#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PHONE_SMS_RELOAD 	10 // na koliko sekundi moze igrac da salje sms?
#define PHONE_SMS_PRICE		2 // cena jednog sms-a
#define PHONE_CALL_PRICE	4 // cena poziva na svakih 30 (zapocetih) sekundi




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	phone_sms_reload[MAX_PLAYERS],
	phone_speaking_with[MAX_PLAYERS], // ID igraca sa kojim igrac razgovara (a.k.a da li je poziv aktivan)
	phone_call_to[MAX_PLAYERS], // Koga je igrac pozvao
	phone_call_from[MAX_PLAYERS], // Od koga je igrac dobio poziv
	phone_call_start[MAX_PLAYERS], // Unix timestamp - trenutak kada je poziv uspostavljen
	phone_call_spent[MAX_PLAYERS], // Koliko kredita je igrac potrosio dok je obavljao poziv
	tajmer:phone_check_pickup[MAX_PLAYERS], // Tajmer koji poziva funkciju ukoliko ne dodje do uspostavljanja poziva
	tajmer:phone_call_tick[MAX_PLAYERS],

    bool:phone_on[MAX_PLAYERS char]
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid) 
{
	
	// Resetovanje promenljivih
	phone_resetuj_promenljive(playerid);
    phone_on{playerid} = true;
	
	return 1;
}

hook OnPlayerDisconnect(playerid) 
{
	
	// Da li poziva nekoga?
	if (phone_speaking_with[playerid] == -1 && phone_call_to[playerid] != -1) 
    {
		KillTimer(tajmer:phone_check_pickup[playerid]), tajmer:phone_check_pickup[playerid] = 0;
		phone_call_from[phone_call_to[playerid]] = -1;
		
		// TODO: ako bude zvukova zvonjave -> iskljuciti
		// Da li je potrebna poruka da telefon vise ne zvoni?
	}
	
	// Da li neko poziva njega?
	if (phone_speaking_with[playerid] == -1 && phone_call_from[playerid] != -1) 
    {
		KillTimer(tajmer:phone_check_pickup[phone_call_from[playerid]]), tajmer:phone_check_pickup[phone_call_from[playerid]] = 0;
		phone_call_to[phone_call_from[playerid]] = -1;
	}
	
	// Da li sa nekime razgovara?
	if (phone_speaking_with[playerid] != -1) 
    {
		//phone_call_msg(playerid, "Veza se prekinula.");
		
		// Ubija tajmere za oba igraca, iako je jedan od njih najverovatnije jednak nuli, pa KillTimer na njega nema efekta
		KillTimer(tajmer:phone_call_tick[playerid]), tajmer:phone_call_tick[playerid] = 0;
		KillTimer(tajmer:phone_call_tick[phone_speaking_with[playerid]]), tajmer:phone_call_tick[phone_speaking_with[playerid]] = 0;
		
		
		phone_resetuj_promenljive(phone_speaking_with[playerid]);
		return 1;
	}
	
	return 1;
}

hook OnPlayerText(playerid, text[]) 
{
	if (phone_speaking_with[playerid] != -1) 
    {
		new 
			speakingwith = phone_speaking_with[playerid],
			speakingwith_imenik = BP_PlayerHasItem(playerid, ITEM_IMENIK)
		;
		
		format(string_128, sizeof string_128, "%s: {FFFFFF}%s", (speakingwith_imenik?(ime_rp[playerid]):("Sagovornik")), text);
		phone_call_msg(speakingwith, string_128);
		
		format(string_128, sizeof string_128, "(mobilni) %s: %s", ime_rp[playerid], text);
		RangeMsg(playerid, string_128, BELA, 20.0);
		
		return ~0;
	}
	
	return 0;
}





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward phone_resetuj_promenljive(playerid);
forward phone_call_msg(playerid, const string[]);
forward phone_format(playerid, string[]);
// forward phone_format2(const pozivni_broj[4], const broj_telefona[7], string[]);
forward oduzmi_kredit(playerid, iznos);
forward phone_check_pickup(playerid);
forward phone_call_tick(callerid, caller_ccinc, playerid, player_ccinc);
forward phone_animation(playerid, bool:status);

public phone_resetuj_promenljive(playerid) 
{
	phone_speaking_with[playerid] 	= phone_call_to[playerid] 		= phone_call_from[playerid] 	= -1;
	phone_call_start[playerid] 		= phone_call_spent[playerid] 	= phone_sms_reload[playerid] 	= 0;
	tajmer:phone_check_pickup[playerid] = tajmer:phone_call_tick[playerid] = 0;
	
	return 1;
}

