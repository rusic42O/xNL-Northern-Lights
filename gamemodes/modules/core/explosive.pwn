#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define BOMBA_S     0
#define BOMBA_M     1
#define BOMBA_L     2




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    bombapickup[MAX_PLAYERS],              
    odabrao_bombu[MAX_PLAYERS],
    bool:postavio_bombu[MAX_PLAYERS char],      
    Text3D:explosive_label[MAX_PLAYERS],
 
    tajmer:bombPlanting[MAX_PLAYERS],
    tajmer:detonation[MAX_PLAYERS],
    
    EXPLOSIVE_expCP,
    EXPLOSIVE_detCP
;




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    EXPLOSIVE_expCP = CreateDynamicCP(2842.0417, -2408.0906, 1.9699, 0.9, -1, -1, -1, 10.0); // Kupovina eksploziva
    EXPLOSIVE_detCP = CreateDynamicCP(1085.6157, 2118.5652, 15.3504, 0.9, -1, -1, -1, 10.0); // Kupovina detonatora

    CreateDynamic3DTextLabel("Kupovina eksploziva", NARANDZASTA, 2842.0417, -2408.0906, 1.9699, 20.0);
    CreateDynamic3DTextLabel("Kupovina detonatora", NARANDZASTA, 1085.6157, 2118.5652, 15.3504, 20.0);

    return 1;
}

