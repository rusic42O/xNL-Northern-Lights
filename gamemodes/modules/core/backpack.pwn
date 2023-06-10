#include <YSI_Coding\y_hooks>

// TODO: Omoguciti kupovinu ranca u prodavnici/tech storu
// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
// Ne menjati ID-eve
// Pri izmeni predmeta, obavezno izmeniti ITEM_MIN_ID / ITEM_MAX_ID, BP_GetItemName
//  i OnGameModeInit, i dodati pod E_PLAYER_BACKPACK[][]

// !!! Ne menjati ID-eve vec postojecih predmeta!!!

// ID-ovi supstanci za drogu su hard-kodovane vrednosti u drugs.pwn; pri dodavanju 
// novih supstanci, obavezno je povecati MAX ID definiciju u tom fajlu


#define ITEM_RANAC          50
#define ITEM_CIGARETE       51
#define ITEM_UPALJAC        52
#define ITEM_PIZZA          53
#define ITEM_SRAFCIGER      54
#define ITEM_UZE            55
#define ITEM_ALAT           56
#define ITEM_SNALICA        57
#define ITEM_IMENIK         58
#define ITEM_SAFROL         59
#define ITEM_BROMOPROPAN    60
#define ITEM_METILAMIN      61
#define ITEM_MORFIN         62
#define ITEM_ACETANHIDRID   63
#define ITEM_HLOROFORM      64
#define ITEM_DEMIVODA       65
#define ITEM_ALKOHOL        66
#define ITEM_ADRENALIN      67
#define ITEM_MDMA           68
#define ITEM_HEROIN         69
#define ITEM_PAINKILLERS    70
#define ITEM_IPODNANO       71
#define ITEM_IPODCLASSIC    72
#define ITEM_KANISTER       73
#define ITEM_HELMET         74
#define ITEM_MATERIALS      75
#define ITEM_RAW_MATS       76
#define ITEM_CROWBAR        77
#define ITEM_EXPLOSIVE      78
#define ITEM_DETONATOR      79
#define ITEM_WEED_RAW       80
#define ITEM_WEED_UNCURED   81
#define ITEM_WEED           82
#define ITEM_SEED           83
#define ITEM_APPLE          84
#define ITEM_PEAR           85
#define ITEM_PLUM           86
#define ITEM_APPLE_SEED     87
#define ITEM_PEAR_SEED      88
#define ITEM_PLUM_SEED      89
#define ITEM_DRILL          90

#define ITEM_MIN_ID         (50)
#define ITEM_MAX_ID         (90)

#define BP_MAX_WEAPONS      2 // Koliko se najvise oruzja moze staviti u ranac
#define BP_CHAT_COLOR       0xFF5900FF




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_PLAYER_BACKPACK
{
    BP_WEAPON[BP_MAX_WEAPONS],
    BP_AMMO[BP_MAX_WEAPONS],

    BP_ITEM_RANAC        = ITEM_RANAC,
    BP_ITEM_CIGARETE     = ITEM_CIGARETE,
    BP_ITEM_UPALJAC      = ITEM_UPALJAC,
    BP_ITEM_PIZZA        = ITEM_PIZZA,
    BP_ITEM_SRAFCIGER    = ITEM_SRAFCIGER,
    BP_ITEM_UZE          = ITEM_UZE,
    BP_ITEM_ALAT         = ITEM_ALAT,
    BP_ITEM_SNALICA      = ITEM_SNALICA,
    BP_ITEM_IMENIK       = ITEM_IMENIK,
    BP_ITEM_BROMOPROPAN  = ITEM_BROMOPROPAN,   
    BP_ITEM_METILAMIN    = ITEM_METILAMIN,
    BP_ITEM_MORFIN       = ITEM_MORFIN, 
    BP_ITEM_ACETANHIDRID = ITEM_ACETANHIDRID, 
    BP_ITEM_HLOROFORM    = ITEM_HLOROFORM, 
    BP_ITEM_DEMIVODA     = ITEM_DEMIVODA, 
    BP_ITEM_ADRENALIN    = ITEM_ADRENALIN, 
    BP_ITEM_ALKOHOL      = ITEM_ALKOHOL, 
    BP_ITEM_MDMA         = ITEM_MDMA,
    BP_ITEM_HEROIN       = ITEM_HEROIN,
    BP_ITEM_PAINKILLERS  = ITEM_PAINKILLERS,
    BP_ITEM_IPODNANO     = ITEM_IPODNANO,
    BP_ITEM_IPODCLASSIC  = ITEM_IPODCLASSIC,
    BP_ITEM_KANISTER     = ITEM_KANISTER,
    BP_ITEM_HELMET       = ITEM_HELMET,
    BP_ITEM_MATERIALS    = ITEM_MATERIALS,
    BP_ITEM_RAW_MATS     = ITEM_RAW_MATS,
    BP_ITEM_CROWBAR      = ITEM_CROWBAR,
    BP_ITEM_EXPLOSIVE    = ITEM_EXPLOSIVE,
    BP_ITEM_DETONATOR    = ITEM_DETONATOR,
    BP_ITEM_WEED_RAW     = ITEM_WEED_RAW,
    BP_ITEM_WEED_UNCURED = ITEM_WEED_UNCURED,
    BP_ITEM_WEED         = ITEM_WEED,
    BP_ITEM_SEED         = ITEM_SEED,
    BP_ITEM_APPLE        = ITEM_APPLE,
    BP_ITEM_PEAR         = ITEM_PEAR,
    BP_ITEM_PLUM         = ITEM_PLUM,
    BP_ITEM_APPLE_SEED   = ITEM_APPLE_SEED,
    BP_ITEM_PEAR_SEED    = ITEM_PEAR_SEED,
    BP_ITEM_PLUM_SEED    = ITEM_PLUM_SEED,
    BP_ITEM_DRILL        = ITEM_DRILL,

}
new P_BACKPACK[MAX_PLAYERS][E_PLAYER_BACKPACK];




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    BP_itemCountLimits[ITEM_MAX_ID - ITEM_MIN_ID + 1],
    BP_oruzje_slot[MAX_PLAYERS],
    BP_managingItemID[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    BP_SetItemCountLimit(ITEM_RANAC,        1);
    BP_SetItemCountLimit(ITEM_CIGARETE,     20); // 4 paklice po 5 cigareta
    BP_SetItemCountLimit(ITEM_UPALJAC,      12); // 3 upaljaca po 4 paljenja cigareta 
    BP_SetItemCountLimit(ITEM_PIZZA,        4);
    BP_SetItemCountLimit(ITEM_SRAFCIGER,    3);
    BP_SetItemCountLimit(ITEM_UZE,          5);
    BP_SetItemCountLimit(ITEM_ALAT,         3);
    BP_SetItemCountLimit(ITEM_SNALICA,      10);
    BP_SetItemCountLimit(ITEM_IMENIK,       1);
    BP_SetItemCountLimit(ITEM_SAFROL,       200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_BROMOPROPAN,  200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_METILAMIN,    200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_MORFIN,       200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_ACETANHIDRID, 200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_HLOROFORM,    200); // 200g (20x10g)
    BP_SetItemCountLimit(ITEM_DEMIVODA,     2000); // 2000ml (4x500ml)
    BP_SetItemCountLimit(ITEM_ADRENALIN,    10); // 10mg (10x1mg)
    BP_SetItemCountLimit(ITEM_ALKOHOL,      1000); // 1000ml (5x200ml)
    BP_SetItemCountLimit(ITEM_MDMA,         200);
    BP_SetItemCountLimit(ITEM_HEROIN,       200);
    BP_SetItemCountLimit(ITEM_PAINKILLERS,  6); // 6 tableta
    BP_SetItemCountLimit(ITEM_IPODNANO,     1);
    BP_SetItemCountLimit(ITEM_IPODCLASSIC,  1);
    BP_SetItemCountLimit(ITEM_KANISTER,     3);
    BP_SetItemCountLimit(ITEM_HELMET,       1);
    BP_SetItemCountLimit(ITEM_MATERIALS,    65000);
    BP_SetItemCountLimit(ITEM_RAW_MATS,     1);
    BP_SetItemCountLimit(ITEM_CROWBAR,      5);
    BP_SetItemCountLimit(ITEM_EXPLOSIVE,    20);
    BP_SetItemCountLimit(ITEM_DETONATOR,    5);
    BP_SetItemCountLimit(ITEM_WEED_RAW,     1500);
    BP_SetItemCountLimit(ITEM_WEED_UNCURED, 150);
    BP_SetItemCountLimit(ITEM_WEED,         300);
    BP_SetItemCountLimit(ITEM_SEED,         6);
    BP_SetItemCountLimit(ITEM_APPLE,        100);
    BP_SetItemCountLimit(ITEM_PEAR,         100);
    BP_SetItemCountLimit(ITEM_PLUM,         100);
    BP_SetItemCountLimit(ITEM_APPLE_SEED,   100);
    BP_SetItemCountLimit(ITEM_PEAR_SEED,    100);
    BP_SetItemCountLimit(ITEM_PLUM_SEED,    100);
    BP_SetItemCountLimit(ITEM_DRILL,        1);
    return true;
}

