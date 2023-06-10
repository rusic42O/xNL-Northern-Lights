#include <YSI_Coding\y_hooks>

/*
    TODO handling:

    - Kada inicijator pogine
    - Kada inicijator bude uhapsen (zavezan)
    - Kada vreme istekne



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
    bRob_prepStage,
    bRob_prepKoji,
    bRob_uniformeId[2],
    bRob_getawayVehId[4],
    bRob_vehId[4],
    bool:bRob_imaPrep[MAX_PLAYERS],
    bRob_uniformaArea[2], // 0 - Uniforma mali Kradja, 1 - Uadlji se od mjesta
    bRob_hakerKoji,
    bRob_izaBankeArea,
    robSkinAdd,
    bRob_prepPokrenuo[MAX_PLAYER_NAME],
    Kanalizacija,
    busilica[5],
    NovacBanka[16],
    NosiBankaTorbu[MAX_PLAYERS],
    dynamitetick[MAX_PLAYERS],
    DynamiteTimer[MAX_PLAYERS],
    bool:testingdaddy
;


// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    bRob_faction = bRob_initiator = bRob_checkpoint = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_stage = BANK_STAGE_READY;

    testingdaddy = false;

    Busilica[0] == INVALID_OBJECT_ID;
    NovacBanka[0] = INVALID_OBJECT_ID;

    bRob_actor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, 0, 100.0);
    SetDynamicActorInvulnerable(bRob_actor, true);
    ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    KreirajNovac();

    KreirajKanalizaciju();

    CreateDynamic3DTextLabel("[ KANALIZACIJA IZLAZ ]\n {FFFFFF}Da izadjete kroz kanalizaciju koristite tipku 'F' ili 'ENTER'",0x9EC73DAA,1454.9529,-912.6064,19.9656, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ KANALIZACIJA ]\n {FFFFFF}Da probijete kanalizaciju\n/postavidinamit",0x9EC73DAA,1454.5032,-960.9556,24.0797, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);

    //CreateDynamic3DTextLabel("{FF0000}[ PLJACKA BANKE ]\n{FF9900}/pljacka", BELA, 1470.8264,-978.0361,22.8931, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("Mjesto za busilicu", BELA, 1105.4530,2657.2278,-60.0098, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);

    // Pickupi za izlaz
    bRob_pickupExit[0] = CreateDynamicPickup(19134, 1, 1423.5593,-975.9340,16.4130);
    //bRob_pickupExit[1] = CreateDynamicPickup(19134, 1, 1419.2909,-979.0989,16.4130);
    bRob_pickupExit[2] = CreateDynamicPickup(19134, 1, 1423.4276,-983.4382,16.4130);

    return 1;
}

hook OnPlayerConnect(playerid)
{
    bRob_killed{playerid} = false;
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
    }
}

PomeriBankaVrata() {

    MoveDynamicObject(BankaSef, 1456.978149, -967.740112, 25.527011, 10.0, 0.000000, 105.000000, 90.000000);
}

hook OnBombExplosion(playerid, Float:X, Float:Y, Float:Z)
{
    if (GetDistanceBetweenPoints(X, Y, Z, 1452.1536, -980.2452, 21.7592) <= 4.0 && IsACriminal(playerid)) 
    {
        // Postavljena je bomba u banci (resetka - samo mafije i bande)
        
        // Ventilacioni otvor
        DestroyDynamicObject(bRob_object[0]);
        bRob_object[0] = CreateDynamicObject(914, 1452.1536, -980.2452, 21.7592,  90.00000, 0.000000, 0.000000, 300.00, 300.00);

        bRob_bombExploded = true;

        foreach (new i : Player)
        {
            if (IsPlayerInRangeOfPoint(i, 50.0, 1452.1536, -980.2452, 21.7592))
                Streamer_Update(i, STREAMER_TYPE_OBJECT);
        }
    }
    return 1;
}

hook OnPlayerGiveDmgDynActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    DebugMsg(playerid, "OnPlayerGiveDmgDynActor");
    if (actorid == bRob_actor && GetBankCooldownTimestamp() < gettime())
    {
        static
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
                bRob_Reset();
                return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku banke.");
            } 
            if (pds < 3) {
                bRob_Reset();
                return ErrorMsg(playerid, "Na serveru moraju biti prisutna minimalno 3 policajca da biste pokrenuli pljacku banke.");
            }
        }

        bRob_faction = PI[playerid][p_org_id];
        bRob_prepKoji = 1;
        bRob_stage = BANK_STAGE_GUARD_KILLED;

        InfoMsg(i, "Uspjesno ste ranili security-a, prodjite dalje te postavite busilicu na vrata sefa (Klik 'N')!");

        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Napad na zastitara", "Snimak sa nadzorne kamere");

        // Slanje poruke policiji i obavestenje za sve igrace
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Security NL banke je ranjen od strane neidentifikovane kriminalne grupe!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom dijelu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}moguca pljacka banke u toku!");

        // Upisivanje u log

        format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pd_igraci, mb_igraci);
        Log_Write(LOG_ROBBERY, logStr);
    }
    else
        ErrorMsg(playerid, "Banka je nedavno opljackana, pokusajte ponovo kasnije!");

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_NO))
    {
        if (bRob_prepKoji == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1460.8927,-966.8206,23.9261))
        {
            if(Busilica[0] != INVALID_OBJECT_ID) return ErrorMsg(playerid, "Busilica je vec postavljena.");
            bRob_time = 600; // 600
            TextDrawSetString(tdBankRobTime, "BUSENJE:   10:00");

            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == bRob_faction || IsACop(i))
                    TextDrawShowForPlayer(i, tdBankRobTime);
            }

            KreirajBusilicu();
            tmr_bRob = SetTimer("BankRobbery", 1*1000, true); // ukupno 600 sekundi
        }
        else if (bRob_prepKoji == 2 && IsPlayerInRangeOfPoint(playerid, 3.0, 1462.4852,-959.4798,24.0797))
        {
            bRob_prepKoji = 3;
            UnistiNovac();

            RemovePlayerAttachedObject(playerid, TORBA_SLOT);
            SetPlayerAttachedObject( playerid, TORBA_SLOT, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );

            NosiBankaTorbu[playerid] = true;

            bRob_initiator = playerid;
            bRob_policeTarget = playerid;

            bRob_stage = BANK_STAGE_ROBBED;
        }
    }    // bRob_prepKoji
    else if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1454.9529,-912.6064,19.9656) && !IsPlayerInAnyVehicle(playerid)) //Kanalizacija 
        {
            SPD(playerid, "SahteOdabir", DIALOG_STYLE_LIST, "Odabir sahta", "Saht 1\nSaht 2\nSaht 3\nSaht 4\nSaht 5\nSaht 6", "Potvrdi", "Odustani");
            bRob_checkpoint = CreatePlayerCP(FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn], 7.0, 0, 0, i, 6000.0);
            return 1;
        }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == bRob_checkpoint && playerid == bRob_initiator && bRob_prepKoji == 4)
    {
        DestroyPlayerCP(bRob_checkpoint, playerid), bRob_checkpoint = -1;
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        new bounty = GetBankRobBounty();

        // Upisivanje u log
        new sLog[75];
        format(sLog, sizeof sLog, "BANKA-USPEH | %s | %s | %s", FACTIONS[bRob_faction][f_tag], ime_obicno[playerid], formatMoneyString(bounty));
        Log_Write(LOG_ROBBERY, sLog);

        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je banku!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, vrednost ukradenog novca se procenjuje na oko {FF0000}%s!", formatMoneyString( floatround(bounty/100000)*100000 ));
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        // Skill UP za sve clanove u okolini + dodavanje novca u sef
        static 
            fid = PI[playerid][p_org_id],
            Float:x,Float:y,Float:z,
            totalRanks = 0
        ;

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
        new sQuery[56],
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

        // Resetovanje
        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
        return ~1;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (bRob_policeTarget == playerid)
    {
        if (IsPlayerConnected(killerid))
        {
            if (PI[killerid][p_org_id] == PI[playerid][p_org_id])
            {
                // Pripadnik iste mafije/bande je ubio igraca koji pljacka
                PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "TK");
            }
            else if (IsACriminal(playerid) && IsACop(killerid)) // Policajac je ubio pljackasa
            {
                // Dobijaju duplo manju nagradu jer nisu uspeli da ga uhapse
                new bounty = floatround(GetBankRobBounty()/10000.0) * 10000 * 2;
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je ubijen u vatrenom okrsaju sa policijom.", ime_rp[playerid]);
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog hrabrog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(bounty));

                RemoveBankPoliceTarget();

                new logStr[99];
                format(logStr, sizeof logStr, "BANKA-UBISTVO | %s je ubio %s | %s", ime_obicno[killerid], ime_obicno[playerid], formatMoneyString(bounty));
                Log_Write(LOG_ROBBERY, logStr);

                new skill = 3;

                // Skill UP za policajca i njegove pomocnike + nagrada za odbranjenu banku/zlataru u sef
                new Float:x,Float:y,Float:z,
                    totalRanks = 0;
                GetPlayerPos(killerid, x, y, z);
                foreach (new i : Player)
                {
                    if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                    {
                        PlayerUpdateCopSkill(i, skill, SKILL_ARREST, (i==killerid)? 0 : 1);
                    }
                }

                //FACTIONS[0][f_budzet] += bounty;
            }
        }

        bRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (playerid == bRob_initiator)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        FactionMsg(bRob_faction, "{FF0000}Pljacka banke je propala jer je %s poginuo.", ime_rp[playerid]);

        SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je poginuo u tragicnoj nesreci.", ime_rp[playerid]);

        // Upisivanje u log
        new logStr[51];
        format(logStr, sizeof logStr, "BANKA-FAIL | %s je poginuo", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
    }
    else
    {
        if (IsBankRobberyInProgress())
        {
            if (IsPlayerInArea(playerid, 1381.9341,-1047.6711,1536.9153,-1012.4745) || (IsPlayerInArea(playerid, 1047.3020,2587.2583,1203.1895,2755.2480) && GetPlayerInterior(playerid) != 0 && GetPlayerVirtualWorld(playerid) != 0))
            {
                if (IsPlayerConnected(killerid) && bRob_killed{killerid})
                {
                    // Napravio RK
                    PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "Revenge Kill (banka)");
                    SetTimerEx("ShowRulesDialog_TURF_ROB", 30000, false, "ii", killerid, cinc[killerid]);
                }
                else
                {
                    bRob_killed{playerid} = true;
                }
            }
        }
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (playerid == bRob_initiator)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        SendClientMessageFToAll(CRVENA, "OVERWATCH | {FFFFFF}Pljacka banke je propala jer je {FF9933}%s {FFFFFF}napustio server.", ime_rp[playerid]);

        // Upisivanje u log
        new logStr[60];
        format(logStr, sizeof logStr, "BANKA-FAIL | %s je napustio server", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (bRob_policeTarget == playerid)
    {
        bRob_policeTarget = INVALID_PLAYER_ID;
    }
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
}

// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
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
    if (bRob_stage > BANK_STAGE_READY && bRob_stage < BANK_STAGE_ROBBERY_IN_PROGRESS)
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

        InfoMsg(i, "Uspjesno ste probili vrata sefa, pokupite novac (Klik 'N')!");
    }
    return 1;
}

// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //

stock bRob_Reset() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("bRob_Reset");
    }

    if (IsValidDynamicCP(bRob_checkpoint))
    {
        if (IsPlayerConnected(bRob_initiator))
            DestroyPlayerCP(bRob_checkpoint, bRob_initiator);
        else
            DestroyDynamicCP(bRob_checkpoint);
    }

    if (IsValidDynamicPickup(bRob_keyPickup))
        DestroyDynamicPickup(bRob_keyPickup);

    foreach (new i : Player)
    {
        bRob_killed{i} = false;
    }

    DestroyVehicle(bRob_getawayVehId[2]);
    DestroyVehicle(bRob_vehId[2]);

    bRob_faction = bRob_initiator = bRob_checkpoint = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_cooldown = gettime() + 10800; // 3h cooldown

    bRob_stage = BANK_STAGE_COOLDOWN;

    TextDrawHideForAll(tdBankRobTime);
    
    DestroyDynamicActor(bRob_actor), bRob_actor = -1;

    SetTimer("BankRobberyReset", (60+30)*60*1000, false);
    return 1;
}

forward BankRobberyReset();
public BankRobberyReset()
{
    if (DebugFunctions())
    {
        LogFunctionExec("BankRobberyReset");
    }

    bRob_actor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, 0, 100.0);
    SetDynamicActorInvulnerable(bRob_actor, true);
    ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    bRob_stage = BANK_STAGE_READY;
   
    return 1;
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
    if (bRob_stage == BANK_STAGE_ROBBERY_IN_PROGRESS || bRob_stage == BANK_STAGE_ROBBED)
        return 1;

    return 0;
}

stock GetBankCooldownTimestamp()
{
    return bRob_cooldown;
}

// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //

Dialog:SahteOdabir(playerid, response, listitem, inputtext[]) {

	if(!response) return 0;
	if(response) {
        if(bRob_prepKoji != 4) return 0;
		switch(listitem) {

	 	    case 0: {
                
                SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 1: {
                
                SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 2: {
	 	    	
				SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 3: {

				SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 4: {
	 	
				SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
	 	    case 5: {
	 	    	
				SetPlayerCompensatedPos(playerid,RandomSahte[0][0], RandomSahte[0][1], RandomSahte[0][2]);
		 	    return 1;
	 	    }
		}
	}

	return 1;
}

forward ExplodeDynamite(playerid, tick);
public ExplodeDynamite(playerid, tick) {

    dynamitetick[playerid] -= 1;

    if (dynamitetick[playerid] <= 10 && dynamitetick[playerid] >> 0) {
        ClearAnimations(playerid, 1);
        GameTextForPlayer(playerid, dynamitetick[playerid], 1000, 3);
    }
    else if (dynamitetick[playerid] <= 0) {
        UnistiKanalizaciju();
        CreateExplosion(1454.5032,-960.9556,24.0797, 12, 2.0);
        InfoMsg(playerid, "Uspjesno ste unistili prolaz za kanalizaciju.");
        KillTimer(DynamiteTimer[playerid]);
    }
    bRob_prepKoji = 4;
}


// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flag:testmode(FLAG_ADMIN_6);
CMD:testmode(playerid, params[])
{
    if(!testingdaddy) {
        testingdaddy = true;
        InfoMsg(playerid, "Aktivirao si test mode, provjere za kolicinu igraca pri pljacki banke se nece racunati.")
    }
    else {
        testingdaddy = false;
        InfoMsg(playerid, "Ugasio si test mode, provjere za kolicinu igraca pri pljacki banke ce se racunati.")
    }
    return 1;
}

flag:bankreset(FLAG_ADMIN_6);
CMD:bankreset(playerid, params[])
{
    bRob_Reset();
    BankRobberyReset();

    bRob_cooldown = 0;
    return 1;
}*/
