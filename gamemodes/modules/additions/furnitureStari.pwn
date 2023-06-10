#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
// Ne menjati brojeve
#define ITEMS_TABLES		0
#define ITEMS_CHAIRS		1
#define ITEMS_BEDS			2
#define ITEMS_SOFAS			3
#define ITEMS_DECORATIONS 	4
#define ITEMS_APPLIANCES	5
#define ITEMS_BATHROOM		6
#define ITEMS_KITCHEN		7
#define ITEMS_SHELVES		8
#define ITEMS_FOOD_DRINKS	9
#define ITEMS_MISC			10
#define ITEMS_SAMP			11

#define FURNITURE_NUM_CAT   12 // Broj kategorija (za 1 veci od poslednjeg ITEMS_*)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum e_furniture_categories
{
	ft_cat_id,
	ft_cat_name[14],
}
enum e_furniture
{
	ft_id,
	ft_name[MAX_FITEM_NAME],
	ft_price,
};





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	ft_category[MAX_PLAYERS],
	ft_item[MAX_PLAYERS],
	ft_item_name[MAX_PLAYERS][MAX_FITEM_NAME],
	ft_item_price[MAX_PLAYERS], // cena se belezi u bazu da bi, zbog eventualne izmene cena objekata, igrac dobio nazad istu kolicinu novca ukoliko proda objekat
	
	/*ft_edit_next[MAX_PLAYERS], // Sledeci slot, onaj od koga treba poceti prikazivanje ako igrac ode na sledecu stranicu
	ft_edit_prev[MAX_PLAYERS], // Prethodni slot, onaj do koga treba prikazati objekte ako igrac ode na prethodnu stranicu
	ft_edit_first[MAX_PLAYERS], // Prvi slot na stranici, onaj od koga se krece, pa ide do "ft_edit_prev", ako igrac ode na tu istu (prethodnu) stranicu*/
	
	ft_edit[MAX_PLAYERS], // Slot koji je igrac izabrao da izmenjuje
	ft_edit_page[MAX_PLAYERS], // Stranica na kojoj se igrac nalazi
	ft_list[MAX_PLAYERS][5][11], // Formira se kada igrac prvi put odabere pregled objekata; u sustini redja sve postojece objekte za prikaz po stranicama
	
	bool:ft_just_bought[MAX_PLAYERS char], // Ako je "true", onda kod izmene objekta moze da koristi ESC da odustane od kupovine i da dobije novac nazad

    furnitureList[FURNITURE_NUM_CAT] = {mS_INVALID_LISTID, ...}
;


new f_categories[FURNITURE_NUM_CAT][e_furniture_categories] =
{
	{ITEMS_TABLES, 		"Stolovi"},
	{ITEMS_CHAIRS, 		"Stolice"},
	{ITEMS_BEDS, 		"Kreveti"},
	{ITEMS_SOFAS, 		"Kaucevi"},
	{ITEMS_DECORATIONS, "Ukrasi"},
	{ITEMS_APPLIANCES, 	"Uredjaji"},
	{ITEMS_BATHROOM,	"Kupatilo"},
	{ITEMS_KITCHEN,		"Kuhinja"},
	{ITEMS_SHELVES,		"Police"},
	{ITEMS_FOOD_DRINKS,	"Hrana i pice"},
	{ITEMS_MISC,		"Razno"},
	{ITEMS_SAMP, 		"SA-MP objekti"}
};

new f_tables[22][e_furniture] =
{
	{1281, "Sto sa suncobranom",  		5000},
	{1432, "Sto + 3 stolice (1)", 		5000},
	{1825, "Sto + 3 stolice (2)", 		5000},
	{1433, "Sto za dnevnu sobu (1)", 	5000},
	{1516, "Sto za dnevnu sobu (2)", 	5000},
	{643,  "Plavi sto + 4 stolice (1)", 5000},
	{1594, "Plavi sto + 4 stolice (2)", 5000},
	{1827, "Stakleni stocic (1)", 		5000},
	{2209, "Stakleni stocic (2)", 		5000},
	{1963, "Radni sto", 				5000},
	{1999, "Radni sto + racunar (1)", 	5000},
	{2008, "Radni sto + racunar (2)", 	5000},
	{2207, "Polukruzni pult",			5000},
	{2311, "Drveni stocic (1)", 		5000},
	{2314, "Drveni stocic (2)", 		5000},
	{2315, "Drveni stocic (3)", 		5000},
	{2635, "Pizza sto (mali)", 			5000},
	{2637, "Pizza sto (veliki)",		5000},
	{2763, "Crveni sto (mali)", 		5000},
	{2762, "Crveni sto (veliki)", 		5000},
	{2764, "Karirani sto", 				5000},
	{2799, "Sto + kozne stolice", 		5000}
};

new f_chairs[19][e_furniture] =
{
	{1369, "Invalidska kolica", 		5000},
	{1805, "Hoklica", 					5000},
	{1280, "Klupa (1)", 				5000},
	{1368, "Klupa (2)", 				5000},
	{1671, "Kancelarijska stolica (1)", 5000},
	{1714, "Kancelarijska stolica (2)", 5000},
	{1806, "Kancelarijska stolica (3)", 5000},
	{1711, "Fotelja (1)", 				5000},
	{1735, "Fotelja (2)", 				5000},
	{1708, "Fotelja (3)", 				5000},
	{1724, "Fotelja (4)", 				5000},
	{1727, "Fotelja (5)", 				5000},
	{1754, "Fotelja (6)", 				5000},
	{1767, "Fotelja (7)", 				5000},
	{1769, "Fotelja (8)", 				5000},
	{1721, "Stolica (1)", 				5000},
	{1739, "Stolica (2)", 				5000},
	{1811, "Stolica (3)", 				5000},
	{2079, "Stolica (4)", 				5000}
};

