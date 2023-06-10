#include <YSI_Coding\y_hooks>

// TODO: Ograniciti na 2 ili 3 dostave DNEVNO po mafiji!

// TODO Ako igrac ode off sa kutijom u ruci, sta se desava sa kutijom i narednim igracem koji zauzme njegov ID?
// A sta se desava ako igrac umre sa kutijom u ruci? Isto pitanje za dostavljaca pice, djubretara, itd.

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define DELIVERY_VEH_MODEL (482) // Burrito
#define DELIVERY_NUM_CRATES (10) // Broj kutija za utovar




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum 
{
    DELIVERY_WAITING_PIN = 1,       // Ceka se da stigne pin na SMS
    DELIVERY_TRAVELING,             // Putuje se do odredista
    DELIVERY_IN_AREA,               // Unutar zone
    DELIVERY_ENTERING_PIN,          // Unosi PIN
    DELIVERY_LOADING,               // Utovar kutija
    DELIVERY_GOING_BACK,            // Povratak u bazu
    DELIVERY_UNLOADING,             // Istovar kutija


    DELIVERY_LIFT_TIMER = 100,      // Tajmer za podizanje/spustanje kutije je aktiviran
    DELIVERY_CARRYING_CRATE,        // Igrac nosi kutiju u rukama
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    weaponDelivery, // id mafije koja radi dostavu (-1 za neaktivno)
    deliveryInitiator, // inicijator (igrac koji je zvao broj)
    deliveryCode,
    deliveryVehicle,
    deliveryStage,
    deliveryInput[5],
    weaponDeliveryCrate[DELIVERY_NUM_CRATES],
    deliveryLoadMax,
    deliveryLoadedCount,
    deliveryUnloadMax,
    deliveryUnloadedCount,
    deliveryUnloadLifted,
    deliveryTimer,
    weaponDelivery_Mats,

    deliveryDoors,
    deliveryArea,
    deliveryKeypadCP,
    deliveryUnloadCP,
    deliveryUnloadPickup,

    Float:deliveryUnloadPos[3],
    tajmer:delivery_TimeUp,

    Iterator:iDeliveryCrates<DELIVERY_NUM_CRATES>
;

static deliveryTime;

new Float:deliveryCrates[DELIVERY_NUM_CRATES][4] = 
{
    {-1114.027465, -1618.819580, 75.603271, 0.000000},
    {-1115.257568, -1618.819580, 76.513267, 0.000000},
    {-1116.618896, -1621.780151, 76.523269, 90.00000},
    {-1116.618896, -1620.319335, 75.613311, 90.00000},
    {-1116.618896, -1621.509765, 75.613311, 90.00000},
    {-1116.618896, -1623.900390, 76.523269, 90.00000},
    {-1116.618896, -1625.321289, 76.523269, 90.00000},
    {-1116.618896, -1624.340576, 75.613311, 90.00000},
    {-1114.398925, -1626.461303, 75.613311, 180.0000},
    {-1113.448486, -1626.521362, 76.523315, 180.0000}
};





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    weaponDelivery = deliveryInitiator = deliveryVehicle = -1;
    deliveryUnloadPickup = -1;
    deliveryUnloadCP = -1;
    deliveryKeypadCP = -1;
    deliveryCode = deliveryStage = -1;
    deliveryInput[0] = EOS;

    deliveryDoors = CreateDynamicObjectEx(2949, -1111.765136, -1623.620971, 75.350502, 0.000000, 0.000000, 180.000000, 750.0, 750.0);


    // Kreiranje kutija
    for__loop (new i = 0; i < DELIVERY_NUM_CRATES; i++) {
        weaponDeliveryCrate[i] = CreateDynamicObjectEx(3052, deliveryCrates[i][0], deliveryCrates[i][1], deliveryCrates[i][2], 0.0, 0.0, deliveryCrates[i][3], 300.0, 300.0);
        Iter_Add(iDeliveryCrates, i);
    } 

    deliveryArea = CreateDynamicRectangle(-1147.9510,-1734.4865, -1005.1130,-1566.4463);
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(playerid == deliveryInitiator)
    {
        DestroyDynamicCP(deliveryKeypadCP), deliveryKeypadCP = -1;
    }
}

hook OnPlayerSpawn(playerid)
{
    if(playerid == deliveryInitiator)
    {
        DestroyDynamicCP(deliveryKeypadCP), deliveryKeypadCP = -1;
    }
}

hook OnPlayerDisconnect(playerid, reason) 
{
    new timerid = GetPVarInt(playerid, "timer_deliveryCall");
    DeletePVar(playerid, "timer_deliveryCall");
    KillTimer(timerid);

    if (playerid == deliveryInitiator)
    {
        deliveryInitiator = -1;
        DestroyDynamicCP(deliveryKeypadCP), deliveryKeypadCP = -1;
    }

    return 1;
}

