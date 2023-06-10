ptdJobhelp_Create(playerid) 
{
    PlayerTD[playerid][ptdJobhelp][0] = CreatePlayerTextDraw(playerid, 14.666699, 133.285110, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobhelp][0], 0.000000, 5.337332);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobhelp][0], 163.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobhelp][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobhelp][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdJobhelp][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdJobhelp][0], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobhelp][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobhelp][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobhelp][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobhelp][0], 1);

    PlayerTD[playerid][ptdJobhelp][1] = CreatePlayerTextDraw(playerid, 18.499860, 118.681388, "Ucitavanje..."); // Naziv posla
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobhelp][1], 0.379332, 1.965036);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobhelp][1], 1011.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobhelp][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobhelp][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobhelp][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdJobhelp][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobhelp][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobhelp][1], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobhelp][1], 1);

    PlayerTD[playerid][ptdJobhelp][2] = CreatePlayerTextDraw(playerid, 21.333513, 142.411010, "Ucitavanje..."); // Opis radnje
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobhelp][2], 0.165000, 1.019258);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobhelp][2], 158.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobhelp][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobhelp][2], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobhelp][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobhelp][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobhelp][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobhelp][2], 1);

    return 1;
}

ptdJobhelp_Destroy(playerid) {
    for (new i = 0; i < PTD_SIZE_JOBHELP; i++) {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdJobhelp][i]);
        PlayerTD[playerid][ptdJobhelp][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    return 1;
}

ptdJobhelp_SetJob(playerid, const job[]) {
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdJobhelp][1], job);

    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdJobhelp][0]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdJobhelp][1]);
    return 1;
}

ptdJobhelp_SetString(playerid, const string[]) {
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdJobhelp][2], string);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdJobhelp][2]);
    return 1;
}

ptdJobhelp_Hide(playerid)
{
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdJobhelp][0]);
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdJobhelp][1]);
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdJobhelp][2]);
}