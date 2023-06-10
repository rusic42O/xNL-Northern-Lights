#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_KUCA      	        430
#define MAX_STANOVA   	        600
#define MAX_FIRMI     	        300
#define MAX_HOTELA			    26
#define MAX_GARAZA    	        200
#define MAX_VIKENDICA           200
#define MAX_PROIZVODA 	        150
#define MAX_OBJEKATA	        50 // namestaj; ako se menja, izmeniti velicinu (broj stranica) kod "ft_list"
#define MAX_HOTEL_SOBA		    30 // Max soba dostupnih za iznajmljivanje u hotelima
#define MAX_APT_CHEM_ITEMS      8 // Na osnovu definicija iz drugs.pwn [substance_max_id - substance_min_id + 1]
    
#define THREAD_KUCE 	        0
#define THREAD_STANOVI 	        1
#define THREAD_FIRME 	        2
#define THREAD_HOTELI		    3
#define THREAD_GARAZE           4
#define THREAD_PROIZVODI        5
#define THREAD_PROIZVODI2       6
#define THREAD_OBJEKTI		    7
#define THREAD_HOTEL_STANARI    8
#define THREAD_KUCE_ORUZJE      9
#define THREAD_KUCE_STANARI     10
#define THREAD_VIKENDICE        11

#define FIRMA_PRODAVNICA        (1)
#define FIRMA_ORUZARNICA        (2)
#define FIRMA_TECHNOLOGY        (3)
#define FIRMA_HARDWARE          (4)
#define FIRMA_RESTORAN          (5)
#define FIRMA_KAFIC             (6)
#define FIRMA_BAR               (7)
#define FIRMA_DISKOTEKA         (8)
#define FIRMA_BUTIK             (9)
#define FIRMA_SEXSHOP           (10)
#define FIRMA_BURGERSHOT        (11)
#define FIRMA_PIZZASTACK        (12)
#define FIRMA_CLUCKINBELL       (13)
#define FIRMA_RANDYSDONUTS      (14)
#define FIRMA_TERETANA          (15)
#define FIRMA_SECURITYSHOP      (16)
#define FIRMA_PIJACA	        (17)
#define FIRMA_RENTACAR          (18)
#define FIRMA_KIOSK             (19)
#define FIRMA_BENZINSKA         (20)
#define FIRMA_POSAO             (21)
#define FIRMA_MEHANICAR         (22)
#define FIRMA_TUNING            (23)
#define FIRMA_DRUGO             (24)
#define FIRMA_APOTEKA           (25)
#define FIRMA_BOLNICA           (26)
#define FIRMA_ACCESSORY         (27)
#define FIRMA_RADIO             (28)








// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_REAL_ESTATE
{
    RE_ID, // lokalni ID nekretnine
    RE_PICKUP_ENTRANCE, // Ulaz Pickup ID
    RE_PICKUP_EXIT, // Izlaz Pickup ID 
    RE_PICKUP_VEHICLE, // Vehicle-Pickup ID (ulaz) - kuce i garaze
    RE_PICKUP_GARAGE_ENTER, // Garaza ulaz pickup - on foot - samo kuce
    RE_PICKUP_GARAGE_EXIT, // Garaza izlaz pickup - on foot - samo kuce
    Text3D:RE_LABEL, // 3D Text Label ID
    Text3D:RE_LABEL_2, // 3D Text Label ID za garaze koje pripadaju kucama / Interact Text ID (samo FIRMA_KIOSK !!!)
    RE_VLASNIK[MAX_PLAYER_NAME],
    RE_NIVO,
    RE_CENA,
    RE_ENT,
    RE_ZATVORENO,
    RE_ADRESA[32],
    Float:RE_ULAZ[4],
    Float:RE_IZLAZ[4],
    RE_OWNER_LAST_ONLINE,

    RE_VRSTA, // Kuca, firma
    RE_NOVAC, // Kuca (sef), firma i hotel (kasa) LIMIT: 16,777,215
    RE_RENT, // Kuca
    RE_SEF, // Kuca (0=nema, 1=ima)
    RE_CENA_SOBE, // Hotel (-1 = onemoguceno iznajmljivanje)
    RE_SLOTOVI, // Hotel (broj soba za iznajmljivanje, max = MAX_HOTEL_SOBA)
    RE_ROBBERY_COOLDOWN, // TODO
    RE_GARAZA_OTKLJUCANA, // Kuca
    Float:RE_GARAZA[4], // Kuca
    Float:RE_INTERACT[3], // Firma, hotel, garaza (izrada droge)
    RE_CHECKPOINT, // Firma, Garaza, Hotel,

    RE_HC_MODEL,
    RE_HC_VEHID,
    Float:RE_HC_POS[4],
};
new RealEstate[/*-1 + */MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA][E_REAL_ESTATE];
// ------------------------------ //
enum E_BUSINESS_INFO
{
    BIZ_REKET,
    BIZ_NOVAC_REKET,
    BIZ_NAZIV[32],
    BIZ_CHECKPOINT,
    BIZ_ACTOR,
}
new BizInfo[MAX_FIRMI][E_BUSINESS_INFO];
// ------------------------------ //
enum E_HOUSE_INFO
{
    HOUSE_MDMA,
    HOUSE_HEROIN,
    HOUSE_VEH_MODEL,
    Float:HOUSE_VEH_POS[4],
    HOUSE_VEH_COLOR[2],
}
new HouseInfo[MAX_KUCA][E_HOUSE_INFO];
// ------------------------------ //
enum e_kuce_objekti
{
    hf_uid, // unikatni id objekta
    hf_dynid, // dynamic object id
    hf_object_id,
    hf_category,
    hf_name[MAX_FITEM_NAME],
    hf_price,
    Float:hf_x_poz,
    Float:hf_y_poz,
    Float:hf_z_poz,
    Float:hf_x_rot,
    Float:hf_y_rot,
    Float:hf_z_rot,
};
new H_FURNITURE[MAX_KUCA][MAX_OBJEKATA][e_kuce_objekti];
// ------------------------------ //
enum E_HOUSES_WEAPONS
{
    hw_weapon,
    hw_ammo,
}
new H_WEAPONS[MAX_KUCA][13][E_HOUSES_WEAPONS];
// ------------------------------ //
enum E_APARTMENTS_CHEM
{
    apt_chem_itemid,
    apt_chem_count,
}
new APT_CHEM[MAX_STANOVA][MAX_APT_CHEM_ITEMS][E_APARTMENTS_CHEM];
// ------------------------------ //
enum E_COTTAGE_INFO
{
    COTTAGE_WEED,
    COTTAGE_WEED_RAW,
    COTTAGE_MATS,
}
new CottageInfo[MAX_VIKENDICA][E_COTTAGE_INFO];
// ------------------------------ //
enum e_f_products
{
    f_cena, // Cena proizvoda
    f_stock, // Zalihe
};
new F_PRODUCTS[MAX_FIRMI][MAX_PROIZVODA][e_f_products]; // Vrednosti proizvoda za svaku firmu
// ------------------------------ //
enum e_products
{
    pr_naziv[32],
    pr_cena,
};
new PRODUCTS[MAX_PROIZVODA][e_products]; // Default vrednosti proizvoda (nisu vezane ni za jednu firmu)
// ------------------------------ //
enum e_hotel_stanari
{
    rh_player_id,
};
new RE_HOTELS[MAX_HOTELA][MAX_HOTEL_SOBA][e_hotel_stanari];





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	MAX_REAL_ESTATE,
	real_estate_maxID[6],

	objekti_cena[MAX_PLAYERS],

    RE_oruzje_slot[MAX_PLAYERS],
	
	stanari_li[MAX_HOTEL_SOBA],

    // Prodaja igracu
    RE_sellingType[MAX_PLAYERS],
    RE_sellingTo[MAX_PLAYERS],
    RE_sellingPrice[MAX_PLAYERS],
    RE_sellingTo_Name[MAX_PLAYERS][MAX_PLAYER_NAME],
    RE_buyingFrom[MAX_PLAYERS],
    RE_buyingPrice[MAX_PLAYERS],
    RE_buyingFrom_Name[MAX_PLAYERS][MAX_PLAYER_NAME],

    drivethruCP,
    RE_PickupKupovinaProizvoda,
    gPropertyPickupGID[MAX_PLAYERS]
;

static gAdvertisingBizID;


new const proizvodi[29][15] =
{
    {},

    // Prodavnica - 1
    {3, 4, 5, 6, 7, 8, 9, 10, 11, 115},

    // Oruzarnica - 2
    {12, 13, 14, 15, 16, 17, 43, 18, 121, 19, 20, 120},

    // Tech Store - 3
    {21, 22, 23, 30, 31, 24, 25, 118},

    // Hardware Store - 4
    {32, 33, 34, 35, 36, 37, 20, 107, 119},
    
    // Restoran - 5
    {50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61},

    {},{},{},{},
    
    // Sex Shop - 10
    {6, 38, 39, 40, 41},
    
    // Burger Shot - 11
    {62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75},

    // Pizza Stack - 12
    {76, 77, 78, 79, 80, 81, 82, 83},

    // Cluckin' Bell - 13
    {84, 85, 86, 87, 88, 89, 90, 91, 92, 73, 93, 94},

    // Randy's Donuts - 14
    {91, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 94, 105},

    // Teretana - 15
    {122, 123, 124, 125, 126, 127},

    // Security Shop - 16
    {128, 129, 130, 131},

    // Pijaca - 17
    {132, 133, 134},

    {},

    // Kiosk - 19
    {1, 2, 8, 9, 32, 36, 49},

    // Benzinska pumpa - 20
    {48},
    
    {}, {}, {}, {}, 

    // Apoteka - 25
    {113, 109, 112, 110, 111, 108, 114, 116, 117},

    // Bolnica, Accessory Shop, Radio NL
    {}, {}, {}
};





// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit() 
{
	MAX_REAL_ESTATE    = /*-1 + */MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA;

	// Resetovanje promenljivih
	for__loop (new i = 0; i < MAX_REAL_ESTATE; i++) 
    {
		RealEstate[i][RE_ID]       = 
        RealEstate[i][RE_CHECKPOINT] = 
		RealEstate[i][RE_PICKUP_ENTRANCE]  = 
		RealEstate[i][RE_PICKUP_EXIT]  = 
		RealEstate[i][RE_PICKUP_VEHICLE]  =
        RealEstate[i][RE_PICKUP_GARAGE_ENTER] = 
        RealEstate[i][RE_PICKUP_GARAGE_EXIT] = -1;

		RealEstate[i][RE_NOVAC] = 0;

		RealEstate[i][RE_LABEL] = RealEstate[i][RE_LABEL_2] = Text3D:INVALID_3DTEXT_ID;
	}
    for__loop (new i = 0; i < MAX_FIRMI; i++)
    {
        BizInfo[i][BIZ_ACTOR] = -1;
    }
	for__loop (new i = 0; i < MAX_HOTELA; i++)
	{
		for__loop (new j = 0; j < MAX_HOTEL_SOBA; j++)
			RE_HOTELS[i][j][rh_player_id] = INVALID_PLAYER_ID;
	}

    for (new i = 0; i < sizeof real_estate_maxID; i++)
    {
        real_estate_maxID[i] = 0;
    }

    mysql_tquery(SQL, "SELECT * FROM re_kuce",      "MySQL_LoadHouse");
    mysql_tquery(SQL, "SELECT * FROM re_stanovi",   "MySQL_LoadApartment");
    mysql_tquery(SQL, "SELECT * FROM re_firme",     "MySQL_LoadBusiness");
    mysql_tquery(SQL, "SELECT * FROM re_hoteli",    "MySQL_LoadHotel");
    mysql_tquery(SQL, "SELECT * FROM re_garaze",    "MySQL_LoadGarage");
    mysql_tquery(SQL, "SELECT * FROM re_vikendice", "MySQL_LoadCottage");
    mysql_tquery(SQL, "SELECT * FROM proizvodi",    "MySQL_LoadProducts");
    mysql_tquery(SQL, "SELECT * FROM re_firme_proizvodi", "MySQL_LoadBizProducts");
    mysql_tquery(SQL, "SELECT * FROM re_stanovi_predmeti ORDER BY stan ASC", "RE_MYSQL_LoadApartmentItems");
    mysql_tquery(SQL, "SELECT * FROM re_hoteli_stanari ORDER BY hotel_id ASC", "MySQL_LoadHotelTennants");


    RE_PickupKupovinaProizvoda = CreateDynamicPickup(19132, 1, 2271.0747,-2352.5740,13.5469); // Narucivanje proizvoda

    // Tajmeri za neaktivnost (po 7 minuta razlike)
    SetTimerEx("RE_UpdateActivityData", 60*60*1000, true, "i", kuca);
    SetTimerEx("RE_UpdateActivityData", 61*60*1000, true, "i", firma);
    SetTimerEx("RE_UpdateActivityData", 62*60*1000, true, "i", stan);
    SetTimerEx("RE_UpdateActivityData", 63*60*1000, true, "i", garaza);
    SetTimerEx("RE_UpdateActivityData", 64*60*1000, true, "i", hotel);
    SetTimerEx("RE_UpdateActivityData", 65*60*1000, true, "i", vikendica);


    // Custom kapije
    gGate_H284 = CreateDynamicObject(19912, 1503.665649, -700.029357, 96.078208, 0.000000, 0.000000, 0.000000); 
    gGate_H284_Status = false;
    
    gGate_H326 = CreateDynamicObject(986, 1003.371032, -643.724914, 121.761138, 0.000000, 0.000000, 21.500005); 
    gGate_H326_Status = false;

    gGate_H396 = CreateDynamicObject(986, 1452.391235, -748.928955, 92.408134, 0.000000, 0.000000, -86.100021, 0, 0);
    gGate_H396_Status = false;

    gGate_H397 = CreateDynamicObject(19912, 1312.305541, -2557.798828, 15.380737, -0.000007, 0.000000, -89.999977, 0, 0);
    gGate_H397_Status = false;

    gGate_H391[0] = CreateDynamicObject(3498, 1073.793212, -778.397399, 103.654846, 0.000000, 0.000007, 6.999997, -1, -1, -1, 750.00, 750.00); 
    SetDynamicObjectMaterial(gGate_H391[0], 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    SetDynamicObjectMaterial(gGate_H391[0], 1, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    gGate_H391[1] = CreateDynamicObject(3498, 1075.493408, -778.047546, 103.694839, 0.000000, 0.000007, 6.999997, -1, -1, -1, 750.00, 750.00); 
    SetDynamicObjectMaterial(gGate_H391[1], 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    SetDynamicObjectMaterial(gGate_H391[1], 1, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    gGate_H391[2] = CreateDynamicObject(3498, 1077.367431, -777.716674, 103.764839, 0.000000, 0.000007, 6.999997, -1, -1, -1, 750.00, 750.00); 
    SetDynamicObjectMaterial(gGate_H391[2], 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    SetDynamicObjectMaterial(gGate_H391[2], 1, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    gGate_H391[3] = CreateDynamicObject(3498, 1079.229858, -777.376892, 103.804840, 0.000000, 0.000007, 6.999997, -1, -1, -1, 750.00, 750.00); 
    SetDynamicObjectMaterial(gGate_H391[3], 0, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    SetDynamicObjectMaterial(gGate_H391[3], 1, 2755, "ab_dojowall", "mp_apt1_roomfloor", 0x00000000);
    gGate_H391_Status = false;
/*
    gGate_H404 = CreateDynamicObject(2990, 551.3797, -1921.4301, 1.9075, 0.00000, 0.00000, 175.44009);
    gGate_H404_Status = false;*/

    // Donacija
    // CreateDynamic3DTextLabel("{FF9900}KUCA ZA DONACIJU\n\n{FFFFFF}Cena: {00FF00}15 EUR", 0xFFFFFF00, 164.9386,-1791.8991,4.3843, 25.0);

	return 1;
}

hook OnPlayerConnect(playerid)
{
    gPropertyPickupGID[playerid] = -1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (IsPlayerLoggedIn(playerid))
    {
        foreach(new i : Player)
        {
            if (i == playerid) continue;

            if (!isnull(RE_sellingTo_Name[i]) && !strcmp(RE_sellingTo_Name[i], ime_rp[playerid], false)) 
            {
                SendClientMessage(i, SVETLOCRVENA, "* Igrac kome zelite da prodate svoju imovinu je napustio server.");
                HidePlayerDialog(i);
                resetuj_prodaju(i);
                break;
            }
                
            if (!isnull(RE_buyingFrom_Name[i]) && !strcmp(RE_buyingFrom_Name[i], ime_rp[playerid], false)) 
            {
                SendClientMessage(i, SVETLOCRVENA, "* Igrac koji Vam je ponudio svoju imovinu je napustio server.");
                HidePlayerDialog(i);
                resetuj_prodaju(i);
                break;
            }
        }
    }
}


hook OnPlayerSpawn(playerid)
{
    // Ukoliko se igrac spawnuje u garazi i sedne u vozilo pre nego sto mu se pickup streamuje, nece moci da izadje iz vozila (ovo je workaround za taj problem)
    if (RealEstate_CheckPlayerPosession(playerid, garaza) > 0)
    {
        // Loop kroz igraceve garaze
        for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][garaza]; i++)
        {
            new gid = re_globalid(garaza, pRealEstate[playerid][garaza][i]);
            if (GetPlayerVirtualWorld(playerid) == gid && PI[playerid][p_spawn_x] == RealEstate[gid][RE_IZLAZ][0])
            {
                gPropertyPickupGID[playerid] = gid;
                break;
            }
        }
    }
}


/*
  Poziva se kada igrac pokupi pickup i postoji mogucnost da je to pickup neke nekretnine
*/
hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if (pickupid == RE_PickupKupovinaProizvoda)
    {
        GameTextForPlayer(playerid, "~b~Narucivanje proizvoda~n~~w~Koristite ~g~/firma", 4000, 3);
        return ~1;
    }
    

	if (gPropertyPickupGID[playerid] != -1)
    {
        // Ako se igrac stalno vrti oko jednog te istog pickup-a
    	if (RealEstate[gPropertyPickupGID[playerid]][RE_PICKUP_ENTRANCE] == pickupid 
            || RealEstate[gPropertyPickupGID[playerid]][RE_PICKUP_EXIT] == pickupid 
            || RealEstate[gPropertyPickupGID[playerid]][RE_PICKUP_VEHICLE] == pickupid) return 1;
	}

    new
        index = -1,
        index2 = -1
	;
    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && GetPlayerInterior(playerid) == 0 && GetPlayerVirtualWorld(playerid) == 0) 
    {
        // Igrac na nogama -> loop kroz spoljasnje obicne pickupe
        index = _:RE_PICKUP_ENTRANCE;
        index2 = _:RE_PICKUP_GARAGE_ENTER;
	}
	else if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0))
	{
        // Igrac na nogama i u enterijeru (vw je zbog tech/hardware store-a) -> loop kroz unutrasnje pickupe
	    index = _:RE_PICKUP_EXIT;
        index2 = _:RE_PICKUP_GARAGE_EXIT;
	}
	else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    {
        // Igrac u vozilu -> loop kroz spoljasnje pickupe za vozila
        index = _:RE_PICKUP_VEHICLE;
	}

    if (index != -1 || index2 != -1)
    {
    	for__loop (new i = 0; i < MAX_REAL_ESTATE; i++)
        {
            if (RealEstate[i][E_REAL_ESTATE:index] == pickupid || (index2 != -1 && RealEstate[i][E_REAL_ESTATE:index2] == pickupid))
            {
                gPropertyPickupGID[playerid] = i;

                if (
                    (re_odredivrstu(i) == garaza && (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)) 
                    ||
                    re_odredivrstu(i) == kuca 
                    && (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) 
                    && RealEstate[i][RE_PICKUP_VEHICLE] == index)
                {
                    // Igrac je na pickupu od garaze (ili kucne garaze) i nalazi se u vozilu -> kreiraj pickup ponovo jer je unisten
                    RealEstate[i][RE_PICKUP_VEHICLE] = -1;
                    re_kreirajpickup(re_odredivrstu(i), i);
                }
                break;
            }
        }
    }

	return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid) 
{
    // Glavni Burg Drivethru
    if ((checkpointid == drivethruCP || IsPlayerInRangeOfPoint(playerid, 10.0, 1206.8125,-894.4656,43.1322)) && IsPlayerInAnyVehicle(playerid))
    {
        new cmdParams[17];
        format(cmdParams, sizeof cmdParams, "%i", re_globalid(firma, 117));
        callcmd::firmakupi(playerid, cmdParams);
        return ~1;
    }

    for__loop (new i = re_globalid(firma, 1); i < re_globalid(firma, MAX_FIRMI-1); i++) 
    {
        if (checkpointid == RealEstate[i][RE_CHECKPOINT])
        {
            new cmdParams[17];
            format(cmdParams, sizeof cmdParams, "%i", i);
            callcmd::firmakupi(playerid, cmdParams);
            return ~1;
        }
    }


    for__loop (new i = re_globalid(garaza, 1); i < re_globalid(garaza, MAX_GARAZA-1); i++) 
    {
        if (checkpointid == RealEstate[i][RE_CHECKPOINT]) 
        {
            SetPVarInt(playerid, "pDrugsLab", 0);
            Drugs_OpenRecipeDialog(playerid);
            return ~1;
        }
    }


    for__loop (new i = re_globalid(hotel, 1); i < re_globalid(hotel, MAX_HOTELA-1); i++) 
    {
        if (checkpointid == RealEstate[i][RE_CHECKPOINT]) 
        {
            format(string_256, sizeof string_256, "{FFFFFF}Cena sobe: {0068B3}$%d\n\n{FFFFFF}Da li zelite da iznajmite sobu u ovom hotelu?\n(novac u iznosu cene sobe ce Vam biti oduzet prilikom svake plate, ukoliko ste online)", RealEstate[i][RE_CENA_SOBE]);
            
            SPD(playerid, "re_hotel_iznajmi", DIALOG_STYLE_MSGBOX, "{0068B3}IZNAJMLJIVANJE SOBE", string_256, "Iznajmi", "Odustani");
            gPropertyPickupGID[playerid] = i;
            return ~1;
        }
    }

    return 1;
}

/*
  Poziva se kada igrac pritisne dugme za ulazak/izlazak iz enterijera i postoji mogucnost da je to neka nekretnina
*/
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (IsPlayerEditingFurniture(playerid)) return 1; // ne moze da izadje ako izmenjuje namestaj
    if (gInteriorReload[playerid] > GetTickCount()) return 1;
    if (GetPVarInt(playerid, "pTeleportFreeze") == 1) return 1;

	if ((((newkeys & KEY_SPRINT) || (newkeys & KEY_SECONDARY_ATTACK)) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && IsPlayerControllable_OW(playerid)) || (newkeys & KEY_HANDBRAKE && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)) // Space/F/Enter
	{
        if (gPropertyPickupGID[playerid] == -1 && (1 <= GetPlayerVirtualWorld(playerid) <=  (MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA)) && GetPlayerInterior(playerid) > 0)
        {
            gPropertyPickupGID[playerid] = GetPlayerVirtualWorld(playerid);
        }

		if (gPropertyPickupGID[playerid] != -1) // Mozda se nalazi na pickupu neke nekretnine
		{
			new
				gid   = gPropertyPickupGID[playerid],
				vrsta = re_odredivrstu(gid),
				vehicleid = GetPlayerVehicleID(playerid),
                Float:radius = ((vrsta==garaza)? 3.0 : 1.5)
			;

            // ignorisi firme bez enterijera
            if (!IsBusinessWithInterior(gid)) return ~1;

			if (IsPlayerInRangeOfPoint(playerid, radius, RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2])) 
			{
                // Ulazak u enterijer
                gInteriorReload[playerid] = GetTickCount() + 1000;

		        if (RealEstate[gid][RE_ZATVORENO] == 1 && strcmp(RealEstate[gid][RE_VLASNIK], ime_obicno[playerid])) 
                {
                    GameTextForPlayer(playerid, "~r~Zatvoreno!", 2500, 3);
                    return ~1;
                }

		        if (vrsta == garaza) // Ulazi u garazu, teleportuj i vozilo ako se nalazi u vozilu
		        {
                    // Freeze zbog ucitavanja garaze
                    TogglePlayerControllable_H(playerid, false);
                    SetPVarInt(playerid, "pTeleportFreeze", 1);
                    SetTimerEx("TeleportUnfreeze", 4000, false, "ii", playerid, cinc[playerid]);
                    TextDrawShowForPlayer(playerid, TD_LoadingObjects);


		            if (vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		            {
                        TogglePlayerControllable(playerid, false);
		                SetVehicleCompensatedPosEx(vehicleid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3], gid, RealEstate[gid][RE_ENT], 5000);
		            }
                    else
                    {
                        // Ako nije vozac, onda teleportujemo samo igraca, a ne i vozilo
                        SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3], gid, RealEstate[gid][RE_ENT], 5000);
                    }
				}
                else
                {
                    SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3], gid, RealEstate[gid][RE_ENT], 3000);
                }
                
		       	
                return ~1;
			}
		    else if (IsPlayerInRangeOfPoint(playerid, 1.5, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2])) // Izlazak napolje
		    {
                gInteriorReload[playerid] = GetTickCount() + 1000;

		        if (vrsta == garaza) // Izlazi iz garaze, teleportuj i vozilo ako se nalazi u vozilu
		        {
		            if (vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		            {
                        TogglePlayerControllable(playerid, false);
		                SetVehicleCompensatedPosEx(vehicleid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3], 0, 0, 5000);
		            }
                    else
                    {
                        SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3], 0, 0, 5000);
                    }
		        }
                else
                {
                    SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3], 0, 0, 3000);
                }
                return ~1;
			}


            // ***************** KUCNE GARAZE*****************
            else if (IsPlayerInRangeOfPoint(playerid, 6.0, RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2])) // Ulazak u kucnu garazu
            {
                gInteriorReload[playerid] = GetTickCount() + 1000;

                if (strcmp(ime_obicno[playerid], RealEstate[gid][RE_VLASNIK])) 
                {
                    GameTextForPlayer(playerid, "~r~Zatvoreno!", 2500, 3);
                    return ~1;
                }

                if (!RealEstate[gid][RE_GARAZA_OTKLJUCANA])
                {
                    ErrorMsg(playerid, "Kucnu garazu morate kupiti kao dodatak. Koristite {FFFFFF}/kuca.");
                    return ~1;
                }

                // Freeze zbog ucitavanja garaze
                TogglePlayerControllable_H(playerid, false);
                SetPVarInt(playerid, "pTeleportFreeze", 1);
                SetTimerEx("TeleportUnfreeze", 4000, false, "ii", playerid, cinc[playerid]);
                TextDrawShowForPlayer(playerid, TD_LoadingObjects);


                if (vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                    TogglePlayerControllable(playerid, false);
                    SetVehicleCompensatedPosEx(vehicleid, -561.55, -2000.4, -5.61, 282.88, gid, RealEstate[gid][RE_ENT], 5000);
                }
                else
                {
                    SetPlayerCompensatedPos(playerid, -561.55, -2000.4, -5.61, 282.88, gid, RealEstate[gid][RE_ENT], 3000);
                }
            }

            else if (IsPlayerInRangeOfPoint(playerid, 3.0, -561.55, -2000.4, -5.61)) // Izlazak iz kucne garaze
            {
                gInteriorReload[playerid] = GetTickCount() + 1000;

                if (vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
                {
                    TogglePlayerControllable(playerid, false);
                    SetVehicleCompensatedPosEx(vehicleid, RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], 0, 0, 5000);
                }
                else
                {
                    SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], 0, 0, 3000);
                }
            }

            else
            {
                // Nije na ulazu/izlazu
                gPropertyPickupGID[playerid] = -1;
            }
		}
	}
	return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward re_globalid(vrsta, lid);
forward re_localid(vrsta, gid);
forward re_kreirajpickup(vrsta, gid);
forward re_odredivrstu(gid);
forward re_proveri_hotel(playerid);
//forward propname(vrsta, oblik);
//forward vrstafirme(vrsta, oblik);
forward re_firma_dodaj_novac(gid, iznos);


/*
  Vraca globalni ID nekretnine baziran na njenom tipu i lokalnom ID-u
*/
public re_globalid(vrsta, lid)
{
	// #if defined DEBUG_FUNCTIONS
	//     Debug("function", "re_globalid");
	// #endif

	/*

	  Npr:

	  - Maksimalni broj kuca:      700
	  - Maksimalni broj stanova:   300
	  - Maksimalni broj vikendica: 200
	  - Maksimalni broj firmi:     250
	  - Maksimalni broj hotela:	   100
	  - Maksimalni broj garaza:    150
								---------
			              Ukupno: 1700

	  Maksimalni broj celija u enumu REAL_ESTATE je 1700.
	  Kuce:      0-699
	  Stanovi:   700-999
	  Vikendice: 1000-1199
	  Firme:     1200-1449
	  Hoteli:	 1450-1549
	  Garaze:    1550-1699

	  Nacin izracunavanja globalnog ID-a na osnovu lokalnog:
	  - Uzmimo definicije MAX_KUCA (700), MAX_STANOVA (300), MAX_VIKENDICA (200),
	    MAX_FIRMI (250), MAX_HOTELA (100) MAX_GARAZA (150) i MAX_REAL_ESTATE (1600)

		- Kuce: (lokalni id = L = 460) Trazi se promenljiva G:
		  - MAX_REAL_ESTATE - MAX_GARAZA - MAX_HOTELA - MAX_FIRMI - MAX_VIKENDICA - MAX_STANOVA - MAX_KUCA = X = 0
			- 1700 - 150 - 100 - 250 - 200 - 300 - 700 = X = 0
		  - G = X + L = 0 + 460 -> G = 460 -> G - 1 = 459 (-1 jer brojanje krece od 0)

		- Vikendice: (lokalni id = L = 120) Trazi se promenljiva G:
		  - MAX_REAL_ESTATE - MAX_GARAZA - MAX_HOTELA - MAX_FIRMI - MAX_VIKENDICA = X = 1000
			- 1700 - 150 - 100 - 250 - 200 = X = 1000
		  - G = X + L = 1000 + 120 -> G = 1120 -> G - 1 = 1119 (-1 jer brojanje krece do 0)

		... itd.
		Uvek se od REAL_ESTATE oduzimaju nekretnine do one za koju se trazi ID (ukljucujuci i nju).
		Na taj nacin se dobije pocetni globalni ID za tu nekretninu (0 za kuce, 700 za stanove, 1000 za vikendice, itd).
		Zatim se na dobijeni broj doda lokalni ID

		(, te se od dobijenog oduzme 1. Razlog za oduzimanje broja 1 je taj
		sto brojanje krece od 0, a ne od 1.) - izbaceno, krece od 1!

	*/

	new gid;
	switch (vrsta)
	{
	    case kuca: 		gid = MAX_REAL_ESTATE - (MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA) + lid;
	    case stan: 		gid = MAX_REAL_ESTATE - (MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA) + lid;
	    case firma: 	gid = MAX_REAL_ESTATE - (MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA) + lid;
	    case hotel: 	gid = MAX_REAL_ESTATE - (MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA) + lid;
	    case garaza: 	gid = MAX_REAL_ESTATE - (MAX_GARAZA + MAX_VIKENDICA) + lid;
        case vikendica: gid = MAX_REAL_ESTATE - (MAX_VIKENDICA) + lid;
	    default:
	    {
	        printf("Ne mogu da odredim globalni ID. Tip: %d, Lokal: %d", vrsta, lid);
	    }
	}

	return gid;
}

/*
  Vraca local id nekretnine na osnovu datog globalnog
*/
public re_localid(vrsta, gid)
{
	// #if defined DEBUG_FUNCTIONS
	//     Debug("function", "re_localid");
	// #endif

	new lid;
	switch (vrsta)
	{
		case kuca:      lid = gid;
		case stan:      lid = gid - (MAX_KUCA);
		case firma:     lid = gid - (MAX_KUCA + MAX_STANOVA);
	    case hotel:     lid = gid - (MAX_KUCA + MAX_STANOVA + MAX_FIRMI);
	    case garaza:    lid = gid - (MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA);
        case vikendica: lid = gid - (MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_VIKENDICA);
	}

	if (lid != RealEstate[gid][RE_ID]) return 0;

	return lid;
}

