#include <YSI_Coding\y_hooks>

/*

    PROMOTER -1-
    - /pv chat
    - Komanda /port jednom u 3 minuta
    - Payday plata uvecana za 20%


    PROMOTER -2-
    - /pv chat
    - Komanda /port jednom u 3 minuta, sa dodatnim lokacijama
    - Komanda /idido jednom u 10 minuta
    - Payday plata uvecana za 30%


    PROMOTER -3-
    - /pv chat
    - Komanda /port jednom u 2 minuta
    - Komanda /idido jednom u 8 minuta
    - Payday plata uvecana za 40%


*/

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PROMO_AD_REWARD 1000 // Nagrada po potvrdjenoj reklami
#define PROMO_MAX_REWARDS_ITEMS 15




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static bool:gPromoRewardsSolved[PROMO_MAX_REWARDS_ITEMS char];
static gClrBase, gClrLighter, g_sClrLighter[7];
static bool:gPromoChat;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    // Podesavanja boje
    gClrBase = 0xAF28A4FF;
    gClrLighter = ColorLighten(gClrBase);
    GetColorShade(gClrLighter, g_sClrLighter);
    gPromoChat = true;
    return true;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
CheckPromoRewards(playerid)
{
    new sQuery[256];
    format(sQuery, sizeof sQuery, "SELECT reward FROM promo_rewards WHERE pid = %i AND status = 1", PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery, "MySQL_CheckPromoRewards", "ii", playerid, cinc[playerid]);
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_PromoRequest(playerid, ccinc, tagNum);
public MySQL_PromoRequest(playerid, ccinc, tagNum)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
    {
        new sQuery[79];
        format(sQuery, sizeof sQuery, "INSERT INTO promo_rewards (pid, last_num, prev_num) VALUES (%i, %i, %i)", PI[playerid][p_id], tagNum, PI[playerid][p_promo_hashtag]);
        mysql_tquery(SQL, sQuery);

        new sDialog[350];
        format(sDialog, sizeof sDialog, "{FFFFFF}Zahtev za nagradu je uspesno poslat.\nPrimices nagradu kada vodja promotera pregleda tvoj rad.\nUkoliko ne budes online, nagradu ces automatski dobiti kada udjes na server.\n\n{FF0000}[VAZNO]: {FF6347}Vise nemoj koristiti hashtag {FF0000}#nlpromo_%04i_%i {FF6347}!\n Naredni krug reklamiranja zapocni hashtagom {00FF00}#nlpromo_%04i_%i .", PI[playerid][p_id], tagNum, PI[playerid][p_id], tagNum+1);
        SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Uspesno", sDialog, "Razumem", "");

        InfoMsg(playerid, "Zahtev za nagradu je uspesno poslat. Bicete nagradjeni kada vodja promotera pregleda Vas rad.");
        SendClientMessageF(playerid, CRVENA, "VAZNO: {FF6347}Nemojte vise koristiti hashtag {FF0000}#nlpromo_%04i_%i {FF6347}!", PI[playerid][p_id], tagNum);
        SendClientMessageF(playerid, SVETLOCRVENA, "Naredni krug reklamiranja zapocni hashtagom {00FF00}#nlpromo_%04i_%i {FF6347}!", PI[playerid][p_id], tagNum+1);


        PI[playerid][p_promo_hashtag] = tagNum;

        new sQuery2[57];
        format(sQuery2, sizeof sQuery2, "UPDATE igraci SET promo_hashtag = %i WHERE id = %i", tagNum, PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery2);
    }
    else
    {
        ErrorMsg(playerid, "Vec imate 1 zahtev na cekanju. Moci cete da posaljete novi tek kada on bude obradjen.");
    }
    return 1;
}