stock igrac_ima_mobilni(playerid) 
{
	if (!strcmp(PI[playerid][p_mobilni], "N/A")) return 0;
	
	return 1;
}

stock igrac_ima_sim(playerid) 
{
	if (!strcmp(PI[playerid][p_sim], "N/A")) return 0;
	
	return 1;
}

public phone_call_msg(playerid, const string[]) 
{
	SendClientMessageF(playerid, ZUTA, "(poziv) {F1A3A4}%s", string);
	return 1;
}

public phone_format(playerid, string[]) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("phone_format");
    }

    if (PI[playerid][p_sim_broj] == 0) 
    {
        format(string, 4, "N/A"); // Nema telefon
    }
	else 
    {
        new
            pozivni_broj[4],
            number[8];

    	if (!strcmp(PI[playerid][p_sim], "Telenor")) 		pozivni_broj = "063";
    	else if (!strcmp(PI[playerid][p_sim], "m:tel")) 	pozivni_broj = "065";
    	else if (!strcmp(PI[playerid][p_sim], "T-Mobile"))	pozivni_broj = "098";
    	format(number, sizeof(number), "%d", PI[playerid][p_sim_broj]);
    	strins(number, "-", 3);
    	format(string, 12, "%s/%s", pozivni_broj, number);
	}
	return 1;
}

// Isto kao phone_format, samo sto se umesto playerid prosledjuje pozivni broj i sestocifreni broj bez srednje crte
// Npr. 063 i 123456
// public phone_format2(const pozivni_broj[4], const broj_telefona[7], string[]) 
// {
//     #if defined DEBUG_FUNCTIONS
//         Debug("function", "phone_format2");
//     #endif

//     if (PI[playerid][p_sim_broj] == 0) 
// {
//         format(string, 4, "N/A"); // Nema telefon
//     }
//     else {    
//     	new number[8];
    	
//     	format(number, sizeof(number), "%s", broj_telefona);
//     	strins(number, "-", 3);
//     	format(string, 12, "%s/%s", pozivni_broj, number);
// 	}
// 	return 1;
// }

public oduzmi_kredit(playerid, iznos) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("oduzmi_kredit");
    }

        
	PI[playerid][p_sim_kredit] -= iznos;
	
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET sim_kredit = %d WHERE id = %d", PI[playerid][p_sim_kredit], PI[playerid][p_id]);
	mysql_pquery(SQL, mysql_upit);
	
	return 1;
}

public phone_check_pickup(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("phone_check_pickup");
    }


    tajmer:phone_check_pickup[playerid] = 0;
        
	// Posto se ova funkcija pozvala, znaci da se druga strana nije javila na telefon
	if(phone_call_to[playerid] == -1)
    {
        phone_resetuj_promenljive(playerid);
        return 1;
    }
	
	phone_resetuj_promenljive(phone_call_to[playerid]);
	phone_resetuj_promenljive(playerid);


    phone_call_msg(playerid, "Igrac koga ste pozvali se nije javio na mobilni.");
	return 1;
}

