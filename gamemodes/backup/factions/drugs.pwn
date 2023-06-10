#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
// Hard-kodovane vrednosti u backpack.pwn; pri dodavanju novih supstanci, OBAVEZNO:
// - povecati MAX ID
// - promeniti MAX_APT_CHEM_ITEMS unutar real_estate.pwn (formula: substance-max-id - substance-min_id + 1)
// - dodati tu supstancu u Drugs_PackageIngradients
// - dodati tu supstancu u RE_ApartmentItems [real_estate.pwn / Dialog:re_sef]

#define DRUGS_SUBSTANCE_MIN_ID  59
#define DRUGS_SUBSTANCE_MAX_ID  66

#define MAX_SEEDS_PER_ROUTE     6

#define DRUG_TYPE_MDMA          0
#define DRUG_TYPE_HEROIN        1
#define DRUG_TYPE_ADRENALINE    2
#define DRUG_TYPE_WEED          3
#define MAX_DRUG_TYPES          4

#define DRUGS_GRACE_PERIOD      (600) // Koliko sekundi sme da prodje nakon zavrsene izrade, a da droga ne propadne

#define SEEDBAG_PRICE           5000 // Cena za vrecicu semena
#define PLANT_DISPLACEMENT      0.128 // ukupan pomeraj je 1.28; Rast traje 20 minuta sa azuriranjem na 2 minuta (displacement)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_DRUGS_PACKAGES
{
    DRUGS_PCK_PICKUPID,
    Float:DRUGS_PCK_POS[3],
    bool:DRUGS_PCK_COLLECTED,
    DRUGS_PCK_ITEM_ID[3],
    DRUGS_PCK_ITEM_COUNT[3],
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new Drugs_itemSelectedAmount[MAX_PLAYERS][DRUGS_SUBSTANCE_MAX_ID - DRUGS_SUBSTANCE_MIN_ID + 1],
    Drugs_effectEndtime[MAX_PLAYERS][MAX_DRUG_TYPES],
    tmrDrugsEffect[MAX_PLAYERS][MAX_DRUG_TYPES];

static gSeedsPurchaseArea;
static gWeedPlantArea;
static gWeedPlantArea2;
static gWeedDryingArea;
static bool:gHarvestingWeed[MAX_PLAYERS char];
static bool:gSeedingWeed[MAX_PLAYERS char];
static bool:gBlockKeyPress[MAX_PLAYERS char];
static gWeedActionID[MAX_PLAYERS char];

new DRUGS_PACKAGES[][E_DRUGS_PACKAGES] = 
{
    {-1, {-399.3784,-422.3250,16.2109},     false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {276.2390,4.1372,2.4334},          false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {760.6530,378.5914,23.1711},       false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {2329.4978,-52.3102,26.4844},      false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {2351.5657,-650.3878,128.0547},    false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {2446.2932,-1900.8821,13.5469},    false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {-383.9338,-1040.1874,58.8887},    false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {-1080.4553,-1296.7692,129.2188},  false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {-1446.7141,-1543.2937,101.7578},  false, {-1, -1, -1}, {0, 0, 0}},
    {-1, {687.2717,-444.7280,16.3359},      false, {-1, -1, -1}, {0, 0, 0}}
};

new Drugs_PackageIngradients[] = {59, 60, 61, 62, 63, 64};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    // Kupovina semena
    gSeedsPurchaseArea = CreateDynamicSphere(870.2025,-25.2336,63.9688, 2.0, 0, 0);
    CreateDynamic3DTextLabel("Kupovina semena\n1 vrecica = "#GREEN_9"$"#SEEDBAG_PRICE, BELA, 870.2025,-25.2336,63.9688, 25.0);

    // gWeedPlantArea = CreateDynamicRectangle(238.22,1032.1,282.75,1098.79, 0, 0);(219.36,1120.45,266.71,1156.36
    gWeedPlantArea = CreateDynamicRectangle(1509.7961, -27.3926, 1432.8833, -95.2832, 0, 0);
    gWeedPlantArea2 = CreateDynamicRectangle(1432.8833, -95.2832, 1496.8761, -129.6511, 0, 0);

    // Susenje marihuane
    CreateDynamic3DTextLabel("Susenje marihuane", BELA, -2416.3477,-2462.1914,-77.8954, 15.0);
    gWeedDryingArea = CreateDynamicSphere(-2416.3477,-2462.1914,-77.8954, 4.0);

    // Actori u laboratoriji
    CreateDynamicActor(145, -2414.9104,-2466.7881,-77.8954,180.0, 1, 100.0, 111, 1);
    CreateDynamicActor(145, -2414.9436,-2468.6953,-77.8954,0.000, 1, 100.0, 111, 1);
    CreateDynamicActor(145, -2414.8589,-2455.6555,-77.8954,0.000, 1, 100.0, 111, 1);
    CreateDynamicActor(145, -2414.8965,-2453.7478,-77.8954,180.0, 1, 100.0, 111, 1);

    CreateDynamicActor(145, -2414.9104,-2466.7881,-77.8954,180.0, 1, 100.0, 111, 2);
    CreateDynamicActor(145, -2414.9436,-2468.6953,-77.8954,0.000, 1, 100.0, 111, 2);
    CreateDynamicActor(145, -2414.8589,-2455.6555,-77.8954,0.000, 1, 100.0, 111, 2);
    CreateDynamicActor(145, -2414.8965,-2453.7478,-77.8954,180.0, 1, 100.0, 111, 2);

    CreateDynamicActor(145, -2414.9104,-2466.7881,-77.8954,180.0, 1, 100.0, 111, 3);
    CreateDynamicActor(145, -2414.9436,-2468.6953,-77.8954,0.000, 1, 100.0, 111, 3);
    CreateDynamicActor(145, -2414.8589,-2455.6555,-77.8954,0.000, 1, 100.0, 111, 3);
    CreateDynamicActor(145, -2414.8965,-2453.7478,-77.8954,180.0, 1, 100.0, 111, 3);

    DRUGS_PackagesDrop_Init();

    // Ciscenje tabele za izradu droge (ono sto je propalo, a nije provereno)
    mysql_tquery(SQL, "DELETE FROM drugs_prep WHERE finish_ts <= UNIX_TIMESTAMP()");
    mysql_tquery(SQL, "DELETE FROM drugs_prep WHERE type = "#DRUG_TYPE_WEED);
    return true;
}

hook OnPlayerConnect(playerid)
{
    for__loop (new i = 0; i < MAX_DRUG_TYPES; i++)
    {
        Drugs_effectEndtime[playerid][i] = 0;
        tmrDrugsEffect[playerid][i] = 0;
    }

    gHarvestingWeed{playerid} = false;
    gSeedingWeed{playerid} = false;
    gBlockKeyPress{playerid} = false;
    gWeedActionID{playerid} = 0;
}

hook OnPlayerDisconnect(playerid, reason)
{
    for__loop (new i = 0; i < MAX_DRUG_TYPES; i++)
    {
        KillTimer(tmrDrugsEffect[playerid][i]);
    }

    // Unistavanje strelica za harvest
    if (gHarvestingWeed{playerid})
    {
        for__loop (new i = 1; i <= BP_GetItemCountLimit(ITEM_SEED)*2; i++)
        {
            new pvarName[14];
            format(pvarName, sizeof pvarName, "PlantArrow_%i", i);
            if (GetPVarInt(playerid, pvarName))
            {
                DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, pvarName));
            }
        }
    }
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (tmrDrugsEffect[playerid][DRUG_TYPE_MDMA])
    {
        HideColorScreen(playerid);
        KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_MDMA]);
    }

    if (tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN])
    {
        SetPlayerDrunkLevel(playerid, 0);
        KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN]);
    }  

    if (tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE])
    {
        KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE]);
    }  
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if (GetPVarInt(playerid, "pAdrenalinePickup") && pickupid == GetPVarInt(playerid, "pAdrenalinePickup"))
    {
        TogglePlayerControllable_H(playerid, true);
        DestroyDynamicPickup(pickupid);
        DeletePVar(playerid, "pAdrenalinePickup");
        return ~1;
    }
    
    for__loop (new i = 0; i < sizeof DRUGS_PACKAGES; i++)
    {
        if (DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID] == pickupid)
        {
            // Igrac je stao na pickup za paket sastojaka
            if (DRUGS_PACKAGES[i][DRUGS_PCK_COLLECTED])
                return ErrorMsg(playerid, "Na ovom mestu nema nikakve robe.");

            if (!BP_PlayerHasBackpack(playerid))
                return ErrorMsg(playerid, "Ne posedujete ranac. Mozete ga kupiti u bilo kom marketu ili prodavnici tehnike.");

            new bool:error = false, logStr[170];
            format(logStr, sizeof logStr, "%s", ime_obicno[playerid]);
            SendClientMessage(playerid, ZUTA, "* Pokupili ste paket sa sledecim preparatima:");

            for__loop (new j = 0; j < 3; j++)
            {
                new itemid = DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_ID][j],
                    count = DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_COUNT][j];

                if (itemid != -1 && count > 0)
                {
                    new addCount = count, sItemName[25];

                    if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(playerid, itemid) + count))
                    {
                        error = true; // prekoracio je limit za ovaj predmet

                        addCount = BP_GetItemCountLimit(itemid) - BP_PlayerItemGetCount(playerid, itemid);
                    }

                    BP_PlayerItemAdd(playerid, itemid, addCount);
                    BP_GetItemName(itemid, sItemName, sizeof sItemName);
                    SendClientMessageF(playerid, BELA, "- %s: %ig%s", sItemName, count, addCount<count? (" (nedovoljno mesta)"):(""));

                    format(logStr, sizeof logStr, "%s | %s %i gr", logStr, sItemName, addCount);
                }
            }
            if (error)
                SendClientMessage(playerid, SVETLOCRVENA, "* Neki sastojci nisu mogli biti dodati u ranac jer nemate dovoljno mesta.");

            DRUGS_PACKAGES[i][DRUGS_PCK_COLLECTED] = true;

            Log_Write(LOG_MEDSPACKAGE, logStr);
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if ((gHarvestingWeed{playerid} || gSeedingWeed{playerid}) && !GetPlayerInterior(playerid) && !GetPlayerVirtualWorld(playerid))
    {
        if (gHarvestingWeed{playerid})
        {
            for__loop (new i = 1; i <= BP_GetItemCountLimit(ITEM_SEED)*2; i++)
            {
                new pvarName[14];
                format(pvarName, sizeof pvarName, "PlantArrow_%i", i);
                if (GetPVarInt(playerid, pvarName))
                {
                    DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, pvarName));
                }
                DeletePVar(playerid, pvarName);

                format(pvarName, sizeof pvarName, "PlantEntry_%i", i);
                DeletePVar(playerid, pvarName);
            }
        }


        gHarvestingWeed{playerid} = gSeedingWeed{playerid} = false;
        gWeedActionID{playerid} = 0;
        gBlockKeyPress{playerid} = false;

        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = "Napustili ste plantazu.", .lines = 1, .durationMs = 5000);
    }
    else
    {
        ptdServerTips_HideMsg(playerid);
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == gSeedsPurchaseArea)
    {
        if (IsACop(playerid) || IsAMobster(playerid))
            return ErrorMsg(playerid, "Samo civili i pripadnici bandi mogu da kupuju na ovom mestu.");

        new sDialog[58];
        format(sDialog, sizeof sDialog, "{FFFFFF}Jedna vrecica sadrzi %i semena i kosta %s.", BP_GetItemCountLimit(ITEM_SEED), formatMoneyString(SEEDBAG_PRICE));
        SPD(playerid, "SeedsPurchase", DIALOG_STYLE_MSGBOX, "Kupovina semena", sDialog, "Kupi", "Odustani");
        return ~1;
    }

    if (areaid == gWeedPlantArea || areaid == gWeedPlantArea2 && !gHarvestingWeed{playerid} && !gSeedingWeed{playerid})
    {
        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = "Usli ste na plantazu marihuane.~N~Komande: ~g~~h~/sadi, ~b~~h~/beri", .lines = 2);
    }

    if (areaid == gWeedDryingArea)
    {
        if (!BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW))
            return ErrorMsg(playerid, "Nemate sirovog kanabisa za susenje.");

        new sDialog[210];
        format(sDialog, sizeof sDialog, "{FFFFFF}Imate {FF9933}%i grama {FFFFFF}sirovog kanabisa.\nZa svakih 10 grama sirovog kanabisa, nakon susenja dobijate {00CC00}1 gram {FFFFFF}marihuane.\n\nUnesite kolicinu za susenje (10, 20, 30, 40, ...):", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW));
        SPD(playerid, "WeedDrying", DIALOG_STYLE_INPUT, "Susenje kanabisa", sDialog, "Potvrdi", "Odustani");
        return ~1;
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (!(newkeys & KEY_SECONDARY_ATTACK) && oldkeys & KEY_SECONDARY_ATTACK) // Enter
    {
        if (IsPlayerInWeedField(playerid) && !IsPlayerInAnyVehicle(playerid) && !gBlockKeyPress{playerid})
        {
            if (gHarvestingWeed{playerid} && !gWeedActionID{playerid})
            {
                new Float:x, Float:y, Float:z;

                // Max je BP_GetItemCountLimit(ITEM_SEED)*2 (dve vrecice semena)
                for__loop (new i = 1; i <= BP_GetItemCountLimit(ITEM_SEED)*4; i++) // ovdje izmjena
                {
                    // pvarName krece brojanje od 1, a ne od 0!
                    new pvarName[14];
                    format(pvarName, sizeof pvarName, "PlantArrow_%i", i);


                    if (GetPVarInt(playerid, pvarName) > 0)
                    {
                        GetDynamicObjectPos(GetPVarInt(playerid, pvarName), x, y, z);
                        if (IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z-1.5))
                        {

                            ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
                            gBlockKeyPress{playerid} = true;
                            gWeedActionID{playerid} = i;

                            SetTimerEx("WeedHarvestAnimation", 5000, false, "ii", playerid, cinc[playerid]);
                            break;
                        }
                    }
                }

                if (!gWeedActionID{playerid})
                    return ErrorMsg(playerid, "Popunili ste sva raspoloziva polja (%i).", BP_GetItemCountLimit(ITEM_SEED)*4);
            }
            else if (gSeedingWeed{playerid} && !gWeedActionID{playerid})
            {
                if (BP_PlayerItemGetCount(playerid, ITEM_SEED) <= 0)
                {
                    gSeedingWeed{playerid} = false;
                    gWeedActionID{playerid} = 0;
                    return ErrorMsg(playerid, "Potrosili ste sva semena.");
                }

                gBlockKeyPress{playerid} = true;

                new sQuery[117];
                format(sQuery, sizeof sQuery, "SELECT COUNT(*) FROM drugs_prep WHERE type = %i AND finish_ts > UNIX_TIMESTAMP()-%i AND pid = %i", DRUG_TYPE_WEED, DRUGS_GRACE_PERIOD, PI[playerid][p_id]);
                mysql_tquery(SQL, sQuery, "MySQL_CheckWeedPlots", "ii", playerid, cinc[playerid]);
            }
        }
    }
    return 1;
}

