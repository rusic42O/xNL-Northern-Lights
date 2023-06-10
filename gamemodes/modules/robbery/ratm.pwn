#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
new ATMRobbery_ATM_ID[MAX_PLAYERS],
    atmRobberyPlayerReload[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
	ATMRobbery_ATM_ID[playerid] = -1;
    atmRobberyPlayerReload[playerid] = 0;
}

hook OnPlayerPause(playerid)
{
	if (IsPlayerRobbingATM(playerid))
	{
		ClearAnimations(playerid);
		TogglePlayerControllable_H(playerid, true);
		ATMRobbery_ATM_ID[playerid] = -1;

		ErrorMsg(playerid, "Pauzirali ste igru tokom pljacke bankomata, pljacka je neuspesna.");
	}
}

hook OnPlayerDeath(playerid)
{
	if (IsPlayerRobbingATM(playerid))
	{
		ATMRobbery_ATM_ID[playerid] = -1;
	}
}

hook OnBurglarySuccess(playerid)
{
	if (IsPlayerRobbingATM(playerid))
	{
		if ((IsPlayerNearATM(playerid)-1) == GetPlayerRobbingATM_ID(playerid))
		{
			TogglePlayerControllable_H(playerid, true);
			ClearAnimations(playerid);

			new str[41], string[81], 
				money = (2000 + random(2000) + random(2000)) * 2;

            money += (GetPlayerLevel_StoreRobbery(playerid)-1)*800; // bonus za skill
			PlayerMoneyAdd(playerid, money);

			format(str, sizeof str, "~g~Uspesna pljacka~n~Zarada: ~y~%s", formatMoneyString(money));
			GameTextForPlayer(playerid, str, 5000, 3);

			format(string, sizeof string, "* %s nasilno otvara bankomat i uzima sav novac iz njega.", ime_rp[playerid]);
			RangeMsg(playerid, string, LJUBICASTA, 20.0);

			// Update ukupne zarade
			PI[playerid][p_atm_stolen_cash] += money;
			new query[65];
			format(query, sizeof query, "UPDATE igraci SET atm_stolen_cash = %i WHERE id = %i", PI[playerid][p_atm_stolen_cash], PI[playerid][p_id]);
			mysql_tquery(SQL, query);

			// Upisivanje u log
			new logStr[53];
			format(logStr, sizeof logStr, "ATM %i | %s | %s", GetPlayerRobbingATM_ID(playerid), ime_obicno[playerid], formatMoneyString(money));
			Log_Write(LOG_ROBBERY, logStr);


            ATMRobbery_ATM_ID[playerid] = -1;

            // Skill UP za sve clanove u okolini
            PlayerUpdateCriminalSkill(playerid, 1, SKILL_ROBBERY_ATM, 0);
            if (IsACriminal(playerid))
            {
                new fid = PI[playerid][p_org_id];
                new Float:x,Float:y,Float:z, limit=0;
                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (i == playerid) continue; // vec dodeljen skill gore
                    
                    if (limit >= 2) break; // samo 2 igraca mogu dobiti

                    if (PI[i][p_org_id] == fid)
                    {
                        if (IsPlayerInRangeOfPoint(i, 10.0, x, y, z))
                        {
                            limit++;
                            PlayerUpdateCriminalSkill(i, 1, SKILL_ROBBERY_ATM, 1);
                        }
                    }
                }
            }
		}
		else
		{
			ErrorMsg(playerid, "Udaljili ste se od bankomata koji ste pljackali, pljacka je neuspesna (%i != %i).", IsPlayerNearATM(playerid), GetPlayerRobbingATM_ID(playerid));
		}
	}
	return 1;
}

hook OnBurglaryFail(playerid)
{
    if (IsPlayerRobbingATM(playerid))
    {
        ATMRobbery_ATM_ID[playerid] = -1;
    }
}

