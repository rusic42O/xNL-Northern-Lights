#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_DRUG_TRANSPORT
{
    bool:DT_ACTIVE,
    DT_PICKUP,
    DT_INITIATOR,
    DT_TIMER,
    DT_PRIM_ITEM,
    DT_PRIM_QUANTITY,
    bool:DT_DROPPED,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new DT_Area, DT_SellCP;
new DrugsTransport[MAX_FACTIONS][E_DRUG_TRANSPORT];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{ 
    CreateDynamicActor(28, 893.7805,-25.6982,63.3171,123.8530);
    DT_SellCP = CreateDynamicCP(-440.2341,1162.5935,1.7459, 2.5, 0, 0, 0 -1, 10.0);
    DT_Area = CreateDynamicSphere(891.7536,-27.6224,63.3120, 2.0, 0, 0);
    CreateDynamicPickup(1575, 1, 891.7536,-27.6224,63.3120);
    CreateDynamic3DTextLabel("Pakovanje droge za prodaju", BELA, 891.7536,-27.6224,63.3120, 25.0);


    // Resetovanje
    for__loop (new i = 0; i < GetMaxFactions(); i++)
    {
        DrugsTransport[i][DT_ACTIVE] = false;
        DrugsTransport[i][DT_PICKUP] = -1;
        DrugsTransport[i][DT_INITIATOR] = INVALID_PLAYER_ID;
        DrugsTransport[i][DT_PRIM_ITEM] = DrugsTransport[i][DT_PRIM_QUANTITY] = 0;
        DrugsTransport[i][DT_TIMER] = 0;
        DrugsTransport[i][DT_DROPPED] = false;
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == DT_Area)
    {
        if (IsAGangster(playerid) || IsAMobster(playerid))
        {
            new fid = PI[playerid][p_org_id], h, m ,s;

            if (DrugsTransport[fid][DT_ACTIVE])
                return ErrorMsg(playerid, "Neko iz Vase mafije/bande je vec aktivirao prevoz droge.");

            gettime(h, m, s);
            if (!(19 <= h <= 20))
                return ErrorMsg(playerid, "Pakovanje droge se moze izvrsiti iskljucivo izmedju 19h i 21h.");

            SPD(playerid, "dt_packing_info", DIALOG_STYLE_MSGBOX, "Pakovanje droge", "{FFFFFF}Droga se pakuje iz 2 dela:\n\n- u prvom delu mora biti Heroin *ili* MDMA\n- u drugom delu mora biti marihuana\n\nOdnos prvog i drugog dela mora biti tacno {FF0000}1 : 2.\n{FFFFFF}Tacnije, koliko droge stavite u prvi deo, {FF0000}2x vise {FFFFFF}morate staviti i u drugi deo.\nPrimer: Heroin 50g + Marihuana 100g", "Razumem", "Izadji");
        }
        else
        {
            return ErrorMsg(playerid, "Morate biti pripadnik mafije ili bande da biste mogli da pakujete drogu na ovom mestu.");
        }
        return ~1;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    new fid = PI[playerid][p_org_id];
    if (fid == -1) return 1;

    if (DrugsTransport[fid][DT_ACTIVE] && DrugsTransport[fid][DT_INITIATOR] == playerid)
    {
        // DrugsTransport[fid][DT_ACTIVE] = false;
        DrugsTransport[fid][DT_DROPPED] = true;
        DrugsTransport[fid][DT_INITIATOR] = INVALID_PLAYER_ID;

        // pickup create
        new Float:pos[3];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        DrugsTransport[fid][DT_PICKUP] = CreateDynamicPickup(1575, 1, pos[0], pos[1], pos[2]);
        DrugsTransport[fid][DT_TIMER] = SetTimerEx("DT_DestroyPickup", 15*60*1000, false, "i", fid);

        new sMsg[86];
        format(sMsg, sizeof sMsg, "* Kriminalac {FF6347}%s {DC143C}je ispustio paket sa drogom.", ime_rp[playerid]);
        SendClientMessageToAll(TAMNOCRVENA2, sMsg);

        // Upisivanje u log
        new logStr[115], tag[9], sItemName[25];
        BP_GetItemName(DrugsTransport[fid][DT_PRIM_ITEM], sItemName, sizeof sItemName);
        GetFactionTag(fid, tag, sizeof tag);
        format(logStr, sizeof logStr, "Paket ispao (disconnect) | %s [%s] | %s: %i gr | Marihuana: %i gr", ime_obicno[playerid], tag, sItemName, DrugsTransport[fid][DT_PRIM_QUANTITY], DrugsTransport[fid][DT_PRIM_QUANTITY]*2);
        Log_Write(LOG_DRUGSTRANSPORT, logStr);
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    new fid = PI[playerid][p_org_id];
    if (fid == -1) return 1;
    
    if (DrugsTransport[fid][DT_ACTIVE] && DrugsTransport[fid][DT_INITIATOR] == playerid)
    {
        // DrugsTransport[fid][DT_ACTIVE] = false;
        DrugsTransport[fid][DT_DROPPED] = true;
        DrugsTransport[fid][DT_INITIATOR] = INVALID_PLAYER_ID;
        RemovePlayerMapIcon(playerid, MAPICON_JOB);

        // pickup create
        new Float:pos[3];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        DrugsTransport[fid][DT_PICKUP] = CreateDynamicPickup(1575, 1, pos[0], pos[1], pos[2]);
        DrugsTransport[fid][DT_TIMER] = SetTimerEx("DT_DestroyPickup", 15*60*1000, false, "i", fid);

        new sMsg[86];
        format(sMsg, sizeof sMsg, "* Kriminalac {FF6347}%s {DC143C}je ispustio paket sa drogom.", ime_rp[playerid]);
        SendClientMessageToAll(TAMNOCRVENA2, sMsg);

        // Upisivanje u log
        new logStr[115], tag[9], sItemName[25];
        BP_GetItemName(DrugsTransport[fid][DT_PRIM_ITEM], sItemName, sizeof sItemName);
        GetFactionTag(fid, tag, sizeof tag);
        format(logStr, sizeof logStr, "Paket ispao (smrt) | %s [%s] | %s: %i gr | Marihuana: %i gr", ime_obicno[playerid], tag, sItemName, DrugsTransport[fid][DT_PRIM_QUANTITY], DrugsTransport[fid][DT_PRIM_QUANTITY]*2);
        Log_Write(LOG_DRUGSTRANSPORT, logStr);
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == DT_SellCP)
    {
        if (IsAMobster(playerid) || IsAGangster(playerid))
        {
            new fid = PI[playerid][p_org_id];
            if (DrugsTransport[fid][DT_INITIATOR] == playerid && DrugsTransport[fid][DT_ACTIVE])
            {
                if (DrugsTransport[fid][DT_ACTIVE])
                {
                    new earnings = 0;
                    if (DrugsTransport[fid][DT_PRIM_ITEM] == ITEM_HEROIN)
                    {
                        earnings += floatround(2620 * 2.7 * DrugsTransport[fid][DT_PRIM_QUANTITY]);
                    }
                    else if (DrugsTransport[fid][DT_PRIM_ITEM] == ITEM_MDMA)
                    {
                        earnings += floatround(3810 * 2.7 * DrugsTransport[fid][DT_PRIM_QUANTITY]);
                    }
                    earnings += floatround(950 * 1.9 * DrugsTransport[fid][DT_PRIM_QUANTITY]*2); // za marihuanu


                    PlayerMoneyAdd(playerid, earnings);

                    new sMsg[120];
                    format(sMsg, sizeof sMsg, "* Kriminalac {FF6347}%s {DC143C}je dostavio paket sa drogom i zaradio {FF6347}%s.", ime_rp[playerid], formatMoneyString(earnings));
                    SendClientMessageToAll(TAMNOCRVENA2, sMsg);

                    // Upisivanje u log
                    new logStr[120], tag[9];
                    GetFactionTag(fid, tag, sizeof tag);
                    format(logStr, sizeof logStr, "Paket dostavljen | %s [%s] | Kolicina: %i | Zarada: %s", ime_obicno[playerid], tag, DrugsTransport[fid][DT_PRIM_QUANTITY], formatMoneyString(earnings));
                    Log_Write(LOG_DRUGSTRANSPORT, logStr);

                    DrugsTransport[fid][DT_ACTIVE] = false;
                    DrugsTransport[fid][DT_INITIATOR] = INVALID_PLAYER_ID;
                    DrugsTransport[fid][DT_PRIM_ITEM] = DrugsTransport[fid][DT_PRIM_QUANTITY] = 0;
                }
                else
                {
                    ErrorMsg(playerid, GRESKA_NEPOZNATO);
                }
            }
        }
        else
        {
            return ErrorMsg(playerid, "Ovde nema nicega za tebe!");
        }
    }
    return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if (!IsPlayerAlive(playerid) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;

    for__loop (new i = 0; i < GetMaxFactions(); i++)
    {
        if (DrugsTransport[i][DT_PICKUP] == pickupid)
        {
            if (DrugsTransport[i][DT_ACTIVE])
            {
                if (DrugsTransport[i][DT_INITIATOR] == INVALID_PLAYER_ID)
                {
                    new fid = PI[playerid][p_org_id];
                    if (fid == -1) return 1;

                    if (DrugsTransport[fid][DT_INITIATOR] == INVALID_PLAYER_ID)
                    {
                        // Sve gucci
                        DrugsTransport[fid][DT_ACTIVE] = true;
                        DrugsTransport[fid][DT_INITIATOR] = playerid;
                        DrugsTransport[fid][DT_PRIM_ITEM] = DrugsTransport[i][DT_PRIM_ITEM];
                        DrugsTransport[fid][DT_PRIM_QUANTITY] = DrugsTransport[i][DT_PRIM_QUANTITY];

                        // Resetovanje za onu orgu kojoj je ispao paket
                        if (fid != i)
                        {
                            DrugsTransport[i][DT_ACTIVE] = false;
                            DrugsTransport[i][DT_PRIM_ITEM] = DrugsTransport[i][DT_PRIM_QUANTITY] = 0;
                        }
                        KillTimer(DrugsTransport[i][DT_TIMER]);
                        DestroyDynamicPickup(DrugsTransport[i][DT_PICKUP]);
                        DrugsTransport[i][DT_PICKUP] = -1;

                        // Attached obj ? :TODO

                        new sMsg[86];
                        format(sMsg, sizeof sMsg, "* Kriminalac {FF6347}%s {DC143C}je pokupio paket sa drogom.", ime_rp[playerid]);
                        SendClientMessageToAll(TAMNOCRVENA2, sMsg);

                        if (IsACop(playerid))
                        {
                            SetPlayerCheckpoint(playerid, 1573.8722,-1628.0157,12.9566, 5.0);
                        }
                        else
                        {
                            SetPlayerMapIcon(playerid, MAPICON_JOB, -440.2341,1162.5935,1.7459, 0, 0xFF0000AA, MAPICON_GLOBAL);
                        }

                        // Upisivanje u log
                        new logStr[105], tag[9], sItemName[25];
                        BP_GetItemName(DrugsTransport[fid][DT_PRIM_ITEM], sItemName, sizeof sItemName);
                        GetFactionTag(fid, tag, sizeof tag);
                        format(logStr, sizeof logStr, "Paket pokupljen | %s [%s] | %s: %i gr | Marihuana: %i gr", ime_obicno[playerid], tag, sItemName, DrugsTransport[fid][DT_PRIM_QUANTITY], DrugsTransport[fid][DT_PRIM_QUANTITY]*2);
                        Log_Write(LOG_DRUGSTRANSPORT, logStr);

                    }
                    else
                    {
                        return ErrorMsg(playerid, "Drugi clan Vase organizacije vec nosi paket sa drogom.");
                    }
                }
            }  
            break;
        }
    }
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid)
{
    new fid = PI[playerid][p_org_id];
    if (IsACop(playerid) && IsPlayerInRangeOfPoint(playerid, 5.0, 1573.8722,-1628.0157,12.9566) && DrugsTransport[fid][DT_ACTIVE] && DrugsTransport[fid][DT_INITIATOR] == playerid)
    {
        new value = 0, sItemName[25];
        if (DrugsTransport[fid][DT_PRIM_ITEM] == ITEM_HEROIN)
        {
            value += floatround(2620 * 2.66 * DrugsTransport[fid][DT_PRIM_QUANTITY]);
        }
        else if (DrugsTransport[fid][DT_PRIM_ITEM] == ITEM_MDMA)
        {
            value += floatround(3810 * 2.66 * DrugsTransport[fid][DT_PRIM_QUANTITY]);
        }
        value += floatround(950 * 2.66 * DrugsTransport[fid][DT_PRIM_QUANTITY]*2); // za marihuanu



        new prize = floatround((value)/100000.0, floatround_floor)*100000; // vrednost zaokruzena na okruglu cifru (floor)
        BP_GetItemName(DrugsTransport[fid][DT_PRIM_ITEM], sItemName, sizeof sItemName);
        SendClientMessageFToAll(SVETLOCRVENA2, "_______________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policija Los Santosa sprecila je pokusaj krijumcarenja droge!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, zaplenjeno je oko %i gr droge %s i oko %i gr droge Marihuana!", floatround(DrugsTransport[fid][DT_PRIM_QUANTITY]/10.0, floatround_floor)*10, floatround(DrugsTransport[fid][DT_PRIM_QUANTITY]/10.0, floatround_ceil)*10 * 2);
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Ukupna ulicna vrednost zaplenjenih supstanci procenjuje se na cak {FF0000}%s!", formatMoneyString( floatround((value)/100000.0)*100000 ));
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(prize));
        SendClientMessageFToAll(SVETLOCRVENA2, "_______________________________________________________");

        FactionMoneyAdd(fid, prize);

        DrugsTransport[fid][DT_ACTIVE] = false;
        DrugsTransport[fid][DT_PICKUP] = -1;
        DrugsTransport[fid][DT_PRIM_ITEM] = DrugsTransport[fid][DT_PRIM_QUANTITY] = 0;
        DrugsTransport[fid][DT_TIMER] = 0;
        DrugsTransport[fid][DT_DROPPED] = false;
        return ~1;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward DT_DestroyPickup(fid);
public DT_DestroyPickup(fid)
{

    // Upisivanje u log
    new logStr[120], tag[9], sItemName[25];
    BP_GetItemName(DrugsTransport[fid][DT_PRIM_ITEM], sItemName, sizeof sItemName);
    GetFactionTag(fid, tag, sizeof tag);
    format(logStr, sizeof logStr, "Paket unisten | %s | %s: %i gr | Marihuana: %i gr", tag, sItemName, DrugsTransport[fid][DT_PRIM_QUANTITY], DrugsTransport[fid][DT_PRIM_QUANTITY]*2);
    Log_Write(LOG_DRUGSTRANSPORT, logStr);

    // Unistavanje
    DestroyDynamicPickup(DrugsTransport[fid][DT_PICKUP]);
    DrugsTransport[fid][DT_PICKUP] = -1;

    DrugsTransport[fid][DT_ACTIVE] = false;
    DrugsTransport[fid][DT_PRIM_ITEM] = DrugsTransport[fid][DT_PRIM_QUANTITY] = 0;
    DrugsTransport[fid][DT_TIMER] = 0;
    DrugsTransport[fid][DT_DROPPED] = false;
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:dt_packing_info(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SPD(playerid, "dt_1_deo", DIALOG_STYLE_MSGBOX, "Pakovanje droge: Heroin/MDMA", "{FFFFFF}Izaberite vrstu droge koju zelite da spakujete u {FFFF00}prvi deo {FFFFFF}paketa.", "Heroin", "MDMA");
    }
    return 1;
}

Dialog:dt_1_deo(playerid, response, listitem, const inputtext[])
{
    new itemid, sItemName[25], sDialog[230];
    if (response) itemid = ITEM_HEROIN;
    else itemid = ITEM_MDMA;

    BP_GetItemName(itemid, sItemName, sizeof sItemName);
    SetPVarInt(playerid, "dtSelection", itemid);

    format(sDialog, sizeof sDialog, "{FFFFFF}Unesite kolicinu koja ide u prvi deo (%s).\n\nU drugi deo automatski ide {FF0000}trostruka {FFFFFF}kolicina od one koju unesete sada.\nPrimer: ako unesete 50g, za drugi deo ce automatski ici 150g marihuane.", sItemName);
    
    SPD(playerid, "dt_2_deo", DIALOG_STYLE_INPUT, "Pakovanje droge: Kolicina", sDialog, "Potvrdi", "Odustani");

    return 1;
}

Dialog:dt_2_deo(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new fid = PI[playerid][p_org_id];
    if (DrugsTransport[fid][DT_ACTIVE])
        return ErrorMsg(playerid, "Neko iz Vase mafije/bande je vec aktivirao prevoz droge.");

    new itemid = GetPVarInt(playerid, "dtSelection"), 
        sItemName[25];

    BP_GetItemName(itemid, sItemName, sizeof sItemName);

    new quantity;
    if (sscanf(inputtext, "i", quantity))
        return DialogReopen(playerid);

    if (quantity < 1 || quantity > 1000)
        return DialogReopen(playerid);

    if (quantity < 40)
        return ErrorMsg(playerid, "Minimum za pakovanje je 40gr Heroin/MDMA i 120gr Marihuana.");

    if (BP_PlayerItemGetCount(playerid, itemid) < quantity)
        return ErrorMsg(playerid, "Nemate dovoljno %s (%i gr).", sItemName, BP_PlayerItemGetCount(playerid, itemid));

    if (BP_PlayerItemGetCount(playerid, ITEM_WEED) < (quantity*2))
        return ErrorMsg(playerid, "Nemate dovoljno marihuane (potrebno je %i gr).", quantity*2);

    DrugsTransport[fid][DT_ACTIVE] = true;
    DrugsTransport[fid][DT_DROPPED] = false;
    DrugsTransport[fid][DT_INITIATOR] = playerid;
    DrugsTransport[fid][DT_PRIM_ITEM] = itemid;
    DrugsTransport[fid][DT_PRIM_QUANTITY] = quantity;

    SetPlayerMapIcon(playerid, MAPICON_JOB, -440.2341,1162.5935,1.7459, 0, 0xFF0000AA, MAPICON_GLOBAL);

    // Oduzimanje droge iz rance
    BP_PlayerItemSub(playerid, itemid, quantity);
    BP_PlayerItemSub(playerid, ITEM_WEED, quantity*2);

    // Upisivanje u log
    new logStr[105], tag[9];
    GetFactionTag(fid, tag, sizeof tag);
    format(logStr, sizeof logStr, "Transport zapocet | %s [%s] | %s: %i gr | Marihuana: %i gr", ime_obicno[playerid], tag, sItemName, quantity, quantity*2);
    Log_Write(LOG_DRUGSTRANSPORT, logStr);

    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
