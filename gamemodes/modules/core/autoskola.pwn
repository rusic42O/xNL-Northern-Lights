#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define AUTOSKOLA_COLOR             (0x55CC55FF)
#define AUTOSKOLA_PRICE             (6000)
#define AUTOSKOLA_KAZNENI_P_MAX     (5) // Praktican deo
#define AUTOSKOLA_KAZNENI_T_MAX     (3) // Teorijski deo


new Float:autoskola_cpInfo[MAX_PLAYERS][4];

// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
    AUTOSKOLA_UPLATIO = 1,
    AUTOSKOLA_TEORIJA,
    AUTOSKOLA_POLIGON,
    AUTOSKOLA_POLIGON_U_TOKU,
    AUTOSKOLA_GRADSKA_VOZNJA,
}

enum e_AUTOSKOLA_POLIGON
{
    Float:POLIGON_CP[3],
    POLIGON_MSG[98],
    POLIGON_PARKING, // ako je != -1, uklanjaju se stop znakovi
}

enum e_AUTOSKOLA_PITANJA
{
    AUTOSKOLA_PITANJE[60],
    AUTOSKOLA_ODGOVORI[70],
    AUTOSKOLA_TACAN_ODG,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    autoskola_progress[MAX_PLAYERS],
    autoskola_cpProgress[MAX_PLAYERS],
    autoskola_kazneniPoeni[MAX_PLAYERS],
    autoskola_pitanje[MAX_PLAYERS],
    autoskola_stopSign[MAX_PLAYERS][3],
    autoskola_zona,

