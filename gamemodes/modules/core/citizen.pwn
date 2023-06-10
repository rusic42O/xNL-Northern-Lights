#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    gPayLimit[MAX_PLAYERS char],
    bool:gSeatbeltState[MAX_PLAYERS char]
;

new const gAccents[21][13] = { "Nista", "Americki", "Australijski", "Arapski", "Azijski", "Britanski", "Brazilski", "Balkanski", "Francuski", "Gangsterski", "Irski", "Italijanski", "Jamajkanski", "Japanski", "Kineski", "Kanadski", "Nemacki", "Ruski", "Skotski", "Spanski", "Turski" };

new gMaleSkins[] = { 136,236 };
new gFemaleSkins[] = { 38,13 };

// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	CreateDynamic3DTextLabel("/poslovi", BELA, -2590.8232,2592.7944,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/dozvole", BELA, -2590.7407,2597.4629,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/pasos", BELA, -2592.6440,2602.5408,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/registracija", BELA, -2590.7322,2588.1689,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/orgkazna", BELA, -2592.6440,2583.1599,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/promeniime", BELA, -2601.0806,2584.8738,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/rtcmycar\nCena: $30.000", BELA, -2610.3477,2584.8767,-97.9256, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/doniraj", BELA, -2600.7781,2599.9341,-97.9156, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 1, 1);
    CreateDynamic3DTextLabel("/zlatara", BELA, 599.3881, -1458.0909, 14.3721, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (newstate == PLAYER_STATE_DRIVER) 
    {
        new 
            vehicleid = GetPlayerVehicleID(playerid), // ID novog vozila
            modelid   = GetVehicleModel(vehicleid) // Model novog vozila
        ;

        if (IsVehicleHelicopter(modelid) && !IsAdmin(playerid, 6)) 
        {
            if (PI[playerid][p_dozvola_letenje] == -1) 
            {
                ErrorMsg(playerid, "Nemate dozvolu za letenje, ne mozete voziti ovu letelicu. Dozvolu mozete izvaditi u opstini."), 
                isteraj(playerid);
                return 1;
            }
        }
        else if (IsVehicleBoat(modelid) && !IsAdmin(playerid, 6) && !IsPlayerInRace(playerid)) 
        {
            if (PI[playerid][p_dozvola_plovidba] == -1) 
            {
                ErrorMsg(playerid, "Nemate dozvolu za plovidbu, ne mozete voziti ovaj brod. Dozvolu mozete izvaditi u opstini.");
                isteraj(playerid);
                return 1;
            }
        }
        else 
        {
            if (!IsVehicleBicycle(vehicleid)) 
            {
                if (!IsAdmin(playerid, 6)) 
                {
                    if (PI[playerid][p_dozvola_voznja] == -1) 
                        SendClientMessage(playerid, SVETLOCRVENA, "UPOZORENJE | {FF0000}Nemate vozacku dozvolu, cuvajte se policije.");
                }
            }
        }
    }

    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        Citizen_SetSeatbeltState(playerid, false);
    }
    return 1;
}

