#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_HOSTNAMES 3




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    hostname[MAX_HOSTNAMES][64], 
    serverPassword[33],
    hostnameCycle,
    gServerInitTime,
    tajmer:hostnameChanger,
    bool:happyHours, 
    bool:snowMap,
    bool:gDebugFunctions,
    bool:gDebugCallbacks,
    bool:gDebugDialogs,
    bool:gDebugLoops,
    serverPlayersRecord,
    bool:serverRestartScheduled,
    bool:gLuckyWheel,
    bool:gAutoRacing,
    gAutoRacingInterval,
    tmrLuckyWheel
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    print("Initializing server variables..");
    happyHours = false;
    snowMap = false;
    serverRestartScheduled = false;
    gLuckyWheel = false;
    gAutoRacing = false;
    gAutoRacingInterval = 20;
    tmrLuckyWheel = 0;
    gServerInitTime = gettime();

    SetServerPlayersRecord(999);

    mysql_tquery(SQL, "SELECT * FROM `server_info` WHERE (field) IN ('hostname_1', 'hostname_2', 'hostname_3', 'password', 'snow', 'debug_functions', 'debug_callbacks', 'debug_dialogs', 'debug_loops', 'players_record') GROUP BY field", "MYSQL_SERVER_LoadConfig");
    return true;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
IsAutoRacingEnabled()
{
    return gAutoRacing;
}

GetAutoRacingInterval()
{
    if (gAutoRacingInterval < 20)
        gAutoRacingInterval = 20;

    return gAutoRacingInterval;
}

forward LuckyWheel();
public LuckyWheel()
{
    new playerid = INVALID_PLAYER_ID, stopper = 0;
    while__loop (!IsPlayerLoggedIn(playerid))
    {
        playerid = Iter_Random(Player);

        if (++stopper > 20) break;
    }

    if (IsPlayerLoggedIn(playerid))
    {
        new sPrize[24];
        LOTTERY_GetLuckyWheelPrize(playerid, sPrize, sizeof sPrize);

        new sMsg[145];
        format(sMsg, sizeof sMsg, "TOMBOLA | Igrac {FFFF00}%s[%i] "#NAVY_BLUE_13" je osvojio nagradu: {FFFF00}%s", ime_rp[playerid], playerid, sPrize);
        SendClientMessageToAll(COLOR_NAVY_BLUE_13, sMsg);
    }
    return 1;
}

LOTTERY_GetLuckyWheelPrize(playerid, szDest[], szLen)
{
    new bool:expChanged = false;
    switch (random(7))
    {
        case 0: // $10.000
        {
            PlayerMoneyAdd(playerid, 10000);

            format(szDest, szLen, "$10.000");
        }

        case 1: // 1 exp
        {
            PI[playerid][p_iskustvo] ++;
            expChanged = true;

            format(szDest, szLen, "1 exp");
        }

        case 2: // 2 exp
        {
            PI[playerid][p_iskustvo] += 2;
            expChanged = true;

            format(szDest, szLen, "2 exp");
        }

        case 3: // Marihuana
        {
            new quantity = 1 + random(5),
                itemid = ITEM_WEED
            ;
            if (BP_PlayerHasBackpack(playerid))
            {
                if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) <= BP_GetItemCountLimit(itemid))
                {
                    BP_PlayerItemAdd(playerid, itemid, quantity);
                }
                else
                {
                    BP_PlayerItemAdd(playerid, itemid, BP_GetItemCountLimit(itemid) - (BP_PlayerItemGetCount(playerid, itemid)));
                }               
            }

            format(szDest, szLen, "Marihuana (%i gr)", quantity);
        }

        case 4: // Heroin
        {
            new quantity = 1 + random(5),
                itemid = ITEM_HEROIN
            ;
            if (BP_PlayerHasBackpack(playerid))
            {
                if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) <= BP_GetItemCountLimit(itemid))
                {
                    BP_PlayerItemAdd(playerid, itemid, quantity);
                }
                else
                {
                    BP_PlayerItemAdd(playerid, itemid, BP_GetItemCountLimit(itemid) - (BP_PlayerItemGetCount(playerid, itemid)));
                }              
            }

            format(szDest, szLen, "Heroin (%i gr)", quantity);
        }

        case 5: // MDMA
        {
            new quantity = 1 + random(5),
                itemid = ITEM_MDMA
            ;
            if (BP_PlayerHasBackpack(playerid))
            {
                if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) <= BP_GetItemCountLimit(itemid))
                {
                    BP_PlayerItemAdd(playerid, itemid, quantity);
                }
                else
                {
                    BP_PlayerItemAdd(playerid, itemid, BP_GetItemCountLimit(itemid) - (BP_PlayerItemGetCount(playerid, itemid)));
                }
            }

            format(szDest, szLen, "MDMA (%i gr)", quantity);
        }

        case 6: // Materijali
        {
            new quantity = (1+random(6)) * 500,
                itemid = ITEM_MATERIALS
            ;
            if (BP_PlayerHasBackpack(playerid))
            {
                if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) <= BP_GetItemCountLimit(itemid))
                {
                    BP_PlayerItemAdd(playerid, itemid, quantity);
                }
                else
                {
                    BP_PlayerItemAdd(playerid, itemid, BP_GetItemCountLimit(itemid) - (BP_PlayerItemGetCount(playerid, itemid)));
                }               
            }

            format(szDest, szLen, "Materijali (%.1f kg)", quantity/1000.0);
        }

        // case 7: // Materijali
        // {
        //     new quantity = (1+random(6)) * 500,
        //         itemid = ITEM_MATERIJALI
        //     ;
        //     if (BP_PlayerHasBackpack(playerid))
        //     {
        //         if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) <= BP_GetItemCountLimit(itemid))
        //         {
        //             BP_PlayerItemAdd(playerid, itemid, quantity);
        //         }
        //         else
        //         {
        //             BP_PlayerItemAdd(playerid, itemid, BP_GetItemCountLimit(itemid) - (BP_PlayerItemGetCount(playerid, itemid)));
        //         }               
        //     }

        //     format(szDest, szLen, "Materijali (%.1f kg)", quantity/1000.0);
        // }
    }


    if (expChanged)
    {
        new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
        if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
        {
            PI[playerid][p_nivo]++;
            SetPlayerScore(playerid, PI[playerid][p_nivo]);
            PI[playerid][p_iskustvo] -= nextLevelExp;
            SendClientMessageF(playerid, ZUTA, "** LEVEL UP | Sada ste nivo {FFFFFF}%d.", PI[playerid][p_nivo]);
        }
        new sQuery[67];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %d, iskustvo = %d WHERE id = %d", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
    }

    return 1;
}

