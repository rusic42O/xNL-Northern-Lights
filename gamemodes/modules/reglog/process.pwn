// 78 (white), 79 (black) <- muski skinovi
// 53 (white), 13 (black) <- zenski skinovi

#include <YSI_Coding\y_hooks>
DEFINE_HOOK_REPLACEMENT(OnPlayer, OP_);

enum
{
    POL_MUSKO = 0,
    POL_ZENSKO = 1,
};




static playerFadeStage[MAX_PLAYERS],
	playerRegLogStage[MAX_PLAYERS],
	introobj[MAX_PLAYERS];

static bool: reg_check_pw[MAX_PLAYERS],
	bool: reg_check_country[MAX_PLAYERS],
	bool: reg_check_email[MAX_PLAYERS],
	bool: reg_check_sex[MAX_PLAYERS],
	bool: reg_check_age[MAX_PLAYERS],
	bool: reg_check_skin[MAX_PLAYERS],
	bool: g_LoginPass[MAX_PLAYERS],
	bool: g_LoginPin[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	ClearChatForPlayer(playerid);
	// Prebacene linije za kameru, Linija 56...
	reg_check_pw[playerid] =
	reg_check_country[playerid] =
	reg_check_email[playerid] =
	reg_check_sex[playerid] =
	reg_check_age[playerid] =
	reg_check_skin[playerid] =
	g_LoginPass[playerid] =
	g_LoginPin[playerid] = false;	
	playerFadeStage[playerid] = playerRegLogStage[playerid] = -1;

	if(IsPlayerNPC(playerid))
		return true;

	new ip[16],
		query[352];
    GetPlayerIp(playerid, ip, sizeof ip);
   
    format(query, sizeof query, "SELECT id FROM `igraci` WHERE ip='%s' AND ime NOT LIKE '%s'", ip, ret_GetPlayerName(playerid));
    mysql_tquery(SQL, query, "mysql_ipcheck", "is", playerid, ip);

	return true;
}

forward mysql_ipcheck(playerid, const ip[]);
public mysql_ipcheck(playerid, const ip[])
{
	new rowws;
	cache_get_row_count(rowws);

	if(rowws > 1)
	{
		printf("DENIED CONNECTION >> player: %s; ip: %s", ret_GetPlayerName(playerid), ip);
		ErrorMsg(playerid, "Server je zabranio postojanje vise racuna sa istom IP adresom!");
		Kick_Timer(playerid);
	}
	else
	{
		SetTimerEx("LoadingRegLogProcess", 1500, false, "i", playerid);
	}

	return true;
}

forward LoadingRegLogProcess(playerid);
public LoadingRegLogProcess(playerid)
{
	// Linije prebacene ovdje da bi se postigao efekat postavljanja kamere
	TogglePlayerSpectating(playerid, true);
	introobj[playerid] = CreateDynamicObject(19538, -2495.603759, 1661.696533, 0.794260, 165.499969, 106.999954, 10.700002, GetPlayerVirtualWorld(playerid), -1, playerid, 300.00, 300.00);
    SetDynamicObjectMaterial(introobj[playerid], 0, -1, "none", "none", 0x99000000);
	AttachCameraToDynamicObject(playerid, introobj[playerid]);
	SetPlayerCameraPos(playerid, -2488.979736, 1711.347534, 16.300119);
    SetPlayerCameraLookAt(playerid, -2493.123046, 1708.950317, 17.744640, 2);
	new query[256];
	format(query, sizeof(query), "SELECT i.id, IFNULL(s.admin,0) as admin, IFNULL(s.helper,0) as helper, IFNULL(s.promoter,0) as promoter, IFNULL(s.pin,0) as pin, i.lozinka FROM staff s RIGHT OUTER JOIN igraci i ON s.pid = i.id WHERE i.ime = '%s'", ReturnName(playerid));
    mysql_tquery(SQL, query, "sql_ProcessPlayerRegLog", "i", playerid);
	return true;
}

