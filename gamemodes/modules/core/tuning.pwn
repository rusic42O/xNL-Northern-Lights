#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PART_EXHAUST        (1)
#define PART_HOOD           (2)
#define PART_HYDRAULICS     (4)
#define PART_LIGHTS         (8)
#define PART_ROOF           (16)
#define PART_SIDESKIRTS     (32)
#define PART_SPOILER        (64)
#define PART_VENTS          (128)
#define PART_WHEELS         (256)
#define PART_BUMPER_F       (512)
#define PART_BUMPER_R       (1024)
#define PART_BULLBAR_F      (2048)
#define PART_BULLBAR_R      (4096)
#define PART_PAINTJOB       (8192)
#define PART_NITRO          (16384)
#define PART_NEON           (32768)

#define TUNING_FIRMA_ID     (17) // ID tuning firme

#define NITRO_PRICE         (35000) // Nitro cena
#define NEON_PRICE          (30000) // Neonka cena
#define NEON_REMOVAL_PRICE  (15000) // Uklanjanje neonke




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    componentPriceList[MAX_PLAYERS][17], // 17 zbog felni
    tuningCP,
    paintingCP,
    specTuningCP,
    pNeonLightObj[MAX_PLAYERS][2];

/*
Unutar NLRPGv3.pwn:

static const gTuningVehicleInfo[212][e_tuningVehicleInfo] = { ... };
*/




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    tuningCP = CreateDynamicCP(2520.8271,-1535.7303,24.7279, 3.0, 0, 0, -1, 10.0);
    paintingCP = CreateDynamicCP(1939.8813,-1976.8627,13.6409, 3.0, 0, 0, -1, 10.0);
    specTuningCP = CreateDynamicCP(1940.0121,-1987.0808,13.6408, 3.0, 0, 0, -1, 10.0);
    return true;
}

