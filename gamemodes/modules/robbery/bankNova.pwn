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
    bool:bRob_killed[MAX_PLAYERS char],
    bRob_prepPokrenut,
    bRob_prepStage,
    //bRob_prepUniforma,
    //bRob_prepVozilo,
    //bRob_prepGetawayVehicle,
    //bRob_SecVrataRazbijena,
    bRob_prepKoji,
    bRob_uniformeId[2],
    bRob_getawayVehId[4],
    bRob_vehId[4],
    bool:bRob_imaPrep[MAX_PLAYERS],
    bRob_uniformaArea[2], // 0 - Uniforma mali Kradja, 1 - Uadlji se od mjesta
    bRob_hakerKoji,
    bRob_izaBankeArea,
    robSkinAdd,
    bRob_prepPokrenuo[MAX_PLAYER_NAME]
;

/*
Rob_uniformeId = [1] - ID Igraca | [2] - Stage na kojem je igrac (1 - Dodijeljen, 2 - Ukradeno , 3 - Izasao iz range pointa, 4 - Dostavljeno u bazu)
Rob_getawayVehId = [1] - ID Igraca | [2] - Stage (1 - Dodijeljen, 2 - U vozilu, 3 - Dostavio u bazu vozilo ) | [3] - ID Vozila za provjeru | [4] - ID Igraca koji vozi vozilo za bjeg)
Rob_vehId = [1] - ID Igraca | [2] - Stage (1 - Dodijeljen, 2 - U vozilu, 3 - Dostavio u bazu vozilo) | [3] - ID Vozila za provjeru | [4] - ID Igraca koji vozi cistaca)


*/

enum bandeVozila 
{
    bKojeV,
    bBandaID,
    Float:bVSpawnX,
    Float:bVSpawnY,
    Float:bVSpawnZ,
    Float:bVSpawnA
}

