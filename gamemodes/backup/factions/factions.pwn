/*

- Resetovati varijable (enume) (ne mora sve) pod OnGameModeInit()
- Onemoguciti davanje i oduzimanje lider ranka svima osim head adminu
- Za PD/MD napraviti posebnu dozvolu za uzimanje duznosti i postavljanje prepreka

*/

#include <YSI_Coding\y_hooks>

enum {
	THREAD_FACTION_INSERT = 10000,
    THREAD_FACTION_UPDATE,
    THREAD_FACTION_DELETE,
    THREAD_FACTION_CONFIG,
    THREAD_FACTION_MEMBERS,
    THREAD_FACTION_VEHICLES,
    THREAD_FACTION_VEHICLES_WEAPONS,
    THREAD_FACTION_RANKS,
    THREAD_FACTION_GATES
}

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_FACTIONS            16
#define MAX_FACTIONS_VEHICLES   30
#define MAX_FACTIONS_MEMBERS    50
#define MAX_FACTIONS_RANKS      8 // RANK_LEADER + 1
#define MAX_FACTIONS_GATES      4
#define MAX_FNAME_LENGTH        32
#define MAX_FTAG_LENGTH         7
#define MAX_HEX_LENGTH          11
#define MAX_RANK_LENGTH         24
#define RANK_LEADER             7
#define FACTIONS_CONTRACT_TIME  (604800) // 7 dana
#define FACTIONS_PENALTY_TIME   (259200) // 3 dana

// Dozvole
#define DOZVOLA_CHAT            1  // Upotreba chata
#define DOZVOLA_VOZILA          2  // Upotreba vozila
#define DOZVOLA_SPAWN           4  // Spawn u bazi
#define DOZVOLA_ENT             8  // Upotreba (ulaz) enterijera
#define DOZVOLA_O_ULAZ          16 // Upotreba (ulaz) oruzarnice
#define DOZVOLA_O_KUPOVINA      32 // Kupovina u oruzarnici

#define GATE                    (0)
#define RAMP                    (1)
#define GATE_CLOSED             (true)
#define GATE_OPEN               (false)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_FACTIONS
{
	f_loaded, // Iako nepotrebno, drzi ID organizacije i sluzi za proveru da li je organizacija ucitana (-1: organizacija nije ucitana)
	f_vrsta, // mafija, banda, law, md
	f_naziv[MAX_FNAME_LENGTH],
	f_tag[MAX_FTAG_LENGTH],
	f_clanovi, // Trenutni broj clanova
	f_max_clanova,
	f_max_vozila,
	Float:f_x_ulaz,
	Float:f_y_ulaz,
	Float:f_z_ulaz,
	Float:f_a_ulaz,
	Float:f_x_izlaz,
	Float:f_y_izlaz,
	Float:f_z_izlaz,
	Float:f_a_izlaz,
	Float:f_x_spawn,
	Float:f_y_spawn,
	Float:f_z_spawn,
	Float:f_a_spawn,
	f_ent_spawn,
	f_vw_spawn,
	f_entid, // ID enterijera (onaj koji se kupuje) preko koga se zatim odredjuje enterijer (onaj drugi xd), virtual world, koordinate izlaza, itd
	f_ent, // Enterijer koji se postavlja unutra (SetPlayerInterior)
	f_vw, // Virtual za enterijer
	f_budzet,
	f_materijali,
	f_municija,
	f_materijali_skladiste,
	f_municija_skladiste,
	f_wars_won,
	f_wars_lost,
	f_wars_draw,
	f_boja_1,
	f_boja_2,
	f_hex[11],
	f_rgb[7], // nastaje iz f_hex kad se oduzme "0x" i 2 poslednja karaktera
	f_respawnCooldown,
	f_sefArea,
	f_interactCP, // Za bande izrada droge; za mafije kupovina oruzja
	f_turfCooldown,
	f_areaid,
	f_heroin,
	f_mdma,
	f_weed,
	Text3D:f_entrance_label,
	Text3D:f_sefLabel,
};

enum E_FACTIONS_VEHICLES
{
	fv_mysql_id, // Auto increment ID u bazi (koristi se zbog update/delete upita)
	fv_vehicle_id, // ID kreiranog vozila (-1 ako nije ucitano)
	fv_model_id,
	fv_cena,
	Float:fv_x_spawn,
	Float:fv_y_spawn,
	Float:fv_z_spawn,
	Float:fv_a_spawn,
	fv_prodaja,
	Text3D:fv_label,
};

enum E_FACTIONS_VEHICLES_WEAPONS
{
	fv_weapon,
	fv_ammo,
};

enum E_FACTIONS_RANKS
{
	fr_ime[MAX_RANK_LENGTH],
	fr_skin,
	fr_dozvole,
}

enum E_FACTIONS_GATES
{
	fg_obj_id,
	fg_model,
	fg_vrsta, // -1 = ne postoji
	Float:fg_open_x,
	Float:fg_open_y,
	Float:fg_open_z,
	Float:fg_closed_x,
	Float:fg_closed_y,
	Float:fg_closed_z,
	bool:fg_status, // true = closed, false = open
	fg_timer,
}

enum
{
	FACTION_MAFIA = 1,
	FACTION_GANG,
	FACTION_LAW,
	FACTION_RACERS,
	FACTION_MD,
	// Pri dodavanju/oduzimanju izmeniti faction_name(), /org_izrada, Dialog:org_izmeni
};

enum 
{
	FNAME_GENITIV,
	FNAME_DATIV,
	FNAME_AKUZATIV,
	FNAME_CAPITAL,
	FNAME_UPPER,
	FNAME_LOWER,
};

enum E_FACTIONS_IZRADA
{
	IZRADA_AKTIVNA,
	IZRADA_VRSTA,
	IZRADA_MAX_CLANOVA,
	IZRADA_MAX_VOZILA,
	IZRADA_BOJA_1,
	IZRADA_BOJA_2,
	IZRADA_NAZIV[MAX_FNAME_LENGTH],
	IZRADA_TAG[MAX_FTAG_LENGTH],
	IZRADA_HEX[MAX_HEX_LENGTH],
};

enum E_FACTIONS_IZMENA
{
	IZMENA_AKTIVNA,
	IZMENA_ID, // id organizacije
	IZMENA_ITEM, // sta izmenjuje
}

enum
{
	IZMENA_NISTA = -1,
	IZMENA_NAZIV = 0,
	IZMENA_TAG,
	IZMENA_VRSTA,
	IZMENA_CLANOVI,
	IZMENA_VOZILA,
	IZMENA_BUDZET,
	IZMENA_BOJA_1,
	IZMENA_BOJA_2,
	IZMENA_HEX,
	IZMENA_RANK,
	IZMENA_IZBACI,
	IZMENA_RANKOVI,
	
	// Ovim redom su postavljeni itemi u dialogu za izmenu, tako da mogu da se koriste ove varijable umesto cistih brojeva
}

enum E_MAFIA_WPNMAKE
{
	MAF_WPNMAKE_NAZIV[15],
	MAF_WPNMAKE_MATS_PRICE,
	MAF_WPNMAKE_MONEY_PRICE,
}


new ZatvorVrata[2],
	bool:ZatvorVrataState;

// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new FACTIONS[MAX_FACTIONS][E_FACTIONS];
new F_VEHICLES[MAX_FACTIONS][MAX_FACTIONS_VEHICLES][E_FACTIONS_VEHICLES];
new F_VEH_WEAPONS[MAX_FACTIONS][MAX_FACTIONS_VEHICLES][13][E_FACTIONS_VEHICLES_WEAPONS];
new F_RANKS[MAX_FACTIONS][MAX_FACTIONS_RANKS][E_FACTIONS_RANKS];
new F_GATES[MAX_FACTIONS][MAX_FACTIONS_GATES][E_FACTIONS_GATES];
new F_IZRADA[E_FACTIONS_IZRADA];
new F_IZMENA[MAX_PLAYERS][E_FACTIONS_IZMENA];

static 
	gGunshopUsed[MAX_PLAYERS char],
	tmrKidnappingWL[MAX_PLAYERS],
	bool:gLeaderChat
;


new
	f_loading_last_id,
	faction_listitem[MAX_PLAYERS][MAX_FACTIONS],
	faction_vehicles_listitem[MAX_PLAYERS][MAX_FACTIONS_VEHICLES],
	faction_vehicles_edit_id[MAX_PLAYERS],
	faction_ranks_listitem[MAX_PLAYERS][MAX_FACTIONS_RANKS],
	faction_ranks_editing[MAX_PLAYERS],
	faction_ranks_id[MAX_PLAYERS],
	faction_ranks_ime[MAX_PLAYERS][MAX_RANK_LENGTH],
	faction_listeting[MAX_PLAYERS],

	f_pozvan[MAX_PLAYERS], // ID organizacije u koju je pozvan
	f_pozvan_ime[MAX_PLAYERS][MAX_PLAYER_NAME], // Ime igraca (admin/lider) od strane koga je pozvan
	
	f_ts_initial[MAX_PLAYERS], // Pocetni timestamp za provedeno vreme u organizaciji
	f_ts_initial_ban[MAX_PLAYERS], // Pocetni timestamp za zabranu ulaska

	bool:gPlayerRopeTied[MAX_PLAYERS char],


	Iterator:faction_vehicles<MAX_VEHICLES>,
	Iterator:iPolicemen<MAX_PLAYERS>
;

new F_LEADERS[MAX_FACTIONS][2][MAX_PLAYER_NAME];


// Ne menjati redosled
new Float:faction_interiors[][5] = 
{
	{1372.0996,8.0094,1001.0008,187.7811, 0.0}, // PD
	{238.6384, 138.7955, 1003.0481, 0.0000, 3.0}, // SWAT
	{1396.2795,-24.6369,1001.0052,270.0, 0.0}, // Mafia generic
	{-527.8986,-51.8994,-12.0333,90.0,10.0}, // Gang generic
	{1383.3387,-39.5031,1000.9503,0.0, 0.0}, // Escobar Cartel
	{1383.6727,-24.1335,1000.9534,360.0, 0.0}, // Pink Panter
	{1402.9940,-32.3642,1000.9440,180.0, 0.0}, // La Casa De Papel
	// ID enterijera je takodje hard-kodovan u fajlovima mapa (da bi objekti bili kreirani samo u jednom entu, jer su iste lokacije svih objekata, a razliciti su grafiti)
	// {-527.8986,-51.8994,-12.0333,90.0,1.0}, // GSF old
	{2590.1723,-1648.6329,1248.0,0.0,1.0}, // GSF
	// {-527.8986,-51.8994,-12.0333,90.0,2.0}, // LSB by Nate (isto kao GSF, samo drugi grafiti)
	{1922.0554,1924.6527,906.4458,270.6654, 2.0}, // LSB by Necro
	{-527.8986,-51.8994,-12.0333,90.0,3.0}, // LSV
	{-527.8986,-51.8994,-12.0333,90.0,4.0}, // VLA
	{1412.9609,-16.4836,1001.0,90.0} // UGR
	//{-527.8986,-51.8994,-12.0333,90.0,2.0}, // LSB by Nate (isto kao GSF, samo drugi grafiti)
	// {-527.8986,-51.8994,-12.0333,90.0,5.0}, // MS13
};



// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit() 
{
	CreateDynamicObject(19794, 1787.13281, -1565.67969, 11.96880,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18766, 1754.99023, -1591.40808, 13.78708,   0.00000, 0.00000, 346.08774);
	ZatvorVrata[0] = CreateDynamicObject(19795, 1822.46362, -1540.96594, 14.18560,   0.00000, 0.00000, 164.38341); // -120
	ZatvorVrata[1] = CreateDynamicObject(19795, 1824.22595, -1534.71240, 14.17600,   0.00000, 0.00000, 344.07889); // -90

	ZatvorVrataState = false;

	for__loop (new i = 0; i < MAX_FACTIONS; i++) 
	{
		FACTIONS[i][f_loaded] = -1;
		FACTIONS[i][f_entrance_label] = Text3D:INVALID_3DTEXT_ID;
		FACTIONS[i][f_sefLabel] = Text3D:INVALID_3DTEXT_ID;
		
		// Resetovanje vozila
		for__loop (new v = 0; v < MAX_FACTIONS_VEHICLES; v++)
			F_VEHICLES[i][v][fv_vehicle_id] = -1;
		
		// Resetovanje rankova
		for__loop (new r = 0; r < MAX_FACTIONS_RANKS; r++)
			F_RANKS[i][r][fr_dozvole] = 0;
	}
	
	gLeaderChat = true;

	// Ucitavanje iz baze
	mysql_tquery(SQL, "SELECT * FROM factions", "mysql_factions", "ii", THREAD_FACTION_CONFIG, -1);


	// 3D text za tocenje goriva i popravku za UGR
	//CreateDynamic3DTextLabel("[ Benzinska pumpa ]\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo", 0xFFFF00FF, 2582.6416,-2189.3118,0.6778, 7.0); // UGR
	//CreateDynamic3DTextLabel("[ Mehanicar ]\n{FFFFFF}Upisite {FF9900}/popravka {FFFFFF}da popravite vozilo", 0xFF9900FF, 2593.9099,-2180.5962,0.5287, 7.0); // UGR
	return 1;
}

hook OnPlayerConnect(playerid) 
{
	RemoveBuildingForPlayer(playerid, 4080, 1787.1328, -1565.6797, 11.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 4000, 1787.1328, -1565.6797, 11.9688, 0.25);

	/*f_ts_initial[playerid] = gettime();*/
	f_ts_initial_ban[playerid] = gettime();
	gPlayerRopeTied{playerid} = false;
	faction_listeting[playerid] = -1;
	gGunshopUsed{playerid} = 0;

	tajmer:HideSkillTextdraw[playerid] = 0;

	return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
	gPlayerRopeTied{playerid} = false;
	gGunshopUsed{playerid} = 0;
}

hook OnPlayerDisconnect(playerid) 
{
	F_IZMENA[playerid][IZMENA_AKTIVNA] = 0;
	

	KillTimer(tmrKidnappingWL[playerid]);
		
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
	if (PI[playerid][p_org_id] == -1 && !IsAdmin(playerid, 5)) return 1;

	if((newkeys & KEY_CROUCH))
	{
		if(IsPlayerInRangeOfPoint(playerid, 5.0, 1825.3306, -1538.4541, 13.6367) || IsPlayerInRangeOfPoint(playerid, 5.0, 1817.1068,-1536.3624,13.3271))
		{
			if(IsACop(playerid) || IsAdmin(playerid, 6))
			{
				if(!ZatvorVrataState)
				{
					MoveDynamicObject(ZatvorVrata[0], 1822.46362, -1540.96594, 14.18560-0.001, 0.003, 0.00000, 0.00000, -120.00000);
					MoveDynamicObject(ZatvorVrata[1], 1824.22595, -1534.71240, 14.17600-0.001, 0.003, 0.00000, 0.00000, -90.00000);
					ZatvorVrataState = true;
					return 1;
				}
				else
				{
					MoveDynamicObject(ZatvorVrata[0], 1822.46362, -1540.96594, 14.18560+0.001, 0.003, 0.00000, 0.00000, 164.38341);
					MoveDynamicObject(ZatvorVrata[1], 1824.22595, -1534.71240, 14.17600+0.001, 0.003, 0.00000, 0.00000, 344.07889);
					ZatvorVrataState = false;
					return 1;
				}
			}
		}
	}

	if ((!IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CTRL_BACK)) || (IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CROUCH))) 
	{ // H
		new Float:pos[3];
		if (PI[playerid][p_org_id] != -1 && !IsAdmin(playerid, 5)) 
		{
			// Da bismo smanjili broj loopova, postoji ova provera.
			// U pitanju je igrac, clan neke grupe, a pritom nije admin >= 5. Proveravamo samo kapije njegove grupe

			if (FACTIONS[PI[playerid][p_org_id]][f_vrsta] == FACTION_LAW)
			{
				// Igrac je clan neke LAW organizacije
				// Pravimo loop kroz sve organizacije, a u obzir uzimamo samo LAW da bi medjusobno mogli da koriste kapije i rampe
				for__loop (new f_id = 0; f_id < MAX_FACTIONS; f_id++) 
				{
					if (FACTIONS[f_id][f_vrsta] != FACTION_LAW) continue;
					
					for__loop (new i = 0; i < MAX_FACTIONS_GATES; i++) 
					{
						if (F_GATES[f_id][i][fg_vrsta] == -1) continue;

						GetDynamicObjectPos(F_GATES[f_id][i][fg_obj_id], pos[POS_X], pos[POS_Y], pos[POS_Z]);
						if (IsPlayerInRangeOfPoint(playerid, 10.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) 
						{
							if (F_GATES[f_id][i][fg_model] == 3498) // Stubici
							{
								for__loop (new j = 0; j < MAX_FACTIONS_GATES; j++) 
								{
									if (F_GATES[f_id][j][fg_model] != 3498) continue;

									new start_timer = (F_GATES[f_id][j][fg_status] == GATE_CLOSED)? 1 : 0;
									if (F_GATES[f_id][j][fg_status] == GATE_OPEN) 
									{
										// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
										KillTimer(F_GATES[f_id][j][fg_timer]), F_GATES[f_id][j][fg_timer] = 0;
									}

									factions_ToggleGateRamp(f_id, j, start_timer);
								}
							}
							else 
							{
								new start_timer = (F_GATES[f_id][i][fg_status] == GATE_CLOSED)? 1 : 0;
								if (F_GATES[f_id][i][fg_status] == GATE_OPEN) 
								{
									// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
									KillTimer(F_GATES[f_id][i][fg_timer]), F_GATES[f_id][i][fg_timer] = 0;
								}

								factions_ToggleGateRamp(f_id, i, start_timer);
							}
							return ~1;
						}
					}
				}
			}
			else
			{
				// Igrac je clan mafije ili bande, proveravamo samo tu m/b
				new f_id = PI[playerid][p_org_id];

				for__loop (new i = 0; i < MAX_FACTIONS_GATES; i++) 
				{
					if (F_GATES[f_id][i][fg_vrsta] == -1) continue;

					GetDynamicObjectPos(F_GATES[f_id][i][fg_obj_id], pos[POS_X], pos[POS_Y], pos[POS_Z]);
					if (IsPlayerInRangeOfPoint(playerid, 10.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) 
					{
						if (F_GATES[f_id][i][fg_model] == 3498) // Stubici
						{
							for__loop (new j = 0; j < MAX_FACTIONS_GATES; j++) 
							{
								if (F_GATES[f_id][j][fg_model] != 3498) continue;

								new start_timer = (F_GATES[f_id][j][fg_status] == GATE_CLOSED)? 1 : 0;
								if (F_GATES[f_id][j][fg_status] == GATE_OPEN) 
								{
									// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
									KillTimer(F_GATES[f_id][j][fg_timer]), F_GATES[f_id][j][fg_timer] = 0;
								}

								factions_ToggleGateRamp(f_id, j, start_timer);
							}
						}
						else 
						{
							new start_timer = (F_GATES[f_id][i][fg_status] == GATE_CLOSED)? 1 : 0;
							if (F_GATES[f_id][i][fg_status] == GATE_OPEN) 
							{
								// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
								KillTimer(F_GATES[f_id][i][fg_timer]), F_GATES[f_id][i][fg_timer] = 0;
							}

							factions_ToggleGateRamp(f_id, i, start_timer);
						}
						return ~1;
					}
				}
			}
		}

		if (IsAdmin(playerid, 5)) 
		{
			// Za admina lvl 5+ mora da prodje loop kroz sve kapije, jer admin 5+ moze da otvori bilo sta
			for__loop (new f_id = 0; f_id < MAX_FACTIONS; f_id++) 
			{
				for__loop (new i = 0; i < MAX_FACTIONS_GATES; i++) 
				{
					if (F_GATES[f_id][i][fg_vrsta] == -1) continue;

					GetDynamicObjectPos(F_GATES[f_id][i][fg_obj_id], pos[POS_X], pos[POS_Y], pos[POS_Z]);
					if (IsPlayerInRangeOfPoint(playerid, 10.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) {
						if (F_GATES[f_id][i][fg_model] == 3498) // Stubici
						{
							for__loop (new j = 0; j < MAX_FACTIONS_GATES; j++) 
							{
								if (F_GATES[f_id][j][fg_model] != 3498) continue;

								new start_timer = (F_GATES[f_id][j][fg_status] == GATE_CLOSED)? 1 : 0;
								if (F_GATES[f_id][j][fg_status] == GATE_OPEN) 
								{
									// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
									KillTimer(F_GATES[f_id][j][fg_timer]), F_GATES[f_id][j][fg_timer] = 0;
								}

								factions_ToggleGateRamp(f_id, j, start_timer);
							}
						}
						else 
						{
							new start_timer = (F_GATES[f_id][i][fg_status] == GATE_CLOSED)? 1 : 0;
							if (F_GATES[f_id][i][fg_status] == GATE_OPEN) 
							{
								// Kapija je otvorena, pa bi trebalo zaustaviti tajmer
								KillTimer(F_GATES[f_id][i][fg_timer]), F_GATES[f_id][i][fg_timer] = 0;
							}

							factions_ToggleGateRamp(f_id, i, start_timer);
						}
						return ~1;
					}
				}
			}
		}

	}
	return 1;
}


/*
  Poziva se kad igrac pokusa da udje u vozilo da bi se proverilo vlasnistvo i
  eventualno izbacio iz istog
*/
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (ispassenger) return 1; // nema veze ako je putnik

	foreach (new i : faction_vehicles) 
	{
		if (i == vehicleid) // Naisli smo na vozilo neke o/m/b
		{
			// Da vidimo kojoj o/m/b pripada ovo vozilo...
			new slot = -1, f_id = -1;
			for__loop (new j = 0; j < MAX_FACTIONS; j++) 
			{
				for__loop (new s = 0; s < FACTIONS[j][f_max_vozila]; s++) 
				{
					if (F_VEHICLES[j][s][fv_vehicle_id] == i) 
					{
						f_id = j;
						slot = s;
						break;
					}
				}
				if (f_id != -1) break;
			}

			if (f_id == -1 || slot == -1)
			{
				ErrorMsg(playerid, "Usli ste u vozilo neke o/m/b, ali se ne moze odrediti koje.");
			}

			if (IsAdmin(playerid, 6) && PI[playerid][p_org_id] != f_id) 
			{
				
				if (PI[playerid][p_org_id] != f_id)
				{
					SendClientMessageF(playerid, CRVENA, "%s | Vlasnik: %s (%d) | Slot: %d | ID (server): %d", imena_vozila[GetVehicleModel(vehicleid) - 400], FACTIONS[f_id][f_tag], f_id, slot, vehicleid);
				}

				return ~1;
			}

			else if (PI[playerid][p_org_id] == f_id && IsACop(playerid))
			{
				// Policajac ulazi u policijsko vozilo. Dozvoliti samo osnovna vozila za R1
				new model = GetVehicleModel(vehicleid), bool:rankError = false;
				if ((model == 599 || model == 490) && PI[playerid][p_org_rank] < 2)
				{
					// Police Ranger / FBI Rancher - rank 2+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 2.");
					rankError = true;
				}
				else if ((model == 427 || model == 560) && PI[playerid][p_org_rank] < 3)
				{
					// Enforcer / Sultan - rank 3+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 3.");
					rankError = true;
				}
				else if (model == 601 && PI[playerid][p_org_rank] < 4)
				{
					// SWAT Van - rank 4+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 4.");
					rankError = true;
				}
				else if ((model == 497 || model == 487) && PI[playerid][p_org_rank] < 5)
				{
					// Maverick - rank 5+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 5.");
					rankError = true;
				}
				else if (model == 541 && PI[playerid][p_org_rank] < 3)
				{
					// Bullet/Maverick - rank 3+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 3.");
					rankError = true;
				}
				else if (model == 447 && PI[playerid][p_org_rank] < 6)
				{
					// Sea Sparrow - rank 6+
					ErrorMsg(playerid, "Za upotrebu ovog vozila potreban je rank 6.");
					rankError = true;
				}
				else if (model != 596 && model != 523 && model != 426 && model != 421 && PI[playerid][p_org_rank] == 1)
				{
					// R1 ima samo obican auto + motor (za FBI windsor i premier)
					ErrorMsg(playerid, "Nemate dozvolu da koristite ovo vozilo zbog suvise malog ranka.");
					rankError = true;
				}

				if (rankError)
				{
					GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
					SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.25);
					return ~1;
				}
			}


			if (PI[playerid][p_org_id] == -1 || (PI[playerid][p_org_id] != -1 && !IsFactionVehicle(vehicleid, PI[playerid][p_org_id]))) 
			{
				if (IsMatsDeliveryVehicle(vehicleid) && IsACriminal(playerid))
				{
					// Igrac ulazi u kombi za dostavu materijala + je clan mafije/bande -> pusti ga da udje
					return ~1;
				}
				else if (IsACop(playerid) && IsLawFaction(f_id))
				{
					// Policajac ulazi u policijsko vozilo (PD/SWAT dele vozila)
					return ~1;
				}
				else
				{
					// Igrac je pokusao da udje u vozilo neke druge o/m/b
					GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
					SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.25);
					
					SendClientMessageF(playerid, GRAD2, "* Vozilo je zakljucano! Vlasnik: {FFFFFF}%s", FACTIONS[f_id][f_tag]);
					return ~1;
				}
			}
			break;
		}
	}
	return 1;
}

hook OnBurglarySuccess(playerid)
{
	new targetid = GetPVarInt(playerid, "pBreakingCuffsID");
	if (IsPlayerConnected(targetid) && IsPlayerNearPlayer(playerid, targetid) && IsPlayerHandcuffed(targetid))
	{
		SetUncuffed(targetid);
		PI[targetid][p_zavezan]  = 0;

		TogglePlayerControllable_H(targetid, true);
		SetPlayerCuffed(targetid, false);
		ClearAnimations(playerid);

		new string[65];
		format(string, sizeof string, "* Lisice su uspesno otkljucane (( %s )).", ime_rp[playerid]);
		RangeMsg(playerid, string, LJUBICASTA, 15.0);
	}
}

hook OnVehicleSpawn(vehicleid)
{
	foreach (new i : faction_vehicles) 
	{
		if (i == vehicleid) // Naisli smo na vozilo neke o/m/b
		{
			// Da vidimo kojoj o/m/b pripada ovo vozilo...
			new slot = -1, f_id = -1;
			for__loop (new j = 0; j < MAX_FACTIONS; j++) 
			{
				for__loop (new s = 0; s < FACTIONS[j][f_max_vozila]; s++) 
				{
					if (F_VEHICLES[j][s][fv_vehicle_id] == i) 
					{
						f_id = j;
						slot = s;
						break;
					}
				}
				if (f_id != -1) break;
			}

			if(f_id == GetFactionIDbyName("Pink Panter"))
			{
				if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1373.891723, -14.869547, 1009.618957))
					SetVehicleVirtualWorld(vehicleid, 100040);
				
				else
					SetVehicleVirtualWorld(vehicleid, 0);
			}

			else if(f_id == GetFactionIDbyName("Escobar Cartel"))
			{
				if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1395.8326, -17.2343, 1000.8964))
					SetVehicleVirtualWorld(vehicleid, 56000);
					
				else
					SetVehicleVirtualWorld(vehicleid, 0);
			}

			if (slot != -1 && f_id != -1 && FACTIONS[f_id][f_vrsta] == FACTION_RACERS && VehicleSupportsNitro(GetVehicleModel(vehicleid)))
			{
				AddVehicleComponent(vehicleid, 1010);
			}
			break;
		}
	}

	
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
	if (IsACriminal(playerid) && GetPVarInt(playerid, "fMakeGun"))
	{
		DeletePVar(playerid, "fMakeGun");

		new f_id = PI[playerid][p_org_id];
		if (clickedid == tdMakeGun[10])
		{
			// Desert Eagle

			if (FACTIONS[f_id][f_materijali] < 1500)
			{
				ErrorMsg(playerid, "U sefu nema dovoljno materijala za ovo oruzje.");
			}
			else
			{
				GivePlayerWeapon(playerid, WEAPON_DEAGLE, 30);
				FACTIONS[f_id][f_materijali] -= 1500;
				gGunshopUsed{playerid} ++;
			}
		}

		else if (clickedid == tdMakeGun[11])
		{
			// MP5

			if (FACTIONS[f_id][f_materijali] < 3000)
			{
				ErrorMsg(playerid, "U sefu nema dovoljno materijala za ovo oruzje.");
			}
			else
			{
				GivePlayerWeapon(playerid, WEAPON_MP5, 100);
				FACTIONS[f_id][f_materijali] -= 3000;
				gGunshopUsed{playerid} ++;
			}
		}

		else if (clickedid == tdMakeGun[12])
		{
			// M4

			if (FACTIONS[f_id][f_materijali] < 4500)
			{
				ErrorMsg(playerid, "U sefu nema dovoljno materijala za ovo oruzje.");
			}
			else
			{
				GivePlayerWeapon(playerid, WEAPON_M4, 85);
				FACTIONS[f_id][f_materijali] -= 4500;
				gGunshopUsed{playerid} ++;
			}
		}

		else if (clickedid == tdMakeGun[13])
		{
			// AK-47

			if (FACTIONS[f_id][f_materijali] < 4500)
			{
				ErrorMsg(playerid, "U sefu nema dovoljno materijala za ovo oruzje.");
			}
			else
			{
				GivePlayerWeapon(playerid, WEAPON_AK47, 85);
				FACTIONS[f_id][f_materijali] -= 4500;
				gGunshopUsed{playerid} ++;
			}
		}

		CancelSelectTextDraw(playerid);
		for__loop (new i = 0; i < sizeof tdMakeGun; i++)
		{
			TextDrawHideForPlayer(playerid, tdMakeGun[i]);
		}

		new sQuery[56];
		format(sQuery, sizeof sQuery, "UPDATE factions SET materijali = %d WHERE id = %d", FACTIONS[f_id][f_materijali], f_id);
		mysql_tquery(SQL, sQuery);

		MAFIA_ShowGunshopDialog(playerid);
	}

	return 0;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
	if (GetPVarInt(playerid, "pUsingSafe"))
	{
		new f_id = PI[playerid][p_org_id];
		if (playertextid == PlayerTD[playerid][ptdFactionSafe][0])
		{
			// Novac

			new sDialog[108];
			format(sDialog, sizeof sDialog, "{FFFFFF}Novac u sefu: {%s}%s\n\n{FFFFFF}Odaberite da li zelite da stavite ili uzmete novac.", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));
			SPD(playerid, "f_sef_novac", DIALOG_STYLE_MSGBOX, "Novac", sDialog, "Stavi", "Uzmi");
		}

		else if (playertextid == PlayerTD[playerid][ptdFactionSafe][1])
		{
			// Materijali

			// new sDialog[104];
			// format(sDialog, sizeof sDialog, "{FFFFFF}Materijali: {%s}%i\n\n{FFFFFF}Odaberite da li zelite da stavite ili uzmete materijale.", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali]);
			// SPD(playerid, "f_sef_mats", DIALOG_STYLE_MSGBOX, "Materijali", sDialog, "Stavi", "Uzmi");

			new sDialog[97];
			format(sDialog, sizeof sDialog, "{FFFFFF}Materijali u sefu: {%s}%.1f kg\n\n{FFFFFF}Upisite kolicinu koju zelite da ostavite:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali]/1000.0);

			SPD(playerid, "f_sef_mats_stavi", DIALOG_STYLE_INPUT, "Materijali", sDialog, "Stavi", "Nazad");
		}

		else if (playertextid == PlayerTD[playerid][ptdFactionSafe][2])
		{
			// Heroin/MDMA

			new sDialog[118];
			format(sDialog, sizeof sDialog, "{FFFFFF}Heroin: {%s}%i gr\n{FFFFFF}MDMA: {%s}%i gr\n\n{FFFFFF}Odaberite sta zelite da stavite/uzmete.", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_heroin], FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_mdma]);

			SPD(playerid, "f_sef_droga_1", DIALOG_STYLE_MSGBOX, "Droga", sDialog, "Heroin", "MDMA");
		}

		else if (playertextid == PlayerTD[playerid][ptdFactionSafe][4])
		{
			// Marihuana

			new sDialog[105];
			format(sDialog, sizeof sDialog, "{FFFFFF}Marihuana: {%s}%i gr\n\n{FFFFFF}Odaberite da li zelite da stavite ili uzmete marihuanu.", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_weed]);
			SPD(playerid, "f_sef_droga_2", DIALOG_STYLE_MSGBOX, "Marihuana", sDialog, "Stavi", "Uzmi");

			SetPVarInt(playerid, "fDrugs_TakePut", ITEM_WEED);
		}

		else if (playertextid == PlayerTD[playerid][ptdFactionSafe][5])
		{
			// X
			ptdFactionSafe_Destroy(playerid);
			TogglePlayerControllable_H(playerid, true);
			DeletePVar(playerid, "pUsingSafe");
		}

		CancelSelectTextDraw(playerid);
		ptdFactionSafe_Hide(playerid);
	}
	return 0;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	new f_id = PI[playerid][p_org_id];
	if (f_id != -1)
	{
		if (checkpointid == FACTIONS[f_id][f_interactCP] && GetPlayerVirtualWorld(playerid) == FACTIONS[f_id][f_vw])
		{
			if (FACTIONS[f_id][f_vrsta] == FACTION_GANG)
			{
				// Bandama se otvara dialog za izradu droge
				SetPVarInt(playerid, "pDrugsLab", 1);
				Drugs_OpenRecipeDialog(playerid);
			}
			else if (FACTIONS[f_id][f_vrsta] == FACTION_MAFIA || FACTIONS[f_id][f_vrsta] == FACTION_RACERS)
			{
				// Mafijama se otvara dialog za kupovinu oruzja/municije
				if (F_RANKS[f_id][PI[playerid][p_org_rank]][fr_dozvole] & DOZVOLA_O_KUPOVINA)
				{
					MAFIA_ShowGunshopDialog(playerid);
				}
				else
				{
					ErrorMsg(playerid, "Rank %i nema dozvolu za koriscenje oruzarnice.", PI[playerid][p_org_rank]);
				}
			}
		}
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward check_faction(playerid, type);
forward f_d_re_reket(playerid, response, listitem, const inputtext[]);
//forward faction_name(faction_type, name_type);
forward f_prijavi_igraca(playerid);
forward factions_ToggleGateRamp(f_id, i, start_timer); // Tajmer


stock Faction_UpdateEntranceLabel(fid)
{
	if (0 <= fid < MAX_FACTIONS && FACTIONS[fid][f_z_ulaz] != 6000.0)
	{
		new sLabel[188];
		format(sLabel, sizeof sLabel, "[ {%s}%s ]\nLider 1: {FFFFFF}%s | {%s}Lider 2: {FFFFFF}%s\n\nKoristite {%s}ENTER {FFFFFF}da udjete", FACTIONS[fid][f_rgb], FACTIONS[fid][f_naziv], F_LEADERS[fid][0], FACTIONS[fid][f_rgb], F_LEADERS[fid][1], FACTIONS[fid][f_rgb]);

		if (IsValidDynamic3DTextLabel(FACTIONS[fid][f_entrance_label]))
		{
			UpdateDynamic3DTextLabelText(FACTIONS[fid][f_entrance_label], 0xFFFFFFFF, sLabel);
		}
		else
		{
			FACTIONS[fid][f_entrance_label] = CreateDynamic3DTextLabel(sLabel, 0xFFFFFFFF, FACTIONS[fid][f_x_ulaz], FACTIONS[fid][f_y_ulaz], FACTIONS[fid][f_z_ulaz], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);
		}
	}
}

forward SetKidnappingWantedLevel(playerid, p_ccinc, kidnappedid, k_ccinc);
public SetKidnappingWantedLevel(playerid, p_ccinc, kidnappedid, k_ccinc)
{
	tmrKidnappingWL[playerid] = 0;

	if (!checkcinc(playerid, p_ccinc) || !checkcinc(kidnappedid, k_ccinc))
	{
		return 1;
	}
	else
	{
		if (IsPlayerRopeTied(kidnappedid) && !IsPlayerControllable_OW(kidnappedid) && IsPlayerNearPlayer(playerid, kidnappedid, 50.0))
		{
			// Igrac je i dalje zavrzan nakon 5 minuta
			AddPlayerCrime(playerid, INVALID_PLAYER_ID, 5, "Otmica", "Automatska prijava");
		}   
	}
	return 1;
}

stock ShowSafeTextDraw(playerid)
{
	if (!GetPVarInt(playerid, "pUsingSafe"))
	{
		ptdFactionSafe_Create(playerid);
	}

	new f_id = PI[playerid][p_org_id];
	ptdFactionSafe_Setup(playerid, FACTIONS[f_id][f_naziv], HexToInt(FACTIONS[f_id][f_hex]), FACTIONS[f_id][f_budzet], FACTIONS[f_id][f_materijali], FACTIONS[f_id][f_materijali_skladiste], FACTIONS[f_id][f_heroin], FACTIONS[f_id][f_mdma], FACTIONS[f_id][f_weed]);
	TogglePlayerControllable_H(playerid, false);
	SetPVarInt(playerid, "pUsingSafe", 1);
	DeletePVar(playerid, "fDrugs_TakePut");
	return 1;
}

stock MAFIA_ShowGunshopDialog(playerid)
{
	if (DebugFunctions())
	{
		LogFunctionExec("MAFIA_ShowGunshopDialog");
	}

	SPD(playerid, "MAFIA_oruzarnica", DIALOG_STYLE_LIST, "Oruzarnica", "Napravi oruzje\nObradi materijale", "Izaberi", "Izadji");
	return 1;
}

Dialog:MAFIA_oruzarnica(playerid, response, listitem, const inputtext[])
{
	if (response && IsACriminal(playerid))
	{
		if (listitem == 0) // Napravi oruzje
		{
			if (PI[playerid][p_org_rank] == 1)
				return ErrorMsg(playerid, "Potreban ti je rank 2 za uzimanje oruzja sa ovog mesta.");

			if (gGunshopUsed{playerid} >= 2)
				return ErrorMsg(playerid, "Previse si kupio, ostavi nesto i za druge!");

			for__loop (new i = 0; i < sizeof tdMakeGun; i++)
			{
				TextDrawShowForPlayer(playerid, tdMakeGun[i]);
			}

			SetPVarInt(playerid, "fMakeGun", 1);
			SelectTextDraw(playerid, 0xF2E4AEFF);
		}

		else if (listitem == 1) // Obradi materijale
		{
			if (!BP_PlayerItemGetCount(playerid, ITEM_RAW_MATS))
			return ErrorMsg(playerid, "Nemate neobradjene materijale u rancu. Kupite ih na crnom trzistu.");

			if ((BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) + MATS_PACKAGE_COUNT) > BP_GetItemCountLimit(ITEM_MATERIALS))
				return ErrorMsg(playerid, "Imate previse obradjenih materijala u rancu. Potrosite neke pre nego sto obradite novi paket!");

			SetPVarInt(playerid, "pUsingMafiaGS", 1);            
			StartCenterProgress(playerid, "Obrada materijala...", 50*1000);

			// diler_oruzja.pwn
		}
	}
	return 1;
}

