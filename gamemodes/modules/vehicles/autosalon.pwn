#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PAGE_MAX_ITEMS (15) // Max 15 vozila po strani




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum e_autosalonVozila
{
    as_modelid,
    as_price,
    as_stock,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new tempVehicle[MAX_PLAYERS];
new bool:autosalon_napunjen;

new listCars[79][e_autosalonVozila] = 
{
    {410, 38000, 0}, // Manana (129)
    {404, 44000, 0}, // Perennial (132)
    {479, 52000, 0}, // Regina (139)
    {413, 56000, 0}, // Pony (109)
    {418, 61000, 0}, // Moonbeam (115)
    {467, 68000, 0}, // Oceanic (139)
    {547, 87000, 0}, // Primo (142)
    {466, 90000, 0}, // Glendale (146)
    {546, 90000, 0}, // Intruder (148)
    {401, 90000, 0}, // Bravura (146)
    {436, 91000, 0}, // Previon (148)
    {482, 93500, 0}, // Burrito ()
    {527, 94000, 0}, // Cadrona (148)
    {529, 94000, 0}, // Willard (148)
    {474, 96000, 0}, // Hermes (148)
    {561, 100000, 0}, // Stratum (153)
    {600, 110000, 0}, // Picador (150)
    {543, 114500, 0}, // Sadler (150)
    {421, 120000, 0}, // Washington (153)
    {549, 122450, 0}, // Tampa (152)
    {458, 130000, 0}, // Solair (156)
    {551, 138000, 0}, // Merit (156)
    {517, 140000, 0}, // Majestic (156)
    {540, 140000, 0}, // Vincent (148)
    {492, 144000, 0}, // Greenwood (139)
    {405, 152000, 0}, // Sentinel (163)
    {516, 160000, 0}, // Nebula (156)
    {585, 160000, 0}, // Emperor (152)
    {542, 164000, 0}, // Clover (163)
    {439, 176000, 0}, // Stallion (167)
    {496, 180000, 0}, // Blista Compact (162)
    {558, 186000, 0}, // Uranus (155)
    {526, 188000, 0}, // Fortune (157)
    {518, 200000, 0}, // Buccaneer (160)
    {422, 200000, 0}, // Bobcat (139)
    {491, 240000, 0}, // Virgo (148)
    {536, 260000, 0}, // Blade (172)
    {554, 300000, 0}, // Yosemite (143)
    {575, 340000, 0}, // Broadway (157)
    {412, 340000, 0}, // Voodoo (167)
    {500, 360000, 0}, // Mesa (140)
    {550, 360000, 0}, // Sunrise (144)
    {508, 375000, 0}, // Journey 
    {419, 380000, 0}, // Esperanto (148)
    {566, 380000, 0}, // Tahoma (159)
    {424, 400000, 0}, // BF Injection (134)
    {400, 400000, 0}, // Landstalker (157)
    {475, 450000, 0}, // Sabre (172)
    {567, 480000, 0}, // Savanna (172)
    {580, 540000, 0}, // Stafford (152)
    {507, 620000, 0}, // Elegant (165)
    {545, 654000, 0}, // Hustler (146)
    {555, 680000, 0}, // Windsor (157)
    {445, 725000, 0}, // Admiral (163)
    {587, 772000, 0}, // Euros (164)
    {602, 800000, 0}, // Alpha (168)
    {426, 940000, 0}, // Premier (172)
    {489, 960000, 0}, // Rancher (139)
    {402, 1000000, 0}, // Buffalo (185)
    {589, 1040000, 0}, // Club (162)
    {565, 1060000, 0}, // Flash (164)
    {470, 1200000, 0}, // Patriot (156)
    {559, 1220000, 0}, // Jester (177)
    {562, 1220000, 0}, // Elegy (177)
    {534, 1240000, 0}, // Remington (167)
    {533, 1320000, 0}, // Feltzer (166)
    {579, 1400000, 0}, // Huntley (157)
    {480, 1500000, 0}, // Comet (183)
    {477, 1600000, 0}, // ZR-350 (185)
    {535, 1700000, 0}, // Slamvan (157)
    {409, 1900000, 0}, // Stretch (157)
    {415, 2100000, 0}, // Cheetah (191)
    {506, 2200000, 0}, // Super GT (178)
    {495, 2300000, 0}, // Sandking (175)
    {451, 2400000, 0}, // Turismo (192)
    {560, 2500000, 0}, // Sultan (168)
    {429, 2600000, 0}, // Banshee (200)
    {541, 3000000, 0}, // Bullet (202)
    {411, 3700000, 0} // Infernus (220)
};

new listMotorbikes[9][e_autosalonVozila] = {
    {462, 27600, 0}, // Faggio
    {581, 70000, 0}, // BF-400
    {461, 220000, 0}, // PCJ-600
    {586, 360000, 0}, // Wayfarer
    {463, 440000, 0}, // Freeway
    {471, 630000, 0}, // Quad
    {521, 850000, 0}, // FCR-900
    {468, 1240000, 0}, // Sanchez
    {522, 2000000, 0} // NRG-500
};
 
new listBicycles[3][e_autosalonVozila] = {
    {509, 6000, 0}, // Bike
    {481, 10000, 0}, // BMX
    {510, 15000, 0} // Mt. Bike
};
 
new listHelicopters[4][e_autosalonVozila] = {
    {469, 450000, 0}, // Sparrow
    {417, 900000, 0}, // Leviathan
    {563, 1800000, 0}, // Raindance
    {487, 3600000, 0} // Maverick
};
 
new listBoats[9][e_autosalonVozila] = {
    {473, 500000, 0},  // Dinghy
    {472, 800000, 0}, // Coastguard
    {595, 1000000, 0}, // Launch
    {484, 1200000, 0}, // Marquis
    {453, 1500000, 0}, // Reefer
    {493, 2400000, 0}, // Jetmax
    {446, 3100000, 0}, // Squallo
    {452, 4200000, 0}, // Speeder
    {454, 4800000, 0} // Tropic
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{

    //Usrana vozila ovde a ne u mape mater ti jebem skriptersku glupavu by Zile
    // Tek sad vidim ovaj komentar, hahahahah hejj moj Hoxxy xD
    new salonvehid;
    salonvehid = AddStaticVehicleEx(451,952.179,-1741.427,13.782,88.541,1,0,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(536,949.578,-1749.357,13.843,54.155,1,1,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(500,950.737,-1733.712,14.208,114.569,1,0,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(481,945.528,-1751.680,18.714,359.785,1,0,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(510,947.019,-1751.739,18.808,359.870,1,0,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(522,946.454,-1711.416,18.765,89.032,1,1,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(471,946.552,-1717.419,18.676,87.823,1,3,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    salonvehid = AddStaticVehicleEx(521,946.337,-1714.412,18.763,89.381,1,0,-1,false);
    SetVehicleParamsEx(salonvehid, 0, 0, 0, 1, 0, 0, 0);
    
    autosalon_napunjen = false;

    CreateDynamic3DTextLabel("{FF9900}[ Auto salon ]\n{FFFFFF}Za kupovinu vozila upisite {FF9900}/katalog", BELA, 940.4893, -1707.6216, 13.6153, 20.0);
    CreateDynamic3DTextLabel("{FF9900}[ Auto salon ]\n{FFFFFF}Za kupovinu vozila upisite {FF9900}/katalog", BELA, 940.5649, -1739.6978, 19.1936, 20.0);
    //Create3DTextLabel("{FF9900}[ Auto salon ]\n{FFFFFF}Za kupovinu vozila upisite {FF9900}/katalog", BELA, 1781.4856, -1694.6372, 13.5492, 20.0, 0, 1); //1781.4856, -1694.6372, 13.5492
    //Create3DTextLabel("{FF9900}[ Auto salon ]\n{FFFFFF}Za kupovinu vozila upisite {FF9900}/katalog", BELA, 940.5649, -1739.6978, 19.1936, 20.0, 0, 1);
    //Create3DTextLabel("{FF9900}[ Auto salon ]\n{FFFFFF}Za kupovinu vozila upisite {FF9900}/katalog", BELA, 2053.4058, -1904.9049, 13.5608, 20.0, 0, 1); // Kucna vozila

    CreateDynamicActor(17, 940.2964, -1751.1726, 13.6487, 0.0); // Pult za automobile
    CreateDynamicActor(17, 953.1270,-1748.7156,19.1936,98.1177); // Pult za helikoptere
    CreateDynamicActor(17, 953.4505,-1735.3542,19.1936,90.0); // Pult za brodove
    CreateDynamicActor(17, 940.8868,-1751.1667,19.1936,0.0); // Pult za bicikle
    CreateDynamicActor(17, 943.4727,-1701.7102,19.1936,175.5352); // Pult za motore

    mysql_tquery(SQL, "SELECT * FROM vozila_stock", "LoadDealershipStock");
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    tempVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    if (tempVehicle[playerid] != INVALID_VEHICLE_ID)
        DestroyVehicle(tempVehicle[playerid]), tempVehicle[playerid] = INVALID_VEHICLE_ID;

    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {

    if (GetPVarInt(playerid, "pAutosalon") == 1) // Izbor kategorije vozila
    {

        if (playertextid == PlayerTD[playerid][ptdKatalog][7] || playertextid == PlayerTD[playerid][ptdKatalog][12]) 
        { // Automobili
            ptdKatalog_Destroy(playerid);
            autosalon_ShowPage(playerid, 1, automobil);
        }
        
        else if (playertextid == PlayerTD[playerid][ptdKatalog][8] || playertextid == PlayerTD[playerid][ptdKatalog][13]) 
        { // Motori
            ptdKatalog_Destroy(playerid);
            autosalon_ShowPage(playerid, 1, motor);
        }
        
        else if (playertextid == PlayerTD[playerid][ptdKatalog][9] || playertextid == PlayerTD[playerid][ptdKatalog][14]) 
        { // Bicikle
            ptdKatalog_Destroy(playerid);
            autosalon_ShowPage(playerid, 1, bicikl);
        }
        
        else if (playertextid == PlayerTD[playerid][ptdKatalog][10] || playertextid == PlayerTD[playerid][ptdKatalog][15]) 
        { // Helikopteri
            ptdKatalog_Destroy(playerid);
            autosalon_ShowPage(playerid, 1, helikopter);
        }
        
        else if (playertextid == PlayerTD[playerid][ptdKatalog][11] || playertextid == PlayerTD[playerid][ptdKatalog][16]) 
        { // Brodovi
            ptdKatalog_Destroy(playerid);
            autosalon_ShowPage(playerid, 1, brod);
        }

        else if (playertextid == PlayerTD[playerid][ptdKatalog][17]) // Izlaz
        {
            katalog_Cancel(playerid);
        }
        return ~1;
    }

    else if (GetPVarInt(playerid, "pAutosalon") == 2) // Izbor vozila
    {

        if (playertextid == PlayerTD[playerid][ptdAutosalon][78]) // Prethodna strana
        {
            autosalon_ShowPage(playerid, GetPVarInt(playerid, "pAutosalonPage")-1, GetPVarInt(playerid, "pAutosalonCat"));
        }

        else if (playertextid == PlayerTD[playerid][ptdAutosalon][79]) // Sledeca strana
        {
            autosalon_ShowPage(playerid, GetPVarInt(playerid, "pAutosalonPage")+1, GetPVarInt(playerid, "pAutosalonCat"));
        }

        else if (playertextid == PlayerTD[playerid][ptdAutosalon][80]) // Kupi vozilo
        {
            if (GetPVarInt(playerid, "pAutosalonSlot") == -1)
                return ErrorMsg(playerid, "Nemate slobodne slotove za kupovinu novih vozila.");

            if (AUTOSALON_CheckStock(GetPVarInt(playerid, "pAutosalonModel")) <= 0 && !AUTOSALON_IsStockUnlimited())
                return ErrorMsg(playerid, "Ovo vozilo je nazalost rasprodato. Morate sacekati da head admin dopuni vozila.");

            ptdAutosalon_Hide(playerid);
            // CancelSelectTextDraw(playerid);


            // Ako je kucno vozilo, nemoj mu ponuditi da bira boju
            if (GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 0 && GetPVarInt(playerid, "pAutosalonBuyingHouseCar") == 1 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 0)
            {
                RealEstate_BuyHouseCar(playerid);
            }
            else
            {
                tempVehicle[playerid] = CreateVehicle(GetPVarInt(playerid, "pAutosalonModel"), 940.0802, -1724.4004, 13.2702,90.0, 0, 0, 5000);

                new Float:camPos[3];
                GetPlayerCameraPos(playerid, camPos[POS_X], camPos[POS_Y], camPos[POS_Z]);
                GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);//1783.8217, -1697.2371, 15.3725
                InterpolateCameraPos(playerid, camPos[POS_X], camPos[POS_Y], camPos[POS_Z], 936.1671, -1729.6696, 15.6153, 1500, CAMERA_MOVE);
                InterpolateCameraLookAt(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], 940.0802, -1724.4004, 13.2702, 1500, CAMERA_MOVE);
            
                ClearChatForPlayer(playerid);
                SendClientMessage(playerid, INFOPLAVA, "Ostalo je jos samo da odaberete {FFFFFF}boju vozila.");

                ptdColors_Create(playerid);
                ptdColors_Show(playerid);
            }
        }

        else if (playertextid == PlayerTD[playerid][ptdAutosalon][77]) // Izlaz
        {
            katalog_Cancel(playerid);
        }

        else // Kliknuo na neko vozilo
        {
            new index;
            for__loop (new i = 0; i <= 74; i++) 
            {
                if (playertextid == PlayerTD[playerid][ptdAutosalon][i]) 
                {
                    index = (i-1)/5 * GetPVarInt(playerid, "pAutosalonPage") + (PAGE_MAX_ITEMS - ((i-1)/5)) * (GetPVarInt(playerid, "pAutosalonPage") - 1);
                    break;
                }
            }

            new model, price;
            switch (GetPVarInt(playerid, "pAutosalonCat")) 
            {
                case automobil:     model = listCars[index][as_modelid],        price = listCars[index][as_price];
                case motor:         model = listMotorbikes[index][as_modelid],  price = listMotorbikes[index][as_price];
                case bicikl:        model = listBicycles[index][as_modelid],    price = listBicycles[index][as_price];
                case helikopter:    model = listHelicopters[index][as_modelid], price = listHelicopters[index][as_price];
                case brod:          model = listBoats[index][as_modelid],       price = listBoats[index][as_price];
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][81], imena_vozila[model - 400]);
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][80]);
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][81]);
            SetPVarInt(playerid, "pAutosalonModel", model);
            SetPVarInt(playerid, "pAutosalonPrice", price);
        }

        return ~1;
    }
    return 0;
}

hook OnPlayerSelectColor(playerid, hex, colorid) 
{
    if (GetPVarInt(playerid, "pAutosalon") > 0)
    {
        ChangeVehicleColor(tempVehicle[playerid], colorid, colorid);
    }
}

hook OnPlayerBuyColor(playerid, hex, colorid) 
{
    if (GetPVarInt(playerid, "pAutosalon") > 0)
    {
        ptdColors_Destroy(playerid);
        SetPVarInt(playerid, "pAutosalonColor", colorid);

        if (tempVehicle[playerid] != INVALID_VEHICLE_ID)
            DestroyVehicle(tempVehicle[playerid]), tempVehicle[playerid] = INVALID_VEHICLE_ID;

        // Kod za kupovinu ovde
        autosalon_FinalizePurchase(playerid);
        return ~1;
    }
    return 1;
}

hook OnPlayerExitColorMenu(playerid) {
    if (GetPVarInt(playerid, "pAutosalon") > 0)
    {
        katalog_Cancel(playerid);
        ptdColors_Destroy(playerid);
        return ~1;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
nl_public AUTOSALON_ToggleUnlimitedStock()
{
    autosalon_napunjen = !autosalon_napunjen;
    return 1;
}

nl_public AUTOSALON_IsStockUnlimited()
{
    return autosalon_napunjen;
}

stock AUTOSALON_CheckStock(model)
{
    new stockNum = 0;
    if (IsVehicleBoat(model))
    {
        for__loop (new i = 0; i < sizeof listBoats; i++)
        {
            if (listBoats[i][as_modelid] == model)
            {
                stockNum = listBoats[i][as_stock];
                break;
            }
        }
    }
    else if (IsVehicleHelicopter(model))
    {
        for__loop (new i = 0; i < sizeof listHelicopters; i++)
        {
            if (listHelicopters[i][as_modelid] == model)
            {
                stockNum = listHelicopters[i][as_stock];
                break;
            }
        }
    }
    else if (IsVehicleBicycle(model))
    {
        for__loop (new i = 0; i < sizeof listBicycles; i++)
        {
            if (listBicycles[i][as_modelid] == model)
            {
                stockNum = listBicycles[i][as_stock];
                break;
            }
        }
    }
    else if (IsVehicleMotorbike(model))
    {
        for__loop (new i = 0; i < sizeof listMotorbikes; i++)
        {
            if (listMotorbikes[i][as_modelid] == model)
            {
                stockNum = listMotorbikes[i][as_stock];
                break;
            }
        }
    }
    else
    {
        for__loop (new i = 0; i < sizeof listCars; i++)
        {
            if (listCars[i][as_modelid] == model)
            {
                stockNum = listCars[i][as_stock];
                break;
            }
        }
    }

    return stockNum;
}

stock AUTOSALON_ReduceStock(vrsta, model)
{
    new stockNum;
    if (vrsta == brod)
    {
        for__loop (new i = 0; i < sizeof listBoats; i++)
        {
            if (listBoats[i][as_modelid] == model)
            {
                listBoats[i][as_stock] -= 1;
                stockNum = listBoats[i][as_stock];
                break;
            }
        }
    }
    else if (vrsta == helikopter)
    {
        for__loop (new i = 0; i < sizeof listHelicopters; i++)
        {
            if (listHelicopters[i][as_modelid] == model)
            {
                listHelicopters[i][as_stock] -= 1;
                stockNum = listHelicopters[i][as_stock];
                break;
            }
        }
    }
    else if (vrsta == bicikl)
    {
        for__loop (new i = 0; i < sizeof listBicycles; i++)
        {
            if (listBicycles[i][as_modelid] == model)
            {
                listBicycles[i][as_stock] -= 1;
                stockNum = listBicycles[i][as_stock];
                break;
            }
        }
    }
    else if (vrsta == motor)
    {
        for__loop (new i = 0; i < sizeof listMotorbikes; i++)
        {
            if (listMotorbikes[i][as_modelid] == model)
            {
                listMotorbikes[i][as_stock] -= 1;
                stockNum = listMotorbikes[i][as_stock];
                break;
            }
        }
    }
    else if (vrsta == automobil)
    {
        for__loop (new i = 0; i < sizeof listCars; i++)
        {
            if (listCars[i][as_modelid] == model)
            {
                listCars[i][as_stock] -= 1;
                stockNum = listCars[i][as_stock];
                break;
            }
        }
    }

    new query[256];
    format(query, sizeof query, "UPDATE vozila_stock SET stock = %i WHERE model = %i", stockNum, model);
    mysql_tquery(SQL, query);
    return 1;
}

stock autosalon_FinalizePurchase(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("autosalon_FinalizePurchase");
    }

    if (GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 0 && GetPVarInt(playerid, "pAutosalonBuyingHouseCar") == 0 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 1) 
    {
        // Fakcija
        faction_BuyVehicle(playerid);
    }
    else if (GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 1 && GetPVarInt(playerid, "pAutosalonBuyingHouseCar") == 0 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 0) 
    {
        // Licno vozilo
        if (GetPVarInt(playerid, "pAutosalonSlot") == -1)
            return ErrorMsg(playerid, "Nemate slobodne slotove za kupovinu novih vozila.");

        OwnedVehicle_Buy(playerid);
    }
    else if (GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 0 && GetPVarInt(playerid, "pAutosalonBuyingHouseCar") == 1 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 0)
    {
        // Kucno vozilo
        RealEstate_BuyHouseCar(playerid);
        return 1;
    }
    else return ErrorMsg(playerid, GRESKA_NEPOZNATO);
    return 1;
}

stock katalog_Cancel(playerid) // TODO: poziv kod respawna (ili ne mora??)
{
    if (DebugFunctions())
    {
        LogFunctionExec("katalog_Cancel");
    }

    ptdKatalog_Destroy(playerid);
    ptdAutosalon_Destroy(playerid);
    DeletePVar(playerid, "pAutosalon");
    DeletePVar(playerid, "pAutosalonCat");
    DeletePVar(playerid, "pAutosalonSlot");
    DeletePVar(playerid, "pAutosalonPage");
    DeletePVar(playerid, "pAutosalonPrice");
    DeletePVar(playerid, "pAutosalonColor");
    DeletePVar(playerid, "pAutosalonModel");
    DeletePVar(playerid, "pAutosalonBuyingAsPlayer");
    DeletePVar(playerid, "pAutosalonBuyingAsLeader");

    if (tempVehicle[playerid] != INVALID_VEHICLE_ID)
        DestroyVehicle(tempVehicle[playerid]), tempVehicle[playerid] = INVALID_VEHICLE_ID;

    SetCameraBehindPlayer(playerid);
    CancelSelectTextDraw(playerid);
    return 1;
}

stock autosalon_HCInit(playerid)
{
    // TODO: Proveriti da li vec poseduje kucno vozilo


    SetPVarInt(playerid, "pAutosalonBuyingAsPlayer", 0);
    SetPVarInt(playerid, "pAutosalonBuyingAsLeader", 0);
    SetPVarInt(playerid, "pAutosalonBuyingHouseCar", 1);

    ptdAutosalon_Create(playerid);
    autosalon_ShowPage(playerid, 1, automobil);
    SelectTextDraw(playerid, 0xF2E4AEFF);

    return 1;
}

stock autosalon_PlayerInit(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("autosalon_PlayerInit");
    }

    #if defined DEBUG_FUNCTIONS
        Debug("function", "autosalon_PlayerInit");
    #endif

    if (PI[playerid][p_nivo] < 3)
        return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste mogli da kupujete u autosalonu.");

    // Trazenje slobodnog slota
    SetPVarInt(playerid, "pAutosalonSlot", -1);
    for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
        if (pVehicles[playerid][i] == 0) 
            SetPVarInt(playerid, "pAutosalonSlot", i);
    }
    
    SetPVarInt(playerid, "pAutosalonBuyingAsPlayer", 1);
    SetPVarInt(playerid, "pAutosalonBuyingAsLeader", 0);
    SetPVarInt(playerid, "pAutosalonBuyingHouseCar", 0);
    autosalon_Init(playerid);
    
    if (GetPVarInt(playerid, "pAutosalonSlot") == -1)
        InfoMsg(playerid, "Nemate slobodne slotove za kupovinu novih vozila, mozete ih samo razgledati.");

    return 1;
}

stock autosalon_LeaderInit(playerid, f_id) {
    if (DebugFunctions())
    {
        LogFunctionExec("autosalon_LeaderInit");
    }

    if (GetFactionVehicleCount(f_id) == GetFactionVehicleLimit(f_id))
        return ErrorMsg(playerid, "Dostigli ste dozvoljeni limit za kupovinu vozila.");

    SetPVarInt(playerid, "pAutosalonBuyingAsPlayer", 0);
    SetPVarInt(playerid, "pAutosalonBuyingAsLeader", 1);
    autosalon_Init(playerid);
    return 1;
}

stock autosalon_Init(playerid) {
    if (DebugFunctions())
    {
        LogFunctionExec("autosalon_Init");
    }

    SetPVarInt(playerid, "pAutosalon", 1); // 1=katalog
    ptdKatalog_Create(playerid);
    ptdKatalog_Show(playerid);
    SelectTextDraw(playerid, 0xF2E4AEFF);

    ptdAutosalon_Create(playerid);
    return 1;
}

stock autosalon_ShowPage(playerid, pagenum, category) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("autosalon_ShowPage");
    }


    SetPVarInt(playerid, "pAutosalonCat", category);
    SetPVarInt(playerid, "pAutosalon", 2); // 2=biranje vozila
    SetPVarInt(playerid, "pAutosalonPage", pagenum);
    
    for__loop (new i = 0; i <= 74; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][i]);

    ptdAutosalon_Show(playerid);
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][80]);
    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][81]);

    new 
        lastPage = false,
        pageMaxItem = pagenum*15 - 1,
        pageMinItem = pageMaxItem - (PAGE_MAX_ITEMS - 1);

    switch (category) 
    {
        case automobil: 
        {
            if (pageMaxItem >= sizeof listCars)
                pageMaxItem = sizeof listCars - 1, lastPage = true;

            for__loop (new item = pageMinItem; item <= pageMaxItem; item++) 
            {
                PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 1], listCars[item][as_modelid]);
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 2], FormatDealershipPrice(listCars[item][as_price], playerid));
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 4], imena_vozila[listCars[item][as_modelid] - 400]);
                if (listCars[item][as_stock] > 0 || AUTOSALON_IsStockUnlimited())
                    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 16711935);
                else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 4278190335);

                for__loop (new j = 0; j <= 4; j++)
                    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + j]);
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][76], "Automobili");
        }

        case motor: 
        {
            if (pageMaxItem >= sizeof listMotorbikes)
                pageMaxItem = sizeof listMotorbikes - 1, lastPage = true;

            for__loop (new item = pageMinItem; item <= pageMaxItem; item++) 
            {
                PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 1], listMotorbikes[item][as_modelid]);
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 2], FormatDealershipPrice(listMotorbikes[item][as_price], playerid));
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 4], imena_vozila[listMotorbikes[item][as_modelid] - 400]);
                if (listMotorbikes[item][as_stock] > 0 || AUTOSALON_IsStockUnlimited())
                    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 16711935);
                else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 4278190335);

                for__loop (new j = 0; j <= 4; j++)
                    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + j]);
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][76], "Motori");
        }

        case bicikl: 
        {
            if (pageMaxItem >= sizeof listBicycles)
                pageMaxItem = sizeof listBicycles - 1, lastPage = true;

            for__loop (new item = pageMinItem; item <= pageMaxItem; item++) 
            {
                PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 1], listBicycles[item][as_modelid]);
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 2], FormatDealershipPrice(listBicycles[item][as_price], playerid));
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 4], imena_vozila[listBicycles[item][as_modelid] - 400]);
                if (listBicycles[item][as_stock] > 0 || AUTOSALON_IsStockUnlimited())
                    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 16711935);
                else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 4278190335);

                for__loop (new j = 0; j <= 4; j++)
                    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + j]);
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][76], "Bicikle");
        }

        case helikopter: 
        {
            if (pageMaxItem >= sizeof listHelicopters)
                pageMaxItem = sizeof listHelicopters - 1, lastPage = true;

            for__loop (new item = pageMinItem; item <= pageMaxItem; item++) 
            {
                PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 1], listHelicopters[item][as_modelid]);
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 2], FormatDealershipPrice(listHelicopters[item][as_price], playerid));
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 4], imena_vozila[listHelicopters[item][as_modelid] - 400]);
                if (listHelicopters[item][as_stock] > 0 || AUTOSALON_IsStockUnlimited())
                    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 16711935);
                else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 4278190335);

                for__loop (new j = 0; j <= 4; j++)
                    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + j]);
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][76], "Helikopteri");
        }

        case brod: 
        {
            if (pageMaxItem >= sizeof listBoats)
                pageMaxItem = sizeof listBoats - 1, lastPage = true;

            for__loop (new item = pageMinItem; item <= pageMaxItem; item++) 
            {
                PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 1], listBoats[item][as_modelid]);
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 2], FormatDealershipPrice(listBoats[item][as_price], playerid));
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 4], imena_vozila[listBoats[item][as_modelid] - 400]);
                if (listBoats[item][as_stock] > 0 || AUTOSALON_IsStockUnlimited())
                    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 16711935);
                else PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + 3], 4278190335);

                for__loop (new j = 0; j <= 4; j++)
                    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][(item % PAGE_MAX_ITEMS) * 5 + j]);
            }
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAutosalon][76], "Brodovi");
        }
    }

    // Prethodna strana; prikazi/sakrij
    if (pagenum == 1)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][78]);
    else
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][78]);

    // Sledeca strana; prikazi/sakrij
    if (lastPage)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAutosalon][79]);
    else
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAutosalon][79]);
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward LoadDealershipStock();
public LoadDealershipStock() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("LoadDealershipStock");
    }

    cache_get_row_count(rows);
    if (!rows) return 1;

    new model;
    for__loop (new row = 0; row < rows; row++) {
        cache_get_value_index_int(row, 0, model);

        new bool:ok = false;
        if (IsVehicleBoat(model)) {
            for__loop (new i = 0; i < sizeof listBoats; i++) {
                if (listBoats[i][as_modelid] == model) {
                    cache_get_value_index_int(row, 1, listBoats[i][as_stock]);
                    ok = true;
                    break;
                }
            }
        }
        else if (IsVehicleBicycle(model)) {
            for__loop (new i = 0; i < sizeof listBicycles; i++) {
                if (listBicycles[i][as_modelid] == model) {
                    cache_get_value_index_int(row, 1, listBicycles[i][as_stock]);
                    ok = true;
                    break;
                }
            }
        }
        else if (IsVehicleHelicopter(model)) {
            for__loop (new i = 0; i < sizeof listHelicopters; i++) {
                if (listHelicopters[i][as_modelid] == model) {
                    cache_get_value_index_int(row, 1, listHelicopters[i][as_stock]);
                    ok = true;
                    break;
                }
            }
        }
        else if (IsVehicleMotorbike(model)) {
            for__loop (new i = 0; i < sizeof listMotorbikes; i++) {
                if (listMotorbikes[i][as_modelid] == model) {
                    cache_get_value_index_int(row, 1, listMotorbikes[i][as_stock]);
                    ok = true;
                    break;
                }
            }
        }
        else {
            for__loop (new i = 0; i < sizeof listCars; i++) {
                if (listCars[i][as_modelid] == model) {
                    cache_get_value_index_int(row, 1, listCars[i][as_stock]);
                    ok = true;
                    break;
                }
            }
        }
        if (!ok)
            printf("[autosalon.pwn] Ne mogu da ucitam lager za vozilo %i", model);
    }

    return 1;
}