new f_beds[16][e_furniture] =
{
	{1700,  "Krevet za spavanje (1)",  5000},
	{1701,  "Krevet za spavanje (2)",  5000},
	{1745,  "Krevet za spavanje (3)",  5000},
	{1793,  "Krevet za spavanje (4)",  5000},
	{1794,  "Krevet za spavanje (5)",  5000},
	{1795,  "Krevet za spavanje (6)",  5000},
	{1796,  "Krevet za spavanje (7)",  5000},
	{1797,  "Krevet za spavanje (8)",  5000},
	{1799,  "Krevet za spavanje (9)",  5000},
	{2298,  "Krevet za spavanje (10)", 5000},
	{2301,  "Krevet za spavanje (11)", 5000},
	{2302,  "Krevet za spavanje (12)", 5000},
	{1800,  "Krevet sa dusekom (1)",   5000},
	{1801,  "Krevet sa dusekom (2)",   5000},
	{14446, "Luksuzni krevet",         5000},
	{14880, "Stari krevet",            5000}
};

new f_sofas[13][e_furniture] =
{
	{1728, "Dvosed (1)", 			5000},
	{1712, "Dvosed (2)", 			5000},
	{1753, "Trosed (1)", 			5000},
	{1710, "Trosed (2)", 			5000},
	{1723, "Elegantni dvosed (1)", 	5000},
	{1726, "Elegantni dvosed (2)", 	5000},
	{1764, "Kauc (1)", 				5000},
	{1766, "Kauc (2)", 				5000},
	{1763, "Kauc (3)", 				5000},
	{1761, "Kauc (4)", 				5000},
	{1760, "Kauc (5)", 				5000},
	{1757, "Kauc (6)", 				5000},
	{1756, "Kauc (7)", 				5000}
};

new f_decorations[24][e_furniture] =
{
	{3963, "Slika (1)", 	5000},
	{2286, "Slika (2)", 	5000},
	{2281, "Slika (3)", 	5000},
	{2277, "Slika (4)", 	5000},
	{2275, "Slika (5)", 	5000},
	{2270, "Slika (6)", 	5000},
	{2266, "Slika (7)", 	5000},
	{2261, "Slika (8)", 	5000},
	{2255, "Slika (9)", 	5000},
	{644,  "Cvece (1)", 	5000},
	{2241, "Cvece (2)", 	5000},
	{2245, "Cvece (3)", 	5000},
	{2247, "Cvece (4)", 	5000},
	{2249, "Cvece (5)", 	5000},
	{2251, "Cvece (6)", 	5000},
	{2252, "Cvece (7)", 	5000},
	{2253, "Cvece (8)", 	5000},
	{2631, "Prostirka (1)", 5000},
	{2632, "Prostirka (2)", 5000},
	{2815, "Prostirka (3)", 5000},
	{2817, "Prostirka (4)", 5000},
	{2818, "Prostirka (5)", 5000},
	{2841, "Prostirka (6)", 5000},
	{2842, "Prostirka (7)", 5000}
};

new f_appliances[20][e_furniture] =
{
	{1518, "Televizor", 		  5000},
	{1429, "Pokvareni televizor", 5000},
	{1429, "Kasetofon", 		  5000},
	{1208, "Masina za ves", 	  5000},
	{1481, "Rostilj", 			  5000},
	{1790, "Video rekorder", 	  5000},
	{1738, "Radijator", 		  5000},
	{2186, "Fotokopir masina", 	  5000},
	{2627, "Traka za trcanje", 	  5000},
	{2628, "Bench klupa (1)", 	  5000},
	{2629, "Bench klupa (2)", 	  5000},
	{2630, "Nepokretni bickl", 	  5000},
	{2421, "Mikrotalasna", 		  5000},
	{1809, "Hi-Fi (1)", 		  5000},
	{2101, "Hi-Fi (2)", 		  5000},
	{2226, "Hi-Fi (3)", 		  5000},
	{2102, "Hi-Fi (4)", 		  5000},
	{2103, "Hi-Fi (5)", 		  5000},
	{2106, "Hi-Fi (6)", 		  5000},
	{2099, "Hi-Fi (7)", 		  5000}
};

new f_bathroom[14][e_furniture] =
{
	{2514, "WC solja (1)", 	5000},
	{2521, "WC solja (2)", 	5000},
	{2525, "WC solja (3)", 	5000},
	{2528, "WC solja (4)", 	5000},
	{2523, "Lavabo (1)", 	5000},
	{2524, "Lavabo (2)", 	5000},
	{2739, "Lavabo (3)", 	5000},
	{2519, "Kada (1)", 		5000},
	{2522, "Kada (2)", 		5000},
	{2526, "Kada (3)", 		5000},
	{2097, "Kada (sprunk)", 5000},
	{2517, "Kabina (1)", 	5000},
	{2520, "Kabina (2)", 	5000},
	{2527, "Kabina (3)", 	5000}
};

new f_kitchen[24][e_furniture] =
{
	{2133, "Kuhinja 1 (R)",        5000},
	{2134, "Kuhinja 1 (M)",        5000},
	{2141, "Kuhinja 1 (L)",        5000},
	{2341, "Kuhinja 1 (ugao)",     5000},
	{2131, "Kuhinja 1 (frizider)", 5000},
	{2132, "Kuhinja 1 (lavabo)",   5000},
	{2339, "Kuhinja 1 (sporet)",   5000},
	{2340, "Kuhinja 1 (perac)",    5000},
	{2335, "Kuhinja 2 (R)",        5000},
	{2334, "Kuhinja 2 (M)",        5000},
	{2158, "Kuhinja 2 (L)",        5000},
	{2338, "Kuhinja 2 (ugao)",     5000},
	{2147, "Kuhinja 2 (frizider)", 5000},
	{2336, "Kuhinja 2 (lavabo)",   5000},
	{2170, "Kuhinja 2 (sporet)",   5000},
	{2337, "Kuhinja 2 (perac)",    5000},
	{2822, "Cisto posudje (1)",    5000},
	{2862, "Cisto posudje (2)",    5000},
	{2863, "Cisto posudje (3)",    5000},
	{2864, "Cisto posudje (4)",    5000},
	{2820, "Prljavo posudje (1)",  5000},
	{2848, "Prljavo posudje (2)",  5000},
	{2850, "Prljavo posudje (3)",  5000},
	{2851, "Prljavo posudje (4)",  5000}
};