hook OnPlayerEnterDynArea(playerid, areaid) 
{
    if (weaponDelivery == -1) return 1;

    if (areaid == deliveryArea && PI[playerid][p_org_id] == weaponDelivery && deliveryStage <= DELIVERY_LOADING) {
        if (deliveryStage < DELIVERY_IN_AREA)
            deliveryStage = DELIVERY_IN_AREA;

        SendClientMessage(playerid, TAMNOCRVENA, "(dostava) {FFFFFF}Udjite u skladiste i utovarite sve kutije u kombi.");
        SetVehicleParamsForPlayer(deliveryVehicle, playerid, 1, 0);
        return ~1;
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid) 
{
    if (weaponDelivery == -1) return 1;

    if (checkpointid == deliveryKeypadCP && PI[playerid][p_org_id] == weaponDelivery && deliveryStage == DELIVERY_IN_AREA) {
        if (deliveryInitiator == -1 || deliveryInitiator == playerid) 
        {
            ptdKeypad_Create(playerid);
            ptdKeypad_Show(playerid);
            SelectTextDraw(playerid, 0xF2E4AEFF);

            deliveryInput[0] = EOS;
            deliveryStage = DELIVERY_ENTERING_PIN;

            DestroyDynamicCP(deliveryKeypadCP), deliveryKeypadCP = -1;
        }
        return ~1;
    }

    if (checkpointid == deliveryUnloadCP && deliveryStage == DELIVERY_GOING_BACK && GetPlayerVehicleID(playerid) == deliveryVehicle) 
    {
        deliveryUnloadMax = deliveryLoadedCount;
        deliveryUnloadedCount = 0;
        deliveryUnloadLifted = 0;

        new str[22];
        format(str, sizeof str, "KUTIJE:      %02i/%02i", deliveryUnloadedCount, deliveryUnloadMax);
        TextDrawSetString(tdMaterialsDelivery[WD_COUNTER], str);

        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery && IsPlayerInRangeOfPoint(i, 150.0, deliveryUnloadPos[POS_X], deliveryUnloadPos[POS_Y], deliveryUnloadPos[POS_Z])) 
            {
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Istovarite sve kutije sa materijalima u skladiste!");
                TextDrawShowForPlayer(playerid, tdMaterialsDelivery[WD_COUNTER]);
            }
        }


        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, 1, objective);

        deliveryStage = DELIVERY_UNLOADING;
        deliveryUnloadPickup = CreateDynamicPickup(1279, 1, deliveryUnloadPos[POS_X], deliveryUnloadPos[POS_Y], deliveryUnloadPos[POS_Z]);

        DestroyDynamicCP(deliveryUnloadCP), deliveryUnloadCP = -1;


        // Slanje obavestenja za druge mafije
        new maxTurfs = floatround(CountTurfs()/3, floatround_floor);
        for__loop (new f_id = 0; f_id < MAX_FACTIONS; f_id++)
        {
            if (FACTIONS[f_id][f_loaded] != -1 && (FACTIONS[f_id][f_vrsta] == FACTION_MAFIA || FACTIONS[f_id][f_vrsta] == FACTION_GANG || FACTIONS[f_id][f_vrsta] == FACTION_RACERS) && f_id != weaponDelivery)
            {
                new ownedTurfs = CountTurfsOwnedByGroup(f_id),
                    probability = floatround((ownedTurfs/maxTurfs) * 100);

                if ((1+random(100)) <= probability)
                {
                    // Obavesti mafiju da druga mafija radi dostavu
                    foreach (new i : Player)
                    {
                        if (PI[i][p_org_id] == f_id)
                        {
                            SendClientMessage(i, TAMNOCRVENA, "(dostava) {FF6347}Dousnik: neko je upravo dosao ovde po materijale!");
                        }
                    }
                }
            }
        }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) 
{
    // if (deliveryVehicle != -1) return 1; // nastavlja se samo ako je dostava aktivna


    // Isto (slicno) parce koda se koristi i u deliverySMS()
    new vehicleid = GetPlayerVehicleID(playerid);
    if (GetVehicleModel(vehicleid) == DELIVERY_VEH_MODEL && IsFactionVehicle(vehicleid, weaponDelivery)) 
    {
        if (deliveryVehicle == -1)
        {
            if (playerid == deliveryInitiator && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)) 
            {
                deliveryVehicle = vehicleid;
                SetVehicleHealth(vehicleid, 2500.0);

                deliveryKeypadCP = CreateDynamicCP(-1111.3523, -1621.8158, 76.4072, 1.0, 0, 0, playerid, 6000.0, -1, 1000);
                return ~1;
            }
        }

        else if (deliveryVehicle != -1 && IsACriminal(playerid) && PI[playerid][p_org_id] != weaponDelivery && newstate == PLAYER_STATE_DRIVER)
        {
            // Pripadnik suparnicke mafije preoteo kombi
            if (deliveryStage == DELIVERY_GOING_BACK)
            {
                // Preotet je u nekom trenutku kad su ovi krenuli na nazad, dakle ne u toku utovara ili pre
                foreach (new i : Player) 
                {
                    if (PI[i][p_org_id] == weaponDelivery) 
                    {
                        SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Suparnicka mafija je preuzela kombi sa materijalima!!!");
                    }
                    else if (PI[i][p_org_id] == PI[playerid][p_org_id])
                    {
                        SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Uspeli ste da preuzmete kombi sa materijalima! Odvezite ga u bazu i istovarite materijale!");
                        TextDrawShowForPlayer(i, tdMaterialsDelivery[WD_COUNTER]);
                        TextDrawShowForPlayer(i, tdMaterialsDelivery[WD_TIMER]);
                    }
                }

                weaponDelivery = PI[playerid][p_org_id];


                // Ako se menjaju ID-evi/koordinate, promeniti i na delivery_loadingPutDown
                if (weaponDelivery == 1) // EC
                    deliveryUnloadPos = Float:{-703.8419,961.2007,12.1640};

                else if (weaponDelivery == 2) // weg
                    deliveryUnloadPos = Float:{921.3898,-2632.1860,42.0328};

                else if (weaponDelivery == 3) // lcdp
                    deliveryUnloadPos = Float:{2336.9263,36.7384,26.1412};

                else if (weaponDelivery == 4) // pp
                    deliveryUnloadPos = Float:{864.2454,-1064.2881,24.7597};

                else if (weaponDelivery == 5) // LSB
                    deliveryUnloadPos = Float:{2245.8152, -1452.4911, 23.3815};

                else if (weaponDelivery == 6) // GSF
                    deliveryUnloadPos = Float:{2515.5186, -1672.4338, 13.3099};

                else if (weaponDelivery == 7) // ms13
                    deliveryUnloadPos = Float:{2508.4531,-2009.7021,12.9425};

                else if (weaponDelivery == 8) // AM
                    deliveryUnloadPos = Float:{976.7514,-1949.1141,12.6541};

                else if (weaponDelivery == 9) // LCN
                    deliveryUnloadPos = Float:{1087.1947, -1999.9484, 48.9232};

                else if (weaponDelivery == 10) // SB
                    deliveryUnloadPos = Float:{1298.4980, -798.9592, 84.1406};

                /*else if (weaponDelivery == 7) // LSV
                    deliveryUnloadPos = Float:{2569.8452,-1119.7156,65.0201};

                else if (weaponDelivery == 8) // ZK
                    deliveryUnloadPos = Float:{-58.0541,-224.1546,5.4297};

                else if (weaponDelivery == 10) // GN/VLA
                    deliveryUnloadPos = Float:{2153.0693,-2288.3613,13.3614};

                else if (weaponDelivery == 11) // LS
                    deliveryUnloadPos = Float:{1672.5951,-2087.0024,13.5543};

                else if (weaponDelivery == 12) // MS13
                    deliveryUnloadPos = Float:{2458.5178,-1968.3217,13.5086};

                else if (weaponDelivery == 13) // TSF
                    deliveryUnloadPos = Float:{916.3652,-614.6505,114.7290};*/

                else 
                    return FactionMsg(PI[playerid][p_org_id], GRESKA_NEPOZNATO);
                
                
                DestroyDynamicCP(deliveryUnloadCP);
                deliveryUnloadCP = CreatePlayerCP(deliveryUnloadPos[POS_X], deliveryUnloadPos[POS_Y], deliveryUnloadPos[POS_Z], 5.0, 0, 0, playerid, 6000.0);
                deliveryInitiator = playerid;
            }
        }
    }
    if (playerid == deliveryInitiator && (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) && GetVehicleModel(vehicleid) != DELIVERY_VEH_MODEL)
    {
        SendClientMessage(playerid, SVETLOCRVENA, "Morate uci u kombi koji je vlasnistvo Vase mafije/bande!");
        return 1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    // ----------- UTOVAR -----------
    if (PI[playerid][p_org_id] == weaponDelivery && deliveryStage == DELIVERY_LOADING && newkeys == KEY_FIRE) 
    {
        // Clan mafije koja vrsi dostavu, pritisnuo levi klik, u toku je faza utovara
        if (GetPVarInt(playerid, "pDeliveryStatus") == DELIVERY_CARRYING_CRATE) 
        {
            // Nosi kutiju u rukama. Da li je iza kombija?
            new Float:pos[3];
            GetPosBehindVehicle(deliveryVehicle, pos[POS_X], pos[POS_Y], pos[POS_Z]);
            if (IsPlayerInRangeOfPoint(playerid, 3.5, pos[POS_X], pos[POS_Y], pos[POS_Z]) && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY) 
            {
                GetVehiclePos(deliveryVehicle, pos[POS_X], pos[POS_Y], pos[POS_Z]);
                if (IsPlayerFacingPoint(playerid, pos[POS_X], pos[POS_Y], 200.0)) 
                {
                    // Nalazi se iza kombija i nosi kutiju u rukama
                    ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0);
                    SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_LIFT_TIMER);
                    SetTimerEx("delivery_loadingPutDown", 1000, false, "i", playerid);
                }
                return ~1;
            }

            return ~1;
        }


        // Ne nosi kutiju u rukama. Da li je blizu neke kutije da moze da je podigne?
        if (GetPVarInt(playerid, "pDeliveryStatus") <= 0)
        {
            new i = delivery_GetClosestCreate(playerid);
            if (i != -1) 
            {
                for__loop (new Float:ang = 10.0; ang < 360.0; ang+=5.0) 
                {
                    if (IsPlayerFacingPoint(playerid, deliveryCrates[i][POS_X], deliveryCrates[i][POS_Y], ang)) 
                    {
                        break;
                    }
                }


                if (IsPlayerFacingPoint(playerid, deliveryCrates[i][POS_X], deliveryCrates[i][POS_Y], 355.0)) 
                {
                    if (deliveryCrates[i][POS_Z] < 76.0) // Kutija na donjoj polici
                        ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);

                    else // Kutija na gornjoj polici
                        ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);


                    SetTimerEx("delivery_loadingLiftUp", 1000, false, "i", playerid);
                    SetPVarInt(playerid, "pDeliveryObjectInd", i);
                    SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_LIFT_TIMER);
                    Iter_Remove(iDeliveryCrates, i);
                }
                return ~1;
            }
        }
    }


    // ----------- ISTOVAR -----------
    if (PI[playerid][p_org_id] == weaponDelivery && deliveryStage == DELIVERY_UNLOADING && newkeys == KEY_FIRE) 
    {
        // Clan mafije koja vrsi dostavu, pritisnuo levi klik, u toku je faza istovara
        if (GetPVarInt(playerid, "pDeliveryStatus") == DELIVERY_CARRYING_CRATE) // Nosi kutiju u rukama. Da li je na pickupu?
        {
            if (IsPlayerInRangeOfPoint(playerid, 4.0, deliveryUnloadPos[POS_X], deliveryUnloadPos[POS_Y], deliveryUnloadPos[POS_Z])) 
            {
                ApplyAnimation(playerid, "CARRY", "putdwn", 4.1, 0, 0, 0, 0, 0);
                SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_LIFT_TIMER);
                SetTimerEx("delivery_unloadingPutDown", 1000, false, "i", playerid);
            }
            return ~1;
        }


        // Ne nosi kutiju u rukama. Da li je iza kamiona?
        if (GetPVarInt(playerid, "pDeliveryStatus") <= 0)
        {
            new Float:pos[3];
            GetPosBehindVehicle(deliveryVehicle, pos[POS_X], pos[POS_Y], pos[POS_Z]);
            if (IsPlayerInRangeOfPoint(playerid, 3.5, pos[POS_X], pos[POS_Y], pos[POS_Z]) && GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_CARRY) 
            {
                GetVehiclePos(deliveryVehicle, pos[POS_X], pos[POS_Y], pos[POS_Z]);
                if (IsPlayerFacingPoint(playerid, pos[POS_X], pos[POS_Y])) 
                {
                    ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0);
                    SetTimerEx("delivery_unloadingLiftUp", 1000, false, "i", playerid);
                    SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_LIFT_TIMER);
                }
                return ~1;
            }
        }
    }
    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (deliveryStage == DELIVERY_ENTERING_PIN) 
    {
        if (strlen(deliveryInput) < 4) 
        {
            for__loop (new i = 0; i <= 9; i++) 
            {
                if (playertextid == PlayerTD[playerid][ptdPadNum][i]) 
                {
                    new num[2];
                    valstr(num, i);
                    strins(deliveryInput, num, strlen(deliveryInput));
                    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], deliveryInput);
                    return ~1;
                }
            }
        }

        if (playertextid == PlayerTD[playerid][ptdKeypad][10]) 
        {
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], "");
            deliveryInput[0] = EOS;
            return ~1;
        }

        if (playertextid == PlayerTD[playerid][ptdKeypad][12]) 
        {
            new enteredPin = strval(deliveryInput);

            if (enteredPin != deliveryCode) { // Uneo pogresan kod
                ErrorMsg(playerid, "Uneli ste pogresan kod!");
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdKeypad][14], "");
                deliveryInput[0] = EOS;
            }

            else // Uspesno!
            {
                InfoMsg(playerid, "Uneli ste tacan kod.");
                ptdKeypad_Destroy(playerid);
                CancelSelectTextDraw(playerid);
                deliveryLoadMax = Iter_Count(iDeliveryCrates);
                deliveryLoadedCount = 0;

                MoveDynamicObject(deliveryDoors, -1111.765136, -1623.620971, 75.355502, 0.005, 0.0, 0.0, 90.0);

                new str[22];
                format(str, sizeof str, "KUTIJE:      %02i/%02i", deliveryLoadedCount, deliveryLoadMax);
                TextDrawSetString(tdMaterialsDelivery[WD_COUNTER], str);

                foreach (new i : Player) 
                {
                    if (PI[i][p_org_id] == weaponDelivery && IsPlayerInRangeOfPoint(i, 40.0, -1093.9786, -1623.2445, 76.3672)) 
                    {
                        SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Utovarite sve kutije sa materijalima u kombi!");
                        TextDrawShowForPlayer(playerid, tdMaterialsDelivery[WD_COUNTER]);
                    }
                }

                deliveryStage = DELIVERY_LOADING;
                // KillTimer(tajmer:delivery_TimeUp), tajmer:delivery_TimeUp = 0;
                // TextDrawHideForAll(tdMaterialsDelivery[WD_TIMER]);

                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, 1, objective);
            }
        }
        return ~1;
    }
    return 0;
}