forward sql_ProcessPlayerRegLog(playerid);
public sql_ProcessPlayerRegLog(playerid) {
	if (!IsPlayerConnected(playerid)) return false;
	cache_get_row_count(rows);    
	if (rows) {
		new adminStatus,
			helperStatus,
			promoterStatus,
			pin,
			pass[BCRYPT_HASH_LENGTH+1],
			nickn[25],
			nicks[25],
			count = strcount(ime_obicno[playerid], "_"),
			bool:correctname = false;

		if(count == 0)
		{
			if((ime_obicno[playerid][0] >= 'A' && ime_obicno[playerid][0] <= 'Z'))
			{
				correctname = true;
			}
		}
		else
		{
			sscanf(ime_obicno[playerid], "p<_>s[24]s[24]", nickn, nicks);
			if((nickn[0] >= 'A' && nickn[0] <= 'Z') && (nicks[0] >= 'A' && nicks[0] <= 'Z'))
			{
				correctname = true;
			}
		}

		if(correctname)
		{
			cache_get_value_index_int(0, 0, PI[playerid][p_id]);
			cache_get_value_index_int(0, 1, adminStatus);
			cache_get_value_index_int(0, 2, helperStatus);
			cache_get_value_index_int(0, 3, promoterStatus);
			cache_get_value_index_int(0, 4, pin);
			cache_get_value_index(0, 5, pass, BCRYPT_HASH_LENGTH+1);
			SetPVarInt(playerid, "pLoginAdmin", adminStatus);
			SetPVarInt(playerid, "pLoginHelper", helperStatus);
			SetPVarInt(playerid, "pLoginPromoter", promoterStatus);
			SetPVarInt(playerid, "pLoginPin_Correct", pin);
			SetPVarString(playerid, "pLoginPass_Correct", pass);
			static
				upit[60],
				ip[16]
			;
			GetPlayerIp(playerid, ip, sizeof ip);
			format(upit, sizeof upit, "SELECT vreme FROM ip_banovi WHERE ip = '%s'", ip);
			mysql_tquery(SQL, upit, "sql_CheckPlayerBanStatus", "ii", playerid, 1);
		}
		else
		{
			SPD(playerid, "kick", DIALOG_STYLE_MSGBOX, "Lose ime!", "{FF0000}Vase ime nije u validnom formatu (validan format: Ime_Prezime).", "U redu", "");
			Kick_Timer(playerid);
			return false;
		}
	}
	else // Nalog ne postoji
	{
		if (!Regex_Check(ime_obicno[playerid], regex_ime)) {
			new sDialog[450];
			format(sDialog, sizeof sDialog, "{FF0000}Vase ime nije u validnom formatu!\n\n{FFFF00}\
				Kako se ovo ne bi u buducnosti dogadjalo, procitajte kako Vase ime treba da izgleda:\n\n\
				- Vase ime mora biti u formatu {FFFFFF}Ime_Prezime {FFFF00}i obavezno mora sadrzati donju crtu.\n\
				- Ime ne mora biti Vase pravo ime, ali ne sme biti ime neke javne licnosti.\n\
				- Ime ne sme sadrzati ime nekog poznatog brenda i ne sme nikoga vredjati.\n\
				Primer dobrog imena: {FFFFFF}Marko_Nikolic, Steve_Petterson");
			SPD(playerid, "kick", DIALOG_STYLE_MSGBOX, "Lose ime!", sDialog, "U redu", "");
			Kick_Timer(playerid);
			return false;
		}
		static
			upit2[60],
			ip[16],
			nickn[25],
			nicks[25]
		;

		sscanf(ime_obicno[playerid], "p<_>s[24]s[24]", nickn, nicks);

		if((nickn[0] >= 'A' && nickn[0] <= 'Z') && (nicks[0] >= 'A' && nicks[0] <= 'Z'))
		{
			GetPlayerIp(playerid, ip, sizeof ip);
			format(upit2, sizeof upit2, "SELECT vreme FROM ip_banovi WHERE ip = '%s'", ip);
			mysql_tquery(SQL, upit2, "sql_CheckPlayerBanStatus", "ii", playerid, 2);
		}
		else
		{
			new sDialog[450];
			format(sDialog, sizeof sDialog, "{FF0000}Vase ime nije u validnom formatu!\n\n{FFFF00}\
				Kako se ovo ne bi u buducnosti dogadjalo, procitajte kako Vase ime treba da izgleda:\n\n\
				- Vase ime mora biti u formatu {FFFFFF}Ime_Prezime {FFFF00}i obavezno mora sadrzati donju crtu.\n\
				- Ime ne mora biti Vase pravo ime, ali ne sme biti ime neke javne licnosti.\n\
				- Ime ne sme sadrzati ime nekog poznatog brenda i ne sme nikoga vredjati.\n\
				Primer dobrog imena: {FFFFFF}Marko_Nikolic, Steve_Petterson");
			SPD(playerid, "kick", DIALOG_STYLE_MSGBOX, "Lose ime!", sDialog, "U redu", "");
			Kick_Timer(playerid);
			return false;
		}
	}
	return true;
}

