
#include <YSI_Coding\y_hooks>

new bool:g_JoinedDM[MAX_PLAYERS],
	g_PlayerKills[MAX_PLAYERS],
	g_PlayerAssists[MAX_PLAYERS],
	g_PlayerDeaths[MAX_PLAYERS],
	Text3D:TopLabels[5],

	TopPlayers[5][MAX_PLAYER_NAME + 1],
	TopPlayersScore[5][15],
	Float:TopPlayersRatio[5],

	UpdateTimer
;

new PlayerText:DM_PTD[MAX_PLAYERS][6];

new Float:labelPos[5][3] =
{
	{ 1378.7219,-1115.5636,24.4141 },
	{ 1378.7219,-1114.4268,24.4141 },
	{ 1378.7219,-1116.6841,24.4141 },
	{ 1378.7219,-1113.2673,24.4141 },
	{ 1378.7219,-1117.9269,24.4141 }
};

new Float:randomDMPositions[8][3] = 
{
	{ 2540.6692,2251.0627,948.0277 },
	{ 2526.6021,2263.3491,948.0277 },
	{ 2510.5972,2256.6243,950.6973 },
	{ 2540.1174,2222.8950,947.8121 },
	{ 2538.4197,2170.2776,947.8140 },
	{ 2563.0229,2230.2612,948.0277 },
	{ 2559.2136,2266.0991,948.0277 },
	{ 2494.6833,2261.8025,948.0277 }
};

hook OnGameModeInit()
{
	CreateDynamic3DTextLabel("/dmarena\n{FFFFFF}DM Arena 0-24", 0xfcf003FF, 1382.1494,-1088.7529,28.2129, 10.0);
	CreateDynamic3DTextLabel("[DM TOP-5]\n{FFFFFF}Top lista se azurira svaki dan u 00:00", 0xfcf003FF, 1372.8463,-1115.5515,24.4141, 10.0);

	mysql_tquery(SQL, "SELECT ime,dmstats FROM igraci WHERE dmstats != '0|0|0'", "mysql_load_top");
	return 1;
}

forward mysql_load_top();
public mysql_load_top()
{
	cache_get_row_count(rows);
	printf("Azuriranje top 5 liste za DM Arenu, rows = %i", rows);	

	static enum E_LIST_TOP
    {
        E_LIST_TOP_NAME[MAX_PLAYER_NAME + 1],
        Float:E_LIST_TOP_AVERAGE,
		E_LIST_TOP_SCORE[15],
    }
    new topplayers[1000][E_LIST_TOP];

	new
		kills,
		assists,
		deaths,
		//Float:ka,
		str[55],
		Float:aa,
		aname[MAX_PLAYER_NAME+1],
		//Float:deathfl,
		ascore[15];

    for(new i = 0; i < rows; i++)
	{
		if(rows == 1000)
			break;
		
		cache_get_value_index(i, 0, topplayers[i][E_LIST_TOP_NAME], MAX_PLAYER_NAME + 1);
		cache_get_value_index(i, 1, topplayers[i][E_LIST_TOP_SCORE], 15);

		sscanf(topplayers[i][E_LIST_TOP_SCORE], "p<|>iii", kills, assists, deaths);
		//ka = float(g_PlayerKills[i]) + float(g_PlayerAssists[i]);
		//deathfl = float(g_PlayerDeaths[i]);
		//topplayers[i][E_LIST_TOP_AVERAGE] = ka - float(deaths);
		topplayers[i][E_LIST_TOP_AVERAGE] = (deaths != 0) ? ((float(kills) + float(assists))/float(deaths)) : (float(kills) + float(assists));
	}
    
    //SortDeepArray(topplayers, E_LIST_TOP_AVERAGE, .order = SORT_DESC);

	for (new i = 0; i < rows; ++i) 
    {
        for (new j = i + 1; j < rows; ++j)
        {
            if (topplayers[i][E_LIST_TOP_AVERAGE] < topplayers[j][E_LIST_TOP_AVERAGE]) 
            {
                aa = topplayers[i][E_LIST_TOP_AVERAGE];
				format(aname, sizeof aname, "%s", topplayers[i][E_LIST_TOP_NAME]);
				format(ascore, sizeof ascore, "%s", topplayers[i][E_LIST_TOP_SCORE]);

                topplayers[i][E_LIST_TOP_AVERAGE] = topplayers[j][E_LIST_TOP_AVERAGE];
				format(topplayers[i][E_LIST_TOP_NAME], sizeof aname, "%s", topplayers[j][E_LIST_TOP_NAME]);
				format(topplayers[i][E_LIST_TOP_SCORE], sizeof ascore, "%s", topplayers[j][E_LIST_TOP_SCORE]);
				
				topplayers[j][E_LIST_TOP_AVERAGE] = aa;
				format(topplayers[j][E_LIST_TOP_NAME], sizeof aname, "%s", aname);
				format(topplayers[j][E_LIST_TOP_SCORE], sizeof ascore, "%s", ascore);
            }
        }
    }

	for(new j = 0; j < 5; j++)
	{
		if(IsValidDynamic3DTextLabel(TopLabels[j]))
			DestroyDynamic3DTextLabel(TopLabels[j]);
		format(str, sizeof str, "[%s]\n{FFFFFF}(k | a | d) ratio: %f", topplayers[j][E_LIST_TOP_NAME], topplayers[j][E_LIST_TOP_AVERAGE]);
		TopLabels[j] = CreateDynamic3DTextLabel(str, 0xfcf003FF, labelPos[j][0], labelPos[j][1], labelPos[j][2], 10.0);
		format(TopPlayers[j], MAX_PLAYER_NAME, "%s", topplayers[j][E_LIST_TOP_NAME]);
		TopPlayersRatio[j] = topplayers[j][E_LIST_TOP_AVERAGE];
		format(TopPlayersScore[j], 15, "%s", topplayers[j][E_LIST_TOP_SCORE]);
	}

	new h, m, s, timerInterval;
    gettime(h, m, s);
    timerInterval = (24-h)*3600 + (60-m)*60;

	UpdateTimer = SetTimer("UpdateDMTop", timerInterval*1000, false);

	return true;
}

