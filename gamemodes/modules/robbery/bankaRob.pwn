#include <YSI_Coding\y_hooks>

enum {
    BANK_AVAILABLE = 1,
    BANK_KILLED_SECURITY,
    BANK_PUT_DRILL,
    BANK_TOOK_MONEY,
    BANK_UNAVAILABLE
}

static
    BankRobTime,
    BankRobber,
    BankSuspect,
    BankStage,
    ControllingBankFaction,
    BankActor,
    BankReset,
    BankResetTimestamp,
    MoneyPickup,
    Kanalizacija,
    Busilica[5],
    NovacBanka[17],
    BankaSef,
    RobInTimeTimer
;

static
    PlayerRobbing[MAX_PLAYERS],
    HasMoney[MAX_PLAYERS]
;

new Float:RandomExits[6][3] =
{
    {1523.2170,-1191.4794,23.8450},
    {1617.8984,-994.4554,24.0670},
    {1520.9397,-969.8616,36.5628},
    {1293.4557,-990.5220,32.6953},
    {1522.2638,-1664.5452,13.5757},
    {1365.7897,-1289.0082,13.5469}
};

#define BANK_ROB_BOUNTY 300000

hook OnGameModeInit()
{
    BankRobber = INVALID_PLAYER_ID;
    BankRobTime =
    BankSuspect =
    ControllingBankFaction =
    MoneyPickup =
    BankActor = -1;

    BankResetTimestamp = 0;

    testingdaddy = false;

    Busilica[0] = INVALID_OBJECT_ID;
    NovacBanka[0] = INVALID_OBJECT_ID;
    
    BankActor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, false, 100.0, 1);
    ApplyDynamicActorAnimation(BankActor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    KreirajNovac();

    KreirajKanalizaciju();

    CreateDynamic3DTextLabel("[ KANALIZACIJA IZLAZ ]\n {FFFFFF}Da izadjete kroz kanalizaciju koristite tipku 'F' ili 'ENTER'",0x9EC73DAA,1454.9529,-912.6064,19.9656, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ BUSILICA ]\n {FFFFFF}Da postavite busilicu koristite tipku 'N'", 0x9EC73DAA, 1460.6890,-969.0071,23.9261, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ DINAMIT ]\n {FFFFFF}Da postavite dinamit koristite tipku 'Y'", 0x9EC73DAA, 1454.5032,-960.9556,24.0797, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    CreateDynamic3DTextLabel("[ NOVAC ]\n {FFFFFF}Da pokupite novac u torbu koristite tipku 'N'", 0x9EC73DAA, 1462.6451,-959.3177,24.0797, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);

    BankaSef = CreateDynamicObject(18846, 1461.008178, -966.659118, 25.796073, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(BankaSef, 0, 10412, "hotel1", "gold128", 0x00000000);
    SetDynamicObjectMaterial(BankaSef, 1, 10412, "hotel1", "gold128", 0x00000000);

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnDynamicActorStreamIn(actorid, forplayerid)
{
    SetDynamicActorPos(BankActor, 1440.9053, -985.0209, 25.5261);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerGiveDmgDynActor(playerid, actorid, Float:amount, weaponid, bodypart)
{
    if(actorid == BankActor)
    {
        // provjere;
        //new fid = GetFactionIDbyName("La Casa De Papel");

        //if(GetPlayerFactionID(playerid) != fid)
        //    return ErrorMsg(playerid, "Samo La Casa De Papel moze zapoceti pljacku.");
        
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
                AddPlayerCrime(playerid, INVALID_PLAYER_ID, 4, "Pokusaj pljacke banke", "Snimak sa nadzorne kamere");
                return ErrorMsg(playerid, "Morate imati jos 3 saigraca u ovoj prostoriji da biste pokrenuli pljacku banke.");
            } 
            if (pds < 3) {
                return ErrorMsg(playerid, "Na serveru moraju biti prisutna minimalno 3 policajca da biste pokrenuli pljacku banke.");
            }
        }

        // pokretanje pljacke;
        BankRobber = playerid;
        ControllingBankFaction = GetPlayerFactionID(BankRobber);

        // stage: ubijen security;
        BankStage = BANK_KILLED_SECURITY;
        DestroyDynamicActor(BankActor);
        GameTextForPlayer(playerid, "~g~Uspjesno~w~ ste ranili security-a~n~Nastavite dalje i postavite busilicu!", 5000, 3);

        // crime report;
        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Napad na zastitara", "Snimak sa nadzorne kamere");

        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Security NL banke je ranjen od strane neidentifikovane kriminalne grupe!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom dijelu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}moguca pljacka banke u toku!");

        // upisivanje u log;
        static logStr[99];
        format(logStr, sizeof logStr, "BANKA-START | %s | PD: %i vs %i", ime_obicno[playerid], pds, saigraci);
        Log_Write(LOG_ROBBERY, logStr);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_NO)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1460.8927,-966.8206,23.9261) && BP_PlayerItemGetCount(playerid, ITEM_DRILL) && BankStage == BANK_KILLED_SECURITY)
        {
            if(Busilica[0] != INVALID_OBJECT_ID) return ErrorMsg(playerid, "Busilica je vec postavljena.");
            BankRobTime = 600; // 600
            TextDrawSetString(tdBankRobTime, "BUSENJE:   10:00");

            BP_PlayerItemSub(playerid, ITEM_DRILL);

            foreach (new i : Player)
            {
                if (GetPlayerFactionID(i) == ControllingBankFaction || IsACop(i))
                    TextDrawShowForPlayer(i, tdBankRobTime);
            }

            KreirajBusilicu();

            // stage: postavljena busilica;
            BankStage = BANK_PUT_DRILL;

            SetTimer("BankRobbery", 1*1000, false); // ukupno 600 sekundi
        }
        else if(IsPlayerInRangeOfPoint(playerid, 3.0, 1462.4852,-959.4798,24.0797) && BankStage == BANK_PUT_DRILL)// && GetPlayerFactionID(playerid) == GetFactionIDbyName("La Casa De Papel")
        {
            // stage: uzeo novac;
            BankStage = BANK_TOOK_MONEY;
            BankSuspect = playerid;
            UnistiNovac();

            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
            SetPlayerAttachedObject( playerid, SLOT_BACKPACK, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );

            HasMoney[playerid] = true;
            SetPlayerCheckpoint(playerid, FACTIONS[ControllingBankFaction][f_x_spawn], FACTIONS[ControllingBankFaction][f_y_spawn], FACTIONS[ControllingBankFaction][f_z_spawn], 1.5);

            RobInTimeTimer = SetTimer("RobInTimeBank", 1000*60*90, false);
        }
        return 1;
    }
    else if(newkeys & KEY_YES)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, 1454.6167,-958.7255,24.0556) && BankStage == BANK_TOOK_MONEY)// && GetPlayerFactionID(playerid) == GetFactionIDbyName("La Casa De Papel")
        {
            if((PI[playerid][p_bomba][BOMBA_S] >= 1 || PI[playerid][p_bomba][BOMBA_M] >= 1 || PI[playerid][p_bomba][BOMBA_L] >= 1))
            {
                SetTimerEx("Bombing", 2000, false, "i", playerid);
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 1, 0);

                if(PI[playerid][p_bomba][BOMBA_S] >= 1)
                {
                    PI[playerid][p_bomba][BOMBA_S] -= 1;
                    return 1;
                }
                else if(PI[playerid][p_bomba][BOMBA_M] >= 1)
                {
                    PI[playerid][p_bomba][BOMBA_M] -= 1;
                    return 1;
                }
                else if(PI[playerid][p_bomba][BOMBA_L] >= 1)
                {
                    PI[playerid][p_bomba][BOMBA_L] -= 1;
                    return 1;
                }
            }
            else
                return ErrorMsg(playerid, "Nemate kreiranu bombu.");
        }
        return 1;
    }
    else if(newkeys & KEY_SECONDARY_ATTACK)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, 1454.9529,-912.6064,19.9656) && !IsPlayerInAnyVehicle(playerid)) //Kanalizacija 
        {
            SPD(playerid, "ChooseExit", DIALOG_STYLE_LIST, "Odabir sahta", "Saht 1\nSaht 2\nSaht 3\nSaht 4\nSaht 5\nSaht 6", "Potvrdi", "Odustani");
        }
        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    new
        sLog[64]
    ;

    if (ControllingBankFaction != -1) {
        if(IsPlayerInRangeOfPoint(playerid, 1.5, FACTIONS[ControllingBankFaction][f_x_spawn], FACTIONS[ControllingBankFaction][f_y_spawn], FACTIONS[ControllingBankFaction][f_z_spawn]) && HasMoney[playerid])
        {
            DisablePlayerCheckpoint(playerid);
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

            if(IsACop(playerid))
            {
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je ubijen u vatrenom okrsaju sa policijom.", ime_rp[BankSuspect]);
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog hrabrog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(floatround(GetBankRobBounty()/10000.0) * 10000));

                // skill-up;
                static skill = 3;

                static Float:x,Float:y,Float:z;
                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                    {
                        PlayerUpdateCopSkill(i, skill, SKILL_BANKWIN, (i==playerid)? 0 : 1);
                    }
                }

                FACTIONS[PI[playerid][p_org_id]][f_budzet] += floatround(GetBankRobBounty()/10000.0) * 10000;

                // Upisivanje u log
                format(sLog, sizeof sLog, "BANKA-FAILED (PDWON) | %s | %s | %s", FACTIONS[ControllingBankFaction][f_tag], ime_obicno[playerid], formatMoneyString(GetBankRobBounty()));
                Log_Write(LOG_ROBBERY, sLog);
            }
            else if(IsACriminal(playerid))
            {
                SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je banku!");
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, vrednost ukradenog novca se procenjuje na oko {FF0000}%s!", formatMoneyString(GetBankRobBounty()));
                SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

                // Skill UP za sve clanove u okolini + dodavanje novca u sef
                new
                    oldValue,
                    Float:x,Float:y,Float:z,
                    totalRanks = 0,
                    sQuery[125]
                ;

                FACTIONS[ControllingBankFaction][f_budzet] += GetBankRobBounty();

                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (GetPlayerFactionID(i) == ControllingBankFaction)
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
                    else if (!IsPlayerAFK(i) && GetPlayerAFKTime(i) < 1800)
                    { 
                        if (PI[i][p_banka] >= 10000)
                        {
                            oldValue = random(10000);
                            PI[i][p_banka] -= oldValue;
                            
                            format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %i WHERE id = %i", PI[i][p_banka], PI[i][p_id]);
                            mysql_tquery(SQL, sQuery);

                            SendClientMessageF(i, SVETLOCRVENA, "** Sa tvog bankovnog racuna nestalo je {FF0000}%s.", formatMoneyString(oldValue));
                        }
                    }
                }
                
                // Oduzimanje novca svim igracima koji su izasli sa servera u prethodnih 20 minuta
                format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = banka * 0.95 WHERE banka > 0 AND org_id != %i AND poslednja_aktivnost > NOW() - INTERVAL 20 MINUTE", PI[playerid][p_org_id]);
                mysql_tquery(SQL, sQuery);

                // Upisivanje u log
                format(sLog, sizeof sLog, "BANKA-USPEH | %s | %s | %s", FACTIONS[ControllingBankFaction][f_tag], ime_obicno[playerid], formatMoneyString(GetBankRobBounty()));
                Log_Write(LOG_ROBBERY, sLog);
            }
            else
                return ErrorMsg(playerid, "[bankaRob.pwn] Trenutno nije moguce izvrsiti ovu radnju, prijavi skripteru!");

            RemoveBankPoliceTarget();
            RobberyFinish(playerid);//CallLocalFunction("OnRobberyFinish", "playerid");
            // resetovati banku
        }
    }
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(HasMoney[playerid] && IsPlayerConnected(killerid))
    {
        if(GetPlayerFactionID(killerid) == GetPlayerFactionID(playerid))
            PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "TK");
        
        if(IsACop(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!", ime_rp[playerid]);

        else if(IsACriminal(playerid))
        {
            if(IsACop(killerid))
            {
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je ubijen u vatrenom okrsaju sa policijom.", ime_rp[BankSuspect]);
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog hrabrog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(floatround(GetBankRobBounty()/10000.0) * 10000));

                // skill-up;
                static skill = 3;

                static Float:x,Float:y,Float:z;
                GetPlayerPos(playerid, x, y, z);
                foreach (new i : Player)
                {
                    if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                    {
                        PlayerUpdateCopSkill(i, skill, SKILL_BANKWIN, (i==playerid)? 0 : 1);
                    }
                }

                FACTIONS[PI[playerid][p_org_id]][f_budzet] += floatround(GetBankRobBounty()/10000.0) * 10000;

                // Upisivanje u log
                new
                    sLog[256]
                ;
                format(sLog, sizeof sLog, "BANKA-FAILED (PDWON) | %s | %s | %s", FACTIONS[ControllingBankFaction][f_tag], ime_obicno[playerid], formatMoneyString(GetBankRobBounty()));
                Log_Write(LOG_ROBBERY, sLog);

                RemoveBankPoliceTarget();
                RobberyFinish(playerid);

                return 1;
            }

            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti novac!", ime_rp[playerid]);

            new
                Float:deathX,
                Float:deathY,
                Float:deathZ
            ;
            GetPlayerPos(playerid, deathX, deathY, deathZ);
            DisablePlayerCheckpoint(playerid);
            BankSuspect = INVALID_PLAYER_ID;
            ControllingBankFaction = -1;
            HasMoney[playerid] = false;

            SetTimerEx("DropBag", 4000, false, "fff", deathX, deathY, deathZ);
            // resetovati banku
        }
        /*    SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti novac!", ime_rp[playerid]);

        new
            Float:deathX,
            Float:deathY,
            Float:deathZ
        ;
        GetPlayerPos(playerid, deathX, deathY, deathZ);
        DisablePlayerCheckpoint(playerid);
        BankSuspect = INVALID_PLAYER_ID;
        ControllingBankFaction = -1;
        HasMoney[playerid] = false;

        SetTimerEx("DropBag", 4000, false, "fff", deathX, deathY, deathZ);*/
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if(BankStage == BANK_UNAVAILABLE || BankStage == BANK_KILLED_SECURITY || BankStage == BANK_AVAILABLE)
        return Y_HOOKS_CONTINUE_RETURN_1;
    
    if(pickupid == MoneyPickup && BankStage == BANK_TOOK_MONEY && IsValidDynamicPickup(MoneyPickup))
    {
        if(!IsACop(playerid) && !IsACriminal(playerid))
            return 1;
        
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);
        SetPlayerAttachedObject( playerid, SLOT_BACKPACK, 1550, 1, -0.008714, -0.188819, -0.026564, 159.138153, 86.558647, 0.000000, 1.005565, 0.984468, 1.014210 );
    
        if(IsACop(playerid))
        {
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako saznajemo, policija je preuzela novac te ga nastoji vratiti!");
        }
        else if(IsACriminal(playerid))
        {
            BankSuspect = playerid;
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kako saznajemo, drugo neidentiikovano kriminalno lice nastoji ukrasti novac!");
        }
        
        DestroyDynamicPickup(MoneyPickup);
        MoneyPickup = -1;
        HasMoney[playerid] = true;
        ControllingBankFaction = GetPlayerFactionID(playerid);
        SetPlayerCheckpoint(playerid, FACTIONS[ControllingBankFaction][f_x_spawn], FACTIONS[ControllingBankFaction][f_y_spawn], FACTIONS[ControllingBankFaction][f_z_spawn], 1.5);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(HasMoney[playerid])
    {
        if(IsACop(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policajac pod imenom {FFFFFF}%s {FF6347} je poginuo pokusavajuci vratiti novac!", ime_rp[playerid]);

        else if(IsACriminal(playerid))
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Kriminalno lice pod imenom {FFFFFF}%s {FF6347} je poginulo pokusavajuci ukrasti novac!", ime_rp[playerid]);

        new
            Float:deathX,
            Float:deathY,
            Float:deathZ
        ;
        GetPlayerPos(playerid, deathX, deathY, deathZ);
        DisablePlayerCheckpoint(playerid);
        BankSuspect = INVALID_PLAYER_ID;
        ControllingBankFaction = -1;
        HasMoney[playerid] = false;

        SetTimerEx("DropBag", 4000, false, "fff", deathX, deathY, deathZ);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
    PlayerRobbing[playerid] =
    HasMoney[playerid] = false;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

//

/*GetBankActorID()
{
    return BankActor;
}*/

stock RobberyFinish(playerid)
{
    BankStage = BANK_UNAVAILABLE;

    PlayerRobbing[playerid] = false;
    HasMoney[playerid] = false;

    BankRobber =
    BankRobTime =
    BankSuspect =
    ControllingBankFaction =
    MoneyPickup =
    BankActor = -1;

    BankResetTimestamp = gettime() + 10800;
    BankReset = SetTimer("ResetBankRobbery", 180*60000, false); //gettime() + 10800; // 3h cooldown
    KillTimer(RobInTimeTimer);    
    if(IsValidDynamicObject(Kanalizacija))
    {
        DestroyDynamicObject(Kanalizacija);
        Kanalizacija = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(Busilica[0]))
    {
        DestroyDynamicObject(Busilica[0]);
        Busilica[0] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[1]);
        Busilica[1] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[2]);
        Busilica[2] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[3]);
        Busilica[3] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[4]);
        Busilica[4] = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(NovacBanka[0]))
    {
        for(new i = 0; i < 17; i++)
        {
            DestroyDynamicObject(NovacBanka[i]);
            NovacBanka[i] = INVALID_OBJECT_ID;
        }
    }
    return 1;
}