hook OnPlayerSpawn(playerid)
{
    Citizen_SetSeatbeltState(playerid, false);
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
Citizen_SetSeatbeltState(playerid, bool:toggle)
{
    gSeatbeltState{playerid} = toggle;
}

Citizen_GetSeatbeltState(playerid)
{
    return gSeatbeltState{playerid};
}

GetPlayerCorrectSkin(playerid)
{
    if (IsOnDuty(playerid))
    {
        if (PI[playerid][p_admin] > 5) {
            return 171;
        }
        if (PI[playerid][p_admin] > 0) {
            return 189;
        }
        if (PI[playerid][p_helper] > 0)
        {
            return 171;
        }
    }
        
    if(IsPlayerInHorrorEvent(playerid)) 
    {
        return 264;
    }

    if (PI[playerid][p_skin] == -1)
    {
        // Igracu nije postavljen nikakav poseban skin

        if (PI[playerid][p_org_id] == -1)
        {
            // Igrac nije ni u jednoj organizaciji -> postaviti mu neki
            PI[playerid][p_skin] = GetRandomCivilianSkin(PI[playerid][p_pol]);

            new query[47];
            format(query, sizeof query, "UPDATE igraci SET skin = %i WHERE id = %i", PI[playerid][p_skin], PI[playerid][p_id]);
            mysql_tquery(SQL, query);

            return PI[playerid][p_skin];
        }
        else
        {
            return GetFactionSkin(PI[playerid][p_org_id], PI[playerid][p_org_rank]);
        }
    }
    else
    {
        return PI[playerid][p_skin];
    }
}

GetRandomCivilianSkin(gender)
{

    if (gender == POL_ZENSKO) 
    {
        return gFemaleSkins[random(sizeof gFemaleSkins)];
    }
    else
    {
        return gMaleSkins[random(sizeof gMaleSkins)];
    }
}

IsPlayerMale(playerid)
{
    return (PI[playerid][p_pol] == POL_MUSKO);
}

/*GetFirstMaleSkin()
{
    return gMaleSkins[0];
}*/

GetAverageGoldCurrency()
{
    return 10000;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:borilacke_vestine(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new fightingStyle, stil[14];
        if (listitem == 0)      
        { 
            fightingStyle = FIGHT_STYLE_NORMAL;    
            stil = "Normalni";        
        }
        else if (listitem == 1) 
        { 
            fightingStyle = FIGHT_STYLE_BOXING;    
            stil = "Box";             
        }
        else if (listitem == 2) 
        { 
            fightingStyle = FIGHT_STYLE_KUNGFU;    
            stil = "Kung Fu";         
        }
        else if (listitem == 3) 
        { 
            fightingStyle = FIGHT_STYLE_KNEEHEAD;  
            stil = "KneeHead";        
        }
        else if (listitem == 4) 
        { 
            fightingStyle = FIGHT_STYLE_GRABKICK;  
            stil = "Grab 'n' Kick";   
        }
        else if (listitem == 5) 
        { 
            fightingStyle = FIGHT_STYLE_ELBOW;     
            stil = "Elbow";           
        }

        SetPlayerFightingStyle(playerid, fightingStyle); 
        SendClientMessageF(playerid, SVETLOPLAVA, "* Stil borbe je promenjen na {FFFFFF}%s.", stil);

        new sQuery[52];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET stil_borbe = %d WHERE id = %d", fightingStyle, PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
    }
    return 1;
}

Dialog:dozvole_kupovina(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;
    switch (listitem) 
    {
        case 0: // Dozvola za letenje
        {
            if (PI[playerid][p_novac] < 50000)
                return ErrorMsg(playerid, "Nemate dovoljno novca za kupovinu ove dozvole.");

            PI[playerid][p_dozvola_letenje] = 1;
            PlayerMoneySub(playerid, 50000);
            SendClientMessage(playerid, SVETLOPLAVA, "* Kupili ste dozvolu za letenje.");

            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_letenje = 1 WHERE id = %d", PI[playerid][p_id]);
        }

        case 1: // Dozvola za plovidbu
        {
            if (PI[playerid][p_novac] < 30000)
                return ErrorMsg(playerid, "Nemate dovoljno novca za kupovinu ove dozvole.");

            PI[playerid][p_dozvola_plovidba] = 1;
            PlayerMoneySub(playerid, 30000);
            SendClientMessage(playerid, SVETLOPLAVA, "* Kupili ste dozvolu za plovidbu.");

            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_plovidba = 1 WHERE id = %d", PI[playerid][p_id]);
        }

        case 2: // Dozvola za oruzje
        {
            if (PI[playerid][p_novac] < 25000)
                return ErrorMsg(playerid, "Nemate dovoljno novca za kupovinu ove dozvole.");

            PI[playerid][p_dozvola_oruzje] = 1;
            PlayerMoneySub(playerid, 25000);
            SendClientMessage(playerid, SVETLOPLAVA, "* Kupili ste dozvolu za oruzje.");

            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET dozvola_oruzje = 1 WHERE id = %d", PI[playerid][p_id]);
        }

        default: return 1;
    }
    mysql_tquery(SQL, mysql_upit);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pokazidozvole(playerid, const params[]) 
{
    new targetid;
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "pokazidozvole [Ime ili ID igraca]");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, GRESKA_PREDALEKO);

    new sDialog[290];
    format(sDialog, sizeof sDialog, "\
        ___________________________________________________\n\
        Status dozvola {FFFF80}%s:\n\
        - {%s}Vozacka dozvola\n\
        - {%s}Dozvola za letenje\n\
        - {%s}Dozvola za plovidbu\n\
        - {%s}Dozvola za oruzje", ime_rp[playerid], 
        (PI[playerid][p_dozvola_voznja]>0)?("00FF00"):("FF0000"), 
        (PI[playerid][p_dozvola_letenje]>0)?("00FF00"):("FF0000"), 
        (PI[playerid][p_dozvola_plovidba]>0)?("00FF00"):("FF0000"),
        (PI[playerid][p_dozvola_oruzje]>0)?("00FF00"):("FF0000"));

    SetPVarInt(targetid, "licenseShownID", playerid);
    SPD(targetid, "pokazidozvole", DIALOG_STYLE_MSGBOX, "Dozvole", sDialog, "U redu", "");
    format(string_128, sizeof string_128, "** %s pokazuje futrolu sa svojim dozvolama sluzbeniku %s.", ime_rp[playerid], ime_rp[targetid]);
    RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
    return 1;
}