flags:fudm(FLAG_ADMIN_6)
CMD:fudm(playerid)
{
	KillTimer(UpdateTimer);
	UpdateTimer = SetTimer("UpdateDMTop", 1*1000, false);
	InfoMsg(playerid, "Top lista DM Arene ce se azurirati za sekund.");
	return 1;
}

forward UpdateDMTop();
public UpdateDMTop()
{
	SendClientMessageFToAll(ZUTA, "(DM Arena) {FFFFFF}Lista top 5 igraca na DM Areni je azurirana, /dmstats.");
	mysql_tquery(SQL, "SELECT ime,dmstats FROM igraci WHERE dmstats != '0|0|0'", "mysql_load_top");
	return 1;
}

hook OnPlayerConnect(playerid)
{
	g_JoinedDM[playerid] = false;
	g_PlayerKills[playerid] =
	g_PlayerAssists[playerid] =
	g_PlayerDeaths[playerid] = 0;

	for(new i = 0; i < 6; i++)
	{
		PlayerTextDrawDestroy(playerid, DM_PTD[playerid][i]);
		DM_PTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
	}
	
	return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	DMTDControl(playerid, false);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(g_JoinedDM[playerid] == true)
        SetPVarInt(playerid, "pIgnoreDeathFine", 1);
	
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if( g_JoinedDM[playerid] == true )
	{
		//new rPlayerWar = random(11);
		new rPlayerWar = random( sizeof( randomDMPositions ) );
		
		SetPlayerCompensatedPos(playerid, randomDMPositions[rPlayerWar][0], randomDMPositions[rPlayerWar][1], randomDMPositions[rPlayerWar][2]+0.5, 135, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 100);
		GivePlayerWeapon(playerid, 29, 1000);
		GivePlayerWeapon(playerid, 31, 1000);

		SetTimerEx("HealthP", 300, false, "i", playerid);

		for__loop (new i; i < 4; i++)
		{
			TextDrawHideForPlayer(playerid, tdDeathScreen[i]);
		}
	}
	return 1;
}

forward HealthP(playerid);
public HealthP(playerid)
{
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	return 1;
}

stock IsPlayerInDMArena(playerid)
{
	if (!IsPlayerConnected(playerid)) return false;
	if(g_JoinedDM[playerid] == true )
		return 1;
	
	return 0;
}

stock UpdateDMStats(playerid)
{
	new
		str[15]
	;
	format(str, sizeof str, "%i|%i|%i", g_PlayerKills[playerid], g_PlayerAssists[playerid], g_PlayerDeaths[playerid]);
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dmstats='%s' WHERE id=%d", str, PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
	return 1;
}

