#include <YSI_Coding\y_hooks>

ptdCenterProgress_Create(playerid, const title[])
{
	PlayerTD[playerid][ptdCenterProgress][0] = CreatePlayerTextDraw(playerid, 224.238555, 228.500015, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdCenterProgress][0], 179.000000, 27.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdCenterProgress][0], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][0], 180);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdCenterProgress][0], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdCenterProgress][0], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdCenterProgress][0], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdCenterProgress][0], 0);

	PlayerTD[playerid][ptdCenterProgress][1] = CreatePlayerTextDraw(playerid, 226.581161, 231.416687, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdCenterProgress][1], 1.000000, 21.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdCenterProgress][1], 1);
	// PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][1], 16711935);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][1], 0xFFBE5AFF);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdCenterProgress][1], 0);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdCenterProgress][1], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdCenterProgress][1], 4);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdCenterProgress][1], 0);

	PlayerTD[playerid][ptdCenterProgress][2] = CreatePlayerTextDraw(playerid, 316.237152, 230.833328, "0%");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdCenterProgress][2], 0.394846, 2.113334);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdCenterProgress][2], 0.000000, -24.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdCenterProgress][2], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][2], -1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdCenterProgress][2], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdCenterProgress][2], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdCenterProgress][2], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdCenterProgress][2], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdCenterProgress][2], 1);

	PlayerTD[playerid][ptdCenterProgress][3] = CreatePlayerTextDraw(playerid, 316.000000, 215.000000, title);
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdCenterProgress][3], 0.270688, 1.349168);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdCenterProgress][3], 0.139999, 179.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdCenterProgress][3], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][3], -1);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdCenterProgress][3], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdCenterProgress][3], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdCenterProgress][3], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdCenterProgress][3], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdCenterProgress][3], 1);
}

ptdCenterProgress_Destroy(playerid)
{
	for (new i = 0; i < PTD_SIZE_CENTERPROGRESS; i++)
	{
		PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdCenterProgress][i]);
        PlayerTD[playerid][ptdCenterProgress][i] = PlayerText:INVALID_TEXT_DRAW;
	}
}

ptdCenterProgress_Show(playerid)
{
	for (new i = 0; i < PTD_SIZE_CENTERPROGRESS; i++)
	{
		PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdCenterProgress][i]);
	}
}

ptdCenterProgress_Update(playerid, percentage)
{
	new str[5];
	format(str, sizeof str, "%i%%", percentage);

	/*
		https://stackoverflow.com/a/21835797
		https://stackoverflow.com/a/4801397
	*/

	new 
		red = floatround(((0x00 - 0xFF) / 100.0) * percentage) + 0xFF,
		green = floatround(((0xFF - 0xBE) / 100.0) * percentage) + 0xBE,
		blue = floatround(((0x5A - 0x5A) / 100.0) * percentage) + 0x5A,
		rgb = (((((red << 8) + green) << 8) + blue) << 8) + 0xFF;


	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdCenterProgress][2], str);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdCenterProgress][1], 1.0+(percentage*1.73), 21.000000);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdCenterProgress][1], rgb);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdCenterProgress][1]);
	PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdCenterProgress][2]);
}

static tmrCenterProgress[MAX_PLAYERS],
		gCenterProgress[MAX_PLAYERS char];

StartCenterProgress(playerid, const title[], durationMs)
{
	if (tmrCenterProgress[playerid])
	{
		KillTimer(tmrCenterProgress[playerid]);
		ptdCenterProgress_Destroy(playerid);
	}

	ptdCenterProgress_Create(playerid, title);
	ptdCenterProgress_Show(playerid);

	gCenterProgress{playerid} = 0;
	tmrCenterProgress[playerid] = SetTimerEx("UpdateCenterProgress", floatround(durationMs/100.0), true, "i", playerid);
	TogglePlayerControllable_H(playerid, false);

	return 1;
}

forward OnProgressFinish(playerid);
public OnProgressFinish(playerid)
{
	return 1;
}

forward UpdateCenterProgress(playerid);
public UpdateCenterProgress(playerid)
{
	if (!IsPlayerConnected(playerid))
	{
		KillTimer(tmrCenterProgress[playerid]);
		return 1;
	}

	gCenterProgress{playerid} ++;
	if (gCenterProgress{playerid} == 101)
	{
        // Kraj
		KillTimer(tmrCenterProgress[playerid]);
		ptdCenterProgress_Destroy(playerid);
		TogglePlayerControllable_H(playerid, true);
		gCenterProgress{playerid} = 0;

		CallRemoteFunction("OnProgressFinish", "i", playerid);
	}
	else
	{
		ptdCenterProgress_Update(playerid, gCenterProgress{playerid});

		if (gCenterProgress{playerid} == 100)
        {
            KillTimer(tmrCenterProgress[playerid]);
            tmrCenterProgress[playerid] = SetTimerEx("UpdateCenterProgress", 4000, false, "i", playerid); // % ce biti 101
            PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
        }
	}

	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (tmrCenterProgress[playerid])
	{
		KillTimer(tmrCenterProgress[playerid]);
		// ptdCenterProgress_Destroy(playerid);
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (tmrCenterProgress[playerid])
	{
		KillTimer(tmrCenterProgress[playerid]);
		ptdCenterProgress_Destroy(playerid);
	}
}