// TODO omoguciti da se kombi zapali i eksplodira, nakon toga stopirati dostavu




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward deliveryCallReject(playerid, ccinc);
public deliveryCallReject(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("deliveryCallReject");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    deliveryTime += 5;

    if (deliveryTime >= 25) // Veza nije uspostavljena, prekini poziv
    {
        phone_animation(playerid, false);
        SendClientMessage(playerid, ZUTA, "(mobilni) {FF6347}Veza nije uspostavljena.");

        new timerid = GetPVarInt(playerid, "timer_deliveryCall");
        DeletePVar(playerid, "timer_deliveryCall");
        KillTimer(timerid);
         
        SetTimerEx("deliverySMS", 10000+random(10000), false, "ii", playerid, cinc[playerid]);
    }
    return 1;
}

forward deliverySMS(playerid, ccinc);
public deliverySMS(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("deliverySMS");
    }

    if (!checkcinc(playerid, ccinc)) return 1;


    SendClientMessage(playerid, ZUTA, "(sms) {FFFFFF}Primili ste novu poruku sa broja {F5DEB3}069/666-999.");

    if (!IsWeaponDeliveryActive()) 
    {
        if (FACTIONS[ PI[playerid][p_org_id] ][f_materijali_skladiste] < 1000)
            return SendClientMessage(playerid, ZUTA, " * Poruka: {FFFFFF}Nemam dovoljno robe za tebe!");

        // Sledece parce koda se koristi i u OnPlayerStateChange()
        // Ovo je alternativa tom kodu, za slucaj da je igrac vec unutar kombija.
        new vehicleid = GetPlayerVehicleID(playerid);
        if (vehicleid != INVALID_VEHICLE_ID && GetVehicleModel(vehicleid) == DELIVERY_VEH_MODEL && IsFactionVehicle(vehicleid, weaponDelivery)) 
        { 
            deliveryVehicle = vehicleid;
            SetVehicleHealth(vehicleid, 2500.0);
            printf("u burritu je");
            deliveryKeypadCP = CreatePlayerCP(-1111.3523, -1621.8158, 76.4072, 1.0, 0, 0, playerid, 6000.0);
        }
        else
            return ErrorMsg(playerid, "Niste u kombiju predvidjenom za prijevoz materijala (Burrito).");

        new poruke[][] = 
        {
            "Spremio sam ti pakete koje smo dogovorili. Dodji po njih, imas 15 minuta.",
            "Kutije te cekaju kod mene kuci. Tu sam jos 15 minuta, pozuri!",
            "Sve sam ti spremio, dodji za 15 minuta.",
            "Igracke, zar ne? Cekaju te, imas 15 minuta da dodjes."
        };

        SendClientMessageF(playerid, ZUTA, " * Poruka: {FFFFFF}%s", poruke[random(sizeof poruke)]);

        TextDrawSetString(tdMaterialsDelivery[WD_TIMER], "VREME:      30:00");
        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == PI[playerid][p_org_id])
            {
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Odvezite se kombijem na oznacenu lokaciju i preuzmite robu.");
                TextDrawShowForPlayer(playerid, tdMaterialsDelivery[WD_TIMER]);
            }
        }
        deliveryInitiator = playerid;
        weaponDelivery = PI[playerid][p_org_id];
        // SetTimerEx("deliverySMSCode", (3+random(3))*60*1000, false, "iii", playerid, weaponDelivery, cinc[playerid]);
        SetTimerEx("deliverySMSCode", 3000, false, "iii", playerid, weaponDelivery, cinc[playerid]);

        deliveryStage = DELIVERY_WAITING_PIN;


        // Pokretanje 30-minutnog tajmera
        deliveryTimer = 30*60;
        tajmer:delivery_TimeUp = SetTimer("delivery_TimeUp", 1000, true);
    }
    else {
        new poruke[][] = 
        {
            "Ne mogu sada da se javim.",
            "Imam posla preko glave, zovi me kasnije.",
            "Trenutno sam zauzet, zovi me kasnije.",
            "Nisam uspeo nista da ti nabavim.",
            "Nisam isao u nabavku."
        };
        SendClientMessageF(playerid, ZUTA, " * Poruka: {FFFFFF}%s", poruke[random(sizeof poruke)]);
    }
    return 1;
}