stock GetServerPlayersRecord()
{
    return serverPlayersRecord;
}

stock SetServerPlayersRecord(value)
{
    serverPlayersRecord = value;
}

stock IsServerRestartScheduled()
{
    return serverRestartScheduled;
}

stock LogFunctionExec(const func[])
{
    new str[64];
    format(str, sizeof str, "Function Executed -> %s", func);
    Log_Write(LOG_DEBUG_FUNCTION, str);
}

stock LogCallbackExec(const module[], const cbName[])
{
    new str[64];
    format(str, sizeof str, "Callback Executed -> [%s] %s", module, cbName);
    Log_Write(LOG_DEBUG_CALLBACK, str);
}

stock LogDialogShow(playerid, const szFunc[])
{
    new sLog[80], playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof playerName);
    format(sLog, sizeof sLog, "Dialog Show -> [%s] %s", szFunc, playerName);
    Log_Write(LOG_DEBUG_DIALOG, sLog);
}

stock LogDialogResponse(playerid, const szFunc[], response, listitem, const szInputtext[])
{
    new str[228], playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof playerName);
    format(str, sizeof str, "Dialog Response -> [%s] %s (%i : %i) -> %s", szFunc, playerName, response, listitem, szInputtext);
    Log_Write(LOG_DEBUG_DIALOG, str);
}

stock HappyHours()
{
    return happyHours;
}

stock SnowMap()
{
    return snowMap;
}

stock DebugFunctions()
{
    return gDebugFunctions;
}

stock DebugCallbacks()
{
    return gDebugCallbacks;
}

stock DebugDialogs()
{
    return gDebugDialogs;
}

// forward DebugLoops();
// public DebugLoops()
// {
//     return gDebugLoops;
// }

stock PrintLoopBacktrace()
{
    if (gDebugLoops) 
    {
        PrintBacktrace(); 
    }
}

