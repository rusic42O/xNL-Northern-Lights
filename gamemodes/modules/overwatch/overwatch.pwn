#include <YSI_Coding\y_hooks>


// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
// General
#define MAX_CHEATNAME_LEN (22)
#define OVERWATCH_MAX_WARNINGS (6)
#define OW_ACTION_NOTIFY (0)
#define OW_ACTION_JAIL (1)
#define OW_ACTION_KICK (2)
#define OW_ACTION_BAN (3)

// Weapon Hack
#define MAX_WEAPON_ID (47)
#define WEAPON_SLOTS (13)
#define WEAPON_SLOT_EMPTY (0)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_OVERWATCH_PLAYERDATA
{
    // General
    bool:OW_TIMED_OUT,
    bool:OW_IS_ALIVE,
    bool:OW_IS_FROZEN,
    OW_LAST_CAR,
    OW_PLAYER_IP[16],
    Float:OW_PLAYER_POS[3],
    OW_TELEPORT_HACK_IGNORE,


    // Weapon Hack
    bool:OW_HAS_WEAPON[MAX_WEAPON_ID],
    OW_WEAPON_IN_SLOT[WEAPON_SLOTS],
    OW_AMMO_IN_SLOT[WEAPON_SLOTS],
    OW_WEAPON_WARN,
    OW_WEAPON_HACK_IGNORE,


    // Ammo Hack
    OW_AMMO_WARN,


    // Speed Hack
    OW_SPEED_WARN,


    // Car Warp
    OW_CAR_CHANGE_COUNT,
    OW_CAR_CHANGE_CNT_RESET,

    // Fake Kill
    OW_FAKE_KILL_SUSPECT,
}

enum E_OVERWATCH_VEHICLE_DATA
{
    Float:OW_VEH_HEALTH,
    Float:OW_VEH_POS[3],
    OW_VEH_HEALTH_WARNINGS,
    OW_VEH_WARP_WARNINGS,
}

