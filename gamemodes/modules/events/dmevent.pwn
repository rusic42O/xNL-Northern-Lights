#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define DM_SKIN1 (170) // Crveni
#define DM_SKIN2 (60)  // Sivi

#define DM_TEAM1 (true)
#define DM_TEAM2 (false)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
	DM_EVENT_INACTIVE = 0,
	DM_EVENT_SIGNUPS,
	DM_EVENT_WAITING_START,
	DM_EVENT_IN_PROGRESS,
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
new dmeventStage,
	dmeventDuration,
    dmeventScore_T1,
    dmeventScore_T2,
    dmeventKills_T1,
    dmeventKills_T2,
    dmeventPlayers_T1,
    dmeventPlayers_T2,

	bool:dmevent[MAX_PLAYERS char],
    bool:dmeventTeam[MAX_PLAYERS char],
    dmeventPlus[MAX_PLAYERS],
    dmeventMinus[MAX_PLAYERS],
    dmeventLastKill[MAX_PLAYERS],
    dmeventMultiKill[MAX_PLAYERS],

    bool:dmeventFirstBlood,

	Iterator:iDMEvent<MAX_PLAYERS>,

	tmrDMEvent,
    tmrDMEventFirstBlood,
    tmrDMEventDouble,
    tmrDMEventTriple,
    tmrDMEventQuad,
    tmrDMEventPenta,

    bool:dmTeamSwitcher;

new Float:DM_Team1Pos[][4] = 
{
    {1158.9130, 1360.3767, 10.7915, 90.0},
    {1161.8434, 1360.3696, 10.7915, 90.0},
    {1164.7212, 1360.6781, 10.7915, 90.0},
    {1167.4034, 1360.1156, 10.7915, 90.0},
    {1170.4739, 1359.9810, 10.7915, 90.0},
    {1173.5688, 1360.0021, 10.7915, 90.0},
    {1175.1379, 1361.5369, 10.7915, 90.0},
    {1174.0913, 1356.7803, 10.7915, 90.0},
    {1171.1597, 1356.9147, 10.7915, 90.0},
    {1168.3846, 1356.9344, 10.7915, 90.0},
    {1165.2415, 1356.9342, 10.7915, 90.0},
    {1162.2853, 1356.9323, 10.7915, 90.0},
    {1159.2296, 1357.2162, 10.7915, 90.0},
    {1159.0784, 1355.3981, 10.7915, 90.0},
    {1162.6089, 1354.9994, 10.7915, 90.0},
    {1165.2924, 1353.7777, 10.7915, 90.0},
    {1168.4487, 1353.7914, 10.7915, 90.0},
    {1171.9731, 1353.0238, 10.7915, 90.0},
    {1174.8431, 1353.1453, 10.7915, 90.0},
    {1175.4338, 1350.5669, 10.7915, 90.0},
    {1172.0410, 1350.0746, 10.7915, 90.0},
    {1168.0343, 1350.4478, 10.7915, 90.0},
    {1164.1508, 1350.4241, 10.7915, 90.0},
    {1160.3773, 1349.7314, 10.7915, 90.0},
    {1156.7428, 1349.4755, 10.8203, 90.0},
    {1158.0627, 1347.3888, 10.7915, 90.0},
    {1161.7249, 1347.3960, 10.7915, 90.0},
    {1165.1802, 1347.6404, 10.7915, 90.0},
    {1168.9272, 1346.7255, 10.7915, 90.0},
    {1172.5658, 1346.9824, 10.7915, 90.0},
    {1175.3538, 1346.9414, 10.7915, 90.0}
};