new bandeVozilaSpawn[][bandeVozila] = 
{ // Broj vozila - ID Orge - Kordinate
    {1, 1, 1245.8938,-2042.8788,59.5343,273.0446}, // LCN 1
    {2, 1, 1246.1133,-2031.1176,59.5281,269.8424}, // LCN 2
    {1, 2, 1241.3060,-776.5391,90.8385,358.7416}, // SB 1
    {2, 2, 1241.1390,-784.3247,90.1025,358.7621}, // SB 2
    {1, 3, 2441.1113,-1665.7493,13.2002,90.3525}, // GSF 1
    {2, 3, 2449.8882,-1665.6953,13.1789,90.3457}, // GSF 2
    {1, 4, 1055.0555,-1423.7518,13.2734,0.6569}, // IM 1
    {2, 4, 1070.1111,-1427.6689,13.3634,358.9684}, // IM 2
    {1, 5, 947.4252,-630.6428,118.8791,206.688}, // IM 1
    {2, 5, 943.3843,-622.6059,116.8009,206.6918} // IM 2
};


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
    bRob_uniformeId[0] = -1, bRob_uniformeId[1] = 0;
    bRob_getawayVehId[0] = -1, bRob_getawayVehId[1] = 0, bRob_getawayVehId[2] = 0;
    bRob_vehId[0] = -1, bRob_vehId[1] = 0, bRob_vehId[2] = 0;
    bRob_getawayVehId[3] = -1, bRob_vehId[3] = -1, bRob_prepStage = -1, robSkinAdd = 0;

    bRob_actor = CreateDynamicActor(71, 1452.7336, -990.3029, 26.8490, 178.22315, 0, 100.0);
    // ApplyDynamicActorAnimation(bRob_actor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    bRob_doors[0] = CreateDynamicObject(19302, 1454.0215, -989.3419, 27.1073, 0.000000, 0.000000, 0.000000, 750.0, 750.0); 
    bRob_doors[1] = CreateDynamicObject(19302, 1455.8416, -989.3430, 27.1073, 0.000000, 0.000000, 180.000000, 750.0, 750.0); 

    bRob_keypadArea = CreateDynamicCircle(1457.6266,-990.2203, 3.0);
    bRob_uniformaArea[0] = CreateDynamicCircle(1629.6100, -1844.5880, 3.0);
    bRob_uniformaArea[1] = CreateDynamicCircle(1629.6100, -1844.5880, 150.0);

    bRob_izaBankeArea = CreateDynamicCircle(1450.0341,-975.3313, 30.0);
    // bank_area  = CreateDynamicRectangle(...); // TODO

    CreateDynamic3DTextLabel("{FF0000}[ PLJACKA BANKE ]\n{FF9900}/pljacka", BELA, 1470.8264,-978.0361,22.8931, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("Mesto za bombu", BELA, 1105.4530,2657.2278,-60.0098, 7.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);

    // Pickupi za izlaz
    /*bRob_pickupExit[0] = CreateDynamicPickup(19134, 1, 1176.2434,2641.0212,-65.9860, 1, 1);
    bRob_pickupExit[1] = CreateDynamicPickup(19134, 1, 1189.8752,2679.3220,-64.8477, 1, 1);
    bRob_pickupExit[2] = CreateDynamicPickup(19134, 1, 1176.1633,2641.0974,-65.9860, 1, 1);*/
    
    // Pickups za ulaz izlaz pozada
    CreateDynamicPickup(1318, 1, 1450.0341,-975.3313,22.8262);
    CreateDynamicPickup(1318, 1, 1426.8859,-964.5129,37.0462);

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
    bRob_imaPrep[playerid] = false;

    /*if(ime_rp[playerid] == bRob_prepPokrenuo)
    {
        KillTimer(TimerBankaResetDisc);
    }*/
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
        new saigraci = 0;
        foreach (new i : Player)
        {
            if (i == playerid) continue;
            if (PI[i][p_org_id] == PI[playerid][p_org_id] && IsPlayerNearPlayer(playerid, i, 10.0)) saigraci++;
        }
        //if (saigraci < 3) return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku banke."); ovdje

        bRob_stage = BANK_STAGE_GUARD_KILLED;
        SetTimer("BankRob_GuardDrop", 1000, false);
        bRob_prepPokrenut = PI[playerid][p_org_id];
        bRob_prepPokrenuo = ime_rp[playerid];
        bRob_prepKoji = 2;

        BankRob_GuardDrop();
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_SPRINT) && bRob_stage >= BANK_STAGE_ROBBERY_IN_PROGRESS)
    {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, 1423.5593,-975.9340,16.4130))
        {
            // Levo
            SetPlayerCompensatedPos(playerid, 1295.6135,-984.8702,32.6953, 96.5, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }
        /*else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1189.8752,2679.3220,-64.8477))
        {
            // Sredina
            SetPlayerCompensatedPos(playerid, 1407.9390,-1306.5870,9.0661, 180.0, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }*/
        else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1423.4276,-983.4382,16.4130))
        {
            // Desno
            SetPlayerCompensatedPos(playerid, 2277.8188,-930.0453,27.9968, 270.0, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }
    }

    if((newkeys & KEY_SPRINT) && PI[playerid][p_org_id] == bRob_prepPokrenut && GetPlayerSkin(playerid) == 8)
    {
        if(IsPlayerInRangeOfPoint(playerid, 4.0, 1426.8859, -964.5129, 37.0461))
        {
            SetPlayerCompensatedPos(playerid, 1450.0341,-975.3313,22.8262, 180.00, 0, 0, 5000);
            GameTextForPlayer(playerid, "Los Santos", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }

        if(IsPlayerInRangeOfPoint(playerid, 4.0, 1450.0341,-975.3313,22.8262))
        {
            SetPlayerCompensatedPos(playerid, 1426.8859, -964.5129, 37.0461, 180.00, 0, 0, 5000);
            GameTextForPlayer(playerid, "Banka", 5000, 1);

            gInteriorReload[playerid] = GetTickCount() + 750;
            return ~1;
        }
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

    if(areaid == bRob_izaBankeArea && bRob_getawayVehId[3] == playerid)
    {
        InfoMsg(playerid, "Dosli ste na odrediste. Vas tim moze da napusti vozilo.");
    }

    if(areaid == bRob_uniformaArea[0] && bRob_uniformeId[0] == playerid)
    {
        InfoMsg(playerid, "Dosli ste na mjesto za kradju uniformi. Kucajte /ukradiuniforme da pocnete kradju.");
    }

    if(GetFactionAreaID(GetPlayerFactionID(playerid)) == areaid && bRob_uniformeId[0] == playerid && bRob_uniformeId[1] == 3)
    {
        bRob_uniformeId[1] = 4;
        InfoMsg(playerid, "Uspjesno ste dostavili uniforme u bazu.");
        FactionMsg(bRob_prepPokrenut, "{FF0000}Igrac %s je uspjesno dostavio uniforme za pljacku u bazu.", ime_rp[playerid]);
        bRob_imaPrep[playerid] = false;
        PlayerMoneyAdd(playerid, 10000);
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
    }

    if(GetFactionAreaID(GetPlayerFactionID(playerid)) == areaid && bRob_getawayVehId[0] == playerid && bRob_getawayVehId[1] == 2)
    {
        new robVid;
        robVid = GetPlayerVehicleID(playerid);
            
        if(bRob_getawayVehId[2] == robVid)
        {
            bRob_getawayVehId[1] = 3;
            InfoMsg(playerid, "Uspjesno ste dostavili vozilo za bjegstvo u bazu.");
            PlayerMoneyAdd(playerid, 10000);
            FactionMsg(bRob_prepPokrenut, "{FF0000}Igrac %s je uspjesno dostavio vozilo za bjegstvo u bazu.", ime_rp[playerid]);
            bRob_imaPrep[playerid] = false;
            DestroyVehicle(robVid);
        }
    }

    if(GetFactionAreaID(GetPlayerFactionID(playerid)) == areaid && bRob_vehId[0] == playerid && bRob_vehId[1] == 2)
    {
        new robVid;
        robVid = GetPlayerVehicleID(playerid);
            
        if(bRob_vehId[2] == robVid)
        {
            bRob_vehId[1] = 3;
            InfoMsg(playerid, "Uspjesno ste dostavili vozilo cistaca u bazu.");
            PlayerMoneyAdd(playerid, 10000);
            FactionMsg(bRob_prepPokrenut, "{FF0000}Igrac %s je uspjesno dostavio vozilo cistaca u bazu.", ime_rp[playerid]);
            bRob_imaPrep[playerid] = false;
            DestroyVehicle(robVid);
        }
    }


    /*if(GetFactionAreaID(GetPlayerFactionID(playerid) == areaid)) 
    {
        if(bRob_uniformeId[0] == playerid && bRob_uniformeId[1] == 3)
        {
            bRob_uniformeId[1] = 4;
            InfoMsg(playerid, "Uspjesno ste dostavili uniforme u bazu.");
            FactionMsg(bRob_faction, "{FF0000}Igrac %s je uspjesno dostavio uniforme za pljacku u bazu.", ime_rp[playerid]);
            bRob_imaPrep[playerid] = false;
        }
        else if(bRob_getawayVehId[0] == playerid && bRob_getawayVehId[1] == 2)
        {
            new robVid;
            robVid = GetPlayerVehicleID(playerid);
            
            if(bRob_getawayVehId[2] == robVid)
            {
                bRob_getawayVehId[1] = 3;
                InfoMsg(playerid, "Uspjesno ste dostavili vozilo za bjegstvo u bazu.");
                FactionMsg(bRob_faction, "{FF0000}Igrac %s je uspjesno dostavio vozilo za bjegstvo u bazu.", ime_rp[playerid]);
                bRob_imaPrep[playerid] = false;
            }
        }
        else if(bRob_vehId[0] == playerid && bRob_vehId[1] == 2)
        {
            new robVid;
            robVid = GetPlayerVehicleID(playerid);
            
            if(bRob_vehId[2] == robVid)
            {
                bRob_vehId[1] = 3;
                InfoMsg(playerid, "Uspjesno ste dostavili vozilo cistaca u bazu.");
                FactionMsg(bRob_faction, "{FF0000}Igrac %s je uspjesno dostavio vozilo cistaca u bazu.", ime_rp[playerid]);
                bRob_imaPrep[playerid] = false;
            }
        }  
    } */
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if(areaid == bRob_uniformaArea[1] && bRob_uniformeId[0] == playerid && bRob_uniformeId[1] == 2) 
    {
        InfoMsg(playerid, "Uspjeli ste pobjegnete s uniformama. Odvezite ih do baze.");
        bRob_uniformeId[1] = 3;
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
        
        DestroyVehicle(bRob_getawayVehId[2]);
        DestroyVehicle(bRob_vehId[2]);

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

                bRob_prepPokrenut = 0;
                bRob_prepPokrenuo = "Niko";

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

        bRob_prepPokrenut = 0;

        // Upisivanje u log
        new logStr[60];
        format(logStr, sizeof logStr, "BANKA-FAIL | %s je napustio server", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        bRob_Reset();
        bRob_policeTarget = INVALID_PLAYER_ID;
    }

    /*if(ime_rp[playerid] == bRob_prepPokrenuo)
    {
        SetTimer("TimerBankaResetDisc", 5 * 60 * 1000, false);
    }*/

    if(bRob_vehId[0] == playerid) bRob_vehId[0] = -1;
    if(bRob_getawayVehId[0] == playerid) bRob_getawayVehId[0] = -1;
    if(bRob_uniformeId[0] == playerid) bRob_uniformeId[0] = -1;

    if (bRob_policeTarget == playerid)
    {
        bRob_policeTarget = INVALID_PLAYER_ID;
    }
}

/*forward TimerBankaResetDisc();
public TimerBankaResetDisc()
{
    bRob_Reset();
    BankRobberyReset();

    bRob_cooldown = 0;

    return 1;
}*/

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

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(bRob_getawayVehId[0] == playerid && bRob_getawayVehId[1] == 1 && vehicleid == bRob_getawayVehId[2] && ispassenger == 0)
    {
        InfoMsg(playerid, "Uspjesno ste pronasli vozilo za bjegstvo.Odvezite vozilo do baze.");
        bRob_getawayVehId[1] = 2;
        DisablePlayerCheckpoint_H(playerid);
    }
    if(bRob_vehId[0] == playerid && bRob_vehId[1] == 1 && vehicleid == bRob_vehId[2] && ispassenger == 0)
    {
        InfoMsg(playerid, "Uspjesno ste pronasli vozilo za pljacku.Odvezite ga do baze.");
        bRob_vehId[1] = 2;
        DisablePlayerCheckpoint_H(playerid);
    }

    if(bRob_prepStage == 5) 
    {
        if(vehicleid == bRob_vehId[2] && GetPlayerSkin(playerid) != 8 && robSkinAdd < 5)
        {
            InfoMsg(playerid, "Ulazite u vozilo za pljacku i presvalcite su u uniformu.");
            SetPlayerSkin(playerid, 8);
            robSkinAdd++;
        }
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
    bRob_keyPickup = CreateDynamicPickup(19792, 1, 1453.8799, -990.9221, 25.8790, 0, 0); // TODO: interior/virtualworld ?
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

forward UniformaUnfreeze(playerid);
public UniformaUnfreeze(playerid)
{
    ClearAnimations(playerid, 1);
    InfoMsg(playerid, "Uspjesno ste uzeli uniforme. Sjedite u vozilo i udaljite se od lokacije nazad do svoje baze.");
    TogglePlayerControllable_H(playerid, true);
    bRob_uniformeId[1] = 2;
    SetPlayerAttachedObject(playerid, SLOT_BACKPACK, 11745, 1, 0.007999, -0.152000, 0.000000, 85.900054, 164.200180, -100.400016);
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

                        //bRob_prepPokrenut = 0;

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

    bRob_faction = bRob_keyPickup = bRob_initiator = bRob_checkpoint = bRob_keyPickup = bRob_code = -1;
    bRob_policeTarget = INVALID_PLAYER_ID;
    bRob_time = bRob_cooldown = 0;
    bRob_input[0] = EOS;
    bRob_cooldown = gettime() + 10800; // 3h cooldown

    bRob_stage = BANK_STAGE_COOLDOWN;

    bRob_uniformeId[0] = -1, bRob_uniformeId[1] = 0;
    bRob_getawayVehId[0] = -1, bRob_getawayVehId[1] = 0, bRob_getawayVehId[2] = 0;
    bRob_vehId[0] = -1, bRob_vehId[1] = 0, bRob_vehId[2] = 0;
    bRob_getawayVehId[3] = -1, bRob_vehId[3] = -1, bRob_prepStage = -1, robSkinAdd = 0;
    bRob_hakerKoji = 0, robSkinAdd = 0;
    bRob_prepPokrenut = 0;

    foreach(new i : Player)
    {
        if(bRob_imaPrep[i] == true)
        {
            bRob_imaPrep[i] = false;
        }
    }
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

    bRob_uniformeId[0] = -1, bRob_uniformeId[1] = 0;
    bRob_getawayVehId[0] = -1, bRob_getawayVehId[1] = 0, bRob_getawayVehId[2] = 0, bRob_getawayVehId[3] = -1;
    bRob_vehId[0] = -1, bRob_vehId[1] = 0, bRob_vehId[2] = 0, bRob_vehId[3] = -1;
    bRob_prepStage = -1;

    bRob_uniformeId[0] = -1, bRob_uniformeId[1] = 0;
    bRob_getawayVehId[0] = -1, bRob_getawayVehId[1] = 0, bRob_getawayVehId[2] = 0;
    bRob_vehId[0] = -1, bRob_vehId[1] = 0, bRob_vehId[2] = 0;
    bRob_getawayVehId[3] = -1, bRob_vehId[3] = -1, bRob_prepStage = -1, robSkinAdd = 0;
    bRob_hakerKoji = 0, robSkinAdd = 0;

    foreach(new i : Player)
    {
        if(bRob_imaPrep[i] == true)
        {
            bRob_imaPrep[i] = false;
        }
    }

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

forward bRobHakerOdrada();
public bRobHakerOdrada()
{
    foreach (new i : Player)
    {
        if (IsACop(i)) TextDrawShowForPlayer(i, tdBankRobTime);
    }

    new Float:xM, Float:yM, Float:zM;

    GetPlayerPos(bRob_initiator, xM, yM, zM);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 30.0, xM, yM, zM) && PI[i][p_org_id] == PI[bRob_initiator][p_org_id])
        {
            if(i != bRob_initiator){
                AddPlayerCrime(i, INVALID_PLAYER_ID, 3, "Pljacka banke(Saucesnik)", "Snimak sa nadzorne kamere");
            }
        }
    }

    AddPlayerCrime(bRob_initiator, INVALID_PLAYER_ID, 6, "Pljacka banke", "Snimak sa nadzorne kamere");

    // Slanje poruke policiji i obavestenje za sve igrace
    SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
    SendClientMessageFToAll(BELA, "Vesti | {FF6347}U toku je pljacka banke od strane neidentifikovane kriminalne grupe!");
    SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje gradjane da ne prilaze ovom delu grada!");
    SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

    DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}pljacka banke u toku!");

    return 1;
}

// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //

Dialog:bankUloga1(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

    new targetid = GetPVarInt(playerid, "lDodijeliUloguID");

    if(PI[playerid][p_org_id] != bRob_prepPokrenut) return ErrorMsg(playerid, "Tvoja banda nije pokrenula prep!");

    switch(listitem)
    {
        case 0: 
        {
            if(bRob_vehId[3] == targetid) return ErrorMsg(playerid, "Vec ste dodijelili ulogu ovom igracu.");
            if(bRob_getawayVehId[3] != -1) return ErrorMsg(playerid, "Vec ste postavili ulogu nekom.");
            
            printf("1GVHID: %d %d %d", bRob_getawayVehId[3], targetid, bRob_vehId[3]);
            bRob_getawayVehId[3] = targetid;
            printf("1GVHID: %d %d %d", bRob_getawayVehId[3], targetid, bRob_vehId[3]);

            InfoMsg(targetid, "Dobili ste zaduzenje da upravljate vozilom za bijeg u toku naredne pljacke.");
            FactionMsg(bRob_prepPokrenut, "%s je dobio zaduzenje da upravlja vozilom za bijeg u toku naredne pljacke.", ime_rp[targetid]);
    
        }
        case 1:
        {
            if(bRob_getawayVehId[3] == targetid) return ErrorMsg(playerid, "Vec ste dodijelili ulogu ovom igracu.");
            if(bRob_vehId[3] != -1) return ErrorMsg(playerid, "Vec ste postavili ulogu nekom.");
            
            printf("1CVHID: %d %d %d", bRob_getawayVehId[3], targetid, bRob_vehId[3]);
            bRob_vehId[3] = targetid;
            printf("1CVHID: %d %d %d", bRob_getawayVehId[3], targetid, bRob_vehId[3]);

            InfoMsg(targetid, "Dobili ste zaduzenje da upravljate vozilom cistaca u toku naredne pljacke.");
            FactionMsg(bRob_prepPokrenut, "%s je dobio zaduzenje da upravlja vozilom cistaca u toku naredne pljacke.", ime_rp[targetid]);
        }
    }

    return 1;
}

