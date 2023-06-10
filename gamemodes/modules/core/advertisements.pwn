#include <YSI_Coding\y_hooks>

#define MAX_ADS         5
#define MAX_AD_LEN      80
#define AD_CYCLE_TIME   60 // Na koliko sekundi se smenjuju oglasi

static gQueuedAds;
static bool:gHasQueuedAd[MAX_PLAYERS char];
static bool:gAdApproved;
static gAdPrint[145];

hook OnGameModeInit()
{
    mysql_tquery(SQL, "TRUNCATE ads");

    gQueuedAds = 0;
    SetTimer("ADS_ShowAdvert", AD_CYCLE_TIME * 1000, true);
    return true;
}

hook OnPlayerConnect(playerid)
{
    gHasQueuedAd{playerid} = false;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    // Brisanje oglasa koji je igrac dao

    if (!IsPlayerLoggedIn(playerid)) return 1;

    if (DebugFunctions())
    {
        LogCallbackExec("advertisements.pwn", "OnPlayerDisconnect");
    }

    if (gHasQueuedAd{playerid})
    {
        new sQuery[40];
        format(sQuery, sizeof sQuery, "DELETE FROM ads WHERE playerid = %i", playerid);
        mysql_tquery(SQL, sQuery);

        gQueuedAds --;
    }
    return 1;
}

forward MySQL_LoadNextAd();
public MySQL_LoadNextAd()
{
    cache_get_row_count(rows);

    if (rows == 1)
    {
        new id, playerid, text[MAX_AD_LEN + 4];
        cache_get_value_name_int(0, "id", id);
        cache_get_value_name_int(0, "playerid", playerid);
        cache_get_value_name(0, "text", text, sizeof text);

        new sQuery[33];
        format(sQuery, sizeof sQuery, "DELETE FROM ads WHERE id = %i", id);
        mysql_tquery(SQL, sQuery);

        if (IsPlayerConnected(playerid) && IsPlayerLoggedIn(playerid) && gHasQueuedAd{playerid})
        {
            gHasQueuedAd{playerid} = false;
            gAdApproved = true;
            
            new sPhone[13];
            format_phone(playerid, sPhone);

            new sAdPrint_Admin[110];
            format(gAdPrint, sizeof gAdPrint, "[OGLAS] {FFFFFF}%s   {48E31C}kontakt: %s", text, sPhone); // String za igrace
            strins(text, "- ", 0); // Ubacivanje crtice na pocetak zbog ispisivanja adminima (2)
            format(sAdPrint_Admin, sizeof sAdPrint_Admin, "OGLAS | %s[%i] | Telefon: %s | {FF6347}Deaktivacija: {FF0000}/stopad", ime_rp[playerid], playerid, sPhone); // String za admine (1)

            foreach(new i : Player)
            {
                if (IsHelper(i, 1)) 
                {
                    SendClientMessage(i, ZELENA2, sAdPrint_Admin);
                    SendClientMessage(i, BELA, text);
                }
            }

            SetTimer("ShowAdIfApproved", 20000, false);
        }
    }
    return 1;
}

forward ShowAdIfApproved();
public ShowAdIfApproved()
{
    if (gAdApproved)
    {
        foreach(new i : Player)
        {
            if (!IsHelper(i, 1)) 
            {
                SendClientMessage(i, ZELENA2, gAdPrint);
            }
        }

        gAdApproved = false;
    }

    return 1;
}

forward ADS_ShowAdvert();
public ADS_ShowAdvert()
{
    if (DebugFunctions())
    {
        LogFunctionExec("ADS_ShowAdvert");
    }
    if (gQueuedAds > 0)
    {
        gQueuedAds --;
        mysql_tquery(SQL, "SELECT * FROM ads ORDER BY id ASC LIMIT 0,1", "MySQL_LoadNextAd");
    }
    return 1;
}

