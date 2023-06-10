#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bool:gLowOnFuel[MAX_PLAYERS char],
    bool:gOutOfFuel[MAX_PLAYERS char],
    bool:gFuelLampShown[MAX_PLAYERS char],

    Float:gVehicleFuel[MAX_VEHICLES],               
    Float:gVehicleFuelLimit[MAX_VEHICLES],
    tmrRefueling[MAX_PLAYERS]
;




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    SetTimer("Vehicle_BurnFuel", 30000, true);

    CreateDynamic3DTextLabel("[ Benzinska pumpa ]\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo", 0xFFFF00FF, -2.4094,-1578.4861,0.3, 15.0); // Za plovila
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    gLowOnFuel{playerid} = gOutOfFuel{playerid} = gFuelLampShown{playerid} = false;
    tmrRefueling[playerid] = 0;
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (oldstate == PLAYER_STATE_DRIVER) 
    {
        gOutOfFuel{playerid} = false;
        SetPlayerFuelBlinkerShown(playerid, false);
    }

    if (newstate == PLAYER_STATE_DRIVER) 
    {
        new 
            vehicleid = GetPlayerVehicleID(playerid),
            modelid   = GetVehicleModel(vehicleid);
        if (IsVehicleBicycle(modelid)) 
        {
            gVehicleFuel[vehicleid] = 1000.0;
            gVehicleFuelLimit[vehicleid] = 1000.0;
            SetVehicleParamsEx(vehicleid, 1, 0, 0, 0, 0, 0, 0);
        }
    }

    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
// forward Float:GetVehicleTankVolume(vehicleid);
// forward Float:GetVehicleFuel(vehicleid);

stock FUEL_SetupVehicle(vehicleid, model)
{
    if (IsVehicleBicycle(model) == 1) 
    {
        SetVehicleFuel(vehicleid, -1);
        SetVehicleTankVolume(vehicleid, -1);
    }
    else if (IsVehicleTruck(model) || IsVehicleHelicopter(model) || IsVehicleAirplane(model) || IsVehicleBoat(model) || model == 538) 
    {
        SetVehicleFuel(vehicleid, 100.0);
        SetVehicleTankVolume(vehicleid, 100.0);
    }
    else if (IsVehicleMotorbike(model)) 
    {
        SetVehicleFuel(vehicleid, 20.0);
        SetVehicleTankVolume(vehicleid, 20.0);
    }
    else 
    {
        if (IsVehicleBicycle(model)) 
        {
            SetVehicleParamsEx(vehicleid, 1, 0, 0, 0, 0, 0, 0);
            SetVehicleFuel(vehicleid, 100.0);
            SetVehicleTankVolume(vehicleid, 100.0);
        }
        else 
        {
            SetVehicleFuel(vehicleid, 55.0);
            SetVehicleTankVolume(vehicleid, 55.0);
        }
    }
}

forward Vehicle_BurnFuel(); // Tajmer
public Vehicle_BurnFuel() 
{
        
    // #if defined DEBUG_FUNCTION_TIMERS
    //     Debug("timer", "Vehicle_BurnFuel");
    // #endif

    new model, engine, lights, alarm, doors, bonnet, boot, objective;
    foreach (new i : iVehicles) 
    {
        model = GetVehicleModel(i);
        if (!(400 <= model <= 611)) 
        {
            Iter_Remove(iVehicles, i); // Nevazeci model vozila -> izbrisi ga iz iteratora
            continue;
        }
        if (vozilo_za_event(i) || IsVehicleBicycle(model)) continue;

        GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);

        if (engine == 1 && gVehicleFuel[i] > 0.00) 
        {
            gVehicleFuel[i] = floatsub(gVehicleFuel[i], 0.2);
            if (gVehicleFuel[i] < 0.0) gVehicleFuel[i] = 0.0;
        }
    }

    return 1;
}

