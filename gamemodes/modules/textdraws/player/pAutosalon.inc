ptdAutosalon_Create(playerid) {

    PlayerTD[playerid][ptdAutosalon][75] = CreatePlayerTextDraw(playerid, 120.200027, 109.784988, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][75], 0.000000, 34.583370);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][75], 520.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][75], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][75], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][75], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][75], 205);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][75], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][75], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][75], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][75], 1);

    PlayerTD[playerid][ptdAutosalon][0] = CreatePlayerTextDraw(playerid, 132.533187, 126.099365, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][0], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][0], 190.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][0], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][0], 1);

    PlayerTD[playerid][ptdAutosalon][1] = CreatePlayerTextDraw(playerid, 116.666679, 114.100196, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][1], 90.000000, 90.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][1], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][1], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][1], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][1], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][1], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][1], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][1], 412);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][1], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][1], -1, 1);

    PlayerTD[playerid][ptdAutosalon][2] = CreatePlayerTextDraw(playerid, 132.733245, 188.054840, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][2], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][2], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][2], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][2], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][2], 1);

    PlayerTD[playerid][ptdAutosalon][3] = CreatePlayerTextDraw(playerid, 185.966674, 116.911018, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][3], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][3], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][3], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][3], 1);

    PlayerTD[playerid][ptdAutosalon][4] = CreatePlayerTextDraw(playerid, 130.000000, 116.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][4], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][4], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][4], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][4], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][4], 1);

    PlayerTD[playerid][ptdAutosalon][5] = CreatePlayerTextDraw(playerid, 212.533187, 126.099365, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][5], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][5], 270.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][5], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][5], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][5], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][5], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][5], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][5], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][5], 1);

    PlayerTD[playerid][ptdAutosalon][6] = CreatePlayerTextDraw(playerid, 203.166458, 114.100196, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][6], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][6], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][6], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][6], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][6], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][6], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][6], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][6], 600);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][6], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][6], -1, 1);

    PlayerTD[playerid][ptdAutosalon][7] = CreatePlayerTextDraw(playerid, 213.000000, 188.054840, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][7], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][7], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][7], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][7], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][7], 1);

    PlayerTD[playerid][ptdAutosalon][8] = CreatePlayerTextDraw(playerid, 266.000000, 116.911018, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][8], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][8], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][8], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][8], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][8], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][8], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][8], 1);

    PlayerTD[playerid][ptdAutosalon][9] = CreatePlayerTextDraw(playerid, 210.500000, 116.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][9], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][9], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][9], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][9], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][9], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][9], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][9], 1);

    PlayerTD[playerid][ptdAutosalon][10] = CreatePlayerTextDraw(playerid, 292.533325, 126.099365, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][10], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][10], 350.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][10], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][10], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][10], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][10], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][10], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][10], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][10], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][10], 1);

    PlayerTD[playerid][ptdAutosalon][11] = CreatePlayerTextDraw(playerid, 283.800231, 114.100196, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][11], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][11], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][11], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][11], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][11], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][11], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][11], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][11], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][11], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][11], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][11], -1, 1);

    PlayerTD[playerid][ptdAutosalon][12] = CreatePlayerTextDraw(playerid, 293.000000, 188.054840, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][12], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][12], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][12], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][12], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][12], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][12], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][12], 1);

    PlayerTD[playerid][ptdAutosalon][13] = CreatePlayerTextDraw(playerid, 346.000000, 116.911018, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][13], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][13], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][13], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][13], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][13], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][13], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][13], 1);

    PlayerTD[playerid][ptdAutosalon][14] = CreatePlayerTextDraw(playerid, 291.000000, 116.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][14], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][14], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][14], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][14], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][14], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][14], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][14], 1);

    PlayerTD[playerid][ptdAutosalon][15] = CreatePlayerTextDraw(playerid, 372.533325, 126.099365, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][15], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][15], 430.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][15], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][15], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][15], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][15], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][15], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][15], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][15], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][15], 1);

    PlayerTD[playerid][ptdAutosalon][16] = CreatePlayerTextDraw(playerid, 364.100250, 114.100196, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][16], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][16], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][16], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][16], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][16], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][16], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][16], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][16], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][16], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][16], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][16], -1, 1);

    PlayerTD[playerid][ptdAutosalon][17] = CreatePlayerTextDraw(playerid, 373.000000, 188.054840, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][17], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][17], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][17], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][17], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][17], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][17], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][17], 1);

    PlayerTD[playerid][ptdAutosalon][18] = CreatePlayerTextDraw(playerid, 426.000000, 116.911018, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][18], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][18], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][18], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][18], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][18], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][18], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][18], 1);

    PlayerTD[playerid][ptdAutosalon][19] = CreatePlayerTextDraw(playerid, 371.500000, 116.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][19], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][19], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][19], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][19], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][19], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][19], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][19], 1);

    PlayerTD[playerid][ptdAutosalon][20] = CreatePlayerTextDraw(playerid, 452.533325, 126.099365, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][20], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][20], 510.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][20], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][20], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][20], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][20], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][20], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][20], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][20], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][20], 1);

    PlayerTD[playerid][ptdAutosalon][21] = CreatePlayerTextDraw(playerid, 443.800231, 114.100196, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][21], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][21], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][21], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][21], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][21], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][21], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][21], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][21], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][21], 580);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][21], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][21], -1, 1);

    PlayerTD[playerid][ptdAutosalon][22] = CreatePlayerTextDraw(playerid, 453.000000, 188.054840, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][22], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][22], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][22], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][22], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][22], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][22], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][22], 1);

    PlayerTD[playerid][ptdAutosalon][23] = CreatePlayerTextDraw(playerid, 506.000000, 116.911018, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][23], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][23], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][23], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][23], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][23], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][23], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][23], 1);

    PlayerTD[playerid][ptdAutosalon][24] = CreatePlayerTextDraw(playerid, 452.000000, 116.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][24], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][24], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][24], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][24], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][24], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][24], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][24], 1);

    PlayerTD[playerid][ptdAutosalon][25] = CreatePlayerTextDraw(playerid, 132.533187, 212.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][25], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][25], 190.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][25], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][25], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][25], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][25], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][25], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][25], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][25], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][25], 1);

    PlayerTD[playerid][ptdAutosalon][26] = CreatePlayerTextDraw(playerid, 116.666679, 200.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][26], 90.000000, 90.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][26], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][26], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][26], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][26], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][26], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][26], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][26], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][26], 412);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][26], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][26], -1, 1);

    PlayerTD[playerid][ptdAutosalon][27] = CreatePlayerTextDraw(playerid, 132.733245, 274.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][27], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][27], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][27], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][27], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][27], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][27], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][27], 1);

    PlayerTD[playerid][ptdAutosalon][28] = CreatePlayerTextDraw(playerid, 185.966674, 202.899215, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][28], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][28], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][28], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][28], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][28], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][28], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][28], 1);

    PlayerTD[playerid][ptdAutosalon][29] = CreatePlayerTextDraw(playerid, 130.000000, 202.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][29], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][29], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][29], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][29], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][29], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][29], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][29], 1);

    PlayerTD[playerid][ptdAutosalon][30] = CreatePlayerTextDraw(playerid, 212.533187, 212.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][30], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][30], 270.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][30], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][30], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][30], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][30], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][30], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][30], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][30], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][30], 1);

    PlayerTD[playerid][ptdAutosalon][31] = CreatePlayerTextDraw(playerid, 203.166458, 200.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][31], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][31], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][31], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][31], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][31], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][31], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][31], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][31], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][31], 600);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][31], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][31], -1, 1);

    PlayerTD[playerid][ptdAutosalon][32] = CreatePlayerTextDraw(playerid, 213.000000, 274.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][32], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][32], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][32], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][32], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][32], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][32], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][32], 1);

    PlayerTD[playerid][ptdAutosalon][33] = CreatePlayerTextDraw(playerid, 266.000000, 202.899215, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][33], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][33], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][33], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][33], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][33], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][33], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][33], 1);

    PlayerTD[playerid][ptdAutosalon][34] = CreatePlayerTextDraw(playerid, 210.500000, 202.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][34], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][34], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][34], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][34], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][34], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][34], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][34], 1);

    PlayerTD[playerid][ptdAutosalon][35] = CreatePlayerTextDraw(playerid, 292.533325, 212.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][35], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][35], 350.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][35], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][35], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][35], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][35], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][35], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][35], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][35], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][35], 1);

    PlayerTD[playerid][ptdAutosalon][36] = CreatePlayerTextDraw(playerid, 283.800231, 200.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][36], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][36], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][36], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][36], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][36], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][36], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][36], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][36], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][36], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][36], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][36], -1, 1);

    PlayerTD[playerid][ptdAutosalon][37] = CreatePlayerTextDraw(playerid, 293.000000, 274.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][37], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][37], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][37], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][37], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][37], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][37], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][37], 1);

    PlayerTD[playerid][ptdAutosalon][38] = CreatePlayerTextDraw(playerid, 346.000000, 202.899215, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][38], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][38], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][38], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][38], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][38], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][38], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][38], 1);

    PlayerTD[playerid][ptdAutosalon][39] = CreatePlayerTextDraw(playerid, 291.000000, 202.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][39], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][39], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][39], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][39], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][39], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][39], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][39], 1);

    PlayerTD[playerid][ptdAutosalon][40] = CreatePlayerTextDraw(playerid, 372.533325, 212.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][40], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][40], 430.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][40], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][40], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][40], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][40], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][40], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][40], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][40], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][40], 1);

    PlayerTD[playerid][ptdAutosalon][41] = CreatePlayerTextDraw(playerid, 364.100250, 200.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][41], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][41], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][41], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][41], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][41], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][41], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][41], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][41], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][41], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][41], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][41], -1, 1);

    PlayerTD[playerid][ptdAutosalon][42] = CreatePlayerTextDraw(playerid, 373.000000, 274.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][42], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][42], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][42], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][42], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][42], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][42], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][42], 1);

    PlayerTD[playerid][ptdAutosalon][43] = CreatePlayerTextDraw(playerid, 426.000000, 202.899215, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][43], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][43], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][43], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][43], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][43], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][43], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][43], 1);

    PlayerTD[playerid][ptdAutosalon][44] = CreatePlayerTextDraw(playerid, 371.500000, 202.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][44], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][44], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][44], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][44], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][44], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][44], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][44], 1);

    PlayerTD[playerid][ptdAutosalon][45] = CreatePlayerTextDraw(playerid, 452.533325, 212.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][45], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][45], 510.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][45], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][45], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][45], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][45], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][45], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][45], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][45], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][45], 1);

    PlayerTD[playerid][ptdAutosalon][46] = CreatePlayerTextDraw(playerid, 443.800231, 200.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][46], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][46], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][46], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][46], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][46], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][46], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][46], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][46], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][46], 580);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][46], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][46], -1, 1);

    PlayerTD[playerid][ptdAutosalon][47] = CreatePlayerTextDraw(playerid, 453.000000, 274.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][47], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][47], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][47], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][47], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][47], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][47], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][47], 1);

    PlayerTD[playerid][ptdAutosalon][48] = CreatePlayerTextDraw(playerid, 506.000000, 202.899215, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][48], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][48], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][48], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][48], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][48], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][48], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][48], 1);

    PlayerTD[playerid][ptdAutosalon][49] = CreatePlayerTextDraw(playerid, 452.000000, 202.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][49], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][49], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][49], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][49], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][49], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][49], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][49], 1);

    PlayerTD[playerid][ptdAutosalon][50] = CreatePlayerTextDraw(playerid, 132.533187, 298.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][50], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][50], 190.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][50], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][50], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][50], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][50], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][50], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][50], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][50], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][50], 1);

    PlayerTD[playerid][ptdAutosalon][51] = CreatePlayerTextDraw(playerid, 116.666679, 286.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][51], 90.000000, 90.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][51], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][51], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][51], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][51], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][51], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][51], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][51], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][51], 412);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][51], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][51], -1, 1);

    PlayerTD[playerid][ptdAutosalon][52] = CreatePlayerTextDraw(playerid, 132.733245, 360.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][52], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][52], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][52], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][52], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][52], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][52], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][52], 1);

    PlayerTD[playerid][ptdAutosalon][53] = CreatePlayerTextDraw(playerid, 185.966674, 288.899200, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][53], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][53], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][53], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][53], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][53], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][53], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][53], 1);

    PlayerTD[playerid][ptdAutosalon][54] = CreatePlayerTextDraw(playerid, 130.000000, 288.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][54], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][54], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][54], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][54], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][54], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][54], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][54], 1);

    PlayerTD[playerid][ptdAutosalon][55] = CreatePlayerTextDraw(playerid, 212.533187, 298.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][55], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][55], 270.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][55], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][55], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][55], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][55], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][55], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][55], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][55], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][55], 1);

    PlayerTD[playerid][ptdAutosalon][56] = CreatePlayerTextDraw(playerid, 203.166458, 286.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][56], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][56], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][56], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][56], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][56], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][56], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][56], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][56], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][56], 600);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][56], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][56], -1, 1);

    PlayerTD[playerid][ptdAutosalon][57] = CreatePlayerTextDraw(playerid, 213.000000, 360.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][57], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][57], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][57], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][57], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][57], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][57], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][57], 1);

    PlayerTD[playerid][ptdAutosalon][58] = CreatePlayerTextDraw(playerid, 266.000000, 288.899200, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][58], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][58], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][58], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][58], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][58], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][58], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][58], 1);

    PlayerTD[playerid][ptdAutosalon][59] = CreatePlayerTextDraw(playerid, 210.500000, 288.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][59], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][59], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][59], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][59], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][59], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][59], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][59], 1);

    PlayerTD[playerid][ptdAutosalon][60] = CreatePlayerTextDraw(playerid, 292.533325, 298.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][60], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][60], 350.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][60], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][60], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][60], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][60], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][60], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][60], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][60], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][60], 1);

    PlayerTD[playerid][ptdAutosalon][61] = CreatePlayerTextDraw(playerid, 283.800231, 286.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][61], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][61], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][61], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][61], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][61], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][61], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][61], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][61], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][61], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][61], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][61], -1, 1);

    PlayerTD[playerid][ptdAutosalon][62] = CreatePlayerTextDraw(playerid, 293.000000, 360.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][62], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][62], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][62], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][62], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][62], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][62], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][62], 1);

    PlayerTD[playerid][ptdAutosalon][63] = CreatePlayerTextDraw(playerid, 346.000000, 288.899200, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][63], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][63], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][63], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][63], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][63], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][63], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][63], 1);

    PlayerTD[playerid][ptdAutosalon][64] = CreatePlayerTextDraw(playerid, 291.000000, 288.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][64], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][64], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][64], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][64], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][64], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][64], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][64], 1);

    PlayerTD[playerid][ptdAutosalon][65] = CreatePlayerTextDraw(playerid, 372.533325, 298.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][65], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][65], 430.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][65], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][65], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][65], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][65], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][65], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][65], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][65], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][65], 1);

    PlayerTD[playerid][ptdAutosalon][66] = CreatePlayerTextDraw(playerid, 364.100250, 286.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][66], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][66], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][66], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][66], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][66], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][66], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][66], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][66], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][66], 562);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][66], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][66], -1, 1);

    PlayerTD[playerid][ptdAutosalon][67] = CreatePlayerTextDraw(playerid, 373.000000, 360.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][67], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][67], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][67], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][67], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][67], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][67], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][67], 1);

    PlayerTD[playerid][ptdAutosalon][68] = CreatePlayerTextDraw(playerid, 426.000000, 288.899200, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][68], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][68], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][68], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][68], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][68], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][68], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][68], 1);

    PlayerTD[playerid][ptdAutosalon][69] = CreatePlayerTextDraw(playerid, 371.500000, 288.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][69], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][69], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][69], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][69], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][69], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][69], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][69], 1);

    PlayerTD[playerid][ptdAutosalon][70] = CreatePlayerTextDraw(playerid, 452.533325, 298.099212, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][70], 0.000000, 7.899991);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][70], 510.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][70], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][70], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][70], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][70], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][70], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][70], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][70], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][70], 1);

    PlayerTD[playerid][ptdAutosalon][71] = CreatePlayerTextDraw(playerid, 443.800231, 286.099212, "");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][71], 84.000000, 97.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][71], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][71], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][71], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][71], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][71], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][71], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][71], true);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][71], 580);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdAutosalon][71], -15.000000, 0.000000, -45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdAutosalon][71], -1, 1);

    PlayerTD[playerid][ptdAutosalon][72] = CreatePlayerTextDraw(playerid, 453.000000, 360.099212, "$25.000.000");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][72], 0.201333, 1.127110);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][72], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][72], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][72], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][72], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][72], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][72], 1);

    PlayerTD[playerid][ptdAutosalon][73] = CreatePlayerTextDraw(playerid, 506.000000, 288.899200, ".");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][73], 0.375665, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][73], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][73], 16711935);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][73], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][73], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][73], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][73], 1);

    PlayerTD[playerid][ptdAutosalon][74] = CreatePlayerTextDraw(playerid, 452.000000, 288.500000, "Voodoo");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][74], 0.328332, 1.334517);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][74], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][74], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][74], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][74], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][74], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][74], 1);

    PlayerTD[playerid][ptdAutosalon][76] = CreatePlayerTextDraw(playerid, 128.866516, 89.874130, "Automobili");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][76], 0.560998, 2.674370);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][76], 288.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][76], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][76], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][76], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdAutosalon][76], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][76], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][76], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][76], 1);

    PlayerTD[playerid][ptdAutosalon][77] = CreatePlayerTextDraw(playerid, 508.500274, 109.484939, " X");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][77], 0.258666, 1.197628);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][77], 525.060058, 30.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][77], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][77], -16776961);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][77], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdAutosalon][77], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][77], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][77], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][77], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][77], true);

    PlayerTD[playerid][ptdAutosalon][78] = CreatePlayerTextDraw(playerid, 121.333305, 404.044586, "~<~ Prethodna strana");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][78], 0.260666, 1.463111);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][78], 218.000000, 30.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][78], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][78], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][78], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][78], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][78], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][78], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][78], true);

    PlayerTD[playerid][ptdAutosalon][79] = CreatePlayerTextDraw(playerid, 443.666656, 404.459320, "Sledeca strana ~>~");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][79], 0.260666, 1.463111);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][79], 518.000000, 30.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][79], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][79], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][79], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][79], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][79], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][79], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][79], true);

    PlayerTD[playerid][ptdAutosalon][80] = CreatePlayerTextDraw(playerid, 270.799896, 401.970489, "  KUPI VOZILO");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][80], 0.310333, 1.674667);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAutosalon][80], 363.799987, 30.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][80], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][80], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAutosalon][80], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAutosalon][80], 11552511);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][80], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][80], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][80], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][80], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAutosalon][80], true);

    PlayerTD[playerid][ptdAutosalon][81] = CreatePlayerTextDraw(playerid, 316.999969, 387.037109, "INFERNUS");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAutosalon][81], 0.280665, 1.388442);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAutosalon][81], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][81], -5963521);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAutosalon][81], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAutosalon][81], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAutosalon][81], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAutosalon][81], 1);

    return 1;
}

ptdAutosalon_Destroy(playerid) {
    for (new i = 0; i < PTD_SIZE_AUTOSALON; i++) {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdAutosalon][i]);
        PlayerTD[playerid][ptdAutosalon][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

ptdAutosalon_Show(playerid) {
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][75]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][76]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][77]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][79]);
    return 1;
}

ptdAutosalon_Hide(playerid) {
    for (new i = 0; i < PTD_SIZE_AUTOSALON; i++) 
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][i]);
    
    return 1;
}