forward HostnameChanger();
public HostnameChanger()
{
    new stopper = 0;
    hostnameCycle = (hostnameCycle+1) % MAX_HOSTNAMES;
    while__loop (isnull(hostname[hostnameCycle]) && stopper <= MAX_HOSTNAMES)
    {
        stopper++; // sprecava infinite loop
        hostnameCycle = (hostnameCycle+1) % MAX_HOSTNAMES;
    }

    new cmd[80];
    format(cmd, sizeof cmd, "hostname %s", hostname[hostnameCycle]);
    SendRconCommand(cmd);
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MYSQL_SERVER_LoadConfig();
public MYSQL_SERVER_LoadConfig()
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new i = 0; i < rows; i++)
    {
        new field[32], bool:nullCheck;
        cache_get_value_index(i, 0, field, sizeof field);
        cache_is_value_index_null(i, 1, nullCheck);

        if (!strcmp(field, "hostname_1"))
        {
            if (!nullCheck) cache_get_value_index(i, 1, hostname[0], sizeof hostname[]);
            else hostname[0][0] = EOS;
        }
        else if (!strcmp(field, "hostname_2"))
        {
            if (!nullCheck) cache_get_value_index(i, 1, hostname[1], sizeof hostname[]);
            else hostname[1][0] = EOS;
        }
        else if (!strcmp(field, "hostname_3"))
        {
            if (!nullCheck) cache_get_value_index(i, 1, hostname[2], sizeof hostname[]);
            else hostname[2][0] = EOS;
        }
        else if (!strcmp(field, "password"))
        {
            if (!nullCheck) cache_get_value_index(i, 1, serverPassword, sizeof serverPassword);
            else serverPassword[0] = EOS;
        }
        else if (!strcmp(field, "snow"))
        {
            new snowStatus[4];
            if (!nullCheck) cache_get_value_index(i, 1, snowStatus, sizeof snowStatus);
            else snowMap = false;

            if (!strcmp(snowStatus, "on", true))
            {
                snowMap = true;
                SendRconCommand("loadfs snow");
            }
            else snowMap = false;
        }
        else if (!strcmp(field, "debug_functions"))
        {
            new status[4];
            if (!nullCheck) cache_get_value_index(i, 1, status, sizeof status);
            else gDebugFunctions = false;

            if (!strcmp(status, "on", true))
            {
                gDebugFunctions = true;
            }
            else gDebugFunctions = false;
        }
        else if (!strcmp(field, "debug_callbacks"))
        {
            new status[4];
            if (!nullCheck) cache_get_value_index(i, 1, status, sizeof status);
            else gDebugCallbacks = false;

            if (!strcmp(status, "on", true))
            {
                gDebugCallbacks = true;
            }
            else gDebugCallbacks = false;
        }
        else if (!strcmp(field, "debug_dialogs"))
        {
            new status[4];
            if (!nullCheck) cache_get_value_index(i, 1, status, sizeof status);
            else gDebugDialogs = false;

            if (!strcmp(status, "on", true))
            {
                gDebugDialogs = true;
            }
            else gDebugDialogs = false;
        }
        else if (!strcmp(field, "debug_loops"))
        {
            new status[4];
            if (!nullCheck) cache_get_value_index(i, 1, status, sizeof status);
            else gDebugLoops = false;

            if (!strcmp(status, "on", true))
            {
                gDebugLoops = true;
            }
            else gDebugLoops = false;
        }
        else if (!strcmp(field, "players_record"))
        {
            new num[4];
            if (!nullCheck) 
            {
                cache_get_value_index(i, 1, num, sizeof num);
                serverPlayersRecord = strval(num);
            }
            else
            {
                serverPlayersRecord = 999;
            }
        }
        else if (!strcmp(field, "auto_racing"))
        {
            new status[4];
            if (!nullCheck) cache_get_value_index(i, 1, status, sizeof status);
            else gAutoRacing = false;

            if (!strcmp(status, "on", true))
            {
                gAutoRacing = true;
            }
            else gAutoRacing = false;

            SetupAutoRacing(gAutoRacing);
        }
        else if (!strcmp(field, "auto_racing_interval"))
        {
            new num[4];
            if (!nullCheck) 
            {
                cache_get_value_index(i, 1, num, sizeof num);
                gAutoRacingInterval = strval(num);
            }
            else
            {
                gAutoRacingInterval = 20;
            }
        }
    }


    if (isnull(hostname[1]) && isnull(hostname[2]))
    {
        tajmer:hostnameChanger = 0;
        if (!isnull(hostname[0]))
        {
            new cmd[80];
            format(cmd, sizeof cmd, "hostname %s", hostname[0]);
            SendRconCommand(cmd);
        }
    }
    else
    {
        hostnameCycle = 0;
        tajmer:hostnameChanger = SetTimer("HostnameChanger", 3000, true);
    }


    if (isnull(serverPassword))
    {
        serverPassword = "0";
    }
    new cmd[42];
    format(cmd, sizeof cmd, "password %s", serverPassword);
    SendRconCommand(cmd);
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:server(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response) return 1;

    switch (listitem)
    {
        case 0: // Promeni ime
        {
            new string[60*(MAX_HOSTNAMES+1)];
            string[0] = EOS;

            for__loop (new i = 0; i < MAX_HOSTNAMES; i++)
            {
                format(string, sizeof string, "%s%d\t%s\n", string, i, hostname[i]);
            }
            SPD(playerid, "server_hostname", DIALOG_STYLE_TABLIST, "Promeni ime", string, "Dalje >", "< Nazad");
        }

        case 1: // Restartuj
        {
            SPD(playerid, "server_restart", DIALOG_STYLE_MSGBOX, "Restart", "{FFFFFF}Da li ste sigurni da zelite da restartujete server?", "Da", "Ne");
        }

        case 2: // Zakljucaj
        {
            SPD(playerid, "server_lock", DIALOG_STYLE_INPUT, "Zakljucaj server", "{FFFFFF}Unesite sifru za server:", "Zakljucaj", "Nazad");
        }

        case 3: // Otkljucaj
        {
            SPD(playerid, "server_unlock", DIALOG_STYLE_MSGBOX, "Otkljucaj server", "{FFFFFF}Da li ste sigurni da zelite da otkljucate server?", "Da", "Ne");
        }
        case 4: // Happy Hours
        {
            happyHours = !happyHours;

            new string[110];
            format(string, sizeof string, "(happy hours) {FFFFFF}Admin %s je %s {FFFFFF}happy hours.", ime_rp[playerid], (HappyHours())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));
            SendClientMessageToAll(ZUTA, string);

            if (HappyHours())
            {
                SendClientMessage(playerid, SVETLOCRVENA, "* Ne zaboravite da iskljucite happy hours!");
            }
            foreach(new i : Player)
            {
                ShowMainGuiTD(i, true);
            }
            callcmd::server(playerid, "");
        }

        case 5: // Happy Job
        {
            SPD(playerid, "server_happyjob", DIALOG_STYLE_LIST, "Server - Happy Job", "On/off", "Dalje >", "< Nazad");
        }

        case 6: // Snow map
        {
            snowMap = !snowMap;

            AdminMsg(ZUTA, "* %s je %s {FFFFFF}zimsku mapu.", ime_rp[playerid], (SnowMap())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));

            if (SnowMap())
            {
                SendRconCommand("loadfs snow");
                mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'snow'");
            }
            else
            {
                SendRconCommand("unloadfs snow");
                mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'snow'");
            }
        }

        case 7: // Debug
        {
            new string[120];
            format(string, sizeof string, "Debug Functions %s\nDebug Callbacks %s\nDebug Dialogs %s\nDebug Loops %s", (gDebugFunctions? ("{00FF00}ON") : ("{FF0000}OFF")), (gDebugCallbacks? ("{00FF00}ON") : ("{FF0000}OFF")), (gDebugDialogs? ("{00FF00}ON") : ("{FF0000}OFF")), (gDebugLoops? ("{00FF00}ON") : ("{FF0000}OFF")));
            SPD(playerid, "server_debug", DIALOG_STYLE_LIST, "Debug", string, "Promeni", "Nazad");
        }

        case 8: // Anticheat
        {
            // return InfoMsg(playerid, "Trenutno nedostupno.");
            new sDialog[512],
                sCheatName[MAX_CHEATNAME_LEN];
            
            format(sDialog, sizeof sDialog, "Modul\tStatus");
            for__loop (new i = 0; i < _:E_OVERWATCH_CONFIG; i++)
            {
                OW_GetCheatName(E_OVERWATCH_CONFIG:i, sCheatName);
                format(sDialog, sizeof sDialog, "%s\n%s\t%s", sDialog, sCheatName, (OW_Config[E_OVERWATCH_CONFIG:i]? ("{00FF00}ON") : ("{FF0000}OFF")));
                
            }
            SPD(playerid, "server_anticheat", DIALOG_STYLE_TABLIST_HEADERS, "Anticheat", sDialog, "Promena", "Nazad");
        }

        case 9: // Lucky One Jackpot
        {
            new string[72];
            format(string, sizeof string, "{FFFFFF}Jackpot: {00FF00}%s\n\n{FFFFFF}Upisite novi iznos za Jackpot:", formatMoneyString(LOTTERY_GetPrize()));

            SPD(playerid, "server_jackpot", DIALOG_STYLE_INPUT, "Jackpot", string, "Promeni", "Nazad");
        }

        case 10: // Salon napunjen
        {
            AUTOSALON_ToggleUnlimitedStock();

            if (AUTOSALON_IsStockUnlimited())
            {
                new str[115];
                format(str, sizeof str, "{FF6347}- STAFF:{B4CDED} %s je napunio autosalon vozilima - moguce je kupiti bilo koje vozilo!", ime_rp[playerid]);
                SendClientMessageToAll(BELA, str);
            }

            else
            {
                new str[115];
                format(str, sizeof str, "{FF6347}- STAFF:{B4CDED} Kupovina vozila je zavrsena! (%s)", ime_rp[playerid]);
                SendClientMessageToAll(BELA, str);
            }

            callcmd::server(playerid, "");
        }

        case 11: // Restart zakazan
        {
            serverRestartScheduled = !serverRestartScheduled;

            if (serverRestartScheduled)
                SendClientMessage(playerid, SVETLOPLAVA, "* Server ce automatski biti restartovan oko 6.00 izjutra.");
            else
                SendClientMessage(playerid, SVETLOPLAVA, "* Otkazali ste automatski restart servera.");

            callcmd::server(playerid, "");
        }

        case 12: // Tocak srece
        {
            gLuckyWheel = !gLuckyWheel;

            if (gLuckyWheel)
            {
                new sMsg[94];
                format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s ukljucio tombolu! Izvlacenje je na svakih 10 minuta.", ime_rp[playerid]);
                SendClientMessageToAll(BELA, sMsg);

                tmrLuckyWheel = SetTimer("LuckyWheel", 10*60*1000, true);
            }
            else
            {
                new sMsg[59];
                format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s iskljucio tombolu.", ime_rp[playerid]);
                SendClientMessageToAll(BELA, sMsg);

                KillTimer(tmrLuckyWheel);
            }

            callcmd::server(playerid, "");
        }

        case 13: // Trke
        {
            new sDialog[90];
            format(sDialog, sizeof sDialog, "Automatsko organizovanje %s\nSpisak za organizovanje\nInterval {FFFF00}%i minuta", (gAutoRacing? ("{00FF00}ON") : ("{FF0000}OFF")), gAutoRacingInterval);
            SPD(playerid, "server_racing", DIALOG_STYLE_LIST, "Trke config", sDialog, "Odaberi", "Nazad");
        }

        case 14: // Zakljucane registracije
        {
            if(serverRegistracijeZakljucane == 0) 
            {
                serverRegistracijeZakljucane = 1;
                InfoMsg(playerid, "Zakljucao si registracije");
            }  
            else 
            {
                serverRegistracijeZakljucane = 0;
                InfoMsg(playerid, "Otkljucao si registracije");
            }
            
        }

        case 15: // Rudar zlato
        {
            new sDialog[100];
            format(sDialog, sizeof sDialog, "U rudniku ima %d zlata, upisite koliko da dodate na postojeco", get_rudar_zlato());
            SPD(playerid, "server_rudnik", DIALOG_STYLE_INPUT, "Rudar Zlato", sDialog, "Odaberi", "Nazad");
        }
        
        case 16: // Banka ekonomija
        {
            new sDialog[110];
            format(sDialog, sizeof sDialog, "U banci ima %d novca, upisite koliko zelite dodati na postojecu kolicinu", gBankaNovci);
            SPD(playerid, "server_banka_ekonomija", DIALOG_STYLE_INPUT, "Banka Novac", sDialog, "Odaberi", "Nazad");
        }
    }
    return 1;
}

