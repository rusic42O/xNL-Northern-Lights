#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
    bool:AutoPM[MAX_PLAYERS char],                   
    AutoPMTekst[MAX_PLAYERS][145],
    PrimioPM[MAX_PLAYERS],
    bool:procitao_pm[MAX_PLAYERS char]
;
static 
    gSentPMs[MAX_PLAYERS],
    gReceivedPM[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid) 
{
    procitao_pm{playerid} = false;
    PrimioPM[playerid] = -1;
    AutoPM{playerid} = false;
    gSentPMs[playerid] = 0;
    gReceivedPM[playerid] = 0;
}

hook OnPlayerSpawn(playerid) 
{
    prikazi_pm(playerid, 0);
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
GetSentPMsBy(playerid)
{
    return gSentPMs[playerid];
}

forward prikazi_pm(playerid, cmd);
public prikazi_pm(playerid, cmd)
{
    if (DebugFunctions())
    {
        LogFunctionExec("prikazi_pm");
    }


    if (procitao_pm{playerid} && cmd == 0) return 1;

    format(mysql_upit, sizeof mysql_upit, "SELECT id, poslao, tekst FROM pm WHERE primalac = '%s' AND status = 0 LIMIT 6", ime_obicno[playerid]);
    mysql_tquery(SQL, mysql_upit, "mysql_offpm", "iii", playerid, cmd, cinc[playerid]);

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_offpm(playerid, cmd, ccinc);
forward mysql_offpm_posalji(playerid, ime[MAX_PLAYER_NAME], string[110], ccinc);

public mysql_offpm(playerid, cmd, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_offpm");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows) {
        procitao_pm{playerid} = true; // Nema novih poruka -> postavi na procitano da se funkcija ne bi pozivala na svakom spawnu igraca
        if (cmd == 1) // Ukucao /procitajpm
            ErrorMsg(playerid, "Nemate neprocitane poruke u svom sanducetu.");

        return 1;
    }
    new 
        string[1024],
        pm_id = -1, 
        pm_poslao[MAX_PLAYER_NAME], 
        pm_tekst[120], 
        rez;

    format(string, 61, "{FF0000}* PRIMILI STE NOVE PORUKE DOK STE BILI OFFLINE\n\n\n");
    format(mysql_upit, sizeof mysql_upit, "UPDATE pm SET status = 1 WHERE id = -1");

    rez = (rows == 6)? 5 : rows;
    for__loop (new i = 0; i < rez; i++) { // SELECT uzima 6 row-ova, loop ide kroz 5 najvise, nikad kroz 6 (6 je samo za proveru da li ima jos PM-ova)
        cache_get_value_index_int(i, 0, pm_id);
        cache_get_value_index(i, 1, pm_poslao);
        cache_get_value_index(i, 2, pm_tekst);

        if (strlen(pm_tekst) > 80) strins(pm_tekst, "-\n", 81);
        format(string_256, 180, "{FFFF00}Poruka od: %s\n%s\n\n", pm_poslao, pm_tekst);
        strins(string, string_256, strlen(string));

        format(string_32, 16, " OR id = %d", pm_id);
        strins(mysql_upit, string_32, strlen(mysql_upit));
    }
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_PMUPDATE); // Update statusa na "procitano" (value = 1)

    if (rows > 5) // Ima vise od 5 PM-ova
        strins(string, "{FF9900}Ostalo Vam je jos neprocitanih poruka. Da biste ih procitali, koristite /procitajpm.", strlen(string));
    else 
        procitao_pm{playerid} = true;

    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Nove poruke", string, "Zatvori", "");

    return 1;
}
public mysql_offpm_posalji(playerid, ime[MAX_PLAYER_NAME], string[110], ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_offpm_posalji");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows || rows > 1) {
        ErrorMsg(playerid, "Igrac sa tim imenom ne postoji u bazi podataka!");
        SendClientMessage(playerid, GRAD2, "Zapamtite da ime mora sadrzati crticu ( _ ) i da je osetljivo na mala i velika slova.");
        return 1;
    }

    new ugasen;
    cache_get_value_index_int(0, 0, ugasen);
    if (ugasen == 1) 
        return ErrorMsg(playerid, "Taj igrac je blokirao offline PM chat!");

    if (strlen(string) < 10 || strlen(string) > 120) 
        return ErrorMsg(playerid, "Tekst mora biti dugacak izmedju 10 i 120 slova!");

    new id = get_player_id(ime, obicno_ime);
    
    if (IsPlayerConnected(id)) 
        return ErrorMsg(playerid, "Taj igrac je sada u igri, koristite /pm.");

    mysql_escape_string(string, string);
    mysql_format(SQL, mysql_upit, 256, "INSERT INTO pm (poslao, primalac, tekst, status) VALUES ('%s', '%s', '%s', 0)", ime_obicno[playerid], ime, string);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_OFFPM);

    if (!IsAdmin(playerid, 6)) PI[playerid][p_offpm_vreme] = gettime() + 600;
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste poslali PM igracu %s. PM ce mu se prikazati cim bude usao u igru.", ime);
    SendClientMessageF(playerid, BELA, "** Tekst: %s", string);

    // Slanje poruke adminima
    AdminMsg(ZLATNA, "OFF PM | %s[%d] » %s: %s", ime_rp[playerid], playerid, ime, string);

    // Upisivanje u log
    format(string_256, sizeof string_256, "OFF | Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime, string);
    Log_Write(LOG_PLAYERPM, string_256);

    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:pm(playerid, const params[])
{
    if (!IsHelper(playerid, 1) && !IsVIP(playerid, 3))
    {
        ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        InfoMsg(playerid, "Koristite /sms da posaljete poruku drugom igracu.");
        return 1;
    }
    
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);

    if (PI[playerid][p_area] > 0)
        return overwatch_poruka(playerid, GRESKA_AREA);

    // Provera parametara
    new 
        id,
        tekst[145]
    ;
    if (sscanf(params, "us[110]", id, tekst)) 
        return Koristite(playerid, "pm [Ime ili ID igraca] [Tekst poruke]");
        
    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (gReceivedPM[id] > gettime() && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, " Sacekajte nekoliko sekundi ukoliko i dalje zelite da posaljete PM. (anti spam)");

    if (PI[id][p_admin] || PI[id][p_helper])
        return overwatch_poruka(playerid, GRESKA_VIPADMIN);
        
    // if (strlen(tekst) >= 70)
    // {
    //     // Ovaj blok sluzi da zameni deo teksta sa "[...]" ako je on previse dugacak
    //     // To je tekst koji se ispisuje staffu, dok je tekst koji se ispisuje igracu u normalnom formatu, bez secenja
    //     new 
    //         duzi_za, 
    //         brisanje_od, 
    //         brisanje_do
    //     ;
    //     strcpy(tekst_novi, tekst);
    //     duzi_za     = strlen(tekst) - 70;
    //     brisanje_od = strlen(tekst) - duzi_za - 18;
    //     brisanje_do = strlen(tekst) - 10;
    //     strdel(tekst_novi, brisanje_od, brisanje_do);
    //     strins(tekst_novi, " [...] ", strlen(tekst_novi)-10);
    // }
        

    // Formatiranje poruke na osnovu admin/helper levela
    // Provere sa head admin status nema nigde jer je on u sklopu svih provera, ukljucujuci i prvu (level 6 admin)
    if (IsHelper(playerid, 1))
    {
        if (IsAdmin(playerid, 6))
        {
            SendClientMessageF(id, SVETLOPLAVA, "Head admin %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, tekst);
        }
        else if (IsAdmin(playerid, 1))
        {
            SendClientMessageF(id, SVETLOPLAVA, "Game Admin %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, tekst);
        }
        else if (IsHelper(playerid, 1))
        {
            SendClientMessageF(id, ZELENOZUTA, "Helper %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, tekst);
        }

        // Slanje poruke staffu
        StaffMsg(TAMNOCRVENA2, "PM | %s[%d] » %s[%d]: {FFFFFF}%s", ime_rp[playerid], playerid, ime_rp[id], id, tekst);
        
        // Upisivanje u log
        format(string_256, 180, "Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime_obicno[id], tekst);
        Log_Write(LOG_STAFFPM, string_256);

        gSentPMs[playerid] ++;
        gReceivedPM[id] = gettime() + 2;
    }
    else
    {
        if (PI[playerid][p_nivo] < 3) 
            return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste koristili privatne poruke.");
        
        if (!hPM{id}) 
            return ErrorMsg(playerid, "Taj igrac je blokirao privatne poruke!");

        if (IsHelper(id, 1))
            return ErrorMsg(playerid, "Ne mozete slati private poruke Staff-u.");
            
        zastiti_chat(playerid, tekst);

        // Slanje poruke igracu
        SendClientMessageF(id, 0x7197B0FF, "* (( PM od %s: %s ))", ime_rp[playerid], tekst);
        SendClientMessage(playerid, BELA, "* Poruka je poslata.");
        
        // Slanje poruke staffu
        AdminMsg(ZLATNA, "PM | %s[%d] » %s[%d]: %s", ime_rp[playerid], playerid, ime_rp[id], id, tekst);
        
        PrimioPM[id] = playerid;
        if (AutoPM{id})
            SendClientMessageF(playerid, 0x7197B0FF, "* (( Auto-PM od %s: %s ))", ime_rp[id], AutoPMTekst[id]);
        
        // Upisivanje u log
        format(string_256, 180, "Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime_obicno[id], tekst);
        Log_Write(LOG_PLAYERPM, string_256);
    }
    return 1;
}

CMD:hpm(playerid, const params[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    // Provera parametara
    new 
        id,
        tekst[145]
    ;
    if (sscanf(params, "us[110]", id, tekst)) 
        return Koristite(playerid, "hpm [Ime ili ID igraca] [Tekst poruke]");
        
    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);
    
    SendClientMessageF(id, SVETLOPLAVA, "Head admin %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, tekst);
    HeadMsg(CRVENA, "HPM {DC143C}| %s[%d] » %s[%d]: {FFFFFF}%s", ime_rp[playerid], playerid, ime_rp[id], id, tekst);
    // SendClientMessage(playerid, BELA, "Poruka je poslata.");
    
    // Upisivanje u log
    format(string_256, 180, "(H-PM) Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime_obicno[id], tekst);
    Log_Write(LOG_STAFFPM, string_256);
    return 1;
}

CMD:apm(const playerid, const params[145])
{
    if (!IsHelper(playerid, 1)) 
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    // Provera parametara
    new 
        id,
        tekst[145];
    if (sscanf(params, "us[110]", id, tekst)) 
        return Koristite(playerid, "pm [Ime ili ID igraca] [Tekst poruke]");
        
    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);
    
    if (!hPM{id}) 
        return ErrorMsg(playerid, "Taj igrac je blokirao privatne poruke!");
        
            
    zastiti_chat(playerid, tekst);

    // Slanje poruke igracu
    SendClientMessageF(id, 0x7197B0FF, "* (( PM od %s: %s ))", ime_rp[playerid], tekst);
    SendClientMessage(playerid, BELA, "* Poruka je poslata.");
    
    // Slanje poruke staffu
    AdminMsg(ZLATNA, "PM | %s[%d] » %s[%d]: %s", ime_rp[playerid], playerid, ime_rp[id], id, tekst);
    
    PrimioPM[id] = playerid;
    if (AutoPM{id})
        SendClientMessageF(playerid, 0x7197B0FF, "* (( Auto-PM od %s: %s ))", ime_rp[id], AutoPMTekst[id]);
    
    // Upisivanje u log
    format(string_256, 180, "Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime_obicno[id], tekst);
    Log_Write(LOG_PLAYERPM, string_256);
    
    return 1;
}

CMD:offpm(playerid, const params[]) 
{
    if (!IsAdmin(playerid, 1) && !IsVIP(playerid, 4))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (PI[playerid][p_nivo] < 6) 
        return ErrorMsg(playerid, "Morate biti najmanje nivo 6 da biste mogli da saljete offline poruke.");
        
    if (PI[playerid][p_offpm_vreme] > gettime()) 
        return ErrorMsg(playerid, "Off PM mozete slati svakih 10 minuta.");
        
    // Provera parametara
    new 
        igrac[MAX_PLAYER_NAME], 
        tekst[110];
    if (sscanf(params, "s[24]s[110]", igrac, tekst)) 
        return Koristite(playerid, "offpm [Ime igraca (osetljivo na mala i velika slova)] [Tekst (max. 110 slova)]");
    
    // Slanje upita ka bazi
    format(mysql_upit, 75, "SELECT offpm_ugasen FROM igraci WHERE ime = '%s'", igrac);
    mysql_tquery(SQL, mysql_upit, "mysql_offpm_posalji", "issi", playerid, igrac, tekst, cinc[playerid]);
    return 1;
}

CMD:odg(playerid, const params[]) 
{
    if (PrimioPM[playerid] == -1) 
        return ErrorMsg(playerid, "Niko Vam nije poslao PM. Koristite /pm da posaljete PM nekom igracu.");
   
    new 
        id = PrimioPM[playerid], tekst[145];
    if (sscanf(params, "s[110]", tekst)) 
        return Koristite(playerid, "odg [Tekst]");

    if (!IsPlayerConnected(id)) 
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!hPM{id}) 
        return ErrorMsg(playerid, "Taj igrac je blokirao privatne poruke!");

    zastiti_chat(playerid, tekst);
    SendClientMessageF(id, 0x7197B0FF, "* (( PM od %s: %s ))", ime_rp[playerid], tekst);
    AdminMsg(ZLATNA, "PM | %s[%d] » %s[%d]: %s", ime_rp[playerid], playerid, ime_rp[id], id, tekst);
    SendClientMessage(playerid, BELA, "* Poruka je poslata.");
    PrimioPM[id] = playerid;
    if (AutoPM{id}) 
        SendClientMessageF(playerid, 0x7197B0FF, "* (( Auto-PM od %s: %s ))", ime_rp[id], tekst);
    
    format(string_256, 180, "Izvrsio: %s | Igrac: %s | %s", ime_obicno[playerid], ime_obicno[id], tekst);
    Log_Write(LOG_PLAYERPM, string_256);
    return 1;
}

CMD:autopm(playerid, const params[]) 
{
    if (PI[playerid][p_nivo] < 3) 
        return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste koristili privatne poruke.");
        
    new tekst[145];
    if (sscanf(params, "s[110]", tekst)) 
        return Koristite(playerid, "autopm [Tekst automatske poruke]");
        
    if (!strcmp(AutoPMTekst[playerid], "iskljuci")) 
        return AutoPM{playerid} = false, SendClientMessage(playerid, BELA, "Iskljucili ste Auto-PM.");
    
    
    // Glavna funkcija komande
    AutoPM{playerid} = true;
    format(AutoPMTekst[playerid], sizeof(AutoPMTekst[]), "%s", zastiti_chat(playerid, tekst));
    
    // Slanje poruka igracu
    SendClientMessage(playerid, SVETLOPLAVA,  "* Igraci koji Vam posalju PM ce automatski dobiti ovu poruku.");
    SendClientMessage(playerid, INFOPLAVA,    "Upisite \"/autopm iskljuci\" da iskljucite Auto-PM.");
    
    // Upisivanje u log
    format(string_256, 160, "AUTOPM | Izvrsio: %s | %s", ime_obicno[playerid], tekst);
    Log_Write(LOG_PLAYERPM, string_256);
    
    return 1;
}
CMD:procitajpm(playerid, const params[]) return prikazi_pm(playerid, 1);