hook OnPlayerConnect(playerid)
{
    P_BACKPACK[playerid][BP_ITEM_RANAC] = 0;

    for__loop (new itemid = ITEM_MIN_ID; itemid <= ITEM_MAX_ID; itemid++)
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] = 0;
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
stock IsItemDrug(itemid)
{
    if (itemid == ITEM_MDMA || itemid == ITEM_HEROIN)
        return true;
    else
        return false;
}

stock LoadPlayerBackpack(playerid)
{
    new query[56];
    format(query, sizeof query, "SELECT item, quantity FROM backpacks WHERE pid = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, query, "MYSQL_LoadPlayerBackpack", "ii", playerid, cinc[playerid]);
}

stock BP_SetItemCountLimit(itemid, limit)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID)
    {
        BP_itemCountLimits[itemid - ITEM_MIN_ID] = limit;
    }
}

stock BP_GetItemCountLimit(itemid)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID)
    {
        return BP_itemCountLimits[itemid - ITEM_MIN_ID];
    }
    return 0;
}

stock BP_GetItemName(itemid, szDest[], len)
{
    if (itemid < ITEM_MIN_ID || itemid > ITEM_MAX_ID)
    {
        format(szDest, len, "[greska]");
    }
    else
    {
        switch (itemid)
        {
            case ITEM_RANAC:        format(szDest, len, "Ranac");
            case ITEM_CIGARETE:     format(szDest, len, "Cigarete");   
            case ITEM_UPALJAC:      format(szDest, len, "Upaljac");    
            case ITEM_PIZZA:        format(szDest, len, "Pizza");      
            case ITEM_SRAFCIGER:    format(szDest, len, "Srafciger");   
            case ITEM_UZE:          format(szDest, len, "Uze");        
            case ITEM_ALAT:         format(szDest, len, "Alat za popravku");       
            case ITEM_SNALICA:      format(szDest, len, "Snalica");    
            case ITEM_IMENIK:       format(szDest, len, "Telefonki imenik");     
            case ITEM_SAFROL:       format(szDest, len, "Safrol");
            case ITEM_BROMOPROPAN:  format(szDest, len, "Bromopropan");
            case ITEM_METILAMIN:    format(szDest, len, "Metilamin");
            case ITEM_MORFIN:       format(szDest, len, "Morfin");
            case ITEM_ACETANHIDRID: format(szDest, len, "Acetanhidrid");
            case ITEM_HLOROFORM:    format(szDest, len, "Hloroform");
            case ITEM_DEMIVODA:     format(szDest, len, "Destilovana voda");
            case ITEM_ALKOHOL:      format(szDest, len, "Alkohol");
            case ITEM_ADRENALIN:    format(szDest, len, "Adrenalin");
            case ITEM_MDMA:         format(szDest, len, "MDMA");
            case ITEM_HEROIN:       format(szDest, len, "Heroin");
            case ITEM_PAINKILLERS:  format(szDest, len, "Pain killers");
            case ITEM_IPODNANO:     format(szDest, len, "iPod Nano");
            case ITEM_IPODCLASSIC:  format(szDest, len, "iPod Classic");
            case ITEM_KANISTER:     format(szDest, len, "Kanister");
            case ITEM_HELMET:       format(szDest, len, "Kaciga");
            case ITEM_MATERIALS:    format(szDest, len, "Materijali");
            case ITEM_RAW_MATS:     format(szDest, len, "Neobradjeni materijali");
            case ITEM_CROWBAR:      format(szDest, len, "Pajser");
            case ITEM_EXPLOSIVE:    format(szDest, len, "Eksploziv");
            case ITEM_DETONATOR:    format(szDest, len, "Detonator");
            case ITEM_WEED_RAW:     format(szDest, len, "Sirovi kanabis");
            case ITEM_WEED_UNCURED: format(szDest, len, "Osuseni kanabis");
            case ITEM_WEED:         format(szDest, len, "Marihuana");
            case ITEM_SEED:         format(szDest, len, "Seme");
            case ITEM_APPLE:        format(szDest, len, "Jabuka");
            case ITEM_PEAR:         format(szDest, len, "Kruska");
            case ITEM_PLUM:         format(szDest, len, "Sljiva");
            case ITEM_APPLE_SEED:   format(szDest, len, "Seme jabuke");
            case ITEM_PEAR_SEED:    format(szDest, len, "Seme kruske");
            case ITEM_PLUM_SEED:    format(szDest, len, "Seme sljive");
            case ITEM_DRILL:        format(szDest, len, "Busilica");
            default:                format(szDest, len, "[Greska]");
        }
    }
}

