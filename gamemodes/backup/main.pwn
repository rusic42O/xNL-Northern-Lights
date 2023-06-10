/*  
    Version: v4.2
    New Maintainer: Zile42O (github.com/zile42O)
    Past maintainers: Hoxxy & Nate; Medo & daddyDOT
    Rework and Improvement by Zile42O
*/
#define 			CGEN_MEMORY 150000

/*
    Boje za TD i izmeniti u chat isto
    B4CDEDFF - svetlo plava
    0D1821FF - tamno
*/
//Main
#define MAX_PLAYERS 1000
#define MAX_VEHICLES 2000
#include <a_samp>

#include <crashdetect>
#include <sscanf2>
#include <weapon-config>
//#include <logger>

#if defined _ALS_OnPlayerGiveDamage
	#undef OnPlayerGiveDamage
#else
	#define _ALS_OnPlayerGiveDamage
#endif
#define OnPlayerGiveDamage NULL_OnPlayerGiveDamage
#if defined NULL_OnPlayerGiveDamage
	forward NULL_OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid);
#endif
#if defined _ALS_OnPlayerTakeDamage
	#undef OnPlayerTakeDamage
#else
	#define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage NULL_OnPlayerTakeDamage
#if defined NULL_OnPlayerTakeDamage
	forward NULL_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid);
#endif

#define YSI_YES_HEAP_MALLOC

#include <a_mysql>
#include <streamer>
#include <colandreas>
#include <Pawn.Regex>
#include <Pawn.CMD>

//Other
#include <cuffs>
#include <progress2>
#include <md-sort>
#include <rbits>
#include <strlib>
#include <md-sort>
//#undef IsEven
//#include "3DTryg.inc"
#include "mSelection.inc"
//YSI
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_inline>

#include <YSI_Core\y_utils>
#include <YSI_Server\y_flooding>

#include <YSI_Coding\y_hooks>
//#include <YSI_Visual\y_dialog\y_dialog_impl>

#include <bcrypt>
#define BCRYPT_COST 12

#include <nex-ac_en.lang>
#include <nex-ac>

hook OnGameModeInit() {

    Streamer_ToggleChunkStream(0);
    Streamer_SetVisibleItems(STREAMER_TYPE_OBJECT, 750, -1);
    CA_Init();
    //SnowMap_Init();
    SetMaxConnections(2, e_FLOOD_ACTION_OTHER);
    return true;
}
#define RandomEx(%0,%1) (random(%1 - %0 + 1) + %0)

#define GetPlayerCameraLookAt(%0,%1,%2,%3)						GetPointInFrontOfCamera3D((%0),(%1),(%2),(%3),5.0)
#define CompressRotation(%0)						((%0)-floatround((%0)/360.0,floatround_floor)*360.0)

stock GetPointInFrontOfCamera3D(playerid,&Float:tx,&Float:ty,&Float:tz,Float:radius,&Float:rx=0.0,&Float:rz=0.0){
	new Float:x,Float:y,Float:z;
	GetPlayerCameraPos(playerid,x,y,z);
	GetPlayerCameraRotation(playerid,rx,rz);
	GetPointInFront3D(x,y,z,rx,rz,radius,tx,ty,tz);
}

stock GetPlayerCameraRotation(playerid,&Float:rx,&Float:rz){
	new Float:mx,Float:my,Float:mz;
	GetPlayerCameraFrontVector(playerid,mx,my,mz);
	rx = CompressRotation(-(acos(mz)-90.0));
	rz = CompressRotation((atan2(my,mx)-90.0));
}

stock GetPointInFront3D(Float:x,Float:y,Float:z,Float:rx,Float:rz,Float:radius,&Float:tx,&Float:ty,&Float:tz){
	tx = x - (radius * floatcos(rx,degrees) * floatsin(rz,degrees));
	ty = y + (radius * floatcos(rx,degrees) * floatcos(rz,degrees));
	tz = z + (radius * floatsin(rx,degrees));
}

//Modules
#include "modules/modules.pwn"

#pragma unused SetInlineTimer