forward RobInTimeBank();
public RobInTimeBank()
{
    if(IsValidDynamicPickup(MoneyPickup))
        DestroyDynamicPickup(MoneyPickup);

    MoneyPickup = -1;
    
    if(GetBankPoliceTarget() != INVALID_PLAYER_ID)
    {
        HasMoney[GetBankPoliceTarget()] = false;
        DisablePlayerCheckpoint(GetBankPoliceTarget());
        RemoveBankPoliceTarget();
    }
    //BankReset = SetTimer("ResetBankRobbery", 180*60000, false);

    BankStage = BANK_UNAVAILABLE;

    BankRobber =
    BankRobTime =
    BankSuspect =
    ControllingBankFaction =
    MoneyPickup =
    BankActor = -1;

    BankResetTimestamp = gettime() + 10800;
    BankReset = SetTimer("ResetBankRobbery", 180*60000, false); //gettime() + 10800; // 3h cooldown
    KillTimer(RobInTimeTimer);    
    if(IsValidDynamicObject(Kanalizacija))
    {
        DestroyDynamicObject(Kanalizacija);
        Kanalizacija = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(Busilica[0]))
    {
        DestroyDynamicObject(Busilica[0]);
        Busilica[0] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[1]);
        Busilica[1] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[2]);
        Busilica[2] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[3]);
        Busilica[3] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[4]);
        Busilica[4] = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(NovacBanka[0]))
    {
        for(new i = 0; i < 17; i++)
        {
            DestroyDynamicObject(NovacBanka[i]);
            NovacBanka[i] = INVALID_OBJECT_ID;
        }
    }

    KillTimer(RobInTimeTimer);
    return true;
}