enum E_OVERWATCH_CONFIG
{
    OWC_WEAPON_HACK = 0,
    OWC_AMMO_HACK,
    OWC_SPEED_HACK,
    OWC_VEHICLE_HEALTH_HACK,
    OWC_TELEPORT_HACK,
    OWC_FAKE_KILL,
    OWC_CAR_WARP,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new Overwatch[MAX_PLAYERS][E_OVERWATCH_PLAYERDATA];
new OverwatchVehInfo[MAX_VEHICLES][E_OVERWATCH_VEHICLE_DATA];
new OW_Config[E_OVERWATCH_CONFIG];
new Iterator:iVehicles<MAX_VEHICLES>;


// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward MYSQL_OverwatchConfig();
public MYSQL_OverwatchConfig()
{
    new row_count;
    cache_get_row_count(row_count);
    if (row_count != 1) 
        return printf("[overwatch.pwn] Nije moguce ucitati konfiguraciju.");
    
    new sConfig[40];
    cache_get_value_index(0, 0, sConfig, sizeof sConfig);

    for__loop (new j = 0, i = 0; i < strlen(sConfig); i += 2, j++)
    {
        OW_Config[E_OVERWATCH_CONFIG: j] = strval(sConfig[i]);
    }
    return 1;
}

forward OVERWATCH();
public OVERWATCH()
{
    foreach (new playerid : Player)
    {
        if (Overwatch[playerid][OW_IS_ALIVE] == false || IsPlayerAFK(playerid))
            continue;


        // Weapon Hack & Ammo Hack
        if (OW_Config[OWC_WEAPON_HACK] || OW_Config[OWC_AMMO_HACK])
        {
            if (Overwatch[playerid][OW_WEAPON_HACK_IGNORE] > 0)
            {
                // Nedavno su detektovane neke izmene na oruzju
                Overwatch[playerid][OW_WEAPON_HACK_IGNORE] --;
            }

            if (IsPlayerInWar(playerid) || IsPlayerInDMEvent(playerid) || IsPlayerInHorrorEvent(playerid))
                continue;

            else
            {
                for__loop (new slot = 0; slot < WEAPON_SLOTS; slot++)
                {
                    new weaponid, ammo;
                    GetPlayerWeaponData(playerid, slot, weaponid, ammo);

                    // Weapon Hack
                    if (weaponid > 0 && ammo > 0 && OW_Config[OWC_WEAPON_HACK])
                    {
                        // [BUG] Kada igrac potrosi municiju, oruzje se detektuje sa 0 municije
                        // [BUG] Padobran se automatski stvara kad igrac pada sa visine
                        // [BUG] Shotgun se automatski stvara *ponekad* kad se udje u policijsko vozilo

                        if (weaponid != GetPlayerWeaponInSlot(playerid, slot) || !Overwatch[playerid][OW_HAS_WEAPON][weaponid])
                        {
                            // Igracu je na slotu pronadjeno oruzje koje mu nije zapisano u promenljivoj za taj slot
                            if (!(weaponid == WEAPON_SHOTGUN && Overwatch[playerid][OW_LAST_CAR] == 596) && !(weaponid == WEAPON_PARACHUTE))
                            {
                                // Ignorise se padobran i shotgun ako je izasao iz PD auta
                                Overwatch[playerid][OW_WEAPON_WARN] ++;

                                if (Overwatch[playerid][OW_WEAPON_WARN] > OVERWATCH_MAX_WARNINGS)
                                {
                                    Overwatch[playerid][OW_WEAPON_WARN] = 0; // Resetuje warning count da ne bi bilo spama

                                    OW_OnCheatDetected(playerid, OWC_WEAPON_HACK, OW_ACTION_NOTIFY, weaponid, ammo);
                                }
                            }
                        }
                    }

                    // Ammo Hack
                    else if (ammo < -1 && OW_Config[OWC_AMMO_HACK])
                    {
                        // Negativna vrednost municije se moze postici cheat-om
                        // GetPlayerWeaponData ume da vrati -1, pa je bitno da vrednost bude manja od toga
                        Overwatch[playerid][OW_AMMO_WARN] ++;

                        if (Overwatch[playerid][OW_AMMO_WARN] > OVERWATCH_MAX_WARNINGS)
                        {
                            Overwatch[playerid][OW_AMMO_WARN] = 0; // Resetuje warning count da ne bi bilo spama

                            OW_OnCheatDetected(playerid, OWC_AMMO_HACK, OW_ACTION_NOTIFY, weaponid, ammo);
                        }
                    }
                }
            }
        }


        // Speed Hack
        if (OW_Config[OWC_SPEED_HACK])
        {
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(playerid))
            {
                new speed = GetPlayerSpeed(playerid),
                    model = GetVehicleModel(GetPlayerVehicleID(playerid)),
                    topSpeed = GetVehicleTopSpeed(model);

                if (!IsVehicleBicycle(model) && !IsVehicleMotorbike(model) && !IsVehicleBoat(model) && !IsVehicleHelicopter(model) && !IsVehicleAirplane(model))
                {
                    // Ignorisanje za bicikl i motor (up arrow abuse)
                    if (topSpeed > 0 && speed > topSpeed*1.20)
                    {
                        // 20% tolerancije
                        Overwatch[playerid][OW_SPEED_WARN] ++;

                        if (Overwatch[playerid][OW_SPEED_WARN] > OVERWATCH_MAX_WARNINGS)
                        {
                            Overwatch[playerid][OW_SPEED_WARN] = 0; // Resetuje warning count da ne bi bilo spama

                            if (IsHelper(playerid, 1))
                            {
                                OW_OnCheatDetected(playerid, OWC_SPEED_HACK, OW_ACTION_NOTIFY, speed, topSpeed);
                            }
                            else
                            {
                                OW_OnCheatDetected(playerid, OWC_SPEED_HACK, OW_ACTION_BAN, speed, topSpeed);
                            }
                        }
                    }
                }
            }
        }


        // Teleport Hack
        if (OW_Config[OWC_TELEPORT_HACK] && GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
        {
            if (Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] > 0)
            {
                Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] --;
            }
            else
            {
                new Float:pos[3], Float:distance;
                GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
                distance = GetDistanceBetweenPoints(pos[0], pos[1], pos[2], Overwatch[playerid][OW_PLAYER_POS][0], Overwatch[playerid][OW_PLAYER_POS][1], Overwatch[playerid][OW_PLAYER_POS][2]);

                if (distance > 350.0 && GetPlayerPing(playerid) < 250)
                {
                    // Otkriven cheat
                    OW_OnCheatDetected(playerid, OWC_TELEPORT_HACK, OW_ACTION_NOTIFY, floatround(distance), 0);
                }
            }

            GetPlayerPos(playerid, Overwatch[playerid][OW_PLAYER_POS][0], Overwatch[playerid][OW_PLAYER_POS][1], Overwatch[playerid][OW_PLAYER_POS][2]);
        }