CMD:dozvole(playerid, const params[]) 
{
    if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2590.7407,2597.4629,-97.9156))
        return ErrorMsg(playerid, "Morate biti u opstini da biste kupili dozvole.");

    return SPD(playerid, "dozvole_kupovina", DIALOG_STYLE_TABLIST, "Kupovina dozvola", "Dozvola za letenje\t$50.000\nDozvola za plovidbu\t$30.000\nDozvola za oruzje\t$25.000", "Kupi", "Odustani");
}

CMD:borilacke_vestine(playerid, const params[])
{
    SPD(playerid, "borilacke_vestine", DIALOG_STYLE_LIST, "Borilacke vestine", "Normalni\nBox\nKung Fu\nKneeHead\nGrab 'n' Kick\nElbow", "Izaberi", "Odustani");
    return 1;
}

CMD:dajoruzje(playerid, const params[])
{
    if (PI[playerid][p_nivo] < 4)
        return ErrorMsg(playerid, "Morate biti nivo 4 da biste koristili ovu naredbu.");

    if (IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate izaci iz vozila da biste koristili ovu komandu.");

    if (IsPlayerOnLawDuty(playerid))
        return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete nista ostaviti u ranac.");

    new targetid, ammo, weaponid, weapon[22];
    if (sscanf(params, "ui", targetid, ammo))
        return Koristite(playerid, "dajoruzje [Ime ili ID igraca] [Kolicina metaka]");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, targetid) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Niste dovoljno blizu tog igraca.");

    if (PI[targetid][p_nivo] < 4)
        return ErrorMsg(playerid, "Taj igrac mora biti nivo 4 da biste mogli da mu date oruzje.");

    if (ammo < 1 || ammo > 1000)
        return ErrorMsg(playerid, "Kolicina metaka mora biti izmedju 1 i 1000.");

    weaponid = GetPlayerWeapon(playerid);


    if (weaponid < 1 || weaponid > 46 || weaponid == 19 || weaponid == 20 || weaponid == 21) 
        return ErrorMsg(playerid, "Ne drzite oruzje u rukama ili pokusavate da date nedozvoljeno oruzje.");

    if (GetPlayerAmmoInSlot(playerid, GetSlotForWeapon(weaponid)) < ammo)
        return ErrorMsg(playerid, "Nemate dovoljno municije.");
        
    GivePlayerWeapon(targetid, weaponid, ammo);
    SetPlayerAmmo(playerid, weaponid, GetPlayerAmmoInSlot(playerid, GetSlotForWeapon(weaponid)) - ammo);
    
    GetWeaponName(weaponid, weapon, sizeof weapon);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Dali ste %s sa %d metaka igracu %s.", weapon, ammo, ime_rp[targetid]);
    SendClientMessageF(targetid, SVETLOPLAVA, "* %s Vam je dao %s sa %d metaka.", ime_rp[playerid], weapon, ammo);

    return 1;
}

