#include <YSI_Coding\y_timers>
#include <YSI_Coding\y_hooks>

#define TIME_DIF 2000 //Decreasing will make it more accurate, leave it like that, it's fine.

forward C_Paused(playerid);

forward OnPlayerPause(playerid);
forward OnPlayerUnPause(playerid);

new g_Paused[MAX_PLAYERS];
new bool:g_Requesting[MAX_PLAYERS char];
new bool:g_IsPaused[MAX_PLAYERS char];
new g_PauseDetected[MAX_PLAYERS];

hook OnPlayerConnect(playerid)    // pregledao daddyDOT
{
    g_PauseDetected[playerid] = 0;
    g_IsPaused{playerid} = false;
    g_Requesting{playerid} = false;
    return 1;
}

hook OnPlayerUpdate(playerid)
{
    g_Paused[playerid] = GetTickCount();
    return 1;
}

hook OnPlayerRequestClass(playerid, classid)
{
    g_Requesting{playerid} = true;
    g_IsPaused{playerid} = false;
}

hook OnPlayerDisconnect(playerid)
{
    g_Requesting{playerid} = false;
    g_IsPaused{playerid} = false;
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    g_Requesting{playerid} = false;
    g_IsPaused{playerid} = false;
    return 1;
}

public C_Paused(playerid)
{
    if(GetTickCount()-g_Paused[playerid] > TIME_DIF && g_Requesting{playerid} != true && g_IsPaused{playerid} != true && InvalidStates(playerid) != 1)
    {
        g_PauseDetected[playerid]++;
        if (g_PauseDetected[playerid] >= 3)
        {
            CallRemoteFunction("OnPlayerPause", "i", playerid); 
            g_IsPaused{playerid} = true;
        }
    }
    else if(GetTickCount()-g_Paused[playerid] < TIME_DIF && g_Requesting{playerid} != true && g_IsPaused{playerid} != false && InvalidStates(playerid) != 1)
    {
        // OnPlayerUnPause(playerid);
        CallRemoteFunction("OnPlayerUnPause", "i", playerid); 
        g_IsPaused{playerid} = false;
        g_PauseDetected[playerid] = 0;
    }
    return 1;
}

stock IsPlayerPaused_OW(playerid) 
{
    return g_IsPaused{playerid}; 
}

stock InvalidStates(playerid)
{
    new pState = GetPlayerState(playerid);
    if(pState == 0 || pState == 7) return 1;
    else return 0;
}

stock GetPlayerPausedTime_OW(playerid)
{
    if (!IsPlayerPaused_OW(playerid)) return 0;

    return floatround((GetTickCount() - g_Paused[playerid])/1000);
}

task PauseUpdate[1000]() 
{ 
    foreach(new i : Player) 
    { 
        C_Paused(i); 
    } 
}

public OnPlayerPause(playerid) 
{ 
    return 1;
}
public OnPlayerUnPause(playerid) 
{ 
    return 1;
}