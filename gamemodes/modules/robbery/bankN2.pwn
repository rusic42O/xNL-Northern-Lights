#include <YSI_Coding\y_hooks>

/*
    TODO handling:

    - Kada inicijator pogine
    - Kada inicijator bude uhapsen (zavezan)
    - Kada vreme istekne

*/

enum
{
    BANK_STAGE_READY = 1,
    BANK_STAGE_GUARD_KILLED, // Ubijen cuvar, tece timer za drop kartice
    BANK_STAGE_KEY_DROPPED, // Kartica ispala, kreiran pickup
    BANK_STAGE_KEY_PICKED_UP, // Kartica pokupljena, ceka se da se unese sifra
    BANK_STAGE_KEYPASS_ENTERING, // Igrac unosi sifru
    BANK_STAGE_DOORS_UNLOCKED, // Otvorena glavna vrata za ulazak u trezor
    BANK_STAGE_ROBBERY_IN_PROGRESS, // Pljacka je u toku
    BANK_STAGE_ROBBED, // Pljacka je uspesna, ceka se na odnosenje novca u bazu
    BANK_STAGE_COOLDOWN, // Zavrsena/prekinuta pljacka
}

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define BANK_ROB_BOUNTY   (1000000)
#define BANK_ROB_BONUS    (250000) // rand max




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bRob_stage,
    bRob_cooldown,
    bRob_faction,
    bRob_keyPickup,
    bRob_checkpoint,
    bRob_time,
    bRob_initiator,
    bRob_doors[2],
    bRob_object[9],
    bRob_policeTarget, // Ne resetuje se dok igrac ne umre, bude uhapsen, izadje iz igre..
    bRob_code, // Sifra za otvaranje sigurnosnih vrata
    bRob_actor,
    bRob_keypadArea,
    bRob_input[5],
    bRob_pickupExit[3],
    bool:bRob_bombExploded,
    tmr_bRob,
    bool:bRob_killed[MAX_PLAYERS char]
;



// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    bRob_faction = bRob_keyPickup = bRob_initiator = bRob_checkpoint = bRob_keyPickup = bRob_code = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    tmr_bRob = bRob_time = bRob_cooldown = 0;
    bRob_input[0] = EOS;
    bRob_bombExploded = false;
    bRob_stage = BANK_STAGE_READY;

    bRob_actor = CreateDynamicActor(71, 1452.7336, -990.3029, 26.8490, 178.22315, 0, 100.0);
    // ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    bRob_doors[0] = CreateDynamicObject(19302, 1454.0215, -989.3419, 27.1073, 0.000000, 0.000000, 0.000000, 750.0, 750.0); 
    bRob_doors[1] = CreateDynamicObject(19302, 1455.8416, -989.3430, 27.1073, 0.000000, 0.000000, 180.000000, 750.0, 750.0); 
    bRob_keypadArea = CreateDynamicCircle(1457.6266,-990.2203, 3.0);
    // bank_area  = CreateDynamicRectangle(...); // TODO

    CreateDynamic3DTextLabel("{FF0000}[ PLJACKA BANKE ]\n{FF9900}/pljacka", BELA, 1470.8264,-978.0361,22.8931, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("Mesto za bombu", BELA, 1452.1536, -980.2452, 21.7592, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);

    // Pickupi za izlaz
    bRob_pickupExit[0] = CreateDynamicPickup(19134, 1, 1423.5593,-975.9340,16.4130);
    //bRob_pickupExit[1] = CreateDynamicPickup(19134, 1, 1419.2909,-979.0989,16.4130);
    bRob_pickupExit[2] = CreateDynamicPickup(19134, 1, 1423.4276,-983.4382,16.4130);


    // Ventilacioni otvor
    bRob_object[0] = CreateDynamicObject(914, 1450.8936, -980.2452, 21.7592, 90.000000, 0.000000, 0.000000, 750.0, 750.0); 

    return 1;
}