CMD:plati(playerid, const params[]) 
{
    // Provera parametara
    new 
        id, 
        iznos
    ;

    if (PI[playerid][p_nivo] < 2)
        return ErrorMsg(playerid, "Morate biti najmanje nivo 2 da biste koristili ovu naredbu.");    

    if (sscanf(params, "ui", id, iznos)) 
        return Koristite(playerid, "plati [Ime ili ID igraca] [Iznos (max. $10.000)]");
        
    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);
        
    GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, pozicija[id][0], pozicija[id][1], pozicija[id][2]) || GetPlayerState(id) == PLAYER_STATE_SPECTATING) 
        return ErrorMsg(playerid, GRESKA_PREDALEKO);
        
    if ((!IsAdmin(playerid, 6) && iznos > 10000) || iznos < 1) // Ako nije head admin, ne moze da da vise od 10000; ILI ne moze da da manje od 1, sta god da je 
        return ErrorMsg(playerid, "Unesite iznos izmedju $1 i $10.000.");
        
    if (PI[playerid][p_novac] < iznos) 
        return ErrorMsg(playerid, "Nemate toliko novca.");

    if (PI[playerid][p_reload_pay] > gettime())
        return ErrorMsg(playerid, "Poslali ste previse novca. Sacekajte %s sledeceg slanja.", konvertuj_vreme(PI[playerid][p_reload_pay] - gettime()));
        
    // Slanje poruka igracima
    SendClientMessageF(playerid, SVETLOPLAVA, "* Poslali ste %s igracu %s.", formatMoneyString(iznos), ime_rp[id]);
    SendClientMessageF(id, SVETLOPLAVA, "* Primili ste %s od igraca %s.", formatMoneyString(iznos), ime_rp[playerid]);
    
    gPayLimit{playerid} ++;
    if (gPayLimit{playerid} >= 3)
    {
        gPayLimit{playerid} = 0;
        PI[playerid][p_reload_pay] = gettime() + 15*60; // 15min cooldown

        new query[256];
        format(query, sizeof query, "UPDATE igraci SET reload_pay = %i WHERE id = %i", PI[playerid][p_reload_pay], PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }

    // Sredjivanje novca
    PlayerMoneyAdd(id, iznos);
    PlayerMoneySub(playerid, iznos);
    
    // Slanje poruke igracima u okolini
    format(string_128, sizeof string_128, "** %s vadi novcanik, uzima nesto novca i predaje ga %s.", ime_rp[playerid], ime_rp[id]);
    RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Izvrsio: %s | Igrac: %s | Iznos: %s", ime_obicno[playerid], ime_obicno[id], formatMoneyString(iznos));
    Log_Write(LOG_PLACANJA, string_128);
    return 1;
}