hook OnPlayerConnect(playerid) 
{
    pNeonLightObj[playerid][0] = pNeonLightObj[playerid][1] = -1;
    return true;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    for (new i = 0; i < 2; i++) 
    {
        if (IsValidDynamicObject(pNeonLightObj[playerid][i]))
            DestroyDynamicObject(pNeonLightObj[playerid][i]), pNeonLightObj[playerid][i] = -1;
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid) 
{
    if (checkpointid == tuningCP && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
    {
        new 
            ok = false, 
            vehicleid = GetPlayerVehicleID(playerid);

        for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
        {
            if (pVehicles[playerid][i] != 0) {
                if (vehicleid == OwnedVehicle[pVehicles[playerid][i]][V_ID]) 
                {
                    ok = true;
                    SetPVarInt(playerid, "pTuningVehID", pVehicles[playerid][i]); // ID vozila u bazi (za enum VEHICLES)
                }
            }
        }

        if (!ok) {
            ErrorMsg(playerid, "Tuning garazu mozete koristiti samo kada dodjete sa vozilom koje ste kupili u auto salonu.");
            return ~1;
        }


        // Postavljanje na dizalicu
        TogglePlayerControllable_H(playerid, false);
        SetPlayerVirtualWorld(playerid, playerid+1);
        SetVehicleVirtualWorld(vehicleid, playerid+1);
        SetVehicleZAngle(vehicleid, 0.0);
        SetVehiclePos(vehicleid, 2521.7664, -1525.6021, 25.1485);
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
        SetPlayerCameraPos(playerid, 2525.4475, -1518.0490, 25.9178);
        SetPlayerCameraLookAt(playerid, 2521.7664, -1525.6021, 25.1485);


        // Otvaranje tuning dialoga
        ShowTuningDialog(playerid, cinc[playerid]);
        return ~1;
    }

    else if (checkpointid == paintingCP && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new 
            ok = false, 
            vehicleid = GetPlayerVehicleID(playerid)
        ;

        for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
        {
            if (pVehicles[playerid][i] != 0) 
            {
                if (vehicleid == OwnedVehicle[pVehicles[playerid][i]][V_ID]) 
                {
                    ok = true;
                    SetPVarInt(playerid, "pTuningVehID", pVehicles[playerid][i]); // ID vozila u bazi (za enum VEHICLES)
                }
            }
        }

        if (!ok) 
        {
            ErrorMsg(playerid, "Auto lakirnicu mozete koristiti samo kada dodjete sa vozilom koje ste kupili u auto salonu.");
            return ~1;
        }


        // Postavljanje na dizalicu
        TogglePlayerControllable_H(playerid, false);
        SetPlayerVirtualWorld(playerid, playerid+1);
        SetVehicleVirtualWorld(vehicleid, playerid+1);
        SetVehicleZAngle(vehicleid, 90.0);
        SetVehiclePos(vehicleid, 1939.8813,-1976.8627,13.6409);
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
        SetPlayerCameraPos(playerid, 1941.8253,-1980.9069,14.2469);
        SetPlayerCameraLookAt(playerid, 1939.8813,-1976.8627,13.6409);

        ShowPaintingDialog(playerid);
        ptdColors_Create(playerid);
    }
    else if (checkpointid == specTuningCP && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new 
            ok = false, 
            vehicleid = GetPlayerVehicleID(playerid)
        ;

        for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
        {
            if (pVehicles[playerid][i] != 0) 
            {
                if (vehicleid == OwnedVehicle[pVehicles[playerid][i]][V_ID]) 
                {
                    ok = true;
                    SetPVarInt(playerid, "pTuningVehID", pVehicles[playerid][i]); // ID vozila u bazi (za enum VEHICLES)
                }
            }
        }

        if (!ok) 
        {
            ErrorMsg(playerid, "Tuning garazu mozete koristiti samo kada dodjete sa vozilom koje ste kupili u auto salonu.");
            return ~1;
        }

        if (PI[playerid][p_tuning_pass] <= 0)
        {
            ErrorMsg(playerid, "Ne posedujete vaucer za specijalni tuning.");
            SendClientMessage(playerid, SVETLOPLAVA, "** Vaucer se dobija donacijom u iznosu od 5 EUR ili preko nagradnih igara.");
            return ~1;
        }

        if (OwnedVehicle_IsSpecTuned(GetPVarInt(playerid, "pTuningVehID")))
        {
            ErrorMsg(playerid, "Ovo vozilo vec ima specijalni tuning.");
            return ~1;
        }


        if (!OwnedVehicle_SetSpecTuning(GetPVarInt(playerid, "pTuningVehID"), true))
        {
            ErrorMsg(playerid, "Specijalni tuning nije dostupan za ovo vozilo.");
            return ~1;
        }


        // Postavljanje na dizalicu
        TogglePlayerControllable_H(playerid, false);
        SetPlayerVirtualWorld(playerid, playerid+1);
        SetVehicleVirtualWorld(vehicleid, playerid+1);
        SetVehicleZAngle(vehicleid, 90.0);
        SetVehiclePos(vehicleid, 1940.0121,-1987.0808,13.6408);
        SetVehicleParamsEx(vehicleid, 0, 0, 0, 0, 0, 0, 0);
        SetPlayerCameraPos(playerid, 1935.1821,-1983.2566,14.2469);
        SetPlayerCameraLookAt(playerid, 1940.0121,-1987.0808,13.6408);

        SPD(playerid, "spec_tuning", DIALOG_STYLE_MSGBOX, "Specijalni tuning", "{FFFFFF}Na tvoje vozilo je postavljen specijalni tuning.\n\nCena: $500.000", "Prihvati", "Izadji");
    }
    return 1;
}

Dialog:spec_tuning(playerid, response, listitem, const inputtext[])
{
    new id = GetPVarInt(playerid, "pTuningVehID");

    if (!response)
    {
        OwnedVehicle_RemoveSpecTuning(id);
    }

    if (response)
    {
        if (PI[playerid][p_novac] < 500000)
        {
            ErrorMsg(playerid, "Nemate dovoljno novca.");

            OwnedVehicle_RemoveSpecTuning(id);
        }   
        else
        {
            PlayerMoneySub(playerid, 500000);

            OwnedVehicle[id][V_SPEC_TUNING] = 1;
            PI[playerid][p_tuning_pass] --;

            new sQuery[57];
            format(sQuery, sizeof sQuery, "UPDATE vozila SET spec_tuning = 1 WHERE id = %i", id);
            mysql_tquery(SQL, sQuery);

            format(sQuery, sizeof sQuery, "UPDATE igraci SET tuning_pass = %i WHERE id = %i", PI[playerid][p_tuning_pass], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }
    }

    new vehicleid = GetPlayerVehicleID(playerid);

    new Float:tuningEndPos[6][4] = 
    {
        {1977.6617, -1985.5515, 13.2740, 180.0},
        {1981.1040, -1985.3730, 13.2740, 180.0},
        {1984.6720, -1985.5790, 13.2740, 180.0},
        {1984.2804, -1995.1174, 13.2775, 0.0},
        {1980.8396, -1995.6302, 13.2810, 0.0},
        {1977.7399, -1995.0300, 13.2810, 0.0}
    };
    new rand = random(sizeof tuningEndPos);

    SetPlayerVirtualWorld(playerid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);
    SetVehicleZAngle(vehicleid, tuningEndPos[rand][POS_A]);
    SetVehiclePos(vehicleid, tuningEndPos[rand][POS_X], tuningEndPos[rand][POS_Y], tuningEndPos[rand][POS_Z]); // edited by daddyDOT 18.5.2022. (edit: da porta na neko od parking mjesta umjesto ispred lakirnice)
    SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    TogglePlayerControllable_H(playerid, true);
    SetCameraBehindPlayer(playerid);
}

Dialog:lakirnica(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return CancelVehiclePainting(playerid);
    }


    if (listitem == 0)
    {
        SPD(playerid, "lakirnica_boja", DIALOG_STYLE_LIST, "{FFFFFF}Promena boje", "Boja 1\t$10000\nBoja 2\t$10000", "Izaberi", "Nazad");
    }
    else if (listitem == 1) // Paintjob
    {
        switch (GetVehicleModel(GetPlayerVehicleID(playerid))) 
        { 
            case 483: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad"), SetPVarInt(playerid, "RadiPaintJob", 1);
            case 575: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nPaintjob ID: 1\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad"), SetPVarInt(playerid, "RadiPaintJob", 1);
            case 534 .. 536, 558 .. 562, 565, 567, 576: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nPaintjob ID: 1\t$30000\nPaintjob ID: 2\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad"), SetPVarInt(playerid, "RadiPaintJob", 1);
            default: ErrorMsg(playerid, "Nema dostupnog paintjob-a za ovo vozilo.");
        }
    }
    return 1;
}

hook OnPlayerSelectColor(playerid, hex, colorid) 
{
    if (GetPVarInt(playerid, "pTuningVehID") <= 0)
        return 1;


    new 
        id = GetPVarInt(playerid, "pTuningVehID"),
        color1, color2;
    if (GetPVarInt(playerid, "pTuningColorSlot") == 1) 
    {
        color1 = colorid;
        color2 = OwnedVehicle[id][V_COLOR_2];
    }
    else 
    {
        color1 = OwnedVehicle[id][V_COLOR_1];
        color2 = colorid;
    }
    ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
    return 1;
}

hook OnPlayerBuyColor(playerid, hex, colorid) 
{
    if (GetPVarInt(playerid, "pTuningVehID") <= 0)
        return 1;


    new 
        id = GetPVarInt(playerid, "pTuningVehID"),
        color1, color2;

    if (PI[playerid][p_novac] < 10000) 
    {
        ErrorMsg(playerid, "Nemate dovoljno novca za promenu boje ($10.000).");
        ChangeVehicleColor(GetPlayerVehicleID(playerid), OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2]);
    }
    else 
    {
        if (GetPVarInt(playerid, "pTuningColorSlot") == 1) 
        {
            color1 = OwnedVehicle[id][V_COLOR_1] = colorid;
            color2 = OwnedVehicle[id][V_COLOR_2];
        }
        else 
        {
            color1 = OwnedVehicle[id][V_COLOR_1];
            color2 = OwnedVehicle[id][V_COLOR_2] = colorid;
        }
        ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
        PlayerMoneySub(playerid, 10000);
        re_firma_dodaj_novac(re_globalid(firma, TUNING_FIRMA_ID), 10000);

        format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET boja1 = %d, boja2 = %d WHERE id = %d", color1, color2, id);
        mysql_tquery(SQL, mysql_upit);

        ptdColors_Destroy(playerid);
        ptdColors_Create(playerid);
        ShowPaintingDialog(playerid);
        DeletePVar(playerid, "pTuningColorSlot");
        DeletePVar(playerid, "pTuningPrice");
        DeletePVar(playerid, "pTuningPart");
        DeletePVar(playerid, "pTuningComponentID");
        DeletePVar(playerid, "pTuningPartCode");
        DeletePVar(playerid, "pTuningPartText");
    }
    return 1;
}

hook OnPlayerExitColorMenu(playerid) 
{
    if (GetPVarInt(playerid, "pTuningVehID") <= 0)
        return 1;


    new id = GetPVarInt(playerid, "pTuningVehID");
    ChangeVehicleColor(GetPlayerVehicleID(playerid), OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2]);

    ptdColors_Destroy(playerid);
    ptdColors_Create(playerid);
    CancelVehiclePainting(playerid);
    
    // ShowTuningDialog(playerid, cinc[playerid]);
    // DeletePVar(playerid, "pTuningColorSlot");
    // DeletePVar(playerid, "pTuningPrice");
    // DeletePVar(playerid, "pTuningPart");
    // DeletePVar(playerid, "pTuningComponentID");
    // DeletePVar(playerid, "pTuningPartCode");
    // DeletePVar(playerid, "pTuningPartText");
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    for (new i = 0; i < 2; i++) 
    {
        if (IsValidDynamicObject(pNeonLightObj[playerid][i]))
            DestroyDynamicObject(pNeonLightObj[playerid][i]), pNeonLightObj[playerid][i] = -1;
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward ShowPaintingDialog(playerid);
public ShowPaintingDialog(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    switch (GetVehicleModel(vehicleid))
    {
        case 483, 534 .. 536, 558 .. 562, 565, 567, 575, 576: SPD(playerid, "lakirnica", DIALOG_STYLE_LIST, "{FFFFFF}Promena boje", "Promena boje\nPaintjob", "Dalje", "Zavrsi");
        default: SPD(playerid, "lakirnica_boja", DIALOG_STYLE_LIST, "{FFFFFF}Promena boje", "Boja 1\t$10000\nBoja 2\t$10000", "Izaberi", "Zavrsi");
    }
}

forward ShowTuningDialog(playerid, ccinc);
public ShowTuningDialog(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("ShowTuningDialog");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    new 
        vehicleid = GetPlayerVehicleID(playerid),
        modelid = GetVehicleModel(vehicleid);
    
    switch (modelid)
    {
        case 534 .. 536, 558 .. 562, 565, 567, 575, 576:
        {
            mysql_format(SQL, mysql_upit, 128, "SELECT part FROM vehicle_components WHERE cars=%i OR cars=-1 GROUP BY part", modelid);
            mysql_tquery(SQL, mysql_upit, "OnTuneLoad", "iii", playerid, 0, cinc[playerid]);
        }
        default:
        {
            new upit[354];
            
            mysql_format(SQL, upit, sizeof upit,
            "SELECT " \
            "IF(parts & 1 <> 0,'Izduvi','')," \
            "IF(parts & 2 <> 0,'Hauba','')," \
            "IF(parts & 4 <> 0,'Hidraulika','')," \
            "IF(parts & 8 <> 0,'Svetla','')," \
            "IF(parts & 16 <> 0,'Krov','')," \
            "IF(parts & 32 <> 0,'Sajtne','')," \
            "IF(parts & 64 <> 0,'Spojler','')," \
            "IF(parts & 128 <> 0,'Ventilacija','')," \
            "IF(parts & 256 <> 0,'Felne','') " \
            "FROM vehicle_model_parts WHERE modelid=%i", modelid);
            mysql_tquery(SQL, upit, "OnTuneLoad", "iii", playerid, 1, cinc[playerid]);
        }
    }
    return 1;
}

forward SetVehicleComponent(playerid, componentid, ccinc);
public SetVehicleComponent(playerid, componentid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("SetVehicleComponent");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);

    if (componentid <= 3) // Paintjob
    {
        ChangeVehiclePaintjob(vehicleid, componentid);

        //SetTimerEx("ShowPaintingDialog", 2500, false, "dd", playerid, cinc[playerid]);
        SetTimerEx("ShowTuningPurchase", 2500, false, "dd", playerid, cinc[playerid]);
    }
    else if (componentid > 18000) // Neonke
    {
        new vehid = GetPVarInt(playerid, "pTuningVehID");

        if (componentid == NEON_LIGHT_INVALID) // Ukloni neonke
        {
            if (!IsValidDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][0]) || !IsValidDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][1]))
            {
                ErrorMsg(playerid, "Ovo vozilo nema ugradjene neonke.");
                return ShowTuningDialog(playerid, cinc[playerid]);
            }
            else 
            {
                SetPVarInt(playerid, "pTuningNeon", Streamer_GetIntData(STREAMER_TYPE_OBJECT, OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][0], E_STREAMER_MODEL_ID));
                for__loop (new x = 0; x < 2; x++)
                {
                    if (IsValidDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][x]))
                        DestroyDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][x]), OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][x] = -1;
                }
                SetPVarInt(playerid, "pTuningPrice", NEON_REMOVAL_PRICE);
            }
        }
        else 
        {

            if (IsValidDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][0]) || IsValidDynamicObject(OwnedVehicle[vehid][V_NEON_LIGHT_OBJ][1]))
            {
                ErrorMsg(playerid, "Neonke su vec ugradjene na ovo vozilo. Moraju se ukloniti da bi se postavile nove.");
                return ShowTuningDialog(playerid, cinc[playerid]);
            }

            pNeonLightObj[playerid][0] = CreateDynamicObject(componentid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            pNeonLightObj[playerid][1] = CreateDynamicObject(componentid, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

            new idx = GetVehicleModel(vehicleid) - 400;
            AttachDynamicObjectToVehicle(pNeonLightObj[playerid][0], vehicleid, gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(pNeonLightObj[playerid][1], vehicleid, -gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);

            SetPVarInt(playerid, "pTuningPrice", NEON_PRICE);
        }
        SetPVarString(playerid, "pTuningPart", "Neonke");

        SetTimerEx("ShowTuningPurchase", 2500, false, "dd", playerid, cinc[playerid]);
    }
    else 
    {
        AddVehicleComponent(vehicleid, componentid);
        
        // sideskirts and vents that have left and right side should be applied twice
        switch (componentid)
        {
            case 1007, 1027, 1030, 1039, 1040, 1051, 1052, 1062, 1063, 1071, 1072, 1094, 1099, 1101, 1102, 1107, 1120, 1121, 1124, 1137, 1142 .. 1145: AddVehicleComponent(vehicleid, componentid);
        }

        SetTimerEx("ShowTuningPurchase", 2500, false, "dd", playerid, cinc[playerid]);
    }

    SetPVarInt(playerid, "pTuningComponentID", componentid);
    return 1;
}

