#include <YSI_Coding\y_hooks>


forward Float:Tree_GetObjectModelZOffset(fruit);
forward Float:Tree_GetObjectRadius(fruit);

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_LAND  55
#define MAX_TREES 60

#define FRUIT_APPLE 1
#define FRUIT_PEAR  2
#define FRUIT_PLUM  3

// #define PRICE_APPLE 780
// #define PRICE_PEAR  870
// #define PRICE_PLUM  735
#define PRICE_APPLE 975
#define PRICE_PEAR  1095
#define PRICE_PLUM  930

#define MARKET_BIZ_ID 103 // ID firme pijace

#define MAX_LAND_PER_PLAYER 2

#define IsPlayerSeedingLand(%0) gSeedingLand{%0}
#define IsPlayerHarvestingLand(%0) gHarvestingLand{%0}
#define IsPlayerWateringLand(%0) gWateringLand{%0}
#define IsPlayerStealingFruit(%0) gStealingFruit{%0}




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_LAND_INFO
{
    LAND_OWNER[MAX_PLAYER_NAME],
    Float:LAND_POS[3],
    Float:LAND_RADIUS,
    LAND_PRICE,
    STREAMER_TAG_AREA:LAND_AREA,
    Text3D:LAND_LABEL,
    LAND_PICKUP,
    LAND_LABEL_TIMER,
    LAND_OWNER_LAST_ONLINE,
}

enum E_LAND_TREES
{
    TREE_ID,
    TREE_OWNER_ID,
    Float:TREE_POS[3],
    TREE_TYPE,
    TREE_PICKING_TIME,
    TREE_WATERING_TIME,
    TREE_OBJECT_ID,
    Text3D:TREE_LABEL,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    gPlayerOwnedLand[MAX_PLAYERS][MAX_LAND_PER_PLAYER],

    gSeedingFruitID[MAX_PLAYERS char],
    gSeedingLand[MAX_PLAYERS char],
    gHarvestingLand[MAX_PLAYERS char],
    gWateringLand[MAX_PLAYERS char],
    gStealingFruit[MAX_PLAYERS char],
    bool:gBlockKeyPress[MAX_PLAYERS char],

    Text3D:gMarketLabel,
    gMarketProducts[4],
    gMarketPrice[4],

    LandInfo[MAX_LAND][E_LAND_INFO],
    TreeInfo[MAX_LAND][MAX_TREES][E_LAND_TREES]
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    gMarketLabel = CreateDynamic3DTextLabel("[ Gradska pijaca ]", COLOR_MAGENTA_11, 1009.4080,-1350.8676,13.5065, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

    // Resetovanje svih imanja i drveca
    for__loop (new land = 0; land < sizeof LandInfo; land++)
    {
        Land_ResetVariables(land);

        for__loop (new tree = 0; tree < sizeof TreeInfo; tree++)
        {
            Tree_ResetVariables(land, tree);
        }
    }

    mysql_tquery(SQL, "SELECT * FROM land", "MySQL_LoadLand");
    mysql_tquery(SQL, "SELECT * FROM land_trees ORDER BY land", "MySQL_LoadLandTrees");
    mysql_tquery(SQL, "SELECT field, value FROM server_info WHERE field IN ('jabuka', 'kruska', 'sljiva')", "MySQL_LoadMarketplace");

    SetTimer("Land_UpdateActivityData", 60*60*1000, true);
    SetTimer("UpdateMarketPrices", 4*60*60*1000, true);


    /* Kapije na privatnim parcelama
    gGate_PremiumLand1 = CreateDynamicObject(19912, 1312.843994, 749.400329, 12.557115, 0.000000, 0.000000, 90.000000, 0, 0); 
    gGate_PremiumLand1_Status = false;

    gGate_PremiumLand2 = CreateDynamicObject(19912, 1113.992553, 749.400329, 12.587117, 0.000029, 0.000000, 90.000000, 0, 0);
    gGate_PremiumLand2_Status = false;*/
    return true;
}

hook OnPlayerConnect(playerid)
{
    // Deo resetovanja postoji i na OnPlayerEnterVehicle, OnPlayerSpawn

    gSeedingFruitID{playerid} = gSeedingLand{playerid} = gHarvestingLand{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
    gBlockKeyPress{playerid} = false;

    for__loop (new i = 0; i < MAX_LAND_PER_PLAYER; i++)
    {
        gPlayerOwnedLand[playerid][i] = 0;
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    new land = GetPlayerLandID(playerid);
    if (land != -1 && LandInfo[land][LAND_LABEL_TIMER] && Land_CheckOwnership(land, playerid))
    {
        KillTimer(LandInfo[land][LAND_LABEL_TIMER]);
        Land_DestroyTreeLabels(land);
    }
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (!(newkeys & KEY_SECONDARY_ATTACK) && oldkeys & KEY_SECONDARY_ATTACK) // Enter
    {
        if ((IsPlayerSeedingLand(playerid) || IsPlayerHarvestingLand(playerid) || IsPlayerWateringLand(playerid) || IsPlayerStealingFruit(playerid)) && !IsPlayerInAnyVehicle(playerid) && !gBlockKeyPress{playerid})
        {
            new land = GetPlayerLandID(playerid),
                Float:x, Float:y, Float:z, Float:a
            ;
            GetPlayerPos(playerid, x, y, z);
            GetPlayerFacingAngle(playerid, a);
            GetXYInFrontOfPoint(x, y, a, 1.5);

            if (land != -1 && land == IsPointInAnyLand(x, y, z))
            {
                if (Land_CheckOwnership(land, playerid))
                {
                    if (IsPlayerHarvestingLand(playerid))
                    {
                        for__loop (new tree = 0; tree < MAX_TREES; tree++)
                        {
                            if (Tree_Exists(land, tree) && IsPlayerInRangeOfPoint(playerid, 2.5, TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2]))
                            {
                                if (TreeInfo[land][tree][TREE_PICKING_TIME] > gettime())
                                {
                                    GameTextForPlayer(playerid, "~N~~N~~N~~R~~H~Nije vreme za branje!", 3000, 3);
                                }
                                else if (TreeInfo[land][tree][TREE_PICKING_TIME] <= gettime() <= (TreeInfo[land][tree][TREE_PICKING_TIME] + 48*3600))
                                {
                                    // U okviru vremena za branje
                                    new sMsg[41],
                                        fruit = TreeInfo[land][tree][TREE_TYPE],
                                        itemid = GetItemByFruit(fruit),
                                        sFruitName[10],
                                        quantity = 6 + random(2);

                                    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(playerid, itemid) + quantity))
                                        return ErrorMsg(playerid, "Nemate mesta za nove plodove u rancu.");

                                    BP_GetItemName(itemid, sFruitName, sizeof sFruitName);
                                    BP_PlayerItemAdd(playerid, itemid, quantity);

                                    format(sMsg, sizeof sMsg, "~N~~N~~N~~G~~H~Pokupio si plodove! %i kg", quantity);
                                    GameTextForPlayer(playerid, sMsg, 2500, 3);

                                    SendClientMessageF(playerid, BELA, "* Pokupio si plodove: %s | U rancu imas %i kg", sFruitName, BP_PlayerItemGetCount(playerid, itemid));

                                    TreeInfo[land][tree][TREE_PICKING_TIME] = gettime()+Tree_PickingTime(fruit);

                                    new sQuery[73];
                                    format(sQuery, sizeof sQuery, "UPDATE land_trees SET picking_time = %i WHERE id = %i", TreeInfo[land][tree][TREE_PICKING_TIME], TreeInfo[land][tree][TREE_ID]);
                                    mysql_tquery(SQL, sQuery);

                                    Tree_CreateInfoLabel(land, tree, playerid);

                                    new sLog[95];
                                    format(sLog, sizeof sLog, "Branje | %s | Imanje: %i | Drvo: %i | %s (%i)", ime_obicno[playerid], land, TreeInfo[land][tree][TREE_ID], sFruitName, quantity);
                                    Log_Write(LOG_LAND, sLog);
                                }
                                else
                                {
                                    // Isteklo je vreme za branje (48h), drvo je propalo, TODO: obavezno!!!
                                    ErrorMsg(playerid, "Isteklo je vreme za branje. Plodovi su propali.");
                                }
                            }
                        }
                    }

                    else if (IsPlayerSeedingLand(playerid))
                    {
                        new itemid = GetItemByFruitSeed(gSeedingFruitID{playerid});

                        if (BP_PlayerItemGetCount(playerid, itemid) <= 0)
                        {
                            new sItemName[25];
                            BP_GetItemName(itemid, sItemName, sizeof sItemName);

                            gSeedingLand{playerid} = gSeedingFruitID{playerid} = 0;
                            return ErrorMsg(playerid, "Potrosili ste sva semena (%s).", sItemName);
                        }

                        gBlockKeyPress{playerid} = true;

                        new sQuery[45];
                        format(sQuery, sizeof sQuery, "SELECT pos FROM land_trees WHERE land = %i", land);
                        mysql_tquery(SQL, sQuery, "MySQL_Land_CheckPlotOccupancy", "iiifff", playerid, cinc[playerid], land, x, y, z);
                    }

                    else if (IsPlayerWateringLand(playerid) && land == gWateringLand{playerid})
                    {
                        for__loop (new tree = 0; tree < MAX_TREES; tree++)
                        {
                            if (Tree_Exists(land, tree) && IsPlayerInRangeOfPoint(playerid, 2.5, TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2]))
                            {
                                if ((TreeInfo[land][tree][TREE_WATERING_TIME] + 6*3600) > gettime())
                                {
                                    GameTextForPlayer(playerid, "~N~~N~~N~~R~~H~Nije vreme za zalivanje!", 3000, 3);
                                }
                                else if ((TreeInfo[land][tree][TREE_WATERING_TIME] + 6*3600) <= gettime() <= (TreeInfo[land][tree][TREE_WATERING_TIME] + 18*3600))
                                {
                                    // U okviru vremena za zalivanje
                                    GameTextForPlayer(playerid, "~N~~N~~N~~G~~H~Drvo je zaliveno!", 2500, 3);

                                    TreeInfo[land][tree][TREE_WATERING_TIME] = gettime();

                                    new sQuery[80];
                                    format(sQuery, sizeof sQuery, "UPDATE land_trees SET watering_time = %i WHERE id = %i", TreeInfo[land][tree][TREE_WATERING_TIME], TreeInfo[land][tree][TREE_ID]);
                                    mysql_tquery(SQL, sQuery);

                                    Tree_CreateInfoLabel(land, tree, playerid);
                                }
                                else
                                {
                                    // Isteklo je vreme za zalivanje, drvo je propalo, TODO: obavezno!!!
                                    ErrorMsg(playerid, "Isteklo je vreme za zalivanje. Plodovi su propali.");
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (IsPlayerStealingFruit(playerid) == land)
                    {
                        new ownerid = INVALID_PLAYER_ID;
                        foreach (new i : Player)
                        {
                            if (Land_CheckOwnership(land, i))
                            {
                                ownerid = i;
                                break;
                            }
                        }
                        if (IsPlayerInDynamicArea(ownerid, LandInfo[land][LAND_AREA]))
                            return ErrorMsg(playerid, "Ne mozete da kradete dok je vlasnik imanja prisutan.");

                        for__loop (new tree = 0; tree < MAX_TREES; tree++)
                        {
                            if (Tree_Exists(land, tree) && IsPlayerInRangeOfPoint(playerid, 2.5, TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2]))
                            {
                                if (TreeInfo[land][tree][TREE_PICKING_TIME] > gettime())
                                {
                                    GameTextForPlayer(playerid, "~N~~N~~N~~R~~H~Nije vreme za branje!", 3000, 3);
                                }
                                else if (TreeInfo[land][tree][TREE_PICKING_TIME] <= gettime() <= (TreeInfo[land][tree][TREE_PICKING_TIME] + 48*3600))
                                {
                                    // U okviru vremena za branje
                                    new sMsg[41],
                                        fruit = TreeInfo[land][tree][TREE_TYPE],
                                        itemid = GetItemByFruit(fruit),
                                        sFruitName[10],
                                        quantity = 6 + random(2)
                                    ;

                                    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(playerid, itemid) + quantity))
                                        return ErrorMsg(playerid, "Nemate mesta za nove plodove u rancu.");

                                    BP_GetItemName(itemid, sFruitName, sizeof sFruitName);
                                    BP_PlayerItemAdd(playerid, itemid, quantity);

                                    format(sMsg, sizeof sMsg, "~N~~N~~N~~G~~H~Ukrao si plodove! %i kg", quantity);
                                    GameTextForPlayer(playerid, sMsg, 2500, 3);

                                    SendClientMessageF(playerid, BELA, "* Ukrao si plodove: %s | U rancu imas %i kg", sFruitName, BP_PlayerItemGetCount(playerid, itemid));

                                    TreeInfo[land][tree][TREE_PICKING_TIME] = gettime()+Tree_PickingTime(fruit);

                                    new sQuery[73];
                                    format(sQuery, sizeof sQuery, "UPDATE land_trees SET picking_time = %i WHERE id = %i", TreeInfo[land][tree][TREE_PICKING_TIME], TreeInfo[land][tree][TREE_ID]);
                                    mysql_tquery(SQL, sQuery);

                                    new sLog[83];
                                    format(sLog, sizeof sLog, "Kradja | %s | Imanje: %i | Drvo: %i | %s (%i)", ime_obicno[playerid], land, TreeInfo[land][tree][TREE_ID], sFruitName, quantity);
                                    Log_Write(LOG_LAND, sLog);
                                }
                                else
                                {
                                    // Isteklo je vreme za branje (48h), drvo je propalo, TODO: obavezno!!!
                                    ErrorMsg(playerid, "Isteklo je vreme za branje. Plodovi su propali.");
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                GameTextForPlayer(playerid, "~N~~N~~N~~R~Van imanja!", 1000, 3);
                ErrorMsg(playerid, "Nalazite se van imanja.");
                gSeedingFruitID{playerid} = gSeedingLand{playerid} = gHarvestingLand{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
                return 1;
            }
        }
    }


    /*if ((!IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CTRL_BACK)) || (IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CROUCH))) 
    { // H
        new Float:x, Float:y, Float:z;

        // Imanja: 38, 39, 40
        GetDynamicObjectPos(gGate_PremiumLand1, x, y, z);

        if (IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
        {
            if (Land_CheckOwnership(38, playerid) || Land_CheckOwnership(39, playerid) || Land_CheckOwnership(40, playerid))
            {
                if (gGate_PremiumLand1_Status)
                {
                    // Kapija je otvorena -> Zatvoriti je
                    MoveDynamicObject(gGate_PremiumLand1, 1312.843994, 749.400329, 12.557115, 2.75);
                }
                else
                {
                    // Kapija je zatvorena -> Otvoriti je
                    MoveDynamicObject(gGate_PremiumLand1, 1312.843994, 749.400329, 6.997099, 2.75);
                }
                gGate_PremiumLand1_Status = !gGate_PremiumLand1_Status;
            }
        }


        // Imanja: 38, 39, 40
        GetDynamicObjectPos(gGate_PremiumLand2, x, y, z);

        if (IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
        {
            if (Land_CheckOwnership(38, playerid) || Land_CheckOwnership(39, playerid) || Land_CheckOwnership(40, playerid))
            {
                if (gGate_PremiumLand2_Status)
                {
                    // Kapija je otvorena -> Zatvoriti je
                    MoveDynamicObject(gGate_PremiumLand2, 1113.992553, 749.400329, 12.587117, 2.75);
                }
                else
                {
                    // Kapija je zatvorena -> Otvoriti je
                    MoveDynamicObject(gGate_PremiumLand2, 1113.992553, 749.400329, 7.027101, 2.75);
                }
                gGate_PremiumLand2_Status = !gGate_PremiumLand2_Status;
            }
        }
    }*/
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (GetPVarInt(playerid, "pLandBounds") && IsAreaLand(areaid) && !GetPlayerInterior(playerid) && !GetPlayerVirtualWorld(playerid))
    {
        DisablePlayerCheckpoint(playerid);
        DeletePVar(playerid, "pLandBounds");
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (IsAreaLand(areaid) && !GetPlayerInterior(playerid) && !GetPlayerVirtualWorld(playerid))
    {
        new land = GetPlayerLandID(playerid);
        if (Land_CheckOwnership(land, playerid))
        {
            // Igrac je usao na svoje polje -> kreirati mu labele na drvecu

            if (LandInfo[land][LAND_LABEL_TIMER])
            {
                KillTimer(LandInfo[land][LAND_LABEL_TIMER]);
                Land_DestroyTreeLabels(land);
            }

            // new debug_minid = 0,
            //  debug_maxid = 0, 
            //  debug_total = 0,
            new destroyedWatering = 0,
                destroyedPicking = 0
            ;
            for__loop (new tree = 0; tree < MAX_TREES; tree++)
            {
                if (Tree_Exists(land, tree))
                {
                    // Da li je drvo zaliveno na vreme i da li su plodovi obrani?
                    new bool:destroyTree = false;
                    if ((TreeInfo[land][tree][TREE_WATERING_TIME] + 18*3600) < gettime())
                    {
                        // Drvo nije zaliveno vise od 18 sati
                        destroyedWatering ++;
                        destroyTree = true;

                        // Upisivanje u log
                        new sLog[95];
                        format(sLog, sizeof sLog, "Propalo | %s | Imanje: %i | Drvo: %i (zalivanje)", ime_obicno[playerid], land, TreeInfo[land][tree][TREE_ID]);
                        Log_Write(LOG_LAND_DESTROYED, sLog);
                    }
                    else if ((TreeInfo[land][tree][TREE_PICKING_TIME] + 24*3600) < gettime())
                    {
                        // Plodovi stoje neobrani preko 24 sata
                        destroyedPicking ++;
                        destroyTree = true;

                        // Upisivanje u log
                        new sLog[95];
                        format(sLog, sizeof sLog, "Propalo | %s | Imanje: %i | Drvo: %i (branje)", ime_obicno[playerid], land, TreeInfo[land][tree][TREE_ID]);
                        Log_Write(LOG_LAND_DESTROYED, sLog);
                    }

                    if (destroyTree)
                    {
                        new sQuery[43];
                        format(sQuery, sizeof sQuery, "DELETE FROM land_trees WHERE id = %i", TreeInfo[land][tree][TREE_ID]);
                        mysql_tquery(SQL, sQuery);

                        if (IsValidDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]))
                            DestroyDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]);

                        if (IsValidDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]))
                            DestroyDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]);

                        Tree_ResetVariables(land, tree);
                    }
                    else
                    {
                        Tree_CreateInfoLabel(land, tree, playerid);

                        // Debug
                        // #warning Izbrisati debug
                        // if (debug_minid == 0) debug_minid = _:TreeInfo[land][tree][TREE_LABEL];
                        // debug_maxid = _:TreeInfo[land][tree][TREE_LABEL];
                        // debug_total ++;
                    }
                }
            }

            if (destroyedWatering)
            {
                SendClientMessageF(playerid, COLOR_FOREST_GREEN, "(imanje) Zakasnili ste sa zalivanjem drveca. Osusilo se {FF6347}%i stabala.", destroyedWatering);
            }
            if (destroyedPicking)
            {
                SendClientMessageF(playerid, COLOR_FOREST_GREEN, "(imanje) Zakasnili ste branjem voca. Unisteno je {FF6347}%i stabala.", destroyedPicking);
            }

            LandInfo[land][LAND_LABEL_TIMER] = SetTimerEx("Land_UpdateTreeLabels", 120000, true, "i", land);
            // DebugMsg(playerid, "Created 3d label ids: %i - %i | Total: %i", debug_minid, debug_maxid, debug_total);
        }
    }
}