forward deliverySMSCode(playerid, f_id, ccinc);
public deliverySMSCode(playerid, f_id, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("deliverySMSCode");
    }

    if (weaponDelivery == -1) return 1;

    deliveryCode = 1000 + random(8999);

    if (!checkcinc(playerid, ccinc)) // Igrac koji je inicirao je napustio igru, posalji kod svima u org
    {
        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
            {
                SendClientMessage(i, ZUTA, "(sms) {FFFFFF}Primili ste novu poruku sa broja {F5DEB3}069/666-999.");
                SendClientMessageF(i, ZUTA, " * Poruka: {FFFFFF}Sifra za ulazak u skladiste je {F5DEB3}%i", deliveryCode);
            }
        }
    }
    else // Posalji inicijatoru
    {
        SendClientMessage(playerid, ZUTA, "(sms) {FFFFFF}Primili ste novu poruku sa broja {F5DEB3}069/666-999.");
        SendClientMessageF(playerid, ZUTA, " * Poruka: {FFFFFF}Sifra za ulazak u skladiste je {F5DEB3}%i", deliveryCode);
    }
    deliveryStage = DELIVERY_TRAVELING;
    return 1;
}

forward delivery_loadingLiftUp(playerid);
public delivery_loadingLiftUp(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("delivery_loadingLiftUp");
    }

    new ind = GetPVarInt(playerid, "pDeliveryObjectInd");

    if (IsValidDynamicObject(weaponDeliveryCrate[ind]))
    {
        DestroyDynamicObject(weaponDeliveryCrate[ind]);
    }
    weaponDeliveryCrate[ind] = -1;
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, 9, 3052, 5, 0.040000, 0.138999, 0.170000, 92.899894, 168.199951, -68.600013);

    SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_CARRYING_CRATE);
    DeletePVar(playerid, "pDeliveryObjectInd");
    SetVehicleParamsForPlayer(deliveryVehicle, playerid, 1, 0);
    return 1;
}

