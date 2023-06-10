#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define BROJ_ENTERIJERA (60)




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    kreirano_enterijera,
    bool:gPlayerOnEEPickup[MAX_PLAYERS char],
    gInteriorReload[MAX_PLAYERS],
    tmrPickupCheck[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_ENTER_EXIT_DATA
{
    EE_NAME_INSIDE[16],
    EE_NAME_OUTSIDE[16],
    Float:EE_ENTRANCE[4],
    Float:EE_EXIT[4],
    EE_INTERIOR_INSIDE,
    EE_INTERIOR_OUTSIDE,
    EE_VIRTUAL_INSIDE,
    EE_VIRTUAL_OUTSIDE,
    EE_PICKUP_INSIDE,
    EE_PICKUP_OUTSIDE,
    EE_FACTION_ID,
    Text3D:EE_LABEL,
};
new EnterExitData[BROJ_ENTERIJERA][E_ENTER_EXIT_DATA];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    kreirano_enterijera = 0;

    // CreateEnterExit("Ime unutra", "Ime spolja", X_Ulaza, Y_Uzlaza, Z_Ulaza, A_Ulaza, X_Izlaza, Y_Izlaza, Z_Izlaza, A_Izlaza, Ent_Unutra, Ent_Spolja, VW_Unutra, VW_Spolja, PickupID_spolja, PickupID_unutra, fid = -1);
    CreateEnterExit("Bank Tower",   "Los Santos",   1571.2075, -1336.6248, 16.4844, 317.0, 1548.5781, -1363.9017, 326.2183, 180.0, 0, 0, 0, 0, 19134, 19134);
    CreateEnterExit("Opstina",      "Los Santos",   1479.5127,-1770.9716,18.7958, 0.0,   -2614.5684,2593.3259,-98.0256,  270.0, 1, 0, 1, 0, 19134, 19134);
    CreateEnterExit("Banka",        "Los Santos",   1467.6831,-1010.7740,26.8438, 180.0, 1467.6146, -1008.0532, 26.8490, 180.0, 0, 0, 1, 0, 19134, 19134); // Prvo na desno
    CreateEnterExit("Banka",        "Los Santos",   1457.2053,-1010.2465,26.8438, 180.0, 1457.1614,-1008.2957,26.8490, 0.0, 0, 0, 1, 0, 19134, 19134); // Drugi na lijevo
    CreateEnterExit("Auto skola",   "Los Santos",   1081.2271, -1693.5883, 13.5320, 180.0, 1081.1718, -1690.0790, 13.5833,  0.0,   0, 0, 0, 0, 19134, 19134);
    //CreateEnterExit("Helipad",      "WTM",          1018.9896, -1450.4397, 13.6090, 270.0, 1002.5164, -1451.3940, 27.3450,  270.0, 0, 0, 0, 0, 19134, 19134);
    //CreateEnterExit("Zlatara",      "Los Santos",   893.0300, -1336.9585, 13.5469, 270.0, 893.1282, -1339.2886, 13.5735,  90.0,  0, 0, 0, 0, 19134, 19134);
    CreateEnterExit("Zlatara",      "Los Santos",   607.7417, -1458.4033, 14.3721, 90.0, 605.0284, -1458.3871, 14.7721,  -90.0,  0, 0, 0, 0, 19134, 19134);
    CreateEnterExit("Crno trziste", "Brod",         2844.7534, -2353.5203, 19.2058, 0.0,   2837.5327, -2377.1472, 2.2652,   180.0, 1, 0, 1, 0, 19134, 19134);
    //CreateEnterExit("Zatvor",       "Los Santos",   1798.1968, -1578.8097, 14.0921, 278.1, 1396.4366,-33.5264,1000.9987,  90.0,  1, 0, 50, 0, 19134, 19134);
    //CreateEnterExit("Auto salon",   "Los Santos",   2055.3174, -1919.1947, 13.5324, 180.0, 2055.4448, -1916.3523, 13.5408,  0.0, 0, 0, 0, 0, 19134, 19134); // salon za kucna vozila
    CreateEnterExit("Casino",       "Las Venturas", 2197.2366, 1677.1932, 12.3198, 0.0, 2233.8325, 1714.7197, 1012.3652,  0.0, 1, 0, 1, 0, 19134, 19134);
    //CreateEnterExit("Auto salon",   "Los Santos",   1777.5338, -1704.0367, 13.5492, 0.0, 1777.5164, -1702.9290, 13.5492, 180.0, 0, 0, 0, 0, 19134, 19134);
    CreateEnterExit("Bolnica",      "Los Santos", 1172.53650, -1321.45325, 15.51260, 0.0, 1206.2377, -1340.6337, -47.6863, 0.0, 0, 0, 1, 0, 19134, 19134);
    CreateEnterExit("Bolnica",      "Los Santos", 1172.53650, -1325.3616, 15.5126, 0.0, 1206.2377, -1340.6337, -47.6863, 0.0, 0, 0, 1, 0, 19134, 19134);
    
    CreateDynamic3DTextLabel("BOLNICA\n{FFFFFF}/izlecime ($1000)", 0x00FF00FF, 1179.2001, -1340.8306, -47.7317+0.1, 7.5, .worldid = 1);
    CreateDynamicPickup(1241, 2, 1179.2001, -1340.8306, -47.7317, 1);
    return true;
}