hook OnPlayerExitDynArea(playerid, areaid)
{
    new land = GetPlayerLandID(playerid);
    if (IsAreaLand(areaid) && land != -1 && LandInfo[land][LAND_LABEL_TIMER])
    {
        KillTimer(LandInfo[land][LAND_LABEL_TIMER]);
        Land_DestroyTreeLabels(land);
    }
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    gSeedingFruitID{playerid} = gSeedingLand{playerid} = gHarvestingLand{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
}

hook OnPlayerSpawn(playerid)
{
    gSeedingFruitID{playerid} = gSeedingLand{playerid} = gHarvestingLand{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward UpdateMarketPrices();
public UpdateMarketPrices()
{
    new sQuery[71];
    format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%i' WHERE field = 'jabuka'", gMarketProducts[FRUIT_APPLE]);
    mysql_tquery(SQL, sQuery);
    format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%i' WHERE field = 'kruska'", gMarketProducts[FRUIT_PEAR]);
    mysql_tquery(SQL, sQuery);
    format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%i' WHERE field = 'sljiva'", gMarketProducts[FRUIT_PLUM]);
    mysql_tquery(SQL, sQuery);


    SetMarketPrices();


    SendClientMessageFToAll(COLOR_MAGENTA_11, "PIJACA | {FFFFFF}Jabuka : "#GREEN_12"%s | {FFFFFF}Kruska: "#YELLOW_8"%s | {FFFFFF}Sljiva: "#PLUM"%s", formatMoneyString(gMarketPrice[FRUIT_APPLE]), formatMoneyString(gMarketPrice[FRUIT_PEAR]), formatMoneyString(gMarketPrice[FRUIT_PLUM]));
    return 1;
}

SetMarketPrices()
{
    new totalProducts = gMarketProducts[FRUIT_APPLE] + gMarketProducts[FRUIT_PEAR] + gMarketProducts[FRUIT_PLUM];
    if (totalProducts == 0) totalProducts = 1;

    new Float:total = totalProducts*1.0;

    gMarketPrice[FRUIT_APPLE] = floatround((1.0 - gMarketProducts[FRUIT_APPLE]/total) * PRICE_APPLE);
    gMarketPrice[FRUIT_PEAR] = floatround((1.0 - gMarketProducts[FRUIT_PEAR]/total) * PRICE_PEAR);
    gMarketPrice[FRUIT_PLUM] = floatround((1.0 - gMarketProducts[FRUIT_PLUM]/total) * PRICE_PLUM);

    DebugMsg(0, "totalProducts = %i", totalProducts);
    DebugMsg(0, "total = %.1f", total);
    DebugMsg(0, "gMarketProducts[FRUIT_PEAR] = %i", gMarketProducts[FRUIT_PEAR]);

    new sLabel[200];
    format(sLabel, sizeof sLabel, "[ Gradska pijaca ]\n{FFFFFF}Jabuka: "#GREEN_12"%s\n{FFFFFF}Kruska: "#YELLOW_8"%s\n{FFFFFF}Sljiva: "#PLUM"%s\n\n"#MAGENTA_11"Koristite "#MAGENTA_14"/pijaca "#MAGENTA_11"za trgovinu", formatMoneyString(gMarketPrice[FRUIT_APPLE]), formatMoneyString(gMarketPrice[FRUIT_PEAR]), formatMoneyString(gMarketPrice[FRUIT_PLUM]));

    UpdateDynamic3DTextLabelText(gMarketLabel, COLOR_MAGENTA_11, sLabel);
}

forward Land_UpdateActivityData();
public Land_UpdateActivityData()
{
    mysql_tquery(SQL, "SELECT UNIX_TIMESTAMP(igraci.poslednja_aktivnost) as lastOnline, land.id FROM land LEFT JOIN igraci ON igraci.ime = land.owner WHERE land.owner NOT LIKE 'Niko'", "MySQL_Land_UpdateActivityData");
    return 1;
}

forward TreeSeedingAnimation(playerid, ccinc, entryId, Float:x, Float:y, Float:z);
public TreeSeedingAnimation(playerid, ccinc, entryId, Float:x, Float:y, Float:z)
{
    gBlockKeyPress{playerid} = false;
    TogglePlayerControllable(playerid, true);

    if (!checkcinc(playerid, ccinc) || !IsPlayerSeedingLand(playerid)) return 1;

    ClearAnimations(playerid);

    new fruit = gSeedingFruitID{playerid},
        land = GetPlayerLandID(playerid),
        tree = -1
    ;

    // Trazimo ID u array-u koji je slobodan
    for__loop (new t = 0; t < MAX_TREES; t++)
    {
        if (!Tree_Exists(land, t))
        {
            tree = t;
            break;
        }
    }

    if (tree == -1)
    {
        // Igrac je zasadio "MAX_TREES" drveca na ovoj plantazi
        gSeedingLand{playerid} = gSeedingFruitID{playerid} = 0;
        ErrorMsg(playerid, "Zasadili ste maksimalni broj drveca (%i).", MAX_TREES);

        new sQuery[45];
        format(sQuery, sizeof sQuery, "DELETE FROM land_trees WHERE id = %i", entryId);
        mysql_tquery(SQL, sQuery);

        return 1;
    }

    // Setup drveta
    TreeInfo[land][tree][TREE_ID] = entryId;
    TreeInfo[land][tree][TREE_OWNER_ID] = PI[playerid][p_id];
    TreeInfo[land][tree][TREE_TYPE] = fruit;
    TreeInfo[land][tree][TREE_PICKING_TIME] = gettime()+Tree_GrowthTime(fruit);
    TreeInfo[land][tree][TREE_WATERING_TIME] = gettime();
    TreeInfo[land][tree][TREE_OBJECT_ID] = CreateDynamicObject(Tree_GetObjectModel(fruit), x, y, z + Tree_GetObjectModelZOffset(fruit), 0.0, 0.0, 0.0, 0, 0, -1/*, STREAMER_OBJECT_SD, STREAMER_OBJECT_DD, -1, 1*/);
    TreeInfo[land][tree][TREE_POS][0] = x;
    TreeInfo[land][tree][TREE_POS][1] = y;
    TreeInfo[land][tree][TREE_POS][2] = z;

    Tree_CreateInfoLabel(land, tree, playerid);
    Streamer_Update(playerid);

    if (BP_PlayerItemGetCount(playerid, GetItemByFruitSeed(fruit)))
    {
        new sMsg[112];
        format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da sadite semena na slobodnim poljima po imanju.~N~~N~Raspolozivih semena: ~g~~h~%i", BP_PlayerItemGetCount(playerid, GetItemByFruitSeed(fruit)));
        ptdServerTips_ShowMsg(playerid, .title = "Imanje", .msg = sMsg, .lines = 4);
    }
    else
    {
        gSeedingLand{playerid} = gSeedingFruitID{playerid} = 0;

        new sMsg[180];
        format(sMsg, sizeof sMsg, "Potrosili ste sva semena!~N~Vreme rasta: ~g~~h~%i sati~N~~W~Zalivanje: ~g~~h~svakih %i do 18 sati~N~~N~~R~Ukoliko ne zalijete drvo na svakih 18h, ~N~~R~vasi plodovi ce propasti!", Tree_GrowthTime(fruit)/3600, Tree_WateringTime(fruit)/3600);
        ptdServerTips_ShowMsg(playerid, .title = "Imanje", .msg = sMsg, .lines = 6, .durationMs = 30000);
    }

    // Upisivanje u log
    new sLog[90], sFruitName[10];
    BP_GetItemName(GetItemByFruit(fruit), sFruitName, sizeof sFruitName);
    format(sLog, sizeof sLog, "Sadnja | %s | Imanje: %i | Drvo: %i | %s", ime_obicno[playerid], land, TreeInfo[land][tree][TREE_ID], sFruitName);
    Log_Write(LOG_LAND, sLog);

    GameTextForPlayer(playerid, "~N~~N~~N~~G~~H~Posadjeno", 1500, 3);
    SendClientMessageF(playerid, COLOR_FOREST_GREEN, "Drvo je uspesno posadjeno (%s).", sFruitName);

    return 1;
}

forward Land_UpdateTreeLabels(land);
public Land_UpdateTreeLabels(land)
{
    if (Land_Exists(land))
    {
        // Da li je vlasnik imanja jos uvek na imanju?
        new ownerid = -1;
        foreach (new i : Player)
        {
            if (!strcmp(ime_obicno[i], LandInfo[land][LAND_OWNER]))
            {
                if (GetPlayerLandID(i) != land)
                {
                    Land_DestroyTreeLabels(land);
                    return 1;
                }
                ownerid = i;
                break;
            }
        }

        if (ownerid > -1)
        {
            for__loop (new tree = 0; tree < MAX_TREES; tree++)
            {
                if (Tree_Exists(land, tree))
                {
                    Tree_CreateInfoLabel(land, tree, ownerid);
                }
            }
        }
    }

    return 1;
}

Land_ResetVariables(land)
{
    if (0 <= land < MAX_LAND)
    {
        format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "Niko");
        LandInfo[land][LAND_RADIUS] = 0.0; // Identifikacija nepostojanja
        LandInfo[land][LAND_PRICE] = 0;
        LandInfo[land][LAND_LABEL_TIMER] = 0;
        LandInfo[land][LAND_OWNER_LAST_ONLINE] = 0;
        LandInfo[land][LAND_POS][0] = LandInfo[land][LAND_POS][1] = LandInfo[land][LAND_POS][2] = 0.0;
        LandInfo[land][LAND_AREA] = LandInfo[land][LAND_PICKUP] = -1;
        LandInfo[land][LAND_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }
}

Land_UpdatePickup(land)
{
    if (IsValidDynamicArea(LandInfo[land][LAND_AREA]))
    {
        DestroyDynamicArea(LandInfo[land][LAND_AREA]);
        LandInfo[land][LAND_AREA] = -1;
    }

    if (IsValidDynamic3DTextLabel(LandInfo[land][LAND_LABEL]))
    {
        DestroyDynamic3DTextLabel(LandInfo[land][LAND_LABEL]);
        LandInfo[land][LAND_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }

    if (IsValidDynamicPickup(LandInfo[land][LAND_PICKUP]))
    {
        DestroyDynamicPickup(LandInfo[land][LAND_PICKUP]);
        LandInfo[land][LAND_PICKUP] = -1;
    }

    new sLabel[195];
    if (!strcmp(LandInfo[land][LAND_OWNER], "Niko"))
    {
        format(sLabel, sizeof sLabel, "[ Imanje na prodaju (%i) ]\nRadius: {FFFFFF}%.1f m | {FF9D00}Cena: {FFFFFF}%s\n\nDa kupite ovo imanje upisite {FF9D00}/kupi", land, LandInfo[land][LAND_RADIUS], formatMoneyString(LandInfo[land][LAND_PRICE]));
    }
    else
    {
        if (LandInfo[land][LAND_OWNER_LAST_ONLINE] != 0)
        {

            new inactivityLimitHrs = 350,
                inactivityLimitSec = inactivityLimitHrs * 3600;

            new remainingTime = LandInfo[land][LAND_OWNER_LAST_ONLINE] + inactivityLimitSec - gettime(), // vreme u sekundama preostalo do skidanja imovine
                displayTimeSec = inactivityLimitSec - remainingTime, // sekunde
                displayTimeHrs = floatround(displayTimeSec/3600.0, floatround_ceil),
                displayColor[7]
            ;

            if (remainingTime <= 1800 || displayTimeHrs >= 350) // 30 minuta
            {
                // Ostalo manje od pola sata ili je isteklo -> skidaj
                Land_SetOnBuy(land);

                new sLog[42];
                format(sLog, sizeof sLog, "IMANJE - PRODAJA (NEAKTIVNOST) | ID: %i", land);
                Log_Write(LOG_IMOVINA, sLog);

                return 1;
            }
            else
            {
                // Jos nije doslo vreme za skidanje

                if (displayTimeHrs <= 50)                               displayColor = "34CC33";
                else if (displayTimeHrs > 50 && displayTimeHrs <= 100)  displayColor = "66FA32";
                else if (displayTimeHrs > 100 && displayTimeHrs <= 150) displayColor = "9AFA33";
                else if (displayTimeHrs > 150 && displayTimeHrs <= 200) displayColor = "FFFB01";
                else if (displayTimeHrs > 200 && displayTimeHrs <= 250) displayColor = "FFC000";
                else if (displayTimeHrs > 250 && displayTimeHrs <= 300) displayColor = "F79646";
                else if (displayTimeHrs > 300)                          displayColor = "FF2500";
            }

            format(sLabel, sizeof sLabel, "[ Imanje %i ]\nRadius: {FFFFFF}%.1f m | {FF9D00}Vlasnik: {FFFFFF}%s\n{FFFFFF}Neaktivnost: {%s}%i/%i", land, LandInfo[land][LAND_RADIUS], LandInfo[land][LAND_OWNER], displayColor, displayTimeHrs, inactivityLimitHrs);
        }
    }

    LandInfo[land][LAND_AREA] = CreateDynamicCircle(LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_RADIUS], 0, 0/*, -1, 3*/);
    
    LandInfo[land][LAND_LABEL] = CreateDynamic3DTextLabel(sLabel, 0xFF9D00CC, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1/*, STREAMER_3D_TEXT_LABEL_SD, -1, 3*/);

    LandInfo[land][LAND_PICKUP] = CreateDynamicPickup(1239, 1, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2], 0, 0, -1/*, STREAMER_PICKUP_SD, -1, 4*/);

    return 1;
}

Land_ChangeOwnerName(playerid)
{
    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
    {
        if (gPlayerOwnedLand[playerid][i] > 0)
        {
            new land = gPlayerOwnedLand[playerid][i];
            format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "%s", ime_obicno[playerid]);
            Land_UpdatePickup(land);
        }
    }
}

Land_SetOnBuy(land)
{
    if (!Land_Exists(land)) return 1;

    for__loop (new tree = 0; tree < MAX_TREES; tree++)
    {
        if (Tree_Exists(land, tree))
        {
            if (IsValidDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]))
                DestroyDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]);

            if (IsValidDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]))
                DestroyDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]);

            Tree_ResetVariables(land, tree);
        }
    }

    format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "Niko");
    Land_UpdatePickup(land);

    new sQuery[46];
    format(sQuery, sizeof sQuery, "UPDATE land SET owner = 'Niko' WHERE id = %i", land);
    mysql_tquery(SQL, sQuery);
    format(sQuery, sizeof sQuery, "DELETE FROM land_trees WHERE land = %i", land);
    mysql_tquery(SQL, sQuery);
    return 1;
}

