#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define TURFWAR_DURATION    (600) // Trajanje u sekundama
#define TURFWAR_MIN_MEMBERS 3 // Min. broj clanova oba tima za pokretanje rata oko teritorije
#define TURF_CHAT_COLOR     (0x4286F4FF)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_TURFWAR_INFO
{
    bool:TW_ACTIVE,
    TW_TURFID, // ID turfa koji se osvaja
    TW_AREAID, // ID area-e iz koje "starter" ne sme da izadje
    TW_DEFENDER, // ID tima koji se brani, tj. tima koga se napada
    TW_STARTER, // Pokretac zauzimanja teritorije
    TW_AREA_TIME,
    TW_TIME_LEFT,

    TW_TIMER_TICK,
    TW_TIMER_AREA_ALERT,

    Text:TW_TEXTDRAW,
};




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new TurfWars[MAX_FACTIONS][E_TURFWAR_INFO],
    TURFWARS_lastTurfID[MAX_PLAYERS],
    gTurfInterferenceWarns[MAX_PLAYERS],

    g_aAbusableTurfs[] = {5, 10, 11, 12};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    // Kreiranje TD-a + inicijalizacija
    for__loop (new i = 0; i < MAX_FACTIONS; i++)
    {
        TurfWars[i][TW_TIMER_TICK] = 0;
        TurfWars[i][TW_TIMER_AREA_ALERT] = 0;

        /////
        TurfWars[i][TW_TEXTDRAW] = TextDrawCreate(502.500213, 214.059280, "_");
        TextDrawLetterSize(TurfWars[i][TW_TEXTDRAW], 0.240666, 1.181037);
        TextDrawTextSize(TurfWars[i][TW_TEXTDRAW], 588.000000, 0.000000);
        TextDrawAlignment(TurfWars[i][TW_TEXTDRAW], 1);
        TextDrawColor(TurfWars[i][TW_TEXTDRAW], -1);
        TextDrawUseBox(TurfWars[i][TW_TEXTDRAW], 1);
        TextDrawBoxColor(TurfWars[i][TW_TEXTDRAW], 150);
        TextDrawSetShadow(TurfWars[i][TW_TEXTDRAW], 0);
        TextDrawSetOutline(TurfWars[i][TW_TEXTDRAW], 1);
        TextDrawBackgroundColor(TurfWars[i][TW_TEXTDRAW], 255);
        TextDrawFont(TurfWars[i][TW_TEXTDRAW], 3);
        TextDrawSetProportional(TurfWars[i][TW_TEXTDRAW], 1);
        /////

        ResetTurfWars(i, false);
        SetTimerEx("turfWars_UpdateTimers", 1000, true, "i", i);
    }
    return 1;
}

