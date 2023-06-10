#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new
	event_vozilo[5][16],
	bool:respawn_pokrenut, 					
	bool:grupa_kreirana[5],                 
	bool:grupa_nitro[5],
    bool:grupa_zakljucana[5]
;




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
	Create3DTextLabel("Grupa [1]", 0x1275EDFF, 2444.8315,2530.5205,25.6478, 50.0, 0);
 	Create3DTextLabel("Grupa [2]", 0x1275EDFF, 2447.5786,2563.1384,25.6466, 50.0, 0);
 	Create3DTextLabel("Grupa [3]", 0x1275EDFF, 2437.0088,2547.9617,25.6462, 50.0, 0);
 	Create3DTextLabel("Grupa [4]", 0x1275EDFF, 2530.5066,2506.3933,25.6468, 50.0, 0);
 	Create3DTextLabel("Grupa [5]", 0x1275EDFF, 2507.2441,2515.1167,25.64548, 50.0, 0);

	for__loop (new i = 0; i < 5; i++) 
	{
	    grupa_kreirana[i] = false;
	    grupa_nitro[i]    = false;
	}
	return true;
}

hook OnVehicleSpawn(vehicleid) 
{
	// Event vozila
   	for__loop (new i = 0; i < 5; i++) 
   	{
	    if (!grupa_kreirana[i]) continue; // Grupa nije kreirana, nastavi dalje

	    for__loop (new j = 0; j < 16; j++) 
	    {
	        if (vehicleid == event_vozilo[i][j]) // Match!
	        {
	            if (grupa_nitro[i]) AddVehicleComponent(vehicleid, 1010);

	            SetVehicleNumberPlate(vehicleid, "{FF0000}EVENT");

	            break;
	        }
	    }
	}
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (!ispassenger)
    {
        new group = vozilo_za_event(vehicleid);
        if (group > 0 && grupa_zakljucana[group-1] && !IsHelper(playerid, 1))
        {
            GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
            SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.5);
                    
            SendClientMessage(playerid, GRAD2, "* Zakljucano!");
        }
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
vozilo_za_event(vehicleid) 
{
	for (new i = 0; i < 5; i++) 
    {
	    if (!grupa_kreirana[i]) continue; // Grupa nije kreirana, nastavi dalje

	    for (new j = 0; j < 16; j++) 
        {
	        if (vehicleid == event_vozilo[i][j]) return i+1; // Match! (vraca id grupe uvecan za 1, jer ako vrati 0 onda je to false)
	    }
	}
	return 0;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:ekreiraj(FLAG_HELPER_1)
CMD:ekreiraj(playerid, const params[])
{
	new grupa,
		model[18], 
		boja, 
		modelid = -1
	;
	if (sscanf(params, "is[18]I(-1)", grupa, model, boja))
		return Koristite(playerid, "ekreiraj [Grupa (1-5)] [Naziv ili ID modela (400-611)] [Boja (razl. boja: -1 | ista boja: ID boje)]");
	
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
    if (grupa < 0 || grupa > 4) 
		return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
	
	for__loop (new i; i < sizeof imena_vozila; i++)
	{
	    if (!strcmp(imena_vozila[i], model, true))
		{
			modelid = i+400;
			break;
		}
	}
	if (modelid == -1) modelid = strval(model);
	if (modelid < 400 || modelid > 611 || modelid == 537 || modelid == 538) 
		return ErrorMsg(playerid, "Nevazeci model vozila.");
		
	if (boja < -1 || boja > 126) 
		return ErrorMsg(playerid, "Nevazeci ID boje.");
		
	if (grupa_kreirana[grupa])
		return ErrorMsg(playerid, "Grupa %d je vec kreirana.", grupa+1);
	
	
	// Glavna funkcija komande
	if (grupa == 0)
	{
		event_vozilo[0][0] = CreateVehicle(modelid,2406.99560547,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][1] = CreateVehicle(modelid,2412.49511719,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][2] = CreateVehicle(modelid,2417.89526367,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][3] = CreateVehicle(modelid,2423.09448242,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][4] = CreateVehicle(modelid,2428.39379883,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][5] = CreateVehicle(modelid,2433.69360352,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][6] = CreateVehicle(modelid,2439.19335938,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][7] = CreateVehicle(modelid,2444.59326172,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][8] = CreateVehicle(modelid,2449.89282227,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][9] = CreateVehicle(modelid,2455.19262695,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][10] = CreateVehicle(modelid,2460.49243164,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][11] = CreateVehicle(modelid,2465.89208984,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][12] = CreateVehicle(modelid,2471.29150391,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][13] = CreateVehicle(modelid,2476.59106445,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][14] = CreateVehicle(modelid,2481.99072266,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[0][15] = CreateVehicle(modelid,2487.39013672,2530.48046875,21.67499924,0.00000000,boja,boja,1500);
	}
	else if (grupa == 1)
	{
		event_vozilo[1][0] = CreateVehicle(modelid,2416.67407227,2570.04467773,21.67499924,165.00000000,boja,boja,1500);
		event_vozilo[1][1] = CreateVehicle(modelid,2421.02880859,2568.91455078,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][2] = CreateVehicle(modelid,2425.45605469,2567.76635742,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][3] = CreateVehicle(modelid,2429.81103516,2566.63623047,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][4] = CreateVehicle(modelid,2434.40747070,2565.44360352,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][5] = CreateVehicle(modelid,2438.76220703,2564.31396484,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][6] = CreateVehicle(modelid,2442.87475586,2563.24682617,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][7] = CreateVehicle(modelid,2447.47094727,2562.05395508,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][8] = CreateVehicle(modelid,2451.94702148,2560.89404297,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][9] = CreateVehicle(modelid,2456.39794922,2559.73876953,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][10] = CreateVehicle(modelid,2460.99438477,2558.54614258,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][11] = CreateVehicle(modelid,2465.34912109,2557.41650391,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][12] = CreateVehicle(modelid,2469.70361328,2556.28662109,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][13] = CreateVehicle(modelid,2474.05810547,2555.15673828,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][14] = CreateVehicle(modelid,2478.65454102,2553.96411133,21.67499924,164.99816895,boja,boja,1500);
		event_vozilo[1][15] = CreateVehicle(modelid,2483.00927734,2552.83447266,21.67499924,164.99816895,boja,boja,1500);
	}
	else if (grupa == 2)
	{
		event_vozilo[2][0] = CreateVehicle(modelid,2452.95166016,2550.77514648,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][1] = CreateVehicle(modelid,2448.02685547,2550.69677734,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][2] = CreateVehicle(modelid,2442.77636719,2550.61425781,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][3] = CreateVehicle(modelid,2437.37792969,2550.52832031,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][4] = CreateVehicle(modelid,2432.12792969,2550.44628906,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][5] = CreateVehicle(modelid,2427.12792969,2550.36816406,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][6] = CreateVehicle(modelid,2421.62792969,2550.28222656,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][7] = CreateVehicle(modelid,2417.12792969,2550.21191406,21.67499924,0.00000000,boja,boja,1500);
		event_vozilo[2][8] = CreateVehicle(modelid,2453.15039062,2544.78027344,21.67499924,182.00000000,boja,boja,1500);
		event_vozilo[2][9] = CreateVehicle(modelid,2448.15039062,2544.69238281,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][10] = CreateVehicle(modelid,2442.87451172,2544.60009766,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][11] = CreateVehicle(modelid,2437.57324219,2544.50683594,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][12] = CreateVehicle(modelid,2432.37207031,2544.41601562,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][13] = CreateVehicle(modelid,2427.32324219,2544.32666016,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][14] = CreateVehicle(modelid,2421.82324219,2544.22949219,21.67499924,181.99951172,boja,boja,1500);
		event_vozilo[2][15] = CreateVehicle(modelid,2417.14843750,2544.14648438,21.67499924,181.99951172,boja,boja,1500);
	}
	else if (grupa == 3)
	{
		event_vozilo[3][0] = CreateVehicle(modelid,2530.74023438,2540.93188477,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][1] = CreateVehicle(modelid,2530.71240234,2536.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][2] = CreateVehicle(modelid,2530.68261719,2531.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][3] = CreateVehicle(modelid,2530.65478516,2526.43164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][4] = CreateVehicle(modelid,2530.62353516,2521.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][5] = CreateVehicle(modelid,2530.59375000,2516.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][6] = CreateVehicle(modelid,2530.56445312,2511.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][7] = CreateVehicle(modelid,2530.53515625,2506.18164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][8] = CreateVehicle(modelid,2530.50732422,2501.43164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][9] = CreateVehicle(modelid,2530.47900391,2496.68164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][10] = CreateVehicle(modelid,2530.44775391,2491.43164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][11] = CreateVehicle(modelid,2530.41796875,2486.43164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][12] = CreateVehicle(modelid,2530.39013672,2481.68164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][13] = CreateVehicle(modelid,2530.36035156,2476.68164062,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][14] = CreateVehicle(modelid,2530.33178711,2471.85693359,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[3][15] = CreateVehicle(modelid,2530.30175781,2466.85644531,21.67499924,90.00000000,boja,boja,1500);
	}
	else if (grupa == 4)
	{
		event_vozilo[4][0] = CreateVehicle(modelid,2503.55541992,2536.10229492,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][1] = CreateVehicle(modelid,2503.54443359,2530.85156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][2] = CreateVehicle(modelid,2503.53417969,2525.85156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][3] = CreateVehicle(modelid,2503.52343750,2520.35156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][4] = CreateVehicle(modelid,2503.51367188,2515.35156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][5] = CreateVehicle(modelid,2503.50341797,2510.10156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][6] = CreateVehicle(modelid,2503.49267578,2504.85156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][7] = CreateVehicle(modelid,2503.48144531,2499.35156250,21.67499924,90.00000000,boja,boja,1500);
		event_vozilo[4][8] = CreateVehicle(modelid,2510.80468750,2536.06616211,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][9] = CreateVehicle(modelid,2510.77905273,2530.81542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][10] = CreateVehicle(modelid,2510.75390625,2525.81542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][11] = CreateVehicle(modelid,2510.72705078,2520.31542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][12] = CreateVehicle(modelid,2510.70214844,2515.31542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][13] = CreateVehicle(modelid,2510.67651367,2510.06542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][14] = CreateVehicle(modelid,2510.65014648,2504.81542969,21.67499924,270.00000000,boja,boja,1500);
		event_vozilo[4][15] = CreateVehicle(modelid,2510.62255859,2499.31542969,21.67499924,270.00000000,boja,boja,1500);
	}
	else return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");

	format(string_32, 32, "{FF0000}EVENT [%d]", grupa+1);
	for__loop (new i = 0; i < 16; i++) 
    {
	    SetVehicleNumberPlate(event_vozilo[grupa][i], string_32);
	}
	grupa_kreirana[grupa] = true;
    grupa_zakljucana[grupa] = false;
	
	
	
	// Slanje poruke staffu 
	if (IsAdmin(playerid, 1)) 
	    StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je kreirao vozila. Grupa: %d | Model: %s(%d)", ime_rp[playerid], grupa+1, imena_vozila[modelid - 400], modelid);
	
	else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) 
		StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je kreirao vozila. Grupa: %d | Model: %s(%d)", ime_rp[playerid], grupa+1, imena_vozila[modelid - 400], modelid);
	
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /ekreiraj | Izvrsio: %s | Model: %s[%d] | Grupa: %d", ime_obicno[playerid], imena_vozila[modelid - 400], modelid, grupa+1);
	Log_Write(LOG_EVENTVOZILA, string_128);
	return 1;
}

flags:enitro(FLAG_HELPER_1)
CMD:enitro(playerid, const params[])
{
	new grupa, 
		status
	;
    if (sscanf(params, "i", grupa)) 
		return Koristite(playerid, "enitro [Grupa (1-5)]");
	
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
    if (grupa < 0 || grupa > 4) 
		return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
		
    if (!grupa_kreirana[grupa])
		return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);

	
	
	// Glavna funkcija komande
	if (!grupa_nitro[grupa]) // Grupa vozila nema nitro -> dodaj
	{
	    status = 1; // 1 - dodavanje nitra
		new model = GetVehicleModel(event_vozilo[grupa][0]);
	    if (IsVehicleBicycle(model) == 1 || IsVehicleAirplane(model) == 1 || IsVehicleBoat(model) == 1 || IsVehicleMotorbike(model) == 1)
		{
			ErrorMsg(playerid, "Ta vrsta vozila ne moze imati nitro!");
			return 1;
		}
		for__loop (new i = 0; i < 16; i++)
		{
		    AddVehicleComponent(event_vozilo[grupa][i], 1010);
		}
		grupa_nitro[grupa] = true;


			// Slanje poruke staffu
		if (IsAdmin(playerid, 1)) 
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je dodao nitro u vozila grupe %d.", ime_rp[playerid], grupa+1);
		
    	else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) 
			StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je dodao nitro u vozila grupe %d.", ime_rp[playerid], grupa+1);
 	}
 	else // Grupa vozila ima nitro -> ukloni
 	{
 	    status = 0; // 0 - uklanjanje nitra
		for__loop (new i = 0; i < 16; i++)
		    RemoveVehicleComponent(event_vozilo[grupa][i], 1010);

		grupa_nitro[grupa] = false;


		// Slanje poruke staffu
		if (IsAdmin(playerid, 1)) {
			StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je uklonio nitro iz vozila grupe %d.", ime_rp[playerid], grupa+1);
		}
    	else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) {
			StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je uklonio nitro iz vozila grupe %d.", ime_rp[playerid], grupa+1);
		}
	}
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /enitro | Izvrsio: %s | Status: %d | Grupa: %d", ime_obicno[playerid], status, grupa+1);
	Log_Write(LOG_EVENTVOZILA, string_128);
	return 1;
}