Land_DestroyTreeLabels(land)
{
    if (Land_Exists(land) && LandInfo[land][LAND_LABEL_TIMER])
    {
        KillTimer(LandInfo[land][LAND_LABEL_TIMER]);

        for__loop (new tree = 0; tree < MAX_TREES; tree++)
        {
            if (Tree_Exists(land, tree) && IsValidDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]))
            {
                DestroyDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]);
                TreeInfo[land][tree][TREE_LABEL] = Text3D:INVALID_3DTEXT_ID;
            }
        }
    }
}

IsAreaLand(areaid)
{
    for__loop (new land = 0; land < MAX_LAND; land++)
    {
        if (Land_Exists(land) && LandInfo[land][LAND_AREA] == areaid)
            return true;
    }
    return false;
}

GetPlayerLandID(playerid)
{
    if (IsPlayerInAnyDynamicArea(playerid))
    {
        for__loop (new land = 0; land < sizeof LandInfo; land++)
        {
            if (Land_Exists(land) && IsPlayerInDynamicArea(playerid, LandInfo[land][LAND_AREA]))
                return land;
        }
    }

    return -1;
}

Land_CheckOwnership(land, playerid)
{
    if (!strcmp(LandInfo[land][LAND_OWNER], ime_obicno[playerid]))
    {
        return true;
    }

    return false;
}

