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





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward GOLD_DiggingReload();
public GOLD_DiggingReload()
{
    if (DebugFunctions())
    {
        LogFunctionExec("GOLD_DiggingReload");
    }

    for__loop (new i = 0; i < sizeof DRUGS_PACKAGES; i++)
    {
        // Resetovanje
        DRUGS_PACKAGES[i][DRUGS_PCK_COLLECTED] = false;


        // Kreiranje paketa
        DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID] = CreateDynamicPickup(1279, 1, DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_X], DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_Y], DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_Z], 0, 0);
    }

    // Obavestenje za sve igrace
    foreach (new i : Player)
    {
        if (IsPlayerLoggedIn(i))
            SendClientMessage(i, CRVENA, "[DILER] {FFFF80}Paketi sa hemijskim preparatima su isporuceni na svim lokacijama.");
            // SendClientMessage(i, ZUTA, "*** Paketi sa hemijskim preparatima su isporuceni na svim lokacijama.");
    }

    // Tajmer za sledeci drop
    SetTimer("GOLD_DiggingReload", (3600 - 400 + random(800))*1000, false);

    Log_Write(LOG_MEDSPACKAGE, "--------- [ NOVI DROP ] ---------");
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
