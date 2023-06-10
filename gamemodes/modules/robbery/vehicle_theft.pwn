#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define VEH_DELIVERY_X (208.6916)
#define VEH_DELIVERY_Y (-231.2697)
#define VEH_DELIVERY_Z (1.7786)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pVehicleTheft[MAX_PLAYERS],
    pStolenVehID[MAX_PLAYERS],
    vehDeliveryCP,
    vehDeliveryActor;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    vehDeliveryCP = CreateDynamicCP(VEH_DELIVERY_X, VEH_DELIVERY_Y, VEH_DELIVERY_Z, 5.0, -1, -1, -1, 10.0);
    vehDeliveryActor = CreateDynamicActor(50, 213.1476,-224.9931,1.7786,180.0);

    ApplyDynamicActorAnimation(vehDeliveryActor, "MISC","Plyrlean_loop", 4.1, 0, 0, 0, 1, 0);
    return true;
}

hook OnPlayerConnect(playerid)
{
    pVehicleTheft[playerid] = pStolenVehID[playerid] = -1;
}

hook OnPlayerSpawn(playerid)
{
    pVehicleTheft[playerid] = pStolenVehID[playerid] = -1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == vehDeliveryCP)
    {
        OnPlayerDeliverVehicle(playerid);
    }
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, VEH_DELIVERY_X, VEH_DELIVERY_Y, VEH_DELIVERY_Z))
    {
        OnPlayerDeliverVehicle(playerid);
    }
    return true;
}

hook OnBurglaryProgress(playerid, progress)
{
    if (pVehicleTheft[playerid] != -1)
    {
        new vehSecurity = OwnedVehicle_GetSecurity(pVehicleTheft[playerid]),
            vehicleid = OwnedVehicle[pVehicleTheft[playerid]][V_ID],
            engine, lights, alarm, doors, bonnet, boot, objective,

            alarmProgressTreshold = 101,
            alarmRepeatBeep = 101
        ;


        
        if (vehSecurity == 0)
        {
            alarmProgressTreshold = alarmRepeatBeep = 101; // 101 da se nikad ne bi dostiglo / ignore
        }
        else if (vehSecurity == 30)
        {
            // Mali alarm
            alarmProgressTreshold = 80;
            alarmRepeatBeep = 101;
        }
        else if (vehSecurity == 60)
        {
            // Za srednji alarm
            alarmProgressTreshold = 40;
            alarmRepeatBeep = 80;
        }
        else if (vehSecurity == 80)
        {
            // Za veliki alarm
            alarmProgressTreshold = 20;
            alarmRepeatBeep = 70;
        }
        else if (vehSecurity == 100)
        {
            // Za ultra alarm
            alarmProgressTreshold = 0;
            alarmRepeatBeep = 50;
        }


        if (progress == alarmProgressTreshold)
        {
            DebugMsg(playerid, "Progress = %i %% | Alarm se ukljucuje", progress);

            GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            SetVehicleParamsEx(vehicleid, engine, lights, 1, doors, bonnet, boot, objective);

            AddPlayerCrime(playerid, INVALID_PLAYER_ID, 3, "Pokusaj kradje vozila");
            Police_NotifyVehTheft(vehicleid);
            
        }
        else if (progress == alarmRepeatBeep)
        {
            GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            if (alarm)
            {
                // Opet ukljucujemo alarm ukoliko je bio ukljucen (jer sam od sebe prestane da svira nakon nekog vremena)
                SetVehicleParamsEx(vehicleid, engine, lights, 1, doors, bonnet, boot, objective);
            }
        }
    }
    return 1;
}

