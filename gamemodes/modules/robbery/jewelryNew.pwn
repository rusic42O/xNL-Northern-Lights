#include <YSI_Coding\y_hooks>
#include jewelry_safes.pwn

/*
    TODO handling:

    - Kada inicijator pogine
    - Kada inicijator bude uhapsen (zavezan)
    - Kada vreme istekne

*/

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define JEWELRY_ROB_BOUNTY   (120000)
#define JEWELRY_ROB_BONUS    (60000) // rand max




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    jRob_cooldown,
    jRob_faction,
    jRob_pickup,
    jRob_checkpoint,
    Text3D:jRob_3dtext,
    jRob_time,
    jRob_initiator,
    jRob_doors,
    jRob_goldBar[sizeof jRob_goldBarArray], // 300 zlatnih poluga u ZlataraSefovi.inc
    jRob_goldBarCounter,
    jRob_policeTarget, // Ne resetuje se dok igrac ne umre, bude uhapsen, izadje iz igre..

    Iterator:iGoldBars<sizeof jRob_goldBarArray>,

    tajmer:jRob_main,
    tajmer:jRob_emptySafe,

    jewelry_area,
    bool:jRob_killed[MAX_PLAYERS char],

    vrataZlatareD,
    vrataZlatareL
;



// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    for__loop (new i = 0; i < sizeof jRob_goldBar; i++) 
    {
        jRob_goldBar[i] = CreateDynamicObject(19941, jRob_goldBarArray[i][GOLDBAR_X], jRob_goldBarArray[i][GOLDBAR_Y], jRob_goldBarArray[i][GOLDBAR_Z], jRob_goldBarArray[i][GOLDBAR_ROTX], jRob_goldBarArray[i][GOLDBAR_ROTY], jRob_goldBarArray[i][GOLDBAR_ROTZ], 200.0, 200.0);
        Iter_Add(iGoldBars, i);
    }

    jRob_faction = jRob_pickup = jRob_initiator = jRob_checkpoint = -1;
    jRob_policeTarget = INVALID_PLAYER_ID;
    tajmer:jRob_main = tajmer:jRob_emptySafe = jRob_time = jRob_cooldown = jRob_goldBarCounter = 0;
    jRob_3dtext = Text3D:INVALID_3DTEXT_ID;

    jRob_doors = CreateDynamicObject(19799, 895.536193, -1353.425537, 9.937844, 0.000000, 0.000000, -180.000000, 750.00, 750.00); 
    //jewelry_area = CreateDynamicRectangle(578.3140,-1493.3745, 621.7431,-1422.9742);
    jewelry_area = CreateDynamicRectangle(871.9656, -1360.9545, 916.9656, -1321.9545);

    //VRAZA ZLATARE

    vrataZlatareL = CreateDynamicObject(19325, 891.215637, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
    SetDynamicObjectMaterial(vrataZlatareL, 0, -1, "none", "none", 0xFF333333);
    vrataZlatareD = CreateDynamicObject(19325, 895.325012, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
    SetDynamicObjectMaterial(vrataZlatareD, 0, -1, "none", "none", 0xFF333333);

    return 1;
}

hook OnPlayerConnect(playerid)
{
    jRob_killed{playerid} = false;
}

hook OnBombExplosion(playerid, Float:X, Float:Y, Float:Z)
{
    if (GetDistanceBetweenPoints(X, Y, Z, 896.4946,-1354.0051,9.4625) <= 6.0 && IsACriminal(playerid)) 
    {
        // Postavljena je bomba ispred vrata trezora u zlatari (samo mafije i bande)

        if (jRob_cooldown > gettime()) 
        {
            new string[87];
            format(string, sizeof string, "Zlatara je nedavno opljackana! Pokusajte ponovo za {FFFFFF}%s.", konvertuj_vreme(jRob_cooldown - gettime()));
            RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
            return 1;
        }

        // TODO: Ukoliko nema po 3 clana policije i date mafije/bande, obustaviti dalje izvrsavanje koda jer ne moze da se pljacka


        DestroyDynamicObject(jRob_doors);
        jRob_doors = CreateDynamicObject(19799, 896.8040, -1344.8013, 4.5000, 90.0, 40.0, -269.9200, 750.00, 750.00); 
        jRob_pickup = CreateDynamicPickup(19941, 1, 601.3725, -1443.8057, 9.8155);
        jRob_3dtext = CreateDynamic3DTextLabel("{FF0000}[ PLJACKA ZLATARE ]\n{FF9900}/pljacka", BELA, 891.6241, -1354.5830, 5.3360, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
        

        jRob_faction = PI[playerid][p_org_id];
        new str[26];
        format(str, sizeof str, "POLUGE:   000/%03d", sizeof jRob_goldBar);
        TextDrawSetString(tdJewelryRobCounter, str);
        // TextDrawSetString(tdJewelryRobTime, "VREME:      10:00");
        jRob_time = 1800;
        tajmer:jRob_main = SetTimer("JewelryRobTimer", 1000, true);

        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == jRob_faction) 
            {
                // TextDrawShowForPlayer(i, tdJewelryRobTime);
                TextDrawShowForPlayer(i, tdJewelryRobCounter);
            }
        }
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == jRob_checkpoint && playerid == jRob_initiator)
    {
        DestroyPlayerCP(jRob_checkpoint, playerid), jRob_checkpoint = -1;
        RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        // Skill UP za sve clanove u okolini
        if (IsACriminal(playerid))
        {
            new fid = PI[playerid][p_org_id],
                Float:x,Float:y,Float:z,
                totalRanks = 0,
                Iterator:iAwardPlayers<MAX_PLAYERS>
            ;
            Iter_Clear(iAwardPlayers);
            GetPlayerPos(playerid, x, y, z);
            foreach (new i : Player)
            {
                if (PI[i][p_org_id] == fid)
                {
                    if (IsPlayerInRangeOfPoint(i, 15.0, x, y, z) && !IsPlayerAFK(i))
                    {
                        totalRanks += PI[i][p_org_rank];
                        Iter_Add(iAwardPlayers, i);

                        if (i == playerid)
                            PlayerUpdateCriminalSkill(i, 5, SKILL_ROBBERY_JEWELRY, 0);
                        else
                            PlayerUpdateCriminalSkill(i, 2, SKILL_ROBBERY_JEWELRY, 1);
                    }
                }
            }

            // Upisivanje u log
            new logStr[75];
            format(logStr, sizeof logStr, "ZLATARA-USPEH | %s | %s | %i zlatnika", FACTIONS[jRob_faction][f_tag], ime_obicno[playerid], totalRanks);
            Log_Write(LOG_ROBBERY, logStr);

            SendClientMessageFToAll(SVETLOCRVENA2, "_______________________________________________________\n");
            SendClientMessageFToAll(BELA, "Vesti | {FF6347}Nepoznata grupa razbojnika opljackala je zlataru!");
            SendClientMessageFToAll(SVETLOCRVENA2, "    - Kako nezvanicno saznajemo, vrednost ukradenog zlata se procenjuje na oko {FF0000}%s!", formatMoneyString( 10000 * totalRanks ));
            SendClientMessageFToAll(SVETLOCRVENA2, "_______________________________________________________");

            foreach (new p : iAwardPlayers)
            {
                PI[p][p_zlato] += PI[p][p_org_rank];
                SendClientMessageF(p, BELA, "* Zaradio si {00FF00}%i zlatnika {FFFFFF}od pljacke zlatare. Stanje zlata: {FFFF00}%i", PI[p][p_org_rank], PI[p][p_zlato]);

                new sQuery[54];
                format(sQuery, sizeof sQuery, "UPDATE igraci SET zlato = %i WHERE id = %i", PI[p][p_zlato], PI[p][p_id]);
                mysql_tquery(SQL, sQuery);
            }
        }

        // Resetovanje
        jRob_Reset();
        jRob_policeTarget = INVALID_PLAYER_ID;
        return ~1;
    }
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (jRob_policeTarget == playerid)
    {
        if (IsPlayerConnected(killerid))
        {
            if (PI[killerid][p_org_id] == PI[playerid][p_org_id]) 
            {
                // Pripadnik iste mafije/bande je ubio igraca koji pljacka
                PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "TK");
            }
            else if (IsACriminal(playerid) && IsACop(killerid)) // Policajac je ubio pljackasa
            {
                // Dobijaju duplo manju nagradu jer nisu uspeli da ga uhapse
                new bounty = floatround((GetJewelryRobBounty()/2.0)/10000) * 10000;
                SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku banke je ubijen u vatrenom okrsaju sa policijom.", ime_rp[playerid]);
                SendClientMessageFToAll(SVETLOCRVENA2, "    - Policija naseg grada je zbog ovog hrabrog poduhvata nagradjena sa {FFFFFF}%s.", formatMoneyString(bounty));

                RemoveJewelryPoliceTarget();

                new logStr[99];
                format(logStr, sizeof logStr, "ZLATARA-UBISTVO | %s je ubio %s | %s", ime_obicno[killerid], ime_obicno[playerid], formatMoneyString(bounty));
                Log_Write(LOG_ROBBERY, logStr);

                new skill = 3;

                // Skill UP za policajca i njegove pomocnike + nagrade za banku/zlataru
                new Float:x,Float:y,Float:z,
                    totalRanks = 0,
                    Iterator:iAwardPlayers<MAX_PLAYERS>;
                Iter_Clear(iAwardPlayers);
                GetPlayerPos(killerid, x, y, z);
                foreach (new i : Player)
                {
                    if (IsPlayerInRangeOfPoint(i, 25.0, x, y, z) && IsACop(i) && IsPlayerOnLawDuty(i))
                    {
                        if (bounty > 0)
                        {
                            totalRanks += PI[i][p_org_rank];
                            Iter_Add(iAwardPlayers, i);
                        }
                        PlayerUpdateCopSkill(i, skill, SKILL_ARREST, (i==killerid)? 0 : 1);
                    }
                }

                if (bounty > 0)
                {    
                    new sLog[75];
                    format(sLog, sizeof sLog, "- Raspodela novca (rank suma = %i, igraca = %i)", totalRanks, Iter_Count(iAwardPlayers));
                    Log_Write(LOG_ROBBERY, sLog);

                    foreach (new p : iAwardPlayers)
                    {
                        new cash = floatround(bounty/totalRanks * PI[p][p_org_rank]);
                        PlayerMoneyAdd(p, cash);
                        SendClientMessageF(p, BELA, "* Vi ste rank %i. Zaradili ste {00FF00}%s {FFFFFF}zbog sprecavanja pljacke.", PI[p][p_org_rank], formatMoneyString(cash));

                        format(sLog, sizeof sLog, "--- %s | %s | Rank %i", ime_obicno[p], formatMoneyString(cash), PI[p][p_org_rank]);
                        Log_Write(LOG_ROBBERY, sLog);
                    }
                }
            }
        }

        jRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (playerid == jRob_initiator)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        FactionMsg(jRob_faction, "{FF0000}Pljacka zlatare je propala jer je %s poginuo.", ime_rp[playerid]);

        SendClientMessageFToAll(BELA, "Vesti | {FF6347}%s, koji je osumnjicen za nedavno pokusanu pljacku zlatare je poginuo u tragicnoj nesreci.", ime_rp[playerid]);

        // Upisivanje u log
        new logStr[53];
        format(logStr, sizeof logStr, "ZLATARA-FAIL | %s je poginuo", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        jRob_Reset();
        jRob_policeTarget = INVALID_PLAYER_ID;
    }

    else
    {
        if (IsJewelryRobberyActive())
        {
            if (IsPlayerInArea(playerid, 869.9686, 1369.9798, 912.9686, 1331.9798))
            {
                if (IsPlayerConnected(killerid) && jRob_killed{killerid})
                {
                    // Napravio RK
                    PromptPunishmentDialog(playerid, killerid, 60, 0, 50000, "Revenge Kill (zlatara)");
                    SetTimerEx("ShowRulesDialog_TURF_ROB", 30000, false, "ii", killerid, cinc[killerid]);
                }
                else
                {
                    jRob_killed{playerid} = true;
                }
            }
        }
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (playerid == jRob_initiator)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        SendClientMessageFToAll(CRVENA, "OVERWATCH | {FFFFFF}Pljacka zlatare je propala jer je {FF9933}%s {FFFFFF}napustio server.", ime_rp[playerid]);

        // Upisivanje u log
        new logStr[62];
        format(logStr, sizeof logStr, "ZLATARA-FAIL | %s je napustio server", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        jRob_Reset();
        jRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (jRob_policeTarget == playerid)
    {
        jRob_policeTarget = INVALID_PLAYER_ID;
    }
}

hook OnPlayerSpawn(playerid)
{
    if (playerid == jRob_initiator)
    {    
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        // FactionMsg(jRob_faction, "{FF0000}Pljacka zlatare je propala.");
        SendClientMessageToAll(CRVENA, "OVERWATCH | {FFFFFF}Pljacka zlatare je prekinuta.");

        // Upisivanje u log
        new logStr[52];
        format(logStr, sizeof logStr, "ZLATARA-FAIL | %s | Respawn", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        jRob_Reset();
        jRob_policeTarget = INVALID_PLAYER_ID;
    }

    if (jRob_policeTarget == playerid)
    {
        jRob_policeTarget = INVALID_PLAYER_ID;
    }
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (jRob_initiator == playerid && areaid == jewelry_area && tajmer:jRob_emptySafe > 0)
    {
        // Pokretac je napustio zonu zlatare dok je trajala pljacka
        if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BACKPACK))
            RemovePlayerAttachedObject(playerid, SLOT_BACKPACK);

        FactionMsg(jRob_faction, "{FF0000}Pljacka zlatare je propala jer je %s napustio zlataru.", ime_rp[playerid]);

        // Upisivanje u log
        new logStr[62];
        format(logStr, sizeof logStr, "ZLATARA-FAIL | %s je napustio zlataru", ime_obicno[playerid]);
        Log_Write(LOG_ROBBERY, logStr);

        jRob_Reset();
        return ~1;
    }

    return 1;
}


/*hook OnPlayerUpdate(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, 893.3087,-1336.4176,13.5469) || IsPlayerInRangeOfPoint(playerid, 2.0, 893.2772,-1339.7253,13.5735))
    {
        MoveDynamicObject(vrataZlatareL, 888.975585, -1338.128906, 14.937245, 3.0, 90.000000, 90.000000, 180.000000);
        MoveDynamicObject(vrataZlatareD, 897.505187, -1338.128906, 14.937245, 3.0, 90.000000, 90.000000, 180.000000);
        SetTimer("zatvoriZlataraVrata", 5000, false);
    }
}*/

/*
zatvoreno vjv---

NLzlatarabb = CreateDynamicObject(19325, 891.215637, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
SetDynamicObjectMaterial(NLzlatarabb, 0, -1, "none", "none", 0xFF333333);
NLzlatarabb = CreateDynamicObject(19325, 895.325012, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
SetDynamicObjectMaterial(NLzlatarabb, 0, -1, "none", "none", 0xFF333333);

otvoreno vjv--

NLzlatarabb = CreateDynamicObject(19325, 888.975585, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
SetDynamicObjectMaterial(NLzlatarabb, 0, -1, "none", "none", 0xFF333333);
NLzlatarabb = CreateDynamicObject(19325, 897.505187, -1338.128906, 14.937245, 90.000000, 90.000000, 180.000000, -1, -1, -1, 500.00, 500.00); 
SetDynamicObjectMaterial(NLzlatarabb, 0, -1, "none", "none", 0xFF333333);*/



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //

/*forward zatvoriZlataraVrata();
public zatvoriZlataraVrata()
{
    MoveDynamicObject(vrataZlatareL, 891.215637, -1338.128906, 14.937245, 3.0, 90.000000, 90.000000, 180.000000);
    MoveDynamicObject(vrataZlatareD, 895.325012, -1338.128906, 14.937245, 3.0, 90.000000, 90.000000, 180.000000);
    return 1;
}*/

forward JewelryRobTimer();
public JewelryRobTimer() 
{
    jRob_time -= 1;

    if (jRob_time <= 0)
    {
        // Vreme za pljacku je isteklo
        if (IsPlayerConnected(jRob_initiator) && PI[jRob_initiator][p_org_id] == jRob_faction && IsPlayerAttachedObjectSlotUsed(jRob_initiator, SLOT_BACKPACK))
        {
            RemovePlayerAttachedObject(jRob_initiator, SLOT_BACKPACK);
        }

        // Upisivanje u log
        Log_Write(LOG_ROBBERY, "ZLATARA-FAIL | Isteklo vreme");

        jRob_Reset();
        return 1;
    }
    return 1;
}

forward JewelryRobEmptySafe();
public JewelryRobEmptySafe()
{
    if (DebugFunctions())
    {
        LogFunctionExec("JewelryRobEmptySafe");
    }

    for__loop (new i = jRob_goldBarCounter; i < (jRob_goldBarCounter); i++) { // ovdje +10
        DestroyDynamicObject(jRob_goldBar[i]);
        jRob_goldBar[i] = -1;
        Iter_Remove(iGoldBars, jRob_goldBarCounter);
    }
    jRob_goldBarCounter += 1;

    new str[26];
    format(str, sizeof str, "POLUGE:   %03d/%03d", jRob_goldBarCounter, sizeof jRob_goldBarArray);
    TextDrawSetString(tdJewelryRobCounter, str);


    if (jRob_goldBarCounter == 24)
    {
        SetPlayerAttachedObject(jRob_initiator, SLOT_BACKPACK, 11745, 1, 0.007999, -0.152000, 0.000000, 85.900054, 164.200180, -100.400016);
        KillTimer(tajmer:jRob_emptySafe), tajmer:jRob_emptySafe = 0;
        KillTimer(tajmer:jRob_main), tajmer:jRob_main = 0;

        TextDrawHideForAll(tdJewelryRobTime);
        TextDrawHideForAll(tdJewelryRobCounter);

        new Float:x,Float:y,Float:z;
        GetPlayerPos(jRob_initiator, x, y, z);
    
        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == jRob_faction)
            {
                if (i == jRob_initiator)
                {
                    SendClientMessage(i, CRVENA, "Pljacka je uspesna! {FF9900}Odnesite vrecu sa polugama u bazu!");
                    jRob_checkpoint = CreatePlayerCP(FACTIONS[jRob_faction][f_x_spawn], FACTIONS[jRob_faction][f_y_spawn], FACTIONS[jRob_faction][f_z_spawn], 7.0, 0, 0, i, 6000.0);

                    ClearAnimations(i, 1);
                    SetCameraBehindPlayer(i);

                    PlayerUpdateCriminalSkill(i, 5, SKILL_ROBBERY_JEWELRY, 0);

                }
                else
                {
                    SendClientMessageF(i, CRVENA, "Pljacka je uspesna! {FF9900}Pomozite {FFFFFF}%s {FF9900}da bezbedno dodje do baze i ostavi zlatne poluge.", ime_rp[jRob_initiator]);

                    if (IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
                    {
                        PlayerUpdateCriminalSkill(i, 3, SKILL_ROBBERY_JEWELRY, 1);
                    }
                }
            }
        }
    }
}