main() 
{
    printf("\n\n\n");                                                                                   
    printf("Northern Lights / www.nlsamp.com");
    printf("Developer: z1ann");
    printf("Version: NL"#MOD_VERZIJA);
    printf("\n\n\n");
	WasteDeAMXersTime();
}
public OnFloodLimitExceeded(ip[16], count)
{
    foreach(new i : FloodingPlayer)
    {
        printf("- AC: Igrac %s (%i) je izbacen sa servera zbog previse konekcija sa njegove IP adrese | %s.", ime_obicno[i], i, ip);
        //StaffMsg(0xFF0000FF, "- AC: {FFFFFF}Igrac \"{FF0000}%s (%i){FFFFFF}\" je izbacen sa servera zbog previse konekcija sa njegove IP adrese | {FF0000}%s.", ime_obicno[i], i, ip);
        Kick(i);
    }

    return true;
}
public OnGameModeInit()
{
    print("Preparing script..");
    djMusicLink[0] = EOS;
    mysql_tquery(SQL, "SELECT value FROM server_info WHERE field = 'overwatch'", "MYSQL_OverwatchConfig");

    // ucitavanje iz baze
	ucitavanje_pocetak = GetTickCount();

    // regex
    regex_ime = Regex_New("([A-Z]{1,1})[a-z]{2,13}_([A-Z]{1,1})[a-z]{2,13}");
    regex_spec_ime = Regex_New("([A-Z]{1,1})[a-z]{2,13}");
    regex_email = Regex_New("([a-zA-Z0-9_\\.]{3,})+@([a-zA-Z0-9\\-]{3,})+\\.+[a-zA-Z]{2,4}");
    
    // global-config;
	SetGameModeText("NL "#MOD_VERZIJA);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ManualVehicleEngineAndLights();
	SetWeather_H(0);

    // weapon-config
    SetVehiclePassengerDamage(true);
    SetVehicleUnoccupiedDamage(true);
    SetDisableSyncBugs(true);
    SetDamageFeed(true);    
    SetWeaponDamage(WEAPON_SILENCED, DAMAGE_TYPE_STATIC, 0.1);

	gChatCleared 		= gettime();
	Oznaceno[0] 		= -9999;
	respawn_pokrenut    = false;

	for__loop (new i = 0; i < 312; i++) 
    {
		AddPlayerClass(i, 1765.2643,-1342.9196,15.7564,242.7716, 0, 0, 0, 0, 0, 0);
	}


    // Pickupi/labeli sa informacijama (credits)
    new credits[229];
    format(credits, sizeof credits, "{7188da}- Northern Lights Roleplay -\n{FFFFFF}Owner:{f82e2e} ZERO \n{FFFFFF}Version:{7188da} v4.2 by Zile42O | /update\n\n{7188da}All rights reserved\n___\nwww.nlsamp.com");
    CreateDynamicPickup(18749, 1, 1798.6270,-1777.7433,13.5453+0.8); // Glavni spawn
    CreateDynamic3DTextLabel(credits, BELA, 1798.6270,-1777.7433,13.5453+0.5, 35.0);

    // timeri;
	SetTimer("odbrojavanja", 1000, true);
    tmrIntroCam = 0;

    // zone;
    zona_area51 = CreateDynamicRectangle(2874.9028,-3016.1875,3126.9976,-2720.1509);
	LOADED[l_init] = 1;
	return 1;
}

public OnGameModeExit()
{
    mysql_close(SQL);
	Regex_Delete(regex_ime); // Server crashuje kod GMX-a bez ovoga
    Regex_Delete(regex_spec_ime);
    Regex_Delete(regex_email);
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if (IsPlayerLoggedIn(playerid)) 
		SpawnPlayer(playerid);		
	return 0;
}

public OnIncomingConnection(playerid, ip_address[], port) 
{
	SendRconCommand("reloadbans");
    return true;
}

public OnPlayerConnect(playerid)
{
    resetuj_promenljive(playerid);
	return true;
}

public OnPlayerDisconnect(playerid, reason) 
{
	KillTimer(tajmer:kick[playerid]);

    if (Iter_Contains(iPlayersConnecting, playerid))
        Iter_Remove(iPlayersConnecting, playerid);

    if (IsValidDynamic3DTextLabel(pText3D[playerid]))
    {
        DestroyDynamic3DTextLabel(pText3D[playerid]), pText3D[playerid] = Text3D:INVALID_3DTEXT_ID;
    }


	new razlog[8];
	switch (reason) 
    {
	    case 0: razlog = "crash";
	    case 1: razlog = "izasao";
	    case 2: 
        {
	        if (kicked{playerid}) razlog = "izbacen";
	        else razlog = "ban";
	    }
	    default: razlog = "???";
	}
	format(string_64, 64, "** (( %s je napustio server (%s) ))", ime_rp[playerid], razlog);
	RangeMsg(playerid, string_64, GRAD1, 50.0);

    new exitStr[128], exitColor = -1;
    if (PI[playerid][p_helper] > 0) 
    {
        format(exitStr, sizeof exitStr, "HELPER | %s je napustio server (%s).", ime_rp[playerid], razlog);
        exitColor = ZELENOZUTA;
    }
    else if (PI[playerid][p_admin] > 0 && PI[playerid][p_admin] < 6) 
    {
        format(exitStr, sizeof exitStr, "GAME ADMIN | %s je napustio server (%s).", ime_rp[playerid], razlog);
        exitColor = SVETLOPLAVA;
    }
    else if (PI[playerid][p_admin] >= 6 && !IsPlayerOwner(playerid)) 
    {
        format(exitStr, sizeof exitStr, "HEAD ADMIN | %s je napustio server (%s).", ime_rp[playerid], razlog);
        exitColor = ZUTA;
    }
    else if (PI[playerid][p_admin] >= 6 && IsPlayerOwner(playerid)) 
    {
        format(exitStr, sizeof exitStr, "OWNER | %s je napustio server (%s).", ime_rp[playerid], razlog);
        exitColor = CRVENA;
    }
    else
    { 
        if (IsPlayerLoggedIn(playerid))
        {
            format(exitStr, sizeof exitStr, "Igrac %s je napustio server (%s).", ime_rp[playerid], razlog);
            exitColor = GRAD2;
        }
    }
    if (exitColor != -1)
    {
        foreach (new i : Player)
        {
            if (IsHelper(i, 1) && IsChatEnabled(i, CHAT_CONNECTIONS))
            {
                SendClientMessage(i, exitColor, exitStr);
            }
        }
    }


	if (IsPlayerLoggedIn(playerid))  
    {
		// Brisanje iz tablice crash:
        new sQuery[38];
		format(sQuery, sizeof sQuery, "DELETE FROM crash WHERE pid = %d", PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_CRASHDELETE);

		if (!IsPlayerInRace(playerid) && GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 0 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 0 && !IsPlayerInWar(playerid) && !IsPlayerInDMArena(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid)) 
        {
		    // Nije na trci, nije u auto salonu, nije u waru, nije na dm eventu, a dogodio se crash

		    // Spremanje podataka u tablicu za narednih 5 minuta
			new
				istice = gettime() + 300,
				Float:health,
				Float:armour,
				oruzje[13],
				municija[13],
				vw = GetPlayerVirtualWorld(playerid),
				enterijer = GetPlayerInterior(playerid),
				
				sPos[51],
				sWeapons[38],
				sAmmo[80]
			;
		  	GetPlayerHealth(playerid, health);
			GetPlayerArmour(playerid, armour);
			GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
			GetPlayerFacingAngle(playerid, pozicija[playerid][3]);
			
			// Formatiranje stringa za poziciju
			format(sPos, sizeof(sPos), "%.2f|%.2f|%.2f|%.2f|%d|%d", pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], pozicija[playerid][3], enterijer, vw);
			
            if (!IsPlayerOnLawDuty(playerid))
            {
                // Igracu se cuvaju oruzja ukoliko _NIJE_ na PD duznosti
                if(!IsPlayerInDMArena(playerid)) {
                    for__loop (new i = 0; i < 13; i++)
                        GetPlayerWeaponData(playerid, i, oruzje[i], municija[i]); // TODO povezati sa overwatchom
                } 
            }
            else
            {
                // Ukoliko je na PD duznosti, oruzja se nece cuvati
                for__loop (new i = 0; i < 13; i++) oruzje[i] = municija[i] = 0;
            }

            // Formatiranje stringa za oruzje
            format(sWeapons, sizeof(sWeapons), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d", oruzje[0], oruzje[1], oruzje[2], oruzje[3], oruzje[4], oruzje[5], oruzje[6], oruzje[7], oruzje[8], oruzje[9], oruzje[10], oruzje[11], oruzje[12]);
            
            // Formatiranje stringa za municiju
            format(sAmmo, sizeof(sAmmo), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d", municija[0], municija[1], municija[2], municija[3], municija[4], municija[5], municija[6], municija[7], municija[8], municija[9], municija[10], municija[11], municija[12]);

			// Upisivanje u bazuž
            new query[275];
			format(query, sizeof query, "INSERT INTO crash VALUES (%d, %d, '%s', %.2f, %.2f, '%s', '%s')", PI[playerid][p_id], istice, sPos, health, armour, sWeapons, sAmmo);
			mysql_tquery(SQL, query);
		}


		// Cuvanje igracevih podataka
		new
            query[360],
			provedeno_vreme = PI[playerid][p_provedeno_vreme] + (gettime() - gJoinTimestamp[playerid]),
			org_vreme = 0
        ;
        if (PI[playerid][p_org_id] != -1) org_vreme = PI[playerid][p_org_vreme] + (gettime() - f_ts_initial[playerid]);

		format(query, sizeof query, "UPDATE igraci SET nivo = %d, novac = %d, banka = %d, iskustvo = %d, zavezan = %d, area = %d, zatvoren = %d,  utisan = %d, poslednja_aktivnost = CURRENT_TIMESTAMP, provedeno_vreme = %d, glad = %d, org_vreme = %d, payday = %d, aktivnaigra = '%d|%d', ip = '%s' WHERE id = %d", 
            PI[playerid][p_nivo], PI[playerid][p_novac], PI[playerid][p_banka], PI[playerid][p_iskustvo], PI[playerid][p_zavezan], PI[playerid][p_area], PI[playerid][p_zatvoren], PI[playerid][p_utisan], provedeno_vreme, PI[playerid][p_glad], org_vreme, PAYDAY_GetTimeLeft(playerid), gettime()+300, AKTIGRA_GetPts(playerid), PI[playerid][p_ip], PI[playerid][p_id]);
		mysql_tquery(SQL, query);

		// Obavestenje drugom igracu kod kupoprodaje/transfera
		foreach(new i : Player) 
        {
			if (PrimioPM[i] == playerid) 
				PrimioPM[i] = -1;
				
			if (transfer_id[i] == playerid) 
            {
				SendClientMessage(i, SVETLOCRVENA, "* Igrac kome zelite da posaljete novac je napustio server.");
				transfer_id[i] 		 = -1;
				transfer_od[i] 		 = -1;
				transfer_iznos[i] 	 = 0;
				transfer_ponudjen{i} = false;
				//HidePlayerDialog(i);
			}
		}
	}

	// Attached objects removal
	if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);



	// Sve ispod ovoga mora da bude na kraju callbacka
	// -----------------------
	respawnaj_vozilo(playerid);
	resetuj_promenljive(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (PI[playerid][p_utisan] > 0) 
    {
        SetPlayerChatBubble(playerid, "(( Ovaj igrac je UTISAN ))", 0xFF0000AA, 15.0, PI[playerid][p_utisan]*1000);
    }


	// Sakrivanje nepotrebnih textdrawova
	for__loop (new i; i < 4; i++)
	{
		TextDrawHideForPlayer(playerid, tdDeathScreen[i]);
	}


    if (!IsPlayerInWar(playerid) && !IsPlayerJailed(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid) && !IsPlayerInLMSEvent(playerid)) 
	{
        // Ako nije u waru ili zatvoru, spawna ga u bolnici ako je umro
		if (gHospitalBill[playerid] != 0 && GetPVarInt(playerid, "pIgnoreDeathFine") != 1)
		{
		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		    SendClientMessageF(playerid, SVETLOCRVENA2, "Bili ste ranjeni i sada placate bolnicki racun u iznosu od %s.", formatMoneyString(gHospitalBill[playerid]));
		    PlayerMoneySub(playerid, gHospitalBill[playerid]);            
            // Upisivanje u log (zbog pracenja novca)
            new sLog[45];
            format(sLog, sizeof sLog, "%s | %s", ime_obicno[playerid], formatMoneyString(gHospitalBill[playerid]));
            Log_Write(LOG_LECENJE, sLog);

		    gHospitalBill[playerid] = 0;

            // Vraca mu spawn tamo gde treba za sledeci put
            SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);
		}
	}

	if (PI[playerid][p_zatvoren] > 0) stavi_u_zatvor(playerid, false);
    if (PI[playerid][p_area] > 0) stavi_u_zatvor(playerid, true);

	if (!IsPlayerJailed(playerid) && PI[playerid][p_zavezan] > 0 && GetPVarInt(playerid, "pKilledByAdmin") != 1) 
	{
        // Izasao dok je bio zavezan

        new alcTime; // kazna u minutima
        new fine;
        if (BP_PlayerHasItem(playerid, ITEM_HEROIN) || BP_PlayerHasItem(playerid, ITEM_MDMA) || BP_PlayerHasItem(playerid, ITEM_WEED) || BP_PlayerHasItem(playerid, ITEM_WEED_RAW) || BP_PlayerHasItem(playerid, ITEM_MATERIALS))
        {
            alcTime = 150; // veca kazna ako je igrac imao drogu kod sebe
            fine = 5;
            // fine = PI[playerid][p_nivo] * 10000;
        }
        else
        {
            alcTime = 60;
            fine = 2;
            // fine = 50000;
        }

        PunishPlayer(playerid, INVALID_PLAYER_ID, alcTime, 0, fine, false, "LTA");
        SetTimerEx("ShowRulesDialog_OTHER", 30000, false, "ii", playerid, cinc[playerid]);

        // Smanjuje se skill
        if (IsACriminal(playerid))
            PlayerUpdateCriminalSkill(playerid, -20, SKILL_LTA, 0);
        else if (IsACop(playerid))
            PlayerUpdateCopSkill(playerid, -20, SKILL_LTA, 0);
	}

    if (!IsPlayerJailed(playerid) && PI[playerid][p_novac] < -50000 && GetPVarInt(playerid, "pKilledByAdmin") != 1)
    {
        PunishPlayer(playerid, INVALID_PLAYER_ID, 30, 0, 0, false, "Minus u rukama");
    }



	// Sve ispod ovoga mora da bude na kraju callbacka
	// -------------------------------------------------------
	if (GetPlayerInterior(playerid) == 0) 
    {
		SetPlayerTime(playerid, GetWorldTime_H(), 0);
		SetPlayerWeather(playerid, GetWeather_H());
	}

	SetCameraBehindPlayer(playerid);

    // Animations preloading
    if (!gAnimationsPreloaded{playerid})
    {
        gAnimationsPreloaded{playerid} = true;

        PreloadAnimLib(playerid, "CARRY");
        PreloadAnimLib(playerid, "SHOP");
        PreloadAnimLib(playerid, "GYMNASIUM");
        PreloadAnimLib(playerid, "PED");
        PreloadAnimLib(playerid, "BOMBER");
        PreloadAnimLib(playerid, "SWORD");
        PreloadAnimLib(playerid, "KNIFE");
        PreloadAnimLib(playerid, "CRACK");
        PreloadAnimLib(playerid, "ON_LOOKERS");
        PreloadAnimLib(playerid, "BLOWJOBZ");
        PreloadAnimLib(playerid, "BD_FIRE");
    }

	// Attached objects removal
	if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);

    if (!IsPlayerInWar(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid) && !IsPlayerInLMSEvent(playerid))
    {
        SetPlayerHealth(playerid, PI[playerid][p_spawn_health]);
        SetPlayerArmour(playerid, PI[playerid][p_spawn_armour]);
    }

    DeletePVar(playerid, "pIgnoreDeathFine");
    if(!IsPlayerInDMEvent(playerid) && !IsPlayerJailed(playerid)) {
		SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
    }
    
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    //SendDeathMessage(killerid, playerid, reason);
	gPlayerSpawned{playerid} = false;
	for__loop (new i; i < 4; i++)
		TextDrawShowForPlayer(playerid, tdDeathScreen[i]);

//    Speedo_Hide(playerid);

	PI[playerid][p_zavezan] = 0; // Ne daje se kazna za LTA kad igrac umre

	if (GetPVarInt(playerid, "pKilledByAdmin") != 1 && GetPVarInt(playerid, "pIgnoreDeathFine") != 1)
	{
	    // --- AKO IGRAC *NIJE* UBIJEN OD STRANE ADMINA (UBISTVO, SAMOUBISTVO, SMRT) ---
		if (!IsPlayerInRace(playerid) && !IsPlayerInWar(playerid) && !IsPlayerInDMEvent(playerid) && !IsPlayerInHorrorEvent(playerid)) // Nije ucesnik trke
		{
			if (PI[playerid][p_nivo] >= 3)
			{
				if (PI[playerid][p_nivo] == 3) gHospitalBill[playerid] = 300;
				else gHospitalBill[playerid] = ((PI[playerid][p_nivo] - 3) * 150) + 300;

                // Spawn ispred bolnice
                if (random(2) == 0)
                {
                	SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), 1211.9316, -1319.3781, 15.0321, 270.0, 0, 0, 0, 0, 0, 0);
                }
                else
                {   //
                	SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), 2022.6838,-1416.1942,16.9921,173.1294, 0, 0, 0, 0, 0, 0);
                }
                
			}
			if (IsPlayerConnected(killerid))
			{
				// Ubica je na serveru

				if (IsNewPlayer(killerid)) // Ubica je novi igrac
				{
					SendClientMessage(killerid, CRVENA, "OVERWATCH | {FFFFFF}Ukoliko nastavite sa ubijanjem igraca bez razloga, mozete biti kaznjeni od strane Game Admina!");
				}
			}
		}
	}

	// --- NEBITNO DA LI JE IGRAC UBIJEN OD STRANE ADMINA ILI NE ---


	// Provera za TK
	// Ide na kraju celog callback-a da bi prednost imala kazna za ubistvo robbera koja je veca
	if (IsPlayerConnected(playerid)  && IsPlayerConnected(killerid)) {
        if (PI[playerid][p_org_id] != -1 && PI[killerid][p_org_id] != -1) {
            if (PI[killerid][p_org_id] == PI[playerid][p_org_id]) {
                if (!IsPlayerInWar(killerid) 
                    && !IsPlayerInDMEvent(killerid) 
                    && !IsPlayerInHorrorEvent(killerid) 
                    && !IsPlayerInVSEvent(killerid) 
                    && !IsPlayerInBoxEvent(killerid)
                    && !IsPlayerInDMArena(killerid)
                    && !IsPlayerInWar(playerid) 
                    && !IsPlayerInDMEvent(playerid) 
                    && !IsPlayerInHorrorEvent(playerid) 
                    && !IsPlayerInVSEvent(playerid) 
                    && !IsPlayerInBoxEvent(playerid) 
                    && !IsPlayerInDMArena(playerid))
                {
                    PromptPunishmentDialog(playerid, killerid, 20, 0, 1, "TK");
                }
            }
        }
    }

	
	// Proveravamo da li je igac clan neke organizacije
	// Ako da, da li mu je spawn postavljen na bazu, i da li ima dozvolu da se spawna tamo?
	if (PI[playerid][p_org_id] != -1)
	{
		new f_id = PI[playerid][p_org_id];
		
		if (PI[playerid][p_spawn_x] == FACTIONS[f_id][f_x_spawn] && PI[playerid][p_spawn_y] == FACTIONS[f_id][f_y_spawn])
		{
			if ((F_RANKS[f_id][PI[playerid][p_org_rank]][fr_dozvole] & DOZVOLA_SPAWN) == 0) // Nema dozvolu za spawn
				dialog_respond:spawn(playerid, 1, 0, ""); // Postavlja spawn na default
		}
	}
	
	if (ft_edit[playerid] != -1) // Izmenjuje neki predmet u kuci
	{
		CancelEdit(playerid);
		ft_edit[playerid] = -1;
	}

	// Attached objects removal
	if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);

	SetPlayerAlive(playerid, false);
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	// Gasenje motora na vozilu, odnosno paljenje ako je u pitanju bicikl + gasenje svetala
    new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if (IsVehicleBicycle(GetVehicleModel(vehicleid)) == 1) 
    {
        SetVehicleParamsEx(vehicleid, 1, 0, 0, doors, bonnet, boot, objective);
    }
	else 
    {
        SetVehicleParamsEx(vehicleid, 0, 0, 0, doors, bonnet, boot, objective);
    }

	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (!ispassenger)
	{
    	foreach(new i : Player)
		{
		    if (GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_DRIVER)
		    {
                if (i == playerid) break;

				GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
				SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.5);
		        overwatch_poruka(playerid, "Ne mozete ukrasti vozilo dok je neko drugi u njemu!");
		        return 1;
		    }
		}
	}
	
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    // NE BRISATI OVAJ CALLBACK

    return 1;
}

public OnPlayerDamage(&playerid, &Float:amount, &issuerid, &weapon, &bodypart)
{
    if(weapon == WEAPON_KNIFE || weapon == WEAPON_FIREEXTINGUISHER)
    {
        return 0;
    }

    // NE BRISATI
    //if (!AvoidBolnicarDeath(playerid, amount, issuerid))
    //{
    //    if (!BolnicarPreDeathHook(playerid, amount, issuerid, weapon, bodypart)) return false; //fix hook da hook odradi pravilno
    //}
    return 1;
}

stock AvoidBolnicarDeath(playerid, Float:amount, issuerid)
{
    new Float: health;
	GetPlayerHealth(playerid, health);
    if (amount >= health && amount != 420.0)
    {
        if(joinedWar[playerid] || IsPlayerInBoxEvent(playerid) || IsPlayerOnActiveTurf(playerid) || IsPlayerNPC(issuerid) || IsPlayerNPC(playerid) || IsPlayerInWar(playerid) || IsPlayerJailed(playerid) || IsPlayerInDMEvent(playerid) || IsPlayerInHorrorEvent(playerid) || IsPlayerInLMSEvent(playerid) || IsPlayerInDMArena(playerid))
            return true;
    }
    return false;
}

