#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_NEW 15




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	zvao_new[MAX_PLAYERS], // timestamp poslednjeg poziva
    bool:pCekaNew[MAX_PLAYERS char],

	report_reload[MAX_PLAYERS], // Reload time za prijavu       
	pitanje_reload[MAX_PLAYERS], // Reload time za pitanje
	new_reload[MAX_PLAYERS], // Reload time za new
	
	bool:new_kanal = true // Da li je /n kanal ukljucen ili iskljucen
;



// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit() 
{
    mysql_tquery(SQL, "TRUNCATE pitanja");
	return 1;
}

hook OnPlayerConnect(playerid)
{
    zvao_new[playerid] = 0, pCekaNew{playerid} = false;
    report_reload[playerid] = pitanje_reload[playerid] = new_reload[playerid] = 0; 
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_OnQuestionsLoaded(playerid, ccinc);
public MySQL_OnQuestionsLoaded(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(playerid, "Nema novih pitanja.");

	new string[2000];
	format(string, 32, "ID\tIgrac\tTekst\tOdgovoreno?");
	for__loop (new i = 0; i < rows; i++)
	{
		new id, igrac[MAX_PLAYER_NAME], tekst[25], odg[MAX_PLAYER_NAME], bool:status = false;

		cache_get_value_name_int(i, "id", id);
		cache_get_value_name(i, "igrac", igrac, sizeof igrac);
		cache_get_value_name(i, "tekst", tekst, sizeof tekst);
		cache_get_value_name(i, "odgovorio", odg, sizeof odg);

		if (strcmp(odg, "Niko")) status = true;

		format(string, sizeof string, "%s\n%i\t%s\t%s...\t%s", string, id, igrac, tekst, (status? ("{00FF00}DA") : ("{FF0000}NE")));
	}

	SPD(playerid, "pitanja", DIALOG_STYLE_TABLIST_HEADERS, "Poslednjih 15 pitanja", string, "Odgovori", "Izadji");
	return 1;
}

forward MySQL_AnswerQuestion(playerid, ccinc);
public MySQL_AnswerQuestion(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc)) 
		return 1;

    cache_get_row_count(rows);
	if (rows != 1)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new id, igrac[MAX_PLAYER_NAME], tekst[120], vreme[6], odg[MAX_PLAYER_NAME], bool:status = false;

	cache_get_value_name_int(0, "id", id);
	cache_get_value_name(0, "igrac", igrac, sizeof igrac);
	cache_get_value_name(0, "tekst", tekst, sizeof tekst);
	cache_get_value_name(0, "odgovorio", odg, sizeof odg);
	cache_get_value_name(0, "ts", vreme, sizeof vreme);

	if (strcmp(odg, "Niko")) status = true;

	new string[325];
	format(string, sizeof string, "{FFFFFF}Odgovarate na pitanje #%i igraca {FF9900}%s {FFFFFF}(poslato u %s).\n\n{FF9900}- %s", id, igrac, vreme, tekst);
	
	if (status)
	{
		format(string, sizeof string, "%s\n\n{FFFFFF}*** Na ovo pitanje je vec odgovorio {FFFF00}%s.", string, odg);
	}

	SetPVarString(playerid, "qAnsweringTo", igrac);
	SetPVarInt(playerid, "qAnsweringID", id);
	SPD(playerid, "pitanje_odgovor", DIALOG_STYLE_INPUT, "Odgovor na pitanje", string, "Posalji", "Odustani");
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:pitanje_odgovor(playerid, response, listitem, const inputtext[])
{
	if (!response) 
        return callcmd::pitanja(playerid, "");

	new targetName[MAX_PLAYER_NAME], targetid = INVALID_PLAYER_ID;
	GetPVarString(playerid, "qAnsweringTo", targetName, sizeof targetName);
	targetid = GetPlayerIDFromName(targetName);

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, "Igrac koji je poslao ovo pitanje je napustio server.");

	if (isnull(inputtext))
		return DialogReopen(playerid);

	// Slanje odgovora
	new cmdParams[145];
	format(cmdParams, sizeof cmdParams, "%i %s", targetid, inputtext);
	callcmd::pm(playerid, cmdParams);

	// Belezenje u bazu
	new query[82];
	format(query, sizeof query, "UPDATE pitanja SET odgovorio = '%s' WHERE id = %i", ime_obicno[playerid], GetPVarInt(playerid, "qAnsweringID"));
	mysql_tquery(SQL, query);
	return 1;
}

Dialog:pitanja(playerid, response, listitem, const inputtext[])
{
	if (!IsHelper(playerid, 1))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (response)
	{
		new id = strval(inputtext);
		new query[85];
		format(query, sizeof query, "SELECT *, DATE_FORMAT(timestamp, '\%%H:\%%i') as ts FROM pitanja WHERE id = %i", id);
		mysql_tquery(SQL, query, "MySQL_AnswerQuestion", "ii", playerid, cinc[playerid]);
	}
	return 1;
}