stock FactionMsg(f_id, const fmat[], {Float, _}:...)
{
	new
		str[145];
	va_format(str, sizeof str, fmat, va_start<2>);
	format(str, sizeof str, "(%s) %s", FACTIONS[f_id][f_tag], str, va_start<2>);
	foreach (new playerid : Player) 
	{
		if (PI[playerid][p_org_id] == f_id)
			SendClientMessage(playerid, HexToInt(FACTIONS[f_id][f_hex]), str);
	}

	return 1;
}

stock DepartmentMsg(boja, const fmat[], {Float, _}:...)
{
	new
		str[145];
	va_format(str, sizeof str, fmat, va_start<2>);

	foreach (new playerid : Player) 
	{
		if (PI[playerid][p_org_id] != -1 && FACTIONS[PI[playerid][p_org_id]][f_vrsta] == FACTION_LAW)
			SendClientMessage(playerid, boja, str);
	}
	
	return 1;
}

stock IsLeader(playerid)
{
	if (PI[playerid][p_org_id] != -1 && PI[playerid][p_org_rank] == RANK_LEADER)
		return true;

	else return false;
}

stock IsACriminal(playerid) 
{
	if (!IsPlayerConnected(playerid)) return 0;

	new f_id = PI[playerid][p_org_id];
	
	if (f_id == -1) return 0;
	if (FACTIONS[f_id][f_vrsta] == FACTION_MAFIA) return 1;
	if (FACTIONS[f_id][f_vrsta] == FACTION_GANG)  return 1;
	if (FACTIONS[f_id][f_vrsta] == FACTION_RACERS) return 1;

	return 0;
}

stock IsAMobster(playerid) 
{
	if (!IsPlayerConnected(playerid)) return 0;

	new f_id = PI[playerid][p_org_id];
	
	if (f_id == -1) return 0;
	if (FACTIONS[f_id][f_vrsta] == FACTION_MAFIA) return 1;

	return 0;
}

stock IsAGangster(playerid) 
{
	if (!IsPlayerConnected(playerid)) return 0;

	new f_id = PI[playerid][p_org_id];
	
	if (f_id == -1) return 0;
	if (FACTIONS[f_id][f_vrsta] == FACTION_GANG)  return 1;

	return 0;
}

stock IsARacer(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;

	new f_id = PI[playerid][p_org_id];
	
	if (f_id == -1) return 0;
	if (FACTIONS[f_id][f_vrsta] == FACTION_RACERS)  return 1;

	return 0;
}

stock IsACop(playerid) 
{
	if (!IsPlayerConnected(playerid)) return 0;

	new f_id = PI[playerid][p_org_id];

	if (f_id == -1) return 0;
	if (FACTIONS[f_id][f_vrsta] == FACTION_LAW) return 1;

	return 0;
}

stock IsFactionVehicle(vehicleid, f_id = -1) 
{
	// Ako je f_id = -1, onda se proverava da li vozilo pripada
	// BILO KOJOJ grupi, a ako je dat f_id, onda se proverava da li
	// vozilo pripada toj navedenoj organizaciji.

	if (vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID)
		return 0;


	if (f_id == -1)
	{
		if (Iter_Contains(faction_vehicles, vehicleid)) return 1;
		else return 0;
	}
	else
	{
		for__loop (new i = 0; i < FACTIONS[f_id][f_max_vozila]; i++) 
		{
			if (F_VEHICLES[f_id][i][fv_vehicle_id] == vehicleid)
				return 1;
		}
		return 0;
	}
}

stock IsLawVehicle(vehicleid)
{
	if (vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID)
		return 0;


	if (!Iter_Contains(faction_vehicles, vehicleid)) return 0;

	for__loop (new f_id = 0; f_id < MAX_FACTIONS; f_id ++)
	{
		if (FACTIONS[f_id][f_loaded] == -1) continue;
		if (FACTIONS[f_id][f_vrsta] != FACTION_LAW) continue;

		for__loop (new slot = 0; slot < FACTIONS[f_id][f_max_vozila]; slot ++)
		{
			if (F_VEHICLES[f_id][slot][fv_vehicle_id] == vehicleid)
				return 1;
		}
	}
	return 0;

}

stock faction_name(f_id, name_type)
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "faction_name");
	#endif
		
	new string[13];
	if (f_id < 0 || f_id > MAX_FACTIONS)
		string = "[greska]";
	
	else 
	{
		switch (FACTIONS[f_id][f_vrsta]) 
		{
			case FACTION_MAFIA, FACTION_RACERS: 
			{
				switch (name_type) 
				{
					case FNAME_AKUZATIV: string = "mafiju";
					case FNAME_DATIV:    string = "mafiji";
					case FNAME_GENITIV:  string = "mafije";
					case FNAME_CAPITAL:  string = "Mafija";
					case FNAME_UPPER:    string = "MAFIJA";
					case FNAME_LOWER:    string = "mafija";
					default:             string = "[greska]";
				}
			}
			case FACTION_GANG: 
			{
				switch (name_type) 
				{
					case FNAME_AKUZATIV: string = "bandu";
					case FNAME_DATIV:    string = "bandi";
					case FNAME_GENITIV:  string = "bande";
					case FNAME_CAPITAL:  string = "Banda";
					case FNAME_UPPER:    string = "BANDA";
					case FNAME_LOWER:    string = "banda";
					default:             string = "[greska]";
				}
			}
			case FACTION_LAW, FACTION_MD: 
			{
				switch (name_type) 
				{
					case FNAME_AKUZATIV: string = "organizaciju";
					case FNAME_DATIV:    string = "organizaciji";
					case FNAME_GENITIV:  string = "organizacije";
					case FNAME_CAPITAL:  string = "Organizacija";
					case FNAME_UPPER:    string = "ORGANIZACIJA";
					case FNAME_LOWER:    string = "organizacija";
					default:             string = "[greska]";
				}
			}
			default: string = "[greska]";
		}
	}

	return string;
}

public check_faction(playerid, type)
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "check_faction");
	#endif
		
	if (!IsPlayerConnected(playerid))
		return 1;
		
	if (PI[playerid][p_org_id] == -1)
		return false;
		
	if (FACTIONS[PI[playerid][p_org_id]][f_vrsta] != type)
		return false;
		
	return true;
}

public f_d_re_reket(playerid, response, listitem, const inputtext[])
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "f_d_re_reket");
	#endif
		
	/* 
	  Ova funkcija sluzi kao dialog "re_reket", ali se ne nalazi u modulu "real_estate", gde bi inace trebalo da bude, jer onda ne bi moglo da
	  ... se pristupi nekim varijablama i definicijama koje su deo ovog modula.
	*/
	
	if (uredjuje[playerid][UREDJUJE_VRSTA] == -1) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (01)");
		
	if (!response) 
		return dialog_respond:nekretnine(playerid, 1, uredjuje[playerid][UREDJUJE_LISTITEM], "");
		
	if (isnull(inputtext) || strlen(inputtext) < 2 || strlen(inputtext) > MAX_FTAG_LENGTH)
		return DialogReopen(playerid);

	new vrsta = uredjuje[playerid][UREDJUJE_VRSTA],
		lid   = pRealEstate[playerid][vrsta];
	
	if (vrsta != firma)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (02)");

	if (pRealEstate[playerid][firma] == -1)
		return ErrorMsg(playerid, "Ne posedujete firmu.");

	
	// Da li je unet ispravan tag?
	new f_id = -1;

	if (!strcmp(inputtext, "Niko", true))
	{
		if (BizInfo[lid][BIZ_REKET] == -1)
			return ErrorMsg(playerid, "Niko ne reketira Vasu firmu.");
	
		// Slanje poruke igracu
		SendClientMessage(playerid, SVETLOPLAVA, "* Vise nikome ne dajete reket.");
	}
	else
	{
		for__loop (new i = 0; i < MAX_FACTIONS; i++)
		{
			if (!strcmp(FACTIONS[i][f_tag], inputtext, true) && FACTIONS[i][f_vrsta] == FACTION_MAFIA)
			{
				f_id = i;
				break;
			}
		}
		if (f_id == -1)
		{
			ErrorMsg(playerid, "Ne postoji mafija sa takvim tagom.");
			return DialogReopen(playerid);
		}
		if (BizInfo[lid][BIZ_REKET] == f_id)
		{
			ErrorMsg(playerid, "Ta mafija je vec postavljena za reket.");
			return DialogReopen(playerid);
		}
	
		// Slanje poruke igracu
		SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste mafiju %s (%s) za reket u svojoj firmi.", FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_tag]);
	}
	
	
	BizInfo[lid][BIZ_REKET] = f_id;
	
	// Update podataka u bazi
	new sQuery[47];
	format(sQuery, sizeof sQuery, "UPDATE re_firme SET reket = %d WHERE id = %d", f_id, lid);
	mysql_tquery(SQL, sQuery);
	
	return 1;
}

public f_prijavi_igraca(playerid) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("f_prijavi_igraca");
	}

	new
		f_id = PI[playerid][p_org_id];

	if (f_id != -1) 
	{
		if (f_id < 0 || f_id >= MAX_FACTIONS) // ID ima negativnu vrednost ili prelazi velicinu array-a (array out of bounds)
		{
			overwatch_poruka(playerid, "Izgleda da ste clan organizacije/mafije/bande koja ne postoji.");
			
			// Resetovanje promenljivih
			PI[playerid][p_org_id]    = -1;
			PI[playerid][p_org_rank]  = -1;
			PI[playerid][p_org_vreme] = 0;
			PI[playerid][p_org_kazna] = 0;
			
			// Update podataka u bazi
			new sQuery[94];
			format(sQuery, sizeof sQuery, "UPDATE igraci SET org_id = -1, org_vreme = 0, org_kazna = FROM_UNIXTIME(0) WHERE id = %d", PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, "i", THREAD_PLAYERUPDATE);
			
			// Upisivanje u log
			new sLog[69];
			format(sLog, sizeof sLog, "Igrac: %s | Nepostojeca organizacija (%d)", ime_obicno[playerid], f_id);
			Log_Write(LOG_FACTIONS_LOGIN, sLog);
			return 1;
		}
		
		
		// Provera da li je ogranizacija ucitana
		if (FACTIONS[f_id][f_loaded] == -1) 
		{
			overwatch_poruka(playerid, "Organizacija/mafija/banda ciji ste clan nije ucitana.");
			
			// Resetovanje promenljivih (ovo se ne belezi u bazu, i nakon reloga se vraca na stare vrednosti)
			PI[playerid][p_org_id]    = -1;
			PI[playerid][p_org_rank]  = -1;
			PI[playerid][p_org_vreme] =  0;
			PI[playerid][p_org_kazna] =  0;
			
			// Upisivanje u log
			new sLog[68];
			format(sLog, sizeof sLog, "Igrac: %s | Organizacija nije ucitana (%d)", ime_obicno[playerid], f_id);
			Log_Write(LOG_FACTIONS_LOGIN, sLog);
			return 1;
		}
		
		
		// ----------------------------------------------------------------------------------------
		// Proveravamo da li je igrac clan organizacije koja mu je upisana u nalogu
		new sQuery[78];
		format(sQuery, sizeof sQuery, "SELECT * FROM factions_members WHERE faction_id = %i AND player_id = %i", PI[playerid][p_org_id], PI[playerid][p_id]);
		new Cache:result = mysql_query(SQL, sQuery, true);
		// cache_save();

		if (cache_is_valid(result))
		{
			cache_get_row_count(rows);

			if (rows != 1) // Igrac izbacen
			{
				SendClientMessageF(playerid, TAMNOCRVENA2, "* Izbaceni ste iz %s ciji ste bili clan.", faction_name(FACTIONS[f_id][f_vrsta], FNAME_GENITIV));

				/*if(strlen(PI[playerid][p_discord_id]) > 5) 
				{
					if(PI[playerid][p_org_id] == 0) { removePlayerDiscRole(PI[playerid][p_discord_id], "lspd"); }
					else if(PI[playerid][p_org_id] == 1) { removePlayerDiscRole(PI[playerid][p_discord_id], "lcn");}
					else if(PI[playerid][p_org_id] == 2) { removePlayerDiscRole(PI[playerid][p_discord_id], "sb");}
					else if(PI[playerid][p_org_id] == 3) { removePlayerDiscRole(PI[playerid][p_discord_id], "gsf");}
				}*/
				
				// Update promenljivih
				PI[playerid][p_org_id]    = -1;
				PI[playerid][p_org_rank]  = -1;
				PI[playerid][p_org_vreme] =  0;
				PI[playerid][p_skill_cop] = 0;
				PI[playerid][p_skill_criminal] = 0;
				if (PI[playerid][p_skin] == -1)
				{
					PI[playerid][p_skin] = GetRandomCivilianSkin(PI[playerid][p_pol]);
					SetPlayerSkin(playerid, PI[playerid][p_skin]);
				}

				// Update podataka u bazi
				new sQuery_1[110];
				format(sQuery_1, sizeof sQuery_1, "UPDATE igraci SET org_id = -1, org_rank = -1, org_vreme = 0, skin = %i, skill_criminal = 0, skill_cop = 0 WHERE id = %i", PI[playerid][p_skin], PI[playerid][p_id]);
				mysql_tquery(SQL, sQuery_1);

				dialog_respond:spawn(playerid, 1, 0, ""); // Postavlja spawn na default
			}
			else // Sve u redu
			{
				f_ts_initial[playerid] = gettime();

				// Da li je igrac lider?
				if (!strcmp(F_LEADERS[f_id][0], ime_obicno[playerid]) || !strcmp(F_LEADERS[f_id][1], ime_obicno[playerid]))
				{
					PI[playerid][p_org_rank] = RANK_LEADER;
				}
				else
				{
					// Odredjivanje ranka na osnovu skilla (ako igrac nije lider)
					PI[playerid][p_org_rank] = GetPlayerFactionRank(FACTIONS[f_id][f_vrsta], 65535, playerid);
				}

				
				// Da li ima dozvolu da se spawnuje u bazi?
				if (PI[playerid][p_spawn_x] == FACTIONS[f_id][f_x_spawn] && PI[playerid][p_spawn_y] == FACTIONS[f_id][f_y_spawn])
				{
					if ((F_RANKS[f_id][PI[playerid][p_org_rank]][fr_dozvole] & DOZVOLA_SPAWN) == 0)
						dialog_respond:spawn(playerid, 1, 0, ""); // Postavlja spawn na default jer mu je ranije bio u bazi, ali vise nema tu dozvolu
				}

				// Postavljanje u odgovarajucu diviziju
				SetPlayerDivision(playerid, PI[playerid][p_division_points], true);
			}

			cache_delete(result);
		}
		else return ErrorMsg(playerid, "Ucitavanje podataka o tvojoj organizaciji nije uspelo.");
	}
	return 1;
}

GetPlayerFactionRank(factionType, skill, playerid = INVALID_PLAYER_ID)
{
	new rank = 1;

	if (factionType == FACTION_LAW) 
	{
		if (!IsPlayerConnected(playerid))
		{
			rank = floatround(skill/100.0, floatround_ceil);
		}
		else
		{
			if (PI[playerid][p_skill_cop] <= 0) PI[playerid][p_skill_cop] = 1;
			rank = floatround(PI[playerid][p_skill_cop]/100.0, floatround_ceil);
		}
	}
	else
	{
		if (!IsPlayerConnected(playerid))
		{
			rank = floatround(skill/120.0, floatround_ceil);
		}
		else
		{
			if (PI[playerid][p_skill_criminal] <= 0) PI[playerid][p_skill_criminal] = 1;
			rank = floatround(PI[playerid][p_skill_criminal]/120.0, floatround_ceil);
		}
	}

	if (rank > 6) rank = 6;
	if (skill <= 0) rank = 1;


	return rank;
}

stock GetFactionSkin(f_id, r_id)
{
	if(f_id == -1)
		return 28;
	
	return F_RANKS[f_id][r_id][fr_skin];
}

stock GetFactionMemberCount(f_id) 
{ 
	return FACTIONS[f_id][f_clanovi];
}

stock GetFactionLeaderCount(f_id) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("GetFactionLeaderCount");
	}
	
	new count = 0;

	if (strcmp(F_LEADERS[f_id][0], "Niko")) 
		count ++;
		
	if (strcmp(F_LEADERS[f_id][1], "Niko"))
		count ++;

	return count;
}
	
stock GetFactionVehicleCount(f_id) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("GetFactionVehicleCount");
	}

	new count = 0;
	for__loop (new i = 0; i < FACTIONS[f_id][f_max_vozila]; i++) {
		if (F_VEHICLES[f_id][i][fv_vehicle_id] != -1)
			count ++;
	}
	return count;
}

stock GetPlayerFactionID(playerid) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("GetPlayerFactionID");
	}

		
	if (!IsPlayerConnected(playerid)) return -1;
	return PI[playerid][p_org_id];
}

stock GetFactionName(faction, str[], len = sizeof str) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionName");
	#endif
		
	if (faction < 0 || faction >= MAX_FACTIONS)
		format(str, len, "N/A");
	else
		format(str, len, "%s", FACTIONS[faction][f_naziv]);

	return 1;
}

stock GetFactionTag(faction, str[], len = sizeof str) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionTag");
	#endif
		
	if (faction < 0 || faction >= MAX_FACTIONS || FACTIONS[faction][f_loaded] == -1)
		format(str, len, "N/A");
	else
		format(str, len, "%s", FACTIONS[faction][f_tag]);

	return 1;
}

stock GetMaxFactions()
{
	return MAX_FACTIONS;
}

stock GetFactionRGB(faction, str[], len = sizeof str) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionRGB");
	#endif
		
	if (faction < 0 || faction >= MAX_FACTIONS)
		format(str, len, "N/A");
	else
		format(str, len, "%s", FACTIONS[faction][f_rgb]);

	return 1;
}

stock GetFactionType(faction) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionType");
	#endif
		
	return FACTIONS[faction][f_vrsta];
}

stock GetPlayerRankName(playerid, str[], len = sizeof str) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetPlayerRankName");
	#endif
		
	if (!IsPlayerConnected(playerid)) return 0;

	new faction = PI[playerid][p_org_id];
	if (faction < 0 || faction >= MAX_FACTIONS || PI[playerid][p_org_rank] < 0 || PI[playerid][p_org_rank] > RANK_LEADER)
		format(str, len, "N/A");
	else {
		format(str, len, "%s", F_RANKS[faction][PI[playerid][p_org_rank]][fr_ime]);
	}

	return 1;
}

stock GetFactionVehicleLimit(faction) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionVehicleLimit");
	#endif
		
	return FACTIONS[faction][f_max_vozila];
}

stock GetFactionMembereLimit(faction) 
{
	#if defined DEBUG_FUNCTIONS
		Debug("function", "GetFactionVehicleLimit");
	#endif
		
	return FACTIONS[faction][f_max_clanova];
}

stock FactionMoneyAdd(f_id, amount) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("FactionMoneyAdd");
	}

	if (amount < 0 || amount > 99999999 || f_id == -1) return 1;

	FACTIONS[f_id][f_budzet] += amount;

	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	return 1;
}

stock FactionMoneySub(f_id, amount) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("FactionMoneySub");
	}

		
	if (amount < 0 || amount > 99999999 || f_id == -1) return 1;

	FACTIONS[f_id][f_budzet] -= amount;

	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	return 1;
}

stock FactionMatsAdd(f_id, amount) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("FactionMatsAdd");
	}

	if (amount < 0 || amount > 99999999 || f_id == -1) return 1;

	FACTIONS[f_id][f_materijali_skladiste] += amount;

	new sQuery[80];
	format(sQuery, sizeof sQuery, "UPDATE factions SET materijali_skladiste = %d WHERE id = %d", FACTIONS[f_id][f_materijali_skladiste], f_id);
	mysql_tquery(SQL, sQuery);
	return 1;
}

stock FactionAmmoAdd(f_id, amount) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("FactionAmmoAdd");
	}

	if (amount < 0 || amount > 99999999 || f_id == -1) return 1;

	FACTIONS[f_id][f_municija_skladiste] += amount;

	new query[128];
	format(query, sizeof query, "UPDATE factions SET municija_skladiste = %d WHERE id = %d", FACTIONS[f_id][f_municija_skladiste], f_id);
	mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	return 1;
}

stock GetFactionMoney(f_id) 
{
	return FACTIONS[f_id][f_budzet];
}

stock faction_BuyVehicle(playerid) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("faction_BuyVehicle");
	}

	new
		price   = GetPVarInt(playerid, "pAutosalonPrice"),
		modelid = GetPVarInt(playerid, "pAutosalonModel"),
		type    = GetPVarInt(playerid, "pAutosalonCat");
		
	if (PI[playerid][p_org_rank] != RANK_LEADER)
		return ErrorMsg(playerid, "[factions.pwn] "GRESKA_NEPOZNATO" (03)");

	new f_id = GetPlayerFactionID(playerid);

	if (GetFactionVehicleCount(f_id) == GetFactionVehicleLimit(f_id))
	{
		ErrorMsg(playerid, "Dostigli ste dozvoljeni limit za kupovinu vozila.");
		SetCameraBehindPlayer(playerid);
		CancelSelectTextDraw(playerid);
	}

	if (GetFactionMoney(f_id) < price)
	{
		ErrorMsg(playerid, "Nemate dovoljno novca u kasi da biste kupili ovo vozilo.");
		SetCameraBehindPlayer(playerid);
		CancelSelectTextDraw(playerid);
	}

	new slot = -1, rand, vehicleid;

	for__loop (new i = 0; i < GetFactionVehicleLimit(f_id); i++) 
	{
		if (F_VEHICLES[f_id][i][fv_vehicle_id] == -1) 
		{
			slot = i;
			break;
		}
	}
	if (slot == -1 || slot >= MAX_FACTIONS_VEHICLES)
		return ErrorMsg(playerid, "[factions.pwn] "GRESKA_NEPOZNATO" (04)");


	switch (type) 
	{
		case brod: 
		{
			rand = random(sizeof(brodovi_pozicije));
			
			F_VEHICLES[f_id][slot][fv_x_spawn] = brodovi_pozicije[rand][POS_X];
			F_VEHICLES[f_id][slot][fv_y_spawn] = brodovi_pozicije[rand][POS_Y];
			F_VEHICLES[f_id][slot][fv_z_spawn] = brodovi_pozicije[rand][POS_Z];
			F_VEHICLES[f_id][slot][fv_a_spawn] = brodovi_pozicije[rand][POS_A];
		}
		case helikopter: 
		{
			rand = random(sizeof(helikopteri_pozicije));
			
			F_VEHICLES[f_id][slot][fv_x_spawn] = helikopteri_pozicije[rand][POS_X];
			F_VEHICLES[f_id][slot][fv_y_spawn] = helikopteri_pozicije[rand][POS_Y];
			F_VEHICLES[f_id][slot][fv_z_spawn] = helikopteri_pozicije[rand][POS_Z];
			F_VEHICLES[f_id][slot][fv_a_spawn] = helikopteri_pozicije[rand][POS_A];
		}
		case bicikl, motor: 
		{
			rand = random(sizeof(bike_pozicije));
			
			F_VEHICLES[f_id][slot][fv_x_spawn] = bike_pozicije[rand][POS_X];
			F_VEHICLES[f_id][slot][fv_y_spawn] = bike_pozicije[rand][POS_Y];
			F_VEHICLES[f_id][slot][fv_z_spawn] = bike_pozicije[rand][POS_Z];
			F_VEHICLES[f_id][slot][fv_a_spawn] = bike_pozicije[rand][POS_A];
		}
		default: 
		{
			rand = random(sizeof(automobili_pozicije));
			
			F_VEHICLES[f_id][slot][fv_x_spawn] = automobili_pozicije[rand][POS_X];
			F_VEHICLES[f_id][slot][fv_y_spawn] = automobili_pozicije[rand][POS_Y];
			F_VEHICLES[f_id][slot][fv_z_spawn] = automobili_pozicije[rand][POS_Z];
			F_VEHICLES[f_id][slot][fv_a_spawn] = automobili_pozicije[rand][POS_A];
		}
	}

	vehicleid = CreateVehicle(modelid, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], 1000);
	Iter_Add(faction_vehicles, vehicleid);

	new sLabel[36];
	format(sLabel, sizeof sLabel, "[ %s ]", FACTIONS[f_id][f_tag]);
	F_VEHICLES[f_id][slot][fv_label] = CreateDynamic3DTextLabel(sLabel, HexToInt(FACTIONS[f_id][f_hex]), 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, vehicleid);


	if (!IsVehicleHelicopter(vehicleid) && !IsVehicleBoat(vehicleid) && !IsVehicleBicycle(vehicleid)) {
		// Vozilo je automobil ili motor
		new tablica[32];
		format(tablica, sizeof(tablica), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);
		SetVehicleNumberPlate(vehicleid, tablica);
		SetVehicleToRespawn(vehicleid);
	}


	// Belezenje podataka, oduzimanje novca
	FactionMoneySub(f_id, price);
	F_VEHICLES[f_id][slot][fv_model_id]     = modelid;
	F_VEHICLES[f_id][slot][fv_cena]         = price;
	F_VEHICLES[f_id][slot][fv_vehicle_id]   = vehicleid;
	F_VEHICLES[f_id][slot][fv_prodaja]      = 1;


	// Poruka
	FactionMsg(f_id, "{FFFFFF}%s je kupio novo vozilo: {%s}%s.", ime_rp[playerid], FACTIONS[f_id][f_rgb], imena_vozila[modelid-400]);


	// Upisivanje podataka u bazu
	format(mysql_upit, 160, "INSERT INTO factions_vehicles (faction_id, model_id, cena, spawn) VALUES (%d, %d, %d, '%.4f|%.4f|%.4f|%.4f')", f_id, modelid, price, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn]);
	mysql_tquery(SQL, mysql_upit, "mysql_factions_vehInsert", "iii", f_id, slot, vehicleid);

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | KUPOVINA | %s | %s [$%d]", FACTIONS[f_id][f_tag], ime_obicno[playerid], imena_vozila[modelid-400], price);
	Log_Write(LOG_FACTIONS_BUYSELLVEH, string_128);

	// Upisivanje u log 2 - mysql
	format(mysql_upit, 145, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je kupio novo vozilo: %s.')", f_id, ime_obicno[playerid], imena_vozila[modelid-400]);
	mysql_pquery(SQL, mysql_upit);

	// Resetovanje
	SetCameraBehindPlayer(playerid);
	SetGPSLocation(playerid, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], "lokacija vozila");

	// Sakrivanje svih TD-ova vezano za kupovinu vozila
	katalog_Cancel(playerid);
	return 1;
}

public factions_ToggleGateRamp(f_id, i, start_timer) 
{
	if (IsDynamicObjectMoving(F_GATES[f_id][i][fg_obj_id])) 
	{
		StopDynamicObject(F_GATES[f_id][i][fg_obj_id]);
		KillTimer(F_GATES[f_id][i][fg_timer]), F_GATES[f_id][i][fg_timer] = 0;
		// return 1;
	}

	// if (start_timer == 0 && F_GATES[f_id][i][fg_timer] != 0)
	//     return 1;

	switch (F_GATES[f_id][i][fg_vrsta]) 
	{
		case GATE: 
		{
			if (F_GATES[f_id][i][fg_status] == GATE_OPEN) 
			{
				MoveDynamicObject(F_GATES[f_id][i][fg_obj_id], F_GATES[f_id][i][fg_closed_x], F_GATES[f_id][i][fg_closed_y], F_GATES[f_id][i][fg_closed_z], 2.75);
			}
			else if (F_GATES[f_id][i][fg_status] == GATE_CLOSED) 
			{
				MoveDynamicObject(F_GATES[f_id][i][fg_obj_id], F_GATES[f_id][i][fg_open_x], F_GATES[f_id][i][fg_open_y], F_GATES[f_id][i][fg_open_z], 2.75);
			}
		}

		case RAMP: 
		{
			new Float:pos[3];
			GetDynamicObjectPos(F_GATES[f_id][i][fg_obj_id], pos[0], pos[1], pos[2]);

			if (F_GATES[f_id][i][fg_status] == GATE_OPEN) 
			{
				MoveDynamicObject(F_GATES[f_id][i][fg_obj_id], pos[0], pos[1], pos[2]-0.001, 0.001, F_GATES[f_id][i][fg_closed_x], F_GATES[f_id][i][fg_closed_y], F_GATES[f_id][i][fg_closed_z]);
			}
			else if (F_GATES[f_id][i][fg_status] == GATE_CLOSED) 
			{
				MoveDynamicObject(F_GATES[f_id][i][fg_obj_id], pos[0], pos[1], pos[2]+0.001, 0.001, F_GATES[f_id][i][fg_open_x], F_GATES[f_id][i][fg_open_y], F_GATES[f_id][i][fg_open_z]);
			}
		}

		default: return 1;
	}

	F_GATES[f_id][i][fg_status] = (F_GATES[f_id][i][fg_status]==true)? false : true;
	
	if (start_timer == 1)
		F_GATES[f_id][i][fg_timer]  = SetTimerEx("factions_ToggleGateRamp", 10*1000, false, "iii", f_id, i, 0);
	else F_GATES[f_id][i][fg_timer] = 0;

	return 1;
}

stock fv_ResetWeapons(f_id, vehSlot) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("fv_ResetWeapons");
	}

		
	for__loop (new i = 0; i < 13; i++) 
	{
		F_VEH_WEAPONS[f_id][vehSlot][i][fv_weapon]  = -1;
		F_VEH_WEAPONS[f_id][vehSlot][i][fv_ammo]    = 0;
	}
	return 1;
}

forward factions_RespawnVehicles(f_id);
public factions_RespawnVehicles(f_id)
{
	if (DebugFunctions())
	{
		LogFunctionExec("factions_RespawnVehicles");
	}

	if (FACTIONS[f_id][f_respawnCooldown] > gettime()) return 1;

	new bool:isOccupied[MAX_FACTIONS_VEHICLES] = {false, false, ...};
	foreach (new i : Player)
	{
		if (IsPlayerInAnyVehicle(i))
		{
			for__loop (new j = 0; j < FACTIONS[f_id][f_max_vozila]; j++) 
			{
				if (F_VEHICLES[f_id][j][fv_vehicle_id] == -1) continue;

				if (GetPlayerVehicleID(i) == F_VEHICLES[f_id][j][fv_vehicle_id])
				{
					isOccupied[j] = true;
				}    
			}
		}
	}

	for__loop (new i = 0; i < FACTIONS[f_id][f_max_vozila]; i++) 
	{
		if (F_VEHICLES[f_id][i][fv_vehicle_id] != -1 && !isOccupied[i])
		{
			SetVehicleToRespawn(F_VEHICLES[f_id][i][fv_vehicle_id]);
			
			LinkVehicleToInterior(F_VEHICLES[f_id][i][fv_vehicle_id], 0);
		}
	}

	FactionMsg(f_id, "{FFFFFF}Sva slobodna vozila su respawnovana.");
	FACTIONS[f_id][f_respawnCooldown] = gettime() + 15*60;
	return 1;
}

stock IsPlayerRopeTied(playerid)
{
	return gPlayerRopeTied{playerid};
}

stock FACTIONS_SetTurfCooldown(f_id)
{
	if (f_id >= 0 && f_id < MAX_FACTIONS)
	{
		FACTIONS[f_id][f_turfCooldown] = gettime() + 10 * 60;
	}
}

stock FACTIONS_RemoveTurfCooldown(f_id)
{
	if (f_id >= 0 && f_id < MAX_FACTIONS)
	{   
		FACTIONS[f_id][f_turfCooldown] = 0;
	}
}

stock FACTIONS_CanAttackTurf(f_id)
{
	if (FACTIONS[f_id][f_turfCooldown] > gettime())
		return false;
	else
		return true;
}

stock FACTIONS_CooldownTimeLeft(f_id)
{
	if (FACTIONS[f_id][f_turfCooldown] > gettime())
		return (FACTIONS[f_id][f_turfCooldown] - gettime());
	else 
		return 0;
}

IsPlayerInFactionBase(playerid, f_id)
{
	if (f_id == -1) return 0;

	return IsPlayerInDynamicArea(playerid, FACTIONS[f_id][f_areaid]);
}