public OnPlayerDamageDone(playerid, Float:amount, issuerid, weapon, bodypart)
{
    // playerid = damagedid (primio damage)
    // issuerid = zadao damage
    SetPVarInt(playerid, "pTookDamage", gettime());
    SetPVarInt(playerid, "pTookDamageID", issuerid);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if (newstate == PLAYER_STATE_DRIVER) 
    {
	    new 
            vehicleid = GetPlayerVehicleID(playerid); // ID novog vozila

        new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		if ((engine == -1 || engine == 0) && IsVehicleBicycle(GetVehicleModel(vehicleid)) == 0) 
        {
		    SendClientMessage(playerid, ZELENA, "(vozilo) {FFFFFF}Motor vozila je ugasen. Da ga upalite pritisnite tipku [2].");
            //GameTextForPlayer(playerid, "~r~Motor vozila je ugasen!~n~~w~Da ga upalite pritisnite tipku ~g~~k~~SNEAK_ABOUT~", 5000, 3);
		}
		
		GetVehiclePos(GetPlayerVehicleID(playerid), km_pos[playerid][POS_X], km_pos[playerid][POS_Y], km_pos[playerid][POS_Z]);

		kilometraza[playerid] = 0.0;
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if (newinteriorid != 0) // Ulazi u enterijer
    {
        SetPlayerTime(playerid, 12, 0);
        SetPlayerWeather(playerid, 0);
    }
    else // Izlazi napolje
    {
        SetPlayerTime(playerid, GetWorldTime_H(), 0);
        SetPlayerWeather(playerid, GetWeather_H());
    }

    if (newinteriorid == 0 && oldinteriorid != 0)
    {
        RefreshPlayerCheckpoint_H(playerid);
    }
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// seif_walk
    /*if (((newkeys & KEY_WALK && newkeys & KEY_UP) || (newkeys & KEY_WALK && newkeys & KEY_DOWN) || (newkeys & KEY_WALK && newkeys & KEY_LEFT) || (newkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| ((oldkeys & KEY_WALK && newkeys & KEY_UP) || (oldkeys & KEY_WALK && newkeys & KEY_DOWN) || (oldkeys & KEY_WALK && newkeys & KEY_LEFT) || (oldkeys & KEY_WALK && newkeys & KEY_RIGHT))
		|| ((newkeys & KEY_WALK && oldkeys & KEY_UP) || (newkeys & KEY_WALK && oldkeys & KEY_DOWN) || (newkeys & KEY_WALK && oldkeys & KEY_LEFT) || (newkeys & KEY_WALK && oldkeys & KEY_RIGHT))
		&& GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
			tajmer:walktime[playerid] = SetTimerEx("WalkAnim", 200, false, "i", playerid);*/

    if (newkeys & KEY_JUMP && !(oldkeys & KEY_JUMP) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED) 
        ApplyAnimation(playerid, "GYMNASIUM", "gym_jog_falloff",4.1,0,1,1,0,0);

	if (!(newkeys & KEY_CROUCH) && oldkeys & KEY_CROUCH) // C / H / Capslock
	{
	   	if (GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
		{
		    if (driveby{playerid} == false) driveby{playerid} = true;
		    else
		    {
				cur_wep[playerid] = GetPlayerWeapon(playerid);
				SetPlayerArmedWeapon(playerid, 0);

				// Nastavak pod OnPlayerUpdate()
			}
		}
	}    
	if (newkeys & KEY_JUMP) // Shift
	{
	    if (!(oldkeys & KEY_JUMP) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
		    gPlayerReversing{playerid} = true;
		    return 1;
	    }
	}
	if (newkeys & KEY_FIRE) // Levi klik
	{
       	if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    	{
    	    new 
                vehicleid = GetPlayerVehicleID(playerid),
                engine, lights, alarm, doors, bonnet, boot, objective,
                Float:HP,
                bool:nitro = false
            ;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
			if (IsVehicleBicycle(GetVehicleModel(vehicleid)) == 1) return 1;
			if (engine == 0 || engine == -1)
			{
			    if (GetVehicleFuel(vehicleid) <= 0.0) 
                    return SendClientMessage(playerid, ZUTA, "Nemate goriva u vozilu, ne mozete upaliti motor!");

				GetVehicleHealth(vehicleid, HP);
				if (HP < 280.0) {
                    SendClientMessage(playerid, ZUTA, "* Vase vozilo je previse osteceno, ne mozete ga voziti!");
                    SendClientMessage(playerid, NARANDZASTA, "Kako biste popravili ostecenje, pozovite mehanicare komandom /pozovi");
                    return 1;
                }
			    if (GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO) == 1010) {
                    nitro = true;
                    RemoveVehicleComponent(vehicleid, 1010);
                }
				SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
				format(string_128, sizeof string_128, "** %s pali motor na vozilu %s.", ime_rp[playerid], imena_vozila[GetVehicleModel(vehicleid) - 400]);
				RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
				if (nitro == true) SetTimerEx("RestoreVehicleNitro", 500, false, "i", vehicleid);
			}
		}
	}
	
	if (newkeys & KEY_SUBMISSION) // 2
	{
	    if (IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	    {
    	    new 
                vehicleid = GetPlayerVehicleID(playerid),
                engine, lights, alarm, doors, bonnet, boot, objective;

			if (IsVehicleBicycle(GetVehicleModel(vehicleid))) return 1;

			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
			if (engine == 1)
			{
				SetVehicleParamsEx(vehicleid, 0, 0, alarm, doors, bonnet, boot, objective);
				format(string_128, sizeof string_128, "** %s gasi motor na vozilu %s.", ime_rp[playerid], imena_vozila[GetVehicleModel(vehicleid) - 400]);
				RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
			}

			else if (engine == 0 || engine == -1)
			{
				new Float:HP;

				if (GetVehicleFuel(vehicleid) <= 0.0)
				return SendClientMessage(playerid, ZUTA, "Nemate goriva u vozilu, ne mozete upaliti motor!");

				GetVehicleHealth(vehicleid, HP);
				if (HP < 280.0)
				{
					SendClientMessage(playerid, ZUTA, "* Vase vozilo je previse osteceno, ne mozete ga voziti!");
					SendClientMessage(playerid, NARANDZASTA, "Kako biste popravili ostecenje, pozovite mehanicare komandom /pozovi");
					return 1;
				}
				SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
				format(string_128, sizeof string_128, "** %s pali motor na vozilu %s.", ime_rp[playerid], imena_vozila[GetVehicleModel(vehicleid) - 400]);
				RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
			}
		}
	}
	if (oldkeys & KEY_JUMP) 
        gPlayerReversing{playerid} = false;

	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) 
{
    if (IsPlayerRegistering(playerid)) 
    {
		ErrorMsg(playerid, GRESKA_REGISTRACIJA);
		return 0;
	}
	
	if (!IsPlayerLoggedIn(playerid)) 
    {
		overwatch_poruka(playerid, "Ne mozete koristiti komande dok se ne prijavite!");
		return 0;
	}

    if (!(flags & pFlags[playerid]) && flags > 0)
    {
        // Komanda sa posebnim dozvolama + igrac nema dozvolu
        ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        return 0;
    }
    else
    {
        // Komanda sa posebnim dozvolama + igrac ima dozvole
        if (PlayerFlagGet(playerid, FLAG_HELPER_1) && (FlagCheck(flags, FLAG_HELPER_1) || FlagCheck(flags, FLAG_HELPER_2) || FlagCheck(flags, FLAG_HELPER_3) || FlagCheck(flags, FLAG_HELPER_4) || FlagCheck(flags, FLAG_ADMIN_1) || FlagCheck(flags, FLAG_ADMIN_2) || FlagCheck(flags, FLAG_ADMIN_3) || FlagCheck(flags, FLAG_ADMIN_4) || FlagCheck(flags, FLAG_ADMIN_5)))
        {
            // Igrac je uneo neku helper/admin komandu + on je clan staff-a
            if (!IsOnDuty(playerid) && !IsAdmin(playerid, 6) && !PlayerFlagGet(playerid, FLAG_MAPER))
            {
                // Nije na duznosti + nije head admin --> ima ogranicen dijapazon komandi
                new aOverridenCommands[][] = {"duznost", "h1", "h2", "h", "a", "pm", "kazni", "cc", "fv", "war", "proveri"};
                new bool:override = false;
                for__loop (new i = 0; i < sizeof aOverridenCommands; i++)
                {
                    if (!strcmp(cmd, aOverridenCommands[i], true))
                    {
                        override = true;
                        break;
                    }
                }
                if (!override)
                {
                    ErrorMsg(playerid, "Upotreba ove komande zahteva da imate ukljucenu duznost.");
                    return 0;
                }
            }
        }
    }
	
	if (strcmp(cmd, "time", true) && !IsHelper(playerid, 1)) // Igrac sme da koristi /time kad je utisan
	{
		antispam[playerid]++;
		if (antispam[playerid] > 1000)
		{
		    if (antispam_vreme[playerid] > gettime())
		    {
				overwatch_poruka(playerid, "Utisani ste zbog prevelikog spama komandi.");
		    	antispam[playerid] = 1200;
		    	return 0;
			}
			else antispam[playerid] = 1;
		}
		else if (antispam[playerid] >= 5)
		{
		    PI[playerid][p_utisan]  += 90;
		    antispam[playerid]       = 1200;
		    antispam_vreme[playerid] = gettime() + 90;
			overwatch_poruka(playerid, "Utisani ste zbog prevelikog spama komandi, zabranjena Vam je upotreba komandi na 90 sekundi!");
			return 0;
		}
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	if(result == -1) 
    {
        overwatch_poruka(playerid, "Ne mogu da pronadjem takvu komandu. Upisite /komande za pregled dostupnih komandi.");
        return 0;
    }
    
    #if defined DEBUG_CMD
        if (!isnull(cmd))
        {
            if (strcmp(cmd, "ha", true) && strcmp(cmd, "h", true) && strcmp(cmd, "a", true) && strcmp(cmd, "b") &&
                strcmp(cmd, "s", true) && strcmp(cmd, "c", true) && strcmp(cmd, "cw", true) && strcmp(cmd, "n") &&  
                strcmp(cmd, "f") && strcmp(cmd, "d") && strcmp(cmd, "r"))
            {
                new sLog[128];
                format(sLog, sizeof sLog, "%s | /%s %s", ime_obicno[playerid], cmd, params);
                Log_Write(LOG_CMD, sLog);
            }
        }
    #endif

	return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if (areaid == zona_area51 && PI[playerid][p_area] != 0)
    {
        stavi_u_zatvor(playerid, true);
        SendClientMessage(playerid, CRVENA, "OVERWATCH | {FFFFFF}Automatski ste vraceni u Alcatraz.");
    }
	return 1;
}

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
    new string[512];
	format(string, sizeof(string), "Error info: %s | ID: %d\r\nQuery: %s\r\n\r\n---------------------\r\n\r\n", error, errorid, query);
	Log_Write(LOG_MYSQLERROR, string);
	return 1;
}

// Overwatch v2.0 (Powered by Nex-AC)
stock GetCheatName(code)
{
    new
        string[37 + 1]
    ;
    switch(code)
    {
        case 0: format(string, sizeof string, "AirBreak (onfoot)");
        case 1: format(string, sizeof string, "AirBreak (in vehicle)");
        case 2: format(string, sizeof string, "teleport hack (onfoot)");
        case 3: format(string, sizeof string, "teleport hack (in vehicle)");
        case 4: format(string, sizeof string, "teleport hack (into/between vehicles)");
        case 5: format(string, sizeof string, "teleport hack (vehicle to player)");
        case 6: format(string, sizeof string, "teleport hack (pickups)");
        case 7: format(string, sizeof string, "FlyHack (onfoot)");
        case 8: format(string, sizeof string, "FlyHack (in vehicle)");
        case 9: format(string, sizeof string, "SpeedHack (onfoot)");
        case 10: format(string, sizeof string, "SpeedHack (in vehicle)");
        case 11: format(string, sizeof string, "Health hack (in vehicle)");
        case 12: format(string, sizeof string, "Health hack (onfoot)");
        case 13: format(string, sizeof string, "Armour hack");
        case 14: format(string, sizeof string, "Money hack");
        case 15: format(string, sizeof string, "Weapon hack");
        case 16: format(string, sizeof string, "Ammo hack (add)");
        case 17: format(string, sizeof string, "Ammo hack (infinite)");
        case 18: format(string, sizeof string, "Special actions hack");
        case 19: format(string, sizeof string, "GodMode (onfoot)");
        case 20: format(string, sizeof string, "GodMode (in vehicle)");
        case 21: format(string, sizeof string, "Invisible hack");
        case 22: format(string, sizeof string, "lagcomp-spoof");
        case 23: format(string, sizeof string, "Tuning hack");
        case 24: format(string, sizeof string, "Parkour mod");
        case 25: format(string, sizeof string, "Quick turn");
        case 26: format(string, sizeof string, "Rapid fire");
        case 27: format(string, sizeof string, "FakeSpawn");
        case 28: format(string, sizeof string, "FakeKill");
        case 29: format(string, sizeof string, "Pro Aim");
        case 30: format(string, sizeof string, "CJ run");
        case 31: format(string, sizeof string, "CarShot");
        case 32: format(string, sizeof string, "CarJack");
        case 33: format(string, sizeof string, "UnFreeze");
        case 34: format(string, sizeof string, "AFK Ghost");
        case 35: format(string, sizeof string, "Full Aiming");

        case 36: format(string, sizeof string, "Fake NPC");
        case 37: format(string, sizeof string, "Reconnect");
        case 38: format(string, sizeof string, "High ping");
        case 39: format(string, sizeof string, "Dialog hack");
        case 40: format(string, sizeof string, "sandbox");
        case 41: format(string, sizeof string, "invalid version");
        case 42: format(string, sizeof string, "Rcon hack");

        case 43: format(string, sizeof string, "Tuning crasher");
        case 44: format(string, sizeof string, "Invalid seat crasher");
        case 45: format(string, sizeof string, "Dialog crasher");
        case 46: format(string, sizeof string, "Attached object crasher");
        case 47: format(string, sizeof string, "Weapon Crasher");

        case 48: format(string, sizeof string, "connection flood in one slot");
        case 49: format(string, sizeof string, "callback functions flood");
        case 50: format(string, sizeof string, "flood by seat changing");

        case 51: format(string, sizeof string, "DoS");

        case 52: format(string, sizeof string, "NOPs");

        default: format(string, sizeof string, "Unknown");
    }

    return string;
}

forward OnCheatDetected(playerid, const ip_address[], type, code);
public OnCheatDetected(playerid, const ip_address[], type, code)
{
	/*if(type) BlockIpAddress(ip_address, 0);
	else
	{
		switch(code)
		{
			case 5, 6, 11, 14, 22, 32: return 1;
			case 40: SendClientMessage(playerid, -1, MAX_CONNECTS_MSG);
			case 41: SendClientMessage(playerid, -1, UNKNOWN_CLIENT_MSG);
			default:
			{
				new strtmp[sizeof KICK_MSG];
				format(strtmp, sizeof strtmp, KICK_MSG, code);
				SendClientMessage(playerid, -1, strtmp);
			}
		}
		//AntiCheatKickWithDesync(playerid, code);
	}*/
    if(!IsAdmin(playerid, 1))
        StaffMsg(0xFF0000FF, "- AC: {FFFFFF}Igrac {FF0000}%s (%i){FFFFFF} je detektovan za moguci {FF0000}%s{FFFFFF} !!!", ime_rp[playerid], playerid, GetCheatName(code));
	
    if(code == 31)
    {
        StaffMsg(0xFF0000FF, "- AC: {FFFFFF}Igrac {FF0000}%s (%i){FFFFFF} je izbacen sa servera zbog {FF0000}%s{FFFFFF}.", ime_rp[playerid], playerid, GetCheatName(code));
        ErrorMsg(playerid, "Izbaceni ste sa servera (mogucnost \"%s\")!", GetCheatName(code));
        Kick_Timer(playerid);
    }

    return 1;
}

forward imovina_vrsta(id_vrste);
public imovina_vrsta(id_vrste)
{
    switch (id_vrste)
	{
		case kuca, stan, firma, hotel, garaza, vikendica:
			return IMOVINA_NEKRETNINA;
			
		case automobil, motor, bicikl, brod, helikopter:
			return IMOVINA_VOZILO;
			
		default:
			return IMOVINA_NEPOZNATO;
	}
    return IMOVINA_NEPOZNATO;
}


// U slucaju izmene, promeniti i u ACP-u (web)
stock GetNextLevelExp(level)
{
    if (level <= 4)
    {
        return (level*2 + 2);
    }
    else if (level >= 5 && level <= 13)
    {
        return (level*3 + 3);
    }
    else
    {
        return (level*4 + 4);
    }
}

stock Debug(const prefix[], const string[]) 
{
    new str[64];
	format(str, sizeof str, "[%s] %s", prefix, string);
	Log_Write(LOG_DEBUG2, str);

	return 1;
}

forward verify_transfer(playerid);
public verify_transfer(playerid)
{
	if (DebugFunctions())
    {
        LogFunctionExec("verify_transfer");
    }

	// Playerid = ID igraca koji NUDI transfer
	if (!IsPlayerConnected(transfer_id[playerid])) return 0; // Transfer nije validan
	if (transfer_od[transfer_id[playerid]] != playerid) return 0; // Transfer nije validan
	if (transfer_iznos[playerid] < 1 || transfer_iznos[playerid] > 10000000) return 0; // Transfer nije validan
	if (transfer_iznos[playerid] != transfer_iznos[transfer_id[playerid]]) return 0; // Transfer nije validan

	return 1; // Sve OK, transfer validan
}

forward proveri_oruzje(playerid, targetid);
public proveri_oruzje(playerid, targetid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("proveri_oruzje");
    }


    if (!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 1;
	new weaponid;
	new ammo;
	new output[21];
	output = "Nema";
	GetPlayerWeaponData(targetid, 1, weaponid, ammo);
	format(string_128, sizeof string_128, "%s(%d) |", output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 2, weaponid, ammo);
	if (weaponid == 22) output = "Pistol";
	if (weaponid == 23) output = "SilencedPistol";
	if (weaponid == 24) output = "DesertEagle";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 3, weaponid, ammo);
	if (weaponid == 25) output = "Shotgun";
	if (weaponid == 26) output = "SawnOffShotgun";
	if (weaponid == 27) output = "CombatShotgun";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 4, weaponid, ammo);
	if (weaponid == 28) output = "MicroUzi";
	if (weaponid == 29) output = "MP5";
	if (weaponid == 32) output = "Tec9";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 5, weaponid, ammo);
	if (weaponid == 30) output = "AK47";
	if (weaponid == 31) output = "M4";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 6, weaponid, ammo);
	if (weaponid == 33) output = "Rifle";
	if (weaponid == 34) output = "Sniper";
	format(string_128, sizeof string_128, "%s %s(%d)", string_128, output, ammo);
	SendClientMessage(playerid, BELA, string_128);

	output = "Nema";
	GetPlayerWeaponData(targetid, 7, weaponid, ammo);
	if (weaponid == 35) output = "RPG";
	if (weaponid == 36) output = "MissileLauncher";
	if (weaponid == 37) output = "FlameThrower";
	if (weaponid == 38) output = "Minigun";
	format(string_128, sizeof string_128, "%s(%d) |", output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 8, weaponid, ammo);
	if (weaponid == 16) output = "Grenade";
	if (weaponid == 17) output = "Tear Gas";
	if (weaponid == 18) output = "Molotov Cocktail";
	if (weaponid == 39) output = "Satchel Charge";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 9, weaponid, ammo);
	if (weaponid == 41) output = "Spraycan";
	if (weaponid == 42) output = "FireExtinguisher";
	if (weaponid == 43) output = "Camera";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 10, weaponid, ammo);
	if (weaponid == 10) output = "Purple Dildo";
	if (weaponid == 11) output = "Small White Vibrator";
	if (weaponid == 12) output = "Large White Vibrator";
	if (weaponid == 13) output = "Silver Vibrator";
	if (weaponid == 14) output = "Flowers";
	if (weaponid == 15) output = "Cane";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 11, weaponid, ammo);
	if (weaponid == 44) output = "NV Goggles";
	if (weaponid == 45) output = "Thermal Goggles";
	if (weaponid == 46) output = "Parachute";
	format(string_128, sizeof string_128, "%s %s(%d) |", string_128, output, ammo);

	output = "Nema";
	GetPlayerWeaponData(targetid, 12, weaponid, ammo);
	if (weaponid == 40) output = "Detonator";
	format(string_128, sizeof string_128, "%s %s(%d)", string_128, output, ammo);
	SendClientMessage(playerid, BELA, string_128);
	return 1;
}