forward sql_CheckPlayerBanStatus(playerid, nextStage);
public sql_CheckPlayerBanStatus(playerid, nextStage)
{
    cache_get_row_count(rows);

    if (rows == 1) // Banovana IP adresa
    {
        new timestamp, ip[16];
        cache_get_value_index_int(0, 0, timestamp);
        GetPlayerIp(playerid, ip, sizeof ip);

        new timeLimit = timestamp + (7 * 24 * 60 * 60); // ip ban traje 7 dana
        if (gettime() < timeLimit)
        {
            SendClientMessageF(playerid, TAMNOCRVENA2, "Vasa IP adresa [%s] je banovana. Unban mozete zatraziti na forumu: {FFFFFF}"#FORUM, ip);
            Kick_Timer(playerid);
        }
    }
    else
    {	
		playerRegLogStage[playerid] = nextStage;
        switch (nextStage) {
			case 1: {				
				SetupLoginForPlayer(playerid);
			}
			case 2: {
				SetupRegisterForPlayer(playerid);
			}
		}       
    }
    return 1;
}

ReturnName(playerid)
{	
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}


static SetupLoginForPlayer(playerid) 
{
    CreateLoginTD(playerid, true);
	ShowLoginTD(playerid, true);
    SelectTextDraw(playerid, 0xFFFFFFFF);
	return true;
}

stock SetupRegisterForPlayer(playerid)
{
	CreateRegisterTD(playerid, true);
	ShowRegisterTD(playerid, true);
    SelectTextDraw(playerid, 0xFFFFFFFF);
	ShowServerRules(playerid, false);
	return true;
}

hook OP_ClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if (playertextid == login_gui[playerid][24] ) //login
	{
		if(PI[playerid][p_id] != -1)
		{
			SPD(playerid, "login_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}Unesite svoju lozinku:", "Potvrdi", "Izadji");
		}
		else
		{
			SPD(playerid, "register_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}- Lozinka mora biti dugacka izmedju 6 i 24 znaka.\n- Nikome ne odajte svoju lozinku jer rizikujete kradju naloga.\n- Lozinku mozete promeniti u bilo kom trenutku.\n\nUnesite lozinku koju zelite da koristite za prijavu:", "Potvrdi", "Izadji");
		}
	}
	else if(playertextid == register_gui[playerid][24])
	{
		SPD(playerid, "register_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}- Lozinka mora biti dugacka izmedju 6 i 24 znaka.\n- Nikome ne odajte svoju lozinku jer rizikujete kradju naloga.\n- Lozinku mozete promeniti u bilo kom trenutku.\n\nUnesite lozinku koju zelite da koristite za prijavu:", "Potvrdi", "Izadji");
	}
	else if(playertextid == register_gui[playerid][66])
	{	
		SPD(playerid, "register_drzava", DIALOG_STYLE_LIST, "{0068B3}Drzava >>", "Bosna i Hercegovina\nCrna Gora\nHrvatska\nMakedonija\nSrbija", "Potvrdi", "Izadji");
	}
	else if(playertextid == register_gui[playerid][38])
	{
		SPD(playerid, "register_email", DIALOG_STYLE_INPUT, "{0068B3}Email >>", "{FFFFFF}- E-mail adresa moze biti dugacka do 40 znakova.\n- Unesite svoju e-mail adresu kojoj imate pristup, jer bez nje\nnecete moci da vratite lozinku ukoliko je zaboravite.\n- E-mail adresu mozete promeniti u bilo kom trenutku.\n\nUnesite svoju e-mail adresu:", "Potvrdi", "Izadji");        
	}
	else if(playertextid == register_gui[playerid][52])
	{
		SPD(playerid, "register_pol", DIALOG_STYLE_MSGBOX, "{0068B3}Pol >>", "{FFFFFF}Odaberite pol za Vaseg lika u igri:", "Musko", "Zensko");
	}
	else if (playertextid == register_gui[playerid][80])
    {
        SPD(playerid, "register_starost", DIALOG_STYLE_INPUT, "{0068B3}Godine >>", "{FFFFFF}Koliko imate godina?", "Potvrdi", "Izadji");
    }
	else if (playertextid == register_gui[playerid][94])
    {
		SPD(playerid, "register_skin", DIALOG_STYLE_LIST, "{0068B3}Skin >>", "{FFFFFF}Bijeli\nCrni", "Potvrdi", "Izadji");
	}	
	return Y_HOOKS_CONTINUE_RETURN_0;
}