SetDMStats(playerid, const str[])
{
	sscanf(str, "p<|>iii", g_PlayerKills[playerid], g_PlayerAssists[playerid], g_PlayerDeaths[playerid]);
}

stock DMTDControl(playerid, bool:tdstate)
{
	new
		str[15]
	;
	if(tdstate)
	{
		DM_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 433.649719, -18.767793, "");
		PlayerTextDrawLetterSize(playerid, DM_PTD[playerid][0], -0.118999, -0.376249);
		PlayerTextDrawTextSize(playerid, DM_PTD[playerid][0], 78.000000, 95.000000);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][0], 255);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][0], 0);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][0], 5);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][0], 0);
		PlayerTextDrawSetPreviewModel(playerid, DM_PTD[playerid][0], 1317);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][0], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, DM_PTD[playerid][0], 100.000000, 0.000000, 90.000000, 1.399999);

		DM_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 430.766845, -23.337800, "");
		PlayerTextDrawLetterSize(playerid, DM_PTD[playerid][1], -0.118999, -0.376249);
		PlayerTextDrawTextSize(playerid, DM_PTD[playerid][1], 84.000000, 105.000000);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][1], 1);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][1], 255);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][1], 0);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][1], 5);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][1], 0);
		PlayerTextDrawSetPreviewModel(playerid, DM_PTD[playerid][1], 1317);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][1], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, DM_PTD[playerid][1], -80.000000, 0.000000, 90.000000, 1.600000);

		format(str, 15, "%i/%i/%i", g_PlayerKills[playerid], g_PlayerAssists[playerid], g_PlayerDeaths[playerid]);

		DM_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 472.799987, 44.825012, str);
		PlayerTextDrawLetterSize(playerid, DM_PTD[playerid][2], 0.206999, 0.838749);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][2], 2);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][2], -1);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][2], 0);
		PlayerTextDrawSetOutline(playerid, DM_PTD[playerid][2], 1);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][2], 255);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][2], 3);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][2], 1);

		DM_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 458.599884, 35.412528, "particle:bloodpool_64");
		PlayerTextDrawTextSize(playerid, DM_PTD[playerid][3], 28.000000, 28.000000);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][3], 1);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][3], 255);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][3], 255);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][3], 4);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][3], 0x00000000);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][3], 0);

		DM_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 460.600036, 37.350006, "particle:bloodpool_64");
		PlayerTextDrawTextSize(playerid, DM_PTD[playerid][4], 24.000000, 24.000000);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][4], 1);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][4], -1);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][4], 255);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][4], 4);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][4], 0x00000000);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][4], 0);

		DM_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 455.200012, 27.062494, "particle:lamp_shad_64");
		PlayerTextDrawTextSize(playerid, DM_PTD[playerid][5], 32.000000, 22.000000);
		PlayerTextDrawAlignment(playerid, DM_PTD[playerid][5], 1);
		PlayerTextDrawColor(playerid, DM_PTD[playerid][5], -188);
		PlayerTextDrawSetShadow(playerid, DM_PTD[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][5], 255);
		PlayerTextDrawFont(playerid, DM_PTD[playerid][5], 4);
		PlayerTextDrawBackgroundColor(playerid, DM_PTD[playerid][5], 0x00000000);
		PlayerTextDrawSetProportional(playerid, DM_PTD[playerid][5], 0);
	}

	for(new i = 0; i < 6; i++)
	{
		if(tdstate)
		{
			PlayerTextDrawShow(playerid, DM_PTD[playerid][i]);
		}
		else
		{
			PlayerTextDrawDestroy(playerid, DM_PTD[playerid][i]);
			DM_PTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}

	return true;
}

stock UpdatePlayerRatio(playerid)
{
	new
		str[15]
	;
	format(str, 15, "%d/%d/%d", g_PlayerKills[playerid], g_PlayerAssists[playerid], g_PlayerDeaths[playerid]);

	PlayerTextDrawSetString(playerid, DM_PTD[playerid][2], str);
	PlayerTextDrawHide(playerid, DM_PTD[playerid][2]);
	PlayerTextDrawShow(playerid, DM_PTD[playerid][2]);
	UpdateDMStats(playerid);
	return true;
}

