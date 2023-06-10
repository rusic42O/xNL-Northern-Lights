#include <YSI_Coding\y_hooks>

// -------------------------------------------------------------------------- //
//
//
//                  Edited by: Nelson
//                        Nick: Johnny Nelson
//
//                  	 Modul: zatvor_posao.pwn
//
//
//                                                   All Rights Reserved - 2021
// -------------------------------------------------------------------------- //

// ========================================================================== //
//                       <section> Promjenljive </section>                    //
// ========================================================================== //

new 
    tajmer:KamenjeTajmer[MAX_PLAYERS],
    tajmer:MetlanjeTajmer[MAX_PLAYERS],
    tajmer:PrvoMetlanjeTajmer[MAX_PLAYERS],
    bool:RadiMetlanjeDobrotvorni[MAX_PLAYERS],
    bool:RadiMetlanje[MAX_PLAYERS],
    MetlanjePrethodni[MAX_PLAYERS],
	MetlanjeObjekat[MAX_PLAYERS],
	MetlanjeDobroPrethodni[MAX_PLAYERS],
    RadiKamenje[MAX_PLAYERS],
	PlayerText:TimerZatvorTD[MAX_PLAYERS][4];

//
//Area
new Float:AreaKamenjeTuci[3][3] =
{
    {240.0359,1897.0586,18.2387},
    {184.4659,1904.6298,17.7876},
    {113.5110,1915.5737,18.7620}
};
new Float:AreaKamenje[7][3] =
{
    {139.6623,1811.8488,17.6406},
    {148.9151,1810.7903,17.6406},
    {157.5593,1810.9113,17.6406},
    {170.5064,1811.2015,17.6439},
    {180.1180,1810.3110,17.6406},
    {192.1512,1810.3910,17.6406},
    {200.8562,1811.4075,17.6406}
};

new Float:RandomMetlanje[10][3] = {

    {1406.0630,-37.3202,1000.9987},
    {1415.8689,-35.0391,1000.9987},
    {1410.3467,-28.0040,1000.9987},
    {1406.5164,-31.7320,1000.9987},
    {1398.9160,-28.8558,1000.9987},
    {1396.0085,-34.3850,1010.3316},
    {1410.4723,-24.7462,1010.3325},
    {1421.4065,-34.4544,1010.3326},
    {1412.5961,-41.2863,1010.3334},
    {1421.3687,-34.6518,1005.6511}
};

new Float:RandomMetlanjeDobro[10][3] = {
    {1484.5771,-1706.3488,14.0469},
    {1473.9193,-1698.2463,14.0469},
    {1479.6227,-1686.9517,14.0469},
    {1508.8331,-1693.1267,14.0469},
    {1498.6895,-1672.8481,14.0469},
    {1503.1115,-1644.2278,14.0224},
    {1479.5564,-1618.9100,14.0393},
    {1465.4475,-1627.8278,14.0469},
    {1459.5779,-1649.7062,14.0469},
    {1454.5317,-1673.4683,14.0469}
};

