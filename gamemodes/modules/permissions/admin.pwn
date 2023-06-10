#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_TELEPORT_LOCATIONS
{
	portKeyword[9],
	portName[24],
	Float:portX,
	Float:portY,
	Float:portZ,
}

enum
{
	THREAD_ADMINI = 0,
	THREAD_HELPERI,
	THREAD_PROMOTERI,
	THREAD_VIP,
	THREAD_DJ,
}



// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	bool:gHeadAdmin[MAX_PLAYERS char],
	bool:gOwner[MAX_PLAYERS char],
	Float:duty_stats[MAX_PLAYERS][2], // hp i armor pre odlaska na admin/gm duznost; [0] = hp, [1] = armor

	bool:gStaffDuty[MAX_PLAYERS char],
	dutyStartTime[MAX_PLAYERS],
	dutyAFKTime[MAX_PLAYERS],
	dutyTimeTotal[MAX_PLAYERS],

	Iterator:iAdminsSpectating<MAX_PLAYERS>,
	gSpectatingPlayer[MAX_PLAYERS],
	tmrSpecUpdate,
	pDutyCooldown[MAX_PLAYERS],
	pCreatedVeh[MAX_PLAYERS],
	Text3D:pStaffVehicleLabel[MAX_PLAYERS],

	bool:StaffDayEnded,
	Text3D:gStaffDutyLabel[MAX_PLAYERS]
;

static
	gCmdUsedOnPlayer_H1[MAX_PLAYERS],
	gCmdUsedOnPlayer_H2[MAX_PLAYERS],
	gCmdUsedOnPlayer_Fv[MAX_PLAYERS],
	gCmdUsedOnPlayer_Ptp[MAX_PLAYERS]
;

static gMusicReload, gMusicPlayer;

new Teleports[][E_TELEPORT_LOCATIONS] =
{
	{"burg",     "Burger Shot",              1193.9370, -882.7886, 43.0527},
	{"sp",       "Spawn (glavni)",           SPAWN_X, SPAWN_Y, SPAWN_Z},
	{"banka",    "Banka",                    1443.7198, -1038.7651, 23.2309},
	{"mc",       "Mount Chiliad",            -2336.7830, -1639.5317, 483.3585},
	{"bolnica",  "Bolnica",                  1197.2137,-1328.1107,13.3984},
	{"pd",       "Policija",                 1520.6989, -1679.5389, 13.8739},
	{"opstina",  "Opstina",                  1475.3367,-1708.0898,14.0469},
	{"tech",     "Tech Store",               1712.5375, -1146.5448, 23.9567},
	{"gun",      "Gun Shop",                 1363.4161, -1279.1832, 13.5469},
	{"as",       "Autobuska stanica",        1814.9778, -1898.3472, 13.5775},
	{"zs",       "Zeleznicka stanica",       1688.7251, -1863.2910, 13.5235},
	{"asalon",   "Auto salon",               906.6302, -1726.4744, 13.2739},
	{"askola",   "Auto skola",               1065.2148, -1727.0674,13.4227},
	{"alc",      "Alcatraz",                  3010.8948,-2846.0674,10.4777},
	{"farma",    "Farma",                    -383.8207, -1401.9355, 24.0377},
	{"tower",    "Bank Tower",               1543.9408,-1354.1099,329.4730},
	{"lsaero",   "Aerodrom (Los Santos)",    1962.6006, -2181.7441, 13.1202},
	{"sfaero",   "Aerodrom (San Fierro)",    -1528.8303,-83.3540,13.7122},
	{"lvaero",   "Aerodrom (Las Venturas)",  1565.2573,1425.8976,10.4112},
	{"meh",      "Mehanicarska radionica",   2560.6797, -1502.5238, 23.9186},
	{"verona",   "Verona",                   830.7375, -1806.4218, 12.5534},
	{"maria",    "Santa Maria Beach",        430.1023, -1794.7499, 5.1079},
	{"dokovi",   "Ocean Docks",              2592.2549, -2402.8052, 13.1826},
	{"sfdokovi", "SF dokovi",                -1685.4487, 2.2885, 3.2818},
	{"rudnik",   "Rudnik",                   633.5398,874.9022,-41.0305},
	{"szm",      "Skladiste za materijale",  -1095.4924, -1623.6160, 78.3681},
	{"poligon",  "Poligon",                  -2050.2117,-113.1143,34.9983},
	{"zlatara",  "Zlatara",                  607.7417, -1458.4033, 14.3721},
	{"fabrika",  "Fabrika oruzja",           1041.3328,2075.0498,10.8203},
	{"baza",     "Staff baza",               -686.4706,958.1559,12.4831},
	{"head",     "Head baza",                -2813.7888,-1500.6383,139.2891},
	{"ls",       "Los Santos",               1442.3499,-1665.5615,13.1240},
	{"sf",       "San Fierro",               -1990.5922,289.0847,34.1308},
	{"lv",       "Las Venturas",             2063.4368,1715.7910,10.2476},
	{"bayside",  "Bayside",                  -2267.6777,2344.5549,4.3857},
	{"402",      "402 Street Race",          2061.7463,-2519.4736,13.1088},
	{"ct",       "Crno trziste",             2845.1563,-2347.1089,19.2058},
	{"vip",      "VIP baza",                 31.7211, -1736.6465, 17.5995},
	{"vs",       "VS Event",                 -248.1189,2610.8713,62.8582},
	{"dokovi",   "Dokovi",                  2274.3665,-2350.0715,13.5469},
	{"pijaca",   "Pijaca/Trznica",          1003.0616,-1332.6691,13.3828},
	{"promo",    "Promoter baza",           1408.4326,-1649.2856,13.3813},
	{"oglas",    "Oglasnik",                1804.9729, -1345.5475, 15.2733}
};


// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{   
	tmrSpecUpdate = 0;
	StaffDayEnded = false;
	gMusicReload = 0;
	gMusicPlayer = INVALID_PLAYER_ID;
	return 1;
}

hook OnPlayerConnect(playerid) 
{
	gHeadAdmin{playerid} = false;
	gOwner{playerid} = false;
	gSpectatingPlayer[playerid] = INVALID_PLAYER_ID;
	pCreatedVeh[playerid] = INVALID_VEHICLE_ID;
	pStaffVehicleLabel[playerid] = Text3D:INVALID_3DTEXT_ID;

	gStaffDuty{playerid} = false;
	dutyTimeTotal[playerid] = 0;
	pDutyCooldown[playerid] = 0;

	gCmdUsedOnPlayer_H1[playerid] = 0;
	gCmdUsedOnPlayer_H2[playerid] = 0;
	gCmdUsedOnPlayer_Fv[playerid] = 0;
	gCmdUsedOnPlayer_Ptp[playerid] = 0;


	return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
	if (!IsPlayerLoggedIn(playerid)) return 1;

	// Brisanje 3D labela za duznost + belezenje vremena
	if (IsOnDuty(playerid)) 
	{       
		Delete3DTextLabel(gStaffDutyLabel[playerid]);
		gStaffDutyLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
		dutyTimeTotal[playerid] += gettime() - dutyStartTime[playerid] - dutyAFKTime[playerid];
	}
	UpdateDutyTime(playerid);
	LogPlayerStaffActivity(playerid);

	if (pCreatedVeh[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(pCreatedVeh[playerid]);
		pCreatedVeh[playerid] = INVALID_VEHICLE_ID;

		if (IsValidDynamic3DTextLabel(pStaffVehicleLabel[playerid]))
			DestroyDynamic3DTextLabel(pStaffVehicleLabel[playerid]);

		pStaffVehicleLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
	}

	StopSpec(playerid);
	return 1;
}

hook OnPlayerText(playerid, text[]) 
{
	if (text[0] == '!' && IsHelper(playerid, 1)) // staff chat
	{
		strdel(text, 0, 1);
		new cmdParams[145];
		
		if (IsAdmin(playerid, 6))
		{
			format(cmdParams, sizeof cmdParams, "%s", text);
			callcmd::ha(playerid, cmdParams);
		}
		
		else if (IsAdmin(playerid, 1))
		{
			format(cmdParams, sizeof cmdParams, "%s", text);
			callcmd::a(playerid, cmdParams);
		}
			
		else if (IsHelper(playerid, 1))
		{
			format(cmdParams, sizeof cmdParams, "%s", text);
			callcmd::h(playerid, cmdParams);
		}
			
		return ~0;
	}
	return 0;
}

hook OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(IsAdmin(playerid, 6))
	{
		//MapAndreas_FindZ_For2DCoord(fX, fY, fZ);
		CA_FindZ_For2DCoord(fX, fY, fZ);
		TeleportPlayer(playerid, fX, fY, fZ+1.0);
	}
	return 1;
}

hook OnPlayerSpawn(playerid) 
{
	SetPVarInt(playerid, "pKilledByAdmin", 0);

	if (IsOnDuty(playerid))
	{
		if (IsAdmin(playerid, 6)) {
			if (IsPlayerOwner(playerid)) 
				SetPlayerColor(playerid, CRVENA);
			else 
				SetPlayerColor(playerid, ZUTA);
		}
		else if (IsAdmin(playerid, 1)) SetPlayerColor(playerid, PLAVA);
		else if (IsHelper(playerid, 1)) SetPlayerColor(playerid, ZELENOZUTA);
	}

	if (Iter_Count(iAdminsSpectating) > 0)
	{
		foreach (new i : iAdminsSpectating) 
		{
			if (playerid == gSpectatingPlayer[i]) 
			{
				TogglePlayerSpectating_H(i, true);
				SetPlayerInterior(i, GetPlayerInterior(playerid));
				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));

				if (!IsPlayerInAnyVehicle(playerid))
					PlayerSpectatePlayer(i, playerid);
				else
					PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
			}
		}
	}
	return 1;
}

hook OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) 
{
	if (Iter_Count(iAdminsSpectating) == 0)
		return 1;

	foreach (new i : iAdminsSpectating) 
	{
		if (playerid == gSpectatingPlayer[i]) 
		{
			TogglePlayerSpectating_H(i, true);
			SetPlayerInterior(i, newinteriorid);
			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));

			if (!IsPlayerInAnyVehicle(playerid))
				PlayerSpectatePlayer(i, playerid);
			else
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
		}
	}
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (Iter_Count(iAdminsSpectating) == 0)
		return 1;

	foreach (new i : iAdminsSpectating) 
	{
		if (playerid == gSpectatingPlayer[i]) 
		{
			TogglePlayerSpectating_H(i, true);
			SetPlayerInterior(i, GetPlayerInterior(playerid));
			SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(playerid));

			if (!IsPlayerInAnyVehicle(playerid))
				PlayerSpectatePlayer(i, playerid);
			else
				PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
	if (DebugFunctions())
	{
		LogCallbackExec("admin.pwn", "OnPlayerKeyStateChange");
	}
	if (gSpectatingPlayer[playerid] != INVALID_PLAYER_ID)
	{
		if (newkeys & KEY_FIRE) // Levi klik
		{
			SpecNextPlayer(playerid);
			return 1;
		}

		if (newkeys & KEY_HANDBRAKE) // Desni klik
		{
			if (Iter_Count(Player) == 2) return 1; // samo 2 igraca na serveru

			// Uzima prethodnog igraca iz iteratora ili resetuje na kraj ako smo dosli do pocetka
			gSpectatingPlayer[playerid] = (Iter_Prev(Player, gSpectatingPlayer[playerid]) == MAX_PLAYERS)? Iter_Last(Player) : Iter_Prev(Player, gSpectatingPlayer[playerid]);

			new stopper = 0;
			while__loop (gSpectatingPlayer[playerid] == playerid || (IsAdmin(gSpectatingPlayer[playerid], 6) && !IsAdmin(playerid, 6)))
			{
				// Uzima prethodnog igraca iz iteratora ili resetuje na kraj ako smo dosli do pocetka
				gSpectatingPlayer[playerid] = (Iter_Prev(Player, gSpectatingPlayer[playerid]) == MAX_PLAYERS)? Iter_Last(Player) : Iter_Prev(Player, gSpectatingPlayer[playerid]);

				stopper++;

				if (stopper > 20) break;
			}
			if (stopper >= 20)
			{
				// Infinite loop -> uncon
				// Na serveru je verovatno taj admin + botovi
				TogglePlayerSpectating_H(playerid, false);
				StopSpec(playerid);

				for (new i = 0; i < sizeof(tdSpec); i++)
					TextDrawHideForPlayer(playerid, tdSpec[i]);

				ptdSpec_Destroy(playerid);
				InfoMsg(playerid, "Nema vise igraca koje mozete da posmatrate.");
				return 1;
			}
			else
			{
				TogglePlayerSpectating_H(playerid, true);
				if (!IsPlayerInAnyVehicle(gSpectatingPlayer[playerid]))
					PlayerSpectatePlayer(playerid, gSpectatingPlayer[playerid], SPECTATE_MODE_NORMAL);
				else 
					PlayerSpectateVehicle(playerid, GetPlayerVehicleID(gSpectatingPlayer[playerid]), SPECTATE_MODE_NORMAL);

				SpecUpdate();
			}
			
			return 1;
		}

		if (newkeys & KEY_SPRINT) // Space
		{
			if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING && IsPlayerConnected(gSpectatingPlayer[playerid]))
			{
				callcmd::spec(playerid, ""); // Uncon
			}
		}
	}
	return 1;
}

hook OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if (IsHelper(playerid, 2)) 
	{
		new str[5];
		valstr(str, clickedplayerid);
		callcmd::proveri(playerid, str);
	}
}

hook OnPlayerAFK_Back(playerid)
{
	if (IsOnDuty(playerid))
	{
		dutyAFKTime[playerid] += GetPlayerAFKTime(playerid);
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
PromptPunishmentDialog(playerid, targetid, jailTime, muteTime, finePercentage, const reason[])
{
	if(IsPlayerNPC(targetid))
		return 1;
	
	new sDialog[345],
		sFine[18]
	;

	if (finePercentage < 100)
	{
		format(sFine, sizeof sFine, "%i procenata", finePercentage);
	}
	else
	{
		format(sFine, sizeof sFine, "%s", formatMoneyString(finePercentage));
	}

	format(sDialog, sizeof sDialog, "{FFFFFF}Igrac {FF9900}%s[%i] {FFFFFF}je napravio prekrsaj: {FF0000}%s\n\n{FFFFFF}Kazna za ovaj prekrsaj je:\nJail: {FF9900}%i minuta\n{FFFFFF}Mute: {FF9900}%i minuta\n{FFFFFF}Novac: {FF9900}%s\n\n{FF0000}Da li zelite da kaznite igraca za ovaj prekrsaj?", ime_rp[targetid], targetid, reason, jailTime, muteTime, sFine);

	SetPVarInt(playerid, "punishTargetID", targetid);
	SetPVarInt(playerid, "punishTargetCinc", cinc[targetid]);
	SetPVarInt(playerid, "punishTimeout", gettime()+20);
	SetPVarInt(playerid, "punishJailTime", jailTime);
	SetPVarInt(playerid, "punishMuteTime", muteTime);
	SetPVarInt(playerid, "punishFine", finePercentage);
	SetPVarString(playerid, "punishReason", reason);

	SPD(playerid, "punishment_prompt", DIALOG_STYLE_MSGBOX, "{FFFFFF}Kazni igraca?", sDialog, "Ne", "Da");
	return 1;
}

PunishPlayer(playerid, adminid, jailTime, muteTime, finePercentage, bool:warn, const reason[])
{
	// Ignorise se [automatska] kazna ako je igrac vec zatvoren
	if (IsPlayerJailed(playerid) && !IsPlayerConnected(adminid)) return 1;
	
	new sMsg[145],
		wealth = PI[playerid][p_novac] + PI[playerid][p_banka],
		fine = 20000
	;

	if (wealth > 20000 && (1 <= finePercentage <= 10))
	{
		fine = floatround((PI[playerid][p_novac] + PI[playerid][p_banka]) * finePercentage/100.0);
	}
	else if (finePercentage > 10)
	{
		fine = finePercentage;
	}


	if (!IsPlayerConnected(adminid))
	{
		// Automatska kazna
		format(sMsg, sizeof sMsg, "OVERWATCH | {FFFFFF}Igrac %s[%i] je automatski kaznjen zbog prekrsaja: {FFFF00}%s.", ime_rp[playerid], playerid, reason);
		SendClientMessageToAll(CRVENA, sMsg);
	}

	else
	{
		format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} Admin %s[%i] je kaznio igraca %s[%i] zbog prekrsaja: {FFFF00}%s.", ime_rp[adminid], adminid, ime_rp[playerid], playerid, reason);
		
		if (!IsHelper(playerid, 1))
		{
			// Obavestenje ide svima ako igrac NIJE helper
			SendClientMessageToAll(CRVENA, sMsg);
		}
		else
		{
			// Samo staff dobija obavestenje ako je igrac helper
			StaffMsg(CRVENA, sMsg);
		}
	}

	format(sMsg, sizeof sMsg, "* Kazna: Alcatraz {%s}[%i min],  {FFFFFF}Mute {%s}[%i min],  {FFFFFF}Novcana kazna {%s}[-%s]", (jailTime>0? ("FF9900") : ("FFFFFF")), jailTime, (muteTime>0? ("FF9900") : ("FFFFFF")), muteTime, (fine>0? ("FF9900") : ("FFFFFF")), formatMoneyString(fine));
	SendClientMessage(playerid, BELA, sMsg);
	AdminMsg(BELA, sMsg);

	// ------------------------------------------------- //

	PI[playerid][p_kaznjen_puta]++;
	format(PI[playerid][p_area_razlog], 32, "N/A");
	format(PI[playerid][p_utisan_razlog], 32, "N/A");

	if (jailTime > 0)
	{
		PI[playerid][p_area] += jailTime * 60;
		PI[playerid][p_zavezan] = 0;
		
		stavi_u_zatvor(playerid, true);
		format(PI[playerid][p_area_razlog], 32, "%s", reason);
	}

	if (muteTime > 0)
	{
		PI[playerid][p_utisan] += muteTime * 60;
		format(PI[playerid][p_utisan_razlog], 32, "%s", reason);
		SetPlayerChatBubble(playerid, "(( Ovaj igrac je UTISAN ))", 0xFF0000AA, 15.0, PI[playerid][p_utisan]*1000);
	}

	if (fine > 0)
	{
		PlayerMoneySub(playerid, fine);
	}

	// Da li za ovu kaznu sleduje WARN_
	if (warn)
	{
		new sQuery[256],
			bool:issueWarn = false
		;
		if (!strcmp(reason, "DM"))
		{
			if (++ PI[playerid][p_warn_dm] > 2)
			{
				// Dobija pravi WARN
				issueWarn = true;
			}
			
			format(sQuery, sizeof sQuery, "UPDATE igraci SET warn_dm = %i WHERE id = %i", PI[playerid][p_warn_dm], PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery);
		}

		else if (!strcmp(reason, "Mesanje u turf/pljacku"))
		{
			if (++ PI[playerid][p_warn_turf_interrupt] > 2)
			{
				// Dobija pravi WARN
				issueWarn = true;
			}
			format(sQuery, sizeof sQuery, "UPDATE igraci SET warn_turf_interrupt = %i WHERE id = %i", PI[playerid][p_warn_turf_interrupt], PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery);
		}

		else if (!strcmp(reason, "VIP/Promo Abuse"))
		{
			if (++ PI[playerid][p_warn_vip_abuse] > 2)
			{
				// Dobija pravi WARN
				issueWarn = true;
			}
			format(sQuery, sizeof sQuery, "UPDATE igraci SET warn_vip_abuse = %i WHERE id = %i", PI[playerid][p_warn_vip_abuse], PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery);
		}
		if (issueWarn)
		{
			SetPVarInt(adminid, "warnPlayerID", playerid);
			SetPVarString(adminid, "warnType", "igrac");
			dialog_respond:warnDetails(adminid, 1, 0, reason);
		}
	}


	// Update podataka u bazi
	new sQuery[256];
	format(sQuery, sizeof sQuery, "UPDATE igraci SET area = %i, area_razlog = '%s', utisan = %i, utisan_razlog = '%s', kaznjen_puta = %i, zavezan = %i, novac = %i WHERE id = %i", PI[playerid][p_area], PI[playerid][p_area_razlog], PI[playerid][p_utisan], PI[playerid][p_utisan_razlog], PI[playerid][p_kaznjen_puta], PI[playerid][p_zavezan], PI[playerid][p_novac], PI[playerid][p_id]);    
	mysql_tquery(SQL, sQuery);

	// Upisivanje u log
	new logStr[160];
	format(logStr, sizeof logStr, "%s je kaznio %s | %s | Alc [%i min], Mute [%i min], Novac [%s]", (IsPlayerConnected(adminid)? (ime_obicno[adminid]) : ("Overwatch")), ime_obicno[playerid], reason, jailTime, muteTime, formatMoneyString(fine));
	Log_Write(LOG_KAZNE, logStr);
	return 1;
}

ProcessNameChange(playerid, const _name[])
{
	if (isnull(_name)) return 1;

	new name[MAX_PLAYER_NAME];
	format(name, sizeof name, "%s", _name);

	// Upisivanje u log
	new sLog[55];
	format(sLog, sizeof sLog, "%s » %s", ime_obicno[playerid], name);
	Log_Write(LOG_NAMECHANGE, sLog);


	// Brisanje donje crte
	new nameRP[MAX_PLAYER_NAME];
	format(nameRP, sizeof nameRP, "%s", name);
	for__loop (new i = 0; i < strlen(nameRP); i++) {
		if (nameRP[i] == '_') {
			nameRP[i] = ' ';
			break;
		}
	}

	// Promena nekretnina
	for__loop (new i = kuca; i <= vikendica; i++)
	{
		if (pRealEstate[playerid][i] != -1)
		{
			RE_ChangeOwnerName(re_globalid(i, pRealEstate[playerid][i]), name);
		}
	}

	new query[128];
	
	mysql_format(SQL, query, sizeof query, "DELETE FROM pm WHERE poslao = '%s' OR primalac = '%s'", ime_obicno[playerid]); // fix buga
	mysql_tquery(SQL, query);

	// Update banova ako je igrac admin
	if (IsAdmin(playerid, 1))
	{
		mysql_format(SQL, query, sizeof query, "UPDATE banovi SET admin = '%s' WHERE admin = '%s'", name, ime_obicno[playerid]);
		mysql_tquery(SQL, query);
	}


	mysql_format(SQL, query, sizeof query, "UPDATE crimes SET reporter = '%s' WHERE reporter = '%s'", nameRP, ime_rp[playerid]);   
	mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET ime = '%s' WHERE ime = '%s'", name, ime_obicno[playerid]);
	mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET reload_namechange = %i WHERE id = %i", PI[playerid][p_reload_namechange], PI[playerid][p_id]);
	mysql_tquery(SQL, query);

	// mysql_format(SQL, query, sizeof query, "UPDATE pm SET poslao = '%s' WHERE poslao = '%s'", name, ime_obicno[playerid]);
	// mysql_tquery(SQL, query);

	// mysql_format(SQL, query, sizeof query, "UPDATE pm SET primalac = '%s' WHERE primalac = '%s'", name, ime_obicno[playerid]);
	// mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE trke_info SET postigao = '%s' WHERE postigao = '%s'", nameRP, ime_rp[playerid]);
	mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE vozila SET vlasnik_ime = '%s' WHERE vlasnik_ime = '%s'", name, ime_obicno[playerid]);
	mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE turf_mvp SET player = '%s' WHERE player = '%s'", name, ime_obicno[playerid]);
	mysql_tquery(SQL, query);

	mysql_format(SQL, query, sizeof query, "UPDATE land SET owner = '%s' WHERE owner = '%s'", name, ime_obicno[playerid]);
	mysql_tquery(SQL, query);

	OwnedVehicle_ChangeOwnerName(playerid, name);
	Land_ChangeOwnerName(playerid);

	// Finalna promena imena
	SetPlayerName(playerid, name);
	format(ime_obicno[playerid], MAX_PLAYER_NAME, "%s", name);
	format(ime_rp[playerid], MAX_PLAYER_NAME, "%s", name);
	for__loop (new i = 0; i < strlen(ime_rp[playerid]); i++) {
		if (ime_rp[playerid][i] == '_') {
			ime_rp[playerid][i] = ' ';
			break;
		}
	}
	return 1;
}

RunPunishmentChecker(playerid)
{
	SetTimerEx("CheckOfflinePunishment", 60000, false, "ii", playerid, cinc[playerid]);
}

forward CheckOfflinePunishment(playerid, ccinc);
public CheckOfflinePunishment(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	new sQuery[690];
	format(sQuery, sizeof sQuery, "\
		SELECT i2.ime as admin, acp_kazne.jail, acp_kazne.mute, acp_kazne.fine, acp_kazne.reason FROM acp_kazne \
		LEFT JOIN igraci i1 ON acp_kazne.pid = i1.id \
		LEFT JOIN igraci i2 ON acp_kazne.aid = i2.id \
		WHERE acp_kazne.status = 0 AND acp_kazne.pid = %i", PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery, "MySQL_CheckOfflinePunishment", "ii", playerid, cinc[playerid]);

	return 1;
}

nl_public SpecNextPlayer(playerid)
{
	if (IsPlayerConnected(playerid)) return false;
	if (Iter_Count(Player) == 2) return 1; // samo 2 igraca na serveru

	// Uzima sledeceg igraca iz iteratora ili resetuje na pocetak ako smo dosli do kraja
	gSpectatingPlayer[playerid] = (Iter_Next(Player, gSpectatingPlayer[playerid]) == MAX_PLAYERS)? Iter_First(Player) : Iter_Next(Player, gSpectatingPlayer[playerid]);

	new stopper = 0;
	while__loop (gSpectatingPlayer[playerid] == playerid || (IsAdmin(gSpectatingPlayer[playerid], 6) && !IsAdmin(playerid, 6)) || !IsPlayerConnected(gSpectatingPlayer[playerid]))
	{
		// Uzima sledeceg igraca iz iteratora ili resetuje na pocetak ako smo dosli do kraja
		gSpectatingPlayer[playerid] = (Iter_Next(Player, gSpectatingPlayer[playerid]) == MAX_PLAYERS)? Iter_First(Player) : Iter_Next(Player, gSpectatingPlayer[playerid]);

		stopper++;

		if (stopper > 20) break;
	}
	if (stopper >= 20)
	{
		// Infinite loop -> uncon
		// Na serveru je *verovatno* taj admin + botovi
		TogglePlayerSpectating_H(playerid, false);
		StopSpec(playerid);

		for (new i = 0; i < sizeof(tdSpec); i++)
			TextDrawHideForPlayer(playerid, tdSpec[i]);

		ptdSpec_Destroy(playerid);
		InfoMsg(playerid, "Nema vise igraca koje mozete da posmatrate.");
		return 1;
	}
	else 
	{
		TogglePlayerSpectating_H(playerid, true);
		if (!IsPlayerInAnyVehicle(gSpectatingPlayer[playerid]))
			PlayerSpectatePlayer(playerid, gSpectatingPlayer[playerid], SPECTATE_MODE_NORMAL);
		else 
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(gSpectatingPlayer[playerid]), SPECTATE_MODE_NORMAL);

		SpecUpdate();
	}
	return 1;
}

stock IsPlayerOwner(playerid)
{
	if(gOwner{playerid})
		return true;

	return false;
}

stock UpdateDutyTime(playerid)
{
	if (IsHelper(playerid, 1))
	{
		new sQuery[180], d, m, y;
		getdate(y, m, d);

		format(sQuery, sizeof sQuery, "INSERT INTO staff_activity VALUES (%i, '%i-%02i-%02i', %i, 0) ON DUPLICATE KEY UPDATE dutyTime = dutyTime + %i, pms = pms + %i", PI[playerid][p_id], y, m, d, dutyTimeTotal[playerid], dutyTimeTotal[playerid], GetSentPMsBy(playerid));
		mysql_tquery(SQL, sQuery);

		dutyTimeTotal[playerid] = 0;
	}
}

LogPlayerStaffActivity(playerid)
{
	if (IsHelper(playerid, 1))
	{
		new sQuery[115], d, m, y;
		getdate(y, m, d);

		format(sQuery, sizeof sQuery, "UPDATE staff_activity SET pms = pms + %i WHERE pid = %i AND date = '%i-%02i-%02i'", GetSentPMsBy(playerid), PI[playerid][p_id], y, m, d);
		mysql_tquery(SQL, sQuery);
	}
}

stock StaffDutyEndDay()
{
	if (StaffDayEnded) return 1;

	foreach (new i : Player)
	{
		if (IsOnDuty(i))
		{
			dutyTimeTotal[i] += gettime() - dutyStartTime[i] - dutyAFKTime[i];
			UpdateDutyTime(i);

			dutyStartTime[i] = gettime();
			dutyAFKTime[i] = 0;
		}
	}

	StaffDayEnded = true;
	return 1;
}

forward SpecUpdate(); // Tajmer
public SpecUpdate() // Tajmer
{
	if (Iter_Count(iAdminsSpectating) == 0) 
	{
		KillTimer(tmrSpecUpdate);
	}

	else
	{
		foreach (new i : iAdminsSpectating) 
		{
			if (gSpectatingPlayer[i] == INVALID_PLAYER_ID) 
			{
				Iter_Remove(iAdminsSpectating, i);
				continue;
			}

			if (!IsPlayerConnected(gSpectatingPlayer[i])) 
			{
				// Igrac kojeg posmatra vise nije online, promeni na sledeceg
				SpecNextPlayer(i);
				continue;
			}


			if (GetPlayerInterior(gSpectatingPlayer[i]) != GetPlayerInterior(i) || GetPlayerVirtualWorld(gSpectatingPlayer[i]) != GetPlayerVirtualWorld(i))
			{
				TogglePlayerSpectating_H(i, true);
				SetPlayerInterior(i, GetPlayerInterior(gSpectatingPlayer[i]));
				SetPlayerVirtualWorld(i, GetPlayerVirtualWorld(gSpectatingPlayer[i]));
				if (!IsPlayerInAnyVehicle(gSpectatingPlayer[i]))
					PlayerSpectatePlayer(i, gSpectatingPlayer[i], SPECTATE_MODE_NORMAL);
				else 
					PlayerSpectateVehicle(i, GetPlayerVehicleID(gSpectatingPlayer[i]), SPECTATE_MODE_NORMAL);
			}

			new
				ime_id[MAX_PLAYER_NAME + 6], 
				string[75], 
				Float:health, 
				Float:armour, 
				grupa[7]
			;
			GetPlayerHealth(gSpectatingPlayer[i], health);
			GetPlayerArmour(gSpectatingPlayer[i], armour);
			GetFactionTag(GetPlayerFactionID(gSpectatingPlayer[i]), grupa, sizeof(grupa));

			format(ime_id, sizeof(ime_id), "%s (%d)", ime_rp[gSpectatingPlayer[i]], gSpectatingPlayer[i]);
			PlayerTextDrawSetString(i, PlayerTD[i][ptdSpec][0], ime_id);
			format(string, sizeof(string), "%d~n~$%d~n~$%d~n~%s~n~%i~n~%.1f~n~%.1f~n~%d / %d", PI[gSpectatingPlayer[i]][p_nivo], PI[gSpectatingPlayer[i]][p_novac], PI[gSpectatingPlayer[i]][p_banka], grupa, GetPlayerCrimeLevel(gSpectatingPlayer[i]), health, armour, GetPlayerInterior(gSpectatingPlayer[i]), GetPlayerVirtualWorld(gSpectatingPlayer[i]));
			PlayerTextDrawSetString(i, PlayerTD[i][ptdSpec][1], string);
		}
	}
	return 1;
}

stock IsOnDuty(playerid)
{
	return gStaffDuty{playerid};
}

stock StaffMsg(boja, const fmat[], {Float, _}:...)
{
	#if defined DEBUG_CHAT
		Debug("chat", "StaffMsg");
	#endif

	new
		str[200];
	va_format(str, sizeof (str), fmat, va_start<2>);

	foreach(new i : Player)
		if (IsHelper(i, 1)) SendClientMessage(i, boja, str);
		
	return 1;
}

stock AdminMsg(boja, const fmat[], {Float, _}:...)
{
	#if defined DEBUG_CHAT
		Debug("chat", "AdminMsg");
	#endif
		
	new
		str[180];
	va_format(str, sizeof (str), fmat, va_start<2>);

	foreach(new i : Player)
		if (IsAdmin(i, 1)) SendClientMessage(i, boja, str);

	return 1;
}

stock HeadMsg(boja, const fmat[], {Float, _}:...)
{
	#if defined DEBUG_CHAT
		Debug("chat", "HeadMsg");
	#endif
	
	new
		str[180];
	va_format(str, sizeof (str), fmat, va_start<2>);

	foreach(new i : Player)
		if (IsAdmin(i, 6)) SendClientMessage(i, boja, str);

	return 1;
}

stock IsAdmin(playerid, level) 
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (gHeadAdmin{playerid} == true || PI[playerid][p_admin] >= level || IsPlayerAdmin(playerid) || gOwner{playerid} == true) return 1;
	return 0;
}

stock IsHelper(playerid, level) 
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (gHeadAdmin{playerid} == true || PI[playerid][p_helper] >= level || PI[playerid][p_admin] > 0 || IsPlayerAdmin(playerid)) return 1;
	return 0;
}

stock IsPromoter(playerid, level) 
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (PI[playerid][p_promoter] >= level) return 1;
	return 0;
}

stock IsHeadAdmin(playerid) 
{
	if (!IsPlayerConnected(playerid)) return 0;
	return (gHeadAdmin{playerid} || IsAdmin(playerid, 6) || gOwner{playerid});
}

stock StopSpec(playerid) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("StopSpec");
	}


	if (Iter_Contains(iAdminsSpectating, playerid)) 
	{
		Iter_Remove(iAdminsSpectating, playerid);
		gSpectatingPlayer[playerid] = INVALID_PLAYER_ID;

		if (Iter_Count(iAdminsSpectating) == 0)
			KillTimer(tmrSpecUpdate);
	}

	return 1;
}

stock IsAdminSpectating(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (DebugFunctions())
	{
		LogFunctionExec("IsAdminSpectating");
	}

	if (Iter_Contains(iAdminsSpectating, playerid))
		return 1;
	else
		return 0;
}

forward PutPlayerInJail(playerid, minutes, const reason[]);
public PutPlayerInJail(playerid, minutes, const reason[])
{
	if (!IsPlayerConnected(playerid)) return 0;
	PI[playerid][p_zatvoren] += minutes * 60;
	PI[playerid][p_zavezan] = 0;
	PI[playerid][p_kaznjen_puta] ++;
		
	stavi_u_zatvor(playerid, true);
	format(PI[playerid][p_area_razlog], 32, "%s", reason);

	new query[150];
	format(query, sizeof query, "UPDATE igraci SET kaznjen_puta = %i, area_razlog = '%s' WHERE id = %i", PI[playerid][p_kaznjen_puta], PI[playerid][p_area_razlog], PI[playerid][p_id]);    
	mysql_tquery(SQL, query);
	return 1;
}

stock stavi_u_zatvor(playerid, bool:area = false)
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (DebugFunctions())
	{
		LogFunctionExec("stavi_u_zatvor");
	}

	if(area)
		printf("%s | area", ime_rp[playerid]);

	// Ako je igrac ucesnik trke, resetovati potrebne podatke
	if (IsPlayerInRace(playerid))
	{
		Race_ResetForPlayer(playerid, .respawn = false, .iterRemove = true);
	}
	
	// Resetovanje ostalih podataka
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehicleToRespawn(GetPlayerVehicleID(playerid));
	ResetPlayerWeapons(playerid);


	// Ubacivanje u zatvor
	SetPlayerVirtualWorld(playerid, 10);
	SetPlayerInterior(playerid, 0);
	// SetPlayerCompensatedPos(playerid, 107.2300, 1920.6311, 18.5208);
	SetPlayerCompensatedPos(playerid, 3019.1174,-2859.4656,11.0847);
	return 1;
}



// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_unban(playerid, ime[], ccinc);
forward mysql_offban(playerid, duration, mins_days[7], ime[MAX_PLAYER_NAME], razlog[], ccinc);
forward mysql_baninfo(returnid, ccinc);
forward mysql_generisi_pin(returnid, ccinc, ime[MAX_PLAYER_NAME]);
forward mysql_provera_ip(playerid, param[MAX_PLAYER_NAME], vrsta);
forward mysql_multi_provera(playerid, param[32], vrsta, ccinc);

forward MySQL_OnResetPin(playerid, ccinc, const sPlayerName[], pin);
public MySQL_OnResetPin(playerid, ccinc, const sPlayerName[], pin)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	if (!cache_affected_rows())
		return ErrorMsg(playerid, "Uneo si pogresno ime.");

	SendClientMessageF(playerid, SVETLOPLAVA, "* PIN je uspesno promenjen za igraca %s. Novi PIN: {FFFFFF}%i", sPlayerName, pin);
	return 1;
}

forward MySQL_OnResetPassword(playerid, ccinc, const sPlayerName[], const sPassword[], const pw[]);
public MySQL_OnResetPassword(playerid, ccinc, const sPlayerName[], const sPassword[], const pw[])
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	if (!cache_affected_rows())
		return ErrorMsg(playerid, "Uneo si pogresno ime.");

	SendClientMessageF(playerid, SVETLOPLAVA, "* Lozinka je uspesno promenjena za igraca %s. Nova lozinka: {FFFFFF}%s", sPlayerName, pw);
	return 1;
}

forward MySQL_VeifyNameChange(playerid, ccinc, const name[]);
public MySQL_VeifyNameChange(playerid, ccinc, const name[])
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows) ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new count;
	cache_get_value_index_int(0, 0, count);
	if (count != 0)
		return ErrorMsg(playerid, "Vec je registrovan igrac sa tim imenom.");

	if (PI[playerid][p_novac] < 15000000)
		return ErrorMsg(playerid, "Nemate dovoljno novca.");

	PlayerMoneySub(playerid, 15000000);
	SendClientMessageF(playerid, SVETLOPLAVA, "Platili ste $15.000.000 za promenu imena: {FFFFFF}%s » %s.", ime_obicno[playerid], name);
	SendClientMessage(playerid, BELA, "* Narednih 30 dana necete moci da promenite ime.");

	PI[playerid][p_reload_namechange] = gettime() + 30*86400;

	ProcessNameChange(playerid, name);
	return 1;
}

