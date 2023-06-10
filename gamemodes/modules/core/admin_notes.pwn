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
nl_public CheckForNewNotes(playerid)
{
    if (IsAdmin(playerid, 5))
    {
        mysql_tquery(SQL, "SELECT COUNT(*) FROM admin_notes WHERE time >= now() - INTERVAL 1 DAY", "MySQL_CheckForNewNotes", "ii", playerid, cinc[playerid]);
    }
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_CheckForNewNotes(playerid, ccinc);
public MySQL_CheckForNewNotes(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    if (rows)
    {
        new count;
        cache_get_value_index_int(0, 0, count);

        if (count > 0)
        {
            SendClientMessageF(playerid, 0xFF63CCFF, "NOTES | {FFFFFF}U poslednjih 24h dodato je {FF63CC}%i novih beleski {FFFFFF}| /notes za pregled", count);
        }
    }
    return 1;
}

forward MySQL_LatestNotesLoad(playerid, ccinc);
public MySQL_LatestNotesLoad(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    new string[3000];
    format(string, 9, "{FFFFFF}");
    if (rows)
    {
        if (rows > 15) rows = 15;

        new admin[MAX_PLAYER_NAME], igrac[MAX_PLAYER_NAME], text[150], time[6];
        for__loop (new i = 0; i < rows; i++)
        {
            cache_get_value_name(i, "igrac", igrac, sizeof igrac);
            cache_get_value_name(i, "admin", admin, sizeof admin);
            cache_get_value_name(i, "text", text, sizeof text);
            cache_get_value_name(i, "time_f", time, sizeof time);

            format(string, sizeof string, "%s[%s] {FFFF00}%s (dodao %s): {FFFFFF}%s\n", string, time, igrac, admin, text);
        }
    }
    else
    {
        format(string, 51, "{FFFFFF}- Tabela sa napomenama je prazna.");
    }

    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Najnovije beleske", string, "Izadji", "");
    return 1;
}

forward MySQL_AdminNotesLoad(playerid, ccinc, ime[MAX_PLAYER_NAME]);
public MySQL_AdminNotesLoad(playerid, ccinc, ime[MAX_PLAYER_NAME])
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);

	new string[3000];
	format(string, 9, "{FFFFFF}");
	if (rows)
	{
		new admin[MAX_PLAYER_NAME], text[150], time[6];
		for__loop (new i = 0; i < rows; i++)
		{
			cache_get_value_name(i, "admin", admin, sizeof admin);
			cache_get_value_name(i, "text", text, sizeof text);
			cache_get_value_name(i, "time_f", time, sizeof time);

			format(string, sizeof string, "%s[%s] {FFFF00}%s: {FFFFFF}%s\n", string, time, admin, text);
		}
	}
	else
	{
		format(string, 51, "{FFFFFF}- Nema zabeleznih napomena za ovog igraca.");
	}

	SPD(playerid, "admin_notes", DIALOG_STYLE_MSGBOX, ime, string, "+", "Izadji");
	return 1;
}

forward MySQL_AdminNotesAdd(playerid, ccinc);
public MySQL_AdminNotesAdd(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	cache_get_row_count(rows);
	if (rows != 1)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new id, ime[MAX_PLAYER_NAME], string[80];
	cache_get_value_index_int(0, 0, id);

	SetPVarInt(playerid, "adminNotes_PlayerID", id);
	GetPVarString(playerid, "adminNotes_PlayerName", ime, sizeof ime);
	format(string, sizeof string, "{FFFFFF}Unesite novu napomenu za igraca {FFFF00}%s", ime);
	SPD(playerid, "admin_notes_add", DIALOG_STYLE_INPUT, "Dodaj napomenu", string, "Dodaj", "Izadji");
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:admin_notes(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        new sQuery[70], ime[MAX_PLAYER_NAME];
        GetPVarString(playerid, "adminNotes_PlayerName", ime, sizeof ime);
        mysql_format(SQL, sQuery, sizeof sQuery, "SELECT id FROM igraci WHERE ime = '%s'", ime);
        mysql_tquery(SQL, sQuery, "MySQL_AdminNotesAdd", "ii", playerid, cinc[playerid]);
    }
    return 1;
}

Dialog:admin_notes_add(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (isnull(inputtext))
            return DialogReopen(playerid);

        new sQuery[256], id, ime[MAX_PLAYER_NAME];
        id = GetPVarInt(playerid, "adminNotes_PlayerID");
        GetPVarString(playerid, "adminNotes_PlayerName", ime, sizeof ime);
        mysql_format(SQL, sQuery, sizeof sQuery, "INSERT INTO admin_notes (pid, aid, text) VALUES (%i, %i, '%s')", id, PI[playerid][p_id], inputtext);
        mysql_tquery(SQL, sQuery);

        foreach (new i : Player)
        {
            if (IsAdmin(i, 5))
            {
                SendClientMessageF(i, 0xFF63CCFF, "NOTES | {FFFF00}%s[%i] je dodao novu belesku za igraca %s.", ime_rp[playerid], playerid, ime);
                SendClientMessageF(i, BELA, "   * %s", inputtext);
            }
        }
    }
    return 1;
}





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:notes(FLAG_ADMIN_5)

CMD:notes(playerid, const params[])
{
	new id;
	if (sscanf(params, "u", id))
    {
		Koristite(playerid, "notes [Ime ili ID igraca]");
        InfoMsg(playerid, "Prikazivanje poslednjih 15 napomena.");

        new sQuery[241];
        mysql_format(SQL, sQuery, sizeof sQuery, "\
            SELECT i1.ime as igrac, i2.ime as admin, admin_notes.text, DATE_FORMAT(time, '\%%d \%%b') as time_f FROM admin_notes \
            LEFT JOIN igraci i1 ON admin_notes.pid = i1.id \
            LEFT JOIN igraci i2 ON admin_notes.aid = i2.id \
            ORDER BY time DESC LIMIT 0,15");
        mysql_tquery(SQL, sQuery, "MySQL_LatestNotesLoad", "ii", playerid, cinc[playerid]);
        return 1;
    }

	new ime[MAX_PLAYER_NAME];
	if (IsPlayerConnected(id))
		format(ime, sizeof ime, "%s", ime_obicno[id]);
	else
		format(ime, sizeof ime, "%s", params);

	new sQuery[280];
	mysql_format(SQL, sQuery, sizeof sQuery, "\
		SELECT igraci.ime as admin, admin_notes.text, DATE_FORMAT(time, '\%%d \%%b') as time_f FROM admin_notes \
		LEFT JOIN igraci ON admin_notes.aid = igraci.id \
		WHERE admin_notes.pid  IN (SELECT id FROM igraci WHERE ime = '%s') \
        ORDER BY time DESC LIMIT 0,15", ime);
	mysql_tquery(SQL, sQuery, "MySQL_AdminNotesLoad", "iis", playerid, cinc[playerid], ime);

	SetPVarString(playerid, "adminNotes_PlayerName", ime);
	return 1;
}