Land_HasOwner(land)
{
    if (!Land_Exists(land))
    {
        return false;
    }
    
    if (!strcmp(LandInfo[land][LAND_OWNER], "Niko"))
    {
        return false;
    }
    return true;
}

Land_ProcessPurchase(playerid, land)
{
    // if (PI[playerid][p_nivo] < 10)
        // return ErrorMsg(playerid, "Morate biti nivo 10 da biste mogli da posedujete imanje.");

    if (LandInfo[land][LAND_RADIUS] == 10.0 && PI[playerid][p_nivo] < 6)
        return ErrorMsg(playerid, "Morate biti nivo 6 da biste mogli da kupite ovo imanje.");

    if (LandInfo[land][LAND_RADIUS] == 20.0 && PI[playerid][p_nivo] < 10)
        return ErrorMsg(playerid, "Morate biti nivo 10 da biste mogli da kupite ovo imanje.");

    if (LandInfo[land][LAND_RADIUS] == 30.0 && PI[playerid][p_nivo] < 12)
        return ErrorMsg(playerid, "Morate biti nivo 12 da biste mogli da kupite ovo imanje.");

    if (PI[playerid][p_novac] < LandInfo[land][LAND_PRICE])
        return ErrorMsg(playerid, "Nemate dovoljno novca za ovo imanje.");

    new varIdx = -1;
    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
    {
        if (gPlayerOwnedLand[playerid][i] == 0)
        {
            varIdx = i;
            gPlayerOwnedLand[playerid][i] = land;
            break;
        }
    }
    if (varIdx == -1)
        return ErrorMsg(playerid, "Popunili ste sve raspolozive slotove za imanja.");

    PlayerMoneySub(playerid, LandInfo[land][LAND_PRICE]);

    format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "%s", ime_obicno[playerid]);
    LandInfo[land][LAND_OWNER_LAST_ONLINE] = gettime();
    Land_UpdatePickup(land);

    // Update podataka u bazi
    new sQuery[68];
    format(sQuery, sizeof sQuery, "UPDATE land SET owner = '%s' WHERE id = %i", ime_obicno[playerid], land);
    mysql_tquery(SQL, sQuery);

    // Upisivanje u log
    new sLog[96];
    format(sLog, sizeof sLog, "IMANJE - KUPOVINA (buy) | Izvrsio: %s | Cena: $%d | ID: %d", ime_obicno[playerid], LandInfo[land][LAND_PRICE], land);
    Log_Write(LOG_IMOVINA, sLog);

    return 1;
}

Land_LoadForPlayer(playerid)
{
    new sQuery[63];
    format(sQuery, sizeof sQuery, "SELECT id FROM land WHERE owner = '%s'", ime_obicno[playerid]);
    mysql_tquery(SQL, sQuery, "MySQL_LoadLandForPlayer", "ii", playerid, cinc[playerid]);
}

// Land_CountTrees(land)
// {
//  new count = 0;
//  if (Land_Exists(land))
//  {
//      for__loop (new tree = 0; tree < MAX_TREES; tree++)
//      {
//          if (Tree_Exists(land, tree)) count ++;
//      }
//  }

//  return count;
// }

Land_Reload(land)
{
    if (IsValidDynamicArea(LandInfo[land][LAND_AREA]))
    {
        DestroyDynamicArea(LandInfo[land][LAND_AREA]);
        LandInfo[land][LAND_AREA] = -1;
    }

    if (IsValidDynamicPickup(LandInfo[land][LAND_PICKUP]))
    {
        DestroyDynamicPickup(LandInfo[land][LAND_PICKUP]);
        LandInfo[land][LAND_PICKUP] = -1;
    }

    if (IsValidDynamic3DTextLabel(LandInfo[land][LAND_LABEL]))
    {
        DestroyDynamic3DTextLabel(LandInfo[land][LAND_LABEL]);
        LandInfo[land][LAND_LABEL] = Text3D:INVALID_3DTEXT_ID;
    }

    if (LandInfo[land][LAND_LABEL_TIMER])
    {
        KillTimer(LandInfo[land][LAND_LABEL_TIMER]);
        Land_DestroyTreeLabels(land);
    }


    new sQuery[36];
    format(sQuery, sizeof sQuery, "SELECT * FROM land WHERE id = %i", land);
    mysql_tquery(SQL, sQuery, "MySQL_LoadLand");
}

Land_Exists(land)
{
    if ((0 <= land < MAX_LAND) && LandInfo[land][LAND_RADIUS] > 0.0)
        return true;

    return false;
}

Tree_Exists(land, tree)
{
    if (Land_Exists(land) && (0 <= tree < MAX_TREES) && TreeInfo[land][tree][TREE_ID] > 0)
        return true;

    return false;
}

Tree_CreateInfoLabel(land, tree, playerid)
{
    new 
        sLabel[150],
        sFruitName[10],
        sWatering[24],
        sPicking[20],
        sTime[20]
    ;

    BP_GetItemName(GetItemByFruit(TreeInfo[land][tree][TREE_TYPE]), sFruitName, sizeof sFruitName);

    if (TreeInfo[land][tree][TREE_WATERING_TIME] == 0)
    {
        format(sWatering, sizeof sWatering, "nikada");
    }
    else
    {
        GetReadableTime(gettime() - TreeInfo[land][tree][TREE_WATERING_TIME], sTime);
        format(sWatering, sizeof sWatering, "pre %s", sTime);
    }


    if (TreeInfo[land][tree][TREE_PICKING_TIME] > gettime())
    {
        GetReadableTime(TreeInfo[land][tree][TREE_PICKING_TIME] - gettime(), sPicking);
    }
    else
    {
        format(sPicking, sizeof sPicking, "spremno");
    }



    format(sLabel, sizeof sLabel, "[ %s (id: %i)]\n\n{FFFFFF}Poslednje zalivanje: {228B22}%s\n{FFFFFF}Vreme do branja: {228B22}%s", sFruitName, TreeInfo[land][tree][TREE_ID], sWatering, sPicking);

    if (IsValidDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]))
    {
        UpdateDynamic3DTextLabelText(TreeInfo[land][tree][TREE_LABEL], 0x228B22CC, sLabel);
    }
    else
    {
        TreeInfo[land][tree][TREE_LABEL] = CreateDynamic3DTextLabel(sLabel, 0x228B22CC, TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, playerid/*, STREAMER_3D_TEXT_LABEL_SD, -1, 3*/);
    }
}

Tree_GrowthTime(fruit)
{
    #pragma unused fruit
    // if (fruit == FRUIT_APPLE)
    //  return 36*3600;

    // else if (fruit == FRUIT_PEAR)
    //  return 48*3600;

    // else if (fruit == FRUIT_PLUM)
    //  return 24*3600;

    return 24*3600;
}

Tree_PickingTime(fruit)
{
    #pragma unused fruit
    // if (fruit == FRUIT_APPLE)
    //  return 22*3600;

    // else if (fruit == FRUIT_PEAR)
    //  return 24*3600;

    // else if (fruit == FRUIT_PLUM)
    //  return 20*3600;

    return 24*3600;
}


Tree_WateringTime(fruit)
{
    #pragma unused fruit
    return 6*3600;
}

Tree_GetObjectModel(fruit)
{
    switch (fruit)
    {
        case FRUIT_APPLE: return 673;
        case FRUIT_PEAR:  return 618;
        case FRUIT_PLUM:  return 775;
    }
    return 775;
}

Float:Tree_GetObjectModelZOffset(fruit)
{
    switch (fruit)
    {
        case FRUIT_APPLE: return (-3.55);
        case FRUIT_PEAR:  return (-2.53);
        case FRUIT_PLUM:  return (-3.06);
    }
    return (-3.0);
}

Float:Tree_GetObjectRadius(fruit)
{
    switch (fruit)
    {
        case FRUIT_APPLE: return 4.64;
        case FRUIT_PEAR:  return 4.58;
        case FRUIT_PLUM:  return 4.61;
    }
    return 4.62;
}

Tree_ResetVariables(land, tree)
{
    TreeInfo[land][tree][TREE_ID] = 0; // Identifikacija nepostojanja
    TreeInfo[land][tree][TREE_OWNER_ID] = -1;
    TreeInfo[land][tree][TREE_TYPE] = 0;
    TreeInfo[land][tree][TREE_PICKING_TIME] = 0;
    TreeInfo[land][tree][TREE_WATERING_TIME] = 0;
    TreeInfo[land][tree][TREE_OBJECT_ID] = 0;
    TreeInfo[land][tree][TREE_POS][0] = TreeInfo[land][tree][TREE_POS][1] = TreeInfo[land][tree][TREE_POS][2] = 0.0;
    TreeInfo[land][tree][TREE_LABEL] = Text3D:INVALID_3DTEXT_ID;
}

GetItemByFruit(fruit)
{
    if (fruit == FRUIT_APPLE) return ITEM_APPLE;
    else if (fruit == FRUIT_PEAR) return ITEM_PEAR;
    else if (fruit == FRUIT_PLUM) return ITEM_PLUM;
    
    return -1;
}

GetItemByFruitSeed(fruit)
{
    if (fruit == FRUIT_APPLE) return ITEM_APPLE_SEED;
    else if (fruit == FRUIT_PEAR) return ITEM_PEAR_SEED;
    else if (fruit == FRUIT_PLUM) return ITEM_PLUM_SEED;
    
    return -1;
}


IsPlayerOnLandPickup(playerid, land)
{
    if (Land_Exists(land) && IsPlayerInRangeOfPoint(playerid, 5.0, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2]))
    {
        return true;
    }
    return false;
}

CountPlayerLand(playerid)
{
    new landCount = 0;
    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
    {
        if (gPlayerOwnedLand[playerid][i] > 0)
        {
            landCount ++;
        }
    }
    return landCount;
}

