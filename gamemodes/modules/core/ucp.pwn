#include <YSI_Coding\y_hooks>

new PlayerText:UCP_PTD[MAX_PLAYERS][33];


hook OnPlayerDisconnect(playerid, reason)
{
	ShowStatsGui(playerid, false);
	CreateStatsGui(playerid, false);
	CancelSelectTextDraw(playerid);
	return true;
}
hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if (playertextid == UCP_PTD[playerid][27]) {// torba 
		callcmd::ranac(playerid, "");
		ShowStatsGui(playerid, false);
		CreateStatsGui(playerid, false);
		CancelSelectTextDraw(playerid);
	}
	if (playertextid == UCP_PTD[playerid][28]) {// exit 
		ShowStatsGui(playerid, false);
		CreateStatsGui(playerid, false);
		CancelSelectTextDraw(playerid);
	}
	return true;
}




forward mysql_changePass(playerid, const pw[]);
public mysql_changePass(playerid, const pw[])
{
	new pw2[BCRYPT_HASH_LENGTH+1];

	cache_get_value_index(0, 0, pw2);

	bcrypt_check(pw, pw2, "PassChange", "i", playerid);

	return 1;
}

Dialog:changePass_1(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
		{
			return DialogReopen(playerid);
		}

		new query[256];
		mysql_format(SQL, query, 256, "SELECT lozinka FROM igraci WHERE id = %d", PI[playerid][p_id]);
		mysql_tquery(SQL, query, "mysql_changePass", "is", playerid, inputtext);
	}
	return 1;
}

forward PassChange(playerid);
public PassChange(playerid)
{
	new match = bcrypt_is_equal();

	if(match)
	{
		SPD(playerid, "changePass_2", DIALOG_STYLE_INPUT, "Promena lozinke [2/3]", "{FFFFFF}Unesite {00FF00}novu {FFFFFF}lozinku:", "Dalje", "Izadji");
	}
	else
	{
		ErrorMsg(playerid, "To nije vasa lozinka!");
	}

    return true;
}

Dialog:changePass_2(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
		{
			return DialogReopen(playerid);
		}

		new pass[35];
		format(pass, sizeof pass, "%s", inputtext);


		if (strlen(pass) > 33)
			pass[33] = EOS;

		if (strlen(pass) < 6) {
			ErrorMsg(playerid, "Lozinka je suvise kratka (najmanje 6 znakova).");
			return DialogReopen(playerid);
		}

		if (strlen(pass) > 24) {
			ErrorMsg(playerid, "Lozinka je suvise dugacka (najvise 24 znaka).");
			return DialogReopen(playerid);
		}

		SetPVarString(playerid, "pPassChange", inputtext);
		SPD(playerid, "changePass_3", DIALOG_STYLE_INPUT, "Promena lozinke [3/3]", "{FFFFFF}Ponovite {00FF00}trenutnu {FFFFFF}novu:", "Promeni", "Izadji");
		
	}
	return 1;
}

Dialog:changePass_3(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
		{
			return DialogReopen(playerid);
		}

		new pass[35], pass1[35];
		format(pass, sizeof pass, "%s", inputtext);


		if (strlen(pass) > 33)
			pass[33] = EOS;

		GetPVarString(playerid, "pPassChange", pass1, sizeof pass1);
		if (strcmp(pass1, pass, false))
		{
			ErrorMsg(playerid, "Lozinke koje ste uneli nisu iste.");
			return 1;
		}

		bcrypt_hash(pass1, BCRYPT_COST, "PassFinalChange", "i", playerid);
	}
	return 1;
}

forward PassFinalChange(playerid);
public PassFinalChange(playerid)
{
	new str[100];
	bcrypt_get_hash(str);
	
	new query[128];
	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET lozinka = '%s' WHERE id = %i", str, PI[playerid][p_id]);
	mysql_tquery(SQL, query);
	InfoMsg(playerid, "Lozinka je uspesno promenjena.");

    return true;
}


// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:ucp("podaci", "stats", "licna", "licnakarta", "lk")
CMD:ucp(playerid, const params[])
{
	CreateStatsGui(playerid, true);
	ShowStatsGui(playerid, true);
	SelectTextDraw(playerid, BELA);

	//Update
		//Zivot
	
	new 
		string[256],
		posao[32],
		grupa[32],
		tel[13],
		pasos[22];

	GetPlayerJobName(playerid, posao, sizeof posao);
	GetFactionName(PI[playerid][p_org_id], grupa, sizeof grupa);
	format_phone(playerid, tel);
	if (PI[playerid][p_pasos_ts] == 0) pasos = "Nema";
	else if (PI[playerid][p_pasos_ts] < gettime()) pasos = "Istekao";
	else format(pasos, sizeof pasos, "Vazi do %s", PI[playerid][p_pasos]);
	format(string, sizeof string, "Novac: %s~n~Banka: %s~n~Posao: %s~n~Grupa: %s~n~Rang: %d~n~Vreme u grupi: %s~n~Kartica PIN: %d~n~Broj telefona: %s~n~Pasos: %s", formatMoneyString(PI[playerid][p_novac]), formatMoneyString(PI[playerid][p_banka]), posao, grupa, PI[playerid][p_org_rank], konvertuj_vreme(PI[playerid][p_org_vreme], true), PI[playerid][p_kartica_pin], tel, pasos);
	PlayerTextDrawSetString(playerid, UCP_PTD[playerid][7], string);
	PlayerTextDrawShow(playerid, UCP_PTD[playerid][7]);
		//Nalog
	new 		
		nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);

	
	format(string, sizeof string, "ID: %d~n~Nivo: %d~n~Iskustvo: %d/%d~n~E-mail: %s~n~Tokeni: %d~n~Drzava: %s~n~Starost: %d~n~Datum registracije: %s~n~Vreme u igri: %dh", PI[playerid][p_id], PI[playerid][p_nivo], PI[playerid][p_iskustvo], nextLevelExp, PI[playerid][p_email], PI[playerid][p_token], PI[playerid][p_drzava], PI[playerid][p_starost], PI[playerid][p_datum_registracije], PI[playerid][p_provedeno_vreme]);
	PlayerTextDrawSetString(playerid, UCP_PTD[playerid][32], string);

	PlayerTextDrawShow(playerid, UCP_PTD[playerid][32]);

		//Skill
	new divisionStr[9];
	GetDivisionName(GetPlayerDivision(playerid), divisionStr, sizeof divisionStr);
	format(string, sizeof string, "Divizija: %s (%i poena)~n~Gang Skill: %i~n~Cop Skill: %i~n~Opljackanih bankomata: %i~n~Opljackanih marketa: %i~n~Ukradenih vozila: %i~n~Broj hapsenja: %i", divisionStr, PI[playerid][p_division_points], PI[playerid][p_skill_criminal], PI[playerid][p_skill_cop], PI[playerid][p_robbed_atms], PI[playerid][p_robbed_stores], PI[playerid][p_stolen_cars], PI[playerid][p_arrested_criminals]);
	PlayerTextDrawSetString(playerid, UCP_PTD[playerid][26], string);

	PlayerTextDrawShow(playerid, UCP_PTD[playerid][26]);

		//Imovina
			// Formatiranje informacija o nekretninama
	if (pRealEstate[playerid][kuca] == -1)
	{
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][10], "Nemate kucu");
	}
	else
	{
		new strInfo[70], vrsta_text[13],
			lid = pRealEstate[playerid][kuca],
			gid = re_globalid(kuca, lid);

		switch (RealEstate[gid][RE_VRSTA])
		{
			case 1:  vrsta_text = "Prikolica";
			case 2:  vrsta_text = "Mala kuca";
			case 3:  vrsta_text = "Srednja kuca";
			case 4:  vrsta_text = "Velika kuca";
			case 5:  vrsta_text = "Vila";
			default: vrsta_text = "Kuca";
		}

		format(strInfo, sizeof strInfo, "KUCA:~n~%s~n~(ID: %03i)~n~%s~n~Cena: %s", vrsta_text, RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], formatMoneyString(RealEstate[gid][RE_CENA]));
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][10], strInfo);
	}

	if (pRealEstate[playerid][stan] == -1)
	{
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][11], "Nemate stan");
	}
	else
	{
		new strInfo[57],
			lid = pRealEstate[playerid][stan],
			gid = re_globalid(stan, lid);

		format(strInfo, sizeof strInfo, "STAN:~n~ID: %03i~n~%s~n~Cena: %s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], formatMoneyString(RealEstate[gid][RE_CENA]));
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][11], strInfo);
	}

	if (pRealEstate[playerid][garaza] == -1)
	{
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][12], "Nemate garazu");
	}
	else
	{
		new strInfo[57],
			lid = pRealEstate[playerid][garaza],
			gid = re_globalid(garaza, lid);

		format(strInfo, sizeof strInfo, "GARAZA~n~ID: %03i~n~%s~n~Cena: %s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], formatMoneyString(RealEstate[gid][RE_CENA]));
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][12], strInfo);
	}

	if (pRealEstate[playerid][firma] == -1)
	{
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][13], "Nemate firmu");
	}
	else
	{
		new strInfo[90],
			lid = pRealEstate[playerid][firma],
			gid = re_globalid(firma, lid);


		format(strInfo, sizeof strInfo, "FIRMA:~n~%s (ID: %03i)~n~%s~n~Cena: %s~n~Kasa: %s", vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_CAPITAL), RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], formatMoneyString(RealEstate[gid][RE_CENA]), formatMoneyString(RealEstate[gid][RE_NOVAC]));
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][13], strInfo);
	}

	if (pRealEstate[playerid][hotel] == -1)
	{
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][14], "Nemate hotel");
	}
	else
	{
		new strInfo[90],
			lid = pRealEstate[playerid][hotel],
			gid = re_globalid(hotel, lid);


		format(strInfo, sizeof strInfo, "HOTE:~n~ID: %03i~n~%s~n~Cena: %s~n~Kasa: %s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], formatMoneyString(RealEstate[gid][RE_CENA]), formatMoneyString(RealEstate[gid][RE_NOVAC]));
		PlayerTextDrawSetString(playerid, UCP_PTD[playerid][14], strInfo);
	}
	//Vozila
	// Postavljanje informacija o vozilima na odgovarajuca mesta
	for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi] - 1; i++) 
	{
		if (pVehicles[playerid][i] != 0)
		{
			new vehid = pVehicles[playerid][i], 
				strReg[32], strInfo[128],
				td_model = 15 + i,
				td_inform = 20 + i;
			OwnedVehicle_GetRegStatus(vehid, strReg, sizeof strReg);

			format(strInfo, sizeof strInfo, "%s~n~%s~n~%s", imena_vozila[OwnedVehicle_GetModel(vehid)-400], strReg, formatMoneyString(OwnedVehicle_GetPrice(vehid)));

			PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][td_model], OwnedVehicle_GetModel(vehid));
			PlayerTextDrawSetPreviewVehCol(playerid, UCP_PTD[playerid][td_model], OwnedVehicle_GetColor1(vehid), OwnedVehicle_GetColor2(vehid));
			PlayerTextDrawSetString(playerid, UCP_PTD[playerid][td_inform], strInfo);

			PlayerTextDrawShow(playerid, UCP_PTD[playerid][td_model]);
			PlayerTextDrawShow(playerid, UCP_PTD[playerid][td_inform]);
		}
	}
	//Skin i username
	PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][29], GetPlayerSkin(playerid));
	PlayerTextDrawShow(playerid, UCP_PTD[playerid][29]);
	new name[24];
	GetPlayerName(playerid, name, 24);
	PlayerTextDrawSetString(playerid, UCP_PTD[playerid][30], name);
	return 1;
}