forward fuel_Tocenje(playerid, kol, firma_gid, ccinc, kanister);
public fuel_Tocenje(playerid, kol, firma_gid, ccinc, kanister) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("fuel_Tocenje");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    tmrRefueling[playerid] = 0;
    TogglePlayerControllable_H(playerid, true);


    if (PI[playerid][p_novac] < re_firma_cenaGoriva(firma_gid)*kol)
        return GameTextForPlayer(playerid, "~r~Nedovoljno novca", 4000, 3);
    PlayerMoneySub(playerid, re_firma_cenaGoriva(firma_gid)*kol);

    if (firma_gid != -1) 
    {

        re_firma_dodaj_novac(firma_gid, re_firma_cenaGoriva(firma_gid)*kol);
        
        if (strcmp(RealEstate[firma_gid][RE_VLASNIK], "Niko", true))
            F_PRODUCTS[re_localid(firma, firma_gid)][48][f_stock] -= kol; // Oduzimamo proizvode samo ako firma IMA vlasnika
    }


    if (kanister == 0)
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
        if (GetPlayerVehicleID(playerid) == INVALID_VEHICLE_ID) return 1;

        new 
            vehicleid = GetPlayerVehicleID(playerid), 
            Float:ukupno = GetVehicleFuel(vehicleid) + kol;
        SetVehicleFuel(GetPlayerVehicleID(playerid), (ukupno>GetVehicleTankVolume(vehicleid))? GetVehicleTankVolume(vehicleid) : ukupno);

        format(string_64, 64, "~g~Tocenje zavrseno~n~~w~Sada imate ~y~%.1f ~w~litara goriva", GetVehicleFuel(GetPlayerVehicleID(playerid)));
        GameTextForPlayer(playerid, string_64, 3500, 3);
    }
    else
    {
        BP_PlayerItemAdd(playerid, ITEM_KANISTER);
        GameTextForPlayer(playerid, "~g~Tocenje zavrseno~n~~w~Kanister je napunjen", 3500, 3);
    }
    return 1;
}

stock SetVehicleFuel(vehicleid, Float:fuel) 
{
    if (vehicleid < 1 || vehicleid > MAX_VEHICLES)
        return 1;
        
    gVehicleFuel[vehicleid] = fuel;
    return 1;
}

stock SetVehicleTankVolume(vehicleid, Float:fuel) 
{
    if (vehicleid < 1 || vehicleid > MAX_VEHICLES)
        return 1;
        
    gVehicleFuelLimit[vehicleid] = fuel;
    return 1;
}

public Float:GetVehicleTankVolume(vehicleid) 
{
    if (vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 0.0;

    return gVehicleFuelLimit[vehicleid];
}

stock RefillVehicle(vehicleid) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "RefillVehicle");
    #endif
    if (vehicleid < 1 || vehicleid > MAX_VEHICLES)
        return 1;
        
    SetVehicleFuel(vehicleid, GetVehicleTankVolume(vehicleid));
    return 1;
}

public Float:GetVehicleFuel(vehicleid) 
{        
    if (vehicleid < 0 || vehicleid >= MAX_VEHICLES) return 0.0;

    return gVehicleFuel[vehicleid];
}

stock SetPlayerLowOnFuel(playerid, bool:status) 
{
    gLowOnFuel{playerid} = status;
    return 1;
}

stock IsPlayersVehicleLowOnFuel(playerid) 
{
    return gLowOnFuel{playerid};
}

stock SetPlayerOutOfFuel(playerid, bool:status) 
{
    gOutOfFuel{playerid} = status;
    return 1;
}

stock IsPlayersVehicleOutOfFuel(playerid) 
{       
    return gOutOfFuel{playerid};
}

stock SetPlayerFuelBlinkerShown(playerid, bool:status) 
{       
    gFuelLampShown{playerid} = status;
    return 1;
}

stock IsPlayerFuelBlinkerShown(playerid) 
{       
    return gFuelLampShown{playerid};
}

