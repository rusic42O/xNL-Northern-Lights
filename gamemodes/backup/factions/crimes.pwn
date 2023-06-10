#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_CRIME_TEXT      32
#define MAX_REPORTER_TEXT   32
#define MAX_PLAYER_CRIMES   5 // Poslednjih X krivicnih dela za koje server pamti informacije (WL ide i van toga)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_CRIMES_DATA
{
    CRIME_INFO[MAX_CRIME_TEXT], // Info o zlocinu
    CRIME_REPORTER[MAX_REPORTER_TEXT], // Ime igraca koji je prijavio, ili neki drugi tekst
}
new CrimeData[MAX_PLAYERS][MAX_PLAYER_CRIMES][E_CRIMES_DATA];

enum E_BRIBE_POINTS
{
    BRIBE_PICKUP,
    Float:BRIBE_POS[3]
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pCopAttackReload[MAX_PLAYERS],
    pCopAttackedID[MAX_PLAYERS],
    tajmer:smanji_wl[MAX_PLAYERS],
    Iterator:iWantedPlayers<MAX_PLAYERS>;

new BribePoints[][E_BRIBE_POINTS] =
{
    {-1, {2555.8401,-2123.8992,0.6323}},
    {-1, {2278.7891,-2042.0737,13.5469}},
    {-1, {2260.9358,-1108.7866,37.9766}},
    {-1, {991.2352,-1246.6664,19.4155}},
    {-1, {445.4332,-1354.3488,14.8281}},
    {-1, {390.2445,-1875.0543,7.8359}},
    {-1, {700.6768,-1201.7411,15.2453}},
    {-1, {1677.2246,-1918.1881,21.9542}},
    {-1, {2201.3877,-2533.8689,13.5469}},
    {-1, {2752.4028,-1417.1980,39.3683}}
};




// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit()
{
    SetTimer("WL_Tips", 900*1000, true);
    SetTimer("UpdateCriminalMarkers", 7500, true);
    Iter_Clear(iWantedPlayers);

    for__loop (new i = 0; i < sizeof BribePoints; i++)
    {
        BribePoints[i][BRIBE_PICKUP] = CreateDynamicPickup(1247, 1, BribePoints[i][BRIBE_POS][0], BribePoints[i][BRIBE_POS][1], BribePoints[i][BRIBE_POS][2]);
    
        CreateDynamic3DTextLabel("[ Bribe Point ]\n{FFFF00}/bribe", 0x940025FF, BribePoints[i][BRIBE_POS][0], BribePoints[i][BRIBE_POS][1], BribePoints[i][BRIBE_POS][2], 12.0);
    }
    return true;
}

hook OnPlayerConnect(playerid)
{
    pCopAttackReload[playerid] = gettime();
    pCopAttackedID[playerid] = INVALID_PLAYER_ID;
    tajmer:smanji_wl[playerid] = 0;
}

hook OnPlayerSpawn(playerid)
{
    if (IsPlayerWanted(playerid) && !IsACop(playerid))
    {
        // Svim clanovima policije stavljamo marker na ovog igraca jer ima WL
        foreach (new i : Player)
        {
            if (IsACop(i) && IsPlayerOnLawDuty(i))
            {
                SetPlayerMarkerForPlayer(i, playerid, 0xFF0000FF);
            }
        }

        if (!Iter_Contains(iWantedPlayers, playerid) && !IsOnDuty(playerid))
        {
            Iter_Add(iWantedPlayers, playerid);
        }

        DeletePVar(playerid, "wantedForWeapons");
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    KillTimer(tajmer:smanji_wl[playerid]);

    // Uklanjanje iz iteratora
    if (Iter_Contains(iWantedPlayers, playerid))
    {
        Iter_Remove(iWantedPlayers, playerid);
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == AreaLS)
    {
        // Zaustavlja tajmer samo ako igrac ima WL, a ako ga nema onda ce tajmer sam da se zaustavi kad se izvrsi njegova funkcija
        if (IsPlayerWanted(playerid) && IsPlayerLoggedIn(playerid))
        {
            KillTimer(tajmer:smanji_wl[playerid]);

            // Vracanje crvenog markera posto se vratio u LS
            foreach (new i : Player)
            {
                if (IsACop(i))
                {
                    SetPlayerMarkerForPlayer(i, playerid, 0xFF0000FF);
                }
            }
        }
    }
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (areaid == AreaLS && PI[playerid][p_area] <= 0 && PI[playerid][p_zatvoren] <= 0 && GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0)
    {
        if (IsPlayerWanted(playerid) && IsPlayerLoggedIn(playerid) && !IsAdminSpectating(playerid))
        {
            tajmer:smanji_wl[playerid] = SetTimerEx("smanji_wl", 360000, true, "ii", playerid, cinc[playerid]);
            InfoMsg(playerid, "Napustili ste zonu Los Santosa. Vas trazeni nivo ce uskoro nestati ukoliko ostanete van LS-a.");

            // Brisanje markera posto je napustio LS
            foreach (new i : Player)
            {
                if (IsACop(i) && IsPlayerOnLawDuty(i))
                {
                    SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
                }
            }
        }
    }
}

// hook OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
// {
//     if (IsPlayerConnected(damagedid) && IsPlayerConnected(playerid))
//     {
//         if (IsACop(damagedid) && !IsACop(playerid) && IsPlayerOnLawDuty(damagedid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInLMSEvent(playerid))
//         {
//             if (pCopAttackReload[playerid] < gettime() || (pCopAttackReload[playerid] >= gettime() && pCopAttackedID[playerid] != damagedid))
//             {
//                 // WL 1 za hladno oruzje, 2 za vatreno
//                 new level = 1;
//                 if (weaponid > 15) level = 2;  

//                 AddPlayerCrime(playerid, damagedid, level, "Napad na sluzbeno lice", ime_obicno[damagedid]);
//                 pCopAttackReload[playerid] = gettime() + 30;
//                 pCopAttackedID[playerid] = damagedid;
//             }
//         }
//     }
//     return 1;
// }

hook OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
    // playerid = damagedid (primio damage)
    // issuerid = zadao damage

    if (IsPlayerConnected(playerid) && IsPlayerConnected(issuerid))
    {
        if (IsACop(playerid) && !IsACop(issuerid) && IsPlayerOnLawDuty(playerid) && !IsPlayerInDMEvent(issuerid) && !IsPlayerInHorrorEvent(issuerid) && !IsPlayerInLMSEvent(issuerid))
        {
            if (pCopAttackReload[issuerid] < gettime() || (pCopAttackReload[issuerid] >= gettime() && pCopAttackedID[issuerid] != playerid))
            {
                // WL 1 za hladno oruzje, 2 za vatreno
                new level = 1;
                if (weapon > 15) level = 2;  

                AddPlayerCrime(issuerid, playerid, level, "Napad na sluzbeno lice", ime_obicno[playerid]);
                pCopAttackReload[issuerid] = gettime() + 30;
                pCopAttackedID[issuerid] = playerid;
            }
        }
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (GetPVarInt(playerid, "pKilledByAdmin") == 1) return 1;
    if (IsPlayerInWar(playerid)) return 1;
    if (IsPlayerInRace(playerid)) return 1;


    if (IsPlayerConnected(killerid) && PI[killerid][p_nivo] >= 5 && GetPlayerVirtualWorld(playerid) == 0 && GetPlayerInterior(playerid) == 0 && !IsPlayerInDMEvent(killerid) && !IsPlayerInHorrorEvent(killerid) && !IsPlayerInLMSEvent(killerid) && !IsPlayerInVSEvent(playerid) && !IsPlayerInBoxEvent(playerid) && !IsPlayerInDMArena(playerid))
    {
        // Ubica ima dovoljno visok nivo, daj mu WL ako je neki policajac u blizini ili ako ima javnih kamera
        if (!IsACop(killerid)) // Ubica nije PD/FBI/SWAT
        {
            if (IsPlayerInArea(killerid, 1380.4023,-1851.1985, 1587.6469,-1728.0759) || IsPlayerInArea(killerid, 1430.4249,-1736.5667,1626.2097,-1586.3167) || IsPlayerInArea(killerid, 1381.9341,-1047.6711,1536.9153,-1012.4745) || IsPlayerInArea(killerid, 1156.4335,-965.1879,1226.1285,-866.2569) || IsPlayerInArea(killerid, 1685.1057,-1949.2325,1820.8802,-1821.3706) || (IsPlayerInArea(killerid, 570.2953,-1526.3473,674.5701,-1385.6680) && !IsTurfWarActiveForPlayer(killerid)))
            {
                AddPlayerCrime(killerid, INVALID_PLAYER_ID, 3, "Prvostepeno ubistvo", "Snimak sa nadzorne kamere");
            }

            new Float:poz[4];
            GetPlayerPos(playerid, poz[0], poz[1], poz[2]);
            
            foreach (new i : Player)
            {
                if (i == playerid || i == killerid)
                    continue;
                    
                if (IsACop(i) && IsPlayerInRangeOfPoint(i, 75.0, poz[0], poz[1], poz[2]) && IsPlayerOnLawDuty(i) && GetPlayerState(i) != PLAYER_STATE_SPECTATING) 
                {
                    // Policajac na duznosti u blizini

                    if (!(GetPlayerFactionID(killerid) != -1 && IsPlayerOnActiveTurf(killerid)))
                    {
                        // Ne dobija se WL ako je ubica na aktivnoj zoni
                        
                        AddPlayerCrime(killerid, i, 5, "Prvostepeno ubistvo");
                    }
                    break;
                }
            }
        }
    }

    
    // Uzimanje para ako je imao WL
    if (IsPlayerWanted(playerid) && PI[playerid][p_nivo] >= 3 && !IsPlayerInWar(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid) && !IsPlayerInLMSEvent(playerid) && GetPVarInt(playerid, "pIgnoreDeathFine") != 1 && IsPlayerConnected(killerid) && IsACop(killerid) && IsACriminal(playerid) && IsPlayerOnLawDuty(killerid))
    {
        // Ubijen sa wanted levelom, blablabla, ubica je policajac, a nastradali je kriminalac
        new crimeValue = GetPlayerCrimeLevel(playerid)*500;
        PlayerMoneySub(playerid, crimeValue);
        SendClientMessageF(playerid, SVETLOCRVENA, "* Izgubili ste {FFFFFF}%s {FF6347}zbog umiranja sa Wanted Levelom {FFFFFF}%d.", formatMoneyString(crimeValue), GetPlayerCrimeLevel(playerid));

        // matematicke operacije se ponekad cudno ponasaju, pa se ovo mora uraditi ovako :(
        new negativeSkill = floatround(GetPlayerCrimeLevel(playerid)/10.0, floatround_ceil);
        negativeSkill = negativeSkill - 2*negativeSkill;
        PlayerUpdateCriminalSkill(playerid, negativeSkill, SKILL_SUSPECT_KILL, 0);

        // if (GetPlayerCrimeLevel(playerid) < 15)
        // {
        //     PlayerMoneySub(killerid, crimeValue/2);
        //     SendClientMessageF(playerid, SVETLOCRVENA, "* Izgubili ste {FFFF00}%s {FF6347}zbog ubistva osumnjicenog.", formatMoneyString(crimeValue));
        // }
        
        // Resetovanje wanted levela
        ClearPlayerRecord(playerid, true);
        
        // Brisanje iz baze
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM crimes WHERE player_id = %d", PI[playerid][p_id]);
        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_CRIMES_DELETE);
    }
    
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward UpdateCriminalMarkers();
public UpdateCriminalMarkers()
{
    if (Iter_Count(iWantedPlayers) > 0)
    {
        foreach (new p : iPolicemen)
        {
            foreach (new c : iWantedPlayers)
            {
                SetPlayerMarkerForPlayer(p, c, 0xFF0000FF);
            }
        }
    }
    return 1;
}

forward WL_Tips();
public WL_Tips()
{
    if (DebugFunctions())
    {
        LogFunctionExec("WL_Tips");
    }

    foreach (new i : Player)
    {
        if (IsPlayerWanted(i))
        {
            SendClientMessage(i, SVETLOCRVENA, "(tips) {FFFFFF}Da biste izgubili Wanted Level, morate otici izvan Los Santosa!");
        }
    }
    return 1;
}

stock LoadPlayerCrimes(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("LoadPlayerCrimes");
    }

    format(mysql_upit, sizeof mysql_upit, "SELECT reporter, info FROM crimes WHERE player_id = %d ORDER BY id DESC LIMIT 4", PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit, "MYSQL_LoadPlayerCrimes", "ii", playerid, cinc[playerid]);
}

stock AddPlayerCrime(playerid, reporter_id, level, const info[MAX_CRIME_TEXT], const reporter_txt[] = "Automatska prijava")
{
    if (DebugFunctions())
    {
        LogFunctionExec("AddPlayerCrime");
    }

    if (PI[playerid][p_nivo] < 4)
        return 1; // nema WL-a za igrace sa malim levelom

    if (!IsPlayerWanted(playerid))
    {
        // Ako igrac pre ovoga NIJE imao WL, onda se sada policiji stavlja crveni marker
        foreach (new i : Player)
        {
            if (IsACop(i) && IsPlayerOnLawDuty(i))
            {
                SetPlayerMarkerForPlayer(i, playerid, 0xFF0000FF);
            }
        }

        // Dodavanje u iterator
        if (!Iter_Contains(iWantedPlayers, playerid) && !IsOnDuty(playerid))
        {
            Iter_Add(iWantedPlayers, playerid);
        }
    }

    if (level > 10) level = 10;
    PI[playerid][p_wanted_level] += level;
    if (PI[playerid][p_wanted_level] > 255) PI[playerid][p_wanted_level] = 255; // limit 255


    if (reporter_id == INVALID_PLAYER_ID)
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Pocinili ste zlocin: {FFFF00}%s.", info);
        SendClientMessageF(playerid, SVETLOCRVENA, "Trenutni trazeni nivo: {FFFFFF}%d.", PI[playerid][p_wanted_level]);

        // Slanje poruka za PD/FBI/SWAT
        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: %s", reporter_txt);
        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Zlocin: %s, Pocinio: %s [WL: %d]", info, ime_rp[playerid], PI[playerid][p_wanted_level]);

        new query[145];
        mysql_format(SQL, query, sizeof query, "INSERT INTO crimes (player_id, reporter, info) VALUES (%i, '%s', '%s')", PI[playerid][p_id], reporter_txt, info);
        mysql_tquery(SQL, query);
    }
    else
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Pocinili ste zlocin: {FFFF00}%s, {FF6347}Prijavio: {FFFF00}%s.", info, ime_rp[reporter_id]);
        SendClientMessageF(playerid, SVETLOCRVENA, "Trenutni trazeni nivo: {FFFFFF}%d.", PI[playerid][p_wanted_level]);