new Float:DM_Team2Pos[][4] = 
{
    {1122.7081, 1206.5913, 10.8515, 270.0},
    {1118.5287, 1206.3809, 10.8515, 270.0},
    {1114.8536, 1206.1954, 10.8515, 270.0},
    {1110.8682, 1205.9940, 10.8515, 270.0},
    {1106.6473, 1205.7811, 10.8515, 270.0},
    {1099.7335, 1205.4319, 10.8515, 270.0},
    {1099.6110, 1208.8401, 10.8515, 270.0},
    {1103.9238, 1209.0651, 10.8515, 270.0},
    {1108.2876, 1209.2480, 10.8515, 270.0},
    {1112.4202, 1209.5155, 10.8515, 270.0},
    {1122.5142, 1210.4158, 10.8515, 270.0},
    {1122.8204, 1214.8566, 10.8515, 270.0},
    {1118.2874, 1215.1641, 10.8515, 270.0},
    {1109.6724, 1215.2737, 10.8515, 270.0},
    {1105.3342, 1215.3290, 10.8515, 270.0},
    {1102.1405, 1215.3290, 10.8515, 270.0},
    {1099.4720, 1215.3290, 10.8515, 270.0},
    {1099.4957, 1219.0509, 10.8515, 270.0},
    {1104.4160, 1219.0509, 10.8515, 270.0},
    {1114.2598, 1219.7267, 10.8515, 270.0},
    {1118.5421, 1219.6943, 10.8515, 270.0},
    {1122.1982, 1219.6667, 10.8515, 270.0},
    {1122.4800, 1223.8142, 10.8515, 270.0},
    {1118.8569, 1224.1237, 10.8515, 270.0},
    {1109.0529, 1222.8856, 10.8515, 270.0},
    {1104.4542, 1223.4904, 10.8515, 270.0},
    {1100.5482, 1223.7529, 10.8515, 270.0},
    {1105.0410, 1227.1202, 10.8515, 270.0},
    {1109.3975, 1226.9948, 10.8515, 270.0},
    {1113.8762, 1227.3160, 10.8515, 270.0},
    {1118.1317, 1227.9697, 10.8515, 270.0}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	dmeventStage = DM_EVENT_INACTIVE;
	tmrDMEvent = 0;
    return true;
}

hook OnPlayerConnect(playerid)
{
	dmevent{playerid} = false;
    dmeventPlus[playerid] = dmeventMinus[playerid] = 0;
}