flags:eport(FLAG_HELPER_1)
CMD:eport(playerid, const params[])
{
	new grupa,
		Float:x,
		Float:y,
		Float:z,
		Float:x_dodatak = 3.0,
		Float:y_dodatak = 0.0,
	 	promena = 0,
	 	broj_vozila,
	 	vw = GetPlayerVirtualWorld(playerid),
	 	ent = GetPlayerInterior(playerid)
	;
    if (sscanf(params, "ii", grupa, broj_vozila)) 
        return Koristite(playerid, "eport [Grupa (1-5)] [Broj vozila]");
	
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
    if (grupa < 0 || grupa > 4) 
        return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");

    if (!grupa_kreirana[grupa])
		return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);

	if (broj_vozila < 1 || broj_vozila > 16) return ErrorMsg(playerid, "Broj vozila mora biti izmedju 1 i 16!");
    GetPlayerPos(playerid, x, y, z);
    for__loop (new i = 0; i < broj_vozila; i++)
   	{
   	    LinkVehicleToInterior(event_vozilo[grupa][i], ent);
	   	SetVehicleVirtualWorld(event_vozilo[grupa][i], vw);
    	SetVehiclePos(event_vozilo[grupa][i], x+x_dodatak, y+y_dodatak, z);
		if (x_dodatak == 3.0) x_dodatak = 7.0;
		else x_dodatak = 3.0;

		promena++;
		if (promena == 2) promena = 0, y_dodatak += 7.0;
	}


	if (IsAdmin(playerid, 1)) 
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je teleportovao %d vozila iz grupe %d. Virtual: %d", ime_rp[playerid], broj_vozila, grupa+1, vw);
	
    else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) 
		StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je teleportovao %d vozila iz grupe %d. Virtual: %d", ime_rp[playerid], broj_vozila, grupa+1, vw);
	
	format(string_128, sizeof string_128, "Komanda: /eport | Izvrsio: %s | Grupa: %d | Vozila: %d | Virtual: %d", ime_obicno[playerid], grupa+1, broj_vozila, vw);
	Log_Write(LOG_EVENTVOZILA, string_128);
	return 1;
}