forward ResetBankRobbery();
public ResetBankRobbery()
{
    if(GetBankPoliceTarget() != INVALID_PLAYER_ID) {
        HasMoney[GetBankPoliceTarget()] = false;
    }
    RemoveBankPoliceTarget();
    if(IsValidDynamicPickup(MoneyPickup))
        DestroyDynamicPickup(MoneyPickup);
    
    MoneyPickup = -1;

    BankStage = BANK_AVAILABLE;
    BankResetTimestamp = 0;
    BankRobber = INVALID_PLAYER_ID;
    
    if(IsValidDynamicActor(BankActor))
        DestroyDynamicActor(BankActor);
    
    BankActor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, false, 100.0, 0);
    ApplyDynamicActorAnimation(BankActor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 30.0, 1440.9053, -985.0209, 25.5261))
            Streamer_Update(i);
    }

    KreirajNovac();
    KreirajKanalizaciju();

    DestroyDynamicObject(BankaSef);

    BankaSef = CreateDynamicObject(18846, 1461.008178, -966.659118, 25.796073, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(BankaSef, 0, 10412, "hotel1", "gold128", 0x00000000);
    SetDynamicObjectMaterial(BankaSef, 1, 10412, "hotel1", "gold128", 0x00000000);
    return 1;
}

Dialog:ChooseExit(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;
    
    SetPlayerCompensatedPos(playerid, RandomExits[listitem][0], RandomExits[listitem][1], RandomExits[listitem][2]);
    return 1;
}

