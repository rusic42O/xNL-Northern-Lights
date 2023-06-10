#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_SPEED_CAMERAS
{
    Float:SPEED_CAMERA_POS[6],
    Text3D:SPEED_CAMERA_LABEL,
    SPEED_CAMERA_ACTIVE, // ID igraca koji je aktivirao radar (ili INVALID ako je neaktivan)
    SPEED_CAMERA_AREA,
    SPEED_CAMERA_AREA_PD
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    Text:tdSpeedCamera,
    gSpeedCamera_Reload[MAX_PLAYERS],
    gSpeedCamera_CaughtBy[MAX_PLAYERS char]
;    

static SpeedCameras[][E_SPEED_CAMERAS] = 
{
    {{1675.536621, -79.447166, 34.584918, 0.000000, 0.000000, -180.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{892.681884, -973.760559, 36.858760, 0.000000, 0.000000, -70.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1337.141113, -1233.327514, 12.468287, 0.000000, 0.000000, 0.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{440.561981, -1724.708007, 8.881980, 0.000000, 0.000000, -100.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1857.282714, -1480.799560, 12.483416, 0.000000, 0.000000, -180.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{983.398254, -1390.026367, 12.451520, 0.000000, 0.000000, -90.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{414.852233, -1354.540649, 13.743200, 0.000000, 0.000000, 120.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1124.366699, -2401.392578, 10.116116, 0.000000, 0.000000, 50.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{2109.434814, -1717.302368, 12.309993, 0.000000, 0.000000, 165.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1896.741333, -1025.888183, 35.055812, 0.000000, 0.000000, 80.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1636.957763, -1737.820190, 12.483333, 0.000000, 0.000000, 90.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}, 
    {{1007.774780, -1786.159667, 13.060641, 0.000000, 0.000000, -110.000000}, Text3D:INVALID_3DTEXT_ID, INVALID_PLAYER_ID, -1, -1}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    tdSpeedCamera = TextDrawCreate(1.0, 1.0, "_");
    TextDrawTextSize(tdSpeedCamera, 644.0, 32.0);
    TextDrawLetterSize(tdSpeedCamera, 0.0, 49.9);
    TextDrawUseBox(tdSpeedCamera, 1);
    TextDrawAlignment(tdSpeedCamera, 0);
    TextDrawBackgroundColor(tdSpeedCamera, 0x000000ff);
    TextDrawFont(tdSpeedCamera, 3);
    TextDrawColor(tdSpeedCamera, 0xffffffff);
    TextDrawSetOutline(tdSpeedCamera, 1);
    TextDrawSetProportional(tdSpeedCamera, 1);
    TextDrawSetShadow(tdSpeedCamera, 1);
    TextDrawBoxColor(tdSpeedCamera, 0xff000099);

    CreateDynamic3DTextLabel("Pregled radara\n{FFFFFF}/radari", 0xAC12F4FF, 1377.7579, -7.1669, 1001.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 100000);


    for (new i = 0; i < sizeof SpeedCameras; i++)
    {
        CreateDynamicObject(18880, SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], SpeedCameras[i][SPEED_CAMERA_POS][2], SpeedCameras[i][SPEED_CAMERA_POS][3], SpeedCameras[i][SPEED_CAMERA_POS][4], SpeedCameras[i][SPEED_CAMERA_POS][5], -1, -1);

        new sLabel[14];
        format(sLabel, sizeof sLabel, "[ RADAR %i ]", i);
        SpeedCameras[i][SPEED_CAMERA_LABEL] = CreateDynamic3DTextLabel(sLabel, 0xFF000080, SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], SpeedCameras[i][SPEED_CAMERA_POS][2]+5.0, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0);

        new 
            Float:x = SpeedCameras[i][SPEED_CAMERA_POS][0], 
            Float:y = SpeedCameras[i][SPEED_CAMERA_POS][1]
        ;
        GetXYInFrontOfPoint(x, y, SpeedCameras[i][SPEED_CAMERA_POS][5], 45.0); 
        SpeedCameras[i][SPEED_CAMERA_AREA] = CreateDynamicSphere(x, y, SpeedCameras[i][SPEED_CAMERA_POS][2], 25.0, 0, 0);
        SpeedCameras[i][SPEED_CAMERA_AREA_PD] = CreateDynamicSphere(SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], SpeedCameras[i][SPEED_CAMERA_POS][2], 60.0, 0, 0);
    }
    return true;
}

hook OnPlayerConnect(playerid)
{
    gSpeedCamera_Reload[playerid] = 0;
    gSpeedCamera_CaughtBy{playerid} = 255;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (IsACop(playerid))
    {
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (SpeedCamera_GetPlayerID(i) == playerid)
            {
                SpeedCamera_ToggleActive(i, false);
            }
        }
    } 
}

hook OnPlayerSpawn(playerid)
{
    if (IsACop(playerid))
    {
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (SpeedCamera_GetPlayerID(i) == playerid)
            {
                SpeedCamera_ToggleActive(i, false);
            }
        }
    } 
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetPlayerSpeed(playerid) > 100 && !IsPlayerOnLawDuty(playerid))
    {
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (areaid == SpeedCameras[i][SPEED_CAMERA_AREA])
            {
                DebugMsg(playerid, "Usao si u zonu kamere %i", i);

                if (SpeedCamera_IsActive(i))
                {
                    PlayerMoneySub(playerid, 2500);
                    PlayerMoneyAdd(SpeedCamera_GetPlayerID(i), 2500);

                    SendClientMessage(playerid, CRVENA, "RADAR | {FFFFFF}Kamera te je snimila u prekoracenju brzine! Kaznjen si sa $2500.");
                    SendClientMessage(SpeedCamera_GetPlayerID(i), ZELENA2, "RADAR | {FFFFFF}Vozac je uhvacen u prekrsaju. Dobijas $2500.");

                    TextDrawShowForPlayer(playerid, tdSpeedCamera);
                    SetTimerEx("SpeedCamera_HideTD", 650, false, "i", playerid);

                    gSpeedCamera_Reload[playerid] = gettime() + 120;
                    gSpeedCamera_CaughtBy{playerid} = i;

                    new sLog[85];
                    format(sLog, sizeof sLog, "%s | Kamera: %i | Policajac: %s", ime_obicno[playerid], i, ime_obicno[SpeedCamera_GetPlayerID(i)]);
                    Log_Write(LOG_SPEEDCAMERAS, sLog);
                }

                break;
            }
        }
    }
}