forward delivery_loadingPutDown(playerid);
public delivery_loadingPutDown(playerid) 
{
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 9);

    DeletePVar(playerid, "pDeliveryStatus");
    SetVehicleParamsForPlayer(deliveryVehicle, playerid, 0, 0);

    new str[22];
    format(str, sizeof str, "KUTIJE:      %02i/%02i", ++deliveryLoadedCount, deliveryLoadMax);
    TextDrawSetString(tdMaterialsDelivery[WD_COUNTER], str);


    // Da li je utovarena poslednja kutija?
    // if (Iter_Count(iDeliveryCrates) == 0) {
    if (deliveryLoadedCount == deliveryLoadMax) 
    {
        // Da vidimo kolika kolicina je utovarena...
        // Max. za prevoz materijala je 5000
        if (FACTIONS[weaponDelivery][f_materijali_skladiste] > 15000)
        {
            weaponDelivery_Mats = 15000;
            FACTIONS[weaponDelivery][f_materijali_skladiste] -= weaponDelivery_Mats;
        }
        else
        {
            weaponDelivery_Mats = FACTIONS[weaponDelivery][f_materijali_skladiste];
            FACTIONS[weaponDelivery][f_materijali_skladiste] = 0;
        }



        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
            {
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Utovarene su sve kutije. Postarajte se da kombi stigne bezbedno do baze!");
                SendClientMessageF(i, SVETLOCRVENA, "** Utovareno je %.1f kg materijala.", weaponDelivery_Mats/1000.0);
                GameTextForPlayer(i, "~g~] SVE KUTIJE UTOVARENE ]", 8000, 3);

                deliveryUnloadLifted = 0;
            }
        }

        deliveryStage = DELIVERY_GOING_BACK;
        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, 0, 0);

        SetTimer("delivery_restoreWarehouse", 90*1000, false); // Zatvara vrata i vraca kutije


        new player;
        if (deliveryInitiator == -1) player = playerid;
        else player = deliveryInitiator;


        // Ako se menjaju ID-evi/koordinate, promeniti i na OnPlayerStateChange
        if (weaponDelivery == 1) // EC
            deliveryUnloadPos = Float:{-703.8419,961.2007,12.1640};

        else if (weaponDelivery == 2) // weg
            deliveryUnloadPos = Float:{921.3898,-2632.1860,42.0328};

        else if (weaponDelivery == 3) // lcdp
            deliveryUnloadPos = Float:{2336.9263,36.7384,26.1412};

        else if (weaponDelivery == 4) // pp
            deliveryUnloadPos = Float:{864.2454,-1064.2881,24.7597};

        else if (weaponDelivery == 5) // LSB
            deliveryUnloadPos = Float:{2245.8152, -1452.4911, 23.3815};

        else if (weaponDelivery == 6) // GSF
            deliveryUnloadPos = Float:{2515.5186, -1672.4338, 13.3099};

        else if (weaponDelivery == 7) // ms13
            deliveryUnloadPos = Float:{2508.4531,-2009.7021,12.9425};

        else if (weaponDelivery == 8) // AM
            deliveryUnloadPos = Float:{976.7514,-1949.1141,12.6541};

        else if (weaponDelivery == 9) // LCN
            deliveryUnloadPos = Float:{1087.1947, -1999.9484, 48.9232};

        else if (weaponDelivery == 10) // SB
            deliveryUnloadPos = Float:{1298.4980, -798.9592, 84.1406};
        
        /*if (weaponDelivery == 2) // WTM
            deliveryUnloadPos = Float:{978.2645, -1438.7708, 13.6790};
        
        else if (weaponDelivery == 3) // LCN
            deliveryUnloadPos = Float:{1087.1947, -1999.9484, 48.9232};

        else if (weaponDelivery == 4) // SB
            deliveryUnloadPos = Float:{1298.4980, -798.9592, 84.1406};

        else if (weaponDelivery == 5) // GSF
            deliveryUnloadPos = Float:{2515.5186, -1672.4338, 13.3099};

        else if (weaponDelivery == 7) // LSV
            deliveryUnloadPos = Float:{2569.8452,-1119.7156,65.0201};

        else if (weaponDelivery == 8) // ZK
            deliveryUnloadPos = Float:{-58.0541,-224.1546,5.4297};

        else if (weaponDelivery == 10) // GN/VLA
            deliveryUnloadPos = Float:{2153.0693,-2288.3613,13.3614};

        else if (weaponDelivery == 11) // LS
            deliveryUnloadPos = Float:{1672.5951,-2087.0024,13.5543};

        else if (weaponDelivery == 12) // MS13
            deliveryUnloadPos = Float:{2458.5178,-1968.3217,13.5086};

        else if (weaponDelivery == 13) // TSF
            deliveryUnloadPos = Float:{916.3652,-614.6505,114.7290};*/

        else 
            return FactionMsg(weaponDelivery, GRESKA_NEPOZNATO);
        
        
        deliveryUnloadCP = CreatePlayerCP(deliveryUnloadPos[POS_X], deliveryUnloadPos[POS_Y], deliveryUnloadPos[POS_Z], 5.0, 0, 0, player, 6000.0);
    }
    return 1;
}

