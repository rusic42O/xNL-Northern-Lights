ptdUCP_Create(playerid, const playerName[]) 
{
    PlayerTD[playerid][ptdUCP][0] = CreatePlayerTextDraw(playerid, 124.999969, 101.229537, playerName); // Ime igraca
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][0], 0.413666, 2.060444);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][0], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdUCP][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][0], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][0], 1);

    PlayerTD[playerid][ptdUCP][1] = CreatePlayerTextDraw(playerid, 123.666633, 240.199966, "__nalog");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][1], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][1], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][1], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][1], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][1], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][1], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][1], true);

    PlayerTD[playerid][ptdUCP][2] = CreatePlayerTextDraw(playerid, 123.666633, 265.199951, "__zivot");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][2], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][2], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][2], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][2], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][2], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][2], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][2], true);

    PlayerTD[playerid][ptdUCP][3] = CreatePlayerTextDraw(playerid, 123.666633, 290.199951, "__stvari");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][3], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][3], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][3], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][3], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][3], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][3], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][3], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][3], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][3], true);

    PlayerTD[playerid][ptdUCP][4] = CreatePlayerTextDraw(playerid, 123.666633, 315.199951, "__imovina");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][4], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][4], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][4], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][4], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][4], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][4], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][4], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][4], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][4], true);

    PlayerTD[playerid][ptdUCP][5] = CreatePlayerTextDraw(playerid, 123.666633, 340.199951, "__vozila");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][5], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][5], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][5], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][5], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][5], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][5], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][5], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][5], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][5], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][5], true);

    PlayerTD[playerid][ptdUCP][6] = CreatePlayerTextDraw(playerid, 123.666633, 365.199951, "__skill");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][6], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][6], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][6], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][6], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][6], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][6], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][6], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][6], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][6], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][6], true);

    PlayerTD[playerid][ptdUCP][7] = CreatePlayerTextDraw(playerid, 123.666633, 390.199951, "__postavke");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][7], 0.259333, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCP][7], 189.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][7], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCP][7], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCP][7], -231);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][7], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][7], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][7], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdUCP][7], true);

    PlayerTD[playerid][ptdUCP][8] = CreatePlayerTextDraw(playerid, 320.00000, 201.000000, "Ucitavanje..."); // Levi stub (opis stavki)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][8], 0.332331, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][8], 3);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][8], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][8], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][8], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][8], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][8], 1);

    PlayerTD[playerid][ptdUCP][9] = CreatePlayerTextDraw(playerid, 335.00000, 201.000000, "Ucitavanje..."); // Desni stub (podaci)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCP][9], 0.332331, 1.695407);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCP][9], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCP][9], 6987519);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCP][9], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCP][9], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCP][9], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCP][9], 1);


    /////////////////////////////////////////////////////////////////////////////////////////////


    PlayerTD[playerid][ptdUCPIkone][0] = CreatePlayerTextDraw(playerid, 116.666671, 123.059249, ""); // Nalog (skin)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][0], 90.000000, 89.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][0], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][0], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][0], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][0], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][0], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][0], GetPlayerCorrectSkin(playerid));
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][0], 0.000000, 0.000000, 30.000000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][1] = CreatePlayerTextDraw(playerid, 102.666679, 111.244407, ""); // Zivot
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][1], 116.000000, 113.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][1], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][1], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][1], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][1], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][1], 19792);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][1], 270.000000, 310.000000, 180.000000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][2] = CreatePlayerTextDraw(playerid, 125.000007, 123.888832, ""); // Stvari
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][2], 65.000000, 90.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][2], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][2], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][2], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][2], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][2], 1210);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][2], -30.000000, 0.000000, 30.000000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][3] = CreatePlayerTextDraw(playerid, 126.666671, 139.651840, ""); // Imovina
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][3], 65.000000, 64.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][3], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][3], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][3], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][3], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][3], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][3], 1273);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][3], 0.000000, 0.000000, 40.000000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][4] = CreatePlayerTextDraw(playerid, 121.166709, 126.177749, ""); // Vozila
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][4], 65.000000, 87.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][4], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][4], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][4], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][4], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][4], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][4], 411);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][4], 0.000000, 0.000000, 30.000000, 0.850000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPIkone][4], 3, 1);

    // PlayerTD[playerid][ptdUCPIkone][5] = CreatePlayerTextDraw(playerid, 124.333343, 138.822189, ""); // Skill
    // PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][5], 63.000000, 67.000000);
    // PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][5], 1);
    // PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][5], -1);
    // PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    // PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    // PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][5], 5);
    // PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    // PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][5], 1247);
    // PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0.000000, 0.000000, 37.500000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][5] = CreatePlayerTextDraw(playerid, 126.166633, 117.177886, ""); // Divizija
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][5], 65.000000, 95.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][5], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][5], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][5], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][5], 19783);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][5], 45.000000, 0.000000, 0.000000, 0.850000);

    PlayerTD[playerid][ptdUCPIkone][6] = CreatePlayerTextDraw(playerid, 118.333343, 134.259231, ""); // Postavke
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][6], 81.000000, 80.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][6], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][6], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][6], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][6], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][6], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][6], 1277);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][6], -20.000000, 0.000000, 220.000000, 1.000000);

    PlayerTD[playerid][ptdUCPIkone][7] = CreatePlayerTextDraw(playerid, 158.814025, 184.166671, "IRON"); // Naziv divizije
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0.281932, 1.343333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0.000000, -92.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][7], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][7], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdUCPIkone][7], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPIkone][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][7], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][7], 1);

    // Ikonica za "kazne" ako se nekad bude ubacivalo
    // PlayerTD[playerid][ptdUCPIkone][7] = CreatePlayerTextDraw(playerid, 123.666671, 126.177749, ""); // Kazne
    // PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPIkone][7], 65.000000, 87.000000);
    // PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPIkone][7], 1);
    // PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPIkone][7], -1);
    // PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0);
    // PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPIkone][7], 5);
    // PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0);
    // PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPIkone][7], 1247);
    // PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPIkone][7], 0.000000, 0.000000, 30.000000, 1.500000);


    /////////////////////////////////////////////////////////////////////////////////////////////
    // I M O V I N A
    /////////////////////////////////////////////////////////////////////////////////////////////


    
    PlayerTD[playerid][ptdUCPImovina][0] = CreatePlayerTextDraw(playerid, 206.000000, 212.166656, "_"); // Kuca
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPImovina][0], 0.237891, 1.448333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPImovina][0], 294.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPImovina][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPImovina][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCPImovina][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCPImovina][0], 255);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPImovina][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPImovina][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPImovina][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPImovina][0], 1);

    PlayerTD[playerid][ptdUCPImovina][1] = CreatePlayerTextDraw(playerid, 316.000000, 212.166656, "_"); // Stan
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPImovina][1], 0.237891, 1.448333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPImovina][1], 404.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPImovina][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPImovina][1], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCPImovina][1], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCPImovina][1], 255);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPImovina][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPImovina][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPImovina][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPImovina][1], 1);

    PlayerTD[playerid][ptdUCPImovina][2] = CreatePlayerTextDraw(playerid, 426.000000, 212.166656, "_"); // Garaza
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPImovina][2], 0.237891, 1.448333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPImovina][2], 514.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPImovina][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPImovina][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCPImovina][2], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCPImovina][2], 255);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPImovina][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPImovina][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPImovina][2], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPImovina][2], 1);

    PlayerTD[playerid][ptdUCPImovina][3] = CreatePlayerTextDraw(playerid, 206.000000, 325.000000, "_"); // Firma
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPImovina][3], 0.237891, 1.448333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPImovina][3], 294.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPImovina][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPImovina][3], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCPImovina][3], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCPImovina][3], 255);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPImovina][3], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPImovina][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPImovina][3], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPImovina][3], 1);

    PlayerTD[playerid][ptdUCPImovina][4] = CreatePlayerTextDraw(playerid, 316.000000, 325.000000, "_"); // Hotel
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPImovina][4], 0.237891, 1.448333);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPImovina][4], 404.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPImovina][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPImovina][4], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdUCPImovina][4], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdUCPImovina][4], 255);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPImovina][4], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPImovina][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPImovina][4], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPImovina][4], 1);



    /////////////////////////////////////////////////////////////////////////////////////////////
    // V O Z I L A
    /////////////////////////////////////////////////////////////////////////////////////////////


    PlayerTD[playerid][ptdUCPVozila][0] = CreatePlayerTextDraw(playerid, 192.399780, 165.547851, ""); // Model (1,1)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][0], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][0], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][0], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][0], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][0], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][0], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][0], 411);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][0], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][0], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][1] = CreatePlayerTextDraw(playerid, 302.399780, 165.547851, ""); // Model (1,2)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][1], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][1], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][1], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][1], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][1], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][1], 408);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][1], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][1], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][2] = CreatePlayerTextDraw(playerid, 413.500030, 165.547851, ""); // Model (1,3)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][2], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][2], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][2], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][2], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][2], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][2], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][2], 500);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][2], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][2], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][3] = CreatePlayerTextDraw(playerid, 192.399780, 290.199707, ""); // Model (2,1)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][3], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][3], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][3], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][3], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][3], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][3], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][3], 411);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][3], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][3], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][4] = CreatePlayerTextDraw(playerid, 302.399780, 290.199707, ""); // Model (2,2)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][4], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][4], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][4], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][4], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][4], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][4], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][4], 411);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][4], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][4], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][5] = CreatePlayerTextDraw(playerid, 413.399780, 290.199707, ""); // Model (2,3)
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdUCPVozila][5], 79.000000, 96.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][5], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][5], 0);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][5], 0);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][5], 5);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][5], 0);
    PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdUCPVozila][5], 411);
    PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][ptdUCPVozila][5], 0.000000, 0.000000, 45.000000, 1.000000);
    PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][ptdUCPVozila][5], 1, 1);

    PlayerTD[playerid][ptdUCPVozila][6] = CreatePlayerTextDraw(playerid, 201.399703, 256.133117, "_"); // Info (1,1)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][6], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][6], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][6], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][6], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][6], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][6], 1);

    PlayerTD[playerid][ptdUCPVozila][7] = CreatePlayerTextDraw(playerid, 312.399780, 256.199707, ""); // Info (1,2)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][7], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][7], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][7], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][7], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][7], 1);

    PlayerTD[playerid][ptdUCPVozila][8] = CreatePlayerTextDraw(playerid, 422.399780, 256.199707, ""); // Info (1,3)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][8], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][8], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][8], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][8], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][8], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][8], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][8], 1);

    PlayerTD[playerid][ptdUCPVozila][9] = CreatePlayerTextDraw(playerid, 201.399780, 374.000854, ""); // Info (2,1)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][9], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][9], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][9], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][9], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][9], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][9], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][9], 1);

    PlayerTD[playerid][ptdUCPVozila][10] = CreatePlayerTextDraw(playerid, 312.399780, 374.000854, ""); // Info (2,2)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][10], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][10], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][10], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][10], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][10], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][10], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][10], 1);

    PlayerTD[playerid][ptdUCPVozila][11] = CreatePlayerTextDraw(playerid, 422.399780, 374.000854, ""); // Info (2,3)
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdUCPVozila][11], 0.192999, 1.048295);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdUCPVozila][11], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdUCPVozila][11], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdUCPVozila][11], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdUCPVozila][11], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdUCPVozila][11], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdUCPVozila][11], 1);
}

ptdUCP_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_UCP; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdUCP][i]);
        PlayerTD[playerid][ptdUCP][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    for (new i = 0; i < PTD_SIZE_UCPIKONE; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdUCPIkone][i]);
        PlayerTD[playerid][ptdUCPIkone][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    for (new i = 0; i < PTD_SIZE_UCPIMOVINA; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdUCPImovina][i]);
        PlayerTD[playerid][ptdUCPImovina][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    for (new i = 0; i < PTD_SIZE_UCPVOZILA; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdUCPVozila][i]);
        PlayerTD[playerid][ptdUCPVozila][i] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

ptdUCP_Show(playerid) 
{
    for (new i = 0; i < PTD_SIZE_UCP; i++)
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdUCP][i]);
    return 1;
}

ptdUCPIkone_Hide(playerid) 
{
    for (new i = 0; i < PTD_SIZE_UCPIKONE; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdUCPIkone][i]);
    return 1;
}