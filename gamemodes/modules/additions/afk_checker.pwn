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
new Float:afkPos[MAX_PLAYERS][3],
    tajmer:AFKCheck[MAX_PLAYERS],
    bool:pAFK[MAX_PLAYERS char],
    pAFK_Timestamp[MAX_PLAYERS]
;



// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)  // pregledao daddyDOT
{
    pAFK{playerid} = false;
    pAFK_Timestamp[playerid] = 0;
    tajmer:AFKCheck[playerid] = 0;
    return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(tajmer:AFKCheck[playerid]), tajmer:AFKCheck[playerid] = 0;
    return true;
}

hook OnPlayerPause(playerid)
{
    SetPlayerAFK(playerid);
}

hook OnPlayerUnPause(playerid)
{
    SetPlayerNotAFK(playerid);
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward OnPlayerAFK(playerid);
public OnPlayerAFK(playerid)
{
    return 1;
}

forward OnPlayerAFK_Back(playerid);
public OnPlayerAFK_Back(playerid)
{
    return 1;
}

stock IsPlayerAFK(playerid)
{
    return pAFK{playerid};
}

stock GetPlayerAFKTime(playerid)
{
    if (pAFK{playerid})
    {
        return (gettime() - pAFK_Timestamp[playerid]);
    }
    else
    {
        return 0;
    }
}

stock SetPlayerAFK(playerid)
{
    CallRemoteFunction("OnPlayerAFK", "i", playerid); 

    pAFK{playerid} = true;
    pAFK_Timestamp[playerid] = gettime();

    // PAYDAY_PlayerWentAFK(playerid); // dodaje minute do plate
}

stock SetPlayerNotAFK(playerid)
{
    CallRemoteFunction("OnPlayerAFK_Back", "i", playerid); 

    pAFK{playerid} = false;
    pAFK_Timestamp[playerid] = 0;

    // PAYDAY_PlayerCameBack(playerid); // vraca minute do plate
}

stock StartAFKChecker(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("StartAFKChecker");
    }

    GetPlayerPos(playerid, afkPos[playerid][0], afkPos[playerid][1], afkPos[playerid][2]);
    tajmer:AFKCheck[playerid] = SetTimerEx("AFKCheck", 180*1000, true, "ii", playerid, cinc[playerid]);
}

forward AFKCheck(playerid, ccinc);
public AFKCheck(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("AFKCheck");
    }

    if (!checkcinc(playerid, ccinc))
    {
        KillTimer(tajmer:AFKCheck[playerid]), tajmer:AFKCheck[playerid] = 0;
        return 1;
    }

    new Float:pos[3];
    pos[0] = afkPos[playerid][0];
    pos[1] = afkPos[playerid][1];
    pos[2] = afkPos[playerid][2];
    GetPlayerPos(playerid, afkPos[playerid][0], afkPos[playerid][1], afkPos[playerid][2]);

    if (afkPos[playerid][0] == pos[0] && afkPos[playerid][1] == pos[1] && afkPos[playerid][2] == pos[2])
    {
        // Prvi put smo detektovali da je igrac otisao AFK (barem 3 minuta stoji u istom mestu (realno oko 5 minuta))
        if (!IsPlayerAFK(playerid) && !IsPlayerRobbingBank(playerid) && !IsPlayerRobbingJewelry(playerid)) 
        {
            SetPlayerAFK(playerid);

            // Stopiracemo trenutni tajmer i zapocecemo novi - sa manjim intervalom (7sec umesto 3min) kako bismo brze detektovali povratak u igru
            KillTimer(tajmer:AFKCheck[playerid]);
            tajmer:AFKCheck[playerid] = SetTimerEx("AFKCheck", 7*1000, true, "ii", playerid, cinc[playerid]);
        }
    }

    else if (IsPlayerAFK(playerid) && (afkPos[playerid][0] != pos[0] || afkPos[playerid][1] != pos[1] || afkPos[playerid][2] != pos[2]))
    {
        // Igrac je bio AFK, ali se pomerio, odnosno vratio se u igru, sporiti mu tajmer
        SetPlayerNotAFK(playerid);

        // Vracamo tajmer na 3 minuta
        KillTimer(tajmer:AFKCheck[playerid]);
        tajmer:AFKCheck[playerid] = SetTimerEx("AFKCheck", 180*1000, true, "ii", playerid, cinc[playerid]);
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