forward delivery_unloadingLiftUp(playerid);
public delivery_unloadingLiftUp(playerid) 
{
    if (deliveryUnloadLifted >= deliveryUnloadMax)
        return ErrorMsg(playerid, "Kombi je prazan.");

    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
    SetPlayerAttachedObject(playerid, 9, 3052, 5, 0.040000, 0.138999, 0.170000, 92.899894, 168.199951, -68.600013);

    SetPVarInt(playerid, "pDeliveryStatus", DELIVERY_CARRYING_CRATE);

    deliveryUnloadLifted += 1;
    return 1;
}

forward delivery_unloadingPutDown(playerid);
public delivery_unloadingPutDown(playerid) 
{
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
    RemovePlayerAttachedObject(playerid, 9);

    DeletePVar(playerid, "pDeliveryStatus");
    SetVehicleParamsForPlayer(deliveryVehicle, playerid, 1, 0);

    new str[22];
    format(str, sizeof str, "KUTIJE:      %02i/%02i", ++deliveryUnloadedCount, deliveryUnloadMax);
    TextDrawSetString(tdMaterialsDelivery[WD_COUNTER], str);


    // Da li je utovarena poslednja kutija?
    if (deliveryUnloadedCount >= deliveryUnloadMax) 
    {
        new gtStr[57];
        format(gtStr, sizeof gtStr, "~g~] SVE KUTIJE ISTOVARENE ]~n~~h~+%.1f kg materijala", weaponDelivery_Mats/1000.0);

        new Float:x,Float:y,Float:z,
            totalRanks = 0;
        GetPlayerPos(playerid, x, y, z);
        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
            {
                // Ako se menja kolicina materijala, promeniti i dole "+= 1600" (za materijale) i "+=800" za metke
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Istovarene su sve kutije.");
                GameTextForPlayer(i, gtStr, 8000, 3);

                if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z))
                {
                    PlayerUpdateCriminalSkill(i, 2, SKILL_DELIVERY, 0);
                    totalRanks += PI[i][p_org_rank];
                }
            }
        }

        if (IsAGangster(playerid))
        {
            // Clanovi bandi dobijaju materijale direktno u ranac

            foreach (new i : Player) 
            {
                if (PI[i][p_org_id] == weaponDelivery) 
                {
                    if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z))
                    {
                        new matsAdd = floatround(weaponDelivery_Mats/totalRanks * (PI[i][p_org_rank]*1.0));
                        SendClientMessageF(i, BELA, "* Vi ste rank %i. Dobili ste ste {00FF00}%.1f kg {FFFFFF}obradjenih materijala.", PI[i][p_org_rank], matsAdd/1000.0);

                        BP_PlayerItemAdd(playerid, ITEM_MATERIALS, matsAdd);
                    }
                }
            }
        }
        else
        {
            // Clanovi mafija dobijaju materijale u sef
            
            FACTIONS[weaponDelivery][f_materijali] += weaponDelivery_Mats;
        }


        new engine, lights, alarm, doors, bonnet, boot, objective, Float:vehHp;
        GetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, boot, objective);
        SetVehicleParamsEx(deliveryVehicle, engine, lights, alarm, doors, bonnet, 0, 0);
        SetVehicleParamsForPlayer(deliveryVehicle, deliveryInitiator, 0, 0);

        GetVehicleHealth(deliveryVehicle, vehHp);
        if (vehHp > 999.0) SetVehicleHealth(deliveryVehicle, 999.0);


        new sQuery[89];
        format(sQuery, sizeof sQuery, "UPDATE factions SET materijali = %i, materijali_skladiste = %i WHERE id = %i", FACTIONS[weaponDelivery][f_materijali], FACTIONS[weaponDelivery][f_materijali_skladiste], weaponDelivery);
        mysql_tquery(SQL, sQuery);

        delivery_Reset();
    }
    return 1;
}