GetFactionAreaID(f_id)
{
	if (f_id == -1) return -1;

	return FACTIONS[f_id][f_areaid];
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_factions_vehInsert(f_id, slot, vehicleid);
forward mysql_factions_logs(f_id, playerid, ccinc);

stock IsFactionLoaded(fid)
{
	if(FACTIONS[fid][f_loaded] != -1)
		return 1;

	return 0;
}

forward mysql_factions(threadid, f_id);
public mysql_factions(threadid, f_id)
{
	cache_get_row_count(rows);
	
	switch (threadid)
	{
		case THREAD_FACTION_CONFIG:
		{
			if (!rows) return print("[mysql warning] Ne mogu da pronadjem nijednu organizaciju u bazi.");
			
			new
				ulaz[42],
				spawn[64],
				sDrugs[21]
			;
			
			for__loop (new i = 0; i < rows; i++)
			{
				cache_get_value_index_int(i, 0, f_id);
				
				if (f_id < 0 || f_id >= MAX_FACTIONS) // ID ima negativnu vrednost ili prelazi velicinu array-a
				{
					printf("[error] Ucitana organizacija ima nepravilan ID: %d", f_id);
					continue;
				}
				

				new zone[43],
					Float:zoneBounds[4];

				cache_get_value_name_int(i, "vrsta",  FACTIONS[f_id][f_vrsta]);      
				cache_get_value_name_int(i, "max_clanova",  FACTIONS[f_id][f_max_clanova]);
				cache_get_value_name_int(i, "max_vozila",  FACTIONS[f_id][f_max_vozila]);
				cache_get_value_name_int(i, "ent",  FACTIONS[f_id][f_entid]);
				cache_get_value_name_int(i, "budzet",  FACTIONS[f_id][f_budzet]);
				cache_get_value_name_int(i, "materijali", FACTIONS[f_id][f_materijali]);
				cache_get_value_name_int(i, "materijali_skladiste", FACTIONS[f_id][f_materijali_skladiste]);
				cache_get_value_name_int(i, "wars_won", FACTIONS[f_id][f_wars_won]);
				cache_get_value_name_int(i, "wars_lost", FACTIONS[f_id][f_wars_lost]);
				cache_get_value_name_int(i, "wars_draw", FACTIONS[f_id][f_wars_draw]);
				cache_get_value_name_int(i, "boja_1", FACTIONS[f_id][f_boja_1]);
				cache_get_value_name_int(i, "boja_2", FACTIONS[f_id][f_boja_2]);
				cache_get_value_name(i, "naziv", FACTIONS[f_id][f_naziv], MAX_FNAME_LENGTH);
				cache_get_value_name(i, "tag", FACTIONS[f_id][f_tag],   MAX_FTAG_LENGTH);
				cache_get_value_name(i, "hex", FACTIONS[f_id][f_hex], MAX_HEX_LENGTH);
				cache_get_value_name(i, "zone", zone, sizeof zone);
				cache_get_value_name(i, "droga",  sDrugs, sizeof sDrugs);
				cache_get_value_name(i, "spawn", spawn);
				cache_get_value_name(i, "ulaz", ulaz);
				
				strmid(FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_hex], 2, 8, 7);
				
				sscanf(ulaz, "p<|>ffff", FACTIONS[f_id][f_x_ulaz], FACTIONS[f_id][f_y_ulaz], FACTIONS[f_id][f_z_ulaz], FACTIONS[f_id][f_a_ulaz]);
				sscanf(spawn, "p<|>ffffii", FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn], FACTIONS[f_id][f_a_spawn], FACTIONS[f_id][f_ent_spawn], FACTIONS[f_id][f_vw_spawn]);
				sscanf(zone, "p<,>ffff", zoneBounds[0], zoneBounds[1], zoneBounds[2], zoneBounds[3]);
				sscanf(sDrugs, "p<|>iii", FACTIONS[f_id][f_heroin], FACTIONS[f_id][f_mdma], FACTIONS[f_id][f_weed]);

				FACTIONS[f_id][f_areaid] = CreateDynamicRectangle(zoneBounds[0], zoneBounds[1], zoneBounds[2], zoneBounds[3]);
				
				if (FACTIONS[f_id][f_entid] != -1) 
				{
					FACTIONS[f_id][f_x_izlaz]   = faction_interiors[FACTIONS[f_id][f_entid]][POS_X];
					FACTIONS[f_id][f_y_izlaz]   = faction_interiors[FACTIONS[f_id][f_entid]][POS_Y];
					FACTIONS[f_id][f_z_izlaz]   = faction_interiors[FACTIONS[f_id][f_entid]][POS_Z];
					FACTIONS[f_id][f_a_izlaz]   = faction_interiors[FACTIONS[f_id][f_entid]][POS_A];
					FACTIONS[f_id][f_ent]       = floatround(faction_interiors[FACTIONS[f_id][f_entid]][4]);
					FACTIONS[f_id][f_vw]        = (10000+f_id) * 10;

					new string[16];
					format(string, sizeof string, "%s", FACTIONS[f_id][f_tag]);

					CreateEnterExit(string, "Los Santos", FACTIONS[f_id][f_x_ulaz], FACTIONS[f_id][f_y_ulaz], FACTIONS[f_id][f_z_ulaz], FACTIONS[f_id][f_a_ulaz], FACTIONS[f_id][f_x_izlaz], FACTIONS[f_id][f_y_izlaz], FACTIONS[f_id][f_z_izlaz], FACTIONS[f_id][f_a_izlaz], FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 1314, 19134, f_id);

					// if (FACTIONS[f_id][f_entid] == 2) // Nate stari enterijer
					// {
					//     CreateEnterExit("Skladiste", string, 2316.3694, -1144.4102, 1054.3047, 0.0, 1436.6176, -2026.3828, -48.2424, 90.0, FACTIONS[f_id][f_ent], FACTIONS[f_id][f_ent], FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134, f_id);

					//     CreateEnterExit("Tajna soba", "Skladiste", 1391.3152, -2042.1559, -46.2484, 270.0, 1357.7509, -2057.1450, -46.4862, 270.0, FACTIONS[f_id][f_ent], FACTIONS[f_id][f_ent], FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134, f_id);

					//     CreateEnterExit("Oruzarnica", "Skladiste", 1417.2921, -2035.4858, -48.2424, 0.0, 316.4064, -170.2960, 999.5938, 0.0, 6, FACTIONS[f_id][f_ent], FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134, f_id);

					//     CreateEnterExit("Streljana", "Oruzarnica", 306.6252, -159.3086, 999.5938, 270.0, 305.2137, -159.2087, 999.5938, 90.0, 6, 6, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134, f_id);

					//     FACTIONS[f_id][f_sefCP]      = CreateDynamicCP(1367.9633,-2068.3994,-46.4862, 0.9, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent], -1, 6.0);
					//     FACTIONS[f_id][f_interactCP] = CreateDynamicCP(311.8759, -165.7875, 999.6010, 0.9, FACTIONS[f_id][f_vw], 6, -1, 6.0);
					// }
					if (!strcmp(FACTIONS[f_id][f_tag], "EC"))
					{
						CreateEnterExit("EC Garage 1", "Escobar Cartel", -701.6007, 965.0975, 12.1847, 90.8130, 1395.8326, -17.2343, 1000.8964, 180.0, 0, 0, 56000, 0, -1, 19134, 1);
						CreateEnterExit("EC Garage 2", "Escobar Cartel", -695.5988, 964.2677, 12.1847, 90.8130, 1395.8326, -17.2343, 1000.8964, 180.0, 0, 0, 56000, 0, -1, 19134, 1);
					}
					else if(!strcmp(FACTIONS[f_id][f_tag], "FBI"))
					{
						FACTIONS[f_id][f_sefLabel] = CreateDynamic3DTextLabel("/sef", BELA, 220.7764, 146.6213, 1002.9891, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
						FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(220.7764, 146.6213, 1002.9891, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
					}
				
					if (FACTIONS[f_id][f_entid] == 0) // PD
					{
						//CreateEnterExit("PD",           "PD helipad", 1552.9875, -1653.1044, 50.9874, 270.0, 1389.9618,0.5666,1001.0008, 180.0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 19134, 19134);
						//CreateEnterExit("PD",           "PD garaza", 1525.3370,-1677.9202,5.8906,88.3271, 1389.9618,0.5666,1001.0008,180.0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 19134, 19134);
						//CreateEnterExit("PD helipad",   "PD", 1389.9618,0.5666,1001.0008,180.0, 1564.5819,-1666.1105,28.3956,  270.0, 0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 19134, 19134);

						CreateDynamic3DTextLabel("/sef", BELA, 1374.4594,-11.5710,1001.0008, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
						FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(1374.4594,-11.5710,1001.0008, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
					}
					//else if (FACTIONS[f_id][f_entid] == 1) // FBI
					//{
					//	// CreateEnterExit("SWAT helipad",   "SWAT", 323.8263,-1502.1965,24.9219,53.2943, 316.9727,-1512.0568,76.5391,234.1727, 0, 0, 0, 0, 19134, 19134);
					//	CreateEnterExit("FBI helipad",   "FBI", 1445.8107,758.8478,10.8203,90.0, 1470.9585,757.3082,34.2276,270.0, 0, 0, 0, 0, 19134, 19134);
					//	
					//}
					else if (FACTIONS[f_id][f_entid] == 2) // Mafia generic (Rina/Kiko/Necro)
					{
						CreateEnterExit("Oruzarnica", "Mafija", 1402.1835, -16.9634, 1001.0052, 180.0, 316.4064, -170.2960, 999.5938, 0.0, 6, FACTIONS[f_id][f_ent], FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134);

						CreateEnterExit("Streljana", "Oruzarnica", 306.6252, -159.3086, 999.5938, 270.0, 305.2137, -159.2087, 999.5938, 90.0, 6, 6, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_vw], 19134, 19134);

						//FACTIONS[f_id][f_interactCP] = CreateDynamicCP(311.8759, -165.7875, 999.6010, 0.9, FACTIONS[f_id][f_vw], 6, -1, 6.0);

						CreateDynamic3DTextLabel("/sef", BELA, 1390.5217,-11.3959,1005.0685, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
						FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(1390.5217,-11.3959,1005.0685, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
					}
					else if (FACTIONS[f_id][f_entid] == 3 || FACTIONS[f_id][f_entid] == 4 || FACTIONS[f_id][f_entid] == 5 || FACTIONS[f_id][f_entid] == 6 || FACTIONS[f_id][f_entid] == 7)
					{
						if (!strcmp(FACTIONS[f_id][f_tag], "GSF"))
						{
							CreateEnterExit("GSF Lab", "Montgomery",1248.7758, 365.1618,19.5547, 333.3, -2406.4624,-2447.5037,-77.8954,180.0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 1279, 19134, f_id);
						}
						if (!strcmp(FACTIONS[f_id][f_tag], "LSB"))
						{
							CreateEnterExit("LSB Lab", "Palomino Creek",2313.541, 56.3902,26.4844, 270.0, -2406.4624,-2447.5037,-77.8954,180.0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 1279, 19134, f_id);
						}
						if (!strcmp(FACTIONS[f_id][f_tag], "MS13"))
						{
							CreateEnterExit("MS13 Lab", "Blueberry",206.9568, -112.2760,4.8965, 90.0, -2406.4624,-2447.5037,-77.8954,180.0, FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 1279, 19134, f_id);
						}

						if (FACTIONS[f_id][f_entid] == 4)
						{
							// GSF by Necro
							CreateDynamic3DTextLabel("/sef", BELA, 1351.6766,-46.6859,1000.9503, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(1351.6766,-46.6859,1000.9503, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							//FACTIONS[f_id][f_interactCP] = CreateDynamicCP(2585.4389,-1645.1367,1247.9757, 1.1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent], -1, 6.0);
						}
						else if (FACTIONS[f_id][f_entid] == 5)
						{
							// LSB by Necro
							CreateDynamic3DTextLabel("/sef", BELA, 1368.9023,-3.3023,1005.3541, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(1368.9023,-3.3023,1005.3541, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							//FACTIONS[f_id][f_interactCP] = CreateDynamicCP(1931.5609,1914.8457,903.0256, 1.1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent], -1, 6.0);
						}
						else if (FACTIONS[f_id][f_entid] == 6)
						{
							// UGR by Necro
							CreateDynamic3DTextLabel("/sef", BELA, 1395.9269,-47.3003,1000.9440, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(1395.9269,-47.3003,1000.9440, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							//FACTIONS[f_id][f_interactCP] = CreateDynamicCP(1389.0202,-23.5961,1001.1862, 1.1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent], -1, 6.0);
						}
						else
						{
							CreateDynamic3DTextLabel("/sef", BELA, -519.7402, -35.1313, -15.2933, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							FACTIONS[f_id][f_sefArea] = CreateDynamicSphere(-519.7402, -35.1313, -15.2933, 3.0, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent]);
							FACTIONS[f_id][f_interactCP] = CreateDynamicCP(-2396.7971,-2466.0906,-77.8954, 1.1, FACTIONS[f_id][f_vw], FACTIONS[f_id][f_ent], -1, 6.0);
						}
					}
				}
				
				FACTIONS[f_id][f_respawnCooldown] = gettime();
				
				
				// Provera za varijable "max_clanova" i "max_vozila": ukoliko su prevelike, moze se javiti error "Array out of bounds"
				if (FACTIONS[f_id][f_max_clanova] > MAX_FACTIONS_MEMBERS) // Preko limita
				{
					printf("[warning] Varijabla \"max_clanova\" organizacije %d je previse velika (%d), smanjujem...", FACTIONS[f_id][f_max_clanova]);
					
					FACTIONS[f_id][f_max_clanova] = MAX_FACTIONS_MEMBERS;
					
					// Update podataka u bazi
					format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET max_clanova = %d WHERE id = %d", FACTIONS[f_id][f_max_clanova], f_id);
					mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
				}
				if (FACTIONS[f_id][f_max_vozila] > MAX_FACTIONS_VEHICLES) // Preko limita
				{
					printf("[warning] Varijabla \"max_vozila\" organizacije %d je previse velika (%d), smanjujem...", FACTIONS[f_id][f_max_vozila]);
					
					FACTIONS[f_id][f_max_vozila] = MAX_FACTIONS_VEHICLES;
					
					// Update podataka u bazi
					format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET max_vozila = %d WHERE id = %d", FACTIONS[f_id][f_max_vozila], f_id);
					mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
				}
				

				FACTIONS[f_id][f_loaded]  = f_id;
				LOADED[l_factions_config] = 1;
				if (i == (rows - 1)) // poslednja iteracija
					f_loading_last_id = f_id;
				
				
				// Ucitavanje rankova
				format(mysql_upit, sizeof mysql_upit, "SELECT rank_id, ime, skin, dozvole FROM factions_ranks WHERE faction_id = %d", f_id);
				mysql_tquery(SQL, mysql_upit, "mysql_factions", "ii", THREAD_FACTION_RANKS, f_id);
				
				// Ucitavanje clanova
				// new query[352];
				// format(query, sizeof query, "SELECT i.ime, fm.player_id, fm.rank, UNIX_TIMESTAMP(kazna_limit) as kazna_ts, DATE_FORMAT(kazna_limit, '\%%d \%%b, \%%H:\%%i') as kazna_str, DATE_FORMAT(date_sub(kazna_limit,interval %d day), '\%%d \%%b, \%%H:\%%i') as join_date FROM factions_members fm INNER JOIN igraci i ON fm.player_id = i.id WHERE faction_id = %d", FACTIONS_CONTRACT_TIME/86400, f_id);
				// mysql_tquery(SQL, query, "mysql_factions", "ii", THREAD_FACTION_MEMBERS, f_id);

				new sQuery[256];
				format(sQuery, sizeof sQuery, "SELECT i.ime, fm.lider FROM factions_members fm INNER JOIN igraci i ON fm.player_id = i.id WHERE faction_id = %d", f_id);
				mysql_tquery(SQL, sQuery, "MySQL_LoadFactionMembersInfo", "i", f_id);


				// Ucitavanje kapija
				format(mysql_upit, sizeof mysql_upit, "SELECT * FROM factions_gates WHERE f_id = %d", f_id);
				mysql_tquery(SQL, mysql_upit, "mysql_factions", "ii", THREAD_FACTION_GATES, f_id);
				
				// Ucitavanje vozila
				format(mysql_upit, sizeof mysql_upit, "SELECT model_id, cena, spawn, id, prodaja FROM factions_vehicles WHERE faction_id = %d", f_id);
				mysql_tquery(SQL, mysql_upit, "mysql_factions", "ii", THREAD_FACTION_VEHICLES, f_id);
			}
		}
		case THREAD_FACTION_RANKS:
		{
			// Ovaj deo bi trebalo da bude na kraju, ali ipak nije, jer bi se onda ponavljao 5-6 puta
			if (f_id == f_loading_last_id)
				LOADED[l_factions_ranks] = 1;
					
			if (f_id < 0 || f_id >= MAX_FACTIONS || !rows) 
				return printf("[error] Nemoguce ucitati rankove za organizaciju: %d", f_id);
				
			if (FACTIONS[f_id][f_loaded] == -1)
				return printf("[error] Nemoguce ucitati rankove za organizaciju: %d (organizacija nije ucitana)", f_id);
			
			new 
				rank_id
			;
			
			// Default naziv ranka je N/A: pomaze kod formiranja spiska rankova na /org_podaci
			for__loop (new i = 0; i < MAX_FACTIONS_RANKS; i++) 
				strmid(F_RANKS[f_id][i][fr_ime], "N/A", 0, strlen("N/A"), MAX_RANK_LENGTH);
			
			for__loop (new i = 0; i < rows; i++)
			{
				cache_get_value_index_int(i, 0, rank_id);
				if (rank_id > RANK_LEADER || rank_id < 0) // Prva provera: Array out of bounds, druga provera: preko limita dozvoljenog skriptom
				{
					printf("[warning] Nevazeci rank u organizaciji %d (id: %d)", f_id, rank_id);
					return 1;
				}
				
				
				cache_get_value_index(i, 1, F_RANKS[f_id][rank_id][fr_ime], MAX_RANK_LENGTH);
				cache_get_value_index_int(i, 2, F_RANKS[f_id][rank_id][fr_skin]);
				cache_get_value_index_int(i, 3, F_RANKS[f_id][rank_id][fr_dozvole]);                
			}
		}

		case THREAD_FACTION_GATES: 
		{
			// Ovaj deo bi trebalo da bude na kraju, ali ipak nije, jer bi se onda ponavljao 5-6 puta
			if (f_id == f_loading_last_id)
			{
				LOADED[l_factions_gates] = 1;
			}

			for__loop (new i = 0; i < MAX_FACTIONS_GATES; i++) 
			{
				F_GATES[f_id][i][fg_vrsta] = -1; // ne postoji (resetovanje)
				F_GATES[f_id][i][fg_timer] = 0;
			}

			if (FACTIONS[f_id][f_loaded] == -1)
				return printf("[error] Nemoguce ucitati kapije za organizaciju: %d (organizacija nije ucitana)", f_id);

			if (rows > MAX_FACTIONS_GATES)
				printf("Pronadjeno je vise kapija nego sto je dozvoljeno za organizaciju %d", f_id);

			new 
				oc_pos[40], createpos[76], Float:pos[3], Float:rot[3];
			for__loop (new i = 0; i < rows; i++) {
				cache_get_value_index_int(i, 2, F_GATES[f_id][i][fg_vrsta]);
				cache_get_value_index_int(i, 3, F_GATES[f_id][i][fg_model]);

				cache_get_value_index(i, 4, createpos);
				sscanf(createpos, "p<,>ffffff", pos[POS_X], pos[POS_Y], pos[POS_Z], rot[POS_X], rot[POS_Y], rot[POS_Z]);

				cache_get_value_index(i, 5, oc_pos);
				sscanf(oc_pos, "p<,>fff", F_GATES[f_id][i][fg_closed_x], F_GATES[f_id][i][fg_closed_y], F_GATES[f_id][i][fg_closed_z]);

				cache_get_value_index(i, 6, oc_pos);
				sscanf(oc_pos, "p<,>fff", F_GATES[f_id][i][fg_open_x], F_GATES[f_id][i][fg_open_y], F_GATES[f_id][i][fg_open_z]);

				F_GATES[f_id][i][fg_obj_id] = CreateDynamicObjectEx(F_GATES[f_id][i][fg_model], pos[POS_X], pos[POS_Y], pos[POS_Z], rot[POS_X], rot[POS_Y], rot[POS_Z], 300.0, 300.0);

				F_GATES[f_id][i][fg_status] = GATE_CLOSED;


				// Texture za stubice
				if (F_GATES[f_id][i][fg_model] == 3498) 
				{
					SetDynamicObjectMaterial(F_GATES[f_id][i][fg_obj_id], 0, 2589, "ab_ab", "ab_sheetSteel", 0x00000000);
					SetDynamicObjectMaterial(F_GATES[f_id][i][fg_obj_id], 1, 8130, "vgsschurch", "vgschurchwall04_256", 0x00000000);
				}

				if(F_GATES[f_id][i][fg_closed_x] == -715.2463)
				{
					SetDynamicObjectMaterial(F_GATES[f_id][i][fg_obj_id], 0, 13861, "lahills_wiresnshit3", "antenna2", 0x00000000); // -715.2463,956.9332,12.6416
				}
			}
		}

		case THREAD_FACTION_VEHICLES:
		{
			// Ovaj deo bi trebalo da bude na kraju, ali ipak nije, jer bi se onda ponavljao 5-6 puta
			if (f_id == f_loading_last_id)
			{
				LOADED[l_factions_vehicles] = 1;
				SetTimer("RespawnEveryTurfNPCs", 250, false);
				foreach(new vehicleid : faction_vehicles)
					SetVehicleToRespawn(vehicleid);
				
				printf("[info] Svi podaci ucitani za: %d ms", GetTickCount()-ucitavanje_pocetak);
			}

			
			if (f_id < 0 || f_id >= MAX_FACTIONS || !rows) 
				return printf("[error] Nemoguce ucitati vozila za organizaciju: %d", f_id);
				
			if (FACTIONS[f_id][f_loaded] == -1)
				return printf("[error] Nemoguce ucitati vozila za organizaciju: %d (organizacija nije ucitana)", f_id);

			// printf("[debug] Pronadjeno %i vozila za organizaciju %s (%i)", rows, FACTIONS[f_id][f_tag], f_id);
			
			new
				spawn[64], tablica[32];
			
			format(tablica, sizeof(tablica), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);
			for__loop (new i = 0; i < rows; i++)
			{
				if (i >= MAX_FACTIONS_VEHICLES || i >= FACTIONS[f_id][f_max_vozila]) 
				{ 
					// Prva provera: Array out of bounds, druga provera: preko limita dozvoljenog skriptom
					printf("[warning] Organizacija %d ima previse vozila (%d)", f_id, i);
					return 1;
				}
					
				cache_get_value_index_int(i, 0, F_VEHICLES[f_id][i][fv_model_id]);
				cache_get_value_index_int(i, 1, F_VEHICLES[f_id][i][fv_cena]);
				cache_get_value_index_int(i, 3, F_VEHICLES[f_id][i][fv_mysql_id]);
				cache_get_value_index_int(i, 4, F_VEHICLES[f_id][i][fv_prodaja]);
				cache_get_value_index(i, 2, spawn);

				sscanf(spawn, "p<|>ffff", F_VEHICLES[f_id][i][fv_x_spawn], F_VEHICLES[f_id][i][fv_y_spawn], F_VEHICLES[f_id][i][fv_z_spawn], F_VEHICLES[f_id][i][fv_a_spawn]);
				
				if (F_VEHICLES[f_id][i][fv_model_id] < 400 || F_VEHICLES[f_id][i][fv_model_id] > 611) {
					printf("[warning] Vozilo %d organizacije %d ima nevazeci model id", i, f_id);
					continue;
				}
				
				// Kreiranje vozila
				new vehicleid = CreateVehicle(F_VEHICLES[f_id][i][fv_model_id], F_VEHICLES[f_id][i][fv_x_spawn], F_VEHICLES[f_id][i][fv_y_spawn], F_VEHICLES[f_id][i][fv_z_spawn], F_VEHICLES[f_id][i][fv_a_spawn], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], 1000);
				Iter_Add(faction_vehicles, vehicleid);
				
				if(f_id == GetFactionIDbyName("Pink Panter"))
				{
					if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1373.891723, -14.869547, 1009.618957))
						SetVehicleVirtualWorld(vehicleid, 100040);
					
					else
						SetVehicleVirtualWorld(vehicleid, 0);
				}

				else if(f_id == GetFactionIDbyName("Escobar Cartel"))
				{
					if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1395.8326, -17.2343, 1000.8964))
						SetVehicleVirtualWorld(vehicleid, 56000);
						
					else
						SetVehicleVirtualWorld(vehicleid, 0);
				}

				//new sLabel[36];
				//format(sLabel, sizeof sLabel, "[ %s ]", FACTIONS[f_id][f_tag]);
				//F_VEHICLES[f_id][i][fv_label] = CreateDynamic3DTextLabel(sLabel, HexToInt(FACTIONS[f_id][f_hex]), 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, vehicleid);

				SetVehicleNumberPlate(vehicleid, tablica);
				SetVehicleToRespawn(vehicleid);
				F_VEHICLES[f_id][i][fv_vehicle_id] = vehicleid;

				// Ucitavanje oruzja
				new sQuery[60];
				fv_ResetWeapons(f_id, i);
				format(sQuery, sizeof sQuery, "SELECT * FROM factions_vehicles_weapons WHERE v_id = %d", F_VEHICLES[f_id][i][fv_mysql_id]);
				mysql_tquery(SQL, sQuery, "MySQL_Factions_LoadVehWeapons", "ii", f_id, i);
			}
		}
	}

	return 1;
}

forward MySQL_PlayerFactionInfo(playerid, ccinc);
public MySQL_PlayerFactionInfo(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	new 
		f_id = PI[playerid][p_org_id],
		sDialog[430],
		sTitle[MAX_FNAME_LENGTH + 8],
		sJoinDate[22],
		sPenaltyDate[22]
	;

	if (f_id == -1) return 1;


	cache_get_value_name(0, "kazna_str", sPenaltyDate, sizeof sPenaltyDate);
	cache_get_value_name(0, "join_date", sJoinDate, sizeof sJoinDate);

	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	format(sDialog, sizeof sDialog, "{%s}%s (%s)\n\n{FFFFFF}Clanovi: {%s}%d/%d (%d lidera)\n{FFFFFF}Vozila: {%s}%d/%d\n{FFFFFF}Budzet: {%s}%s\n{FFFFFF}War skor: {%s}%d, %d, %d\n\n{FFFFFF}Provedeno vreme u %s: {%s}%s\n{FFFFFF}Vreme pristupa %s: {%s}%s\n{FFFFFF}Trajanje ugovora: {%s}do %s",
	FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_tag],  
	FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_clanovi], FACTIONS[f_id][f_max_clanova], GetFactionLeaderCount(f_id), 
	FACTIONS[f_id][f_rgb], GetFactionVehicleCount(f_id), FACTIONS[f_id][f_max_vozila], 
	FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]),  
	FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_wars_won], FACTIONS[f_id][f_wars_lost], FACTIONS[f_id][f_wars_draw],
	faction_name(f_id, FNAME_DATIV), FACTIONS[f_id][f_rgb], konvertuj_vreme(PI[playerid][p_org_vreme]),
	faction_name(f_id, FNAME_DATIV), FACTIONS[f_id][f_rgb], sJoinDate,
	FACTIONS[f_id][f_rgb], sPenaltyDate);

	SPD(playerid, "grupa_return", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");
	return 1;
}

forward MySQL_LoadFactionMembersInfo(f_id);
public MySQL_LoadFactionMembersInfo(f_id)
{
	// Resetuje imena lidera, da bi se komandom /lideri moglo videti gde nedostaje lider
	strmid(F_LEADERS[f_id][0], "Niko", 0, strlen("Niko"));
	strmid(F_LEADERS[f_id][1], "Niko", 0, strlen("Niko"));
	
	// Ovaj deo bi trebalo da bude na kraju, ali ipak nije, jer bi se onda ponavljao 5-6 puta
	if (f_id == f_loading_last_id)
		LOADED[l_factions_members] = 1;

	cache_get_row_count(rows);
			
	if (f_id < 0 || f_id >= MAX_FACTIONS || !rows) 
		return printf("[factions.pwn] Nemoguce ucitati clanove za organizaciju: %d", f_id);
		
	if (FACTIONS[f_id][f_loaded] == -1)
		return printf("[factions.pwn] Nemoguce ucitati clanove za organizaciju: %d (organizacija nije ucitana)", f_id);
	

	FACTIONS[f_id][f_clanovi] = 0;

	for__loop (new i = 0; i < rows; i++)
	{
		if (i >= MAX_FACTIONS_MEMBERS || i >= FACTIONS[f_id][f_max_clanova]) // Prva provera: Array out of bounds, druga provera: preko limita dozvoljenog skriptom
		{
			printf("[factions.pwn] Organizacija %d ima previse clanova (%d)", f_id, i);
			return 1;
		}


		FACTIONS[f_id][f_clanovi] ++;
		
		new lider;
		cache_get_value_name_int(i, "lider", lider);
		
		if (lider == 1) 
		{
			// Lider je u pitanju, upisi ga u F_LEADERS
			
			if (!strcmp(F_LEADERS[f_id][0], "Niko")) 
				cache_get_value_name(i, "ime", F_LEADERS[f_id][0], MAX_PLAYER_NAME);
				
			else if (!strcmp(F_LEADERS[f_id][1], "Niko"))
				cache_get_value_name(i, "ime", F_LEADERS[f_id][1], MAX_PLAYER_NAME);
				
			else printf("[factions.pwn] Pronadjeno vise od 2 lidera za f_id = %d", f_id);
		}

		new ime[MAX_PLAYER_NAME];
		cache_get_value_name(i, "ime", ime, sizeof ime);
	}

	Faction_UpdateEntranceLabel(f_id);
	return 1;
}

forward mysql_remove_vehicle_weapons();
public mysql_remove_vehicle_weapons()
{
	cache_get_row_count(rows);
	if(!rows) return 1;

	new id, sQuery[100];

	for(new i = 0; i < rows; i++)
	{
		cache_get_value_index_int(i, 0, id);

		format(sQuery, sizeof sQuery, "DELETE FROM factions_vehicles_weapons WHERE v_id = %d", id);
		mysql_tquery(SQL, sQuery);
	}

	return 1;
}

forward MySQL_Factions_LoadVehWeapons(f_id, vehSlot);
public MySQL_Factions_LoadVehWeapons(f_id, vehSlot)
{
	cache_get_row_count(rows);
	if (!rows) return 1;

	for__loop (new id, weaponSlot, i = 0; i < rows; i++) 
	{
		cache_get_value_index_int(i, 0, id);
		cache_get_value_index_int(i, 1, weaponSlot);
		cache_get_value_index_int(i, 2, F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon]);
		cache_get_value_index_int(i, 3, F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]);
	}
	return 1;
}

