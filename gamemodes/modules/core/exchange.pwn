/*
    Zamena vozilo za vozilo:
    ako su kod targeta puni svi slotovi, zamena puca jer ce se ispisati da nema slobodnih slotova

    potrebno je ukloniti vozilo sa autopijace, ako je prethodno bilo stavljeno tamo
*/


#include <YSI_Coding\y_hooks>
// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    zamena_menja[MAX_PLAYERS], // Vrsta imovine koju menja: kuca, stan... automobil, motor...
    zamena_trazi[MAX_PLAYERS], // Vrsta imovine koju trazi: kuca, stan... automobil, motor...
    zamena_menja_slot[MAX_PLAYERS], // Slot u kome je zabelezeno vozilo koje igrac nudi u zamenu
    zamena_trazi_slot[MAX_PLAYERS], // Slot u kome je zabelezeno vozilo koje igrac trazi u zamenu
    zamena_menja_id[MAX_PLAYERS], // ID imovine u bazi (radi kontrole); za nekretnine je GLOBAL ID!  
    zamena_trazi_id[MAX_PLAYERS], // ID imovine u bazi (radi kontrole); za nekretnine je GLOBAL ID!  
    zamena_doplata[MAX_PLAYERS],
    zamena_ime[MAX_PLAYERS][MAX_PLAYER_NAME], // igrac kome se nudi zamena             
    zamena_od[MAX_PLAYERS][MAX_PLAYER_NAME],  // igrac koji je ponudio zamenu
    zamena_dialog_li[MAX_PLAYERS][6]