hook OnPlayerConnect(playerid)
{
    TURFWARS_lastTurfID[playerid] = INVALID_TURF_ID;
    gTurfInterferenceWarns[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    new f_id = PI[playerid][p_org_id];

    if (f_id != -1 && TurfWars[f_id][TW_ACTIVE] && TurfWars[f_id][TW_STARTER] == playerid) 
    {
        // Starter je napustio igru, prekinuti zauzimanje teritorije (odbrana uspesna, zauzimanje neuspesno)
        new string[80];
        format(string, sizeof string, "~r~] ZAUZIMANJE NEUSPESNO ]~n~~y~%s ~w~JE NAPUSTIO IGRU", ime_rp[TurfWars[f_id][TW_STARTER]]);

        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == f_id) // Poruka za napadace
            {
                GameTextForPlayer(i, string, 5000, 3);
                SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {FF0000}nije uspelo. {FFFFFF}%s je napustio igru.", ime_rp[TurfWars[f_id][TW_STARTER]]);
            }
            else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER])
            {
                GameTextForPlayer(i, "~g~] ODBRANA USPESNA ]~n~~w~NAPADAC NAPUSTIO IGRU", 5000, 3);
                SendClientMessage(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Teritorija je {00FF00}uspesno odbranjena. {FFFFFF}Napadac je napustio igru.");

                if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_DEFENSE, 0);
                    UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                }
            }
        }

        // Upisivanje u log
        new logStr[61];
        format(logStr, sizeof logStr, "ODBRANA [%i] | %s je napustio igru", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]]);
        Log_Write(LOG_TURFS, logStr);

        TURF_LevelInc(TurfWars[f_id][TW_TURFID]); // Posto je odbrana teritorije uspesna, povecavamo level teritorije
        ResetTurfWars(f_id, true);
    }

    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) 
{
    new f_id = PI[playerid][p_org_id]; // Grupa kojoj pripada UBIJENI IGRAC
    new twActive = IsTurfWarActiveForPlayer(playerid);
    new bool:diedOnTurf = false; // Da li je poginuo na teritoriji koja mu je pod napadom/koju brani?
    new playerTurf = GetPlayerTurf(playerid);
    new turfWarId = -1;

    if (twActive)
    {
        // Potrebno je da odredimo da li se igrac nalazio na teritoriji koja mu je pod napadom ili na teritoriji koju on napada, kako ga NE bismo spawnali u bolnici (i naplatili za smrt)
        
        for__loop (new i = 0; i < MAX_FACTIONS; i++)
        {
            if (!TurfWars[i][TW_ACTIVE]) continue;

            if (i == f_id && TurfWars[i][TW_TURFID] == playerTurf)
            {
                // Igracev tim napada neku teritoriju i on je poginuo na *TOJ* teritoriji
                SetPVarInt(playerid, "pKilledByAdmin", 1); // da se ne bi spawnao ispred bolnice

                if (IsPlayerConnected(killerid)) 
                {
                    diedOnTurf = true;
                    turfWarId = i;
                }
                break;
            }

            if (i != f_id && TurfWars[i][TW_DEFENDER] == f_id && TurfWars[i][TW_TURFID] == playerTurf)
            {
                // Neko napada igracev tim, a on se nalazi na teritoriji koja mu je pod napadom
                SetPVarInt(playerid, "pKilledByAdmin", 1); // da se ne bi spawnao ispred bolnice

                if (IsPlayerConnected(killerid)) 
                {
                    diedOnTurf = true;
                    turfWarId = i;
                }
                break;
            }
        }


        if (diedOnTurf) // podrazumeva se da je killerid connectovan zbog ranijih provera
        {
            // Igrac je ubijen na teritoriji koju brani/napada
            if (PI[killerid][p_org_id] != turfWarId && PI[killerid][p_org_id] != TurfWars[turfWarId][TW_DEFENDER])
            {
                // Ubio ga je igrac koji ne pripada ni njegovom, ni protivnickom timu
                // Kazniti za mesanje u teritoriju AKKO je level 8+ i bez organizacije ILI u bilo kojoj organizaciji
                if (!IsNewPlayer(killerid) || PI[killerid][p_org_id] != -1)
                {
                    PunishTurfInterference(killerid);
                }
            }
        }


        if (TurfWars[f_id][TW_ACTIVE] && TurfWars[f_id][TW_STARTER] == playerid && IsPlayerConnected(killerid))
        {
            // Potrebno je proveriti da li je igrac protivnickog tima ubio "starter"-a
            // Dozvoljeno je samoubistvo i teamkill

            if (PI[killerid][p_org_id] != TurfWars[f_id][TW_DEFENDER]) return 1;

            // Sa Sigurnoscu znamo da je tim koji se brani ubio startera --> teritorija uspesno odbranjena
            new string[75];
            format(string, sizeof string, "~r~] ZAUZIMANJE NEUSPESNO ]~n~~y~%s ~w~JE UBIJEN", ime_rp[TurfWars[f_id][TW_STARTER]]);

            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == f_id) // Poruka za napadace
                {
                    GameTextForPlayer(i, string, 5000, 3);
                    SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                    SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {FF0000}nije uspelo. {FFFFFF}%s je ubijen.", ime_rp[TurfWars[f_id][TW_STARTER]]);
                }
                else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER])
                {
                    GameTextForPlayer(i, "~g~] ODBRANA USPESNA ]~n~~w~NAPADAC UBIJEN", 5000, 3);
                    SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Teritorija #%i je {00FF00}uspesno odbranjena. {FFFFFF}Napadac je ubijen.", TurfWars[f_id][TW_TURFID]);

                    if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                    {
                        PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_DEFENSE, 0);
                        UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                    }
                }
            }

            // Upisivanje u log
            new logStr[8];
            format(logStr, sizeof logStr, "ODBRANA [%i] | %s je ubijen (%s)", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]], ime_obicno[killerid]);
            Log_Write(LOG_TURFS, logStr);

            TURF_LevelInc(TurfWars[f_id][TW_TURFID]); // Posto je odbrana teritorije uspesna, povecavamo level teritorije
            ResetTurfWars(f_id, true);
        }
    }
    return 1;
}

hook OnPlayerSpawn(playerid) 
{
    gTurfInterferenceWarns[playerid] = 0;

    for__loop (new i = 0; i < MAX_FACTIONS; i++)
    {
        if (TurfWars[i][TW_ACTIVE])
        {
            ZoneFlashForPlayer(playerid, TURFS[TurfWars[i][TW_TURFID]][t_zone], HexToInt(FACTIONS[i][f_hex]) - 80);

            if (PI[playerid][p_org_id] == i && TurfWars[i][TW_STARTER] != playerid)
            {
                // Igrac pripada organizaciji koja napada neku teritoriju -> postaviti mu marker na startera
                SetPlayerMarkerForPlayer(playerid, TurfWars[i][TW_STARTER], PLAVA);
            }
        }
    }
    return 1;
}



