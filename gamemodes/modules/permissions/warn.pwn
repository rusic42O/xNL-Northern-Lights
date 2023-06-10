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
forward MySQL_Warn(playerid, ccinc, targetid, tcinc, const type[]);
public MySQL_Warn(playerid, ccinc, targetid, tcinc, const type[])
{
    if (!checkcinc(playerid, ccinc) || !checkcinc(targetid, tcinc)) return 1;

    cache_get_row_count(rows);
    if (!rows) return 1;

    new warnCount;
    cache_get_value_index_int(0, 0, warnCount);

    SendClientMessageF(playerid, BELA, "* Broj opomena: {FF6347}%i", warnCount);
    if (!strcmp(type, "igrac", true))
    {
        if (warnCount > 0 && (warnCount == 7 || (warnCount % 5) == 0))
        {
            // Warn se dobija na 5, 7, 10, 15, 20,....
            
            new trajanje = warnCount * 1440; // 1440 minuta = 1 dan (za svaki warn)
            
            // Slanje poruke opomenutom igracu
            ClearChatForPlayer(targetid);
            SendClientMessage(targetid, CRVENA,   "______________________________________________________________________________");
            SendClientMessage(targetid, CRVENA,   "______________________________________________________________________________");
            SendClientMessage(targetid, CRVENA,   "ISKLJUCENJE SA SERVERA");
            SendClientMessageF(targetid, BELA,    "Ime: %s | Nivo: %d", ime_obicno[targetid], PI[targetid][p_nivo]);
            SendClientMessageF(targetid, BELA,    "- Dobili ste {FFFF00}5. {FFFFFF}opomenu od Game Admina %s.", ime_obicno[playerid]);
            SendClientMessageF(targetid, BELA,    "- Trajanje iskljucenja: %d dana", (trajanje/1440));
            SendClientMessageF(targetid, BELA,    "Vasa IP adresa: %s | Datum i vreme: %s", PI[targetid][p_ip], trenutno_vreme());
            SendClientMessage(targetid, ZUTA,     "Ukoliko smatrate da je doslo do greske, slikajte ovo (F8) i zatrazite unban putem foruma: "#FORUM);
            
            // Slanje poruke staffu
            // StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je opomenuo igraca %s[ID: %d], razlog: %s", ime_rp[playerid], ime_rp[id], id, razlog);
            StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je banovan od %s na %d dana (%i opomena).", ime_rp[targetid], ime_rp[playerid], (trajanje/1440), warnCount);

            banuj_igraca(targetid, "Warn", gettime()+trajanje, ime_obicno[playerid], false); // Ban na kraju (zbog kicka)
        }
    }
    else
    {
        if (warnCount >= 3)
        {
            SendClientMessageF(targetid, CRVENA, "Dobili ste 3. opomenu. Pozicija {FFFFFF}%s {FF0000}Vam je automatski oduzeta.", type);
        
            if (!strcmp(type, "lider", true))
            {
                new duration = 15; // duzina zabrane u danima

                dialog_respond:f_smeni_lidera(playerid, 1, 100, ime_obicno[targetid]);

                PI[targetid][p_zabrana_lider] = gettime() + duration*86400;

                // Update podataka u bazi
                new query[65];
                format(query, sizeof query, "UPDATE igraci SET zabrana_lider = %i WHERE id = %i", PI[targetid][p_zabrana_lider], PI[targetid][p_id]);
                mysql_tquery(SQL, query);

                // Upisivanje u log
                new sLog[90];
                format(sLog, sizeof sLog, "LIDER | %s | %s na %i dana (3 opomene)", ime_obicno[playerid], ime_obicno[targetid], duration);
                Log_Write(LOG_ZABRANE, sLog);
            }

            else if (!strcmp(type, "helper", true) || !strcmp(type, "admin", true))
            {
                new duration = 15; // duzina zabrane u danima
                PI[targetid][p_admin] = PI[targetid][p_helper] = 0;
                PI[targetid][p_zabrana_staff] = gettime() + duration*86400;
                FLAGS_SetupStaffFlags(targetid);


                // Update podataka u bazi
                new query[65];
                format(query, sizeof query, "UPDATE igraci SET zabrana_staff = %i WHERE id = %i", PI[targetid][p_zabrana_staff], PI[targetid][p_id]);
                mysql_tquery(SQL, query);
                format(query, sizeof query, "DELETE FROM staff WHERE pid = %d", PI[targetid][p_id]);
                mysql_tquery(SQL, query); // uklonjen noreturn by daddyDOT ->, THREAD_ADMINLEVEL);

                // Upisivanje u log
                new sLog[90];
                format(sLog, sizeof sLog, "STAFF | %s | %s na %i dana (3 opomene)", ime_obicno[playerid], ime_obicno[targetid], duration);
                Log_Write(LOG_ZABRANE, sLog);
            }
        }
    }
    return 1;
}

forward MySQL_CheckWarns(playerid, ccinc, const naslov[]);
public MySQL_CheckWarns(playerid, ccinc, const naslov[])
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (!rows)
        return ErrorMsg(playerid, "Nisu pronadjene aktuelne opomene.");

    new dStr[1700], igrac[MAX_PLAYER_NAME], admin[MAX_PLAYER_NAME], datum[11], razlog[64];
    format(dStr, sizeof dStr, "Igrac\tAdmin\tDatum\tRazlog");
    for__loop (new i = 0; i < rows; i++)
    {
        cache_get_value_index(i, 0, igrac, sizeof igrac);
        cache_get_value_index(i, 1, admin, sizeof admin);
        cache_get_value_index(i, 3, razlog, sizeof razlog);
        cache_get_value_index(i, 4, datum, sizeof datum);

        format(dStr, sizeof dStr, "%s\n%s\t%s\t%s\t%s", dStr, igrac, admin, datum, razlog);
    }

    SPD(playerid, "no_return", DIALOG_STYLE_TABLIST_HEADERS, naslov, dStr, "U redu", "");
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:warnType(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "warnPlayerID");
        return 1;
    }

    if (!IsPlayerConnected(GetPVarInt(playerid, "warnPlayerID")))
        return ErrorMsg(playerid, "Igrac je napustio igru.");

    new type[7];
    format(type, sizeof type, "%s", inputtext);

    type[0] = tolower(type[0]);
    SetPVarString(playerid, "warnType", type);

    new dStr[145],
        targetid = GetPVarInt(playerid, "warnPlayerID");
    format(dStr, sizeof dStr, "{FFFFFF}Igrac: {FF0000}%s[%i]\n{FFFFFF}Tip opomene: {FF0000}%s\n\n{FFFFFF}Unesite razlog za ovu opomenu:", ime_obicno[targetid], targetid, type);
    SPD(playerid, "warnDetails", DIALOG_STYLE_INPUT, ime_obicno[targetid], dStr, "Opomeni", "Odustani");
    return 1;
}