;




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid) {
    exchange_reset(playerid);
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) {
    if (!isnull(zamena_ime[playerid])) {
        // Igrac je nekome ponudio zamenu

        foreach (new i : Player) {
            if (!isnull(zamena_od[i]) && !strcmp(zamena_od[i], ime_rp[playerid], false)) {
                SendClientMessage(i, SVETLOCRVENA, "* Igrac koji Vam je ponudio zamenu je napustio server.");
                
                //HidePlayerDialog(i);
                exchange_reset(i);
                break;
            }
        }
    }
    if (!isnull(zamena_od[playerid])) {
        // Neko je ovom igracu ponudio zamenu

        foreach (new i : Player) {
            if (!isnull(zamena_ime[i]) && !strcmp(zamena_ime[i], ime_rp[playerid], false)) {
                SendClientMessage(i, SVETLOCRVENA, "* Igrac kome ste ponudili zamenu je napustio server.");
                
                //HidePlayerDialog(i);
                exchange_reset(i);
                break;
            }
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock exchange_reset(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("exchange_reset");
    }
        
    zamena_doplata[playerid] = 0;

    zamena_ime[playerid][0]  = 
    zamena_od[playerid][0]   = EOS;

    zamena_menja[playerid]   = 
    zamena_trazi[playerid]   =
    zamena_menja_slot[playerid] =
    zamena_trazi_slot[playerid] =
    zamena_menja_id[playerid] =
    zamena_trazi_id[playerid] = -1;
    return 1;
}

stock exchange_reset_ex(playerid_1, playerid_2)
{
    if (DebugFunctions())
    {
        LogFunctionExec("exchange_reset_ex");
    }

        
    exchange_reset(playerid_1);
    exchange_reset(playerid_2);
    return 1;
}

forward exchange_verify(playerid, targetid);
public exchange_verify(playerid, targetid) 
{
    
    if (DebugFunctions())
    {
        LogFunctionExec("exchange_verify");
    }

        
    new 
        error_txt[95], slot;
    error_txt[0] = EOS;

    if (!IsPlayerConnected(playerid) || !IsPlayerLoggedIn(playerid)) // inicijator nije na serveru
        error_txt = "Igrac koji je pokrenuo zamenu nije na serveru. (00)";

    if (!IsPlayerConnected(targetid) || !IsPlayerLoggedIn(targetid)) // Ponudjeni igrac nije na serveru
        error_txt = "Igrac kome je ponudjena zamena nije na serveru. (01)";

    if (zamena_menja[playerid] == -1 || zamena_trazi[playerid] == -1)
        error_txt = "Nije moguce odrediti vrstu imovine koja se menja. (02)";


    if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_NEKRETNINA) { // Ponudjena je nekretnina
        if (pRealEstate[playerid][zamena_menja[playerid]] == -1)
            error_txt = "Igrac ne poseduje nekretninu koju je ponudio. (03)";

        if (pRealEstate[playerid][zamena_menja[playerid]] != re_localid(zamena_menja[playerid], zamena_menja_id[playerid]))
            error_txt = "ID ponudjene nekretnine se razlikuje od ID-a koji igrac trenutno poseduje. (04)";

        if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_NEKRETNINA && zamena_trazi[playerid] != zamena_menja[playerid]) {
            // Zamena nekretnina za nekretninu, ali razlicite vrste
            // Player ne sme da poseduje ono sto trazi, a target ne sme da poseduje ono sto se menja
            if (pRealEstate[playerid][zamena_trazi[playerid]] != -1)
                error_txt = "Igrac koji je ponudio zamenu vec poseduje nekretninu koju trazi. (05)";

            if (pRealEstate[targetid][zamena_menja[playerid]] != -1)
                error_txt = "Igrac kome je ponudjena zamena vec poseduje nekretinu koja mu se nudi. (06)";
        }
        else if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_VOZILO) {
            // Nekretnina za vozilo
            // Player mora da ima slobodne slotove, a target ne sme da poseduje nekretninu koja se menja
            slot = -1;
            for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
                if (pVehicles[playerid][i] == 0) slot = i;
            }
            if (slot == -1)
                error_txt = "Igrac koji je ponudio nekretninu nema slobodnih slotova za vozilo. (07)";

            if (pRealEstate[targetid][zamena_menja[playerid]] != -1)
                error_txt = "Igrac kome je ponudjena zamena vec poseduje nekretinu koja mu se nudi. (08)";
        }
    }
    else if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_VOZILO) { // Ponudjeno je vozilo
        if (pVehicles[playerid][zamena_menja_slot[playerid]] != zamena_menja_id[playerid]) 
            error_txt = "ID ponudjenog vozila se razlikuje od ID-a koji igrac trenutno poseduje. (09)";

        if (pVehicles[playerid][zamena_menja_slot[playerid]] == 0) 
            error_txt = "Igrac koji je ponudio vozilo nema vozilo u tom slotu. (10)";

        // playerid je ponudio vozilo. Da li targetid ima slobodan slot?
        slot = -1;
        for__loop (new i = PI[targetid][p_vozila_slotovi]-1; i >= 0 ; i--) {
            if (pVehicles[targetid][i] == 0) slot = i;
        }
        if (slot == -1 && imovina_vrsta(zamena_trazi[playerid]) != IMOVINA_VOZILO)
            error_txt = "Igrac kome je ponudjena zamena nema slobodnih slotova za vozilo. (11)";
             // detektovace da nema slobodan slot, ali samo ako nije zamena vozilo-za-vozilo

        if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_NEKRETNINA) {
            // Vozilo za nekretninu
            // Player ne sme da poseduje nekretninu koju trazi, a target mora da ima slobodne slotove
            if (pRealEstate[playerid][zamena_trazi[playerid]] != -1)
                error_txt = "Igrac koji je ponudio vozilo vec poseduje nekretninu koju trazi. (12)";

            slot = -1;
            for__loop (new i = PI[targetid][p_vozila_slotovi]-1; i >= 0 ; i--) {
                if (pVehicles[targetid][i] == 0) slot = i;
            }
            if (slot == -1) 
                error_txt = "Igrac kome je ponudjena zamena nema slobodnih slotova za vozilo. (13)";
        }
    }
    else return 0;


    if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_NEKRETNINA) { // Trazi se nekretnina
        if (pRealEstate[targetid][zamena_trazi[playerid]] == -1) 
            error_txt = "Igrac kome je ponudjena zamena ne poseduje nekretninu koja se trazi. (14)";

        if (pRealEstate[targetid][zamena_trazi[playerid]] != re_localid(zamena_trazi[playerid], zamena_trazi_id[playerid])) 
            error_txt = "ID trazene nekretnine se razlikuje od ID-a koji ponudjeni igrac trenutno poseduje. (15)";
    }
    else if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_VOZILO) { // Trazi se vozilo
        if (pVehicles[targetid][zamena_trazi_slot[playerid]] != zamena_trazi_id[playerid]) 
            error_txt = "ID trazenog vozila se razlikuje od ID-a koji ponudjeni igrac trenutno poseduje. (16)";

        if (pVehicles[targetid][zamena_trazi_slot[playerid]] == 0)
            error_txt = "Ponudjeni igrac nema vozilo na trazenom slotu. (17)";

        // playerid je trazi vozilo od targetid. Da li playerid ima slobodan slot?
        slot = -1;
        for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
            if (pVehicles[playerid][i] == 0) slot = i;
        }
        if (slot == -1 && imovina_vrsta(zamena_menja[playerid]) != IMOVINA_VOZILO) 
            error_txt = "Igrac koji je ponudio zamenu nema slobodnih slotova za vozilo. (18)";
            // detektovace da su svi slotovi puni, ali samo ako nije zamena vozilo-za-vozilo
    }
    else return 0;

    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    if (!IsPlayerInRangeOfPoint(targetid, 10.0, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2])) // Previse udaljeni jedan od drugog
        error_txt = "Igraci su previse udaljeni. (19)";

    if (PI[targetid][p_novac] < zamena_doplata[playerid]) 
        error_txt = "Igrac kome je ponudjena zamena nema dovoljno novca. (20)";

    if (!isnull(error_txt)) {
        SendClientMessage(playerid,   TAMNOCRVENA2, "Dogodila se greska prilikom zamene imovine.");
        SendClientMessageF(playerid,  TAMNOCRVENA2, "* Informacije o gresci: {FFFFFF}%s", error_txt);
        SendClientMessage(targetid,   TAMNOCRVENA2, "Dogodila se greska prilikom zamene imovine.");
        SendClientMessageF(targetid,  TAMNOCRVENA2, "* Informacije o gresci: {FFFFFF}%s", error_txt);
        return 0;
    }

    return 1;
}

stock exchange_active(playerid) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "exchange_active");
    #endif
        
    if (!isnull(zamena_ime[playerid]) || !isnull(zamena_od[playerid]))
        return true;

    return false;
}

stock exchange_set_menja_id(playerid, value) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "exchange_set_menja_id");
    #endif
        
    zamena_menja_id[playerid] = value;
    return 1;
}