hook OnPlayerConnect(playerid) 
{
    gInteriorReload[playerid] = GetTickCount();
    tmrPickupCheck[playerid] = 0;
    gPlayerOnEEPickup{playerid} = false;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if (gInteriorReload[playerid] > GetTickCount()) return 1;
    if (GetPVarInt(playerid, "pTeleportFreeze") == 1) return 1;

    if ((((newkeys & KEY_SPRINT) || (newkeys & KEY_SECONDARY_ATTACK)) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT  && IsPlayerControllable_OW(playerid)) || (newkeys & KEY_HANDBRAKE && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)) // Space
    {
        for (new i = 1; i <= kreirano_enterijera; i++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 1.5, EnterExitData[i][EE_ENTRANCE][POS_X], EnterExitData[i][EE_ENTRANCE][POS_Y], EnterExitData[i][EE_ENTRANCE][POS_Z]) && GetPlayerVirtualWorld(playerid) == EnterExitData[i][EE_VIRTUAL_OUTSIDE] && GetPlayerInterior(playerid) == EnterExitData[i][EE_INTERIOR_OUTSIDE]) // Ulazak
            {
                if (!strcmp(EnterExitData[i][EE_NAME_INSIDE], "Banka", true) && !IsPlayerInAnyVehicle(playerid))
                {
                    if (IsBankRobberyInProgress() && !IsACop(playerid))
                    {
                        ErrorMsg(playerid, "Ovaj ulaz je zakljucan jer je pljacka u toku!");
                        return ~1;
                    }
                    else
                    {
                        new h, m;
                        gettime(h, m);
                        if (!IsBankOpen() && h > 0 && h < 9)
                        {
                            GameTextForPlayer(playerid, "~r~Banka je zatvorena!~n~Dodjite izmedju 9h i 01h", 5000, 1);
                            return ~1;
                        }
                    }
                }
                if (!strcmp(EnterExitData[i][EE_NAME_INSIDE], "Zlatara", true) && !IsPlayerInAnyVehicle(playerid))
                {
                    new h, m;
                    gettime(h, m);
                    if (h > 1 && h < 10 && !IsAdmin(playerid, 6))
                    {
                        GameTextForPlayer(playerid, "~r~Zlatara je zatvorena!~n~Dodjite izmedju 10h i 01h", 5000, 1);
                        return ~1;
                    }
                }
                /*if(!strcmp(EnterExitData[i][EE_NAME_INSIDE], "Benefit Room", true) && !IsPlayerInAnyVehicle(playerid))
                {
                    new
                        areas[1],
                        turfid
                    ;
                    GetPlayerDynamicAreas(playerid, areas);
                    turfid = GetTurfByArea(areas[0]);
                    if(turfid != -1)
                    {
                        if(GetPlayerFactionID(playerid) != GetTurfFactionID(turfid) && GetPlayerFactionID(playerid) != -1)
                        {
                            GameTextForPlayer(playerid, "~r~Zakljucano", 3000, 3);
                            return 1;
                        }
                    }
                }*/
                if (EnterExitData[i][EE_FACTION_ID] != -1 && PI[playerid][p_org_id] != EnterExitData[i][EE_FACTION_ID]) {
                    // Enterijer koji pripada nekoj o/m/b koja nije njegova
                    if (!IsAdmin(playerid, 5)) {
                        GameTextForPlayer(playerid, "~r~Zakljucano", 3000, 3);
                        return ~1;
                    }
                }

                if(EnterExitData[i][EE_FACTION_ID] != -1 && !IsFactionLoaded(EnterExitData[i][EE_FACTION_ID]))
                    return 1;

                new
                    vehid = -1
                ;

                if(IsPlayerInAnyVehicle(playerid))
                {
                    if(EnterExitData[i][EE_FACTION_ID] != 4 && EnterExitData[i][EE_FACTION_ID] != 1)
                        return 1;
                    
                    vehid = GetPlayerVehicleID(playerid);
                }

                OW_SetupAntiSpawnKill(playerid, 5);
                SetPlayerCompensatedPosEx(playerid, EnterExitData[i][EE_EXIT][POS_X], EnterExitData[i][EE_EXIT][POS_Y], EnterExitData[i][EE_EXIT][POS_Z], EnterExitData[i][EE_EXIT][POS_A], EnterExitData[i][EE_VIRTUAL_INSIDE], EnterExitData[i][EE_INTERIOR_INSIDE], 5000);

                // Pink Panteri i Escobar Cartel da mogu vozila ubacivati 
                if(vehid != -1) 
                {
                    SetVehicleCompensatedPos(vehid, EnterExitData[i][EE_EXIT][POS_X], EnterExitData[i][EE_EXIT][POS_Y], EnterExitData[i][EE_EXIT][POS_Z], EnterExitData[i][EE_VIRTUAL_INSIDE], EnterExitData[i][EE_INTERIOR_INSIDE], 4000);
                    PutPlayerInVehicle(playerid, vehid, 0);
                    SetTimerEx("PutInVeh", 4500, false, "iifff", playerid, vehid, EnterExitData[i][EE_EXIT][POS_X], EnterExitData[i][EE_EXIT][POS_Y], EnterExitData[i][EE_EXIT][POS_Z]);
                }

                format(string_32, 32, "~w~%s", EnterExitData[i][EE_NAME_INSIDE]);
                GameTextForPlayer(playerid, string_32, 5000, 1);

                gInteriorReload[playerid] = GetTickCount() + 750;
                return ~1;
            }
            if (IsPlayerInRangeOfPoint(playerid, 1.5, EnterExitData[i][EE_EXIT][POS_X], EnterExitData[i][EE_EXIT][POS_Y], EnterExitData[i][EE_EXIT][POS_Z]) && GetPlayerVirtualWorld(playerid) == EnterExitData[i][EE_VIRTUAL_INSIDE] && GetPlayerInterior(playerid) == EnterExitData[i][EE_INTERIOR_INSIDE]) // Izlazak
            {
                if (!strcmp(EnterExitData[i][EE_NAME_INSIDE], "Banka", true) && !IsPlayerInAnyVehicle(playerid))
                {
                    if (IsBankRobberyInProgress() && GetFactionRobbingBank() == PI[playerid][p_org_id])
                    {
                        ErrorMsg(playerid, "Ovaj izlaz je zakljucan jer je pljacka u toku!");
                        return ~1;
                    }
                }
                /*if(!strcmp(EnterExitData[i][EE_NAME_INSIDE], "Benefit Room", true) && !IsPlayerInAnyVehicle(playerid))
                {
                    new
                        areas[1],
                        turfid
                    ;
                    GetPlayerDynamicAreas(playerid, areas);
                    turfid = GetTurfByArea(areas[0]);
                    if(turfid != -1)
                    {
                        if(GetPlayerFactionID(playerid) != GetTurfFactionID(turfid) && GetPlayerFactionID(playerid) != -1)
                        {
                            GameTextForPlayer(playerid, "~r~Zakljucano", 3000, 3);
                            return 1;
                        }
                    }
                }*/
                if (EnterExitData[i][EE_FACTION_ID] != -1 && PI[playerid][p_org_id] != EnterExitData[i][EE_FACTION_ID]) 
                {
                    // Enterijer koji pripada nekoj o/m/b koja nije njegova
                    if (!IsAdmin(playerid, 5)) 
                    {
                        GameTextForPlayer(playerid, "~r~Zakljucano", 3000, 3);
                        return ~1;
                    }
                }

                new
                    vehid = -1
                ;

                if(IsPlayerInAnyVehicle(playerid))
                {
                    if(EnterExitData[i][EE_FACTION_ID] != 4 && EnterExitData[i][EE_FACTION_ID] != 1)
                        return 1;
                    
                    vehid = GetPlayerVehicleID(playerid);
                }

                OW_SetupAntiSpawnKill(playerid, 5);

                SetPlayerCompensatedPosEx(playerid, EnterExitData[i][EE_ENTRANCE][POS_X], EnterExitData[i][EE_ENTRANCE][POS_Y], EnterExitData[i][EE_ENTRANCE][POS_Z], EnterExitData[i][EE_ENTRANCE][POS_A], EnterExitData[i][EE_VIRTUAL_OUTSIDE], EnterExitData[i][EE_INTERIOR_OUTSIDE], 5000);
    
                // Pink Panteri i Escobar Cartel da mogu vozila ubacivati
                if(vehid != -1)
                {
                    SetVehicleCompensatedPos(vehid, EnterExitData[i][EE_ENTRANCE][POS_X], EnterExitData[i][EE_ENTRANCE][POS_Y], EnterExitData[i][EE_ENTRANCE][POS_Z], EnterExitData[i][EE_VIRTUAL_OUTSIDE], EnterExitData[i][EE_INTERIOR_OUTSIDE], 4000);
                    PutPlayerInVehicle(playerid, vehid, 0);
                    SetTimerEx("PutInVeh", 4500, false, "iifff", playerid, vehid, EnterExitData[i][EE_ENTRANCE][POS_X], EnterExitData[i][EE_ENTRANCE][POS_Y], EnterExitData[i][EE_ENTRANCE][POS_Z]);
                }

                format(string_32, 32, "~w~%s", EnterExitData[i][EE_NAME_OUTSIDE]);
                GameTextForPlayer(playerid, string_32, 5100, 1);
                
                gInteriorReload[playerid] = GetTickCount() + 750;
                return 1;
            }
        }
    }
    return 1;
}