forward MySQL_StatsRestore(playerid, ccinc, level, cash, const playerName[]);
public MySQL_StatsRestore(playerid, ccinc, level, cash, const playerName[])
{
	if (!checkcinc(playerid, ccinc)) return 1;

	if (cache_affected_rows() == 0)
	{
		Log_Write(LOG_STATSRESTORE, "* Neuspesno (igrac ne postoji)");
		return ErrorMsg(playerid, "Igrac %s nije pronadjen u bazi podataka ili je veci nivo od 8.", playerName);
	}

	SendClientMessageF(playerid, SVETLOPLAVA, "Vratili ste stats offline igracu %s: level %i + %s", playerName, level, formatMoneyString(cash));
	return 1;
}

forward MySQL_CheckOfflinePunishment(playerid, ccinc);
public MySQL_CheckOfflinePunishment(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc) || !IsPlayerLoggedIn(playerid)) return 1;

	cache_get_row_count(rows);
	if (rows)
	{
		new jailTime = 0,
			muteTime = 0,
			fine = 0,
			admin[MAX_PLAYER_NAME],
			reason[32];

		if (rows == 1)
		{
			cache_get_value_index(0, 0, admin, sizeof admin);
			cache_get_value_index_int(0, 1, jailTime);
			cache_get_value_index_int(0, 2, muteTime);
			cache_get_value_index_int(0, 3, fine);
			cache_get_value_index(0, 4, reason, sizeof reason);

			new sDialog[275];
			format(sDialog, sizeof sDialog, "{FFFFFF}Postavljena ti je kazna dok si bio offline:\n\n\
				Alcatraz {FFFF00}[%i min]  {FFFFFF}Mute {FFFF00}[%i min]  {FFFFFF}Novcana kazna: {FFFF00}[-%s]\n\
				{FFFFFF}Razlog: {FF9900}%s\n\
				{FFFFFF}Admin: {FF9900}%s", jailTime, muteTime, formatMoneyString(fine), reason, admin);
			SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Offline kazna", sDialog, "U redu", "");

			PunishPlayer(playerid, INVALID_PLAYER_ID, jailTime, muteTime, fine, false, "Prijava na forumu");
		}
		else
		{
			new sDialog[275 * 5]; // prostora za oko 5 kazni
			format(sDialog, sizeof sDialog, "{FFFFFF}Postavljeno ti je {FF0000}%i {FFFFFF}kazni dok si bio offline.", rows);

			for__loop (new i = 0; i < rows; i++)
			{
				new jailTemp, muteTemp, fineTemp;
				cache_get_value_index(i, 0, admin, sizeof admin);
				cache_get_value_index_int(i, 1, jailTemp);
				cache_get_value_index_int(i, 2, muteTemp);
				cache_get_value_index_int(i, 3, fineTemp);
				cache_get_value_index(i, 4, reason, sizeof reason);

				jailTime += jailTemp;
				muteTime += muteTemp;
				fine += fineTemp;

				format(sDialog, sizeof sDialog, "%s\n\n\
					Alcatraz {FFFF00}[%i min]  {FFFFFF}Mute {FFFF00}[%i min]  {FFFFFF}Novcana kazna: {FFFF00}[-%s]\n\
					{FFFFFF}Razlog: {FF9900}%s\n\
					{FFFFFF}Admin: {FF9900}%s", sDialog, jailTemp, muteTemp, formatMoneyString(fineTemp), reason, admin);
			}

			format(sDialog, sizeof sDialog, "%s\n\n{FFFFFF}---------\n\nAlcatraz {FF9900}[%i min]  {FFFFFF}Mute {FF9900}[%i min]  {FFFFFF}Novcana kazna: {FF9900}[-%s]", sDialog, jailTime, muteTime, formatMoneyString(fine));
			SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Offline kazna", sDialog, "U redu", "");

			PunishPlayer(playerid, INVALID_PLAYER_ID, jailTime, muteTime, fine, false, "Prijava na forumu");
		}

		new sQuery[50];
		format(sQuery, sizeof sQuery, "UPDATE acp_kazne SET status = 1 WHERE pid = %i", PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery);
	}
	return 1;
}

forward mysql_staff_list(playerid, ccinc, thread);
public mysql_staff_list(playerid, ccinc, thread)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows) return 1;

	if (thread == THREAD_ADMINI || thread == THREAD_HELPERI || thread == THREAD_PROMOTERI)
	{
		new dStr[750], level, ime[MAX_PLAYER_NAME], last_act[22];
		format(dStr, 31, "Ime\tNivo\tPoslednja aktivnost");
		for__loop (new i = 0; i < rows; i++)
		{
			cache_get_value_index(i, 0, ime, sizeof ime);
			cache_get_value_index_int(i, 1, level);
			cache_get_value_index(i, 2, last_act, sizeof last_act);

			format(dStr, sizeof dStr, "%s\n%s\t%i\t%s", dStr, ime, level, last_act);
		}

		if (thread == THREAD_ADMINI)
		{
			SPD(playerid, "staff_list_admini", DIALOG_STYLE_TABLIST_HEADERS, "{33CCFF}SPISAK ADMINA", dStr, "Aktivnost", "Nazad");
		}
		else if (thread == THREAD_HELPERI)
		{
			SPD(playerid, "staff_list_helperi", DIALOG_STYLE_TABLIST_HEADERS, "{00FF00}SPISAK HELPERA", dStr, "Aktivnost", "Nazad");
		}
		else if (thread == THREAD_PROMOTERI)
		{
			SPD(playerid, "staff_list_promoteri", DIALOG_STYLE_TABLIST_HEADERS, "{AF28A4}SPISAK PROMOTERA", dStr, "Nazad", "");
		}
	}

	else if (thread == THREAD_VIP)
	{
		new dStr[1024], ime[MAX_PLAYER_NAME], vipLevel, vipExp, vipDays, vipHrs, vipName[9], expStr[20];
		format(dStr, 23, "Ime\tPaket\tIstice za");
		for__loop (new i = 0; i < rows; i++)
		{
			cache_get_value_index(i, 0, ime, sizeof ime);
			cache_get_value_index_int(i, 1, vipLevel);
			cache_get_value_index_int(i, 2, vipExp);

			vipExp -= gettime();
			vipDays = floatround(vipExp/86400, floatround_floor);
			vipHrs = floatround((vipExp - vipDays*86400)/3600, floatround_floor);
			VIP_GetPackageName(vipLevel, vipName, sizeof vipName);

			if (vipExp <= 0) format(expStr, sizeof expStr, "istekao");
			else format(expStr, sizeof expStr, "%i dana, %i sati", vipDays, vipHrs);
			format(dStr, sizeof dStr, "%s\n%s\t%d\t%s", dStr, ime, vipName, expStr);
		}

		SPD(playerid, "staff_list_vip", DIALOG_STYLE_TABLIST_HEADERS, "{AF28A4}SPISAK VIP IGRACA", dStr, "Nazad", "");
	}

	else if (thread == THREAD_DJ)
	{
		new dStr[600], ime[MAX_PLAYER_NAME], poslednja_aktivnost[22];
		format(dStr, 23, "Ime\tPoslednja aktivnost");
		for__loop (new i = 0; i < rows; i++)
		{
			cache_get_value_index(i, 0, ime, sizeof ime);
			cache_get_value_index(i, 1, poslednja_aktivnost, sizeof poslednja_aktivnost);

			format(dStr, sizeof dStr, "%s\n%s\t%s", dStr, ime, poslednja_aktivnost);
		}

		SPD(playerid, "staff_list_dj", DIALOG_STYLE_TABLIST_HEADERS, "{FF9900}SPISAK DJ-eva", dStr, "Smeni", "Nazad");
	}
	return 1;
}

forward mysql_staff_aktivnost(playerid, ccinc, thread);
public mysql_staff_aktivnost(playerid, ccinc, thread)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows) return 1;

	new dStr[750], level, ime[MAX_PLAYER_NAME], last_act[22];
	if (thread == THREAD_PROMOTERI)
	{
		format(dStr, sizeof dStr, "Ime\tNivo\tPoslednji zahtev");
	}
	else
	{
		format(dStr, sizeof dStr, "Ime\tNivo\tPoslednja aktivnost");
	}
	for__loop (new i = 0; i < rows; i++)
	{
		cache_get_value_index(i, 0, ime, sizeof ime);
		cache_get_value_index_int(i, 1, level);
		cache_get_value_index(i, 2, last_act, sizeof last_act);

		format(dStr, sizeof dStr, "%s\n%s\t%d\t%s", dStr, ime, level, last_act);
	}

	if (thread == THREAD_ADMINI)
	{
		SPD(playerid, "staff_list_admini", DIALOG_STYLE_TABLIST_HEADERS, "{33CCFF}AKTIVNOST ADMINA", dStr, "Nazad", "");
	}
	else if (thread == THREAD_HELPERI)
	{
		SPD(playerid, "staff_list_helperi", DIALOG_STYLE_TABLIST_HEADERS, "{00FF00}AKTIVNOST HELPERA", dStr, "Nazad", "");
	}
	else if (thread == THREAD_PROMOTERI)
	{
		SPD(playerid, "staff_list_promoteri", DIALOG_STYLE_TABLIST_HEADERS, "{AF28A4}AKTIVNOST PROMOTERA", dStr, "Nazad", "");
	}

	return 1;
}

forward mysql_smeni(playerid, ccinc, thread);
public mysql_smeni(playerid, ccinc, thread)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows) return 1;

	new dStr[512], level, ime[MAX_PLAYER_NAME];
	format(dStr, sizeof dStr, "Ime\tNivo");
	for__loop (new i = 0; i < rows; i++)
	{
		cache_get_value_index(i, 0, ime, sizeof ime);
		cache_get_value_index_int(i, 1, level);

		format(dStr, sizeof dStr, "%s\n%s\t%d", dStr, ime, level);
	}

	SPD(playerid, "staff_smeni", DIALOG_STYLE_TABLIST_HEADERS, "Staff smena", dStr, "Smeni", "Izadji");
	return 1;
}

forward MySQL_OffProvera(playerid, ccinc);
public MySQL_OffProvera(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc) || !IsAdmin(playerid, 1)) return 1;

	cache_get_row_count(rows);
	if (rows != 1)
		return ErrorMsg(playerid, "Igrac sa tim imenom nije pronadjen u bazi podataka.");

	new ime[MAX_PLAYER_NAME], id, nivo, iskustvo, novac, banka, opomene, provedeno_vreme,
		kaznjen_puta, org_id, drzava[20], email[MAX_EMAIL_LEN], 
		_kuca, _stan, _firma, _garaza, _hotel,
		last_act[22], reg_datum[22], org[8], ip[16],
		kuca_str[5], stan_str[5], firma_str[32], garaza_str[5], hotel_str[5];

	cache_get_value_name(0, "ime", ime, sizeof ime);
	cache_get_value_name_int(0, "id", id);
	cache_get_value_name_int(0, "nivo", nivo);
	cache_get_value_name_int(0, "iskustvo", iskustvo);
	cache_get_value_name_int(0, "novac", novac);
	cache_get_value_name_int(0, "banka", banka);
	cache_get_value_name_int(0, "opomene", opomene);
	cache_get_value_name_int(0, "kaznjen_puta", kaznjen_puta);
	cache_get_value_name_int(0, "org_id", org_id);
	cache_get_value_name_int(0, "kuca", _kuca);
	cache_get_value_name_int(0, "stan", _stan);
	cache_get_value_name_int(0, "firma", _firma);
	cache_get_value_name_int(0, "garaza", _garaza);
	cache_get_value_name_int(0, "hotel", _hotel);
	cache_get_value_name_int(0, "provedeno_vreme", provedeno_vreme);
	cache_get_value_name(0, "drzava", drzava);
	cache_get_value_name(0, "email", email);
	cache_get_value_name(0, "last_act", last_act);
	cache_get_value_name(0, "reg_date", reg_datum);
	cache_get_value_name(0, "ip", ip, sizeof ip);

	GetFactionTag(org_id, org, sizeof org);


	// Formatiranje stringova za nekretnine
	if (_kuca == -1)
		kuca_str = "Nema";
	else
		valstr(kuca_str, _kuca);

	if (_stan == -1)
		stan_str = "Nema";
	else
		valstr(stan_str, _stan);

	if (_firma == -1)
		firma_str = "Nema";
	else
		format(firma_str, sizeof firma_str, "%d (%s)", _firma, vrstafirme(RealEstate[re_globalid(firma, _firma)][RE_VRSTA], PROPNAME_CAPITAL));

	if (_garaza == -1)
		garaza_str = "Nema";
	else
		valstr(garaza_str, _garaza);

	if (_hotel == -1)
		hotel_str = "Nema";
	else
		valstr(hotel_str, _hotel);

	SendClientMessageF(playerid, CRVENA, "_________ ** {FFFFFF}%s[%i] {FF0000}** {FFFFFF}%s {FF0000} ** _____________________________________________", ime, id, trenutno_vreme());
	SendClientMessageF(playerid, 0xFFFFFFFF, "Nivo: [%d] Iskustvo: [%d/%d] Novac: [%s] Banka: [%s]", nivo, iskustvo, GetNextLevelExp(nivo), formatMoneyString(novac), formatMoneyString(banka));
	SendClientMessageF(playerid, 0xCECECEFF, "Opomene: [%d/5] Kaznjen: [%d puta] Grupa: [%s]", opomene, kaznjen_puta, org);
	SendClientMessageF(playerid, 0xFFFFFFFF, "Datum registracije: [%s] Vreme u igri: [%.1f sati] Poslednja aktivnost: [%s]", reg_datum, floatdiv(provedeno_vreme, 3600.0), last_act);
	SendClientMessageF(playerid, 0xCECECEFF, "Drzava: [%s] Email: [%s] Poslednji IP: [%s]",  drzava, email, ip);
	SendClientMessageF(playerid, 0xFFFFFFFF, "Kuca: [%s]   Stan: [%s]   Firma: [%s]   Garaza: [%s]   Hotel: [%s] ", kuca_str, stan_str, firma_str, garaza_str, hotel_str);

	return 1;
}

forward MySQL_OnAdminsSelected(playerid, ccinc);
public MySQL_OnAdminsSelected(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	SendClientMessage(playerid, PLAVA,    "_______________ Game Admini _______________");

	for__loop (new i = 0; i < rows; i++)
	{
		new ime[MAX_PLAYER_NAME], nivo;
		cache_get_value_index(i, 0, ime, sizeof ime);
		cache_get_value_index_int(i, 1, nivo);

		if (nivo == 0) continue;
		new id = GetPlayerIDFromName(ime);

		if (IsPlayerConnected(id))
		{
			if (IsPlayerAFK(id))
			{
				SendClientMessageF(playerid, PLAVA, "Admin: {FFFFFF}%s | {1275ED}Nivo: {FFFFFF}%d | {FF9900}[AFK %s]", ime, nivo, konvertuj_vreme(GetPlayerAFKTime(id)));
			}
			else 
			{
				SendClientMessageF(playerid, PLAVA, "Admin: {FFFFFF}%s | {1275ED}Nivo: {FFFFFF}%d | {00FF00}[ONLINE]", ime, nivo);
			}
		}
		else
		{
			SendClientMessageF(playerid, PLAVA, "Admin: {FFFFFF}%s | {1275ED}Nivo: {FFFFFF}%d | {FF0000}[OFFLINE]", ime, nivo);
		}
	}
	return 1;
}

forward MySQL_OnHelpersSelected(playerid, ccinc);
public MySQL_OnHelpersSelected(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	SendClientMessage(playerid, ZELENOZUTA,   "_______________ Helperi _______________");

	for__loop (new i = 0; i < rows; i++)
	{
		new ime[MAX_PLAYER_NAME], nivo;
		cache_get_value_index(i, 0, ime, sizeof ime);
		cache_get_value_index_int(i, 1, nivo);

		if (nivo == 0) continue;
		new id = GetPlayerIDFromName(ime);

		if (IsPlayerConnected(id))
		{
			if (IsPlayerAFK(id))
			{
				SendClientMessageF(playerid, ZELENOZUTA, "Helper: {FFFFFF}%s | {8EFF00}Nivo: {FFFFFF}%d | {FF9900}[AFK %s]", ime, nivo, konvertuj_vreme(GetPlayerAFKTime(id)));
			}
			else 
			{
				SendClientMessageF(playerid, ZELENOZUTA, "Helper: {FFFFFF}%s | {8EFF00}Nivo: {FFFFFF}%d | {00FF00}[ONLINE]", ime, nivo);
			}
		}
		else
		{
			SendClientMessageF(playerid, ZELENOZUTA, "Helper: {FFFFFF}%s | {8EFF00}Nivo: {FFFFFF}%d | {FF0000}[OFFLINE]", ime, nivo);
		}
	}
	return 1;
}

public mysql_unban(playerid, ime[], ccinc) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_unban");
	}

	if (!checkcinc(playerid, ccinc)) return 1;
	
	if (cache_affected_rows() == 0) 
		return ErrorMsg(playerid, "Igrac sa tim imenom nije pronadjen u nasoj bazi podataka!");
	
	// Slanje poruke adminima
	AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je odbanovao igraca %s.", ime_rp[playerid], ime);
	
	// Upisivanje u log
	format(string_128, 80, "UNBAN | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime);
 	Log_Write(LOG_BAN, string_128);
	return 1;
}

public mysql_offban(playerid, duration, mins_days[7], ime[MAX_PLAYER_NAME], razlog[], ccinc) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_offban");
	}

	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows) 
		return ErrorMsg(playerid, "Igrac sa tim imenom nije pronadjen u bazi podataka.");
	
	new id, banExpirationTime;
	cache_get_value_index_int(0, 0, id);
	
	// --- iz /ban komande, izmenjeno ---
	if (!strcmp(mins_days, "minuta", true) || !strcmp(mins_days, "min", true)) 
	{
		banExpirationTime = gettime() + (duration * 60);
	}
	else if (!strcmp(mins_days, "dana", true)) 
	{
		banExpirationTime = gettime() + (duration * 24 * 60 * 60);
	}
	else
		return ErrorMsg(playerid, "Nevazeci unos za minute/dane. Upisite /offban (bez parametara) za vise informacija. (mysql_offban)");

	if (duration == 0)
	{
		banExpirationTime = gettime() + (1000 * 24 * 60 * 60); // ban 1000 dana (perm)
	}
 	
 	// Slanje dodatnih informacija adminu koji je dao ban:
	SendClientMessage(playerid, CRVENA, 		"______________________________________________________________________________");
 	SendClientMessageF(playerid, SVETLOCRVENA,"Informacije o iskljucenju %s (id %d):", ime, id);
	SendClientMessageF(playerid, BELA,        "Razlog iskljucenja: %s", razlog);
	SendClientMessageF(playerid, BELA,        "Trajanje: %d %s | Trenutno vreme: %s", duration, mins_days, trenutno_vreme());
 	
 	// Slanje poruke staffu:
 	if (duration > 0) 
	{
 		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je banovan od %s na %d %s, razlog: %s (offban).", ime, ime_obicno[playerid], duration, mins_days, razlog);
	}
 	else 
	{
 		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je trajno banovan od %s, razlog: %s (offban).", ime, ime_obicno[playerid], razlog);
	}
 	
 	// Upisivanje u log
 	format(string_256, sizeof string_256, "OFFBAN | Izvrsio: %s | Igrac: %s | Trajanje: %s | Razlog: %s", ime_obicno[playerid], ime, string_32, razlog);
 	Log_Write(LOG_BAN, string_256);

	// Brisanje prethodnog unosa ako je igrac vec bio banovan
	format(mysql_upit, sizeof mysql_upit, "DELETE FROM banovi WHERE pid = '%d'", id);
	mysql_tquery(SQL, mysql_upit);
 	
 	// Upisivanje u bazu
 	format(mysql_upit, sizeof mysql_upit, "INSERT INTO banovi (pid, admin, razlog, istice, offban) VALUES (%d, '%s', '%s', FROM_UNIXTIME(%d), 1)", id, ime_obicno[playerid], razlog, banExpirationTime);
	//mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_BANPLAYER);
	mysql_tquery(SQL, mysql_upit);
	return 1;
}

public mysql_baninfo(returnid, ccinc) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_baninfo");
	}

	if (!checkcinc(returnid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(returnid, "Nisu pronadjene nikakve informacije o tom igracu. Proverite da li ste uneli tacno ime. Ban je mozda istekao.");
		
	new 
		baninfo_id,
		baninfo_ime[MAX_PLAYER_NAME],
		baninfo_admin[MAX_PLAYER_NAME],
		baninfo_razlog[32],
		baninfo_datum[23],
		baninfo_istice[23],
		baninfo_offban;

	cache_get_value_name_int(0, "id",       baninfo_id);
	cache_get_value_name_int(0, "offban",   baninfo_offban);
	cache_get_value_name(0,     "admin",    baninfo_admin);
	cache_get_value_name(0,     "razlog",   baninfo_razlog);
	cache_get_value_name(0,     "datum",    baninfo_datum);
	cache_get_value_name(0,     "istice",   baninfo_istice);
	cache_get_value_name(0,     "ime",      baninfo_ime);

	SendClientMessageF(returnid, CRVENA,     "______________________________________________________________________________");
	SendClientMessageF(returnid, BELA,       "Ban: #%d | Igrac: %s | Admin: %s", baninfo_id, baninfo_ime, baninfo_admin);
	SendClientMessageF(returnid, BELA,       "Razlog iskljucenja: %s", baninfo_razlog);
	SendClientMessageF(returnid, BELA,       "Iskljucenje istice: %s", baninfo_istice);
	SendClientMessageF(returnid, BELA,       "Datum i vreme bana: %s | Trenutno vreme: %s", baninfo_datum, trenutno_vreme());
	if (baninfo_offban == 1)
		SendClientMessage(returnid, SVETLOCRVENA, "Napomena: {FFFFFF}Ovaj nalog je iskljucen dok je igrac bio odsutan sa servera!");
	
	return 1;
}

public mysql_generisi_pin(returnid, ccinc, ime[MAX_PLAYER_NAME]) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_generisi_pin");
	}

	if (!checkcinc(returnid, ccinc)) return 1;		
		
	cache_get_row_count(rows);
	if (!rows) 
		return ErrorMsg(returnid, "Nema takvog igraca u bazi podataka.");
		
	if (rows > 1) 
		return SendClientMessage(returnid, TAMNOCRVENA2, "[admin.pwn] "GRESKA_NEPOZNATO" (01)");
		
		
	new 
		id,
		pin = 10000+random(89999);
	
	cache_get_value_index_int(0, 0, id);
	
	
	// Update podataka u bazi
 	format(mysql_upit, sizeof mysql_upit, "UPDATE staff SET pin = %d WHERE pid = %d", pin, id);
 	mysql_tquery(SQL, mysql_upit);
	
	// Slanje poruke igracu
	format(string_128, sizeof string_128, "* Novi pin za %s je uspesno generisan: {FFFFFF}%d", ime, pin);
	SendClientMessage(returnid, SVETLOPLAVA, string_128);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Promenio: %s | Adminu: %s", ime_obicno[returnid], ime);
	Log_Write(LOG_PROMENA_PINA, string_128);
	return 1;
}

public mysql_multi_provera(playerid, param[32], vrsta, ccinc) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_multi_provera");
	}

	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (!rows) return 1;
	if (vrsta == 1) {
		format(string_128, sizeof string_128, "Igraci sa istom lozinkom kao %s:", param);
		SendClientMessage(playerid, ZUTA, string_128);
	}
	else {
		format(string_64, 64, "Igraci sa lozinkom \"%s\":", param);
		SendClientMessage(playerid, ZUTA, string_64);
	}

	string_128[0] = EOS;
	for__loop (new i = 0, x = 0; i < rows; i++) 
	{
		cache_get_value_index(i, 0, param);
		
   		x++;
		if (x < 4)
		{
			if (x < 3) strins(string_128, param, strlen(string_128)), strins(string_128, ", ", strlen(string_128));
			else strins(string_128, param, strlen(string_128));
		}
		else SendClientMessage(playerid, BELA, string_128), strmid(string_128, param, 0, strlen(param), 128), strins(string_128, ", ", strlen(string_128)), x = 0;
	}

	new len = strlen(string_128);
	//if (!strcmp(string_128[len], " ")) strdel(string_128, len-2, len);
	if (string_128[len - 1] == ' ') strdel(string_128, len-2, len);
	SendClientMessage(playerid, BELA, string_128);

	return 1;
}

public mysql_provera_ip(playerid, param[MAX_PLAYER_NAME], vrsta)
{
	if(vrsta == 1 || vrsta == 3)
	{
		print("vrsta 1");
		new
			ipadress[24 + 1]
		;

		cache_get_value_index(0, 0, ipadress, sizeof ipadress);
		printf("ip %s", ipadress);
		if(vrsta == 1)
		{
			format(mysql_upit, sizeof mysql_upit, "SELECT ime, datum_registracije FROM igraci WHERE ip = '%s'", ipadress);
			mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, ipadress, 2);
		}
		else
		{
			format(mysql_upit, sizeof mysql_upit, "SELECT ime, datum_registracije, ip FROM igraci WHERE 1");
			mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, ipadress, 4);
		}
	}
	else if(vrsta == 2 || vrsta == 4)
	{
		print("vrsta 2");
		cache_get_row_count(rows);

		new
			name[MAX_PLAYER_NAME + 1],
			registerdate[19 + 1],
			string[128 * 15 + 1],
			usersip[24 + 1],
			checkip[4][5],
			cip[8],
			ippart[4][5],
			uip[8]
		;
		
		sscanf(param, "p<.>s[5]s[5]s[5]s[5]", checkip[0], checkip[1], checkip[2], checkip[3]);
		format(cip, sizeof cip, "%s.%s", checkip[0], checkip[1]);

		string[0] = EOS;
		format(string, sizeof string, "Ime_Prezime\tIP adresa\tDatum registracije{D1D1D1}");
		
		for(new i = 0; i < rows; i++)
		{
			cache_get_value_index(i, 0, name, sizeof name);
			cache_get_value_index(i, 1, registerdate, sizeof registerdate);
			printf("name %s | reg %s", name, registerdate);
			
			if(vrsta == 2)
			{
				format(string, sizeof string, "%s\n%s\t%s\t( %s )", string, name, param, registerdate);
			}
			else
			{
				cache_get_value_index(i, 2, usersip, sizeof usersip);

				sscanf(usersip, "p<.>s[4]s[4]s[4]s[4]", ippart[0], ippart[1], ippart[2], ippart[3]);
				format(uip, sizeof uip, "%s.%s", ippart[0], ippart[1]);

				if(strcmp(uip, cip, true))
				{
					format(string, sizeof string, "%s\n%s\t%s\t( %s )", string, name, usersip, registerdate);
				}
			}
		}

		if(vrsta == 2)
			SPD(playerid, "IPCheck", DIALOG_STYLE_TABLIST_HEADERS, "Svi korisnici sa istom IP adresom.", string, "Ok", "");
		else
			SPD(playerid, "IPCheck", DIALOG_STYLE_TABLIST_HEADERS, "Svi korisnici sa slicnom IP adresom.", string, "Ok", "");
	}

	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:punishment_prompt(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		// NE

		DeletePVar(playerid, "punishTargetID");
		DeletePVar(playerid, "punishTargetCinc");
		DeletePVar(playerid, "punishTimeout");
		DeletePVar(playerid, "punishJailTime");
		DeletePVar(playerid, "punishMuteTime");
		DeletePVar(playerid, "punishFine");
		DeletePVar(playerid, "punishReason");
	}

	else
	{
		// DA
		new targetid = GetPVarInt(playerid, "punishTargetID"),
			tcinc = GetPVarInt(playerid, "punishTargetCinc"),
			timeout = GetPVarInt(playerid, "punishTimeout"),
			jailTime = GetPVarInt(playerid, "punishJailTime"),
			muteTime = GetPVarInt(playerid, "punishMuteTime"),
			finePercentage = GetPVarInt(playerid, "punishFine"),
			reason[32]
		;
		GetPVarString(playerid, "punishReason", reason, sizeof reason);

		DeletePVar(playerid, "punishTargetID");
		DeletePVar(playerid, "punishTargetCinc");
		DeletePVar(playerid, "punishTimeout");
		DeletePVar(playerid, "punishJailTime");
		DeletePVar(playerid, "punishMuteTime");
		DeletePVar(playerid, "punishFine");
		DeletePVar(playerid, "punishReason");

		if (!IsPlayerConnected(targetid) || !checkcinc(targetid, tcinc))
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (timeout < gettime())
			return ErrorMsg(playerid, "Isteklo je vreme za odgovor. Igrac nije kaznjen.");

		PunishPlayer(targetid, INVALID_PLAYER_ID, jailTime, muteTime, finePercentage, false, reason);
	}
	return 1;
}

Dialog:fv_request(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (PI[playerid][p_reload_fv] > gettime())
			return ErrorMsg(playerid, "Narednu popravku mozete dobiti za %i minuta.", floatround((PI[playerid][p_reload_fv]-gettime())/60.0, floatround_ceil));

		if (PI[playerid][p_nivo] > 10 && !IsNewPlayer(playerid) && PI[playerid][p_novac] < 5000)
			return ErrorMsg(playerid, "Nemate dovoljno novca.");

		if (!IsPlayerInAnyVehicle(playerid))
			return ErrorMsg(playerid, "Niste u vozilu.");

		new Float:health,
			vehicleid = GetPlayerVehicleID(playerid);
		GetVehicleHealth(vehicleid, health);

		if (GetPlayerCrimeLevel(playerid) >= 3)
			return ErrorMsg(playerid, "Nemate pravo na popravku vozila jer imate wanted level 3+.");

		if (RecentPoliceInteraction(playerid))
			return ErrorMsg(playerid, "Nemate pravo na popravku vozila jer ste nedavno imali interakciju sa policijom. (anti abuse)");
		

		PlayerMoneySub(playerid, ((PI[playerid][p_nivo] <= 10 || IsNewPlayer(playerid))? (0) : (5000)));

		new engine, lights, alarm, doors, bonnet, boot, objective;
		RepairVehicle(vehicleid);
		SetVehicleHealth(vehicleid, 500.0);
		
		// Pali vozilo ako je bilo ugaseno jer je bilo mnogo osteceno
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);

		InfoMsg(playerid, "Vozilo je popravljeno.");

		PI[playerid][p_reload_fv] = gettime() + 20*60;

		new sQuery[61];
		format(sQuery, sizeof sQuery, "UPDATE igraci SET reload_fv = %i WHERE id = %i", PI[playerid][p_reload_fv], PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery);
	}
	return 1;
}

Dialog:port(playerid, response, listitem, const inputtext[]) // Teleport na lokaciju
{
	if (!response)
	{
		if (GetPVarInt(playerid, "vipOverride") == 1)
		{
			callcmd::vip(playerid, "");
		}
	}
	else if (response)
	{
		callcmd::tp(playerid, inputtext);
	}

	return 1;
}

Dialog:utisaj(playerid, response, listitem, const inputtext[]) // Utisavanje
{
	if (!response) 
		return 1;

	if (!IsAdmin(playerid, 1)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new 
		id = GetPVarInt(playerid, "aKaznaID"),
		razlog[32];

	if (!checkcinc(id, GetPVarInt(playerid, "aKaznaCinc"))) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "Igrac je napustio server.");

	if (PI[id][p_utisan] <= 5) 
		return ErrorMsg(playerid, "Taj igrac nije utisan ili mu je ostalo manje od 5 sekundi, pokusajte ponovo.");

	PI[id][p_utisan] += GetPVarInt(playerid, "aKaznaVreme")*60;
	PI[id][p_kaznjen_puta]++;
	GetPVarString(playerid, "aKaznaRazlog", razlog, sizeof razlog);
	SetPlayerChatBubble(id, "(( Ovaj igrac je UTISAN ))", 0xFF0000AA, 15.0, PI[id][p_utisan]*1000);

	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Utisani ste na %d minuta od Game Admina %s | Preostalo: %s", GetPVarInt(playerid, "aKaznaVreme"), ime_rp[playerid], konvertuj_vreme(PI[id][p_utisan], true));
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je utisao igraca %s[ID: %d] na %d minuta | Preostalo: %s", ime_rp[playerid], ime_rp[id], id, GetPVarInt(playerid, "aKaznaVreme"), konvertuj_vreme(PI[id][p_utisan], true));
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
  	
	// Update podataka u bazi
  	format(mysql_upit, 75, "UPDATE igraci SET utisan = %d, kaznjen_puta = %d WHERE id = %d", PI[id][p_utisan], PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, mysql_upit);

	// Insert u kazne
	format(mysql_upit, sizeof mysql_upit, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'MUTE', '%s', %d)", PI[id][p_id], razlog, GetPVarInt(playerid, "aKaznaVreme"));
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Upisivanje u log
	format(string_256, 180, "MUTE | Izvrsio: %s | Igrac: %s | Vreme: + %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], GetPVarInt(playerid, "aKaznaVreme"), razlog);
 	Log_Write(LOG_KAZNE, string_256);

	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste utisali je previse mali nivo! Da opozovete akciju, koristite /utisaj.");
	return 1;
}

/*Dialog:area(playerid, response, listitem, const inputtext[]) 
{
	if (!response) 
		return 1;
		
	if (!IsAdmin(playerid, 4)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	new 
		id = GetPVarInt(playerid, "aKaznaID"),
		razlog[32];

	if (!checkcinc(id, GetPVarInt(playerid, "aKaznaCinc"))) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "Igrac je napustio server.");
		
	if (PI[id][p_zatvoren] <= 5 || PI[id][p_area] <= 5) 
		return ErrorMsg(playerid, "Taj igrac nije zatvoren ili mu je ostalo manje od 5 sekundi, pokusajte ponovo.");
		
		
   	PI[id][p_kaznjen_puta]++;
	PI[id][p_area] += GetPVarInt(playerid, "aKaznaVreme")*60;
	GetPVarString(playerid, "aKaznaRazlog", razlog, sizeof razlog);
	
	// Univerzalni kod za stavljanje igraca u zatvor
	stavi_u_zatvor(playerid, true);
	
	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Zatvoreni ste na %d minuta od Game Admina %s | Preostalo: %s", GetPVarInt(playerid, "aKaznaVreme"), ime_rp[playerid], konvertuj_vreme(PI[id][p_area], true));
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je zatvorio igraca %s[ID: %d] na %d minuta | Preostalo: %s", ime_rp[playerid], ime_rp[id], id, GetPVarInt(playerid, "aKaznaVreme"), konvertuj_vreme(PI[id][p_area], true));
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET area = %d, kaznjen_puta = %d WHERE id = %d", PI[id][p_area], PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, mysql_upit);

	// Insert u kazne
	format(mysql_upit, sizeof mysql_upit, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'AREA', '%s', %d)", PI[id][p_id], razlog, GetPVarInt(playerid, "aKaznaVreme"));
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Upisivanje u log
 	format(string_256, 180, "AREA | Izvrsio: %s | Igrac: %s | Vreme: + %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], GetPVarInt(playerid, "aKaznaVreme"), razlog);
 	Log_Write(LOG_KAZNE, string_256);
	
	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste zatvorili je previse mali nivo! Da opozovete akciju, koristite /area.");

	// Ako je bio zatvoren od strane policije, to ponistavamo
	if (PI[id][p_zatvoren] > 0) 
	{
		PI[id][p_zatvoren] = 0;
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
	}

 	return 1;
}*/

Dialog:area(playerid, response, listitem, const inputtext[]) 
{
	if (!response) 
		return 1;
		
	if (!IsAdmin(playerid, 4)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	new 
		id = GetPVarInt(playerid, "aKaznaID"),
		razlog[32];

	if (!checkcinc(id, GetPVarInt(playerid, "aKaznaCinc"))) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "Igrac je napustio server.");
		
	if (PI[id][p_zatvoren] <= 5 && PI[id][p_area] <= 5) 
		return ErrorMsg(playerid, "Taj igrac nije zatvoren ili mu je ostalo manje od 5 sekundi, pokusajte ponovo.");
		
		
   	PI[id][p_kaznjen_puta]++;
	PI[id][p_area] += GetPVarInt(playerid, "aKaznaVreme")*60;
	GetPVarString(playerid, "aKaznaRazlog", razlog, sizeof razlog);
	
	// Univerzalni kod za stavljanje igraca u zatvor
	stavi_u_zatvor(playerid, true);
	
	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Zatvoreni ste na %d minuta od Game Admina %s | Preostalo: %s", GetPVarInt(playerid, "aKaznaVreme"), ime_rp[playerid], konvertuj_vreme(PI[id][p_area], true));
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je zatvorio igraca %s[ID: %d] na %d minuta | Preostalo: %s", ime_rp[playerid], ime_rp[id], id, GetPVarInt(playerid, "aKaznaVreme"), konvertuj_vreme(PI[id][p_area], true));
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET area = %d, kaznjen_puta = %d WHERE id = %d", PI[id][p_area], PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, mysql_upit);

	// Insert u kazne
	format(mysql_upit, sizeof mysql_upit, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'AREA', '%s', %d)", PI[id][p_id], razlog, GetPVarInt(playerid, "aKaznaVreme"));
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Upisivanje u log
 	format(string_256, 180, "AREA | Izvrsio: %s | Igrac: %s | Vreme: + %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], GetPVarInt(playerid, "aKaznaVreme"), razlog);
 	Log_Write(LOG_KAZNE, string_256);
	
	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste zatvorili je previse mali nivo! Da opozovete akciju, koristite /area.");

	// Ako je bio zatvoren od strane policije, to ponistavamo
	if (PI[id][p_zatvoren] > 0) 
	{
		PI[id][p_zatvoren] = 0;
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
	}

 	return 1;
}

Dialog:global_weather(playerid, response, listitem, const inputtext[]) 
{
	if (!response) return 1;
	if (listitem < 0 || listitem > 255) return 1;

	callcmd::vreme(playerid, inputtext);
	return 1;
}

Dialog:staff_smeni(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	// inputtext = IME IGRACA KOJI SE SMENJUJE

	new query[120];
	format(query, sizeof query, "DELETE staff FROM staff RIGHT JOIN igraci ON igraci.id = staff.pid WHERE igraci.ime = '%s'", inputtext);
	mysql_tquery(SQL, query);

	SendClientMessageF(playerid, CRVENA, "* Uspesno ste smenili sa pozicije igraca: %s", inputtext);
	return 1;
}

Dialog:nagradisve_levelup(playerid, response, listitem, const inputtext[])
{
	if (!response) 
		return callcmd::nagradisve(playerid, "");

	new string[105];
	format(string, sizeof string, "HEAD ADMIN NAGRADA | {FFFF00}%s je nagradio sve igrace sa: {00FF00}LEVEL UP.", ime_rp[playerid]);
	foreach (new i : Player)
	{
		if (IsPlayerLoggedIn(i))
		{
			PI[i][p_nivo] += 1;
			SetPlayerScore(i, PI[i][p_nivo]);
			SendClientMessage(i, ZELENA2, string);
			SendClientMessageF(i, BELA, "* Sada ste nivo: {FFFF00}%i.", PI[i][p_nivo]);

			new query[50];
			format(query, sizeof query, "UPDATE igraci SET nivo = %i WHERE id = %i", PI[i][p_nivo], PI[i][p_id]);
			mysql_tquery(SQL, query);
		}
	}
	return 1;
}

Dialog:nagradisve_cash(playerid, response, listitem, const inputtext[])
{
	if (!response) 
		return callcmd::nagradisve(playerid, "");

	new cash;
	if (sscanf(inputtext, "i", cash))
		return DialogReopen(playerid);

	if (cash < 1 || cash > 50000)
	{
		DialogReopen(playerid);
		return ErrorMsg(playerid, "Iznos mora biti izmedju $1 i $50.000.");
	}

	new string[105];
	format(string, sizeof string, "HEAD ADMIN NAGRADA | {FFFF00}%s je nagradio sve igrace sa: {00FF00}%s.", ime_rp[playerid], formatMoneyString(cash));
	foreach (new i : Player)
	{
		if (IsPlayerLoggedIn(i))
		{
			PlayerMoneyAdd(i, cash);
			SendClientMessage(i, ZELENA2, string);

			new query[60];
			format(query, sizeof query, "UPDATE igraci SET novac = %i WHERE id = %i", PI[i][p_novac], PI[i][p_id]);
			mysql_tquery(SQL, query);
		}
	}
	return 1;
}


stock HideDutyPTD(playerid)
{
	#pragma unused playerid
}

stock ShowDutyPTD(playerid)
{
	#pragma unused playerid
}

Dialog:staff(playerid, response, listitem, const inputtext[])
{
	if (listitem == 0 && (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_ADMIN_VODJA)) ||
		listitem == 1 && (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_HELPER_VODJA)) ||
		listitem == 2 && (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_PROMO_VODJA)) ||
		listitem == 3 && (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) ||
		listitem == 4 && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (!response) return 1;

	if (listitem == 0) // Admini
	{
		SPD(playerid, "staff_admini", DIALOG_STYLE_LIST, "Staff - Admini", "Spisak admina\nAktivnost admina\nSmeni admina", "Dalje »", "« Nazad");
	}
	else if (listitem == 1) // Helperi
	{
		SPD(playerid, "staff_helperi", DIALOG_STYLE_LIST, "Staff - Helperi", "Spisak helpera\nAktivnost helpera\nSmeni helpera", "Dalje »", "« Nazad");
	}
	else if (listitem == 2) // Promoteri
	{
		SPD(playerid, "staff_promoteri", DIALOG_STYLE_LIST, "Staff - Promoteri", "Spisak promotera\nAktivnost promotera\nSmeni promotera", "Dalje »", "« Nazad");
	}
	else if (listitem == 3) // Lideri
	{
		SPD(playerid, "staff_lideri", DIALOG_STYLE_LIST, "Staff - Lideri", "Spisak lidera\nAktivnost lidera\nSmeni lidera", "Dalje »", "« Nazad");
	}
	else if (listitem == 4) // VIP
	{
		// Prikazati spisak VIP igraca
		mysql_tquery(SQL, "SELECT ime, vip_level, vip_istice FROM igraci WHERE vip_level > 0 AND vip_istice > 0 ORDER BY vip_istice ASC", "mysql_staff_list", "iii", playerid, cinc[playerid], THREAD_VIP);
	}
	else if (listitem == 5) // DJ
	{
		// Prikazati spisak DJ-eva
		mysql_tquery(SQL, "SELECT ime, DATE_FORMAT(poslednja_aktivnost, '%d %b %Y, %H:%i') as akt FROM igraci WHERE dj > 0 ORDER BY poslednja_aktivnost DESC", "mysql_staff_list", "iii", playerid, cinc[playerid], THREAD_DJ);
	}
	return 1;
}

