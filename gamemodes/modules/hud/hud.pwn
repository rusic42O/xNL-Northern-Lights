#include <YSI_Coding\y_hooks>
new bool:main_gui_created[MAX_PLAYERS],
	bool:TD_SpeedometerShown[MAX_PLAYERS];

new PlayerText:GUI_PTD[MAX_PLAYERS][42];

new RandomMSG[][] =
{
    "Ukoliko primetite citera ~r~prijavite ga.",
    "Igrate na ~b~Northern Lights~w~ samp serveru.",
    "Posetite nas forum ~p~nlsamp.com/forum/",
	"~w~Vlasnici servera su ~b~Bozic & DomT~w~, a skripter ~r~z1ann.",
	"Trenutna verzija moda je ~y~5.0"
};
hook OnGameModeInit() {
	SetTimer("RandomMessagesTD", 60000, true);
	return true;
}
hook OnPlayerConnect(playerid) {
	TD_SpeedometerShown[playerid] = 
	main_gui_created[playerid] = false;
	CreateMainGuiTD(playerid, true);
	return true;
}
hook OnPlayerDisconnect(playerid, reason) {
	CreateMainGuiTD(playerid, false);
	return true;
}
/*
HOOK_SetPlayerSkin(playerid, skinid)
{	
	PlayerTextDrawSetPreviewModel(playerid, main_gui_player[playerid][2], GetPlayerCorrectSkin(playerid));
	PlayerTextDrawShow(playerid, main_gui_player[playerid][2]);
	return SetPlayerSkin(playerid, skinid);
}
#if defined _ALS_SetPlayerSkin
		#undef SetPlayerSkin
#else
		#define _ALS_SetPlayerSkin
#endif
#define SetPlayerSkin HOOK_SetPlayerSkin
*/

forward RandomMessagesTD();
public RandomMessagesTD() {
	new randMSG = random(sizeof(RandomMSG)); 
	foreach (new i : Player) {
		if (main_gui_created[i]) {
			PlayerTextDrawSetString(i, GUI_PTD[i][10], RandomMSG[randMSG]);
			PlayerTextDrawShow(i, GUI_PTD[i][10]);
		}
	}
	return true;
}

ShowMainGuiTD(playerid, bool:show) {
	if (!IsPlayerConnected(playerid)) return false;
	if (main_gui_created[playerid]) {
		if (show && pHudStatus{playerid}) {
			for (new i; i < 42; i++) {
				PlayerTextDrawShow(playerid, GUI_PTD[playerid][i]);
			}	
			//Checks
			if (!IsHappyJobSet()) {				
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][12]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][13]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][15]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][16]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][19]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][20]);
			} else {
				new jobname[64];
				GetJobName(GetHappyJob(), jobname, sizeof jobname);
				PlayerTextDrawSetString(playerid, GUI_PTD[playerid][20], jobname);
			}
			if (!HappyHours()) {
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][11]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][14]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][17]);
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][18]);
			}
			if (!IsPlayerInAnyVehicle(playerid))
				ShowSpeedometerTD(playerid, false);	
		} 
		else {
			for (new i; i < 42; i++) {
				PlayerTextDrawHide(playerid, GUI_PTD[playerid][i]);
			}
		}
	}
	else 
		SendClientMessage(playerid, -1, "Gui Error: Dogodila se greska nije vam moguce prikazati GUI! Probajte se reconnect!");
	return true;
}

UpdateHungerMainGui(playerid, hunger)
{
	#pragma unused playerid
	#pragma unused hunger
	return true;
}
hook OnPlayerDeath(playerid, killerid, reason)
{
	ShowMainGuiTD(playerid, false);
	return true;
}

hook OnPlayerSpawn(playerid) {
	if (!IsPlayerInWar(playerid) && !IsPlayerInDMArena(playerid)) 
		ShowMainGuiTD(playerid, true);
	else
		ShowMainGuiTD(playerid, false);
	return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_WASTED || newstate == PLAYER_STATE_SPECTATING || newstate == PLAYER_STATE_NONE)
    {
        ShowMainGuiTD(playerid, false);
    }
	if (newstate == PLAYER_STATE_DRIVER) {
		ShowSpeedometerTD(playerid, true);
	}
	if (newstate != PLAYER_STATE_DRIVER && oldstate == PLAYER_STATE_DRIVER) {
		ShowSpeedometerTD(playerid, false);
	}
	return true;
}

