#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bool:gHungerWarned[MAX_PLAYERS char]
;




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    SetTimer("povecaj_glad", 140*1000, true);

    // tdBurger = TextDrawCreate(553.058166, 35.1167425, "hud:radar_burgerShot");
    // TextDrawTextSize(tdBurger, -8.000000, 9.000000);
    // TextDrawAlignment(tdBurger, 1);
    // TextDrawColor(tdBurger, -1);
    // TextDrawSetShadow(tdBurger, 0);
    // TextDrawBackgroundColor(tdBurger, 255);
    // TextDrawFont(tdBurger, 4);
    // TextDrawSetProportional(tdBurger, 0);

    // tdBurger = TextDrawCreate(550.820556, 25.293344, "hud:radar_burgershot");
    // TextDrawTextSize(tdBurger, 10.000000, 11.000000);
    // TextDrawAlignment(tdBurger, 1);
    // TextDrawColor(tdBurger, -1);
    // TextDrawSetShadow(tdBurger, 0);
    // TextDrawBackgroundColor(tdBurger, 255);
    // TextDrawFont(tdBurger, 4);
    // TextDrawSetProportional(tdBurger, 0);
    return true;
}

hook OnPlayerConnect(playerid) 
{
    gHungerWarned{playerid} = false;
}

// hook OnPlayerSpawn(playerid) 
// {
//     TextDrawShowForPlayer(playerid, tdBurger);
//     PlayerTextDrawShow(playerid, ptdGlad[playerid]);
//     gHungerWarned{playerid} = false;
// }

// hook OnPlayerDeath(playerid, killerid, reason)
// {
//     TextDrawHideForPlayer(playerid, tdBurger);
//     PlayerTextDrawHide(playerid, ptdGlad[playerid]);
// }




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward povecaj_glad(); // Tajmer
public povecaj_glad() 
{
    foreach(new i : Player) 
    {
        if (!IsPlayerLoggedIn(i) || IsPlayerInRace(i) || IsOnDuty(i) || IsPlayerJailed(i) || IsPlayerInWar(i) || IsAdmin(i, 6) || IsPlayerHandcuffed(i) || IsPlayerRopeTied(i) || IsPlayerInDMEvent(i) || IsPlayerInHorrorEvent(i)) continue;

        PlayerHungerIncrease(i, 1);
    }
    return 1;
}

stock PlayerHungerIncrease(playerid, amount)
{
    PI[playerid][p_glad] += amount;
    if (PI[playerid][p_glad] > 100)
    {
        PI[playerid][p_glad] = 100;
    }
    PlayerHungerUpdate(playerid);
}

stock PlayerHungerDecrease(playerid, amount)
{
    PI[playerid][p_glad] -= amount;
    if (PI[playerid][p_glad] < 0)
    {
        PI[playerid][p_glad] = 0;
    }

    PlayerHungerUpdate(playerid);
}

forward PlayerHungerUpdate(playerid);
public PlayerHungerUpdate(playerid)
{
    if (PI[playerid][p_glad] >= 100) 
    {
        SendClientMessage(playerid, TAMNOCRVENA, "Umrli ste od gladi!");
        
        PI[playerid][p_glad] = 0;
        SetPlayerHealth(playerid, 0.0);
        // PlayerTextDrawSetString(playerid, ptdGlad[playerid], "0%");
    }
    else if (PI[playerid][p_glad] > 95 && PI[playerid][p_glad] < 100 && !gHungerWarned{playerid}) 
    {
        SendClientMessage(playerid, TAMNOCRVENA2, "Vas procenat gladi je veci od 95%%. Morate jesti u najblizem restoranu kako ne biste umrli od gladi!");
        
        gHungerWarned{playerid} = true;
    }
    else if (PI[playerid][p_glad] < 0)
    {
        PI[playerid][p_glad] = 0;
    }
    
    UpdateHungerMainGui(playerid, PI[playerid][p_glad]);
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