hook OnProgressFinish(playerid)
{
    new quantity = GetPVarInt(playerid, "pDryingGramage");
    if (quantity && GetPlayerVirtualWorld(playerid) > 0)
    {
        DeletePVar(playerid, "pDryingGramage");

        if (BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW) < quantity)
        {
            ErrorMsg(playerid, "Na raspolaganju imate %i grama (stavili ste %i grama na susenje).", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW), quantity);
            return 1;
        }


        BP_PlayerItemSub(playerid, ITEM_WEED_RAW, quantity);
        BP_PlayerItemAdd(playerid, ITEM_WEED, floatround(quantity/10.0));

        SendClientMessageF(playerid, BELA, "* Osuseno je {FFFF00}%i grama {FFFFFF}sirovog kanabisa i pretvoreno u {00CC00}%i grama {FFFFFF}marihuane.", quantity, floatround(quantity/10.0));

        // Upisivanje u log
        new sLog[64];
        format(sLog, sizeof sLog, "%s je susenjem dobio %i g marihuane.", ime_obicno[playerid], floatround(quantity/10.0));
        Log_Write(LOG_MARIJUANA, sLog);
        
        return ~1;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward WeedHarvestAnimation(playerid, ccinc);
public WeedHarvestAnimation(playerid, ccinc)
{
    gBlockKeyPress{playerid} = false;

    if (!checkcinc(playerid, ccinc) || !gWeedActionID{playerid} || !gHarvestingWeed{playerid}) return 1;

    ClearAnimations(playerid);
    
    new pvarName[14];
    format(pvarName, sizeof pvarName, "PlantArrow_%i", gWeedActionID{playerid});
    DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, pvarName));
    DeletePVar(playerid, pvarName);

    new sPropName[13], entryId;
    format(pvarName, sizeof pvarName, "PlantEntry_%i", gWeedActionID{playerid});
    entryId = GetPVarInt(playerid, pvarName);
    format(sPropName, sizeof sPropName, "Plant_%i", entryId);

    // Unistavamo objekat
    new objectid;
    if (existproperty(_, sPropName))
    {
        objectid = getproperty(_, sPropName);
        DestroyDynamicObject(objectid);
        setproperty(_, sPropName, -1);
    }


    BP_PlayerItemAdd(playerid, ITEM_WEED_RAW, 10);
    SendClientMessageF(playerid, BELA, "* Sirovi kanabis u rancu: {FF9933}%i grama", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW));

    // Brisanje iz baze
    new sQuery[42];
    format(sQuery, sizeof sQuery, "DELETE FROM drugs_prep WHERE id = %i", entryId);
    mysql_tquery(SQL, sQuery);

    gWeedActionID{playerid} = 0;

    UpdatePVarInt(playerid, "pHarvestedWeedCount", 1);
    UpdatePVarInt(playerid, "pWeedRemainingCount", -1);

    if (GetPVarInt(playerid, "pWeedRemainingCount") > 0)
    {
        new sMsg[132];
        format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da berete marihuanu sa zrelih polja na plantazi.~N~~N~Obrano polja: ~g~~h~%i~N~~W~Preostala polja: ~Y~~H~%i", GetPVarInt(playerid, "pHarvestedWeedCount"), GetPVarInt(playerid, "pWeedRemainingCount"));
        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = sMsg, .lines = 5);
    }
    else
    {
        gHarvestingWeed{playerid} = false;
        gWeedActionID{playerid} = 0;
        gBlockKeyPress{playerid} = false;

        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = "Sva polja su obrana!~N~Idite u laboratoriju da osusite marihuanu.", .lines = 3, .durationMs = 20000);
    }

    // Upisivanje u log
    new sLog[46];
    format(sLog, sizeof sLog, "%s je obrao biljku.", ime_obicno[playerid]);
    Log_Write(LOG_MARIJUANA, sLog);
    return 1;
}

