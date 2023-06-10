#include <YSI_Coding\y_hooks>

new top10_ResetTime[11];

hook OnGameModeInit()
{
    mysql_tquery(SQL, "SELECT value FROM server_info WHERE field = 'top10_reset'", "MYSQL_Top10Info");
    return true;
}

forward MYSQL_Top10Info();
public MYSQL_Top10Info()
{
    cache_get_row_count(rows);
    if (rows == 1)
    {
        cache_get_value_index(0, 0, top10_ResetTime, sizeof top10_ResetTime);
    }
}

Dialog:top10(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0) // All time
        {
            SPD(playerid, "top10_alltime", DIALOG_STYLE_LIST, "TOP 10", "Najveci level\nNajvise vremena u igri\nNajvise novca", "Odaberi", "Izadji");
        }
        else if (listitem == 1) // Parcijalna
        {
            SPD(playerid, "top10_partial", DIALOG_STYLE_LIST, "TOP 10", "Najvise vremena u igri (aktivno)\nNajvise vremena u igri (afk)\nNajvise vremena u igri (aktivno + afk)\nNajvise novca zaradjeno na poslu\nNajvise vremena na poslu", "Odaberi", "Izadji");
        }
        else if (listitem == 2) // Reset parcijalne
        {
            new dStr[97];
            format(dStr, sizeof dStr, "{FFFFFF}Da li ste sigurni da zelite da {FF0000}resetujete {FFFFFF}statistike od %s?", top10_ResetTime);
            SPD(playerid, "top10_reset", DIALOG_STYLE_MSGBOX, "TOP 10 - RESET", dStr, "Resetuj", "Odustani");
        }
    }
    return 1;
}

Dialog:top10_partial(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (listitem == 0) // Najvise vremena u igri (aktivno)
        {
            
        }
        else if (listitem == 1) // Najvise vremena u igri (afk)
        {
            
        }
        else if (listitem == 2) // Najvise vremena u igri (aktivno + afk)
        {
            
        }
        else if (listitem == 3) // Najvise novca zaradjeno na poslu
        {
            
        }
        else if (listitem == 4) // Najvise vremena na poslu
        {
            
        }
    }
    else
    {
        cmd_top10(playerid, "");
    }
    return 1;
}

Dialog:top10_reset(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        if (!IsAdmin(playerid, 6))
            return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

        mysql_tquery(SQL, "TRUNCATE top_10");

        StaffMsg(CRVENA, "Head admin %s je resetovao TOP 10 statistiku.", ime_rp[playerid]);
    }
    else
    {
        cmd_top10(playerid, "");
    }
    return 1;
}

CMD:top10(playerid, const params[])
{
    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    SPD(playerid, "top10", DIALOG_STYLE_LIST, "TOP 10", "All-time top 10\nTop 10 od %s\n-- RESETUJ TOP 10", "Odaberi", "Izadji");
    return 1;
}