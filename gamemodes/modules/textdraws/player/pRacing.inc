ptdRacing_Create(playerid) 
{
    PlayerTD[playerid][ptdRacing] = CreatePlayerTextDraw(playerid, 571.333496, 269.759216, "-");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdRacing], 0.657666, 3.690667);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdRacing], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdRacing], -5963521);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdRacing], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdRacing], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdRacing], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdRacing], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdRacing], 1);

    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdRacing]);


    return 1;
}

ptdRacing_Destroy(playerid) 
{
    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdRacing]);
    PlayerTD[playerid][ptdRacing] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}

ptdRacing_UpdatePosition(playerid, position) 
{
    new str[3];
    valstr(str, position);
    return PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdRacing], str);
}

