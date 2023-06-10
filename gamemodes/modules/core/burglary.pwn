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
new PlayerBar:BURGLARY_EfficiecyBar[MAX_PLAYERS],
    BURGLARY_Efficiency[MAX_PLAYERS],
    BURGLARY_MaxEfficiency[MAX_PLAYERS],
    BURGLARY_Progress[MAX_PLAYERS],
    tajmer:BURGLARY_EfficiencyDrop[MAX_PLAYERS],
    tajmer:BURGLARY_ProgressUpdate[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    BURGLARY_EfficiecyBar[playerid] = INVALID_PLAYER_BAR_ID;
    BURGLARY_Efficiency[playerid] = 0;
    BURGLARY_Progress[playerid] = 0;
    tajmer:BURGLARY_EfficiencyDrop[playerid] = 0;
    tajmer:BURGLARY_ProgressUpdate[playerid] = 0;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys == KEY_FIRE && tajmer:BURGLARY_EfficiencyDrop[playerid] != 0) // Levi klik
    {
        BURGLARY_Efficiency[playerid] ++;
        if (BURGLARY_Efficiency[playerid] > BURGLARY_MaxEfficiency[playerid])
        {
            BURGLARY_Efficiency[playerid] = BURGLARY_MaxEfficiency[playerid];
        }
        SetPlayerProgressBarValue(playerid, BURGLARY_EfficiecyBar[playerid], BURGLARY_Efficiency[playerid]);
        ShowPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);
    }

    else if (newkeys == KEY_SPRINT && IsPlayerBurglaryActive(playerid)) // Space - prekidanje obijanja
    {
        CallRemoteFunction("OnBurglaryStop", "i", playerid); 

        ClearAnimations(playerid);
        TogglePlayerControllable_H(playerid, true);
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward OnBurglaryProgress(playerid, progress);
public OnBurglaryProgress(playerid, progress)
{
    if (DebugFunctions())
    {
        LogCallbackExec("burglary.pwn", "OnBurglaryProgress");
    }

    return 1;
}

forward OnBurglarySuccess(playerid);
public OnBurglarySuccess(playerid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("burglary.pwn", "OnBurglarySuccess");
    }

    ptdBurglary_Destroy(playerid);
    DestroyPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);

    ClearAnimations(playerid);
    TogglePlayerControllable_H(playerid, true);
    
    SetWeaponsDropInactive();
    
    KillTimer(tajmer:BURGLARY_EfficiencyDrop[playerid]), tajmer:BURGLARY_EfficiencyDrop[playerid] = 0;
    KillTimer(tajmer:BURGLARY_ProgressUpdate[playerid]), tajmer:BURGLARY_ProgressUpdate[playerid] = 0;

    TextDrawHideForPlayer(playerid, tdBurglaryTip);
    return 1;
}

forward OnBurglaryFail(playerid);
public OnBurglaryFail(playerid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("burglary.pwn", "OnBurglaryFail");
    }
    
    ptdBurglary_Destroy(playerid);
    DestroyPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);
    
    // SetWeaponsDropInactive();

    BURGLARY_EfficiecyBar[playerid] = INVALID_PLAYER_BAR_ID;
    KillTimer(tajmer:BURGLARY_EfficiencyDrop[playerid]), tajmer:BURGLARY_EfficiencyDrop[playerid] = 0;
    KillTimer(tajmer:BURGLARY_ProgressUpdate[playerid]), tajmer:BURGLARY_ProgressUpdate[playerid] = 0;

    TextDrawHideForPlayer(playerid, tdBurglaryTip);
    return 1;
}

forward OnBurglaryStop(playerid);
public OnBurglaryStop(playerid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("burglary.pwn", "OnBurglaryStop");
    }
    
    ptdBurglary_Destroy(playerid);
    DestroyPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);
    
    // SetWeaponsDropInactive();

    BURGLARY_EfficiecyBar[playerid] = INVALID_PLAYER_BAR_ID;
    KillTimer(tajmer:BURGLARY_EfficiencyDrop[playerid]), tajmer:BURGLARY_EfficiencyDrop[playerid] = 0;
    KillTimer(tajmer:BURGLARY_ProgressUpdate[playerid]), tajmer:BURGLARY_ProgressUpdate[playerid] = 0;

    TextDrawHideForPlayer(playerid, tdBurglaryTip);
    return 1;
}

