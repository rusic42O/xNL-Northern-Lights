/*
	SA-MP "GetVehicleColor v2.1" Include
	Copyright - 2011 RyDeR`
*/

#if defined _Included_GetVehicleColor
	#endinput
#endif

#define _Included_GetVehicleColor

#define PROPERTY_OFFSET(%0) \
	((((%0) * ((%0) << 1)) << 2) + 65536)

stock n_AddStaticVehicle(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2)
{
	if(color1 < 0 || color2 < 0)
	{
		color1 = random(127);
		color2 = random(127);
	}
	modelID = AddStaticVehicle(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2);
	
	new
		colorStr1[24]
	;	
	format(colorStr1, sizeof(colorStr1), "%d-%d", color1, color2);
	setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr1);
	
	return modelID;
}

stock n_AddStaticVehicleEx(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, bool:addsiren = false)
{
	if(color1 < 0 || color2 < 0)
	{
		color1 = random(127);
		color2 = random(127);
	}
	modelID = AddStaticVehicleEx(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, addsiren);
	
	new
		colorStr2[24]
	;	
	format(colorStr2, sizeof(colorStr2), "%d-%d", color1, color2);
	setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr2);
	
	return modelID;
}

stock n_CreateVehicle(modelID, Float: spawn_X, Float: spawn_Y, Float: spawn_Z, Float: z_Angle, color1, color2, respawn_Delay, bool:addsiren = false)
{
	if(color1 < 0 || color2 < 0)
	{
		color1 = random(127);
		color2 = random(127);
	}
	modelID = CreateVehicle(modelID, spawn_X, spawn_Y, spawn_Z, z_Angle, color1, color2, respawn_Delay, addsiren);
	
	new
		colorStr3[24]
	;	
	format(colorStr3, sizeof(colorStr3), "%d-%d", color1, color2);
	setproperty(_, "", PROPERTY_OFFSET(modelID), colorStr3);
	
	return modelID;
}

stock n_DestroyVehicle(vehicleID)
{
	deleteproperty(_, "", PROPERTY_OFFSET(vehicleID));
	
	return DestroyVehicle(vehicleID);
}

stock n_ChangeVehicleColor(vehicleID, color1, color2)
{
	new
		colorStr4[24]
	;	
	format(colorStr4, sizeof(colorStr4), "%d-%d", color1, color2);
	setproperty(_, "", PROPERTY_OFFSET(vehicleID), colorStr4);
	
	return ChangeVehicleColor(vehicleID, color1, color2);
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	new
		colorStr5[24]
	;	
	format(colorStr5, sizeof(colorStr5), "%d-%d", color1, color2);
	setproperty(_, "", PROPERTY_OFFSET(vehicleid), colorStr5);
	
	if(funcidx("n_OnVehicleRespray") != -1)
	{
		return CallLocalFunction("n_OnVehicleRespray", "iiii", playerid, vehicleid, color1, color2);
	}
	return 1;
}

stock GetVehicleColor_CA(vehicleID, &color1, &color2)
{
	vehicleID = PROPERTY_OFFSET(vehicleID);
	
	if(existproperty(_, "", vehicleID))
	{
		new
			colorStr6[24],
			strPos
		;
		getproperty(_, "", vehicleID, colorStr6);
		strunpack(colorStr6, colorStr6);
		
		if((strPos = strfind(colorStr6, "-")) != -1)
		{
			color1 = strval(colorStr6);
			color2 = strval(colorStr6[strPos + 1]);
			return 1;
		}
	}
	return 0;
}

#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle n_AddStaticVehicle

#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx n_AddStaticVehicleEx

#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle n_CreateVehicle

#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle n_DestroyVehicle

#if defined _ALS_ChangeVehicleColor
    #undef ChangeVehicleColor
#else
    #define _ALS_ChangeVehicleColor
#endif
#define ChangeVehicleColor n_ChangeVehicleColor

#if defined _ALS_OnVehicleRespray
    #undef OnVehicleRespray
#else
    #define _ALS_OnVehicleRespray
#endif
#define OnVehicleRespray n_OnVehicleRespray

forward n_OnVehicleRespray(playerid, vehicleid, color1, color2);