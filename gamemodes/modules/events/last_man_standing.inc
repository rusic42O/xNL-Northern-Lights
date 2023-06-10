#include <YSI_Coding\y_hooks>

// TODO: napraviti dinamicki krug precnika 100 npr, i ne dozvoliti da se iz njega izadje

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
    LMS_EVENT_INACTIVE = 0,
    LMS_EVENT_SIGNUPS,
    LMS_EVENT_WAITING_START,
    LMS_EVENT_IN_PROGRESS,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new LMS_Event_Stage,
    LMS_Event_Prize,
    Float:LMS_Event_Pos[3],

    bool:LMS_Event_[MAX_PLAYERS],

    LMS_Event_Area,
    tajmer:LMS_Event_,
    Iterator:iLMSEvent<MAX_PLAYERS>;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    LMS_Event_Stage = LMS_EVENT_INACTIVE;
    tajmer:LMS_Event_ = 0;
    return true;
}

hook OnPlayerConnect(playerid)
{
    LMS_Event_[playerid] = false;
    return true;
}

hook OnPlayerDisconnect(playerid)
{
    if (Iter_Contains(iLMSEvent, playerid))
    {
        Iter_Remove(iLMSEvent, playerid);
        LMSEvent_CheckWinner();
    }
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (Iter_Contains(iLMSEvent, playerid) || LMS_Event_[playerid])
    {
        LMS_Event_[playerid] = false;
        Iter_Remove(iLMSEvent, playerid);
        LMSEvent_CheckWinner();
    }
    return true;
}

hook OnPlayerSpawn(playerid)
{
    if (Iter_Contains(iLMSEvent, playerid) || LMS_Event_[playerid])
    {
        LMS_Event_[playerid] = false;
        Iter_Remove(iLMSEvent, playerid);
        LMSEvent_CheckWinner();
    }
    return true;
}