hook OnPlayerLeaveDynArea(playerid, areaid) 
{
    new f_id = PI[playerid][p_org_id];

    if (f_id == -1 || !TurfWars[f_id][TW_ACTIVE] || TurfWars[f_id][TW_STARTER] != playerid || areaid != TurfWars[f_id][TW_AREAID]) return 1;
    
    // Pokretac zauzimanja je napustio teritoriju koja se zauzima
    SetPVarInt(playerid, "pTurfLeftCount", GetPVarInt(playerid, "pTurfLeftCount")+1);
    TurfWars[f_id][TW_TIMER_AREA_ALERT] = SetTimerEx("turfWars_AreaAlert", 1000, true, "i", f_id);
    TurfWars[f_id][TW_AREA_TIME] = 5;
    GameTextForPlayer(playerid, "~r~Napustili ste teritoriju!!!~n~~n~~w~Imate ~r~5 ~w~sekundi da se vratite!", 1000, 3);
    SendClientMessageF(playerid, TURF_CHAT_COLOR, "(teritorija) {FF0000}Napustili ste teritoriju! (%d/3)", GetPVarInt(playerid, "pTurfLeftCount"));

    if (GetPVarInt(playerid, "pTurfLeftCount") >= 3)
    {
        // Napustio teritoriju 3 puta

        new string[88];
        format(string, sizeof string, "~r~] ZAUZIMANJE NEUSPESNO ]~n~~y~%s ~w~JE NAPUSTIO TERITORIJU", ime_rp[TurfWars[f_id][TW_STARTER]]);
        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == f_id) // Poruka za napadace
            {
                GameTextForPlayer(i, string, 5000, 3);
                SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {FF0000}nije uspelo. {FFFFFF}%s je napustio teritoriju 3 puta.", ime_rp[TurfWars[f_id][TW_STARTER]]);
            }
            else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER])
            {
                GameTextForPlayer(i, "~g~] ODBRANA USPESNA ]~n~~w~NAPADAC NAPUSTIO TERITORIJU", 5000, 3);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Teritorija #%i je {00FF00}uspesno odbranjena. {FFFFFF}Napadac je napustio teritoriju 3 puta.", TurfWars[f_id][TW_TURFID]);

                if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_DEFENSE, 0);
                    UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                }
            }
        }

        // Upisivanje u log
        new logStr[66];
        format(logStr, sizeof logStr, "ODBRANA [%i] | %s je napustio teritoriju", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]]);
        Log_Write(LOG_TURFS, logStr);

        TURF_LevelInc(TurfWars[f_id][TW_TURFID]); // Posto je odbrana teritorije uspesna, povecavamo level teritorije
        ResetTurfWars(f_id, true);
    }
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid) 
{
    new f_id = PI[playerid][p_org_id];
    if (f_id == -1) return 1;


    // new turfAttacker = -1;
    if (!IsOnDuty(playerid))
    {
        for__loop (new i = 0; i < MAX_FACTIONS; i++)
        {
            if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_AREAID] == areaid)
            {
                // Detektovali smo da je igrac usao na teritoriju koja je trenutno pod napadom

                if (f_id == i || f_id == TurfWars[i][TW_DEFENDER])
                {
                    // Igrac je u timu koji napada/brani tu teritoriju na koju je usao
                    TURFWARS_lastTurfID[playerid] = TurfWars[i][TW_TURFID];

                    for__loop (new j = 0; j < sizeof g_aAbusableTurfs; j++)
                    {
                        if (TurfWars[i][TW_TURFID] == g_aAbusableTurfs[j])
                        {
                            // Turf 5 - dokovi - water abuse
                            SetTimerEx("CheckTurfWaterAbuse", 1000, false, "ii", playerid, 11);
                            break;
                        }
                    }
                }
                else
                {
                    // Igrac *NIJE* u timu koji ucestvuje u odbrani ove teritorije
                    // Otkriveno je mesanje u teritorije
                    gTurfInterferenceWarns[playerid] ++;
                    if (gTurfInterferenceWarns[playerid] >= 3)
                    {
                        PunishTurfInterference(playerid);
                    }
                    else
                    {
                        CheckTurfInterference(playerid, 11);
                    }
                }
                break;
            }
        }
    }
    

    if (TurfWars[f_id][TW_ACTIVE] && TurfWars[f_id][TW_STARTER] == playerid && areaid == TurfWars[f_id][TW_AREAID] && TurfWars[f_id][TW_TIMER_AREA_ALERT] != 0)
    {
        // Pokretac zauzimanja se vratio na teritoriju koja se zauzima, a koju je prethodno napustio
        KillTimer(TurfWars[f_id][TW_TIMER_AREA_ALERT]), TurfWars[f_id][TW_TIMER_AREA_ALERT] = 0;
    }
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    new f_id = PI[playerid][p_org_id];

    if (f_id != -1 && TurfWars[f_id][TW_ACTIVE] && playerid == TurfWars[f_id][TW_STARTER])
    {
        GetPlayerPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]);
        SetPlayerCompensatedPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]+0.3);

        GameTextForPlayer(playerid, "~r~NE MOZETE U VOZILO DOK ZAUZIMATE TERITORIJU!", 5000, 3);
        return ~1;
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    new f_id = PI[playerid][p_org_id];

    if (f_id != -1 && TurfWars[f_id][TW_ACTIVE] && playerid == TurfWars[f_id][TW_STARTER] && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER))
    {
        GetPlayerPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]);
        SetPlayerCompensatedPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]+1.5);

        GameTextForPlayer(playerid, "~r~NE MOZETE U VOZILO DOK ZAUZIMATE TERITORIJU!", 5000, 3);
        return ~1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_FIRE) // Levi klik
    {
        if (IsOnDuty(playerid) && GetPlayerWeapon(playerid) > 0)
        {
            new playerTurf = GetPlayerTurf(playerid);
            if (playerTurf != INVALID_TURF_ID)
            {
                // Admin/helper na duznosti + ima oruzje + stoji na nekoj teritoriji
                for__loop (new i = 0; i < MAX_FACTIONS; i++)
                {
                    if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_TURFID] == playerTurf)
                    {
                        // Neka mafija/banda napada bas tu teritoriju na kojoj igrac koristi oruzje
                        SetPlayerHealth(playerid, 0.0);
                        overwatch_poruka(playerid, "Duznost se mora iskljuciti pre odlaska na teritoriju.");
                        break;
                    }
                }
            }   
        }
    }
    return 1;
}

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if (hittype == BULLET_HIT_TYPE_PLAYER && GetPlayerTurf(playerid) != INVALID_TURF_ID && IsPlayerConnected(hitid))
    {
        for__loop (new i = 0; i < MAX_FACTIONS; i++)
        {
            if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_TURFID] == GetPlayerTurf(playerid))
            {
                if (PI[playerid][p_org_id] != i && PI[playerid][p_org_id] != TurfWars[i][TW_DEFENDER])
                {
                    // Igrac nije ni napadac ni branilac teritorije
                    if (PI[hitid][p_org_id] == i || PI[hitid][p_org_id] == TurfWars[i][TW_DEFENDER])
                    {
                        // Ali je pucao na nekoga ko napada/brani tu teritoriju
                        {
                            if (IsNewPlayer(playerid))
                            {
                                // Respawn ako je novi igrac
                                SetPlayerHealth(playerid, 0.0);
                                overwatch_poruka(playerid, "Ne smete se mesati u zauzimanje teritorija!");
                            }
                            else
                            {
                                // Kazna ako nije
                                PunishTurfInterference(playerid);
                            }
                        }
                    }
                }
                break;
            }
        }
    }
    return 1;
}