hook OnBurglarySuccess(playerid)
{
    if (pVehicleTheft[playerid] != -1)
    {
        new Float:vPos[3], vehicleid = OwnedVehicle[pVehicleTheft[playerid]][V_ID];
        GetVehiclePos(vehicleid, vPos[0], vPos[1], vPos[2]);
        if (!IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]))
        {
            ErrorMsg(playerid, "Udaljili ste se od vozila koje ste pokusali da ukradete.");
            pVehicleTheft[playerid] = -1;
            return 1;
        }

        new bool:failed = false;
        foreach (new i : Player)
        {
            if (GetPlayerVehicleID(i) == vehicleid)
            {
                failed = true;
                break;
            }
        }
        if (failed)
        {
            ErrorMsg(playerid, "Neko je usao u vozilo koje ste pokusali da ukradete.");
            pVehicleTheft[playerid] = -1;
            return 1;
        }


        // Iskljucivanje alarma
        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, engine, lights, 0, doors, bonnet, boot, objective);


        // Reload time
        PI[playerid][p_reload_vehicle_theft] = gettime() + 300; // 5 minuta cooldown        
        new sQuery[73];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET reload_vehicle_theft = %i WHERE id = %i", PI[playerid][p_reload_vehicle_theft], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);


        // Provera za alarm
        new vehSecurity = floatround(OwnedVehicle_GetSecurity(pVehicleTheft[playerid])/10.0);
        if (random(10) < vehSecurity)
        {
            GameTextForPlayer(playerid, "~N~~N~~R~KRADJA NIJE USPELA!", 5000, 3);
            pVehicleTheft[playerid] = -1;
            return 1;
        }

        // Sve provere su OK, obijanje uspesno
        // PutPlayerInVehicle(playerid, vehicleid, 0);  
        GameTextForPlayer(playerid, "~g~Obijanje uspesno~n~~w~Odvezi vozilo do oznacene lokacije!", 5000, 3);
        SetGPSLocation(playerid, VEH_DELIVERY_X, VEH_DELIVERY_Y, VEH_DELIVERY_Z, "auto deponija");

        // Otkljucavanje vozila
        OwnedVehicle[pVehicleTheft[playerid]][V_LOCKED] = 0;

        pStolenVehID[playerid] = pVehicleTheft[playerid];
        pVehicleTheft[playerid] = -1;
    }
    return 1;
}

hook OnBurglaryFail(playerid)
{
    if (pVehicleTheft[playerid] != -1)
    {
        new vehicleid = OwnedVehicle[pVehicleTheft[playerid]][V_ID],
            engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(vehicleid, engine, lights, 0, doors, bonnet, boot, objective);

        pVehicleTheft[playerid] = -1;
    }
    return 1;
}

