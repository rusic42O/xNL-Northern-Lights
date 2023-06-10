#include <YSI_Coding\y_hooks>

// Ne menjati ID-eve
// Pri izmeni predmeta, obavezno izmeniti ITEM_MIN_ID / ITEM_MAX_ID, BP_GetItemName
//  i OnGameModeInit, i dodati pod E_PLAYER_BACKPACK[][]

// ID-ovi supstanci za drogu su hard-kodovane vrednosti u drugs.pwn; pri dodavanju 
// novih supstanci, obavezno je povecati MAX ID definiciju u tom fajlu

DEFINE_HOOK_REPLACEMENT(OnPlayerClick, OPC_);

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

// textdraws;
enum E_INVENTORY_ITEMS
{
    Float:TD_X,
    Float:TD_Y
}

new
    Text:MainInv[156],
    PlayerText:ItemInv[MAX_PLAYERS][48],
    PlayerText:PutGun[MAX_PLAYERS][3],
    bool:InBP[MAX_PLAYERS]
;

new
    ItemTDInfo[][E_INVENTORY_ITEMS] = {
        {0.0000, 0.0000},
        //
        {50.416675, 109.370361},
        {59.566680, 107.037040},
        //
        {103.433364, 109.370361},
        {112.583358, 107.037040},
        //
        {156.350067, 109.370353},
        {165.500061, 107.037033},
        //
        {210.400070, 109.370376},
        {219.550064, 107.037055},
        //
        {264.450195, 109.370353},
        {273.600128, 107.037033},
        //
        {318.433380, 109.370376},
        {327.583374, 107.037055},
        //
        {50.333358, 169.818481},
        {59.483364, 167.485153},
        //
        {103.350021, 169.818481},
        {112.500015, 167.485153},
        //
        {156.266738, 169.818466},
        {165.416732, 167.485153},
        //
        {210.316741, 169.818496},
        {219.466735, 167.485168},
        //
        {264.366760, 169.818466},
        {273.516693, 167.485153},
        //
        {318.349945, 169.818496},
        {327.499938, 167.485168},
        //
        {50.750026, 230.885162},
        {59.900032, 228.551834},
        //
        {103.766685, 230.885162},
        {112.916679, 228.551834},
        //
        {156.683410, 230.885147},
        {165.833404, 228.551834},
        //
        {210.733413, 230.885177},
        {219.883407, 228.551849},
        //
        {264.783416, 230.885147},
        {273.933349, 228.551834},
        //
        {318.766601, 230.885177},
        {327.916595, 228.551849},
        //
        {50.450031, 292.288848},
        {59.600036, 289.955505},
        //
        {103.466690, 292.288848},
        {112.616683, 289.955505},
        //
        {156.383392, 292.288818},
        {165.533386, 289.955505},
        //
        {210.433395, 292.288848},
        {219.583389, 289.955535},
        //
        {264.483398, 292.288818},
        {273.633331, 289.955505},
        //
        {318.466583, 292.288848},
        {327.616577, 289.955535}
    }
;

// enums;
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
    BP_itemModelID[ITEM_MAX_ID - ITEM_MIN_ID + 1],
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

    BP_SetItemModelID(ITEM_RANAC,        -1);
    BP_SetItemModelID(ITEM_CIGARETE,     19897); // 4 paklice po 5 cigareta
    BP_SetItemModelID(ITEM_UPALJAC,      19998); // 3 upaljaca po 4 paljenja cigareta 
    BP_SetItemModelID(ITEM_PIZZA,        19571);
    BP_SetItemModelID(ITEM_SRAFCIGER,    18644);
    BP_SetItemModelID(ITEM_UZE,          19088);
    BP_SetItemModelID(ITEM_ALAT,         19921);
    BP_SetItemModelID(ITEM_SNALICA,      3380);
    BP_SetItemModelID(ITEM_IMENIK,       1742);
    BP_SetItemModelID(ITEM_SAFROL,       19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_BROMOPROPAN,  19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_METILAMIN,    19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_MORFIN,       19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_ACETANHIDRID, 19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_HLOROFORM,    19570); // 200g (20x10g)
    BP_SetItemModelID(ITEM_DEMIVODA,     19570); // 2000ml (4x500ml)
    BP_SetItemModelID(ITEM_ADRENALIN,    19570); // 10mg (10x1mg)
    BP_SetItemModelID(ITEM_ALKOHOL,      19570); // 1000ml (5x200ml)
    BP_SetItemModelID(ITEM_MDMA,         1575);
    BP_SetItemModelID(ITEM_HEROIN,       1580);
    BP_SetItemModelID(ITEM_PAINKILLERS,  19570); // 6 tableta
    BP_SetItemModelID(ITEM_IPODNANO,     19787);
    BP_SetItemModelID(ITEM_IPODCLASSIC,  19787);
    BP_SetItemModelID(ITEM_KANISTER,     1650);
    BP_SetItemModelID(ITEM_HELMET,       18977);
    BP_SetItemModelID(ITEM_MATERIALS,    17051);
    BP_SetItemModelID(ITEM_RAW_MATS,     17051);
    BP_SetItemModelID(ITEM_CROWBAR,      18634);
    BP_SetItemModelID(ITEM_EXPLOSIVE,    1252);
    BP_SetItemModelID(ITEM_DETONATOR,    1654);
    BP_SetItemModelID(ITEM_WEED_RAW,     903);
    BP_SetItemModelID(ITEM_WEED_UNCURED, 903);
    BP_SetItemModelID(ITEM_WEED,         702);
    BP_SetItemModelID(ITEM_SEED,         2214);
    BP_SetItemModelID(ITEM_APPLE,        19575);
    BP_SetItemModelID(ITEM_PEAR,         19576);
    BP_SetItemModelID(ITEM_PLUM,         19574);
    BP_SetItemModelID(ITEM_APPLE_SEED,   19573);
    BP_SetItemModelID(ITEM_PEAR_SEED,    19573);
    BP_SetItemModelID(ITEM_PLUM_SEED,    19573);
    BP_SetItemModelID(ITEM_DRILL,        2750);

    CreateMainInvTD();
    return true;
}

hook OnPlayerConnect(playerid)
{
    InBP[playerid] = false;
    P_BACKPACK[playerid][BP_ITEM_RANAC] = 0;

    for__loop (new itemid = ITEM_MIN_ID; itemid <= ITEM_MAX_ID; itemid++)
    {
        P_BACKPACK[playerid][E_PLAYER_BACKPACK: itemid] = 0;
    }

    for(new i = 0; i < 48; i++)
    {
        if(i < 3)
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if (clickedid == INVALID_TEXT_DRAW)
    {
		if (InBP[playerid])
        {
            for(new i = 0; i < 48; i++)
            {
                if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
                {
                    PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
                    PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
                    ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
                }
                if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
                {
                    PlayerTextDrawHide(playerid, PutGun[playerid][i]);
                    PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
                    PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
                }
            }
            InBP[playerid] = false;
            for(new j = 0; j < sizeof MainInv; j++)
            {
                if(MainInv[j] != INVALID_TEXT_DRAW)
                {
                    TextDrawHideForPlayer(playerid, MainInv[j]);
                }
            }
            CancelSelectTextDraw(playerid);
            ptdInfoBox_Show(playerid);
            ptdInfoBox_UpdateWantedLevel(playerid);
            return 1;
		}
	}
    else if(clickedid == MainInv[144]) // stvari
    {
        for(new i = 0; i < 48; i++)
        {
            if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
                PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
                ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
            if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, PutGun[playerid][i]);
                PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
                PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
        }

        BP_managingItemID[playerid] = -1;

        new
            itemcountf,
            stringt[6]
        ;
        
        for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
        {
            if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
                || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

            itemcountf += 2;

            if (i == ITEM_MATERIALS)
            {
                format(stringt, sizeof stringt, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
            }
            else
            {
                format(stringt, sizeof stringt, "%i", BP_PlayerItemGetCount(playerid, i));
            }

            ItemInv[playerid][itemcountf-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf-1][TD_X], ItemTDInfo[itemcountf-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountf-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountf-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountf-2], BP_GetItemModelID(i));
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-2], i);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountf-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcountf-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf][TD_X], ItemTDInfo[itemcountf][TD_Y], stringt);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountf-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountf-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountf-1], 1);
            
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-1]);
        }
        return 1;
    }
    else if(clickedid == MainInv[143]) // oruzje
    {
        if (IsPlayerOnLawDuty(playerid))
            return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete uzimati/stavljati oruzje u ranac.");

        if (IsPlayerInWar(playerid))
            return ErrorMsg(playerid, "Ne mozete uzimati/stavljati oruzje u ranac dok ste u waru.");

        if (IsPlayerWorking(playerid))
            return ErrorMsg(playerid, "Ne mozete uzimati/stavljati oruzje u ranac dok ste na poslu.");
    
        for(new i = 0; i < 48; i++)
        {
            if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
                PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
                ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
            if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, PutGun[playerid][i]);
                PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
                PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
        }

        new stringw[6], itemcountl, weaponmodel, slotempty;
        for(new i = 0; i < BP_MAX_WEAPONS; i++) 
        {
            if (P_BACKPACK[playerid][BP_WEAPON][i] == -1 || P_BACKPACK[playerid][BP_AMMO][i] <= 0)
            {
                slotempty += 1;
                if(itemcountl >= 2)
                    slotempty = 2;
                switch(slotempty)
                {
                    case 1:
                    {
                        PutGun[playerid][0] = CreatePlayerTextDraw(playerid, 55.016651, 116.974037, "");
                        PlayerTextDrawTextSize(playerid, PutGun[playerid][0], 25.000000, 30.000000);
                        PlayerTextDrawAlignment(playerid, PutGun[playerid][0], 1);
                        PlayerTextDrawColor(playerid, PutGun[playerid][0], -154);
                        PlayerTextDrawSetShadow(playerid, PutGun[playerid][0], 0);
                        PlayerTextDrawFont(playerid, PutGun[playerid][0], 5);
                        PlayerTextDrawSetProportional(playerid, PutGun[playerid][0], 0);
                        PlayerTextDrawSetSelectable(playerid, PutGun[playerid][0], true);
                        PlayerTextDrawSetPreviewModel(playerid, PutGun[playerid][0], 1316);
                        PlayerTextDrawBackgroundColor(playerid, PutGun[playerid][0], 0x00000000);
                        PlayerTextDrawSetPreviewRot(playerid, PutGun[playerid][0], 90.000000, 0.000000, 0.000000, 1.000000);
                    
                        PlayerTextDrawShow(playerid, PutGun[playerid][0]);
                    }
                    case 2:
                    {
                        PutGun[playerid][1] = CreatePlayerTextDraw(playerid, 108.049957, 116.974037, "");
                        PlayerTextDrawTextSize(playerid, PutGun[playerid][1], 25.000000, 30.000000);
                        PlayerTextDrawAlignment(playerid, PutGun[playerid][1], 1);
                        PlayerTextDrawColor(playerid, PutGun[playerid][1], -154);
                        PlayerTextDrawSetShadow(playerid, PutGun[playerid][1], 0);
                        PlayerTextDrawFont(playerid, PutGun[playerid][1], 5);
                        PlayerTextDrawSetProportional(playerid, PutGun[playerid][1], 0);
                        PlayerTextDrawSetSelectable(playerid, PutGun[playerid][1], true);
                        PlayerTextDrawSetPreviewModel(playerid, PutGun[playerid][1], 1316);
                        PlayerTextDrawBackgroundColor(playerid, PutGun[playerid][1], 0x00000000);
                        PlayerTextDrawSetPreviewRot(playerid, PutGun[playerid][1], 90.000000, 0.000000, 0.000000, 1.000000);
                    
                        PlayerTextDrawShow(playerid, PutGun[playerid][1]);
                    }
                    case 3:
                    {
                        PutGun[playerid][2] = CreatePlayerTextDraw(playerid, 161.466537, 116.974037, "");
                        PlayerTextDrawTextSize(playerid, PutGun[playerid][2], 25.000000, 30.000000);
                        PlayerTextDrawAlignment(playerid, PutGun[playerid][2], 1);
                        PlayerTextDrawColor(playerid, PutGun[playerid][2], -154);
                        PlayerTextDrawSetShadow(playerid, PutGun[playerid][2], 0);
                        PlayerTextDrawFont(playerid, PutGun[playerid][2], 5);
                        PlayerTextDrawSetProportional(playerid, PutGun[playerid][2], 0);
                        PlayerTextDrawSetSelectable(playerid, PutGun[playerid][2], true);
                        PlayerTextDrawSetPreviewModel(playerid, PutGun[playerid][2], 1316);
                        PlayerTextDrawBackgroundColor(playerid, PutGun[playerid][2], 0x00000000);
                        PlayerTextDrawSetPreviewRot(playerid, PutGun[playerid][2], 90.000000, 0.000000, 0.000000, 1.000000);
                    
                        PlayerTextDrawShow(playerid, PutGun[playerid][2]);
                    }
                }
                continue;
            }
            itemcountl += 2;
            switch(P_BACKPACK[playerid][BP_WEAPON][i])
            {
                case 24: weaponmodel = 348;
                case 34: weaponmodel = 358;
                case 22: weaponmodel = 346;
                case 4: weaponmodel = 335;
                case 29: weaponmodel = 353;
                case 32: weaponmodel = 372;
                case 31: weaponmodel = 356;
                case 23: weaponmodel = 347;
                case 25: weaponmodel = 349;
                case 33: weaponmodel = 357;
                case 30: weaponmodel = 355;
                case 3: weaponmodel = 334;
                case 5: weaponmodel = 336;
                case 14: weaponmodel = 325;
                case 42: weaponmodel = 366;
                case 1: weaponmodel = 331;
                default: weaponmodel = -1;
            }

            ItemInv[playerid][itemcountl-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl-1][TD_X], ItemTDInfo[itemcountl-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountl-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountl-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountl-2], weaponmodel);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-2], i);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountl-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcountl-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl][TD_X], ItemTDInfo[itemcountl][TD_Y], stringw);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountl-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountl-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountl-1], 1);
        
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-1]);
        }
        return 1;
    }
    else if(clickedid == MainInv[145]) // droga
    {
        for(new i = 0; i < 48; i++)
        {
            if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
                PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
                ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
            if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, PutGun[playerid][i]);
                PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
                PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
        }

        new
            itemcount,
            strcol[10]
        ;

        BP_managingItemID[playerid] = -1;

        if(BP_PlayerItemGetCount(playerid, ITEM_MDMA) >= 1)
        {
            itemcount += 2;

            format(strcol, sizeof strcol, "%dgr", BP_PlayerItemGetCount(playerid, ITEM_MDMA));

            ItemInv[playerid][itemcount-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount-1][TD_X], ItemTDInfo[itemcount-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcount-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcount-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcount-2], BP_GetItemModelID(ITEM_MDMA));
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-2], ITEM_MDMA);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcount-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcount-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount][TD_X], ItemTDInfo[itemcount][TD_Y], strcol);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcount-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcount-1], 1);
            
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-1]);
        }
        if(BP_PlayerItemGetCount(playerid, ITEM_HEROIN) >= 1)
        {
            itemcount += 2;

            format(strcol, sizeof strcol, "%dgr", BP_PlayerItemGetCount(playerid, ITEM_HEROIN));

            ItemInv[playerid][itemcount-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount-1][TD_X], ItemTDInfo[itemcount-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcount-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcount-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcount-2], BP_GetItemModelID(ITEM_HEROIN));
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-2], ITEM_HEROIN);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcount-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcount-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount][TD_X], ItemTDInfo[itemcount][TD_Y], strcol);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcount-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcount-1], 1);

            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-1]);
        }
        if(BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW) >= 1)
        {
            itemcount += 2;

            format(strcol, sizeof strcol, "%dgr", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW));

            ItemInv[playerid][itemcount-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount-1][TD_X], ItemTDInfo[itemcount-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcount-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcount-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcount-2], BP_GetItemModelID(ITEM_WEED_RAW));
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-2], ITEM_WEED_RAW);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcount-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcount-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount][TD_X], ItemTDInfo[itemcount][TD_Y], strcol);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcount-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcount-1], 1);

            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-1]);
        }
        if(BP_PlayerItemGetCount(playerid, ITEM_WEED) >= 1)
        {
            itemcount += 2;

            format(strcol, sizeof strcol, "%dgr", BP_PlayerItemGetCount(playerid, ITEM_WEED));

            ItemInv[playerid][itemcount-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount-1][TD_X], ItemTDInfo[itemcount-1][TD_Y], "");
            PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcount-2], 34.000000, 45.000000);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-2], -1);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-2], 5);
            PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcount-2], true);
            PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcount-2], BP_GetItemModelID(ITEM_WEED));
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-2], ITEM_WEED);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-2], 0x00000000);
            PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcount-2], 0.000000, 0.000000, 0.000000, 1.000000);

            ItemInv[playerid][itemcount-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount][TD_X], ItemTDInfo[itemcount][TD_Y], strcol);
            PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcount-1], 0.136666, 0.562962);
            PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-1], -1);
            PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-1], 0);
            PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-1], 255);
            PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-1], 2);
            PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcount-1], 1);

            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-2]);
            PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-1]);
        }
        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_0;
}