forward WeedSeedingAnimation(Float:x, Float:y, Float:z, entryId, playerid, ccinc);
public WeedSeedingAnimation(Float:x, Float:y, Float:z, entryId, playerid, ccinc)
{
    gBlockKeyPress{playerid} = false;

    if (!checkcinc(playerid, ccinc) || !gSeedingWeed{playerid}) return 1;

    ClearAnimations(playerid);

    new sPropName[13],
        objectid = CreateDynamicObject(3409, x, y, z-2.4, 0.0, 0.0, 0.0, 0, 0);

    Streamer_Update(playerid);

    format(sPropName, sizeof sPropName, "Plant_%i", entryId);
    setproperty(_, sPropName, objectid);

    SetTimerEx("WeedGrowth", 120*1000, false, "iiiii", playerid, cinc[playerid], entryId, objectid, 1);


    if (BP_PlayerItemGetCount(playerid, ITEM_SEED))
    {
        new sMsg[112];
        format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da sadite semena na slobodnim poljima po plantazi.~N~~N~Raspolozivih semena: ~g~~h~%i", BP_PlayerItemGetCount(playerid, ITEM_SEED));
        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = sMsg, .lines = 4);
    }
    else
    {
        gSeedingWeed{playerid} = false;
        ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = "Potrosili ste sva semena!~N~Vreme rasta: ~g~~h~20 minuta~N~~W~Nakon 20 minuta, imate dodatnih 10 minuta da oberete biljku pre nego sto ona propadne!", .lines = 5, .durationMs = 10000);
    }

    // Upisivanje u log
    new sLog[46];
    format(sLog, sizeof sLog, "%s je posadio seme.", ime_obicno[playerid]);
    Log_Write(LOG_MARIJUANA, sLog);
    return 1;
}

forward WeedGrowth(playerid, ccinc, entryId, objectid, stage);
public WeedGrowth(playerid, ccinc, entryId, objectid, stage)
{
    if (stage <= 10)
    {
        // Faza rasta
        new Float:x, Float:y, Float:z;
        GetDynamicObjectPos(objectid, x, y, z);
        MoveDynamicObject(objectid, x, y, z+PLANT_DISPLACEMENT, PLANT_DISPLACEMENT);
        
        stage++;
        if (stage <= 10)
        {
            SetTimerEx("WeedGrowth", 120*1000, false, "iiiii", playerid, cinc[playerid], entryId, objectid, stage);
        }
        else
        {
            SetTimerEx("WeedGrowth", DRUGS_GRACE_PERIOD*1000, false, "iiiii", playerid, cinc[playerid], entryId, objectid, stage);

            // Igracu treba stvoriti strelicu iznad ovog polja ukoliko je branje droge u toku i ako je on na plantazi
            if (gHarvestingWeed{playerid} && IsPlayerInWeedField(playerid))
            {
                for__loop (new i = 1; i <= BP_GetItemCountLimit(ITEM_SEED)*2; i++)
                {
                    new pvarName[14];
                    format(pvarName, sizeof pvarName, "PlantArrow_%i", i);
                    if (GetPVarInt(playerid, pvarName) == 0)
                    {
                        SetPVarInt(playerid, pvarName, _:CreatePlayerArrow(playerid, x, y, z + 1.5, x, y, z, 19606));

                        format(pvarName, sizeof pvarName, "PlantEntry_%i", i);
                        SetPVarInt(playerid, pvarName, entryId);

                        Streamer_Update(playerid);


                        UpdatePVarInt(playerid, "pWeedRemainingCount", 1);
                        if (GetPVarInt(playerid, "pWeedRemainingCount") > 0)
                        {
                            new sMsg[132];
                            format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da berete marihuanu sa zrelih polja na plantazi.~N~~N~Obrano polja: ~g~~h~%i~N~~W~Preostala polja: ~Y~~H~%i", GetPVarInt(playerid, "pHarvestedWeedCount"), GetPVarInt(playerid, "pWeedRemainingCount"));
                            ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = sMsg, .lines = 5);
                        }
                        break;
                    }
                }
            }
        }
    }
    else
    {
        // Biljka je prezrela ukoliko u medjuvremenu nije obrana
        // Ako je igrac obrao biljku, onda ce njen GVar biti postavljen na -1
        // Ukoliko igrac nije stigao na vreme i nije obrao biljku, njen GVar ce imati vrednost >0
        // U svakom slucaju, GVar se unistava iskljucivo na ovom mestu, a ne prilikom branja
        /*
            Branje postavlja Plant_ID na -1, a ne unistava GVar!!
        */

        new sPropName[13];
        format(sPropName, sizeof sPropName, "Plant_%i", entryId);
        if (existproperty(_, sPropName) && getproperty(_, sPropName) == -1)
        {
            // Biljka je obrana
            DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, sPropName));
        }
        else
        {
            // Biljka nije obrana

            DestroyDynamicObject(objectid);

            new sQuery[42];
            format(sQuery, sizeof sQuery, "DELETE FROM drugs_prep WHERE id = %i", entryId);
            mysql_tquery(SQL, sQuery);

            DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, sPropName));

            // TODO: sta ako propadne dok igrac bere -> treba mu unistiti strelicu!
        }

        if (existproperty(_, sPropName))
        {
            deleteproperty(_, sPropName);
        }
    }

    return 1;
}

IsPlayerInWeedField(playerid)
{
    if (IsPlayerInDynamicArea(playerid, gWeedPlantArea) || IsPlayerInDynamicArea(playerid, gWeedPlantArea2)) return 1;

    return 0;
}

IsPlayerOnMDMA(playerid)
{
    return (Drugs_effectEndtime[playerid][DRUG_TYPE_MDMA] > gettime());
}

stock DRUGS_GetSubstanceMinID()
{
    return DRUGS_SUBSTANCE_MIN_ID;
}

stock DRUGS_GetSubstanceMaxID()
{
    return DRUGS_SUBSTANCE_MAX_ID;
}

stock DRUGS_PackagesDrop_Init()
{
    if (DebugFunctions())
    {
        LogFunctionExec("DRUGS_PackagesDrop_Init");
    }

    new h, m, s, timerInterval;
    gettime(h, m, s);
    timerInterval = 3600 - h*60 - s;

    SetTimer("DRUGS_PackagesDrop", (timerInterval - 400 + random(800)) * 1000, false);
}

forward DRUGS_PackagesDrop();
public DRUGS_PackagesDrop()
{
    if (DebugFunctions())
    {
        LogFunctionExec("DRUGS_PackagesDrop");
    }

    for__loop (new i = 0; i < sizeof DRUGS_PACKAGES; i++)
    {
        // Resetovanje
        if (DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID] != -1)
        {
            DestroyDynamicPickup(DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID]);
            DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID] = -1;
        }
        for__loop (new j = 0; j < 3; j++)
        {
            DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_ID][j] = -1;
            DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_COUNT][j] = 0;
        }
        DRUGS_PACKAGES[i][DRUGS_PCK_COLLECTED] = false;


        // Kreiranje paketa
        DRUGS_PACKAGES[i][DRUGS_PCK_PICKUPID] = CreateDynamicPickup(1279, 1, DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_X], DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_Y], DRUGS_PACKAGES[i][DRUGS_PCK_POS][POS_Z], 0, 0);

        new availableAmount = 100 + random(60);
        for__loop (new j = 0; j < 3; j++)
        {
            new amount = 1 + random(availableAmount);
            DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_ID][j] = Drugs_PackageIngradients[random(sizeof(Drugs_PackageIngradients))];
            DRUGS_PACKAGES[i][DRUGS_PCK_ITEM_COUNT][j] = amount;

            availableAmount -= amount;
            if (availableAmount <= 0)
                break;
        }
    }

    // Obavestenje za sve igrace
    foreach (new i : Player)
    {
        if (IsPlayerLoggedIn(i))
            SendClientMessage(i, CRVENA, "[DILER] {FFFF80}Paketi sa hemijskim preparatima su isporuceni na svim lokacijama.");
            // SendClientMessage(i, ZUTA, "*** Paketi sa hemijskim preparatima su isporuceni na svim lokacijama.");
    }

    // Tajmer za sledeci drop
    SetTimer("DRUGS_PackagesDrop", (3600 - 400 + random(800))*1000, false);

    Log_Write(LOG_MEDSPACKAGE, "--------- [ NOVI DROP ] ---------");
    return 1;
}

