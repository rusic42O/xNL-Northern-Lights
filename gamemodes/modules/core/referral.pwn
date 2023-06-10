
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





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_RefCheck(playerid, ccinc, ime[MAX_PLAYER_NAME]);
public MySQL_RefCheck(playerid, ccinc, ime[MAX_PLAYER_NAME])
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    new string[3000];
    format(string, 33, "Igrac\tNivo\tOrganizacija\tDatum");
    if (rows)
    {
        new playerName[MAX_PLAYER_NAME], level, regDate[22], org_id;
        for__loop (new i = 0; i < rows; i++)
        {
            cache_get_value_name(i, "ime", playerName, sizeof playerName);
            cache_get_value_name(i, "reg_date", regDate, sizeof regDate);
            cache_get_value_name_int(i, "nivo", level);
            cache_get_value_name_int(i, "org_id", org_id);

            format(string, sizeof string, "%s\n%s\t%i\t%s\t%s", string, playerName, level, (org_id==-1? ("{FF0000}Ne") : ("{00FF00}Da")), regDate);
        }

        new title[64];
        format(title, sizeof title, "%s | %i dovedenih igraca", ime, rows);
        SPD(playerid, "no_return", DIALOG_STYLE_TABLIST_HEADERS, title, string, "U redu", "");
    }
    else
    {
        ErrorMsg(playerid, "Taj igrac nije doveo nikoga na server.");
    }
    return 1;
}

forward MySQL_RefStatus(playerid, ccinc);
public MySQL_RefStatus(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    new string[3000];
    format(string, 33, "Igrac\tNivo\tOrganizacija\tDatum");
    if (rows)
    {
        new playerName[MAX_PLAYER_NAME], level, regDate[22], org_id;
        for__loop (new i = 0; i < rows; i++)
        {
            cache_get_value_name(i, "ime", playerName, sizeof playerName);
            cache_get_value_name(i, "reg_date", regDate, sizeof regDate);
            cache_get_value_name_int(i, "nivo", level);
            cache_get_value_name_int(i, "org_id", org_id);

            format(string, sizeof string, "%s\n%s\t%i\t%s\t%s", string, playerName, level, (org_id==-1? ("{FF0000}Ne") : ("{00FF00}Da")), regDate);
        }

        new title[36];
        format(title, sizeof title, "Broj dovedenih igraca: {FFFF00}%i", rows);
        SPD(playerid, "no_return", DIALOG_STYLE_TABLIST_HEADERS, title, string, "U redu", "");
    }
    else
    {
        ErrorMsg(playerid, "Niste doveli nikoga na server.");
    }
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:ref(playerid, const params[])
{
    if (PI[playerid][p_nivo] > 2) 
        return ErrorMsg(playerid, "Samo igraci do nivoa 2 mogu koristiti ovu komandu.");

    new targetid;
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "ref [Ime ili ID igraca]");

    if (targetid == playerid)
        return ErrorMsg(playerid, "Ne mozete oznaciti sami sebe.");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(playerid, targetid, 5.0) || GetPlayerState(targetid) == PLAYER_STATE_SPECTATING)
        return ErrorMsg(playerid, "Ne nalazite se dovoljno blizu tog igraca.");

    if (strcmp(PI[playerid][p_referral], "N/A"))
        return ErrorMsg(playerid, "Vec ste jednom iskoristili ovu komandu (ref: %s).", PI[playerid][p_referral]);

    format(PI[playerid][p_referral], MAX_PLAYER_NAME, "%s", ime_obicno[targetid]);
    SendClientMessageF(targetid, SVETLOPLAVA, "* %s[%i] je oznacio da ste ga doveli na server.", ime_obicno[playerid], playerid);
    SendClientMessageF(playerid, SVETLOPLAVA, "* Oznacili ste da Vas je na server doveo: %s[%i].", ime_obicno[targetid], targetid);
    SendClientMessage(playerid, SVETLOPLAVA, "Kao znak dobrodoslice, dobijate {FFFFFF}nivo 3.");

    PI[playerid][p_nivo] = 3;
    SetPlayerScore(playerid, 3);

    new query[256];
    mysql_format(SQL, query, sizeof query, "UPDATE igraci SET nivo = 3, referral = '%s' WHERE id = %i", ime_obicno[targetid], PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    new logStr[70];
    format(logStr, sizeof logStr, "%s[%i] | %s[%i]", ime_obicno[playerid], PI[playerid][p_id], ime_obicno[targetid], PI[targetid][p_id]);
    Log_Write(LOG_REFERRAL, logStr);
    return 1;
}