hook OPC_PlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == ItemInv[playerid][0] || playertextid == ItemInv[playerid][2] || playertextid == ItemInv[playerid][4] || playertextid == ItemInv[playerid][6] || playertextid == ItemInv[playerid][8] || playertextid == ItemInv[playerid][10] || playertextid == ItemInv[playerid][12] || playertextid == ItemInv[playerid][14] || playertextid == ItemInv[playerid][16] || playertextid == ItemInv[playerid][18] || playertextid == ItemInv[playerid][20] || playertextid == ItemInv[playerid][22] || playertextid == ItemInv[playerid][24] || playertextid == ItemInv[playerid][26] || playertextid == ItemInv[playerid][28] || playertextid == ItemInv[playerid][30] || playertextid == ItemInv[playerid][32] || playertextid == ItemInv[playerid][34] || playertextid == ItemInv[playerid][36] || playertextid == ItemInv[playerid][38] || playertextid == ItemInv[playerid][40] || playertextid == ItemInv[playerid][42] || playertextid == ItemInv[playerid][44] || playertextid == ItemInv[playerid][46])
    {
        new
            modelid = PlayerTextDrawGetPreviewModel(playerid, playertextid),
            naslov[40],
            sItemName[25]
        ;

        switch(modelid)
        {
            case 19897,19998,19571,18644,19088,19921,3380,1742,19570,19787,1650,18977,17051,18634,1252,1654,2214,19575,19576,19574,19573,2750:
            {
                BP_managingItemID[playerid] = PlayerTextDrawGetShadow(playerid, playertextid);
                BP_GetItemName(BP_managingItemID[playerid], sItemName, sizeof sItemName);

                format(naslov, sizeof naslov, "RANAC » STVARI » %s", (StrToUpper(sItemName), sItemName));
                SPD(playerid, "backpack_items_manage", DIALOG_STYLE_LIST, naslov, "Koristi\nDaj igracu\nBaci", "Dalje »", "« Nazad");
            }
            case 348,358,346,335,353,372,356,347,349,357,377,334,336,325,366,331,355:
            {
                BP_managingItemID[playerid] = PlayerTextDrawGetShadow(playerid, playertextid);
                
                new
                    slot = BP_managingItemID[playerid],
                    weaponid,
                    ammo,
                    weapon[25];

                if (slot < 0 || slot >= BP_MAX_WEAPONS)
                    return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

                weaponid = P_BACKPACK[playerid][BP_WEAPON][slot];
                ammo     = P_BACKPACK[playerid][BP_AMMO][slot];

                if (ammo <= 0)
                    return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

                GetWeaponName(weaponid, weapon, sizeof(weapon));
                BP_oruzje_slot[playerid] = slot;
                format(string_256, 160, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da uzmete:", weapon, ammo);
                SPD(playerid, "backpack_weapons_take_conf", DIALOG_STYLE_INPUT, "RANAC » ORUZJE » UZMI", string_256, "Uzmi", "« Nazad");
                //SPD(playerid, "backpack_weapons", DIALOG_STYLE_LIST, "RANAC » ORUZJE", "Uzmi oruzje\nStavi oruzje", "Dalje »", "« Nazad");
            }
            case 1575,1580,903,702:
            {
                BP_managingItemID[playerid] = PlayerTextDrawGetShadow(playerid, playertextid);
                BP_GetItemName(BP_managingItemID[playerid], sItemName, sizeof sItemName);

                format(naslov, sizeof naslov, "RANAC » DROGA » %s", (StrToUpper(sItemName), sItemName));
                SPD(playerid, "backpack_drugs_manage", DIALOG_STYLE_LIST, naslov, "Prodaj igracu\nBaci", "Dalje »", "« Nazad");
            }
            default: return ErrorMsg(playerid, "Doslo je do greske, prijavi daddyu ako primijetis ovu poruku!");
        }
        return 1;
    }
    if(playertextid == PutGun[playerid][0] || playertextid == PutGun[playerid][1] || playertextid == PutGun[playerid][2])
    {
        if (IsPlayerOnLawDuty(playerid))
            return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInDMEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInHorrorEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista ostaviti u ranac.");

        if (IsPlayerInLMSEvent(playerid))
            return ErrorMsg(playerid, "Trenutno ucestvujete u LMS Event-u i ne mozete nista ostaviti u ranac.");
            
        new weaponid, ammo, weapon[25], string[200], hasweapon;
        format(string, 23, "Slot\tOruzje\tMunicija");
        for__loop (new i = 0; i < 13; i++) 
        {
            weaponid    = GetPlayerWeaponInSlot(playerid, i);
            ammo        = GetPlayerAmmoInSlot(playerid, i);
            if (weaponid <= 0 || ammo <= 0) continue;
            SendClientMessageF(playerid, -1, "proslo");
            hasweapon += 1;
            GetWeaponName(weaponid, weapon, sizeof(weapon));
            format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, ammo);
        }
        if(hasweapon == 0)
        {
            SelectTextDraw(playerid, 0xFFFFFF99);
            ErrorMsg(playerid, "Nemate oruzje za staviti u ranac.");
        }
        else
            SPD(playerid, "backpack_weapons_put", DIALOG_STYLE_TABLIST_HEADERS, "RANAC » ORUZJE » STAVI", string, "Stavi", "« Nazad");
        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_0;
}