    tajmer:autoskola_brzina[MAX_PLAYERS],
    Iterator:iAutoSkola<MAX_VEHICLES>;

new autoskola_pitanja[6][e_AUTOSKOLA_PITANJA] = 
{
    {"[1/6] U saobracaju se vozi:",                       "Desnom stranom\nLevom stranom\nBilo kojom stranom",                    0},
    {"[2/6] Svetla na vozilu moraju biti upaljena:",      "Samo tokom dana\nSamo tokom noci\nUvek",                               2},
    {"[3/6] Ukoliko je na semaforu crveno svetlo:",       "Malo usporimo, pa nastavimo\nZaustavimo se\nNastavimo sa voznjom",     1},
    {"[4/6] Ukoliko Vas zaustavi policija:",              "Stisnucete gas i pobeci\nIgnorisati ih\nZaustaviti vozilo pored puta", 2},
    {"[5/6] Prilikom voznje motora, nosenje kacige je:",  "Obavezno\nNije obavezno",                                              0},
    {"[6/6] Ukoliko Vam se vozilo pokvari, pozvacete:",   "Policiju\nHitnu pomoc\nMehanicara\nVatrogasce",                        2}
};

new autoskola_poligonCP[18][e_AUTOSKOLA_POLIGON] = 
{
    {{-2069.7256,-136.5743,35.3203}, "~g~~h~Dobrodosli na prakticni deo vozackog ispita!~n~~w~- Udjite na poligon na oznacenom mestu.", -1}, // cp 1
    {{-2069.9641,-169.7783,35.3203}, "~y~~h~Pratite checkpoint-e i nastavite sa voznjom.~n~~r~~h~Pazite da ne ostetite vozilo!", -1}, // cp 2
    {{-2080.3884,-157.0282,35.3203}, "~r~Parkirajte se u ~w~rikverc ~r~upravno u mesto sa Vase desne strane.", -1}, // cp 3 - parking*
    {{-2071.3606,-214.1017,35.3203}, "~y~~h~Pratite checkpoint-e i nastavite sa voznjom.", 0}, // cp 4
    {{-2066.2913,-198.7799,35.3203}, "~r~Parkirajte se u ~w~paralelno ~r~u mesto sa Vase leve strane.", -1}, // cp 5 parking paralelno
    {{-2069.4519,-230.7670,35.3203}, "~b~~h~Sledi kruzni tok, obrnite ceo krug.", 1}, // cp 6
    {{-2062.4900,-250.0705,35.3203}, "~b~~h~Sledi kruzni tok, obrnite ceo krug.", -1}, // cp 7
    {{-2048.5632,-246.7486,35.3203}, "~b~~h~Sledi kruzni tok, obrnite ceo krug.", -1}, // cp 8
    {{-2062.5137,-240.0256,35.3203}, "~g~~h~Nastavite sa voznjom kroz kruzni tok.", -1}, // cp 9
    {{-2059.0652,-253.1865,35.3203}, "~g~~h~Nastavite sa voznjom kroz kruzni tok.", -1}, // cp 10
    {{-2045.0354,-236.4693,35.3203}, "~y~Izadjite iz kruznog toka.", -1}, // cp 11
    {{-2042.4161,-198.6111,35.3203}, "~y~~h~Nastavite pravo.", -1}, // cp 12
    {{-2034.6082,-210.8607,35.3203}, "~r~Parkirajte se u ~w~rikverc ~r~upravno u mesto sa Vase desne strane.", -1}, // cp 13 parking
    {{-2041.9377,-189.2420,35.3203}, "~y~Isparkirajte se i nastavite sa voznjom.~n~~b~Sledi slalom.", 2}, // cp 14
    {{-2047.0936,-178.4812,35.3203}, "~b~~h~Pazljivo vozite slalom izmedju stubica i pazite da ~b~~h~ne ostetite vozilo.", -1}, // cp 15
    {{-2042.0209,-167.3502,35.3203}, "~b~~h~Pazljivo vozite slalom izmedju stubica i pazite da ~b~~h~ne ostetite vozilo.", -1}, // cp 16
    {{-2045.2357,-138.0336,35.3087}, "~g~~h~Zavrili ste sa voznjom na poligonu!~n~~g~~h~Izadjite sa poligona. Sledi ~r~gradska voznja.", -1}, // cp 17
    {{-2047.0112,-107.7738,34.9608}, "~g~~h~Zavrili ste sa voznjom na poligonu!~n~~g~~h~Izadjite sa poligona. Sledi ~r~gradska voznja.", -1} // cp 18
};

new Float:autoskola_gradCP[42][3] = 
{
    {1148.7690,-1743.1370,13.1783},
    {1172.8038,-1757.0865,13.1774},
    {1172.8677,-1830.4681,13.1799},
    {1188.5341,-1854.5833,13.1795},
    {1324.6799,-1854.7992,13.1634},
    {1434.3409,-1874.6062,13.1620},
    {1558.0062,-1874.6448,13.1625},
    {1571.6063,-1853.9923,13.1627},
    {1572.0740,-1752.7526,13.1621},
    {1584.5066,-1734.6641,13.1619},
    {1668.4597,-1734.6198,13.1621},
    {1691.6006,-1712.9678,13.1619},
    {1691.8038,-1609.6459,13.1624},
    {1675.9341,-1590.4895,13.1621},
    {1660.2783,-1576.8057,13.1700},
    {1660.1636,-1458.5294,13.1652},
    {1646.4923,-1438.5153,13.1624},
    {1470.3846,-1438.7136,13.1620},
    {1425.1663,-1435.9957,13.1634},
    {1418.9811,-1394.1187,13.1622},
    {1370.9783,-1393.0925,13.2357},
    {1359.9812,-1383.9944,13.2910},
    {1355.4075,-1226.4387,13.7069},
    {1355.1010,-1162.4017,23.4959},
    {1348.8108,-1145.4318,23.4675},
    {1324.0480,-1141.0680,23.4358},
    {1237.1406,-1141.2289,23.3485},
    {1214.0752,-1158.5436,23.1405},
    {1213.6927,-1264.5924,13.5914},
    {1204.5082,-1281.2067,13.1644},
    {1070.0972,-1280.6329,13.3828},
    {1056.7181,-1392.0161,13.0351},
    {1131.3901,-1400.5926,13.0292},
    {1193.7524,-1419.8225,13.0092},
    {1193.8527,-1560.1278,13.1621},
    {1179.9039,-1569.6632,13.1277},
    {1160.7207,-1570.0474,13.0579},
    {1147.6875,-1583.8351,13.0981},
    {1147.8274,-1697.7693,13.5603},
    {1171.4227,-1717.0276,13.4566},
    {1170.2018,-1738.5852,13.2328},
    {1105.5787,-1738.4443,13.2815}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    new str3d[105];
    format(str3d, sizeof str3d, "{55CC55}[ AUTO SKOLA ]\n{FFFFFF}Za polaganje upisite {55CC55}/polaganje\n{FFFFFF}Cena: {55CC55}%s", formatMoneyString(AUTOSKOLA_PRICE));

    // Pickupi
    CreateDynamicPickup(1581, 1, 1081.5848,-1673.5972,13.5833);
    CreateDynamic3DTextLabel(str3d, BELA, 1081.5848,-1673.5972,13.8, 20.0);
    autoskola_zona = CreateDynamicRectangle(-2095.3296,-280.0060,-2012.3361,-104.3241);

    // Vozila
    new vehicleid;
    vehicleid = CreateVehicle(401, -2059.6875, -107.0250, 35.2485, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2064.8206, -107.0250, 35.2524, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2069.8103, -107.0250, 35.2510, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2074.9104, -107.0250, 35.2527, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2079.8567, -107.0250, 35.2474, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2084.8525, -107.0250, 35.2474, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);

    vehicleid = CreateVehicle(401, -2089.8918, -107.0250, 35.2474, 180.0, 162, 162, 100);
    Iter_Add(iAutoSkola, vehicleid);
    return true;
}

hook OnPlayerConnect(playerid)
{
    autoskola_progress[playerid] = 0;
    autoskola_cpProgress[playerid] = autoskola_pitanje[playerid] = -1;
    tajmer:autoskola_brzina[playerid] = 0;

    autoskola_stopSign[playerid][0] = autoskola_stopSign[playerid][1] = autoskola_stopSign[playerid][2] = -1; 

    AUTOSKOLA_ResetPlayerCP(playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (tajmer:autoskola_brzina[playerid] != 0)
    {
        KillTimer(tajmer:autoskola_brzina[playerid]);
        tajmer:autoskola_brzina[playerid] = 0;
    }

    for__loop (new i = 0; i < 3; i++)
    {
        if (autoskola_stopSign[playerid][i] != -1 && IsValidDynamicObject(autoskola_stopSign[playerid][i]))
            DestroyDynamicObject(autoskola_stopSign[playerid][i]), autoskola_stopSign[playerid][i] = -1;
    }
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
    if (areaid == autoskola_zona && autoskola_progress[playerid] == AUTOSKOLA_POLIGON)
    {
        SendClientMessage(playerid, AUTOSKOLA_COLOR, "Sa desne strane nalaze se parkirana vozila. Udjite u jedan automobil i pratite uputstva za voznju po poligonu.");
        return ~1;
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER && autoskola_progress[playerid] == AUTOSKOLA_POLIGON)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if (Iter_Contains(iAutoSkola, vehicleid))
        {
            autoskola_progress[playerid] = AUTOSKOLA_POLIGON_U_TOKU;

            ptdJobhelp_Create(playerid);
            ptdJobhelp_SetJob(playerid, "Auto skola");
            SetPlayerVirtualWorld(playerid, playerid+1);
            SetVehicleVirtualWorld(vehicleid, playerid+1);
            RefillVehicle(vehicleid);
            

            autoskola_cpProgress[playerid] = 0;
            AUTOSKOLA_SetPlayerCP(playerid, autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_X], autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_Y], autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_Z], 3.0);
            ptdJobhelp_SetString(playerid, autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_MSG]);


            // Stop znakovi
            autoskola_stopSign[playerid][0] = CreateDynamicObject(19966, -2072.731201, -175.075531, 33.830333, 0.000000, 0.000000, -180.000000, playerid+1, 0, playerid); 
            autoskola_stopSign[playerid][1] = CreateDynamicObject(19966, -2072.731201, -222.045440, 33.830333, 0.000000, 0.000000, -180.000000, playerid+1, 0, playerid); 
            autoskola_stopSign[playerid][2] = CreateDynamicObject(19966, -2041.036499, -191.314987, 33.920310, 0.000000, 0.000000, 0.000000, playerid+1, 0, playerid);
        }
    }
}