forward Drugs_MDMAEffect(playerid, ccinc);
public Drugs_MDMAEffect(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_MDMAEffect");
    }

    if (!checkcinc(playerid, ccinc) || Drugs_effectEndtime[playerid][DRUG_TYPE_MDMA] < gettime())
    {
        KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_MDMA]);
        tmrDrugsEffect[playerid][DRUG_TYPE_MDMA] = 0;
        HideColorScreen(playerid);
        return 1;
    }
    
    PlayerHungerDecrease(playerid, 1);
    return 1;
}

forward Drugs_HeroinEffect(playerid, ccinc);
public Drugs_HeroinEffect(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_HeroinEffect");
    }

    if (!checkcinc(playerid, ccinc) || Drugs_effectEndtime[playerid][DRUG_TYPE_HEROIN] < gettime())
    {
        KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN]);
        tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN] = 0;
        SetPlayerDrunkLevel(playerid, 0);
        return 1;
    }
    

    if (GetPlayerDrunkLevel(playerid) <= 3000)
    {
        SetPlayerDrunkLevel(playerid, 4000);
    }

    new Float:health, Float:armour;
    GetPlayerHealth(playerid, health);
    GetPlayerArmour(playerid, armour);

    if (Drugs_effectEndtime[playerid][DRUG_TYPE_ADRENALINE] >= gettime())
    {
        // Adrenalin je aktivan - dodaj pancir ako je hp pun
        if (health >= 99.0)
        {
            SetPlayerArmour(playerid, ((armour+4.0)>40.0)? 40.0 : (armour+4.0));
        }
    }
    SetPlayerHealth(playerid, ((health+4.0)>99.0)? 99.0 : (health+4.0));
    return 1;
}

forward Drugs_AdrenalineEffect(playerid, ccinc);
public Drugs_AdrenalineEffect(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_AdrenalineEffect");
    }

    KillTimer(tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE]);
    tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE] = 0;
    if (checkcinc(playerid, ccinc))
    {
        SetPlayerArmour(playerid, 0.0);
        SendClientMessage(playerid, SVETLOCRVENA, "(adrenalin) {FFFFFF}Efekat adrenalina je prosao.");
    }

}

stock Drugs_OpenRecipeDialog(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_OpenRecipeDialog");
    }

    if (IsAGangster(playerid) || IsACop(playerid))
        return ErrorMsg(playerid, "Samo civili i pripadnici mafija mogu da prave drogu (Heroin i MDMA).");

    for__loop (new i = 0; i < sizeof Drugs_itemSelectedAmount[]; i++)
    {
        Drugs_itemSelectedAmount[playerid][i] = 0;
    }

    return SPD(playerid, "drugs_garage_1", DIALOG_STYLE_LIST, "Priprema droge", "Status\nPriprema\nSusenje marihuane", "Dalje", "Izadji");
}

stock GetDrugName(drug, szDest[], len)
{
    if (drug == DRUG_TYPE_MDMA) 
    {
        format(szDest, len, "MDMA");
    }
    else if (drug == DRUG_TYPE_HEROIN)
    {
        format(szDest, len, "Heroin");
    }
    else if (drug == DRUG_TYPE_ADRENALINE)
    {
        format(szDest, len, "Adrenalin");
    }
    else if (drug == DRUG_TYPE_WEED)
    {
        format(szDest, len, "Marihuana");
    }
    else
    {
        format(szDest, len, "[greska]");
    }
}

stock DRUGS_SeizeFromPlayer(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("DRUGS_SeizeFromPlayer");
    }

    BP_PlayerItemRemove(playerid, ITEM_MDMA);
    BP_PlayerItemRemove(playerid, ITEM_HEROIN);
    BP_PlayerItemRemove(playerid, ITEM_ADRENALIN);
    BP_PlayerItemRemove(playerid, ITEM_WEED_RAW);
    BP_PlayerItemRemove(playerid, ITEM_WEED_UNCURED);
    BP_PlayerItemRemove(playerid, ITEM_WEED);
    BP_PlayerItemRemove(playerid, ITEM_SEED);
}

stock Drugs_CheckRecipe(playerid, drugType)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_CheckRecipe");
    }

    if (drugType == DRUG_TYPE_MDMA)
    {
        if (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] > 0)
        {
            // Da li su odnosi dobri?
            if (   (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] % 10) != (Drugs_itemSelectedAmount[playerid][ITEM_BROMOPROPAN - DRUGS_SUBSTANCE_MIN_ID] % 30)
                || (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] % 10) != (Drugs_itemSelectedAmount[playerid][ITEM_METILAMIN - DRUGS_SUBSTANCE_MIN_ID] % 20)
                || (Drugs_itemSelectedAmount[playerid][ITEM_BROMOPROPAN - DRUGS_SUBSTANCE_MIN_ID] % 30) != (Drugs_itemSelectedAmount[playerid][ITEM_METILAMIN - DRUGS_SUBSTANCE_MIN_ID] % 20)
                )
            {
                return 0;
            }


            // Da li svega ima za jednaku kolicinu droge (ako trerba 10, 20, 30 za 1g, ne sme da ima 20, 20, 30 npr)
            if (   (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] / 10) != (Drugs_itemSelectedAmount[playerid][ITEM_BROMOPROPAN - DRUGS_SUBSTANCE_MIN_ID] / 30)
                || (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] / 10) != (Drugs_itemSelectedAmount[playerid][ITEM_METILAMIN - DRUGS_SUBSTANCE_MIN_ID] / 20)
                || (Drugs_itemSelectedAmount[playerid][ITEM_BROMOPROPAN - DRUGS_SUBSTANCE_MIN_ID] / 30) != (Drugs_itemSelectedAmount[playerid][ITEM_METILAMIN - DRUGS_SUBSTANCE_MIN_ID] / 20)
                )
            {
                return 0;
            }


            // Provera da li ima dovoljno (ili vise vode)
            if ((Drugs_itemSelectedAmount[playerid][ITEM_DEMIVODA - DRUGS_SUBSTANCE_MIN_ID]/500) < (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID]/10))
            {
                return 0;
            }

            return Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] / 10;
        }
        return 0;
    }


    else if (drugType == DRUG_TYPE_HEROIN)
    {
        if (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] > 0)
        {
            // Da li su odnosi dobri?
            if (   (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] % 30) != (Drugs_itemSelectedAmount[playerid][ITEM_ACETANHIDRID - DRUGS_SUBSTANCE_MIN_ID] % 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] % 30) != (Drugs_itemSelectedAmount[playerid][ITEM_HLOROFORM - DRUGS_SUBSTANCE_MIN_ID] % 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_ACETANHIDRID - DRUGS_SUBSTANCE_MIN_ID] % 10) != (Drugs_itemSelectedAmount[playerid][ITEM_HLOROFORM - DRUGS_SUBSTANCE_MIN_ID] % 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] % 30) != (Drugs_itemSelectedAmount[playerid][ITEM_ALKOHOL - DRUGS_SUBSTANCE_MIN_ID] % 100)
                )
            {
                return 0;
            }


            // Da li svega ima za jednaku kolicinu droge (ako trerba 10, 20, 30 za 1g, ne sme da ima 20, 20, 30 npr)
            if (   (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] / 30) != (Drugs_itemSelectedAmount[playerid][ITEM_ACETANHIDRID - DRUGS_SUBSTANCE_MIN_ID] / 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] / 30) != (Drugs_itemSelectedAmount[playerid][ITEM_HLOROFORM - DRUGS_SUBSTANCE_MIN_ID] / 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_ACETANHIDRID - DRUGS_SUBSTANCE_MIN_ID] / 10) != (Drugs_itemSelectedAmount[playerid][ITEM_HLOROFORM - DRUGS_SUBSTANCE_MIN_ID] / 10)
                || (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] / 30) != (Drugs_itemSelectedAmount[playerid][ITEM_ALKOHOL - DRUGS_SUBSTANCE_MIN_ID] / 100)
                )
            {
                return 0;
            }


            // Provera da li ima dovoljno (ili vise vode)
            if ((Drugs_itemSelectedAmount[playerid][ITEM_DEMIVODA - DRUGS_SUBSTANCE_MIN_ID]/500) < (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID]/30))
            {
                return 0;
            }

            return Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] / 30;
        }
        return 0;
    }
    return 0;
}