CMD:isteraj(playerid, const params[]) 
{
    new id;
    if (sscanf(params, "u", id)) 
        return Koristite(playerid, "isteraj [Ime ili ID igraca]");
            
    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (id == playerid)
        return ErrorMsg(playerid, "Ne mozete isterati sami sebe.");

    if (IsPlayerInAnyVehicle(playerid))
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
            return ErrorMsg(playerid, "Samo vozac moze da izbacuje iz vozila.");
            
        // Provera parametara
        if (GetPlayerVehicleID(id) != GetPlayerVehicleID(playerid)) 
            return ErrorMsg(playerid, "Taj igrac se ne nalazi u Vasem vozilu.");
            
            
        // Glavna funkcija komande
        GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
        SetPlayerPos(id, pozicija[id][0]+3.0, pozicija[id][1], pozicija[id][2]+0.5);
        
        // Slanje poruka igracima
        SendClientMessageF(playerid, SVETLOPLAVA, "* Izbacili ste %s iz svog vozila.", ime_rp[id]);
        SendClientMessageF(id, ZUTA, "* %s Vas je izbacio iz svog vozila.", ime_rp[playerid]);
    }

    else // Igrac nije u vozilu
    {
        if (!IsACop(playerid)) // Ako nije policajac, nema pravo da izbacuje ako nije u vozilu
            return ErrorMsg(playerid, "Ne nalazite se u vozilu.");

        if (!IsPlayerOnLawDuty(playerid))
            return ErrorMsg(playerid, "Morate biti na duznosti.");

        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
            return ErrorMsg(playerid, "Ne mozete koristiti ovu komandu sada.");

        if (!IsPlayerNearPlayer(playerid, id, 6.0) || GetPlayerState(id) == PLAYER_STATE_SPECTATING)
            return ErrorMsg(playerid, "Ne nalazite se blizu tog igraca.");

        new Float:velocity[3], vehicleid = GetPlayerVehicleID(id);
        GetVehicleVelocity(vehicleid, velocity[0], velocity[1], velocity[2]);

        if (velocity[0] != 0.0 || velocity[1] != 0.0 || velocity[2] != 0.0)
            return ErrorMsg(playerid, "Ne mozete izbaciti igraca iz vozila u pokretu.");

        GetPlayerPos(id, pozicija[id][0], pozicija[id][1], pozicija[id][2]);
        SetPlayerPos(id, pozicija[id][0]+3.0, pozicija[id][1], pozicija[id][2]+0.5);

        SendClientMessageF(playerid, SVETLOPLAVA, "* Izvukli ste %s iz njegovog vozila.", ime_rp[id]);
        SendClientMessageF(id, ZUTA, "* %s Vas je izvukao iz vozila.", ime_rp[playerid]); 
    }
    return 1;
}

alias:pojas("stavipojas")
CMD:pojas(playerid, const params[])
{
    if (!IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Morate biti u vozilu da biste koristili pojas.");

    if (IsVehicleMotorbike(GetVehicleModel(GetPlayerVehicleID(playerid))))
        return ErrorMsg(playerid, "Ne mozete koristiti pojas na motoru.");

    if (IsVehicleBicycle(GetVehicleModel(GetPlayerVehicleID(playerid))))
        return ErrorMsg(playerid, "Ne mozete koristiti pojas na biciklu.");

    new sMsg[58];
    Citizen_SetSeatbeltState(playerid, !Citizen_GetSeatbeltState(playerid));
    if (Citizen_GetSeatbeltState(playerid))
    {
        GameTextForPlayer(playerid, "~N~~N~~N~~G~~H~POJAS ZAKOPCAN", 5000, 3);
        format(sMsg, sizeof sMsg, "* %s vezuje sigurnosni pojas.", ime_rp[playerid]);
    }
    else
    {
        GameTextForPlayer(playerid, "~N~~N~~N~~R~~H~POJAS OTKOPCAN", 5000, 3);
        format(sMsg, sizeof sMsg, "* %s odvezuje sigurnosni pojas.", ime_rp[playerid]);
    }

    RangeMsg(playerid, sMsg, LJUBICASTA, 10.0);
    return 1;
}

CMD:doniraj(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2600.7781,2599.9341,-97.9156))
        return ErrorMsg(playerid, "Morate biti u opstini da biste donirali drzavi novac.");

    SPD(playerid, "doniraj", DIALOG_STYLE_INPUT, "DONACIJA", "{FFFFFF}Deo Vaseg novca ce biti raspodeljen siromasnim gradjanima.\n\nUpisite koliko novca zelite da donirate:", "Potvrdi", "Odustani");
    return 1;
}

