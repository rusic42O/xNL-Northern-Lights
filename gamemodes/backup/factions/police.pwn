#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define TASER_BASETIME  (6)     // Sok ce trajati najmanje 6 sec
#define TASER_INDEX     (4)     // setplayerattachedobject index for taser object
#define MAX_BARRIERS     (2 * MAX_FACTIONS_MEMBERS * 2) // 2 prepreke po igracu (PD+SWAT), ali ce u praksi moci vise jer nece svako da koristi
#define MAX_PLAYER_BARRIERS 5 // Broj prepreka po igracu

#define MIN_RANK_KAZNA 3




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_TASER
{
    bool:TaserEnabled,
    TaserCountdown,
    GetupTimer,
    bool:TaserCharged,
    ChargeTimer
};

enum E_BARRIER_DATA
{
    BARRIER_NAME[32],
    BARRIER_OBJECT_ID,
    BARRIER_PLAYER_ID,
    BARRIER_MODEL,
    Float:BARRIER_POS[6],
    Text3D:BARRIER_3DTEXT,
}

enum E_CCTV
{
    CCTV_NAME[22],
    Float:CCTV_CAMERA_POS[3],
    Float:CCTV_CAMERA_LOOK_AT[3],
}






// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new TaserData[MAX_PLAYERS][E_TASER];
new BarrierData[MAX_BARRIERS][E_BARRIER_DATA]; // 2 barijere po igracu (PD+SWAT), ali u parksi ce moci vise
new CCTV[][E_CCTV] =
{
    {"Zlatara", {650.7531,-1424.7245,30.9720},  {611.0959,-1465.0505,14.4689}},
    {"Bolnica", {1222.6276,-1369.4385,30.3864}, {1176.3911,-1323.2476,14.0190}},
    {"PD 1",    {1501.4023,-1664.3165,33.9114}, {1546.1394,-1691.3717,13.9214}},
    {"PD 2",    {1501.4023,-1664.3165,33.9114}, {1541.1857,-1635.5614,15.5305}},
    {"Opstina", {1501.2058,-1701.7690,31.5366}, {1462.2919,-1753.4950,13.5483}},
    {"Banka 1", {1423.6034,-1046.5382,43.3438}, {1471.5747,-1016.6328,25.7544}},
    {"Banka 2", {1500.8936,-1048.6794,39.9983}, {1438.6027,-1022.7612,23.8281}},
    {"Burg",    {1273.4896,-944.3929,59.1594},  {1203.1417,-928.1246,42.9344}}
};


new 
    checkpoint_PDPopravka,
    checkpoint_SWATPopravka,
    //actor_PDMehanicar,
    actor_SWATMehanicar,
    pickup_PDOprema,
    pickup_SWATOprema,
    bool:PDPopravka_inUse,
    bool:SWATPopravka_inUse,

    gPoliceInteraction[MAX_PLAYERS],
    gPoliceTicketPaidTime[MAX_PLAYERS],

    bool:gLawDuty[MAX_PLAYERS char],
    bool:gPlayerHandcuffed[MAX_PLAYERS char],
    pUsingCCTV[MAX_PLAYERS],
    tajmer:pPhoneLocator[MAX_PLAYERS],

    PlayerBar:TaserChargeBar[MAX_PLAYERS],

    // Rotacije
    policeLightObj[MAX_VEHICLES][2],
    bool:FlasherState[MAX_VEHICLES char],
    tmrFlash,
    Iterator:iFlashingVehicles<MAX_VEHICLES>,

    // SOS
    tajmer:policeSOS,
    policeSOS_playerID,

    // Barijere
    pBarriers[MAX_PLAYERS],
    Iterator:iBarriers<MAX_BARRIERS>;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    Iter_Clear(iPolicemen);

    // Postavljanje CP za PD popravku
    checkpoint_PDPopravka = CreateDynamicCP(1587.2683,-1665.5732,13.4703, 2.0, 0, 0, -1, 5.0); // 1530.6863, -1677.9153, 5.8906
    PDPopravka_inUse = false;
    // Postavljanje CP za SWAT popravku
    checkpoint_SWATPopravka = CreateDynamicCP(1429.7600,789.8082,11.0527, 2.0, 0, 0, -1, 5.0);
    SWATPopravka_inUse = false;

    // PD actor (mehanicar)
    //actor_PDMehanicar = CreateDynamicActor(50, 1524.9529, -1677.9741, 5.8906, 270.0);
    // SWAT actor (mehanicar)
    actor_SWATMehanicar = CreateDynamicActor(50, 1429.7196,793.8729,10.8203, 180.0);

    // PD oprema
    pickup_PDOprema = CreateDynamicPickup(1247, 1, 1401.8667,-0.9297,1001.0008);
    // SWAT oprema
    pickup_SWATOprema = CreateDynamicPickup(1247, 1, 258.4168, 109.5337, 1003.2188);


    // Video nadzor
    CreateDynamic3DTextLabel("Video nadzor\n{FFFFFF}/cctv", 0xAC12F4FF, 57.4201,812.9319,-29.6422, 5.0);

    // 3D text za tocenje goriva PD/SWAT
    CreateDynamic3DTextLabel("[ Benzinska pumpa ]\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo", 0xFFFF00FF, 1594.9836,-1662.2030,13.4703, 7.0); // PD 1528.957153, -1686.031494, 6.473833
    // CreateDynamic3DTextLabel("[ Benzinska pumpa ]\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo", 0xFFFF00FF, 299.4340,-1536.6195,24.5938, 7.0); // SWAT
    CreateDynamic3DTextLabel("[ Benzinska pumpa ]\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo", 0xFFFF00FF, 1448.7781,786.9559,10.3938, 7.0); // SWAT

    // Map Icon
    CreateDynamicMapIcon(1524.9529, -1677.9741, 13.5, 30, BELA, 0, 0);


    // Arrest Points
    CreateDynamicPickup(1247, 1, 1535.6982,-1675.5869,12.9614);
    CreateDynamic3DTextLabel("[ Arrest Point ]\n{FFFF00}/uhapsi", 0x0068B3FF, 1535.6982,-1675.5869,12.9614, 12.0);
    CreateDynamicPickup(1247, 1, 1771.1769,-1546.9315,9.9188);
    CreateDynamic3DTextLabel("[ Arrest Point ]\n{FFFF00}/uhapsi", 0x0068B3FF, 1771.1769,-1546.9315,9.9188, 12.0);
    //CreateDynamicPickup(1247, 1, 1544.6929,-1645.8215,5.4520);
    //CreateDynamic3DTextLabel("[ Arrest Point ]\n{FFFF00}/uhapsi", 0x0068B3FF, 1544.6929,-1645.8215,5.4520, 12.0);
    CreateDynamicPickup(1247, 1, 1540.2302,676.2508,10.8203);
    CreateDynamic3DTextLabel("[ Arrest Point ]\n{FFFF00}/uhapsi", 0x0068B3FF, 1540.2302,676.2508,10.8203, 12.0);


    // Rotacije
    tmrFlash = 0;
    for__loop (new veh = 0; veh < MAX_VEHICLES; veh++)
    {
        FlasherState{veh} = false;
        policeLightObj[veh][0] = policeLightObj[veh][1] = -1;
    }
    Iter_Clear(iFlashingVehicles);


    // Prepreke (init)
    Iter_Clear(iBarriers);
    for__loop (new i = 0; i < MAX_BARRIERS; i++)
    {
        BarrierData[i][BARRIER_PLAYER_ID] = INVALID_PLAYER_ID;
        BarrierData[i][BARRIER_OBJECT_ID] = -1;
        BarrierData[i][BARRIER_3DTEXT]    = Text3D:INVALID_3DTEXT_ID;
    }
    printf("MAX_BARRIERS: %i", MAX_BARRIERS);

    policeSOS_playerID = INVALID_PLAYER_ID;
    tajmer:policeSOS = 0;
    return true;
}


hook OnPlayerConnect(playerid)
{
    gPlayerHandcuffed{playerid} = false;
    gLawDuty{playerid} = false;
    pUsingCCTV[playerid] = -1;
    tajmer:pPhoneLocator[playerid] = 0;
    gPoliceInteraction[playerid] = 0;
    gPoliceTicketPaidTime[playerid] = 0;

    pBarriers[playerid] = 0;

    TaserData[playerid][TaserEnabled] = false;
    TaserData[playerid][TaserCharged] = true;
    TaserData[playerid][TaserCountdown] = 0;
    TaserData[playerid][GetupTimer] = 0;
    TaserData[playerid][ChargeTimer] = 0;

    SetPVarInt(playerid, "pBarrierID", -1);
}