new f_shelves[12][e_furniture] =
{
	{1744, "Polica (1)", 		 5000},
	{2482, "Polica (2)", 		 5000},
	{2708, "Polica (3)", 		 5000},
	{1742, "Polica sa knjigama", 5000},
	{1741, "Ormar (1)", 		 5000},
	{1743, "Ormar (2)", 		 5000},
	{2087, "Ormar (3)", 		 5000},
	{2088, "Ormar (4)", 		 5000},
	{2197, "Ormar (5)", 		 5000},
	{2204, "Ormar (6)", 		 5000},
	{2328, "Ormar (7)", 		 5000},
	{912,  "Ormar (8)", 		 5000}
};

new f_food_drinks[18][e_furniture] =
{
	{2212, "Burger Shot",    5000},
	{2215, "Cluckin' Bell",  5000},
	{2220, "Pizza Hut",      5000},
	{2222, "Dunkin' Donuts", 5000},
	{1487, "Flasa (1)", 	 5000},
	{1520, "Flasa (2)", 	 5000},
	{1543, "Flasa (3)", 	 5000},
	{1544, "Flasa (4)", 	 5000},
	{1664, "Flasa (5)", 	 5000},
	{1668, "Flasa (6)", 	 5000},
	{1455, "Casa (1)",  	 5000},
	{1546, "Casa (2)",  	 5000},
	{1667, "Casa (3)",  	 5000},
	{2821, "Otpad (1)", 	 5000},
	{2838, "Otpad (2)", 	 5000},
	{2840, "Otpad (3)", 	 5000},
	{2837, "Otpad (4)", 	 5000},
	{2814, "Otpad (5)", 	 5000}
};

new f_misc[13][e_furniture] =
{
	{2964, "Sto za bilijar", 	5000},
	{2961, "Pozarni alarm", 	5000},
	{2614, "Zastavice", 		5000},
	{1549, "Korpa za otpad", 	5000},
	{3111, "Nacrt (1)", 		5000},
	{3017, "Nacrt (2)", 		5000},
	{2894, "Knjiga", 			5000},
	{2114, "Lopta", 			5000},
	{1828, "Tigrasti tepih", 	5000},
	{2002, "Aparat za vodu", 	5000},
	{3071, "Mali teg", 			5000},
	{2913, "Veliki teg", 		5000},
	{1985, "Vreca za udaranje", 5000}
};

new f_samp[24][e_furniture] =
{
	{19273, "Tastatura", 	  5000},
	{19317, "Gitara", 	 	  5000},
	{19078, "Papagaj", 	 	  5000},
	{19173, "Pejzaz", 	 	  5000},
	{19054, "Poklon (1)", 	  5000},
	{19055, "Poklon (2)", 	  5000},
	{19056, "Poklon (3)", 	  5000},
	{19057, "Poklon (4)", 	  5000},
	{19058, "Poklon (5)", 	  5000},
	{19059, "Lopta (1)", 	  5000},
	{19060, "Lopta (2)", 	  5000},
	{19061, "Lopta (3)", 	  5000},
	{19062, "Lopta (4)", 	  5000},
	{19063, "Lopta (5)", 	  5000},
	{19128, "Sareni pod (1)", 5000},
	{19129, "Sareni pod (2)", 5000},
	{19164, "Mapa (1)", 	  5000},
	{19165, "Mapa (2)", 	  5000},
	{19166, "Mapa (3)", 	  5000},
	{19167, "Mapa (4)", 	  5000},
	{19168, "Mapa (5)", 	  5000},
	{19169, "Mapa (6)", 	  5000},
	{19170, "Mapa (7)", 	  5000},
	{19171, "Mapa (8)", 	  5000}
};




// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit()
{
    furnitureList[ITEMS_TABLES]      = LoadModelSelectionMenu("mSelection/furniture/tables.list");
    furnitureList[ITEMS_CHAIRS]      = LoadModelSelectionMenu("mSelection/furniture/chairs.list");
    furnitureList[ITEMS_BEDS]        = LoadModelSelectionMenu("mSelection/furniture/beds.list");
    furnitureList[ITEMS_SOFAS]       = LoadModelSelectionMenu("mSelection/furniture/sofas.list");
    furnitureList[ITEMS_DECORATIONS] = LoadModelSelectionMenu("mSelection/furniture/decorations.list");
    furnitureList[ITEMS_APPLIANCES]  = LoadModelSelectionMenu("mSelection/furniture/appliances.list");
    furnitureList[ITEMS_BATHROOM]    = LoadModelSelectionMenu("mSelection/furniture/bathroom.list");
    furnitureList[ITEMS_KITCHEN]     = LoadModelSelectionMenu("mSelection/furniture/kitchen.list");
    furnitureList[ITEMS_SHELVES]     = LoadModelSelectionMenu("mSelection/furniture/shelves.list");
    furnitureList[ITEMS_FOOD_DRINKS] = LoadModelSelectionMenu("mSelection/furniture/food_drinks.list");
    furnitureList[ITEMS_MISC]        = LoadModelSelectionMenu("mSelection/furniture/misc.list");
    furnitureList[ITEMS_SAMP]        = LoadModelSelectionMenu("mSelection/furniture/samp.list");
	return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (ft_edit[playerid] != -1 || pRealEstate[playerid][kuca] == -1)
		return 1;

    if (DebugFunctions())
    {
        LogCallbackExec("furniture.pwn", "OnPlayerKeyStateChange");
    }
		
	if (!(newkeys & KEY_SECONDARY_ATTACK) && oldkeys & KEY_SECONDARY_ATTACK) // Enter
    {
		new
			lid,
			gid,
			slot = -1, // slot ID najblizeg objekta
			Float:poz[3],
			Float:udaljenost[2], // 0 - udaljenost od prethodnog objekta, 1 - udaljenost od trenutnog objekta
			naslov[40]
		;
		lid = pRealEstate[playerid][kuca];
		gid = re_globalid(kuca, lid);
		udaljenost[0] = 9999999.0;
		
		if (GetPlayerVirtualWorld(playerid) != gid || GetPlayerInterior(playerid) != RealEstate[gid][RE_ENT]) // Nije u kuci
			return 1;
		
		
		for__loop (new i = 0; i < MAX_OBJEKATA; i++) // Loop kroz sve objekte da se nadje najblizi
		{
			if (H_FURNITURE[lid][i][hf_dynid] != -1)
			{
				GetDynamicObjectPos(H_FURNITURE[lid][i][hf_dynid], poz[0], poz[1], poz[2]);
				udaljenost[1] = GetPlayerDistanceFromPoint(playerid, poz[0], poz[1], poz[2]);
				
				if (udaljenost[1] < udaljenost[0])
				{
					slot = i;
					udaljenost[0] = udaljenost[1];
				}
			}
		}
		if (slot == -1)
			return 1;
			
		if (GetPlayerDistanceFromPoint(playerid, H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], H_FURNITURE[lid][slot][hf_z_poz]) > 10.0)
			return 1;
			
			
		SetPVarInt(playerid, "pExitDialog", 1);
		ft_edit[playerid] = slot;
		uredjuje[playerid][UREDJUJE_VRSTA] = kuca;
		uredjuje[playerid][UREDJUJE_LISTITEM] = 0;
		
		format(naslov, sizeof(naslov), "{0068B3}%s", H_FURNITURE[lid][ft_edit[playerid]][hf_name]);
		SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
	}
	return 1;
}