Dialog:warnDetails(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        DeletePVar(playerid, "warnPlayerID");
        return 1;
    }

    if (!IsPlayerConnected(GetPVarInt(playerid, "warnPlayerID")))
        return ErrorMsg(playerid, "Igrac je napustio igru.");


    new targetid = GetPVarInt(playerid, "warnPlayerID"),
        type[7],
        details[64];
    GetPVarString(playerid, "warnType", type, sizeof type);
    format(details, sizeof details, "%s", inputtext);

    // Slanje poruke igracu
    ClearChatForPlayer(targetid);
    SendClientMessage(targetid, CRVENA,   "______________________________________________________________________________");
    SendClientMessage(targetid, CRVENA,   "______________________________________________________________________________");
    SendClientMessage(targetid, CRVENA,   "DOBILI STE OPOMENU");
    SendClientMessageF(targetid, BELA,    "Ime: %s | Nivo: %i | UniqID: %i", ime_obicno[targetid], PI[targetid][p_nivo], PI[targetid][p_id]);
    SendClientMessageF(targetid, BELA,    "- Dobili ste opomenu od Game Admina %s.", ime_obicno[playerid]);
    SendClientMessageF(targetid, BELA,    "- Tip opomene: %s", type);
    SendClientMessageF(targetid, BELA,    "- Razlog opomene: %s", details);
    SendClientMessageF(targetid, BELA,    "Vasa IP adresa: %s | Trenutno vreme: %s", PI[targetid][p_ip], trenutno_vreme());

    SendClientMessageF(playerid, BELA, "{FF6347}- STAFF:{B4CDED} Opomenuli ste igraca %s[%i] (%s / %s)", ime_rp[targetid], targetid, type, details);

    // Upisivanje u bazu
    new sQuery[170];
    mysql_format(SQL, sQuery, sizeof sQuery, "INSERT INTO opomene (player, issuer, type, details) VALUES (%i, %i, '%s', '%s')", PI[targetid][p_id], PI[playerid][p_id], type, details);
    mysql_tquery(SQL, sQuery);

    mysql_format(SQL, sQuery, sizeof sQuery, "SELECT COUNT(*) FROM opomene WHERE player = %i AND type = '%s' AND time >= NOW() - INTERVAL 15 DAY", PI[targetid][p_id], type);
    mysql_tquery(SQL, sQuery, "MySQL_Warn", "iiiis", playerid, cinc[playerid], targetid, cinc[targetid], type);


    // Da li igrac dobija ban?
    // TODO
    return 1;
}



// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:warn(FLAG_ADMIN_5 | FLAG_ADMIN_VODJA | FLAG_LEADER_VODJA | FLAG_HELPER_VODJA)
CMD:warn(playerid, const params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "warn [Ime ili ID igraca]");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    SetPVarInt(playerid, "warnPlayerID", targetid);

    new title[64];
    format(title, sizeof title, "%s - izaberite tip opomene", ime_obicno[playerid]);
    SPD(playerid, "warnType", DIALOG_STYLE_LIST, title, "Igrac\nLider\nHelper\nAdmin", "Dalje", "Odustani");
    return 1;
}

CMD:opomene(playerid, const params[])
{
    if (!PlayerFlagGet(playerid, FLAG_LEADER_VODJA) && !PlayerFlagGet(playerid, FLAG_HELPER_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_6))
    {
        // Nema nikakvu "vaznu" poziciju, moze videti samo svoje opomene
        new query[415];
        format(query, sizeof query, "\
            SELECT i1.ime as player, i2.ime as issuer, opomene.type, opomene.details, DATE_FORMAT(opomene.time, '\%%d/\%%m/\%%Y') as time_f FROM opomene \
            LEFT JOIN igraci i1 ON opomene.player = i1.id \
            LEFT JOIN igraci i2 ON opomene.issuer = i2.id \
            WHERE opomene.player = %i AND opomene.time >= NOW() - INTERVAL 30 DAY \
            ORDER BY opomene.time DESC LIMIT 0,10", PI[playerid][p_id]);
        mysql_tquery(SQL, query, "MySQL_CheckWarns", "iis", playerid, cinc[playerid], ime_obicno[playerid]);
    }
    else
    {
        // Moze pogledati opomene za bilo kog igraca
        new targetid;
        if (sscanf(params, "u", targetid))
        {
            Koristite(playerid, "opomene [Ime ili ID igraca]");
            InfoMsg(playerid, "Prikazivanje 15 najnovijih opomena.");

            new query[345];
            format(query, sizeof query, "\
                SELECT i1.ime as player, i2.ime as issuer, opomene.type, opomene.details, DATE_FORMAT(opomene.time, '\%%d/\%%m/\%%Y') as time_f FROM opomene \
                LEFT JOIN igraci i1 ON opomene.player = i1.id \
                LEFT JOIN igraci i2 ON opomene.issuer = i2.id \
                ORDER BY opomene.time DESC LIMIT 0,15");
            mysql_tquery(SQL, query, "MySQL_CheckWarns", "iis", playerid, cinc[playerid], "Najnovije opomene");
            return 1;
        }

        new ime[MAX_PLAYER_NAME];
        if (IsPlayerConnected(targetid))
            format(ime, sizeof ime, "%s", ime_obicno[targetid]);
        else
            format(ime, sizeof ime, "%s", params);

        new query[435];
        mysql_format(SQL, query, sizeof query, "\
            SELECT i1.ime as player, i2.ime as issuer, opomene.type, opomene.details, DATE_FORMAT(opomene.time, '\%%d/\%%m/\%%Y') as time_f FROM opomene \
            LEFT JOIN igraci i1 ON opomene.player = i1.id \
            LEFT JOIN igraci i2 ON opomene.issuer = i2.id \
            WHERE i1.ime = '%s' AND opomene.time >= NOW() - INTERVAL 30 DAY \
            ORDER BY opomene.time DESC LIMIT 0,15", ime);
        mysql_tquery(SQL, query, "MySQL_CheckWarns", "iis", playerid, cinc[playerid], ime);
    }
    return 1;
}
