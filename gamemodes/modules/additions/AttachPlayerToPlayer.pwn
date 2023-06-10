#define WALK_SLOW


#if !defined WALK_FAST && !defined WALK_SLOW 
    #error "Please define WALK_FAST or WALK_SLOW." 
#endif 


#if defined WALK_FAST 
    #define WALK_SPEED true 
#else 
    #define WALK_SPEED false 
#endif 


#include <YSI_Coding\y_hooks>

new 
    tmrPlayerFollowingPlayer[MAX_PLAYERS],
    bool:pFollowingStopped[MAX_PLAYERS char],
    bool:pPlayerFollowingPlayer[MAX_PLAYERS char],
    
    pAttachedTo[MAX_PLAYERS], // koji igrac ga vuce
    pAttachedPlayerID[MAX_PLAYERS]; // kog igraca vuce

hook OnPlayerConnect(playerid)    // pregledao daddyDOT
{
    tmrPlayerFollowingPlayer[playerid] = 0;
    pFollowingStopped{playerid} = false;
    pPlayerFollowingPlayer{playerid} = false;

    pAttachedPlayerID[playerid] = pAttachedTo[playerid] = INVALID_PLAYER_ID;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(tmrPlayerFollowingPlayer[playerid]);


    if (IsPlayerConnected(pAttachedTo[playerid]) && pAttachedPlayerID[pAttachedTo[playerid]] == playerid)
    {
        StopPullingPlayer(pAttachedTo[playerid]);
    }

    if (IsPlayerConnected(pAttachedPlayerID[playerid]) && pAttachedTo[pAttachedPlayerID[playerid]] == playerid)
    {
        StopFollowingPlayer(pAttachedPlayerID[playerid]);
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    KillTimer(tmrPlayerFollowingPlayer[playerid]);


    if (IsPlayerConnected(pAttachedTo[playerid]) && pAttachedPlayerID[pAttachedTo[playerid]] == playerid)
    {
        StopPullingPlayer(pAttachedTo[playerid]);
    }

    if (IsPlayerConnected(pAttachedPlayerID[playerid]) && pAttachedTo[pAttachedPlayerID[playerid]] == playerid)
    {
        StopFollowingPlayer(pAttachedPlayerID[playerid]);
    }
}

hook OnPlayerSpawn(playerid)
{
    KillTimer(tmrPlayerFollowingPlayer[playerid]);


    if (IsPlayerConnected(pAttachedTo[playerid]) && pAttachedPlayerID[pAttachedTo[playerid]] == playerid)
    {
        StopPullingPlayer(pAttachedTo[playerid]);
    }

    if (IsPlayerConnected(pAttachedPlayerID[playerid]) && pAttachedTo[pAttachedPlayerID[playerid]] == playerid)
    {
        StopFollowingPlayer(pAttachedPlayerID[playerid]);
    }
}

stock MovePlayer(playerid, bool:speed) 
{ 
    return (!speed) ? ApplyAnimation(playerid, "ped", "WALK_civi",4.1,1,1,1,1,0) : ApplyAnimation(playerid, "ped", "sprint_civi",4.1,1,1,1,1,0); 
} 

stock AttachPlayerToPlayer(playerid, attachplayerid) 
{ 
    if(IsPlayerInAnyVehicle(attachplayerid) || pAttachedPlayerID[playerid] != INVALID_PLAYER_ID || pAttachedTo[attachplayerid] != INVALID_PLAYER_ID) return 0; 

    new Float:angle;
    GetPlayerFacingAngle(playerid, angle); 
    SetPlayerFacingAngle(attachplayerid, angle),
    MovePlayer(attachplayerid, WALK_SPEED); 

    pAttachedPlayerID[playerid] = attachplayerid;
    pAttachedTo[attachplayerid] = playerid;

    tmrPlayerFollowingPlayer[playerid] = SetTimerEx("PlayerFollowingPlayer", 500, true, "ii", playerid, attachplayerid);
    pPlayerFollowingPlayer{attachplayerid} = true; 
    return 1; 
}

stock StopFollowingPlayer(playerid) 
{
    if (!IsPlayerHandcuffed(playerid) && !IsPlayerRopeTied(playerid))
    {
        TogglePlayerControllable_H(playerid, true);
        ClearAnimations(playerid);
    }
    pPlayerFollowingPlayer{playerid} = false; 
    
    if (IsPlayerConnected(pAttachedTo[playerid]))
        pAttachedPlayerID[pAttachedTo[playerid]] = INVALID_PLAYER_ID;

    pAttachedTo[playerid] = INVALID_PLAYER_ID;
    KillTimer(tmrPlayerFollowingPlayer[playerid]);
}

stock StopPullingPlayer(playerid)
{
    if (pAttachedPlayerID[playerid] != INVALID_PLAYER_ID)
    {
        StopFollowingPlayer(pAttachedPlayerID[playerid]);
    }
}

stock IsPlayerPullingPlayer(playerid)
{
    if (IsPlayerConnected(pAttachedPlayerID[playerid])) return 1;
    else return 0;
}

stock IsPlayerAttachedToPlayer(playerid)
{
    if (IsPlayerConnected(pAttachedTo[playerid])) return 1;
    else return 0;
}

forward PlayerFollowingPlayer(leadingplayerid, followingplayerid);
public PlayerFollowingPlayer(leadingplayerid, followingplayerid) 
{ 
    if(!pPlayerFollowingPlayer{followingplayerid} || IsPlayerInAnyVehicle(leadingplayerid) || IsPlayerInAnyVehicle(followingplayerid) || !IsPlayerConnected(leadingplayerid) || !IsPlayerConnected(followingplayerid)) 
    {
        pPlayerFollowingPlayer{followingplayerid} = false; 
        KillTimer(tmrPlayerFollowingPlayer[followingplayerid]);
        return 1;
    }

    new Float:pos[4];
    GetPlayerPos(leadingplayerid, pos[POS_X], pos[POS_Y], pos[POS_Z]);
    GetPlayerFacingAngle(leadingplayerid, pos[POS_A]);

    if(IsPlayerInRangeOfPoint(followingplayerid, 5.0, pos[POS_X], pos[POS_Y], pos[POS_Z]))
    {
        TogglePlayerControllable_H(followingplayerid, false);
        pFollowingStopped{followingplayerid} = true; 
        return 1;
    }

    if (pFollowingStopped{followingplayerid}) 
    { 
        TogglePlayerControllable_H(followingplayerid,true);
        MovePlayer(followingplayerid,WALK_SPEED);
        pFollowingStopped{followingplayerid} = false; 
    } 

    SetPlayerInterior(followingplayerid, GetPlayerInterior(leadingplayerid));
    SetPlayerVirtualWorld(followingplayerid, GetPlayerVirtualWorld(leadingplayerid));
    SetPlayerPos(followingplayerid, pos[POS_X] + 1.5*floatcos(90-pos[POS_A], degrees), pos[POS_Y] - 1.5*floatsin(90-pos[POS_A], degrees), pos[POS_Z]);
    SetPlayerFacingAngle(followingplayerid, pos[POS_A]);
    return 1;
}  