#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_GPS_INFO
{
    gpsName[18],
    Float:gpsCoords[3]
}





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bool:gps_aktivan[MAX_PLAYERS]
;

new GPSInfo[][E_GPS_INFO] = 
{
    // Glavne lokacije
    {"Pijaca",              {1209.8362, -1540.7909, 13.5791}},
    {"Opstina",             {1479.6530,-1785.1094,13.5469}},
    {"Tech Store",          {1712.5375, -1146.5448, 23.9567}},
    {"Hardware Store",      {1324.0614, -1124.6028, 23.9370}},
    {"Security Shop",       {1739.6257, -1608.4365, 13.5469}},
    {"Zlatara",             {607.7417, -1458.4033, 14.3721}},
    {"Auto skola",          {1081.2271, -1693.5883, 13.5320}},
    {"Auto salon",          {928.9373,  -1712.8451, 13.5405}},
    {"Auto pijaca",         {1641.9790, -1155.3376, 24.0988}},
    {"Lutrija",             {1220.2201, -1413.0074, 13.3203}},
    {"Tuning garaza",       {2508.5737, -1517.3580, 24.0098}},
    {"Auto lakirnica",      {1952.5653, -1975.0490, 13.1211}},
    {"Mehanicar",           {2547.0918, -1471.1000, 23.8562}},
    {"Burger Shot",         {1221.3342, -918.0650,  42.9127}},
    {"LS Banka",            {1461.0076, -1026.0122, 23.8281}},
    {"Policija",            {1544.2372, -1675.6801, 13.5580}},
    {"Bolnica",             {1201.8177, -1388.2979, 13.2148}},
    {"Autobuska stanica",   {1810.9696, -1889.1246, 13.4076}},
    {"Aerodrom",            {1962.6006, -2181.7441, 13.1202}},
    {"Oglasnik",            {1804.9729, -1345.5475, 15.2733}}
};




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid) 
{
    gps_aktivan[playerid] = false;
    return 1;
}

hook OnPlayerEnterCheckpoint(playerid) 
{
    if (!gps_aktivan[playerid]) return 1;

    GameTextForPlayer(playerid, "~g~Stigli ste na odrediste", 5000, 1);
    DisablePlayerCheckpoint_H(playerid);
    gps_aktivan[playerid] = false;
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward SetGPSLocation(playerid, Float:x, Float:y, Float:z, const lokacija[]);
public SetGPSLocation(playerid, Float:x, Float:y, Float:z, const lokacija[]) 
{
    SetPlayerCheckpoint_H(playerid, x, y, z, 5.0);
    gps_aktivan[playerid] = true;
    SendClientMessageF(playerid, INFO, "(gps) {9DF2B5}Lokacija postavljena na: {FFFFFF}%s.", lokacija);
    return 1;
}

forward SetTeleportLocation(playerid, Float:x, Float:y, Float:z, const lokacija[]);
public SetTeleportLocation(playerid, Float:x, Float:y, Float:z, const lokacija[]) 
{
    TeleportPlayer(playerid, x, y, z);
    SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovani ste na lokaciju: {FFFFFF}%s.", lokacija);
    return 1;
}

// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:gps(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        switch (listitem)
        {

        case 0: // Glavne lokacija
        {
            new string[sizeof(GPSInfo) * 20];
            string[0] = EOS;
            for__loop (new i = 0; i < sizeof(GPSInfo); i++) 
            {
                format(string_32, 32, "%s\n", GPSInfo[i][gpsName]);
                strins(string, string_32, strlen(string));
            }

            if(IsAdmin(playerid, 1))
            {
                SPD(playerid, "gps_glavne", DIALOG_STYLE_LIST, "PORT - Odaberite lokaciju", string, "Odaberi", "Nazad");
            }
            else
                SPD(playerid, "gps_glavne", DIALOG_STYLE_LIST, "GPS - Odaberite lokaciju", string, "Odaberi", "Nazad");
    
        }

        case 1: // Poslovi
        {
            new job_name[20], string[512];
            string[0] = EOS;
            for__loop (new i = 0; i < GetNumberOfJobs(); i++) {
                GetJobName(i, job_name, sizeof(job_name));
                format(string, sizeof(string), "%s\n%s", string, job_name);
            }
            SPD(playerid, "gps_poslovi", DIALOG_STYLE_LIST, "Izaberite posao", string, "Odaberi", "Nazad");
        }

        case 2: // Nekretnine
        {
            SPD(playerid, "gps_nekretnina", DIALOG_STYLE_LIST, "Izaberite vrstu nekretnine", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica", "Dalje ", " Nazad");
        }

        }
    }
    return 1;
}