hook OnPlayerSpawn(playerid) 
{
    gPoliceTicketPaidTime[playerid] = 0;
    gLawDuty{playerid} = false;
    if (Iter_Contains(iPolicemen, playerid))
    {
        Iter_Remove(iPolicemen, playerid);
    }

    if(TaserData[playerid][GetupTimer] != 0)
    {
        KillTimer(TaserData[playerid][GetupTimer]);
    }

    if(TaserData[playerid][ChargeTimer] != 0)
    {
        KillTimer(TaserData[playerid][ChargeTimer]);
    }

    RemovePlayerBarriers(playerid);

    if (policeSOS_playerID == playerid)
    {
        POLICE_SOSTurnOff();
    }

    KillTimer(tajmer:pPhoneLocator[playerid]);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (TaserData[playerid][TaserCountdown] > 0)
    {
        // Igrac je sokiran napustio server
        PI[playerid][p_zavezan] = 1; // Ovo se upisuje u bazu u query-ju koji je u glavnom fajlu, a posle se igrac stavlja u zatvor kad se vrati
    }

    RemovePlayerBarriers(playerid);

    if (policeSOS_playerID == playerid)
    {
        POLICE_SOSTurnOff();
    }

    if (!IsACop(playerid) && gPoliceInteraction[playerid] >= gettime() && IsPlayerWanted(playerid) && PI[playerid][p_zavezan] == 0)
    {
        // Anti LTA
        new nearbyOfficer = INVALID_PLAYER_ID;
        foreach (new i : iPolicemen)
        {
            if (IsPlayerNearPlayer(i, playerid, 40.0))
            {
                nearbyOfficer = i;
                break;
            }
        }

        if (IsPlayerConnected(nearbyOfficer))
        {
            PI[playerid][p_zavezan] = 1; // Ovo se upisuje u bazu u query-ju koji je u glavnom fajlu, a posle se igrac stavlja u zatvor kad se vrati

            // Upisivanje u log
            new sLog[95];
            format(sLog, sizeof sLog, "LTA - Bezanje od potere | %s | Policajac: %s", ime_obicno[playerid], ime_obicno[nearbyOfficer]);
            Log_Write(LOG_AUTOPUNISHMENT, sLog);
        }
    }
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid) 
{
    if ((checkpointid == checkpoint_PDPopravka && !PDPopravka_inUse) || (checkpointid == checkpoint_SWATPopravka && !SWATPopravka_inUse)) 
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ~1;

        new vehicleid = GetPlayerVehicleID(playerid);

        if (!IsACop(playerid)) 
        {
            ErrorMsg(playerid, "Samo pripadnici policije mogu popravljati vozila na ovom mestu.");
            return ~1;
        }

        if (!IsLawVehicle(vehicleid)) 
        {
            ErrorMsg(playerid, "Na ovom mestu mozete popravljati samo vozila policije.");
            return ~1;
        }


        // Prosao provere, u pitanju je LAW auto
        if (IsPlayerInRangeOfPoint(playerid, 15.0, 1530.6863, -1677.9153, 5.8906))
        {
            // PD
            //SetDynamicActorPos(actor_PDMehanicar, 1524.9529, -1677.9741, 5.8906);
            SetVehiclePos(vehicleid, 1528.8154, -1677.9011, 6.0961);
            SetVehicleZAngle(vehicleid, 90.0);
            TogglePlayerControllable_H(playerid, false);
            SetPlayerCameraPos(playerid, 1524.4977, -1674.4611 ,7.5188);
            SetPlayerCameraLookAt(playerid, 1526.9529, -1678.5741, 5.8906);
            SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 1, 0, 0);
            GameTextForPlayer(playerid, "~y~Popravka u toku~n~~w~Molimo sacekajte...", 3000, 3);
            //ApplyDynamicActorAnimation(actor_PDMehanicar, "SHOP", "SHP_Serve_Loop", 4.1, 1, 0, 0, 0, 0);
            SetTimerEx("PDPopravka_finish", 8000, false, "iii", playerid, vehicleid, cinc[playerid]);
            PDPopravka_inUse = true;
        }
        else if (IsPlayerInRangeOfPoint(playerid, 15.0, 1429.7600,789.8082,11.0527))
        {
            // SWAT
            SetDynamicActorPos(actor_SWATMehanicar, 1429.7196,793.8729,10.8203);
            SetVehiclePos(vehicleid, 1429.7600,789.8082,11.0527);
            SetVehicleZAngle(vehicleid, 0.0);
            TogglePlayerControllable_H(playerid, false);
            SetPlayerCameraPos(playerid, 1432.9960,795.8714,10.8203);
            SetPlayerCameraLookAt(playerid, 1429.7196,793.8729,10.8203);
            SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 1, 0, 0);
            GameTextForPlayer(playerid, "~y~Popravka u toku~n~~w~Molimo sacekajte...", 3000, 3);
            ApplyDynamicActorAnimation(actor_SWATMehanicar, "SHOP", "SHP_Serve_Loop", 4.1, 1, 0, 0, 0, 0);
            SetTimerEx("SWATPopravka_finish", 8000, false, "iii", playerid, vehicleid, cinc[playerid]);
            SWATPopravka_inUse = true;
        }
        return ~1;
    }
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid) 
{
    if (pickupid == pickup_PDOprema || pickupid == pickup_SWATOprema) 
    {
        GameTextForPlayer(playerid, "~b~Policijska oprema~n~~w~Koristite ~y~/duznost ~w~i ~y~/oprema", 4000, 3);
        return ~1;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (Iter_Contains(iPolicemen, playerid))
    {
        Iter_Remove(iPolicemen, playerid);
    }

    if (TaserData[playerid][TaserEnabled])
    {
        TaserData[playerid][TaserEnabled] = false;
        RemovePlayerAttachedObject(playerid, SLOT_TASER);
        DestroyPlayerProgressBar(playerid, TaserChargeBar[playerid]);
    }

    RemovePlayerBarriers(playerid);

    if (policeSOS_playerID == playerid)
    {
        POLICE_SOSTurnOff();
    }

    PI[playerid][p_zavezan] = 0;
    gPlayerHandcuffed{playerid} = false;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (pUsingCCTV[playerid] != -1)
    {
        if (newkeys & KEY_FIRE) // Levi klik
        {
            new nextCam = pUsingCCTV[playerid]+1;
            if (nextCam >= sizeof CCTV) nextCam = 0;
            dialog_respond:cctv(playerid, 1, nextCam, CCTV[nextCam][CCTV_NAME]);
        }
        else if (newkeys & KEY_HANDBRAKE) // Desni klik
        {
            new prevCam = pUsingCCTV[playerid]-1;
            if (prevCam <= -1) prevCam = sizeof CCTV - 1;
            dialog_respond:cctv(playerid, 1, prevCam, CCTV[prevCam][CCTV_NAME]);
        }
    }

    if((newkeys & KEY_FIRE) && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && IsPlayerOnLawDuty(playerid) && IsACop(playerid))
    {

        if (TaserData[playerid][TaserEnabled] && TaserData[playerid][TaserCharged])
        {
            TaserShoot(playerid);
        }
    }
    return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    if (IsValidDynamicObject(policeLightObj[vehicleid][0]))
        DestroyDynamicObject(policeLightObj[vehicleid][0]), policeLightObj[vehicleid][0] = -1;

    if (IsValidDynamicObject(policeLightObj[vehicleid][1]))
        DestroyDynamicObject(policeLightObj[vehicleid][1]), policeLightObj[vehicleid][1] = -1;

    if (Iter_Contains(iFlashingVehicles, vehicleid))
        Iter_Remove(iFlashingVehicles, vehicleid);
}

hook OnVehicleDeath(vehicleid, killerid)
{
    if (IsValidDynamicObject(policeLightObj[vehicleid][0]))
        DestroyDynamicObject(policeLightObj[vehicleid][0]), policeLightObj[vehicleid][0] = -1;

    if (IsValidDynamicObject(policeLightObj[vehicleid][1]))
        DestroyDynamicObject(policeLightObj[vehicleid][1]), policeLightObj[vehicleid][1] = -1;

    if (Iter_Contains(iFlashingVehicles, vehicleid))
        Iter_Remove(iFlashingVehicles, vehicleid);
}

hook OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if (!IsACop(playerid)) return 1;
    if (response == EDIT_RESPONSE_UPDATE) return 1;

    new barrier = GetPVarInt(playerid, "pBarrierID");
    if (barrier == -1) return 1;

    if (response == EDIT_RESPONSE_FINAL)
    {
        BarrierData[barrier][BARRIER_POS][0] = x;
        BarrierData[barrier][BARRIER_POS][1] = y;
        BarrierData[barrier][BARRIER_POS][2] = z;
        BarrierData[barrier][BARRIER_POS][3] = rx;
        BarrierData[barrier][BARRIER_POS][4] = ry;
        BarrierData[barrier][BARRIER_POS][5] = rz;
    }

    new barrierStr[64];
    format(barrierStr, sizeof barrierStr, "%s\nID: {FFFFFF}%i", BarrierData[barrier][BARRIER_NAME], barrier);
    DestroyDynamicObject(BarrierData[barrier][BARRIER_OBJECT_ID]);
    DestroyDynamic3DTextLabel(BarrierData[barrier][BARRIER_3DTEXT]);
    BarrierData[barrier][BARRIER_OBJECT_ID] = CreateDynamicObject(BarrierData[barrier][BARRIER_MODEL], BarrierData[barrier][BARRIER_POS][0], BarrierData[barrier][BARRIER_POS][1], BarrierData[barrier][BARRIER_POS][2], BarrierData[barrier][BARRIER_POS][3], BarrierData[barrier][BARRIER_POS][4], BarrierData[barrier][BARRIER_POS][5]);
    BarrierData[barrier][BARRIER_3DTEXT]    = CreateDynamic3DTextLabel(barrierStr, 0x9BC9CE80, BarrierData[barrier][BARRIER_POS][0], BarrierData[barrier][BARRIER_POS][1], BarrierData[barrier][BARRIER_POS][2], 10.0);

    
    SetPVarInt(playerid, "pBarrierID", -1);
    TextDrawHideForPlayer(playerid, tdBarrierHint);
    PC_EmulateCommand(playerid, "/prepreka");
    Streamer_Update(playerid);
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if (IsACop(playerid) && IsPlayerOnLawDuty(playerid) && weaponid == WEAPON_SILENCED && !IsPlayerInAnyVehicle(playerid))
    {
        if (TaserData[playerid][TaserEnabled] && TaserData[playerid][TaserCharged])
        {
            if (hittype == BULLET_HIT_TYPE_PLAYER && IsPlayerNearPlayer(playerid, hitid, 30.0))
            {
                TaserShoot(playerid, hitid, true);
            }
            else
            {
                // Nije pogodio igraca -> ukljuciti reload tazera
                TaserData[playerid][TaserCharged] = false;

                SetPlayerProgressBarColour(playerid, TaserChargeBar[playerid], RGY[0]);
                SetPlayerProgressBarValue(playerid, TaserChargeBar[playerid], 0.0);
                TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 100, true, "i", playerid);

                new string2[80];
                format(string2, sizeof string2, "** %s ispaljuje iz elektrosoka, ali ne pogadja nikoga.", ime_rp[playerid]);
                RangeMsg(playerid, string2, LJUBICASTA, 20.0);
            }
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward CheckFineAcceptance(playerid, ccinc);
public CheckFineAcceptance(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    if (GetPVarInt(playerid, "police_kaznaIznos"))
    {
        // Igrac nije platio kaznu u roku
        
        dialog_respond:police_kazna(playerid, 0, -1, "-");
    }
    return 1;
}

Police_NotifyVehTheft(vehicleid)
{
    new Float:x, Float:y, Float:z,
        sZone[32]
    ;
    GetVehiclePos(vehicleid, x, y, z);
    Get2DZoneByPosition(x, y, sZone, sizeof sZone);

    DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Model vozila: %s, Lokacija: %s", GetVehicleModelName(GetVehicleModel(vehicleid)), sZone);
    return 1;
}

TaserShoot(playerid, hitid = INVALID_PLAYER_ID, bool:taserGun = false)
{
    TaserData[playerid][TaserCharged] = false;

    SetPlayerProgressBarColour(playerid, TaserChargeBar[playerid], RGY[0]);
    SetPlayerProgressBarValue(playerid, TaserChargeBar[playerid], 0.0);
    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 100, true, "i", playerid);
    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
    if (GetPlayerWeapon(playerid) == 0)
    {
        ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
    }

    if (hitid == INVALID_PLAYER_ID)
    {
        // Obican tazer (nije tazer gun)

        new Float:pos[3];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

        foreach (new i : Player)
        {
            if (playerid == i) continue;
            if (TaserData[i][TaserCountdown] != 0) continue;
            if (IsPlayerInAnyVehicle(i)) continue;
            if (IsACop(i)) continue;
            if (!IsPlayerInRangeOfPoint(i, 4.0, pos[0], pos[1], pos[2])) continue;
            if (GetPlayerState(i) == PLAYER_STATE_SPECTATING) continue;

            hitid = i;
            break;
        }
    }

    if (!IsPlayerConnected(hitid) || !IsPlayerNearPlayer(playerid, hitid, 30.0))
    {
        new string2[80];
        format(string2, sizeof string2, "** %s ispaljuje iz elektrosoka, ali ne pogadja nikoga.", ime_rp[playerid]);
        RangeMsg(playerid, string2, LJUBICASTA, 20.0);
    }
    else
    {
        if (!taserGun)
        {
            if (GetPlayerWeapon(hitid) > 0 && ((22 <= GetPlayerWeapon(hitid) <= 34) || GetPlayerWeapon(hitid) == 38))
            {
                if ((GetPlayerCameraMode(hitid) == 53 && IsPlayerFacingPlayer(hitid, playerid, 60.0)) 
                    || ((GetPVarInt(playerid, "pTookDamage")+3 > gettime()) && GetPVarInt(playerid, "pTookDamageID") == hitid))
                {
                    // Tazovao igraca dok je bio ispred njega u trenutku kada je taj igrac nisanio oruzjem 
                    // ILI tazovao igraca sa ledja iako je pre toga primio damage od tog istog igraca

                    PunishPlayer(playerid, INVALID_PLAYER_ID, 60, 0, 2, false, "PG/RPS (taz na gun)");
                    SetTimerEx("ShowRulesDialog_POLICE", 30000, false, "ii", playerid, cinc[playerid]);
                    return 1;
                }
            }
        }

        if (TaserData[hitid][GetupTimer] || TaserData[hitid][TaserCountdown] > gettime()) return 1;


        new Float:health, string[64];

        ClearAnimations(hitid, 1);
        TogglePlayerControllable_H(hitid, false);
        ApplyAnimation(hitid, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
        PlayerPlaySound(hitid, 6003, 0.0, 0.0, 0.0);

        GetPlayerHealth(hitid, health);
        TaserData[hitid][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
        format(string, sizeof(string), "~n~~n~~n~~b~~h~~h~SOKIRAN: ~g~~h~~h~%d", TaserData[hitid][TaserCountdown]);
        GameTextForPlayer(hitid, string, 1000, 3);
        TaserData[hitid][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", hitid);

        new string2[96];
        format(string2, sizeof string2, "** %s ispaljuje iz elektrosoka i pogadja %s.", ime_rp[playerid], ime_rp[hitid]);
        RangeMsg(playerid, string2, LJUBICASTA, 20.0);

        // Pogodjeni igrac pljacka zlataru?
        if (IsPlayerRobbingJewelry(hitid))
        {    
            if (IsPlayerAttachedObjectSlotUsed(hitid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(hitid, SLOT_BACKPACK);

            FactionMsg(GetFactionRobbingJeweley(), "{FF0000}Pljacka zlatare je propala jer je policija uhvatila %s.", ime_rp[hitid]);
            FactionMsg(PI[playerid][p_org_id], "{4655B2}* Odvedite %s u zatvor da biste dobili novcanu nagradu!", ime_rp[hitid]);

            SendClientMessageToAll(BELA, "Vesti | {FF6347}Policijske jedinice su na vreme reagovale i tako uspele da sprece jos jednu pljacku zlatare!");
            SendClientMessageToAll(SVETLOCRVENA2, "    - Trenutno je u toku zestoki okrsaj izmedju policijskih snaga i za sada nepoznate kriminalne organizacije.");

            // Upisivanje u log
            new logStr[53];
            format(logStr, sizeof logStr, "ZLATARA-FAIL | %s je sokiran", ime_obicno[hitid]);
            Log_Write(LOG_ROBBERY, logStr);

            jRob_Reset();
            JewelryRob_SetPoliceTarget(hitid);
        }

        // Pogodjeni igrac pljacka banku?
        if (IsPlayerRobbingBank(hitid))
        {    
            if (IsPlayerAttachedObjectSlotUsed(hitid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(hitid, SLOT_BACKPACK);

            FactionMsg(GetFactionRobbingBank(), "{FF0000}Pljacka banke je propala jer je policija uhvatila %s.", ime_rp[hitid]);
            FactionMsg(PI[playerid][p_org_id], "{4655B2}* Odvedite %s u zatvor da biste dobili novcanu nagradu!", ime_rp[hitid]);

            SendClientMessageToAll(BELA, "Vesti | {FF6347}Policijske jedinice su na vreme reagovale i tako uspele da sprece jos jednu pljacku banke!");
            SendClientMessageToAll(SVETLOCRVENA2, "    - Trenutno je u toku zestoki okrsaj izmedju policijskih snaga i za sada nepoznate kriminalne organizacije.");

            // Upisivanje u log
            new logStr[51];
            format(logStr, sizeof logStr, "BANKA-FAIL | %s je sokiran", ime_obicno[hitid]);
            Log_Write(LOG_ROBBERY, logStr);

            bRob_Reset();
            BankRob_SetPoliceTarget(hitid);
        }

        // Pogodjeni igrac pljacka bankomat/krade vozilo/obija skladiste s oruzjem?
        if (IsPlayerBurglaryActive(hitid))
        {
            if (IsPlayerStealingVehicle(hitid))
            {
                AddPlayerCrime(hitid, playerid, 2, "Pokusaj kradje vozila", ime_obicno[playerid]);
            }
            else if (IsPlayerRobbingWeaponsWH(hitid))
            {
                AddPlayerCrime(hitid, playerid, 2, "Pokusaj provale", ime_obicno[playerid]);
            }

            CallRemoteFunction("OnBurglaryStop", "i", hitid); 
        }

        if (IsPlayerRobbingATM(hitid))
        {
            ATMRobbery_Reset(playerid);
        }
    }
    return 1;
}

stock SetUncuffed(playerid)
{
    gPlayerHandcuffed{playerid} = false;
}

stock RecentPoliceInteraction(playerid)
{
    return (gPoliceInteraction[playerid] >= gettime());
}

stock POLICE_SOSTurnOff()
{
    if (DebugFunctions())
    {
        LogFunctionExec("POLICE_SOSTurnOff");
    }

    policeSOS_playerID = INVALID_PLAYER_ID;
    KillTimer(tajmer:policeSOS);
    
    foreach (new i : Player)
    {
        if (IsACop(i))
        {
            RemovePlayerMapIcon(i, MAPICON_POLICE_SOS);
        }
    }
    return 1;
}

stock IsLawFaction(f_id)
{
    if (FACTIONS[f_id][f_vrsta] == FACTION_LAW)
    {
        return 1;
    }
    else return 0;
}

stock IsPlayerHandcuffed(playerid)
{
    return gPlayerHandcuffed{playerid};
}

stock IsPlayerOnLawDuty(playerid) 
{
    return gLawDuty{playerid};
}

stock ToggleLawDuty(playerid, bool:toggle)
{
    gLawDuty{playerid} = toggle;

    if (!toggle)
    {
        SetPlayerSkin(playerid, PI[playerid][p_skin]);
        SetPlayerArmour(playerid, 0.0);
        ResetPlayerWeapons(playerid);
        SetPlayerColor(playerid, 0xFFFFFFFF);
        Iter_Remove(iPolicemen, playerid);

        foreach (new i : Player)
        {
            if (!IsOnDuty(i))
            {
                SetPlayerMarkerForPlayer(playerid, i, 0xFFFFFF00);
            }
        }

        new f_id = PI[playerid][p_org_id];
        if (f_id != -1)
        {
            DepartmentMsg(INFOPLAVA, "(%s) Sluzbenik %s vise nije na duznosti.", FACTIONS[f_id][f_tag], ime_rp[playerid]);
        }
    }
    else {
        SetPlayerColor(playerid, 0x1D5575FF);
    }
}

stock RemovePlayerBarriers(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("RemovePlayerBarriers");
    }

    if (pBarriers[playerid] > 0)
    {
        foreach (new i : iBarriers)
        {
            if (BarrierData[i][BARRIER_PLAYER_ID] == playerid)
            {
                DestroyDynamicObject(BarrierData[i][BARRIER_OBJECT_ID]);
                DestroyDynamic3DTextLabel(BarrierData[i][BARRIER_3DTEXT]);
                BarrierData[i][BARRIER_OBJECT_ID] = -1;
                BarrierData[i][BARRIER_3DTEXT]    = Text3D:INVALID_3DTEXT_ID;
                BarrierData[i][BARRIER_PLAYER_ID] = INVALID_PLAYER_ID;

                Iter_SafeRemove(iBarriers, i, i);
                pBarriers[playerid] -= 1;

                if (pBarriers[playerid] <= 0) break;
            }
        }
    }
}

forward POLICE_SOSTimer(); // Tajmer
public POLICE_SOSTimer()
{
    if (DebugFunctions())
    {
        LogFunctionExec("POLICE_SOSTimer");
    }

    if (!IsPlayerConnected(policeSOS_playerID) || !IsACop(policeSOS_playerID))
    {
        KillTimer(tajmer:policeSOS);
        return 1;
    }

    new Float:pos[3];
    GetPlayerPos(policeSOS_playerID, pos[0], pos[1], pos[2]);

    foreach (new i : Player)
    {
        if (IsACop(i) && i != policeSOS_playerID)
        {
            RemovePlayerMapIcon(i, MAPICON_POLICE_SOS);
            SetPlayerMapIcon(i, MAPICON_POLICE_SOS, pos[0], pos[1], pos[2], 30, 0, MAPICON_GLOBAL);
        }
    }
    return 1;
}

forward PDPopravka_finish(playerid, vehicleid, ccinc); // Tajmer
public PDPopravka_finish(playerid, vehicleid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("PDPopravka_finish");
    }

    RepairVehicle(vehicleid);
    SetVehicleHealth(vehicleid, 999.0);
    SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    //ClearDynamicActorAnimations(actor_PDMehanicar);
    PDPopravka_inUse = false;

    if (checkcinc(playerid, ccinc)) {
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable_H(playerid, true);
        GameTextForPlayer(playerid, "~g~Vozilo je popravljeno", 3000, 3);
    }
    return 1;
}

forward SWATPopravka_finish(playerid, vehicleid, ccinc); // Tajmer
public SWATPopravka_finish(playerid, vehicleid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("SWATPopravka_finish");
    }

    RepairVehicle(vehicleid);
    SetVehicleHealth(vehicleid, 999.0);
    SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    ClearDynamicActorAnimations(actor_SWATMehanicar);
    SWATPopravka_inUse = false;

    if (checkcinc(playerid, ccinc)) {
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable_H(playerid, true);
        GameTextForPlayer(playerid, "~g~Vozilo je popravljeno", 3000, 3);
    }
    return 1;
}

forward TaserGetUp(playerid);
public TaserGetUp(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("TaserGetUp");
    }

    if (!IsPlayerConnected(playerid))
    {
        KillTimer(TaserData[playerid][GetupTimer]);
        return 1;
    }


    if(TaserData[playerid][TaserCountdown] > 1) 
    {
        new string[48];
        TaserData[playerid][TaserCountdown]--;
        format(string, sizeof(string), "~n~~n~~n~~b~~h~~h~SOKIRAN: ~g~~h~~h~%d", TaserData[playerid][TaserCountdown]);
        GameTextForPlayer(playerid, string, 1000, 3);
    }
    else if(TaserData[playerid][TaserCountdown] == 1) 
    {
        ClearAnimations(playerid, 1);
        if (PI[playerid][p_zavezan] <= 0)
        {
            SetPlayerCuffed(playerid, 0);
            TogglePlayerControllable_H(playerid, true);
        }
        else
        {
            SetPlayerCuffed(playerid, 1);
        }
        KillTimer(TaserData[playerid][GetupTimer]);
        TaserData[playerid][GetupTimer] = 0;
        TaserData[playerid][TaserCountdown] = 0;
        GameTextForPlayer(playerid, "~n~~n~~n~~g~~h~~h~EFEKAT SOKA JE PROSAO", 1000, 3);
    }

    return 1;
}

forward ChargeUp(playerid);
public ChargeUp(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("ChargeUp");
    }

    if (!IsPlayerConnected(playerid))
    {
        KillTimer(TaserData[playerid][ChargeTimer]);
        return 1;
    }

    new Float: charge = GetPlayerProgressBarValue(playerid, TaserChargeBar[playerid]);
    charge++;

    if (charge < 0.0)
    {
        TaserData[playerid][TaserCharged] = true;
        KillTimer(TaserData[playerid][ChargeTimer]);
        charge = 0.0;
    }

    if(charge >= 100.0)
    {
        charge = 100.0;
        TaserData[playerid][TaserCharged] = true;
        KillTimer(TaserData[playerid][ChargeTimer]);
        PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);
        SendClientMessage(playerid, 0x3498DBFF, "(tazer) {FFFFFF}Elektrosoker je napunjen i spreman.");

        if (PI[playerid][p_org_rank] >= 3)
        {
            // stavlja 1 metak za tazer gun ako ima rank 3+
            GivePlayerWeapon(playerid, WEAPON_SILENCED, 1);
            SetPlayerAmmo(playerid, 2, 1);
        }
    }

    if(charge < 100.0) SetPlayerProgressBarColour(playerid, TaserChargeBar[playerid], RGY[floatround(charge)]);
    SetPlayerProgressBarValue(playerid, TaserChargeBar[playerid], charge);
    return 1;
}

forward FlasherFunc();
public FlasherFunc()
{
    if (Iter_Count(iFlashingVehicles) == 0)
    {
        KillTimer(tmrFlash);
        return 1;
    }

    new panels, doors, lights, tires;
    foreach (new veh : iFlashingVehicles)
    {
        GetVehicleDamageStatus(veh,panels, doors, lights, tires);
        if (FlasherState{veh} == true)
        {
            UpdateVehicleDamageStatus(veh, panels, doors, 4, tires);
        }
        else
        {
            UpdateVehicleDamageStatus(veh, panels, doors, 1, tires);
        }
        
        FlasherState{veh} = !FlasherState{veh};
    }
    return 1;
}

forward PhoneLocator(officerid, officer_ccinc, targetid, target_ccinc, stage);
public PhoneLocator(officerid, officer_ccinc, targetid, target_ccinc, stage)
{
    if (!checkcinc(officerid, officer_ccinc) || !checkcinc(targetid, target_ccinc))
    {
        if (!checkcinc(targetid, target_ccinc))
        {
            RemovePlayerMapIcon(officerid, MAPICON_LOCATE);
            SendClientMessage(officerid, SVETLOCRVENA, "* Korisnik je van dometa. (( igrac napustio igru ))");
        }

        KillTimer(tajmer:pPhoneLocator[officerid]), tajmer:pPhoneLocator[officerid] = 0;
        return 1;
    }

    if (stage >= 5)
    {
        RemovePlayerMapIcon(officerid, MAPICON_LOCATE);
        SendClientMessage(officerid, SVETLOCRVENA, "* Signal je izgubljen. (( isteklo vreme ))");
        KillTimer(tajmer:pPhoneLocator[officerid]), tajmer:pPhoneLocator[officerid] = 0;
    }
    else
    {
        GetPlayerPos(targetid, pozicija[targetid][0], pozicija[targetid][1], pozicija[targetid][2]);
        SetPlayerMapIcon(officerid, MAPICON_LOCATE, pozicija[targetid][POS_X], pozicija[targetid][POS_Y], pozicija[targetid][POS_Z], 0, 0xFFFF00AA, MAPICON_GLOBAL);

        stage ++;
        tajmer:pPhoneLocator[officerid] = SetTimerEx("PhoneLocator", 8000, false, "iiiii", officerid, officer_ccinc, targetid, target_ccinc, stage);
    }
    return 1;
}






// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
/*Dialog:seize(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "POLICE_SeizeID");
        return 1;
    }

    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new id = GetPVarInt(playerid, "POLICE_SeizeID");

    if (!IsPlayerNearPlayer(playerid, id))
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (listitem == 0) // Oruzje
    {
        // Brojanje metaka
        new weaponid, ammo, totalAmmoCount = 0;
        for__loop (new i = 0; i < 13; i++) 
        {
            weaponid    = GetPlayerWeaponInSlot(id, i);
            ammo        = GetPlayerAmmoInSlot(id, i);
            if (weaponid <= 0 || ammo <= 0) continue;

            totalAmmoCount += ammo;
        }

        // Davanje WL ako treba
        if (totalAmmoCount > 0)
        {
            new crimeLevel = floatround(totalAmmoCount/200.0, floatround_ceil) * 3; // 3xWL na svakih 200 metaka
            new reason[32];
            format(reason, sizeof reason, "Nosenje oruzja (%i metaka)", totalAmmoCount);


            if ((PI[id][p_dozvola_oruzje] > 0 && totalAmmoCount > 500) || PI[id][p_dozvola_oruzje] <= 0)
            {
                // Ako ima dozvolu i preko 500 metaka  ILI  nema dozvolu --> dobija WL
                AddPlayerCrime(id, playerid, crimeLevel, reason, ime_obicno[playerid]);
            }
        }

        // Oduzimanje orzja
        ResetPlayerWeapons(id);

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo oruzje.", ime_rp[playerid]);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste oruzje od %s.", ime_rp[id]);

        new logstr[100];
        format(logstr, sizeof logstr, "ORUZJE | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    else if (listitem == 1) // Droga
    {

        // Daje WL igracu ako je imao drogu
        new drugsCount = BP_PlayerItemGetCount(id, ITEM_MDMA) + BP_PlayerItemGetCount(id, ITEM_HEROIN);
        if (drugsCount > 0)
        {
            new crimeLevel = floatround(drugsCount/50.0, floatround_ceil) * 3; // 3xWL na svakih 50g
            new reason[32];
            format(reason, sizeof reason, "Posedovanje droge (%i gr)", drugsCount);
            AddPlayerCrime(id, playerid, crimeLevel, reason, ime_obicno[playerid]);
        }

        // Oduzimanje droge
        DRUGS_SeizeFromPlayer(id);

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo drogu (%i grama).", ime_rp[playerid], drugsCount);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste drogu od %s (%i grama).", ime_rp[id], drugsCount);

        new logstr[100];
        format(logstr, sizeof logstr, "DROGA | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    else if (listitem == 2) // Vozacka dozvola
    {
        if (PI[id][p_dozvola_voznja] == 0)
        {
            ErrorMsg(playerid, "Taj igrac nema vozacku dozvolu.");
            return DialogReopen(playerid);
        }

        PI[id][p_dozvola_voznja] = 0;

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo dozvolu za voznju.", ime_rp[playerid]);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste %s dozvolu za voznju.", ime_rp[id]);

        new query[60];
        format(query, sizeof query, "UPDATE igraci SET dozvola_voznja = 0 WHERE id = %i", PI[id][p_id]);
        mysql_tquery(SQL, query);

        new logstr[100];
        format(logstr, sizeof logstr, "DOZVOLA VOZNJA | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    else if (listitem == 3) // Dozvola za oruzje
    {
        if (PI[id][p_dozvola_oruzje] == 0)
        {
            ErrorMsg(playerid, "Taj igrac nema dozvolu za oruzje.");
            return DialogReopen(playerid);
        }

        PI[id][p_dozvola_oruzje] = 0;

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo dozvolu za oruzje.", ime_rp[playerid]);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste %s dozvolu za oruzje.", ime_rp[id]);

        new query[60];
        format(query, sizeof query, "UPDATE igraci SET dozvola_oruzje = 0 WHERE id = %i", PI[id][p_id]);
        mysql_tquery(SQL, query);

        new logstr[100];
        format(logstr, sizeof logstr, "DOZVOLA ORUZJE | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    else if (listitem == 4) // Dozvola za letenje
    {
        if (PI[id][p_dozvola_letenje] == 0)
        {
            ErrorMsg(playerid, "Taj igrac nema dozvolu za letenje.");
            return DialogReopen(playerid);
        }

        PI[id][p_dozvola_letenje] = 0;

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo dozvolu za letenje.", ime_rp[playerid]);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste %s dozvolu za letenje.", ime_rp[id]);

        new query[60];
        format(query, sizeof query, "UPDATE igraci SET dozvola_letenje = 0 WHERE id = %i", PI[id][p_id]);
        mysql_tquery(SQL, query);

        new logstr[100];
        format(logstr, sizeof logstr, "DOZVOLA LETENJE | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    else if (listitem == 5) // Dozvola za plovidbu
    {
        if (PI[id][p_dozvola_plovidba] == 0)
        {
            ErrorMsg(playerid, "Taj igrac nema dozvolu za plovidbu.");
            return DialogReopen(playerid);
        }

        PI[id][p_dozvola_plovidba] = 0;

        SendClientMessageF(id, SVETLOCRVENA, "* Sluzbenik %s Vam je oduzeo dozvolu za plovidbu.", ime_rp[playerid]);
        SendClientMessageF(playerid, SVETLOPLAVA, "* Oduzeli ste %s dozvolu za plovidbu.", ime_rp[id]);

        new query[60];
        format(query, sizeof query, "UPDATE igraci SET dozvola_plovidba = 0 WHERE id = %i", PI[id][p_id]);
        mysql_tquery(SQL, query);

        new logstr[100];
        format(logstr, sizeof logstr, "DOZVOLA PLOVIDBA | %s je oduzeo od %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_SEIZE, logstr);
    }
    return 1;
}*/

Dialog:frisk(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "POLICE_FriskID");
        return 1;
    }

    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new targetid = GetPVarInt(playerid, "POLICE_FriskID");
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    gPoliceInteraction[targetid] = gettime() + 30;

    if (listitem == 0) // Stvari
    {
        new string[512], sItemName[25];
        format(string, 29, "ID\tNaziv predmeta\tKolicina");
        for__loop (new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
        {
            if (i == ITEM_RANAC || BP_PlayerItemGetCount(targetid, i) <= 0 || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

            BP_GetItemName(i, sItemName, sizeof sItemName);
            format(string, sizeof string, "%s\n%i\t%s\t%i", string, i, sItemName, BP_PlayerItemGetCount(targetid, i));
        }
        SPD(playerid, "frisk_items", DIALOG_STYLE_TABLIST_HEADERS, "PRETRES - STVARI", string, "Oduzmi", "- Nazad");
    }
    else if (listitem == 1) // Oruzje
    {
        new string[256], weapon[22];
        format(string, 23, "Slot\tOruzje\tMunicija");
        
        // Oruzje iz ranca
        {
            for__loop (new i = 0; i < BP_MAX_WEAPONS; i++) 
            {
                if (P_BACKPACK[targetid][BP_WEAPON][i] == -1 || P_BACKPACK[targetid][BP_AMMO][i] <= 0) continue;

                GetWeaponName(P_BACKPACK[targetid][BP_WEAPON][i], weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, P_BACKPACK[targetid][BP_AMMO][i]);
            }
        }

        // Oruzje u rukama
        {
            new weaponid, ammo, totalAmmoCount = 0;
            for__loop (new i = 0; i < 13; i++) 
            {
                weaponid    = GetPlayerWeaponInSlot(targetid, i);
                ammo        = GetPlayerAmmoInSlot(targetid, i);
                if (weaponid <= 0 || ammo <= 0) continue;

                totalAmmoCount += ammo;
                GetWeaponName(weaponid, weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i+10, weapon, ammo);
            }

            if (totalAmmoCount > 0 && GetPVarInt(targetid, "wantedForWeapons") < gettime())
            {
                new crimeLevel = floatround(totalAmmoCount/200.0, floatround_ceil) * 3; // 3xWL na svakih 200 metaka
                new reason[32];
                format(reason, sizeof reason, "Nosenje oruzja (%i metaka)", totalAmmoCount);

                if ((PI[targetid][p_dozvola_oruzje] > 0 && totalAmmoCount > 500) || PI[targetid][p_dozvola_oruzje] <= 0)
                {
                    // Ako ima dozvolu i preko 500 metaka  ILI  nema dozvolu --> dobija WL
                    AddPlayerCrime(targetid, playerid, crimeLevel, reason, ime_obicno[playerid]);
                    SetPVarInt(targetid, "wantedForWeapons", gettime()+300); // da se ne bi koristio pretres za nabijanje WL-a
                }
            }
        }

        SPD(playerid, "frisk_weapons", DIALOG_STYLE_TABLIST_HEADERS, "PRETRES - ORUZJE", string, "Oduzmi", "- Nazad");
    }
    else if (listitem == 2) // Droga
    {
            new string[180];
            format(string, sizeof string, "ID\tVrsta\tKolicina\n{000000}%i\t{FFFFFF}MDMA\t%i gr\n{000000}%i\t{FFFFFF}Heroin\t%i gr\n{000000}%i\t{FFFFFF}Sirovi kanabis\t%i gr\n{000000}%i\t{FFFFFF}Marihuana\t%i gr", ITEM_MDMA, BP_PlayerItemGetCount(targetid, ITEM_MDMA), ITEM_HEROIN, BP_PlayerItemGetCount(targetid, ITEM_HEROIN), ITEM_WEED_RAW, BP_PlayerItemGetCount(targetid, ITEM_WEED_RAW), ITEM_WEED, BP_PlayerItemGetCount(targetid, ITEM_WEED));
            SPD(playerid, "frisk_drugs", DIALOG_STYLE_TABLIST_HEADERS, "PRETRES - DROGA", string, "Oduzmi", "- Nazad");
    }

    return 1;
}

Dialog:frisk_items(playerid, response, listitem, const inputtext[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new targetid = GetPVarInt(playerid, "POLICE_FriskID");
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (!response)
    {
        new cmdParams[16];
        format(cmdParams, sizeof cmdParams, "/pretresi %i", targetid);
        PC_EmulateCommand(playerid, cmdParams);
    }
    else
    {
        new sItemName[25],
            itemid = strval(inputtext),
            itemCount = BP_PlayerItemGetCount(targetid, itemid);

        BP_GetItemName(itemid, sItemName, sizeof sItemName);
        StrToLower(sItemName);


        if (!BP_PlayerHasItem(targetid, itemid))
        {
            ErrorMsg(playerid, "Taj igrac nema %s u rancu.", sItemName);
            return DialogReopen(playerid);
        }

        if (itemid != ITEM_CROWBAR && itemid != ITEM_MATERIALS && itemid != ITEM_EXPLOSIVE && itemid != ITEM_DETONATOR)
        {
            DialogReopen(playerid);
            return ErrorMsg(playerid, "Ne mozete oduzeti legalne predmete.");
        }

        new string[128];
        format(string, sizeof string, "** %s oduzima %s (%i kom) iz ranca od %s.", ime_rp[playerid], sItemName, itemCount, ime_rp[targetid]);
        RangeMsg(playerid, string, LJUBICASTA, 20.0);

        BP_PlayerItemRemove(targetid, itemid);
        
        // Upisivanje u log
        new logStr[125];
        format(logStr, sizeof logStr, "PREDMET | %s je oduzeo od %s | Predmet: %s | Kolicina: %i", ime_obicno[playerid], ime_obicno[targetid], sItemName, itemCount);
        Log_Write(LOG_SEIZE, logStr);
    }
    return 1;
}

Dialog:frisk_drugs(playerid, response, listitem, const inputtext[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new targetid = GetPVarInt(playerid, "POLICE_FriskID");
    if (!IsPlayerNearPlayer(playerid, targetid))
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (!response)
    {
        new cmdParams[16];
        format(cmdParams, sizeof cmdParams, "/pretresi %i", targetid);
        PC_EmulateCommand(playerid, cmdParams);
    }
    else
    {
        new sItemName[25],
            itemid = strval(inputtext),
            itemCount = BP_PlayerItemGetCount(targetid, itemid);

        BP_GetItemName(itemid, sItemName, sizeof sItemName);
        StrToLower(sItemName);


        if (!BP_PlayerHasItem(targetid, itemid))
        {
            ErrorMsg(playerid, "Taj igrac nema %s u rancu.", sItemName);
            return DialogReopen(playerid);
        }

        new string[128];
        format(string, sizeof string, "** %s oduzima %s (%ig) iz ranca od %s.", ime_rp[playerid], sItemName, itemCount, ime_rp[targetid]);
        RangeMsg(playerid, string, LJUBICASTA, 20.0);

        if (itemCount > 0)
        {
            new crimeLevel = floatround(itemCount/50.0, floatround_ceil) * 3; // 3xWL na svakih 50g
            new reason[32];
            format(reason, sizeof reason, "Posedovanje droge (%i gr)", itemCount);
            AddPlayerCrime(targetid, playerid, crimeLevel, reason, ime_obicno[playerid]);
        }

        BP_PlayerItemRemove(targetid, itemid);
        
        // Upisivanje u log
        new logStr[125];
        format(logStr, sizeof logStr, "DROGA | %s je oduzeo od %s | Predmet: %s | Kolicina: %i", ime_obicno[playerid], ime_obicno[targetid], sItemName, itemCount);
        Log_Write(LOG_SEIZE, logStr);
    }
    return 1;
}

Dialog:frisk_weapons(playerid, response, listitem, const inputtext[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new targetid = GetPVarInt(playerid, "POLICE_FriskID");
    if (!IsPlayerNearPlayer(playerid, targetid))
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (!response)
    {
        new cmdParams[16];
        format(cmdParams, sizeof cmdParams, "/pretresi %i", targetid);
        PC_EmulateCommand(playerid, cmdParams);
    }
    else
    {
        new slot = strval(inputtext),
            weaponid, ammo, weapon[22];

        if (slot < 10)
        {
            // Oruzje iz ranca
            if (slot < 0 || slot >= BP_MAX_WEAPONS)
                return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

            weaponid = P_BACKPACK[targetid][BP_WEAPON][slot];
            ammo     = P_BACKPACK[targetid][BP_AMMO][slot];

            if (weaponid <= 0 || weaponid > 46)
                return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

            if (ammo < 1 || ammo > 50000)
                return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");


            P_BACKPACK[targetid][BP_AMMO][slot] = 0;
            P_BACKPACK[targetid][BP_WEAPON][slot] = -1;

            format(mysql_upit, 78, "DELETE FROM backpacks WHERE pid = %d AND item = %d", PI[targetid][p_id], weaponid);
            mysql_tquery(SQL, mysql_upit);
        }
        else
        {
            // Oruzje iz ruke (slot je uvecan za 10 kako bi se razlikovalo od oruzja iz ranca)
            slot -= 10;
            weaponid = GetPlayerWeaponInSlot(targetid, slot);
            ammo     = GetPlayerAmmoInSlot(targetid, slot);

            if (slot < 0 || slot > 12)
                return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

            if (weaponid == -1)
                return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

            if (ammo <= 0)
                return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

            SetPlayerAmmo(targetid, weaponid, 0);
        }

        new string[128];
        GetWeaponName(weaponid, weapon, sizeof(weapon));
        format(string, sizeof string, "** %s oduzima %s od %s.", ime_rp[playerid], weapon, ime_rp[targetid]);
        RangeMsg(playerid, string, LJUBICASTA, 20.0);
    }
    return 1;
}

Dialog:police_prepreke(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new model, Float:pos[4], barrier = -1, barrierStr[64];
    switch (listitem)
    {
        case 0: model = 2899;
        case 1: model = 2892;
        case 2: model = 1251;
        case 3: model = 1237;
        case 4: model = 1228;
        case 5: model = 1459;
        case 6: model = 1427;
        case 7: model = 4527;
        case 8: model = 981;
        case 9: // Izmeni prepreku
        {
            if (pBarriers[playerid] <= 0)
                return ErrorMsg(playerid, "Niste postavili nijednu prepreku.");

            new string[MAX_PLAYER_BARRIERS * (32)];
            string[0] = EOS;
            foreach (new i : iBarriers)
            {
                if (BarrierData[i][BARRIER_PLAYER_ID] == playerid)
                {
                    format(string, sizeof string, "%s\n%i\t%s", string, i, BarrierData[i][BARRIER_NAME]);
                }
            }
            SPD(playerid, "police_prepreke_izmeni", DIALOG_STYLE_LIST, "{FFFFFF}Izmeni prepreku", string, "Izmeni", "- Nazad");
            return 1;
        }
        case 10: // Ukloni prepreku
        {
            if (pBarriers[playerid] <= 0)
                return ErrorMsg(playerid, "Niste postavili nijednu prepreku.");

            new string[MAX_PLAYER_BARRIERS * (32)];
            string[0] = EOS;
            foreach (new i : iBarriers)
            {
                if (BarrierData[i][BARRIER_PLAYER_ID] == playerid)
                {
                    format(string, sizeof string, "%s\n%i\t%s", string, i, BarrierData[i][BARRIER_NAME]);
                }
            }
            SPD(playerid, "police_prepreke_ukloni", DIALOG_STYLE_LIST, "{FFFFFF}Ukloni prepreku", string, "Ukloni", "- Nazad");
            return 1;
        }
    }

    if (pBarriers[playerid] > MAX_PLAYER_BARRIERS)
    {
        ErrorMsg(playerid, "Mozete postaviti najvise %i prepreka. Uklonite neku da biste postavili novu.", MAX_PLAYER_BARRIERS);
        return DialogReopen(playerid);
    }

    for__loop (new i = 0; i < MAX_BARRIERS; i++)
    {
        if (!Iter_Contains(iBarriers, i))
        {
            barrier = i;
            break;
        }
    }
    if (barrier == -1)
        return ErrorMsg(playerid, "Dostignut je maksimalni broj postavljenih prepreka.");


    SetPVarInt(playerid, "pBarrierID", barrier);
    GetPlayerPos(playerid, pos[POS_X], pos[POS_Y], pos[POS_Z]);
    GetPlayerFacingAngle(playerid, pos[POS_A]);
    pos[POS_X] -= 6*floatcos(90-pos[POS_A], degrees);
    pos[POS_Y] += 6*floatcos(90-pos[POS_A], degrees);

    pBarriers[playerid]++;
    format(barrierStr, sizeof barrierStr, "%s\nID: {FFFFFF}%i", inputtext, barrier);
    format(BarrierData[barrier][BARRIER_NAME], 32, "%s", inputtext);
    BarrierData[barrier][BARRIER_PLAYER_ID] = playerid;
    BarrierData[barrier][BARRIER_3DTEXT] = Text3D:INVALID_3DTEXT_ID;
    BarrierData[barrier][BARRIER_MODEL] = model;
    BarrierData[barrier][BARRIER_POS][0] = pos[0];
    BarrierData[barrier][BARRIER_POS][1] = pos[1];
    BarrierData[barrier][BARRIER_POS][2] = pos[2];
    BarrierData[barrier][BARRIER_POS][3] = 0.0;
    BarrierData[barrier][BARRIER_POS][4] = 0.0;
    BarrierData[barrier][BARRIER_POS][5] = 0.0;
    BarrierData[barrier][BARRIER_OBJECT_ID] = CreateDynamicObject(model, pos[POS_X], pos[POS_Y], pos[POS_Z], 0.0, 0.0, 0.0);
    BarrierData[barrier][BARRIER_3DTEXT]    = CreateDynamic3DTextLabel(barrierStr, 0x9BC9CE80, pos[0], pos[1], pos[2], 10.0);
    EditDynamicObject(playerid, BarrierData[barrier][BARRIER_OBJECT_ID]);
    Iter_Add(iBarriers, barrier);

    TextDrawShowForPlayer(playerid, tdBarrierHint);

    new proxMsg[87];
    format(proxMsg, sizeof proxMsg, "* %s je postavio prepreku: %s.", ime_rp[playerid], BarrierData[barrier][BARRIER_NAME]);
    foreach (new i : Player)
    {
        if (IsACop(i) && IsPlayerOnLawDuty(i) && IsPlayerInRangeOfPoint(i, 50.0, pos[0], pos[1], pos[2]))
            SendClientMessage(i, LJUBICASTA, proxMsg);
    }

    new string[90];
    format(string, sizeof string, "%s | %s - postavljeno | ID: %d", ime_obicno[playerid], inputtext, barrier);
    Log_Write(LOG_PREPREKE, string);
    return 1;
}

Dialog:police_prepreke_izmeni(playerid, response, listitem, const inputtext[])
{
    new barrier = strval(inputtext);
    if (barrier < 0 || barrier >= MAX_BARRIERS)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (BarrierData[barrier][BARRIER_PLAYER_ID] != playerid)
        return ErrorMsg(playerid, "Mozete izmeniti samo prepreke koje ste Vi postavili.");

    if (!IsPlayerInRangeOfPoint(playerid, 10.0, BarrierData[barrier][BARRIER_POS][POS_X], BarrierData[barrier][BARRIER_POS][POS_Y], BarrierData[barrier][BARRIER_POS][POS_Z]))
        return ErrorMsg(playerid, "Ne nalazite se u blizini ove prepreke.");

    EditDynamicObject(playerid, BarrierData[barrier][BARRIER_OBJECT_ID]);
    TextDrawShowForPlayer(playerid, tdBarrierHint);
    SetPVarInt(playerid, "pBarrierID", barrier);
    SendClientMessageF(playerid, ZUTA, "Sada izmenjujete poziciju prepreke %i.", barrier);
    return 1;
}

Dialog:police_prepreke_ukloni(playerid, response, listitem, const inputtext[])
{
    new barrier = strval(inputtext);
    if (barrier < 0 || barrier >= MAX_BARRIERS)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (BarrierData[barrier][BARRIER_PLAYER_ID] != playerid)
        return ErrorMsg(playerid, "Mozete uloniti samo prepreke koje ste Vi postavili.");

    new proxMsg[87], Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    format(proxMsg, sizeof proxMsg, "* %s je uklonio prepreku: %s.", ime_rp[playerid], BarrierData[barrier][BARRIER_NAME]);
    foreach (new i : Player)
    {
        if (IsACop(i) && IsPlayerOnLawDuty(i) && IsPlayerInRangeOfPoint(i, 50.0, pos[0], pos[1], pos[2]))
            SendClientMessage(i, LJUBICASTA, proxMsg);
    }

    pBarriers[playerid] -= 1;
    DestroyDynamicObject(BarrierData[barrier][BARRIER_OBJECT_ID]);
    DestroyDynamic3DTextLabel(BarrierData[barrier][BARRIER_3DTEXT]);
    BarrierData[barrier][BARRIER_OBJECT_ID] = -1;
    BarrierData[barrier][BARRIER_3DTEXT] = Text3D:INVALID_3DTEXT_ID;
    BarrierData[barrier][BARRIER_PLAYER_ID] = INVALID_PLAYER_ID;
    Iter_Remove(iBarriers, barrier);

    new string[90];
    format(string, sizeof string, "%s | %s - unisteno | ID: %d", ime_obicno[playerid], BarrierData[barrier][BARRIER_NAME], barrier);
    Log_Write(LOG_PREPREKE, string);
    return 1;
}

Dialog:police_kazna(playerid, response, listitem, const inputtext[])
{
    new iznos = GetPVarInt(playerid, "police_kaznaIznos"), 
        officerid = GetPVarInt(playerid, "police_kaznaPlayerId"),
        razlog[32];

    GetPVarString(playerid, "police_kaznaRazlog", razlog, sizeof razlog);

    DeletePVar(playerid, "police_kaznaIznos");
    DeletePVar(playerid, "police_kaznaPlayerId");
    DeletePVar(playerid, "police_kaznaRazlog");

    if (iznos < 1 || iznos > 100000)
        return ErrorMsg(playerid, "Nevazeci iznos za placanje.");

    if (!IsACop(officerid))
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (!IsPlayerNearPlayer(playerid, officerid, 15.0))
    {
        ErrorMsg(playerid, "Placanje kazne nije uspelo, policajac nije u blizini.");
        ErrorMsg(officerid, "%s je pokusao da plati kaznu, ali ste previse daleko od njega.", ime_rp[playerid]);

        new logstr[117];
        format(logstr, sizeof logstr, "NOVCANA KAZNA - NEPLACENA | %s nije platio kaznu od %s (predaleko)", ime_obicno[playerid], ime_obicno[officerid]);
        Log_Write(LOG_KAZNE_POLICE, logstr);
        return 1;
    }

    if (gPoliceTicketPaidTime[playerid] > gettime())
        return ErrorMsg(officerid, "Igrac je nedavno vec platio kaznu (ili odbio da plati).");

    if (response)
    {
        if (!PlayerMoneySub_ex(playerid, iznos, true))
        {
            // Nema dovoljno u dzepu+banci
            ErrorMsg(playerid, "Placanje kazne nije uspelo, nemate dovoljno novca.");
            ErrorMsg(officerid, "%s je pokusao da plati kaznu, ali nema dovoljno novca.", ime_rp[playerid]);
            AddPlayerCrime(playerid, officerid, 1, "Neplacena kazna");

            new logstr[124];
            format(logstr, sizeof logstr, "NOVCANA KAZNA - NEPLACENA | %s nije platio kaznu od %s (nedovoljno novca)", ime_obicno[playerid], ime_obicno[officerid]);
            Log_Write(LOG_KAZNE_POLICE, logstr);
            return 1;
        }

        SendClientMessageF(officerid, 0x3498DBFF, "** PLACENA KAZNA | {FFFFFF}%s je platio kaznu i iznosu od %s.", ime_rp[playerid], formatMoneyString(iznos));
        PlayerMoneyAdd(officerid, iznos);

        new logstr[140];
        format(logstr, sizeof logstr, "NOVCANA KAZNA | %s je kaznio %s | %s | %s", ime_obicno[officerid], ime_obicno[playerid], formatMoneyString(iznos), razlog);
        Log_Write(LOG_KAZNE_POLICE, logstr);
    }
    else
    {
        InfoMsg(playerid, "Odbili ste da platite kaznu.");
        InfoMsg(officerid, "%s je odbio da plati kaznu.", ime_rp[playerid]);
        AddPlayerCrime(playerid, officerid, PI[officerid][p_org_rank]-MIN_RANK_KAZNA+1, "Neplacena kazna");

        new logstr[104];
        format(logstr, sizeof logstr, "NOVCANA KAZNA - ODBIJENO | %s nije platio kaznu od %s", ime_obicno[playerid], ime_obicno[officerid], formatMoneyString(iznos), razlog);
        Log_Write(LOG_KAZNE_POLICE, logstr);
    }

    gPoliceTicketPaidTime[playerid] = gettime()+300;
    return 1;
}

Dialog:cctv(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "CCTV_OldData");
        return 1;
    }

    if (pUsingCCTV[playerid] == -1)
    {
        InfoMsg(playerid, "Koristite levi/desni klik da idete napred/nazad. Koristite ponovo /cctv da prekinete gledanje.");
        TogglePlayerSpectating_H(playerid, true);
    }

    // SetPlayerCompensatedPos(playerid, CCTV[listitem][CCTV_CAMERA_POS][POS_X], CCTV[listitem][CCTV_CAMERA_POS][POS_Y], CCTV[listitem][CCTV_CAMERA_POS][POS_Z]);
    SetPlayerCameraPos(playerid, CCTV[listitem][CCTV_CAMERA_POS][POS_X], CCTV[listitem][CCTV_CAMERA_POS][POS_Y], CCTV[listitem][CCTV_CAMERA_POS][POS_Z]);
    SetPlayerCameraLookAt(playerid, CCTV[listitem][CCTV_CAMERA_LOOK_AT][POS_X], CCTV[listitem][CCTV_CAMERA_LOOK_AT][POS_Y], CCTV[listitem][CCTV_CAMERA_LOOK_AT][POS_Z]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    pUsingCCTV[playerid] = listitem;
    return 1;
}

Dialog:pokazidozvole(playerid, response, listitem, const inputtext[])
{
    if (!IsACop(playerid) || !IsPlayerOnLawDuty(playerid)) return 1;

    new targetid = GetPVarInt(playerid, "licenseShownID");
    DeletePVar(playerid, "licenseShownID");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, targetid, 10.0))
        return ErrorMsg(playerid, "Nalazite se previse daleko od igraca koji Vam je pokazao dozvole.");

    if (!PI[targetid][p_dozvola_voznja])
    {
        // Nema vozacku
        new vehicleid = GetPlayerLastDrivenVehicleID(targetid);
        if (GetPlayerState(targetid) == PLAYER_STATE_DRIVER || IsPlayerNearVehicle(targetid, vehicleid))
        {
            // Igrac je u vozilu ili pored vozila kojim je do nedavno upravljao
            if (GetPVarInt(targetid, "wantedForLicenses") < gettime())
            {
                AddPlayerCrime(targetid, playerid, 1, "Voznja bez vozacke dozvole");
                SetPVarInt(targetid, "wantedForLicenses", gettime()+300);
            }
        }
    }
    return 1;
}

Dialog:trazidozvole(playerid, response, listitem, const inputtext[])
{
    new targetid = GetPVarInt(playerid, "licenseCheckID"),
        ccinc = GetPVarInt(playerid, "licenseCheckCinc");

    DeletePVar(playerid, "licenseCheckID");
    DeletePVar(playerid, "licenseCheckCinc");

    if (!checkcinc(targetid, ccinc))
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (!IsPlayerNearPlayer(playerid, targetid))
        return ErrorMsg(playerid, "Nalazite se previse daleko od igraca koji je trazio dozvole na uvid.");

    if (!response)
    {
        SendClientMessageF(targetid, SVETLOCRVENA, "* %s je odbio da Vam pokaze svoje dozvole.", ime_rp[playerid]);
        if (GetPVarInt(playerid, "wantedForLicenses") < gettime())
        {
            // Odbio da pokaze -> WL
            AddPlayerCrime(playerid, targetid, 3, "Odbijanje kontrole");
            SetPVarInt(playerid, "wantedForLicenses", gettime()+300);
        }
    }
    else
    {
        new SendClientMessaged[19];
        format(SendClientMessaged, sizeof SendClientMessaged, "/pokazidozvole %i", targetid);
        PC_EmulateCommand(playerid, SendClientMessaged);
    }
    return 1;
}

Dialog:proverivozilo(playerid, response, listitem, const inputtext[])
{
    if (!IsACop(playerid) || !IsPlayerOnLawDuty(playerid)) return 1;

    new ammoCount = GetPVarInt(playerid, "vehCheckTotalAmmo"),
        regStatus = GetPVarInt(playerid, "vehCheckRegStatus"),
        vehicleid = GetPVarInt(playerid, "vehCheckID");

    DeletePVar(playerid, "vehCheckTotalAmmo");
    DeletePVar(playerid, "vehCheckRegStatus");
    DeletePVar(playerid, "vehCheckID");

    if (ammoCount > 1000 || regStatus == 0)
    {
        // Otkriven je neki prekrsaj -> trazimo da li je u blizini igrac koji je skoro upravljao proverenim vozilom
        new Float:x, Float:y, Float:z;
        GetVehiclePos(vehicleid, x, y, z);
        foreach (new i : Player)
        {
            if (i == playerid) continue;
            
            if (GetPlayerLastDrivenVehicleID(i) == vehicleid && IsPlayerInRangeOfPoint(i, 10.0, x, y, z))
            {
                if (!regStatus && !IsVehicleBicycle(GetVehicleModel(vehicleid)))
                {
                    AddPlayerCrime(i, playerid, 2, "Neregistrovano vozilo");
                }

                if (ammoCount > 1000)
                {
                    new wl = floatround(ammoCount/500.0, floatround_ceil);
                    AddPlayerCrime(i, playerid, wl, "Nedozvoljena kolicina oruzja");
                }

                break;
            }
        }
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:sos("bk", "poj", "pojacanje")
alias:prepreka("barikada")
alias:ukloniprepreku("uklonibarikadu", "unistibarikadu", "unistiprepreku", "izbrisiprepreku", "izbrisibarikadu")
alias:tazer("ta", "taser")
alias:pretresi("frisk", "pretres")
alias:rotacija("rot")

CMD:sos(playerid, const params[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    
    if(PI[playerid][p_org_rank] == 0) 
        return ErrorMsg(playerid, "Vi ste suspendovani sa duznosti!");
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

    if (PI[playerid][p_org_rank] < 3)
        return ErrorMsg(playerid, "Potreban Vam je rank 3 da biste mogli da pozovete pojacanje.");

    if (policeSOS_playerID != INVALID_PLAYER_ID)
    {
        // SOS je vec ukljucen

        if (policeSOS_playerID == playerid)
        {
            POLICE_SOSTurnOff();
            DepartmentMsg(BELA, "* %s je iskljucio poziv za pojacanje.", ime_rp[playerid]);

        }
        else ErrorMsg(playerid, "Neko je vec aktivirao poziv za pojacanje.");
        return 1;
    }



    policeSOS_playerID = playerid;
    tajmer:policeSOS = SetTimer("POLICE_SOSTimer", 3500, true);

    new Float:pos[3], lokacija[32];
    GetPlayerPos(policeSOS_playerID, pos[0], pos[1], pos[2]);
    GetPlayer2DZone(playerid, lokacija, sizeof lokacija);

    foreach (new i : Player)
    {
        if (IsACop(i) && i != policeSOS_playerID)
        {
            RemovePlayerMapIcon(i, MAPICON_POLICE_SOS);
            SetPlayerMapIcon(i, MAPICON_POLICE_SOS, pos[0], pos[1], pos[2], 30, 0, MAPICON_GLOBAL);
        }
    }

    DepartmentMsg(CRVENA, "*** {0000FF}S O S {FF0000}*** {FFFFFF}%s trazi pojacanje na lokaciji %s {FF0000}*** {0000FF}S O S {FF0000}***", ime_rp[playerid], lokacija);
    return 1;
}

CMD:prepreka(playerid, const params[]) 
{    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    
    if(PI[playerid][p_org_rank] == 0) 
        return ErrorMsg(playerid, "Vi ste suspendovani sa duznosti!");
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");


    SPD(playerid, "police_prepreke", DIALOG_STYLE_LIST, "{FFFFFF}Prepreke", "Prepreka za gume (mala)\nPrepreka za gume (velika)\nLezeci policajac\nMali stub\nMala blokada 1\nMala blokada 2\nMala blokada 3\nSrednja blokada\nVelika blokada\n\n-- Izmeni prepreku\n--- Ukloni prepreku", "Izaberi", "Izadji");
    return 1;
}

CMD:ukloniprepreku(playerid, const params[])
{
    if (!IsAdmin(playerid, 2))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU), SendClientMessage(playerid, -1, "* Koristite /prepreka -> ukloni prepreku.");

    new id;
    if (sscanf(params, "i", id))
    {
        if (IsAdmin(playerid, 6))
            return Koristite(playerid, "ukloniprepreku [ID prepreke (-1 da unistis sve prepreke)]");
        else
            return Koristite(playerid, "ukloniprepreku [ID prepreke]");
    }

    if (!IsAdmin(playerid, 6) && id == -1)
        return ErrorMsg(playerid, "Uneli ste nevazeci ID prepreke.");

    if (IsAdmin(playerid, 6) && (id < -1 || id >= MAX_BARRIERS))
        return ErrorMsg(playerid, "Uneli ste nevazeci ID prepreke.");

    if (!IsAdmin(playerid, 6) && (id < 0 || id >= MAX_BARRIERS))
        return ErrorMsg(playerid, "Uneli ste nevazeci ID prepreke.");

    if (id >= 0 && (!IsValidDynamicObject(BarrierData[id][BARRIER_OBJECT_ID]) || !IsPlayerConnected(BarrierData[id][BARRIER_PLAYER_ID])))
        return ErrorMsg(playerid, "Uneta prepreka nije kreirana.");

    AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je unistio prepreku ID %i, koju je postavio policajac %s.", ime_rp[playerid], id, ime_rp[BarrierData[id][BARRIER_PLAYER_ID]]);
    SendClientMessageF(BarrierData[id][BARRIER_PLAYER_ID], BELA, "{FF6347}- STAFF:{B4CDED} %s je unistio prepreku ID %i koju ste postavili (%s).", ime_rp[playerid], id, (StrToLower(BarrierData[id][BARRIER_NAME]), BarrierData[id][BARRIER_NAME]));

    pBarriers[BarrierData[id][BARRIER_PLAYER_ID]] -= 1;
    DestroyDynamicObject(BarrierData[id][BARRIER_OBJECT_ID]);
    DestroyDynamic3DTextLabel(BarrierData[id][BARRIER_3DTEXT]);
    BarrierData[id][BARRIER_OBJECT_ID] = -1;
    BarrierData[id][BARRIER_3DTEXT] = Text3D:INVALID_3DTEXT_ID;
    BarrierData[id][BARRIER_PLAYER_ID] = INVALID_PLAYER_ID;
    Iter_Remove(iBarriers, id);

    new string[90];
    format(string, sizeof string, "%s | %s - unisteno (A) | ID: %d", ime_obicno[playerid], BarrierData[id][BARRIER_NAME], id);
    Log_Write(LOG_PREPREKE, string);
    return 1;
}   

CMD:lisice(playerid, const params[]) 
{
    new
        f_id = PI[playerid][p_org_id],
        r_id = PI[playerid][p_org_rank],
        targetid
    ;
    
    if (!IsACop(playerid))
    {
        if (IsACriminal(playerid))
        {
            new SendClientMessaged[45];
            format(SendClientMessaged, sizeof SendClientMessaged, "/skinilisice %s", params);
            return PC_EmulateCommand(playerid, SendClientMessaged);
        }
        else return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    }
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "lisice [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu na sebi.");
        
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (IsPlayerAFK(targetid))
        return ErrorMsg(playerid, "Ne mozete staviti lisice ovom igracu jer je AFK.");
        
    if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
        
    if (PI[targetid][p_org_id] == f_id && PI[targetid][p_org_rank] >= r_id) // Ista organizacija i veci ili isti rank
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima istog ili viseg ranka.");
        
    if (IsPlayerRopeTied(targetid))
        return ErrorMsg(playerid, "Ovaj igrac je vec zavezan uzetom, ne mozete mu staviti lisice.");
        
    if (IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Igrac mora biti van vozila.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");
        
    
    if (!gPlayerHandcuffed{targetid}) 
    {
        // Nema lisice -> stavi
        
        // Bio je sokiran kad su mu stavljene lisice? -> spreci unfreeze kada istekne timer
        ClearAnimations(targetid, 1);
        KillTimer(TaserData[targetid][GetupTimer]);
        TaserData[targetid][GetupTimer] = 0;
        TaserData[targetid][TaserCountdown] = 0;

        // Ako neko vuce ovog igraca -> zaustaviti
        if (IsPlayerAttachedToPlayer(targetid))
        {
            StopFollowingPlayer(targetid);
        }

        gPlayerHandcuffed{targetid} = true;
        PI[targetid][p_zavezan]  = 1;
        
        TogglePlayerControllable_H(targetid, false);
        SetPlayerCuffed(targetid, 1);
        
        // Slanje poruka igracima
        SendClientMessageF(playerid, SVETLOPLAVA, "* Stavili ste lisice %s[%d].", ime_rp[targetid], targetid);
        SendClientMessageF(targetid, ZUTA, "* %s Vam je stavio lisice na ruke.", ime_rp[playerid]);
        GameTextForPlayer(targetid, "~n~~n~~n~~r~~h~UHAPSEN!", 3000, 3);

        new string[85];
        format(string, sizeof string, "* %s vadi lisice i stavlja ih %s.", ime_rp[playerid], ime_rp[targetid]);
        RangeMsg(playerid, string, LJUBICASTA, 15.0);
        format(string, sizeof string, "** lisice su stegnute na poslednji zubac (( %s )).", ime_rp[playerid]);
        RangeMsg(playerid, string, LJUBICASTA, 15.0);



        // Uhapseni igrac pljacka zlataru?
        if (IsPlayerRobbingJewelry(targetid))
        {    
            if (IsPlayerAttachedObjectSlotUsed(targetid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(targetid, SLOT_BACKPACK);

            FactionMsg(GetFactionRobbingJeweley(), "{FF0000}Pljacka zlatare je propala jer je policija uhvatila %s.", ime_rp[targetid]);
            FactionMsg(PI[playerid][p_org_id], "{4655B2}* Odvedite %s u zatvor da biste dobili novcanu nagradu!", ime_rp[targetid]);

            SendClientMessageToAll(BELA, "Vesti | {FF6347}Policijske snage su brzom reakcijom uspele da zaustave pljacku zlatare!");
            // SendClientMessageToAll(SVETLOCRVENA2, "    - Pripadnici specijalnih snaga se jos uvek bore sa za sada nepoznatom grupom razbojnika.");

            // Upisivanje u log
            new logStr[63];
            format(logStr, sizeof logStr, "ZLATARA-FAIL | %s je uhapsen (lisice)", ime_obicno[targetid]);
            Log_Write(LOG_ROBBERY, logStr);

            jRob_Reset();
        }

        // Uhapseni igrac pljacka banku?
        if (IsPlayerRobbingBank(targetid))
        {    
            if (IsPlayerAttachedObjectSlotUsed(targetid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(targetid, SLOT_BACKPACK);

            FactionMsg(GetFactionRobbingBank(), "{FF0000}Pljacka banke je propala jer je policija uhvatila %s.", ime_rp[targetid]);
            FactionMsg(PI[playerid][p_org_id], "{4655B2}* Odvedite %s u zatvor da biste dobili novcanu nagradu!", ime_rp[targetid]);

            SendClientMessageToAll(BELA, "Vesti | {FF6347}Policijske snage su brzom reakcijom uspele da zaustave pljacku banke!");
            // SendClientMessageToAll(SVETLOCRVENA2, "    - Pripadnici specijalnih snaga se jos uvek bore sa za sada nepoznatom grupom razbojnika.");

            // Upisivanje u log
            new logStr[61];
            format(logStr, sizeof logStr, "BANKA-FAIL | %s je uhapsen (lisice)", ime_obicno[targetid]);
            Log_Write(LOG_ROBBERY, logStr);

            bRob_Reset();
        }

        // Uhapseni igrac pljacka bankomat/krade vozilo/obija skladiste s oruzjem?
        if (IsPlayerBurglaryActive(targetid))
        {
            if (IsPlayerStealingVehicle(targetid))
            {
                AddPlayerCrime(targetid, playerid, 2, "Pokusaj kradje vozila", ime_obicno[playerid]);
            }
            else if (IsPlayerRobbingWeaponsWH(targetid))
            {
                AddPlayerCrime(targetid, playerid, 2, "Pokusaj provale", ime_obicno[playerid]);
            }

            CallRemoteFunction("OnBurglaryStop", "i", targetid);
        }
    }
    else
    { 
        // Ima lisice -> skini
        gPlayerHandcuffed{targetid} = false;
        PI[targetid][p_zavezan]  = 0;
        
        TogglePlayerControllable_H(targetid, true);
        SetPlayerCuffed(targetid, 0);
        
        // Slanje poruka igracima
        SendClientMessageF(playerid, SVETLOPLAVA, "* Skinuli ste lisice %s[%d].", ime_rp[targetid], targetid);
        SendClientMessageF(targetid, ZUTA, "* %s Vam je skinuo lisice sa ruku.", ime_rp[playerid]);

        new string[72];
        format(string, sizeof string, "* %s skida lisice %s.", ime_rp[playerid], ime_rp[targetid]);
        RangeMsg(playerid, string, LJUBICASTA, 15.0);
    }
    return 1;
}

CMD:m(const playerid, params[145]) 
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (IsPlayerRegistering(playerid)) 
        return ErrorMsg(playerid, GRESKA_REGISTRACIJA);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
        
    if (isnull(params)) 
        return Koristite(playerid, "m [Tekst]");
        
    if (!IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili megafon.");

    new 
        f_id = PI[playerid][p_org_id],
        vehicleid = GetPlayerVehicleID(playerid);

    // Provera za policijsko vozilo
    new bool:ok = false;
    for__loop (new j = 0; j < MAX_FACTIONS; j++) 
    {
        if (FACTIONS[j][f_vrsta] != FACTION_LAW) continue;

        for__loop (new i = 0; i < FACTIONS[f_id][f_max_vozila]; i++) 
        {
            if (F_VEHICLES[j][i][fv_vehicle_id] == vehicleid) 
            {
                ok = true;
                break;
            }
        }
    }
    if (!ok)
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili megafon.");
        
        
    koristio_chat[playerid] = gettime() + 3;
    zastiti_chat(playerid, params);
    
    new chat_string[145];
    StrToUpper(params);
    if (!strcmp(PI[playerid][p_naglasak], "Nista")) 
    {
        format(chat_string, sizeof chat_string, "** %s (megafon): %s!!!", ime_rp[playerid], params);
    }
    else 
    {
        format(chat_string, sizeof chat_string, "** %s (megafon): [%s] %s!!!", ime_rp[playerid], PI[playerid][p_naglasak], params);
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
        {
            gPoliceInteraction[i] = gettime() + 15;
            SendClientMessage(i, SVETLOZUTA, chat_string);
        }
    }
    return 1;
}

CMD:pu(playerid, const params[]) 
{
    new
        f_id = PI[playerid][p_org_id],
        targetid,
        sediste
    ;
    
    if (!IsACop(playerid) && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (IsACop(playerid) && !IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu (kao vozac) da biste koristili ovu naredbu.");

    if (IsACop(playerid) && !IsLawVehicle(GetPlayerVehicleID(playerid)))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");

    if (IsACriminal(playerid) && !IsFactionVehicle(GetPlayerVehicleID(playerid), f_id) && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, "Morate biti u vozilu svoje %s da biste koristili ovu naredbu.", faction_name(f_id, FNAME_GENITIV));
        
    if (sscanf(params, "ui", targetid, sediste))
        return Koristite(playerid, "pu [Ime ili ID igraca] [Sediste (1 = suvozac, 2 = pozadi levo, 3 = pozadi desno)]");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu na sebi.");
        
    if (sediste != 1 && sediste != 2 && sediste != 3)
        return ErrorMsg(playerid, "Uneli ste nepoznat broj sedista.");
        
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
        
    if (PI[targetid][p_org_id] == f_id) // Ista organizacija
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima svoje organizacije.");
        
    if (IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Igrac mora biti van vozila.");

    if (!IsPlayerHandcuffed(targetid))
        return ErrorMsg(playerid, "Morate staviti lisice igracu da biste mogli da ga ubacite u vozilo.");
    
    
    new vehid = GetPlayerVehicleID(playerid);
    foreach (new i : Player) 
    {
        if (GetPlayerVehicleID(i) == vehid && GetPlayerVehicleSeat(i) == sediste)
            return ErrorMsg(playerid, "To sediste je vec zauzeto.");
    }

    // Ako neko vuce ovog igraca -> zaustaviti
    if (IsPlayerAttachedToPlayer(targetid))
    {
        StopFollowingPlayer(targetid);
    }
    
    PutPlayerInVehicle(targetid, vehid, sediste);

    if (IsACop(playerid))
    {
        new string[128];
        format(string, sizeof string, "* Sluzbenik %s otvara vrata vozila i ubacuje osumnjicenog unutra.", ime_rp[playerid]);
        RangeMsg(playerid, string, LJUBICASTA, 15.0);
    }
    // if (IsACriminal(playerid))
    // {
    //     new string[128];
    //     format(string, sizeof string, "* %s otvara vrata vozila i nasilno ubacuje %s unutra.", ime_rp[playerid], ime_rp[targetid]);
    //     RangeMsg(playerid, string, LJUBICASTA, 15.0);
    // }
    return 1;
}

CMD:bork(playerid, const params[])
{
    new targetid;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
        return ErrorMsg(playerid, "Morate biti na mestu putnika u vozilu da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "bork [Ime ili ID igraca]");
        
    if (playerid == targetid)
        return ErrorMsg(playerid, "Ne mozete osumnjiciti sami sebe.");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (IsPlayerWanted(targetid))
        return ErrorMsg(playerid, "Igrac vec ima Wanted Level.");
        
    if (IsACop(targetid))
        return ErrorMsg(playerid, "Igrac je pripadnik policije, ne mozete mu povecati Wanted Level.");
        
    if (PI[targetid][p_nivo] < 4)
        return ErrorMsg(playerid, "Igrac ima previse mali nivo da biste ga osumnjicili.");

    if (GetPlayerState(targetid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Igrac ne upravlja nikakvim vozilom.");

    //if (!IsPlayerNearPlayer(playerid, targetid, 80.0) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
      //  return ErrorMsg(playerid, "Previse ste daleko od tog igraca.");

    if (IsPlayerAFK(targetid))
        return ErrorMsg(playerid, "Igrac je AFK.");

    if (gPoliceInteraction[targetid] < gettime())
        return ErrorMsg(playerid, "Server nije prepoznao da ste pokusali da zaustavite ovog igraca na propisan nacin. (niste koristili /m)");
        
    AddPlayerCrime(targetid, playerid, 3, "Bezanje od rutinske kontrole");
    return 1;
}

CMD:su(playerid, const params[]) 
{
    InfoMsg(playerid, "Komanda /su je ukinuta. Igraci automatski dobijaju WL za svoje prekrsaje.");
    InfoMsg(playerid, "Za prekrsaj {FFFFFF}bezanje od rutinske kontrole: {FFFF00}/bork");

    // new
    //     id,
    //     nivo,
    //     razlog[MAX_CRIME_TEXT]
    // ;
    
    // if (!IsACop(playerid))
    //     return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    // if (!IsPlayerOnLawDuty(playerid))
    //     return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    // if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
    //     return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");
        
    // if (sscanf(params, "uis[" #MAX_CRIME_TEXT "]", id, nivo, razlog))
    //     return Koristite(playerid, "su [Ime ili ID igraca] [Nivo] [Razlog]");
        
    // if (playerid == id)
    //     return ErrorMsg(playerid, "Ne mozete osumnjiciti sami sebe.");
        
    // if (!IsPlayerConnected(id))
    //     return ErrorMsg(playerid, GRESKA_OFFLINE);
        
    // if (nivo < 1 || nivo > 5)
    //     return ErrorMsg(playerid, "Trazeni nivo mora biti izmedju 1 i 5.");
        
    // if (PI[id][p_org_id] != -1 && FACTIONS[PI[id][p_org_id]][f_vrsta] == FACTION_LAW)
    //     return ErrorMsg(playerid, "Igrac je pripadnik policije, ne mozete mu povecati trazeni nivo.");
        
    // if (PI[id][p_nivo] < 4)
    //     return ErrorMsg(playerid, "Igrac ima previse mali nivo da biste ga osumnjicili.");

        
    // AddPlayerCrime(id, playerid, nivo, razlog);

    return 1;
}

CMD:uhapsi(playerid, const params[])
{
    new
        targetid,
        cena,
        vreme,
        kaucija[3],
        kaucija_cena,
        kaucijaStr[20]
    ;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    // if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
    //     return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");

    if (!IsPlayerInArea(playerid, 1532.5935, -1708.9698, 1589.3744,-1611.1423) && !IsPlayerInArea(playerid, 1415.2610,670.9660, 1556.4900,728.3267) && !IsPlayerInRangeOfPoint(playerid, 5.0, 1771.1769,-1546.9315,9.9188))
        return ErrorMsg(playerid, "Morate biti ispred PD ili SWAT baze da biste izvrsili hapsenje.");
        
    if (sscanf(params, "us[3]I(0)", targetid, kaucija, kaucija_cena))
        return Koristite(playerid, "uhapsi [Ime ili ID igraca] [Kaucija (da/ne)] [Cena kaucije]");
        
    if (playerid == targetid)
        return ErrorMsg(playerid, "Ne mozete uhapsiti sami sebe.");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);
        
    if (IsACop(targetid))
        return ErrorMsg(playerid, "Igrac je pripadnik policije, ne mozete ga uhapsiti.");
        
    if (PI[targetid][p_nivo] < 4)
        return ErrorMsg(playerid, "Igrac ima previse mali nivo da biste ga uhapsili.");
        
    if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(targetid))
        return ErrorMsg(playerid, "Igrac mora biti u Vasem vozilu da biste ga uhapsili.");
        
    if (GetPlayerCrimeLevel(targetid) == 0)
        return ErrorMsg(playerid, "Ovaj igrac nije na listi trazenih, ne mozete ga uhapsiti.");

    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od tog igraca.");
        
    // if (cena < 1000 || cena > 50000)
    //     return ErrorMsg(playerid, "Iznos kazne moze biti najmanje $1.000, a najvise $50.000.");
        
    // if (vreme < 3 || vreme > 20)
    //     return ErrorMsg(playerid, "Vreme zatvaranja moze biti najmanje 3, a najvise 20 minuta.");
        
        
    if (!strcmp(kaucija, "da", true, 2)) // Ima pravo na kauciju
    {
        if (kaucija_cena < 10000 || kaucija_cena > 500000)
            return ErrorMsg(playerid, "Cena kaucije moze biti najmanje $10.000, a najvise $500.000.");

        PI[targetid][p_kaucija] = kaucija_cena;
        
        format(kaucijaStr, sizeof kaucijaStr, "da (%s)", formatMoneyString(kaucija_cena));
    }
    else if (!strcmp(kaucija, "ne", true, 2)) // Nema pravo na kauciju
    {
        PI[targetid][p_kaucija] = 0;
        format(kaucijaStr, 3, "ne");
    }
    else
        return ErrorMsg(playerid, "Nepoznat unos za polje \"kaucija\", unesite samo \"da\" ili \"ne\".");
        

    cena = GetPlayerCrimeLevel(targetid) * 500;
    vreme = GetPlayerCrimeLevel(targetid) * 1;
    // FactionMoneyAdd(f_id, cena);

    // Ako neko vuce ovog igraca -> zaustaviti
    if (IsPlayerAttachedToPlayer(targetid))
    {
        StopFollowingPlayer(targetid);
    }
    
    
    PI[targetid][p_zatvoren] += vreme * 5; // Dobice znaci igrac 5 markera po minuti -  staro: vreme * 60; ovo vazi za sekunde!
    PI[targetid][p_uhapsen_puta] ++;
    PI[targetid][p_zavezan]  = 0;
    gPlayerHandcuffed{targetid} = false;
    stavi_u_zatvor(targetid, false);
    PlayerMoneySub_ex(targetid, cena, true);
    PlayerMoneyAdd(playerid, cena*2); // nagrada za policajca, $1000 po WL
    TogglePlayerControllable_H(targetid, true);
    SetPlayerCuffed(targetid, 0);

    // matematicke operacije se ponekad cudno ponasaju, pa se ovo mora uraditi ovako :(
    new negativeSkill = floatround(GetPlayerCrimeLevel(targetid)/5.0, floatround_ceil);
    negativeSkill = negativeSkill - 2*negativeSkill;
    PlayerUpdateCriminalSkill(targetid, negativeSkill, SKILL_ARREST, 0);

    new skill = floatround(GetPlayerCrimeLevel(targetid)/5.0, floatround_ceil);


    // Slanje poruke uhapsenom igracu
    SendClientMessageF(targetid, SVETLOCRVENA, "Uhapseni ste od pripadnika policije %s i kaznjeni sa %s. | Trajanje: %d min, kaucija: %s", ime_rp[playerid], formatMoneyString(cena), vreme, kaucijaStr);
    
    // Slanje poruke igracu koji je izvrsio hapsenje
    SendClientMessageF(playerid, SVETLOPLAVA, "Uhapsili ste %s | Trajanje: %d min, kazna: %s, kaucija: %s", ime_rp[targetid], vreme, formatMoneyString(cena), kaucijaStr);
    
    // Slanje poruke svim online igracima + nagrade za banku/zlataru
    new bounty = 0;
    if (targetid == GetJewelryPoliceTarget())
    {
        bounty = floatround((GetJewelryRobBounty())/10000) * 10000 * 2;
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku zlatare je uhvacen i priveden pravdi.", ime_rp[targetid]);
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(bounty));

        RemoveJewelryPoliceTarget();

        new sLog[65];
        format(sLog, sizeof sLog, "ZLATARA-HAPSENJE | %s | %s", ime_obicno[playerid], formatMoneyString(bounty));
        Log_Write(LOG_ROBBERY, sLog);

        skill += 5;
    }
    else if (targetid == GetBankPoliceTarget())
    {
        bounty = floatround(GetBankRobBounty()/10000) * 10000 * 2;
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je uhvacen i priveden pravdi.", ime_rp[targetid]);
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(bounty));

        RemoveBankPoliceTarget();

        new sLog[65];
        format(sLog, sizeof sLog, "BANKA-HAPSENJE | %s | %s", ime_obicno[playerid], formatMoneyString(bounty));
        Log_Write(LOG_ROBBERY, sLog);

        skill += 6;
    }
    else
    {
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalac %s je uhapsen od strane pripadnika policije %s.", ime_rp[targetid], ime_rp[playerid]);
    }

    // Skill UP za policajca i njegove pomocnike + nagrade za banku/zlataru
    new Float:x,Float:y,Float:z,
        totalRanks = 0,
        Iterator:iAwardPlayers<MAX_PLAYERS>;
    Iter_Clear(iAwardPlayers);
    GetPlayerPos(playerid, x, y, z);
    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, 12.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i) && !IsPlayerAFK(i))
        {
            if (bounty > 0)
            {
                totalRanks += PI[i][p_org_rank];
                Iter_Add(iAwardPlayers, i);
            }
            PlayerUpdateCopSkill(i, skill, SKILL_ARREST, (i==playerid)? 0 : 1);
        }
    }

    if (bounty > 0)
    {    
        new sLog[75];
        format(sLog, sizeof sLog, "- Raspodela novca (rank suma = %i, igraca = %i)", totalRanks, Iter_Count(iAwardPlayers));
        Log_Write(LOG_ROBBERY, sLog);

        foreach (new p : iAwardPlayers)
        {
            new cash = floatround(bounty/totalRanks * PI[p][p_org_rank]);
            PlayerMoneyAdd(p, cash);
            SendClientMessageF(p, BELA, "* Vi ste rank %i. Zaradili ste {00FF00}%s {FFFFFF}zbog sprecavanja pljacke.", PI[p][p_org_rank], formatMoneyString(cash));

            format(sLog, sizeof sLog, "--- %s | %s | Rank %i", ime_obicno[p], formatMoneyString(cash), PI[p][p_org_rank]);
            Log_Write(LOG_ROBBERY, sLog);
        }
    }
    
    // Update podataka u bazi
    new sQuery[125];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET zatvoren = %d, uhapsen_puta = %d, kaucija = %d, zavezan = 0, wanted_level = 0 WHERE id = %d", PI[targetid][p_zatvoren], PI[targetid][p_uhapsen_puta], PI[playerid][p_kaucija], PI[targetid][p_id]);
    mysql_tquery(SQL, sQuery);


    // Info za kauciju
    if (PI[targetid][p_kaucija] > 0)
    {
        SendClientMessageF(targetid, INFOPLAVA, "Imate mogucnost da platite kauciju u iznosu od %s, i na taj nacin izadjete odmah iz zatvora.", formatMoneyString(kaucija_cena));
        SendClientMessageF(targetid, INFOPLAVA, "Da biste platili kauciju, jednostavno upisite {FFFFFF}/kaucija.");
    }
    

    // Upisivanje u log
    new sLog[165];
    format(sLog, sizeof sLog, "HAPSENJE | %s je uhapsio %s | %d min | %s | Kaucija: %s | WL: %d", ime_obicno[playerid], ime_obicno[targetid], vreme, formatMoneyString(cena), string_32, GetPlayerCrimeLevel(targetid));
    Log_Write(LOG_KAZNE_POLICE, sLog);
    

    // Resetovanje wanted levela
    ClearPlayerRecord(targetid, true);
    return 1;
}

CMD:vlada(const playerid, params[145]) 
{
    new
        r_id = PI[playerid][p_org_rank];
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (r_id != RANK_LEADER)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (isnull(params)) 
        return Koristite(playerid, "vlada [Tekst]");

    zastiti_chat(playerid, params);
        
    new chat_string[145];
    format(chat_string, sizeof chat_string, "Sluzbenik %s: {FFFFFF}%s", ime_rp[playerid], params);
    SendClientMessageToAll(PLAVA, "_________________ ZVANICNO SAOPSTENJE _________________");
    SendClientMessageToAll(PLAVA, chat_string);
    
    return 1;
}

CMD:lociraj(playerid, const params[])
{   
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");

    if (GetPVarInt(playerid, "pPhoneLocatorReload") > gettime())
        return ErrorMsg(playerid, "Morate sacekati jos %s pre sledeceg lociranja.");
        
    
    /////////////////////////////////////////////////////////////////////////////////////////////////
    // TRAZENJE BROJA TELEFONA

    if (isnull(params) || strlen(params) < 3)
        return Koristite(playerid, "lociraj [Broj telefona]");

    new 
        broj_telefona = -1,
        broj_telefona_str[8],
        pozivni_broj[4],
        mreza[11],
        targetid = -1 // Id igraca koji se poziva
    ;
    
    if (sscanf(params, "p</>s[4]s[8]", pozivni_broj, broj_telefona_str)) 
    {
        // Broj koji je uneo nema crtice (npr. 063123456 ili nesto peto)

        pozivni_broj[0] = params[0];
        pozivni_broj[1] = params[1];
        pozivni_broj[2] = params[2];
        
        new tel[12];
        format(tel, sizeof tel, "%s", params);
        strdel(tel, 0, 3);
        broj_telefona = strval(tel);
    }
    else 
    {
        // Formiranje broja telefona (brisanje srednje crte)
        strdel(broj_telefona_str, 3, 4);
        broj_telefona = strval(broj_telefona_str);
        
        // Da li je uneo dobar pozivni broj?
        if (!strcmp(pozivni_broj, "063"))       mreza = "Telenor";
        else if (!strcmp(pozivni_broj, "065"))  mreza = "m:tel";
        else if (!strcmp(pozivni_broj, "098"))  mreza = "T-Mobile";
        else return ErrorMsg(playerid, "Uneli ste nepostojeci pozivni broj. Koristite 063, 065 ili 098.");
    }
    
    // Da li je broj telefona sestocifren?
    if (broj_telefona < 100000 || broj_telefona > 999999)
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");
    
    // 0 je default vrednost za p_sim_broj, pa je bolje da se to ne proverava u foreach petlji, ako se nekim slucajem dogodi
    if (broj_telefona == 0)
        return ErrorMsg(playerid, "[phone.pwn] "GRESKA_NEPOZNATO" (01)");
    
    foreach (new i : Player) 
    {
        // Provera svih igraca za njihovu mrezu i broj telefona
        if (!strcmp(PI[i][p_sim], mreza) && PI[i][p_sim_broj] == broj_telefona) 
        {
            targetid = i;
            break;
        }
    }
    if (targetid == -1)
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona.");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, "Uneli ste nepostojeci broj telefona. (02)");

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne moete locirati sebe.");
    /////////////////////////////////////////////////////////////////////////////////////////////////
        
    KillTimer(tajmer:pPhoneLocator[playerid]), tajmer:pPhoneLocator[playerid] = 0;
        
    // Oznacavanje na mapi
    GetPlayerPos(targetid, pozicija[targetid][0], pozicija[targetid][1], pozicija[targetid][2]);
    SetPlayerMapIcon(playerid, MAPICON_LOCATE, pozicija[targetid][POS_X], pozicija[targetid][POS_Y], pozicija[targetid][POS_Z], 0, 0xFFFF00AA, MAPICON_GLOBAL);
    tajmer:pPhoneLocator[playerid] = SetTimerEx("PhoneLocator", 8000, false, "iiiii", playerid, cinc[playerid], targetid, cinc[targetid], 1);

    SetPVarInt(playerid, "pPhoneLocatorReload", gettime()+20);
    
    // Slanje poruke igracu
    SendClientMessageF(playerid, PLAVA, "Mesto na kome se trenutno nalazi %s je oznaceno na radaru.", ime_rp[targetid]);
    return 1;
}

CMD:trazeni(playerid, const params[])
{
    if (!IsAdmin(playerid, 1))
    {   
        if (!IsACop(playerid))
            return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
            
        if (!IsPlayerOnLawDuty(playerid))
            return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
       // if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
         //   return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");
    }

    
    SendClientMessage(playerid, CRNA, "");
    SendClientMessage(playerid, ZELENA, "__________ Spisak trazenih igraca __________");
    if (Iter_Count(iWantedPlayers) == 0)
        return SendClientMessage(playerid, BELA, " - Spisak trazenih je trenutno prazan.");
    
    new wantedid = Iter_First(iWantedPlayers);
    while__loop (wantedid != MAX_PLAYERS && IsPlayerConnected(wantedid))
    {
        new sMsg[97];
        format(sMsg, sizeof sMsg, "%s (%i)", ime_rp[wantedid], GetPlayerCrimeLevel(wantedid));

        wantedid = Iter_Next(iWantedPlayers, wantedid);
        if (wantedid != MAX_PLAYERS && IsPlayerConnected(wantedid))
        {
            format(sMsg, sizeof sMsg, "%s, %s (%i)", sMsg, ime_rp[wantedid], GetPlayerCrimeLevel(wantedid));

            wantedid = Iter_Next(iWantedPlayers, wantedid);
            if (wantedid != MAX_PLAYERS && IsPlayerConnected(wantedid))
            {
                format(sMsg, sizeof sMsg, "%s, %s (%i)", sMsg, ime_rp[wantedid], GetPlayerCrimeLevel(wantedid));
                wantedid = Iter_Next(iWantedPlayers, wantedid);
            }
        }

        SendClientMessage(playerid, BELA, sMsg);
    }
    return 1;
}

CMD:pdoprema(playerid, const params[]) 
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1385.0066,-23.2893,1001.0030) && !IsPlayerInRangeOfPoint(playerid, 3.0, 258.4168, 109.5337, 1003.2188))
        return ErrorMsg(playerid, "Ne mozete uzeti opremu na ovom mestu.");

    if (!IsACop(playerid))
        return ErrorMsg(playerid, "Samo pripadnici policije mogu uzimati opremu na ovom mestu.");

    if (F_RANKS[PI[playerid][p_org_id]][PI[playerid][p_org_rank]][fr_dozvole] & DOZVOLA_O_KUPOVINA == 0)
    {
        return ErrorMsg(playerid, "Rank %i nema dozvolu za koriscenje oruzarnice.", PI[playerid][p_org_rank]);
    }

    SPD(playerid, "f_pd_oprema", DIALOG_STYLE_LIST, "{FFFFFF}Izaberite opremu", "Oprema za patrolu\nOprema za poteru\nOprema za specijalce\nOprema za diverzante\nOprema za undercover\nDodatna oprema\nOdeca za undercover\nOdeca za SWAT\nOdeca za vojsku", "Izaberi", "Izadji");

    // SPD(playerid, "f_pd_oprema", DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Izaberite opremu", "Oprema\tSadrzaj paketa opreme\nStandardna\tPendrek, suzavac, pistolj, tazer, pancir\nLaka specijalna\tPendrek, suzavac, pistolj, tazer, MP5, pancir+\nSWAT\tPistolj, tazer, shotgun, MP5, M4, dimne bombe, pancir 2x\nDodatna oprema\tBira se posebno\nOdeca\tPosebna odeca za undercover\nOdeca za SWAT\t-\nOdeca za vojsku\t-", "Izaberi", "Izadji");
    return 1;
}

CMD:duty(playerid, params[]) 
{
    new 
        f_id = PI[playerid][p_org_id],
        r_id = PI[playerid][p_org_rank];

    if (!IsACop(playerid))
        return ErrorMsg(playerid, "Niste clan policije.");

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1385.0066,-23.2893,1001.0030) && !IsPlayerInRangeOfPoint(playerid, 3.0, 258.4168, 109.5337, 1003.2188))
        return ErrorMsg(playerid, "Niste na mestu za uzimanje duznosti.");

    if (r_id < 1)
        return ErrorMsg(playerid, "Suspendovani ste, ne mozete ici na duznost.");


    new sMsg[90];
    if (!IsPlayerOnLawDuty(playerid)) 
    {
        if (PI[playerid][p_pol] == POL_MUSKO)
        {
            SetPlayerSkin(playerid, F_RANKS[f_id][r_id][fr_skin]);
        }
        else
        {
            SetPlayerSkin(playerid, 309);
        }
        
        ToggleLawDuty(playerid, true);
        SendClientMessage(playerid, ZUTA, "* Sada ste na duznosti. Koristite /oprema za uzimanje oruzja i opreme.");

        format(sMsg, sizeof sMsg, "* %s uzima znacku iz ormarica i oblaci sluzbenu uniformu.", ime_rp[playerid]);
        DepartmentMsg(INFOPLAVA, "(%s) Sluzbenik %s je sada na duznosti.", FACTIONS[f_id][f_tag], ime_rp[playerid]);

        Iter_Add(iPolicemen, playerid);

        foreach (new i : Player)
        {
            if (IsPlayerWanted(i))
            {
                SetPlayerMarkerForPlayer(playerid, i, 0xFF0000FF);
            }
        }
    }
    else 
    {
        format(sMsg, sizeof sMsg, "* %s skida sluzbenu uniformu i odlaze znacku i oruzje u ormaric.", ime_rp[playerid]);
        ToggleLawDuty(playerid, false);
    }
    RangeMsg(playerid, sMsg, LJUBICASTA, 10.0);
    return 1;
}

CMD:kaucija(playerid, const params[])
{
    if (PI[playerid][p_zatvoren] == 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer niste zatvoreni.");
        
    if (PI[playerid][p_kaucija] <= 0)
        return ErrorMsg(playerid, "Nemate pravo na kauciju.");
        
    if ((PI[playerid][p_novac] + PI[playerid][p_banka]) < PI[playerid][p_kaucija])
        return ErrorMsg(playerid, "Nemate dovoljno novca za kauciju.");
        
    
    // Oduzimanje novca
    PlayerMoneySub_ex(playerid, PI[playerid][p_kaucija], false);
    
    // Nasumicno dodavanje novca u PD ili SWAT
    new c = 0, fid[2] = {-1, -1};
    for__loop (new i = 0; i < GetMaxFactions(); i++)
    {
        if (FACTIONS[i][f_vrsta] == FACTION_LAW && FACTIONS[i][f_loaded] != -1)
        {
            fid[c++] = i;
            if (c == sizeof fid) break;
        }
    }
    if (fid[0] != -1 && fid[1] != -1)
        FactionMoneyAdd(fid[random(2)], PI[playerid][p_kaucija]);
    
    // Stavljanje van zatvora
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerWorldBounds(playerid, 20000, -20000, 20000, -20000);
    SetPlayerCompensatedPos(playerid, 1802.7881, -1577.6869, 13.4119, 280.0);
    
    // Slanje poruke igracu
    SendClientMessage(playerid, SVETLOPLAVA, "Platili ste kauciju i sada ste slobodni.");
    
    // Slanje department poruke
    DepartmentMsg(INFOPLAVA, "* %s je platio kauciju u iznosu od %s.", ime_rp[playerid], formatMoneyString(PI[playerid][p_kaucija]));
    
    // Resetovanje varijabli
    PI[playerid][p_kaucija]  = 0;
    PI[playerid][p_zatvoren] = 0;
    
    // Update podataka u bazi
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET kaucija = 0, zatvoren = 0 WHERE id = %d", PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
    return 1;
}

CMD:kazna(playerid, const params[])
{
    new
        r_id = PI[playerid][p_org_rank],
        id, iznos, razlog[32],
        dstr[250]
    ;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (r_id < MIN_RANK_KAZNA)
        return ErrorMsg(playerid, "Morate biti rank "#MIN_RANK_KAZNA" da biste koristili ovu naredbu.");
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "uis[32]", id, iznos, razlog))
        return Koristite(playerid, "kazna [Ime ili ID igraca] [Iznos] [Razlog]");
        
    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, id) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

    if (GetPlayerAFKTime(id) > 300)
        return ErrorMsg(playerid, "Taj igrac je AFK.");

    if (gPoliceTicketPaidTime[id] > gettime())
        return ErrorMsg(playerid, "Igrac je nedavno vec platio kaznu (ili odbio da plati).");

    if (iznos < 1 || iznos > 15000)
        return ErrorMsg(playerid, "Iznos kazne mora biti izmedju $1 i $15.000.");

    // Maksimalan iznos kazne = RANK*3000
    new maxIznos = (r_id-MIN_RANK_KAZNA+1)*3000;
    if (iznos > maxIznos)
        return ErrorMsg(playerid, "U skladu sa Vasim rankom, maksimalan iznos kazne je %s.", formatMoneyString(maxIznos));

    format(dstr, sizeof dstr, "{FFFFFF}Sluzbenik {3498DB}%s {FFFFFF}Vam je napisao kaznu.\nIznos: {3498DB}%s\n{FFFFFF}Razlog: {3498DB}%s\n\n{FFFFFF}Ukoliko odbijete da je platite, preti Vam zatvorska kazna!", ime_rp[playerid], formatMoneyString(iznos), razlog);
    SPD(id, "police_kazna", DIALOG_STYLE_MSGBOX, "KAZNA", dstr, "Plati", "Odbij");

    SetPVarInt(id, "police_kaznaIznos", iznos);
    SetPVarInt(id, "police_kaznaPlayerId", playerid);
    SetPVarString(id, "police_kaznaRazlog", razlog);

    SetTimerEx("CheckFineAcceptance", 60000, false, "ii", id, cinc[id]);

    SendClientMessageF(playerid, BELA, "* Ponudili ste %s da plati kaznu u iznosu od %s.", ime_rp[id], formatMoneyString(iznos));
    return 1;
}

CMD:tazer(playerid, const params[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

    if(!TaserData[playerid][TaserCharged]) 
        return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu dok se elektrosoker puni.");

    TaserData[playerid][TaserEnabled] = !TaserData[playerid][TaserEnabled];

    new string[56];
    if(TaserData[playerid][TaserEnabled]) 
    {
        if (PI[playerid][p_org_rank] < 3)
        {
            // Stari tazer za R1 i R2
            SetPlayerArmedWeapon(playerid, 0);
            SetPlayerAttachedObject(playerid, SLOT_TASER, 18642, 6, 0.0795, 0.015, 0.0295, 180.0, 0.0, 0.0);
        }
        else
        {
            // Pistolj tazer za R3+
            SetPVarInt(playerid, "copDeagleAmmo", GetPlayerAmmoInSlot(playerid, 2));
            GivePlayerWeapon(playerid, WEAPON_SILENCED, 1);
            SetPlayerAmmo(playerid, 2, 1);
        }

        SetPlayerArmedWeapon(playerid, 0);
        SetPlayerAttachedObject(playerid, SLOT_TASER, 18642, 6, 0.0795, 0.015, 0.0295, 180.0, 0.0, 0.0);

        TaserChargeBar[playerid] = CreatePlayerProgressBar(playerid, 548.000000, 58.000000, 62.000000, 4.699999, 0x00FF00FF, 100.0, 0);
        SetPlayerProgressBarValue(playerid, TaserChargeBar[playerid], 100.0);
        ShowPlayerProgressBar(playerid, TaserChargeBar[playerid]);
        format(string, sizeof string, "** %s je izvadio elektrosoker.", ime_rp[playerid]);
    }
    else
    {   
        RemovePlayerAttachedObject(playerid, SLOT_TASER);

        if (PI[playerid][p_org_rank] < 3)
        {
            RemovePlayerAttachedObject(playerid, SLOT_TASER);
        }
        else
        {
            GivePlayerWeapon(playerid, WEAPON_DEAGLE, GetPVarInt(playerid, "copDeagleAmmo"));
            // SetPlayerAmmo(playerid, 2, GetPVarInt(playerid, "copDeagleAmmo"));
            DeletePVar(playerid, "copDeagleAmmo");
        }


        DestroyPlayerProgressBar(playerid, TaserChargeBar[playerid]);
        format(string, sizeof string, "** %s je odlozio elektrosoker.", ime_rp[playerid]);
    }
    RangeMsg(playerid, string, LJUBICASTA, 15.0);
    return 1;
}

CMD:dosije(playerid, const params[])
{
    new
        r_id = PI[playerid][p_org_rank],
        id
    ;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (r_id < 1)
        return ErrorMsg(playerid, "Suspendovani ste sa duznosti.");
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (!IsLawVehicle(GetPlayerVehicleID(playerid)))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", id))
        return Koristite(playerid, "dosije [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerWanted(id))
        return ErrorMsg(playerid, "%s nema dosije.", ime_rp[id]);

    new proxString[58];
    format(proxString, sizeof proxString, "* %s koristi policijski laptop.", ime_rp[playerid]);
    RangeMsg(playerid, proxString, LJUBICASTA, 5.0);

    new string[1000], naslov[MAX_PLAYER_NAME + 9];
    format(naslov, sizeof naslov, "{3498DB}%s", ime_rp[id]);
    format(string, sizeof string, "{3498DB}_________________ LAPTOP _________________\n\n{FFFFFF}   - Ime: {3498DB}%s\n{FFFFFF}   - Wanted level: {3498DB}%i\n", ime_rp[id], GetPlayerCrimeLevel(id));
    for__loop (new i = 0; i < MAX_PLAYER_CRIMES; i++)
    {
        new reporter[32], info[32];
        GetCrimeData(id, i, info, sizeof info, reporter, sizeof reporter);
        if (strcmp(reporter, "N/A"))
        {
            format(string, sizeof string, "%s\n   -------------------\n{FFFFFF}   - Zlocin: {3498DB}%s\n{FFFFFF}   - Prijavio: {3498DB}%s", string, info, reporter);
        }
    }
    format(string, sizeof string, "%s\n\n-------------------\n{FFFFFF}   - Sluzbenik: {3498DB}%s\n\n_____________________________ %s _____", string, ime_rp[playerid], trenutno_vreme(false));
    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, naslov, string, "Zatvori", "");


    // SendClientMessage(playerid, 0x3498DBFF, "_____________ LAPTOP _____________");
    // if (IsPlayerWanted(id))
    // {
    //     SendClientMessageF(playerid, 0x3498DBFF, "   Ime: {FFFFFF}%s", ime_rp[id]);
    //     SendClientMessageF(playerid, 0x3498DBFF, "   Zlocin: {FFFFFF}%s", CRIMES[id][c_info]);
    //     SendClientMessageF(playerid, 0x3498DBFF, "   Prijavio: {FFFFFF}%s", CRIMES[id][c_reporter]);
    //     SendClientMessageF(playerid, 0x3498DBFF, "   Trazeni nivo: {FFFFFF}%d", CRIMES[id][c_level]);
    //     SendClientMessageF(playerid, 0x3498DBFF, " ");
    //     SendClientMessageF(playerid, 0x3498DBFF, "   Sluzbenik: {FFFFFF}%s", ime_rp[playerid]);
    // }
    // else
    // {
    //     SendClientMessageF(playerid, BELA, " - %s nema dosije.", ime_rp[id]);
    // }
    // SendClientMessageF(playerid, 0x3498DBFF, "______________________ %s ____", trenutno_vreme(false));
    return 1;
}


CMD:pretresi(playerid, const params[]) 
{
    new
        f_id = PI[playerid][p_org_id],
        r_id = PI[playerid][p_org_rank],
        targetid
    ;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "pretresi [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu na sebi.");
        
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
        
    if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
        
    if (PI[targetid][p_org_id] == f_id && PI[targetid][p_org_rank] >= r_id) // Ista organizacija i veci ili isti rank
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima istog ili viseg ranka.");
        
    if (IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Igrac mora biti van vozila.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");


    gPoliceInteraction[targetid] = gettime() + 30;
    SetPVarInt(playerid, "POLICE_FriskID", targetid);
    SPD(playerid, "frisk", DIALOG_STYLE_LIST, "PRETRES", "Stvari\nOruzje\nDroga", "Proveri", "Izadji");
    return 1;
}

CMD:proverivozilo(playerid, const params[]) 
{   
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");


    // Provera da li je blizu vozila i trazenje najblizeg vozila
    new Float:x,Float:y,Float:z, vehicleid = -1, Float:dist = 99999.0;
    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    foreach (new i : iVehicles)
    {
        GetVehiclePos(i, x, y, z);
        new Float:distance_i = GetDistanceBetweenPoints(pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], x, y, z);
        if (distance_i < 5.0 && distance_i < dist)
        {
            vehicleid = i;
            dist = distance_i;
        }
    }
    if (vehicleid == -1)
    {
        return ErrorMsg(playerid, "Ne nalazite se blizu vozila.");
    }
    else
    {
        // Igrac jeste blizu nekog vozila. 
        
        if (GetPVarInt(playerid, "VehicleFrisk_ID") == vehicleid && GetPVarInt(playerid, "VehicleFrisk_Reload") < gettime())
            return ErrorMsg(playerid, "Nedavno ste vec proverili ovo vozilo.");

        // Razdvajamo slucaje: ownership vozilo - da i ne
        new ownershipVeh = -1;
        foreach (new v : iOwnedVehicles)
        {
            if (OwnedVehicle[v][V_ID] == vehicleid)
            {
                ownershipVeh = v;
                break;
            }
        }

        new sDialog[310];
        if (ownershipVeh == -1)
        {
            // Nije ownership vozilo -> proveriti da li pripada nekoj organizaciji
            new factionVeh = -1;
            for__loop (new i = 0; i < MAX_FACTIONS; i++)
            {
                if (IsFactionVehicle(vehicleid, i))
                {
                    factionVeh = i;
                    break;
                }
            }

            if (factionVeh == -1)
            {
                // Nije ownership vozilo, niti pripada nekoj o/m/b -> rent/posao/event/...
                format(sDialog, sizeof sDialog, "{FFFFFF}\
                    Provera vozila: {0068B3}%s [%i]\n\
                    _________________________________________\n\
                    {00FF00}- U redu.", GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);

                SetPVarInt(playerid, "vehCheckTotalAmmo", 0);
                SetPVarInt(playerid, "vehCheckRegStatus", 1);
            }
            else
            {
                // U pitanju je vozilo koje pripada nekoj o/m/b
                // factionVeh = ID fakcije kojoj vozilo pripada

                new vehSlot = -1;
                for__loop (new Float:pos[3], slot = 0; slot < FACTIONS[factionVeh][f_max_vozila]; slot++) 
                {
                    GetVehiclePos(F_VEHICLES[factionVeh][slot][fv_vehicle_id], pos[POS_X], pos[POS_Y], pos[POS_Z]);
                    if (IsPlayerInRangeOfPoint(playerid, 5.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) 
                    {
                        vehSlot = slot;
                        SetPVarInt(playerid, "vehCheckID", F_VEHICLES[factionVeh][slot][fv_vehicle_id]);
                    }
                }
                if (vehSlot == -1)
                    return ErrorMsg(playerid, GRESKA_NEPOZNATO);

                new weaponCount = 0, ammoCount = 0;

                // Provera za oruzja u vozilu
                for__loop (new weaponSlot = 0; weaponSlot < 13; weaponSlot++) 
                {
                    if (F_VEH_WEAPONS[factionVeh][vehSlot][weaponSlot][fv_weapon] == -1 || F_VEH_WEAPONS[factionVeh][vehSlot][weaponSlot][fv_ammo] <= 0) continue;
                    weaponCount ++;
                    ammoCount += F_VEH_WEAPONS[factionVeh][vehSlot][weaponSlot][fv_ammo];
                }

                // Jeste ownership vozilo | proveriti stvari i registraciju
                format(sDialog, sizeof sDialog, "{FFFFFF}\
                    Provera vozila: {0068B3}%s [%i][%i]\n\
                    _________________________________________\n{FFFFFF}\
                    Vlasnik: {0068B3}%s\n{FFFFFF}\
                    Registracija: {0068B3}registrovan\n\
                    _________________________________________\n{FFFFFF}",
                GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid, F_VEHICLES[factionVeh][vehSlot][fv_mysql_id], FACTIONS[factionVeh][f_naziv]);

                if (!weaponCount)
                {
                    format(sDialog, sizeof sDialog, "%s{00FF00}- U vozilu nema nikakvog oruzja.", sDialog);
                }
                else
                {
                    format(sDialog, sizeof sDialog, "%s{FF9900}- U vozilu se nalazi %i komada oruzja i %i metaka.", sDialog, weaponCount, ammoCount);
                }

                SetPVarInt(playerid, "vehCheckTotalAmmo", ammoCount);
                SetPVarInt(playerid, "vehCheckRegStatus", 1);
            }
        }
        else
        {
            // U pitanju je ownership vozilo
            new regStr[32], weaponCount = 0, ammoCount = 0;
            OwnedVehicle_GetRegStatus(ownershipVeh, regStr, sizeof regStr);

            // Provera za oruzja u vozilu
            for__loop (new i = 0; i < 13; i++) 
            {
                if (VehicleWeapons[ownershipVeh][i][V_WEAPON_ID] == -1 || VehicleWeapons[ownershipVeh][i][V_AMMO] <= 0) continue;
                weaponCount ++;
                ammoCount += VehicleWeapons[ownershipVeh][i][V_AMMO];
            }

            // Jeste ownership vozilo | proveriti stvari i registraciju
            format(sDialog, sizeof sDialog, "{FFFFFF}\
                Provera vozila: {0068B3}%s [%i][%i]\n\
                _________________________________________\n{FFFFFF}\
                Vlasnik: {0068B3}%s\n{FFFFFF}\
                Registracija: {0068B3}%s\n{0068B3}\
                _________________________________________\n{FFFFFF}",
            GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid, ownershipVeh,
            OwnedVehicle[ownershipVeh][V_OWNER_NAME],
            regStr);

            if (!weaponCount)
            {
                format(sDialog, sizeof sDialog, "%s{00FF00}- U vozilu nema nikakvog oruzja.", sDialog);
            }
            else
            {
                
                format(sDialog, sizeof sDialog, "%s{FF9900}- U vozilu se nalazi %i komada oruzja i %i metaka.", sDialog, weaponCount, ammoCount);
            }

            SetPVarInt(playerid, "vehCheckTotalAmmo", ammoCount);
            SetPVarInt(playerid, "vehCheckRegStatus", (OwnedVehicle_IsRegistered(ownershipVeh)? 1 : 0));
            SetPVarInt(playerid, "vehCheckID", OwnedVehicle[ownershipVeh][V_ID]);
        }

        SetPVarInt(playerid, "VehicleFrisk_ID", vehicleid);
        SetPVarInt(playerid, "VehicleFrisk_Reload", gettime()+120);
        SPD(playerid, "proverivozilo", DIALOG_STYLE_MSGBOX, "Pretres vozila", sDialog, "U redu", "");
    }
    return 1;
}

CMD:rotacija(playerid, const params[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu komandu.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if (!IsLawVehicle(vehicleid))
        return ErrorMsg(playerid, "Morate biti u policijskom vozilu da biste koristili ovu komandu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Morate biti na mestu vozaca da biste ukljucili rotaciju.");

    if(!Iter_Contains(iFlashingVehicles, vehicleid)) 
    {
        if (IsValidDynamicObject(policeLightObj[vehicleid][0]))
            DestroyDynamicObject(policeLightObj[vehicleid][0]), policeLightObj[vehicleid][0] = -1;

        if (IsValidDynamicObject(policeLightObj[vehicleid][1]))
            DestroyDynamicObject(policeLightObj[vehicleid][1]), policeLightObj[vehicleid][1] = -1;

        switch (GetVehicleModel(vehicleid))
        {
            case 596:
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                policeLightObj[vehicleid][1] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][1], vehicleid, -0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
            }
            case 597:
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                policeLightObj[vehicleid][1] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][1], vehicleid, -0.599999,-0.375000,0.899999,0.000000,0.000000,0.000000);
            }
            case 598:
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                policeLightObj[vehicleid][1] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.524999, -0.300000, 0.899999, 0.000000, 0.000000, 0.000000);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][1], vehicleid, -0.524999, -0.300000, 0.899999, 0.000000, 0.000000, 0.000000);
            }
            case 599:
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                policeLightObj[vehicleid][1] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.524999,0.000000,1.125000,0.000000,0.000000,0.000000);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][1], vehicleid, -0.524999,0.000000,1.125000,0.000000,0.000000,0.000000);
            }
            case 541:// Bullet
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.375000,0.524999,0.375000,0.000000,0.000000,0.000000);
            }
            case 426:// Premier
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.524999,0.749999,0.375000,0.000000,0.000000,0.000000);
            }
            case 427, 528, 601: // Enforcer, FBI truck, 
            {
            }
            case 560: // Sultan
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.225000,0.750000,0.449999,0.000000,0.000000,0.000000);
            }
            case 490: // FBI Rancher
            {
                policeLightObj[vehicleid][0] = CreateDynamicObject(18646, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(policeLightObj[vehicleid][0], vehicleid, 0.000000,1.125000,0.599999,0.000000,0.000000,0.000000);
            }
            default:
            {
                return ErrorMsg(playerid, "Ne mozete ukljuciti rotaciju za ovo vozilo.");
            }
        }


        if (Iter_Count(iFlashingVehicles) == 0)
        {
            tmrFlash = SetTimer("FlasherFunc", 200, true);
        }
        Iter_Add(iFlashingVehicles, vehicleid);
        SendClientMessage(playerid, ZUTA, "* Rotacija je ukljucena.");
    } 
    else 
    {
        if (IsValidDynamicObject(policeLightObj[vehicleid][0]))
            DestroyDynamicObject(policeLightObj[vehicleid][0]), policeLightObj[vehicleid][0] = -1;

        if (IsValidDynamicObject(policeLightObj[vehicleid][1]))
            DestroyDynamicObject(policeLightObj[vehicleid][1]), policeLightObj[vehicleid][1] = -1;
        

        new panels, doors, lights, tires;
        GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
        UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
        Iter_Remove(iFlashingVehicles, vehicleid);
        SendClientMessage(playerid, ZUTA, "** Rotacija je iskljucena.");
    }
    return 1;
}

