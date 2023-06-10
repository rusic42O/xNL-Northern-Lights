ptdMarketRob_Create(playerid) 
{
    PlayerTD[playerid][ptdMarketRob][0] = CreatePlayerTextDraw(playerid, 498.500000, 184.000000, "Pljacka u toku...");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdMarketRob][0], 0.243666, 1.234963);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdMarketRob][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdMarketRob][0], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdMarketRob][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdMarketRob][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdMarketRob][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdMarketRob][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdMarketRob][0], 1);

    PlayerTD[playerid][ptdMarketRob][1] = CreatePlayerTextDraw(playerid, 606.000000, 184.000000, "0%");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdMarketRob][1], 0.221666, 1.255703);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdMarketRob][1], 3);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdMarketRob][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdMarketRob][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdMarketRob][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdMarketRob][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdMarketRob][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdMarketRob][1], 1);

    PlayerTD[playerid][ptdMarketRob][2] = CreatePlayerTextDraw(playerid, 498.500000, 198.000000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdMarketRob][2], 0.000000, 2.222334);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdMarketRob][2], 606.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdMarketRob][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdMarketRob][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdMarketRob][2], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdMarketRob][2], 224);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdMarketRob][2], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdMarketRob][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdMarketRob][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdMarketRob][2], 1);

    PlayerTD[playerid][ptdMarketRob][3] = CreatePlayerTextDraw(playerid, 500.500000, 200.300000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdMarketRob][3], 0.000000, 1.703673);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdMarketRob][3], 499.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdMarketRob][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdMarketRob][3], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdMarketRob][3], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdMarketRob][3], 4282861567);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdMarketRob][3], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdMarketRob][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdMarketRob][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdMarketRob][3], 1);

    for (new i = 0; i < PTD_SIZE_MARKETROB; i++)
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdMarketRob][i]);
}

ptdMarketRob_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_MARKETROB; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdMarketRob][i]);
        PlayerTD[playerid][ptdMarketRob][i] = PlayerText:INVALID_TEXT_DRAW;
    }
}

ptdMarketRob_UpdateProgress(playerid, Float:progress_percentage) 
{
    // PlayerTextDrawTextSize ide od 499.0 do 603.5 (X koordinata)
    new 
        string[6],
        progress_display,
        Float:lettersize = 499.0 + 104.5*(progress_percentage / 100.0);

    progress_display = floatround(progress_percentage);
    if (progress_display > 100) progress_display = 100;
    if (progress_display < 0)   progress_display = 0;
    
    format(string, sizeof(string), "%d%%", progress_display);

    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdMarketRob][3], lettersize, 0.000000);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdMarketRob][1], string);

    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdMarketRob][3]);
    return 1;
}