/*
  Kreira ulaz/izlaz pickup
*/
public re_kreirajpickup(vrsta, gid)
{
	// #if defined DEBUG_FUNCTIONS
	//     Debug("function", "re_kreirajpickup");
	// #endif

	/*
	  [param] vrsta:   vrsta nekretnine (kuca/stan/...)
	  [param] vlasnik: true = nekretnina ima vlasnika, false = nema vlasnika
	  [param] gid:     globalni id nekretnine
	*/
	new
		bool:vlasnik = !!strcmp(RealEstate[gid][RE_VLASNIK], "Niko"),
		boja,
		pickup = 1239,
		Float:add = 0.0
	;
	switch (vrsta)
	{
	    case kuca:
	    {
	        boja = 0x80FF80CC;
			if (!vlasnik) // Nema vlasnika
			{
			    pickup = 1273;
			    add    = 0.5;
                new vrsta_text[13];
                switch (RealEstate[gid][RE_VRSTA])
                {
                    case 1:  vrsta_text = "Prikolica";
                    case 2:  vrsta_text = "Mala kuca";
                    case 3:  vrsta_text = "Srednja kuca";
                    case 4:  vrsta_text = "Velika kuca";
                    case 5:  vrsta_text = "Vila";
                    default: vrsta_text = "Kuca";
                }
                if(RealEstate[gid][RE_NIVO] == 98) format(string_256, sizeof string_256, "{80FF80}%s [NA DONACIJU!]\n\n[ {FFFFFF}%d, %s {80FF80}]\nNivo: {FFFFFF}%d | {80FF80}Cena: {FFFFFF}%s\nDa kupite ovu kucu upisite {80FF80}/kupi", vrsta_text, RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			    else format(string_256, sizeof string_256, "{80FF80}%s na prodaju!\n\n[ {FFFFFF}%d, %s {80FF80}]\nNivo: {FFFFFF}%d | {80FF80}Cena: {FFFFFF}%s\nDa kupite ovu kucu upisite {80FF80}/kupi", vrsta_text, RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
            }
			else // Ima vlasnika
			{
			    format(string_256, sizeof string_256, "{80FF80}[ {FFFFFF}%d, %s {80FF80}]\nNivo: {FFFFFF}%d | {80FF80}Vlasnik: {FFFFFF}%s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
                
                if (RealEstate[gid][RE_RENT] > 0)
                {
                    format(string_256, sizeof string_256, "%s\n{80FF80}Cena sobe: {FFFFFF}%s (/iznajmisobu)", string_256, formatMoneyString(RealEstate[gid][RE_RENT]));
                }
			}

            // Kucna garaza
            if (RealEstate[gid][RE_GARAZA][0] != 0.0)
            {
                // Garaza postoji za ovu kucu

                // Odredjivanje modela pickupa
                new garazaPickup = 19524;
                if (RealEstate[gid][RE_GARAZA_OTKLJUCANA] == 1)
                {
                    garazaPickup = 1239;
                }

                // Odredjivanje koordinata pickupa
                new Float:pPos[2];
                pPos[0] = RealEstate[gid][RE_GARAZA][0] + 4*floatcos(90-RealEstate[gid][RE_GARAZA][3], degrees);
                pPos[1] = RealEstate[gid][RE_GARAZA][1] - 4*floatsin(90-RealEstate[gid][RE_GARAZA][3], degrees);
                
                // 3D text
                new string[110];
                format(string, sizeof string, "{FFFF00}Kucna garaza\n\n[ {FFFFFF}%d, %s {FFFF00}]", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA]);
                if (RealEstate[gid][RE_LABEL_2] != Text3D:INVALID_3DTEXT_ID)
                {
                    UpdateDynamic3DTextLabelText(RealEstate[gid][RE_LABEL_2], 0xFFFF00CC, string);
                }
                else
                {
                    RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel(string, 0xFFFF00CC, pPos[0], pPos[1], floatadd(RealEstate[gid][RE_GARAZA][2], 0.5), 15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 100.0);
                }

                // Pickupi
                if (RealEstate[gid][RE_PICKUP_VEHICLE] != -1) DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_VEHICLE]);
                RealEstate[gid][RE_PICKUP_VEHICLE] = CreateDynamicPickup(garazaPickup, 14, pPos[0], pPos[1], RealEstate[gid][RE_GARAZA][2], 0, 0); // Vehicle pickup za ulaz

                if (RealEstate[gid][RE_PICKUP_GARAGE_ENTER] != -1) DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_ENTER]);
                RealEstate[gid][RE_PICKUP_GARAGE_ENTER] = CreateDynamicPickup(garazaPickup, 1, pPos[0], pPos[1], RealEstate[gid][RE_GARAZA][2], 0, 0); // On-foot pickup za ulaz

                if (RealEstate[gid][RE_PICKUP_GARAGE_EXIT] != -1) DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_EXIT]);
                RealEstate[gid][RE_PICKUP_GARAGE_EXIT] = CreateDynamicPickup(19134, 1, -561.55, -2000.4, -5.61, 0, 0, gid, RealEstate[gid][RE_ENT]); // On-foot pickup za izlaz
            }
	    }
	    case stan:
	    {
	        boja = 0xFFC081CC;
			if (!vlasnik) // Nema vlasnika
			{
			    pickup = 1273;
			    add    = 0.5;
			    format(string_256, sizeof string_256, "{FFC081}Stan na prodaju!\n\n[ {FFFFFF}%d, %s {FFC081}]\nNivo: {FFFFFF}%d | {FFC081}Cena: {FFFFFF}%s\nDa kupite ovaj stan upisite {FFC081}/kupi", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			}
			else // Ima vlasnika
			{
			    format(string_256, sizeof string_256, "{FFC081}[ {FFFFFF}%d, %s {FFC081}]\nNivo: {FFFFFF}%d | {FFC081}Vlasnik: {FFFFFF}%s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
			}
	    }
	    case firma:
	    {
	        boja = 0x81C0FFCC;
			if (!vlasnik) // Nema vlasnika
			{
			    pickup = 1272;
			    add    = 0.5;
                if(RealEstate[gid][RE_NIVO] == 98) format(string_256, sizeof string_256, "{81C0FF}%s [NA DONACIJU!]\n\n[ {FFFFFF}%d, %s {81C0FF}]\nNivo: {FFFFFF}%d | {81C0FF}Cena: {FFFFFF}%s\nDa kupite ovu firmu upisite {81C0FF}/kupi", vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_CAPITAL), RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			    else format(string_256, sizeof string_256, "{81C0FF}%s na prodaju!\n\n[ {FFFFFF}%d, %s {81C0FF}]\nNivo: {FFFFFF}%d | {81C0FF}Cena: {FFFFFF}%s\nDa kupite ovu firmu upisite {81C0FF}/kupi", vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_CAPITAL), RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			}
			else // Ima vlasnika
			{
                format(string_256, sizeof string_256, "{81C0FF}[ {FFFFFF}%s {81C0FF}]\nAdresa: {FFFFFF}%s, %d\n{81C0FF}Nivo: {FFFFFF}%d | {81C0FF}Vlasnik: {FFFFFF}%s", BizInfo[re_localid(firma, gid)][BIZ_NAZIV], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_ID], RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
			}

            new mapIcon = -1;
            switch (RealEstate[gid][RE_VRSTA]) {
                case FIRMA_PRODAVNICA:      mapIcon = 56;
                case FIRMA_ORUZARNICA:      mapIcon = 6;
                // case FIRMA_TECHNOLOGY:      mapIcon = ;
                // case FIRMA_HARDWARE:        mapIcon = ;
                case FIRMA_RESTORAN:        mapIcon = 50;
                case FIRMA_KAFIC:           mapIcon = 49;
                case FIRMA_BAR:             mapIcon = 49;
                case FIRMA_DISKOTEKA:       mapIcon = 48;
                case FIRMA_BUTIK:           mapIcon = 45;
                // case FIRMA_SEXSHOP:         mapIcon = ;
                case FIRMA_BURGERSHOT:      mapIcon = 10;
                case FIRMA_PIZZASTACK:      mapIcon = 29;
                case FIRMA_CLUCKINBELL:     mapIcon = 14;
                case FIRMA_RANDYSDONUTS:    mapIcon = 50;
                case FIRMA_TERETANA:        mapIcon = 54;
                // case FIRMA_SECURITYSHOP:    mapIcon = ?;
                case FIRMA_RENTACAR:        mapIcon = 55;
                case FIRMA_KIOSK:           mapIcon = 56;
                case FIRMA_BENZINSKA:       mapIcon = 8;
                case FIRMA_MEHANICAR:       mapIcon = 27;
                case FIRMA_TUNING:          mapIcon = 63;
                case FIRMA_APOTEKA:         mapIcon = 22;
                case FIRMA_BOLNICA:         mapIcon = 22;
                // case FIRMA_ACCESSORY:       mapIcon = 45;
                default:                    mapIcon = -1;
            }

            if (mapIcon != -1) 
                CreateDynamicMapIcon(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], mapIcon, BELA, 0, 0);
	    }
	    case hotel:
	    {
	        boja = 0x8080FFCC;
			if (!vlasnik) // Nema vlasnika
			{
			    pickup = 1273;
			    add    = 0.5;
			    format(string_256, sizeof string_256, "{8080FF}Hotel na prodaju!\n\n[ {FFFFFF}%d, %s {8080FF}]\nNivo: {FFFFFF}%d | {8080FF}Cena: {FFFFFF}%s\nDa kupite ovaj hotel upisite {8080FF}/kupi",
			        RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			}
			else // Ima vlasnika
			{
			    format(string_256, sizeof string_256, "{8080FF}[ {FFFFFF}%d, %s {8080FF}]\nNivo: {FFFFFF}%d | {8080FF}Vlasnik: {FFFFFF}%s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA],
					RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
			}
	    }
	    case garaza:
	    {
	        boja = 0xFF9900CC;
			if (!vlasnik) // Nema vlasnika
			{
			    pickup = 19523;
			    add    = 0.5;
			    format(string_256, sizeof string_256, "{FF9900}Garaza na prodaju!\n\n[ {FFFFFF}%d, %s {FF9900}]\nNivo: {FFFFFF}%d | {FF9900}Cena: {FFFFFF}%s\nDa kupite ovu firmu upisite {FF9900}/kupi",
			        RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
			}
			else // Ima vlasnika
			{
			    format(string_256, sizeof string_256, "{FF9900}[ {FFFFFF}%d, %s {FF9900}]\nNivo: {FFFFFF}%d | {FF9900}Vlasnik: {FFFFFF}%s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA],
					RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
			}
	    }
        case vikendica:
        {
            boja = 0x6622FFCC;
            if (!vlasnik) // Nema vlasnika
            {
                pickup = 19523;
                add    = 0.5;
                format(string_256, sizeof string_256, "{FF9900}Vikendica na prodaju!\n\n[ {FFFFFF}%d, %s {FF9900}]\nNivo: {FFFFFF}%d | {FF9900}Cena: {FFFFFF}%s\nDa kupite ovu firmu upisite {FF9900}/kupi",
                    RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA], RealEstate[gid][RE_NIVO], formatMoneyString(RealEstate[gid][RE_CENA]));
            }
            else // Ima vlasnika
            {
                format(string_256, sizeof string_256, "{FF9900}[ {FFFFFF}%d, %s {FF9900}]\nNivo: {FFFFFF}%d | {FF9900}Vlasnik: {FFFFFF}%s", RealEstate[gid][RE_ID], RealEstate[gid][RE_ADRESA],
                    RealEstate[gid][RE_NIVO], RealEstate[gid][RE_VLASNIK]);
            }
        }
	}

    // Dodavanje stringa za neaktivnost
    if (vlasnik && RealEstate[gid][RE_OWNER_LAST_ONLINE] > 0)
    {
        new inactivityLimit = 1800000; // 500 sati = 1800000 sekundi

        new remainingTime = RealEstate[gid][RE_OWNER_LAST_ONLINE] + inactivityLimit - gettime(), // vreme u sekundama preostalo do skidanja imovine
            displayTimeSec = inactivityLimit - remainingTime, // sekunde
            displayTimeHrs = floatround(displayTimeSec/3600.0, floatround_ceil)
        ;

        if (remainingTime <= 1800 || displayTimeHrs >= 500) // 30 minuta
        {
            // Ostalo manje od pola sata ili je isteklo -> skidaj
            RE_SetOnBuy(vrsta, gid);

            new logStr[48];
            format(logStr, sizeof logStr, "%s - PRODAJA (NEAKTIVNOST) | ID: %i", propname(vrsta, PROPNAME_UPPER), RealEstate[gid][RE_ID]);
            Log_Write(LOG_IMOVINA, logStr);

            return 1; // re_kreirajpickup ce se pozvati ponovo unutar RE_SetOnBuy
        }
        else
        {
            // Jos nije doslo vreme za skidanje
            new displayColor[7];

            if (displayTimeHrs <= 72)                               displayColor = "34CC33";
            else if (displayTimeHrs > 72 && displayTimeHrs <= 145)  displayColor = "66FA32";
            else if (displayTimeHrs > 145 && displayTimeHrs <= 217) displayColor = "9AFA33";
            else if (displayTimeHrs > 217 && displayTimeHrs <= 289) displayColor = "FFFB01";
            else if (displayTimeHrs > 289 && displayTimeHrs <= 361) displayColor = "FFC000";
            else if (displayTimeHrs > 361 && displayTimeHrs <= 433) displayColor = "F79646";
            else if (displayTimeHrs > 433)                          displayColor = "FF2500";

            format(string_256, sizeof string_256, "%s\n\n{FFFFFF}Neaktivnost: {%s}%i/500", string_256, displayColor, displayTimeHrs);
        }
    }

	// Kreiranje standardnog pickupa za ulaz i labela
	if (RealEstate[gid][RE_LABEL] != Text3D:INVALID_3DTEXT_ID)
	{
		UpdateDynamic3DTextLabelText(RealEstate[gid][RE_LABEL], boja, string_256);
	}
	else {
        RealEstate[gid][RE_LABEL] = CreateDynamic3DTextLabel(string_256, boja, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], floatadd(RealEstate[gid][RE_ULAZ][2], add), 15, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 100.0);
    }

	// Kreiranje vehicle pickupa za ulaz
	if (RealEstate[gid][RE_PICKUP_ENTRANCE] != -1) DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_ENTRANCE]);
	RealEstate[gid][RE_PICKUP_ENTRANCE] = CreateDynamicPickup(pickup, 1, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], 0, 0); // Onfoot pickup
	
    if (vrsta == garaza)
	{
	    if (RealEstate[gid][RE_PICKUP_VEHICLE] != -1) DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_VEHICLE]);
		RealEstate[gid][RE_PICKUP_VEHICLE] = CreateDynamicPickup(pickup, 14, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], 0, 0); // Vehicle pickup
	}

	// Kreiranje pickupa za izlaz
	if (RealEstate[gid][RE_PICKUP_EXIT] == -1 && RealEstate[gid][RE_VRSTA] != FIRMA_KIOSK)
	{
	    RealEstate[gid][RE_PICKUP_EXIT] = CreateDynamicPickup(19134, 1, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], gid, RealEstate[gid][RE_ENT]);
	}

	return 1;
}

RE_GetPlayerPickupGID(playerid)
{
    return gPropertyPickupGID[playerid];
}

RE_IsPlayerAtEntrance(playerid, gid)
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]))
    {
        return true;
    }
    return false;
}

RE_IsPlayerAtInteract(playerid, gid)
{
    if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]))
    {
        return true;
    }
    return false;
}

RE_GetInterior(gid)
{
    return RealEstate[gid][RE_ENT];
}

RE_GetEntrancePos(gid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    x = RealEstate[gid][RE_ULAZ][0];
    y = RealEstate[gid][RE_ULAZ][1];
    z = RealEstate[gid][RE_ULAZ][2];
    a = RealEstate[gid][RE_ULAZ][3];
}

RE_GetExitPos(gid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    x = RealEstate[gid][RE_IZLAZ][0];
    y = RealEstate[gid][RE_IZLAZ][1];
    z = RealEstate[gid][RE_IZLAZ][2];
    a = RealEstate[gid][RE_IZLAZ][3];
}

RE_SetOnBuy(vrsta, gid)
{
    new lid = re_localid(vrsta, gid);

    if (vrsta == firma) // Nekretnina je firma
    {
        // Resetuj ime firme
        format(BizInfo[lid][BIZ_NAZIV], 32, "%s", vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_CAPITAL));
    }
    
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    RealEstate[gid][RE_ZATVORENO] = 1;
    RealEstate[gid][RE_OWNER_LAST_ONLINE] = 0;
    RealEstate[gid][RE_NOVAC]       = 0;
    
    if (vrsta == firma) // Nekretnina je firma, pokreni poseban update query
    {
        BizInfo[lid][BIZ_REKET] = -1;
        BizInfo[lid][BIZ_NOVAC_REKET] = 0;

        new sQuery[170];
        mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE %s SET vlasnik = 'Niko', naziv = '%s', novac = 0, novac_reket = 0, reket = -1, zatvoreno = 1 WHERE id = %d", propname(vrsta, PROPNAME_TABLE), BizInfo[lid][BIZ_NAZIV], RealEstate[gid][RE_ID]);
        mysql_tquery(SQL, sQuery);
    }
    else if (vrsta == kuca) // Nekretnina je kuca, pokreni poseban update query + brisanje svih kupljenih predmeta + otpustanje stanara
    {
        RealEstate[gid][RE_GARAZA_OTKLJUCANA] = 0;
            
        // Resetovanje varijabli za objekte
        for__loop (new i = 0; i < MAX_OBJEKATA; i++)
        {
            H_FURNITURE[lid][i][hf_uid]       = -1;
            H_FURNITURE[lid][i][hf_object_id] = -1;
            H_FURNITURE[lid][i][hf_price]     = 0;
            H_FURNITURE[lid][i][hf_name]      = EOS;
            if (H_FURNITURE[lid][i][hf_dynid] != -1)
            {
                DestroyDynamicObject(H_FURNITURE[lid][i][hf_dynid]);
                H_FURNITURE[lid][i][hf_dynid] = -1;
            }
        }

        // Resetovanje oruzja
        for__loop (new i = 0; i < 13; i++) {
            H_WEAPONS[lid][i][hw_weapon]  = -1;
            H_WEAPONS[lid][i][hw_ammo]    = 0;
        }

        // Otpustanje stanara
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_stanari WHERE k_id = %i", lid);
        mysql_tquery(SQL, mysql_upit);
        
        // Brisanje objekata iz baze
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_predmeti WHERE k_id = %d", lid);
        mysql_tquery(SQL, mysql_upit);

        // Brisanje oruzja iz baze
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_oruzje WHERE k_id = %d", lid);
        mysql_tquery(SQL, mysql_upit);
        
        // Update podataka u bazi (za kucu)
        new sQuery[140];
        format(sQuery, sizeof sQuery, "UPDATE %s SET vlasnik = 'Niko', novac = 0, zatvoreno = 1, garaza = '%.2f|%.2f|%.2f|%.2f|%i' WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], RealEstate[gid][RE_GARAZA_OTKLJUCANA], RealEstate[gid][RE_ID]);
        mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
    }
    else // Klasicna nekretnina, pokreni obican query
    {
        new sQuery[75];
        format(sQuery, sizeof sQuery, "UPDATE %s SET vlasnik = 'Niko', zatvoreno = 1 WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_ID]);
        mysql_tquery(SQL, sQuery);
    }

    re_kreirajpickup(vrsta, gid);
    return 1;
}

/*
  Vraca vrstu nekretnine (kuca/stan...)
*/
public re_odredivrstu(gid)
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "re_odredivrstu");
	#endif

	/*
	  Odredjuje vrstu nekretnine na osnovu globalnog ID-a
	*/
	new vrsta = -1;
	if (gid >= 0 && gid < MAX_KUCA) 
    {
        vrsta = kuca;
    }
	else if ((gid >= MAX_KUCA) && (gid < MAX_KUCA + MAX_STANOVA)) 
    {
        vrsta = stan;
    }
	else if ((gid >= MAX_KUCA + MAX_STANOVA) && (gid < MAX_KUCA + MAX_STANOVA + MAX_FIRMI)) 
    {
        vrsta = firma;
    }
	else if ((gid >= MAX_KUCA + MAX_STANOVA + MAX_FIRMI) && (gid < MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA)) 
    {
        vrsta = hotel;
    }
	else if ((gid >= MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA) && (gid < MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA)) 
    {
        vrsta = garaza;
    }
    else if ((gid >= MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA) && (gid < MAX_KUCA + MAX_STANOVA + MAX_FIRMI + MAX_HOTELA + MAX_GARAZA + MAX_VIKENDICA)) 
    {
        vrsta = vikendica;
    }
	else
	{
	    printf("Nemoguce odrediti vrstu nekretnine (gid: %d)", gid);
	}

	return vrsta;
}

RealEstate_ChooseProperty(playerid, iEstate)
{
    if (iEstate < 0 || iEstate >= sizeof pRealEstate[]) return 0;

    if (RealEstate_CheckPlayerPosession(playerid, iEstate) == 0)
    {
        ErrorMsg(playerid, "Ne posedujes %s.", propname(iEstate, PROPNAME_AKUZATIV));
        return 0;
    }

    new estateCount = 0, id = -1;
    for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][iEstate]; i++)
    {
        if (i >= RE_MAX_SLOTS) break;

        if (pRealEstate[playerid][iEstate][i] > 0)
        {
            estateCount ++;
            id = pRealEstate[playerid][iEstate][i];
        }
    }
        

    SetPVarInt(playerid, "RE_Listing", iEstate);
    if (estateCount == 1)
    {
        // Ako poseduje samo jednu nekretninu ove vrste, otvoriti mu odmah upravljanje tom nekretninom
        new sInputtext[4];
        valstr(sInputtext, id);
        dialog_respond:estateList(playerid, 1, 0, sInputtext);
        return 1;
    }
    else if (estateCount > 1)
    {
        // Ako poseduje vise imanja, prikazati mu listu
        new 
            sDialog[60 * RE_MAX_SLOTS], 
            sZone[32]
        ;
        sDialog[0] = EOS;
        for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][iEstate]; i++)
        {
            new 
                lid = pRealEstate[playerid][iEstate][i],
                gid = re_globalid(iEstate, lid)
            ;
            if (RealEstate_Exists(iEstate, lid))
            {
                Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], sZone, sizeof sZone);
                format(sDialog, sizeof sDialog, "%s\n%i\t%s %i\t%s", sDialog, lid, propname(iEstate, PROPNAME_CAPITAL), i+1, sZone);
            }
        }

        SPD(playerid, "estateList", DIALOG_STYLE_LIST, "{FFFFFF}Izbor nekretnine", sDialog, "Dalje", "Izadji");
        return 1;
    }
    else
    {
        ErrorMsg(playerid, "Ne posedujes %s.", propname(iEstate, PROPNAME_AKUZATIV));
        return 0;
    }
}

RealEstate_GetPlayerSlots(playerid, iEstate)
{
    return PI[playerid][p_nekretnine_slotovi][iEstate];
}

RealEstate_Exists(iEstate, lid)
{
    if (lid >= 0 && lid <= real_estate_maxID[iEstate])
    {
        return 1;
    }
    return 0;
}

RealEstate_CheckPlayerPosession(playerid, iEstate)
{
    if (iEstate < 0 || iEstate >= sizeof pRealEstate[]) return 0;

    new estateCount = 0;
    for__loop (new i = 0; i < RE_MAX_SLOTS; i++)
    {
        if (pRealEstate[playerid][iEstate][i] != -1)
            estateCount ++;
    }

    return estateCount;
}

RealEstate_GetPlayerFreeSlots(playerid, iEstate)
{
    if (iEstate < 0 || iEstate >= sizeof pRealEstate[]) return 0;

    new freeSlots = 0;
    for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][iEstate]; i++)
    {
        if (pRealEstate[playerid][iEstate][i] == -1)
        {
            freeSlots ++;
        }
    }

    return freeSlots;
}

RealEstate_CountPlayerEstate(playerid, iEstate)
{
    return PI[playerid][p_nekretnine_slotovi][iEstate] - RealEstate_GetPlayerFreeSlots(playerid, iEstate);
}

/*
  Inicijalizacija igracevih nekretnina prilikom login-a
*/
RealEstate_PlayerLogin(playerid)
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "RealEstate_PlayerLogin");
    #endif

    // U bazi podataka trazimo nekretnine koje pripadaju ovom igracu
    for__loop (new i = kuca; i <= vikendica; i++)
    {
        new sQuery[85];
        mysql_format(SQL, sQuery, sizeof sQuery, "SELECT id FROM %s WHERE vlasnik = '%s'", propname(i, PROPNAME_TABLE), ime_obicno[playerid]);
        mysql_tquery(SQL, sQuery, "MySQL_LoadPlayerEstate", "iii", playerid, cinc[playerid], i);
    }

	return 1;
}

/*
  Vraca vrstu firme (prodavnica/oruzarnica/...)
*/
stock vrstafirme(vrsta, oblik)
{
	#if defined DEBUG_FUNCTIONS
	    Debug("function", "vrstafirme");
	#endif

	new
		string[23]
	;

 	switch (oblik)
 	{
 	    case PROPNAME_UPPER:
 	    {
 	        switch (vrsta)
 	        {
		 	    case FIRMA_PRODAVNICA: 	   string = "PRODAVNICA";
		 	    case FIRMA_ORUZARNICA: 	   string = "ORUZARNICA";
		 	    case FIRMA_TECHNOLOGY: 	   string = "TECH STORE";
		 	    case FIRMA_HARDWARE:   	   string = "PRODAVNICA ALATA";
		 	    case FIRMA_RESTORAN:       string = "RESTORAN";
				case FIRMA_KAFIC:          string = "KAFIC";
				case FIRMA_BAR:            string = "BAR";
				case FIRMA_DISKOTEKA:      string = "DISKOTEKA";
				case FIRMA_BUTIK:          string = "BUTIK";
				case FIRMA_SEXSHOP:        string = "SEX SHOP";
				case FIRMA_BURGERSHOT:     string = "BURGER SHOT";
				case FIRMA_PIZZASTACK:     string = "PIZZA STACK";
				case FIRMA_CLUCKINBELL:    string = "CLUCKIN' BELL";
				case FIRMA_RANDYSDONUTS:   string = "RANDY'S DONUTS";
				case FIRMA_TERETANA:       string = "TERETANA";
                case FIRMA_SECURITYSHOP:   string = "SECURITY SHOP";
                case FIRMA_PIJACA:         string = "PIJACA";
                case FIRMA_RENTACAR:       string = "RENT-A-CAR";
				case FIRMA_KIOSK:          string = "KIOSK";
                case FIRMA_BENZINSKA:      string = "BENZINSKA PUMPA";
                case FIRMA_POSAO:          string = "POSAO";
                case FIRMA_MEHANICAR:      string = "MEHANICARSKA RADIONICA";
                case FIRMA_TUNING:         string = "TUNING GARAZA";
                case FIRMA_DRUGO:          string = "FIRMA";
                case FIRMA_APOTEKA:        string = "APOTEKA";
                case FIRMA_BOLNICA:        string = "BOLNICA";
                case FIRMA_ACCESSORY:      string = "ACCESSORY SHOP";
		 	    default: 				   string = "GRESKA";
			}
		}
		case PROPNAME_CAPITAL:
		{
			switch (vrsta)
			{
			    case FIRMA_PRODAVNICA: 	   string = "Prodavnica";
		 	    case FIRMA_ORUZARNICA: 	   string = "Oruzarnica";
		 	    case FIRMA_TECHNOLOGY: 	   string = "Tech Store";
		 	    case FIRMA_HARDWARE:   	   string = "Prodavnica alata";
		 	    case FIRMA_RESTORAN:       string = "Restoran";
				case FIRMA_KAFIC:          string = "Kafic";
				case FIRMA_BAR:            string = "Bar";
				case FIRMA_DISKOTEKA:      string = "Diskoteka";
				case FIRMA_BUTIK:          string = "Butik";
				case FIRMA_SEXSHOP:        string = "Sex Shop";
				case FIRMA_BURGERSHOT:     string = "Burger Shot";
				case FIRMA_PIZZASTACK:     string = "Pizza Stack";
				case FIRMA_CLUCKINBELL:    string = "Cluckin' Bell";
				case FIRMA_RANDYSDONUTS:   string = "Randy's Donuts";
				case FIRMA_TERETANA:       string = "Teretana";
				case FIRMA_SECURITYSHOP:   string = "Security Shop";
                case FIRMA_PIJACA:         string = "Pijaca";
                case FIRMA_RENTACAR:       string = "Rent-a-car";
                case FIRMA_KIOSK:          string = "Kiosk";
                case FIRMA_BENZINSKA:      string = "Benzinska pumpa";
                case FIRMA_POSAO:          string = "Posao";
                case FIRMA_MEHANICAR:      string = "Mehanicarska radionica";
                case FIRMA_TUNING:         string = "Tuning garaza";
                case FIRMA_DRUGO:          string = "Firma";
                case FIRMA_APOTEKA:        string = "Apoteka";
                case FIRMA_BOLNICA:        string = "Bolnica";
                case FIRMA_ACCESSORY:      string = "Accessory Shop";
		 	    default: 				   string = "GRESKA";
			}
		}
 	}

	return string;
}

stock IsFoodBusiness(gid)
{
    if (RealEstate[gid][RE_VRSTA] == FIRMA_RESTORAN || RealEstate[gid][RE_VRSTA] == FIRMA_KAFIC || RealEstate[gid][RE_VRSTA] == FIRMA_BAR || RealEstate[gid][RE_VRSTA] == FIRMA_DISKOTEKA || RealEstate[gid][RE_VRSTA] == FIRMA_BURGERSHOT || RealEstate[gid][RE_VRSTA] == FIRMA_PIZZASTACK || RealEstate[gid][RE_VRSTA] == FIRMA_CLUCKINBELL || RealEstate[gid][RE_VRSTA] == FIRMA_RANDYSDONUTS) return 1;
    else return 0;
}

stock Is24_7Business(gid)
{
    if (RealEstate[gid][RE_VRSTA] == FIRMA_PRODAVNICA || RealEstate[gid][RE_VRSTA] == FIRMA_KIOSK) return 1;
    else return 0;
}

stock IsClothingBusiness(gid)
{
    if (RealEstate[gid][RE_VRSTA] == FIRMA_BUTIK) return 1;
    else return 0;
}


stock IsTechBusiness(gid)
{
    if (RealEstate[gid][RE_VRSTA] == FIRMA_TECHNOLOGY) return 1;
    else return 0;
}

public re_proveri_hotel(playerid)
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "re_proveri_hotel");
    #endif
        
	if (!IsPlayerConnected(playerid))
		return 1;
		
	if (PI[playerid][p_hotel_soba] == -1)
		return 1;
		
	if (PI[playerid][p_hotel_cena] == 0)
		return 1;
		
	
	new
        lid = PI[playerid][p_hotel_soba],
		gid = re_globalid(hotel, lid);
	
	new x = 0;
	for__loop (new i = 0; i < RealEstate[gid][RE_SLOTOVI]; i++)
	{
		if (RE_HOTELS[lid][i][rh_player_id] == PI[playerid][p_id])
		{
			x ++;
			break;
		}
	}
	if (x == 0) // Izbacen iz hotela
	{
		// Update varijabli
		PI[playerid][p_hotel_soba] = -1;
		PI[playerid][p_hotel_cena] = 0;
		
		// Slanje poruke igracu
		SendClientMessage(playerid, TAMNOCRVENA, "* Izbaceni ste iz hotela u kome ste iznajmljivali sobu.");
	
		// Promena spawna
		dialog_respond:spawn(playerid, 1, 0, "");
	
		// Update igracevih podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_soba = -1, hotel_cena = 0 WHERE id = %d", PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit);
			
		return 1;
	}
	else // U hotelu je, proveriti da li je cena ista
	{
		if (RealEstate[gid][RE_CENA_SOBE] > PI[playerid][p_hotel_cena]) // Poskupelo
		{		
			SendClientMessageF(playerid, ZUTA, "Cena sobe u hotelu je povecana sa {FFFFFF}$%d {FFFF00}na {FFFFFF}$%d.", PI[playerid][p_hotel_cena], RealEstate[gid][RE_CENA_SOBE]);
			SendClientMessage(playerid, ZUTA, "Ukoliko Vam nova cena ne odgovara, koristite {FFFFFF}/odjavisobu {FFFF00}da napustite hotel.");
		}
		else if(RealEstate[gid][RE_CENA_SOBE] < PI[playerid][p_hotel_cena]) // Pojeftinilo
		{
			SendClientMessageF(playerid, ZUTA, "Cena sobe u hotelu je smanjena sa {FFFFFF}$%d {FFFF00}na {FFFFFF}$%d.", PI[playerid][p_hotel_cena], 
                RealEstate[gid][RE_CENA_SOBE]);
		}
		else return 1;
			
			
		PI[playerid][p_hotel_cena] = RealEstate[gid][RE_CENA_SOBE];
	
		// Update igracevih podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_cena = %d WHERE id = %d", PI[playerid][p_hotel_cena], PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit);
	}

	return 1;
}

stock resetuj_prodaju(playerid)
{
    RE_sellingTo_Name[playerid][0]      = EOS;
    RE_buyingFrom_Name[playerid][0]     = EOS;
    RE_sellingPrice[playerid]           = 0;
    RE_sellingTo[playerid]              = 0;
    RE_sellingType[playerid]            = -1;
    RE_buyingPrice[playerid]            = 0;
    RE_buyingFrom[playerid]             = -1;
}

// Dodavanje novca u kasu firme (i reket kasu)
public re_firma_dodaj_novac(gid, iznos) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("re_firma_dodaj_novac");
    }

    if (!strcmp(RealEstate[gid][RE_VLASNIK], "Niko", true))
        return 1; // Nema dodavanja novca ako firma nema vlasnika!
    
    new lid = re_localid(firma, gid);

    if (BizInfo[lid][BIZ_REKET] != -1)
    {
        // Firma ima reket -> 20% ide u reket kasu, preostalih 80% u kasu firme
        BizInfo[lid][BIZ_NOVAC_REKET] += floatround(iznos * 0.2); // 20% za reket
        RealEstate[gid][RE_NOVAC]    += floatround(iznos * 0.8); // 80% u kasu
    }
    else 
    {
        RealEstate[gid][RE_NOVAC] += iznos;
    }

    new sQuery[79];
    format(sQuery, sizeof sQuery, "UPDATE re_firme SET novac = %d, novac_reket = %d WHERE id = %d", RealEstate[gid][RE_NOVAC], BizInfo[lid][BIZ_NOVAC_REKET], lid);
    mysql_tquery(SQL, sQuery);
	return 1;
}

stock AdBizMoneyAdd(value)
{
    value = floatround(value/3.0*2);
    re_firma_dodaj_novac(re_globalid(firma, gAdvertisingBizID), value);
    return 1;
}

// Oduzimanje novca iz kase firme (i reket kase)
forward re_firma_oduzmi_novac(gid, iznos);
public re_firma_oduzmi_novac(gid, iznos) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("re_firma_oduzmi_novac");
    }

    if (!strcmp(RealEstate[gid][RE_VLASNIK], "Niko", true))
        return 1; // Nema oduzimanja novca ako firma nema vlasnika!
    
    new lid = re_localid(firma, gid);
        
    if (BizInfo[lid][BIZ_REKET] != -1)
    {
        // Firma ima reket -> 20% ide u reket kasu, preostalih 80% u kasu firme
        BizInfo[lid][BIZ_NOVAC_REKET] -= floatround(iznos * 0.2); // 20% za reket
        RealEstate[gid][RE_NOVAC]    -= floatround(iznos * 0.8); // 80% u kasu
    }
    else 
    {
        RealEstate[gid][RE_NOVAC] -= iznos;
    }

    new sQuery[79];
    format(sQuery, sizeof sQuery, "UPDATE re_firme SET novac = %d, novac_reket = %d WHERE id = %d", RealEstate[gid][RE_NOVAC], BizInfo[lid][BIZ_NOVAC_REKET], lid);
    mysql_tquery(SQL, sQuery);
    return 1;
}

stock RE_HouseAddMoney(gid, iznos)
{
    if (DebugFunctions())
    {
        LogFunctionExec("RE_HouseAddMoney");
    }

    RealEstate[gid][RE_NOVAC] += iznos;

    new query[50];
    format(query, sizeof query, "UPDATE re_kuce SET novac = %i WHERE id = %d", RealEstate[gid][RE_NOVAC], re_localid(kuca, gid));
    mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
    return 1;
}

stock RE_ChangeOwnerName(gid, const name[MAX_PLAYER_NAME])
{
    if (DebugFunctions())
    {
        LogFunctionExec("RE_ChangeOwnerName");
    }

    new query[85], vrsta = re_odredivrstu(gid);
    strmid(RealEstate[gid][RE_VLASNIK], name, 0, strlen(name), MAX_PLAYER_NAME);
    re_kreirajpickup(vrsta, gid);

    mysql_format(SQL, query, sizeof query, "UPDATE %s SET vlasnik = '%s' WHERE id = %i", propname(vrsta, PROPNAME_TABLE), name, re_localid(vrsta, gid));
    mysql_tquery(SQL, query);
}

stock re_firma_cenaGoriva(gid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("re_firma_cenaGoriva");
    }

        
    if (gid < 0 || gid >= MAX_REAL_ESTATE) return 0;
    if (RealEstate[gid][RE_VRSTA] != FIRMA_BENZINSKA) return 0;

    return F_PRODUCTS[re_localid(firma, gid)][48][f_cena];
} 

stock RE_GetMaxID_House()
{
    return real_estate_maxID[kuca];
}

stock RE_GetMaxID_Apartment()
{
    return real_estate_maxID[stan];
}

stock RE_GetMaxID_Business()
{
    return real_estate_maxID[firma];
}

stock RE_GetMaxID_Hotel()
{
    return real_estate_maxID[hotel];
}

stock RE_GetMaxID_Garage()
{
    return real_estate_maxID[garaza];
}

stock RE_GetMaxID_Cottage()
{
    return real_estate_maxID[vikendica];
}

stock IsBusinessWithInterior(gid)
{
    if (re_odredivrstu(gid) == firma)
    {
        new vrsta = RealEstate[gid][RE_VRSTA];
        if (vrsta == FIRMA_KIOSK || vrsta == FIRMA_RENTACAR || vrsta == FIRMA_BENZINSKA || vrsta == FIRMA_POSAO || vrsta == FIRMA_MEHANICAR || (RealEstate[gid][RE_ULAZ][0] == RealEstate[gid][RE_IZLAZ][0] && RealEstate[gid][RE_ULAZ][1] == RealEstate[gid][RE_IZLAZ][1])) // odredjena vrsta firme ILI iste koordinate ulaza i izlaza
        {
            return 0;
        }
        else return 1;
    }
    else return 1;
}

stock GetBusinessName(lid, szDest[], len)
{
    if (lid >= 1 && lid <= RE_GetMaxID_Business())
        format(szDest, len, "%s", BizInfo[lid][BIZ_NAZIV]);
}

stock GetRacketMoney(lid)
{
    if (lid >= 1 && lid <= RE_GetMaxID_Business())
        return BizInfo[lid][BIZ_NOVAC_REKET];
    
    else return 0;
}

stock RE_GetRobberyCooldown(gid)
{
    if (gid < 0 || gid >= MAX_REAL_ESTATE) return 0;
    
    return RealEstate[gid][RE_ROBBERY_COOLDOWN];
}

stock RE_CheckTenantStatus(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("RE_CheckTenantStatus");
    }

    if (PI[playerid][p_rent_kuca] <= 0) return 1;

    new query[74];
    format(query, sizeof query, "SELECT * FROM re_kuce_stanari WHERE k_id = %i AND pid = %i", PI[playerid][p_rent_kuca], PI[playerid][p_id]);
    mysql_tquery(SQL, query, "MYSQL_CheckTenantStatus", "ii", playerid, cinc[playerid]);
    return 1;
}

forward RE_UnlockEntrance(gid);
public RE_UnlockEntrance(gid)
{
    RealEstate[gid][RE_ZATVORENO] = 0;
}

forward RE_LockEntrance(gid); // Tajmer
public RE_LockEntrance(gid)
{
    RealEstate[gid][RE_ZATVORENO] = 1;
}

RealEstate_BuyHouseCar(playerid)
{
    if (RealEstate_CheckPlayerPosession(playerid, kuca) == 0)
        return ErrorMsg(playerid, "Ne posedujes kucu.");

    new 
        model = GetPVarInt(playerid, "pAutosalonModel"),
        price = GetPVarInt(playerid, "pAutosalonPrice"),
        lid   = GetPVarInt(playerid, "pAutosalonHouseID"),
        gid   = re_globalid(kuca, lid),
        priceGold = GetVehicleGoldPrice(price, PI[playerid][p_nivo])
    ;

    if (PI[playerid][p_novac] < price)
    {
        katalog_Cancel(playerid);
        ErrorMsg(playerid, "Nemas dovoljno novca za ovo vozilo. (%s)", formatMoneyString(price));
        return 1;
    }

    if (PI[playerid][p_zlato] < priceGold)
    {
        katalog_Cancel(playerid);
        ErrorMsg(playerid, "Nemas dovoljno zlatnika za ovo vozilo. (%i)", priceGold);
        return 1;
    }

    RealEstate[gid][RE_HC_MODEL] = model;

    katalog_Cancel(playerid);
    
    if (RealEstate[gid][RE_HC_MODEL] >= 400 && RealEstate[gid][RE_HC_MODEL] <= 611)
    {
        PlayerMoneySub(playerid, price);
        PI[playerid][p_zlato] -= priceGold;

        if (RealEstate[gid][RE_HC_VEHID] != -1)
        {
            DestroyVehicle(RealEstate[gid][RE_HC_VEHID]);
        }

        RealEstate[gid][RE_HC_VEHID] = CreateVehicle(RealEstate[gid][RE_HC_MODEL], RealEstate[gid][RE_HC_POS][0], RealEstate[gid][RE_HC_POS][1], RealEstate[gid][RE_HC_POS][2], RealEstate[gid][RE_HC_POS][3], -1, -1, 1000);

        new sQuery[118];
        format(sQuery, sizeof sQuery, "UPDATE re_kuce SET vehicle = '%i,%i,%.4f,%.4f,%.4f,%.4f' WHERE id = %i", lid, RealEstate[gid][RE_HC_MODEL], RealEstate[gid][RE_HC_POS][0], RealEstate[gid][RE_HC_POS][1], RealEstate[gid][RE_HC_POS][2], RealEstate[gid][RE_HC_POS][3], lid);
        mysql_tquery(SQL, sQuery);

        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, zlato = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        SendClientMessageF(playerid, SVETLOZELENA, "(kuca) {FFFFFF}Kupio si kucno vozilo: {00FF00}%s. {FFFFFF}  Vozilo je parkirano ispred tvoje kuce.", imena_vozila[RealEstate[gid][RE_HC_MODEL] - 400]);
    }
    else
    {
        ErrorMsg(playerid, #GRESKA_NEPOZNATO "(model: %i)", RealEstate[gid][RE_HC_MODEL]);
    }

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_addHouse(playerid, vrsta, ccinc);
forward mysql_addBusiness(playerid, vrsta, nivo, cena, naziv[], ccinc);
forward mysql_addApartment(playerid, ccinc);
forward mysql_addGarage(playerid, ccinc);
forward mysql_addCottage(playerid, ccinc);
forward re_kuce_oruzje();
forward mysql_re_hoteli_stanari(playerid, hotel_id, ccinc);


forward RE_MYSQL_LoadApartmentItems();
public RE_MYSQL_LoadApartmentItems()
{
    // Inicijalizacija svih vrednosti
    for__loop (new i = 0; i < MAX_STANOVA; i++)
    {
        for__loop (new j = 0; j < MAX_APT_CHEM_ITEMS; j++)
        {
            APT_CHEM[i][j][apt_chem_itemid] = -1;
            APT_CHEM[i][j][apt_chem_count] = 0;
        }
    }

    // Ucitavanje
    cache_get_row_count(rows);
    if (rows <= 0) return 1;

    new lid, itemid, count,
        lid_prev = -1, index = 0;

    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index_int(i, 0, lid);
        cache_get_value_index_int(i, 1, itemid);
        cache_get_value_index_int(i, 2, count);

        if (lid != lid_prev) index = 0;
        else index++;

        lid_prev = lid;

        if (index >= MAX_APT_CHEM_ITEMS) continue;

        APT_CHEM[lid][index][apt_chem_itemid] = itemid;
        APT_CHEM[lid][index][apt_chem_count] = count;
    }
    return 1;
}

forward MySQL_LoadPlayerEstate(playerid, ccinc, iEstate);
public MySQL_LoadPlayerEstate(playerid, ccinc, iEstate)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (rows)
    {
        new idx = 0;
        // TODO: provera za prekoracenje slotova
        for__loop (new i = 0; i < rows; i++)
        {
            new lid, gid;
            cache_get_value_index_int(i, 0, lid);

            pRealEstate[playerid][iEstate][idx++] = lid;
            gid = re_globalid(i, lid);

            // Azurirati last online time
            RealEstate[gid][RE_OWNER_LAST_ONLINE] = gettime();
            re_kreirajpickup(iEstate, gid);
        }
    }
    return 1;
}