CMD:r(const playerid, params[145])
{
    if (PI[playerid][p_org_id] == -1)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (FACTIONS[PI[playerid][p_org_id]][f_vrsta] != FACTION_LAW)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (isnull(params)) 
        return Koristite(playerid, "r [Tekst]");

    new cmdParams[145];
    format(cmdParams, sizeof cmdParams, "/f %s", params);
    PC_EmulateCommand(playerid, cmdParams);
    return 1;
}


CMD:d(const playerid, params[145]) 
{
    new
        f_id = PI[playerid][p_org_id],
        r_id = PI[playerid][p_org_rank]
    ;
    
    if (f_id == -1)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (FACTIONS[f_id][f_vrsta] != FACTION_LAW)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if ((F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_CHAT) == 0)
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);

    if (PI[playerid][p_area] > 0)
        return overwatch_poruka(playerid, "Ne mozete koristiti ovaj chat dok ste zatvoreni.");
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");
        
    if (isnull(params)) 
        return Koristite(playerid, "d [Tekst]");

    if (!IsChatEnabled(playerid, CHAT_DEPARTMENT))
        return ErrorMsg(playerid, "Iskljucili ste /d kanal. Koristite /chat da ga ponovo ukljucite.");
        
    koristio_chat[playerid] = gettime() + 3;
    zastiti_chat(playerid, params);

    // Formatiranje poruke za slanje
    new string[145];
    if (F_RANKS[f_id][r_id][fr_dozvole] != 0 && !isnull(F_RANKS[f_id][r_id][fr_ime])) 
    {
        format(string, sizeof string, "%s %s[%i]: {FFFFFF}%s, prijem.", F_RANKS[f_id][r_id][fr_ime], ime_rp[playerid], playerid, params);
    }
    else
    {
        format(string, sizeof string, "Rank %d %s[%i]: {FFFFFF}%s, prijem.", r_id, ime_rp[playerid], playerid, params);
    }

    // Slanje poruke
    foreach (new i : Player) 
    {
        if ((IsACop(i) || IsAdmin(i, 5)) && IsChatEnabled(i, CHAT_DEPARTMENT))
            SendClientMessage(i, 0xFF295EFF, string);
    }


    // Upisivanje u log
    new sLog[145];
    format(sLog, sizeof sLog, "%s: %s", ime_obicno[playerid], params);
    Log_Write("logs/chat/factions/Department.txt", sLog);
    return 1;
}
/*
CMD:oduzmi(playerid, const params[])
{
    new
        f_id = PI[playerid][p_org_id],
        r_id = PI[playerid][p_org_rank],
        id
    ;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", id))
        return Koristite(playerid, "oduzmi [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (id == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu na sebi.");
        
    if (!IsPlayerNearPlayer(playerid, id))
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
        
    if (IsPlayerJailed(playerid) || IsPlayerJailed(id))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
        
    if (PI[id][p_org_id] == f_id && PI[id][p_org_rank] >= r_id) // Ista organizacija i veci ili isti rank
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima istog ili viseg ranka.");
        
    if (IsPlayerInAnyVehicle(id))
        return ErrorMsg(playerid, "Igrac mora biti van vozila.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");


    SetPVarInt(playerid, "POLICE_SeizeID", id);
    SPD(playerid, "seize", DIALOG_STYLE_LIST, "ODUZIMANJE STVARI", "Oruzje\nDroga\nVozacka dozvola\nDozvola za oruzje\nDozvola za letenje\nDozvola za plovidbu", "Dalje", "Izadji");
    return 1;
}*/