        // Car Warp
        if (OW_Config[OWC_CAR_WARP])
        {
            if (++Overwatch[playerid][OW_CAR_CHANGE_CNT_RESET] > 3)
            {
                Overwatch[playerid][OW_CAR_CHANGE_CNT_RESET] = 0;
                Overwatch[playerid][OW_CAR_CHANGE_COUNT] = 0;
            }
        }
    }
    return 1;
}

stock OW_ResetPlayerVariables(playerid)
{
    // General
    Overwatch[playerid][OW_TIMED_OUT] = false;
    Overwatch[playerid][OW_IS_ALIVE] = false;
    Overwatch[playerid][OW_LAST_CAR] = INVALID_VEHICLE_ID;
    Overwatch[playerid][OW_IS_FROZEN] = false;
    Overwatch[playerid][OW_WEAPON_HACK_IGNORE] = 3;
    Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] = 3;
    Overwatch[playerid][OW_CAR_CHANGE_COUNT] = 0;

    GetPlayerPos(playerid, Overwatch[playerid][OW_PLAYER_POS][0], Overwatch[playerid][OW_PLAYER_POS][1], Overwatch[playerid][OW_PLAYER_POS][2]);

    // Weapon Hack
    OW_ResetPlayerWeapons(playerid);
}

stock OW_IsPlayerFrozen(playerid)
{
    return Overwatch[playerid][OW_IS_FROZEN];
}

stock IsValidWeapon(weaponid)
{
    if (weaponid > 0 && weaponid < 19 || weaponid > 21 && weaponid < 47) return 1;
    return 0;
}

stock IsPlayerAlive(playerid)
{
    return Overwatch[playerid][OW_IS_ALIVE];
}

stock SetPlayerAlive(playerid, bool:is_alive)
{
    Overwatch[playerid][OW_IS_ALIVE] = is_alive;
}

stock OW_TimePlayerOut(playerid, const msg[])
{
    Overwatch[playerid][OW_TIMED_OUT] = true;

    ClearChatForPlayer(playerid);
    SendClientMessage(playerid, 0xFF0000FF, "______________________________________________________________________________");
    SendClientMessageF(playerid, 0xFF0000FF, "OVERWATCH | {FFFFFF}%s", msg);

    new SendClientMessaged[22];
    format(SendClientMessaged, sizeof SendClientMessaged, "banip %s", Overwatch[playerid][OW_PLAYER_IP]);
    SendRconCommand(SendClientMessaged);
    return 1;
}

forward OW_UpdateVehicleHealth();
public OW_UpdateVehicleHealth()
{
    foreach (new i : Player)
    {
        new vehicleid = GetPlayerVehicleID(i);
        if (vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER)
        {
            new Float:health;
            GetVehicleHealth(vehicleid, Float:health);
            if (health <= OverwatchVehInfo[vehicleid][OW_VEH_HEALTH])
            {
                OverwatchVehInfo[vehicleid][OW_VEH_HEALTH] = health;
            }
            else
            {
                // Detektovan je veci health na vozilu
                OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] ++;

                if (OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] >= 4)
                {
                    // Ili desync ili cheat. Salje se obavestenje i resetuje se health

                    if (OW_Config[OWC_VEHICLE_HEALTH_HACK])
                    {
                        OW_OnCheatDetected(i, OWC_VEHICLE_HEALTH_HACK, OW_ACTION_NOTIFY, floatround(health), floatround(OverwatchVehInfo[vehicleid][OW_VEH_HEALTH]));
                    }

                    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH] = health;
                }
            }
        }
    }
    return 1;
}

stock IsPlayerControllable_OW(playerid)
{
    return !Overwatch[playerid][OW_IS_FROZEN];
}



// ========================================================================== //
//                         <section> Natives </section>                       //
// ========================================================================== //
stock OW_TogglePlayerControllable(playerid, bool:toggle)
{
    Overwatch[playerid][OW_IS_FROZEN] = !toggle;

    return TogglePlayerControllable(playerid, toggle);
}

