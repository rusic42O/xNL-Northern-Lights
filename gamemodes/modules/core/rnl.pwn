#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define RNL_VAN 582
#define RNL_HELI 488




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static gInterviewer;
static gInterviewee[2];
static gClrBase, gClrLighter, g_sClrLighter[7];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;

	CreateVehicle(582, 1734.4762, -1126.6620, 24.1430, 180.0, 49, 11, 1000, 1);
	CreateVehicle(582, 1725.4905, -1126.6620, 24.1421, 180.0, 49, 11, 1000, 1);
	CreateVehicle(582, 1734.4762, -1112.1454, 24.1419, 180.0, 49, 11, 1000, 1);
	CreateVehicle(582, 1725.4905, -1114.1454, 24.1437, 180.0, 49, 11, 1000, 1);

    // Podesavanja boje
    gClrBase = 0xFF8533FF;
    gClrLighter = ColorLighten(gClrBase);
    GetColorShade(gClrLighter, g_sClrLighter);
	return true;
}

hook OnPlayerDisconnect(playerid, reason)
{
	if (playerid == gInterviewer)
	{
		// Voditelj je napustio igru
		if (IsPlayerConnected(gInterviewee[0]))
			SendClientMessageF(gInterviewee[0], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		if (IsPlayerConnected(gInterviewee[1]))
			SendClientMessageF(gInterviewee[1], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
	}

	else if (playerid == gInterviewee[0])
	{
		// Sagovornik 1 je napustio igru
		if (IsPlayerConnected(gInterviewer))
			SendClientMessageF(gInterviewer, gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		if (IsPlayerConnected(gInterviewee[1]))
			SendClientMessageF(gInterviewee[1], gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
	}

	else if (playerid == gInterviewee[1])
	{
		// Sagovornik 2 je napustio igru
		if (IsPlayerConnected(gInterviewer))
			SendClientMessageF(gInterviewer, gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		if (IsPlayerConnected(gInterviewee[0]))
			SendClientMessageF(gInterviewee[0], gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio igru.", g_sClrLighter, ime_rp[playerid]);

		gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_DRIVER)
	{
		if (playerid == gInterviewer)
		{
			// Voditelj je napustio vozilo
			if (IsPlayerConnected(gInterviewee[0]))
				SendClientMessageF(gInterviewee[0], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			if (IsPlayerConnected(gInterviewee[1]))
				SendClientMessageF(gInterviewee[1], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
		}

		else if (playerid == gInterviewee[0])
		{
			// Sagovornik 1 je napustio vozilo
			if (IsPlayerConnected(gInterviewer))
				SendClientMessageF(gInterviewer, gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			if (IsPlayerConnected(gInterviewee[1]))
				SendClientMessageF(gInterviewee[1], gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
		}

		else if (playerid == gInterviewee[1])
		{
			// Sagovornik 2 je napustio vozilo
			if (IsPlayerConnected(gInterviewer))
				SendClientMessageF(gInterviewer, gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			if (IsPlayerConnected(gInterviewee[0]))
				SendClientMessageF(gInterviewee[0], gClrBase, "INTERVIEW | Sagovornik {%s}%s {FF8533}je napustio vozilo.", g_sClrLighter, ime_rp[playerid]);

			gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
		}
	}

	if (newstate == PLAYER_STATE_DRIVER)
	{
		new model = GetVehicleModel(GetPlayerVehicleID(playerid));
		if (model == RNL_VAN || model == RNL_HELI)
		{
			if (PlayerFlagGet(playerid, FLAG_RNL_LEADER) || PlayerFlagGet(playerid, FLAG_RNL_MEMBER))
			{
				SendClientMessageF(playerid, gClrBase, "RNL | {%s}Koristite {FF8533}/intervju {%s}da zapocnete intervju.", g_sClrLighter, g_sClrLighter);
			}
			else
			{
				ErrorMsg(playerid, "Niste clan RNL.");
                isteraj(playerid);
			}
		}
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsInterviewActive()
{
	if (!IsPlayerConnected(gInterviewer) && !IsPlayerConnected(gInterviewee[0]) && !IsPlayerConnected(gInterviewee[1]))
	{
		return 0;
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
alias:intervju("interview")
flags:intervju(FLAG_RNL_LEADER | FLAG_RNL_MEMBER)
CMD:intervju(playerid, const params[])
{
	if (!IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Ne nalazite se u RNL vozilu.");
	else
	{
		new model = GetVehicleModel(GetPlayerVehicleID(playerid));
		if (model != RNL_VAN && model != RNL_HELI)
			return ErrorMsg(playerid, "Ne nalazite se u RNL vozilu.");
	}

	if (IsPlayerConnected(gInterviewer) && gInterviewer != playerid)
		return ErrorMsg(playerid, "Intervju je vec aktivan (%s).", ime_rp[gInterviewer]);

	// --------------------------------------------------
	if (!isnull(params) && !strcmp(params, "off", true))
	{
		if (!IsInterviewActive())
			return ErrorMsg(playerid, "Intervju nije ukljucen.");

		if (gInterviewer != playerid && PlayerFlagGet(playerid, FLAG_RNL_LEADER))
			return ErrorMsg(playerid, "Intervju moze prekinuti samo voditelj.");

		// Iskljucivanje intervjua
		SendClientMessageF(playerid, gClrBase, "INTERVIEW | {%s}Prekinuli ste intervju.", g_sClrLighter);

		if (IsPlayerConnected(gInterviewee[0]))
			SendClientMessageF(gInterviewee[0], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je prekinuo intervju.", g_sClrLighter, ime_rp[playerid]);

		if (IsPlayerConnected(gInterviewee[1]))
			SendClientMessageF(gInterviewee[1], gClrBase, "INTERVIEW | Voditelj {%s}%s {FF8533}je prekinuo intervju.", g_sClrLighter, ime_rp[playerid]);

		gInterviewer = gInterviewee[0] = gInterviewee[1] = INVALID_PLAYER_ID;
		return 1;
	}
	// --------------------------------------------------

	new targetid_1, targetid_2;
	if (sscanf(params, "uU(-1)", targetid_1, targetid_2))
		return Koristite(playerid, "intervju [Sagovornik 1] [Sagovornik 2]");

	if (!IsPlayerConnected(targetid_1))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (targetid_2 == targetid_1) targetid_2 = INVALID_PLAYER_ID;

	if (!IsPlayerNearPlayer(playerid, targetid_1, 5.0))
		return ErrorMsg(playerid, "Previse ste daleko od tog igraca.");

	if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(targetid_1))
		return ErrorMsg(playerid, "Taj igrac mora sedeti u Vasem vozilu.");

	if (targetid_1 == playerid || targetid_2 == playerid)
		return ErrorMsg(playerid, "Ne mozete intervjuisati sebe.");

	if (IsPlayerConnected(targetid_2))
	{
		if (!IsPlayerNearPlayer(playerid, targetid_2, 5.0))
		return ErrorMsg(playerid, "Previse ste daleko od sagovornika 2.");

		if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(targetid_2))
			return ErrorMsg(playerid, "Sagovornik 2 mora sedeti u Vasem vozilu.");

		gInterviewee[1] = targetid_2;

		SendClientMessageF(targetid_2, gClrBase, "INTERVIEW | Intervju je zapocet | Voditelj: {%s}%s, {FF8533}Sagovornik: {%s}%s", g_sClrLighter, ime_rp[playerid], g_sClrLighter, ime_rp[targetid_1]);
		SendClientMessageF(targetid_2, gClrLighter, "* Koristite {FF8533}/i {%s}za chat sa voditeljem i sagovornikom.", g_sClrLighter);

		SendClientMessageF(targetid_1, gClrBase, "INTERVIEW | Intervju je zapocet | Voditelj: {%s}%s, {FF8533}Sagovornik: {%s}%s", g_sClrLighter, ime_rp[playerid], g_sClrLighter, ime_rp[targetid_2]);
		SendClientMessageF(targetid_1, gClrLighter, "* Koristite {FF8533}/i {%s}za chat sa voditeljem i sagovornikom.", g_sClrLighter);
	}
	else
	{
		gInterviewee[1] = INVALID_PLAYER_ID;

		SendClientMessageF(targetid_1, gClrBase, "INTERVIEW | Intervju je zapocet | Voditelj: {%s}%s", g_sClrLighter, ime_rp[playerid]);
		SendClientMessageF(targetid_1, gClrLighter, "* Koristite {FF8533}/i {%s}za chat sa voditeljem.", g_sClrLighter);
	}

	gInterviewer = playerid;
	gInterviewee[0] = targetid_1;

	SendClientMessageF(playerid, gClrBase, "INTERVIEW | Intervju je zapocet | Sagovornici: {%s}%s, %s", g_sClrLighter, ime_rp[targetid_1], (IsPlayerConnected(targetid_2)? (ime_rp[targetid_2]) : ("Niko")));
	SendClientMessageF(playerid, gClrLighter, "* Koristite {FF8533}/i {%s}za chat sa sagovornicima.", g_sClrLighter);

	return 1;
}

// flags:i(FLAG_RNL_LEADER | FLAG_RNL_MEMBER);
CMD:i(playerid, const params[])
{
	if (!IsInterviewActive())
		return ErrorMsg(playerid, "Trenutno nije aktivan intervju.");

	if (gInterviewer != playerid && gInterviewee[0] != playerid && gInterviewee[1] != playerid)
		return ErrorMsg(playerid, "Niste ucesnik ovog intervjua.");

	if (isnull(params))
		return Koristite(playerid, "i [Tekst poruke]");

	new sPrefix[11];
	if (gInterviewer == playerid)
	{
		format(sPrefix, sizeof sPrefix, "Voditelj");
	}
	else
	{
		format(sPrefix, sizeof sPrefix, "Sagovornik");
	}

	new sMsg[145];
	format(sMsg, sizeof sMsg, "RNL | %s %s[%i]: {%s}%s", sPrefix, ime_rp[playerid], playerid, g_sClrLighter, params);
	SendClientMessageToAll(gClrBase, sMsg);
	return 1;
}

flags:news(FLAG_RNL_LEADER | FLAG_RNL_MEMBER)
CMD:news(playerid, const params[])
{
	if (isnull(params))
		return Koristite(playerid, "news [Tekst poruke]");

	new sMsg[145];
	format(sMsg, sizeof sMsg, "RNL | Voditelj %s[%i]: {%s}%s", ime_rp[playerid], playerid, g_sClrLighter, params);
	SendClientMessageToAll(gClrBase, sMsg);
	return 1;
}