Dialog:server_banka_ekonomija(playerid, response, listitem, const inputtext[])
{
    if(!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!response) return callcmd::server(playerid, "");
    if(isnull(inputtext)) return DialogReopen(playerid);

    gBankaNovci += strval(inputtext);

    DodajNovacUBanku(strval(inputtext));

    SendClientMessageF(playerid, SVETLOPLAVA, "Novo stanje novca u banci je: %d", gBankaNovci);

    return 1;
}

Dialog:server_rudnik(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!response) return callcmd::server(playerid, "");
    if (isnull(inputtext)) return DialogReopen(playerid);

    new novoZlato;

    novoZlato = get_rudar_zlato() + strval(inputtext);

    format(mysql_upit, sizeof mysql_upit, "UPDATE server_info SET value = '%d' WHERE field = 'rudar_zlato'", novoZlato);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

    rudar_dodaj_zlato(novoZlato);

    SendClientMessageF(playerid, SVETLOPLAVA, "Novo stanje zlata u rudniku: %d", novoZlato);

    return 1;
}

Dialog:server_racing(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return callcmd::server(playerid, "");

    if (listitem == 0)
    {
        if (IsRaceActive())
            return ErrorMsg(playerid, "Ne mozete menjati ovu opciju trka dok je trka aktivna.");

        gAutoRacing = !gAutoRacing;

        if (gAutoRacing)
        {
            new sMsg[80];
            format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s ukljucio automatsko organizovanje trka.", ime_rp[playerid]);
            SendClientMessageToAll(BELA, sMsg);

            SetupAutoRacing(true);
            mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'auto_racing'");

        }
        else
        {
            new sMsg[81];
            format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s iskljucio automatsko organizovanje trka.", ime_rp[playerid]);
            SendClientMessageToAll(BELA, sMsg);

            SetupAutoRacing(false);
            mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'auto_racing'");
        }

        callcmd::server(playerid, "");
    }
    else if (listitem == 1)
    {
        Race_ShowConfigDialog(playerid);
    }

    else if (listitem == 2) // Interval
    {
        new sDialog[90];
        format(sDialog, sizeof sDialog, "{FFFFFF}Trenutno podesavanje: {FFFF00}%i minuta\n\n{FFFFFF}Unesite novi interval (min):", gAutoRacingInterval);
        SPD(playerid, "server_race_interval", DIALOG_STYLE_INPUT, "Trke: interval", sDialog, "Postavi", "Nazad");
    }
    return 1;
}