/*

Cheating
Deathmatching
Bug Abusing
Reklamiranje
Meta Gaming
Power Gaming
Spam
Non RP ponasanje
Revenge Killing
Non RP ime
Sledeca strana -

Zahtev za unmute
Problem sa nalogom
Zalba na akciju admina
Razgovor s adminom
Drugo
- Prethodna strana

*/




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:acceptnew("an")
alias:novi("new")
alias:prijava("report", "prijavi", "re")
alias:pitanje("pomoc", "askq")

CMD:prijava(playerid, const params[]) 
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < report_reload[playerid]) 
        return ErrorMsg(playerid, "Vec ste nedavno poslali prijavu. Pokusajte ponovo za %d sekundi.", report_reload[playerid]-gettime());
    
    // Provera parametara
    new 
        tekst[110],
        price = 1500
    ;
    if (sscanf(params, "s[110]", tekst)) 
    {
        Koristite(playerid, "prijava [Tekst prijave]");
        SendClientMessageF(playerid, GRAD2, "* Prijava se naplacuje %s za igrace nivo 8+.", formatMoneyString(price));
        return 1;
    }

    if (PI[playerid][p_nivo] >= 6 && !IsVIP(playerid, 1))
    {
        if (PI[playerid][p_novac] < price)
            return ErrorMsg(playerid, "Nemate dovoljno novca. Prijava se naplacuje %s za igrace nivo 6+.", formatMoneyString(price));

        PlayerMoneySub(playerid, price);
    }
    else price = 0;

    if (strlen(tekst) > 110) 
        return ErrorMsg(playerid, "Tekst prijave je previse dugacak!");
    
    if (!IsVIP(playerid, 3))
	{
    	report_reload[playerid] = gettime() + 120;
    }

    StrToLower(tekst);
    
    // Slanje poruke igracu i staffu
    foreach(new i : Player)
    {
        if ((IsAdmin(i, 1) || PlayerFlagGet(i, FLAG_SPEC_ADMIN)) && IsChatEnabled(i, CHAT_REPORT)) 
        {
        	SendClientMessageF(i, PLAVA, "R | {FF9900}%s[%i, nivo %i]: %s", ime_rp[playerid], playerid, PI[playerid][p_nivo], tekst);
        }
    }
    SendClientMessageF(playerid, BELA, " - %s", tekst);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Vasa prijava je uspesno poslata svim Adminima na serveru (cena: %s).", formatMoneyString(price));

    
    // Upisivanje u log
    format(string_256, sizeof string_256, "PRIJAVA | Igrac: %s | %s", ime_obicno[playerid], tekst);
    Log_Write(LOG_REPORT_POMOC, string_256);
    return 1;
}

CMD:pitanje(playerid, const params[]) 
{
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);

	if (gettime() < pitanje_reload[playerid]) 
		return ErrorMsg(playerid, "Vec ste nedavno poslali pitanje. Pokusajte ponovo za %d sekundi.", pitanje_reload[playerid]-gettime());
	
	// Provera parametara
	new 
		tekst[110],
        price = 500
	;
	if (sscanf(params, "s[110]", tekst)) 
    {
        Koristite(playerid, "pitanje [Tekst pitanja]");
        SendClientMessageF(playerid, GRAD2, "* Upit se naplacuje %s za igrace nivo 6+.", formatMoneyString(price));
        return 1;
    }

    if (PI[playerid][p_nivo] >= 6 && !IsVIP(playerid, 1))
    {
        if (PI[playerid][p_novac] < price)
            return ErrorMsg(playerid, "Nemate dovoljno novca. Upit se naplacuje %s za igrace koji imaju nivo 6+.", formatMoneyString(price));

        PlayerMoneySub(playerid, price);
    }
    else price = 0;

	if (strlen(tekst) > 110) 
        return ErrorMsg(playerid, "Tekst pitanja je previse dugacak!");
	
	if (!IsVIP(playerid, 3))
	{
		pitanje_reload[playerid] = gettime() + 90;
	}

    StrToLower(tekst);
	// Slanje poruke igracu i staffu
	foreach(new i : Player)
    {
        if (IsHelper(i, 1) && IsChatEnabled(i, CHAT_QUESTION)) 
        {
        	SendClientMessageF(i, ZELENOZUTA, "Q | {FF9900}%s[%d, nivo %i]: %s", ime_rp[playerid], playerid, PI[playerid][p_nivo], tekst);
        }
    }
	SendClientMessageF(playerid, BELA, " - %s", tekst);
	SendClientMessageF(playerid, SVETLOPLAVA, "* Vase pitanje je uspesno poslato svim Helperima na serveru (cena: %s).", formatMoneyString(price));

	// Upisivanje u log
	format(string_256, sizeof string_256, "PITANJE | Igrac: %s | %s", ime_obicno[playerid], tekst);
	Log_Write(LOG_REPORT_POMOC, string_256);

	// Upisivanje u bazu
	new query[200];
	mysql_format(SQL, query, sizeof query, "INSERT INTO pitanja (igrac, tekst) VALUES ('%s', '%s')", ime_obicno[playerid], tekst);
	mysql_tquery(SQL, query);
	return 1;
}

