stock ptdHudLegacy_Create(playerid) {               
    PlayerTD[playerid][ptdHudLegacy][0] = CreatePlayerTextDraw(playerid, 609.000000, 406.000000, "_"); // 12
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHudLegacy][0], 0.500000, 0.899999);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], -1);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHudLegacy][0], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], 343447754);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdHudLegacy][0], 535.000000, 1.000000);

    PlayerTD[playerid][ptdHudLegacy][1] = CreatePlayerTextDraw(playerid, 584.000000, 406.000000, "N/A"); // 13
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdHudLegacy][1], 2);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHudLegacy][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHudLegacy][1], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHudLegacy][1], 0.230000, 0.899999);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHudLegacy][1], -1);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHudLegacy][1], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHudLegacy][1], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHudLegacy][1], 1);

    PlayerTD[playerid][ptdHudLegacy][2] = CreatePlayerTextDraw(playerid, 538.000000, 384.000000, "~P~N/A"); // 14
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHudLegacy][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHudLegacy][2], 3);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHudLegacy][2], 0.430000, 1.899999);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHudLegacy][2], -16711681);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHudLegacy][2], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHudLegacy][2], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHudLegacy][2], 1);

    PlayerTD[playerid][ptdHudLegacy][4] = CreatePlayerTextDraw(playerid, 614.000000, 385.000000, "~b~~h~~h~?"); // 23
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHudLegacy][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHudLegacy][4], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHudLegacy][4], 0.419999, 1.799998);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHudLegacy][4], -1);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHudLegacy][4], 1);
    return 1;
}

stock ptdHudLegacy_Destroy(playerid) {
    for (new i = 0; i < PTD_SIZE_HUDLEGACY; i++) {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdHudLegacy][i]);
        PlayerTD[playerid][ptdHudLegacy][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock ptdHudLegacy_Show(playerid) {
    for (new i = 0; i < PTD_SIZE_HUDLEGACY; i++)
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdHudLegacy][i]);
    return 1;
}

stock ptdHudLegacy_Hide(playerid) {
    for (new i = 0; i < PTD_SIZE_HUDLEGACY; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdHudLegacy][i]);
    return 1;
}

stock ptdHudLegacy_UpdateSpeed(playerid, speed, topSpeed) 
{
    if (topSpeed == 0) return 1;
    
    new string[8];
    format(string, sizeof string, "~p~%d", speed);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][2], string);

    new speedPercentage = (speed * 100) / topSpeed;

    if (speedPercentage > 5)  TextDrawShowForPlayer(playerid, tdHudLegacy[5]);
    if (speedPercentage > 15) TextDrawShowForPlayer(playerid, tdHudLegacy[6]);
    if (speedPercentage > 30) TextDrawShowForPlayer(playerid, tdHudLegacy[7]);
    if (speedPercentage > 45) TextDrawShowForPlayer(playerid, tdHudLegacy[8]);
    if (speedPercentage > 60) TextDrawShowForPlayer(playerid, tdHudLegacy[9]);
    if (speedPercentage > 85) TextDrawShowForPlayer(playerid, tdHudLegacy[10]);
    if (speedPercentage < 85) TextDrawHideForPlayer(playerid, tdHudLegacy[10]);
    if (speedPercentage < 60) TextDrawHideForPlayer(playerid, tdHudLegacy[9]);
    if (speedPercentage < 45) TextDrawHideForPlayer(playerid, tdHudLegacy[8]);
    if (speedPercentage < 30) TextDrawHideForPlayer(playerid, tdHudLegacy[7]);
    if (speedPercentage < 15) TextDrawHideForPlayer(playerid, tdHudLegacy[6]);
    if (speedPercentage < 5)  TextDrawHideForPlayer(playerid, tdHudLegacy[5]);
    return 1;
}

stock ptdHudLegacy_UpdateGear(playerid, speed, topSpeed) {
    new gear = GetVehicleGear(playerid, speed, topSpeed);
    switch (gear) {
        case GEAR_UNKNOWN:  PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~?");
        case GEAR_REVERSE:  PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~R");
        case GEAR_NEUTRAL:  PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~N");
        case GEAR_PARKING:  PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~P");
        case 1:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~1");
        case 2:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~2");
        case 3:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~3");
        case 4:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~4");
        case 5:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~5");
        case 6:             PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~6");
        default:            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][4], "~b~~h~~h~?");
    }
    return 1;
}

stock ptdHudLegacy_UpdateFuel(playerid) {
    new
        string[8],
        Float:X,
        Float:M,
        vehicleid = GetPlayerVehicleID(playerid);
    if (vehicleid == INVALID_VEHICLE_ID) return 1;

    if (GetVehicleFuel(vehicleid) == -1) 
        format(string, sizeof string, "N/A");
    else 
        format(string, sizeof string, "%.1fl", GetVehicleFuel(vehicleid));
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHudLegacy][1], string);

    X = 89.0; // maxX (628.0) - minX (539.0)
    M = floatdiv(GetVehicleTankVolume(vehicleid), GetVehicleFuel(vehicleid));
    X = floatadd(floatdiv(X, M), 539.0);

    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdHudLegacy][0]);
    PlayerTD[playerid][ptdHudLegacy][0] = CreatePlayerTextDraw(playerid, X, 406.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHudLegacy][0], 0.500000, 0.899999);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], -1);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHudLegacy][0], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdHudLegacy][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdHudLegacy][0], 343447754);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdHudLegacy][0], 535.000000, 1.000000);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdHudLegacy][0]);
    return 1;
}