flags:refcheck(FLAG_ADMIN_5 | FLAG_HELPER_VODJA | FLAG_ADMIN_VODJA | FLAG_LEADER_VODJA)
CMD:refcheck(playerid, const params[])
{
    new id;
    if (sscanf(params, "u", id))
        return Koristite(playerid, "refcheck [Ime ili ID igraca]   *ime offline igraca mora sadrzati {FFFFFF}_");

    new ime[MAX_PLAYER_NAME];
    if (IsPlayerConnected(id))
        format(ime, sizeof ime, "%s", ime_obicno[id]);
    else
        format(ime, sizeof ime, "%s", params);

    new query[185];
    mysql_format(SQL, query, sizeof query, "SELECT ime, nivo, org_id, DATE_FORMAT(datum_registracije, '\%%d \%%b \%%Y') as reg_date FROM igraci WHERE referral = '%s' ORDER BY datum_registracije DESC", ime);
    mysql_tquery(SQL, query, "MySQL_RefCheck", "iis", playerid, cinc[playerid], ime);
    return 1;
}

CMD:refstatus(playerid, const params[])
{
    new query[170];
    mysql_format(SQL, query, sizeof query, "SELECT ime, nivo, org_id, DATE_FORMAT(datum_registracije, '\%%d \%%b \%%Y') as reg_date FROM igraci WHERE referral = '%s' ORDER BY nivo DESC", ime_obicno[playerid]);
    mysql_tquery(SQL, query, "MySQL_RefStatus", "ii", playerid, cinc[playerid]);
}

// CMD:akcija(playerid, const params[])
// {
//     SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "{00FF00}NAGRADJUJEMO", "\
//         {FFFF00}DOVEDI IGRACE I OSVOJI NAGRADE\n\
//         _____________________________________\n\n\
//         \
//         {FFFFFF}Svaki igac koga dovedete na server, dobice {0068B3}nivo 5.\n\
//         {FFFFFF}Kada taj igrac dostigne {0068B3}nivo 8, {FFFFFF}vi dobijate {00FF00}$250.000, {FFFFFF}a on dobija {00FF00}$50.000.\n\
//         {FFFFFF}Uslov za dobijanje nagrada je da dovedeni igrac bude u BILO KOJOJ organizaciji/mafiji/bandi.\n\n\
//         \
//         {FFFFFF}* Imate pravo da na 8 dovedenih igraca zatrazite kreiranje privatne mafije ili bande, pod uslovom da ti igraci budu njeni clanovi.\n\
//         {FFFFFF}Komandom {FFFF80}/refstatus {FFFFFF}mozete proveriti status svih igraca koje ste doveli, njihov level, da li su u organizaciji, itd.\n\n\
//         \
//         {AF28A4}POSEBNA NAGRADA - VIP STATUS\n\
//         _____________________________________\n\
//         {FFFFFF}Top 3 igraca koji do 15.3.2020. dovedu najvise igraca dobijaju VIP Platinum, Gold i Silver (respektivno) u trajanju od {AF28A4}cak 90 dana!\n\n\
//         \
//         {FFFFFF}Za vise informacija obratite se Helperima ili posetite nas forum: "#FORUM, 
//     "U redu", "");
//     return 1;
// }