hook OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("furniture.pwn", "OnPlayerModelSelection");
    }

    new bool:ok = false;
    for__loop (new i = 0; i < FURNITURE_NUM_CAT; i++)
    {
        if (listid == furnitureList[i])
        {
            ok = true;
            break;
        }
    }
    if (!ok) return 1;


    if (!response)
        return dialog_respond:ft_main(playerid, response, 1, "");
        
    new
        vrsta,
        kategorija
    ;
    vrsta   = uredjuje[playerid][UREDJUJE_VRSTA];
    kategorija = ft_category[playerid];

    if (vrsta != kuca) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (12)");

    if (pRealEstate[playerid][kuca] == -1)
        return ErrorMsg(playerid, "Ne podesujete kucu.");
        
        
    // Dobijanje naziva predmeta i cene
    switch (kategorija)
    {
        case ITEMS_TABLES:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_tables; i++)
            {
                if (f_tables[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_tables[index][ft_name], 0, strlen(f_tables[index][ft_name]));
            ft_item_price[playerid] = f_tables[index][ft_price];
            
            ft_item[playerid] = f_tables[index][ft_id];
        }
        case ITEMS_CHAIRS:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_chairs; i++)
            {
                if (f_chairs[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_chairs[index][ft_name], 0, strlen(f_chairs[index][ft_name]));
            ft_item_price[playerid] = f_chairs[index][ft_price];
            
            ft_item[playerid] = f_chairs[index][ft_id];
        }
        case ITEMS_BEDS:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_beds; i++)
            {
                if (f_beds[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_beds[index][ft_name], 0, strlen(f_beds[index][ft_name]));
            ft_item_price[playerid] = f_beds[index][ft_price];
            
            ft_item[playerid] = f_beds[index][ft_id];
        }
        case ITEMS_SOFAS:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_sofas; i++)
            {
                if (f_sofas[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_sofas[index][ft_name], 0, strlen(f_sofas[index][ft_name]));
            ft_item_price[playerid] = f_sofas[index][ft_price];
            
            ft_item[playerid] = f_sofas[index][ft_id];
        }
        case ITEMS_DECORATIONS:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_decorations; i++)
            {
                if (f_decorations[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_decorations[index][ft_name], 0, strlen(f_decorations[index][ft_name]));
            ft_item_price[playerid] = f_decorations[index][ft_price];
            
            ft_item[playerid] = f_decorations[index][ft_id];
        }
        case ITEMS_APPLIANCES:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_appliances; i++)
            {
                if (f_appliances[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_appliances[index][ft_name], 0, strlen(f_appliances[index][ft_name]));
            ft_item_price[playerid] = f_appliances[index][ft_price];
            
            ft_item[playerid] = f_appliances[index][ft_id];
        }
        case ITEMS_BATHROOM:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_bathroom; i++)
            {
                if (f_bathroom[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_bathroom[index][ft_name], 0, strlen(f_bathroom[index][ft_name]));
            ft_item_price[playerid] = f_bathroom[index][ft_price];
            
            ft_item[playerid] = f_bathroom[index][ft_id];
        }
        case ITEMS_KITCHEN:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_kitchen; i++)
            {
                if (f_kitchen[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_kitchen[index][ft_name], 0, strlen(f_kitchen[index][ft_name]));
            ft_item_price[playerid] = f_kitchen[index][ft_price];
            
            ft_item[playerid] = f_kitchen[index][ft_id];
        }
        case ITEMS_SHELVES:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_shelves; i++)
            {
                if (f_shelves[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_shelves[index][ft_name], 0, strlen(f_shelves[index][ft_name]));
            ft_item_price[playerid] = f_shelves[index][ft_price];
            
            ft_item[playerid] = f_shelves[index][ft_id];
        }
        case ITEMS_FOOD_DRINKS:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_food_drinks; i++)
            {
                if (f_food_drinks[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_food_drinks[index][ft_name], 0, strlen(f_food_drinks[index][ft_name]));
            ft_item_price[playerid] = f_food_drinks[index][ft_price];
            
            ft_item[playerid] = f_food_drinks[index][ft_id];
        }
        case ITEMS_MISC:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_misc; i++)
            {
                if (f_misc[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_misc[index][ft_name], 0, strlen(f_misc[index][ft_name]));
            ft_item_price[playerid] = f_misc[index][ft_price];
            
            ft_item[playerid] = f_misc[index][ft_id];
        }
        case ITEMS_SAMP:
        {
            new index = -1;
            for__loop (new i = 0; i < sizeof f_samp; i++)
            {
                if (f_samp[i][ft_id] == modelid)
                {
                    index = i;
                    break;
                }
            }
            if (index == -1) return SendClientMessageF(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (list %i, cat %i, model %i)", listid, kategorija, modelid);

            strmid(ft_item_name[playerid], f_samp[index][ft_name], 0, strlen(f_samp[index][ft_name]));
            ft_item_price[playerid] = f_samp[index][ft_price];
            
            ft_item[playerid] = f_samp[index][ft_id];
        }
        default: return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (13)");
    }
        
    new sDialog[286],
    	sTitle[42];
    format(sTitle, sizeof(sTitle), "{0068B3}%s", ft_item_name[playerid]);
    format(sDialog, sizeof sDialog, "{FFFFFF}Kategorija: {0068B3}%s\n{FFFFFF}Predmet: {0068B3}%s\n{FFFFFF}Cena: {0068B3}%s\n\n{FFFFFF}Ukoliko Vam se ne dopada kupljeni predmet, jednostavnim pritiskom\nna tipku \"ESC\" ga mozete prodati i dobiti svoj novac natrag.", f_categories[kategorija][ft_cat_name], ft_item_name[playerid], formatMoneyString(ft_item_price[playerid]));
    
    SPD(playerid, "ft_kupovina_potvrda", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Kupi", "Nazad");
    return 1;
}

hook OnPlayerEditDynObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if (response == EDIT_RESPONSE_FINAL && ft_edit[playerid] != -1)
	{
        if (DebugFunctions())
        {
            LogCallbackExec("furniture.pwn", "OnPlayerEditDynObject");
        }
        
		new 
			pozicija_str[66],
			slot,
			lid,
			gid
		;
		slot = ft_edit[playerid];
		lid  = pRealEstate[playerid][kuca];
		gid  = re_globalid(kuca, lid);

		if (pRealEstate[playerid][kuca] == -1)
			return ErrorMsg(playerid, "Ne podesujete kucu.");
			
		if (GetPlayerVirtualWorld(playerid) != gid || GetPlayerInterior(playerid) != RealEstate[gid][RE_ENT])
		{
			ErrorMsg(playerid, "Ne nalazite se u svojoj kuci, ne mozete sacuvati izmene.");
			ft_edit[playerid] = -1;
			
			return 1;
		}
		
		
		// Izmena promenljivih
		H_FURNITURE[lid][slot][hf_x_poz] = x;
		H_FURNITURE[lid][slot][hf_y_poz] = y;
		H_FURNITURE[lid][slot][hf_z_poz] = z;
		H_FURNITURE[lid][slot][hf_x_rot] = rx;
		H_FURNITURE[lid][slot][hf_y_rot] = ry;
		H_FURNITURE[lid][slot][hf_z_rot] = rz;
		
		format(pozicija_str, sizeof(pozicija_str), "%.4f|%.4f|%.4f|%.4f|%.4f|%.4f", H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], 
			H_FURNITURE[lid][slot][hf_z_poz], H_FURNITURE[lid][slot][hf_x_rot], H_FURNITURE[lid][slot][hf_y_rot], H_FURNITURE[lid][slot][hf_z_rot]);
			
		// Ponovno kreiranje objekta
		DestroyDynamicObject(H_FURNITURE[lid][slot][hf_dynid]);
		H_FURNITURE[lid][slot][hf_dynid] = 	CreateDynamicObject(H_FURNITURE[lid][slot][hf_object_id], H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], H_FURNITURE[lid][slot][hf_z_poz], H_FURNITURE[lid][slot][hf_x_rot], H_FURNITURE[lid][slot][hf_y_rot], H_FURNITURE[lid][slot][hf_z_rot], gid, RealEstate[gid][RE_ENT], -1, 80.0);

		Streamer_Update(playerid);
		
		// Unistavanje textdrawa
		TextDrawHideForPlayer(playerid, tdFurnitureHint);
			
		// Upisivanje u bazu
		format(mysql_upit, sizeof mysql_upit, "UPDATE re_kuce_predmeti SET pozicija = '%s' WHERE u_id = %d", pozicija_str, H_FURNITURE[lid][slot][hf_uid]);
		mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_KOBJEKTI_UPDATE);
		
		// Vracanje na prethodni dialog
		new naslov[40];
		format(naslov, sizeof(naslov), "{0068B3}%s", H_FURNITURE[lid][slot][hf_name]);
		SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
	}
	
	else if (response == EDIT_RESPONSE_CANCEL && ft_edit[playerid] != -1)
	{
		if (pRealEstate[playerid][kuca] == -1)
			return ErrorMsg(playerid, "Ne podesujete kucu.");
			
		if (ft_just_bought{playerid}) // Tek kupljen objekat, prodaj i vrati novac igracu
		{
			new 
				slot,
				lid,
				uid
			;
			slot = ft_edit[playerid];
			lid  = pRealEstate[playerid][kuca];

			if (pRealEstate[playerid][kuca] == -1)
				return ErrorMsg(playerid, "Ne podesujete kucu.");
		
			// Vracanje novca
			PlayerMoneyAdd(playerid, H_FURNITURE[lid][slot][hf_price]);
			
			// Slanje poruke igracu
			SendClientMessageF(playerid, ZUTA, "* Prodali ste %s, vraceno Vam je $%d.", H_FURNITURE[lid][slot][hf_name], H_FURNITURE[lid][slot][hf_price]);
				
			uid = H_FURNITURE[lid][slot][hf_uid];
			// Resetovanje varijabli
			H_FURNITURE[lid][slot][hf_uid]       = -1;
			H_FURNITURE[lid][slot][hf_object_id] = -1;
			H_FURNITURE[lid][slot][hf_price] 	 = 0;
			H_FURNITURE[lid][slot][hf_name]  	 = EOS;
			DestroyDynamicObject(H_FURNITURE[lid][slot][hf_dynid]);
			H_FURNITURE[lid][slot][hf_dynid]     = -1;
		
			TextDrawHideForPlayer(playerid, tdFurnitureHint);
			
			// Brisanje iz baze
			format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_predmeti WHERE u_id = %d", uid);
			mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_KOBJEKTI_DELETE);
			
			ft_just_bought{playerid} = false;
		}
		else // Samo je odustao od promene pozicije
		{		
			new 
				slot,
				lid,
				gid
			;
			slot = ft_edit[playerid];
			lid  = pRealEstate[playerid][kuca];
			gid  = re_globalid(kuca, lid);

			if (pRealEstate[playerid][kuca] == -1)
				return ErrorMsg(playerid, "Ne podesujete kucu.");
			
			TextDrawHideForPlayer(playerid, tdFurnitureHint);
			
			// Ponovno kreiranje objekta
			DestroyDynamicObject(H_FURNITURE[lid][slot][hf_dynid]);
			H_FURNITURE[lid][slot][hf_dynid] = 	CreateDynamicObject(H_FURNITURE[lid][slot][hf_object_id], H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], H_FURNITURE[lid][slot][hf_z_poz], H_FURNITURE[lid][slot][hf_x_rot], H_FURNITURE[lid][slot][hf_y_rot], H_FURNITURE[lid][slot][hf_z_rot], gid, RealEstate[gid][RE_ENT], -1, 80.0);
			Streamer_Update(playerid);
			
			// Vracanje na prethodni dialog
			new naslov[40];
			format(naslov, sizeof(naslov), "{0068B3}%s", H_FURNITURE[pRealEstate[playerid][kuca]][ft_edit[playerid]][hf_name]);
			SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
		}
	}
	
	return 1;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
