#include <YSI_Coding\y_hooks>

static
    bool:ZlataraRobbed,
    bool:ZlataraInProgress,
    ZlataraTorbaPickup,
    bRobZ_faction,
    Satovi[36],
    ResetJewTimer,
    SuspectID,
    InTimeTimer,
    bool:ZlataraEnd
;

new
    ZlataraCuvar,
    bool:RobbingJewerly[MAX_PLAYERS],
    ZlataraCP[MAX_PLAYERS],
    bool:NosiZlato[MAX_PLAYERS]
;

hook OnGameModeInit()
{
    ZlataraEnd = false;
    ZlataraCuvar = CreateDynamicActor(163, 599.2057,-1459.4545,14.7443,271.4424, false, 100.0, 0); //Cuvar Zlatara
    ClearDynamicActorAnimations(ZlataraCuvar);
    ApplyDynamicActorAnimation(ZlataraCuvar, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    SuspectID = INVALID_PLAYER_ID;
    if(IsValidDynamicPickup(ZlataraTorbaPickup))
        DestroyDynamicPickup(ZlataraTorbaPickup);
    KreirajSatove();
}

hook OnPlayerConnect(playerid)
{
    RobbingJewerly[playerid] = false;
    NosiZlato[playerid] = false;
    ZlataraCP[playerid] = 0;
    return Y_HOOKS_CONTINUE_RETURN_1;
}
/*
ResetRobbingJew(playerid)
{
    NosiZlato[playerid] = false;
}*/

stock GetFactionRobbingJeweley()
{
    return bRobZ_faction;
}

stock GetJewelryPoliceTarget()
{
    return SuspectID;
}

stock IsPlayerRobbingJewelry(playerid)
{
    if(RobbingJewerly[playerid])
        return 1;

    return 0;
}

ResetCuvar()
{
    if(IsValidDynamicActor(ZlataraCuvar))
        DestroyDynamicActor(ZlataraCuvar);
    
    ZlataraCuvar = CreateDynamicActor(163, 599.2057,-1459.4545,14.7443,271.4424, false, 100.0, 0); //Cuvar Zlatara
    ClearDynamicActorAnimations(ZlataraCuvar);
    ApplyDynamicActorAnimation(ZlataraCuvar, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 30.0, 599.2057,-1459.4545,14.7443))
            Streamer_Update(i);
    }
}