IsPointInAnyLand(Float:x, Float:y, Float:z)
{
    for__loop (new land = 0; land < MAX_LAND; land++)
    {
        if (Land_Exists(land) && IsPointInDynamicArea(LandInfo[land][LAND_AREA], x, y, z))
        {
            return land;
        }
    }
    return 0;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_LoadMarketplace();
public MySQL_LoadMarketplace()
{
    cache_get_row_count(rows);

    new row = rows;
    while (row)
    {
        row --;

        new field[12], value[12];
        cache_get_value_name(row, "field", field, sizeof field);
        cache_get_value_name(row, "value", value, sizeof value);

        if (!strcmp(field, "jabuka", true))
        {
            gMarketProducts[FRUIT_APPLE] = strval(value);
        }

        else if (!strcmp(field, "kruska", true))
        {
            gMarketProducts[FRUIT_PEAR] = strval(value);
        }

        else if (!strcmp(field, "sljiva", true))
        {
            gMarketProducts[FRUIT_PLUM] = strval(value);
        }
    }

    SetMarketPrices();
    return 1;
}

forward MySQL_LoadLand();
public MySQL_LoadLand()
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new i = 0; i < rows; i++)
    {
        new land, sPosition[32];
        cache_get_value_name_int(i, "id", land);
        cache_get_value_name(i, "owner", LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME);
        cache_get_value_name(i, "pos", sPosition, sizeof sPosition);
        cache_get_value_name_float(i, "radius", LandInfo[land][LAND_RADIUS]);
        cache_get_value_name_int(i, "price", LandInfo[land][LAND_PRICE]);

        sscanf(sPosition, "p<,>fff", LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2]);

        LandInfo[land][LAND_AREA] = LandInfo[land][LAND_PICKUP] = -1;
        LandInfo[land][LAND_LABEL] = Text3D:INVALID_3DTEXT_ID;
        LandInfo[land][LAND_LABEL_TIMER] = 0;
        LandInfo[land][LAND_OWNER_LAST_ONLINE] = 0;
        Land_UpdatePickup(land);

    }

    Land_UpdateActivityData();
    return 1;
}

forward MySQL_LoadLandTrees();
public MySQL_LoadLandTrees()
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    new landOld = -1, 
        tree = -1,
        land,
        sPosition[32]
    ;
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_name_int(i, "land", land);
        if (land != landOld) tree = -1, landOld = land;

        tree ++;

        cache_get_value_name(i, "pos", sPosition, sizeof sPosition);
        cache_get_value_name_int(i, "id", TreeInfo[land][tree][TREE_ID]);
        cache_get_value_name_int(i, "owner", TreeInfo[land][tree][TREE_OWNER_ID]);
        cache_get_value_name_int(i, "type", TreeInfo[land][tree][TREE_TYPE]);
        cache_get_value_name_int(i, "picking_time", TreeInfo[land][tree][TREE_PICKING_TIME]);
        cache_get_value_name_int(i, "watering_time", TreeInfo[land][tree][TREE_WATERING_TIME]);

        sscanf(sPosition, "p<,>fff", TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2]);

        TreeInfo[land][tree][TREE_LABEL] = Text3D:INVALID_3DTEXT_ID;
        TreeInfo[land][tree][TREE_OBJECT_ID] = CreateDynamicObject(Tree_GetObjectModel(TreeInfo[land][tree][TREE_TYPE]), TreeInfo[land][tree][TREE_POS][0], TreeInfo[land][tree][TREE_POS][1], TreeInfo[land][tree][TREE_POS][2] + Tree_GetObjectModelZOffset(TreeInfo[land][tree][TREE_TYPE]), 0.0, 0.0, 0.0, 0, 0, -1/*, STREAMER_OBJECT_SD, STREAMER_OBJECT_DD, -1, 1*/);

        // TODO: Provera da li je drvo propalo
    }
    return 1;
}

forward MySQL_CheckLandOccupancy(playerid, ccinc, Float:x, Float:y, Float:z, Float:radius, price);
public MySQL_CheckLandOccupancy(playerid, ccinc, Float:x, Float:y, Float:z, Float:radius, price)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    new isPlotOccupied = false;
    if (rows)
    {
        new tempArea = CreateDynamicCircle(x, y, radius+1.0, 0, 0, playerid, 1);
        for__loop (new i = 0; i < rows; i++)
        {
            new pos[31], Float:checkx, Float:checky, Float:checkz;
            cache_get_value_index(i, 0, pos, sizeof pos);
            if (!sscanf(pos, "p<,>fff", checkx, checky, checkz))
            {
                if (IsPointInDynamicArea(tempArea, checkx, checky, 0.0))
                {
                    isPlotOccupied = true;
                    break;
                }
            }
        }

        DestroyDynamicArea(tempArea);
    }

    if (!isPlotOccupied)
    {
        new sQuery[102];
        format(sQuery, sizeof sQuery, "INSERT INTO land (pos, radius, price) VALUES ('%.4f,%.4f,%.4f', '%.1f', %i)", x, y, z, radius, price);
        mysql_tquery(SQL, sQuery, "MySQL_CreateLand", "iiffffi", playerid, cinc[playerid], x, y, z, radius, price);
    }
    else
    {
        return ErrorMsg(playerid, "Nalazite se unutar vec postojeceg imanja.");
    }
    return 1;
}

forward MySQL_CreateLand(playerid, ccinc, Float:x, Float:y, Float:z, Float:radius, price);
public MySQL_CreateLand(playerid, ccinc, Float:x, Float:y, Float:z, Float:radius, price)
{
    new land = cache_insert_id();
    if (land >= 1)
    {
        format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "Niko");
        LandInfo[land][LAND_POS][0] = x;
        LandInfo[land][LAND_POS][1] = y;
        LandInfo[land][LAND_POS][2] = z;
        LandInfo[land][LAND_RADIUS] = radius;
        LandInfo[land][LAND_PRICE] = price;
        LandInfo[land][LAND_AREA] = LandInfo[land][LAND_PICKUP] = -1;
        LandInfo[land][LAND_LABEL] = Text3D:INVALID_3DTEXT_ID;
        LandInfo[land][LAND_LABEL_TIMER] = 0;
        LandInfo[land][LAND_OWNER_LAST_ONLINE] = 0;
        Land_UpdatePickup(land);

        SendClientMessageF(playerid, SVETLOPLAVA, "* Imanje je kreirano. (id: %i)", land);
    }
    else return ErrorMsg(playerid, "Kreiranje imanja nije uspelo. (SQL Error)");
    return 1;
}

forward MySQL_Land_CheckPlotOccupancy(playerid, ccinc, land, Float:refx, Float:refy, Float:refz);
public MySQL_Land_CheckPlotOccupancy(playerid, ccinc, land, Float:refx, Float:refy, Float:refz)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if (GetPlayerLandID(playerid) != land || GetDistanceBetweenPoints(x, y, z, refx, refy, refz) > 5.0)
    {
        // Igrac je napustio imanje ili se pomerio dok se upit izvrsavao
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Upit ka bazi je trajao predugacko, pokusajte ponovo.");
    }

    cache_get_row_count(rows);
    new bool:isPlotOccupied = false;
    if (rows)
    {
        new tempArea = CreateDynamicCircle(refx, refy, Tree_GetObjectRadius(gSeedingFruitID{playerid}), 0, 0, playerid, 1);
        for__loop (new i = 0; i < rows; i++)
        {
            new pos[31], Float:checkx, Float:checky, Float:checkz;
            cache_get_value_index(i, 0, pos, sizeof pos);
            if (!sscanf(pos, "p<,>fff", checkx, checky, checkz))
            {
                if (IsPointInDynamicArea(tempArea, checkx, checky, 0.0))
                {
                    isPlotOccupied = true;
                    break;
                }
            }
        }

        DestroyDynamicArea(tempArea);
    }

    if (!isPlotOccupied)
    {
        // Sadjenje

        new fruit = gSeedingFruitID{playerid},
            sQuery[207]
        ;
        format(sQuery, sizeof sQuery, "INSERT INTO land_trees (land, owner, pos, type, picking_time, watering_time) VALUES (%i, %i, '%.4f,%.4f,%.4f', %i, %i, %i)", land, PI[playerid][p_id], refx, refy, refz, fruit, gettime()+Tree_GrowthTime(fruit), gettime());
        mysql_tquery(SQL, sQuery, "MySQL_OnTreePlanted", "iifff", playerid, cinc[playerid], refx, refy, refz);
    }

    else 
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Razmak izmedju drveca je previse mali.");
    }

    return 1;
}

forward MySQL_OnTreePlanted(playerid, ccinc, Float:x, Float:y, Float:z);
public MySQL_OnTreePlanted(playerid, ccinc, Float:x, Float:y, Float:z)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    new entryId = cache_insert_id();
    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
    SetTimerEx("TreeSeedingAnimation", 5000, false, "iiifff", playerid, cinc[playerid], entryId, x, y, z);

    BP_PlayerItemSub(playerid, GetItemByFruitSeed(gSeedingFruitID{playerid}));

    return 1;
}

forward MySQL_LoadLandForPlayer(playerid, ccinc);
public MySQL_LoadLandForPlayer(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (rows)
    {
        if (rows > PI[playerid][p_imanja_slotovi])
        {
            rows = PI[playerid][p_imanja_slotovi];
        }

        for__loop (new i = 0; i < rows; i++)
        {
            new land;
            cache_get_value_index_int(i, 0, land);
            gPlayerOwnedLand[playerid][i] = land;
            LandInfo[land][LAND_OWNER_LAST_ONLINE] = gettime();

            Land_UpdatePickup(land);
        }
    }
    return 1;
}

forward MySQL_Land_UpdateActivityData();
public MySQL_Land_UpdateActivityData()
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new i = 0; i < rows; i++)
    {
        new land;
        cache_get_value_index_int(i, 1, land);
        cache_get_value_index_int(i, 0, LandInfo[land][LAND_OWNER_LAST_ONLINE]);

        Land_UpdatePickup(land);
    }
    return 1;
}



// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:land_seeding_start(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    gHarvestingLand{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
    gSeedingLand{playerid} = GetPlayerLandID(playerid);
    gSeedingFruitID{playerid} = listitem+1;

    new sFruitName[10],
        itemid = GetItemByFruit(gSeedingFruitID{playerid}),
        seedid = GetItemByFruitSeed(gSeedingFruitID{playerid});

    BP_GetItemName(itemid, sFruitName, sizeof sFruitName);

    SendClientMessageF(playerid, BELA, "* Zapoceli ste sadnju voca (%s). Imate %i semena na raspolaganju.", sFruitName, BP_PlayerItemGetCount(playerid, seedid));
    SendClientMessageF(playerid, BELA, "* Koristite ENTER (F) da posadite seme na slobodnom zemljistu.");

    return 1;
}

Dialog:imanja(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new land = strval(inputtext);
        SetPVarInt(playerid, "pEditingLand", land);

        if (Land_Exists(land))
        {
            SPD(playerid, "imanje_options", DIALOG_STYLE_LIST, "Imanje - opcije", "Informacije\nLociraj\nPrikazi granice\nProdaj", "Dalje >", "< Nazad");
        }
        else
        {
            return ErrorMsg(playerid, GRESKA_NEPOZNATO);
        }
    }
    return 1;
}