public mysql_addHouse(playerid, vrsta, ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new
        nivo,
        cena,
        lid,
        gid,
        ulaz[42],
        izlaz[42],
        vrsta_text[13]
    ;

    cache_get_value_index_int(0, 0, lid);
    gid = re_globalid(kuca, lid);

    switch (vrsta)
    {
        case 1: // Prikolica
        {
            nivo = 3, cena = 15000, vrsta_text = "Prikolica";
            RealEstate[gid][RE_IZLAZ] = Float:{1.8542, -3.1205, 999.4284, 90.0};
            RealEstate[gid][RE_ENT] = 2;
        }
        case 2: // Mala kuca
        {
            nivo = 6, cena = 40000, vrsta_text = "Mala kuca";
            RealEstate[gid][RE_IZLAZ] = Float:{1398.3052, -21.9941, 1001.0, 270.0};
            RealEstate[gid][RE_ENT] = 5;
        }
        case 3: // Srednja kuca
        {
            nivo = 9, cena = 85000, vrsta_text = "Srednja kuca";
            RealEstate[gid][RE_IZLAZ] = Float:{1402.7360, -22.6733, 1001.1, 270.0};
            RealEstate[gid][RE_ENT] = 6;
        }
        case 4: // Velika kuca
        {
            nivo = 12, cena = 150000, vrsta_text = "Velika kuca";
            RealEstate[gid][RE_IZLAZ] = Float:{1402.7360, -22.6733, 1001.1, 270.0};
            RealEstate[gid][RE_ENT] = 7;
        }
        case 5: // Vila
        {
            nivo = 15, cena = 350000, vrsta_text = "Vila";
            RealEstate[gid][RE_IZLAZ] = Float:{-1273.6405, 1884.3213, 966.3909, 0.0};
            RealEstate[gid][RE_ENT] = 8;
        }
        default: return ErrorMsg(playerid, "Nepoznat unos za polje \"vrsta\".");
    }

    real_estate_maxID[kuca] ++;

    // Podesavanje default vrednosti
    RealEstate[gid][RE_ID]        = lid;
    RealEstate[gid][RE_NIVO]      = nivo;
    RealEstate[gid][RE_CENA]      = cena;
    RealEstate[gid][RE_ZATVORENO] = 1;
    RealEstate[gid][RE_VRSTA]     = vrsta;
    RealEstate[gid][RE_NOVAC]     = 0;
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    GetPlayerPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    GetPlayerFacingAngle(playerid, RealEstate[gid][RE_ULAZ][3]);
    format(ulaz, sizeof(ulaz),   "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2],  RealEstate[gid][RE_ULAZ][3]);
    format(izlaz, sizeof(izlaz), "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);
    printf("izlaz = %s", izlaz);

    Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

    // Kreiranje pickupa
    RealEstate[gid][RE_LABEL]    = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_LABEL_2]   = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_PICKUP_ENTRANCE]  = -1;
    RealEstate[gid][RE_PICKUP_EXIT]  = -1;
    RealEstate[gid][RE_PICKUP_VEHICLE]  = -1;
    RealEstate[gid][RE_PICKUP_GARAGE_EXIT] = -1;
    RealEstate[gid][RE_PICKUP_GARAGE_ENTER] = -1;
    re_kreirajpickup(kuca, gid);

    // Insertovanje u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_kuce (vlasnik,vrsta,nivo,cena,ent,zatvoreno,novac,ulaz,izlaz) VALUES ('Niko',%d,%d,%d,%d,1,0,'%s','%s')",
    vrsta, nivo, cena, RealEstate[gid][RE_ENT], ulaz, izlaz);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
    printf("mysql_upit = %s", mysql_upit);

    // Ispisivanje poruke adminu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dodali kucu. (id: %d)", lid);

    // Upisivanje u log
    format(string_128, sizeof string_128, "KUCA | DODAVANJE | Izvrsio: %s | %s | ID: %d", ime_obicno[playerid], vrsta_text, lid);
    Log_Write(LOG_AIMOVINA, string_128);
    return 1;
}


public mysql_addBusiness(playerid, vrsta, nivo, cena, naziv[], ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new
        lid,
        gid,
        ulaz[42],
        izlaz[42],
        interact[42];


    cache_get_value_index_int(0, 0, lid);
    gid = re_globalid(firma, lid);


    // Interact pozicije
    if (vrsta == FIRMA_KIOSK || vrsta == FIRMA_BENZINSKA) 
    {
        RealEstate[gid][RE_INTERACT][0] = GetPVarFloat(playerid, "pInteractX");
        RealEstate[gid][RE_INTERACT][1] = GetPVarFloat(playerid, "pInteractY");
        RealEstate[gid][RE_INTERACT][2] = GetPVarFloat(playerid, "pInteractZ");
    
        GetPlayerPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]);
        GetPlayerFacingAngle(playerid, RealEstate[gid][RE_IZLAZ][3]);
    }


    // Dodavanje proizvoda
    switch (vrsta) 
    {
        case FIRMA_BENZINSKA: 
        {
            RealEstate[gid][RE_ENT] = 0;
            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi VALUES (%d, 48, %d, 2000)", lid, PRODUCTS[48][pr_cena]);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_KIOSK: 
        {
            RealEstate[gid][RE_ENT] = 0;
            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 1), (%d, 2), (%d, 8), (%d, 9), (%d, 32), (%d, 36), (%d, 49)", lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_PRODAVNICA: 
        {
            switch (random(3))
            {
                case 0:
                {
                    RealEstate[gid][RE_ENT]      = 17;
                    RealEstate[gid][RE_IZLAZ]    = Float:{-25.9599, -188.042, 1003.55, 0.0};
                    RealEstate[gid][RE_INTERACT] = Float:{-29.1341, -184.7661, 1003.5469};
                }
                case 1:
                {
                    RealEstate[gid][RE_ENT]      = 18;
                    RealEstate[gid][RE_IZLAZ]    = Float:{-30.9628, -91.8244, 1003.55, 0.0};
                    RealEstate[gid][RE_INTERACT] = Float:{-28.1984, -89.5208, 1003.5469};
                }
                case 2:
                {
                    RealEstate[gid][RE_ENT]      = 10;
                    RealEstate[gid][RE_IZLAZ]    = Float:{6.0463, -31.5751, 1003.55, 0.0};
                    RealEstate[gid][RE_INTERACT] = Float:{2.0757, -28.8392, 1003.5494};
                }
            }

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 1), (%d, 2), (%d, 3), (%d, 4), (%d, 5), (%d, 6), (%d, 7), (%d, 8), (%d, 9), (%d, 10), (%d, 11)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_ORUZARNICA: 
        {
            RealEstate[gid][RE_ENT]      = 6;
            RealEstate[gid][RE_IZLAZ]    = Float:{316.4064, -170.2960, 999.5938, 0.0};
            RealEstate[gid][RE_INTERACT] = Float:{312.3180, -165.9008, 999.6010};

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 12), (%d, 13), (%d, 42), (%d, 14), (%d, 15), (%d, 16), (%d, 17), (%d, 43), (%d, 44), (%d, 18), (%d, 19), (%d, 20), (%d, 11)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_CLUCKINBELL: 
        {
            RealEstate[gid][RE_ENT]      = 9;
            RealEstate[gid][RE_IZLAZ]    = Float:{364.957, -11.8245, 1001.85, 0.0};
            RealEstate[gid][RE_INTERACT] = Float:{369.3488, -6.0354, 1001.8516};

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 84), (%d, 85), (%d, 86), (%d, 87), (%d, 88), (%d, 89), (%d, 90), (%d, 91), (%d, 92), (%d, 73), (%d, 93), (%d, 94)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_PIZZASTACK: 
        {
            RealEstate[gid][RE_ENT]      = 5;
            RealEstate[gid][RE_IZLAZ]    = Float:{372.498, -133.458, 1001.49, 0.0};
            RealEstate[gid][RE_INTERACT] = Float:{373.8392, -118.8041, 1001.4922};

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 76), (%d, 77), (%d, 78), (%d, 79), (%d, 80), (%d, 81), (%d, 82), (%d, 83)", lid, lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_RESTORAN: 
        {
            switch (random(2))
            {
                case 0:
                {
                    RealEstate[gid][RE_ENT]      = 4;
                    RealEstate[gid][RE_IZLAZ]    = Float:{460.2551, -88.6550, 999.5547, 90.0};
                    RealEstate[gid][RE_INTERACT] = Float:{450.5651, -83.6518, 999.5547};
                }
                case 1:
                {
                    RealEstate[gid][RE_ENT]      = 1;
                    RealEstate[gid][RE_IZLAZ]    = Float:{-794.918, 489.349, 1376.2, 0.0};
                    RealEstate[gid][RE_INTERACT] = Float:{-783.0355, 500.4286, 1371.7422};
                }
            }

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 50), (%d, 51), (%d, 52), (%d, 53), (%d, 54), (%d, 55), (%d, 56), (%d, 57), (%d, 58), (%d, 59), (%d, 60), (%d, 61)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_SEXSHOP: 
        {
            RealEstate[gid][RE_ENT]      = 3;
            RealEstate[gid][RE_IZLAZ]    = Float:{-100.326, -24.8522, 1000.72, 0.0};
            RealEstate[gid][RE_INTERACT] = Float:{-105.1052, -10.8381, 1000.7188};

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
                (%d, 6), (%d, 38), (%d, 39), (%d, 40), (%d, 41)", lid, lid, lid, lid, lid);
            mysql_tquery(SQL, mysql_upit);
        }
        case FIRMA_APOTEKA:
        {
            RealEstate[gid][RE_ENT] = 1;
            RealEstate[gid][RE_IZLAZ]    = Float:{1957.5551, 947.9746, -34.9424, 90.0};
            RealEstate[gid][RE_INTERACT] = Float:{1950.9457, 948.3459, -35.0};
        }
        case FIRMA_ACCESSORY:
        {
            RealEstate[gid][RE_ENT] = 1;
            RealEstate[gid][RE_IZLAZ]    = Float:{2198.2881, 959.1854, -30.2806,  0.0};
            RealEstate[gid][RE_INTERACT] = Float:{2194.9626, 968.0716, -30.2806};
        }
    }

    // Podesavanje default vrednosti
    RealEstate[gid][RE_ID]             = lid;
    RealEstate[gid][RE_NIVO]           = nivo;
    RealEstate[gid][RE_CENA]           = cena;
    RealEstate[gid][RE_ZATVORENO]      = 1;
    RealEstate[gid][RE_VRSTA]          = vrsta;
    RealEstate[gid][RE_NOVAC]          = 0;
    BizInfo[lid][BIZ_NOVAC_REKET]      = 0;
    BizInfo[lid][BIZ_REKET]            = -1;
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    strmid(BizInfo[lid][BIZ_NAZIV], naziv, 0, strlen(naziv), 31);
    GetPlayerPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    GetPlayerFacingAngle(playerid, RealEstate[gid][RE_ULAZ][3]);

    format(ulaz, sizeof(ulaz),   "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2],  RealEstate[gid][RE_ULAZ][3]);
    format(izlaz, sizeof(izlaz), "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);
    format(interact, sizeof(interact), "%.4f|%.4f|%.4f", RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]);

    Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

    // Kreiranje pickupa
    RealEstate[gid][RE_LABEL]   = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_PICKUP_ENTRANCE] = -1;
    RealEstate[gid][RE_PICKUP_EXIT] = -1;
    RealEstate[gid][RE_PICKUP_VEHICLE] = -1;
    re_kreirajpickup(firma, gid);

    // Insertovanje u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme (vrsta,naziv,nivo,cena,ent,ulaz,izlaz,interact) VALUES (%d,'%s',%d,%d,%d,'%s','%s','%s')",
    vrsta, BizInfo[lid][BIZ_NAZIV], nivo, cena, RealEstate[gid][RE_ENT], ulaz, izlaz, interact);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEINSERT);

    // Ispisivanje poruke adminu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dodali firmu. (id: %d)", lid);

    // Upisivanje u log
    format(string_128, sizeof string_128, "FIRMA | DODAVANJE | Izvrsio: %s | %s | ID: %d", ime_obicno[playerid], vrstafirme(vrsta, PROPNAME_CAPITAL), lid);
    Log_Write(LOG_AIMOVINA, string_128);

    DeletePVar(playerid, "pInteractX");
    DeletePVar(playerid, "pInteractY");
    DeletePVar(playerid, "pInteractZ");
    return 1;
}

public mysql_addApartment(playerid, ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new
        nivo,
        cena,
        lid,
        gid,
        ulaz[42],
        izlaz[42],
        rand
    ;

    new Float:stan_enterijeri[6][5] = 
    {
        {2237.52, -1081.58, 1049.02, 0.0,   2.0},
        {422.454,  2536.60, 10.0,    90.0,  10.0},
        {2308.83, -1212.88, 1049.02, 0.0,   6.0},
        {2233.76, -1115.16, 1050.88, 0.0,   5.0},
        {2218.33, -1076.14, 1050.48, 90.0,  1.0},
        {2196.75, -1204.27, 1049.02, 90.0,  6.0}
    };

    rand = random(sizeof(stan_enterijeri));
    nivo = 3, cena = 10000;

    cache_get_value_index_int(0, 0, lid);
    gid = re_globalid(stan, lid);

    // Dodela enterijera
    RealEstate[gid][RE_IZLAZ][0] = stan_enterijeri[rand][0];
    RealEstate[gid][RE_IZLAZ][1] = stan_enterijeri[rand][1];
    RealEstate[gid][RE_IZLAZ][2] = stan_enterijeri[rand][2];
    RealEstate[gid][RE_IZLAZ][3] = stan_enterijeri[rand][3];
    RealEstate[gid][RE_ENT]     = floatround(stan_enterijeri[rand][4]);

    // Podesavanje default vrednosti
    RealEstate[gid][RE_ID]        = lid;
    RealEstate[gid][RE_NIVO]      = nivo;
    RealEstate[gid][RE_CENA]      = cena;
    RealEstate[gid][RE_ZATVORENO] = 1;
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    GetPlayerPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    GetPlayerFacingAngle(playerid, RealEstate[gid][RE_ULAZ][3]);
    format(ulaz, sizeof(ulaz),   "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2],  RealEstate[gid][RE_ULAZ][3]);
    format(izlaz, sizeof(izlaz), "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);

    Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

    // Kreiranje pickupa
    RealEstate[gid][RE_LABEL]   = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_PICKUP_ENTRANCE] = -1;
    RealEstate[gid][RE_PICKUP_EXIT] = -1;
    RealEstate[gid][RE_PICKUP_VEHICLE] = -1;
    re_kreirajpickup(stan, gid);

    // Insertovanje u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_stanovi (vlasnik,nivo,cena,ent,zatvoreno,ulaz,izlaz) VALUES ('Niko',%d,%d,%d,1,'%s','%s')",
    nivo, cena, RealEstate[gid][RE_ENT], ulaz, izlaz);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEINSERT);

    // Ispisivanje poruke adminu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dodali stan. (id: %d)", lid);

    // Upisivanje u log
    format(string_128, sizeof string_128, "STAN | DODAVANJE | Izvrsio: %s | ID: %d", ime_obicno[playerid], lid);
    Log_Write(LOG_AIMOVINA, string_128);
    return 1;
}

public mysql_addGarage(playerid, ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new
        nivo,
        cena,
        lid,
        gid,
        ulaz[42]
    ;

    nivo = 8, cena = 150000;

    cache_get_value_index_int(0, 0, lid);
    gid = re_globalid(garaza, lid);

    // Podesavanje default vrednosti
    RealEstate[gid][RE_ID]        = lid;
    RealEstate[gid][RE_NIVO]      = nivo;
    RealEstate[gid][RE_CENA]      = cena;
    RealEstate[gid][RE_ZATVORENO] = 1;
    RealEstate[gid][RE_IZLAZ]     = Float:{-1706.7264, -941.3351, 32.8662, 90.0};
    RealEstate[gid][RE_INTERACT]  = Float:{-1716.7944, -958.1540, 32.9392};
    RealEstate[gid][RE_ENT]       = 2;
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    GetPlayerPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    GetPlayerFacingAngle(playerid, RealEstate[gid][RE_ULAZ][3]);
    format(ulaz, sizeof(ulaz),   "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2],  RealEstate[gid][RE_ULAZ][3]);

    Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

    // Kreiranje pickupa
    RealEstate[gid][RE_LABEL]   = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_PICKUP_ENTRANCE] = -1;
    RealEstate[gid][RE_PICKUP_EXIT] = -1;
    RealEstate[gid][RE_PICKUP_VEHICLE] = -1;
    re_kreirajpickup(garaza, gid);

    // Insertovanje u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_garaze (vlasnik,nivo,cena,zatvoreno,ulaz) VALUES ('Niko',%d,%d,1,'%s')",
    nivo, cena, ulaz);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEINSERT);

    // Ispisivanje poruke adminu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dodali garazu. (id: %d)", lid);

    // Upisivanje u log
    format(string_128, sizeof string_128, "GARAZA | DODAVANJE | Izvrsio: %s | ID: %d", ime_obicno[playerid], lid);
    Log_Write(LOG_AIMOVINA, string_128);
    return 1;
}

public mysql_addCottage(playerid, ccinc) 
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new
        nivo,
        cena,
        lid,
        gid,
        ulaz[42]
    ;

    nivo = 12, cena = 1800000;

    cache_get_value_index_int(0, 0, lid);
    gid = re_globalid(vikendica, lid);

    // Podesavanje default vrednosti
    RealEstate[gid][RE_ID]        = lid;
    RealEstate[gid][RE_NIVO]      = nivo;
    RealEstate[gid][RE_CENA]      = cena;
    RealEstate[gid][RE_ZATVORENO] = 1;
    RealEstate[gid][RE_IZLAZ]     = Float:{-1509.7969, 2400.9155, 3.57, 0.0};
    strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
    GetPlayerPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    GetPlayerFacingAngle(playerid, RealEstate[gid][RE_ULAZ][3]);
    format(ulaz, sizeof(ulaz),   "%.4f|%.4f|%.4f|%.4f", RealEstate[gid][RE_ULAZ][0],  RealEstate[gid][RE_ULAZ][1],  RealEstate[gid][RE_ULAZ][2],  RealEstate[gid][RE_ULAZ][3]);

    Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

    // Kreiranje pickupa
    RealEstate[gid][RE_LABEL]   = Text3D:INVALID_3DTEXT_ID;
    RealEstate[gid][RE_PICKUP_ENTRANCE] = -1;
    RealEstate[gid][RE_PICKUP_EXIT] = -1;
    RealEstate[gid][RE_PICKUP_VEHICLE] = -1;
    re_kreirajpickup(vikendica, gid);

    // Insertovanje u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_vikendice (vlasnik,nivo,cena,zatvoreno,ulaz) VALUES ('Niko',%d,%d,1,'%s')",
    nivo, cena, ulaz);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEINSERT);

    // Ispisivanje poruke adminu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dodali vikendicu. (id: %d)", lid);

    // Upisivanje u log
    format(string_128, sizeof string_128, "VIKENDICA | DODAVANJE | Izvrsio: %s | ID: %d", ime_obicno[playerid], lid);
    Log_Write(LOG_AIMOVINA, string_128);
    return 1;
}

forward MySQL_RE_UpdateActivityData(type);
public MySQL_RE_UpdateActivityData(type)
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new i = 0; i < rows; i++)
    {
        new lid;
        cache_get_value_index_int(i, 1, lid);

        new gid = re_globalid(type, lid);
        cache_get_value_index_int(i, 0, RealEstate[gid][RE_OWNER_LAST_ONLINE]);

        re_kreirajpickup(type, gid);
    }
    return 1;
}


forward MySQL_LoadHouse();
public MySQL_LoadHouse()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijednu kucu u bazi.");

    new
        lid,
        ulaz[42],
        izlaz[42],
        garazaStr[44],
        vehicleStr[54],
        gid,
        ucitano = 0,
        droga[16]
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(kuca, lid);
        RealEstate[gid][RE_ID] = lid;
        RealEstate[gid][RE_ROBBERY_COOLDOWN] = 0;
        RealEstate[gid][RE_OWNER_LAST_ONLINE] = 0;
        
        cache_get_value_name(i, "vlasnik", RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);
        cache_get_value_name_int(i, "vrsta", RealEstate[gid][RE_VRSTA]);
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "ent", RealEstate[gid][RE_ENT]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name_int(i, "novac", RealEstate[gid][RE_NOVAC]);
        cache_get_value_name_int(i, "rent", RealEstate[gid][RE_RENT]);
        cache_get_value_name_int(i, "sef", RealEstate[gid][RE_SEF]);
        cache_get_value_name(i, "droga", droga);
        cache_get_value_name(i, "ulaz",  ulaz);
        cache_get_value_name(i, "izlaz", izlaz);
        cache_get_value_name(i, "garaza", garazaStr);
        cache_get_value_name(i, "vehicle", vehicleStr);

        // Razdvajanje droge
        sscanf(droga, "p<|>ii", HouseInfo[lid][HOUSE_MDMA], HouseInfo[lid][HOUSE_HEROIN]);

        // Razdvajanje stringa sa koordinatama ulaza i izlaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);
        sscanf(izlaz, "p<|>ffff", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);
        sscanf(garazaStr, "p<|>ffffi", RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], RealEstate[gid][RE_GARAZA_OTKLJUCANA]);

        // Razdvajanje informacija o kucnom vozilu
        sscanf(vehicleStr, "p<,>iffff", RealEstate[gid][RE_HC_MODEL], RealEstate[gid][RE_HC_POS][0], RealEstate[gid][RE_HC_POS][1], RealEstate[gid][RE_HC_POS][2], RealEstate[gid][RE_HC_POS][3]);

        // Kreiranje kucnog vozila
        if (RealEstate[gid][RE_HC_MODEL] >= 400 && RealEstate[gid][RE_HC_MODEL] < 611)
        {
            RealEstate[gid][RE_HC_VEHID] = CreateVehicle(RealEstate[gid][RE_HC_MODEL], RealEstate[gid][RE_HC_POS][0], RealEstate[gid][RE_HC_POS][1], RealEstate[gid][RE_HC_POS][2], RealEstate[gid][RE_HC_POS][3], -1, -1, 1000);
        }
        else
        {
            RealEstate[gid][RE_HC_VEHID] = -1;
        }
        

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

        // Kreiranje pickupa
        re_kreirajpickup(kuca, gid);
        
        // Resetovanje varijabli za objekte (samo dyn id)
        for__loop (new j = 0; j < MAX_OBJEKATA; j++)
            H_FURNITURE[lid][j][hf_dynid] = -1;

        // Resetovanje oruzja
        for__loop (new j = 0; j < 13; j++) {
            H_WEAPONS[lid][j][hw_weapon]  = -1;
            H_WEAPONS[lid][j][hw_ammo]    = 0;
        }
        
        // Ucitavanje objekata
        new sQuery[51];
        format(sQuery, sizeof sQuery, "SELECT * FROM re_kuce_predmeti WHERE k_id = %d", lid);
        mysql_tquery(SQL, sQuery, "MySQL_LoadHouseObjects", "i", lid);
        
        ucitano++;
    }

    if (lid > real_estate_maxID[kuca]) real_estate_maxID[kuca] = lid;
    printf("[Real estate] Ucitano %d kuca.", ucitano, GetTickCount());        

    RE_UpdateActivityData(kuca);

    // Ucitavanje oruzja
    mysql_tquery(SQL, "SELECT * FROM re_kuce_oruzje", "MySQL_LoadHouseWeapons");
    return 1;
}

forward MySQL_LoadHouseObjects(lid);
public MySQL_LoadHouseObjects(lid)
{
    cache_get_row_count(rows);
    if (!rows)
        return 1;
        
    new 
        pozicija_str[66],
        gid
    ;
    gid = re_globalid(kuca, lid);
        
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "u_id", H_FURNITURE[lid][i][hf_uid]);
        cache_get_value_name_int(i, "o_id", H_FURNITURE[lid][i][hf_object_id]);
        cache_get_value_name_int(i, "kategorija", H_FURNITURE[lid][i][hf_category]);
        cache_get_value_name_int(i, "cena", H_FURNITURE[lid][i][hf_price]);
        cache_get_value_name(i, "naziv",    H_FURNITURE[lid][i][hf_name], MAX_FITEM_NAME);
        cache_get_value_name(i, "pozicija", pozicija_str);
        
        sscanf(pozicija_str, "p<|>ffffff", H_FURNITURE[lid][i][hf_x_poz], H_FURNITURE[lid][i][hf_y_poz], H_FURNITURE[lid][i][hf_z_poz], H_FURNITURE[lid][i][hf_x_rot], H_FURNITURE[lid][i][hf_y_rot], H_FURNITURE[lid][i][hf_z_rot]);
            
        H_FURNITURE[lid][i][hf_dynid] = CreateDynamicObject(H_FURNITURE[lid][i][hf_object_id], H_FURNITURE[lid][i][hf_x_poz], H_FURNITURE[lid][i][hf_y_poz], H_FURNITURE[lid][i][hf_z_poz], H_FURNITURE[lid][i][hf_x_rot], H_FURNITURE[lid][i][hf_y_rot], H_FURNITURE[lid][i][hf_z_rot], gid, RealEstate[gid][RE_ENT], -1, 80.0);
    }
    return 1;
}

forward MySQL_LoadHouseWeapons();
public MySQL_LoadHouseWeapons()
{
    cache_get_row_count(rows);
    if (!rows) 
        return 1;

    new id, slot;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index_int(i, 0, id);
        cache_get_value_index_int(i, 1, slot);
        cache_get_value_index_int(i, 2, H_WEAPONS[id][slot][hw_weapon]);
        cache_get_value_index_int(i, 3, H_WEAPONS[id][slot][hw_ammo]);
    }
    return 1;
}

forward MySQL_LoadApartment();
public MySQL_LoadApartment()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijedan stan u bazi.");

    new
        lid,
        ulaz[42],
        izlaz[42],
        gid,
        ucitano = 0
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(stan, lid);
        RealEstate[gid][RE_ID] = lid;
        
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "ent", RealEstate[gid][RE_ENT]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name(i, "ulaz",    ulaz);
        cache_get_value_name(i, "izlaz",   izlaz);
        cache_get_value_name(i, "vlasnik", RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);

        // Razdvajanje stringa sa koordinatama ulaza i izlaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);
        sscanf(izlaz, "p<|>ffff", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

        // Kreiranje pickupa
        re_kreirajpickup(stan, gid);

        ucitano++;
    }

    if (lid > real_estate_maxID[stan]) real_estate_maxID[stan] = lid;
    printf("[Real estate] Ucitano %d stanova.", ucitano);

    RE_UpdateActivityData(stan);
    return 1;
}

forward MySQL_LoadHotel();
public MySQL_LoadHotel()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijednu firmu u bazi.");

    new
        lid,
        ulaz[42],
        interact[33],
        gid,
        ucitano
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(hotel, lid);
        RealEstate[gid][RE_ID] = lid;
        
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "ent", RealEstate[gid][RE_ENT]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name_int(i, "novac", RealEstate[gid][RE_NOVAC]);
        cache_get_value_name_int(i, "cena_sobe", RealEstate[gid][RE_CENA_SOBE]);
        cache_get_value_name_int(i, "slotovi", RealEstate[gid][RE_SLOTOVI]);
        cache_get_value_name(i, "ulaz",     ulaz);
        cache_get_value_name(i, "vlasnik",  RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);

        // Razdvajanje stringa sa koordinatama ulaza i izlaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);
        sscanf(interact, "p<|>fff", RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]);

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);
        
        // Postavljanje statickih koordinata za izlaz (+ enterijer)
        RealEstate[gid][RE_IZLAZ][0] = 2214.6240;
        RealEstate[gid][RE_IZLAZ][1] = -1150.4921;
        RealEstate[gid][RE_IZLAZ][2] = 1025.7969;
        RealEstate[gid][RE_IZLAZ][3] = 270.0;
        RealEstate[gid][RE_ENT]     = 15;
        
        // Postavljanje statickih koordinata za interact
        RealEstate[gid][RE_INTERACT][0] = 2217.2412;
        RealEstate[gid][RE_INTERACT][1] = -1147.0216;
        RealEstate[gid][RE_INTERACT][2] = 1025.7969;

        RealEstate[gid][RE_CHECKPOINT] = CreateDynamicCP(RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 0.9, gid, RealEstate[gid][RE_ENT], -1, 10.0);
        re_kreirajpickup(hotel, gid);

        ucitano ++;
    }

    if (lid > real_estate_maxID[hotel]) real_estate_maxID[hotel] = lid;
    printf("[Real estate] Ucitano %d hotela.", ucitano);

    RE_UpdateActivityData(hotel);

    return 1;
}

forward MySQL_LoadHotelTennants();
public MySQL_LoadHotelTennants()
{
    /*
      Rezultati su poredjani po polju "hotel_id" rastuci
      Slot krece od -1, i povecava se svaki put jer je hotel id isti
      Kad se promeni hotel id, slot krece ispocetka (ali od 0)
    */


    LOADED[l_realestate] = 1;


    
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Svi hoteli su prazni.");

    new
        lid, // hotel id
        pid, // player id
        ucitano
    ;
    for__loop (new i = 0, slot = -1, previous_hotel_id; i < rows; i++)
    {
        slot ++;
        
        cache_get_value_name_int(i, "hotel_id", lid);
        cache_get_value_name_int(i, "player_id", pid);
        
        if (lid != previous_hotel_id) // Promenjen hotel id
            slot = 0; // Slot krece brojanje ispocetka
        else
        {
            if (slot >= MAX_HOTEL_SOBA) // Array index out of bounds
                continue;
        }
        
        
        RE_HOTELS[lid][slot][rh_player_id] = pid;
        previous_hotel_id = lid;
        
        ucitano ++;
    }
    
    printf("[Real estate] Ucitano %d stanara u hotelima.", ucitano);
    return 1;
}

forward MySQL_LoadGarage();
public MySQL_LoadGarage()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijednu garazu u bazi.");

    new
        lid,
        ulaz[42],
        gid,
        ucitano = 0
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(garaza, lid);
        RealEstate[gid][RE_ID] = lid;
        
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name(i, "ulaz",    ulaz);
        cache_get_value_name(i, "vlasnik", RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);

        // Razdvajanje stringa sa koordinatama ulaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);

        // Postavljanje enterijera i koordinati izlaza (isto za svaku garazu)
        RealEstate[gid][RE_IZLAZ]    = Float:{-1706.7264, -941.3351, 32.8662, 90.0};
        RealEstate[gid][RE_INTERACT] = Float:{-1716.7944, -958.1540, 32.9392}; // TODO: dodati na mysql_addgarage
        RealEstate[gid][RE_ENT]      = 2;

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

        // Checkpoint za izradu droge
        RealEstate[gid][RE_CHECKPOINT] = CreateDynamicCP(RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]-1.0, 1.1, gid, RealEstate[gid][RE_ENT], -1, 10.0);

        // Kreiranje pickupa
        re_kreirajpickup(garaza, gid);

        ucitano++;
    }

    if (lid > real_estate_maxID[garaza]) real_estate_maxID[garaza] = lid;
    printf("[Real estate] Ucitano %d garaza.", ucitano);

    RE_UpdateActivityData(garaza);
    return 1;
}

forward MySQL_LoadCottage();
public MySQL_LoadCottage()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijednu vikendicu u bazi.");

    new
        lid,
        ulaz[42],
        gid,
        ucitano = 0
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        new sDrugs[10];

        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(vikendica, lid);
        RealEstate[gid][RE_ID] = lid;
        
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name_int(i, "mats", CottageInfo[lid][COTTAGE_MATS]);
        cache_get_value_name(i, "ulaz",    ulaz);
        cache_get_value_name(i, "vlasnik", RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);
        cache_get_value_name(i, "droga", sDrugs, sizeof sDrugs);

        // Razdvajanje droge
        sscanf(sDrugs, "p<|>ii", CottageInfo[lid][COTTAGE_WEED], CottageInfo[lid][COTTAGE_WEED_RAW]);

        // Razdvajanje stringa sa koordinatama ulaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);

        // Postavljanje enterijera i koordinati izlaza (isto za svaku garazu)
        // RealEstate[gid][RE_IZLAZ]    = Float:{-1706.7264, -941.3351, 32.8662, 90.0};
        RealEstate[gid][RE_IZLAZ]    = Float:{-1509.7969, 2400.9155, 3.57, 0.0};
        RealEstate[gid][RE_ENT]      = 2;

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

        // Checkpoint za izradu droge
        RealEstate[gid][RE_CHECKPOINT] = CreateDynamicCP(RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]-1.0, 1.1, gid, RealEstate[gid][RE_ENT], -1, 10.0);

        // Kreiranje pickupa
        re_kreirajpickup(vikendica, gid);

        ucitano++;
    }

    if (lid > real_estate_maxID[vikendica]) real_estate_maxID[vikendica] = lid;
    printf("[Real estate] Ucitano %d vikendica.", ucitano);

    RE_UpdateActivityData(vikendica);
    return 1;
}

forward MySQL_LoadBusiness();
public MySQL_LoadBusiness()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijednu firmu u bazi.");

    new
        lid,
        ulaz[42],
        izlaz[42],
        interact[33],
        gid,
        ucitano
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", lid);
        gid = re_globalid(firma, lid);
        RealEstate[gid][RE_ID] = lid;
        BizInfo[lid][BIZ_ACTOR] = -1;
        RealEstate[gid][RE_ROBBERY_COOLDOWN] = 0;
        
        cache_get_value_name_int(i, "vrsta", RealEstate[gid][RE_VRSTA]);
        cache_get_value_name_int(i, "nivo", RealEstate[gid][RE_NIVO]);
        cache_get_value_name_int(i, "cena", RealEstate[gid][RE_CENA]);
        cache_get_value_name_int(i, "ent", RealEstate[gid][RE_ENT]);
        cache_get_value_name_int(i, "zatvoreno", RealEstate[gid][RE_ZATVORENO]);
        cache_get_value_name_int(i, "novac", RealEstate[gid][RE_NOVAC]);
        cache_get_value_name_int(i, "reket", BizInfo[lid][BIZ_REKET]);
        cache_get_value_name_int(i, "novac_reket", BizInfo[lid][BIZ_NOVAC_REKET]);
        cache_get_value_name(i, "ulaz",     ulaz);
        cache_get_value_name(i, "izlaz",    izlaz);
        cache_get_value_name(i, "interact", interact);
        cache_get_value_name(i, "vlasnik", RealEstate[gid][RE_VLASNIK], MAX_PLAYER_NAME);
        cache_get_value_name(i, "naziv",   BizInfo[lid][BIZ_NAZIV],   32);

        // Razdvajanje stringa sa koordinatama ulaza i izlaza
        sscanf(ulaz, "p<|>ffff", RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);
        sscanf(izlaz, "p<|>ffff", RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);
        sscanf(interact, "p<|>fff", RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]);

        // Dobijanje adrese
        Get2DZoneByPosition(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ADRESA], 32);

        new vw = gid;
        // VW = gid, osim za kioske, gde je 0
        if (RealEstate[gid][RE_VRSTA] == FIRMA_KIOSK) vw = 0; 
        else if (RealEstate[gid][RE_VRSTA] == FIRMA_PIJACA) vw = 0;
        

        if (RealEstate[gid][RE_VRSTA] == FIRMA_APOTEKA || RealEstate[gid][RE_VRSTA] == FIRMA_ACCESSORY)
        {
            // Posto je u pitanju custom enterijer, checkpoint lebdi u vazduhu.
            // Potrebno je spustiti ga za 1.0 (po Z), ali se CP obim mora (malo) povecati.
            RealEstate[gid][RE_CHECKPOINT] = CreateDynamicCP(RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]-1.0, 1.1, vw, RealEstate[gid][RE_ENT], -1, 10.0);
        }
        else
        {
            // Za sve druge firme je normalno (ili skoro normalno - kiosci su izuzetak - oni imaju 3DText umesto CP-a)
            if (RealEstate[gid][RE_VRSTA] == FIRMA_KIOSK)
            {
                RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel("/kiosk", 0xFFFF00FF, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 7.5);
            }
            else if (RealEstate[gid][RE_VRSTA] == FIRMA_PIJACA)
            {
                RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel("[ Gradska pijaca ]\nKoristite "#MAGENTA_14"/pijaca "#MAGENTA_11"da kupite semena", COLOR_MAGENTA_11, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 7.5);
            }
            else if (RealEstate[gid][RE_VRSTA] == FIRMA_BOLNICA)
            {
                // Bolnice imaju pilulu
                RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel("BOLNICA\n{FFFFFF}/izlecime ($1000)", 0x00FF00FF, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 7.5);
                CreateDynamicPickup(1241, 2, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]);
            }
            else if (RealEstate[gid][RE_VRSTA] == FIRMA_RADIO)
            {
                // Bolnice imaju pilulu
                RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel("/oglas ($2.000)", 0x48E31CFF, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 7.5);
            }
            else
            {
                RealEstate[gid][RE_CHECKPOINT] = CreateDynamicCP(RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2], 1.0, vw, RealEstate[gid][RE_ENT], -1, 10.0);
            }
        }


        re_kreirajpickup(firma, gid);


        new vrstaFirme = RealEstate[gid][RE_VRSTA];
        // Kreiranje actora
        if (vrstaFirme == FIRMA_PRODAVNICA)
        {
            if (RealEstate[gid][RE_ENT] == 10)
            {
                BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(170, 3.1866,-30.7007,1003.5494,0.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
            }
            
            else if (RealEstate[gid][RE_ENT] == 17)
            {
                BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(170, -27.9991,-186.8369,1003.5469,0.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
            }
            
            else if (RealEstate[gid][RE_ENT] == 18)
            {
                BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(170, -26.8574,-91.6186,1003.5469,0.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
            }
        }

        else if (vrstaFirme == FIRMA_TECHNOLOGY)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(289, 1821.8160,-1428.9924,13.6016,180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }

        else if (vrstaFirme == FIRMA_ORUZARNICA)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(179, 312.4022,-167.7644,999.5938, 0.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }
        
        else if (vrstaFirme == FIRMA_RESTORAN)
        {
            if (RealEstate[gid][RE_ENT] == 1)
            {
                BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(11, -782.4267,498.3178,1371.7490,0.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
            }
            
            else if (RealEstate[gid][RE_ENT] == 4)
            {
                BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(170, 449.7166,-82.2324,999.5547,180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
            }
        }
        
        else if (vrstaFirme == FIRMA_SEXSHOP)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(75, -105.0150,-8.9150,1000.7188, 180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }
        
        else if (vrstaFirme == FIRMA_BURGERSHOT)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(205, 376.5357,-65.8476,1001.5078, 180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);

            if (GetDistanceBetweenPoints(RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], 1206.8125,-894.4656,43.1322) < 20.0)
            {
                // Drive thru za glavni burg
                drivethruCP = CreateDynamicCP(1206.8125,-894.4656,43.1322, 4.0, 0, 0, -1, 12.0);
                CreateDynamicActor(205, 1204.4557,-895.8875,43.1546,277.6918);
            }
        }
       
        else if (vrstaFirme == FIRMA_PIZZASTACK)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(155, 373.8414,-117.2744,1001.4995, 180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }
        
        else if (vrstaFirme == FIRMA_RANDYSDONUTS)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(179, 380.6600,-187.7794,1000.6328, 90.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }
        
        else if (vrstaFirme == FIRMA_CLUCKINBELL)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(167, 368.8124,-4.4923,1001.8516, 180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }
        
        else if (vrstaFirme == FIRMA_APOTEKA)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(308, 1948.8920,948.3152,-34.9424,270.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }

        else if (vrstaFirme == FIRMA_HARDWARE)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(8, 1315.4365,-1120.9429,24.0068,270.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }

        else if (vrstaFirme == FIRMA_BOLNICA)
        {
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(308, 1176.7411,-1340.8031,-47.7370,270.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }

        else if (vrstaFirme == FIRMA_RADIO)
        {
            gAdvertisingBizID = lid;
            BizInfo[lid][BIZ_ACTOR] = CreateDynamicActor(148, 1712.6195,-1135.2046,24.1103,180.0, 1, 100.0, gid, RealEstate[gid][RE_ENT]);
        }

        ucitano++;
    }

    if (lid > real_estate_maxID[firma]) real_estate_maxID[firma] = lid;
    printf("[Real estate] Ucitano %d firmi.", ucitano);
    
    RE_UpdateActivityData(firma);
    return 1;
}

forward MySQL_LoadProducts();
public MySQL_LoadProducts()
{
    cache_get_row_count(rows);
    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijedan proizvod u bazi.");

    new
        ucitano;
    for__loop (new i = 0, id; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name(i, "naziv", PRODUCTS[id][pr_naziv], 32);
        cache_get_value_name_int(i, "cena", PRODUCTS[id][pr_cena]);

        ucitano++;
    }

    printf("[Real estate] Ucitano %d proizvoda.", ucitano);
    return 1;
}

forward MySQL_LoadBizProducts();
public MySQL_LoadBizProducts()
{
    cache_get_row_count(rows);

    if (!rows) 
        return print("[mysql warning] Ne mogu da pronadjem nijedan firma-specifican proizvod u bazi.");

    for__loop (new i = 0, fid, pid; i < rows; i++)
    {
        cache_get_value_name_int(i, "fid", fid); // id firme (local)
        cache_get_value_name_int(i, "pid", pid); // id proizvoda
        cache_get_value_name_int(i, "cena",  F_PRODUCTS[fid][pid][f_cena]);
        cache_get_value_name_int(i, "stock", F_PRODUCTS[fid][pid][f_stock]);

        if (F_PRODUCTS[fid][pid][f_cena] == 0)
        {
            F_PRODUCTS[fid][pid][f_cena] = PRODUCTS[pid][pr_cena];
        }

        // Benzinska pumpa? -> 3dtext
        new gid = re_globalid(firma, fid);
        if (RealEstate[gid][RE_VRSTA] == FIRMA_BENZINSKA && pid == 48) 
        {
            format(string_128, sizeof string_128, "[ Benzinska pumpa ]\n\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo\n1 litar = $%d", F_PRODUCTS[fid][48][f_cena]);
            RealEstate[gid][RE_LABEL_2] = CreateDynamic3DTextLabel(string_128, 0xFFFF00FF, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]+1.0, 30.0);
            CreateDynamicPickup(1650, 1, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]);
        }
    }
    return 1;
}