hook OnPlayerPause(playerid)
{
    new f_id = PI[playerid][p_org_id];

    if (f_id != -1 && TurfWars[f_id][TW_ACTIVE] && playerid == TurfWars[f_id][TW_STARTER])
    {
        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == f_id) // Poruka za napadace
            {
                GameTextForPlayer(i, "~r~] ZAUZIMANJE NEUSPESNO ]~n~~w~NAPADAC NAPUSTIO IGRU (ALT-TAB/ESC)", 5000, 3);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {FF0000}nije uspelo. {FFFFFF}%s je napustio igru (alt-tab/esc).", ime_rp[TurfWars[f_id][TW_STARTER]]);
            }
            else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER])
            {
                GameTextForPlayer(i, "~g~] ODBRANA USPESNA ]~n~~w~NAPADAC NAPUSTIO IGRU", 5000, 3);
                SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                SendClientMessage(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Teritorija je {00FF00}uspesno odbranjena. {FFFFFF}Napadac je napustio igru (alt-tab/esc).");

                if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_DEFENSE, 0);
                    UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                }
            }
        }

        // Upisivanje u log
        new logStr[75];
        format(logStr, sizeof logStr, "ODBRANA [%i] | %s je napustio igru (alt-tab/esc)", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]]);
        Log_Write(LOG_TURFS, logStr);
        
        TURF_LevelInc(TurfWars[f_id][TW_TURFID]); // Posto je odbrana teritorije uspesna, povecavamo level teritorije
        ResetTurfWars(f_id, true);
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward CheckTurfInterference(playerid, timeCounter);
public CheckTurfInterference(playerid, timeCounter)
{
    if (!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid) || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) return 1;

    if (IsPlayerInRangeOfPoint(playerid, 20.0, 1067.0, -1432.9, 13.0))
    {
        // Fix za teritoriju 9 (preliva se na ulicu)
        gTurfInterferenceWarns[playerid] = 0;
        return 1;
    }

    timeCounter --;
    new sGametext[84];
    format(sGametext, sizeof sGametext, "~r~Usli ste na tudju teritoriju!!!~n~~n~~w~Imate ~r~%d ~w~sekundi da je napustite!", timeCounter);
    GameTextForPlayer(playerid, sGametext, 1000, 3);

    if (timeCounter <= 0)
    {
        PunishTurfInterference(playerid);
    }
    else
    {
        if (GetPlayerTurf(playerid) != INVALID_TURF_ID)
        {
            SetTimerEx("CheckTurfInterference", 1000, false, "ii", playerid, timeCounter);
        }
    }
    return 1;
}

forward CheckTurfWaterAbuse(playerid, timeCounter);
public CheckTurfWaterAbuse(playerid, timeCounter)
{
    if (!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid)) return 1;

    new turf = GetPlayerTurf(playerid);
    if (turf != INVALID_TURF_ID)
    {
        for__loop (new j = 0; j < sizeof g_aAbusableTurfs; j++)
        {
            if (turf == g_aAbusableTurfs[j]) return 1;
        }
    }

    new Float:x, Float:y, Float:z,
        animlib[32], animname[32];
    GetPlayerPos(playerid, x, y, z);
    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,sizeof animlib,animname,sizeof animname);

    if (-5.0 <= z <= 0.0 && !strcmp(animlib, "SWIM", true))
    {
        timeCounter --;
        new sGametext[84];
        format(sGametext, sizeof sGametext, "~r~Usli ste u vodu!!!~n~~n~~w~Imate ~r~%d ~w~sekundi da se vratite!", timeCounter);
        GameTextForPlayer(playerid, sGametext, 1000, 3);

        if (timeCounter <= 0)
        {
            PunishTurfWaterAbuse(playerid);
        }
        else
        {
            if (GetPlayerTurf(playerid) != INVALID_TURF_ID)
            {
                SetTimerEx("CheckTurfWaterAbuse", 1000, false, "ii", playerid, timeCounter);
            }
        }
    }
    return 1;
}

PunishTurfInterference(playerid)
{
    gTurfInterferenceWarns[playerid] = 0;
    if (IsOnDuty(playerid)) return 1;

    PunishPlayer(playerid, INVALID_PLAYER_ID, 30, 0, 1, true, "Mesanje u teritoriju");
    SetTimerEx("ShowRulesDialog_TURF_ROB", 30000, false, "ii", playerid, cinc[playerid]);
    return 1;
}