// stocks;
stock CreateMainInvTD()
{
    MainInv[0] = TextDrawCreate(-12.916659, -1.592631, "LD_SPAC:white");
    TextDrawTextSize(MainInv[0], 829.000000, 475.000000);
    TextDrawAlignment(MainInv[0], 1);
    TextDrawColor(MainInv[0], 404235256);
    TextDrawSetShadow(MainInv[0], 0);
    TextDrawBackgroundColor(MainInv[0], 255);
    TextDrawFont(MainInv[0], 4);
    TextDrawSetProportional(MainInv[0], 0);

    MainInv[1] = TextDrawCreate(-26.666662, 302.259155, "particle:lamp_shad_64");
    TextDrawTextSize(MainInv[1], 764.000000, -333.000000);
    TextDrawAlignment(MainInv[1], 1);
    TextDrawColor(MainInv[1], -239);
    TextDrawSetShadow(MainInv[1], 0);
    TextDrawBackgroundColor(MainInv[1], 255);
    TextDrawFont(MainInv[1], 4);
    TextDrawSetProportional(MainInv[1], 0);

    MainInv[2] = TextDrawCreate(265.000000, 30.555534, "LD_SPAC:white");
    TextDrawTextSize(MainInv[2], 339.000000, 0.319999);
    TextDrawAlignment(MainInv[2], 1);
    TextDrawColor(MainInv[2], -1);
    TextDrawSetShadow(MainInv[2], 0);
    TextDrawBackgroundColor(MainInv[2], 255);
    TextDrawFont(MainInv[2], 4);
    TextDrawSetProportional(MainInv[2], 0);

    MainInv[3] = TextDrawCreate(247.716644, 18.088890, "0");
    TextDrawLetterSize(MainInv[3], 0.272500, 2.357035);
    TextDrawAlignment(MainInv[3], 1);
    TextDrawColor(MainInv[3], -1);
    TextDrawSetShadow(MainInv[3], 0);
    TextDrawBackgroundColor(MainInv[3], 255);
    TextDrawFont(MainInv[3], 2);
    TextDrawSetProportional(MainInv[3], 1);

    MainInv[4] = TextDrawCreate(248.750015, 24.851839, "LD_SPAC:white");
    TextDrawTextSize(MainInv[4], 1.849999, 5.519989);
    TextDrawAlignment(MainInv[4], 1);
    TextDrawColor(MainInv[4], -1);
    TextDrawSetShadow(MainInv[4], 0);
    TextDrawBackgroundColor(MainInv[4], 255);
    TextDrawFont(MainInv[4], 4);
    TextDrawSetProportional(MainInv[4], 0);

    MainInv[5] = TextDrawCreate(240.000030, 27.503698, "Koristi_lijevi_klik_da_upravljas_artiklima");
    TextDrawLetterSize(MainInv[5], 0.132916, 0.635555);
    TextDrawAlignment(MainInv[5], 3);
    TextDrawColor(MainInv[5], -1);
    TextDrawSetShadow(MainInv[5], 0);
    TextDrawBackgroundColor(MainInv[5], 255);
    TextDrawFont(MainInv[5], 2);
    TextDrawSetProportional(MainInv[5], 1);

    MainInv[6] = TextDrawCreate(32.083339, 57.418506, "LD_SPAC:white");
    TextDrawTextSize(MainInv[6], 339.000000, 0.319999);
    TextDrawAlignment(MainInv[6], 1);
    TextDrawColor(MainInv[6], -1);
    TextDrawSetShadow(MainInv[6], 0);
    TextDrawBackgroundColor(MainInv[6], 255);
    TextDrawFont(MainInv[6], 4);
    TextDrawSetProportional(MainInv[6], 0);

    MainInv[7] = TextDrawCreate(31.850032, 30.674043, "LD_SPAC:white");
    TextDrawTextSize(MainInv[7], 70.610130, 0.289999);
    TextDrawAlignment(MainInv[7], 1);
    TextDrawColor(MainInv[7], -1);
    TextDrawSetShadow(MainInv[7], 0);
    TextDrawBackgroundColor(MainInv[7], 255);
    TextDrawFont(MainInv[7], 4);
    TextDrawSetProportional(MainInv[7], 0);

    MainInv[8] = TextDrawCreate(31.850032, 30.674043, "LD_SPAC:white");
    TextDrawTextSize(MainInv[8], 0.389999, 27.160003);
    TextDrawAlignment(MainInv[8], 1);
    TextDrawColor(MainInv[8], -1);
    TextDrawSetShadow(MainInv[8], 0);
    TextDrawBackgroundColor(MainInv[8], 255);
    TextDrawFont(MainInv[8], 4);
    TextDrawSetProportional(MainInv[8], 0);

    MainInv[9] = TextDrawCreate(379.333557, 53.629600, "X");
    TextDrawLetterSize(MainInv[9], 0.340833, 0.754814);
    TextDrawAlignment(MainInv[9], 1);
    TextDrawColor(MainInv[9], -1);
    TextDrawSetShadow(MainInv[9], 0);
    TextDrawBackgroundColor(MainInv[9], 255);
    TextDrawFont(MainInv[9], 3);
    TextDrawSetProportional(MainInv[9], 1);

    MainInv[10] = TextDrawCreate(379.333557, 53.629600, "X");
    TextDrawLetterSize(MainInv[10], 0.340833, 0.754814);
    TextDrawAlignment(MainInv[10], 1);
    TextDrawColor(MainInv[10], -1);
    TextDrawSetShadow(MainInv[10], 0);
    TextDrawBackgroundColor(MainInv[10], 255);
    TextDrawFont(MainInv[10], 3);
    TextDrawSetProportional(MainInv[10], 1);

    MainInv[11] = TextDrawCreate(393.233276, 54.329605, "Koristi_tipku_'ESC'_da_napustis_inventory_ranca");
    TextDrawLetterSize(MainInv[11], 0.132916, 0.635555);
    TextDrawAlignment(MainInv[11], 1);
    TextDrawColor(MainInv[11], -1);
    TextDrawSetShadow(MainInv[11], 0);
    TextDrawBackgroundColor(MainInv[11], 255);
    TextDrawFont(MainInv[11], 2);
    TextDrawSetProportional(MainInv[11], 1);

    MainInv[12] = TextDrawCreate(45.449569, 354.021942, "LD_SPAC:white");
    TextDrawTextSize(MainInv[12], 549.000000, 36.000000);
    TextDrawAlignment(MainInv[12], 1);
    TextDrawColor(MainInv[12], -249);
    TextDrawSetShadow(MainInv[12], 0);
    TextDrawBackgroundColor(MainInv[12], 255);
    TextDrawFont(MainInv[12], 4);
    TextDrawSetProportional(MainInv[12], 0);

    MainInv[13] = TextDrawCreate(382.067169, 93.025566, "LD_SPAC:white");
    TextDrawTextSize(MainInv[13], 33.000000, 136.000000);
    TextDrawAlignment(MainInv[13], 1);
    TextDrawColor(MainInv[13], -249);
    TextDrawSetShadow(MainInv[13], 0);
    TextDrawBackgroundColor(MainInv[13], 255);
    TextDrawFont(MainInv[13], 4);
    TextDrawSetProportional(MainInv[13], 0);

    MainInv[14] = TextDrawCreate(67.850166, 170.122589, "LD_SPAC:white");
    TextDrawTextSize(MainInv[14], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[14], 1);
    TextDrawColor(MainInv[14], -1);
    TextDrawSetShadow(MainInv[14], 0);
    TextDrawBackgroundColor(MainInv[14], 255);
    TextDrawFont(MainInv[14], 4);
    TextDrawSetProportional(MainInv[14], 0);

    MainInv[15] = TextDrawCreate(46.167167, 214.331359, "LD_SPAC:white");
    TextDrawTextSize(MainInv[15], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[15], 1);
    TextDrawColor(MainInv[15], -1);
    TextDrawSetShadow(MainInv[15], 0);
    TextDrawBackgroundColor(MainInv[15], 255);
    TextDrawFont(MainInv[15], 4);
    TextDrawSetProportional(MainInv[15], 0);

    MainInv[16] = TextDrawCreate(46.167167, 214.331359, "LD_SPAC:white");
    TextDrawTextSize(MainInv[16], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[16], 1);
    TextDrawColor(MainInv[16], -1);
    TextDrawSetShadow(MainInv[16], 0);
    TextDrawBackgroundColor(MainInv[16], 255);
    TextDrawFont(MainInv[16], 4);
    TextDrawSetProportional(MainInv[16], 0);

    MainInv[17] = TextDrawCreate(88.433815, 214.312881, "LD_SPAC:white");
    TextDrawTextSize(MainInv[17], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[17], 1);
    TextDrawColor(MainInv[17], -1);
    TextDrawSetShadow(MainInv[17], 0);
    TextDrawBackgroundColor(MainInv[17], 255);
    TextDrawFont(MainInv[17], 4);
    TextDrawSetProportional(MainInv[17], 0);

    MainInv[18] = TextDrawCreate(46.233856, 170.256347, "LD_SPAC:white");
    TextDrawTextSize(MainInv[18], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[18], 1);
    TextDrawColor(MainInv[18], -1);
    TextDrawSetShadow(MainInv[18], 0);
    TextDrawBackgroundColor(MainInv[18], 255);
    TextDrawFont(MainInv[18], 4);
    TextDrawSetProportional(MainInv[18], 0);

    MainInv[19] = TextDrawCreate(120.816673, 170.122589, "LD_SPAC:white");
    TextDrawTextSize(MainInv[19], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[19], 1);
    TextDrawColor(MainInv[19], -1);
    TextDrawSetShadow(MainInv[19], 0);
    TextDrawBackgroundColor(MainInv[19], 255);
    TextDrawFont(MainInv[19], 4);
    TextDrawSetProportional(MainInv[19], 0);

    MainInv[20] = TextDrawCreate(99.133598, 214.331375, "LD_SPAC:white");
    TextDrawTextSize(MainInv[20], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[20], 1);
    TextDrawColor(MainInv[20], -1);
    TextDrawSetShadow(MainInv[20], 0);
    TextDrawBackgroundColor(MainInv[20], 255);
    TextDrawFont(MainInv[20], 4);
    TextDrawSetProportional(MainInv[20], 0);

    MainInv[21] = TextDrawCreate(99.133598, 214.331375, "LD_SPAC:white");
    TextDrawTextSize(MainInv[21], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[21], 1);
    TextDrawColor(MainInv[21], -1);
    TextDrawSetShadow(MainInv[21], 0);
    TextDrawBackgroundColor(MainInv[21], 255);
    TextDrawFont(MainInv[21], 4);
    TextDrawSetProportional(MainInv[21], 0);

    MainInv[22] = TextDrawCreate(141.400955, 214.312896, "LD_SPAC:white");
    TextDrawTextSize(MainInv[22], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[22], 1);
    TextDrawColor(MainInv[22], -1);
    TextDrawSetShadow(MainInv[22], 0);
    TextDrawBackgroundColor(MainInv[22], 255);
    TextDrawFont(MainInv[22], 4);
    TextDrawSetProportional(MainInv[22], 0);

    MainInv[23] = TextDrawCreate(99.200286, 170.256347, "LD_SPAC:white");
    TextDrawTextSize(MainInv[23], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[23], 1);
    TextDrawColor(MainInv[23], -1);
    TextDrawSetShadow(MainInv[23], 0);
    TextDrawBackgroundColor(MainInv[23], 255);
    TextDrawFont(MainInv[23], 4);
    TextDrawSetProportional(MainInv[23], 0);

    MainInv[24] = TextDrawCreate(174.100677, 170.122589, "LD_SPAC:white");
    TextDrawTextSize(MainInv[24], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[24], 1);
    TextDrawColor(MainInv[24], -1);
    TextDrawSetShadow(MainInv[24], 0);
    TextDrawBackgroundColor(MainInv[24], 255);
    TextDrawFont(MainInv[24], 4);
    TextDrawSetProportional(MainInv[24], 0);

    MainInv[25] = TextDrawCreate(152.417617, 214.331375, "LD_SPAC:white");
    TextDrawTextSize(MainInv[25], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[25], 1);
    TextDrawColor(MainInv[25], -1);
    TextDrawSetShadow(MainInv[25], 0);
    TextDrawBackgroundColor(MainInv[25], 255);
    TextDrawFont(MainInv[25], 4);
    TextDrawSetProportional(MainInv[25], 0);

    MainInv[26] = TextDrawCreate(152.417617, 214.331375, "LD_SPAC:white");
    TextDrawTextSize(MainInv[26], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[26], 1);
    TextDrawColor(MainInv[26], -1);
    TextDrawSetShadow(MainInv[26], 0);
    TextDrawBackgroundColor(MainInv[26], 255);
    TextDrawFont(MainInv[26], 4);
    TextDrawSetProportional(MainInv[26], 0);

    MainInv[27] = TextDrawCreate(194.684997, 214.312896, "LD_SPAC:white");
    TextDrawTextSize(MainInv[27], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[27], 1);
    TextDrawColor(MainInv[27], -1);
    TextDrawSetShadow(MainInv[27], 0);
    TextDrawBackgroundColor(MainInv[27], 255);
    TextDrawFont(MainInv[27], 4);
    TextDrawSetProportional(MainInv[27], 0);

    MainInv[28] = TextDrawCreate(152.484298, 170.256347, "LD_SPAC:white");
    TextDrawTextSize(MainInv[28], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[28], 1);
    TextDrawColor(MainInv[28], -1);
    TextDrawSetShadow(MainInv[28], 0);
    TextDrawBackgroundColor(MainInv[28], 255);
    TextDrawFont(MainInv[28], 4);
    TextDrawSetProportional(MainInv[28], 0);

    MainInv[29] = TextDrawCreate(227.901275, 170.241119, "LD_SPAC:white");
    TextDrawTextSize(MainInv[29], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[29], 1);
    TextDrawColor(MainInv[29], -1);
    TextDrawSetShadow(MainInv[29], 0);
    TextDrawBackgroundColor(MainInv[29], 255);
    TextDrawFont(MainInv[29], 4);
    TextDrawSetProportional(MainInv[29], 0);

    MainInv[30] = TextDrawCreate(206.218215, 214.449859, "LD_SPAC:white");
    TextDrawTextSize(MainInv[30], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[30], 1);
    TextDrawColor(MainInv[30], -1);
    TextDrawSetShadow(MainInv[30], 0);
    TextDrawBackgroundColor(MainInv[30], 255);
    TextDrawFont(MainInv[30], 4);
    TextDrawSetProportional(MainInv[30], 0);

    MainInv[31] = TextDrawCreate(206.218215, 214.449859, "LD_SPAC:white");
    TextDrawTextSize(MainInv[31], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[31], 1);
    TextDrawColor(MainInv[31], -1);
    TextDrawSetShadow(MainInv[31], 0);
    TextDrawBackgroundColor(MainInv[31], 255);
    TextDrawFont(MainInv[31], 4);
    TextDrawSetProportional(MainInv[31], 0);

    MainInv[32] = TextDrawCreate(248.485580, 214.431381, "LD_SPAC:white");
    TextDrawTextSize(MainInv[32], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[32], 1);
    TextDrawColor(MainInv[32], -1);
    TextDrawSetShadow(MainInv[32], 0);
    TextDrawBackgroundColor(MainInv[32], 255);
    TextDrawFont(MainInv[32], 4);
    TextDrawSetProportional(MainInv[32], 0);

    MainInv[33] = TextDrawCreate(206.284851, 170.693405, "LD_SPAC:white");
    TextDrawTextSize(MainInv[33], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[33], 1);
    TextDrawColor(MainInv[33], -1);
    TextDrawSetShadow(MainInv[33], 0);
    TextDrawBackgroundColor(MainInv[33], 255);
    TextDrawFont(MainInv[33], 4);
    TextDrawSetProportional(MainInv[33], 0);

    MainInv[34] = TextDrawCreate(281.851989, 170.222595, "LD_SPAC:white");
    TextDrawTextSize(MainInv[34], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[34], 1);
    TextDrawColor(MainInv[34], -1);
    TextDrawSetShadow(MainInv[34], 0);
    TextDrawBackgroundColor(MainInv[34], 255);
    TextDrawFont(MainInv[34], 4);
    TextDrawSetProportional(MainInv[34], 0);

    MainInv[35] = TextDrawCreate(260.169036, 214.431350, "LD_SPAC:white");
    TextDrawTextSize(MainInv[35], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[35], 1);
    TextDrawColor(MainInv[35], -1);
    TextDrawSetShadow(MainInv[35], 0);
    TextDrawBackgroundColor(MainInv[35], 255);
    TextDrawFont(MainInv[35], 4);
    TextDrawSetProportional(MainInv[35], 0);

    MainInv[36] = TextDrawCreate(260.169036, 214.431350, "LD_SPAC:white");
    TextDrawTextSize(MainInv[36], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[36], 1);
    TextDrawColor(MainInv[36], -1);
    TextDrawSetShadow(MainInv[36], 0);
    TextDrawBackgroundColor(MainInv[36], 255);
    TextDrawFont(MainInv[36], 4);
    TextDrawSetProportional(MainInv[36], 0);

    MainInv[37] = TextDrawCreate(302.436309, 214.412872, "LD_SPAC:white");
    TextDrawTextSize(MainInv[37], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[37], 1);
    TextDrawColor(MainInv[37], -1);
    TextDrawSetShadow(MainInv[37], 0);
    TextDrawBackgroundColor(MainInv[37], 255);
    TextDrawFont(MainInv[37], 4);
    TextDrawSetProportional(MainInv[37], 0);

    MainInv[38] = TextDrawCreate(260.235656, 170.674880, "LD_SPAC:white");
    TextDrawTextSize(MainInv[38], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[38], 1);
    TextDrawColor(MainInv[38], -1);
    TextDrawSetShadow(MainInv[38], 0);
    TextDrawBackgroundColor(MainInv[38], 255);
    TextDrawFont(MainInv[38], 4);
    TextDrawSetProportional(MainInv[38], 0);

    MainInv[39] = TextDrawCreate(335.852447, 170.222610, "LD_SPAC:white");
    TextDrawTextSize(MainInv[39], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[39], 1);
    TextDrawColor(MainInv[39], -1);
    TextDrawSetShadow(MainInv[39], 0);
    TextDrawBackgroundColor(MainInv[39], 255);
    TextDrawFont(MainInv[39], 4);
    TextDrawSetProportional(MainInv[39], 0);

    MainInv[40] = TextDrawCreate(314.169494, 214.431320, "LD_SPAC:white");
    TextDrawTextSize(MainInv[40], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[40], 1);
    TextDrawColor(MainInv[40], -1);
    TextDrawSetShadow(MainInv[40], 0);
    TextDrawBackgroundColor(MainInv[40], 255);
    TextDrawFont(MainInv[40], 4);
    TextDrawSetProportional(MainInv[40], 0);

    MainInv[41] = TextDrawCreate(314.169494, 214.431320, "LD_SPAC:white");
    TextDrawTextSize(MainInv[41], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[41], 1);
    TextDrawColor(MainInv[41], -1);
    TextDrawSetShadow(MainInv[41], 0);
    TextDrawBackgroundColor(MainInv[41], 255);
    TextDrawFont(MainInv[41], 4);
    TextDrawSetProportional(MainInv[41], 0);

    MainInv[42] = TextDrawCreate(356.436767, 214.412841, "LD_SPAC:white");
    TextDrawTextSize(MainInv[42], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[42], 1);
    TextDrawColor(MainInv[42], -1);
    TextDrawSetShadow(MainInv[42], 0);
    TextDrawBackgroundColor(MainInv[42], 255);
    TextDrawFont(MainInv[42], 4);
    TextDrawSetProportional(MainInv[42], 0);

    MainInv[43] = TextDrawCreate(314.236114, 170.674896, "LD_SPAC:white");
    TextDrawTextSize(MainInv[43], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[43], 1);
    TextDrawColor(MainInv[43], -1);
    TextDrawSetShadow(MainInv[43], 0);
    TextDrawBackgroundColor(MainInv[43], 255);
    TextDrawFont(MainInv[43], 4);
    TextDrawSetProportional(MainInv[43], 0);

    MainInv[44] = TextDrawCreate(67.850166, 109.688468, "LD_SPAC:white");
    TextDrawTextSize(MainInv[44], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[44], 1);
    TextDrawColor(MainInv[44], -1);
    TextDrawSetShadow(MainInv[44], 0);
    TextDrawBackgroundColor(MainInv[44], 255);
    TextDrawFont(MainInv[44], 4);
    TextDrawSetProportional(MainInv[44], 0);

    MainInv[45] = TextDrawCreate(46.167167, 153.896575, "LD_SPAC:white");
    TextDrawTextSize(MainInv[45], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[45], 1);
    TextDrawColor(MainInv[45], -1);
    TextDrawSetShadow(MainInv[45], 0);
    TextDrawBackgroundColor(MainInv[45], 255);
    TextDrawFont(MainInv[45], 4);
    TextDrawSetProportional(MainInv[45], 0);

    MainInv[46] = TextDrawCreate(46.167167, 153.896575, "LD_SPAC:white");
    TextDrawTextSize(MainInv[46], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[46], 1);
    TextDrawColor(MainInv[46], -1);
    TextDrawSetShadow(MainInv[46], 0);
    TextDrawBackgroundColor(MainInv[46], 255);
    TextDrawFont(MainInv[46], 4);
    TextDrawSetProportional(MainInv[46], 0);

    MainInv[47] = TextDrawCreate(88.433815, 153.878097, "LD_SPAC:white");
    TextDrawTextSize(MainInv[47], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[47], 1);
    TextDrawColor(MainInv[47], -1);
    TextDrawSetShadow(MainInv[47], 0);
    TextDrawBackgroundColor(MainInv[47], 255);
    TextDrawFont(MainInv[47], 4);
    TextDrawSetProportional(MainInv[47], 0);

    MainInv[48] = TextDrawCreate(46.233856, 109.822227, "LD_SPAC:white");
    TextDrawTextSize(MainInv[48], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[48], 1);
    TextDrawColor(MainInv[48], -1);
    TextDrawSetShadow(MainInv[48], 0);
    TextDrawBackgroundColor(MainInv[48], 255);
    TextDrawFont(MainInv[48], 4);
    TextDrawSetProportional(MainInv[48], 0);

    MainInv[49] = TextDrawCreate(120.816673, 109.688461, "LD_SPAC:white");
    TextDrawTextSize(MainInv[49], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[49], 1);
    TextDrawColor(MainInv[49], -1);
    TextDrawSetShadow(MainInv[49], 0);
    TextDrawBackgroundColor(MainInv[49], 255);
    TextDrawFont(MainInv[49], 4);
    TextDrawSetProportional(MainInv[49], 0);

    MainInv[50] = TextDrawCreate(99.133598, 153.896591, "LD_SPAC:white");
    TextDrawTextSize(MainInv[50], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[50], 1);
    TextDrawColor(MainInv[50], -1);
    TextDrawSetShadow(MainInv[50], 0);
    TextDrawBackgroundColor(MainInv[50], 255);
    TextDrawFont(MainInv[50], 4);
    TextDrawSetProportional(MainInv[50], 0);

    MainInv[51] = TextDrawCreate(99.133598, 153.896591, "LD_SPAC:white");
    TextDrawTextSize(MainInv[51], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[51], 1);
    TextDrawColor(MainInv[51], -1);
    TextDrawSetShadow(MainInv[51], 0);
    TextDrawBackgroundColor(MainInv[51], 255);
    TextDrawFont(MainInv[51], 4);
    TextDrawSetProportional(MainInv[51], 0);

    MainInv[52] = TextDrawCreate(141.400955, 153.878112, "LD_SPAC:white");
    TextDrawTextSize(MainInv[52], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[52], 1);
    TextDrawColor(MainInv[52], -1);
    TextDrawSetShadow(MainInv[52], 0);
    TextDrawBackgroundColor(MainInv[52], 255);
    TextDrawFont(MainInv[52], 4);
    TextDrawSetProportional(MainInv[52], 0);

    MainInv[53] = TextDrawCreate(99.200286, 109.822219, "LD_SPAC:white");
    TextDrawTextSize(MainInv[53], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[53], 1);
    TextDrawColor(MainInv[53], -1);
    TextDrawSetShadow(MainInv[53], 0);
    TextDrawBackgroundColor(MainInv[53], 255);
    TextDrawFont(MainInv[53], 4);
    TextDrawSetProportional(MainInv[53], 0);

    MainInv[54] = TextDrawCreate(174.100677, 109.688461, "LD_SPAC:white");
    TextDrawTextSize(MainInv[54], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[54], 1);
    TextDrawColor(MainInv[54], -1);
    TextDrawSetShadow(MainInv[54], 0);
    TextDrawBackgroundColor(MainInv[54], 255);
    TextDrawFont(MainInv[54], 4);
    TextDrawSetProportional(MainInv[54], 0);

    MainInv[55] = TextDrawCreate(152.417617, 153.896591, "LD_SPAC:white");
    TextDrawTextSize(MainInv[55], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[55], 1);
    TextDrawColor(MainInv[55], -1);
    TextDrawSetShadow(MainInv[55], 0);
    TextDrawBackgroundColor(MainInv[55], 255);
    TextDrawFont(MainInv[55], 4);
    TextDrawSetProportional(MainInv[55], 0);

    MainInv[56] = TextDrawCreate(152.417617, 153.896591, "LD_SPAC:white");
    TextDrawTextSize(MainInv[56], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[56], 1);
    TextDrawColor(MainInv[56], -1);
    TextDrawSetShadow(MainInv[56], 0);
    TextDrawBackgroundColor(MainInv[56], 255);
    TextDrawFont(MainInv[56], 4);
    TextDrawSetProportional(MainInv[56], 0);

    MainInv[57] = TextDrawCreate(194.684997, 153.878112, "LD_SPAC:white");
    TextDrawTextSize(MainInv[57], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[57], 1);
    TextDrawColor(MainInv[57], -1);
    TextDrawSetShadow(MainInv[57], 0);
    TextDrawBackgroundColor(MainInv[57], 255);
    TextDrawFont(MainInv[57], 4);
    TextDrawSetProportional(MainInv[57], 0);

    MainInv[58] = TextDrawCreate(152.484298, 109.822219, "LD_SPAC:white");
    TextDrawTextSize(MainInv[58], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[58], 1);
    TextDrawColor(MainInv[58], -1);
    TextDrawSetShadow(MainInv[58], 0);
    TextDrawBackgroundColor(MainInv[58], 255);
    TextDrawFont(MainInv[58], 4);
    TextDrawSetProportional(MainInv[58], 0);

    MainInv[59] = TextDrawCreate(227.901275, 109.806991, "LD_SPAC:white");
    TextDrawTextSize(MainInv[59], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[59], 1);
    TextDrawColor(MainInv[59], -1);
    TextDrawSetShadow(MainInv[59], 0);
    TextDrawBackgroundColor(MainInv[59], 255);
    TextDrawFont(MainInv[59], 4);
    TextDrawSetProportional(MainInv[59], 0);

    MainInv[60] = TextDrawCreate(206.218215, 154.015075, "LD_SPAC:white");
    TextDrawTextSize(MainInv[60], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[60], 1);
    TextDrawColor(MainInv[60], -1);
    TextDrawSetShadow(MainInv[60], 0);
    TextDrawBackgroundColor(MainInv[60], 255);
    TextDrawFont(MainInv[60], 4);
    TextDrawSetProportional(MainInv[60], 0);

    MainInv[61] = TextDrawCreate(206.218215, 154.015075, "LD_SPAC:white");
    TextDrawTextSize(MainInv[61], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[61], 1);
    TextDrawColor(MainInv[61], -1);
    TextDrawSetShadow(MainInv[61], 0);
    TextDrawBackgroundColor(MainInv[61], 255);
    TextDrawFont(MainInv[61], 4);
    TextDrawSetProportional(MainInv[61], 0);

    MainInv[62] = TextDrawCreate(248.485580, 153.996597, "LD_SPAC:white");
    TextDrawTextSize(MainInv[62], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[62], 1);
    TextDrawColor(MainInv[62], -1);
    TextDrawSetShadow(MainInv[62], 0);
    TextDrawBackgroundColor(MainInv[62], 255);
    TextDrawFont(MainInv[62], 4);
    TextDrawSetProportional(MainInv[62], 0);

    MainInv[63] = TextDrawCreate(206.284851, 110.259277, "LD_SPAC:white");
    TextDrawTextSize(MainInv[63], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[63], 1);
    TextDrawColor(MainInv[63], -1);
    TextDrawSetShadow(MainInv[63], 0);
    TextDrawBackgroundColor(MainInv[63], 255);
    TextDrawFont(MainInv[63], 4);
    TextDrawSetProportional(MainInv[63], 0);

    MainInv[64] = TextDrawCreate(281.851989, 109.788475, "LD_SPAC:white");
    TextDrawTextSize(MainInv[64], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[64], 1);
    TextDrawColor(MainInv[64], -1);
    TextDrawSetShadow(MainInv[64], 0);
    TextDrawBackgroundColor(MainInv[64], 255);
    TextDrawFont(MainInv[64], 4);
    TextDrawSetProportional(MainInv[64], 0);

    MainInv[65] = TextDrawCreate(260.169036, 153.996566, "LD_SPAC:white");
    TextDrawTextSize(MainInv[65], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[65], 1);
    TextDrawColor(MainInv[65], -1);
    TextDrawSetShadow(MainInv[65], 0);
    TextDrawBackgroundColor(MainInv[65], 255);
    TextDrawFont(MainInv[65], 4);
    TextDrawSetProportional(MainInv[65], 0);

    MainInv[66] = TextDrawCreate(260.169036, 153.996566, "LD_SPAC:white");
    TextDrawTextSize(MainInv[66], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[66], 1);
    TextDrawColor(MainInv[66], -1);
    TextDrawSetShadow(MainInv[66], 0);
    TextDrawBackgroundColor(MainInv[66], 255);
    TextDrawFont(MainInv[66], 4);
    TextDrawSetProportional(MainInv[66], 0);

    MainInv[67] = TextDrawCreate(302.436309, 153.978088, "LD_SPAC:white");
    TextDrawTextSize(MainInv[67], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[67], 1);
    TextDrawColor(MainInv[67], -1);
    TextDrawSetShadow(MainInv[67], 0);
    TextDrawBackgroundColor(MainInv[67], 255);
    TextDrawFont(MainInv[67], 4);
    TextDrawSetProportional(MainInv[67], 0);

    MainInv[68] = TextDrawCreate(260.235656, 110.240760, "LD_SPAC:white");
    TextDrawTextSize(MainInv[68], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[68], 1);
    TextDrawColor(MainInv[68], -1);
    TextDrawSetShadow(MainInv[68], 0);
    TextDrawBackgroundColor(MainInv[68], 255);
    TextDrawFont(MainInv[68], 4);
    TextDrawSetProportional(MainInv[68], 0);

    MainInv[69] = TextDrawCreate(335.852447, 109.788490, "LD_SPAC:white");
    TextDrawTextSize(MainInv[69], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[69], 1);
    TextDrawColor(MainInv[69], -1);
    TextDrawSetShadow(MainInv[69], 0);
    TextDrawBackgroundColor(MainInv[69], 255);
    TextDrawFont(MainInv[69], 4);
    TextDrawSetProportional(MainInv[69], 0);

    MainInv[70] = TextDrawCreate(314.169494, 153.996536, "LD_SPAC:white");
    TextDrawTextSize(MainInv[70], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[70], 1);
    TextDrawColor(MainInv[70], -1);
    TextDrawSetShadow(MainInv[70], 0);
    TextDrawBackgroundColor(MainInv[70], 255);
    TextDrawFont(MainInv[70], 4);
    TextDrawSetProportional(MainInv[70], 0);

    MainInv[71] = TextDrawCreate(314.169494, 153.996536, "LD_SPAC:white");
    TextDrawTextSize(MainInv[71], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[71], 1);
    TextDrawColor(MainInv[71], -1);
    TextDrawSetShadow(MainInv[71], 0);
    TextDrawBackgroundColor(MainInv[71], 255);
    TextDrawFont(MainInv[71], 4);
    TextDrawSetProportional(MainInv[71], 0);

    MainInv[72] = TextDrawCreate(356.436767, 153.978057, "LD_SPAC:white");
    TextDrawTextSize(MainInv[72], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[72], 1);
    TextDrawColor(MainInv[72], -1);
    TextDrawSetShadow(MainInv[72], 0);
    TextDrawBackgroundColor(MainInv[72], 255);
    TextDrawFont(MainInv[72], 4);
    TextDrawSetProportional(MainInv[72], 0);

    MainInv[73] = TextDrawCreate(314.236114, 110.240776, "LD_SPAC:white");
    TextDrawTextSize(MainInv[73], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[73], 1);
    TextDrawColor(MainInv[73], -1);
    TextDrawSetShadow(MainInv[73], 0);
    TextDrawBackgroundColor(MainInv[73], 255);
    TextDrawFont(MainInv[73], 4);
    TextDrawSetProportional(MainInv[73], 0);

    MainInv[74] = TextDrawCreate(67.850158, 292.694549, "LD_SPAC:white");
    TextDrawTextSize(MainInv[74], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[74], 1);
    TextDrawColor(MainInv[74], -1);
    TextDrawSetShadow(MainInv[74], 0);
    TextDrawBackgroundColor(MainInv[74], 255);
    TextDrawFont(MainInv[74], 4);
    TextDrawSetProportional(MainInv[74], 0);

    MainInv[75] = TextDrawCreate(46.167171, 336.902862, "LD_SPAC:white");
    TextDrawTextSize(MainInv[75], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[75], 1);
    TextDrawColor(MainInv[75], -1);
    TextDrawSetShadow(MainInv[75], 0);
    TextDrawBackgroundColor(MainInv[75], 255);
    TextDrawFont(MainInv[75], 4);
    TextDrawSetProportional(MainInv[75], 0);

    MainInv[76] = TextDrawCreate(46.167171, 336.902862, "LD_SPAC:white");
    TextDrawTextSize(MainInv[76], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[76], 1);
    TextDrawColor(MainInv[76], -1);
    TextDrawSetShadow(MainInv[76], 0);
    TextDrawBackgroundColor(MainInv[76], 255);
    TextDrawFont(MainInv[76], 4);
    TextDrawSetProportional(MainInv[76], 0);

    MainInv[77] = TextDrawCreate(88.433807, 336.884399, "LD_SPAC:white");
    TextDrawTextSize(MainInv[77], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[77], 1);
    TextDrawColor(MainInv[77], -1);
    TextDrawSetShadow(MainInv[77], 0);
    TextDrawBackgroundColor(MainInv[77], 255);
    TextDrawFont(MainInv[77], 4);
    TextDrawSetProportional(MainInv[77], 0);

    MainInv[78] = TextDrawCreate(46.233860, 292.828308, "LD_SPAC:white");
    TextDrawTextSize(MainInv[78], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[78], 1);
    TextDrawColor(MainInv[78], -1);
    TextDrawSetShadow(MainInv[78], 0);
    TextDrawBackgroundColor(MainInv[78], 255);
    TextDrawFont(MainInv[78], 4);
    TextDrawSetProportional(MainInv[78], 0);

    MainInv[79] = TextDrawCreate(120.816665, 292.694549, "LD_SPAC:white");
    TextDrawTextSize(MainInv[79], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[79], 1);
    TextDrawColor(MainInv[79], -1);
    TextDrawSetShadow(MainInv[79], 0);
    TextDrawBackgroundColor(MainInv[79], 255);
    TextDrawFont(MainInv[79], 4);
    TextDrawSetProportional(MainInv[79], 0);

    MainInv[80] = TextDrawCreate(99.133590, 336.902893, "LD_SPAC:white");
    TextDrawTextSize(MainInv[80], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[80], 1);
    TextDrawColor(MainInv[80], -1);
    TextDrawSetShadow(MainInv[80], 0);
    TextDrawBackgroundColor(MainInv[80], 255);
    TextDrawFont(MainInv[80], 4);
    TextDrawSetProportional(MainInv[80], 0);

    MainInv[81] = TextDrawCreate(99.133590, 336.902893, "LD_SPAC:white");
    TextDrawTextSize(MainInv[81], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[81], 1);
    TextDrawColor(MainInv[81], -1);
    TextDrawSetShadow(MainInv[81], 0);
    TextDrawBackgroundColor(MainInv[81], 255);
    TextDrawFont(MainInv[81], 4);
    TextDrawSetProportional(MainInv[81], 0);

    MainInv[82] = TextDrawCreate(141.400970, 336.884399, "LD_SPAC:white");
    TextDrawTextSize(MainInv[82], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[82], 1);
    TextDrawColor(MainInv[82], -1);
    TextDrawSetShadow(MainInv[82], 0);
    TextDrawBackgroundColor(MainInv[82], 255);
    TextDrawFont(MainInv[82], 4);
    TextDrawSetProportional(MainInv[82], 0);

    MainInv[83] = TextDrawCreate(99.200279, 292.828308, "LD_SPAC:white");
    TextDrawTextSize(MainInv[83], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[83], 1);
    TextDrawColor(MainInv[83], -1);
    TextDrawSetShadow(MainInv[83], 0);
    TextDrawBackgroundColor(MainInv[83], 255);
    TextDrawFont(MainInv[83], 4);
    TextDrawSetProportional(MainInv[83], 0);

    MainInv[84] = TextDrawCreate(174.100692, 292.694549, "LD_SPAC:white");
    TextDrawTextSize(MainInv[84], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[84], 1);
    TextDrawColor(MainInv[84], -1);
    TextDrawSetShadow(MainInv[84], 0);
    TextDrawBackgroundColor(MainInv[84], 255);
    TextDrawFont(MainInv[84], 4);
    TextDrawSetProportional(MainInv[84], 0);

    MainInv[85] = TextDrawCreate(152.417633, 336.902893, "LD_SPAC:white");
    TextDrawTextSize(MainInv[85], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[85], 1);
    TextDrawColor(MainInv[85], -1);
    TextDrawSetShadow(MainInv[85], 0);
    TextDrawBackgroundColor(MainInv[85], 255);
    TextDrawFont(MainInv[85], 4);
    TextDrawSetProportional(MainInv[85], 0);

    MainInv[86] = TextDrawCreate(152.417633, 336.902893, "LD_SPAC:white");
    TextDrawTextSize(MainInv[86], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[86], 1);
    TextDrawColor(MainInv[86], -1);
    TextDrawSetShadow(MainInv[86], 0);
    TextDrawBackgroundColor(MainInv[86], 255);
    TextDrawFont(MainInv[86], 4);
    TextDrawSetProportional(MainInv[86], 0);

    MainInv[87] = TextDrawCreate(194.685012, 336.884399, "LD_SPAC:white");
    TextDrawTextSize(MainInv[87], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[87], 1);
    TextDrawColor(MainInv[87], -1);
    TextDrawSetShadow(MainInv[87], 0);
    TextDrawBackgroundColor(MainInv[87], 255);
    TextDrawFont(MainInv[87], 4);
    TextDrawSetProportional(MainInv[87], 0);

    MainInv[88] = TextDrawCreate(152.484313, 292.828308, "LD_SPAC:white");
    TextDrawTextSize(MainInv[88], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[88], 1);
    TextDrawColor(MainInv[88], -1);
    TextDrawSetShadow(MainInv[88], 0);
    TextDrawBackgroundColor(MainInv[88], 255);
    TextDrawFont(MainInv[88], 4);
    TextDrawSetProportional(MainInv[88], 0);

    MainInv[89] = TextDrawCreate(227.901290, 292.813079, "LD_SPAC:white");
    TextDrawTextSize(MainInv[89], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[89], 1);
    TextDrawColor(MainInv[89], -1);
    TextDrawSetShadow(MainInv[89], 0);
    TextDrawBackgroundColor(MainInv[89], 255);
    TextDrawFont(MainInv[89], 4);
    TextDrawSetProportional(MainInv[89], 0);

    MainInv[90] = TextDrawCreate(206.218231, 337.021362, "LD_SPAC:white");
    TextDrawTextSize(MainInv[90], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[90], 1);
    TextDrawColor(MainInv[90], -1);
    TextDrawSetShadow(MainInv[90], 0);
    TextDrawBackgroundColor(MainInv[90], 255);
    TextDrawFont(MainInv[90], 4);
    TextDrawSetProportional(MainInv[90], 0);

    MainInv[91] = TextDrawCreate(206.218231, 337.021362, "LD_SPAC:white");
    TextDrawTextSize(MainInv[91], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[91], 1);
    TextDrawColor(MainInv[91], -1);
    TextDrawSetShadow(MainInv[91], 0);
    TextDrawBackgroundColor(MainInv[91], 255);
    TextDrawFont(MainInv[91], 4);
    TextDrawSetProportional(MainInv[91], 0);

    MainInv[92] = TextDrawCreate(248.485595, 337.002899, "LD_SPAC:white");
    TextDrawTextSize(MainInv[92], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[92], 1);
    TextDrawColor(MainInv[92], -1);
    TextDrawSetShadow(MainInv[92], 0);
    TextDrawBackgroundColor(MainInv[92], 255);
    TextDrawFont(MainInv[92], 4);
    TextDrawSetProportional(MainInv[92], 0);

    MainInv[93] = TextDrawCreate(206.284866, 293.265350, "LD_SPAC:white");
    TextDrawTextSize(MainInv[93], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[93], 1);
    TextDrawColor(MainInv[93], -1);
    TextDrawSetShadow(MainInv[93], 0);
    TextDrawBackgroundColor(MainInv[93], 255);
    TextDrawFont(MainInv[93], 4);
    TextDrawSetProportional(MainInv[93], 0);

    MainInv[94] = TextDrawCreate(281.851959, 292.794555, "LD_SPAC:white");
    TextDrawTextSize(MainInv[94], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[94], 1);
    TextDrawColor(MainInv[94], -1);
    TextDrawSetShadow(MainInv[94], 0);
    TextDrawBackgroundColor(MainInv[94], 255);
    TextDrawFont(MainInv[94], 4);
    TextDrawSetProportional(MainInv[94], 0);

    MainInv[95] = TextDrawCreate(260.169006, 337.002868, "LD_SPAC:white");
    TextDrawTextSize(MainInv[95], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[95], 1);
    TextDrawColor(MainInv[95], -1);
    TextDrawSetShadow(MainInv[95], 0);
    TextDrawBackgroundColor(MainInv[95], 255);
    TextDrawFont(MainInv[95], 4);
    TextDrawSetProportional(MainInv[95], 0);

    MainInv[96] = TextDrawCreate(260.169006, 337.002868, "LD_SPAC:white");
    TextDrawTextSize(MainInv[96], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[96], 1);
    TextDrawColor(MainInv[96], -1);
    TextDrawSetShadow(MainInv[96], 0);
    TextDrawBackgroundColor(MainInv[96], 255);
    TextDrawFont(MainInv[96], 4);
    TextDrawSetProportional(MainInv[96], 0);

    MainInv[97] = TextDrawCreate(302.436279, 336.984375, "LD_SPAC:white");
    TextDrawTextSize(MainInv[97], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[97], 1);
    TextDrawColor(MainInv[97], -1);
    TextDrawSetShadow(MainInv[97], 0);
    TextDrawBackgroundColor(MainInv[97], 255);
    TextDrawFont(MainInv[97], 4);
    TextDrawSetProportional(MainInv[97], 0);

    MainInv[98] = TextDrawCreate(260.235626, 293.246856, "LD_SPAC:white");
    TextDrawTextSize(MainInv[98], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[98], 1);
    TextDrawColor(MainInv[98], -1);
    TextDrawSetShadow(MainInv[98], 0);
    TextDrawBackgroundColor(MainInv[98], 255);
    TextDrawFont(MainInv[98], 4);
    TextDrawSetProportional(MainInv[98], 0);

    MainInv[99] = TextDrawCreate(335.852416, 292.794586, "LD_SPAC:white");
    TextDrawTextSize(MainInv[99], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[99], 1);
    TextDrawColor(MainInv[99], -1);
    TextDrawSetShadow(MainInv[99], 0);
    TextDrawBackgroundColor(MainInv[99], 255);
    TextDrawFont(MainInv[99], 4);
    TextDrawSetProportional(MainInv[99], 0);

    MainInv[100] = TextDrawCreate(314.169464, 337.002838, "LD_SPAC:white");
    TextDrawTextSize(MainInv[100], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[100], 1);
    TextDrawColor(MainInv[100], -1);
    TextDrawSetShadow(MainInv[100], 0);
    TextDrawBackgroundColor(MainInv[100], 255);
    TextDrawFont(MainInv[100], 4);
    TextDrawSetProportional(MainInv[100], 0);

    MainInv[101] = TextDrawCreate(314.169464, 337.002838, "LD_SPAC:white");
    TextDrawTextSize(MainInv[101], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[101], 1);
    TextDrawColor(MainInv[101], -1);
    TextDrawSetShadow(MainInv[101], 0);
    TextDrawBackgroundColor(MainInv[101], 255);
    TextDrawFont(MainInv[101], 4);
    TextDrawSetProportional(MainInv[101], 0);

    MainInv[102] = TextDrawCreate(356.436737, 336.984344, "LD_SPAC:white");
    TextDrawTextSize(MainInv[102], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[102], 1);
    TextDrawColor(MainInv[102], -1);
    TextDrawSetShadow(MainInv[102], 0);
    TextDrawBackgroundColor(MainInv[102], 255);
    TextDrawFont(MainInv[102], 4);
    TextDrawSetProportional(MainInv[102], 0);

    MainInv[103] = TextDrawCreate(314.236083, 293.246856, "LD_SPAC:white");
    TextDrawTextSize(MainInv[103], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[103], 1);
    TextDrawColor(MainInv[103], -1);
    TextDrawSetShadow(MainInv[103], 0);
    TextDrawBackgroundColor(MainInv[103], 255);
    TextDrawFont(MainInv[103], 4);
    TextDrawSetProportional(MainInv[103], 0);

    MainInv[104] = TextDrawCreate(67.850151, 231.300811, "LD_SPAC:white");
    TextDrawTextSize(MainInv[104], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[104], 1);
    TextDrawColor(MainInv[104], -1);
    TextDrawSetShadow(MainInv[104], 0);
    TextDrawBackgroundColor(MainInv[104], 255);
    TextDrawFont(MainInv[104], 4);
    TextDrawSetProportional(MainInv[104], 0);

    MainInv[105] = TextDrawCreate(46.167175, 275.509124, "LD_SPAC:white");
    TextDrawTextSize(MainInv[105], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[105], 1);
    TextDrawColor(MainInv[105], -1);
    TextDrawSetShadow(MainInv[105], 0);
    TextDrawBackgroundColor(MainInv[105], 255);
    TextDrawFont(MainInv[105], 4);
    TextDrawSetProportional(MainInv[105], 0);

    MainInv[106] = TextDrawCreate(46.167175, 275.509124, "LD_SPAC:white");
    TextDrawTextSize(MainInv[106], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[106], 1);
    TextDrawColor(MainInv[106], -1);
    TextDrawSetShadow(MainInv[106], 0);
    TextDrawBackgroundColor(MainInv[106], 255);
    TextDrawFont(MainInv[106], 4);
    TextDrawSetProportional(MainInv[106], 0);

    MainInv[107] = TextDrawCreate(88.433799, 275.490661, "LD_SPAC:white");
    TextDrawTextSize(MainInv[107], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[107], 1);
    TextDrawColor(MainInv[107], -1);
    TextDrawSetShadow(MainInv[107], 0);
    TextDrawBackgroundColor(MainInv[107], 255);
    TextDrawFont(MainInv[107], 4);
    TextDrawSetProportional(MainInv[107], 0);

    MainInv[108] = TextDrawCreate(46.233863, 231.434570, "LD_SPAC:white");
    TextDrawTextSize(MainInv[108], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[108], 1);
    TextDrawColor(MainInv[108], -1);
    TextDrawSetShadow(MainInv[108], 0);
    TextDrawBackgroundColor(MainInv[108], 255);
    TextDrawFont(MainInv[108], 4);
    TextDrawSetProportional(MainInv[108], 0);

    MainInv[109] = TextDrawCreate(120.816658, 231.300796, "LD_SPAC:white");
    TextDrawTextSize(MainInv[109], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[109], 1);
    TextDrawColor(MainInv[109], -1);
    TextDrawSetShadow(MainInv[109], 0);
    TextDrawBackgroundColor(MainInv[109], 255);
    TextDrawFont(MainInv[109], 4);
    TextDrawSetProportional(MainInv[109], 0);

    MainInv[110] = TextDrawCreate(99.133583, 275.509155, "LD_SPAC:white");
    TextDrawTextSize(MainInv[110], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[110], 1);
    TextDrawColor(MainInv[110], -1);
    TextDrawSetShadow(MainInv[110], 0);
    TextDrawBackgroundColor(MainInv[110], 255);
    TextDrawFont(MainInv[110], 4);
    TextDrawSetProportional(MainInv[110], 0);

    MainInv[111] = TextDrawCreate(99.133583, 275.509155, "LD_SPAC:white");
    TextDrawTextSize(MainInv[111], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[111], 1);
    TextDrawColor(MainInv[111], -1);
    TextDrawSetShadow(MainInv[111], 0);
    TextDrawBackgroundColor(MainInv[111], 255);
    TextDrawFont(MainInv[111], 4);
    TextDrawSetProportional(MainInv[111], 0);

    MainInv[112] = TextDrawCreate(141.400985, 275.490661, "LD_SPAC:white");
    TextDrawTextSize(MainInv[112], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[112], 1);
    TextDrawColor(MainInv[112], -1);
    TextDrawSetShadow(MainInv[112], 0);
    TextDrawBackgroundColor(MainInv[112], 255);
    TextDrawFont(MainInv[112], 4);
    TextDrawSetProportional(MainInv[112], 0);

    MainInv[113] = TextDrawCreate(99.200271, 231.434555, "LD_SPAC:white");
    TextDrawTextSize(MainInv[113], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[113], 1);
    TextDrawColor(MainInv[113], -1);
    TextDrawSetShadow(MainInv[113], 0);
    TextDrawBackgroundColor(MainInv[113], 255);
    TextDrawFont(MainInv[113], 4);
    TextDrawSetProportional(MainInv[113], 0);

    MainInv[114] = TextDrawCreate(174.100708, 231.300796, "LD_SPAC:white");
    TextDrawTextSize(MainInv[114], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[114], 1);
    TextDrawColor(MainInv[114], -1);
    TextDrawSetShadow(MainInv[114], 0);
    TextDrawBackgroundColor(MainInv[114], 255);
    TextDrawFont(MainInv[114], 4);
    TextDrawSetProportional(MainInv[114], 0);

    MainInv[115] = TextDrawCreate(152.417648, 275.509155, "LD_SPAC:white");
    TextDrawTextSize(MainInv[115], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[115], 1);
    TextDrawColor(MainInv[115], -1);
    TextDrawSetShadow(MainInv[115], 0);
    TextDrawBackgroundColor(MainInv[115], 255);
    TextDrawFont(MainInv[115], 4);
    TextDrawSetProportional(MainInv[115], 0);

    MainInv[116] = TextDrawCreate(152.417648, 275.509155, "LD_SPAC:white");
    TextDrawTextSize(MainInv[116], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[116], 1);
    TextDrawColor(MainInv[116], -1);
    TextDrawSetShadow(MainInv[116], 0);
    TextDrawBackgroundColor(MainInv[116], 255);
    TextDrawFont(MainInv[116], 4);
    TextDrawSetProportional(MainInv[116], 0);

    MainInv[117] = TextDrawCreate(194.685028, 275.490661, "LD_SPAC:white");
    TextDrawTextSize(MainInv[117], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[117], 1);
    TextDrawColor(MainInv[117], -1);
    TextDrawSetShadow(MainInv[117], 0);
    TextDrawBackgroundColor(MainInv[117], 255);
    TextDrawFont(MainInv[117], 4);
    TextDrawSetProportional(MainInv[117], 0);

    MainInv[118] = TextDrawCreate(152.484329, 231.434555, "LD_SPAC:white");
    TextDrawTextSize(MainInv[118], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[118], 1);
    TextDrawColor(MainInv[118], -1);
    TextDrawSetShadow(MainInv[118], 0);
    TextDrawBackgroundColor(MainInv[118], 255);
    TextDrawFont(MainInv[118], 4);
    TextDrawSetProportional(MainInv[118], 0);

    MainInv[119] = TextDrawCreate(227.901306, 231.419326, "LD_SPAC:white");
    TextDrawTextSize(MainInv[119], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[119], 1);
    TextDrawColor(MainInv[119], -1);
    TextDrawSetShadow(MainInv[119], 0);
    TextDrawBackgroundColor(MainInv[119], 255);
    TextDrawFont(MainInv[119], 4);
    TextDrawSetProportional(MainInv[119], 0);

    MainInv[120] = TextDrawCreate(206.218246, 275.627624, "LD_SPAC:white");
    TextDrawTextSize(MainInv[120], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[120], 1);
    TextDrawColor(MainInv[120], -1);
    TextDrawSetShadow(MainInv[120], 0);
    TextDrawBackgroundColor(MainInv[120], 255);
    TextDrawFont(MainInv[120], 4);
    TextDrawSetProportional(MainInv[120], 0);

    MainInv[121] = TextDrawCreate(206.218246, 275.627624, "LD_SPAC:white");
    TextDrawTextSize(MainInv[121], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[121], 1);
    TextDrawColor(MainInv[121], -1);
    TextDrawSetShadow(MainInv[121], 0);
    TextDrawBackgroundColor(MainInv[121], 255);
    TextDrawFont(MainInv[121], 4);
    TextDrawSetProportional(MainInv[121], 0);

    MainInv[122] = TextDrawCreate(248.485610, 275.609161, "LD_SPAC:white");
    TextDrawTextSize(MainInv[122], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[122], 1);
    TextDrawColor(MainInv[122], -1);
    TextDrawSetShadow(MainInv[122], 0);
    TextDrawBackgroundColor(MainInv[122], 255);
    TextDrawFont(MainInv[122], 4);
    TextDrawSetProportional(MainInv[122], 0);

    MainInv[123] = TextDrawCreate(206.284881, 231.871612, "LD_SPAC:white");
    TextDrawTextSize(MainInv[123], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[123], 1);
    TextDrawColor(MainInv[123], -1);
    TextDrawSetShadow(MainInv[123], 0);
    TextDrawBackgroundColor(MainInv[123], 255);
    TextDrawFont(MainInv[123], 4);
    TextDrawSetProportional(MainInv[123], 0);

    MainInv[124] = TextDrawCreate(281.851928, 231.400817, "LD_SPAC:white");
    TextDrawTextSize(MainInv[124], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[124], 1);
    TextDrawColor(MainInv[124], -1);
    TextDrawSetShadow(MainInv[124], 0);
    TextDrawBackgroundColor(MainInv[124], 255);
    TextDrawFont(MainInv[124], 4);
    TextDrawSetProportional(MainInv[124], 0);

    MainInv[125] = TextDrawCreate(260.168975, 275.609130, "LD_SPAC:white");
    TextDrawTextSize(MainInv[125], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[125], 1);
    TextDrawColor(MainInv[125], -1);
    TextDrawSetShadow(MainInv[125], 0);
    TextDrawBackgroundColor(MainInv[125], 255);
    TextDrawFont(MainInv[125], 4);
    TextDrawSetProportional(MainInv[125], 0);

    MainInv[126] = TextDrawCreate(260.168975, 275.609130, "LD_SPAC:white");
    TextDrawTextSize(MainInv[126], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[126], 1);
    TextDrawColor(MainInv[126], -1);
    TextDrawSetShadow(MainInv[126], 0);
    TextDrawBackgroundColor(MainInv[126], 255);
    TextDrawFont(MainInv[126], 4);
    TextDrawSetProportional(MainInv[126], 0);

    MainInv[127] = TextDrawCreate(302.436248, 275.590637, "LD_SPAC:white");
    TextDrawTextSize(MainInv[127], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[127], 1);
    TextDrawColor(MainInv[127], -1);
    TextDrawSetShadow(MainInv[127], 0);
    TextDrawBackgroundColor(MainInv[127], 255);
    TextDrawFont(MainInv[127], 4);
    TextDrawSetProportional(MainInv[127], 0);

    MainInv[128] = TextDrawCreate(260.235595, 231.853103, "LD_SPAC:white");
    TextDrawTextSize(MainInv[128], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[128], 1);
    TextDrawColor(MainInv[128], -1);
    TextDrawSetShadow(MainInv[128], 0);
    TextDrawBackgroundColor(MainInv[128], 255);
    TextDrawFont(MainInv[128], 4);
    TextDrawSetProportional(MainInv[128], 0);

    MainInv[129] = TextDrawCreate(335.852386, 231.400833, "LD_SPAC:white");
    TextDrawTextSize(MainInv[129], 21.000000, 0.460000);
    TextDrawAlignment(MainInv[129], 1);
    TextDrawColor(MainInv[129], -1);
    TextDrawSetShadow(MainInv[129], 0);
    TextDrawBackgroundColor(MainInv[129], 255);
    TextDrawFont(MainInv[129], 4);
    TextDrawSetProportional(MainInv[129], 0);

    MainInv[130] = TextDrawCreate(314.169433, 275.609100, "LD_SPAC:white");
    TextDrawTextSize(MainInv[130], 42.570072, 0.410000);
    TextDrawAlignment(MainInv[130], 1);
    TextDrawColor(MainInv[130], -1);
    TextDrawSetShadow(MainInv[130], 0);
    TextDrawBackgroundColor(MainInv[130], 255);
    TextDrawFont(MainInv[130], 4);
    TextDrawSetProportional(MainInv[130], 0);

    MainInv[131] = TextDrawCreate(314.169433, 275.609100, "LD_SPAC:white");
    TextDrawTextSize(MainInv[131], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[131], 1);
    TextDrawColor(MainInv[131], -1);
    TextDrawSetShadow(MainInv[131], 0);
    TextDrawBackgroundColor(MainInv[131], 255);
    TextDrawFont(MainInv[131], 4);
    TextDrawSetProportional(MainInv[131], 0);

    MainInv[132] = TextDrawCreate(356.436706, 275.590606, "LD_SPAC:white");
    TextDrawTextSize(MainInv[132], 0.430001, -44.000000);
    TextDrawAlignment(MainInv[132], 1);
    TextDrawColor(MainInv[132], -1);
    TextDrawSetShadow(MainInv[132], 0);
    TextDrawBackgroundColor(MainInv[132], 255);
    TextDrawFont(MainInv[132], 4);
    TextDrawSetProportional(MainInv[132], 0);

    MainInv[133] = TextDrawCreate(314.236053, 231.853118, "LD_SPAC:white");
    TextDrawTextSize(MainInv[133], 5.000000, 0.380000);
    TextDrawAlignment(MainInv[133], 1);
    TextDrawColor(MainInv[133], -1);
    TextDrawSetShadow(MainInv[133], 0);
    TextDrawBackgroundColor(MainInv[133], 255);
    TextDrawFont(MainInv[133], 4);
    TextDrawSetProportional(MainInv[133], 0);

    MainInv[134] = TextDrawCreate(413.533294, 101.818450, "LD_SPAC:white");
    TextDrawTextSize(MainInv[134], 2.000000, 32.000000);
    TextDrawAlignment(MainInv[134], 1);
    TextDrawColor(MainInv[134], -1);
    TextDrawSetShadow(MainInv[134], 0);
    TextDrawBackgroundColor(MainInv[134], 255);
    TextDrawFont(MainInv[134], 4);
    TextDrawSetProportional(MainInv[134], 0);

    MainInv[135] = TextDrawCreate(413.533264, 144.214752, "LD_SPAC:white");
    TextDrawTextSize(MainInv[135], 2.000000, 32.000000);
    TextDrawAlignment(MainInv[135], 1);
    TextDrawColor(MainInv[135], -1);
    TextDrawSetShadow(MainInv[135], 0);
    TextDrawBackgroundColor(MainInv[135], 255);
    TextDrawFont(MainInv[135], 4);
    TextDrawSetProportional(MainInv[135], 0);

    MainInv[136] = TextDrawCreate(413.533264, 187.840911, "LD_SPAC:white");
    TextDrawTextSize(MainInv[136], 2.000000, 32.000000);
    TextDrawAlignment(MainInv[136], 1);
    TextDrawColor(MainInv[136], -1);
    TextDrawSetShadow(MainInv[136], 0);
    TextDrawBackgroundColor(MainInv[136], 255);
    TextDrawFont(MainInv[136], 4);
    TextDrawSetProportional(MainInv[136], 0);

    MainInv[137] = TextDrawCreate(406.766540, 133.407379, "LD_SPAC:white");
    TextDrawTextSize(MainInv[137], 35.000000, 0.470000);
    TextDrawAlignment(MainInv[137], 1);
    TextDrawColor(MainInv[137], -1);
    TextDrawSetShadow(MainInv[137], 0);
    TextDrawBackgroundColor(MainInv[137], 255);
    TextDrawFont(MainInv[137], 4);
    TextDrawSetProportional(MainInv[137], 0);

    MainInv[138] = TextDrawCreate(406.966583, 175.925872, "LD_SPAC:white");
    TextDrawTextSize(MainInv[138], 35.000000, 0.470000);
    TextDrawAlignment(MainInv[138], 1);
    TextDrawColor(MainInv[138], -1);
    TextDrawSetShadow(MainInv[138], 0);
    TextDrawBackgroundColor(MainInv[138], 255);
    TextDrawFont(MainInv[138], 4);
    TextDrawSetProportional(MainInv[138], 0);

    MainInv[139] = TextDrawCreate(406.433319, 219.481414, "LD_SPAC:white");
    TextDrawTextSize(MainInv[139], 35.000000, 0.470000);
    TextDrawAlignment(MainInv[139], 1);
    TextDrawColor(MainInv[139], -1);
    TextDrawSetShadow(MainInv[139], 0);
    TextDrawBackgroundColor(MainInv[139], 255);
    TextDrawFont(MainInv[139], 4);
    TextDrawSetProportional(MainInv[139], 0);

    MainInv[140] = TextDrawCreate(396.249969, 125.903678, "....");
    TextDrawLetterSize(MainInv[140], 0.193750, 1.008889);
    TextDrawAlignment(MainInv[140], 1);
    TextDrawColor(MainInv[140], -1);
    TextDrawSetShadow(MainInv[140], 0);
    TextDrawBackgroundColor(MainInv[140], 255);
    TextDrawFont(MainInv[140], 2);
    TextDrawSetProportional(MainInv[140], 1);

    MainInv[141] = TextDrawCreate(396.250030, 168.703720, "....");
    TextDrawLetterSize(MainInv[141], 0.193750, 1.008889);
    TextDrawAlignment(MainInv[141], 1);
    TextDrawColor(MainInv[141], -1);
    TextDrawSetShadow(MainInv[141], 0);
    TextDrawBackgroundColor(MainInv[141], 255);
    TextDrawFont(MainInv[141], 2);
    TextDrawSetProportional(MainInv[141], 1);

    MainInv[142] = TextDrawCreate(396.250122, 212.159255, "....");
    TextDrawLetterSize(MainInv[142], 0.193750, 1.008889);
    TextDrawAlignment(MainInv[142], 1);
    TextDrawColor(MainInv[142], -1);
    TextDrawSetShadow(MainInv[142], 0);
    TextDrawBackgroundColor(MainInv[142], 255);
    TextDrawFont(MainInv[142], 2);
    TextDrawSetProportional(MainInv[142], 1);

    MainInv[143] = TextDrawCreate(375.700164, 135.870346, "");
    TextDrawTextSize(MainInv[143], 33.000000, 32.000000);
    TextDrawAlignment(MainInv[143], 1);
    TextDrawColor(MainInv[143], -1);
    TextDrawSetShadow(MainInv[143], 0);
    TextDrawFont(MainInv[143], 5);
    TextDrawSetProportional(MainInv[143], 0);
    TextDrawSetSelectable(MainInv[143], true);
    TextDrawSetPreviewModel(MainInv[143], 352);
    TextDrawBackgroundColor(MainInv[143], 0x00000000);
    TextDrawSetPreviewRot(MainInv[143], 0.000000, 0.000000, 160.000000, 1.000000);

    MainInv[144] = TextDrawCreate(383.083343, 90.822257, "");
    TextDrawTextSize(MainInv[144], 29.000000, 41.000000);
    TextDrawAlignment(MainInv[144], 1);
    TextDrawColor(MainInv[144], -1);
    TextDrawSetShadow(MainInv[144], 0);
    TextDrawFont(MainInv[144], 5);
    TextDrawSetProportional(MainInv[144], 0);
    TextDrawSetSelectable(MainInv[144], true);
    TextDrawSetPreviewModel(MainInv[144], 19592);
    TextDrawBackgroundColor(MainInv[144], 0x00000000);
    TextDrawSetPreviewRot(MainInv[144], 0.000000, 0.000000, 0.000000, 1.000000);

    MainInv[145] = TextDrawCreate(387.849975, 168.969512, "");
    TextDrawTextSize(MainInv[145], 20.000000, 54.000000);
    TextDrawAlignment(MainInv[145], 1);
    TextDrawColor(MainInv[145], -1);
    TextDrawSetShadow(MainInv[145], 0);
    TextDrawFont(MainInv[145], 5);
    TextDrawSetProportional(MainInv[145], 0);
    TextDrawSetSelectable(MainInv[145], true);
    TextDrawSetPreviewModel(MainInv[145], 1575);
    TextDrawBackgroundColor(MainInv[145], 0x00000000);
    TextDrawSetPreviewRot(MainInv[145], 60.000000, 0.000000, 0.000000, 1.000000);

    MainInv[146] = TextDrawCreate(446.349914, 129.770355, "STVARI");
    TextDrawLetterSize(MainInv[146], 0.119583, 0.702962);
    TextDrawAlignment(MainInv[146], 1);
    TextDrawColor(MainInv[146], -1);
    TextDrawSetShadow(MainInv[146], 0);
    TextDrawBackgroundColor(MainInv[146], 255);
    TextDrawFont(MainInv[146], 2);
    TextDrawSetProportional(MainInv[146], 1);

    MainInv[147] = TextDrawCreate(446.349914, 171.941055, "ORUZJE");
    TextDrawLetterSize(MainInv[147], 0.119583, 0.702962);
    TextDrawAlignment(MainInv[147], 1);
    TextDrawColor(MainInv[147], -1);
    TextDrawSetShadow(MainInv[147], 0);
    TextDrawBackgroundColor(MainInv[147], 255);
    TextDrawFont(MainInv[147], 2);
    TextDrawSetProportional(MainInv[147], 1);

    MainInv[148] = TextDrawCreate(446.349914, 215.474822, "DROGA");
    TextDrawLetterSize(MainInv[148], 0.119583, 0.702962);
    TextDrawAlignment(MainInv[148], 1);
    TextDrawColor(MainInv[148], -1);
    TextDrawSetShadow(MainInv[148], 0);
    TextDrawBackgroundColor(MainInv[148], 255);
    TextDrawFont(MainInv[148], 2);
    TextDrawSetProportional(MainInv[148], 1);

    MainInv[149] = TextDrawCreate(398.549865, 242.929641, "LD_SPAC:white");
    TextDrawTextSize(MainInv[149], 0.340000, 58.000000);
    TextDrawAlignment(MainInv[149], 1);
    TextDrawColor(MainInv[149], -1);
    TextDrawSetShadow(MainInv[149], 0);
    TextDrawBackgroundColor(MainInv[149], 255);
    TextDrawFont(MainInv[149], 4);
    TextDrawSetProportional(MainInv[149], 0);

    MainInv[150] = TextDrawCreate(398.549835, 301.381896, "LD_SPAC:white");
    TextDrawTextSize(MainInv[150], 32.000000, 0.500000);
    TextDrawAlignment(MainInv[150], 1);
    TextDrawColor(MainInv[150], -1);
    TextDrawSetShadow(MainInv[150], 0);
    TextDrawBackgroundColor(MainInv[150], 255);
    TextDrawFont(MainInv[150], 4);
    TextDrawSetProportional(MainInv[150], 0);

    MainInv[151] = TextDrawCreate(440.900451, 297.670379, "/");
    TextDrawLetterSize(MainInv[151], -0.325416, 0.537037);
    TextDrawAlignment(MainInv[151], 1);
    TextDrawColor(MainInv[151], -1);
    TextDrawSetShadow(MainInv[151], 0);
    TextDrawBackgroundColor(MainInv[151], 255);
    TextDrawFont(MainInv[151], 3);
    TextDrawSetProportional(MainInv[151], 1);

    MainInv[152] = TextDrawCreate(440.900451, 297.670379, "/");
    TextDrawLetterSize(MainInv[152], -0.325416, 0.537037);
    TextDrawAlignment(MainInv[152], 1);
    TextDrawColor(MainInv[152], -1);
    TextDrawSetShadow(MainInv[152], 0);
    TextDrawBackgroundColor(MainInv[152], 255);
    TextDrawFont(MainInv[152], 3);
    TextDrawSetProportional(MainInv[152], 1);

    MainInv[153] = TextDrawCreate(444.033660, 304.511230, "/");
    TextDrawLetterSize(MainInv[153], -0.383333, -1.013333);
    TextDrawAlignment(MainInv[153], 1);
    TextDrawColor(MainInv[153], -1);
    TextDrawSetShadow(MainInv[153], 0);
    TextDrawBackgroundColor(MainInv[153], 255);
    TextDrawFont(MainInv[153], 3);
    TextDrawSetProportional(MainInv[153], 1);

    MainInv[154] = TextDrawCreate(444.033660, 304.511230, "/");
    TextDrawLetterSize(MainInv[154], -0.383333, -1.013333);
    TextDrawAlignment(MainInv[154], 1);
    TextDrawColor(MainInv[154], -1);
    TextDrawSetShadow(MainInv[154], 0);
    TextDrawBackgroundColor(MainInv[154], 255);
    TextDrawFont(MainInv[154], 3);
    TextDrawSetProportional(MainInv[154], 1);

    MainInv[155] = TextDrawCreate(449.783294, 297.851806, "KORISTI_LIJEVI_KLIK_DA_ODABERES_VRSTU_ARTIKALA");
    TextDrawLetterSize(MainInv[155], 0.132916, 0.635555);
    TextDrawAlignment(MainInv[155], 1);
    TextDrawColor(MainInv[155], -1);
    TextDrawSetShadow(MainInv[155], 0);
    TextDrawBackgroundColor(MainInv[155], 255);
    TextDrawFont(MainInv[155], 2);
    TextDrawSetProportional(MainInv[155], 1);
}

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