stock OW_TogglePlayerSpectating(playerid, bool:toggle)
{
    OW_ResetPlayerVariables(playerid);

    Overwatch[playerid][OW_PLAYER_POS][0] = x;
    Overwatch[playerid][OW_PLAYER_POS][1] = y;
    Overwatch[playerid][OW_PLAYER_POS][2] = z;
    Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] = 3;

    return TogglePlayerSpectating(playerid, toggle);
}

stock OW_GivePlayerWeapon(playerid, weaponid, ammo)
{
    // Civilima se ne daje automatsko oruzje
    if (!IsACop(playerid) && !IsACriminal(playerid) && !IsAdmin(playerid, 1) && !IsPlayerInDMArena(playerid))
    {
        if (weaponid == WEAPON_MP5 || weaponid == WEAPON_M4 || weaponid == WEAPON_AK47 || weaponid == WEAPON_SNIPER || weaponid == WEAPON_SHOTGUN || weaponid == WEAPON_RIFLE)
        {
            overwatch_poruka(playerid, "Civilima je zabranjeno da nose puske.");
            return 0;
        }
    }

    new slot = GetWeaponSlot_OW(weaponid);

    Overwatch[playerid][OW_HAS_WEAPON][weaponid] = true;
    Overwatch[playerid][OW_WEAPON_IN_SLOT][slot] = weaponid;
    Overwatch[playerid][OW_AMMO_IN_SLOT][slot] += ammo;

    Overwatch[playerid][OW_WEAPON_HACK_IGNORE] = 5;

    return GivePlayerWeapon(playerid, weaponid, ammo);
}

stock OW_ResetPlayerWeapons(playerid)
{
    Overwatch[playerid][OW_WEAPON_WARN] = 0;
    Overwatch[playerid][OW_AMMO_WARN] = 0;
    for__loop (new i = 0; i < MAX_WEAPON_ID; i++)
    {
        Overwatch[playerid][OW_HAS_WEAPON][i] = false;
    }
    for__loop (new i = 0; i < WEAPON_SLOTS; i++)
    {
        Overwatch[playerid][OW_WEAPON_IN_SLOT][i] = WEAPON_SLOT_EMPTY;
        Overwatch[playerid][OW_AMMO_IN_SLOT][i]   = 0;
    }

    Overwatch[playerid][OW_WEAPON_HACK_IGNORE] = 5;

    return ResetPlayerWeapons(playerid);
}

stock GetPlayerWeaponInSlot(playerid, wSlot)
{
    if (wSlot >= 0 && wSlot <= 12)
    {
        return Overwatch[playerid][OW_WEAPON_IN_SLOT][wSlot];
    }
    else return -1;
}

stock GetPlayerAmmoInSlot(playerid, wSlot)
{
    if (wSlot >= 0 && wSlot <= 12)
    {
        return Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot];
    }
    else return -1;
}

stock OW_SetPlayerAmmo(playerid, ow_weaponid, ow_ammo)
{
    if(ow_ammo < -32768) ow_ammo = -32768;
    else if(ow_ammo > 32767) ow_ammo = 32767;
    if(16 <= ow_weaponid <= 43)
    {
        new weaponSlot = GetWeaponSlot_OW(ow_weaponid);
        if(Overwatch[playerid][OW_WEAPON_IN_SLOT][weaponSlot] > 0)
        {
            Overwatch[playerid][OW_AMMO_IN_SLOT][weaponSlot] = ow_ammo;
        }
    }

    Overwatch[playerid][OW_WEAPON_HACK_IGNORE] = 5;
    return SetPlayerAmmo(playerid, ow_weaponid, ow_ammo);
}

stock OW_SetPlayerHealth(playerid, Float:amount)
{
    if (amount > 99.0) amount = 99.0;
    if (amount < 0.0) amount = 0.0;

    return SetPlayerHealth(playerid, amount);
}

stock OW_SetPlayerArmour(playerid, Float:amount)
{
    if (amount > 99.0 && !IsACop(playerid)) amount = 99.0;
    if (amount < 0.0) amount = 0.0;

    if (amount > 0.0)
    {
        AttachPlayerBodyArmor(playerid);
    }
    else
    {
        DettachPlayerBodyArmor(playerid);
    }

    return SetPlayerArmour(playerid, amount);
}

stock OW_SetVehicleHealth(vehicleid, Float:health)
{
    if (vehicleid == INVALID_VEHICLE_ID || vehicleid >= MAX_VEHICLES || vehicleid < 1 || !IsValidVehicle(vehicleid)) return 0;

    if (health > 999.0) health = 999.0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH] = health;

    return SetVehicleHealth(vehicleid, health);
}

