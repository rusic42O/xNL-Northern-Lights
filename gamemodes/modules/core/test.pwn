#include <YSI_Coding\y_hooks>

CMD:setfuel(playerid, params[]) 
{
    if (!IsAdmin(playerid, 6)) return 1;
    new Float:fuel;
    if (sscanf(params, "f", fuel))
    	return Koristite(playerid, "setfuel [Kolicina goriva]");

    if (fuel < 0 || fuel > 55)
    	return ErrorMsg(playerid, "Kolicina goriva mora biti izmedju 0 i 55 litara.");
    
    SetVehicleFuel(GetPlayerVehicleID(playerid), fuel);
    return 1;
}

// CMD:mark(playerid, params[])
// {
// 	new Float:locations[][3] = {
// 		{-399.3784,-422.3250,16.2109},    
// 		{276.2390,4.1372,2.4334},         
// 		{760.6530,378.5914,23.1711},      
// 		{2329.4978,-52.3102,26.4844},     
// 		{2351.5657,-650.3878,128.0547},   
// 		{2446.2932,-1900.8821,13.5469},   
// 		{-383.9338,-1040.1874,58.8887},   
// 		{-1080.4553,-1296.7692,129.2188}, 
// 		{-1446.7141,-1543.2937,101.7578}, 
// 		{687.2717,-444.7280,16.3359}
// 	};

// 	for__loop (new i = 0; i < sizeof locations; i++)
// 	{
// 		SetPlayerMapIcon(playerid, 10+i, locations[i][0], locations[i][1], locations[i][2], 0, 0xFF0000FF, MAPICON_GLOBAL);
// 	}
// 	return 1;
// }