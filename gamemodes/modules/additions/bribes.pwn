#include <YSI_Coding\y_hooks>

#define BRIBE_COST       3000
#define MAX_BRIBE_NPCS      3

enum E_BRIBE_NPC_INFO
{
    E_BRIBE_NPC_ID,
    E_BRIBE_NPC_NAME[24+1],
    E_BRIBE_NPC_RECORD,
}

new
    BribeInfo[MAX_BRIBE_NPCS][E_BRIBE_NPC_INFO],

    NPCResume[MAX_PLAYERS]
;

// Hooks;
hook OnGameModeInit()
{
    CallLocalFunction("LoadBribeNPCs", "");
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
    NPCResume[playerid] = -1;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook FCNPC_OnFinishPlayback(npcid)
{
    new
        bribeid = GetBribeFromNPC(npcid)
    ;

    if(bribeid == -1)
        return 1;

    FCNPC_UnloadPlayingPlayback(BribeInfo[bribeid][E_BRIBE_NPC_RECORD]);
    BribeInfo[bribeid][E_BRIBE_NPC_RECORD] = FCNPC_LoadPlayingPlayback(BribeInfo[bribeid][E_BRIBE_NPC_NAME]);
    
    FCNPC_StartPlayingPlayback(BribeInfo[bribeid][E_BRIBE_NPC_ID], BribeInfo[bribeid][E_BRIBE_NPC_NAME], BribeInfo[bribeid][E_BRIBE_NPC_RECORD]);

    return Y_HOOKS_CONTINUE_RETURN_1;
}

// NPC-functions;
forward ResumePlayingPlayback(playerid, npcid, bribeid, quantity);
public ResumePlayingPlayback(playerid, npcid, bribeid, quantity)
{
    PlayerMoneySub(playerid, BRIBE_COST*quantity);
    TogglePlayerControllable(playerid, true);
    PI[playerid][p_wanted_level] -= quantity;
    ptdInfoBox_UpdateWantedLevel(playerid);

    if (PI[playerid][p_wanted_level] == 0) // Nema vise WL, izbrisi iz baze
    {
        KillTimer(tajmer:smanji_wl[playerid]);
        ClearPlayerRecord(playerid, true);
    }

    SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Sredio sam posao, udalji se dok nas neko nije uhvatio.", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);
    
    FCNPC_ClearAnimations(npcid);
    FCNPC_ResumePlayingPlayback(npcid);

    KillTimer(NPCResume[npcid]);
    NPCResume[npcid] = -1;
    return 1;
}

forward LoadBribeNPCs();
public LoadBribeNPCs()
{
    BribeInfo[0][E_BRIBE_NPC_ID] = FCNPC_Create("Trevor_Fergas");
    BribeInfo[1][E_BRIBE_NPC_ID] = FCNPC_Create("Soulja_Ganger");
    BribeInfo[2][E_BRIBE_NPC_ID] = FCNPC_Create("Bleachz_Corleone");

    format(BribeInfo[0][E_BRIBE_NPC_NAME], 25, "Trevor_Fergas");
    format(BribeInfo[1][E_BRIBE_NPC_NAME], 25, "Soulja_Ganger");
    format(BribeInfo[2][E_BRIBE_NPC_NAME], 25, "Bleachz_Corleone");

    FCNPC_Spawn(BribeInfo[0][E_BRIBE_NPC_ID], 303, 2635.0852,-1113.8251,67.8448);
    FCNPC_Spawn(BribeInfo[1][E_BRIBE_NPC_ID], 304, 2238.3538,-1906.7137,14.9375);
    FCNPC_Spawn(BribeInfo[2][E_BRIBE_NPC_ID], 305, 1929.8539,-2135.3384,13.6953);

    FCNPC_SetInvulnerable(BribeInfo[0][E_BRIBE_NPC_ID], true);
    FCNPC_SetInvulnerable(BribeInfo[1][E_BRIBE_NPC_ID], true);
    FCNPC_SetInvulnerable(BribeInfo[2][E_BRIBE_NPC_ID], true);

    BribeInfo[0][E_BRIBE_NPC_RECORD] = FCNPC_LoadPlayingPlayback(BribeInfo[0][E_BRIBE_NPC_NAME]);
    BribeInfo[1][E_BRIBE_NPC_RECORD] = FCNPC_LoadPlayingPlayback(BribeInfo[1][E_BRIBE_NPC_NAME]);
    BribeInfo[2][E_BRIBE_NPC_RECORD] = FCNPC_LoadPlayingPlayback(BribeInfo[2][E_BRIBE_NPC_NAME]);
    
    FCNPC_StartPlayingPlayback(BribeInfo[0][E_BRIBE_NPC_ID], BribeInfo[0][E_BRIBE_NPC_NAME], BribeInfo[0][E_BRIBE_NPC_RECORD]);
    FCNPC_StartPlayingPlayback(BribeInfo[1][E_BRIBE_NPC_ID], BribeInfo[1][E_BRIBE_NPC_NAME], BribeInfo[1][E_BRIBE_NPC_RECORD]);
    FCNPC_StartPlayingPlayback(BribeInfo[2][E_BRIBE_NPC_ID], BribeInfo[2][E_BRIBE_NPC_NAME], BribeInfo[2][E_BRIBE_NPC_RECORD]);
    return true;
}

// Additional-functions;
stock GetRandomBribePoint(Float:x, Float:y, Float:z)
{
    new
        bribeid = random(2)
    ;

    FCNPC_GetPosition(BribeInfo[bribeid][E_BRIBE_NPC_ID], x, y, z);
    return 1;
}

stock IsPlayerNearBribeNPC(playerid)
{
    new
        Float:X,
        Float:Y,
        Float:Z
    ;

    for(new i = 0; i < MAX_BRIBE_NPCS; i++)
    {
        FCNPC_GetPosition(BribeInfo[i][E_BRIBE_NPC_ID], X, Y, Z);
        if(IsPlayerInRangeOfPoint(playerid, 3.0, X, Y, Z))
            return i;
    }

    return -1;
}

stock GetBribeFromNPC(npcid)
{
    for(new i = 0; i < MAX_BRIBE_NPCS; i++)
    {
        if(BribeInfo[i][E_BRIBE_NPC_ID] == npcid)
            return i;
    }

    return -1;
}

// Commands;
CMD:bribe(playerid, const params[])
{
    new
        bribeid = IsPlayerNearBribeNPC(playerid),
        quantity
    ;

    if(bribeid == -1)
        return 1;
    
    if(IsACop(playerid))
        return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Ko si ti, jos jedan auslander?", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

    if (RecentPoliceInteraction(playerid))
        return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Prvo se rijesi policije, ne zelim probleme!", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

    foreach (new i : iPolicemen)
    {
        if (IsPlayerNearPlayer(i, playerid, 40.0))
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Policajci su iza ugla, bolje da se udaljimo.", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);
    }

    if(!sscanf(params, "i", quantity))
    {
        if(NPCResume[BribeInfo[bribeid][E_BRIBE_NPC_ID]] != -1)
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Polahko, cemu zurba?", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

        if(!IsPlayerWanted(playerid))
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Tebi ne treba pomoc, odmakni se!", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

        if(quantity < 1)
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Ne zelis pomoc? Uredu.", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

        else if(quantity > 5)
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Ne mogu ti toliko pomoci, zao mi je.", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

        if(GetPlayerMoney(playerid) < BRIBE_COST*quantity)
            return SendClientMessagef(playerid, -1, "{D1D1D1}%s: {FFFFFF}Bez love nista, produzi dalje i nabavi novac!", BribeInfo[bribeid][E_BRIBE_NPC_NAME]);

        FCNPC_PausePlayingPlayback(BribeInfo[bribeid][E_BRIBE_NPC_ID]);
        FCNPC_SetAnimationByName(BribeInfo[bribeid][E_BRIBE_NPC_ID], "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);

        FCNPC_GoToPlayer(BribeInfo[bribeid][E_BRIBE_NPC_ID], playerid, .dist_check = 0.5);
        TogglePlayerControllable(playerid, false);
        NPCResume[BribeInfo[bribeid][E_BRIBE_NPC_ID]] = SetTimerEx("ResumePlayingPlayback", 4000, false, "iiii", playerid, BribeInfo[bribeid][E_BRIBE_NPC_ID], bribeid, quantity);
    }
    return 1;
}
