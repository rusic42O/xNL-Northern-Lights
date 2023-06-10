#include <YSI_Coding\y_hooks>

hook OnPlayerDeath(playerid, killerid, reason)
{
    ptdNovac_Hide(playerid);
}

stock ptdNovac_Create(playerid) 
{
    // PlayerTD[playerid][ptdNovac] = CreatePlayerTextDraw(playerid, 608.398132, 121.866000, "Ucitavanje...");
    // PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdNovac], 3);
    // PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdNovac], 255);
    // PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdNovac], 3);
    // PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdNovac], 0.552353, 2.174998);
    // PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], -1);
    // PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdNovac], 1);
    // PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdNovac], 1);

    // PlayerTD[playerid][ptdNovac] = CreatePlayerTextDraw(playerid, 607.308593, 97.550033, "$0");
    // PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdNovac], 0.310512, 1.477499);
    // PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdNovac], 3);
    // PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], 130628095);
    // PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdNovac], 0);
    // PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdNovac], 1);
    // PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdNovac], 255);
    // PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdNovac], 3);
    // PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdNovac], 0);

    PlayerTD[playerid][ptdNovac] = CreatePlayerTextDraw(playerid, 490.000000, 80.916679, "$0");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdNovac], 0.310512, 1.477499);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdNovac], 3);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], 130628095);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdNovac], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdNovac], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdNovac], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdNovac], 3);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdNovac], 0);
    return 1;
}

ptdNovac_SetString(playerid, const string[]) 
{
    return PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdNovac], string);
}

ptdNovac_Show(playerid) 
{
    return PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdNovac]);
}

ptdNovac_Hide(playerid) 
{
    return PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdNovac]);
}

ptdNovac_SetColor_Green(playerid)
{
    return PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], 130628095);
}

ptdNovac_SetColor_Red(playerid)
{
    return PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], 4281026303);
}

ptdNovac_SetColor_Yellow(playerid)
{
    return PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdNovac], 4294919935);
}