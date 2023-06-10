#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define CHAT_NEW            1
#define CHAT_FACTION        2
#define CHAT_DEPARTMENT     4
#define CHAT_LEADER         8
#define CHAT_PROMOVIP       16
#define CHAT_REPORT         32
#define CHAT_QUESTION       64
#define CHAT_ADWARNING      128
#define CHAT_SMSADMIN       256
#define CHAT_HELPER         512
#define CHAT_ADMIN          1024
#define CHAT_CONNECTIONS    2048
/*
    U slucaju dodavanja nove stavke, treba je dodati na sledeca mesta:

        CMD:chat
        Dialog:chat_toggle
        ResetAllChats(playerid)      
*/



// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pChat[MAX_PLAYERS];

new const gForbiddenPhrases[][] = 
{
    "Cro", "C-H", "Herze", "LB", "LosBalkan", "Los B", "Balkan", "B-U", "C H", "C/H", "C.H", "C//H", "C///H", "Srv", "Srw", "NB", "Noo", "Nobo", "Under", "serV", "mod", "SL ", " SL", "S L", "S-L", "Story", "Stori", "Life", "MW", "Mean", "While", "AG", "Gaming", "Andreas", "Attox", "Indigo"
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    LimitGlobalChatRadius(15);
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    koristio_chat[playerid] = 0;

    // Ukljucivanje svih chatova (nista ne vidi)
    pChat[playerid] = 0;

    return 1;
}

