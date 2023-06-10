#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new gLastDrivenVehicle[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
	gLastDrivenVehicle[playerid] = INVALID_VEHICLE_ID;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (oldstate == PLAYER_STATE_DRIVER) 
    {
		if (newstate != PLAYER_STATE_ONFOOT)
        {
            gLastDrivenVehicle[playerid] = INVALID_VEHICLE_ID;
        }
	}

	else if (newstate == PLAYER_STATE_DRIVER) 
    {
        gLastDrivenVehicle[playerid] = GetPlayerVehicleID(playerid);
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
GetPlayerLastDrivenVehicleID(playerid)
{
	return gLastDrivenVehicle[playerid];
}

// Vehicle_CanHaveNitro(modelid)
// {
//     new disallowedVehicles[] = {430, 446, 448, 449, 452, 453, 454, 461, 462, 463, 468, 472, 473, 481, 484, 493, 509, 510, 521, 522, 523, 537, 538, 569, 570, 581, 586, 590, 595, 430, 446, 448, 449, 452, 453, 454, 461, 462, 463, 468, 472, 473, 481, 484, 493, 509, 510, 521, 522, 523, 537, 538, 569, 570, 581, 586, 590, 595};

//     new bool:allowed = true;
//     for__loop (new i = 0; i < sizeof disallowedVehicles; i++)
//     {
//         if (modelid == disallowedVehicles[i])
//         {
//             allowed = false;
//             break;
//         }
//     }

//     return allowed;
// }




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
