#include <YSI_Coding\y_hooks>

new tajmer:pATM_errorMsg[MAX_PLAYERS];

stock ptdATM_Create(playerid) 
{

    new string[40];
    format(string, sizeof string, "klijent:   %s", ime_rp[playerid]);

    PlayerTD[playerid][ptdATM][0] = CreatePlayerTextDraw(playerid, 316.666595, 136.073989, string); // ime igraca
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][0], 0.309666, 1.757629);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][0], 0.000000, 463.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][0], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][0], -1378294017);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][0], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdATM][0], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][0], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][0], 1);

    PlayerTD[playerid][ptdATM][1] = CreatePlayerTextDraw(playerid, 318.666564, 193.318481, "trenutno stanje na racunu:~n~$-");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][1], 0.309666, 1.757629);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][1], 0.000000, 302.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][1], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdATM][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][1], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][1], 1);

    PlayerTD[playerid][ptdATM][2] = CreatePlayerTextDraw(playerid, 319.333404, 273.792633, "Upisite cifru koju zelite da podignete:");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][2], 0.186333, 0.984814);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][2], 0.000000, 298.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][2], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][2], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][2], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdATM][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][2], 1);

    PlayerTD[playerid][ptdATM][3] = CreatePlayerTextDraw(playerid, 319.799499, 292.344512, "$-");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][3], 0.292000, 1.434074);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][3], 0.000000, -67.190040);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][3], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][3], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][3], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][3], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][3], 1);

    // PlayerTD[playerid][ptdATM][4] = CreatePlayerTextDraw(playerid, 318.000000, 70.118469, "_"); // informaciona_poruka_na_vrhu_ekrana
    // PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][4], 0.220333, 1.450666);
    // PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][4], 0.000000, -60.000000);
    // PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][4], 2);
    // PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][4], -65281);
    // PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][4], 0);
    // PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][4], 255);
    // PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][4], 1);
    // PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][4], 1);

    PlayerTD[playerid][ptdATM][4] = CreatePlayerTextDraw(playerid, 319.333312, 66.744453, "_"); // informaciona_poruka_na_vrhu_ekrana
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdATM][4], 0.349666, 1.645629);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdATM][4], 0.000000, 390.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdATM][4], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdATM][4], -5963521);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdATM][4], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdATM][4], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdATM][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdATM][4], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdATM][4], 1);

    tajmer:pATM_errorMsg[playerid] = 0;
    return 1;
}

stock ptdATM_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_ATM; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdATM][i]);
        PlayerTD[playerid][ptdATM][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    KillTimer(tajmer:pATM_errorMsg[playerid]), tajmer:pATM_errorMsg[playerid] = 0;
    return 1;
}

stock ptdATM_Show(playerid) 
{
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][0]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][2]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][3]);
    return 1;
}

stock ptdATM_Hide(playerid) 
{
    for (new i = 0; i < PTD_SIZE_ATM; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdATM][i]);
    return 1;
}

stock ptdATM_DisplayBalance(playerid)
{
    new str[48];
    format(str, sizeof str, "trenutno stanje na racunu:~n~%s", formatMoneyString(PI[playerid][p_banka]));
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][1], str);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);
}

stock ptdATM_ShowError(playerid, const str[])
{
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][4], str);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][4]);

    if (tajmer:pATM_errorMsg[playerid] != 0)
    {
        KillTimer(tajmer:pATM_errorMsg[playerid]), tajmer:pATM_errorMsg[playerid] = 0;
    }
    tajmer:pATM_errorMsg[playerid] = SetTimerEx("ptdATM_HideError", 5000, false, "i", playerid);
    return 1;
}

forward ptdATM_HideError(playerid);
public ptdATM_HideError(playerid)
{
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdATM][4]);
    KillTimer(tajmer:pATM_errorMsg[playerid]), tajmer:pATM_errorMsg[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    for (new i = 0; i < PTD_SIZE_ATM; i++) 
        PlayerTD[playerid][ptdATM][i] = PlayerText:INVALID_TEXT_DRAW;
    
    return 1;
}