forward delivery_restoreWarehouse();
public delivery_restoreWarehouse() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("delivery_restoreWarehouse");
    }

    MoveDynamicObject(deliveryDoors, -1111.765136, -1623.620971, 75.350502, 0.005, 0.0, 0.0, 180.0);

    // Kreiranje kutija
    if (Iter_Count(iDeliveryCrates) != 0) 
    {
        // Nisu unisteni svi objekti kutija. Unistiti one koje su preostale, a zatim cemo ih sve rekreirati
        foreach (new i : iDeliveryCrates) 
        {
            DestroyDynamicObject(weaponDeliveryCrate[i]);
            weaponDeliveryCrate[i] = -1;
            Iter_Remove(iDeliveryCrates, i);
        }
    }

    for__loop (new i = 0; i < DELIVERY_NUM_CRATES; i++) 
    {
        weaponDeliveryCrate[i] = CreateDynamicObjectEx(3052, deliveryCrates[i][0], deliveryCrates[i][1], deliveryCrates[i][2], 0.0, 0.0, deliveryCrates[i][3], 300.0, 300.0);
        Iter_Add(iDeliveryCrates, i);
    }

    return 1;
}

forward delivery_TimeUp();
public delivery_TimeUp() 
{    
    if (DebugFunctions())
    {
        LogFunctionExec("delivery_TimeUp");
    }

    if (weaponDelivery == -1) 
    {
        KillTimer(tajmer:delivery_TimeUp);
        return 1;
    }

    deliveryTimer -= 1;
    if (deliveryTimer < 15*60 && deliveryStage < DELIVERY_LOADING) 
    {
        // Mafija nije uspela za 15 minuta da dodje do skladista i unese pin.

        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Isteklo je vreme za ulazak u skladiste sa materijalima. Sledeci put budite brzi!");
        }

        if (deliveryInitiator != -1) 
        {
            SendClientMessage(deliveryInitiator, ZUTA, "(sms) {FFFFFF}Primili ste novu poruku sa broja {F5DEB3}069/666-999.");
            SendClientMessage(deliveryInitiator, ZUTA, " * Poruka: {FFFFFF}Zakasnio si, nista od isporuke ovog puta.");
        }

        delivery_Reset(); // Tu je i KillTimer
        TextDrawHideForAll(tdMaterialsDelivery[WD_TIMER]);
        TextDrawHideForAll(tdMaterialsDelivery[WD_COUNTER]);

        if (deliveryStage == DELIVERY_ENTERING_PIN) 
        {
            // TODO: unistiti keypad onome ko kuca
        }
        return 1;
    }

    if (deliveryTimer == -1) 
    {
        // Materijali su preuzeti, ali nisu dostavljeni na vreme

        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
                SendClientMessage(i, TAMNOCRVENA, "(dostava) {FFFFFF}Isteklo je vreme za istovar materijala. Sledeci put budite brzi!");
        }

        delivery_Reset(); // Tu je i KillTimer
        return 1;
    }

    new vremeStr[18];
    format(vremeStr, sizeof vremeStr, "VREME:      %s", konvertuj_vreme(deliveryTimer));
    TextDrawSetString(tdMaterialsDelivery[WD_TIMER], vremeStr);
    return 1;
}