IsPlayerEditingFurniture(playerid) 
{
	if (ft_edit[playerid] == -1) return false;
	else return true;
}



// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_ft_insert(playerid, slot, ccinc);
public mysql_ft_insert(playerid, slot, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_ft_insert");
    }

	if (!checkcinc(playerid, ccinc)) return 1;
		
	new
		vrsta,
		lid
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	lid   = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (01)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
	
	if (slot != ft_edit[playerid])
		return 1;
		
	TextDrawShowForPlayer(playerid, tdFurnitureHint);
	
	ft_just_bought{playerid} = true;
	H_FURNITURE[lid][slot][hf_uid] = cache_insert_id();
	EditDynamicObject(playerid, H_FURNITURE[lid][slot][hf_dynid]);
		
	return 1;
}





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:ft_main(playerid, response, listitem, const inputtext[]) // Uredjivanje kuce
{
	if (uredjuje[playerid][UREDJUJE_VRSTA] == -1) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (02)");

	if (!response) 
		return dialog_respond:nekretnine(playerid, 1, uredjuje[playerid][UREDJUJE_LISTITEM], "");
		
	new
	    vrsta,
		lid
	;
	vrsta   = uredjuje[playerid][UREDJUJE_VRSTA];
	lid     = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (03)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
		
	switch (listitem)
	{
		case 0: // Vidi predmete u kuci
		{
			new 
                string[1024], found = 0;

            ft_edit[playerid]        = -1;
            ft_edit_page[playerid]   = 0;
            ft_just_bought{playerid} = false;
            string[0]                = EOS;
			
			// Najpre se resetuje varijabla "ft_list" (sve)
			for__loop (new i = 0; i < sizeof(ft_list[][]); i++)
			{
				for__loop (new j = 0; j < sizeof(ft_list[]); j++)
				{
					ft_list[playerid][j][i] = -1;
				}
			}
			
			// Formiranje liste
			for__loop (new i = 0, x = 0, page = 0; i < MAX_OBJEKATA; i++)
			{
				if (H_FURNITURE[lid][i][hf_object_id] > 1)
				{
					found = 1;
					
					
					// Ako je ovo 11. iteracija, znaci da postoji vise od 10 predmeta za ovu stranicu, i ima mesta za sledecu
					// Resetovati brojac (u 11. listitem ide "Sledeca stranica") i krenuti na sledecu stranicu
					if (x == 10)
					{
						ft_list[playerid][page][x] = -2; // -2 oznacava "sledeca stranica"
					
						x = 0;
						page ++;
					}
					
					ft_list[playerid][page][x] = i;
					x ++;
				}
			}
			
			// Prikazivanje prve stranice
			for__loop (new i = 0; i < sizeof(ft_list[][]); i++)
			{
				if (ft_list[playerid][ft_edit_page[playerid]][i] == -1)
					break;
				else if (ft_list[playerid][ft_edit_page[playerid]][i] == -2) // Sledeca stranica
				{
					strins(string, "Sledeca strana -", strlen(string), 1024);
					break;
				}
				else // Neki slot
				{
					format(string, 1024, "%s%s\n", string, H_FURNITURE[lid][ ft_list[playerid][ ft_edit_page[playerid] ][i] ][hf_name]);
				}
			}
			
			// Da li postoji makar 1 predmet?
			if (found == 0 || isnull(string))
			{
				ErrorMsg(playerid, "Jos uvek niste kupili nijedan predmet za ovu kucu.");
				return DialogReopen(playerid);
			}
			
			// Prikazujemo prvu stranicu
			new sTitle[35];
			format(sTitle, sizeof sTitle, "{0068B3}PREGLED PREDMETA [%d/%d]", (ft_edit_page[playerid] + 1), sizeof(ft_list[]));
			SPD(playerid, "ft_pregled", DIALOG_STYLE_LIST, sTitle, string, "Dalje -", "- Nazad");
		}
		case 1: // Kupi novi predmet
		{
			new sDialog[128];
			sDialog[0] = EOS;
			for__loop (new i = 0; i < sizeof(f_categories); i++)
			{
				format(sDialog, sizeof sDialog, "%s%s\n", sDialog, f_categories[i][ft_cat_name]);
			}
			
			SPD(playerid, "ft_kupovina_kategorije", DIALOG_STYLE_LIST, "{0068B3}KUPOVINA NOVOG PREDMETA", sDialog, "Dalje -", "- Nazad");
		}
	}
	
	return 1;
}

