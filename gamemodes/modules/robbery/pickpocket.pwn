#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PICKPOCKET_MAXDISTANCE (0.75)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new PICKPOCKET_cooldown[MAX_PLAYERS],
    tajmer:pickpocket[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    tajmer:pickpocket[playerid] = 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward Pickpocket(playerid, targetid, ccinc);
public Pickpocket(playerid, targetid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Pickpocket");
    }

    tajmer:pickpocket[playerid] = 0;

    if (!checkcinc(playerid, ccinc) || !IsPlayerConnected(targetid) || PICKPOCKET_cooldown[playerid] > gettime())
        return 1;

    new Float:pos[3];
    GetPosBehindPlayer(targetid, pos[0], pos[1], pos[2], PICKPOCKET_MAXDISTANCE);
    if (!IsPlayerInRangeOfPoint(playerid, 0.7, pos[0], pos[1], pos[2]))
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    if (PI[targetid][p_novac] < 100)
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    if (IsPlayerPaused_OW(targetid) || IsPlayerAFK(targetid))
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    if (IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    if (!IsPlayerInAnyVehicle(playerid) && IsPlayerInAnyVehicle(targetid))
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    if (OW_IsPlayerFrozen(playerid))
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    new money = floatround(PI[targetid][p_novac] * 0.007),
        randBase = floatround(money/4);

    if (randBase > 0)
    {
        money += random(randBase);
    }
    else
    {
        // ostaje isto (money = money)
    }

    if (money > 1000000) money = 1000000;
    else if (money < 20)
        return ErrorMsg(playerid, "Dzeparenje nije uspelo.");

    PlayerMoneyAdd(playerid, money);
    PlayerMoneySub(targetid, money);

    PlayerUpdateCriminalSkill(playerid, 1, SKILL_PICKPOCKET, 0);
    if (IsACop(targetid))
        PlayerUpdateCopSkill(targetid, -2, SKILL_PICKPOCKET, 0);
    else if (IsACriminal(targetid))
        PlayerUpdateCriminalSkill(targetid, -2, SKILL_PICKPOCKET, 0);

    // Upisivanje u log
    new string[80];
    format(string, sizeof string, "%s je opljackao %s (%s)", ime_obicno[playerid], ime_obicno[targetid], formatMoneyString(money));
    Log_Write(LOG_PICKPOCKET, string);

    PICKPOCKET_cooldown[playerid] = gettime() + 600;

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
CMD:ukradi(playerid, const params[])
{
    //if (PI[playerid][p_nivo] < 3)
    //    return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste dzeparili!");
    //new fID = GetFactionIDbyName("Pink Panter");
	//if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (GetPlayerFactionID(playerid) == 0) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici ilegalnih organizacija!");//Pink Panter-a
	

    if (PICKPOCKET_cooldown[playerid] > gettime())
        return ErrorMsg(playerid, "Sacekajte jos %s pre narednog dzeparenja.", konvertuj_vreme(PICKPOCKET_cooldown[playerid] - gettime()));

    if (tajmer:pickpocket[playerid] > 0)
        return ErrorMsg(playerid, "Pljackanje je vec u toku.");

    new id, Float:posBehind[3];
    if (sscanf(params, "u", id))
        return Koristite(playerid, "ukradi [Ime ili ID igraca]");

    if (id == playerid)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu na sebi.");

    if (PI[playerid][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu dok ste zatvoreni.");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    GetPosBehindPlayer(id, posBehind[0], posBehind[1], posBehind[2], PICKPOCKET_MAXDISTANCE);
    if (!IsPlayerInRangeOfPoint(playerid, 1.0, posBehind[0], posBehind[1], posBehind[2]))
        return ErrorMsg(playerid, "Morate biti iza igraca koga zelite da opljackate!");

    if (IsAdmin(id, 6))
        return ErrorMsg(playerid, "Ne mozete opljackati head admina.");

    if (IsPlayerPaused_OW(id) || IsPlayerAFK(id))
        return ErrorMsg(playerid, "Ne mozete opljackati ovog igraca.");

    if (PI[id][p_nivo] < 3)
        return ErrorMsg(playerid, "Ne mozete opljackati igraca ciji je nivo manji od 3.");

    if (IsPlayerWorking(playerid))
        return ErrorMsg(playerid, "Ne mozete opljackati igraca koji radi posao.");

    tajmer:pickpocket[playerid] = SetTimerEx("Pickpocket", 2500, false, "iii", playerid, id, cinc[playerid]);
    return 1;
}