forward respawnaj_vozilo(playerid);
public respawnaj_vozilo(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("respawnaj_vozilo");
    }


	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    {
		new x = 0, vehid = GetPlayerVehicleID(playerid);
		foreach(new i : Player) 
        {
		    if (GetPlayerVehicleID(i) == vehid && i != playerid) x++;
		}
		if (x == 0) SetVehicleToRespawn(vehid);
	}
	return 1;
}

forward isteraj(playerid);
public isteraj(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("isteraj");
    }


	if (!IsPlayerConnected(playerid)) return 1;
	GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 5.0);
	return 1;
}

forward GetPlayerIDFromName(const ime[MAX_PLAYER_NAME]);
public GetPlayerIDFromName(const ime[MAX_PLAYER_NAME]) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("GetPlayerIDFromName");
    }


	foreach(new i : Player)
	{
		if (strcmp(ime_obicno[i], ime) == 0)
		{
			return i;
		}
	}
	return INVALID_PLAYER_ID;
}

forward TeleportPlayer(playerid, Float:x, Float:y, Float:z);
public TeleportPlayer(playerid, Float:x, Float:y, Float:z) 
{
	
    if (DebugFunctions())
    {
        LogFunctionExec("TeleportPlayer");
    }


	if (!IsPlayerConnected(playerid)) return 1;
	if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    {
		km_pos[playerid][POS_X] = x, km_pos[playerid][POS_Y] = y, km_pos[playerid][POS_Z] = z;
		// uzima se pozicija u km_pos kako se pri portu na velike udaljenosti ne bi povecavala kilometraza

		SetVehicleCompensatedPos(GetPlayerVehicleID(playerid), x, y, z); // Vozac je, teleportuj mu i vozilo
	}
	// else SetPlayerCompensatedPos(playerid, x, y, z); // Nije u vozilu ili nije vozac, teleportuj samo njega
    else
    {
        SetPlayerCompensatedPos(playerid, x, y, z);
    }
	return 1;
}

forward RangeMsg(playerid, tekst[], boja, Float:udaljenost);
public RangeMsg(playerid, tekst[], boja, Float:udaljenost) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("range_poruka");
    }

	
	new
		ent = GetPlayerInterior(playerid),
		vw = GetPlayerVirtualWorld(playerid)
	;

	/*
		Range poruka se salje svim igracima koji se nalaze blizu odredjenog igraca od koga poruka potice
		Ti igraci moraju biti u istom enterijeru, istom virtual world-u, ne smeju biti u procesu registracije, i moraju biti prijavljeni/ulogovani
	*/

    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
 	foreach(new i : Player)
	{
	    if (IsPlayerInRangeOfPoint(i, udaljenost, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]) && GetPlayerInterior(i) == ent && GetPlayerVirtualWorld(i) == vw && !IsPlayerRegistering(i) && IsPlayerLoggedIn(i)) 
        {
			
			SendClientMessage(i, boja, tekst);
		}
	}
	return 1;
}

// Credits: Daniel_Cortez
forward ClearChatForPlayer(playerid);
public ClearChatForPlayer(playerid) 
{
    for(new i = 0; i < 50; i++)
        SendClientMessage(playerid, 0, "");
    /*static const str[] = "";
    new i = 100;
    
    #if __Pawn < 0x030A
        { if(0 == i) SendClientMessage(playerid, 0, str); }
    #endif
    
    #emit    push.c        str
    #emit    push.c        0xFFFFFFFF
    #emit    push.c        8

    do{
        #emit    sysreq.c    SendClientMessage
    }while(--i);

    #emit    stack        12*/
	return 1;
}

forward PlayerMoneyAdd(playerid, iznos);
public PlayerMoneyAdd(playerid, iznos)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PlayerMoneyAdd");
    }


	if (!IsPlayerConnected(playerid)) return 1;
	if (iznos < 0 || iznos > 20000000) 
    {
		SendClientMessage(playerid, TAMNOCRVENA2, GRESKA_NEPOZNATO);
		
		// Slanje upozorenja adminima
		AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[%d]: Dodavanje negativnog/previse velikog iznosa (%s)", ime_rp[playerid], playerid, formatMoneyString(iznos));
		
		// Upisivanje u log
		format(string_128, sizeof string_128, "NOVAC | %s | Dodavanje negativnog/previse velikog iznosa | $%d", ime_obicno[playerid], iznos);
		Log_Write(LOG_OVERWATCH, string_128);
		
	}
	if (PI[playerid][p_novac] < 0) 
    {
	    SendClientMessage(playerid, SVETLOCRVENA, "* Imate negativnu sumu novca.");
	    SendClientMessage(playerid, ZUTA, "* Savetujemo Vam da ovo prijavite na forum kako bi Vas problem bio resen.");

		// Upisivanje u log
		format(string_128, sizeof string_128, "NOVAC | %s | Negativan iznos (dodavanje) | $%d", ime_obicno[playerid], PI[playerid][p_novac]);
		Log_Write(LOG_OVERWATCH, string_128);
	}
	
	PI[playerid][p_novac] += iznos;
	GivePlayerMoney(playerid, iznos);
	
    new str[11];
    format(str, sizeof str, "+%d", iznos);
    ptdNovac_SetColor_Green(playerid);
	ptdNovac_SetString(playerid, str);
	ptdNovac_Show(playerid);
	
	KillTimer(tajmer:NovacTD[playerid]);
	tajmer:NovacTD[playerid] = SetTimerEx("sakrij_NovacTD", 5*1000, false, "d", playerid);
	
	novac_izmenjen[playerid] ++;
	if (novac_izmenjen[playerid] >= MAX_NOVAC_IZMENA) 
    {
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit);
	
		novac_izmenjen[playerid] = 0;
	}
	
	return 1;
}

forward PlayerMoneySub(playerid, iznos);
public PlayerMoneySub(playerid, iznos)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PlayerMoneySub");
    }

	if (!IsPlayerConnected(playerid)) return 1;
	if (iznos < 0 || iznos > 99999999) 
    {
		SendClientMessage(playerid, TAMNOCRVENA2, GRESKA_NEPOZNATO);

		// Slanje upozorenja adminima
		AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[%d]: Spreceno oduzimanje negativnog/previse velikog iznosa (%s)", ime_rp[playerid], playerid, formatMoneyString(iznos));

		// Upisivanje u log
		format(string_128, sizeof string_128, "NOVAC | %s | Oduzimanje negativnog/previse velikog iznosa | $%d", ime_obicno[playerid], iznos);
		Log_Write(LOG_OVERWATCH, string_128);

	}
	if (PI[playerid][p_novac] < 0) 
    {
	    SendClientMessage(playerid, SVETLOCRVENA, "* Imate negativnu sumu novca.");
	    SendClientMessage(playerid, ZUTA, "* Savetujemo Vam da ovo prijavite na forum kako bi Vas problem bio resen.");

		// Upisivanje u log
		format(string_128, sizeof string_128, "NOVAC | %s | Negativan iznos (oduzimanje) | $%d", ime_obicno[playerid], PI[playerid][p_novac]);
		Log_Write(LOG_OVERWATCH, string_128);

	    //return 1;
	}
	
	PI[playerid][p_novac] -= iznos;
	GivePlayerMoney(playerid, -iznos);
	
	new str[11];
    format(str, sizeof str, "-%d", iznos);
    ptdNovac_SetColor_Red(playerid);
    ptdNovac_SetString(playerid, str);
	ptdNovac_Show(playerid);
	
	KillTimer(tajmer:NovacTD[playerid]);
	tajmer:NovacTD[playerid] = SetTimerEx("sakrij_NovacTD", 5*1000, false, "d", playerid);
	
	novac_izmenjen[playerid] ++;
	if (novac_izmenjen[playerid] >= MAX_NOVAC_IZMENA) 
    {
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit);
	
		novac_izmenjen[playerid] = 0;
	}
	
	return 1;
}

forward PlayerMoneySet(playerid, iznos);
public PlayerMoneySet(playerid, iznos)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PlayerMoneySet");
    }

	if (!IsPlayerConnected(playerid) || IsAdmin(playerid, 1)) return 1;
	if (iznos < 0 || iznos > 99999999)
	{
		SendClientMessage(playerid, TAMNOCRVENA2, GRESKA_NEPOZNATO);

		// Slanje upozorenja adminima
		AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[%d]: Spreceno postavljanje negativnog/previse velikog iznosa ($%d)", ime_rp[playerid], playerid, iznos);

		// Upisivanje u log
		format(string_128, sizeof string_128, "NOVAC | %s | Postavljanje negativnog/previse velikog iznosa | $%d", ime_obicno[playerid], iznos);
		Log_Write(LOG_OVERWATCH, string_128);

		return 1;
	}
	
	PI[playerid][p_novac] = iznos;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, iznos);

    new str[11];
	format(str, sizeof str, "%d", iznos);
    ptdNovac_SetColor_Yellow(playerid);
	ptdNovac_SetString(playerid, str);
	ptdNovac_Show(playerid);
	
	KillTimer(tajmer:NovacTD[playerid]);
	tajmer:NovacTD[playerid] = SetTimerEx("sakrij_NovacTD", 5*1000, false, "d", playerid);
	return 1;
}