CMD:dmstats(playerid)
{
	new
		str[700],
		kills[5],
		deaths[5],
		assists[5]
	;
	
	for(new j = 0; j < 5; j++)
		sscanf(TopPlayersScore[j], "p<|>iii", kills[j], assists[j], deaths[j]);
	
	format(str, sizeof str, "{ECDE00}TOP 5 {FFFFFF}po score-u u DM Areni:  {DDDDDD}(k | a | d)\n\n{FFFF11}1. %s {FFFFFF}(%i | %i | %i) (ratio %f)\n{FFFF33}2. %s {EEEEFF}(%i | %i | %i) (ratio %f)\n{FFFF55}3. %s {DDDDDD}(%i | %i | %i) (ratio %f)\n{FFFF77}4. %s {BBBBBB}(%i | %i | %i) (ratio %f)\n{FFFF99}5. %s {AAAAAA}(%i | %i | %i) (ratio %f)\n\n{FFFFFF}Tvoja statistika u DM Areni:\n\nKills: {ECDE00}%i\n{FFFFFF}Assists: {ECDE00}%i\n{FFFFFF}Deaths: {ECDE00}%i\n\t\t\t\tTvoj ratio: {FFFFFF}%f", 
		TopPlayers[0], kills[0], assists[0], deaths[0], TopPlayersRatio[0],
			TopPlayers[1], kills[1], assists[1], deaths[1], TopPlayersRatio[1],
				TopPlayers[2], kills[2], assists[2], deaths[2], TopPlayersRatio[2],
					TopPlayers[3], kills[3], assists[3], deaths[3], TopPlayersRatio[3],
						TopPlayers[4], kills[4], assists[4], deaths[4], TopPlayersRatio[4],
							g_PlayerKills[playerid], g_PlayerAssists[playerid], g_PlayerDeaths[playerid], (g_PlayerDeaths[playerid] != 0) ? floatdiv(float(g_PlayerKills[playerid]) + float(g_PlayerAssists[playerid]), float(g_PlayerDeaths[playerid])) : (float(g_PlayerKills[playerid]) + float(g_PlayerAssists[playerid]))
	); //(g_PlayerDeaths[playerid] != 0) ? floatdiv(float(g_PlayerKills[playerid]) + float(g_PlayerAssists[playerid]), float(g_PlayerDeaths[playerid])) : (float(g_PlayerKills[playerid]) + float(g_PlayerAssists[playerid]))
	SPD(playerid, "DMStats", DIALOG_STYLE_MSGBOX, "{FFFFFF}DM Arena // {ECDE00}statistics...", str, "Ok", "");
	return true;
}

CMD:dmarena(playerid)
{

 	if(g_JoinedDM[playerid]) return ErrorMsg(playerid, "Vec se nalazis u DM areni!");
	
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, 1382.1494,-1088.7529,28.2129))
		return ErrorMsg(playerid, "Ne nalazite se u blizini DM arene.");
	 
    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici u DM Arenu!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli u DM Arenu!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici u DM Arenu dok pljackate zlataru!");

    if (IsPlayerRobbingBank(playerid))
        return ErrorMsg(playerid, "Ne mozete ici u DM Arenu dok pljackate banku!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete uci u DM Arenu jer ste zavezani ili uhapseni.");

    //new rPlayerWar = random(11);
	new rPlayerWar = random( sizeof( randomDMPositions ) );

	ResetPlayerWeapons(playerid);
    SetPlayerCompensatedPos(playerid, randomDMPositions[rPlayerWar][0], randomDMPositions[rPlayerWar][1], randomDMPositions[rPlayerWar][2]+0.5, 135, 0);
 	InfoMsg(playerid, "Usli ste u DM arenu, napustite je komandom /leave.");
 	g_JoinedDM[playerid] = true;

	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);

	DMTDControl(playerid, true);

	GivePlayerWeapon(playerid, 24, 100);
    GivePlayerWeapon(playerid, 29, 999);
    GivePlayerWeapon(playerid, 31, 999);
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 100.0);
	ShowMainGuiTD(playerid, false); //Hide
	return 1;
}

CMD:leave(playerid)
{
    if(g_JoinedDM[playerid] == true )
    {
		ResetPlayerWeapons(playerid);
		SetPlayerArmour(playerid, 0.0);
		SetPlayerHealth(playerid, 150.0);
		DMTDControl(playerid, false);
        SetPlayerCompensatedPos(playerid, 1382.1494,-1088.7529,28.2129);
		SetPlayerVirtualWorld(playerid, 0);
        g_JoinedDM[playerid] = false;
		ShowMainGuiTD(playerid, true);//Show
    }
    else
        return ErrorMsg(playerid, "Nisi u DM areni.");
	return 1;
}