CMD:tocenje(playerid, const params[]) 
{
    if (tmrRefueling[playerid] != 0)
        return ErrorMsg(playerid, "Tocenje goriva je u toku.");

    if (!IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Ovu komandu mozete koristiti samo ako ste u vozilu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Ovu komandu mozete koristiti samo ako ste vozac.");

    new 
        vehicleid = GetPlayerVehicleID(playerid),
        gid = -1,
        kol,
        vremeTocenja;

    if (IsVehicleBicycle(GetVehicleModel(vehicleid)))
        return ErrorMsg(playerid, "Ne mozete sipati gorivo u bicikl.");

    if (GetVehicleTankVolume(vehicleid) <= 0.0)
        ErrorMsg(playerid, "[fuel.pwn] "GRESKA_NEPOZNATO" (01)");

    if ((GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid)) > 100.0 || (GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid)) < 0.0)
        ErrorMsg(playerid, "[fuel.pwn] "GRESKA_NEPOZNATO" (02)");

    for__loop (new i = re_globalid(firma, 1); i <= re_globalid(firma, MAX_FIRMI); i++) 
    {
        if (RealEstate[i][RE_VRSTA] != FIRMA_BENZINSKA) continue;

        if (IsPlayerInRangeOfPoint(playerid, 7.0, RealEstate[i][RE_INTERACT][0], RealEstate[i][RE_INTERACT][1], RealEstate[i][RE_INTERACT][2])) 
        {
            gid = i;
            break;
        }
    }

    if (gid == -1 && !IsPlayerInRangeOfPoint(playerid, 7.0, 1528.957153, -1686.031494, 6.473833) && !IsPlayerInRangeOfPoint(playerid, 7.0, 1448.7781,786.9559,10.3938) && !IsPlayerInRangeOfPoint(playerid, 7.0, 2582.6416,-2189.3118,0.6778) && !IsPlayerInRangeOfPoint(playerid, 10.0, -2.4094,-1578.4861,0.3))
        return ErrorMsg(playerid, "Ne nalazite se na mestu za tocenje goriva.");

    if (IsPlayerInRangeOfPoint(playerid, 7.0, 1528.957153, -1686.031494, 6.473833) && !IsACop(playerid)) 
        return ErrorMsg(playerid, "Samo pripadnici policije mogu tociti gorivo na ovom mestu.");

    if (IsPlayerInRangeOfPoint(playerid, 7.0, 2582.6416,-2189.3118,0.6778) && !IsARacer(playerid))
        return ErrorMsg(playerid, "Ne mozete tociti gorivo na ovom mestu.");

    if (IsPlayerInRangeOfPoint(playerid, 10.0, -2.4094,-1578.4861,0.3) && !IsVehicleBoat(GetVehicleModel(vehicleid)))
        return ErrorMsg(playerid, "Na ovom mestu mozete tociti gorivo iskljucivo u plovila.");

    if (sscanf(params, "i", kol)) 
    {
        Koristite(playerid, "tocenje [kolicina goriva u litrima]");
        return SendClientMessageF(playerid, GRAD2, "* Trenutno mozete sipati najvise {FFFFFF}%d {BFC0C2}litara.", floatround(GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid), floatround_floor));
    }

    if (kol < 1)
        return ErrorMsg(playerid, "Mozete natociti najmanje 1 litar goriva.");

    if (kol > floatround(GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid), floatround_floor))
        return SendClientMessageF(playerid, GRAD2, "* Trenutno mozete sipati najvise {FFFFFF}%d {BFC0C2}litara.", floatround(GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid), floatround_floor));

    if (gid != -1 && F_PRODUCTS[re_localid(firma, gid)][48][f_stock] < kol)
        return ErrorMsg(playerid, "Na ovoj pumpi trenutno nema toliko goriva. Pokusajte sa manjom kolicinom ili pronadjite drugu pumpu.");

    TogglePlayerControllable_H(playerid, false);
    GameTextForPlayer(playerid, "~b~Tocenje goriva je u toku~n~~w~molimo sacekajte...", 3500, 3);
    vremeTocenja = kol*200;
    tmrRefueling[playerid] = SetTimerEx("fuel_Tocenje", (vremeTocenja<5000)? 5000 : vremeTocenja, false, "iiiii", playerid, kol, gid, cinc[playerid], 0);
    return 1;
}

CMD:kanister(playerid, const params[])
{
    SendClientMessage(playerid, BELA, "Koristite: /napunikanister - da napunite svoj kanister na benzinskoj pumpi");
    SendClientMessage(playerid, BELA, "Koristite: /dopunikanisterom - da dopunite bilo koje vozilo gorivom iz kanistera");
    return 1;
}