PunishTurfWaterAbuse(playerid)
{
    if (IsOnDuty(playerid)) return 1;

    PunishPlayer(playerid, INVALID_PLAYER_ID, 30, 0, 1, false, "Teritorija - water abuse");
    SetTimerEx("ShowRulesDialog_TURF_ROB", 30000, false, "ii", playerid, cinc[playerid]);
    return 1;
}

stock UpdatePlayerTurfParticipation(playerid, turfid)
{
    new query[127];
    format(query, sizeof query, "INSERT INTO turf_mvp VALUES ('%s', %i, 1) ON DUPLICATE KEY UPDATE participations = participations + 1", ime_obicno[playerid], turfid);
    mysql_tquery(SQL, query);
}

forward turfWars_Tick(f_id);
public turfWars_Tick(f_id) 
{
    TurfWars[f_id][TW_TIME_LEFT]--;

    if (TurfWars[f_id][TW_TIME_LEFT] == -1) 
    {
        new string[175], Iterator:iSkillReducing<MAX_PLAYERS>;
        format(string, sizeof string, "~g~] ZAUZIMANJE USPESNO ]~n~~w~ODBRANILI STE ~y~%s", ime_rp[TurfWars[f_id][TW_STARTER]]);
        Iter_Clear(iSkillReducing);

        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == f_id)
            {
                // Poruka za clanove napadaca
                GameTextForPlayer(i, string, 5000, 3);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {00FF00}je uspesno. {FFFFFF}Odbranili ste %s.", ime_rp[TurfWars[f_id][TW_STARTER]]);
                SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_TAKEOVER, 0);
                    UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                }
            }
            else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER] && !IsLawFaction(PI[i][p_org_id]))
            {
                GameTextForPlayer(i, "~r~] ODBRANA NEUSPESNA ]~n~~w~VREME JE ISTEKLO", 5000, 3);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Odbrana teritorije #%i {FF0000}nije uspesna. {FFFFFF}Vreme je isteklo.", TurfWars[f_id][TW_TURFID]);

                Iter_Add(iSkillReducing, i);
            }
        }

        // Oduzimamo bodove ako je online 3+ clana gubitnickog tima
        if (Iter_Count(iSkillReducing) >= 3)
        {
            foreach (new i : iSkillReducing)
            {
                PlayerUpdateCriminalSkill(i, -2, SKILL_TURF_DEFENSE_FAIL, 0);
            }
        }
        Iter_Clear(iSkillReducing);

        // Promena vlasnika i boje teritorije
        TURFS[ TurfWars[f_id][TW_TURFID] ][t_fid] = f_id;
        TURFS[ TurfWars[f_id][TW_TURFID] ][t_level] = 1;
        new turf = TurfWars[f_id][TW_TURFID],
            color = HexToInt(FACTIONS[ TURFS[turf][t_fid] ][f_hex]) - 80
        ;
        foreach (new i : Player) 
        {
            ShowZoneForPlayer(i, TURFS[turf][t_zone], color);
        }

        // Upisivanje u log
        new logStr[85], tag[MAX_FTAG_LENGTH];
        GetFactionTag(f_id, tag, sizeof tag);
        format(logStr, sizeof logStr, "ZAUZIMANJE [%i] | %s (%s) | Isteklo vreme za odbranu", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]], tag);
        Log_Write(LOG_TURFS, logStr);

        // Upit ka bazi
        format(mysql_upit, sizeof mysql_upit, "UPDATE turfs SET fid = %d, level = 1 WHERE id = %d", TURFS[turf][t_fid], turf);
        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_TURF_UPDATE);


        ResetTurfWars(f_id, true);
    }
    return 1;
}

forward turfWars_UpdateTimers(fid);
public turfWars_UpdateTimers(fid)
{
    new timerStr[165], bool:twActive = false;
    format(timerStr, 2, "_");

    if (TurfWars[fid][TW_ACTIVE])
    {
        twActive = true;
        format(timerStr, 35, "%s~N~  ~G~Turf %02i   ~W~%s", timerStr, TurfWars[fid][TW_TURFID], konvertuj_vreme(TurfWars[fid][TW_TIME_LEFT]));
    }
    for (new i = 0; i < MAX_FACTIONS; i++)
    {
        if (i == fid) continue;
        if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_DEFENDER] == fid)
        {
            twActive = true;

            format(timerStr, sizeof timerStr, "%s~N~  ~R~Turf %02i   ~W~%s", timerStr, TurfWars[i][TW_TURFID], konvertuj_vreme(TurfWars[i][TW_TIME_LEFT]));
        }
    }

    format(timerStr, sizeof timerStr, "%s~N~_", timerStr);
    TextDrawSetString(TurfWars[fid][TW_TEXTDRAW], timerStr);

    if (!twActive)
    {
        TextDrawHideForAll(TurfWars[fid][TW_TEXTDRAW]);
    }
    return 1;
}