Dialog:ft_pregled(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		if (ft_edit_page[playerid] == 0) // Na prvoj stranici je, vrati na glavni meni
			return SPD(playerid, "ft_main", DIALOG_STYLE_LIST, "{0068B3}KUCA - UREDJIVANJE", "Vidi predmete u kuci\nKupi novi predmet", "Dalje -", "- Nazad");
		
		// Ako stranica != 0, to se resava malo dole, gde se odlucuje da li ce se stranica povecati ili smanjiti
	}
		
	new
	    vrsta,
		page,
		lid,
		naslov[40]
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	page  = ft_edit_page[playerid];
	lid   = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (04)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
	
	if (!response && ft_edit_page[playerid] > 0) // Vraca se na prethodnu stranicu
		ft_edit_page[playerid] --;
	else if (!isnull(inputtext) && !strcmp(inputtext, "Sledeca strana -", false)) // Ide na sledecu stranu
		ft_edit_page[playerid] ++;
	else // Odabrao je neki predmet
	{
		ft_edit[playerid] = ft_list[playerid][page][listitem];
		
		format(naslov, sizeof(naslov), "{0068B3}%s", H_FURNITURE[lid][ft_edit[playerid]][hf_name]);
		SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
	}
	
	// Ide na sledecu/prethodnu stranicu?
	if (page != ft_edit_page[playerid]) 
	{
        new string[1024];
		string[0] = EOS;
		for__loop (new i = 0; i < sizeof(ft_list[][]); i++) 
		{
			if (ft_list[playerid][ft_edit_page[playerid]][i] == -1)
			{
				break;
			}

			else if (ft_list[playerid][ft_edit_page[playerid]][i] == -2) // Sledeca stranica
			{
				strins(string, "Sledeca strana -", strlen(string), 1024);
				break;
			}

			else // Neki slot
			{
				format(string, 1024, "%s%s\n", string, H_FURNITURE[lid][ft_list[playerid][ft_edit_page[playerid]][i]][hf_name]);
			}
		}
		
		// Da li postoji makar 1 predmet?
		if (isnull(string)) 
		{
			SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (05)");
			return DialogReopen(playerid);
		}
		
		// Prikazujemo novu stranicu
		new sTitle[35];
		format(sTitle, sizeof sTitle, "{0068B3}PREGLED PREDMETA [%d/%d]", (ft_edit_page[playerid] + 1), sizeof(ft_list[]));
		SPD(playerid, "ft_pregled", DIALOG_STYLE_LIST, sTitle, string, "Dalje -", "- Nazad");
	}
	
	return 1;
}