//LOGIN DIALOGS
Dialog:login_password(playerid, response, listitem, const inputtext[])
{
	if(!response) return 1;

	if(isnull(inputtext)) return SPD(playerid, "login_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}Unesite svoju lozinku:", "Potvrdi", "Izadji");

	new pass[25];
	format(pass, sizeof pass, "%s", inputtext);

	for__loop (new i = 0; i < strlen(pass); i++)
	{
		if (pass[i] == '~')
			pass[i] = ' ';
	}	
	
	SetPVarString(playerid, "pLoginPass", pass);

	new correctPass[BCRYPT_HASH_LENGTH+1];
	GetPVarString(playerid, "pLoginPass_Correct", correctPass, BCRYPT_HASH_LENGTH+1);

	bcrypt_check(pass, correctPass, "PassValidation", "i", playerid);

	return true;
}

forward PassValidation(playerid);
public PassValidation(playerid)
{
    new bool:match = bcrypt_is_equal();
    
    if(match)
    {
        SetLoginPasswordTD(playerid, true);
		//
		g_LoginPass[playerid] = true;
		ClearChatForPlayer(playerid);
		if ((GetPVarInt(playerid, "pLoginAdmin") > 0 || GetPVarInt(playerid, "pLoginHelper") > 0)) // Uneo pin
		{
			SPD(playerid, "login_staffpin", DIALOG_STYLE_PASSWORD, "{0068B3}Staff Pin >>", "{FFFFFF}Unesite svoj PIN:", "Potvrdi", "Nazad");
		}
		else { //Obican igrac
			g_LoginPass[playerid] = !g_LoginPass[playerid];			
			CancelSelectTextDraw(playerid);
			DestroyDynamicObject(introobj[playerid]);
			ShowLoginTD(playerid, false);
			CreateLoginTD(playerid, false);
			static upit4[330];
			format(upit4, sizeof upit4, "SELECT i.ime, b.admin, b.razlog, DATE_FORMAT(b.datum, '\%%d \%%b \%%Y, \%%H:\%%i') as datum, UNIX_TIMESTAMP(b.istice) as istice_ts, DATE_FORMAT(b.istice, '\%%d \%%b \%%Y, \%%H:\%%i') as istice, b.offban, b.id, i.id FROM banovi b INNER JOIN igraci i ON b.pid = i.id WHERE i.ime = '%s'", ime_obicno[playerid]);
			mysql_tquery(SQL, upit4, "mysql_banCheck", "ii", playerid, cinc[playerid]);
			return ~1;
		}
    }
    else
    {
		SetPVarInt(playerid, "pLoginFailed", GetPVarInt(playerid, "pLoginFailed")+1);
		if (GetPVarInt(playerid, "pLoginFailed") < 3) 
		{
			format(string_64, 64, "Uneli ste pogresnu lozinku (%d/3)", GetPVarInt(playerid, "pLoginFailed"));
			ErrorMsg(playerid, string_64);
		}
		else
		{
			Kick_Timer(playerid);
			return false;
		}
		SetLoginPasswordTD(playerid, false);
    }

    return true;
}