Dialog:doniraj(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new money;
        if (sscanf(inputtext, "i", money) || money < 1 || money > 99999999)
            return DialogReopen(playerid);

        if (money < 200000)
            return ErrorMsg(playerid, "Minimalan iznos za donaciju je $200.000.");

        if (PI[playerid][p_novac] < money)
            return ErrorMsg(playerid, "Nemate toliko novca.");

        new sMsg[130];
        format(sMsg, sizeof sMsg, "DONACIJA | Gradjanin "#STEEL_BLUE"%s[%i] "#SLATE_BLUE"je donirao drzavi: {FFFF00}%s.", ime_rp[playerid], playerid, formatMoneyString(money));
        SendClientMessageToAll(COLOR_SLATE_BLUE, sMsg);
        SendClientMessageToAll(COLOR_STEEL_BLUE, "* Njegova donacija je raspodeljena svim siromasnim gradjanima.");


        // Brojanje siromasnih igraca i odredjivanje cifre koju ce oni dobiti
        new poorCitizens = 0;
        foreach (new i : Player)
        {
            if (IsPlayerLoggedIn(i))
            {
                if ((PI[i][p_novac]+PI[i][p_banka]) < 200000)
                {
                    poorCitizens ++;
                }
            }
        }
        new donateToPoor = floatround(money/100000.0);
        if (donateToPoor > 100000) donateToPoor = 100000;
        if (donateToPoor < 0) donateToPoor = 0;

        if (1 <= donateToPoor <= 100000)
        {
            foreach (new i : Player)
            {
                if (IsPlayerLoggedIn(i))
                {
                    if ((PI[i][p_novac]+PI[i][p_banka]) < 200000)
                    {
                        PlayerMoneyAdd(i, donateToPoor);
                        SendClientMessageF(i, COLOR_STEEL_BLUE, "** Dobili ste "#SLATE_BLUE"%s "#STEEL_BLUE"od donacije gradjanina.", formatMoneyString(donateToPoor));
                    }
                }
            }
        }

        PlayerMoneySub(playerid, money);
        PI[playerid][p_donacije] += money;

        new sDialog[130];
        format(sDialog, sizeof sDialog, "{FFFFFF}Grad Los Santos i svi gradjani su vam zahvalni na velikodusnosti!\n\nDo sada ste ukupno donirali: {FFFF00}%s", formatMoneyString(PI[playerid][p_donacije]));
        SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "HVALA", sDialog, "U redu", "");


        new sQuery[94];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, donacije = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_donacije], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[40];
        format(sLog, sizeof sLog, "%s | %s", ime_obicno[playerid], formatMoneyString(money));
        Log_Write(LOG_DONATIONS, sLog);
    }
    return 1;
}

CMD:zlatara(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 7.0, 599.3881, -1458.0909, 14.3721))
        return ErrorMsg(playerid, "Ovu naredbu mozes koristiti samo u zlatari.");

    new sDialog[160];
    format(sDialog, sizeof sDialog, "{FFFFFF}Stanje zlata: {FFFF00}%i zlatnika\n\n{FFFFFF}Kupovni kurs: {FFFF00}%s\n{FFFFFF}Srednji kurs: {FF9900}%s\n{FFFFFF}Prodajni kurs: {FFFF00}%s", PI[playerid][p_zlato], formatMoneyString(floatround(GetAverageGoldCurrency()*0.8)), formatMoneyString(floatround(GetAverageGoldCurrency()*1.0)), formatMoneyString(floatround(GetAverageGoldCurrency()*1.2)));

    SPD(playerid, "zlato_info", DIALOG_STYLE_MSGBOX, "{FFFF00}ZLATARA - MENJACNICA", sDialog, "Dalje", "Zatvori");

    return 1;
}