hook OnPlayerConnect(playerid) 
{
    odabrao_bombu[playerid] =
    tajmer:bombPlanting[playerid] = 
    tajmer:detonation[playerid] = 0;

    bombapickup[playerid] = -1;
    postavio_bombu{playerid} = false;

    explosive_label[playerid] = Text3D:INVALID_3DTEXT_ID;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    if (tajmer:detonation[playerid] != 0 && postavio_bombu{playerid} == true) 
    {
        if (DebugFunctions())
        {
            LogCallbackExec("explosive.pwn", "OnPlayerDisconnect");
        }
        // Postavio bombu
        KillTimer(tajmer:detonation[playerid]), tajmer:detonation[playerid] = 0;
        postavio_bombu{playerid} = false;
        DestroyDynamicPickup(bombapickup[playerid]), bombapickup[playerid] = -1;
        DestroyDynamic3DTextLabel(explosive_label[playerid]), explosive_label[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    if (tajmer:bombPlanting[playerid] != 0)
    {
        KillTimer(tajmer:bombPlanting[playerid]);
        tajmer:bombPlanting[playerid] = 0;
    }

    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) 
{
    if (tajmer:detonation[playerid] != 0 && postavio_bombu{playerid} == true) 
    {
        // Postavio bombu
        KillTimer(tajmer:detonation[playerid]), tajmer:detonation[playerid] = 0;
        postavio_bombu{playerid} = false;
        DestroyDynamicPickup(bombapickup[playerid]), bombapickup[playerid] = -1;
        DestroyDynamic3DTextLabel(explosive_label[playerid]), explosive_label[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    if (tajmer:bombPlanting[playerid] != 0)
    {
        KillTimer(tajmer:bombPlanting[playerid]);
        tajmer:bombPlanting[playerid] = 0;
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == EXPLOSIVE_expCP)
    {
        callcmd::kupieksploziv(playerid, "");
        return ~1;
    }

    else if (checkpointid == EXPLOSIVE_detCP)
    {
        callcmd::kupidetonator(playerid, "");
        return ~1;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward EXPLOSIVE_TransferToBP(playerid);
public EXPLOSIVE_TransferToBP(playerid)
{
    if (PI[playerid][p_eksploziv] > 0)
    {
        BP_PlayerItemAdd(playerid, ITEM_EXPLOSIVE, PI[playerid][p_eksploziv]);
    }
    if (PI[playerid][p_detonatori] > 0)
    {
        BP_PlayerItemAdd(playerid, ITEM_DETONATOR, PI[playerid][p_detonatori]);
    }

    PI[playerid][p_eksploziv] = PI[playerid][p_detonatori] = 0;
    new query[67];
    format(query, sizeof query, "UPDATE igraci SET eksploziv = 0, detonatori = 0 WHERE id = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

forward explosive_Detonation(playerid, velicina, Float:X, Float:Y, Float:Z, vrsta, vehicleid, ccinc);
public explosive_Detonation(playerid, velicina, Float:X, Float:Y, Float:Z, vrsta, vehicleid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("explosive_Detonation");
    }


    SetPVarInt(playerid, "eExplosionTime", GetPVarInt(playerid, "eExplosionTime")-1);

    if (GetPVarInt(playerid, "eExplosionTime") <= 0)
    {
        KillTimer(tajmer:detonation[playerid]), tajmer:detonation[playerid] = 0;
        if (!checkcinc(playerid, ccinc)) return 1;

        new Float:radius;
        if (velicina == BOMBA_S)        radius = 15.0;
        else if (velicina == BOMBA_M)   radius = 40.0;
        else if (velicina == BOMBA_L)   radius = 85.0;

        if (vrsta == 0) 
        { // klasicna
            DestroyDynamicPickup(bombapickup[playerid]), bombapickup[playerid] = -1;
            DestroyDynamic3DTextLabel(explosive_label[playerid]), explosive_label[playerid] = Text3D:INVALID_3DTEXT_ID;
        }
        else if (vrsta == 1) 
        { // autobomba
            SetVehicleHealth(vehicleid, 0);
            GetVehiclePos(vehicleid, X, Y, Z);
        }

        CreateExplosion(X+5.0, Y, Z, 10, radius);
        CreateExplosion(X, Y+5.0, Z, 10, radius);
        CreateExplosion(X, Y, Z, 10,     radius);
        CreateExplosion(X-5.0, Y, Z, 10, radius);

        CallRemoteFunction("OnBombExplosion", "ifff", playerid, X, Y, Z); 
    }
    else
    {
        UpdateDynamic3DTextLabelText(explosive_label[playerid], CRVENA, konvertuj_vreme(GetPVarInt(playerid, "eExplosionTime")));
    }
    return 1;
}

forward explosive_BombPlanting(playerid, vrsta, vreme, vehicleid, ccinc);
public explosive_BombPlanting(playerid, vrsta, vreme, vehicleid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("explosive_BombPlanting");
    }

    tajmer:bombPlanting[playerid] = 0;
    if (!checkcinc(playerid, ccinc)) return 1;

    StopLoopingAnim(playerid);
    
    new
        vrtext1[8], vrtext2[8], zona[32], tiptext[11];

    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    if (IsPlayerInAnyVehicle(playerid))
    {
        vrsta = 1; // Auto bomba
        explosive_label[playerid] = CreateDynamic3DTextLabel(konvertuj_vreme(vreme), CRVENA, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], 20.0, INVALID_PLAYER_ID, GetPlayerVehicleID(playerid));
    }

    if (vrsta == 0) // Obicna bomba
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 594.6897,-1434.5972,9.8155)) 
        {
            new jewelryBomb = CreateDynamicObjectEx(1654, 593.784057, -1434.539916, 10.260982, 0.000000, 0.000000, 90.000000, 750.00, 750.00);

            SetTimerEx("DestroyDynamite", vreme*1000, false, "i", jewelryBomb);
        }
        else
        {
            bombapickup[playerid] = CreateDynamicPickup(1654, 1, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        }
        explosive_label[playerid] = CreateDynamic3DTextLabel(konvertuj_vreme(vreme), CRVENA, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], 20.0);
    }


    switch (odabrao_bombu[playerid]) 
    {
        case BOMBA_S:   vrtext1 = "malu",       vrtext2 = "Mala";
        case BOMBA_M:   vrtext1 = "srednju",    vrtext2 = "Srednja";
        case BOMBA_L:   vrtext1 = "veliku",     vrtext2 = "Velika";
        default:        vrtext1 = "N/A",        vrtext2 = "N/A";
    }
    if (vrsta == 0)     tiptext = "Klasicna";
    else                tiptext = "Auto-Bomba";

    PI[playerid][p_bomba][odabrao_bombu[playerid]] -= 1;


    GetPlayer2DZone(playerid, zona, sizeof zona);
    AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[ID: %d] je postavio bombu! Lokacija: %s | Vrsta: %s", ime_obicno[playerid], playerid, zona, vrtext2);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Postavili ste %s bombu | Vreme do detonacije: %d sekundi", vrtext1, vreme);

    format(string_64, 64, "** %s je postavio bombu!", ime_rp[playerid]);
    RangeMsg(playerid, string_64, LJUBICASTA, 15.0);

    // Update podataka u bazi
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET bombe = '%d|%d|%d' WHERE id = %d", PI[playerid][p_bomba][BOMBA_S], PI[playerid][p_bomba][BOMBA_M], PI[playerid][p_bomba][BOMBA_L], PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);

    // Upisivanje u log
    format(string_128, sizeof string_128, "Izvrsio: %s | Lokacija: %s | Tip: %s | Vrsta: %s | Vreme: %d sec", ime_obicno[playerid], zona, tiptext, vrtext2, vreme);
    Log_Write(LOG_BOMBE, string_128);

    // Tajmer za detonaciju
    SetPVarInt(playerid, "eExplosionTime", vreme);
    tajmer:detonation[playerid] = SetTimerEx("explosive_Detonation", 1000, true, "iifffiii", playerid, odabrao_bombu[playerid], pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], vrsta, vehicleid, cinc[playerid]);

    return 1;
}