forward MySQL_PlayerLeaveFaction(playerid, ccinc);
public MySQL_PlayerLeaveFaction(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows) 
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new 
		timestamp,
		novcanaKazna = 100000,
		f_id = PI[playerid][p_org_id],
		sTitle[MAX_FNAME_LENGTH + 8]
	;
	cache_get_value_index_int(0, 0, timestamp);

	if (PI[playerid][p_nivo] > 10)
	{
		novcanaKazna += 100000 * (PI[playerid][p_nivo] - 10);
	}

	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	if (timestamp > gettime()) // Igrac nije uspunio ugovor
	{
		SetPVarInt(playerid, "factionPenalty", novcanaKazna);

		new sDialog[331];
		format(sDialog, sizeof sDialog, "{FFFFFF}Niste ispunili ugovor u trajanju od {FF0000}%d dana {FFFFFF}clanstva.\nUkoliko sada napustite {%s}%s, {FFFFFF}bicete kaznjeni:\n  - %d dana zabrane ulaska u bilo koju organizaciju/mafiju/bandu\n  - novcana kazna u iznosu od %s\n\nDa li ste sigurni da zelite da napustite {%s}%s?", FACTIONS_CONTRACT_TIME/86400, FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], FACTIONS_PENALTY_TIME/86400, formatMoneyString(novcanaKazna), FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
		SPD(playerid, "grupa_napusti", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Napusti", "Odustani");
	}
	else 
	{
		SetPVarInt(playerid, "factionPenalty", 0);

		new sDialog[211];
		format(sDialog, sizeof sDialog, "{FFFFFF}Ispunili ste ugovor u trajanju od {FF0000}%d dana {FFFFFF}clanstva.\nMozete da napustite {%s}%s {FFFFFF}bez posledica.\n\nDa li ste sigurni da zelite da napustite {%s}%s?", FACTIONS_CONTRACT_TIME/86400, FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
		SPD(playerid, "grupa_napusti", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Napusti", "Odustani");
	}

	return 1;
}

forward MySQL_FactionMemberList(playerid, f_id, lider, ccinc);
public MySQL_FactionMemberList(playerid, f_id, lider, ccinc)
{
	/*
		param. lider = 1 ---> spisak clanova je zatrazio lider ili admin
			   lider = 0 ---> spisak clanova je zatrazio obican clan
	*/
	if (!checkcinc(playerid, ccinc))  return 1;

	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(playerid, "Ova organizacija/mafija/banda je prazna (nema clanova).");
	
	if (lider == 1) 
	{
	   if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	   if (F_IZMENA[playerid][IZMENA_ITEM] != IZMENA_CLANOVI || F_IZMENA[playerid][IZMENA_ID] != f_id)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (05)");
	}
	else 
	{
		if (PI[playerid][p_org_id] == -1)
			return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (06)");
	}
		
	new 
		sDialog[1200],
		sTitle[MAX_FNAME_LENGTH + 8],
		targetid,
		rank,
		skill,
		sPlayerName[MAX_PLAYER_NAME],
		sLastActivity[22]
	;
	

	if (lider == 1)
	{
		format(sDialog, 47, "Ime\tRang (skill)\tPoslednja aktivnost\tStatus");
	}
	else
	{
		format(sDialog, 18, "Ime\tRang\tStatus");
	}

	for__loop (new i = 0; i < rows; i++)
	{
		cache_get_value_index(i, 0, sPlayerName, MAX_PLAYER_NAME); // ime
		cache_get_value_index_int(i, 1, skill); // skill
		if (lider == 1) cache_get_value_index(i, 2, sLastActivity, sizeof sLastActivity); 

		targetid = GetPlayerIDFromName(sPlayerName);
		rank = GetPlayerFactionRank(FACTIONS[f_id][f_vrsta], skill);


		if (lider == 1)
		{
			format(sDialog, sizeof sDialog, "%s\n%s\t%i (%i)\t%s\t%s", sDialog, sPlayerName, rank, skill, sLastActivity, (IsPlayerConnected(targetid)?("{00FF00}ONLINE"):("{FF0000}OFFLINE")));
		}
		else
		{
			format(sDialog, sizeof sDialog, "%s\n%s\t%i\t%s", sDialog, sPlayerName, rank, (IsPlayerConnected(targetid)?("{00FF00}ONLINE"):("{FF0000}OFFLINE")));
		}
	}
	
	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	if (lider == 1)
	{
		SPD(playerid, "org_clanovi", DIALOG_STYLE_TABLIST_HEADERS, sTitle, sDialog, "Izmeni", "Nazad");
	}
	else
	{
		SPD(playerid, "grupa_return", DIALOG_STYLE_TABLIST_HEADERS, sTitle, sDialog, "Nazad", "");
	}
	return 1;
}

forward MySQL_FactionMemberInfo(returnid, sPlayerName[MAX_PLAYER_NAME], f_id, ccinc);
public MySQL_FactionMemberInfo(returnid, sPlayerName[MAX_PLAYER_NAME], f_id, ccinc) 
{
	if (!checkcinc(returnid, ccinc)) return 1;
	
	if (!IsAdmin(returnid, 1) && (PI[returnid][p_org_id] != f_id || PI[returnid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(returnid, GRESKA_NEMADOZVOLU);
		
	if (F_IZMENA[returnid][IZMENA_ITEM] != IZMENA_CLANOVI || F_IZMENA[returnid][IZMENA_ID] != f_id)
		return SendClientMessage(returnid, TAMNOCRVENA2, GRESKA_NEMADOZVOLU);
		
		
	cache_get_row_count(rows);
	if (!rows)
		return ErrorMsg(returnid, "Upit je uspesno poslat ka bazi, ali nema nikakvih rezultata.");
	if (rows != 1)
		return ErrorMsg(returnid, "Pronadjen je duplikat ovog igraca. Obavesti head admina o ovome!");
		
	new
		org_id,
		nivo,
		kaznjen_puta,
		org_vreme,
		skill,
		sLastAct[22],
		sTitle[MAX_PLAYER_NAME + 8],
		sJoinDate[22]
	;
	cache_get_value_name_int(0, "org_id", org_id);
	cache_get_value_name_int(0, "nivo", nivo);
	cache_get_value_name_int(0, "kaznjen_puta", kaznjen_puta);
	cache_get_value_name_int(0, "org_vreme", org_vreme);
	cache_get_value_name_int(0, "skill", skill);
	cache_get_value_name(0,     "last_act", sLastAct, sizeof sLastAct);
	cache_get_value_name(0,     "join_date", sJoinDate, sizeof sJoinDate);
		
	if (org_id != f_id)
		return ErrorMsg(returnid, "Igrac cije ste podatke zatrazili nije clan te organizacije.");
	
	
	new sDialog[330];
	format(sDialog, sizeof(sDialog), "{FFFFFF}Clan: {%s}%s\n{FFFFFF}Rank: {%s}%d\n{FFFFFF}Datum pristupa: {%s}%s\n{FFFFFF}Nivo: {%s}%d\n{FFFFFF}Kaznjen: {%s}%d puta\n{FFFFFF}Vreme u grupi: {%s}%i sati\n{FFFFFF}Poslednja aktivnost: {%s}%s", 
		FACTIONS[f_id][f_rgb], sPlayerName, 
		FACTIONS[f_id][f_rgb], GetPlayerFactionRank(FACTIONS[f_id][f_vrsta], skill),
		FACTIONS[f_id][f_rgb], sJoinDate,
		FACTIONS[f_id][f_rgb], nivo,
		FACTIONS[f_id][f_rgb], kaznjen_puta, 
		FACTIONS[f_id][f_rgb], floatround(org_vreme/3600.0), 
		FACTIONS[f_id][f_rgb], sLastAct);
	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], sPlayerName);
	
	SPD(returnid, "org_clanovi_info", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");

	return 1;
}

public mysql_factions_vehInsert(f_id, slot, vehicleid) 
{
	if (DebugFunctions())
	{
		LogFunctionExec("mysql_factions_vehInsert");
	}

	if (F_VEHICLES[f_id][slot][fv_vehicle_id] != vehicleid || cache_insert_id() == -1) 
	{
		FactionMsg(f_id, "{FF0000}Dogodila se nepoznata greska sa kupljenim vozilom. Obavestite head admina i nemojte koristiti vozilo, niti ga prodavati.");
		FactionMsg(f_id, "{FFFFFF}Debug info: f_id: [%d], slot: [%d], vehicleid: [%d]", f_id, slot, vehicleid);
	}

	F_VEHICLES[f_id][slot][fv_mysql_id] = cache_insert_id();
	return 1;
}

public mysql_factions_logs(f_id, playerid, ccinc) 
{
	if (!checkcinc(playerid, ccinc) || !IsPlayerConnected(playerid)) return 1;

	new 
		naslov[30], vreme[22], tekst[90], string[1950];
	format(naslov, sizeof(naslov), "{%s}%s - Logovi", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);

	cache_get_row_count(rows);
	if (!rows) {
		return SPD(playerid, "org_logovi", DIALOG_STYLE_MSGBOX, naslov, "{FFFFFF}Nema logova.", "U redu", "");
	}

	format(string, 35, "{FFFFFF}Poslednjih 20 radnji:\n");
	for__loop (new i = 0; i < rows; i++) {
		cache_get_value_index(i, 0, vreme);
		cache_get_value_index(i, 1, tekst);
		format(string, sizeof(string), "%s\n[%s]\t%s", string, vreme, tekst);
	}

	SPD(playerid, "org_logovi", DIALOG_STYLE_MSGBOX, naslov, string, "U redu", "");
	return 1;
}





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
stock showDialog_org_podaci_2(playerid, f_id) {
	if (f_id == -1) return 1;

	new naslov[32];
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);

	if (IsAdmin(playerid, 5) || PI[playerid][p_org_rank] == RANK_LEADER) // Lider/admin5
	{
		if (FACTIONS[f_id][f_vrsta] == FACTION_MAFIA || FACTIONS[f_id][f_vrsta] == FACTION_GANG || FACTIONS[f_id][f_vrsta] == FACTION_RACERS)
		{
			SPD(playerid, "org_podaci_2", DIALOG_STYLE_LIST, naslov, "Informacije\nClanovi\nIzmena vozila\nRespawn vozila\nRankovi\nLogovi\nUbaci novog clana\nReket info\nWar", "Dalje »", "« Nazad");
		}
		else
		{
			SPD(playerid, "org_podaci_2", DIALOG_STYLE_LIST, naslov, "Informacije\nClanovi\nIzmena vozila\nRespawn vozila\nRankovi\nLogovi\nUbaci novog clana", "Dalje »", "« Nazad");
		}
	}
	else // obican clan
		SPD(playerid, "org_podaci_2", DIALOG_STYLE_LIST, naslov, "Informacije\nClanovi\nIzmena vozila\nRespawn vozila\nRankovi", "Dalje »", "« Nazad");
	return 1;
}

Dialog:org_izrada_naziv(playerid, response, listitem, const inputtext[])
{
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return F_IZRADA[IZRADA_AKTIVNA] = 0;
		
	if (F_IZRADA[IZRADA_AKTIVNA] == 0)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (07)");
		
	if (isnull(inputtext) || strlen(inputtext) > MAX_FNAME_LENGTH)
	{
		F_IZRADA[IZRADA_AKTIVNA] = 0; // ako se varijabla ne resetuje, komanda /org_izrada ce vratiti error da je izrada vec aktivna

		new cmdParams[45];
		format(cmdParams, sizeof cmdParams, "%d %d %d %d %d", F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], 
			F_IZRADA[IZRADA_BOJA_2]);
			
		callcmd::orgizrada(playerid, cmdParams);
		
		return 1;
	}
	
	for__loop (new i = 0; i < MAX_FACTIONS; i++)
	{
		if (FACTIONS[i][f_loaded] != -1 && !strcmp(FACTIONS[i][f_naziv], inputtext, true))
		{
			ErrorMsg(playerid, "Vec postoji organizacija sa istim nazivom.");
			F_IZRADA[IZRADA_AKTIVNA] = 0; // ako se varijabla ne resetuje, komanda /org_izrada ce vratiti error da je izrada vec aktivna
			
			new cmdParams[45];
			format(cmdParams, sizeof cmdParams, "%d %d %d %d %d", F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], 
				F_IZRADA[IZRADA_BOJA_2]);
				
			callcmd::orgizrada(playerid, cmdParams);
			
			return 1;
		}
	}
	
	strmid(F_IZRADA[IZRADA_NAZIV], inputtext, 0, strlen(inputtext), MAX_FNAME_LENGTH);
	
	format(string_128, sizeof string_128, "{FFFFFF}Naziv: {0068B3}%s\n\n{FFFFFF}Upisite tag za ovu organizaciju (max. %d znakova):", F_IZRADA[IZRADA_NAZIV], MAX_FTAG_LENGTH);
	SPD(playerid, "org_izrada_tag", DIALOG_STYLE_INPUT, "{0068B3}Izrada organiacije", string_128, "Dalje »", "« Nazad");
	
	return 1;
}

Dialog:org_izrada_tag(playerid, response, listitem, const inputtext[])
{
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
	{
		F_IZRADA[IZRADA_AKTIVNA] = 0; // ako se varijabla ne resetuje, komanda /org_izrada ce vratiti error da je izrada vec aktivna

		new cmdParams[45];
		format(cmdParams, sizeof cmdParams, "%d %d %d %d %d", F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], F_IZRADA[IZRADA_BOJA_2]);
				
		callcmd::orgizrada(playerid, cmdParams);
		
		return 1;
	}
		
	if (F_IZRADA[IZRADA_AKTIVNA] == 0)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (08)");
		
	if (isnull(inputtext) || strlen(inputtext) > MAX_FTAG_LENGTH)
		return DialogReopen(playerid);
	
	for__loop (new i = 0; i < MAX_FACTIONS; i++)
	{
		if (FACTIONS[i][f_loaded] != -1 && !strcmp(FACTIONS[i][f_tag], inputtext, true))
		{
			ErrorMsg(playerid, "Vec postoji organizacija sa istim tagom.");
			DialogReopen(playerid);
			
			return 1;
		}
	}
	
	
	strmid(F_IZRADA[IZRADA_TAG], inputtext, 0, strlen(inputtext), MAX_FTAG_LENGTH);
	
	format(string_128, sizeof string_128, "{FFFFFF}Tag: {0068B3}%s\n\n{FFFFFF}Upisite HEX kod za boju ove organizacije:", F_IZRADA[IZRADA_TAG]);
	SPD(playerid, "org_izrada_hex", DIALOG_STYLE_INPUT, "{0068B3}Izrada organiacije", string_128, "Dalje »", "« Nazad");
	
	return 1;
}

Dialog:org_izrada_hex(playerid, response, listitem, const inputtext[]) {
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	
	if (!response) {
		// Vraca na unos taga
		format(string_128, sizeof string_128, "{FFFFFF}Naziv: {0068B3}%s\n\n{FFFFFF}Upisite tag za ovu organizaciju (max. %d znakova):", F_IZRADA[IZRADA_NAZIV], MAX_FTAG_LENGTH);
		SPD(playerid, "org_izrada_tag", DIALOG_STYLE_INPUT, "{0068B3}Izrada organiacije", string_128, "Dalje »", "« Nazad");
		
		return 1;
	}
		
	if (F_IZRADA[IZRADA_AKTIVNA] == 0)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (09)");
		
	if (isnull(inputtext) || strlen(inputtext) != 10)
		return DialogReopen(playerid);

	new hex_stripped[7]; // Hex boja bez "0x" na pocetku i bez poslednja 2 karaktera. Npr 0x00FF00AA ---> 00FF00
	strmid(F_IZRADA[IZRADA_HEX], inputtext, 0, strlen(inputtext), MAX_HEX_LENGTH);
	strmid(hex_stripped, inputtext, 2, 8);
	
	new sDialog[396];
	format(sDialog, sizeof sDialog, "{FFFFFF}Vrsta: {0068B3}%s (%d)\n{FFFFFF}Naziv: {0068B3}%s\n{FFFFFF}Tag: {0068B3}%s\n{FFFFFF}Max clanova: {0068B3}%d\n{FFFFFF}Max vozila: {0068B3}%d\n{FFFFFF}Boje: {0068B3}%d, %d\n{FFFFFF}Hex boja: {%s}%s\n\n{FFFFFF}Spawn pozicija ce biti postavljena na mestu gde se trenutno nalazite.\nDa li zelite da kreirate novu organizaciju?", faction_name(F_IZRADA[IZRADA_VRSTA], FNAME_LOWER), F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_NAZIV], F_IZRADA[IZRADA_TAG], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], F_IZRADA[IZRADA_BOJA_2], hex_stripped, F_IZRADA[IZRADA_HEX]);
	SPD(playerid, "org_izrada_potvrda", DIALOG_STYLE_MSGBOX, "{0068B3}Izrada organiacije", sDialog, "Da", "Nazad");
	return 1;
}

Dialog:org_izrada_potvrda(playerid, response, listitem, const inputtext[])
{
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return dialog_respond:org_izrada_naziv(playerid, 1, 0, F_IZRADA[IZRADA_NAZIV]);
		
	// Validacija svih prethodno unetih parametara, za svaki slucaj
	if (F_IZRADA[IZRADA_AKTIVNA] == 0)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (10)");
	
	if (F_IZRADA[IZRADA_VRSTA] != FACTION_MAFIA && F_IZRADA[IZRADA_VRSTA] != FACTION_GANG && F_IZRADA[IZRADA_VRSTA] != FACTION_LAW && F_IZRADA[IZRADA_VRSTA] != FACTION_RACERS && F_IZRADA[IZRADA_VRSTA] != FACTION_MD)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (11)");
		
	if (F_IZRADA[IZRADA_MAX_CLANOVA] < 1 || F_IZRADA[IZRADA_MAX_CLANOVA] >= MAX_FACTIONS_MEMBERS)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (12)");
		
	if (F_IZRADA[IZRADA_MAX_VOZILA] < 1 || F_IZRADA[IZRADA_MAX_VOZILA] >= MAX_FACTIONS_VEHICLES)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (13)");
		
	if (F_IZRADA[IZRADA_BOJA_1] < 0 || F_IZRADA[IZRADA_BOJA_2] < 0 || F_IZRADA[IZRADA_BOJA_1] > 255 || F_IZRADA[IZRADA_BOJA_2] > 255)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (14)");
		
	if (isnull(F_IZRADA[IZRADA_NAZIV]) || strlen(F_IZRADA[IZRADA_NAZIV]) > MAX_FNAME_LENGTH)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (15)");
		
	if (isnull(F_IZRADA[IZRADA_TAG]) || strlen(F_IZRADA[IZRADA_TAG]) > MAX_FNAME_LENGTH)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (16)");
		
	if (isnull(F_IZRADA[IZRADA_HEX]) || strlen(F_IZRADA[IZRADA_HEX]) != 10)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (17)");
		
		
	// Uzimanje ID-a nove organizacije
	new f_id = -1;
	for__loop (new i = 0; i < MAX_FACTIONS; i++)
	{
		if (FACTIONS[i][f_loaded] == -1)
		{
			f_id = i;
			break;
		}
	}
	if (f_id == -1)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (18)");
	
	
	// Uzimanje spawn pozicije
	GetPlayerPos(playerid, FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn]);
	GetPlayerFacingAngle(playerid, FACTIONS[f_id][f_a_spawn]);
	FACTIONS[f_id][f_ent_spawn] = GetPlayerInterior(playerid);
	FACTIONS[f_id][f_vw_spawn]  = GetPlayerVirtualWorld(playerid);
	
	
	// Asocijacija unetih informacija sa varijablama organizacije i postavljanje default vrednosti kod ostalih
	new
		ulaz[41],
		spawn[64],
		query[255];
	
	format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f|%d|%d", FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn], 
		FACTIONS[f_id][f_a_spawn], FACTIONS[f_id][f_ent_spawn], FACTIONS[f_id][f_vw_spawn]);
	format(ulaz, sizeof(ulaz), "%.4f|%.4f|%.4f|%.4f", FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn], FACTIONS[f_id][f_a_spawn]);
	strmid(FACTIONS[f_id][f_naziv],  F_IZRADA[IZRADA_NAZIV], 0, strlen(F_IZRADA[IZRADA_NAZIV]), MAX_FNAME_LENGTH);
	strmid(FACTIONS[f_id][f_tag],    F_IZRADA[IZRADA_TAG],   0, strlen(F_IZRADA[IZRADA_TAG]),   MAX_FTAG_LENGTH);
	strmid(FACTIONS[f_id][f_hex],    F_IZRADA[IZRADA_HEX],   0, strlen(F_IZRADA[IZRADA_HEX]),   MAX_HEX_LENGTH);
	strmid(FACTIONS[f_id][f_rgb],    F_IZRADA[IZRADA_HEX],   2, 8, 7);
	FACTIONS[f_id][f_vrsta]                 = F_IZRADA[IZRADA_VRSTA];
	FACTIONS[f_id][f_max_clanova]           = F_IZRADA[IZRADA_MAX_CLANOVA];
	FACTIONS[f_id][f_max_vozila]            = F_IZRADA[IZRADA_MAX_VOZILA];
	FACTIONS[f_id][f_boja_1]                = F_IZRADA[IZRADA_BOJA_1];
	FACTIONS[f_id][f_boja_2]                = F_IZRADA[IZRADA_BOJA_2];
	FACTIONS[f_id][f_loaded]                = f_id;
	FACTIONS[f_id][f_x_ulaz]                = FACTIONS[f_id][f_x_spawn];
	FACTIONS[f_id][f_y_ulaz]                = FACTIONS[f_id][f_y_spawn];
	FACTIONS[f_id][f_z_ulaz]                = FACTIONS[f_id][f_z_spawn];
	FACTIONS[f_id][f_a_ulaz]                = FACTIONS[f_id][f_a_spawn];

	if(FACTIONS[f_id][f_vrsta] == FACTION_MAFIA)
		FACTIONS[f_id][f_entid]             = 2;

	else if(FACTIONS[f_id][f_vrsta] == FACTION_GANG)
		FACTIONS[f_id][f_entid]             = 3;
	
	FACTIONS[f_id][f_x_izlaz] = faction_interiors[FACTIONS[f_id][f_entid]][POS_X];
	FACTIONS[f_id][f_y_izlaz] = faction_interiors[FACTIONS[f_id][f_entid]][POS_Y];
	FACTIONS[f_id][f_z_izlaz] = faction_interiors[FACTIONS[f_id][f_entid]][POS_Z];
	FACTIONS[f_id][f_a_izlaz] = faction_interiors[FACTIONS[f_id][f_entid]][POS_A];
	FACTIONS[f_id][f_ent]       = floatround(faction_interiors[FACTIONS[f_id][f_entid]][4]);
	FACTIONS[f_id][f_vw]        = (10000+f_id) * 10;

	FACTIONS[f_id][f_budzet]                = 0;
	FACTIONS[f_id][f_materijali]            = 0;
	FACTIONS[f_id][f_municija]              = 0;
	FACTIONS[f_id][f_materijali_skladiste]  = 0;
	FACTIONS[f_id][f_municija_skladiste]    = 0;
	FACTIONS[f_id][f_wars_won]              = 0;
	FACTIONS[f_id][f_wars_lost]             = 0;
	FACTIONS[f_id][f_wars_draw]             = 0;
	
	new sstring[16];
	format(sstring, sizeof sstring, "%s", FACTIONS[f_id][f_tag]);

	CreateEnterExit(sstring, "Los Santos", FACTIONS[f_id][f_x_ulaz], FACTIONS[f_id][f_y_ulaz], FACTIONS[f_id][f_z_ulaz], FACTIONS[f_id][f_a_ulaz], FACTIONS[f_id][f_x_izlaz], FACTIONS[f_id][f_y_izlaz], FACTIONS[f_id][f_z_izlaz], FACTIONS[f_id][f_a_izlaz], FACTIONS[f_id][f_ent], 0, FACTIONS[f_id][f_vw], 0, 1314, 19134, f_id);
	
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, FACTIONS[f_id][f_x_ulaz], FACTIONS[f_id][f_y_ulaz], FACTIONS[f_id][f_z_ulaz]))
			Streamer_Update(i);
	}

	// Insert u bazu
	mysql_format(SQL, query, sizeof query, "INSERT INTO factions VALUES (%d, %d, '%s', '%s', %d, %d, '%s', '%s', %d, 0, 0, 0, 0, 0, 0, 0, 0, 0, %d, %d, '%s', '%s')", f_id, FACTIONS[f_id][f_vrsta], FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_tag], FACTIONS[f_id][f_max_clanova], FACTIONS[f_id][f_max_vozila], spawn, ulaz, FACTIONS[f_id][f_entid], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], FACTIONS[f_id][f_hex], "0.0000,0.0000,0.0000,0.0000");
	mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_INSERT);
	
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, ZELENA2, "%s %s (%s) je uspjesno kreirana.", faction_name(f_id, FNAME_CAPITAL), FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_tag]);
	SendClientMessage(playerid, ZUTA, "* Kreirajte rankove koristeci naredbu /lider.");

	F_IZRADA[IZRADA_AKTIVNA] = 0;
	return 1;
}

Dialog:org_podaci_1(playerid, response, listitem, const inputtext[]) // Odabir organizacije za edit
{
	if (!response)
		return 1;
		
	new 
		f_id = faction_listitem[playerid][listitem],
		naslov[MAX_FNAME_LENGTH + 8]
	;
		
	if (FACTIONS[f_id][f_loaded] == -1) // organizacija nije ucitana
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (19)");
			
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	
	F_IZMENA[playerid][IZMENA_AKTIVNA] = 1;
	F_IZMENA[playerid][IZMENA_ITEM]    = IZMENA_NISTA;
	F_IZMENA[playerid][IZMENA_ID]      = f_id;
		
	showDialog_org_podaci_2(playerid, f_id);    

	return 1;
}

Dialog:org_podaci_2(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		if (IsAdmin(playerid, 5) || PlayerFlagGet(playerid, FLAG_LEADER_VODJA))
			return callcmd::lider(playerid, "");
		else
			return 1;
	}
	
	
	if (F_IZMENA[playerid][IZMENA_ID] < 0 || F_IZMENA[playerid][IZMENA_ID] >= MAX_FACTIONS)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (20)");
		
	new 
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8];
		
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);


	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);   
	switch (listitem) 
	{
		case 0: // Konfiguracija
		{
			new sDialog[352];
			format(sDialog, sizeof sDialog, "{%s}%s (%s)\n\n{FFFFFF}ID: {%s}%d\n{FFFFFF}Vrsta: {%s}%s (%d)\n{FFFFFF}Clanovi: {%s}%d/%d (%d lidera)\n{FFFFFF}Vozila: {%s}%d/%d\n{FFFFFF}Enterijer: {%s}%d\n{FFFFFF}Budzet: {%s}%s\n{FFFFFF}Boje: {%s}%d, %d\n{FFFFFF}War skor: {%s}%d, %d, %d",
			FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], FACTIONS[f_id][f_tag], 
			FACTIONS[f_id][f_rgb], f_id, 
			FACTIONS[f_id][f_rgb], faction_name(f_id, FNAME_LOWER), FACTIONS[f_id][f_vrsta], 
			FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_clanovi], FACTIONS[f_id][f_max_clanova], GetFactionLeaderCount(f_id), 
			FACTIONS[f_id][f_rgb], GetFactionVehicleCount(f_id), FACTIONS[f_id][f_max_vozila], 
			FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_entid], FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]), 
			FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], 
			FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_wars_won], FACTIONS[f_id][f_wars_lost], FACTIONS[f_id][f_wars_draw]);
				
			if (IsAdmin(playerid, 6))
				SPD(playerid, "org_config_info", DIALOG_STYLE_MSGBOX, naslov, sDialog, "Izmeni", "Nazad");
			else
				SPD(playerid, "org_config_info", DIALOG_STYLE_MSGBOX, naslov, sDialog, "Nazad", "");
		}
		case 1: // Clanovi
		{
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_CLANOVI; // IZMENA_CLANOVI se koristi ovde, ali i za izmenu max broja clanova
		
			new sQuery[260];
			format(sQuery, sizeof sQuery, "SELECT igraci.ime, igraci.skill_%s, DATE_FORMAT(igraci.poslednja_aktivnost, '\%%d/\%%m, \%%H:\%%i') as akt FROM igraci RIGHT JOIN factions_members ON factions_members.player_id = igraci.id WHERE factions_members.faction_id = %i ORDER BY akt DESC", (FACTIONS[f_id][f_vrsta]==FACTION_LAW? ("cop") : ("criminal")), f_id);
			mysql_tquery(SQL, sQuery, "MySQL_FactionMemberList", "iiii", playerid, f_id, 1, cinc[playerid]);
		}
		case 2: // Izmena vozila
		{
			new sDialog[12 + MAX_FACTIONS_VEHICLES*48];
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_VOZILA;

			if (GetFactionVehicleCount(f_id) == 0) 
			{
				ErrorMsg(playerid, "Nema nijednog kupljenog vozila.");
				return showDialog_org_podaci_2(playerid, f_id);
			}

			format(sDialog, 12, "Model\tCena");
			for__loop (new i = 0, li = 0; i < sizeof(faction_vehicles_listitem[]); i++) 
			{
				faction_vehicles_listitem[playerid][i] = -1;

				if (F_VEHICLES[f_id][i][fv_vehicle_id] != -1) 
				{
					// Vozilo na slotu "i" postoji i kreirano je
					faction_vehicles_listitem[playerid][li++] = i;

					new sRGB[7];
					if (GetPlayerVehicleID(playerid) == F_VEHICLES[f_id][i][fv_vehicle_id]) sRGB = "FFFF00";
					else sRGB = "FFFFFF";

					format(sDialog, sizeof(sDialog), "%s\n{%s}%s\t{%s}$%d", sDialog, sRGB, imena_vozila[F_VEHICLES[f_id][i][fv_model_id] - 400], sRGB, F_VEHICLES[f_id][i][fv_cena]);
				} 
			}
	
			SPD(playerid, "org_vozila", DIALOG_STYLE_TABLIST_HEADERS, naslov, sDialog, "Izmeni", "Nazad");
		}
		case 3: // Respawn vozila
		{
			if (FACTIONS[f_id][f_respawnCooldown] > gettime())
				return ErrorMsg(playerid, "Mozete respawnovati vozila jednom u 15 minuta. Pokusajte ponovo za %s.", konvertuj_vreme(FACTIONS[f_id][f_respawnCooldown]-gettime()));
			
			SetTimerEx("factions_RespawnVehicles", 20*1000, false, "i", f_id);
			FactionMsg(f_id, "{FFFFFF}Sva slobodna vozila ce biti respawnovana za 20 sekundi (%s)", ime_rp[playerid]);
		}
		case 4: // Rankovi
		{
			new sDialog[20 + MAX_FACTIONS_RANKS * 38];
			format(sDialog, sizeof sDialog, "Kreiraj novi rank\n");
			for__loop (new i = 0, x = 0; i < MAX_FACTIONS_RANKS; i++)
			{
				
				if (strcmp(F_RANKS[f_id][i][fr_ime], "N/A")) 
				{
					x++;
					faction_ranks_listitem[playerid][x] = i;
					
					format(sDialog, sizeof sDialog, "%s%d: %s\n", sDialog, i, F_RANKS[f_id][i][fr_ime]);
				}
			}
			
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_RANKOVI;
			
			SPD(playerid, "org_rankovi", DIALOG_STYLE_LIST, naslov, sDialog, "Dalje »", "« Nazad");
		}

		case 5: // Logovi
		{
			new sQuery[142];
			format(sQuery, sizeof sQuery, "SELECT DATE_FORMAT(vreme, '\%%d \%%b, \%%H:\%%i') as time, tekst FROM factions_logs WHERE f_id = %d ORDER BY vreme DESC LIMIT 0,20", f_id);
			mysql_tquery(SQL, sQuery, "mysql_factions_logs", "iii", f_id, playerid, cinc[playerid]);
		}

		case 6: // Ubaci novog clana
		{
			SPD(playerid, "org_ubaci", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Unesite ime ili ID igraca kome zelite da posaljete poziv za pridruzivanje:", "Pozovi", "Nazad");
		}

		case 7: // Reket info
		{
			new sDialog[1024];

			format(sDialog, 24, "ID\tFirma\tIznos u kasi");
			for__loop (new i = 1; i <= RE_GetMaxID_Business(); i++)
			{
				if (BizInfo[i][BIZ_REKET] == f_id)
				{
					new bizName[32], lid = re_localid(firma, i);
					GetBusinessName(i, bizName, sizeof bizName);
					format(sDialog, sizeof sDialog, "%s\n%i\t%s\t%s", sDialog, lid, bizName, formatMoneyString(GetRacketMoney(lid)));
				}
			} 

			SPD(playerid, "org_reket_info", DIALOG_STYLE_TABLIST_HEADERS, naslov, sDialog, "Lociraj", "Nazad");
		}

		case 8: // War
		{
			return callcmd::war(playerid, "");
		}
	}
	
	return 1;
}

Dialog:org_reket_info(playerid, response, listitem, const inputtext[])
{
	new f_id = F_IZMENA[playerid][IZMENA_ID];

	if (!response) 
		return showDialog_org_podaci_2(playerid, f_id);

	SetPVarInt(playerid, "pGPSRealEstateType", firma);
	return dialog_respond:gps_nekretnina_id(playerid, 1, 0, inputtext);
}

Dialog:org_config_info(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8]
	;
		
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	
	if (response)
	{
		if (IsAdmin(playerid, 6))
		{
			format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
	
			SPD(playerid, "org_izmeni_select", DIALOG_STYLE_LIST, naslov, "Naziv\nTag\nVrsta\nLimit clanova\nLimit vozila\nBudzet\nBoje\nSpawn pozicija", "Dalje »", "« Nazad");
		}
		else if ((PI[playerid][p_org_id] == f_id && PI[playerid][p_org_rank] == RANK_LEADER) || !IsAdmin(playerid, 6))
			return showDialog_org_podaci_2(playerid, f_id);
		else
			return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	}
	else // Esc?
	{
		if (IsAdmin(playerid, 6)) // Ako pritisne Esc, ili klikne na nazad, vraca ga samo ako je admin; u suprotnom sakriva dialog
			return showDialog_org_podaci_2(playerid, f_id);
	}

	return 1;
}

Dialog:org_izmeni_select(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_FNAME_LENGTH + 8],
		sDialog[128]
	;
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
		
	if (!response)
		return showDialog_org_podaci_2(playerid, f_id);
		
	switch (listitem)
	{
		case 0: // Naziv
		{
			format(sDialog, sizeof sDialog, "{%s}Naziv: {FFFFFF}%s\n\nUpisite novi naziv za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], 
				faction_name(f_id, FNAME_AKUZATIV));
				
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_NAZIV;
		}
		case 1: // Tag
		{
			format(sDialog, sizeof sDialog, "{%s}Tag: {FFFFFF}%s\n\nUpisite novi tag za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag], 
				faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_TAG;
		}
		case 2: // Vrsta
		{
			format(sDialog, sizeof sDialog, "{%s}Vrsta: {FFFFFF}%s (%d)\n\nUpisite novu vrstu (string ili int) za ovu %s:", 
				FACTIONS[f_id][f_rgb], faction_name(f_id, FNAME_LOWER), FACTIONS[f_id][f_vrsta], faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_VRSTA;
		}
		case 3: // Limit clanova
		{
			format(sDialog, sizeof sDialog, "{%s}Limit clanova: {FFFFFF}%d\n\nUpisite novi limit clanova za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_max_clanova], 
				faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_CLANOVI;
		}
		case 4: // Limit vozila
		{
			format(sDialog, sizeof sDialog, "{%s}Limit vozila: {FFFFFF}%d\n\nUpisite novi limit vozila za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_max_vozila], 
				faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_VOZILA;
		}
		case 5: // Budzet
		{
			format(sDialog, sizeof sDialog, "{%s}Budzet: {FFFFFF}$%d\n\nUpisite novi budzet za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_budzet], 
				faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_BUDZET;
		}
		case 6: // Boje
		{
			return SPD(playerid, "org_izmeni_boje", DIALOG_STYLE_LIST, sTitle, "Boja vozila 1\nBoja vozila 2\nHex boja", "Dalje »", "« Nazad");
			// Tu je return da se ne bi prikazao sledeci dialog (ako se to dogodi, prikazace se input umesto list, i bice neki drugi string)
		}
		case 7: // Spawn pozicija
		{
			GetPlayerPos(playerid, FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn]);
			GetPlayerFacingAngle(playerid, FACTIONS[f_id][f_a_spawn]);
			FACTIONS[f_id][f_ent_spawn] = GetPlayerInterior(playerid);
			FACTIONS[f_id][f_vw_spawn]  = GetPlayerVirtualWorld(playerid);

			new sQuery[100];
			format(sQuery, sizeof sQuery, "UPDATE factions SET spawn = '%.4f|%.4f|%.4f|%.4f|%d|%d' WHERE id = %d", FACTIONS[f_id][f_x_spawn], FACTIONS[f_id][f_y_spawn], FACTIONS[f_id][f_z_spawn], FACTIONS[f_id][f_a_spawn], FACTIONS[f_id][f_ent_spawn], FACTIONS[f_id][f_vw_spawn], f_id);
			mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);


		
			// Slanje poruke igracu
			SendClientMessageF(playerid, SVETLOPLAVA, "Izmenili ste spawn poziciju za %s %s. Novi spawn je postavljen na Vasoj trenutnoj poziciji.",faction_name(f_id, FNAME_AKUZATIV), FACTIONS[f_id][f_naziv]);
			
			// Vracanje na prethodni dialog
			dialog_respond:org_config_info(playerid, 1, 0, "");
			
			// Upisivanje u log
			new sLog[82];
			format(sLog, sizeof sLog, "%s | %s | Spawn pozicija", FACTIONS[f_id][f_naziv], ime_obicno[playerid]);
			Log_Write(LOG_FACTIONS_EDIT, sLog);
		}
		default: return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (21)");
	}
	
	SPD(playerid, "org_izmeni", DIALOG_STYLE_INPUT, sTitle, sDialog, "Izmeni", "Nazad");
	
	return 1;
}

Dialog:org_izmeni_boje(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8]
	;
	
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response) 
		return dialog_respond:org_config_info(playerid, 1, 0, "");
		
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
		
	switch (listitem)
	{
		case 0: { // Boja 1
			format(string_128, sizeof string_128, "{%s}Boja 1: {FFFFFF}%d\n\nUpisite novu boju (1) za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_boja_1], faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_BOJA_1;
		}
		case 1: { // Boja 2
			format(string_128, sizeof string_128, "{%s}Boja 2: {FFFFFF}%d\n\nUpisite novu boju (2) za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_boja_2], faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_BOJA_2;
		}
		case 2: { // Hex
			format(string_128, sizeof string_128, "{%s}Hex boja: {FFFFFF}%s\n\nUpisite novu hex boju za ovu %s:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_hex], faction_name(f_id, FNAME_AKUZATIV));
		
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_HEX;
		}
		default: return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (22)");
	}
	
	SPD(playerid, "org_izmeni", DIALOG_STYLE_INPUT, naslov, string_128, "Izmeni", "Nazad");
	return 1;
}

Dialog:org_izmeni(playerid, response, listitem, inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8],
		field_name[16],
		input = -99,
		old[64]
	;
	if (!IsAdmin(playerid, 6))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response) 
		return dialog_respond:org_config_info(playerid, 1, 0, "");
		
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);
		
	switch (F_IZMENA[playerid][IZMENA_ITEM])
	{
		case IZMENA_NAZIV:
		{
			if (isnull(inputtext) || strlen(inputtext) > MAX_FNAME_LENGTH)
			{
				ErrorMsg(playerid, "Niste uneli nista ili je unos previse dug.");
				return DialogReopen(playerid);
			}
			
			strmid(old, FACTIONS[f_id][f_naziv], 0, strlen(FACTIONS[f_id][f_naziv]));
			strmid(FACTIONS[f_id][f_naziv], inputtext, 0, strlen(inputtext), MAX_FNAME_LENGTH);
			field_name = "naziv";
		}
		case IZMENA_TAG:
		{
			if (isnull(inputtext) || strlen(inputtext) > MAX_FTAG_LENGTH-1)
			{
				ErrorMsg(playerid, "Niste uneli nista ili je unos previse dug.");
				return DialogReopen(playerid);
			}
			
			strmid(old, FACTIONS[f_id][f_tag], 0, strlen(FACTIONS[f_id][f_tag]));
			strmid(FACTIONS[f_id][f_tag], inputtext, 0, strlen(inputtext), MAX_FTAG_LENGTH);
			field_name = "tag";
		}
		case IZMENA_VRSTA:
		{
			if (isnull(inputtext))
				return DialogReopen(playerid);
			
			if (sscanf(inputtext, "i", input)) // Igrac NIJE uneo broj
			{
				if (sscanf(inputtext, "s[" #MAX_FTAG_LENGTH "]")) // Igrac NIJE uneo niti string
					return DialogReopen(playerid);
				else // Igrac JE uneo string
				{
					if (!strcmp(inputtext,     "mafija",   true, 6)) input = FACTION_MAFIA;
					else if(!strcmp(inputtext, "banda",    true, 5)) input = FACTION_GANG;
					else if(!strcmp(inputtext, "policija", true, 8)) input = FACTION_LAW;
					else if(!strcmp(inputtext, "bolnica",  true, 7)) input = FACTION_MD;
					else
					{
						ErrorMsg(playerid, "Nevazeci unos.");
						return DialogReopen(playerid);
					}
				}
			}
			if (input != FACTION_MAFIA && input != FACTION_GANG && input != FACTION_LAW && input != FACTION_RACERS && input != FACTION_MD)
			{
				ErrorMsg(playerid, "Nevazeci unos.");
				return DialogReopen(playerid);
			}
			// Nakon ovoga gore, "input" bi trebalo da ima ispravnu vrednost
			
			
			valstr(old, FACTIONS[f_id][f_vrsta]);
			FACTIONS[f_id][f_vrsta] = input;
			field_name = "vrsta";
		}
		case IZMENA_CLANOVI:
		{
			input = strval(inputtext);
			
			if (input < 1 || input > MAX_FACTIONS_MEMBERS)
			{
				ErrorMsg(playerid, "Nevazeci unos (previse veliki ili previse mali broj).");
				return DialogReopen(playerid);
			}
			
			valstr(old, FACTIONS[f_id][f_max_clanova]);
			FACTIONS[f_id][f_max_clanova] = input;
			field_name = "max_clanova";
		}
		case IZMENA_VOZILA:
		{
			input = strval(inputtext);
			
			if (input < 1 || input > MAX_FACTIONS_VEHICLES)
			{
				ErrorMsg(playerid, "Nevazeci unos (previse veliki ili previse mali broj).");
				return DialogReopen(playerid);
			}
				
			valstr(old, FACTIONS[f_id][f_max_vozila]);
			FACTIONS[f_id][f_max_vozila] = input;
			field_name = "max_vozila";
		}
		case IZMENA_BUDZET:
		{
			input = strval(inputtext);
			
			if (input < 0 || input > 2147483647 || isnull(inputtext))
			{
				ErrorMsg(playerid, "Nevazeci unos (previse veliki ili previse mali broj).");
				return DialogReopen(playerid);
			}
				
			valstr(old, FACTIONS[f_id][f_budzet]);
			FACTIONS[f_id][f_budzet] = input;
			field_name = "budzet";
		}
		case IZMENA_BOJA_1:
		{
			input = strval(inputtext);
			
			if (input < 0 || input > 255 || isnull(inputtext))
			{
				ErrorMsg(playerid, "Nevazeci unos (broj mora biti 0-255).");
				return DialogReopen(playerid);
			}
				
			valstr(old, FACTIONS[f_id][f_boja_1]);
			FACTIONS[f_id][f_boja_1] = input;
			field_name = "boja_1";
		}
		case IZMENA_BOJA_2:
		{
			input = strval(inputtext);
			
			if (input < 0 || input > 255 || isnull(inputtext))
			{
				ErrorMsg(playerid, "Nevazeci unos (broj mora biti 0-255).");
				return DialogReopen(playerid);
			}
				
			valstr(old, FACTIONS[f_id][f_boja_2]);
			FACTIONS[f_id][f_boja_2] = input;
			field_name = "boja_2";
		}
		case IZMENA_HEX:
		{
			if (isnull(inputtext) || strlen(inputtext) != 10)
			{
				ErrorMsg(playerid, "Niste uneli nista ili unos ne sadrzi tacno 10 karaktera.");
				return DialogReopen(playerid);
			}
			
			strmid(old, FACTIONS[f_id][f_hex], 0, strlen(FACTIONS[f_id][f_hex]));
			strmid(FACTIONS[f_id][f_hex], inputtext, 0, strlen(inputtext), MAX_HEX_LENGTH);
			strmid(FACTIONS[f_id][f_rgb], inputtext, 2, 8, 7);
			field_name = "hex";
		}
		default: return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (23)");
	}
	
	// Upisivanje u bazu
	if (input != -99)
		valstr(inputtext, input);
		
	mysql_format(SQL, mysql_upit, 128, "UPDATE factions SET %s = '%s' WHERE id = %d", field_name, inputtext, f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
		
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "Izmenili ste polje \"%s\" za %s %s. Nova vrednost: %s", field_name, faction_name(f_id, FNAME_AKUZATIV), FACTIONS[f_id][f_naziv], inputtext);
	
	// Vracanje na prethodni dialog
	dialog_respond:org_config_info(playerid, 1, 0, "");
	
	// Upisivanje u log
	format(string_256, sizeof string_256, "%s | Izvrsio: %s | Polje: %s | %s » %s", FACTIONS[f_id][f_naziv], ime_obicno[playerid], field_name, old, inputtext);
	Log_Write(LOG_FACTIONS_EDIT, string_256);

	return 1;
}

Dialog:org_clanovi(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return showDialog_org_podaci_2(playerid, f_id);

	SetPVarString(playerid, "factionEditMember", inputtext);
		
	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], inputtext);
	SPD(playerid, "org_clanovi_edit_select", DIALOG_STYLE_LIST, naslov, "Informacije\nPromeni rank\nIzbaci", "Dalje »", "« Nazad");
		
	return 1;
}