forward MySQL_PromoRewards(playerid, ccinc);
public MySQL_PromoRewards(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, "Trenutno nema nikakvih zahteva.");

    new sDialog[39 + 100*PROMO_MAX_REWARDS_ITEMS],
        playerName[MAX_PLAYER_NAME], 
        uniqid,
        lastTagNum, 
        prevTagNum,
        time[7], 
        status;

    format(sDialog, 39, "Igrac\tHashtag\tVreme zahteva\tReseno?");
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index(i, 0, playerName, sizeof playerName);
        cache_get_value_index_int(i, 1, uniqid);
        cache_get_value_index_int(i, 2, lastTagNum);
        cache_get_value_index_int(i, 3, prevTagNum);
        cache_get_value_index(i, 4, time, sizeof time);
        cache_get_value_index_int(i, 5, status);

        format(sDialog, sizeof sDialog, "%s\n%s\t%04i_%i > %04i_%i\t%s\t%s", sDialog, playerName, uniqid, prevTagNum, uniqid, lastTagNum, time, (status? ("{00FF00}Da"):("{FF0000}Ne")));
        gPromoRewardsSolved{i} = !!status;
    }

    SPD(playerid, "PromoRequests", DIALOG_STYLE_TABLIST_HEADERS, "Zahtevi za nagrade", sDialog, "Dalje", "Izadji");
    return 1;
}

