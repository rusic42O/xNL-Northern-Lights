#include <YSI_Coding\y_hooks>

hook OnGameModeInit() 
{
    print("Initializing prehooks..");
    for__loop (new i = 0; i < _:e_loaded; i++) 
    {
        LOADED[e_loaded: i] = 0;
    }
    print("Prehooks done..");
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerConnect");
    }

    // Izmena broja igraca i postavljanje u textdraw
    cinc[playerid]++;
    // PlayerCountInc();

    // Uzimanje  RP i obicnog imena i stavljanje u varijable
    GetPlayerIp(playerid, PI[playerid][p_ip], 16);
    GetPlayerName(playerid, ime_obicno[playerid], MAX_PLAYER_NAME);
    GetPlayerName(playerid, ime_rp[playerid], MAX_PLAYER_NAME);
    for__loop (new i = 0; i < strlen(ime_rp[playerid]); i++) 
    {
        if (ime_rp[playerid][i] == '_') 
        {
            ime_rp[playerid][i] = ' ';
            break;
        }
    }

    /*if (IsPlayerNPC(playerid))
    {
        SetPlayerLoggedIn(playerid);
        SetSpawnInfo(playerid, 0, 0, 2979.59, 2974.52, 0.0, 321.77, 0, 0, 0, 0, 0, 0);
        GetPlayerName(playerid, ime_obicno[playerid], MAX_PLAYER_NAME);
        strcpy(ime_rp[playerid], ime_obicno[playerid]);
        resetuj_promenljive(playerid);
        SpawnPlayer(playerid);

        return ~1; // ~ = obustavi dalje hookove
    }*/

    //ptdIntro_Create(playerid);

    ResetPlayerMoney(playerid);
    TogglePlayerSpectating_H(playerid, true);
    SetPlayerWeather(playerid, GetWeather_H());
    SetPlayerTime(playerid, GetWorldTime_H(), 0);
    resetuj_promenljive(playerid);
    SetPlayerColor(playerid, 0xFFFFFF00);

    for__loop (new i = 0; i < sizeof pAttachedObjects[]; i++)
    {
        pAttachedObjects[playerid][i] = -1;
    }

    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerDisconnect");
    }

    if (IsPlayerNPC(playerid)) 
    {
        return ~1; // obustavlja dalje pozivanje OnPlayerDisconnect
    }

    // Izmena broja igraca i postavljanje u textdraw
    cinc[playerid]++;

    // Brisanje prikacenih objekata
    for__loop (new i = 0; i < sizeof pAttachedObjects[]; i++)
    {
        if (pAttachedObjects[playerid][i] != -1)
        {
            RemovePlayerAttachedObject(playerid, i);
        }
    }


    // Upisivanje u log - pracenje novca
    new sLog[93];
    format(sLog, sizeof sLog, "%s | Cash: %s | Bank: %s (disconnect)", ime_obicno[playerid], formatMoneyString(PI[playerid][p_novac]), formatMoneyString(PI[playerid][p_banka]));
    Log_Write(LOG_MONEYFLOW, sLog);
    return 1;
}

