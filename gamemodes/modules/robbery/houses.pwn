#include <YSI_Coding\y_hooks>

static KradjaKuceVreme[MAX_PLAYERS], NeMozeVreme[MAX_PLAYERS];

CMD:kradjakuce(playerid, arg[]) {
	if (PI[playerid][p_org_id] == -1) return ErrorMsg(playerid, "Niste u organizaciji");
	
	if (FACTIONS[PI[playerid][p_org_id]][f_vrsta] == FACTION_LAW)
		return ErrorMsg(playerid, "Vi ste policajac, ne mozete obijati kuce.");

	//new fID = GetFactionIDbyName("Pink Panter");
	//if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (GetPlayerFactionID(playerid) == 0) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici ilegalnih organizacija!");//Pink Panter-a
	
	new gid = -1;
	for(new kid; kid < MAX_KUCA; kid++) {
		if (IsPlayerInRangeOfPoint(playerid, 3.0, RealEstate[kid][RE_ULAZ][0], RealEstate[kid][RE_ULAZ][1], RealEstate[kid][RE_ULAZ][2])) {
			gid = kid;
			break;
		}
	}
	if (gid == -1) return ErrorMsg(playerid, "Niste blizu neke kuce!");

	if (KradjaKuceVreme[playerid] != 0) return ErrorMsg(playerid, "Vec pljackate!");
	if (gettime() - NeMozeVreme[playerid] < 300) return ErrorMsg(playerid, "Svakih 5 minuta mozete pljackati kuce, sacekajte malo!");
	if (RealEstate[gid][RE_ZATVORENO] == 1) {
		if (!BP_PlayerHasItem(playerid, ITEM_CROWBAR))
			return ErrorMsg(playerid, "Nemate pajser da biste zapoceli kradju.");
	
		new try = random(2);
		switch (try) {
			case 0: {
				SendClientMessage(playerid, -1, "Pokusaj ulaska u kucu je neuspeo, i dobili ste wanted level!");
				AddPlayerCrime(playerid, INVALID_PLAYER_ID, 2, "Poksaj provale u kucu", "Alarmni sistem");
				return false;
			}
			case 1: {
				SetPlayerInterior(playerid, RealEstate[gid][RE_ENT]);
  				SetPlayerVirtualWorld(playerid, gid);
				SendClientMessage(playerid, -1, "Pokusaj ulaska u kucu je uspeo, ali ste dobili wanted level!");
				SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]);
				SetPlayerFacingAngle(playerid, RealEstate[gid][RE_IZLAZ][3]);
				AddPlayerCrime(playerid, INVALID_PLAYER_ID, 3, "Provala u kucu", "Komsija");
			}
			case 2: {
				SetPlayerInterior(playerid, RealEstate[gid][RE_ENT]);
    			SetPlayerVirtualWorld(playerid, gid);
				SendClientMessage(playerid, -1, "Pokusaj ulaska u kucu je uspeo, i niste dobili wanted level!");
				SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]);
				SetPlayerFacingAngle(playerid, RealEstate[gid][RE_IZLAZ][3]);
			}
		}
	}
	else {
		SendClientMessage(playerid, -1, "Kuca je otkljucana i usli ste i niste dobili wanted level!");
		SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]);
	}
	SendClientMessage(playerid, -1, "Zapoceli ste kradju kuce, ukoliko izadjete iz kuce kradja se prekida, ukoliko poginete takodje!");
	KradjaKuceVreme[playerid] = 120;
	NeMozeVreme[playerid] = gettime();
	SetTimerEx("ProveraKradjaKuce", 1000, false, "ii", playerid, gid);
	return true;
}

forward ProveraKradjaKuce(playerid, gid);
public ProveraKradjaKuce(playerid, gid) {

	if (KradjaKuceVreme[playerid] > 0)
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2])) {
			KradjaKuceVreme[playerid] --;
			new str[64];
			format(str, sizeof(str), "~r~Ostanite_u_kuci~n~jos_~y~%i_~r~sekundi", KradjaKuceVreme[playerid]);
			GameTextForPlayer(playerid, str, 999, 3);
			SetTimerEx("ProveraKradjaKuce", 1000, false, "ii", playerid, gid);
		}
		else {
			SendClientMessage(playerid, -1, "Nazalost, udaljili ste se iz kuce i pljacka je prekinuta!");
			KradjaKuceVreme[playerid] = 0;
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
		}
		
	}
	else {
		if (RealEstate[gid][RE_NOVAC] > 200) {
			RealEstate[gid][RE_NOVAC] -= RealEstate[gid][RE_NOVAC] / 2;
			PlayerMoneyAdd(playerid, RealEstate[gid][RE_NOVAC] / 2);
			new string[128];
			format(string, sizeof(string), "Opljackali ste $%d", RealEstate[gid][RE_NOVAC] / 2);
			SendClientMessage(playerid, 0x33CCFFFF, string);
		}
		else {
			SendClientMessage(playerid, -1, "Nazalost, u kuci nema novca i niste nista dobili!");
		} 
		KradjaKuceVreme[playerid] = 0;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
	}
	return true;
}