forward ShowTuningPurchase(playerid, ccinc);
public ShowTuningPurchase(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("ShowTuningPurchase");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    new part_name[16], part_str[22], part_code = 0;
    GetPVarString(playerid, "pTuningPart", part_name, sizeof part_name);

    if (!strcmp(part_name, "Izduvi")) 
    {
        part_str = "izduv";
        part_code = PART_EXHAUST;
    }
    else if (!strcmp(part_name, "Hauba")) 
    {
        part_str = "haubu";
        part_code = PART_HOOD;
    }
    else if (!strcmp(part_name, "Hidraulika")) 
    {
        part_str = "hidrauliku";
        part_code = PART_HYDRAULICS;
    }
    else if (!strcmp(part_name, "Svetla")) 
    {
        part_str = "svetla";
        part_code = PART_LIGHTS;
    }
    else if (!strcmp(part_name, "Krov")) 
    {
        part_str = "krov";
        part_code = PART_ROOF;
    }
    else if (!strcmp(part_name, "Sajtne")) 
    {
        part_str = "sajtne";
        part_code = PART_SIDESKIRTS;
    }
    else if (!strcmp(part_name, "Spojleri")) 
    {
        part_str = "spojler";
        part_code = PART_SPOILER;
    }
    else if (!strcmp(part_name, "Ventilacija")) 
    {
        part_str = "otvore za ventilaciju";
        part_code = PART_VENTS;
    }
    else if (!strcmp(part_name, "Felne")) 
    {
        part_str = "felne";
        part_code = PART_WHEELS;
    }
    else if (!strcmp(part_name, "Prednji branik")) 
    {
        part_str = "prednji branik";
        part_code = PART_BUMPER_F;
    }
    else if (!strcmp(part_name, "Zadnji branik")) 
    {
        part_str = "zadnji branik";
        part_code = PART_BUMPER_R;
    }
    else if (!strcmp(part_name, "Prednji bullbar")) 
    {
        part_str = "prednji bullbar";
        part_code = PART_BULLBAR_F;
    }
    else if (!strcmp(part_name, "Zadnji bullbar")) 
    {
        part_str = "zadnji bullbar";
        part_code = PART_BULLBAR_R;
    }
    else if (!strcmp(part_name, "Paintjob")) 
    {
        part_str = "paintjob";
        part_code = PART_PAINTJOB;
    }
    else if (!strcmp(part_name, "Nitro")) 
    {
        part_str = "nitro";
        part_code = PART_NITRO;
    }
    else if (!strcmp(part_name, "Neonke")) 
    {
        part_str = "neonke";
        part_code = PART_NEON;
    }
    else return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    SetPVarInt(playerid, "pTuningPartCode", part_code);
    SetPVarString(playerid, "pTuningPartText", part_str);

    if (!strcmp(part_name, "Neonke") && GetPVarInt(playerid, "pTuningComponentID") == NEON_LIGHT_INVALID) 
    {
        format(string_256, sizeof string_256, "{FFFFFF}Uklonili ste {FF9900}neonke {FFFFFF}sa svog automobila.\n\nCena ove modifikacije je {FF9900}$%d.\nDa li zelite da trajno uklonite neonke sa svog automobila?", GetPVarInt(playerid, "pTuningPrice"));
    }
    else 
    {
        format(string_256, sizeof string_256, "{FFFFFF}Postavili ste {FF9900}%s {FFFFFF}na svoj automobil.\n\nCena ovog dela je {FF9900}$%d.\nDa li zelite da kupite ovaj deo i trajno ga ostavite na svom automobilu?", part_str, GetPVarInt(playerid, "pTuningPrice"));
    }

    SPD(playerid, "tune3", DIALOG_STYLE_MSGBOX, "{FFFFFF}Placanje", string_256, "Kupi", "Odustani");

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward OnTuneLoad(playerid, idx, ccinc);
public OnTuneLoad(playerid, idx, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("OnTuneLoad");
    }

    if (!checkcinc(playerid, ccinc) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    switch (idx)
    {
        case 0:
        {
            new sDialog[135], part_name[15];

            for__loop (new i, j = cache_num_rows(); i != j; i++) 
            {
                cache_get_value(i, 0, part_name);

                strcat(sDialog, part_name);
                strcat(sDialog, "\n");
            }
                
            if (VehicleSupportsNitro(GetVehicleModel(GetPlayerVehicleID(playerid))))
                strcat(sDialog, "Nitro\n");

            if (VehicleSupportsNeonLights(GetVehicleModel(GetPlayerVehicleID(playerid))))
                strcat(sDialog, "Neonke\n");

            strcat(sDialog, "Promena boje\nUkloni tuning\nZavrsi tuning");
            
            SPD(playerid, "tune", DIALOG_STYLE_LIST, "Dostupni delovi", sDialog, "Izaberi", "Izadji");
        }
        case 1:
        {
            if (cache_num_rows())
            {
                new sDialog[135], sPartName[14], num_fields;
                cache_get_field_count(num_fields);
                
                for__loop (new i; i != num_fields; i++)
                {
                    cache_get_value(0, i, sPartName);

                    if (!isnull(sPartName))
                    {
                        strcat(sDialog, sPartName);
                        strcat(sDialog, "\n");
                    }
                }

                if (VehicleSupportsNitro(GetVehicleModel(GetPlayerVehicleID(playerid))))
                    strcat(sDialog, "Nitro\n");

                if (VehicleSupportsNeonLights(GetVehicleModel(GetPlayerVehicleID(playerid))))
                    strcat(sDialog, "Neonke\n");

                strcat(sDialog, "Promena boje\nUkloni tuning\nZavrsi tuning");
                
                SPD(playerid, "tune", DIALOG_STYLE_LIST, "Dostupni delovi", sDialog, "Izaberi", "Izadji");
                SetPVarInt(playerid, "pTuning_ColorOnly", 0);
            }
            else 
            {
                InfoMsg(playerid, "Nemamo delove za ovo vozilo, ali mozete promeniti boju.");
                SPD(playerid, "tuning_boja", DIALOG_STYLE_LIST, "{FFFFFF}Promena boje", "Boja 1\t$10000\nBoja 2\t$10000", "Dalje ", " Nazad");

                SetPVarInt(playerid, "pTuning_ColorOnly", 1);
            }
        }
        case 2:
        {
            static sDialog[716];
            new componentid, type[22];

            sDialog = "ID\tVrsta\tCena";
            
            for__loop (new i, j = cache_num_rows(); i != j; i++)
            {
                cache_get_value_int(i, 0, componentid);
                cache_get_value(i, 1, type);
                cache_get_value_index_int(i, 2, componentPriceList[playerid][i]);
                
                format(sDialog, sizeof sDialog, "%s\n%d\t%s\t$%d", sDialog, componentid, type, componentPriceList[playerid][i]);
            }
            
            if (componentid == 1087) strcat(sDialog, "\n ----\tUkloni hidrauliku");
            
            SPD(playerid, "tune2", DIALOG_STYLE_TABLIST_HEADERS, "Dostupni delovi", sDialog, "Postavi", "Nazad");
        }
    }
    return 1;
}

stock VehicleSupportsNitro(modelid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("VehicleSupportsNitro");
    }

    if(400 <= modelid <= 611)
    {
        return gTuningVehicleInfo[modelid - 400][t_nitro];
    }
    return 0;
}