stock BP_SetItemModelID(itemid, modelid)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID)
    {
        BP_itemModelID[itemid - ITEM_MIN_ID] = modelid;
    }
}

stock BP_GetItemModelID(itemid)
{
    if (itemid >= ITEM_MIN_ID && itemid <= ITEM_MAX_ID)
    {
        return BP_itemModelID[itemid - ITEM_MIN_ID];
    }
    return 0;
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
            return callcmd::popravi(playerid, "");
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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    BP_managingItemID[playerid] = -1;

    new
        itemcountf,
        stringt[6]
    ;
    
    for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
            || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

        itemcountf += 2;

        if (i == ITEM_MATERIALS)
        {
            format(stringt, sizeof stringt, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
        }
        else
        {
            format(stringt, sizeof stringt, "%i", BP_PlayerItemGetCount(playerid, i));
        }

        ItemInv[playerid][itemcountf-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf-1][TD_X], ItemTDInfo[itemcountf-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountf-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountf-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountf-2], BP_GetItemModelID(i));
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountf-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountf-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf][TD_X], ItemTDInfo[itemcountf][TD_Y], stringt);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountf-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountf-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-1]);
    }

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

// Dialogs;
Dialog:backpack_drugs_manage(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

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
        return 1;

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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    BP_managingItemID[playerid] = -1;

    new
        itemcountf,
        stringt[6]
    ;
    
    for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
            || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

        itemcountf += 2;

        if (i == ITEM_MATERIALS)
        {
            format(stringt, sizeof stringt, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
        }
        else
        {
            format(stringt, sizeof stringt, "%i", BP_PlayerItemGetCount(playerid, i));
        }

        ItemInv[playerid][itemcountf-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf-1][TD_X], ItemTDInfo[itemcountf-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountf-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountf-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountf-2], BP_GetItemModelID(i));
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountf-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountf-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf][TD_X], ItemTDInfo[itemcountf][TD_Y], stringt);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountf-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountf-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-1]);
    }
    return 1;
}

