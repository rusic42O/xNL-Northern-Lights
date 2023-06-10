#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new AreaLS,
    AreaMainSpawn,
    AreaMainHospital,
    AreaSecondHospital,
    AreaMarketplace
;

static
    Text3D:SKProtectionLabel[MAX_PLAYERS],
    tmrSKProtection[MAX_PLAYERS],
    tmrBaseHiding[MAX_PLAYERS],
    gBaseHidingWarns[MAX_PLAYERS char],
    gAntiBunnyHop[MAX_PLAYERS char],
    gBunnHopNotified[MAX_PLAYERS char],

    gKillerPlayerID[MAX_PLAYERS],
    gKillerPlayerCinc[MAX_PLAYERS],
    gKillerPlayerTime[MAX_PLAYERS],

    gKilledPlayerID[MAX_PLAYERS],
    gKilledPlayerCinc[MAX_PLAYERS],
    gKilledPlayerTime[MAX_PLAYERS]
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    AreaLS = CreateDynamicRectangle(9.42,-2766.68, 2977.858, -537.1823, 0, 0);
    AreaMainSpawn = CreateDynamicRectangle(1729.039, -1737.6, 1810.033, -1807.6, 0, 0);
    AreaMarketplace = CreateDynamicRectangle(1207.0817, -1560.6444, 1217.3228, -1521.0510, 0, 0);
    AreaMainHospital = CreateDynamicRectangle(1174.6227, -1386.9089, 1222.8951, -1291.4751, 0, 0);
    AreaSecondHospital = CreateDynamicRectangle(1991.9299, -1454.5915, 2047.4742, -1398.5915, 0, 0);

    SetTimer("BunnyHopReset", 3222, true);
    return true;
}