stock VehicleSupportsNeonLights(modelid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("VehicleSupportsNeonLights");
    }

    new idx = modelid - 400;

    if(0 <= idx <= 211)
    {
        if(gTuningVehicleInfo[idx][t_neonOffset][POS_X] == 0.0 && gTuningVehicleInfo[idx][t_neonOffset][POS_Y] == 0.0 && gTuningVehicleInfo[idx][t_neonOffset][POS_Z] == 0.0)
        {
            return 0;
        }
        return 1;
    }
    return 0;
}

stock CancelPlayerTuning(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("CancelPlayerTuning");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    new Float:tuningEndPos[5][4] = 
    {
        {2513.9868, -1523.2061, 24.0138, 90.0},
        {2510.3936, -1551.5875, 23.7369, 0.0},
        {2510.3645, -1543.0613, 23.7369, 0.0},
        {2506.3083, -1551.1528, 23.7369, 0.0},
        {2506.2322, -1542.2268, 23.7369, 0.0}
    };
    new rand = random(sizeof tuningEndPos);

    SetPlayerVirtualWorld(playerid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);
    SetVehicleZAngle(vehicleid, tuningEndPos[rand][POS_A]);
    SetVehiclePos(vehicleid, tuningEndPos[rand][POS_X], tuningEndPos[rand][POS_Y], tuningEndPos[rand][POS_Z]);
    SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    TogglePlayerControllable_H(playerid, true);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CancelVehiclePainting(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    SetPlayerVirtualWorld(playerid, 0);
    SetVehicleVirtualWorld(vehicleid, 0);
    SetVehicleZAngle(vehicleid, 270.0);
    SetVehiclePos(vehicleid, 1950.5216,-1978.8827,13.2739);
    SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
    TogglePlayerControllable_H(playerid, true);
    SetCameraBehindPlayer(playerid);
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:tune(playerid, response, listitem, const inputtext[]) 
{
    new 
        vehicleid = GetPlayerVehicleID(playerid),
        modelid = GetVehicleModel(vehicleid);

    if (!response || !strcmp(inputtext, "Zavrsi tuning")) 
    {
        CancelPlayerTuning(playerid);
        return 1;
    }

    if (!strcmp(inputtext, "Ukloni tuning"))
    {
        SPD(playerid, "tuning_remove", DIALOG_STYLE_MSGBOX, "{FFFFFF}Ukloni tuning", "{FFFFFF}Uklanjanje tuninga kosta $10.000.", "Ukloni", " Nazad");

        return 1;
    }

    if (!strcmp(inputtext, "Promena boje"))
    {
        ErrorMsg(playerid, "Promena boje se moze izvrsiti u auto lakirnici. Koristite /gps da saznate lokaciju.");
        return ShowTuningDialog(playerid, cinc[playerid]);
    }

    /*if (!strcmp(inputtext, "Paintjob")) 
    {
        switch (modelid) 
        { 
            case 483: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad");
            case 575: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nPaintjob ID: 1\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad");
            case 534 .. 536, 558 .. 562, 565, 567, 576: SPD(playerid, "tune_paintjob", DIALOG_STYLE_TABLIST, "Izaberite paintjob", "Paintjob ID: 0\t$30000\nPaintjob ID: 1\t$30000\nPaintjob ID: 2\t$30000\nIzbrisi paintjob\t$10000", "Izaberi", "Nazad");
            default: ErrorMsg(playerid, "Nema dostupnog paintjob-a za ovo vozilo.");
        }
        return 1;
    }*/

    if (!strcmp(inputtext, "Nitro")) 
    {
        SetPVarInt(playerid, "pTuningPrice", NITRO_PRICE); // Nitro cena
        SetPVarString(playerid, "pTuningPart", "Nitro");

        new Float:fromPos[3], Float:toPos[3];
        GetPlayerCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z]);
        toPos[POS_X] = 2521.6316, toPos[POS_Y] = -1532.8058, toPos[POS_Z] = 27.9365;

        if (fromPos[POS_X] != toPos[POS_X] && fromPos[POS_Y] != toPos[POS_Y] && fromPos[POS_Z] != toPos[POS_Z]) 
        {
            InterpolateCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z], toPos[POS_X], toPos[POS_Y], toPos[POS_Z], 1000, CAMERA_MOVE);
            InterpolateCameraLookAt(playerid, 2521.7664, -1525.6021, 25.1485, 2521.7664, -1525.6021, 25.1485, 1000, CAMERA_MOVE);
            SetTimerEx("SetVehicleComponent", 1250, false, "ddd", playerid, 1010, cinc[playerid]);
        }
        else SetTimerEx("SetVehicleComponent", 200, false, "ddd", playerid, 1010, cinc[playerid]);

        return 1;
    }

    if (!strcmp(inputtext, "Neonke")) 
    {
        new str[140], priceStr[9];
        format(priceStr, sizeof priceStr, "%s", formatMoneyString(NEON_PRICE));
        format(str, sizeof str, "Crvena\t%s\nPlava\t%s\nZelena\t%s\nZuta\t%s\nPink\t%s\nBela\t%s\nUkloni neonke\t%s", priceStr, priceStr, priceStr, priceStr, priceStr, priceStr, formatMoneyString(NEON_REMOVAL_PRICE));

        return SPD(playerid, "tune_neonLights", DIALOG_STYLE_TABLIST, "{FFFFFF}Izaberite boju neonke", str, "Izaberi", "Nazad");
    }


    switch (modelid)
    {
        case 534 .. 536, 558 .. 562, 565, 567, 575, 576:
        {
            if (!strcmp(inputtext, "Felne") || !strcmp(inputtext, "Hidraulika"))
            {
                new Query[105];
                
                mysql_format(SQL, Query, sizeof Query, "SELECT componentid,type,price FROM vehicle_components WHERE part='%s' ORDER BY type", inputtext);
                mysql_tquery(SQL, Query, "OnTuneLoad", "iii", playerid, 2, cinc[playerid]);
            }
            else
            {
                new Query[119];
                
                mysql_format(SQL, Query, sizeof Query, "SELECT componentid,type,price FROM vehicle_components WHERE cars=%i AND part='%s' ORDER BY type", modelid, inputtext);
                mysql_tquery(SQL, Query, "OnTuneLoad", "iii", playerid, 2, cinc[playerid]);
            }
        }
        default:
        {
            new Query[107];
            
            mysql_format(SQL, Query, sizeof Query, "SELECT componentid,type,price FROM vehicle_components WHERE cars<=0 AND part='%s' ORDER BY type", inputtext);
            mysql_tquery(SQL, Query, "OnTuneLoad", "iii", playerid, 2, cinc[playerid]);
        }
    }

    SetPVarString(playerid, "pTuningPart", inputtext);
    
    return 1;
}

