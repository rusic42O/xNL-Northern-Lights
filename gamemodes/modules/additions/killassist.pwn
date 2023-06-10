/*
Script name: killAssist.fs
Version: 1d
Author: billz
Thanks to:
BigETI - constructive criticism
NaS - help with loop
*/

#include <a_samp>
#include <YSI_Coding\y_hooks>

#define killAssist@MAX_SLOTS			1	// total amount of people that can have assist on one player


new killAssist[MAX_PLAYERS][killAssist@MAX_SLOTS];

hook OnGameModeInit()
{

	for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++) 
	{
		for(new a; a < killAssist@MAX_SLOTS; a++)
		{
			killAssist[p][a] = INVALID_PLAYER_ID;
		}
	}
    return 1;
}

hook OnGameModeExit()
{
	for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++) 
	{
		for(new a; a < killAssist@MAX_SLOTS; a++)
		{
			killAssist[p][a] = INVALID_PLAYER_ID;
		}
	}
    return 1;	
}

hook OnPlayerConnect(playerid)
{
	for(new a; a < killAssist@MAX_SLOTS; a++)
	{
		killAssist[playerid][a] = INVALID_PLAYER_ID;
	}
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
	for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++) 
	{
		for(new a; a < killAssist@MAX_SLOTS; a++)
		{
			if(killAssist[p][a] == playerid)
			{
				killAssist[p][a] = INVALID_PLAYER_ID;
				break;
			}
		}
	}

	return 1;

}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	new slot = -1;
	
	for(new a; a < killAssist@MAX_SLOTS; a++)
	{
		if(killAssist[playerid][a] == issuerid)
		{
			slot = -1;
			break;
		}
	
		if((slot == -1) && (killAssist[playerid][a] == INVALID_PLAYER_ID))
		{
			slot = a;
		}
	}
	
	if(slot != -1)
	{
		killAssist[playerid][slot] = issuerid;
	}
		
	//printf(" | playerid: %d | slot: %d | value: %d ", playerid, slot, killAssist[playerid][slot]);
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{

    if(IsPlayerConnected(playerid) && IsPlayerConnected(killerid) && IsPlayerInDMArena(playerid) && IsPlayerInDMArena(killerid))
    {
        for(new a; a < killAssist@MAX_SLOTS; a++)
        {
            if(killAssist[playerid][a] == killerid)
            {
                killAssist[playerid][a] = INVALID_PLAYER_ID;
            }

            if((killAssist[playerid][a]!= INVALID_PLAYER_ID) && (killAssist[playerid][a] != killerid))
            {
                OnPlayerKillAssist(killAssist[playerid][a], playerid, killerid);

                killAssist[playerid][a] = INVALID_PLAYER_ID; // keep this last
            }
            else
            {
                new newStr[154], deathid_name[MAX_PLAYER_NAME + 1], killerid_name[MAX_PLAYER_NAME + 1];

                g_PlayerKills[killerid] += 1;
                g_PlayerDeaths[playerid] += 1;

                UpdateDMStats(killerid);
                UpdateDMStats(playerid);

                UpdatePlayerRatio(killerid);
                UpdatePlayerRatio(playerid);

                GetPlayerName(killerid, killerid_name, sizeof killerid_name);
                GetPlayerName(playerid, deathid_name, sizeof deathid_name);
                
                format(newStr, sizeof(newStr), "[DM Arena] {FFFFFF}%s je ubio %s, sada ima ukupno %i killova.", killerid_name, deathid_name, g_PlayerKills[killerid]);

                foreach(new i : Player)
                {
                    if(IsPlayerInDMArena(i))
                        SendClientMessage(i, 0x3c99f0FF, newStr);
                }
            }
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

OnPlayerKillAssist(playerid, deathid, killerid)
{
    if(IsPlayerInDMArena(playerid) && IsPlayerInDMArena(killerid) && IsPlayerInDMArena(deathid))
    {
        new newStr[154], deathid_name[MAX_PLAYER_NAME + 1], killerid_name[MAX_PLAYER_NAME + 1], assister_name[MAX_PLAYER_NAME + 1];

        g_PlayerAssists[playerid] += 1;
        g_PlayerKills[killerid] += 1;
        g_PlayerDeaths[playerid] += 1;

        UpdateDMStats(killerid);
        UpdateDMStats(deathid);
        UpdateDMStats(playerid);

        UpdatePlayerRatio(killerid);
        UpdatePlayerRatio(deathid);
        UpdatePlayerRatio(playerid);

        GetPlayerName(deathid, deathid_name, sizeof deathid_name);
        GetPlayerName(killerid, killerid_name, sizeof killerid_name);
        GetPlayerName(playerid, assister_name, sizeof assister_name);
        
        format(newStr, sizeof(newStr), "[DM Arena] {FFFFFF}%s je ubio %s (assist %s), sada ima ukupno %i killova.", killerid_name, deathid_name, assister_name, g_PlayerKills[killerid]);

        foreach(new i : Player)
        {
            if(IsPlayerInDMArena(i))
                SendClientMessage(i, 0x3c99f0FF, newStr);
        }
    }
    
    return 1;
}