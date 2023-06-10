// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:komande(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

    new cmdString[1800];
    switch (listitem) 
    {
        case 0: // Opste komande
        {
            format(cmdString, sizeof cmdString, "{FFFF00}- OPSTE KOMANDE -\n\n\
                {FFFF00}BANKA | {FFFFFF}/kredit, /banka, /kartica, /bankomat, /ponistitransfer\n\
                {FFFF00}PRIJAVE | {FFFFFF}/new, /askq, /report, /n\n\
                {FFFF00}EVENTI | {FFFFFF}/trka, /deaktiviraj, /trkaucesnici, /dm, /dmnapusti, /etp\n\
                {FFFF00}IMOVINA | {FFFFFF}/imovina, /nekretnine, /vozila, /iznajmisobu, /odjavisobu, /odjavihotel\n\
                {FFFF00}VOZILA | {FFFFFF}/vozila, /vopcije, /registracija, /autopijaca, /kanister, /popravi, /kradja\n\
                {FFFF00}RENT VOZILA | {FFFFFF}/iznajmi, /odjavi, /rlociraj\n\
                {FFFF00}POSLOVI | {FFFFFF}/poslovi, /oprema, /otkaz, /prekiniposao\n\n\
                \
                {00FF00}ACCOUNT | {FFFFFF}/ucp, /aktivnaigra, /token, /promenilozinku, /spawn, /ranac, /stvari, /ref, /refstatus\n\
                {FF9900}KOMANDE | {FFFFFF}/skill, /gps, /plati, /mobilni, /lideri, /refresh, /cp, /ts3, /id, /time, /oglas\n\
                {FF9900}KOMANDE | {FFFFFF}/dajoruzje, /pokazidozvole, /radio (/ipod), /payday, /bribe, /mdma, /heroin, /adrenalin, /weed\n\
                {FF9900}KOMANDE | {FFFFFF}/jackpot, /izracunaj, /ponudi, /prihvati, /mehanicari\n\
                {FF9900}KOMANDE | {FFFFFF}/ukradi, /kradja, /postavibombu, /isteraj, /pojas, /kaucija, /zaposleni, /djevi, /music"); ///pozovitaxi, /taksisti,
        }

        case 1: // Chat komande
        {
            format(cmdString, sizeof cmdString, "{FFFF00}- CHAT KOMANDE -\n\n\
                {FFFF00}CHAT | {FFFFFF}/chat, /b, /s, /c, /cw, /n, /ds, /me, /do, /naglasak\n\
                {FF9900}TELEFON | {FFFFFF}/mobilni, /pozovi, /javise, /prekini, /odbij, /sms, /broj");
        }

        case 2: // Organizacije
        {
            new fName[32], fColor[7],
                f_id = GetPlayerFactionID(playerid);

            if (f_id == -1)
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

            GetFactionName(f_id, fName, sizeof fName);
            GetFactionRGB(f_id, fColor, sizeof fColor);
            format(cmdString, sizeof cmdString, "{%s} - %s -\n\n{FFFFFF}", fColor, fName);

            if (IsACriminal(playerid))
            {
                format(cmdString, sizeof cmdString, "%s\
                    /%s, /skill, /clanovi, /f, /vuci, /pusti, /gepek, /zavezi, /odvezi, /lisice\n\
                    /warstats, /warscore, /wa, /napustiwar, /pljacka, /kradja /ukradizlato\n\
                    LIDER: /lider", cmdString, faction_name(f_id, FNAME_LOWER));
                format(cmdString, sizeof cmdString, "%s\n\n*** Broj za dostavu materijala: {FFFF00}069/666-999", cmdString);
            }
            else if (IsACop(playerid))
            {
                format(cmdString, sizeof cmdString, "%s\
                    /pdhelp, /skill, /org, /clanovi, /r, /d, /trazeni, /pretresi, /trazidozvole\n\
                    /proverivozilo, /tazer, /m, /bork, /kazna, /pu, /sos, /lisice, /rot, /proveripojas\n\
                    /vuci, /pusti, /dosije, /prepreka, /uhapsi, /atmloc, /vlada, /cctv, /lociraj\n\
                    /ukradizlato", cmdString);
            }
            else return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

            if (IsLeader(playerid))
            {
                format(cmdString, sizeof cmdString, "%s\n\n{CD5C5C} - LIDER KOMANDE -\n{FFFFFF}/lider, /war, /reketpodigni", cmdString);
            }
        }

        case 3: // Staff komande
        {
            if (!IsHelper(playerid, 1))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

            format(cmdString, sizeof cmdString, "{8EFF00}\
                - HELPER KOMANDE -\n\n\
                \
                HELPER 1 | {FFFFFF}/h, /ho, /h1, /h2, /pm, /n, /acceptnew, /pitanja, /veh, /dveh, /staff\n{8EFF00}\
                HELPER 1 | {FFFFFF}/tp, /ptp, /idido, /dovedi, /novajlije, /utisani, /zatvoreni, /afkeri\n{8EFF00}\
                HELPER 1 | {FFFFFF}/fv, /rtc, /postavi, /cc, /nick, /oznaci, /naoznaceno, /uklonioznaku");


            if (IsHelper(playerid, 2))
            {
                format(cmdString, sizeof cmdString, "%s\n{8EFF00}HELPER 2 | {FFFFFF}/proveri, /kick", cmdString);
            }
            if (IsHelper(playerid, 3))
            {
                format(cmdString, sizeof cmdString, "%s\n{8EFF00}HELPER 3 | {FFFFFF}/respawn, /zamrzni, /odmrzni, /osamari, /ubij, /spec", cmdString);
            }
            if (IsHelper(playerid, 4))
            {
                // Nista
            }


            // EVENT KOMANDE
            if (IsHelper(playerid, 1))
            {
                format(cmdString, sizeof cmdString, "%s\n\n{FF9900}\
                    EVENT | {FFFFFF}/trka, /402, /dmevent, /vs, /e, /t, /oznaci event\n{FF9900}\
                    EVENT | {FFFFFF}/ekreiraj, /eunisti, /eport, /enitro, /elock, /erespawn, /epopravi", cmdString);
            }


            // ADMIN KOMANDE
            if (IsAdmin(playerid, 1))
            {
                format(cmdString, sizeof cmdString, "%s\n\n\n{0068B3}\
                    - ADMIN KOMANDE -\n\n\
                    \
                    ADMIN 1 | {FFFFFF}/a, /ao, /kazni, /war, /turftp, /jetpack, /oslobodi, /proveraip, /rv\n{0068B3}\
                    ADMIN 1 | {FFFFFF}/eksplodiraj, /push", cmdString);
            }
            if (IsAdmin(playerid, 2))
            {
                format(cmdString, sizeof cmdString, "%s\n{0068B3}ADMIN 2 | {FFFFFF}/banka, /razoruzaj, /padobran, /ban, /bannick, /banip, /vreme", cmdString);
            }
            if (IsAdmin(playerid, 3))
            {
                format(cmdString, sizeof cmdString, "%s\n{0068B3}ADMIN 3 | {FFFFFF}/aveh, /baninfo, /izlecisve, /aizleci, /pancir, /nahranisve, /refill", cmdString);
            }
            if (IsAdmin(playerid, 4))
            {
                format(cmdString, sizeof cmdString, "%s\n{0068B3}ADMIN 4 | {FFFFFF}/area, /utisaj, /warn, /l, /unbanip, /napunivozila", cmdString);
            }
            if (IsAdmin(playerid, 5))
            {
                format(cmdString, sizeof cmdString, "%s\n{0068B3}ADMIN 5 | {FFFFFF}/lider, /checkprop, /offprovera, /fslusaj, /refcheck, /setstats, /promoteri, /offban", cmdString);
            }
            if (IsAdmin(playerid, 6))
            {
                format(cmdString, sizeof cmdString, "%s\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/lider, /checkprop, /offprovera, /fslusaj, /refcheck, /setstats, /promoteri, /offban\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/ha, /hao, /notes, /staff, /zaduzenja, /zabrana, /promonagrade, /opomene, /server, /gmx\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/unban, /nagradisve, /editprop, /transfer, /fine, /setitem, /itemids, /promeniime, /salon\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/getveh, /gotoveh, /enterveh, /nitro, /setgun, /dobadana, /playmusic, /kreirajkod\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/gt, /scm, /scmta, /bport, /xport, /unisti, /ididocp, /ididorcp, /kucatp, /firmatp\n{0068B3}\
                    ADMIN 6 | {FFFFFF}/resetpin, /resetpw, /tuningpass", cmdString);
            }
        }

        case 4: // VIP komande
        {
            if (!IsVIP(playerid, 1))
                return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

            format(cmdString, sizeof cmdString, "{8EFF00}- VIP KOMANDE -\n\nBRONZE | {FFFFFF}/port, /fv, /pv, /goto");


            if (IsVIP(playerid, 2))
            {
                format(cmdString, sizeof cmdString, "%s\n{8EFF00}SILVER | {FFFFFF}/refill, /luckyone", cmdString);
            }

            if (IsVIP(playerid, 3))
            {
                format(cmdString, sizeof cmdString, "%s\n{8EFF00}GOLD | {FFFFFF}/gethere /pm", cmdString);
            }

            if (IsVIP(playerid, 4))
            {
                format(cmdString, sizeof cmdString, "%s\n{8EFF00}PLATINUM | {FFFFFF}/offpm, /chat", cmdString);
            }
        }

        case 5: // Animacije
        {
            format(cmdString, sizeof cmdString, "{FFFF00}- ANIMACIJE -\n\n{FFFFFF}/fall /fallback /injured /akick /spush /lowbodypush /handsup /bomb /drunk /getarrested /laugh /sup\n/basket /headbutt /medic /spray /robman /taichi /lookout /kiss /crossarms /lay /piss /lean\n/deal /crack /groundsit /chat /dance /fucku /strip /hide /vomit /eat /chairsit /reload\n/koface /kostomach /rollfall /carjacked1 /carjacked2 /rcarjack1 /rcarjack2 /lcarjack1 /lcarjack2 /bat\n/lifejump /exhaust /leftslap /carlock /hoodfrisked /lightcig /tapcig /box /lay2 /chant finger\n/shouting /knife /cop /elbow /kneekick /airkick /gkick /gpunch /fstance /lowthrow /highthrow /aim\n/inbedleft /inbedright");
        }
    }
    SPD(playerid, "komande_return", DIALOG_STYLE_MSGBOX, "Komande", cmdString, "Nazad", "");
    DebugMsg(playerid, "strlen = %i", strlen(cmdString));
    return 1;
}

