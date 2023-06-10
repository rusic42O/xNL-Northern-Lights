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
new bool:Race402_Active,
	Race402_Start,
	Race402_P1,
	Race402_P2,

    Race402_FrontFence,
    Race402_BackFence;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	Race402_Active = false;
	Race402_P1 = Race402_P2 = INVALID_PLAYER_ID;

    Race402_FrontFence = CreateDynamicObject(982,2048.03027344,-2493.85937500,13.23042965,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1) // Ogradica NAPRED podignuta
    Race402_BackFence  = CreateDynamicObject(982,2068.03027344,-2493.85937500,11.80042934,0.00000000,0.00000000,0.00000000); //object(fenceshit) (1) // Ogradica POZADI spustena
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (Race402_P1 == playerid)
	{
		Race402_P1 = INVALID_PLAYER_ID;
		StaffMsg(NARANDZASTA, "Trka 402 | {FFFF00}Igrac %s je napustio igru, trka mora biti resetovana.", ime_rp[playerid]);
	}
	else if (Race402_P2 == playerid)
	{
		Race402_P2 = INVALID_PLAYER_ID;
		StaffMsg(NARANDZASTA, "Trka 402 | {FFFF00}Igrac %s je napustio igru, trka mora biti resetovana.", ime_rp[playerid]);
	}
}