Dialog:bankPrep1(playerid, response, listitem, const inputtext[])
{

    if (!response)
        return 1;

    new targetid = GetPVarInt(playerid, "lDodijeliPrepID");

    if(PI[playerid][p_org_id] != bRob_prepPokrenut) return ErrorMsg(playerid, "Tvoja banda nije pokrenula prep!");
    
    switch(listitem)
    {
        case 0:
        {   
            if(bRob_uniformeId[0] == -1 && bRob_imaPrep[targetid] == false && bRob_uniformeId[1] == 0){
                InfoMsg(playerid, "Postavili ste igracu %s prep za nabavku uniformi", ime_rp[targetid]);
                InfoMsg(targetid, "Lider %s vam je postavio prep za nabavku uniformi, kad budete spremni korisite /startprep da ga pokrenete.", ime_rp[playerid]);
                bRob_uniformeId[0] = targetid;
                bRob_uniformeId[1] = 1;
                bRob_imaPrep[targetid] = true;
            } else {
                ErrorMsg(playerid, "Vec ste dali ovaj prep nekom igracu, igrac ima dodijeljen prep ili je prep odradjen.");
            }
            
        }
        case 1:
        {
            if(bRob_getawayVehId[0] == -1 && bRob_imaPrep[targetid] == false && bRob_getawayVehId[1] == 0){
                InfoMsg(playerid, "Postavili ste igracu %s prep za nabavku vozila za bjeg", ime_rp[targetid]);
                InfoMsg(targetid, "Lider %s vam je postavio prep za nabavku vozila za bjeg, kad budete spremni korisite /startprep da ga pokrenete.", ime_rp[playerid]);
                bRob_getawayVehId[0] = targetid;
                bRob_getawayVehId[1] = 1;
                bRob_imaPrep[targetid] = true;
            } else {
                ErrorMsg(playerid, "Vec ste dali ovaj prep nekom igrac ili igrac ima dodijeljen prep.");
            }
        }
        case 2:
        {
            if(bRob_vehId[0] == -1 && bRob_imaPrep[targetid] == false && bRob_vehId[1] == 0){
                InfoMsg(playerid, "Postavili ste igracu %s prep za nabavku vozila cistaca", ime_rp[targetid]);
                InfoMsg(targetid, "Lider %s vam je postavio prep za nabavku vozila cistaca, kad budete spremni korisite /startprep da ga pokrenete.", ime_rp[playerid]);
                bRob_vehId[0] = targetid;
                bRob_vehId[1] = 1;
                bRob_imaPrep[targetid] = true;
            } else {
                ErrorMsg(playerid, "Vec ste dali ovaj prep nekom igrac ili igrac ima dodijeljen prep.");
            }
        }
        case 3:
        {
            SPD(playerid, "bankPrepOdabirHakera", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}Odabir Hakera", "Ime\tCijena\tDodatno Vrijeme\n Anna Chapman\t20.000$\t 45 Sekundi \n Raven Alder\t80.000$\t 2 Minute \n Chuck Bartowski\t 200.000 $\t 4 Minute", "Odaberi", "Odustani");
        }
    }
    
    return 1;
}