        // Slanje poruka za PD/FBI/SWAT
        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: Prijavio: %s.", ime_rp[reporter_id]);
        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Zlocin: %s, Pocinio: %s [WL: %d]", info, ime_rp[playerid], PI[playerid][p_wanted_level]);

        new query[145];
        mysql_format(SQL, query, sizeof query, "INSERT INTO crimes (player_id, reporter, info) VALUES (%i, '%s', '%s')", PI[playerid][p_id], ime_rp[reporter_id], info);
        mysql_tquery(SQL, query);
    }

    // Selektovanje zlocina, jer je tako najlakse da se izmenja redosled u enumu
    LoadPlayerCrimes(playerid);

    // Update baze
    new query[59];
    format(query, sizeof query, "UPDATE igraci SET wanted_level = %i WHERE id = %i", PI[playerid][p_wanted_level], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

stock GetPlayerCrimeLevel(playerid)
{
    return PI[playerid][p_wanted_level];
}

stock IsPlayerWanted(playerid)
{
    if(PI[playerid][p_wanted_level] > 0) return 1;
    return 0;
}

stock ClearPlayerRecord(playerid, dbRemove = false)
{
    if (DebugFunctions())
    {
        LogFunctionExec("ClearPlayerRecord");
    }

    for__loop (new i = 0; i < MAX_PLAYER_CRIMES; i++)
    {
        format(CrimeData[playerid][i][CRIME_INFO], 4, "N/A");
        format(CrimeData[playerid][i][CRIME_REPORTER], 4, "N/A");
    }
    SetPlayerWantedLevel(playerid, 0);
    PI[playerid][p_wanted_level] = 0;
    DeletePVar(playerid, "wantedForWeapons");

    // Uklanjamo marker
    foreach (new i : Player)
    {
        if (IsACop(i) && IsPlayerOnLawDuty(i))
        {
            SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00);
        }
    }

    // Uklanjanje iz iteratora
    if (Iter_Contains(iWantedPlayers, playerid))
    {
        Iter_Remove(iWantedPlayers, playerid);
    }

    new query_1[53];
    format(query_1, sizeof query_1, "UPDATE igraci SET wanted_level = 0 WHERE id = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, query_1);

    if (dbRemove)
    {
        new query[45];
        format(query, sizeof query, "DELETE FROM crimes WHERE player_id = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }
}

stock GetMaxCrimesPerPlayer()
{
    return MAX_PLAYER_CRIMES;
}

stock GetCrimeData(playerid, crimeSlot, szDest_Info[], len1, szDest_Reporter[], len2)
{
    if (DebugFunctions())
    {
        LogFunctionExec("GetCrimeData");
    }

    if (crimeSlot >= 0 && crimeSlot < MAX_PLAYER_CRIMES)
    {
        format(szDest_Info, len1, "%s", CrimeData[playerid][crimeSlot][CRIME_INFO]);
        format(szDest_Reporter, len2, "%s", CrimeData[playerid][crimeSlot][CRIME_REPORTER]);
    }
}

forward smanji_wl(playerid, ccinc);
public smanji_wl(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("smanji_wl");
    }

    if (!checkcinc(playerid, ccinc) || !IsPlayerWanted(playerid)) 
    {
        KillTimer(tajmer:smanji_wl[playerid]);
        return 1;
    }
    
    if (!IsPlayerAFK(playerid) && !IsPlayerJailed(playerid))
    {
        PI[playerid][p_wanted_level] --;         
        if (PI[playerid][p_wanted_level] == 0) // Nema vise WL, izbrisi iz baze
        {
            KillTimer(tajmer:smanji_wl[playerid]);
            
            SendClientMessage(playerid, SVETLOCRVENA, "* Vise niste trazeni u Los Santosu. Sada nema opasnosti od policije i mozete se vratiti u grad.");

            ClearPlayerRecord(playerid, true);
        }
        else // Jos uvek ima WL, samo updateuj podatke
        {
            SendClientMessageF(playerid, SVETLOCRVENA, "Trenutni trazeni nivo: {FFFFFF}%d.", PI[playerid][p_wanted_level]);
        
            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET wanted_level = %d WHERE id = %d", PI[playerid][p_wanted_level], PI[playerid][p_id]);
            mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_CRIMES_INSERT);
        }
    }
    return 1;
}

stock GetRandomBribePoint(&Float:x, &Float:y, &Float:z)
{
    new rand = random(sizeof BribePoints);
    x = BribePoints[rand][BRIBE_POS][0];
    y = BribePoints[rand][BRIBE_POS][1];
    z = BribePoints[rand][BRIBE_POS][2];
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MYSQL_LoadPlayerCrimes(playerid, ccinc);
public MYSQL_LoadPlayerCrimes(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MYSQL_LoadPlayerCrimes");
    }

	if (!checkcinc(playerid, ccinc))
		return 1;

    for__loop (new i = 0; i < MAX_PLAYER_CRIMES; i++)
    {
        format(CrimeData[playerid][i][CRIME_INFO], 4, "N/A");
        format(CrimeData[playerid][i][CRIME_REPORTER], 4, "N/A");
    }
		
	cache_get_row_count(rows);
	if (!rows) return 1;
    if (rows > MAX_PLAYER_CRIMES) rows = MAX_PLAYER_CRIMES;
	
	for__loop (new i = 0; i < rows; i++)
    {
    	cache_get_value_name(i, "reporter", CrimeData[playerid][i][CRIME_REPORTER], MAX_REPORTER_TEXT);
        cache_get_value_name(i, "info", CrimeData[playerid][i][CRIME_INFO], MAX_CRIME_TEXT);
    }
    // Dodavanje u iterator
    if (!Iter_Contains(iWantedPlayers, playerid))
    {
        Iter_Add(iWantedPlayers, playerid);
    }
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:bribe(playerid, const params[])
{
    if (!IsPlayerWanted(playerid))
        return ErrorMsg(playerid, "Morate imati Wanted Level da biste koristili ovu komandu.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    foreach (new i : iPolicemen)
    {
        if (IsPlayerNearPlayer(i, playerid, 40.0))
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok je policija u blizini.");
    }

    new pts;
    if (sscanf(params, "i", pts))
        return Koristite(playerid, "bribe [Broj wanted levela (max. 3)]");

    if (pts < 1 || pts > 3)
        return ErrorMsg(playerid, "Uneti parametar mora biti izmedju 1 i 3.");

    if (GetPlayerCrimeLevel(playerid) < pts)
        return ErrorMsg(playerid, "Vas Wanted Level je manji od unetog parametra.");

    for__loop (new i = 0; i < sizeof BribePoints; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, BribePoints[i][BRIBE_POS][0], BribePoints[i][BRIBE_POS][1], BribePoints[i][BRIBE_POS][2]))
        {
            #define BRIBE_POINT_COST 3000
            new cost = BRIBE_POINT_COST * pts;
            if (PI[playerid][p_novac] < cost)
                return ErrorMsg(playerid, "Nemate dovoljno novca (%s).", formatMoneyString(cost));

            PlayerMoneySub(playerid, cost);
            PI[playerid][p_wanted_level] -= pts;
        
            if (PI[playerid][p_wanted_level] == 0) // Nema vise WL, izbrisi iz baze
            {
                KillTimer(tajmer:smanji_wl[playerid]);
                ClearPlayerRecord(playerid, true);
            }

            SendClientMessageF(playerid, ZUTA, "Wanted Level je smanjen za {940025}%i poena {FFFF00}po ceni od %s.", pts, formatMoneyString(cost));
            PI[playerid][p_reload_bribe] = gettime() + 1800;
            return 1;
        }
    }

    ErrorMsg(playerid, "Ne nalazite se na Bribe Point-u.");
    return 1;
}