stock OW_DestroyVehicle(vehicleid) 
{
    if (vehicleid == INVALID_VEHICLE_ID || vehicleid >= MAX_VEHICLES || vehicleid < 1 || !IsValidVehicle(vehicleid)) return 0;

    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH] = 999.0;
    Iter_Remove(iVehicles, vehicleid);

    return DestroyVehicle(vehicleid);
}

stock OW_AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, bool:addsiren=false)
{
    new vehicleid = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, respawn_delay, addsiren);

    OverwatchVehInfo[vehicleid][OW_VEH_POS][0] = spawn_x;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][1] = spawn_y;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][2] = spawn_z;
    OverwatchVehInfo[vehicleid][OW_VEH_WARP_WARNINGS] = 0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] = 0;

    FUEL_SetupVehicle(vehicleid, modelid);
    SetVehicleHealth(vehicleid, 999.0);
    Iter_Add(iVehicles, vehicleid);

    if (vehicleid >= MAX_VEHICLES)
        StaffMsg(0xFF0000FF, "[!!!] DOSTIGNUT JE LIMIT VOZILA, BRZO PRIJAVI HEAD ADMINU! [%d/%d]", vehicleid, MAX_VEHICLES);

    return vehicleid;
}

stock OW_CreateVehicle(model, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, bool:addsiren = false) 
{
    new vehicleid = CreateVehicle(model, x, y, z, rotation, color1, color2, respawn_delay, addsiren);

    OverwatchVehInfo[vehicleid][OW_VEH_POS][0] = x;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][1] = y;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][2] = z;
    OverwatchVehInfo[vehicleid][OW_VEH_WARP_WARNINGS] = 0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] = 0;
    SetVehicleHealth(vehicleid, 999.0);

    FUEL_SetupVehicle(vehicleid, model);
    Iter_Add(iVehicles, vehicleid);

    if (vehicleid >= MAX_VEHICLES)
        StaffMsg(0xFF0000FF, "[!!!] DOSTIGNUT JE LIMIT VOZILA, BRZO PRIJAVI HEAD ADMINU! [%d/%d]", vehicleid, MAX_VEHICLES);

    return vehicleid;
}

stock OW_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
    GetVehicleHealth(vehicleid, OverwatchVehInfo[vehicleid][OW_VEH_HEALTH]);

    OverwatchVehInfo[vehicleid][OW_VEH_POS][0] = x;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][1] = y;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][2] = z;
    OverwatchVehInfo[vehicleid][OW_VEH_WARP_WARNINGS] = 0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] = 0;

    foreach (new i : Player)
    {
        if (GetPlayerVehicleID(i) == vehicleid)
        {
            Overwatch[i][OW_PLAYER_POS][0] = x;
            Overwatch[i][OW_PLAYER_POS][1] = y;
            Overwatch[i][OW_PLAYER_POS][2] = z;
            Overwatch[i][OW_TELEPORT_HACK_IGNORE] = 3;
        }
    }

    return SetVehiclePos(vehicleid, x, y, z);
}

stock OW_SetPlayerPos(playerid, Float:x, Float:y, Float:z, Float:a = -1.007) 
{
    /*
        Kad budem sredjivao postavljanje pozicije u varijablu zbog teleporta,
        to isto uraditi i kod TeleportPlayer();
    */
    
    // Streamer_UpdateEx(playerid, x, y, z);
    Overwatch[playerid][OW_PLAYER_POS][0] = x;
    Overwatch[playerid][OW_PLAYER_POS][1] = y;
    Overwatch[playerid][OW_PLAYER_POS][2] = z;
    Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] = 3;

    SetPlayerPos(playerid, x, y, z);
    if (a != -1.007) SetPlayerFacingAngle(playerid, a);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock OW_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);

    Overwatch[playerid][OW_PLAYER_POS][0] = x;
    Overwatch[playerid][OW_PLAYER_POS][1] = y;
    Overwatch[playerid][OW_PLAYER_POS][2] = z;
    Overwatch[playerid][OW_TELEPORT_HACK_IGNORE] = 3;

    return PutPlayerInVehicle(playerid, vehicleid, seatid);
}