Dialog:staff_admini(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return callcmd::staff(playerid, "");

	if (listitem == 0) // Spisak
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.admin, DATE_FORMAT(igraci.poslednja_aktivnost, '%d %b %Y, %H:%i') as last_act FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE staff.admin > 0 ORDER BY last_act DESC", "mysql_staff_list", "iii", playerid, cinc[playerid], THREAD_ADMINI);
	}

	else if (listitem == 1) // Aktivnost
	{
		InfoMsg(playerid, "U izradi. Koristiti /staff - Spisak Admina - Aktivnost");
		// mysql_tquery(SQL, "SELECT igraci.ime, staff.admin, DATE_FORMAT(igraci.poslednja_aktivnost, '%d %b %Y, %H:%i') as last_act FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE staff.admin > 0 ORDER BY last_act DESC", "mysql_staff_aktivnost", "iii", playerid, cinc[playerid], THREAD_ADMINI);
	}

	else if (listitem == 2) // Smeni
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.admin FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE igraci.ime != 'daddyDOT' AND staff.admin > 0 ORDER BY staff.admin DESC", "mysql_smeni", "iii", playerid, cinc[playerid], THREAD_ADMINI);
	}

	return 1;
}

Dialog:staff_helperi(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return callcmd::staff(playerid, "");

	if (listitem == 0) // Spisak
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.helper, DATE_FORMAT(igraci.poslednja_aktivnost, '%d %b %Y, %H:%i') as last_act FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE staff.helper > 0 ORDER BY last_act DESC", "mysql_staff_list", "iii", playerid, cinc[playerid], THREAD_HELPERI);
	}

	else if (listitem == 1) // Aktivnost
	{
		InfoMsg(playerid, "U izradi. Koristiti /staff - Spisak Helpera - Aktivnost");
		// mysql_tquery(SQL, "SELECT igraci.ime, staff.helper, DATE_FORMAT(igraci.poslednja_aktivnost, '%d %b %Y, %H:%i') as last_act FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE staff.helper > 0 ORDER BY last_act DESC", "mysql_staff_aktivnost", "iii", playerid, cinc[playerid], THREAD_HELPERI);
	}

	else if (listitem == 2) // Smeni
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.helper FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE igraci.ime != 'daddyDOT' AND staff.helper > 0 ORDER BY staff.helper DESC", "mysql_smeni", "iii", playerid, cinc[playerid], THREAD_HELPERI);
	}

	return 1;
}

Dialog:staff_promoteri(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return callcmd::staff(playerid, "");

	if (listitem == 0) // Spisak
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.promoter, DATE_FORMAT(igraci.poslednja_aktivnost, '%d %b %Y, %H:%i') as last_act FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE staff.promoter > 0 ORDER BY last_act DESC", "mysql_staff_list", "iii", playerid, cinc[playerid], THREAD_PROMOTERI);
	}

	else if (listitem == 1) // Aktivnost
	{
		mysql_tquery(SQL, "SELECT * FROM (SELECT igraci.ime AS playerName, staff.promoter, DATE_FORMAT(promo_rewards.time, '%d %b %Y, %H:%i') AS last_req, promo_rewards.time AS requestTime FROM igraci RIGHT JOIN promo_rewards ON promo_rewards.pid = igraci.id RIGHT JOIN staff ON staff .pid = igraci.id WHERE staff.promoter > 0 AND igraci.ime IS NOT NULL ORDER BY promo_rewards.time DESC LIMIT 99999999) sub GROUP BY playerName ORDER BY requestTime DESC", "mysql_staff_aktivnost", "iii", playerid, cinc[playerid], THREAD_PROMOTERI);
	}

	else if (listitem == 2) // Smeni
	{
		mysql_tquery(SQL, "SELECT igraci.ime, staff.promoter FROM igraci RIGHT JOIN staff ON igraci.id = staff.pid WHERE igraci.ime != 'daddyDOT' AND staff.promoter > 0 ORDER BY staff.promoter DESC", "mysql_smeni", "iii", playerid, cinc[playerid], THREAD_PROMOTERI);
	}

	return 1;
}

Dialog:staff_lideri(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return callcmd::staff(playerid, "");

	if (listitem == 0) // Spisak
	{
		return callcmd::lideri(playerid, "");
	}

	else if (listitem == 1) // Aktivnost
	{
		mysql_tquery(SQL, "SELECT igraci.ime, factions.naziv, DATE_FORMAT(igraci.poslednja_aktivnost, '%d/%m/%Y, %h:%m:%s') as last_act, factions.hex FROM igraci \
			LEFT JOIN factions_members ON factions_members.player_id = igraci.id \
			LEFT JOIN factions ON factions.id = factions_members.faction_id \
			WHERE factions_members.rank=7 ORDER BY factions_members.faction_id ASC", "MySQL_LeadersActivity", "ii", playerid, cinc[playerid]);
	}

	else if (listitem == 2) // Smeni
	{
		return callcmd::lideri(playerid, "");
	}

	return 1;
}

forward MySQL_LeadersActivity(playerid, ccinc);
public MySQL_LeadersActivity(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new dStr[2048],
		leaderName[MAX_PLAYER_NAME],
		factionName[MAX_FNAME_LENGTH],
		lastActivity[22],
		factionHex[11],
		factionRGB[7];
	format(dStr, sizeof dStr, "Lider\tGrupa\tPoslednja aktivnost");
	for__loop (new i = 0; i < rows; i++)
	{
		cache_get_value_index(i, 0, leaderName, sizeof leaderName);
		cache_get_value_index(i, 1, factionName, sizeof factionName);
		cache_get_value_index(i, 2, lastActivity, sizeof lastActivity);
		cache_get_value_index(i, 3, factionHex, sizeof factionHex);
		strmid(factionRGB, factionHex, 2, 8, 7);

		format(dStr, sizeof dStr, "%s\n%s\t{%s}%s\t%s", dStr, leaderName, factionRGB, factionName, lastActivity);
	}

	SPD(playerid, "staff_lideri_aktivnost", DIALOG_STYLE_TABLIST_HEADERS, "Aktivnost lidera", dStr, "Nazad", "");
	return 1;
}

forward MySQL_StaffDutyTime(playerid, ccinc, threadid, const ime[]);
public MySQL_StaffDutyTime(playerid, ccinc, threadid, const ime[])
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new dStr[2048],
		datum[7],
		dutyTime,
		pms
	;
	format(dStr, sizeof dStr, "Datum\tVreme na duznosti\tPM-ovi");
	for__loop (new i = 0; i < rows; i++)
	{
		cache_get_value_index(i, 0, datum, sizeof datum);
		cache_get_value_index_int(i, 1, dutyTime);
		cache_get_value_index_int(i, 2, pms);
		
		new dutyHrs  = floatround(dutyTime/3600, floatround_floor);
		new dutyMins = floatround((dutyTime - dutyHrs*3600)/60, floatround_floor);
		format(dStr, sizeof dStr, "%s\n%s\t%ih %im\t%i", dStr, datum, dutyHrs, dutyMins, pms);
	}

	if (threadid == THREAD_ADMINI)
	{
		SPD(playerid, "staff_admin_dutytime", DIALOG_STYLE_TABLIST_HEADERS, ime, dStr, "Nazad", "");
	}
	else if (threadid == THREAD_HELPERI)
	{
		SPD(playerid, "staff_helper_dutytime", DIALOG_STYLE_TABLIST_HEADERS, ime, dStr, "Nazad", "");
	}
	return 1;
}

Dialog:staff_lideri_spisak(playerid, response, listitem, const inputtext[])
{
	if (!response) return dialog_respond:staff(playerid, 1, 3, "Lideri");
	else return dialog_respond:f_smeni_lidera(playerid, response, listitem, inputtext);
}
Dialog:staff_list_admini(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:staff(playerid, 1, 0, "Admini");

	// Kliknuo je na nekog igraca, prikazati detaljno aktivnost po danima
	new sQuery[243];
	mysql_format(SQL, sQuery, sizeof sQuery, "SELECT DATE_FORMAT(date, '\%%d \%%b') as datum, dutyTime, pms FROM staff_activity LEFT JOIN igraci ON igraci.id = staff_activity.pid WHERE igraci.ime = '%s' AND date >= NOW() - INTERVAL 14 DAY ORDER BY date DESC", inputtext);
	mysql_tquery(SQL, sQuery, "MySQL_StaffDutyTime", "iiis", playerid, cinc[playerid], THREAD_ADMINI, inputtext);
	return 1;
}
Dialog:staff_admin_dutytime(playerid, response, listitem, const inputtext[])
{
	if(IsAdmin(playerid, 6))
		return dialog_respond:staff(playerid, 1, 0, "Admini");

	return 1;
}

Dialog:staff_list_helperi(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:staff(playerid, 1, 1, "Helperi");

	// Kliknuo je na nekog igraca, prikazati detaljno aktivnost po danima
	new sQuery[243];
	mysql_format(SQL, sQuery, sizeof sQuery, "SELECT DATE_FORMAT(date, '\%%d \%%b') as datum, dutyTime, pms FROM staff_activity LEFT JOIN igraci ON igraci.id = staff_activity.pid WHERE igraci.ime = '%s' AND date >= NOW() - INTERVAL 14 DAY ORDER BY date DESC", inputtext);
	mysql_tquery(SQL, sQuery, "MySQL_StaffDutyTime", "iiis", playerid, cinc[playerid], THREAD_HELPERI, inputtext);
	return 1;
}
Dialog:staff_helper_dutytime(playerid, response, listitem, const inputtext[])
{
	if(IsAdmin(playerid, 6))
		return dialog_respond:staff(playerid, 1, 1, "Helperi");

	return 1;
}

Dialog:staff_list_promoteri(playerid, response, listitem, const inputtext[])
	return dialog_respond:staff(playerid, 1, 2, "Promoteri");
Dialog:staff_list_vip(playerid, response, listitem, const inputtext[])
	return callcmd::staff(playerid, "");
Dialog:staff_lideri_aktivnost(playerid, response, listitem, const inputtext[])
	return dialog_respond:staff(playerid, 1, 3, "Lideri");

Dialog:staff_list_dj(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		new ime[MAX_PLAYER_NAME];
		format(ime, sizeof ime, "%s", inputtext);

		new targetid = GetPlayerIDFromName(ime);
		if (IsPlayerConnected(targetid))
		{
			PI[targetid][p_dj] = 0;
			SendClientMessageF(targetid, SVETLOCRVENA, "* Admin %s Vam je oduzeo DJ zaduzenje.", ime_rp[playerid]);
		}

		new query[70];
		mysql_format(SQL, query, sizeof query, "UPDATE igraci SET dj = 0 WHERE ime = '%s'", inputtext);
		mysql_tquery(SQL, query);

		SendClientMessageF(playerid, SVETLOPLAVA, "* Smenili ste igraca %s sa pozicije DJ-a.", inputtext);
	}

	return callcmd::staff(playerid, "");
}

Dialog:nagradisve(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	if (listitem == 0) // Level UP
	{
		SPD(playerid, "nagradisve_levelup", DIALOG_STYLE_MSGBOX, "Nagradi sve: Level UP", "{FFFFFF}Da li ste sigurni da zelite da date {FF0000}Level UP {FFFFFF}svim igracima?", "Da", "Ne");
	}
	else if (listitem == 1) // Novac
	{
		SPD(playerid, "nagradisve_cash", DIALOG_STYLE_INPUT, "Nagradi sve: Novac", "{FFFFFF}Upisite iznos novca koji zelite da dodate svim igracima:", "Potvrdi", "Nazad");
	}
	else if (listitem == 2) // Poeni iskustva
	{
		// TODO
		return ErrorMsg(playerid, "Nedostupno.");
	}
	return 1;
}

Dialog:kazni(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	if (!IsAdmin(playerid, 1))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new targetid = GetPVarInt(playerid, "aPunishmentID");

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(targetid))
		return ErrorMsg(playerid, "Taj igrac nije ulogovan.");

	switch (listitem)
	{
		case 0: // Non RP
		{
			PunishPlayer(targetid, playerid, 30, 0, 1,  false, "Non RP");
		}

		case 1: // PG
		{
			PunishPlayer(targetid, playerid, 15, 0, 1, false, "PG");
			SetTimerEx("ShowRulesDialog_MG_PG", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 2: // DM
		{
			PunishPlayer(targetid, playerid, 60, 0, 3, true, "DM");
			SetTimerEx("ShowRulesDialog_DM_RK", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 3: // RK
		{
			PunishPlayer(targetid, playerid, 45, 0, 3, false, "RK");
			SetTimerEx("ShowRulesDialog_DM_RK", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 4: // SK
		{
			PunishPlayer(targetid, playerid, 30, 0, 1, false, "SK");
		}

		case 5: // TK
		{
			PunishPlayer(targetid, playerid, 60, 0, 1, false, "TK");
			SetTimerEx("ShowRulesDialog_TURF_ROB", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 6: // Mesanje u turf/pljacku
		{
			PunishPlayer(targetid, playerid, 120, 0, 1, true, "Mesanje u turf/pljacku");
			SetTimerEx("ShowRulesDialog_TURF_ROB", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 7: // Heli Abuse / H Abuse
		{
			PunishPlayer(targetid, playerid, 45, 0, 1, false, "Heli abuse / H abuse");
		}

		case 8: // Vredjanje/psovanje/provociranje
		{
			PunishPlayer(targetid, playerid, 0, 180, 1, false, "Vredjanje/psovanje/provociranje");
			SetTimerEx("ShowRulesDialog_OTHER", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 9: // Zloupotreba /prijava ili /pitanje
		{
			PunishPlayer(targetid, playerid, 0, 60, 0, false, "Zloupotreba /report ili /askq");
			SetTimerEx("ShowRulesDialog_OTHER", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 10: // Zloupotreba oglasa
		{
			PunishPlayer(targetid, playerid, 0, 60, 1, false, "Zloupotreba oglasa");
			SetTimerEx("ShowRulesDialog_ADS", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 11: // DB
		{
			PunishPlayer(targetid, playerid, 45, 0, 3, false, "DB");
		}

		case 12: // MG
		{
			PunishPlayer(targetid, playerid, 60, 0, 1, false, "MG");
			SetTimerEx("ShowRulesDialog_MG_PG", 5000, false, "ii", targetid, cinc[targetid]);
		}

		case 13: // VIP/Promo Abuse
		{
			PunishPlayer(targetid, playerid, 180, 0, 2, true, "VIP/Promo Abuse");
		}

		case 14: // Odbijanje provere
		{
			PunishPlayer(targetid, playerid, 4000, 0, 0, false, "Odbijanje provere");

			//PI[targetid][p_zabrana_oruzje] = gettime() + 10*86400; // 10 dana

			PI[targetid][p_org_kazna] = gettime() + 14*86400; // 14 dana

			new sQuery[90];
			format(sQuery, sizeof sQuery, "UPDATE igraci SET org_kazna = FROM_UNIXTIME(%d) WHERE id = %i", PI[targetid][p_org_kazna], PI[targetid][p_id]);
			mysql_tquery(SQL, sQuery);
		}

		case 15: // Cheat
		{
			if (!IsAdmin(playerid, 3)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

			PunishPlayer(targetid, playerid, 2160, 0, 10, false, "Cheat");

			PI[targetid][p_zabrana_oruzje] = gettime() + 14*86400; // 14 dana
			PI[targetid][p_cheater] = gettime() + 14*86400; // 7 dana
			PI[targetid][p_org_kazna] = gettime() + 14*86400; // 14 dana

			new sQuery[90];
			format(sQuery, sizeof sQuery, "UPDATE igraci SET zabrana_oruzje = %i, org_kazna = FROM_UNIXTIME(%d), cheater = %i WHERE id = %i", PI[targetid][p_zabrana_oruzje], PI[targetid][p_org_kazna], PI[targetid][p_cheater], PI[targetid][p_id]);    
			mysql_tquery(SQL, sQuery);

			// Upisivanje u log
			new sLog[90];
			format(sLog, sizeof sLog, "ORUZJE | %s | %s na 14 dana (cheater)", ime_obicno[playerid], ime_obicno[targetid]);
			Log_Write(LOG_ZABRANE, sLog);
		}

		case 16: // Cheat (Aim/WH)
		{
			if (!IsAdmin(playerid, 3)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

			PunishPlayer(targetid, playerid, 4000, 0, 20, false, "Cheat (Aim/WH)");

			PI[targetid][p_zabrana_oruzje] = gettime() + 28*86400; // 28 dana
			PI[targetid][p_cheater] = gettime() + 28*86400; // 28 dana
			PI[targetid][p_org_kazna] = gettime() + 28*86400; // 28 dana

			new query[256];
			format(query, sizeof query, "UPDATE igraci SET zabrana_oruzje = %i, org_kazna = FROM_UNIXTIME(%d), cheater = %i WHERE id = %i", PI[targetid][p_zabrana_oruzje], PI[targetid][p_org_kazna], PI[targetid][p_cheater], PI[targetid][p_id]);    
			mysql_tquery(SQL, query);

			// Upisivanje u log
			new sLog[90];
			format(sLog, sizeof sLog, "ORUZJE | %s | %s na 28 dana (cheater)", ime_obicno[playerid], ime_obicno[targetid]);
			Log_Write(LOG_ZABRANE, sLog);
		}

		case 17: // RPS
		{
			PunishPlayer(targetid, playerid, 45, 0, 1, false, "RPS");
			SetTimerEx("ShowRulesDialog_MG_PG", 5000, false, "ii", targetid, cinc[targetid]);
		}
	}
	return 1;
}

Dialog:promeniime(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (isnull(inputtext))
			return DialogReopen(playerid);

		if (!Regex_Check(inputtext, regex_ime) || strlen(inputtext) < 6 || strlen(inputtext) >= MAX_PLAYER_NAME)
		{
			ErrorMsg(playerid, "Ime nije u pravilnom obliku (Ime_Prezime).");
			return DialogReopen(playerid);
		}

		if (PI[playerid][p_novac] < 15000000)
			return ErrorMsg(playerid, "Nemate dovoljno novca.");

		new sQuery[75];
		mysql_format(SQL, sQuery, sizeof sQuery, "SELECT COUNT(id) FROM igraci WHERE ime = '%s'", inputtext);
		mysql_tquery(SQL, sQuery, "MySQL_VeifyNameChange", "iis", playerid, cinc[playerid], inputtext);
	}
	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:admini("admins")
alias:helperi("gamehelperi", "gamehelpers", "gamemasteri", "masteri", "gamemasters", "helpers")
alias:respawn("resetuj")
alias:utisaj("mute")
alias:osamari("slap")
alias:idido("goto")
alias:dovedi("gethere")
alias:tp("teleport")
alias:pancir("setarmor", "setarmour")
alias:allowma("dozvolima")
alias:duznost("aon", "aoff")


CMD:jetpack(playerid, const params[]) 
{
	if (!IsAdmin(playerid, 6) && !IsOnDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili jetpack.");
	
	if (GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK) 
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	else
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);

	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /jetpack | Izvrsio: %s", ime_obicno[playerid]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:razoruzaj(playerid, const params[]) 
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "razoruzaj [Ime ili ID igraca]");
	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	// Glavna funkcija komande
	ResetPlayerWeapons(id);
	
	// Slanje poruke igracu i staffu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Razoruzani ste od Game Admina %s.", ime_rp[playerid]);
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je razoruzao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);

	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /razoruzaj | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

CMD:proveravpn(playerid, const params[])
{
	if (Regex_Check(params, regex_ime)) // Pretraga po imenu
	{
		printf("ime | params %s", params);
		format(mysql_upit, sizeof mysql_upit, "SELECT ip FROM igraci WHERE ime = '%s'", params);
		mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, params, 3);
	}
	else // Pretraga po IP adresi (verovatno)
	{
		printf("ip | params %s", params);
		format(mysql_upit, sizeof mysql_upit, "SELECT ime, datum_registracije, ip FROM igraci WHERE 1");
		mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, params, 4);
	}

	return 1;
}

CMD:proveraip(playerid, const params[])
{
 	if (Regex_Check(params, regex_ime) || Regex_Check(params, regex_spec_ime)) // Pretraga po imenu
	{
		printf("ime | params %s", params);
		format(mysql_upit, sizeof mysql_upit, "SELECT ip FROM igraci WHERE ime = '%s'", params);
		mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, params, 1);
	}
	else // Pretraga po IP adresi (verovatno)
	{
		printf("ip | params %s", params);
		format(mysql_upit, sizeof mysql_upit, "SELECT ime, datum_registracije FROM igraci WHERE ip = '%s'", params);
		mysql_tquery(SQL, mysql_upit, "mysql_provera_ip", "isi", playerid, params, 2);
	}

	return 1;
}

cmd:allowma(playerid, const params[])
{
	new id,
		grant
	;

	if (sscanf(params, "ui", id, grant)) 
		return Koristite(playerid, "allowma [Ime ili ID igraca] [0 - oduzmi dozvolu za multiacc; 1 - daj dozvolu]");
	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if(grant << 0 || grant >> 1)
		return ErrorMsg(playerid, "Moguc odabir je 0 ili 1.");

	SetPVarInt(id, "ma_access", grant);
	InfoMsg(playerid, "Uspjesno ste dali dozvolu na multiacc igracu %s", ime_obicno[id]);
	InfoMsg(id, "Admin %s Vam je dao dozvolu na multiacc", ime_obicno[playerid]);

	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /allowma | Izvrsio: %s | ID: %d | Dozvola: %i", ime_obicno[playerid], id, grant);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

CMD:rv(playerid, const params[])
{
	new id;
	if (sscanf(params, "i", id)) 
		return Koristite(playerid, "rv [ID vozila]");

	if (Iter_Contains(iVehicles, id))
		return ErrorMsg(playerid, "To vozilo nije kreirano.");
		
		
	// Glavna funkcija komande
	SetVehicleToRespawn(id);
	
	
	// Slanje poruke staffu
	AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je respawnao vozilo ID %d.", ime_rp[playerid], id);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /rv | Izvrsio: %s | ID: %d", ime_obicno[playerid], id);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:scm(playerid, const params[])
{
	new 
		id, 
		tekst[100];

  	if (sscanf(params, "us[100]", id, tekst)) 
		return Koristite(playerid, "SendClientMessage [Ime ili ID igraca] [Tekst]");
		
   	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		
	// Glavna funkcija komande
	SendClientMessage(id, -1, tekst);
	return 1;
}

CMD:scmta(playerid, const params[])
{
	// Glavna funkcija komande
 	SendClientMessageToAll(-1, params);
	return 1;
}

CMD:multi(playerid, const params[])
{
	// TODO: proveriti
	if (!gHeadAdmin{playerid}) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	new 
		vrsta, 
		parametar[32]
	;
 	if (sscanf(params, "is[32]", vrsta, parametar))
 	{
	 	Koristite(playerid, "multi [Vrsta 1/2] [Ime igraca ili lozinka]");
	 	SendClientMessage(playerid, GRAD2, "Vrsta 1: pretraga po imenu; vrsta 2: pretraga po lozinci");
	 	return 1;
	}
 	if (vrsta == 1) // Pretraga po imenu
	{
		format(mysql_upit, sizeof mysql_upit, "SELECT ime FROM igraci JOIN (SELECT lozinka AS pass FROM igraci WHERE ime = '%s') AS pwtbl ON igraci.lozinka = pass AND igraci.ime != '%s'",
		parametar, parametar);
		mysql_tquery(SQL, mysql_upit, "mysql_multi_provera", "isii", playerid, parametar, 1, cinc[playerid]);
	}
	else if (vrsta == 2) // Pretraga po lozinci
	{
		format(mysql_upit, sizeof mysql_upit, "SELECT ime FROM igraci WHERE lozinka = '%s'", params);
		mysql_tquery(SQL, mysql_upit, "mysql_multi_provera", "isii", playerid, parametar, 2, cinc[playerid]);
	}
	else return ErrorMsg(playerid, "Nevazeci unos za vrstu!");
	
	return 1;
}

CMD:setgun(playerid, const params[])
{
	if (!IsAdmin(playerid, 6)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new 
		id, 
		weapon[21], 
		ammo,
		weaponid = -1,
		sWeapon[21]
	;
	if (sscanf(params, "us[21]i", id, weapon, ammo)) 
		return Koristite(playerid, "setgun [Ime ili ID igraca] [Naziv ili ID oruzja] [Municija (20000 = neograniceno]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	
	// Glavna funkcija komande
	weaponid = GetWeaponIDFromName(weapon);
	if (weaponid == -1) weaponid = strval(weapon);

	if (weaponid < 1 || weaponid > 46 || weaponid == 19 || weaponid == 20 || weaponid == 21) 
		return ErrorMsg(playerid, "Nepoznato ime ili ID oruzja!");

	if (ammo < 1 || ammo > 20000) 
		return ErrorMsg(playerid, "Nepoznat unos za polje \"municija\".");

	
	// Glavna funkcija komande
	GivePlayerWeapon(id, weaponid, ammo);
	GetWeaponName(weaponid, sWeapon, sizeof sWeapon);

	
	// Slanje poruke igracu i staffu
 	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Dobili ste oruzje %s sa %d municije od Game Admina %s.", sWeapon, ammo, ime_rp[playerid]);
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je dao oruzje %s sa %d municije igracu %s[ID: %d].", ime_rp[playerid], sWeapon, ammo, ime_rp[id], id);

	// Upisivanje u log
	format(string_128, sizeof string_128, "Izvrsio: %s | Igrac: %s | Oruzje: %s (%d) | Municija: %d", ime_obicno[playerid], ime_obicno[id], sWeapon, weaponid, ammo);
	Log_Write(LOG_ORUZJE, string_128);
	return 1;
}

CMD:proveri(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "proveri [Ime ili ID igraca]");
		   
	if (!IsPlayerConnected(id)) 
	{
		ErrorMsg(playerid, GRESKA_OFFLINE);

		if (!IsPlayerConnected(id) && IsAdmin(playerid, 5))
		{
			callcmd::offprovera(playerid, params);
		}
		return 1;
	}
		   
	if (!IsPlayerLoggedIn(id)) 
		return ErrorMsg(playerid, "Igrac nije prijavljen.");

	new
		Float:health,
		Float:armour,
		version[24],
		zatvoren[20],
		utisan[10],
		posao[22],
		grupa[10],
		vipName[9],
		vipExp = PI[id][p_vip_istice] - gettime(), 
		vipDays = ((vipExp>0)? floatround(vipExp/86400, floatround_floor) : 0), 
		vipHrs = ((vipExp>0)? floatround((vipExp - vipDays*86400)/3600, floatround_floor) : 0),
		sDivision[9],
		email_provera[MAX_EMAIL_LEN],
		ip_provera[16]
	;
	GetPlayerHealth(id, health);
	GetPlayerArmour(id, armour);
	GetPlayerVersion(id, version, sizeof version);
	GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
	GetPlayerFacingAngle(id, pozicija[id][3]);
	GetPlayerJobName(id, posao, sizeof posao);
	GetFactionTag(PI[id][p_org_id], grupa, sizeof grupa);
	VIP_GetPackageName(PI[id][p_vip_level], vipName, sizeof vipName);
	GetDivisionName(GetPlayerDivision(id), sDivision, sizeof sDivision);
	
	
	if (!IsPlayerJailed(id)) zatvoren = "Ne";
	else 
	{
		if (PI[id][p_zatvoren] > 0) format(zatvoren, 20, "%d minuta", PI[id][p_zatvoren]);
		//if (PI[id][p_area] > 0)     format(zatvoren, 20, "%s", konvertuj_vreme(PI[id][p_area], true));
	}
	
	if (PI[id][p_utisan] == 0) utisan = "Ne";
	else format(utisan, 16, "%s", konvertuj_vreme(PI[id][p_utisan], true));

	if(PI[id][p_admin] > 0 || PI[id][p_helper] > 0) {
		format(email_provera, MAX_EMAIL_LEN, "HELPER/ADMIN");
		format(ip_provera, 16, "HELPER/ADMIN");
	} 
	if(PI[playerid][p_admin] > 4) {
		format(email_provera, MAX_EMAIL_LEN, "%s", PI[id][p_email]);
		format(ip_provera, 16, "%s", PI[id][p_ip]);
	} 
	if(PI[playerid][p_admin] == 0 || PI[playerid][p_helper] == 0) {
		format(email_provera, MAX_EMAIL_LEN, "%s", PI[id][p_email]);
		format(ip_provera, 16, "%s", PI[id][p_ip]);
	}

	new string[2500];
	
	format(string, sizeof string, "\
		{FF9900}%s[%i] ** UniqID: [%i] ** %s\n\
		___________________________________________________\n\
		\n\
		Nivo: {FFFFFF}[%i]\n{FF9900}\
		Iskustvo: {FFFFFF}[%i/%i]\n{FF9900}\
		Novac (server): {FFFFFF}[%s]   {FF9900}client: {FFFFFF}[%s]\n{FF9900}\
		Novac u banci: {FFFFFF}[%s]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		Opomena: {FFFFFF}[%i/5]\n{FF9900}\
		Kaznjen: {FFFFFF}[%i puta]\n{FF9900}\
		Zatvoren: {FFFFFF}[%s] [%s]\n{FF9900}\
		Utisan: {FFFFFF}[%s] [%s]\n{FF9900}\
		AFK: {FFFFFF}[%s]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		Posao: {FFFFFF}[%s]\n{FF9900}\
		Grupa: {FFFFFF}[%s]\n{FF9900}\
		Rank: {FFFFFF}[%i]\n{FF9900}\
		Vreme u grupi: {FFFFFF}[%i sati]\n{FF9900}\
		Aktivna igra: {FFFFFF}[%i poena]\n{FF9900}\
		Skill Cop: {FFFFFF}[%i]\n{FF9900}\
		Skill Criminal: {FFFFFF}[%i]\n{FF9900}\
		Divizija: {FFFFFF}[%s (%i)]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		Pozicija: {FFFFFF}[%.2f] [%.2f] [%.2f] [%.2f]\n{FF9900}\
		Enterijer: {FFFFFF}[%i]  /  {FF9900}VirtualWorld: {FFFFFF}[%i]\n{FF9900}\
		Health: {FFFFFF}[%.1f]  /  {FF9900}Armour: {FFFFFF}[%.1f]\n{FF9900}\
		Zamrznut: {FFFFFF}[%s]\n{FF9900}\
		Wanted Level: {FFFFFF}[%d]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		VIP Level: {FFFFFF}[%s (%i)]\n{FF9900}\
		VIP istice za: {FFFFFF}[%i dana, %i sati]\n{FF9900}\
		Tokeni: {FFFFFF}[%i]\n{FF9900}\
		Slotovi za vozila: {FFFFFF}[%i]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		Drzava: {FFFFFF}[%s]\n{FF9900}\
		Starost: {FFFFFF}[%i godina]\n{FF9900}\
		E-mail: {FFFFFF}[%s]\n{FF9900}\
		Poslednji IP: {FFFFFF}[%s]\n{FF9900}\
		Ref: {FFFFFF}[%s]\n{FF9900}\
		Datum registracije: {FFFFFF}[%s]\n{FF9900}\
		Vreme u igri: {FFFFFF}[%.1f sati]\n{FF9900}\
		Client: {FFFFFF}[SA-MP %s]\n{FF9900}\
		___________________________________________________\n{FF9900}\
		", // 42
	ime_obicno[id], id, PI[id][p_id], trenutno_vreme(),
	PI[id][p_nivo], PI[id][p_iskustvo], GetNextLevelExp(PI[id][p_nivo]), formatMoneyString(PI[id][p_novac]), formatMoneyString(GetPlayerMoney(id)), formatMoneyString(PI[id][p_banka]),
	PI[id][p_opomene], PI[id][p_kaznjen_puta], zatvoren, PI[id][p_area_razlog], utisan, PI[id][p_utisan_razlog], (IsPlayerAFK(id)? konvertuj_vreme(GetPlayerAFKTime(id)) : ("Ne")),
	posao, grupa, PI[id][p_org_rank], floatround(PI[id][p_org_vreme] / 3600.0), AKTIGRA_GetPts(id), PI[id][p_skill_cop], PI[id][p_skill_criminal], sDivision, PI[id][p_division_points],
	pozicija[id][0], pozicija[id][1], pozicija[id][2], pozicija[id][3], GetPlayerInterior(id), GetPlayerVirtualWorld(id), health, armour, (zamrznut{id}?("Da"):("Ne")), PI[id][p_wanted_level],
	vipName, PI[id][p_vip_level], vipDays, vipHrs, PI[id][p_token], PI[id][p_vozila_slotovi],
	PI[id][p_drzava], PI[id][p_starost], email_provera, ip_provera, PI[id][p_referral], PI[id][p_datum_registracije], floatdiv(PI[id][p_provedeno_vreme], 3600.0), version);

	SetPVarInt(playerid, "aCheckID", id);
	if (IsAdmin(playerid, 5))
	{
		// A5+ moze da gleda i imovinu + stvari
		SPD(playerid, "admin_proveri", DIALOG_STYLE_MSGBOX, ime_obicno[id], string, "Dalje >>", "Zatvori");
	}
	else
	{
		// Helper ima samo prvu stranicu
		SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, ime_obicno[id], string, "Zatvori", "");
	}
	return 1;
}

Dialog:admin_proveri(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	new id = GetPVarInt(playerid, "aCheckID");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(id))
		return ErrorMsg(playerid, "Igrac nije prijavljen.");

	new kuca_str[8], stan_str[8], firma_str[8], garaza_str[8], hotel_str[8],
		v1_str[26], v2_str[26], v3_str[26], v4_str[26], v5_str[26],
		weaponid, ammo, output[21], weaponStr1[128], weaponStr2[128];

	output = "Nema";
	GetPlayerWeaponData(id, 1, weaponid, ammo);
	format(weaponStr1, 128, "%s(%d) |", output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 2, weaponid, ammo);
	if (weaponid == 22) output = "Pistol";
	if (weaponid == 23) output = "Silenced Pistol";
	if (weaponid == 24) output = "Desert Eagle";
	format(weaponStr1, 128, "%s %s(%d) |", weaponStr1, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 3, weaponid, ammo);
	if (weaponid == 25) output = "Shotgun";
	if (weaponid == 26) output = "SawnOff Shotgun";
	if (weaponid == 27) output = "Combat Shotgun";
	format(weaponStr1, 128, "%s %s(%d) |", weaponStr1, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 4, weaponid, ammo);
	if (weaponid == 28) output = "MicroUzi";
	if (weaponid == 29) output = "MP5";
	if (weaponid == 32) output = "Tec9";
	format(weaponStr1, 128, "%s %s(%d) |", weaponStr1, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 5, weaponid, ammo);
	if (weaponid == 30) output = "AK47";
	if (weaponid == 31) output = "M4";
	format(weaponStr1, 128, "%s %s(%d) |", weaponStr1, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 6, weaponid, ammo);
	if (weaponid == 33) output = "Rifle";
	if (weaponid == 34) output = "Sniper";
	format(weaponStr1, 128, "%s %s(%d)", weaponStr1, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 7, weaponid, ammo);
	if (weaponid == 35) output = "RPG";
	if (weaponid == 36) output = "Missile Launcher";
	if (weaponid == 37) output = "Flame Thrower";
	if (weaponid == 38) output = "Minigun";
	format(weaponStr2, 128, "%s(%d) |", output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 8, weaponid, ammo);
	if (weaponid == 16) output = "Grenade";
	if (weaponid == 17) output = "Tear Gas";
	if (weaponid == 18) output = "Molotov Cocktail";
	if (weaponid == 39) output = "Satchel Charge";
	format(weaponStr2, 128, "%s %s(%d) |", weaponStr2, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 9, weaponid, ammo);
	if (weaponid == 41) output = "Spraycan";
	if (weaponid == 42) output = "FireExtinguisher";
	if (weaponid == 43) output = "Camera";
	format(weaponStr2, 128, "%s %s(%d) |", weaponStr2, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 10, weaponid, ammo);
	if (weaponid == 10) output = "Purple Dildo";
	if (weaponid == 11) output = "Small White Vibrator";
	if (weaponid == 12) output = "Large White Vibrator";
	if (weaponid == 13) output = "Silver Vibrator";
	if (weaponid == 14) output = "Flowers";
	if (weaponid == 15) output = "Cane";
	format(weaponStr2, 128, "%s %s(%d) |", weaponStr2, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 11, weaponid, ammo);
	if (weaponid == 44) output = "NV Goggles";
	if (weaponid == 45) output = "Thermal Goggles";
	if (weaponid == 46) output = "Parachute";
	format(weaponStr2, 128, "%s %s(%d) |", weaponStr2, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(id, 12, weaponid, ammo);
	if (weaponid == 40) output = "Detonator";
	format(weaponStr2, 128, "%s %s(%d)", weaponStr2, output, ammo);


	// Formatiranje stringova za nekretnine
	if (pRealEstate[id][kuca] == -1) kuca_str = "Nema";
	else valstr(kuca_str, pRealEstate[id][kuca]);

	if (pRealEstate[id][stan] == -1) stan_str = "Nema";
	else valstr(stan_str, pRealEstate[id][stan]);

	if (pRealEstate[id][firma] == -1) firma_str = "Nema";
	else format(firma_str, sizeof firma_str, "%d (%s)", pRealEstate[id][firma], vrstafirme(RealEstate[re_globalid(firma, pRealEstate[id][firma])][RE_VRSTA], PROPNAME_CAPITAL));

	if (pRealEstate[id][garaza] == -1) garaza_str = "Nema";
	else valstr(garaza_str, pRealEstate[id][garaza]);

	if (pRealEstate[id][hotel] == -1) hotel_str = "Nema";
	else valstr(hotel_str, pRealEstate[id][hotel]);


	// Formatiranje stringova za vozila
	if (pVehicles[id][0] <= 0) v1_str = "Nema";
	else format(v1_str, sizeof v1_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][0]][V_MODEL] - 400], pVehicles[id][0]);

	if (pVehicles[id][1] <= 0) v2_str = "Nema";
	else format(v2_str, sizeof v2_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][1]][V_MODEL] - 400], pVehicles[id][1]);
		
	if (pVehicles[id][2] <= 0) v3_str = "Nema";
	else format(v3_str, sizeof v3_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][2]][V_MODEL] - 400], pVehicles[id][2]);
		
	if (pVehicles[id][3] <= 0) v4_str = "Nema";
	else format(v4_str, sizeof v4_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][3]][V_MODEL] - 400], pVehicles[id][3]);
		
	if (pVehicles[id][4] <= 0) v5_str = "Nema";
	else format(v5_str, sizeof v5_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][4]][V_MODEL] - 400], pVehicles[id][4]);


	new string[1000];
	format(string, sizeof string, "\
		{FF9900}%s[%i] ** UniqID: [%i] ** %s\n\
		___________________________________________________\n\
		{FFFFFF}%s\n\
		{FFFFFF}%s\n{FF9900}\
		___________________________________________________\n\
		Kuca: {FFFFFF}[%s]\n{FF9900}\
		Stan: {FFFFFF}[%s]\n{FF9900}\
		Firma: {FFFFFF}[%s]\n{FF9900}\
		Garaza: {FFFFFF}[%s]\n{FF9900}\
		Hotel: {FFFFFF}[%s]\n{FF9900}\
		___________________________________________________\n\
		Vozilo 1: {FFFFFF}[%s]\n{FF9900}\
		Vozilo 2: {FFFFFF}[%s]\n{FF9900}\
		Vozilo 3: {FFFFFF}[%s]\n{FF9900}\
		Vozilo 4: {FFFFFF}[%s]\n{FF9900}\
		Vozilo 5: {FFFFFF}[%s]\n{FF9900}\
		",
	ime_obicno[id], id, PI[id][p_id], trenutno_vreme(),
	weaponStr1, weaponStr2,
	kuca_str, stan_str, firma_str, garaza_str, hotel_str,
	v1_str, v2_str, v3_str, v4_str, v5_str);
	SPD(playerid, "admin_proveri2", DIALOG_STYLE_MSGBOX, ime_obicno[id], string, "Dalje >>", "<< Nazad");
	return 1;
}