Dialog:org_vozila(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_FNAME_LENGTH + 8]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return showDialog_org_podaci_2(playerid, f_id);

	faction_vehicles_edit_id[playerid] = faction_vehicles_listitem[playerid][listitem]; // slot

	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], imena_vozila[F_VEHICLES[f_id][faction_vehicles_edit_id[playerid]][fv_model_id] - 400]);
	SPD(playerid, "org_vozila_edit_select", DIALOG_STYLE_LIST, sTitle, "Parkiraj\nLociraj\nProdaj", "Dalje »", "« Nazad");
	return 1;
}

Dialog:org_vozila_edit_select(playerid, response, listitem, const inputtext[]) {
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_PLAYER_NAME + 8],
		slot = faction_vehicles_edit_id[playerid]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return d_org_podaci_2(playerid, 1, 2, "");

	switch (listitem) {
		case 0: { // Parkiraj
			new vehicleid = GetPlayerVehicleID(playerid);
			if (vehicleid != F_VEHICLES[f_id][slot][fv_vehicle_id])
				return ErrorMsg(playerid, "Ne nalazite se u izabranom vozilu.");

			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
				return ErrorMsg(playerid, "Morate biti na mestu vozaca da biste parkirali ovo vozilo.");
			
			if (IsPlayerInArea(playerid, 1524.091, -1373.938, 1801.698, -1144.969) == 1) 
				return ErrorMsg(playerid, "Ne mozete parkirati vozilo blizu spawna.");

			new
				Float:fuel, Float:hp;
			GetVehiclePos(vehicleid, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn]);
			GetVehicleZAngle(vehicleid, F_VEHICLES[f_id][slot][fv_a_spawn]);
			GetVehicleHealth(vehicleid, hp);
			F_VEHICLES[f_id][slot][fv_z_spawn] += 1.5;
			fuel = GetVehicleFuel(vehicleid);

			if (hp < 300.0)
				return ErrorMsg(playerid, "Ovo vozilo je previse osteceno! Da biste ga parkirali, najpre ga popravite.");
			
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
			
			DestroyVehicle(vehicleid);
			Iter_Remove(faction_vehicles, vehicleid);

			if (IsValidDynamic3DTextLabel(F_VEHICLES[f_id][slot][fv_label]))
			{
				DestroyDynamic3DTextLabel(F_VEHICLES[f_id][slot][fv_label]);
				F_VEHICLES[f_id][slot][fv_label] = Text3D:INVALID_3DTEXT_ID;
			}

			vehicleid = CreateVehicle(F_VEHICLES[f_id][slot][fv_model_id], F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], 1000);
			
			if(f_id == GetFactionIDbyName("Pink Panter"))
			{
				if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1373.891723, -14.869547, 1009.618957))
					SetVehicleVirtualWorld(vehicleid, 100040);
				
				else
					SetVehicleVirtualWorld(vehicleid, 0);
			}

			else if(f_id == GetFactionIDbyName("Escobar Cartel"))
			{
				if(IsVehicleInRangeOfPoint(vehicleid, 400.0, 1395.8326, -17.2343, 1000.8964))
					SetVehicleVirtualWorld(vehicleid, 56000);
					
				else
					SetVehicleVirtualWorld(vehicleid, 0);
			}

			Iter_Add(faction_vehicles, vehicleid);


			//new sLabel[36];
			//format(sLabel, sizeof sLabel, "[ %s ]", FACTIONS[f_id][f_tag]);
			//F_VEHICLES[f_id][slot][fv_label] = CreateDynamic3DTextLabel(sLabel, HexToInt(FACTIONS[f_id][f_hex]), 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, vehicleid);
			

			SetVehicleFuel(vehicleid, fuel);
			F_VEHICLES[f_id][slot][fv_vehicle_id] = vehicleid;

			if (!IsVehicleHelicopter(vehicleid) && !IsVehicleBoat(vehicleid) && !IsVehicleBicycle(vehicleid)) {
				format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);
				SetVehicleNumberPlate(vehicleid, sTitle);
				SetVehicleToRespawn(vehicleid);
			}
			SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
			PutPlayerInVehicle(playerid, vehicleid, 0);

			format(mysql_upit, sizeof mysql_upit, "UPDATE factions_vehicles SET spawn = '%.4f|%.4f|%.4f|%.4f' WHERE id = %d", F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn], F_VEHICLES[f_id][slot][fv_mysql_id]);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);

			SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Vozilo je uspesno parkirano.", FACTIONS[f_id][f_tag]);
		}
		
		case 1: { // Lociraj
			new Float:poz[3];
			GetVehiclePos(F_VEHICLES[f_id][slot][fv_vehicle_id], poz[POS_X], poz[POS_Y], poz[POS_Z]);
			SetGPSLocation(playerid, poz[POS_X], poz[POS_Y], poz[POS_Z], "lokacija vozila");
		}

		case 2: // Prodaj
		{
			format(string_64, 45, "{%s}%s - PRODAJA", FACTIONS[f_id][f_rgb], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id] - 400]);
			format(string_256, 200, "{FFFFFF}Model: {%s}%s\n{FFFFFF}Vrednost: {%s}$%d\n\nDa li zaista zelite da prodate ovo vozilo za {%s}$%d?", FACTIONS[f_id][f_rgb], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id] - 400], FACTIONS[f_id][f_rgb], F_VEHICLES[f_id][slot][fv_cena], FACTIONS[f_id][f_rgb], (F_VEHICLES[f_id][slot][fv_cena]/3)*2);
			SPD(playerid, "org_vozila_prodaj", DIALOG_STYLE_MSGBOX, string_64, string_256, "Da", "Ne");
		}
	}

	return 1;
}

Dialog:org_vozila_prodaj(playerid, response, listitem, const inputtext[]) {
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		slot = faction_vehicles_edit_id[playerid]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return d_org_podaci_2(playerid, 1, 2, "");

	if (F_VEHICLES[f_id][slot][fv_vehicle_id] == -1)
		return ErrorMsg(playerid, "[factions.pwn] "GRESKA_NEPOZNATO" (24)");

	if (F_VEHICLES[f_id][slot][fv_prodaja] == 0)
		return ErrorMsg(playerid, "Prodaja ovog vozila nije dozvoljena. Mozete prodati samo ona vozila koja ste kupili.");


	// Unistavanje vozila
	DestroyVehicle(F_VEHICLES[f_id][slot][fv_vehicle_id]);
	Iter_Remove(faction_vehicles, F_VEHICLES[f_id][slot][fv_vehicle_id]);
	F_VEHICLES[f_id][slot][fv_vehicle_id] = -1;

	if (IsValidDynamic3DTextLabel(F_VEHICLES[f_id][slot][fv_label]))
	{
		DestroyDynamic3DTextLabel(F_VEHICLES[f_id][slot][fv_label]);
		F_VEHICLES[f_id][slot][fv_label] = Text3D:INVALID_3DTEXT_ID;
	}


	// Dodavanje novca
	FactionMoneyAdd(f_id, F_VEHICLES[f_id][slot][fv_cena]/3*2);


	// Poruke
	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Prodali ste vozilo {%s}%s {FFFFFF}za {%s}$%d.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id]- 400], FACTIONS[f_id][f_rgb], F_VEHICLES[f_id][slot][fv_cena]/3*2);
	FactionMsg(f_id, "{FFFFFF}%s je prodao vozilo: {%s}%s.", ime_rp[playerid], FACTIONS[f_id][f_rgb], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id]- 400]);

	// Brisanje vozila iz baze
	format(mysql_upit, sizeof mysql_upit, "DELETE FROM factions_vehicles WHERE id = %d", F_VEHICLES[f_id][slot][fv_mysql_id]);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_DELETE);

	// Upisivanje u log 2 - mysql
	format(mysql_upit, 145, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je prodao vozilo: %s.')", f_id, ime_obicno[playerid], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id]- 400]);
	mysql_pquery(SQL, mysql_upit);

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | PRODAJA | %s | %s | $%d", FACTIONS[f_id][f_tag], ime_obicno[playerid], imena_vozila[F_VEHICLES[f_id][slot][fv_model_id]- 400], F_VEHICLES[f_id][slot][fv_cena]/3*2);
	Log_Write(LOG_FACTIONS_BUYSELLVEH, string_128);

	return 1;
}

Dialog:org_clanovi_edit_select(playerid, response, listitem, const inputtext[]) 
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_PLAYER_NAME + 8],
		sPlayerName[MAX_PLAYER_NAME]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response) 
		return d_org_podaci_2(playerid, 1, 1, ""); // Pokazuje spisak clanova
	
	
	GetPVarString(playerid, "factionEditMember", sPlayerName, sizeof sPlayerName);
	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], sPlayerName);
	
	switch (listitem)
	{
		case 0: // Informacije
		{
			new sQuery[400];
			format(sQuery, sizeof sQuery, "SELECT igraci.org_id, igraci.nivo, igraci.kaznjen_puta, igraci.org_vreme, DATE_FORMAT(igraci.poslednja_aktivnost, '\%%d \%%b, \%%H:\%%i') as last_act, igraci.skill_%s as skill, DATE_FORMAT(date_sub(fm.kazna_limit,interval %d day), '\%%d \%%b, \%%H:\%%i') as join_date FROM igraci INNER JOIN factions_members fm ON fm.player_id = igraci.id WHERE igraci.ime = '%s'", (FACTIONS[f_id][f_vrsta]==FACTION_LAW? ("cop") : ("criminal")), FACTIONS_CONTRACT_TIME/86400, sPlayerName);
			mysql_tquery(SQL, sQuery, "MySQL_FactionMemberInfo", "isii", playerid, sPlayerName, f_id, cinc[playerid]);
		}

		case 1: // Promeni rank
		{
			ErrorMsg(playerid, "Promena ranka je onemogucena. Rank se automatski dodeljuje na osnovu skill-a.");
			DialogReopen(playerid);
		}

		case 2: // Izbaci
		{
			F_IZMENA[playerid][IZMENA_ITEM] = IZMENA_IZBACI;
			
			new sDialog[124];
			format(sDialog, sizeof sDialog, "{FFFFFF}Igrac: {%s}%s\n\n{FF0000}Zelite li da izbacite ovog clana iz {%s}%s?", FACTIONS[f_id][f_rgb], sPlayerName, FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);
				
			SPD(playerid, "org_clanovi_izmeni", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Da", "Nazad");
		}
	}
	
	return 1;
}

Dialog:org_clanovi_info(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_PLAYER_NAME + 8],
		sPlayerName[MAX_PLAYER_NAME]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	GetPVarString(playerid, "factionEditMember", sPlayerName, sizeof sPlayerName);
	format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], sPlayerName);
	return SPD(playerid, "org_clanovi_edit_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nPromeni rank\nIzbaci", "Dalje »", "« Nazad");
}

Dialog:org_clanovi_izmeni(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[MAX_PLAYER_NAME + 8],
		sPlayerName[MAX_PLAYER_NAME]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	GetPVarString(playerid, "factionEditMember", sPlayerName, sizeof sPlayerName);
	if (!response)
	{
		format(sTitle, sizeof(sTitle), "{%s}%s", FACTIONS[f_id][f_rgb], sPlayerName);
		return SPD(playerid, "org_clanovi_edit_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nPromeni rank\nIzbaci", "Dalje »", "« Nazad");
	}
	
	
	switch (F_IZMENA[playerid][IZMENA_ITEM])
	{
		case IZMENA_RANK: // Rank
		{
			ErrorMsg(playerid, "Promena ranka je onemogucena. Rank se automatski dodeljuje na osnovu skill-a.");
			SPD(playerid, "org_clanovi_edit_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nPromeni rank\nIzbaci", "Dalje »", "« Nazad");
		}
		case IZMENA_IZBACI: // Potvrda izbacivanja
		{
			// Proveravamo da li lider pokusava da izbaci drugog lidera
			if (!IsAdmin(playerid, 5) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
			{
				if (!strcmp(F_LEADERS[f_id][0], sPlayerName) || !strcmp(F_LEADERS[f_id][1], sPlayerName))
					return ErrorMsg(playerid, "Lidera moze da izbaci samo Head Admin ili Vodja lidera.");
			}
			

			// Brisanje iz baze
			{
				new sQuery[135];
				mysql_format(SQL, sQuery, sizeof sQuery, "DELETE FROM factions_members WHERE faction_id = %d AND player_id = (SELECT id FROM igraci WHERE ime = '%s')", f_id, sPlayerName);
				mysql_tquery(SQL, sQuery);
			}
			
			// Slanje poruke adminu/lideru
			SendClientMessageF(playerid, SVETLOPLAVA, "* Izbacili ste clana %s iz %s %s.", sPlayerName, faction_name(f_id, FNAME_GENITIV), FACTIONS[f_id][f_naziv]);
			
			// Slanje poruke igracu (ako je online) + izmena varijabli
			new targetid = get_player_id(sPlayerName);
			if (IsPlayerConnected(targetid) && PI[targetid][p_org_id] == f_id)
			{
				// Slanje poruke
				SendClientMessageF(targetid, SVETLOCRVENA, "* Izbaceni ste iz %s %s od %s.", faction_name(f_id, FNAME_GENITIV), FACTIONS[f_id][f_naziv], ime_rp[playerid]);

				/*if(strlen(PI[targetid][p_discord_id]) > 5) 
				{
					if(PI[targetid][p_org_id] == 0) { removePlayerDiscRole(PI[targetid][p_discord_id], "lspd"); }
					else if(PI[targetid][p_org_id] == 1) { removePlayerDiscRole(PI[targetid][p_discord_id], "lcn");}
					else if(PI[targetid][p_org_id] == 2) { removePlayerDiscRole(PI[targetid][p_discord_id], "sb");}
					else if(PI[targetid][p_org_id] == 3) { removePlayerDiscRole(PI[targetid][p_discord_id], "gsf");}
				}*/
				
				// Izmena varijabli
				PI[targetid][p_org_id]    = -1;
				PI[targetid][p_org_rank]  = -1;
				PI[targetid][p_org_vreme] =  0;
				PI[targetid][p_skill_cop] = 0;
				PI[targetid][p_skill_criminal] = 0;
				PI[targetid][p_skin] = GetRandomCivilianSkin(PI[targetid][p_pol]);

				SetPlayerSkin(targetid, PI[targetid][p_skin]);
				ChatDisableForPlayer(targetid, CHAT_FACTION);
				ChatDisableForPlayer(targetid, CHAT_DEPARTMENT);

				dialog_respond:spawn(targetid, 1, 0, ""); // Postavlja spawn na default

				// Update podataka u bazi
				new sQuery[110];
				format(sQuery, sizeof sQuery, "UPDATE igraci SET org_id = -1, org_vreme = 0, skin = %i, skill_criminal = 0, skill_cop = 0 WHERE id = %d", PI[targetid][p_skin], PI[targetid][p_id]);
				mysql_tquery(SQL, sQuery);
			}
			
			// Igracevi podaci u bazi se ne menjaju jer ce automatski da se updateuju kad bude usao u igru
			
			// Ako je bio lider, izbrisati ga iz F_LEADERS
			if (!strcmp(F_LEADERS[f_id][0], sPlayerName))
				strmid(F_LEADERS[f_id][0], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
			if (!strcmp(F_LEADERS[f_id][1], sPlayerName))
				strmid(F_LEADERS[f_id][1], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);

			FACTIONS[f_id][f_clanovi] --;

			Faction_UpdateEntranceLabel(f_id);
			
			// Upisivanje u log
			new sLog[125];
			format(sLog, sizeof sLog, "%s | IZBACIVANJE | Izvrsio: %s | Igrac: %s", FACTIONS[f_id][f_naziv], ime_obicno[playerid], sPlayerName);
			Log_Write(LOG_FACTIONS_MEMBERS, sLog);

			// Upisivanje u log 2 - mysql
			new sQuery[125];
			format(sQuery, sizeof sQuery, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je izbacio %s.')", f_id, ime_obicno[playerid], sPlayerName);
			mysql_pquery(SQL, sQuery);
			
			d_org_podaci_2(playerid, 1, 1, ""); // Pokazuje spisak clanova
		}
		default: return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (25)");
	}

	return 1;
}



Dialog:org_ubaci(playerid, response, listitem, const inputtext[]) 
{
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] == -1 || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		id
	;

	if (!response)
		return showDialog_org_podaci_2(playerid, f_id);
	
	if (sscanf(inputtext, "u", id))
		return DialogReopen(playerid);    
		
	if (!IsPlayerConnected(id)) {
		ErrorMsg(playerid, GRESKA_OFFLINE);
		return DialogReopen(playerid);    
	}

	if (!IsPlayerNearPlayer(playerid, id) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
		return ErrorMsg(playerid, "Morate biti blizu tog igraca.");
		
	// if (PI[id][p_nivo] < 2) 
	//     return ErrorMsg(playerid, "Taj igrac nema dovoljno visok nivo.");
		
	if (PI[id][p_org_id] == f_id)
		return ErrorMsg(playerid, "Taj igrac je vec clan ove organizacije.");
		
	if (PI[id][p_org_id] != -1)
		return ErrorMsg(playerid, "Taj igrac je vec clan neke druge organizacije.");
		
	if (PI[id][p_org_kazna] > gettime())
		return ErrorMsg(playerid, "Taj igrac ima zabranu ulaska u organizaciju/mafiju/bandu.");

	if (PI[id][p_provedeno_vreme] < 10*3600)
		return ErrorMsg(playerid, "Taj igrac mora imati najmanje 10 sati igre da bi usao u neku organizaciju.");
		
	// Trazenje slobodnog slota
	if (FACTIONS[f_id][f_clanovi] >= FACTIONS[f_id][f_max_clanova])
		return ErrorMsg(playerid, "Nema slobodnih slotova.");
		
	// Dodati potvrdu dialogom za igraca koji se poziva
	new string[320];
	format(string, sizeof(string), "{FFFFFF}%s %s Vas je pozvao da se pridruzite %s {%s}%s.\n\n{FFFFFF}Ukoliko samovoljno napustite %s u prvih {FF0000}%d dana {FFFFFF}bicete automatski kaznjeni.", ((PI[playerid][p_org_id] == f_id)? ("Lider") : ("Game Admin")), ime_rp[playerid], faction_name(f_id, FNAME_DATIV), FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], faction_name(f_id, FNAME_AKUZATIV), FACTIONS_CONTRACT_TIME/86400);
	format(string, sizeof(string), "%s\nKazna ukljucuje zabranu ulaska u bilo koju organizaciju/mafiju/bandu, kao i placanje novcane kazne.", string);
	SPD(id, "org_ubaci_odgovor", DIALOG_STYLE_MSGBOX, "Poziv za pridruzivanje", string, "Prihvati", "Odbij");
	
	f_pozvan[id] = f_id;
	strmid(f_pozvan_ime[id], ime_rp[playerid], 0, strlen(ime_rp[playerid]), MAX_PLAYER_NAME);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Poslali ste zahtev za pridruzivanje %s igracu {FFFFFF}%s.", faction_name(f_id, FNAME_DATIV), ime_rp[id]);
		
	return 1;
}

Dialog:org_ubaci_odgovor(playerid, response, listitem, const inputtext[])
{
	if (f_pozvan[playerid] == -1)
		return 1;
		
		
	new 
		targetid = get_player_id(f_pozvan_ime[playerid], rp_ime),
		f_id = f_pozvan[playerid];
	
	if (!response) { // Odbio da se pridruzi
		// Slanje poruke igracu
		SendClientMessageF(playerid, ZUTA, "* Odbili ste da se pridruzite %s.", faction_name(f_id, FNAME_DATIV));
		
		// Slanje poruke adminu/lideru
		if (IsPlayerConnected(targetid)) 
		{
			format(string_64, 64, "Igrac %s je odbio da se pridruzi %s.", ime_rp[playerid], faction_name(f_id, FNAME_DATIV));
			InfoMsg(targetid, string_64);
		}
		
		// Resetovanje varijabli
		f_pozvan[playerid] = -1;
		f_pozvan_ime[playerid][0] = EOS;
		
		// Upisivanje u log
		new sLog[128];
		format(sLog, sizeof sLog, "%s | UBACIVANJE (X) | Izvrsio: %s | Igrac: %s", FACTIONS[f_id][f_naziv], f_pozvan_ime[playerid], ime_obicno[playerid]);
		Log_Write(LOG_FACTIONS_MEMBERS, sLog);

		// Upisivanje u log 2 - mysql
		new sQuery[256];
		format(sQuery, sizeof sQuery, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je odbio da se pridruzi %s.')", f_id, ime_obicno[playerid], faction_name(f_id, FNAME_DATIV));
		mysql_pquery(SQL, sQuery);
	}

	else // Prihvatio poziv
	{
		// Trazenje slobodnih slotova
		if (FACTIONS[f_id][f_clanovi] >= FACTIONS[f_id][f_max_clanova])
			return ErrorMsg(playerid, "Nema slobodnih slotova.");
			
		// Da li ima zabranu za ulazak?
		if (PI[playerid][p_org_kazna] > gettime())
			return ErrorMsg(playerid, "Imate zabranu ulaska u organizaciju/mafiju/bandu.");

		/*if(strlen(PI[playerid][p_discord_id]) > 5) 
		{
			if(f_id== 0) { setPlayerDiscRole(PI[playerid][p_discord_id], "lspd"); }
			else if(f_id == 1) { setPlayerDiscRole(PI[playerid][p_discord_id], "lcn");}
			else if(f_id == 2) { setPlayerDiscRole(PI[playerid][p_discord_id], "sb");}
			else if(f_id == 3) { setPlayerDiscRole(PI[playerid][p_discord_id], "gsf");}
		}*/
		
		//Provjera da li je igrac lider
		/*new lider[ MAX_PLAYERS ];
		if( PI[ playerid ][ p_org_rank ] == RANK_LEADER )
		{
		    lider[ playerid ] = 1;
		}
		else { lider[ playerid ] = 0; }*/

		// Upisivanje podataka u varijable
		PI[playerid][p_org_id]    = f_id;
		printf("fid %i", f_id);
		PI[playerid][p_org_rank]  = 1;
		f_ts_initial[playerid]    = gettime();
		PI[playerid][p_org_vreme] = 0;
		if (!IsACop(playerid)) PI[playerid][p_skin] = -1;

		// /f, /r, /d chat enable
		ChatEnableForPlayer(playerid, CHAT_FACTION);
		if (IsACop(playerid)) ChatEnableForPlayer(playerid, CHAT_DEPARTMENT);
		
		// Upisivanje u bazu (igrac)
		new sQuery[256];
		format(sQuery, sizeof sQuery, "UPDATE igraci SET org_id = %i, org_rank = %i, org_vreme = 0, org_kazna = FROM_UNIXTIME(0), skin = %i WHERE id = %i", f_id, PI[playerid][p_org_rank], PI[playerid][p_skin], PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery);

		// Upisivanje u bazu (org)
		new sQuery3[ 256 ];
		format(sQuery3, sizeof sQuery3, "INSERT INTO factions_members (faction_id, player_id, lider ) VALUES (%d, %d, 0)", f_id, PI[playerid][p_id] );
		mysql_tquery(SQL, sQuery3);

		// new sQuery_2[140];
		// format(sQuery_2, sizeof sQuery_2, "SELECT DATE_FORMAT(kazna_limit, '\%%d \%%b, \%%H:\%%i') as kazna_str FROM factions_members WHERE faction_id = %d AND player_id = %d", f_id, PI[playerid][p_id]);
		// mysql_tquery(SQL, sQuery_2, "mysql_factions_kazna_limit", "ii", f_id, PI[playerid][p_id]);
		
		// Slanje poruke svim clanovima organizacije
		FactionMsg(f_id, "{FBC800}%s se upravo pridruzio %s. (pozvan od strane %s)", ime_rp[playerid], faction_name(f_id, FNAME_DATIV), f_pozvan_ime[playerid]);
		
		// Slanje poruke igracu koji je pozvao, ukoliko on nije lider/clan te organizacije, nego admin
		if (IsPlayerConnected(targetid) && PI[targetid][p_org_id] != f_id) 
		{
			SendClientMessageF(targetid, SVETLOPLAVA, "* Igrac %s je prihvatio Vas poziv za %s.", ime_rp[playerid], FACTIONS[f_id][f_tag]);
		}


		FACTIONS[f_id][f_clanovi] ++;
		
		SetPlayerSkin(playerid, GetPlayerCorrectSkin(playerid));
		
		// Upisivanje u log
		new sLog[124];
		format(sLog, sizeof sLog, "%s | UBACIVANJE | Izvrsio: %s | Igrac: %s", FACTIONS[f_id][f_naziv], f_pozvan_ime[playerid], ime_obicno[playerid]);
		Log_Write(LOG_FACTIONS_MEMBERS, sLog);

		// Upisivanje u log 2 - mysql
		new sQuery_2[145];
		format(sQuery_2, sizeof sQuery_2, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s se pridruzio %s (pozvao %s).')", f_id, ime_obicno[playerid], faction_name(f_id, FNAME_DATIV), f_pozvan_ime[playerid]);
		mysql_pquery(SQL, sQuery_2);
	}
	
	return 1;
}

Dialog:org_rankovi(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[32],
		r_id
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return showDialog_org_podaci_2(playerid, f_id);
	
	switch (listitem)
	{
		case 0: // Kreiraj novi rank
		{
			if (!IsAdmin(playerid, 6))
			{
				ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
				return DialogReopen(playerid);
			}
			
			SPD(playerid, "org_novi_rank_id", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [1/3]", "{FFFFFF}Upisite ID/visinu ranka:", "Dalje »", "« Nazad");
		}
		default: // Izmena nekog od postojecih rankova
		{
			r_id = faction_ranks_listitem[playerid][listitem];
			faction_ranks_editing[playerid] = r_id;
			
			format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
			SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
		}
	}
	
	return 1;
}

Dialog:org_novi_rank_id(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		input
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return dialog_respond:org_podaci_2(playerid, 1, 4, "");
		
	if (sscanf(inputtext, "i", input))
		return SPD(playerid, "org_novi_rank_id", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [1/3]", "{FFFFFF}Upisite ID/visinu ranka:", "Dalje »", "« Nazad");
		
	if (input < 0 || input > RANK_LEADER)
		return SPD(playerid, "org_novi_rank_id", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [1/3]", "{FFFFFF}Upisite ID/visinu ranka:", "Dalje »", "« Nazad");
		
	if (F_RANKS[f_id][input][fr_dozvole] != 0)
	{
		ErrorMsg(playerid, "Taj rank je vec kreiran.");
		return SPD(playerid, "org_novi_rank_id", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [1/3]", "{FFFFFF}Upisite ID/visinu ranka:", "Dalje »", "« Nazad");
	}
		
	faction_ranks_id[playerid] = input;
	
	format(string_128, sizeof string_128, "{FFFFFF}Rank: {%s}%d\n\n{FFFFFF}Upisite naziv za ovaj rank (max. 16 slova):", FACTIONS[f_id][f_rgb], faction_ranks_id[playerid]);
	SPD(playerid, "org_novi_rank_naziv", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [2/3]", string_128, "Gotovo", "Nazad");

	return 1;
}
Dialog:org_novi_rank_naziv(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID]
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return SPD(playerid, "org_novi_rank_id", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [1/3]", "{FFFFFF}Upisite ID/visinu ranka:", "Dalje »", "« Nazad");
		
	if (sscanf(inputtext, "s[" #MAX_RANK_LENGTH "]", inputtext) || strlen(inputtext) > MAX_RANK_LENGTH)
		return DialogReopen(playerid);
	
	// for__loop (new i = 0; i < MAX_FACTIONS_RANKS; i++)
	// {
	//     if (!isnull(F_RANKS[f_id][i][fr_ime]) && !strcmp(F_RANKS[f_id][i][fr_ime], inputtext, true))
	//     {
	//         ErrorMsg(playerid, "Vec postoji rank sa istim imenom.");
	//         return DialogReopen(playerid);
	//     }
	// }
	
	strmid(faction_ranks_ime[playerid], inputtext, 0, strlen(inputtext), MAX_RANK_LENGTH);
	
	format(string_128, sizeof string_128, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Ime: {%s}%s\n\n{FFFFFF}Upisite ID skina a ovaj rank:", FACTIONS[f_id][f_rgb], faction_ranks_id[playerid], FACTIONS[f_id][f_rgb], inputtext);
	SPD(playerid, "org_novi_rank_skin", DIALOG_STYLE_INPUT, "{0068B3}Novi rank [3/3]", string_128, "Gotovo", "Nazad");
	
	return 1;
}

Dialog:org_novi_rank_skin(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		naslov[MAX_FNAME_LENGTH + 8],
		r_id,
		input
	;
	r_id = faction_ranks_id[playerid];
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
	{
		new str[6];
		valstr(str, faction_ranks_id[playerid]);
		return dialog_respond:org_novi_rank_id(playerid, 1, 0, str);
	}
	
	if (sscanf(inputtext, "i", input))
		//return dialog_respond:org_novi_rank_naziv(playerid, 1, 0, faction_ranks_ime[playerid]);
		return DialogReopen(playerid);
		
	if (input < 0 || input > 311)
		//return dialog_respond:org_novi_rank_naziv(playerid, 1, 0, faction_ranks_ime[playerid]);
		return DialogReopen(playerid);
	
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_ranks VALUES (%d, %d, '%s', %d, 0)", f_id, r_id, faction_ranks_ime[playerid], input);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_INSERT);
	
	F_RANKS[f_id][r_id][fr_dozvole] = 0;
	F_RANKS[f_id][r_id][fr_skin]    = input;
	strmid(F_RANKS[f_id][r_id][fr_ime], faction_ranks_ime[playerid], 0, strlen(faction_ranks_ime[playerid]), MAX_RANK_LENGTH);
	
	// Slanje poruke igracu
	format(string_128, sizeof string_128, "* Uspesno ste kreirali novi rank (%d): %s.", r_id, faction_ranks_ime[playerid]);
	SendClientMessage(playerid, SVETLOPLAVA, string_128);
	
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | NOVI RANK | Izvrsio: %s | ID: %d | Naziv: %s | Skin: %d", FACTIONS[f_id][f_naziv], ime_obicno[playerid], r_id, faction_ranks_ime[playerid], input);
	Log_Write(LOG_FACTIONS_RANKS, string_128);
	
	faction_ranks_editing[playerid] = r_id;
	format(naslov, sizeof(naslov), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
	SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	
	return 1;
}

Dialog:org_rank_izmena_select(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[32],
		r_id
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response)
		return dialog_respond:org_podaci_2(playerid, 1, 4, "");
		
		
	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (26)");
	
	
	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
	switch (listitem)
	{
		case 0: // Informacije
		{
			new 
				dozvole = F_RANKS[f_id][r_id][fr_dozvole]
			;
			
			
			new sDialog[352];
			format(sDialog, sizeof sDialog, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Naziv: {%s}%s\n\n{FFFFFF}Upotreba chata: {%s}%s\n{FFFFFF}Upotreba vozila: {%s}%s\n{FFFFFF}Spawn u bazi: {%s}%s\n{FFFFFF}Ulaz u enterijer: {%s}%s\n{FFFFFF}Ulaz u oruzarnicu: {%s}%s\n{FFFFFF}Kupovina u oruzarnici: {%s}%s",
				FACTIONS[f_id][f_rgb], r_id, 
				FACTIONS[f_id][f_rgb], F_RANKS[f_id][r_id][fr_ime], 
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_CHAT)? ("Da") : ("Ne")), 
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_VOZILA)? ("Da") : ("Ne")),
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_SPAWN)? ("Da") : ("Ne")), 
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_ENT)? ("Da") : ("Ne")), 
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_O_ULAZ)? ("Da") : ("Ne")),
				FACTIONS[f_id][f_rgb], ((dozvole & DOZVOLA_O_KUPOVINA)? ("Da") : ("Ne")));
			SPD(playerid, "org_rank_info", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");
		}
		case 1: // Izmeni naziv ranka
		{
			if (!IsAdmin(playerid, 6))
			{
				ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
				return DialogReopen(playerid);
			}
			
			new sDialog[128];
			format(sDialog, sizeof sDialog, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Naziv: {%s}%s\n\n{FFFFFF}Upisite novi naziv za ovaj rank:", FACTIONS[f_id][f_rgb], r_id, FACTIONS[f_id][f_rgb], F_RANKS[f_id][r_id][fr_ime]);
			SPD(playerid, "org_rank_izmena_naziv", DIALOG_STYLE_INPUT, sTitle, sDialog, "Izmeni", "Nazad");
		}
		case 2: // Izmeni skin
		{
			if (!IsAdmin(playerid, 6))
			{
				ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
				return DialogReopen(playerid);
			}
			
			new sDialog[100];
			format(sDialog, sizeof sDialog, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Skin: {%s}%d\n\n{FFFFFF}Upisite ID novog skina za ovaj rank:", FACTIONS[f_id][f_rgb], r_id, FACTIONS[f_id][f_rgb], F_RANKS[f_id][r_id][fr_skin]);
			SPD(playerid, "org_rank_izmena_skin", DIALOG_STYLE_INPUT, sTitle, sDialog, "Izmeni", "Nazad");
		}
		case 3: // Izmeni dozvole
		{
			new sDialog[138],
				dozvole = F_RANKS[f_id][r_id][fr_dozvole];
			
			format(sDialog, sizeof sDialog, "Pregled dozvola\n{%s}Chat\n{%s}Vozila\n{%s}Spawn\n{%s}Enterijer\n{%s}Oruzarnica (ulaz)\n{%s}Oruzarnica (kupovina)",
				((dozvole & DOZVOLA_CHAT)? ("41C72E") : ("C82E40")), ((dozvole & DOZVOLA_VOZILA)? ("41C72E") : ("C82E40")), 
				((dozvole & DOZVOLA_SPAWN)? ("41C72E") : ("C82E40")), ((dozvole & DOZVOLA_ENT)? ("41C72E") : ("C82E40")), 
				((dozvole & DOZVOLA_O_ULAZ)? ("41C72E") : ("C82E40")), ((dozvole & DOZVOLA_O_KUPOVINA)? ("41C72E") : ("C82E40")));
			SPD(playerid, "org_rank_izmena_dozvole", DIALOG_STYLE_LIST, sTitle, sDialog, "Izmeni", "Nazad");
		}
		case 4: // Izbrisi rank
		{
			if (!IsAdmin(playerid, 6))
			{
				ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
				return DialogReopen(playerid);
			}
			
			new sDialog[136];
			format(sDialog, sizeof sDialog, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Naziv: {%s}%s\n\n{FFFFFF}Zelite li zaista da izbrisete ovaj rank?", FACTIONS[f_id][f_rgb], r_id, FACTIONS[f_id][f_rgb], F_RANKS[f_id][r_id][fr_ime]);
			SPD(playerid, "org_rank_brisanje", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Izbrisi", "Nazad");
		}
	}

	return 1;
}

Dialog:org_rank_info(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[24],
		r_id
	;
	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (27)");
		
	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
	SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	return 1;
}

Dialog:org_rank_izmena_naziv(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[24],
		r_id
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (28)");

	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
		
	if (!response)
		return SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	
	if (sscanf(inputtext, "s[" #MAX_RANK_LENGTH "]", inputtext) || strlen(inputtext) > MAX_RANK_LENGTH)
		return DialogReopen(playerid);
	
	// Update podataka u bazi
	mysql_format(SQL, mysql_upit, 128, "UPDATE factions_ranks SET ime = '%s' WHERE faction_id = %d AND rank_id = %d", inputtext, f_id, r_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste izmenili ime ranka %d | %s » %s", r_id, F_RANKS[f_id][r_id][fr_ime], inputtext);
	
	// Upisivanje u log
	new sLog[165];
	format(sLog, sizeof sLog, "%s | IME | Izvrsio: %s | Rank: %d | %s » %s", FACTIONS[f_id][f_naziv], ime_obicno[playerid], r_id, F_RANKS[f_id][r_id][fr_ime], inputtext);
	Log_Write(LOG_FACTIONS_RANKS, sLog);
	
	strmid(F_RANKS[f_id][r_id][fr_ime], inputtext, 0, strlen(inputtext), MAX_RANK_LENGTH);

	SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	
	return 1;
}

Dialog:org_rank_izmena_skin(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[32],
		r_id,
		input
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
		
	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (29)");
	
	
	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
		
	if (!response)
		return SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	
	if (sscanf(inputtext, "i", input) || input < 0 || input > 311)
	{
		new sDialog[100];
		format(sDialog, sizeof sDialog, "{FFFFFF}Rank: {%s}%d\n{FFFFFF}Skin: {%s}%d\n\n{FFFFFF}Upisite ID novog skina za ovaj rank:", FACTIONS[f_id][f_rgb], r_id, FACTIONS[f_id][f_rgb], F_RANKS[f_id][r_id][fr_skin]);
		SPD(playerid, "org_rank_izmena_skin", DIALOG_STYLE_INPUT, sTitle, sDialog, "Izmeni", "Nazad");
		
		return 1;
	}
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE factions_ranks SET skin = %d WHERE faction_id = %d AND rank_id = %d", input, f_id, r_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste izmenili skin ranka %d | %d » %d", r_id, F_RANKS[f_id][r_id][fr_skin], input);
	
	// Upisivanje u log
	new sLog[102];
	format(sLog, sizeof sLog, "%s | SKIN | Izvrsio: %s | Rank: %d | %d » %d", FACTIONS[f_id][f_naziv], ime_obicno[playerid], r_id, F_RANKS[f_id][r_id][fr_skin], input);
	Log_Write(LOG_FACTIONS_RANKS, sLog);
	
	F_RANKS[f_id][r_id][fr_skin] = input;
	
	// Izmena skina svim online igracima sa tim rankom
	foreach (new i : Player) 
	{
		if (PI[i][p_org_id] == f_id && PI[i][p_org_rank] == r_id) 
		{
			SetPlayerSkin(i, GetPlayerCorrectSkin(i));
		}
	}

	SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
	
	return 1;
}

Dialog:org_rank_izmena_dozvole(playerid, response, listitem, const inputtext[])
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[32],
		r_id
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (30)");
		
		
	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
		
	if (!response)
		return SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
		
	new
		status = -1,
		dozvola[22]
	;
	
	switch (listitem)
	{
		case 0: // Pregled dozvola
		{
			return dialog_respond:org_rank_izmena_select(playerid, 1, 0, "");
		}
		case 1: // Chat
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_CHAT) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_CHAT, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_CHAT, status = 1;
				
			dozvola = "Upotreba chata";
		}
		case 2: // Vozila
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_VOZILA) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_VOZILA, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_VOZILA, status = 1;
				
			dozvola = "Upotreba vozila";
		}
		case 3: // Spawn
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_SPAWN) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_SPAWN, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_SPAWN, status = 1;
				
			dozvola = "Spawn u bazi";
		}
		case 4: // Enterijer
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_ENT) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_ENT, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_ENT, status = 1;
				
			dozvola = "Ulaz u enterijer";
		}
		case 5: // Oruzarnica (ulaz)
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_O_ULAZ) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_O_ULAZ, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_O_ULAZ, status = 1;
				
			dozvola = "Ulaz u oruzarnicu";
		}
		case 6: // Oruzarnica (kupovina)
		{
			if (F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_O_KUPOVINA) // Dozvola postoji -> oduzmi
				F_RANKS[f_id][r_id][fr_dozvole] ^= DOZVOLA_O_KUPOVINA, status = 0;
			else // Dozvola ne postoji -> dodaj
				F_RANKS[f_id][r_id][fr_dozvole] |= DOZVOLA_O_KUPOVINA, status = 1;
				
			dozvola = "Kupovina u oruzarnici";
		}
	}
	
	// Cuvanje u bazu
	new sQuery[88];
	format(sQuery, sizeof sQuery, "UPDATE factions_ranks SET dozvole = %d WHERE faction_id = %d AND rank_id = %d", F_RANKS[f_id][r_id][fr_dozvole], f_id, r_id);
	mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_UPDATE);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* %s ste dozvolu \"%s\" ranku %d (%s).", ((status == 0)? ("Oduzeli") : ("Dodali")), dozvola, r_id, F_RANKS[f_id][r_id][fr_ime]);
	
	// Upisivanje u log
	new sLog[118];
	format(sLog, sizeof sLog, "%s | DOZVOLA %s | Izvrsio: %s | Dozvola: %s", FACTIONS[f_id][f_naziv], ((status == 0)? ("ODUZETA") : ("DODATA")), ime_obicno[playerid], dozvola);
	Log_Write(LOG_FACTIONS_RANKS, sLog);

	dialog_respond:org_rank_izmena_select(playerid, 1, 3, ""); // Vraca na dialog s dozvolama

	return 1;
}