hook OnPlayerEnterCheckpoint(playerid)
{
    if (autoskola_progress[playerid] >= AUTOSKOLA_UPLATIO)
    {
        DisablePlayerCheckpoint_H(playerid);

        if (autoskola_progress[playerid] == AUTOSKOLA_UPLATIO)
        {
            autoskola_pitanje[playerid] += 1;
            SPD(playerid, "autoskola_test", DIALOG_STYLE_LIST, autoskola_pitanja[autoskola_pitanje[playerid]][AUTOSKOLA_PITANJE], autoskola_pitanja[autoskola_pitanje[playerid]][AUTOSKOLA_ODGOVORI], "Dalje ", "");
        }

        else if (autoskola_progress[playerid] == AUTOSKOLA_POLIGON_U_TOKU || autoskola_progress[playerid] == AUTOSKOLA_GRADSKA_VOZNJA)
        {
            if (IsPlayerInRangeOfPoint(playerid, autoskola_cpInfo[playerid][3], autoskola_cpInfo[playerid][0], autoskola_cpInfo[playerid][1], autoskola_cpInfo[playerid][2]))
            // if (IsPlayerInRangeOfPoint(playerid, 3.0, autoskola_gradCP[autoskola_cpProgress[playerid]][POS_X], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Y], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Z]))
            {
                autoskola_cpProgress[playerid]++;
                if (autoskola_progress[playerid] == AUTOSKOLA_POLIGON_U_TOKU && autoskola_cpProgress[playerid] == sizeof autoskola_poligonCP)
                {
                    // Poligon je zavrsen, usao je u poslednji CP
                    new Float:vehicleHp, vehicleid = GetPlayerVehicleID(playerid);
                    GetVehicleHealth(vehicleid, vehicleHp);
                    if (vehicleHp < 920.0)
                    {
                        SendClientMessage(playerid, SVETLOCRVENA, "(autoskola) Uspesno ste zavrsili poligon, ali je vozilo previse osteceno. Niste polozili.");
                        autoskola_progress[playerid] = 0;
                        autoskola_cpProgress[playerid] = -1;
                        SetPlayerCompensatedPosEx(playerid, 1081.5848,-1673.5972,13.5833,0.0);

                        SetVehicleToRespawn(vehicleid);
                        ptdJobhelp_Destroy(playerid);
                        SetPlayerVirtualWorld(playerid, 0);
                        SetVehicleVirtualWorld(vehicleid, 0);

                        return 1;
                    }

                    TeleportPlayer(playerid, 1104.6268,-1743.4497,13.1586);
                    SetVehicleZAngle(vehicleid, 270.0);
                    RepairVehicle(vehicleid);
                    SetVehicleHealth(vehicleid, 999.0);
                    autoskola_progress[playerid] = AUTOSKOLA_GRADSKA_VOZNJA;
                    tajmer:autoskola_brzina[playerid] = SetTimerEx("autoskola_ProveriBrzinu", 1200, true, "i", playerid);

                    autoskola_cpProgress[playerid] = 0;
                    AUTOSKOLA_SetPlayerCP(playerid, autoskola_gradCP[autoskola_cpProgress[playerid]][POS_X], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Y], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Z], 3.0);

                    ptdJobhelp_SetString(playerid, "~g~~h~Vozite po gradu.~n~~g~~h~~h~Ogranicenje brzine je ~r~80 km/h!~n~~g~~h~~h~Ne smete da prekoracite brzinu ili ostetite vozilo!");
                }
                else if (autoskola_progress[playerid] == AUTOSKOLA_GRADSKA_VOZNJA && autoskola_cpProgress[playerid] == sizeof autoskola_gradCP)
                {
                    // Zavrsena gradska voznja
                    new Float:vehicleHp;
                    GetVehicleHealth(GetPlayerVehicleID(playerid), vehicleHp);

                    new vehicleid = GetPlayerVehicleID(playerid);
                    SetVehicleToRespawn(vehicleid);
                    ptdJobhelp_Destroy(playerid);
                    SetPlayerVirtualWorld(playerid, 0);
                    SetVehicleVirtualWorld(vehicleid, 0);
                    
                    autoskola_progress[playerid] = 0;
                    autoskola_cpProgress[playerid] = -1;
                    KillTimer(tajmer:autoskola_brzina[playerid]), tajmer:autoskola_brzina[playerid] = 0;

                    if (vehicleHp < 900.0)
                    {
                        SendClientMessage(playerid, SVETLOCRVENA, "(autoskola) Uspesno ste zavrsili gradsku voznju, ali je vozilo koje ste vratili previse osteceno. Niste polozili.");
                    }
                    else
                    {
                        SendClientMessage(playerid, AUTOSKOLA_COLOR, "(autoskola) {FFFFFF}Uspesno ste polozili vozacki ispit! Sada imate vozacku dozvolu.");

                        PI[playerid][p_dozvola_voznja] = 1;

                        new query[55];
                        format(query, sizeof query, "UPDATE igraci SET dozvola_voznja = 1 WHERE id = %d", PI[playerid][p_id]);
                        mysql_tquery(SQL, query);
                    }
                }
                else
                {
                    if (autoskola_progress[playerid] == AUTOSKOLA_POLIGON_U_TOKU)
                    {
                        ptdJobhelp_SetString(playerid, autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_MSG]);
                        AUTOSKOLA_SetPlayerCP(playerid, autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_X], autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_Y], autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_CP][POS_Z], 3.0);

                        // Uklanjanje stop znakova
                        if (autoskola_poligonCP[autoskola_cpProgress[playerid]][POLIGON_PARKING] != -1)
                        {
                            if (IsValidDynamicObject(autoskola_stopSign[playerid][ autoskola_poligonCP[ autoskola_cpProgress[playerid] ][POLIGON_PARKING] ]))
                            {
                                DestroyDynamicObject(autoskola_stopSign[playerid][ autoskola_poligonCP[ autoskola_cpProgress[playerid] ][POLIGON_PARKING] ]);
                                
                                autoskola_stopSign[playerid][ autoskola_poligonCP[ autoskola_cpProgress[playerid] ][POLIGON_PARKING] ] = -1;
                            }
                        }


                        // Usporavanje vozila pred parking
                        new index = autoskola_cpProgress[playerid]+2;
                        if (index < sizeof autoskola_poligonCP && autoskola_poligonCP[index][POLIGON_PARKING] != -1)
                        {
                            // Za 2 checkpointa sledi parking
                            SetVehicleVelocity(GetPlayerVehicleID(playerid), 0.0,0.0,0.0);
                        }
                    }
                    else if (autoskola_progress[playerid] == AUTOSKOLA_GRADSKA_VOZNJA)
                    {
                        AUTOSKOLA_SetPlayerCP(playerid, autoskola_gradCP[autoskola_cpProgress[playerid]][POS_X], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Y], autoskola_gradCP[autoskola_cpProgress[playerid]][POS_Z], 3.0);
                    }
                    else
                    {

                        // DebugMsg(playerid, "autoskola_progress = %i", autoskola_progress[playerid]);
                    }
                }
                return ~1;
            }
        }
    }
    return 1;
}





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward autoskola_ProveriBrzinu(playerid);
public autoskola_ProveriBrzinu(playerid)
{
    new 
        speed = GetPlayerSpeed(playerid),
        vehicleid = GetPlayerVehicleID(playerid);

    if (speed > 80)
    {
        autoskola_kazneniPoeni[playerid] += 1;
        
        new Float:ST[3];
        GetVehicleVelocity(vehicleid, ST[0], ST[1], ST[2]);
        SetVehicleVelocity(vehicleid, ST[0]/3, ST[1]/3, ST[2]/3);

        if (autoskola_kazneniPoeni[playerid] >= AUTOSKOLA_KAZNENI_P_MAX)
        {
            SendClientMessageF(playerid, AUTOSKOLA_COLOR, "(autoskola) {FF0000}Imate %i kaznenih poena, pali ste na vozackom ispitu.", AUTOSKOLA_KAZNENI_P_MAX);
            SetVehicleToRespawn(vehicleid);
            ptdJobhelp_Destroy(playerid);
            SetPlayerVirtualWorld(playerid, 0);
            SetVehicleVirtualWorld(vehicleid, 0);
            DisablePlayerCheckpoint_H(playerid);
            
            autoskola_progress[playerid] = 0;
            autoskola_cpProgress[playerid] = -1;
            SetPlayerCompensatedPosEx(playerid, 1081.5848,-1673.5972,13.5833,0.0);

            KillTimer(tajmer:autoskola_brzina[playerid]), tajmer:autoskola_brzina[playerid] = 0;
        }
        else
        {
            SendClientMessageF(playerid, AUTOSKOLA_COLOR, "(autoskola) {FF0000}Prekoracili ste brzinu!!! Imate %i/%i kaznenih poena.", autoskola_kazneniPoeni[playerid], AUTOSKOLA_KAZNENI_P_MAX);
        }
    }
    return 1;
}