stock DRUGS_RandomDropLocation(&Float:x, &Float:y, &Float:z)
{
    new rand = random(sizeof DRUGS_PACKAGES);
    x = DRUGS_PACKAGES[rand][DRUGS_PCK_POS][0];
    y = DRUGS_PACKAGES[rand][DRUGS_PCK_POS][1];
    z = DRUGS_PACKAGES[rand][DRUGS_PCK_POS][2];
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_CheckWeedPlots(playerid, ccinc);
public MySQL_CheckWeedPlots(playerid, ccinc)
{
    // Proverava se koliko polja igrac ima zasadjeno
    // Max je BP_GetItemCountLimit(ITEM_SEED)*2 (dve vrecice semena, iako se one ne mogu kupiti istovremeno)

    if (!checkcinc(playerid, ccinc)) return 1;
    if (!IsPlayerInWeedField(playerid))
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");
    }

    new count;
    cache_get_row_count(rows);
    cache_get_value_index_int(0, 0, count);

    if (!rows)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (count >= BP_GetItemCountLimit(ITEM_SEED)*4)
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Vec imate maksimalan broj posadjenih polja (%i).", BP_GetItemCountLimit(ITEM_SEED)*4);
    }
    else
    {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);

        mysql_tquery(SQL, "SELECT pos FROM drugs_prep WHERE type = "#DRUG_TYPE_WEED, "MySQL_Weed_CheckPlotOccupancy", "fffii", x, y, z, playerid, cinc[playerid]);
    }
    return 1;
}

forward MySQL_Weed_CheckPlotOccupancy(Float:refx, Float:refy, Float:refz, playerid, ccinc);
public MySQL_Weed_CheckPlotOccupancy(Float:refx, Float:refy, Float:refz, playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;
    if (!IsPlayerInWeedField(playerid))
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (GetDistanceBetweenPoints(x, y, z, refx, refy, refz) > 4.0)
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Upit ka bazi je trajao predugacko, pokusajte ponovo.");
    }

    cache_get_row_count(rows);
    new bool:isPlotOccupied = false;
    if (rows)
    {
        new tempArea = CreateDynamicCircle(refx, refy, 4.0, 0, 0, playerid, 1);
        for__loop (new i = 0; i < rows; i++)
        {
            new pos[31], Float:checkx, Float:checky, Float:checkz;
            cache_get_value_index(i, 0, pos, sizeof pos);
            if (!sscanf(pos, "p<|>fff", checkx, checky, checkz))
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
        new finish_ts = gettime() + 20*60 + 5; // 20 minuta i 5 sekundi zbog animacije
        // new finish_ts = gettime() + 100 + 5;

        new sQuery[133];
        format(sQuery, sizeof sQuery, "INSERT INTO drugs_prep (gid, pid, quantity, type, finish_ts, pos) VALUES (0, %i, 1, %i, %i, '%.4f|%.4f|%.4f')", PI[playerid][p_id], DRUG_TYPE_WEED, finish_ts, refx, refy, refz);
        mysql_tquery(SQL, sQuery, "MySQL_OnWeedPlanted", "fffiii", refx, refy, refz, finish_ts, playerid, cinc[playerid]);
    }

    else 
    {
        gBlockKeyPress{playerid} = false;
        return ErrorMsg(playerid, "Na mestu gde stojis je vec posadjena marihuana.");
    }

    return 1;
}

forward MySQL_OnWeedPlanted(Float:x, Float:y, Float:z, finish_ts, playerid, ccinc);
public MySQL_OnWeedPlanted(Float:x, Float:y, Float:z, finish_ts, playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;
    // if (!IsPlayerInWeedField(playerid))
    // {
    //     gBlockKeyPress{playerid} = false;
    //     return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");
    // }

    new entryId = cache_insert_id();
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
    SetTimerEx("WeedSeedingAnimation", 5000, false, "fffiii", x, y, z, entryId, playerid, cinc[playerid]);

    BP_PlayerItemSub(playerid, ITEM_SEED);
    return 1;
}

forward MySQL_StartWeedHarvest(playerid, ccinc);
public MySQL_StartWeedHarvest(playerid, ccinc)
{  
    if (!checkcinc(playerid, ccinc)) return 1;
    if (!IsPlayerInWeedField(playerid))
        return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, "Niste nista posadili na ovoj plantazi.");
    else
    {
        if (gHarvestingWeed{playerid})
            return ErrorMsg(playerid, "Vec ste pokrenuli branje.");


        gHarvestingWeed{playerid} = true;

        new entryId, 
            pos[31], 
            finish_ts,
            Float:x, Float:y, Float:z,
            countReady = 0,
            countGrowing = 0,
            countFailed = 0;

        // Brisanje svih PVar-ova
        // Max je BP_GetItemCountLimit(ITEM_SEED)*2 (dve vrecice semena)
        for__loop (new i = 1; i <= BP_GetItemCountLimit(ITEM_SEED)*2; i++)
        {
            new pvarName[14];
            format(pvarName, sizeof pvarName, "PlantArrow_%i", i);
            if (GetPVarInt(playerid, pvarName))
            {
                DestroyPlayerArrow(playerid, Arrow:GetPVarInt(playerid, pvarName));
            }
            DeletePVar(playerid, pvarName);

            format(pvarName, sizeof pvarName, "PlantEntry_%i", i);
            DeletePVar(playerid, pvarName);
        }

        for__loop (new i = 0; i < rows; i++)
        {
            cache_get_value_index_int(i, 0, entryId);
            cache_get_value_index(i, 1, pos, sizeof pos);
            cache_get_value_index_int(i, 2, finish_ts);
            sscanf(pos, "p<|>fff", x, y, z);

            if (finish_ts > gettime())
            {
                countGrowing ++;
            }
            else if (finish_ts <= gettime() <= finish_ts+DRUGS_GRACE_PERIOD)
            {
                countReady ++;

                // pvarName krece brojanje od 1, a ne od 0!
                new pvarName[14];
                format(pvarName, sizeof pvarName, "PlantArrow_%i", i+1);
                SetPVarInt(playerid, pvarName, _:CreatePlayerArrow(playerid, x, y, z + 1.5, x, y, z, 19606));

                format(pvarName, sizeof pvarName, "PlantEntry_%i", i+1);
                SetPVarInt(playerid, pvarName, entryId);

                Streamer_Update(playerid);
            }
            else
            {
                countFailed ++;
                // Brisanje iz baze nije neophodno jer ce se to resiti u tajmeri WeedGrowth()
            }
        }

        if (countReady > 0)
        {
            SendClientMessage(playerid, BELA, "* Pokrenuli ste branje marihuane. Lokacije zrelih biljaka su oznacene strelicama.");
            SendClientMessageF(playerid, BELA, "Zrelo {00CC00}[%i]   {FFFFFF}Nezrelo: {FFFF00}[%i]   {FFFFFF}Propalo: {FF0000}[%i]", countReady, countGrowing, countFailed);

            SetPVarInt(playerid, "pHarvestedWeedCount", 0);
            SetPVarInt(playerid, "pWeedRemainingCount", countReady);

            new sMsg[132];
            format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da berete marihuanu sa zrelih polja na plantazi.~N~~N~Obrano polja: ~g~~h~%i~N~~W~Preostala polja: ~Y~~H~%i", GetPVarInt(playerid, "pHarvestedWeedCount"), GetPVarInt(playerid, "pWeedRemainingCount"));
            ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = sMsg, .lines = 5);
        }
        else 
        {
            ErrorMsg(playerid, "Nema zrelih biljaka.");
            gHarvestingWeed{playerid} = false;
        }
    }
    return 1;
}

forward Drugs_ShowGarageStatus(playerid, ccinc);
public Drugs_ShowGarageStatus(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_ShowGarageStatus");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows) return ErrorMsg(playerid, "Trenutno se nista ne izradjuje.");

    new string[1024], quantity, drug, finish_ts, drugStr[9], finishStatus[17], ident;
    format(string, sizeof string, "ID\tVrsta\tKolicina\tStatus");
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index_int(i, 0, quantity);
        cache_get_value_index_int(i, 1, drug);
        cache_get_value_index_int(i, 2, finish_ts);
        cache_get_value_index_int(i, 3, ident);

        GetDrugName(drug, drugStr, sizeof drugStr);
        if (finish_ts < gettime())
        {
            if ((finish_ts + DRUGS_GRACE_PERIOD) < gettime())
            {
                format(finishStatus, sizeof finishStatus, "{FF0000}PROPALO");
            }
            else
            {
                format(finishStatus, sizeof finishStatus, "{00FF00}SPREMNO");
            }
        }
        else
        {
            format(finishStatus, sizeof finishStatus, "{FF9900}%s", konvertuj_vreme(finish_ts - gettime(), true));
        }

        format(string, sizeof string, "%s\n{000000}%i\t{FFFFFF}%s\t%i gr\t%s", string, ident, drugStr, quantity, finishStatus);
        SPD(playerid, "drugs_harvest", DIALOG_STYLE_TABLIST_HEADERS, "Status", string, "Pokupi", "Nazad");
    }

    return 1;
}