hook OnPlayerConnect(playerid)
{
    bRob_killed{playerid} = false;
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
    if (actorid == bRob_actor && bRob_stage == BANK_STAGE_READY && GetBankCooldownTimestamp() < gettime())
    {
        // Cuvar je upucan
     

        // Brojanje saigraca u blizini
        new saigraci = 0;
        foreach (new i : Player)
        {
            if (i == playerid) continue;
            if (PI[i][p_org_id] == PI[playerid][p_org_id] && IsPlayerNearPlayer(playerid, i, 10.0)) saigraci++;
        }
        if (saigraci < 3) return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku banke.");

        bRob_stage = BANK_STAGE_GUARD_KILLED;
        // SetTimer("BankRob_GuardDrop", 1000, false);
        BankRob_GuardDrop();
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_SPRINT) && bRob_stage >= BANK_STAGE_ROBBERY_IN_PROGRESS)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, 1423.4276,-983.4382,16.4130))
        {
            // Levo
            SetPlayerCompensatedPos(playerid, 1295.6135,-984.8702,32.6953, 96.5, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }
        else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1423.5593,-975.9340,16.4130))
        {
            // Sredina
            SetPlayerCompensatedPos(playerid, 1407.9390,-1306.5870,9.0661, 180.0, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }
        /*else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1419.2909,-979.0989,16.4130))
        {
            // Desno
            SetPlayerCompensatedPos(playerid, 2277.8188,-930.0453,27.9968, 270.0, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }*/
    }
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if (pickupid == bRob_keyPickup && bRob_stage == BANK_STAGE_KEY_DROPPED)
    {
        DestroyDynamicPickup(bRob_keyPickup), bRob_keyPickup = -1;

        bRob_code = 1000 + random(8999);
        SendClientMessageF(playerid, BELA, "* Sifra za otvaranje sigurnosnih vrata je: {FF0000}%i.", bRob_code);
        bRob_stage = BANK_STAGE_KEY_PICKED_UP;
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == bRob_keypadArea && bRob_stage == BANK_STAGE_KEY_PICKED_UP)
    {
        ptdKeypad_Create(playerid);
        ptdKeypad_Show(playerid);
        SelectTextDraw(playerid, 0xF2E4AEFF);

        bRob_input[0] = EOS;
        bRob_stage = BANK_STAGE_KEYPASS_ENTERING;
    }
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (bRob_stage == BANK_STAGE_KEYPASS_ENTERING) 
    {
        if (strlen(bRob_input) < 4) 
        {
            for__loop (new i = 0; i <= 9; i++) 
            {
                if (playertextid == PlayerTD[playerid][ptdPadNum][i]) 
                {
                    new num[2];
                    valstr(num, i);
                    strins(bRob_input, num, strlen(bRob_input));
                    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], bRob_input);
                    return ~1;
                }
            }
        }

        if (playertextid == PlayerTD[playerid][ptdKeypad][10]) 
        {
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], "");
            bRob_input[0] = EOS;
            return ~1;
        }

        if (playertextid == PlayerTD[playerid][ptdKeypad][12]) 
        {
            new enteredPin = strval(bRob_input);

            if (enteredPin != bRob_code) // Uneo pogresan kod
            {
                ErrorMsg(playerid, "Uneli ste pogresan kod!");
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], "");
                bRob_input[0] = EOS;
            }

            else // Uspesno!
            {
                InfoMsg(playerid, "Uneli ste tacan kod.");
                ptdKeypad_Destroy(playerid);
                CancelSelectTextDraw(playerid);

                MoveDynamicObject(bRob_doors[0], 1452.3030, -989.3341, 27.1073, 5.350, 0.000000, 0.000000, 0.00);
                MoveDynamicObject(bRob_doors[1], 1457.6797, -989.3345, 27.1073, 5.350, 0.000000, 0.000000, 180.00);

                bRob_stage = BANK_STAGE_DOORS_UNLOCKED;
            }
        }
        return ~1;
    }
    return 0;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == bRob_checkpoint && playerid == bRob_initiator && bRob_stage == BANK_STAGE_ROBBED)
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

        // Skill UP za sve clanove u okolini + raspodela novca
        if (IsACriminal(playerid))
        {
            new 
                fid = PI[playerid][p_org_id],
                Float:x,Float:y,Float:z,
                totalRanks = 0,
                Iterator:iAwardPlayers<MAX_PLAYERS>
            ;
            Iter_Clear(iAwardPlayers);
            GetPlayerPos(playerid, x, y, z);
            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == fid)
                {
                    if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z) && !IsPlayerAFK(i))
                    {
                        totalRanks += PI[i][p_org_rank];
                        Iter_Add(iAwardPlayers, i);

                        if (i == playerid)
                            PlayerUpdateCriminalSkill(i, 5, SKILL_ROBBERY_BANK, 0);
                        else
                            PlayerUpdateCriminalSkill(i, 2, SKILL_ROBBERY_BANK, 1);
                    }
                }
            }

            format(sLog, sizeof sLog, "BANKA | Raspodela novca (rank suma = %i, igraca = %i)", totalRanks, Iter_Count(iAwardPlayers));
            Log_Write(LOG_ROBBERY, sLog);

            foreach (new p : iAwardPlayers)
            {
                new cash = floatround(bounty/totalRanks * PI[p][p_org_rank]);
                PlayerMoneyAdd(p, cash);
                SendClientMessageF(p, BELA, "* Vi ste rank %i. Zaradili ste {00FF00}%s {FFFFFF}od pljacke banke.", PI[p][p_org_rank], formatMoneyString(cash));

                format(sLog, sizeof sLog, "BANKA | %s | %s | Rank %i", ime_obicno[p], formatMoneyString(cash), PI[p][p_org_rank]);
                Log_Write(LOG_ROBBERY, sLog);
            }
        }


        {
            // Oduzimanje novca svim igracima koji su izasli sa servera u prethodnih 20 minuta
            new sQuery[125];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = banka * 0.95 WHERE banka > 0 AND org_id != %i AND poslednja_aktivnost > NOW() - INTERVAL 20 MINUTE", PI[playerid][p_org_id]);
            mysql_tquery(SQL, sQuery);
        }


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

                // Skill UP za policajca i njegove pomocnike + nagrade za banku/zlataru
                new Float:x,Float:y,Float:z,
                    totalRanks = 0,
                    Iterator:iAwardPlayers<MAX_PLAYERS>;
                Iter_Clear(iAwardPlayers);
                GetPlayerPos(killerid, x, y, z);
                foreach (new i : Player)
                {
                    if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                    {
                        if (bounty > 0)
                        {
                            totalRanks += PI[i][p_org_rank];
                            Iter_Add(iAwardPlayers, i);
                        }
                        PlayerUpdateCopSkill(i, skill, SKILL_ARREST, (i==killerid)? 0 : 1);
                    }
                }

                if (bounty > 0)
                {    
                    new sLog[75];
                    format(sLog, sizeof sLog, "- Raspodela novca (rank suma = %i, igraca = %i)", totalRanks, Iter_Count(iAwardPlayers));
                    Log_Write(LOG_ROBBERY, sLog);

                    foreach (new p : iAwardPlayers)
                    {
                        new cash = floatround(bounty/totalRanks * PI[p][p_org_rank]);
                        PlayerMoneyAdd(p, cash);
                        SendClientMessageF(p, BELA, "* Vi ste rank %i. Zaradili ste {00FF00}%s {FFFFFF}zbog sprecavanja pljacke.", PI[p][p_org_rank], formatMoneyString(cash));

                        format(sLog, sizeof sLog, "--- %s | %s | Rank %i", ime_obicno[p], formatMoneyString(cash), PI[p][p_org_rank]);
                        Log_Write(LOG_ROBBERY, sLog);
                    }
                }
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
    // ApplyDynamicActorAnimation(bRob_actor, "PED", "KO_shot_stom", 4.1, 0, 1, 1, 1, 1); 
    ApplyDynamicActorAnimation(bRob_actor, "PED","KO_skid_front", 4.1, 0, 1, 1, 1, 1); 
    bRob_keyPickup = CreateDynamicPickup(19792, 1, 1453.8799, -990.9221, 25.8790); // TODO: interior/virtualworld ?
    bRob_stage = BANK_STAGE_KEY_DROPPED;

    SetTimer("BankRob_CheckStart", 300000, false);

    foreach (new i : Player)
    {
        if (IsPlayerInRangeOfPoint(i, 50.0, 1453.8799, -990.9221, 25.8790))
        {
            Streamer_Update(i, STREAMER_TYPE_PICKUP);
            DebugMsg(i, "BankRob_GuardDrop");
        }
    }
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
    format(str, sizeof str, "VREME:   %s", konvertuj_vreme(bRob_time));
    TextDrawSetString(tdBankRobTime, str);

    if (!IsPlayerConnected(bRob_initiator) || bRob_stage != BANK_STAGE_ROBBERY_IN_PROGRESS)
    {
        // Upisivanje u log
        Log_Write(LOG_ROBBERY, "BANKA-FAIL | Nepoznata faza ili inicijator nije konektovan");

        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
        return 1;
    }


    if (bRob_time == -1)
    {
        KillTimer(tmr_bRob), tmr_bRob = 0;
        TextDrawHideForAll(tdBankRobTime);

        if (bRob_stage == BANK_STAGE_ROBBERY_IN_PROGRESS)
        {
            bRob_stage = BANK_STAGE_ROBBED;
            SetPlayerAttachedObject(bRob_initiator, SLOT_BACKPACK, 11745, 1, 0.007999, -0.152000, 0.000000, 85.900054, 164.200180, -100.400016);

            new Float:x,Float:y,Float:z;
            GetPlayerPos(bRob_initiator, x, y, z);

            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == bRob_faction)
                {
                    if (i == bRob_initiator)
                    {
                        SendClientMessage(i, CRVENA, "Pljacka je uspesna! {FF9900}Odnesite vrecu sa novcem u bazu!");
                        bRob_checkpoint = CreatePlayerCP(FACTIONS[bRob_faction][f_x_spawn], FACTIONS[bRob_faction][f_y_spawn], FACTIONS[bRob_faction][f_z_spawn], 7.0, 0, 0, i, 6000.0);

                        ClearAnimations(i, 1);
                        SetCameraBehindPlayer(i);

                        PlayerUpdateCriminalSkill(i, 7, SKILL_ROBBERY_BANK, 0);
                    }
                    else
                    {
                        SendClientMessageF(i, CRVENA, "Pljacka je uspesna! {FF9900}Pomozite {FFFFFF}%s {FF9900}da bezbedno dodje do baze i ostavi ukradeni novac.", ime_rp[bRob_initiator]);

                        if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
                        {
                            PlayerUpdateCriminalSkill(i, 3, SKILL_ROBBERY_BANK, 1);
                        }
                    }
                }
            }

            // Upisivanje u log
            Log_Write(LOG_ROBBERY, "BANKA-TORBA");
        }
    }
    else
    {
        if (!IsPlayerInRangeOfPoint(bRob_initiator, 8.0, 1470.8264,-978.0361,22.8931))
        {
            FactionMsg(bRob_faction, "{FF0000}Pljacka banke je propala jer se %s udaljio od mesta pljacke.", ime_rp[bRob_initiator]);

            // Upisivanje u log
            new logStr[68];
            format(logStr, sizeof logStr, "BANKA-FAIL | %s se udaljio od mesta pljacke", ime_obicno[bRob_initiator]);
            Log_Write(LOG_ROBBERY, logStr);

            bRob_Reset();
            bRob_policeTarget = INVALID_PLAYER_ID;
        }
    }
    return 1;
}

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

    bRob_faction = bRob_keyPickup = bRob_initiator = bRob_checkpoint = bRob_keyPickup = bRob_code = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_input[0] = EOS;
    bRob_cooldown = gettime() + 10800; // 3h cooldown
    bRob_stage = BANK_STAGE_COOLDOWN;
    TextDrawHideForAll(tdBankRobTime);
    
    KillTimer(tmr_bRob), tmr_bRob = 0;
    DestroyDynamicActor(bRob_actor), bRob_actor = -1;

    SetTimer("BankRobberyReset", (60+30)*60*1000, false);
    // SetTimer("BankRobberyReset", 10*1000, false);
    return 1;
}

