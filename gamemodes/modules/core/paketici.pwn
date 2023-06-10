#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_XMAS_TREES
{
    XMAS_OBJECT_ID,
    Text3D:XMAS_TEXT3D,
    Float:XMAS_POS[6],
    bool:XMAS_GIFT_OPENED,
    XMAS_OPENER_NAME[MAX_PLAYER_NAME],
    XMAS_GIFT_TYPE,
}

enum E_XMAS_GIFTS
{
    XMASGIFT_ID,
    XMASGIFT_NAME[24],    
}

enum
{
    XMAS_GIFT_NONE      = 0,
    XMAS_GIFT_FAGGIO    = 1,
    XMAS_GIFT_BMX       = 2,
    XMAS_GIFT_MONEY     = 3,
    XMAS_GIFT_IPOD      = 4,
    XMAS_GIFT_PASSPORT  = 5,
    XMAS_GIFT_MDMA      = 6,
    XMAS_GIFT_HEROIN    = 7,
    XMAS_GIFT_AKTIVNA   = 8,
    XMAS_GIFT_ARMOUR    = 9,
    XMAS_GIFT_DEAGLE    = 10,
    XMAS_GIFT_M4        = 11,
    XMAS_GIFT_MP5       = 12,
    XMAS_GIFT_TOKEN     = 13,

    // Potrebno izmeniti XMAS_GIFT_MAX_ID
}
// #define XMAS_GIFT_MIN_ID 3
// #define XMAS_GIFT_MAX_ID 10




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new tajmer:XmasDrop;

new XmasGifts[][E_XMAS_GIFTS] =
{
    {XMAS_GIFT_NONE,        "N/A"},
    {XMAS_GIFT_FAGGIO,      "Faggio"},    
    {XMAS_GIFT_BMX,         "BMX"},       
    {XMAS_GIFT_MONEY,       "Novac"},     
    {XMAS_GIFT_IPOD,        "iPod Nano"},      
    {XMAS_GIFT_PASSPORT,    "Pasos"},  
    {XMAS_GIFT_MDMA,        "MDMA 5g"},      
    {XMAS_GIFT_HEROIN,      "Heroin 5g"},    
    {XMAS_GIFT_AKTIVNA,     "2 poena aktivne igre"},   
    {XMAS_GIFT_ARMOUR,      "Pancir"},
    {XMAS_GIFT_DEAGLE,      "Deagle + 150 metaka"},
    {XMAS_GIFT_M4,          "M4 + 200 metaka"},
    {XMAS_GIFT_MP5,         "MP5 + 200 metaka"},
    {XMAS_GIFT_TOKEN,       "Token"}
};