public phone_call_tick(callerid, caller_ccinc, playerid, player_ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("phone_call_tick");
    }


    if (!checkcinc(callerid, caller_ccinc) || !checkcinc(playerid, player_ccinc))
    {
        KillTimer(tajmer:phone_call_tick[playerid]), tajmer:phone_call_tick[playerid] = 0;
        return 1;
    }
        
	if (!IsPlayerConnected(phone_call_to[callerid]) || !IsPlayerConnected(phone_speaking_with[callerid])) 
    {
		// Igrac sa kojim razgovara je otisao offline
	
		phone_call_msg(callerid, "Veza se prekinula.");
		
		// Ubija tajmere za oba igraca, iako je jedan od njih najverovatnije jednak nuli, pa KillTimer na njega nema efekta
		KillTimer(tajmer:phone_call_tick[callerid]), tajmer:phone_call_tick[callerid] = 0;
        if (phone_speaking_with[callerid] != -1)
        {
    		KillTimer(tajmer:phone_call_tick[phone_speaking_with[callerid]]), tajmer:phone_call_tick[phone_speaking_with[callerid]] = 0;
        }
		
		phone_resetuj_promenljive(callerid);
		
		return 1;
	}
	
	if (phone_speaking_with[callerid] != -1 && phone_speaking_with[phone_speaking_with[callerid]] == callerid) 
    {
		// Da li igrac prica za nekim?      &&   Da li igrac sa druge strane prica sa ovim igracem?
		
	
		if (PI[callerid][p_sim_kredit] < PHONE_CALL_PRICE) 
        {
			
			phone_call_msg(callerid, "Nemate dovoljno kredita da nastavite poziv.");
			SendClientMessageF(callerid, ZUTA, "    Trajanje poziva: {F5DEB3}%s {FFFF00} | Potroseno kredita: {F5DEB3}$%d", konvertuj_vreme(gettime() - phone_call_start[callerid]), phone_call_spent[callerid]);
			
			format(string_128, sizeof string_128, "Veza se prekinula. (trajanje poziva: %s)", konvertuj_vreme(gettime() - phone_call_start[callerid]));
			phone_call_msg(phone_speaking_with[callerid], string_128);
			
			KillTimer(tajmer:phone_call_tick[callerid]), tajmer:phone_call_tick[callerid] = 0;
			KillTimer(tajmer:phone_call_tick[phone_speaking_with[callerid]]), tajmer:phone_call_tick[phone_speaking_with[callerid]] = 0;
			
			phone_resetuj_promenljive(phone_speaking_with[callerid]);
			phone_resetuj_promenljive(callerid);
		
			return 1;
		}
	
		oduzmi_kredit(callerid, PHONE_CALL_PRICE);
		phone_call_spent[callerid] += PHONE_CALL_PRICE;
	}
	else 
    {
	
		//phone_call_msg(callerid, "Veza se prekinula.");
		
		// Ubija tajmere za oba igraca, iako je jedan od njih najverovatnije jednak nuli, pa KillTimer na njega nema efekta
		KillTimer(tajmer:phone_call_tick[callerid]), tajmer:phone_call_tick[callerid] = 0;

		if (phone_speaking_with[callerid] != -1)
		{
			KillTimer(tajmer:phone_call_tick[phone_speaking_with[callerid]]), tajmer:phone_call_tick[phone_speaking_with[callerid]] = 0;
		}
		
		phone_resetuj_promenljive(callerid);
		
		return 1;
		
	}
	
	return 1;
}

public phone_animation(playerid, bool:status) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("phone_animation");
    }

        
	if(status == false) 
    { //sakrij
 		if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);
     	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
	else if(status == true) 
    { //prikazi
 		if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	    SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6); // SLOT_PHONE = attachment slot, 330 = cellphone model, 6 = right hand
	}
	
	return 1;
}