Dialog:org_rank_brisanje(playerid, response, listitem, const inputtext[]) 
{
	new
		f_id = F_IZMENA[playerid][IZMENA_ID],
		sTitle[32],
		r_id
	;
	
	if (!IsAdmin(playerid, 1) && (PI[playerid][p_org_id] != f_id || PI[playerid][p_org_rank] != RANK_LEADER))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	r_id = faction_ranks_editing[playerid];
	if (r_id < 0 || r_id > RANK_LEADER)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (31)");
	
	format(sTitle, sizeof(sTitle), "{%s}Izmena ranka %d", FACTIONS[f_id][f_rgb], r_id);
	
	if (!response)
		return SPD(playerid, "org_rank_izmena_select", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni ime ranka\nIzmeni skin\nIzmeni dozvole\nIzbrisi rank", "Dalje »", "« Nazad");
		
	// Brisanje iz baze
	new sQuery[256];
	format(sQuery, sizeof sQuery, "DELETE FROM factions_ranks WHERE faction_id = %d AND rank_id = %d", f_id, r_id);
	mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_FACTION_DELETE);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Izbrisali ste rank %d: %s.", r_id, F_RANKS[f_id][r_id][fr_ime]);
	
	// Upisivanje u log
	new sLog[95];
	format(sLog, sizeof sLog, "%s | BRISANJE | Izvrsio: %s | Rank: %d", FACTIONS[f_id][f_naziv], ime_obicno[playerid], r_id);
	Log_Write(LOG_FACTIONS_RANKS, sLog);
	
	// Resetovanje varijabli
	F_RANKS[f_id][r_id][fr_dozvole] = 0;
	F_RANKS[f_id][r_id][fr_ime]     = EOS;

	dialog_respond:org_podaci_2(playerid, 1, 4, "");

	return 1;
}

Dialog:grupa(playerid, response, listitem, const inputtext[]) 
{
	if (!response || PI[playerid][p_org_id] == -1) return 1;

	new f_id = PI[playerid][p_org_id];

	switch (listitem) 
	{
		case 0: // Informacije
		{
			new sQuery[230];
			format(sQuery, sizeof sQuery, "SELECT DATE_FORMAT(kazna_limit, '\%%d \%%b, \%%H:\%%i') as kazna_str, DATE_FORMAT(date_sub(kazna_limit,interval %d day), '\%%d \%%b, \%%H:\%%i') as join_date FROM factions_members WHERE faction_id = %i AND player_id = %i", FACTIONS_CONTRACT_TIME/86400, f_id, PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery, "MySQL_PlayerFactionInfo", "ii", playerid, cinc[playerid]);
		}
		
		case 1: // Spisak clanova
		{
			new sQuery[170];
			format(sQuery, sizeof sQuery, "SELECT igraci.ime, igraci.skill_%s FROM igraci RIGHT JOIN factions_members ON factions_members.player_id = igraci.id WHERE factions_members.faction_id = %d", (FACTIONS[f_id][f_vrsta]==FACTION_LAW? ("cop") : ("criminal")), f_id);
			mysql_tquery(SQL, sQuery, "MySQL_FactionMemberList", "iiii", playerid, f_id, 0, cinc[playerid]);
		}

		case 2: // Napusti o/m/b
		{
			// Saljemo upit da bismo proverili da li je igrac ispunio ugovor ili ne:
			new sQuery[115];
			format(sQuery, sizeof sQuery, "SELECT UNIX_TIMESTAMP(kazna_limit) as kazna_ts FROM factions_members WHERE faction_id = %i AND player_id = %i", f_id, PI[playerid][p_id]);
			mysql_tquery(SQL, sQuery, "MySQL_PlayerLeaveFaction", "ii", playerid, cinc[playerid]);
		}

		case 3: // Uputstvo za pocetnike
		{
			callcmd::pdhelp(playerid, "");
		}
	}
	return 1;
}

Dialog:grupa_return(playerid, response, listitem, const inputtext[]) 
{
	if (PI[playerid][p_org_id] == -1) return 1;

	return callcmd::grupa(playerid, "");
}

Dialog:grupa_napusti(playerid, response, listitem, const inputtext[]) 
{
	if (PI[playerid][p_org_id] == -1) return 1;

	if (!response)
		return callcmd::grupa(playerid, "");

	new
		f_id = GetPlayerFactionID(playerid),
		novcanaKazna = GetPVarInt(playerid, "factionPenalty")
	;
	DeletePVar(playerid, "factionPenalty");

	if (novcanaKazna > 0) 
	{
		// Nije ispunio ugovor -> dobija kaznu
		PlayerMoneySub(playerid, novcanaKazna);
		PI[playerid][p_org_kazna] = gettime() + FACTIONS_PENALTY_TIME;
	}
	else // Ispunio ugovor, nema kazne
	{
		PI[playerid][p_org_kazna] = 0;
	}

	// Resetovanje igracevih podataka
	PI[playerid][p_org_id] = -1;
	PI[playerid][p_org_rank] = -1;
	PI[playerid][p_org_vreme] = 0;
	PI[playerid][p_skill_cop] = 0;
	PI[playerid][p_skill_criminal] = 0;
	PI[playerid][p_skin] = GetRandomCivilianSkin(PI[playerid][p_pol]);

	SetPlayerSkin(playerid, PI[playerid][p_skin]);

	FACTIONS[f_id][f_clanovi] --;

	// Update igracevih podataka u bazi
	new sQuery[160];
	format(sQuery, sizeof sQuery, "UPDATE igraci SET org_id = -1, org_vreme = 0, org_kazna = FROM_UNIXTIME(%d), skin = %d, skill_criminal = 0, skill_cop = 0 WHERE id = %d", PI[playerid][p_org_kazna], PI[playerid][p_skin], PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery);

	// Brisanje iz grupe (u bazi)
	new sQuery2[75];
	format(sQuery2, sizeof sQuery2, "DELETE FROM factions_members WHERE faction_id = %d AND player_id = %d", f_id, PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery2);

	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "Napustili ste %s {FFFFFF}%s.", faction_name(f_id, FNAME_AKUZATIV), FACTIONS[f_id][f_naziv]);
	if (novcanaKazna > 0) 
	{
		SendClientMessage(playerid, SVETLOCRVENA, "* Zbog neispunjenja ugovora kaznjeni ste novcano i zabranom ulaska u druge organizacije.");
		SendClientMessageF(playerid, SVETLOCRVENA, "** Novcana kazna: {FFFFFF}%s  {FF6347}|  Zabrana ulaska: {FFFFFF}%d dana", formatMoneyString(novcanaKazna), FACTIONS_PENALTY_TIME/86400);
	}

	// Slanje poruke bivsim saigracima
	FactionMsg(f_id, "{FFFF00}* %s je napustio %s.", ime_rp[playerid], faction_name(f_id, FNAME_AKUZATIV));

	// Upisivanje u log
	new sLog[71];
	format(sLog, sizeof sLog, "%s (%i) | NAPUSTANJE | %s | Kaznjen: %s", FACTIONS[f_id][f_tag], f_id, ime_obicno[playerid], (novcanaKazna>0? ("da") : ("ne")));
	Log_Write(LOG_FACTIONS_MEMBERS, sLog);

		// Upisivanje u log 2 - mysql
	new sQuery3[135];
	format(sQuery3, sizeof sQuery3, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je napustio %s (ugovor ispunjen: %s).')", f_id, ime_rp[playerid], faction_name(f_id, FNAME_AKUZATIV), (novcanaKazna>0? ("ne") : ("da")));
	mysql_pquery(SQL, sQuery3);

	dialog_respond:spawn(playerid, 1, 0, ""); // Postavlja spawn na default
	return 1;
}

Dialog:org_logovi(playerid, response, listitem, const inputtext[]) 
{
	return showDialog_org_podaci_2(playerid, F_IZMENA[playerid][IZMENA_ID]);
}

Dialog:f_pd_oprema(playerid, response, listitem, const inputtext[]) 
{
	if (!response) return 1;

	if (!IsPlayerOnLawDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste uzeli opremu. Koristite {FFFFFF}/duznost.");

	if (PI[playerid][p_org_rank] < 1)
		return ErrorMsg(playerid, "Suspendovani ste, ne mozete uzeti opremu.");

	switch (listitem)
	{
		case 0: // Oprema za patrolu
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
			GivePlayerWeapon(playerid, WEAPON_SPRAYCAN, 500);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100);
			SetPlayerArmour(playerid, 100.0);
		}   

		case 1: // Oprema za poteru
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 150);
			GivePlayerWeapon(playerid, WEAPON_MP5, 300);
			SetPlayerArmour(playerid, 130.0);
		}   

		case 2: // Oprema za specijalce
		{
			if (PI[playerid][p_org_rank] < 2)
				return ErrorMsg(playerid, "Potreban Vam je rank 2 da biste koristili ovu opremu.");

			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_M4, 300);
			GivePlayerWeapon(playerid, WEAPON_MP5, 200);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 150);
			GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
			SetPlayerArmour(playerid, 200.0);
		}

		case 3: // Oprema za diverzante
		{
			if (PI[playerid][p_org_rank] < 3)
				return ErrorMsg(playerid, "Potreban Vam je rank 3 da biste koristili ovu opremu.");

			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, WEAPON_SNIPER, 50);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100);
			GivePlayerWeapon(playerid, WEAPON_PARACHUTE, 1);
			SetPlayerArmour(playerid, 200.0);
		}

		case 4: // Oprema za undercover
		{
			if (PI[playerid][p_org_rank] < 4)
				return ErrorMsg(playerid, "Potreban Vam je rank 4 da biste koristili ovu opremu.");

			ResetPlayerWeapons(playerid);
			//GivePlayerWeapon(playerid, WEAPON_KNIFE, 50);
			GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100);
			GivePlayerWeapon(playerid, WEAPON_CAMERA, 100);
			// SetPlayerArmour(playerid, 200.0);
		}

		case 5: // Dodatna oprema
		{
			//SPD(playerid, "f_pd_dodatna_oprema", DIALOG_STYLE_LIST, "{FFFFFF}Dodatna oprema", "Lecenje\nPancir\nPendrek\nSuzavac\n9mm\nDesert Eagle\nShotgun\nMP5\nM4\nAK-47\nSniper Rifle\nFotoaparat", "Izaberi", "Nazad");
			SPD(playerid, "f_pd_dodatna_oprema", DIALOG_STYLE_LIST, "{FFFFFF}Dodatna oprema", "Lecenje\nPancir\nPendrek\nSuzavac\nShotgun\nMP5\nM4\nSniper Rifle", "Izaberi", "Nazad");
		}

		case 6: // Odeca
		{
			if (PI[playerid][p_org_rank] < 4)
				return ErrorMsg(playerid, "Potreban Vam je rank 4 da biste koristili ovu opremu.");

			SPD(playerid, "f_pd_odeca", DIALOG_STYLE_INPUT, "{FFFFFF}Izbor odece", "{FFFFFF}Unesite ID skina koji zelite da obucete.\n\nSpisak: {FFFF00}wiki.sa-mp.com/wiki/Skins:All", "Izaberi", "Nazad");
		}
		case 7: // Odeca za SWAT
		{
			if (PI[playerid][p_org_rank] < 2)
				return ErrorMsg(playerid, "Potreban Vam je rank 2 da biste koristili ovu opremu.");

			// if (PI[playerid][p_org_id] != 1) 
			//     return ErrorMsg(playerid, "Samo FBI moze uzeti ovu opremu.");

			SetPlayerSkin(playerid, 285);
		}

		case 8: // Odeca za vojsku
		{
			if (PI[playerid][p_org_rank] < 3)
				return ErrorMsg(playerid, "Potreban Vam je rank 3 da biste koristili ovu opremu.");

			if (strcmp(FACTIONS[PI[playerid][p_org_id]][f_tag], "FBI"))
				return ErrorMsg(playerid, "Samo FBI moze uzeti ovu opremu.");

			SetPlayerSkin(playerid, 287);
		}
	}
	return 1;
}

Dialog:f_pd_dodatna_oprema(playerid, response, listitem, const inputtext[]) 
{
	if (!response) return 1;

	if (!IsPlayerOnLawDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste uzeli opremu. Koristite {FFFFFF}/duznost.");

	if (PI[playerid][p_org_rank] < 1)
		return ErrorMsg(playerid, "Suspendovani ste, ne mozete uzeti opremu.");

	switch(listitem) 
	{// Lecenje\nPancir\nPendrek\nSuzavac\nShotgun\nMP5\nM4\nSniper Rifle
		case 0: SetPlayerHealth(playerid, 100.0);
		case 1: SetPlayerArmour(playerid, 200.0);
		case 2: GivePlayerWeapon(playerid, WEAPON_NITESTICK, 1);
		case 3: GivePlayerWeapon(playerid, WEAPON_SPRAYCAN, 500), SetPlayerAmmo(playerid, 9, 500);
		//case 4: GivePlayerWeapon(playerid, WEAPON_COLT45, 200), SetPlayerAmmo(playerid, 2, 200);
		//case 5: GivePlayerWeapon(playerid, WEAPON_DEAGLE, 100), SetPlayerAmmo(playerid, 2, 100);
		case 4: GivePlayerWeapon(playerid, WEAPON_SHOTGUN, 100), SetPlayerAmmo(playerid, 3, 100);
		case 5: GivePlayerWeapon(playerid, WEAPON_MP5, 200), SetPlayerAmmo(playerid, 4, 200);
		case 6: GivePlayerWeapon(playerid, WEAPON_M4, 200), SetPlayerAmmo(playerid, 5, 200);
		//case 9: GivePlayerWeapon(playerid, WEAPON_AK47, 200), SetPlayerAmmo(playerid, 5, 200);
		case 7: GivePlayerWeapon(playerid, WEAPON_SNIPER, 30), SetPlayerAmmo(playerid, 6, 30);
		//case 11: GivePlayerWeapon(playerid, WEAPON_CAMERA, 50), SetPlayerAmmo(playerid, 8, 50);
	}
	DialogReopen(playerid);
	return 1;
}

Dialog:f_pd_odeca(playerid, response, listitem, const inputtext[]) 
{
	if (!response) return callcmd::oprema(playerid, "");

	if (!IsPlayerOnLawDuty(playerid))
		return ErrorMsg(playerid, "Morate biti na duznosti da biste promenili odecu. Koristite {FFFFFF}/duznost.");

	if (PI[playerid][p_org_rank] < 1)
		return ErrorMsg(playerid, "Suspendovani ste, ne mozete uzeti odecu.");

	new skin;
	if (sscanf(inputtext, "i", skin))
		return DialogReopen(playerid);

	if (skin < 0 || skin > 311)
	{
		DialogReopen(playerid);
		return ErrorMsg(playerid, "ID skina mora biti izmedju 0 i 311.");
	}

	SetPlayerSkin(playerid, skin);
	return 1;
}

Dialog:fv_gepek(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	new 
		weapon[22],
		string[450], 
		f_id = PI[playerid][p_org_id],
		vehSlot = GetPVarInt(playerid, "FactionVehSlot")
	;
		
	oruzje_slot[playerid] = -1;
	if (vehSlot < 0 || f_id == -1)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	switch (listitem) 
	{
		case 0: // Uzmi iz gepeka
		{
			format(string, 23, "Slot\tOruzje\tMunicija");

			for__loop (new weaponSlot = 0; weaponSlot < 13; weaponSlot++) 
			{
				if (F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon] == -1 || F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo] <= 0) continue;

				GetWeaponName(F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon], weapon, sizeof(weapon));
				format(string, sizeof(string), "%s\n%d\t%s\t%d", string, weaponSlot, weapon, F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]);
			}

			SPD(playerid, "fv_gepek_uzmi", DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}UZMI IZ GEPEKA", string, "Uzmi", "Nazad");
		}

		case 1: // Stavi u gepek
		{
			new
				weaponid,
				ammo
			;

			format(string, 23, "Slot\tOruzje\tMunicija");
			for__loop (new weaponSlot = 0; weaponSlot < 13; weaponSlot++) 
			{
				weaponid    = GetPlayerWeaponInSlot(playerid, weaponSlot);
				ammo        = GetPlayerAmmoInSlot(playerid, weaponSlot);
				if (weaponid <= 0 || ammo <= 0) continue;

				GetWeaponName(weaponid, weapon, sizeof(weapon));
				format(string, sizeof(string), "%s\n%d\t%s\t%d", string, weaponSlot, weapon, ammo);
			}

			SPD(playerid, "fv_gepek_stavi", DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}STAVI U GEPEK", string, "Stavi", "Nazad");
		}
	}
	return 1;
}

Dialog:fv_gepek_uzmi(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return callcmd::gepek(playerid, "");

	new 
		vehSlot = GetPVarInt(playerid, "FactionVehSlot"),
		f_id = PI[playerid][p_org_id],
		weaponSlot = strval(inputtext), // odnosi se na slot oruzja, a ne na slot gde se nalazi vozilo
		weaponid,
		ammo,
		weapon[22]
	;

	if (vehSlot < 0 || f_id == -1) 
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	if (weaponSlot < 0 || weaponSlot > 12)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznat slot)");

	weaponid = F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon];
	if (weaponid == -1)
		return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

	ammo = F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo];
	if (ammo <= 0)
		return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

	GetWeaponName(weaponid, weapon, sizeof(weapon));
	oruzje_slot[playerid] = weaponSlot;

	new sDialog[150];
	format(sDialog, sizeof sDialog, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da uzmete:", weapon, ammo);
	SPD(playerid, "fv_gepek_uzmi_potvrda", DIALOG_STYLE_INPUT, "{FFFFFF}UZMI IZ GEPEKA", sDialog, "Uzmi", "Nazad");

	return 1;
}

Dialog:fv_gepek_uzmi_potvrda(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return callcmd::gepek(playerid, "");

	new input;
	if (sscanf(inputtext, "i", input) || input < 1 || input > 10000) 
	{
		ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 10000.");
		return DialogReopen(playerid);
	}

	new
		weaponSlot = oruzje_slot[playerid],
		vehSlot    = GetPVarInt(playerid, "FactionVehSlot"),
		f_id       = PI[playerid][p_org_id],
		weaponid,
		weapon[22],
		ammo
	;

	if (vehSlot < 0 || f_id < 0) 
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	if (weaponSlot < 0 || weaponSlot > 12)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

	weaponid= F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon];
	ammo    = F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo];

	if (weaponid <= 0 || weaponid > 46)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

	if (ammo < 1 || ammo > 50000)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

	if (input > ammo) {
		ErrorMsg(playerid, "Nema toliko municije za ovo oruzje u gepeku.");
		return DialogReopen(playerid);
	}

	if (GetPlayerWeaponInSlot(playerid, weaponSlot) != weaponid)
		GivePlayerWeapon(playerid, weaponid, 0);
	
	SetPlayerAmmo(playerid, weaponid, GetPlayerAmmoInSlot(playerid, weaponSlot)+input);
	F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo] -= input;

	// Update podataka u bazi
	if (F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo] <= 0) 
	{

		// Igrac je uzeo svu municiju, izbrisati oruzje iz gepeka
		F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon] = -1;

		new sQuery[95];
		format(sQuery, sizeof sQuery, "DELETE FROM factions_vehicles_weapons WHERE v_id = %d AND slot = %d AND weapon = %d", F_VEHICLES[f_id][vehSlot][fv_mysql_id], weaponSlot, weaponid);
		mysql_tquery(SQL, sQuery);
	}
	else 
	{
		// Nije uzeo sve, samo uraditi update municije

		new sQuery[92];
		format(sQuery, sizeof sQuery, "UPDATE factions_vehicles_weapons SET ammo = %d WHERE v_id = %d AND slot = %d", F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo], F_VEHICLES[f_id][vehSlot][fv_mysql_id], weaponSlot);
		mysql_tquery(SQL, sQuery);
	}

	GetWeaponName(weaponid, weapon, sizeof(weapon));

	// Slanje poruka igracu
	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Uzeli ste {%s}%s {FFFFFF}i {%s}%d metaka {FFFFFF}iz gepeka.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], weapon, FACTIONS[f_id][f_rgb], input);
	SendClientMessageF(playerid, BELA, "* U gepeku je ostalo jos {FFFF00}%d metaka {FFFFFF}za ovo oruzje.", F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]);

	// Upisivanje u log
	format(string_128, sizeof string_128, "UZIMANJE | %s | %s | Uzeo %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
	Log_Write(LOG_FACTIONS_VEH_WEAPONS, string_128);

	return callcmd::gepek(playerid, "");
}

Dialog:fv_gepek_stavi(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return callcmd::gepek(playerid, "");

	new 
		weaponSlot = strval(inputtext),
		vehSlot    = GetPVarInt(playerid, "FactionVehSlot"),
		f_id       = PI[playerid][p_org_id],
		weaponid    = GetPlayerWeaponInSlot(playerid, weaponSlot),
		ammo        = GetPlayerAmmoInSlot(playerid, weaponSlot),
		weapon[22];

	if (vehSlot < 0 || f_id < 0) 
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	if (weaponSlot < 0 || weaponSlot > 12)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznat slot)");

	if (weaponid == -1)
		return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

	if (ammo <= 0)
		return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

	if (weaponid != WEAPON_DEAGLE && weaponid != WEAPON_MP5 && weaponid != WEAPON_M4 && weaponid != WEAPON_AK47 && weaponid != WEAPON_SNIPER)
		return ErrorMsg(playerid, "Ne mozete ostaviti to oruzje u gepek.");

	GetWeaponName(weaponid, weapon, sizeof(weapon));
	oruzje_slot[playerid] = weaponSlot;

	new sDialog[150];
	format(sDialog, sizeof sDialog, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da stavite:", weapon, ammo);
	SPD(playerid, "fv_gepek_stavi_potvrda", DIALOG_STYLE_INPUT, "STAVI U GEPEK", sDialog, "Uzmi", "Nazad");

	return 1;
}

Dialog:fv_gepek_stavi_potvrda(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return callcmd::gepek(playerid, "");

	new input;
	if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) 
	{
		ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
		return DialogReopen(playerid);
	}

	new
		weaponSlot = oruzje_slot[playerid],
		vehSlot    = GetPVarInt(playerid, "FactionVehSlot"),
		f_id        = PI[playerid][p_org_id],
		weaponid,
		weapon[22],
		ammo;

	if (vehSlot < 0 || f_id < 0) 
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	if (weaponSlot < 0 || weaponSlot > 12)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

	weaponid = GetPlayerWeaponInSlot(playerid, weaponSlot);
	ammo     = GetPlayerAmmoInSlot(playerid, weaponSlot);

	if (weaponid <= 0 || weaponid > 46)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

	if (ammo < 1 || ammo > 50000)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

	if (input > ammo) 
	{
		ErrorMsg(playerid, "Nemate toliko municije za ovo oruzje kod sebe.");
		return DialogReopen(playerid);
	}

	SetPlayerAmmo(playerid, weaponid, ammo-input);

	// Update podataka u bazi
	if (F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon] == -1) 
	{
		// Ovaj slot nije bio zauzet u gepeku --> insert

		F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon] = weaponid;
		F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]   = input;

		format(mysql_upit, 85, "INSERT INTO factions_vehicles_weapons VALUES (%d, %d, %d, %d)", F_VEHICLES[f_id][vehSlot][fv_mysql_id], weaponSlot, weaponid, input);
		mysql_tquery(SQL, mysql_upit);
	}
	else 
	{
		// Slot je bio zauzet (istim ili drugim oruzjem)

		if ((F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo] + input) > 1000)
		{
			ErrorMsg(playerid, "Mozete ubaciti najvise 1000 metaka u vozilo. Vec ih imate %d za ovaj slot.", F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]);
			return DialogReopen(playerid);
		}

		F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_weapon] = weaponid;
		F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]  += input;

		format(mysql_upit, sizeof mysql_upit, "UPDATE factions_vehicles_weapons SET weapon = %d, ammo = %d WHERE v_id = %d AND slot = %d", weaponid, F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo], F_VEHICLES[f_id][vehSlot][fv_mysql_id], weaponSlot);
		mysql_tquery(SQL, mysql_upit);
	}

	GetWeaponName(weaponid, weapon, sizeof(weapon));

	// Slanje poruka igracu
	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Stavili ste {%s}%s {FFFFFF}i {%s}%d metaka {FFFFFF}u gepek.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], weapon, FACTIONS[f_id][f_rgb], input);
	SendClientMessageF(playerid, BELA, "* U gepeku sada ima {FFFF00}%d metaka {FFFFFF}za ovo oruzje.", F_VEH_WEAPONS[f_id][vehSlot][weaponSlot][fv_ammo]);

	// Upisivanje u log
	new sLog[115];
	format(sLog, sizeof sLog, "STAVLJANJE | %s | %s | Vozilo %i | Stavio %d od %d metaka", ime_obicno[playerid], weapon, F_VEHICLES[f_id][vehSlot][fv_mysql_id], input, ammo);
	Log_Write(LOG_FACTIONS_VEH_WEAPONS, sLog);

	return callcmd::gepek(playerid, "");
}