hook OnPlayerText(playerid, text[]) 
{
    new chat_string[145];
    format(chat_string, 120, "%s", text);

    if (gettime() < koristio_chat[playerid] && !IsAdmin(playerid, 1)) 
    {
        overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde."); 
        return ~0; 
    }

    if (text[0] == '!' && IsHelper(playerid, 1)) // staff chat, obustavi ovo
        return 0;

    if (PhoneCallActive(playerid)) return 0;

    koristio_chat[playerid] = gettime() + 3;
    zastiti_chat(playerid, chat_string);
    SetPlayerChatBubble(playerid, chat_string, 0xFFFF00AA, 15.0, 15000);


    // Slanje range poruke
    if (IsOnDuty(playerid))
    {
        new boja[7];        
        if (IsAdmin(playerid, 6))
        {
            if (!IsPlayerOwner(playerid))
                boja = "FFFF00";
            else
                boja = "d30a0a";
        }
        else if (IsAdmin(playerid, 1))
        {
            boja = "33CCFF";
        }
        else if (IsHelper(playerid, 1))
        {
            boja = "8EFF00";
        }
        else
        {
            boja = "FFFFFF";
        }
        format(chat_string, sizeof chat_string, "{%s}%s: {FFFFFF}%s", boja, ime_rp[playerid], chat_string);
    }
    else
    {
        if (!strcmp(PI[playerid][p_naglasak], "Nista", false, 5)) 
        {
            format(chat_string, sizeof chat_string, "%s: %s", ime_rp[playerid], chat_string);
        }
        else 
        {
            format(chat_string, sizeof chat_string, "%s: [%s] %s", ime_rp[playerid], PI[playerid][p_naglasak], chat_string);
        }
    }
    RangeMsg(playerid, chat_string, BELA, 15.0);
    Log_Write(LOG_CHAT, chat_string);
    return 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock zastiti_chat(playerid, const text[]) 
{
    if (!IsAdmin(playerid, 5))
    {
        new bool:cenzura = false;

        for__loop (new i; i < sizeof(gForbiddenPhrases); i++) 
        {
            if (strfind(text, gForbiddenPhrases[i], true) != -1) 
            {
                cenzura = true;
                break;
            }
        }

        if (cenzura) 
        {
            foreach (new i : Player)
            {
                if (IsAdmin(i, 1) && IsChatEnabled(i, CHAT_ADWARNING))
                {
                    SendClientMessageF(i, 0x95A859FF, "[!!!] %s[%d]: %s", ime_rp[playerid], playerid, text);
                }
            }
        }
    }
    return 1;
}

forward ResetAllChats(playerid);
public ResetAllChats(playerid)
{
    pChat[playerid] = 0;


    // CHAT_NEW
    if (PI[playerid][p_nivo] <= 6 || (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)))
        ChatEnableForPlayer(playerid, CHAT_NEW); // vidi /n do levela 6 ili ako je helper

    // CHAT_FACTION
    if (PI[playerid][p_org_id] != -1)
        ChatEnableForPlayer(playerid, CHAT_FACTION);

    // CHAT_DEPARTMENT
    if (IsACop(playerid))
        ChatEnableForPlayer(playerid, CHAT_DEPARTMENT);

    // CHAT_LEADER
    if (IsLeader(playerid) || IsAdmin(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_LEADER);

    // CHAT_PROMOVIP
    if (IsPromoter(playerid, 1) || IsVIP(playerid, 1) || IsAdmin(playerid, 5) || PlayerFlagGet(playerid, FLAG_PROMO_VODJA))
        ChatEnableForPlayer(playerid, CHAT_PROMOVIP);

    // CHAT_REPORT
    if (IsAdmin(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_REPORT);

    // CHAT_QUESTION
    if (IsHelper(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_QUESTION);

    // CHAT_ADWARNING
    if (IsAdmin(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_ADWARNING);

    // CHAT_SMSADMIN
    if (IsAdmin(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_SMSADMIN);

    // CHAT_HELPER
    if (PlayerFlagGet(playerid, FLAG_HELPER_1))
        ChatEnableForPlayer(playerid, CHAT_HELPER);

    // CHAT_ADMIN
    if (IsAdmin(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_ADMIN);

    // CHAT_CONNECTIONS
    if (IsHelper(playerid, 1))
        ChatEnableForPlayer(playerid, CHAT_CONNECTIONS);

    return 1;
}

stock IsChatEnabled(playerid, chat_id)
{
    return (pChat[playerid] & chat_id);
}

stock ChatToggle(playerid, chat_id)
{
    if (pChat[playerid] & chat_id)
        pChat[playerid] ^= chat_id; // iskljucuje chat

    else
        pChat[playerid] |= chat_id; // ukljucuje chat

    return 1;
}

stock ChatEnableForPlayer(playerid, chat_id)
{
    pChat[playerid] |= chat_id; // ukljucuje chat
    return 1;
}

stock ChatDisableForPlayer(playerid, chat_id)
{
    pChat[playerid] ^= chat_id; // iskljucuje chat
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:chat_toggle(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new chat_id = floatround( floatpower( 2.0, float( listitem ) ) );
    switch (chat_id)
    {
        case CHAT_FACTION:
        {
            if (!IsVIP(playerid, 4) && !IsHelper(playerid, 1))
                return ErrorMsg(playerid, "Samo VIP Platinum moze iskljuciti ovaj kanal.");

            if (PI[playerid][p_org_id] == -1)
                return ErrorMsg(playerid, "Niste clan organizacije/mafije/bande.");
        }

        case CHAT_DEPARTMENT:
        {
            if (!IsVIP(playerid, 4) && !IsAdmin(playerid, 5))
                return ErrorMsg(playerid, "Samo VIP Platinum moze iskljuciti ovaj kanal.");

            if (!IsACop(playerid) && !IsAdmin(playerid, 5))
                return ErrorMsg(playerid, "Niste clan nijedne organizacije/mafije/bande.");
        }

        case CHAT_LEADER:
        {
            if (!IsVIP(playerid, 4) && !IsAdmin(playerid, 5))
                return ErrorMsg(playerid, "Samo VIP Platinum moze iskljuciti ovaj kanal.");

            if (!IsLeader(playerid) && !IsAdmin(playerid, 5))
                return ErrorMsg(playerid, "Niste lider nijedne organizacije/mafije/bande.");
        }

        case CHAT_PROMOVIP:
        {
            if (!IsVIP(playerid, 1) && !IsAdmin(playerid, 5) && !PlayerFlagGet(playerid, FLAG_PROMO_VODJA))
                return ErrorMsg(playerid, "Samo igraci sa VIP statusom mogu iskljuciti ovaj kanal.");
        }

        case CHAT_REPORT:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_QUESTION:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_ADWARNING:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_SMSADMIN:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_HELPER:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_ADMIN:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }

        case CHAT_CONNECTIONS:
        {
            if (!IsAdmin(playerid, 5))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
        }
    }

    ChatToggle(playerid, chat_id);
    InfoMsg(playerid, "%s: %s", inputtext, (IsChatEnabled(playerid, chat_id)? ("{00FF00}ON") : ("{FF0000}OFF")));
    return callcmd::chat(playerid, "");
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:do(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
    
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
    
    if (isnull(params)) 
        return Koristite(playerid, "do [Tekst]");
    
    
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    format(chat_string, sizeof(chat_string), "* %s (( %s ))", params, ime_rp[playerid]);
    RangeMsg(playerid, chat_string, LJUBICASTA, 20.0);
    
    format(chat_string, sizeof(chat_string), "* %s", params);
    SetPlayerChatBubble(playerid, chat_string, LJUBICASTA, 20.0, 7500);
    return 1;
}

CMD:me(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
    
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
    
    if (isnull(params))
        return Koristite(playerid, "me [Tekst]");
    
    
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    format(chat_string, sizeof(chat_string), "* %s %s", ime_rp[playerid], params);
    RangeMsg(playerid, chat_string, LJUBICASTA, 20.0);
    
    format(chat_string, sizeof(chat_string), "* %s", params);
    SetPlayerChatBubble(playerid, chat_string, LJUBICASTA, 20.0, 7500);
    return 1;
}

CMD:cw(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
        
    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Morate biti u vozilu da biste mogli da koristite ovu komandu.");
        
    if (isnull(params)) 
        return Koristite(playerid, "cw [Tekst]");
        
        
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    if (!strcmp(PI[playerid][p_naglasak], "Nista")) 
        format(chat_string, sizeof(chat_string), "%s (u vozilu): %s", ime_rp[playerid], params);
    else 
        format(chat_string, sizeof(chat_string), "%s (u vozilu): [%s] %s", ime_rp[playerid], PI[playerid][p_naglasak], params);
    
    
    new veh = GetPlayerVehicleID(playerid);
    foreach(new i : Player)
    {
        if (GetPlayerVehicleID(i) == veh) 
            SendClientMessage(i, BELA, chat_string);
    }

    Log_Write(LOG_CHAT, chat_string);
    return 1;
}

CMD:c(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
    
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
    
    if (isnull(params)) 
        return Koristite(playerid, "c [Tekst]");
    
    
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    if (!strcmp(PI[playerid][p_naglasak], "Nista")) {
        format(chat_string, sizeof chat_string, "%s (tiho): %s", ime_rp[playerid], params);
    }
    else {
        format(chat_string, sizeof chat_string, "%s (tiho): [%s] %s", ime_rp[playerid], PI[playerid][p_naglasak], params);
    }
    RangeMsg(playerid, chat_string, BELA, 5.0);
    Log_Write(LOG_CHAT, chat_string);
    return 1;
}

CMD:s(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
        
    if (isnull(params)) 
        return Koristite(playerid, "s [Tekst]");
        
        
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    if (!strcmp(PI[playerid][p_naglasak], "Nista")) {
        format(chat_string, sizeof chat_string, "%s vice: %s!!!", ime_rp[playerid], params);
    }
    else {
        format(chat_string, sizeof chat_string, "%s vice: [%s] %s!!!", ime_rp[playerid], PI[playerid][p_naglasak], params);
    }
    RangeMsg(playerid, chat_string, BELA, 50.0);
    Log_Write(LOG_CHAT, chat_string);
    
    return 1;
}

CMD:b(const playerid, params[145])
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");
        
    if (isnull(params)) 
        return Koristite(playerid, "b [Tekst]");
        
    
    new chat_string[145];
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    format(chat_string, sizeof chat_string, "%s: (( %s ))", ime_rp[playerid], params);
    RangeMsg(playerid, chat_string, BELA, 20.0);
    Log_Write(LOG_CHAT, chat_string);
    return 1;
}

CMD:naglasak(playerid, const params[])
{
    // Provera parametara
    new naglasak[13];
    if (sscanf(params, "s[13]", naglasak)) 
    {
        Koristite(playerid, "naglasak [Naglasak koji zelite da koristite]");
        SendClientMessage(playerid, GRAD2, "Dostupno: [Nista] [Americki] [Australijski] [Arapski] [Azijski] [Britanski] [Brazilski] [Balkanski] [Francuski] [Gangsterski]");
        SendClientMessage(playerid, GRAD2, "Dostupno: [Irski] [Italijanski] [Jamajkanski] [Japanski] [Kineski] [Kanadjanski] [Nemacki] [Ruski] [Skotski] [Spanski] [Turski]");
        
        return 1;
    }
        
    // Trazenje naglaska
    new bool:pronadjeno = false;
    for__loop (new i = 0; i < sizeof(gAccents); i++)
    {
        if (!strcmp(gAccents[i], naglasak, true))
        {
            pronadjeno = true;
            PI[playerid][p_naglasak] = gAccents[i];
            
            // Update podataka u bazi
            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET naglasak = '%s' WHERE id = %d", PI[playerid][p_naglasak], PI[playerid][p_id]);
            mysql_tquery(SQL, mysql_upit);
            
            if (!strcmp(naglasak, "Nista", true)) {
                SendClientMessage(playerid, SVETLOPLAVA, "* Iskljucili ste naglasak.");
            }
            else {
                SendClientMessageF(playerid, SVETLOPLAVA, "* Vas naglasak je sada: {FFFFFF}%s.", PI[playerid][p_naglasak]);
            }
            
            break;
        }
    }
    if (!pronadjeno) 
        return ErrorMsg(playerid, "Uneli ste pogresan naglasak, pokusajte ponovo.");
        
    return 1;
}

CMD:chat(playerid, const params[])
{
    /*
        Redosled chatova u stringu mora biti isti kao redosled definicija!!!
    */

    new string[512];
    format(string, sizeof string, "\
        /n (novi)\t%s\n\
        /f, /r (faction, radio)\t%s\n\
        /d (department)\t%s\n\
        /l (leader)\t%s\n\
        /pv (promoter/vip)\t%s\n\
        /prijava\t%s\n\
        /pitanje\t%s\n\
        Ad warning\t%s\n\
        /sms (admin)\t%s\n\
        /h (helper)\t%s\n\
        /a (admin)\t%s\n\
        Connect/Disconnect\t%s",
        (IsChatEnabled(playerid, CHAT_NEW)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_FACTION)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_DEPARTMENT)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_LEADER)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_PROMOVIP)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_REPORT)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_QUESTION)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_ADWARNING)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_SMSADMIN)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_HELPER)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_ADMIN)? ("{00FF00}ON") : ("{FF0000}OFF")),
        (IsChatEnabled(playerid, CHAT_CONNECTIONS)? ("{00FF00}ON") : ("{FF0000}OFF")));

    SPD(playerid, "chat_toggle", DIALOG_STYLE_TABLIST, "Chat ukljuci/iskljuci", string, "Promeni", "Odustani");
    return 1;
}