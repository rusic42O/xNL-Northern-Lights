#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnPlayerSpawn(playerid) 
{
	if (IsPlayerRegistering(playerid)) 
		return overwatch_poruka(playerid, "Server zahteva prijavu pre spawna!", true);
	return 1;
}

forward startRegProcess(playerid, ccinc);
public startRegProcess(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("startRegProcess");
    }

        
    if (!checkcinc(playerid, ccinc)) 
    {
        print("stopped [registracija.pwn]");
        return 1;
    }

    gRegTimestampLimit[playerid] = gettime() + 400;
    SetPVarInt(playerid, "pRegSkin", gMaleSkins[0]);
    SetPVarInt(playerid, "pRegSkin_ArrayIndex", 0);

    ShowServerRules(playerid, false);
    return 1;
}

stock IsPlayerRegistering(playerid) 
{
	return GetPVarInt(playerid, "pRegistering");
}

stock ShowServerRules(playerid, bool:info_only) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("ShowServerRules");
    }

    if(serverRegistracijeZakljucane == 1) 
    {
        ErrorMsg(playerid, "Registracije su trenutno zakljucane iz sigurnosnih razloga. Posjetite nas kroz par sati.");
        Kick_Timer(playerid);
    }

    new reg_pravila[1750]; // povecati ako se menjaju pravila

    reg_pravila = "";
    strcat(reg_pravila, "{FFFFFF}Dobrodosli na Northern Lights RPG server!\n\n{33CCFF}Pre nego sto zapocnete sa \
    procesom registracije, morate procitati \
    vaznija pravila servera i\nsloziti se sa njima.\n\n{FF0000}> In Character ime <\n{FFFFFF}  - Ime mora biti realno i u formatu \
    Ime_Prezime.\n  - Vase ime ne sme ni na koji nacin vredjati bilo koga\n  - \
    Vase ime ne sme sadrzati ime nekog poznatog \
    brenda ili \
    biti ime neke poznate licnosti.\n\n{FF0000}> Pravila servera <\n{FFFFFF}", 
    sizeof(reg_pravila));

    strcat(reg_pravila, "  - Nacionalizam, sovinizam, kao i diskriminacija po bilo kom osnovu su NAJSTROZE zabranjeni\n  - Iskoriscavanje i zloupotreba \
    gresaka u skripti je zabranjeno i kaznjava se trajnim iskljucenjem iz igre\n  - Upotreba bilo kakvih modifikacija koje donose prednost nad ostalim igracima je \
    strogo zabranjena\n    i rezultirace trajnim iskljucenjem sa servera.\n  - Zabranjeno je reklamiranje, kao i spominjanje bilo kog servera ili web stranice", sizeof(reg_pravila));

    strcat(reg_pravila, "\n\n{FF0000}> Privatnost podataka <\n{FFFFFF}  - NL zajednica ne odgovara za Vasu lozinku, ali istu nece nikome otkriti\n  - \
    NL nikome nece otkriti bilo koji podatak iz Vaseg naloga bez Vase saglasnosti\n  - NL {FF0000}nikada {FFFFFF}nece traziti Vasu lozinku u bilo koje svrhe!", sizeof(reg_pravila));

    strcat(reg_pravila, "\n\n{FF0000}Pritiskom na dugme \"Prihvatam\" automatski se obavezujete da:{FFFFFF}\n  - cete se striktno pridrzavati navedenih \
    pravila, kao i svih drugih pravila koja vaze na serveru\n  - cete svaku gresku (bug) koju primetite prijaviti na forumu i necete je zloupotrebiti\n  - necete kriviti \
    NL zajednicu za bilo kakvu stetu nacinjenu na Vasem nalogu\n     (izuzetak je steta nacinjena greskama u skripti)", sizeof(reg_pravila));

    strcat(reg_pravila, "\n\n\nVise pravila mozete procitati na nasem forumu: "#FORUM"\n\n{FFFFFF}Da biste se registrovali morate uneti lozinku, e-mail adresu i drzavu porekla.", sizeof(reg_pravila));
    
    if (!info_only) 
    {
        // Nije samo informativno, vec se registruje
        SPD(playerid, "reg_pravila", DIALOG_STYLE_MSGBOX, "{0068B3}PRAVILA SERVERA", reg_pravila, "Prihvatam", "Izadji");
    }
    else 
    {
        SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "{0068B3}PRAVILA SERVERA", reg_pravila, "Zatvori", "");
    }

    return 1;
}





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_OnPlayerRegister(playerid, ccinc);
public MySQL_OnPlayerRegister(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MySQL_OnPlayerRegister");
    }
    //if (!checkcinc(playerid, ccinc)) return 1;
    
    SetPVarInt(playerid, "pRegistering", 0);
    PI[playerid][p_id] = cache_insert_id();
    LogPlayerIn(playerid, PRIJAVA_PRVIPUT);
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:reg_pravila(playerid, response, listitem, const inputtext[]) // Registracija: pravila
{
	if (!response)
	{
		SendClientMessage(playerid, TAMNOCRVENA2, GRESKA_KICK);
		Kick_Timer(playerid);
		return 1;
	}
    SelectTextDraw(playerid, 0xF2E4AEFF);
	return 1;
}