forward DropBag(Float:X, Float:Y, Float:Z);
public DropBag(Float:X, Float:Y, Float:Z)
{
    MoneyPickup = CreateDynamicPickup(1550, 1, X, Y, Z, -1, -1, -1, STREAMER_PICKUP_SD, -1, 0);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 15.0, X, Y, Z))
            Streamer_Update(i);
    }
    return 1;
}

forward ExplodeDynamite(playerid);
public ExplodeDynamite(playerid) {
    
    UnistiKanalizaciju();
    CreateExplosion(1454.5032,-960.9556,24.0797, 12, 2.0);
    GameTextForPlayer(BankRobber, "~g~Uspjesno ~w~ste unistili prolaz za kanalizaciju.~n~Prodjite dalje.", 5000, 3);
    return 1;
}

forward Bombing(playerid);
public Bombing(playerid)
{
    ClearAnimations(playerid, 1);
    SetTimer("ExplodeDynamite", 10000, false);
    GameTextForPlayer(playerid, "Bomba ce eksplodirati za 10 sekundi~n~udaljite se!", 3000, 3);
    return 1;
}

forward BankRobbery();
public BankRobbery()
{
    BankRobTime -= 1;

    new str[26];
    format(str, sizeof str, "BUSENJE:   %s", konvertuj_vreme(BankRobTime));
    TextDrawSetString(tdBankRobTime, str);

    if (BankRobTime == -1)
    {
        TextDrawHideForAll(tdBankRobTime);

        UnistiBusilicu();
        PomeriBankaVrata();

        GameTextForPlayer(BankRobber, "~g~Uspjesno ~w~ste probili vrata sefa~n~pokupite novac (Klik '~g~N~w~')", 5000, 3);

        return 1;
    }
    SetTimer("BankRobbery", 1*1000, false);
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
    if (BankRobber == playerid) return 1;
    return 0;
}