Dialog:login_staffpin(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

	new
		pininput;

	if (sscanf(inputtext, "i", pininput))
		return DialogReopen(playerid);

	SetPVarInt(playerid, "pLoginPin", pininput);

	if (pininput == GetPVarInt(playerid, "pLoginPin_Correct"))
	{	
		g_LoginPin[playerid] = true;

		if(g_LoginPass[playerid])
		{
			g_LoginPass[playerid] = !g_LoginPass[playerid];
			
			CancelSelectTextDraw(playerid);
			DestroyDynamicObject(introobj[playerid]);
			ShowLoginTD(playerid, false);
			CreateLoginTD(playerid, false);
			static upit4[330];
			format(upit4, sizeof upit4, "SELECT i.ime, b.admin, b.razlog, DATE_FORMAT(b.datum, '\%%d \%%b \%%Y, \%%H:\%%i') as datum, UNIX_TIMESTAMP(b.istice) as istice_ts, DATE_FORMAT(b.istice, '\%%d \%%b \%%Y, \%%H:\%%i') as istice, b.offban, b.id, i.id FROM banovi b INNER JOIN igraci i ON b.pid = i.id WHERE i.ime = '%s'", ime_obicno[playerid]);
			mysql_tquery(SQL, upit4, "mysql_banCheck", "ii", playerid, cinc[playerid]);
			return ~1;
		}			
	}
	else 
	{
		SetPVarInt(playerid, "pPinFailed", GetPVarInt(playerid, "pPinFailed")+1);
		if (GetPVarInt(playerid, "pPinFailed") < 2) 
		{
			format(string_64, 64, "Uneli ste pogresan pin (%d/2)", GetPVarInt(playerid, "pPinFailed"));
			ErrorMsg(playerid, string_64);
		}
		else 
		{
			return Kick_Timer(playerid), printf("%s : %d", __file, __line);
		}
	}
    return 1;
}
//REGISTER DIALOGS
Dialog:register_skin(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
	if (!reg_check_sex[playerid])
		return ErrorMsg(playerid, "Prvo odaberi spol");
	
	new
		strcmppol[7]
	;
	GetPVarString(playerid, "pRegSex", strcmppol);
	if(!strcmp(strcmppol, "Musko", true))
	{
		if(listitem == 0)
			SetPVarInt(playerid, "pRegSkin", 134);
		else if(listitem == 1)
			SetPVarInt(playerid, "pRegSkin", 236);
	}
	else
	{
		if(listitem == 0)
			SetPVarInt(playerid, "pRegSkin", 38);
		else if(listitem == 1)
			SetPVarInt(playerid, "pRegSkin", 13);
	}
	ptdReg_SetSkinID(playerid);
	reg_check_skin[playerid] = true;
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
	return true;
}

Dialog:register_password(playerid, response, listitem, const inputtext[])
{
	if(!response) return 1;

	if(isnull(inputtext)) return SPD(playerid, "register_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}- Lozinka mora biti dugacka izmedju 6 i 24 znaka.\n- Nikome ne odajte svoju lozinku jer rizikujete kradju naloga.\n- Lozinku mozete promeniti u bilo kom trenutku.\n\nUnesite lozinku koju zelite da koristite za prijavu:", "Potvrdi", "Izadji");

	new pass[25];
	format(pass, sizeof pass, "%s", inputtext);

	for__loop (new i = 0; i < strlen(pass); i++)
	{
		if (pass[i] == '~')
			pass[i] = ' ';
	}
	SetPVarString(playerid, "pRegPass", pass);

	if (strlen(pass) < 6) 
	{
		ErrorMsg(playerid, "Lozinka je suvise kratka (najmanje 6 znakova).");
		ptdReg_SetPass(playerid, false);
		return SPD(playerid, "register_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}- Lozinka mora biti dugacka izmedju 6 i 24 znaka.\n- Nikome ne odajte svoju lozinku jer rizikujete kradju naloga.\n- Lozinku mozete promeniti u bilo kom trenutku.\n\nUnesite lozinku koju zelite da koristite za prijavu:", "Potvrdi", "Izadji");
	}

	if (strlen(pass) > 24) 
	{
		ErrorMsg(playerid, "Lozinka je suvise dugacka (najvise 24 znaka).");
		ptdReg_SetPass(playerid, false);
		return SPD(playerid, "register_password", DIALOG_STYLE_PASSWORD, "{0068B3}Lozinka >>", "{FFFFFF}- Lozinka mora biti dugacka izmedju 6 i 24 znaka.\n- Nikome ne odajte svoju lozinku jer rizikujete kradju naloga.\n- Lozinku mozete promeniti u bilo kom trenutku.\n\nUnesite lozinku koju zelite da koristite za prijavu:", "Potvrdi", "Izadji");
	}

	bcrypt_hash(pass, BCRYPT_COST, "PassRegistration", "i", playerid);

	ptdReg_SetPass(playerid, true);
	reg_check_pw[playerid] = true;
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
	return true;
}