CreateMainGuiTD(playerid, bool: create) {
	if (create) {
		
		GUI_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 569.538818, -2.499989, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][0], 46.000000, 50.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][0], 219685239);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][0], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][0], 0);

		GUI_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 572.818603, 1.583341, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][1], 39.000000, 41.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][1], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][1], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][1], 0);

		GUI_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 583.294311, 14.999982, "/");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][2], 0.295051, 1.139165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][2], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][2], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][2], 1);

		GUI_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 587.979553, 14.999979, "/");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][3], 0.295051, 1.139165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][3], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][3], 1);

		GUI_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 590.790649, 18.499979, "/");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][4], 0.295051, 1.139165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][4], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][4], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][4], 1);

		GUI_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 590.322082, 21.999977, "-");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][5], 0.514787, 1.156666);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][5], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][5], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][5], 1);

		GUI_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 594.539062, 13.833332, "]");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][6], 0.179324, 0.666665);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][6], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][6], -1261572609);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][6], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][6], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][6], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][6], 1);

		GUI_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 208.308731, 419.833374, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][7], 21.000000, 24.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][7], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][7], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][7], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][7], 0);

		GUI_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 218.616363, 423.916656, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][8], 204.000000, 16.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][8], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][8], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][8], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][8], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][8], 0);

		GUI_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 413.521179, 419.833374, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][9], 21.000000, 24.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][9], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][9], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][9], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][9], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][9], 0);

		GUI_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 321.859954, 428.583343, "UCITAVANJE SERVER PORUKA...");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][10], 0.109516, 0.608331);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][10], 2);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][10], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][10], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][10], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][10], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][10], 1);

		GUI_PTD[playerid][11] = CreatePlayerTextDraw(playerid, -1.120056, 415.749938, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][11], 31.000000, 35.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][11], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][11], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][11], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][11], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][11], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][11], 0);

		GUI_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 23.243040, 415.749938, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][12], 31.000000, 35.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][12], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][12], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][12], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][12], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][12], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][12], 0);

		GUI_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 44.795028, 426.249969, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][13], 52.000000, 14.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][13], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][13], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][13], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][13], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][13], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][13], 0);

		GUI_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 1.222380, 417.500091, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][14], 27.000000, 31.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][14], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][14], -1523963137);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][14], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][14], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][14], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][14], 0);

		GUI_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 25.116960, 417.500091, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][15], 27.000000, 31.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][15], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][15], -5963521);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][15], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][15], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][15], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][15], 0);

		GUI_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 24.179901, 418.666656, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][16], 29.000000, 29.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][16], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][16], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][16], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][16], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][16], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][16], 0);

		GUI_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 0.285324, 418.666656, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][17], 29.000000, 29.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][17], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][17], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][17], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][17], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][17], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][17], 0);

		GUI_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 6.544689, 426.250122, "HH");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][18], 0.345182, 1.413331);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][18], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][18], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][18], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][18], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][18], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][18], 1);

		GUI_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 31.844829, 425.666778, "HJ");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][19], 0.345182, 1.413331);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][19], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][19], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][19], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][19], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][19], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][19], 1);

		GUI_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 48.243072, 429.750152, "UCITAVANJE HJ...");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][20], 0.157305, 0.754166);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][20], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][20], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][20], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][20], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][20], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][20], 1);

		GUI_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 431.793731, 409.916534, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][21], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][21], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][21], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][21], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][21], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][21], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][21], 0);

		GUI_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 440.227233, 413.416656, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][22], 60.000000, 14.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][22], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][22], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][22], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][22], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][22], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][22], 0);

		GUI_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 490.358581, 409.916473, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][23], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][23], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][23], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][23], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][23], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][23], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][23], 0);

		GUI_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 442.738311, 416.333404, "nivo:_?_glad:_?%%");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][24], 0.134816, 0.754166);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][24], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][24], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][24], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][24], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][24], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][24], 1);

		GUI_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 432.730804, 425.666534, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][25], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][25], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][25], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][25], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][25], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][25], 0);

		GUI_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 490.827117, 425.666595, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][26], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][26], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][26], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][26], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][26], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][26], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][26], 0);

		GUI_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 440.227233, 429.166717, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][27], 60.000000, 14.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][27], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][27], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][27], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][27], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][27], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][27], 0);

		GUI_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 440.864227, 432.666656, "pay:_?min_poeni:_?");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][28], 0.123103, 0.695833);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][28], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][28], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][28], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][28], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][28], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][28], 1);

		GUI_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 515.190917, 425.083160, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][29], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][29], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][29], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][29], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][29], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][29], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][29], 0);

		GUI_PTD[playerid][30] = CreatePlayerTextDraw(playerid, 524.561096, 428.583343, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][30], 78.000000, 14.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][30], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][30], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][30], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][30], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][30], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][30], 0);

		GUI_PTD[playerid][31] = CreatePlayerTextDraw(playerid, 594.371398, 425.083221, "ld_Beat:chit");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][31], 19.000000, 21.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][31], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][31], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][31], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][31], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][31], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][31], 0);

		GUI_PTD[playerid][32] = CreatePlayerTextDraw(playerid, 527.071960, 431.499908, "UCITAVANJE..");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][32], 0.171360, 0.777499);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][32], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][32], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][32], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][32], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][32], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][32], 1);

		GUI_PTD[playerid][33] = CreatePlayerTextDraw(playerid, 518.470520, 373.166748, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][33], 114.000000, 46.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][33], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][33], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][33], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][33], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][33], 4);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][33], 0);

		GUI_PTD[playerid][34] = CreatePlayerTextDraw(playerid, 508.631256, 363.250091, "");
		PlayerTextDrawTextSize(playerid, GUI_PTD[playerid][34], 62.000000, 75.000000);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][34], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][34], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][34], 0);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][34], 5);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][34], 0);
		PlayerTextDrawSetPreviewModel(playerid, GUI_PTD[playerid][34], 411);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][34], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, GUI_PTD[playerid][34], 0.000000, 0.000000, 0.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, GUI_PTD[playerid][34], 1, 1);

		GUI_PTD[playerid][35] = CreatePlayerTextDraw(playerid, 628.741271, 374.916564, "UCITAVANJE..");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][35], 0.161991, 0.783333);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][35], 3);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][35], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][35], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][35], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][35], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][35], 1);

		GUI_PTD[playerid][36] = CreatePlayerTextDraw(playerid, 558.931518, 393.000030, "0");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][36], 0.503073, 2.049165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][36], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][36], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][36], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][36], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][36], 3);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][36], 1);

		GUI_PTD[playerid][37] = CreatePlayerTextDraw(playerid, 593.601867, 395.916625, "km/h");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][37], 0.196660, 0.736666);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][37], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][37], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][37], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][37], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][37], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][37], 1);

		GUI_PTD[playerid][38] = CreatePlayerTextDraw(playerid, 520.981079, 374.916503, "UCITAVANJE..");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][38], 0.155431, 0.654999);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][38], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][38], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][38], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][38], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][38], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][38], 1);

		GUI_PTD[playerid][39] = CreatePlayerTextDraw(playerid, 426.339904, 415.750091, "~y~UCITAVANJE..~r~(???)");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][39], 0.131068, 0.829999);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][39], 3);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][39], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][39], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][39], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][39], 2);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][39], 1);

		GUI_PTD[playerid][40] = CreatePlayerTextDraw(playerid, 499.429138, 99.000015, "$00000000");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][40], 0.543835, 2.259165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][40], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][40], 219685375);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][40], 0);
		PlayerTextDrawSetOutline(playerid, GUI_PTD[playerid][40], 2);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][40], -1261572609);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][40], 3);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][40], 1);

		GUI_PTD[playerid][41] = CreatePlayerTextDraw(playerid, 586.105346, 14.999977, "\\");
		PlayerTextDrawLetterSize(playerid, GUI_PTD[playerid][41], 0.295051, 1.139165);
		PlayerTextDrawAlignment(playerid, GUI_PTD[playerid][41], 1);
		PlayerTextDrawColor(playerid, GUI_PTD[playerid][41], -1);
		PlayerTextDrawSetShadow(playerid, GUI_PTD[playerid][41], 0);
		PlayerTextDrawBackgroundColor(playerid, GUI_PTD[playerid][41], 255);
		PlayerTextDrawFont(playerid, GUI_PTD[playerid][41], 1);
		PlayerTextDrawSetProportional(playerid, GUI_PTD[playerid][41], 1);

		main_gui_created[playerid] = true;
		SetTimerEx("OnUpdatePlayerGui", 1000, false, "i", playerid);
	}
	else {
		for (new i; i < 42; i++) {
			PlayerTextDrawDestroy(playerid, GUI_PTD[playerid][i]);
			GUI_PTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
			main_gui_created[playerid] = false;
		}
	}
	return true;
}