flags:eunisti(FLAG_HELPER_1)
CMD:eunisti(playerid, const params[]) 
{
	new grupa;
    if (sscanf(params, "i", grupa)) return Koristite(playerid, "eunisti [Grupa (1-5)]");
	
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
    if (grupa < 0 || grupa > 4) 
		return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
	
    if (!grupa_kreirana[grupa]) 
	    return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);
	
	// Glavna funkcija komande
    for__loop (new i = 0; i < 16; i++) 
    {
		DestroyVehicle(event_vozilo[grupa][i]);
		event_vozilo[grupa][i] = INVALID_VEHICLE_ID;
	}
    grupa_kreirana[grupa] = false;
    grupa_nitro[grupa]    = false;


	if (IsAdmin(playerid, 1)) 
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je unistio sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
	
    else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) 
		StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je unistio sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
	
	format(string_128, sizeof string_128, "Komanda: /eunisti | Izvrsio: %s | Grupa: %d", ime_obicno[playerid], grupa+1);
	Log_Write(LOG_EVENTVOZILA, string_128);
	return 1;
}

flags:erespawn(FLAG_HELPER_1)
CMD:erespawn(playerid, const params[]) 
{
	new grupa, 
		tip, 
		bool:veh_occupied
	;
	if (sscanf(params, "ii", grupa, tip)) 
		return Koristite(playerid, "erespawn [Grupa (1-5)] [Tip respawna (0 = sva vozila | 1 = sva slobodna | 2 = sva zauzeta)]");
    
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
	if (grupa < 0 || grupa > 4) 
		return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
   
	if (!grupa_kreirana[grupa])
		return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);
	
	if (tip < 0 || tip > 2) 
		return ErrorMsg(playerid, "Nevazeci tip respawna.");
	
	
	
	// Glavna funkcija komande
	if (tip == 0) {
		for__loop (new i = 0; i < 16; i++) SetVehicleToRespawn(event_vozilo[grupa][i]);
	}
	else if (tip == 1) {
        for__loop (new i = 0; i < 16; i++) {
			veh_occupied = false;
			
            foreach (new j : Player) {
                if (GetPlayerVehicleID(j) == event_vozilo[grupa][i]) {
					veh_occupied = true;
					break;
                }
            }

            if (veh_occupied == false)
                SetVehicleToRespawn(event_vozilo[grupa][i]);
        }
	}
	else if (tip == 2) {
        for__loop (new i = 0; i < 16; i++) {
 		    foreach (new j : Player) {
 		        if (GetPlayerVehicleID(j) == event_vozilo[grupa][i]) {
 		            SetVehicleToRespawn(event_vozilo[grupa][i]);
 		            break;
 		        }
 		    }
 		}
	}


	// Slanje poruke staffu
	if (IsAdmin(playerid, 1)) 
    {
		if (tip == 0) StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je respawnao sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
		else if (tip == 1) StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je respawnao sva slobodna vozila u grupi %d.", ime_rp[playerid], grupa+1);
		else if (tip == 2) StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je respawnao sva zauzeta vozila u grupi %d.", ime_rp[playerid], grupa+1);
	}
    else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) 
    {
		if (tip == 0) StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je respawnao sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
		else if (tip == 1) StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je respawnao sva slobodna vozila u grupi %d.", ime_rp[playerid], grupa+1);
		else if (tip == 2) StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je respawnao sva zauzeta vozila u grupi %d.", ime_rp[playerid], grupa+1);
	}
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /erespawn | Izvrsio: %s | Grupa: %d | Tip: %d", ime_obicno[playerid], grupa+1, tip);
	Log_Write(LOG_EVENTVOZILA, string_128);
	
	return 1;
}