hook OnBurglaryStop(playerid)
{
    if (pVehicleTheft[playerid] != -1)
    {
        pVehicleTheft[playerid] = -1;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock VehicleTheft_Start(playerid, veh)
{
    // Odredjujemo brzinu obijanja na osnovu skill-a
    new theftPace = 1500 - 150*VehicleTheft_GetPlayerLevel(playerid);
    if (theftPace < 750) theftPace = 750; // za svaki slucaj, da ne bude prebrzo

    PlayerStartBurglary(playerid, theftPace);
    pVehicleTheft[playerid] = veh;
}

stock OnPlayerDeliverVehicle(playerid)
{
    if (pStolenVehID[playerid] != -1)
    {
        if (GetPlayerVehicleID(playerid) == OwnedVehicle[pStolenVehID[playerid]][V_ID])
        {
            // Igrac se nalazi u vozilu koje je ukrao

            new pay, value = OwnedVehicle_GetPrice(pStolenVehID[playerid]), Float:health;
            GetVehicleHealth(GetPlayerVehicleID(playerid), health);

            if (value < 100000) pay = 2000;
            else if (value < 300000) pay = 3000;
            else if (value < 600000) pay = 4000;
            else if (value < 1000000) pay = 5000;
            else if (value < 1600000) pay = 6000;
            else if (value < 2000000) pay = 7000;
            else if (value >= 2000000) pay = 8000;
            if (pay < 2000) pay = 2000;
            if (pay > 8000) pay = 8000;

            new rand = floatround(health/1000)*100 * 10;
            if (rand < 300) rand = 300;
            if (rand > 1000) rand = 1000;

            pay += random(rand);
            pay += (VehicleTheft_GetPlayerLevel(playerid)-1)*1000; // bonus za skill

            PlayerMoneyAdd(playerid, pay);
            InfoMsg(playerid, "Vozilo je uspesno isporuceno. Zaradili ste {FFFF00}%s.", formatMoneyString(pay));
            VehicleTheft_SetColors(playerid, OwnedVehicle[pStolenVehID[playerid]][V_COLOR_1], OwnedVehicle[pStolenVehID[playerid]][V_COLOR_2]);
            PlayerUpdateCriminalSkill(playerid, 1, SKILL_ROBBERY_CAR, 0);

            OwnedVehicle[ pStolenVehID[playerid] ][V_LOCKED] = 1;
            OwnedVehicle[ pStolenVehID[playerid] ][V_HEALTH] = 250.1;
            OwnedVehicle[ pStolenVehID[playerid] ][V_FUEL]   = 0.0;
            SetVehicleToRespawn(GetPlayerVehicleID(playerid));

            // Reload time
            PI[playerid][p_reload_vehicle_theft] = gettime() + 900; // 15 minuta cooldown 

            // Udate podataka u bazi      
            new sQuery[72];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET reload_vehicle_theft = %i WHERE id = %i", PI[playerid][p_reload_vehicle_theft], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);

            new sQuery2[64];
            format(sQuery2, sizeof sQuery2, "UPDATE vozila SET gorivo = 0.0, health = 250.1 WHERE id = %i", pStolenVehID[playerid]);
            mysql_tquery(SQL, sQuery2);

            pStolenVehID[playerid] = -1;
        }
    }
    return 1;
}

stock VehicleTheft_SetColors(playerid, color1, color2)
{
    SetPVarInt(playerid, "pVehTheft_Color1", color1);
    SetPVarInt(playerid, "pVehTheft_Color2", color2);
}

stock VehicleTheft_GetColors(playerid, &color1, &color2)
{
    color1 = GetPVarInt(playerid, "pVehTheft_Color1");
    color2 = GetPVarInt(playerid, "pVehTheft_Color2");

    DeletePVar(playerid, "pVehTheft_Color1");
    DeletePVar(playerid, "pVehTheft_Color2");
}

stock VehicleTheft_GetPlayerLevel(playerid)
{
    new stolenCars = PI[playerid][p_stolen_cars], 
        level = floatround(stolenCars/50.0, floatround_ceil);

    return level;
}

stock IsPlayerStealingVehicle(playerid)
{
    if (pVehicleTheft[playerid] == -1)
        return 0;

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
CMD:kradja(playerid, const params[])
{
    if(PI[playerid][p_org_id] == -1)
        return ErrorMsg(playerid, "Niste clan ilegalne organizacije.");

    if (FACTIONS[PI[playerid][p_org_id]][f_vrsta] == FACTION_LAW)
        return ErrorMsg(playerid, "Vi ste policajac, ne mozete obijati vozila.");
    
    if (pVehicleTheft[playerid] != -1)
        return ErrorMsg(playerid, "Obijanje vozila je vec u toku.");

    if (PI[playerid][p_reload_vehicle_theft] > gettime())
        return ErrorMsg(playerid, "Nedavno ste vec ukrali neko vozilo. Pokusajte ponovo za %s.", konvertuj_vreme(PI[playerid][p_reload_vehicle_theft] - gettime()));
    
    if (!BP_PlayerHasItem(playerid, ITEM_CROWBAR))
        return ErrorMsg(playerid, "Nemate pajser da biste zapoceli kradju.");

    //new fID = GetFactionIDbyName("West End Gang");
	//if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (GetPlayerFactionID(playerid) == 0) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici ilegalnih organizacija!");//West End Gang-a
	

    new bool:found = false;
    foreach (new i : iOwnedVehicles) 
    {
        new Float:vPos[3], vehicleid = OwnedVehicle[i][V_ID];
        GetVehiclePos(vehicleid, vPos[0], vPos[1], vPos[2]);

        if (IsPlayerInRangeOfPoint(playerid, 5.0, vPos[0], vPos[1], vPos[2]) && GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid)) 
        {
            if (OwnedVehicle[i][V_SELLING_PRICE] != 0) 
            {
                // Vozilo se prodaje na auto pijaci
                ErrorMsg(playerid, "Ne mozete ukrasti vozilo koje stoji na auto pijaci.");                 
                return 1;
            }
            
            if (OwnedVehicle[i][V_OWNER_ID] == PI[playerid][p_id]) 
            {
                ErrorMsg(playerid, "Ne mozete da ukradete sopstveno vozilo.");
                return 1;
            }

            new bool:failed = false;
            foreach (new p : Player)
            {
                if (GetPlayerVehicleID(p) == vehicleid)
                {
                    failed = true;
                    break;
                }
            }
            if (failed)
            {
                ErrorMsg(playerid, "Ne mozete da ukradete vozilo u kome se neko vec nalazi.");
                return 1;
            }

            found = true;
            VehicleTheft_Start(playerid, i);
            break;
        }
    }

    if (!found)
    {
        ErrorMsg(playerid, "Ne nalazite se blizu vozila koje mozete da ukradete.");
    }
    return 1;
}