KreirajSatove() {

    // GRUPA 1
    Satovi[0] = CreateDynamicObject(2710, 603.108337, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[1] = CreateDynamicObject(2710, 602.547973, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 2
    Satovi[2] = CreateDynamicObject(2710, 601.537719, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[3] = CreateDynamicObject(2710, 600.877258, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 3
    Satovi[4] = CreateDynamicObject(2710, 599.907043, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[5] = CreateDynamicObject(2710, 599.266906, -1472.280151, 14.213462, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 4
    Satovi[6] = CreateDynamicObject(2710, 598.416809, -1471.369995, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[7] = CreateDynamicObject(2710, 598.416809, -1470.859985, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 5
    Satovi[8] = CreateDynamicObject(2710, 598.416809, -1469.809692, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[9] = CreateDynamicObject(2710, 598.416809, -1469.219482, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 6
    Satovi[10] = CreateDynamicObject(2710, 598.416809, -1468.249145, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[11] = CreateDynamicObject(2710, 598.416809, -1467.649047, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 7
    Satovi[12] = CreateDynamicObject(2710, 598.416809, -1466.638671, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[13] = CreateDynamicObject(2710, 598.416809, -1466.028686, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 8
    Satovi[14] = CreateDynamicObject(2710, 598.416809, -1465.068237, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[15] = CreateDynamicObject(2710, 598.416809, -1464.427978, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 9
    Satovi[16] = CreateDynamicObject(2710, 598.416809, -1463.467651, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[17] = CreateDynamicObject(2710, 598.416809, -1462.847534, 14.213462, 0.000000, 0.000000, 810.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 10
    Satovi[18] = CreateDynamicObject(2710, 598.357849, -1453.693237, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[19] = CreateDynamicObject(2710, 598.357849, -1453.152954, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 11
    Satovi[20] = CreateDynamicObject(2710, 598.357849, -1452.132690, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[21] = CreateDynamicObject(2710, 598.357849, -1451.462524, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 12
    Satovi[22] = CreateDynamicObject(2710, 598.357849, -1450.542724, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[23] = CreateDynamicObject(2710, 598.357849, -1449.862426, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 13
    Satovi[24] = CreateDynamicObject(2710, 598.357849, -1448.942138, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[25] = CreateDynamicObject(2710, 598.357849, -1448.281982, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 14
    Satovi[26] = CreateDynamicObject(2710, 598.357849, -1447.341796, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[27] = CreateDynamicObject(2710, 598.357849, -1446.611816, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 15
    Satovi[28] = CreateDynamicObject(2710, 598.357849, -1445.711425, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[29] = CreateDynamicObject(2710, 598.357849, -1444.961059, 14.212387, 0.000000, 0.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 16
    Satovi[30] = CreateDynamicObject(2710, 599.257812, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[31] = CreateDynamicObject(2710, 599.877868, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 17
    Satovi[32] = CreateDynamicObject(2710, 600.788085, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[33] = CreateDynamicObject(2710, 601.548156, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    // GRUPA 18
    Satovi[34] = CreateDynamicObject(2710, 602.448242, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
    Satovi[35] = CreateDynamicObject(2710, 603.278320, -1444.170654, 14.212387, 0.000000, 0.000000, 360.000000, -1, -1, -1, 300.00, 300.00);
}

hook OnDynamicActorStreamIn(actorid, forplayerid)
{
    SetDynamicActorPos(ZlataraCuvar, 599.2057,-1459.4545,14.7443);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerGiveDmgDynActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    if (actorid == ZlataraCuvar && !ZlataraRobbed)
    {
        //new fID = GetFactionIDbyName("La Casa De Papel");
        //if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu radnju!");
        //if (fID != GetPlayerFactionID(playerid)) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici La Casa De Papel-a!"); 

        if(ZlataraRobbed) return ErrorMsg(playerid, "Zlatara je vec orobana!");
        if(ZlataraInProgress) return ErrorMsg(playerid, "Rob je u toku!");

        new
            saigraci = 0,
            pds = 0;

        foreach (new i : Player)
        {
            if (i == playerid) continue;
            if (PI[i][p_org_id] == PI[playerid][p_org_id] && IsPlayerNearPlayer(playerid, i, 10.0)) saigraci++;
            if(IsACop(i)) pds++;
        }
        if(!testingdaddy) {
            if (saigraci < 3) {
                AddPlayerCrime(playerid, INVALID_PLAYER_ID, 4, "Pokusaj pljacke zlatare", "Snimak sa nadzorne kamere");
                return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku zlatare.");
            } 
            if (pds < 3) {
                return ErrorMsg(playerid, "Na serveru moraju biti prisutna minimalno 3 policajca da biste pokrenuli pljacku zlatare.");
            }
        }

        DestroyDynamicActor(ZlataraCuvar);

        InfoMsg(playerid, "Pokrenuo si rob zlatare! Pokupi zlatne satove tako sto ces uci u svaki checkpoint!");
        InfoMsg(playerid, "Ne smes da napustis zlataru inace ce se rob prekinuti!");
        SuspectID = playerid;
        ZlataraInProgress = true;
        RobbingJewerly[playerid] = true;
        
        ZlataraCP[playerid] = 1;
        SetPlayerCheckpoint(playerid, 602.8632,-1471.5470,14.7443, 1.0);

        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Napad na zastitara", "Snimak sa nadzorne kamere");

        // Slanje poruke policiji i obavestenje za sve igrace
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Security NL zlatare je ranjen od strane zloglasne kriminalne grupe!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom dijelu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}moguca pljacka zlatare u toku!");

        // Upisivanje u log

        static logStr[99];
        format(logStr, sizeof logStr, "ZLATARA-START | %s | PD: %i vs %i", ime_obicno[playerid], pds, saigraci);
        Log_Write(LOG_ROBBERY, logStr);

        InTimeTimer = SetTimer("RobInTime", 1000*60*90, false);

        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if(RobbingJewerly[playerid]) {

        switch(ZlataraCP[playerid]) {

            case 0: {

                DestroyDynamicObject(Satovi[0]);
                DestroyDynamicObject(Satovi[1]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 601.2461,-1471.5471,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 1: {

                DestroyDynamicObject(Satovi[2]);
                DestroyDynamicObject(Satovi[3]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.6002,-1471.5472,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 2: {

                DestroyDynamicObject(Satovi[4]);
                DestroyDynamicObject(Satovi[5]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2088,-1471.0209,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 3: {

                DestroyDynamicObject(Satovi[6]);
                DestroyDynamicObject(Satovi[7]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1469.4249,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 4: {

                DestroyDynamicObject(Satovi[8]);
                DestroyDynamicObject(Satovi[9]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1467.8204,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 5: {

                DestroyDynamicObject(Satovi[10]);
                DestroyDynamicObject(Satovi[11]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1466.2476,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 6: {

                DestroyDynamicObject(Satovi[12]);
                DestroyDynamicObject(Satovi[13]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1464.6692,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 7: {

                DestroyDynamicObject(Satovi[14]);
                DestroyDynamicObject(Satovi[15]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1462.9858,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 8: {

                DestroyDynamicObject(Satovi[16]);
                DestroyDynamicObject(Satovi[17]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2087,-1453.3314,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 9: {

                DestroyDynamicObject(Satovi[18]);
                DestroyDynamicObject(Satovi[19]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2092,-1451.5885,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 10: {

                DestroyDynamicObject(Satovi[20]);
                DestroyDynamicObject(Satovi[21]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2092,-1451.5885,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 11: {

                DestroyDynamicObject(Satovi[22]);
                DestroyDynamicObject(Satovi[23]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1448.5332,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 12: {

                DestroyDynamicObject(Satovi[24]);
                DestroyDynamicObject(Satovi[25]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1446.9280,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 13: {

                DestroyDynamicObject(Satovi[26]);
                DestroyDynamicObject(Satovi[27]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.2086,-1445.3940,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 14: {

                DestroyDynamicObject(Satovi[28]);
                DestroyDynamicObject(Satovi[29]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 599.7703,-1444.9453,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 15: {

                DestroyDynamicObject(Satovi[30]);
                DestroyDynamicObject(Satovi[31]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 601.1335,-1444.9453,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 16: {

                DestroyDynamicObject(Satovi[32]);
                DestroyDynamicObject(Satovi[33]);
                ZlataraCP[playerid]++;
                DisablePlayerCheckpoint(playerid);
                TogglePlayerControllable(playerid, false);
                SetTimerEx("UnfreezeJewerly", 10000, false, "i", playerid);
                SetPlayerCheckpoint(playerid, 602.8792,-1444.9453,14.7443, 1.0);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 6.0, 1, 0, 0, 0, 0, 1);
                return 1;
            }
            case 17: { //Orobao

                DestroyDynamicObject(Satovi[34]);
                DestroyDynamicObject(Satovi[35]);
                ZlataraCP[playerid] = 0;
                DisablePlayerCheckpoint(playerid);

                ZlataraInProgress = false;
                ZlataraRobbed = true;
                RobbingJewerly[playerid] = false;

                ResetJewTimer = SetTimer("ResetJewerly", 3600000, false);

                RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
                SetPlayerAttachedObject(playerid, SLOT_BACKPACK, 1210, 5, 0.306999, 0.091000, 0.000000, 0.000000, -93.099998, -1.199999, 1.000000, 1.000000, 1.000000);

                NosiZlato[playerid] = true;
                InfoMsg(playerid, "Uspesno si opljackao zlataru! Odnesi zlato u svoju organizaciju!");
                ZlataraEnd = false;
                bRobZ_faction = GetPlayerFactionID(playerid);
                SetPlayerCheckpoint(playerid, FACTIONS[bRobZ_faction][f_x_spawn], FACTIONS[bRobZ_faction][f_y_spawn], FACTIONS[bRobZ_faction][f_z_spawn], 3.0);
                
                SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je zlataru!");
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Policijske snage jos nastoje sprijeciti ovaj neocekivan dogadjaj!");
                SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

                return 1;
            }
        }
    }
    if(bRobZ_faction == -1)
        return 1;
    
    if (NosiZlato[playerid] && IsPlayerInRangeOfPoint(playerid, 3.0, FACTIONS[bRobZ_faction][f_x_spawn], FACTIONS[bRobZ_faction][f_y_spawn], FACTIONS[bRobZ_faction][f_z_spawn]))
    {
        DisablePlayerCheckpoint(playerid);
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        new
            bounty = 200000,
            sLog[75]
        ;

        ZlataraEnd = true;

        if(IsACop(playerid))
        {
            //new bounty = floatround(GetBankRobBounty()/10000.0) * 10000 * 2;
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policija je snaznom upornoscu uspjela sprijeciti pljacku zlatare te su nagradjeni sa {FFFFFF}%s", formatMoneyString(floatround(150000/10000.0) * 10000 * 2));
            SendClientMessageFToAll(SVETLOCRVENA2, "    - Kriminalna organizacija koja stoji iza napada je u bijegu te molimo sve gradjane da budu oprezni!");

            static skill = 3;

            if(IsValidDynamicPickup(ZlataraTorbaPickup))
                DestroyDynamicPickup(ZlataraTorbaPickup);

            // Skill UP za policajca i njegove pomocnike + nagrada za odbranjenu banku/zlataru u sef
            static Float:x,Float:y,Float:z;
            GetPlayerPos(playerid, x, y, z);
            foreach (new i : Player)
            {
                if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                {
                    PlayerUpdateCopSkill(i, skill, SKILL_JEWWIN, (i==playerid)? 0 : 1);
                }
            }

            FactionMoneyAdd(GetPlayerFactionID(playerid), floatround(bounty/10000.0) * 10000 * 2);
            bRobZ_faction = -1;
            SuspectID = INVALID_PLAYER_ID;
            NosiZlato[playerid] = false;
            // Upisivanje u log
            format(sLog, sizeof sLog, "ZLATARA-FAILED (PDWON) | %s | %s | %s", FACTIONS[bRobZ_faction][f_tag], ime_obicno[playerid], formatMoneyString(bounty));
            Log_Write(LOG_ROBBERY, sLog);
            return 1;
        }
        else if(IsACriminal(playerid))
        {
            SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je zlataru!");
            SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, vrednost ukradenog novca se procenjuje na oko {FF0000}%s!", formatMoneyString(bounty));
            SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

            if(IsValidDynamicPickup(ZlataraTorbaPickup))
                DestroyDynamicPickup(ZlataraTorbaPickup);

            // Skill UP za sve clanove u okolini + dodavanje novca u sef
            static
                Float:x,Float:y,Float:z,
                totalRanks = 0
            ;

            new
                fid = PI[playerid][p_org_id];

            FactionMoneyAdd(fid, bounty);

            if (IsACriminal(playerid))
            {
                
                //Iter_Clear(iAwardPlayers);
                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (PI[i][p_org_id] == fid)
                    {
                        if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z) && !IsPlayerAFK(i))
                        {
                            totalRanks += PI[i][p_org_rank];

                            if (i == playerid)
                                PlayerUpdateCriminalSkill(i, 5, SKILL_ROBBERY_JEWELRY, 0);
                            else
                                PlayerUpdateCriminalSkill(i, 2, SKILL_ROBBERY_JEWELRY, 1);
                        }
                    }
                }
            }
            bRobZ_faction = -1;
            SuspectID = INVALID_PLAYER_ID;
            NosiZlato[playerid] = false;
            // Upisivanje u log
            format(sLog, sizeof sLog, "ZLATARA-USPEH | %s | %s | %s", FACTIONS[bRobZ_faction][f_tag], ime_obicno[playerid], formatMoneyString(bounty));
            Log_Write(LOG_ROBBERY, sLog);
            return 1;
        }
        return ~1;
    }
    return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (NosiZlato[playerid])
    {
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        if(IsACop(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!");
        else if(IsACriminal(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti zlato!");

        new
            Float:X,
            Float:Y,
            Float:Z
        ;
        SuspectID = INVALID_PLAYER_ID;
        GetPlayerPos(playerid, X,Y,Z);
        SetTimerEx("RestorePickup", 4000, false, "fff", X, Y, Z);
        //KreirajPickup(X, Y, Z);

        //RemoveBankPoliceTarget();
        DisablePlayerCheckpoint(playerid);
        NosiZlato[playerid] = false;
        // Upisivanje u log
        new logStr[60];
        format(logStr, sizeof logStr, "ZLATARA-DROPBAG | %s se diskonektovao", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (NosiZlato[playerid])
    {
        if (IsPlayerConnected(killerid))
        {
            if(PI[playerid][p_org_id] == PI[killerid][p_org_id])
                PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "TK");

            if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

            if(IsACop(playerid))
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!");
            else if(IsACriminal(playerid))
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti zlato!");

            new
                Float:X,
                Float:Y,
                Float:Z
            ;
            SuspectID = INVALID_PLAYER_ID;
            GetPlayerPos(playerid, X,Y,Z);
            SetTimerEx("RestorePickup", 4000, false, "fff", X, Y, Z);
            //KreirajPickup(X, Y, Z);

            //RemoveBankPoliceTarget();
            DisablePlayerCheckpoint(playerid);
            NosiZlato[playerid] = false;
            // Upisivanje u log
            new logStr[60];
            format(logStr, sizeof logStr, "ZLATARA-DROPBAG | %s je ubio %s", ime_obicno[killerid], ime_obicno[playerid]);
            Log_Write(LOG_ROBBERY, logStr);
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward RobInTime();
public RobInTime()
{
    if(IsValidDynamicPickup(ZlataraTorbaPickup))
        DestroyDynamicPickup(ZlataraTorbaPickup);

    if(SuspectID != INVALID_PLAYER_ID)
    {
        NosiZlato[SuspectID] = false;
        DisablePlayerCheckpoint(SuspectID);
    }
    SuspectID = INVALID_PLAYER_ID;
    SendClientMessageFToAll(BELA, "Vesti | {FF6347}Cini se kako je pljacka prekinuta, nemamo daljnjih informacija!");

    KillTimer(InTimeTimer);
    
    return true;
}

forward RestorePickup(Float:X, Float:Y, Float:Z);
public RestorePickup(Float:X, Float:Y, Float:Z)
{
    ZlataraTorbaPickup = CreateDynamicPickup(1210, 1, X, Y, Z, 0, 0);

    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, 50.0, X, Y, Z))
        {
            Streamer_Update(i);
        }
    }
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    static
        Float:X,
        Float:Y,
        Float:Z
    ;
    GetPlayerPos(playerid, X, Y, Z);

    if (pickupid == ZlataraTorbaPickup && ZlataraRobbed == true && bRobZ_faction != -1 && !ZlataraEnd)
    {
        bRobZ_faction = GetPlayerFactionID(playerid);
        if(IsACriminal(playerid))
        {
            DestroyDynamicPickup(ZlataraTorbaPickup);

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject(playerid, SLOT_BACKPACK, 1210, 5, 0.306999, 0.091000, 0.000000, 0.000000, -93.099998, -1.199999, 1.000000, 1.000000, 1.000000);

            NosiZlato[playerid] = true;
            SuspectID = playerid;
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako doznajemo, drugo kriminalno lice pokusava ukrasti novac!");
        }
        else if(IsACop(playerid))
        {
            DestroyDynamicPickup(ZlataraTorbaPickup);

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject(playerid, SLOT_BACKPACK, 1210, 5, 0.306999, 0.091000, 0.000000, 0.000000, -93.099998, -1.199999, 1.000000, 1.000000, 1.000000);

            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako doznajemo, policija nastoji odnijeti novac na sigurno!");

            NosiZlato[playerid] = true;
        }
        SetPlayerCheckpoint(playerid, FACTIONS[bRobZ_faction][f_x_spawn], FACTIONS[bRobZ_faction][f_y_spawn], FACTIONS[bRobZ_faction][f_z_spawn], 3.0);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward ResetJewerly();
public ResetJewerly()
{
    KreirajSatove();

    if(IsValidDynamicPickup(ZlataraTorbaPickup))
        DestroyDynamicPickup(ZlataraTorbaPickup);

    if(SuspectID != INVALID_PLAYER_ID)
        NosiZlato[SuspectID] = false;
    SuspectID = INVALID_PLAYER_ID;

    ZlataraRobbed = false;
    ZlataraInProgress = false;
    bRobZ_faction = -1;
    ResetCuvar();

    foreach(new i : Player) // 9 id chainsaw
    {
        if(RobbingJewerly[i])
        {
            RobbingJewerly[i] = false;
            DisablePlayerCheckpoint(i);
        }
    }

    KillTimer(ResetJewTimer);
    KillTimer(InTimeTimer);
    return 1;
}

forward UnfreezeJewerly(playerid);
public UnfreezeJewerly(playerid)
{
    TogglePlayerControllable(playerid, true);
    return 1;
}

flags:forcejewreset(FLAG_ADMIN_6)
CMD:forcejewreset(playerid)
{
    KreirajSatove();

    if(IsValidDynamicPickup(ZlataraTorbaPickup))
        DestroyDynamicPickup(ZlataraTorbaPickup);

    if(SuspectID != INVALID_PLAYER_ID)
        NosiZlato[SuspectID] = false;
    SuspectID = INVALID_PLAYER_ID;

    ZlataraRobbed = false;
    ZlataraInProgress = false;
    bRobZ_faction = -1;
    ResetCuvar();

    foreach(new i : Player) // 9 id chainsaw
    {
        if(RobbingJewerly[i])
        {
            RobbingJewerly[i] = false;
            DisablePlayerCheckpoint(i);
        }
    }

    KillTimer(ResetJewTimer);
    KillTimer(InTimeTimer);
    return 1;
}