Dialog:backpack_drugs_manage_throw(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    BP_managingItemID[playerid] = -1;

    new
        itemcountf,
        stringt[6]
    ;
    
    for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
            || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

        itemcountf += 2;

        if (i == ITEM_MATERIALS)
        {
            format(stringt, sizeof stringt, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
        }
        else
        {
            format(stringt, sizeof stringt, "%i", BP_PlayerItemGetCount(playerid, i));
        }

        ItemInv[playerid][itemcountf-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf-1][TD_X], ItemTDInfo[itemcountf-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountf-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountf-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountf-2], BP_GetItemModelID(i));
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountf-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountf-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf][TD_X], ItemTDInfo[itemcountf][TD_Y], stringt);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountf-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountf-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-1]);
    }

    return 1;
}

Dialog:backpack_items_manage(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

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
        return 1;

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
        return 1;

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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    BP_managingItemID[playerid] = -1;

    new
        itemcountf,
        stringt[6]
    ;
    
    for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
            || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;

        itemcountf += 2;

        if (i == ITEM_MATERIALS)
        {
            format(stringt, sizeof stringt, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
        }
        else
        {
            format(stringt, sizeof stringt, "%i", BP_PlayerItemGetCount(playerid, i));
        }

        ItemInv[playerid][itemcountf-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf-1][TD_X], ItemTDInfo[itemcountf-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountf-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountf-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountf-2], BP_GetItemModelID(i));
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountf-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountf-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountf][TD_X], ItemTDInfo[itemcountf][TD_Y], stringt);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountf-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountf-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountf-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountf-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountf-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountf-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountf-1]);
    }
    return 1;
}