CMD:cctv(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 57.4201,812.9319,-29.6422) && pUsingCCTV[playerid] == -1)
        return ErrorMsg(playerid, "Ne nalazite se na mestu za gledanje kamera.");

    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste gledali kamere.");

    if (pUsingCCTV[playerid] == -1)
    {
        // Ukljucivanje video nadzora
        new dStr[200];
        dStr[0] = EOS;
        for__loop (new i = 0; i < sizeof CCTV; i++)
        {
            format(dStr, sizeof dStr, "%s\n%s", dStr, CCTV[i][CCTV_NAME]);
        }

        SavePlayerWeaponDataAndPos(playerid);
        SPD(playerid, "cctv", DIALOG_STYLE_LIST, "Nadzorne kamere", dStr, "Gledaj", "Odustani");
    }
    else
    {
        // Iskljucivanje video nadzora
        pUsingCCTV[playerid] = -1;
        
        PlayerRestorePosition(playerid);
        TogglePlayerSpectating(playerid, false);
    }
    return 1;
}

CMD:trazidozvole(playerid, const params[])
{
    new targetid;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "trazidozvole [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu na sebi.");
        
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
        
    if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
        
    if (IsACop(targetid))
        return ErrorMsg(playerid, "Ovaj igrac je policajac.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");

    SetPVarInt(targetid, "licenseCheckID", playerid);
    SetPVarInt(targetid, "licenseCheckCinc", cinc[playerid]);
    gPoliceInteraction[targetid] = gettime() + 30;

    new sDialog[157];
    format(sDialog, sizeof sDialog, "{FFFFFF}Sluzbenik {0068B3}%s {FFFFFF}trazi uvid u Vase dozvole.\n\n{FF9900}Ukoliko odbijete da mu ih pokazete, mozete ici u zatvor!", ime_rp[playerid]);
    SPD(targetid, "trazidozvole", DIALOG_STYLE_MSGBOX, "Dozvole", sDialog, "Pokazi", "Odbij");
    SendClientMessage(playerid, BELA, "* Zahtev za pregled dozvola je poslat igracu. Ukoliko odbije da ga prihvati, dobice wanted level automatski.");

    return 1;
}