forward PutInVeh(playerid, vehid, Float:x, Float:y, Float:z);
public PutInVeh(playerid, vehid, Float:x, Float:y, Float:z)
{
    if(vehid == INVALID_VEHICLE_ID)
        return 1;
    
    SetVehiclePos(vehid, x, y, z);
    PutPlayerInVehicle(playerid, vehid, 0);
    return 1;
}


// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock CreateEnterExit(const NameIn[16], const NameOut[16], Float:entrance_X, Float:entrance_Y, Float:entrance_Z, Float:entrance_A, Float:exit_X, Float:exit_Y, Float:exit_Z, Float:exit_A, InteriorIn, InteriorOut, VirtualIn, VirtualOut, pickupOut, pickupIn, fid = -1) 
{
    new entid = ++kreirano_enterijera;

    if (kreirano_enterijera >= BROJ_ENTERIJERA) {
        printf("\n------------------------\nBROJ ENTERIJERA JE PREKORACEN\n------------------------");
        return 1;
    }

    strmid(EnterExitData[entid][EE_NAME_INSIDE], NameIn, 0, strlen(NameIn), 16);
    strmid(EnterExitData[entid][EE_NAME_OUTSIDE], NameOut, 0, strlen(NameOut), 16);
    EnterExitData[entid][EE_ENTRANCE][POS_X]  = entrance_X;
    EnterExitData[entid][EE_ENTRANCE][POS_Y]  = entrance_Y;
    EnterExitData[entid][EE_ENTRANCE][POS_Z]  = entrance_Z;
    EnterExitData[entid][EE_ENTRANCE][POS_A]  = entrance_A;
    EnterExitData[entid][EE_EXIT][POS_X]      = exit_X;
    EnterExitData[entid][EE_EXIT][POS_Y]      = exit_Y;
    EnterExitData[entid][EE_EXIT][POS_Z]      = exit_Z;
    EnterExitData[entid][EE_EXIT][POS_A]      = exit_A;
    EnterExitData[entid][EE_INTERIOR_INSIDE]  = InteriorIn;
    EnterExitData[entid][EE_INTERIOR_OUTSIDE] = InteriorOut;
    EnterExitData[entid][EE_VIRTUAL_INSIDE]   = VirtualIn;
    EnterExitData[entid][EE_VIRTUAL_OUTSIDE]  = VirtualOut;
    EnterExitData[entid][EE_FACTION_ID]       = fid;

    if(pickupOut != -1)
        EnterExitData[entid][EE_PICKUP_OUTSIDE] = CreateDynamicPickup(pickupOut, 1, EnterExitData[entid][EE_ENTRANCE][POS_X], EnterExitData[entid][EE_ENTRANCE][POS_Y], EnterExitData[entid][EE_ENTRANCE][POS_Z], EnterExitData[entid][EE_VIRTUAL_OUTSIDE], EnterExitData[entid][EE_INTERIOR_OUTSIDE]); // Pickup spolja

    EnterExitData[entid][EE_PICKUP_INSIDE] = CreateDynamicPickup(pickupIn, 1, EnterExitData[entid][EE_EXIT][POS_X], EnterExitData[entid][EE_EXIT][POS_Y], EnterExitData[entid][EE_EXIT][POS_Z], EnterExitData[entid][EE_VIRTUAL_INSIDE], EnterExitData[entid][EE_INTERIOR_INSIDE]); // Pickup unutra


    if (fid == -1 && strcmp(NameIn, "Benefit Room", true))
    {
        new sLabel[65];
        format(sLabel, sizeof sLabel, "[ %s ]\nKoristite {FF6600}ENTER {FF9933}da udjete", EnterExitData[entid][EE_NAME_INSIDE]);
        EnterExitData[entid][EE_LABEL] = CreateDynamic3DTextLabel(sLabel, 0xFF9933FF, EnterExitData[entid][EE_ENTRANCE][POS_X], EnterExitData[entid][EE_ENTRANCE][POS_Y], EnterExitData[entid][EE_ENTRANCE][POS_Z], 12.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, EnterExitData[entid][EE_VIRTUAL_OUTSIDE], EnterExitData[entid][EE_INTERIOR_OUTSIDE]);
    }
    return entid;
}

forward TeleportUnfreeze(playerid, ccinc);
public TeleportUnfreeze(playerid, ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    DeletePVar(playerid, "pTeleportFreeze");
    TogglePlayerControllable_H(playerid, true);
    gInteriorReload[playerid] = GetTickCount() + 750;

    TextDrawHideForPlayer(playerid, TD_LoadingObjects);
    return 1;
}


forward CheckPlayerPickup(playerid, Float:x, Float:y, Float:z);
public CheckPlayerPickup(playerid, Float:x, Float:y, Float:z)
{
    #if defined DEBUG_FUNCTION_TIMERS
        Debug("timer", "CheckPlayerPickup");
    #endif

    if (!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
    {
        gPlayerOnEEPickup{playerid} = false;
        KillTimer(tmrPickupCheck[playerid]);
    }

    return 1;
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