Dialog:backpack_weapons_take(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

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
        return 1;
    
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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    new stringw[6], itemcountl, weaponmodel;
    for(new i = 0; i < BP_MAX_WEAPONS; i++) 
    {
        if (P_BACKPACK[playerid][BP_WEAPON][i] == -1 || P_BACKPACK[playerid][BP_AMMO][i] <= 0) continue;
        itemcountl += 2;
        switch(P_BACKPACK[playerid][BP_WEAPON][i])
        {
            case 24: weaponmodel = 348;
            case 34: weaponmodel = 358;
            case 22: weaponmodel = 346;
            case 4: weaponmodel = 335;
            case 29: weaponmodel = 353;
            case 32: weaponmodel = 372;
            case 31: weaponmodel = 356;
            case 23: weaponmodel = 347;
            case 25: weaponmodel = 349;
            case 33: weaponmodel = 357;
            case 30: weaponmodel = 355;
            default: weaponmodel = -1;
        }

        ItemInv[playerid][itemcountl-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl-1][TD_X], ItemTDInfo[itemcountl-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountl-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountl-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountl-2], weaponmodel);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountl-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountl-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl][TD_X], ItemTDInfo[itemcountl][TD_Y], stringw);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountl-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountl-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountl-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-1]);
    }

    return 1;
}