Dialog:gps_glavne(playerid, response, listitem, const inputtext[]) 
{
    if (response)
    {
        if (!strcmp(inputtext, "Accessory Shop", true))
        {
            // Loop kroz sve firme da se pronadju accessory shop-ovi, pa onda se oznaci jedan nasumicno
            new Iterator:iAccessoryShops<MAX_FIRMI>;
            for__loop (new i = re_globalid(firma, 1); i < re_globalid(firma, RE_GetMaxID_Business()); i++)
            {
                if (RealEstate[i][RE_VRSTA] == FIRMA_ACCESSORY)
                {
                    Iter_Add(iAccessoryShops, re_localid(firma, i));
                }
            }

            new lid = Iter_Random(iAccessoryShops);
            new gid = re_globalid(firma, lid);

            SetGPSLocation(playerid, RealEstate[gid][RE_ULAZ][POS_X], RealEstate[gid][RE_ULAZ][POS_Y], RealEstate[gid][RE_ULAZ][POS_Z], inputtext);
        }
        else
        {
            if(IsAdmin(playerid, 1)) //tutu
                SetTeleportLocation(playerid, GPSInfo[listitem][gpsCoords][POS_X], GPSInfo[listitem][gpsCoords][POS_Y], GPSInfo[listitem][gpsCoords][POS_Z], GPSInfo[listitem][gpsName]);
            else
                SetGPSLocation(playerid, GPSInfo[listitem][gpsCoords][POS_X], GPSInfo[listitem][gpsCoords][POS_Y], GPSInfo[listitem][gpsCoords][POS_Z], GPSInfo[listitem][gpsName]);

            //SetGPSLocation(playerid, GPSInfo[listitem][gpsCoords][POS_X], GPSInfo[listitem][gpsCoords][POS_Y], GPSInfo[listitem][gpsCoords][POS_Z], GPSInfo[listitem][gpsName]);
        }
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

/*Dialog:gps(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        switch (listitem)
        {

        case 0: // Glavne lokacija
        {
            new string[sizeof(GPSInfo) * 20];
            string[0] = EOS;
            for__loop (new i = 0; i < sizeof(GPSInfo); i++) 
            {
                format(string_32, 32, "%s\n", GPSInfo[i][gpsName]);
                strins(string, string_32, strlen(string));
            }

            SPD(playerid, "gps_glavne", DIALOG_STYLE_LIST, "GPS - Odaberite lokaciju", string, "Odaberi", "Nazad");
        }

        case 1: // Poslovi
        {
            new job_name[20], string[512];
            string[0] = EOS;
            for__loop (new i = 0; i < GetNumberOfJobs(); i++) {
                GetJobName(i, job_name, sizeof(job_name));
                format(string, sizeof(string), "%s\n%s", string, job_name);
            }
            SPD(playerid, "gps_poslovi", DIALOG_STYLE_LIST, "Izaberite posao", string, "Odaberi", "Nazad");
        }

        case 2: // Nekretnine
        {
            SPD(playerid, "gps_nekretnina", DIALOG_STYLE_LIST, "Izaberite vrstu nekretnine", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica", "Dalje ", " Nazad");
        }

        }
    }
    return 1;
}

Dialog:gps_glavne(playerid, response, listitem, const inputtext[]) 
{
    if (response)
    {
        if (!strcmp(inputtext, "Accessory Shop", true))
        {
            // Loop kroz sve firme da se pronadju accessory shop-ovi, pa onda se oznaci jedan nasumicno
            new Iterator:iAccessoryShops<MAX_FIRMI>;
            for__loop (new i = re_globalid(firma, 1); i < re_globalid(firma, RE_GetMaxID_Business()); i++)
            {
                if (RealEstate[i][RE_VRSTA] == FIRMA_ACCESSORY)
                {
                    Iter_Add(iAccessoryShops, re_localid(firma, i));
                }
            }

            new lid = Iter_Random(iAccessoryShops);
            new gid = re_globalid(firma, lid);

            SetGPSLocation(playerid, RealEstate[gid][RE_ULAZ][POS_X], RealEstate[gid][RE_ULAZ][POS_Y], RealEstate[gid][RE_ULAZ][POS_Z], inputtext);
        }
        else
        {
            SetGPSLocation(playerid, GPSInfo[listitem][gpsCoords][POS_X], GPSInfo[listitem][gpsCoords][POS_Y], GPSInfo[listitem][gpsCoords][POS_Z], GPSInfo[listitem][gpsName]);
        }
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

Dialog:gps_poslovi(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SetJobLocation(playerid, listitem);
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

Dialog:gps_nekretnina(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SetPVarInt(playerid, "pGPSRealEstateType", listitem);

        new string[28];
        format(string, sizeof string, "{FFFFFF}Unesite ID %s:", propname(listitem, PROPNAME_GENITIV));
        SPD(playerid, "gps_nekretnina_id", DIALOG_STYLE_INPUT, "ID nekretnine", string, "Pronadji", "Nazad");
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

Dialog:gps_nekretnina_id(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "pGPSRealEstateType");
        return callcmd::gps(playerid, "");
    }

    new id, gid, propType, string[14];
    if (sscanf(inputtext, "i", id))
        return DialogReopen(playerid);

    if (id < 1)
        return DialogReopen(playerid);

    propType = GetPVarInt(playerid, "pGPSRealEstateType");
    if (propType == kuca && id > RE_GetMaxID_House())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_House());
        return DialogReopen(playerid);
    }
    if (propType == stan && id > RE_GetMaxID_Apartment())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Apartment());
        return DialogReopen(playerid);
    }
    if (propType == firma && id > RE_GetMaxID_Business())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Business());
        return DialogReopen(playerid);
    }
    if (propType == hotel && id > RE_GetMaxID_Hotel())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Hotel());
        return DialogReopen(playerid);
    }
    if (propType == garaza && id > RE_GetMaxID_Garage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Garage());
        return DialogReopen(playerid);
    }
    if (propType == vikendica && id > RE_GetMaxID_Cottage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Cottage());
        return DialogReopen(playerid);
    }

    gid = re_globalid(propType, id);
    format(string, sizeof string, "%s #%d", propname(propType, PROPNAME_LOWER), id);
    SetGPSLocation(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], string);

    DeletePVar(playerid, "pGPSRealEstateType");
    return 1;
}*/

Dialog:gpslokacije(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;

    switch(listitem)
    {
        case 0:
        {
            new string[sizeof(GPSInfo) * 20];
            string[0] = EOS;
            for__loop (new i = 0; i < sizeof(GPSInfo); i++) 
            {
                format(string_32, 32, "%s\n", GPSInfo[i][gpsName]);
                strins(string, string_32, strlen(string));
            }

            SPD(playerid, "gps_glavne", DIALOG_STYLE_LIST, "GPS - Odaberite lokaciju", string, "Odaberi", "Nazad");
        }
        case 1:
        {
            new job_name[20], string[712];
            string[0] = EOS;
            for__loop (new i = 0; i < GetNumberOfJobs(); i++) {
                GetJobName(i, job_name, sizeof(job_name));
                format(string, sizeof(string), "%s\n%s", string, job_name);
            }
            format(string, sizeof(string), "%s\nAutoindustrijalac\nVatrogasac\nVocar\nGradjevinar\nRibar", string);
            SPD(playerid, "gps_poslovi", DIALOG_STYLE_LIST, "Izaberite posao", string, "Odaberi", "Nazad");
        }
        case 2: // Nekretnine
        {
            SPD(playerid, "gps_nekretnina", DIALOG_STYLE_LIST, "Izaberite vrstu nekretnine", "Kuca\nStan\nFirma\nHotel\nGaraza\nVikendica", "Dalje ", " Nazad");
        }
        case 3:
        {
            SPD(playerid, "gps_org", DIALOG_STYLE_LIST, "/tp -> organizacije", "Policija\nEscobar Cartel\nWest End Gang\nLa Casa De Papel\nPink Panter", "Dalje ", " Nazad");
        }
    }
    return 1;
}

Dialog:gps_org(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;
    
    if(!IsAdmin(playerid, 1))
        return 1;

    switch(listitem)
    {
        case 0: SetPlayerCompensatedPos(playerid, 1544.2372, -1675.6801, 13.5580);
        case 1: SetPlayerCompensatedPos(playerid, -733.1684,974.6061,12.3594);
        case 2: SetPlayerCompensatedPos(playerid, 885.1022,-2639.7039,41.7902);
        case 3: SetPlayerCompensatedPos(playerid, 2348.0417,30.8671,26.3359);
        case 4: SetPlayerCompensatedPos(playerid, 852.2839,-1029.9764,26.5864);
    }
    return 1;
}

Dialog:gps_poslovi(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if(listitem < GetNumberOfJobs())
        {
            if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                SetJobPos(playerid, listitem);
            else
                SetJobLocation(playerid, listitem);
        }
        else
        {
            if(listitem == GetNumberOfJobs())
            {
                if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                    SetPlayerCompensatedPos(playerid, 2419.1741,-2089.7471,13.4366);
                else
                    SetGPSLocation(playerid, 2419.1741,-2089.7471,13.4366, "Autoindustrijalac");
            }
            /*else if(listitem == GetNumberOfJobs()+1)
            {
                if(IsAdmin(playerid, 1))
                    SetPlayerCompensatedPos(playerid, 1188.3307,-1312.4376,13.5641);
                else
                    SetGPSLocation(playerid, 1188.3307,-1312.4376,13.5641, "Bolnicar");
            }*/
            else if(listitem == GetNumberOfJobs()+1)
            {
                if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                    SetPlayerCompensatedPos(playerid, 1065.5499,-944.0566,42.9912);
                else
                    SetGPSLocation(playerid, 1065.5499,-944.0566,42.9912, "Vatrogasac");
            }
            else if(listitem == GetNumberOfJobs()+2)
            {
                if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                    SetPlayerCompensatedPos(playerid, -675.7363,1042.5112,12.3652);
                else
                    SetGPSLocation(playerid, -675.7363,1042.5112,12.3652, "Vocar");
            }
            else if(listitem == GetNumberOfJobs()+3)
            {
                if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                    SetPlayerCompensatedPos(playerid, 789.5940,-1354.2445,13.5469);
                else
                    SetGPSLocation(playerid, 789.5940,-1354.2445,13.5469, "Gradjevinar");
            }
            else if(listitem == GetNumberOfJobs()+4)
            {
                if(IsAdmin(playerid, 1) || IsHelper(playerid, 1))
                    SetPlayerCompensatedPos(playerid, 1216.3024,-2337.3054,14.3762);
                else
                    SetGPSLocation(playerid, 1216.3024,-2337.3054,14.3762, "Ribar");
            }
        }
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

Dialog:gps_nekretnina(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SetPVarInt(playerid, "pGPSRealEstateType", listitem);

        new string[28];
        format(string, sizeof string, "{FFFFFF}Unesite ID %s:", propname(listitem, PROPNAME_GENITIV));
        SPD(playerid, "gps_nekretnina_id", DIALOG_STYLE_INPUT, "ID nekretnine", string, "Pronadji", "Nazad");
    }
    else return callcmd::gps(playerid, "");
    return 1;
}

Dialog:gps_nekretnina_id(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "pGPSRealEstateType");
        return callcmd::gps(playerid, "");
    }

    new id, gid, propType, string[14];
    if (sscanf(inputtext, "i", id))
        return DialogReopen(playerid);

    if (id < 1)
        return DialogReopen(playerid);

    propType = GetPVarInt(playerid, "pGPSRealEstateType");
    if (propType == kuca && id > RE_GetMaxID_House())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_House());
        return DialogReopen(playerid);
    }
    if (propType == stan && id > RE_GetMaxID_Apartment())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Apartment());
        return DialogReopen(playerid);
    }
    if (propType == firma && id > RE_GetMaxID_Business())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Business());
        return DialogReopen(playerid);
    }
    if (propType == hotel && id > RE_GetMaxID_Hotel())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Hotel());
        return DialogReopen(playerid);
    }
    if (propType == garaza && id > RE_GetMaxID_Garage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Garage());
        return DialogReopen(playerid);
    }
    if (propType == vikendica && id > RE_GetMaxID_Cottage())
    {
        ErrorMsg(playerid, "Najveci moguci ID je %d.", RE_GetMaxID_Cottage());
        return DialogReopen(playerid);
    }

    gid = re_globalid(propType, id);
    format(string, sizeof string, "%s #%d", propname(propType, PROPNAME_LOWER), id);
    if(IsAdmin(playerid, 1))
        SetPlayerCompensatedPos(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2]);
    else
        SetGPSLocation(playerid, RealEstate[gid][RE_ULAZ][0], RealEstate[gid][RE_ULAZ][1], RealEstate[gid][RE_ULAZ][2], string);

    DeletePVar(playerid, "pGPSRealEstateType");
    return 1;
}


// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
/*CMD:gps(playerid, const params[]) 
{
    SPD(playerid, "gps", DIALOG_STYLE_LIST, "GPS", "Glavne lokacije\nPoslovi\nNekretnine", "Dalje ", "Izadji");
    return 1;
}*/
CMD:gps(playerid, const params[]) 
{
    if(IsAdmin(playerid, 1))
    {
        SPD(playerid, "gpslokacije", DIALOG_STYLE_LIST, "PORT", "Glavne lokacije\nPoslovi\nNekretnine\nOrganizacije", "Dalje", "Izadji");
    }
    else
        SPD(playerid, "gpslokacije", DIALOG_STYLE_LIST, "GPS", "Glavne lokacije\nPoslovi\nNekretnine", "Dalje ", "Izadji");
    
    return 1;
}