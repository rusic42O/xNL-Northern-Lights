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





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:prihvati(playerid, const params[]) 
{
    if (!isnull(params) && (!strcmp(params, "mehanicar", true) || !strcmp(params, "mehanicara", true) || !strcmp(params, "popravka", true) || !strcmp(params, "popravku", true) || !strcmp(params, "popravak", true)) )
    {
        return callcmd::acceptmeh(playerid, "");
    }

    if (!isnull(params) && (!strcmp(params, "gorivo", true) || !strcmp(params, "refill", true))) {
        return callcmd::acceptrefill(playerid, "");
    }

    if (!isnull(params) && (!strcmp(params, "new", true) || !strcmp(params, "novi", true)))
    {
        return callcmd::acceptnew(playerid, "");
    }

    if (!isnull(params) && (!strcmp(params, "taxi", true) || !strcmp(params, "taksi", true) || !strcmp(params, "prevoz", true)))
    {
        return callcmd::accepttaxi(playerid, "");
    }

    else {
        Koristite(playerid, "prihvati [Sta prihvatate]");
        SendClientMessage(playerid, GRAD2, "Dostupne opcije: [popravka/mehanicar] [refill/gorivo] [taxi/prevoz]");
        return 1;
    }
}