hook OnPlayerSpawn(playerid) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerSpawn");
    }
    if (IsPlayerNPC(playerid)) return ~1;

    // Freeze zbog (eventualnog) ucitavanja enterijera
    TogglePlayerControllable_H(playerid, false);
    SetPVarInt(playerid, "pTeleportFreeze", 1);
    SetTimerEx("TeleportUnfreeze", 1500, false, "ii", playerid, cinc[playerid]);
    TextDrawShowForPlayer(playerid, TD_LoadingObjects);


    // Upisivanje u log - pracenje novca
    new sLog[80];
    format(sLog, sizeof sLog, "%s | Cash: %s | Bank: %s", ime_obicno[playerid], formatMoneyString(PI[playerid][p_novac]), formatMoneyString(PI[playerid][p_banka]));
    Log_Write(LOG_MONEYFLOW, sLog);


    if (gCrashSpawn{playerid} == true)
    {
        new
            sWeapons[38],
            sAmmo[80],
            aWeapons[13],
            aAmmo[13]
        ;

        SetPlayerInterior(playerid,  GetPVarInt(playerid, "pCrashInterior"));
        SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pCrashVirtual"));
        
        SetPlayerHealth(playerid, GetPVarFloat(playerid, "pCrashHealth"));
        SetPlayerArmour(playerid, GetPVarFloat(playerid, "pCrashArmour"));

        GetPVarString(playerid, "pCrashWeapons", sWeapons, sizeof sWeapons);
        GetPVarString(playerid, "pCrashAmmo", sAmmo, sizeof sAmmo);

        DeletePVar(playerid, "pCrashWeapons");
        DeletePVar(playerid, "pCrashAmmo");
        DeletePVar(playerid, "pCrashInterior");
        DeletePVar(playerid, "pCrashVirtual");
        DeletePVar(playerid, "pCrashHealth");
        DeletePVar(playerid, "pCrashArmour");
        
        sscanf(sWeapons, "p<|>iiiiiiiiiiiii", aWeapons[0], aWeapons[1], aWeapons[2], aWeapons[3], aWeapons[4], aWeapons[5], aWeapons[6], aWeapons[7], aWeapons[8], aWeapons[9], aWeapons[10], aWeapons[11], aWeapons[12]);
        
        sscanf(sAmmo, "p<|>iiiiiiiiiiiii", aAmmo[0], aAmmo[1], aAmmo[2], aAmmo[3], aAmmo[4], aAmmo[5], aAmmo[6], aAmmo[7], aAmmo[8], aAmmo[9], aAmmo[10], aAmmo[11], aAmmo[12]);
        
        for__loop (new i = 0; i < 13; i++)
        {
            if (aWeapons[i] > 0 && aAmmo[i] > 0)
            {
                GivePlayerWeapon(playerid, aWeapons[i], aAmmo[i]);
            }
        }
    
        gCrashSpawn{playerid} = false;

        // Vraca spawn gde i treba biti
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);
    }
    else if (pRestoreData{playerid})
    {
        RestorePlayerWeaponDataAndPos(playerid);
    }
    else
    {  
        if (!IsPlayerInWar(playerid))
        {
            SetPlayerInterior(playerid, PI[playerid][p_spawn_ent]);
            SetPlayerVirtualWorld(playerid, PI[playerid][p_spawn_vw]);
        }
    }

    // Postavljanje podrazumevanih vrednosti za promenljive
    gPlayerSpawned{playerid} = true;
    
    // Resetovanje potrebnih podataka
    ClearAnimations(playerid);
    DisablePlayerCheckpoint_H(playerid);
    DisablePlayerRaceCheckpoint_H(playerid);
    UpdatePlayerBubble(playerid);
    
    // Postavljanje potrebnih podataka (1/3)
    if (GetPlayerMoney(playerid) != PI[playerid][p_novac]) 
    {
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PI[playerid][p_novac]);
    }
    
    // SetPlayerColor(playerid, 0xFFFFFF00); // postavlja belu providnu boju imena
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerDeath");
    }

    
    // Upisivanje u log
    new sLog[150], Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    if (IsPlayerConnected(killerid))
    {
        new sWeapon[20];
        GetWeaponName(reason, sWeapon, sizeof sWeapon);
        format(sLog, sizeof sLog, "UBISTVO | %s je ubijen od strane %s | %s (%i) | %.2f, %.2f, %.2f", ime_obicno[playerid], ime_obicno[killerid], sWeapon, reason, pos[0], pos[1], pos[2]);
    }
    else
    {
        new sReason[20];
        GetWeaponName(reason, sReason, sizeof sReason);
        format(sLog, sizeof sLog, "SMRT | %s | %s (%i) | %.2f, %.2f, %.2f", ime_obicno[playerid], sReason, reason, pos[0], pos[1], pos[2]);
    }
    Log_Write(LOG_ONPLAYERDEATH, sLog);
    
    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerEnterDynArea");
    }

    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerLeaveDynArea");
    }

    return 1;
}

hook OnPlayerText(playerid, text[]) 
{
    if (PI[playerid][p_utisan] > 0) 
    {
        overwatch_poruka(playerid, GRESKA_UTISAN);
        return ~0;
    }
    if (IsPlayerRegistering(playerid)) 
    { 
        ErrorMsg(playerid, GRESKA_REGISTRACIJA);
        return ~0;
    }
    
    return 0;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerStateChange");
    }

    driveby{playerid} = false;
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerKeyStateChange");
    }

    return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerClickTextDraw");
    }

    if (IsDialogShownToPlayer(playerid))
    {
        return ~1;
    }
    else 
    {
        if (GetPVarInt(playerid, "owSelectTextDraw") == 1)
        {
            SelectTextDraw(playerid, GetPVarInt(playerid, "owHoverColor"));
        }
    }
    return 0;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerClickPlayerTD");
    }

    if (IsDialogShownToPlayer(playerid))
    {
        return ~1;
    }
    return 0;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerEnterDynamicCP");
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
        return ~1;

    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("pre_hooks.pwn", "OnPlayerEnterCheckpoint");
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
        return ~1;

    return 1;
}