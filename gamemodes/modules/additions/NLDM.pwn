
#include <YSI_Coding\y_hooks>

new 
	bool:warStarted,
	joinedWar[MAX_PLAYERS],
	warTimer,
	warTime,
    Float:oldpos[MAX_PLAYERS][3];

new Float:randomWarPositions[9][3] = 
{
	{ -433.3674,2253.2629,42.4297 },
	{ -408.6185,2261.9001,42.4196 },
	{ -364.8165,2264.3884,42.4844 },
	{ -350.4330,2238.5701,42.4844 },
	{ -348.2400,2222.4565,42.4912 },
	{ -359.5164,2204.2878,42.4844 },
	{ -388.5855,2199.1855,42.4234 },
	{ -400.2693,2225.5200,42.4297 },
	{ -395.9157,2214.8225,42.4297 }
};

hook OnGameModeInit()
{
	warStarted = false;
	warTime = 0;
	return 1;
}

hook OnPlayerConnect(playerid)
{
	joinedWar[playerid] = false;
	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	if(warStarted && joinedWar[playerid])
	{
		SendClientMessageFToAll(0xf71130FF, "[WAR - FFA EVENT]: {FFFFFF}%s je ubio %s", ime_rp[killerid], ime_rp[playerid]);
        SetPVarInt(playerid, "pIgnoreDeathFine", 1);
    }
	return 1;
}

hook OnPlayerSpawn(playerid)
{
	if(joinedWar[playerid])
	{
		new
 			rPlayerWar = random(9);
 		SetPlayerCompensatedPos(playerid, randomWarPositions[rPlayerWar][0], randomWarPositions[rPlayerWar][1], randomWarPositions[rPlayerWar][2]);
	}
	return 1;
}

forward EndWarEvent();
public EndWarEvent()
{
	SendClientMessageToAll(0xf71130FF, "[WAR - FFA EVENT]: {FFFFFF}Event je zavrsen.");
	KillTimer(warTimer);
	return 1;
}

flags:startwar(FLAG_HELPER_1)
CMD:startwar(playerid, params[])
{
	new
		warMinutes;

	if(warStarted) return ErrorMsg(playerid, "War je u toku!");
	if(sscanf(params, "i", warMinutes)) return Koristite(playerid, "startwar [minute]");

	warTime = warMinutes*60000;
	warStarted = true;
	warTimer = SetTimer("EndWarEvent", warTime, false);
	SendClientMessageFToAll(0xf71130FF, "[WAR - FFA EVENT]: {FFFFFF}%s je pokrenuo war event na %d minuta. Kucajte /joinwar da se pridruzite.", ime_rp[playerid], warMinutes);
	return 1;
}

CMD:joinwar(playerid)
{
 	new
 		rPlayerWar = random(9);

 	if(joinedWar[playerid]) return ErrorMsg(playerid, "Vec ste nalazis na FFA War eventu!");
 	if(!warStarted) return ErrorMsg(playerid, "FFA War event nije u toku...");
    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici na event!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli na event!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na event dok pljackate zlataru!");

    if (IsPlayerRobbingBank(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na event dok pljackate banku!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete se prijaviti na event jer ste zavezani ili uhapseni.");

    GetPlayerPos(playerid, oldpos[playerid][0], oldpos[playerid][1], oldpos[playerid][2]);
    SetPlayerVirtualWorld(playerid, 135);

 	SetPlayerCompensatedPos(playerid, randomWarPositions[rPlayerWar][0], randomWarPositions[rPlayerWar][1], randomWarPositions[rPlayerWar][2]);
 	InfoMsg(playerid, "Usli na ste na war event!");
 	joinedWar[playerid] = true;
	return 1;
}

CMD:leavewar(playerid)
{
    if(joinedWar[playerid])
    {
        SetPlayerCompensatedPos(playerid, oldpos[playerid][0], oldpos[playerid][1], oldpos[playerid][2]);
        oldpos[playerid][0] = oldpos[playerid][1] = oldpos[playerid][2] = 0.0;
        joinedWar[playerid] = false;
    }
    else
        return ErrorMsg(playerid, "Nisi u FFA War eventu.");
	return 1;
}