forward BankRobberyReset();
public BankRobberyReset()
{
    if (DebugFunctions())
    {
        LogFunctionExec("BankRobberyReset");
    }

    bRob_actor = CreateDynamicActor(71, 1452.7336, -990.3029, 26.8490, 178.22315, 0, 100.0);
    ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
    
    // zatvaranje jos jednom za svaki slucaj
    MoveDynamicObject(bRob_doors[0], 1454.0215, -989.3419, 27.1073, 5.350, 0.000000, 0.000000, 0.000000);
    MoveDynamicObject(bRob_doors[1], 1455.8416, -989.3430, 27.1073, 5.350, 0.000000, 0.000000, 180.000000);

    // Vracanje unistenih/pomerenih objekata u prvobitno stanje
    if (bRob_bombExploded)
    {
        // Ventilacioni otvor
        DestroyDynamicObject(bRob_object[0]);
        bRob_object[0] = CreateDynamicObject(914, 1450.8936, -980.2452, 21.7592, 90.000000, 0.000000, 0.000000, 750.0, 750.0); 

    }

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
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pljackajbanku(playerid, const params[]) 
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1470.8264,-978.0361,22.8931))
        return ErrorMsg(playerid, "Niste na mestu za pljackanje banke.");

    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da pljackaju banku.");

    if (GetPlayerWeapon(playerid) <= 0)
        return ErrorMsg(playerid, "Morate drzati oruzje u ruci da biste pokrenuli pljacku.");

    if (bRob_stage < BANK_STAGE_DOORS_UNLOCKED)
        return ErrorMsg(playerid, "Niste usli na regularan nacin u trezor. Morate ubiti strazara i otkljucati vrata pomocu kartice.");

    if (bRob_stage == BANK_STAGE_ROBBERY_IN_PROGRESS)
        return ErrorMsg(playerid, "Pljacka banke je vec u toku.");

    /*new h, m;
    gettime(h, m);
    if (h > 0 && h < 10)
        return ErrorMsg(playerid, "Ne mozete pljackati banku izmedju 01h i 10h.");*/

    if (bRob_cooldown > gettime() || bRob_stage > BANK_STAGE_ROBBERY_IN_PROGRESS) 
    {
        new string[87];
        format(string, sizeof string, "Banka je nedavno vec opljackana! Pokusajte ponovo za {FFFFFF}%s.", konvertuj_vreme(bRob_cooldown - gettime(), true));
        RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
        return 1;
    }

    // Provera da li ima barem 4 saigraca + barem 4 policajaca
    new mb_igraci = 0, pd_igraci = 0;
    foreach (new i : Player)
    {
        if (IsACop(i)) pd_igraci++;
        if (PI[i][p_org_id] == PI[playerid][p_org_id]) mb_igraci++;
    }
    if (pd_igraci < 4)
        return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 4).");
    if (mb_igraci < 4)
        return ErrorMsg(playerid, "Nema dovoljno tvojih saigraca (minimum 4).");

    bRob_faction = PI[playerid][p_org_id];
    bRob_initiator = playerid;
    bRob_policeTarget = playerid;
    bRob_time = 600; // 600
    bRob_stage = BANK_STAGE_ROBBERY_IN_PROGRESS;
    TextDrawSetString(tdBankRobTime, "BANKA:      10:00");

    foreach (new i : Player)
    {
        if (PI[i][p_org_id] == bRob_faction || IsACop(i))
            TextDrawShowForPlayer(i, tdBankRobTime);
    }
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
    tmr_bRob = SetTimer("BankRobbery", 1*1000, true); // ukupno 600 sekundi

    AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Pljacka banke", "Snimak sa nadzorne kamere");

    new Float:xM, Float:yM, Float:zM;

    GetPlayerPos(playerid, xM, yM, zM);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 30.0, xM, yM, zM) && PI[i][p_org_id] == PI[playerid][p_org_id])
        {
            if(i != playerid){
                AddPlayerCrime(i, INVALID_PLAYER_ID, 3, "Pljacka banke(Saucesnik)", "Snimak sa nadzorne kamere");
            }
        }
    }

    // Slanje poruke policiji i obavestenje za sve igrace
    SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
    SendClientMessageFToAll(BELA, "Vesti | {FF6347}U toku je pljacka banke od strane neidentifikovane kriminalne grupe!");
    SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom delu grada!");
    SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

    DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}pljacka banke u toku!");

    // Upisivanje u log
    new logStr[57];
    format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pd_igraci, mb_igraci);
    Log_Write(LOG_ROBBERY, logStr);
    return 1;
}

CMD:bankstage(playerid, const params[])
{
    DebugMsg(playerid, "bRob_stage = %i", bRob_stage);
    return 1;
}