Dialog:bankPrepOdabirHakera(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

    if(PI[playerid][p_org_id] != bRob_prepPokrenut) return ErrorMsg(playerid, "Vi niste pokrenuli prep!");
    if(bRob_hakerKoji > 0) return ErrorMsg(playerid, "Vec ste odabrali hakera.");

    switch(listitem)
    {
        case 0:
        {
            if (PI[playerid][p_novac] < 20000)
	        {
	            ErrorMsg(playerid, "Nemate toliko novca kod sebe.");
                return DialogReopen(playerid);
	        }

            PlayerMoneySub(playerid, 20000);
            bRob_hakerKoji = 1;
            InfoMsg(playerid, "Odabrali ste Anna Chapman za hakera. Platili ste joj 20.000 $ i ona ce se potruditi da se alarm ne upali 45 sekundi nakon pocetka pljacke.");
        }
        case 1:
        {
            if (PI[playerid][p_novac] < 80000)
	        {
	            ErrorMsg(playerid, "Nemate toliko novca kod sebe.");
                return DialogReopen(playerid);
	        }

            PlayerMoneySub(playerid, 80000);
            bRob_hakerKoji = 2;
            InfoMsg(playerid, "Odabrali ste Raven Alder za hakera. Platili ste joj 80.000 $ i ona ce se potruditi da se alarm ne upali 2 minute nakon pocetka pljacke.");
        }
        case 2:
        {
            if (PI[playerid][p_novac] < 200000)
	        {
	            ErrorMsg(playerid, "Nemate toliko novca kod sebe.");
                return DialogReopen(playerid);
	        }
            
            PlayerMoneySub(playerid, 200000);
            bRob_hakerKoji = 3;
            InfoMsg(playerid, "Odabrali ste Chuck Bartowski za hakera. Platili ste mu 200.000 $ i on ce se potruditi da se alarm ne upali 4 minute nakon pocetka pljacke.");
        }
    }

    return 1;
}


/*Dialog:bankPrep2(playerid, response, listitem, const inputtext[])
{
    if(PI[playerid][p_org_id] != bRob_prepPokrenut) return ErrorMsg(playerid, "Tvoja banda nije pokrenula prep!");

    switch(listitem)
    {
        case 0:
        {
            SPD(playerid, "bankaPrep2_0", DIALOG_STYLE_INPUT, "asd", "{FFFFFF}Unesite ID igraca kojem zelite dati da {FFFF00}nabavlja uniforme {FFFFFF}za pljacku banke", "Potvrd", "Izadji");
        }
        case 1:
        {
            SPD(playerid, "bankaPrep2_1", DIALOG_STYLE_INPUT, "asd", "{FFFFFF}Unesite ID igraca kojem zelite dati da {FFFF00}nabavlja vozilo za bjeg", "Potvrd", "Izadji");
        }
        case 2:
        {
            SPD(playerid, "bankaPrep2_2", DIALOG_STYLE_INPUT, "asd", "{FFFFFF}Unesite ID igraca kojem zelite dati da {FFFF00}nabavlja vozila za cistace", "Potvrd", "Izadji");
        }
    }
    
    return 1;
}*/



// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pokreniprep(playerid, const params[])
{
    if(IsPlayerConnected(playerid))
        return InfoMsg(playerid, "Sistem pljacke banke u izradi");
    new prepId, 
    //h, m, mb_igraci = 0, pd_igraci = 0, 
    string[120];

    if(!IsLeader(playerid)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da pljackaju banku.");
    if(bRob_prepPokrenut > 0) return ErrorMsg(playerid, "Netko je vec pokrenuo prep za pljacku banke.");
    
    if(bRob_cooldown > gettime() || bRob_stage > BANK_STAGE_ROBBERY_IN_PROGRESS)
    {
        format(string, sizeof string, "Banka je nedavno opljackana! Pokusajte ponovo za {FFFFFF} %s.", konvertuj_vreme(bRob_cooldown - gettime(), true));
        RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
        return 1;
    }

    if (sscanf(params, "i", prepId)) {
        Koristite(playerid, "pokreniprep [ 1 / 2 ]");
        //SendClientMessage(playerid, SVETLOPLAVA, "Prep 1 - Silent ");
        SendClientMessage(playerid, SVETLOPLAVA, "Prep 2 - All in - Kroz glavni ulaz.");
    }
    
    //gettime(h, m);
    //if(h > 0 && h < 10) return ErrorMsg(playerid, "Ne mozete pljackati banku izmedju 01h i 10h.");

    if(bRob_cooldown > gettime() || bRob_stage > BANK_STAGE_ROBBERY_IN_PROGRESS)
    {
        format(string, sizeof string, "Banka je nedavno vec opljackana! Pokusajte ponovo za {FFFFFF} %s.", konvertuj_vreme(bRob_cooldown - gettime(), true));
        RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
        return 1;
    }
 
    /*foreach(new i : Player)
    {
        if(IsACop(i)) pd_igraci++;
        if(PI[i][p_org_id] == PI[playerid][p_org_id]) mb_igraci++;
    }
    if (pd_igraci < 4)
        return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 4).");
    if (mb_igraci < 4)
        return ErrorMsg(playerid, "Nema dovoljno tvojih saigraca (minimum 4).");*/


    if(prepId == 1) {
        bRob_prepPokrenut = PI[playerid][p_org_id];
        bRob_prepPokrenuo = ime_rp[playerid];
        FactionMsg(bRob_prepPokrenut, "{FF0000}%s je pokrenuo prep(Silent Type) za banku", ime_rp[playerid]);
        SendClientMessage(playerid, SVETLOPLAVA, "Koristite /dodijeliprep da dodijlite prep igracu");
    } else if (prepId == 2){
        bRob_prepPokrenut = PI[playerid][p_org_id];
        bRob_prepPokrenuo = ime_rp[playerid];
        FactionMsg(bRob_prepPokrenut, "{FF0000}%s je pokrenuo prep(All in) za banku", ime_rp[playerid]);
        SendClientMessage(playerid, SVETLOPLAVA, "Koristite /dodijeliprep da dodijlite prep igracu");
    } else ErrorMsg(playerid, "Odabrali ste nepostojeci prep. Trenutno postoje samo 1 i 2.");

    bRob_prepKoji = prepId;

    return 1;
}

CMD:pokrenipljacku(playerid, const params[])
{
    if(!IsLeader(playerid)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da dodjeljuju prep.");
    if(bRob_prepPokrenut == 0) return ErrorMsg(playerid, "Prep za banku nije pokrenut. Koristite /pokreniprep.");
    if(bRob_prepPokrenut != PI[playerid][p_org_id]) return ErrorMsg(playerid, "Vi niste pokrenuli prep za banku.");

    new brojIgrace[2];

    foreach(new i : Player)
    {
        if(IsACop(i)) brojIgrace[0]++;
        if(PI[i][p_org_id] == PI[playerid][p_org_id]) brojIgrace[1]++; 
    }

    if(bRob_uniformeId[1] != 4 && bRob_getawayVehId[1] != 3 && bRob_vehId[1] != 3) return ErrorMsg(playerid, "Niste zavrsili sve prepove. Koristite /dodijeliprep.");
    if(bRob_getawayVehId[3] == -1 || bRob_vehId[3] == -1) return ErrorMsg(playerid, "Niste dodijelili uloge za pljacku. Koristite /dodijeliulogu");
   
    InfoMsg(playerid, "Pokrenuli ste pljacku banke.");

    InfoMsg(bRob_getawayVehId[3], "Sjedite u vozilo za bjegstvo i parkirajte se u blizini banke.");
    InfoMsg(bRob_vehId[3], "Sjedite u vozilo cistaca i odvezite vasu ekipu do straznjeg ulaza u banku.");

    FactionMsg(bRob_prepPokrenut, "Lider je pokrenuo pljacku banke.");

    bRob_prepStage = 5;

    for(new i = 0; i < sizeof bandeVozilaSpawn; i++) 
    {
        if(bandeVozilaSpawn[i][bKojeV] == 1 && bandeVozilaSpawn[i][bBandaID] == bRob_prepPokrenut)
        {
            bRob_getawayVehId[2] = CreateVehicle(516, bandeVozilaSpawn[i][bVSpawnX], bandeVozilaSpawn[i][bVSpawnY], bandeVozilaSpawn[i][bVSpawnZ], bandeVozilaSpawn[i][bVSpawnA], 252, 252, 1000, 0);
        }
        
        if(bandeVozilaSpawn[i][bKojeV] == 2 && bandeVozilaSpawn[i][bBandaID] == bRob_prepPokrenut)
        {
            bRob_vehId[2] = CreateVehicle(482, bandeVozilaSpawn[i][bVSpawnX], bandeVozilaSpawn[i][bVSpawnY], bandeVozilaSpawn[i][bVSpawnZ], bandeVozilaSpawn[i][bVSpawnA], 252, 252, 1000, 0);
        }
    }
    return 1;
}

CMD:dodijeliprep(playerid, const params[])
{
    if(IsPlayerConnected(playerid))
        return InfoMsg(playerid, "Sistem pljacke banke u izradi");
    new id;

    if(!IsLeader(playerid)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da dodjeljuju prep.");
    if(bRob_prepPokrenut == 0) return ErrorMsg(playerid, "Prep za banku nije pokrenut. Koristite /pokreniprep.");
    if(bRob_prepPokrenut != PI[playerid][p_org_id]) return ErrorMsg(playerid, "Vi niste pokrenuli prep za banku.");

    if(sscanf(params, "u", id)) return Koristite(playerid, "dodijeliprep [ID/Ime Igraca]");

    if(!IsPlayerConnected(id)) return ErrorMsg(playerid, GRESKA_OFFLINE);
    if(!IsPlayerLoggedIn(id)) return ErrorMsg(playerid, "Taj igrac nije ulogovan.");
    if(IsPlayerJailed(id)) return ErrorMsg(playerid, "Taj igrac je zatvoren.");
    if(IsPlayerInRace(id)) return ErrorMsg(playerid, "Igrac je na eventu!");
    if(IsPlayerInWar(id)) return ErrorMsg(playerid, "Igrac je u waru!");
    if(PI[playerid][p_org_id] != PI[id][p_org_id]) return ErrorMsg(playerid, "Igrac nije dio vase bande/mafije!");

    SetPVarInt(playerid, "lDodijeliPrepID", id);

    if(bRob_prepKoji == 1) {
        SPD(playerid, "bankPrep1", DIALOG_STYLE_LIST, "{FFFF00}PREP ZA PLJACKU BANKE(1)", "(1) Nabavka uniformi cistaca \n (2) Nabavka vozila za bjeg \n (3) Nabavka vozila za cistace \n (4) Izbor hakera", "Izaberi", "Izadji");
    } else if(bRob_prepKoji == 2)
    {
        ErrorMsg(playerid, "Za ovaj pristup ne postoje prepovi.");
    }/*else if(bRob_prepKoji == 2) {
        SPD(playerid, "bankPrep2", DIALOG_STYLE_LIST, "{FFFF00}PREP ZA PLJACKU BANKE(2)", "(1) Nabavka vozila za bjeg \n (2)  \n (3)", "Izaberi", "Izadji");
    }*/
    return 1;
}

CMD:dodijeliulogu(playerid, const params[])
{
    new id;

    if(!IsLeader(playerid)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da dodjeluju prep.");
    if(bRob_prepPokrenut == 0) return ErrorMsg(playerid, "Prep za banku nije pokrenut. Koristite /pokreniprep.");
    if(bRob_prepPokrenut != PI[playerid][p_org_id]) return ErrorMsg(playerid, "Vi niste pokrenuli prep za banku.");

    if(bRob_uniformeId[1] != 4 && bRob_getawayVehId[2] != 3 && bRob_vehId[2] != 3) return ErrorMsg(playerid, "Niste zavrsili sve prepove. Koristite /dodijeliprep.");

    if(sscanf(params, "u", id)) return Koristite(playerid, "dodijeliulogu [ID/Ime Igraca]");

    if(!IsPlayerConnected(id)) return ErrorMsg(playerid, GRESKA_OFFLINE);
    if(!IsPlayerLoggedIn(id)) return ErrorMsg(playerid, "Taj igrac nije ulogovan.");
    if(IsPlayerJailed(id)) return ErrorMsg(playerid, "Taj igrac je zatvoren.");
    if(IsPlayerInRace(id)) return ErrorMsg(playerid, "Igrac je na evenetu!");
    if(IsPlayerInWar(id)) return ErrorMsg(playerid, "Igrac je u waru!");
    if(PI[playerid][p_org_id] != PI[id][p_org_id]) return ErrorMsg(playerid, "Igrac nije dio vase bande/mafije!");

    SetPVarInt(playerid, "lDodijeliUloguID", id);

    if(bRob_prepKoji == 1){
        SPD(playerid, "bankUloga1", DIALOG_STYLE_LIST, "{FFFF00} ULOGE ZA PLJACKU BANKE(1)", "(1) Vozac auta za bijeg \n (2) Vozac auta za ciscenje", "Odaberi", "Izadji");
    } else if(bRob_prepKoji == 2)
    {
        ErrorMsg(playerid, "Za ovaj pristup ne postoje uloge.");
    }

    return 1;
}

CMD:startprep(playerid, const params[]) 
{
    if(IsPlayerConnected(playerid))
        return InfoMsg(playerid, "Sistem pljacke banke u izradi");
    if(bRob_imaPrep[playerid] == false) return ErrorMsg(playerid, "Nemate dodijeljen prep!");
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Samo clanovi mafija i bande mogu da koriste ovo.");
    
    if(bRob_uniformeId[0] == playerid && bRob_uniformeId[1] == 1) {
        InfoMsg(playerid, "Pokrenuli ste nabavku uniformi za pljacku!.");
        InfoMsg(playerid, "Odite na checkpoint i ukradite uniforme. Pazite da vas neko ne prijavi policiji.");
        SetPlayerCheckpoint_H(playerid, 1629.6100, -1844.5880, 13.5388, 3.0);
    }
    else if(bRob_getawayVehId[0] == playerid && bRob_getawayVehId[1] == 1) {
        InfoMsg(playerid, "Pokrenuli ste nabavku vozila za bjegstvo.");
        InfoMsg(playerid, "Odite na checkpoint i ukradite vozilo. Pazite da vas neko ne prijavi policiji.");

        DestroyVehicle(bRob_getawayVehId[2]);
        bRob_getawayVehId[2] = CreateVehicle(516, 2263.0422, 1490.7836, 29.0581, 269.6872, 252, 252, 1000, 0);

        SetPlayerCheckpoint_H(playerid, 2263.0422, 1490.7836, 29.0581, 5.0);
    }
    else if(bRob_vehId[0] == playerid && bRob_vehId[1] == 1) {
        InfoMsg(playerid, "Pokrenuli ste nabavku vozila za cistace.");
        InfoMsg(playerid, "Odite na checkpoint i ukradite vozilo. Pazite da vas neko ne prijavi policiji.");
        
        DestroyVehicle(bRob_vehId[2]);
        bRob_vehId[2] = CreateVehicle(482, 1319.0479, 395.5521, 19.6741, 334.0122, 252, 252, 1000, 0);

        SetPlayerCheckpoint_H(playerid, 1319.0479, 395.5521, 19.6741, 5.0);
    }

    return 1;
}

CMD:ukradiuniforme(playerid, const params[])
{
    if(bRob_imaPrep[playerid] == false) return ErrorMsg(playerid, "Nemate dodijeljen prep!");
    if(!IsACriminal(playerid)) return ErrorMsg(playerid, "Niste clan mafije/bande.");
    if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1629.6100, -1844.5880, 13.5388)) return ErrorMsg(playerid, "Niste na mjestu za kradju uniformi.");

    if(bRob_uniformeId[0] == playerid && bRob_uniformeId[1] == 1) {
        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 1, 0);
        //TogglePlayerControllable_H(playerid, false);
        SetTimerEx("UniformaUnfreeze", 30000, false, "i", playerid);
    }

    return 1;
}

CMD:pljackajbanku(playerid, const params[]) 
{
    /*if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1470.8264,-978.0361,22.8931))
        return ErrorMsg(playerid, "Niste na mestu za pljackanje banke.");

    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da pljackaju banku.");

    if (GetPlayerWeapon(playerid) <= 0)
        return ErrorMsg(playerid, "Morate drzati oruzje u ruci da biste pokrenuli pljacku.");

    new h, m, string[90], mb_igraci = 0, pd_igraci = 0, logStr[57];
    gettime(h, m);

    if(bRob_prepKoji == 1)
    {
        if(bRob_prepStage != 5) return ErrorMsg(playerid, "Niste pokrenuli pljacku banke");
        if(bRob_stage == BANK_STAGE_ROBBERY_IN_PROGRESS) return ErrorMsg(playerid, "Pljacka banke je vec u toku.");
        //if(h > 0 && h < 10) return ErrorMsg(playerid, "Ne mozete pljackati banku izmedju 01 i 10h.");
        if(bRob_cooldown > gettime() || bRob_stage > BANK_STAGE_ROBBERY_IN_PROGRESS)
        {
            format(string, sizeof string, "Banka je nedavno opljackana! Pokusajte ponovo za {FFFFFF} %s.", konvertuj_vreme(bRob_cooldown - gettime(), true));
            RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
            return 1;
        }

        foreach(new i : Player)
        {
            if(IsACop(i)) pd_igraci++;
            if(PI[i][p_org_id] == PI[playerid][p_org_id]) mb_igraci++;
        }

        if(pd_igraci < 4) return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 4)."); ovo promj
        if(mb_igraci < 4) return ErrorMsg(playerid, "Nema dovoljno tvojih saigraca (minimum 4).");*/

        /*bRob_faction = PI[playerid][p_org_id];
        bRob_initiator = playerid;
        bRob_policeTarget = playerid;
        bRob_time = 600;
        bRob_stage = BANK_STAGE_ROBBERY_IN_PROGRESS;
        TextDrawSetString(tdBankRobTime, "BANKA:    1:00");

        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == bRob_faction) TextDrawShowForPlayer(i, tdBankRobTime);
        }

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
        tmr_bRob = SetTimer("BankRobbery", 1*1000, true); // ukupno 600 sekundi

        format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pd_igraci, mb_igraci);
        Log_Write(LOG_ROBBERY, logStr);

        if(bRob_hakerKoji == 1) 
        {
            SetTimer("bRobHakerOdrada", 45 * 1000, false);
        }
        else if(bRob_hakerKoji == 2)
        {
            SetTimer("bRobHakerOdrada", 120 * 1000, false);
        }
        else if(bRob_hakerKoji == 3)
        {
            SetTimer("bRobHakerOdrada", 240 * 1000, false);
        }

    }
    else if(bRob_prepKoji == 2)
    {
        if (bRob_stage < BANK_STAGE_DOORS_UNLOCKED) return ErrorMsg(playerid, "Niste usli na regularan nacin u trezor. Morate ubiti strazara i otkljucati vrata pomocu kartice.");
        if (bRob_stage == BANK_STAGE_ROBBERY_IN_PROGRESS) return ErrorMsg(playerid, "Pljacka banke je vec u toku.");
        //if (h > 0 && h < 10) return ErrorMsg(playerid, "Ne mozete pljackati banku izmedju 01h i 10h.");

        if (bRob_cooldown > gettime() || bRob_stage > BANK_STAGE_ROBBERY_IN_PROGRESS) 
        {
            new stringNN[87];
            format(stringNN, sizeof stringNN, "Banka je nedavno vec opljackana! Pokusajte ponovo za {FFFFFF}%s.", konvertuj_vreme(bRob_cooldown - gettime(), true));
            RangeMsg(playerid, stringNN, SVETLOCRVENA, 15.0);
            return 1;
        }

         Provera da li ima barem 4 saigraca + barem 4 policajaca
        foreach (new i : Player)
        {
            if (IsACop(i)) pd_igraci++;
            if (PI[i][p_org_id] == PI[playerid][p_org_id]) mb_igraci++;
        }
        if (pd_igraci < 4)
            return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 4).");
        if (mb_igraci < 4)
            return ErrorMsg(playerid, "Nema dovoljno tvojih saigraca (minimum 4).");*/

        /*bRob_faction = PI[playerid][p_org_id];
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

        // Slanje poruke policiji i obavestenje za sve igrace
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}U toku je pljacka banke od strane neidentifikovane kriminalne grupe!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom delu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}pljacka banke u toku!");

        // Upisivanje u log

        format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pd_igraci, mb_igraci);
        Log_Write(LOG_ROBBERY, logStr);
    }*/
    InfoMsg(playerid, "Sistem pljacke banke u izradi");
    return 1;
}

CMD:bankstage(playerid, const params[])
{
    DebugMsg(playerid, "bRob_stage = %i", bRob_stage);
    return 1;
}

CMD:bankreset(playerid, params[])
{
    bRob_Reset();
    BankRobberyReset();

    bRob_cooldown = 0;
    return 1;
}