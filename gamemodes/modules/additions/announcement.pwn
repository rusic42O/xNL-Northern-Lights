#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum
{
	ANNOUNCEMENT_TYPE_ADMIN = 0,
	ANNOUNCEMENT_TYPE_HELPER,
	ANNOUNCEMENT_TYPE_PROMO,
	ANNOUNCEMENT_TYPE_LIDER,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new bool:pAnnouncement[MAX_PLAYERS char]; // Da li je obavestenje vec bilo prikazano u tekucoj sesiji?




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)	// pregledao daddyDOT
{
	pAnnouncement{playerid} = false;
}

hook OnPlayerSpawn(playerid)
{
	if (!pAnnouncement{playerid} && PI[playerid][p_announcement] == 0)
	{
		pAnnouncement{playerid} = true;
		ShowAnnouncement(playerid);
	}
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock ShowAnnouncement(playerid)
{
	#pragma unused playerid

	// if (IsACop(playerid))
	// {
	// 	SPD(playerid, "playerAnnouncement", DIALOG_STYLE_MSGBOX, "{FF0000}IZMENA PRAVILA", "{FFFFFF}Obavestavamo te da je od danas {FFFF00}taz na gun -- {FF0000}ZABRANJEN.\n\n\
	// 		{FFFFFF}Server automatski detektuje i kaznjava ovaj prekrsaj: {FF9900}Alcatraz 60 min, -$50.000\n\n\
	// 		{FFFFFF}Tazovanje igraca je {00FF00}dozvoljeno {FFFFFF}ako prilazite s ledja!", "Razumem", "");
	// }
	// else
	// {
	//     SPD(playerid, "playerAnnouncement", DIALOG_STYLE_MSGBOX, "{00FF00}NAGRADJUJEMO", "\
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
	// }
	
	return 1;
}

forward MySQL_StaffAnnouncement(playerid, ccinc, type);
public MySQL_StaffAnnouncement(playerid, ccinc, type)
{
	if (!checkcinc(playerid, ccinc)) return 1;


	new sTitle[17];
	SetPVarInt(playerid, "pAnnouncementEditType", type);
	cache_get_row_count(rows);
	switch (type)
	{
		case ANNOUNCEMENT_TYPE_ADMIN: 	sTitle = "{1275ED}Admin";
		case ANNOUNCEMENT_TYPE_HELPER: 	sTitle = "{8EFF00}Helper";
		case ANNOUNCEMENT_TYPE_PROMO: 	sTitle = "{AF28A4}Promoter";
		case ANNOUNCEMENT_TYPE_LIDER: 	sTitle = "Lider";
	}

	if (!rows)
	{
		// Nema aktivnog obavestenja za taj tip
		
		// SPD(playerid, "staffAnnouncementList", sTitle, 	"-- Dodaj poruku", "Izaberi", "Nazad");
	}
	else
	{
		// Pronadjeno je obavestenje

		new sAuthor[MAX_PLAYER_NAME], sDialog[5*145];
		sDialog[0] = EOS;
		cache_get_value_name(0, "author", sAuthor, sizeof sAuthor);
		for__loop (new i = 0; i < rows; i++)
		{
			new msgId, sTextShort[50];
			cache_get_value_name(i, "text", sTextShort, sizeof sTextShort);
			cache_get_value_name_int(i, "msgNum", msgId);

			format(sDialog, sizeof sDialog, "%s\n%i: %s", sDialog, msgId, sTextShort);
		}

		format(sDialog, sizeof sDialog, "%s\n-- Izbrisi obavestenje\n-- Dodaj poruku", sDialog);
		SPD(playerid, "staffAnnouncementList", DIALOG_STYLE_LIST, sTitle, sDialog, "Izaberi", "Nazad");
	}

	return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:playerAnnouncement(playerid, response, listitem, const inputtext[])
{
	SPD(playerid, "playerAnnouncement2", DIALOG_STYLE_LIST, "{FFFFFF}ADRESA FORUMA: {00FF00}www.nlsamp.com", "Ponovo prikazi obavestenje\n---\nPodseti me kasnije ponovo\nNe prikazuj vise", "Potvrdi", "");
	return 1;
}

Dialog:playerAnnouncement2(playerid, response, listitem, const inputtext[])
{
	if (listitem == 1) return DialogReopen(playerid);

	if (listitem == 0) return ShowAnnouncement(playerid);

	if (listitem == 2)
		return InfoMsg(playerid, "Ovo obavestenje cete dobiti kada se sledeci put budete ulogovali na server.");

	if (listitem == 3) // Ne prikazuj vise
	{
		PI[playerid][p_announcement] = 1;

		new query[53];
		format(query, sizeof query, "UPDATE igraci SET announcement = 1 WHERE id = %i", PI[playerid][p_id]);
		mysql_tquery(SQL, query);

		InfoMsg(playerid, "Vise Vam necemo prikazivati ovo obavestenje.");
	}
	return 1;
}

Dialog:staffAnnouncement(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		DeletePVar(playerid, "pAnnouncementEditMsg");
		DeletePVar(playerid, "pAnnouncementEditType");
	}
	else
	{
		if (listitem == ANNOUNCEMENT_TYPE_ADMIN) // Admin
		{
			if (!PlayerFlagGet(playerid, FLAG_ADMIN_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_6))
				return ErrorMsg(playerid, GRESKA_NEMADOZVOLU), DialogReopen(playerid);
		}

		else if (listitem == ANNOUNCEMENT_TYPE_HELPER) // Helper
		{
			if (!PlayerFlagGet(playerid, FLAG_HELPER_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_6))
				return ErrorMsg(playerid, GRESKA_NEMADOZVOLU), DialogReopen(playerid);
		}

		else if (listitem == ANNOUNCEMENT_TYPE_PROMO) // Promoter
		{
			if (!PlayerFlagGet(playerid, FLAG_PROMO_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_6))
				return ErrorMsg(playerid, GRESKA_NEMADOZVOLU), DialogReopen(playerid);
		}

		else if (listitem == ANNOUNCEMENT_TYPE_LIDER) // Lider
		{	
			if (!PlayerFlagGet(playerid, FLAG_LEADER_VODJA) && !PlayerFlagGet(playerid, FLAG_ADMIN_6))
				return ErrorMsg(playerid, GRESKA_NEMADOZVOLU), DialogReopen(playerid);
		}

		new sQuery[63];
		format(sQuery, sizeof sQuery, "SELECT * FROM announcements WHERE type = %i ORDER BY msgNum ASC", listitem);
		mysql_tquery(SQL, sQuery, "MySQL_StaffAnnouncement", "iii", playerid, cinc[playerid], listitem);
	}
	return 1;
}

Dialog:staffAnnouncementList(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		return callcmd::obavestenje(playerid, "");
	}
	else
	{
		new sTitle[17], 
			announcementType = GetPVarInt(playerid, "pAnnouncementEditType")
		;
		switch (announcementType)
		{
			case ANNOUNCEMENT_TYPE_ADMIN: 	sTitle = "{1275ED}Admin";
			case ANNOUNCEMENT_TYPE_HELPER: 	sTitle = "{8EFF00}Helper";
			case ANNOUNCEMENT_TYPE_PROMO: 	sTitle = "{AF28A4}Promoter";
			case ANNOUNCEMENT_TYPE_LIDER: 	sTitle = "Lider";
		}


		if (!strcmp(inputtext, "-- Dodaj poruku"))
		{
			SPD(playerid, "staffAnnouncementAdd", DIALOG_STYLE_INPUT, sTitle, "{FFFFFF}Unesite tekst poruke:", "Dodaj", "Nazad");
		}

		else if (!strcmp(inputtext, "-- Izbrisi obavestenje"))
		{
			// SPD(playerid, "staffAnnouncementAdd", DIALOG_STYLE_INPUT, sTitle, "{FFFFFF}Unesite tekst poruke:", "Dodaj", "Nazad");
		}

		else
		{
			// Kliknuo na neku poruku - dati im mogucnost za izmenu ili brisanje
 
			new sDialog[220], sMsgText[146];

			// Izvlacenje msgNum
			format(sMsgText, sizeof sMsgText, "%s", inputtext);
			strdel(sMsgText, strfind(sMsgText, ":"), strlen(sMsgText));
			SetPVarInt(playerid, "pAnnouncementEditMsg", strval(sMsgText));

			// Izvlacenje teksta poruke
			format(sMsgText, sizeof sMsgText, "%s", inputtext);
			strdel(sMsgText, 0, strfind(sMsgText, ":")+1);

			format(sDialog, sizeof sDialog, "{FFCC00}%s\n\n{FFFFFF}Da izbrisete ovu poruku, upisite {CC0000}ukloni.", sMsgText);
			SPD(playerid, "staffAnnouncementEdit", DIALOG_STYLE_INPUT, sTitle, sDialog, "Izmeni", "Nazad");
		}
	}
	return 1;
}

Dialog:staffAnnouncementEdit(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		dialog_respond:staffAnnouncement(playerid, 1, GetPVarInt(playerid, "pAnnouncementEditType"), "");
	}
	else
	{
		if (strlen(inputtext) > 145)
			return ErrorMsg(playerid, "Tekst je sadrzi %i karaktera. Dozvoljeno je do 145.", strlen(inputtext)), DialogReopen(playerid);
		
		new msgNum = GetPVarInt(playerid, "pAnnouncementEditMsg");

        #pragma unused msgNum
		
	}
	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:obavestenje("obavijest", "obavjest")
flags:obavestenje(FLAG_ADMIN_6 | FLAG_ADMIN_VODJA | FLAG_HELPER_VODJA | FLAG_PROMO_VODJA | FLAG_LEADER_VODJA)
CMD:obavestenje(playerid, const params[])
{
	SPD(playerid, "staffAnnouncement", DIALOG_STYLE_LIST, "Obavestenja", "Admin\nHelper\nPromoter\nLider", "Dalje", "Izadji");
	return 1;
}