CMD:napunikanister(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_KANISTER))
        return ErrorMsg(playerid, "Ne posedujete kanister.");

    if (tmrRefueling[playerid] != 0)
        return ErrorMsg(playerid, "Tocenje goriva je u toku.");

    new gid = -1;
    for__loop (new i = re_globalid(firma, 1); i <= re_globalid(firma, MAX_FIRMI); i++) 
    {
        if (RealEstate[i][RE_VRSTA] != FIRMA_BENZINSKA) continue;

        if (IsPlayerInRangeOfPoint(playerid, 7.0, RealEstate[i][RE_INTERACT][0], RealEstate[i][RE_INTERACT][1], RealEstate[i][RE_INTERACT][2])) 
        {
            gid = i;
            break;
        }
    }
    InfoMsg(playerid, "detektovao sam firmu ID: %d", gid);
    if (gid == -1 && !IsPlayerInRangeOfPoint(playerid, 7.0, 1528.957153, -1686.031494, 6.47383))
        return ErrorMsg(playerid, "Ne nalazite se na mestu za tocenje goriva.");

    if (IsPlayerInRangeOfPoint(playerid, 7.0, 1528.957153, -1686.031494, 6.47383) && !IsACop(playerid)) 
        return ErrorMsg(playerid, "Samo pripadnici policije mogu tociti gorivo na ovom mestu.");

    if (gid != -1 && F_PRODUCTS[re_localid(firma, gid)][48][f_stock] < 5)
        return ErrorMsg(playerid, "Na ovoj pumpi trenutno nema toliko goriva. Pokusajte sa manjom kolicinom ili pronadjite drugu pumpu.");

    if (BP_PlayerItemGetCount(playerid, ITEM_KANISTER) > 1)
        return ErrorMsg(playerid, "Vas kanister je pun goriva, ne mozete vise sipati u njega.");

    if (PI[playerid][p_novac] < re_firma_cenaGoriva(gid)*5)
        return GameTextForPlayer(playerid, "~r~Nedovoljno novca", 4000, 3);

    TogglePlayerControllable_H(playerid, false);
    GameTextForPlayer(playerid, "~b~Tocenje goriva je u toku~n~~w~molimo sacekajte...", 3500, 3);
    tmrRefueling[playerid] = SetTimerEx("fuel_Tocenje", 5000, false, "iiiii", playerid, 5, -1, cinc[playerid], 1);
    return 1;
}

CMD:dopunikanisterom(playerid, const params[])
{
    if (tmrRefueling[playerid] != 0)
        return ErrorMsg(playerid, "Tocenje goriva je u toku.");

    if (!BP_PlayerHasItem(playerid, ITEM_KANISTER))
        return ErrorMsg(playerid, "Ne posedujete kanister.");

    if (BP_PlayerItemGetCount(playerid, ITEM_KANISTER) <= 1)
        return ErrorMsg(playerid, "Vas kanister je prazan.");

    if (!IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti u vozilu.");

    new engine, lights, alarm, doors, bonnet, boot, objective,
        vehicleid = GetPlayerVehicleID(playerid);

    if (IsVehicleBicycle(GetVehicleModel(vehicleid)))
        return ErrorMsg(playerid, "Ne mozete sipati gorivo u bicikl.");

    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (engine == 1)
        return ErrorMsg(playerid, "Motor vozila mora biti ugasen.");

    if (5 > floatround(GetVehicleTankVolume(vehicleid)-GetVehicleFuel(vehicleid), floatround_floor))
        return ErrorMsg(playerid, "U vozilu ima previse goriva da biste ga dopunili iz kanistera.");

    BP_PlayerItemSub(playerid, ITEM_KANISTER);
    TogglePlayerControllable_H(playerid, false);
    GameTextForPlayer(playerid, "~b~Tocenje goriva je u toku~n~~w~molimo sacekajte...", 3500, 3);
    tmrRefueling[playerid] = SetTimerEx("fuel_Tocenje", 5000, false, "iiiii", playerid, 5, -1, cinc[playerid], 0);

    return 1;
}
