ptdFactionSafe_Create(playerid)
{	
	PlayerTD[playerid][ptdFactionSafe][0] = CreatePlayerTextDraw(playerid, 203.811614, 242.917297, "~N~~N~~N~~N~~N~~N~$ ~W~-");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][0], 0.236486, 1.243332);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][0], 90.000000, 64.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][0], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][0], 1347440895);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][0], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][0], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][0], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][0], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][0], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][0], true);

	PlayerTD[playerid][ptdFactionSafe][1] = CreatePlayerTextDraw(playerid, 281.231506, 242.917297, "~N~~N~~N~~N~~N~~N~- ~W~mats");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][1], 0.236486, 1.243332);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][1], 90.000000, 64.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][1], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][1], 1347440895);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][1], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][1], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][1], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][1], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][1], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][1], true);

	PlayerTD[playerid][ptdFactionSafe][2] = CreatePlayerTextDraw(playerid, 358.731506, 242.917297, "~N~~N~~N~~N~~N~~N~-g ~W~heroin");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][2], 0.236486, 1.203333);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][2], 90.000000, 64.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][2], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][2], 1347440895);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][2], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][2], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][2], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][2], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][2], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][2], true);

	PlayerTD[playerid][ptdFactionSafe][3] = CreatePlayerTextDraw(playerid, 358.731506, 254.666595, "~N~~N~~N~~N~~N~~N~-g ~W~mdma");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][3], 0.236486, 1.203333);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][3], 90.000000, 64.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][3], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][3], 1347440895);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][3], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][3], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][3], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][3], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][3], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][3], false);

	PlayerTD[playerid][ptdFactionSafe][4] = CreatePlayerTextDraw(playerid, 436.231506, 242.917297, "~N~~N~~N~~N~~N~~N~-g ~W~weed");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][4], 0.236486, 1.203333);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][4], 90.000000, 64.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][4], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][4], 1347440895);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][4], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][4], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][4], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][4], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][4], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][4], true);

	PlayerTD[playerid][ptdFactionSafe][5] = CreatePlayerTextDraw(playerid, 473.192169, 180.083465, "X");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][5], 0.400000, 1.600000);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][5], 484.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][5], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][5], -16776961);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][5], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][5], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][5], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][5], 1);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][5], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][5], true);

	PlayerTD[playerid][ptdFactionSafe][6] = CreatePlayerTextDraw(playerid, 320.396118, 198.166641, "Ucitavanje...");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdFactionSafe][6], 0.441229, 2.165833);
	PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdFactionSafe][6], 0.000000, 298.000000);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdFactionSafe][6], 2);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][6], 255);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdFactionSafe][6], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdFactionSafe][6], 1);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdFactionSafe][6], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdFactionSafe][6], 2);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdFactionSafe][6], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdFactionSafe][6], false);
}

ptdFactionSafe_Destroy(playerid)
{
	for (new i = 0; i < PTD_SIZE_FACTION_SAFE; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdFactionSafe][i]);
        PlayerTD[playerid][ptdFactionSafe][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    for__loop (new i = 0; i < sizeof tdFactionSafe; i++)
	{
		TextDrawHideForPlayer(playerid, tdFactionSafe[i]);
	}
}

ptdFactionSafe_Hide(playerid)
{
	for (new i = 0; i < PTD_SIZE_FACTION_SAFE; i++) 
    {
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdFactionSafe][i]);
    }

    for__loop (new i = 0; i < sizeof tdFactionSafe; i++)
	{
		TextDrawHideForPlayer(playerid, tdFactionSafe[i]);
	}
}

ptdFactionSafe_Setup(playerid, const sFactionName[], color, money, matsCount, matsWarehouseCount, heroinCount, mdmaCount, weedCount)
{
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][6], sFactionName);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdFactionSafe][6], color);

	new sMoney[36];
	format(sMoney, sizeof sMoney, "~N~~N~~N~~N~~N~~N~$ ~W~%s", formatMoneyString(money));
	strdel(sMoney, 23, 24);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][0], sMoney);

	new sMats[49];
	format(sMats, sizeof sMats, "~N~~N~~N~~N~~N~~N~%.1f ~W~kg~N~(%.1f kg)", matsCount/1000.0, matsWarehouseCount/1000.0);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][1], sMats);

	new sHeroin[35];
	format(sHeroin, sizeof sHeroin, "~N~~N~~N~~N~~N~~N~%ig ~W~heroin", heroinCount);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][2], sHeroin);

	new sMdma[35];
	format(sMdma, sizeof sMdma, "~N~~N~~N~~N~~N~~N~%ig ~W~mdma", mdmaCount);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][3], sMdma);

	new sWeed[35];
	format(sWeed, sizeof sWeed, "~N~~N~~N~~N~~N~~N~%ig ~W~weed", weedCount);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdFactionSafe][4], sWeed);

	for__loop (new i = 0; i < sizeof tdFactionSafe; i++)
	{
		TextDrawShowForPlayer(playerid, tdFactionSafe[i]);
	}

	for (new i = 0; i < PTD_SIZE_FACTION_SAFE; i++)
	{
		PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdFactionSafe][i]);
	}

	SelectTextDraw(playerid, 0xF2E4AEFF);
}