stock BP_PlayerHasBackpack(playerid)
{
    return P_BACKPACK[playerid][BP_ITEM_RANAC];
}

stock BP_PlayerHasItem(playerid, itemid)
{
    if (!BP_PlayerHasBackpack(playerid) || itemid < ITEM_MIN_ID || itemid > ITEM_MAX_ID)
        return 0;

    else 
        return P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid];
}

stock BP_PlayerItemGetCount(playerid, itemid)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID)
    {
        return P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid];
    }
    else return 0;
}

stock BP_PlayerItemAdd(playerid, itemid, addCount = 1)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID && IsPlayerConnected(playerid))
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] += addCount;

        new query[92];
        format(query, sizeof query, "INSERT INTO backpacks VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE quantity = %i", PI[playerid][p_id], itemid, P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid], P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid]);
        mysql_tquery(SQL, query); 
    }
}

stock BP_PlayerItemSub(playerid, itemid, subCount = 1)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID && IsPlayerConnected(playerid))
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] -= subCount;
        if (P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] < 0) P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] = 0;

        new query[92];
        format(query, sizeof query, "INSERT INTO backpacks VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE quantity = %i", PI[playerid][p_id], itemid, P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid], P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid]);
        mysql_tquery(SQL, query); 
    }
}

stock BP_PlayerItemSet(playerid, itemid, setCount)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID && IsPlayerConnected(playerid))
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] = setCount;

        new query[92];
        format(query, sizeof query, "INSERT INTO backpacks VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE quantity = %i", PI[playerid][p_id], itemid, P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid], P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid]);
        mysql_tquery(SQL, query); 
    }
}

stock BP_PlayerItemRemove(playerid, itemid)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID && IsPlayerConnected(playerid))
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] = 0;

        new query[60];
        format(query, sizeof query, "DELETE FROM backpacks WHERE pid = %i AND item = %i", PI[playerid][p_id], itemid);
        mysql_tquery(SQL, query); 
    }
}