CMD:promenilozinku(playerid, params[])
{
	SPD(playerid, "changePass_1", DIALOG_STYLE_INPUT, "Promena lozinke [1/3]", "{FFFFFF}Unesite {FF0000}trenutnu {FFFFFF}lozinku:", "Dalje", "Izadji");
	return 1;
}


ShowStatsGui(playerid, bool: show) {
	if (show) {
		for (new i; i < 33; i++)
			PlayerTextDrawShow(playerid, UCP_PTD[playerid][i]);
	} else {
		for (new i; i < 33; i++)
			PlayerTextDrawHide(playerid, UCP_PTD[playerid][i]);
	}
	return true;
}

CreateStatsGui(playerid, bool: create) {

	if (create) {
		UCP_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 5.439301, 15.583344, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][0], 620.000000, 405.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][0], 219685375);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][0], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][0], 0);

		UCP_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 282.972198, 59.333320, "/");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][1], 0.683923, 2.504163);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][1], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][1], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][1], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][1], 1);

		UCP_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 298.433654, 59.916664, "/");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][2], 0.586000, 1.739999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][2], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][2], 1);

		UCP_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 306.398406, 55.833320, "/");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][3], 0.683923, 2.504163);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][3], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][3], 1);

		UCP_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 304.524047, 65.750000, "-");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][4], 1.169311, 2.579998);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][4], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][4], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][4], 1);

		UCP_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 269.384735, 90.833343, "NLSAMP.COM");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][5], 0.297861, 0.719165);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][5], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][5], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][5], 1);

		UCP_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 240.805358, 100.749984, "User_Control_Panel");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][6], 0.400000, 1.600000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][6], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][6], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][6], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][6], 1);

		UCP_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 57.613464, 146.833389, "NOVAC:_$2000~n~BANKA:_$2000~n~POSAO:_Nezaposlen~n~GRUPA:_N/A~n~RANG:_-1~n~VREME_U_GRUPI:_00:00:00~n~KARTICA_PIN:_1337~n~BROJ_TE");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][7], 0.242108, 1.016666);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][7], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][7], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][7], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][7], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][7], 1);

		UCP_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 130.702804, 124.666694, "ZIVOT");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][8], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][8], 0.000000, 163.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][8], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][8], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][8], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][8], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][8], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][8], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][8], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][8], 1);

		UCP_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 373.866119, 124.666679, "IMOVINA");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][9], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][9], 0.000000, 271.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][9], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][9], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][9], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][9], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][9], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][9], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][9], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][9], 1);

		UCP_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 237.994888, 155.000091, "NEMATE_KUCU");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][10], 0.250541, 0.882498);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][10], 304.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][10], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][10], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][10], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][10], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][10], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][10], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][10], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][10], 1);

		UCP_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 315.300964, 155.000091, "NEMATE_STAN~n~");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][11], 0.250541, 0.882498);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][11], 381.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][11], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][11], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][11], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][11], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][11], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][11], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][11], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][11], 1);

		UCP_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 392.607147, 155.000106, "NEMATE_GARAZU");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][12], 0.250541, 0.882498);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][12], 461.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][12], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][12], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][12], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][12], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][12], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][12], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][12], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][12], 1);

		UCP_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 473.193115, 155.000106, "FIRMA:~n~ORUZAONICA~n~~n~ID(352)~n~WILOFILED~n~CENA:_2000$~n~KASA:_5252$");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][13], 0.250541, 0.882498);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][13], 532.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][13], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][13], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][13], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][13], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][13], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][13], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][13], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][13], 1);

		UCP_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 545.345397, 155.000106, "NEMATE_HOTEL");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][14], 0.250541, 0.882498);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][14], 605.000000, 0.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][14], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][14], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][14], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][14], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][14], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][14], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][14], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][14], 1);

		UCP_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 236.420196, 230.833251, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][15], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][15], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][15], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][15], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][15], -1261572609);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][15], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][15], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][15], -1);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][15], 0.000000, 0.000000, 45.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, UCP_PTD[playerid][15], 1, 1);

		UCP_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 313.726409, 230.833251, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][16], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][16], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][16], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][16], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][16], -1261572609);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][16], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][16], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][16], -1);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][16], 0.000000, 0.000000, 45.000000, 1.000000);

		UCP_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 388.689971, 229.666595, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][17], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][17], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][17], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][17], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][17], -1261572609);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][17], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][17], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][17], -1);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][17], 0.000000, 0.000000, 45.000000, 1.000000);

		UCP_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 464.121917, 229.666610, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][18], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][18], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][18], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][18], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][18], -1261572609);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][18], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][18], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][18], -1);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][18], 0.000000, 0.000000, 45.000000, 1.000000);

		UCP_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 538.148254, 229.666610, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][19], 60.000000, 60.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][19], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][19], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][19], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][19], -1261572609);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][19], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][19], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][19], -1);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][19], 0.000000, 0.000000, 45.000000, 1.000000);

		UCP_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 235.651473, 292.666687, "NEMATE_VOZILO");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][20], 0.257099, 0.969999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][20], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][20], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][20], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][20], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][20], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][20], 1);

		UCP_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 312.957672, 292.666687, "NEMATE_VOZILO");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][21], 0.257099, 0.969999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][21], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][21], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][21], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][21], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][21], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][21], 1);

		UCP_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 388.858123, 292.083374, "NEMATE_VOZILO");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][22], 0.257099, 0.969999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][22], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][22], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][22], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][22], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][22], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][22], 1);

		UCP_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 498.023864, 291.500030, "NEMATE_VOZILO");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][23], 0.257099, 0.969999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][23], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][23], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][23], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][23], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][23], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][23], 1);

		UCP_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 537.847900, 290.916687, "NEMATE_VOZILO");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][24], 0.257099, 0.969999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][24], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][24], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][24], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][24], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][24], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][24], 1);

		UCP_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 129.765762, 249.500030, "SKILL");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][25], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][25], 0.000000, 163.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][25], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][25], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][25], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][25], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][25], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][25], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][25], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][25], 1);

		UCP_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 56.676422, 272.250183, "DIVIZIJA:_Iron_(-3_Poena)~n~GANG_SKILL:_0~n~COP_SKILL:_0~n~OPLJACKANIH_BANKOMATA:_0~n~OPLJACKANIH_MARKETA:_0~n~UKRADENIH_VOZILA");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][26], 0.242108, 1.016666);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][26], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][26], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][26], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][26], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][26], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][26], 1);

		UCP_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 127.891616, 365.000091, "TORBA_(STVARI)");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][27], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][27], 107.000000, 107.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][27], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][27], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][27], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][27], -5963521);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][27], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][27], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][27], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][27], 1);
		PlayerTextDrawSetSelectable(playerid, UCP_PTD[playerid][27], true); 

		UCP_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 127.423645, 393.583465, "IZADJI");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][28], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][28], 107.000000, 107.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][28], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][28], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][28], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][28], -1523963137);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][28], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][28], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][28], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][28], 1);
		PlayerTextDrawSetSelectable(playerid, UCP_PTD[playerid][28], true);

		UCP_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 406.962127, 331.166625, "");
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][29], 90.000000, 90.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][29], 1);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][29], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][29], 0);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][29], 5);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][29], 0);
		PlayerTextDrawSetPreviewModel(playerid, UCP_PTD[playerid][29], 229);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][29], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, UCP_PTD[playerid][29], 0.000000, 0.000000, 0.000000, 1.000000);

		UCP_PTD[playerid][30] = CreatePlayerTextDraw(playerid, 463.352813, 402.333465, "aleksandar");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][30], 0.236954, 1.004999);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][30], 3);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][30], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][30], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][30], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][30], 3);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][30], 1);

		UCP_PTD[playerid][31] = CreatePlayerTextDraw(playerid, 525.666503, 315.999969, "NALOG");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][31], 0.400000, 1.600000);
		PlayerTextDrawTextSize(playerid, UCP_PTD[playerid][31], 0.000000, 163.000000);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][31], 2);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][31], 255);
		PlayerTextDrawUseBox(playerid, UCP_PTD[playerid][31], 1);
		PlayerTextDrawBoxColor(playerid, UCP_PTD[playerid][31], -1261572609);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][31], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][31], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][31], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][31], 1);

		UCP_PTD[playerid][32] = CreatePlayerTextDraw(playerid, 602.504089, 335.249969, "ID:~n~Nivo:~n~Iskustvo:~n~E-mail:~n~Tokeni:~n~Drzava:~n~Starost:~n~Datum registracije:~n~Vreme u igri:252");
		PlayerTextDrawLetterSize(playerid, UCP_PTD[playerid][32], 0.269282, 0.987499);
		PlayerTextDrawAlignment(playerid, UCP_PTD[playerid][32], 3);
		PlayerTextDrawColor(playerid, UCP_PTD[playerid][32], -1);
		PlayerTextDrawSetShadow(playerid, UCP_PTD[playerid][32], 0);
		PlayerTextDrawBackgroundColor(playerid, UCP_PTD[playerid][32], 255);
		PlayerTextDrawFont(playerid, UCP_PTD[playerid][32], 1);
		PlayerTextDrawSetProportional(playerid, UCP_PTD[playerid][32], 1);

	} else {
		for (new i; i < 33; i++)
			PlayerTextDrawDestroy(playerid, UCP_PTD[playerid][i]);
	}
	return true;
}