Dialog:ft_izmena(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		ft_edit[playerid] = -1;
		
		
		if (GetPVarInt(playerid, "pExitDialog") == 1)
			return DeletePVar(playerid, "pExitDialog");
			
		dialog_respond:ft_main(playerid, 1, 0, "");
		return 1;
	}
		
	new
	    vrsta,
		slot,
		lid
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	slot  = ft_edit[playerid];
	lid   = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (06)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
	if (slot < 0 || slot >= MAX_OBJEKATA)
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (06)");
		
	
	switch (listitem)
	{
		case 0: // Informacije
		{
			new sDialog[175];
			format(sDialog, sizeof sDialog, "{FFFFFF}Slot: {0068B3}%d\n{FFFFFF}Kategorija: {0068B3}%s\n{FFFFFF}Predmet: {0068B3}%s\n{FFFFFF}Cena: {0068B3}%s", slot, f_categories[H_FURNITURE[lid][slot][hf_category]][ft_cat_name], H_FURNITURE[lid][slot][hf_name], formatMoneyString(H_FURNITURE[lid][slot][hf_price]));
				
			SPD(playerid, "ft_predmet_info", DIALOG_STYLE_MSGBOX, "{0068B3}INFO O PREDMETU", sDialog, "Nazad", "");
		}
		case 1: // Izmeni poziciju
		{
			TextDrawShowForPlayer(playerid, tdFurnitureHint);
			EditDynamicObject(playerid, H_FURNITURE[lid][slot][hf_dynid]);
		}
		case 2: // Izmeni naziv
		{
			new sDialog[150];
			format(sDialog, sizeof sDialog, "{FFFFFF}Predmet: {0068B3}%s\n\n{FFFFFF}Naziv mora sadrzati izmedju 3 i 30 znakova.\nUpisite novi naziv ovog predmeta:", H_FURNITURE[lid][slot][hf_name]);
			SPD(playerid, "ft_predmet_naziv", DIALOG_STYLE_INPUT, "{0068B3}IZMENA NAZIVA", sDialog, "Izmeni", "Nazad");
		}
		case 3: // Prodaj
		{
			new sDialog[235];
			format(sDialog, sizeof sDialog, "{FFFFFF}Slot: {0068B3}%d\n{FFFFFF}Kategorija: {0068B3}%s\n{FFFFFF}Predmet: {0068B3}%s\n{FFFFFF}Cena: {0068B3}%s\n\n{FFFFFF}Ukoliko prodate predmet, dobicete svoj novac nazad.",
				slot, f_categories[H_FURNITURE[lid][slot][hf_category]][ft_cat_name], H_FURNITURE[lid][slot][hf_name], formatMoneyString(H_FURNITURE[lid][slot][hf_price]));
				
			SPD(playerid, "ft_predmet_prodaja", DIALOG_STYLE_MSGBOX, "{0068B3}PRODAJA PREDMETA", sDialog, "Prodaj", "Nazad");
		}
	}
	
	return 1;
}

Dialog:ft_predmet_info(playerid, response, listitem, const inputtext[])
{
	new
	    vrsta,
		lid,
		naslov[40]
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	lid   = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (07)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
		
	format(naslov, sizeof(naslov), "{0068B3}%s", H_FURNITURE[lid][ft_edit[playerid]][hf_name]);
	SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, naslov, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
	
	return 1;
}