stock exchange_set_menja_slot(playerid, value) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "exchange_set_menja_slot");
    #endif
        
    zamena_menja_slot[playerid] = value;
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:imovina_zamena_1(playerid, response, listitem, const inputtext[])
{    
    new
        vrsta = uredjuje[playerid][UREDJUJE_VRSTA], // Kuca/stan/.../automobil/motor/...
        kategorija = imovina_vrsta(vrsta), // Nekretnina/vozilo
        naslov[39],
        targetid
    ;

    if (!response) {
        exchange_reset(playerid);

        if (kategorija == IMOVINA_NEKRETNINA)
            return dialog_respond:re_general(playerid, 1, 1, "");
        else 
            return callcmd::vozila(playerid, "");
    }

    if (vrsta == -1) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (01)");
    
    if (kategorija == IMOVINA_NEPOZNATO)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (02)");

    if (sscanf(inputtext, "u", targetid) || targetid == playerid)
        return DialogReopen(playerid);

    if ((kategorija == IMOVINA_VOZILO       && pVehicles[playerid][zamena_menja_slot[playerid]] == -1) ||
        (kategorija == IMOVINA_NEKRETNINA   && pRealEstate[playerid][vrsta] == -1)) {
        
        format(string_64, 64, "Ne posedujete %s.", propname(vrsta, PROPNAME_AKUZATIV));
        return ErrorMsg(playerid, string_64);
    }
    
    if (!IsPlayerConnected(targetid))  {
        format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [1/5]", propname(vrsta, PROPNAME_UPPER));
        SPD(playerid, "imovina_zamena_1", DIALOG_STYLE_INPUT, naslov, "{FF0000}* Igrac cije ste ime ili ID uneli trenutno nije na serveru.\n\n{FFFFFF}\
            Upisite ime ili ID igraca sa kojim zelite da zamenite imovinu:", "Dalje -", "- Nazad");
            
        return 1;
    }
    
    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    if (!IsPlayerInRangeOfPoint(targetid, 10.0, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]))
    {
        format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [1/5]", propname(vrsta, PROPNAME_UPPER));
        SPD(playerid, "imovina_zamena_1", DIALOG_STYLE_INPUT, naslov, "{FF0000}* Taj igrac se ne nalazi u Vasoj blizini.\n\n{FFFFFF}Upisite ime ili ID igraca \
            sa kojim zelite da zamenite imovinu:", "Dalje -", "- Nazad");

        return 1;
    }

    if ((kategorija == IMOVINA_NEKRETNINA   && PI[targetid][p_nivo] < RealEstate[zamena_menja_id[playerid]][RE_NIVO]) || (kategorija == IMOVINA_VOZILO       && PI[targetid][p_nivo] < 3))
        return ErrorMsg(playerid, "Drugi igrac nema dovoljno visok nivo da bi mogao da ucestvuje u zameni.");

    new minSec = 50 * 3600;
    if (PI[targetid][p_provedeno_vreme] < minSec)
        return ErrorMsg(playerid, "Taj igrac mora imati najmanje 50 sati igre. Trenutno ima %i sati igre.", floatround(PI[targetid][p_provedeno_vreme]/3600.0));

    // ---------- //

    zamena_menja[playerid] = vrsta, 
    zamena_trazi[playerid] = -1, 
    zamena_doplata[playerid] = 0,
    strmid(zamena_ime[playerid], ime_rp[targetid], 0, strlen(ime_rp[targetid]), MAX_PLAYER_NAME);

    format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [2/5]", propname(vrsta, PROPNAME_UPPER));
    SPD(playerid, "imovina_zamena_2", DIALOG_STYLE_LIST, naslov, "Izaberite za sta zelite da se zamenite:\nKuca\nStan\nFirma\nHotel\nGaraza\nVozilo", "Dalje -", "- Nazad");

    return 1;
}
Dialog:imovina_zamena_2(playerid, response, listitem, const inputtext[])
{       
    new 
        vrsta = uredjuje[playerid][UREDJUJE_VRSTA], // Kuca/stan/.../automobil/motor/...
        kategorija = imovina_vrsta(vrsta), // Nekretnina/vozilo
        naslov[39],
        targetid = get_player_id(zamena_ime[playerid], rp_ime);

    if (!IsPlayerConnected(targetid)) {
        exchange_reset(playerid);
        return ErrorMsg(playerid, "Igrac je napustio server.");
    }

    if (!response) {
        format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [1/5]", propname(vrsta, PROPNAME_UPPER));
        SPD(playerid, "imovina_zamena_1", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite ime ili ID igraca sa kojim zelite da zamenite imovinu:", "Dalje -", "- Nazad");
    }
        
    if (listitem == 0)
        return DialogReopen(playerid);

    if (vrsta == -1) {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (03)");
    }
    
    if (kategorija == IMOVINA_NEPOZNATO) {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (04)");
    }
    
    switch (listitem) {
        case 1..5: { // Nekretnine
            zamena_trazi[playerid] = listitem - 1;
            if (pRealEstate[targetid][zamena_trazi[playerid]] == -1) {
                exchange_reset_ex(playerid, targetid);
                return ErrorMsg(playerid, "Igrac nema imovinu koju zelite.");
            }

            zamena_trazi_id[playerid] = re_globalid(zamena_trazi[playerid], pRealEstate[targetid][zamena_trazi[playerid]]);
            if (PI[playerid][p_nivo] < RealEstate[zamena_trazi_id[playerid]][RE_NIVO]) { 
                exchange_reset_ex(playerid, targetid);
                return ErrorMsg(playerid, "Nemate dovoljno veliki nivo za nekretninu koju zelite.");
            }

            if (zamena_menja[playerid] != zamena_trazi[playerid]) { // Ne menja za istu imovinu, proveriti za dupliranje
                if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_NEKRETNINA) {
                    // Menja nekretninu za neku drugu (razlicitu) nekretninu (npr. kucu za stan)
                    if (pRealEstate[playerid][zamena_trazi[playerid]] != -1) {
                        // Igrac vec poseduje ono sto trazi (pr. stan)
                        SendClientMessageF(playerid, TAMNOCRVENA2, "Vec posedujete %s.", propname(zamena_trazi[playerid], PROPNAME_AKUZATIV));
                        return exchange_reset(playerid);
                    }

                    if (pRealEstate[targetid][zamena_menja[playerid]] != -1) {
                        // Drugi igrac poseduje ono sto mu prvi nudi (pr. kucu)
                        SendClientMessageF(playerid, TAMNOCRVENA2, "Drugi igrac vec poseduje %s.", propname(zamena_menja[playerid], PROPNAME_AKUZATIV));
                        return exchange_reset(playerid);
                    }
                }
                else // Menja vozilo za nekretninu
                {
                    new slot = -1;
                    for__loop (new i = PI[targetid][p_vozila_slotovi]-1; i >= 0 ; i--) 
                    {
                        if (pVehicles[targetid][i] == 0) slot = i;
                    }
                    if (slot == -1) 
                    {
                        exchange_reset(playerid);
                        return ErrorMsg(playerid, "Drugi igrac nema slobodnih slotova za vozila.");
                    }

                    if (pRealEstate[playerid][zamena_trazi[playerid]] != -1) 
                    {
                        // Igrac vec poseduje nekretninu koju trazi
                        SendClientMessageF(playerid, TAMNOCRVENA2, "Vec posedujete %s.", propname(zamena_trazi[playerid], PROPNAME_AKUZATIV));
                        return exchange_reset(playerid);
                    }
                }
            }

            format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [3/5]", propname(vrsta, PROPNAME_UPPER));
            SPD(playerid, "imovina_zamena_3", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite iznos koji zelite da Vam ovaj igrac doplati:", "Dalje -", "- Nazad");
        }
        case 6: // Vozilo
        {
            new sDialog[425];
            format(sDialog, 30, "Slot\tVozilo\tModel\tTablice");
            
            new item = 0;
            for__loop (new i = 0; i < PI[targetid][p_vozila_slotovi]; i++) 
            {
                if (pVehicles[targetid][i] == 0) continue; // prazan slot
                
                new veh = pVehicles[targetid][i];
                format(sDialog, sizeof sDialog, "%s\n%d\t%s\t%s\t%s", sDialog, i+1, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], OwnedVehicle[veh][V_PLATE]);

                zamena_dialog_li[playerid][item++] = i; // belezi se koji je slot
            }
            
            if (item == 0) 
            {
                exchange_reset_ex(playerid, targetid);
                return ErrorMsg(playerid, "Taj igrac ne poseduje ni jedno vozilo.");
            }

            if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_NEKRETNINA) 
            {
                // Menja nekretninu za vozilo
                // Da li player ima slobodan slot za vozilo
                // Da li target vec poseduje nekretninu

                new slot = -1;
                for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) 
                {
                    if (pVehicles[playerid][i] == 0) slot = i;
                }
                if (slot == -1) {
                    exchange_reset(playerid);
                    return ErrorMsg(playerid, "Nemate slobodnih slotova za vozila.");
                }

                if (pRealEstate[targetid][zamena_menja[playerid]] != -1) 
                {
                    // Drugi igrac vec poseduje nekretninu koju ovaj nudi
                    SendClientMessageF(playerid, TAMNOCRVENA2, "Drugi igrac vec poseduje %s", propname(zamena_menja[playerid], PROPNAME_AKUZATIV));
                    return exchange_reset(playerid);
                }
            }

            format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [2/5]", propname(vrsta, PROPNAME_UPPER));
            SPD(playerid, "imovina_zamena_2_5", DIALOG_STYLE_TABLIST_HEADERS, naslov, sDialog, "Dalje -", "- Nazad");
        }
        default: {
            exchange_reset(playerid);
            return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (05)");
        }
    }
    return 1;
}