Dialog:server_race_interval(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::server(playerid, "");

    if (isnull(inputtext))
        return DialogReopen(playerid);

    new input = strval(inputtext);
    if (input < 20 || input > 240)
        return ErrorMsg(playerid, "Unesite broj izmedju 20 i 240 minuta.");

    gAutoRacingInterval = input;

    new sQuery[75];
    format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%i' WHERE field = 'auto_racing_interval'", input);
    mysql_tquery(SQL, sQuery);

    SendClientMessageF(playerid, SVETLOPLAVA, "* Trke ce biti organizovane automatski na svakih %i minuta.", input);

    return 1;
}

Dialog:server_jackpot(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::server(playerid, "");

    new prize;
    if (sscanf(inputtext, "i", prize))
        return DialogReopen(playerid);

    if (prize < 0 || prize > 10000000)
        return ErrorMsg(playerid, "Nagrada mora biti izmedju $0 i $10.000.000.");

    LOTTERY_SetPrize(prize);

    new str[115];
    format(str, sizeof str, "{FF6347}- STAFF:{B4CDED} %s je postavio iznos Jackpot-a za Lucky One na: {00FF00}%s.", ime_rp[playerid], formatMoneyString(prize));
    SendClientMessageToAll(BELA, str);

    new query[256];
    format(query, sizeof query, "UPDATE server_info SET value = '%i' WHERE field = 'jackpot'", LOTTERY_GetPrize());
    mysql_tquery(SQL, query);
    return 1;
}

