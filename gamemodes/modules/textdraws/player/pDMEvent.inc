ptdDMEvent_Create(playerid)
{
    PlayerTD[playerid][ptdDMEvent] = CreatePlayerTextDraw(playerid, 378.666687, 372.267120, "$0");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdDMEvent], 0.227666, 1.185185);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdDMEvent], 3);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdDMEvent], -1378294017);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdDMEvent], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdDMEvent], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdDMEvent], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdDMEvent], 3);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdDMEvent], 1);
}

ptdDMEvent_Destroy(playerid)
{
    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdDMEvent]);
}

ptdDMEvent_Show(playerid)
{
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdDMEvent]);
}

ptdDMEvent_Update(playerid, value)
{
    new string[14];
    format(string, sizeof string, "%s", formatMoneyString(value));
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdDMEvent], string);
    if (value < 0) PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdDMEvent], 4281026303);
    else if (value > 0) PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdDMEvent], 130628095);
    else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdDMEvent], -1378294017);

    ptdDMEvent_Show(playerid);
}