Dialog:ft_predmet_naziv(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:ft_predmet_info(playerid, 1, 0, "");

	new
	    vrsta,
		lid,
		input[MAX_FITEM_NAME],
		slot
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	lid   = pRealEstate[playerid][kuca];
	slot  = ft_edit[playerid];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (08)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
	
	if (sscanf(inputtext, "s[" #MAX_FITEM_NAME "]", input) || strlen(input) < 3 || strlen(input) >= MAX_FITEM_NAME)
		return DialogReopen(playerid);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste izmenili naziv predmeta | %s - %s", H_FURNITURE[lid][slot][hf_name], input);
		
	// Izmena
	strmid(H_FURNITURE[lid][slot][hf_name], input, 0, strlen(input), MAX_FITEM_NAME);
	
	// Upisivanje u bazu
	mysql_format(SQL, mysql_upit, 128, "UPDATE re_kuce_predmeti SET naziv = '%s' WHERE u_id = %d", input, H_FURNITURE[lid][slot][hf_uid]);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_KOBJEKTI_UPDATE);
		
	// Vracanje na prethodni dialog
	new sTitle[40];
	format(sTitle, sizeof sTitle, "{0068B3}%s", H_FURNITURE[lid][slot][hf_name]);
	SPD(playerid, "ft_izmena", DIALOG_STYLE_LIST, sTitle, "Informacije\nIzmeni poziciju\nIzmeni naziv\nProdaj", "Dalje -", "- Nazad");
		
	return 1;
}

Dialog:ft_predmet_prodaja(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:ft_predmet_info(playerid, 1, 0, "");

	new
	    vrsta,
		lid,
		slot,
		uid
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	lid   = pRealEstate[playerid][kuca];
	slot  = ft_edit[playerid];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (09)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
		
	// Vracanje novca
	PlayerMoneyAdd(playerid, H_FURNITURE[lid][slot][hf_price]);
	
	// Slanje poruke igracu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Prodali ste %s za %s.", H_FURNITURE[lid][slot][hf_name], formatMoneyString(H_FURNITURE[lid][slot][hf_price]));
		
	uid = H_FURNITURE[lid][slot][hf_uid];
	// Resetovanje varijabli
	H_FURNITURE[lid][slot][hf_uid] = -1;
	H_FURNITURE[lid][slot][hf_object_id] = -1;
	H_FURNITURE[lid][slot][hf_price] = 0;
	H_FURNITURE[lid][slot][hf_name] = EOS;
	DestroyDynamicObject(H_FURNITURE[lid][slot][hf_dynid]);
	H_FURNITURE[lid][slot][hf_dynid] = -1;
	
	// Brisanje iz baze
	format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_kuce_predmeti WHERE u_id = %d", uid);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_KOBJEKTI_DELETE);
	
	dialog_respond:ft_main(playerid, 1, 0, "");
	ft_edit[playerid] = -1;
		
	return 1;
}

Dialog:ft_kupovina_kategorije(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return SPD(playerid, "ft_main", DIALOG_STYLE_LIST, "{0068B3}KUCA - UREDJIVANJE", "Vidi predmete u kuci\nKupi novi predmet", "Dalje -", "- Nazad");
		
	new vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (10)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
	
	ft_category[playerid] = f_categories[listitem][ft_cat_id];
	ShowModelSelectionMenu(playerid, furnitureList[ft_category[playerid]], "Izaberite predmet");
	return 1;
}

Dialog:ft_kupovina_potvrda(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return dialog_respond:ft_kupovina_kategorije(playerid, 1, ft_category[playerid], "");
		
	new
	    vrsta,
		gid,
		lid,
		slot = -1
	;
	vrsta = uredjuje[playerid][UREDJUJE_VRSTA];
	lid   = pRealEstate[playerid][kuca];

	if (vrsta != kuca) 
		return SendClientMessage(playerid, TAMNOCRVENA2, "[furniture.pwn] "GRESKA_NEPOZNATO" (14)");

	if (pRealEstate[playerid][kuca] == -1)
		return ErrorMsg(playerid, "Ne podesujete kucu.");
		
	if (PI[playerid][p_novac] < ft_item_price[playerid])
		return ErrorMsg(playerid, "Nemate dovoljno novca.");
		
	
	gid = re_globalid(kuca, pRealEstate[playerid][kuca]);
	for__loop (new i = 0; i < MAX_OBJEKATA; i++)
	{
		if (H_FURNITURE[lid][i][hf_object_id] < 1)
		{
			slot = i;
			
			break;
		}
	}
	if (slot == -1)
		return ErrorMsg(playerid, "Prekoracili ste dozvoljeni limit objekata (" #MAX_OBJEKATA ").");
	
	
	
	new pozicija_str[66], Float:Angle;
	
	// Postavljanje vrednosti u varijable
	ft_edit[playerid] = slot;
	H_FURNITURE[lid][slot][hf_object_id] = ft_item[playerid];
	H_FURNITURE[lid][slot][hf_category]  = ft_category[playerid];
	H_FURNITURE[lid][slot][hf_price]	 = ft_item_price[playerid];
	strmid(H_FURNITURE[lid][slot][hf_name], ft_item_name[playerid], 0, strlen(ft_item_name[playerid]), MAX_FITEM_NAME);
    GetPlayerFacingAngle(playerid, Angle);
	GetPlayerPos(playerid, H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], H_FURNITURE[lid][slot][hf_z_poz]);
	
    H_FURNITURE[lid][slot][hf_x_poz] -= 5*floatcos(90-Angle, degrees);
    H_FURNITURE[lid][slot][hf_y_poz] += 5*floatsin(90-Angle, degrees);
    H_FURNITURE[lid][slot][hf_z_poz] += 1.0;
	H_FURNITURE[lid][slot][hf_x_rot] =  0.0;
	H_FURNITURE[lid][slot][hf_y_rot] =  0.0;
	H_FURNITURE[lid][slot][hf_z_rot] =  0.0;
	format(pozicija_str, sizeof(pozicija_str), "%.4f|%.4f|%.4f|%.4f|%.4f|%.4f", H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], 
		H_FURNITURE[lid][slot][hf_z_poz], H_FURNITURE[lid][slot][hf_x_rot], H_FURNITURE[lid][slot][hf_y_rot], H_FURNITURE[lid][slot][hf_z_rot]);
		
	// Kreiranje objekta
	H_FURNITURE[lid][slot][hf_dynid] = CreateDynamicObject(H_FURNITURE[lid][slot][hf_object_id], H_FURNITURE[lid][slot][hf_x_poz], H_FURNITURE[lid][slot][hf_y_poz], H_FURNITURE[lid][slot][hf_z_poz], H_FURNITURE[lid][slot][hf_x_rot], H_FURNITURE[lid][slot][hf_y_rot], H_FURNITURE[lid][slot][hf_z_rot], gid, RealEstate[gid][RE_ENT], -1, 80.0);
		
	// Oduzimanje novca
	PlayerMoneySub(playerid, ft_item_price[playerid]);
		
	// Upisivanje u bazu
	format(mysql_upit, sizeof mysql_upit, "INSERT INTO re_kuce_predmeti (k_id, o_id, kategorija, pozicija, naziv, cena) VALUES (%d, %d, %d, '%s', '%s', %d)",
		lid, ft_item[playerid], ft_category[playerid], pozicija_str, ft_item_name[playerid], ft_item_price[playerid]);
	mysql_tquery(SQL, mysql_upit, "mysql_ft_insert", "iii", playerid, ft_edit[playerid], cinc[playerid]);
	
	// TODO: Upisivanje u log
		
	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