hook OnPlayerConnect(playerid)
{
    SKProtectionLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    tmrBaseHiding[playerid] = gBaseHidingWarns{playerid} = 0;
    gBunnHopNotified{playerid} = gAntiBunnyHop{playerid} = 0;

    gKillerPlayerID[playerid] = gKillerPlayerCinc[playerid] = gKillerPlayerTime[playerid] = -1;
    gKilledPlayerID[playerid] = gKilledPlayerCinc[playerid] = gKilledPlayerTime[playerid] = -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (IsValidDynamic3DTextLabel(SKProtectionLabel[playerid]))
        DestroyDynamic3DTextLabel(SKProtectionLabel[playerid]), SKProtectionLabel[playerid] = Text3D:INVALID_3DTEXT_ID;

    KillTimer(tmrBaseHiding[playerid]);
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_FIRE) // Levi klik
    {
        if ((IsPlayerInDynamicArea(playerid, AreaMainSpawn) || IsPlayerInDynamicArea(playerid, AreaMarketplace) || IsPlayerInDynamicArea(playerid, AreaMainHospital) || IsPlayerInDynamicArea(playerid, AreaSecondHospital) || IsPlayerInDynamicArea(playerid, zona_area51) || IsPlayerInWeedField(playerid)) && !IsPlayerInAnyVehicle(playerid))
        {
            if (GetPVarInt(playerid, "owHitSlapped") == 0 && !IsPlayerRobbingATM(playerid) && !IsPlayerWorking(playerid) && !IsAdmin(playerid, 1))
            {
                if (GetPlayerWeapon(playerid) == 0)
                    GameTextForPlayer(playerid, "~N~~N~~N~~r~] ] ] ] ] ] ] ] ]~n~~w~Ne tuci se ovde!~n~~r~] ] ] ] ] ] ] ] ]", 5000, 3);
                else
                    GameTextForPlayer(playerid, "~N~~N~~N~~r~] ] ] ] ] ] ] ] ]~n~~w~Ne pucaj ovde!~n~~r~] ] ] ] ] ] ] ] ]", 5000, 3);
                
                SlapPlayer(playerid, 1.5);
                SetPlayerArmedWeapon(playerid, 0);
                SetPVarInt(playerid, "owHitSlapped", 1);
                SetTimerEx("OW_HitSlapped_Reset", 700, false, "i", playerid);
                return ~1;
            }
        }
    }

    if((newkeys & KEY_JUMP) && !IsPlayerInAnyVehicle(playerid) && IsPlayerControllable_OW(playerid) && !IsPlayerOnMDMA(playerid) && !IsPlayerInWar(playerid) && !IsAdmin(playerid, 6) && GetPlayerCameraMode(playerid) != 7)
    {
        gAntiBunnyHop{playerid} ++;
 
        if(gAntiBunnyHop{playerid} >= 3)
        {
            ApplyAnimationEx(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);

            if (gBunnHopNotified{playerid} < 1)
            {
                gBunnHopNotified{playerid} ++;
                SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Bunny Hop", "{FF0000}Bunny Hop je zabranjen!\n\n{FFFFFF}Ukoliko zelis da trcis i skaces istovremeno, koristi {FF0000}/mdma !", "OK", "");
            }
        }
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    gBaseHidingWarns{playerid} = 0;


    if (IsValidDynamic3DTextLabel(SKProtectionLabel[playerid]))
        DestroyDynamic3DTextLabel(SKProtectionLabel[playerid]), SKProtectionLabel[playerid] = Text3D:INVALID_3DTEXT_ID;

    if (IsPlayerConnected(killerid) && IsValidWeapon(reason) && IsPlayerAlive(playerid))
    {
        /*if (IsPlayerInDynamicArea(playerid, AreaMainHospital) || IsPlayerInDynamicArea(playerid, AreaSecondHospital) || IsPlayerInDynamicArea(killerid, AreaMainHospital) || IsPlayerInDynamicArea(playerid, AreaMarketplace) || IsPlayerInWeedField(playerid) || IsPlayerInWeedField(killerid))
        {   
            if (!IsTurfWarActiveForPlayer(playerid) && !IsTurfWarActiveForPlayer(killerid) && (GetPlayerTurf(playerid) || GetPlayerTurf(killerid)))
            {
                PromptPunishmentDialog(playerid, killerid, 45, 0, 1, "Ubistvo na nedozvoljenom mestu");
                SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
            }
        }*/
        if (GetPVarInt(playerid, "pAntiSpawnKill") >= gettime() && !IsPlayerInDMEvent(killerid) && !IsPlayerInHorrorEvent(killerid) && !IsPlayerInDMArena(killerid))
        {
            PromptPunishmentDialog(playerid, killerid, 20, 0, 1, "SK");
            SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
        }
    }

    /*if (IsPlayerConnected(playerid) && IsPlayerConnected(killerid) && IsPlayerAlive(playerid))
    {
        if (!IsPlayerInDMEvent(killerid) && !IsPlayerInHorrorEvent(killerid) && !IsPlayerInWar(killerid) && !IsTurfWarActiveForPlayer(killerid) 
            && !IsPlayerInWar(playerid) && !IsTurfWarActiveForPlayer(playerid) && !IsPlayerInVSEvent(killerid) && !IsPlayerInBoxEvent(killerid))
        {
            if (gKillerPlayerID[killerid] == playerid && gKillerPlayerCinc[killerid] == cinc[playerid] && gKillerPlayerTime[killerid] > gettime())
            {
                PromptPunishmentDialog(playerid, killerid, 45, 0, 3, "RK");
                SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);

                gKillerPlayerID[killerid] = gKillerPlayerCinc[killerid] = gKillerPlayerTime[killerid] = -1;
                return 1;
            }
            else if ((gKilledPlayerID[killerid] == playerid && gKilledPlayerCinc[killerid] == cinc[playerid] && gKilledPlayerTime[killerid] > gettime()) || (gKillerPlayerID[playerid] == killerid && gKillerPlayerCinc[playerid] == cinc[killerid] && gKillerPlayerTime[playerid] > gettime()))
            {
                PromptPunishmentDialog(playerid, killerid, 45, 0, 3, "DM");
                SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);

                gKilledPlayerID[killerid] = gKilledPlayerCinc[killerid] = gKilledPlayerTime[killerid] = -1;
                return 1;
            }
            else
            {
                // Nisu se medjusobno poubijali vise puta uzastopno (dm/rk)
                if (reason == 52 && IsPlayerInAnyVehicle(killerid) && GetPlayerState(killerid) == PLAYER_STATE_DRIVER && !IsPlayerInAnyVehicle(playerid))
                {
                    // Igrac je ubijen tako sto je ubica stao autom preko njega
                    PromptPunishmentDialog(playerid, killerid, 60, 0, 3, "Ubistvo vozilom");
                    SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                }

                if ((PI[playerid][p_provedeno_vreme] > 5*3600 && PI[playerid][p_provedeno_vreme] <= 20*3600) && GetPlayerFactionID(playerid) == -1 && GetPlayerFactionID(killerid) > -1)
                {
                    if (!((gettime() - GetPVarInt(killerid, "pTookDamage")) < 10 && GetPVarInt(killerid, "pTookDamageID") == playerid))
                    {
                        // Kaznjava se samo ako ga taj igrac nije prethodno udario/upucao
                        PromptPunishmentDialog(playerid, killerid, 90, 0, 3, "Ubistvo novog igraca (civila)");
                        SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                    }
                }*/

                /*if (IsPlayerWorking(playerid) && GetPlayerWeapon(playerid) == 0)
                {
                    if (!((gettime() - GetPVarInt(killerid, "pTookDamage")) < 10 && GetPVarInt(killerid, "pTookDamageID") == playerid))
                    {
                        // Kaznjava se samo ako ga taj igrac nije prethodno udario/upucao
                        PromptPunishmentDialog(playerid, killerid, 90, 0, 3, "Ubistvo igraca koji radi posao (civil)");
                        SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                    }
                }

                if (GetPlayerLandID(playerid) != -1)
                {
                    PromptPunishmentDialog(playerid, killerid, 20, 0, 50000, "Ubistvo na nedozvoljenom mestu");
                    SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                }*/

                /*if (GetPlayerVirtualWorld(playerid) > 1000 && GetPlayerVirtualWorld(playerid) < 3000)
                {
                    // Ubistvo u enterijeru
                    PromptPunishmentDialog(playerid, killerid, 45, 0, 3, "DM");
                    SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                }*/

                /*if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER) // Napravljen DB
                {
                    PromptPunishmentDialog(playerid, killerid, 60, 0, 3, "DB");
                    SetTimerEx("ShowRulesDialog_DM_RK", 30000, false, "ii", killerid, cinc[killerid]);
                }

                gKillerPlayerID[playerid] = killerid;
                gKillerPlayerCinc[playerid] = cinc[killerid];
                gKillerPlayerTime[playerid] = gettime()+180;

                gKilledPlayerID[killerid] = playerid;
                gKilledPlayerCinc[killerid] = cinc[playerid];
                gKilledPlayerTime[killerid] = gettime()+180;
            }
        }*/
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    OW_SetupAntiSpawnKill(playerid);
    gBaseHidingWarns{playerid} = 0;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if (GetPVarInt(playerid, "pAntiSpawnKill") >= gettime() && !IsPlayerInDMArena(playerid))
    {
        new str[43];
        format(str, sizeof str, "~N~~N~~r~Spawn Kill zastita~N~%i sekundi", GetPVarInt(playerid, "pAntiSpawnKill")-gettime());
        GameTextForPlayer(playerid, str, 5000, 3);

        // SlapPlayer(playerid, 3.0);
        ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
        // return ~0;
    }

    if (hittype == BULLET_HIT_TYPE_PLAYER && IsPlayerConnected(hitid) && GetPVarInt(hitid, "pAntiSpawnKill") >= gettime() && !IsPlayerInDMArena(hitid))
    {
        new str[43];
        format(str, sizeof str, "~N~~N~~r~Spawn Kill zastita~N~%i sekundi", GetPVarInt(hitid, "pAntiSpawnKill")-gettime());
        GameTextForPlayer(playerid, str, 5000, 3);

        // SlapPlayer(playerid, 3.0);
        ApplyAnimation(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
        // return ~0;
    }
    return 1;
}

// hook OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
// {
//     // playerid = damagedid
//     if (IsPlayerConnected(playerid) && GetPVarInt(playerid, "pAntiSpawnKill") >= gettime())
//     {
//         new Float:health;
//         GetPlayerHealth(playerid, health);
//         if (health > 0) SetPlayerHealth(playerid, health+amount);
//     }

//     if (IsPlayerConnected(playerid) && IsNewPlayer(issuerid) && GetPlayerFactionID(issuerid) == -1 && weapon == 0)
//     {
//         new Float:health;
//         GetPlayerHealth(playerid, health);
//         if (health > 0) SetPlayerHealth(playerid, health+amount);

//         ApplyAnimationEx(issuerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
//         GameTextForPlayer(issuerid, "~N~~N~~N~~r~] ] ] ] ] ] ] ] ]~n~~w~Ne udaraj druge igrace!~n~~r~] ] ] ] ] ] ] ] ]", 5000, 3);
//     }
//     return 1;
// }

// hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
// {
//     if (IsPlayerConnected(damagedid) && GetPVarInt(damagedid, "pAntiSpawnKill") >= gettime())
//     {
//         new Float:health;
//         GetPlayerHealth(damagedid, health);
//         if (health > 0) SetPlayerHealth(damagedid, health+amount);
//     }

//     if (IsPlayerConnected(damagedid) && IsNewPlayer(playerid) && GetPlayerFactionID(playerid) == -1 && weaponid == 0)
//     {
//         new Float:health;
//         GetPlayerHealth(damagedid, health);
//         if (health > 0) SetPlayerHealth(damagedid, health+amount);

//         ApplyAnimationEx(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
//         GameTextForPlayer(playerid, "~N~~N~~N~~r~] ] ] ] ] ] ] ] ]~n~~w~Ne udaraj druge igrace!~n~~r~] ] ] ] ] ] ] ] ]", 5000, 3);
//     }
//     return 1;
// }

hook OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
    // playerid = damagedid
    if (IsPlayerConnected(playerid) && GetPVarInt(playerid, "pAntiSpawnKill") >= gettime() && !IsPlayerInDMArena(playerid))
    {
        new Float:health;
        GetPlayerHealth(playerid, health);
        if (health > 0) SetPlayerHealth(playerid, health+amount);
    }

    if (IsPlayerConnected(playerid) && IsNewPlayer(issuerid) && GetPlayerFactionID(issuerid) == -1 && weapon == 0)
    {
        new Float:health;
        GetPlayerHealth(playerid, health);
        if (health > 0) SetPlayerHealth(playerid, health+amount);

        ApplyAnimationEx(issuerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
        GameTextForPlayer(issuerid, "~N~~N~~N~~r~] ] ] ] ] ] ] ] ]~n~~w~Ne udaraj druge igrace!~n~~r~] ] ] ] ] ] ] ] ]", 5000, 3);
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (IsPlayerWanted(playerid) && IsACriminal(playerid) && GetFactionAreaID(GetPlayerFactionID(playerid)) == areaid)
    {
        // Kriminalac sa WL-om je usao u nedozvoljenu zonu oko svoje baze
        if (!tmrBaseHiding[playerid])
        {
            tmrBaseHiding[playerid] = SetTimerEx("CheckPlayerHidingInBase", 30000, true, "ii", playerid, cinc[playerid]);
        }
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward BunnyHopReset();
public BunnyHopReset()
{
    foreach (new i : Player)
    {
        gAntiBunnyHop{i} = 0;
    }
    return 1;
}

forward CheckPlayerHidingInBase(playerid, ccinc);
public CheckPlayerHidingInBase(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc) || !IsPlayerWanted(playerid) || !IsACriminal(playerid))
    {
        KillTimer(tmrBaseHiding[playerid]);
        return 1;
    }

    if (IsPlayerInFactionBase(playerid, GetPlayerFactionID(playerid)))
    {
        // Igrac je i dalje u bazi
        #define MAX_BASE_HIDING_WARNINGS 4 // 4 x 30sec = 120 sec tolerancije

        gBaseHidingWarns{playerid} ++;
        SendClientMessageF(playerid, CRVENA, "OVERWATCH | {FFFFFF}Zabranjeno je da budete blizu baze dok imate WL. (%i/%i)", gBaseHidingWarns{playerid}, MAX_BASE_HIDING_WARNINGS);

        if (gBaseHidingWarns{playerid} >= MAX_BASE_HIDING_WARNINGS)
        {
            KillTimer(tmrBaseHiding[playerid]);
            
            PunishPlayer(playerid, INVALID_PLAYER_ID, 30, 0, 1, false, "Kampovanje u bazi sa WL");

            gBaseHidingWarns{playerid} = 0;
        }
        else
        {
            SlapPlayer(playerid);
            GameTextForPlayer(playerid, "~N~~N~~R~UDALJI SE OD BAZE~N~~Y~IMAS WANTED LEVEL", 5000, 3);
        }
    }
    else
    {
        gBaseHidingWarns{playerid} --;

        if (gBaseHidingWarns{playerid} <= 0)
        {
            KillTimer(tmrBaseHiding[playerid]);
        }
    }
    return 1;
}

forward OW_HitSlapped_Reset(playerid);
public OW_HitSlapped_Reset(playerid)
{
    DeletePVar(playerid, "owHitSlapped");
    return 1;
}

forward OW_SpawnKillCountdown(playerid, ccinc);
public OW_SpawnKillCountdown(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc) || gettime() > GetPVarInt(playerid, "pAntiSpawnKill"))
    {
        KillTimer(tmrSKProtection[playerid]), tmrSKProtection[playerid] = 0;

        if (IsValidDynamic3DTextLabel(SKProtectionLabel[playerid]))
        DestroyDynamic3DTextLabel(SKProtectionLabel[playerid]), SKProtectionLabel[playerid] = Text3D:INVALID_3DTEXT_ID;

        return 1;
    }

    new str[28];
    format(str, sizeof str, "(( ASK: %i ))", GetPVarInt(playerid, "pAntiSpawnKill")-gettime());
    UpdateDynamic3DTextLabelText(SKProtectionLabel[playerid], 0xFF0000CC, str);
    return 1;
}

stock OW_SetupAntiSpawnKill(playerid, time = -1)
{
    if (time == -1)
    {
        if (!IsPlayerInWar(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid))
        {
            time = 15;
        }
        else
        {
            time = 5;
        }
    }
    SetPVarInt(playerid, "pAntiSpawnKill", gettime()+time);


    if (IsValidDynamic3DTextLabel(SKProtectionLabel[playerid]))
    {
        DestroyDynamic3DTextLabel(SKProtectionLabel[playerid]), SKProtectionLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    KillTimer(tmrSKProtection[playerid]), tmrSKProtection[playerid] = 0;

    new str[28];
    format(str, sizeof str, "(( ASK: %i ))", GetPVarInt(playerid, "pAntiSpawnKill")-gettime());
    SKProtectionLabel[playerid] = CreateDynamic3DTextLabel(str, 0xFF0000FF, 0.0, 0.0, 0.0, 25.0, playerid, INVALID_VEHICLE_ID, 1);
    Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, SKProtectionLabel[playerid], E_STREAMER_ATTACH_OFFSET_Z, 0.1);
    
    tmrSKProtection[playerid] = SetTimerEx("OW_SpawnKillCountdown", 1000, true, "ii", playerid, cinc[playerid]);
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