stock OW_ApplyAnimation(playerid, const animlib[], const animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    if (GetPVarInt(playerid, "OverrideAnimationRestriction") != 1)
    {
        if (IsPlayerOnActiveTurf(playerid) && IsTurfWarActiveForPlayer(playerid))
        {
            ErrorMsg(playerid, "Zabranjena je upotreba animacija na aktivnim teritorijama.");
            return 0;
        }
        else if (IsPlayerInWar(playerid))
        {
            ErrorMsg(playerid, "Zabranjena je upotreba animacija u waru.");
            return 0;
        }
        else if (IsPlayerInDMEvent(playerid))
        {
            ErrorMsg(playerid, "Zabranjena je upotreba animacija na DM eventu.");
            return 0;
        }
        else if (IsPlayerInHorrorEvent(playerid))
        {
            ErrorMsg(playerid, "Zabranjena je upotreba animacija na Horor eventu.");
            return 0;
        }
    }

    return ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
}

stock ApplyAnimationEx(playerid, const animlib[], const animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync = 0)
{
    SetPVarInt(playerid, "OverrideAnimationRestriction", 1);
    ApplyAnimation(playerid, animlib, animname, Float:fDelta, loop, lockx, locky, freeze, time, forcesync);
    DeletePVar(playerid, "OverrideAnimationRestriction");
    return 1;
}



// ========================================================================== //
//                          <section> Hooks </section>                        //
// ========================================================================== //
#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon OW_GivePlayerWeapon

#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons OW_ResetPlayerWeapons

#if defined _ALS_SetPlayerAmmo
    #undef SetPlayerAmmo
#else
    #define _ALS_SetPlayerAmmo
#endif
#define SetPlayerAmmo OW_SetPlayerAmmo

#if defined _ALS_SetPlayerHealth
    #undef SetPlayerHealth
#else
    #define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth OW_SetPlayerHealth

#if defined _ALS_SetPlayerArmour
    #undef SetPlayerArmour
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour OW_SetPlayerArmour

#if defined _ALS_SetVehicleHealth
    #undef SetVehicleHealth
#else
    #define _ALS_SetVehicleHealth
#endif
#define SetVehicleHealth OW_SetVehicleHealth

#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle OW_DestroyVehicle

#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx OW_AddStaticVehicleEx

#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle OW_CreateVehicle

#if defined _ALS_SetVehiclePos
    #undef SetVehiclePos
#else
    #define _ALS_SetVehiclePos
#endif
#define SetVehiclePos OW_SetVehiclePos

#if defined _ALS_SetPlayerPos
    #undef SetPlayerPos
#else
    #define _ALS_SetPlayerPos
#endif
#define SetPlayerPos OW_SetPlayerPos

#if defined _ALS_PutPlayerInVehicle
    #undef PutPlayerInVehicle
#else
    #define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle OW_PutPlayerInVehicle

#if defined _ALS_ApplyAnimation
    #undef ApplyAnimation
#else
    #define _ALS_ApplyAnimation
#endif
#define ApplyAnimation OW_ApplyAnimation



// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    SetTimer("OVERWATCH", 1200, true);
    SetTimer("OW_UpdateVehicleHealth", 680, true);

    // Resetovanje vozila
    for__loop (new i = 0; i < MAX_VEHICLES; i++)
    {
        OverwatchVehInfo[i][OW_VEH_HEALTH] = 999.0;
        OverwatchVehInfo[i][OW_VEH_WARP_WARNINGS] = 0;
        OverwatchVehInfo[i][OW_VEH_HEALTH_WARNINGS] = 0;
    }
    return true;
}