new XmasTrees[][E_XMAS_TREES] =
{
    {-1, Text3D:INVALID_3DTEXT_ID, {1393.811401, -1163.691528, 22.799707, 0.000000, 0.000000, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1621.435180, -1319.822021, 16.389724, 0.000000, 0.000060, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1511.915893, -1713.893920, 13.049724, 0.000000, 0.000144, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1689.074951, -1864.780517, 12.519716, 0.000000, 0.000190, -30.5000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1280.054931, -1541.786865, 12.527249, 0.000000, 0.000000, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1213.744262, -1295.980468, 12.569706, 0.000000, 0.000273, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {2085.996093, -1317.169433, 22.879724, 0.000000, 0.000494, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1049.341674, -1720.631713, 12.539706, 0.000000, 0.000341, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {900.621276,  -1764.420532, 12.539706, 0.000000, 0.000364, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1837.317504, -1253.022216, 12.569703, 0.000000, 0.000137, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1361.253662, -1050.299682, 25.539709, 0.000000, 0.000038, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1145.067016, -932.098449,  42.079772, 0.000000, 0.000387, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {2076.178222, -1765.129516, 12.519721, 0.000000, 0.000570, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1805.197143, -1639.410156, 12.519721, 0.000000, 0.000624, 0.000000}, false, "N/A", 0},
    {-1, Text3D:INVALID_3DTEXT_ID, {1532.846191, -2264.065185, 12.529096, 0.000000, 0.000000, 0.000000}, false, "N/A", 0}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    for__loop (new i = 0; i < sizeof XmasTrees; i++)
    {
        XmasTrees[i][XMAS_OBJECT_ID] = CreateDynamicObject(19076, XmasTrees[i][XMAS_POS][0], XmasTrees[i][XMAS_POS][1], XmasTrees[i][XMAS_POS][2], XmasTrees[i][XMAS_POS][3], XmasTrees[i][XMAS_POS][4], XmasTrees[i][XMAS_POS][5], 750.0, 750.0);
        XmasTrees[i][XMAS_GIFT_OPENED] = false;
        // XmasTrees[i][XMAS_GIFT_TYPE] =  3 + (random(sizeof XmasGifts - 4)); // "-4" eliminise Nulu, bmx, faggio i poslednji id
        XmasTrees[i][XMAS_GIFT_TYPE] =  XMAS_GIFT_NONE;
        format(XmasTrees[i][XMAS_OPENER_NAME], MAX_PLAYER_NAME, "N/A");

        new str[128];
        format(str, sizeof str, "{DC3D2A}[ {00B32C}NOVOGODISNJA JELKA (%i) {DC3D2A}]\n\n{00B32C}Upisite {DC3D2A}/paketic {00B32C}da otvorite svoj paketic", i);
        XmasTrees[i][XMAS_TEXT3D] = CreateDynamic3DTextLabel(str, 0xFFFFFFFF, XmasTrees[i][XMAS_POS][0], XmasTrees[i][XMAS_POS][1], XmasTrees[i][XMAS_POS][2] + 2.0, 15.0);
    }

    SetTimer("XmasGiftsDrop", 5*60*1000, false); // prvi drop ide 5 minuta nakon paljenja servera
    tajmer:XmasDrop = SetTimer("XmasGiftsDrop", 60*60*1000 - 5*60*1000 + random(700)*1000, true);
    return true;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward XmasGiftsDrop();
public XmasGiftsDrop()
{
    for__loop (new i = 0; i < sizeof XmasTrees; i++)
    {
        XmasTrees[i][XMAS_GIFT_OPENED] = false;
        XmasTrees[i][XMAS_GIFT_TYPE] =  3 + (random(sizeof XmasGifts - 4)); // "-4" eliminise Nulu, bmx, faggio i poslednji id
        format(XmasTrees[i][XMAS_OPENER_NAME], MAX_PLAYER_NAME, "N/A");

        new str[128];
        format(str, sizeof str, "{DC3D2A}[ {00B32C}NOVOGODISNJA JELKA (%i) {DC3D2A}]\n\n{00B32C}Upisite {DC3D2A}/paketic {00B32C}da otvorite svoj paketic", i);
        UpdateDynamic3DTextLabelText(XmasTrees[i][XMAS_TEXT3D], 0xFFFFFFFF, str);
    }

    SendClientMessageToAll(0xDC3D2AFF, "HO {FFFFFF}HO {DC3D2A}HO  |  {00B32C}Stigla je nova isporuka Novogodisnjih paketica, pozuri da ih otvoris!");
    SendClientMessageToAll(0x00B32CFF, "Ko bude otvorio najvise paketica do Nove godine, osvaja vredne nagrade!");
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:izmenipaketic(playerid, response, listitem, const inputtext[])
{
    if (response)
    {   
        new tree = GetPVarInt(playerid, "pXmasEdit");
        XmasTrees[tree][XMAS_GIFT_TYPE] = strval(inputtext);

        SendClientMessageF(playerid, BELA, "* Poklon je izmenjen za jelku #%i: %s.", tree, XmasGifts[strval(inputtext)][XMASGIFT_NAME]);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:paketic("poklon")
CMD:paketic(playerid, const params[])
{
    new tree = -1;
    for__loop (new i = 0; i < sizeof XmasTrees; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 6.0, XmasTrees[i][XMAS_POS][0], XmasTrees[i][XMAS_POS][1], XmasTrees[i][XMAS_POS][2]))
        {
            tree = i;
            break;
        }
    }
    if (tree == -1)
        return ErrorMsg(playerid, "Ne nalazite se u blizini jelke.");

    if (XmasTrees[tree][XMAS_GIFT_OPENED])
        return ErrorMsg(playerid, "Neko je vec otvorio ovaj paketic pre tebe, pokusaj da pronadjes drugu jelku.");

    if (XmasTrees[tree][XMAS_GIFT_TYPE] == XMAS_GIFT_NONE)
        return ErrorMsg(playerid, "Ispod ove jelke nema paketica. Sacekaj nekoliko minuta, uskoro ce stici!");

    // Da li je vec uzeo paketic u ovoj turi?
    new alreadyOpened = false;
    for__loop (new i = 0; i < sizeof XmasTrees; i++)
    {
        if (!strcmp(XmasTrees[i][XMAS_OPENER_NAME], ime_rp[playerid]))
        {
            alreadyOpened = true;
        }
    }
    if (alreadyOpened)
        return ErrorMsg(playerid, "Vec ste otvorili svoj paketic u ovoj turi. Sacekajte sledecu podelu paketica!");


    new gift = XmasTrees[tree][XMAS_GIFT_TYPE],
        giftText[32],
        cash = random(10001);

    // Ako igrac nema ranac a dobije nesto sto ide u ranac, nagrada se prebacuje na novac
    if (!BP_PlayerHasBackpack(playerid) && (gift == XMAS_GIFT_IPOD || gift == XMAS_GIFT_MDMA || gift == XMAS_GIFT_HEROIN))
    {
        XmasTrees[tree][XMAS_GIFT_TYPE] = gift = XMAS_GIFT_MONEY;
    }

    // Ako igrac dobije pasos, a vec ima pasos, nagrada se prebacuje na oruzje
    if (gift == XMAS_GIFT_PASSPORT && PI[playerid][p_pasos_ts] > gettime())
    {
        XmasTrees[tree][XMAS_GIFT_TYPE] = gift = XMAS_GIFT_DEAGLE;
    }

    // Formatiranje naziva poklona
    if (gift == XMAS_GIFT_MONEY)
    {
        format(giftText, sizeof giftText, "Novac (%s)", formatMoneyString(cash));
    }
    else
    {
        format(giftText, sizeof giftText, "%s", XmasGifts[XmasTrees[tree][XMAS_GIFT_TYPE]][XMASGIFT_NAME]);
    }


    // Ispisivanje poruke igracu
    if (gift != XMAS_GIFT_NONE)
    {
        PI[playerid][p_paketici] += 1;

        SendClientMessageF(playerid, 0xDC3D2AFF, "(paketic) {00B32C}Dobili ste {FFFFFF}%s {00B32C}iz novogodisnjeg paketica.", giftText);
        SendClientMessageF(playerid, 0xDC3D2AFF, "* Do sada ste otvorili ukupno {00B32C}%i paketica.", PI[playerid][p_paketici]);
        SendClientMessage(playerid, 0x00B32CFF, "** Zelimo Vam srecne Novogodisnje praznike!");

        new query[55];
        format(query, sizeof query, "UPDATE igraci SET paketici = %i WHERE id = %i", PI[playerid][p_paketici], PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }

    // Dodela poklona
    switch (gift)
    {
        case XMAS_GIFT_NONE:
        {
            return ErrorMsg(playerid, GRESKA_NEPOZNATO);
        }

        case XMAS_GIFT_FAGGIO:
        {
            for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
                if (pVehicles[playerid][i] == 0) 
                    SetPVarInt(playerid, "pAutosalonSlot", i);
            }

            if (GetPVarInt(playerid, "pAutosalonSlot") == -1)
                return ErrorMsg(playerid, "Nemate slobodne slotove za nova vozila.");

            SetPVarInt(playerid, "pAutosalonCat", motor);
            mysql_tquery(SQL, "SELECT (t1.id + 1) as id FROM vozila t1 WHERE NOT EXISTS (SELECT t2.id FROM vozila t2 WHERE t2.id = t1.id + 1) LIMIT 1", "MySQL_GiftVehicle", "iii", playerid, 462, cinc[playerid]);
        }

        case XMAS_GIFT_BMX:
        {
            for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
                if (pVehicles[playerid][i] == 0) 
                    SetPVarInt(playerid, "pAutosalonSlot", i);
            }

            if (GetPVarInt(playerid, "pAutosalonSlot") == -1)
                return ErrorMsg(playerid, "Nemate slobodne slotove za nova vozila.");

            SetPVarInt(playerid, "pAutosalonCat", bicikl);
            mysql_tquery(SQL, "SELECT (t1.id + 1) as id FROM vozila t1 WHERE NOT EXISTS (SELECT t2.id FROM vozila t2 WHERE t2.id = t1.id + 1) LIMIT 1", "MySQL_GiftVehicle", "iii", playerid, 481, cinc[playerid]);
        }

        case XMAS_GIFT_MONEY:
        {
            PlayerMoneyAdd(playerid, cash);
        }

        case XMAS_GIFT_IPOD:
        {
            BP_PlayerItemAdd(playerid, ITEM_IPODNANO);
        }

        case XMAS_GIFT_PASSPORT:
        {
            new h,m,s;
            gettime(h, m, s);
            PI[playerid][p_pasos] = gettime() + 2592000 + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih 30 dana, pa jos do kraja sledeceg dana

            new query[115];
            format(query, sizeof query, "UPDATE igraci SET pasos = FROM_UNIXTIME(%i) WHERE id = %i", PI[playerid][p_pasos], PI[playerid][p_id]);
            mysql_tquery(SQL, query);

            format(query, sizeof query, "SELECT DATE_FORMAT(pasos, '\%%d/\%%m/\%%Y') as pasos1, UNIX_TIMESTAMP(pasos) as pasos_ts FROM igraci WHERE id = %i", PI[playerid][p_id]);
            mysql_tquery(SQL, query, "OnPlayerIssuedPassport", "ii", playerid, cinc[playerid]);
        }

        case XMAS_GIFT_MDMA:
        {
            BP_PlayerItemAdd(playerid, ITEM_MDMA, 5);
        }

        case XMAS_GIFT_HEROIN:
        {
            BP_PlayerItemAdd(playerid, ITEM_HEROIN, 5);
        }

        case XMAS_GIFT_AKTIVNA:
        {
            AKTIGRA_PtsInc(playerid, 1);
            AKTIGRA_Check(playerid);

            AKTIGRA_PtsInc(playerid, 1);
            AKTIGRA_Check(playerid);
        }

        case XMAS_GIFT_ARMOUR:
        {
            SetPlayerArmour(playerid, 100.0);
        }

        case XMAS_GIFT_DEAGLE:
        {
            GivePlayerWeapon(playerid, WEAPON_DEAGLE, 150);
        }

        case XMAS_GIFT_M4:
        {
            GivePlayerWeapon(playerid, WEAPON_M4, 200);
        }

        case XMAS_GIFT_MP5:
        {
            GivePlayerWeapon(playerid, WEAPON_MP5, 250);
        }

        case XMAS_GIFT_TOKEN:
        {
            PI[playerid][p_token] += 1;

            new query[256];
            format(query, sizeof query, "UPDATE igraci SET gold = %i WHERE id = %i", PI[playerid][p_token], PI[playerid][p_id]);
            mysql_tquery(SQL, query);
        }
    }

    XmasTrees[tree][XMAS_GIFT_OPENED] = true;
    format(XmasTrees[tree][XMAS_OPENER_NAME], MAX_PLAYER_NAME, "%s", ime_rp[playerid]);

    new labelStr[180];
    format(labelStr, sizeof labelStr, "{DC3D2A}[ {00B32C}NOVOGODISNJA JELKA (%i) {DC3D2A}]\n\nPaketic je vec otvorio {F3F3F3}%s\n{DC3D2A}Poklon: %s", tree, ime_rp[playerid], XmasGifts[XmasTrees[tree][XMAS_GIFT_TYPE]][XMASGIFT_NAME]);
    UpdateDynamic3DTextLabelText(XmasTrees[tree][XMAS_TEXT3D], 0xFFFFFFFF, labelStr);
    return 1;
}

CMD:izmenipaketic(playerid, const params[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new id;
    if (sscanf(params, "i", id))
        return Koristite(playerid, "izmenipaketic [ID jelke]");

    if (id < 0 || id >= sizeof XmasTrees)
        return ErrorMsg(playerid, "Nevazeci ID.");

    SetPVarInt(playerid, "pXmasEdit", id);
    new string[512];
    format(string, sizeof(string), "ID\tNaziv");
    for__loop (new i = 0; i < sizeof XmasGifts; i++)
    {
        format(string, sizeof string, "%s\n%i\t%s", string, XmasGifts[i][XMASGIFT_ID], XmasGifts[i][XMASGIFT_NAME]);
    }
    SPD(playerid, "izmenipaketic", DIALOG_STYLE_TABLIST_HEADERS, "Odaberi poklon", string, "Izmeni", "Odustani");
    return 1;
}

CMD:xmasdrop(playerid, const params[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    KillTimer(tajmer:XmasDrop);
    XmasGiftsDrop();
    tajmer:XmasDrop = SetTimer("XmasGiftsDrop", 60*60*1000 - 5*60*1000 + random(700)*1000, true);
    return 1;
}

CMD:nagradnaigra(playerid, const params[])
{
    // new string[600];
    // format(string, sizeof string, "{DC3D2A}HO  {FFFFFF}HO  {DC3D2A}HO    {FFFFFF}***    Velika Novogodisnja nagradna igra!\n\n{FFFFFF}- Svakih {00B32C}60 minuta {FFFFFF}Deda Mraz isporucuje nove paketice ispod svih jelki u gradu!\n- Igraci koji otvore najvise paketica do {00B32C}01/01/2020 {FFFFFF}osvajaju vredne nagrade!\n- Moguce je otvoriti najvise 1 paketic po isporuci\n\n{00B32C}SPISAK NAGRADA:\n{FFFFFF}1. mesto: {DC3D2A}Velika kuca po izboru + mapa\n{FFFFFF}2. mesto: {DC3D2A}Automobil po izboru do $1.200.000\n{FFFFFF}3. mesto: {DC3D2A}$300.000\n\n\n{00B32C}Vi ste do sada otvorili {DC3D2A}%i paketica.", PI[playerid][p_paketici]);

    // SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Novogodisnja nagradna igra", string, "OK", "");
    InfoMsg(playerid, "Nagradna igra je zavrsena. Spisak pobednika mozete videti na forumu.");
    return 1;
}