stock IsJewelryRobberyActive()
{
    if (jRob_time > 0 && IsPlayerConnected(jRob_initiator))
    {
        return true;
    }
    return false;
}

stock jRob_Reset() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("jRob_Reset");
    }

    if (IsValidDynamicCP(jRob_checkpoint))
    {
        if (IsPlayerConnected(jRob_initiator))
            DestroyPlayerCP(jRob_checkpoint, jRob_initiator);
        else
            DestroyDynamicCP(jRob_checkpoint);
    }

    if (IsValidDynamicPickup(jRob_pickup))
        DestroyDynamicPickup(jRob_pickup);

    if (IsValidDynamic3DTextLabel(jRob_3dtext))
        DestroyDynamic3DTextLabel(jRob_3dtext);

    foreach (new i : Player)
    {
        jRob_killed{i} = false;
    }

    jRob_faction = jRob_pickup = jRob_initiator = jRob_checkpoint = -1;
    jRob_time = jRob_cooldown = jRob_goldBarCounter = 0;
    jRob_3dtext = Text3D:INVALID_3DTEXT_ID;

    TextDrawHideForAll(tdJewelryRobTime);
    TextDrawHideForAll(tdJewelryRobCounter);

    KillTimer(tajmer:jRob_emptySafe), tajmer:jRob_emptySafe = 0;
    KillTimer(tajmer:jRob_main), tajmer:jRob_main = 0;

    jRob_cooldown = gettime() + 3600; // 1h cooldown
    SetTimer("JewelryReset", 60*60*1000, false);

    DestroyDynamicObject(jRob_doors);
    //jRob_doors = CreateDynamicObject(1533, 593.653076, -1435.329345, 8.758131, 0.000000, 0.000000, 90.000000, 750.00, 750.00);
    jRob_doors = CreateDynamicObject(19799, 895.536193, -1353.425537, 9.937844, 0.000000, 0.000000, -180.000000, 750.00, 750.00);

    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, 50.0, 895.536193, -1353.425537, 9.937844))
            Streamer_Update(i, STREAMER_TYPE_OBJECT);
    }

    // jRob_cooldown = gettime() + 60; // 60s cooldown
    // SetTimer("JewelryReset", 60*1000, false);
    return 1;
}