public mysql_re_hoteli_stanari(playerid, hotel_id, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_re_hoteli_stanari");
    }

	/* hotel_id = gid */
	if (!checkcinc(playerid, ccinc))
		return 1;
		
	cache_get_row_count(rows);
	if (!rows)
		return InfoMsg(playerid, "Sve sobe u ovom hotelu su prazne.");
		
	if (rows >= MAX_HOTEL_SOBA || rows > RealEstate[hotel_id][RE_SLOTOVI])
		return ErrorMsg(playerid, "Zauzete sobe prelaze limit.");
	
	// Resetovanje stringa i listitem arraya
    new string[512];
	string[0] = EOS;
	for__loop (new i = 0; i < MAX_HOTEL_SOBA; i++)
		stanari_li[i] = INVALID_PLAYER_ID;
		
	// Uzimanje vracenih podataka
	for__loop (new i = 0, ime[MAX_PLAYER_NAME]; i < rows; i++)
	{
		cache_get_value_name(i, "ime", ime);
	
		format(string, sizeof(string), "%s%s\n", string, ime);
		cache_get_value_name_int(i, "p_id", stanari_li[i]);
	}
	
	SPD(playerid, "re_hoteli_stanari", DIALOG_STYLE_LIST, "{0068B3}HOTEL - SPISAK STANARA", string, "Izbaci", "Nazad");
		
	return 1;
}

forward MYSQL_CountHouseTenants(playerid, gid, ccinc);
public MYSQL_CountHouseTenants(playerid, gid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MYSQL_CountHouseTenants");
    }

    if (!checkcinc(playerid, ccinc))
        return 1;

    if (PI[playerid][p_rent_kuca] != 0 || PI[playerid][p_rent_cena] != 0)
        return ErrorMsg(playerid, "Vec iznajmljujete sobu u nekoj kuci. Koristite /odjavisobu da je odjavite.");

    new maxTenants = 0, tenantCount;
    cache_get_row_count(rows);
    cache_get_value_index_int(0, 0, tenantCount);
    switch (RealEstate[gid][RE_VRSTA])
    {
        case 1: maxTenants = 0; // Prikolica
        case 2: maxTenants = 1; // Mala kuca
        case 3: maxTenants = 2; // Srednja kuca
        case 4: maxTenants = 3; // Velika kuca
        case 5: maxTenants = 5; // Vila
    }

    if (tenantCount >= maxTenants)
        return ErrorMsg(playerid, "U ovoj kuci nema mesta za nove stanare!");

    PI[playerid][p_rent_kuca] = re_localid(kuca, gid);
    PI[playerid][p_rent_cena] = RealEstate[gid][RE_RENT];

    new query[75];
    format(query, sizeof query, "UPDATE igraci SET rent_kuca = %i, rent_cena = %i WHERE id = %i", PI[playerid][p_rent_kuca], PI[playerid][p_rent_cena], PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    format(query, sizeof query, "INSERT INTO re_kuce_stanari VALUES (%i, %i, %i)", PI[playerid][p_rent_kuca], PI[playerid][p_id], PI[playerid][p_rent_cena]);
    mysql_tquery(SQL, query);

    SendClientMessageF(playerid, SVETLOZELENA, "(kuca) {FFFFFF}Iznajmili ste ovu kucu. Prilikom svake plate, sa bankovnog racuna ce Vam biti oduzeto {00FF00}%s.", formatMoneyString(PI[playerid][p_rent_cena]));
    SendClientMessage(playerid, BELA, "* Kada budete zeleli da odjavite sobu, koristite /odjavisobu.");

    SetPlayerInterior(playerid, RealEstate[gid][RE_ENT]);
    SetPlayerVirtualWorld(playerid, gid);
    SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]);
    SetPlayerFacingAngle(playerid, RealEstate[gid][RE_IZLAZ][3]);
    return 1;
}

forward MYSQL_CheckTenantStatus(playerid, ccinc);
public MYSQL_CheckTenantStatus(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MYSQL_CheckTenantStatus");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (rows == 0)
    {
        SendClientMessage(playerid, TAMNOCRVENA, "* Izbaceni ste iz kuce od strane vlasnika.");

        // Promena spawna
        if (PI[playerid][p_rent_kuca] > 0 && re_globalid(kuca, PI[playerid][p_rent_kuca]) == PI[playerid][p_spawn_vw])
        {
            dialog_respond:spawn(playerid, 1, 0, "");
        }

        // Izbacen iz kuce
        PI[playerid][p_rent_kuca] = 0;
        PI[playerid][p_rent_cena] = 0;

        new query[65];
        format(query, sizeof query, "UPDATE igraci SET rent_kuca = 0, rent_cena = 0 WHERE id = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }
    else
    {
        if (PI[playerid][p_rent_cena] != RealEstate[re_globalid(kuca, PI[playerid][p_rent_kuca])][RE_RENT])
        {
            SendClientMessageF(playerid, CRVENA, "(kuca) {FFFFFF}Vlasnik kuce u kojoj iznajmljujete sobu je promenio cenu stanarine: {FF0000}%s ? %s.", formatMoneyString(PI[playerid][p_rent_cena]), formatMoneyString(RealEstate[re_globalid(kuca, PI[playerid][p_rent_kuca])][RE_RENT]));
            SendClientMessage(playerid, BELA, "* Od sada cete sobu placati po novoj ceni. Ukoliko zelite da odjavite sobu, koristite /odjavisobu.");

            PI[playerid][p_rent_cena] = RealEstate[re_globalid(kuca, PI[playerid][p_rent_kuca])][RE_RENT];

            new query[56];
            format(query, sizeof query, "UPDATE igraci SET rent_cena = %i WHERE id = %i", PI[playerid][p_rent_cena], PI[playerid][p_id]);
            mysql_tquery(SQL, query);
        }
    }
    return 1;
}

forward MYSQL_ListHouseTenants(playerid, ccinc);
public MYSQL_ListHouseTenants(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MYSQL_ListHouseTenants");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
    {
        ErrorMsg(playerid, "Niko ne iznajmljuje sobu u Vasoj kuci.");
        return DialogReopen(playerid);
    }

    new string[MAX_PLAYER_NAME * 5], playerName[MAX_PLAYER_NAME];
    string[0] = EOS;

    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index(i, 0, playerName, MAX_PLAYER_NAME);
        format(string, sizeof string, "%s\n%s", string, playerName);
    }

    SPD(playerid, "re_kuce_spisak_stanara", DIALOG_STYLE_LIST, "{FFFFFF}SPISAK STANARA", string, "Izbaci", "« Nazad");
    return 1;
}

RE_Reload(propType, lid)
{
    new gid = re_globalid(propType, lid),
        sQuery[52],
        sCallback[24]
    ;


    // Kreiranje vehicle pickupa za ulaz
    if (IsValidDynamicPickup(RealEstate[gid][RE_PICKUP_ENTRANCE]))
    {
        DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_ENTRANCE]);
        RealEstate[gid][RE_PICKUP_ENTRANCE] = -1;
    }
    if (IsValidDynamicPickup(RealEstate[gid][RE_PICKUP_VEHICLE]))
    {
        DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_VEHICLE]);
        RealEstate[gid][RE_PICKUP_VEHICLE] = -1;
    }
    if (IsValidDynamicPickup(RealEstate[gid][RE_PICKUP_EXIT]))
    {
        DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_EXIT]);
        RealEstate[gid][RE_PICKUP_EXIT] = -1;
    }
    if (IsValidDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_ENTER]))
    {
        DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_ENTER]);
        RealEstate[gid][RE_PICKUP_GARAGE_ENTER] = -1;
    }
    if (IsValidDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_EXIT]))
    {
        DestroyDynamicPickup(RealEstate[gid][RE_PICKUP_GARAGE_EXIT]);
        RealEstate[gid][RE_PICKUP_GARAGE_EXIT] = -1;
    }
    if (IsValidDynamicCP(RealEstate[gid][RE_CHECKPOINT]))
    {
        DestroyDynamicCP(RealEstate[gid][RE_CHECKPOINT]);
        RealEstate[gid][RE_CHECKPOINT] = -1;
    }
    if (IsValidDynamic3DTextLabel(RealEstate[gid][RE_LABEL]))
    {
        DestroyDynamic3DTextLabel(RealEstate[gid][RE_LABEL]);
        RealEstate[gid][RE_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }


    switch (propType)
    {
        case kuca: 
        {
            sCallback = "MySQL_LoadHouse";

            // Resetovanje varijabli za objekte
            for__loop (new i = 0; i < MAX_OBJEKATA; i++)
            {
                H_FURNITURE[lid][i][hf_uid]       = -1;
                H_FURNITURE[lid][i][hf_object_id] = -1;
                H_FURNITURE[lid][i][hf_price]    = 0;
                H_FURNITURE[lid][i][hf_name]     = EOS;
                if (H_FURNITURE[lid][i][hf_dynid] != -1)
                {
                    DestroyDynamicObject(H_FURNITURE[lid][i][hf_dynid]);
                    H_FURNITURE[lid][i][hf_dynid] = -1;
                }
            }
        }
        case firma: 
        {
            sCallback = "MySQL_LoadBusiness";

            if (IsValidDynamicActor(BizInfo[lid][BIZ_ACTOR]))
            {
                DestroyDynamicActor(BizInfo[lid][BIZ_ACTOR]);
                BizInfo[lid][BIZ_ACTOR] = -1;
            }
            if (IsValidDynamic3DTextLabel(RealEstate[gid][RE_LABEL_2]))
            {
                DestroyDynamic3DTextLabel(RealEstate[gid][RE_LABEL_2]);
                RealEstate[gid][RE_LABEL_2] = Text3D:INVALID_3DTEXT_ID;
            }
        }
        case stan: sCallback = "MySQL_LoadApartment";
        case hotel: sCallback = "MySQL_LoadHotel";
        case garaza: sCallback = "MySQL_LoadGarage";
        case vikendica: sCallback = "MySQL_LoadCottage";
    }

    format(sQuery, sizeof sQuery, "SELECT * FROM %s WHERE id = %i", propname(propType, PROPNAME_TABLE), lid);
    mysql_tquery(SQL, sQuery, sCallback);

    if (propType == firma)
    {
        format(sQuery, sizeof sQuery, "SELECT * FROM re_firme_proizvodi WHERE fid = %i", lid);
        mysql_tquery(SQL, sQuery, "MySQL_LoadBizProducts");
    }
    return 1;
}





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:nekretnine(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return SPD(playerid, "imovina", DIALOG_STYLE_LIST, "{0068B3}UPRAVLJANJE IMOVINOM", "Vozila\nNekretnine", "Odaberi", "Izadji");
	
    if (RealEstate_ChooseProperty(playerid, listitem))
    {
        SetPVarInt(playerid, "RE_ManageProperty", 1);
    }

	return 1;
}

Dialog:estateList(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new 
            estate = GetPVarInt(playerid, "RE_Listing"), // Vrsta nekretnine kojom upravlja
            lid = strval(inputtext), // Local ID te nekretnine
            gid = re_globalid(estate, lid)
        ;
        SetPVarInt(playerid, "RE_EditID", lid);


        if (GetPVarInt(playerid, "RE_ManageProperty") == 1)
        {
            // Upravljanje nekom imovinom
            DeletePVar(playerid, "RE_ManageProperty");

            new
                sTitle[28],
                sDialog[128],
                sDialogAdd[64]
            ;
            sDialogAdd[0] = EOS;
            
            switch (estate)
            {
                case 0: // Kuca
                {
                    sDialogAdd = "\nSef\nUredi kucu\nKucna garaza\nIznajmljivanje";
                }
                case 1: // Stan
                {
                    sDialogAdd = "\nSef";
                }
                case 2: // firma
                {
                    sDialogAdd = "\nKasa\nReket\nProizvodi\nNaziv firme";
                }
                case 3: // hotel
                {
                    sDialogAdd = "\nKasa\nReket\nIzmeni cenu sobe\nStanari";
                }
                case 4: // garaza
                {
                    // ---
                }
                case 5: // Vikendica
                {
                    sDialogAdd = "\nSef";
                }
                default: return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (01)");
            }

            format(sDialog, sizeof sDialog, "Informacije\nProdaj %s\nLociraj %s\nOtkljucaj / Zakljucaj%s", propname(estate, PROPNAME_AKUZATIV),
                propname(estate, PROPNAME_AKUZATIV), sDialogAdd);

            if (RealEstate_CheckPlayerPosession(playerid, estate) == 0)
                return ErrorMsg(playerid, "Ne posedujes %s.", propname(estate, PROPNAME_AKUZATIV));

            format(sTitle, sizeof(sTitle), "{0068B3}NEKRETNINE - %s", propname(estate, PROPNAME_UPPER));
            SPD(playerid, "re_general", DIALOG_STYLE_LIST, sTitle, sDialog, "Odaberi", "Nazad");
        }

        else if (estate == kuca && GetPVarInt(playerid, "RE_BuyingHC") == 1)
        {
            // Kupovina kucnog vozila
            DeletePVar(playerid, "RE_BuyingHC");

            SetPVarInt(playerid, "pAutosalonHouseID", lid);
            autosalon_HCInit(playerid);
        }

        else if (estate == kuca && GetPVarInt(playerid, "pBuyingHouseSafe") > 0)
        {
            // Kupovina sefa za kucu
            new iPrice = GetPVarInt(playerid, "pBuyingHouseSafe");
            new iBusiness = GetPVarInt(playerid, "pBuyingSafe_BizID");
            DeletePVar(playerid, "pBuyingHouseSafe");
            DeletePVar(playerid, "pBuyingSafe_BizID");

            if (iPrice > 0)
            {
                PlayerMoneySub(playerid, iPrice);
                re_firma_dodaj_novac(iBusiness, floatround(iPrice/100.0)*8);
            }

            RealEstate[gid][RE_SEF] = 1;

            new sQuery[45];
            format(sQuery, sizeof sQuery, "UPDATE re_kuce SET sef = 1 WHERE id = %i", lid);
            mysql_tquery(SQL, sQuery);

            InfoMsg(playerid, "Kupio si sef za kucu %i.", lid);
        }
    
        else if (GetPVarInt(playerid, "RE_ChangingSpawn") == 1)
        {
            // Promena spawna
            DeletePVar(playerid, "RE_ChangingSpawn");

            PI[playerid][p_spawn_x]      = RealEstate[gid][RE_IZLAZ][0];
            PI[playerid][p_spawn_y]      = RealEstate[gid][RE_IZLAZ][1];
            PI[playerid][p_spawn_z]      = RealEstate[gid][RE_IZLAZ][2];
            PI[playerid][p_spawn_a]      = RealEstate[gid][RE_IZLAZ][3];
            PI[playerid][p_spawn_vw]     = gid;
            PI[playerid][p_spawn_ent]    = RealEstate[gid][RE_ENT];
            PI[playerid][p_spawn_armour] = 0.0;
            if (estate == kuca)
            {
                PI[playerid][p_spawn_health] = 100.0;
            }
            else if (estate == stan)
            {
                PI[playerid][p_spawn_health] = 80.0;
            }
            else
            {
                PI[playerid][p_spawn_health] = 70.0;
            }

            if (estate == firma)
            {
                if (IsBusinessWithInterior(gid))
                {
                    PI[playerid][p_spawn_vw] = gid;
                }
                else
                {
                    PI[playerid][p_spawn_vw] = 0;
                }
            }

            ///////////////////////////////////////////////////////////
            // Sledeci je kopiran iz dialoga "spawn" u NLRPGv3.pwn
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
            else PI[playerid][p_spawn_armour] = 0.0;

            // Formatiranje unosa za update podataka u bazi
            new sSpawn[63], sQuery[115];
            format(sSpawn, sizeof(sSpawn), "%.4f|%.4f|%.4f|%.4f|%d|%d|%.1f|%.1f", PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], PI[playerid][p_spawn_ent], PI[playerid][p_spawn_vw], PI[playerid][p_spawn_health], PI[playerid][p_spawn_armour]);

            // Update podataka u bazi
            format(sQuery, sizeof sQuery, "UPDATE igraci SET spawn = '%s' WHERE id = %d", sSpawn, PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);

            // Slanje poruke igracu
            InfoMsg(playerid, "Mesto stvaranja (spawn) je uspesno promenjeno. Novi spawn je: {FFFFFF}%s %i.", propname(estate, PROPNAME_LOWER), lid);

            if (GetPVarInt(playerid, "vipOverride") == 1)
            {
                DeletePVar(playerid, "vipOverride");
                callcmd::vip(playerid, "");
            }
        }
    }
    else
    {
        if (GetPVarInt(playerid, "RE_ChangingSpawn") == 1)
        {
            DeletePVar(playerid, "RE_ChangingSpawn");
            callcmd::spawn(playerid, "");
        }
    }
    return 1;
}

Dialog:re_general(playerid, response, listitem, const inputtext[])
{
	if (!response) 
		return dialog_respond:imovina(playerid, 1, 1, "");

	new
	    naslov[42],
	    boja[7],
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid   = GetPVarInt(playerid, "RE_EditID"),
	    gid   = re_globalid(vrsta, lid)
	;

	switch (vrsta)
	{
	    case kuca:      boja = "48E31C";
		case stan:      boja = "48E31C";
		case firma:     boja = "33CCFF";
		case hotel:	    boja = "8080FF";
	    case garaza:    boja = "FF8282";
        case vikendica: boja = "6622FF";
	    default:     return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (47)");
	}

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
	{
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));
	}

	switch (listitem)
	{
	    case 0: // Informacije
	    {
	        new vrsta_text[13], string[320];
	        if (vrsta == kuca)
	        {
	            switch (RealEstate[gid][RE_VRSTA])
		        {
		          	case 1: vrsta_text = "Prikolica";
	                case 2: vrsta_text = "Mala kuca";
	                case 3: vrsta_text = "Srednja kuca";
	                case 4: vrsta_text = "Velika kuca";
	                case 5: vrsta_text = "Vila";
	                default:
	                {
	                    printf("[error] Kuca #%d nepoznate vrste (%d).", RealEstate[gid][RE_ID], RealEstate[gid][RE_VRSTA]);
	                    return 1;
	                }
	            }
			}
			else format(vrsta_text, sizeof(vrsta_text), "%s", propname(vrsta, PROPNAME_LOWER));

	        format(naslov, sizeof(naslov), "{0068B3}%s", propname(vrsta, PROPNAME_UPPER));

	        format(string, sizeof string, "{%s}Vrsta: {FFFFFF}%s (%d)\n{%s}Vlasnik: {FFFFFF}%s\n{%s}Adresa: {FFFFFF}%s\n{%s}Cena: {FFFFFF}$%d\n{%s}Nivo: {FFFFFF}%d", boja, vrsta_text,
				RealEstate[gid][RE_ID], boja, RealEstate[gid][RE_VLASNIK], boja, RealEstate[gid][RE_ADRESA], boja, RealEstate[gid][RE_CENA], boja, RealEstate[gid][RE_NIVO]);

			if (vrsta == firma)
			{
				format(string, sizeof string, "%s\n\n{%s}%s\nNaziv: {FFFFFF}%s\n{%s}Kasa: {FFFFFF}%s\n{%s}Reket: {FFFFFF}%s\n{%s}Reket racun: {FFFFFF}%s", string, boja, vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_UPPER), BizInfo[lid][BIZ_NAZIV], boja, formatMoneyString(RealEstate[gid][RE_NOVAC]), boja, reket_ime(gid), boja, formatMoneyString(BizInfo[lid][BIZ_NOVAC_REKET]));
			}
				
			SPD(playerid, "re_return", DIALOG_STYLE_MSGBOX, naslov, string, "Nazad", "");
	    }


	    case 1: // Prodaj
	    {
	        format(naslov, sizeof(naslov), "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
            SPD(playerid, "re_prodaja", DIALOG_STYLE_LIST, naslov, "Prodaj drzavi\nProdaj igracu\nZameni sa igracem", "Dalje »", "« Nazad");
	    }


	    case 2: // Lociraj
	    {
	        SetGPSLocation(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], "lokacija nekretnine");
	    }


	    case 3: // Otkljucaj / zakljucaj
	    {
	        if (!IsPlayerInRangeOfPoint(playerid, 3.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]) && !IsPlayerInRangeOfPoint(playerid, 3.0, RealEstate[gid][RE_IZLAZ][0],
			    RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2])) return ErrorMsg(playerid, "Morate biti blizu vrata.");

	        if (RealEstate[gid][RE_ZATVORENO] == 0) // Zakljucavanje
	        {
	            format(string_64, 64, "{%s}(%s) {FFFFFF}Zakljucali ste %s.", boja, propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_AKUZATIV));
	        }
	        else // Otkljucavanje
	        {
	            format(string_64, 64, "{%s}(%s) {FFFFFF}Otkljucali ste %s.", boja, propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_AKUZATIV));
	        }
	        RealEstate[gid][RE_ZATVORENO] = (RealEstate[gid][RE_ZATVORENO] == 0)? 1 : 0;
	        SendClientMessage(playerid, BELA, string_64);

	        format(string_64, 64, "* %s okrece kljuc u bravi.", ime_rp[playerid]);
	        RangeMsg(playerid, string_64, LJUBICASTA, 10.0);
	        format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET zatvoreno = %d WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_ZATVORENO], RealEstate[gid][RE_ID]);
	        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
	    }


	    case 4: // Sef/kasa
	    {
            format(naslov, sizeof(naslov), "{0068B3}%s - %s", propname(vrsta, PROPNAME_UPPER), (vrsta == kuca)? ("SEF") : ("KASA"));

			if (vrsta == kuca)
			{
				if (!IsPlayerInRangeOfPoint(playerid, 30.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]) || GetPlayerVirtualWorld(playerid) != gid)
					return ErrorMsg(playerid, "Morate biti u svojoj kuci da biste koristili sef.");

                if (RealEstate[gid][RE_SEF] == 0)
                    return ErrorMsg(playerid, "Nemate sef u svojoj kuci. Mozete ga kupiti u prodavnici sefova i alata (/gps).");

                SPD(playerid, "re_sef", DIALOG_STYLE_LIST, naslov, "Informacije\nOruzje\nDroga\nNovac", "Dalje »", "« Nazad");
			}
			else if (vrsta == firma || vrsta == hotel)
			{
				if (!IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]))
					return ErrorMsg(playerid, "Morate biti blizu kase da biste je koristili.");
                
                SPD(playerid, "re_novac", DIALOG_STYLE_LIST, naslov, "Uzmi novac\nStavi novac", "Dalje »", "« Nazad");
			}
            else if (vrsta == stan)
            {
                if (!IsPlayerInRangeOfPoint(playerid, 30.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]) || GetPlayerVirtualWorld(playerid) != gid)
                    return ErrorMsg(playerid, "Morate biti u svom stanu da biste koristili sef.");

                SPD(playerid, "re_sef", DIALOG_STYLE_LIST, naslov, "Uzmi stvari\nStavi stvari", "Dalje »", "« Nazad");
            }
            else if (vrsta == vikendica)
            {
                if (!IsPlayerInRangeOfPoint(playerid, 30.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]) || GetPlayerVirtualWorld(playerid) != gid)
                    return ErrorMsg(playerid, "Morate biti u svojoj vikendici da biste koristili sef.");

                // SPD(playerid, "re_sef", DIALOG_STYLE_LIST, naslov, "Uzmi marihuanu\nStavi marihuanu", "Dalje <", "< Nazad");
                SPD(playerid, "re_sef", DIALOG_STYLE_LIST, naslov, "Uzmi stvari\nStavi stvari", "Dalje »", "« Nazad");
            }
			else return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (04)");
	    }
		case 5: // Reket ili uredjivanje kuce
		{
			switch (vrsta)
			{
				case firma, hotel:
				{
                    new string [180];
					format(naslov, sizeof(naslov), "{0068B3}%s - REKET", propname(vrsta, PROPNAME_UPPER), (vrsta == kuca)? ("SEF") : ("KASA"));
					format(string, sizeof string, "{FFFFFF}Reket: {0068B3}%s\n\n{FFFFFF}Upisite tag mafije koju zelite da postavite za reket\nili upisite \"Niko\" da uklonite reket::", reket_ime(gid));
					
					SPD(playerid, "re_reket", DIALOG_STYLE_INPUT, naslov, string, "Postavi", "Nazad");
				}
				case kuca:
				{
                    if (!IsPlayerInRangeOfPoint(playerid, 50.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]) || GetPlayerVirtualWorld(playerid) != gid)
                        return ErrorMsg(playerid, "Morate biti u svojoj kuci da biste je uredjivali.");

					SPD(playerid, "ft_main", DIALOG_STYLE_LIST, "{0068B3}KUCA - UREDJIVANJE", "Vidi predmete u kuci\nKupi novi predmet", "Dalje »", "« Nazad");
				}
				default: return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (05)");
			}
		}
		case 6: // Proizvodi / cena sobe / kucna garaza
		{
			switch (vrsta)
			{
				case firma: // Proizvodi
                {
                    SPD(playerid, "re_proizvodi", DIALOG_STYLE_LIST, "{0068B3}FIRMA - PROIZVODI", "Proveri stanje\nIzmeni cene\nNaruci jos proizvoda", "Dalje »", "« Nazad");
                }

				case hotel: // Cena sobe
				{
					format(string_256, sizeof string_256, "{FFFFFF}Cena sobe: {0068B3}$%d\n\n{FFFFFF}Upisite novu cenu sobe u hotelu.\nDa onemogucite iznajmljivanje sobe, \
					upisite {0068B3}0:", RealEstate[gid][RE_CENA_SOBE]);
					SPD(playerid, "re_cena_sobe", DIALOG_STYLE_INPUT, "{0068B3}HOTEL - CENA SOBE", string_256, "Izmeni", "Nazad");
				}

                case kuca: // Kucna garaza
                {
                    if (RealEstate[gid][RE_GARAZA][0] == 0.0)
                    {
                        ErrorMsg(playerid, "Vasa kuca ne poseduje garazu koju mozete kupiti.");
                        return DialogReopen(playerid);
                    }

                    new price = (((RealEstate[gid][RE_CENA]/4)<100000)? 100000 : RealEstate[gid][RE_CENA]/4);
                    
                    if (RealEstate[gid][RE_GARAZA_OTKLJUCANA])
                    {
                        SetPVarInt(playerid, "RE_HouseGaragePrice", price);
                        
                        new string[115];
                        format(string, sizeof string, "{FFFFFF}Posedujete kucnu garazu.\n\nDa li zelite da {FF0000}PRODATE {FFFFFF}kucnu garazu za {0068B3}%s?", formatMoneyString(price));
                        SPD(playerid, "re_kucna_garaza_sell", DIALOG_STYLE_MSGBOX, "Kucna garaza", string, "Prodaj", "Nazad");
                    }
                    else 
                    {
                        SetPVarInt(playerid, "RE_HouseGaragePrice", price);

                        new string[105];
                        format(string, sizeof string, "{FFFFFF}Kucna garaza se dodatno naplacuje.\n\nDa li zelite da dokupite garazu za {0068B3}%s?", formatMoneyString(price));
                        SPD(playerid, "re_kucna_garaza_buy", DIALOG_STYLE_MSGBOX, "Kucna garaza", string, "Kupi", "Nazad");
                    }
                }
				default: return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (06)");
			}
		}
		case 7: // Lista stanara (hotel), iznajmljivanje (kuca) ili naziv firme
		{
            switch (vrsta) 
            {
                case hotel: 
                {
                    new query[186];
        			format(query, sizeof query, "SELECT igraci.ime as ime, re_hoteli_stanari.player_id as p_id FROM re_hoteli_stanari LEFT JOIN igraci ON igraci.id = re_hoteli_stanari.player_id WHERE re_hoteli_stanari.hotel_id = %d", lid);
        			mysql_tquery(SQL, query, "mysql_re_hoteli_stanari", "iii", playerid, gid, cinc[playerid]);
                }
                case firma: 
                {
                    format(string_128, sizeof string_128, "{FFFFFF}Trenutni naziv: {0068B3}%s\n\n{FFFFFF}Upisite novi naziv za ovu firmu:", BizInfo[lid][BIZ_NAZIV]);
                    SPD(playerid, "re_firma_naziv", DIALOG_STYLE_INPUT, "{0068B3}FIRMA - NAZIV", string_128, "Izmeni", "Nazad");
                }
                case kuca: // Iznajmljivanje
                {
                    if (RealEstate[gid][RE_VRSTA] == 1)
                    {
                        ErrorMsg(playerid, "Ne mozete koristiti ovu opciju za prikolicu.");
                        return DialogReopen(playerid);
                    }

                    SPD(playerid, "re_kuce_rent", DIALOG_STYLE_LIST, "{0068B3}KUCA - IZNAJMLJIVANJE", "Cena stanarine\nSpisak stanara", "Dalje »", "« Nazad");
                }
                default: return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (07)");
            }
		}
	}

	return 1;
}

Dialog:re_return(playerid, response, listitem, const inputtext[])
{
    return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));
}

Dialog:re_reket(playerid, response, listitem, const inputtext[]) // Postavljanje reketa
{
	return f_d_re_reket(playerid, response, listitem, inputtext); // Ovaj dialog je u modulu "factions", da bi moglo da se pristupi varijablama tog modula
}

Dialog:re_sef(playerid, response, listitem, const inputtext[]) // Kuca: sef
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));
        // return SPD(playerid, "re_sef", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Informacije\nOruzje\nDroga\nNovac", "Dalje <", "< Nazad");

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid = GetPVarInt(playerid, "RE_EditID"),
        gid = re_globalid(vrsta, lid)
    ;
    if (vrsta != kuca && vrsta != stan && vrsta != vikendica) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (46)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (vrsta == kuca)
    {
        switch (listitem)
        {
            case 0: // Informacije (stanje)
            {
                new string[256];

                format(string, sizeof string, "{0068B3}[ ORUZJE ]\n{FFFFFF}...\n\n[ DROGA ]\n{FFFFFF}...\n\n[ NOVAC ]\n{FFFFFF}Sef: {0068B3}%s", formatMoneyString(RealEstate[gid][RE_NOVAC]));
                SPD(playerid, "re_sef_info", DIALOG_STYLE_MSGBOX, "{0068B3}KUCA - SEF", string, "OK", "");
            }

            case 1: // Oruzje
            {
                SPD(playerid, "re_sef_oruzje", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Uzmi oruzje\nStavi oruzje", "Dalje »", "« Nazad");
            }

            case 2: // Droga
            {
                SPD(playerid, "re_sef_droga", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Uzmi drogu\nStavi drogu", "Dalje »", "« Nazad");
            }

            case 3: // Novac
            {
                SPD(playerid, "re_novac", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Uzmi novac\nStavi novac", "Dalje »", "« Nazad");
            }
        }
    }
    else if (vrsta == stan)
    {

        if (!BP_PlayerHasBackpack(playerid))
            return ErrorMsg(playerid, "Ne posedujes ranac. Mozes ga kupiti u bilo kom marketu ili prodavnici tehnike.");

        if (listitem == 0) // Uzmi
        {
            new count = 0,
                sDialog[256],
                sItemName[25]
            ;

            format(sDialog, sizeof sDialog, "ID\tNaziv\tKolicina");
            for__loop (new i = 0; i < MAX_APT_CHEM_ITEMS; i++)
            {
                if (APT_CHEM[lid][i][apt_chem_itemid] != -1 && APT_CHEM[lid][i][apt_chem_count] > 0)
                {
                    count ++;
                    BP_GetItemName(APT_CHEM[lid][i][apt_chem_itemid], sItemName, sizeof sItemName);
                    format(sDialog, sizeof sDialog, "%s\n%i\t%s\t%i %s", 
                        sDialog, APT_CHEM[lid][i][apt_chem_itemid], sItemName, APT_CHEM[lid][i][apt_chem_count], 
                        ((APT_CHEM[lid][i][apt_chem_itemid]==ITEM_DEMIVODA||APT_CHEM[lid][i][apt_chem_itemid]==ITEM_ALKOHOL)? ("ml") : ("gr"))
                    );
                }
            }

            if (!count)
            {
                ErrorMsg(playerid, "Nemate stvari u stanu.");
                return DialogReopen(playerid);
            }

            SPD(playerid, "re_stan_take", DIALOG_STYLE_TABLIST_HEADERS, "UZMI STVARI", sDialog, "Uzmi", "Nazad");
        }
        else if (listitem == 1) // Stavi
        {
            new count = 0,
                sDialog[256],
                sItemName[25]
            ;

            format(sDialog, sizeof sDialog, "ID\tNaziv\tKolicina");
            for__loop (new i = DRUGS_GetSubstanceMinID(); i <= DRUGS_GetSubstanceMaxID(); i++)
            {
                if (BP_PlayerItemGetCount(playerid, i) > 0)
                {
                    count ++;
                    BP_GetItemName(i, sItemName, sizeof sItemName);
                    format(sDialog, sizeof sDialog, "%s\n%i\t%s\t%i %s", 
                        sDialog, i, sItemName, BP_PlayerItemGetCount(playerid, i), 
                        ((i==ITEM_DEMIVODA||i==ITEM_ALKOHOL)? ("ml") : ("gr"))
                    );
                }
            }

            if (!count)
            {
                ErrorMsg(playerid, "Nemate stvari koje mozete ostaviti.");
                return DialogReopen(playerid);
            }

            SPD(playerid, "re_stan_put", DIALOG_STYLE_TABLIST_HEADERS, "STAVI STVARI", sDialog, "Stavi", "Nazad");
        }
    }
    else if (vrsta == vikendica)
    {
        if (listitem == 0) // Uzmi stvari
        {
            new sDialog[109];
            format(sDialog, sizeof sDialog, "{000000}%i\tSirovi kanabis\t%i grama\n{000000}%i\tMarihuana\t%i grama\n{000000}%i\tMaterijali\t%.1f kg", ITEM_WEED_RAW, CottageInfo[lid][COTTAGE_WEED_RAW], ITEM_WEED, CottageInfo[lid][COTTAGE_WEED], ITEM_MATERIALS, CottageInfo[lid][COTTAGE_MATS]/1000.0);
            SPD(playerid, "re_cottage_take_1", DIALOG_STYLE_TABLIST, "{0068B3}VIKENDICA - UZMI", sDialog, "Uzmi", "Nazad");
        }
        if (listitem == 1) // Stavi stvari
        {
            new sDialog[109];
            format(sDialog, sizeof sDialog, "{000000}%i\tSirovi kanabis\t%i grama\n{000000}%i\tMarihuana\t%i grama\n{000000}%i\tMaterijali\t%.1f kg", ITEM_WEED_RAW, BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW), ITEM_WEED, BP_PlayerItemGetCount(playerid, ITEM_WEED), ITEM_MATERIALS, BP_PlayerItemGetCount(playerid, ITEM_MATERIALS)/1000.0);
            SPD(playerid, "re_cottage_put_1", DIALOG_STYLE_TABLIST, "{0068B3}VIKENDICA - STAVI", sDialog, "Stavi", "Nazad");
        }
    }

    return 1;
}

Dialog:re_cottage_put_1(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new vrsta = GetPVarInt(playerid, "RE_Listing");
    if (vrsta != vikendica) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    SetPVarInt(playerid, "pSefDroga_ID", strval(inputtext)); // Id predmeta(droge) koji stavlja
    SPD(playerid, "re_cottage_put_2", DIALOG_STYLE_INPUT, "{0068B3}VIKENDICA - STAVI", "{FFFFFF}Upisite kolicinu koju zelite da stavite {FFFF00}(gram):", "Stavi", "Odustani");
    return 1;
}

Dialog:re_cottage_put_2(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        quantity, maxquantity, itemid
    ;

    if (vrsta != vikendica) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (sscanf(inputtext, "i", quantity))
        return DialogReopen(playerid);

    itemid = GetPVarInt(playerid, "pSefDroga_ID");
    maxquantity = BP_PlayerItemGetCount(playerid, itemid);

    if (quantity < 1 || quantity > maxquantity)
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", maxquantity);
        return DialogReopen(playerid);
    }

    if (itemid == ITEM_MATERIALS && (quantity + CottageInfo[id][COTTAGE_MATS]) > 1000000)
    {
        ErrorMsg(playerid, "Mozete drzati najvise 1000 kg materijala u vikendici.");
        return DialogReopen(playerid);
    }


    if (itemid == ITEM_WEED) CottageInfo[id][COTTAGE_WEED] += quantity;
    else if (itemid == ITEM_WEED_RAW) CottageInfo[id][COTTAGE_WEED_RAW] += quantity;
    else if (itemid == ITEM_MATERIALS) CottageInfo[id][COTTAGE_MATS] += quantity;

    new sItemName[25];
    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    BP_PlayerItemSub(playerid, itemid, quantity);

    if (itemid == ITEM_MATERIALS)
    {
        SendClientMessageF(playerid, 0x6622FFFF, "(vikendica) {FFFFFF}Stavili ste %.1f kg obradjenih materijala. Sada u rancu imate %.1f kg materijala.", quantity/1000.0, BP_PlayerItemGetCount(playerid, itemid)/1000.0);

        new sQuery[60];
        format(sQuery, sizeof sQuery, "UPDATE re_vikendice SET mats = %i WHERE id = %i", CottageInfo[id][COTTAGE_MATS], id);
        mysql_tquery(SQL, sQuery);
    }
    else
    {
        SendClientMessageF(playerid, 0x6622FFFF, "(vikendica) {FFFFFF}Stavili ste %s u kolicini %i gr. Sada u rancu imate %i gr.", sItemName, quantity, BP_PlayerItemGetCount(playerid, itemid));

        new sQuery[256];
        format(sQuery, sizeof sQuery, "UPDATE re_vikendice SET droga = '%i|%i' WHERE id = %i", CottageInfo[id][COTTAGE_WEED], CottageInfo[id][COTTAGE_WEED_RAW], id);
        mysql_tquery(SQL, sQuery);
    }

    new sLog[96];
    format(sLog, sizeof sLog, "STAVLJANJE | %s | %s: %i | Vikendica: %i", ime_obicno[playerid], sItemName, quantity, id);
    Log_Write(LOG_RE_STVARI, sLog);
    return 1;
}