Dialog:backpack_weapons_put(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;

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
        return 1;
    
    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
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

            if ((P_BACKPACK[playerid][BP_AMMO][i] + input) > 1000)
            {
                ErrorMsg(playerid, "Mozete ubaciti najvise 1000 metaka u ranac. Vec ih imate %d za ovaj slot.", P_BACKPACK[playerid][BP_AMMO][i]);
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

    for(new i = 0; i < 48; i++)
    {
        if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
            PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
            ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
        if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
        {
            PlayerTextDrawHide(playerid, PutGun[playerid][i]);
            PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
            PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }

    new stringw[6], itemcountl, weaponmodel;
    for(new i = 0; i < BP_MAX_WEAPONS; i++) 
    {
        if (P_BACKPACK[playerid][BP_WEAPON][i] == -1 || P_BACKPACK[playerid][BP_AMMO][i] <= 0) continue;
        itemcountl += 2;
        switch(P_BACKPACK[playerid][BP_WEAPON][i])
        {
            case 24: weaponmodel = 348;
            case 34: weaponmodel = 358;
            case 22: weaponmodel = 346;
            case 4: weaponmodel = 335;
            case 29: weaponmodel = 353;
            case 32: weaponmodel = 372;
            case 31: weaponmodel = 356;
            case 23: weaponmodel = 347;
            case 25: weaponmodel = 349;
            case 33: weaponmodel = 357;
            case 30: weaponmodel = 355;
            case 3: weaponmodel = 334;
            case 5: weaponmodel = 336;
            case 14: weaponmodel = 325;
            case 42: weaponmodel = 366;
            case 1: weaponmodel = 331;
            default: weaponmodel = -1;
        }

        ItemInv[playerid][itemcountl-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl-1][TD_X], ItemTDInfo[itemcountl-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcountl-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcountl-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcountl-2], weaponmodel);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-2], i);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcountl-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcountl-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcountl][TD_X], ItemTDInfo[itemcountl][TD_Y], stringw);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcountl-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcountl-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcountl-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcountl-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcountl-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcountl-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcountl-1], 1);

        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcountl-1]);
    }

    return true;
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