forward JewelryReset();
public JewelryReset()
{
    if (DebugFunctions())
    {
        LogFunctionExec("JewelryReset");
    }

    // Rekreiranje objekata zlatnih poluga
    if (Iter_Count(iGoldBars) > 0)
    {
        foreach (new i : iGoldBars)
        {
            DestroyDynamicObject(jRob_goldBar[i]);
            jRob_goldBar[i] = -1;
            Iter_SafeRemove(iGoldBars, i, i);
        }
    }
    for__loop (new i = 0; i < sizeof jRob_goldBar; i++) 
    {
        jRob_goldBar[i] = CreateDynamicObject(19941, jRob_goldBarArray[i][GOLDBAR_X], jRob_goldBarArray[i][GOLDBAR_Y], jRob_goldBarArray[i][GOLDBAR_Z], jRob_goldBarArray[i][GOLDBAR_ROTX], jRob_goldBarArray[i][GOLDBAR_ROTY], jRob_goldBarArray[i][GOLDBAR_ROTZ], 200.0, 200.0);
        Iter_Add(iGoldBars, i);
    }

    
    //DestroyDynamicObject(jRob_doors);
    //jRob_doors = CreateDynamicObject(1533, 593.653076, -1435.329345, 8.758131, 0.000000, 0.000000, 90.000000, 750.00, 750.00);
    //jRob_doors = CreateDynamicObject(19799, 895.536193, -1353.425537, 9.937844, 0.000000, 0.000000, -180.000000, 750.00, 750.00); 
}