stock GetFactionRobbingBank()
{
    return ControllingBankFaction;
}

stock GetBankPoliceTarget()
{
    return BankSuspect;
}

stock RemoveBankPoliceTarget()
{
    BankSuspect = INVALID_PLAYER_ID;
}

stock BankRob_SetPoliceTarget(playerid)
{
    BankSuspect = playerid;
}

stock GetBankRobBounty()
{
    return BANK_ROB_BOUNTY;
}

stock IsBankRobberyInProgress()
{
    if (BankStage == BANK_KILLED_SECURITY || BankStage == BANK_PUT_DRILL || BankStage == BANK_TOOK_MONEY)
        return 1;

    return 0;
}

stock GetBankCooldownTimestamp()
{
    return BankResetTimestamp;
}

flags:forceresetbank(FLAG_ADMIN_6)
CMD:forceresetbank(playerid)
{
    KillTimer(BankReset);
    BankStage = BANK_AVAILABLE;
    BankResetTimestamp = 0;
    if(IsValidDynamicActor(BankActor))
        DestroyDynamicActor(BankActor);

    BankRobber = INVALID_PLAYER_ID;

    BankActor = CreateDynamicActor(71, 1440.9053, -985.0209, 25.5261,177.8431, false, 100.0, 1);
    ApplyDynamicActorAnimation(BankActor, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);

    if(IsValidDynamicObject(Kanalizacija))
    {
        DestroyDynamicObject(Kanalizacija);
        Kanalizacija = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(Busilica[0]))
    {
        DestroyDynamicObject(Busilica[0]);
        Busilica[0] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[1]);
        Busilica[1] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[2]);
        Busilica[2] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[3]);
        Busilica[3] = INVALID_OBJECT_ID;
        DestroyDynamicObject(Busilica[4]);
        Busilica[4] = INVALID_OBJECT_ID;
    }
    if(IsValidDynamicObject(NovacBanka[0]))
    {
        for(new i = 0; i < 17; i++)
        {
            DestroyDynamicObject(NovacBanka[i]);
            NovacBanka[i] = INVALID_OBJECT_ID;
        }
    }

    KreirajNovac();
    KreirajKanalizaciju();

    DestroyDynamicObject(BankaSef);

    BankaSef = CreateDynamicObject(18846, 1461.008178, -966.659118, 25.796073, 0.000000, 90.000000, 90.000000, -1, -1, -1, 300.00, 300.00);
    SetDynamicObjectMaterial(BankaSef, 0, 10412, "hotel1", "gold128", 0x00000000);
    SetDynamicObjectMaterial(BankaSef, 1, 10412, "hotel1", "gold128", 0x00000000);
    //CallLocalFunction("ResetBankRobbery", "");
    return 1;
}