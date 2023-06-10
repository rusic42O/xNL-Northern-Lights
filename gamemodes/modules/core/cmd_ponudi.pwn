#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
    OFFER_DELIVERY = 1,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock CheckOffer(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("CheckOffer");
    }

    new error = 0;
    if (!checkcinc(GetPVarInt(playerid, "pOfferReceivedFrom"), GetPVarInt(playerid, "pOfferReceivedFromCheck")))
        error = 1; // Nesto nije u redu sa igracem koji je POSLAO ponudu

    if (!checkcinc(GetPVarInt(playerid, "pOfferReceivedFrom"), GetPVarInt(GetPVarInt(playerid, "pOfferReceivedFrom"), "pOfferSentToCheck")))
        error = 2; // Nesto nije u redu sa igracem koji je PRIMIO ponudu

    if (GetPVarInt(playerid, "pOfferType") != GetPVarInt(GetPVarInt(playerid, "pOfferReceivedFrom"), "pOfferType"))
        error = 3; // Nesto nije u redu sa ponudom. Najverovatnije se desila neka druga ponuda u medjuvremenu


    if (error != 0) {
        ErrorMsg(playerid, "Dogodila se greska prilikom provere ponude. Kod greske: %02d", error);
        return 0;
    }
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:ponuda_dostava(playerid, response, listitem, const inputtext[]) {
    if (!CheckOffer(playerid)) return 1;

    new senderid = GetPVarInt(playerid, "pOfferReceivedFrom");

    if (!response)
        return SendClientMessageF(senderid, SVETLOCRVENA, "* %s je odbio Vasu ponudu za dostavu.", ime_rp[playerid]);


    if (!IsACriminal(senderid))
        return ErrorMsg(playerid, "Igrac koji Vam je poslao ponudu mora biti clan mafije/bande.");

    new faction[10];
    GetFactionTag(PI[senderid][p_org_id], faction, sizeof faction);
    SendClientMessageF(playerid, INFOPLAVA, "* Prihvatili ste ponudu za dostavu od {FFFFFF}%s.", ime_rp[senderid]);
    SendClientMessageF(playerid, INFOPLAVA, "Nakon sto utovarite sve kutije u kamion za dostavu, sedite u kamion i odaberite jednu od ponudjenih zona koja pripada %s {FFFFFF}%s.", faction_name(PI[senderid][p_org_id], FNAME_DATIV), faction);
    
    SetPVarInt(playerid, "pOfferFID", PI[senderid][p_org_id]);
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:ponudi(const playerid, params[]) 
{
    new str[12], id, parametar;
    if (strfind(params, "dostava") != -1 || strfind(params, "dostavu") != -1) // Ponudi: dostava
    {
        if (!IsACriminal(playerid))
            return ErrorMsg(playerid, "Ne mozete ponuditi nikakvu dostavu.");

        if (sscanf(params, "s[7] u", str, id)) 
        {
            Koristite(playerid, "ponudi dostavu [Ime ili ID igraca]");
            SendClientMessage(playerid, GRAD2, "* Onaj ko salje ponudu treba da bude clan mafije/bande, a onaj ko prima/privata treba da ima posao dostavljaca.");
            return 1;
        }

        if (id == playerid)
            return ErrorMsg(playerid, "Ne mozete poslati ponudu samom sebi.");

        if (!IsPlayerConnected(id))
            return ErrorMsg(playerid, GRESKA_OFFLINE);

        if (!IsPlayerNearPlayer(playerid, id))
            return ErrorMsg(playerid, "Taj igrac nije u Vasoj blizini.");

        if (GetPlayerJob(id) != JOB_DOSTAVLJAC)
            return ErrorMsg(playerid, "Ovaj igrac Vam ne moze nista dostaviti.");

        if (CountTurfsOwnedByGroup(PI[playerid][p_org_id]) == 0)
            return ErrorMsg(playerid, "Vasa mafija/banda mora posedovati makar jednu teritoriju.");

        SendClientMessageF(playerid, INFOPLAVA, "Ponudili ste dostavu {FFFFFF}%s.", ime_rp[id]);

        new string[193];
        format(string, sizeof string, "{FFFFFF}Dobili ste ponudu za dostavu od {FFFFFF}%s.\n\n{FFFFFF}Ukoliko prihvatite, Vas zadatak ce biti da prevezete {4655B2}ilegalnu robu {FFFFFF}na zadatu teritoriju.");
        SPD(id, "ponuda_dostava", DIALOG_STYLE_MSGBOX, "{4655B2}PONUDA: DOSTAVA", string, "Prihvati", "Odbij");

        SetPVarInt(id,       "pOfferType", OFFER_DELIVERY);
        SetPVarInt(playerid, "pOfferType", OFFER_DELIVERY);
    }

    else if (strfind(params, "mehanicar") != -1 || strfind(params, "mehanicara") != -1 || strfind(params, "popravka") != -1 || strfind(params, "popravku") != -1 || strfind(params, "popravak") != -1) 
    {
        if (GetPlayerJob(playerid) != JOB_MEHANICAR)
            return ErrorMsg(playerid, "Morate biti zaposleni kao mehanicar da biste ponudili popravku.");

        if (!job_active{playerid})
            return ErrorMsg(playerid, "Morate biti na duznosti da biste ponudili popravku. Koristite {FFFFFF}/oprema.");

        if (sscanf(params, "s[12]ui", str, id, parametar)) 
            return Koristite(playerid, "ponudi popravku [Ime ili ID igraca] [Cena popravke]");

        if (id == playerid)
            return ErrorMsg(playerid, "Ne mozete poslati ponudu samom sebi.");

        if (!IsPlayerConnected(id))
            return ErrorMsg(playerid, GRESKA_OFFLINE);

        if (!IsPlayerNearPlayer(playerid, id))
            return ErrorMsg(playerid, "Taj igrac nije u Vasoj blizini.");

        if (GetPlayerState(id) != PLAYER_STATE_DRIVER)
            return ErrorMsg(playerid, "Taj igrac mora biti na mestu vozaca.");

        if (PI[id][p_nivo] == 1)
            return ErrorMsg(playerid, "Ne mozete ponuditi dopunu goriva igracu koji je nivo 1.");

        if (parametar < 1 || parametar > 5000)
            return ErrorMsg(playerid, "Nepravilan unos za polje \"cena popravke\".");

        if (pMehanicarCooldown[playerid] > gettime())
            return ErrorMsg(playerid, "Nedavno ste vec nudili popravku ili dopunu goriva. Pokusajte ponovo za %s.", konvertuj_vreme(pMehanicarCooldown[playerid] - gettime()));

        SetPVarInt(id, "mehOfferedBy", playerid);
        SetPVarInt(id, "mehOfferPrice", parametar);
        pMehanicarCooldown[playerid] = gettime() + 30;

        SendClientMessageF(playerid, INFOPLAVA, "Ponudili ste popravku {FFFFFF}%s.", ime_rp[id]);
        SendClientMessageF(id, INFOPLAVA, "Mehanicar {FFFFFF}%s {4655B2}je ponudio da Vam popravi vozilo po ceni od {FFFFFF}$%i.", ime_rp[playerid], parametar);
        SendClientMessage(id, INFOPLAVA, "Upisite {FFFFFF}/prihvati popravku {4655B2}da biste prihvatili ovu ponudu.");
    }

    else if (strfind(params, "gorivo") != -1 || strfind(params, "refill") != -1 || strfind(params, "dopuna") != -1 || strfind(params, "dopunu") != -1 || strfind(params, "benzin") != -1) 
    {
        if (GetPlayerJob(playerid) != JOB_MEHANICAR)
            return ErrorMsg(playerid, "Morate biti zaposleni kao mehanicar da biste ponudili dopunu goriva.");

        if (!job_active{playerid})
            return ErrorMsg(playerid, "Morate biti na duznosti da biste ponudili dopunu goriva. Koristite {FFFFFF}/oprema.");

        if (sscanf(params, "s[7]ui", str, id, parametar)) 
            return Koristite(playerid, "ponudi gorivo [Ime ili ID igraca] [Cena dopune goriva]");

        if (id == playerid)
            return ErrorMsg(playerid, "Ne mozete poslati ponudu samom sebi.");

        if (!IsPlayerConnected(id))
            return ErrorMsg(playerid, GRESKA_OFFLINE);

        if (!IsPlayerNearPlayer(playerid, id))
            return ErrorMsg(playerid, "Taj igrac nije u Vasoj blizini.");

        if (GetPlayerState(id) != PLAYER_STATE_DRIVER)
            return ErrorMsg(playerid, "Taj igrac mora biti na mestu vozaca.");

        if (PI[id][p_nivo] == 1)
            return ErrorMsg(playerid, "Ne mozete ponuditi dopunu goriva igracu koji je nivo 1.");

        if (parametar < 1 || parametar > 5000)
            return ErrorMsg(playerid, "Nepravilan unos za polje \"cena dopune goriva\".");

        if (pMehanicarCooldown[playerid] > gettime())
            return ErrorMsg(playerid, "Nedavno ste vec nudili popravku ili dopunu goriva. Pokusajte ponovo za %s.", konvertuj_vreme(pMehanicarCooldown[playerid] - gettime()));

        SetPVarInt(id, "fuelOfferedBy", playerid);
        SetPVarInt(id, "fuelOfferPrice", parametar);
        pMehanicarCooldown[playerid] = gettime() + 30;

        SendClientMessageF(playerid, INFOPLAVA, "Ponudili ste dopunu goriva {FFFFFF}%s.", ime_rp[id]);
        SendClientMessageF(id, INFOPLAVA, "Mehanicar {FFFFFF}%s {4655B2}je ponudio da Vam naspe 5 litara goriva po ceni od {FFFFFF}$%i.", ime_rp[playerid], parametar);
        SendClientMessage(id, INFOPLAVA, "Upisite {FFFFFF}/prihvati gorivo {4655B2}da biste prihvatili ovu ponudu.");
    }

    else 
    {
        Koristite(playerid, "ponudi [Sta nudite] [Ime ili ID igraca] [Paramtera (opciono)]");
        SendClientMessage(playerid, GRAD2, "Dostupno za ponudu: [dostava] [popravka] [gorivo]");
        return 1;
    }

    SetPVarInt(playerid,    "pOfferSentTo",             id);
    SetPVarInt(playerid,    "pOfferSentToCheck",        cinc[id]);
    SetPVarInt(id,          "pOfferReceivedFrom",       playerid);
    SetPVarInt(id,          "pOfferReceivedFromCheck",  cinc[playerid]);
    return 1;
}