forward PassRegistration(playerid);
public PassRegistration(playerid)
{
	new str[100];
	bcrypt_get_hash(str);
	SetPVarString(playerid, "pRegPass", str);

    return true;
}

Dialog:register_drzava(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

	SetPVarString(playerid, "pRegCountry", inputtext);
	ptdReg_SetCountry(playerid, true);
	reg_check_country[playerid] = true;
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
    return 1;
}

Dialog:register_email(playerid, response, listitem, const inputtext[]) // Email
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
	reg_check_email[playerid] = true;
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
    return 1;
}

Dialog:register_starost(playerid, response, listitem, const inputtext[]) // Starost
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
	reg_check_age[playerid] = true;
    ptdReg_SetAge(playerid, true);
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
    return 1;
}

Dialog:register_pol(playerid, response, listitem, const inputtext[]) // Pol
{
    if (response) 
    {
        SetPVarString(playerid, "pRegSex", "Musko");        
    }
    else 
    {
        SetPVarString(playerid, "pRegSex", "Zensko");

    }

    SetPVarInt(playerid, "pRegSkin_ArrayIndex", 0);
    ptdReg_SetSex(playerid, true);
	reg_check_sex[playerid] = true;
	if(reg_check_pw[playerid] &&
		reg_check_country[playerid] &&
		reg_check_email[playerid] &&
		reg_check_sex[playerid] &&
		reg_check_age[playerid] &&
		reg_check_skin[playerid] 
	)
	{
		FinishPlayerRegister(playerid);
		reg_check_pw[playerid] =
		reg_check_country[playerid] =
		reg_check_email[playerid] =
		reg_check_sex[playerid] =
		reg_check_age[playerid] =
		reg_check_skin[playerid] = false;
	}
    return 1;
}