Dialog:f_smeni_lidera(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
	if (!IsAdmin(playerid, 5) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (listitem == 0)
	{
		ErrorMsg(playerid, "Ne mozete ovo polje izabrati!");
		return DialogReopen(playerid);
	}
	if (strcmp(inputtext, "Niko", true) == 0)
	{
		ErrorMsg(playerid, "Izabrani slot je prazan.");
		return DialogReopen(playerid);
	} 

	// Trazimo ID organizacije + izbacivanje iz F_LEADERS
	new f_id = -1;
	for__loop (new i = 0; i < MAX_FACTIONS; i++)
	{
		if (FACTIONS[i][f_loaded] == -1) continue;       
		if (strcmp(inputtext, F_LEADERS[i][0], true) == 0)
		{
			strmid(F_LEADERS[i][0], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
			f_id = i;
			break;
		}
		if (strcmp(inputtext, F_LEADERS[i][1], true) == 0)
		{
			strmid(F_LEADERS[i][1], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
			f_id = i;
			break;
		}
		Faction_UpdateEntranceLabel(i);
	}
	if (f_id == -1)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);


	// Brisanje iz baze
	new sQuery_1[117];
	mysql_format(SQL, sQuery_1, sizeof sQuery_1, "DELETE FROM factions_members WHERE player_id = (SELECT id FROM igraci WHERE ime = '%s')", inputtext);
	mysql_tquery(SQL, sQuery_1);

	FACTIONS[f_id][f_clanovi] --;
	
	// Slanje poruke adminu/lideru
	SendClientMessageF(playerid, SVETLOPLAVA, "* Smenili ste lidera %s.", inputtext);
	
	// Slanje poruke igracu (ako je online) + izmena varijabli
	new name[MAX_PLAYER_NAME];
	format(name, sizeof name, "%s", inputtext);
	new targetid = get_player_id(name);
	if (IsPlayerConnected(targetid))
	{
		// Slanje poruke
		SendClientMessageF(targetid, SVETLOCRVENA, "* %s Vas je smenio sa pozicije lidera.", ime_rp[playerid]);

		/*if(strlen(PI[targetid][p_discord_id]) > 5) 
		{
			if(PI[targetid][p_org_id] == 0) { removePlayerDiscRole(PI[targetid][p_discord_id], "lspd"); }
			else if(PI[targetid][p_org_id] == 1) { removePlayerDiscRole(PI[targetid][p_discord_id], "lcn");}
			else if(PI[targetid][p_org_id] == 2) { removePlayerDiscRole(PI[targetid][p_discord_id], "sb");}
			else if(PI[targetid][p_org_id] == 3) { removePlayerDiscRole(PI[targetid][p_discord_id], "gsf");}

			removePlayerDiscRole(PI[targetid][p_discord_id], "lider");
		}*/
		
		// Izmena varijabli
		PI[targetid][p_org_id]    = -1;
		PI[targetid][p_org_rank]  = -1;
		PI[targetid][p_org_vreme] =  0;
		PI[targetid][p_skill_cop] = 0;
		PI[targetid][p_skill_criminal] = 0;
		PI[targetid][p_skin] = GetRandomCivilianSkin(PI[targetid][p_pol]);
		SetPlayerSkin(targetid, PI[targetid][p_skin]);

		dialog_respond:spawn(targetid, 1, 0, ""); // Postavlja spawn na default

		ChatDisableForPlayer(targetid, CHAT_FACTION);
		ChatDisableForPlayer(targetid, CHAT_LEADER);
		ChatDisableForPlayer(targetid, CHAT_DEPARTMENT);

		// Update podataka u bazi
		new sQuery[110];
		format(sQuery, sizeof sQuery, "UPDATE igraci SET org_id = -1, org_vreme = 0, skin = %i, skill_criminal = 0, skill_cop = 0 WHERE id = %d", PI[targetid][p_skin], PI[targetid][p_id]);
		mysql_tquery(SQL, sQuery);
	}
	
	// Igracevi podaci u bazi se ne menjaju jer ce automatski da se updateuju kad bude usao u igru
	
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | IZBACIVANJE | Izvrsio: %s | Igrac: %s", FACTIONS[f_id][f_naziv], ime_obicno[playerid], inputtext);
	Log_Write(LOG_FACTIONS_MEMBERS, string_128);

	// Upisivanje u log 2 - mysql
	new sQuery_2[128];
	mysql_format(SQL, sQuery_2, sizeof sQuery_2, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je izbacio %s.')", f_id, ime_obicno[playerid], inputtext);
	mysql_pquery(SQL, sQuery_2);

	return 1;
}

Dialog:f_sef(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	new f_id = PI[playerid][p_org_id];
	if (f_id == -1/* || PI[playerid][p_org_rank] != RANK_LEADER*/) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (35)");

	if (listitem == 0) // Pregled stanja
	{
		if (FACTIONS[f_id][f_vrsta] == FACTION_LAW)
		{
			new sDialog[48];
			format(sDialog, sizeof sDialog, "{FFFFFF}Stanje novca: {%s}%s", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));
			SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "SEF", sDialog, "OK", "");
		}
		else
		{
			new sDialog[144];
			format(sDialog, sizeof sDialog, "{FFFFFF}Stanje novca: {%s}%s\n\n{FFFFFF}Materijali u sefu: {%s}%i\n{FFFFFF}Materijali u skladistu: {%s}%i", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]), FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali], FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali_skladiste]);

			SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "SEF", sDialog, "OK", "");
		}
	}

	else if (listitem == 1) // Novac: uzimanje
	{
		if (IsLeader(playerid))
		{
			new sDialog[93];
			format(sDialog, sizeof sDialog, "{FFFFFF}Stanje novca: {%s}%s\n\n{FFFFFF}Upisite iznos koji zelite da uzmete:", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));

			SPD(playerid, "f_sef_uzmi_novac", DIALOG_STYLE_INPUT, "SEF", sDialog, "Uzmi", "Nazad");
		}
		else
		{
			return ErrorMsg(playerid, "Nemate dozvolu za uzimanje novca iz sefa.");
		}
	}
	else if (listitem == 2) // Novac: stavljanje
	{
		new sDialog[95];
		format(sDialog, sizeof sDialog, "{FFFFFF}Stanje novca: {%s}%s\n\n{FFFFFF}Upisite iznos koji zelite da ostavite:", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));

		SPD(playerid, "f_sef_stavi_novac", DIALOG_STYLE_INPUT, "SEF", sDialog, "Stavi", "Nazad");
	}
	return 1;
}

Dialog:f_sef_uzmi_novac(playerid, response, listitem, const inputtext[])
{
	if(!response) return 1;

	new f_id = -1, iznos;

	f_id = PI[playerid][p_org_id];

	if(f_id == -1 || PI[playerid][p_org_rank] != RANK_LEADER) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	if(sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 99999999) return DialogReopen(playerid);

	if(FACTIONS[f_id][f_budzet] < iznos)
	{
		ErrorMsg(playerid, "Nema toliko novca u sefu.");
		return DialogReopen(playerid);
	}

	if((PI[playerid][p_novac] + iznos) > 99999999)
	{
		ErrorMsg(playerid, "Mozete nositi najvise $99.999.999 sa sobom. Unesite neki manji iznos.");
		return DialogReopen(playerid);
	}

	FACTIONS[f_id][f_budzet] -= iznos;
	PlayerMoneyAdd(playerid, iznos);

	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF} Uzeli ste {%s}%s {FFFFFF}iz sefa.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], formatMoneyString(iznos));

	format(string_128, sizeof string_128, "%s | UZIMANJE | %s | $%d (novi iznos: $%d", FACTIONS[f_id][f_naziv], ime_obicno[playerid], iznos, FACTIONS[f_id][f_budzet]);
	Log_Write(LOG_FACTIONS_SAFE, string_128);

	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je podigao %s iz sefa.')", f_id, ime_obicno[playerid], formatMoneyString(iznos));
	mysql_pquery(SQL, mysql_upit);

	return 1;
}

Dialog:f_sef_stavi_novac(playerid, response, listitem, const inputtext[])
{
	if(!response) return 1;

	new f_id = -1, iznos;

	f_id = PI[playerid][p_org_id];

	if(f_id == -1 || PI[playerid][p_org_rank] != RANK_LEADER) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	if(sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 99999999) return DialogReopen(playerid);

	if(PI[playerid][p_novac] < iznos)
	{
		ErrorMsg(playerid, "Nema toliko novca kod sebe.");
		return DialogReopen(playerid);
	}

	if((FACTIONS[f_id][f_budzet] + iznos) > 99999999)
	{
		ErrorMsg(playerid, "Mozete imati najvise $99.999.999 u sefu. Unesite neki manji iznos.");
		return DialogReopen(playerid);
	}

	FACTIONS[f_id][f_budzet] += iznos;
	PlayerMoneySub(playerid, iznos);

	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF} Stavili ste {%s}%s {FFFFFF}iz sefa.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], formatMoneyString(iznos));

	format(string_128, sizeof string_128, "%s | STAVLJANJE | %s | $%d (novi iznos: $%d", FACTIONS[f_id][f_naziv], ime_obicno[playerid], iznos, FACTIONS[f_id][f_budzet]);
	Log_Write(LOG_FACTIONS_SAFE, string_128);

	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je podigao %s iz sefa.')", f_id, ime_obicno[playerid], formatMoneyString(iznos));
	mysql_pquery(SQL, mysql_upit);

	return 1;
}


// Dialog:f_sef_takeMats(playerid, response, listitem, const inputtext[])
// {
//     if (!response) return 1;

//     new quantity;
//     if (sscanf(inputtext, "i", quantity))
//         return DialogReopen(playerid);

//     new maxTake = GetPVarInt(playerid, "fSafeMaxTake");

//     if (maxTake <= 0)
//         return ErrorMsg(playerid, "Prostor u rancu je popunjen do kraja.");

//     if (quantity < 1 || quantity > maxTake)
//     {
//         ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", maxTake);
//         return DialogReopen(playerid);
//     }

//     new f_id = PI[playerid][p_org_id];
//     if (f_id == -1) return ErrorMsg(playerid, GRESKA_NEPOZNATO);

//     if (FACTIONS[f_id][f_materijali] < quantity)
//     {
//         ErrorMsg(playerid, "Nema dovoljno materijala u sefu, unesite manji broj.");
//         return DialogReopen(playerid);
//     }

//     if (BP_GetItemCountLimit(ITEM_MATERIALS) < (quantity + BP_PlayerItemGetCount(playerid, ITEM_MATERIALS)))
//     {
//         ErrorMsg(playerid, "Ne mozete nositi toliku kolicinu.");
//         return DialogReopen(playerid);
//     }

//     BP_PlayerItemAdd(playerid, ITEM_MATERIALS, quantity);
//     FACTIONS[f_id][f_materijali] -= quantity;

//     // Slanje poruke svim clanovima
//     FactionMsg(f_id, "{FFFFFF}%s je uzeo %i materijala iz sefa.", ime_rp[playerid], quantity);

//     // Update podataka u bazi
//     new query[60];
//     format(query, sizeof query, "UPDATE factions SET materijali = %i WHERE id = %i", FACTIONS[f_id][f_materijali], f_id);
//     mysql_tquery(SQL, query);

//     // Upisivanje u log
//     format(string_128, sizeof string_128, "%s | UZIMANJE | %s | %i materijala (novo stanje: %i)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], quantity, FACTIONS[f_id][f_materijali]);
//     Log_Write(LOG_FACTIONS_SAFE, string_128);

//     // Upisivanje u log 2 - mysql
//     mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je podigao %i materijala iz sefa.')", f_id, ime_obicno[playerid], quantity);
//     mysql_pquery(SQL, mysql_upit);

//     return 1;
// }

Dialog:f_sef_novac(playerid, response, listitem, const inputtext[])
{
	new f_id = PI[playerid][p_org_id];

	if (response)
	{
		// Stavi

		new sDialog[95];
		format(sDialog, sizeof sDialog, "{FFFFFF}Novac u sefu: {%s}%s\n\n{FFFFFF}Upisite iznos koji zelite da ostavite:", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));

		SPD(playerid, "f_sef_novac_stavi", DIALOG_STYLE_INPUT, "Novac", sDialog, "Stavi", "Nazad");
	}
	else
	{
		// Uzmi

		if (IsLeader(playerid))
		{
			new sDialog[95];
			format(sDialog, sizeof sDialog, "{FFFFFF}Novac u sefu: {%s}%s\n\n{FFFFFF}Upisite iznos koji zelite da uzmete:", FACTIONS[f_id][f_rgb], formatMoneyString(FACTIONS[f_id][f_budzet]));

			SPD(playerid, "f_sef_novac_uzmi", DIALOG_STYLE_INPUT, "Novac", sDialog, "Uzmi", "Nazad");
		}
		else
		{
			ErrorMsg(playerid, "Nemate dozvolu za uzimanje novca iz sefa.");
			ShowSafeTextDraw(playerid);
		}
	}
	return 1;
}

// Dialog:f_sef_mats(playerid, response, listitem, const inputtext[])
// {
//     new f_id = PI[playerid][p_org_id];

//     if (response)
//     {
//         // Stavi

//         new sDialog[96];
//         format(sDialog, sizeof sDialog, "{FFFFFF}Materijali u sefu: {%s}%i\n\n{FFFFFF}Upisite kolicinu koju zelite da ostavite:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali]);

//         SPD(playerid, "f_sef_mats_stavi", DIALOG_STYLE_INPUT, "Materijali", sDialog, "Stavi", "Nazad");
//     }
//     else
//     {
//         // Uzmi

//         if (IsLeader(playerid))
//         {
//             new sDialog[96];
//             format(sDialog, sizeof sDialog, "{FFFFFF}Materijali u sefu: {%s}%i\n\n{FFFFFF}Upisite kolicinu koju zelite da uzmete:", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali]);

//             SPD(playerid, "f_sef_mats_uzmi", DIALOG_STYLE_INPUT, "Materijali", sDialog, "Uzmi", "Nazad");
//         }
//         else
//         {
//             ErrorMsg(playerid, "Nemate dozvolu za uzimanje novca iz sefa.");
//             ShowSafeTextDraw(playerid);
//         }
//     }
//     return 1;
// }



Dialog:f_sef_droga_1(playerid, response, listitem, const inputtext[])
{
	new f_id = PI[playerid][p_org_id];
	if (response)
	{
		// Heroin
		new sDialog[96];
		format(sDialog, sizeof sDialog, "{FFFFFF}Heroin: {%s}%i gr\n\n{FFFFFF}Odaberite da li zelite da stavite ili uzmete heroin.", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_heroin]);
		SPD(playerid, "f_sef_droga_2", DIALOG_STYLE_MSGBOX, "Heroin", sDialog, "Stavi", "Uzmi");

		SetPVarInt(playerid, "fDrugs_TakePut", ITEM_HEROIN);
	}
	else
	{
		// MDMA

		new sDialog[96];
		format(sDialog, sizeof sDialog, "{FFFFFF}MDMA: {%s}%i gr\n\n{FFFFFF}Odaberite da li zelite da stavite ili uzmete MDMA-u.", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_mdma]);
		SPD(playerid, "f_sef_droga_2", DIALOG_STYLE_MSGBOX, "MDMA", sDialog, "Stavi", "Uzmi");

		SetPVarInt(playerid, "fDrugs_TakePut", ITEM_MDMA);
	}
	return 1;
}

Dialog:f_sef_droga_2(playerid, response, listitem, const inputtext[])
{
	new f_id = PI[playerid][p_org_id],
		itemid = GetPVarInt(playerid, "fDrugs_TakePut"),
		sItemName[25],
		safeQuantity = 0;

	BP_GetItemName(itemid, sItemName, sizeof sItemName);

	if (itemid == ITEM_HEROIN) safeQuantity = FACTIONS[f_id][f_heroin];
	else if (itemid == ITEM_MDMA) safeQuantity = FACTIONS[f_id][f_mdma];
	else if (itemid == ITEM_WEED) safeQuantity = FACTIONS[f_id][f_weed];

	if (response)
	{
		// Stavi

		new sDialog[97];
		format(sDialog, sizeof sDialog, "{FFFFFF}%s u sefu: {%s}%i gr\n\n{FFFFFF}Upisite kolicinu koju zelite da ostavite:", sItemName, FACTIONS[f_id][f_rgb], safeQuantity);

		SPD(playerid, "f_sef_droga_stavi", DIALOG_STYLE_INPUT, sItemName, sDialog, "Stavi", "Nazad");
	}
	else
	{
		// Uzmi

		if (IsLeader(playerid))
		{
			new sDialog[98];
			format(sDialog, sizeof sDialog, "{FFFFFF}%s u sefu: {%s}%i gr\n\n{FFFFFF}Upisite kolicinu koju zelite da uzmete:", sItemName, FACTIONS[f_id][f_rgb], safeQuantity);

			SPD(playerid, "f_sef_droga_uzmi", DIALOG_STYLE_INPUT, sItemName, sDialog, "Uzmi", "Nazad");
		}
		else
		{
			ErrorMsg(playerid, "Nemate dozvolu za uzimanje droge iz sefa.");
			ShowSafeTextDraw(playerid);
		}
	}
	return 1;
}

Dialog:f_sef_novac_uzmi(playerid, response, listitem, const inputtext[]) // Novac: uzimanje
{
	if (!response) return ShowSafeTextDraw(playerid);

	new 
		f_id = PI[playerid][p_org_id], 
		iznos
	;

	if (f_id == -1 || PI[playerid][p_org_rank] != RANK_LEADER) 
	{
		ShowSafeTextDraw(playerid);
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (36)");
	}

	if (sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 99999999)
		return DialogReopen(playerid);

	if (FACTIONS[f_id][f_budzet] < iznos) // Nema dovoljno novca
	{
		ErrorMsg(playerid, "Nema toliko novca u sefu.");
		return DialogReopen(playerid);
	}

	if ((PI[playerid][p_novac] + iznos) > 99999999)
	{
		ErrorMsg(playerid, "Mozete nositi najvise $99.999.999 sa sobom. Unesite neki manji iznos.");
		return DialogReopen(playerid);
	}

	FACTIONS[f_id][f_budzet] -= iznos;
	PlayerMoneyAdd(playerid, iznos);
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

	// Slanje poruke igracu
	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Uzeli ste {%s}%s {FFFFFF}iz sefa.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], formatMoneyString(iznos));

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | UZIMANJE | %s | $%d (novi iznos: $%d)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], iznos, FACTIONS[f_id][f_budzet]);
	Log_Write(LOG_FACTIONS_SAFE, string_128);

	// Upisivanje u log 2 - mysql
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je podigao %s iz sefa.')", f_id, ime_obicno[playerid], formatMoneyString(iznos));
	mysql_pquery(SQL, mysql_upit);


	ShowSafeTextDraw(playerid);
	return 1;
}

Dialog:f_sef_novac_stavi(playerid, response, listitem, const inputtext[]) // Novac: stavljanje
{
	if (!response) return ShowSafeTextDraw(playerid);

	new f_id = PI[playerid][p_org_id], iznos;
	if (f_id == -1) 
	{
		ShowSafeTextDraw(playerid);
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (37)");
	}

	if (sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 99999999) 
		return DialogReopen(playerid);

	if (PI[playerid][p_novac] < iznos) // Nema dovoljno novca
	{
		ErrorMsg(playerid, "Nemate toliko novca u kod sebe.");
		return DialogReopen(playerid);
	}

	if ((FACTIONS[f_id][f_budzet] + iznos) > 99999999)
	{
		ErrorMsg(playerid, "Mozete imati najvise $99.999.999 u sefu. Unesite neki manji iznos.");
		return DialogReopen(playerid);
	}

	FACTIONS[f_id][f_budzet] += iznos;
	PlayerMoneySub(playerid, iznos);

	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

	// Slanje poruke igracu
	SendClientMessageF(playerid, HexToInt(FACTIONS[f_id][f_hex]), "(%s) {FFFFFF}Stavili ste {%s}%s {FFFFFF}u sef.", FACTIONS[f_id][f_tag], FACTIONS[f_id][f_rgb], formatMoneyString(iznos));

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | STAVLJANJE | %s | $%d (novi iznos: $%d)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], iznos, FACTIONS[f_id][f_budzet]);
	Log_Write(LOG_FACTIONS_SAFE, string_128);

	// Upisivanje u log 2 - mysql
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je stavio %s u sef.')", f_id, ime_obicno[playerid], formatMoneyString(iznos));
	mysql_tquery(SQL, mysql_upit);

	ShowSafeTextDraw(playerid);
	return 1;
}

Dialog:f_sef_mats_stavi(playerid, response, listitem, const inputtext[])
{
	if (!response) return ShowSafeTextDraw(playerid);

	new Float:quantity, quantityInteger;
	if (sscanf(inputtext, "f", quantity) || quantity < 0.1 || quantity > 1000.0)
		return DialogReopen(playerid);

	quantityInteger = floatround(quantity*1000);

	if (quantityInteger > BP_PlayerItemGetCount(playerid, ITEM_MATERIALS))
	{
		ErrorMsg(playerid, "Nemate toliko obradjenih materijala u rancu.");
		return DialogReopen(playerid);
	}

	new f_id = PI[playerid][p_org_id];
	if (f_id == -1) 
	{
		ShowSafeTextDraw(playerid);
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	}

	BP_PlayerItemSub(playerid, ITEM_MATERIALS, quantityInteger);
	FACTIONS[f_id][f_materijali] += quantityInteger;

	// Slanje poruke svim clanovima
	FactionMsg(f_id, "{FFFFFF}%s je stavio %.1f kg materijala u sef | Novo stanje: {%s}%.1f kg", ime_rp[playerid], quantity, FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_materijali]/1000.0);

	// Update podataka u bazi
	new sQuery[60];
	format(sQuery, sizeof sQuery, "UPDATE factions SET materijali = %i WHERE id = %i", FACTIONS[f_id][f_materijali], f_id);
	mysql_tquery(SQL, sQuery);

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | STAVLJANJE | %s | %i materijala (novo stanje: %i)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], quantityInteger, FACTIONS[f_id][f_materijali]);
	Log_Write(LOG_FACTIONS_SAFE, string_128);

	// Upisivanje u log 2 - mysql
	mysql_format(SQL, mysql_upit, 128, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je stavio %.1f kg materijala u sef.')", f_id, ime_obicno[playerid], quantity);
	mysql_pquery(SQL, mysql_upit);

	ShowSafeTextDraw(playerid);
	return 1;
}

Dialog:f_sef_droga_stavi(playerid, response, listitem, const inputtext[])
{
	if (!response) return ShowSafeTextDraw(playerid);

	new quantity, itemid, sItemName[25], countSafe = 0, newCount = 0;
	if (sscanf(inputtext, "i", quantity) || quantity < 1 || quantity > 1000000)
		return DialogReopen(playerid);

	itemid = GetPVarInt(playerid, "fDrugs_TakePut");
	BP_GetItemName(itemid, sItemName, sizeof sItemName);

	new f_id = PI[playerid][p_org_id];
	if (f_id == -1) 
	{
		ShowSafeTextDraw(playerid);
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	}
	
	if (itemid == ITEM_HEROIN) countSafe = FACTIONS[f_id][f_heroin];
	else if (itemid == ITEM_MDMA) countSafe = FACTIONS[f_id][f_mdma];
	else if (itemid == ITEM_WEED) countSafe = FACTIONS[f_id][f_weed];
	else
	{
		ShowSafeTextDraw(playerid);
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	}

	if (quantity > BP_PlayerItemGetCount(playerid, itemid))
	{
		ErrorMsg(playerid, "Nemate toliko %s u rancu.", sItemName);
		return DialogReopen(playerid);
	}

	if ((countSafe + quantity) > 10000)
	{
		ErrorMsg(playerid, "U sefu mozete drzati najvise 10.000 grama.");
		return DialogReopen(playerid);
	}

	BP_PlayerItemSub(playerid, itemid, quantity);
	if (itemid == ITEM_HEROIN) 
	{
		FACTIONS[f_id][f_heroin] += quantity;
		newCount = FACTIONS[f_id][f_heroin];
	}
	else if (itemid == ITEM_MDMA) 
	{
		FACTIONS[f_id][f_mdma] += quantity;
		newCount = FACTIONS[f_id][f_mdma];
	}
	else if (itemid == ITEM_WEED) 
	{
		FACTIONS[f_id][f_weed] += quantity;
		newCount = FACTIONS[f_id][f_weed];
	}

	// Slanje poruke svim clanovima
	FactionMsg(f_id, "{FFFFFF}%s je stavio %s (%i gr) u sef | Novo stanje: {%s}%i gr", ime_rp[playerid], sItemName, quantity, FACTIONS[f_id][f_rgb], newCount);

	// Update podataka u bazi
	new sQuery[68];
	format(sQuery, sizeof sQuery, "UPDATE factions SET droga = '%i|%i|%i' WHERE id = %i", FACTIONS[f_id][f_heroin], FACTIONS[f_id][f_mdma], FACTIONS[f_id][f_weed], f_id);
	mysql_tquery(SQL, sQuery);

	// Upisivanje u log
	new sLog[100];
	format(sLog, sizeof sLog, "%s | STAVLJANJE | %s | %igr %s (novo stanje: %i)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], quantity, sItemName, newCount);
	Log_Write(LOG_FACTIONS_SAFE, sLog);

	// Upisivanje u log 2 - mysql
	new sQuery2[124];
	mysql_format(SQL, sQuery2, sizeof sQuery2, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je stavio %s (%i gr) u sef.')", f_id, ime_obicno[playerid], sItemName, quantity);
	mysql_pquery(SQL, sQuery2);

	ShowSafeTextDraw(playerid);
	return 1;
}

Dialog:f_sef_droga_uzmi(playerid, response, listitem, const inputtext[])
{
	if (!response) return ShowSafeTextDraw(playerid);

	new quantity, itemid, sItemName[25], countSafe = 0, newCount = 0;
	if (sscanf(inputtext, "i", quantity) || quantity < 1 || quantity > 1000000)
		return DialogReopen(playerid);

	itemid = GetPVarInt(playerid, "fDrugs_TakePut");
	BP_GetItemName(itemid, sItemName, sizeof sItemName);

	new f_id = PI[playerid][p_org_id];
	if (f_id == -1) 
	{
		ShowSafeTextDraw(playerid);
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	}

	if (itemid == ITEM_HEROIN) countSafe = FACTIONS[f_id][f_heroin];
	else if (itemid == ITEM_MDMA) countSafe = FACTIONS[f_id][f_mdma];
	else if (itemid == ITEM_WEED) countSafe = FACTIONS[f_id][f_weed];
	else
	{
		ShowSafeTextDraw(playerid);
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	}

	if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) > BP_GetItemCountLimit(itemid))
	{
		ErrorMsg(playerid, "Limit %s u rancu je %i gr. Mozete uzeti jos samo %i gr.", sItemName, BP_GetItemCountLimit(itemid), (BP_GetItemCountLimit(itemid) - BP_PlayerItemGetCount(playerid, itemid)));
		return DialogReopen(playerid);
	}

	if (quantity > countSafe)
	{
		ErrorMsg(playerid, "Nema toliko droge u sefu. Mozete uzeti najvise %i gr.", countSafe);
		return DialogReopen(playerid);
	}

	BP_PlayerItemAdd(playerid, itemid, quantity);
	if (itemid == ITEM_HEROIN) 
	{
		FACTIONS[f_id][f_heroin] -= quantity;
		newCount = FACTIONS[f_id][f_heroin];
	}
	else if (itemid == ITEM_MDMA) 
	{
		FACTIONS[f_id][f_mdma] -= quantity;
		newCount = FACTIONS[f_id][f_mdma];
	}
	else if (itemid == ITEM_WEED) 
	{
		FACTIONS[f_id][f_weed] -= quantity;
		newCount = FACTIONS[f_id][f_weed];
	}

	// Slanje poruke svim clanovima
	FactionMsg(f_id, "{FFFFFF}%s je uzeo %s (%i gr) iz sefa | Novo stanje: {%s}%i gr", ime_rp[playerid], sItemName, quantity, FACTIONS[f_id][f_rgb], newCount);

	// Update podataka u bazi
	new sQuery[68];
	format(sQuery, sizeof sQuery, "UPDATE factions SET droga = '%i|%i|%i' WHERE id = %i", FACTIONS[f_id][f_heroin], FACTIONS[f_id][f_mdma], FACTIONS[f_id][f_weed], f_id);
	mysql_tquery(SQL, sQuery);

	// Upisivanje u log
	new sLog[100];
	format(sLog, sizeof sLog, "%s | UZIMANJE | %s | %igr %s (novo stanje: %i)", FACTIONS[f_id][f_naziv], ime_obicno[playerid], quantity, sItemName, newCount);
	Log_Write(LOG_FACTIONS_SAFE, sLog);

	// Upisivanje u log 2 - mysql
	new sQuery2[124];
	mysql_format(SQL, sQuery2, sizeof sQuery2, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je uzeo %s (%i gr) iz sefa.')", f_id, ime_obicno[playerid], sItemName, quantity);
	mysql_pquery(SQL, sQuery2);

	ShowSafeTextDraw(playerid);
	return 1;
}

Dialog:orgkazna(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		new pay = 100000;
		if (PI[playerid][p_nivo] > 10)
			pay += 100000 * (PI[playerid][p_nivo] - 10);
		

		if (PI[playerid][p_novac] < pay)
			return ErrorMsg(playerid, "Nemate dovoljno novca.");

		PlayerMoneySub(playerid, pay);
		PI[playerid][p_org_kazna] = 0;

		SendClientMessageF(playerid, BELA, "* Platili ste kaznu u iznosu od %s. Sada mozete uci u neku organizaciju.", formatMoneyString(pay));

		new sQuery[88];
		format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, org_kazna = FROM_UNIXTIME(0) WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery);

		new sLog[42];
		format(sLog, sizeof sLog, "%s | %s", ime_obicno[playerid], formatMoneyString(pay));
		Log_Write(LOG_ORGKAZNA, sLog);
	}
	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:createorgveh(FLAG_ADMIN_6)
CMD:createorgveh(playerid, const params[])
{
	if(!IsPlayerOwner(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new
		vehicleid,
		f_id,
		modelid,
		Float:X,
		Float:Y,
		Float:Z
	;

	if(!sscanf(params, "ii", f_id, modelid))
	{
		if(f_id == -1 || FACTIONS[f_id][f_loaded] == -1)
			return ErrorMsg(playerid, "Unijeli ste nevazeci ID organizacije.");

		new slot = -1;

		for__loop (new i = 0; i < GetFactionVehicleLimit(f_id); i++) 
		{
			if (F_VEHICLES[f_id][i][fv_vehicle_id] == -1) 
			{
				slot = i;
				break;
			}
		}
		if (slot == -1 || slot >= MAX_FACTIONS_VEHICLES)
			return ErrorMsg(playerid, "[factions.pwn] "GRESKA_NEPOZNATO" (04)");
			
		GetPlayerPos(playerid, X, Y, Z);

		F_VEHICLES[f_id][slot][fv_x_spawn] = X;
		F_VEHICLES[f_id][slot][fv_y_spawn] = Y;
		F_VEHICLES[f_id][slot][fv_z_spawn] = Z;
		F_VEHICLES[f_id][slot][fv_a_spawn] = 0.0;

		vehicleid = CreateVehicle(modelid, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn], FACTIONS[f_id][f_boja_1], FACTIONS[f_id][f_boja_2], 1000);
		Iter_Add(faction_vehicles, vehicleid);

		new sLabel[36];
		format(sLabel, sizeof sLabel, "[ %s ]", FACTIONS[f_id][f_tag]);
		F_VEHICLES[f_id][slot][fv_label] = CreateDynamic3DTextLabel(sLabel, HexToInt(FACTIONS[f_id][f_hex]), 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, vehicleid);


		if (!IsVehicleHelicopter(vehicleid) && !IsVehicleBoat(vehicleid) && !IsVehicleBicycle(vehicleid))
		{
			// Vozilo je automobil ili motor
			new tablica[32];
			format(tablica, sizeof(tablica), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_tag]);
			SetVehicleNumberPlate(vehicleid, tablica);
			SetVehicleToRespawn(vehicleid);
		}

		// Belezenje podataka, oduzimanje novca
		F_VEHICLES[f_id][slot][fv_model_id]     = modelid;
		F_VEHICLES[f_id][slot][fv_cena]         = 6969;
		F_VEHICLES[f_id][slot][fv_vehicle_id]   = vehicleid;
		F_VEHICLES[f_id][slot][fv_prodaja]      = 1;

		InfoMsg(playerid, "Uspjesno ste dodali vozilo za organizaciju ID %i", f_id);

		// Upisivanje podataka u bazu
		format(mysql_upit, 160, "INSERT INTO factions_vehicles (faction_id, model_id, cena, spawn) VALUES (%d, %d, %d, '%.4f|%.4f|%.4f|%.4f')", f_id, modelid, 6969, F_VEHICLES[f_id][slot][fv_x_spawn], F_VEHICLES[f_id][slot][fv_y_spawn], F_VEHICLES[f_id][slot][fv_z_spawn], F_VEHICLES[f_id][slot][fv_a_spawn]);
		mysql_tquery(SQL, mysql_upit, "mysql_factions_vehInsert", "iii", f_id, slot, vehicleid);
	}
	else
		Koristite(playerid, "createorgveh [ID organizacije] [modelid]");
	
	return 1;
}

