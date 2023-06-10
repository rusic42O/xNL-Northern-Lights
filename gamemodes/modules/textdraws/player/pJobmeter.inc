ptdJobmeter_Create(playerid) 
{
    new jobname[20];
    GetPlayerJobName(playerid, jobname, sizeof jobname);

    PlayerTD[playerid][ptdJobmeter][0] = CreatePlayerTextDraw(playerid, 498.500000, 184.000000, jobname);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobmeter][0], 0.243663, 1.234963);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobmeter][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobmeter][0], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobmeter][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdJobmeter][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobmeter][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobmeter][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobmeter][0], 1);

    PlayerTD[playerid][ptdJobmeter][1] = CreatePlayerTextDraw(playerid, 606.000000, 184.000000, "0%");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobmeter][1], 0.221663, 1.255702);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobmeter][1], 3);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobmeter][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobmeter][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdJobmeter][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobmeter][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobmeter][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobmeter][1], 1);

    PlayerTD[playerid][ptdJobmeter][2] = CreatePlayerTextDraw(playerid, 498.500000, 198.000000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobmeter][2], 0.000000, 2.222332);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobmeter][2], 605.999450, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobmeter][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobmeter][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdJobmeter][2], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdJobmeter][2], 224);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobmeter][2], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobmeter][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobmeter][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobmeter][2], 1);

    PlayerTD[playerid][ptdJobmeter][3] = CreatePlayerTextDraw(playerid, 500.500000, 200.300000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdJobmeter][3], 0.000000, 1.703673);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobmeter][3], 602.999328, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdJobmeter][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdJobmeter][3], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdJobmeter][3], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdJobmeter][3], 157658592);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdJobmeter][3], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdJobmeter][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdJobmeter][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdJobmeter][3], 1);

    for (new i = 0; i < PTD_SIZE_JOBMETER; i++)
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdJobmeter][i]);

    return 1;
}

ptdJobmeter_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_JOBMETER; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdJobmeter][i]);
        PlayerTD[playerid][ptdJobmeter][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    return 1;
}

ptdJobmeter_UpdateProgress(playerid, Float:progress, Float:min, Float:max) 
{
    // PlayerTextDrawTextSize ide od 499.0 do 603.5 (X koordinata)
    new 
        string[6],
        percentage_display,
        Float:progress_percentage = ((progress - min) / (max - min)) * 100.0,
        Float:lettersize = 499.0 + 104.5*(progress_percentage / 100);

    percentage_display = floatround(progress_percentage, floatround_round);

    if (percentage_display > 100) percentage_display = 100;
    if (percentage_display < 0)   percentage_display = 0;
    
    format(string, sizeof(string), "%d%%", percentage_display);

    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdJobmeter][3], lettersize, 0.000000);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdJobmeter][1], string);

    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdJobmeter][3]);
    return 1;
}

ptdJobmeter_Hide(playerid)
{
    for (new i = 0; i < PTD_SIZE_JOBMETER; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdJobmeter][i]);
}