stock BP_UseItem(playerid, itemid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("BP_UseItem");
    }

    if (BP_PlayerItemGetCount(playerid, itemid) <= 0)
        return ErrorMsg(playerid, "Nemate dovoljno.");

    switch (itemid)
    {
        case ITEM_PIZZA:
        {
            PlayerHungerDecrease(playerid, 15);
            callcmd::eat(playerid, "");

            new string[64];
            format(string, sizeof string, "** %s jede pizzu.", ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }

        case ITEM_UZE:
        {
            return callcmd::zavezi(playerid, "");
        }

        case ITEM_PAINKILLERS:
        {
            new Float:health, Float:maxhp=99.0;
            GetPlayerHealth(playerid, health);
            // GetPlayerMaxHealth(playerid, maxhp);

            SetPlayerHealth(playerid, ((health+15.0)>maxhp)? maxhp : (health+15.0));

            new string[64];
            format(string, sizeof string, "** %s pije tablete protiv bolova.", ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 15.0);
        }

        case ITEM_ALAT:
        {
            return PC_EmulateCommand(playerid, "/popravi");
        }

        case ITEM_APPLE:
        {
            PlayerHungerDecrease(playerid, 14);
            callcmd::eat(playerid, "");

            new string[64];
            format(string, sizeof string, "** %s jede jabuku.", ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }

        case ITEM_PEAR:
        {
            PlayerHungerDecrease(playerid, 17);
            callcmd::eat(playerid, "");

            new string[64];
            format(string, sizeof string, "** %s jede krusku.", ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }

        case ITEM_PLUM:
        {
            PlayerHungerDecrease(playerid, 12);
            callcmd::eat(playerid, "");

            new string[64];
            format(string, sizeof string, "** %s jede sljivu.", ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }

        default: return ErrorMsg(playerid, "Taj predmet nije moguce koristiti.");
    }

    BP_PlayerItemSub(playerid, itemid);
    return 1;
}

forward MYSQL_LoadPlayerBackpack(playerid, ccinc);
public MYSQL_LoadPlayerBackpack(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MYSQL_LoadPlayerBackpack");
    }

    if (!checkcinc(playerid, ccinc))
        return 1;

    
    // Inicijalizacija oruzja i svega ostalog na nulu
    for__loop (new slot = 0; slot < BP_MAX_WEAPONS; slot++)
    {
        P_BACKPACK[playerid][BP_WEAPON][slot] = -1;
        P_BACKPACK[playerid][BP_AMMO][slot]   = 0;
    }

    for__loop (new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: i] = 0;
    }


    cache_get_row_count(rows);
    if (rows)
    {
        P_BACKPACK[playerid][BP_ITEM_RANAC] = 1;

        new item, quantity;
        for__loop (new i = 0; i < rows; i++)
        {
            cache_get_value_index_int(i, 0, item);
            cache_get_value_index_int(i, 1, quantity);

            if (item < 50)
            {
                // ID predmeta < 50, znaci da je neko oruzje
                for__loop (new slot = 0; slot < BP_MAX_WEAPONS; slot++)
                {
                    if (P_BACKPACK[playerid][BP_WEAPON][slot] == -1)
                    {
                        P_BACKPACK[playerid][BP_WEAPON][slot] = item;
                        P_BACKPACK[playerid][BP_AMMO][slot] = quantity;
                        break;
                    }
                }
            }
            else
            {
                // Nije oruzje, vec neki drugi predmet
                P_BACKPACK[playerid][E_PLAYER_BACKPACK: item] = quantity;
            }
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:backpack(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

    if (!BP_PlayerHasBackpack(playerid))
        return ErrorMsg(playerid, "Ne posedujete ranac. Mozete ga kupiti u bilo kom marketu ili prodavnici tehnike.");

    switch (listitem)
    {
        case 0: // Stvari
        {
            new string[512], sItemName[25];
            format(string, 29, "ID\tNaziv predmeta\tKolicina");
            for__loop (new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
            {
                if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
                    || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

                BP_GetItemName(i, sItemName, sizeof sItemName);

                if (i == ITEM_MATERIALS)
                {
                    format(string, sizeof string, "%s\n%i\t%s\t%.1f kg", string, i, sItemName, BP_PlayerItemGetCount(playerid, i)/100.0);
                }
                else
                {
                    format(string, sizeof string, "%s\n%i\t%s\t%i", string, i, sItemName, BP_PlayerItemGetCount(playerid, i));
                }
            }
            SPD(playerid, "backpack_items", DIALOG_STYLE_TABLIST_HEADERS, "RANAC » STVARI", string, "Dalje >", "< Nazad");
        }

        case 1: // Oruzje
        {
            if (IsPlayerOnLawDuty(playerid))
                return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete uzimati/stavljati oruzje u ranac.");

            if (IsPlayerInWar(playerid))
                return ErrorMsg(playerid, "Ne mozete uzimati/stavljati oruzje u ranac dok ste u waru.");

            if (IsPlayerWorking(playerid))
                return ErrorMsg(playerid, "Ne mozete uzimati/stavljati oruzje u ranac dok ste na poslu.");

            SPD(playerid, "backpack_weapons", DIALOG_STYLE_LIST, "RANAC » ORUZJE", "Uzmi oruzje\nStavi oruzje", "Dalje »", "« Nazad");
        }

        case 2: // Droga
        {
            new string[180];
            format(string, sizeof string, "ID\tVrsta\tKolicina\n{000000}%i\t{FFFFFF}MDMA\t%i gr\n{000000}%i\t{FFFFFF}Heroin\t%i gr\n{000000}%i\t{FFFFFF}Sirovi kanabis\t%i gr\n{000000}%i\t{FFFFFF}Marihuana\t%i gr", ITEM_MDMA, BP_PlayerItemGetCount(playerid, ITEM_MDMA), ITEM_HEROIN, BP_PlayerItemGetCount(playerid, ITEM_HEROIN), ITEM_WEED_RAW, BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW), ITEM_WEED, BP_PlayerItemGetCount(playerid, ITEM_WEED));
            SPD(playerid, "backpack_drugs", DIALOG_STYLE_TABLIST_HEADERS, "RANAC » DROGA", string, "Dalje »", "« Nazad");
        }
    }
    return 1;
}

Dialog:backpack_drugs(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::ranac(playerid, "");

    new naslov[40], sItemName[25];
    BP_managingItemID[playerid] = strval(inputtext);
    BP_GetItemName(BP_managingItemID[playerid], sItemName, sizeof sItemName);

    format(naslov, sizeof naslov, "RANAC » DROGA » %s", (StrToUpper(sItemName), sItemName));
    SPD(playerid, "backpack_drugs_manage", DIALOG_STYLE_LIST, naslov, "Prodaj igracu\nBaci", "Dalje »", "« Nazad");
    return 1;
}

Dialog:backpack_drugs_manage(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 2, "Droga");

    new itemid = BP_managingItemID[playerid],
        sItemName[25];

    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    if (listitem == 0) // Prodaj igracu
    {
        new string[245], naslov[48];
        format(naslov, sizeof naslov, "RANAC » DROGA » %s » PRODAJ", (StrToUpper(sItemName), sItemName));
        format(string, sizeof string, "{FFFFFF}Upisite parametre za prodaju {FF5900}%s {FFFFFF}u sledecem formatu:\n     {FF5900}[Ime ili ID igraca] [Kolicina] [Cena]\n\n{FFFFFF}* Primer: {FF5900}27 3 10000   {FFFFFF}(prodaja igracu 27, 3 grama za $10.000)", (StrToLower(sItemName), sItemName));
        SPD(playerid, "backpack_items_manage_sell1", DIALOG_STYLE_INPUT, naslov, string, "Dalje »", "Odustani");
    }
    else if (listitem == 1) // Baci
    {
        foreach (new i : Player)
    	{
        	if(IsACop(i)) {
				new Float:x,Float:y,Float:z;
				GetPlayerPos(i, x, y, z);
				if(IsPlayerInRangeOfPoint(playerid, 150.0, x, y, z)) {
                    ErrorMsg(playerid, "Ne mozes baciti drogu dok ste u blizini policajca.");
				    break;
                }
            }
    	}
        new string[90], naslov[48];
        format(naslov, sizeof naslov, "RANAC » DROGA » %s » BACI", (StrToUpper(sItemName), sItemName));
        format(string, sizeof string, "{FFFFFF}Da li ste sigurni da zelite da bacite: {FF5900}%ig x %s", BP_PlayerItemGetCount(playerid, itemid), (StrToLower(sItemName), sItemName));
        SPD(playerid, "backpack_drugs_manage_throw", DIALOG_STYLE_MSGBOX, naslov, string, "Baci", "Odustani");
    }
    return 1;
}

Dialog:backpack_items_manage_sell1(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::ranac(playerid, "");

    new itemid = BP_managingItemID[playerid],
        sItemName[25],
        targetid, quantity, price,
        Float:pos[3],
        naslov[40], dialogStr[256];

    if (sscanf(inputtext, "uii", targetid, quantity, price))
    {
        ErrorMsg(playerid, "Uneli ste neispravne parametre. Postujte format: {FFFFFF}[Ime ili ID igraca] [Kolicina] [Ukupna cena]");
        return DialogReopen(playerid);
    }

    if (!IsPlayerConnected(targetid))
    {
        ErrorMsg(playerid, GRESKA_OFFLINE);
        return DialogReopen(playerid);
    }

    if (targetid == playerid)
        return DialogReopen(playerid);

    GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2]))
    {
        ErrorMsg(playerid, "Previse ste daleko od tog igraca.");
        return DialogReopen(playerid);
    }

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    StrToLower(sItemName);


    if (!BP_PlayerHasItem(playerid, itemid))
        return ErrorMsg(playerid, "Nemate %s u rancu.", sItemName);

    if (quantity < 1 || quantity > BP_GetItemCountLimit(itemid))
    {
        ErrorMsg(playerid, "Kolicina mora biti izmedju 1 i %i.", BP_GetItemCountLimit(itemid));
        return DialogReopen(playerid);
    }

    if (price < 0 || price > 500000)
    {
        ErrorMsg(playerid, "Cena mora biti izmedju $0 i $500.000.");
        return DialogReopen(playerid);
    }

    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(targetid, itemid) + quantity))
        return ErrorMsg(playerid, "Taj igrac nema mesta za %s.", sItemName);

    if (BP_PlayerItemGetCount(playerid, itemid) < quantity)
        return ErrorMsg(playerid, "Nemate toliko %s.", sItemName);

    if (floatround(price/(quantity*1.0)) > 7000)
        return ErrorMsg(playerid, "Cena po gramu ne sme da prelazi $7.000. Izabranu kolicinu mozete prodati za max. %s.", formatMoneyString(7000*quantity));

    if (floatround(price/(quantity*1.0)) < 2000 && (PI[targetid][p_provedeno_vreme] < 360000 || PI[playerid][p_provedeno_vreme] < 360000))
    {
        ErrorMsg(playerid, "Cena po gramu ne sme biti manja od $2.000. Izabranu kolicinu mozete prodati za min. %s.", formatMoneyString(2000*quantity));
        SendClientMessage(playerid, BELA, "* Ovo ogranicenje vazi ukoliko neko od vas ima manje od 100 sati igre.");
        return 1;
    }

    new minSec = 40 * 3600;
    if (PI[targetid][p_provedeno_vreme] < minSec)
        return ErrorMsg(playerid, "Taj igrac mora imati najmanje 40 sati igre. Trenutno ima %i sati igre.", floatround(PI[targetid][p_provedeno_vreme]/3600.0));


    SetPVarInt(playerid, "BP_SellOffer_TargetID",   targetid);
    SetPVarInt(playerid, "BP_SellOffer_Quantity",   quantity);
    SetPVarInt(playerid, "BP_SellOffer_Price",      price);
    SetPVarInt(playerid, "BP_SellOffer_ItemID",     itemid);
    SetPVarInt(targetid, "BP_SellOffer_SellerID",   playerid);

    format(naslov, sizeof naslov, "RANAC » %s » PRODAJ", (StrToUpper(sItemName), sItemName));
    format(dialogStr, sizeof dialogStr, "{FFFFFF}Kolicina: {FF5900}%i\n{FFFFFF}Ukupna cena: {FF5900}%s\n\n{FFFFFF}Da li zelite da posaljete ponudu za prodaju {FF5900}%s {FFFFFF}igracu {FF5900}%s[%i]?", quantity, formatMoneyString(price), sItemName, ime_rp[targetid], targetid);
    SPD(playerid, "backpack_items_manage_sell2", DIALOG_STYLE_MSGBOX, naslov, dialogStr, "Ponudi", "Odustani");
    return 1;
}