Dialog:re_cottage_take_1(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new vrsta = GetPVarInt(playerid, "RE_Listing");
    if (vrsta != vikendica) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    SetPVarInt(playerid, "pSefDroga_ID", strval(inputtext)); // Id predmeta(droge) koji uzima
    SPD(playerid, "re_cottage_take_2", DIALOG_STYLE_INPUT, "{0068B3}VIKENDICA - UZMI", "{FFFFFF}Upisite kolicinu koju zelite da uzmete {FFFF00}(gram):", "Uzmi", "Odustani");
    return 1;
}

Dialog:re_cottage_take_2(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        quantity, maxquantity, itemid,
        sItemName[25]
    ;
    if (vrsta != vikendica) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (sscanf(inputtext, "i", quantity))
        return DialogReopen(playerid);

    itemid = GetPVarInt(playerid, "pSefDroga_ID");
    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    if (itemid == ITEM_WEED) maxquantity = CottageInfo[id][COTTAGE_WEED];
    else if (itemid == ITEM_WEED_RAW) maxquantity = CottageInfo[id][COTTAGE_WEED_RAW];
    else if (itemid == ITEM_MATERIALS) maxquantity = CottageInfo[id][COTTAGE_MATS];

    if (maxquantity == 0)
    {
        return ErrorMsg(playerid, "Na ovom slotu nemate nista.");
    }

    if (quantity < 1 || quantity > maxquantity)
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", maxquantity);
        return DialogReopen(playerid);
    }

    if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) > BP_GetItemCountLimit(itemid))
    {
        ErrorMsg(playerid, "Imate previse %s u rancu, morate uzeti manju kolicinu (najvise %i).", sItemName, BP_GetItemCountLimit(itemid) - BP_PlayerItemGetCount(playerid, itemid));
        return DialogReopen(playerid);
    }

    if (itemid == ITEM_WEED) CottageInfo[id][COTTAGE_WEED] -= quantity;
    else if (itemid == ITEM_WEED_RAW) CottageInfo[id][COTTAGE_WEED_RAW] -= quantity;
    else if (itemid == ITEM_MATERIALS) CottageInfo[id][COTTAGE_MATS] -= quantity;

    BP_PlayerItemAdd(playerid, itemid, quantity);

    if (itemid == ITEM_MATERIALS)
    {
        SendClientMessageF(playerid, 0x6622FFFF, "(vikendica) {FFFFFF}Uzeli ste %.1f kg obradjenih materijala. Sada u rancu imate %.1f kg materijala.", quantity/1000.0, BP_PlayerItemGetCount(playerid, itemid)/1000.0);

        new sQuery[60];
        format(sQuery, sizeof sQuery, "UPDATE re_vikendice SET mats = %i WHERE id = %i", CottageInfo[id][COTTAGE_MATS], id);
        mysql_tquery(SQL, sQuery);
    }
    else
    {
        SendClientMessageF(playerid, 0x6622FFFF, "(vikendica) {FFFFFF}Uzeli ste %s u kolicini %i gr. Sada u rancu imate %i gr.", sItemName, quantity, BP_PlayerItemGetCount(playerid, itemid));

        new sQuery[63];
        format(sQuery, sizeof sQuery, "UPDATE re_vikendice SET droga = '%i|%i' WHERE id = %i", CottageInfo[id][COTTAGE_WEED], CottageInfo[id][COTTAGE_WEED_RAW], id);
        mysql_tquery(SQL, sQuery);
    }


    new sLog[94];
    format(sLog, sizeof sLog, "UZIMANJE | %s | %s: %i | Vikendica: %i", ime_obicno[playerid], sItemName, quantity, id);
    Log_Write(LOG_RE_STVARI, sLog);
    return 1;
}

Dialog:re_sef_droga(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID")
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (listitem == 0) // Uzmi drogu
    {
        new string[92];
        format(string, sizeof string, "ID\tVrsta\tKolicina\n{000000}%i\t{FFFFFF}MDMA\t%i gr\n{000000}%i\t{FFFFFF}Heroin\t%i gr", ITEM_MDMA, HouseInfo[id][HOUSE_MDMA], ITEM_HEROIN, HouseInfo[id][HOUSE_HEROIN]);
        SPD(playerid, "re_sef_droga_take_1", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}KUCA - UZMI DROGU", string, "Dalje »", "« Nazad");
    }

    else if (listitem == 1) // Stavi drogu
    {
        new string[92];
        format(string, sizeof string, "ID\tVrsta\tKolicina\n{000000}%i\t{FFFFFF}MDMA\t%i gr\n{000000}%i\t{FFFFFF}Heroin\t%i gr", ITEM_MDMA, BP_PlayerItemGetCount(playerid, ITEM_MDMA), ITEM_HEROIN, BP_PlayerItemGetCount(playerid, ITEM_HEROIN));
        SPD(playerid, "re_sef_droga_put_1", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}KUCA - STAVI DROGU", string, "Dalje »", "« Nazad");
    }
    return 1;
}

Dialog:re_sef_droga_take_1(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new vrsta = GetPVarInt(playerid, "RE_Listing");
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    SetPVarInt(playerid, "pSefDroga_ID", strval(inputtext)); // Id predmeta(droge) koji uzima
    SPD(playerid, "re_sef_droga_take_2", DIALOG_STYLE_INPUT, "{0068B3}KUCA - UZMI DROGU", "{FFFFFF}Upisite kolicinu koju zelite da uzmete:", "Uzmi", "Odustani");
    return 1;
}

Dialog:re_sef_droga_take_2(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        quantity, maxquantity, itemid
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (sscanf(inputtext, "i", quantity))
        return DialogReopen(playerid);

    itemid = GetPVarInt(playerid, "pSefDroga_ID");
    if (itemid == ITEM_MDMA) maxquantity = HouseInfo[id][HOUSE_MDMA];
    else maxquantity = HouseInfo[id][HOUSE_HEROIN];

    if (maxquantity == 0)
    {
        return ErrorMsg(playerid, "Na ovom slotu nemate drogu.");
    }

    if (quantity < 1 || quantity > maxquantity)
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", maxquantity);
        return DialogReopen(playerid);
    }

    if ((BP_PlayerItemGetCount(playerid, itemid) + quantity) > BP_GetItemCountLimit(itemid))
    {
        ErrorMsg(playerid, "Imate previse droge u rancu, morate uzeti manju kolicinu (najvise %i gr).", BP_GetItemCountLimit(itemid) - BP_PlayerItemGetCount(playerid, itemid));
        return DialogReopen(playerid);
    }

    if (itemid == ITEM_MDMA) HouseInfo[id][HOUSE_MDMA] -= quantity;
    else HouseInfo[id][HOUSE_HEROIN] -= quantity;

    BP_PlayerItemAdd(playerid, itemid, quantity);

    new sItemName[25];
    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    SendClientMessageF(playerid, ZELENA2, "(kuca) {FFFFFF}Uzeli ste %s u kolicini %i gr. Sada u rancu imate %i gr.", sItemName, quantity, BP_PlayerItemGetCount(playerid, itemid));

    new sQuery[256];
    format(sQuery, sizeof sQuery, "UPDATE re_kuce SET droga = '%i|%i' WHERE id = %i", HouseInfo[id][HOUSE_MDMA], HouseInfo[id][HOUSE_HEROIN], id);
    mysql_tquery(SQL, sQuery);

    new sLog[96];
    format(sLog, sizeof sLog, "UZIMANJE | %s | %s: %i | Kuca: %i", ime_obicno[playerid], sItemName, quantity, id);
    Log_Write(LOG_RE_STVARI, sLog);
    return 1;
}

Dialog:re_sef_droga_put_1(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new vrsta = GetPVarInt(playerid, "RE_Listing");
    
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    SetPVarInt(playerid, "pSefDroga_ID", strval(inputtext)); // Id predmeta(droge) koji stavlja
    SPD(playerid, "re_sef_droga_put_2", DIALOG_STYLE_INPUT, "{0068B3}KUCA - STAVI DROGU", "{FFFFFF}Upisite kolicinu koju zelite da stavite:", "Stavi", "Odustani");
    return 1;
}

Dialog:re_sef_droga_put_2(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        quantity, maxquantity, itemid
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (sscanf(inputtext, "i", quantity))
        return DialogReopen(playerid);

    itemid = GetPVarInt(playerid, "pSefDroga_ID");
    maxquantity = BP_PlayerItemGetCount(playerid, itemid);

    if (quantity < 1 || quantity > maxquantity)
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", maxquantity);
        return DialogReopen(playerid);
    }

    if (itemid == ITEM_MDMA) HouseInfo[id][HOUSE_MDMA] += quantity;
    else HouseInfo[id][HOUSE_HEROIN] += quantity;

    BP_PlayerItemSub(playerid, itemid, quantity);

    new sItemName[25];
    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    SendClientMessageF(playerid, ZELENA2, "(kuca) {FFFFFF}Stavili ste %s u kolicini %i gr. Sada u rancu imate %i gr.", sItemName, quantity, BP_PlayerItemGetCount(playerid, itemid));

    new query[55];
    format(query, sizeof query, "UPDATE re_kuce SET droga = '%i|%i' WHERE id = %i", HouseInfo[id][HOUSE_MDMA], HouseInfo[id][HOUSE_HEROIN], id);
    mysql_tquery(SQL, query);

    new sLog[96];
    format(sLog, sizeof sLog, "STAVLJANJE | %s | %s: %i | Kuca: %i", ime_obicno[playerid], sItemName, quantity, id);
    Log_Write(LOG_RE_STVARI, sLog);
    return 1;
}

Dialog:re_stan_take(playerid, response, listitem, const inputtext[]) // Stan -> Sef -> Uzmi stvari
{
    if (!response)
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta  = GetPVarInt(playerid, "RE_Listing"),
        lid    = GetPVarInt(playerid, "RE_EditID"),
        itemid = strval(inputtext),
        sItemName[25],
        index = -1,
        takeCount = 0
    ;
    if (vrsta != stan) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (71)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    // Trazimo na kom se indexu nalazi ovaj predmet u sefu stana
    for__loop (new i = 0; i < MAX_APT_CHEM_ITEMS; i++)
    {
        if (APT_CHEM[lid][i][apt_chem_itemid] == itemid)
        {
            index = i;
            break;
        }
    }
    if (index == -1)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (72)");

    // Ako: [kolicina u stanu] + [kolicina u rancu] <= [limit za ranac]
    // Onda: uzeti sve iz stana
    // Ako je drugacije (>), onda: uzeti [limit za ranac] - [kolicina u rancu]

    if ((APT_CHEM[lid][index][apt_chem_count] + BP_PlayerItemGetCount(playerid, itemid)) <= BP_GetItemCountLimit(itemid))
    {
        // Uzeti sve iz stana
        takeCount = APT_CHEM[lid][index][apt_chem_count];

        APT_CHEM[lid][index][apt_chem_count] = 0;
        APT_CHEM[lid][index][apt_chem_itemid] = -1;

        // Brisanje unosa iz baze
        new query[70];
        format(query, sizeof query, "DELETE FROM re_stanovi_predmeti WHERE stan = %i AND itemid = %i", lid, itemid);
        mysql_tquery(SQL, query);
    }
    else
    {
        // Uzeti samo do popunjavanja ranca
        takeCount = BP_GetItemCountLimit(itemid) - BP_PlayerItemGetCount(playerid, itemid);

        APT_CHEM[lid][index][apt_chem_count] -= takeCount;

        // Update unosa u bazi
        new sQuery[83];
        format(sQuery, sizeof sQuery, "UPDATE re_stanovi_predmeti SET count = %i WHERE stan = %i AND itemid = %i", APT_CHEM[lid][index][apt_chem_count], lid, itemid);
        mysql_tquery(SQL, sQuery);
    }
    
    BP_PlayerItemAdd(playerid, itemid, takeCount);
    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    // Slanje poruke igracu
    SendClientMessageF(playerid, ZELENA2, "(stan) {FFFFFF}Uzeli ste %s, %i %s.", sItemName, takeCount, ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")));
    SendClientMessageF(playerid, BELA, "* Stanje u stanu: {48E31C}%i %s {FFFFFF}| Stanje u rancu: {48E31C}%i %s", APT_CHEM[lid][index][apt_chem_count], ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")), BP_PlayerItemGetCount(playerid, itemid), ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")));

    new sLog[96];
    format(sLog, sizeof sLog, "UZIMANJE | %s | %s: %i | Stan: %i", ime_obicno[playerid], sItemName, takeCount, lid);
    Log_Write(LOG_RE_STVARI, sLog);

    dialog_respond:re_sef(playerid, 1, 0, "");

    return 1;
}

Dialog:re_stan_put(playerid, response, listitem, const inputtext[]) // Stan -> Sef -> Stavi stvari
{
    if (!response)
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta  = GetPVarInt(playerid, "RE_Listing"),
        lid    = GetPVarInt(playerid, "RE_EditID"),
        itemid = strval(inputtext),
        sItemName[25],
        index = -1,
        putCount = 0,
        bool:itemExists = false
    ;
    if (vrsta != stan) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (74)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    // Proveravamo da li u stanu vec postoji ovaj predmet i na kom indexu
    // Ako ne postoji, odredjujemo na koji ce se index smestiti
    for__loop (new i = 0; i < MAX_APT_CHEM_ITEMS; i++)
    {
        if (APT_CHEM[lid][i][apt_chem_itemid] == itemid)
        {
            index = i;
            itemExists = true;
            break;
        }
    }
    if (!itemExists)
    {
        // Predmet ne postoji u kuci, odrediti na kom ce indexu biti
        for__loop (new i = 0; i < MAX_APT_CHEM_ITEMS; i++)
        {
            if (APT_CHEM[lid][i][apt_chem_itemid] == -1)
            {
                index = i;
                break;
            }
        }
    }


    // Ako predmet ne postoji u kuci, slobodno dodati svu kolicinu iz ranca
    // Inace, [limit za stan] = [limit za ranac] x 10, pa treba dodati po sledecim pravilima
    //
    //      Ako je: [kolicina u stanu] + [kolicina u rancu] <= [limit za stan], onda dodati sve iz ranca
    //      Inace (>): dodati [limit za stan] - [kolicina u stanu]
    if (!itemExists)
    {
        putCount = BP_PlayerItemGetCount(playerid, itemid);
        APT_CHEM[lid][index][apt_chem_itemid] = itemid;
        APT_CHEM[lid][index][apt_chem_count] = putCount;

        // Ubacivanje unosa u bazu
        new query[65];
        format(query, sizeof query, "INSERT INTO re_stanovi_predmeti VALUES (%i, %i, %i)", lid, itemid, putCount);
        mysql_tquery(SQL, query);
    }
    else
    {
        new itemCountLimit = BP_GetItemCountLimit(itemid) * 10; // LIMIT PREDMETA U STANU

        if ((APT_CHEM[lid][index][apt_chem_count] + BP_PlayerItemGetCount(playerid, itemid)) <= itemCountLimit)
        {
            // Ubaciti sve iz ranca
            putCount = BP_PlayerItemGetCount(playerid, itemid);
            APT_CHEM[lid][index][apt_chem_count] += putCount;
        }
        else
        {
            putCount = itemCountLimit - APT_CHEM[lid][index][apt_chem_count];
            APT_CHEM[lid][index][apt_chem_count] += putCount;
        }

        new query[86];
        format(query, sizeof query, "UPDATE re_stanovi_predmeti SET count = %i WHERE stan = %i AND itemid = %i", APT_CHEM[lid][index][apt_chem_count], lid, itemid);
        mysql_tquery(SQL, query);
    }

    BP_PlayerItemSub(playerid, itemid, putCount);
    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    // Slanje poruke igracu
    SendClientMessageF(playerid, ZELENA2, "(stan) {FFFFFF}Stavili ste %s, %i %s.", sItemName, putCount, ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")));
    SendClientMessageF(playerid, BELA, "* Stanje u stanu: {48E31C}%i %s {FFFFFF}| Stanje u rancu: {48E31C}%i %s", APT_CHEM[lid][index][apt_chem_count], ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")), BP_PlayerItemGetCount(playerid, itemid), ((itemid==ITEM_DEMIVODA||itemid==ITEM_ALKOHOL)? ("ml") : ("gr")));

    new sLog[96];
    format(sLog, sizeof sLog, "STAVLJANJE | %s | %s: %i | Stan: %i", ime_obicno[playerid], sItemName, putCount, lid);
    Log_Write(LOG_RE_STVARI, sLog);

    dialog_respond:re_sef(playerid, 1, 1, "");
    return 1;
}

Dialog:re_sef_info(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> informacije
{
    return dialog_respond:re_general(playerid, 1, 4, "");
}

Dialog:re_sef_oruzje(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> oruzje
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        weapon[22],
        string[450]
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (49)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    RE_oruzje_slot[playerid] = -1;
    switch (listitem) 
    {
        case 0: // Uzmi oruzje
        {
            if (IsPlayerOnLawDuty(playerid))
                return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete uzimati oruzje iz kuce.");

            if (IsPlayerInDMEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista uzeti iz kuce.");

            if (IsPlayerInHorrorEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista uzeti iz kuce.");

            format(string, 23, "Slot\tOruzje\tMunicija");

            for__loop (new i = 0; i < 13; i++) 
            {
                if (H_WEAPONS[id][i][hw_weapon] == -1 || H_WEAPONS[id][i][hw_ammo] <= 0) continue;

                GetWeaponName(H_WEAPONS[id][i][hw_weapon], weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, H_WEAPONS[id][i][hw_ammo]);
            }

            SPD(playerid, "re_sef_oruzje_uzmi", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}KUCA - UZMI ORUZJE", string, "Uzmi", "Nazad");
        }

        case 1: // Stavi oruzje
        {
            if (IsPlayerOnLawDuty(playerid))
                return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete stavljati oruzje u kucu.");


            if (IsPlayerInDMEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista ostaviti u kucu.");


            if (IsPlayerInHorrorEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista ostaviti u kucu.");

            new
                weaponid,
                ammo;

            format(string, 23, "Slot\tOruzje\tMunicija");
            for__loop (new i = 0; i < 13; i++) 
            {
                weaponid    = GetPlayerWeaponInSlot(playerid, i);
                ammo        = GetPlayerAmmoInSlot(playerid, i);
                if (weaponid <= 0 || ammo <= 0) continue;

                GetWeaponName(weaponid, weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, ammo);
            }

            SPD(playerid, "re_sef_oruzje_stavi", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}KUCA - STAVI ORUZJE", string, "Stavi", "Nazad");
        }
    }

    return 1;
}


Dialog:re_sef_oruzje_uzmi(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> oruzje -> uzmi
{
    if (!response) 
        return SPD(playerid, "re_sef_oruzje", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Uzmi oruzje\nStavi oruzje", "Dalje »", "« Nazad");

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        slot  = strval(inputtext), // odnosi se na slot oruzja
        weaponid,
        ammo,
        weapon[22]
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (51)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    
    weaponid = H_WEAPONS[id][slot][hw_weapon];
    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    ammo = H_WEAPONS[id][slot][hw_ammo];
    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    RE_oruzje_slot[playerid] = slot;
    format(string_256, 160, "{FFFFFF}Oruzje: {0068B3}%s\n{FFFFFF}Municija: {0068B3}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da uzmete:", weapon, ammo);
    SPD(playerid, "re_sef_oruzje_uzmi_potv", DIALOG_STYLE_INPUT, "KUCA - UZMI ORUZJE", string_256, "Uzmi", "Nazad");
    return 1;
}

Dialog:re_sef_oruzje_uzmi_potv(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> oruzje -> uzmi
{
    if (!response) 
    {
        new slotStr[4];
        valstr(slotStr, RE_oruzje_slot[playerid]);
        return dialog_respond:re_sef_oruzje(playerid, 1, 0, slotStr);
    }

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
        return DialogReopen(playerid);
    }

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        slot  = RE_oruzje_slot[playerid],
        weaponid,
        ammo,
        weapon[22]
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (51)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = H_WEAPONS[id][slot][hw_weapon];
    ammo     = H_WEAPONS[id][slot][hw_ammo];

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nema toliko municije za ovo oruzje.");
        return DialogReopen(playerid);
    }

    if (GetPlayerWeaponInSlot(playerid, slot) != weaponid)
        GivePlayerWeapon(playerid, weaponid, 0);
    
    SetPlayerAmmo(playerid, weaponid, GetPlayerAmmoInSlot(playerid, slot)+input);
    H_WEAPONS[id][slot][hw_ammo] -= input;

    // Update podataka u bazi
    if (H_WEAPONS[id][slot][hw_ammo] <= 0) { 
        // Igrac je uzeo svu municiju, izbrisati oruzje iz gepeka
        H_WEAPONS[id][slot][hw_weapon] = -1;

        format(mysql_upit, 80, "DELETE FROM re_kuce_oruzje WHERE k_id = %d AND slot = %d AND weapon = %d", id, slot, weaponid);
        mysql_tquery(SQL, mysql_upit);
    }
    else {
        // Nije uzeo sve, samo uraditi update municije
        format(mysql_upit, 74, "UPDATE re_kuce_oruzje SET ammo = %d WHERE k_id = %d AND slot = %d", H_WEAPONS[id][slot][hw_ammo], id, slot);
        mysql_tquery(SQL, mysql_upit);
    }

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, 0x0068B3FF, "(kuca) {FFFFFF}Uzeli ste {0068B3}%s {FFFFFF}i {0068B3}%d metaka {FFFFFF}iz sefa.", weapon, input);
    SendClientMessageF(playerid, BELA, "* U sefu je ostalo jos {0068B3}%d metaka {FFFFFF}za ovo oruzje.", H_WEAPONS[id][slot][hw_ammo]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "UZIMANJE | %s | %s | Uzeo %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_HOUSES_WEAPONS, string_128);
    
    
    new slotStr[4];
    valstr(slotStr, RE_oruzje_slot[playerid]);
    return dialog_respond:re_sef_oruzje(playerid, 1, 0, slotStr);
}

Dialog:re_sef_oruzje_stavi(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> oruzje -> stavi
{
    if (!response) 
        return SPD(playerid, "re_sef_oruzje", DIALOG_STYLE_LIST, "{0068B3}KUCA - SEF", "Uzmi oruzje\nStavi oruzje", "Dalje »", "« Nazad");

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        slot  = strval(inputtext), // odnosi se na slot oruzja
        weaponid    = GetPlayerWeaponInSlot(playerid, slot),
        ammo        = GetPlayerAmmoInSlot(playerid, slot),
        weapon[22]
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (53)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    RE_oruzje_slot[playerid] = slot;
    format(string_256, 160, "{FFFFFF}Oruzje: {0068B3}%s\n{FFFFFF}Municija: {0068B3}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da stavite:", weapon, ammo);
    SPD(playerid, "re_sef_oruzje_stavi_potv", DIALOG_STYLE_INPUT, "{0068B3}KUCA - STAVI ORUZJE", string_256, "Stavi", "Nazad");
    return 1;
}

Dialog:re_sef_oruzje_stavi_potv(playerid, response, listitem, const inputtext[]) // Kuca -> sef -> oruzje -> stavi
{
    if (!response) 
    {
        new slotStr[4];
        valstr(slotStr, RE_oruzje_slot[playerid]);
        return dialog_respond:re_sef_oruzje(playerid, 1, 1, slotStr);
    }

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
        return DialogReopen(playerid);
    }

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        id    = GetPVarInt(playerid, "RE_EditID"),
        slot  = RE_oruzje_slot[playerid],
        weaponid,
        ammo,
        weapon[22]
    ;
    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (51)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = GetPlayerWeaponInSlot(playerid, slot);
    ammo     = GetPlayerAmmoInSlot(playerid, slot);

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nemate toliko municije za ovo oruzje.");
        return DialogReopen(playerid);
    }


    // Update podataka u bazi
    if (H_WEAPONS[id][slot][hw_weapon] == -1) {
        // Ovaj slot nije bio zauzet u gepeku --> insert

        H_WEAPONS[id][slot][hw_weapon] = weaponid;
        H_WEAPONS[id][slot][hw_ammo]   = input;

        format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_kuce_oruzje VALUES (%d, %d, %d, %d)", id, slot, weaponid, input);
        mysql_tquery(SQL, mysql_upit);
    }
    else {
        // Slot je bio zauzet (istim ili drugim oruzjem)

        if ((H_WEAPONS[id][slot][hw_ammo] + input) > 250)
        {
            ErrorMsg(playerid, "Mozete ubaciti najvise 250 metaka u vozilo. Vec ih imate %d za ovaj slot.", H_WEAPONS[id][slot][hw_ammo]);
            return DialogReopen(playerid);
        }

        H_WEAPONS[id][slot][hw_weapon] = weaponid;
        H_WEAPONS[id][slot][hw_ammo]  += input;

        format(mysql_upit, 95, "UPDATE re_kuce_oruzje SET weapon = %d, ammo = %d WHERE k_id = %d AND slot = %d", weaponid, H_WEAPONS[id][slot][hw_ammo], id, slot);
        mysql_tquery(SQL, mysql_upit);
    }

    SetPlayerAmmo(playerid, weaponid, ammo-input);

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, 0x0068B3FF, "(kuca) {FFFFFF}Stavili ste {0068B3}%s {FFFFFF}i {0068B3}%d metaka {FFFFFF}u ostavu.", weapon, input);
    SendClientMessageF(playerid, BELA, "* U sefu sada imate {0068B3}%d metaka {FFFFFF}za ovo oruzje.", H_WEAPONS[id][slot][hw_ammo]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "STAVLJANJE | %s | %s | Stavio %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_HOUSES_WEAPONS, string_128);
    
    
    new slotStr[4];
    valstr(slotStr, RE_oruzje_slot[playerid]);
    return dialog_respond:re_sef_oruzje(playerid, 1, 1, slotStr);
}

Dialog:re_prodaja(playerid, response, listitem, const inputtext[]) // Prodaja nekretnine
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta,
	    naslov[39],
		lid,
	    gid
	;
	vrsta = GetPVarInt(playerid, "RE_Listing");
	lid   = GetPVarInt(playerid, "RE_EditID");
	gid   = re_globalid(vrsta, lid);

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	switch (listitem)
	{
	    case 0: // Prodaja drzavi
	    {
			string_64[0] = EOS;
			if (vrsta == firma)
			{
			    format(string_64, sizeof(string_64), " + %s", formatMoneyString(RealEstate[gid][RE_NOVAC]));
			}
			else if (vrsta == kuca)
			{
				// Izracunavanje cene svih objekata u kuci
				objekti_cena[playerid] = 0;
				for__loop (new i = 0; i < MAX_OBJEKATA; i++)
				{
					if (H_FURNITURE[lid][i][hf_dynid] != -1 && H_FURNITURE[lid][i][hf_price] > 0)
						objekti_cena[playerid] += H_FURNITURE[lid][i][hf_price];
				}

                // cena kucne garaze, ako je bila otkljucana
                DeletePVar(playerid, "RE_HouseGaragePrice");
                new garagePrice = 0;
                if (RealEstate[gid][RE_GARAZA_OTKLJUCANA] == 1)
                    garagePrice = (((RealEstate[gid][RE_CENA]/4)<100000)? 100000 : RealEstate[gid][RE_CENA]/4);

                SetPVarInt(playerid, "RE_HouseGaragePrice", garagePrice);

			    format(string_64, sizeof(string_64), " + %s + %s + %s", formatMoneyString(RealEstate[gid][RE_NOVAC]), formatMoneyString(objekti_cena[playerid]), formatMoneyString(GetPVarInt(playerid, "RE_HouseGaragePrice")));
			}
			format(naslov, sizeof(naslov), "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
	        format(string_256, 200, "{0068B3}Vrsta nekretnine: {FFFFFF}%s\n\n{0068B3}Vrednost: {FFFFFF}$%d\n\nDa li zaista zelite da prodate %s za {FFFF00}%s%s?",
				propname(vrsta, PROPNAME_LOWER), RealEstate[gid][RE_CENA], propname(vrsta, PROPNAME_AKUZATIV), formatMoneyString((RealEstate[gid][RE_CENA]/3)*2), string_64);
			SPD(playerid, "re_prodaja_drzavi", DIALOG_STYLE_MSGBOX, naslov, string_256, "Da", "Ne");
	    }
	    case 1: // Prodaja igracu
	    {
			if (PI[playerid][p_nivo] < 10)
				return ErrorMsg(playerid, "Morate biti najmanje nivo 10 da biste mogli da prodajete imovinu drugim igracima.");
				
			format(naslov, sizeof(naslov), "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
	        SPD(playerid, "re_prodaja_igracu_1", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite ime ili ID igraca kome zelite da prodate ovu nekretninu:", "Dalje »", "« Nazad");
	    }
		case 2: // Zamena
		{
            return InfoMsg(playerid, "Zamena imovine je privremeno onemogucena.");
			// if (PI[playerid][p_nivo] < 5)
			// 	return ErrorMsg(playerid, "Morate biti najmanje nivo 5 da biste mogli da menjate imovinu sa drugim igracima.");
				
			// if (exchange_active(playerid))
			// 	return ErrorMsg(playerid, "Vec imate aktivnu zamenu sa nekim igracem.");

   //          exchange_set_menja_id(playerid, gid);
				
			// format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [1/5]", propname(vrsta, PROPNAME_UPPER));
	  //       SPD(playerid, "imovina_zamena_1", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite ime ili ID igraca sa kojim zelite da zamenite imovinu:", "Dalje <", "< Nazad");
		}
	}

	return 1;
}

Dialog:re_prodaja_drzavi(playerid, response, listitem, const inputtext[]) // Prodaja drzavi
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid = GetPVarInt(playerid, "RE_EditID"),
	    gid = re_globalid(vrsta, lid)
	;

   	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	new cena = (RealEstate[gid][RE_CENA]/3)*2;
	
	if (vrsta == firma) // Nekretnina je firma
	{
	    // Isprazni kasu/sef i dodaj taj novac iznosu koji igrac dobija prodajom
	    cena += (RealEstate[gid][RE_NOVAC] > 0)? RealEstate[gid][RE_NOVAC] : 0;
		
		// Resetuj ime firme
	    format(BizInfo[lid][BIZ_NAZIV], 32, "%s", vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_CAPITAL));
	}
	else if (vrsta == kuca) // Nekretnina je kuca
	{
	    // Isprazni kasu/sef i dodaj taj novac iznosu koji igrac dobija prodajom
	    cena += (RealEstate[gid][RE_NOVAC] > 0)? RealEstate[gid][RE_NOVAC] : 0;
		
		// Dodaj cenu objekata
		if (objekti_cena[playerid] > 0)
			cena += objekti_cena[playerid];
			
		objekti_cena[playerid] = 0;

        // Cena garaze
        cena += GetPVarInt(playerid, "RE_HouseGaragePrice");
        DeletePVar(playerid, "RE_HouseGaragePrice");
	}
	
	// Da li je igrac imao spawn unutar nekretnine koju prodaje? Ako da, postavi na default
	if (PI[playerid][p_spawn_vw] == gid && PI[playerid][p_spawn_ent] == RealEstate[gid][RE_ENT])
		dialog_respond:spawn(playerid, 1, 0, "");
	
	strmid(RealEstate[gid][RE_VLASNIK], "Niko", 0, strlen("Niko"), MAX_PLAYER_NAME);
	RealEstate[gid][RE_ZATVORENO]   = 1;
	RealEstate[gid][RE_NOVAC]       = 0;
	
    for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][vrsta]; i++)
    {
        if (pRealEstate[playerid][vrsta][i] == lid)
        {
            pRealEstate[playerid][vrsta][i] = -1;
            break;
        }
    }
	PlayerMoneyAdd(playerid, cena);
    new sMsg[78];
	format(sMsg, sizeof sMsg, "~N~~N~~N~~G~Prodaja nekretnine~n~~w~Prodali ste %s za ~r~%s", propname(vrsta, PROPNAME_AKUZATIV), formatMoneyString(cena));
	GameTextForPlayer(playerid, sMsg, 5000, 3);
	
	// TODO: Kod prodaje hotela izbaciti sve stanare

    new sQuery[70];
	format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery);

	if (vrsta == firma) // Nekretnina je firma, pokreni poseban update query
	{
        BizInfo[lid][BIZ_NOVAC_REKET] = 0;
        BizInfo[lid][BIZ_REKET]       = -1;

		mysql_format(SQL, mysql_upit, 256, "UPDATE %s SET vlasnik = 'Niko', naziv = '%s', novac = 0, novac_reket = 0, reket = -1, zatvoreno = 1 WHERE id = %d", propname(vrsta, PROPNAME_TABLE),
			BizInfo[lid][BIZ_NAZIV], RealEstate[gid][RE_ID]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
	}
	else if (vrsta == kuca) // Nekretnina je kuca, pokreni poseban update query + brisanje svih kupljenih predmeta + otpustanje stanara
	{
        RealEstate[gid][RE_GARAZA_OTKLJUCANA] = 0;
			
		// Resetovanje varijabli za objekte
		for__loop (new i = 0; i < MAX_OBJEKATA; i++)
		{
			H_FURNITURE[lid][i][hf_uid]       = -1;
			H_FURNITURE[lid][i][hf_object_id] = -1;
			H_FURNITURE[lid][i][hf_price] 	 = 0;
			H_FURNITURE[lid][i][hf_name]  	 = EOS;
			if (H_FURNITURE[lid][i][hf_dynid] != -1)
			{
				DestroyDynamicObject(H_FURNITURE[lid][i][hf_dynid]);
				H_FURNITURE[lid][i][hf_dynid] = -1;
			}
		}

        // Resetovanje oruzja
        for__loop (new i = 0; i < 13; i++) 
        {
            H_WEAPONS[lid][i][hw_weapon]  = -1;
            H_WEAPONS[lid][i][hw_ammo]    = 0;
        }

        // Otpustanje stanara
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_stanari WHERE k_id = %i", lid);
        mysql_tquery(SQL, mysql_upit);
		
		// Brisanje objekata iz baze
		format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_predmeti WHERE k_id = %d", lid);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_KOBJEKTI_DELETE);

        // Brisanje oruzja iz baze
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_oruzje WHERE k_id = %d", lid);
        mysql_tquery(SQL, mysql_upit);
		
		// Update podataka u bazi (za kucu)
        new query[160];
		format(query, sizeof query, "UPDATE %s SET vlasnik = 'Niko', novac = 0, zatvoreno = 1, garaza = '%.2f|%.2f|%.2f|%.2f|%i' WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], RealEstate[gid][RE_GARAZA_OTKLJUCANA], RealEstate[gid][RE_ID]);
		mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
	}
	else // Klasicna nekretnina, pokreni obican query
	{
		format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET vlasnik = 'Niko', zatvoreno = 1 WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_ID]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
	}


	format(string_128, sizeof string_128, "%s - PRODAJA (drzava) | Izvrsio: %s | Cena: $%d | ID: %d", propname(vrsta, PROPNAME_UPPER), ime_obicno[playerid], RealEstate[gid][RE_CENA],
		RealEstate[gid][RE_ID]);
	Log_Write(LOG_IMOVINA, string_128);

	re_kreirajpickup(vrsta, gid);
	return 1;
}

Dialog:re_prodaja_igracu_1(playerid, response, listitem, const inputtext[]) // Prodaja igracu: ID
{
	if (!response) 
		return dialog_respond:re_general(playerid, 1, 1, "");


	new
	    naslov[29],
	    targetid,
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
	    gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"))
	;

	if (sscanf(inputtext, "u", targetid))
		return DialogReopen(playerid);

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	format(naslov, sizeof(naslov), "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));

	if (!IsPlayerConnected(targetid)) 
    {
        ErrorMsg(playerid, GRESKA_OFFLINE);
        return DialogReopen(playerid);
    }

    if (targetid == playerid)
        return DialogReopen(playerid);

    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
	if (!IsPlayerInRangeOfPoint(targetid, 5.0, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]))
	{
		ErrorMsg(playerid, "Taj igrac se ne nalazi u Vasoj blizini.");
        return DialogReopen(playerid);
	}

	if (PI[targetid][p_nivo] < RealEstate[gid][RE_NIVO])
        return ErrorMsg(playerid, "Taj igrac nema dovoljan nivo za ovu nekretninu.");

    if (RealEstate_GetPlayerFreeSlots(targetid, vrsta) == 0)
		return ErrorMsg(playerid, "Taj igrac nema slobodnih slotova za %s.", propname(vrsta, PROPNAME_AKUZATIV));

    new minSec = 50 * 3600;
    if (PI[targetid][p_provedeno_vreme] < minSec)
        return ErrorMsg(playerid, "Taj igrac mora imati najmanje 50 sati igre. Trenutno ima %i sati igre.", floatround(PI[targetid][p_provedeno_vreme]/3600.0));

	// ---------- //

	RE_sellingType[playerid] = GetPVarInt(playerid, "RE_Listing");
	RE_sellingTo[playerid] = targetid;
    format(RE_sellingTo_Name[playerid], MAX_PLAYER_NAME, "%s", ime_rp[targetid]);
	SPD(playerid, "re_prodaja_igracu_2", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite iznos koji zelite da Vam ovaj igrac plati.\n\n{FF0000}Napomena: {FFFFFF}Od iznosa se oduzima 10 procenata na ime poreza!", "Dalje »", "« Nazad");

	return 1;
}

Dialog:re_prodaja_igracu_2(playerid, response, listitem, const inputtext[]) // Prodaja igracu: cena
{
	if (!response) 
		return dialog_respond:re_prodaja(playerid, 1, 1, "");

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
	    sTitle[25],
	    cena
	;

	if (sscanf(inputtext, "i", cena) || cena < 1 || cena > 99999999)
		return DialogReopen(playerid);

	//if (!IsPlayerConnected(RE_sellingTo[playerid])) return dialog_respond:re_prodaja_igracu_1(playerid, 1, 0, "-1");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	format(sTitle, sizeof(sTitle), "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));

	if (!IsPlayerInRangeOfPoint(RE_sellingTo[playerid], 5.0, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]))
		return ErrorMsg(playerid, "Taj igrac se vise ne nalazi u Vasoj blizini!");

    if (RealEstate_GetPlayerFreeSlots(RE_sellingTo[playerid], vrsta) == 0)
		return ErrorMsg(playerid, "Taj igrac nema slobodnih slotova za %s.", propname(vrsta, PROPNAME_AKUZATIV));

	// ---------- //


	RE_sellingPrice[playerid] = cena;
	// RE_buyingFrom[RE_sellingTo[playerid]] = playerid;

    new sDialog[250];
	format(sDialog, sizeof sDialog, "{0068B3}Igrac: {FFFFFF}%s\n{0068B3}Cena: {FFFFFF}%s\n{0068B3}Porez: {FFFFFF}%s\n{0068B3}Iznos koji dobijate: {00CC00}%s\n\nDa li zaista zelite da prodate svoju nekretninu\novom igracu i za ovu cenu?", ime_rp[RE_sellingTo[playerid]], formatMoneyString(RE_sellingPrice[playerid]), formatMoneyString(floatround(RE_sellingPrice[playerid]/10.0)), formatMoneyString(floatround(RE_sellingPrice[playerid]/10.0)*9));

	SPD(playerid, "re_prodaja_igracu_3", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Da", "Ne");

	return 1;
}

Dialog:re_prodaja_igracu_3(playerid, response, listitem, const inputtext[]) // Prodaja igracu: ponuda
{
	if (!IsPlayerConnected(RE_sellingTo[playerid])) 
		return SendClientMessage(playerid, SVETLOCRVENA, "* Igrac je napustio server.");

	new
        targetid = RE_sellingTo[playerid],
	    vrsta,
	    sTitle[29]
	;
	vrsta = GetPVarInt(playerid, "RE_Listing");

	format(sTitle, sizeof(sTitle), "{0068B3}%s - KUPOPRODAJA", propname(vrsta, PROPNAME_UPPER));

	format(string_256, 200, "{FFFFFF}Igrac {0068B3}%s {FFFFFF}zeli da Vam proda %s.\n\n{0068B3}Cena: {FFFFFF}%s", ime_rp[playerid], propname(vrsta, PROPNAME_AKUZATIV), formatMoneyString(RE_sellingPrice[playerid]));

    RE_buyingFrom[targetid] = playerid;
    RE_buyingPrice[targetid] = RE_sellingPrice[playerid];
    format(RE_buyingFrom_Name[targetid], MAX_PLAYER_NAME, "%s", ime_rp[playerid]);
	SPD(targetid, "re_prodaja_igracu_4", DIALOG_STYLE_MSGBOX, sTitle, string_256, "Prihvati", "Odbaci");
	return 1;
}

Dialog:re_prodaja_igracu_4(playerid, response, listitem, const inputtext[]) // Prodaja igracu: dialog prihvati/odbij
{
    if (!IsPlayerConnected(RE_buyingFrom[playerid])) // Prodavac offline
        return SendClientMessage(playerid, SVETLOCRVENA, "* Igrac koji Vam je ponudio prodaju je napustio server.");

    if (!response) // Odbio kupovinu
		SendClientMessage(RE_buyingFrom[playerid], SVETLOCRVENA, "* Igrac je odbio da kupi imovinu koju ste mu ponudili.");

	new
		sellerid = RE_buyingFrom[playerid],
		cena     = RE_sellingPrice[sellerid]
	;

	// Sigurnosne provere
	if (RE_sellingTo[sellerid] != playerid || RE_sellingType[sellerid] == -1 
        || !IsPlayerLoggedIn(playerid) || !IsPlayerLoggedIn(sellerid)
        || cena < 1 || cena > 99999999 || RE_buyingPrice[playerid] != RE_sellingPrice[sellerid])
	{
	    SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (12)");
	}

	if (PI[playerid][p_novac] < cena) // Premalo novca
	{
	    ErrorMsg(playerid, "Nemate dovoljno novca");
	    SendClientMessage(sellerid, SVETLOCRVENA, "* Igrac nema dovoljno novca");
	}

	// Sigurnosne provere (part 2)
	if (!response || !IsPlayerConnected(sellerid) || RE_sellingTo[sellerid] != playerid || RE_sellingType[sellerid] == -1
        || !IsPlayerLoggedIn(sellerid) || !IsPlayerLoggedIn(playerid)
	    || PI[playerid][p_novac] < cena || cena < 1 || cena > 99999999
        || RE_buyingPrice[playerid] != RE_sellingPrice[sellerid]) // Kombinacija svih gorenavedenih uslova (resetovanje varijabli)
	{
		resetuj_prodaju(playerid);
        resetuj_prodaju(sellerid);
        HidePlayerDialog(playerid);
        HidePlayerDialog(sellerid);

		return 1;
	}

	new
	    prilog[6],
	    vrsta = GetPVarInt(sellerid, "RE_Listing"),
        lid   = GetPVarInt(sellerid, "RE_EditID"),
	    gid   = re_globalid(vrsta, lid)
	;

	switch (vrsta)
	{
	    case kuca:      prilog = "svoju";
		case stan:      prilog = "svoj";
		case firma:     prilog = "svoju";
	    case garaza:    prilog = "svoju";
        case vikendica: prilog = "svoju";
	    default:     return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (13)");
	}

	if (vrsta != RE_sellingType[sellerid])
	{
        // Ukoliko je ponudio, a zatim kontrolisao neku drugu imovinu dok kupac nije prihvatio ponudu
		SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (14)");
		SendClientMessage(sellerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (15)");
		return 1;
	}

	// Oduzimanje/dodavanje novca i prebacivanje imovine
	PlayerMoneySub(playerid, cena);
	PlayerMoneyAdd(sellerid, floatround(cena/10.0)*9);

    // Promena vlasnistva
    for__loop (new i = 0; i < PI[sellerid][p_nekretnine_slotovi][vrsta]; i++)
    {
        if (pRealEstate[sellerid][vrsta][i] == lid)
        {
            pRealEstate[sellerid][vrsta][i] = -1;
            break;
        }
    }
    for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi][vrsta]; i++)
    {
        if (pRealEstate[playerid][vrsta][i] == -1)
        {
            pRealEstate[playerid][vrsta][i] = lid;
            break;
        }
    }

	// Update informacija o imovini
	strmid(RealEstate[gid][RE_VLASNIK], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), 21);
    re_kreirajpickup(vrsta, gid);
	format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET vlasnik = '%s' WHERE id = %d", propname(vrsta, PROPNAME_TABLE), ime_obicno[playerid], RealEstate[gid][RE_ID]);
 	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s - PRODAJA (igrac) | Izvrsio: %s | Igrac: %s | Cena: $%d | ID: %d", propname(vrsta, PROPNAME_UPPER), ime_obicno[sellerid], ime_obicno[playerid], cena, RealEstate[gid][RE_ID]);
	Log_Write(LOG_IMOVINA, string_128);

	// Slanje poruka igracima
	SendClientMessageF(sellerid, SVETLOPLAVA, "* Uspesno ste prodali %s %s igracu {FFFFFF}%s {33CCFF}za {FFFFFF}%s.", prilog, propname(vrsta, PROPNAME_AKUZATIV), ime_rp[playerid], formatMoneyString(cena));
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste kupili %s od {FFFFFF}%s {33CCFF}za {FFFFFF}%s | Iznos poreza: {FF6347}%s", propname(vrsta, PROPNAME_AKUZATIV), ime_rp[sellerid], formatMoneyString(floatround(cena/10.0)*9), formatMoneyString(floatround(cena/10.0)));

	// Resetovanje
    resetuj_prodaju(playerid);
    resetuj_prodaju(sellerid);
	return 1;
}

Dialog:re_novac(playerid, response, listitem, const inputtext[]) // Novac
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
	    gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID")),
	    naslov[29]
	;
	if (vrsta != kuca && vrsta != firma && vrsta != hotel) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (17)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	format(naslov, sizeof(naslov), "{0068B3}%s - %s", propname(vrsta, PROPNAME_UPPER), (vrsta == kuca)? ("SEF") : ("KASA"));
    if (listitem == 0) // Novac: uzimanje
	{
	    format(string_128, sizeof string_128, "{FFFFFF}Stanje novca: {0068B3}%s\n\n{FFFFFF}Upisite iznos koji zelite da uzmete:", formatMoneyString(RealEstate[gid][RE_NOVAC]));

	    SPD(playerid, "re_novac_uzmi", DIALOG_STYLE_INPUT, naslov, string_128, "Uzmi", "Nazad");
	}
    else if (listitem == 1) // Novac: stavljanje
	{
	    format(string_128, sizeof string_128, "{FFFFFF}Stanje novca: {0068B3}%s\n\n{FFFFFF}Upisite iznos koji zelite da ostavite:", formatMoneyString(RealEstate[gid][RE_NOVAC]));

	    SPD(playerid, "re_novac_stavi", DIALOG_STYLE_INPUT, naslov, string_128, "Ostavi", "Nazad");
	}

	return 1;
}

Dialog:re_kucna_garaza_buy(playerid, response, listitem, const inputtext[]) // Kucna garaza: kupi
{
    new price = GetPVarInt(playerid, "RE_HouseGaragePrice");
    DeletePVar(playerid, "RE_HouseGaragePrice");
        
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    if (price <= 1)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (45)");

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"))
    ;

    if (RealEstate[gid][RE_GARAZA][0] == 0.0)
        return ErrorMsg(playerid, "Vasa kucna nema garazu.");

    if (PI[playerid][p_novac] < price)
        return ErrorMsg(playerid, "Nemate dovoljno novca.");

    if (vrsta != kuca)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (42)");

    RealEstate[gid][RE_GARAZA_OTKLJUCANA] = 1;
    PlayerMoneySub(playerid, price);

    // TODO: pickup update

    // Update podataka u bazi
    new query[110];
    format(query, sizeof query, "UPDATE re_kuce SET garaza = '%.2f|%.2f|%.2f|%.2f|1' WHERE id = %d", RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], RealEstate[gid][RE_ID]);
    mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

    // Upisivanje u log
    new logString[68];
    format(logString, sizeof logString, "KUCNA GARAZA | KUPOVINA | %s | %d", ime_obicno[playerid], price);
    Log_Write(LOG_IMOVINA, logString);
    return 1;
}

Dialog:re_kucna_garaza_sell(playerid, response, listitem, const inputtext[]) // Kucna garaza: prodaj
{
    new price = GetPVarInt(playerid, "RE_HouseGaragePrice");
    DeletePVar(playerid, "RE_HouseGaragePrice");
        
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    if (price <= 1)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (44)");

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"))
    ;

    if (RealEstate[gid][RE_GARAZA][0] == 0.0)
        return ErrorMsg(playerid, "Vasa kucna nema garazu.");

    if (vrsta != kuca)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (43)");

    RealEstate[gid][RE_GARAZA_OTKLJUCANA] = 0;
    PlayerMoneyAdd(playerid, price);

    // TODO: pickup update

    // Update podataka u bazi
    new query[110];
    format(query, sizeof query, "UPDATE re_kuce SET garaza = '%.2f|%.2f|%.2f|%.2f|0' WHERE id = %d", RealEstate[gid][RE_GARAZA][0], RealEstate[gid][RE_GARAZA][1], RealEstate[gid][RE_GARAZA][2], RealEstate[gid][RE_GARAZA][3], RealEstate[gid][RE_ID]);
    mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

    // Upisivanje u log
    new logString[67];
    format(logString, sizeof logString, "KUCNA GARAZA | PRODAJA | %s | %d", ime_obicno[playerid], price);
    Log_Write(LOG_IMOVINA, logString);
    return 1;
}

Dialog:re_novac_uzmi(playerid, response, listitem, const inputtext[]) // Novac: uzimanje
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid   = GetPVarInt(playerid, "RE_EditID"),
	    gid   = re_globalid(vrsta, lid),
        iznos
	;

	if (vrsta != kuca && vrsta != firma && vrsta != hotel) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (19)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	if (sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 9999999)
		return DialogReopen(playerid);

	if (RealEstate[gid][RE_NOVAC] < iznos) // Nema dovoljno novca
	{
	    ErrorMsg(playerid, "Nemate toliko novca u %s.", (vrsta == kuca)? ("sefu") : ("kasi"));
		return DialogReopen(playerid);
	}

    if ((PI[playerid][p_novac] + iznos) > 99999999)
    {
        ErrorMsg(playerid, "Mozete nositi najvise $99.999.999 sa sobom. Unesite neki manji iznos.");
        return DialogReopen(playerid);
    }

	RealEstate[gid][RE_NOVAC] -= iznos;
	PlayerMoneyAdd(playerid, iznos);
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET novac = %d WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_NOVAC], RealEstate[gid][RE_ID]);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

	// Slanje poruke igracu
	SendClientMessageF(playerid, (vrsta == kuca)? 0x48E31CFF : 0x33CCFFFF, "(%s) {FFFFFF}Uzeli ste %s iz %s.", propname(vrsta, PROPNAME_LOWER), formatMoneyString(iznos), (vrsta == kuca)? ("sefa") : ("kase"));

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s (%i) | UZIMANJE | Igrac: %s | $%d | $%d -> $%d", propname(vrsta, PROPNAME_UPPER), lid, ime_obicno[playerid], iznos, RealEstate[gid][RE_NOVAC] + iznos,
		RealEstate[gid][RE_NOVAC]);
	Log_Write(LOG_RENOVAC, string_128);

	RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	return 1;
}