forward PlayerMoneySub_ex(playerid, iznos, bool:force);
public PlayerMoneySub_ex(playerid, iznos, bool:force) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("PlayerMoneySub_ex");
    }

	/*
	  Force: Ako je "true", onda ce oduzeti novac cak i ako igrac nema dovoljno, i ostaviti ga u minusu (oduzece sve iz banke, i ostatak iz dzepa, koliko je potrebno)
	*/

	if (PI[playerid][p_novac] >= iznos) // Ako ima dovoljno novca u dzepu, oduzima iz dzepa
    {
		PlayerMoneySub(playerid, iznos);
        return 1;
    }
		
	else if (PI[playerid][p_banka] >= iznos) // Ako nema dovoljno u dzepu, ali ima u banci, oduzima iz banke
    {
		BankMoneySub(playerid, iznos);
        return 1;
    }
		
	else if ((PI[playerid][p_novac] < iznos && PI[playerid][p_banka] < iznos && (PI[playerid][p_novac] + PI[playerid][p_banka]) >= iznos) 
		|| (PI[playerid][p_novac] + PI[playerid][p_banka]) < iznos && force == true) // Ako nema dovoljno ni u dzepu, ni u banci, ali je ukupan iznos u dzepu i 
		// banci dovoljan -ILI- jednostavno nema dovoljno novca, a pritom je (force == true) - oduzima sve iz banke, a ostatak iz dzepa 
		// (moze da stavi igraca u minus, ako je u pitanju 2. slucaj)
	{
		new banka_iznos = PI[playerid][p_banka];
		BankMoneySub(playerid, banka_iznos);
		iznos -= banka_iznos;
		
		PlayerMoneySub(playerid, iznos);
        return 1;
	}
	else
    {
        return 0;
    }
}

forward BankMoneyAdd(playerid, amount);
public BankMoneyAdd(playerid, amount)
{
    PI[playerid][p_banka] += amount;
//    ShowInfoBoxMainGui(playerid, true, true);
}

forward BankMoneySub(playerid, amount);
public BankMoneySub(playerid, amount)
{
    PI[playerid][p_banka] -= amount;
  //  ShowInfoBoxMainGui(playerid, true, true);
}

forward BankMoneySet(playerid, amount);
public BankMoneySet(playerid, amount)
{
    PI[playerid][p_banka] = amount;
  //  ShowInfoBoxMainGui(playerid, true, true);
}

forward resetuj_promenljive(playerid);
public resetuj_promenljive(playerid) 
{
	// Postavljanje varijabli na default vrednosti
	cur_wep[playerid] = 0,
	gHospitalBill[playerid] = 0, gLoginTimestampLimit[playerid] = gettime() + 120, gRegTimestampLimit[playerid] = gettime() + 400, 
	gJoinTimestamp[playerid] = gettime(),
	transfer_id[playerid] = -1, transfer_od[playerid] = -1, transfer_iznos[playerid] = 0, 
	antispam[playerid] = 0, antispam_vreme[playerid] = 0, firma_kupuje[playerid] = -1,
	f_pozvan[playerid] = -1, ft_edit[playerid] = -1,
	f_pozvan_ime[playerid][0] = EOS, novac_izmenjen[playerid] = 0, ft_category[playerid] = -1,
	ft_item[playerid] = -1;

    

	gPlayerSpawned			{playerid} = 					
	gPlayerReversing		{playerid} =  					 
	IgracevCPPrikazan		{playerid} = 
	IgracevRCPPrikazan		{playerid} = 
	kicked					{playerid} =  					
    zamrznut				{playerid} =  
	transfer_ponudjen		{playerid} =  
    driveby					{playerid} = 
	gCrashSpawn				{playerid} = 
    gAnimationsPreloaded    {playerid} =
    pRestoreData            {playerid} = false;
	
	picked_pickup[playerid] = -1;
	
	hPM{playerid} = true;
    pAdminMusic{playerid} = true;

	// Tajmeri					
    tajmer:kick				[playerid] = 
	tajmer:NovacTD			[playerid] = 0;					

	// PVar-ovi
	SetPVarInt(playerid, "zamrznut", 0);
	
	// Ostalo
	resetuj_prodaju(playerid);
	
	// Postavljanje praznih slotova za vozila
	for__loop (new i = 0; i < sizeof(pVehicles[]); i++) 
    {
		pVehicles[playerid][i] = 0;
	}

    if (IsValidDynamic3DTextLabel(pText3D[playerid]))
    {
        DestroyDynamic3DTextLabel(pText3D[playerid]), pText3D[playerid] = Text3D:INVALID_3DTEXT_ID;
    }


	// Postavljanje player (enum) varijabli na default vrednosti
    PI[playerid][p_id] = 
    PI[playerid][p_org_id] = 
    PI[playerid][p_org_rank] = 
    PI[playerid][p_hotel_soba] = -1;


    PI[playerid][p_admin] = 
    PI[playerid][p_helper] = 
    PI[playerid][p_promoter] = 
    PI[playerid][p_org_vreme] = 
    PI[playerid][p_novac] = 
    PI[playerid][p_banka] = 
	PI[playerid][p_token] = 
    PI[playerid][p_zlato] = 
    PI[playerid][p_iskustvo] = 
    PI[playerid][p_kartica_pin] = 
    PI[playerid][p_kredit_iznos] = 
    PI[playerid][p_kredit_otplata] = 
	PI[playerid][p_kredit_rata] = 
    PI[playerid][p_spawn_ent] = 
    PI[playerid][p_spawn_vw] = 
    PI[playerid][p_stil_hodanja] = 
    PI[playerid][p_provedeno_vreme] = 
    PI[playerid][p_glad] = 
    PI[playerid][p_offpm_vreme] = 
    PI[playerid][p_offpm_ugasen] = 
    PI[playerid][p_torba] = 
    PI[playerid][p_zavezan] =
    PI[playerid][p_area] =  
    PI[playerid][p_zatvoren] = 
    PI[playerid][p_utisan] = 
    PI[playerid][p_kaznjen_puta] = 
    PI[playerid][p_opomene] = 
	PI[playerid][p_dozvola_letenje] = 
    PI[playerid][p_dozvola_oruzje] = 
    PI[playerid][p_dozvola_plovidba] = 
    PI[playerid][p_dozvola_voznja] = 
	PI[playerid][p_reload_mehanicar] = 
    PI[playerid][p_reload_vehicle_theft] = 
    PI[playerid][p_reload_market] = 
    PI[playerid][p_reload_bribe] = 
    PI[playerid][p_reload_fv] = 
    PI[playerid][p_reload_namechange] = 
    PI[playerid][p_provedeno_vreme] = 
    PI[playerid][p_uhapsen_puta] =
    PI[playerid][p_payday] = 
	PI[playerid][p_sim_broj] = 
    PI[playerid][p_sim_kredit] =
	PI[playerid][p_posao_zarada] = 
    PI[playerid][p_posao_payday] = 
    PI[playerid][p_dj] = 
    PI[playerid][p_promo_hashtag] = 
    PI[playerid][p_cheater] = 
    PI[playerid][p_wanted_level] = 
    PI[playerid][p_donacije] = 
    PI[playerid][p_vip_level] = 
    PI[playerid][p_vip_istice] = 
    PI[playerid][p_vip_refill] = 
    PI[playerid][p_vip_replenish] = 
    PI[playerid][p_division_points] = 
    PI[playerid][p_division_expiry] = 
    PI[playerid][p_division_treshold_up] = 
    PI[playerid][p_division_treshold_dn] = 
    PI[playerid][p_division_reload_up] = 
    PI[playerid][p_division_reload_dn] = 
    PI[playerid][p_skill_cop] = 
    PI[playerid][p_skill_criminal] = 
    PI[playerid][p_robbed_atms] = 
    PI[playerid][p_robbed_stores] = 
    PI[playerid][p_stolen_cars] = 
    PI[playerid][p_arrested_criminals] = 
    PI[playerid][p_atm_stolen_cash] = 
    PI[playerid][p_stores_stolen_cash] = 
    PI[playerid][p_treasure_hunt] = 
    PI[playerid][p_zabrana_oruzje] = 
    PI[playerid][p_zabrana_lider] = 
    PI[playerid][p_rudnik_zlato] =
    PI[playerid][p_odradio_posao] =
    PI[playerid][p_zabrana_staff] = 0;


    PI[playerid][p_nivo] = 1;
    PI[playerid][p_spawn_x] = SPAWN_X;
    PI[playerid][p_spawn_y] = SPAWN_Y;
    PI[playerid][p_spawn_z] = SPAWN_Z;
    PI[playerid][p_spawn_a] = SPAWN_A; 
    PI[playerid][p_spawn_health] = 50.0;
    PI[playerid][p_spawn_armour] = 0.0;
    PI[playerid][p_pol] = POL_MUSKO;
    PI[playerid][p_starost] = 21;
    PI[playerid][p_skin] = gMaleSkins[0];
    PI[playerid][p_stil_borbe] = 4;
    PI[playerid][p_hotel_cena] = 0;
    PI[playerid][p_vozila_slotovi] = 3;
    PI[playerid][p_imanja_slotovi] = 1;
    PI[playerid][p_boja_imena] = 0xFFFFFF00;
	
	// Postavljanje imovine na default vrednosti
    for__loop (new i = 0; i < sizeof pRealEstate[]; i++)
    {
            pRealEstate[playerid][i] = -1;
    }	

	// Resetovanje stringova
	AutoPMTekst[playerid][0] = EOS;
	strmid(PI[playerid][p_mobilni], "", 0, 0, 13);
	strmid(PI[playerid][p_sim], "N/A", 0, strlen("N/A"), 11);
    strmid(PI[playerid][p_kartica], "N/A", 0, strlen("N/A"), 11);
    format(PI[playerid][p_email], MAX_EMAIL_LEN, "N/A");
    format(PI[playerid][p_referral], MAX_PLAYER_NAME, "N/A");
	return 1;
}

forward Koristite(playerid, const tekst[]);
public Koristite(playerid, const tekst[])
{
	#if defined DEBUG_CHAT
	    Debug("chat", "Koristite");
	#endif

	SendClientMessageF(playerid, GRAD2, "Koristite: {E8E8E8}/%s", tekst);
	return 1;
}




// ========================================================================== //
//                          	     Tajmeri                                  //
// ========================================================================== //
forward sakrij_NovacTD(playerid);
public sakrij_NovacTD(playerid)
{
	if (tajmer:NovacTD[playerid] == 0) return 1;
	
	KillTimer(tajmer:NovacTD[playerid]), tajmer:NovacTD[playerid] = 0;
	
	ptdNovac_Hide(playerid);
	return 1;
}

forward respawn(Float:x, Float:y, Float:z, Float:radius);
public respawn(Float:x, Float:y, Float:z, Float:radius)
{
    if (DebugFunctions())
    {
        LogFunctionExec("respawn");
    }


    new bool:unwanted[MAX_VEHICLES char] = {false, false, ...};
	if (x == 0 && y == 0 && z == 0 && radius == 0) // Sva vozila
	{
	    foreach(new i : Player) 
        {
			SendClientMessage(i, ZUTA, "* Sva vozila su respawnovana.");
			if (IsPlayerInAnyVehicle(i)) unwanted{GetPlayerVehicleID(i)} = true;
		}
		foreach (new i : iVehicles) 
        {
			if (!unwanted{i} && GetVehicleModel(i) != 584) SetVehicleToRespawn(i);
		}
	}
	else // U radiusu
	{
	    foreach(new i : Player) 
        {
			if (IsPlayerInAnyVehicle(i)) unwanted{GetPlayerVehicleID(i)} = true;
			if (IsPlayerInRangeOfPoint(i, floatadd(radius, 20.0), x, y, z)) SendClientMessage(i, ZUTA, "* Vozila u okolini su respawnovana.");
		}
		foreach(new i : iVehicles) 
        {
			if (IsVehicleInRangeOfPoint(i, radius, x, y, z) && !unwanted{i} && GetVehicleModel(i) != 584) SetVehicleToRespawn(i);
        }
	}
	respawn_pokrenut = false;
	return 1;
}

