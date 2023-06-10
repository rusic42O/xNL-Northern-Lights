#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
    HORROR_INACTIVE = 0,
    HORROR_SIGNUPS,
    HORROR_WAITING_START,
    HORROR_IN_PROGRESS,
}

enum
{
    MULTIKILL_NONE = 1,
    MULTIKILL_DOUBLE = 2,
    MULTIKILL_TRIPLE = 3,
    MULTIKILL_QUADRIPLE = 4,
    MULTIKILL_PENTA = 5,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    gEventStage,
    gEventDuration,

    bool:pHorrorEvent[MAX_PLAYERS char],
    pEventPlus[MAX_PLAYERS],
    pEventMinus[MAX_PLAYERS],
    pHorrorEventLastKill[MAX_PLAYERS],
    pHorrorEventMultiKill[MAX_PLAYERS],

    bool:gHorrorEventFirstBlood,

    Iterator:iHorrorEvent<MAX_PLAYERS>,

    tmrHorrorEvent,
    tmrHorrorEventFirstBlood,
    tmrHorrorEventDouble,
    tmrHorrorEventTriple,
    tmrHorrorEventQuad,
    tmrHorrorEventPenta

;

static Float:HororSpawnPos[][4] = 
{
    {1799.3317, 3426.0444, 9.9746, 213.4090},
    {1806.8832, 3406.6724, 9.9746, 17.2839},
    {1807.1130, 3401.1606, 9.9746, 197.2839},
    {1803.1624, 3391.9458, 10.1798, 79.3969},
    {1794.9869, 3381.3086, 10.0092, 322.1367},
    {1796.5540, 3367.3213, 10.0092, 357.0854},
    {1797.0308, 3355.6016, 10.0092, 249.6110},
    {1804.0212, 3348.9834, 9.9746, 337.3452},
    {1809.8998, 3355.2007, 9.9746, 218.4458},
    {1813.3472, 3364.2661, 9.9746, 266.3862},
    {1825.2389, 3374.7512, 10.0813, 276.8713},
    {1834.0627, 3389.7898, 10.0813, 271.8579},
    {1849.3367, 3385.5090, 10.0753, 214.8307},
    {1865.7582, 3379.8230, 10.0813, 27.6240},
    {1874.4596, 3376.6746, 10.0813, 91.5445},
    {1884.2074, 3383.3054, 10.0813, 84.9645},
    {1879.8254, 3399.8713, 10.0713, 100.7996},
    {1856.2372, 3400.5234, 10.0683, 267.6395},
    {1856.7031, 3422.4961, 9.9746, 121.1665},
    {1835.1849, 3422.0483, 9.9746, 206.1532},
    {1835.4415, 3405.5078, 9.9746, 89.6879},
    {1824.7001, 3428.4934, 9.9746, 177.1087},
    {1863.2930, 3428.2522, 9.9746, 181.1821},
    {1882.2483, 3426.6494, 9.9746, 88.4346},
    {1890.0010, 3410.7073, 10.0092, 101.9080},
    {1888.7139, 3394.2654, 10.0092, 90.3870},
    {1883.9707, 3370.6819, 9.9746, 173.8795},
    {1890.5013, 3352.7563, 10.0092, 359.4470},
    {1885.4266, 3344.7422, 10.0092, 93.5928},
    {1863.0890, 3347.7930, 10.8107, 0.3870},
    {1848.2156, 3358.0984, 10.9234, 193.3788},
    {1824.5588, 3348.4983, 9.9746, 92.8212},
    {1832.4641, 3335.0432, 9.9746, 268.1937},
    {1840.8750, 3330.5781, 10.7177, 91.5678},
    {1872.1959, 3314.8142, 9.9746, 5.4004},
    {1830.8192, 3313.9922, 9.9746, 356.9637},
    {1817.2806, 3326.6492, 13.0495, 176.7229},
    {1805.1453, 3314.9170, 9.9746, 354.7703},
    {1795.7344, 3323.4924, 9.9746, 264.5294},
    {1801.2267, 3328.9854, 10.0221, 173.0353},
    {1794.8771, 3337.4590, 10.0092, 270.2420},
    {1796.4121, 3347.6118, 10.0092, 0.2420},
    {1838.4677, 3361.2581, 10.9268, 357.1947},
    {1829.0763, 3361.3875, 9.9746, 91.3406},
    {1847.8698, 3392.8494, 10.2087, 180.3068}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    gEventStage = DM_EVENT_INACTIVE;
    tmrHorrorEvent = 0;
    return true;
}

hook OnPlayerConnect(playerid)
{
    pHorrorEvent{playerid} = false;
    pEventPlus[playerid] = pEventMinus[playerid] = 0;
}

hook OnPlayerDisconnect(playerid)
{
    if (Iter_Contains(iHorrorEvent, playerid))
    {
        Iter_Remove(iHorrorEvent, playerid);
        pHorrorEvent{playerid} = false;

        foreach (new i : iHorrorEvent)
        {
            SendClientMessageF(i, ZELENA, "Horor Event | {00FF00}%s {33AA33}je napustio Horor Event.", ime_rp[playerid]);
        }
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (Iter_Contains(iHorrorEvent, playerid))
    {
        pHorrorEvent_SetSpawnInfo(playerid);

        StaffMsg(DEBUG, "[DEBUG] - HororEvent - OnPlayerDeath [%s]", ime_rp[playerid]);

        if (!IsPlayerConnected(killerid)) return 1;
        
        if (Iter_Contains(iHorrorEvent, killerid))
        {
            #define DM_KILL_PRIZE   150
            #define DM_FIRST_BLOOD  1000
            #define DM_DOUBLE_PRIZE 300
            #define DM_TRIPLE_PRIZE 450
            #define DM_QUAD_PRIZE   600
            #define DM_PENTA_PRIZE  750

            new scoreToAdd = DM_KILL_PRIZE,
                current_tick = GetTickCount(),
                killInterval = GetTickDiff(current_tick, pHorrorEventLastKill[killerid])
            ;

            PlayerMoneyAdd(killerid, DM_KILL_PRIZE);
            PlayerMoneySub(playerid, 60);

            pEventPlus[killerid] += DM_KILL_PRIZE;
            pEventMinus[playerid] += 60;

            if (!gHorrorEventFirstBlood)
            {
                gHorrorEventFirstBlood = true;

                PlayerMoneyAdd(killerid, DM_FIRST_BLOOD);
                pEventPlus[killerid] += DM_FIRST_BLOOD;
                scoreToAdd += DM_FIRST_BLOOD;

                new string[MAX_PLAYER_NAME+5];
                format(string, sizeof string, "] %s ]", ime_rp[killerid]);
                TextDrawSetString(tdDMEvent[5], string);

                foreach (new i : iHorrorEvent)
                {
                    TextDrawShowForPlayer(i, tdDMFirstBlood), TextDrawShowForPlayer(i, tdDMEvent[5]);
                }

                tmrHorrorEventFirstBlood = SetTimer("Horror_HideFirstBlood", 2500, false);
            }
            else
            {
                if (killInterval <= 8000)
                {
                    pHorrorEventMultiKill[killerid] ++;

                    new string[MAX_PLAYER_NAME+5];
                    format(string, sizeof string, "] %s ]", ime_rp[killerid]);
                    TextDrawSetString(tdDMEvent[5], string);

                    if (pHorrorEventMultiKill[killerid] >= MULTIKILL_DOUBLE && pHorrorEventMultiKill[killerid] <= MULTIKILL_PENTA)
                    {
                        KillTimer(tmrHorrorEventFirstBlood), tmrHorrorEventFirstBlood = 0;
                        KillTimer(tmrHorrorEventDouble), tmrHorrorEventDouble = 0;
                        KillTimer(tmrHorrorEventTriple), tmrHorrorEventTriple = 0;
                        KillTimer(tmrHorrorEventQuad), tmrHorrorEventQuad = 0;
                        KillTimer(tmrHorrorEventPenta), tmrHorrorEventPenta = 0;

                        foreach (new i : iHorrorEvent)
                        {
                            TextDrawHideForPlayer(i, tdDMFirstBlood);
                            TextDrawHideForPlayer(i, tdDMDouble);
                            TextDrawHideForPlayer(i, tdDMTriple);
                            TextDrawHideForPlayer(i, tdDMQuad);
                            TextDrawHideForPlayer(i, tdDMPenta);
                        }

                        if (pHorrorEventMultiKill[killerid] == MULTIKILL_DOUBLE)
                        {
                            foreach (new i : iHorrorEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMDouble), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrHorrorEventDouble = SetTimer("Horror_HideDouble", 2500, false);

                            PlayerMoneyAdd(killerid, DM_DOUBLE_PRIZE);
                            pEventPlus[killerid] += DM_DOUBLE_PRIZE;
                            scoreToAdd += DM_DOUBLE_PRIZE;
                        }

                        else if (pHorrorEventMultiKill[killerid] == MULTIKILL_TRIPLE)
                        {
                            foreach (new i : iHorrorEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMTriple), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrHorrorEventTriple = SetTimer("Horror_HideTriple", 2500, false);

                            PlayerMoneyAdd(killerid, DM_TRIPLE_PRIZE);
                            pEventPlus[killerid] += DM_TRIPLE_PRIZE;
                            scoreToAdd += DM_TRIPLE_PRIZE;
                        }

                        else if (pHorrorEventMultiKill[killerid] == MULTIKILL_QUADRIPLE)
                        {
                            foreach (new i : iHorrorEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMQuad), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrHorrorEventQuad = SetTimer("Horror_HideQuad", 2500, false);

                            PlayerMoneyAdd(killerid, DM_QUAD_PRIZE);
                            pEventPlus[killerid] += DM_QUAD_PRIZE;
                            scoreToAdd += DM_QUAD_PRIZE;
                        }

                        else if (pHorrorEventMultiKill[killerid] == MULTIKILL_PENTA)
                        {
                            foreach (new i : iHorrorEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMPenta), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrHorrorEventPenta = SetTimer("Horror_HidePenta", 2500, false);

                            PlayerMoneyAdd(killerid, DM_PENTA_PRIZE);
                            pEventPlus[killerid] += DM_PENTA_PRIZE;
                            scoreToAdd += DM_PENTA_PRIZE;
                        }
                    }
                }
            }

            pHorrorEventLastKill[killerid] = GetTickCount();
            pHorrorEventLastKill[playerid] = 0;
        }
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    if (Iter_Contains(iHorrorEvent, playerid))
    {
        pHorrorEvent_Spawn(playerid, false);
        StaffMsg(DEBUG, "[DEBUG] - HororEvent - OnPlayerSpawn [%s]", ime_rp[playerid]);
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerInHorrorEvent(playerid)
{
    return pHorrorEvent{playerid};
}

stock IspHorrorEventActive()
{
    if (gEventStage > DM_EVENT_INACTIVE)
    {
        return true;
    }
    else
    {
        return false;
    }
}

forward pHorrorEvent_Reminder();
public pHorrorEvent_Reminder()
{
    if (DebugFunctions())
    {
        LogFunctionExec("pHorrorEvent_Reminder");
    }

    foreach(new i : Player)
    {
        if (!pHorrorEvent{i} && IsPlayerLoggedIn(i))
        {
            SendClientMessage(i, ZELENA, "Horor Event | Ostalo je jos 15 sekundi do kraja prijava. Koristite {00FF00}/horor {33AA33}da se prijavite.");
        }
    }

    tmrHorrorEvent = SetTimer("pHorrorEvent_StopSubmissions", 15000, false);
}

forward pHorrorEvent_StopSubmissions();
public pHorrorEvent_StopSubmissions()
{
    if (DebugFunctions())
    {
        LogFunctionExec("pHorrorEvent_StopSubmissions");
    }

    tmrHorrorEvent = 0;
    gEventStage = DM_EVENT_WAITING_START;
    SendClientMessageToAll(ZELENA, "Horor Event | Vreme za prijave je isteklo. Event uskoro pocinje.");
}

forward pHorrorEvent_Time();
public pHorrorEvent_Time()
{
    gEventDuration -= 1;
    if (gEventDuration <= 0) gEventDuration = 0;

    // TD Update
    new str[20];
    format(str, sizeof str, "VREME:      %s", konvertuj_vreme(gEventDuration));
    TextDrawSetString(tdDMEvent[4], str);

    if (gEventDuration <= 0)
    {
        // Horor Event je zavrsen
        KillTimer(tmrHorrorEvent);


        gEventDuration = 0;
        new mvp = INVALID_PLAYER_ID, mvpScore = -1000000;
        new score[MAX_PLAYERS] = {-1000000, -1000000, ...};
        foreach (new i : iHorrorEvent)
        {
            score[i] = pEventPlus[i] - pEventMinus[i];

            if (score[i] > mvpScore)
            {
                mvpScore = pEventPlus[i] - pEventMinus[i];
                mvp = i;
            }

            for__loop (new t = 0; t < sizeof tdDMEvent; t++)
            {
                TextDrawHideForPlayer(i, tdDMEvent[t]);
            }

            pHorrorEvent_RemovePlayer(i, false);
        }

        if (IsPlayerConnected(mvp))
        {
            foreach (new i : Player)
            {
                if (!IsPlayerLoggedIn(i)) return 1;

                if (score[i] != -1000000)
                {
                    SendClientMessageF(i, ZELENA2, "(horor) {33AA33}Horor Event je zavrsen | MVP: {FFFF00}%s (score: %s) {33AA33}| Vas score: {00FF00}%s", ime_rp[mvp], formatMoneyString(mvpScore), formatMoneyString(score[i]));
                }
                else
                {
                    SendClientMessageF(i, ZELENA2, "(horor) {33AA33}Horor Event je zavrsen | MVP: {00FF00}%s (score: %s)", ime_rp[mvp], formatMoneyString(mvpScore));
                }
            }
        }


        Iter_Clear(iHorrorEvent);
        gEventStage = DM_EVENT_INACTIVE;
    }
    return 1;
}

stock pHorrorEvent_SetSpawnInfo(playerid)
{
    new rand = random(sizeof HororSpawnPos);
    SetSpawnInfo(playerid, 1, 264, HororSpawnPos[rand][0], HororSpawnPos[rand][1], HororSpawnPos[rand][2], HororSpawnPos[rand][3], 9, 1000, 44, 1000, 0, 0);
}

stock pHorrorEvent_Spawn(playerid, bool:setPos = false)
{
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    SetPlayerWeather(playerid, 7);
    SetPlayerSkin(playerid, 264);

    GivePlayerWeapon(playerid, 33, 1000);
    GivePlayerWeapon(playerid, 44, 1000);

    if (setPos)
    {
        // Postavljanje oruzja, skina i pozicije
        TogglePlayerControllable_H(playerid, true);

        new rand = random(sizeof HororSpawnPos);
        SetPlayerCompensatedPos(playerid, HororSpawnPos[rand][0], HororSpawnPos[rand][1], HororSpawnPos[rand][2]);
        SetPlayerFacingAngle(playerid, HororSpawnPos[rand][3]);
        SetCameraBehindPlayer(playerid);
    }

    pHorrorEventLastKill[playerid] = 0;
    pHorrorEventMultiKill[playerid] = MULTIKILL_NONE;

    StaffMsg(DEBUG, "[DEBUG] - HororEvent - pHorrorEvent_Spawn [%s]", ime_rp[playerid]);
}

stock pHorrorEvent_RemovePlayer(playerid, iteratorRemove = false)
{
    pHorrorEvent{playerid} = false;
    if (iteratorRemove) Iter_Remove(iHorrorEvent, playerid);

    for__loop (new t = 0; t < sizeof tdDMEvent; t++)
    {
        TextDrawHideForPlayer(playerid, tdDMEvent[t]);
    }
    TextDrawHideForPlayer(playerid, tdDMFirstBlood);
    TextDrawHideForPlayer(playerid, tdDMDouble);
    TextDrawHideForPlayer(playerid, tdDMTriple);
    TextDrawHideForPlayer(playerid, tdDMQuad);
    TextDrawHideForPlayer(playerid, tdDMPenta);

    ptdDMEvent_Destroy(playerid);
    PlayerRestorePosition(playerid);
    SpawnPlayer(playerid); // Ne koristimo "_H" jer ga treba spawnati malo drugacije
    SetPlayerTeam(playerid, NO_TEAM);
}

forward Horor_Countdown(count);
public Horor_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            foreach(new i : iHorrorEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 2:
        {
            foreach(new i : iHorrorEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 3:
        {
            foreach(new i : iHorrorEvent)
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
            foreach(new i : iHorrorEvent)
            {
                TextDrawHideForPlayer(i, tdEventCountdown[7]);
                TextDrawHideForPlayer(i, tdEventCountdown[8]);
                TextDrawHideForPlayer(i, tdEventCountdown[9]);
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                TextDrawShowForPlayer(i, tdEventCountdown[9]);
                PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);

                TogglePlayerControllable_H(i, true);
            }

            // Pokrece se timer za zaustavljanje Horor Event-a
            KillTimer(tmrHorrorEvent);
            tmrHorrorEvent = SetTimer("pHorrorEvent_Time", 1000, true);
        }
        case 5:
        {
            foreach(new i : iHorrorEvent)
            {
                for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(i, tdEventCountdown[t]);
            }
            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("Horor_Countdown", 1000, false, "i", count+1);

    return 1;
}

forward Horror_HideFirstBlood();
public Horror_HideFirstBlood()
{
    foreach (new i : iHorrorEvent)
    {
        TextDrawHideForPlayer(i, tdDMFirstBlood), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrHorrorEventFirstBlood = 0;
    return 1;
}

forward Horror_HideDouble();
public Horror_HideDouble()
{
    foreach (new i : iHorrorEvent)
    {
        TextDrawHideForPlayer(i, tdDMDouble), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrHorrorEventDouble = 0;
    return 1;
}

forward Horror_HideTriple();
public Horror_HideTriple()
{
    foreach (new i : iHorrorEvent)
    {
        TextDrawHideForPlayer(i, tdDMTriple), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrHorrorEventTriple = 0;
    return 1;
}

forward Horror_HideQuad();
public Horror_HideQuad()
{
    foreach (new i : iHorrorEvent)
    {
        TextDrawHideForPlayer(i, tdDMQuad), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrHorrorEventQuad = 0;
    return 1;
}

forward Horror_HidePenta();
public Horror_HidePenta()
{
    foreach (new i : iHorrorEvent)
    {
        TextDrawHideForPlayer(i, tdDMPenta), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrHorrorEventPenta = 0;
    return 1;
}





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:hororevent(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0) // Pokreni prijave
        {
            if (gEventStage != DM_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Horor Event je vec u toku.");

            foreach (new i : Player)
            {
                pEventPlus[playerid] = pEventMinus[playerid] = 0;
            }

            dmTeamSwitcher = false;
            gEventStage = DM_EVENT_SIGNUPS;
            SendClientMessageToAll(ZELENA, "Organizuje se {00FF00}Horor Event {33AA33}| Upisite /horor da se prijavite (vreme: 60 sec)");
            StaffMsg(ZELENA, "* %s je pokrenuo prijave za {00FF00}Horor Event.", ime_rp[playerid]);

            Iter_Clear(iHorrorEvent);
            gEventDuration = 0;

            tmrHorrorEvent = SetTimer("pHorrorEvent_Reminder", 45000, false);
        }
        else if (listitem == 1) // Zaustavi prijave
        {
            if (gEventStage != DM_EVENT_SIGNUPS)
                return ErrorMsg(playerid, "Prijave za Horor Event nisu u toku.");

            gEventStage = DM_EVENT_WAITING_START;
            SendClientMessageToAll(ZELENA, "Prijave za Horor Event su zaustavljene.");
            StaffMsg(ZELENA, "* %s je zaustavio prijave za Horor Event.", ime_rp[playerid]);

            KillTimer(tmrHorrorEvent);
        }
        else if (listitem == 2) // Pokreni event
        {
            if (gEventStage != DM_EVENT_WAITING_START)
                return ErrorMsg(playerid, "Morate zaustaviti prijave pre nego sto pokrenete Horor Event.");

            if (gEventDuration <= 0)
                return ErrorMsg(playerid, "Morate postaviti vreme trajanja pre pokretanja Horor Eventa.");

            gHorrorEventFirstBlood = false;

            // Dodela oruzja, promena pozicije
            foreach (new i : iHorrorEvent)
            {
                ResetPlayerWeapons(i);
                pHorrorEvent_Spawn(i, true);
                TogglePlayerControllable_H(i, false);
                SendClientMessage(i, ZELENA, "Horor Event je pokrenut!");

                for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(i, tdEventCountdown[j]);
                TextDrawShowForPlayer(i, tdDMEvent[4]);
            }

            SetTimerEx("Horor_Countdown", 1000, false, "i", 1);
            StaffMsg(ZELENA, "Horor Event | {00FF00}%s {33AA33}je pokrenuo Horor Event.", ime_rp[playerid]);

            gEventStage = DM_EVENT_IN_PROGRESS;
        }
        else if (listitem == 3) // Zaustavi event
        {
            if (gEventStage == DM_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Horor Event nije aktivan.");

            foreach (new i : iHorrorEvent)
            {
                pHorrorEvent_RemovePlayer(playerid, false);
                SendClientMessageF(i, ZELENA, "Horor Event | %s je zaustavio Horor Event.", ime_rp[playerid]);
            }

            gEventDuration = 0;
            pHorrorEvent_Time();
        }
        else if (listitem == 4) // Postavi vreme
        {
            if (gEventStage == DM_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Horor Event nije aktivan.");

            SPD(playerid, "hororevent_duration", DIALOG_STYLE_INPUT, "Horor Event", "{FFFFFF}Unesite vreme trajanja Horor Event-a (u minutima):", "Potvrdi", "Izadji");
        }
    }
    return 1;
}

Dialog:hororevent_duration(playerid, response, listitem, const inputtext[])
{
    new duration;
    if (sscanf(inputtext, "i", duration))
        return DialogReopen(playerid);

    if (duration < 3 || duration > 20)
    {
        ErrorMsg(playerid, "Unos mora biti izmedju 3 i 20 minuta.");
        return DialogReopen(playerid);
    }

    gEventDuration = duration * 60;
    StaffMsg(ZELENA, "Horor Event | %s je postavio vreme trajanja Horor Event-a na {00FF00}%i minuta.", ime_rp[playerid], duration);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:hororevent(playerid, const params[])
{
    if (!IsHelper(playerid, 3))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (IsRaceActive())
        return ErrorMsg(playerid, "Ne mozete pokrenuti Horor Event dok je trka aktivna.");

    SPD(playerid, "hororevent", DIALOG_STYLE_LIST, "Horor Event", "Pokreni prijave\nZaustavi prijave\nPokreni event\nZaustavi event\nPostavi vreme trajanja", "OK", "Izadji");
    return 1;
}

CMD:horor(playerid, const params[])
{
    if (gEventStage != DM_EVENT_SIGNUPS && gEventStage != DM_EVENT_IN_PROGRESS)
        return ErrorMsg(playerid, "Horor Event nije u toku.");

    if (pHorrorEvent{playerid})
        return ErrorMsg(playerid, "Vec ste prijavljeni na Horor Event.");
        
    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici na Horor Event!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli na Horor Event!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na Horor Event dok pljackate zlataru!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete se prijaviti na Horor Event jer ste zavezani ili uhapseni.");

    if (IsPlayerWorking(playerid))
        job_stop(playerid);

    SavePlayerWeaponDataAndPos(playerid);

    if (gEventStage == DM_EVENT_SIGNUPS)
    {
        pHorrorEvent{playerid} = true;
        pEventPlus[playerid] = pEventMinus[playerid] = 0;
        Iter_Add(iHorrorEvent, playerid);

        ptdDMEvent_Create(playerid);
        ptdDMEvent_Show(playerid);

        foreach (new i : iHorrorEvent)
        {
            SendClientMessageF(i, ZELENA2, "Horor Event | %s {33AA33}se prijavio na Horor Event.", ime_rp[playerid]);
        }

        SendClientMessage(playerid, BELA, "* Sacekajte pocetak eventa - automatski cete biti teleportovani. Da napustite event: {FF0000}/horornapusti.");
    }
    else if (gEventStage == DM_EVENT_IN_PROGRESS)
    {
        pHorrorEvent{playerid} = true;
        Iter_Add(iHorrorEvent, playerid);

        ptdDMEvent_Create(playerid);
        ptdDMEvent_Show(playerid);


        ResetPlayerWeapons(playerid);
        pHorrorEvent_Spawn(playerid, true);

        foreach (new i : iHorrorEvent)
        {
            SendClientMessageF(i, ZELENA2, "Horor Event | %s {33AA33}se prijavio na Horor Event.", ime_rp[playerid]);
        }

        TextDrawShowForPlayer(playerid, tdDMEvent[4]); // Vreme

        SendClientMessage(playerid, BELA, "* Da napustite event: {FF0000}/horornapusti.");
    }


    if (IsHelper(playerid, 1) && IsOnDuty(playerid))
    {
        callcmd::duznost(playerid, ""); // gasi duty za staffovce
    }
    return 1;
}

CMD:horornapusti(playerid, const params[])
{
    if (!Iter_Contains(iHorrorEvent, playerid))
        return ErrorMsg(playerid, "Niste prijavljeni na Horor Event.");

    pHorrorEvent_RemovePlayer(playerid, true);

    foreach (new i : iHorrorEvent)
    {
        SendClientMessageF(i, ZELENA2, "(horor) %s {33AA33}je napustio Horor Event.", ime_rp[playerid]);
    }
    return 1;
}