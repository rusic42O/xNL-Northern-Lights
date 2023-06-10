#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_HITPOINTS (100.0)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new tajmer:updatePlayerHitPoints[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    ptdHitPoints_Create(playerid);
    tajmer:updatePlayerHitPoints[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(tajmer:updatePlayerHitPoints[playerid]);
}

hook OnPlayerSpawn(playerid)
{
    if (tajmer:updatePlayerHitPoints[playerid] == 0)
    {
        tajmer:updatePlayerHitPoints[playerid] = SetTimerEx("HITPOINTS_UpdateGraphic", 700, true, "ii", playerid, cinc[playerid]);
    }

    SetPlayerMaxHealth(playerid, 100.0);
    SetPlayerMaxArmour(playerid, 100.0);
    ptdHitPoints_Show(playerid);
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward HITPOINTS_UpdateGraphic(playerid, ccinc);
public HITPOINTS_UpdateGraphic(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
    {
        KillTimer(tajmer:updatePlayerHitPoints[playerid]);
    }

    new Float:health, Float:armour;
    GetPlayerHealth(playerid, health);
    GetPlayerArmour(playerid, armour);
    if (health < 0.0) health = 0.0;
    if (armour < 0.0) armour = 0.0;

    ptdHitPoints_Show(playerid);
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