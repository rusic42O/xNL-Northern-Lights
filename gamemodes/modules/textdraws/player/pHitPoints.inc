stock ptdHitPoints_Create(playerid)
{
    PlayerTD[playerid][ptdHitPoints][0] = CreatePlayerTextDraw(playerid, 577.331970, 65.592140, "_"); // Health
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHitPoints][0], 0.184999, 1.127111);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdHitPoints][0], 0.000000, 11.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdHitPoints][0], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHitPoints][0], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHitPoints][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHitPoints][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHitPoints][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHitPoints][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHitPoints][0], 1);

    PlayerTD[playerid][ptdHitPoints][1] = CreatePlayerTextDraw(playerid, 577.331970, 43.792472, "_"); // Armour
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdHitPoints][1], 0.184999, 1.127111);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdHitPoints][1], 0.000000, 11.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdHitPoints][1], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdHitPoints][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdHitPoints][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdHitPoints][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdHitPoints][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdHitPoints][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdHitPoints][1], 1);
}

stock ptdHitPoints_Show(playerid)
{
    new Float:HP, Float:AR;
    GetPlayerHealth(playerid, HP);
    GetPlayerArmour(playerid, AR);

    new str[6];
    format(str, sizeof str, "%.0f", HP);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHitPoints][0], str);
    format(str, sizeof str, "%.0f", AR);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdHitPoints][1], str);

    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdHitPoints][0]);
    if (AR > 0) PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdHitPoints][1]);
    else PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdHitPoints][1]);
}

stock ptdHitPoints_Hide(playerid)
{
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdHitPoints][0]);
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdHitPoints][1]);
}