forward turfWars_AreaAlert(f_id);
public turfWars_AreaAlert(f_id)
{
    TurfWars[f_id][TW_AREA_TIME]--;

    if (TurfWars[f_id][TW_AREA_TIME] == -1) 
    {
        // Pokretac se nije vratio u zonu; zauzimanje neuspesno
        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == f_id) // Poruka za napadace
            {
                GameTextForPlayer(i, "~r~] ZAUZIMANJE NEUSPESNO ]~n~~w~NAPADAC NAPUSTIO ZONU", 5000, 3);
                SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PI[TurfWars[f_id][TW_STARTER]][p_boja_imena]);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Zauzimanje teritorije {FF0000}nije uspelo. {FFFFFF}%s je napustio zonu.", ime_rp[TurfWars[f_id][TW_STARTER]]);
            }
            else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER])
            {
                GameTextForPlayer(i, "~g~] ODBRANA USPESNA ]~n~~w~NAPADAC NAPUSTIO ZONU", 5000, 3);
                SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Teritorija #%i je {00FF00}uspesno odbranjena. {FFFFFF}Napadac je napustio zonu.", TurfWars[f_id][TW_TURFID]);

                if (TURFWARS_lastTurfID[i] == TurfWars[f_id][TW_TURFID])
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_TURF_DEFENSE, 0);
                    UpdatePlayerTurfParticipation(i, TurfWars[f_id][TW_TURFID]);
                }
            }
        }

        // Oduzimanje bodova samo za napadaca
        PlayerUpdateCriminalSkill(TurfWars[f_id][TW_STARTER], -3, SKILL_TURF_TAKEOVER_FAIL, 0);

        // Upisivanje u log
        new logStr[70];
        format(logStr, sizeof logStr, "ODBRANA [%i] | Napadac: %s je napustio zonu", TurfWars[f_id][TW_TURFID], ime_obicno[TurfWars[f_id][TW_STARTER]]);
        Log_Write(LOG_TURFS, logStr);
        
        TURF_LevelInc(TurfWars[f_id][TW_TURFID]); // Posto je odbrana teritorije uspesna, povecavamo level teritorije
        ResetTurfWars(f_id, true);
    }
    else 
    {
        new str[77];
        format(str, sizeof str, "~r~Napustili ste teritoriju!!!~n~~n~~w~Imate ~r~%d ~w~sekundi da se vratite!", TurfWars[f_id][TW_AREA_TIME]);
        GameTextForPlayer(TurfWars[f_id][TW_STARTER], str, 1000, 3);
    }
    return 1;
}

nl_public ResetTurfWars(f_id, bool:updateLabel) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("ResetTurfWars");
    }

    if (updateLabel && TurfWars[f_id][TW_TURFID] != -1) 
    {
        new turf = TurfWars[f_id][TW_TURFID];
        ZoneStopFlashForAll(TURFS[turf][t_zone]);
        TURFS[turf][t_cooldown] = gettime() + 1800;

        // Label update
        UpdateTurfLabel(turf);
    }

    //FACTIONS_SetTurfCooldown(f_id);

    TurfWars[f_id][TW_ACTIVE] = false;

    foreach( new i : Player) {
        if(GetPlayerFactionID(i) == f_id)
            TurfState[i] = false;
    }

    TurfWars[f_id][TW_TURFID] = -1;
    TurfWars[f_id][TW_AREAID] = -1;
    TurfWars[f_id][TW_DEFENDER] = -1;
    TurfWars[f_id][TW_STARTER] = INVALID_PLAYER_ID;
    TurfWars[f_id][TW_AREA_TIME] = 9999;
    KillTimer(TurfWars[f_id][TW_TIMER_TICK]), TurfWars[f_id][TW_TIMER_TICK] = 0;
    KillTimer(TurfWars[f_id][TW_TIMER_AREA_ALERT]), TurfWars[f_id][TW_TIMER_AREA_ALERT] = 0;
    return 1;
}

stock IsTurfWarActiveForPlayer(playerid) 
{
	new f_id = PI[playerid][p_org_id];
	if (f_id == -1) return 0;
	else
	{
		if (TurfWars[f_id][TW_ACTIVE])
		{
			return 1; // njegova m/b napada teritoriju
		}
		else
		{
			for__loop (new i = 0; i < MAX_FACTIONS; i++)
			{
				if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_DEFENDER] == f_id)
				{
					return 2; // njegova m/b brani teritoriju
				}
			}
		}
	}
    return 0;
}