Dialog:imanje_options(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        if (CountPlayerLand(playerid) == 1) return 1;
        else return callcmd::imanja(playerid, "");
    }
    else
    {
        new land = GetPVarInt(playerid, "pEditingLand");

        if (listitem == 0) // Informacije
        {
            new sDialog[175],
                sZone[32],
                countTrees = 0,
                countTreeType[4] = {0, 0, 0, 0}
            ;

            Get2DZoneByPosition(LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], sZone, sizeof sZone);
            for__loop (new tree = 0; tree < MAX_TREES; tree++)
            {
                if (Tree_Exists(land, tree))
                {
                    countTrees ++;
                    countTreeType[TreeInfo[land][tree][TREE_TYPE]] ++;
                }
            }

            format(sDialog, sizeof sDialog, ""#FOREST_GREEN "Imanje (%s)\n\n\
                {FFFFFF}Cena: "#FOREST_GREEN "%s\n\
                {FFFFFF}Radius: "#FOREST_GREEN "%.1f metara\n\
                {FFFFFF}Zasadjeno: "#FOREST_GREEN "%i stabala\n\
                  -  od toga: %i jabuka, %i kruska, %i sljiva", sZone, formatMoneyString(LandInfo[land][LAND_PRICE]), LandInfo[land][LAND_RADIUS], countTrees, countTreeType[FRUIT_APPLE], countTreeType[FRUIT_PEAR], countTreeType[FRUIT_PLUM]);
            SPD(playerid, "imanje_info", DIALOG_STYLE_MSGBOX, "Imanje - informacije", sDialog, "Nazad", "");
        }

        else if (listitem == 1) // Lociraj
        {
            SetGPSLocation(playerid, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2], "imanje");
        }

        else if (listitem == 2) // Prikazi granice
        {
            if (GetPVarInt(playerid, "pLandBounds"))
            {
                DisablePlayerCheckpoint(playerid);
                DeletePVar(playerid, "pLandBounds");
            }
            else
            {
                SetPlayerCheckpoint(playerid, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2], LandInfo[land][LAND_RADIUS]*2);
                SetPVarInt(playerid, "pLandBounds", 1);

                InfoMsg(playerid, "Granice imanja su prikazane Checkpoint-om.");
            }
        }

        else if (listitem == 3) // Prodaj
        {
            SPD(playerid, "imanje_sell", DIALOG_STYLE_LIST, "Imanje - prodaj", "Prodaj drzavi\nProdaj igracu", "Dalje >", "< Nazad");
        }
    }
    return 1;
}

Dialog:imanje_info(playerid, response, listitem, const inputtext[])
{
    new sInputtext[4];
    valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
    dialog_respond:imanja(playerid, 1, 0, sInputtext);
    return 1;
}

Dialog:imanje_sell(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        new sInputtext[4];
        valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
        return 1;
    }

    if (listitem == 0) // Prodaj drzavi
    {
        new land = GetPVarInt(playerid, "pEditingLand");
        new sDialog[77];
        format(sDialog, sizeof sDialog, "{FFFFFF}Da li zelite da prodate ovo imanje za {FF9D00}%s?", formatMoneyString(floatround(LandInfo[land][LAND_PRICE]/3)*2));
        SPD(playerid, "imanje_sell_onBuy", DIALOG_STYLE_MSGBOX, "Imanje - prodaj", sDialog, "Da", "Ne");
    }
    else if (listitem == 1) // Prodaj igracu
    {
        if (PI[playerid][p_nivo] < 10)
            return ErrorMsg(playerid, "Morate biti najmanje nivo 10 da biste mogli da prodajete imovinu drugim igracima.");
            
        SPD(playerid, "imanje_sell_toPlayer_1", DIALOG_STYLE_INPUT, "Imanje - prodaj", "{FFFFFF}Upisite ime igraca kome zelite da prodate imanje:", "Dalje >", "< Nazad");
    }
    return 1;
}

Dialog:imanje_sell_toPlayer_1(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        new sInputtext[4];
        valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
        return 1;
    }

    new
        targetid
    ;
    
    if (sscanf(inputtext, "u", targetid) || targetid == playerid)
        return DialogReopen(playerid);

    if (!IsPlayerConnected(targetid)) 
    {
        ErrorMsg(playerid, GRESKA_OFFLINE);
        return DialogReopen(playerid);
    }

    if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        ErrorMsg(playerid, "Taj igrac se ne nalazi u Vasoj blizini.");
        return DialogReopen(playerid);
    }

    if (PI[targetid][p_nivo] < 10)
        return ErrorMsg(playerid, "Taj igrac mora biti barem nivo 10.");

    new minSec = 50 * 3600;
    if (PI[targetid][p_provedeno_vreme] < minSec)
        return ErrorMsg(playerid, "Taj igrac mora imati najmanje 50 sati igre. Trenutno ima %i sati igre.", floatround(PI[targetid][p_provedeno_vreme]/3600.0));


    // Trazenje slobodnog slota kod kupca
    new buyerSlot = -1;
    for__loop (new i = 0; i < PI[targetid][p_imanja_slotovi]; i++) 
    {
        if (gPlayerOwnedLand[targetid][i] == 0) 
            buyerSlot = i;
    }
    if (buyerSlot == -1)
        return ErrorMsg(playerid, "Taj igrac nema slobodan slot za novo imanje.");

    // ---------- //

    SetPVarInt(playerid, "landSell_TargetID", targetid);

    SPD(playerid, "imanje_sell_toPlayer_2", DIALOG_STYLE_INPUT, "Imanje - prodaja", "{FFFFFF}Upisite iznos koji zelite da Vam ovaj igrac plati:", "Dalje >", "< Nazad");
    return 1;
}

Dialog:imanje_sell_toPlayer_2(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        new sInputtext[4];
        valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
        return 1;
    }

    new
        cena,
        targetid = GetPVarInt(playerid, "landSell_TargetID"),
        land = GetPVarInt(playerid, "pEditingLand")
    ;
    
    if (sscanf(inputtext, "i", cena) || cena < 1 || cena > 99999999)
        return DialogReopen(playerid);

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(targetid, playerid, 5.0))
        return ErrorMsg(playerid, "Ovaj igrac vise nije u Vasoj blizini.");

    SetPVarInt(playerid, "landSell_Price", cena);

    format(string_256, sizeof string_256, "{0068B3}Imanje ID: {FFFFFF}%i\n{0068B3}Igrac: {FFFFFF}%s\n{0068B3}Cena: {FFFFFF}%s\n\nDa li zaista zelite da prodate svoje imanje\novom igracu i za ovu cenu?", land, ime_rp[targetid], formatMoneyString(cena));

    SPD(playerid, "imanje_sell_toPlayer_3", DIALOG_STYLE_MSGBOX, "Imanje - prodaja", string_256, "Da", "Ne");
    return 1;
}

Dialog:imanje_sell_toPlayer_3(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        new sInputtext[4];
        valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
        return 1;
    }


    new
        cena = GetPVarInt(playerid, "landSell_Price"),
        targetid = GetPVarInt(playerid, "landSell_TargetID"),
        land = GetPVarInt(playerid, "pEditingLand")
    ;

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(targetid, playerid, 5.0))
        return ErrorMsg(playerid, "Ovaj igrac vise nije u Vasoj blizini.");

    if (!Land_Exists(land) || !Land_CheckOwnership(land, playerid))
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);


    SetPVarInt(targetid, "landBuy_SellerID", playerid);
    SetPVarInt(targetid, "landBuy_Price", cena);
    SetPVarInt(targetid, "landBuy_ID", land);

    SetPVarInt(playerid, "landSell_ID", land);

    format(string_256, 200, "{FFFFFF}Igrac {0068B3}%s {FFFFFF}zeli da Vam proda Imanje ID: {0068B3}%i.\n\n{0068B3}Cena: {FFFFFF}%s", ime_rp[playerid], land, formatMoneyString(cena));

    SPD(targetid, "imanje_sell_toPlayer_4", DIALOG_STYLE_MSGBOX, "Imanje - kupoprodaja", string_256, "Prihvati", "Odbaci");

    SendClientMessage(playerid, SVETLOPLAVA, "* Ponuda je poslata.");
    return 1;
}

Dialog:imanje_sell_toPlayer_4(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return SendClientMessage(GetPVarInt(playerid, "landBuy_SellerID"), SVETLOCRVENA, "* Igrac je odbio kupovinu imanja.");


    new
        // cena = GetPVarInt(playerid, "landSell_Price"),
        // targetid = GetPVarInt(playerid, "landSell_TargetID"),
        sellerid = GetPVarInt(playerid, "landBuy_SellerID"),
        land = GetPVarInt(sellerid, "pEditingLand"),
        price = GetPVarInt(playerid, "landBuy_Price")
     ;

    if (!IsPlayerConnected(sellerid)) // Prodavac offline
        return SendClientMessage(playerid, SVETLOCRVENA, "* Igrac koji Vam je ponudio prodaju je napustio server.");

    // Provera da li se parametri poklapaju kod prodavca i kupca
    if (GetPVarInt(sellerid, "landSell_TargetID") != playerid)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[land.pwn] "GRESKA_NEPOZNATO" (04)");

    if (GetPVarInt(sellerid, "landSell_Price") != price)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[land.pwn] "GRESKA_NEPOZNATO" (05)");

    if (GetPVarInt(sellerid, "landSell_ID") != GetPVarInt(playerid, "landBuy_ID"))
        return SendClientMessage(playerid, TAMNOCRVENA2, "[land.pwn] "GRESKA_NEPOZNATO" (06)");

    if (price < 1 || price > 99999999)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[land.pwn] "GRESKA_NEPOZNATO" (09)");

    if (PI[playerid][p_novac] < price)
        return ErrorMsg(playerid, "Nemate dovoljno novca.");

    // Provera slobodnih slotova
    new slot = -1;
    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++) 
    {
        if (gPlayerOwnedLand[playerid][i] == 0) 
            slot = i;
    }
    if (slot == -1)
        return ErrorMsg(playerid, "Nemate nijedan slobodan slot za novo imanje.");

    PlayerMoneySub(playerid, price);
    PlayerMoneyAdd(sellerid, price);
    gPlayerOwnedLand[playerid][slot] = gPlayerOwnedLand[sellerid][0];
    gPlayerOwnedLand[sellerid][0] = 0;
    
    // Azuriranje podataka o imanju
    format(mysql_upit, sizeof mysql_upit, "UPDATE land SET owner = '%s' WHERE id = %d", ime_obicno[playerid], land);
    mysql_tquery(SQL, mysql_upit);
    format(mysql_upit, sizeof mysql_upit, "UPDATE land_trees SET owner = %i WHERE land = %d", PI[playerid][p_id], land);
    mysql_tquery(SQL, mysql_upit);
    
    // Slanje poruka
    SendClientMessageF(sellerid, SVETLOPLAVA, "* Uspesno ste prodali imanje za {FFFFFF}%s.", formatMoneyString(price));
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste kupili imanje za {FFFFFF}%s.", formatMoneyString(price));
    SendClientMessage(playerid, BELA, "Koristite {FFFF00}/imanje {FFFFFF}za upravljanje ovim imanjem.");

    
    // Logovanje
    format(string_128, sizeof string_128, "IMANJE - PRODAJA (igracu) | %s -> %s | Cena: $%d | ID: %d", LandInfo[land][LAND_OWNER], ime_obicno[playerid], price, land);
    Log_Write(LOG_IMOVINA, string_128);
    
    // Promena podataka imanja
    format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "%s", ime_obicno[playerid]);

    for (new tree = 0; tree < MAX_TREES; tree++)
    {
        if (Tree_Exists(land, tree))
        {
            TreeInfo[land][tree][TREE_OWNER_ID] = PI[playerid][p_id];
        }
    }

    Land_UpdatePickup(land);

    return 1;
}

Dialog:imanje_sell_onBuy(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        new sInputtext[4];
        valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
        return 1;
    }

    new land = GetPVarInt(playerid, "pEditingLand"),
        money = floatround(LandInfo[land][LAND_PRICE]/3)*2,
        sMsg[58]
    ;

    PlayerMoneyAdd(playerid, money);

    format(sMsg, sizeof sMsg, "~N~~N~~N~~G~Prodaja imanja~n~~w~Zarada: ~r~%s", formatMoneyString(money));
    GameTextForPlayer(playerid, sMsg, 5000, 3);

    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
    {
        if (gPlayerOwnedLand[playerid][i] == land)
        {
            gPlayerOwnedLand[playerid][i] = 0;
        }
    }

    Land_SetOnBuy(land);
    
    new sLog[70];
    format(sLog, sizeof sLog, "IMANJE - PRODAJA (drzava) | %s | ID: %i", ime_obicno[playerid], land);
    Log_Write(LOG_IMOVINA, sLog);
    return 1;
}