Dialog:backpack_items_manage_sell2(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 2, "Droga");

    new itemid   = GetPVarInt(playerid, "BP_SellOffer_ItemID"),
        targetid = GetPVarInt(playerid, "BP_SellOffer_TargetID"), 
        quantity = GetPVarInt(playerid, "BP_SellOffer_Quantity"), 
        price    = GetPVarInt(playerid, "BP_SellOffer_Price"),
        Float:pos[3],
        sItemName[25],
        naslov[40], dialogStr[256];



    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2]))
        return ErrorMsg(playerid, "Previse ste daleko od tog igraca.");

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    StrToLower(sItemName);


    if (!BP_PlayerHasItem(playerid, itemid))
        return ErrorMsg(playerid, "Nemate %s u rancu.", sItemName);


    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(targetid, itemid) + quantity))
        return ErrorMsg(playerid, "Taj igrac nema mesta za %s.", sItemName);

    if (BP_PlayerItemGetCount(playerid, itemid) < quantity)
        return ErrorMsg(playerid, "Nemate toliko %s.", sItemName);


    format(naslov, sizeof naslov, "RANAC » %s » PRODAJ", (StrToUpper(sItemName), sItemName));
    format(dialogStr, sizeof dialogStr, "{FF5900}[ %s ]\n{FFFFFF}Kolicina: {FF5900}%i\n{FFFFFF}Ukupna cena: {FF5900}%s\n{FFFFFF}Ponudio: {FF5900}%s[%i]\n\n{FFFFFF}Da li zelite da prihvatite ovu ponudu za kupovinu? Ovo ce Vas kostati {FF5900}%s!", (StrToUpper(sItemName), sItemName), quantity, formatMoneyString(price), ime_rp[targetid], targetid, formatMoneyString(price));
    SPD(targetid, "backpack_items_manage_sell3", DIALOG_STYLE_MSGBOX, naslov, dialogStr, "Prihvati", "Odbij");

    SendClientMessage(playerid, SVETLOPLAVA, "* Ponuda je poslata.");
    return 1;
}

Dialog:backpack_items_manage_sell3(playerid, response, listitem, const inputtext[])
{
    new sellerid = GetPVarInt(playerid, "BP_SellOffer_SellerID");
    if (!response)
    {
        if (IsPlayerConnected(sellerid))
        {
            InfoMsg(sellerid, "%s je odbio Vasu ponudu.", ime_rp[playerid]);
        }
    }
    else
    {
        new itemid   = GetPVarInt(sellerid, "BP_SellOffer_ItemID"),
            quantity = GetPVarInt(sellerid, "BP_SellOffer_Quantity"), 
            price    = GetPVarInt(sellerid, "BP_SellOffer_Price"),
            Float:pos[3],
            sItemName[25];

        if (playerid != GetPVarInt(sellerid, "BP_SellOffer_TargetID") || quantity == 0 || itemid == 0)
            return ErrorMsg(playerid, GRESKA_NEPOZNATO);

        if (!IsPlayerConnected(sellerid))
            return ErrorMsg(playerid, GRESKA_OFFLINE);

        GetPlayerPos(sellerid, pos[0], pos[1], pos[2]);
        if (!IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2]))
            return ErrorMsg(playerid, "Previse ste daleko od tog igraca.");

        BP_GetItemName(itemid, sItemName, sizeof sItemName);
        StrToLower(sItemName);


        if (!BP_PlayerHasItem(sellerid, itemid))
            return ErrorMsg(playerid, "Prodavac nema %s u rancu.", sItemName);

        if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(playerid, itemid) + quantity))
            return ErrorMsg(playerid, "Nemate dovoljno mesta za %s.", sItemName);

        if (BP_PlayerItemGetCount(sellerid, itemid) < quantity)
            return ErrorMsg(playerid, "Igrac nema dovoljno %s u rancu.", sItemName);

        if (price < 0 || price > 99999999)
            return ErrorMsg(playerid, "Nevazeci iznos novca.");

        if (PI[playerid][p_novac] < price)
            return ErrorMsg(playerid, "Nemate dovoljno novca kod sebe.");



        if (IsItemDrug(itemid))
        {        
            new string[120];
            format(string, sizeof string, "** %s vadi vrecicu iz ranca i predaje ju %s.", ime_rp[sellerid], ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }
        else
        {
            new string[120];
            format(string, sizeof string, "** %s vadi %s iz ranca i predaje %s", ime_rp[sellerid], sItemName, ime_rp[playerid]);
            RangeMsg(playerid, string, LJUBICASTA, 20.0);
        }

        BP_PlayerItemSub(sellerid, itemid, quantity);
        BP_PlayerItemAdd(playerid, itemid, quantity);
        PlayerMoneyAdd(sellerid, price);
        PlayerMoneySub(playerid, price);

        new logStr[128];
        format(logStr, sizeof logStr, "%s | %s igracu %s | %i grama za %s", sItemName, ime_obicno[sellerid], ime_obicno[playerid], quantity, formatMoneyString(price));
        Log_Write(LOG_DRUGSTRADE, logStr);
    }

    DeletePVar(playerid, "BP_SellOffer_TargetID");
    DeletePVar(playerid, "BP_SellOffer_Quantity");
    DeletePVar(playerid, "BP_SellOffer_Price");
    DeletePVar(playerid, "BP_SellOffer_ItemID");
    DeletePVar(playerid, "BP_SellOffer_SellerID");
    DeletePVar(sellerid, "BP_SellOffer_TargetID");
    DeletePVar(sellerid, "BP_SellOffer_Quantity");
    DeletePVar(sellerid, "BP_SellOffer_Price");
    DeletePVar(sellerid, "BP_SellOffer_ItemID");
    DeletePVar(sellerid, "BP_SellOffer_SellerID");
    return 1;
}

