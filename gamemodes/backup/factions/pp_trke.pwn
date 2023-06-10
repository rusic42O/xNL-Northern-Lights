#include <YSI_Coding\y_hooks>

static Float:races_cp_pos[][3] = {
	{1499.7324, -1872.4452, 13.0442},
	{1281.6338, -1852.2908, 13.0442},
	{1066.8770, -1852.7883, 13.0442},
	{866.8852, -1771.5668, 13.0442}, 
	{628.1292, -1729.4778, 13.3500}, 
	{631.3096, -1551.7606, 15.0054}, 
	{619.3304, -1215.4574, 17.9014}, 
	{507.9936, -1276.4288, 15.6081}, 
	{507.3643, -1346.0718, 15.7869}, 
	{392.3306, -1409.5095, 33.7860}, 
	{429.1240, -1465.1204, 30.2528}, 
	{328.2036, -1569.1011, 32.8305}, 
	{328.7490, -1641.9000, 32.8305}, 
	{369.8489, -1658.6359, 32.8305}, 
	{369.7522, -2032.3790, 7.4631}
};


static izazvaoIgraca[MAX_PLAYERS], protivnikovIzazivac[MAX_PLAYERS], trkaulog[MAX_PLAYERS], PlayerText:TRKA_PTD[MAX_PLAYERS][3];

hook OnPlayerConnect(playerid) {

	TRKA_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 217.210830, 173.666687, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, TRKA_PTD[playerid][0], 210.000000, 180.000000);
	PlayerTextDrawAlignment(playerid, TRKA_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, TRKA_PTD[playerid][0], 255);
	PlayerTextDrawSetShadow(playerid, TRKA_PTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, TRKA_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, TRKA_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, TRKA_PTD[playerid][0], 0);

	TRKA_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 221.427505, 177.750000, "LD_RCE1:race00");
	PlayerTextDrawTextSize(playerid, TRKA_PTD[playerid][1], 202.000000, 171.000000);
	PlayerTextDrawAlignment(playerid, TRKA_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, TRKA_PTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, TRKA_PTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, TRKA_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, TRKA_PTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, TRKA_PTD[playerid][1], 0);

	TRKA_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 219.253707, 150.333465, "zile42o_vs_necro~n~ulog:_$50000~n~pobednik_dobija:_$100000");
	PlayerTextDrawLetterSize(playerid, TRKA_PTD[playerid][2], 0.173704, 0.888332);
	PlayerTextDrawTextSize(playerid, TRKA_PTD[playerid][2], 425.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, TRKA_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, TRKA_PTD[playerid][2], -1);
	PlayerTextDrawUseBox(playerid, TRKA_PTD[playerid][2], 1);
	PlayerTextDrawBoxColor(playerid, TRKA_PTD[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, TRKA_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, TRKA_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, TRKA_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, TRKA_PTD[playerid][2], 1);
	return true;
}


CMD:trkanje(playerid, params[])
{
	new fID = GetFactionIDbyName("Pink Panter");
	if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (fID != GetPlayerFactionID(playerid)) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici Pink Panter-a!"); 

	new id, ulog;
    if (sscanf(params, "ui", id,ulog))
        return Koristite(playerid, "trkanje [Ime ili ID igraca] [ulog]");
    
	if (ulog > 200000 || ulog < 10000) return ErrorMsg(playerid, "Ulog mora biti veci od $10.000 a manji od $200.000");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, id, 3.0) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (IsPlayerAFK(id))
        return ErrorMsg(playerid, "Igrac je AFK.");
        
	new igrac_vozila = 0;
	for__loop (new i = 0; i < PI[id][p_vozila_slotovi]; i++) 
		igrac_vozila++;
	
	if (igrac_vozila == 0) return ErrorMsg(playerid, "Igrac ne poseduje privatna vozila!");
	if (PI[id][p_novac] < ulog) return ErrorMsg(playerid, "Igrac nema dovoljno novca probajte smanjiti ulog!"); 
	
	new sDialog[512];
	format(sDialog, 30, "Slot\tVozilo\tModel\tTablice");

	new item = 0;
	for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
	{
		if (pVehicles[playerid][i] == 0) continue; // prazan slot
		
		new veh = pVehicles[playerid][i], color[7];
		if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
		else color = "FFFFFF";

		format(sDialog, sizeof sDialog, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", sDialog, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

		OwnedVehiclesDialog_AddItem(playerid, item++, i);
	}
	if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");
	SPD(playerid, "iza_bira_voz", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}IZABERITE VOZILO ZA TRKU", sDialog, "Odaberi", "Nazad");
	izazvaoIgraca[playerid] = id;
	trkaulog[playerid] = ulog;
	trkaulog[id] = ulog;
	return true;
}

