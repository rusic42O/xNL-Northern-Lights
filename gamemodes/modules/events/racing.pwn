#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_RACES 55
#define MAX_RACE_CPS 150




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_RACE_INFO
{
	RACE_NAME[42],
	RACE_FASTEST[MAX_PLAYER_NAME],
	RACE_FASTEST_TIME,
	RACE_HAS_LAPS,
    RACE_IS_STUNT,
    RACE_VEHICLE_MODEL,
    RACE_ACTIVE,
    Float:RACE_VEH_X[2],
    Float:RACE_VEH_Y[2],
    Float:RACE_VEH_Z,
    Float:RACE_VEH_A,
}

enum E_RACE_CP_INFO
{
    Float:RCP_POS[3],
    Float:RCP_DISTANCE_FROM_FINISH
}

enum E_ACTIVE_RACE_INFO
{
    RACE_ID,
    E_RACE_STAGES:RACE_STAGE,
    RACE_ELAPSED,
    RACE_NEXT_VEH,
    RACE_VEH_MODEL,
    RACE_LAST_CP,
    RACE_FIRST[MAX_PLAYER_NAME],
    RACE_SECOND[MAX_PLAYER_NAME],
    RACE_THIRD[MAX_PLAYER_NAME],
    RACE_FIRST_PRIZE,
    RACE_SECOND_PRIZE,
    RACE_THIRD_PRIZE,
    RACE_BREAKPOINT[7],
    RACE_TMR_INFO,
    RACE_TMR_STOP,
    RACE_TMR_SIGNUPS,
    RACE_TMR_COUNTDOWN,
}

enum E_RACERS_POSITIONS
{
    PLAYER_ID,
    Float:PLAYER_DISTANCE,
}

enum E_RACE_STAGES
{
    RACE_STAGE_INACTIVE = 0,
    RACE_STAGE_SIGNUPS = 1,
    RACE_STAGE_STARTING = 2,
    RACE_STAGE_ACTIVE = 3,
    RACE_STAGE_ENDING = 4,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static RaceInfo[MAX_RACES][E_RACE_INFO];
static RacingCP[MAX_RACE_CPS][E_RACE_CP_INFO]; // Checkpointi za aktivnu trku
static ActiveRace[E_ACTIVE_RACE_INFO];

static
    Race_Start_ID,

    Race_PlayerVehID[MAX_PLAYERS],
    Race_PlayerProgress[MAX_PLAYERS char],

    Iterator:iRacers<MAX_PLAYERS>
;

// Kreiranje nove trke
static
    Race_New_ID,
    Race_New_HasLaps,
    Race_New_Stunt,
    Race_New_CP,
    Race_New_Model,
    Float:Race_New_VehPos[3][4]
;

static tmrAutoRacing;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    ActiveRace[RACE_STAGE] = RACE_STAGE_INACTIVE;
    Race_New_ID = 0;
    tmrAutoRacing = 0;

	mysql_tquery(SQL, "SELECT * FROM races", "MySQL_LoadRaces");
    return true;
}

hook OnPlayerConnect(playerid)
{
    Race_PlayerVehID[playerid] = INVALID_VEHICLE_ID;
    Race_PlayerProgress{playerid} = 255;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    Race_ResetForPlayer(playerid, .respawn = false, .iterRemove = true);
    return 1;
}

hook OnPlayerDeath(playerid)
{
    Race_ResetForPlayer(playerid, .respawn = false, .iterRemove = true);
    return 1;
}