Dialog:reg_lozinka(playerid, response, listitem, const inputtext[]) // Lozinka
{
    if (!response) return 1;
    if (isnull(inputtext)) return DialogReopen(playerid);

    new pass[25];
    format(pass, sizeof pass, "%s", inputtext);

    for__loop (new i = 0; i < strlen(pass); i++) 
    {
        if (pass[i] == '~')
        {
            pass[i] = ' ';
        }
    }

    SetPVarString(playerid, "pRegPass", pass);

    if (strlen(pass) < 6) 
    {
        ErrorMsg(playerid, "Lozinka je suvise kratka (najmanje 6 znakova).");
        ptdReg_SetPass(playerid, false);
        return DialogReopen(playerid);
    }

    if (strlen(pass) > 24) 
    {
        ErrorMsg(playerid, "Lozinka je suvise dugacka (najvise 24 znaka).");
        ptdReg_SetPass(playerid, false);
        return DialogReopen(playerid);
    }

    ptdReg_SetPass(playerid, true);
    return 1;
}

Dialog:reg_email(playerid, response, listitem, const inputtext[]) // Email
{
    if (!response) return 1;
    if (isnull(inputtext) || strlen(inputtext) > 60) return DialogReopen(playerid);

    new email[42], bool:tooLong = false, bool:atChar = false;
    format(email, sizeof email, "%s", inputtext);

    if (strlen(email) > 40)
        tooLong = true;

    for__loop (new i = 0; i < strlen(email); i++) 
    {
        if (email[i] == '~')
        {
            email[i] = ' ';
        }
        else if (email[i] == '@')
        {
            atChar = true;
        }
    }

    SetPVarString(playerid, "pRegEmail", email);

    if (tooLong) 
    {
        ErrorMsg(playerid, "E-mail adresa je suvise dugacka (najvise 40 znakova).");
        ptdReg_SetEmail(playerid, false);
        return DialogReopen(playerid);
    }

    if (!atChar || !Regex_Check(email, regex_email))
    {
        ErrorMsg(playerid, "E-mail adresa nije u pravilnom obliku.");
        ptdReg_SetEmail(playerid, false);
        return DialogReopen(playerid);
    }

    ptdReg_SetEmail(playerid, true);
    return 1;
}

Dialog:reg_drzava(playerid, response, listitem, const inputtext[]) // Drzava
{
    if (!response) return 1;

    SetPVarString(playerid, "pRegCountry", inputtext);
    ptdReg_SetCountry(playerid, true);
    return 1;
}

Dialog:reg_starost(playerid, response, listitem, const inputtext[]) // Starost
{
    if (!response)
        return 1;

    new age;
    if (sscanf(inputtext, "i", age)) 
        return DialogReopen(playerid); 

    if (age >= 100)
        age = 99;
    if (age < 0)
        age = 0;

    SetPVarInt(playerid, "pRegAge", age);

    if (age < 12 || age > 80) {
        ErrorMsg(playerid, "Morate uneti vrednost izmedju 12 i 80 godina.");
        ptdReg_SetAge(playerid, false);
        return DialogReopen(playerid);
    }

    ptdReg_SetAge(playerid, true);
    return 1;
}

Dialog:reg_pol(playerid, response, listitem, const inputtext[]) // Pol
{
    if (response) 
    {
        SetPVarString(playerid, "pRegSex", "Musko");

        PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdReg][1], gMaleSkins[0]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdReg][1]);

        SetPVarInt(playerid, "pRegSkin", gMaleSkins[0]);
    }
    else 
    {
        SetPVarString(playerid, "pRegSex", "Zensko");

        PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdReg][1], gFemaleSkins[0]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdReg][1]);

        SetPVarInt(playerid, "pRegSkin", gFemaleSkins[0]);
    }

    SetPVarInt(playerid, "pRegSkin_ArrayIndex", 0);
    ptdReg_SetSex(playerid, true);
    return 1;
}