hook OnPlayerLeaveDynArea(playerid, areaid)
{
    if (IsACop(playerid))
    {
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (areaid == SpeedCameras[i][SPEED_CAMERA_AREA_PD] && SpeedCamera_GetPlayerID(i) == playerid)
            {
                // Igrac se previse udaljio od kamere
                SpeedCamera_ToggleActive(i, false);
                InfoMsg(playerid, "Kamera %i je deaktivirana jer si se previse udaljio od nje.", i);
                break;
            }
        }
    }
}

hook OnPlayerAFK(playerid)
{
    // Deaktivirati radar kada igrac ode AFK
    if (IsACop(playerid))
    {
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (SpeedCamera_GetPlayerID(i) == playerid)
            {
                SpeedCamera_ToggleActive(i, false);
                InfoMsg(playerid, "Kamera %i je deaktivirana jer si otisao AFK.", i);
                break;
            }
        }
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward SpeedCamera_HideTD(playerid);
public SpeedCamera_HideTD(playerid)
{
    TextDrawHideForPlayer(playerid, tdSpeedCamera);
    return 1;
}

SpeedCamera_IsActive(cameraid)
{
    if (SpeedCameras[cameraid][SPEED_CAMERA_ACTIVE] == INVALID_PLAYER_ID)
        return false;

    return true;
}

SpeedCamera_GetPlayerID(cameraid)
{
    if (SpeedCamera_IsActive(cameraid))
        return SpeedCameras[cameraid][SPEED_CAMERA_ACTIVE];

    return INVALID_PLAYER_ID;
}

SpeedCamera_ToggleActive(cameraid, bool:toggle, playerid = INVALID_PLAYER_ID)
{
    if (toggle)
    {
        SpeedCameras[cameraid][SPEED_CAMERA_ACTIVE] = playerid;

        new sLabel[41];
        format(sLabel, sizeof sLabel, "[ RADAR %i ]\n\n%s", cameraid, ime_rp[playerid]);
        UpdateDynamic3DTextLabelText(SpeedCameras[cameraid][SPEED_CAMERA_LABEL], 0x00FF0080, sLabel);
    }
    else
    {
        SpeedCameras[cameraid][SPEED_CAMERA_ACTIVE] = INVALID_PLAYER_ID;

        new sLabel[14];
        format(sLabel, sizeof sLabel, "[ RADAR %i ]", cameraid);
        UpdateDynamic3DTextLabelText(SpeedCameras[cameraid][SPEED_CAMERA_LABEL], 0xFF000080, sLabel);
    }
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:radari(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new cameraid = listitem;
    new sMsg[11];
    format(sMsg, sizeof sMsg, "Radar #%i", cameraid);
    SetGPSLocation(playerid, SpeedCameras[cameraid][SPEED_CAMERA_POS][0], SpeedCameras[cameraid][SPEED_CAMERA_POS][1], SpeedCameras[cameraid][SPEED_CAMERA_POS][2], sMsg);

    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:radar(playerid, const params[])
{
    if (!IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili radare.");

    new cameraid = -1;
    for (new i = 0; i < sizeof SpeedCameras; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 4.0, SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], SpeedCameras[i][SPEED_CAMERA_POS][2]))
        {
            cameraid = i;
            break;
        }
    }

    if (cameraid == -1)
        return ErrorMsg(playerid, "Ne nalazite se pored kamere za merenje brzine kretanja vozila.");

    if (SpeedCamera_IsActive(cameraid))
    {
        if (SpeedCamera_GetPlayerID(cameraid) != playerid)
            return ErrorMsg(playerid, "Drugi igrac je vec aktivirao ovu kameru.");

        SpeedCamera_ToggleActive(cameraid, false);
        InfoMsg(playerid, "Deaktivirao si ovu kameru.");
    }
    else
    {
        new bool:ok = true;
        for (new i = 0; i < sizeof SpeedCameras; i++)
        {
            if (cameraid == i) continue;

            if (SpeedCamera_GetPlayerID(cameraid) == playerid)
            {
                ok = false;
                break;
            }
        }

        if (!ok)
            return ErrorMsg(playerid, "Vec si aktivirao drugu kameru.");

        SpeedCamera_ToggleActive(cameraid, true, playerid);
        InfoMsg(playerid, "Aktivirao si ovu kameru za merenje brzine kretanja vozila.");
        SendClientMessage(playerid, BELA, "Svako vozilo koje prekoraci brzinu od 100 km/h bice kaznjeno sa $1.500, a novac od kazne dobijas ti.");
    }

    return 1;
}

CMD:radari(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1377.7579, -7.1669, 1001.0) && pUsingCCTV[playerid] == -1)
        return ErrorMsg(playerid, "Ne nalazite se na mestu za gledanje kamera u policijskoj stanici.");

    if (!IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Morate biti na duznosti da biste koristili ovu komandu.");

    new 
        sDialog[sizeof SpeedCameras * 45],
        sZone[32]
    ;
    sDialog[0] = EOS;
    for__loop (new i = 0; i < sizeof SpeedCameras; i++)
    {
        Get2DZoneByPosition(SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], sZone, sizeof sZone);
        format(sDialog, sizeof sDialog, "%s%i\t%s\t%s\n", sDialog, i, sZone, (SpeedCamera_IsActive(i)? ("{00FF00}Aktivan") : ("{FF0000}Neaktivan")));
    }

    SPD(playerid, "radari", DIALOG_STYLE_TABLIST, "Spisak radara", sDialog, "Oznaci", "Izadji");

    return 1;
}

flags:resetradar(FLAG_ADMIN_6)
CMD:resetradar(playerid, const params[])
{
    new cameraid = -1;
    for (new i = 0; i < sizeof SpeedCameras; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 7.0, SpeedCameras[i][SPEED_CAMERA_POS][0], SpeedCameras[i][SPEED_CAMERA_POS][1], SpeedCameras[i][SPEED_CAMERA_POS][2]))
        {
            cameraid = i;
            break;
        }
    }

    if (cameraid == -1)
        return ErrorMsg(playerid, "Ne nalazite se pored kamere za merenje brzine kretanja vozila.");

    SpeedCamera_ToggleActive(cameraid, false);
    InfoMsg(playerid, "Deaktivirao si ovu kameru.");
    return 1;
}