alias:proveripojas("provjeripojas");
CMD:proveripojas(playerid, const params[])
{
    new targetid;
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "proveripojas [Ime ili ID igraca]");
        
    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);
                
    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
        
    if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
        
    if (IsACop(targetid))
        return ErrorMsg(playerid, "Ovaj igrac je policajac.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");

    if (!IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Taj igrac nije u vozilu.");
        
    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");


    gPoliceInteraction[targetid] = gettime() + 30;

    new sMsg[130];
    format(sMsg, sizeof sMsg, "* %s gleda kroz prozor vozila i proverava da li je %s zakopcao sigurnosti pojas.", ime_rp[playerid], ime_rp[targetid]);
    RangeMsg(playerid, sMsg, LJUBICASTA, 15.0);

    if (Citizen_GetSeatbeltState(targetid))
    {
        // Pojas zakopcan
        SendClientMessageF(playerid, 0xFF295EFF, "[SIGURNOSNI POJAS] {FFFFFF}%s: {00FF00}zakopcan", ime_rp[targetid]);
    }
    else
    {
        // Nije stavio pojas
        // AddPlayerCrime(targetid, playerid, 1, "Nekoriscenje sigurnosnog pojasa", ime_obicno[playerid]);
        SendClientMessageF(playerid, 0xFF295EFF, "[SIGURNOSNI POJAS] {FFFFFF}%s: {FF0000}nije zakopcan", ime_rp[targetid]);
    }

    return 1;
}