Dialog:backpack_drugs_manage_throw(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 2, "Droga");

    new itemid = BP_managingItemID[playerid],
        sItemName[25];

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    StrToLower(sItemName);


    if (!BP_PlayerHasItem(playerid, itemid))
        return ErrorMsg(playerid, "Nemate %s u rancu.", sItemName);


    new string[80];
    format(string, sizeof string, "** %s baca %s iz ranca (%ig).", ime_rp[playerid], sItemName, BP_PlayerItemGetCount(playerid, itemid));
    RangeMsg(playerid, string, LJUBICASTA, 20.0);

    BP_PlayerItemRemove(playerid, itemid);
    return 1;
}

Dialog:backpack_items(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::ranac(playerid, "");

    new naslov[40], sItemName[25];
    BP_managingItemID[playerid] = strval(inputtext);
    BP_GetItemName(BP_managingItemID[playerid], sItemName, sizeof sItemName);

    format(naslov, sizeof naslov, "RANAC » STVARI » %s", (StrToUpper(sItemName), sItemName));
    SPD(playerid, "backpack_items_manage", DIALOG_STYLE_LIST, naslov, "Koristi\nDaj igracu\nBaci", "Dalje »", "« Nazad");
    return 1;
}

Dialog:backpack_items_manage(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 0, "Stvari");

    new itemid = BP_managingItemID[playerid],
        sItemName[25];

    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    if (listitem == 0) // Koristi
    {
        BP_UseItem(playerid, itemid);
    }

    else if (listitem == 1) // Daj igracu
    {
        new naslov[48];
        format(naslov, sizeof naslov, "RANAC » STVARI » %s » DAJ", (StrToUpper(sItemName), sItemName));

        // Odlucivanje da li se otvara dialog za davanje *jednog* predmeta, ili dialog za prodaju neke kolicine
        switch (itemid)
        {
            case ITEM_BROMOPROPAN, ITEM_METILAMIN, ITEM_MORFIN, ITEM_ACETANHIDRID, ITEM_HLOROFORM, ITEM_DEMIVODA, ITEM_ALKOHOL, ITEM_MATERIALS, ITEM_RAW_MATS:
            {
                // Dialog za prodaju
                new dStr[256];
                format(dStr, sizeof dStr, "{FFFFFF}Upisite parametre za prodaju {FF5900}%s {FFFFFF}u sledecem formatu:\n     {FF5900}[Ime ili ID igraca] [Kolicina] [Cena]\n\n{FFFFFF}* Primer: {FF5900}27 10 10000   {FFFFFF}(prodaja igracu 27, kolicina 10 za $10.000)", (StrToLower(sItemName), sItemName));
                SPD(playerid, "backpack_items_manage_sell1", DIALOG_STYLE_INPUT, naslov, dStr, "Ponudi", "Odustani");
            }
            default:
            {
                // Sve ostalo - samo davanje
                new dStr[90];
                format(dStr, sizeof dStr, "{FFFFFF}Upisite ime ili ID igraca kome zelite da date: {FF5900}1 x %s", (StrToLower(sItemName), sItemName));
                SPD(playerid, "backpack_imnge_give", DIALOG_STYLE_INPUT, naslov, dStr, "Daj", "Odustani");
            }
        }
    }
    else if (listitem == 2) // Baci
    {
        new string[90], naslov[48];
        format(naslov, sizeof naslov, "RANAC » STVARI » %s » BACI", (StrToUpper(sItemName), sItemName));
        format(string, sizeof string, "{FFFFFF}Da li ste sigurni da zelite da bacite: {FF5900}%i x %s", BP_PlayerItemGetCount(playerid, itemid), (StrToLower(sItemName), sItemName));
        SPD(playerid, "backpack_items_manage_throw", DIALOG_STYLE_MSGBOX, naslov, string, "Baci", "Odustani");
    }
    return 1;
}

Dialog:backpack_imnge_give(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 0, "Stvari");

    new itemid = BP_managingItemID[playerid],
        sItemName[25],
        targetid,
        Float:pos[3];

    if (sscanf(inputtext, "u", targetid))
        return DialogReopen(playerid);

    if (!IsPlayerConnected(targetid))
    {
        ErrorMsg(playerid, GRESKA_OFFLINE);
        return DialogReopen(playerid);
    }

    if (targetid == playerid)
        return DialogReopen(playerid);

    GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, pos[0], pos[1], pos[2]))
    {
        ErrorMsg(playerid, "Previse ste daleko od tog igraca.");
        return DialogReopen(playerid);
    }

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    StrToLower(sItemName);


    if (!BP_PlayerHasItem(playerid, itemid))
        return ErrorMsg(playerid, "Nemate %s u rancu.", sItemName);

    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(targetid, itemid) + 1))
        return ErrorMsg(playerid, "Taj igrac nema mesta za %s.", sItemName);


    new string[120];
    format(string, sizeof string, "** %s vadi %s iz ranca i predaje %s (1 kom).", ime_rp[playerid], sItemName, ime_rp[targetid]);
    RangeMsg(playerid, string, LJUBICASTA, 20.0);

    BP_PlayerItemSub(playerid, itemid);
    BP_PlayerItemAdd(targetid, itemid);
    return 1;
}