hook OnPlayerEnterRaceCP(playerid)
{
    if (Iter_Contains(iRacers, playerid) && GetPlayerVehicleID(playerid) == Race_PlayerVehID[playerid] && Race_PlayerProgress{playerid} < 255)
    {
        new rcp = Race_PlayerProgress{playerid},
            race = ActiveRace[RACE_ID]
        ;

        if (IsPlayerInRangeOfPoint(playerid, 10.0, RacingCP[rcp][RCP_POS][0], RacingCP[rcp][RCP_POS][1], RacingCP[rcp][RCP_POS][2]))
        {
            DisablePlayerRaceCheckpoint_H(playerid);

            rcp ++;

            if (rcp <= ActiveRace[RACE_LAST_CP])
            {

                // Poruka za prolaz
                for (new i = 0; i < 7; i++)
                {
                    if (Race_PlayerProgress{playerid} == ActiveRace[RACE_BREAKPOINT][i])
                    {
                        new sMsg[105];
                        format(sMsg, sizeof sMsg, "%s | "#LIGHT_BLUE_9"Prolaz [%i]: "#LIGHT_BLUE_12"%s "#LIGHT_BLUE_9"| %s", RaceInfo[race][RACE_NAME], i+1, ime_rp[playerid], konvertuj_vreme(ActiveRace[RACE_ELAPSED]));

                        foreach (new racer : iRacers)
                        {
                            SendClientMessage(racer, COLOR_LIGHT_BLUE_12, sMsg);
                        }
                        break;
                    }
                }

                new nextcp = rcp + 1,
                    type = 0
                ;
                if (rcp == ActiveRace[RACE_LAST_CP])
                {
                    nextcp = rcp;
                    type = 1;
                }

                Race_PlayerProgress{playerid} ++;
                SetPlayerRaceCheckpoint_H(playerid, type, RacingCP[rcp][RCP_POS][0], RacingCP[rcp][RCP_POS][1], RacingCP[rcp][RCP_POS][2], RacingCP[nextcp][RCP_POS][0], RacingCP[nextcp][RCP_POS][1], RacingCP[nextcp][RCP_POS][2], 10.0);
            }
            else
            {
                // Poslednji CP (cilj/novi krug)

                new sMsg[128];
                format(sMsg, sizeof sMsg, "%s | "#RED_13"Finish: %s | %s", RaceInfo[race][RACE_NAME], ime_rp[playerid], konvertuj_vreme(ActiveRace[RACE_ELAPSED]));

                SetTimerEx("Race_StopForPlayer", 7*1000, false, "ii", playerid, cinc[playerid]);

                if (!strcmp(ActiveRace[RACE_FIRST], "Niko"))
                {
                    new prize = ActiveRace[RACE_FIRST_PRIZE];
                    format(ActiveRace[RACE_FIRST], MAX_PLAYER_NAME, "%s", ime_rp[playerid]);
                    GameTextForPlayer(playerid, "~N~~N~~N~~N~~g~]]]]]]]]]~n~~w~Prvo mesto!~n~~r~]]]]]]]]]", 5000, 3);
                    

                    ActiveRace[RACE_TMR_STOP] = SetTimer("Race_Stop", 45*1000, false);
                    ActiveRace[RACE_STAGE] = RACE_STAGE_ENDING;


                    // Provera za rekord
                    if (ActiveRace[RACE_ELAPSED] < RaceInfo[ ActiveRace[RACE_ID] ][RACE_FASTEST_TIME])
                    {
                        format(sMsg, sizeof sMsg, "%s "#GREEN_10"  ** NOVI REKORD **", sMsg);
                        SendClientMessageF(playerid, COLOR_GREEN_13, "REKORD | "#GREEN_10"Posigao si novi rekord na ovoj trci! Nagradjen si sa dodatnih "#GREEN_13"$50.000!");
                        prize += 50000;

                        RaceInfo[ ActiveRace[RACE_ID] ][RACE_FASTEST_TIME] = ActiveRace[RACE_ELAPSED];
                        format(RaceInfo[ ActiveRace[RACE_ID] ][RACE_FASTEST], MAX_PLAYER_NAME, "%s", ime_obicno[playerid]);

                        new sQuery[94];
                        format(sQuery, sizeof sQuery, "UPDATE races SET fastest = '%s', fastest_time = %i WHERE id = %i", RaceInfo[ ActiveRace[RACE_ID] ][RACE_FASTEST], RaceInfo[ ActiveRace[RACE_ID] ][RACE_FASTEST_TIME], ActiveRace[RACE_ID]);
                        mysql_tquery(SQL, sQuery);
                    }

                    PlayerMoneyAdd(playerid, prize);
                }

                else if (!strcmp(ActiveRace[RACE_SECOND], "Niko"))
                {
                    format(ActiveRace[RACE_SECOND], MAX_PLAYER_NAME, "%s", ime_rp[playerid]);
                    GameTextForPlayer(playerid, "~N~~N~~N~~N~~g~]]]]]]]]]~n~~w~Drugo mesto!~n~~r~]]]]]]]]]", 5000, 3);
                    
                    PlayerMoneyAdd(playerid, ActiveRace[RACE_SECOND_PRIZE]);
                }

                else if (!strcmp(ActiveRace[RACE_THIRD], "Niko"))
                {
                    format(ActiveRace[RACE_THIRD], MAX_PLAYER_NAME, "%s", ime_rp[playerid]);
                    GameTextForPlayer(playerid, "~N~~N~~N~~N~~g~]]]]]]]]]~n~~w~Trece mesto!~n~~r~]]]]]]]]]", 5000, 3);
                    
                    PlayerMoneyAdd(playerid, ActiveRace[RACE_THIRD_PRIZE]);
                }

                foreach (new i : iRacers)
                {
                    SendClientMessage(i, COLOR_LIGHT_BLUE_12, sMsg);
                }
            }
        }
    }
    return 1;
}

forward Race_StopForPlayer(playerid, ccinc);
public Race_StopForPlayer(playerid, ccinc)
{
    if (checkcinc(playerid, ccinc) && ActiveRace[RACE_STAGE] >= RACE_STAGE_ENDING)
    {
        if (Iter_Contains(iRacers, playerid))
        {
            Race_ResetForPlayer(playerid, .respawn = true, .iterRemove = true);
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (ActiveRace[RACE_STAGE] >= RACE_STAGE_ACTIVE && IsPlayerInRace(playerid) && IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);

        if (newkeys & KEY_SUBMISSION) // 2 = popravka vozila
        {
            RepairVehicle(vehicleid);
            SetVehicleHealth(vehicleid, 999.0);

            TextDrawHideForPlayer(playerid, tdRacing[3]);
        }

        if (newkeys & KEY_YES) // Y = flip
        {
            new Float:z;
            GetVehicleZAngle(vehicleid, z);
            SetVehicleZAngle(vehicleid, z);

            TextDrawHideForPlayer(playerid, tdRacing[3]);
        }

        if (newkeys & KEY_FIRE) // Levi klik = nitro
        {
            new model = GetVehicleModel(vehicleid);
            if (VehicleSupportsNitro(model))
            {
                if (GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO))
                {
                    RemoveVehicleComponent(vehicleid, 1010);
                }
                AddVehicleComponent(vehicleid, 1010);

                TextDrawHideForPlayer(playerid, tdRacing[3]);
            }
        }
    }
    return 1;
}


// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
SetupAutoRacing(bool:active)
{
    KillTimer(tmrAutoRacing);

    if (active)
    {
        new h, m;
        gettime(h, m);
        if (h < 10)
        {
            // Nije vreme da se organizuje trka -> zakazati za 10:00
            // Ako se menja vreme pocetka, onda broj "10" izmeniti u uslovu i u intervalu timer-a (takodje unutar funkcije!)
            tmrAutoRacing = SetTimer("AutoRaceOrganize", ((10-h-1)*60 + (60-m)) * 60 * 1000, false);
        }
        else
        {
            // Vreme kada su trke aktivne
            tmrAutoRacing = SetTimer("AutoRaceOrganize", GetAutoRacingInterval() * 60 * 1000, false);
        }
    }
}

forward AutoRaceOrganize();
public AutoRaceOrganize()
{
    new h, m;
    gettime(h, m);

    if (h < 10)
    {
        // Prosla je ponoc. Iskljuciti trke i postaviti timer za 10:00
        tmrAutoRacing = SetTimer("AutoRaceOrganize", ((10-h-1)*60 + (60-m)) * 60 * 1000, false);
    }
    else
    {
        // Regularno radno vreme, organizuje se nova trka
        tmrAutoRacing = SetTimer("AutoRaceOrganize", GetAutoRacingInterval() * 60 * 1000, false);

        if (ActiveRace[RACE_STAGE] == RACE_STAGE_INACTIVE)
        {
            new race = Race_GetRandom();
            if (race != -1)
            {
                Race_StartSignup(race, RaceInfo[race][RACE_VEHICLE_MODEL]);
            }
        }
    }
}

Race_GetRandom()
{
    new race = -1, stopper = 0;
    while__loop (!(Race_IsValid(race) && RaceInfo[race][RACE_ACTIVE]))
    {
        race = random(sizeof RaceInfo);

        stopper ++;
        if (stopper > 30) 
        {
            race = -1;
            break;
        }
    }

    return race;
}

ShowRacingStartDialog(playerid)
{
    SPD(playerid, "race", DIALOG_STYLE_LIST, "Trke", "Pokreni novu trku\nZaustavi trku\nPrijavi se na trku", "Odaberi", "Izadji");
}

Race_ShowConfigDialog(playerid)
{
    new sDialog[sizeof RaceInfo * 43];
    sDialog[0] = EOS;

    for__loop (new race = 0; race < sizeof RaceInfo; race++)
    {
        if (!Race_IsValid(race)) continue;

        format(sDialog, sizeof sDialog, "%s%i\t%s\t%s\n", sDialog, race, RaceInfo[race][RACE_NAME], (RaceInfo[race][RACE_ACTIVE]? ("{00FF00}ON") : ("{FF0000}OFF")));
    }

    SPD(playerid, "race_auto_config", DIALOG_STYLE_TABLIST, "Trke config", sDialog, "Promeni", "Nazad");
}

Race_IsValid(race)
{
    if (race == -1 || RaceInfo[race][RACE_FASTEST_TIME] == -1)
    {
        return false;
    }
    return true;
}

Racing_ResetStartingProcess()
{
    foreach (new i : iRacers)
    {
        Race_ResetForPlayer(i, .respawn = false, .iterRemove = false);
    }

    Iter_Clear(iRacers);
    ActiveRace[RACE_STAGE] = RACE_STAGE_INACTIVE;
}

Float:Race_GetDistanceFromFinish(playerid)
{
    // Formula: Udaljenost do narednog CP-a + udaljenost tog CP-a od cilja

    new Float:x, Float:y, Float:z,
        nextCP = Race_PlayerProgress{playerid}
    ;

    if(nextCP == 255)
    {
        if(Iter_Contains(iRacers, playerid))
            Iter_Remove(iRacers, playerid);

        return 0.0;
    }

    GetPlayerPos(playerid, x, y, z);

    return GetDistanceBetweenPoints(x, y, z, RacingCP[nextCP][RCP_POS][0], RacingCP[nextCP][RCP_POS][1], RacingCP[nextCP][RCP_POS][2]) + RacingCP[nextCP][RCP_DISTANCE_FROM_FINISH];
}

Race_StartSignup(race, modelid)
{
    ActiveRace[RACE_ID] = race;
    ActiveRace[RACE_VEH_MODEL] = modelid;

    Iter_Clear(iRacers);
    for__loop (new i = 1; i < 7; i++) ActiveRace[RACE_BREAKPOINT][i] = 9999;

    format(ActiveRace[RACE_FIRST], MAX_PLAYER_NAME, "Niko");
    format(ActiveRace[RACE_SECOND], MAX_PLAYER_NAME, "Niko");
    format(ActiveRace[RACE_THIRD], MAX_PLAYER_NAME, "Niko");

    ActiveRace[RACE_FIRST_PRIZE] = 30000;
    ActiveRace[RACE_SECOND_PRIZE] = 20000;
    ActiveRace[RACE_THIRD_PRIZE] = 10000;

    ActiveRace[RACE_STAGE] = RACE_STAGE_SIGNUPS;
    ActiveRace[RACE_TMR_SIGNUPS] = SetTimer("Race_StopSignup", 20*1000, false);

    // Ucitavanje checkpointa za trku
    new sQuery[58];
    format(sQuery, sizeof sQuery, "SELECT pos FROM races_cp WHERE race = %i ORDER BY cp ASC", ActiveRace[RACE_ID]);
    mysql_tquery(SQL, sQuery, "MySQL_LoadRaceCheckpoints");

    new sMsg[128];
    format(sMsg, sizeof sMsg, "Organizuje se trka: {FFFFFF}%s", RaceInfo[ActiveRace[RACE_ID]][RACE_NAME]);
    SendClientMessageToAll(NARANDZASTA, sMsg);
    SendClientMessageToAll(NARANDZASTA, "Da se prijavite upisite: {FFFFFF}/trka {FF9900}| Imate 20 sekundi da se prijavite na event!");
}

forward Race_StopSignup();
public Race_StopSignup()
{
    // Brojanje prijavljenih ucesnika; otkazivanje trke ako nema 5 prijavljenih
    // if (Iter_Count(iRacers) < 5)
    // {
    //     foreach (new playerid : iRacers)
    //     {
    //         SendClientMessageF(playerid, COLOR_LIGHT_BLUE_12, "%s | "RED_9"Trka je otkazana jer nema dovoljno prijavljenih igraca.", RaceInfo[ ActiveRace[RACE_ID] ][RACE_NAME]);
    //     }

    //     Racing_ResetStartingProcess();
    //     return 1;
    // }


    new race = ActiveRace[RACE_ID];
    ActiveRace[RACE_NEXT_VEH] = 0;
    ActiveRace[RACE_ELAPSED] = 0;
    ActiveRace[RACE_STAGE] = RACE_STAGE_STARTING;


    // Textdraw update
    new sParticipants[4];
    format(sParticipants, sizeof sParticipants, "/%i", Iter_Count(iRacers));
    TextDrawSetString(tdRacing[0], sParticipants);
    TextDrawSetString(tdRacing[1], "00:00");

    
    // Postavljanje svih igraca na startne pozicije
    foreach (new playerid : iRacers)
    {
        // Belezimo oruzje (mora prvo!)
        SavePlayerWeaponDataAndPos(playerid);
        ResetPlayerWeapons(playerid);

        // if (!RaceInfo[ ActiveRace[RACE_ID] ][RACE_IS_STUNT])
        // {
        //     DisableRemoteVehicleCollisions(playerid, 1);
        // }

        DisableRemoteVehicleCollisions(playerid, 1);

        if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
            SetVehicleToRespawn(GetPlayerVehicleID(playerid));

        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 1000);
        TogglePlayerControllable_H(playerid, false);
        
        new idx = ActiveRace[RACE_NEXT_VEH] % 2;
        Race_PlayerVehID[playerid] = CreateVehicle(ActiveRace[RACE_VEH_MODEL], RaceInfo[race][RACE_VEH_X][idx], RaceInfo[race][RACE_VEH_Y][idx], RaceInfo[race][RACE_VEH_Z], RaceInfo[race][RACE_VEH_A], -1, -1, 1000);
        SetVehicleParamsEx(Race_PlayerVehID[playerid], 1, 1, 0, 0, 0, 0, 0);
        LinkVehicleToInterior(Race_PlayerVehID[playerid], 0);
        SetVehicleVirtualWorld(Race_PlayerVehID[playerid], 1000);
        PutPlayerInVehicle_H(playerid, Race_PlayerVehID[playerid], 0);

        if (!(RaceInfo[race][RACE_VEH_Y][1] == 0.0 && RaceInfo[race][RACE_VEH_X][1] == 0.0))
        {
            // Ako su koordinate drugog vozila 0.0, 0.0 - onda se sva vozila spawnuju na istu lokaciju
            RaceInfo[race][RACE_VEH_X][idx] = RaceInfo[race][RACE_VEH_X][idx] + 6*floatcos(90-RaceInfo[race][RACE_VEH_A], degrees); 
            RaceInfo[race][RACE_VEH_Y][idx] = RaceInfo[race][RACE_VEH_Y][idx] - 6*floatsin(90-RaceInfo[race][RACE_VEH_A], degrees); 
            ActiveRace[RACE_NEXT_VEH] ++;
        }

        SendClientMessageF(playerid, NARANDZASTA, "%s | {FFFF00}Trka pocinje za nekoliko sekundi.", RaceInfo[race][RACE_NAME]);

        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(playerid, tdEventCountdown[j]);
        ptdRacing_Create(playerid);
        TextDrawShowForPlayer(playerid, tdRacing[0]);
        TextDrawShowForPlayer(playerid, tdRacing[1]);
        TextDrawShowForPlayer(playerid, tdRacing[2]);
        TextDrawShowForPlayer(playerid, tdRacing[3]);

        Race_PlayerProgress{playerid} = 0;
    }


    // Odbrojavanje pocinje za 5 sekundi
    ActiveRace[RACE_TMR_COUNTDOWN] = SetTimerEx("Race_Countdown", 5000, false, "i", 1);

    return 1;
}

forward Race_Countdown(stage);
public Race_Countdown(stage)
{
    switch (stage)
    {
        case 1:
        {
            foreach(new i : iRacers)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 2:
        {
            foreach(new i : iRacers)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 3:
        {
            foreach(new i : iRacers)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[9]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 4:
        {
            TextDrawBoxColor(tdEventCountdown[7], 13369599);
            TextDrawBoxColor(tdEventCountdown[8], 13369599);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);

            foreach(new i : iRacers)
            {
                TextDrawHideForPlayer(i, tdEventCountdown[7]);
                TextDrawHideForPlayer(i, tdEventCountdown[8]);
                TextDrawHideForPlayer(i, tdEventCountdown[9]);
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                TextDrawShowForPlayer(i, tdEventCountdown[9]);
                PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);

                SetPlayerRaceCheckpoint_H(i, 0, RacingCP[0][RCP_POS][0], RacingCP[0][RCP_POS][1], RacingCP[0][RCP_POS][2], RacingCP[1][RCP_POS][0], RacingCP[1][RCP_POS][1], RacingCP[1][RCP_POS][2], 10.0);
                TogglePlayerControllable_H(i, true);
            }

            ActiveRace[RACE_STAGE] = RACE_STAGE_ACTIVE;
            ActiveRace[RACE_TMR_INFO] = SetTimer("Race_UpdateInfo", 1000, true);
        }
        case 5:
        {
            for__loop (new t = 0; t < 10; t++) TextDrawHideForAll(tdEventCountdown[t]);

            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (stage != 5) ActiveRace[RACE_TMR_COUNTDOWN] = SetTimerEx("Race_Countdown", 1000, false, "i", stage+1);
    
    return 1;
}

forward Race_UpdateInfo();
public Race_UpdateInfo()
{
    new distArray[MAX_PLAYERS][E_RACERS_POSITIONS],
        idx = 0
    ;

    // Sortiranje niza sa udaljenostima
    for__loop (new i = 0; i < sizeof distArray; i++)
    {
        distArray[i][PLAYER_ID] = -1;
        distArray[i][PLAYER_DISTANCE] = 99999.0;
    }

    foreach (new playerid : iRacers)
    {
        distArray[idx][PLAYER_ID] = playerid;
        distArray[idx][PLAYER_DISTANCE] = Race_GetDistanceFromFinish(playerid);

        idx ++; 
    }

    SortDeepArray(distArray, E_RACERS_POSITIONS:PLAYER_DISTANCE);


    for__loop (new i = 0; i < sizeof distArray; i++)
    {
        if (distArray[i][PLAYER_ID] == -1) break;

        // Prikazivanje pozicije svim igracima
        ptdRacing_UpdatePosition(distArray[i][PLAYER_ID], i+1);

        // Ako je stunt race, proveravamo da li su ispali
        if (RaceInfo[ ActiveRace[RACE_ID] ][RACE_IS_STUNT])
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(distArray[i][PLAYER_ID], x, y, z);
            if (z < 1000.0)
            {
                callcmd::rrace(distArray[i][PLAYER_ID], "");
            }
        }
    }

    // Azuriranje vremena
    ActiveRace[RACE_ELAPSED] += 1;
    TextDrawSetString(tdRacing[1], konvertuj_vreme(ActiveRace[RACE_ELAPSED]));

    // Azuriranje broja ucesnika
    new sParticipants[4];
    format(sParticipants, sizeof sParticipants, "/%i", Iter_Count(iRacers));
    TextDrawSetString(tdRacing[0], sParticipants);

    return 1;
}

forward Race_Stop();
public Race_Stop()
{
    new sMsg[145];
    format(sMsg, sizeof sMsg, "%s | "#LIGHT_BLUE_9"[1] "LIGHT_BLUE_12"%s,  "LIGHT_BLUE_9"[2] "LIGHT_BLUE_12"%s,  "LIGHT_BLUE_9"[3] "LIGHT_BLUE_12"%s", RaceInfo[ ActiveRace[RACE_ID] ][RACE_NAME], ActiveRace[RACE_FIRST], ActiveRace[RACE_SECOND], ActiveRace[RACE_THIRD]);
    SendClientMessageToAll(COLOR_LIGHT_BLUE_12, sMsg);

    foreach (new i : iRacers) 
    {
        GameTextForPlayer(i, "~N~~N~~Y~Trka je zavrsena", 5000, 4);
        Race_ResetForPlayer(i, .respawn = true, .iterRemove = false);
    }
    Iter_Clear(iRacers);
    ActiveRace[RACE_STAGE] = RACE_STAGE_INACTIVE;
    KillTimer(ActiveRace[RACE_TMR_INFO]);
    KillTimer(ActiveRace[RACE_TMR_STOP]);
    KillTimer(ActiveRace[RACE_TMR_SIGNUPS]);
    KillTimer(ActiveRace[RACE_TMR_COUNTDOWN]);

    return 1;
}

Race_ResetForPlayer(playerid, bool:respawn, bool:iterRemove)
{
    if (IsValidVehicle(Race_PlayerVehID[playerid]))
    {
        DestroyVehicle(Race_PlayerVehID[playerid]);
    }
    Race_PlayerVehID[playerid] = INVALID_VEHICLE_ID;
    Race_PlayerProgress{playerid} = 255;


    if (Iter_Contains(iRacers, playerid))
    {
        if (iterRemove)
        {
            Iter_Remove(iRacers, playerid);
        }

        ptdRacing_Destroy(playerid);
        TextDrawHideForPlayer(playerid, tdRacing[0]);
        TextDrawHideForPlayer(playerid, tdRacing[1]);
        TextDrawHideForPlayer(playerid, tdRacing[2]);
        TextDrawHideForPlayer(playerid, tdRacing[3]);
        for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(playerid, tdEventCountdown[t]);


        DisableRemoteVehicleCollisions(playerid, 0);

        if (respawn)
        {
            PlayerRestorePosition(playerid);
            SpawnPlayer(playerid);
        }
    }
}

Race_Signup(playerid)
{
    if (ActiveRace[RACE_STAGE] != RACE_STAGE_SIGNUPS)
        return ErrorMsg(playerid, "Trka nije aktivna ili su zavrsene prijave.");

    if (Iter_Contains(iRacers, playerid))
        return ErrorMsg(playerid, "Vec ste prijavljeni na trku, sacekajte pocetak.");

    if (Iter_Count(iRacers) == 50)
        return ErrorMsg(playerid, "Sva mesta za ovu trku su vec popunjena.");

    Iter_Add(iRacers, playerid);
    SendClientMessageF(playerid, COLOR_LIGHT_BLUE_12, "%s | "#LIGHT_BLUE_9"Prijavili ste se na trku. Bicete teleportovani ubrzo.", RaceInfo[ ActiveRace[RACE_ID] ][RACE_NAME]);
    return 1;
}

IsPlayerInRace(playerid)
{
    if (ActiveRace[RACE_STAGE] > RACE_STAGE_INACTIVE && Iter_Contains(iRacers, playerid))
    {
        return true;
    }
    return false;
}

IsRaceActive()
{
    if (ActiveRace[RACE_STAGE] == RACE_STAGE_INACTIVE)
    {
        return false;
    }
    return true;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_LoadRaces();
public MySQL_LoadRaces()
{
	cache_get_row_count(rows);
	if (!rows) return 1;

	// Resetovanje
	for__loop (new race = 0; race < sizeof RaceInfo; race++)
	{
		RaceInfo[race][RACE_FASTEST_TIME] = -1; // Indikator postojanja
	}

    new sVehiclePos[111],
        sXY_1[42+1],
        sXY_2[42+1],
        race
    ;
	for__loop (new i = 0; i < rows; i++)
	{
        cache_get_value_name_int(i, "id", race);
		cache_get_value_name(i, "name", RaceInfo[race][RACE_NAME], 42);
		cache_get_value_name(i, "fastest", RaceInfo[race][RACE_FASTEST], MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "fastest_time", RaceInfo[race][RACE_FASTEST_TIME]);
		cache_get_value_name_int(i, "has_laps", RaceInfo[race][RACE_HAS_LAPS]);
        cache_get_value_name_int(i, "stunt", RaceInfo[race][RACE_IS_STUNT]);
        cache_get_value_name_int(i, "model", RaceInfo[race][RACE_VEHICLE_MODEL]);
        cache_get_value_name_int(i, "active", RaceInfo[race][RACE_ACTIVE]);
        cache_get_value_name(i, "veh_pos", sVehiclePos, sizeof sVehiclePos);
        sscanf(sVehiclePos, "p<|>ffs[100]", RaceInfo[race][RACE_VEH_Z], RaceInfo[race][RACE_VEH_A], sVehiclePos);
        sscanf(sVehiclePos, "p<|>s[42]s[42]", sXY_1, sXY_2);
        sscanf(sXY_1, "p<,>ff", RaceInfo[race][RACE_VEH_X][0], RaceInfo[race][RACE_VEH_Y][0]);
        sscanf(sXY_2, "p<,>ff", RaceInfo[race][RACE_VEH_X][1], RaceInfo[race][RACE_VEH_Y][1]);
	}

	return 1;
}

forward MySQL_LoadRaceCheckpoints();
public MySQL_LoadRaceCheckpoints()
{
    cache_get_row_count(rows);
    if (!rows)
    {
        Racing_ResetStartingProcess();
        return StaffMsg(CRVENA, "[!!] TRKA | Nisu pronadjeni checkpointi za trku.");
    }

    for__loop(new i = 0; i < MAX_RACE_CPS; i++)
    {
        RacingCP[i][RCP_POS][0] = RacingCP[i][RCP_POS][1] = RacingCP[i][RCP_POS][2] = 0.0;
        RacingCP[i][RCP_DISTANCE_FROM_FINISH] = 0.0;
    }


    new pos[33], rcp;
    for__loop (rcp = 0; rcp < rows; rcp++)
    {
        cache_get_value_name(rcp, "pos", pos, sizeof pos);
        sscanf(pos, "p<,>fff", RacingCP[rcp][RCP_POS][0], RacingCP[rcp][RCP_POS][1], RacingCP[rcp][RCP_POS][2]);
    }
    new last = ActiveRace[RACE_LAST_CP] = rcp - 1;


    // Racunamo udaljenost od cilja za svaki CP
    RacingCP[last][RCP_DISTANCE_FROM_FINISH] = 0.0;
    for__loop (rcp = last - 1; rcp >= 0; rcp --)
    {
        RacingCP[rcp][RCP_DISTANCE_FROM_FINISH] = RacingCP[rcp+1][RCP_DISTANCE_FROM_FINISH] + GetDistanceBetweenPoints(RacingCP[rcp][RCP_POS][0], RacingCP[rcp][RCP_POS][1], RacingCP[rcp][RCP_POS][2], RacingCP[rcp+1][RCP_POS][0], RacingCP[rcp+1][RCP_POS][1], RacingCP[rcp+1][RCP_POS][2]);
    }


    // Postavljanje prolaza na osnovu broja checkpointa
    if (last >= 5 && last < 15) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 2;
    }
    else if (last >= 15 && last < 30) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 3;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 3);
    }
    else if (last >= 30 && last < 45) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 4;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 4);
        ActiveRace[RACE_BREAKPOINT][2] = ActiveRace[RACE_BREAKPOINT][1] + (last / 4);
    }
    else if (last >= 45 && last < 60) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 5;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 5);
        ActiveRace[RACE_BREAKPOINT][2] = ActiveRace[RACE_BREAKPOINT][1] + (last / 5);
        ActiveRace[RACE_BREAKPOINT][3] = ActiveRace[RACE_BREAKPOINT][2] + (last / 5);
    }
    else if (last >= 60 && last < 75) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 5;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 6);
        ActiveRace[RACE_BREAKPOINT][2] = ActiveRace[RACE_BREAKPOINT][1] + (last / 6);
        ActiveRace[RACE_BREAKPOINT][3] = ActiveRace[RACE_BREAKPOINT][2] + (last / 6);
        ActiveRace[RACE_BREAKPOINT][4] = ActiveRace[RACE_BREAKPOINT][3] + (last / 6);
    }
    else if (last >= 75 && last < 90) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 5;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 7);
        ActiveRace[RACE_BREAKPOINT][2] = ActiveRace[RACE_BREAKPOINT][1] + (last / 7);
        ActiveRace[RACE_BREAKPOINT][3] = ActiveRace[RACE_BREAKPOINT][2] + (last / 7);
        ActiveRace[RACE_BREAKPOINT][4] = ActiveRace[RACE_BREAKPOINT][3] + (last / 7);
        ActiveRace[RACE_BREAKPOINT][5] = ActiveRace[RACE_BREAKPOINT][4] + (last / 7);
    }
    else if (last >= 90 && last < 100) 
    {
        ActiveRace[RACE_BREAKPOINT][0] = last / 5;
        ActiveRace[RACE_BREAKPOINT][1] = ActiveRace[RACE_BREAKPOINT][0] + (last / 8);
        ActiveRace[RACE_BREAKPOINT][2] = ActiveRace[RACE_BREAKPOINT][1] + (last / 8);
        ActiveRace[RACE_BREAKPOINT][3] = ActiveRace[RACE_BREAKPOINT][2] + (last / 8);
        ActiveRace[RACE_BREAKPOINT][4] = ActiveRace[RACE_BREAKPOINT][3] + (last / 8);
        ActiveRace[RACE_BREAKPOINT][5] = ActiveRace[RACE_BREAKPOINT][4] + (last / 8);
        ActiveRace[RACE_BREAKPOINT][6] = ActiveRace[RACE_BREAKPOINT][5] + (last / 8);
    }

    return 1;
}