hook OnBurglaryStop(playerid)
{
    if (IsPlayerRobbingATM(playerid))
    {
        ATMRobbery_ATM_ID[playerid] = -1;
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerRobbingATM(playerid)
{
	if (GetPlayerRobbingATM_ID(playerid) != -1)
	{
		return true;
	}
	else
	{
		return false;
	}
}

stock GetPlayerRobbingATM_ID(playerid)
{
	return ATMRobbery_ATM_ID[playerid];
}

stock ATMRobbery_Reset(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("ATMRobbery_Reset");
    }

	ATMRobbery_ATM_ID[playerid] = -1;
}

stock GetPlayerLevel_ATMRobbery(playerid)
{
	new robbedAtms = PI[playerid][p_robbed_atms], 
		atmLevel = floatround(robbedAtms/50.0, floatround_ceil);

	return atmLevel;
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
CMD:pljackajatm(playerid, params[])
{
    if (IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	if (!IsPlayerNearATM(playerid))
		return ErrorMsg(playerid, "Ne nalazite se blizu bankomata.");
	if (GetPlayerWeapon(playerid) <= 0)
        return ErrorMsg(playerid, "Morate drzati oruzje u ruci da biste pokrenuli pljackanje bankomata.");
	new atm = IsPlayerNearATM(playerid) - 1; // vraca ID bankomata uvecan za 1, zato se oduzima 1.
	if (ATMInfo[atm][atmRobberyCooldown] > gettime())
		return ErrorMsg(playerid, "Ovaj bankomat je vec opljackan.");
    if (atmRobberyPlayerReload[playerid] > gettime())
        return ErrorMsg(playerid, "Sacekajte jos %s pre sledece pljacke.", konvertuj_vreme(atmRobberyPlayerReload[playerid]-gettime()));
	//new fID = GetFactionIDbyName("West End Gang");
	//if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (GetPlayerFactionID(playerid) == 0) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici ilegalnih organizacija!");//West End Gang-a
	new period;
	if (IsACriminal(playerid))
	{
		new fid = GetPlayerFactionID(playerid), Iterator:iAlliesNearby<MAX_PLAYERS>;
		foreach (new i : Player)
		{
			if (i == playerid) continue;
			if (GetPlayerFactionID(i) == fid)
			{
				if (IsPlayerNearPlayer(playerid, i, 5.0))
				{
					Iter_Add(iAlliesNearby, i);
				}
			}
		}
		if (Iter_Count(iAlliesNearby) == 0)
			return ErrorMsg(playerid, "Morate biti u drustvu barem 1 pripadnika svoje mafije/bande da biste pokrenuli pljacku.");

		period = 900; // sa periodom 900ms, progress ce dostici 100% za tacno 90 sekundi
	}
	else
	{
		new playerNearby = INVALID_PLAYER_ID;
		foreach (new i : Player)
		{
			if (i == playerid) continue;
			if (IsPlayerNearPlayer(playerid, i, 5.0))
			{
				playerNearby = i;
				break;
			}
		}
		if (playerNearby == INVALID_PLAYER_ID)
			return ErrorMsg(playerid, "Morate biti u drustvu barem 1 igraca da biste pokrenuli pljacku.");

		period = 1500; // sa periodom 1500ms, progress ce dostici 100% za tacno 150 sekundi
	}
	printf("pljackajatm 9");
    new str[32];
    format(str, sizeof str, "Pljacka bankomata #%02d", atm+1);
    AddPlayerCrime(playerid, INVALID_PLAYER_ID, 2, str, "Snimak sa nadzorne kamere");
	printf("pljackajatm 10");
    atmRobberyPlayerReload[playerid] = gettime() + period/10 + 180;
	ATMInfo[atm][atmRobberyCooldown] = gettime() + period/10 + 1800;
	ATMRobbery_ATM_ID[playerid] = atm;

	// Odredjujemo brzinu obijanja na osnovu skill-a
	new robbingPace = 3200 - 250*GetPlayerLevel_ATMRobbery(playerid);

	if (robbingPace < 1500) robbingPace = 1500; // za svaki slucaj, da ne bude prebrzo
	PlayerStartBurglary(playerid, robbingPace);

	// Upisivanje u log
    new logStr[64];
    format(logStr, sizeof logStr, "ATM-START | %s | %i", ime_obicno[playerid], atm);
    Log_Write(LOG_ROBBERY, logStr);
	printf("pljackajatm 11");
	return 1;
}