flags:epopravi(FLAG_HELPER_1)
CMD:epopravi(playerid, const params[])
{
	new grupa;
    if (sscanf(params, "i", grupa)) 
		return Koristite(playerid, "epopravi [Grupa (1-5)]");
    
	grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
	if (grupa < 0 || grupa > 4) 
		return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
    
	if (!grupa_kreirana[grupa])
		return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);

	
	// Glavna funkcija komande
    for__loop (new i = 0; i < 16; i++)
	{
		SetVehicleHealth(event_vozilo[grupa][i], 999.0);
	}


	// Slanje poruke staffu
	if (IsAdmin(playerid, 1)) {
		StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je popravio sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
	}
    else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) {
		StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je popravio sva vozila u grupi %d.", ime_rp[playerid], grupa+1);
	}
	
	// Upisivanje u log
	format(string_128, sizeof string_128, "Komanda: /epopravi | Izvrsio: %s | Grupa: %d", ime_obicno[playerid], grupa+1);
	Log_Write(LOG_EVENTVOZILA, string_128);
	
	return 1;
}

flags:elock(FLAG_HELPER_1)
CMD:elock(playerid, const params[])
{
    new grupa;
    if (sscanf(params, "i", grupa)) 
        return Koristite(playerid, "elock [Grupa (1-5)]");
    
    grupa -= 1; // smanjuje uneti broj grupe da bi bio u opsegu 0-4
    if (grupa < 0 || grupa > 4) 
        return ErrorMsg(playerid, "Broj grupe mora biti izmedju 1 i 5.");
    
    if (!grupa_kreirana[grupa])
        return ErrorMsg(playerid, "Grupa %d nije kreirana.", grupa+1);

    
    // Glavna funkcija komande
    grupa_zakljucana[grupa] = !grupa_zakljucana[grupa];


    // Slanje poruke staffu
    if (IsAdmin(playerid, 1)) {
        StaffMsg(BELA, "{FF6347}- STAFF:{B4CDED} {FFFFFF}%s {FF6347}je %s sva vozila u grupi %d.", ime_rp[playerid], (grupa_zakljucana[grupa]? ("zakljucao") : ("otkljucao")), grupa+1);
    }
    else if (IsHelper(playerid, 1) && !IsAdmin(playerid, 1)) {
        StaffMsg(BELA, "H {8EFF00}| {FFFFFF}%s {8EFF00}je %s sva vozila u grupi %d.", ime_rp[playerid], (grupa_zakljucana[grupa]? ("zakljucao") : ("otkljucao")), grupa+1);
    }
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Komanda: /elock | Izvrsio: %s | Grupa: %d", ime_obicno[playerid], grupa+1);
    Log_Write(LOG_EVENTVOZILA, string_128);
    
    return 1;
}