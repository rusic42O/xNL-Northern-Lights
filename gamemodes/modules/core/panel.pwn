// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:panel(playerid, response, listitem, const inputtext[]) { // Server panel: prvi izbornik
	if (!response) 
        return 1;

    if (!IsAdmin(playerid, 6)) 
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	switch (listitem) {
	    case 0: { // Server info
            new
                string[1024],
                vreme 	= GetConsoleVarAsInt("weather"),
                port    = GetConsoleVarAsInt("port"),
                maxnpc  = GetConsoleVarAsInt("maxnpc"),
                onfoot  = GetConsoleVarAsInt("onfoot_rate"),
                incar   = GetConsoleVarAsInt("incar_rate"),
                weapon  = GetConsoleVarAsInt("weapon_rate"),
                stream  = GetConsoleVarAsInt("stream_rate"),
                streamd = GetConsoleVarAsInt("stream_distance"),
                naziv[64], mapa[16], verzija[16], password[96], sati[8], ip[16], plugini[96], weburl[32];

			GetConsoleVarAsString("hostname", naziv, 32);
			GetConsoleVarAsString("mapname", mapa, 16);
	        GetConsoleVarAsString("version", verzija, 16);
	        GetConsoleVarAsString("password", password, 96);
	        GetConsoleVarAsString("worldtime", sati, 8);
	        GetConsoleVarAsString("bind", ip, 16);
	        GetConsoleVarAsString("plugins", plugini, 96);
	        GetConsoleVarAsString("weburl", weburl, 32);

	        if (strcmp(password, "")) 
                format(password, 96, "Da (password: %s)", password);
	        else 
                password = "Ne";

	        format(string, sizeof(string), "{0068B3}%s\n\nGame mode:\t{FFFFFF}%s\n{0068B3}Broj igraca:\t{FFFFFF}%d/%d\n{0068B3}Mapa:\t\t{FFFFFF}%s\n{0068B3}Vreme:\t\t{FFFFFF}\
			%d\n{0068B3}Sati:\t\t{FFFFFF}%s\n{0068B3}SA-MP:\t\t{FFFFFF}%s\n{0068B3}Zakljucan:\t{FFFFFF}%s\n\n{0068B3}IP:\t\t\t{FFFFFF}%s\n{0068B3}Port:\t\t{FFFFFF}%d\n\
			{0068B3}Plugini:\t\t{FFFFFF}%s\n{0068B3}Web URL:\t{FFFFFF}%s\n\n{0068B3}maxnpc:\t{FFFFFF}%d\n{0068B3}onfoot_rate:\t{FFFFFF}%d ms\n", naziv,
			MOD_VERZIJA, playersOnline, GetMaxPlayers(), mapa, vreme, sati, verzija, password, ip, port, plugini, weburl, maxnpc, onfoot);

			format(string, sizeof(string), "%s{0068B3}incar_rate:\t{FFFFFF}%d ms\n{0068B3}weapon_rate:\t{FFFFFF}%d ms\n{0068B3}stream_rate:\t{FFFFFF}%d ms\n{0068B3}stream_dist:\t\
			{FFFFFF}%d", string, incar, weapon, stream, streamd);
	        SPD(playerid, "panel_info", DIALOG_STYLE_MSGBOX, "{0068B3}SERVER INFO", string, "Nazad", "");
	    }
        
	    case 1: // Overwatch
	    {
	        SPD(playerid, "panel_ow", DIALOG_STYLE_LIST, "{0068B3}OVERWATCH CONFIG", "Konfiguracija\nPodesavanja\nRezim rada\n/n kanal", "Odaberi", "Nazad");
	    }
	    case 2: // Rcon komande
	    {

	    }
	    case 3: // Obavestenje
	    {
			SPD(playerid, "panel_obavestenje", DIALOG_STYLE_LIST, "{0068B3}OBAVESTENJE", "Novo obavestenje\nIzbrisi obavestenje", "Odaberi", "Nazad");
	    }
	    case 4: // Ucitaj
	    {

	    }
	    case 5: // Spremi
	    {

	    }
	}
	return 1;
}
Dialog:panel_info(playerid, response, listitem, const inputtext[]) // Server panel: info
{
	if (!IsAdmin(playerid, 6)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	return callcmd::panel(playerid, "");
}
/*Dialog:panel_ow(playerid, response, listitem, const inputtext[]) // Server panel: overwatch config
{
	if (!IsAdmin(playerid, 6)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
		
	if (!response) 
		return cmd_panel(playerid, "");
		
	
	switch (listitem)
	{
		case 0: { // Konfiguracija
			string_1024[0] = EOS;
			for__loop (new i = 0; i < sizeof(overwatch_config); i++)
			{
				format(string_1024, 1024, "%s{0068B3}%s: {FFFFFF}%s\n", string_1024, overwatch_config[i][config_name], (overwatch_config[i][config_state])? ("on") : ("{FF6347}off"));
			}
			SPD(playerid, "panel_info", DIALOG_STYLE_MSGBOX, "{0068B3}OVERWATCH CONFIG", string_1024, "Nazad", "");
		}
		case 1: { // Podesavanja
		
		}
		case 2: { // Rezim rada
		
		}
		case 3: { // /n kanal
			new_kanal = new_kanal? false : true;
			
			format(string_64, 64, "/n kanal je sada %s.", (new_kanal)?("ukljucen"):("iskljucen"));
		}
	}

	return 1;
}*/
// Dialog:panel_obavestenje(playerid, response, listitem, const inputtext[]) // Server panel: obavestenje
// {
// 	if (!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
// 	if (!response) return cmd_panel(playerid, "");

// 	switch (listitem)
// 	{
// 	    case 0: // Novo obavestenje
// 	    {
// 			format(string_256, sizeof string_256, "{0068B3}Trenutno obavestenje: {FFFFFF}%s\n\nUpisite tekst novog obavestenja:", kb_info[kb_obavestenje]);
// 			SPD(playerid, "panel_obavestenje_new", DIALOG_STYLE_INPUT, "{0068B3}NOVO OBAVESTENJE", string_256, "Potvrdi", "Nazad");
// 	    }
// 	    case 1: // Izbrisi obavestenje
// 	    {
// 			format(string_256, sizeof string_256, "{FFFFFF}%s\n\nIzbrisati obavestenje?", kb_info[kb_obavestenje]);
// 			SPD(playerid, "panel_obavestenje_del", DIALOG_STYLE_MSGBOX, "{0068B3}BRISANJE OBAVESTENJA", string_256, "Potvrdi", "Nazad");
// 	    }
// 	}

// 	return 1;
// }
// Dialog:panel_obavestenje_new(playerid, response, listitem, const inputtext[]) // Server panel: novo obavestenje
// {
// 	if (!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
// 	if (!response) return SPD(playerid, "panel_obavestenje", DIALOG_STYLE_LIST, "{0068B3}OBAVESTENJE", "Novo obavestenje\nIzbrisi obavestenje", "Odaberi", "Nazad");

// 	if (strlen(inputtext) > 128)
// 	{
// 		format(string_256, sizeof string_256, "{FF0000}Uneto obavestenje je predugacko (max. 128)\n\n{0068B3}Trenutno obavestenje: {FFFFFF}%s\n\nUpisite tekst novog obavestenja:", kb_info[kb_obavestenje]);
// 		SPD(playerid, "panel_obavestenje_new", DIALOG_STYLE_INPUT, "{0068B3}NOVO OBAVESTENJE", string_256, "Potvrdi", "Nazad");

// 		return 1;
// 	}

// 	format(kb_info[kb_obavestenje], sizeof(kb_info[kb_obavestenje]), "OBAVESTENJE:~n~~n~~w~%s", inputtext);
// 	TextDrawSetString(IntroTD[10], kb_info[kb_obavestenje]);

// 	SendClientMessage(playerid, SVETLOPLAVA, "* Novo obavestenje je uspesno postavljeno:");
// 	SendClientMessage(playerid, BELA, inputtext);

// 	format(string_256, sizeof string_256, "NOVO OBAVESTENJE | Izvrsio: %s | %s", ime_obicno[playerid], inputtext);
// 	Log_Write(LOG_SERVERPANEL, string_256);

// 	mysql_format(SQL, mysql_upit, 256, "UPDATE overwatch SET obavestenje = '%s'", kb_info[kb_obavestenje]);
// 	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_OVERWATCHUPDATE);

// 	return 1;
// }
// Dialog:panel_obavestenje_del(playerid, response, listitem, const inputtext[]) // Server panel: izbrisi obavestenje
// {
// 	if (!IsAdmin(playerid, 6)) return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
// 	if (!response) return SPD(playerid, "panel_obavestenje", DIALOG_STYLE_LIST, "{0068B3}OBAVESTENJE", "Novo obavestenje\nIzbrisi obavestenje", "Odaberi", "Nazad");

// 	TextDrawSetString(IntroTD[10], "_");
// 	SendClientMessage(playerid, SVETLOPLAVA, "* Obavestenje je uspesno izbrisano.");

// 	format(string_256, sizeof string_256, "IZBRISANO OBAVESTENJE | Izvrsio: %s | %s", ime_obicno[playerid], kb_info[kb_obavestenje]);
// 	Log_Write(LOG_SERVERPANEL, string_256);

// 	kb_info[kb_obavestenje][0] = '_';
// 	mysql_pquery(SQL, "UPDATE overwatch SET obavestenje = '_'"); // uklonjen noreturn by daddyDOT ->, THREAD_OVERWATCHUPDATE);

// 	return 1;
// }




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:panel(playerid, const params[])
{
	if (!IsAdmin(playerid, 6)) 
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
	SPD(playerid, "panel", DIALOG_STYLE_LIST, "{0068B3}SERVER CONTROL PANEL", "Server Info\nOverwatch\nRcon\nObavestenje\nUcitaj\nSpremi", "Odaberi", "Izadji");

	return 1;
}