CMD:ram(playerid, const params[])
{
    
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (PI[playerid][p_org_rank] < 3)
        return ErrorMsg(playerid, "Potreban Vam je rank 3 da biste koristili ovu naredbu.");
        
    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");
        
    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti van vozila.");

    new gid = RE_GetPlayerPickupGID(playerid);
    if (gid == -1)
        return ErrorMsg(playerid, "Ne nalazite se ispred ulaza u enterijer.");

    if (!RE_IsPlayerAtEntrance(playerid, gid))
        return ErrorMsg(playerid, "Ne nalazite se ispred ulaza u enterijer.");

    // Da li ima drustvo?
    new pdNearby = 0;
    foreach (new i : iPolicemen)
    {
        if (playerid != i && IsPlayerNearPlayer(playerid, i, 5.0))
        {
            pdNearby ++;
        }
    }
    if (pdNearby == 0)
        return ErrorMsg(playerid, "Morate biti u drustvu nekog kolege da biste koristili ovu naredbu.");

    new vrsta = re_odredivrstu(gid);
    new sMsg[91];
    format(sMsg, sizeof sMsg, "* Policajac %s nasilno otvara vrata %s i ulazi unutra.", ime_rp[playerid], propname(vrsta, PROPNAME_GENITIV));
    RangeMsg(playerid, sMsg, LJUBICASTA, 20.0);

    RE_UnlockEntrance(gid);
    SetTimerEx("RE_LockEntrance", 300000, false, "i", gid);

    new Float:x, Float:y, Float:z, Float:a, ent;
    ent = RE_GetInterior(gid);
    RE_GetExitPos(gid, x, y, z, a);
    SetPlayerCompensatedPos(playerid, x, y, z, a, gid, ent, 5000);

    return 1;
}