Dialog:zlato_info(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        SPD(playerid, "zlato_menjacnica", DIALOG_STYLE_LIST, "{FFFF00}ZLATARA - MENJACNICA", "Prodaj zlatnike\nKupi zlatnike", "Dalje", "Zatvori");
    }
    return 1;
}

Dialog:zlato_menjacnica(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0)
        {
            // Prodaj zlatnike
            new sDialog[128];
            format(sDialog, sizeof sDialog, "{FFFFFF}Kupovni kurs menjacnice: {FFFF00}%s\n\n{FFFFFF}Upisi koliko zlatnika zelis da prodas i zamenis za pravi novac:", formatMoneyString(floatround(GetAverageGoldCurrency()*0.8)));
            SPD(playerid, "zlato_prodaj", DIALOG_STYLE_INPUT, "{FFFF00}PRODAJ ZLATNIKE", sDialog, "Prodaj", "Odustani");
        }

        else if (listitem == 1)
        {
            // Kupi zlatnike
            new sDialog[128];
            format(sDialog, sizeof sDialog, "{FFFFFF}Prodajni kurs menjacnice: {FFFF00}%s\n\n{FFFFFF}Upisi koliko zlatnika zelis da kupis pravim novcem:", formatMoneyString(floatround(GetAverageGoldCurrency()*1.2)));
            SPD(playerid, "zlato_kupi", DIALOG_STYLE_INPUT, "{FFFF00}KUPI ZLATNIKE", sDialog, "Kupi", "Odustani");
        }
    }
    else return callcmd::zlatara(playerid, "");
    return 1;
}

Dialog:zlato_prodaj(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new input;

        if (sscanf(inputtext, "i", input))
            return DialogReopen(playerid);

        if (input < 1 || input > 10000)
            return DialogReopen(playerid);

        if (PI[playerid][p_zlato] < input)
            return ErrorMsg(playerid, "Nemas toliko zlatnika.");

        new currency = floatround(GetAverageGoldCurrency()*0.8);

        PI[playerid][p_zlato] -= input;
        PlayerMoneyAdd(playerid, input*currency);

        SendClientMessageF(playerid, ZUTA, "(zlatara) Prodao si %i zlatnika za %s | {FF9900}Stanje zlata: %i.", input, formatMoneyString(currency*input), PI[playerid][p_zlato]);
         
        new sQuery[71];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, zlato = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[80];
        format(sLog, sizeof sLog, "PRODAJA | %s | %i zlatnika | Kurs: %s", ime_obicno[playerid], input, formatMoneyString(currency));
        Log_Write(LOG_ZLATNICI, sLog);
//        ShowInfoBoxMainGui(playerid, true, true);//update
    }
    else return callcmd::zlatara(playerid, "");
    return 1;
}

Dialog:zlato_kupi(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new input;

        if (sscanf(inputtext, "i", input))
            return DialogReopen(playerid);

        if (input < 1 || input > 5000)
            return DialogReopen(playerid);

        if ((PI[playerid][p_zlato]+input) > 5000)
            return ErrorMsg(playerid, "Mozes nositi najvise 5000 zlatnika sa sobom.");

        new currency = floatround(GetAverageGoldCurrency()*1.2);

        if (PI[playerid][p_novac] < (currency * input))
            return ErrorMsg(playerid, "Nemas dovoljno novca.");

        PI[playerid][p_zlato] += input;
        PlayerMoneySub(playerid, input*currency);

        SendClientMessageF(playerid, ZUTA, "(zlatara) Kupio si %i zlatnika za %s | {FF9900}Stanje zlata: %i.", input, formatMoneyString(currency*input), PI[playerid][p_zlato]);

        new sQuery[71];
        format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, zlato = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[80];
        format(sLog, sizeof sLog, "KUPOVINA | %s | %i zlatnika | Kurs: %s", ime_obicno[playerid], input, formatMoneyString(currency));
        Log_Write(LOG_ZLATNICI, sLog);
//        ShowInfoBoxMainGui(playerid, true, true);//update
    }
    else return callcmd::zlatara(playerid, "");
    return 1;
}