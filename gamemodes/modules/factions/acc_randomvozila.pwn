#include <YSI_Coding\y_hooks>
static acc_vozilo;

new Float:pos_veh_random[][4] = {
	{1429.6886, 225.9274, 19.2478, 0.000},
	{338.7077, -341.7311, 10.0908, 0.000},
	{984.0619, -2142.6052, 12.9719, 0.00},
	{1776.0829, -2060.8694, 13.3113, 0.0},
	{2246.0747, -2641.2417, 13.8361, 0.0},
	{2770.3879, -2470.5037, 13.3920, 0.0},
	{2583.8147, -1646.2432, 2.1489, 0.00},
	{2596.7959, -1113.0549, 67.5101, 0.0},
	{2377.2610, -647.3283, 128.1032, 0.0}
};

static radivozilo_arrid;

enum enum_vehicle_model {
	veh_modelid,
	veh_zarada
};

new veh_models[][enum_vehicle_model] = {
	{410, 5000},
	{411, 85000},
	{415, 8000},
	{422, 4200},
	{426, 3000},
	{495, 55000}
};


hook OnGameModeInit() {
	acc_vozilo = INVALID_VEHICLE_ID;
	SetTimer("KreirajVoziloACC", 1800000, false);
	return true;
}

forward KreirajVoziloACC();
public KreirajVoziloACC() {

	if (acc_vozilo != INVALID_VEHICLE_ID) {
		DestroyVehicle(acc_vozilo);        
	}
	new posrand = random(8), 
		zona[64],
		modelrand = random(5), 
		rmodel = veh_models[modelrand][veh_modelid];

	acc_vozilo = CreateVehicle(rmodel, 
	pos_veh_random[posrand][0],
	pos_veh_random[posrand][1],
	pos_veh_random[posrand][2],
	0.0, -1, -1, 1000, false);
	radivozilo_arrid = modelrand;
	Get2DZoneByPosition(pos_veh_random[posrand][0], pos_veh_random[posrand][1], zona, 64);
	//new fID = GetFactionIDbyName("West End Gang");
	//if (fID != -1)
	for(new i = 1; i < MAX_FACTIONS; i++)
	{
		if(FACTIONS[i][f_vrsta] == FACTION_MAFIA)
			FactionMsg(i, "Vozilo marke %s nalazi se u okolini %s, pozurite da ga nadjete i zaradite novac!", GetVehicleModelName(rmodel), zona);	
	}
	
	SetTimer("KreirajVoziloACC", 1800000, false);
	return true;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (vehicleid == acc_vozilo && acc_vozilo != INVALID_VEHICLE_ID) {
		//new fID = GetFactionIDbyName("West End Gang");
		//if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovo vozilo!");
		if (GetPlayerFactionID(playerid) <= 0) {
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerCompensatedPos(playerid, x, y, z);
			return ErrorMsg(playerid, "Nazalost, u ovo vozilo mogu samo pripadnici ilegalnih organizacija"); //West End Gang-a!
		}
		SendClientMessage(playerid, -1, "Svaka cast! Pronasli ste vozilo sada ga brzo odvezite do garaze i zaradite novac!");
		
		/*
		IsPlayerInRangeOfPoint(playerid, 4.0, -719.3267,956.6565,12.1328,341.2969) ||
		IsPlayerInRangeOfPoint(playerid, 4.0, 922.4797,-2644.1094,41.9972,220.6625) ||
		IsPlayerInRangeOfPoint(playerid, 4.0, 2351.5667,27.2426,26.4844,358.9900) ||
		IsPlayerInRangeOfPoint(playerid, 4.0, 860.8377,-1068.9227,25.1016,89.9092)
		*/

		if(GetFactionIDbyName("Escobar Cartel") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, -719.3267,956.6565,12.1328, 5.0);
		else if(GetFactionIDbyName("West End Gang") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 922.4797,-2644.1094,41.9972, 5.0);
		else if(GetFactionIDbyName("La Casa De Papel") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 2351.5667,27.2426,26.4844, 5.0);
		else if(GetFactionIDbyName("Pink Panter") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 860.8377,-1068.9227,25.1016, 5.0);
		else if(GetFactionIDbyName("American Mafia") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 976.7514,-1949.1141,12.6541, 5.0);
		else if(GetFactionIDbyName("La Cosa Nostra") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 1087.1947, -1999.9484, 48.9232, 5.0);
		else if(GetFactionIDbyName("Solntsevskaya Bratva") == GetPlayerFactionID(playerid))
			SetPlayerCheckpoint(playerid, 1298.4980, -798.9592, 84.1406, 5.0);
	}
	return true;
}

hook OnPlayerEnterCheckpoint(playerid)
{
	if (GetPlayerVehicleID(playerid) == acc_vozilo && acc_vozilo != INVALID_VEHICLE_ID)
	{
		DisablePlayerCheckpoint(playerid);
		SetVehicleToRespawn(acc_vozilo);
		DestroyVehicle(acc_vozilo); acc_vozilo = INVALID_VEHICLE_ID;
		PlayerMoneyAdd(playerid, veh_models[radivozilo_arrid][veh_zarada]);
		new string[128];
		format(string, sizeof(string), "Zaradili ste $%d", veh_models[radivozilo_arrid][veh_zarada]);
		SendClientMessage(playerid, 0x33CCFFFF, string);
		radivozilo_arrid = -1;
	}
	
	return true;
}