Dialog:server_anticheat(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::server(playerid, "");

    OW_Config[E_OVERWATCH_CONFIG: listitem] = (OW_Config[E_OVERWATCH_CONFIG: listitem] == 1)? 0 : 1;

    new sQuery[61 + _:E_OVERWATCH_CONFIG*2], sValue[_:E_OVERWATCH_CONFIG*2];
    sValue[0] = EOS;
    for__loop (new i = 0; i < _:E_OVERWATCH_CONFIG; i++)
    {
        format(sValue, sizeof sValue, "%s%i|", sValue, OW_Config[E_OVERWATCH_CONFIG: i]);
        // poslednji "|" se nece pojaviti jer sValue ima tacno za toliko kracu duzinu (da je +1, onda bi bilo)
    }
    format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%s' WHERE field = 'overwatch'", sValue);
    mysql_tquery(SQL, sQuery);

    AdminMsg(CRVENA, "* %s je %s {FF0000}modul anticheat-a: {FFFFFF}%s", ime_rp[playerid], (OW_Config[E_OVERWATCH_CONFIG: listitem]==1? ("{00FF00}ukljucio") : ("{FF0000}iskljucio")), inputtext);

    dialog_respond:server(playerid, 1, 8, "Anticheat");
    return 1;
}

Dialog:server_happyjob(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::server(playerid, "");

    if (IsHappyJobSet())
    {
        new jobname[22], str[70], jobid = GetHappyJob();
        GetJobName(jobid, jobname, sizeof jobname);
        format(str, sizeof str, "{FFFFFF}Ukljucen je Happy Job: {FF9900}%s.", jobname);
        SPD(playerid, "server_happyjob_off", DIALOG_STYLE_MSGBOX, "Happy Job", str, "Iskljuci", "Nazad");
    }
    else
    {
        new job_name[20], string[512];
        format(string, sizeof string, "ID\tNaziv");
        for__loop (new i = 0; i < GetMaxJobs(); i++) 
        {
            GetJobName(i, job_name, sizeof(job_name));
            format(string, sizeof(string), "%s\n%i\t%s", string, i, job_name);
        }
        SPD(playerid, "server_happyjob_on", DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Izbor HappyJob-a", string, "Izaberi", "Odustani");
    }
    return 1;
}

Dialog:server_happyjob_off(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SetHappyJob(-1);

        new str[64];
        format(str, sizeof str, "{FF6347}- STAFF:{B4CDED} %s je iskljucio HappyJob.", ime_rp[playerid]);
        SendClientMessageToAll(BELA, str);
        foreach(new i : Player)
        {
            ShowMainGuiTD(i, true);
        }

    }
    
    callcmd::server(playerid, "");
    return 1;
}

Dialog:server_happyjob_on(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::server(playerid, "");

    SetHappyJob(strval(inputtext));

    new str[100], jobName[22];
    GetJobName(strval(inputtext), jobName, sizeof jobName);
    format(str, sizeof str, "{FF6347}- STAFF:{B4CDED} %s je ukljucio HappyJob (dupla zarada): {FFFF00}%s.", ime_rp[playerid], jobName);
    SendClientMessageToAll(BELA, str);
    foreach(new i : Player)
    {
        ShowMainGuiTD(i, true);
    }
    callcmd::server(playerid, "");
    return 1;
}

Dialog:server_hostname(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response)
        return callcmd::server(playerid, "");

    SetPVarInt(playerid, "pServerHostname", listitem);
    new string[180];
    format(string, sizeof string, "{FFFFFF}hostname #%i: %s\nUpisite novi naziv servera (\"Ukloni\" da uklonite ovaj hostname):", listitem, hostname[listitem]);
    SPD(playerid, "server_hostname2", DIALOG_STYLE_INPUT, "Promena imena", string, "Promeni", "Nazad");
    return 1;
}

Dialog:server_hostname2(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response)
        return dialog_respond:server(playerid, 1, 0, "Promeni ime");

    if (isnull(inputtext))
        return DialogReopen(playerid);

    if (strlen(inputtext) < 3 && strlen(inputtext) > 60)
        return ErrorMsg(playerid, "Ime mora biti dugacko izmedju 3 i 60 karaktera.");

    new cmd[74], h = GetPVarInt(playerid, "pServerHostname");

    if (!strcmp(inputtext, "ukloni", true))
    {
        if (h == 0)
        {
            ErrorMsg(playerid, "Ne mozete ukloniti hostname #1.");
            return DialogReopen(playerid);
        }
        else
        {
            if (h == 1 && isnull(hostname[2]) || h == 2 && isnull(hostname[1]))
            {
                KillTimer(tajmer:hostnameChanger), tajmer:hostnameChanger = 0;
            }

            new query[256];
            format(query, sizeof query, "UPDATE server_info SET value = NULL WHERE field = 'hostname_%i'", h+1);
            mysql_tquery(SQL, query);

            format(cmd, sizeof cmd, "hostname %s", hostname[0]);
            SendRconCommand(cmd);

            hostname[h][0] = EOS;
            AdminMsg(BELA, "A {FF0000}| %s je uklonio hostname #%i.", ime_rp[playerid], h+1);
        }
    }
    else
    {
        format(hostname[h], sizeof hostname[], "%s", inputtext);
        format(cmd, sizeof cmd, "hostname %s", hostname[h]);
        SendRconCommand(cmd);

        new query[129];
        format(query, sizeof query, "UPDATE server_info SET value = '%s' WHERE field = 'hostname_%i'", inputtext, h+1);
        mysql_tquery(SQL, query);

        AdminMsg(BELA, "A {FF0000}| %s je promenio hostname #%i: %s.", ime_rp[playerid], h+1, inputtext);
    }

    DeletePVar(playerid, "pServerHostname");
    return callcmd::server(playerid, "");
}