Dialog:imanje_edit_id(playerid, response, listitem, const inputtext[])
{
    if (!response) return callcmd::editprop(playerid, "");

    if (isnull(inputtext)) 
        return DialogReopen(playerid);

    new land = strval(inputtext);
    if (!Land_Exists(land))
        return DialogReopen(playerid);

    SetPVarInt(playerid, "pEditingLand", land);
    SPD(playerid, "imanje_edit_do", DIALOG_STYLE_LIST, "IZMENA IMANJA", "Informacije\nIzmena\nStavi na prodaju", "Dalje >", "< Nazad");
    return 1;
}

Dialog:imanje_edit_do(playerid, response, listitem, const inputtext[])
{
    if (!response) return callcmd::editprop(playerid, "");

    if (isnull(inputtext)) 
        return DialogReopen(playerid);

    new land = GetPVarInt(playerid, "pEditingLand");

    if (listitem == 0) // Informacije
    {
        new sDialog[175],
            sZone[32],
            countTrees = 0,
            countTreeType[4] = {0, 0, 0, 0}
        ;

        Get2DZoneByPosition(LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], sZone, sizeof sZone);
        for__loop (new tree = 0; tree < MAX_TREES; tree++)
        {
            if (Tree_Exists(land, tree))
            {
                countTrees ++;
                countTreeType[TreeInfo[land][tree][TREE_TYPE]] ++;
            }
        }

        format(sDialog, sizeof sDialog, ""#FOREST_GREEN "Imanje (%s)\n\n\
            {FFFFFF}Vlasnik: "#FOREST_GREEN "%s\n\
            {FFFFFF}Cena: "#FOREST_GREEN "%s\n\
            {FFFFFF}Radius: "#FOREST_GREEN "%.1f metara\n\
            {FFFFFF}Zasadjeno: "#FOREST_GREEN "%i stabala\n\
              -  od toga: %i jabuka, %i kruska, %i sljiva", sZone, LandInfo[land][LAND_OWNER], formatMoneyString(LandInfo[land][LAND_PRICE]), LandInfo[land][LAND_RADIUS], countTrees, countTreeType[FRUIT_APPLE], countTreeType[FRUIT_PEAR], countTreeType[FRUIT_PLUM]);
        SPD(playerid, "imanje_edit_return", DIALOG_STYLE_MSGBOX, "Imanje - informacije", sDialog, "< Nazad", "");
    }

    else if (listitem == 1) // Izmena
    {
        SPD(playerid, "imanje_edit_info", DIALOG_STYLE_LIST, "Imanje - izmena", "Vlasnik\nRadius\nCena", "Dalje >", "< Nazad");
    }

    else if (listitem == 2) // Stavi na prodaju
    {
        Land_SetOnBuy(land);

        new sLog[75];
        format(sLog, sizeof sLog, "IMANJE - PRODAJA (ADMIN) | Izvrsio: %s | ID: %i", ime_obicno[playerid], land);
        Log_Write(LOG_IMOVINA, sLog);
    }
    return 1;
}

Dialog:imanje_edit_return(playerid, response, listitem, const inputtext[])
{
    new sInputtext[4];
    valstr(sInputtext, GetPVarInt(playerid, "pEditingLand"));
    dialog_respond:imanje_edit_id(playerid, 1, -1, sInputtext);
    return 1;
}