// ========================================================================== //
//                       <section> Default funkcije </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    TimerZatvorTDKreiraj(playerid);
    return Y_HOOKS_CONTINUE_RETURN_1;
}
hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer_Zatvor(playerid);
    return Y_HOOKS_CONTINUE_RETURN_1;
}
hook OnPlayerEnterCheckpoint(playerid)
{
    if(RadiMetlanjeDobrotvorni[playerid])
	{
	    DisablePlayerCheckpoint(playerid);
	    TogglePlayerControllable(playerid, false);
	    GameTextForPlayer(playerid, "~r~Cistis..", 4000, 3);
	    //ApplyAnimation(playerid, "GHETTO_DB", "GDB_Car_SMO", 4.0, 1, 1, 1, 0, 0, 0);
        ApplyAnimation(playerid, "GHETTO_DB", "GDB_Car_SMO", 4.1, 0, 0, 0, 0, 0, 1);
	    new Float:Poskk[3];
	    GetPlayerPos(playerid, Poskk[0], Poskk[1], Poskk[2]);
	    MetlanjeObjekat[playerid] = CreatePlayerObject(playerid, 18731, Poskk[0], Poskk[1], Poskk[2]-2.0, 0, 0, 0, 10);
	    tajmer:PrvoMetlanjeTajmer[playerid] = SetTimerEx("MetlanjeDobrortvorno", 4000, false, "d", playerid);
	    return 1;
    }
    if(RadiKamenje[playerid] == 1) {

        DisablePlayerCheckpoint(playerid);
        TogglePlayerControllable(playerid, false);
        GameTextForPlayer(playerid, "~r~Kopas..", 4000, 3);
        ApplyAnimation( playerid, "CHAINSAW", "CSAW_1", 4.1, 1, 1, 1, 0, 0 );
        tajmer:KamenjeTajmer[playerid] = SetTimerEx("KopanjeTimer", 5000, false, "d", playerid);
        return 1;
    }

    if(RadiKamenje[playerid] == 2) {

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 0, 0, 0, 0, 0, 1);
        RemovePlayerAttachedObject(playerid, 1);
        DisablePlayerCheckpoint(playerid);
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

        PI[playerid][p_zatvoren]--;
        if(PI[playerid][p_zatvoren] == 0) {

            PI[playerid][p_area] = PI[playerid][p_zatvoren] = 0;
            SakrijTimerZatvorTD(playerid);
            KillTimer_Zatvor(playerid);
            SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
            SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
            SetPlayerCompensatedPos(playerid, 1802.7881, -1577.6869, 13.4119, 280.0, 0, 0, 3000);
            SetPlayerVirtualWorld(playerid, 0);
            new sQuery[90];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET zatvoren = 0, area_razlog = 'N/A', area = 0, zatvoren = 0 WHERE id = %d", PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
            overwatch_poruka(playerid, "Odsluzio si svoju zatvorsku kaznu i pusten si iz zatvora! Pokusaj biti bolji gradjanin!");
            return 1;
        }
        SetPlayerAttachedObject(playerid, 1, 19631, 6, 0.040000, 0.063000, 0.177999, -96.299964, 92.599784, -2.500000, 1.000000, 1.000000, 1.000000);
        new string[16];
        format(string, sizeof(string), "%d_markera", PI[playerid][p_zatvoren]);
        PlayerTextDrawSetString(playerid, TimerZatvorTD[playerid][3], string);
        new marker = random(sizeof(AreaKamenjeTuci));
        InfoMsg(playerid, "Ocistio si marker! Ostalo ti je jos %d!", PI[playerid][p_zatvoren]);
        RadiKamenje[playerid] = 1;
        SetPlayerCheckpoint(playerid, AreaKamenjeTuci[marker][0], AreaKamenjeTuci[marker][1], AreaKamenjeTuci[marker][2], 2.0);
        return 1;
    }
    if(RadiMetlanje[playerid]) {

        DisablePlayerCheckpoint(playerid);
        TogglePlayerControllable(playerid, false);
        GameTextForPlayer(playerid, "~r~Cistis..", 4000, 3);
        ApplyAnimation(playerid, "GHETTO_DB", "GDB_Car_SMO", 4.1, 0, 0, 0, 0, 0, 1);
        new Float:Poskk[3];
        GetPlayerPos(playerid, Poskk[0], Poskk[1], Poskk[2]);
        MetlanjeObjekat[playerid] = CreatePlayerObject(playerid, 18731, Poskk[0], Poskk[1], Poskk[2]-2.0, 0, 0, 0, 10);
        tajmer:MetlanjeTajmer[playerid] = SetTimerEx("MetlanjeTimer", 4000, false, "d", playerid);
        return 1;
    }
	return Y_HOOKS_CONTINUE_RETURN_1;
}
// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //

KillTimer_Zatvor(playerid)
{
    RadiKamenje[playerid] = MetlanjePrethodni[playerid] = MetlanjeDobroPrethodni[playerid] = 0;
    RadiMetlanjeDobrotvorni[playerid] = RadiMetlanje[playerid] = false;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE); RemovePlayerAttachedObject(playerid, 1);
    if(tajmer:PrvoMetlanjeTajmer[playerid] != 0) KillTimer(tajmer:PrvoMetlanjeTajmer[playerid]), tajmer:PrvoMetlanjeTajmer[playerid] = 0;
    if(tajmer:KamenjeTajmer[playerid] != 0) KillTimer(tajmer:KamenjeTajmer[playerid]), tajmer:KamenjeTajmer[playerid] = 0;
    if(tajmer:MetlanjeTajmer[playerid] != 0) KillTimer(tajmer:MetlanjeTajmer[playerid]), tajmer:MetlanjeTajmer[playerid] = 0;
}
TimerZatvorTDKreiraj(playerid) {

    TimerZatvorTD[playerid][0] = CreatePlayerTextDraw(playerid, 35.300014, 234.406433, "box");
    PlayerTextDrawLetterSize(playerid, TimerZatvorTD[playerid][0], 0.000000, 2.500000);
    PlayerTextDrawTextSize(playerid, TimerZatvorTD[playerid][0], 107.799682, 0.000000);
    PlayerTextDrawAlignment(playerid, TimerZatvorTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, TimerZatvorTD[playerid][0], -1);
    PlayerTextDrawUseBox(playerid, TimerZatvorTD[playerid][0], 1);
    PlayerTextDrawBoxColor(playerid, TimerZatvorTD[playerid][0], 303174399);
    PlayerTextDrawSetShadow(playerid, TimerZatvorTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, TimerZatvorTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, TimerZatvorTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, TimerZatvorTD[playerid][0], 1);

    TimerZatvorTD[playerid][1] = CreatePlayerTextDraw(playerid, 35.399978, 234.328582, "box");
    PlayerTextDrawLetterSize(playerid, TimerZatvorTD[playerid][1], 0.000000, 0.699998);
    PlayerTextDrawTextSize(playerid, TimerZatvorTD[playerid][1], 107.769523, 0.000000);
    PlayerTextDrawAlignment(playerid, TimerZatvorTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, TimerZatvorTD[playerid][1], -1);
    PlayerTextDrawUseBox(playerid, TimerZatvorTD[playerid][1], 1);
    PlayerTextDrawBoxColor(playerid, TimerZatvorTD[playerid][1], 310866175);
    PlayerTextDrawSetShadow(playerid, TimerZatvorTD[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, TimerZatvorTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, TimerZatvorTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, TimerZatvorTD[playerid][1], 1);

    TimerZatvorTD[playerid][2] = CreatePlayerTextDraw(playerid, 71.599411, 233.195983, "VRIJEME_ZATVORA");
    PlayerTextDrawLetterSize(playerid, TimerZatvorTD[playerid][2], 0.162496, 0.806666);
    PlayerTextDrawTextSize(playerid, TimerZatvorTD[playerid][2], -0.399999, 0.000000);
    PlayerTextDrawAlignment(playerid, TimerZatvorTD[playerid][2], 2);
    PlayerTextDrawColor(playerid, TimerZatvorTD[playerid][2], 255);
    PlayerTextDrawSetShadow(playerid, TimerZatvorTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, TimerZatvorTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, TimerZatvorTD[playerid][2], 2);
    PlayerTextDrawSetProportional(playerid, TimerZatvorTD[playerid][2], 1);

    TimerZatvorTD[playerid][3] = CreatePlayerTextDraw(playerid, 71.599678, 244.462738, "9999_markera");
    PlayerTextDrawLetterSize(playerid, TimerZatvorTD[playerid][3], 0.317499, 1.139554);
    PlayerTextDrawAlignment(playerid, TimerZatvorTD[playerid][3], 2);
    PlayerTextDrawColor(playerid, TimerZatvorTD[playerid][3], 310866175);
    PlayerTextDrawSetShadow(playerid, TimerZatvorTD[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, TimerZatvorTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, TimerZatvorTD[playerid][3], 3);
    PlayerTextDrawSetProportional(playerid, TimerZatvorTD[playerid][3], 1);
}

PrikaziTimerZatvorTD(playerid) {

    for(new i = 0; i < 4; i++) {

        PlayerTextDrawShow(playerid, TimerZatvorTD[playerid][i]);
    }
}

SakrijTimerZatvorTD(playerid) {

    for(new i = 0; i < 4; i++) {

        PlayerTextDrawHide(playerid, TimerZatvorTD[playerid][i]);
    }
}

ZatvoriIgracaDobroRad(id) {

    ResetPlayerWeapons(id);
    RemovePlayerAttachedObject(id, 1);
    SetPlayerAttachedObject(id, 1, 19622, 6, 0.0719, 0.0039, -0.2590, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
    SetPlayerVirtualWorld(id, 0);
    SetPlayerSkin(id, 62);
    PrikaziTimerZatvorTD(id);
    new Zstring[16];
    format(Zstring, sizeof(Zstring), "%d_markera", PI[id][p_zatvoren]);
    PlayerTextDrawSetString(id, TimerZatvorTD[id][3], Zstring);
    TogglePlayerControllable(id, false);
    SetPlayerCompensatedPos(id, 1476.6851,-1715.4576,14.0469, 180.0, 0, 0, 3000);
    SetPlayerWorldBounds(id, 1521.60009765625, 1435.60009765625, -1602.30029296875, -1720.30029296875);
    tajmer:PrvoMetlanjeTajmer[id] = SetTimerEx("PrvoMetlanjeDobrotvorni", 2000, false, "d", id);
}
ZatvoriIgraca(id) {

    ResetPlayerWeapons(id);
    RemovePlayerAttachedObject(id, 1);
    SetPlayerAttachedObject(id, 1, 19622, 6, 0.0719, 0.0039, -0.2590, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF);
    SetPlayerSkin(id, 62);
    PrikaziTimerZatvorTD(id);
    new tstring[16];
    format(tstring, sizeof(tstring), "%d_markera", PI[id][p_zatvoren]);
    PlayerTextDrawSetString(id, TimerZatvorTD[id][3], tstring);
    TogglePlayerControllable(id, false);
    SetPlayerCompensatedPos(id, 1398.1868,-31.9943,1000.9987, 180.0, 50, 0, 3000);
    tajmer:MetlanjeTajmer[id] = SetTimerEx("PrvoMetlanjeMarker", 2000, false, "d", id);
}

ZatvoriIgracaArea(id) {

    ResetPlayerWeapons(id);
    RemovePlayerAttachedObject(id, 1);
    SetPlayerAttachedObject(id, 1, 19631, 6, 0.040000, 0.063000, 0.177999, -96.299964, 92.599784, -2.500000, 1.000000, 1.000000, 1.000000);
    SetPlayerVirtualWorld(id, 50);
    SetPlayerSkin(id, 268);
    PrikaziTimerZatvorTD(id);
    new astring[16];
    format(astring, sizeof(astring), "%d_markera", PI[id][p_zatvoren]);
    PlayerTextDrawSetString(id, TimerZatvorTD[id][3], astring);
    TogglePlayerControllable(id, false);
    SetPlayerCompensatedPos(id, 215.7069,1909.2211,17.6406, 180.0, 50, 0, 3000);
    SetPlayerWorldBounds(id, 400.199951171875, 93.199951171875, 2107.5, 1777.5);
    tajmer:KamenjeTajmer[id] = SetTimerEx("KamenjePrvo", 2000, false, "d", id);
}

forward PrvoMetlanjeDobrotvorni(id);
public PrvoMetlanjeDobrotvorni(id) {

    DisablePlayerCheckpoint(id);
    new marker = random(sizeof(RandomMetlanjeDobro));
    RadiMetlanjeDobrotvorni[id] = true;
    SetPlayerCheckpoint(id, RandomMetlanjeDobro[marker][0], RandomMetlanjeDobro[marker][1], RandomMetlanjeDobro[marker][2], 2.0);
    MetlanjeDobroPrethodni[id] = marker;
    return 1;
}

forward MetlanjeDobrortvorno(playerid);
public MetlanjeDobrortvorno(playerid)
{
    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    DestroyPlayerObject(playerid, MetlanjeObjekat[playerid]);
    PI[playerid][p_zatvoren]--;
    if(PI[playerid][p_zatvoren] == 0)
	{
        PI[playerid][p_area] = PI[playerid][p_zatvoren] = 0;     
        format(PI[playerid][p_area_razlog], 32, "N/A");
        SakrijTimerZatvorTD(playerid);
        RemovePlayerAttachedObject(playerid, 1);
	    SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
		SetPlayerWorldBounds(playerid, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
	    SetPlayerCompensatedPos(playerid, 1802.7881, -1577.6869, 13.4119, 280.0, 0, 0, 3000);
        SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
        KillTimer_Zatvor(playerid);
	 	overwatch_poruka(playerid, "Odsluzio si svoj dobrotvorni rad! Pokusaj biti bolji gradjanin! Vasa zatvorska kazna je istekla.");

	    new sQuery[90];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET zatvoren = 0, area_razlog = 'N/A', zatvor = 0 WHERE id = %d", PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
        return 1;
	}
    new Xstring[16];
    format(Xstring, sizeof(Xstring), "%d_markera", PI[playerid][p_zatvoren]);
    PlayerTextDrawSetString(playerid, TimerZatvorTD[playerid][3], Xstring);
    new marker = random(sizeof(RandomMetlanjeDobro));
    if(MetlanjeDobroPrethodni[playerid] == marker) {

        marker = random(sizeof(RandomMetlanjeDobro));
    }
    InfoMsg(playerid, "Ocistio si marker! Ostalo ti je jos %d!", PI[playerid][p_zatvoren]);
    RadiMetlanjeDobrotvorni[playerid] = true;
    SetPlayerCheckpoint(playerid, RandomMetlanjeDobro[marker][0], RandomMetlanjeDobro[marker][1], RandomMetlanjeDobro[marker][2], 2.0);
    return 1;
}

forward MetlanjeTimer(playerid); //4000
public MetlanjeTimer(playerid) {

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    DestroyPlayerObject(playerid, MetlanjeObjekat[playerid]);
    PI[playerid][p_zatvoren]--;
    if(PI[playerid][p_zatvoren] == 0) {

        PI[playerid][p_area] = PI[playerid][p_zatvoren] = 0;
        DisablePlayerCheckpoint(playerid);
        SakrijTimerZatvorTD(playerid);
        RemovePlayerAttachedObject(playerid, 1);
        SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
		SetPlayerWorldBounds(playerid, 20000, -20000, 20000, -20000);
	    SetPlayerCompensatedPos(playerid, 1802.7881, -1577.6869, 13.4119, 280.0, 0, 0, 3000);
        KillTimer_Zatvor(playerid);
        new sQuery[90];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET zatvoren = 0, area_razlog = 'N/A', zatvor = 0 WHERE id = %d", PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
        overwatch_poruka(playerid, "Odsluzio si svoju zatvorsku kaznu i pusten si iz zatvora! Pokusaj biti bolji gradjanin!");
        return 1;
    }
    new zstring[16];
    format(zstring, sizeof(zstring), "%d_markera", PI[playerid][p_zatvoren]);
    PlayerTextDrawSetString(playerid, TimerZatvorTD[playerid][3], zstring);
    new marker = random(sizeof(RandomMetlanje));
    if(MetlanjePrethodni[playerid] == marker) {

        marker = random(sizeof(RandomMetlanje));
    }
    InfoMsg(playerid, "Ocistio si marker! Ostalo ti je jos %d!", PI[playerid][p_zatvoren]);
    RadiMetlanje[playerid] = true;
    SetPlayerCheckpoint(playerid, RandomMetlanje[marker][0], RandomMetlanje[marker][1], RandomMetlanje[marker][2], 2.0);
    return 1;
}

forward KopanjeTimer(playerid); //5000
public KopanjeTimer(playerid) {

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    RemovePlayerAttachedObject(playerid, 1);
    SetPlayerAttachedObject(playerid, 1, 3930, 17, 0.059999, 0.499999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000);
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

    RadiKamenje[playerid] = 2;
    new marker = random(sizeof(AreaKamenje));
    SetPlayerCheckpoint(playerid, AreaKamenje[marker][0], AreaKamenje[marker][1], AreaKamenje[marker][2], 2.0);
    return 1;
}
forward KamenjePrvo(id); //2000
public KamenjePrvo(id) {

    DisablePlayerCheckpoint(id);
    new marker = random(sizeof(AreaKamenjeTuci));
    RadiKamenje[id] = 1;
    SetPlayerCheckpoint(id, AreaKamenjeTuci[marker][0], AreaKamenjeTuci[marker][1], AreaKamenjeTuci[marker][2], 2.0);
    return 1;
}
forward PrvoMetlanjeMarker(id); //2000
public PrvoMetlanjeMarker(id) 
{
    DisablePlayerCheckpoint(id);
    new marker = random(sizeof(RandomMetlanje));
    RadiMetlanje[id] = true;
    SetPlayerCheckpoint(id, RandomMetlanje[marker][0], RandomMetlanje[marker][1], RandomMetlanje[marker][2], 2.0);
    MetlanjePrethodni[id] = marker;
    return 1;
}


/*CMD:pdzatvortest(playerid, params[]) {

    PI[playerid][p_area] += PD_ZATVOR;
    PI[playerid][p_zatvoren] += 3;
    stavi_u_zatvor(playerid, false);
    InfoMsg(playerid, "Stavio si sebe u zatvor test.");
    return 1;
}
CMD:zatvortest(playerid, params[]) {

    PI[playerid][p_area] += DOBROTVORNI_ZATVOR;
    PI[playerid][p_zatvoren] += 3;
    stavi_u_zatvor(playerid, false);
    InfoMsg(playerid, "Stavio si sebe u dobrotvorni zatvor test.");
    return 1;
}

CMD:areatest(playerid, params[]) {

    PI[playerid][p_area] = AREA;
    PI[playerid][p_zatvoren] += 3;
    stavi_u_zatvor(playerid, true);
    InfoMsg(playerid, "Stavio si sebe u areu test.");
    return 1;
}
*/