stock delivery_Reset() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("delivery_Reset");
    }

    if (weaponDelivery != -1) 
    {
        // Uklanjanje attached objekata u slucaju da neki igrac nosi kutiju
        foreach (new i : Player) 
        {
            if (PI[i][p_org_id] == weaponDelivery) 
            {
                if (IsPlayerAttachedObjectSlotUsed(i, 9) && GetPlayerSpecialAction(i) == SPECIAL_ACTION_CARRY) 
                {
                    RemovePlayerAttachedObject(i, 9);
                    SetPlayerSpecialAction(i, SPECIAL_ACTION_NONE);
                }
            }
        }
    }
    weaponDelivery = deliveryInitiator = deliveryVehicle = deliveryCode = deliveryStage = -1;
    weaponDelivery_Mats = 0;
    deliveryInput[0] = EOS;
    KillTimer(tajmer:delivery_TimeUp);

    if (deliveryUnloadPickup != -1)
        DestroyDynamicPickup(deliveryUnloadPickup), deliveryUnloadPickup = -1;

    if (deliveryUnloadCP != -1)
        DestroyDynamicCP(deliveryUnloadCP), deliveryUnloadCP = -1;

    if (deliveryKeypadCP != -1)
        DestroyDynamicCP(deliveryKeypadCP), deliveryKeypadCP = -1;

    TextDrawHideForAll(tdMaterialsDelivery[0]);
    TextDrawHideForAll(tdMaterialsDelivery[1]);

    delivery_restoreWarehouse();
}

stock IsWeaponDeliveryActive() 
{
    if (weaponDelivery == -1) return 0;
    return 1;
}

stock delivery_GetClosestCreate(playerid) 
{
    GetPlayerPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]);

    new closestCrate = -1, Float:minDistance = 999999.0;
    foreach (new i : iDeliveryCrates) 
    {
        new Float:dist = GetDistanceBetweenPoints(pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z], deliveryCrates[i][POS_X], deliveryCrates[i][POS_Y], deliveryCrates[i][POS_Z]);

        if (dist < minDistance) 
        {
            minDistance = dist;
            closestCrate = i;
        }
    }

    if (minDistance <= 2.5) // Vraca validan ID samo ako je igrac zaista blizu neke kutije
        return closestCrate;
    else
        return -1;
}

stock IsMatsDeliveryVehicle(vehicleid)
{
    if (deliveryVehicle > 0)
    {
        if (vehicleid == deliveryVehicle)
        {
            return 1;
        }
    }
    return 0;
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
CMD:weapondelivery1(playerid, const params[]) 
{
    if ((!IsACriminal(playerid)) || PI[playerid][p_org_rank] < 4)
        return ErrorMsg(playerid, "Nemate dozvolu da pozovete ovaj broj (rank 4+).");

    if (!IsPlayerInDynamicArea(playerid, AreaLS)) // TODO napraviti jednu malo manju zonu od ove
        return ErrorMsg(playerid, "Nedostupno. Ovaj broj mozete pozvati iskljucivo iz Los Santosa.");

    if (IsWarActive())
        return ErrorMsg(playerid, "Nedostupno za vreme war-a.");

    format(string_64, 64, "** %s vadi mobilni telefon.", ime_rp[playerid]);
    RangeMsg(playerid, string_64, LJUBICASTA, 10.0);

    SendClientMessage(playerid, ZUTA, "(mobilni) {FFFFFF}Veza se uspostavlja...");
    deliveryTime = 5;
    SetPVarInt(playerid, "timer_deliveryCall", SetTimerEx("deliveryCallReject", 5*1000, true, "ii", playerid, cinc[playerid]));

    phone_animation(playerid, true);

    // TODO: dodati obavestenje za sve ostale maf/bande
    return 1;
}