new 
	world_time, 
	global_weather,
	bool:kicked[MAX_PLAYERS char]
; 


forward Ban_H(playerid);
public Ban_H(playerid) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "Ban_H");
	#endif

	if (!IsPlayerConnected(playerid)) return 1;

	new query[110], ip[16];
    GetPlayerIp(playerid, ip, sizeof ip);
    mysql_format(SQL, query, sizeof query, "INSERT INTO ip_banovi VALUES ('%s', %i) ON DUPLICATE KEY UPDATE vreme = %i", ip, gettime(), gettime());
    mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_BANIP);
	Kick_Timer(playerid);
	return 1;
}

forward Kick_H(playerid, ccinc);
public Kick_H(playerid, ccinc) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "Kick_H");
	#endif

	if (!IsPlayerConnected(playerid) || (ccinc != -1 && !checkcinc(playerid, ccinc))) return 1;

	kicked{playerid} = true;
	tajmer:kick[playerid] = 0;
	Kick(playerid);
	return 1;
}

stock SetWeather_H(weatherid) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "SetWeather_H");
	#endif

	SetWeather(weatherid);
	global_weather = weatherid;

	return 1;
}

stock GetWeather_H() 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "GetWeather_H");
	#endif

	return global_weather;
}

stock TogglePlayerControllable_H(playerid, bool:toggle) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "TogglePlayerControllable_H");
	#endif

    if (!IsPlayerConnected(playerid)) return 1;
    // kod ovde
    if (toggle == false) zamrznut{playerid} = true, SetPVarInt(playerid, "zamrznut", 1);
    else zamrznut{playerid} = false, SetPVarInt(playerid, "zamrznut", 0);
	return TogglePlayerControllable(playerid, toggle);
}

stock TogglePlayerSpectating_H(playerid, bool:toggle) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "TogglePlayerSpectating_H");
	#endif
    
	return TogglePlayerSpectating(playerid, toggle);
}

stock SpawnPlayer_H(playerid) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "SpawnPlayer_H");
	#endif

	if (!IsPlayerConnected(playerid)) return 1;
	SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);
	return SpawnPlayer(playerid);
}

stock __timer_ex(const funcname[], interval, repeating, timerid) 
{
 //   	#if defined DEBUG_TIMERS
	// 	printf("[debug] Extended timer started! ID: %d, function: %s, interval: %d, repeating: %d", timerid, funcname, interval, repeating);
	// #endif

    #pragma unused funcname
    #pragma unused interval
    #pragma unused repeating

	return timerid;
}

stock PutPlayerInVehicle_H(playerid, vehicleid, seatid) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "PutPlayerInVehicle_H");
	#endif

	if (vehicleid == INVALID_VEHICLE_ID) return 1;

	return PutPlayerInVehicle(playerid, vehicleid, seatid);
}

stock SetWorldTime_H(hour) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "SetWorldTime_H");
	#endif

	world_time = hour;
	SetWorldTime(hour);

	return 1;
}

stock GetWorldTime_H() 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "GetWorldTime_H");
	#endif

	return world_time;
}

/*stock SendClientMessageToAll(color, const message[])
{
	foreach (new i : Player)
	{
		if (IsPlayerLoggedIn(i))
		{
			SendClientMessage(i, color, message);
		}
	}
}*/

stock NL_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
	pAttachedObjects[playerid][index] = modelid;

	return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);
}

stock NL_RemovePlayerAttachedObject(playerid, index)
{
	pAttachedObjects[playerid][index] = -1;

	return RemovePlayerAttachedObject(playerid, index);
}


#if defined _ALS_SetPlayerAttachedObject
    #undef SetPlayerAttachedObject
#else
    #define _ALS_SetPlayerAttachedObject
#endif
#define SetPlayerAttachedObject NL_SetPlayerAttachedObject

#if defined _ALS_RemovePlayerAttachedObject
    #undef RemovePlayerAttachedObject
#else
    #define _ALS_RemovePlayerAttachedObject
#endif
#define RemovePlayerAttachedObject NL_RemovePlayerAttachedObject