Dialog:backpack_items_manage_throw(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 0, "Stvari");

    new itemid = BP_managingItemID[playerid],
        sItemName[25];

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    StrToLower(sItemName);


    if (!BP_PlayerHasItem(playerid, itemid))
        return ErrorMsg(playerid, "Nemate %s u rancu.", sItemName);


    new string[80];
    format(string, sizeof string, "** %s baca %s iz ranca (%i kom).", ime_rp[playerid], sItemName, BP_PlayerItemGetCount(playerid, itemid));
    RangeMsg(playerid, string, LJUBICASTA, 20.0);

    BP_PlayerItemRemove(playerid, itemid);
    return 1;
}

Dialog:backpack_weapons(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::ranac(playerid, "");

    new string[200], weapon[22];
    format(string, 23, "Slot\tOruzje\tMunicija");
    if (listitem == 0) // Uzmi oruzje
    {
        for__loop (new i = 0; i < BP_MAX_WEAPONS; i++) 
        {
            if (P_BACKPACK[playerid][BP_WEAPON][i] == -1 || P_BACKPACK[playerid][BP_AMMO][i] <= 0) continue;

            GetWeaponName(P_BACKPACK[playerid][BP_WEAPON][i], weapon, sizeof(weapon));
            format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, P_BACKPACK[playerid][BP_AMMO][i]);
        }

        SPD(playerid, "backpack_weapons_take", DIALOG_STYLE_TABLIST_HEADERS, "RANAC » ORUZJE » UZMI", string, "Uzmi", "« Nazad");
    }
    else if (listitem == 1) // Stavi oruzje
    {
        if (IsPlayerOnLawDuty(playerid))
            return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInDMEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInHorrorEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInLMSEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u LMS Event-u i ne mozete nista ostaviti u ranac.");

        new weaponid, ammo;
        for__loop (new i = 0; i < 13; i++) 
        {
            weaponid    = GetPlayerWeaponInSlot(playerid, i);
            ammo        = GetPlayerAmmoInSlot(playerid, i);
            if (weaponid <= 0 || ammo <= 0) continue;

            GetWeaponName(weaponid, weapon, sizeof(weapon));
            format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, ammo);
        }
        SPD(playerid, "backpack_weapons_put", DIALOG_STYLE_TABLIST_HEADERS, "RANAC » ORUZJE » STAVI", string, "Stavi", "« Nazad");
    }
    return 1;
}

Dialog:backpack_weapons_take(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 1, "Oruzje"); // Vraca na dijalog uzmi/stavi oruzje

    new
        slot = strval(inputtext),
        weaponid,
        ammo,
        weapon[22];

    if (slot < 0 || slot >= BP_MAX_WEAPONS)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = P_BACKPACK[playerid][BP_WEAPON][slot];
    ammo     = P_BACKPACK[playerid][BP_AMMO][slot];

    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    BP_oruzje_slot[playerid] = slot;
    format(string_256, 160, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da uzmete:", weapon, ammo);
    SPD(playerid, "backpack_weapons_take_conf", DIALOG_STYLE_INPUT, "RANAC » ORUZJE » UZMI", string_256, "Uzmi", "« Nazad");

    return 1;
}

Dialog:backpack_weapons_take_conf(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack_weapons(playerid, 1, 0, "Uzmi oruzje"); // Vraca na dijalog sa spiskom oruzja u rancu

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) 
    {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
        return DialogReopen(playerid);
    }

    new
        slot = BP_oruzje_slot[playerid],
        weaponid,
        ammo,
        weapon[22],
        wSlot;

    if (slot < 0 || slot >= BP_MAX_WEAPONS)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = P_BACKPACK[playerid][BP_WEAPON][slot];
    ammo     = P_BACKPACK[playerid][BP_AMMO][slot];

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nema toliko municije za ovo oruzje u rancu.");
        return DialogReopen(playerid);
    }

    wSlot = GetSlotForWeapon(weaponid);
    if (GetPlayerWeaponInSlot(playerid, wSlot) != weaponid)
        GivePlayerWeapon(playerid, weaponid, 0);
    
    SetPlayerAmmo(playerid, weaponid, GetPlayerAmmoInSlot(playerid, wSlot)+input);
    P_BACKPACK[playerid][BP_AMMO][slot] -= input;

    // Update podataka u bazi
    if (P_BACKPACK[playerid][BP_AMMO][slot] <= 0) 
    { 
        // Igrac je uzeo svu municiju, izbrisati oruzje iz ranca
        P_BACKPACK[playerid][BP_WEAPON][slot] = -1;

        format(mysql_upit, 78, "DELETE FROM backpacks WHERE pid = %d AND item = %d", PI[playerid][p_id], weaponid);
        mysql_tquery(SQL, mysql_upit);
    }
    else 
    {
        // Nije uzeo sve, samo uraditi update municije
        format(mysql_upit, 72, "UPDATE backpacks SET quantity = %d WHERE pid = %d AND item = %d", P_BACKPACK[playerid][BP_AMMO][slot], PI[playerid][p_id], P_BACKPACK[playerid][BP_WEAPON][slot]);
        mysql_tquery(SQL, mysql_upit);
    }

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, BP_CHAT_COLOR, "(ranac) {FFFFFF}Uzeli ste {FF5900}%s {FFFFFF}i {FF5900}%d metaka {FFFFFF}iz ranca.", weapon, input);
    SendClientMessageF(playerid, BELA, "* U rancu je ostalo jos {FF5900}%d metaka {FFFFFF}za ovo oruzje.", P_BACKPACK[playerid][BP_AMMO][slot]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "UZIMANJE | %s | %s | Uzeo %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_BACKPACK, string_128);

    return dialog_respond:backpack(playerid, 1, 1, "Oruzje"); // Vraca na dijalog uzmi/stavi oruzje
}

