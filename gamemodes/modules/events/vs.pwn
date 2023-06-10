#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    bool:VS_Active,
    VS_P1,
    VS_P2
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    VS_Active = false;
    VS_P1 = VS_P2 = INVALID_PLAYER_ID;
    return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (VS_P1 == playerid)
    {
        VS_P1 = INVALID_PLAYER_ID;
        StaffMsg(NARANDZASTA, "VS Event | {FFFF00}Igrac %s je napustio igru, event mora biti restartovan.", ime_rp[playerid]);
    }
    else if (VS_P2 == playerid)
    {
        VS_P2 = INVALID_PLAYER_ID;
        StaffMsg(NARANDZASTA, "VS Event | {FFFF00}Igrac %s je napustio igru, event mora biti restartovan.", ime_rp[playerid]);
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (VS_Active && ((VS_P1 == playerid && VS_P2 == killerid) || (VS_P1 == killerid && VS_P2 == playerid)))
    {
        StaffMsg(PLAVA, "VS Event | Pobednik: {0068B3}%s", ime_rp[killerid]);

        VS_P1 = INVALID_PLAYER_ID;
        VS_P2 = INVALID_PLAYER_ID;
        VS_Active = false;

        ResetPlayerWeapons(killerid);
        SetPlayerHealth(killerid, 99.0);

        SetPVarInt(playerid, "pIgnoreDeathFine", 1);
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
IsPlayerInVSEvent(playerid)
{
    if (VS_P1 == playerid && VS_P2 == playerid)
    {
        return 1;
    }
    return 0;
}

forward VS_Countdown(count);
public VS_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[7]);
            PlayerPlaySound(VS_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(VS_P2, tdEventCountdown[7]);
            PlayerPlaySound(VS_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 2:
        {
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[8]);
            PlayerPlaySound(VS_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(VS_P2, tdEventCountdown[8]);
            PlayerPlaySound(VS_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 3:
        {
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[9]);
            PlayerPlaySound(VS_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(VS_P2, tdEventCountdown[9]);
            PlayerPlaySound(VS_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 4:
        {
            TextDrawBoxColor(tdEventCountdown[7], 13369599);
            TextDrawBoxColor(tdEventCountdown[8], 13369599);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);

            // P1
            TextDrawHideForPlayer(VS_P1, tdEventCountdown[7]);
            TextDrawHideForPlayer(VS_P1, tdEventCountdown[8]);
            TextDrawHideForPlayer(VS_P1, tdEventCountdown[9]);
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[7]);
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[8]);
            TextDrawShowForPlayer(VS_P1, tdEventCountdown[9]);
            PlayerPlaySound(VS_P1, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(VS_P1, true); 

            // P2
            TextDrawHideForPlayer(VS_P2, tdEventCountdown[7]);
            TextDrawHideForPlayer(VS_P2, tdEventCountdown[8]);
            TextDrawHideForPlayer(VS_P2, tdEventCountdown[9]);
            TextDrawShowForPlayer(VS_P2, tdEventCountdown[7]);
            TextDrawShowForPlayer(VS_P2, tdEventCountdown[8]);
            TextDrawShowForPlayer(VS_P2, tdEventCountdown[9]);
            PlayerPlaySound(VS_P2, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(VS_P2, true);
        }
        case 5:
        {
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(VS_P1, tdEventCountdown[t]);
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(VS_P2, tdEventCountdown[t]);

            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("VS_Countdown", 1000, false, "i", count+1);
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
flags:vs(FLAG_HELPER_1)
CMD:vs(playerid, const params[])
{
    if (isnull(params) || !strcmp(params, "help", false))
    {
        Koristite(playerid, "vs [Igrac 1] [Igrac 2] - za prijavu igraca na event");
        Koristite(playerid, "vs start - za startovanje eventa nakon prijave igraca");
        Koristite(playerid, "vs reset - za resetovanje eventa");
        return 1;
    }

    if (!strcmp(params, "start", false))
    {
        if (VS_Active)
            return ErrorMsg(playerid, "VS Event je vec pokrenut.");

        if (VS_P1 == INVALID_PLAYER_ID || VS_P2 == INVALID_PLAYER_ID)
            return ErrorMsg(playerid, "Nisu prijavljena oba igraca na event.");

        VS_Active = true;

        TogglePlayerControllable_H(VS_P1, false);
        TogglePlayerControllable_H(VS_P2, false);

        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(VS_P1, tdEventCountdown[j]);
        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(VS_P2, tdEventCountdown[j]);

        SetTimerEx("VS_Countdown", 1000, false, "i", 1);
        StaffMsg(NARANDZASTA, "VS Event | {FFFFFF}%s {FFFF00}je pokrenuo VS Event | %s - %s.", ime_rp[playerid], ime_rp[VS_P1], ime_rp[VS_P2]);
    }
    else if (!strcmp(params, "reset", false))
    {
        VS_Active = false;
        VS_P1 = VS_P2 = INVALID_PLAYER_ID;

        StaffMsg(NARANDZASTA, "VS Event | {FFFFFF}%s {FFFF00}je resetovao VS Event.", ime_rp[playerid]);
    }
    else 
    {
        new p1, p2;
        if (sscanf(params, "uu", p1, p2))
            return Koristite(playerid, "vs help - da vidite dostupne komande.");

        if (p1 == p2)
            return ErrorMsg(playerid, "Nije moguce uneti istog igraca u oba polja.");

        if (VS_P1 != INVALID_PLAYER_ID || VS_P2 != INVALID_PLAYER_ID)
            return ErrorMsg(playerid, "Vec ima prijavljenih igraca. Koristite \"/vs reset\" da resetujete event.");

        if (!IsPlayerConnected(p1))
            return ErrorMsg(playerid, "Igrac 1 trenutno nije na serveru.");

        if (!IsPlayerConnected(p2))
            return ErrorMsg(playerid, "Igrac 2 trenutno nije na serveru.");

        if (VS_Active)
            return ErrorMsg(playerid, "VS Event je vec aktivan. Koristite \"/vs reset\" da ga resetujete.");

        if (IsPlayerOnLawDuty(p1))
        {
            ToggleLawDuty(p1, false);
        }

        if (IsPlayerOnLawDuty(p2))
        {
            ToggleLawDuty(p2, false);
        }

        VS_P1 = p1;
        VS_P2 = p2;

        // Postavlja igrace na start
        SetPlayerCompensatedPosEx(p1, -214.3129,2601.7500,62.7031,90.0);
        SetCameraBehindPlayer(p1);
        GivePlayerWeapon(p1, WEAPON_DEAGLE, 30);
        SetPlayerHealth(p1, 99.0);
        TogglePlayerControllable_H(p1, false);
        SetPlayerCompensatedPosEx(p2, -240.0181,2601.7500,62.7031,270.0);
        SetCameraBehindPlayer(p2);
        GivePlayerWeapon(p2, WEAPON_DEAGLE, 30);
        SetPlayerHealth(p2, 99.0);
        TogglePlayerControllable_H(p2, false);

        SendClientMessageF(p1, NARANDZASTA, "VS Event | {FFFF00}Pozvani ste na VS Event od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p2]);
        SendClientMessageF(p2, NARANDZASTA, "VS Event | {FFFF00}Pozvani ste na VS Event od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p1]);
        SendClientMessageF(playerid, NARANDZASTA, "VS Event | {FFFF00}Pozvali ste na VS Event igrace: %s[%i], %s[%i]", ime_rp[p1], p1, ime_rp[p2], p2);
        SendClientMessage(playerid, BELA, "* Koristite /vs start da oznacite pocetak eventa.");
    }

    return 1;
}