Dialog:iza_bira_voz(playerid, response, listitem, const inputtext[] ) {
	if (!response) return ErrorMsg(playerid, "Odustali ste od trke!");
	if (izazvaoIgraca[playerid] == INVALID_PLAYER_ID) return false;
	new slot = OwnedVehiclesDialog_GetItem(playerid, listitem);
	new id = ((aveh[playerid]==-1)? pVehicles[playerid][slot] : aveh[playerid]);
	
	SetVehicleZAngle(OwnedVehicle[id][V_ID], 90.0);
	SetVehiclePos(OwnedVehicle[id][V_ID], 1542.6376, -1875.1387, 13.0442);
	SetVehicleZAngle(OwnedVehicle[id][V_ID], 90.0);
	SetVehicleHealth(OwnedVehicle[id][V_ID], 990);
	SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], 0);
	TogglePlayerControllable(playerid, false);
	InfoMsg(playerid, "Izabrali ste vozilo sada sacekajte da igrac izabere vozilo!");
	PutPlayerInVehicle(playerid, OwnedVehicle[id][V_ID], 0);
	DisableRemoteVehicleCollisions(playerid, 1); //iskljucujem mu coll jer ceka igraca dok ne krene trka
	
	new sDialog[512];
	format(sDialog, 30, "Slot\tVozilo\tModel\tTablice");

	new item = 0;
	for__loop (new i = 0; i < PI[izazvaoIgraca[playerid]][p_vozila_slotovi]; i++) 
	{
		if (pVehicles[izazvaoIgraca[playerid]][i] == 0) continue; // prazan slot
		
		new veh = pVehicles[izazvaoIgraca[playerid]][i], color[7];
		if (GetPlayerVehicleID(izazvaoIgraca[playerid]) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
		else color = "FFFFFF";

		format(sDialog, sizeof sDialog, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", sDialog, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

		OwnedVehiclesDialog_AddItem(izazvaoIgraca[playerid], item++, i);
	}	
	SPD(izazvaoIgraca[playerid], "prot_bira_voz", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}IZABERITE VOZILO ZA TRKU", sDialog, "Odaberi", "Nazad");
	protivnikovIzazivac[izazvaoIgraca[playerid]] = playerid;
	return true;
	
}
Dialog:prot_bira_voz(playerid, response, listitem, const inputtext[] ) {
	if (!response) return ErrorMsg(playerid, "Odustali ste od trke!");
	if (protivnikovIzazivac[playerid] == INVALID_PLAYER_ID) return false;
	new slot = OwnedVehiclesDialog_GetItem(playerid, listitem);
	new id = ((aveh[playerid]==-1)? pVehicles[playerid][slot] : aveh[playerid]);
	
	SetVehicleZAngle(OwnedVehicle[id][V_ID], 90.0);
	SetVehiclePos(OwnedVehicle[id][V_ID], 1542.6215, -1869.8722, 13.0442);
	SetVehicleZAngle(OwnedVehicle[id][V_ID], 90.0);
	SetVehicleHealth(OwnedVehicle[id][V_ID], 990);
	SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], 0);
	TogglePlayerControllable(playerid, false);
	InfoMsg(playerid, "Izabrali ste vozilo sada sacekajte da krene trka!");
	InfoMsg(protivnikovIzazivac[playerid], "Igrac je izabrao vozilo sacekajte da krene trka!");
	PlayerMoneySub(playerid, trkaulog[playerid]);
	PlayerMoneySub(protivnikovIzazivac[playerid], trkaulog[protivnikovIzazivac[playerid]]);
	PutPlayerInVehicle(playerid, OwnedVehicle[id][V_ID], 0);
	DisableRemoteVehicleCollisions(playerid, 1); //iskljucujem mu coll jer ceka igraca dok ne krene trka
	

	new name1[24], name2[24], string[64];
	GetPlayerName(protivnikovIzazivac[playerid], name1, 24);
	GetPlayerName(playerid, name2, 24);
	format(string, sizeof(string), "%s vs %s~n~ulog: $%i~n~dobitak: $%i", name1, name2, trkaulog[protivnikovIzazivac[playerid]], trkaulog[protivnikovIzazivac[playerid]] * 2);
	PlayerTextDrawSetString(playerid, TRKA_PTD[playerid][2], string);
	PlayerTextDrawSetString(protivnikovIzazivac[playerid], TRKA_PTD[playerid][2], string);
	for (new i; i < 3; i++)
		PlayerTextDrawShow(playerid,TRKA_PTD[playerid][i]), PlayerTextDrawShow(protivnikovIzazivac[playerid],TRKA_PTD[playerid][i]);
	SetTimerEx("StartRaceFF", 10000, false, "ii", playerid, protivnikovIzazivac[playerid]);
	return true;
	
}
forward StartRaceFF(izazivac, protivnik);
public StartRaceFF(izazivac, protivnik) {

	for (new i; i < 3; i++)
		PlayerTextDrawHide(izazivac,TRKA_PTD[izazivac][i]), PlayerTextDrawHide(protivnik,TRKA_PTD[protivnik][i]);

	SetVehicleZAngle(GetPlayerVehicleID(izazivac), 90.0);
	SetVehicleZAngle(GetPlayerVehicleID(protivnik), 90.0);
	DisableRemoteVehicleCollisions(izazivac, 0); 
	DisableRemoteVehicleCollisions(protivnik, 0); 
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(izazivac), engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(GetPlayerVehicleID(izazivac), VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective); 
	GetVehicleParamsEx(GetPlayerVehicleID(protivnik), engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(GetPlayerVehicleID(protivnik), VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective); 
	TogglePlayerControllable(izazivac, true);
	TogglePlayerControllable(protivnik, true);
	GameTextForPlayer(izazivac, "~g~TRKA JE POCLA!!!~n~GO GO GO", 3000, 3);
	GameTextForPlayer(protivnik, "~g~TRKA JE POCLA!!!~n~GO GO GO", 3000, 3);
	
	SetPlayerRaceCheckpoint(izazivac, 2, 
	races_cp_pos[0][0], races_cp_pos[0][1], races_cp_pos[0][2], 
	races_cp_pos[1][0], races_cp_pos[1][1], races_cp_pos[1][2], 5.0);

	SetPlayerRaceCheckpoint(protivnik, 2, 
	races_cp_pos[0][0], races_cp_pos[0][1], races_cp_pos[0][2], 
	races_cp_pos[1][0], races_cp_pos[1][1], races_cp_pos[1][2], 5.0);
	return true;
}

hook OnPlayerEnterRaceCP(playerid)
{
	
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[0][0], races_cp_pos[0][1], races_cp_pos[0][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[1][0], races_cp_pos[1][1], races_cp_pos[1][2], 
		races_cp_pos[2][0], races_cp_pos[2][1], races_cp_pos[2][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[1][0], races_cp_pos[1][1], races_cp_pos[1][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[2][0], races_cp_pos[2][1], races_cp_pos[2][2], 
		races_cp_pos[3][0], races_cp_pos[3][1], races_cp_pos[3][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[2][0], races_cp_pos[2][1], races_cp_pos[2][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[3][0], races_cp_pos[3][1], races_cp_pos[3][2], 
		races_cp_pos[4][0], races_cp_pos[4][1], races_cp_pos[4][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[3][0], races_cp_pos[3][1], races_cp_pos[3][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[4][0], races_cp_pos[4][1], races_cp_pos[4][2], 
		races_cp_pos[5][0], races_cp_pos[5][1], races_cp_pos[5][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[4][0], races_cp_pos[4][1], races_cp_pos[4][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[5][0], races_cp_pos[5][1], races_cp_pos[5][2], 
		races_cp_pos[6][0], races_cp_pos[6][1], races_cp_pos[6][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[5][0], races_cp_pos[5][1], races_cp_pos[5][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[6][0], races_cp_pos[6][1], races_cp_pos[6][2], 
		races_cp_pos[7][0], races_cp_pos[7][1], races_cp_pos[7][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[6][0], races_cp_pos[6][1], races_cp_pos[6][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[7][0], races_cp_pos[7][1], races_cp_pos[7][2], 
		races_cp_pos[8][0], races_cp_pos[8][1], races_cp_pos[8][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[7][0], races_cp_pos[7][1], races_cp_pos[7][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[8][0], races_cp_pos[8][1], races_cp_pos[8][2], 
		races_cp_pos[9][0], races_cp_pos[9][1], races_cp_pos[9][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[8][0], races_cp_pos[8][1], races_cp_pos[8][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[9][0], races_cp_pos[9][1], races_cp_pos[9][2], 
		races_cp_pos[10][0], races_cp_pos[10][1], races_cp_pos[10][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[9][0], races_cp_pos[9][1], races_cp_pos[9][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[10][0], races_cp_pos[10][1], races_cp_pos[10][2], 
		races_cp_pos[11][0], races_cp_pos[11][1], races_cp_pos[11][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[10][0], races_cp_pos[10][1], races_cp_pos[10][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[11][0], races_cp_pos[11][1], races_cp_pos[11][2], 
		races_cp_pos[12][0], races_cp_pos[12][1], races_cp_pos[12][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[11][0], races_cp_pos[11][1], races_cp_pos[11][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[12][0], races_cp_pos[12][1], races_cp_pos[12][2], 
		races_cp_pos[13][0], races_cp_pos[13][1], races_cp_pos[13][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[12][0], races_cp_pos[12][1], races_cp_pos[12][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 2, 
		races_cp_pos[13][0], races_cp_pos[13][1], races_cp_pos[13][2], 
		races_cp_pos[14][0], races_cp_pos[14][1], races_cp_pos[14][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[13][0], races_cp_pos[13][1], races_cp_pos[13][2])) {
		DisablePlayerRaceCheckpoint(playerid);
		SetPlayerRaceCheckpoint(playerid, 1, 
		races_cp_pos[14][0], races_cp_pos[14][1], races_cp_pos[14][2], 
		races_cp_pos[14][0], races_cp_pos[14][1], races_cp_pos[14][2], 5.0);
	}
	if (IsPlayerInRangeOfPoint(playerid, 5.0, races_cp_pos[14][0], races_cp_pos[14][1], races_cp_pos[14][2])) {
		DisablePlayerRaceCheckpoint(protivnikovIzazivac[playerid]);
		DisablePlayerRaceCheckpoint(izazvaoIgraca[playerid]);
		DisablePlayerRaceCheckpoint(playerid);
		if (protivnikovIzazivac[playerid] != playerid)
			SendClientMessage(protivnikovIzazivac[playerid], -1, "Nazalost izgubili ste trku!");
		if (izazvaoIgraca[playerid] != playerid)
			SendClientMessage(izazvaoIgraca[playerid], -1, "Nazalost izgubili ste trku!");

		SendClientMessage(playerid, -1, "Cestitamo pobedili ste");
		new iznos = trkaulog[playerid] * 2;		
		PlayerMoneyAdd(playerid, iznos);
		new string[128];
		format(string, sizeof(string), "Trka zavrsena: Zaradili ste $%d", iznos);
		SendClientMessage(playerid, 0x33CCFFFF, string);			
	}
	return true;
}