hook OnPlayerConnect(playerid)
{
    OW_ResetPlayerVariables(playerid);
    GetPlayerIp(playerid, Overwatch[playerid][OW_PLAYER_IP], 16);

    Overwatch[playerid][OW_FAKE_KILL_SUSPECT] = 0; // ne sme ici u OW_ResetPlayerVariables !
    return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (Overwatch[playerid][OW_TIMED_OUT])
    {
        new SendClientMessaged[24];
        format(SendClientMessaged, sizeof SendClientMessaged, "unbanip %s", Overwatch[playerid][OW_PLAYER_IP]);
        SendRconCommand(SendClientMessaged);
        SendRconCommand("reloadbans");

        Overwatch[playerid][OW_TIMED_OUT] = false;
    }
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    OW_ResetPlayerVariables(playerid);
    SetPlayerAlive(playerid, true); // Ide na false u OnPlayerDeath.pwn

    if (OW_Config[OWC_FAKE_KILL] && IsPlayerConnected(playerid) && IsPlayerConnected(killerid))
    {
        // TODO:
        // Proveravamo koliko je puta igrac umro u roku od 2 sekunde
        // Koliko igraca je igrac ubio u roku od 2 sekunde


        // Igrac level 1, ubija preko Fire extinguisher-a ili Knife-a ---> cheater 1/1
        if (GetPlayerScore(killerid) <= 1 && (reason == WEAPON_CAMERA || reason == WEAPON_GRENADE || (reason == WEAPON_CHAINSAW && !IsPlayerInHorrorEvent(playerid)) || reason == WEAPON_MINIGUN || reason == WEAPON_FIREEXTINGUISHER || reason == WEAPON_KNIFE || reason == WEAPON_HEATSEEKER || reason == WEAPON_ROCKETLAUNCHER || !IsValidWeapon(reason)))
        {
            OW_OnCheatDetected(killerid, OWC_FAKE_KILL, OW_ACTION_BAN, reason, 0);
        }

        else if (GetPlayerScore(playerid) <= 1 && (reason == WEAPON_CAMERA || reason == WEAPON_GRENADE || (reason == WEAPON_CHAINSAW && !IsPlayerInHorrorEvent(playerid)) || reason == WEAPON_MINIGUN || reason == WEAPON_FIREEXTINGUISHER || reason == WEAPON_KNIFE || reason == WEAPON_HEATSEEKER || reason == WEAPON_ROCKETLAUNCHER || !IsValidWeapon(reason)))
        {
            Overwatch[playerid][OW_FAKE_KILL_SUSPECT] ++;

            if (Overwatch[playerid][OW_FAKE_KILL_SUSPECT] >= 2)
            {
                OW_OnCheatDetected(playerid, OWC_FAKE_KILL, OW_ACTION_BAN, reason, 0);
            }
        }
    }
    return true;
}

hook OnPlayerSpawn(playerid)
{
    SetPlayerAlive(playerid, true);
    return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER)
    {
        Overwatch[playerid][OW_LAST_CAR] = GetPlayerVehicleID(playerid);

        if (OW_Config[OWC_CAR_WARP])
        {
            Overwatch[playerid][OW_CAR_CHANGE_COUNT] ++;

            if (Overwatch[playerid][OW_CAR_CHANGE_COUNT] >= 3)
            {
                OW_OnCheatDetected(playerid, OWC_CAR_WARP, OW_ACTION_NOTIFY, 0, 0);
            }
        }
    }
    return true;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    new ammo = GetPlayerAmmo(playerid),
        wSlot = GetWeaponSlot_OW(weaponid);

    if (wSlot != -1)
    {
        if (ammo < Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot])
            Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot] --;

        if (OW_Config[OWC_AMMO_HACK] && ammo > Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot] && !Overwatch[playerid][OW_WEAPON_HACK_IGNORE])
        {
            // Igrac je ispalio municiju, ali ima vise nego sto je overwatch-u poznato
            Overwatch[playerid][OW_AMMO_WARN] ++;

            if (Overwatch[playerid][OW_AMMO_WARN] > OVERWATCH_MAX_WARNINGS && ammo > (Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot] + 10))
            {
                Overwatch[playerid][OW_AMMO_WARN] = 0; // Resetuje warning count da ne bi bilo spama

                OW_OnCheatDetected(playerid, OWC_AMMO_HACK, OW_ACTION_NOTIFY, weaponid, ammo);
                Overwatch[playerid][OW_AMMO_IN_SLOT][wSlot] = ammo;
            }
        }
    }
    return 1;
}

hook OnVehicleDeath(vehicleid, killerid)
{
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH] = 0.0;
    OverwatchVehInfo[vehicleid][OW_VEH_WARP_WARNINGS] = 0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] = 0;
    return true;
}

hook OnVehicleSpawn(vehicleid)
{
    SetVehicleHealth(vehicleid, 999.0);

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);
    OverwatchVehInfo[vehicleid][OW_VEH_POS][0] = x;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][1] = y;
    OverwatchVehInfo[vehicleid][OW_VEH_POS][2] = z;
    OverwatchVehInfo[vehicleid][OW_VEH_WARP_WARNINGS] = 0;
    OverwatchVehInfo[vehicleid][OW_VEH_HEALTH_WARNINGS] = 0;
    return 1;
}