Dialog:server_restart(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response)
        return callcmd::server(playerid, "");

    AdminMsg(BELA, "A {FF0000}| %s je pokrenuo restart servera.", ime_rp[playerid]);
    SendClientMessageToAll(CRVENA, "Server se restartuje...");
    foreach (new i : Player)
    {
        TogglePlayerControllable_H(playerid, false);
    }
    SendRconCommand("gmx");
    return 1;
}

Dialog:server_lock(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response)
        return callcmd::server(playerid, "");

    if (isnull(inputtext))
        return DialogReopen(playerid);

    if (strlen(inputtext) < 3 && strlen(inputtext) > 32)
        return ErrorMsg(playerid, "Lozinka mora biti dugacka izmedju 3 i 32 karaktera.");


    new query[96];
    format(query, sizeof query, "UPDATE server_info SET value = '%s' WHERE field = 'password'", inputtext);
    mysql_tquery(SQL, query);

    new cmd[42];
    format(serverPassword, sizeof serverPassword, "%s", inputtext);
    format(cmd, sizeof cmd, "password %s", serverPassword);
    SendRconCommand(cmd);

    AdminMsg(BELA, "A {FF0000}| %s je zakljucao server (pw: %s).", ime_rp[playerid], serverPassword);
    return callcmd::server(playerid, "");
}

Dialog:server_unlock(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!response)
        return callcmd::server(playerid, "");


    mysql_tquery(SQL, "UPDATE server_info SET value = NULL WHERE field = 'password'");

    format(serverPassword, sizeof serverPassword, "0");
    SendRconCommand("password 0");

    AdminMsg(BELA, "A {FF0000}| %s je otkljucao server.", ime_rp[playerid]);
    return callcmd::server(playerid, "");
}