// Commands;
CMD:ranac(playerid, const params[])
{
    if(IsPlayerInDMArena(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac dok ste u DM areni.");
        
    if (!BP_PlayerHasBackpack(playerid))
        return ErrorMsg(playerid, "Ne posedujete ranac. Mozete ga kupiti u bilo kom marketu ili prodavnici tehnike.");

    if (IsPlayerJailed(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac kada ste u zatvoru.");

    if (IsPlayerInDMEvent(playerid) || IsPlayerInHorrorEvent(playerid) || IsPlayerInLMSEvent(playerid) || IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ranac na Eventu.");

    if(InBP[playerid])
    {
        for(new i = 0; i < 48; i++)
        {
            if(ItemInv[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, ItemInv[playerid][i]);
                PlayerTextDrawDestroy(playerid, ItemInv[playerid][i]);
                ItemInv[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
            if(i < 3 && PutGun[playerid][i] != INVALID_PLAYER_TEXT_DRAW)
            {
                PlayerTextDrawHide(playerid, PutGun[playerid][i]);
                PlayerTextDrawDestroy(playerid, PutGun[playerid][i]);
                PutGun[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
            }
        }
        InBP[playerid] = false;
        for(new j = 0; j < sizeof MainInv; j++)
        {
            if(MainInv[j] != INVALID_TEXT_DRAW)
            {
                TextDrawHideForPlayer(playerid, MainInv[j]);
            }
        }
        CancelSelectTextDraw(playerid);
        ptdInfoBox_Show(playerid);
        ptdInfoBox_UpdateWantedLevel(playerid);
        return 1;
    }
    //ClearChatForPlayer(playerid);
    BP_managingItemID[playerid] = -1;

    ptdInfoBox_Hide(playerid);
    ptdInfoBox_HideWanted(playerid);

    InBP[playerid] = true;

    for(new j = 0; j < sizeof MainInv; j++)
        TextDrawShowForPlayer(playerid, MainInv[j]);

    new
        itemcount,
        string[6]
    ;
    
    for(new i = ITEM_MIN_ID; i <= ITEM_MAX_ID; i++)
    {
        if (i == ITEM_RANAC || BP_PlayerItemGetCount(playerid, i) <= 0 
            || i == ITEM_MDMA || i == ITEM_HEROIN || i == ITEM_WEED || i == ITEM_WEED_RAW) continue;
        
        itemcount += 2;

        if (i == ITEM_MATERIALS)
        {
            format(string, sizeof string, "%fkg", BP_PlayerItemGetCount(playerid, i)/1000.0);
        }
        else
        {
            format(string, sizeof string, "%i", BP_PlayerItemGetCount(playerid, i));
        }

        ItemInv[playerid][itemcount-2] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount-1][TD_X], ItemTDInfo[itemcount-1][TD_Y], "");
        PlayerTextDrawTextSize(playerid, ItemInv[playerid][itemcount-2], 34.000000, 45.000000);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-2], -1);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-2], 5);
        PlayerTextDrawSetSelectable(playerid, ItemInv[playerid][itemcount-2], true);
        PlayerTextDrawSetPreviewModel(playerid, ItemInv[playerid][itemcount-2], BP_GetItemModelID(i));
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-2], i); // ovo je jedna od najludjih stvari koje sam pokusao u zivotu xD
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, ItemInv[playerid][itemcount-2], 0.000000, 0.000000, 0.000000, 1.000000);

        ItemInv[playerid][itemcount-1] = CreatePlayerTextDraw(playerid, ItemTDInfo[itemcount][TD_X], ItemTDInfo[itemcount][TD_Y], string);
        PlayerTextDrawLetterSize(playerid, ItemInv[playerid][itemcount-1], 0.136666, 0.562962);
        PlayerTextDrawAlignment(playerid, ItemInv[playerid][itemcount-1], 2);
        PlayerTextDrawColor(playerid, ItemInv[playerid][itemcount-1], -1);
        PlayerTextDrawSetShadow(playerid, ItemInv[playerid][itemcount-1], 0);
        PlayerTextDrawBackgroundColor(playerid, ItemInv[playerid][itemcount-1], 255);
        PlayerTextDrawFont(playerid, ItemInv[playerid][itemcount-1], 2);
        PlayerTextDrawSetProportional(playerid, ItemInv[playerid][itemcount-1], 1);
        
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-2]);
        PlayerTextDrawShow(playerid, ItemInv[playerid][itemcount-1]);
    }

    SelectTextDraw(playerid, 0xFFFFFF99);
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
