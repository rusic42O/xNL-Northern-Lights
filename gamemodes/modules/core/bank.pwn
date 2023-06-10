#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static bool:banka;
new gBankaNovci;


// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{

	mysql_tquery(SQL, "SELECT field, value FROM server_info WHERE field = 'banka'", "MySQL_LoadBankInfo");

	banka = false;
    CreateDynamicActor(76, 1458.13123, -994.92719, 25.53390, 180.0, 1, 100.0, 1); // Blagajna
    CreateDynamicActor(76, 1466.12170, -994.93011, 25.53390, 180.0, 1, 100.0, 1); // Kartice
    CreateDynamicActor(76, 1473.74231, -994.94843, 25.53390, 180.0, 1, 100.0, 1); // Krediti

    CreateDynamicMapIcon(1462.1746, -1012.1542, 26.8438, 52, BELA, 0, 0);

    CreateDynamic3DTextLabel("/blagajna", BELA, 1457.7959,-997.5428,25.5261, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("/kartica", BELA, 1465.6864,-997.1131,25.5261, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
    CreateDynamic3DTextLabel("/kredit", BELA, 1473.5359,-997.2178,25.5261, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);

  	CreateDynamic3DTextLabel("[ BANKA ]\n\nRadno vreme:\n09:00 - 01:00\n\n{FFD724}Ako je banka zatvorena,\nkoristite bankomate", 0xFFA724C8, 1462.2893,-1011.3467,26.8438, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);

	return 1;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsBankOpen() 
{
	return banka;
}

stock DodajNovacUBanku(novac)
{
	gBankaNovci = gBankaNovci + novac;

	new query[96];
    format(query, sizeof query, "UPDATE server_info SET value = '%d' WHERE field = 'banka'", gBankaNovci);
    mysql_tquery(SQL, query);
}

stock OduzmiNovacUBanci(novac)
{
	gBankaNovci = gBankaNovci - novac;

	new query[96];
    format(query, sizeof query, "UPDATE server_info SET value = '%d' WHERE field = 'banka'", gBankaNovci);
    mysql_tquery(SQL, query);
}


// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //


forward MySQL_LoadBankInfo();
public MySQL_LoadBankInfo()
{
    cache_get_row_count(rows);

    new row = rows;
    while (row)
    {
        row --;

        new field[12], value[12];
        cache_get_value_name(row, "field", field, sizeof field);
        cache_get_value_name(row, "value", value, sizeof value);

        if (!strcmp(field, "banka", true))
        {
            gBankaNovci = strval(value);
        }
    }
    return 1;
}



// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:kartica(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
	switch (listitem)
	{
	    case 0: strmid(PI[playerid][p_kartica], "Visa", 0, strlen("Visa"), 17);
	    case 1: strmid(PI[playerid][p_kartica], "Maestro", 0, strlen("Maestro"), 17);
	    case 2: strmid(PI[playerid][p_kartica], "Dinacard", 0, strlen("Dinacard"), 17);
	    case 3: strmid(PI[playerid][p_kartica], "Helpercard", 0, strlen("Helpercard"), 17);
	    case 4: strmid(PI[playerid][p_kartica], "American Express", 0, strlen("American Express"), 17);
	    default: return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (01)");
	}
	PI[playerid][p_kartica_pin] = 1000 + random(8999);
	if (PI[playerid][p_banka] <= 0) PI[playerid][p_banka] = 5000; // igrac dobija 5000 ako nije imao nista para
	BankMoneySet(playerid, PI[playerid][p_banka]);
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste izvadili %s karticu.", PI[playerid][p_kartica]);
	SendClientMessageF(playerid, NARANDZASTA, "PIN kod: {FFFFFF}%d, {FF9900}Stanje na racunu: %s", PI[playerid][p_kartica_pin], formatMoneyString(PI[playerid][p_banka]));
	
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET kartica = '%s', kartica_pin = %d, banka = %d WHERE id = %d", PI[playerid][p_kartica], PI[playerid][p_kartica_pin], PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, mysql_upit);
	return 1;
}

Dialog:banka(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
	switch (listitem)
	{
	    case 0: // Stanje racuna
	    {
	        format(string_128, sizeof string_128, "{0068B3}Kartica: {FFFFFF}%s\n{0068B3}PIN kod: {FFFFFF}%d\n\n{0068B3}Stanje na racunu: {FFFFFF}%s", PI[playerid][p_kartica],
	        PI[playerid][p_kartica_pin], formatMoneyString(PI[playerid][p_banka]));
	        SPD(playerid, "banka_return", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: STANJE RACUNA", string_128, "Nazad", "");
			format(string_128, sizeof string_128, "STANJE | Izvrsio: %s", ime_obicno[playerid]);
			Log_Write(LOG_BANKA, string_128);
	    }
	    case 1: // Polaganje novca (depozit)
	    {
	        format(string_128, sizeof string_128, "{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite iznos koji zelite da polozite na racun:", formatMoneyString(PI[playerid][p_banka]));
	        SPD(playerid, "banka_polaganje", DIALOG_STYLE_INPUT, "{0068B3}BANKA: POLAGANJE NOVCA", string_128, "Polozi", "Nazad");
	    }
	    case 2: // Podizanje novca
	    {
	        format(string_128, sizeof string_128, "{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite iznos koji zelite da podignete sa racuna:", formatMoneyString(PI[playerid][p_banka]));
	        SPD(playerid, "banka_podizanje", DIALOG_STYLE_INPUT, "{0068B3}BANKA: PODIZANJE NOVCA", string_128, "Podigni", "Nazad");
	    }
	    case 3: // Transfer novca
	    {
	        // if (PI[playerid][p_nivo] < 5) return ErrorMsg(playerid, "Morate biti najmanje nivo 5 da biste vrsili transfere.");

            new minSec = 50 * 3600;
            if (PI[playerid][p_provedeno_vreme] < minSec)
                return ErrorMsg(playerid, "Morate imati najmanje 50 sati igre da biste mogli da vrsite transfer. Vase vreme igre: %i sati.", floatround(PI[playerid][p_provedeno_vreme]/3600.0));

			if (transfer_ponudjen{playerid}) return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (02)");
	        if (IsPlayerConnected(transfer_id[playerid]))
		 	{
			 	format(string_128, sizeof string_128, "{FF0000}* Vec imate aktivan transfer (igrac: %s).\n\n{0068B3}Da li zelite da ponistite taj transfer i pokrenete novi?",
			 	ime_rp[transfer_id[playerid]]);
			 	SPD(playerid, "banka_transfer_5", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: TRANSFER NOVCA", string_128, "Da, nastavi", "Ne");
			}
	        format(string_128, sizeof string_128, "{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite ime ili ID igraca kome zelite da posaljete novac:", formatMoneyString(PI[playerid][p_banka]));
	        SPD(playerid, "banka_transfer_1", DIALOG_STYLE_INPUT, "{0068B3}BANKA: TRANSFER NOVCA", string_128, "Dalje »", "« Nazad");
	    }
	    case 4: // Donacija
	    {
	    	return InfoMsg(playerid, "Donaciju mozete izvrsiti u opstini.");
	    }
	}
	return 1;
}
Dialog:banka_return(playerid, response, listitem, const inputtext[]) // Banka: vracanje na pocetni dialog
{
	return SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");
}
Dialog:banka_polaganje(playerid, response, listitem, const inputtext[]) // Banka: polaganje novca
{
	if (!response) 
        return SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");

	new iznos;
	if (sscanf(inputtext, "i", iznos))
	   return DialogReopen(playerid);

	if (iznos < 1 || iznos > 10000000)
	{
        ErrorMsg(playerid, "Unesite iznos izmedju $i i $10.000.000.");
	    return DialogReopen(playerid);
	}

	if (iznos > PI[playerid][p_novac])
	{
	    ErrorMsg(playerid, "Nemate toliko novca kod sebe.");
	    return DialogReopen(playerid);
	}

    if ((PI[playerid][p_banka] + iznos) > 999999999)
    {
        ErrorMsg(playerid, "Na bankovnom racunu mozete imati najvise $999.999.999. Unesite neku manji iznos.");
        return DialogReopen(playerid);
    }

	BankMoneyAdd(playerid, iznos);
	PlayerMoneySub(playerid, iznos);

	format(string_128, sizeof string_128, "{FFFFFF}Polozili ste {0068B3}%s {FFFFFF}na bankovni racun.\n\n{0068B3}Novo stanje: {FFFFFF}%s", formatMoneyString(iznos), formatMoneyString(PI[playerid][p_banka]));
	SPD(playerid, "banka_return", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: PODIZANJE NOVCA", string_128, "Zatvori", "");
	
	SendClientMessageF(playerid, 0x00FF00FF, "(banka) {FFFFFF}Polozili ste {00FF00}%s {FFFFFF}na bankovni racun.  Novo stanje: {00FF00}%s", formatMoneyString(iznos), formatMoneyString(PI[playerid][p_banka]));
	
    new query[128];
    format(query, sizeof query, "UPDATE igraci SET novac = %d, banka = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, query);
	
    format(string_128, sizeof string_128, "POLAGANJE | Izvrsio: %s | Iznos: $%d | Novo stanje: $%d", ime_obicno[playerid], iznos, PI[playerid][p_banka]);
	Log_Write(LOG_BANKA, string_128);
	return 1;
}

Dialog:banka_podizanje(playerid, response, listitem, const inputtext[]) // Banka: podizanje novca
{
	if (!response) 
        return SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");
	
    new iznos;
	if (sscanf(inputtext, "i", iznos))
	   return DialogReopen(playerid);

	if (iznos < 1 || iznos > 10000000)
	{
	    ErrorMsg(playerid, "Unesite iznos izmedju $1 i $10.000.000.");
        return DialogReopen(playerid);
	}

	if (iznos > PI[playerid][p_banka])
	{
	    ErrorMsg(playerid, "Nemate toliko novca na racunu.");
        return DialogReopen(playerid);
	}

    if ((PI[playerid][p_novac] + iznos) > 99999999)
    {
        ErrorMsg(playerid, "Mozete nositi najvise $99.999.999 sa sobom. Unesite neku manji iznos.");
        return DialogReopen(playerid);
    }


	BankMoneySub(playerid, iznos);
	PlayerMoneyAdd(playerid, iznos);

	format(string_128, sizeof string_128, "{FFFFFF}Podigli ste {0068B3}%s {FFFFFF}sa bankovnog racuna.\n\n{0068B3}Novo stanje: {FFFFFF}%s", formatMoneyString(iznos), formatMoneyString(PI[playerid][p_banka]));
	SPD(playerid, "banka_return", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: PODIZANJE NOVCA", string_128, "Zatvori", "");
	
	SendClientMessageF(playerid, 0x00FF00FF, "(banka) {FFFFFF}Podigli ste {00FF00}%s {FFFFFF}sa bankovnog racuna.  Novo stanje: {00FF00}%s", formatMoneyString(iznos), formatMoneyString(PI[playerid][p_banka]));
	
    new query[128];
    format(query, sizeof query, "UPDATE igraci SET novac = %d, banka = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, query);
	
    format(string_128, sizeof string_128, "PODIZANJE | Izvrsio: %s | Iznos: $%d | Novo stanje: $%d", ime_obicno[playerid], iznos, PI[playerid][p_banka]);
	Log_Write(LOG_BANKA, string_128);
	return 1;
}

Dialog:banka_transfer_1(playerid, response, listitem, const inputtext[]) // Banka: transfer novca, korak 1: ime igraca
{
	if (!response)
	{
	    transfer_id[playerid] = -1;
		SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");
		return 1;
	}

	new id;
	if (sscanf(inputtext, "u", id))
	   return DialogReopen(playerid);

	if (!IsPlayerConnected(id))
	{
	    ErrorMsg(playerid, GRESKA_OFFLINE);
     	return DialogReopen(playerid);
	}

	if (!strcmp(PI[id][p_kartica], "N/A"))
	{
	    ErrorMsg(playerid, "Taj igrac nema otvoren racun u banci (karticu).");
     	return DialogReopen(playerid);
	}

	if (transfer_ponudjen{id} == true)
	{
	    ErrorMsg(playerid, "Taj igrac vec ima jedan aktivan transfer.");
     	return DialogReopen(playerid);
	}

	transfer_id[playerid] = id;
	transfer_od[id] = playerid;

	format(string_256, sizeof string_256, "{0068B3}Igrac: {FFFFFF}%s[ID: %d]\n{0068B3}Stanje na racunu: {FFFFFF}%s\n\nUpisite iznos koji zelite da posaljete ovom igracu:", ime_rp[id], id, formatMoneyString(PI[playerid][p_banka]));
	SPD(playerid, "banka_transfer_2", DIALOG_STYLE_INPUT, "{0068B3}BANKA: TRANSFER NOVCA", string_256, "Dalje »", "« Nazad");
	return 1;
}

Dialog:banka_transfer_2(playerid, response, listitem, const inputtext[]) // Banka: transfer novca, korak 2: iznos
{
	if (!response)
	{
	    transfer_id[playerid] = -1;
	    format(string_128, sizeof string_128, "{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite ime ili ID igraca kome zelite da posaljete novac:", formatMoneyString(PI[playerid][p_banka]));
     	SPD(playerid, "banka_transfer_1", DIALOG_STYLE_INPUT, "{0068B3}BANKA: PODIZANJE NOVCA", string_128, "Dalje »", "« Nazad");
     	return 1;
	}

	new iznos;
	if (sscanf(inputtext, "i", iznos))
	   return DialogReopen(playerid);

	if (!IsPlayerConnected(transfer_id[playerid]) || transfer_od[transfer_id[playerid]] != playerid)
	{
	    transfer_id[playerid] = -1;
	    format(string_256, sizeof string_256, "{FF0000}* Igrac cije ste ime ili ID uneli je napustio server.\n\n{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite ime ili ID \
		igraca kome zelite da posaljete novac:", formatMoneyString(PI[playerid][p_banka]));
     	return DialogReopen(playerid);
	}

	if (iznos < 50000 || iznos > 50000000)
	{
	    ErrorMsg(playerid, "Unesite iznos izmedju $50.000 i $50.000.000.");
		return DialogReopen(playerid);
	}

	if (iznos > PI[playerid][p_banka])
	{
	    ErrorMsg(playerid, "Nemate toliko novca na racunu.");
		return DialogReopen(playerid);
	}

    if (PI[playerid][p_kredit_otplata] > 0 && (PI[playerid][p_kredit_otplata] - iznos) <= 0)
    {
        new canSend = PI[playerid][p_kredit_otplata] - PI[playerid][p_banka];
        if (canSend < 0) canSend = 0;
        ErrorMsg(playerid, "Imate aktivan kredit. Maksimalan iznos koji mozete da posaljete je %s.", formatMoneyString(canSend));
        return DialogReopen(playerid);
    }

	transfer_iznos[playerid] = iznos;
	transfer_iznos[transfer_id[playerid]] = iznos;

	format(string_256, sizeof string_256, "{0068B3}Igrac: {FFFFFF}%s[ID: %d]\n{0068B3}Iznos: {FFFFFF}%s\n\nDa nastavite, pritisnite \"Potvrdi\".\nDa odustanete, pritisnite \"Nazad\"", ime_rp[transfer_id[playerid]], transfer_id[playerid], formatMoneyString(transfer_iznos[playerid]));
	SPD(playerid, "banka_transfer_3", DIALOG_STYLE_LIST, "{0068B3}BANKA: TRANSFER NOVCA", string_256, "Potvrdi", "Nazad");
	return 1;
}

Dialog:banka_transfer_3(playerid, response, listitem, const inputtext[]) // Banka: transfer novca, korak 3: provera podataka
{
	if (!response || !verify_transfer(playerid))
 	{
	 	SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");
		if (verify_transfer(playerid))
		{
		    new id = transfer_id[playerid];
			transfer_id[id] 	  = -1;
			transfer_od[id] 	  = -1;
			transfer_iznos[id]    = 0;
			transfer_ponudjen{id} = false;
		}
		else SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (03)");

		transfer_id[playerid]	 = -1;
		transfer_od[playerid] 	 = -1;
		transfer_iznos[playerid] = 0;
		return 1;
	}

	if (!IsPlayerConnected(transfer_id[playerid]) || transfer_od[transfer_id[playerid]] != playerid)
	{
	    transfer_id[playerid] = -1;
        return ErrorMsg(playerid, GRESKA_OFFLINE);   
	}

	if (transfer_id[playerid] == playerid)
	{
	    transfer_id[playerid] = -1;
	    return ErrorMsg(playerid, "Ne mozete slati novac sami sebi.");
	}

	if (transfer_ponudjen{transfer_id[playerid]} == true)
	{
	    transfer_id[playerid] = -1;
	    return ErrorMsg(playerid, "Taj igrac vec ima jedan aktivan transfer.");
	}

	transfer_ponudjen{transfer_id[playerid]} = true;
	
    format(string_128, sizeof string_128, "{FFFFFF}* Ponudili ste transfer igracu {0068B3}%s {FFFFFF}u iznosu od {0068B3}%s.", ime_rp[transfer_id[playerid]], formatMoneyString(transfer_iznos[playerid]));
	SPD(playerid, "banka", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: TRANSFER NOVCA", string_128, "U redu", "");
	
    format(string_128, sizeof string_128, "{FFFFFF}Igrac {0068B3}%s {FFFFFF}Vam je ponudio transfer u iznosu od {0068B3}%s.", ime_rp[playerid], formatMoneyString(transfer_iznos[playerid]));
	SPD(transfer_id[playerid], "banka_transfer_4", DIALOG_STYLE_LIST, "{0068B3}BANKA: TRANSFER NOVCA", string_128, "Prihvati", "Odbij");
	
    format(string_128, sizeof string_128, "(Ponuda) Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[transfer_id[playerid]], transfer_iznos[playerid]);
	Log_Write(LOG_TRANSFERI, string_128);
	return 1;
}

Dialog:banka_transfer_4(playerid, response, listitem, const inputtext[]) // Banka: transfer novca, korak 4: potvrda transfera
{
    new id = transfer_od[playerid];
    if (!IsPlayerConnected(id)) 
        return SendClientMessage(playerid, GRAD2, "* Igrac koji Vam je ponudio transfer je napustio server.");

    if (id == playerid) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (04)"), transfer_ponudjen{playerid} = false, transfer_id[playerid] = -1;

	if (!response) // Igrac odbio transfer
	{
	    SendClientMessage(id, TAMNOCRVENA, "(banka) Igrac je odbio Vas transfer.");
	    SendClientMessage(playerid, TAMNOCRVENA, "(banka) Odbili ste transfer.");
		format(string_128, sizeof string_128, "(Odbijen) Izvrsio: %s | Igrac: %s | Iznos: $%d", ime_obicno[playerid], ime_obicno[id], transfer_iznos[playerid]);
		Log_Write(LOG_TRANSFERI, string_128);

		transfer_id[id] = -1;
	    transfer_od[playerid] = -1;
		transfer_iznos[id] = 0;
		transfer_iznos[playerid] = 0;
		transfer_ponudjen{playerid} = false;
	    return 1;
	}

	if (transfer_id[id] != playerid)
	{
	    transfer_od[playerid] = -1;
		transfer_iznos[playerid] = 0;
		transfer_ponudjen{playerid} = false;

		return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (05)");
	}

	new iznos = transfer_iznos[id];
	if (iznos != transfer_iznos[playerid] || !strcmp(PI[id][p_kartica], "N/A") || !strcmp(PI[playerid][p_kartica], "N/A"))
	{
		transfer_id[id] = -1;
	    transfer_od[playerid] = -1;
		transfer_iznos[id] = 0;
		transfer_iznos[playerid] = 0;
		transfer_ponudjen{playerid} = false;

		return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (06)");
	}
	if (iznos > PI[id][p_banka])
	{
	    SendClientMessage(playerid, TAMNOCRVENA, "* Igrac nema dovoljno novca na racunu.");
	    SendClientMessage(id, TAMNOCRVENA, "* Igrac je prihvatio transfer, ali Vi nemate dovoljno novca na racunu.");

		transfer_id[id] = -1;
	    transfer_od[playerid] = -1;
		transfer_iznos[id] = 0;
		transfer_iznos[playerid] = 0;
		transfer_ponudjen{playerid} = false;
	    return 1;
	}
    if ((PI[playerid][p_banka] + iznos) > 999999999)
    {
        SendClientMessage(playerid, TAMNOCRVENA, "* Na racunu mozete imati najvise $999.999.999.");
        SendClientMessage(id, TAMNOCRVENA, "* Igrac ima previse novca na racunu i ne moze primiti ovoliki iznos.");

        transfer_id[id] = -1;
        transfer_od[playerid] = -1;
        transfer_iznos[id] = 0;
        transfer_iznos[playerid] = 0;
        transfer_ponudjen{playerid} = false;
        return 1;
    }

	BankMoneySub(id, iznos);
	BankMoneyAdd(playerid, iznos);


	SendClientMessageF(playerid, ZELENA2, "(banka) {FFFFFF}Primili ste {00FF00}%s {FFFFFF}od {00FF00}%s.", formatMoneyString(iznos), ime_rp[id]);
	SendClientMessageF(id, ZELENA2, "(banka) %s {FFFFFF}je prihvatio Vas transfer u iznosu od {00FF00}%s.", ime_rp[playerid], formatMoneyString(iznos));
	AdminMsg(ZUTA, "TRANSFER | %s[%d] » %s[%d] | %s", ime_rp[id], id, ime_rp[playerid], playerid, formatMoneyString(iznos));
	

    new sQuery[60];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %d WHERE id = %d", PI[id][p_banka], PI[id][p_id]);
	mysql_tquery(SQL, sQuery);
	
    format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %d WHERE id = %d", PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery);

	format(string_128, sizeof string_128, "(Uspesno) %s » %s | $%d", ime_obicno[id], ime_obicno[playerid], iznos);
	Log_Write(LOG_TRANSFERI, string_128);

	transfer_id[id] = -1;
    transfer_od[playerid] = -1;
	transfer_iznos[id] = 0;
	transfer_iznos[playerid] = 0;
	transfer_ponudjen{playerid} = false;
	return 1;
}

Dialog:banka_transfer_5(playerid, response, listitem, const inputtext[]) // Transfer (vec aktivan, ponistiti i pokrenuti novi, ili ostaviti?)
{
	if (!response) // Ostaviti aktivan transfer
	{
	    if (!IsPlayerConnected(transfer_id[playerid])) 
            return SendClientMessage(playerid, ZUTA, "* Odlucili ste da ostavite aktivan transfer, ali je igrac vec prihvatio ili odbio taj transfer.");

	    if (!verify_transfer(playerid))
		{
			SendClientMessage(playerid, SVETLOCRVENA, "* Transfer koji je bio aktivan vise nije validan i automatski je ponisten.");
			transfer_id[playerid] = -1;
			transfer_iznos[playerid] = 0;
			return 1;
		}
	    format(string_128, sizeof string_128, "* Odlucili ste da ostavite aktivan transfer. Sacekajte da %s prihvati ili odbije Vas transfer.", ime_rp[transfer_id[playerid]]);
	    SendClientMessage(playerid, ZELENA2, string_128);
	    return 1;
	}
	else // Ponistiti aktivan transfer i pokrenuti novi
	{
		if (verify_transfer(playerid))
		{
		    new id = transfer_id[playerid];
			transfer_id[id]       = -1;
			transfer_od[id] 	  = -1;
			transfer_iznos[id]    = 0;
			transfer_ponudjen{id} = false;
		}

		SendClientMessage(playerid, SVETLOPLAVA, "* Ponistili ste ponudjeni transfer.");
		format(string_128, sizeof string_128, "(Ponistenje) %s » %s | %s", ime_obicno[playerid], ime_obicno[transfer_id[playerid]], formatMoneyString(transfer_iznos[playerid]));
		Log_Write(LOG_TRANSFERI, string_128);

		transfer_id[playerid]    = -1;
		transfer_od[playerid]    = -1;
		transfer_iznos[playerid] = 0;

	    format(string_256, sizeof string_256, "{FFFF00}* Ponistili ste aktivan transfer, sada mozete da pokrenete novi.\n\n{0068B3}Stanje na racunu: {FFFFFF}%s\n\n{FFFFFF}Upisite ime ili ID \
		igraca kome zelite da posaljete novac:", formatMoneyString(PI[playerid][p_banka]));
        SPD(playerid, "banka_transfer_1", DIALOG_STYLE_INPUT, "{0068B3}BANKA: TRANSFER NOVCA", string_256, "Dalje »", "« Nazad");
	}
	return 1;
}

Dialog:kredit_1(playerid, response, listitem, const inputtext[]) { // Kredit: lista
	if (!response) return 1;

	if (PI[playerid][p_nivo] < 3) 
		return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste mogli da podignete kredit.");

	if (!strcmp(PI[playerid][p_kartica], "N/A")) 
		return ErrorMsg(playerid, "Nemate kreditnu karticu, izvadite je na salteru pored ovog.");

	new nivo = PI[playerid][p_nivo];

	format(string_256, 31, "Paket\tIznos\nPocetni\t$70.000\n");
	if (nivo > 4)  strins(string_256, "Mali\t$100.000\n", 		strlen(string_256), 256);
	if (nivo > 6)  strins(string_256, "Srednji\t$200.000\n", 	strlen(string_256), 256);
	if (nivo > 9)  strins(string_256, "Veliki\t$400.000\n", 	strlen(string_256), 256);
	if (nivo > 12) strins(string_256, "Super\t$750.000\n", 	    strlen(string_256), 256);
	if (nivo > 14) strins(string_256, "Extra\t$1.000.000\n", 	strlen(string_256), 256);
	if (nivo > 19) strins(string_256, "Mega\t$2.000.000\n", 	strlen(string_256), 256);
	if (nivo > 25) strins(string_256, "Giga\t$4.000.000\n", 	strlen(string_256), 256);
	if (nivo > 30) strins(string_256, "Ultra\t$8.000.000\n", 	strlen(string_256), 256);
	if (nivo > 35) strins(string_256, "Premium\t$16.000.000\n", strlen(string_256), 256);
	
	SPD(playerid, "kredit_2", DIALOG_STYLE_TABLIST_HEADERS, "{0068B3}BANKA: KREDIT", string_256, "Odaberi", "Izadji");
	return 1;
}

Dialog:kredit_2(playerid, response, listitem, const inputtext[]) // Kredit: odabir
{
	if (!response) return 1;
	if (PI[playerid][p_kredit_iznos] > 0 && PI[playerid][p_kredit_otplata] > 0)
	{
		ErrorMsg(playerid, "Vec imate aktivan kredit. Otplatite ga da biste mogli da podignete drugi.");
		SendClientMessage(playerid, GRAD2, "Ukoliko su Vam potrebne informacije o kreditu, predjite na salter pored");

		return 1;
	}
    if (!strcmp(PI[playerid][p_kartica], "N/A")) return ErrorMsg(playerid, "Nemate kreditnu karticu, izvadite je na salteru pored ovog.");
	new kredit[16];
	switch (listitem)
	{
	    case 0: // Pocetni
	    {
	        if (PI[playerid][p_nivo] < 3) return ErrorMsg(playerid, "Morate biti nivo 3 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 140000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 70000;
	        kredit = "pocetni";
			OduzmiNovacUBanci(70000);
	    }
	    case 1: // Mali
	    {
	        if (PI[playerid][p_nivo] < 5) return ErrorMsg(playerid, "Morate biti nivo 5 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 200000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 100000;
	        kredit = "mali";
			OduzmiNovacUBanci(100000);
	    }
	    case 2: // Srednji
	    {
	        if (PI[playerid][p_nivo] < 7) return ErrorMsg(playerid, "Morate biti nivo 7 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 400000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 200000;
	        kredit = "srednji";
			OduzmiNovacUBanci(200000);
	    }
	    case 3: // Veliki
	    {
	        if (PI[playerid][p_nivo] < 10) return ErrorMsg(playerid, "Morate biti nivo 10 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 800000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 400000;
	        kredit = "veliki";
			OduzmiNovacUBanci(400000);
	    }
	    case 4: // Super
	    {
	        if (PI[playerid][p_nivo] < 13) return ErrorMsg(playerid, "Morate biti nivo 13 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 1500000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 750000;
	        kredit = "super";
			OduzmiNovacUBanci(750000);
	    }
	    case 5: // Extra
	    {
	        if (PI[playerid][p_nivo] < 15) return ErrorMsg(playerid, "Morate biti nivo 15 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 2000000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 1000000;
	        kredit = "extra";
			OduzmiNovacUBanci(1000000);
	    }
	    case 6: // Mega
	    {
	        if (PI[playerid][p_nivo] < 20) return ErrorMsg(playerid, "Morate biti nivo 20 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 4000000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 2000000;
	        kredit = "mega";
			OduzmiNovacUBanci(2000000);
	    }
	    case 7: // Giga
	    {
	        if (PI[playerid][p_nivo] < 26) return ErrorMsg(playerid, "Morate biti nivo 26 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 8000000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 4000000;
	        kredit = "giga";
			OduzmiNovacUBanci(4000000);
	    }
	    case 8: // Ultra
	    {
	        if (PI[playerid][p_nivo] < 31) return ErrorMsg(playerid, "Morate biti nivo 31 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 16000000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 8000000;
	        kredit = "ultra";
			OduzmiNovacUBanci(8000000);
	    }
		case 9: // Premium
		{
		    if (PI[playerid][p_nivo] < 36) return ErrorMsg(playerid, "Morate biti nivo 36 da biste podigli ovaj kredit.");
			//if(get_server_novac() < 32000000) return ErrorMsg(playerid, "Drzava trenutno nema finansija da podrzi vas kredit.");
	        PI[playerid][p_kredit_iznos] = 16000000;
	        kredit = "premium";
			OduzmiNovacUBanci(16000000);
		}
		default: return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (07)");
	}
 	PI[playerid][p_kredit_otplata] = PI[playerid][p_kredit_iznos] + (PI[playerid][p_kredit_iznos]*10/100);
	PI[playerid][p_kredit_rata] = floatround(PI[playerid][p_kredit_iznos] * 0.01);
	BankMoneyAdd(playerid, PI[playerid][p_kredit_iznos]);

	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET kredit_iznos = %d, kredit_otplata = %d, kredit_rata = %i WHERE id = %d", PI[playerid][p_kredit_iznos], PI[playerid][p_kredit_otplata], PI[playerid][p_kredit_rata], PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
	
    SendClientMessageF(playerid, 0x00FF00FF, "(banka) {FFFFFF}Podigli ste {00FF00}%s kredit {FFFFFF}u iznosu od {00FF00}%s.", kredit, formatMoneyString(PI[playerid][p_kredit_iznos]));
	SendClientMessageF(playerid, BELA, "Komande: {00FF00}/kredit");
	
    format(string_128, sizeof string_128, "PODIZANJE | Izvrsio: %s | Iznos: $%d (%s)", ime_obicno[playerid], PI[playerid][p_kredit_iznos], kredit);
	Log_Write(LOG_KREDITI, string_128);
	return 1;
}

Dialog:kredit(playerid, response, listitem, const inputtext[]) // Upravljanje kreditom (info, rata, otplata)
{
	if (!response) return 1;
	if (PI[playerid][p_kredit_iznos] == 0 && PI[playerid][p_kredit_otplata] == 0) return ErrorMsg(playerid, "Nemate aktivan kredit.");
 	if (PI[playerid][p_kredit_iznos] == 0 || PI[playerid][p_kredit_otplata] == 0) return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (08)");
	switch (listitem)
	{
	    case 0: // Informacije
	    {
	        format(string_128, sizeof string_128, "{0068B3}Iznos kredita: {FFFFFF}%s\n{0068B3}Preostalo za otplatu: {FFFFFF}%s\n{0068B3}Iznos rate: {FFFFFF}%s",
	        formatMoneyString(PI[playerid][p_kredit_iznos]), formatMoneyString(PI[playerid][p_kredit_otplata]), formatMoneyString(PI[playerid][p_kredit_rata]));
	        SPD(playerid, "kredit_info", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: KREDIT", string_128, "Zatvori", "");
	    }
	    case 1: // Promena rate
	    {
			format(string_128, sizeof string_128, "{0068B3}Trenutni iznos rate: {FFFFFF}%s\n\nUpisite novi iznos koji zelite postaviti kao ratu kredita:", formatMoneyString(PI[playerid][p_kredit_rata]));
			SPD(playerid, "kredit_rata", DIALOG_STYLE_INPUT, "{0068B3}BANKA: KREDIT", string_128, "Dalje »", "« Nazad");
	    }
	    case 2: // Otplata
	    {
	        format(string_256, sizeof string_256, "{FFFFFF}Iznos kredita: {00FF00}%s\n\n{FFFFFF}Da biste odmah otplatili kredit, morate platiti i kamatu.\nIznos za otplatu sa kamatom: \
			{00FF00}%s\n\n{FFFFFF}Da li ste sigurni da zelite da otplatite kredit?", formatMoneyString(PI[playerid][p_kredit_iznos]), formatMoneyString(PI[playerid][p_kredit_otplata]));
			SPD(playerid, "kredit_otplata", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: KREDIT", string_256, "Potvrdi", "Odustani");
	    }
	}
	return 1;
}

Dialog:kredit_info(playerid, response, listitem, const inputtext[]) // Informacije o kreditu
{
	return SPD(playerid, "kredit", DIALOG_STYLE_LIST, "{0068B3}BANKA: KREDIT", "Informacije\nIznos rate\nOtplati kredit", "Odaberi", "Izadji");
}

Dialog:kredit_rata(playerid, response, listitem, const inputtext[]) // Promena rate kredita
{
	if (!response) 
        return SPD(playerid, "kredit", DIALOG_STYLE_LIST, "{0068B3}BANKA: KREDIT", "Informacije\nIznos rate\nOtplati kredit", "Odaberi", "Izadji");

	if (PI[playerid][p_kredit_iznos] == 0 && PI[playerid][p_kredit_otplata] == 0) 
        return ErrorMsg(playerid, "Nemate aktivan kredit.");

 	if (PI[playerid][p_kredit_iznos] == 0 || PI[playerid][p_kredit_otplata] == 0) 
        return SendClientMessage(playerid, TAMNOCRVENA2, "[bank.pwn] "GRESKA_NEPOZNATO" (09)");

	new iznos;
	if (sscanf(inputtext, "i", iznos))
	   return DialogReopen(playerid);

	if (iznos < 150)
	{
 		ErrorMsg(playerid, "Iznos rate mora biti najmanje $150.");
	    return DialogReopen(playerid);
	}
	if (iznos > floatround(PI[playerid][p_kredit_iznos]/20))
	{
 		ErrorMsg(playerid, "Iznos rate moze biti najvise %s.", formatMoneyString(floatround(PI[playerid][p_kredit_iznos]/20)));
        return DialogReopen(playerid);
	}

	format(string_128, sizeof string_128, "RATA | %s | $%d » $%d", ime_obicno[playerid], PI[playerid][p_kredit_rata], iznos);
	Log_Write(LOG_KREDITI, string_128);
	
    SendClientMessageF(playerid, 0x00FF00FF, "(banka) {FFFFFF}Promenili ste iznos rate za kredit sa {00FF00}%s {FFFFFF}» {00FF00}%s.", formatMoneyString(PI[playerid][p_kredit_rata]), formatMoneyString(iznos));
	
    PI[playerid][p_kredit_rata] = iznos;
	
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET kredit_rata = %d WHERE id = %d", iznos, PI[playerid][p_id]);
	mysql_tquery(SQL, mysql_upit);
	return 1;
}

Dialog:kredit_otplata(playerid, response, listitem, const inputtext[]) // Otplata kredita
{
	if (!response) 
        return SPD(playerid, "kredit", DIALOG_STYLE_LIST, "{0068B3}BANKA: KREDIT", "Informacije\nIznos rate\nOtplati kredit", "Odaberi", "Izadji");
	
    if (PI[playerid][p_banka] < PI[playerid][p_kredit_otplata]) 
        return ErrorMsg(playerid, "Nemate dovoljno novca na racunu. Stavite novac na bankovni racun i pokusajte ponovo.");

	format(string_128, sizeof string_128, "OTPLATA | %s | Kredit: $%d | Za otplatu: $%d", ime_obicno[playerid], PI[playerid][p_kredit_iznos], PI[playerid][p_kredit_otplata]);
	Log_Write(LOG_KREDITI, string_128);
	
	BankMoneySub(playerid, PI[playerid][p_kredit_otplata]);
	PI[playerid][p_kredit_iznos] 	= 0;
	PI[playerid][p_kredit_otplata] 	= 0;
	PI[playerid][p_kredit_rata] 	= 0;

    new query[112];
    format(query, sizeof query, "UPDATE igraci SET kredit_iznos = 0, kredit_otplata = 0, kredit_rata = 0, banka = %d WHERE id = %d", PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, query);
	
    SendClientMessage(playerid, 0x00FF00FF, "(banka) {FFFFFF}Otplatili ste kredit. Ukoliko zelite, mozete podici novi bilo kada.");

	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:kredit(playerid, const params[])
{
	//if(IsPlayerConnected(playerid))
	//	return ErrorMsg(playerid, "Krediti trenutno nisu u funkciji");

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1473.5359,-997.2178,25.5261))
        return ErrorMsg(playerid, "Niste na salteru za kredite.");
	
    if (!strcmp(PI[playerid][p_kartica], "N/A")) 
        return ErrorMsg(playerid, "Nemate kreditnu karticu, izvadite je na salteru pored ovog.");

	if (PI[playerid][p_nivo] < 3) 
        return ErrorMsg(playerid, "Morate biti najmanje nivo 3 da biste podigli kredit.");

    if (PI[playerid][p_kredit_iznos] > 0 && PI[playerid][p_kredit_otplata] > 0) { // Igrac ima aktivan kredit
        SPD(playerid, "kredit", DIALOG_STYLE_LIST, "{0068B3}BANKA: KREDIT", "Informacije\nIznos rate\nOtplati kredit", "Odaberi", "Izadji");
    }
    else 
    {
        if (PI[playerid][p_kredit_iznos] > 0 || PI[playerid][p_kredit_otplata] > 0)
            return ErrorMsg(playerid, "[bank.pwn] "GRESKA_NEPOZNATO" (10)");

        new string[570];
	    format(string, sizeof(string), "\t\t\t{0068B3}Krediti - Informacije\n\n{FFFFFF}- Da biste podigli kredit morate biti najmanje nivo 3.\n- Najmanji iznos kredita \
		je $70.000, a najveci $16.000.000.\n- Kada podignete kredit, necete moci da podignete novi sve dok\novaj postojeci ne otplatite do kraja.\n- Otplata se vrsi svakog PayDay-a, \
		a iznos rate mozete sami birati.\n- Vazno je da na bankovnom racunu imate novac u iznosu rate.\n- Ako nemate toliko, na PayDay-u Vam se nece oduzeti nista.\n");
		format(string, sizeof(string), "%s{FF0000}Morate otplatiti 10%% vise od podignutog iznosa!\n\n{FFFFFF}Ako zelite da podignete kredit, pritisnite \"Dalje\".", string);
		SPD(playerid, "kredit_1", DIALOG_STYLE_MSGBOX, "{0068B3}BANKA: KREDIT", string, "Dalje »", "Izadji");
	}
	return 1;
}

CMD:blagajna(playerid, const params[])
{
	if (IsAdmin(playerid, 4))
	{
	    if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1457.7959,-997.5428,25.5261))
	    {
	        // Igrac je admin i NE nalazi se na salteru -> otvori/zatvori banku
			banka = !banka;

			// Slanje poruke staffu
   			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} %s je %s banku.", ime_rp[playerid], ((banka == false)? ("zatvorio") : ("otvorio")));

   			return 1;
	    }
	}
	
	if(PI[playerid][p_wanted_level] > 0) return ErrorMsg(playerid, "Trazeni ste i vas racun je zamrznut. Ne mozete koristiti usluge bankarstva dok ste na listi trazenih.");

	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1457.7959,-997.5428,25.5261)) 
		return ErrorMsg(playerid, "Niste na salteru u banci.");
		
	if (!strcmp(PI[playerid][p_kartica], "N/A")) 
		return ErrorMsg(playerid, "Nemate kreditnu karticu, izvadite je na salteru pored ovog.");
		
		
	SPD(playerid, "banka", DIALOG_STYLE_LIST, "{0068B3}BANKA", "Stanje racuna\nPolozi novac\nPodigni novac\nTransfer novca\nDonacija", "Odaberi", "Izadji");
	return 1;
}

CMD:kartica(playerid, const params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1465.6864,-997.1131,25.5261)) 
		return ErrorMsg(playerid, "Niste na salteru za uzimanje kreditnih kartica.");
		
	if (strcmp(PI[playerid][p_kartica], "N/A") && !isnull(PI[playerid][p_kartica])) 
		return ErrorMsg(playerid, "Vec imate kreditnu karticu.");
	
	SPD(playerid, "kartica", DIALOG_STYLE_LIST, "{0068B3}KREDITNE KARTICE", "Visa\nMaestro\nDinacard\nHelpercard\nAmerican Express", "Odaberi", "Izadji");
	return 1;
}

CMD:ponistitransfer(playerid, const params[])
{
	if (transfer_id[playerid] == -1) 
		return ErrorMsg(playerid, "Nemate aktivan transfer.");
		
	if (transfer_ponudjen{playerid}) 
		return ErrorMsg(playerid, "Nemate aktivan transfer ka drugom igracu, ali imate ponudjen transfer. Prijavite ovo na forum.");
	
	
	if (verify_transfer(playerid))
	{
	    new id = transfer_id[playerid];
		transfer_id[id] 	  = -1;
		transfer_od[id] 	  = -1;
		transfer_iznos[id]    = 0;
		transfer_ponudjen{id} = false;
	}

	// Slanje poruka igracima
	SendClientMessage(playerid, SVETLOPLAVA, "* Ponistili ste ponudjeni transfer.");
	SendClientMessage(transfer_id[playerid], TAMNOCRVENA, "(banka) Igrac je ponistio ponudjeni transfer.");
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "(Ponistenje) %s » %s | %s", ime_obicno[playerid], ime_obicno[transfer_id[playerid]], formatMoneyString(transfer_iznos[playerid]));
	Log_Write(LOG_TRANSFERI, string_128);

	// Resetovanje varijabli
	transfer_id[playerid]	 = -1;
	transfer_od[playerid] 	 = -1;
	transfer_iznos[playerid] = 0;
	return 1;
}