Dialog:imanje_edit_info(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    new land = GetPVarInt(playerid, "pEditingLand");

    if (listitem == 0) // Vlasnik
    {
        new sDialog[98];
        format(sDialog, sizeof sDialog, "{FFFFFF}Vlasnik: "#FOREST_GREEN"%s\n\n{FFFFFF}Upisite ime novog vlasnika:", LandInfo[land][LAND_OWNER]);
        SPD(playerid, "imanje_edit_info_owner", DIALOG_STYLE_INPUT, "Imanje - Izmena", sDialog, "Izmeni", "< Nazad");
    }

    else if (listitem == 1) // Radius
    {
        new sDialog[67];
        format(sDialog, sizeof sDialog, "{FFFFFF}Radius: "#FOREST_GREEN"%.1f\n\n{FFFFFF}Upisite novi radius:", LandInfo[land][LAND_RADIUS]);
        SPD(playerid, "imanje_edit_info_radius", DIALOG_STYLE_INPUT, "Imanje - Izmena", sDialog, "Izmeni", "< Nazad");
    }

    else if (listitem == 2) // Cena
    {
        new sDialog[70];
        format(sDialog, sizeof sDialog, "{FFFFFF}Cena: "#FOREST_GREEN"%s\n\n{FFFFFF}Upisite novu cenu:", formatMoneyString(LandInfo[land][LAND_PRICE]));
        SPD(playerid, "imanje_edit_info_price", DIALOG_STYLE_INPUT, "Imanje - Izmena", sDialog, "Izmeni", "< Nazad");
    }

    return 1;   
}

Dialog:imanje_edit_info_owner(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    if (isnull(inputtext))
        return DialogReopen(playerid);

    new land = GetPVarInt(playerid, "pEditingLand"),
        oldValue[MAX_PLAYER_NAME]
    ;

    format(oldValue, sizeof oldValue, "%s", LandInfo[land][LAND_OWNER]);
    format(LandInfo[land][LAND_OWNER], MAX_PLAYER_NAME, "%s", inputtext);
    SendClientMessageF(playerid, BELA, "* Izmenili ste vlasnika sa "#FOREST_GREEN"[%s] {FFFFFF}na "FOREST_GREEN"[%s] {FFFFFF}| Imanje [%i]", oldValue, inputtext, land);

    Land_UpdatePickup(land);

    new sQuery[75];
    mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE land SET owner = '%s' WHERE id = %i", LandInfo[land][LAND_OWNER], land);
    mysql_tquery(SQL, sQuery);

    dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    return 1;
}

Dialog:imanje_edit_info_radius(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    new Float:radius;
    if (sscanf(inputtext, "f", radius) || radius < 5.0 || radius > 100.0)
        return DialogReopen(playerid);

    new land = GetPVarInt(playerid, "pEditingLand"),
        Float:oldValue = LandInfo[land][LAND_RADIUS]
    ;

    LandInfo[land][LAND_RADIUS] = radius;
    SendClientMessageF(playerid, BELA, "* Izmenili ste radius sa "#FOREST_GREEN"[%.1f] {FFFFFF}na "FOREST_GREEN"[%.1f] {FFFFFF}| Imanje [%i]", oldValue, radius, land);

    new sQuery[50];
    format(sQuery, sizeof sQuery, "UPDATE land SET radius = '%.1f' WHERE id = %i", LandInfo[land][LAND_RADIUS], land);
    mysql_tquery(SQL, sQuery);

    dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    return 1;
}

Dialog:imanje_edit_info_price(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    new price;
    if (sscanf(inputtext, "i", price) || price < 1 || price > 99999999)
        return DialogReopen(playerid);

    new land = GetPVarInt(playerid, "pEditingLand"),
        oldValue = LandInfo[land][LAND_PRICE]
    ;

    LandInfo[land][LAND_PRICE] = price;
    SendClientMessageF(playerid, BELA, "* Izmenili ste cenu sa "#FOREST_GREEN"[%s] {FFFFFF}na "FOREST_GREEN"[%s] {FFFFFF}| Imanje [%i]", formatMoneyString(oldValue), formatMoneyString(price), land);

    Land_UpdatePickup(land);

    new sQuery[55];
    format(sQuery, sizeof sQuery, "UPDATE land SET price = %i WHERE id = %i", LandInfo[land][LAND_PRICE], land);
    mysql_tquery(SQL, sQuery);

    dialog_respond:imanje_edit_return(playerid, 1, -1, "");

    return 1;
}

Dialog:market(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0) // Prodaj voce
    {
        new sDialog[80];
        format(sDialog, sizeof sDialog, "Prodaj sve\n----\nJabuka\t%s /kom\nKruska\t%s /kom\nSljiva\t%s /kom", formatMoneyString(gMarketPrice[FRUIT_APPLE]), formatMoneyString(gMarketPrice[FRUIT_PEAR]), formatMoneyString(gMarketPrice[FRUIT_PLUM]));
        SPD(playerid, "market_sell_fruit", DIALOG_STYLE_TABLIST, "PRODAJ VOCE", sDialog, "Izaberi", "Nazad");
    }

    else if (listitem == 1) // Kupi voce
    {
        new sDialog[64];
        format(sDialog, sizeof sDialog, "Jabuka\t%s /kom\nKruska\t%s /kom\nSljiva\t%s /kom", formatMoneyString(gMarketPrice[FRUIT_APPLE]), formatMoneyString(gMarketPrice[FRUIT_PEAR]), formatMoneyString(gMarketPrice[FRUIT_PLUM]));
        SPD(playerid, "market_buy_fruit", DIALOG_STYLE_TABLIST, "KUPI VOCE", sDialog, "Izaberi", "Nazad");
    }

    // else if (listitem == 2) // Kupi seme
    // {
    //  new cmdParams[16];
    //  format(cmdParams, sizeof cmdParams, "/firmakupi %i", re_globalid(firma, MARKET_BIZ_ID));
    //  PC_EmulateCommand(playerid, cmdParams);
    // }

    return 1;
}

Dialog:market_sell_fruit(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pijaca(playerid, "");

    if (listitem == 0) // Prodaj sve
    {
        new apples = BP_PlayerItemGetCount(playerid, ITEM_APPLE),
            pears = BP_PlayerItemGetCount(playerid, ITEM_PEAR),
            plums = BP_PlayerItemGetCount(playerid, ITEM_PLUM),
            pay = apples*gMarketPrice[FRUIT_APPLE] + pears*gMarketPrice[FRUIT_PEAR] + plums*gMarketPrice[FRUIT_PLUM]
        ;

        if (apples+pears+plums <= 0)
            return ErrorMsg(playerid, "Nemate nikakvog voca za prodaju.");

        BP_PlayerItemSub(playerid, ITEM_APPLE, apples);
        BP_PlayerItemSub(playerid, ITEM_PEAR, pears);
        BP_PlayerItemSub(playerid, ITEM_PLUM, plums);

        gMarketProducts[FRUIT_APPLE] += apples;
        gMarketProducts[FRUIT_PEAR] += pears;
        gMarketProducts[FRUIT_PLUM] += plums;

        PlayerMoneyAdd(playerid, pay);

        SendClientMessageF(playerid, COLOR_MAGENTA_11, "PIJACA | Zaradili ste "#MAGENTA_14"%s "#MAGENTA_11"od prodaje %i jabuka, %i krusaka, %i sljiva.", formatMoneyString(pay), apples, pears, plums);

        new sQuery[62];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[108];
        format(sLog, sizeof sLog, "PRODAJA | %s | Jabuka: %i | Kruska: %i | Sljiva: %i | Zarada: %s", ime_obicno[playerid], apples, pears, plums, formatMoneyString(pay));
        Log_Write(LOG_MARKETPLACE, sLog);
    }

    else if (listitem == 1)
    {
        return DialogReopen(playerid);
    }

    else
    {
        new fruit = listitem-1,
            itemid = GetItemByFruit(fruit),
            sFruitName[10],
            quantity = BP_PlayerItemGetCount(playerid, itemid),
            pay = quantity*gMarketPrice[fruit]
        ;

        if (quantity <= 0)
            return ErrorMsg(playerid, "Ne posedujete ovo voce.");

        BP_PlayerItemSub(playerid, itemid, quantity);
        BP_GetItemName(itemid, sFruitName, sizeof sFruitName);
        
        PlayerMoneyAdd(playerid, pay);

        SendClientMessageF(playerid, COLOR_MAGENTA_11, "PIJACA | Zaradili ste "#MAGENTA_14"%s "#MAGENTA_11"od prodaje %s (%i kom).", formatMoneyString(pay), sFruitName, quantity);

        new sQuery[62];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[108];
        format(sLog, sizeof sLog, "PRODAJA | %s | %s: %i | Zarada: %s", ime_obicno[playerid], sFruitName, quantity, formatMoneyString(pay));
        Log_Write(LOG_MARKETPLACE, sLog);
    }

    return 1;
}

Dialog:market_buy_fruit(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pijaca(playerid, "");

    new fruit = listitem+1,
        itemid = GetItemByFruit(fruit),
        sFruitName[10]
    ;

    if (PI[playerid][p_novac] < gMarketPrice[fruit])
        return ErrorMsg(playerid, "Nemate dovoljno novca.");

    PlayerMoneySub(playerid, gMarketPrice[fruit]);
    BP_PlayerItemAdd(playerid, itemid);
    BP_GetItemName(itemid, sFruitName, sizeof sFruitName);
    InfoMsg(playerid, "Kupovina uspesna: {FFFFFF}%s (%s)", sFruitName, formatMoneyString(gMarketPrice[fruit]));

    return DialogReopen(playerid);
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:imanja("imanje")
CMD:imanja(playerid, const params[])
{
    new landCount = 0, id = -1;
    for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
    {
        if (gPlayerOwnedLand[playerid][i] > 0)
        {
            landCount ++;
            id = gPlayerOwnedLand[playerid][i];
        }
    }
        

    if (landCount == 1)
    {
        // Ako poseduje samo jedno, otvoriti mu odmah upravljanje tim imanjem
        new sInputtext[4];
        valstr(sInputtext, id);
        dialog_respond:imanja(playerid, 1, 0, sInputtext);
    }
    else if (landCount > 1)
    {
        // Ako poseduje vise imanja, prikazati mu listu
        new sDialog[60 * MAX_LAND_PER_PLAYER], sZone[32];
        for__loop (new i = 0; i < PI[playerid][p_imanja_slotovi]; i++)
        {
            new land = gPlayerOwnedLand[playerid][i];
            if (Land_Exists(land))
            {
                Get2DZoneByPosition(LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], sZone, sizeof sZone);
                format(sDialog, sizeof sDialog, "%s\n{000000}%i\tImanje %i\t%s", sDialog, gPlayerOwnedLand[playerid][i], i+1, sZone);
            }
        }

        SPD(playerid, "imanja", DIALOG_STYLE_LIST, "{FFFFFF}Spisak imanja", sDialog, "Dalje", "Izadji");
    }
    else
    {
        return ErrorMsg(playerid, "Ne posedujes imanje.");
    }
    return 1;
}

CMD:sadivoce(playerid, const params[])
{
    new land = GetPlayerLandID(playerid);

    if (land == -1)
        return ErrorMsg(playerid, "Ne nalazite se na imanju.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (!Land_CheckOwnership(land, playerid))
        return ErrorMsg(playerid, "Ovu naredbu mozete koristiti samo na svom imanju.");

    if (gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti sadjenje u ovom trenutku.");

    SPD(playerid, "land_seeding_start", DIALOG_STYLE_LIST, "{FF9D00}Koje voce sadite?", "Jabuka\nKruska\nSljiva", "Izaberi", "Odustani");

    return 1;
}

CMD:berivoce(playerid, const params[])
{
    new land = GetPlayerLandID(playerid);

    if (land == -1)
        return ErrorMsg(playerid, "Ne nalazite se na imanju.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (!Land_CheckOwnership(land, playerid))
        return ErrorMsg(playerid, "Ovu naredbu mozete koristiti samo na svom imanju.");

    if (IsPlayerHarvestingLand(playerid))
        return ErrorMsg(playerid, "Berba je vec u toku.");

    if (gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti branje u ovom trenutku.");

    gSeedingLand{playerid} = gSeedingFruitID{playerid} = gWateringLand{playerid} = gStealingFruit{playerid} = 0;
    gHarvestingLand{playerid} = land;

    SendClientMessageF(playerid, BELA, "* Zapoceli ste branje voca.");
    SendClientMessageF(playerid, BELA, "* Koristite ENTER (F) da pokupite plodove sa drveta pored koga se nalazite.");

    return 1;
}

alias:zalivaj("zalij", "zalivanje", "polivanje", "zalijvoce", "polijvoce")
CMD:zalivaj(playerid, const params[])
{
    new land = GetPlayerLandID(playerid);

    if (land == -1)
        return ErrorMsg(playerid, "Ne nalazite se na imanju.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (!Land_CheckOwnership(land, playerid))
        return ErrorMsg(playerid, "Ovu naredbu mozete koristiti samo na svom imanju.");

    if (gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti zalivanje u ovom trenutku.");

    gSeedingLand{playerid} = gSeedingFruitID{playerid} = gHarvestingLand{playerid} = gStealingFruit{playerid} = 0;
    gWateringLand{playerid} = land;

    SendClientMessageF(playerid, BELA, "* Zapoceli ste zalivanje drveca.");
    SendClientMessageF(playerid, BELA, "* Koristite ENTER (F) da zalijete drvo pored koga se nalazite.");

    return 1;
}

alias:kradivoce("ukradivoce")
CMD:kradivoce(playerid, const params[])
{
    if (IsNewPlayer(playerid))
        return ErrorMsg(playerid, "Igracima sa manje od 20 sati igre je zabranjeno da kradu voce.");

    new land = GetPlayerLandID(playerid);

    if (land == -1)
        return ErrorMsg(playerid, "Ne nalazite se na imanju.");

    if (land == 40 || land == 38 || land == 39)
        return ErrorMsg(playerid, "Ne mozete da kradete sa privatnog imanja.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (Land_CheckOwnership(land, playerid))
        return ErrorMsg(playerid, "Ne mozete da kradete voce sa svog imanja.");

    if (gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti kradju u ovom trenutku.");

    new ownerid = INVALID_PLAYER_ID;
    foreach (new i : Player)
    {
        if (Land_CheckOwnership(land, i))
        {
            ownerid = i;
            break;
        }
    }
    if (IsPlayerInDynamicArea(ownerid, LandInfo[land][LAND_AREA]))
        return ErrorMsg(playerid, "Ne mozete da kradete dok je vlasnik imanja prisutan.");

    gSeedingLand{playerid} = gSeedingFruitID{playerid} = gHarvestingLand{playerid} = gWateringLand{playerid} = 0;
    gStealingFruit{playerid} = land;

    SendClientMessageF(playerid, BELA, "* Zapoceli ste kradju voca.");
    SendClientMessageF(playerid, BELA, "* Koristite ENTER (F) da ukradete plodove sa drveta pored koga se nalazite.");

    return 1;
}

flags:dodajimanje(FLAG_ADMIN_6)
CMD:dodajimanje(playerid, const params[])
{
    new Float:radius, price,
        Float:x, Float:y, Float:z
    ;
    if (sscanf(params, "fi", radius, price))
        return Koristite(playerid, "dodajimanje [Radius] [Cena]");

    if (radius < 10 || radius > 100)
        return ErrorMsg(playerid, "Radius mora biti izmedju 10 i 100.");

    if (price < 1 || price > 99999999)
        return ErrorMsg(playerid, "Cena mora biti izmedju $1 i $99.999.999.");

    GetPlayerPos(playerid, x, y, z);

    mysql_tquery(SQL, "SELECT pos FROM land", "MySQL_CheckLandOccupancy", "iiffffi", playerid, cinc[playerid], x, y, z, radius, price);
    return 1;
}

alias:pijaca("trznica")
CMD:pijaca(playerid, const params[])
{
    if (RE_IsPlayerAtInteract(playerid, re_globalid(firma, MARKET_BIZ_ID)))
    {
        new cmdParams[16];
        format(cmdParams, sizeof cmdParams, "%i", re_globalid(firma, MARKET_BIZ_ID));
        callcmd::firmakupi(playerid, cmdParams);
    }
    else
    {
        if (!IsPlayerInRangeOfPoint(playerid, 7.0, 1003.5930,-1354.7419,13.5065))
            return ErrorMsg(playerid, "Niste na pijaci. Koristite: /gps -- Glavne lokacije -- Pijaca.");

        SPD(playerid, "market", DIALOG_STYLE_LIST, "PIJACA", "Prodaj voce\nKupi voce", "Dalje", "Izadji");
    }
    return 1;
}

flags:ceneupdate(FLAG_ADMIN_6)
CMD:ceneupdate(playerid, const params[])
{
    return UpdateMarketPrices();
}

flags:imanjetp(FLAG_ADMIN_6)
CMD:imanjetp(playerid, const params[])
{
    new land;
    if (sscanf(params, "i", land))
        return Koristite(playerid, "imanjetp [ID imanja]");

    if (!Land_Exists(land))
        return ErrorMsg(playerid, "To imanje ne postoji.");

    TeleportPlayer(playerid, LandInfo[land][LAND_POS][0], LandInfo[land][LAND_POS][1], LandInfo[land][LAND_POS][2]);
    return 1;
}

flags:treelabelson(FLAG_ADMIN_6)
CMD:treelabelson(playerid, const params[])
{
    new land;
    if (sscanf(params, "i", land))
        return Koristite(playerid, "treelabelson [ID imanja]");

    if (!Land_Exists(land))
        return ErrorMsg(playerid, "To imanje ne postoji.");

    for (new tree = 0; tree < MAX_TREES; tree++)
    {
        Tree_CreateInfoLabel(land, tree, playerid);
    }

    InfoMsg(playerid, "Labeli na drvecu su prikazani.");
    return 1;
}

flags:treelabelsoff(FLAG_ADMIN_6)
CMD:treelabelsoff(playerid, const params[])
{
    new land;
    if (sscanf(params, "i", land))
        return Koristite(playerid, "treelabelsoff [ID imanja]");

    if (!Land_Exists(land))
        return ErrorMsg(playerid, "To imanje ne postoji.");

    Land_DestroyTreeLabels(land);
    return 1;
}

flags:reload2(FLAG_ADMIN_6)
CMD:reload2(playerid, const params[])
{
    new land;
    if (sscanf(params, "i", land))
    {
        Koristite(playerid, "reload2 [ID imanja]  |  Ponovo kreira drvece");
        SendClientMessage(playerid, CRVENA, "Moras biti van imanja!");
        return 1;
    }

    if (!Land_Exists(land))
        return ErrorMsg(playerid, "Pogresan ID imanja.");

    // Unistavanje drveca, kao i labela
    if (LandInfo[land][LAND_LABEL_TIMER])
    {
        KillTimer(LandInfo[land][LAND_LABEL_TIMER]);
    }
    for__loop (new tree = 0; tree < MAX_TREES; tree++)
    {
        if (Tree_Exists(land, tree))
        {
            if (IsValidDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]))
                DestroyDynamicObject(TreeInfo[land][tree][TREE_OBJECT_ID]);

            if (IsValidDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]))
                DestroyDynamic3DTextLabel(TreeInfo[land][tree][TREE_LABEL]);

            Tree_ResetVariables(land, tree);
        }
    }

    new sQuery[43];
    format(sQuery, sizeof sQuery, "SELECT * FROM land_trees WHERE land = %i", land);
    mysql_tquery(SQL, sQuery, "MySQL_LoadLandTrees");
    return 1;
}