FormatDealershipPrice(iPrice, playerid)
{
    if (iPrice <= 0) iPrice = 1000; // sanity check
    new sReturn[25];


    if (GetPVarInt(playerid, "pAutosalonBuyingAsPlayer") == 0 && GetPVarInt(playerid, "pAutosalonBuyingHouseCar") == 0 && GetPVarInt(playerid, "pAutosalonBuyingAsLeader") == 1) 
    {
        // Kupovina za fakciju
        format(sReturn, sizeof sReturn, "%s", formatMoneyString(iPrice));
    }
    else
    {
        format(sReturn, sizeof sReturn, "%s", formatMoneyString(iPrice));
        // Kupovina licnog ili kucnog vozila
        /*
        new sCashPart[13], sGoldPart[10],
            iPlayerLevel = PI[playerid][p_nivo];

        if (iPrice < 1000000)
        {
            format(sCashPart, sizeof sCashPart, "~G~$~W~%.1fk", (iPrice/1000.0));
        }
        else if (iPrice >= 1000000)
        {
            format(sCashPart, sizeof sCashPart, "~G~$~W~%.1fm", (iPrice/1000000.0));
        }

        //if (iPlayerLevel > 10)
        //{
        //    format(sGoldPart, sizeof sGoldPart, "%i~Y~G", GetVehicleGoldPrice(iPrice, iPlayerLevel));
        //}

        format(sReturn, sizeof sReturn, "%s + %s", sCashPart, sGoldPart);*/
    }
    return sReturn;
}