Dialog:re_novac_stavi(playerid, response, listitem, const inputtext[]) // Novac: stavljanje
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta,
	    gid
	;
	vrsta = GetPVarInt(playerid, "RE_Listing");
	gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"));

	if (vrsta != kuca && vrsta != firma) return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (21)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes %s.", propname(vrsta, PROPNAME_AKUZATIV));

	new
		iznos
	;
	if (sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 9999999) 
		return DialogReopen(playerid);

	if (PI[playerid][p_novac] < iznos) // Nema dovoljno novca
	{
	    ErrorMsg(playerid, "Nemate toliko novca u kod sebe.");
		return DialogReopen(playerid);
	}

    if ((RealEstate[gid][RE_NOVAC] + iznos) > 99999999)
    {
        ErrorMsg(playerid, "Mozete imati najvise $99.999.999 u %s. Unesite neki manji iznos.", (vrsta == kuca)? ("sefu") : ("kasi"));
        return DialogReopen(playerid);
    }

	RealEstate[gid][RE_NOVAC] += iznos;
	PlayerMoneySub(playerid, iznos);

	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET novac = %d WHERE id = %d", propname(vrsta, PROPNAME_TABLE), RealEstate[gid][RE_NOVAC], RealEstate[gid][RE_ID]);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

	// Slanje poruke igracu
	SendClientMessageF(playerid, ((vrsta == kuca)? 0x48E31CFF : 0x33CCFFFF), "(%s) {FFFFFF}Stavili ste ste %s u %s.", propname(vrsta, PROPNAME_LOWER), formatMoneyString(iznos), (vrsta == kuca)? ("sef") : ("kasu"));

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | STAVLJANJE | Igrac: %s | $%d | $%d -> $%d", propname(vrsta, PROPNAME_UPPER), ime_obicno[playerid], iznos, RealEstate[gid][RE_NOVAC] - iznos,
		RealEstate[gid][RE_NOVAC]);
	Log_Write(LOG_RENOVAC, string_128);

	RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	return 1;
}

Dialog:re_proizvodi(playerid, response, listitem, const inputtext[]) // Proizvodi
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));
		
	new
		vrsta_f,
	    vrsta,
	    gid
	;
	vrsta   = GetPVarInt(playerid, "RE_Listing");
	gid     = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"));
	vrsta_f = RealEstate[gid][RE_VRSTA];

	if (vrsta != firma) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (23)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes firmu.");

		
    new string[1024];
	switch (listitem)
	{
		case 0: // Stanje
		{
			string[0] = EOS;
			for__loop (new i = 0; i < sizeof(proizvodi[]) && proizvodi[vrsta_f][i] > 0; i++)
			{
				format(string, sizeof(string), "%s{0068B3}%s: {FFFFFF}%d (%s)\n", string, PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv], 
					F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_stock], formatMoneyString(F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_cena]));
			}
					
			SPD(playerid, "re_proizvodi_return", DIALOG_STYLE_MSGBOX, "{0068B3}FIRMA - PROIZVODI", string, "Nazad", "");
		}
		case 1: // Izmena cena
		{
            // Formatiranje stringa za dialog
			format(string, sizeof(string), "Naziv proizvoda\tTrenutna cena");
			for__loop (new i = 0; i < sizeof(proizvodi[]) && proizvodi[vrsta_f][i] > 0; i++)
				format(string, sizeof(string), "%s\n%s\t$%d", string, PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv], F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_cena]);
					
			SPD(playerid, "re_proizvodi_cena", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}FIRMA - PROIZVODI", string, "Izmeni", "Nazad");
		}
		case 2: // Narucivanje
		{
			if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2271.0747,-2352.5740,13.5469))
				return ErrorMsg(playerid, "Ne nalazite se na mestu za narucivanje proizvoda (dokovi).");

            // Formatiranje stringa za dialog
            format(string, sizeof(string), "Naziv proizvoda\tJedinicna cena za porudzbinu");
            for__loop (new i = 0; i < sizeof(proizvodi[]) && proizvodi[vrsta_f][i] > 0; i++) 
            {
                new unitPrice = PRODUCTS[ proizvodi[vrsta_f][i] ][pr_cena]/3;
                if (unitPrice <= 0) unitPrice = 1;
                format(string, sizeof(string), "%s\n%s\t$%d", string, PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv], unitPrice);
            }
                    
            SPD(playerid, "re_proizvodi_narucivanje", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}FIRMA - PROIZVODI", string, "Dalje »", "« Nazad");
		}
	}
	return 1;
}
Dialog:re_proizvodi_return(playerid, response, listitem, const inputtext[])
{
	return dialog_respond:re_general(playerid, 1, 6, "");
}
Dialog:re_proizvodi_cena(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:re_general(playerid, 1, 6, "");

	new
	    vrsta   = GetPVarInt(playerid, "RE_Listing"), // Vrsta nekretnine
		lid     = GetPVarInt(playerid, "RE_EditID"),
	    gid     = re_globalid(firma, lid),
		vrsta_f = RealEstate[gid][RE_VRSTA],
		pid     = proizvodi[vrsta_f][listitem] // ID proizvoda
	;

	if (vrsta != firma) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (25)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne podesujes firmu.");
		

	SetPVarInt(playerid, "RE_BizProductInfo", listitem); // Ovde bi trebalo upisati ID proizvoda, ali ipak upisujem listitem, da bih kasnije mogao da re-showujem ovaj isti dialog
    // (sledeci korak, ako je nepravilan unos). Preko listitem-a se lako dobije i ID proizvoda, isto kao gore (pid = ...)
	
	format(string_256, sizeof string_256, "{FFFFFF}Proizvod: {0068B3}%s\n{FFFFFF}Prava cena: {0068B3}$%d\n{FFFFFF}Vasa cena: {0068B3}$%d\n\n{FFFFFF}Upisite novu cenu za ovaj proizvod:",
	PRODUCTS[pid][pr_naziv], PRODUCTS[pid][pr_cena], F_PRODUCTS[lid][pid][f_cena]);
	SPD(playerid, "re_proizvodi_update", DIALOG_STYLE_INPUT, "{0068B3}FIRMA - PROIZVODI", string_256, "Izmeni", "Nazad");
		
	return 1;
}

Dialog:re_proizvodi_update(playerid, response, listitem, const inputtext[]) // Update cene proizvoda
{
	if (!response)
		return dialog_respond:re_proizvodi(playerid, 1, 1, "");

	new
		vrsta   = GetPVarInt(playerid, "RE_Listing"), // Vrsta nekretnine
        gid     = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID")),
        vrsta_f = RealEstate[gid][RE_VRSTA],
        pid     = proizvodi[vrsta_f][ GetPVarInt(playerid, "RE_BizProductInfo") ], // ID proizvoda
        lid     = re_localid(firma, gid),
		iznos,
        staraCena
	;
	

	if (vrsta != firma) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (27)");

	if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
		return ErrorMsg(playerid, "Ne posedujes firmu.");
		
	if (sscanf(inputtext, "i", iznos) || iznos < 1 || iznos > 99999999)
		return DialogReopen(playerid);

    if (vrsta_f == FIRMA_ORUZARNICA && iznos < PRODUCTS[pid][pr_cena])
    {
        ErrorMsg(playerid, "Minimalna cena za ovo oruzje mora iznositi %s.", formatMoneyString(PRODUCTS[pid][pr_cena]));
        return DialogReopen(playerid);
    }

    else if (vrsta_f == FIRMA_BENZINSKA && iznos > 150)
    {
        ErrorMsg(playerid, "Maksimalna cena goriva moze iznositi $150.");
        return DialogReopen(playerid);
    }

    else if (vrsta_f != FIRMA_BENZINSKA)
    {
        if (iznos > floatround(PRODUCTS[pid][pr_cena] * 1.3))
        {
            ErrorMsg(playerid, "Maksimalna cena ovog proizvoda moze iznositi %s.", formatMoneyString(floatround(PRODUCTS[pid][pr_cena]*1.3)));
            return DialogReopen(playerid);
        }

        if (iznos < floatround(PRODUCTS[pid][pr_cena] * 0.7))
        {
            ErrorMsg(playerid, "Minimalna cena ovog proizvoda moze iznositi %s.", formatMoneyString(floatround(PRODUCTS[pid][pr_cena]*0.7)));
            return DialogReopen(playerid);
        }
    }
        
        
    staraCena = F_PRODUCTS[lid][pid][f_cena];
    F_PRODUCTS[lid][pid][f_cena] = iznos;
	
	// Upisivanje u bazu
	format(mysql_upit, sizeof mysql_upit, "UPDATE re_firme_proizvodi SET cena = %d WHERE fid = %d AND pid = %d", iznos, lid, pid);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_PROIZVODIUPDATE);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "(firma) {FFFFFF}Izmenili ste cenu proizvoda. %s ($%d -> $%d)", PRODUCTS[pid][pr_naziv], staraCena, iznos);
	
	// Upisivanje u log
    format(string_128, sizeof string_128, "IZMENA CENE | Firma [%d] | %s je izmenio cenu za %s ($%d -> $%d)", lid, ime_obicno[playerid], PRODUCTS[pid][pr_naziv], staraCena, iznos);
    Log_Write(LOG_FIRME, string_128);


    // Izmena label-a za benzinsku
    if (vrsta_f == FIRMA_BENZINSKA && pid == 48)
    {
        format(string_128, sizeof string_128, "[ Benzinska pumpa ]\n\n{FFFFFF}Upisite {FFFF00}/tocenje {FFFFFF}da natocite gorivo\n1 litar = $%d", F_PRODUCTS[lid][pid][f_cena]);
        UpdateDynamic3DTextLabelText(RealEstate[gid][RE_LABEL_2], 0xFFFF00FF, string_128);
    }
	return 1;
}

Dialog:re_proizvodi_narucivanje(playerid, response, listitem, const inputtext[]) // Narucivanje proizvoda
{
    if (!response)
        return dialog_respond:re_general(playerid, 1, 6, "");

    new
        vrsta   = GetPVarInt(playerid, "RE_Listing"), // Vrsta nekretnine
        gid     = re_globalid(firma, GetPVarInt(playerid, "RE_EditID")),
        vrsta_f = RealEstate[gid][RE_VRSTA], // Vrsta firme
        pid     = proizvodi[vrsta_f][listitem] // ID proizvoda
    ;

    if (vrsta != firma) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (29)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes firmu.");
        
    SetPVarInt(playerid, "RE_BizProductInfo", listitem);
    
    // Formatiranje stringa za dialog
    new unitPrice = PRODUCTS[pid][pr_cena]/3;
    if (unitPrice <= 0) unitPrice = 1; // minimum 1
    format(string_256, sizeof string_256, "{FFFFFF}Narucivanje proizvoda: {0068B3}%s\n{FFFFFF}Trenutno stanje: {0068B3}%d\n{FFFFFF}Cena za narucivanje: {0068B3}%s {FFFFFF}(za 1 kom)\n\nUpisite kolicinu koju zelite da porucite:", PRODUCTS[pid][pr_naziv], F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock], formatMoneyString(unitPrice));
    SPD(playerid, "f_proizvodi_provera", DIALOG_STYLE_INPUT, "{0068B3}FIRMA - PROIZVODI", string_256, "Dalje »", "« Nazad");

    return 1;
}

Dialog:f_proizvodi_provera(playerid, response, listitem, const inputtext[]) // Provera kolicine i cene
{
    if (!response)
        return dialog_respond:re_proizvodi(playerid, 1, 2, "");

    new
        vrsta   = GetPVarInt(playerid, "RE_Listing"),
        gid     = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID")),
        vrsta_f = RealEstate[gid][RE_VRSTA],
        pid     = proizvodi[vrsta_f][ GetPVarInt(playerid, "RE_BizProductInfo") ],
        kolicina
    ;

    if (vrsta != firma) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (31)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes firmu.");

    if (sscanf(inputtext, "i", kolicina))
        return DialogReopen(playerid);

    if (kolicina < 1 || kolicina > 1000) 
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i 1000 komada.");
        return DialogReopen(playerid);
    }

    new unitPrice = floatround(PRODUCTS[pid][pr_cena]/3.0);
    if (unitPrice <= 0) unitPrice = 1; // minimum 1
    SetPVarInt(playerid, "reOrderPrice", unitPrice*kolicina);
    SetPVarInt(playerid, "reOrderQuantity", kolicina);

    // Formatiranje dialoga
    format(string_256, 200, "{FFFFFF}Naziv proizvoda: {0068B3}%s\n\n{FFFFFF}Narucivanje {0068B3}%d {FFFFFF}komada ovog proizvoda ce Vas kostati {0068B3}$%d.",
        PRODUCTS[pid][pr_naziv], kolicina, GetPVarInt(playerid, "reOrderPrice"));
    SPD(playerid, "re_proizvodi_potvrda", DIALOG_STYLE_MSGBOX, "{0068B3}FIRMA - PROIZVODI", string_256, "Naruci", "Odustani");

    return 1;
}

Dialog:re_proizvodi_potvrda(playerid, response, listitem, const inputtext[]) // Finalna provera i potvrda porudbine
{
    if (!response)
        return dialog_respond:re_proizvodi(playerid, 1, 2, "");

    new
        vrsta   = GetPVarInt(playerid, "RE_Listing"),
        gid     = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID")),
        vrsta_f = RealEstate[gid][RE_VRSTA],
        pid     = proizvodi[vrsta_f][ GetPVarInt(playerid, "RE_BizProductInfo") ],
        lid     = re_localid(firma, gid)
    ;

    if (vrsta != firma) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (33)");

    if (RealEstate_CheckPlayerPosession(playerid, vrsta) == 0)
        return ErrorMsg(playerid, "Ne posedujes firmu.");

    if (GetPVarInt(playerid, "reOrderPrice") > RealEstate[gid][RE_NOVAC]) {
        ErrorMsg(playerid, "Nemate dovoljno novca u kasi firme da biste porucili ove proizvode.");
        return dialog_respond:re_proizvodi(playerid, 1, 2, "");
    }

    RealEstate[gid][RE_NOVAC] -= GetPVarInt(playerid, "reOrderPrice");
    F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock] += GetPVarInt(playerid, "reOrderQuantity");

    // Slanje poruke igracu
    SendClientMessage(playerid, SVETLOPLAVA, "(firma) {FFFFFF}Uspesno ste porucili proizvode.");
    SendClientMessageF(playerid, BELA, "* Porucili ste {33CCFF}%s {FFFFFF}| %d komada za $%d", PRODUCTS[pid][pr_naziv], GetPVarInt(playerid, "reOrderQuantity"), GetPVarInt(playerid, "reOrderPrice"));

    // Upisivanje u bazu
    format(mysql_upit, sizeof mysql_upit, "UPDATE re_firme SET novac = %d WHERE id = %d", RealEstate[gid][RE_NOVAC], lid);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
    format(mysql_upit, 90, "UPDATE re_firme_proizvodi SET stock = %d WHERE fid = %d AND pid = %d", F_PRODUCTS[RealEstate[gid][RE_ID]][pid][f_stock], lid, pid);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_PROIZVODIUPDATE);

    // Upisivanje u log
    format(string_128, sizeof string_128, "PORUCIVANJE | Firma [%d] | %s je porucio %s (kolicina: %d)", lid, ime_obicno[playerid], PRODUCTS[pid][pr_naziv], GetPVarInt(playerid, "reOrderQuantity"));
    Log_Write(LOG_FIRME, string_128);

    return 1;
}

Dialog:re_cena_sobe(playerid, response, listitem, const inputtext[])
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
		lid   = GetPVarInt(playerid, "RE_EditID"),
	    gid   = re_globalid(vrsta, lid),
		input
	;
	
	if (vrsta != hotel)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (35)");

    if (RealEstate_CheckPlayerPosession(playerid, hotel) == 0)
		return ErrorMsg(playerid, "Ne posedujes hotel.");
		
	if (sscanf(inputtext, "i", input) || input < 0 || input > 65535)
		return DialogReopen(playerid);
		
	if (input == RealEstate[gid][RE_CENA_SOBE]) // Nije napravljena nikakva izmena
		return 1;
	
	
	if (input == 0)
	{
		SendClientMessage(playerid, SVETLOPLAVA, "* Onemogucili ste iznajmljivanje soba u hotelu.");
	}
	else
	{
		format(string_128, sizeof string_128, "* Postavili ste novu cenu sobe u hotelu | $%d ? $%d", RealEstate[gid][RE_CENA_SOBE], input);
		SendClientMessage(playerid, SVETLOPLAVA, string_128);
	}
	
	
	RealEstate[gid][RE_CENA_SOBE] = input;
	
	// Update podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE re_hoteli SET cena_sobe = %d WHERE id = %d", input, lid);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
	
	return 1;
}

Dialog:re_hoteli_stanari(playerid, response, listitem, const inputtext[]) 
{
	if (!response) 
		return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

	new
	    vrsta = GetPVarInt(playerid, "RE_Listing"),
		lid   = GetPVarInt(playerid, "RE_EditID")
	;
	
	if (vrsta != hotel)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (37)");

    if (RealEstate_CheckPlayerPosession(playerid, hotel) == 0)
		return ErrorMsg(playerid, "Ne posedujes hotel.");
			
	if (listitem < 0 || listitem >= MAX_HOTEL_SOBA) // Array index out of bounds
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (38)");
		
	if (stanari_li[listitem] == INVALID_PLAYER_ID) // Prazan slot
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (39)");

	
	// Brisanje iz baze
	format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_hoteli_stanari WHERE player_id = %d AND hotel_id = %d", stanari_li[listitem], lid);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_HOTEL_DELETE);
	
	// Ako je igrac online, updateovati varijablu i poslati mu poruku da je izbacen
	foreach (new i : Player)
	{
		if (PI[i][p_id] == stanari_li[listitem])
		{
			// Resetovanje varijabli
			PI[i][p_hotel_soba] = -1;
			PI[i][p_hotel_cena] = 0; // 0 = ne renta nigde 
			
			// Slanje poruke igracu
			SendClientMessage(playerid, TAMNOCRVENA, "* Izbaceni ste iz hotela u kome ste iznajmljivali sobu.");
	
			// Promena spawna
			dialog_respond:spawn(playerid, 1, 0, "");
		
			// Update igracevih podataka u bazi
			// Update se ne vrsi ako je igrac offline, jer se za taj slucaj vrsi provera kada igrac udje na server, da bi dobio obavestenje o izbacivanju
			format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_soba = -1, hotel_cena = 0 WHERE id = %d", stanari_li[listitem]);
			mysql_tquery(SQL, mysql_upit);
		}
	}
	
	// Slanje poruke igracu (vlasniku hotela)
	SendClientMessage(playerid, SVETLOPLAVA, "* Uspesno ste izbacili ovog stanara. Njegova soba je sada prazna.");
	
	return 1;
}

Dialog:re_hotel_iznajmi(playerid, response, listitem, const inputtext[]) // Checkpoint pitanje za iznajmljivanje hotela
{
	if (!response)
		return 1;
		
	if (gPropertyPickupGID[playerid] == -1)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (40)");
		
	new
		gid   = gPropertyPickupGID[playerid],
		vrsta = re_odredivrstu(gid),
		lid   = re_localid(vrsta, gid)
	;
	if (vrsta != hotel)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (41)");
		
	if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]))
	{
		if (PI[playerid][p_hotel_soba] != -1)
			return ErrorMsg(playerid, "Vec imate iznajmljenu sobu u drugom hotelu. Koristite \"/odjavihotel\", pa pokusajte ponovo.");
			
		// Da li je moguce iznajmiti sobu u tom hotelu?
		if (RealEstate[gid][RE_CENA_SOBE] == 0) // 0 = ne moze
			return ErrorMsg(playerid, "Vlasnik ovog hotela vise ne prima nove stanare. Pokusajte u nekom drugom hotelu.");
			
		// Da li ima mesta u hotelu?
		new x = 0;
		for__loop (new i = 0; i < RealEstate[gid][RE_SLOTOVI]; i++)
		{
			if (RE_HOTELS[lid][i][rh_player_id] == INVALID_PLAYER_ID) // Prazan slot; TODO: Resetovati ovu varijabli na ongamemodeinit
			{
				x ++;
				break;
			}
		}
		if (x == 0)
			return ErrorMsg(playerid, "Nema slobodnih soba u ovom hotelu.");
			
			
		
		PI[playerid][p_hotel_soba] = lid;
		PI[playerid][p_hotel_cena] = RealEstate[gid][RE_CENA_SOBE];
			
		
		// Brisanje svih prethodnih unosa iz tabele za stanare
		format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_hoteli_stanari WHERE player_id = %d", PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_HOTEL_DELETE);
		
		// Insert u tabelu za stanare
		format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_hoteli_stanari (hotel_id, player_id) VALUES (%d, %d)", lid, PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_HOTEL_INSERT);
		
		// Update igracevih podataka u bazi
		format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_soba = %d, hotel_cena = %d WHERE id = %d", lid, RealEstate[gid][RE_CENA_SOBE], PI[playerid][p_id]);
		mysql_tquery(SQL, mysql_upit);
		
		// Slanje poruke igracu
		format(string_128, sizeof string_128, "* Iznajmili ste sobu u ovom hotelu. Cena sobe: {FFFFFF}%s.", formatMoneyString(RealEstate[gid][RE_CENA_SOBE]));
		SendClientMessage(playerid, SVETLOPLAVA, string_128);
		
		// Promena spawna
		dialog_respond:spawn(playerid, 1, 8, "");
	}
	else
		return ErrorMsg(playerid, "Morate biti na recepciji hotela da biste koristili ovu naredbu.");
	
	return 1;
}