Dialog:admin_proveri2(playerid, response, listitem, const inputtext[])
{
	new id = GetPVarInt(playerid, "aCheckID");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(id))
		return ErrorMsg(playerid, "Igrac nije prijavljen.");

	if (!response)
	{
		// Nazad
		new cmdParams[14];
		format(cmdParams, sizeof cmdParams, "%i", id);
		callcmd::proveri(playerid, cmdParams);
	}
	else
	{
		// Dalje
		new string[1024], sItemName[25];
		format(string, sizeof string, "\
			{FF9900}%s[%i] ** UniqID: [%i] ** %s\n\
			___________________________________________________\n", 
		ime_obicno[id], id, PI[id][p_id], trenutno_vreme());

		for__loop (new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
		{
			if (i == ITEM_RANAC || BP_PlayerItemGetCount(id, i) <= 0) continue;

			BP_GetItemName(i, sItemName, sizeof sItemName);
			format(string, sizeof string, "%s\n{FF9900}%s: {FFFFFF}[%i]", string, sItemName, BP_PlayerItemGetCount(id, i));
		}

		SPD(playerid, "admin_proveri3", DIALOG_STYLE_MSGBOX, ime_obicno[id], string, "<< Nazad", "Zatvori");
	}
	return 1;
}

Dialog:admin_proveri3(playerid, response, listitem, const inputtext[])
{
	new id = GetPVarInt(playerid, "aCheckID");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(id))
		return ErrorMsg(playerid, "Igrac nije prijavljen.");

	if (response)
	{
		// Nazad
		dialog_respond:admin_proveri(playerid, 1, 0, "");
	}
	return 1;
}

CMD:offprovera(playerid, const params[])
{
	new query[355];
	mysql_format(SQL, query, sizeof query, "SELECT ime, id, nivo, iskustvo, novac, banka, opomene, kaznjen_puta, org_id, posao, drzava, email, kuca, stan, firma, garaza, hotel, provedeno_vreme, ip, DATE_FORMAT(poslednja_aktivnost, '\%%d \%%b \%%Y, \%%H:\%%i') as last_act, DATE_FORMAT(datum_registracije, '\%%d \%%b \%%Y, \%%H:\%%i') as reg_date FROM igraci WHERE ime = '%s'", params);
	mysql_tquery(SQL, query, "MySQL_OffProvera", "ii", playerid, cinc[playerid]);
	return 1;
}

CMD:hao(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "hao [Tekst]");
		
	if(!gOwner{playerid})
		SendClientMessageFToAll(ZUTA, "(( %s: {FFFFFF}%s {FFFF00}))", ime_rp[playerid], params);
	else
		SendClientMessageFToAll(CRVENA, "(( %s: {FFFFFF}%s {FF0000}))", ime_rp[playerid], params);
	
	new logStr[145];
	format(logStr, sizeof logStr, "HEAD | %s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_STAFFOOC, logStr);
	return 1;
}

CMD:ao(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "ao [Tekst]");
		

	SendClientMessageFToAll(SVETLOPLAVA, "(( %s: {FFFFFF}%s {33CCFF}))", ime_rp[playerid], params);
	
	new logStr[145];
	format(logStr, sizeof logStr, "ADMIN | %s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_STAFFOOC, logStr);
	return 1;
}

CMD:ho(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "ho [Tekst]");
		

	SendClientMessageFToAll(ZELENOZUTA, "(( %s: {FFFFFF}%s {8EFF00}))", ime_rp[playerid], params);
	
	new logStr[145];
	format(logStr, sizeof logStr, "HELPER | %s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_STAFFOOC, logStr);
	return 1;
}

CMD:t(playerid, const params[])
{
	if (IsRaceActive()) 
		return ErrorMsg(playerid, "Nijedna trka nije aktivna!");
		
	if (isnull(params))
		return Koristite(playerid, "t [Tekst]");
	
	new sMsg[145];
	format(sMsg, sizeof sMsg, "(( %s: {FFFFFF}%s {FF9900}))", ime_rp[playerid], params);
	foreach(new i : Player)
	{
		if (IsPlayerInRace(i)) 
			SendClientMessage(i, NARANDZASTA, sMsg);
	}
	
	// Upisivanje u log
	format(sMsg, sizeof sMsg, "TRKA | %s | %s", ime_obicno[playerid], params);
	Log_Write(LOG_STAFFOOC, sMsg);
	return 1;
}

CMD:kreirajkod(playerid, const params[])
{
	// Provera parametara
	new 
		gold, 
		novac, 
		nivo
	;
	if (sscanf(params, "iii", gold, novac, nivo)) 
		return Koristite(playerid, "kreirajkod [Tokeni] [Novac] [Nivo]");
		
	if (gold < 0 || gold > 100000) 
		return ErrorMsg(playerid, "Nevazeci unos za \"Tokeni\"");
		
	if (novac < 0 || novac > 10000000) 
		return ErrorMsg(playerid, "Nevazeci unos za \"Novac\"");
		
	if (nivo < 0 || nivo > 100000) 
		return ErrorMsg(playerid, "Nevazeci unos za \"Nivo\"");
		
		
	// Glavna funkcija komande
	new kod[8];
	RandomString(kod, sizeof kod, RANDSTR_FLAG_UPPER | RANDSTR_FLAG_LOWER | RANDSTR_FLAG_DIGIT);

	format(mysql_upit, sizeof mysql_upit, "INSERT INTO kodovi (kod, gold, novac, nivo) VALUES ('%s', %d, %d, %d)", kod, gold, novac, nivo);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_NOVIKOD);
	overwatch_poruka(playerid, "Kod uspesno generisan!");
	
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, PLAVA, "Tokeni: %d | Novac: $%d | Nivo: %d | KOD: {FF0000}%s", gold, novac, nivo, kod);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "GENERISAN | Izvrsio: %s | Kod: %s | Tokeni: %d | Novac: $%d | Nivo: %d", ime_obicno[playerid], kod, gold, novac, nivo);
	Log_Write(LOG_KODOVI, string_128);
	return 1;
}

CMD:admini(playerid, const params[])
{
	if (PI[playerid][p_nivo] < 3)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (!IsHelper(playerid, 1))
	{
		// Obicnim igracima prikazuje samo broj online admina
		new online = 0;
		foreach(new i : Player)
		{
			if (PI[i][p_admin] > 0 && !IsPlayerAFK(i)) online ++;
		}

		SendClientMessageF(playerid, BELA, "Trenutno je na serveru prisutno {1275ED}%i {FFFFFF}Game Admina.", online);
	}
	else
	{
		SendClientMessage(playerid, PLAVA,    "_______________ Game Admini _______________");
		foreach(new i : Player) 
		{
			if (PI[i][p_admin] > 0) 
			{
				if (!IsAdmin(playerid, 1) || (IsAdmin(playerid, 1) && !IsPlayerAFK(i)))
				{
					SendClientMessageF(playerid, PLAVA, "Admin: {FFFFFF}%s[%i] | {1275ED}Nivo: {FFFFFF}%d", ime_rp[i], i, PI[i][p_admin]);
				}
				else if (IsAdmin(playerid, 1) && IsPlayerAFK(i))
				{
					SendClientMessageF(playerid, PLAVA, "Admin: {FFFFFF}%s[%i] | {1275ED}Nivo: {FFFFFF}%d | {FF9900}[AFK %s]", ime_rp[i], i, PI[i][p_admin], konvertuj_vreme(GetPlayerAFKTime(i)));
				}
			}
		}
	}
	return 1;
}

CMD:helperi(playerid, const params[])
{
	if (PI[playerid][p_nivo] < 3)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (!IsHelper(playerid, 1))
	{
		// Obicnim igracima prikazuje samo broj online helpera
		new online = 0;
		foreach(new i : Player)
		{
			if (PI[i][p_helper] > 0 && !IsPlayerAFK(i)) online ++;
		}

		SendClientMessageF(playerid, BELA, "Trenutno je na serveru prisutno {8EFF00}%i {FFFFFF}Helpera.", online);
	}
	else
	{
		SendClientMessage(playerid, ZELENOZUTA,   "_______________ Helperi _______________");
		foreach(new i : Player) 
		{
			if (PI[i][p_helper] > 0) 
			{
				if (!IsHelper(playerid, 1) || (IsHelper(playerid, 1) && !IsPlayerAFK(i)))
				{
					SendClientMessageF(playerid, ZELENOZUTA, "Helper: {FFFFFF}%s[%i] | {8EFF00}Nivo: {FFFFFF}%d", ime_rp[i], i, PI[i][p_helper]);
				}
				else if (IsHelper(playerid, 1) && IsPlayerAFK(i))
				{
					SendClientMessageF(playerid, ZELENOZUTA, "Helper: {FFFFFF}%s[%i] | {8EFF00}Nivo: {FFFFFF}%d | {FF9900}[AFK %s]", ime_rp[i], i, PI[i][p_helper], konvertuj_vreme(GetPlayerAFKTime(i)));
				}
			}
		}
	}
	return 1;
}

CMD:generisipin(playerid, const params[]) 
{
	if (!gHeadAdmin{playerid}) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	new ime[MAX_PLAYER_NAME];
	if (sscanf(params, "s[24]", ime)) 
		return Koristite(playerid, "generisipin [Ime igraca (npr. Frankie_Marcello)]");
		
		
	// Glavna funkcija komande
	format(mysql_upit, sizeof mysql_upit, "SELECT id FROM igraci WHERE ime = '%s'", ime);
	mysql_tquery(SQL, mysql_upit, "mysql_generisi_pin", "iis", playerid, cinc[playerid], ime);
	
	
	return 1;
}

