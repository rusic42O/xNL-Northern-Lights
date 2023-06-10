#include <YSI_Coding\y_hooks>

/*
    Razrada sistema:

    Priprema: Potrebno 3 PD-a i 3 clana organizacije online na serveru;
              Kupi busilicu i dinamit;

    Zapocni pljacku: Upucaj securitya u banci; Prodji do sefa i postavi busilicu tipkom N; Sacekaj 10min dok probijes vrata sefa;
                     Kada probijes vrata sefa udji unutra i pokupi novac tipkom N; Nakon toga postavi dinamit na kanalizacioni otvor te se udalji;
                     Nakon 10sec desiti ce se eksplozija te tada mozete proci kroz kanalizaciju do markera gdje birate saht na koji izlazite (random pozicije);
                     Nakon izlaska imati cete marker na vratima svoje organizacije; Potrebno je da dodjete do tamo i pljacka je uspjesna;
                     Novac od pljacke se automatski stavlja u sef organizacije a svi clanovi koji su blizu dostavljaca novca dobijaju skill up.

    Preuzimanje torbe: Ukoliko igrac koji nosi torbu s novcem umre ili napusti server, baciti ce na pod tu torbu koju moze pokupiti ili PD ili Mafija/Banda;
                       Nakon sto pokupite dobijate marker koji oznacava vrata vase orge;
                       Tu morate odnijeti taj novac da, ako ste PD sprijecite, a ako ste mafija/banda da dovrsite pljacku.

    Razrada sistema:

    Priprema: Potrebno 3 PD-a i 3 clana organizacije online na serveru;
              Kupi busilicu i dinamit;

    Zapocni pljacku: Upucaj securitya u banci; Prodji do sefa i postavi busilicu tipkom N;
                     Sacekaj 10min dok probijes vrata sefa;
                     Kada probijes vrata sefa udji unutra i pokupi novac tipkom N;
                     Nakon toga postavi dinamit na kanalizacioni otvor te se udalji;
                     Nakon 10sec desiti ce se eksplozija i raznosi se saht;
                     Tada idete kroz kanalizaciju do markera gdje birate saht na koji izlazite (random pozicije);
                     Nakon izlaska imati cete marker na vratima svoje organizacije;
                     Potrebno je da dodjete do tamo i pljacka je uspjesna;
                     Novac od pljacke se automatski stavlja u sef organizacije;
                     Svi clanovi koji su blizu dostavljaca novca dobijaju skill up.

    Preuzimanje torbe: Ukoliko igrac koji nosi torbu s novcem umre ili napusti server, baciti ce na pod tu torbu koju moze pokupiti ili PD ili Mafija/Banda;
                       Nakon sto pokupite dobijate marker koji oznacava vrata vase orge;
                       Tu morate odnijeti taj novac da, ako ste PD sprijecite, a ako ste mafija/banda da dovrsite pljacku.

*/

enum
{
    BANK_STAGE_READY = 1,
    BANK_STAGE_GUARD_KILLED, // Ubijen cuvar, tece timer za drop kartice
    BANK_STAGE_DOORS_UNLOCKED, // Otvorena glavna vrata za ulazak u trezor
    BANK_STAGE_ROBBED, // Pljacka je uspesna, ceka se na odnosenje novca u bazu
    BANK_STAGE_COOLDOWN, // Zavrsena/prekinuta pljacka
}

new Float:RandomSahte[6][3] =
{
    {1523.2170,-1191.4794,23.8450},
    {1617.8984,-994.4554,24.0670},
    {1520.9397,-969.8616,36.5628},
    {1293.4557,-990.5220,32.6953},
    {1522.2638,-1664.5452,13.5757},
    {1365.7897,-1289.0082,13.5469}
};

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define BANK_ROB_BOUNTY   (400000)
#define BANK_ROB_BONUS    (120000) // rand max
#define MAX_VEHS          6



// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bRob_stage,
    bRob_cooldown,
    bRob_faction,
    bRob_checkpoint,
    bRob_time,
    bRob_policeTarget, // Ne resetuje se dok igrac ne umre, bude uhapsen, izadje iz igre..
    bRob_actor,
    bool:bRob_killed[MAX_PLAYERS char],
    bRob_prepKoji,
    bRob_initiator,
    Kanalizacija,
    Busilica[5],
    NovacBanka[17],
    NosiBankaTorbu[MAX_PLAYERS],
    BankaSef,
    tmr_bRob,
    bRob_pickupbag,
    lastplbanka
;

// callbacks;

hook OnGameModeInit() 
{
    bRob_initiator = INVALID_PLAYER_ID;
    bRob_faction = bRob_checkpoint = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_stage = BANK_STAGE_READY;

    testingdaddy = false;

    bRob_pickupbag = -1;

    Busilica[0] = INVALID_OBJECT_ID;
    NovacBanka[0] = INVALID_OBJECT_ID;
    bRob_actor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, false, 100.0, 0);
    ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    KreirajNovac();

    KreirajKanalizaciju();

    CreateDynamic3DTextLabel("[ KANALIZACIJA IZLAZ ]\n {FFFFFF}Da izadjete kroz kanalizaciju koristite tipku 'F' ili 'ENTER'",0x9EC73DAA,1454.9529,-912.6064,19.9656, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    //CreateDynamic3DTextLabel("{FF0000}[ PLJACKA BANKE ]\n{FF9900}/pljacka", BELA, 1470.8264,-978.0361,22.8931, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("[ BUSILICA ]\n {FFFFFF}Da postavite busilicu koristite tipku 'N'", 0x9EC73DAA, 1460.6890,-969.0071,23.9261, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ DINAMIT ]\n {FFFFFF}Da postavite dinamit koristite tipku 'Y'", 0x9EC73DAA, 1454.5032,-960.9556,24.0797, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ NOVAC ]\n {FFFFFF}Da pokupite novac u torbu koristite tipku 'N'", 0x9EC73DAA, 1462.6451,-959.3177,24.0797, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);

    BankaSef = CreateDynamicObject(18846, 1461.008178, -966.659118, 25.796073, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(BankaSef, 0, 10412, "hotel1", "gold128", 0x00000000);
    SetDynamicObjectMaterial(BankaSef, 1, 10412, "hotel1", "gold128", 0x00000000);

    return 1;
}

hook OnPlayerConnect(playerid)
{
    bRob_killed{playerid} = false;
    lastplbanka = INVALID_PLAYER_ID;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnDynamicActorStreamIn(actorid, forplayerid)
{
    SetDynamicActorPos(bRob_actor, 1440.9053, -985.0209, 25.5261);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerGiveDmgDynActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    if (actorid == bRob_actor)
    {
        new fid = GetFactionIDbyName("La Casa De Papel");

        if(GetPlayerFactionID(playerid) != fid)
            return ErrorMsg(playerid, "Samo La Casa De Papel moze zapoceti pljacku.");
        
        if(gettime() < GetBankCooldownTimestamp())
            return ErrorMsg(playerid, "Banka je nedavno opljackana, pokusajte ponovo kasnije!");

        new
            saigraci = 0,
            pds = 0;

        foreach (new i : Player)
        {
            if (i == playerid) continue;
            if (PI[i][p_org_id] == PI[playerid][p_org_id] && IsPlayerNearPlayer(playerid, i, 10.0)) saigraci++;
            if(IsACop(i)) pds++;
        }
        if(!testingdaddy) {
            if (saigraci < 3) {
                //bRob_Reset();
                AddPlayerCrime(playerid, INVALID_PLAYER_ID, 4, "Pokusaj pljacke banke", "Snimak sa nadzorne kamere");
                return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku banke.");
            } 
            if (pds < 3) {
                //bRob_Reset();
                BankRobberyReset();
                return ErrorMsg(playerid, "Na serveru moraju biti prisutna minimalno 3 policajca da biste pokrenuli pljacku banke.");
            }
        }

        bRob_faction = PI[playerid][p_org_id];
        bRob_prepKoji = 1;
        bRob_stage = BANK_STAGE_GUARD_KILLED;

        DestroyDynamicActor(bRob_actor);

        InfoMsg(playerid, "Uspjesno ste ranili security-a, prodjite dalje te postavite busilicu na vrata sefa (Klik 'N')!");

        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Napad na zastitara", "Snimak sa nadzorne kamere");

        // Slanje poruke policiji i obavestenje za sve igrace
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Security NL banke je ranjen od strane neidentifikovane kriminalne grupe!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom dijelu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}moguca pljacka banke u toku!");

        // Upisivanje u log

        static logStr[99];
        format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pds, saigraci);
        Log_Write(LOG_ROBBERY, logStr);
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_NO))
    {
        if (bRob_prepKoji == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1460.8927,-966.8206,23.9261) && BP_PlayerItemGetCount(playerid, ITEM_DRILL))
        {
            if(Busilica[0] != INVALID_OBJECT_ID) return ErrorMsg(playerid, "Busilica je vec postavljena.");
            bRob_time = 2*60; // 600
            TextDrawSetString(tdBankRobTime, "BUSENJE:   10:00");

            BP_PlayerItemSub(playerid, ITEM_DRILL);

            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == bRob_faction || IsACop(i))
                    TextDrawShowForPlayer(i, tdBankRobTime);
            }

            KreirajBusilicu();
            tmr_bRob = SetTimer("BankRobbery", 1*1000, true); // ukupno 600 sekundi
        }
        else if (bRob_prepKoji == 2 && IsPlayerInRangeOfPoint(playerid, 3.0, 1462.4852,-959.4798,24.0797) && GetPlayerFactionID(playerid) == GetFactionIDbyName("La Casa De Papel"))
        {
            bRob_prepKoji = 3;
            UnistiNovac();

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject( playerid, SLOT_BACKPACK, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );

            NosiBankaTorbu[playerid] = true;

            bRob_initiator = playerid;
            bRob_policeTarget = playerid;

            bRob_stage = BANK_STAGE_ROBBED;

            InfoMsg(playerid, "Uspjesno ste ukrali novac, postavite dinamit na kanalizacioni otvor u blizini kako biste mogli pobjeci.");
        }
        return 1;
    }    // bRob_prepKoji
    else if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1454.9529,-912.6064,19.9656) && !IsPlayerInAnyVehicle(playerid) && GetPlayerFactionID(playerid) == GetFactionIDbyName("La Casa De Papel")) //Kanalizacija 
        {
            SPD(playerid, "SahteOdabir", DIALOG_STYLE_LIST, "Odabir sahta", "Saht 1\nSaht 2\nSaht 3\nSaht 4\nSaht 5\nSaht 6", "Potvrdi", "Odustani");
            if(NosiBankaTorbu[playerid])
                bRob_checkpoint = SetPlayerCheckpoint(playerid, FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn], 3.0);
            return 1;
        }
    }
    else if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, 1454.6167,-958.7255,24.0556) && PI[playerid][p_bomba][BOMBA_S] >= 1 && GetPlayerFactionID(playerid) == GetFactionIDbyName("La Casa De Papel"))
        {
            PI[playerid][p_bomba][BOMBA_S] -= 1;
            SetTimerEx("ClearAnim", 2000, false, "i", playerid);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 1, 0);
            return 1;
        }
    }
    return 1;
}