stock IsPlayerRobbingJewelry(playerid) 
{
    if (jRob_initiator == playerid) return 1;
    return 0;
}

stock GetFactionRobbingJeweley()
{
    return jRob_faction;
}

stock GetJewelryPoliceTarget()
{
    return jRob_policeTarget;
}

stock RemoveJewelryPoliceTarget()
{
    jRob_policeTarget = INVALID_PLAYER_ID;
}

JewelryRob_SetPoliceTarget(playerid)
{
    jRob_policeTarget = playerid;
}

stock GetJewelryRobBounty()
{
    return JEWELRY_ROB_BOUNTY + random(JEWELRY_ROB_BONUS);
}

stock GetJewelryCooldownTimestamp()
{
    return jRob_cooldown;
}

// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pljackajzlataru(playerid, const params[]) 
{
    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 891.6241,-1354.5830,5.3360))
        return ErrorMsg(playerid, "Niste na mestu za pljackanje zlatare.");

    if (!IsACriminal(playerid))
        return ErrorMsg(playerid, "Samo clanovi mafija i bandi mogu da pljackaju zlataru.");

    if (GetPlayerWeapon(playerid) <= 0)
        return ErrorMsg(playerid, "Morate drzati oruzje u ruci da biste pokrenuli pljacku.");

    if (tajmer:jRob_emptySafe > 0)
        return ErrorMsg(playerid, "Pljacka zlatare je vec u toku!");

    if (jRob_3dtext == Text3D:INVALID_3DTEXT_ID)
        return ErrorMsg(playerid, "Prvo raznesite vrata bombom.");


    if (jRob_cooldown > gettime()) 
    {
        new string[87];
        format(string, sizeof string, "Zlatara je nedavno opljackana! Pokusajte ponovo za {FFFFFF}%s.", konvertuj_vreme(jRob_cooldown - gettime()));
        RangeMsg(playerid, string, SVETLOCRVENA, 15.0);
        return 1;
    }



    // Provera da li ima barem 3 saigraca + barem 1 policajac
    new mb_igraci = 0, pd_igraci = 0, pd_nonafk = 0;
    foreach (new i : Player)
    {
        if (IsACop(i)) 
        {
            pd_igraci++;
            if (!IsPlayerAFK(i)) pd_nonafk ++;
        }
        if (PI[i][p_org_id] == PI[playerid][p_org_id]) mb_igraci++;
    }
    if (pd_igraci < 2 && testingdaddy == false)
        return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 2).");
    if (mb_igraci < 3 && testingdaddy == false)
        return ErrorMsg(playerid, "Nema dovoljno vasih saigraca (minimum 3).");

    new h, m;
    gettime(h, m);
    if (h > 0 && h < 10)
    {
        if (pd_nonafk < 2 && testingdaddy == false)
            return ErrorMsg(playerid, "Nema dovoljno pripadnika policije (minimum 2) ili su neki AFK.");
    }

    new fID = GetFactionIDbyName("La casa de pepel");
	if (fID == -1) return ErrorMsg(playerid, "Dogodila se greska, trenutno ne mozete koristiti ovu komandu!");
	if (fID != GetPlayerFactionID(playerid)) return ErrorMsg(playerid, "Nazalost, ovu radnju mogu samo pripadnici La casa de pepel-a!");

    jRob_initiator = playerid;
    jRob_goldBarCounter = 0;
    jRob_policeTarget = playerid;

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0,1,0,0,1,0);
    tajmer:jRob_emptySafe = SetTimer("JewelryRobEmptySafe", 16*1000, true); // 30 sefova, 480 sekundi --> 480/30 = 16
    // tajmer:jRob_emptySafe = SetTimer("JewelryRobEmptySafe", 1000, true); // Ubrzana pljacka, zbog testiranja

    // SetPlayerCameraPos(playerid, 584.6992,-1433.4574,10.8155);
    SetPlayerCameraPos(playerid, 905.8217, -1338.5513, 16.8542);
    SetPlayerCameraLookAt(playerid, 905.1132, -1339.2542, 16.5592, CAMERA_MOVE);
    

    DestroyDynamicPickup(jRob_pickup), jRob_pickup = -1;
    DestroyDynamic3DTextLabel(jRob_3dtext), jRob_3dtext = Text3D:INVALID_3DTEXT_ID;

    AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Pljacka zlatare", "Snimak sa nadzorne kamere");

    // Slanje poruke policiji i obavestenje za sve igrace
    SendClientMessageFToAll(SVETLOCRVENA2, "__________________________________________________________________");
    SendClientMessageFToAll(SVETLOCRVENA2, "");
    SendClientMessageFToAll(BELA, "Vesti | {FF6347}U toku je pljacka zlatare od strane neidentifikovane kriminalne grupe!");
    SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom delu grada!");
    SendClientMessageFToAll(SVETLOCRVENA2, "__________________________________________________________________");

    DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}pljacka zlatare u toku!");
    return 1;
}

flags:resetzlatara(FLAG_ADMIN_6)
cmd:resetzlatara(const playerid)
{
    jRob_Reset();
    jRob_cooldown = gettime() + 3600; // 1h cooldown
    SetTimer("JewelryReset", 100, false);
    InfoMsg(playerid, "Zlatara rob je resetovan!");
    return 1;
}