GetVehicleGoldPrice(iCashPrice, iPlayerLevel)
{
    #pragma unused iPlayerLevel, iCashPrice
    return 0;//floatround((iCashPrice*0.04) / GetAverageGoldCurrency()); // 4% od KES cene za svaki level preko 10
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:autosalon_igrac_lider(playerid, response, listitem, const inputtext[]) {
    if (response) 
        autosalon_PlayerInit(playerid);
    else
        autosalon_LeaderInit(playerid, PI[playerid][p_org_id]);

    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:katalog(playerid, const params[]) 
{
    if (!IsPlayerInRangeOfPoint(playerid, 10.0, 940.3291, -1707.9705, 13.6153)) 
        return SetGPSLocation(playerid, 940.3291, -1707.9705, 13.6153, "auto salon");
    
    if (GetPVarInt(playerid, "pAutosalon") != 0)
        return ErrorMsg(playerid, "Vec gledate katalog.");

    if (IsPlayerInRangeOfPoint(playerid, 10.0, 2053.3782,-1905.1417,13.5608))
    {
        // Autosalon za kucna vozila
        autosalon_HCInit(playerid);
    }
    else
    {
        // Autosalon za privatna i org vozila
        if (IsLeader(playerid)) 
        {
            new 
                rgb[7], tag[8], f_id = GetPlayerFactionID(playerid);
            GetFactionRGB(f_id, rgb, sizeof(rgb));
            GetFactionTag(f_id, tag, sizeof(tag));
            format(string_128, sizeof string_128, "{FFFFFF}Vi ste lider {%s}%s.\n\n{FFFFFF}Da li zelite da kupujete vozila kao obican igrac ili kao lider?",
                rgb, tag);
            SPD(playerid, "autosalon_igrac_lider", DIALOG_STYLE_MSGBOX, "Auto salon", string_128, "Igrac", "Lider");

            return 1;
        }
        
        // kupuje kao igrac
        autosalon_PlayerInit(playerid); 
    }

    
    return 1;
}

flags:salon(FLAG_ADMIN_6)
CMD:salon(playerid, const params[]) 
{
    new model, stockNum;
    if (sscanf(params, "k<vehiclemodel>I(-1)", model, stockNum))
        return Koristite(playerid, "salon [Naziv ili ID modela] [Lager (opciono; izostaviti za info o dostupnosti)]");

    if (model == -1)
        return ErrorMsg(playerid, "Uneli ste nepoznati model vozila.");

    if (stockNum > 10000)
        return ErrorMsg(playerid, "Lager moze da bude najvise 10000.");

    new bool:ok = false, availableCount = -1;
    if (IsVehicleBoat(model)) 
    {
        for__loop (new i = 0; i < sizeof listBoats; i++) 
        {
            if (listBoats[i][as_modelid] == model) 
            {
                if (stockNum == -1) availableCount = listBoats[i][as_stock];
                else listBoats[i][as_stock] = stockNum;
                ok = true;
                break;
            }
        }
    }
    else if (IsVehicleBicycle(model)) 
    {
        for__loop (new i = 0; i < sizeof listBicycles; i++) 
        {
            if (listBicycles[i][as_modelid] == model) 
            {
                if (stockNum == -1) availableCount = listBicycles[i][as_stock];
                else listBicycles[i][as_stock] = stockNum;
                ok = true;
                break;
            }
        }
    }
    else if (IsVehicleHelicopter(model)) 
    {
        for__loop (new i = 0; i < sizeof listHelicopters; i++) 
        {
            if (listHelicopters[i][as_modelid] == model) 
            {
                if (stockNum == -1) availableCount = listHelicopters[i][as_stock];
                else listHelicopters[i][as_stock] = stockNum;
                ok = true;
                break;
            }
        }
    }
    else if (IsVehicleMotorbike(model)) 
    {
        for__loop (new i = 0; i < sizeof listMotorbikes; i++) 
        {
            if (listMotorbikes[i][as_modelid] == model) 
            {
                if (stockNum == -1) availableCount = listMotorbikes[i][as_stock];
                else listMotorbikes[i][as_stock] = stockNum;
                ok = true;
                break;
            }
        }
    }
    else 
    {
        for__loop (new i = 0; i < sizeof listCars; i++) 
        {
            if (listCars[i][as_modelid] == model) 
            {
                if (stockNum == -1) availableCount = listCars[i][as_stock];
                else listCars[i][as_stock] = stockNum;
                ok = true;
                break;
            }
        }
    }
    if (!ok)
        return ErrorMsg(playerid, "Uneli ste ispravno vozilo, ali ono se ne prodaje u salonu.");


    if (availableCount != -1)
        return SendClientMessageF(playerid, INFOPLAVA, "Vozilo: {FFFFFF}%s | {4655B2}Dostupno za kupovinu: {FFFFFF}%i", imena_vozila[model - 400], availableCount);

    SendClientMessageF(playerid, INFOPLAVA, "* Promenili ste lager za vozilo {FFFFFF}%s | {4655B2}Dostupno za kupovinu: {FFFFFF}%i", imena_vozila[model - 400], stockNum);

    format(mysql_upit, sizeof mysql_upit, "UPDATE vozila_stock SET stock = %i WHERE model = %i", stockNum, model);
    mysql_tquery(SQL, mysql_upit);
    return 1;
}