flags:pitanja(FLAG_HELPER_1)
CMD:pitanja(playerid, const params[]) 
{
	mysql_tquery(SQL, "SELECT * FROM pitanja ORDER BY timestamp DESC LIMIT 15", "MySQL_OnQuestionsLoaded", "ii", playerid, cinc[playerid]);
	return 1;
}

CMD:novi(playerid, const params[]) 
{
    if (!IsNewPlayer(playerid))
        return ErrorMsg(playerid, "Ova komanda je rezervisana za nove igrace.");

	if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);

	if (zvao_new[playerid] > gettime())
		return ErrorMsg(playerid, "Sacekajte jos %d sekundi pre sledeceg upita!", zvao_new[playerid] - gettime());


	StaffMsg(BELA, "NOVI IGRAC {FFFF00}| POTREBNA POMOC | Igrac: %s[%d] | Nivo: %d | Novac: $%d | Koristite /an", ime_rp[playerid], playerid, PI[playerid][p_nivo], PI[playerid][p_novac]);

	SendClientMessage(playerid, ZUTA, "** Vas poziv za pomoc je poslat game podrsci. Uskoro ce do Vas doci neko od Helpera.");
    zvao_new[playerid] = gettime() + 60;
    pCekaNew{playerid} = true;
	return 1;
}

flags:acceptnew(FLAG_HELPER_1)
CMD:acceptnew(playerid, const params[])
{
    new id;
    if (sscanf(params, "u", id))
        return Koristite(playerid, "/acceptnew [Ime ili ID igraca]");

    if (id == playerid)
        return ErrorMsg(playerid, "Ne mozete prihvatiti svoj poziv.");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!pCekaNew{id})
        return ErrorMsg(playerid, "Taj igrac nije poslao poziv za pomoc.");
    

    StaffMsg(ZUTA, "* Helper %s je prihvatio new od %s.", ime_rp[playerid], ime_rp[id]);

    GameTextForPlayer(id, "~g~Vas poziv za pomoc je prihvacen!", 3500, 3);
    SendClientMessageF(playerid, NARANDZASTA, "Prihvatili ste new. Koristite {FFFFFF}/idido %d {FF9900}da se teleportujete do igraca.", id);
    pCekaNew{id} = false;
    return 1;
}

flags:ntog(FLAG_ADMIN_6)
CMD:ntog(playerid)
{
	new_kanal = new_kanal? false : true;
			
	format(string_64, 64, "/n kanal je sada %s.", (new_kanal)?("ukljucen"):("iskljucen"));
	SendClientMessage(playerid, SVETLOCRVENA, string_64);
	return 1;
}

CMD:n(playerid, const params[145]) 
{
	if (!new_kanal)
		return ErrorMsg(playerid, "/n kanal je privremeno iskljucen za sve igrace. Koristite {FF9900}/pitanje.");
	
	if (!IsChatEnabled(playerid, CHAT_NEW))
        return ErrorMsg(playerid, "Iskljucili ste /n kanal. Koristite /chat da ga ponovo ukljucite.");
	
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);
		
	if (gettime() < koristio_chat[playerid]) 
		return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
		
	if (isnull(params)) 
		return Koristite(playerid, "n [Tekst]");
	 
	koristio_chat[playerid] = gettime() + 3;

	
    // Formatiranje poruke
    zastiti_chat(playerid, params);
    new chat_string[145];
	if (PI[playerid][p_nivo] <= 4)
		format(chat_string, sizeof chat_string, "NOVI | %s[%d] (nivo %d): {FFFFFF}%s", ime_rp[playerid], playerid, PI[playerid][p_nivo], params);
	else 
    {
		if (PI[playerid][p_helper] > 0)
			format(chat_string, sizeof chat_string, "NOVI | HELPER | %s: {FFFFFF}%s", ime_rp[playerid], params);
		else if (PI[playerid][p_admin] > 0)
			format(chat_string, sizeof chat_string, "NOVI | ADMIN | %s: {FFFFFF}%s", ime_rp[playerid], params);
		else if (PI[playerid][p_nivo] > 4)
			format(chat_string, sizeof chat_string, "NOVI | IGRAC | %s: {FFFFFF}%s", ime_rp[playerid], params);
	}
	
    // Slanje poruke
	foreach(new i : Player) 
    {
		if (IsChatEnabled(i, CHAT_NEW) && IsPlayerLoggedIn(i))
			SendClientMessage(i, NARANDZASTA, chat_string);
	}
	
    // Upisivanje u log
	format(chat_string, sizeof chat_string, "%s[%d]: %s", ime_obicno[playerid], PI[playerid][p_nivo], params);
	Log_Write(LOG_CHAT_NEW, chat_string);
	return 1;
}