stock AUTOSKOLA_SetPlayerCP(playerid, Float:x, Float:y, Float:z, Float:size)
{
    autoskola_cpInfo[playerid][0] = x;
    autoskola_cpInfo[playerid][1] = y;
    autoskola_cpInfo[playerid][2] = z;
    autoskola_cpInfo[playerid][3] = size;

    return SetPlayerCheckpoint_H(playerid, x, y, z, size);
}

stock AUTOSKOLA_ResetPlayerCP(playerid)
{
    autoskola_cpInfo[playerid][0] = -6000;
    autoskola_cpInfo[playerid][1] = -6000;
    autoskola_cpInfo[playerid][2] = -6000;
    autoskola_cpInfo[playerid][3] = 0;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:autoskola_test(playerid, response, listitem, const inputtext[]) // poslednje pitanje
{
    if (!response) return DialogReopen(playerid);

    if (listitem != autoskola_pitanja[autoskola_pitanje[playerid]][AUTOSKOLA_TACAN_ODG])
    {
        // Dao je pogresan odgovor
        autoskola_kazneniPoeni[playerid]++;
        if (autoskola_kazneniPoeni[playerid] >= AUTOSKOLA_KAZNENI_T_MAX)
        {
            // 3 netacna odgovora -> pada
            SendClientMessageF(playerid, TAMNOCRVENA, "Dali ste netacan odgovor na %i pitanja. Pali ste na teorijskom ispitu.", AUTOSKOLA_KAZNENI_T_MAX);
            SendClientMessage(playerid, SVETLOCRVENA, "Ukoliko zelite da polazete ponovo, morate platiti ponovo (/polaganje).");
            return 1;
        }
        else
        {
            SendClientMessageF(playerid, SVETLOCRVENA, "Dali ste netacan odgovor. Ukoliko pogresite jos %i puta, moracete da platite novo polaganje.", AUTOSKOLA_KAZNENI_T_MAX-autoskola_kazneniPoeni[playerid]);
        }
    }
    
    autoskola_pitanje[playerid] += 1;
    if (autoskola_pitanje[playerid] != sizeof autoskola_pitanja)
    {
        SPD(playerid, "autoskola_test", DIALOG_STYLE_LIST, autoskola_pitanja[autoskola_pitanje[playerid]][AUTOSKOLA_PITANJE], autoskola_pitanja[autoskola_pitanje[playerid]][AUTOSKOLA_ODGOVORI], "Dalje ", "");
    }
    else
    {
        SendClientMessage(playerid, AUTOSKOLA_COLOR, "* Uspesno ste polozili teorijski deo ispita. Sledi poligon.");
        autoskola_progress[playerid] = AUTOSKOLA_POLIGON;
        SetPlayerCompensatedPosEx(playerid, -2029.7772,-120.6989,35.1713,180.0);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:polaganje(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 4.0, 1081.5848,-1673.5972,13.5833))
        return ErrorMsg(playerid, "Morate ici u auto skolu da biste polagali vozacki ispit.");

    if (autoskola_progress[playerid] >= AUTOSKOLA_UPLATIO)
        return ErrorMsg(playerid, "Vec ste aktivirali polaganje, pratite instrukcije!");

    if (PI[playerid][p_novac] < AUTOSKOLA_PRICE)
        return ErrorMsg(playerid, "Nemate dovoljno novca. Polaganje vozackog ispita kosta {FFFFFF}%s.", formatMoneyString(AUTOSKOLA_PRICE));

    if (PI[playerid][p_dozvola_voznja] > 0)
        return ErrorMsg(playerid, "Vec posedujete validnu vozacku dozvolu, nema potrebe da polazete ponovo.");


    PlayerMoneySub(playerid, AUTOSKOLA_PRICE);
    autoskola_kazneniPoeni[playerid] = 0;
    autoskola_pitanje[playerid] = -1;
    autoskola_stopSign[playerid][0] = autoskola_stopSign[playerid][1] = autoskola_stopSign[playerid][2] = -1; 
    autoskola_progress[playerid] = AUTOSKOLA_UPLATIO;
    AUTOSKOLA_SetPlayerCP(playerid, 1069.0654,-1676.3960,13.5620, 2.0);

    SendClientMessage(playerid, AUTOSKOLA_COLOR, "* Uplatili ste polaganje vozackog ispita. Idite na oznaceno mesto da biste polagali teorijski test.");

    // Preventivno resetovanje virtualworld-a vozilima, jer se nekad desi da ostane neki drugi podesen, pa se ta vozila ne vide
    foreach (new i : iAutoSkola)
    {
        if (!IsVehicleOccupied_OW(i))
        {
            SetVehicleToRespawn(i);
            SetVehicleVirtualWorld(i, 0);
        }
    }
    return 1;
}