stock PhoneCallActive(playerid) 
{
    if (phone_speaking_with[playerid] != -1) return true;
    return false;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:phone_choose_sim(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return DialogReopen(playerid);

    switch (listitem)
    {
        case 0: // Telenor
        {
            strmid(PI[playerid][p_sim], "Telenor", 0, strlen("Telenor"), 11);
        }
        case 1: // m:tel
        {
            strmid(PI[playerid][p_sim], "m:tel", 0, strlen("m:tel"), 11);
        }
        case 2: // T-Mobile
        {
            strmid(PI[playerid][p_sim], "T-Mobile", 0, strlen("T-Mobile"), 11);
        }
    }

    PI[playerid][p_sim_broj] = 100000 + random(899999);
    PI[playerid][p_sim_kredit] = 100;
    new tel[12];
    phone_format(playerid, tel);
    InfoMsg(playerid, "Broj telefona koji ste dobili: {FFFF00}%s   {FFFFFF}Kredit: {FFFF00}$100", tel);

    // Cuvanje podataka u bazu
    new query[112];
    format(query, sizeof query, "UPDATE igraci SET mobilni = '%s', sim = '%s', sim_broj = %d, sim_kredit = %d WHERE id = %d", PI[playerid][p_mobilni], PI[playerid][p_sim], PI[playerid][p_sim_broj], PI[playerid][p_sim_kredit], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

Dialog:mobilni(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0) // Poziv
    {
        SPD(playerid, "mobilni_call", DIALOG_STYLE_INPUT, "Mobilni -> Poziv", "{FFFFFF}Unesite broj telefona koji zelite da pozovete:", "Pozovi", "Nazad");
    }

    else if (listitem == 1) // SMS
    {
        return PC_EmulateCommand(playerid, "/sms");
    }

    else if (listitem == 2) // Imenik
    {
        SPD(playerid, "mobilni_broj", DIALOG_STYLE_INPUT, "Mobilni -> Imenik", "{FFFFFF}Unesite ime ili ID igraca ciji broj zelite da saznate:", "Pronadji", "Nazad");
    }

    else if (listitem == 3) // Ukljuci/iskljuci
    {
        phone_on{playerid} = !phone_on{playerid};
        SendClientMessageF(playerid, BELA, "Vas mobilni telefon je sada %s.", (phone_on{playerid}? ("{00FF00}ukljucen"):("{FF0000}iskljucen")));
    }

    else if (listitem == 4) // Baci mobilni
    {
        strmid(PI[playerid][p_mobilni], "N/A", 0, strlen("N/A"), 13);
        strmid(PI[playerid][p_sim], "N/A", 0, strlen("N/A"), 11);
        PI[playerid][p_sim_broj] = 0;
        PI[playerid][p_sim_kredit] = 0;

        new query[100];
        format(query, sizeof query, "UPDATE igraci SET mobilni = 'N/A', sim = 'N/A', sim_broj = 0, sim_kredit = 0 WHERE id = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        new string[64];
        format(string, sizeof string, "* %s baca svoj mobilni telefon.", ime_rp[playerid]);
        RangeMsg(playerid, string, LJUBICASTA, 25.0);
    }

    return 1;
}

Dialog:mobilni_call(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (isnull(inputtext))
        return DialogReopen(playerid);

    return PC_EmulateCommandEx(playerid, "/pozovi", inputtext);
}

Dialog:mobilni_broj(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (isnull(inputtext))
        return DialogReopen(playerid);

    return PC_EmulateCommandEx(playerid, "/broj", inputtext);
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:pozovi("call")
alias:broj("number", "imenik")
alias:prekini("hangup")
alias:mobilni("telefon")

CMD:pozovi(playerid, const params[]) 
{
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);

    if (PI[playerid][p_zatvoren] > 0 || PI[playerid][p_area] > 0)
        return overwatch_poruka(playerid, "Ne mozete koristiti ovu komandu dok ste zatvoreni.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");
	
	if (gettime() < koristio_chat[playerid]) 
		return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
	
	if (!igrac_ima_mobilni(playerid)) 
    {
		ErrorMsg(playerid, "Ne posedujete mobilni telefon. Kupite ga u prodavnici tehnike.");
		SetGPSLocation(playerid, 1833.0729, -1435.5862, 13.6016, "prodavnica tehnike"); 
		return 1;
	}
	
	if (!igrac_ima_sim(playerid)) 
    {
        ErrorMsg(playerid, "Ne posedujete SIM karticu. Kupite je u prodavnici tehnike.");
        SetGPSLocation(playerid, 1833.0729, -1435.5862, 13.6016, "prodavnica tehnike"); 
        return 1;
    }

    if (isnull(params) || strlen(params) < 4)
    {
        Koristite(playerid, "pozovi [Broj telefona]");
        SendClientMessage(playerid, GRAD2, "Specijalni brojevi: [mehanicar]");
        return 1;
    }
	
	if (PI[playerid][p_sim_kredit] < PHONE_CALL_PRICE)
		return ErrorMsg(playerid, "Nemate dovoljno kredita. Dopunu mozete kupiti u bilo kojoj prodavnici ili kiosku.");
	
	if (phone_call_to[playerid] != -1 || phone_call_from[playerid] != -1 || GetPVarInt(playerid, "timer_deliveryCall") != 0)
		return ErrorMsg(playerid, "Vec razgovarate mobilnim telefonom. Koristite /prekini da prekinete razgovor.");

    if (!strcmp(params, "mehanicar", true) || !strcmp(params, "mehanicara", true))
        return PC_EmulateCommand(playerid, "/pozovimehanicara");

    if (!strcmp(params, "taxi", true) || !strcmp(params, "taksi", true))
        return PC_EmulateCommand(playerid, "/pozovitaxi");

    if (!strcmp(params, "069/666-999") || !strcmp(params, "069666999"))
        return PC_EmulateCommand(playerid, "/weapondelivery1");

    if (!phone_on{playerid})
        return ErrorMsg(playerid, "Vas mobilni telefon je iskljucen.");
	
	
	new 
		broj_telefona = -1,
		broj_telefona_str[8],
		pozivni_broj[4],
		mreza[11],
		targetid = -1 // Id igraca koji se poziva
	;
	
	if (sscanf(params, "p</>s[4]s[8]", pozivni_broj, broj_telefona_str)) 
    {
        // Broj koji je uneo nema crtice (npr. 063123456 ili nesto peto)

        pozivni_broj[0] = params[0];
        pozivni_broj[1] = params[1];
        pozivni_broj[2] = params[2];

        new tel[12];
        format(tel, sizeof tel, "%s", params);
        strdel(tel, 0, 3);
        broj_telefona = strval(tel);
    }
    else {
        // Formiranje broja telefona (brisanje srednje crte)
        strdel(broj_telefona_str, 3, 4);
        broj_telefona = strval(broj_telefona_str);
        
        // Da li je uneo dobar pozivni broj?
        if (!strcmp(pozivni_broj, "063"))       mreza = "Telenor";
        else if (!strcmp(pozivni_broj, "065"))  mreza = "m:tel";
        else if (!strcmp(pozivni_broj, "098"))  mreza = "T-Mobile";
        else return ErrorMsg(playerid, "Uneli ste nepostojeci pozivni broj. Koristite 063, 065 ili 098.");
    }
	
	// Da li je broj telefona sestocifren?
	if (broj_telefona < 1000 || broj_telefona > 999999)
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");
	
	// 0 je default vrednost za p_sim_broj, pa je bolje da se to ne proverava u foreach petlji, ako se nekim slucajem dogodi
	if (broj_telefona == 0)
		return ErrorMsg(playerid, "[phone.pwn] "GRESKA_NEPOZNATO" (01)");
	
	foreach (new i : Player) 
    {
		// Provera svih igraca za njihovu mrezu i broj telefona
		if (!strcmp(PI[i][p_sim], mreza) && PI[i][p_sim_broj] == broj_telefona) 
        {
            targetid = i;
            break;
        }
	}
	if (targetid == -1)
		return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona. (02)");

    if (playerid == targetid)
        return ErrorMsg(playerid, "Ne mozete da pozovete sami sebe.");
	
	if (phone_call_from[targetid] != -1 || phone_call_to[targetid] != -1 || phone_speaking_with[targetid] != -1 || phone_speaking_with[playerid] != -1)
		return ErrorMsg(playerid, "Linija je zauzeta, pokusajte malo kasnije ili posaljite SMS poruku.");

    if (!phone_on{targetid} || IsOnDuty(targetid))
        return ErrorMsg(playerid, "Mobilni pretplatnik je trenutno nedostupan.");
	
	
	koristio_chat[playerid] = gettime() + 3;
	//oduzmi_kredit(playerid, PHONE_CALL_PRICE);
	//phone_call_spent[playerid] = PHONE_CALL_PRICE;
	phone_call_from[targetid] = playerid;
	phone_call_from[playerid] = -1;
	phone_call_to[playerid] = targetid;
	phone_call_to[targetid] = -1;
	
	phone_animation(playerid, true);
	
	new 
		imenik_target = BP_PlayerHasItem(targetid, ITEM_IMENIK),
		caller_name[MAX_PLAYER_NAME+6],
		caller_phone[12] // telefon pozivaoca (formatiran)
	;
	
	// Formatiranje broja telefona pozivaoca
	phone_format(playerid, caller_phone);
	
	if (imenik_target) 
		// Igrac koji prima poziv ima tel. imenik, pa mu mozemo prikazati ime igraca koji mu salje SMS
		format(caller_name, sizeof(caller_name), " (%s).", ime_rp[playerid]);
	else caller_name = "."; // samo tacka na kraju recenice, bez informacija o imenu pozivaoca
	
	format(string_128, sizeof string_128, "Poziv sa  broja: {F5DEB3}%s%s {FFFFFF}Da se javite upisite /javise. Da odbijete poziv, upisite /odbij.", caller_phone, caller_name);
	phone_call_msg(targetid, string_128);
    format(string_64, 64, "** Mobilni od %s zvoni.", ime_rp[targetid]);
    RangeMsg(targetid, string_64, LJUBICASTA, 10.0);
    format(string_64, 64, "** %s vadi mobilni telefon.", ime_rp[playerid]);
    RangeMsg(playerid, string_64, LJUBICASTA, 10.0);
	

    KillTimer(tajmer:phone_check_pickup[playerid]), tajmer:phone_check_pickup[playerid] = 0;
	tajmer:phone_check_pickup[playerid] = SetTimerEx("phone_check_pickup", 20*1000, false, "i", playerid);
	
	/*
		TODO: ubaciti neke zvukove
		npr ringtone za targetid, i ono piiiiip, piiiiip za playerid (kao cekanje na uspostavu poziva) 
	*/
	
	return 1;
}

CMD:javise(playerid, const params[]) 
{
	// TODO: Omoguciti da se koristi "/prihvati poziv"
	
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);
	
	if (!igrac_ima_mobilni(playerid))
		return ErrorMsg(playerid, "Ne posedujete mobilni telefon.");
	
	if (!igrac_ima_sim(playerid))
		return ErrorMsg(playerid, "Ne posedujete SIM karticu.");
	
	if (phone_call_from[playerid] == -1) 
		return ErrorMsg(playerid, "Ne zvoni Vam mobilni.");
	
	if (phone_speaking_with[playerid] != -1)
		return ErrorMsg(playerid, "Vec razgovarate telefonom.");
	
	if (phone_call_to[playerid] != -1)
		return ErrorMsg(playerid, "Ne zvoni Vam mobilni.");
	
	new callerid = phone_call_from[playerid];
	
	phone_speaking_with[playerid] = callerid;
	phone_speaking_with[callerid] = playerid;
	
	oduzmi_kredit(callerid, PHONE_CALL_PRICE);
	phone_call_spent[callerid] = PHONE_CALL_PRICE;
	phone_call_start[callerid] = phone_call_start[playerid] = gettime();
	
	phone_animation(playerid, true);
	
	phone_call_msg(playerid, "Veza je uspesno uspostavljena. Koristite tipku {F1A3A4}T {FFFFFF}za razgovor. Kada zavrsite upisite {F1A3A4}/prekini.");
	phone_call_msg(callerid, "Veza je uspesno uspostavljena. Koristite tipku {F1A3A4}T {FFFFFF}za razgovor. Kada zavrsite upisite {F1A3A4}/prekini.");
	SendClientMessage(callerid, BELA, " * Razgovor ce Vas kostati {F1A3A4}$"#PHONE_CALL_PRICE" {FFFFFF}za svakih zapocetih {F1A3A4}30 sekundi.");
	
	KillTimer(tajmer:phone_check_pickup[callerid]), tajmer:phone_check_pickup[callerid] = 0;
    KillTimer(tajmer:phone_call_tick[callerid]), tajmer:phone_call_tick[callerid] = 0;
    KillTimer(tajmer:phone_call_tick[playerid]), tajmer:phone_call_tick[playerid] = 0;
	tajmer:phone_call_tick[playerid] = SetTimerEx("phone_call_tick", 30*1000, true, "iiii", callerid, cinc[callerid], playerid, cinc[playerid]);
	
	return 1;
}

CMD:prekini(playerid, const params[]) 
{
	// TODO: Ako prekine poziv pre nego sto je on uspostavljen, treba ubiti tajmer za pickup
	
	if (!igrac_ima_mobilni(playerid))
		return ErrorMsg(playerid, "Ne posedujete mobilni telefon.");
	
	if (!igrac_ima_sim(playerid))
		return ErrorMsg(playerid, "Ne posedujete SIM karticu.");
	
	if (phone_speaking_with[playerid] == -1)
		return ErrorMsg(playerid, "Nemate aktivan telefonski poziv.");
	
	new 
		callerid = -1, // Id igraca koji je zapoceo poziv
		speakingwith = phone_speaking_with[playerid] // id igraca sa kojim razgovara
	; 
	
	// Potrebno je odrediti ko je pozivalac kako bi mu se ispisala ukupna cena poziva
	if (phone_call_from[playerid] == -1) callerid = playerid;
	else callerid = speakingwith;
	
	phone_call_msg(playerid, "Prekinuli ste poziv.");
	phone_call_msg(speakingwith, "Sagovornik je prekinuo poziv.");
	
	SendClientMessageF(callerid, ZUTA, "  Trajanje poziva: {F5DEB3}%s {FFFF00} | Potroseno kredita: {F5DEB3}$%d", konvertuj_vreme(gettime() - phone_call_start[callerid]), phone_call_spent[callerid]);
	
	KillTimer(tajmer:phone_call_tick[callerid]), tajmer:phone_call_tick[callerid] = 0;
	phone_resetuj_promenljive(speakingwith);
	phone_resetuj_promenljive(playerid);

    phone_animation(playerid, false);
    phone_animation(speakingwith, false);
	//
	ClearAnimations(playerid, 1);
	ClearAnimations(speakingwith, 1);

    // factions\delivery.pwn
    new timerid = GetPVarInt(playerid, "timer_deliveryCall");
    DeletePVar(playerid, "timer_deliveryCall");
    KillTimer(timerid);
	return 1;
}

CMD:odbij(playerid, const params[]) 
{	
	if (!igrac_ima_mobilni(playerid))
		return ErrorMsg(playerid, "Ne posedujete mobilni telefon.");
	
	if (!igrac_ima_sim(playerid))
		return ErrorMsg(playerid, "Ne posedujete SIM karticu.");
	
	if (phone_call_from[playerid] == -1) 
		return ErrorMsg(playerid, "Ne zvoni Vam mobilni.");
	
	if (phone_speaking_with[playerid] != -1)
		return ErrorMsg(playerid, "Vec razgovarate telefonom. Koristite /prekini.");
	
	if (phone_call_to[playerid] != -1)
		return ErrorMsg(playerid, "Ne zvoni Vam mobilni.");
	
	new callerid = phone_call_from[playerid];
	
	KillTimer(tajmer:phone_check_pickup[callerid]);
	phone_resetuj_promenljive(callerid);
	phone_resetuj_promenljive(playerid);

    phone_animation(playerid, false);
    phone_animation(callerid, false);
	
	phone_call_msg(playerid, "Odbili ste dolazni poziv.");
	phone_call_msg(callerid, "Druga strana je odbila Vas poziv.");
	
	return 1;
}

CMD:sms(playerid, const params[]) 
{
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);

    if (PI[playerid][p_area] > 0)
        return overwatch_poruka(playerid, "Ne mozete koristiti SMS dok ste zatvoreni.");
	
	if (gettime() < koristio_chat[playerid]) 
		return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
	
	if (gettime() < phone_sms_reload[playerid])
		return overwatch_poruka(playerid, "SMS mozete slati na svakih "#PHONE_SMS_RELOAD" sekundi.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");
	
    if (!igrac_ima_mobilni(playerid)) 
    {
        ErrorMsg(playerid, "Ne posedujete mobilni telefon. Kupite ga u prodavnici tehnike.");
        SetGPSLocation(playerid, 1833.0729, -1435.5862, 13.6016, "prodavnica tehnike"); 
        return 1;
    }
    
    if (!igrac_ima_sim(playerid)) 
    {
        ErrorMsg(playerid, "Ne posedujete SIM karticu. Kupite je u prodavnici tehnike.");
        SetGPSLocation(playerid, 1833.0729, -1435.5862, 13.6016, "prodavnica tehnike"); 
        return 1;
    }
	
	if (PI[playerid][p_sim_kredit] < PHONE_SMS_PRICE)
		return ErrorMsg(playerid, "Nemate dovoljno kredita. Dopunu mozete kupiti u bilo kojoj prodavnici ili kiosku.");

    if (!phone_on{playerid})
        return ErrorMsg(playerid, "Vas mobilni telefon je iskljucen.");
	
	
	new 
		broj_telefona_str[12],
		broj_telefona = -1,
		tekst[100],
		pozivni_broj[4],
		mreza[11],
		targetid = -1,
		target_phone[12] // broj telefona na koji se salje sms
	;
	
	if (sscanf(params, "p< >s[12]s[100]", broj_telefona_str, tekst)) 
		return Koristite(playerid, "sms [Broj telefona] [Tekst]");
	
	if (sscanf(broj_telefona_str, "p</>s[4]s[8]", pozivni_broj, broj_telefona_str)) 
    {
        // Broj koji je uneo nema crtice (npr. 063123456 ili nesto peto)

        pozivni_broj[0] = broj_telefona_str[0];
        pozivni_broj[1] = broj_telefona_str[1];
        pozivni_broj[2] = broj_telefona_str[2];
        strdel(broj_telefona_str, 0, 3);
        broj_telefona = strval(broj_telefona_str);
	}
    else 
    {
    	// Formiranje broja telefona (brisanje srednje crte)
    	strdel(broj_telefona_str, 3, 4);
    	broj_telefona = strval(broj_telefona_str);
    	
    	// Da li je uneo dobar pozivni broj?
    	if (!strcmp(pozivni_broj, "063")) 		mreza = "Telenor";
    	else if (!strcmp(pozivni_broj, "065")) 	mreza = "m:tel";
    	else if (!strcmp(pozivni_broj, "098")) 	mreza = "T-Mobile";
    	else return ErrorMsg(playerid, "Uneli ste nepostojeci pozivni broj. Koristite 063, 065 ili 098.");
    }

	
	// Da li je broj telefona sestocifren?
	if (broj_telefona < 1000 || broj_telefona > 999999)
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");
	
	// 0 je default vrednost za p_sim_broj, pa je bolje da se to ne proverava u foreach petlji, ako se nekim slucajem dogodi
	if (broj_telefona == 0)
		return ErrorMsg(playerid, "[phone.pwn] "GRESKA_NEPOZNATO" (02)");
	
	foreach (new i : Player) 
    {
		// Provera svih igraca za njihovu mrezu i broj telefona
		if (!strcmp(PI[i][p_sim], mreza) && PI[i][p_sim_broj] == broj_telefona) 
        {
            targetid = i;
            break;
        }
	}
	if (targetid == -1)
		return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");

    if (!phone_on{targetid})
        return ErrorMsg(playerid, "Mobilni pretplatnik je trenutno nedostupan.");
	
	
	koristio_chat[playerid] = gettime() + 3;
	phone_sms_reload[playerid] = gettime() + PHONE_SMS_RELOAD;
	oduzmi_kredit(playerid, PHONE_SMS_PRICE);
	
	new 
		imenik_sender = BP_PlayerHasItem(playerid, ITEM_IMENIK),
		imenik_target = BP_PlayerHasItem(targetid, ITEM_IMENIK),
		sender_name[MAX_PLAYER_NAME+6],
		target_name[MAX_PLAYER_NAME+6],
		sender_phone[12] // telefon posiljaoca (formatiran)
	;
	
	
	// Formatiranje broja telefona posiljaoca
    phone_format(playerid, sender_phone);
	phone_format(targetid, target_phone);
	
	if (imenik_target) 
		// Igrac koji prima poruku ima tel. imenik, pa mu mozemo prikazati ime igraca koji mu salje SMS
		format(sender_name, sizeof(sender_name), " (%s).", ime_rp[playerid]);
	else sender_name = "."; // samo tacka na kraju recenice, bez informacija o imenu posiljaoca
	
	if (imenik_sender) 
		// Igrac koji salje poruku ima tel. imenik, pa mu mozemo prikazati ime igraca kome je poslao SMS
		format(target_name, sizeof(target_name), " (%s).", ime_rp[targetid]);
	else target_name = "."; // samo tacka na kraju recenice, bez informacija o imenu posiljaoca
	
	// Poruka igracu koji prima SMS
	SendClientMessageF(targetid, ZUTA, "(sms) {FFFFFF}Primili ste novu poruku sa broja {F5DEB3}%s%s.", sender_phone, sender_name);
	SendClientMessageF(targetid, ZUTA, " * Poruka: {FFFFFF}%s", tekst);
	
	// Poruka igracu koji salje SMS
	format(string_128, sizeof string_128, "* Vasa SMS poruka je uspesno dostavljena na broj {F5DEB3}%s%s.", target_phone, target_name);
	SendClientMessage(playerid, BELA, string_128);
	
	// Poruka adminima i okruzenju
	foreach (new i : Player)
	{
		if (IsAdmin(i, 1) && IsChatEnabled(i, CHAT_SMSADMIN))
		{
			SendClientMessageF(i, SVETLOZELENA, "SMS | %s[%d] > %s[%d]: %s", ime_rp[playerid], playerid, ime_rp[targetid], targetid, tekst);
		}
	}
 	format(string_64, 64, "** %s salje SMS poruku.", ime_rp[playerid]);
	RangeMsg(playerid, string_64, LJUBICASTA, 10.0);
	
    new logStr[150];
	format(logStr, sizeof(logStr), "%s > %s: %s", ime_obicno[playerid], ime_obicno[targetid], tekst);
	Log_Write(LOG_SMS, logStr);
	
	return 1;
}

CMD:broj(playerid, const params[]) 
{
    if (!BP_PlayerHasItem(playerid, ITEM_IMENIK))
        return ErrorMsg(playerid, "Ne posedujete telefonski imenik.");

    new 
		id,
		pozivni_broj[4],
		broj[8],
		telefon[12]
	;
	
    if (sscanf(params, "u", id)) 
		return Koristite(playerid, "broj [Ime ili ID igraca]");
	
    if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, "Taj igrac je offline.");
	
	if (PI[id][p_sim_broj] == 0)
		return ErrorMsg(playerid, "U telefonskom imeniku nema nikoga pod tim imenom.");
	
	// Formatiranje broja telefona
	if (!strcmp(PI[id][p_sim], "Telenor")) 			pozivni_broj = "063";
	else if (!strcmp(PI[id][p_sim], "m:tel")) 		pozivni_broj = "065";
	else if (!strcmp(PI[id][p_sim], "T-Mobile"))	pozivni_broj = "098";
	else return ErrorMsg(playerid, "U telefonskom imeniku nema nikoga pod tim imenom.");
	format(broj, sizeof(broj), "%d", PI[id][p_sim_broj]);
	strins(broj, "-", 3);
	format(telefon, sizeof(telefon), "%s/%s", pozivni_broj, broj);
	
	SendClientMessageF(playerid, GRAD2, "* Ime: %s | Telefon: %s", ime_rp[id], telefon);
 	format(string_64, 64, "** %s gleda telefonski imenik.", ime_rp[playerid]);
 	RangeMsg(playerid, string_64, LJUBICASTA, 10.0);
    return 1;
}

CMD:mobilni(playerid, const params[])
{
    if (!igrac_ima_mobilni(playerid)) 
    {
        ErrorMsg(playerid, "Ne posedujete mobilni telefon. Kupite ga u prodavnici tehnike.");
        SetGPSLocation(playerid, 1833.0729, -1435.5862, 13.6016, "prodavnica tehnike"); 
        return 1;
    }
	PC_EmulateCommand(playerid, "/mobitel");
    //SPD(playerid, "mobilni", DIALOG_STYLE_LIST, "Mobilni", "Poziv\nSMS\nImenik\nUkljuci/iskljuci\nBaci mobilni", "Dalje", "Izadji");
    return 1;
}