Dialog:SahteOdabir(playerid, response, listitem, const inputtext[]) {

	if(!response) return 1;
	if(response) {
        if(bRob_prepKoji != 4) return 1;
		switch(listitem) {

	 	    case 0: {
                
                SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 1: {
                
                SetPlayerCompensatedPos(playerid,RandomSahte[1][0], RandomSahte[1][1], RandomSahte[1][2]);
		 	    return 1;
	 	    }
	 	    case 2: {
	 	    	
				SetPlayerCompensatedPos(playerid,RandomSahte[2][0], RandomSahte[2][1], RandomSahte[2][2]);
		 	    return 1;
	 	    }
	 	    case 3: {

				SetPlayerCompensatedPos(playerid,RandomSahte[3][0], RandomSahte[3][1], RandomSahte[3][2]);
		 	    return 1;
	 	    }
	 	    case 4: {
	 	
				SetPlayerCompensatedPos(playerid,RandomSahte[4][0], RandomSahte[4][1], RandomSahte[4][2]);
		 	    return 1;
	 	    }
	 	    case 5: {
	 	    	
				SetPlayerCompensatedPos(playerid,RandomSahte[5][0], RandomSahte[5][1], RandomSahte[5][2]);
		 	    return 1;
	 	    }
		}
	}

	return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (IsPlayerInRangeOfPoint(playerid, 3.0, FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn]) && bRob_prepKoji == 4 && playerid == bRob_policeTarget)
    {
        DisablePlayerCheckpoint(playerid), bRob_checkpoint = -1;
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
        RemoveBankPoliceTarget();

        new
            bounty = GetBankRobBounty(),
            sLog[75];

        if(IsACop(playerid))
        {
            //new bounty = floatround(GetBankRobBounty()/10000.0) * 10000 * 2;
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je ubijen u vatrenom okrsaju sa policijom.", ime_rp[bRob_initiator]);
            SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog hrabrog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(floatround(bounty/10000.0) * 10000 * 2));

            static skill = 3;

            // Skill UP za policajca i njegove pomocnike + nagrada za odbranjenu banku/zlataru u sef
            static Float:x,Float:y,Float:z;
            GetPlayerPos(playerid, x, y, z);
            foreach (new i : Player)
            {
                if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                {
                    PlayerUpdateCopSkill(i, skill, SKILL_BANKWIN, (i==playerid)? 0 : 1);
                }
            }

            FACTIONS[PI[playerid][p_org_id]][f_budzet] += floatround(bounty/10000.0) * 10000 * 2;

            // Upisivanje u log
            format(sLog, sizeof sLog, "BANKA-FAILED (PDWON) | %s | %s | %s", FACTIONS[bRob_faction][f_tag], ime_obicno[playerid], formatMoneyString(bounty));
            Log_Write(LOG_ROBBERY, sLog);
        }
        else if(IsACriminal(playerid))
        {
            // Upisivanje u log
            format(sLog, sizeof sLog, "BANKA-USPEH | %s | %s | %s", FACTIONS[bRob_faction][f_tag], ime_obicno[playerid], formatMoneyString(bounty));
            Log_Write(LOG_ROBBERY, sLog);

            SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je banku!");
            SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, vrednost ukradenog novca se procenjuje na oko {FF0000}%s!", formatMoneyString(bounty));
            SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

            // Skill UP za sve clanove u okolini + dodavanje novca u sef
            static
                Float:x,Float:y,Float:z,
                totalRanks = 0
            ;

            new
                fid = PI[playerid][p_org_id];

            FACTIONS[fid][f_budzet] += bounty;

            if (IsACriminal(playerid))
            {
                
                //Iter_Clear(iAwardPlayers);
                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (PI[i][p_org_id] == fid)
                    {
                        if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z) && !IsPlayerAFK(i))
                        {
                            totalRanks += PI[i][p_org_rank];

                            if (i == playerid)
                                PlayerUpdateCriminalSkill(i, 5, SKILL_ROBBERY_BANK, 0);
                            else
                                PlayerUpdateCriminalSkill(i, 2, SKILL_ROBBERY_BANK, 1);
                        }
                    }
                }
            }

            // Oduzimanje novca svim igracima koji su izasli sa servera u prethodnih 20 minuta
            new sQuery[125];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = banka * 0.95 WHERE banka > 0 AND org_id != %i AND poslednja_aktivnost > NOW() - INTERVAL 20 MINUTE", PI[playerid][p_org_id]);
            mysql_tquery(SQL, sQuery);

            // Oduzimanje novca svim online igracima
            new
                oldValue
            ;

            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == PI[playerid][p_org_id]) continue; // Preskace clanove mafije/bande koja je opljackala banku
                if (IsPlayerAFK(i) && GetPlayerAFKTime(i) > 1800) continue; // Preskace igrace koji su AFK preko pola sata

                if (PI[i][p_banka] > 0)
                {
                    oldValue = PI[i][p_banka];
                    PI[i][p_banka] = random(25000);
                    
                    format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %i WHERE id = %i", PI[i][p_banka], PI[i][p_id]);
                    mysql_tquery(SQL, sQuery);

                    SendClientMessageF(i, SVETLOCRVENA, "** Sa tvog bankovnog racuna nestalo je {FF0000}%s.", formatMoneyString(oldValue - PI[i][p_banka]));
                }
            }
        }

        // Resetovanje
        bRob_Reset();
        return ~1;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (bRob_prepKoji == 4 && bRob_policeTarget == playerid)
    {
        if (IsPlayerConnected(killerid))
        {
            if(PI[playerid][p_org_id] == PI[killerid][p_org_id])
                PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "TK");

            if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
                RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

            if(IsACop(playerid))
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!");
            else if(IsACriminal(playerid))
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti novac!");

            static
                Float:X,
                Float:Y,
                Float:Z
            ;

            GetPlayerPos(playerid, X,Y,Z);

            bRob_pickupbag = CreateDynamicPickup(1550, 1, X, Y, Z, 0, 0);

            foreach (new i : Player)
            {
                if (IsPlayerInRangeOfPoint(i, 50.0, X, Y, Z))
                {
                    Streamer_Update(i, STREAMER_TYPE_PICKUP);
                    DebugMsg(i, "BankRob_BagDrop");
                }
            }

            RemoveBankPoliceTarget();
            lastplbanka = playerid;
            NosiBankaTorbu[playerid] = false;

            if(bRob_initiator == playerid)
                bRob_initiator = INVALID_PLAYER_ID;

            // Upisivanje u log
            new logStr[60];
            format(logStr, sizeof logStr, "BANKA-DROPBAG | %s je ubio %s", ime_obicno[killerid], ime_obicno[playerid]);
            Log_Write(LOG_ROBBERY, logStr);
        }
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    static
        Float:X,
        Float:Y,
        Float:Z
    ;
    GetPlayerPos(playerid, X, Y, Z);

    if (pickupid == bRob_pickupbag && lastplbanka != playerid)
    {
        if(IsACriminal(playerid))
        {
            DestroyDynamicPickup(bRob_pickupbag), bRob_pickupbag = -1;

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject( playerid, SLOT_BACKPACK, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );

            bRob_checkpoint = -1;
            bRob_faction = PI[playerid][p_org_id];
            bRob_checkpoint = CreatePlayerCP(FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn], 7.0, 0, 0, playerid, 6000.0);

            NosiBankaTorbu[playerid] = true;

            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako doznajemo, drugo kriminalno lice pokusava ukrasti novac!");

            //bRob_initiator = playerid;
            bRob_policeTarget = playerid;
        }
        else if(IsACop(playerid))
        {
            DestroyDynamicPickup(bRob_pickupbag), bRob_pickupbag = -1;

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject( playerid, SLOT_BACKPACK, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );

            bRob_checkpoint = -1;
            bRob_faction = PI[playerid][p_org_id];
            bRob_checkpoint = CreatePlayerCP(FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn], 7.0, 0, 0, playerid, 6000.0);

            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako doznajemo, policija nastoji odnijeti novac na sigurno!");

            NosiBankaTorbu[playerid] = true;
            bRob_policeTarget = playerid;
        }
        else {
            DestroyDynamicPickup(bRob_pickupbag), bRob_pickupbag = -1;
            bRob_pickupbag = CreateDynamicPickup(1550, 1, X, Y, Z, 0, 0);
            //AddPlayerCrime(playerid, "Policija", 2, "Pokusaj kradje novca.");
            SetPlayerCompensatedPos(playerid, X, Y+0.3, Z+0.3);
            ErrorMsg(playerid, "Niste clan organizacije te niste u mogucnosti pokupiti novac od pljacke.");
        }
    }
    else {
        DestroyDynamicPickup(bRob_pickupbag), bRob_pickupbag = -1;
        bRob_pickupbag = CreateDynamicPickup(1550, 1, X, Y, Z, 0, 0);
        //AddPlayerCrime(playerid, "Policija", 2, "Pokusaj kradje novca.");
        SetPlayerCompensatedPos(playerid, X, Y+0.3, Z+0.3);
        ErrorMsg(playerid, "Niste clan organizacije te niste u mogucnosti pokupiti novac od pljacke.");
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(playerid == bRob_initiator || playerid == bRob_policeTarget)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        if(IsACop(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!");
        else
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti novac!");

        static
            Float:X,
            Float:Y,
            Float:Z
        ;

        GetPlayerPos(playerid, X,Y,Z);

        bRob_pickupbag = CreateDynamicPickup(1550, 1, X, Y, Z, 0, 0);

        foreach (new i : Player)
        {
            if (IsPlayerInRangeOfPoint(i, 50.0, X, Y, Z))
            {
                Streamer_Update(i, STREAMER_TYPE_PICKUP);
                DebugMsg(i, "BankRob_BagDrop");
            }
        }

        RemoveBankPoliceTarget();

        NosiBankaTorbu[playerid] = false;

        if(bRob_initiator == playerid)
            bRob_initiator = INVALID_PLAYER_ID;

        // Upisivanje u log
        new logStr[60];
        format(logStr, sizeof logStr, "BANKA-DROPBAG | %s je napustio server", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerSpawn(playerid)
{
    if (playerid == bRob_initiator)
    {
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        SendClientMessageToAll(CRVENA, "OVERWATCH | {FFFFFF}Pljacka banke je propala.");

        // Upisivanje u log
        new logStr[51];
        format(logStr, sizeof logStr, "BANKA-FAIL | %s | Respawn", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (bRob_policeTarget == playerid)
    {
        bRob_policeTarget = INVALID_PLAYER_ID;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

KreirajNovac() {

    NovacBanka[0] = CreateDynamicObject(1271, 1463.455566, -959.532043, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[0], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[1] = CreateDynamicObject(1271, 1464.318481, -959.362609, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[1], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[2] = CreateDynamicObject(1271, 1463.802246, -958.846374, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[2], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[3] = CreateDynamicObject(1271, 1463.278930, -958.323059, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[3], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[4] = CreateDynamicObject(1271, 1462.755737, -957.799865, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[4], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[5] = CreateDynamicObject(1271, 1463.469604, -957.523986, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[5], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[6] = CreateDynamicObject(1271, 1464.000000, -958.054199, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[6], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[7] = CreateDynamicObject(1271, 1464.509033, -958.563293, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[7], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[8] = CreateDynamicObject(1271, 1464.374389, -957.424499, 23.409669, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[8], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[9] = CreateDynamicObject(1271, 1463.454345, -957.523742, 24.069667, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[9], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[10] = CreateDynamicObject(1271, 1463.949096, -958.018615, 24.069667, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[10], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[11] = CreateDynamicObject(1271, 1464.415893, -958.485229, 24.069667, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[11], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[12] = CreateDynamicObject(1271, 1463.010375, -957.941101, 24.049673, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[12], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[13] = CreateDynamicObject(1271, 1463.483764, -958.542175, 24.059673, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[13], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[14] = CreateDynamicObject(1271, 1464.006835, -959.065307, 24.059673, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[14], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[15] = CreateDynamicObject(1271, 1463.907836, -958.598571, 24.699672, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[15], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    NovacBanka[16] = CreateDynamicObject(1271, 1463.377441, -958.068176, 24.699672, 0.000000, 0.000000, 45.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(NovacBanka[16], 0, 1550, "cj_money_bags", "money_128", 0x00000000);
    //NovacBanka[17] = CreateDynamicObject(19355, 1454.533935, -958.686828, 22.969671, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
}

KreirajKanalizaciju() {

    Kanalizacija = CreateDynamicObject(19355, 1454.533935, -958.686828, 22.969671, 0.000000, 90.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(Kanalizacija, 0, 2986, "imm_roomx", "kb_imvent", 0x00000000);
}

UnistiKanalizaciju() {

    DestroyDynamicObject(Kanalizacija);
    Kanalizacija = INVALID_OBJECT_ID;
}

UnistiNovac() {

    for(new i = 0; i < 17; i++) {

        DestroyDynamicObject(NovacBanka[i]);
    }
}

KreirajBusilicu() {

    Busilica[0] = CreateDynamicObject(18717, 1460.670043, -966.685180, 22.927171, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    Busilica[1] = CreateDynamicObject(18655, 1460.668823, -968.905639, 22.104099, 0.000000, 34.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(Busilica[1], 0, 18868, "mobilephone4", "mobilephone4-1", 0x00000000);
    SetDynamicObjectMaterial(Busilica[1], 1, 10101, "2notherbuildsfe", "Bow_Abpave_Gen", 0x00000000);
    Busilica[2] = CreateDynamicObject(2006, 1460.662475, -966.816650, 24.608776, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(Busilica[2], 0, 18996, "mattextures", "sampblack", 0x00000000);
    Busilica[3] = CreateDynamicObject(2006, 1460.662475, -966.716552, 24.608776, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(Busilica[3], 0, 18996, "mattextures", "sampblack", 0x00000000);
    Busilica[4] = CreateDynamicObject(19610, 1460.673217, -966.616638, 24.611816, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00);
}

UnistiBusilicu() {

    for(new i = 0; i < 5; i++) {

        DestroyDynamicObject(Busilica[i]);
        Busilica[i] = INVALID_OBJECT_ID;
    }
}

PomeriBankaVrata() {

    MoveDynamicObject(BankaSef, 1456.978149, -967.740112, 25.527011, 10.0, 0.000000, 105.000000, 90.000000);
}

stock IsPlayerRobbingBank(playerid) 
{
    if (bRob_initiator == playerid) return 1;
    return 0;
}

stock GetFactionRobbingBank()
{
    return bRob_faction;
}

stock GetBankPoliceTarget()
{
    return bRob_policeTarget;
}

stock RemoveBankPoliceTarget()
{
    bRob_policeTarget = INVALID_PLAYER_ID;
}

BankRob_SetPoliceTarget(playerid)
{
    bRob_policeTarget = playerid;
}

stock GetBankRobBounty()
{
    return BANK_ROB_BOUNTY + random(BANK_ROB_BONUS);
}

stock IsBankRobberyInProgress()
{
    if (bRob_stage == BANK_STAGE_GUARD_KILLED || bRob_stage == BANK_STAGE_DOORS_UNLOCKED || bRob_stage == BANK_STAGE_ROBBED)
        return 1;

    return 0;
}

stock GetBankCooldownTimestamp()
{
    return bRob_cooldown;
}

// more;

forward BankRob_GuardDrop();
public BankRob_GuardDrop()
{
    ApplyDynamicActorAnimation(bRob_actor, "PED","KO_skid_front", 4.1, 0, 1, 1, 1, 1); 

    SetTimer("BankRob_CheckStart", 300000, false);
    return 1;
}

forward BankRob_CheckStart();
public BankRob_CheckStart()
{
    if (bRob_stage > BANK_STAGE_READY && bRob_stage < BANK_STAGE_DOORS_UNLOCKED)
    {
        bRob_Reset();
        SendClientMessageToAll(CRVENA, "OVERWATCH | {FFFFFF}Pljacka banke je ponistena jer nije zapoceta na vreme.");
    }

    return 1;
}

forward BankRobbery();
public BankRobbery()
{
    if (DebugFunctions())
    {
        LogFunctionExec("BankRobbery");
    }

    bRob_time -= 1;

    new str[26];
    format(str, sizeof str, "BUSENJE:   %s", konvertuj_vreme(bRob_time));
    TextDrawSetString(tdBankRobTime, str);

    if (bRob_time == -1)
    {
        KillTimer(tmr_bRob), tmr_bRob = 0;
        TextDrawHideForAll(tdBankRobTime);

        UnistiBusilicu();
        PomeriBankaVrata();

        bRob_prepKoji = 2;

        foreach(new i : Player) {
            if(IsPlayerRobbingBank(i))
                InfoMsg(i, "Uspjesno ste probili vrata sefa, pokupite novac (Klik 'N')!");
        }
    }
    return 1;
}

// functions;

stock bRob_Reset() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("bRob_Reset");
    }

    if (IsValidDynamicCP(bRob_checkpoint))
    {
        if (IsPlayerConnected(bRob_initiator))
            DisablePlayerCheckpoint(bRob_initiator);
        else
            DisablePlayerCheckpoint(bRob_policeTarget);
    }

    bRob_faction = bRob_initiator = bRob_checkpoint = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_cooldown = gettime() + 10800; // 3h cooldown

    bRob_stage = BANK_STAGE_COOLDOWN;

    TextDrawHideForAll(tdBankRobTime);
    
    DestroyDynamicActor(bRob_actor), bRob_actor = -1;
    MoveDynamicObject(BankaSef, 1461.008178, -966.659118, 25.796073, 10.0, 0.000000, 90.000000, 90.000000);
    KreirajNovac();
    KreirajKanalizaciju();

    foreach (new i : Player)
    {
        bRob_killed{i} = false;
        Streamer_Update(i, STREAMER_TYPE_OBJECT);
    }

    SetTimer("BankRobberyReset", (60+60+60)*60*1000, false);
    return 1;
}

// publics;

forward BankRobberyReset();
public BankRobberyReset()
{
    if (DebugFunctions())
    {
        LogFunctionExec("BankRobberyReset");
    }

    DestroyDynamicActor(bRob_actor);
    bRob_actor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, false, 100.0, 0);
    ClearDynamicActorAnimations(bRob_actor);
    ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    bRob_stage = BANK_STAGE_READY;
    bRob_cooldown = gettime();
   
    return 1;
}

forward ClearAnim(playerid);
public ClearAnim(playerid)
{
    ClearAnimations(playerid, 1);
    SetTimerEx("ExplodeDynamite", 10000, false, "i", playerid);
    GameTextForPlayer(playerid, "Bomba ce eksplodirati za 10 sekundi~n~udaljite se!", 3000, 3);
    return 1;
}

forward ExplodeDynamite(playerid);
public ExplodeDynamite(playerid) {
    
    UnistiKanalizaciju();
    CreateExplosion(1454.5032,-960.9556,24.0797, 12, 2.0);
    InfoMsg(playerid, "Uspjesno ste unistili prolaz za kanalizaciju.");
    bRob_prepKoji = 4;
    return 1;
}

// cmds;
flags:bankreset(FLAG_ADMIN_6)
CMD:bankreset(playerid, params[])
{
    bRob_Reset();
    BankRobberyReset();
    return 1;
}