// dodatne-funkcije (register);
stock ptdReg_SetPass(playerid, bool:ok) {
	
    PlayerTextDrawSetString(playerid, register_gui[playerid][24], "xxx");
	if (ok) {
		for (new i = 102; i <= 104; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	}
	else {
		for (new i = 102; i <= 104; i++)
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
	}
    return 1;
}

ptdReg_SetEmail(playerid, bool:ok) {
    new string[55];
    GetPVarString(playerid, "pRegEmail", string, sizeof(string));

    for__loop (new i = 0; i < strlen(string); i++) {
        if (string[i] == '@') {
            string[i] = ' ';
            strins(string, " (at)", i, sizeof string);
            break;
        }
    }

    PlayerTextDrawSetString(playerid, register_gui[playerid][38], string);

    // Promjena boje TD-a
    if (ok)
    {
		for (new i = 105; i <= 107; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	}
	else {
		for (new i = 105; i <= 107; i++)
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
	}
    return 1;
}

ptdReg_SetCountry(playerid, bool:ok) {
    new string[21];
    GetPVarString(playerid, "pRegCountry", string, sizeof(string));

    PlayerTextDrawSetString(playerid, register_gui[playerid][66], string);

    // Promena boje pozadine
    if (ok) {
		for (new i = 111; i <= 113; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	}
	else {
		for (new i = 11; i <= 113; i++)
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
	}
    return 1;
}

ptdReg_SetAge(playerid, bool:ok) 
{
    new age[5], ageNum = GetPVarInt(playerid, "pRegAge");

    if (ageNum >= 100) ageNum = 99;
    if (ageNum < 0) ageNum = 0;
    
    valstr(age, ageNum);
    PlayerTextDrawSetString(playerid, register_gui[playerid][80], age);

    if (ok) {
		for (new i = 114; i <= 116; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	}
	else {
		for (new i = 114; i <= 116; i++)
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
	}
    return 1;
}

ptdReg_SetSex(playerid, bool:ok) {
    new string[7];
    GetPVarString(playerid, "pRegSex", string, sizeof(string));

    PlayerTextDrawSetString(playerid, register_gui[playerid][52], string);

    // Promena boje pozadine
    if (ok) {
		for (new i = 108; i <= 110; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	}
	else {
		for (new i = 108; i <= 110; i++)
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
	}
    return 1;
}

ptdReg_SetSkinID(playerid) {
	new skin = GetPVarInt(playerid, "pRegSkin");
	new string[5];
    format(string, sizeof string, "%d", skin);
    PlayerTextDrawSetString(playerid, register_gui[playerid][94], string);
	PlayerTextDrawShow(playerid, register_gui[playerid][94]);
	for (new i = 117; i <= 119; i++)
		PlayerTextDrawShow(playerid, register_gui[playerid][i]);
	
	return true;
}

FinishPlayerRegister(playerid) {

	DestroyDynamicObject(introobj[playerid]);
	ShowRegisterTD(playerid, false);
	CreateRegisterTD(playerid, false);
	new 
		upit[450], // Ako se hashuje password, bice potrebno da se poveca
		spawn[45],
		ip[16],
		pass[BCRYPT_HASH_LENGTH+1],
		email[MAX_EMAIL_LEN+10],
		country[11],
		sex[7],
		sexInt,
		age = GetPVarInt(playerid, "pRegAge"),
		skin = GetPVarInt(playerid, "pRegSkin");
		

	GetPVarString(playerid, "pRegPass", pass, sizeof(pass));
	GetPVarString(playerid, "pRegEmail", email, sizeof(email));
	GetPVarString(playerid, "pRegCountry", country, sizeof(country));
	GetPVarString(playerid, "pRegSex", sex, sizeof(sex));	
	//GetPVarString(playerid, "pDiscordName", sex, sizeof(sex)); dodati za discord cuvanje

	ClearChatForPlayer(playerid);
	
	SetPlayerScore(playerid, 2);
	PlayerMoneySet(playerid, 100000);
	PI[playerid][p_provedeno_vreme] = 20;
	PI[playerid][p_stil_borbe] = 4;
	PI[playerid][p_skin] = skin;
	PI[playerid][p_nivo] = 2;
	
	if (!strcmp(sex, "Musko")) sexInt = POL_MUSKO, PI[playerid][p_stil_hodanja] = WALK_DEFAULT;
	else sexInt = POL_ZENSKO, PI[playerid][p_stil_hodanja] = WALK_LADY;

	format(PI[playerid][p_poslednja_aktivnost], 22, "%s", trenutno_vreme());
	format(PI[playerid][p_datum_registracije],  22, "%s", trenutno_vreme());
	format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f|0|0", SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_A);

	GetPlayerIp(playerid, ip, sizeof ip);

	CancelSelectTextDraw(playerid);

	mysql_format(SQL, upit, sizeof(upit), "INSERT INTO igraci \
	(ime, lozinka, email, nivo, pol, starost, drzava, stil_hodanja, skin, spawn, provedeno_vreme, pasos, ip) VALUES \
	('%s', '%s', '%s', %d, %d, %d, '%s', %d, %d, '%s', %d, FROM_UNIXTIME(0), '%s')", 
	ReturnName(playerid), 
	pass, email, PI[playerid][p_nivo], sexInt, age, country, PI[playerid][p_stil_hodanja], skin, spawn, PI[playerid][p_provedeno_vreme], ip);
	mysql_tquery(SQL, upit, "MySQL_OnPlayerRegister", "ii", playerid, cinc[playerid]);
	
	return true;
}