Dialog:imovina_zamena_2_5(playerid, response, listitem, const inputtext[]) {
    new targetid = get_player_id(zamena_ime[playerid], rp_ime);

    if (!IsPlayerConnected(targetid)) {
        exchange_reset(playerid);
        return ErrorMsg(playerid, "Igrac je napustio server.");
    }

    if (!response) 
        return dialog_respond:imovina_zamena_1(playerid, 1, 0, ime_obicno[targetid]);

    new
        vrsta = uredjuje[playerid][UREDJUJE_VRSTA], // Kuca/stan/.../automobil/motor/...
        kategorija = imovina_vrsta(vrsta), // Nekretnina/vozilo
        naslov[39]
    ;

    if (vrsta == -1)  {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (06)");
    }
    
    if (kategorija == IMOVINA_NEPOZNATO) {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (07)");
    }

    zamena_trazi_slot[playerid] = zamena_dialog_li[playerid][listitem];
    if (zamena_trazi_slot[playerid] < 0 || zamena_trazi_slot[playerid] >= 6) {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (08)");
    }

    zamena_trazi_id[playerid] = pVehicles[targetid][zamena_trazi_slot[playerid]];
    if (zamena_trazi_id[playerid] <= 0) {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "Igrac ne poseduje vozilo na izabranom slotu.");
    }

    zamena_trazi[playerid] = OwnedVehicle[zamena_trazi_id[playerid]][V_TYPE];

    format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [3/5]", propname(vrsta, PROPNAME_UPPER));
    SPD(playerid, "imovina_zamena_3", DIALOG_STYLE_INPUT, naslov, "{FFFFFF}Upisite iznos koji zelite da Vam ovaj igrac doplati:", "Dalje -", "- Nazad");
    return 1;
}