forward MySQL_RaceCreate(playerid, ccinc, sRaceName[]);
public MySQL_RaceCreate(playerid, ccinc, sRaceName[])
{
    if (!checkcinc(playerid, ccinc)) return 1;

    Race_New_ID = cache_insert_id();
    SendClientMessageF(playerid, BELA, "Izrada trke {FFFF00}[%s (ID: %i)] {FFFFFF}| Koristite /raceveh za cuvanje pozicije vozila.", sRaceName, Race_New_ID);

    format(RaceInfo[Race_New_ID][RACE_NAME], 42, "%s", sRaceName);
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:race(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0) // Pokreni novu trku
    {
        if (ActiveRace[RACE_STAGE] != RACE_STAGE_INACTIVE)
            return ErrorMsg(playerid, "Trka je vec pokrenuta.");

        if (IsAutoRacingEnabled())
            return ErrorMsg(playerid, "Ne mozete pokrenuti trku jer je ukljuceno automatsko organizovanje.");

        new sDialog[sizeof RaceInfo * 32];
        sDialog[0] = EOS;

        for__loop (new race = 0; race < sizeof RaceInfo; race++)
        {
            if (!Race_IsValid(race)) continue;

            format(sDialog, sizeof sDialog, "%s%i\t%s\n", sDialog, race, RaceInfo[race][RACE_NAME]);
        }

        SPD(playerid, "race_start_1", DIALOG_STYLE_TABLIST, "Pokreni novu trku", sDialog, "Dalje -", "- Nazad");
    }

    else if (listitem == 1) // Zaustavi trku
    {
        Race_Stop();
        // StaffMsg()
    }

    else if (listitem == 2) // Prijavi se na trku
    {
        Race_Signup(playerid);
    }
    return 1;
}