hook OnPlayerPause(playerid)
{
    if (Iter_Contains(iLMSEvent, playerid) || LMS_Event_[playerid])
    {
        LMS_Event_[playerid] = false;
        Iter_Remove(iLMSEvent, playerid);
        LMSEvent_CheckWinner();

        SendClientMessage(playerid, TAMNOCRVENA, "Diskvalifikovani ste sa Last Man Standing-a jer ste pauzirali igru.");
    }
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (LMS_Event_[playerid] && areaid == LMS_Event_Area && Iter_Contains(iLMSEvent, playerid))
    {
        LMS_Event_[playerid] = false;
        Iter_Remove(iLMSEvent, playerid);
        LMSEvent_CheckWinner();

        SendClientMessage(playerid, TAMNOCRVENA, "Diskvalifikovani ste sa Last Man Standing-a jer ste napustili zvonu eventa.");
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerInLMSEvent(playerid)
{
    return LMS_Event_[playerid];
}

stock LMSEvent_CheckWinner()
{
    if (DebugFunctions())
    {
        LogFunctionExec("LMSEvent_CheckWinner");
    }

    if (Iter_Count(iLMSEvent) == 1)
    {
        // Imamo pobednika
        new winnerid = Iter_First(iLMSEvent);
        GameTextForPlayer(winnerid, "~r~Last Man Standing: ~r~POBEDA", 5000, 3);

        PlayerMoneyAdd(winnerid, LMS_Event_Prize);
        SpawnPlayer(winnerid);
        TextDrawHideForAll(tdLMSEvent);

        LMS_Event_Stage = LMS_EVENT_INACTIVE;

        new string[128];
        format(string, sizeof string, "Last Man Standing | %s je jedini preziveo i osvojio %s", ime_rp[winnerid], formatMoneyString(LMS_Event_Prize));
        SendClientMessageToAll(ZELENA, string);
    }
    else
    {
        // Nemamo pobednika, ali se nesto promenilo -> azuriraj broj u TD-u
        new tdstr[14];
        format(tdstr, sizeof tdstr, "LMS: %i", Iter_Count(iLMSEvent));
        TextDrawSetString(tdLMSEvent, tdstr);
    }
}

stock IsLMSEventActive()
{
    if (LMS_Event_Stage > LMS_EVENT_INACTIVE)
    {
        return true;
    }
    else
    {
        return false;
    }
}

forward LMSEvent_Reminder();
public LMSEvent_Reminder()
{
    if (DebugFunctions())
    {
        LogFunctionExec("LMSEvent_Reminder");
    }

    foreach(new i : Player)
    {
        if (!LMS_Event_[i] && IsPlayerLoggedIn(i))
        {
            SendClientMessage(i, ZELENA, "Last Man Standing | Ostalo je jos 15 sekundi do kraja prijava. Koristite {00FF00}/lms {33AA33}da se prijavite.");
        }
    }

    tajmer:LMS_Event_ = SetTimer("LMSEvent_StopSubmissions", 15000, false);
}

forward LMSEvent_StopSubmissions();
public LMSEvent_StopSubmissions()
{
    if (DebugFunctions())
    {
        LogFunctionExec("LMSEvent_StopSubmissions");
    }

    tajmer:LMS_Event_ = 0;
    SendClientMessageToAll(ZELENA, "Last Man Standing | Vreme za prijave je isteklo.");
}

forward LMSEvent_Countdown(count);
public LMSEvent_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            foreach(new i : iLMSEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[7]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 2:
        {
            foreach(new i : iLMSEvent)
            {
                TextDrawShowForPlayer(i, tdEventCountdown[8]);
                PlayerPlaySound(i, 1056, 0.0, 0.0, 0.0);
            }
        }
        case 3:
        {
            foreach(new i : iLMSEvent)
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
            foreach(new i : iLMSEvent)
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
        }
        case 5:
        {
            foreach(new i : iLMSEvent)
            {
                for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(i, tdEventCountdown[t]);
            }
            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("LMSEvent_Countdown", 1000, false, "i", count+1);

    return 1;
}





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:LMS_Event_(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0) // Pokreni prijave
        {
            if (LMS_Event_Stage != LMS_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Last Man Standing je vec u toku.");

            LMS_Event_Stage = LMS_EVENT_SIGNUPS;
            SendClientMessageToAll(ZELENA, "Organizuje se {00FF00}Last Man Standing {33AA33}| Upisite /lms da se prijavite (vreme: 60 sec)");
            StaffMsg(ZELENA, "* %s je pokrenuo prijave za Last Man Standing.", ime_rp[playerid]);

            Iter_Clear(iLMSEvent);
            LMS_Event_Prize = 0;
            GetPlayerPos(playerid, LMS_Event_Pos[0], LMS_Event_Pos[1], LMS_Event_Pos[2]);
            LMS_Event_Area = CreateDynamicCircle(LMS_Event_Pos[0], LMS_Event_Pos[1], 100.0);

            tajmer:LMS_Event_ = SetTimer("LMSEvent_Reminder", 45000, false);
        }
        else if (listitem == 1) // Zaustavi prijave
        {
            if (LMS_Event_Stage != LMS_EVENT_SIGNUPS)
                return ErrorMsg(playerid, "Prijave za Last Man Standing nisu u toku.");

            LMS_Event_Stage = LMS_EVENT_WAITING_START;
            SendClientMessageToAll(ZELENA, "Prijave za Last Man Standing su zaustavljene.");
            StaffMsg(ZELENA, "* %s je zaustavio prijave za Last Man Standing.", ime_rp[playerid]);

            KillTimer(tajmer:LMS_Event_), tajmer:LMS_Event_ = 0;
        }
        else if (listitem == 2) // Pokreni event
        {
            if (LMS_Event_Stage != LMS_EVENT_WAITING_START)
                return ErrorMsg(playerid, "Morate zaustaviti prijave pre nego sto pokrenete Last Man Standing.");

            if (LMS_Event_Prize <= 0)
                return ErrorMsg(playerid, "Morate postaviti nagradu pre pokretanja Last Man Standing Eventa.");

            foreach (new i : iLMSEvent)
            {
                GivePlayerWeapon(i, 31, 2000);
                SetPlayerHealth(i, 100.0);
                SetPlayerArmour(i, 100.0);
                TogglePlayerControllable_H(i, true);

                SendClientMessageF(i, ZELENA, "Last Man Standing je pokrenut | Igrac koji prezivi osvaja {00FF00}%s.", formatMoneyString(LMS_Event_Prize));
            }

            SetTimerEx("LMSEvent_Countdown", 1000, false, "i", 1);
            StaffMsg(ZELENA, "Last Man Standing | {00FF00}%s {33AA33}je pokrenuo Last Man Standing.", ime_rp[playerid]);
        }
        else if (listitem == 3) // Zaustavi event
        {
            if (LMS_Event_Stage == LMS_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Last Man Standing nije aktivan.");

            foreach (new i : iLMSEvent)
            {
                LMS_Event_[i] = false;
                SpawnPlayer(i);
                SendClientMessageF(i, ZELENA, "Last Man Standing | %s je zaustavio Last Man Standing.", ime_rp[playerid]);
            }

            TextDrawHideForAll(tdLMSEvent);
            LMS_Event_Stage = LMS_EVENT_INACTIVE;
            Iter_Clear(iLMSEvent);
            KillTimer(tajmer:LMS_Event_), tajmer:LMS_Event_ = 0;
        }
        else if (listitem == 4) // Postavi nagradu
        {
            if (LMS_Event_Stage == LMS_EVENT_INACTIVE)
                return ErrorMsg(playerid, "Last Man Standing nije aktivan.");

            SPD(playerid, "lmsevent_prize", DIALOG_STYLE_INPUT, "LAST MAN STANDING", "{FFFFFF}Unesite iznos nagrade za poslednjeg prezivelog igraca:", "Potvrdi", "Izadji");
        }
    }
    return 1;
}

Dialog:lmsevent_prize(playerid, response, listitem, const inputtext[])
{
    new iznos;
    if (sscanf(inputtext, "i", iznos))
        return DialogReopen(playerid);

    if ((!IsAdmin(playerid, 6) && (iznos < 0 || iznos > 100000)) || (IsAdmin(playerid, 6) && (iznos < 0 || iznos > 1000000)))
    {
        ErrorMsg(playerid, "Nevazeci unos (max. $100.000)");
        return DialogReopen(playerid);
    }

    LMS_Event_Prize = iznos;
    StaffMsg(ZELENA, "Last Man Standing | %s je postavio iznos nagrade na {00FF00}%s.", ime_rp[playerid], formatMoneyString(iznos));
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:lmsevent(playerid, const params[])
{
    if (!IsAdmin(playerid, 1))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (IsRaceActive())
        return ErrorMsg(playerid, "Ne mozete pokrenuti Last Man Standing dok je trka aktivna.");

    SPD(playerid, "LMS_Event_", DIALOG_STYLE_LIST, "LAST MAN STANDING", "Pokreni prijave\nZaustavi prijave\nPokreni event\nZaustavi event\nPostavi nagradu", "OK", "Izadji");
    return 1;
}

CMD:lms(playerid, const params[])
{
    if (LMS_Event_Stage != LMS_EVENT_SIGNUPS)
        return ErrorMsg(playerid, "Prijave za Last Man Standing nisu u toku.");

    if (LMS_Event_[playerid])
        return ErrorMsg(playerid, "Vec ste prijavljeni na Last Man Standing.");
        
    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici na Last Man Standing!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli na Last Man Standing!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na Last Man Standing dok pljackate zlataru!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete se prijaviti na Last Man Standing jer ste zavezani ili uhapseni.");

    if (IsPlayerWorking(playerid))
        job_stop(playerid);

    SetPlayerCompensatedPos(playerid, LMS_Event_Pos[0]-10+random(20), LMS_Event_Pos[1]-10+random(20), LMS_Event_Pos[2]+1.0);
    LMS_Event_[playerid] = true;
    Iter_Add(iLMSEvent, playerid);

    new tdstr[14];
    format(tdstr, sizeof tdstr, "LMS: %i", Iter_Count(iLMSEvent));
    TextDrawSetString(tdLMSEvent, tdstr);
    TextDrawShowForPlayer(playerid, tdLMSEvent);

    new string[64];
    format(string, sizeof string, "* %s se pridruzio na Last Man Standing.", ime_rp[playerid]);
    RangeMsg(playerid, string, ZELENA2, 50.0);
    return 1;
}