stock PlayerStartBurglary(playerid, pace = 5000)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PlayerStartBurglary");
    }

    TogglePlayerControllable_H(playerid, false);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);

    BURGLARY_Efficiency[playerid] = 0;
    BURGLARY_MaxEfficiency[playerid] = 100;
    BURGLARY_EfficiecyBar[playerid] = CreatePlayerProgressBar(playerid, 498.000000, 235.000000, 113.000000, 10.0, -1580072961, BURGLARY_MaxEfficiency[playerid], 0);
    ShowPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);

    ptdBurglary_Create(playerid);
    ptdBurglary_UpdateProgress(playerid, 0);
    BURGLARY_Progress[playerid] = 0;

    tajmer:BURGLARY_EfficiencyDrop[playerid] = SetTimerEx("BURGLARY_EfficiencyDrop", 350, true, "ii", playerid, cinc[playerid]);
    tajmer:BURGLARY_ProgressUpdate[playerid] = SetTimerEx("BURGLARY_ProgressUpdate", pace, true, "ii", playerid, cinc[playerid]);

    TextDrawShowForPlayer(playerid, tdBurglaryTip);
}

forward BURGLARY_EfficiencyDrop(playerid, ccinc);
public BURGLARY_EfficiencyDrop(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
    {
        KillTimer(tajmer:BURGLARY_EfficiencyDrop[playerid]), tajmer:BURGLARY_EfficiencyDrop[playerid] = 0;
        return 1;
    }


    BURGLARY_Efficiency[playerid] -= random(3);
    if (BURGLARY_Efficiency[playerid] < 0) 
    {
        BURGLARY_Efficiency[playerid] = 0;
    }
    SetPlayerProgressBarValue(playerid, BURGLARY_EfficiecyBar[playerid], BURGLARY_Efficiency[playerid]);
    ShowPlayerProgressBar(playerid, BURGLARY_EfficiecyBar[playerid]);
    return 1;
}

forward BURGLARY_ProgressUpdate(playerid, ccinc);
public BURGLARY_ProgressUpdate(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
    {
        KillTimer(tajmer:BURGLARY_ProgressUpdate[playerid]), tajmer:BURGLARY_ProgressUpdate[playerid] = 0;
        return 1;
    }

    new efficiencyPercentage = BURGLARY_Efficiency[playerid],
        progressToAdd = 0;

    if (efficiencyPercentage <= 10)
    {
        progressToAdd = 0;
    }
    else if (efficiencyPercentage > 10 && efficiencyPercentage <= 35)
    {
        progressToAdd = 1;
    }
    else if (efficiencyPercentage > 35 && efficiencyPercentage <= 70)
    {
        progressToAdd = 2;
    }
    else if (efficiencyPercentage > 70 && efficiencyPercentage <= 90)
    {
        progressToAdd = 3;
    }
    else if (efficiencyPercentage > 90 && efficiencyPercentage <= 100)
    {
        progressToAdd = 4;
    }

    BURGLARY_Progress[playerid] += progressToAdd;
    if (BURGLARY_Progress[playerid] >= 100)
    {
        // Obijanje zavrseno
        BURGLARY_Progress[playerid] = 100;
        KillTimer(tajmer:BURGLARY_ProgressUpdate[playerid]), tajmer:BURGLARY_ProgressUpdate[playerid] = 0;

        // TODO
        CallRemoteFunction("OnBurglarySuccess", "i", playerid); 
    }
    else
    {
        CallRemoteFunction("OnBurglaryProgress", "ii", playerid, BURGLARY_Progress[playerid]); 
    }
    ptdBurglary_UpdateProgress(playerid, BURGLARY_Progress[playerid]);

    GameTextForPlayer(playerid, "~N~~N~~W~Brzo pritiskaj ~R~~k~~PED_FIREWEAPON~!", 5000, 3);
    return 1;
}

stock IsPlayerBurglaryActive(playerid)
{
    if (tajmer:BURGLARY_EfficiencyDrop[playerid] != 0)
    {
        return 1;
    }

    return 0;
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