alias:oglas("ad")
CMD:oglas(playerid, params[145]) 
{
    new bool:smsAd = !!GetPVarInt(playerid, "pSMS_Ad");

    if (!smsAd && !IsPlayerInRangeOfPoint(playerid, 5.0, 1804.9729,-1345.5475,15.2733))
        return ErrorMsg(playerid, "Ne nalazite se na mestu za davanje oglasa. Koristite /smsoglas ili /gps - Oglasnik.");

    if (IsNewPlayer(playerid)) 
        return ErrorMsg(playerid, "Ne mozete dati oglas jer ste jos uvek nov igrac.");
    
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (IsPlayerJailed(playerid) == 1)
        return overwatch_poruka(playerid, "Ne mozete koristiti ovu komandu dok ste zatvoreni.");

    if (!PlayerHasPhone(playerid)) 
        return ErrorMsg(playerid, "Morate imati mobilni telefon da biste mogli da dajete oglase.");
    
    if (!smsAd && PI[playerid][p_novac] < 2000) 
        return ErrorMsg(playerid, "Nemate dovoljno novca! Oglas kosta $2.000.");
    
    if (smsAd && PI[playerid][p_novac] < 5000) 
        return ErrorMsg(playerid, "Nemate dovoljno novca! SMS oglas kosta $5.000.");

    if (gHasQueuedAd{playerid})
        return ErrorMsg(playerid, "Vec imate jedan oglas na cekanju.");
    
    if (isnull(params)) 
        return Koristite(playerid, "oglas [Tekst oglasa]");
    
    if (strlen(params) < 7 || strlen(params) > MAX_AD_LEN) 
        return ErrorMsg(playerid, "Tekst oglasa mora sadrzati vise od 7, a manje od "#MAX_AD_LEN" znakova!");
    
    if (strfind(params, "~", true) != -1) 
        return ErrorMsg(playerid, "Ne mozete koristiti znak \"~\" u oglasu!");

    if (gQueuedAds > MAX_ADS)
        return ErrorMsg(playerid, "Trenutno nema slobodnih mesta za oglase, pokusajte malo kasnije.");

    // Stavljamo veliko pocetno slovo
    params[0] = toupper(params[0]);

    new sQuery[60 + MAX_AD_LEN];
    mysql_format(SQL, sQuery, sizeof sQuery, "INSERT INTO ads (playerid, text) VALUES (%i, '%s')", playerid, params);
    mysql_tquery(SQL, sQuery);


    gQueuedAds ++;
    gHasQueuedAd{playerid} = true;
    if (!smsAd) PlayerMoneySub(playerid, 2000), AdBizMoneyAdd(2000);
    else PlayerMoneySub(playerid, 5000), AdBizMoneyAdd(5000);
    
    // Slanje poruke igracu
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste dali oglas. Vas oglas je {FFFFFF}%i. {33CCFF}po redu.", gQueuedAds);
    SendClientMessageF(playerid, BELA, "    Procenjeno vreme cekanja: {33CCFF}%i minuta.", floatround(gQueuedAds*AD_CYCLE_TIME/60.0));
    
    // Upisivanje u log
    new sLog[MAX_AD_LEN + MAX_PLAYER_NAME];
    format(sLog, sizeof sLog, "%s | %s", ime_obicno[playerid], params);
    Log_Write(LOG_OGLASI, sLog);
    return 1;
}

CMD:smsoglas(playerid, params[145])
{
    if (IsPlayerJailed(playerid) == 1)
        return overwatch_poruka(playerid, "Ne mozete koristiti ovu komandu dok ste zatvoreni.");

    if (isnull(params))
        return Koristite(playerid, "smsoglas [Tekst oglasa]");

    SetPVarInt(playerid, "pSMS_Ad", 1);
    callcmd::oglas(playerid, params);
    DeletePVar(playerid, "pSMS_Ad");
    return 1;
}

flags:stopad(FLAG_HELPER_1)
CMD:stopad(playerid, const params[])
{
    if (!gAdApproved)
        return ErrorMsg(playerid, "Oglas je vec deaktiviran ili je isteklo vreme za deaktivaciju, te je on prikazan svim igracima.");

    gAdApproved = false;

    if (PI[playerid][p_admin] > 0)
    {
        StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je deaktivirao oglas.", ime_rp[playerid]);
    }
    else if (PI[playerid][p_helper] > 0)
    {
        StaffMsg(BELA, "H {8EFF00}| %s je deaktivirao oglas.", ime_rp[playerid]);
    }

    return 1;
}