forward Drugs_HarvestCheck(playerid, ccinc, ident);
public Drugs_HarvestCheck(playerid, ccinc, ident)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Drugs_HarvestCheck");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (rows != 1) return ErrorMsg(playerid, GRESKA_NEPOZNATO "(r: %i)", rows);

    new quantity, drug, finish_ts, drugStr[9];
    cache_get_value_name_int(0, "quantity", quantity);
    cache_get_value_name_int(0, "type", drug);
    cache_get_value_name_int(0, "finish_ts", finish_ts);

    if (finish_ts > gettime())
        return ErrorMsg(playerid, "Kuvanje jos nije zavrseno. Vratite se opet za %s.", konvertuj_vreme(finish_ts - gettime(), true));

    if (gettime() > (finish_ts + DRUGS_GRACE_PERIOD))
    {
        ErrorMsg(playerid, "Sastojci su prekuvani i unisteni. Sledeci put vodite racuna o vremenu!");
    }
    else
    {
        GetDrugName(drug, drugStr, sizeof drugStr);
        InfoMsg(playerid, "Uspesno ste pokupili: {FFFFFF}%s, %i grama.", drugStr, quantity);

        // TODO: dodati u stats i upisati u bazu!
        new itemid;
        switch (drug)
        {
            case DRUG_TYPE_MDMA:        itemid = ITEM_MDMA;
            case DRUG_TYPE_HEROIN:      itemid = ITEM_HEROIN;
            case DRUG_TYPE_ADRENALINE:  itemid = ITEM_ADRENALIN;
            default:                    return ErrorMsg(playerid, "Droga nije mogla biti dodata u ranac.");
        }

        if (BP_GetItemCountLimit(itemid) < (BP_PlayerItemGetCount(playerid, itemid) + quantity))
            return ErrorMsg(playerid, "Nemate dovoljno mesta u rancu.");


        BP_PlayerItemAdd(playerid, itemid, quantity);
    }


    new query[42];
    format(query, sizeof query, "DELETE FROM drugs_prep WHERE id = %i", ident);
    mysql_tquery(SQL, query);

    dialog_respond:drugs_garage_1(playerid, 1, 0, "");
    return 1;
}

forward ApplyDrugEffect(playerid, ccinc, drugType);
public ApplyDrugEffect(playerid, ccinc, drugType)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    ClearAnimations(playerid);
    if (drugType == DRUG_TYPE_WEED)
    {
        BP_PlayerItemSub(playerid, ITEM_WEED, 2);
        SendClientMessage(playerid, 0x00CC00FF, "(marihuana) {FFFFFF}Pancir je uvecan za 50 jedinica.");

        new Float:armour;
        GetPlayerArmour(playerid, armour);
        armour += 49.5;
        SetPlayerArmour(playerid, (armour>99.0? 99.0 : armour));
        TogglePlayerControllable_H(playerid, true);
    }
    else if (drugType == DRUG_TYPE_HEROIN)
    {
        BP_PlayerItemSub(playerid, ITEM_HEROIN);
        SendClientMessage(playerid, 0xFF6015FF, "(heroin) {FFFFFF}Za sve vreme dejstva opijata, Vas health ce se regenerisati brzinom 4 hp/sec.");

        tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN] = SetTimerEx("Drugs_HeroinEffect", 1000, true, "ii", playerid, cinc[playerid]);
        SetPlayerDrunkLevel(playerid, 4000);
        TogglePlayerControllable_H(playerid, true);
    }
    else if (drugType == DRUG_TYPE_MDMA)
    {
        new Float:health, Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPVarInt(playerid, "pAdrenalinePickup", CreateDynamicPickup(1241, 2, x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid));
        GetPlayerHealth(playerid, Float:health);
        SetPlayerHealth(playerid, ((health>50.0)? 100.0 : (health+50.0)));
        PlayerHungerDecrease(playerid, 20);

        BP_PlayerItemSub(playerid, ITEM_MDMA);
        SendClientMessage(playerid, 0xFF6015FF, "(MDMA) {FFFFFF}Vasa glad je umanjena za 20%%, a health je uvecan za 50 jedinica.");
        SendClientMessage(playerid, 0xFFFFFFFF, "       Za sve vreme delovanja opijata, glad ce nastaviti da opada i imacete bolju kondiciju.");
        
        tmrDrugsEffect[playerid][DRUG_TYPE_MDMA] = SetTimerEx("Drugs_MDMAEffect", 10*1000, true, "ii", playerid, cinc[playerid]);
        ShowColorScreen(playerid);
    }
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:drugs_garage_1(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            // Status
            new query[77], gid = GetPlayerVirtualWorld(playerid);
            format(query, sizeof query, "SELECT quantity, type, finish_ts, id FROM drugs_prep WHERE gid = %i", gid);
            mysql_tquery(SQL, query, "Drugs_ShowGarageStatus", "ii", playerid, cinc[playerid]);
        }
        else if (listitem == 1)
        {
            // (Nova) Priprema
            new string[512], sItemName[25], index = 0, color[7];
            format(string, sizeof string, "Supstanca\tDostupna kolicina\tOdabrana kolicina");
            for__loop (new i = DRUGS_SUBSTANCE_MIN_ID; i <= DRUGS_SUBSTANCE_MAX_ID; i++, index++)
            {
                if (i==ITEM_SAFROL||i==ITEM_METILAMIN||i==ITEM_BROMOPROPAN||i==ITEM_DEMIVODA)
                {
                    if (Drugs_CheckRecipe(playerid, DRUG_TYPE_MDMA)) color = "00FF00";
                    else color = "FF0000";
                }
                else if (i==ITEM_MORFIN||i==ITEM_ACETANHIDRID||i==ITEM_HLOROFORM||i==ITEM_ALKOHOL||i==ITEM_DEMIVODA)
                {
                    if (Drugs_CheckRecipe(playerid, DRUG_TYPE_HEROIN)) color = "00FF00";
                    else color = "FF0000";
                }
                else color = "FF9900";

                BP_GetItemName(i, sItemName, sizeof sItemName);
                format(string, sizeof string, "%s\n%s\t%i %s\t{%s}%i %s", string, sItemName, 
                    BP_PlayerItemGetCount(playerid, i) - Drugs_itemSelectedAmount[playerid][index], ((i==ITEM_DEMIVODA||i==ITEM_ALKOHOL)? ("ml") : ("gr")), 
                    color, Drugs_itemSelectedAmount[playerid][index], ((i==ITEM_DEMIVODA||i==ITEM_ALKOHOL)? ("ml") : ("gr")));
            }

            format(string, sizeof string, "%s\n-- Potvrdi & zapocni izradu", string);
            SPD(playerid, "drugs_preparation_1", DIALOG_STYLE_TABLIST_HEADERS, "Priprema droge", string, "Izaberi", "Nazad");
        }

        else if (listitem == 2)
        {
            if (GetPlayerFactionID(playerid) == -1)
            {
                // Samo za civile!

                if (!BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW))
                    return ErrorMsg(playerid, "Nemate sirovog kanabisa za susenje.");

                new sDialog[210];
                format(sDialog, sizeof sDialog, "{FFFFFF}Imate {FF9933}%i grama {FFFFFF}sirovog kanabisa.\nZa svakih 10 grama sirovog kanabisa, nakon susenja dobijate {00CC00}1 gram {FFFFFF}marihuane.\n\nUnesite kolicinu za susenje (10, 20, 30, 40, ...):", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW));
                SPD(playerid, "WeedDrying", DIALOG_STYLE_INPUT, "Susenje kanabisa", sDialog, "Potvrdi", "Odustani");
            }
            else
            {
                ErrorMsg(playerid, "Samo civili mogu da suse marihuanu na ovom mestu.");
                DialogReopen(playerid);
            }
        }
    }
    return 1;
}