Dialog:komande_return(playerid, response, listitem, const inputtext[])
{
    if (GetPVarInt(playerid, "vipOverride") == 1)
    {
        DeletePVar(playerid, "vipOverride");
        return callcmd::vip(playerid, "");
    }
    else
    {
        return callcmd::komande(playerid, "");
    }
}



// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:komande("cmds", "commands", "help")

CMD:komande(playerid, const params[]) 
{
    SPD(playerid, "komande", DIALOG_STYLE_LIST, "Komande", "Opste komande\nChat komande\nOrganizacija\nStaff komande\nVIP komande\nAnimacije", "Dalje ", "Izadji");
    return 1;
}

CMD:social(playerid, const params[]) 
{
    new str[190+1];
    format(str, sizeof(str), "%s{ffffff}Facebook: {7188da}www.facebook.com/nlOGC\n\
    {ffffff}Discord: {7188da}www.discord.gg/nlOGC\n\
    {ffffff}Portal/Forum: {7188da}www.nlsamp.com\n\
    {ffffff}I", str);
    format(str, sizeof(str), "%sP servera: {7188da}gta.nlsamp.com\n", str);

    SPD(playerid, "socialnecmd", DIALOG_STYLE_LIST, "{ffffff}Socijalne mreze od {7188da}Northern Lights servera", str, "Zatvori", "");     
    return 1;
}