flags:deleteorg(FLAG_ADMIN_6)
CMD:deleteorg(playerid, const params[])
{
	if (!IsPlayerOwner(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new
		fname[MAX_FNAME_LENGTH+1],
		f_id
	;

	if(!sscanf(params, "s[32]", fname))
	{
		for(new i = 0; i < MAX_FACTIONS; i++)
		{
			if(!strcmp(FACTIONS[i][f_naziv], fname, true))
			{
				f_id = i;

				if(f_id == -1)
					return ErrorMsg(playerid, "Ne postoji organizacija sa tim imenom.");
				
				if(IsLawFaction(f_id))
					return ErrorMsg(playerid, "Ne mozes obrisati ovu organizaciju.");

				FACTIONS[f_id][f_vrsta] =
				FACTIONS[f_id][f_max_clanova] =
				FACTIONS[f_id][f_max_vozila] =
				FACTIONS[f_id][f_entid] =
				FACTIONS[f_id][f_budzet] =
				FACTIONS[f_id][f_materijali] =
				FACTIONS[f_id][f_materijali_skladiste] =
				FACTIONS[f_id][f_wars_won] =
				FACTIONS[f_id][f_wars_lost] =
				FACTIONS[f_id][f_wars_draw] =
				FACTIONS[f_id][f_boja_1] =
				FACTIONS[f_id][f_boja_2] = -1;
				format(FACTIONS[f_id][f_naziv], MAX_FNAME_LENGTH, "");
				format(FACTIONS[f_id][f_tag],   MAX_FTAG_LENGTH, "");
				format(FACTIONS[f_id][f_hex], MAX_HEX_LENGTH, "");
				format(FACTIONS[f_id][f_rgb], 2, "");
				
				FACTIONS[f_id][f_x_ulaz] =
				FACTIONS[f_id][f_y_ulaz] =
				FACTIONS[f_id][f_z_ulaz] =
				FACTIONS[f_id][f_a_ulaz] =
				FACTIONS[f_id][f_x_spawn] =
				FACTIONS[f_id][f_y_spawn] =
				FACTIONS[f_id][f_z_spawn] =
				FACTIONS[f_id][f_a_spawn] =
				FACTIONS[f_id][f_x_izlaz] =
				FACTIONS[f_id][f_y_izlaz] =
				FACTIONS[f_id][f_z_izlaz] =
				FACTIONS[f_id][f_a_izlaz] = 0.0;
				FACTIONS[f_id][f_ent_spawn] =
				FACTIONS[f_id][f_ent] =
				FACTIONS[f_id][f_vw] =
				FACTIONS[f_id][f_max_clanova] =
				FACTIONS[f_id][f_max_vozila] =
				FACTIONS[f_id][f_vw_spawn] = 0;

				FACTIONS[f_id][f_heroin] =
				FACTIONS[f_id][f_mdma] =
				FACTIONS[f_id][f_weed] = -1;

				DestroyDynamicArea(FACTIONS[f_id][f_areaid]);
				DestroyDynamicArea(FACTIONS[f_id][f_sefArea]);
				DestroyDynamicArea(FACTIONS[f_id][f_sefArea]);
				DestroyDynamicArea(FACTIONS[f_id][f_interactCP]);

				FACTIONS[f_id][f_loaded] = -1;

				if(IsValidDynamic3DTextLabel(FACTIONS[f_id][f_sefLabel]))
					DestroyDynamic3DTextLabel(FACTIONS[f_id][f_sefLabel]);

				// brisanje rankova
				for__loop (new j = 0; j < MAX_FACTIONS_RANKS; j++) 
				{
					strmid(F_RANKS[f_id][j][fr_ime], "N/A", 0, strlen("N/A"), MAX_RANK_LENGTH);
					F_RANKS[f_id][j][fr_skin] =
					F_RANKS[f_id][j][fr_dozvole] = 0;
				}

				new
					sQuery[100]
				;
				format(sQuery, sizeof sQuery, "DELETE FROM factions_ranks WHERE faction_id = %d", f_id);
				mysql_tquery(SQL, sQuery);

				// brisanje kapija
				for__loop (new l = 0; i < MAX_FACTIONS_GATES; l++) 
				{
					if(!IsValidDynamicObject(F_GATES[f_id][l][fg_obj_id]))
						continue;
					
					F_GATES[f_id][l][fg_vrsta] =
					F_GATES[f_id][l][fg_model] = -1;

					F_GATES[f_id][l][fg_closed_x] =
					F_GATES[f_id][l][fg_closed_y] =
					F_GATES[f_id][l][fg_closed_z] =
					F_GATES[f_id][l][fg_open_x] =
					F_GATES[f_id][l][fg_open_y] =
					F_GATES[f_id][l][fg_open_z] = 0.0;

					DestroyDynamicObject(F_GATES[f_id][l][fg_obj_id]);
				}

				format(sQuery, sizeof sQuery, "DELETE FROM factions_gates WHERE f_id = %d", f_id);
				mysql_tquery(SQL, sQuery);

				// brisanje vozila
				for__loop (new k = 0; k < MAX_FACTIONS_VEHICLES; k++) 
				{
					if (F_VEHICLES[f_id][k][fv_vehicle_id] != -1)
					{
						F_VEHICLES[f_id][k][fv_model_id] =
						F_VEHICLES[f_id][k][fv_cena] =
						F_VEHICLES[f_id][k][fv_mysql_id] =
						F_VEHICLES[f_id][k][fv_prodaja] = -1;

						F_VEHICLES[f_id][k][fv_x_spawn] =
						F_VEHICLES[f_id][k][fv_y_spawn] =
						F_VEHICLES[f_id][k][fv_z_spawn] =
						F_VEHICLES[f_id][k][fv_a_spawn] = 0.0;

						Iter_Remove(faction_vehicles, F_VEHICLES[f_id][k][fv_vehicle_id]);
						DestroyVehicle(F_VEHICLES[f_id][k][fv_vehicle_id]);
						F_VEHICLES[f_id][k][fv_vehicle_id] = INVALID_VEHICLE_ID;

						for(new j = 0; j < 7; j++)
						{
							F_VEH_WEAPONS[f_id][k][j][fv_weapon] =
							F_VEH_WEAPONS[f_id][k][j][fv_ammo] = -1;
						}

						format(sQuery, sizeof sQuery, "SELECT v_id FROM factions_vehicles WHERE faction_id = %d", f_id);
						mysql_tquery(SQL, sQuery, "mysql_remove_vehicle_weapons");
					}
				}

				format(sQuery, sizeof sQuery, "DELETE FROM factions_vehicles WHERE faction_id = %d", f_id);
				mysql_tquery(SQL, sQuery);

				format(sQuery, sizeof sQuery, "DELETE FROM factions WHERE id = %d", f_id);
				mysql_tquery(SQL, sQuery);

				InfoMsg(playerid, "Uspjesno si izbrisao organizaciju ID %i (%s)", f_id, fname);
				return 1;
			}
		}

		return ErrorMsg(playerid, "Ne postoji nijedna orgazniacija sa tim imenom");
	}
	else
		Koristite(playerid, "deleteorg [Puno ime organizacije] {BFC0C2}*napomena: Prvo izbacite sve clanove iz te organizacije!");

	return 1;
}

CMD:orgizrada(playerid, const params[])
{
	if (!IsHeadAdmin(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (F_IZRADA[IZRADA_AKTIVNA] == 1)
		return ErrorMsg(playerid, "Mod izrade organizacije je vec aktivan.");
		
	
	// Provera parametara
	if (sscanf(params, "iiiii", F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], F_IZRADA[IZRADA_BOJA_2]))
	{
		Koristite(playerid, "orgizrada [Vrsta] [Max clanova] [Max vozila] [Boja vozila (1)] [Boja vozila (2)]");
		SendClientMessage(playerid, BELA, "Dostupne vrste: 1 - mafija, 2 - banda, 3 - policija, 4 - bolnica");
		
		return 1;
	}
	
	if (F_IZRADA[IZRADA_VRSTA] != FACTION_MAFIA && F_IZRADA[IZRADA_VRSTA] != FACTION_GANG && F_IZRADA[IZRADA_VRSTA] != FACTION_LAW && F_IZRADA[IZRADA_VRSTA] != FACTION_RACERS && F_IZRADA[IZRADA_VRSTA] != FACTION_MD)
		return ErrorMsg(playerid, "Nevazeci unos za polje \"vrsta\".");
		
	if (F_IZRADA[IZRADA_MAX_CLANOVA] < 1 || F_IZRADA[IZRADA_MAX_CLANOVA] >= MAX_FACTIONS_MEMBERS)
		return ErrorMsg(playerid, "Nevazeci unos za polje \"max clanova\".");
		
	if (F_IZRADA[IZRADA_MAX_VOZILA] < 1 || F_IZRADA[IZRADA_MAX_VOZILA] >= MAX_FACTIONS_VEHICLES)
		return ErrorMsg(playerid, "Nevazeci unos za polje \"max vozila\".");
		
	if (F_IZRADA[IZRADA_BOJA_1] < 0 || F_IZRADA[IZRADA_BOJA_2] < 0 || F_IZRADA[IZRADA_BOJA_1] > 255 || F_IZRADA[IZRADA_BOJA_2] > 255)
		return ErrorMsg(playerid, "Nevazeci unos za polje \"boja_1\" ili \"boja_2\" (0-255).");
		
		
	F_IZRADA[IZRADA_AKTIVNA] = 1;
	
	new sDialog[260];
	format(sDialog, sizeof sDialog, "{0068B3}Pokrenuli ste izradu nove organiacije.\n\n{FFFFFF}Vrsta: {0068B3}%s (%d)\n{FFFFFF}Max clanova: {0068B3}%d\n{FFFFFF}Max vozila: {0068B3}%d\n{FFFFFF}Boje: {0068B3}%d, %d\n\n\n{FFFFFF}Upisite pun naziv za ovu organizaciju (max. %d znakova):", 
		faction_name(F_IZRADA[IZRADA_VRSTA], FNAME_LOWER), F_IZRADA[IZRADA_VRSTA], F_IZRADA[IZRADA_MAX_CLANOVA], F_IZRADA[IZRADA_MAX_VOZILA], F_IZRADA[IZRADA_BOJA_1], F_IZRADA[IZRADA_BOJA_2], MAX_FNAME_LENGTH);
	SPD(playerid, "org_izrada_naziv", DIALOG_STYLE_INPUT, "{0068B3}Izrada organizacije", sDialog, "Dalje »", "Odustani");
	
	return 1;
}

CMD:lider(playerid, const params[]) 
{
	if (!IsAdmin(playerid, 5) && (PI[playerid][p_org_id] == -1 || PI[playerid][p_org_rank] != RANK_LEADER) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	
	if (!IsAdmin(playerid, 5) && !PlayerFlagGet(playerid, FLAG_LEADER_VODJA) && PI[playerid][p_org_rank] == RANK_LEADER) // Lider
	{
		new f_id = PI[playerid][p_org_id];
		
		if (FACTIONS[f_id][f_loaded] == -1) // organizacija nije ucitana
			return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (32)");
		
		F_IZMENA[playerid][IZMENA_AKTIVNA] = 1;
		F_IZMENA[playerid][IZMENA_ITEM]    = IZMENA_NISTA;
		F_IZMENA[playerid][IZMENA_ID]      = f_id;
		
		showDialog_org_podaci_2(playerid, f_id);
	}
	else if (IsAdmin(playerid, 5) || PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) // Admin/vodja lidera
	{
		new sDialog[MAX_FACTIONS * 43];
		sDialog[0] = EOS;
		
		for__loop (new i = 0, x = -1; i < MAX_FACTIONS; i++) 
		{
			if (FACTIONS[i][f_loaded] != -1) 
			{
				x++;
				faction_listitem[playerid][x] = i;
				
				format(sDialog, sizeof(sDialog), "%s%s (id: %d)\n", sDialog, FACTIONS[i][f_naziv], i);
			}
		}
		
		if (isnull(sDialog))
			return ErrorMsg(playerid, "Nijedna organizacija nije ucitana u mod.");
			
		F_IZMENA[playerid][IZMENA_AKTIVNA] = 1;
		F_IZMENA[playerid][IZMENA_ITEM]    = IZMENA_NISTA;
		F_IZMENA[playerid][IZMENA_ID]      = -1;
		
		SPD(playerid, "org_podaci_1", DIALOG_STYLE_LIST, "{0068B3}Podaci organizacije", sDialog, "Dalje »", "Izadji");
	}
	else
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	
	return 1;
}

CMD:lideri(playerid, const params[]) 
{
	if (IsAdmin(playerid, 3) || PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
	{
		// Admini >= 3 mogu da vide sve lidere + on/off status
		new 
			id[2], sDialog[36 + (MAX_FACTIONS)*144];
		// format(sDialog, sizeof(sDialog), "Grupa\tLider\tStatus\nSpisak lidera:");
		format(sDialog, sizeof(sDialog), "Lider\tGrupa\tStatus\nSpisak lidera:");
		
		for__loop (new i = 0; i < MAX_FACTIONS; i++) 
		{
			if (FACTIONS[i][f_loaded] == -1) continue; // nije ucitana
			
			id[0] = GetPlayerIDFromName(F_LEADERS[i][0]);
			id[1] = GetPlayerIDFromName(F_LEADERS[i][1]);

			//format(sDialog, sizeof sDialog, "%s\n%s\t{%s}%s\t%s\n%s\t{%s}%s\t%s", sDialog, F_LEADERS[i][0], FACTIONS[i][f_rgb], FACTIONS[i][f_naziv], (IsPlayerConnected(id[0])?("{00FF00}ONLINE"):("{FF0000}OFFLINE"))); // , F_LEADERS[i][1], FACTIONS[i][f_rgb], FACTIONS[i][f_naziv], (IsPlayerConnected(id[1])?("{00FF00}ONLINE"):("{FF0000}OFFLINE"))
			format(sDialog, sizeof(sDialog), "\
				%s\n\
				{FFFFFF}%s\t{%s}%s\t%s\n\
				{FFFFFF}%s\t{%s}%s\t%s",
				sDialog, 
				F_LEADERS[i][0], FACTIONS[i][f_rgb], FACTIONS[i][f_naziv], (IsPlayerConnected(id[0])?("{00FF00}ONLINE"):("{FF0000}OFFLINE")), 
				F_LEADERS[i][1], FACTIONS[i][f_rgb], FACTIONS[i][f_naziv], (IsPlayerConnected(id[1])?("{00FF00}ONLINE"):("{FF0000}OFFLINE")));
		}

		new sDialogName[20];
		/*if (isnull(params))
		{
			sDialogName = "f_smeni_lidera";
		}
		else
		{
			sDialogName = "staff_lideri_spisak";
		}*/
		sDialogName = "f_smeni_lidera";
		SPD(playerid, sDialogName, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Spisak lidera", sDialog, "SMENI", "Zatvori");
	}
	else 
	{
		// Svi ostali mogu da vide samo online lidere
		new sDialog[36 + (MAX_FACTIONS)*144];
		format(sDialog, sizeof(sDialog), "Grupa\tLider\tStatus\nSpisak lidera:");
		foreach (new i : Player) 
		{
			new f_id = PI[i][p_org_id];
			if (f_id != -1 && PI[i][p_org_rank] == RANK_LEADER) 
			{
				// Igrac je lider neke org
				
				if (FACTIONS[f_id][f_vrsta] != FACTION_GANG || FACTIONS[f_id][f_vrsta] != FACTION_MAFIA || FACTIONS[f_id][f_vrsta] != FACTION_RACERS) 
				{
					// Nije ni mafija ni banda (za njih se ne mogu videti lideri jer nije rp)
					
					format(sDialog, sizeof(sDialog), "%s\n{%s}%s\t{FFFFFF}%s", sDialog, FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv], ime_rp[i]);
				}
			}
		}

		SPD(playerid, "no_return", DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Spisak lidera", sDialog, "U redu", "");
	}
	
	return 1;
}

CMD:f(playerid, params[]) 
{
	new
		f_id = PI[playerid][p_org_id],
		r_id = PI[playerid][p_org_rank]
	;
	
	if (f_id == -1)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	
	if (r_id == -1)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if ((F_RANKS[f_id][r_id][fr_dozvole] & DOZVOLA_CHAT) == 0)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);

	if (PI[playerid][p_area] > 0)
		return overwatch_poruka(playerid, "Ne mozete koristiti ovaj chat dok ste zatvoreni.");
		
	if (gettime() < koristio_chat[playerid]) 
		return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
		
	if (isnull(params)) 
		return Koristite(playerid, "f [Tekst]");

	if (PI[playerid][p_zavezan] != 0)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");

	if (!IsChatEnabled(playerid, CHAT_FACTION))
		return ErrorMsg(playerid, "Iskljucili ste /f kanal. Koristite /chat da ga ponovo ukljucite.");
		
	koristio_chat[playerid] = gettime() + 3;
	zastiti_chat(playerid, params);

	// Odredjivanje boje ispisivanja (razlicita je za LAW organizacije)
	new boja[7];
	if (FACTIONS[f_id][f_vrsta] == FACTION_LAW) boja = "78A6B4";
	else boja = "FBC800";
		

	// Formatiranje poruke za slanje
	new string[145];
	if (F_RANKS[f_id][r_id][fr_dozvole] != 0 && !isnull(F_RANKS[f_id][r_id][fr_ime])) 
	{
		format(string, sizeof string, "(%s) {%s}%s %s[%i]: {FFFFFF}%s", FACTIONS[f_id][f_tag], boja, F_RANKS[f_id][r_id][fr_ime], ime_rp[playerid], playerid, params);
		// FactionMsg(f_id, "{%s}%s %s[%i]: {FFFFFF}%s", boja, F_RANKS[f_id][r_id][fr_ime], ime_rp[playerid], playerid, params);
	}
	else
	{
		format(string, sizeof string, "(%s) {%s}Rank %d %s[%i]: {FFFFFF}%s", FACTIONS[f_id][f_tag], boja, r_id, ime_rp[playerid], playerid, params);
		// FactionMsg(f_id, "{%s}Rank %d %s[%i]: {FFFFFF}%s", boja, r_id, ime_rp[playerid], playerid, params);
	}

	// Slanje poruke
	foreach (new i : Player) 
	{
		if ((PI[i][p_org_id] == f_id && IsChatEnabled(i, CHAT_FACTION)) || faction_listeting[i] == f_id)
			SendClientMessage(i, HexToInt(FACTIONS[f_id][f_hex]), string);
	}


	// Upisivanje u log
	new sLog[145], sFile[25 + MAX_FTAG_LENGTH];
	format(sFile, sizeof sFile, "logs/chat/factions/%s.txt", FACTIONS[f_id][f_tag]);
	format(sLog, sizeof sLog, "%s: %s", ime_obicno[playerid], params);
	Log_Write(sFile, sLog);
	return 1;
}

CMD:zavezi(playerid, const params[])
{
	new
		f_id = PI[playerid][p_org_id],
		r_id = PI[playerid][p_org_rank],
		id
	;
	
	if (!IsACriminal(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new fID = GetFactionIDbyName("Pink Panter");
	if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (fID != GetPlayerFactionID(playerid)) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici Pink Panter-a!"); 
		
	if (sscanf(params, "u", id))
		return Koristite(playerid, "zavezi [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerNearPlayer(playerid, id, 3.0) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
		return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

	if (IsPlayerAFK(id))
		return ErrorMsg(playerid, "Ne mozete zavezati ovog igraca jer je AFK.");
		
	if (IsPlayerJailed(playerid) || IsPlayerJailed(id))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
		
	if (PI[id][p_org_id] == f_id && PI[id][p_org_rank] >= r_id) // Ista organizacija i veci ili isti rank
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima istog ili viseg ranka.");
		
	if (IsPlayerHandcuffed(id))
		return ErrorMsg(playerid, "Ovaj igrac je vec zavezan lisicama, ne mozete mu staviti uze.");

	if (!IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Morate biti u vozilu.");

	if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(id))
		return ErrorMsg(playerid, "Morate biti unutar istog vozila kao i ovaj igrac.");
		
	if (PI[playerid][p_zavezan] != 0)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");

	if (IsPlayerRopeTied(id))
		return ErrorMsg(playerid, "Taj igrac je vec zavezan.");
		
	if (!BP_PlayerHasItem(playerid, ITEM_UZE))
		return ErrorMsg(playerid, "Nemate uze.");

	BP_PlayerItemSub(playerid, ITEM_UZE);
		
	gPlayerRopeTied{id} = true;
	PI[id][p_zavezan]  = 1;
	
	TogglePlayerControllable_H(id, false);
	SetPlayerCuffed(id, true);
	
	// Slanje poruka igracima
	SendClientMessageF(playerid, SVETLOPLAVA, "* Zavezali ste uzetom %s[%d].", ime_rp[id], id);
	SendClientMessageF(id, SVETLOCRVENA, "* %s Vas je zavezao uzetom.", ime_rp[playerid]);

	KillTimer(tmrKidnappingWL[playerid]);
	tmrKidnappingWL[playerid] = SetTimerEx("SetKidnappingWantedLevel", 300*1000, false, "iiii", playerid, cinc[playerid], id, cinc[id]);
	return 1;
}

CMD:odvezi(playerid, const params[])
{
	new
		f_id = PI[playerid][p_org_id],
		r_id = PI[playerid][p_org_rank],
		id
	;
	
	if (!IsACriminal(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (sscanf(params, "u", id))
		return Koristite(playerid, "odvezi [Ime ili ID igraca]");
		
	if (!IsPlayerConnected(id))
		return ErrorMsg(playerid, GRESKA_OFFLINE);
		
	new Float:poz[3];
	GetPlayerPos(id, poz[0], poz[1], poz[2]);
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, poz[0], poz[1], poz[2]))
		return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");
		
	if (IsPlayerJailed(playerid) || IsPlayerJailed(id))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");
		
	if (PI[id][p_org_id] == f_id && PI[id][p_org_rank] >= r_id) // Ista organizacija i veci ili isti rank
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu nad clanovima istog ili viseg ranka.");
		
	if (IsPlayerHandcuffed(id))
		return ErrorMsg(playerid, "Ovaj igrac je vec zavezan lisicama, ne mozete ga odvezati.");
		
	if (GetPlayerVehicleID(playerid) != GetPlayerVehicleID(id))
		return ErrorMsg(playerid, "Morate biti unutar istog vozila kao i ovaj igrac, ili morate obojica biti van vozila.");
		
	if (PI[playerid][p_zavezan] != 0)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");

	if (!IsPlayerRopeTied(id))
		return ErrorMsg(playerid, "Taj igrac nije zavezan uzetom.");
		
	
	gPlayerRopeTied{id} = false;
	PI[id][p_zavezan]  = 0;
	
	TogglePlayerControllable_H(id, true);
	SetPlayerCuffed(id, false);
	
	// Slanje poruka igracima
	SendClientMessageF(playerid, SVETLOPLAVA, "* Odvezali ste %s[%d].", ime_rp[id], id);
	SendClientMessageF(id, ZUTA, "* %s Vas je odvezao.", ime_rp[playerid]);
	return 1;
}

CMD:grupa(playerid, const params[])
{
	new 
		string[80],
		naslov[MAX_FNAME_LENGTH + 8], 
		f_id = PI[playerid][p_org_id];

	if (f_id == -1)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije/mafije/bande.");

	if (f_id < 0 || f_id >= MAX_FACTIONS)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (33)");
		
	if (FACTIONS[f_id][f_loaded] == -1)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[factions.pwn] "GRESKA_NEPOZNATO" (34)");

	if (PI[playerid][p_org_rank] == RANK_LEADER)
		return callcmd::lider(playerid, "");

	format(naslov, sizeof(naslov), "{%s}%s", FACTIONS[f_id][f_rgb], FACTIONS[f_id][f_naziv]);

	if (IsACop(playerid))
	{
		format(string, sizeof(string), "Informacije\nSpisak clanova\nNapusti %s\nUputstvo za pocetnike", faction_name(f_id, FNAME_AKUZATIV));
	}
	else
	{
		format(string, sizeof(string), "Informacije\nSpisak clanova\nNapusti %s", faction_name(f_id, FNAME_AKUZATIV));
	}
	
	SPD(playerid, "grupa", DIALOG_STYLE_LIST, naslov, string, "Dalje »", "Izadji");

	return 1;
}

CMD:org(playerid, const params[]) 
{
	if (PI[playerid][p_org_id] == -1)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije.");

	new vrsta = FACTIONS[PI[playerid][p_org_id]][f_vrsta];
	if (vrsta != FACTION_LAW && vrsta != FACTION_MD)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije.");

	return callcmd::grupa(playerid, "");
}

CMD:banda(playerid, const params[]) 
{
	if (PI[playerid][p_org_id] == -1)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije/mafije/bande.");

	new vrsta = FACTIONS[PI[playerid][p_org_id]][f_vrsta];
	if (vrsta != FACTION_GANG)
		return ErrorMsg(playerid, "Niste clan ni jedne bande.");

	return callcmd::grupa(playerid, "");
}

CMD:mafija(playerid, const params[]) {
	if (PI[playerid][p_org_id] == -1)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije/mafije/bande.");

	new vrsta = FACTIONS[PI[playerid][p_org_id]][f_vrsta];
	if (vrsta != FACTION_MAFIA && vrsta != FACTION_RACERS)
		return ErrorMsg(playerid, "Niste clan ni jedne mafije.");

	return callcmd::grupa(playerid, "");
}

CMD:gepek(playerid, const params[]) 
{
	if (!IsACriminal(playerid))
		return ErrorMsg(playerid, "Koristite /vozilo.");

	new f_id = PI[playerid][p_org_id];
	SetPVarInt(playerid, "FactionVehSlot", -1);

	for__loop (new Float:pos[3], slot = 0; slot < FACTIONS[f_id][f_max_vozila]; slot++) 
	{
		GetPosBehindVehicle(F_VEHICLES[f_id][slot][fv_vehicle_id], pos[POS_X], pos[POS_Y], pos[POS_Z]);
		if (IsPlayerInRangeOfPoint(playerid, 1.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) 
		{
			SetPVarInt(playerid, "FactionVehSlot", slot);
		}
	}
	if (GetPVarInt(playerid, "FactionVehSlot") == -1)
		return ErrorMsg(playerid, "Morate stajati blizu gepeka vozila koje pripada Vasoj mafiji/bandi.");


	return SPD(playerid, "fv_gepek", DIALOG_STYLE_LIST, "{FFFFFF}Gepek", "Uzmi iz gepeka\nStavi u gepek", "Dalje »", "Odustani");
}

CMD:clanovi(playerid, const params[])
{
	new f_id = PI[playerid][p_org_id];
	if (f_id == -1)
		return ErrorMsg(playerid, "Niste clan ni jedne organizacije/mafije/bande.");

	SendClientMessage(playerid, HexToInt(FACTIONS[f_id][f_hex]), "_______________ Online clanovi _______________");
	foreach (new i : Player)
	{
		if (PI[i][p_org_id] == f_id)
		{
			new sMsg[145];
			if (IsPlayerAFK(i))
			{
				format(sMsg, sizeof sMsg, "- %s (AFK: %s)", ime_rp[i], konvertuj_vreme(GetPlayerAFKTime(i)));
			}
			else
			{
				format(sMsg, sizeof sMsg, "- %s", ime_rp[i]);
			}

			if (IsLeader(playerid))
			{
				if (PI[i][p_area] > 0)
				{
					format(sMsg, sizeof sMsg, "%s | Zatvoren: [%d minuta]", sMsg, PI[i][p_zatvoren]);
				}
				if (PI[i][p_utisan] > 0)
				{
					format(sMsg, sizeof sMsg, "%s | Utisan: [%s]", sMsg, konvertuj_vreme(PI[i][p_utisan], true));
				}
			}

			SendClientMessage(playerid, BELA, sMsg);
		}
	}
	return 1;
}

CMD:reketpodigni(playerid, const params[])
{
	if (!IsACriminal(playerid) || PI[playerid][p_org_rank] < 4)
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new lid, gid, iznos,
		f_id = PI[playerid][p_org_id];

	if (sscanf(params, "ii", lid, iznos))
		return Koristite(playerid, "reketpodigni [ID firme] [Iznos]");

	if (lid < 1 || lid > RE_GetMaxID_Business())
		return ErrorMsg(playerid, "ID mora biti izmedju 1 i %i.", RE_GetMaxID_Business());

	gid = re_globalid(firma, lid);
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]))
		return ErrorMsg(playerid, "Morate biti na pickupu sa informacijama o firmi.");

	if (BizInfo[lid][BIZ_REKET] != f_id)
		return ErrorMsg(playerid, "Vasa mafija/banda ne reketira ovu firmu.");

	if (iznos < 1 || iznos > 99999999)
		return ErrorMsg(playerid, "Uneli ste nevazeci iznos.");

	if (GetRacketMoney(lid) < iznos)
		return ErrorMsg(playerid, "Nema toliko novca za Vas! Mozete podici najvise %s.", formatMoneyString(GetRacketMoney(lid)));

	BizInfo[lid][BIZ_NOVAC_REKET] -= iznos;
	FACTIONS[f_id][f_budzet] += iznos;

	FactionMsg(f_id, "{FFFFFF}U budzet je dodato {%s}%s {FFFFFF}(od firme %s).", FACTIONS[f_id][f_rgb], formatMoneyString(iznos), BizInfo[lid][BIZ_NAZIV]);

	// MySQL update
	new query[256];
	format(query, sizeof query, "UPDATE re_firme SET novac_reket = %i WHERE id = %i", GetRacketMoney(lid), lid);
	mysql_tquery(SQL, query);
	format(query, sizeof query, "UPDATE factions SET budzet = %d WHERE id = %d", FACTIONS[f_id][f_budzet], f_id);
	mysql_tquery(SQL, query);

	// Upisivanje u log - mysql
	format(mysql_upit, 150, "INSERT INTO factions_logs (f_id, tekst) VALUES (%d, '%s je podigao reket iz firme %i, iznos: %s.')", f_id, ime_obicno[playerid], lid, formatMoneyString(iznos));
	mysql_pquery(SQL, mysql_upit);

	return 1;
}

CMD:vuci(playerid, const params[])
{
	if (!IsACop(playerid) && !IsACriminal(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new targetid;
	if (sscanf(params, "u", targetid))
		return Koristite(playerid, "vuci [Ime ili ID igraca]");

	if (playerid == targetid)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu na sebi.");

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerNearPlayer(playerid, targetid, 3.0) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
		return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

	if (IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Morate biti van vozila da biste koristili ovu komandu.");

	if (IsPlayerInAnyVehicle(targetid))
		return ErrorMsg(playerid, "Igrac mora biti van vozila da biste ga vukli.");
		
	if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");

	if (IsACop(playerid))
	{
		if (!IsPlayerOnLawDuty(playerid))
			return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

		if (IsACop(targetid))
			return ErrorMsg(playerid, "Ne mozete da koristite ovu komandu na svojim kolegama.");
	}

	if (!IsPlayerRopeTied(targetid) && !IsPlayerHandcuffed(targetid))
		return ErrorMsg(playerid, "Igrac mora biti zavezan uzetom/lisicama da biste ga vukli.");

	if (IsPlayerPullingPlayer(playerid))
		return ErrorMsg(playerid, "Vec vucete nekog igraca.");

	if (IsPlayerAttachedToPlayer(targetid))
		return ErrorMsg(playerid, "Neko drugi vec vuce ovog igraca.");


	AttachPlayerToPlayer(playerid, targetid);

	SendClientMessageF(playerid, SVETLOPLAVA, "* Sada vucete %s. Da ga pustite koristite /pusti.", ime_rp[targetid]);
	SendClientMessageF(targetid, SVETLOCRVENA, "(!) %s je poceo da Vas vuce.", ime_rp[playerid]);
	return 1;
}

CMD:pusti(playerid, const params[])
{
	if (!IsACop(playerid) && !IsACriminal(playerid))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new targetid;
	if (sscanf(params, "u", targetid))
		return Koristite(playerid, "pusti [Ime ili ID igraca]");

	if (playerid == targetid)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu na sebi.");

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (!IsPlayerNearPlayer(playerid, targetid, 3.0) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
		return ErrorMsg(playerid, "Nalazite se previse daleko od ovog igraca.");

	if (IsPlayerInAnyVehicle(playerid))
		return ErrorMsg(playerid, "Morate biti van vozila da biste koristili ovu komandu.");

	if (IsPlayerInAnyVehicle(targetid))
		return ErrorMsg(playerid, "Igrac mora biti van vozila da biste ga vukli.");
		
	if (IsPlayerJailed(playerid) || IsPlayerJailed(targetid))
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu u zatvoru.");

	if (IsACop(playerid))
	{
		if (!IsPlayerOnLawDuty(playerid))
			return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu naredbu.");

		if (IsACop(targetid))
			return ErrorMsg(playerid, "Ne mozete da koristite ovu komandu na svojim kolegama.");
	}

	if (!IsPlayerPullingPlayer(playerid))
		return ErrorMsg(playerid, "Ne vucete nikoga.");

	if (!IsPlayerAttachedToPlayer(targetid))
		return ErrorMsg(playerid, "Niko ne vuce ovog igraca.");


	StopPullingPlayer(playerid);

	SendClientMessageF(playerid, SVETLOPLAVA, "* Pustili ste %s.", ime_rp[targetid]);
	SendClientMessageF(targetid, SVETLOCRVENA, "* %s Vas je pustio.", ime_rp[playerid]);
	return 1;
}

CMD:l(playerid, const params[])
{
	if (!IsLeader(playerid) && !IsAdmin(playerid, 4))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	if (IsLeader(playerid) && !IsAdmin(playerid, 4) && !gLeaderChat)
		return ErrorMsg(playerid, "Head Admin je privremeno iskljucio /l kanal.");

	if (PI[playerid][p_utisan] > 0) 
		return overwatch_poruka(playerid, GRESKA_UTISAN);

	if (isnull(params))
		return Koristite(playerid, "l [Tekst]");

	if (!IsChatEnabled(playerid, CHAT_LEADER))
		return ErrorMsg(playerid, "Iskljucili ste /l kanal. Koristite /chat da ga ponovo ukljucite.");

	foreach (new i : Player)
	{
		if ((IsLeader(i) || IsAdmin(i, 1)) && IsChatEnabled(i, CHAT_LEADER))
		{
			if (PI[playerid][p_org_id] != -1)
			{
				SendClientMessageF(i, 0xCD5C5CFF, "%s | %s[%i]: {FFFFFF}%s", FACTIONS[PI[playerid][p_org_id]][f_tag], ime_rp[playerid], playerid, params);
			}
			else
			{
				SendClientMessageF(i, 0xCD5C5CFF, "Admin | %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, params);
			}
		}
	}
	return 1;
}

flags:ltog(FLAG_ADMIN_6)
CMD:ltog(playerid, const params[])
{
	gLeaderChat = !gLeaderChat;

	new sMsg[60];
	format(sMsg, sizeof sMsg, "Admin %s je %s /l kanal.", (gLeaderChat)?("ukljucio"):("iskljucio"));

	foreach (new i : Player)
	{
		if ((IsLeader(i) || IsAdmin(i, 1)) && IsChatEnabled(i, CHAT_LEADER))
		{
			SendClientMessage(i, 0xCD5C5CFF, sMsg);
		}
	}
	return 1;
}

flags:fslusaj(FLAG_ADMIN_5)
CMD:fslusaj(playerid, const params[])
{
	new f_id;
	if (sscanf(params, "k<ftag>", f_id))
		return Koristite(playerid, "fslusaj [ID ili naziv fakcije | -1 = off] ");
			
	if (f_id < -1 || f_id >= MAX_FACTIONS) 
		return ErrorMsg(playerid, "Nevazeci unos!");

	if (f_id == -1)
	{
		// Iskljucivanje
		InfoMsg(playerid, "Iskljucili ste prisluskivanje /f kanala.");
	}
	else
	{
		InfoMsg(playerid, "Ukljucili ste prisluskivanje /f kanala od {FFFFFF}%s.", FACTIONS[f_id][f_naziv]);
		SendClientMessage(playerid, BELA, " * Za iskljucivanje koristite \"/fslusaj -1\".");
	}
	
	faction_listeting[playerid] = f_id;
	return 1;
}

alias:skinilisice("razbijlisice")
CMD:skinilisice(playerid, const params[])
{
	if (IsACop(playerid))
	{
		new SendClientMessaged[35];
		format(SendClientMessaged, sizeof SendClientMessaged, "%s", params);
		return callcmd::lisice(playerid, SendClientMessaged);
	}

	if (!BP_PlayerItemGetCount(playerid, ITEM_SNALICA))
		return ErrorMsg(playerid, "Nemate snalicu.");

	new targetid;
	if (sscanf(params, "u", targetid))
		return Koristite(playerid, "lisice [Ime ili ID igraca]");

	if (!IsPlayerConnected(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (playerid == targetid)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu na sebi.");

	if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
		return ErrorMsg(playerid, "Previse ste daleko od tog igraca.");

	if (!IsPlayerHandcuffed(targetid))
		return ErrorMsg(playerid, "Taj igrac nema lisice na rukama.");
		
	if (PI[playerid][p_zavezan] != 0)
		return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zavezani.");

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	foreach (new i : iPolicemen)
	{
		if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
		{
			ErrorMsg(playerid, "Ne mozete koristiti ovu komandu dok je policija u blizini.");
			return 1;
		}
	}

	SetPVarInt(playerid, "pBreakingCuffsID", targetid);
	PlayerStartBurglary(playerid, 500);
	ApplyAnimation(playerid, "SHOP", "SHP_Serve_Loop", 4.1, 1, 0, 0, 0, 0);
	BP_PlayerItemSub(playerid, ITEM_SNALICA);

	new string[86];
	format(string, sizeof string, "* %s pokusava da otkljuca lisice %s.", ime_rp[playerid], ime_rp[targetid]);
	RangeMsg(playerid, string, LJUBICASTA, 15.0);
	return 1;
}

CMD:orgkazna(playerid, const params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2592.6440,2583.1599,-97.9156))
		return ErrorMsg(playerid, "Placanje kazne se moze izvrsiti samo u opstini.");

	new sDialog[87],
		pay = 100000
	;

	if (PI[playerid][p_nivo] > 10)
		pay += 100000 * (PI[playerid][p_nivo] - 10);

	format(sDialog, sizeof sDialog, "{FFFFFF}Za skidanje zabrane ulaska u organizaciju morate platiti {FF0000}%s.", formatMoneyString(pay));
	SPD(playerid, "orgkazna", DIALOG_STYLE_MSGBOX, "PLATI ORG KAZNU", sDialog, "Plati", "Odustani");
	return 1;
}

CMD:sef(playerid, const params[])
{
	new f_id = PI[playerid][p_org_id];
	if (f_id != -1)
	{
		if (IsPlayerInDynamicArea(playerid, FACTIONS[f_id][f_sefArea]) && GetPlayerVirtualWorld(playerid) == FACTIONS[f_id][f_vw])
		{
			if (IsACriminal(playerid))
			{
				ShowSafeTextDraw(playerid);
			}
			else if (IsACop(playerid))
			{
				SPD(playerid, "f_sef", DIALOG_STYLE_LIST, "Sef", "Pregled stanja\nUzmi novac\nStavi novac", "Dalje", "Izadji");
			}
			else {
				SendClientMessage(playerid, -1, "whaa");
			}
			return ~1;
		}
	}
	return 1;
}

/*CMD:popravka(playerid, const params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 7.0, 2593.9099,-2180.5962,0.5287)) // UGR
		return ErrorMsg(playerid, "Nisi na mestu za popravku vozila.");

	if (!IsARacer(playerid))
		return ErrorMsg(playerid, "Ne mozes koristiti ovo mesto za popravku vozila.");



	new vehicleid = GetPlayerVehicleID(playerid);

	new engine, lights, alarm, doors, bonnet, boot, objective;
	RepairVehicle(vehicleid);
	SetVehicleHealth(vehicleid, 999.0);
	
	// Pali vozilo ako je bilo ugaseno jer je bilo mnogo osteceno
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);

	GameTextForPlayer(playerid, "~g~Vozilo je popravljeno", 3500, 3);
	return 1;
}*/

// CMD:race(playerid, const params[])
// {
//     if (isnull(params) || !strcmp(params, "help", false))
//     {
//         Koristite(playerid, "race clear - za resetovanje prethodno sacuvane trke");
//         Koristite(playerid, "race cp1 - za obelezavanje startne pozicije");
//         Koristite(playerid, "race cp2 - za obelezavanje krajnjeg CP-a (cilj)");
//         Koristite(playerid, "race signup - da se prijavis za ucestvovanje u trci");
//         Koristite(playerid, "race start - za pokretanje trke");
//         return 1;
//     }
// }
GetFactionIDbyName(const name[]) {
	new id = -1;
	for (new f_id; f_id < MAX_FACTIONS; f_id++)
	{
		if (!strcmp(name, FACTIONS[f_id][f_naziv], true)) {
			id = f_id;
			break;
		}
	}
	return id;
}
GiveFactionSafeMoney(const name[], money)
{
	new f_id = GetFactionIDbyName(name);
	if (f_id != -1) {
		FactionMoneyAdd(f_id, money);
	}
	return true;
}