forward odbrojavanja();
public odbrojavanja()
{
	foreach(new i : Player)
	{
	    if (IsPlayerLoggedIn(i))
	    {
	        if (antispam[i] > 0) antispam[i]--;

            if (IsOnDuty(i))
            {
                SetPlayerArmour(i, 255.0);
                SetPlayerHealth(i, 255.0);
                if (IsPlayerInAnyVehicle(i)) {
                    RepairVehicle(GetPlayerVehicleID(i));
                    SetVehicleHealth(GetPlayerVehicleID(i), 999.0);
                }
            }
            if (PI[i][p_wanted_level] > 0)
            {
                GameTextForPlayer(i, "~n~~n~~n~~n~~r~Trazeni ste juri vas~n~~b~policija~n~", 5000, 5);
            }

	        if (PI[i][p_utisan] > 0)
	        {
    		    PI[i][p_utisan]--;
    		    if (PI[i][p_utisan] == 0)
    		    {
                    format(PI[i][p_utisan_razlog], 32, "N/A");
                    SetPlayerChatBubble(i, "", BELA, 1.0, 100);
    		        overwatch_poruka(i, "Niste vise utisani, ponovo mozete koristiti chat.");
    	         	
                    new sQuery[70];
                    format(sQuery, sizeof sQuery, "UPDATE igraci SET utisan = 0, utisan_razlog = 'N/A' WHERE id = %d", PI[i][p_id]);
                    mysql_tquery(SQL, sQuery);
    		    }
			}
			if (PI[i][p_zatvoren] > 0)
			{
    			PI[i][p_zatvoren]--;
    			if (PI[i][p_zatvoren] == 0)
    			{
                    PI[i][p_zatvoren] = 0;
                    format(PI[i][p_area_razlog], 32, "N/A");  			    
    				SetPlayerWorldBounds(i, 6000, -6000, 6000, -6000);
    			    SetPlayerCompensatedPosEx(i, 1802.7881, -1577.6869, 13.4119, 280.0);
                    SetPlayerSkin(i, PI[i][p_skin]);
    			 	overwatch_poruka(i, "Vasa zatvorska kazna je istekla.");

    			    new sQuery[256];
                    format(sQuery, sizeof sQuery, "UPDATE igraci SET zatvoren = 0, area = 0, area_razlog = 'N/A' WHERE id = %d", PI[i][p_id]);
                    mysql_tquery(SQL, sQuery);
    			}
			}
            if (PI[i][p_area] > 0)
            {
                PI[i][p_area]--;
                if (PI[i][p_area] <= 0)
                {
                    PI[i][p_area] = 0;
                    format(PI[i][p_area_razlog], 32, "N/A");
                    SetPlayerWorldBounds(i, 20000, -20000, 20000, -20000);
                    SetPlayerCompensatedPosEx(i, 1802.7881, -1577.6869, 13.4119, 280.0);
                    SetPlayerSkin(i, PI[i][p_skin]);
                    overwatch_poruka(i, "Vasa zatvorska kazna je istekla.");

                    new sQuery[256];
                    format(sQuery, sizeof sQuery, "UPDATE igraci SET area = 0, area_razlog = 'N/A' WHERE id = %d", PI[i][p_id]);
                    mysql_tquery(SQL, sQuery);
                }
            }


            // Blokiranje oruzja
            if (GetPlayerWeapon(i) > 0 && !IsPlayerInDMArena(i) && !IsPlayerInHorrorEvent(i))
            {
                if (IsNewPlayer(i) && GetPlayerFactionID(i) == -1 && !IsPlayerInDMArena(i))
                {
                    overwatch_poruka(i, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
                    ResetPlayerWeapons(i);
                }

                else if (PI[i][p_zabrana_oruzje] > gettime() && GetPlayerWeapon(i) != WEAPON_SHOTGUN)
                {
                    new sTime[20];
                    GetRemainingTime(PI[i][p_zabrana_oruzje], sTime);
                    SendClientMessageF(i, CRVENA, "OVERWATCH | {FFFFFF}Zabranjeno Vam je nosenje oruzja jos: %s.", sTime);
                    ResetPlayerWeapons(i);
                }
            }


            // Anti weapon hack
            new weaponid, ammo, cheat = 0;
            
            GetPlayerWeaponData(i, 3, weaponid, ammo);
            if (weaponid == 26) cheat = weaponid;
            if (weaponid == 27) cheat = weaponid;

            GetPlayerWeaponData(i, 4, weaponid, ammo);
            if (weaponid == 28) cheat = weaponid;
            if (weaponid == 32) cheat = weaponid;

            GetPlayerWeaponData(i, 7, weaponid, ammo);
            if (weaponid == 35) cheat = weaponid;
            if (weaponid == 36) cheat = weaponid;
            if (weaponid == 37) cheat = weaponid;
            if (weaponid == 38) cheat = weaponid;

            GetPlayerWeaponData(i, 9, weaponid, ammo);
            if (weaponid == 43 && !IsACop(i)) cheat = weaponid;

            GetPlayerWeaponData(i, 11, weaponid, ammo);
            if (weaponid == 44 && !IsPlayerInHorrorEvent(i)) cheat = weaponid;
            if (weaponid == 45) cheat = weaponid;

            if (cheat != 0 && !IsPlayerJailed(i)) // Spawnao je neko zabranjeno oruzje
            {
                ResetPlayerWeapons(i);
                PunishPlayer(i, INVALID_PLAYER_ID, 180, 0, 0, false, "Weapon Hack");
            }
	    }


		if (!IsPlayerLoggedIn(i))
		{
			if (!IsPlayerRegistering(i) && gettime() > gLoginTimestampLimit[i])
			{
				SendClientMessage(i, TAMNOCRVENA2, GRESKA_KICK);
				Kick_Timer(i);
				
				continue;
			}
			if (IsPlayerRegistering(i) && gettime() > gRegTimestampLimit[i])
			{
				SendClientMessage(i, TAMNOCRVENA2, GRESKA_KICK);
				Kick_Timer(i);
				
				continue;
			}
		}
	}
	return 1;
}

forward IntroCameraRotation();
public IntroCameraRotation() 
{
    if (Iter_Count(iPlayersConnecting) == 0)
    {
        KillTimer(tmrIntroCam);
    }
    else
    {
        #define INTRO_CAM_SPEED  0.18
        #define INTRO_CAM_RADIUS 380.0


        if(gIntroCamAngle >= 360) gIntroCamAngle = 0;
        gIntroCamAngle += INTRO_CAM_SPEED;

        new
            Float:nX = 1535.2549 + INTRO_CAM_RADIUS * floatcos(gIntroCamAngle, degrees),
            Float:nY = -1351.2888 + INTRO_CAM_RADIUS * floatsin(gIntroCamAngle, degrees)
        ;

        //InterpolateCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z], toPos[POS_X], toPos[POS_Y], toPos[POS_Z], 1000, CAMERA_MOVE);
        //InterpolateCameraLookAt(playerid, 2521.7664, -1525.6021, 25.1485, 2521.7664, -1525.6021, 25.1485, 1000, CAMERA_MOVE);

        foreach (new playerid : iPlayersConnecting) 
        {
            SetPlayerCameraPos(playerid, nX, nY, 140.6617+80.0);
            SetPlayerCameraLookAt(playerid, 1535.2549, -1351.2888, 140.6617);
        }
    }
    return 1;
}

forward RestoreVehicleNitro(vehicleid);
public RestoreVehicleNitro(vehicleid)
{
    return AddVehicleComponent(vehicleid, 1010);
}


// ========================================================================== //
//                              Overwatch funkcije                              //
// ========================================================================== //
stock overwatch_poruka(playerid, const tekst[128], izbaci = false) 
{
	#if defined DEBUG_CHAT
	    Debug("chat", "overwatch_poruka");
	#endif

    if (!IsPlayerConnected(playerid)) 
      return 1;

    SendClientMessageF(playerid, CRVENA, "- NL: {B4CDED}%s", tekst);

    if (izbaci)
    {
        Kick_Timer(playerid);
    }

	return 1;
}

forward banuj_igraca(playerid, const razlog[], trajanje, const admin[MAX_PLAYER_NAME], bool:banip);
public banuj_igraca(playerid, const razlog[], trajanje, const admin[MAX_PLAYER_NAME], bool:banip)
{
    if (DebugFunctions())
    {
        LogFunctionExec("banuj_igraca");
    }

	if (!IsPlayerConnected(playerid)) 
        return 1;

	format(mysql_upit, sizeof mysql_upit, "INSERT INTO banovi (pid, admin, razlog, istice) VALUES (%d, '%s', '%s', FROM_UNIXTIME(%d))", PI[playerid][p_id], admin, razlog, trajanje);
	//mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_BANPLAYER);
    mysql_tquery(SQL, mysql_upit);
	
    if (!banip) 
        Kick_Timer(playerid);
	else 
        Ban_H(playerid);

	return 1;
}

forward Kick_Timer(playerid);
public Kick_Timer(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Kick_Timer");
    }


	SetPVarInt(playerid, "kick", 1);
	tajmer:kick[playerid] = SetTimerEx("Kick_H", 1000, false, "ii", playerid, cinc[playerid]);
	return 1;
}


// ========================================================================== //
//                          	    Stockovi                                  //
// ========================================================================== //
forward UpdatePlayerBubble(playerid);
public UpdatePlayerBubble(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("UpdatePlayerBubble");
    }

    new string[30];
    string[0] = EOS;
    new nick[24];
    GetPlayerName(playerid, nick, 24);
    if (PI[playerid][p_promoter])
    {
        format(string, sizeof string, "{FCE6C4}[ PROMOTER ]");
    }
    else if (PlayerFlagGet(playerid, FLAG_MAPER))
    {
        format(string, sizeof string, "{FF6347}[ MAPER ]");
    }
    else if (strfind(nick, "ZERO") != -1)
    {
        format(string, sizeof string, "{FF6347}[ VLASNIK ]");
    }
    else if (strfind(nick, "Zile42O") != -1)
    {
        format(string, sizeof string, "{FF6347}[ SKRIPTER ]");
    }
    else if (strfind(nick, "Glisha") != -1)
    {
        format(string, sizeof string, "{FF6347}[ SUVLASNIK ]");
    }    
    else if (PlayerFlagGet(playerid, FLAG_YOUTUBER))
    {
        format(string, sizeof string, "{FF6347}[ YOUTUBER ]");
    }
    else if (IsVIP(playerid, 4))
    {
        format(string, sizeof string, "{AF28A4}[ VIP PLATINUM ]");
    }
    else if (IsVIP(playerid, 3))
    {
        format(string, sizeof string, "{AF28A4}[ VIP GOLD ]");
    }
    else if (IsVIP(playerid, 2))
    {
        format(string, sizeof string, "{AF28A4}[ VIP SILVER ]");
    }
    else if (IsVIP(playerid, 1))
    {
        format(string, sizeof string, "{AF28A4}[ VIP BRONZE ]");
    }
    else if (IsNewPlayer(playerid))
    {
        // Manje od 20h igre
        format(string, sizeof string, "{80FF80}[ NOVI IGRAC ]");
    }
    else if (PI[playerid][p_cheater] > gettime())
    {
        format(string, sizeof string, "{FF0000}[ CHEATER ]");
    }


    if (!isnull(string))
    {
        if (IsValidDynamic3DTextLabel(pText3D[playerid]))
        {
            UpdateDynamic3DTextLabelText(pText3D[playerid], 0xFFFFFFFF, string);
        }
        else
        {
            pText3D[playerid] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, 0.0, 0.0, -1000.0, 20.0, playerid, INVALID_VEHICLE_ID, 1);

            Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pText3D[playerid], E_STREAMER_ATTACH_OFFSET_Z, 0.8);
        }
    }
    else
    {
        if (IsValidDynamic3DTextLabel(pText3D[playerid]))
        {
            DestroyDynamic3DTextLabel(pText3D[playerid]), pText3D[playerid] = Text3D:INVALID_3DTEXT_ID;
        }
    }
}

stock IsPlayerJailed(playerid) 
{
    if (PI[playerid][p_zatvoren] != 0 || PI[playerid][p_area] != 0) return 1;
    return 0;
}

stock reket_ime(gid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("reket_ime");
    }

	new string[MAX_FNAME_LENGTH];
	new lid = re_localid(firma, gid);

    if (!(1 <= lid <= RE_GetMaxID_Business()) || BizInfo[lid][BIZ_REKET] <= 0)
    {
		format(string, sizeof string, "Nema");
    }
	else
    {
		format(string, sizeof string, "%s", FACTIONS[BizInfo[lid][BIZ_REKET]][f_naziv]);
    }
	
	return string;
}

stock propname(vrsta, oblik) 
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "propname");
	#endif

	new
		string[13];

	switch (vrsta) 
    {
	    case automobil: 
        {
	        switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "AUTOMOBIL";
	            case PROPNAME_LOWER:    string = "automobil";
	            case PROPNAME_CAPITAL:  string = "Automobil";
                case PROPNAME_AKUZATIV: string = "automobil";
                case PROPNAME_GENITIV:  string = "automobila";
	            case PROPNAME_TABLE:    string = "vozila";
	            default:                string = "[greska]";
	        }
	    }
	    case motor: 
        {
	        switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "MOTOR";
	            case PROPNAME_LOWER:    string = "motor";
	            case PROPNAME_CAPITAL:  string = "Motor";
                case PROPNAME_AKUZATIV: string = "motor";
                case PROPNAME_GENITIV:  string = "motora";
	            case PROPNAME_TABLE:    string = "vozila";
	            default:                string = "[greska]";
	        }
		}
		case bicikl: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "BICIKL";
	            case PROPNAME_LOWER:    string = "bicikl";
	            case PROPNAME_CAPITAL:  string = "Bicikl";
                case PROPNAME_AKUZATIV: string = "bicikl";
                case PROPNAME_GENITIV:  string = "bicikla";
	            case PROPNAME_TABLE:    string = "vozila";
	            default:                string = "[greska]";
	        }
		}
		case brod: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "BROD";
	            case PROPNAME_LOWER:    string = "brod";
	            case PROPNAME_CAPITAL:  string = "Brod";
                case PROPNAME_AKUZATIV: string = "brod";
                case PROPNAME_GENITIV:  string = "broda";
	            case PROPNAME_TABLE:    string = "vozila";
	            default:                string = "[greska]";
	        }
		}
		case helikopter: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "HELIKOPTER";
	            case PROPNAME_LOWER:    string = "helikopter";
	            case PROPNAME_CAPITAL:  string = "Helikopter";
                case PROPNAME_AKUZATIV: string = "helikopter";
                case PROPNAME_GENITIV:  string = "helikoptera";
	            case PROPNAME_TABLE:    string = "vozila";
	            default:                string = "[greska]";
	        }
		}
		case kuca: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "KUCA";
	            case PROPNAME_LOWER:    string = "kuca";
	            case PROPNAME_CAPITAL:  string = "Kuca";
	            case PROPNAME_AKUZATIV: string = "kucu";
                case PROPNAME_GENITIV:  string = "kuce";
	            case PROPNAME_TABLE:    string = "re_kuce";
	            default:                string = "[greska]";
	        }
		}
		case stan: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "STAN";
	            case PROPNAME_LOWER:    string = "stan";
	            case PROPNAME_CAPITAL:  string = "Stan";
	            case PROPNAME_AKUZATIV: string = "stan";
                case PROPNAME_GENITIV:  string = "stana";
	            case PROPNAME_TABLE:    string = "re_stanovi";
	            default:                string = "[greska]";
	        }
		}
		case firma: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "FIRMA";
	            case PROPNAME_LOWER:    string = "firma";
	            case PROPNAME_CAPITAL:  string = "Firma";
	            case PROPNAME_AKUZATIV: string = "firmu";
                case PROPNAME_GENITIV:  string = "firme";
	            case PROPNAME_TABLE:    string = "re_firme";
	            default:                string = "[greska]";
	        }
		}
		case hotel: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "HOTEL";
	            case PROPNAME_LOWER:    string = "hotel";
	            case PROPNAME_CAPITAL:  string = "Hotel";
	            case PROPNAME_AKUZATIV: string = "hotel";
                case PROPNAME_GENITIV:  string = "hotela";
	            case PROPNAME_TABLE:    string = "re_hoteli";
	            default:                string = "[greska]";
	        }
		}
		case garaza: 
        {
		    switch (oblik) 
            {
	            case PROPNAME_UPPER:    string = "GARAZA";
	            case PROPNAME_LOWER:    string = "garaza";
	            case PROPNAME_CAPITAL:  string = "Garaza";
	            case PROPNAME_AKUZATIV: string = "garazu";
                case PROPNAME_GENITIV:  string = "garaze";
	            case PROPNAME_TABLE:    string = "re_garaze";
	            default:                string = "[greska]";
	        }
		}
        case vikendica: 
        {
            switch (oblik) 
            {
                case PROPNAME_UPPER:    string = "VIKENDICA";
                case PROPNAME_LOWER:    string = "vikendica";
                case PROPNAME_CAPITAL:  string = "Vikendica";
                case PROPNAME_AKUZATIV: string = "vikendicu";
                case PROPNAME_GENITIV:  string = "vikendice";
                case PROPNAME_TABLE:    string = "re_vikendice";
                default:                string = "[greska]";
            }
        }
		default: string = "[greska]";
	}
	return string;
}

