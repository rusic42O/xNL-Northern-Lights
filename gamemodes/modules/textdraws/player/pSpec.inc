ptdSpec_Create(playerid) 
{
    PlayerTD[playerid][ptdSpec][0] = CreatePlayerTextDraw(playerid, 550.029296, 135.750091, "Ucitavanje...");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSpec][0], 0.161522, 1.282500);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdSpec][0], 0.000000, 132.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSpec][0], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSpec][0], -65281);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSpec][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdSpec][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSpec][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSpec][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSpec][0], 1);

    PlayerTD[playerid][ptdSpec][1] = CreatePlayerTextDraw(playerid, 546.888610, 152.666687, "_");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSpec][1], 0.166676, 0.987499);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdSpec][1], 602.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSpec][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSpec][1], -1061109505);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSpec][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdSpec][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSpec][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSpec][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSpec][1], 1);

    for (new i = 0; i < PTD_SIZE_SPEC; i++)
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdSpec][i]);
    
    return 1;
}

ptdSpec_Destroy(playerid) 
{
    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdSpec][0]);
    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdSpec][1]);
    PlayerTD[playerid][ptdSpec][0] = PlayerText:INVALID_TEXT_DRAW;
    PlayerTD[playerid][ptdSpec][1] = PlayerText:INVALID_TEXT_DRAW;
    return 1;
}