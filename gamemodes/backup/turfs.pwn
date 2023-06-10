#include <YSI_Coding\y_hooks>

/* TODO
    Poseban TD za svaku fakciju

*/

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_TURFS           (41) 
#define INVALID_TURF_ID     (-1)
#define TURF_FREE_COLOR     (0x96816CAF)
#define THREAD_TURF_UPDATE        (print("[mysql debug] Turf updated"))




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_TURFS
{
    t_zone,
    t_areaid, // CreateDynamicRectangle
    Text3D:t_labelid, // 3D Text Label
    t_fid,
    t_level,
    t_benefit,
    Float:t_minx,
    Float:t_miny,
    Float:t_maxx,
    Float:t_maxy,
    Float:t_interact[3],
    t_cooldown,
    t_mvp[MAX_PLAYER_NAME],
    t_mvp_pts,
};

enum
{
    TURFS_BENEFIT_MONEY = 1,
    TURFS_BENEFIT_MATS = 2,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new TURFS[MAX_TURFS][E_TURFS],
    Iterator:iTurfs<MAX_TURFS>,
    gLoadedTurfsCount;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    for__loop (new i = 0; i < MAX_TURFS; i++)
    {
        TURFS[i][t_fid] = -1;
    }

    SetTimer("UpdateTurfMVPs", 4*3580*1000, true); // otprilike na 4h
    SetTimer("TurfPayout", 60*60*1000, true);
    mysql_tquery(SQL, "SELECT * FROM turfs", "mysql_turfLoad");
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    foreach (new zone : iTurfs) 
    {
        new color = (TURFS[zone][t_fid] != -1) ? (HexToInt(FACTIONS[TURFS[zone][t_fid]][f_hex]) - 80) : TURF_FREE_COLOR;
        ShowZoneForPlayer(playerid, TURFS[zone][t_zone], color);
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward UpdateTurfMVPs();
public UpdateTurfMVPs()
{
    new query[100];
    for__loop (new i = 0; i < gLoadedTurfsCount; i++)
    {
        format(query, sizeof query, "SELECT player, participations FROM turf_mvp WHERE turf = %i ORDER BY participations DESC LIMIT 0,1", i);
        mysql_tquery(SQL, query, "MySQL_UpdateTurfMVPs", "i", i);
    }
    return 1;
}

forward TurfPayout();
public TurfPayout()
{
    if (DebugFunctions())
    {
        LogFunctionExec("TurfPayout");
    }

    if (playersOnline > 0)
    {
        for__loop (new i = 0; i < MAX_FACTIONS; i++)
        {
            if (FACTIONS[i][f_loaded] == -1) continue; // nije ucitana
            if (FACTIONS[i][f_vrsta] != FACTION_GANG && FACTIONS[i][f_vrsta] != FACTION_MAFIA && FACTIONS[i][f_vrsta] != FACTION_RACERS) continue;

            // Brojimo online clanove
            new membersOnline = 0;
            foreach (new p : Player)
            {
                if (PI[p][p_org_id] == i) membersOnline ++;
            }


            new incomeMoney = 0, incomeMats = 0;

            for__loop (new j = 1; j < MAX_TURFS; j++) 
            {
                if (TURFS[j][t_fid] == i)
                {
                    // Teritorija koja pripada ovoj m/b (id: i)
                    if (TURFS[j][t_benefit] == TURFS_BENEFIT_MONEY)
                    {
                        if (membersOnline > 0)
                            incomeMoney += 4050 + 600*TURFS[j][t_level];
                    }
                    else
                    {
                        incomeMats += 20 + 7*TURFS[j][t_level];
                    }
                }
            }

            FactionMsg(i, "(teritorija) U skladiste je dodato {FFFFFF}%i materijala.", incomeMats);
            FactionMatsAdd(i, incomeMats);

            // Raspodela novca medju online clanovima
            new totalRanks = 0;
            foreach (new p : Player)
            {
                if (PI[p][p_org_id] == i)
                {
                    totalRanks += PI[p][p_org_rank];
                }
            }
            foreach (new p : Player)
            {
                if (PI[p][p_org_id] == i)
                {
                    new cash = floatround(incomeMoney/totalRanks * (PI[p][p_org_rank]*1.0));
                    PlayerMoneyAdd(p, cash);
                    SendClientMessageF(p, BELA, "* Vi ste rank %i. Zaradili ste {00FF00}%s {FFFFFF}od teritorija.", PI[p][p_org_rank], formatMoneyString(cash));
                }
            }
        }
    }
    return 1;
}

stock TURF_LevelInc(turf)
{
    if (DebugFunctions())
    {
        LogFunctionExec("TURF_LevelInc");
    }

    TURFS[turf][t_level] += 1;

    new query[46];
    format(query, sizeof query, "UPDATE turfs SET level = %i WHERE id = %i", TURFS[turf][t_level], turf);
    mysql_tquery(SQL, query);
}

stock GetPlayerTurf(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("GetPlayerTurf");
    }

    if (!IsPlayerConnected(playerid)) return INVALID_TURF_ID;

    new turfid = INVALID_TURF_ID;
    foreach (new i : iTurfs) 
    {
        if (IsPlayerInDynamicArea(playerid, TURFS[i][t_areaid])) 
        {
            turfid = i;
            break;
        }   
    }

    return turfid;
}

stock CountTurfsOwnedByGroup(group) 
{
    if (group < 0 || group > MAX_FACTIONS) return 0;

    new count = 0;
    foreach (new i : iTurfs) 
    {
        if (TURFS[i][t_fid] == group) count++;
    }
    return count;
}

stock CountTurfs()
{
    return Iter_Count(iTurfs);
}

stock UpdateTurfLabel(turf)
{
    new interact_txt[232];
    format(interact_txt, sizeof interact_txt, "{8EFF00}[ TERITORIJA (%d) ]\n{FFFF00}Vlasnik: {FFFFFF}%s\n{FFFF00}Nivo: {FFFFFF}%i   {FFFF00}Benefit: {FFFFFF}%s\n{FFFF00}MVP: {00FF00}%s (%i)\n\n{FFFF00}Da je zauzmete upisite {FFFFFF}/zauzmi", turf, FACTIONS[TURFS[turf][t_fid]][f_tag], TURFS[turf][t_level], (TURFS[turf][t_benefit]==TURFS_BENEFIT_MONEY? ("Novac"):("Oruzje")), TURFS[turf][t_mvp], TURFS[turf][t_mvp_pts]);
    UpdateDynamic3DTextLabelText(TURFS[turf][t_labelid], BELA, interact_txt);
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_turfLoad();
public mysql_turfLoad() 
{
    gLoadedTurfsCount = 0;
    cache_get_row_count(rows);
    if (!rows) return 1;

    new id, zone[43], interact[32], interact_txt[235], benefit[13];
    for__loop (new i = 0; i < rows; i++) 
    {
        cache_get_value_index_int(i, 0, id);
        cache_get_value_index_int(i, 1, TURFS[id][t_fid]);
        cache_get_value_index_int(i, 3, TURFS[id][t_level]);
        cache_get_value_index(i, 4, benefit, sizeof benefit);
        cache_get_value_index(i, 2, zone, sizeof zone);
        cache_get_value_index(i, 5, interact, sizeof interact);
        
        sscanf(zone, "p<,>ffff", TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
        sscanf(interact, "p<,>fff", TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]);

        if (!strcmp(benefit, "Novac")) TURFS[id][t_benefit] = TURFS_BENEFIT_MONEY;
        else TURFS[id][t_benefit] = TURFS_BENEFIT_MATS;

        TURFS[id][t_zone] = CreateZone(TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
        CreateZoneNumber(TURFS[id][t_zone], id);
        CreateZoneBorders(TURFS[id][t_zone]);

        TURFS[id][t_areaid] = CreateDynamicRectangle(TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
        
        CreateDynamicPickup(1313, 1, TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]);

        if (TURFS[id][t_fid] != -1) 
        {
            format(interact_txt, sizeof interact_txt, "{8EFF00}[ TERITORIJA (%d) ]\n{FFFF00}Vlasnik: {FFFFFF}%s\n{FFFF00}Nivo: {FFFFFF}%i   {FFFF00}Benefit: {FFFFFF}%s\n{FFFF00}Da je zauzmete upisite {FFFFFF}/zauzmi", id, FACTIONS[TURFS[id][t_fid]][f_tag], TURFS[id][t_level], benefit);
        }
        else 
        {
            format(interact_txt, sizeof interact_txt, "{00FF00}[ SLOBODNA TERITORIJA (%d) ]\n(( {FFFFFF}/zauzmi {00FF00}))", id);
        }
        TURFS[id][t_labelid] = CreateDynamic3DTextLabel(interact_txt, BELA, TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]+1.0, 15.0);

        TURFS[id][t_cooldown] = 0;
        Iter_Add(iTurfs, id);
        gLoadedTurfsCount++;
    }

    printf("[turfs.pwn] Ucitano %i teritorija.", gLoadedTurfsCount);
    UpdateTurfMVPs();
    return 1;
}

forward MySQL_UpdateTurfMVPs(turf);
public MySQL_UpdateTurfMVPs(turf)
{
    cache_get_row_count(rows);
    if (rows == 1)
    {
        cache_get_value_index(0, 0, TURFS[turf][t_mvp], MAX_PLAYER_NAME);
        cache_get_value_index_int(0, 1, TURFS[turf][t_mvp_pts]);

        UpdateTurfLabel(turf);
    }
    return 1;
}

forward mysql_turfCreate(playerid, ccinc, zone[45], interact[33]);
public mysql_turfCreate(playerid, ccinc, zone[45], interact[33]) 
{
    new 
        id = cache_insert_id(), 
        interact_txt[500]; // 235

    sscanf(zone, "p<,>ffff", TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
    sscanf(interact, "p<,>fff", TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]);
    TURFS[id][t_fid] = -1;
    TURFS[id][t_level] = 1;
    TURFS[id][t_benefit] = TURFS_BENEFIT_MONEY;
    TURFS[id][t_cooldown] = 0;

    TURFS[id][t_zone] = CreateZone(TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
    CreateZoneNumber(TURFS[id][t_zone], id);
    CreateZoneBorders(TURFS[id][t_zone]);

    TURFS[id][t_areaid] = CreateDynamicRectangle(TURFS[id][t_minx], TURFS[id][t_miny], TURFS[id][t_maxx], TURFS[id][t_maxy]);
    
    CreateDynamicPickup(1313, 1, TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]);

    if (TURFS[id][t_fid] != -1) 
    {
        format(interact_txt, sizeof interact_txt, "{8EFF00}[ TERITORIJA (%d) ]\n{FFFF00}Vlasnik: {FFFFFF}%s\n{FFFF00}Nivo: {FFFFFF}%i   {FFFF00}Benefit: {FFFFFF}%s\n{FFFF00}MVP: {00FF00}%s (%i)\n\n{FFFF00}Da je zauzmete upisite {FFFFFF}/zauzmi", id, FACTIONS[TURFS[id][t_fid]][f_tag], TURFS[id][t_level], (TURFS[id][t_benefit]==TURFS_BENEFIT_MONEY? ("Novac"):("Oruzje")), TURFS[id][t_mvp], TURFS[id][t_mvp_pts]);
    }
    else 
    {
        format(interact_txt, sizeof interact_txt, "{00FF00}[ SLOBODNA TERITORIJA (%d) ]\n(( {FFFFFF}/zauzmi {00FF00}))", id);
    }
    TURFS[id][t_labelid] = CreateDynamic3DTextLabel(interact_txt, BELA, TURFS[id][t_interact][POS_X], TURFS[id][t_interact][POS_Y], TURFS[id][t_interact][POS_Z]+1.0, 15.0);

    Iter_Add(iTurfs, id);

    DeletePVar(playerid, "pTurfCreateMin");
    DeletePVar(playerid, "pTurfCreateMax");
    DeletePVar(playerid, "pTurfCreateInteract");

    ShowZoneForAll(TURFS[id][t_zone], TURF_FREE_COLOR);
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:turfedit1(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new turfList[MAX_TURFS*15];
    turfList = "ID zone\tVlasnik";
    for__loop (new i = 1; i < MAX_TURFS; i++) 
    {
        if (TURFS[i][t_zone] > 0 || (i == 1 && TURFS[i][t_zone] == 0)) 
        { // prva zona moze da ima id 0
            new vlasnik[10];
            GetFactionTag(TURFS[i][t_fid], vlasnik);

            if (IsPlayerInDynamicArea(playerid, TURFS[i][t_areaid]))
                format(turfList, sizeof turfList, "%s\n{FFFF00}%d\t{FFFF00}%s", turfList, i, vlasnik);
            else 
                format(turfList, sizeof turfList, "%s\n%d\t%s", turfList, i, vlasnik);
        }
    }

    switch (listitem) 
    {
        case 0: { // Izmeni zonu
            SPD(playerid, "turfedit2", DIALOG_STYLE_TABLIST_HEADERS, "Izaberite zonu", turfList, "Izmeni", "Nazad");
        }

        case 1: { // Izbrisi zonu
            SPD(playerid, "turfedit4", DIALOG_STYLE_TABLIST_HEADERS, "Izaberite zonu", turfList, "Izbrisi", "Nazad");
        }

        case 2: { // Dodaj novu zonu
            new minStr[22], maxStr[22], interact[33], zone[45], query[126];
            GetPVarString(playerid, "pTurfCreateMin",       minStr,     sizeof minStr);
            GetPVarString(playerid, "pTurfCreateMax",       maxStr,     sizeof maxStr);
            GetPVarString(playerid, "pTurfCreateInteract",  interact,   sizeof interact);

            if (isnull(minStr))
                return ErrorMsg(playerid, "Idite u donji levi ugao zone i upisite {FFFFFF}/turfcreate min");

            if (isnull(maxStr))
                return ErrorMsg(playerid, "Idite u gornji desni ugao zone i upisite {FFFFFF}/turfcreate max");

            if (isnull(interact))
                return ErrorMsg(playerid, "Idite na mesto gde zelite da stavite pickup i upisite {FFFFFF}/turfcreate interact");

            format(zone, sizeof zone, "%s,%s", minStr, maxStr);
            format(query, sizeof query, "INSERT INTO turfs (zone, interact) VALUES ('%s', '%s')", zone, interact);
            mysql_tquery(SQL, query, "mysql_turfCreate", "iiss", playerid, cinc[playerid], zone, interact);
        }
    }
    return 1;
}

Dialog:turfedit2(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return PC_EmulateCommand(playerid, "/turfedit");

    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    SetPVarInt(playerid, "pTurfEdit", strval(inputtext));
    SPD(playerid, "turfedit3", DIALOG_STYLE_LIST, "Izmena zone", "Izmeni minX/minY\nIzmeni maxX/maxY", "Dalje ", " Nazad");
    return 1;
}

Dialog:turfedit3(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return dialog_respond:turfedit2(playerid, 1, 0, "");

    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new turf = GetPVarInt(playerid, "pTurfEdit");
    new Float:pos[3], query[128];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    switch (listitem) 
    {
        case 0: { // minx, miny
            TURFS[turf][t_minx] = pos[0];
            TURFS[turf][t_miny] = pos[1];
            
            SendClientMessageF(playerid, ZUTA, "* Izmenili ste minX/minY koordinate za zonu %d.", turf);
        }

        case 1: { // maxx, maxy
            TURFS[turf][t_maxx] = pos[0];
            TURFS[turf][t_maxy] = pos[1];

            SendClientMessageF(playerid, ZUTA, "* Izmenili ste maxX/maxY koordinate za zonu %d.", turf);
        }
    }

    format(query, sizeof query, "UPDATE turfs SET zone = '%.4f,%.4f,%.4f,%.4f' WHERE id = %d", TURFS[turf][t_minx], TURFS[turf][t_miny], TURFS[turf][t_maxx], TURFS[turf][t_maxy], turf);
    mysql_tquery(SQL, query, "mysql_no_return_query", "i", THREAD_TURF_UPDATE);

    DeletePVar(playerid, "pTurfEdit");
    DestroyZone(TURFS[turf][t_zone]);
    DestroyDynamicArea(TURFS[turf][t_areaid]);

    TURFS[turf][t_zone] = CreateZone(TURFS[turf][t_minx], TURFS[turf][t_miny], TURFS[turf][t_maxx], TURFS[turf][t_maxy]);
    CreateZoneNumber(TURFS[turf][t_zone], turf);
    CreateZoneBorders(TURFS[turf][t_zone]);
    TURFS[turf][t_areaid] = CreateDynamicRectangle(TURFS[turf][t_minx], TURFS[turf][t_miny], TURFS[turf][t_maxx], TURFS[turf][t_maxy]);

    // Prikazivanje zone
    new color = (TURFS[turf][t_fid] != -1) ? (HexToInt(FACTIONS[TURFS[turf][t_fid]][f_hex]) - 80) : TURF_FREE_COLOR;
    ShowZoneForAll(TURFS[turf][t_zone], color);
    return 1;
}

Dialog:turfedit4(playerid, response, listitem, const inputtext[]) 
{ // Brisanje zone
    if (!response) return PC_EmulateCommand(playerid, "/turfedit");

    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new 
        query[34],
        turf = strval(inputtext);
    format(query, sizeof query, "DELETE FROM turfs WHERE id = %d", turf);
    mysql_tquery(SQL, query);

    DestroyZone(TURFS[turf][t_zone]);
    DestroyDynamicArea(TURFS[turf][t_areaid]);
    DestroyDynamic3DTextLabel(TURFS[turf][t_labelid]);

    TURFS[turf][t_fid] = -1;
    TURFS[turf][t_level] = 1;
    TURFS[turf][t_benefit] = 0;
    TURFS[turf][t_areaid] = -1;
    TURFS[turf][t_minx] = TURFS[turf][t_miny] = TURFS[turf][t_maxx] = TURFS[turf][t_maxy] =
    TURFS[turf][t_interact][POS_X] = TURFS[turf][t_interact][POS_Y] = TURFS[turf][t_interact][POS_Z] = 0.0;
    TURFS[turf][t_labelid] = Text3D:INVALID_3DTEXT_ID;

    SendClientMessageF(playerid, ZUTA, "* Zona %d je izbrisana.", turf);
    return PC_EmulateCommand(playerid, "/turfedit");
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:turftp(FLAG_ADMIN_1)
CMD:turftp(playerid, const params[]) 
{
    new turf;
    if (sscanf(params, "i", turf))
        return Koristite(playerid, "turftp [ID zone]");

    if (turf < 1 || turf >= MAX_TURFS)
        return ErrorMsg(playerid, "Pogresan ID zone.");

    TeleportPlayer(playerid, TURFS[turf][t_interact][POS_X], TURFS[turf][t_interact][POS_Y], TURFS[turf][t_interact][POS_Z]);

    // Postavljane enterijera i worlda na 0
    if (GetPlayerVehicleID(playerid) != 0)
    {
        LinkVehicleToInterior(GetPlayerVehicleID(playerid), 0);
        SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
    }
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    
    // Slanje poruke igracu
    SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovani ste u zonu %d.", turf);
    return 1;
}

CMD:turfedit(playerid, const params[]) 
{
    if (!IsHeadAdmin(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    SPD(playerid, "turfedit1", DIALOG_STYLE_LIST, "Izmena zone", "Izmeni zonu...\nIzbrisi zonu...\nDodaj novu zonu", "Dalje ", "Izadji");
    return 1;
}

CMD:turfcreate(playerid, const params[]) 
{
    if (!IsHeadAdmin(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
    if (!isnull(params) && !strcmp(params, "min")) 
    {
        new str[22];
        format(str, sizeof str, "%.4f,%.4f", pos[0], pos[1]);
        SetPVarString(playerid, "pTurfCreateMin", str);
    }

    else if (!isnull(params) && !strcmp(params, "max")) 
    {
        new str[22];
        format(str, sizeof str, "%.4f,%.4f", pos[0], pos[1]);
        SetPVarString(playerid, "pTurfCreateMax", str);
    }

    else if (!isnull(params) && !strcmp(params, "interact")) 
    {
        new str[33];
        format(str, sizeof str, "%.4f,%.4f,%.4f", pos[0], pos[1], pos[2]);
        SetPVarString(playerid, "pTurfCreateInteract", str);
    }

    else return Koristite(playerid, "/turfcreate [min/max/interact]");

    new minStr[22], maxStr[22], interact[33];
    GetPVarString(playerid, "pTurfCreateMin",       minStr,     sizeof minStr);
    GetPVarString(playerid, "pTurfCreateMax",       maxStr,     sizeof maxStr);
    GetPVarString(playerid, "pTurfCreateInteract",  interact,   sizeof interact);

    if (!isnull(minStr) && !isnull(maxStr) && !isnull(interact))
        return SendClientMessage(playerid, ZELENA, "* Sacuvali ste sve potrebne koordinate. Koristite /turfedit da kreirate zonu.");

    return 1;
}

flags:turfreset(FLAG_ADMIN_6)
CMD:turfreset(playerid, const params[])
{
    new 
        turf = GetPlayerTurf(playerid)
    ;

    if (turf == INVALID_TURF_ID)
        return ErrorMsg(playerid, "Ne mozete koristiti tu komandu na ovom mestu.");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, TURFS[turf][t_interact][POS_X], TURFS[turf][t_interact][POS_Y], TURFS[turf][t_interact][POS_Z]))
        return ErrorMsg(playerid, "Morate stajati na pickupu da biste resetovali nivo.");

    TURFS[turf][t_level] = 1;
    UpdateTurfLabel(turf);

    new sQuery[46];
    format(sQuery, sizeof sQuery, "UPDATE turfs SET level = %i WHERE id = %i", TURFS[turf][t_level], turf);
    mysql_tquery(SQL, sQuery);

    InfoMsg(playerid, "Zona %i je resetovana na nivo 1.", turf);

    return 1;
}