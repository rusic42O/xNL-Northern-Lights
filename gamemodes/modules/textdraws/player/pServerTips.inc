#include <YSI_Coding\y_hooks>

new tmrServerTipHide[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	tmrServerTipHide[playerid] = 0;

	PlayerTD[playerid][ptdServerTips][0] = CreatePlayerTextDraw(playerid, 9.531476, 198.683319, "LD_BEAT:CHIT");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][0], 32.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][0], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][0], 255);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][0], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][0], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][0], 0);

	PlayerTD[playerid][ptdServerTips][1] = CreatePlayerTextDraw(playerid, 109.531478, 198.683319, "LD_BEAT:CHIT");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][1], 32.000000, 30.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][1], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][1], 255);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][1], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][1], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][1], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][1], 0);

	PlayerTD[playerid][ptdServerTips][2] = CreatePlayerTextDraw(playerid, 25.898605, 203.749786, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][2], 98.000000, 19.659992);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][2], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][2], 255);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][2], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][2], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][2], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][2], 0);

	PlayerTD[playerid][ptdServerTips][3] = CreatePlayerTextDraw(playerid, 14.846714, 213.266677, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][3], 121.35, 45.0); // visina 45.0 je osnova za 2 linije teksta
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][3], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][3], 225);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][3], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][3], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][3], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][3], 0);

	PlayerTD[playerid][ptdServerTips][4] = CreatePlayerTextDraw(playerid, 36.766189, 250.316528, "particle:lamp_shad_64");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][4], 77.000000, -47.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][4], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][4], 7448114);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][4], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][4], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][4], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][4], 0);

	PlayerTD[playerid][ptdServerTips][5] = CreatePlayerTextDraw(playerid, 75.328483, 206.283340, "_"); // Naslov
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdServerTips][5], 0.246793, 1.471667);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][5], 0.000000, 117.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][5], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][5], -1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][5], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][5], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][5], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][5], 1);

	PlayerTD[playerid][ptdServerTips][6] = CreatePlayerTextDraw(playerid, 22.005867, 229.600021, "_"); // Poruka
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdServerTips][6], 0.168081, 1.028331);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][6], 134.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdServerTips][6], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdServerTips][6], -1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdServerTips][6], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdServerTips][6], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdServerTips][6], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdServerTips][6], 1);
	return true;
}

ptdServerTips_ShowMsg(playerid, const title[], const msg[], lines, durationMs = 0)
{
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdServerTips][5], title);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdServerTips][6], msg);

	new Float:sizeY = 45.0;
	if (lines > 2) sizeY += (lines-2)*8.0; // dodatak 8.0 za svaku liniju posle druge
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdServerTips][3], 121.35, sizeY);

	for (new i = 0; i < 7; i++)
	{
		PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdServerTips][i]);
	}

	if (durationMs)
	{
		tmrServerTipHide[playerid] = SetTimerEx("ptdServerTips_HideMsg", durationMs, false, "i", playerid);
	}
}

forward ptdServerTips_HideMsg(playerid);
public ptdServerTips_HideMsg(playerid)
{
	KillTimer(tmrServerTipHide[playerid]);

	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdServerTips][5], "_");
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdServerTips][6], "_");
	for (new i = 0; i < 7; i++)
	{
		PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdServerTips][i]);
	}
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	KillTimer(tmrServerTipHide[playerid]);
	for (new i = 0; i < 7; i++)
	{
		PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdServerTips][i]);
	}
	return true;
}