Dialog:drugs_preparation_1(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new itemid = listitem + DRUGS_SUBSTANCE_MIN_ID;
        if (itemid > DRUGS_SUBSTANCE_MAX_ID)
        {
            // Zavrsetak i priprema
            new drugStr[31], prepTime;


            // Provera sastojaka za MDMA
            if (Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID] > 0)
            {
                if (!Drugs_CheckRecipe(playerid, DRUG_TYPE_MDMA))
                {
                    return ErrorMsg(playerid, "Odabrali ste nepoznat recept. Pokusajte ponovo.");
                }
            }



            // Provera sastojaka za Heroin
            if (Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID] > 0)
            {
                if (!Drugs_CheckRecipe(playerid, DRUG_TYPE_HEROIN))
                {
                    return ErrorMsg(playerid, "Odabrali ste nepoznat recept. Pokusajte ponovo.");
                }
            }



            // Ako pravi i MDMA i Heroin, da li ima dovoljno vode?
            if ((Drugs_itemSelectedAmount[playerid][ITEM_MORFIN - DRUGS_SUBSTANCE_MIN_ID]/30 + Drugs_itemSelectedAmount[playerid][ITEM_SAFROL - DRUGS_SUBSTANCE_MIN_ID]/10) != Drugs_itemSelectedAmount[playerid][ITEM_DEMIVODA - DRUGS_SUBSTANCE_MIN_ID]/500)
            {
                return ErrorMsg(playerid, "Odabrali ste nepoznat recept. Pokusajte ponovo.");
            }


            // Spisak sastojaka za MDMA
            new Drugs_MDMAIngredients[4];
            Drugs_MDMAIngredients[0] = Drugs_itemSelectedAmount[playerid][ITEM_SAFROL       - DRUGS_SUBSTANCE_MIN_ID]/10;
            Drugs_MDMAIngredients[1] = Drugs_itemSelectedAmount[playerid][ITEM_BROMOPROPAN  - DRUGS_SUBSTANCE_MIN_ID]/30;
            Drugs_MDMAIngredients[2] = Drugs_itemSelectedAmount[playerid][ITEM_METILAMIN    - DRUGS_SUBSTANCE_MIN_ID]/20;
            Drugs_MDMAIngredients[3] = Drugs_itemSelectedAmount[playerid][ITEM_DEMIVODA     - DRUGS_SUBSTANCE_MIN_ID]/500;

            // Spisak sastojaka za Heroin
            new Drugs_HeroinIngredients[5];
            Drugs_HeroinIngredients[0] = Drugs_itemSelectedAmount[playerid][ITEM_MORFIN         - DRUGS_SUBSTANCE_MIN_ID]/30;
            Drugs_HeroinIngredients[1] = Drugs_itemSelectedAmount[playerid][ITEM_ACETANHIDRID   - DRUGS_SUBSTANCE_MIN_ID]/10;
            Drugs_HeroinIngredients[2] = Drugs_itemSelectedAmount[playerid][ITEM_HLOROFORM      - DRUGS_SUBSTANCE_MIN_ID]/10;
            Drugs_HeroinIngredients[3] = Drugs_itemSelectedAmount[playerid][ITEM_DEMIVODA       - DRUGS_SUBSTANCE_MIN_ID]/500;
            Drugs_HeroinIngredients[4] = Drugs_itemSelectedAmount[playerid][ITEM_ALKOHOL        - DRUGS_SUBSTANCE_MIN_ID]/100;



            // Izrada MDMA
            if (Drugs_MDMAIngredients[0] > 0)
            {
                // Detaljnija provera recepta


                if (Drugs_MDMAIngredients[3] < Drugs_MDMAIngredients[0])
                {
                    // Nema dovoljno vode
                    ErrorMsg(playerid, "Odabrali ste nepoznat recept. Pokusajte ponovo.");
                    return Drugs_OpenRecipeDialog(playerid);
                }

                if (Drugs_MDMAIngredients[3] > Drugs_MDMAIngredients[0])
                {
                    // Ima vise vode nego sto je potrebno. Ovo je validno ukoliko pravi 2 vrste droge, pa cemo
                    // mu jednostavno oduzeti visak ovde iz recepta za MDMA-u
                    Drugs_MDMAIngredients[3] = Drugs_MDMAIngredients[0];
                }

                new quantity = Drugs_MDMAIngredients[0], 
                    finish_ts,
                    query[110];

                prepTime = (GetPVarInt(playerid, "pDrugsLab")==1? 10 : 25); // 10min u lab, 25min u garazi
                finish_ts = gettime() + prepTime*60;

                format(query, sizeof query, "INSERT INTO drugs_prep (gid, pid, quantity, type, finish_ts) VALUES (%i, %i, %i, %i, %i)", GetPlayerVirtualWorld(playerid), PI[playerid][p_id], quantity, DRUG_TYPE_MDMA, finish_ts);
                mysql_tquery(SQL, query);

                BP_PlayerItemSub(playerid, ITEM_SAFROL,      quantity*10);
                BP_PlayerItemSub(playerid, ITEM_BROMOPROPAN, quantity*30);
                BP_PlayerItemSub(playerid, ITEM_METILAMIN,   quantity*20);
                BP_PlayerItemSub(playerid, ITEM_DEMIVODA,    quantity*500);

                format(drugStr, sizeof drugStr, "MDMA (%i gr)", quantity);
            }


            // Izrada Heroin
            if (Drugs_HeroinIngredients[0] > 0)
            {
                // Oduzimanje demi vode ako je vec napravljena neka kolicina MDMA-e
                if (Drugs_MDMAIngredients[0] > 0)
                {
                    Drugs_HeroinIngredients[3] -= Drugs_MDMAIngredients[3];
                }

                // Izrada samo ako je ostalo vode
                if (Drugs_HeroinIngredients[3] >= Drugs_MDMAIngredients[0])
                {
                    new quantity = Drugs_HeroinIngredients[0], 
                        finish_ts,
                        query[110];

                    prepTime = (GetPVarInt(playerid, "pDrugsLab")==1? 10 : 25); // 10min u lab, 25min u garazi
                    finish_ts = gettime() + prepTime*60;

                    format(query, sizeof query, "INSERT INTO drugs_prep (gid, pid, quantity, type, finish_ts) VALUES (%i, %i, %i, %i, %i)", GetPlayerVirtualWorld(playerid), PI[playerid][p_id], quantity, DRUG_TYPE_HEROIN, finish_ts);
                    mysql_tquery(SQL, query);

                    BP_PlayerItemSub(playerid, ITEM_MORFIN,       quantity*30);
                    BP_PlayerItemSub(playerid, ITEM_ACETANHIDRID, quantity*10);
                    BP_PlayerItemSub(playerid, ITEM_HLOROFORM,    quantity*10);
                    BP_PlayerItemSub(playerid, ITEM_DEMIVODA,     quantity*500);
                    BP_PlayerItemSub(playerid, ITEM_ALKOHOL,      quantity*100);

                    if (isnull(drugStr))
                    {
                        format(drugStr, sizeof drugStr, "Heroin (%i gr)", quantity);
                    }
                    else
                    {
                        format(drugStr, sizeof drugStr, ", Heroin (%i gr)", quantity);
                    }
                }
            }

            if (!isnull(drugStr))
            {
                SendClientMessageF(playerid, 0xFF6015FF, "Pokrenuli ste pripremu droge: {FFA07A}%s  {FF6015}| Proces ce biti zavrsen za {FFA07A}%i minuta.", drugStr, prepTime);
                SendClientMessageF(playerid, 0xFF6015FF, "Po zavrsetku, imate {FFA07A}10 minuta {FF6015}da pokupite gotov proizvod, inace ce svi sastojci propasti!");
                SendClientMessageF(playerid, 0xFF6347FF, "* Vodite racuna o vremenu jer {FF0000}NECETE {FF6347}biti obavesteni kada priprema bude gotova!");
            }
        }
        else
        {
            // Dodavanje sastojka

            if ((BP_PlayerItemGetCount(playerid, itemid) - Drugs_itemSelectedAmount[playerid][itemid - DRUGS_SUBSTANCE_MIN_ID]) < 10)
            {
                ErrorMsg(playerid, "Ne mozete dodati vise ovog sastojka!");
            }
            else
            {
                if (itemid == ITEM_DEMIVODA)
                {
                    Drugs_itemSelectedAmount[playerid][listitem] += 500; // 500ml vode
                }
                else if (itemid == ITEM_ALKOHOL)
                {
                    Drugs_itemSelectedAmount[playerid][listitem] += 100; // 200ml alkohola
                }
                else
                {
                    Drugs_itemSelectedAmount[playerid][listitem] += 10; // 10g neke supstance
                }
            }

            dialog_respond:drugs_garage_1(playerid, 1, 1, "Priprema");
        }
    }
    else
    {
        Drugs_OpenRecipeDialog(playerid);
    }
    return 1;
}

Dialog:drugs_harvest(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new ident, query[70];
        ident = strval(inputtext);

        format(query, sizeof query, "SELECT quantity, type, finish_ts FROM drugs_prep WHERE id = %i", ident);
        mysql_tquery(SQL, query, "Drugs_HarvestCheck", "iii", playerid, cinc[playerid], ident);
    }
    else
    {
        // TODO
        return 1;
    }
    return 1;
}

Dialog:SeedsPurchase(playerid, response, listitem, const inputtext[])
{
    // Kupuje se vrecica semena koja sadrzi "BP_GetItemCountLimit(ITEM_SEED)" (6) semena
    // Igracu se u ranac ne dodaje vrecica, nego taj broj semena
    // Da bi kupio vrecicu, mora da potrosi sva prethodno kupljena semena (cak i ako ostane sa 1 semenom, ne moze kupiti nova dok to jedno ne potrosi)

    if (response)
    {
        if (PI[playerid][p_novac] < SEEDBAG_PRICE)
            return ErrorMsg(playerid, "Nemate dovoljno novca.");

        if (BP_PlayerItemGetCount(playerid, ITEM_SEED) > MAX_SEEDS_PER_ROUTE)
            return ErrorMsg(playerid, "Morate potrositi sva semena koja imate kod sebe (%i) da biste mogli da kupite nova.", BP_PlayerItemGetCount(playerid, ITEM_SEED));

        PlayerMoneySub(playerid, SEEDBAG_PRICE);
        BP_PlayerItemAdd(playerid, ITEM_SEED, BP_GetItemCountLimit(ITEM_SEED));
        InfoMsg(playerid, "Kupili ste vrecicu semena za marihuanu. Kada ih sve zasadite, moci cete da kupite novu vrecicu.");

        InfoMsg(playerid, "Lokacija sadjenja je skrivena,\n{FFFFFF}(Odgonetni zagonetku: 'Na sirokom putu, ispod mosta, nalaze su 2 gosta, lokacija je prosta.')");
        //SetGPSLocation(playerid, 243.0747, 1137.3818, 11.4458, "plantaza marihuane");

        // Upisivanje u log
        new sLog[54];
        format(sLog, sizeof sLog, "%s je kupio vrecicu semena.", ime_obicno[playerid]);
        Log_Write(LOG_MARIJUANA, sLog);
    }
    return 1;
}