hook OnPlayerDisconnect(playerid)
{
	if (Iter_Contains(iDMEvent, playerid))
	{
		Iter_Remove(iDMEvent, playerid);
        dmevent{playerid} = false;

        foreach (new i : iDMEvent)
        {
            SendClientMessageF(i, ZELENA, "DM Event | {00FF00}%s {33AA33}je napustio DM Event.", ime_rp[playerid]);
        }
	}
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (Iter_Contains(iDMEvent, playerid))
    {
        DMEvent_SetSpawnInfo(playerid);

        if (!IsPlayerConnected(killerid)) return 1;
    	
        if (Iter_Contains(iDMEvent, killerid))
    	{
            #define DM_KILL_PRIZE   150
            #define DM_FIRST_BLOOD  1000
            #define DM_DOUBLE_PRIZE 300
            #define DM_TRIPLE_PRIZE 450
            #define DM_QUAD_PRIZE   600
            #define DM_PENTA_PRIZE  750

            new scoreToAdd = DM_KILL_PRIZE,
                current_tick = GetTickCount(),
                killInterval = GetTickDiff(current_tick, dmeventLastKill[killerid]);

            PlayerMoneyAdd(killerid, DM_KILL_PRIZE);
            PlayerMoneySub(playerid, 60);

            dmeventPlus[killerid] += DM_KILL_PRIZE;
            dmeventMinus[playerid] += 60;

            if (!dmeventFirstBlood)
            {
                dmeventFirstBlood = true;

                PlayerMoneyAdd(killerid, DM_FIRST_BLOOD);
                dmeventPlus[killerid] += DM_FIRST_BLOOD;
                scoreToAdd += DM_FIRST_BLOOD;

                new string[MAX_PLAYER_NAME+5];
                format(string, sizeof string, "] %s ]", ime_rp[killerid]);
                TextDrawSetString(tdDMEvent[5], string);

                foreach (new i : iDMEvent)
                {
                    TextDrawShowForPlayer(i, tdDMFirstBlood), TextDrawShowForPlayer(i, tdDMEvent[5]);
                }

                tmrDMEventFirstBlood = SetTimer("DM_HideFirstBlood", 2500, false);
            }
            else
            {
                if (killInterval <= 8000)
                {
                    dmeventMultiKill[killerid] ++;

                    new string[MAX_PLAYER_NAME+5];
                    format(string, sizeof string, "] %s ]", ime_rp[killerid]);
                    TextDrawSetString(tdDMEvent[5], string);

                    if (dmeventMultiKill[killerid] >= MULTIKILL_DOUBLE && dmeventMultiKill[killerid] <= MULTIKILL_PENTA)
                    {
                        KillTimer(tmrDMEventFirstBlood), tmrDMEventFirstBlood = 0;
                        KillTimer(tmrDMEventDouble), tmrDMEventDouble = 0;
                        KillTimer(tmrDMEventTriple), tmrDMEventTriple = 0;
                        KillTimer(tmrDMEventQuad), tmrDMEventQuad = 0;
                        KillTimer(tmrDMEventPenta), tmrDMEventPenta = 0;

                        foreach (new i : iDMEvent)
                        {
                            TextDrawHideForPlayer(i, tdDMFirstBlood);
                            TextDrawHideForPlayer(i, tdDMDouble);
                            TextDrawHideForPlayer(i, tdDMTriple);
                            TextDrawHideForPlayer(i, tdDMQuad);
                            TextDrawHideForPlayer(i, tdDMPenta);
                        }

                        if (dmeventMultiKill[killerid] == MULTIKILL_DOUBLE)
                        {
                            foreach (new i : iDMEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMDouble), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrDMEventDouble = SetTimer("DM_HideDouble", 2500, false);

                            PlayerMoneyAdd(killerid, DM_DOUBLE_PRIZE);
                            dmeventPlus[killerid] += DM_DOUBLE_PRIZE;
                            scoreToAdd += DM_DOUBLE_PRIZE;
                        }

                        else if (dmeventMultiKill[killerid] == MULTIKILL_TRIPLE)
                        {
                            foreach (new i : iDMEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMTriple), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrDMEventTriple = SetTimer("DM_HideTriple", 2500, false);

                            PlayerMoneyAdd(killerid, DM_TRIPLE_PRIZE);
                            dmeventPlus[killerid] += DM_TRIPLE_PRIZE;
                            scoreToAdd += DM_TRIPLE_PRIZE;
                        }

                        else if (dmeventMultiKill[killerid] == MULTIKILL_QUADRIPLE)
                        {
                            foreach (new i : iDMEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMQuad), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrDMEventQuad = SetTimer("DM_HideQuad", 2500, false);

                            PlayerMoneyAdd(killerid, DM_QUAD_PRIZE);
                            dmeventPlus[killerid] += DM_QUAD_PRIZE;
                            scoreToAdd += DM_QUAD_PRIZE;
                        }

                        else if (dmeventMultiKill[killerid] == MULTIKILL_PENTA)
                        {
                            foreach (new i : iDMEvent)
                            {
                                TextDrawShowForPlayer(i, tdDMPenta), TextDrawShowForPlayer(i, tdDMEvent[5]);
                            }
                            tmrDMEventPenta = SetTimer("DM_HidePenta", 2500, false);

                            PlayerMoneyAdd(killerid, DM_PENTA_PRIZE);
                            dmeventPlus[killerid] += DM_PENTA_PRIZE;
                            scoreToAdd += DM_PENTA_PRIZE;
                        }
                    }
                }
            }


            // Dodavanje skora citavom timu
            if (dmeventTeam{killerid} == DM_TEAM1)
            {
                dmeventKills_T1 ++;
                dmeventScore_T1 += scoreToAdd;
            }
            else if (dmeventTeam{killerid} == DM_TEAM2)
            {
                dmeventKills_T2 ++;
                dmeventScore_T2 += scoreToAdd;
            }


            // Update skorova (TD)
            new string[32];
            format(string, sizeof string, "TEAM A - %i~N~~N~%s", dmeventKills_T1, formatMoneyString(dmeventScore_T1));
            TextDrawSetString(tdDMEvent[2], string);
            format(string, sizeof string, "%i - TEAM B~N~~N~%s", dmeventKills_T2, formatMoneyString(dmeventScore_T2));
            TextDrawSetString(tdDMEvent[3], string);
            ptdDMEvent_Update(killerid, dmeventPlus[killerid] - dmeventMinus[killerid]);
            ptdDMEvent_Update(playerid, dmeventPlus[playerid] - dmeventMinus[playerid]);


            dmeventLastKill[killerid] = GetTickCount();
            dmeventLastKill[playerid] = 0;
    	}
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
	if (Iter_Contains(iDMEvent, playerid))
	{
		DMEvent_Spawn(playerid, false, false);
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerInDMEvent(playerid)
{
    return dmevent{playerid};
}

stock IsDMEventActive()
{
	if (dmeventStage > DM_EVENT_INACTIVE)
	{
		return true;
	}
	else
	{
		return false;
	}
}

forward DMEvent_Reminder();
public DMEvent_Reminder()
{
    if (DebugFunctions())
    {
        LogFunctionExec("DMEvent_Reminder");
    }

	foreach(new i : Player)
	{
		if (!dmevent{i} && IsPlayerLoggedIn(i))
		{
			SendClientMessage(i, ZELENA, "DM Event | Ostalo je jos 15 sekundi do kraja prijava. Koristite {00FF00}/dm {33AA33}da se prijavite.");
		}
	}

	tmrDMEvent = SetTimer("DMEvent_StopSubmissions", 15000, false);
}

forward DMEvent_StopSubmissions();
public DMEvent_StopSubmissions()
{
    if (DebugFunctions())
    {
        LogFunctionExec("DMEvent_StopSubmissions");
    }

	tmrDMEvent = 0;
    dmeventStage = DM_EVENT_WAITING_START;
	SendClientMessageToAll(ZELENA, "DM Event | Vreme za prijave je isteklo. Event uskoro pocinje.");
}

forward DMEvent_Time();
public DMEvent_Time()
{
    dmeventDuration -= 1;
    if (dmeventDuration <= 0) dmeventDuration = 0;

    // TD Update
    new str[20];
    format(str, sizeof str, "VREME:      %s", konvertuj_vreme(dmeventDuration));
    TextDrawSetString(tdDMEvent[4], str);

    if (dmeventDuration <= 0)
    {
        // DM Event je zavrsen
        KillTimer(tmrDMEvent);


        dmeventDuration = 0;
        new mvp = INVALID_PLAYER_ID, mvpScore = -1000000;
        new score[MAX_PLAYERS] = {-1000000, -1000000, ...};
        foreach (new i : iDMEvent)
        {
            score[i] = dmeventPlus[i] - dmeventMinus[i];

            if (score[i] > mvpScore)
            {
                mvpScore = dmeventPlus[i] - dmeventMinus[i];
                mvp = i;
            }

            for__loop (new t = 0; t < sizeof tdDMEvent; t++)
            {
                TextDrawHideForPlayer(i, tdDMEvent[t]);
            }

            DMEvent_RemovePlayer(i, false);
        }


        if (IsPlayerConnected(mvp))
        {
            foreach (new i : Player)
            {
                if (!IsPlayerLoggedIn(i)) return 1;

                if (score[i] != -1000000)
                {
                    SendClientMessageF(i, ZELENA2, "(dm) {33AA33}DM Event je zavrsen | MVP: {FFFF00}%s (score: %s) {33AA33}| Vas score: {00FF00}%s", ime_rp[mvp], formatMoneyString(mvpScore), formatMoneyString(score[i]));
                }
                else
                {
                    SendClientMessageF(i, ZELENA2, "(dm) {33AA33}DM Event je zavrsen | MVP: {00FF00}%s (score: %s)", ime_rp[mvp], formatMoneyString(mvpScore));
                }
            }
        }


        Iter_Clear(iDMEvent);
        dmeventStage = DM_EVENT_INACTIVE;
    }
    return 1;
}

stock DMEvent_SetSpawnInfo(playerid)
{
    // Preraspodela timova
    if (dmeventPlayers_T2 > dmeventPlayers_T1 && dmeventTeam{playerid} == DM_TEAM2)
    {
        dmeventTeam{playerid} = DM_TEAM1;

        dmeventPlayers_T1 ++;
        dmeventPlayers_T2 --;
    }
    else if (dmeventPlayers_T2 < dmeventPlayers_T1 && dmeventTeam{playerid} == DM_TEAM1)
    {
        dmeventTeam{playerid} = DM_TEAM2;

        dmeventPlayers_T2 ++;
        dmeventPlayers_T1 --;
    }

    if (dmeventTeam{playerid} == DM_TEAM1)
    {
        new rand = random(sizeof DM_Team1Pos);
        SetSpawnInfo(playerid, 1, DM_SKIN1, DM_Team1Pos[rand][0], DM_Team1Pos[rand][1], DM_Team1Pos[rand][2], DM_Team1Pos[rand][3], 24, 100, 29, 1000, 31, 1000);
    }
    else if (dmeventTeam{playerid} == DM_TEAM2)
    {
        new rand = random(sizeof DM_Team2Pos);
        SetSpawnInfo(playerid, 2, DM_SKIN2, DM_Team2Pos[rand][0], DM_Team2Pos[rand][1], DM_Team2Pos[rand][2], DM_Team2Pos[rand][3], 24, 100, 29, 1000, 31, 1000);
    }
}

stock DMEvent_Spawn(playerid, bool:adjustTeams = false, bool:setPos = false)
{
    if (adjustTeams)
    {
        if (dmeventPlayers_T2 > dmeventPlayers_T1 && dmeventTeam{playerid} == DM_TEAM2)
        {
            dmeventTeam{playerid} = DM_TEAM1;

            dmeventPlayers_T1 ++;
            dmeventPlayers_T2 --;
        }
        else if (dmeventPlayers_T2 < dmeventPlayers_T1 && dmeventTeam{playerid} == DM_TEAM1)
        {
            dmeventTeam{playerid} = DM_TEAM2;

            dmeventPlayers_T2 ++;
            dmeventPlayers_T1 --;
        }
    }

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);

    if (setPos)
    {
        // Postavljanje oruzja, skina i pozicije
        TogglePlayerControllable_H(playerid, true);

        GivePlayerWeapon(playerid, 24, 100);
        GivePlayerWeapon(playerid, 29, 1000);
        GivePlayerWeapon(playerid, 31, 1000);

        if (dmeventTeam{playerid} == DM_TEAM1)
        {
            new rand = random(sizeof DM_Team1Pos);
            SetPlayerSkin(playerid, DM_SKIN1);
            SetPlayerCompensatedPos(playerid, DM_Team1Pos[rand][0], DM_Team1Pos[rand][1], DM_Team1Pos[rand][2]);
            SetPlayerFacingAngle(playerid, DM_Team1Pos[rand][3]);
            SetPlayerTeam(playerid, 1);
        }
        else if (dmeventTeam{playerid} == DM_TEAM2)
        {
            new rand = random(sizeof DM_Team2Pos);
            SetPlayerSkin(playerid, DM_SKIN2);
            SetPlayerCompensatedPos(playerid, DM_Team2Pos[rand][0], DM_Team2Pos[rand][1], DM_Team2Pos[rand][2]);
            SetPlayerFacingAngle(playerid, DM_Team2Pos[rand][3]);
            SetPlayerTeam(playerid, 2);
        }
        SetCameraBehindPlayer(playerid);
    }

    dmeventLastKill[playerid] = 0;
    dmeventMultiKill[playerid] = MULTIKILL_NONE;
}

stock DMEvent_RemovePlayer(playerid, iteratorRemove = false)
{
    dmevent{playerid} = false;
    if (iteratorRemove) Iter_Remove(iDMEvent, playerid);

    if (dmeventTeam{playerid} == DM_TEAM1)
        dmeventPlayers_T1 --;
    else if (dmeventTeam{playerid} == DM_TEAM2)
        dmeventPlayers_T2 --;

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

forward DMEvent_Countdown(count);
public DMEvent_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            foreach(new i : iDMEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 2:
        {
            foreach(new i : iDMEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 3:
        {
            foreach(new i : iDMEvent)
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
            foreach(new i : iDMEvent)
            {
                TextDrawHideForPlayer(i, tdEventCountdown[7]);
                TextDrawHideForPlayer(i, tdEventCountdown[8]);
                TextDrawHideForPlayer(i, tdEventCountdown[9]);
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                TextDrawShowForPlayer(i, tdEventCountdown[9]);
                PlayerPlaySound(i, 1057, 0.0, 0.0, 0.0);

                for__loop (new t = 0; t < sizeof tdDMEvent; t++)
                {
                    TextDrawShowForPlayer(i, tdDMEvent[t]);
                }

                TogglePlayerControllable_H(i, true);
            }

            // Pokrece se timer za zaustavljanje DM event-a
            KillTimer(tmrDMEvent);
            tmrDMEvent = SetTimer("DMEvent_Time", 1000, true);
        }
        case 5:
        {
            foreach(new i : iDMEvent)
            {
                for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(i, tdEventCountdown[t]);
            }
            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("DMEvent_Countdown", 1000, false, "i", count+1);

    return 1;
}

forward DM_HideFirstBlood();
public DM_HideFirstBlood()
{
    foreach (new i : iDMEvent)
    {
        TextDrawHideForPlayer(i, tdDMFirstBlood), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrDMEventFirstBlood = 0;
    return 1;
}

forward DM_HideDouble();
public DM_HideDouble()
{
    foreach (new i : iDMEvent)
    {
        TextDrawHideForPlayer(i, tdDMDouble), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrDMEventDouble = 0;
    return 1;
}

forward DM_HideTriple();
public DM_HideTriple()
{
    foreach (new i : iDMEvent)
    {
        TextDrawHideForPlayer(i, tdDMTriple), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrDMEventTriple = 0;
    return 1;
}

forward DM_HideQuad();
public DM_HideQuad()
{
    foreach (new i : iDMEvent)
    {
        TextDrawHideForPlayer(i, tdDMQuad), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrDMEventQuad = 0;
    return 1;
}

forward DM_HidePenta();
public DM_HidePenta()
{
    foreach (new i : iDMEvent)
    {
        TextDrawHideForPlayer(i, tdDMPenta), TextDrawHideForPlayer(i, tdDMEvent[5]);
    }
    TextDrawSetString(tdDMEvent[5], "_");
    tmrDMEventPenta = 0;
    return 1;
}





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:dmevent(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		if (listitem == 0) // Pokreni prijave
		{
			if (dmeventStage != DM_EVENT_INACTIVE)
				return ErrorMsg(playerid, "DM Event je vec u toku.");

            foreach (new i : Player)
            {
                dmeventPlus[playerid] = dmeventMinus[playerid] = 0;
            }

            dmTeamSwitcher = false;
			dmeventStage = DM_EVENT_SIGNUPS;
			SendClientMessageToAll(ZELENA, "Organizuje se {00FF00}DM Event {33AA33}| Upisite /dm da se prijavite (vreme: 60 sec)");
			StaffMsg(ZELENA, "* %s je pokrenuo prijave za {00FF00}DM Event.", ime_rp[playerid]);

			Iter_Clear(iDMEvent);
			dmeventDuration = 0;

			tmrDMEvent = SetTimer("DMEvent_Reminder", 45000, false);
		}
		else if (listitem == 1) // Zaustavi prijave
		{
			if (dmeventStage != DM_EVENT_SIGNUPS)
				return ErrorMsg(playerid, "Prijave za DM Event nisu u toku.");

			dmeventStage = DM_EVENT_WAITING_START;
			SendClientMessageToAll(ZELENA, "Prijave za DM Event su zaustavljene.");
			StaffMsg(ZELENA, "* %s je zaustavio prijave za DM Event.", ime_rp[playerid]);

			KillTimer(tmrDMEvent);
		}
		else if (listitem == 2) // Pokreni event
		{
			if (dmeventStage != DM_EVENT_WAITING_START)
				return ErrorMsg(playerid, "Morate zaustaviti prijave pre nego sto pokrenete DM event.");

			if (dmeventDuration <= 0)
				return ErrorMsg(playerid, "Morate postaviti vreme trajanja pre pokretanja DM Eventa.");

            dmeventFirstBlood = false;
            dmeventScore_T1 = 0;
            dmeventScore_T2 = 0;
            dmeventKills_T1 = 0;
            dmeventKills_T2 = 0;
            dmeventPlayers_T1 = 0;
            dmeventPlayers_T2 = 0;

            // Dodela oruzja, promena pozicije, raspodela po timovima
			foreach (new i : iDMEvent)
			{
                ResetPlayerWeapons(i);
                DMEvent_Spawn(i, false, true);
                TogglePlayerControllable_H(i, false);
				SendClientMessage(i, ZELENA, "DM Event je pokrenut!");

                for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(i, tdEventCountdown[j]);
			}

			
            SetTimerEx("DMEvent_Countdown", 1000, false, "i", 1);
			StaffMsg(ZELENA, "DM Event | {00FF00}%s {33AA33}je pokrenuo DM Event.", ime_rp[playerid]);

            dmeventStage = DM_EVENT_IN_PROGRESS;
		}
		else if (listitem == 3) // Zaustavi event
		{
			if (dmeventStage == DM_EVENT_INACTIVE)
				return ErrorMsg(playerid, "DM Event nije aktivan.");

			foreach (new i : iDMEvent)
			{
				DMEvent_RemovePlayer(playerid, false);
				SendClientMessageF(i, ZELENA, "DM Event | %s je zaustavio DM Event.", ime_rp[playerid]);
			}

            dmeventDuration = 0;
			DMEvent_Time();

            dmeventStage = DM_EVENT_INACTIVE;
		}
		else if (listitem == 4) // Postavi vreme
		{
			if (dmeventStage == DM_EVENT_INACTIVE)
				return ErrorMsg(playerid, "DM Event nije aktivan.");

			SPD(playerid, "dmevent_duration", DIALOG_STYLE_INPUT, "DM EVENT", "{FFFFFF}Unesite vreme trajanja DM Event-a (u minutima):", "Potvrdi", "Izadji");
		}
	}
	return 1;
}

Dialog:dmevent_duration(playerid, response, listitem, const inputtext[])
{
	new duration;
	if (sscanf(inputtext, "i", duration))
		return DialogReopen(playerid);

	if (duration < 3 || duration > 20)
	{
		ErrorMsg(playerid, "Unos mora biti izmedju 3 i 20 minuta.");
		return DialogReopen(playerid);
	}

	dmeventDuration = duration * 60;
	StaffMsg(ZELENA, "DM Event | %s je postavio vreme trajanja DM Event-a na {00FF00}%i minuta.", ime_rp[playerid], duration);
	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
/*CMD:dmevent(playerid, const params[])
{
	if (!IsHelper(playerid, 3))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (IsRaceActive())
		return ErrorMsg(playerid, "Ne mozete pokrenuti DM Event dok je trka aktivna.");

	SPD(playerid, "dmevent", DIALOG_STYLE_LIST, "DM EVENT", "Pokreni prijave\nZaustavi prijave\nPokreni event\nZaustavi event\nPostavi vreme trajanja", "OK", "Izadji");
	return 1;
}*/

CMD:dm(playerid, const params[])
{
	if (dmeventStage != DM_EVENT_SIGNUPS && dmeventStage != DM_EVENT_IN_PROGRESS)
		return ErrorMsg(playerid, "DM Event nije u toku.");

	if (dmevent{playerid})
		return ErrorMsg(playerid, "Vec ste prijavljeni na DM Event.");
		
    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici na DM Event!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli na DM Event!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na DM Event dok pljackate zlataru!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete se prijaviti na DM Event jer ste zavezani ili uhapseni.");
    
    if(dmeventStage == DM_EVENT_INACTIVE) return ErrorMsg(playerid, "DM event nije aktivan.");

    if (IsPlayerWorking(playerid))
        job_stop(playerid);

    SavePlayerWeaponDataAndPos(playerid);

    if (dmeventStage == DM_EVENT_SIGNUPS)
    {
    	dmevent{playerid} = true;
        dmeventPlus[playerid] = dmeventMinus[playerid] = 0;
    	Iter_Add(iDMEvent, playerid);

        ptdDMEvent_Create(playerid);
        ptdDMEvent_Show(playerid);

        // Raspodela u tim
        dmeventTeam{playerid} = dmTeamSwitcher;
        dmTeamSwitcher = !dmTeamSwitcher;

        foreach (new i : iDMEvent)
        {
            SendClientMessageF(i, ZELENA2, "DM Event | %s {33AA33}se prijavio na DM Event.", ime_rp[playerid]);
        }

        SendClientMessage(playerid, BELA, "* Sacekajte pocetak eventa - automatski cete biti teleportovani. Da napustite event: {FF0000}/dmnapusti.");
    }
    else if (dmeventStage == DM_EVENT_IN_PROGRESS)
    {
        dmevent{playerid} = true;
        // dmeventPlus[playerid] = dmeventMinus[playerid] = 0;
        Iter_Add(iDMEvent, playerid);

        ptdDMEvent_Create(playerid);
        ptdDMEvent_Show(playerid);

        // Raspodela u tim koji ima manje igraca
        if (dmeventPlayers_T1 == dmeventPlayers_T2)
        {
            dmeventTeam{playerid} = dmTeamSwitcher;
            dmTeamSwitcher = !dmTeamSwitcher;
        }
        else if (dmeventPlayers_T2 > dmeventPlayers_T1)
        {
            dmeventTeam{playerid} = DM_TEAM1;
        }
        else if (dmeventPlayers_T2 < dmeventPlayers_T1)
        {
            dmeventTeam{playerid} = DM_TEAM2;
        }

        ResetPlayerWeapons(playerid);
        DMEvent_Spawn(playerid, false, true);

        foreach (new i : iDMEvent)
        {
            SendClientMessageF(i, ZELENA2, "DM Event | %s {33AA33}se prijavio na DM Event.", ime_rp[playerid]);
        }

        for__loop (new t = 0; t < sizeof tdDMEvent; t++)
        {
            TextDrawShowForPlayer(playerid, tdDMEvent[t]);
        }

        SendClientMessage(playerid, BELA, "* Da napustite event: {FF0000}/dmnapusti.");
    }


    // Team inc
    if (dmeventTeam{playerid} == DM_TEAM1)
        dmeventPlayers_T1 ++;
    else if (dmeventTeam{playerid} == DM_TEAM2)
        dmeventPlayers_T2 ++;


    if (IsHelper(playerid, 1) && IsOnDuty(playerid))
    {
        callcmd::duznost(playerid, ""); // gasi duty za staffovce
    }
	return 1;
}

CMD:dmnapusti(playerid, const params[])
{
    if (!Iter_Contains(iDMEvent, playerid))
        return ErrorMsg(playerid, "Niste prijavljeni na DM Event.");

    DMEvent_RemovePlayer(playerid, true);

    foreach (new i : iDMEvent)
    {
        SendClientMessageF(i, ZELENA2, "(dm) %s {33AA33}je napustio DM Event.", ime_rp[playerid]);
    }
    return 1;
}