forward MySQL_CheckPromoRewards(playerid, ccinc);
public MySQL_CheckPromoRewards(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (rows == 1)
    {
        new reward,
            numAds;
        cache_get_value_index_int(0, 0, reward);

        numAds = floatround(reward / PROMO_AD_REWARD);

        PlayerMoneyAdd(playerid, reward);

        SendClientMessageF(playerid, gClrBase, "PROMO | {%s}Dobili ste novcanu nagradu u iznosu od {AF28A4}%s.", g_sClrLighter, formatMoneyString(reward));

        new sQuery[55];
        format(sQuery, sizeof sQuery, "UPDATE promo_rewards SET status = 2 WHERE pid = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[94];
        format(sLog, sizeof sLog, "%s je nagradjen za %i reklama | %s | Offline odobrenje", ime_obicno[playerid], numAds, formatMoneyString(reward));
        Log_Write(LOG_PROMO_REWARDS, sLog);
    }
    return 1;
}





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:promogoto(playerid, response, listitem, const inputtext[])
{
    new id = GetPVarInt(playerid, "pPromoterGotoRequested");

    if (!IsPromoter(id, 2) || GetPVarInt(id, "pPromoterGoto") != playerid)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (!response)
    {
        DeletePVar(playerid, "pPromoterGotoRequested");
        DeletePVar(id, "pPromoterGoto");
        ErrorMsg(id, "%s je odbio teleport.", ime_obicno[playerid]);
    }
    else
    {
        if (GetPVarInt(id, "pPromoterGotoCooldown") > gettime())
        {
            ErrorMsg(playerid, "Taj igrac je nedavno vec iskoristio teleport.");
            ErrorMsg(playerid, "Vec ste se nedavno teleportovali do igraca. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(id, "pPromoterGotoCooldown")-gettime()));
            return 1;
        }

        // Glavna funkcija komande
        SetPlayerInterior(id, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));
        GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
        TeleportPlayer(id, pozicija[playerid][0], pozicija[playerid][1] + 4.0, pozicija[playerid][2]);
        
        // Slanje poruke igracu
        SendClientMessageF(id, INFO, "(teleport) {9DF2B5}Teleportovani ste do igraca %s.", ime_rp[playerid], playerid);

        // Cooldown
        if (IsPromoter(id, 3))
            SetPVarInt(id, "pPromoterGotoCooldown", gettime()+480); // 8 minuta
        else 
            SetPVarInt(id, "pPromoterGotoCooldown", gettime()+600); // 10 minuta

        // Upisivanje u log
        new string[128];
        format(string, sizeof string, "/idido | %s do %s", ime_obicno[id], ime_obicno[playerid]);
        Log_Write(LOG_PROMOTER, string);
    }


    DeletePVar(playerid, "pPromoterGotoRequested");
    DeletePVar(id, "pPromoterGoto");
    return 1;
}

Dialog:PromoRequest(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new tagNum;
    if (sscanf(inputtext, "i", tagNum))
        return DialogReopen(playerid);

    if (tagNum < 1 || tagNum > 255)
        return DialogReopen(playerid);

    if (tagNum <= PI[playerid][p_promo_hashtag])
    {
        ErrorMsg(playerid, "Vec ste dobili nagradu za taj hashtag ili imate zahtev na cekanju.");
        return DialogReopen(playerid);
    }

    new sQuery[69];
    format(sQuery, sizeof sQuery, "SELECT pid FROM promo_rewards WHERE pid = %i AND status != 2", PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery, "MySQL_PromoRequest", "iii", playerid, cinc[playerid], tagNum);
    return 1;
}

Dialog:PromoRequests(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (gPromoRewardsSolved{listitem})
    {
        ErrorMsg(playerid, "Ovaj zahtev je vec resen.");
        return DialogReopen(playerid);
    }

    SetPVarString(playerid, "pPromoRewardName", inputtext);
    SPD(playerid, "PromoGiveReward", DIALOG_STYLE_INPUT, "Promoter nagrada", "{FFFFFF}Unesite broj {00FF00}validnih {FFFFFF}reklama za ovog igraca:\n({FF0000}0{FFFFFF} = ponistenje zahteva)", "Potvrdi", "Nazad");

    return 1;
}

Dialog:PromoGiveReward(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::vipfv(playerid, "");

    new ads;
    if (sscanf(inputtext, "i", ads) || !(0 <= ads <= 500))
        return DialogReopen(playerid);


    new playerName[MAX_PLAYER_NAME], 
        targetid,
        reward = PROMO_AD_REWARD * ads;

    GetPVarString(playerid, "pPromoRewardName", playerName, sizeof playerName);
    targetid = GetPlayerIDFromName(playerName);
    DeletePVar(playerid, "pPromoRewardName");


    if (IsPlayerConnected(targetid))
    {
        if(targetid == playerid)
            return ErrorMsg(playerid, "Ne mozete prihvatiti zahtjev sami sebi!");
        PlayerMoneyAdd(targetid, reward);

        SendClientMessageF(targetid, gClrBase, "PROMO | {%s}Dobili ste novcanu nagradu od {AF28A4}%s {%s}u iznosu od {AF28A4}%s.", g_sClrLighter, ime_rp[playerid], g_sClrLighter, formatMoneyString(reward));
        SendClientMessageF(playerid, gClrBase, "PROMO | {%s}Odobrili ste novcanu nagradu {AF28A4}%s[%i] {%s}u iznosu od {AF28A4}%s.", g_sClrLighter, ime_rp[targetid], targetid, g_sClrLighter, formatMoneyString(reward));

        new sQuery[60];
        format(sQuery, sizeof sQuery, "UPDATE promo_rewards SET status = 2 WHERE pid = %i", PI[targetid][p_id]);
        mysql_tquery(SQL, sQuery);

        new sLog[94];
        format(sLog, sizeof sLog, "%s je nagradjen za %i reklama | %s | %s", playerName, ads, formatMoneyString(reward), ime_obicno[playerid]);
        Log_Write(LOG_PROMO_REWARDS, sLog);
    }
    else
    {
        SendClientMessageF(playerid, gClrBase, "PROMO | {%s}Dodelili ste novcanu nagradu {AF28A4}%s {%s}u iznosu od {AF28A4}%s.", g_sClrLighter, playerName, g_sClrLighter, formatMoneyString(reward));
        SendClientMessageF(playerid, gClrLighter, "* %s je trenutno offline. Automatski ce dobiti nagradu kada udje na server.", playerName);

        new sQuery[215];
        mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE promo_rewards INNER JOIN igraci ON igraci.id = promo_rewards.pid SET promo_rewards.status = 1, promo_rewards.reward = %i WHERE igraci.ime = '%s' AND promo_rewards.status = 0", reward, playerName);
        mysql_tquery(SQL, sQuery);

        new sLog[114];
        format(sLog, sizeof sLog, "%s je nagradjen za %i reklama - zakazano/offline | %s | %s", playerName, ads, formatMoneyString(reward), ime_obicno[playerid]);
        Log_Write(LOG_PROMO_REWARDS, sLog);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:port(playerid, const params[]) 
{
    if (IsAdmin(playerid, 1))
        return callcmd::tp(playerid, params);

    if (!IsPromoter(playerid, 1) && !IsVIP(playerid, 1))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste na trci.");

    if (IsPlayerWorking(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok radite posao.");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u waru.");

    if (PI[playerid][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zatvoreni.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste uhapseni/zavezani.");

    if (IsPlayerWanted(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu ukoliko imate wanted level.");

    if (GetPVarInt(playerid, "pTookDamage")+10 > gettime())
        return ErrorMsg(playerid, "Nedavno ste upucani, morate sacekati 10 sekundi pre nego sto budete mogli da koristite ovu naredbu.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    if (IsACriminal(playerid))
    {
        if (IsPlayerRobbingJewelry(playerid))
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok pljackate zlataru.");

        if (IsTurfWarActiveForPlayer(playerid))
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda napada/brani teritoriju.");

        if (IsBankRobberyInProgress() && GetFactionRobbingBank() == PI[playerid][p_org_id])
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda pljacka banku.");
    }
    else if (IsACop(playerid) && IsPlayerOnLawDuty(playerid))
    {
        if (IsBankRobberyInProgress())
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka banke.");

        if (GetFactionRobbingJeweley() != -1)
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka zlatare.");
    }
    

    if (IsPromoter(playerid, 1))
    {
        if (IsPromoter(playerid, 2)) 
        {
            new string[406];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nburg\tBurger Shot\nsp\tSpawn (glavni)\nbanka\tBanka\nbolnica\tBolnica\npd\tPolicija, opstina\ngun\tGun Shop\nas\tAutobuska stanica\nzs\tZeleznicka stanica\nasalon\tAuto salon\naskola\tAuto skola\ngrove\tGrove Street\ntower\tBank Tower\nlsaero\tAerodrom (Los Santos)\nmeh\tMehanicarska radionica\nverona\tVerona\nmaria\tSanta Maria Beach\ndokovi\tOcean Docks");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");

            SetPVarInt(playerid, "pPromoterPort", 1);
        }

        else if (IsPromoter(playerid, 1)) 
        {
            new string[470];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nburg\tBurger Shot\nsp\tSpawn (glavni)\nbanka\tBanka\nbolnica\tBolnica\npd\tPolicija, opstina\ngun\tGun Shop\nas\tAutobuska stanica\nzs\tZeleznicka stanica\nasalon\tAuto salon\naskola\tAuto skola\ngrove\tGrove Street\ntower\tBank Tower\nlsaero\tAerodrom (Los Santos)\nsfaero\tAerodrom (San Fierro)\nlvaero\tAerodrom (Las Venturas)\nmeh\tMehanicarska radionica\nverona\tVerona\nmaria\tSanta Maria Beach\ndokovi\tOcean Docks");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
            
            SetPVarInt(playerid, "pPromoterPort", 1);
        }
        return 1;
    }

    if (IsVIP(playerid, 1))
    {
        SetPVarInt(playerid, "pVIPPort", 1);

        if (IsVIP(playerid, 4))
        {
            new string[650];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nvip\tVIP baza\nls\tLos Santos\nsf\tSan Fierro\nlv\tLas Venturas\nburg\tBurger Shot\nsp\tSpawn (glavni)\nbanka\tBanka\nbolnica\tBolnica\npd\tPolicija, opstina\ngun\tGun Shop\nas\tAutobuska stanica\nzs\tZeleznicka stanica\nasalon\tAuto salon\naskola\tAuto skola\ngrove\tGrove Street\ntower\tBank Tower\nlsaero\tAerodrom (Los Santos)\nsfaero\tAerodrom (San Fierro)\nlvaero\tAerodrom (Las Venturas)\nmeh\tMehanicarska radionica\nverona\tVerona\nmaria\tSanta Maria Beach\ndokovi\tOcean Docks\nrudnik\tRudnik\nzlatara\tZlatara\nfabrika\tFabrika oruzja\nbayside\tBayside\ngsflab\tGSF Lab\nlsblab\tLSB Lab\nlsvlab\tLSV Lab");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
        }

        else if (IsVIP(playerid, 3))
        {
            new string[470];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nvip\tVIP baza\nls\tLos Santos\nsf\tSan Fierro\nlv\tLas Venturas\nburg\tBurger Shot\nsp\tSpawn (glavni)\nbanka\tBanka\nbolnica\tBolnica\npd\tPolicija, opstina\ngun\tGun Shop\nas\tAutobuska stanica\nzs\tZeleznicka stanica\nasalon\tAuto salon\naskola\tAuto skola\ngrove\tGrove Street\ntower\tBank Tower\nlsaero\tAerodrom (Los Santos)\nsfaero\tAerodrom (San Fierro)\nlvaero\tAerodrom (Las Venturas)\nmeh\tMehanicarska radionica\nverona\tVerona\nmaria\tSanta Maria Beach\ndokovi\tOcean Docks");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
        }

        else if (IsVIP(playerid, 2))
        {
            new string[246];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nvip\tVIP baza\nls\tLos Santos\nsf\tSan Fierro\nlv\tLas Venturas\nburg\tBurger Shot\nsp\tSpawn (glavni)\nbanka\tBanka\nbolnica\tBolnica\npd\tPolicija\nopstina\tOpstina\nas\tAutobuska stanica\nasalon\tAuto salon\nmaria\tSanta Maria Beach");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
        }

        else if (IsVIP(playerid, 1))
        {
            new string[74];

            format(string, sizeof(string), "Precica\tNaziv lokacije\nvip\tVIP baza\nls\tLos Santos\nsf\tSan Fierro\nlv\tLas Venturas");
            SPD(playerid, "port", DIALOG_STYLE_TABLIST_HEADERS, "Teleport", string, "Teleport", "Odustani");
        }
        return 1;
    }

    else
    {
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    }

}

CMD:promogoto(playerid, const params[]) 
{
    if (!IsPromoter(playerid, 2))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (GetPVarInt(playerid, "pPromoterGotoCooldown") > gettime())
        return ErrorMsg(playerid, "Vec ste se nedavno teleportovali do igraca. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "pPromoterGotoCooldown")-gettime()));

    if (IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste na trci.");

    if (IsPlayerWorking(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok radite posao.");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u waru.");

    if (IsPlayerInDMArena(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u DM Areni.");

    if (PI[playerid][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zatvoreni.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste uhapseni/zavezani.");

    if (IsPlayerWanted(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu ukoliko imate trazeni nivo.");

    if (GetPVarInt(playerid, "pTookDamage")+10 > gettime())
        return ErrorMsg(playerid, "Nedavno ste upucani, morate sacekati 10 sekundi pre nego sto budete mogli da koristite ovu naredbu.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    if (IsACriminal(playerid))
    {
        if (IsPlayerRobbingJewelry(playerid))
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok pljackate zlataru.");

        if (IsTurfWarActiveForPlayer(playerid))
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda napada/brani teritoriju.");

        if (IsBankRobberyInProgress() && GetFactionRobbingBank() == PI[playerid][p_org_id])
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda pljacka banku.");
    }
    else if (IsACop(playerid) && IsPlayerOnLawDuty(playerid))
    {
        if (IsBankRobberyInProgress())
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka banke.");

        if (GetFactionRobbingJeweley() != -1)
            return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka zlatare.");
    }

    new id;
    if (sscanf(params, "u", id))
        return Koristite(playerid, "idido [Ime ili ID igraca]");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, "Ne mozete se teleportovati do head admina.");

    new string[92];
    format(string, sizeof string, "{FFFFFF}Promoter {FFFF00}%s {FFFFFF}zeli da se teleportuje do Vas.", ime_rp[playerid]);
    SPD(id, "promogoto", DIALOG_STYLE_MSGBOX, "Zahtev za teleport", string, "Prihvati", "Odbij");

    SetPVarInt(playerid, "pPromoterGoto", id);
    SetPVarInt(id, "pPromoterGotoRequested", playerid);
    return 1;
}

flags:pvtog(FLAG_ADMIN_6)
CMD:pvtog(playerid, const params[])
{
    gPromoChat = !gPromoChat;

    new sMsg[60];
    format(sMsg, sizeof sMsg, "Admin %s je %s /pv kanal.", (gPromoChat)?("ukljucio"):("iskljucio"));

    foreach (new i : Player)
    {
        if ((IsPromoter(i, 1) || IsAdmin(i, 5) || IsVIP(i, 1)) && IsChatEnabled(i, CHAT_PROMOVIP))
        {
            SendClientMessage(i, 0xAF28A4FF, sMsg);
        }
    }
    return 1;
}

flags:pv(FLAG_PROMO_1 | FLAG_PROMO_VODJA | FLAG_ADMIN_1 | FLAG_VIP_1)
CMD:pv(playerid, const params[])
{  
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
    
    // Provera parametara
    if (sscanf(params, "s[128]", string_128)) 
        return Koristite(playerid, "pv [Tekst]");

    if (!IsAdmin(playerid, 5) && !gPromoChat)
        return ErrorMsg(playerid, "Head Admin je privremeno iskljucio /pv kanal.");

    if (!IsChatEnabled(playerid, CHAT_PROMOVIP))
        return ErrorMsg(playerid, "Iskljucili ste /pv kanal. Koristite /chat da ga ponovo ukljucite.");
        
    // Formatiranje poruke
    new string[145];
    if (IsAdmin(playerid, 6) && !IsPlayerOwner(playerid)) 
    {
        format(string, sizeof string, "Head admin %s: {FFFFFF}%s", ime_rp[playerid], string_128);
    }
    else if (IsAdmin(playerid, 6) && IsPlayerOwner(playerid)) 
    {
        format(string, sizeof string, "Owner %s: {FFFFFF}%s", ime_rp[playerid], string_128);
    }
    else if (IsAdmin(playerid, 1)) 
    {
        format(string, sizeof string, "|%d|A| %s[%i]: {FFFFFF}%s", PI[playerid][p_admin], ime_rp[playerid], playerid, string_128);
    }
    else if (IsHelper(playerid, 1)) 
    {
        format(string, sizeof string, "|%d|H| %s[%i]: {FFFFFF}%s", PI[playerid][p_helper], ime_rp[playerid], playerid, string_128);
    }
    else if (PlayerFlagGet(playerid, FLAG_MAPER)) 
    {
        format(string, sizeof string, "MAPER | %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, string_128);
    }
    else if (IsPromoter(playerid, 1)) 
    {
        format(string, sizeof string, "|%d|P| %s[%i]: {FFFFFF}%s", PI[playerid][p_promoter], ime_rp[playerid], playerid, string_128);
    }
    else if (IsVIP(playerid, 1)) 
    {
        format(string, sizeof string, "|%d|VIP| %s[%i]: {FFFFFF}%s", PI[playerid][p_vip_level], ime_rp[playerid], playerid, string_128);
    }
    
    if (PlayerFlagGet(playerid, FLAG_PROMO_VODJA)) 
    {
        format(string, sizeof string, "Vodja promotera %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, string_128);
    }
    else if (PlayerFlagGet(playerid, FLAG_LEADER_VODJA)) 
    {
        format(string, sizeof string, "Vodja lidera %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, string_128);
    }
    else if (PlayerFlagGet(playerid, FLAG_HELPER_VODJA)) 
    {
        format(string, sizeof string, "Vodja helpera %s[%i]: {FFFFFF}%s", ime_rp[playerid], playerid, string_128);
    }
    
    
    // Slanje poruke
    foreach(new i : Player)
    {
        if ((IsPromoter(i, 1) || IsAdmin(i, 5) || IsVIP(i, 1)) || PlayerFlagGet(playerid, FLAG_HELPER_VODJA) || PlayerFlagGet(playerid, FLAG_LEADER_VODJA) || PlayerFlagGet(playerid, FLAG_PROMO_VODJA) && IsChatEnabled(i, CHAT_PROMOVIP))
            SendClientMessage(i, 0xAF28A4FF, string);
    }
    
    return 1;
}

CMD:promofv(playerid, const params[])
{
    if (!IsPromoter(playerid, 3))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (GetPVarInt(playerid, "pPromoterFvCooldown") > gettime())
        return ErrorMsg(playerid, "Vec ste nedavno popravili vozilo. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "pPromoterFvCooldown")-gettime()));

    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Niste u vozilu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Mozete popraviti samo vozilo kojim upravljate.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    new vehicleid = GetPlayerVehicleID(playerid);
    SetVehicleHealth(vehicleid, 999.0);
    
    SendClientMessage(playerid, SVETLOPLAVA, "* Vozilo je popravljeno.");

    if (IsPromoter(playerid, 1))
    {
        SetPVarInt(playerid, "pPromoterFvCooldown", gettime()+1200); // 20 minuta za promotere
    }
    else if (IsVIP(playerid, 4))
    {
        SetPVarInt(playerid, "pPromoterFvCooldown", gettime()-1); // Neograniceno za VIP 4
    }
    else if (IsVIP(playerid, 3))
    {
        SetPVarInt(playerid, "pPromoterFvCooldown", gettime()+60); // 1 minut za VIP 3
    }
    else if (IsVIP(playerid, 2))
    {
        SetPVarInt(playerid, "pPromoterFvCooldown", gettime()+300); // 5 minuta za VIP 2
    }
    else if (IsVIP(playerid, 1))
    {
        SetPVarInt(playerid, "pPromoterFvCooldown", gettime()+600); // 10 minuta za VIP 1
    }

    if (GetPVarInt(playerid, "vipOverride") == 1)
    {
        callcmd::vip(playerid, "");
    }
    return 1;
}

CMD:promoter(playerid, const params[])
{
    new sDialog[1580]; //, sa dodatnim lokacijama dole portovi
    format(sDialog, sizeof sDialog, "{AF28A4}\
        PROMOTER NIVO: 1\n{FFFFFF}\
        - /pv chat\n\
        - Komanda /port jednom u 3 minuta\n\
        - Payday plata uvecana za 20%\n\n\
        {AF28A4}\
        PROMOTER NIVO: 2\n{FFFFFF}\
        - /pv chat\n\
        - Komanda /port jednom u 3 minuta\n\
        - Komanda /idido jednom u 10 minuta\n\
        - Payday plata uvecana za 30%\n\n\
        {AF28A4}\
        PROMOTER NIVO: 3\n{FFFFFF}\
        - /pv chat\n\
        - Komanda /port jednom u 2 minuta\n\
        - Komanda /idido jednom u 8 minuta\n\
        - Komanda /fv jednom u 20 minuta\n\
        - Payday plata uvecana za 40%\n\n\
        \
        {AF28A4}[NAGRADE] {%s}Za svaku objavljenu reklamu dobijate {AF28A4}%s !\n\
        {FFFFFF}Na kraju dana iskoristite komandu {%s}/promonagrada {FFFFFF}kojom cete vodji promotera poslati zahtev\n\
        za novcanu nagradu. U dialogu koji se otvori upisite broj reklama koje objavili tog dana,\n\
        a vodja promotera ce Vam nakon provere dodeliti nagradu.\n\
        {FFFFFF}Ukoliko budete offline u trenutku dodele, nagradu automatski primate kada udjete na server.", g_sClrLighter, formatMoneyString(PROMO_AD_REWARD), g_sClrLighter);

    if (IsPromoter(playerid, 1))
    {
        format(sDialog, sizeof sDialog, "%s\n\nDa bi Vam se bodovala svaka reklama, obavezno na kraju posta morate ukljuciti svoj jedinstveni hashtag!\n --- {%s}Hashtag: {AF28A4}#nlpromo_%04i_{FF0000}X\n\n\
            X {FFFFFF}je broj koji menjate na svakih {FF9900}50 objavljenih reklama.{FFFFFF}\n\
            Primer:\n\
            - Za reklame {FFFF00}1-50 {FFFFFF}koristite hashtag {AF28A4}#nlpromo_%04i_1\n{FFFFFF}\
            - Za reklame {FFFF00}51-100 {FFFFFF}koristite hashtag {AF28A4}#nlpromo_%04i_2\n{FFFFFF}\
            - Za reklame {FFFF00}101-150 {FFFFFF}koristite hashtag {AF28A4}#nlpromo_%04i_3\n{FFFFFF}\
            - itd... Ovaj brojac se nikad ne resetuje, vec se samo povecava!\n\n\
            {FF0000}Minimum za dobijanje nagrade je 50 reklama!", sDialog, g_sClrLighter, PI[playerid][p_id], PI[playerid][p_id], PI[playerid][p_id], PI[playerid][p_id]);
    }

    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "{AF28A4}Promoter Info", sDialog, "OK", "");
    return 1;
}

CMD:promoteri(playerid, const params[])
{
    if (!IsPromoter(playerid, 1) && !IsAdmin(playerid, 5) && !PlayerFlagGet(playerid, FLAG_PROMO_VODJA))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    SendClientMessage(playerid, 0xAF28A4FF,    "_______________ Promoteri _______________");
    foreach(new i : Player) 
    {
        if (PI[i][p_promoter] > 0) 
        {
            if (PlayerFlagGet(playerid, FLAG_PROMO_VODJA) || IsAdmin(playerid, 6))
            {
                if (!IsPlayerAFK(i))
                {
                    SendClientMessageF(playerid, 0xAF28A4FF, "Promoter: {FFFFFF}%s | {AF28A4}Nivo: {FFFFFF}%d", ime_obicno[i], PI[i][p_promoter]); 
                }
                else
                {
                    SendClientMessageF(playerid, 0xAF28A4FF, "Promoter: {FFFFFF}%s | {AF28A4}Nivo: {FFFFFF}%d | {FF9900}[AFK %s]", ime_obicno[i], PI[i][p_promoter], konvertuj_vreme(GetPlayerAFKTime(i))); 
                }
            }
            else
            {
                SendClientMessageF(playerid, 0xAF28A4FF, "Promoter: {FFFFFF}%s | {AF28A4}Nivo: {FFFFFF}%d", ime_obicno[i], PI[i][p_promoter]);
            }
        }
    }
    return 1;
}

flags:promonagrada(FLAG_PROMO_1 | FLAG_PROMO_VODJA)
CMD:promonagrada(playerid, const params[])
{
    new sDialog[185];
    format(sDialog, sizeof sDialog, "{FFFFFF}Unesite broj sa {FFFF00}poslednjeg hashtag-a {FFFFFF}koji ste iskoristili za svoje reklame.\n\n#nlpromo_%04d_{FF0000}X   {FFFFFF}<--   unesite broj koji menja {FF0000}X !", PI[playerid][p_id]);

    SPD(playerid, "PromoRequest", DIALOG_STYLE_INPUT, "Zahtev za nagradu", sDialog, "Posalji", "Odustani");
    return 1;
}

flags:promonagrade(FLAG_ADMIN_6 | FLAG_PROMO_VODJA)
CMD:promonagrade(playerid, const params[])
{
    mysql_tquery(SQL, "\
        SELECT igraci.ime, promo_rewards.pid, promo_rewards.last_num, promo_rewards.prev_num, DATE_FORMAT(promo_rewards.time, '%d %b') as time1, promo_rewards.status FROM promo_rewards \
        LEFT JOIN igraci ON promo_rewards.pid = igraci.id \
        ORDER BY time DESC LIMIT 0,"#PROMO_MAX_REWARDS_ITEMS, "MySQL_PromoRewards", "ii", playerid, cinc[playerid]);
    return 1;
}