Dialog:imovina_zamena_3(playerid, response, listitem, const inputtext[]) {
    if (uredjuje[playerid][UREDJUJE_VRSTA] == -1)  {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (09)");
    }

    new
        kategorija = imovina_vrsta(zamena_menja[playerid]),
        naslov[39],
        sDialog[452],
        cena,
        targetid = get_player_id(zamena_ime[playerid], rp_ime)
    ;
        
    if (!response) 
    {
        format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [2/5]", propname(zamena_menja[playerid], PROPNAME_UPPER));
        return SPD(playerid, "imovina_zamena_2", DIALOG_STYLE_LIST, naslov, "Izaberite za sta zelite da se zamenite:\nKuca\nStan\nFirma\nHotel\nGaraza\nVozilo", "Dalje -", "- Nazad");
    }

    if (!IsPlayerConnected(targetid)) 
    {
        exchange_reset(playerid);
        return ErrorMsg(playerid, "Igrac je napustio server.");
    }
    
    if (sscanf(inputtext, "i", cena) || cena < 0 || cena > 99999999)
        return DialogReopen(playerid);

    zamena_doplata[playerid] = cena;

    new menja_id, trazi_id;
    if (kategorija == IMOVINA_NEKRETNINA) 
        menja_id = re_localid(zamena_menja[playerid], zamena_menja_id[playerid]);
    else if (kategorija == IMOVINA_VOZILO) 
        menja_id = zamena_menja_id[playerid];
    else {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (10)");
    }

    if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_NEKRETNINA)
        trazi_id = re_localid(zamena_trazi[playerid], zamena_trazi_id[playerid]);
    else if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_VOZILO)
        trazi_id = zamena_trazi_id[playerid];
    else {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (11)");
    }

    
    format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [4/5]", propname(zamena_menja[playerid], PROPNAME_UPPER));
    format(sDialog, sizeof sDialog, "{FFFFFF}Igrac: {0068B3}%s\n{FFFFFF}Imovina koju nudite: {0068B3}%s (id: %d)\n{FFFFFF}Imovina koju trazite: {0068B3}%s (id: %d)\n{FFFFFF}Iznos koji cete dobiti: {0068B3}%s\n\n{FFFFFF}Pre nego sto potvrdite zamenu, obavezno slikajte ekran (F8). Zalbe u slucaju bilo kakvih\nproblema sa imovinom nece biti uvazene bez ove slike!\n\n{FF0000}Da li zaista zelite da zamenite imovinu sa ovim igracem?", 
        zamena_ime[playerid], propname(zamena_menja[playerid], PROPNAME_CAPITAL), menja_id, propname(zamena_trazi[playerid], PROPNAME_CAPITAL), trazi_id, formatMoneyString(zamena_doplata[playerid]));
    SPD(playerid, "imovina_zamena_4", DIALOG_STYLE_MSGBOX, naslov, sDialog, "Dalje -", "- Nazad");

    // Belezenje ponude za zamenu u log
    new sLog[187];
    format(sLog, sizeof sLog, "Dialog: PONUDA [1/2] | Igrac 1: %s | Igrac 2: %s | Ponudjeno: %s (%d) | Trazi se: %s (%d) | Doplata: $%d", ime_obicno[playerid], ime_obicno[targetid], propname(zamena_menja[playerid], PROPNAME_LOWER), menja_id, propname(zamena_trazi[playerid], PROPNAME_LOWER), trazi_id, zamena_doplata[playerid]);
    Log_Write(LOG_ZAMENA, sLog);
    
    return 1;
}
Dialog:imovina_zamena_4(playerid, response, listitem, const inputtext[])
{
    if (uredjuje[playerid][UREDJUJE_VRSTA] == -1)  
    {
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (12)");
    }

    new
        naslov[39],
        sDialog[485],
        targetid = get_player_id(zamena_ime[playerid], rp_ime)
    ;
        
    if (!response)
    {
        if (!IsPlayerConnected(targetid))
            return exchange_reset(playerid);
        else 
            return exchange_reset_ex(playerid, targetid);
    }
    
    if (IsPlayerConnected(targetid) && !isnull(zamena_od[targetid]))
        return ErrorMsg(playerid, "Igrac kome ste ponudili zamenu vec ima aktivnu zamenu sa drugim igracem.");
        
    if (strcmp(zamena_od[targetid], ime_rp[playerid], false)) 
    {
        // Inicijator zamene i ime u varijabli igraca kome se nudi zamena se ne podudaraju
        exchange_reset(playerid);
        return SendClientMessage(playerid, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (13)");
    }
    
    if (!exchange_verify(playerid, targetid)) 
        return exchange_reset_ex(playerid, targetid);
    
    
    strmid(zamena_od[targetid], ime_rp[playerid], 0, strlen(ime_rp[playerid]), MAX_PLAYER_NAME);
    

    new menja_id, trazi_id;
    if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_NEKRETNINA) 
        menja_id = re_localid(zamena_menja[playerid], zamena_menja_id[playerid]);
    else if (imovina_vrsta(zamena_menja[playerid]) == IMOVINA_VOZILO) 
        menja_id = zamena_menja_id[playerid];
    else {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (14)");
    }

    if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_NEKRETNINA)
        trazi_id = re_localid(zamena_trazi[playerid], zamena_trazi_id[playerid]);
    else if (imovina_vrsta(zamena_trazi[playerid]) == IMOVINA_VOZILO)
        trazi_id = zamena_trazi_id[playerid];
    else {
        exchange_reset_ex(playerid, targetid);
        return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (15)");
    }
    
    format(naslov, sizeof(naslov), "{0068B3}%s - ZAMENA [5/5]", propname(zamena_menja[playerid], PROPNAME_UPPER));
    format(sDialog, sizeof sDialog, "{FFFFFF}Igrac {0068B3}%s {FFFFFF}Vam je ponudio zamenu imovine.\n\n{FFFFFF}Imovina koju dobijate: {0068B3}%s (%d)\n{FFFFFF}Imovina koju dajete: {0068B3}%s (%d)\nIznos koji treba da doplatite: {0068B3}%s\n\n{FFFFFF}Pre nego sto potvrdite zamenu, obavezno slikajte ekran (F8). Zalbe u slucaju bilo kakvih\nproblema sa imovinom nece biti uvazene bez ove slike!\n\n{FF0000}Da li zaista zelite da zamenite imovinu sa ovim igracem?", 
        ime_rp[playerid], propname(zamena_menja[playerid], PROPNAME_CAPITAL), menja_id, propname(zamena_trazi[playerid], PROPNAME_CAPITAL), trazi_id, formatMoneyString(zamena_doplata[playerid]));
    SPD(targetid, "imovina_zamena_potvrda", DIALOG_STYLE_MSGBOX, naslov, sDialog, "Zameni", "Odbaci");

    // Belezenje ponude za zamenu u log
    new sLog[188];
    format(sLog, sizeof sLog, "Dialog: PONUDA [2/2] | Igrac 1: %s | Igrac 2: %s | Ponudjeno: %s (%d) | Trazi se: %s (%d) | Doplata: $%d", ime_obicno[playerid], ime_obicno[targetid], propname(zamena_menja[playerid], PROPNAME_LOWER), menja_id, propname(zamena_trazi[playerid], PROPNAME_LOWER), trazi_id, zamena_doplata[playerid]);
    Log_Write(LOG_ZAMENA, sLog);
    
    return 1;
}
Dialog:imovina_zamena_potvrda(playerid, response, listitem, const inputtext[]) 
{
    new
        pokretac    = get_player_id(zamena_od[playerid], rp_ime), // ID igraca koji je pokrenuo/inicirao zamenu
        ponudjeni   = playerid, // ID igraca kome je ponudjena zamena
        vrsta_menja = zamena_menja[pokretac], // Vrsta imovine koja je ponudjena u zamenu od strane inicijatora
        vrsta_trazi = zamena_trazi[pokretac] // Vrsta imovine koju inicijator trazi u zamenu
    ;     
    
    
    if (!response)
    {

        // Odbio zamenu
        if (IsPlayerConnected(pokretac)) 
        {
            SendClientMessage(pokretac, SVETLOCRVENA, "* Igrac kome ste ponudili zamenu ju je odbio.");
            exchange_reset(pokretac);
        }
        exchange_reset(ponudjeni);
        return 1;
    }
    
    
    if (IsPlayerConnected(pokretac)) 
    {
        if (isnull(zamena_ime[pokretac])) 
        {
            SendClientMessage(ponudjeni, TAMNOCRVENA2, "[exchange.pwn] "GRESKA_NEPOZNATO" (16)");
            return exchange_reset(ponudjeni);
        }
        else if (strcmp(zamena_ime[pokretac], ime_rp[ponudjeni], false)) 
        {
            ErrorMsg(ponudjeni, "Igrac koji Vam je ponudio zamenu ima vec aktivnu zamenu sa drugim igracem."); 
            return exchange_reset(ponudjeni);
        }
    }
    else 
    {
        ErrorMsg(ponudjeni, "Igrac koji Vam je ponudio zamenu je napustio server.");
        return exchange_reset(ponudjeni);
    }
        

    if (!exchange_verify(pokretac, ponudjeni) )
        return exchange_reset_ex(pokretac, ponudjeni);


    //////////////////////////////////////////////////////////////////////////////////////////////////////////


    if (imovina_vrsta(vrsta_menja) == IMOVINA_NEKRETNINA && imovina_vrsta(vrsta_trazi) == IMOVINA_NEKRETNINA) 
    {
        // Nekretnina za nekretninu

        // Zamena imena vlasnika
        strmid(RealEstate[zamena_menja_id[pokretac]][RE_VLASNIK], ime_obicno[ponudjeni], 0, strlen(ime_obicno[ponudjeni]), MAX_PLAYER_NAME);
        strmid(RealEstate[zamena_trazi_id[pokretac]][RE_VLASNIK], ime_obicno[pokretac], 0, strlen(ime_obicno[pokretac]), MAX_PLAYER_NAME);

        // Zamena ID-eva u promenljivoj
        pRealEstate[pokretac][vrsta_menja] = -1;
        pRealEstate[pokretac][vrsta_trazi] = re_localid(vrsta_trazi, zamena_trazi_id[pokretac]);
        pRealEstate[ponudjeni][vrsta_trazi] = -1;
        pRealEstate[ponudjeni][vrsta_menja] = re_localid(vrsta_menja, zamena_menja_id[pokretac]);

        // Update pickupa
        re_kreirajpickup(vrsta_menja, zamena_menja_id[pokretac]);
        re_kreirajpickup(vrsta_trazi, zamena_trazi_id[pokretac]);

        // Update podataka igraca u bazi
        format(mysql_upit, 80, "UPDATE igraci SET %s = -1, %s = %d WHERE id = %d", propname(vrsta_menja, PROPNAME_LOWER), propname(vrsta_trazi, PROPNAME_LOWER), pRealEstate[pokretac][vrsta_trazi], PI[pokretac][p_id]);
        mysql_tquery(SQL, mysql_upit);
        format(mysql_upit, 80, "UPDATE igraci SET %s = -1, %s = %d WHERE id = %d", propname(vrsta_trazi, PROPNAME_LOWER), propname(vrsta_menja, PROPNAME_LOWER), pRealEstate[ponudjeni][vrsta_menja], PI[ponudjeni][p_id]);
        mysql_tquery(SQL, mysql_upit);

        // Update podataka nekretnina u bazi
        format(mysql_upit, 80, "UPDATE %s SET vlasnik = '%s' WHERE id = %d", propname(vrsta_menja, PROPNAME_TABLE), RealEstate[zamena_menja_id[pokretac]][RE_VLASNIK], re_localid(vrsta_menja, zamena_menja_id[pokretac]));
        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
        format(mysql_upit, 80, "UPDATE %s SET vlasnik = '%s' WHERE id = %d", propname(vrsta_trazi, PROPNAME_TABLE), RealEstate[zamena_trazi_id[pokretac]][RE_VLASNIK], re_localid(vrsta_trazi, zamena_trazi_id[pokretac]));
        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
    }
    else if (imovina_vrsta(vrsta_menja) == IMOVINA_VOZILO && imovina_vrsta(vrsta_trazi) == IMOVINA_VOZILO) { 
        // Vozilo za vozilo

        // Trazenje odgovarajucih slotova + zamena ID-eva u promenljivoj
        new pokretac_slot = -1, ponudjeni_slot = -1;
        for__loop (new i = PI[pokretac][p_vozila_slotovi]-1; i >= 0 ; i--) 
        {
            if (pVehicles[pokretac][i] == zamena_menja_id[pokretac]) 
            {
                pokretac_slot = i;
                break;
            }
        }
        for__loop (new i = PI[ponudjeni][p_vozila_slotovi]-1; i >= 0 ; i--) 
        {
            if (pVehicles[ponudjeni][i] == zamena_trazi_id[pokretac]) 
            {
                ponudjeni_slot = i;
                break;
            }
        }
        if (pokretac_slot == -1 || ponudjeni_slot == -1) 
        {
            exchange_reset_ex(pokretac, ponudjeni);
            return ErrorMsg(playerid, "[exchange.pwn] "GRESKA_NEPOZNATO" (17)");
        }
        pVehicles[pokretac][pokretac_slot] = zamena_trazi_id[pokretac];
        pVehicles[ponudjeni][ponudjeni_slot] = zamena_menja_id[pokretac];


        // Zamena vlasnika
        OwnedVehicle[zamena_menja_id[pokretac]][V_OWNER_ID] = PI[ponudjeni][p_id];
        OwnedVehicle[zamena_trazi_id[pokretac]][V_OWNER_ID] = PI[pokretac][p_id];
        strmid(OwnedVehicle[zamena_menja_id[pokretac]][V_OWNER_NAME], ime_obicno[ponudjeni], 0, strlen(ime_obicno[ponudjeni]), MAX_PLAYER_NAME);
        strmid(OwnedVehicle[zamena_trazi_id[pokretac]][V_OWNER_NAME], ime_obicno[pokretac], 0, strlen(ime_obicno[pokretac]), MAX_PLAYER_NAME);

        // Update podataka vozila u bazi
        format(mysql_upit, 100, "UPDATE vozila SET vlasnik = %d, vlasnik_ime = '%s' WHERE id = %d", OwnedVehicle[zamena_menja_id[pokretac]][V_OWNER_ID], OwnedVehicle[zamena_menja_id[pokretac]][V_OWNER_NAME], zamena_menja_id[pokretac]);
        mysql_tquery(SQL, mysql_upit);
        format(mysql_upit, 100, "UPDATE vozila SET vlasnik = %d, vlasnik_ime = '%s' WHERE id = %d", OwnedVehicle[zamena_trazi_id[pokretac]][V_OWNER_ID], OwnedVehicle[zamena_trazi_id[pokretac]][V_OWNER_NAME], zamena_trazi_id[pokretac]);
        mysql_tquery(SQL, mysql_upit);
    }

    else if ((imovina_vrsta(vrsta_menja) == IMOVINA_VOZILO && imovina_vrsta(vrsta_trazi) == IMOVINA_NEKRETNINA)
        ||   (imovina_vrsta(vrsta_trazi) == IMOVINA_VOZILO && imovina_vrsta(vrsta_menja) == IMOVINA_NEKRETNINA)) 
    {
        // Vozilo za nekretninu ili nekretnina za vozilo

        new 
            menja_nekretninu, menja_vozilo, nekretnina_id, vozilo_id, nekretnina_vrsta, vozilo_slot;
        // Odredjujemo ko daje nekretninu, a ko vozilo, i nadalje vise ne koristimi ponudjeni/pokretac
        if (imovina_vrsta(vrsta_menja) == IMOVINA_VOZILO) 
        {
            menja_vozilo        = pokretac; // ID igraca koji daje vozilo, a prima nekretninu
            vozilo_id           = zamena_menja_id[pokretac]; // ID vozila koje se predaje
            vozilo_slot         = zamena_menja_slot[pokretac]; // Slot SA KOGA se vozilo predaje,kod onoga ko DAJE
            menja_nekretninu    = ponudjeni; // ID igraca koji daje nekretninu, a prima vozilo
            nekretnina_id       = zamena_trazi_id[pokretac]; // globalni id nekretnine koja se predaje
            nekretnina_vrsta    = vrsta_trazi; // Vrsta nekretnine koja se predaje
        }
        else 
        {
            menja_vozilo        = ponudjeni; // ID igraca koji daje vozilo, a prima nekretninu
            vozilo_id           = zamena_trazi_id[pokretac]; // ID vozila koje se predaje
            vozilo_slot         = zamena_trazi_slot[pokretac]; // Slot SA KOGA se vozilo predaje,kod onoga ko DAJE
            menja_nekretninu    = pokretac; // ID igraca koji daje nekretninu, a prima vozilo
            nekretnina_id       = zamena_menja_id[pokretac]; // globalni id nekretnine koja se predaje
            nekretnina_vrsta    = vrsta_menja; // Vrsta nekretnine koja se predaje
        }

        // Trazenje praznog slota za vozila kod igraca koji prima vozilo, a daje nekretninu
        new slot = -1;
        for__loop (new i = PI[menja_nekretninu][p_vozila_slotovi]-1; i >= 0 ; i--) 
        {
            if (pVehicles[menja_nekretninu][i] == 0) slot = i;
        }
        if (slot == -1) 
            return ErrorMsg(playerid, "Igrac koji treba da dobije vozilo nema slobodnih slotova za vozila.");

        // Promena/brisanje vlasnistva
        pRealEstate[menja_vozilo][nekretnina_vrsta] = pRealEstate[menja_nekretninu][nekretnina_vrsta];
        pRealEstate[menja_nekretninu][nekretnina_vrsta] = -1;
        pVehicles[menja_nekretninu][slot] = pVehicles[menja_vozilo][vozilo_slot];
        pVehicles[menja_vozilo][vozilo_slot] = 0;

        strmid(RealEstate[nekretnina_id][RE_VLASNIK], ime_obicno[menja_vozilo], 0, strlen(ime_obicno[menja_vozilo]), MAX_PLAYER_NAME);
        strmid(OwnedVehicle[vozilo_id][V_OWNER_NAME], ime_obicno[menja_nekretninu], 0, strlen(ime_obicno[menja_nekretninu]), MAX_PLAYER_NAME);
        OwnedVehicle[vozilo_id][V_OWNER_ID] = PI[menja_nekretninu][p_id];

        // Update pickupa
        re_kreirajpickup(nekretnina_vrsta, nekretnina_id);


        // Update podataka igraca u bazi
        // Upiti za nekretninu
        format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET %s = %d WHERE id = %d", propname(nekretnina_vrsta, PROPNAME_LOWER), re_localid(nekretnina_vrsta, nekretnina_id), PI[menja_vozilo][p_id]);
        mysql_tquery(SQL, mysql_upit);
        format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET %s = -1 WHERE id = %d", propname(nekretnina_vrsta, PROPNAME_LOWER), PI[menja_nekretninu][p_id]);
        mysql_tquery(SQL, mysql_upit);
        // Upiti za vozilo
        format(mysql_upit, 75, "UPDATE vozila SET vlasnik = %d WHERE id = %d and vlasnik = %d", PI[menja_nekretninu][p_id], vozilo_id, PI[menja_vozilo][p_id]);
        mysql_tquery(SQL, mysql_upit);

        // Update podataka o imovini
        format(mysql_upit, 85, "UPDATE %s SET vlasnik = '%s' WHERE id = %d", propname(nekretnina_vrsta, PROPNAME_TABLE), RealEstate[nekretnina_id][RE_VLASNIK], re_localid(nekretnina_vrsta, nekretnina_id));
        mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_REALESTATEUPDATE);
        format(mysql_upit, 100, "UPDATE vozila SET vlasnik = %d, vlasnik_ime = '%s' WHERE id = %d", OwnedVehicle[vozilo_id][V_OWNER_ID], OwnedVehicle[vozilo_id][V_OWNER_NAME], vozilo_id);
        mysql_tquery(SQL, mysql_upit);
    }

    // Dodavanje/oduzimanje novca i update podataka u bazi
    PlayerMoneySub(ponudjeni, zamena_doplata[pokretac]);
    PlayerMoneyAdd(pokretac,  zamena_doplata[pokretac]);
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", PI[pokretac][p_novac], PI[pokretac][p_id]);
    mysql_tquery(SQL, mysql_upit);
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", PI[ponudjeni][p_novac], PI[ponudjeni][p_id]);
    mysql_tquery(SQL, mysql_upit);
    

    
    // Slanje poruka igracima
    SendClientMessageF(ponudjeni, SVETLOPLAVA, "Uspesno ste izvrsili zamenu imovine sa igracem {FFFFFF}%s.", ime_rp[pokretac]);
    SendClientMessageF(ponudjeni, SVETLOPLAVA, "Zamenili ste {FFFFFF}%s {33CCFF}za {FFFFFF}%s {33CCFF}i doplatili {FFFFFF}$%d", propname(zamena_trazi[pokretac], PROPNAME_AKUZATIV), propname(zamena_menja[pokretac], PROPNAME_AKUZATIV), zamena_doplata[pokretac]);
    
    SendClientMessageF(pokretac, SVETLOPLAVA, "Uspesno ste izvrsili zamenu imovine sa igracem {FFFFFF}%s.", ime_rp[ponudjeni]);
    SendClientMessageF(pokretac, SVETLOPLAVA, "Zamenili ste {FFFFFF}%s {33CCFF}za {FFFFFF}%s {33CCFF}i dobili {FFFFFF}$%d", propname(zamena_menja[pokretac], PROPNAME_AKUZATIV), propname(zamena_trazi[pokretac], PROPNAME_AKUZATIV), zamena_doplata[pokretac]);

    // Upisivanje u log
    new 
        sLog[195],
        menja_id = (imovina_vrsta(zamena_menja[pokretac]) == IMOVINA_NEKRETNINA)? re_localid(zamena_menja[pokretac], zamena_menja_id[pokretac]) : zamena_menja_id[pokretac], 
        trazi_id = (imovina_vrsta(zamena_trazi[pokretac]) == IMOVINA_NEKRETNINA)? re_localid(zamena_trazi[pokretac], zamena_trazi_id[pokretac]) : zamena_trazi_id[pokretac];
    format(sLog, sizeof sLog, "Dialog: REALIZACIJA | Igrac 1: %s | Igrac 2: %s | Ponudjeno: %s (%d) | Trazi se: %s (%d) | Doplata: $%d", ime_obicno[pokretac], ime_obicno[ponudjeni], propname(zamena_menja[pokretac], PROPNAME_LOWER), menja_id, propname(zamena_trazi[pokretac], PROPNAME_LOWER), trazi_id, zamena_doplata[pokretac]);
    Log_Write(LOG_ZAMENA, sLog);
    
    exchange_reset_ex(ponudjeni, pokretac);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