Dialog:tune2(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return ShowTuningDialog(playerid, cinc[playerid]);

    new componentid;
    if (sscanf(inputtext, "i", componentid)) 
    {
        RemoveVehicleComponent(GetPlayerVehicleID(playerid), 1087);
        ShowTuningDialog(playerid, cinc[playerid]);
        return 1;
    }
    SetPVarInt(playerid, "pTuningPrice", componentPriceList[playerid][listitem]);

    new part_name[16], Float:fromPos[3], Float:toPos[3];
    GetPVarString(playerid, "pTuningPart", part_name, sizeof part_name);
    GetPlayerCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z]);

    if (!strcmp(part_name, "Izduvi") || !strcmp(part_name, "Zadnji bullbar") || !strcmp(part_name, "Spojleri") || !strcmp(part_name, "Zadnji branik"))
    {
        toPos[POS_X] = 2521.6316, toPos[POS_Y] = -1532.8058, toPos[POS_Z] = 25.9365;
    }
    else if (!strcmp(part_name, "Prednji bullbar") || !strcmp(part_name, "Hauba") || !strcmp(part_name, "Svetla") || !strcmp(part_name, "Prednji branik") || !strcmp(part_name, "Krov") || !strcmp(part_name, "Ventilacija"))
    {
        toPos[POS_X] = 2521.8118, toPos[POS_Y] = -1520.2231, toPos[POS_Z] = 25.9545;
    }
    else if (!strcmp(part_name, "Felne"))
    {
        toPos[POS_X] = 2525.8142, toPos[POS_Y] = -1522.0583, toPos[POS_Z] = 25.9416;
    }
    else if (!strcmp(part_name, "Sajtne"))
    {
        toPos[POS_X] = 2517.1199, toPos[POS_Y] = -1526.0251, toPos[POS_Z] = 25.8554;
    }
    else if (!strcmp(part_name, "Hidraulika"))
    {
        toPos[POS_X] = 2525.4475, toPos[POS_Y] = -1518.0490, toPos[POS_Z] = 25.9178;
    }
    

    if (fromPos[POS_X] != toPos[POS_X] && fromPos[POS_Y] != toPos[POS_Y] && fromPos[POS_Z] != toPos[POS_Z]) {
        InterpolateCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z], toPos[POS_X], toPos[POS_Y], toPos[POS_Z], 1000, CAMERA_MOVE);
        InterpolateCameraLookAt(playerid, 2521.7664, -1525.6021, 25.1485, 2521.7664, -1525.6021, 25.1485, 1000, CAMERA_MOVE);
        SetTimerEx("SetVehicleComponent", 1250, false, "ddd", playerid, componentid, cinc[playerid]);
    }
    else SetTimerEx("SetVehicleComponent", 200, false, "ddd", playerid, componentid, cinc[playerid]);

    return 1;
}