nl_public WasteDeAMXersTime() {
    new b;
    #emit load.pri b
    #emit stor.pri b
}



// ========================================================================== //
//                          	 MySQL funkcije                               //
// ========================================================================== //
forward MySQL_OnDJSelected(playerid, ccinc);
public MySQL_OnDJSelected(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (!rows)
        return InfoMsg(playerid, "Trenutno niko nema poziciju DJ-a.");

    SendClientMessage(playerid, NARANDZASTA,    "_______________ DJ-evi _______________");
    for__loop (new i = 0; i < rows; i++)
    {
        new ime[MAX_PLAYER_NAME];
        cache_get_value_index(i, 0, ime, sizeof ime);

        SendClientMessageF(playerid, BELA, "- %s", ime);
    }
    return 1;
}

forward mysql_crash(returnid, ccinc);
public mysql_crash(returnid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_crash");
    }

	if (!checkcinc(returnid, ccinc)) return 1;

	cache_get_row_count(rows);
	//if (!rows || rows > 1) return 1;
	
	if (rows > 0)
	{
        new sQuery[38];
		format(sQuery, sizeof sQuery, "DELETE FROM crash WHERE pid = %d", PI[returnid][p_id]);
		//mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_CRASHDELETE);
        mysql_tquery(SQL, sQuery);
    }
	
	if (rows == 1)
	{
        new sPosition[51], Float:fPos[4],
            interior,
            virtual
        ;
        cache_get_value_name(0, "pozicija", sPosition);
        sscanf(sPosition, "p<|>ffffii", fPos[0], fPos[1], fPos[2], fPos[3], interior, virtual);
        /*if (IsPointInAnyDynamicArea(fPos[0], fPos[1], fPos[2]))
        {
            for__loop (new i = 0; i < MAX_FACTIONS; i++)
            {
                if (TurfWars[i][TW_ACTIVE] && IsPointInDynamicArea(TurfWars[i][TW_AREAID], fPos[0], fPos[1], fPos[2]))
                {
                    // Zabranjujemo igracu da se spawna na aktivnoj teritoriji
                    gCrashSpawn{returnid} = false;
                    return 1;
                }
            }
        }*/

		
		new
			sWeapons[38],
			sAmmo[80],
            Float:health,
            Float:armour
		;
		
		
		cache_get_value_name(0, "oruzje",   	sWeapons);
		cache_get_value_name(0, "municija", 	sAmmo);
		cache_get_value_name_float(0, "health", health);
		cache_get_value_name_float(0, "armour", armour);
		
        SetPVarString(returnid, "pCrashWeapons", sWeapons);
        SetPVarString(returnid, "pCrashAmmo", sAmmo);

        
        SetPVarInt(returnid, "pCrashInterior", interior);
        SetPVarInt(returnid, "pCrashVirtual", virtual);
        SetPVarFloat(returnid, "pCrashHealth", health);
        SetPVarFloat(returnid, "pCrashArmour", armour);
        SetSpawnInfo(returnid, 0, GetPlayerCorrectSkin(returnid), fPos[0], fPos[1], fPos[2], fPos[3], 0, 0, 0, 0, 0, 0);
        gCrashSpawn{returnid} = true; // Koristi se kod OnPlayerSpawn() pri odredjivanju mesta spawna (normalno ili ga vraca na crash pos)
	}
	else // Ima vise od 1 rezultata ili ih uopste nema
	{
		gCrashSpawn{returnid} = false;
	}
	
    TogglePlayerSpectating_H(returnid, false); // Spawn igraca
	return 1;
}



// ========================================================================== //
//                          	    Dijalozi                                  //
// ========================================================================== //
Dialog:no_return(playerid, response, listitem, const inputtext[])  // Info window
    return 1;

Dialog:kick(playerid, response, listitem, const inputtext[])  // Lose ime
    return Kick(playerid);