forward OnUpdatePlayerGui(playerid);
public OnUpdatePlayerGui(playerid) {
	if (!IsPlayerConnected(playerid)) return false;
	if (main_gui_created[playerid]) {
		new name[24], namestr[64];
		GetPlayerName(playerid, name, 24);
		new country[16];
	
		if (strfind(PI[playerid][p_drzava], "Bosna i Hercegovina") != -1)
				format(country, sizeof(country), "BIH");
		if (strfind(PI[playerid][p_drzava], "Crna Gora") != -1)
				format(country, sizeof(country), "CG");
		if (strfind(PI[playerid][p_drzava], "Hrvatska") != -1)
				format(country, sizeof(country), "HRV");
		if (strfind(PI[playerid][p_drzava], "Makedonija") != -1)
				format(country, sizeof(country), "MKD");
		if (strfind(PI[playerid][p_drzava], "Srbija") != -1)
				format(country, sizeof(country), "SRB");
	
		format(namestr, sizeof(namestr), "~y~%s ~r~(%s)", name, country);
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][39], namestr);
		//Banka novac
		new arg[60];
		new amount = PI[playerid][p_banka];
		format(arg,sizeof(arg),"$%08d", amount); 
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][40], arg);

		//Nivo i glad
		new nivoglad[90];
		format(nivoglad, sizeof(nivoglad), "~w~Nivo: ~b~%i  ~w~Glad: ~b~%i%%",  PI[playerid][p_nivo], PI[playerid][p_glad]);
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][24], nivoglad);
		//Payday 
		new ppayday[90];
		format(ppayday, sizeof(ppayday), "~w~Payday: ~b~%i min", PAYDAY_GetTimeLeft(playerid) / 60);
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][28], ppayday);
		//Datum vreme
		new datumvreme[90];
		new hours, minutes, f, Year, Month, Day;
		getdate(Year, Month, Day);
		gettime(hours, minutes, f);
		#pragma unused f
		format(datumvreme, sizeof(datumvreme), "%02d/%02d/%d - %02d:%02d",  Day, Month, Year, hours, minutes);
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][32], datumvreme);
		//Update loop
		SetTimerEx("OnUpdatePlayerGui", 1000, false, "i", playerid);
	}
	return true;
}