Dialog:re_firma_kupovina(playerid, response, listitem, const inputtext[]) // Kupovina u nekoj firmi
{
	if (!response) return firma_kupuje[playerid] = -1;

	new
		vrsta,
	    gid,
		lid,
		pid,
		cena,
		naziv[32],
		glad_oduzmi = -1,
        bool:reopenStoreDialog = true // Ponovo otvori dialog za kupovinu? NE kada se kupuje telefon/sim kartica, inace DA
	;
	gid = firma_kupuje[playerid];
	lid = re_localid(firma, gid);
	if (lid < 0 || lid >= MAX_FIRMI) return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (42)"); // Nevazeci local ID

	vrsta = RealEstate[gid][RE_VRSTA]; // Vrsta firme, NE[!] vrsta nekretnine
	pid   = proizvodi[vrsta][listitem]; // ID proizvoda
	cena  = F_PRODUCTS[lid][pid][f_cena]; // Cena proizvoda
	strmid(naziv, PRODUCTS[pid][pr_naziv], 0, strlen(PRODUCTS[pid][pr_naziv]), 32); // Naziv proizvoda

	if (vrsta < 1) // Nepoznata vrsta firme
	{
		SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (43)");
		firma_kupuje[playerid] = -1;

	    return 1;
	}
	if (PI[playerid][p_novac] < cena) // Nema dovoljno novca
	{
	    ErrorMsg(playerid, "Nemate dovoljno novca za ovaj proizvod.");
		firma_kupuje[playerid] = -1;

	    return 1;
	}
	if (F_PRODUCTS[lid][pid][f_stock] <= 0) // Proizvoda nema na lageru (proverava se SAMO! ako firma ima vlasnika)
	{
		GameTextForPlayer(playerid, "~r~Rasprodato", 2500, 3);
		firma_kupuje[playerid] = -1;

		return 1;
	}

    DeletePVar(playerid, "pVehicleAlarmSecurity"); // Security Shop
    DeletePVar(playerid, "pVehicleAlarmPrice"); // Security Shop
    DeletePVar(playerid, "pVehicleAlarmBizGID"); // Security Shop
    DeletePVar(playerid, "pBuyingHouseSafe"); // Sef za kucu
    DeletePVar(playerid, "pBuyingSafe_BizID"); // Sef za kucu
	switch (pid)
	{
	    case 1: // Bon ($100)
	    {
            if (!igrac_ima_mobilni(playerid) || !igrac_ima_sim(playerid))
                return ErrorMsg(playerid, "Morate posedovati mobilni telefon i SIM karticu (kupite ih u tech shopu).");

            if ((PI[playerid][p_sim_kredit] + 100) > 65535)
                return ErrorMsg(playerid, "Mozete imati najvise $65.535 kredita.");

            PI[playerid][p_sim_kredit] += 100;

            new query[57];
            format(query, sizeof query, "UPDATE igraci SET sim_kredit = %i WHERE id = %i", PI[playerid][p_sim_kredit], PI[playerid][p_id]);
            mysql_tquery(SQL, query);
		}
		case 2: // Telefonski imenik
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite telefonski imenik.");

			if (BP_PlayerHasItem(playerid, ITEM_IMENIK))
				return ErrorMsg(playerid, "Vec imate telefonski imenik.");

			BP_PlayerItemAdd(playerid, ITEM_IMENIK);
        }
        case 3: // Torba
        {
			if (BP_PlayerHasBackpack(playerid))
				return ErrorMsg(playerid, "Vec imate ranac.");
				
			BP_PlayerItemAdd(playerid, ITEM_RANAC);
        }
        case 4: // Naocare
        {

        }
        case 5: // Pizza
        {
            if (!BP_PlayerHasBackpack(playerid))
                glad_oduzmi = 15; // Nema ranaca -> jede odmah

            else
            {
                if (BP_PlayerItemGetCount(playerid, ITEM_PIZZA) < BP_GetItemCountLimit(ITEM_PIZZA))
                    BP_PlayerItemAdd(playerid, ITEM_PIZZA);
                else 
                    glad_oduzmi = 15; // ranac pun -> jede odmah
            }
        }
        case 6: // Cvece
        {
			GivePlayerWeapon(playerid, 14, 1);
        }
        case 7: // Kanister
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac.");

            if (BP_PlayerHasItem(playerid, ITEM_KANISTER))
                return ErrorMsg(playerid, "Vec imate kanister.");
                
            BP_PlayerItemAdd(playerid, ITEM_KANISTER, 1);
        }
        case 8: // Paklica cigareta
        {
            new count = 5; // koliko se dodaje prilikom kupovine

			if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite cigarete.");

            if (BP_GetItemCountLimit(ITEM_CIGARETE) < (BP_PlayerItemGetCount(playerid, ITEM_CIGARETE) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %i cigareta sa sobom (trenutno ih imate %i).", floatround(BP_GetItemCountLimit(ITEM_CIGARETE)/count), floatround(BP_PlayerItemGetCount(playerid, ITEM_CIGARETE)/count));
				
			BP_PlayerItemAdd(playerid, ITEM_CIGARETE, count);
        }
        case 9: // Upaljac
        {
			new count = 4; // koliko se dodaje prilikom kupovine
            
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite upaljac.");

            if (BP_GetItemCountLimit(ITEM_UPALJAC) < (BP_PlayerItemGetCount(playerid, ITEM_UPALJAC) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %i upaljaca sa sobom (trenutno ih imate %i).", floatround(BP_GetItemCountLimit(ITEM_UPALJAC)/count), floatround(BP_PlayerItemGetCount(playerid, ITEM_UPALJAC)/count));
                
            BP_PlayerItemAdd(playerid, ITEM_UPALJAC, count);
        }
        case 114: //Alkohol
        {
            new count = 200; // koliko se dodaje prilikom kupovine (200ml)
            
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite alkohol.");

            if (BP_GetItemCountLimit(ITEM_ALKOHOL) < (BP_PlayerItemGetCount(playerid, ITEM_ALKOHOL) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %.1fl alkohola sa sobom (trenutno imate %.1fl).", BP_GetItemCountLimit(ITEM_ALKOHOL)/1000.0, BP_PlayerItemGetCount(playerid, ITEM_ALKOHOL)/1000.0);
                
            BP_PlayerItemAdd(playerid, ITEM_ALKOHOL, count);
        }
        case 115: // Destilovana voda
        {
            new count = 500; // koliko se dodaje prilikom kupovine (500ml)
            
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite vodu.");

            if (BP_GetItemCountLimit(ITEM_DEMIVODA) < (BP_PlayerItemGetCount(playerid, ITEM_DEMIVODA) + count))
            {
                InfoMsg(playerid, "najvise %d, trenutno %d", BP_GetItemCountLimit(ITEM_DEMIVODA), BP_PlayerItemGetCount(playerid, ITEM_DEMIVODA));
                return ErrorMsg(playerid, "Mozete nositi najvise %.1fl destilovane vode sa sobom (trenutno imate %.1fl).", BP_GetItemCountLimit(ITEM_DEMIVODA)/1000.0, BP_PlayerItemGetCount(playerid, ITEM_DEMIVODA)/1000.0);
            }
                
            BP_PlayerItemAdd(playerid, ITEM_DEMIVODA, count);
        }
        case 10: // Bokser
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

			GivePlayerWeapon(playerid, 1, 1);
        }
        case 11: // Bejzbol palica
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

			GivePlayerWeapon(playerid, 5, 1);
        }
        case 12: // Noz
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

            GivePlayerWeapon(playerid, 4, 1);
        }
        case 13: // 9mm
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

			GivePlayerWeapon(playerid, 22, 50);
        }
        case 14: // Desert Eagle
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

			GivePlayerWeapon(playerid, 24, 35);
        }
        case 15: // MP5
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");

			GivePlayerWeapon(playerid, 29, 100);
        }
        case 16: // M4
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
			GivePlayerWeapon(playerid, 31, 100);
        }
        case 17: // AK-47
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
			GivePlayerWeapon(playerid, 30, 100);
        }
        case 18: // Country Rifle
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
			GivePlayerWeapon(playerid, 33, 40);
        }
        case 121: // Sniper
        {
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
            GivePlayerWeapon(playerid, WEAPON_SNIPER, 50);
        }
        case 19: // Pancir
        {
            new Float:armour, Float:maxArmour=99.0, Float:set;
            GetPlayerArmour(playerid, armour);
            // GetPlayerMaxArmour(playerid, maxArmour);

            set = armour + 50.0;
            if (set > maxArmour) set = maxArmour;
            SetPlayerArmour(playerid, set);
        }
        case 20: // Padobran
        {
			GivePlayerWeapon(playerid, 46, 1);
        }
		// case 42: // Silenced 9mm
		// {
		// 	GivePlayerWeapon(playerid, 23, 40);
		// }
		case 43: // Shotgun
		{
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
			GivePlayerWeapon(playerid, 25, 45);
		}
		case 44: // Combat Shotgun
		{
            if (IsNewPlayer(playerid))
                return overwatch_poruka(playerid, "Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.");
            if(IsPlayerOnLawDuty(playerid)) return overwatch_poruka(playerid, "Policajac na duznosti ne moze kupovati oruzje.");
            
			GivePlayerWeapon(playerid, 27, 60);
		}
        case 32: // Uze
        {
            new count = 1; // koliko se dodaje prilikom kupovine

            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite uze.");

            if (BP_GetItemCountLimit(ITEM_UZE) < (BP_PlayerItemGetCount(playerid, ITEM_UZE) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %i uzadi sa sobom (trenutno ih imate %i).", BP_GetItemCountLimit(ITEM_UZE), BP_PlayerItemGetCount(playerid, ITEM_UZE));
                
            BP_PlayerItemAdd(playerid, ITEM_UZE, count);
        }
        case 33: // Alat za popravku
        {
            new count = 1; // koliko se dodaje prilikom kupovine

            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite alat.");

            if (BP_GetItemCountLimit(ITEM_ALAT) < (BP_PlayerItemGetCount(playerid, ITEM_ALAT) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %i setova alata sa sobom (trenutno ih imate %i).", BP_GetItemCountLimit(ITEM_ALAT), BP_PlayerItemGetCount(playerid, ITEM_ALAT));
                
            BP_PlayerItemAdd(playerid, ITEM_ALAT, count);
        }
        case 34: // Sprej
        {
			GivePlayerWeapon(playerid, 41, 200);
        }
        case 35: // Lopata
        {
			GivePlayerWeapon(playerid, 6, 1);
        }
        case 36: // Snalica za kosu
        {
            new count = 1; // koliko se dodaje prilikom kupovine

            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite snalice.");

            if (BP_GetItemCountLimit(ITEM_SNALICA) < (BP_PlayerItemGetCount(playerid, ITEM_SNALICA) + count))
                return ErrorMsg(playerid, "Mozete nositi najvise %i snalica sa sobom (trenutno ih imate %i).", BP_GetItemCountLimit(ITEM_SNALICA), BP_PlayerItemGetCount(playerid, ITEM_SNALICA));
                
            BP_PlayerItemAdd(playerid, ITEM_SNALICA, count);
        }
        case 37: // Protivpozarni aparat
        {
			GivePlayerWeapon(playerid, 42, 250);
        }
        case 38: // Ljubicasti vibrator
        {
			GivePlayerWeapon(playerid, 10, 1);
        }
        case 39: // Mali beli vibrator
        {
			GivePlayerWeapon(playerid, 11, 1);
        }
        case 40: // Veliki beli vibrator
        {
			GivePlayerWeapon(playerid, 12, 1);
        }
        case 41: // Sivi vibrator
        {
			GivePlayerWeapon(playerid, 13, 1);
        }

        // Technology Store
        case 21:
        {
            strmid(PI[playerid][p_mobilni], "iPhone", 0, strlen("iPhone"), 13);
            SPD(playerid, "phone_choose_sim", DIALOG_STYLE_LIST, "Izaberite operatera", "Telenor\nm:tel\nT-Mobile", "Izaberi", "");
            reopenStoreDialog = false;
        }
        case 22:
        {
            strmid(PI[playerid][p_mobilni], "Samsung", 0, strlen("Samsung"), 13);
            SPD(playerid, "phone_choose_sim", DIALOG_STYLE_LIST, "Izaberite operatera", "Telenor\nm:tel\nT-Mobile", "Izaberi", "");
            reopenStoreDialog = false;
        }
        case 23:
        {
            strmid(PI[playerid][p_mobilni], "Huawei", 0, strlen("Huawei"), 13);
            SPD(playerid, "phone_choose_sim", DIALOG_STYLE_LIST, "Izaberite operatera", "Telenor\nm:tel\nT-Mobile", "Izaberi", "");
            reopenStoreDialog = false;
        }

        case 107:
        {
            if (RealEstate_CheckPlayerPosession(playerid, kuca) == 0)
                return ErrorMsg(playerid, "Ne posedujes kucu.");

            SetPVarInt(playerid, "pBuyingHouseSafe", cena);
            SetPVarInt(playerid, "pBuyingSafe_BizID", gid);
            reopenStoreDialog = false;
        }

        case 108..113: // Sastojci za MDMA i heroin
        {
            new bpItem, count = 10; // 10g
            if (pid == 108) bpItem = ITEM_SAFROL;
            else if (pid == 109) bpItem = ITEM_BROMOPROPAN;
            else if (pid == 110) bpItem = ITEM_METILAMIN;
            else if (pid == 111) bpItem = ITEM_MORFIN;
            else if (pid == 112) bpItem = ITEM_ACETANHIDRID;
            else if (pid == 113) bpItem = ITEM_HLOROFORM;


            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupujete u apoteci.");

            if (BP_GetItemCountLimit(bpItem) < (BP_PlayerItemGetCount(playerid, bpItem) + count))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %ig %s sa sobom (trenutno imate %ig).", BP_GetItemCountLimit(bpItem), PRODUCTS[pid][pr_naziv], BP_PlayerItemGetCount(playerid, bpItem));
            }
                
            BP_PlayerItemAdd(playerid, bpItem, count);

            // Dodavanje " - 100g" u naziv proizvoda za info_msg
            format(naziv, sizeof naziv, "%s - %ig", PRODUCTS[pid][pr_naziv], count);
        }

        case 116: // Adrenalin
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupujete u apoteci.");

            if (BP_GetItemCountLimit(ITEM_ADRENALIN) < (BP_PlayerItemGetCount(playerid, ITEM_ADRENALIN) + 1))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %img adrenalina sa sobom (trenutno imate %img).", BP_GetItemCountLimit(ITEM_ADRENALIN), BP_PlayerItemGetCount(playerid, ITEM_ADRENALIN));
            }
                
            BP_PlayerItemAdd(playerid, ITEM_ADRENALIN, 1);

            // Dodavanje " - 2mg" u naziv proizvoda za info_msg
            format(naziv, sizeof naziv, "%s - %img", PRODUCTS[pid][pr_naziv], 1);
        }

        case 117: // tablete protiv bolova
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupujete u apoteci.");

            if (BP_GetItemCountLimit(ITEM_PAINKILLERS) < (BP_PlayerItemGetCount(playerid, ITEM_PAINKILLERS) + 1))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i tableta sa sobom (trenutno imate %i tableta).", BP_GetItemCountLimit(ITEM_PAINKILLERS), BP_PlayerItemGetCount(playerid, ITEM_PAINKILLERS));
            }
                
            BP_PlayerItemAdd(playerid, ITEM_PAINKILLERS, 1);
        }

        case 118: // Kaciga
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac.");

            if (BP_PlayerHasItem(playerid, ITEM_HELMET))
                return ErrorMsg(playerid, "Vec imate kacigu.");
                
            BP_PlayerItemAdd(playerid, ITEM_HELMET, 1);
        }

        case 119: // Pajser
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite ovaj predmet.");

            if (BP_GetItemCountLimit(ITEM_CROWBAR) < (BP_PlayerItemGetCount(playerid, ITEM_CROWBAR) + 1))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i pajsera sa sobom.", BP_GetItemCountLimit(ITEM_CROWBAR));
            }
                
            BP_PlayerItemAdd(playerid, ITEM_CROWBAR, 1);
        }

        case 120: // Detonator
        {
            if (BP_GetItemCountLimit(ITEM_DETONATOR) < (BP_PlayerItemGetCount(playerid, ITEM_DETONATOR) + 1))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i detonatora sa sobom (trenutno ih imate %i).", BP_GetItemCountLimit(ITEM_DETONATOR), BP_PlayerItemGetCount(playerid, ITEM_DETONATOR));
            }

            BP_PlayerItemAdd(playerid, ITEM_DETONATOR, 1);
        }

        case 24:
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac.");

            if (BP_PlayerHasItem(playerid, ITEM_IPODNANO))
                return ErrorMsg(playerid, "Vec imate iPod Nano.");
                
            BP_PlayerItemAdd(playerid, ITEM_IPODNANO, 1);
        }

        case 25:
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac.");

            if (BP_PlayerHasItem(playerid, ITEM_IPODCLASSIC))
                return ErrorMsg(playerid, "Vec imate iPod Classic.");
                
            BP_PlayerItemAdd(playerid, ITEM_IPODCLASSIC, 1);
        }


        // Teretana
        case 122:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
        }
        case 123:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
        }
        case 124:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
        }
        case 125:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
        }
        case 126:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_GRABKICK);
        }
        case 127:
        {
            SetPlayerFightingStyle(playerid, FIGHT_STYLE_ELBOW);
        }


        // Security Shop
        case 128:
        {
            SetPVarInt(playerid, "pVehicleAlarmPrice", cena);
            SetPVarInt(playerid, "pVehicleAlarmSecurity", 30);
            SetPVarInt(playerid, "pVehicleAlarmBizGID", gid);
            reopenStoreDialog = false;
        }
        case 129:
        {
            SetPVarInt(playerid, "pVehicleAlarmPrice", cena);
            SetPVarInt(playerid, "pVehicleAlarmSecurity", 60);
            SetPVarInt(playerid, "pVehicleAlarmBizGID", gid);
            reopenStoreDialog = false;
        }
        case 130:
        {
            SetPVarInt(playerid, "pVehicleAlarmPrice", cena);
            SetPVarInt(playerid, "pVehicleAlarmSecurity", 80);
            SetPVarInt(playerid, "pVehicleAlarmBizGID", gid);
            reopenStoreDialog = false;
        }
        case 131:
        {
            return InfoMsg(playerid, "Ovaj alarm se moze dobiti donacijom od 5 EUR.");
        }


        // Pijaca
        case 132:
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite ovaj predmet.");

            if (BP_GetItemCountLimit(ITEM_APPLE_SEED) < (BP_PlayerItemGetCount(playerid, ITEM_APPLE_SEED) + 10))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i semena jabuke sa sobom.", BP_GetItemCountLimit(ITEM_APPLE_SEED));
            }
                
            BP_PlayerItemAdd(playerid, ITEM_APPLE_SEED, 10);
        }
        case 133:
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite ovaj predmet.");

            if (BP_GetItemCountLimit(ITEM_PEAR_SEED) < (BP_PlayerItemGetCount(playerid, ITEM_PEAR_SEED) + 10))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i semena kruske sa sobom.", BP_GetItemCountLimit(ITEM_PEAR_SEED));
            }
                
            BP_PlayerItemAdd(playerid, ITEM_PEAR_SEED, 10);
        }
        case 134:
        {
            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Morate imati ranac da biste mogli da kupite ovaj predmet.");

            if (BP_GetItemCountLimit(ITEM_PLUM_SEED) < (BP_PlayerItemGetCount(playerid, ITEM_PLUM_SEED) + 10))
            {
                return ErrorMsg(playerid, "Mozete nositi najvise %i semena sljive sa sobom.", BP_GetItemCountLimit(ITEM_PLUM_SEED));
            }
            
            BP_PlayerItemAdd(playerid, ITEM_PLUM_SEED, 10);
        }


        // Pice
        case 60,61,72..75,80..83,92..94,104,105:
        {
            glad_oduzmi = 3;
        }

        // Hrana
        case 49..59, 62..71, 76..79, 84..91, 95..103:
        {
            glad_oduzmi = floatround(PRODUCTS[proizvodi[vrsta][listitem]][pr_cena]/10);
        }
        default: return ErrorMsg(playerid, "Trenutno ne mozete kupiti ovaj proizvod.");
	}


    // Posebni slucajevi, kada se otvara naredni dialog za nekakav izbor, i novac se ne oduzima odmah
    if (GetPVarInt(playerid, "pVehicleAlarmSecurity") > 0)
    {
        // Alarm za vozilo
        new sDialog[256];
        format(sDialog, 30, "Slot\tModel");
        
        new item = 0;
        for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
        {
            if (pVehicles[playerid][i] == 0) continue; // prazan slot
            
            new veh = pVehicles[playerid][i];
            format(sDialog, sizeof sDialog, "%s\n%d\t%s", sDialog, i+1, imena_vozila[OwnedVehicle_GetModel(veh) - 400]);

            OwnedVehiclesDialog_AddItem(playerid, item++, i);
        }

        if (item == 0) 
            return ErrorMsg(playerid, "Ne posedujes ni jedno vozilo.");
        
        SPD(playerid, "buy_veh_alarm", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}UGRADI ALARM", sDialog, "Ugradi", "");
    }

    else if (GetPVarInt(playerid, "pBuyingHouseSafe") > 0)
    {
        // Sef za kucu
        RealEstate_ChooseProperty(playerid, kuca);
    }

    else
    {
        // Oduzimanje novca igracu
        PlayerMoneySub(playerid, cena);
    }


	// Slanje poruke igracu
 	InfoMsg(playerid, "Kupovina uspesna: {FFFFFF}%s (%s)", naziv, formatMoneyString(cena));
    if (132 <= pid <= 134) SendClientMessage(playerid, BELA, "* Dobili ste 10 semena.");


    // Dodatne informacije o proizvodima
    if (pid == 7) // kanister
        callcmd::kanister(playerid, "");
    else if (pid == 118) // kaciga
        SendClientMessage(playerid, BELA, "* Kacigu cete staviti automatski prilikom sedanja na motor.");
    else if (pid == 33) // alat za popravku
        SendClientMessage(playerid, BELA, "* Za popravku vozila koristite /popravi.");

 	if (glad_oduzmi == 3) // Pice (pice uvek dodaje 3)
 	{
        PI[playerid][p_glad] -= (PI[playerid][p_glad] > glad_oduzmi)? glad_oduzmi : PI[playerid][p_glad];
 	    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_DRINK_SPRUNK);

 	    format(string_128, sizeof string_128, "** %s pije: %s", ime_obicno[playerid], naziv);
 	    RangeMsg(playerid, string_128, LJUBICASTA, 20.0);
 	}
 	else if (glad_oduzmi > 3) // Hrana (hrana uvek dodaje preko 3)
 	{
        PlayerHungerDecrease(playerid, glad_oduzmi);
        callcmd::eat(playerid, "");

 	    format(string_128, sizeof string_128, "** %s jede: %s", ime_obicno[playerid], naziv);
 	    RangeMsg(playerid, string_128, LJUBICASTA, 20.0);
 	}

    if (122 <= pid <= 127)
    {
        // Teretana
        new sQuery[52];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET stil_borbe = %d WHERE id = %d", GetPlayerFightingStyle(playerid), PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
    }

    // Azuriramo lager, ali SAMO! ako firma ima vlasnika
    if (strcmp(RealEstate[gid][RE_VLASNIK], "Niko"))
    {
        new query[128];
        F_PRODUCTS[lid][pid][f_stock] -= 1;
        format(query, sizeof query, "UPDATE re_firme_proizvodi SET stock = %d WHERE fid = %d AND pid = %d", F_PRODUCTS[lid][pid][f_stock], lid, pid);
        mysql_tquery(SQL, query);

        // Dodavanje novca u firmu (opet, samo ako ima vlasnika)
        if (122 <= pid <= 127)
        {
            // 2/3 novca ide u teretanu jer nema nabavke proizvoda
            re_firma_dodaj_novac(gid, floatround(cena/3.0)*2);
        }
        else if (GetPVarInt(playerid, "pVehicleAlarmPrice") > 0 || GetPVarInt(playerid, "pBuyingHouseSafe") > 0)
        {
            // Nema dodavanja kod kupovine alarma (tek u narednom koraku)
        }
        else
        {
            // Svi ostali proizvodi
            re_firma_dodaj_novac(gid, cena);
        }
    }

	// Upisivanje u log
	format(string_128, sizeof string_128, "%s | Igrac: %s | Proizvod: %s ($%d, %d) | Firma: %d", vrstafirme(vrsta, PROPNAME_UPPER), ime_obicno[playerid], naziv, cena, pid, lid);
	Log_Write(LOG_PROIZVODIKUPOVINA, string_128);

	// Ponovno prikazivanje dialoga
    if (reopenStoreDialog)
    {
        antispam[playerid] = 0;
        
        new cmdParams[17];
        format(cmdParams, sizeof cmdParams, "%i", gid);
        callcmd::firmakupi(playerid, cmdParams);
    }

	return 1;
}



Dialog:re_firma_naziv(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid   = GetPVarInt(playerid, "RE_EditID"),
        gid   = re_globalid(vrsta, lid);
    
    if (vrsta != firma)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (45)");

    if (RealEstate_CheckPlayerPosession(playerid, firma) == 0)
        return ErrorMsg(playerid, "Ne posedujes firmu.");
        
    if (strlen(inputtext) < 5 || strlen(inputtext) > 31) {
        ErrorMsg(playerid, "Duzina naziva mora biti izmedju 5 i 31.");
        return DialogReopen(playerid);
    }
    
    
    strmid(BizInfo[lid][BIZ_NAZIV], inputtext, 0, strlen(inputtext), 32);
    re_kreirajpickup(firma, gid);

    SendClientMessageF(playerid, SVETLOPLAVA, "(firma) {FFFFFF}Promenili ste naziv firme u {33CCFF}%s.", inputtext);
    
    // Update podataka u bazi
    mysql_format(SQL, mysql_upit, 128, "UPDATE re_firme SET naziv = '%s' WHERE id = %d", inputtext, lid);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
    
    return 1;
}

Dialog:re_kuce_spisak_stanara(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new 
        query[140],
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid   = re_globalid(vrsta, GetPVarInt(playerid, "RE_EditID"));
    mysql_format(SQL, query, sizeof query, "DELETE from re_kuce_stanari WHERE pid = (SELECT igraci.id FROM igraci WHERE igraci.ime = '%s') AND k_id = %i", inputtext, gid);
    mysql_tquery(SQL, query);

    new name[MAX_PLAYER_NAME];
    format(name, sizeof name, "%s", inputtext);
    new targetid = get_player_id(name);
    if (IsPlayerConnected(targetid))
    {
        SendClientMessage(targetid, TAMNOCRVENA, "* Izbaceni ste iz kuce u kojoj ste iznajmljivali sobu.");

        // Promena spawna
        if (gid == PI[playerid][p_spawn_vw])
        {
            dialog_respond:spawn(playerid, 1, 0, "");
        }
    }


    SendClientMessageF(playerid, SVETLOZELENA, "(kuca) {FFFFFF}Izbacili ste {00FF00}%s {FFFFFF}iz kuce.", inputtext);
    return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));
}

Dialog:re_kuce_rent(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid   = GetPVarInt(playerid, "RE_EditID"),
        gid   = re_globalid(vrsta, lid)
    ;

    if (listitem == 0) // Cena stanarite
    {
        new sDialog[150];

        if (RealEstate[gid][RE_RENT] == 0)
        {
            format(sDialog, sizeof sDialog, "{FFFFFF}Iznajmljivanje sobe u Vasoj kuci je {FF0000}onemoguceno.\n\n{FFFFFF}Da biste omogucili iznajmljivanje, upisite cenu koju ce stanari placati:");
        }
        else
        {
            format(sDialog, sizeof sDialog, "{FFFFFF}Trenutna cena je: {0068B3}%s\n\n{FFFFFF}Upisite novu cenu ili upisite {FF0000}0 {FFFFFF}da onemogucite najam:", formatMoneyString(RealEstate[gid][RE_RENT]));
        }
        SPD(playerid, "re_kuce_stanarina", DIALOG_STYLE_INPUT, "{0068B3}KUCA - CENA STANARINE", sDialog, "Postavi", "« Nazad");
    }
    else if (listitem == 1) // Spisak stanara
    {
        new query[132];
        format(query, sizeof query, "SELECT igraci.ime as ime FROM re_kuce_stanari LEFT JOIN igraci ON igraci.id = re_kuce_stanari.pid WHERE re_kuce_stanari.k_id = %i", lid);
        mysql_tquery(SQL, query, "MYSQL_ListHouseTenants", "ii", playerid, cinc[playerid]);
    }
    return 1;
}

Dialog:re_kuce_stanarina(playerid, response, listitem, const inputtext[])
{
    if (!response) 
        return RealEstate_ChooseProperty(playerid, GetPVarInt(playerid, "RE_Listing"));

    new
        vrsta = GetPVarInt(playerid, "RE_Listing"),
        lid   = GetPVarInt(playerid, "RE_EditID"),
        gid   = re_globalid(vrsta, lid),
        newPrice, 
        oldPrice = RealEstate[gid][RE_RENT]
    ;

    if (sscanf(inputtext, "i", newPrice))
        return DialogReopen(playerid);

    if (newPrice < 0 || newPrice > 50000)
    {
        ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 50000.");
        return DialogReopen(playerid);
    }

    if (oldPrice == newPrice)
    {
        ErrorMsg(playerid, "Ta cena je vec postavljena, upisite drugu vrednost ili odustanite.");
        return DialogReopen(playerid);
    }

    RealEstate[gid][RE_RENT] = newPrice;
    re_kreirajpickup(kuca, gid);

    SendClientMessageF(playerid, SVETLOZELENA, "(kuca) {FFFFFF}Promenili ste cenu stanarine: {00FF00}%s ? %s.", formatMoneyString(oldPrice), formatMoneyString(newPrice));
    SendClientMessageF(playerid, BELA, "* Igraci koji trenutno iznajmljuju sobu ce od sada placati {00FF00}%s.", formatMoneyString(newPrice));

    foreach (new i : Player)
    {
        if (PI[i][p_rent_kuca] == lid)
        {
            SendClientMessageF(i, CRVENA, "(kuca) {FFFFFF}Vlasnik kuce u kojoj iznajmljujete sobu je promenio cenu stanarine: {FF0000}%s ? %s.", formatMoneyString(oldPrice), formatMoneyString(newPrice));
            SendClientMessage(i, BELA, "* Od sada cete sobu placati po novoj ceni. Ukoliko zelite da odjavite sobu, koristite /odjavisobu.");
        }
    }

    new sQuery[50];
    format(sQuery, sizeof sQuery, "UPDATE re_kuce SET rent = %i WHERE id = %i", newPrice, lid);
    mysql_tquery(SQL, sQuery);
    return 1;
}

Dialog:re_a_editprop(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    else
    {
        if (!strcmp(inputtext, "Kuca", true))
        {
            SetPVarInt(playerid, "RE_Listing", kuca);
        }
        if (!strcmp(inputtext, "Stan", true))
        {
            SetPVarInt(playerid, "RE_Listing", stan);
        }
        if (!strcmp(inputtext, "firma", true))
        {
            SetPVarInt(playerid, "RE_Listing", firma);
        }
        if (!strcmp(inputtext, "hotel", true))
        {
            SetPVarInt(playerid, "RE_Listing", hotel);
        }
        if (!strcmp(inputtext, "garaza", true))
        {
            SetPVarInt(playerid, "RE_Listing", garaza);
        }
        if (!strcmp(inputtext, "vikendica", true))
        {
            SetPVarInt(playerid, "RE_Listing", vikendica);
        }


        if (GetPVarInt(playerid, "pEditpropID") > 0)
        {
            // Unet je ID preko komande

            new propId[5];
            valstr(propId, GetPVarInt(playerid, "pEditpropID"));

            if (!strcmp(inputtext, "Imanje", true))
            {
                dialog_respond:imanje_edit_id(playerid, 1, -1, propId);
            }
            else
            {
                dialog_respond:re_a_editprop2(playerid, 1, -1, propId);
            }
        }
        else
        {
            // Nije unet ID preko komande
            if (!strcmp(inputtext, "Imanje", true))
            {
                SPD(playerid, "imanje_edit_id", DIALOG_STYLE_INPUT, "IZMENI IMANJE", "{FFFFFF}Unesite ID imanja kojim zelite da upravljate:", "Dalje »", "« Nazad");
            }
            else
            {
                new dStr[75];
                format(dStr, sizeof dStr, "{FFFFFF}Unesite ID nekretnine [%s] kojom zelite da upravljate:", propname(GetPVarInt(playerid, "RE_Listing"), PROPNAME_UPPER));
                SPD(playerid, "re_a_editprop2", DIALOG_STYLE_INPUT, "IZMENI NEKRETNINU", dStr, "Dalje »", "« Nazad");
            }
        }
    }
    return 1;
}

Dialog:re_a_editprop2(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return PC_EmulateCommand(playerid, "/editprop");

    new vrsta = GetPVarInt(playerid, "RE_Listing"),
        id;

    if (sscanf(inputtext, "i", id))
        return DialogReopen(playerid);

    if (vrsta == kuca && id > RE_GetMaxID_House())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_House());
        return DialogReopen(playerid);
    }
    if (vrsta == stan && id > RE_GetMaxID_Apartment())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Apartment());
        return DialogReopen(playerid);
    }
    if (vrsta == firma && id > RE_GetMaxID_Business())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Business());
        return DialogReopen(playerid);
    }
    if (vrsta == hotel && id > RE_GetMaxID_Hotel())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Hotel());
        return DialogReopen(playerid);
    }
    if (vrsta == garaza && id > RE_GetMaxID_Garage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Garage());
        return DialogReopen(playerid);
    }
    if (vrsta == vikendica && id > RE_GetMaxID_Cottage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Cottage());
        return DialogReopen(playerid);
    }

    SetPVarInt(playerid, "RE_EditProp_GID", re_globalid(vrsta, id));

    new dTitle[16];
    format(dTitle, sizeof dTitle, "%s: %i", propname(vrsta, PROPNAME_UPPER), id);
    SPD(playerid, "re_a_editprop_menu", DIALOG_STYLE_LIST, dTitle, "Informacije\nIzmena\nStavi na prodaju", "Dalje »", "« Nazad");
    return 1;
}

Dialog:re_a_editprop_menu(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return PC_EmulateCommand(playerid, "/editprop");

    new vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid = GetPVarInt(playerid, "RE_EditProp_GID"),
        lid = re_localid(vrsta, gid),
        boja[7], dTitle[16];

    format(dTitle, sizeof dTitle, "%s: %i", propname(vrsta, PROPNAME_UPPER), lid);

    if (listitem == 0) // Informacije
    {
        switch (vrsta)
        {
            case kuca:      boja = "48E31C";
            case stan:      boja = "48E31C";
            case firma:     boja = "33CCFF";
            case hotel:     boja = "8080FF";
            case garaza:    boja = "FF8282";
            case vikendica: boja = "6622FF";
            default:     return 1;
        }


        if (vrsta == kuca)
        {
            new vrsta_text[13];
            switch (RealEstate[gid][RE_VRSTA])
            {
                case 1:  vrsta_text = "Prikolica";
                case 2:  vrsta_text = "Mala kuca";
                case 3:  vrsta_text = "Srednja kuca";
                case 4:  vrsta_text = "Velika kuca";
                case 5:  vrsta_text = "Vila";
                default: vrsta_text = "Nepoznato";
            }

            new dStr[512];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Vrsta: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s\n{FFFFFF}Novac: {%s}%s\n{FFFFFF}Rent: {%s}%s\n{FFFFFF}Sef: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK], 
                boja, vrsta_text, 
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]), 
                boja, formatMoneyString(RealEstate[gid][RE_NOVAC]), 
                boja, (RealEstate[gid][RE_RENT]==0)? ("onemogucen") : (formatMoneyString(RealEstate[gid][RE_RENT])),
                boja, (RealEstate[gid][RE_SEF]==0)? ("nema") : ("ima"));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
        else if (vrsta == stan)
        {
            new dStr[256];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK],
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
        else if (vrsta == firma)
        {
            new dStr[512];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Vrsta: {%s}%s\n{FFFFFF}Naziv: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s\n{FFFFFF}Kasa: {%s}%s\n{FFFFFF}Reket: {%s}%s\n{FFFFFF}Reket racun: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK],
                boja, vrstafirme(RealEstate[gid][RE_VRSTA], PROPNAME_UPPER),
                boja, BizInfo[lid][BIZ_NAZIV],
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]),
                boja, formatMoneyString(RealEstate[gid][RE_NOVAC]),
                boja, reket_ime(gid),
                boja, formatMoneyString(BizInfo[lid][BIZ_NOVAC_REKET]));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
        else if (vrsta == hotel)
        {
            new dStr[512];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s\n{FFFFFF}Kasa: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK],
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]),
                boja, formatMoneyString(RealEstate[gid][RE_NOVAC]));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
        else if (vrsta == garaza)
        {
            new dStr[256];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK],
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
        else if (vrsta == vikendica)
        {
            new dStr[256];
            format(dStr, sizeof dStr, "{%s}%s [%i] - INFORMACIJE\n{FFFFFF}Vlasnik: {%s}%s\n{FFFFFF}Nivo: {%s}%i\n{FFFFFF}Cena: {%s}%s", 
                boja, propname(vrsta, PROPNAME_UPPER), lid, 
                boja, RealEstate[gid][RE_VLASNIK],
                boja, RealEstate[gid][RE_NIVO], 
                boja, formatMoneyString(RealEstate[gid][RE_CENA]));

            SPD(playerid, "re_a_editprop_info", DIALOG_STYLE_MSGBOX, dTitle, dStr, "Nazad", "");
        }
    }
    else if (listitem == 1) // Izmena
    {
        SPD(playerid, "re_a_editprop_edit1", DIALOG_STYLE_LIST, dTitle, "Vlasnik\nNaziv\nNivo\nCena\nNovac", "Dalje »", "« Nazad");
    }
    else if (listitem == 2) // Stavi na prodaju
    {
        RE_SetOnBuy(vrsta, gid);

        format(string_128, sizeof string_128, "%s - PRODAJA (ADMIN) | Izvrsio: %s | ID: %i", propname(vrsta, PROPNAME_UPPER), ime_obicno[playerid], RealEstate[gid][RE_ID]);
        Log_Write(LOG_IMOVINA, string_128);
    }
    return 1;
}

Dialog:re_a_editprop_info(playerid, response, listitem, const inputtext[])
{
    new params[5];
    valstr(params, re_localid(GetPVarInt(playerid, "RE_Listing"), GetPVarInt(playerid, "RE_EditProp_GID")));
    dialog_respond:re_a_editprop2(playerid, 1, 0, params);
    return 1;
}

