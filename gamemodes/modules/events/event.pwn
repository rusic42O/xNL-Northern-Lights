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
new Float:Oznaceno[3], etp_ts,
    tajmer:etp;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    etp_ts = 0;
    tajmer:etp = 0;
    return true;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward etp_reminder();
public etp_reminder()
{
    SendClientMessageToAll(NARANDZASTA, "* Prijave za event traju jos 15 sekundi. Koristite {FFFFFF}/etp.");
    tajmer:etp = SetTimer("etp_end", 15000, false);
}

forward etp_end();
public etp_end()
{
    SendClientMessageToAll(NARANDZASTA, "* Prijave za event su zavrsene.");
    tajmer:etp = 0;
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
flags:oznaci(FLAG_HELPER_1)
CMD:oznaci(playerid, const params[])
{
    if (!IsHelper(playerid, 1)) 
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        
    
    // Glavna funkcija komande
    GetPlayerPos(playerid, Oznaceno[0], Oznaceno[1], Oznaceno[2]);
    
    
    // Slanje poruke staffu
    if (IsAdmin(playerid, 1))
        StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je oznacio koordinate: %.1f, %.1f, %.1f | Koristite /naoznaceno da odete tamo.", ime_rp[playerid], Oznaceno[0], Oznaceno[1], Oznaceno[2]);
    else 
        StaffMsg(BELA, "H {8EFF00}| %s je oznacio koordinate: %.1f, %.1f, %.1f | Koristite /naoznaceno da odete tamo.", ime_rp[playerid], Oznaceno[0], Oznaceno[1], Oznaceno[2]);

    if (!isnull(params) && !strcmp(params, "event", true))
    {
        new string[144];
        format(string, sizeof string, "* %s organizuje event na posebnoj lokaciji. Koristite {FFFFFF}/etp {FF9900}da se prijavite, imate 60 sekundi.", ime_rp[playerid]);
        SendClientMessageToAll(NARANDZASTA, string);
        etp_ts = gettime() + 60;
        tajmer:etp = SetTimer("etp_reminder", 45000, false);
    }
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Komanda: /oznaci | Izvrsio: %s | Koordinate: %.1f, %.1f, %.1f", ime_obicno[playerid], Oznaceno[0], Oznaceno[1], Oznaceno[2]);
    Log_Write(LOG_ADMINKOMANDE, string_128);
    
    return 1;
}

flags:naoznaceno(FLAG_HELPER_1)
CMD:naoznaceno(playerid, const params[])
{
    if (Oznaceno[0] == -9999) 
        return ErrorMsg(playerid, "Nijedno mesto nije oznaceno.");
        
    // Glavna funkcija komande
    TeleportPlayer(playerid, Oznaceno[0], Oznaceno[1], Oznaceno[2]);
    
    // Slanje poruke staffu
    AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s se teleportovao na oznacene koordinate | Koristite /naoznaceno da odete tamo.", ime_rp[playerid]);
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Komanda: /naoznaceno | Izvrsio: %s", ime_obicno[playerid]);
    Log_Write(LOG_PORT, string_128);
    return 1;
}

flags:uklonioznaku(FLAG_HELPER_1)
CMD:uklonioznaku(playerid, const params[])
{
    // Glavna funkcija komande
    Oznaceno[0] = -9999;
    
    // Slanje poruke staffu
    AdminMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je uklonio oznacene koordinate.", ime_rp[playerid]);
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Komanda: /uklonioznaku | Izvrsio: %s", ime_obicno[playerid]);
    Log_Write(LOG_ADMINKOMANDE, string_128);

    KillTimer(tajmer:etp);
    tajmer:etp = 0;
    etp_ts = 0;
    
    return 1;
}

CMD:etp(playerid, const params[])
{
    if (gettime() > etp_ts)
        return ErrorMsg(playerid, "Prijave za event nisu aktivne.");

    if (IsPlayerJailed(playerid)) 
        return ErrorMsg(playerid, "Zatvoreni ste, ne mozete ici na event!");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Morate napustiti war da biste isli na event!");

    if (IsPlayerRobbingJewelry(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na event dok pljackate zlataru!");

    if (IsPlayerRobbingBank(playerid))
        return ErrorMsg(playerid, "Ne mozete ici na event dok pljackate banku!");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete se prijaviti na event jer ste zavezani ili uhapseni.");

    if (IsPlayerWorking(playerid))
        job_stop(playerid);


    if (IsPlayerOnLawDuty(playerid))
    {
        ToggleLawDuty(playerid, false);
    }

    TeleportPlayer(playerid, Oznaceno[0], Oznaceno[1], Oznaceno[2]);
    InfoMsg(playerid, "Teleportovani ste na event, pratite uputstva organizatora.");
    return 1;
}

flags:e(FLAG_HELPER_1)
CMD:e(playerid, const params[])
{
    if (isnull(params))
        return Koristite(playerid, "e [Tekst]");
        
    new chat_string[145];
    // Slanje poruke igracima
    format(chat_string, sizeof chat_string, "(( %s: {FFFFFF}%s {1275ED}))", ime_rp[playerid], params);
    RangeMsg(playerid, chat_string, PLAVA, 100.0);
    

    // Upisivanje u log
    format(chat_string, sizeof chat_string, "EVENT | Izvrsio: %s | %s", ime_obicno[playerid], params);
    Log_Write(LOG_STAFFOOC, chat_string);
    return 1;
}