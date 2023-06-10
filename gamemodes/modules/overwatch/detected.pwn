#include <YSI_Coding\y_hooks>

#define MAX_LINES                       10

forward OW_OnCheatDetected(playerid, E_OVERWATCH_CONFIG:cheat, action, param1, param2);
public OW_OnCheatDetected(playerid, E_OVERWATCH_CONFIG:cheat, action, param1, param2)
{
    new playerName[MAX_PLAYER_NAME],
        cheatName[MAX_CHEATNAME_LEN],
        warningStr[145],
        logStr[300],
        Float:playerData[5],
        ent, vw;

    GetPlayerName(playerid, playerName, sizeof playerName);
    OW_GetCheatName(cheat, cheatName);
    GetPlayerPos(playerid, playerData[0], playerData[1], playerData[2]);
    GetPlayerHealth(playerid, playerData[3]);
    GetPlayerArmour(playerid, playerData[4]);
    ent = GetPlayerInterior(playerid);
    vw = GetPlayerVirtualWorld(playerid);

    // Log string - formatiranje
    format(logStr, sizeof logStr, "%s | %s\r\n", cheatName, playerName);

    switch (cheat)
    {
        case OWC_WEAPON_HACK:
        {
            // param1 = weaponid | param2 = ammo
            new weapon[22],
                weaponid = param1,
                ammo = param2,
                slot = GetWeaponSlot_OW(weaponid),
                weaponOw[22];

            GetWeaponName(Overwatch[playerid][OW_WEAPON_IN_SLOT][slot], weaponOw, sizeof weaponOw);
            GetWeaponName(weaponid, weapon, sizeof weapon);
            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | %s | %s (%i metaka)", playerName, playerid, cheatName, weapon, ammo);

            // Log string - formatiranje
            format(logStr, sizeof logStr, "%s\
                Detektovano | [%s (%i)], municija [%i]\r\n\
                Poznato | [%s (%i)], municija [%i]", 
                logStr, 
                weapon, weaponid, ammo, 
                weaponOw, Overwatch[playerid][OW_WEAPON_IN_SLOT][slot], Overwatch[playerid][OW_AMMO_IN_SLOT][slot]);
        }

        case OWC_AMMO_HACK:
        {
            // param1 = weaponid | param2 = ammo
            new weapon[22],
                weaponid = param1,
                ammo = param2,
                slot = GetWeaponSlot_OW(weaponid),
                weaponOw[22];

            GetWeaponName(Overwatch[playerid][OW_WEAPON_IN_SLOT][slot], weaponOw, sizeof weaponOw);
            GetWeaponName(weaponid, weapon, sizeof weapon);
            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | %s | %s (%i metaka)", playerName, playerid, cheatName, weapon, ammo);

            // Log string - formatiranje
            format(logStr, sizeof logStr, "%s\
                Detektovano | [%s (%i)], municija [%i]\r\n\
                Poznato | [%s (%i)], municija [%i]", 
                logStr,
                weapon, weaponid, ammo,
                weaponOw, Overwatch[playerid][OW_WEAPON_IN_SLOT][slot], Overwatch[playerid][OW_AMMO_IN_SLOT][slot]);
        }

        case OWC_SPEED_HACK:
        {
            // param1 = player speed | param2 = veh max. speed
            new playerSpeed = param1,
                vehTopSpeed = param2,
                vehicleid = GetPlayerVehicleID(playerid),
                model = GetVehicleModel(vehicleid);

            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | %s | %i km/h (%s[%i], max %i km/h)", playerName, playerid, cheatName, playerSpeed, GetVehicleModelName(model), vehicleid, vehTopSpeed);

            // Log string - formatiranje
            format(logStr, sizeof logStr, "%s\
                Igrac se krece brzinom od [%i km/h]\r\n\
                Vozilo [%s (%i)] | Maksimalna brzina: [%i km/h]",
                logStr,
                playerSpeed,
                GetVehicleModelName(model), vehicleid, vehTopSpeed);
        }

        case OWC_VEHICLE_HEALTH_HACK:
        {
            // param1 = current health | param2 = should be health
            new currentHp = param1,
                shouldBeHp = param2,
                vehicleid = GetPlayerVehicleID(playerid);

            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | Vehicle Health Hack | %d umesto %d hp", playerName, playerid, currentHp, shouldBeHp);

            // Log string - formatiranje
            format(logStr, sizeof logStr, "%s\
                Vozilo ima %d umesto %d health-a\n\
                Vozilo: %s [%i]",
                logStr,
                currentHp, shouldBeHp,
                GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
        }

        case OWC_TELEPORT_HACK:
        {
            // param1 = distance
            new distance = param1,
                vehicleid = GetPlayerVehicleID(playerid),
                sVehModel[20];

            if (vehicleid)
            {
                format(sVehModel, sizeof sVehModel, "%s", GetVehicleModelName(GetVehicleModel(vehicleid)));
            }
            else
            {
                format(sVehModel, sizeof sVehModel, "N/A");
            }

            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | Teleport Hack | Udaljenost: %i", playerName, playerid, distance);

            // Log string - formatiranje
            format(logStr, sizeof logStr, "%s\
                Udaljenost: [%i], Vozilo: %s [%i]\n\
                Stara (poznata) pozicija: [%.2f, %.2f, %.2f]\n",
                logStr,
                distance, sVehModel, vehicleid,
                Overwatch[playerid][OW_PLAYER_POS][0], Overwatch[playerid][OW_PLAYER_POS][1], Overwatch[playerid][OW_PLAYER_POS][2]);
        }

        case OWC_FAKE_KILL:
        {
            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | Fake Kill", playerName, playerid);
        }

        case OWC_CAR_WARP:
        {
            format(warningStr, sizeof warningStr, "OVERWATCH | {FFFFFF}%s[%i] | Moguce bacanje vozila", playerName, playerid);
        }
    }

    // Log string - formatiranje | Upisivanje u log
    format(logStr, sizeof logStr, "%s\r\nPozicija [%.2f, %.2f, %.2f], E/VW: [%i/%i], HP: [%.2f], AR: [%.2f]\r\n", logStr, playerData[0], playerData[1], playerData[2], ent, vw, playerData[3], playerData[4]);
    Log_Write("logs/overwatch/detections.txt", logStr);


    if (action == OW_ACTION_NOTIFY)
    {
        AdminMsg(0xFF0000FF, warningStr);
    }
    else if (action == OW_ACTION_JAIL)
    {
        format(warningStr, sizeof warningStr, "%s | {FFFF00}JAIL (60 min)", warningStr);
        AdminMsg(0xFF0000FF, warningStr);

        PunishPlayer(playerid, INVALID_PLAYER_ID, 60, 0, 0, false, cheatName);
    }
    else if (action == OW_ACTION_KICK)
    {
        format(warningStr, sizeof warningStr, "%s | {FFFF00}KICK", warningStr);
        AdminMsg(0xFF0000FF, warningStr);
        Kick_Timer(playerid);
    }
    else if (action == OW_ACTION_BAN)
    {
        format(warningStr, sizeof warningStr, "%s | {FF9900}BAN", warningStr);
        AdminMsg(0xFF0000FF, warningStr);
        
        new banTime = gettime() + (1000 * 24 * 60 * 60); // ban 1000 dana
        banuj_igraca(playerid, cheatName, banTime, "Overwatch", true); 
    }

    return 1;
}

stock OW_GetCheatName(E_OVERWATCH_CONFIG:cheatCode, cheatName[MAX_CHEATNAME_LEN])
{
    switch (cheatCode)
    {
        case OWC_WEAPON_HACK: format(cheatName, MAX_CHEATNAME_LEN, "Weapon Hack");
        case OWC_AMMO_HACK: format(cheatName, MAX_CHEATNAME_LEN, "Ammo Hack");
        case OWC_SPEED_HACK: format(cheatName, MAX_CHEATNAME_LEN, "Speed Hack");
        case OWC_VEHICLE_HEALTH_HACK: format(cheatName, MAX_CHEATNAME_LEN, "Vehicle Health Hack");
        case OWC_TELEPORT_HACK: format(cheatName, MAX_CHEATNAME_LEN, "Teleport Hack");
        case OWC_FAKE_KILL: format(cheatName, MAX_CHEATNAME_LEN, "Fake Kill");
        case OWC_CAR_WARP: format(cheatName, MAX_CHEATNAME_LEN, "Bacanje vozila");
        
        default: format(cheatName, MAX_CHEATNAME_LEN, "Nepoznato");
    }
}