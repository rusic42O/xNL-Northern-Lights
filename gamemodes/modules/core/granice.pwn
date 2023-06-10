#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_GRANICE_DATA
{
    GRANICE_LS_LV = 0,
    GRANICE_LV_LS,

    GRANICE_LS_SF,
    GRANICE_SF_LS,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    GRANICE_Actor[E_GRANICE_DATA],
    GRANICE_Ramp[E_GRANICE_DATA],
    GRANICE_Zona[E_GRANICE_DATA],
    bool:GRANICE_RampInUse[E_GRANICE_DATA]
;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    // LS/LV
    GRANICE_Ramp[GRANICE_LS_LV]  = CreateDynamicObjectEx(968, 1802.680053, 810.116333, 10.673389, 0.000001, -90.000061, 179.999511, 750.00, 750.00, {0}); 
    GRANICE_Ramp[GRANICE_LV_LS]  = CreateDynamicObjectEx(968, 1791.312988, 798.105895, 10.893391, 0.000000, -90.000000, 0.000000, 750.00, 750.00, {0}); 
    GRANICE_Actor[GRANICE_LS_LV] = CreateDynamicActor(280, 1800.4644,798.4709,11.1570,270.0, 1, 100.0, 0, 0, -1);
    GRANICE_Actor[GRANICE_LV_LS] = CreateDynamicActor(282, 1793.6024,809.2614,10.9564,90.0, 1, 100.0, 0, 0, -1);
    GRANICE_Zona[GRANICE_LS_LV]  = CreateDynamicRectangle(1796.1954,787.1987, 1816.0188,812.8604);
    GRANICE_Zona[GRANICE_LV_LS]  = CreateDynamicRectangle(1777.8865,795.7766, 1797.0817,813.6616);

    // LS/SF
    GRANICE_Ramp[GRANICE_LS_SF]  = CreateDynamicObjectEx(968, 54.424346, -1528.413208, 4.824265, 0.000014, 90.000000, 83.999992, 750.00, 750.00, {0}); 
    GRANICE_Ramp[GRANICE_SF_LS]  = CreateDynamicObjectEx(968, 48.494323, -1535.413940, 4.834265, 0.000000, -90.000000, 83.200035, 750.00, 750.00, {0}); 
    GRANICE_Actor[GRANICE_LS_SF] = CreateDynamicActor(280, 60.7358,-1530.6447,5.1867,350.7383, 1, 100.0, 0, 0, -1);
    GRANICE_Actor[GRANICE_SF_LS] = CreateDynamicActor(281, 41.6820,-1532.3406,5.3830,164.9299, 1, 100.0, 0, 0, -1);
    GRANICE_Zona[GRANICE_LS_SF]  = CreateDynamicRectangle(52.0710,-1529.7073, 71.6615,-1519.4777);
    GRANICE_Zona[GRANICE_SF_LS]  = CreateDynamicRectangle(34.7527,-1542.7739, 50.8480,-1533.7585);

    GRANICE_RampInUse[GRANICE_LS_LV] = false;
    GRANICE_RampInUse[GRANICE_LV_LS] = false;
    GRANICE_RampInUse[GRANICE_LS_SF] = false;
    GRANICE_RampInUse[GRANICE_SF_LS] = false;

    #pragma unused GRANICE_Actor
    return true;
}


hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == GRANICE_Zona[GRANICE_LS_LV] || areaid == GRANICE_Zona[GRANICE_LV_LS] || areaid == GRANICE_Zona[GRANICE_LS_SF] || areaid == GRANICE_Zona[GRANICE_SF_LS])
    {
        if (DebugFunctions())
        {
            LogCallbackExec("granice.pwn", "OnPlayerEnterDynArea");
        }

        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || GetPlayerVirtualWorld(playerid) != 0 || IsPlayerInRace(playerid)) return ~1;

        new 
            // string[165],
            string[242],
            vehicleid = GetPlayerVehicleID(playerid),
            Float:X, Float:Y, Float:Z;

        GetVehicleVelocity(vehicleid, X, Y, Z);
        SetVehicleVelocity(vehicleid, X/6, Y/6, Z/6);

        format(string, sizeof string, "{FFFFFF}Dosli ste na {FF9900}granicni prelaz.\n{FFFFFF}Za prelazak granice neophodno je da svi putnici u vozilu imaju {FF9900}vazeci pasos.\n\n{FFFFFF}Carinik ce pregledati pasose, a onda cete moci da predjete granicu ukoliko je sve u redu.");
        SPD(playerid, "granica", DIALOG_STYLE_MSGBOX, "{FFFFFF}Granicni prelaz", string, "Nastavi", "Odustani");

        if (IsPlayerInDynamicArea(playerid, GRANICE_Zona[GRANICE_LS_LV]))
        {
            SetPVarInt(playerid, "GRANICE_rampID", GRANICE_Ramp[GRANICE_LS_LV]);
            SetPVarInt(playerid, "GRANICE_zone", GRANICE_Zona[GRANICE_LS_LV]);
            SetPVarString(playerid, "GRANICE_str", "LS-LV");
        }
        else if (IsPlayerInDynamicArea(playerid, GRANICE_Zona[GRANICE_LV_LS]))
        {
            SetPVarInt(playerid, "GRANICE_rampID", GRANICE_Ramp[GRANICE_LV_LS]);
            SetPVarInt(playerid, "GRANICE_zone", GRANICE_Zona[GRANICE_LV_LS]);
            SetPVarString(playerid, "GRANICE_str", "LV-LS");
        }
        else if (IsPlayerInDynamicArea(playerid, GRANICE_Zona[GRANICE_LS_SF]))
        {
            SetPVarInt(playerid, "GRANICE_rampID", GRANICE_Ramp[GRANICE_LS_SF]);
            SetPVarInt(playerid, "GRANICE_zone", GRANICE_Zona[GRANICE_LS_SF]);
            SetPVarString(playerid, "GRANICE_str", "LS-SF");
        }
        else if (IsPlayerInDynamicArea(playerid, GRANICE_Zona[GRANICE_SF_LS]))
        {
            SetPVarInt(playerid, "GRANICE_rampID", GRANICE_Ramp[GRANICE_SF_LS]);
            SetPVarInt(playerid, "GRANICE_zone", GRANICE_Zona[GRANICE_SF_LS]);
            SetPVarString(playerid, "GRANICE_str", "SF-LS");
        }
        else ErrorMsg(playerid, "[granice.pwn] "GRESKA_NEPOZNATO "(01)");
        return ~1;
    }
    return 1;
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (GetPVarInt(playerid, "GRANICE_zone") == areaid && GetPVarInt(playerid, "GRANICE_paid") == 1)
    {
        if (DebugFunctions())
        {
            LogCallbackExec("granice.pwn", "OnPlayerLeaveDynArea");
        }
        
        DeletePVar(playerid, "GRANICE_zone");
        DeletePVar(playerid, "GRANICE_paid");

        if (areaid == GRANICE_Zona[GRANICE_LS_LV])
        {
            MoveDynamicObject(GRANICE_Ramp[GRANICE_LS_LV], 1802.680053, 810.116333, 10.673389, 0.005, 0.000001, -90.000061, 179.999511);
            GRANICE_RampInUse[GRANICE_LS_LV] = false;
        }
        else if (areaid == GRANICE_Zona[GRANICE_LV_LS])
        {
            MoveDynamicObject(GRANICE_Ramp[GRANICE_LV_LS], 1791.312988, 798.105895, 10.893390, 0.005, 0.000000, -90.000000, 0.000000);
            GRANICE_RampInUse[GRANICE_LV_LS] = false;
        }
        else if (areaid == GRANICE_Zona[GRANICE_LS_SF])
        {
            MoveDynamicObject(GRANICE_Ramp[GRANICE_LS_SF], 54.424346, -1528.413208, 4.824265-0.005, 0.005, 0.000014, 90.000000, 83.999992);
            GRANICE_RampInUse[GRANICE_LS_SF] = false;
        }
        else if (areaid == GRANICE_Zona[GRANICE_SF_LS])
        {
            MoveDynamicObject(GRANICE_Ramp[GRANICE_SF_LS], 48.494323, -1535.413940, 4.834265-0.005, 0.005, 0.000000, -90.000000, 83.200035);
            GRANICE_RampInUse[GRANICE_SF_LS] = false;
        }
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock CheckPassport_Login(playerid)
{
    if (PI[playerid][p_pasos_ts] > 0 && PI[playerid][p_pasos_ts] < gettime())
    {
        SendClientMessage(playerid, TAMNOCRVENA, "Vas {FF9900}pasos {880000}je istekao. Obnovite ga kako biste mogli da putujete van Los Santosa.");
    }
}

forward OnPlayerIssuedPassport(playerid, ccinc);
public OnPlayerIssuedPassport(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("OnPlayerIssuedPassport");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (rows != 1) return 1;

    cache_get_value_index(0, 0, PI[playerid][p_pasos], 11);
    cache_get_value_index_int(0, 1, PI[playerid][p_pasos_ts]);

    SendClientMessageF(playerid, NARANDZASTA, "(pasos) {FFFFFF}Dobili ste novi pasos. Datum isteka: {FF9900}%s", PI[playerid][p_pasos]);
    return 1;
}

forward PassportCheck(playerid, ccinc);
public PassportCheck(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PassportCheck");
    }

    if (!checkcinc(playerid, ccinc)) return 1;
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

    new invalidPassports = 0,
        vehicleid = GetPlayerVehicleID(playerid);

    foreach (new i : Player)
    {
        if (GetPlayerVehicleID(i) == vehicleid)
        {
            if (PI[i][p_pasos_ts] < gettime())
            {
                invalidPassports ++;
            }
        }
    }

    if (invalidPassports == 0)
    {
        dialog_respond:granica2(playerid, 1, 0, "Plati");
    }
    else
    {
        // Postoje nevazeci pasosi
        new passengers = CountVehiclePassengers(vehicleid);
        if (passengers == 0)
        {
            SPD(playerid, "granica2", DIALOG_STYLE_MSGBOX, "{FFFFFF}Granicni prelaz", "{FFFFFF}Prilikom pasoske kontrole utvrdjeno je da imate {FF0000}nevazeci pasos.\n{FFFFFF}Mozete preci granicu uz placanje kazne od {FF0000}$15.000.", "Plati", "Odustani");
        }
        else
        {
            new string[200];
            format(string, sizeof string, "{FFFFFF}Prilikom pasoske kontrole utvrdjeno je da u Vasem vozilu postoji {FF0000}%i nevazecih pasosa.\n{FFFFFF}Mozete preci granicu uz placanje kazne od {FF0000}%s", invalidPassports, formatMoneyString(invalidPassports*15000));
            SPD(playerid, "granica2", DIALOG_STYLE_MSGBOX, "{FFFFFF}Granicni prelaz", string, "Plati", "Odustani");
        }

        SetPVarInt(playerid, "GRANICE_price", invalidPassports*15000);
    }
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:pasos(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new passportPrice = GetPVarInt(playerid, "pPassportPrice"),
            h, m, s;


        if (PI[playerid][p_novac] < passportPrice)
            return ErrorMsg(playerid, "Nemate dovoljno novca.");

        gettime(h, m, s);
        PI[playerid][p_pasos] = gettime() + 2592000 + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih 30 dana, pa jos do kraja sledeceg dana

        PlayerMoneySub(playerid, passportPrice);

        new query[115];
        format(query, sizeof query, "UPDATE igraci SET pasos = FROM_UNIXTIME(%i) WHERE id = %i", PI[playerid][p_pasos], PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        format(query, sizeof query, "SELECT DATE_FORMAT(pasos, '\%%d/\%%m/\%%Y') as pasos1, UNIX_TIMESTAMP(pasos) as pasos_ts FROM igraci WHERE id = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, query, "OnPlayerIssuedPassport", "ii", playerid, cinc[playerid]);
    }
    DeletePVar(playerid, "pPassportPrice");
    return 1;
}

Dialog:granica(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SendClientMessage(playerid, NARANDZASTA, "(granica) {FFFFFF}Pregled pasosa je u toku, molimo sacekajte...");
        TogglePlayerControllable_H(playerid, false);
        SetTimerEx("PassportCheck", 6000, false, "ii", playerid, cinc[playerid]);
    }
    else
    {
        DeletePVar(playerid, "GRANICE_price");
        DeletePVar(playerid, "GRANICE_rampID");
        DeletePVar(playerid, "GRANICE_str");
        DeletePVar(playerid, "GRANICE_paid");
    }
    return 1;
}

Dialog:granica2(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new 
            granica[6],
            vehicleid = GetPlayerVehicleID(playerid),
            rampid = GetPVarInt(playerid, "GRANICE_rampID"),
            price = GetPVarInt(playerid, "GRANICE_price");

        GetPVarString(playerid, "GRANICE_str", granica, sizeof granica);
        DeletePVar(playerid, "GRANICE_price");
        DeletePVar(playerid, "GRANICE_rampID");
        DeletePVar(playerid, "GRANICE_str");

        TogglePlayerControllable_H(playerid, true);


        if (IsPlayerWanted(playerid))
        {
            DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: Prijavio: pogranicna policija (%s).", granica);
            DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Zlocin: ilegalni prelazak granice, Pocinio: %s [N: %d]", ime_rp[playerid], GetPlayerCrimeLevel(playerid));
            ErrorMsg(playerid, "Trazeni ste, ne mozete preci granicu. Policija je obavestena o Vasoj lokaciji!");
            return 1;
        }
        else
        {
            SendClientMessage(playerid, NARANDZASTA, "(granica) {FFFFFF}Uspesno ste prosli pasosku kontrolu, mozete nastaviti sa svojim putovanjem. Srecan put!");
            SetPVarInt(playerid, "GRANICE_price", 0);

            if (price > 0 && PI[playerid][p_novac] < price)
                return ErrorMsg(playerid, "Nemate dovoljno novca.");

            if (rampid == GRANICE_Ramp[GRANICE_LS_LV])
            {
                if (GRANICE_RampInUse[GRANICE_LS_LV])
                    return ErrorMsg(playerid, "Rampa je podignuta, sacekajte da se spusti.");

                GRANICE_RampInUse[GRANICE_LS_LV] = true;
                MoveDynamicObject(rampid, 1802.680053, 810.116333, 10.673389+0.005, 0.005, 0.000000, -0.000060, 179.999511);
            }
            else if (rampid == GRANICE_Ramp[GRANICE_LV_LS])
            {
                if (GRANICE_RampInUse[GRANICE_LV_LS])
                    return ErrorMsg(playerid, "Rampa je podignuta, sacekajte da se spusti.");

                GRANICE_RampInUse[GRANICE_LV_LS] = true;
                MoveDynamicObject(rampid, 1791.312988, 798.105895, 10.893390+0.005, 0.005, 0.000000, 0.000000, 0.000000);
            }
            else if (rampid == GRANICE_Ramp[GRANICE_LS_SF])
            {
                if (GRANICE_RampInUse[GRANICE_LS_SF])
                    return ErrorMsg(playerid, "Rampa je podignuta, sacekajte da se spusti.");

                GRANICE_RampInUse[GRANICE_LS_SF] = true;
                MoveDynamicObject(rampid, 54.424346, -1528.413208, 4.824265+0.005, 0.005, 0.000014, 0.000000, 83.999992);
            }
            else if (rampid == GRANICE_Ramp[GRANICE_SF_LS])
            {
                if (GRANICE_RampInUse[GRANICE_SF_LS])
                    return ErrorMsg(playerid, "Rampa je podignuta, sacekajte da se spusti.");

                GRANICE_RampInUse[GRANICE_SF_LS] = true;
                MoveDynamicObject(rampid, 48.494323, -1535.413940, 4.834265+0.005, 0.005, 0.000000, 0.000000, 83.200035);
            }
            else return ErrorMsg(playerid, "[granice.pwn] "GRESKA_NEPOZNATO "(03)");

            SetPVarInt(playerid, "GRANICE_paid", 1);
            if (price > 0) PlayerMoneySub(playerid, price);

            new string[60];
            format(string, sizeof string, "%s | %s | %i putnika | %s", granica, ime_obicno[playerid], CountVehiclePassengers(vehicleid), formatMoneyString(price));
            Log_Write(LOG_GRANICA, string);
        }
    }
    else
    {
        DeletePVar(playerid, "GRANICE_paid");
        DeletePVar(playerid, "GRANICE_price");
        DeletePVar(playerid, "GRANICE_rampID");
        DeletePVar(playerid, "GRANICE_str");
        TogglePlayerControllable_H(playerid, true);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pasos(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2592.6440,2602.5408,-97.9156))
        return ErrorMsg(playerid, "Ne nalazite se na mestu za vadjenje pasosa.");

    if (PI[playerid][p_pasos_ts] == 0) // Vadi pasos po prvi put
    {
        new passportPrice = 10000, str[271];
        if (PI[playerid][p_nivo] > 6)
        {
            passportPrice += 2000 * PI[playerid][p_nivo];
        }
        SetPVarInt(playerid, "pPassportPrice", passportPrice);
        format(str, sizeof str, "{FFFFFF}Vadjenjem pasosa dobijate validnu putnu ispravu, pomocu koje mozete neogranicen\nbroj puta prelaziti drzavnu granicu.\n\nTrajanje pasosa je {FF9900}30 dana {FFFFFF}od dana kada ga izvadite, a nakon isteka mora biti obnovljen.\nCena novog pasosa: {FF9900}%s", formatMoneyString(passportPrice));

        SPD(playerid, "pasos", DIALOG_STYLE_MSGBOX, "{FF9900}Vadjenje pasosa", str, "Prihvati", "Odustani");
    }
    else if (PI[playerid][p_pasos_ts] <= gettime()) // Ima pasos koji mu je istekao
    {
        new passportPrice = 10000 + (2000 * PI[playerid][p_nivo]), 
            str[275];
        SetPVarInt(playerid, "pPassportPrice", passportPrice);
        format(str, sizeof str, "{FFFFFF}Vas pasos je istekao {FF9900}%s.\n{FFFFFF}Morate obnoviti pasos kako biste mogli da prelazite drzavnu granicu.\n\nTrajanje pasosa je {FF9900}30 dana {FFFFFF}od dana kada ga izvadite, a nakon isteka mora biti obnovljen.\nCena novog pasosa: {FF9900}%s", PI[playerid][p_pasos], formatMoneyString(passportPrice));

        SPD(playerid, "pasos", DIALOG_STYLE_MSGBOX, "{FF9900}Obnova pasosa", str, "Prihvati", "Odustani");
    }
    else if (PI[playerid][p_pasos_ts] > gettime()) // Ima pasos koji nije istekao
    {
        new passportPrice = 10000 + (2000 * PI[playerid][p_nivo]), 
            str[220];
        SetPVarInt(playerid, "pPassportPrice", passportPrice);
        format(str, sizeof str, "{FFFFFF}Vas pasos jos uvek nije istekao (vazi do {FF9900}%s).\n{FFFFFF}Pasos je moguce obnoviti pre nego sto istekne, ali ce on trajati {FF9900}narednih 30 dana.\n{FFFFFF}Cena novog pasosa: {FF9900}%s", PI[playerid][p_pasos], formatMoneyString(passportPrice));

        SPD(playerid, "pasos", DIALOG_STYLE_MSGBOX, "{FF9900}Obnova pasosa", str, "Prihvati", "Odustani");
    }

    return 1;
}