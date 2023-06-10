#include <YSI_Coding\y_hooks>

static 
    bool:Box_Active,
    Box_P1,
    Box_P2
;

hook OnGameModeInit()
{
    Box_Active = false;
    Box_P1 = Box_P2 = INVALID_PLAYER_ID;
    return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (Box_P1 == playerid)
    {
        Box_P1 = INVALID_PLAYER_ID;
        StaffMsg(NARANDZASTA, "Box Event | {FFFF00}Igrac %s je napustio igru, event mora biti restartovan.", ime_rp[playerid]);
    }
    else if (Box_P2 == playerid)
    {
        Box_P2 = INVALID_PLAYER_ID;
        StaffMsg(NARANDZASTA, "Box Event | {FFFF00}Igrac %s je napustio igru, event mora biti restartovan.", ime_rp[playerid]);
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (Box_Active && ((Box_P1 == playerid && Box_P2 == killerid) || (Box_P1 == killerid && Box_P2 == playerid)))
    {
        StaffMsg(PLAVA, "Box Event | Pobednik: {0068B3}%s", ime_rp[killerid]);


        SetPlayerSkin(killerid, GetPlayerCorrectSkin(killerid));

        if(IsPlayerAttachedObjectSlotUsed(playerid, 0))
            RemovePlayerAttachedObject(playerid, 0);

        if(IsPlayerAttachedObjectSlotUsed(killerid, 0))
            RemovePlayerAttachedObject(killerid, 0);

        SetPlayerVirtualWorld(playerid, 0);

        Box_P1 = INVALID_PLAYER_ID;
        Box_P2 = INVALID_PLAYER_ID;
        Box_Active = false;

        ResetPlayerWeapons(killerid);
        SetPlayerHealth(killerid, 99.0);

        SetPVarInt(playerid, "pIgnoreDeathFine", 1);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

IsPlayerInBoxEvent(playerid)
{
    if (Box_P1 == playerid && Box_P2 == playerid)
    {
        return 1;
    }
    return 0;
}

forward Box_Countdown(count);
public Box_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[7]);
            PlayerPlaySound(Box_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Box_P2, tdEventCountdown[7]);
            PlayerPlaySound(Box_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 2:
        {
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[8]);
            PlayerPlaySound(Box_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Box_P2, tdEventCountdown[8]);
            PlayerPlaySound(Box_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 3:
        {
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[9]);
            PlayerPlaySound(Box_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Box_P2, tdEventCountdown[9]);
            PlayerPlaySound(Box_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 4:
        {
            TextDrawBoxColor(tdEventCountdown[7], 13369599);
            TextDrawBoxColor(tdEventCountdown[8], 13369599);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);

            // P1
            TextDrawHideForPlayer(Box_P1, tdEventCountdown[7]);
            TextDrawHideForPlayer(Box_P1, tdEventCountdown[8]);
            TextDrawHideForPlayer(Box_P1, tdEventCountdown[9]);
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[7]);
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[8]);
            TextDrawShowForPlayer(Box_P1, tdEventCountdown[9]);
            PlayerPlaySound(Box_P1, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(Box_P1, true); 

            // P2
            TextDrawHideForPlayer(Box_P2, tdEventCountdown[7]);
            TextDrawHideForPlayer(Box_P2, tdEventCountdown[8]);
            TextDrawHideForPlayer(Box_P2, tdEventCountdown[9]);
            TextDrawShowForPlayer(Box_P2, tdEventCountdown[7]);
            TextDrawShowForPlayer(Box_P2, tdEventCountdown[8]);
            TextDrawShowForPlayer(Box_P2, tdEventCountdown[9]);
            PlayerPlaySound(Box_P2, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(Box_P2, true);
        }
        case 5:
        {
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(Box_P1, tdEventCountdown[t]);
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(Box_P2, tdEventCountdown[t]);

            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("Box_Countdown", 1000, false, "i", count+1);
    return 1;
}

flags:boxport(FLAG_HELPER_1)
CMD:boxport(playerid, const params[])
{
    new
        id
    ;

    if(!sscanf(params, "u", id))
    {
        if(id == INVALID_PLAYER_ID)
            return ErrorMsg(playerid, "Pogresan ID!");

        SetPlayerVirtualWorld(id, 69);
        SetPlayerCompensatedPos(id, 1389.4478,-15.2057,1002.7076);
        InfoMsg(id, "Teleportovani ste na box event.");
    }
    else
        Koristite(playerid, "boxport [ID / Ime_Prezime]");
    
    return 1;
}

flags:box(FLAG_HELPER_1)
CMD:box(playerid, const params[])
{
    if (isnull(params) || !strcmp(params, "help", false))
    {
        Koristite(playerid, "box [Igrac 1] [Igrac 2] - za prijavu igraca na event");
        Koristite(playerid, "box start - za startovanje eventa nakon prijave igraca");
        Koristite(playerid, "box reset - za resetovanje eventa");
        Koristite(playerid, "boxport - za portanje do eventa");
        return 1;
    }

    if (!strcmp(params, "start", false))
    {
        if (Box_Active)
            return ErrorMsg(playerid, "Box Event je vec pokrenut.");

        if (Box_P1 == INVALID_PLAYER_ID || Box_P2 == INVALID_PLAYER_ID)
            return ErrorMsg(playerid, "Nisu prijavljena oba igraca na event.");

        Box_Active = true;

        TogglePlayerControllable_H(Box_P1, false);
        TogglePlayerControllable_H(Box_P2, false);

        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(Box_P1, tdEventCountdown[j]);
        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(Box_P2, tdEventCountdown[j]);

        
        SetTimerEx("Box_Countdown", 1000, false, "i", 1);
        StaffMsg(NARANDZASTA, "Box Event | {FFFFFF}%s {FFFF00}je pokrenuo Box Event | %s - %s.", ime_rp[playerid], ime_rp[Box_P1], ime_rp[Box_P2]);
    }
    else if (!strcmp(params, "reset", false))
    {
        if (IsPlayerConnected(Box_P1))
        {
            SetPlayerSkin(Box_P1, GetPlayerCorrectSkin(Box_P1));
        }
        if (IsPlayerConnected(Box_P2))
        {
            SetPlayerSkin(Box_P2, GetPlayerCorrectSkin(Box_P2));
        }

        Box_Active = false;
        Box_P1 = Box_P2 = INVALID_PLAYER_ID;

        StaffMsg(NARANDZASTA, "Box Event | {FFFFFF}%s {FFFF00}je resetovao Box Event.", ime_rp[playerid]);
    }
    else 
    {
        new p1, p2;
        if (sscanf(params, "uu", p1, p2))
            return Koristite(playerid, "box help - da vidite dostupne komande.");

        if (p1 == p2)
            return ErrorMsg(playerid, "Nije moguce uneti istog igraca u oba polja.");

        if (Box_P1 != INVALID_PLAYER_ID || Box_P2 != INVALID_PLAYER_ID)
            return ErrorMsg(playerid, "Vec ima prijavljenih igraca. Koristite \"/box reset\" da resetujete event.");

        if (!IsPlayerConnected(p1))
            return ErrorMsg(playerid, "Igrac 1 trenutno nije na serveru.");

        if (!IsPlayerConnected(p2))
            return ErrorMsg(playerid, "Igrac 2 trenutno nije na serveru.");

        if (Box_Active)
            return ErrorMsg(playerid, "Box Event je vec aktivan. Koristite \"/box reset\" da ga resetujete.");

        if (IsPlayerOnLawDuty(p1))
        {
            ToggleLawDuty(p1, false);
        }

        if (IsPlayerOnLawDuty(p2))
        {
            ToggleLawDuty(p2, false);
        }

        Box_P1 = p1;
        Box_P2 = p2;

        // Postavlja igrace na start
        SetPlayerCompensatedPosEx(p1, 1391.8215,-31.2779,1001.8614,132.2177); // Plavi
        SetPlayerAttachedObject(p1, 0, 18952, 2, 0.1010, 0.0229, 0.0000, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000, 0xFF1E90FF, 0xFFFFFFFF); // BoxingHelmet1 attached to the Head of daddyDOT
        SetPlayerSkin(p1, 81);
        SetCameraBehindPlayer(p1);
        ResetPlayerWeapons(p1);
        SetPlayerHealth(p1, 99.0);
        TogglePlayerControllable_H(p1, false);
        SetPlayerCompensatedPosEx(p2, 1387.8995,-35.3064,1001.8614,305.7826); // Crveni
        SetPlayerAttachedObject(p2, 0, 18952, 2, 0.1010, 0.0229, 0.0000, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000, 0xFFFFFFFF, 0xFFFFFFFF); // BoxingHelmet1 attached to the Head of daddyDOT
        SetPlayerSkin(p2, 80);
        SetCameraBehindPlayer(p2);
        ResetPlayerWeapons(p2);
        SetPlayerHealth(p2, 99.0);
        TogglePlayerControllable_H(p2, false);

        SendClientMessageF(p1, NARANDZASTA, "Box Event | {FFFF00}Pozvani ste na Box Event od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p2]);
        SendClientMessageF(p2, NARANDZASTA, "Box Event | {FFFF00}Pozvani ste na Box Event od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p1]);
        SendClientMessageF(playerid, NARANDZASTA, "Box Event | {FFFF00}Pozvali ste na Box Event igrace: %s[%i], %s[%i]", ime_rp[p1], p1, ime_rp[p2], p2);
        SendClientMessage(playerid, BELA, "* Koristite /box start da oznacite pocetak eventa.");
    }

    return 1;
}