CMD:nl(playerid, const params[]) 
{
    new str[351+1];

    format(str, sizeof(str), "{ffffff}Pogledajte sve informacije o svom profilu {7188da}/stats\n\
    {ffffff}Za pregled svih dostupnih komandi koristite {7188da}/komande\n\
    {ffffff}Pogledajt");
    format(str, sizeof(str), "%se tutorijale i upoznajte se sa serverom {7188da}/tutorial\n\
    {ffffff}Pogledajte i upravljajte svojim rancem {7188da}/ranac\n\
    {ffffff}Sve drustvene mreze i profili na jednom mjestu {7188da}/social\n", str);

    SPD(playerid, "nlcmd", DIALOG_STYLE_LIST, "{ffffff}Dobrodosli na Northern Lights! {7188da}Odaberite zeljenu funkciju", str, "Zatvori", "");
    return 1;
}

Dialog:nlcmd(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;

    switch(listitem)
    {
        case 0: {
            callcmd::ucp(playerid, "");
        }
        case 1: {
            callcmd::komande(playerid, "");
        }
        case 2: {
            callcmd::tutorial(playerid, "");
        }
        case 3: {
            callcmd::ranac(playerid, "");
        }
        case 4: {
            callcmd::social(playerid, "");
        }
    }
    return 1;
}