Dialog:tune3(playerid, response, listitem, const inputtext[]) 
{
    new 
        vehicleid   = GetPlayerVehicleID(playerid),
        id          = GetPVarInt(playerid, "pTuningVehID"),
        part_code   = GetPVarInt(playerid, "pTuningPartCode"),
        part_price  = GetPVarInt(playerid, "pTuningPrice"),
        componentid = GetPVarInt(playerid, "pTuningComponentID"),
        part_text[24],
        part_group[16]
    ;
    GetPVarString(playerid, "pTuningPartText", part_text, sizeof part_text);
    GetPVarString(playerid, "pTuningPart", part_group, sizeof part_group);

    if (!response) // Odustao
    {
        if (componentid <= 3) 
        {
            ChangeVehiclePaintjob(vehicleid, 3);
            SetPVarInt(playerid, "RadiPaintJob", 0);
            ShowPaintingDialog(playerid);
        }
        else if (componentid > 18000) 
        {
            if (componentid == NEON_LIGHT_INVALID) // Odustao od uklanjanja postojecih neonki
            {
                Vehicle_SetNeonLights(id, true, GetPVarInt(playerid, "pTuningNeon"));
            }
            else // Odustao od postavljanja novih neonki
            {
                for__loop (new i = 0; i < 2; i++) 
                {
                    if (IsValidDynamicObject(pNeonLightObj[playerid][i]))
                        DestroyDynamicObject(pNeonLightObj[playerid][i]), pNeonLightObj[playerid][i] = -1;
                }
            }
        }
        else RemoveVehicleComponent(vehicleid, GetPVarInt(playerid, "pTuningComponentID"));

        new Float:tuningEndPos[5][4] = 
        {
            {2513.9868, -1523.2061, 24.0138, 90.0},
            {2510.3936, -1551.5875, 23.7369, 0.0},
            {2510.3645, -1543.0613, 23.7369, 0.0},
            {2506.3083, -1551.1528, 23.7369, 0.0},
            {2506.2322, -1542.2268, 23.7369, 0.0}
        };
        new rand = random(sizeof tuningEndPos);

        SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        SetVehicleZAngle(vehicleid, tuningEndPos[rand][POS_A]);
        SetVehiclePos(vehicleid, tuningEndPos[rand][POS_X], tuningEndPos[rand][POS_Y], tuningEndPos[rand][POS_Z]); // fixed by daddyDOT 18.5.2022. (problem: portalo do lakirnice umjesto ispred tuning radnje)
        SetVehicleParamsEx(vehicleid, 1, 1, 0, 0, 0, 0, 0);
        TogglePlayerControllable_H(playerid, true);
        SetCameraBehindPlayer(playerid);
    }
    else // Kupuje
    {
        if (PI[playerid][p_novac] >= part_price) 
        {

            if (!(OwnedVehicle[id][V_COMPONENTS] & part_code)) // Komponenta ne postoji -> dodaj
                OwnedVehicle[id][V_COMPONENTS] |= part_code;

            new slot = -1;
            for__loop (new i = 0; i < 12; i++) // Prvo gledamo da li vec ima komponentu iste vrste
            {
                if (VehicleComponents[id][i][V_PART_ID] == part_code) 
                {
                    slot = i;
                    VehicleComponents[id][i][V_COMPONENT_ID] = componentid;
                    VehicleComponents[id][i][V_PART_ID] = part_code;
                    break;
                }
            }
            if (slot == -1) // Ako komp. ne postoji vec na autu, onda trazimo slobodan slot
            {
                for__loop (new i = 0; i < 12; i++) 
                {
                    if (VehicleComponents[id][i][V_PART_ID] == -1) 
                    {
                        slot = i;
                        VehicleComponents[id][i][V_COMPONENT_ID] = componentid;
                        VehicleComponents[id][i][V_PART_ID] = part_code;
                        break;
                    }
                }
            }
            if (slot == -1) return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nema slotova)");

            if (componentid > 18000) 
            {
                for__loop (new i = 0; i < 2; i++) 
                {
                    if (IsValidDynamicObject(pNeonLightObj[playerid][i]))
                        DestroyDynamicObject(pNeonLightObj[playerid][i]), pNeonLightObj[playerid][i] = -1;
                }
                Vehicle_SetNeonLights(id, true, componentid);
            }

            PlayerMoneySub(playerid, part_price);
            re_firma_dodaj_novac(re_globalid(firma, TUNING_FIRMA_ID), part_price);
            SendClientMessageF(playerid, NARANDZASTA, "(tuning) {FFFFFF}Montirali ste {FF9900}%s {FFFFFF}na svoj automobil za {FF9900}%s", part_text, formatMoneyString(part_price));

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO vozila_komponente VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE componentid = %d", id, componentid, part_code, componentid);
            mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

            format(string_128, sizeof string_128, "Veh: %d | Component: %d | Part: %s | Price: $%d", id, componentid, part_group, part_price);
            Log_Write(LOG_TUNING, string_128);
            if(GetPVarInt(playerid, "RadiPaintJob") == 0) SetTimerEx("ShowTuningDialog", 650, false, "dd", playerid, cinc[playerid]);
            else if(GetPVarInt(playerid, "RadiPaintJob") == 1)
            {
                SetPVarInt(playerid, "RadiPaintJob", 0);
                ShowPaintingDialog(playerid);
                return 1;    
            }
        }
        else ErrorMsg(playerid, "Nemate dovoljno novca.");

    }
    //return SetTimerEx("ShowTuningDialog", 650, false, "dd", playerid, cinc[playerid]);
    return 1;
}