CMD:pdhelp(playerid, const params[])
{
    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Uputstvo za pocetnike", "{4286F4}RUTINSKA KONTROLA/HAPSENJE\n{FFFFFF}\
        - Dozvoljeno vam je da hapsite bez upotrebe /me i /do komandi (mozete ih koristiti, ali nije obavezno).\n\
        - Za hapsenje je dovoljno da pronadjete nacin da zaustavite osumnjicenog, a onda je dovoljno da mu pridjete, \n\
          stavite lisice, te ga odvedete do stanice i uhapsite.\n\
        - Igraci sa poternicom (wanted level) su oznaceni crvenim markerom na mapi, i njihovo kretanje se prati u realnom vremenu.\n\
        - Komanda /su za davanje WL ne postoji - zato sto skripta automatski daje WL kada detektuje da igrac krsi zakon.\n\n\
        - Komanda {4286F4}/bork: {FFFFFF}sluzi da policajac da WL igracu zbog bezanja od rutinske kontrole\n\
          Ova komanda ima posebna ogranicenja da bi se onemogucila zloupotreba:\n\
          - moze je koristiti samo putnik u policijskom vozilu, a pre toga se mora koristiti megafon (/m)\n\
            kao pokusaj zaustavljanja igraca radi rutinske kontrole.\n\
        - Komanda {4286F4}/trazidozvole: {FFFFFF}ovom komandom trazite od igraca dozvole na uvid\n\
          Ukoliko igrac nema vozacku dozvolu, a nedavno je upravljao vozilom, on ce automatski dobiti WL.\n\
          Ukoliko odbije da vam pokaze svoje dozvole, takodje dje dobiti WL zbog odbijanja kontrole.\n\
        - Komanda {4286F4}/proverivozilo: {FFFFFF}sluzi za pretres vozila i proveru vazenja registracije.\n\
          Ako u vozilu postoji vise od 1000 metaka, igrac koji je upravljao vozilom dobija WL, bez obzira da li ima dozvolu ili ne.\n\
          Ako vozilo nije registrovano ili je registracija istekla, igrac automatski dobija 2 WL.\n\
        - Komanda {4286F4}/pretresi: {FFFFFF}sluzi za pretres igraca i provere da li nosi drogu i oruzje\n\
          Igrac automatski dobija 3 WL za svakih 50g droge koje nosi (1-50g = 3WL, 51-100g = 6WL ...)\n\
          Tolerise se nosenje do 500 metaka ako igrac ima dozvolu za oruzje (nece dobiti WL)\n\
          Za nosenje previse metaka, igrac dobija 3 WL za svakih 200 metaka koje nosi (1-200 = 3WL, 201-400 = 6WL ...)\n\n\
        \
        {FF0000}VAZNA PRAVILA!\n{FFFFFF}\
        - U sprecavanju pljacke zlatare/banke mora ucestvovati {FF6300}najmanje {FFFFFF}2 clana policije.\n\
        - Revenge Kill (RK) je najstroze zabranjen, a narocito tokom pljacke zlatare/banke!\n\
        - Zabranjeno je raditi RPS i trcati odmah na igraca koji pljacka (kako biste ga tazovali i prekinuli pljacku)\n\
          dok svi ostali pucaju u vas. Morate prvo onesposobiti sve ostale!\n\
        - Zabranjeno je ulaziti u baze mafija i bandi. (ukoliko neko sa WL kampuje u bazi, server ce ga automatski kazniti)\n\
        - Zabranjeno je hapsiti na teritorijama koje {FF6300}blinkaju!\n{FFFFFF}\
        - Zabranjen je taz na gun!\n\
        - Kod sprecavanja pljacke zlatare/banke duzni ste pokusati pregovarati sa pljackasima. \n\
        - - Ukoliko odbijaju, saradnju, dozvoljeno je krenuti u napad.", "U redu", "");

    return 1;
}