forward OnBombExplosion(playerid, Float:X, Float:Y, Float:Z);
public OnBombExplosion(playerid, Float:X, Float:Y, Float:Z)
{
    return 1;
}

forward DestroyDynamite(objid);
public DestroyDynamite(objid)
{
    return DestroyDynamicObject(objid);
}

stock IsPlayerPlantingBomb(playerid)
{
    if (tajmer:bombPlanting[playerid] == 0) return 0;
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:kupovina_eksploziva(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new kolicina;
    if (sscanf(inputtext, "d", kolicina)) 
        return DialogReopen(playerid);
    
    if (BP_GetItemCountLimit(ITEM_EXPLOSIVE) < (BP_PlayerItemGetCount(playerid, ITEM_EXPLOSIVE) + kolicina))
    {
        return ErrorMsg(playerid, "Mozete nositi najvise %ikg eksploziva sa sobom (trenutno imate %ikg).", BP_GetItemCountLimit(ITEM_EXPLOSIVE), BP_PlayerItemGetCount(playerid, ITEM_EXPLOSIVE));
    }

    new cena = kolicina*10000;
    if (PI[playerid][p_novac] < cena) 
    {
        ErrorMsg(playerid, "Nemate dovoljno novca!");
        return DialogReopen(playerid);
    }
    PlayerMoneySub(playerid, cena);
    BP_PlayerItemAdd(playerid, ITEM_EXPLOSIVE, kolicina);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Kupili ste %d kilograma eksploziva za %s.", kolicina, formatMoneyString(cena));
    return 1;
}

// Dialog:kupovina_detonatora(playerid, response, listitem, const inputtext[])
// {
//     if (!response) return 1;
//     new kolicina;
//     if (sscanf(inputtext, "d", kolicina)) 
//         return DialogReopen(playerid);
    
//     if (kolicina < 1 || kolicina > 10) 
//     {
//         ErrorMsg(playerid, "Ne mozete kupiti toliko!");
//         return DialogReopen(playerid);
//     }

//     new cena = kolicina*1500;
//     if (PI[playerid][p_novac] < cena) 
//     {
//         ErrorMsg(playerid, "Nemate dovoljno novca!");
//         return DialogReopen(playerid);
//     }

//     PI[playerid][p_detonatori] += kolicina;
//     PlayerMoneySub(playerid, cena);
//     SendClientMessageF(playerid, SVETLOPLAVA, "* Kupili ste %d detonatora za $%d.", kolicina, cena);
//     return 1;
// }

Dialog:izrada_bombe(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

        
    if (!BP_PlayerHasItem(playerid, ITEM_DETONATOR)) 
        return ErrorMsg(playerid, "Nemate detonator! Koristite /kupidetonator.");

    switch (listitem)
    {
        case 0:
        {
            if (BP_PlayerHasItem(playerid, ITEM_EXPLOSIVE) < 2) 
                return ErrorMsg(playerid, "Nemate dovoljno eksploziva!");
            
            if (PI[playerid][p_bomba][BOMBA_S] >= 5)
                return ErrorMsg(playerid, "Mozete nositi najvise 5 malih bombi sa sobom!");
            
            BP_PlayerItemSub(playerid, ITEM_EXPLOSIVE, 2);
            PI[playerid][p_bomba][BOMBA_S] += 1;
            SendClientMessage(playerid, SVETLOPLAVA, "* Napravili ste malu bombu. Koristite /postavibombu da je aktivirate.");
        }
        case 1:
        {
            if (BP_PlayerHasItem(playerid, ITEM_EXPLOSIVE) < 10) 
                return ErrorMsg(playerid, "Nemate dovoljno eksploziva!");
            
            if (PI[playerid][p_bomba][BOMBA_M] >= 2)
                return ErrorMsg(playerid, "Mozete nositi najvise 2 srednje bombe sa sobom!");
            
            BP_PlayerItemSub(playerid, ITEM_EXPLOSIVE, 10);
            PI[playerid][p_bomba][BOMBA_M] += 1;
            SendClientMessage(playerid, SVETLOPLAVA, "* Napravili ste srednju bombu. Koristite /postavibombu da je aktivirate.");
        }
        case 2:
        {
            if (BP_PlayerHasItem(playerid, ITEM_EXPLOSIVE) < 20) 
                return ErrorMsg(playerid, "Nemate dovoljno eksploziva!");
            
            if (PI[playerid][p_bomba][BOMBA_L] >= 1)
                return ErrorMsg(playerid, "Mozete nositi samo jednu veliku bombu sa sobom!");

            BP_PlayerItemSub(playerid, ITEM_EXPLOSIVE, 20);
            PI[playerid][p_bomba][BOMBA_L] += 1;
            SendClientMessage(playerid, SVETLOPLAVA, "* Napravili ste veliku bombu. Koristite /postavibombu da je aktivirate.");
         }
    }

    BP_PlayerItemSub(playerid, ITEM_DETONATOR);

    // Update podataka u bazi
    new query[60];
    format(query, sizeof query, "UPDATE igraci SET bombe = '%d|%d|%d' WHERE id = %d", PI[playerid][p_bomba][BOMBA_S], PI[playerid][p_bomba][BOMBA_M], PI[playerid][p_bomba][BOMBA_L], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

Dialog:aktivacija_bombe(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    
    if (PI[playerid][p_bomba][listitem] <= 0) 
    {
        ErrorMsg(playerid, "Nemate tu bombu kod sebe!");
        return DialogReopen(playerid);
    }
    
    odabrao_bombu[playerid] = listitem;
    SPD(playerid, "detonacija", DIALOG_STYLE_INPUT, "Vreme do detonacije", "Upisite vreme u sekundama koje zelite da prodje pre eksplozije:", "Aktiviraj", "Izadji");
    return 1;
}

Dialog:detonacija(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    new 
        vreme, vrsta = 0, vehicleid = INVALID_VEHICLE_ID;

    if (sscanf(inputtext, "i", vreme)) 
        return DialogReopen(playerid);

    if (vreme < 1 || vreme > 600) 
    {
        ErrorMsg(playerid, "Vreme mora biti izmedju 1 i 600 sekundi!");
        return DialogReopen(playerid);
    }

    if (IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
    tajmer:bombPlanting[playerid] = SetTimerEx("explosive_BombPlanting", 5*1000, false, "iiiii", playerid, vrsta, vreme, vehicleid, cinc[playerid]);

    format(string_64, 64, "** %s postavlja bombu.", ime_rp[playerid]);
    RangeMsg(playerid, string_64, LJUBICASTA, 15.0);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:kupieksploziv(playerid, const params[])
{
    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo pripadnici mafija i bandi mogu kupovati eksploziv.");
    
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 2842.0417, -2408.0906, 1.9699)) 
        return ErrorMsg(playerid, "Ne nalazite se na mestu za kupovinu eksploziva!");
    
    SPD(playerid, "kupovina_eksploziva", DIALOG_STYLE_INPUT, "Kupovina eksploziva:", "Upisite koliko kilograma eksploziva zelite.\n1kg = $10000", "Potvrdi", "Odustani");
    return 1;
}
CMD:kupidetonator(playerid, const params[])
{
    InfoMsg(playerid, "Kupovina detonatora je premestena u {FFFF00}Hardware Store.");
    SendClientMessage(playerid, BELA, "* Za lokaciju koristite /gps -> Glavne lokacije -> Hardware Store.");
    // if (!IsACriminal(playerid))
    //     return ErrorMsg(playerid, "Samo pripadnici mafija i bandi mogu kupovati detonatore.");
    
    // if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1085.6157, 2118.5652, 15.3504))
    //     return ErrorMsg(playerid, "Ne nalazite se na mestu za kupovinu detonatora!");
    
    // SPD(playerid, "kupovina_detonatora", DIALOG_STYLE_INPUT, "Kupovina detonatora:", "Upisite koliko detonatora zelite.\n1 detonator = $2000", "Potvrdi", "Odustani");
    return 1;
}

CMD:napravibombu(playerid, const params[])
{
    /*
        Ova komanda se automatski poziva odgovorom na dialog koji je definisan unutar diler_oruzja.pwn
    */
    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo pripadnici mafija i bandi mogu praviti bombe.");
    
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1064.3727, 2127.6003, 10.8203)) 
        return ErrorMsg(playerid, "Ne nalazite se u fabrici oruzja!");
    
    SPD(playerid, "izrada_bombe", DIALOG_STYLE_LIST, "Vrsta bombe:", "Mala bomba (2kg)\nSrednja bomba (5kg)\nVelika bomba (10kg)", "Odaberi", "Izadji");
    
    return 1;
}

/*CMD:postavibombu(playerid, const params[])
{
    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo pripadnici mafija i bandi mogu postavljati bombe.");
    
    SPD(playerid, "aktivacija_bombe", DIALOG_STYLE_LIST, "Vrsta bombe", "Mala bomba (2kg)\nSrednja bomba (5kg)\nVelika bomba (10kg)", "Odaberi", "Izadji");

    return 1;
}*/