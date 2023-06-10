#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //

//static tajmer:voziloTajmer;



// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //

hook OnGameModeInit() 
{
    SetTimer("voziloServisTajmer", 10000, true);//tajmer:voziloTajmer = 
	return 1;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //


forward voziloServisTajmer();
public voziloServisTajmer()
{
    new alarm, doors, bonnet, boot, objective;
    new rnd;
    rnd = random(MAX_PLAYERS);
    foreach(new i : Player)
    {
        if(IsPlayerInAnyVehicle(i))
        {
            foreach (new n : iOwnedVehicles) 
            {
                new vehId;

                vehId = GetPlayerVehicleID(i);

                if(OwnedVehicle[n][V_ID] == vehId)
                {
                    if(OwnedVehicle[n][V_STEPENPOK] > 0)
                    {
                        if(rnd == i)
                        {
                            SetVehicleParamsEx(vehId, 0, 0, alarm, doors, bonnet, boot, objective);
                            SetVehicleHealth(vehId, 300);
                        }
                        
                        //printf("%f - %d - %d", OwnedVehicle[n][V_STEPENPOK], vehId, OwnedVehicle[n][V_ID]);
                    }
                }
            }
        }
    }
    return 1;
}


// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