IsPlayerOnActiveTurf(playerid)
{
    new turf = GetPlayerTurf(playerid);
    if (turf != INVALID_TURF_ID)
    {
        for__loop (new i = 0; i < MAX_FACTIONS; i++)
        {
            if (TurfWars[i][TW_ACTIVE] && turf == TurfWars[i][TW_TURFID])
            {
                return 1;
            }
        }
    }
    return 0;
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
CMD:zauzmi(playerid, const params[]) 
{
    new 
        f_id = PI[playerid][p_org_id],
        turf = GetPlayerTurf(playerid);

    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo clanovi mafija/bandi mogu da zauzimaju teritorije!");

    if (turf == INVALID_TURF_ID)
        return ErrorMsg(playerid, "Ne mozete koristiti tu komandu na ovom mestu.");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, TURFS[turf][t_interact][POS_X], TURFS[turf][t_interact][POS_Y], TURFS[turf][t_interact][POS_Z]))
        return ErrorMsg(playerid, "Morate stajati na pickupu da biste pokrenuli zauzimanje.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Ne mozete pokrenuti zauzimanje teritorije dok ste u vozilu.");

    // if (IsRaceActive())
    //     return ErrorMsg(playerid, "Ne mozete zauzimati teritoriju dok je trka u toku.");

    if (TURFS[turf][t_fid] == f_id)
        return ErrorMsg(playerid, "Ova teritorija je u vlasnistvu Vase mafije/bande.");

    // Da li je ova teritorija vec pod napadom?
    for__loop (new i = 0; i < MAX_FACTIONS; i++)
    {
        if (TurfWars[i][TW_ACTIVE] && TurfWars[i][TW_TURFID] == turf)
        {
            GameTextForPlayer(playerid, "~r~Ne mozete pokrenuti zauzimanje teritorije!", 4000, 3);
            return ErrorMsg(playerid, "Ova teritorija je vec pod napadom.");
        }
    }

    // Da li ovaj tim vec napada nesto?
    if (TurfWars[f_id][TW_ACTIVE])
    {
        SetPlayerArmedWeapon(playerid, 0);
        GameTextForPlayer(playerid, "~r~Ne mozete pokrenuti zauzimanje teritorije!", 4000, 3);
        return ErrorMsg(playerid, "Vas tim vec napada neku drugu teritoriju.");
    }

    if (TURFS[turf][t_cooldown] > gettime())
        return ErrorMsg(playerid, "Ova zona je nedavno bila pod napadom. Pokusajte ponovo za %s.", konvertuj_vreme(TURFS[turf][t_cooldown] - gettime()));

    if (IsTeamInWar(TURFS[turf][t_fid]))
        return ErrorMsg(playerid, "Tim koji drzi ovu teritoriju je u waru, ne mozete pokrenuti zauzimanje dok se war ne zavrsi.");

    if (GetPlayerWeapon(playerid) <= 0)
        return ErrorMsg(playerid, "Morate drzati oruzje u ruci da biste pokrenuli zauzimanje teritorije.");  


    ResetTurfWars(f_id, true);


    // Odredjivanje timova
    TurfWars[f_id][TW_DEFENDER] = TURFS[turf][t_fid];


    // Brojanje igraca u oba tima
    new attackingMembers = 0, 
        defendingMembers = 0,
        defendingMembersNotAFK = 0
    ;
    foreach (new i : Player) 
    {
        if (PI[i][p_org_id] == f_id && GetPlayerTurf(i) == turf)
            attackingMembers ++;

        else if (PI[i][p_org_id] == TURFS[turf][t_fid])
        {
            defendingMembers++;
            if (!IsPlayerAFK(i))
            {
                defendingMembersNotAFK ++;
            }
        }
    }


    // Provera da li ima dovoljno igraca u oba tima
    if(!testingdaddy)
    {
        if (attackingMembers < TURFWAR_MIN_MEMBERS)
        {
            SetPlayerArmedWeapon(playerid, 0);
            GameTextForPlayer(playerid, "~r~Ne mozete pokrenuti zauzimanje teritorije!", 4000, 3);
            ErrorMsg(playerid, "Potrebno je minimum "#TURFWAR_MIN_MEMBERS " igraca na ovoj teritoriji.");

            ResetTurfWars(f_id, true);
            return 1;
        }

        if (TURFS[turf][t_level] >= 3 && defendingMembers < TURFWAR_MIN_MEMBERS)
        {
            SetPlayerArmedWeapon(playerid, 0);
            GameTextForPlayer(playerid, "~r~Ne mozete pokrenuti zauzimanje teritorije!", 4000, 3);
            ErrorMsg(playerid, "Potrebno je minimum "#TURFWAR_MIN_MEMBERS " online igraca iz drugog tima jer je teritorija nivo 3+.");

            ResetTurfWars(f_id, true);
            return 1;
        }
    }


    new h,m,s;
    gettime(h,m,s);
    if (h > 0 && h < 9)
    {
        if (defendingMembersNotAFK < TURFWAR_MIN_MEMBERS)
            return ErrorMsg(playerid, "Da biste pokrenuli zauzimanje posle 01h ujutru, mora biti "#TURFWAR_MIN_MEMBERS" igraca online iz drugog tima.");
    }


    // Inicijalizacija
    TurfWars[f_id][TW_ACTIVE] = true;
    TurfWars[f_id][TW_TURFID] = turf;
    TurfWars[f_id][TW_AREAID] = TURFS[turf][t_areaid];
    TurfWars[f_id][TW_STARTER] = playerid;
    TurfWars[f_id][TW_TIME_LEFT] = TURFWAR_DURATION;
    TurfWars[f_id][TW_TIMER_TICK] = SetTimerEx("turfWars_Tick", 1000, true, "i", f_id);
    SetPVarInt(playerid, "pTurfLeftCount", 0);

    // Slanje poruka igracima ciji timovi ucestvuju
    new str_attacker[84], str_defender[84], rgb[7], tag[8], tag2[8];
    format(str_attacker, sizeof str_attacker, "~y~VAS TIM NAPADA TERITORIJU %d~n~~w~Zastitite ~r~%s", TurfWars[f_id][TW_TURFID], ime_rp[playerid]);
    format(str_defender, sizeof str_defender, "~r~TERITORIJA ~w~%d ~r~JE POD NAPADOM~n~~w~Idite na oznaceno mesto", TurfWars[f_id][TW_TURFID]);
    GetFactionRGB(TURFS[turf][t_fid], rgb, sizeof rgb);
    GetFactionTag(TURFS[turf][t_fid], tag, sizeof tag);
    foreach (new i : Player) // Slanje poruke napadacima i braniocima + markiranje prisutnih igraca
    {
        if (PI[i][p_org_id] == f_id)
        {
            GameTextForPlayer(i, str_attacker, 7500, 3);
            SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Vas tim {00FF00}napada {FFFFFF}teritoriju (%d) u vlasnistvu {%s}%s.", TurfWars[f_id][TW_TURFID], rgb, tag);
            TurfState[i] = true;
            // Postavlja marker na startera, koji je vidljiv samo saigracima
            SetPlayerMarkerForPlayer(i, TurfWars[f_id][TW_STARTER], PLAVA);
            TextDrawShowForPlayer(i, TurfWars[f_id][TW_TEXTDRAW]);
        }
        else if (PI[i][p_org_id] == TurfWars[f_id][TW_DEFENDER] && !IsLawFaction(PI[i][p_org_id]))
        {
            GameTextForPlayer(i, str_defender, 7500, 3);
            SendClientMessageF(i, TURF_CHAT_COLOR, "(teritorija) {FFFFFF}Vasa teritorija (%d) je {FF0000}pod napadom!", TurfWars[f_id][TW_TURFID]);
            TurfState[i] = true;
            TextDrawShowForPlayer(i, TurfWars[f_id][TW_TEXTDRAW]);
        }

        if (IsPlayerInDynamicArea(i, TurfWars[f_id][TW_AREAID]))
        {
            TURFWARS_lastTurfID[i] = TurfWars[f_id][TW_TURFID];
        }
    }

    ZoneFlashForAll(TURFS[turf][t_zone], HexToInt(FACTIONS[f_id][f_hex]) - 80);

    // Obavestenje za admine
    GetFactionTag(PI[playerid][p_org_id], tag2, sizeof tag2);

    foreach (new i : Player)
    {
        if (IsAdmin(i, 5))
        {   
            SendClientMessageF(i, TURF_CHAT_COLOR, "* TURF ATTACK (#%i) | %s napada %s | Napadac: %s[%i] | /spec, /turftp", TurfWars[f_id][TW_TURFID], tag2, tag, ime_rp[playerid], playerid);
        }
        else if (IsAdmin(i, 1))
        {
            SendClientMessageF(i, TURF_CHAT_COLOR, "* TURF ATTACK (#%i) | %s napada %s | /spec, /turftp", TurfWars[f_id][TW_TURFID], tag2, tag, playerid);
        }
    }

    // Upisivanje u log
    new logStr[85];
    format(logStr, sizeof logStr, "NAPAD [%i] | %s napada %s | Napadac: %s", TurfWars[f_id][TW_TURFID], tag2, tag, ime_obicno[playerid]);
    Log_Write(LOG_TURFS, logStr);
    return 1;
}

CMD:turfinfo(playerid, const params[])
{
    new sDialog[25 + MAX_FACTIONS*50], bool:active=false;
    format(sDialog, 25, "Ucesnici\tVreme\tNapadac");
    for__loop (new i = 0; i < MAX_FACTIONS; i++)
    {
        if (TurfWars[i][TW_ACTIVE])
        {
            active=true;
            new sAttacker[MAX_PLAYER_NAME+5], sTag1[MAX_FTAG_LENGTH], sTag2[MAX_FTAG_LENGTH];
            if (IsAdmin(playerid, 6) && IsPlayerConnected(TurfWars[i][TW_STARTER])) 
            {
                format(sAttacker, sizeof sAttacker, "%s[%i]", ime_rp[TurfWars[i][TW_STARTER]], TurfWars[i][TW_STARTER]);
            }
            else
            {
                format(sAttacker, sizeof sAttacker, "-");
            }
            GetFactionTag(i, sTag1, sizeof sTag1);
            GetFactionTag(TurfWars[i][TW_DEFENDER], sTag2, sizeof sTag2);
            format(sDialog, sizeof sDialog, "%s\n%s vs %s\t%s\t%s", sDialog, sTag1, sTag2, konvertuj_vreme(TurfWars[i][TW_TIME_LEFT]), sAttacker);
        }
    }

    if (!active)
        return ErrorMsg(playerid, "Trenutno se nijedna teritorija ne zauzima.");

    SPD(playerid, "no_return", DIALOG_STYLE_TABLIST_HEADERS, "Turf Info", sDialog, "U redu", "");
    return 1;
}

CMD:turfhelp(playerid, const params[])
{
    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Turf Help", "\
        Zone imaju svoje nivoe/levele:\n\
        - Svaki put kada odbranite zonu, raste joj nivo za 1.\n\
        - Kad izgubite zonu nivo se resetuje na 1.\n\
        - Kako raste nivo zone, to vise para/oruzja dobijate od te zone.\n\n\
        \
        Sve dok je zona nivoa <3, odnos potreban da se pokrene zauzimanje takve zone takva zona je 3:0,\n\
        odnosno 3 igraca iz vaseg tima mora biti prisutno na zoni, dok niko od protivnika ne mora da bude online.\n\n\
        \
        Ukoliko je zona do nivo 3+, tada je odnos potreban da se pokrene zauzimanje 3:3,\n\
        odnosno 3 igraca iz vaseg tima mora biti prisutno na zoni, dok 3 igraca protivnika mora biti online.\n\n\
        \
        Sto je veci nivo zone, takvu zonu je teze osvojiti jer se nece moci pokrenuti zauzimanje ako vas nema 3:3.\n\n\
        \
        MVP zone je igrac koji je najvise puta ucestovao u zauzimanju/odbrani zone.", "U redu", "");

    return 1;
}