Dialog:imovina(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
    
	switch (listitem)
	{
		case 0: 
        {
            new sDialog[512];
			format(sDialog, 30, "Slot\tVozilo\tModel\tTablice");
			
			new item = 0;
			for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
            {
				if (pVehicles[playerid][i] == 0) continue; // prazan slot
				
				new veh = pVehicles[playerid][i], color[7];
                if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
                else color = "FFFFFF";

				format(sDialog, sizeof sDialog, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", sDialog, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

                OwnedVehiclesDialog_AddItem(playerid, item++, i);
			}
			
			if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");
			
			SPD(playerid, "vozila", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}UPRAVLJANJE VOZILIMA", sDialog, "Odaberi", "Nazad");
		}
		
		case 1: SPD(playerid, "nekretnine", DIALOG_STYLE_LIST, "{0068B3}UPRAVLJANJE NEKRETNINAMA", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica", "Odaberi", "Nazad");
	}
	return 1;
}

Dialog:spawn(playerid, response, listitem, const inputtext[])
{
	//Default\nKuca\nStan\nFirma\nGaraza\nBaza
	if (!response) return 1;

	new
	    gid,
		spawnStr[18]
	;
	switch (listitem)
	{
	    case 0: // Default
	    {
            PI[playerid][p_spawn_x]      = SPAWN_X;
            PI[playerid][p_spawn_y]      = SPAWN_Y;
            PI[playerid][p_spawn_z]      = SPAWN_Z;
            PI[playerid][p_spawn_a]      = SPAWN_A;
            PI[playerid][p_spawn_vw]     = 0;
            PI[playerid][p_spawn_ent]    = 0;
            PI[playerid][p_spawn_health] = 50.0;
            PI[playerid][p_spawn_armour] = 0.0;

			spawnStr = "default";
	    }
	    case 1: // Kuca
		{
		    if (pRealEstate[playerid][kuca] == -1) return ErrorMsg(playerid, "Ne posedujete kucu.");

			gid = re_globalid(kuca, pRealEstate[playerid][kuca]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 100.0;
            PI[playerid][p_spawn_armour] = 0.0;

		    spawnStr = "kuca";
		}
		case 2: // Stan
		{
		    if (pRealEstate[playerid][stan] == -1) return ErrorMsg(playerid, "Ne posedujete stan.");

			gid = re_globalid(stan, pRealEstate[playerid][stan]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 80.0;
            PI[playerid][p_spawn_armour] = 0.0;

		    spawnStr = "stan";
		}
		case 3: // Firma
		{
		    if (pRealEstate[playerid][firma] == -1) return ErrorMsg(playerid, "Ne posedujete firmu.");

			gid = re_globalid(firma, pRealEstate[playerid][firma]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 70.0;
            PI[playerid][p_spawn_armour] = 0.0;

            if (IsBusinessWithInterior(gid))
            {
                PI[playerid][p_spawn_vw] = gid;
            }
            else
            {
                PI[playerid][p_spawn_vw] = 0;
            }

		    spawnStr = "firma";
		}
		case 4: // Hotel
		{
		    if (pRealEstate[playerid][hotel] == -1) return ErrorMsg(playerid, "Ne posedujete hotel.");

			gid = re_globalid(hotel, pRealEstate[playerid][hotel]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 70.0;
            PI[playerid][p_spawn_armour] = 0.0;

		    spawnStr = "hotel";
		}
		case 5: // Garaza
		{
		    if (pRealEstate[playerid][garaza] == -1) return ErrorMsg(playerid, "Ne posedujete garazu.");

			gid = re_globalid(garaza, pRealEstate[playerid][garaza]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 70.0;
            PI[playerid][p_spawn_armour] = 0.0;

		    spawnStr = "garaza";
		}
        case 6: // Vikendica
        {
            if (pRealEstate[playerid][vikendica] == -1) return ErrorMsg(playerid, "Ne posedujete vikendicu.");

            gid = re_globalid(vikendica, pRealEstate[playerid][vikendica]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 70.0;
            PI[playerid][p_spawn_armour] = 0.0;

            spawnStr = "vikendica";
        }
		case 7: // Baza
		{
		    new
				f_id
			;
			f_id = PI[playerid][p_org_id]; // Ne treba nikakva druga provera osim ovih, jer su druge provere izvedene pri ucitavanju podataka / prijavi igraca (mislim na array out of bounds)
			
			if (f_id == -1)
				return ErrorMsg(playerid, "Ova opcija Vam nije trenutno dostupna.");
				
			if ((F_RANKS[PI[playerid][p_org_id]][PI[playerid][p_org_rank]][fr_dozvole] & DOZVOLA_SPAWN) == 0)
				return ErrorMsg(playerid, "Nemate dozvolu da se spawnate u bazi.");

            // SKILL-RANK OGRANICENJE
            // if (PI[playerid][p_org_rank] == 1)
            //     return ErrorMsg(playerid, "Nemate dozvolu da se spawnate u bazi (rank 2+).");
			
            PI[playerid][p_spawn_x]      = FACTIONS[f_id][f_x_spawn];
            PI[playerid][p_spawn_y]      = FACTIONS[f_id][f_y_spawn];
            PI[playerid][p_spawn_z]      = FACTIONS[f_id][f_z_spawn];
            PI[playerid][p_spawn_a]      = FACTIONS[f_id][f_a_spawn];
            PI[playerid][p_spawn_ent]    = FACTIONS[f_id][f_ent_spawn];
            PI[playerid][p_spawn_vw]     = FACTIONS[f_id][f_vw_spawn];
            PI[playerid][p_spawn_health] = 80.0;
            PI[playerid][p_spawn_armour] = 0.0;

			spawnStr = "baza";
		}
		case 8: // Hotelska soba
		{
			if (PI[playerid][p_hotel_soba] == -1 || PI[playerid][p_hotel_cena] == 1000)
				return ErrorMsg(playerid, "Nemate iznajmljenu sobu ni u jednom hotelu.");
				
			gid = re_globalid(hotel, PI[playerid][p_hotel_soba]);
			new rand = random(sizeof gHotelRooms);
            PI[playerid][p_spawn_x]      = gHotelRooms[rand][0];
            PI[playerid][p_spawn_y]      = gHotelRooms[rand][1];
            PI[playerid][p_spawn_z]      = gHotelRooms[rand][2];
            PI[playerid][p_spawn_a]      = gHotelRooms[rand][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 80.0;
            PI[playerid][p_spawn_armour] = 0.0;
			
		    spawnStr = "hotelska soba";
		}
        case 9: // Iznajmljena soba u kuci
        {
            if (PI[playerid][p_rent_kuca] == 0 || PI[playerid][p_rent_cena] == 0)
                return ErrorMsg(playerid, "Nemate iznajmljenu sobu ni u jednoj kuci.");
                
            gid = re_globalid(kuca, PI[playerid][p_rent_kuca]);
            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_health] = 65.0;
            PI[playerid][p_spawn_armour] = 0.0;
            
            spawnStr = "iznajmljena soba";
        }
        case 10: // Trenutna pozicija
        {
            if (!IsAdmin(playerid, 6) && !IsVIP(playerid, 4))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

            new Float:pos[4];
            GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
            if(IsPointInAnyDynamicArea(pos[0], pos[1], pos[2]) >= 1)
                return ErrorMsg(playerid, "Ne mozete postaviti svoj spawn point u blizini zone!");
            GetPlayerFacingAngle(playerid, pos[3]);

            PI[playerid][p_spawn_x]      = pos[0];
            PI[playerid][p_spawn_y]      = pos[1];
            PI[playerid][p_spawn_z]      = pos[2];
            PI[playerid][p_spawn_a]      = pos[3];
            PI[playerid][p_spawn_vw]     = GetPlayerVirtualWorld(playerid);
            PI[playerid][p_spawn_ent]    = GetPlayerInterior(playerid);
            PI[playerid][p_spawn_health] = 100.0;
            PI[playerid][p_spawn_armour] = 0.0;

            spawnStr = "trenutna pozicija";
        }
	}

    ///////////////////////////////////////////////////////////
    // Sledeci kod se koristi u fajlu real_estate.pwn
    // u dialogu "estateList", takodje za promenu spawna
    ///////////////////////////////////////////////////////////

	// Promena spawna
	SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);

    // VIP se uvek spawna sa 100hp
    if (IsVIP(playerid, 1))
        PI[playerid][p_spawn_health] = 100.0;

    // Armour na spawnu za VIP-a
    if (IsVIP(playerid, 4)) PI[playerid][p_spawn_armour] = 100.0;
    else if (IsVIP(playerid, 3)) PI[playerid][p_spawn_armour] = 70.0;
    else if (IsVIP(playerid, 2)) PI[playerid][p_spawn_armour] = 35.0;
    else PI[playerid][p_spawn_armour] = 0;

	// Formatiranje unosa za update podataka u bazi
	new sSpawn[63], sQuery[115];
	format(sSpawn, sizeof(sSpawn), "%.4f|%.4f|%.4f|%.4f|%d|%d|%.1f|%.1f", PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], PI[playerid][p_spawn_ent], PI[playerid][p_spawn_vw], PI[playerid][p_spawn_health], PI[playerid][p_spawn_armour]);

	// Update podataka u bazi
	format(sQuery, sizeof sQuery, "UPDATE igraci SET spawn = '%s' WHERE id = %d", sSpawn, PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery);

	// Slanje poruke igracu
	InfoMsg(playerid, "Mesto stvaranja (spawn) je uspesno promenjeno. Novi spawn je: {FFFFFF}%s.", spawnStr);

    if (GetPVarInt(playerid, "vipOverride") == 1)
    {
        DeletePVar(playerid, "vipOverride");
        callcmd::vip(playerid, "");
    }

	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:plati("pay", "givemoney")
alias:refresh("osvezi", "osvjezi", "osvijezi", "odmrznime")
cmd:shownames(playerid, const params[])
{
    new
        togsel
    ;
    if(sscanf(params, "i", togsel))
        return Koristite(playerid, "shownames [1 - sakrij imena / 0 - prikazi imena]");

    foreach(new i : Player)
    {
        if(i != playerid)
            ShowPlayerNameTagForPlayer(playerid, i, togsel);
    }
    return 1;
}

/*CMD:buydrill(const playerid)
{
    if (BP_PlayerItemGetCount(playerid, ITEM_DRILL) >= 1)
        return ErrorMsg(playerid, "Vec imate busilicu.");

    if (PI[playerid][p_novac] << 5000)
        return ErrorMsg(playerid, "Nemate dovoljno novca ($5000).");

    BP_PlayerItemAdd(playerid, ITEM_DRILL, BP_GetItemCountLimit(ITEM_DRILL));
    BP_PlayerItemSub(playerid, ITEM_DRILL);
    return 1;
}*/


flags:testmode(FLAG_ADMIN_6)
CMD:testmode(const playerid)
{
    if(!testingdaddy) {
        testingdaddy = true;
        InfoMsg(playerid, "Aktivirao si test mode, provjere za kolicinu igraca pri pljacki banke, zlatare i zauzimanju teritorija se nece racunati.");
    }
    else {
        testingdaddy = false;
        InfoMsg(playerid, "Ugasio si test mode, provjere za kolicinu igraca pri pljacki banke, zlatare i zauzimanju teritorija ce se racunati.");
    }
    return 1;
}

CMD:spawn(playerid, const params[]) 
{
    if (IsTurfWarActiveForPlayer(playerid))
    {
        return ErrorMsg(playerid, "Ne mozete promeniti spawn dok Vas tim ucestvuje u borbi za teritoriju.");
    }

	SPD(playerid, "spawn", DIALOG_STYLE_LIST, "{0068B3}PROMENA SPAWNA", "Default\nKuca\nStan\nFirma\nHotel\nGaraza\nVikendica\nBaza\nHotelska soba\nIznajmljena soba u kuci\nTrenutna pozicija", "Odaberi", "Izadji");

	return 1;
}

CMD:izracunaj(playerid, const params[]) 
{
	new 
        Float:vrednost[2], operacija[3];
	if (sscanf(params, "fs[3]f", vrednost[0], operacija, vrednost[1])) 
        return Koristite(playerid, "izracunaj [Vrednost 1] [Operacija ( + - * / )] [Vrednost 2]");

	if (!strcmp(operacija, "+")) {
	    new Float:rezultat = floatadd(vrednost[0], vrednost[1]);
	    format(string_32, 32, "%.1f + %.1f = %.1f", vrednost[0], vrednost[1], rezultat);
	    SendClientMessage(playerid, BELA, string_32);
	}
	else if (!strcmp(operacija, "-")) {
	    new Float:rezultat = floatsub(vrednost[0], vrednost[1]);
	    format(string_32, 32, "%.1f - %.1f = %.1f", vrednost[0], vrednost[1], rezultat);
	    SendClientMessage(playerid, BELA, string_32);
	}
	else if (!strcmp(operacija, "*")) {
	    new Float:rezultat = floatmul(vrednost[0], vrednost[1]);
	    format(string_32, 32, "%.1f * %.1f = %.1f", vrednost[0], vrednost[1], rezultat);
	    SendClientMessage(playerid, BELA, string_32);
	}
	else if (!strcmp(operacija, "/")) {
	    new Float:rezultat = floatdiv(vrednost[0], vrednost[1]);
	    format(string_32, 32, "%.1f / %.1f = %.1f", vrednost[0], vrednost[1], rezultat);
	    SendClientMessage(playerid, BELA, string_32);
	}
	else 
        return ErrorMsg(playerid, "Nevazeca racunska operacija!");

	return 1;
}

CMD:imovina(playerid, const params[]) 
{
	return SPD(playerid, "imovina", DIALOG_STYLE_LIST, "{0068B3}UPRAVLJANJE IMOVINOM", "Vozila\nNekretnine", "Odaberi", "Izadji");
}

CMD:hodanje(playerid, const params[]) 
{
    new hodanje[10];
	if (PI[playerid][p_pol] == POL_MUSKO) 
    {
		// Provera parametara
	    if (sscanf(params, "s[10]", hodanje)) 
        {
			Koristite(playerid, "hodanje [Stil hodanja koji zelite da koristite]");
			SendClientMessage(playerid, GRAD2, "Dostupno: [Normalan] [Ped] [Gangsta 1] [Gangsta 2] [Debeli] [Starac] [Slepac]");
		
			return 1;
		}
		
		// Trazenje unetog stila
		if (!strcmp(hodanje, "Ped", true)) 				
            PI[playerid][p_stil_hodanja] = WALK_PED, 		hodanje = "Ped";

		else if (!strcmp(hodanje, "Gangsta 1", true))	
            PI[playerid][p_stil_hodanja] = WALK_GANGSTA,	hodanje = "Gangsta 1";

		else if (!strcmp(hodanje, "Gangsta 2", true))	
            PI[playerid][p_stil_hodanja] = WALK_GANGSTA2,	hodanje = "Gangsta 2";

		else if (!strcmp(hodanje, "Debeli", true)) 		
            PI[playerid][p_stil_hodanja] = WALK_FAT, 		hodanje = "Debeli";

		else if (!strcmp(hodanje, "Starac", true)) 		
            PI[playerid][p_stil_hodanja] = WALK_OLD, 		hodanje = "Starac";

		else if (!strcmp(hodanje, "Slepac", true)) 		
            PI[playerid][p_stil_hodanja] = WALK_BLIND, 		hodanje = "Slepac";

		else if (!strcmp(hodanje, "Normalan", true))	
            PI[playerid][p_stil_hodanja] = WALK_DEFAULT, 	hodanje = "Normalan";

		else 
            return ErrorMsg(playerid, "Uneli ste pogresan stil hodanja, pokusajte ponovo.");
	}
	else if (PI[playerid][p_pol] == POL_ZENSKO) {
		// Provera parametara
	    if (sscanf(params, "s[10]", hodanje)) 
		{
			Koristite(playerid, "hodanje [Stil hodanja koji zelite da koristite]");
			SendClientMessage(playerid, GRAD2, "Dostupno: [Zenski 1] [Zenski 2] [Kurva 1] [Kurva 2]");
			
			return 1;
		}
		
		// Trazenje unetog stila
		if (!strcmp(hodanje, "Zenski 1", true)) 		
            PI[playerid][p_stil_hodanja] = WALK_LADY, 	hodanje = "Zenski 1";

		else if (!strcmp(hodanje, "Zenski 2", true))	
            PI[playerid][p_stil_hodanja] = WALK_LADY2, 	hodanje = "Zenski 2";

		else if (!strcmp(hodanje, "Kurva 1", true))		
            PI[playerid][p_stil_hodanja] = WALK_WHORE, 	hodanje = "Kurva 1";

		else if (!strcmp(hodanje, "Kurva 2", true)) 	
            PI[playerid][p_stil_hodanja] = WALK_WHORE2,	hodanje = "Kurva 2";

		else 
            return ErrorMsg(playerid, "Uneli ste pogresan stil hodanja, pokusajte ponovo.");
	}
	else return SendClientMessage(playerid, TAMNOCRVENA2, GRESKA_NEPOZNATO);
    
    // Update podataka u bazi
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET stil_hodanja = %d WHERE id = %d", PI[playerid][p_stil_hodanja], PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
    
    // Slanje poruke igracu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Vas stil hodanja je sada: {FFFFFF}%s.", hodanje);
	return 1;
}

CMD:refresh(playerid, const params[]) 
{
	if (zamrznut{playerid} == true) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "Ne mozete koristiti tu komandu u ovom trenutku, obratite se Game Adminima za dalju pomoc!");
		
	TogglePlayerControllable_H(playerid, true);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
	SendClientMessage(playerid, ZELENA, "Igra je osvezena.");
	return 1;
}

CMD:time(playerid, const params[]) 
{
    new jailTime, str[124];
    if (PI[playerid][p_zatvoren] > 0) jailTime = PI[playerid][p_zatvoren];
    if (PI[playerid][p_area] > 0) jailTime = PI[playerid][p_area];

	if (jailTime > 0 && PI[playerid][p_utisan] == 0) 
		format(str, sizeof str, "~r~~n~~n~~n~~n~~n~~n~~n~Zatvoreni ste jos: ~w~%s", konvertuj_vreme(jailTime));
	
	else if (jailTime == 0 && PI[playerid][p_utisan] > 0) 
		format(str, sizeof str, "~r~~n~~n~~n~~n~~n~~n~~n~Utisani ste jos: ~w~%s", konvertuj_vreme(PI[playerid][p_utisan]));
	
	else if (jailTime > 0 && PI[playerid][p_utisan] > 0) 
		format(str, sizeof str, "~r~~n~~n~~n~~n~~n~~n~Zatvoreni ste jos: ~w~%s~n~~r~Utisani ste jos: ~w~%s", konvertuj_vreme(jailTime), konvertuj_vreme(PI[playerid][p_utisan]));
    
    if(PI[playerid][p_utisan] > 0) 
		format(str, sizeof str, "~r~~n~~n~~n~~n~~n~~n~~n~Utisani ste jos: ~w~%s", konvertuj_vreme(PI[playerid][p_utisan]));
	
    if(!isnull(str))
	    GameTextForPlayer(playerid, str, 5000, 3);

    else 
		return ErrorMsg(playerid, "Ne mozete koristiti tu komandu u ovom trenutku!");

	return 1;
}

CMD:music(playerid, const params[])
{
    pAdminMusic{playerid} = !pAdminMusic{playerid};

    if (!pAdminMusic{playerid})
    {
        StopAudioStreamForPlayer(playerid);
        SendClientMessage(playerid, BELA, "* Iskljucili ste muziku koju pusta DJ.");
    }
    else
    {
        if (!isnull(djMusicLink)) 
        {
            PlayAudioStreamForPlayer(playerid, djMusicLink);
            SendClientMessage(playerid, BELA, "* Ukljucili ste muziku koju pusta DJ.");
        }
        else
        {
            InfoMsg(playerid, "Trenutno nije pustena nijedna numera, ali cete moci da cujete muziku kada bude pustena.");
        }
    }
    return 1;
}

CMD:djevi(playerid, const params[])
{
    mysql_tquery(SQL, "SELECT ime FROM igraci WHERE dj = 1", "MySQL_OnDJSelected", "ii", playerid, cinc[playerid]);
    return 1;
}

CMD:id(playerid, const params[])
{
    if (isnull(params))
        return Koristite(playerid, "id [Ime igraca]");

    new ime[MAX_PLAYER_NAME];
    format(ime, sizeof ime, "%s", params);

    new targetid = INVALID_PLAYER_ID;
    foreach(new i : Player)
    {
        if (strcmp(ime_obicno[i], ime, true) == 0)
        {
            targetid = i;
            break;
        }
    }

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    SendClientMessageF(playerid, GRAD2, "%s | ID: {FFFFFF}%i", ime_obicno[targetid], targetid);
    return 1;
}

stock IsNewPlayer(playerid)
{
    if (IsPlayerLoggedIn(playerid) && PI[playerid][p_provedeno_vreme] <= 20*3600)
    {
        return true;
    }
    return false;
}

flags:streamer(FLAG_ADMIN_6)
CMD:streamer(playerid, const params[])
{
    DebugMsg(playerid, "Vidljivi objekti: %i", Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT));
    DebugMsg(playerid, "Vidljivi pickupi: %i", Streamer_CountVisibleItems(playerid, STREAMER_TYPE_PICKUP));
    DebugMsg(playerid, "Vidljive ikone: %i", Streamer_CountVisibleItems(playerid, STREAMER_TYPE_MAP_ICON));

    new total = 0;
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_OBJECT);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_PICKUP);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_CP);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_RACE_CP);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_MAP_ICON);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_AREA);
    total += Streamer_CountVisibleItems(playerid, STREAMER_TYPE_ACTOR);
    DebugMsg(playerid, "-- Ukupno vidljivih stvari: %i", total);
    DebugMsg(playerid, "-- Ukupno actora: %i", CountDynamicActors(0));
    return 1;
}

CMD:sadi(playerid, const params[])
{
    if (IsPlayerInWeedField(playerid))
        return callcmd::sadidrogu(playerid, "");

    else if (GetPlayerLandID(playerid) != -1)
        return callcmd::sadivoce(playerid, "");

    else return ErrorMsg(playerid, "Ne mozete nista da sadite na ovom mestu.");
}

CMD:beri(playerid, const params[])
{
    if (IsPlayerInWeedField(playerid))
        return callcmd::beridrogu(playerid, "");

    else if (GetPlayerLandID(playerid) != -1)
        return callcmd::berivoce(playerid, "");

    else return ErrorMsg(playerid, "Ne mozete nista da berete na ovom mestu.");
}

CMD:discord(playerid, const params[])
{
    return SendClientMessage(playerid, COLOR_NAVY_BLUE_13, "URL Discord servera je: {7289DA}nlsamp.com/discord "#NAVY_BLUE_13"| Pridruzite se!");
}