Dialog:backpack_weapons_put(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack(playerid, 1, 1, "Oruzje"); // Vraca na dijalog uzmi/stavi oruzje

    new
        slot        = strval(inputtext),
        weaponid    = GetPlayerWeaponInSlot(playerid, slot),
        ammo        = GetPlayerAmmoInSlot(playerid, slot),
        weapon[22];

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    BP_oruzje_slot[playerid] = slot;
    format(string_256, 160, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da stavite:", weapon, ammo);
    SPD(playerid, "backpack_weapons_put_confirm", DIALOG_STYLE_INPUT, "RANAC » ORUZJE » STAVI", string_256, "Stavi", "Nazad");
    return 1;
}

Dialog:backpack_weapons_put_confirm(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:backpack_weapons(playerid, 1, 1, "Stavi oruzje"); // Vraca na dijalog sa spiskom oruzja u rukama

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 10000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 10000.");
        return DialogReopen(playerid);
    }

    new
        slot = BP_oruzje_slot[playerid],
        weapon[22],
        weaponid,
        ammo;

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = GetPlayerWeaponInSlot(playerid, slot);
    ammo     = GetPlayerAmmoInSlot(playerid, slot);

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nemate toliko municije za ovo oruzje kod sebe.");
        return DialogReopen(playerid);
    }


    // Trazimo slot sa istim ovim oruzjem
    new bpSlot = -1;
    for__loop (new i = 0; i < BP_MAX_WEAPONS; i++)
    {
        if (P_BACKPACK[playerid][BP_WEAPON][i] == weaponid) 
        {
            bpSlot = i;

            if ((P_BACKPACK[playerid][BP_AMMO][i] + input) > 10000)
            {
                ErrorMsg(playerid, "Mozete ubaciti najvise 10000 metaka u ranac. Vec ih imate %d za ovaj slot.", P_BACKPACK[playerid][BP_AMMO][i]);
                return DialogReopen(playerid);
            }

            P_BACKPACK[playerid][BP_WEAPON][i] = weaponid;
            P_BACKPACK[playerid][BP_AMMO][i]  += input;
            break;
        }
    }

    // Ako nema ovog oruzja u rancu, onda trazimo slobodan slot
    if (bpSlot == -1)
    {
        for__loop (new i = 0; i < BP_MAX_WEAPONS; i++)
        {
            if (P_BACKPACK[playerid][BP_WEAPON][i] == -1) 
            {
                bpSlot = i;

                P_BACKPACK[playerid][BP_WEAPON][i] = weaponid;
                P_BACKPACK[playerid][BP_AMMO][i]   = input;
                break;
            }
        }
    }

    if (bpSlot == -1)
        return ErrorMsg(playerid, "Nemate vise mesta za oruzje u rancu.");


    format(mysql_upit, sizeof mysql_upit, "INSERT INTO backpacks VALUES (%i, %i, %i) ON DUPLICATE KEY UPDATE quantity = %i", PI[playerid][p_id], weaponid, input, P_BACKPACK[playerid][BP_AMMO][bpSlot]);
    mysql_tquery(SQL, mysql_upit);

    if(weaponid == 334 || weaponid == 371)
        SetPlayerAmmo(playerid, weaponid, -1);
    else
        SetPlayerAmmo(playerid, weaponid, ammo-input);

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, BP_CHAT_COLOR, "(ranac) {FFFFFF}Stavili ste {FF5900}%s {FFFFFF}i {FF5900}%d metaka {FFFFFF}u ranac.", weapon, input);
    SendClientMessageF(playerid, BELA, "* U rancu sada imate {FF5900}%d metaka {FFFFFF}za ovo oruzje.", P_BACKPACK[playerid][BP_AMMO][bpSlot]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "STAVLJANJE | %s | %s | Stavio %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_BACKPACK, string_128);

    return dialog_respond:backpack(playerid, 1, 1, "Oruzje"); // Vraca na dijalog uzmi/stavi oruzje
}

Dialog:itemids(playerid, response, listitem, const inputtext[])
{
    new itemid = strval(inputtext);
    if (itemid < ITEM_MIN_ID || itemid > ITEM_MAX_ID)
        return 1;

    new sItemName[25];
    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    SendClientMessageF(playerid, GRAD2, "ID %i | %s", itemid, sItemName);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:ranac(playerid, const params[])
{
    if(IsPlayerInDMArena(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac dok ste u DM areni.");
        
    if (!BP_PlayerHasBackpack(playerid))
        return ErrorMsg(playerid, "Ne posedujete ranac. Mozete ga kupiti u bilo kom marketu ili prodavnici tehnike.");

    if (IsPlayerJailed(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac kada ste u zatvoru.");

    if (IsPlayerInDMEvent(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac na DM Event-u.");

    if (IsPlayerInHorrorEvent(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac na Horor Event-u.");

    if (IsPlayerInLMSEvent(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac na LMS Event-u.");

    if (IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac na trci.");

    BP_managingItemID[playerid] = -1;

    SPD(playerid, "backpack", DIALOG_STYLE_LIST, "RANAC", "Stvari\nOruzje\nDroga", "Dalje »", "Izadji");
    return 1;
}

flags:setitem(FLAG_ADMIN_6)
CMD:setitem(playerid, const params[])
{
    if (!IsAdmin(playerid, 6)) 
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new id, itemid, count;
    if (sscanf(params, "uii", id, itemid, count)) 
        return Koristite(playerid, "setitem [Ime ili ID igraca] [ID predmeta] [Kolicina]"), SendClientMessage(playerid, GRAD2, "/itemids za pregled ID-eva.");

    if (!IsPlayerConnected(playerid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (itemid < ITEM_MIN_ID || itemid > ITEM_MAX_ID)
        return ErrorMsg(playerid, "ID proizvoda mora biti izmedju %i i %i.", ITEM_MIN_ID, ITEM_MAX_ID);

    if (count < 0)
        return ErrorMsg(playerid, "Kolicina ne sme biti negativna.");

    if (count > BP_GetItemCountLimit(itemid))
        return ErrorMsg(playerid, "Kolicina moze biti najvise %i.", BP_GetItemCountLimit(itemid));


    BP_PlayerItemSet(id, itemid, count);

    new sItemName[25];
    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s predmet %s na kolicinu: %i.", ime_rp[id], sItemName, count);
    SendClientMessageF(id, SVETLOPLAVA, "* %s Vam je postavio predmet %s na kolicinu: %i.", ime_rp[playerid], sItemName, count);
    return 1;
}

flags:itemids(FLAG_ADMIN_6)
CMD:itemids(playerid, const params[])
{
    new dStr[(ITEM_MAX_ID - ITEM_MIN_ID) * 20];
    format(dStr, sizeof dStr, "ID\tNaziv");

    for__loop (new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        new sItemName[25];
        BP_GetItemName(i, sItemName, sizeof sItemName);
        format(dStr, sizeof dStr, "%s\n%i\t%s", dStr, i, sItemName);
    }

    SPD(playerid, "itemids", DIALOG_STYLE_TABLIST_HEADERS, "Lista predmeta", dStr, "U redu", "");
    return 1;
}