ShowSpeedometerTD(playerid, bool:show) {
	
	if (show) {
		for (new i = 33; i < 39; i++)
			PlayerTextDrawShow(playerid, GUI_PTD[playerid][i]);
		TD_SpeedometerShown[playerid] = true;
		new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
		PlayerTextDrawSetPreviewModel(playerid, GUI_PTD[playerid][34], modelid);
		PlayerTextDrawShow(playerid, GUI_PTD[playerid][34]);
		PlayerTextDrawSetString(playerid, GUI_PTD[playerid][38], imena_vozila[modelid-400]);

		SetTimerEx("OnSpeedometerUpdate", 1000, false, "i", playerid);

	} else {  
		for (new i = 33; i < 39; i++)
			PlayerTextDrawHide(playerid, GUI_PTD[playerid][i]);
		TD_SpeedometerShown[playerid] = false;
	}
	return true;
}

forward OnSpeedometerUpdate(playerid);
public OnSpeedometerUpdate(playerid) {

	if (IsPlayerInAnyVehicle(playerid)) {
		if (IsVehicleFlipped(GetPlayerVehicleID(playerid))) 
		{
			new Float:z;
			GetVehicleZAngle(GetPlayerVehicleID(playerid), z);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), z);
		}
		if (TD_SpeedometerShown[playerid])
		{
			new speedstr[5], fuelstr[25];
			format(speedstr, sizeof(speedstr), "%i", GetPlayerSpeed(playerid));
			PlayerTextDrawSetString(playerid, GUI_PTD[playerid][36], speedstr);
			new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));
			format(fuelstr, sizeof(fuelstr), "Gorivo: %.02f L", GetVehicleFuel(GetPlayerVehicleID(playerid)));
			PlayerTextDrawSetString(playerid, GUI_PTD[playerid][35], fuelstr);
			if (modelid != 0)
				PlayerTextDrawSetString(playerid, GUI_PTD[playerid][38], imena_vozila[modelid-400]);
			else 
				PlayerTextDrawSetString(playerid, GUI_PTD[playerid][38], "Unknown");
			///PlayerTextDrawShow(playerid, main_gui[playerid][24]);
			//PlayerTextDrawShow(playerid, main_gui[playerid][26]);
			SetTimerEx("OnSpeedometerUpdate", 1000, false, "i", playerid);	
		}
	}
	return true;
}