CMD:bport(playerid, const params[])
{
	new Float:poz[3];
	if (sscanf(params, "p<,>fff", poz[0], poz[1], poz[2]) && sscanf(params, "p<|>fff", poz[0], poz[1], poz[2])) 
		return Koristite(playerid, "bport [X], [Y], [Z]");
		
	// Glavna funkcija komande
	TeleportPlayer(playerid, poz[0], poz[1], poz[2]);
	return 1;
}
CMD:dobadana(playerid, const params[])
{
	new vreme;
	if (sscanf(params, "i", vreme)) 
		return Koristite(playerid, "dobadana [Doba dana (sati)]");
		
		
	// Glavna funkcija komande
	SetWorldTime_H(vreme);
	
	
	// Slanje poruke staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je postavio doba dana na %d sati.", ime_rp[playerid], vreme);
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /dobadana | Izvrsio: %s | Sati: %d", ime_obicno[playerid], vreme);
  	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:vreme(playerid, const params[])
{
	new vreme;
	if (sscanf(params, "i", vreme)) 
	{
		// Igrac nije uneo ID, vec je samo uneo komandu --> prikazati mu dialog
		Koristite(playerid, "vreme [ID vremena]");
		SPD(playerid, "global_weather", DIALOG_STYLE_LIST, "Izbor vremena", "EXTRASUNNY_LA\nSUNNY_LA\nEXTRASUNNY_SMOG_LA\n\
			SUNNY_SMOG_LA\nCLOUDY_LA\nSUNNY_SF\nEXTRASUNNY_SF\nCLOUDY_SF\nRAINY_SF\nFOGGY_SF\nSUNNY_VEGAS\nEXTRASUNNY_VEGAS\n\
			CLOUDY_VEGAS\nEXTRASUNNY_COUNTRYSIDE\nSUNNY_COUNTRYSIDE\nCLOUDY_COUNTRYSIDE\nRAINY_COUNTRYSIDE\nEXTRASUNNY_DESERT\n\
			SUNNY_DESERT\nSANDSTORM_DESERT\nUNDERWATER", "Postavi", "Odustani");
		return 1;
	}
	else {	
		// Igrac je uneo ID
		SetWeather_H(vreme);

		new nazivVremena[23];
		switch (vreme) {
			case 0:  nazivVremena = "EXTRASUNNY_LA";
			case 1:  nazivVremena = "SUNNY_LA";
			case 2:  nazivVremena = "EXTRASUNNY_SMOG_LA";
			case 3:  nazivVremena = "SUNNY_SMOG_LA";
			case 4:  nazivVremena = "CLOUDY_LA";
			case 5:  nazivVremena = "SUNNY_SF";
			case 6:  nazivVremena = "EXTRASUNNY_SF";
			case 7:  nazivVremena = "CLOUDY_SF";
			case 8:  nazivVremena = "RAINY_SF";
			case 9:  nazivVremena = "FOGGY_SF";
			case 10: nazivVremena = "SUNNY_VEGAS";
			case 11: nazivVremena = "EXTRASUNNY_VEGAS";
			case 12: nazivVremena = "CLOUDY_VEGAS";
			case 13: nazivVremena = "EXTRASUNNY_COUNTRYSIDE";
			case 14: nazivVremena = "SUNNY_COUNTRYSIDE";
			case 15: nazivVremena = "CLOUDY_COUNTRYSIDE";
			case 16: nazivVremena = "RAINY_COUNTRYSIDE";
			case 17: nazivVremena = "EXTRASUNNY_DESERT";
			case 18: nazivVremena = "SUNNY_DESERT";
			case 19: nazivVremena = "SANDSTORM_DESERT";
			case 20: nazivVremena = "UNDERWATER";
			default: nazivVremena = "Nepoznato";
		}

		
		
		// Slanje poruke staffu
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je postavio ID vremena na %d (%s).", ime_rp[playerid], vreme, nazivVremena);
		
		// Upisivanje u log
	 	format(string_128, sizeof string_128, "Komanda: /vreme | Izvrsio: %s | %s (%d)", ime_obicno[playerid], nazivVremena, vreme);
	  	Log_Write(LOG_ADMINKOMANDE, string_128);
	}
	
	return 1;
}

CMD:gt(playerid, const params[])
{
	new 
		id, 
		text[128]
	;
	if (sscanf(params, "is[128]", id, text)) 
		return Koristite(playerid, "gt [Stil] [Tekst]");
		
	if (id < 0 || id > 6 || id == 2) 
		return ErrorMsg(playerid, "Stil moze biti samo 0, 1, 3, 4, 5, 6.");
		
	if (strfind(text, "~", true) != -1) 
		return ErrorMsg(playerid, "Ne mozete koristiti znak \"~\" u GameTextu!");
		
		
	// Glavna funkcija komande
	GameTextForAll(text, 5000, id);
	
	
	return 1;
}

CMD:gotoveh(playerid, const params[])
{
	new 
		id, 
		Float:Poz[3]
	;
	if (sscanf(params, "i", id)) 
		return Koristite(playerid, "gotoveh [ID vozila]");
		
	GetVehiclePos(id, Poz[0], Poz[1], Poz[2]);
	TeleportPlayer(playerid, Poz[0] + 4.0, Poz[1], Poz[2]);
	
	InfoMsg(playerid, "Teleportovani ste do vozila %i.", id);
	
	// Upisivanje u log
	format(string_128, 80, "Komanda: /gotoveh | Izvrsio: %s | ID: %d", ime_obicno[playerid], id);
	Log_Write(LOG_PORT, string_128);
	return 1;
}

CMD:enterveh(playerid, const params[])
{
	new 
		id, 
		Float:Poz[3]
	;
	if (sscanf(params, "i", id)) 
		return Koristite(playerid, "enterveh [ID vozila]");
		
	GetVehiclePos(id, Poz[0], Poz[1], Poz[2]);
	PutPlayerInVehicle_H(playerid, id, 0);
	
	InfoMsg(playerid, "Teleportovani ste u vozilo %i.", id);
	
	// Upisivanje u log
	format(string_128, 80, "Komanda: /enterveh | Izvrsio: %s | ID: %d", ime_obicno[playerid], id);
	Log_Write(LOG_PORT, string_128);
	return 1;
}

CMD:getveh(playerid, const params[])
{
	new 
		vehicleid, 
		Float:Poz[3]
	;
	if (sscanf(params, "i", vehicleid)) 
		return Koristite(playerid, "getveh [ID vozila]");
		
	GetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
	SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
	SetVehiclePos(vehicleid, Poz[0]+3.0, Poz[1], Poz[2]);
	
	InfoMsg(playerid, "Teleportovali ste do sebe vozilo %i.", vehicleid);
	
	// Upisivanje u log
	format(string_128, 80, "Komanda: /getveh | Izvrsio: %s | ID: %d", ime_obicno[playerid], vehicleid);
	Log_Write(LOG_PORT, string_128);
	return 1;
}

CMD:crash(playerid, const params[])
{
	if(!sscanf(ime_obicno[playerid], "Bozic", true) || !sscanf(ime_obicno[playerid], "DomT", true) || !sscanf(ime_obicno[playerid], "z1ann", true))
	{
		new id;
		if (sscanf(params, "u", id)) 
			return Koristite(playerid, "crash [Ime ili ID igraca]");
			
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
			
		if (IsHelper(id, 1) && !IsAdmin(playerid, 5))
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
			
		// Glavna funkcija komande
		GameTextForPlayer(id, "~", 1000, 5);
		
		
		// Slanje poruke staffu
		//AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je izazvao crash igracu %s.", ime_rp[playerid], ime_rp[id]);
		
		// Upisivanje u log
		//format(string_128, sizeof string_128, "Komanda: /crash | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
		//Log_Write(LOG_ADMINKOMANDE, string_128);
	}
	else return 0;
	
	return 1;
}

CMD:napunivozila(playerid, const params[])
{
	new model;
	foreach(new i : iVehicles) 
	{
		model = GetVehicleModel(i);
		FUEL_SetupVehicle(i, model);
	}
	
	
	// Slanje poruke igracima
	SendClientMessageFToAll(BELA, "{FF6347}- STAFF:{B4CDED} %s je napunio sva vozila gorivom.", ime_rp[playerid]);
	
	// Upisivanje u log
	new sLog[35];
	format(sLog, sizeof sLog, "/napunivozila | %s", ime_obicno[playerid]);
	Log_Write(LOG_ADMINKOMANDE, sLog);
	return 1;
}

CMD:refill(playerid, const params[])
{
	if (IsVIP(playerid, 2) && !IsAdmin(playerid, 3))
		return callcmd::viprefill(playerid, "");

	new targetid = INVALID_PLAYER_ID, vehicleid;
	if (sscanf(params, "u", targetid))
	{
		if (!IsPlayerInAnyVehicle(playerid)) 
			return ErrorMsg(playerid, "Niste u vozilu.");

		vehicleid = GetPlayerVehicleID(playerid);
	}
	else
	{
		if (!IsPlayerConnected(targetid))
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (!IsPlayerInAnyVehicle(targetid))
			return ErrorMsg(playerid, "Taj igrac nije u vozilu.");

		vehicleid = GetPlayerVehicleID(targetid);
	}

	RefillVehicle(vehicleid);
	if (!IsPlayerConnected(targetid))
	{
	   SendClientMessage(playerid, SVETLOPLAVA, "* Vozilo je napunjeno gorivom.");
	}
	else
	{
		SendClientMessageF(targetid, SVETLOPLAVA, "* Admin %s Vam je dopunio vozilo gorivom.", ime_rp[playerid]);
	}
	// TODO: poruka za staff
	
	// Upisivanje u log
	if (!IsPlayerConnected(targetid)) targetid = playerid;
	new sLog[75];
	format(sLog, sizeof sLog, "/refill | %s | Igrac: %s", ime_obicno[playerid], ime_obicno[targetid]);
	Log_Write(LOG_ADMINKOMANDE, sLog);

	return 1;
}

CMD:baninfo(playerid, const params[])
{
	new ime[MAX_PLAYER_NAME];
	if (sscanf(params, "s[21]", ime)) 
		return Koristite(playerid, "baninfo [Ime igraca (obavezno staviti crticu u ime)]");
		
	// Slanje upita
	new upit[274];
 	mysql_format(SQL, upit, sizeof upit, "SELECT b.id, b.admin, b.razlog, DATE_FORMAT(b.datum, '\%%d/\%%m/\%%Y u \%%H:\%%i:\%%S') as datum, DATE_FORMAT(b.istice, '\%%d/\%%m/\%%Y u \%%H:\%%i:\%%S') as istice, b.offban, i.ime FROM banovi b LEFT JOIN igraci i ON i.id = b.pid WHERE i.ime = '%s'", ime);
  	mysql_tquery(SQL, upit, "mysql_baninfo", "ii", playerid, cinc[playerid]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /baninfo | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

CMD:izlecisve(playerid, const params[])
{
	foreach(new i : Player) 
	{
		if (!IsPlayerInWar(i)) 
			SetPlayerHealth(i, 99.0);
	}
	
	// Slanje poruke igracima
	SendClientMessageFToAll(BELA, "{FF6347}- STAFF:{B4CDED} %s je izlecio sve igrace na serveru.", ime_rp[playerid]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /izlecisve | Izvrsio: %s", ime_obicno[playerid]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:aizleci(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "aizleci [Ime ili ID igraca]");

	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		
	// Glavna funkcija komande 
	SetPlayerHealth(id, 99.0);
	
	// Slanje poruke igracima
	AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je izlecio %s.", ime_rp[playerid], ime_rp[id]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /aizleci | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:pancir(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "pancir [Ime ili ID igraca]");

	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		
	// Glavna funkcija komande 
	SetPlayerArmour(id, 99.0);
	
	// Slanje poruke igracima
	AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je napunio pancir igracu %s.", ime_rp[playerid], ime_rp[id]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /pancir | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:nahranisve(playerid, const params[]) 
{
	foreach(new i : Player) 
	{
		PI[i][p_glad] = 0;
		UpdateHungerMainGui(i, PI[i][p_glad]);
	}
	
	// Slanje poruke igracima
	SendClientMessageFToAll(BELA, "{FF6347}- STAFF:{B4CDED} %s je nahranio sve igrace na serveru (glad = 0).", ime_rp[playerid]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /nahranisve | Izvrsio: %s", ime_obicno[playerid]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:padobran(playerid, const params[])
{
	new 
		id, 
		Float:visina = 1000.0
	;
	if (sscanf(params, "uF(1000)", id, visina)) 
		return Koristite(playerid, "padobran [Ime ili ID igraca] [Visina (opciono, default = 1000)]");
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		
	// Glavna funkcija komande
	SetPlayerCompensatedPos(id, 1543.9408, -1354.1099, visina);
	GivePlayerWeapon(id, 46, 1);
	
	
	// Slanje poruke igracu i staffu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Poslati ste na skakanje padobranom od Game Admina %s (h = %.1fm).", ime_rp[playerid], visina);
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je poslao %s[ID: %d] na skakanje padobranom sa visine %.1fm.", ime_rp[playerid], ime_rp[id], id, visina);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /padobran | Izvrsio: %s | Igrac: %s | Visina: %.1f", ime_obicno[playerid], ime_obicno[id], visina);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

/*CMD:oglasi(playerid, const params[])
{
	if (!IsHelper(playerid, 1)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	for__loop (new i = 0; i < 10; i++)
	{
		if (!isnull(Oglasi[i])) SendClientMessage(playerid, ZELENA2, Oglasi[i]);
	}
	return 1;
}*/

CMD:eksplodiraj(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "eksplodiraj [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
	CreateExplosion(pozicija[id][0], pozicija[id][1], pozicija[id][2], 7, 10.0);
	
	
	// Slanje poruke igracu i staffu
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Eksplodirani ste od Game Admina %s.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je eksplodirao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		SendClientMessageF(id, BELA, "H {8EFF00}| Eksplodirani ste od Helpera %s.", ime_rp[playerid]);
		StaffMsg(BELA, "H {8EFF00}| %s je eksplodirao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}

	new Float:health;
	GetPlayerHealth(id, health);
	if (health <= 0.0) SetPVarInt(playerid, "pKilledByAdmin", 1);
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /eksplodiraj | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
 	return 1;
}

CMD:respawntijela(playerid, const params[])
{
	new Float:radius;

	if(sscanf(params, "f", radius)) return Koristite(playerid, "respawntijela [Udaljesnot (-1 za sva)]");

	if(radius == -1)
	{
		radius = -1;
		//GROBAR_DestroyBodies(playerid, radius);

		if (IsAdmin(playerid, 1))
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn svih tijela.", ime_rp[playerid]);
		else 
			StaffMsg(BELA, "H {8EFF00}| %s je pokrenuo respawn svih tijela.", ime_rp[playerid]);
	}
	else {
		//GROBAR_DestroyBodies(playerid, radius);

		if (IsAdmin(playerid, 1)) 
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn tijela u udaljenosti od %.1fm", ime_rp[playerid], radius);
		else 
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn tijela u udaljenosti od %.1fm", ime_rp[playerid], radius);
	}

	return 1;
}

CMD:respawn(playerid, const params[]) 
{
	if (respawn_pokrenut == true) 
		return ErrorMsg(playerid, "Respawn je vec pokrenut.");
	
	new 
		vreme, 
		Float:radius
	;
	if (sscanf(params, "if", vreme, radius)) 
		return Koristite(playerid, "respawn [Vreme do respawna (sekunde)] [Udaljenost (zona za respawn, za sva vozila koristite -1)]");
		
	if (vreme < 1 || vreme > 60) 
		return ErrorMsg(playerid, "Vreme mora biti izmedju 1 i 60 sekundi!");
		
		
	// Glavna funkcija komande
	format(string_128, sizeof string_128, "Sva prazna vozila ce biti respawnana za %d sekundi, udjite u vozilo da ga ne biste izgubili!", vreme);
	if (radius == -1) // Sva vozila
	{
		respawn_pokrenut = true;
		
		// Slanje poruke svim igracima
		foreach(new i : Player)
		{
			if (IsPlayerLoggedIn(i)) overwatch_poruka(i, string_128);
		}
		
		// Postavljanje tajmera za respawn
		SetTimerEx("respawn", vreme*1000, false, "ffff", 0, 0, 0, 0);
		
		// Slanje poruke staffu
		if (IsAdmin(playerid, 1))
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn svih vozila za %d sekundi.", ime_rp[playerid], vreme);
		else 
			StaffMsg(BELA, "H {8EFF00}| %s je pokrenuo respawn svih vozila za %d sekundi.", ime_rp[playerid], vreme);
	}
	else // U radiusu
	{
		respawn_pokrenut = true;
		
		// Slanje poruke igracima u radijusu
		GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
		foreach(new i : Player)
		{
			if (IsPlayerInRangeOfPoint(i, floatadd(radius, 30.0), pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2])) overwatch_poruka(i, string_128);
		}
		
		// Postavljanje tajmera za respawn
		SetTimerEx("respawn", vreme*1000, false, "ffff", pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], radius);
		
		// Slanje poruke staffu
		if (IsAdmin(playerid, 1)) 
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn vozila u udaljenosti od %.1fm za %d sekundi.", ime_rp[playerid], radius, vreme);
		else 
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je pokrenuo respawn vozila u udaljenosti od %.1fm za %d sekundi.", ime_rp[playerid], radius, vreme);
	}
	
	return 1;
}

CMD:utisaj(playerid, const params[]) 
{
	new 
		id, 
		vreme, 
		razlog[32];

	if (sscanf(params, "uis[32]", id, vreme, razlog)) 
		return Koristite(playerid, "utisaj [Ime ili ID igraca] [Vreme (minuti, 0 = unmute)] [Razlog utisavanja]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (IsHelper(id, 1) && !IsAdmin(playerid, 5))
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
		
		
	// Glavna funkcija komande
	if (vreme == 0) // Unmute
	{
		PI[id][p_utisan] = 0;
		SetPlayerChatBubble(id, "", BELA, 1.0, 100);
		
		// Slanje poruke igracu i staffu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Niste vise utisani, Game Admin: %s", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je omogucio upotrebu chata (unmute) igracu %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
		
		// Update podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET utisan = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		// Upisivanje u log
	 	format(string_128, sizeof string_128, "UNMUTE | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	 	Log_Write(LOG_KAZNE, string_128);
		
		return 1;
	}
	if (PI[id][p_utisan] > 0) // Igrac je vec utisan -> prikazivanje dialoga sa informacijama o preostalom vremenu i pitanjem "utisati ili ne"
	{
		// Upisivanje informacija za njihovu kasniju upotrebu
		SetPVarInt(playerid, "aKaznaID", id);
		SetPVarInt(playerid, "aKaznaCinc", cinc[id]);
		SetPVarInt(playerid, "aKaznaVreme", vreme);
		SetPVarString(playerid, "aKaznaRazlog", razlog);
		
		// Prikazivanje dialoga
		format(string_256, 160, "{FFFFFF}Igrac: {FF0000}%s {FFFFFF}je vec utisan.\nPreostalo vreme: {FF0000}%s\n\nZelite li da mu dodate %d:00 minuta?",
			ime_rp[id], konvertuj_vreme(PI[id][p_utisan]), vreme);
		SPD(playerid, "utisaj", DIALOG_STYLE_MSGBOX, "Igrac je vec utisan", string_256, "Da", "Ne");
		
		return 1;
	}
	PI[id][p_utisan] = vreme*60;
	PI[id][p_kaznjen_puta]++;
	format(PI[id][p_utisan_razlog], 32, "%s", razlog);
	SetPlayerChatBubble(id, "(( Ovaj igrac je UTISAN ))", 0xFF0000AA, 15.0, PI[id][p_utisan]*1000);
	
	
	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Utisani ste na %d minuta od Game Admina %s.", vreme, ime_rp[playerid]);
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je utisao igraca %s[ID: %d] na %d minuta.", ime_rp[playerid], ime_rp[id], id, vreme);
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Update podataka u bazi
	new query[140];
	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET utisan = %d, utisan_razlog = '%s', kaznjen_puta = %d WHERE id = %d", vreme*60, razlog, PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, query);

	// Insert u kazne
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'MUTE', '%s', %d)", PI[id][p_id], razlog, vreme);
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Upisivanje u log
 	format(string_256, 180, "MUTE | Izvrsio: %s | Igrac: %s | Vreme: %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], vreme, razlog);
 	Log_Write(LOG_KAZNE, string_256);
	
	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste utisali je previse mali nivo! Da opozovete akciju, koristite /utisaj.");
	return 1;
}

CMD:utisani(playerid, const params[])
{
	SendClientMessage(playerid, SVETLOCRVENA, "_______________ Utisani igraci_______________");
	foreach(new i : Player)
	{
		if (PI[i][p_utisan] > 0)
		{
			SendClientMessageF(playerid, BELA, "- %s[%d], vreme: %s - %s", ime_obicno[i], i, konvertuj_vreme(PI[i][p_utisan]), PI[i][p_utisan_razlog]);
		}
	}
	
	return 1;
}

CMD:zatvoreni(playerid, const params[])
{
	SendClientMessage(playerid, SVETLOCRVENA, "_______________ Zatvoreni igraci_______________");
	foreach(new i : Player)
	{
		if (PI[i][p_zatvoren] > 0 || PI[i][p_area] > 0)
		{
			//new vreme = PI[i][p_area]>0? PI[i][p_area] : PI[i][p_zatvoren];
			SendClientMessageF(playerid, BELA, "- %s[%d], vreme: %d (%s) - %s", ime_obicno[i], i, PI[playerid][p_zatvoren], (PI[i][p_area] > 0?("area"):("zatvor")), PI[i][p_area_razlog]);
		}
	}
	
	return 1;
}

CMD:afkeri(playerid, const params[])
{
	SendClientMessage(playerid, NARANDZASTA, "_______________ AFK igraci_______________");
	foreach(new i : Player)
	{
		if (IsPlayerAFK(i))
		{
			SendClientMessageF(playerid, BELA, "- %s[%d], vreme: %s", ime_obicno[i], i, konvertuj_vreme(GetPlayerAFKTime(i)));
		}
	}
	
	return 1;
}

CMD:novajlije(playerid, const params[]) 
{
	SendClientMessage(playerid, LTPINK, "________________ Novajlije ________________");
	foreach(new i : Player) 
	{
		if (IsNewPlayer(i)) 
		{
			format(string_128, sizeof string_128, "Ime: {FFFFFF}%s[ID: %d] | {FF8282}Nivo: {FFFFFF}%d", ime_obicno[i], i, PI[i][p_nivo]);
			SendClientMessage(playerid, LTPINK, string_128);
		}
	}
	return 1;
}

/*CMD:area(playerid, const params[])
{
	// ispod ide jos jedna provera (A4)
		
	new 
		id, 
		vreme, 
		razlog[31]
	;
	if (sscanf(params, "uis[31]", id, vreme, razlog)) 
		return Koristite(playerid, "area [Ime ili ID igraca] [Vreme (minuti, 0 = oslobadjanje)] [Razlog zatvaranja]");

	// Admini ispod A4 mogu samo da oslobadjaju igrace
	if (vreme > 0 && !IsAdmin(playerid, 4)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	if (IsHelper(id, 1) && !IsAdmin(playerid, 5)) 
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
	
	if (vreme < 0 || vreme > 99999999) 
		return ErrorMsg(playerid, "Nevazeci unos za vreme!");
		
		
	// Glavna funkcija komande
	if (vreme == 0) // Oslobadjanje iz zatvora
	{
		if (!IsPlayerJailed(id))
			return ErrorMsg(playerid, "Taj igrac nije zatvoren.");

		PI[id][p_zatvoren] = 0;
		PI[id][p_area] = 0;
		SetPlayerInterior(id, 0);
		SetPlayerVirtualWorld(id, 0);
		SetPlayerWorldBounds(id, 20000, -20000, 20000, -20000);
		SetPlayerCompensatedPos(id, 1802.7881, -1577.6869, 13.4119, 280.0);

		SetPlayerSkin(id, GetPlayerCorrectSkin(id));

		// Slanje poruke igracu i staffu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vas je oslobodio iz zatvora.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je oslobodio %s[ID: %d] iz zatvora.", ime_rp[playerid], ime_rp[id], id);
		
		// Update podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0,area = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		// Upisivanje u log
	 	format(string_128, sizeof string_128, "OSLOBODJEN | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	 	Log_Write(LOG_KAZNE, string_128);

		return 1;
	}

	if (PI[id][p_area] > 0) // Igrac je vec zatvoren -> prikazivanje dialoga sa informacijama o preostalom vremenu i pitanjem "zatvoriti ili ne"
	{
		// Upisivanje informacija za njihovu kasniju upotrebu
		SetPVarInt(playerid, "aKaznaID", id);
		SetPVarInt(playerid, "aKaznaCinc", cinc[id]);
		SetPVarInt(playerid, "aKaznaVreme", vreme);
		SetPVarString(playerid, "aKaznaRazlog", razlog);
		
		// Prikazivanje dialoga
		format(string_256, 160, "{FFFFFF}Igrac: {FF0000}%s {FFFFFF}je vec zatvoren.\nPreostalo vreme: {FF0000}%s\n\nZelite li da mu dodate %d:00 minuta?",
			ime_rp[id], konvertuj_vreme(PI[id][p_zatvoren]), vreme);
		SPD(playerid, "area", DIALOG_STYLE_MSGBOX, "Igrac je vec zatvoren", string_256, "Da", "Ne");

		return 1;
	}

	PI[id][p_kaznjen_puta]++;
	PI[id][p_area] = vreme*60;
	format(PI[id][p_area_razlog], 32, "%s", razlog);
	
	// Univerzalni kod za stavljanje igraca u zatvor
	stavi_u_zatvor(id, true);
	
	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Zatvoreni ste na %d minuta od Game Admina %s.", vreme, ime_rp[playerid]);
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je zatvorio igraca %s[ID: %d] na %d minuta.", ime_rp[playerid], ime_rp[id], id, vreme);
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Update podataka u bazi
	new query[140];
	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET area = %d, area_razlog = '%s', kaznjen_puta = %d WHERE id = %d", vreme*60, razlog, PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, query);
	
	// Upisivanje u log
 	format(string_256, 180, "AREA | Izvrsio: %s | Igrac: %s | Vreme: %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], vreme, razlog);
 	Log_Write(LOG_KAZNE, string_256);

	// Insert u kazne
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'AREA', '%s', %d)", PI[id][p_id], razlog, vreme);
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste zatvorili je previse mali nivo! Da opozovete akciju, koristite /area.");

	// Ako je bio zatvoren od strane policije, to ponistavamo
	if (PI[id][p_zatvoren] > 0) 
	{
		PI[id][p_zatvoren] = 0;
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
	}

	return 1;
}*/

CMD:area(playerid, const params[])
{
	// ispod ide jos jedna provera (A4)
		
	new 
		id, 
		vreme, 
		razlog[31]
	;
	if (sscanf(params, "uis[31]", id, vreme, razlog)) 
		return Koristite(playerid, "area [Ime ili ID igraca] [Vreme (minuti, 0 = oslobadjanje)] [Razlog zatvaranja]");

	// Admini ispod A4 mogu samo da oslobadjaju igrace
	if (vreme > 0 && !IsAdmin(playerid, 4)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	if (IsHelper(id, 1) && !IsAdmin(playerid, 5)) 
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
	
	if (vreme < 0 || vreme > 99999999) 
		return ErrorMsg(playerid, "Nevazeci unos za vreme!");
		
		
	// Glavna funkcija komande
	if (vreme == 0) // Oslobadjanje iz zatvora
	{
		if (!IsPlayerJailed(id))
			return ErrorMsg(playerid, "Taj igrac nije zatvoren.");

		PI[id][p_zatvoren] = 0;
		PI[id][p_area] = 0;
		SetPlayerInterior(id, 0);
		SetPlayerVirtualWorld(id, 0);
		SetPlayerWorldBounds(id, 20000, -20000, 20000, -20000);
		SetPlayerCompensatedPosEx(id, 1802.7881, -1577.6869, 13.4119, 280.0);

		// Slanje poruke igracu i staffu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vas je oslobodio iz zatvora.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je oslobodio %s[ID: %d] iz zatvora.", ime_rp[playerid], ime_rp[id], id);
		
		// Update podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0,area = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		// Upisivanje u log
	 	format(string_128, sizeof string_128, "OSLOBODJEN | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	 	Log_Write(LOG_KAZNE, string_128);

		return 1;
	}

	if (PI[id][p_area] > 0) // Igrac je vec zatvoren -> prikazivanje dialoga sa informacijama o preostalom vremenu i pitanjem "zatvoriti ili ne"
	{
		// Upisivanje informacija za njihovu kasniju upotrebu
		SetPVarInt(playerid, "aKaznaID", id);
		SetPVarInt(playerid, "aKaznaCinc", cinc[id]);
		SetPVarInt(playerid, "aKaznaVreme", vreme);
		SetPVarString(playerid, "aKaznaRazlog", razlog);
		
		// Prikazivanje dialoga
		format(string_256, 160, "{FFFFFF}Igrac: {FF0000}%s {FFFFFF}je vec zatvoren.\nPreostalo vreme: {FF0000}%s\n\nZelite li da mu dodate %d:00 minuta?",
			ime_rp[id], konvertuj_vreme(PI[id][p_zatvoren]), vreme);
		SPD(playerid, "area", DIALOG_STYLE_MSGBOX, "Igrac je vec zatvoren", string_256, "Da", "Ne");

		return 1;
	}

	PI[id][p_kaznjen_puta]++;
	PI[id][p_area] = vreme*60;
	format(PI[id][p_area_razlog], 32, "%s", razlog);
	
	// Univerzalni kod za stavljanje igraca u zatvor
	stavi_u_zatvor(id, true);
	
	// Slanje poruka igracu
	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Zatvoreni ste na %d minuta od Game Admina %s.", vreme, ime_rp[playerid]);
	SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Slanje poruka staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je zatvorio igraca %s[ID: %d] na %d minuta.", ime_rp[playerid], ime_rp[id], id, vreme);
	StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	
	// Update podataka u bazi
	new query[140];
	mysql_format(SQL, query, sizeof query, "UPDATE igraci SET area = %d, area_razlog = '%s', kaznjen_puta = %d WHERE id = %d", vreme*60, razlog, PI[id][p_kaznjen_puta], PI[id][p_id]);
	mysql_tquery(SQL, query);
	
	// Upisivanje u log
 	format(string_256, 180, "AREA | Izvrsio: %s | Igrac: %s | Vreme: %d min | Razlog: %s", ime_obicno[playerid], ime_obicno[id], vreme, razlog);
 	Log_Write(LOG_KAZNE, string_256);

	// Insert u kazne
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO kazne (pid, tip, razlog, trajanje) VALUES (%d, 'AREA', '%s', %d)", PI[id][p_id], razlog, vreme);
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
	
	// Slanje upozorenja adminu ako je igrac premali level
 	if (PI[id][p_nivo] < 5) overwatch_poruka(playerid, "Igrac koga ste zatvorili je previse mali nivo! Da opozovete akciju, koristite /area.");

	// Ako je bio zatvoren od strane policije, to ponistavamo
	if (PI[id][p_zatvoren] > 0) 
	{
		PI[id][p_zatvoren] = 0;
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET zatvoren = 0 WHERE id = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
	}

	return 1;
}

CMD:oslobodi(playerid, params[])
{
	new id;
	if (sscanf(params, "u", id))
		return Koristite(playerid, "oslobodi [Ime ili ID igraca]");

	new cmdParams[15];
	format(cmdParams, sizeof cmdParams, "%i 0 oslobodi", id);
	callcmd::area(playerid, cmdParams);
/*
	new cmdParams[15];
	format(cmdParams, sizeof cmdParams, "/area %i 0 oslobodi", id);
	PC_EmulateCommand(playerid, cmdParams);*/
	return 1;
}

flags:kickall(FLAG_ADMIN_6)
CMD:kickall(playerid, const params[])
{
	new razlog[32];

	if(sscanf(params, "s[32]", razlog)) return Koristite(playerid, "kickall [Razlog]");

	foreach(new i: Player) 
	{
		if(i != playerid)
		{
			SendClientMessageF(i, BELA, "{FF6347}- STAFF:{B4CDED} Izbaceni ste ste od Game Admina %s.", ime_rp[playerid]);
			SendClientMessageF(i, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
		
			Kick_Timer(i);
		}
	}

	format(string_256, 180, "Komanda: /kickall | Izvrsio: %s | Razlog: %s", ime_obicno[playerid], razlog);
 	Log_Write(LOG_KICK, string_256);
	
 	return 1;
}

CMD:kick(playerid, const params[])
{
	new 
		id, 
		razlog[32]
	;
	if (sscanf(params, "us[32]", id, razlog)) 
		return Koristite(playerid, "kick [Ime ili ID igraca] [Razlog izbacivanja]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		
	// Glavna funkcija komande
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		if (PI[playerid][p_admin] < PI[id][p_admin] && !gHeadAdmin{playerid})
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
		// Slanje poruka igracu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Izbaceni ste ste od Game Admina %s.", ime_rp[playerid]);
		SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
		
		// Slanje poruka staffu
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je izbacio igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
		StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		if (IsHelper(id, 1) && !gHeadAdmin{playerid}) // Helper nema pravo da izvrsi komandu na drugom helperu
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
		// Slanje poruka igracu
		SendClientMessageF(id, BELA, "H {8EFF00}| Izbaceni ste ste od Helpera %s.", ime_rp[playerid]);
		SendClientMessageF(id, SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
		
		// Slanje poruka adminu
		StaffMsg(BELA, "H {8EFF00}| %s je izbacio igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
		StaffMsg(SVETLOCRVENA, "* Razlog: {FFFFFF}%s", razlog);
	}
	
	
	// Upisivanje u log
 	format(string_256, 180, "Komanda: /kick | Izvrsio: %s | Igrac: %s | Razlog: %s", ime_obicno[playerid], ime_obicno[id], razlog);
 	Log_Write(LOG_KICK, string_256);
	
 	Kick_Timer(id); // Kick uvek na kraju, naravno
	return 1;
}

CMD:zamrzni(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "zamrzni [Ime ili ID igraca]");

	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	if(!IsAdmin(playerid, 6) && IsAdmin(id, 6))
		return ErrorMsg(playerid, "Greska pri imunitetu!");
	
	// Glavna funkcija komande
	TogglePlayerControllable_H(id, false);
	
	
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		if (PI[playerid][p_admin] < PI[id][p_admin] && !gHeadAdmin{playerid}) 
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
		// Slanje poruka igracu i staffu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Zamrznuti ste od Game Admina %s.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je zamrzao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		if (IsHelper(id, 1) && !gHeadAdmin{playerid}) // Helper nema pravo da izvrsi komandu na drugom helperu
			return overwatch_poruka(playerid, GRESKA_IMUNITET); 
			
		// Slanje poruka igracu i staffu
		SendClientMessageF(id, BELA, "H {8EFF00}| Zamrznuti ste od Helpera %s.", ime_rp[playerid]);
		StaffMsg(BELA, "H {8EFF00}| %s je zamrzao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /zamrzni | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:odmrzni(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "odmrzni [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	// Slanje poruka igracu  i staffu
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Odmrznuti ste od Game Admina %s.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je odmrzao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		SendClientMessageF(id, BELA, "H {8EFF00}| Odmrznuti ste od Helpera %s.", ime_rp[playerid]);
		StaffMsg(BELA, "H {8EFF00}| %s je odmrzao igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}


	// Glavna funkcija komande
	TogglePlayerControllable_H(id, true);
	if (PI[id][p_zavezan] == 1)
	{
		PI[id][p_zavezan] = 0;
		gPlayerHandcuffed{id} = false;
		gPlayerRopeTied{id} = false;
		SetPlayerCuffed(id, false);
		SendClientMessageF(playerid, TAMNOCRVENA, "(!) Taj igrac je bio zavezan uzetom ili lisicama!");
	}
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /odmrzni | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:osamari(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "osamari [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	
	// Slanje poruka igracu i staffu
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		if (PI[playerid][p_admin] < PI[id][p_admin] && !gHeadAdmin{playerid}) 
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Osamareni ste od Game Admina %s.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je osamario igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		if (IsHelper(id, 1) && !gHeadAdmin{playerid}) // Helper nema pravo da izvrsi komandu na drugom helperu
			return overwatch_poruka(playerid, GRESKA_IMUNITET);
			
		SendClientMessageF(id, BELA, "H {8EFF00}| Osamareni ste od Helpera %s.", ime_rp[playerid]);
		StaffMsg(BELA, "H {8EFF00}| %s je osamario igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
		
		
	// Glavna funkcija komande
	SlapPlayer(id, 10.0);
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /osamari | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_ADMINKOMANDE, string_128);
	
 	return 1;
}

CMD:idido(playerid, const params[])
{
	// Override za Promo i VIP
	if (IsPromoter(playerid, 2) && !IsHelper(playerid, 1))
		return callcmd::promogoto(playerid, params);

	if (IsVIP(playerid, 1) && !IsHelper(playerid, 1))
		return callcmd::vipgoto(playerid, params);
		

	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "idido [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, "Ne mozete se teleportovati do head admina.");

	if (IsHelper(playerid, 1) && !IsAdmin(playerid, 5) && !IsOnDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu komandu.");

	if (!IsAdmin(playerid, 1) && IsAdmin(id, 1))
		return ErrorMsg(playerid, GRESKA_IMUNITET);
	
	// Glavna funkcija komande
	SetPlayerInterior(playerid, GetPlayerInterior(id));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
	TeleportPlayer(playerid, pozicija[id][0], pozicija[id][1] + 4.0, pozicija[id][2]);
	
	
	// Slanje poruke igracu
 	SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovani ste do igraca %s[ID: %d].", ime_rp[id], id);
	InfoMsg(id, "%s se teleportovao do Vas.", ime_rp[playerid]);
	
	// Upisivanje u log
 	format(string_128, sizeof string_128, "Komanda: /idido | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_PORT, string_128);
	
	return 1;
}

CMD:dovedi(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "dovedi [Ime ili ID igraca]");

	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, "Ne mozete teleportovati head admina.");

	if (IsAdmin(id, 1) && !IsAdmin(playerid, 1))
		return ErrorMsg(playerid, "Ne mozete teleportovati admina.");

	if (IsHelper(playerid, 1) && !IsAdmin(playerid, 5) && !IsOnDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu komandu.");

	if (!IsAdmin(playerid, 5) && IsPlayerWanted(id))
		return ErrorMsg(playerid, "Taj igrac ima wanted level.");

	if (RecentPoliceInteraction(id))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu jer je igrac nedavno imao interakciju sa policijom. (anti abuse)");


		
		
	// Glavna funkcija komande
	SetPlayerInterior(id, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));
	GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	TeleportPlayer(id, pozicija[playerid][0], pozicija[playerid][1] + 4.0, pozicija[playerid][2]);
	
	
	// Slanje poruke igracu (teleportovanom)
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vas je teleportovao do sebe.", ime_rp[playerid]);
	else if (PI[playerid][p_helper] > 0)
		SendClientMessageF(id, BELA, "H {8EFF00}| %s Vas je teleportovao do sebe.", ime_rp[playerid]);
	
	// Slanje poruke igracu (adminu/helperu)
 	SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovali ste igraca %s[ID: %d] do sebe.", ime_rp[id], id);
	
	// Upisivanej u log
 	format(string_128, sizeof string_128, "Komanda: /dovedi | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_PORT, string_128);
	
	return 1;
}

// CMD:warn(playerid, const params[])
// {
// 	new 
// 		id, 
// 		razlog[31]
// 	;
// 	if (sscanf(params, "us[31]", id, razlog)) 
// 		return Koristite(playerid, "opomeni [Ime ili ID igraca] [Razlog opomene]");
		
// 	if (!IsPlayerConnected(id)) 
// 		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
// 	if (IsAdmin(id, 1) && !IsAdmin(playerid, 6)) // Ne sme da koristi komandu na drugim adminima, osim ako nije head
// 		return overwatch_poruka(playerid, GRESKA_IMUNITET);
		
		
// 	// Glavna funkcija komande
// 	PI[id][p_opomene]++;
// 	if (PI[id][p_opomene] >= 5) // Ima 5 ili vise opomena (ban)
// 	{
// 	    new trajanje = (PI[id][p_opomene] - 4) * 7200; // 7200 minuta = 5 dana
		
// 		// Slanje poruke opomenutom igracu
// 		ClearChatForPlayer(id, 20);
// 		SendClientMessage(id, CRVENA,   "______________________________________________________________________________");
// 		SendClientMessage(id, CRVENA,   "______________________________________________________________________________");
// 		SendClientMessage(id, CRVENA,   "ISKLJUCENJE SA SERVERA");
// 		SendClientMessageF(id, BELA,    "Ime: %s | Nivo: %d", ime_obicno[id], PI[id][p_nivo]);
// 		SendClientMessageF(id, BELA,    "- Dobili ste {FFFF00}%d. {FFFFFF}opomenu od Game Admina %s.", PI[id][p_opomene], ime_obicno[playerid]);
// 		SendClientMessageF(id, BELA,    "- Razlog opomene: %s", razlog);
// 		SendClientMessageF(id, BELA,    "- Trajanje iskljucenja: %d dana", (trajanje/1440));
// 	 	SendClientMessageF(id, BELA,    "Vasa IP adresa: %s | Datum i vreme: %s", PI[id][p_ip], trenutno_vreme());
//  		SendClientMessage(id, ZUTA,     "Ukoliko smatrate da je doslo do greske, slikajte ovo (F8) i zatrazite unban putem foruma: "#FORUM);
		
//  		// Slanje poruke staffu
//  		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je opomenuo igraca %s[ID: %d], razlog: %s", ime_rp[playerid], ime_rp[id], id, razlog);
//  		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je banovan od %s na %d dana, razlog: %s (opomena).", ime_rp[id], ime_rp[playerid], (trajanje/1440), razlog);

//  		banuj_igraca(id, razlog, gettime()+trajanje, ime_obicno[playerid], false); // Ban na kraju (zbog kicka)
// 	}
// 	else // Manje od 5 opomena
// 	{
// 		// Slanje poruke opomenutom igracu
// 	    ClearChatForPlayer(id, 20);
// 		SendClientMessage(id, CRVENA,   "______________________________________________________________________________");
// 		SendClientMessage(id, CRVENA,   "______________________________________________________________________________");
// 		SendClientMessage(id, CRVENA,   "OPOMENA");
// 		SendClientMessageF(id, BELA,    "Ime: %s | Nivo: %d", ime_obicno[id], PI[id][p_nivo]);
// 		SendClientMessageF(id, BELA,    "- Dobili ste {FFFF00}%d. {FFFFFF}opomenu od Game Admina %s.", PI[id][p_opomene], ime_obicno[playerid]);
// 		SendClientMessageF(id, BELA,    "- Razlog opomene: %s", razlog);
// 		SendClientMessage(id, BELA,     "* Zapamtite da nakon {FF0000}PETE {FFFFFF}automatski dobijate ban na najmanje 5 dana.");
//         SendClientMessageF(id, BELA,    "Vasa IP adresa: %s | Datum i vreme: %s", PI[id][p_ip], trenutno_vreme());
		
// 		// Slanje poruke staffu
//  		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je opomenuo igraca %s[ID: %d], razlog: %s", ime_rp[playerid], ime_rp[id], id, razlog);
// 	}
	
//  	// Upisivanje u log
//  	format(string_256, sizeof string_256, "Admin: %s | Igrac: %s | Broj: %d | Razlog: %s", ime_rp[playerid], ime_rp[id], PI[id][p_opomene], razlog);
//  	Log_Write(LOG_OPOMENE, string_256);
	
// 	return 1;
// }

CMD:ban(playerid, const params[])
{
	new 
		id, 
		trajanje, 
		md[7],
		razlog[32],
		banExpirationTime
	;
	if (sscanf(params, "uis[7] s[32]", id, trajanje, md, razlog)) 
	{
		Koristite(playerid, "ban [Ime ili ID igraca] [Trajanje bana (broj)] [minuta/dana] [Razlog bana]");
		SendClientMessage(playerid, GRAD2, "* Primer: /ban  [Ime_Prezime]  {FFFFFF}[30]  {FF0000}[minuta]  {BFC0C2}cheat   |   ban 30 minuta");
		SendClientMessage(playerid, GRAD2, "* Primer: /ban  [Ime_Prezime]  {FFFFFF}[10]  {FF0000}[dana]     {BFC0C2}cheat   |   ban 10 dana");
		SendClientMessage(playerid, GRAD2, "* Trajni ban: 0 dana ili 0 minuta");
		return 1;
	}


	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	if (IsHelper(id, 1) && !IsAdmin(playerid, 6)) // Ne sme da koristi komandu na drugim adminima/helperima ako nije head
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
	
	if (trajanje < 0 || trajanje > 1000000) 
		return ErrorMsg(playerid, "Nevazeci unos za trajanje bana!");

	if (trajanje == 0)
	{
		banExpirationTime = gettime() + (1000 * 24 * 60 * 60); // ban 1000 dana
	}
	else
	{
		if (!strcmp(md, "minuta", true) || !strcmp(md, "min", true)) 
		{
			banExpirationTime = gettime() + (trajanje * 60);
		}
		else if (!strcmp(md, "dana", true)) 
		{
			banExpirationTime = gettime() + (trajanje * 24 * 60 * 60);
		}
		else
		{
			return ErrorMsg(playerid, "Nevazeci unos za minute/dane. Upisite /ban (bez parametara) za vise informacija.");
		}
	}

		
 	// Slanje dodatnih informacija adminu koji je dao ban
	SendClientMessage(playerid, CRVENA,         "______________________________________________________________________________");
 	SendClientMessageF(playerid, SVETLOCRVENA,  "Informacije o iskljucenju %s (nivo: %d):", ime_obicno[id], PI[id][p_nivo]);
 	SendClientMessageF(playerid, BELA,          "Razlog iskljucenja: %s", razlog);
	SendClientMessageF(playerid, BELA,          "Istice za: %d %s", trajanje, md);
 	SendClientMessageF(playerid, BELA,          "IP: %s | Istice: %s | Vreme: %s", PI[id][p_ip], string_32, trenutno_vreme());
 	SendClientMessageF(playerid, SVETLOZUTA,    "Igracev IP nije banovan. Da banujete IP koristite {FFFFFF}/banip %s.", PI[id][p_ip]);
	

	// Slanje poruke igracu
	ClearChatForPlayer(id);
	SendClientMessage(id, CRVENA, 		"______________________________________________________________________________");
	SendClientMessage(id, CRVENA,         "______________________________________________________________________________");
	SendClientMessage(id, SVETLOCRVENA,   "[ISKLJUCENJE SA SERVERA] {FFFFFF}Ovo je obavestenje o Vasem iskljucenju sa servera.");
	SendClientMessageF(id, BELA,          "Ime: %s | Admin: %s | Nivo: %d | Novac: $%d (+$%d)", ime_obicno[id], ime_obicno[playerid], PI[id][p_nivo], PI[id][p_novac], PI[id][p_banka]);
	SendClientMessageF(id, BELA,          "Razlog iskljucenja: %s", razlog);
	if (trajanje > 0)
		SendClientMessageF(id, BELA,      "Istice za: %d %s", trajanje, md);
	else
		SendClientMessage(id, BELA,       "Istice: {FF0000}nikada");
	SendClientMessageF(id, BELA,          "Vasa IP adresa: %s | Datum i vreme: %s", PI[id][p_ip], trenutno_vreme());
	SendClientMessage(id, ZUTA,           "Ukoliko smatrate da je doslo do greske, slikajte ovo (F8) i zatrazite unban putem foruma: {FFFFFF}"#FORUM);
 	

	// Slanje poruke igracima
	new sMsg[100];
 	if (trajanje > 0) 
		format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s je banovan od %s na %d %s.", ime_rp[id], ime_rp[playerid], trajanje, md);
 	else 
		format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s je trajno banovan od %s.", ime_rp[id], ime_rp[playerid]);
	SendClientMessageToAll(BELA, sMsg);

	format(sMsg, sizeof sMsg, "* Razlog: {FFFFFF}%s", razlog);
	SendClientMessageToAll(SVETLOCRVENA, sMsg);
	
	
 	// Upisivanje u log + izbacivanje igraca
	if (GetPVarInt(playerid, "pFakeBan") == 1) 
	{
		SendClientMessage(id, ZUTA, "* Ovo je fake ban, mozete ponovo uci na server.");
		StaffMsg(BELA, "* fakeban");
		format(string_256, sizeof string_256, "FAKEBAN | Izvrsio: %s | Igrac: %s | Trajanje: %d %s | Razlog: %s", ime_obicno[playerid], ime_obicno[id], trajanje, md, razlog);
		Log_Write(LOG_BAN, string_256);
		Kick_Timer(id);
	}
	else 
	{
		format(string_256, sizeof string_256, "Izvrsio: %s | Igrac: %s | Trajanje: %d %s | Razlog: %s", ime_obicno[playerid], ime_obicno[id], trajanje, md, razlog);
		Log_Write(LOG_BAN, string_256);
	 	banuj_igraca(id, razlog, banExpirationTime, ime_obicno[playerid], false); // Ban na kraju (zbog kicka)
	}
	return 1;
}

CMD:fakeban(playerid, const params[])
{
	SetPVarInt(playerid, "pFakeBan", 1);
	callcmd::ban(playerid, params);
	SetPVarInt(playerid, "pFakeBan", 0);
	return 1;
}

CMD:offban(playerid, const params[])
{
	new 
		ime[MAX_PLAYER_NAME], 
		trajanje, 
		md[7],
		razlog[32]
	;
	if (sscanf(params, "s[24] i s[7] s[32]", ime, trajanje, md, razlog)) {
		Koristite(playerid, "offban [Ime igraca u formatu Ime_Prezime] [Trajanje bana (broj)] [minuta/dana] [Razlog bana]");
		SendClientMessage(playerid, GRAD2, "* Primer: /offban  [Ime_Prezime]  {FFFFFF}[30]  {FF0000}[minuta]  {BFC0C2}cheat   |   ban 30 minuta");
		SendClientMessage(playerid, GRAD2, "* Primer: /offban  [Ime_Prezime]  {FFFFFF}[10]  {FF0000}[dana]     {BFC0C2}cheat   |   ban 10 dana");
		SendClientMessage(playerid, GRAD2, "* Trajni ban: 0 dana ili 0 minuta");
		SendClientMessageF(playerid, -1, "ime: %s, trajanje: %d, md: %s, razlog: %s", ime, trajanje, md, razlog);
		return 1;
	}
	// SendClientMessageF(playerid, -1, "ime: %s, trajanje: %d, md: %s, razlog: %s", ime, trajanje, md, razlog);
	new id = GetPlayerIDFromName(ime);
	if (IsPlayerConnected(id)) 
		return ErrorMsg(playerid, "Igrac je prisutan na serveru, koristite /ban.");
	
	if (trajanje < 0 || trajanje > 1000000) 
		return ErrorMsg(playerid, "Nevazeci unos za vreme!");

	if (strcmp(md, "minuta", true) && strcmp(md, "min", true) && strcmp(md, "dana", true))
		return ErrorMsg(playerid, "Nevazeci unos za minute/dane. Upisite /offban (bez parametara) za vise informacija.");

		
	// Glavna funkcija komande
	format(mysql_upit, 70, "SELECT id FROM igraci WHERE ime = '%s'", ime);
	mysql_tquery(SQL, mysql_upit, "mysql_offban", "iisssi", playerid, trajanje, md, ime, razlog, cinc[playerid]);
	
	return 1;
}

CMD:bannick(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "bannick [Ime ili ID igraca]");
	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	if (IsHelper(id, 1) && !IsAdmin(playerid, 6)) 
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
	
	// Slanje poruka igracu
	SendClientMessage(id, ZELENA, 		"___________________________ {FFFFFF}Poruka servera {33AA33}___________________________");
	SendClientMessage(id, CRVENA, 		"	Izbaceni ste sa servera zbog loseg imena!");
	SendClientMessage(id, ZUTA,   		"	Kako se ovo ne bi u buducnosti dogadjalo, procitajte kako Vase ime treba da izgleda:");
	SendClientMessage(id, ZUTA,   		"   - Vase ime mora biti u formatu {FFFFFF}Ime_Prezime {FFFF00}i obavezno mora sadrzati: \"_\" (crticu)");
	SendClientMessage(id, ZUTA,   		"   - Ime ne mora biti Vase pravo ime, ali ne sme biti ime neke javne licnosti.");
	SendClientMessage(id, ZUTA,   		"   - Ime ne sme sadrzati ime nekog poznatog brenda i ne sme nikoga vredjati.");
	SendClientMessage(id, ZUTA,   		"   Primer dobrog imena: {FFFFFF}Marko_Nikolic, Steve_Petterson");
	SendClientMessage(id, SVETLOCRVENA, 	"   Game Admin je banovao (zabranio) Vase ime!");
	SendClientMessage(id, ZELENA, 		"___________________________________________________________________");
	
 	// Upisivanje u log
 	format(string_128, sizeof string_128, "BANNICK | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
 	Log_Write(LOG_BAN, string_128);
	
 	banuj_igraca(id, "Lose ime (bannick)", 0, ime_obicno[playerid], false);
	
 	return 1;
}

CMD:unban(playerid, const params[])
{
	new ime[MAX_PLAYER_NAME];
	if (sscanf(params, "s[24]", ime)) 
		return Koristite(playerid, "unban [Ime igraca (ime mora sadrzati donju crtu)]");
		
		
	// Glavna funkcija komande
	new upit[102];
	format(upit, sizeof upit, "DELETE b FROM banovi b INNER JOIN igraci i ON i.id = b.pid WHERE i.ime = '%s'", ime);
	mysql_tquery(SQL, upit, "mysql_unban", "isi", playerid, ime, cinc[playerid]);
	
	return 1;
}

CMD:banip(playerid, const params[])
{
	new ip[16];
	if (sscanf(params, "s[16]", ip)) 
		return Koristite(playerid, "banip [IP adresa]");
		
		
	// Glavna funkcija komande
	new query[110];
	mysql_format(SQL, query, sizeof query, "INSERT INTO ip_banovi VALUES ('%s', %i) ON DUPLICATE KEY UPDATE vreme = %i", ip, gettime(), gettime());
	mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_BANIP);
	
	
	// Slanje poruke staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je banovao IP %s.", ime_rp[playerid], ip);
	
	// Upisivanje u log
 	format(string_64, 64, "BANIP | %s | %s", ime_obicno[playerid], ip);
 	Log_Write(LOG_BAN, string_64);
	
	return 1;
}

CMD:unbanip(playerid, const params[])
{
	new ip[16];
	if (sscanf(params, "s[16]", ip)) 
		return Koristite(playerid, "unbanip [IP adresa]");
		
		
	// Glavna funkcija komande
	mysql_format(SQL, mysql_upit, 58, "DELETE FROM ip_banovi WHERE ip = '%s'", ip);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_DELETEROW);
	
	
	// Slanje poruke staffu
	StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je odbanovao IP %s.", ime_rp[playerid], ip);
	
	// Upisivanje u log
 	format(string_64, 64, "UNBANIP | %s | %s", ime_obicno[playerid], ip);
 	Log_Write(LOG_BAN, string_64);
	
	return 1;
}

CMD:ididocp(playerid, const params[])
{
	new Float:x, Float:y, Float:z;
	if (GetPlayerCheckpoint_cp(playerid, x, y, z))
	{
		TeleportPlayer(playerid, x, y, z);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	}
	else 
	{
		if (IsValidDynamicCP(GetPlayerVisibleDynamicCP(playerid))) 
		{
			new interior, virtual;
			Streamer_GetFloatData(STREAMER_TYPE_CP, GetPlayerVisibleDynamicCP(playerid), E_STREAMER_X, x);
			Streamer_GetFloatData(STREAMER_TYPE_CP, GetPlayerVisibleDynamicCP(playerid), E_STREAMER_Y, y);
			Streamer_GetFloatData(STREAMER_TYPE_CP, GetPlayerVisibleDynamicCP(playerid), E_STREAMER_Z, z);
			interior = Streamer_GetIntData(STREAMER_TYPE_CP, GetPlayerVisibleDynamicCP(playerid), E_STREAMER_INTERIOR_ID);
			virtual  = Streamer_GetIntData(STREAMER_TYPE_CP, GetPlayerVisibleDynamicCP(playerid), E_STREAMER_WORLD_ID);

			TeleportPlayer(playerid, x, y, z);
			if (interior != -1) SetPlayerInterior(playerid, interior);
			if (virtual != -1) SetPlayerVirtualWorld(playerid, virtual);
		}
		else return ErrorMsg(playerid, "Trenutno nije prikazan ni jedan checkpoint.");
	}
	
	SendClientMessage(playerid, GRAD2, "(teleport) Teleportovani ste do checkpointa.");
	
	// Upisivanje u log
	new sLog[48];
	format(sLog, sizeof sLog, "Komanda: /ididocp | %s", ime_obicno[playerid]);
	Log_Write(LOG_PORT, sLog);
	return 1;
}

CMD:ididorcp(playerid, const params[])
{
	new Float:x, Float:y, Float:z;
	if (GetPlayerRaceCheckpoint_cp(playerid, x, y, z))
	{
		
		TeleportPlayer(playerid, x, y, z);
		SendClientMessage(playerid, GRAD2, "(teleport) Teleportovani ste do race checkpointa.");
		
		// Upisivanje u log
		new sLog[49];
		format(sLog, sizeof sLog, "Komanda: /ididrocp | %s", ime_obicno[playerid]);
		Log_Write(LOG_PORT, sLog);
	}
	else return ErrorMsg(playerid, "Trenutno nije prikazan nijedan race checkpoint!");
	return 1;
}

// CMD:aset(playerid, p[])
// {
//     PI[playerid][p_admin] = strval(p);
//     FLAGS_SetupStaffFlags(playerid);
//     return 1;
// }
// CMD:hset(playerid, p[])
// {
//     PI[playerid][p_helper] = strval(p);
//     FLAGS_SetupStaffFlags(playerid);
//     return 1;
// }
// CMD:pset(playerid, p[])
// {
//     PI[playerid][p_promoter] = strval(p);
//     FLAGS_SetupPromoterFlags(playerid);
//     return 1;
// }
// CMD:vipset(playerid, p[])
// {
//     PI[playerid][p_vip_level] = strval(p);
//     FLAGS_SetupVIPFlags(playerid);
//     return 1;
// }

CMD:tp(playerid, const params[]) 
{
	// Override za Promo i VIP (dodavanje/provera cooldown-a)
	if (IsPromoter(playerid, 1) && !IsHelper(playerid, 1))
	{
		if (GetPVarInt(playerid, "pPromoterPort") == 0)
		{
			return ErrorMsg(playerid, "Koristite /port.");
		}

		else if (GetPVarInt(playerid, "pPromoterPort") == 1)
		{
			DeletePVar(playerid, "pPromoterPort");

			if (GetPVarInt(playerid, "pPromoterPortCooldown") > gettime())
				return ErrorMsg(playerid, "Vec ste nedavno koristili ovu naredbu. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "pPromoterPortCooldown")-gettime()));

			if (IsPromoter(playerid, 3))
			{
				SetPVarInt(playerid, "pPromoterPortCooldown", gettime()+120); // 2 minuta za promo3
			}
			else
			{
				SetPVarInt(playerid, "pPromoterPortCooldown", gettime()+180); // 3 minuta za promo1,2
			}
		}
	}

	if (IsVIP(playerid, 1) && !IsHelper(playerid, 1))
	{
		if (GetPVarInt(playerid, "pVIPPort") == 0)
			return ErrorMsg(playerid, "Koristite /port.");

		else if (GetPVarInt(playerid, "pVIPPort") == 1)
		{
			DeletePVar(playerid, "pVIPPort");

			if (GetPVarInt(playerid, "pVIPPortCooldown") > gettime())
				return ErrorMsg(playerid, "Vec ste nedavno koristili ovu naredbu. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "pVIPPortCooldown")-gettime()));

			SetPVarInt(playerid, "pVIPPortCooldown", gettime()+120); // 2 minuta
		}
	}

	if (IsHelper(playerid, 1) && !IsAdmin(playerid, 5) && !IsOnDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu komandu.");

	if (!isnull(params) && !strcmp(params, "head", true) && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new bool:found = false, lokacija[24];
	if (!isnull(params))
	{
		for__loop (new i = 0; i < sizeof Teleports; i++)
		{
			if (!strcmp(params, Teleports[i][portKeyword], true))
			{
				found = true;
				TeleportPlayer(playerid, Teleports[i][portX], Teleports[i][portY], Teleports[i][portZ]);
				format(lokacija, sizeof lokacija, "%s", Teleports[i][portName]);
				break;
			}
		}
	}

	if (!found) 
	{
		new bool:found2 = false;
		if (!isnull(params))
		{
			for__loop (new i = 0; i < MAX_FACTIONS; i++) 
			{
				if (isnull (FACTIONS[i][f_tag])) continue;
				if (!strcmp(FACTIONS[i][f_tag], params, true)) 
				{
					found2 = true;
					TeleportPlayer(playerid, FACTIONS[i][f_x_spawn], FACTIONS[i][f_y_spawn], FACTIONS[i][f_z_spawn]);
					format(lokacija, sizeof lokacija, "%s", FACTIONS[i][f_tag]);
					break;
				}
			}
		}
		if (!found2)
		{
			//callcmd::gps(playerid);
			new string[(sizeof Teleports + 3) * sizeof lokacija];
			format(string, sizeof(string), "Precica\tNaziv lokacije");
			for__loop (new i = 0; i < sizeof Teleports; i++)
			{
				format(string, sizeof string, "%s\n%s\t%s", string, Teleports[i][portKeyword], Teleports[i][portName]);
			}
			SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
			return 1;
		}
	}

	// Postavljane enterijera i worlda na 0
	if (GetPlayerVehicleID(playerid) != 0)
	{
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
	}
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	SetCameraBehindPlayer(playerid);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovani ste na lokaciju: {FFFFFF}%s.", lokacija);


	// Upisivanje u log (promoteri)
	if (IsPromoter(playerid, 1)) 
	{
		new string[128];
		format(string, sizeof string, "/port | %s | %s", ime_obicno[playerid], lokacija);
		Log_Write(LOG_PROMOTER, string);
	}
	// Upisivanje u log (VIP)
	if (IsVIP(playerid, 1)) 
	{
		new string[128];
		format(string, sizeof string, "/port | %s | %s", ime_obicno[playerid], lokacija);
		Log_Write(LOG_VIP, string);
	}
	return 1;
}

CMD:ptp(playerid, const params[]) 
{
	new id, loc[16];
	if (sscanf(params, "us[16]", id, loc))
		return Koristite(playerid, "ptp [Ime ili ID igraca] [Lokacija]");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (IsHelper(id, 1))
		return ErrorMsg(playerid, GRESKA_IMUNITET);

	if (!IsAdmin(playerid, 5) && GetPlayerCrimeLevel(id) >= 3)
		return ErrorMsg(playerid, "Taj igrac ima wanted level 3+.");

	if (!IsHelper(playerid, 3) && PI[id][p_nivo] > 10)
		return ErrorMsg(playerid, "Taj igrac ima nivo veci od 10.");

	if (gCmdUsedOnPlayer_Ptp[id] > gettime())
		return ErrorMsg(playerid, "Drugi Helper/Admin je vec koristio ovu komandu za tog igraca.");

	if (RecentPoliceInteraction(id))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu jer je igrac nedavno imao interakciju sa policijom. (anti abuse)");

	if (!strcmp(loc, "head", true) && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new bool:found = false, lokacija[24];
	for__loop (new i = 0; i < sizeof Teleports; i++)
	{
		if (!strcmp(loc, Teleports[i][portKeyword], true))
		{
			found = true;
			TeleportPlayer(id, Teleports[i][portX], Teleports[i][portY], Teleports[i][portZ]);
			format(lokacija, sizeof lokacija, "%s", Teleports[i][portName]);
		}
	}

	if (!found) 
	{
		new bool:found2 = false;
		for__loop (new i = 0; i < MAX_FACTIONS; i++) 
		{
			if (isnull (FACTIONS[i][f_tag])) continue;
			if (!strcmp(FACTIONS[i][f_tag], loc, true)) 
			{
				found2 = true;
				TeleportPlayer(id, FACTIONS[i][f_x_spawn], FACTIONS[i][f_y_spawn], FACTIONS[i][f_z_spawn]);
				format(lokacija, sizeof lokacija, "%s", FACTIONS[i][f_tag]);
				break;
			}
		}
		if (!found2)
			return ErrorMsg(playerid, "Uneli ste nepoznatu lokaciju.");
	}

	// Postavljane enterijera i worlda na 0
	if (GetPlayerVehicleID(id) != 0)
	{
		LinkVehicleToInterior(GetPlayerVehicleID(id), 0);
		SetVehicleVirtualWorld(GetPlayerVehicleID(id), 0);
	}
	SetPlayerInterior(id, 0);
	SetPlayerVirtualWorld(id, 0);
	SetCameraBehindPlayer(id);
	
	// Slanje poruka
	if (IsAdmin(playerid, 1))
	{
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je teleportovao %s na lokaciju: {FFFFFF}%s.", ime_rp[playerid], ime_rp[id], lokacija);
	}
	else if (IsHelper(playerid, 1))
	{
		StaffMsg(BELA, "H {8EFF00}| %s je teleportovao %s na lokaciju: {FFFFFF}%s.", ime_rp[playerid], ime_rp[id], lokacija);
	}
	SendClientMessageF(id, INFO, "(teleport) {9DF2B5}%s Vas je teleportovao na lokaciju: {FFFFFF}%s.", ime_rp[playerid], lokacija);

	gCmdUsedOnPlayer_Ptp[id] = gettime() + 15;
	return 1;
}

CMD:nick(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "nick [Ime ili ID igraca]");
	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (IsHelper(id, 1) && !IsAdmin(playerid, 5))
		return overwatch_poruka(playerid, GRESKA_IMUNITET);
	
	if (IsAdmin(playerid, 1))
	{
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je upozorio igraca %s na nepravilno ime.", ime_rp[playerid], ime_rp[id]);
	}
	else if (IsHelper(playerid, 1))
	{
		StaffMsg(BELA, "H {8EFF00}| %s je upozorio igraca %s na nepravilno ime.", ime_rp[playerid], ime_rp[id]);
	}
	format(string_128, sizeof string_128, "Komanda: /nick | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	SendClientMessage(id, ZELENA, 		"___________________________ {FFFFFF}Poruka servera {33AA33}___________________________");
	SendClientMessage(id, CRVENA, 		"	Izbaceni ste sa servera zbog loseg imena!");
	SendClientMessage(id, ZUTA,   		"	Kako se ovo ne bi u buducnosti dogadjalo, procitajte kako Vase ime treba da izgleda:");
	SendClientMessage(id, ZUTA,   		"   - Vase ime mora biti u formatu {FFFFFF}Ime_Prezime {FFFF00}i obavezno mora sadrzati: \"_\" (crticu)");
	SendClientMessage(id, ZUTA,   		"   - Ime ne mora biti Vase pravo ime, ali ne sme biti ime neke javne licnosti.");
	SendClientMessage(id, ZUTA,   		"   - Ime ne sme sadrzati ime nekog poznatog brenda i ne sme nikoga vredjati.");
	SendClientMessage(id, ZUTA,   		"   Primer dobrog imena: {FFFFFF}Marko_Nikolic, Steve_Petterson");
	SendClientMessage(id, SVETLOCRVENA, 	"   Promenite svoje ime!");
	SendClientMessage(id, ZELENA, 		"___________________________________________________________________");
	Kick_Timer(id);
	
	return 1;
}

CMD:cc(playerid, const params[]) 
{
	if (gettime() < gChatCleared) 
		return ErrorMsg(playerid, "Chat je ociscen pre manje od 10 sekundi!");
		
	new 
		bool:force = (!isnull(params) && !strcmp(params, "force", true))? true : false;

	foreach(new i : Player) 
	{
		if (force || (!force && !IsHelper(i, 1))) 
		{
			ClearChatForPlayer(i);
			SendClientMessage(i, BELA, "{33CCFF}-| {FFFFFF}Northern Lights {33CCFF}| "#FORUM" |-");
		}
	}
		
	// HUD_SetRandomMsg();
	gChatCleared = gettime() + 10;
	
	// Slanje poruke staffu
	StaffMsg(SVETLOPLAVA, "%s je ocistio chat.", ime_rp[playerid]);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /cc | Izvrsio: %s", ime_obicno[playerid]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:ubij(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "ubij [Ime ili ID igraca]");
	
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
	
	
	if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
	{
		if (PI[playerid][p_admin] < PI[id][p_admin] && !gHeadAdmin{playerid}) 
			return overwatch_poruka(playerid, GRESKA_IMUNITET);

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Ubijeni ste od Game Admina %s.", ime_rp[playerid]);
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je ubio igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	else if (PI[playerid][p_helper] > 0)
	{
		if (IsHelper(id, 1) && !gHeadAdmin{playerid}) 
			return overwatch_poruka(playerid, GRESKA_IMUNITET); // Helper nema pravo da izvrsi komandu na drugom helperu

		SendClientMessageF(id, BELA, "H {8EFF00}| Ubijeni ste od Helpera %s.", ime_rp[playerid]);
		StaffMsg(BELA, "H {8EFF00}| %s je ubio igraca %s[ID: %d].", ime_rp[playerid], ime_rp[id], id);
	}
	
	if (PI[id][p_zavezan] == 1) 
	{
		PI[id][p_zavezan] = 0;
		gPlayerHandcuffed{id} = false;
		gPlayerRopeTied{id} = false;
		SetPlayerCuffed(id, false);
		SendClientMessageF(playerid, TAMNOCRVENA, "(!) Taj igrac je bio zavezan uzetom ili lisicama!");
	}
	
	SetPVarInt(id, "pKilledByAdmin", 1);
	SetPlayerHealth(id, 0.0);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /ubij | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[id]);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

CMD:duznost(playerid, const params[])
{
	if (IsPlayerInRangeOfPoint(playerid, 3.0, 208.7232, 146.1103, 1002.9891) || IsPlayerInRangeOfPoint(playerid, 3.0, 1401.8984,-1.0861,1001.0008) || IsPlayerInRangeOfPoint(playerid, 3.0, 258.4168,109.5337,1003.2188))
		return callcmd::duty(playerid, ""); //PC_EmulateCommand(playerid, "/duty"); // za PD/SWAT (duznost)

	if (!IsHelper(playerid, 1) && !PlayerFlagGet(playerid, FLAG_MAPER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	// Ukljucivanje duznosti
	if (!IsOnDuty(playerid)) 
	{
		/*if (pDutyCooldown[playerid] > gettime())
			return ErrorMsg(playerid, "Duznost je nedavno iskljucena. Pokusaj ponovo za %s.", konvertuj_vreme(pDutyCooldown[playerid] - gettime()));*/

		// Uklanja ga sa liste traznih da se ne bi pojavljivao crveni marker
		if (Iter_Contains(iWantedPlayers, playerid))
		{
			Iter_Remove(iWantedPlayers, playerid);
		}

		GetPlayerHealth(playerid, duty_stats[playerid][0]);
		GetPlayerArmour(playerid, duty_stats[playerid][1]);
		SetPlayerHealth(playerid, 99.0);
		SetPlayerArmour(playerid, 99.0);
		gStaffDuty{playerid} = true;
		dutyStartTime[playerid] = gettime();
		dutyAFKTime[playerid] = 0;
	   
		if (IsAdmin(playerid, 6)) 
		{
			if(!gOwner{playerid})
				gStaffDutyLabel[playerid] = Create3DTextLabel("(( Head Admin na duznosti ))", 0xFFFF00AA, 9999.0, 9999.0, 9999.0, 15.0, 0);
			else
				gStaffDutyLabel[playerid] = Create3DTextLabel("(( Owner na duznosti ))", 0xd30a0aFF, 9999.0, 9999.0, 9999.0, 15.0, 0);

			if (!isnull(params) && !strcmp(params, "inv"))
			{
				SetPlayerColor(playerid, 0xFFFF0000);
			}
			else
			{
				SetPlayerColor(playerid, ZUTA);
				if(!gOwner{playerid})
					SendClientMessageFToAll(ZUTA, "(( Head Admin %s je sada na duznosti. ))", ime_rp[playerid]);
				else
					SendClientMessageFToAll(0xd30a0aFF, "(( Owner %s je sada na duznosti. ))", ime_rp[playerid]), SetPlayerColor(playerid, 0xd30a0aFF);
			}          
		}
		else if (IsAdmin(playerid, 1)) 
		{
			gStaffDutyLabel[playerid] = Create3DTextLabel("(( Game Admin na duznosti ))", 0x33CCFFFF, 9999.0, 9999.0, 9999.0, 15.0, 0);
			SendClientMessageFToAll(PLAVA, "(( Game Admin %s je sada na duznosti. ))", ime_rp[playerid]);
			SetPlayerColor(playerid, PLAVA);
		}
		else if (IsHelper(playerid, 1)) 
		{
			gStaffDutyLabel[playerid] = Create3DTextLabel("(( Helper na duznosti ))", 0x00FF00FF, 9999.0, 9999.0, 9999.0, 15.0, 0);
			SendClientMessageFToAll(ZELENOZUTA, "(( Helper %s je sada na duznosti. ))", ime_rp[playerid]);
			SetPlayerColor(playerid, ZELENOZUTA);
		}
		
		DettachPlayerBodyArmor(playerid); // ne zelimo da staff ima pancir dok su na duznosti
		Attach3DTextLabelToPlayer(gStaffDutyLabel[playerid], playerid, 0.0, 0.0, 0.5);
		format(string_64, 64, "Izvrsio: %s | Status: 1", ime_obicno[playerid]);
	}
	
	// Iskljucivanje duznosti
	else 
	{
		/*if (pDutyCooldown[playerid] > gettime())
			return ErrorMsg(playerid, "Duznost je nedavno ukljucena. Pokusaj ponovo za %s.", konvertuj_vreme(pDutyCooldown[playerid] - gettime()));*/

		// Vraca ga na listu trazenih ako je potrebno
		if (IsPlayerWanted(playerid) && !Iter_Contains(iWantedPlayers, playerid))
		{
			Iter_Add(iWantedPlayers, playerid);
		}

		SetPlayerHealth(playerid, duty_stats[playerid][0]);
		SetPlayerArmour(playerid, duty_stats[playerid][1]);
		Delete3DTextLabel(gStaffDutyLabel[playerid]);
		gStaffDutyLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
		gStaffDuty{playerid} = false;
		dutyTimeTotal[playerid] += gettime() - dutyStartTime[playerid] - dutyAFKTime[playerid];
		UpdateDutyTime(playerid);
		
		if (IsAdmin(playerid, 6))
		{
			if(!gOwner{playerid})
				SendClientMessageFToAll(ZUTA, "(( Head Admin %s vise nije na duznosti. ))", ime_rp[playerid]);
			else
				SendClientMessageFToAll(0xd30a0aFF, "(( Owner %s vise nije na duznosti. ))", ime_rp[playerid]);
		}

		else if (IsAdmin(playerid, 1))
			SendClientMessageFToAll(PLAVA, "(( Game Admin %s nije vise na duznosti. ))", ime_rp[playerid]);

		else if (IsHelper(playerid, 1))
			SendClientMessageFToAll(ZELENOZUTA, "(( Helper %s nije vise na duznosti. ))", ime_rp[playerid]);

		SetPlayerColor(playerid, PI[playerid][p_boja_imena]);
	}

	//SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
	pDutyCooldown[playerid] = gettime() + 180;
	Log_Write(LOG_DUZNOSTI, string_64);
	return 1;
}

CMD:xgoto(const playerid, params[])
{
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new Float:Poz[ 3 ];
	if( sscanf(params, "fff", Poz[ 0 ], Poz[ 1 ], Poz[ 2 ] ) ) return ErrorMsg( playerid, "/xgoto [ x ] [ y ] [ z ]." );

	if( IsPlayerInAnyVehicle( playerid ) ) { SetVehiclePos( GetPlayerVehicleID( playerid ), Poz[ 0 ], Poz[ 1 ], Poz[ 2 ] ); }
	else { SetPlayerPos( playerid, Poz[ 0 ], Poz[ 1 ], Poz[2 ] ); }

    SendClientMessageF( playerid, SVETLOPLAVA, "Teleportovani ste na koordinate %f, %f, %f", Poz[ 0 ], Poz[ 1 ], Poz[ 2 ] );

	return true;
}

CMD:postavi(const playerid, params[]) 
{
	new str[12], id, parametar;

	if (strfind(params, "zaduzenje") != -1) // Postavi: zaduzenje
	{
		if (!IsAdmin(playerid, 6))
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
			
		new zaduzenje[20+1];
		if (sscanf(params, "s[10] u s[20]", str, id, zaduzenje)) 
			return Koristite(playerid, "postavi zaduzenje [Ime ili ID igraca] [vodja helpera / vodja admina / vodja lidera / vodja promotera]");
			
		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (!strcmp(zaduzenje, "vodja helpera", true))
		{
			PI[id][p_custom_flags] |= FLAG_HELPER_VODJA;
			PlayerFlagSet(id, FLAG_HELPER_VODJA);
		}
		else if (!strcmp(zaduzenje, "vodja admina", true))
		{
			PI[id][p_custom_flags] |= FLAG_ADMIN_VODJA;
			PlayerFlagSet(id, FLAG_ADMIN_VODJA);
		}
		else if (!strcmp(zaduzenje, "vodja lidera", true))
		{
			PI[id][p_custom_flags] |= FLAG_LEADER_VODJA;
			PlayerFlagSet(id, FLAG_LEADER_VODJA);
		}
		else if (!strcmp(zaduzenje, "vodja promotera", true))
		{
			PI[id][p_custom_flags] |= FLAG_PROMO_VODJA;
			PlayerFlagSet(id, FLAG_PROMO_VODJA);
		}
		else
			return ErrorMsg(playerid, "Uneli ste nepoznato zaduzenje.");

		// Formatiranje poruka za slanje igracu
		SendClientMessageF(id, SVETLOPLAVA, "* Dobili ste zaduzenje: %s | Head admin: %s.", zaduzenje, ime_rp[playerid]);
		
		// Slanje poruke igracu
		format(string_128, sizeof string_128, "* Postavili ste zaduzenje %s igracu %s[%d].", zaduzenje, ime_rp[id], id);
		SendClientMessage(playerid, SVETLOPLAVA, string_128);
		
		// Update podataka u bazi
		new query[70];
		mysql_format(SQL,query, sizeof query, "UPDATE igraci SET custom_flags = %i WHERE id = %i", PI[id][p_custom_flags], PI[id][p_id]);
		mysql_tquery(SQL, query);

		// Upisivanje u log
		format(string_128, sizeof string_128, "ZADUZENJE | Izvrsio: %s | Igrac: %s | Nivo: %s", ime_obicno[playerid], ime_obicno[id], zaduzenje);
		Log_Write(LOG_POZICIJE, string_128);
	}

	else if (strfind(params, "admin") != -1) // postavi: admin
	{
		if (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_ADMIN_VODJA))
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[7]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi admin [Ime ili ID igraca] [Admin nivo]");

		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 6) 
			return ErrorMsg(playerid, "Admin nivo mora biti izmedju 0 i 6.");

		if (PI[id][p_zabrana_staff] > gettime())
		{
			new timeStr[20];
			GetRemainingTime(PI[id][p_zabrana_staff], timeStr);
			return ErrorMsg(playerid, "Taj igrac ima zabranu na staff poziciju jos {FF0000}%s.", timeStr);
		}
		
		// Formatiranje poruka za slanje igracu
		if (parametar == 0) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Oduzeta Vam je pozicija Game Admina | Head admin: %s.", ime_rp[playerid]), gHeadAdmin{id} = false; // za svaki slucaj

			ChatDisableForPlayer(id, CHAT_HELPER);
			ChatDisableForPlayer(id, CHAT_ADMIN);
			ChatDisableForPlayer(id, CHAT_REPORT);
			ChatDisableForPlayer(id, CHAT_QUESTION);
			ChatDisableForPlayer(id, CHAT_ADWARNING);
			ChatDisableForPlayer(id, CHAT_SMSADMIN);

			//if(strlen(PI[id][p_discord_id]) > 5) removePlayerDiscRole(PI[id][p_discord_id], "admin");

			SetPlayerHealth(id, duty_stats[id][0]);
			SetPlayerArmour(id, duty_stats[id][1]);
			Delete3DTextLabel(gStaffDutyLabel[id]);
			gStaffDutyLabel[id] = Text3D:INVALID_3DTEXT_ID;
			gStaffDuty{id} = false;
			dutyTimeTotal[id] += gettime() - dutyStartTime[id] - dutyAFKTime[id];
			UpdateDutyTime(id);

			PlayerTextDrawHide(id, PlayerTD[id][tdStaffDuty]);
			
			if (IsAdmin(id, 6))
			{
				if(!gOwner{id})
					SendClientMessageFToAll(ZUTA, "(( Head Admin %s vise nije na duznosti. ))", ime_rp[id]);
				else
					SendClientMessageFToAll(0xd30a0aFF, "(( Owner %s vise nije na duznosti. ))", ime_rp[id]);
			}

			else if (IsAdmin(id, 1))
				SendClientMessageFToAll(PLAVA, "(( Game Admin %s nije vise na duznosti. ))", ime_rp[id]);

			else if (IsHelper(id, 1))
				SendClientMessageFToAll(ZELENOZUTA, "(( Helper %s nije vise na duznosti. ))", ime_rp[id]);

			SetPlayerColor(id, PI[id][p_boja_imena]);
		}
		
		else if (parametar > PI[id][p_admin]) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Unapredjeni ste u Game Admin nivo %d | Head admin: %s.", parametar, ime_rp[playerid]);

			ChatEnableForPlayer(id, CHAT_HELPER);
			ChatEnableForPlayer(id, CHAT_ADMIN);
			ChatEnableForPlayer(id, CHAT_REPORT);
			ChatEnableForPlayer(id, CHAT_QUESTION);
			ChatEnableForPlayer(id, CHAT_ADWARNING);
			ChatEnableForPlayer(id, CHAT_SMSADMIN);
		}

		else if (parametar < PI[id][p_admin]) 
			SendClientMessageF(id, SVETLOPLAVA, "* Postavljeni ste za nivo %d Game Admina | Head admin: %s.", parametar, ime_rp[playerid]);
		
		// Postavljanje novog PIN-a ako je bio level 0
		if (PI[id][p_admin] == 0)
		{
			new pin = 10000+random(89999);
			
			// Update podataka u bazi
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "DELETE FROM staff WHERE pid = %d", PI[id][p_id]);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL); // za svaki slucaj
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "INSERT INTO staff (pid, pin) VALUES (%d, %d)", PI[id][p_id], pin);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL);
				
			// Slanje poruka igracu
			SendClientMessage(id, CRVENA, "VAZNO! Za ulazak u igru bice Vam potreban poseban kod. Bez tog koda necete biti u mogucnosti da se prijavite na svoj nalog.");
			SendClientMessageF(id, CRVENA, "Vas PIN kod je: {FFFFFF}%d. {FF0000}Ukoliko ga izgubite, nece biti moguce vratiti ga i necete moci da se prijavite.", pin);
		}
		
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] za nivo %d Game Admina.", ime_rp[id], id, parametar);

		//if(strlen(PI[id][p_discord_id]) > 5) setPlayerDiscRole(PI[id][p_discord_id], "admin");
		
		// Update podataka u bazi
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE staff SET admin = %d WHERE pid = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		// Upisivanje u log
		format(string_128, sizeof string_128, "ADMIN | Izvrsio: %s | Igrac: %s | Nivo: %d » %d", ime_obicno[playerid], ime_obicno[id], PI[id][p_admin], parametar);
		Log_Write(LOG_POZICIJE, string_128);
		
		// Postavljanje pozicije
		PI[id][p_admin] = parametar;
		FLAGS_SetupStaffFlags(id);
	}

	else if (strfind(params, "helper") != -1) // Postavi: helper
	{
		if (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_HELPER_VODJA)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
			
		if (sscanf(params, "s[7]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi helper [Ime ili ID igraca] [Helper nivo]");
			
			
		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 4) 
			return ErrorMsg(playerid, "Helper nivo mora biti izmedju 0 i 4.");

		if (PI[id][p_zabrana_staff] > gettime())
		{
			new timeStr[20];
			GetRemainingTime(PI[id][p_zabrana_staff], timeStr);
			return ErrorMsg(playerid, "Taj igrac ima zabranu na staff poziciju jos {FF0000}%s.", timeStr);
		}
			
		// Formatiranje poruka za slanje igracu
		if (parametar == 0) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Oduzeta Vam je pozicija Helpera | Head admin: %s.", ime_rp[playerid]);

			ChatDisableForPlayer(id, CHAT_HELPER);
			ChatDisableForPlayer(id, CHAT_QUESTION);

			//if(strlen(PI[id][p_discord_id]) > 5) removePlayerDiscRole(PI[id][p_discord_id], "helper");

			/*if (pDutyCooldown[playerid] > gettime())
			return ErrorMsg(playerid, "Duznost je nedavno ukljucena. Pokusaj ponovo za %s.", konvertuj_vreme(pDutyCooldown[playerid] - gettime()));*/

			// Vraca ga na listu trazenih ako je potrebno
			if (IsPlayerWanted(playerid) && !Iter_Contains(iWantedPlayers, playerid))
			{
				Iter_Add(iWantedPlayers, playerid);
			}

			SetPlayerHealth(playerid, 100);
			SetPlayerArmour(playerid, 0);
			Delete3DTextLabel(gStaffDutyLabel[playerid]);
			gStaffDutyLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
			gStaffDuty{playerid} = false;
			dutyTimeTotal[playerid] += gettime() - dutyStartTime[playerid] - dutyAFKTime[playerid];
			UpdateDutyTime(playerid);
		 
			SetPlayerColor(playerid, PI[playerid][p_boja_imena]);
			
			format(string_64, 64, "Izvrsio: %s | Status: 0", ime_obicno[playerid]);

			SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
		}

		else if (parametar > PI[id][p_helper]) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Unapredjeni ste u Helper nivo %d | Head admin: %s.", parametar, ime_rp[playerid]);

			ChatEnableForPlayer(id, CHAT_HELPER);
			ChatEnableForPlayer(id, CHAT_QUESTION);

			if (parametar == 4)
			{
			   ChatEnableForPlayer(id, CHAT_ADMIN); 
			}
		}

		else if (parametar < PI[id][p_helper]) 
			SendClientMessageF(id, SVETLOPLAVA, "* Postavljeni ste za nivo %d Helpera | Head admin: %s.", parametar, ime_rp[playerid]);

		
		//if(strlen(PI[id][p_discord_id]) > 5) setPlayerDiscRole(PI[id][p_discord_id], "helper");

		
		// Postavljanje novog PIN-a ako je bio level 0
		if (PI[id][p_helper] == 0)
		{
			new pin = 10000+random(89999);
			
			// Update podataka u bazi
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "DELETE FROM staff WHERE pid = %d", PI[id][p_id]);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL); // za svaki slucaj
			
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "INSERT INTO staff (pid, pin) VALUES (%d, %d)", PI[id][p_id], pin);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL);
				
			// Slanje poruka igracu
			SendClientMessage(id, CRVENA, "VAZNO! Za ulazak u igru bice Vam potreban poseban kod. Bez tog koda necete biti u mogucnosti da se prijavite na svoj nalog.");
			SendClientMessageF(id, CRVENA, "Vas PIN kod je: {FFFFFF}%d. {FF0000}Ukoliko ga izgubite, nece biti moguce vratiti ga i necete moci da se prijavite.", pin);
		}
		
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] za nivo %d Helpera.", ime_rp[id], id, parametar);
		
		// Update podataka u bazi
		if (parametar > 0)
		{
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE staff SET helper = %d WHERE pid = %d", parametar, PI[id][p_id]);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL);
		}
		
		// Upisivanje u log
		format(string_128, sizeof string_128, "HELPER | Izvrsio: %s | Igrac: %s | Nivo: %d » %d", ime_obicno[playerid], ime_obicno[id], PI[id][p_helper], parametar);
		Log_Write(LOG_POZICIJE, string_128);
		
		// Postavljanje pozicije
		PI[id][p_helper] = parametar;
		FLAGS_SetupStaffFlags(id);
	}

	else if (strfind(params, "vip") != -1) // Postavi: VIP
	{
		if (!IsAdmin(playerid, 6)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
			
		new duration, validUntil = gettime(), vipName[9];
		if (sscanf(params, "s[9]uii", str, id, parametar, duration)) 
			return Koristite(playerid, "postavi vip [Ime ili ID igraca] [VIP nivo, 0 za skidanje] [Trajanje (u danima, 0 za skidanje)]");
			
			
		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (IsPromoter(id, 1))
			return ErrorMsg(playerid, "Igrac ne moze biti promoter i VIP istovremeno.");

		if (parametar < 0 || parametar > 4) 
			return ErrorMsg(playerid, "VIP nivo mora biti izmedju 0 i 4.");

		if (duration < 0 || duration > 90)
			return ErrorMsg(playerid, "Trajanje VIP statusa mora biti izmedju 0 (skidanje) i 90 dana.");
			
		// Formatiranje poruka za slanje igracu
		VIP_GetPackageName(parametar, vipName, sizeof vipName);
		if (parametar == 0) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Oduzet Vam je VIP status | Head admin: %s.", ime_rp[playerid]);
			ChatDisableForPlayer(id, CHAT_PROMOVIP);

			duration = 0;
		}
		else
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Postavljen Vam je VIP paket %s u trajanju od %i dana | Head admin: %s", vipName, duration, ime_rp[playerid]);
			ChatEnableForPlayer(id, CHAT_PROMOVIP);
		}
		validUntil = gettime() + duration*86400;
		

		// Postavljanje pogodnosti
		/*if (parametar == 2)
		{
			PlayerMoneyAdd(id, 100000);
		}
		else if (parametar == 3)
		{
			PlayerMoneyAdd(id, 200000);
		}
		else if (parametar == 4)
		{
			PlayerMoneyAdd(id, 300000);
		}*/

		// Pasos za vreme trajanja VIP paketa
		if (parametar > 0)
		{
			new h,m,s;
			gettime(h, m, s);
			PI[id][p_pasos] = validUntil + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih X dana (isto koliko i VIP), pa jos do kraja sledeceg dana
		}


		// Health/armor na spawnu
		// VIP se uvek spawna sa 100hp
		if (IsVIP(id, 1))
			PI[id][p_spawn_health] = 100.0;

		// Armour na spawnu za VIP-a
		if (IsVIP(id, 4)) PI[id][p_spawn_armour] = 100.0;
		else if (IsVIP(id, 3)) PI[id][p_spawn_armour] = 70.0;
		else if (IsVIP(id, 2)) PI[id][p_spawn_armour] = 35.0;
		else if (parametar == 0) PI[id][p_spawn_armour] = 0.0;

		// Formatiranje unosa za update podataka u bazi
		new spawn[63];
		format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f|%d|%d|%.1f|%.1f", PI[id][p_spawn_x], PI[id][p_spawn_y], PI[id][p_spawn_z], PI[id][p_spawn_a], PI[id][p_spawn_ent], PI[id][p_spawn_vw], PI[id][p_spawn_health], PI[id][p_spawn_armour]);


		// Slanje poruke igracu
		format(string_128, sizeof string_128, "* Postavili ste %s[ID: %d] VIP paket %s u trajanju od %i dana.", ime_rp[id], id, vipName, duration);
		SendClientMessage(playerid, SVETLOPLAVA, string_128);
		
		// Update podataka u bazi
		new sQuery[285];
		mysql_format(SQL,sQuery, sizeof sQuery, "UPDATE igraci SET vip_level = %i, vip_istice = %i, vip_refill = 0, vip_replenish = 0, novac = %i, pasos = FROM_UNIXTIME(%i), spawn = '%s' WHERE id = %i", parametar, validUntil, PI[id][p_novac], PI[id][p_pasos], spawn, PI[id][p_id]);
		mysql_tquery(SQL, sQuery);

		// Upisivanje u log
		format(string_128, sizeof string_128, "VIP | Izvrsio: %s | Igrac: %s | Nivo: %d » %d | %i dana", ime_obicno[playerid], ime_obicno[id], PI[id][p_vip_level], parametar, duration);
		Log_Write(LOG_POZICIJE, string_128);
		
		// Postavljanje pozicije
		PI[id][p_vip_level] = parametar;
		PI[id][p_vip_istice] = validUntil;
		PI[id][p_vip_refill] = 0;
		PI[id][p_vip_replenish] = 0;
		UpdatePlayerBubble(id);
		FLAGS_SetupVIPFlags(id);
	}

	else if (strfind(params, "promoter") != -1) // Postavi: promoter
	{
		if (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_PROMO_VODJA)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
			
		if (sscanf(params, "s[9]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi promoter [Ime ili ID igraca] [Promoter nivo]");
			
			
		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 3) 
			return ErrorMsg(playerid, "Promoter nivo mora biti izmedju 0 i 3.");

		if (IsHelper(id, 1))
			return ErrorMsg(playerid, "Igrac koga zelite da postavite za promotera ne sme biti admin ili helper.");
			
		// Formatiranje poruka za slanje igracu
		if (parametar == 0) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Oduzeta Vam je pozicija Promotera | Head admin: %s.", ime_rp[playerid]);
			ChatDisableForPlayer(id, CHAT_PROMOVIP);
		}
		
		else if (parametar > PI[id][p_promoter]) 
		{
			SendClientMessageF(id, SVETLOPLAVA, "* Unapredjeni ste u Promoter nivo %d | Head admin: %s.", parametar, ime_rp[playerid]);
			ChatEnableForPlayer(id, CHAT_PROMOVIP);
		}
		
		else if (parametar < PI[id][p_promoter]) 
			SendClientMessageF(id, SVETLOPLAVA, "* Postavljeni ste za nivo %d Promotera | Head admin: %s.", parametar, ime_rp[playerid]);
		


		if (PI[id][p_promoter] == 0 || parametar == 0) 
		{
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "DELETE FROM staff WHERE pid = %d", PI[id][p_id]);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL);
		}

		
		// Slanje poruke igracu
		format(string_128, sizeof string_128, "* Postavili ste %s[ID: %d] za nivo %d Promotera.", ime_rp[id], id, parametar);
		SendClientMessage(playerid, SVETLOPLAVA, string_128);
		
		// Update podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "DELETE FROM staff WHERE pid = %d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL); // za svaki slucaj
		if (parametar > 0)
		{
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "INSERT INTO staff (pid, promoter) VALUES (%d, %d)", PI[id][p_id], parametar);
			mysql_tquery(SQL, mysql_upit);
		}

		// Upisivanje u log
		format(string_128, sizeof string_128, "PROMOTER | Izvrsio: %s | Igrac: %s | Nivo: %d » %d", ime_obicno[playerid], ime_obicno[id], PI[id][p_promoter], parametar);
		Log_Write(LOG_POZICIJE, string_128);
		
		// Postavljanje pozicije
		PI[id][p_promoter] = parametar;
		UpdatePlayerBubble(id);
		FLAGS_SetupPromoterFlags(id);
	}

	else if (strfind(params, "lider") != -1) // Postavi: lider
	{
		if (!IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
			
		if (sscanf(params, "s[12]uk<ftag>", str, id, parametar))
			return Koristite(playerid, "postavi lider [Ime ili ID igraca] [ID ili naziv fakcije]");
			
		// Validacija inputa
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
			
		if (GetPlayerFactionID(id) != -1)
			return ErrorMsg(playerid, "Igrac mora najpre da napusti organizaciju u kojoj se nalazi.");
			
		if (parametar < 0 || parametar >= MAX_FACTIONS) 
			return ErrorMsg(playerid, "Nevazeci unos!");

		if (PI[id][p_org_rank] == RANK_LEADER)
			return ErrorMsg(playerid, "Igrac je vec lider neke organizacije!");

		if (PI[id][p_zabrana_lider] > gettime())
		{
			new timeStr[20];
			GetRemainingTime(PI[id][p_zabrana_lider], timeStr);
			return ErrorMsg(playerid, "Taj igrac ima zabranu na lidera jos {FF0000}%s.", timeStr);
		}
		 
		//new bool:alreadyMember = true;   
		if (PI[id][p_org_id] != parametar) // Nije clan organizacije gde mu je postavljen lider, proveriti da li ima mesta
		{
			//alreadyMember = false;

			if (FACTIONS[parametar][f_clanovi] >= FACTIONS[parametar][f_max_clanova])
				return ErrorMsg(playerid, "Svi slotovi su popunjeni.");
		}
		
		
		// Postavljanje u F_LEADERS kako bi promene odmah bile vidljive u /lideri
		if (!strcmp(F_LEADERS[parametar][0], "Niko")) 
			strmid(F_LEADERS[parametar][0], ime_obicno[id], 0, strlen(ime_obicno[id]), MAX_PLAYER_NAME);
			
		else if (!strcmp(F_LEADERS[parametar][1], "Niko"))
			strmid(F_LEADERS[parametar][1], ime_obicno[id], 0, strlen(ime_obicno[id]), MAX_PLAYER_NAME);
			
		else return ErrorMsg(playerid, "Oba lider slota su zauzeta.");
		
		
		// Postavljanje igracevih varijabli
		PI[id][p_org_id]   = parametar;
		PI[id][p_org_rank] = RANK_LEADER;
		PI[id][p_skin]     = -1;
		f_ts_initial[playerid] = gettime();
		SetPlayerSkin(id, GetPlayerCorrectSkin(id));
		SetSpawnInfo(id, 0, GetPlayerCorrectSkin(id), PI[id][p_spawn_x], PI[id][p_spawn_y], PI[id][p_spawn_z], PI[id][p_spawn_a], 0, 0, 0, 0, 0, 0);

		ChatEnableForPlayer(id, CHAT_FACTION);
		ChatEnableForPlayer(id, CHAT_LEADER);
		if (IsACop(id)) ChatEnableForPlayer(id, CHAT_DEPARTMENT);
			
		// Slanje poruke igracu
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Head admin {FFFFFF}%s {FF6347}Vas je postavio za lidera %s {FF6347}%s.", ime_rp[playerid], faction_name(FACTIONS[parametar][f_vrsta], FNAME_GENITIV), FACTIONS[parametar][f_naziv]);

		/*if(strlen(PI[id][p_discord_id]) > 5) 
		{
			if(parametar == 0) { setPlayerDiscRole(PI[id][p_discord_id], "lspd"); }
			else if(parametar == 1) { setPlayerDiscRole(PI[id][p_discord_id], "lcn");}
			else if(parametar == 2) { setPlayerDiscRole(PI[id][p_discord_id], "sb");}
			else if(parametar == 3) { setPlayerDiscRole(PI[id][p_discord_id], "gsf");}
			
			setPlayerDiscRole(PI[id][p_discord_id], "lider");
		}*/
		
		// Slanje poruke adminu
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] za lidera %s {FFFFFF}%s.", ime_rp[id], id, faction_name(parametar, FNAME_GENITIV), FACTIONS[parametar][f_naziv]);
		Faction_UpdateEntranceLabel(parametar);
		// Update igraca u bazi
		new sQuery[128];
		mysql_format(SQL,sQuery, sizeof sQuery, "UPDATE igraci SET org_id = %d, org_rank = %d, skin = -1 WHERE id = %d", parametar, PI[id][p_org_rank], PI[id][p_id] );
		mysql_tquery(SQL, sQuery);
		
		// Update/Insert u tablicu za clanove
		new sQuery_2[256];
		mysql_format(SQL, sQuery_2, sizeof sQuery_2, "INSERT INTO factions_members ( faction_id, player_id, lider ) VALUES ( %d, %d, 1 )", parametar, PI[id][p_id]);
		mysql_tquery(SQL, sQuery_2);
		
		// Upisivanje u log
		new sLog[128];
		format(sLog, sizeof sLog, "LIDER | Izvrsio: %s | Igrac: %s | ID: %d (%s)", ime_obicno[playerid], ime_obicno[id], parametar, FACTIONS[parametar][f_naziv]);
		Log_Write(LOG_POSTAVLJANJE, sLog);
	}

	else if (strfind(params, "novac") != -1) // Postavi: novac
	{
		if (!IsAdmin(playerid, 6)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[6]ui", str, id, parametar))
			return ErrorMsg(playerid, "Nevazeci unos!");

		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 99999999) 
			return ErrorMsg(playerid, "Nevazeci iznos!");

		PlayerMoneySet(id, parametar);
		
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Head admin {FFFFFF}%s {FF6347}Vam je postavio iznos novca na {FFFFFF}$%d.", ime_rp[playerid], parametar);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] iznos novca na $%d.", ime_rp[id], id, parametar);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "NOVAC | Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "token") != -1) // Postavi: token
	{
		if (!IsHeadAdmin(playerid)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[6]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi token [Ime ili ID igraca] [Novi iznos tokena]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
		if (parametar < 0 || parametar > 99999999) 
			return ErrorMsg(playerid, "Nevazeci iznos!");

		PI[id][p_token] = parametar;
		
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Head admin {FFFFFF}%s {FF6347}Vam je postavio Tokene na {FFFFFF}%d.", ime_rp[playerid], parametar);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] Tokene na %d.", ime_rp[id], id, parametar);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET gold = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "TOKEN | Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "virtual") != -1 || strfind(params, "vw") != -1) // Postavi: virtual
	{
		if (!IsHelper(playerid, 2)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		if (sscanf(params, "s[8]ui", str, id, parametar))
			return Koristite(playerid, "postavi virtual [Ime ili ID igraca] [virtual world (0 - 2 147 483 647)]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		if (parametar < 0 || parametar > 2147483647) 
			return ErrorMsg(playerid, "Virtual world moze biti najmanje 0, a najvise 2.147.483.647.");
		
		if (GetPlayerVehicleID(playerid) != 0) SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), parametar);
		SetPlayerVirtualWorld(id, parametar);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] virtual world na %d.", ime_rp[id], id, parametar);
	}

	else if (strfind(params, "enterijer") != -1 || strfind(params, "ent") != -1 || strfind(params, "interijer") != -1 || strfind(params, "int") != -1) // Postavi: enterijer
	{
		if (!IsHelper(playerid, 1)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		if (sscanf(params, "s[10]ui", str, id, parametar))
			return Koristite(playerid, "postavi enterijer [Ime ili ID igraca] [enterijer (0-35)]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		if (parametar < 0 || parametar > 35) 
			return ErrorMsg(playerid, "Enterijer moze biti najmanje 0, a najvise 35.");
		
		if (GetPlayerVehicleID(playerid) != 0) LinkVehicleToInterior(GetPlayerVehicleID(playerid), parametar);
		SetPlayerInterior(id, parametar);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] enterijer na %d.", ime_rp[id], id, parametar);
	}

	else if (strfind(params, "skin") != -1) // Postavi: skin
	{
		if (!IsAdmin(playerid, 4)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		if (sscanf(params, "s[5]ui", str, id, parametar))
			return Koristite(playerid, "postavi skin [Ime ili ID igraca] [skin ID (-1 - 311)]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < -1 || parametar > 311) 
			return ErrorMsg(playerid, "Skin ID moze biti najmanje -1, a najvise 311.");
		
		PI[id][p_skin] = parametar;
		SetPlayerSkin(id, GetPlayerCorrectSkin(id));
		SetSpawnInfo(id, 0, GetPlayerCorrectSkin(id), PI[id][p_spawn_x], PI[id][p_spawn_y], PI[id][p_spawn_z], PI[id][p_spawn_a], 0, 0, 0, 0, 0, 0);

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je skin id %d od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] skin id na %d.", ime_rp[id], id, parametar);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET skin = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "SKIN | Izvrsio: %s | Igrac: %s | ID: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "dj") != -1) // Postavi: DJ
	{
		if (!IsAdmin(playerid, 5))
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		if (sscanf(params, "s[5]ui", str, id, parametar))
			return Koristite(playerid, "postavi dj [Ime ili ID igraca] [DJ status (0/1)]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0 && parametar != 1) 
			return ErrorMsg(playerid, "DJ status moze biti samo 0 ili 1.");
		
		PI[id][p_dj] = parametar;

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je DJ status %i od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %i] DJ status na %i.", ime_rp[id], id, parametar);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dj = %i WHERE id = %i", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "DJ | Izvrsio: %s | Igrac: %s | Status: %i", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}
	
	else if (strfind(params, "stil borbe") != -1) // Postavi: stil borbe
	{
		if (!IsAdmin(playerid, 3)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		new stil2[15], str222[5];
		if (sscanf(params, "s[5]s[6]ui", str222, str, id, parametar))
		{
			Koristite(playerid, "postavi stil borbe [Ime ili ID igraca] [ID stila]");
			SendClientMessage(playerid, GRAD2, "Dostupni stilovi - 1: Normalni | 2: Boxing | 3: Kung Fu | 4: KneeHead | 5 - Grab 'n' Kick | 6 - Elbow");
			return 1;
		}

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar == 1)      stil2 = "Normalni",        SetPlayerFightingStyle(id, FIGHT_STYLE_NORMAL);
		else if (parametar == 2) stil2 = "Box",             SetPlayerFightingStyle(id, FIGHT_STYLE_BOXING);
		else if (parametar == 3) stil2 = "Kung Fu",         SetPlayerFightingStyle(id, FIGHT_STYLE_KUNGFU);
		else if (parametar == 4) stil2 = "KneeHead",        SetPlayerFightingStyle(id, FIGHT_STYLE_KNEEHEAD);
		else if (parametar == 5) stil2 = "Grab 'n' Kick",   SetPlayerFightingStyle(id, FIGHT_STYLE_GRABKICK);
		else if (parametar == 6) stil2 = "Elbow",           SetPlayerFightingStyle(id, FIGHT_STYLE_ELBOW);
		else return ErrorMsg(playerid, "Nevazeci ID stila!");
		
		PI[id][p_stil_borbe] = GetPlayerFightingStyle(id);
		
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je stil borbe %s od Game Admina %s.", stil2, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste stil borbe %s igracu %s[ID: %d].", stil2, ime_rp[id], id);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET stil_borbe = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "STIL BORBE | Izvrsio: %s | Igrac: %s | Stil: %s", ime_obicno[playerid], ime_obicno[id], stil2);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "vozacka") != -1) // Postavi: vozacka dozvola
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[8]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi vozacka [Ime ili ID igraca] [0/1]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0 && parametar != 1) 
			return ErrorMsg(playerid, "Parametar moze biti samo 0 (oduzimanje) ili 1 (postavljanje).");

		
		if (parametar == 0)
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je {FFFFFF}oduzeo {FF6347}vozacku dozvolu.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste vozacku dozvolu %s[ID: %d].", ime_rp[id], id);
		}
		else
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je dao vozacku dozvolu.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] vozacku dozvolu.", ime_rp[id], id);
		}

		if (parametar == 0) parametar = -1; // oduzeta dozvola je zapravo -1, a ne 0
		PI[id][p_dozvola_voznja] = parametar;

		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_voznja = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);

		mysql_format(SQL,string_128, sizeof string_128, "VOZACKA DOZVOLA | Izvrsio: %s | Igrac: %s | %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "oruzje") != -1) // Postavi: dozvola za oruzje
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[7]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi oruzje [Ime ili ID igraca] [0/1]");

		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0 && parametar != 1) 
			return ErrorMsg(playerid, "Parametar moze biti samo 0 (oduzimanje) ili 1 (postavljanje).");

		if (parametar == 0)
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je {FFFFFF}oduzeo {FF6347}dozvolu za oruzje.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste dozvolu za oruzje %s[ID: %d].", ime_rp[id], id);
		}
		else
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je dao dozvolu za oruzje.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] dozvolu za oruzje.", ime_rp[id], id);
		}

		if (parametar == 0)
			parametar = -1; // oduzeta dozvola je zapravo -1, a ne 0
		PI[id][p_dozvola_oruzje] = parametar;

		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_oruzje = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);

		mysql_format(SQL,string_128, sizeof string_128, "ORUZJE DOZVOLA | Izvrsio: %s | Igrac: %s | %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "letenje") != -1) // Postavi: dozvola za letenje
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[9]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi letenje [Ime ili ID igraca] [0/1]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0 && parametar != 1) 
			return ErrorMsg(playerid, "Parametar moze biti samo 0 (oduzimanje) ili 1 (postavljanje).");

		
		if (parametar == 0)
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je {FFFFFF}oduzeo {FF6347}dozvolu za letenje.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste dozvolu za letenje %s[ID: %d].", ime_rp[id], id);
		}
		else
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je dao dozvolu za letenje.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] dozvolu za letenje.", ime_rp[id], id);
		}

		if (parametar == 0) parametar = -1; // oduzeta dozvola je zapravo -1, a ne 0
		PI[id][p_dozvola_letenje] = parametar;

		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_letenje = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);

		mysql_format(SQL,string_128, sizeof string_128, "LETENJE DOZVOLA | Izvrsio: %s | Igrac: %s | %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "plovidba") != -1) // Postavi: dozvola za plovidbu
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[9]ui", str, id, parametar)) 
			return Koristite(playerid, "postavi plovidba [Ime ili ID igraca] [0/1]");
		
		// Validacija inputa:
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0 && parametar != 1) 
			return ErrorMsg(playerid, "Parametar moze biti samo 0 (oduzimanje) ili 1 (postavljanje).");

		
		if (parametar == 0)
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je {FFFFFF}oduzeo {FF6347}dozvolu za plovidbu.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste dozvolu za plovidbu %s[ID: %d].", ime_rp[id], id);
		}
		else
		{
			SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} %s Vam je dao dozvolu za plovidbu.", ime_rp[playerid]);
			SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s[ID: %d] dozvolu za plovidbu.", ime_rp[id], id);
		}

		if (parametar == 0) parametar = -1; // oduzeta dozvola je zapravo -1, a ne 0
		PI[id][p_dozvola_plovidba] = parametar;

		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_plovidba = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);

		mysql_format(SQL,string_128, sizeof string_128, "PLOVIDBA DOZVOLA | Izvrsio: %s | Igrac: %s | %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "nivo") != -1) // Postavi: nivo
	{
		if (!IsAdmin(playerid, 6)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[5]ui", str, id, parametar))
			return Koristite(playerid, "postavi nivo [Ime ili ID igraca] [Nivo]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 1 || parametar > 49)
			return ErrorMsg(playerid, "Nivo mora biti izmedju 1 i 49.");

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je nivo %d od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste nivo %d igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		PI[id][p_nivo] = parametar;
		SetPlayerScore(id, parametar);
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET nivo = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		mysql_format(SQL,string_128, sizeof string_128, "NIVO | Izvrsio: %s | Igrac: %s | Nivo: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "banka") != -1) // Postavi: banka
	{
		if (!IsHeadAdmin(playerid)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[6]ui", str, id, parametar))
			return Koristite(playerid, "postavi banka [Ime ili ID igraca] [Kolicina novca]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je iznos bankovnog racna na $%d od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste iznos bankovnog racuna na $%d igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		PI[id][p_banka] = parametar;
		BankMoneySet(id, parametar);

		new query[60];
		mysql_format(SQL,query, sizeof query, "UPDATE igraci SET banka = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, query);
		
		mysql_format(SQL,string_128, sizeof string_128, "BANKA | Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "iskustvo") != -1) // Postavi: iskustvo
	{
		if (!IsAdmin(playerid, 6)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		if (sscanf(params, "s[9]ui", str, id, parametar))
			return Koristite(playerid, "postavi iskustvo [Ime ili ID igraca] [Poeni iskustva]");
		
		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljeno Vam je %d poena iskustva od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %d poena iskustva igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		PI[id][p_iskustvo] = parametar;
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET iskustvo = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		mysql_format(SQL,string_128, sizeof string_128, "ISKUSTVO | Izvrsio: %s | Igrac: %s | Poeni: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	/*else if (strfind(params, "vreme igre") != -1) // Postavi: vreme igre
	{
		if (!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		strdel(params, 0, strlen("vreme igre ")); // obavezno mora ovaj razmak u stringu
		if (sscanf(params, "ui", id, parametar)) return Koristite(playerid, "postavi vreme igre [Ime ili ID igraca] [Vreme igre u sekundama]");
		if (!IsPlayerConnected(id)) return ErrorMsg(playerid, GRESKA_OFFLINE);
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljeno Vam je %d sekundi igre od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %d sekundi igre igracu %s[ID: %d].", parametar, ime_rp[id], id);
		PI[id][p_provedeno_vreme] = parametar;
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET provedeno_vreme = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		format(string_128, sizeof string_128, "VREME IGRE | Izvrsio: %s | Igrac: %s | Vreme: $%d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}*/

	else if (strfind(params, "starost") != -1) // Postavi: starost
	{
		if (!IsAdmin(playerid, 4)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[9]ui", str, id, parametar))
			return Koristite(playerid, "postavi starost [Ime ili ID igraca] [Godine]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);
		
		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljeno Vam je %d godina od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %d godina igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		PI[id][p_starost] = parametar;
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET starost = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		mysql_format(SQL,string_128, sizeof string_128, "GODINE | Izvrsio: %s | Igrac: %s | Godine: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "opomene") != -1) // Postavi: opomene
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[8]ui", str, id, parametar))
			return Koristite(playerid, "postavi opomene [Ime ili ID igraca] [Broj opomena]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 5)
			return ErrorMsg(playerid, "Broj opomena mora biti izmedju 0 i 5.");

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljeno Vam je %d opomena od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %d opomena igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		PI[id][p_opomene] = parametar;
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET opomene = %d WHERE id = %d", parametar, PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		mysql_format(SQL,string_128, sizeof string_128, "OPOMENE | Izvrsio: %s | Igrac: %s | Opomene: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "wl") != -1 || strfind(params, "wanted") != -1 || strfind(params, "wanted level") != -1) // Postavi: wanted level
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (strfind(params, "wanted level") != -1)
		{
			new str2[6];
			if (sscanf(params, "s[7]s[6]ui", str, str2, id, parametar))
				return Koristite(playerid, "postavi wanted level [Ime ili ID igraca] [Wanted level (0-255)]");
		}
		else
		{
			if (sscanf(params, "s[7]ui", str, id, parametar))
				return Koristite(playerid, "postavi wanted [Ime ili ID igraca] [Wanted level (0-255)]");
		}

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar < 0 || parametar > 255)
			return ErrorMsg(playerid, "Wanted level mora biti izmedju 0 i 255.");

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Postavljen Vam je Wanted Level %d od Game Admina %s.", parametar, ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste Wanted Level %d igracu %s[ID: %d].", parametar, ime_rp[id], id);
		
		
		if (parametar == 0)
		{
			ClearPlayerRecord(id, true);
		}
		else
		{
			PI[id][p_wanted_level] = parametar;
			mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET wanted_level = %d WHERE id = %d", parametar, PI[id][p_id]);
			mysql_tquery(SQL, mysql_upit);

			// Dodavanje u iterator
			if (!Iter_Contains(iWantedPlayers, id))
			{
				Iter_Add(iWantedPlayers, id);
			}
		}
		
		
		format(string_128, sizeof string_128, "WANTED LEVEL | Izvrsio: %s | Igrac: %s | WL: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else if (strfind(params, "orgkazna") != -1 || strfind(params, "kazna") != -1) // Postavi: orgkazna
	{
		if (!IsAdmin(playerid, 5)) 
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

		if (sscanf(params, "s[9]ui", str, id, parametar))
			return Koristite(playerid, "postavi orgkazna [Ime ili ID igraca] [0]");

		if (!IsPlayerConnected(id)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (parametar != 0)
			return ErrorMsg(playerid, "Parametar moze biti samo 0 (brisanje kazne).");

		SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Izbrisana Vam je kazna za ulazak u organizaciju od Game Admina %s.", ime_rp[playerid]);
		SendClientMessageF(playerid, SVETLOPLAVA, "* Izbrisali ste kaznu za ulazak u organizaciju igracu %s[ID: %d].", ime_rp[id], id);
		
		PI[id][p_org_kazna] = 0;
		
		mysql_format(SQL,mysql_upit, sizeof mysql_upit, "UPDATE igraci SET org_kazna=FROM_UNIXTIME(0) WHERE id=%d", PI[id][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		format(string_128, sizeof string_128, "ORG KAZNA | Izvrsio: %s | Igrac: %s | Parametar: %d", ime_obicno[playerid], ime_obicno[id], parametar);
		Log_Write(LOG_POSTAVLJANJE, string_128);
	}

	else
	{
		Koristite(playerid, "postavi [Sta postavljate] [Ime ili ID igraca] [Parametar]");
		if (IsHelper(playerid, 1))  SendClientMessage(playerid, GRAD2, "Moguce postaviti: [virtual] [enterijer]");
		if (IsAdmin(playerid, 3))   SendClientMessage(playerid, GRAD2, "Moguce postaviti: [stil borbe] [skin] [starost]");
		if (IsAdmin(playerid, 5))   SendClientMessage(playerid, GRAD2, "Moguce postaviti: [dozvole: vozacka/oruzje/letenje/plovidba] [lider] [wanted]");
		if (IsAdmin(playerid, 5))   SendClientMessage(playerid, GRAD2, "Moguce postaviti: [opomene] [orgkazna] [dj]");
		if (IsAdmin(playerid, 6))   SendClientMessage(playerid, GRAD2, "Moguce postaviti: [admin] [helper] [promoter] [vip]");
		if (gHeadAdmin{playerid})       SendClientMessage(playerid, GRAD2, "Moguce postaviti: [novac] [banka] [token] [nivo] [iskustvo]");

		return 1;
	}

	return 1;
}

SetPlayerBabo(playerid, var)
{
	if(var == 1)
		gOwner{playerid} = true;
	else
		gOwner{playerid} = false;
}

flags:setowner(FLAG_ADMIN_6)
CMD:setowner(playerid, const params[])
{
	new
		imeigraca
	;

	if(!sscanf(params, "d", imeigraca))
	{
		gOwner{imeigraca} = true;
		InfoMsg(playerid, "Uspjesno si postavio Ownera igracu %s", ime_rp[imeigraca]);

		new sQuery2[64];
		mysql_format(SQL,sQuery2, sizeof sQuery2, "UPDATE igraci SET babo = %d WHERE id = %d", 1, PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery2);
	}

	return 1;
}

flags:removeowner(FLAG_ADMIN_6)
CMD:removeowner(playerid, const params[])
{
	new
		imeigraca
	;

	if(!sscanf(params, "d", imeigraca))
	{
		gOwner{imeigraca} = false;
		InfoMsg(playerid, "Uspjesno si skinuo Ownera igracu %s", ime_rp[imeigraca]);

		new sQuery2[64];
		mysql_format(SQL,sQuery2, sizeof sQuery2, "UPDATE igraci SET babo = %d WHERE id = %d", 0, PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery2);

		SetPVarInt(imeigraca, "pKilledByAdmin", 1);
		SetPlayerHealth(imeigraca, 0.0);
	}

	return 1;
}

CMD:h(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "h [Tekst]");

	if (!IsChatEnabled(playerid, CHAT_HELPER))
		return ErrorMsg(playerid, "Iskljucili ste /h kanal. Koristite /chat da ga ponovo ukljucite.");
		
	new title[40];

	if (IsAdmin(playerid, 6)) 
	{
		if(gOwner{playerid})
			format(title, sizeof title, "Owner %s[%i]", ime_rp[playerid], playerid);
		else
			format(title, sizeof title, "Head admin %s[%i]", ime_rp[playerid], playerid);
	}
	else if (IsAdmin(playerid, 1)) 
	{
		format(title, sizeof title, "A%i | %s[%i]", PI[playerid][p_admin], ime_rp[playerid], playerid);
	}
	else if (IsHelper(playerid, 1)) 
	{
		format(title, sizeof title, "H%i | %s[%i]", PI[playerid][p_helper], ime_rp[playerid], playerid);
	}
	
	if (PlayerFlagGet(playerid, FLAG_PROMO_VODJA)) 
	{
		format(title, sizeof title, "Vodja promotera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
	{
		format(title, sizeof title, "Vodja lidera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_HELPER_VODJA)) 
	{
		format(title, sizeof title, "Vodja helpera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_ADMIN_VODJA)) 
	{
		format(title, sizeof title, "Vodja admina %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_MAPER)) 
	{
		format(title, sizeof title, "Maper %s[%i]", ime_rp[playerid], playerid);
	}
	
	
	// Slanje poruke
	foreach(new i : Player)
	{
		if ((IsHelper(i, 1) || PlayerFlagGet(i, FLAG_MAPER)) && IsChatEnabled(i, CHAT_HELPER))
		{
			if (i == playerid)
			{
				SendClientMessageF(i, ZELENOZUTA, "%s: {F3F3F3}%s", title, params);
			}
			else
			{
				SendClientMessageF(i, ZELENOZUTA, "%s: {FFFFFF}%s", title, params);
			}
		}
	}
	
	new sLog[144];
	format(sLog, sizeof sLog, "%s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_CHAT_HELPER, sLog);
	return 1;
}

CMD:a(playerid, const params[])
{
	if (isnull(params)) 
		return Koristite(playerid, "a [Tekst]");

	if (!IsChatEnabled(playerid, CHAT_ADMIN))
		return ErrorMsg(playerid, "Iskljucili ste /a kanal. Koristite /chat da ga ponovo ukljucite.");
		
	new title[40];

	if(gOwner{playerid})
	{
		format(title, sizeof title, "Owner %s", ime_rp[playerid]);
	}
	else if (IsAdmin(playerid, 6) && !gOwner{playerid})
	{
		format(title, sizeof title, "Head admin %s", ime_rp[playerid]);
	}
	else if (IsAdmin(playerid, 1) && !gOwner{playerid})
	{
		format(title, sizeof title, "A%i | %s[%i]", PI[playerid][p_admin], ime_rp[playerid], playerid);
	}
	
	if (PlayerFlagGet(playerid, FLAG_PROMO_VODJA)) 
	{
		format(title, sizeof title, "Vodja promotera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
	{
		format(title, sizeof title, "Vodja lidera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_HELPER_VODJA)) 
	{
		format(title, sizeof title, "Vodja helpera %s[%i]", ime_rp[playerid], playerid);
	}
	else if (PlayerFlagGet(playerid, FLAG_ADMIN_VODJA)) 
	{
		format(title, sizeof title, "Vodja admina %s[%i]", ime_rp[playerid], playerid);
	}
	
	
	// Slanje poruke
	foreach(new i : Player)
	{
		if (IsAdmin(i, 1) && IsChatEnabled(i, CHAT_ADMIN)) 
		{
			if (i == playerid)
			{
				SendClientMessageF(i, SVETLOPLAVA, "%s: {B4B5B7}%s", title, params);
			}
			else
			{
				SendClientMessageF(i, SVETLOPLAVA, "%s: {FFFFFF}%s", title, params);
			}
		}
	}
	
	new sLog[144];
	format(sLog, sizeof sLog, "%s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_CHAT_ADMIN, sLog);
	return 1;
}

CMD:ha(playerid, const params[])
{
	if (isnull(params)) 
		return Koristite(playerid, "ha [Tekst]");
	
	foreach(new i : Player)
	{
		if (IsAdmin(i, 6)) 
		{
			if (i == playerid)
			{
				SendClientMessageF(i, (gOwner{playerid}) ? 0xd30a0aFF : ZUTA, "%s %s[%i]: {B4B5B7}%s", (gOwner{playerid}) ? "Owner" : "Head Admin", ime_rp[playerid], playerid, params);
			}
			else
			{
				SendClientMessageF(i, (gOwner{playerid}) ? 0xd30a0aFF : ZUTA, "%s %s[%i]: {FFFFFF}%s", (gOwner{playerid}) ? "Owner" : "Head Admin", ime_rp[playerid], playerid, params);
			}
		}
	}
	
	new sLog[144];
	format(sLog, sizeof sLog, "%s: %s", ime_obicno[playerid], params);
	Log_Write(LOG_CHAT_HEAD, sLog);
	return 1;
}

CMD:veh(playerid, params[]) 
{
	new 
		veh_id, boja, 
		modelid = -1
	;
	if (sscanf(params, "k<vehiclemodel>I(-1)", modelid, boja)) 
		return Koristite(playerid, "veh [Naziv ili ID modela (400-611)] [ID boje (opciono)]");
	
	if (modelid == -1 || modelid == 537 || modelid == 538) 
		return ErrorMsg(playerid, "Nevazeci model vozila.");

	if (pCreatedVeh[playerid] != INVALID_VEHICLE_ID)
	{
		if (IsValidDynamic3DTextLabel(pStaffVehicleLabel[playerid]))
			DestroyDynamic3DTextLabel(pStaffVehicleLabel[playerid]);

		pStaffVehicleLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
		DestroyVehicle(pCreatedVeh[playerid]);
		SendClientMessage(playerid, BELA, "* Prethodno kreirano vozilo je automatski unisteno.");
	}
		
	// Glavna funkcija komande
	GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	GetPlayerFacingAngle(playerid, pozicija[playerid][3]);
	veh_id = CreateVehicle(modelid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], pozicija[playerid][3], boja, boja, 1000, true);
	SetVehicleVirtualWorld(veh_id, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(veh_id, GetPlayerInterior(playerid));
	SetVehicleParamsEx(veh_id, 1, 1, 0, 0, 0, 0, 0);
	PutPlayerInVehicle_H(playerid, veh_id, 0);

	pCreatedVeh[playerid] = veh_id;

	if (IsAdmin(playerid, 6))
	{
	    pStaffVehicleLabel[playerid] = CreateDynamic3DTextLabel("[ HEAD VOZILO ]", ZUTA, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh_id, 1, -1, -1);
	}
	else if (IsAdmin(playerid, 1) && !IsAdmin(playerid, 6))
	{
	    pStaffVehicleLabel[playerid] = CreateDynamic3DTextLabel("[ ADMIN VOZILO ]", 0x33CCFFAA, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh_id, 1, -1, -1);
	}
	else if (IsHelper(playerid, 1))
	{
	    pStaffVehicleLabel[playerid] = CreateDynamic3DTextLabel("[ HELPER VOZILO ]", 0x00FF00AA, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh_id, 1, -1, -1);
	}
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, ZELENA, "* Vozilo stvoreno | Model: %s (%d) | ID: %d", imena_vozila[modelid - 400], modelid, veh_id);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /veh | Izvrsio: %s | Model: %s (%d) | ID: %d", ime_obicno[playerid], imena_vozila[modelid - 400], modelid, veh_id);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:dveh(playerid, const params[])
{
	if (pCreatedVeh[playerid] == INVALID_VEHICLE_ID)
		return ErrorMsg(playerid, "Nemate kreirano vozilo.");

	SendClientMessageF(playerid, BELA, "* Prethodno kreirano vozilo (%s) je automatski unisteno.", imena_vozila[GetVehicleModel(pCreatedVeh[playerid]) - 400]);
	DestroyVehicle(pCreatedVeh[playerid]);
	pCreatedVeh[playerid] = INVALID_VEHICLE_ID;

	if (IsValidDynamic3DTextLabel(pStaffVehicleLabel[playerid]))
		DestroyDynamic3DTextLabel(pStaffVehicleLabel[playerid]);

	pStaffVehicleLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
	return 1;
}

CMD:unisti(playerid, const params[]) 
{
	new veh_id;
	if (sscanf(params, "i", veh_id)) 
		return Koristite(playerid, "unisti [ID vozila - ako ste blizu koristite /dl] (oprezno! ovo unistava vozilo do sledeceg restarta!)");

	if (veh_id < 0 || veh_id > MAX_VEHICLES)
		return ErrorMsg(playerid, "Nepostojeci ID vozila.");
		
	
	DestroyVehicle(veh_id);
	
	
	// Slanje poruke staffu
	AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je unistio vozilo ID %d.", ime_rp[playerid], veh_id);
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /unisti | Izvrsio: %s | ID: %d", ime_obicno[playerid], veh_id);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	
	return 1;
}

CMD:fv(playerid, const params[]) 
{
	// Override za Promo i VIP
	// -------------------------------------------------------
	if (IsPromoter(playerid, 3) && !IsHelper(playerid, 1))
		return callcmd::promofv(playerid, "");

	if (IsVIP(playerid, 1) && !IsHelper(playerid, 1))
		return callcmd::vipfv(playerid, "");
	// -------------------------------------------------------
		
	new targetid = INVALID_PLAYER_ID, 
		vehicleid;
	if (sscanf(params, "u", targetid))
	{
		if (!IsPlayerInAnyVehicle(playerid)) 
		{
			ErrorMsg(playerid, "Niste u vozilu.");
			Koristite(playerid, "fv [Ime ili ID igraca]");
			return 1;
		}

		// Popravka sopstvenog vozila

		vehicleid = GetPlayerVehicleID(playerid);

		new engine, lights, alarm, doors, bonnet, boot, objective;
		RepairVehicle(vehicleid);
		SetVehicleHealth(vehicleid, 999.0);
		
		// Pali vozilo ako je bilo ugaseno jer je bilo mnogo osteceno
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);

		SendClientMessage(playerid, SVETLOPLAVA, "* Vozilo je popravljeno.");
	}
	else
	{
		if (!IsPlayerConnected(targetid))
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (!IsPlayerInAnyVehicle(targetid))
			return ErrorMsg(playerid, "Taj igrac nije u vozilu.");

		if (gCmdUsedOnPlayer_Fv[targetid] > gettime())
			return ErrorMsg(playerid, "Drugi Helper/Admin je vec koristio ovu komandu za tog igraca.");

		new sDialog[255];
		format(sDialog, sizeof sDialog, "{FFFFFF}%s %s ti zeli popraviti vozilo.\n\nTvoje vozilo ce biti popravljeno za {FFFF00}100 hp {FFFFFF}po ceni {FF0000}$%s.\n\n{FFFFFF}Savetujemo ti da ubuduce koristis mehanicarske garaze za popravku - {00CC00}jeftinije je!", (IsAdmin(playerid, 1)? ("Admin") : ("Helper")), ime_rp[playerid], (PI[targetid][p_nivo] <= 10 || IsNewPlayer(targetid)? ("0") : ("5.000")));
		SPD(targetid, "fv_request", DIALOG_STYLE_MSGBOX, "{FFFFFF}Popravka vozila", sDialog, "Prihvati", "Odbij");

		// Slanje poruka igracu i staffu
		if (PI[playerid][p_admin] > 0 || gHeadAdmin{playerid} == true)
		{
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je ponudio popravku vozila igracu %s[%d].", ime_rp[playerid], ime_rp[targetid], targetid);
		}
		else if (PI[playerid][p_helper] > 0)
		{
			StaffMsg(BELA, "H {8EFF00}| %s je ponudio popravku vozila igracu %s[%d].", ime_rp[playerid], ime_rp[targetid], targetid);
		}

		gCmdUsedOnPlayer_Fv[targetid] = gettime() + 15;

		// Upisivanje u log
		format(string_128, sizeof string_128, "Komanda: /fv | Izvrsio: %s | Igrac: %s", ime_obicno[playerid], ime_obicno[targetid]);
		Log_Write(LOG_ADMINKOMANDE, string_128);
	}

	return 1;
}

CMD:rtc(playerid, const params[]) 
{
	if (!IsPlayerInAnyVehicle(playerid)) 
		return ErrorMsg(playerid, "Ovu komandu mozete koristiti samo u vozilu!");
		
	new vehicleid = GetPlayerVehicleID(playerid);
	SetVehicleToRespawn(vehicleid);
	
	// Slanje poruke staffu
	if (IsAdmin(playerid, 1))
	{
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je respawnao svoje vozilo.", ime_rp[playerid]);
	}
	else if (IsHelper(playerid, 1))
	{
		StaffMsg(BELA, "H {8EFF00}| %s je respawnao svoje vozilo.", ime_rp[playerid]);
	}
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /rtc | Izvrsio: %s | ID: %d", ime_obicno[playerid], vehicleid);
	Log_Write(LOG_ADMINKOMANDE, string_128);
	return 1;
}

CMD:kucatp(playerid, const params[]) 
{
	new id, gid;
	if (sscanf(params, "i", id))
		return Koristite(playerid, "kucatp [id kuce]");

	if (id < 1 || id >= MAX_KUCA)
		return ErrorMsg(playerid, "ID mora da bude izmedju 1 i "#MAX_KUCA);

	gid = re_globalid(kuca, id);
	TeleportPlayer(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);

	InfoMsg(playerid, "Teleportovan si do kuce {FFFFFF}%d", id);
	return 1;
}

CMD:firmatp(playerid, const params[]) 
{
	new id, gid;
	if (sscanf(params, "i", id))
		return Koristite(playerid, "firmatp [id firme]");

	if (id < 1 || id >= MAX_FIRMI)
		return ErrorMsg(playerid, "ID mora da bude izmedju 1 i "#MAX_FIRMI);

	gid = re_globalid(firma, id);
	TeleportPlayer(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);

	InfoMsg(playerid, "Teleportovan si do firme {FFFFFF}%d", id);
	return 1;
}

CMD:xport(playerid, const params[]) 
{
	new 
		Float:X, 
		Float:Y, 
		Float:Z, 
		Float:A, 
		Float:ent
	;
	if (sscanf(params, "p<,>fffff", X, Y, Z, A, ent)) 
		return Koristite(playerid, "xport [X], [Y], [Z], [A], [Enterijer]");
		
	SetPlayerInterior(playerid, floatround(ent));
	TeleportPlayer(playerid, X, Y, Z);
	return 1;
}

CMD:pickup(playerid, const params[]) 
{
	GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	CreateDynamicPickup(strval(params), 1, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	return 1;
}

CMD:vtest(playerid, params[]) 
{
	new Float:poz[3][3], id;
	sscanf(params, "u", id);
	
	GetPlayerPos(id, poz[0][0], poz[0][1], poz[0][2]);
	GetPlayerCameraPos(id, poz[1][0], poz[1][1], poz[1][2]);
	GetPlayerCameraFrontVector(id, poz[2][0], poz[2][1], poz[2][2]);
	
	
	SendClientMessage(id, -1, "");
	
	format(string_64, 64, "Player: %s[%d]", ime_rp[id], id);
	SendClientMessage(id, -1, string_64);
	
	format(string_64, 64, "Position | X: %.2f, Y: %.2f, Z: %.2f", poz[0][0], poz[0][1], poz[0][2]);
	SendClientMessage(id, -1, string_64);
	
	format(string_64, 64, "Camera Position | X: %.2f, Y: %.2f, Z: %.2f", poz[1][0], poz[1][1], poz[1][2]);
	SendClientMessage(id, -1, string_64);
	
	format(string_64, 64, "Camera Front Vector | X: %.2f, Y: %.2f, Z: %.2f", poz[2][0], poz[2][1], poz[2][2]);
	SendClientMessage(id, -1, string_64);
	
	return 1;
}

CMD:spec(playerid, const params[]) 
{
	if (gSpectatingPlayer[playerid] == INVALID_PLAYER_ID) 
	{
		// Nikoga ne posmatra, potrebno je da unese ID nekog igraca
		new id;
		if (sscanf(params, "u", id))
			return Koristite(playerid, "spec [Ime ili ID igraca]");

		if (!IsPlayerConnected(id))
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (!IsPlayerLoggedIn(id))
			return ErrorMsg(playerid, "Igrac nije ulogovan.");

		if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
			return ErrorMsg(playerid, GRESKA_IMUNITET);

		if (Iter_Count(iAdminsSpectating) == 0) 
		{
			// Nema admina na specu, ovaj ce biti prvi -> pokrenuti tajmer
			tmrSpecUpdate = SetTimer("SpecUpdate", 3000, true);
		}

		gSpectatingPlayer[playerid] = id;
		if (!Iter_Contains(iAdminsSpectating, playerid))
		{
			Iter_Add(iAdminsSpectating, playerid);
		}
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && VehicleHasPassengers(GetPlayerVehicleID(playerid))) 
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));


		SavePlayerWeaponDataAndPos(playerid);


		// TD inicijalizacija
		ptdSpec_Create(playerid); // kreiranje + prikazivanje
		for (new i = 0; i < sizeof(tdSpec); i++)
			TextDrawShowForPlayer(playerid, tdSpec[i]);


		TogglePlayerSpectating_H(playerid, true);
		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		if (!IsPlayerInAnyVehicle(id))
			PlayerSpectatePlayer(playerid, id, SPECTATE_MODE_NORMAL);
		else 
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(id), SPECTATE_MODE_NORMAL);

		SpecUpdate();
	}
	else 
	{
		// Posmatra nekoga

		// Ako je bez parametara, onda ide uncom
		// Ako je sa parametrima, prebacuje sliku na drugog igraca

		// if (isnull(params)) // uncon
		// {
		//     TogglePlayerSpectating_H(playerid, false);
		//     StopSpec(playerid);

		//     for (new i = 0; i < sizeof(tdSpec); i++)
		//         TextDrawHideForPlayer(playerid, tdSpec[i]);

		//     ptdSpec_Destroy(playerid);
		// }
		// else
		// {
		//     ptdSpec_Destroy(playerid);
		//     gSpectatingPlayer[playerid] = INVALID_PLAYER_ID;

		//     cmd_spec(playerid, params);
		// }



		// UNCON
		pRestoreData{playerid} = true;
		TogglePlayerSpectating_H(playerid, false);
		StopSpec(playerid);

		for (new i = 0; i < sizeof(tdSpec); i++)
			TextDrawHideForPlayer(playerid, tdSpec[i]);

		ptdSpec_Destroy(playerid);
	}
	return 1;
}
CMD:push(playerid, const params[]) 
{
	new Float:distance, Float:pos[4];
	if (sscanf(params, "F(5.0)", distance) || distance < 1.0 || distance > 100.0)
		return Koristite(playerid, "push [Udaljenost]");

	GetPlayerPos(playerid, pos[POS_X], pos[POS_Y], pos[POS_Z]);
	if (!IsPlayerInAnyVehicle(playerid))
		GetPlayerFacingAngle(playerid, pos[POS_A]);
	else
		GetVehicleZAngle(GetPlayerVehicleID(playerid), pos[POS_A]);

	//MapAndreas_FindZ_For2DCoord(pos[POS_X], pos[POS_Y], pos[POS_Z]);
	CA_FindZ_For2DCoord(pos[POS_X], pos[POS_Y], pos[POS_Z]);
	TeleportPlayer(playerid, pos[POS_X] - distance*floatcos(90-pos[POS_A], degrees), pos[POS_Y] + distance*floatsin(90-pos[POS_A], degrees), pos[POS_Z]+1.0);

	return 1;
}

CMD:nitro(playerid, const params[]) 
{
	if (!IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Morate biti u vozilu da biste koristili ovu naredbu.");

	new vehicleid = GetPlayerVehicleID(playerid);
	if (!VehicleSupportsNitro(GetVehicleModel(vehicleid)))
		return ErrorMsg(playerid, "U ovo vozilo se ne moze ugraditi nitro.");

	if (GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO) == 1010) {
		RemoveVehicleComponent(vehicleid, 1010);
		SendClientMessage(playerid, SVETLOPLAVA, "* Uklonili ste nitro iz svog vozila.");
	}
	else {
		AddVehicleComponent(vehicleid, 1010);
		SendClientMessage(playerid, SVETLOPLAVA, "* Ugradili ste nitro u svoje vozilo.");
	}
	return 1;
}

CMD:gmx(playerid, const params[])
{
	new time;
	if (sscanf(params, "i", time))
		return Koristite(playerid, "gmx [Vreme u sekundama do restarta]");

	if (time < 3 || time > 60)
		return ErrorMsg(playerid, "Vreme mora biti izmedju 3 i 60 sekundi.");

	new string[90];
	format(string, sizeof string, "* Head admin %s je pokrenuo restart servera za %i sekundi.", ime_rp[playerid], time);
	SendClientMessageToAll(CRVENA, string);
	RestartServer(time);
	return 1;
}

CMD:promeniime(playerid, const params[])
{
	if (!IsAdmin(playerid, 6))
	{
		if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2601.0806,2584.8738,-97.9156))
			return ErrorMsg(playerid, "Morate biti u opstini da biste promenili ime.");

		SPD(playerid, "promeniime", DIALOG_STYLE_INPUT, "PROMENI IME", "{FFFFFF}Promena imena kosta {FFFF00}$15.000.000\n\n{FFFFFF}Upisite svoje zeljeno ime:", "Promeni", "Odustani");
	}

	else
	{
		new targetid, name[MAX_PLAYER_NAME];
		if (sscanf(params, "us[24]", targetid, name))
			return Koristite(playerid, "promeniime [Ime ili ID igraca] [Novo ime]");

		if (!IsPlayerConnected(targetid))
			return ErrorMsg(playerid, GRESKA_OFFLINE);


		SendClientMessageF(playerid, SVETLOPLAVA, "* Promenili ste ime igracu: {FFFFFF}%s {33CCFF}» {FFFFFF}%s.", ime_obicno[targetid], name);
		SendClientMessageF(targetid, BELA,        "{FF6347}- STAFF:{B4CDED} %s Vam je promenio ime: {FFFFFF}%s {FF6347}» {FFFFFF}%s", ime_rp[playerid], ime_obicno[targetid], name);
		
		ProcessNameChange(targetid, name);
	}
	return 1;
}

CMD:editprop(playerid, const params[])
{
	if (isnull(params))
	{
		SPD(playerid, "re_a_editprop", DIALOG_STYLE_LIST, "IZMENI NEKRETNINU", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica\nImanje", "Odaberi", "Nazad");
	}
	else
	{
		new sPropType[16], propId;
		if (!sscanf(params, "s[10] i", sPropType, propId))
		{
			SetPVarInt(playerid, "pEditpropID", propId);
			dialog_respond:re_a_editprop(playerid, 1, -1, sPropType);
		}
	}
	return 1;
}

flags:firmaproizvodi(FLAG_ADMIN_6)
CMD:firmaproizvodi(playerid, const params[])
{
	new
		id,
		gid,
		vrsta_f,
		string[1024]
	;
	if(!sscanf(params, "i", id))
	{
		gid = re_globalid(firma, id);
		vrsta_f = RealEstate[gid][RE_VRSTA];

		SetPVarInt(playerid, "FirmaEdituje", id);

		// Formatiranje stringa za dialog
		format(string, sizeof(string), "Naziv proizvoda\tJedinicna cena za porudzbinu");
		for__loop (new i = 0; i < sizeof(proizvodi[]) && proizvodi[vrsta_f][i] > 0; i++) 
		{
			new unitPrice = PRODUCTS[ proizvodi[vrsta_f][i] ][pr_cena]/3;
			if (unitPrice <= 0) unitPrice = 1;
			format(string, sizeof(string), "%s\n%s\t$%d", string, PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv], unitPrice);
		}
		
		SPD(playerid, "firma_proizvodi", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}FIRMA - PROIZVODI", string, "Dalje >", "< Nazad");
	}
	return 1;
}

Dialog:firma_proizvodi(playerid, response, listitem, const inputtext[]) // Narucivanje proizvoda
{
	if(!response)
		return 1;
		
	new
		gid     = re_globalid(firma, GetPVarInt(playerid, "FirmaEdituje")),
		vrsta_f = RealEstate[gid][RE_VRSTA], // Vrsta firme
		pid     = proizvodi[vrsta_f][listitem] // ID proizvoda
	;

	uredjuje[playerid][UREDJUJE_INFO] = listitem;
	
	// Formatiranje stringa za dialog
	format(string_256, sizeof string_256, "{FFFFFF}Dodavanje proizvoda: {0068B3}%s\n{FFFFFF}Trenutno stanje: {0068B3}%d\n{FFFFFF}\n\nUpisite kolicinu koju zelite da dodate:", PRODUCTS[pid][pr_naziv], F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock]);
	SPD(playerid, "proizvodi_provera", DIALOG_STYLE_INPUT, "{0068B3}FIRMA - PROIZVODI", string_256, "Dalje >", "< Nazad");

	return 1;
}

Dialog:proizvodi_provera(playerid, response, listitem, const inputtext[]) // Provera kolicine i cene
{
	if(!response)
		return 1;

	new
		gid     = re_globalid(firma, GetPVarInt(playerid, "FirmaEdituje")),
		vrsta_f = RealEstate[gid][RE_VRSTA], // Vrsta firme
		pid     = proizvodi[vrsta_f][uredjuje[playerid][UREDJUJE_INFO]], // ID proizvoda
		kolicina
	;
	
	if (sscanf(inputtext, "i", kolicina))
		return DialogReopen(playerid);

	if (kolicina < 1 || kolicina > 1000)
	{
		ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i 1000 komada.");
		return DialogReopen(playerid);
	}

	SetPVarInt(playerid, "reOrderQuantity", kolicina);

	// Formatiranje dialoga
	format(string_256, 200, "{FFFFFF}Naziv proizvoda: {0068B3}%s\n\n{FFFFFF}Narucivanje {0068B3}%d {FFFFFF}komada ovog proizvoda ce Vas kostati {0068B3}$%d.",
		PRODUCTS[pid][pr_naziv], kolicina, GetPVarInt(playerid, "reOrderPrice"));
	SPD(playerid, "proizvodi_potvrda", DIALOG_STYLE_MSGBOX, "{0068B3}FIRMA - PROIZVODI", string_256, "Naruci", "Odustani");
	return 1;
}

Dialog:proizvodi_potvrda(playerid, response, listitem, const inputtext[]) { // Finalna provera i potvrda porudbine
	
	if (!response)
		return 1;

	new
		gid     = re_globalid(firma, GetPVarInt(playerid, "FirmaEdituje")),
		vrsta_f = RealEstate[gid][RE_VRSTA], // Vrsta firme
		pid     = proizvodi[vrsta_f][uredjuje[playerid][UREDJUJE_INFO]], // ID proizvoda
		lid     = re_localid(firma, gid)
	;
	
	F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock] += GetPVarInt(playerid, "reOrderQuantity");

	// Slanje poruke igracu
	SendClientMessage(playerid, SVETLOPLAVA, "(firma) {FFFFFF}Uspjesno ste dodali jos proizvoda firmi.");
	SendClientMessageF(playerid, BELA, "* Dodali ste {33CCFF}%s {FFFFFF}| %d komada", PRODUCTS[pid][pr_naziv], GetPVarInt(playerid, "reOrderQuantity"));

	// Upisivanje u bazu
	mysql_format(SQL,mysql_upit, 90, "UPDATE re_firme_proizvodi SET stock = %d WHERE fid = %d AND pid = %d", F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock], lid, pid);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_PROIZVODIUPDATE);

	// Upisivanje u log
	format(string_128, sizeof string_128, "PORUCIVANJE | Firma [%d] | %s je dodao %s (kolicina: %d)", lid, ime_obicno[playerid], PRODUCTS[pid][pr_naziv], GetPVarInt(playerid, "reOrderQuantity"));
	Log_Write(LOG_FIRME, string_128);

	DeletePVar(playerid, "FirmaEdituje");
	DeletePVar(playerid, "reOrderQuantity");

	return 1;
}
////////////////////////////////////////////////////////////////////////////

CMD:checkprop(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id)) 
		return Koristite(playerid, "checkprop [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id)) 
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	if (!IsPlayerLoggedIn(id)) 
		return ErrorMsg(playerid, "Igrac nije prijavljen.");

	new kuca_str[RE_MAX_SLOTS*6], stan_str[RE_MAX_SLOTS*6], firma_str[RE_MAX_SLOTS*6], garaza_str[RE_MAX_SLOTS*6], hotel_str[RE_MAX_SLOTS*6], vikendica_str[RE_MAX_SLOTS*6];
	new v1_str[26], v2_str[26], v3_str[26], v4_str[26], v5_str[26];


	 // Formatiranje stringova za nekretnine
	if (pRealEstate[id][kuca] == -1)
		kuca_str = "Nema";
	else
		valstr(kuca_str, pRealEstate[id][kuca]);

	if (pRealEstate[id][stan] == -1)
		stan_str = "Nema";
	else
		valstr(stan_str, pRealEstate[id][stan]);

	if (pRealEstate[id][firma] == -1)
		firma_str = "Nema";
	else
		format(firma_str, sizeof firma_str, "%d (%s)", pRealEstate[id][firma], vrstafirme(RealEstate[re_globalid(firma, pRealEstate[id][firma])][RE_VRSTA], PROPNAME_CAPITAL));

	if (pRealEstate[id][garaza] == -1)
		garaza_str = "Nema";
	else
		valstr(garaza_str, pRealEstate[id][garaza]);

	if (pRealEstate[id][hotel] == -1)
		hotel_str = "Nema";
	else
		valstr(hotel_str, pRealEstate[id][hotel]);

	if (pRealEstate[id][vikendica] == -1)
		vikendica_str = "Nema";
	else
		valstr(vikendica_str, pRealEstate[id][vikendica]);

	// Formatiranje stringova za vozila
	if (pVehicles[id][0] <= 0)
		v1_str = "Nema";
	else
		format(v1_str, sizeof v1_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][0]][V_MODEL] - 400], pVehicles[id][0]);

	if (pVehicles[id][1] <= 0)
		v2_str = "Nema";
	else
		format(v2_str, sizeof v2_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][1]][V_MODEL] - 400], pVehicles[id][1]);
		
	if (pVehicles[id][2] <= 0)
		v3_str = "Nema";
	else
		format(v3_str, sizeof v3_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][2]][V_MODEL] - 400], pVehicles[id][2]);
		
	if (pVehicles[id][3] <= 0)
		v4_str = "Nema";
	else
		format(v4_str, sizeof v4_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][3]][V_MODEL] - 400], pVehicles[id][3]);
		
	if (pVehicles[id][4] <= 0)
		v5_str = "Nema";
	else
		format(v5_str, sizeof v5_str, "%s (%i)", imena_vozila[OwnedVehicle[pVehicles[id][4]][V_MODEL] - 400], pVehicles[id][4]);


	// Ispisivanje
	SendClientMessageF(playerid, NARANDZASTA, "_________ ** {FFFFFF}%s[%i] {FF9900}** {FFFFFF}%s {FF9900} ** _____________________________________________", ime_rp[id], id, trenutno_vreme());
	SendClientMessageF(playerid, 0xFFFFFFFF, "Kuca: [%s]   Stan: [%s]   Firma: [%s]   Garaza: [%s]   Hotel: [%s]   Vikendica: [%s]", kuca_str, stan_str, firma_str, garaza_str, hotel_str, vikendica_str);
	SendClientMessageF(playerid, 0xCECECEFF, "v1: [%s]   v2: [%s]   v3: [%s]   v4: [%s]   v5: [%s]", v1_str, v2_str, v3_str, v4_str, v5_str);
	return 1;
}

CMD:nagradisve(playerid, const params[])
{
	SPD(playerid, "nagradisve", DIALOG_STYLE_LIST, "Nagradi sve igrace", "Level UP\nNovac\nPoeni iskustva", "Dalje", "Odustani");
	return 1;
}

CMD:playmusic(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "playmusic [Link]");

	if (gMusicReload > gettime() && gMusicPlayer != playerid)
		return ErrorMsg(playerid, "Sacekaj da se zavrsi pesma koju je pustio drugi DJ.");

	foreach (new i : Player)
	{
		if (pAdminMusic{i})
		{
			PlayAudioStreamForPlayer(i, params);
			SendClientMessageF(i, GRAD2, "* DJ %s je pustio muziku. Ukoliko ne zelite da je slusate, upisite {FFFFFF}/music.", ime_rp[playerid]);
		}
	}

	format(djMusicLink, sizeof djMusicLink, "%s", params);

	gMusicReload = gettime() + 120;
	gMusicPlayer = playerid;

	return 1;
}

CMD:h1(playerid, const params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
		return Koristite(playerid, "h1 [Ime ili ID igraca]");

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (gCmdUsedOnPlayer_H1[targetid] > gettime())
		return ErrorMsg(playerid, "Drugi Helper/Admin je vec koristio ovu komandu za tog igraca.");

	gCmdUsedOnPlayer_H1[targetid] = gettime() + 15;

	new cmdParams[70];
	format(cmdParams, sizeof cmdParams, "%i Dobrodosao na NL! Zelimo ti dobru zabavu i prijatan boravak.", targetid);
	callcmd::pm(playerid, cmdParams);
	return 1;
}

CMD:h2(playerid, const params[])
{
	new targetid;
	if (sscanf(params, "u", targetid))
	{
		Koristite(playerid, "h2 [Ime ili ID igraca]");
		SendClientMessage(playerid, GRAD2, "Ukoliko ti je potrebna pomoc, mozes nam se javiti preko komande /askq ili /new.");
	}

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (gCmdUsedOnPlayer_H2[targetid] > gettime())
		return ErrorMsg(playerid, "Drugi Helper/Admin je vec koristio ovu komandu za tog igraca.");

	gCmdUsedOnPlayer_H2[targetid] = gettime() + 15;

	new cmdParams[90];
	format(cmdParams, sizeof cmdParams, "%i Ukoliko ti je potrebna pomoc, mozes nam se javiti preko komande /askq ili /new.", targetid);
	callcmd::pm(playerid, cmdParams);
	return 1;
}

CMD:transfer(playerid, const params[])
{
	if (!IsAdmin(playerid, 6))
	{
		ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		InfoMsg(playerid, "Za transfer novca drugom igracu morate otici u banku.");
		return 1;
	}

	if(PI[playerid][p_provedeno_vreme] < 30 * 3600) return ErrorMsg(playerid, "Morate imati 30 sati igre da prebacite novac.");

	new id, cash;
	if (sscanf(params, "ui", id, cash))
		return Koristite(playerid, "transfer [Ime ili ID igraca] [Iznos novca]");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (cash < 1 || cash > 20000000)
		return ErrorMsg(playerid, "Iznos novca mora biti izmedju $1 i $20.000.000.");

	PlayerMoneyAdd(id, cash);
	SendClientMessageF(playerid, SVETLOPLAVA, "* Prebacili ste %s novac u iznosu %s.", ime_rp[id], formatMoneyString(cash));
	SendClientMessageF(id, SVETLOPLAVA, "* %s Vam je prebacio novac u iznosu %s.", ime_rp[playerid], formatMoneyString(cash));
		
	format(string_128, sizeof string_128, "NOVAC-TRANSFER | Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], cash);
	Log_Write(LOG_POSTAVLJANJE, string_128);
	return 1;
}

CMD:fine(playerid, const params[])
{
	new id, cash;
	if (sscanf(params, "ui", id, cash))
		return Koristite(playerid, "fine [Ime ili ID igraca] [Iznos novca]");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (cash < 1 || cash > 50000000)
		return ErrorMsg(playerid, "Iznos novca mora biti izmedju $1 i $50.000.000.");

	PlayerMoneySub(id, cash);
	SendClientMessageF(playerid, SVETLOCRVENA, "* Kaznili ste %s novcano u iznosu %s.", ime_rp[id], formatMoneyString(cash));
	SendClientMessageF(id, SVETLOCRVENA, "* %s Vas je kaznio novcano u iznosu %s.", ime_rp[playerid], formatMoneyString(cash));
		
	format(string_128, sizeof string_128, "NOVAC-KAZNA | Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], cash);
	Log_Write(LOG_KAZNE, string_128);
	return 1;
}

flags:myduty(FLAG_ADMIN_1 | FLAG_HELPER_1)
CMD:myduty(playerid)
{
	new sQuery[243];
	if(IsAdmin(playerid, 1))
	{
		mysql_format(SQL, sQuery, sizeof sQuery, "SELECT DATE_FORMAT(date, '\%%d \%%b') as datum, dutyTime, pms FROM staff_activity LEFT JOIN igraci ON igraci.id = staff_activity.pid WHERE igraci.ime = '%s' AND date >= NOW() - INTERVAL 14 DAY ORDER BY date DESC", ime_obicno[playerid]);
		mysql_tquery(SQL, sQuery, "MySQL_StaffDutyTime", "iiis", playerid, cinc[playerid], THREAD_HELPERI, ime_obicno[playerid]);
	}
	else
	{
		mysql_format(SQL, sQuery, sizeof sQuery, "SELECT DATE_FORMAT(date, '\%%d \%%b') as datum, dutyTime, pms FROM staff_activity LEFT JOIN igraci ON igraci.id = staff_activity.pid WHERE igraci.ime = '%s' AND date >= NOW() - INTERVAL 14 DAY ORDER BY date DESC", ime_obicno[playerid]);
		mysql_tquery(SQL, sQuery, "MySQL_StaffDutyTime", "iiis", playerid, cinc[playerid], THREAD_ADMINI, ime_obicno[playerid]);
	}
	return 1;
}

CMD:staff(playerid, const params[])
{
	SPD(playerid, "staff", DIALOG_STYLE_LIST, "Staff", "Admini\nHelperi\nPromoteri\nLideri\nVIP\nDJ", "Dalje »", "« Nazad");
	return 1;
}

CMD:resetkaznu(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id))
		return Koristite(playerid, "kazni [Ime ili ID igraca]");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(id))
		return ErrorMsg(playerid, "Taj igrac nije ulogovan.");

	PI[id][p_zabrana_oruzje] = 0;
	PI[id][p_cheater] = 0;

	new sQuery[90];
	mysql_format(SQL,sQuery, sizeof sQuery, "UPDATE igraci SET zabrana_oruzje = %i, cheater = %i WHERE id = %i", PI[id][p_zabrana_oruzje], PI[id][p_cheater], PI[id][p_id]);    
	mysql_tquery(SQL, sQuery);

	SpawnPlayer(id);

	SendClientMessageF(id, BELA, "{FF6347}- STAFF:{B4CDED} Admin %s Vam je skinuo zabranu {FFFFFF}nosenja oruzja.", ime_rp[playerid]);
	SendClientMessageF(playerid, BELA, "{FF6347}- STAFF:{B4CDED} Skinuli ste %s zabranu {FFFFFF}nosenja oruzja.", ime_rp[id]);
	return 1;
}

CMD:kazni(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id))
		return Koristite(playerid, "kazni [Ime ili ID igraca]");

	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerLoggedIn(id))
		return ErrorMsg(playerid, "Taj igrac nije ulogovan.");

	if (IsAdmin(id, 1) && !IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_IMUNITET);

	SetPVarInt(playerid, "aPunishmentID", id);

	new title[55];
	format(title, sizeof title, "{FFFFFF}Kazni igraca: {FF0000}%s", ime_rp[id]);
	SPD(playerid, "kazni", DIALOG_STYLE_LIST, title, "\
		Non RP\n\
		Power Gaming (PG)\n\
		Death Match (DM)\n\
		Revenge Kill (RK)\n\
		Spawn Kill (SK)\n\
		Team Killing (TK)\n\
		Mesanje u turf/pljacku\n\
		Heli abuse / H abuse\n\
		Vredjanje/psovanje/provociranje\n\
		Zloupotreba /prijava ili /pitanje\n\
		Zloupotreba oglasa\n\
		Drive By (DB)\n\
		Meta Gaming (MG)\n\
		VIP/Promo Abuse\n\
		Odbijanje provere\n\
		Cheat\n\
		Cheat (Aim/WH)\n\
		RolePlay Superman (RPS)", "Kazni", "Odustani");
	return 1;
}

CMD:zabrana(const playerid, params[]) 
{
	new str[8], targetid, duration;

	if (strfind(params, "lider") != -1) // Zabrana: lider
	{
		if (sscanf(params, "s[6]uii", str, targetid, duration)) 
			return Koristite(playerid, "zabrana lider [Ime ili ID igraca] [Trajanje (u danima)]");
			
		// Validacija inputa
		if (!IsPlayerConnected(targetid)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (duration < 1 || duration > 60)
			return ErrorMsg(playerid, "Trajanje mora biti izmedju 1 i 60 dana.");

		PI[targetid][p_zabrana_lider] = gettime() + duration*86400; // X dana zabrane

		SendClientMessageF(targetid, BELA, "{FF6347}- STAFF:{B4CDED} Admin %s Vam je postavio zabranu na poziciju {FFFFFF}lider {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[playerid], duration);
		SendClientMessageF(playerid, BELA, "{FF6347}- STAFF:{B4CDED} Postavili ste %s zabranu na poziciju {FFFFFF}lider {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[targetid], duration);

		new query[65];
		mysql_format(SQL,query, sizeof query, "UPDATE igraci SET zabrana_lider = %i WHERE id = %i", PI[targetid][p_zabrana_lider], PI[targetid][p_id]);
		mysql_tquery(SQL, query);
	}
	else if (strfind(params, "staff") != -1) // Zabrana: staff
	{
		if (sscanf(params, "s[6]uii", str, targetid, duration)) 
			return Koristite(playerid, "zabrana staff [Ime ili ID igraca] [Trajanje (u danima)]");
			
		// Validacija inputa
		if (!IsPlayerConnected(targetid)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (duration < 1 || duration > 60)
			return ErrorMsg(playerid, "Trajanje mora biti izmedju 1 i 60 dana.");

		PI[targetid][p_zabrana_staff] = gettime() + duration*86400; // X dana zabrane

		SendClientMessageF(targetid, BELA, "{FF6347}- STAFF:{B4CDED} Admin %s Vam je postavio zabranu na poziciju {FFFFFF}admin/helper {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[playerid], duration);
		SendClientMessageF(playerid, BELA, "{FF6347}- STAFF:{B4CDED} Postavili ste %s zabranu na poziciju {FFFFFF}admin/helper {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[targetid], duration);

		new query[65];
		mysql_format(SQL,query, sizeof query, "UPDATE igraci SET zabrana_staff = %i WHERE id = %i", PI[targetid][p_zabrana_staff], PI[targetid][p_id]);
		mysql_tquery(SQL, query);
	}
	else if (strfind(params, "oruzje") != -1) // Zabrana: oruzje
	{
		if (sscanf(params, "s[7]uii", str, targetid, duration)) 
			return Koristite(playerid, "zabrana oruzje [Ime ili ID igraca] [Trajanje (u danima)]");
			
		// Validacija inputa
		if (!IsPlayerConnected(targetid)) 
			return ErrorMsg(playerid, GRESKA_OFFLINE);

		if (duration < 1 || duration > 60)
			return ErrorMsg(playerid, "Trajanje mora biti izmedju 1 i 60 dana.");

		PI[targetid][p_zabrana_oruzje] = gettime() + duration*86400; // X dana zabrane

		SendClientMessageF(targetid, BELA, "{FF6347}- STAFF:{B4CDED} Admin %s Vam je postavio zabranu {FFFFFF}nosenja oruzja {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[playerid], duration);
		SendClientMessageF(playerid, BELA, "{FF6347}- STAFF:{B4CDED} Postavili ste %s zabranu {FFFFFF}nosenja oruzja {FF6347}u trajanju od {FFFFFF}%i dana.", ime_rp[targetid], duration);

		new query[66];
		mysql_format(SQL,query, sizeof query, "UPDATE igraci SET zabrana_oruzje = %i WHERE id = %i", PI[targetid][p_zabrana_oruzje], PI[targetid][p_id]);
		mysql_tquery(SQL, query);
	}
	else
	{
		Koristite(playerid, "zabrana [Sta zabranjujete] [Ime ili ID igraca] [Trajanje (u danima)]");
		SendClientMessage(playerid, GRAD2, "Moguce zabraniti: [lider] [staff] [oruzje]");
		return 1;
	}

	StrToUpper(str);
	new sLog[90];
	format(sLog, sizeof sLog, "%s | %s | %s na %i dana", str, ime_obicno[playerid], ime_obicno[targetid], duration);
	Log_Write(LOG_ZABRANE, sLog);
	return 1;
}


CMD:pos(playerid, const params[])
{
	new Float:pos[4];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, pos[3]);

	SendClientMessageF(playerid, -1, "Pozicija: %.4f,  %.4f,  %.4f,  %.4f", pos[0], pos[1], pos[2], pos[3]);
	return 1;
}

flags:vratistats(FLAG_ADMIN_6)
CMD:vratistats(playerid, const params[])
{
	new playerName[MAX_PLAYER_NAME], targetid = INVALID_PLAYER_ID, level, cash;
	if (sscanf(params, "s[24] ii", playerName, level, cash))
		return Koristite(playerid, "vratistats [Ime igraca (*ne ID*)] [Nivo] [Novac]"); 

	if (level < 1 || level > 20)
		return ErrorMsg(playerid, "Nivo mora biti izmedju 1 i 15.");

	if (cash < 1 || cash > 2000000)
		return ErrorMsg(playerid, "Novac moze iznositi najvise $2.000.000.");

	foreach(new i : Player)
	{
		if (strcmp(ime_obicno[i], playerName, true) == 0)
		{
			targetid = i;
			break;
		}
	}

	if (IsPlayerConnected(targetid))
	{
		if (!IsPlayerLoggedIn(targetid))
			return ErrorMsg(playerid, "Taj igrac nije ulogovan.");

		if (!IsNewPlayer(targetid)) 
			return ErrorMsg(playerid, "Taj igrac nije novi.");

		PI[targetid][p_nivo] = level;
		SetPlayerScore(targetid, level);
		PlayerMoneyAdd(targetid, cash);

		SendClientMessageF(targetid, ZUTA, "STATS | Vracan ti je stats: {FFFFFF}level %i + %s.", level, formatMoneyString(cash));
		SendClientMessageF(playerid, SVETLOPLAVA, "Vratili ste stats igracu %s[%i]: level %i + %s", ime_rp[targetid], targetid, level, formatMoneyString(cash));

		new sQuery[256];
		mysql_format(SQL,sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %i, novac = %i WHERE id = %i", level, PI[targetid][p_novac], PI[targetid][p_id]);
		mysql_tquery(SQL, sQuery);
	}
	else
	{
		new sQuery[115];
		mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %i, novac = novac + %i WHERE ime = '%s' AND nivo < 8", level, cash, playerName);
		mysql_tquery(SQL, sQuery, "MySQL_StatsRestore", "iiiis", playerid, cinc[playerid], level, cash, playerName);
	}

	new sLog[86];
	format(sLog, sizeof sLog, "%s | %s | nivo %i + %s", ime_rp[playerid], playerName, level, formatMoneyString(cash));
	Log_Write(LOG_STATSRESTORE, sLog);

	return 1;
}

flags:kreirajcp(FLAG_ADMIN_6)
CMD:kreirajcp(playerid, const params[])
{
	new Float:radius, Float:x, Float:y, Float:z;
	if (sscanf(params, "f", radius) || radius < 1.0 || radius > 100.0)
		return Koristite(playerid, "kreirajcp [Radius]");

	GetPlayerPos(playerid, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, z, radius*2);
	return 1;
}

flags:unisticp(FLAG_ADMIN_6)
CMD:unisticp(playerid, const params[])
{
	DisablePlayerCheckpoint(playerid);
	return 1;
}

flags:resetpin(FLAG_ADMIN_6)
CMD:resetpin(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "resetpin [Ime igraca]");

	new 
		sQuery[115],
		iPin = 10000 + random(90000)
	;
	
	mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE staff SET pin = %i WHERE pid = (SELECT id FROM igraci WHERE ime = '%s')", iPin, params);
	mysql_tquery(SQL, sQuery, "MySQL_OnResetPin", "iisi", playerid, cinc[playerid], params, iPin);

	return 1;
}

flags:resetpw(FLAG_ADMIN_6)
CMD:resetpw(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "resetpw [Ime igraca]");

	new 
		sPassword[8]
	;

	sPassword[0] = EOS;
	RandomString(sPassword, sizeof (sPassword), RANDSTR_FLAG_UPPER | RANDSTR_FLAG_LOWER | RANDSTR_FLAG_DIGIT);
	// a
	bcrypt_hash(sPassword, BCRYPT_COST, "PassAdminChange", "iss", playerid, params, sPassword);

	return 1;
}

forward PassAdminChange(playerid, const params[], const unhashed[]);
public PassAdminChange(playerid, const params[], const unhashed[])
{
	new str[100];
	bcrypt_get_hash(str);
	
	new sQuery[300];
	mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE igraci SET lozinka = '%s' WHERE ime = '%s'", str, params);
	mysql_tquery(SQL, sQuery, "MySQL_OnResetPassword", "iisss", playerid, cinc[playerid], params, str, unhashed);

    return true;
}


flags:push(FLAG_ADMIN_1)
flags:resetkaznu(FLAG_ADMIN_1)
flags:kazni(FLAG_ADMIN_1)
flags:jetpack(FLAG_ADMIN_1)
flags:proveraip(FLAG_ADMIN_1)
flags:rv(FLAG_ADMIN_1)
flags:ao(FLAG_ADMIN_1)
flags:a(FLAG_ADMIN_1)
flags:eksplodiraj(FLAG_ADMIN_3)
flags:utisaj(FLAG_ADMIN_1) // [A4], A1 ima samo unmute
flags:area(FLAG_ADMIN_1) // [A4], A1 ima samo oslobadjanje
flags:oslobodi(FLAG_ADMIN_1)
flags:razoruzaj(FLAG_ADMIN_4)
flags:padobran(FLAG_ADMIN_2)
flags:ban(FLAG_ADMIN_1)
flags:bannick(FLAG_ADMIN_2)
flags:banip(FLAG_ADMIN_2)
flags:vreme(FLAG_ADMIN_5)
flags:baninfo(FLAG_ADMIN_3)
flags:izlecisve(FLAG_ADMIN_4)
flags:aizleci(FLAG_ADMIN_3)
flags:pancir(FLAG_ADMIN_3)
flags:nahranisve(FLAG_ADMIN_3)
flags:unbanip(FLAG_ADMIN_4)
flags:napunivozila(FLAG_ADMIN_4)
flags:offban(FLAG_ADMIN_5)
flags:checkprop(FLAG_ADMIN_5)
flags:offprovera(FLAG_ADMIN_5)
flags:getveh(FLAG_ADMIN_6)
flags:gotoveh(FLAG_ADMIN_6)
flags:enterveh(FLAG_ADMIN_6)
flags:unban(FLAG_ADMIN_6)
flags:ididocp(FLAG_ADMIN_6)
flags:ididorcp(FLAG_ADMIN_6)
flags:unisti(FLAG_ADMIN_6)
flags:kucatp(FLAG_ADMIN_6)
flags:firmatp(FLAG_ADMIN_6)
flags:xport(FLAG_ADMIN_6)
flags:pickup(FLAG_ADMIN_6)
flags:vtest(FLAG_ADMIN_6)
flags:nitro(FLAG_ADMIN_6)
flags:gmx(FLAG_ADMIN_6)
flags:editprop(FLAG_ADMIN_6)
flags:nagradisve(FLAG_ADMIN_6)
flags:fine(FLAG_ADMIN_6)
flags:transfer(FLAG_ADMIN_6)
flags:SendClientMessage(FLAG_ADMIN_6)
flags:SendClientMessagetoall(FLAG_ADMIN_6)
flags:setgun(FLAG_ADMIN_6)
flags:hao(FLAG_ADMIN_6)
flags:ha(FLAG_ADMIN_6)
flags:kreirajkod(FLAG_ADMIN_6)
flags:bport(FLAG_ADMIN_6)
flags:dobadana(FLAG_ADMIN_6)
flags:gt(FLAG_ADMIN_6)
flags:crash(FLAG_ADMIN_6)
flags:allowma(FLAG_ADMIN_6)
flags:h(FLAG_HELPER_1)
flags:ho(FLAG_HELPER_1)
flags:t(FLAG_HELPER_1)
flags:cc(FLAG_HELPER_1)
flags:h1(FLAG_HELPER_1)
flags:h2(FLAG_HELPER_1)
flags:nick(FLAG_HELPER_1)
flags:rtc(FLAG_HELPER_1)
flags:novajlije(FLAG_HELPER_1)
flags:utisani(FLAG_HELPER_1)
flags:zatvoreni(FLAG_HELPER_1)
flags:afkeri(FLAG_HELPER_1)
flags:dovedi(FLAG_HELPER_1)
flags:veh(FLAG_HELPER_1)
flags:dveh(FLAG_HELPER_1)
flags:ptp(FLAG_HELPER_1)
flags:proveri(FLAG_HELPER_2)
flags:kick(FLAG_ADMIN_1)
flags:respawn(FLAG_HELPER_3)
flags:respawntijela(FLAG_HELPER_3)
flags:zamrzni(FLAG_ADMIN_1)
flags:odmrzni(FLAG_HELPER_3)
flags:osamari(FLAG_ADMIN_1)
flags:ubij(FLAG_ADMIN_1)
flags:refill(FLAG_ADMIN_5 | FLAG_VIP_2)
flags:fv(FLAG_HELPER_1 | FLAG_VIP_1 | FLAG_PROMO_3)
flags:idido(FLAG_HELPER_1 | FLAG_VIP_1 | FLAG_PROMO_2)
flags:tp(FLAG_HELPER_1 | FLAG_VIP_1 | FLAG_PROMO_1)
flags:spec(FLAG_HELPER_3 | FLAG_SPEC_ADMIN | FLAG_HELPER_VODJA)
flags:playmusic(FLAG_ADMIN_6 | FLAG_DJ)
flags:staff(FLAG_ADMIN_6 | FLAG_HELPER_VODJA | FLAG_LEADER_VODJA | FLAG_ADMIN_VODJA | FLAG_PROMO_VODJA)
flags:postavi(FLAG_ADMIN_5 | FLAG_PROMO_VODJA | FLAG_LEADER_VODJA)
flags:zabrana(FLAG_ADMIN_6 | FLAG_ADMIN_VODJA | FLAG_LEADER_VODJA | FLAG_HELPER_VODJA)