hook OnPlayerEnterRaceCP(playerid)
{
	if (Race402_Active && (Race402_P1 == playerid || Race402_P2 == playerid))
	{
		if ((Race402_P1 == playerid && IsPlayerInRangeOfPoint(playerid, 7.5, 1555.2500,-2501.7417,13.2818)) || Race402_P2 == playerid && IsPlayerInRangeOfPoint(playerid, 7.5, 1555.2500,-2486.0654,13.2818))
		{
			
			new newtick = GetTickCount(),
				drivingTime = GetTickDiff(newtick, Race402_Start);

			if (IsPlayerConnected(Race402_P1))
				SendClientMessageF(Race402_P1, PLAVA, "Trka 402 | %s  (vreme: %.3f s)", ime_rp[playerid], floatdiv(drivingTime, 1000.0));

			if (IsPlayerConnected(Race402_P2))
				SendClientMessageF(Race402_P2, PLAVA, "Trka 402 | %s  (vreme: %.3f s)", ime_rp[playerid], floatdiv(drivingTime, 1000.0));
			
			StaffMsg(PLAVA, "Trka 402 | %s  (vreme: %.3f s)", ime_rp[playerid], floatdiv(drivingTime, 1000.0));


			if (Race402_P1 == playerid)
				Race402_P1 = INVALID_PLAYER_ID;

			if (Race402_P2 == playerid)
				Race402_P2 = INVALID_PLAYER_ID;

			if (Race402_P1 == INVALID_PLAYER_ID && Race402_P2 == INVALID_PLAYER_ID)
            {
				Race402_Active = false;

                // Vracamo ogradice
                MoveDynamicObject(Race402_FrontFence, 2048.03027344,-2493.85937500,13.23042965,5.350); // dignuta prednja
                MoveDynamicObject(Race402_BackFence, 2068.03027344,-2493.85937500,11.80042934,5.350); // spustena zadnja
            }

            DisablePlayerRaceCheckpoint_H(playerid);

			return ~1;
		}
	}
	return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward Race402_Countdown(count);
public Race402_Countdown(count)
{
    switch (count)
    {
        case 1:
        {
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[7]);
            PlayerPlaySound(Race402_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[7]);
            PlayerPlaySound(Race402_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 2:
        {
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[8]);
            PlayerPlaySound(Race402_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[8]);
            PlayerPlaySound(Race402_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 3:
        {
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[9]);
            PlayerPlaySound(Race402_P1, 1056, 0.0, 0.0, 0.0);

            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[9]);
            PlayerPlaySound(Race402_P2, 1056, 0.0, 0.0, 0.0);
        }
        case 4:
        {
            TextDrawBoxColor(tdEventCountdown[7], 13369599);
            TextDrawBoxColor(tdEventCountdown[8], 13369599);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);

            // Ogradice
            MoveDynamicObject(Race402_FrontFence, 2048.03027344,-2493.85937500,11.80042934,5.350); // spustena prednja
            MoveDynamicObject(Race402_BackFence, 2068.03027344,-2493.85937500,13.23042965,5.350); // dignuta zadnja

            // P1
            TextDrawHideForPlayer(Race402_P1, tdEventCountdown[7]);
            TextDrawHideForPlayer(Race402_P1, tdEventCountdown[8]);
            TextDrawHideForPlayer(Race402_P1, tdEventCountdown[9]);
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[7]);
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[8]);
            TextDrawShowForPlayer(Race402_P1, tdEventCountdown[9]);
            PlayerPlaySound(Race402_P1, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(Race402_P1, true);
            SetPlayerRaceCheckpoint_H(Race402_P1, 1, 1555.2500,-2501.7417,13.2818, 1555.2500,-2501.7417,13.2818, 7.5); 

            // P2
            TextDrawHideForPlayer(Race402_P2, tdEventCountdown[7]);
            TextDrawHideForPlayer(Race402_P2, tdEventCountdown[8]);
            TextDrawHideForPlayer(Race402_P2, tdEventCountdown[9]);
            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[7]);
            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[8]);
            TextDrawShowForPlayer(Race402_P2, tdEventCountdown[9]);
            PlayerPlaySound(Race402_P2, 1057, 0.0, 0.0, 0.0);
            TogglePlayerControllable_H(Race402_P2, true);
            SetPlayerRaceCheckpoint_H(Race402_P2, 1, 1555.2500,-2486.0654,13.2818, 1555.2500,-2486.0654,13.2818, 7.5);

            Race402_Start = GetTickCount();
        }
        case 5:
        {
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(Race402_P1, tdEventCountdown[t]);
            for__loop (new t = 0; t < 10; t++) TextDrawHideForPlayer(Race402_P2, tdEventCountdown[t]);

            TextDrawBoxColor(tdEventCountdown[7], -872414977);
            TextDrawBoxColor(tdEventCountdown[8], -3407617);
            TextDrawBoxColor(tdEventCountdown[9], 13369599);
        }
    }

    if (count != 5) SetTimerEx("Race402_Countdown", 1000, false, "i", count+1);
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
flags:402(FLAG_HELPER_1)
CMD:402(playerid, const params[])
{
	if (!IsHelper(playerid, 1))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (isnull(params) || !strcmp(params, "help", false))
	{
		Koristite(playerid, "402 [Igrac 1] [Igrac 2] - za prijavu igraca na event");
		Koristite(playerid, "402 start - za startovanje eventa nakon prijave igraca");
		Koristite(playerid, "402 reset - za resetovanje eventa");
		return 1;
	}

	if (!strcmp(params, "start", false))
	{
		if (Race402_Active)
			return ErrorMsg(playerid, "Trka 402 je vec pokrenuta.");

		if (Race402_P1 == INVALID_PLAYER_ID || Race402_P2 == INVALID_PLAYER_ID)
			return ErrorMsg(playerid, "Nisu prijavljena oba igraca na trku.");

		Race402_Active = true;

		TogglePlayerControllable_H(Race402_P1, false);
		TogglePlayerControllable_H(Race402_P2, false);

        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(Race402_P1, tdEventCountdown[j]);
        for__loop (new j = 0; j < 7; j++) TextDrawShowForPlayer(Race402_P2, tdEventCountdown[j]);

		SetTimerEx("Race402_Countdown", 1000, false, "i", 1);
		StaffMsg(NARANDZASTA, "Race 402 | {FFFFFF}%s {FFFF00}je pokrenuo trku 402 | %s - %s.", ime_rp[playerid], ime_rp[Race402_P1], ime_rp[Race402_P2]);
	}
	else if (!strcmp(params, "reset", false))
	{
		Race402_Active = false;
		Race402_P1 = Race402_P2 = INVALID_PLAYER_ID;

        MoveDynamicObject(Race402_FrontFence,  2048.03027344,-2493.85937500,13.23042965,5.350); // dignuta prednja
        MoveDynamicObject(Race402_BackFence, 2068.03027344,-2493.85937500,11.80042934,5.350); // spustena zadnja

		StaffMsg(NARANDZASTA, "Race 402 | {FFFFFF}%s {FFFF00}je resetovao trku 402.", ime_rp[playerid]);
	}
	else 
	{
		new p1, p2;
		if (sscanf(params, "uu", p1, p2))
			return Koristite(playerid, "402 help - da vidite dostupne komande.");

		if (p1 == p2)
			return ErrorMsg(playerid, "Nije moguce uneti istog igraca u oba polja.");

		if (Race402_P1 != INVALID_PLAYER_ID || Race402_P2 != INVALID_PLAYER_ID)
			return ErrorMsg(playerid, "Vec ima prijavljenih igraca. Koristite \"/402 reset\" da resetujete trku.");

		if (!IsPlayerConnected(p1))
			return ErrorMsg(playerid, "Igrac 1 trenutno nije na serveru.");

		if (!IsPlayerConnected(p2))
			return ErrorMsg(playerid, "Igrac 2 trenutno nije na serveru.");

		if (Race402_Active)
			return ErrorMsg(playerid, "Trka 402 je vec aktivna. Koristite \"/402 reset\" da je resetujete.");

		if (GetPlayerState(p1) != PLAYER_STATE_DRIVER)
			return ErrorMsg(playerid, "Igrac 1 se ne nalazi u vozilu.");

		if (GetPlayerState(p2) != PLAYER_STATE_DRIVER)
			return ErrorMsg(playerid, "Igrac 2 se ne nalazi u vozilu.");

		Race402_P1 = p1;
		Race402_P2 = p2;

		// Postavlja igrace na start TODO
		SetVehiclePos(GetPlayerVehicleID(p1), 2057.4500, -2502.5579, 13.2084);
		SetVehiclePos(GetPlayerVehicleID(p2), 2057.4500, -2486.6335, 13.2726);
        SetVehicleZAngle(GetPlayerVehicleID(p1), 90.0);
        SetVehicleZAngle(GetPlayerVehicleID(p2), 90.0);

		// Podize ogradicE (napred i pozadi, stavlja ih u kavez) TODO
		MoveDynamicObject(Race402_FrontFence,2048.03027344,-2493.85937500,13.23042965,5.350); // dignuta prednja
        MoveDynamicObject(Race402_BackFence, 2068.03027344,-2493.85937500,11.80042934,5.350); // spustena zadnja

		SendClientMessageF(p1, NARANDZASTA, "Trka 402 | {FFFF00}Pozvani ste na 402 trku od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p2]);
		SendClientMessageF(p2, NARANDZASTA, "Trka 402 | {FFFF00}Pozvani ste na 402 trku od strane %s | Protivnik: {00FFFF}%s", ime_rp[playerid], ime_rp[p1]);
		SendClientMessageF(playerid, NARANDZASTA, "Trka 402 | {FFFF00}Pozvali ste na trku 402 igrace: %s[%i], %s[%i]", ime_rp[p1], p1, ime_rp[p2], p2);
		SendClientMessage(playerid, BELA, "* Koristite /402 start da oznacite pocetak trke.");
	}

	return 1;
}