Dialog:re_a_editprop_edit1(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:re_a_editprop_info(playerid, 1, 0, "");

    new vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid = GetPVarInt(playerid, "RE_EditProp_GID"),
        lid = re_localid(vrsta, gid), dTitle[16], boja[7];

    format(dTitle, sizeof dTitle, "%s: %i", propname(vrsta, PROPNAME_UPPER), lid);

    new value[25];
    switch (listitem)
    {
        case 0: // Vlasnik
        {
            format(value, sizeof value, "%s", RealEstate[gid][RE_VLASNIK]);
        }
        case 1: // Naziv
        {
            if (vrsta != firma && vrsta != hotel)
            {
                ErrorMsg(playerid, "Ne mozete izmeniti naziv za ovu vrstu nekretnine.");
                return DialogReopen(playerid);
            }
            format(value, sizeof value, "%s", RealEstate[gid][RE_VLASNIK]);
        }
        case 2: // Nivo
        {
            format(value, sizeof value, "%d", RealEstate[gid][RE_NIVO]);
        }
        case 3: // Cena
        {
            format(value, sizeof value, "%s", formatMoneyString(RealEstate[gid][RE_CENA]));
        }
        case 4: // Novac
        {
            if (vrsta == garaza || vrsta == stan || vrsta == vikendica)
            {
                ErrorMsg(playerid, "Ne mozete izmeniti novac u sefu/kasi za ovu vrstu nekretnine.");
                return DialogReopen(playerid);
            }
            format(value, sizeof value, "%s", formatMoneyString(RealEstate[gid][RE_NOVAC]));
        }
    }
    SetPVarInt(playerid, "pEditprop_Field", listitem);
    SetPVarString(playerid, "pEditprop_Value", value);

    switch (vrsta)
    {
        case kuca:      boja = "48E31C";
        case stan:      boja = "48E31C";
        case firma:     boja = "33CCFF";
        case hotel:     boja = "8080FF";
        case garaza:    boja = "FF8282";
        case vikendica: boja = "6622FF";
        default:     return 1;
    }

    new dStr[150];
    format(dStr, sizeof dStr, "{FFFFFF}%s: {%s}%s\n\n{FFFFFF}Unesite novu vrednost za ovo polje:", inputtext, boja, value);
    SPD(playerid, "re_a_editprop_edit2", DIALOG_STYLE_INPUT, dTitle, dStr, "Izmeni", "Nazad");
    return 1;
}

Dialog:re_a_editprop_edit2(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:re_a_editprop_info(playerid, 1, 0, "");

    new vrsta = GetPVarInt(playerid, "RE_Listing"),
        gid = GetPVarInt(playerid, "RE_EditProp_GID"),
        lid = re_localid(vrsta, gid), dTitle[16], bojaHex;

    format(dTitle, sizeof dTitle, "%s: %i", propname(vrsta, PROPNAME_UPPER), lid);

    switch (vrsta)
    {
        case kuca:      bojaHex = 0x48E31CFF;
        case stan:      bojaHex = 0x48E31CFF;
        case firma:     bojaHex = 0x33CCFFFF;
        case hotel:     bojaHex = 0x8080FFFF;
        case garaza:    bojaHex = 0xFF8282FF;
        case vikendica: bojaHex = 0x6622FFFF;
        default:     return 1;
    }

    switch (GetPVarInt(playerid, "pEditprop_Field"))
    {
        case 0: // Vlasnik
        {
            if (isnull(inputtext))
                return DialogReopen(playerid);

            if (strlen(inputtext) >= MAX_PLAYER_NAME)
                return DialogReopen(playerid);

            strmid(RealEstate[gid][RE_VLASNIK], inputtext, 0, strlen(inputtext), MAX_PLAYER_NAME);
            re_kreirajpickup(vrsta, gid);

            new sQuery[100], oldValue[32];

            GetPVarString(playerid, "pEditprop_Value", oldValue, sizeof oldValue);
            SendClientMessageF(playerid, bojaHex, "(%s) {FFFFFF}Izmenili ste vrednost sa [%s] na [%s].", propname(vrsta, PROPNAME_LOWER), oldValue, inputtext);

            mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE %s SET vlasnik = '%s' WHERE id = %i", propname(vrsta, PROPNAME_TABLE), inputtext, lid);
            mysql_tquery(SQL, sQuery);
        }
        case 1: // Naziv
        {
            if (isnull(inputtext))
                return DialogReopen(playerid);

            if (strlen(inputtext) >= 32)
                return DialogReopen(playerid);

            strmid(BizInfo[lid][BIZ_NAZIV], inputtext, 0, strlen(inputtext), 32);
            re_kreirajpickup(vrsta, gid);

            new sQuery[100], oldValue[32];

            GetPVarString(playerid, "pEditprop_Value", oldValue, sizeof oldValue);
            SendClientMessageF(playerid, bojaHex, "(%s) {FFFFFF}Izmenili ste vrednost sa [%s] na [%s].", propname(vrsta, PROPNAME_LOWER), oldValue, inputtext);

            mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE %s SET naziv = '%s' WHERE id = %i", propname(vrsta, PROPNAME_TABLE), inputtext, lid);
            mysql_tquery(SQL, sQuery);
        }
        case 2: // Nivo
        {
            new value, oldValue[16];
            if (sscanf(inputtext, "i", value))
                return DialogReopen(playerid);

            if (value < 1 || value > 99)
                return DialogReopen(playerid);

            RealEstate[gid][RE_NIVO] = value;
            re_kreirajpickup(vrsta, gid);

            GetPVarString(playerid, "pEditprop_Value", oldValue, sizeof oldValue);
            SendClientMessageF(playerid, bojaHex, "(%s) {FFFFFF}Izmenili ste vrednost sa [%s] na [%d].", propname(vrsta, PROPNAME_LOWER), oldValue, value);

            new sQuery[60];
            format(sQuery, sizeof sQuery, "UPDATE %s SET nivo = %i WHERE id = %i", propname(vrsta, PROPNAME_TABLE), value, lid);
            mysql_tquery(SQL, sQuery);
        }
        case 3: // Cena
        {
            new value, oldValue[16];
            if (sscanf(inputtext, "i", value))
                return DialogReopen(playerid);

            if (value < 1 || value > 99999999)
                return DialogReopen(playerid);

            RealEstate[gid][RE_CENA] = value;
            re_kreirajpickup(vrsta, gid);

            GetPVarString(playerid, "pEditprop_Value", oldValue, sizeof oldValue);
            SendClientMessageF(playerid, bojaHex, "(%s) {FFFFFF}Izmenili ste vrednost sa [%s] na [%s].", propname(vrsta, PROPNAME_LOWER), oldValue, formatMoneyString(value));

            new sQuery[60];
            format(sQuery, sizeof sQuery, "UPDATE %s SET cena = %i WHERE id = %i", propname(vrsta, PROPNAME_TABLE), value, lid);
            mysql_tquery(SQL, sQuery);
        }
        case 4: // Novac
        {
            new value, oldValue[16];
            if (sscanf(inputtext, "i", value))
                return DialogReopen(playerid);

            if (value < 1 || value > 99999999)
                return DialogReopen(playerid);

            RealEstate[gid][RE_NOVAC] = value;
            re_kreirajpickup(vrsta, gid);

            GetPVarString(playerid, "pEditprop_Value", oldValue, sizeof oldValue);
            SendClientMessageF(playerid, bojaHex, "(%s) {FFFFFF}Izmenili ste vrednost sa [%s] na [%s].", propname(vrsta, PROPNAME_LOWER), oldValue, formatMoneyString(value));

            new sQuery[60];
            format(sQuery, sizeof sQuery, "UPDATE %s SET novac = %i WHERE id = %i", propname(vrsta, PROPNAME_TABLE), value, lid);
            mysql_tquery(SQL, sQuery);
        }
    }
    dialog_respond:re_a_editprop_info(playerid, 1, 0, "");

    return 1;
}

Dialog:healPickup(playerid, response, listitem, const inputtext[]) // Bolnica heal
{
    new gid = GetPVarInt(playerid, "RE_HealPickup_GID");
    DeletePVar(playerid, "RE_HealPickup_GID");

    if (response)
    {
        if (PI[playerid][p_novac] < 1000 && !IsVIP(playerid, 2))
            return ErrorMsg(playerid, "Nemate dovoljno novca.");

        new lid = re_localid(firma, gid);
        if (lid < 1 || lid > RE_GetMaxID_Business())
            return ErrorMsg(playerid, GRESKA_NEPOZNATO);

        SetPlayerHealth(playerid, 99.0);
        SendClientMessage(playerid, SVETLOZELENA, "* Izleceni ste.");
        
        if (!IsVIP(playerid, 2))
            PlayerMoneySub(playerid, 1000);

        re_firma_dodaj_novac(gid, 1000);
    }
    return 1;
}

forward RE_UpdateActivityData(type);
public RE_UpdateActivityData(type)
{
    new sQuery[200];
    format(sQuery, sizeof sQuery, "SELECT UNIX_TIMESTAMP(igraci.poslednja_aktivnost) as lastOnline, %s.id FROM %s LEFT JOIN igraci ON igraci.ime = %s.vlasnik WHERE %s.vlasnik NOT LIKE 'Niko'", propname(type, PROPNAME_TABLE), propname(type, PROPNAME_TABLE), propname(type, PROPNAME_TABLE), propname(type, PROPNAME_TABLE));

    mysql_tquery(SQL, sQuery, "MySQL_RE_UpdateActivityData", "i", type);
    return 1;
}



// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:dodajkucu(FLAG_ADMIN_6);
CMD:dodajkucu(playerid, const params[])
{
    new vrsta;
    if (sscanf(params, "i", vrsta)) 
    {
        Koristite(playerid, "dodajkucu [Vrsta]");
        return SendClientMessage(playerid, GRAD2, "Dostupne vrste: 1 - prikolica; 2 - mala kuca; 3 - srednja kuca; 4 - velika kuca; 5 - vila");
    }

    if (vrsta < 1 || vrsta > 5)
        return ErrorMsg(playerid, "Nepoznat unos za polje \"vrsta\".");

    new query[128];
    format(query, sizeof query, "SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s' AND TABLE_NAME = 're_kuce'", MYSQL_DB_1);
    mysql_tquery(SQL, query, "mysql_addHouse", "iii", playerid, vrsta, cinc[playerid]);
    return 1;
}

flags:firmainteract(FLAG_ADMIN_6);
CMD:firmainteract(playerid, const params[]) 
{
    GetPlayerPos(playerid, pozicija[playerid][POS_X], pozicija[playerid][POS_Y], pozicija[playerid][POS_Z]);
    SetPVarFloat(playerid, "pInteractX", pozicija[playerid][POS_X]);
    SetPVarFloat(playerid, "pInteractY", pozicija[playerid][POS_Y]);
    SetPVarFloat(playerid, "pInteractZ", pozicija[playerid][POS_Z]);
    SendClientMessage(playerid, GRAD2, "Sacuvali ste interact poziciju. Koristite /dodajfirma da napravite firmu.");

    return 1;
}

flags:dodajfirmu(FLAG_ADMIN_6);
CMD:dodajfirmu(playerid, const params[])
{
    new vrsta, nivo, cena, naziv[32];
    if (sscanf(params, "iiis[32]", vrsta, nivo, cena, naziv)) 
    {
        Koristite(playerid, "dodajfirmu [Vrsta] [Nivo] [Cena] [Naziv]");
        SendClientMessage(playerid, GRAD2, "[1]Prodavnica  [2]Oruzarnica  [3]Technology  [4]Hardware  [5]Restoran  [6]Kafic  [7]Bar  [8]Diskoteka  [9]Butik  [10]Sex Shop");
        SendClientMessage(playerid, GRAD2, "[11]Burger Shot  [12]Pizza Stack  [13]Cluckin' Bell  [14]Randy's Donuts  [15]Teretana  [16]Frizerski salon  [17]Posta  [18]Rent-a-car");
        SendClientMessage(playerid, GRAD2, "[19]Kiosk  [20]Benzinska pumpa  [21]Posao  [22]Mehanicarska garaza  [23]Tuning garaza  [24] Drugo  [25] Apoteka ");
        SendClientMessage(playerid, GRAD2, "[26] Bolnica  [27] Accessory Shop");
        SendClientMessage(playerid, SVETLOZUTA, "Pre dodavanja kioska i benzinske pumpe koristite /firmainteract da sacuvate interact poziciju.");
        SendClientMessage(playerid, SVETLOCRVENA, "Trenutno je moguce dodati: 19, 18, 21, 22, 23");
        return 1;
    }

    if (vrsta < 1 || vrsta > 27)
        return ErrorMsg(playerid, "Nepoznat unos za polje \"vrsta\".");

    new query[145];
    format(query, sizeof query, "SELECT AUTO_INCREMENT FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s' AND TABLE_NAME = 're_firme'", MYSQL_DB_1);
    mysql_tquery(SQL, query, "mysql_addBusiness", "iiiisi", playerid, vrsta, nivo, cena, naziv, cinc[playerid]);
    return 1;
}

flags:dodajstan(FLAG_ADMIN_6);
CMD:dodajstan(playerid, const params[])
{
    new query[145];
    format(query, sizeof query, "SELECT AUTO_INCREMENT FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s' AND TABLE_NAME = 're_stanovi'", MYSQL_DB_1);
    mysql_tquery(SQL, query, "mysql_addApartment", "ii", playerid, cinc[playerid]);
    return 1;
}

flags:dodajgarazu(FLAG_ADMIN_6);
CMD:dodajgarazu(playerid, const params[])
{
    new query[145];
    format(query, sizeof query, "SELECT AUTO_INCREMENT FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s' AND TABLE_NAME = 're_garaze'", MYSQL_DB_1);
    mysql_tquery(SQL, query, "mysql_addGarage", "ii", playerid, cinc[playerid]);
    return 1;
}

flags:dodajvikendicu(FLAG_ADMIN_6);
CMD:dodajvikendicu(playerid, const params[])
{
    new query[145];
    format(query, sizeof query, "SELECT AUTO_INCREMENT FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '%s' AND TABLE_NAME = 're_vikendice'", MYSQL_DB_1);
    mysql_tquery(SQL, query, "mysql_addCottage", "ii", playerid, cinc[playerid]);
    return 1;
}

CMD:kupi(playerid, const params[])
{
	if (gPropertyPickupGID[playerid] != -1) // Mozda se nalazi na nekom pickupu
	{
		new
			gid   = gPropertyPickupGID[playerid],
			vrsta = re_odredivrstu(gid),
			lid   = re_localid(vrsta, gid)
		;
		if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2])) 
		{
            // Kupovina nekretnine

			if (strcmp(RealEstate[gid][RE_VLASNIK], "Niko")) return ErrorMsg(playerid, "Ne mozete kupiti ovu nekretninu jer ona nije na prodaju.");
		    if (PI[playerid][p_nivo]  < RealEstate[gid][RE_NIVO])
			{
			    format(string_128, sizeof string_128, "Morate biti najmanje nivo %d da biste kupili %s %s.", RealEstate[gid][RE_NIVO], ((vrsta==stan||vrsta==hotel)?("ovaj"):("ovu")), propname(vrsta, PROPNAME_AKUZATIV));
				ErrorMsg(playerid, string_128);
				return 1;
			}

            if (RealEstate_GetPlayerFreeSlots(playerid, vrsta) == 0)
                return ErrorMsg(playerid, "Nemas slobodnih slotova za %s.", propname(vrsta, PROPNAME_AKUZATIV));

			if (PI[playerid][p_novac] < RealEstate[gid][RE_CENA])
				return ErrorMsg(playerid, "Nemate dovoljno novca za kupovinu ove nekretnine.");

		    switch (vrsta)
		    {
		        case kuca:
		        {
                    if (PI[playerid][p_rent_kuca] != 0 || PI[playerid][p_rent_cena] != 0)
                        return ErrorMsg(playerid, "Vec iznajmljujete sobu u nekoj kuci. Koristite /odjavisobu da je odjavite.");

					// Slanje poruke igracu
					SendClientMessage(playerid, SVETLOZELENA, "(kuca) {FFFFFF}Uspesno ste kupili ovu kucu. Za upravljanje koristite {48E31C}/imovina -> Nekretnine -> Kuca.");
		        }
		        case stan:
		        {
					// Slanje poruke igracu
					SendClientMessage(playerid, ZELENA2, "(stan) {FFFFFF}Uspesno ste kupili ovaj stan. Za upravljanje koristite {48E31C}/imovina -> Nekretnine -> Stan.");
		        }
		        case firma:
		        {
					// Slanje poruke igracu
					SendClientMessage(playerid, SVETLOPLAVA, "(firma) {FFFFFF}Uspesno ste kupili ovu firmu. Za upravljanje koristite {33CCFF}/imovina -> Nekretnine -> Firma.");
		        }
		        case hotel:
		        {
					// Slanje poruke igracu
					SendClientMessage(playerid, LJUBICASTA, "(hotel) {FFFFFF}Uspesno ste kupili ovaj hotel. Za upravljanje koristite {8080FF}/imovina -> Nekretnine -> Hotel.");
		        }
		        case garaza:
		        {
					// Slanje poruke igracu
					SendClientMessage(playerid, NARANDZASTA, "(garaza) {FFFFFF}Uspesno ste kupili ovu garazu. Za upravljanje koristite {FF9900}/imovina -> Nekretnine -> Garaza.");
		        }
                case vikendica:
                {
                    // Slanje poruke iFgracu
                    SendClientMessage(playerid, 0x6622FFFF, "(vikendica) {FFFFFF}Uspesno ste kupili ovu vikendicu. Za upravljanje koristite {FF9900}/imovina -> Nekretnine -> Vikendica.");
                }
		        default: return SendClientMessage(playerid, TAMNOCRVENA2, "[real_estate.pwn] "GRESKA_NEPOZNATO" (46)");
		    }

			// Upisivanje ID-a u igracevu varijablu
            for__loop (new i = 0; i < PI[playerid][p_nekretnine_slotovi]; i++)
            {
                if (pRealEstate[playerid][vrsta][i] == -1)
                {
                    pRealEstate[playerid][vrsta][i] = lid;
                    break;
                }
            }

		    // Upisivanje novog vlasnika u varijablu
	     	strmid(RealEstate[gid][RE_VLASNIK], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);


			// Oduzimanje novca/GOLD-a
		    PlayerMoneySub(playerid, RealEstate[gid][RE_CENA]);

			// Ubacivanje igraca unutra (pod uslovom da nije firma bez enterijera)
            if (vrsta != firma && RealEstate[gid][RE_ULAZ][0] != RealEstate[gid][RE_IZLAZ][0] && RealEstate[gid][RE_ULAZ][1] != RealEstate[gid][RE_IZLAZ][1]) 
            {
    	       	SetPlayerInterior(playerid, RealEstate[gid][RE_ENT]);
    	       	SetPlayerVirtualWorld(playerid, gid);
    	        SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2], RealEstate[gid][RE_IZLAZ][3]);
            }

			// Update pickupa
			re_kreirajpickup(vrsta, gid);

			// Upisivanje u log
			format(string_128, sizeof string_128, "%s - KUPOVINA (buy) | Izvrsio: %s | Cena: $%d | ID: %d", propname(vrsta, PROPNAME_UPPER), ime_obicno[playerid], RealEstate[gid][RE_CENA],
				lid);
			Log_Write(LOG_IMOVINA, string_128);

			// Cuvanje igracevih podataka
            new sQuery[256];
			format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_id]);
	        mysql_tquery(SQL, sQuery);


			// Cuvanje podataka za nekretninu
			format(mysql_upit, 80, "UPDATE %s SET vlasnik = '%s' WHERE id = %d", propname(vrsta, PROPNAME_TABLE), ime_obicno[playerid], lid);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);

            // Ako je firma, treba je otkljucati
            if (vrsta == firma) 
            {
                RealEstate[gid][RE_ZATVORENO] = 0;
                format(mysql_upit, sizeof mysql_upit, "UPDATE %s SET zatvoreno = 0 WHERE id = %d", propname(vrsta, PROPNAME_TABLE), ime_obicno[playerid], lid);
                mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
            }

		    return 1;
		}

        new vw = gid;
        if (RealEstate[gid][RE_VRSTA] == FIRMA_KIOSK) vw = 0;
		if (vrsta == firma && IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]) && GetPlayerVirtualWorld(playerid) == vw && GetPlayerInterior(playerid) == RealEstate[gid][RE_ENT])
		{ 
		    // Kupuje u nekoj firmi

            new cmdParams[17];
            format(cmdParams, sizeof cmdParams, "/firmakupi %i", gid);
            PC_EmulateCommand(playerid, cmdParams);

		    return 1;
		}
	}

	if (IsPlayerInArea(playerid, 1530.92, -1100.53, 1820.35, -995.27) || IsPlayerInArea(playerid, 1591.7, -1143.8, 1684.72, -1090.67)) // ako se nesto menja - promeniti i u komandi /autopijaca
    {
		// Igrac je na auto pijaci
		new cmdParams[20];
        format(cmdParams, sizeof cmdParams, "/autopijaca %s", params);
        PC_EmulateCommand(playerid, cmdParams);
		
		return 1;
	}
    new land = GetPlayerLandID(playerid);
    if (land != -1 && IsPlayerOnLandPickup(playerid, land))
    {
        if (!Land_HasOwner(land))
        {
            Land_ProcessPurchase(playerid, land);
        }
        else
        {
            return ErrorMsg(playerid, "Ovo imanje vec ima svog vlasnika.");
        }
        return 1;
    }

    // Dodati jos koda za kupovinu drugih stvari i uvek staviti return 1 na kraju

	ErrorMsg(playerid, "Ne mozete kupiti nista na mestu gde se trenutno nalazite.");
	return 1;
}

CMD:odjavihotel(playerid, const params[])
{
	if (PI[playerid][p_hotel_soba] == -1)
		return ErrorMsg(playerid, "Nemate iznajmljenu sobu ni u jednom hotelu.");
		
	new 
		lid = PI[playerid][p_hotel_soba],
		gid = re_globalid(hotel, lid)
	;
		
	// Update igracevih varijabli
	PI[playerid][p_hotel_soba] = -1;
	PI[playerid][p_hotel_cena] = 1000;
	
	// Update varijabli hotela
	for__loop (new i = 0; i < RealEstate[gid][RE_SLOTOVI]; i++)
	{
		if (RE_HOTELS[lid][i][rh_player_id] == PI[playerid][p_id])
		{
			RE_HOTELS[lid][i][rh_player_id] = INVALID_PLAYER_ID;
		}
	}
	
	// Slanje poruke igracu
	SendClientMessage(playerid, SVETLOPLAVA, "* Odjavili ste svoju hotelsku sobu.");
	
	// Promena spawna
	dialog_respond:spawn(playerid, 1, 0, "");
	
	// Update igracevih podataka u bazi
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_soba = -1, hotel_cena = 1000 WHERE id = %d", PI[playerid][p_id]);
	mysql_tquery(SQL, mysql_upit);
	
	return 1;
}


CMD:kuca(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 0, "Kuca");

CMD:stan(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 1, "Stan");

CMD:firma(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 2, "Firma");

CMD:hotel(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 3, "Hotel");

CMD:garaza(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 4, "Garaza");

CMD:vikendica(playerid, const params[]) 
    return dialog_respond:nekretnine(playerid, 1, 5, "Vikendica");

CMD:nekretnine(playerid, const params[]) 
    return dialog_respond:imovina(playerid, 1, 1, "Nekretnine");

CMD:ds(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
        
    if (isnull(params)) 
        return Koristite(playerid, "ds [Tekst]");


    if (gPropertyPickupGID[playerid] != -1) // Mozda se nalazi na pickupu neke nekretnine
    {
        new gid = gPropertyPickupGID[playerid];

        if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2])
        || IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2])) // Nalazi se ispred ili unutra
        {
            new chat_string[145];
            zastiti_chat(playerid, params);
            
            if (!strcmp(PI[playerid][p_naglasak], "Nista")) 
                format(chat_string, sizeof chat_string, "%s vice (kroz vrata): %s!!!", ime_rp[playerid], params);
            else 
                format(chat_string, sizeof chat_string, "%s vice (kroz vrata): [%s] %s!!!", ime_rp[playerid], PI[playerid][p_naglasak], params);
                
                
            foreach(new i : Player)
            {
                if (
                        (IsPlayerInRangeOfPoint(i, 20.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2])
                        && GetPlayerInterior(i) == 0  && GetPlayerVirtualWorld(i) == 0)
                        || 
                        (IsPlayerInRangeOfPoint(i, 20.0, RealEstate[gid][RE_IZLAZ][0], RealEstate[gid][RE_IZLAZ][1], RealEstate[gid][RE_IZLAZ][2]) 
                        && GetPlayerInterior(i) == RealEstate[gid][RE_ENT]  && GetPlayerVirtualWorld(i) == gid)
                    ) 
                    SendClientMessage(i, BELA, chat_string);
            }
        }
        else
        {
            gPropertyPickupGID[playerid] = -1;
        }
    }
    if (gPropertyPickupGID[playerid] == -1) return ErrorMsg(playerid, "Nalazite se previse daleko od vrata.");

    koristio_chat[playerid] = gettime() + 3;
    return 1;
}

CMD:firmakupi(playerid, const params[]) 
{
    new gid = strval(params);
    new lid = re_localid(firma, gid);

    // new vw = gid;
    // if (RealEstate[gid][RE_VRSTA] == FIRMA_KIOSK) vw = 0;

    if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]) || (IsPlayerInRangeOfPoint(playerid, 10.0, 1206.8125,-894.4656,43.1322) && re_localid(firma, gid) == 117))
    { // Kupuje u nekoj firmi
        firma_kupuje[playerid] = -1;

        // if (!strcmp(RealEstate[gid][RE_VLASNIK], "Niko", false, 4)) // Firma nema vlasnika
        // {
        //     ErrorMsg(playerid, "Ova firma nema vlasnika, ne mozete kupovati u njoj.");

        //     SetPlayerInterior(playerid, 0);
        //     SetPlayerVirtualWorld(playerid, 0);
        //     SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);

        //     return 1;
        // }
        // else if (RealEstate[gid][RE_ZATVORENO] == 1)
        // {
        //     ErrorMsg(playerid, "Ova firma je zatvorena, ne mozete kupovati u njoj.");

        //     SetPlayerInterior(playerid, 0);
        //     SetPlayerVirtualWorld(playerid, 0);
        //     SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], RealEstate[gid][RE_ULAZ][3]);

        //     return 1;
        // }


        switch (RealEstate[gid][RE_VRSTA]) 
        {
            case FIRMA_PRODAVNICA, FIRMA_TECHNOLOGY, FIRMA_KIOSK, FIRMA_RESTORAN, FIRMA_ORUZARNICA, FIRMA_SEXSHOP, FIRMA_HARDWARE, FIRMA_APOTEKA, FIRMA_BURGERSHOT, FIRMA_CLUCKINBELL, FIRMA_PIZZASTACK, FIRMA_RANDYSDONUTS, FIRMA_TERETANA, FIRMA_SECURITYSHOP, FIRMA_PIJACA: 
            {
                if (RealEstate[gid][RE_VRSTA] == FIRMA_ORUZARNICA)
                {
                    if (PI[playerid][p_dozvola_oruzje] != 1)
                        return ErrorMsg(playerid, "Morate posedovati dozvolu za oruzje.");


                    if (PI[playerid][p_provedeno_vreme] < 20 && GetPlayerFactionID(playerid) == -1)
                        return ErrorMsg(playerid, "Morate imati najmanje 20 sati igre da biste kupovali oruzje.");
                }

                // Formatiranje dialoga
                new
                    vrsta_f = RealEstate[gid][RE_VRSTA],
                    boja[7],
                    string[1024]
                ;
                string[0] = EOS;
                for__loop (new i = 0; i < sizeof(proizvodi[]) && proizvodi[vrsta_f][i] > 0; i++)
                {
                    if (F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_stock] > 0)
                         boja = "41C72E";
                    else 
                        boja = "C82E40";

                    if (RealEstate[gid][RE_VRSTA] == FIRMA_APOTEKA)
                    {
                        format(string, sizeof(string), "%s{%s}(%s/10g)\t{FFFFFF}%s\n", string, boja, formatMoneyString(F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_cena]), PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv]);
                    }
                    else
                    {
                        format(string, sizeof(string), "%s{%s}(%s)\t{FFFFFF}%s\n", string, boja, formatMoneyString(F_PRODUCTS[RealEstate[gid][RE_ID]][proizvodi[vrsta_f][i]][f_cena]), PRODUCTS[proizvodi[vrsta_f][i]][pr_naziv]);
                    }
                }


                // Prikazivanje dialoga
                new
                    naslov[40];
                format(naslov, sizeof(naslov), "{0068B3}%s", BizInfo[lid][BIZ_NAZIV]);
                SPD(playerid, "re_firma_kupovina", DIALOG_STYLE_TABLIST, naslov, string, "Kupi", "Nazad");
            }

            case FIRMA_BUTIK: 
            {
                ptdButik_Create(playerid);
                ptdButik_Setup(playerid);
                SetPVarInt(playerid,   "pShoppingVW",  gid);
                SetPVarInt(playerid,   "pShoppingInt", RealEstate[gid][RE_ENT]);
                SetPVarFloat(playerid, "pShoppingX",   RealEstate[gid][RE_IZLAZ][0]);
                SetPVarFloat(playerid, "pShoppingY",   RealEstate[gid][RE_IZLAZ][1]);
                SetPVarFloat(playerid, "pShoppingZ",   RealEstate[gid][RE_IZLAZ][2]);

                SetPlayerInterior(playerid, 14);
                SetPlayerVirtualWorld(playerid, playerid);
                SetPlayerCompensatedPos(playerid, 258.4893, -41.4008, 1002.0234);
                SetPlayerFacingAngle(playerid, 270.0);
                SetPlayerCameraPos(playerid, 256.0815, -43.0475, 1004.0234);
                SetPlayerCameraLookAt(playerid, 258.4893, -41.4008, 1002.0234);

                ptdButik_Show(playerid);
            }

            case FIRMA_ACCESSORY:
            {
                if (GetPlayerFreeAttachSlot(playerid) == -1)
                    return ErrorMsg(playerid, "Vec imate previse stvari na sebi. Morate skinuti nesto.");

                SetPVarFloat(playerid,  "pShoppingX",    RealEstate[gid][RE_IZLAZ][0]);
                SetPVarFloat(playerid,  "pShoppingY",    RealEstate[gid][RE_IZLAZ][1]);
                SetPVarFloat(playerid,  "pShoppingZ",    RealEstate[gid][RE_IZLAZ][2]);
                SPD(playerid, "accessoryShop", DIALOG_STYLE_LIST, "Accessory Shop", "Kape\nBandane\nNaocare", "Dalje", "Izadji");
            }
        }



        firma_kupuje[playerid] = gid;
        return 1;
    }
    return 1;
}

CMD:kiosk(playerid, const params[])
{
    new bool:error = true;
    for__loop (new i = 1; i < RE_GetMaxID_Business(); i++)
    {
        new gid = re_globalid(firma, i);
        if (RealEstate[gid][RE_VRSTA] != FIRMA_KIOSK) continue;

        if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]))
        {
            // Nalazi se ispred nekog kioska
            new cmdParams[17];
            format(cmdParams, sizeof cmdParams, "/firmakupi %i", gid);
            PC_EmulateCommand(playerid, cmdParams);

            error = false;
            break;
        }
    }

    if (error)
        return ErrorMsg(playerid, "Ne nalazite se u blizini kioska.");

    return 1;
}

CMD:iznajmisobu(playerid, const params[])
{
    new 
        gid = gPropertyPickupGID[playerid],
        vrsta = re_odredivrstu(gid);

    if (vrsta != kuca)
        return ErrorMsg(playerid, "Ne mozes iznajmiti sobu na ovom mestu.");

    if (!IsPlayerInRangeOfPoint(playerid, 4.0, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]))
        return ErrorMsg(playerid, "Ne mozes iznajmiti sobu na ovom mestu.");

    if (RealEstate[gid][RE_RENT] == 0)
        return ErrorMsg(playerid, "Vlasnik ove kuce ne dozvoljava najam soba.");

    if (!strcmp(RealEstate[gid][RE_VLASNIK], ime_obicno[playerid]))
        return ErrorMsg(playerid, "Ne mozes iznajmiti sobu u sopstvenoj kuci.");

    if (PI[playerid][p_rent_kuca] != 0 || PI[playerid][p_rent_cena] != 0)
        return ErrorMsg(playerid, "Vec iznajmljujes sobu u nekoj kuci. Koristi /odjavisobu da je odjavis.");

    new query[54];
    format(query, sizeof query, "SELECT COUNT(*) FROM re_kuce_stanari WHERE k_id = %i", re_localid(kuca, gid));
    mysql_tquery(SQL, query, "MYSQL_CountHouseTenants", "iii", playerid, gid, cinc[playerid]);
    return 1;
}

CMD:odjavisobu(playerid, const params[])
{
    if (PI[playerid][p_rent_kuca] == 0 && PI[playerid][p_rent_cena] == 0)
        return ErrorMsg(playerid, "Nemas iznajmljenu sobu ni u jednoj kuci.");

    SendClientMessage(playerid, SVETLOPLAVA, "* Odjavio so sobu koju si iznajmljivao.");

    // Promena spawna
    if (re_globalid(kuca, PI[playerid][p_rent_kuca]) == PI[playerid][p_spawn_vw])
    {
        dialog_respond:spawn(playerid, 1, 0, "");
    }

    PI[playerid][p_rent_kuca] = 0;
    PI[playerid][p_rent_cena] = 0;

    new query[65];
    format(query, sizeof query, "UPDATE igraci SET rent_kuca = 0, rent_cena = 0 WHERE id = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

CMD:izlecime(playerid, const params[])
{
    if (GetPlayerInterior(playerid) != 1) // sigurno nije u bolnici!
        return ErrorMsg(playerid, "Ne nalazis se na mestu za lecenje.");

    new bool:error = true;
    for__loop (new i = 1; i < RE_GetMaxID_Business(); i++)
    {
        new gid = re_globalid(firma, i);
        if (RealEstate[gid][RE_VRSTA] != FIRMA_BOLNICA) continue;

        if (IsPlayerInRangeOfPoint(playerid, 5.0, RealEstate[gid][RE_INTERACT][0], RealEstate[gid][RE_INTERACT][1], RealEstate[gid][RE_INTERACT][2]) && GetPlayerVirtualWorld(playerid) == gid)
        {
            // Nalazi se na pickupu neke bolnica
            SetPVarInt(playerid, "RE_HealPickup_GID", gid);

            SPD(playerid, "healPickup", DIALOG_STYLE_MSGBOX, "Lecenje", "{FFFFFF}Lecenje u bolnici (100hp) kosta {00FF00}$1.000.\n{FFFFFF}Lecenje u bolnici (100hp) je besplatno za VIP Silver igrace.", "Izleci se", "Odustani");

            error = false;
            break;
        }
    }

    if (error)
        return ErrorMsg(playerid, "Ne nalazis se u bolnici.");

    return 1;
}


// CMD:proizvodi(playerid, const params[])
// {
//     // Komanda koja ubacuje proizvode u tabelu "re_firme_proizvodi" za svaku firmu (tabela treba da bude prazna) 
//     if (!IsAdmin(playerid, 6))
//         return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

//     new MIN_ID, MAX_ID;
//     if (sscanf(params, "ii", MIN_ID, MAX_ID))
//         return Koristite(playerid, "proizvodi [Min ID] [Max ID]");

//     for__loop (new lid = MIN_ID; lid <= MAX_ID; lid++)
//     {
//         new gid = re_globalid(firma, lid);
//         switch (RealEstate[gid][RE_VRSTA])
//         {
//             case FIRMA_BENZINSKA:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES (%d, 48)", lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_KIOSK: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 1), (%d, 2), (%d, 8), (%d, 9), (%d, 32), (%d, 36), (%d, 49)", lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_PRODAVNICA: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 3), (%d, 4), (%d, 5), (%d, 6), (%d, 7), (%d, 8), (%d, 9), (%d, 10), (%d, 11), (%d, 115)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_ORUZARNICA: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 12), (%d, 13), (%d, 42), (%d, 14), (%d, 15), (%d, 16), (%d, 17), (%d, 43), (%d, 44), (%d, 18), (%d, 19), (%d, 20)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_CLUCKINBELL: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 84), (%d, 85), (%d, 86), (%d, 87), (%d, 88), (%d, 89), (%d, 90), (%d, 91), (%d, 92), (%d, 73), (%d, 93), (%d, 94)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_PIZZASTACK: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 76), (%d, 77), (%d, 78), (%d, 79), (%d, 80), (%d, 81), (%d, 82), (%d, 83)", lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_RESTORAN: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 50), (%d, 51), (%d, 52), (%d, 53), (%d, 54), (%d, 55), (%d, 56), (%d, 57), (%d, 58), (%d, 59), (%d, 60), (%d, 61)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_SEXSHOP: 
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 6), (%d, 38), (%d, 39), (%d, 40), (%d, 41)", lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_APOTEKA:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 113), (%d, 109), (%d, 112), (%d, 110), (%d, 111), (%d, 108), (%d, 114), (%d, 116), (%d, 117)", lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             } 
//             case FIRMA_RANDYSDONUTS:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 91), (%d, 95), (%d, 96), (%d, 97), (%d, 98), (%d, 99), (%d, 100), (%d, 101), (%d, 102), (%d, 103), (%d, 104), (%d, 105), (%d, 94)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             } 
//             case FIRMA_BURGERSHOT:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 62), (%d, 63), (%d, 64), (%d, 65), (%d, 66), (%d, 67), (%d, 68), (%d, 69), (%d, 70), (%d, 71), (%d, 72), (%d, 73), (%d, 74), (%d, 75)", lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_HARDWARE:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 32), (%d, 33), (%d, 34), (%d, 35), (%d, 36), (%d, 37), (%d, 20), (%d, 107)", lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//             case FIRMA_TECHNOLOGY:
//             {
//                 format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_firme_proizvodi (fid, pid) VALUES \
//                     (%d, 21), (%d, 22), (%d, 23), (%d, 24), (%d, 25), (%d, 30), (%d, 31), (%d, 118)", lid, lid, lid, lid, lid, lid, lid, lid);
//                 mysql_tquery(SQL, mysql_upit);
//             }
//         }
//     }
//     return 1;
// }

CMD:updateact(playerid, params[])
{
    if(IsAdmin(playerid,6))
    {
        RE_UpdateActivityData(kuca);
        RE_UpdateActivityData(firma);
        RE_UpdateActivityData(stan);
        RE_UpdateActivityData(garaza);
        RE_UpdateActivityData(hotel);
        RE_UpdateActivityData(vikendica);
    }
    return 1;
}

CMD:propdebug(playerid, const params[])
{
    for (new i = 0; i < PI[playerid][p_nekretnine_slotovi][kuca]; i++)
    {
        SendClientMessageF(playerid, -1, "slot %i : %i", i, pRealEstate[playerid][kuca][i]);
    }
    return 1;
}