Dialog:race_start_1(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        Racing_ResetStartingProcess();
        ShowRacingStartDialog(playerid);
        return 1;
    }

    Race_Start_ID = strval(inputtext);
    //Race_Start_PlayerID = playerid;

    ActiveRace[RACE_ID] = Race_Start_ID;
    SPD(playerid, "race_start_2", DIALOG_STYLE_INPUT, "Pokreni novu trku", "{FFFFFF}Unesite model vozila za ovu trku", "Start", "- Nazad");
    return 1;
}

Dialog:race_start_2(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        Racing_ResetStartingProcess();
        ShowRacingStartDialog(playerid);
        return 1;
    }

    new 
        model_str[18],
        modelid = -1
    ;

    if (sscanf(inputtext, "s[18]", model_str)) 
    {
        ErrorMsg(playerid, "Nevazeci model vozila.");
        return DialogReopen(playerid);
    }

    modelid = GetVehicleModelID(model_str);
    if (modelid == -1) modelid = strval(model_str);
    if (modelid < 400 || modelid > 611) 
    {
        ErrorMsg(playerid, "Nevazeci model vozila.");
        return DialogReopen(playerid);
    }

    Race_StartSignup(Race_Start_ID, modelid);
    return 1;
}

Dialog:race_auto_config(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return callcmd::server(playerid, "");

    new race = strval(inputtext);
    RaceInfo[race][RACE_ACTIVE] = !RaceInfo[race][RACE_ACTIVE];

    new sQuery[44];
    format(sQuery, sizeof sQuery, "UPDATE races SET active = %i WHERE id = %i", RaceInfo[race][RACE_ACTIVE], race);
    mysql_tquery(SQL, sQuery);

    Race_ShowConfigDialog(playerid);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:trka(playerid, const params[])
{
    if (IsHelper(playerid, 1))
    {
        ShowRacingStartDialog(playerid);
    }
    else
    {
        if (IsPlayerInRace(playerid))
        {
            Race_ResetForPlayer(playerid, .respawn = true, .iterRemove = true);
        }
        else
        {
            Race_Signup(playerid);
        }
    }
    return 1;
}

CMD:deaktiviraj(playerid, const params[])
{
    if (!IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Niste na trci.");

    Race_ResetForPlayer(playerid, .respawn = true, .iterRemove = true);
    return 1;
}

CMD:rrace(playerid, const params[])
{
    if (!IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Niste na trci.");

    if (ActiveRace[RACE_STAGE] < RACE_STAGE_ACTIVE)
        return ErrorMsg(playerid, "Trka jos uvek nije pocela.");

    if (Race_PlayerProgress{playerid} > ActiveRace[RACE_LAST_CP])
        return ErrorMsg(playerid, "Zavrsili ste trku.");

    new rcp = Race_PlayerProgress{playerid} - 1;
    if (rcp < 0) rcp = 0;
    if (rcp >= ActiveRace[RACE_LAST_CP]) rcp = ActiveRace[RACE_LAST_CP]-1;

    TeleportPlayer(playerid, RacingCP[rcp][RCP_POS][0], RacingCP[rcp][RCP_POS][1], RacingCP[rcp][RCP_POS][2]+4.0);

    new vehicleid = GetPlayerVehicleID(playerid);
    if (IsValidVehicle(vehicleid) && IsVehicleFlipped(vehicleid)) 
    {
        new Float:z;
        GetVehicleZAngle(vehicleid, z);
        SetVehicleZAngle(vehicleid, z);
    }
    return 1;
}

flags:racehelp(FLAG_ADMIN_6)
CMD:racehelp(playerid, const params[])
{
    Koristite(playerid, "newrace [Krugovi (0 = bez krugova, 1 = sa krugovima)] [Stunt (0 = ne, 1 = da)] - {FFFFFF}Pokretanje izrade trke");
    Koristite(playerid, "racename [Naziv trke] - {FFFFFF}Postavljanje naziva trke");
    Koristite(playerid, "raceveh [1/2/3] - {FFFFFF}Podesavanje pozicije vozila u prvom redu");
    // Koristite(playerid, "raceveh [save] - {FFFFFF}Cuvanje pozicija vozila (tek kada su sve zavrsene!)")
    Koristite(playerid, "racecp - {FFFFFF}Postavljanje checkpointa na trenutnoj poziciji");
    Koristite(playerid, "racecp [fix] - {FFFFFF}Promena pozicije poslednjeg checkpointa (ako se desila greska)");
    Koristite(playerid, "racedelete - {FFFFFF}Brisanje trke cije je kreiranje zapoceto");
    Koristite(playerid, "racestop - {FFFFFF}Kreiranje je zavrseno");

    return 1;
}

flags:newrace(FLAG_ADMIN_6)
CMD:newrace(playerid, const params[])
{
    if (Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke je aktivno. Koristite /racedelete ili /racestop.");

    new laps, stunt, model;
    if (sscanf(params, "iii", laps, stunt, model) || !(0 <= laps <= 1) || !(0 <= stunt <= 1) || !(400 <= model <= 611))
        return Koristite(playerid, "newrace [Krugovi (0 = bez krugova, 1 = sa krugovima)] [Stunt (0 = ne, 1 = da)] [Model vozila (broj)]");

    Race_New_HasLaps = laps;
    Race_New_Stunt = stunt;
    Race_New_ID = 1000;
    Race_New_CP = 0;
    Race_New_Model = model;
    for (new i = 0; i < sizeof Race_New_VehPos; i++)
    {
        Race_New_VehPos[i][0] = Race_New_VehPos[i][1] = Race_New_VehPos[i][2] = Race_New_VehPos[i][3] = 0.0;
    }

    SendClientMessage(playerid, BELA, "Izrada trke je zapoceta. Koristite /racename da postavite naziv trke.");

    return 1;
}

flags:racename(FLAG_ADMIN_6)
CMD:racename(playerid, const params[])
{
    if (!Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke nije zapoceto. Koristite /newrace.");

    if (isnull(params)) 
        return Koristite(playerid, "racename [Naziv trke]");

    if (strlen(params) < 5 || strlen(params) > 32)
        return ErrorMsg(playerid, "Naziv mora sadrzati izmedju 5 i 32 karaktera (uneli ste %i karaktera).", strlen(params));

    new sQuery[123];
    mysql_format(SQL, sQuery, sizeof sQuery, "INSERT INTO races (name, has_laps, stunt, veh_pos, model) VALUES ('%s', %i, %i, '-', %i)", params, Race_New_HasLaps, Race_New_Stunt, Race_New_Model);
    mysql_tquery(SQL, sQuery, "MySQL_RaceCreate", "iis", playerid, cinc[playerid], params);

    return 1;
}

flags:raceveh(FLAG_ADMIN_6)
CMD:raceveh(playerid, const params[])
{
    if (!Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke nije zapoceto. Koristite /newrace.");

    if (Race_New_ID == 1000)
        return ErrorMsg(playerid, "Niste definisali naziv trke. Koristite /racename.");

    new idx;
    if (sscanf(params, "i", idx) || !(1 <= idx <= 2))
        return Koristite(playerid, "raceveh [1/2] - {FFFFFF}Podesavanje pozicije vozila u prvom redu");

    idx--;

    if (IsPlayerInAnyVehicle(playerid))
    {
        GetVehiclePos(GetPlayerVehicleID(playerid), Race_New_VehPos[idx][0], Race_New_VehPos[idx][1], Race_New_VehPos[idx][2]);
        GetVehicleZAngle(GetPlayerVehicleID(playerid), Race_New_VehPos[idx][3]);
    }
    else
    {
        GetPlayerPos(playerid, Race_New_VehPos[idx][0], Race_New_VehPos[idx][1], Race_New_VehPos[idx][2]);
        GetPlayerFacingAngle(playerid, Race_New_VehPos[idx][3]);
    }

    new sQuery[105];
    format(sQuery, sizeof sQuery, "UPDATE races SET veh_pos = '%.4f|%.2f|%.4f,%.4f|%.4f,%.4f' WHERE id = %i", Race_New_VehPos[idx][2], Race_New_VehPos[idx][3], Race_New_VehPos[0][0], Race_New_VehPos[0][1], Race_New_VehPos[1][0], Race_New_VehPos[1][1], Race_New_ID);
    mysql_tquery(SQL, sQuery);

    SendClientMessageF(playerid, BELA, "Sacauvana je pozicija vozila %i.", idx+1);
    return 1;
}

flags:racecp(FLAG_ADMIN_6)
CMD:racecp(playerid, const params[])
{
    if (!Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke nije zapoceto. Koristite /newrace.");

    if (Race_New_ID == 1000)
        return ErrorMsg(playerid, "Niste definisali naziv trke. Koristite /racename.");

    new Float:x, Float:y, Float:z,
        sQuery[92]
    ;
    GetPlayerPos(playerid, x, y, z);

    if (!isnull(params) && !strcmp(params, "fix", true))
    {
        // Ispravka pozicije za poslednji CP
        format(sQuery, sizeof sQuery, "UDPATE races_cp SET pos = '%.4f,%.4f,%.4f' WHERE race = %i AND cp = %i", x, y, z, Race_New_ID, Race_New_CP-1);
        SendClientMessageF(playerid, -1, "Ispravljena je pozicija za checkpoint %i.", Race_New_CP);
    }
    else
    {
        format(sQuery, sizeof sQuery, "INSERT INTO races_cp (race, cp, pos) VALUES (%i, %i, '%.4f,%.4f,%.4f')", Race_New_ID, Race_New_CP++, x, y, z);
        SendClientMessageF(playerid, -1, "Checkpoint %i je dodat. Da ispravis poziciju koristi /racecp fix.", Race_New_CP);
    }
    mysql_tquery(SQL, sQuery);

    return 1;
}

flags:racedelete(FLAG_ADMIN_6)
CMD:racedelete(playerid, const params[])
{
    if (!Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke nije zapoceto. Koristite /newrace.");

    if (Race_New_ID != 1000)
    {
        new sQuery[38];
        format(sQuery, sizeof sQuery, "DELETE FROM races WHERE id = %i", Race_New_ID);
        mysql_tquery(SQL, sQuery);

        format(sQuery, sizeof sQuery, "DELETE FROM races_cp WHERE race = %i", Race_New_ID);
        mysql_tquery(SQL, sQuery);
    }

    Race_New_ID = 0;

    SendClientMessage(playerid, BELA, "Trka je izbrisana. Koristite /newrace da zapocnete izradu nove trke.");
    return 1;
}

flags:racestop(FLAG_ADMIN_6)
CMD:racestop(playerid, const params[])
{
    if (!Race_New_ID)
        return ErrorMsg(playerid, "Kreiranje trke nije zapoceto. Koristite /newrace.");

    format(RaceInfo[Race_New_ID][RACE_FASTEST], MAX_PLAYER_NAME, "Niko");
    RaceInfo[Race_New_ID][RACE_FASTEST_TIME] = 9999;
    RaceInfo[Race_New_ID][RACE_HAS_LAPS] = Race_New_HasLaps;
    RaceInfo[Race_New_ID][RACE_IS_STUNT] = Race_New_Stunt;
    RaceInfo[Race_New_ID][RACE_VEH_X][0] = Race_New_VehPos[0][0];
    RaceInfo[Race_New_ID][RACE_VEH_Y][0] = Race_New_VehPos[0][1];
    RaceInfo[Race_New_ID][RACE_VEH_X][1] = Race_New_VehPos[1][0];
    RaceInfo[Race_New_ID][RACE_VEH_Y][1] = Race_New_VehPos[1][1];
    RaceInfo[Race_New_ID][RACE_VEH_Z] = Race_New_VehPos[1][2];
    RaceInfo[Race_New_ID][RACE_VEH_A] = Race_New_VehPos[1][3];

    Race_New_ID = 0;
    SendClientMessage(playerid, BELA, "Izrada trke je uspesno zavrsena.");
    return 1;
}