//Boje
Dialog:tdcontrol(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;
    switch (listitem) {
        case 0:
        {
            if (pHudStatus{playerid})
            {
               pHudStatus{playerid} = false;
               ShowMainGuiTD(playerid, false);
            }
            else
            {
                pHudStatus{playerid} = true;
                ShowMainGuiTD(playerid, true);                
            }
            SendClientMessageF(playerid, BELA, "* TextDraw-ovi su %s.", (pHudStatus{playerid})?("{00FF00}ukljuceni"):("{FF0000}iskljuceni"));
        }
        case 1: {
            //   SendClientMessage(playerid, -1, "Stize uskoro!");
            SPD(playerid, "tdbojice1", DIALOG_STYLE_LIST, "Boja Textdrawova", webcolors, "Nastavi", "Nazad");
        }
        case 2: {
            ShowMainGuiTD(playerid, false);
            CreateMainGuiTD(playerid, false);
            CreateMainGuiTD(playerid, true);
            ShowMainGuiTD(playerid, true);
        }
    }
    return 1;
}
Dialog:tdbojice1(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return SPD(playerid, "tdcontrol", DIALOG_STYLE_LIST, "TD Control", "Prikazi/Sakrij TD-ove\nPromeni Boju\nDefault", "Nastavi", "Otkazi");
    new string[120];
    format(string, sizeof(string), "Izabrali ste {%06x}XXXXXX {ffffff}boju za textdrawove.", WebColorsRGBA[listitem] >>> 8);
    SendClientMessage(playerid, -1, string);

    //SVETLIJA BOJA:
    for (new i; i < 42; i++) {
        if (i == 1
			|| i ==7
			|| i ==8
			|| i ==9
			|| i ==11
			|| i ==12
			|| i ==13
			|| i ==16
			|| i ==17
			|| i ==21
			|| i ==22
			|| i ==23
			|| i ==25
			|| i ==26
			|| i ==27
			|| i ==29
			|| i ==30
			|| i ==31
			|| i ==33
			|| i ==40)
            PlayerTextDrawColor(playerid, GUI_PTD[playerid][i], WebColorsRGBA[listitem]);
    }  
	ShowMainGuiTD(playerid, true);
	if (IsPlayerInAnyVehicle(playerid))
		ShowSpeedometerTD(playerid, true);
	else 
		ShowSpeedometerTD(playerid, false);	
    return 1;
}
