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
new
    MARKET_playerRobbing[MAX_PLAYERS],
    tajmer:marketRobbery[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    MARKET_playerRobbing[playerid] = -1;
    tajmer:marketRobbery[playerid] = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(tajmer:marketRobbery[playerid]), tajmer:marketRobbery[playerid] = 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward OnPlayerTargetMarketClerk(playerid, actorid, gid);
public OnPlayerTargetMarketClerk(playerid, actorid, gid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("OnPlayerTargetMarketClerk");
    }

    if (IsACop(playerid))
        return 1;
    
    if (MARKET_playerRobbing[playerid] == -1)
    {
        MARKET_playerRobbing[playerid] = gid;
        SetTimerEx("MARKET_StartActorAnim", 5000, false, "iii", playerid, actorid, gid);

        SendClientMessage(playerid, SVETLOCRVENA, "Ukoliko sklonite nisan sa prodavca, pljacka propada!");
    }
    return 1;
}

forward MARKET_StartActorAnim(playerid, actorid, gid);
public MARKET_StartActorAnim(playerid, actorid, gid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MARKET_StartActorAnim");
    }

    if (actorHandsUp{actorid})
    {
        if (PI[playerid][p_reload_market] > gettime())
        {
            MARKET_playerRobbing[playerid] = -1;
            ErrorMsg(playerid, "Nedavno ste vec pljackali neki market. Pokusajte ponovo za %s.", konvertuj_vreme(PI[playerid][p_reload_market] - gettime()));
            return 1;
        }


        if (RealEstate[gid][RE_ROBBERY_COOLDOWN] < gettime())
        {
            ApplyDynamicActorAnimation(actorid, "SHOP", "SHP_Serve_Loop", 4.1, 1, 0, 0, 0, 0);
            RealEstate[gid][RE_ROBBERY_COOLDOWN] = gettime() + 1800;

            ptdMarketRob_Create(playerid);
            ptdMarketRob_UpdateProgress(playerid, 0);

            // Odredjujemo brzinu pljackanja na osnovu skill-a
            new robbingPace = 1100 - 150*GetPlayerLevel_StoreRobbery(playerid); // vreme u milisekundama; svakim tick-om se procenat povecava za 1

            if (robbingPace < 300) robbingPace = 300; // za svaki slucaj, da ne bude prebrzo

            SetPVarInt(playerid, "pMarketRobberyProgress", 0);
            tajmer:marketRobbery[playerid] = SetTimerEx("MARKET_RobberyProgress", robbingPace, true, "iii", playerid, actorid, gid);

            // Upisivanje u log
            new logStr[64];
            format(logStr, sizeof logStr, "MARKET-START | %s | %i", ime_obicno[playerid], gid);
            Log_Write(LOG_ROBBERY, logStr);
        }
        else
        {
            MARKET_playerRobbing[playerid] = -1;
            ErrorMsg(playerid, "Ovaj market je nedavno vec opljackan.");
        }
    }
    return 1;
}

forward MARKET_RobberyProgress(playerid, actorid, gid);
public MARKET_RobberyProgress(playerid, actorid, gid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MARKET_RobberyProgress");
    }

    if (!actorHandsUp{actorid} || random(1300) == 1151) // mala sansa za neuspeh
    {
        KillTimer(tajmer:marketRobbery[playerid]), tajmer:marketRobbery[playerid] = 0;
        MARKET_playerRobbing[playerid] = -1;

        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 2, "Pljacka marketa", "Snimak sa nadzorne kamere");
        ptdMarketRob_Destroy(playerid);
        SendClientMessage(playerid, TAMNOCRVENA, "Pljacka je propala, prodavac je uspeo da aktivira alarm!");
        ClearDynamicActorAnimations(actorid);

        // Upisivanje u log
        new logStr[64];
        format(logStr, sizeof logStr, "MARKET-FAIL | %s | %i", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);
    }
    else
    {
        UpdatePVarInt(playerid, "pMarketRobberyProgress", 1); 
        ptdMarketRob_UpdateProgress(playerid, GetPVarInt(playerid, "pMarketRobberyProgress"));

        if (GetPVarInt(playerid, "pMarketRobberyProgress") > 100)
        {
            // Zavrsena pljacka
            KillTimer(tajmer:marketRobbery[playerid]), tajmer:marketRobbery[playerid] = 0; 
            MARKET_playerRobbing[playerid] = -1;
            ptdMarketRob_Destroy(playerid);

            new money = 3000 + random(5000);
            money += (GetPlayerLevel_StoreRobbery(playerid)-1)*1200; // bonus za skill

            PlayerMoneyAdd(playerid, money);
            SendClientMessageF(playerid, SVETLOZELENA, "Pljacka je uspesna! Ukrali ste: {FFFFFF}%s.", formatMoneyString(money));

            // Update ukupne zarade
            PI[playerid][p_stores_stolen_cash] += money;
            new query[68];
            format(query, sizeof query, "UPDATE igraci SET stores_stolen_cash = %i WHERE id = %i", PI[playerid][p_stores_stolen_cash], PI[playerid][p_id]);
            mysql_tquery(SQL, query);

            PlayerUpdateCriminalSkill(playerid, 1, SKILL_ROBBERY_247, 0);

            if (random(101) > 65) // 35% sanse da se aktivira alarm
            {
                AddPlayerCrime(playerid, INVALID_PLAYER_ID, 2, "Pljacka marketa", "Snimak sa nadzorne kamere");
                SendClientMessage(playerid, SVETLOCRVENA, "Prodavac je aktivirao alarm, cuvajte se policije!");
            }

            // Upisivanje u log
            new logStr[64];
            format(logStr, sizeof logStr, "MARKET-USPEH | %s | %s", ime_obicno[playerid], formatMoneyString(money));
            Log_Write(LOG_ROBBERY, logStr);
        }
    }

    PI[playerid][p_reload_market] = gettime() + 600;

    new query[60];
    format(query, sizeof query, "UPDATE igraci SET reload_market = %i WHERE id = %i", PI[playerid][p_reload_market], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

stock GetPlayerLevel_StoreRobbery(playerid)
{
    new robbedStores = PI[playerid][p_robbed_stores], 
        level = floatround(robbedStores/50.0, floatround_ceil);

    return level;
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