Dialog:WeedDrying(playerid, response, listitem, const inputtext[]) 
{
    if (response)
    {
        new grams;
        if (sscanf(inputtext, "i", grams))
            return DialogReopen(playerid);

        if (grams < 1 || grams > 100000)
            return DialogReopen(playerid);

        if (grams % 10)
        {
            ErrorMsg(playerid, "Morate uneti okrugao broj. Na primer: 10, 20, 30, 100, 150, 280, ...");
            return DialogReopen(playerid);
        }

        if (BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW) < grams)
        {
            ErrorMsg(playerid, "Na raspolaganju imate %i grama.", BP_PlayerItemGetCount(playerid, ITEM_WEED_RAW));
            return DialogReopen(playerid);
        }

        if ((BP_PlayerItemGetCount(playerid, ITEM_WEED) + floatround(grams/10.0)) > BP_GetItemCountLimit(ITEM_WEED))
        {
            ErrorMsg(playerid, "Imate previse marihuane u rancu i ne mozete dodati ovoliku kolicinu.");
            ErrorMsg(playerid, "Mozete osusiti jos najvise %i grama.", (BP_GetItemCountLimit(ITEM_WEED)-BP_PlayerItemGetCount(playerid, ITEM_WEED))*10);
            return DialogReopen(playerid);
        }

        SetPVarInt(playerid, "pDryingGramage", grams);
        StartCenterProgress(playerid, "Susenje u toku...", 50*1000);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:mdma(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_MDMA))
        return ErrorMsg(playerid, "Ne posedujete ovu vrstu droge.");

    if (PI[playerid][p_zavezan] > 0)
        return ErrorMsg(playerid, "Ne mozete koristiti drogu dok ste vezani.");

    new drugEffectDuration = 90; // 1.5 minuta traje efekat ove droge
    Drugs_effectEndtime[playerid][DRUG_TYPE_MDMA] = gettime() + drugEffectDuration;

    TogglePlayerControllable_H(playerid, false);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 0, 0);
    SetTimerEx("ApplyDrugEffect", 5000, false, "iii", playerid, cinc[playerid], DRUG_TYPE_MDMA);
    return 1;
}

CMD:heroin(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_HEROIN))
        return ErrorMsg(playerid, "Ne posedujete ovu vrstu droge.");

    if (PI[playerid][p_zavezan] > 0)
        return ErrorMsg(playerid, "Ne mozete koristiti drogu dok ste vezani.");

    if (tmrDrugsEffect[playerid][DRUG_TYPE_HEROIN] != 0)
        return ErrorMsg(playerid, "Vec ste koristili heroin, sacekajte da dejstvo prestane da biste mogli da ga koristite ponovo.");

    new drugEffectDuration = 180; // 3 minuta traje efekat ove droge
    Drugs_effectEndtime[playerid][DRUG_TYPE_HEROIN] = gettime() + drugEffectDuration + 5;

    TogglePlayerControllable_H(playerid, false);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 0, 0);
    SetTimerEx("ApplyDrugEffect", 5000, false, "iii", playerid, cinc[playerid], DRUG_TYPE_HEROIN);
    return 1;
}

CMD:adrenalin(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_ADRENALIN))
        return ErrorMsg(playerid, "Ne posedujete adrenalin.");

    if (PI[playerid][p_zavezan] > 0)
        return ErrorMsg(playerid, "Ne mozete koristiti drogu dok ste vezani.");

    if (tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE] != 0)
        return ErrorMsg(playerid, "Vec ste koristili adrenalin, sacekajte da dejstvo prestane da biste mogli da ga koristite ponovo.");

    new drugEffectDuration = 120; // 2 minuta traje efekat ove droge

    BP_PlayerItemSub(playerid, ITEM_ADRENALIN);
    SendClientMessage(playerid, SVETLOCRVENA, "(adrenalin) {FFFFFF}Otvorili ste prostor za dopunjavanje 40 jedinica pancira.");

    Drugs_effectEndtime[playerid][DRUG_TYPE_ADRENALINE] = gettime() + drugEffectDuration;
    tmrDrugsEffect[playerid][DRUG_TYPE_ADRENALINE] = SetTimerEx("Drugs_AdrenalineEffect", 2*60*1000, false, "ii", playerid, cinc[playerid]);
    return 1;
}

alias:marihuana("weed")
CMD:marihuana(playerid, const params[])
{
    if (BP_PlayerItemGetCount(playerid, ITEM_WEED) < 2)
        return ErrorMsg(playerid, "Nemate dovoljno ove droge (minimum 2 grama).");

    if (PI[playerid][p_zavezan] > 0)
        return ErrorMsg(playerid, "Ne mozete koristiti drogu dok ste vezani.");

    if (Drugs_effectEndtime[playerid][DRUG_TYPE_WEED] > gettime())
        return ErrorMsg(playerid, "Vec ste nedavno koristili marihuanu. Pokusajte ponovo za %i minuta.", floatround((Drugs_effectEndtime[playerid][DRUG_TYPE_WEED]-gettime())/60.0, floatround_ceil));

    new drugEffectDuration = 180; // 3 minuta traje efekat ove droge (ODNOSNO: cooldown do sledeceg koriscenja)
    Drugs_effectEndtime[playerid][DRUG_TYPE_WEED] = gettime() + drugEffectDuration + 5;

    TogglePlayerControllable_H(playerid, false);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 1, 1, 0, 0);
    SetTimerEx("ApplyDrugEffect", 5000, false, "iii", playerid, cinc[playerid], DRUG_TYPE_WEED);
    return 1;
}

flags:medsport(FLAG_ADMIN_6)
CMD:medsport(playerid, const params[])
{
    new id;
    if (sscanf(params, "i", id))
        return Koristite(playerid, "medsport [0-9]");

    if (id < 0 || id > 9)
        return 1;

    TeleportPlayer(playerid, DRUGS_PACKAGES[id][DRUGS_PCK_POS][0], DRUGS_PACKAGES[id][DRUGS_PCK_POS][1], DRUGS_PACKAGES[id][DRUGS_PCK_POS][2]);
    return 1;
}

flags:medsrenew(FLAG_ADMIN_6)
CMD:medsrenew(playerid, const params[])
{
    return DRUGS_PackagesDrop();
}

cmd:setsjeme(const playerid) {
    BP_PlayerItemAdd(playerid, ITEM_SEED, 24);
    InfoMsg(playerid, "Postavljeno ti je 24 sjemena.");
    return 1;
}

CMD:sadidrogu(playerid, const params[])
{
    if (!IsPlayerInWeedField(playerid))
        return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (BP_PlayerItemGetCount(playerid, ITEM_SEED) <= 0)
        return ErrorMsg(playerid, "Nemate semena.");

    if (IsACop(playerid) || IsAMobster(playerid))
            return ErrorMsg(playerid, "Samo civili i pripadnici bandi mogu da koriste plantazu.");

    if (gSeedingWeed{playerid})
        return ErrorMsg(playerid, "Sadnja je vec u toku.");

    if (gWeedActionID{playerid} || gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti sadjenje dok berete.");

    gSeedingWeed{playerid} = true;

    SendClientMessageF(playerid, BELA, "* Zapoceli ste sadnju marihuane. Imate %i semena na raspolaganju.", BP_PlayerItemGetCount(playerid, ITEM_SEED));
    SendClientMessageF(playerid, BELA, "* Koristite ENTER (F) da posadite seme na slobodnom zemljistu.");

    new sMsg[112];
    format(sMsg, sizeof sMsg, "Koristite ~r~Enter/F ~w~da sadite semena na slobodnim poljima po plantazi.~N~~N~Raspolozivih semena: ~g~~h~%i", BP_PlayerItemGetCount(playerid, ITEM_SEED));
    ptdServerTips_ShowMsg(playerid, .title = "Marihuana", .msg = sMsg, .lines = 4);
    return 1;
}

CMD:beridrogu(playerid, const params[])
{
    if (!IsPlayerInWeedField(playerid))
        return ErrorMsg(playerid, "Ne nalazite se na plantazi marihuane.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate napustiti vozilo.");

    if (gHarvestingWeed{playerid})
        return ErrorMsg(playerid, "Branje je vec u toku.");

    if (gWeedActionID{playerid} || gBlockKeyPress{playerid})
        return ErrorMsg(playerid, "Ne mozete pokrenuti branje dok sadite.");

    new sQuery[78];
    format(sQuery, sizeof sQuery, "SELECT id, pos, finish_ts FROM drugs_prep WHERE type = "#DRUG_TYPE_WEED" AND pid = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery, "MySQL_StartWeedHarvest", "ii", playerid, cinc[playerid]);
    return 1;
}