Dialog:tunepaintjob(playerid, response, listitem, const inputtext[]) 
{
    new 
        vehicleid   = GetPlayerVehicleID(playerid),
        id          = GetPVarInt(playerid, "pTuningVehID"),
        part_code   = GetPVarInt(playerid, "pTuningPartCode"),
        part_price  = GetPVarInt(playerid, "pTuningPrice"),
        componentid = GetPVarInt(playerid, "pTuningComponentID"),
        part_text[24],
        part_group[16]
    ;
    GetPVarString(playerid, "pTuningPartText", part_text, sizeof part_text);
    GetPVarString(playerid, "pTuningPart", part_group, sizeof part_group);

    if (!response) // Odustao
    {
        if (componentid <= 3) 
        {
            ChangeVehiclePaintjob(vehicleid, 3);
            SetPVarInt(playerid, "RadiPaintjob", 0);
            CancelVehiclePainting(playerid); //tutu
        }
    }
    else // Kupuje
    {
        if (PI[playerid][p_novac] >= part_price) 
        {
            if (!(OwnedVehicle[id][V_COMPONENTS] & part_code)) // Komponenta ne postoji -> dodaj
                OwnedVehicle[id][V_COMPONENTS] |= part_code;

            new slot = -1;
            for__loop (new i = 0; i < 12; i++) // Prvo gledamo da li vec ima komponentu iste vrste
            {
                if (VehicleComponents[id][i][V_PART_ID] == part_code) 
                {
                    slot = i;
                    VehicleComponents[id][i][V_COMPONENT_ID] = componentid;
                    VehicleComponents[id][i][V_PART_ID] = part_code;
                    break;
                }
            }
            if (slot == -1) // Ako komp. ne postoji vec na autu, onda trazimo slobodan slot
            {
                for__loop (new i = 0; i < 12; i++) 
                {
                    if (VehicleComponents[id][i][V_PART_ID] == -1) 
                    {
                        slot = i;
                        VehicleComponents[id][i][V_COMPONENT_ID] = componentid;
                        VehicleComponents[id][i][V_PART_ID] = part_code;
                        break;
                    }
                }
            }
            if (slot == -1) return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nema slotova)");

            if (componentid > 18000) 
            {
                for__loop (new i = 0; i < 2; i++) 
                {
                    if (IsValidDynamicObject(pNeonLightObj[playerid][i]))
                        DestroyDynamicObject(pNeonLightObj[playerid][i]), pNeonLightObj[playerid][i] = -1;
                }
                Vehicle_SetNeonLights(id, true, componentid);
            }

            PlayerMoneySub(playerid, part_price);
            re_firma_dodaj_novac(re_globalid(firma, TUNING_FIRMA_ID), part_price);
            SendClientMessageF(playerid, NARANDZASTA, "(tuning) {FFFFFF}Montirali ste {FF9900}%s {FFFFFF}na svoj automobil za {FF9900}%s", part_text, formatMoneyString(part_price));

            format(mysql_upit, sizeof mysql_upit, "INSERT INTO vozila_komponente VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE componentid = %d", id, componentid, part_code, componentid);
            mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->

            format(string_128, sizeof string_128, "Veh: %d | Component: %d | Part: %s | Price: $%d", id, componentid, part_group, part_price);
            Log_Write(LOG_TUNING, string_128);
        }
        else ErrorMsg(playerid, "Nemate dovoljno novca.");

    }
    return SetTimerEx("ShowTuningDialog", 650, false, "dd", playerid, cinc[playerid]);
}