Dialog:server_debug(playerid, response, listitem, const inputtext[])
{
    if (!response) return callcmd::server(playerid, "");

    if (listitem == 0) // Debug Functions
    {
        gDebugFunctions = !gDebugFunctions;

        AdminMsg(ZUTA, "* %s je %s {FFFFFF}functions debug.", ime_rp[playerid], (DebugFunctions())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));

        if (DebugFunctions())
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'debug_functions'");
        }
        else
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'debug_functions'");
        }
    }

    if (listitem == 1) // Debug Callbacks
    {
        gDebugCallbacks = !gDebugCallbacks;

        AdminMsg(ZUTA, "* %s je %s {FFFFFF}callbacks debug.", ime_rp[playerid], (DebugCallbacks())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));

        if (DebugCallbacks())
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'debug_callbacks'");
        }
        else
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'debug_callbacks'");
        }
    }

    if (listitem == 2) // Debug Dialogs
    {
        gDebugDialogs = !gDebugDialogs;

        AdminMsg(ZUTA, "* %s je %s {FFFFFF}dialog debug.", ime_rp[playerid], (DebugDialogs())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));

        if (DebugCallbacks())
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'debug_dialogs'");
        }
        else
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'debug_dialogs'");
        }
    }

    if (listitem == 3) // Debug Loops
    {
        gDebugLoops = !gDebugLoops;

        AdminMsg(ZUTA, "* %s je %s {FFFFFF}loop debug.", ime_rp[playerid], (DebugDialogs())?("{00FF00}ukljucio"):("{FF0000}iskljucio"));

        if (gDebugLoops)
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'on' WHERE field = 'debug_loops'");
        }
        else
        {
            mysql_tquery(SQL, "UPDATE server_info SET value = 'off' WHERE field = 'debug_loops'");
        }
    }

    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:server(playerid, const params[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new dialogString[320], hjStr[32];

    if (!IsHappyJobSet())
        format(hjStr, sizeof hjStr, "{FF0000}OFF");
    else
    {
        new jobName[22];
        GetJobName(GetHappyJob(), jobName, sizeof jobName);
        format(hjStr, sizeof hjStr, "{00FF00}%s", jobName);
    }

    format(dialogString, sizeof dialogString, "Promeni ime\nRestartuj server\nZakljucaj server\nOtkljucaj server\nHappy Hours %s\nHappy Job %s\nSneg %s\nDebug\nAnticheat\nLucky One Jackpot\nSalon napunjen %s\nRestart zakazan %s\nTocak srece %s\nTrke\nZakljucaj registracije\nRudar zlato\nBanka", 
        (happyHours? ("{00FF00}ON") : ("{FF0000}OFF")), hjStr, (snowMap? ("{00FF00}ON") : ("{FF0000}OFF")), (AUTOSALON_IsStockUnlimited()? ("{00FF00}DA") : ("{FF0000}NE")), (serverRestartScheduled? ("{00FF00}DA") : ("{FF0000}NE")), (gLuckyWheel? ("{00FF00}DA") : ("{FF0000}NE")));
    SPD(playerid, "server", DIALOG_STYLE_LIST, "Server", dialogString, "Dalje", "Izadji");

    return 1;
}

flags:reload(FLAG_ADMIN_6)
CMD:reload(playerid, const params[])
{
    SPD(playerid, "reload", DIALOG_STYLE_LIST, "Reload", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica\nImanje\nFakcija\nVozilo", "Dalje", "Izadji");
    return 1;
}

Dialog:reload(playerid, response, listitem, const inputtext[])
{
    DeletePVar(playerid, "pReloadType");
    if (!response) return 1;

    
    if (0 <= listitem <= 6 || listitem == 8)
    {
        SetPVarString(playerid, "pReloadType", inputtext);

        new sTitle[24];
        format(sTitle, sizeof sTitle, "Reload: %s", inputtext);
        SPD(playerid, "reload_id", DIALOG_STYLE_INPUT, sTitle, "{FFFFFF}Upisite ID za ponovno ucitavanje:", "Reload", "Nazad");
    }

    else
    {
        return InfoMsg(playerid, "Trenutno nedostupno.");
    }
    return 1;
}

Dialog:reload_id(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::reload(playerid, "");

    new id, sTarget[16];
    if (sscanf(inputtext, "i", id))
        return DialogReopen(playerid);

    GetPVarString(playerid, "pReloadType", sTarget, sizeof sTarget);
    DeletePVar(playerid, "pReloadType");

    if (!strcmp(sTarget, "Kuca", true))
    {
        if (id > RE_GetMaxID_House())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_House());
            return DialogReopen(playerid);
        }

        RE_Reload(kuca, id);
        InfoMsg(playerid, "Kuca %i je ponovo ucitana.", id);
    }

    else if (!strcmp(sTarget, "Stan", true))
    {
        if (id > RE_GetMaxID_Apartment())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Apartment());
            return DialogReopen(playerid);
        }

        RE_Reload(stan, id);
        InfoMsg(playerid, "Stan %i je ponovo ucitana.", id);
    }

    else if (!strcmp(sTarget, "Firma", true))
    {
        if (id > RE_GetMaxID_Business())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Business());
            return DialogReopen(playerid);
        }
        
        RE_Reload(firma, id);
        InfoMsg(playerid, "Firma %i je ponovo ucitana.", id);
    }

    else if (!strcmp(sTarget, "Garaza", true))
    {
        if (id > RE_GetMaxID_Garage())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Garage());
            return DialogReopen(playerid);
        }
        
        RE_Reload(garaza, id);
        InfoMsg(playerid, "Garaza %i je ponovo ucitana.", id);
    }

    else if (!strcmp(sTarget, "Hotel", true))
    {
        if (id > RE_GetMaxID_Cottage())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Cottage());
            return DialogReopen(playerid);
        }
        
        RE_Reload(hotel, id);
        InfoMsg(playerid, "Hotel %i je ponovo ucitan.", id);
    }

    else if (!strcmp(sTarget, "Vikendica", true))
    {
        if (id > RE_GetMaxID_House())
        {
            ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_House());
            return DialogReopen(playerid);
        }
        
        RE_Reload(vikendica, id);
        InfoMsg(playerid, "Vikendica %i je ponovo ucitana.", id);
    }
    else if (!strcmp(sTarget, "Imanje", true))
    {
        Land_Reload(id);
        InfoMsg(playerid, "Imanje %i je ponovo ucitano.", id);
    }
    else if (!strcmp(sTarget, "Vozilo", true))
    {
        OwnedVehicle_Reload(id);
        InfoMsg(playerid, "Vozilo %i je ponovo ucitano.", id);
    }
    else return ErrorMsg(playerid, "Trenutno nedostupno.");

    return 1;
}

flags:fixrecord(FLAG_ADMIN_6)
CMD:fixrecord(playerid, const params[])
{
    new number;
    if (sscanf(params, "i", number))
        return Koristite(playerid, "fixrecord [Rekord u broju igraca]");

    if (number < 0 || number > 1000)
        return ErrorMsg(playerid, "Broj mora biti izmedju 0 i 1000.");

    SetServerPlayersRecord(number);
    return 1;
}

flags:tombola(FLAG_ADMIN_6)
CMD:tombola(playerid, const params[])
{
    LuckyWheel();
    return 1;
}

flags:uptime(FLAG_ADMIN_6)
CMD:uptime(playerid, const params[])
{  
    new sTime[20];
    GetReadableTime(gettime() - gServerInitTime, sTime);

    SendClientMessageF(playerid, ZUTA, "Server je poslednji put restartovan pre: {FF0000}%s.", sTime);
    return 1;
}