Dialog:tuning_remove(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        ShowTuningDialog(playerid, cinc[playerid]);
    }
    else
    {
        if (PI[playerid][p_novac] < 10000)
        {
            ShowTuningDialog(playerid, cinc[playerid]);
            return ErrorMsg(playerid, "Nemate dovoljno novca.");
        }

        new 
            vehicleid = GetPlayerVehicleID(playerid),
            id        = GetPVarInt(playerid, "pTuningVehID")
        ;

        if (OwnedVehicle[id][V_COMPONENTS] == 0)
        {
            ShowTuningDialog(playerid, cinc[playerid]);
            return ErrorMsg(playerid, "Ovo vozilo nije tunirano.");
        } 
        
        for__loop (new i = 0; i < 12; i++) 
        {
            if (VehicleComponents[id][i][V_PART_ID] == -1) continue;

            if (VehicleComponents[id][i][V_COMPONENT_ID] >= 0 && VehicleComponents[id][i][V_COMPONENT_ID] <= 2) // Paintjob
            {
                ChangeVehiclePaintjob(vehicleid, 3);
            }
            else if (VehicleComponents[id][i][V_COMPONENT_ID] < 18000)
            {
                RemoveVehicleComponent(vehicleid, VehicleComponents[id][i][V_COMPONENT_ID]);
            }

            VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;
        }

        OwnedVehicle[id][V_COMPONENTS] = 0;
        

        PlayerMoneySub(playerid, 10000);
        re_firma_dodaj_novac(re_globalid(firma, TUNING_FIRMA_ID), 10000);

        new sQuery[50];
        format(sQuery, sizeof sQuery, "DELETE FROM vozila_komponente WHERE v_id = %i", id);
        mysql_tquery(SQL, sQuery);

        ShowTuningDialog(playerid, cinc[playerid]);
    }
    return 1;
}

Dialog:lakirnica_boja(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
    {
        return CancelVehiclePainting(playerid);
    }

    SetPVarInt(playerid, "pTuningColorSlot", listitem+1);
    ptdColors_Show(playerid);
    return 1;
}

Dialog:tune_paintjob(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
        return SPD(playerid, "lakirnica", DIALOG_STYLE_LIST, "{FFFFFF}Promena boje", "Promena boje\nPaintjob", "Dalje", "Zavrsi");

    new paintjobid;
    if (!sscanf(inputtext, "'Paintjob ID: 'i", paintjobid)) 
    {
        SetPVarInt(playerid, "pTuningPrice", 30000);
    }
    else 
    {
        paintjobid = 3;
        SetPVarInt(playerid, "pTuningPrice", 10000);
    }

    SetPVarString(playerid, "pTuningPart", "Paintjob");
    SetTimerEx("SetVehicleComponent", 200, false, "ddd", playerid, paintjobid, cinc[playerid]);
    return 1;
}

Dialog:tune_neonLights(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
        return ShowTuningDialog(playerid, cinc[playerid]);

    SetPVarInt(playerid, "pTuningPrice", NEON_PRICE);

    new neonLightId, Float:fromPos[3], Float:toPos[3];
    SetPVarString(playerid, "pTuningPart", "Neonke");
    GetPlayerCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z]);
    toPos[POS_X] = 2525.4475, toPos[POS_Y] = -1518.0490, toPos[POS_Z] = 25.9178;

    switch (listitem) {
        case 0: neonLightId = NEON_LIGHT_RED;
        case 1: neonLightId = NEON_LIGHT_BLUE;
        case 2: neonLightId = NEON_LIGHT_GREEN;
        case 3: neonLightId = NEON_LIGHT_YELLOW;
        case 4: neonLightId = NEON_LIGHT_PINK;
        case 5: neonLightId = NEON_LIGHT_WHITE;
        case 6: neonLightId = NEON_LIGHT_INVALID;
    }

    if (fromPos[POS_X] != toPos[POS_X] && fromPos[POS_Y] != toPos[POS_Y] && fromPos[POS_Z] != toPos[POS_Z]) {
        InterpolateCameraPos(playerid, fromPos[POS_X], fromPos[POS_Y], fromPos[POS_Z], toPos[POS_X], toPos[POS_Y], toPos[POS_Z], 1000, CAMERA_MOVE);
        InterpolateCameraLookAt(playerid, 2521.7664, -1525.6021, 25.1485, 2521.7664, -1525.6021, 25.1485, 1000, CAMERA_MOVE);
        SetTimerEx("SetVehicleComponent", 1250, false, "ddd", playerid, neonLightId, cinc[playerid]);
    }
    else SetTimerEx("SetVehicleComponent", 200, false, "ddd", playerid, neonLightId, cinc[playerid]);
    return 1;
}

// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:tuningpass(FLAG_ADMIN_6)
CMD:tuningpass(playerid, const params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "tuningpass [Ime ili ID igraca]");

    if (!IsPlayerConnected(targetid) || !IsPlayerLoggedIn(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    PI[targetid][p_tuning_pass] ++;

    new sQuery[57];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET tuning_pass = %i WHERE id = %i", PI[targetid][p_tuning_pass], PI[targetid][p_id]);
    mysql_tquery(SQL, sQuery);

    SendClientMessageF(playerid, SVETLOPLAVA, "* Urucio si vaucer za specijalni tuning igracu {FFFFFF}%s[%i].", ime_rp[targetid], targetid);
    SendClientMessageF(targetid, SVETLOPLAVA, "* Head Admin %s ti je urucio vaucer za specijalni tuning.", ime_rp[playerid]);
    return 1;
}