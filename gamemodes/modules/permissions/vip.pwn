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
static vipVehDialog[MAX_PLAYERS][MAX_VOZILA_SLOTOVI];
static Iterator:iVipVehicles<MAX_VEHICLES>;
static Iterator:iPromoVehicles<MAX_VEHICLES>;
//static gPromoGate, bool:gPromoGate_Status;


// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    new h, m, s, timerInterval;
    gettime(h, m, s);
    timerInterval = (24-h)*3600 + (60-m)*60; // Npr. sada je 17:46, timer ce okinuti za 6h i 14min (u 00:00);

    SetTimer("VIP_DailyReset", timerInterval*1000, false);
    new vehicleid;
    vehicleid = CreateVehicle(411, 3327.7390, -845.973, 11.7359, 0.0,233, 233, 1000);
    Iter_Add(iVipVehicles, vehicleid);
    Iter_Add(iPromoVehicles, vehicleid);

    
    vehicleid = CreateVehicle(522,6.5650, -1749.2457, 17.6082, -45.0000,233, 233, 1000); // vipvozilo1
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(522,6.4203, -1745.1508, 17.6082, -45.0000,233, 233, 1000); // vipvozilo2
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(522,6.3911, -1741.3420, 17.6082, -45.0000,233, 233, 1000); // vipvozilo3
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(411, 5.0412, -1737.1045, 17.8455, -90.0000,233, 233, 1000); // vipvozilo4
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(411, 17.9599, -1708.6306, 18.1577, 180.0000,233, 233, 1000); // vipvozilo5
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(411, 22.3130, -1708.4008, 18.1577, 180.0000,233, 233, 1000); // vipvozilo6
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(495, 26.4925, -1708.4910, 18.1577, 180.0000,233, 233, 1000); // vipvozilo7
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(495, 31.8782, -1713.5686, 17.5995, 90.0000,233, 233, 1000); // vipvozilo8
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(495,31.9043, -1717.5304, 17.5995, 90.0000,233, 233, 1000); // vipvozilo9
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(451,31.9312, -1721.5120, 17.5995, 90.0000,233, 233, 1000); // vipvozilo10
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(451, 4.9943, -1733.2977, 17.8455, -90.0000,233, 233, 1000); // vipvozilo11
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(451,4.8682, -1729.4576, 17.8455, -90.0000,233, 233, 1000); // vipvozilo12
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(522,6.5143, -1725.2521, 17.6082, -45.0000,233, 233, 1000); // vipvozilo13
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(522,6.5665, -1721.3099, 17.6082, -45.0000,233, 233, 1000); // vipvozilo14
    Iter_Add(iVipVehicles, vehicleid);
    vehicleid = CreateVehicle(522,6.5028, -1717.6116, 17.6082, -45.0000,233, 233, 1000); // vipvozilo15
    Iter_Add(iVipVehicles, vehicleid);
    
    foreach (new veh : iVipVehicles)
    {
        SetVehicleNumberPlate(veh, "{AF28A4}V.I.P.");
        CreateDynamic3DTextLabel("[ VIP - VOZILO ]", 0xFFFFFFCC, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh);
    }

    vehicleid = CreateVehicle(495,1363.7987,-1635.4307,13.2145,270.5192,233, 233, 1000); // Promotervozilo 1
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(495,1363.7135,-1643.2238,13.2145,271.6398,233, 233, 1000); // Promotervozilo 2
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(495,1363.6099,-1651.0837,13.2145,271.9102,233, 233, 1000); // Promotervozilo 3
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(522,1363.6642,-1658.9276,13.2144,271.5225,233, 233, 1000); // Promotervozilo 4
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(522,1372.9391,-1663.9054,13.1906,3.9619,233, 233, 1000); // Promotervozilo 5
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(522,1376.5795,-1635.6431,13.2912,89.3497,233, 233, 1000); // Promotervozilo 6
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(411,1380.6023,-1658.5912,13.3312,91.4683,233, 233, 1000); // Promotervozilo 7
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(411,1364.4641,-1676.3197,13.3861,332.6269,233, 233, 1000); // Promotervozilo 8
    Iter_Add(iPromoVehicles, vehicleid);
    vehicleid = CreateVehicle(411,1358.2776,-1669.7483,13.4350,331.8203,233, 233, 1000); // Promotervozilo 9
    Iter_Add(iPromoVehicles, vehicleid);

    foreach (new veh : iPromoVehicles)
    {
        SetVehicleNumberPlate(veh, "{AF28A4}PROMO.");
        CreateDynamic3DTextLabel("[ PROMOTER - VOZILO ]", 0xFFFFFFCC, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh);
    }
    return true;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if (!ispassenger)
    {
        if (Iter_Contains(iVipVehicles, vehicleid)) 
        {
            GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);

            if (!IsVIP(playerid, 1) && !IsAdmin(playerid, 6)) 
            {
                SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.3);
                SendClientMessage(playerid, GRAD2, "* Morate imati VIP status da biste koristili ovo vozilo!"); 
                return 1;
            }
        }

        else if (Iter_Contains(iPromoVehicles, vehicleid)) 
        {
            GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);

            if (!IsPromoter(playerid, 1) && !IsAdmin(playerid, 6)) 
            {
                SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.3);
                SendClientMessage(playerid, GRAD2, "* Morate imati Promoter status da biste koristili ovo vozilo!"); 
                return 1;
            }
        }
    }
    return 1;
}

/*hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((!IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CTRL_BACK)) || (IsPlayerInAnyVehicle(playerid) && (newkeys & KEY_CROUCH))) 
    { // H
        new Float:x, Float:y, Float:z;

        GetDynamicObjectPos(gPromoGate, x, y, z);
        if (IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
        {
            if (IsPromoter(playerid, 1) || IsAdmin(playerid, 6))
            {
                if (gPromoGate_Status)
                {
                    // Kapija je otvorena -> Zatvoriti je
                    MoveDynamicObject(gPromoGate, 1387.062866, -1649.251098, 14.130184, 2.75);
                }
                else
                {
                    // Kapija je zatvorena -> Otvoriti je
                    MoveDynamicObject(gPromoGate, 1387.062866, -1649.251098, 10.580176, 2.75);
                }
                gPromoGate_Status = !gPromoGate_Status;
            }
        }
    }
}
*/



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward VIP_DailyReset();
public VIP_DailyReset()
{
    mysql_tquery(SQL, "UPDATE igraci SET vip_refill = 0, vip_replenish = 0");
    foreach (new i : Player)
    {
        if (IsVIP(i, 1))
        {
            PI[i][p_vip_refill] = PI[i][p_vip_replenish] = 0;
        }
    }

    SetTimer("VIP_DailyReset", 24*3600*1000, false);
    return 1;
}

nl_public VIP_LoginCheck(playerid)
{
    if (IsVIP(playerid, 1))
    {
        new vipName[9];
        VIP_GetPackageName(PI[playerid][p_vip_level], vipName, sizeof vipName);

    	if (PI[playerid][p_vip_istice] < gettime())
    	{
	        SendClientMessageF(playerid, TAMNOLJUBICASTA, "VIP | {FF6347}Vas VIP status (%s paket) je istekao.", vipName);

	        PI[playerid][p_vip_level] = 0;
            PI[playerid][p_spawn_armour] = 0.0;
	        new query[50];
	        format(query, sizeof query, "UPDATE igraci SET vip_level = 0 WHERE id = %i", PI[playerid][p_id]);
	        mysql_tquery(SQL, query);
	        return 1;
	    }
        else
        {
            new exp = PI[playerid][p_vip_istice] - gettime(),
                days = floatround(exp/86400, floatround_floor),
                hrs = floatround((exp - days*86400)/3600, floatround_floor);

            SendClientMessageF(playerid, TAMNOLJUBICASTA, "VIP | {FFFFFF}Na Vasem nalogu je aktiviran {AC12F4}VIP %s {FFFFFF}paket | Istice za: %i dana, %i sati", vipName, days, hrs);
        }

	    // Postavljanje nekih bitnih stvari =)
    }
    return 1;
}

nl_public IsVIP(playerid, level)
{
	return (PI[playerid][p_vip_level] >= level || GetPlayerDivision(playerid) >= level);
}

// Prilikom izmene, promeniti i ACP (web)
stock VIP_GetPackageName(level, dest[], len)
{
	if (level == 1) format(dest, len, "Bronze");
    else if (level == 2) format(dest, len, "Silver");
    else if (level == 3) format(dest, len, "Gold");
    else if (level == 4) format(dest, len, "Platinum");
    else format(dest, len, "N/A");
}

nl_public GetVIPInterestRate(playerid, &Float:interestRate)
{
    if (PI[playerid][p_vip_level] == 1)
    {
        interestRate = 0.002;
    }
    else if (PI[playerid][p_vip_level] == 2)
    {
        interestRate = 0.0025;
    }
    else if (PI[playerid][p_vip_level] == 3)
    {
        interestRate = 0.0033;
    }
    else if (PI[playerid][p_vip_level] == 4)
    {
        interestRate = 0.0045;
    }
    else
    {
        interestRate = 0.001;
    }
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_donator_kod(returnid, kod[19], ccinc);
public mysql_donator_kod(returnid, kod[19], ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_donator_kod");
    }

	if (!checkcinc(returnid, ccinc)) return 1;
	
	cache_get_row_count(rows);
	
   	if (!rows)
	{
        SetPVarInt(returnid, "pPogresioKod", GetPVarInt(returnid, "pPogresioKod")+1);
		format(string_128, sizeof string_128, "NEUSPESNO | Izvrsio: %s | Kod: %s", ime_obicno[returnid], kod);
		Log_Write(LOG_KODOVI, string_128);
	    if (GetPVarInt(returnid, "pPogresioKod") >= 3)
	    {
    		overwatch_poruka(returnid, "Uneli ste pogresan kod vise od 3 puta! Vasa IP adresa je zabelezena i banovana.");
	        Kick_Timer(returnid);
	        return 1;
	    }
	    overwatch_poruka(returnid, "Uneli ste pogresan kod! Nakon 3 pogresna pokusaja dobijate ban!");
	    return 1;
	}
	
	if (rows > 1) 
		return SendClientMessage(returnid, TAMNOCRVENA2, GRESKA_NEPOZNATO);
	
	new 
		gold,
		novac,
		level
	;
	cache_get_value_index_int(0, 0, gold);
	cache_get_value_index_int(0, 1, novac);
	cache_get_value_index_int(0, 2, level);
	
	format(mysql_upit, sizeof mysql_upit, "DELETE FROM kodovi WHERE kod = '%s'", kod);
	mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_DELETEROW);
	
	if (gold > 0) PI[returnid][p_token] += gold;
	if (novac > 0) PlayerMoneyAdd(returnid, novac);
	if (level > 0) PI[returnid][p_nivo] += level, SetPlayerScore(returnid, PI[returnid][p_nivo]);
	
	overwatch_poruka(returnid, "Kod prihvacen!");
	format(string_128, sizeof string_128, "* Dobili ste %d Tokena, %s i %d levela.", gold, formatMoneyString(novac), level);
	SendClientMessage(returnid, SVETLOPLAVA, string_128);
	
	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d, nivo = %d, gold = %d WHERE id = %d",PI[returnid][p_novac],PI[returnid][p_nivo],PI[returnid][p_token],PI[returnid][p_id]);
	mysql_tquery(SQL, mysql_upit);
	
	format(string_128, sizeof string_128, "USPESNO | Izvrsio: %s | Kod: %s | Tokeni: %d | Novac: $%d | Nivo: %d", ime_obicno[returnid], kod, gold, novac, level);
	Log_Write(LOG_KODOVI, string_128);
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
// Dialog:token(playerid, response, listitem, const inputtext[])
// {
// 	if (!response) return 1;

// 	switch (listitem)
// 	{
// 		case 0: // $10.000 = 1 token
// 		{
// 			if (PI[playerid][p_token] < 1)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 1;
// 			PlayerMoneyAdd(playerid, 10000);

// 			SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}1 token {FFFF00}za nagradu: {F7BBEE}$10.000.");

// 			new query[128];
// 			format(query, sizeof query, "UPDATE igraci SET novac = %i, gold = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | $10000 (1)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
// 		case 1: // Poen iskustva = 3 tokena
// 		{
// 			if (PI[playerid][p_token] < 3)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 3;
// 			PI[playerid][p_iskustvo] += 1;

// 			SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}3 tokena {FFFF00}za nagradu: {F7BBEE}poen iskustva.");

// 			new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
//             if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
//             {
//                 PI[playerid][p_nivo]++;
//                 SetPlayerScore(playerid, PI[playerid][p_nivo]);
//                 PI[playerid][p_iskustvo] = 0;
//                 SendClientMessageF(playerid, ZUTA, "** LEVEL UP | Sada ste nivo {FFFFFF}%d.", PI[playerid][p_nivo]);
//             }

// 			new query[128];
// 			format(query, sizeof query, "UPDATE igraci SET nivo = %i, iskustvo = %i, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | Iskustvo (3)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
		
// 		case 2: // Pasos na 1 mesec = 3 tokena
// 		{
// 			if (PI[playerid][p_token] < 8)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			new h,m,s;
// 			gettime(h, m, s);
// 			PI[playerid][p_token] -= 8;
// 	        PI[playerid][p_pasos] = gettime() + 2592000 + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih 30 dana, pa jos do kraja sledeceg dana

// 			SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}8 tokena {FFFF00}za nagradu: {F7BBEE}pasos na 1 mesec.");


// 	        new query[130];
// 	        format(query, sizeof query, "UPDATE igraci SET gold = %i, pasos = FROM_UNIXTIME(%i) WHERE id = %i", PI[playerid][p_token], PI[playerid][p_pasos], PI[playerid][p_id]);
// 	        mysql_tquery(SQL, query);

// 	        format(query, sizeof query, "SELECT DATE_FORMAT(pasos, '\%%d/\%%m/\%%Y') as pasos1, UNIX_TIMESTAMP(pasos) as pasos_ts FROM igraci WHERE id = %i", PI[playerid][p_id]);
// 	        mysql_tquery(SQL, query, "OnPlayerIssuedPassport", "ii", playerid, cinc[playerid]);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | Pasos (8)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}

// 		case 3: // Nasumican iznos novca ($1.000 - $250.000) = 10 tokena
// 		{
// 			if (PI[playerid][p_token] < 10)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 10;

// 			new prize = 1000;
// 			switch (random(26))
// 			{
// 				case 0..4, 17..22: 	prize += random(10000);
// 				case 5..9, 23: 		prize += random(50000);
// 				case 10, 24: 		prize += random(70000);
// 				case 11, 25: 		prize = 50000 + random(50000);
// 				case 12: 			prize = 50000 + random(100000);
// 				case 13: 			prize = 50000 + random(150000);
// 				case 14: 			prize = 100000 + random(100000);
// 				case 15: 			prize = 100000 + random(160000);
// 				case 16: 			prize = 175000 + random(76000);
// 				case 26:
// 				{
// 					new r = random(3);
// 					if (r == 0) 
// 						prize = 100000;
// 					else if (r == 1)
// 						prize = 250000;
// 					else if (r == 2)
// 						prize = 150000;
// 				}
// 				default: prize = 50000;
// 			}

// 			PlayerMoneyAdd(playerid, prize);

// 			SendClientMessageF(playerid, ZUTA, "* Zamenili ste {F7BBEE}10 tokena {FFFF00}za nagradu: {F7BBEE}%s", formatMoneyString(prize));

// 			new query[128];
// 			format(query, sizeof query, "UPDATE igraci SET novac = %i, gold = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | Random iznos (10) | %s", ime_obicno[playerid], formatMoneyString(prize));
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
// 		case 4: // Telefonski broj po izboru = 15 tokena
// 		{
// 			if (PI[playerid][p_token] < 15)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			if (!igrac_ima_mobilni(playerid))
// 				return ErrorMsg(playerid, "Nemate mobilni telefon.");

// 			SPD(playerid, "token_customPhone", DIALOG_STYLE_INPUT, "TOKEN", "{FFFFFF}Telefonski broj mora imati 4, 5 ili 6 cifara i ne sme pocinjati sa 0.\nUnesite zeljeni broj telefona (bez prefixa):", "Promeni", "Odustani");
// 		}
// 		case 5: // Tablica za vozilo po izboru = 20 tokena
// 		{
// 			if (PI[playerid][p_token] < 20)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			new string[512];
// 			format(string, 30, "Slot\tVozilo\tModel\tTablice");
			
// 			new item = 0;
// 			for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
//             {
// 				if (pVehicles[playerid][i] == 0) continue; // prazan slot
				
// 				new veh = pVehicles[playerid][i], color[7];
//                 if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
//                 else color = "FFFFFF";

// 				format(string, 512, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", string, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

// 				vipVehDialog[playerid][item++] = i; // belezi se koji je slot
// 			}
			
// 			if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");
			
// 			SPD(playerid, "token_customPlate", DIALOG_STYLE_TABLIST_HEADERS, "TOKEN", string, "Odaberi", "Nazad");
// 		}

// 		case 6: // Ponistavanje kazne ugovora = 35 tokena
// 		{
// 			if (PI[playerid][p_token] < 35)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 35;
// 			PI[playerid][p_org_kazna] = 0;

// 			SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}35 tokena {FFFF00}za nagradu: {F7BBEE}ponistavanje kazne ugovora.");

// 			new query[81];
// 			format(query, sizeof query, "UPDATE igraci SET gold = %i, org_kazna = FROM_UNIXTIME(0) WHERE id = %d", PI[playerid][p_token], PI[playerid][p_id]);
//         	mysql_tquery(SQL, query);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | Ugovor (35)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
// 		case 7: // Level UP = 50 tokena
// 		{
// 			if (PI[playerid][p_token] < 50)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 50;
// 			PI[playerid][p_nivo] += 1;
// 			PI[playerid][p_iskustvo] = 0;

// 			SendClientMessageF(playerid, ZUTA, "* Zamenili ste {F7BBEE}50 tokena {FFFF00}za nagradu: {F7BBEE}level UP (nivo %i)", PI[playerid][p_nivo]);

// 			new query[128];
// 			format(query, sizeof query, "UPDATE igraci SET nivo = %i, iskustvo = 0, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			new logStr[64];
// 			format(logStr, sizeof logStr, "%s | Level UP (50)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
		
// 		case 8: // Otplata kredita = 90 tokena
// 		{
// 			if (PI[playerid][p_kredit_otplata] > 8000000)
// 				return ErrorMsg(playerid, "Kredit mozete otplatiti tek kada dugovanje bude manje od $8.000.000.");

// 			if (PI[playerid][p_token] < 90)
// 				return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

// 			PI[playerid][p_token] -= 90;
// 			PI[playerid][p_kredit_iznos] 	= 0;
// 			PI[playerid][p_kredit_otplata] 	= 0;
// 			PI[playerid][p_kredit_rata] 	= 0;

// 			new query[110];
//     		format(query, sizeof query, "UPDATE igraci SET kredit_iznos = 0, kredit_otplata = 0, kredit_rata = 0, gold = %d WHERE id = %d", PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}90 tokena {FFFF00}za nagradu: {F7BBEE}otplata kredita.");

// 			format(query, sizeof query, "UPDATE igraci SET nivo = %i, iskustvo = 0, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_token], PI[playerid][p_id]);
// 			mysql_tquery(SQL, query);

// 			new logStr[128];
// 			format(logStr, sizeof logStr, "%s | Otplata kredita (90)", ime_obicno[playerid]);
// 			Log_Write(LOG_TOKEN, logStr);
// 		}
//         case 9: // Spec nick = 100 token
//         {
//             // if (PI[playerid][p_token] < 100)
//             //     return ErrorMsg(playerid, "Nemate dovoljno tokena za ovu nagradu.");

//             return InfoMsg(playerid, "Cena za Spec Nick iznosi 5 EUR.");
//         }
//         case 10: // VIP Bronze = $12.000.000
//         {
//             if (PI[playerid][p_novac] < 12000000)
//                 return ErrorMsg(playerid, "Nemate dovoljno novca za VIP Bronze.");

//             PlayerMoneySub(playerid, 12000000);
//             SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}$15.000.000 {FFFF00}za nagradu: {F7BBEE}VIP Brozne (30 dana).");

//             new validUntil = gettime() + 30*86400, vipName[9], h,m,s;
//             VIP_GetPackageName(1, vipName, sizeof vipName);

//             // Pasos
//             gettime(h, m, s);
//             PI[playerid][p_pasos] = validUntil + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih X dana (isto koliko i VIP), pa jos do kraja sledeceg dana

//             // Spawn health
//             PI[playerid][p_spawn_health] = 100.0;
//             new spawn[63];
//             format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f|%d|%d|%.1f|%.1f", PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a],
//             PI[playerid][p_spawn_ent], PI[playerid][p_spawn_vw], PI[playerid][p_spawn_health], PI[playerid][p_spawn_armour]);

//             // Upisivanje u bazu
//             new query[285];
//             format(query, sizeof query, "UPDATE igraci SET vip_level = 1, vip_istice = %i, vip_refill = 0, vip_replenish = 0, novac = %i, pasos = FROM_UNIXTIME(%i), spawn = '%s' WHERE id = %i", validUntil, PI[playerid][p_novac], PI[playerid][p_pasos], spawn, PI[playerid][p_id]);
//             mysql_tquery(SQL, query);

//             // Postavljanje pozicije
//             PI[playerid][p_vip_level] = 1;
//             PI[playerid][p_vip_refill] = 0;
//             PI[playerid][p_vip_replenish] = 0;
//             UpdatePlayerBubble(playerid);
//             FLAGS_SetupVIPFlags(playerid);

//             new logStr[128];
//             format(logStr, sizeof logStr, "%s | VIP Bronze ($12.000.000)", ime_obicno[playerid]);
//             Log_Write(LOG_TOKEN, logStr);

//         }
//         case 11: // Dodatni slot za vozilo = $15.000.000
//         {
//             if (PI[playerid][p_vozila_slotovi] >= 6)
//                 return ErrorMsg(playerid, "Moguce je imati najvise 6 slotova za vozila.");

//             if (PI[playerid][p_novac] < 15000000)
//                 return ErrorMsg(playerid, "Nemate dovoljno novca za dodatni slot.");

//             PI[playerid][p_vozila_slotovi] ++;
//             PlayerMoneySub(playerid, 15000000);
//             SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}$15.000.000 {FFFF00}za nagradu: {F7BBEE}dodatni slot za vozilo.");

//             new query[56];
//             format(query, sizeof query, "UPDATE igraci SET vozila_slotovi = %i WHERE id = %i", PI[playerid][p_vozila_slotovi], PI[playerid][p_id]);
//             mysql_tquery(SQL, query);

//             new logStr[128];
//             format(logStr, sizeof logStr, "%s | Slot za vozilo ($15.000.000)", ime_obicno[playerid]);
//             Log_Write(LOG_TOKEN, logStr);
//         }
// 	}
// 	return 1;
// }

forward MySQL_CheckPhoneDuplicate(playerid, ccinc, number);
public MySQL_CheckPhoneDuplicate(playerid, ccinc, number)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows)
	{
		PI[playerid][p_sim_broj] = number;
		PI[playerid][p_token] -= 300;

		SendClientMessageF(playerid, ZUTA, "* Zamijenili ste {F7BBEE}300 tokena {FFFF00}za nagradu: {F7BBEE}telefonski broj po izboru (%d)", number);

		new sQuery[67];
		format(sQuery, sizeof sQuery, "UPDATE igraci SET gold = %i, sim_broj = %i WHERE id = %i", PI[playerid][p_token], PI[playerid][p_sim_broj], PI[playerid][p_id]);
		mysql_tquery(SQL, sQuery);

		new sLog[57];
		format(sLog, sizeof sLog, "%s | Telefon (15) | %d", ime_obicno[playerid], number);
		Log_Write(LOG_TOKEN, sLog);
	}
	else
	{
		return ErrorMsg(playerid, "Neko drugi vec ima takav broj telefona.");
	}
	return 1;
}

Dialog:token_customPlate(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	new slot = vipVehDialog[playerid][listitem],
		model = GetVehicleModel(OwnedVehicle[pVehicles[playerid][slot]][V_ID]);


	if (IsVehicleBicycle(model) || IsVehicleBoat(model) || IsVehicleMotorbike(model) || IsVehicleHelicopter(model) || IsVehicleAirplane(model))
		return ErrorMsg(playerid, "Izabrano vozilo ne moze imati tablice.");

	if (!OwnedVehicle_IsRegistered(pVehicles[playerid][slot]))
		return ErrorMsg(playerid, "Izabrano vozilo nije registrovano.");

	SetPVarInt(playerid, "numberPlate_SLOT", slot);
	SPD(playerid, "token_customPlate2", DIALOG_STYLE_INPUT, "TOKEN", "{FFFFFF}Unesite zeljeni natpis na tablicama (max. duzina = 32):", "Promeni", "Odustani");
	return 1;
}

Dialog:vip(playerid, response, listitem, const inputtext[])
{
	if (!response)
    {
        if (IsVIP(playerid, 1) && GetPVarInt(playerid, "vipOverride") == 1)
        {
            callcmd::vip(playerid, "");
        }
        DeletePVar(playerid, "vipOverride");
        return 1;
    }


    SetPVarInt(playerid, "vipOverride", 1);
	switch (listitem)
    {
        case 0: // Spisak VIP paketa
        {
            callcmd::vip(playerid, "");
        }

        case 1: // VIP komande
        {
            dialog_respond:komande(playerid, 1, 4, "VIP komande");
        }

        case 2: // VIP baza
        {
            SetPVarInt(playerid, "pVIPPort", 1);
            dialog_respond:port(playerid, 1, 0, "vip");
            DeletePVar(playerid, "vipOverride");
        }

        case 3: // Teleport
        {
            callcmd::port(playerid, "");
            DeletePVar(playerid, "vipOverride");
        }

        case 4: // Goto
        {
            SPD(playerid, "vipMenu_goto", DIALOG_STYLE_INPUT, "Idi do igraca (goto)", "{FFFFFF}Upisite ime ili ID igraca do kog zelite da se teleportujete.\n* Taj igrac mora prihvatiti zahtev za teleport!", "Posalji", "Nazad");
        }

        case 5: // Popravi vozilo
        {
            callcmd::vipfv(playerid, "");
            DeletePVar(playerid, "vipOverride");
        }

        case 6: // Dopuni vozilo gorivom
        {
            callcmd::viprefill(playerid, "");
            DeletePVar(playerid, "vipOverride");
        }

        case 7: // HP na 100%, glad na 0%
        {
            new cmdLimit = 1000;

            if (IsVIP(playerid, 4)) cmdLimit = 10;
            else if (IsVIP(playerid, 3)) cmdLimit = 5;
            else if (IsVIP(playerid, 2)) cmdLimit = 2;

            if (PI[playerid][p_vip_replenish] >= cmdLimit) return ErrorMsg(playerid, "Prekoracili ste dnevni limit za koriscenje ove pogodnosti (%i/%i).", cmdLimit, cmdLimit);
            if (IsPlayerInWar(playerid)) return ErrorMsg(playerid, "Ne mozes ovo koristiti u waru");


            PI[playerid][p_vip_replenish] ++;
            PI[playerid][p_glad] = 0;
            PlayerHungerUpdate(playerid);
            SetPlayerHealth(playerid, 100.0);
            SendClientMessageF(playerid, 0x00FF00FF, "* Health je napunjen do 100%% i glad je smanjena na 0%%. (%i/%i)", PI[playerid][p_vip_replenish], cmdLimit);

            new query[55];
            format(query, sizeof query, "UPDATE igraci SET vip_replenish = %i WHERE id = %i", PI[playerid][p_vip_replenish], PI[playerid][p_id]);
            mysql_tquery(SQL, query);
            
            // Upisivanje u log
            format(string_128, sizeof string_128, "Komanda: /replenish | %s", ime_obicno[playerid]);
            Log_Write(LOG_VIP, string_128);

            DeletePVar(playerid, "vipOverride");
        }

        case 8: // Uplati Lucky One
        {
            SPD(playerid, "vipMenu_luckyone", DIALOG_STYLE_INPUT, "LuckyOne", "{FFFFFF}Upisite broj na koji zelite da se kladite:", "Uplati", "Odustani");
            DeletePVar(playerid, "vipOverride");
        }

        case 9: // Borilacke vestine
        {
            callcmd::borilacke_vestine(playerid, "");
            DeletePVar(playerid, "vipOverride");
        }

        case 10: // Respawn svog vozila
        {
            new string[512];
            format(string, 30, "Slot\tVozilo\tModel\tTablice");
            
            new item = 0;
            for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
            {
                if (pVehicles[playerid][i] == 0) continue; // prazan slot
                
                new veh = pVehicles[playerid][i], color[7];
                if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
                else color = "FFFFFF";

                format(string, 512, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", string, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

                vipVehDialog[playerid][item++] = i; // belezi se koji je slot
            }
            
            if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");

            DeletePVar(playerid, "vipOverride");
            SPD(playerid, "vipMenu_respawnVeh", DIALOG_STYLE_TABLIST_HEADERS, "RESPAWN VOZILA", string, "Respawn", "Nazad");
        }

        case 11: // Gethere
        {
            SPD(playerid, "vipMenu_gethere", DIALOG_STYLE_INPUT, "Idi do igraca (gethere)", "{FFFFFF}Upisite ime ili ID igraca kojeg zelite da teleportujete do sebe.\n* Taj igrac mora prihvatiti zahtev za teleport!", "Posalji", "Nazad");
        }

        case 12: // Privatna poruka (PM)
        {
            DeletePVar(playerid, "vipOverride");
            return InfoMsg(playerid, "Koristite /pm.");
        }

        case 13: // Ukljuci/iskljuci PM
        {
            hPM{playerid} = !hPM{playerid};
            SendClientMessageF(playerid, BELA, "* Privatne poruke su sada %s.", (hPM{playerid}? ("{00FF00}ukljucene") : ("{FF0000}iskljucene")));
            DeletePVar(playerid, "vipOverride");
        }

        case 14: // PM offline igracu
        {
            DeletePVar(playerid, "vipOverride");
            return InfoMsg(playerid, "Koristite /offpm.");
        }

        case 15: // Promeni skin
        {
            SPD(playerid, "vipMenu_skin", DIALOG_STYLE_INPUT, "PROMENA SKINA", "{FFFFFF}Unesite ID skina koji zelite da postavite sebi:", "Postavi", "Nazad");
        }

        case 16: // Promeni spawn
        {
            callcmd::spawn(playerid, "");
        }

        case 17: // Teleport svog vozila
        {
            new string[512];
            format(string, 30, "Slot\tVozilo\tModel\tTablice");
            
            new item = 0;
            for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
            {
                if (pVehicles[playerid][i] == 0) continue; // prazan slot
                
                new veh = pVehicles[playerid][i], color[7];
                if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
                else color = "FFFFFF";

                format(string, 512, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", string, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

                vipVehDialog[playerid][item++] = i; // belezi se koji je slot
            }
            
            if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");

            DeletePVar(playerid, "vipOverride");
            SPD(playerid, "vipMenu_teleportVeh", DIALOG_STYLE_TABLIST_HEADERS, "TELEPORT VOZILA DO SEBE", string, "Teleport", "Nazad");
        }

        case 18: // Transfer
        {
        	callcmd::viptransfer(playerid, "");
        }
    }

    return 1;
}

Dialog:vipMenu_respawnVeh(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        new slot = vipVehDialog[playerid][listitem],
            id = pVehicles[playerid][slot];

        if (IsVehicleOccupied_OW(OwnedVehicle[id][V_ID]) && GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID])
            return ErrorMsg(playerid, "Ne mozete respawnati vozilo dok ga neko koristi.");

        SetVehicleToRespawn(OwnedVehicle[id][V_ID]);
        SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_VW]);
        LinkVehicleToInterior(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_ENT]);

        SendClientMessage(playerid, SVETLOPLAVA, "* Respawnali ste svoje vozilo.");
        DialogReopen(playerid);
    }
    return 1;
}

Dialog:vipMenu_teleportVeh(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        new slot = vipVehDialog[playerid][listitem],
            id = pVehicles[playerid][slot],
            Float:x, Float:y, Float:z;

        if (IsVehicleOccupied_OW(OwnedVehicle[id][V_ID]))
            return ErrorMsg(playerid, "Ne mozete teleportovati vozilo dok ga neko koristi.");

        if(TurfState[playerid])
            return ErrorMsg(playerid, "Ne mozete teleportovati vozilo dok traje zauzimanje teritorija.");

        GetPlayerPos(playerid, x, y, z);
        SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(OwnedVehicle[id][V_ID], GetPlayerInterior(playerid));
        SetVehiclePos(OwnedVehicle[id][V_ID], x+3.0, y, z);

        SendClientMessage(playerid, SVETLOPLAVA, "* Teleportovali ste svoje vozilo do sebe.");
        DialogReopen(playerid);
    }
    return 1;
}

Dialog:vipMenu_goto(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        if (isnull(inputtext))
            return DialogReopen(playerid);

        return callcmd::vipgoto(playerid, inputtext);
    }
}

Dialog:vipMenu_gethere(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        if (isnull(inputtext))
            return DialogReopen(playerid);

        return callcmd::vipgethere(playerid, inputtext);
    }
}

Dialog:vipMenu_skin(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        if (isnull(inputtext))
            return DialogReopen(playerid);

        new skin = strval(inputtext);
        if (skin < 0 || skin > 311) 
        {
            DialogReopen(playerid);
            return ErrorMsg(playerid, "Skin ID moze biti najmanje 0, a najvise 311.");
        }
        
        PI[playerid][p_skin] = skin;
        SetPlayerSkin(playerid, skin);
        SetSpawnInfo(playerid, 0, skin, PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);

        SendClientMessageF(playerid, SVETLOPLAVA, "* Postavljen Vam je skin id %d. Skin ce se resetovati nakon reloga.", skin);

        DeletePVar(playerid, "vipOverride");
        return callcmd::vip(playerid, "");
    }
}

Dialog:vipMenu_luckyone(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        return callcmd::vip(playerid, "");
    }
    else
    {
        if (isnull(inputtext))
            return DialogReopen(playerid);

        return callcmd::luckyone(playerid, inputtext);
    }
}

Dialog:vip_packages(playerid, response, listitem, const inputtext[])
{
	if (!response)
    {
        if (IsVIP(playerid, 1))
        {
            DeletePVar(playerid, "vipOverride");
            callcmd::vip(playerid, "");
        }
        return 1;
    }

	new string[1760];
	if (listitem == 0) // Bronze
	{
		format(string, sizeof string, "{CD7F32}VIP BRONZE PAKET\n\n{FFFFFF}\
			- Respekti: {33CCFF}2x\n{FFFFFF}\
			- Teleport: {33CCFF}Gradovi\n{FFFFFF}\
			- Pristup posebnom chatu {AF28A4}/pv\n{FFFFFF}\
			- Natpis {AF28A4}<> VIP <> {FFFFFF}iznad glave\n{FFFFFF}\
			- Pristup {AF28A4}VIP bazi\n{FFFFFF}\
			- Koriscenje luksuznih {AF28A4}VIP vozila\n{FFFFFF}\
			- Cena za /pitanje i /prijava: {00FF00}$0\n{FFFFFF}\
			- Health na spawnu: {00FF00}100hp\n{FFFFFF}\
			- Kamatna stopa: {00FF00}0.2%%\n{FFFFFF}\
			- Popust za registraciju vozila: {00FF00}20%%\n{FFFFFF}\
			- Teleport do igraca: {00FF00}svakih 15 minuta\n{FFFFFF}\
			- Komanda /fv za popravku vozila: {00FF00}svakih 10 minuta\n\n\
			\
			{FFFFFF}Trajanje: {FF9900}30 dana\n\
			{FFFFFF}Cena: {FFFF00}3 EUR / 360 RSD / 6 KM / 25 KN\n\n\
			\
			{FFFFFF}* Za detalje o nacinima uplate posetite forum: "#FORUM);
	}
	else if (listitem == 1) // Silver
	{   // - Novcani dodatak: {FFFF00}$100.000\n{FFFFFF}
		format(string, sizeof string, "{C0C0C0}VIP SILVER PAKET\n\n{FFFFFF}\
			- Respekti: {33CCFF}2x\n{FFFFFF}\
			- Teleport: {33CCFF}Bitne lokacije\n{FFFFFF}\
			- Pristup posebnom chatu {AF28A4}/pv\n{FFFFFF}\
			- Natpis {AF28A4}<> VIP <> {FFFFFF}iznad glave\n{FFFFFF}\
			- Pristup {AF28A4}VIP bazi\n{FFFFFF}\
			- Koriscenje luksuznih {AF28A4}VIP vozila\n{FFFFFF}\
			- Cena za /pitanje i /prijava: {00FF00}$0\n{FFFFFF}\
			- Health na spawnu: {00FF00}100hp\n{FFFFFF}\
			- Pancir na spawnu: {00FF00}35\n{FFFFFF}\
			- Kamatna stopa: {00FF00}0.25%%\n{FFFFFF}\
			- Popust za registraciju vozila: {00FF00}40%%\n{FFFFFF}\
			- Teleport do igraca: {00FF00}svakih 10 minuta\n{FFFFFF}\
			- Komanda /fv za popravku vozila: {00FF00}svakih 5 minuta\n{FFFFFF}\
			- Komanda /refill za dopunu goriva: {00FF00}2x dnevno\n{FFFFFF}\
			- Health na 100, glad na 0: {00FF00}1x dnevno\n{FFFFFF}\
			- Neogranicen pasos\n{FFFFFF}\
            - Besplatan heal u bolnici\n{FFFFFF}\
			- Globalno uplacivanje Lucky One (sa bilo koje lokacije)\n{FFFFFF}\
			- Izbor borilackih vestina\n\n\
			\
			{FFFFFF}Trajanje: {FF9900}30 dana\n\
			{FFFFFF}Cena: {FFFF00}5 EUR / 600 RSD / 10 KM / 40 KN\n\n\
			\
			{FFFFFF}* Za detalje o nacinima uplate posetite forum: "#FORUM);
	}
	else if (listitem == 2) // Gold
	{ //- Novcani dodatak: {FFFF00}$200.000\n{FFFFFF}
		format(string, sizeof string, "{CBA135}VIP GOLD PAKET\n\n{FFFFFF}\
			- Respekti: {33CCFF}3x\n{FFFFFF}\
			- Teleport: {33CCFF}Sve lokacije\n{FFFFFF}\
			- Pristup posebnom chatu {AF28A4}/pv\n{FFFFFF}\
			- Natpis {AF28A4}<> VIP <> {FFFFFF}iznad glave\n{FFFFFF}\
			- Pristup {AF28A4}VIP bazi\n{FFFFFF}\
			- Koriscenje luksuznih {AF28A4}VIP vozila\n{FFFFFF}\
			- Cena za /pitanje i /prijava: {00FF00}$0\n{FFFFFF}\
			- Health na spawnu: {00FF00}100hp\n{FFFFFF}\
			- Pancir na spawnu: {00FF00}70\n{FFFFFF}\
			- Kamatna stopa: {00FF00}0.33%%\n{FFFFFF}\
			- Popust za registraciju vozila: {00FF00}70%%\n{FFFFFF}\
			- Teleport do igraca: {00FF00}svakih 5 minuta\n{FFFFFF}\
			- Komanda /fv za popravku vozila: {00FF00}na 1 minut\n{FFFFFF}\
			- Komanda /refill za dopunu goriva: {00FF00}5x dnevno\n{FFFFFF}\
			- Health na 100, glad na 0: {00FF00}3x dnevno\n{FFFFFF}\
			- Neogranicen pasos\n{FFFFFF}\
            - Besplatan heal u bolnici\n{FFFFFF}\
			- Globalno uplacivanje Lucky One (sa bilo koje lokacije)\n{FFFFFF}\
			- Izbor borilackih vestina\n{FFFFFF}\
			- /report i /pitanje bez cooldown-a\n{FFFFFF}\
			- Respawn svojih vozila\n{FFFFFF}\
			- Teleport igraca do sebe\n{FFFFFF}\
			- Slanje privatnih poruka (/pm)\n{FFFFFF}\
			- Iskljucivanje privatnih poruka\n\n\
			\
			{FFFFFF}Trajanje: {FF9900}30 dana\n\
			{FFFFFF}Cena: {FFFF00}8 EUR / 1000 RSD / 16 KM / 60 KN\n\n\
			\
			{FFFFFF}* Za detalje o nacinima uplate posetite forum: "#FORUM);
	}
	else if (listitem == 3) // Platinum
	{ //- Novcani dodatak: {FFFF00}$300.000\n{FFFFFF}
		format(string, sizeof string, "{E5E4E2}VIP PLATINUM PAKET\n\n{FFFFFF}\
			- Respekti: {33CCFF}3x\n{FFFFFF}\
			- Teleport: {33CCFF}Sve lokacije (prosireno)\n{FFFFFF}\
			- Pristup posebnom chatu {AF28A4}/pv\n{FFFFFF}\
			- Natpis {AF28A4}<> VIP <> {FFFFFF}iznad glave\n{FFFFFF}\
			- Pristup {AF28A4}VIP bazi\n{FFFFFF}\
			- Koriscenje luksuznih {AF28A4}VIP vozila\n{FFFFFF}\
			- Cena za /pitanje i /prijava: {00FF00}$0\n{FFFFFF}\
			- Health na spawnu: {00FF00}100hp\n{FFFFFF}\
			- Pancir na spawnu: {00FF00}100\n{FFFFFF}\
			- Kamatna stopa: {00FF00}0.45%%\n{FFFFFF}\
			- Popust za registraciju vozila: {00FF00}100%%\n{FFFFFF}\
			- Teleport do igraca: {00FF00}neograniceno\n{FFFFFF}\
			- Komanda /fv za popravku vozila: {00FF00}neograniceno\n{FFFFFF}\
			- Komanda /refill za dopunu goriva: {00FF00}neograniceno\n{FFFFFF}\
			- Health na 100, glad na 0: {00FF00}10x dnevno\n{FFFFFF}\
			- Neogranicen pasos\n{FFFFFF}\
            - Besplatan heal u bolnici\n{FFFFFF}\
			- Globalno uplacivanje Lucky One (sa bilo koje lokacije)\n{FFFFFF}\
			- Izbor borilackih vestina\n{FFFFFF}\
			- /report i /pitanje bez cooldown-a\n{FFFFFF}\
			- Respawn svojih vozila\n{FFFFFF}\
			- Teleport igraca do sebe\n{FFFFFF}\
			- Slanje privatnih poruka (/pm)\n{FFFFFF}\
			- Iskljucivanje privatnih poruka\n{FFFFFF}\
			- Slanje PM-a igracima koji su offline (/offpm)\n{FFFFFF}\
			- Promena skina bilo kada\n{FFFFFF}\
			- Spawn na bilo kojoj lokaciji\n{FFFFFF}\
			- Teleport privatnih vozila do sebe\n{FFFFFF}\
			- Transfer novca sa bilo koje lokacije\n{FFFFFF}\
			- Iskljucivanje chatova (/f, /r, /d, /l, /pv, ...)\n{FFFFFF}\
			- Izrada bombe na bilo kojoj lokaciji\n\n\
			\
			{FFFFFF}Trajanje: {FF9900}30 dana\n\
			{FFFFFF}Cena: {FFFF00}10 EUR / 1200 RSD / 20 KM / 75 KN\n\n\
			\
			{FFFFFF}* Za detalje o nacinima uplate posetite forum: "#FORUM);
	}

	SPD(playerid, "vip_return", DIALOG_STYLE_MSGBOX, "VIP info", string, "Nazad", "");
	return 1;
}

Dialog:vip_return(playerid, response, listitem, const inputtext[])
{
	return callcmd::vip(playerid, "");
}

Dialog:vip_goto(playerid, response, listitem, const inputtext[])
{
    new id = GetPVarInt(playerid, "vipGotoRequested");

    if (!IsVIP(id, 1) || GetPVarInt(id, "vipGoto") != playerid)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (!response)
    {
        DeletePVar(playerid, "vipGotoRequested");
        DeletePVar(id, "vipGoto");
        ErrorMsg(id, "%s je odbio teleport.", ime_obicno[playerid]);
    }
    else
    {
        if (GetPVarInt(id, "vipGotoCooldown") > gettime())
        {
            ErrorMsg(playerid, "Taj igrac je nedavno vec iskoristio teleport.");
            ErrorMsg(playerid, "Vec ste se nedavno teleportovali do igraca. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(id, "vipGotoCooldown")-gettime()));
            return 1;
        }

        // Glavna funkcija komande
        SetPlayerInterior(id, GetPlayerInterior(playerid));
        SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));
        GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
        TeleportPlayer(id, pozicija[playerid][0], pozicija[playerid][1] + 4.0, pozicija[playerid][2]);
        
        // Slanje poruke igracu
        SendClientMessageF(id, INFO, "(teleport) {9DF2B5}Teleportovani ste do igraca %s.", ime_rp[playerid], playerid);

        // Cooldown
        if (IsVIP(id, 4))
            SetPVarInt(id, "vipGotoCooldown", gettime()); // Neograniceno
        else if (IsVIP(id, 3))
            SetPVarInt(id, "vipGotoCooldown", gettime()+300); // 5 minuta
        else if (IsVIP(id, 2))
            SetPVarInt(id, "vipGotoCooldown", gettime()+600); // 10 minuta
        else if (IsVIP(id, 1))
            SetPVarInt(id, "vipGotoCooldown", gettime()+900); // 15 minuta

        // Upisivanje u log
        new string[128];
        format(string, sizeof string, "/idido | %s do %s", ime_obicno[id], ime_obicno[playerid]);
        Log_Write(LOG_VIP, string);
    }


    DeletePVar(playerid, "vipGotoRequested");
    DeletePVar(id, "vipGoto");
    return 1;
}

Dialog:vip_gethere(playerid, response, listitem, const inputtext[])
{
    new id = GetPVarInt(playerid, "vipGethereRequested");

    if (!IsVIP(id, 3) || GetPVarInt(id, "vipGethere") != playerid)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    if (!response)
    {
        DeletePVar(playerid, "vipGethereRequested");
        DeletePVar(id, "vipGethere");
        ErrorMsg(id, "%s je odbio teleport.", ime_obicno[playerid]);
    }
    else
    {
        if (GetPVarInt(id, "vipGethereCooldown") > gettime())
        {
            ErrorMsg(playerid, "Taj igrac je nedavno vec iskoristio teleport.");
            ErrorMsg(playerid, "Vec ste nedavno teleportovali igraca do sebe. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(id, "vipGethereCooldown")-gettime()));
            return 1;
        }

        // Glavna funkcija komande
        SetPlayerInterior(playerid, GetPlayerInterior(id));
        SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
        GetPlayerPos(id, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
        TeleportPlayer(playerid, pozicija[playerid][0], pozicija[playerid][1] + 4.0, pozicija[playerid][2]);
        
        // Slanje poruke igracu
        SendClientMessageF(playerid, INFO, "(teleport) {9DF2B5}Teleportovani ste do igraca %s[%i].", ime_rp[playerid], playerid);
        SendClientMessageF(id, INFO, "(teleport) {9DF2B5}Teleportovali ste igraca %s[%i] do sebe.", ime_rp[playerid], playerid);

        // Cooldown
        SetPVarInt(id, "vipGethereCooldown", gettime()+300); // 5 minuta

        // Upisivanje u log
        new string[128];
        format(string, sizeof string, "/dovedi | %s do %s", ime_obicno[playerid], ime_obicno[id]);
        Log_Write(LOG_VIP, string);
    }


    DeletePVar(playerid, "vipGethereRequested");
    DeletePVar(id, "vipGethere");
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:token(playerid, const params[])
{
	// SPD(playerid, "token", DIALOG_STYLE_TABLIST, "TOKEN", "$10.000\t1 token\nPoen iskustva\t3 tokena\nPasos na 1 mesec\t8 tokena\nNasumican iznos novca ($1.000 - $250.000)\t10 tokena\nTelefonski broj po izboru\t15 tokena\nTablica za vozilo po izboru\t20 tokena\nPonistavanje kazne ugovora\t35 tokena\nLevel UP\t50 tokena\nOtplata kredita\t90 tokena\n{FFFF00}Spec Nick\t5 EUR\nVIP Bronze (30 dana)\t$12.000.000 / 3 EUR\nDodatni slot za vozilo\t$15.000.000 / 5 EUR", "Izaberi", "Izadji");

    new sDialog[100];
    format(sDialog, sizeof sDialog, "VIP Status\nLevel Up\nVozila\nPremium\n---\nStanje tokena: {00FF00}%i\n{FFFF00}KUPI TOKENE", PI[playerid][p_token]);
    SPD(playerid, "token", DIALOG_STYLE_LIST, "TOKEN MENU", sDialog, "Dalje", "Izadji");

	return 1;
}

Dialog:token(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0)
    {
        // VIP Status
        SPD(playerid, "token_vip", DIALOG_STYLE_TABLIST, "TOKEN MENU", "VIP Bronze\t300 Tokena\nVIP Silver\t500 Tokena\nVIP Gold\t800 Tokena\nVIP Platinum\t1000 Tokena", "Odaberi", "Izadji");
    }

    else if (listitem == 1)
    {
        // Level Up
        SPD(playerid, "token_levelup", DIALOG_STYLE_TABLIST, "TOKEN MENU", "1 x Level Up\t100 Tokena\n4 x Level Up\t300 Tokena\n7 x Level Up\t500 Tokena", "Odaberi", "Izadji");
    }

    else if (listitem == 2)
    {
        // Vozila
        SPD(playerid, "token_vehicles", DIALOG_STYLE_TABLIST, "TOKEN MENU", "Dodatni slot\t500 Tokena\nBullet\t800 Tokena\nDuneride\t800 Tokena\nSultan\t1000 Tokena\nNRG-500\t1000 Tokena\nInfernus\t1200 Tokena\nFBI Rancher\t1000 Tokena\nBus\t500 Tokena\nBoxville\t500 Tokena\nBandito\t500 Tokena\nKart\t500 Tokena\nMonster\t1000 Tokena\nHotring Racer\t1000 Tokena\nBloodring Banger\t700 Tokena\nDumper\t1500 Tokena", "Odaberi", "Izadji");
    }

    else if (listitem == 3)
    {
        // Premium
        SPD(playerid, "token_premium", DIALOG_STYLE_TABLIST, "TOKEN MENU", "DJ\t500 Tokena\nSpec Nick\t500 Tokena\nNick u boji\t500 Tokena\nTel. broj sa 3 cifre\t300 Tokena\nPosebne tablice na autu\t300 Tokena", "Odaberi", "Izadji");
    }

    else if (listitem == 6)
    {
        // Kupi tokene
        SPD(playerid, "token_info", DIALOG_STYLE_MSGBOX, "TOKEN MENU", "{FFFFFF}Tokene mozete dobiti ukoliko donirate odredjeni iznos novca.\n\n{FFFF00}    100 Tokena = 1 EUR / 120 RSD / 2 BAM / 8 HRK\n\n{FFFFFF}Nacini uplate:\n- PayPal:  {33CCFF}www.paypal.me/nlsamp\n{FFFFFF}- Western Union\n- Posta/banka (samo iz Srbije)\n\nZa dodatne informacije kontaktirajte {FFFF00}Head Admine.", "U redu", "");
    }

    else return callcmd::token(playerid, "");

    return 1;
}

Dialog:token_info(playerid, response, listitem, const inputtext[])
{
    return callcmd::token(playerid, "");
}

Dialog:token_vip(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        callcmd::token(playerid, "");
        return 1;
    }

    if (IsPromoter(playerid, 1))
        return ErrorMsg(playerid, "Ne mozes biti Promoter i VIP istovremeno.");

    if (PI[playerid][p_vip_level] > 0 && PI[playerid][p_vip_istice] > (gettime()-86400))
    {
        // Ostalo je vise od 24h trajanja prethodnog vipa
        return ErrorMsg(playerid, "VIP status mozes produziti najranije 24h pre isteka trenutnog VIP-a.");
    }


    new iValidUntil = gettime() + 30*86400,
        sLog[64];

    if (listitem == 0)
    {
        // VIP Bronze

        if (PI[playerid][p_token] < 300)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");
        
        PI[playerid][p_token] -= 300;
        PI[playerid][p_spawn_health] = 100.0;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}VIP Bronze (30 dana)");
        format(sLog, sizeof sLog, "%s | VIP Bronze (300)", ime_obicno[playerid]);
    }

    else if (listitem == 1)
    {
        // VIP Silver

        if (PI[playerid][p_token] < 500)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");
        
        PI[playerid][p_token] -= 500;
        PlayerMoneyAdd(playerid, 100000);
        PI[playerid][p_spawn_armour] = 35.0;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}VIP Silver (30 dana)");
        format(sLog, sizeof sLog, "%s | VIP Silver (500)", ime_obicno[playerid]);
    }

    else if (listitem == 2)
    {
        // VIP Gold

        if (PI[playerid][p_token] < 800)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");
        
        PI[playerid][p_token] -= 800;
        PlayerMoneyAdd(playerid, 200000);
        PI[playerid][p_spawn_armour] = 75.0;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}800 tokena {FFFF00}za nagradu: {F7BBEE}VIP Gold (30 dana)");
        format(sLog, sizeof sLog, "%s | VIP Gold (800)", ime_obicno[playerid]);
    }

    else if (listitem == 3)
    {
        // VIP Platinum

        if (PI[playerid][p_token] < 1000)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

        PI[playerid][p_token] -= 1000;
        PlayerMoneyAdd(playerid, 300000);
        PI[playerid][p_spawn_armour] = 100.0;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}VIP Platinum (30 dana)");
        format(sLog, sizeof sLog, "%s | VIP Platinum (1000)", ime_obicno[playerid]);
    }

    else return callcmd::token(playerid, "");

    ChatEnableForPlayer(playerid, CHAT_PROMOVIP);

    // Postavljanje pasosa za narednih 30 dana
    new h,m,s;
    gettime(h, m, s);
    PI[playerid][p_pasos] = iValidUntil + 86400 - h*60*60 - m*60 - s; // pasos vazi narednih 30 dana (isto koliko i VIP), pa jos do kraja sledeceg dana

    new sSpawn[63];
    format(sSpawn, sizeof(sSpawn), "%.4f|%.4f|%.4f|%.4f|%d|%d|%.1f|%.1f", PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], PI[playerid][p_spawn_ent], PI[playerid][p_spawn_vw], PI[playerid][p_spawn_health], PI[playerid][p_spawn_armour]);

    new sQuery[285];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET vip_level = %i, vip_istice = %i, vip_refill = 0, vip_replenish = 0, novac = %i, pasos = FROM_UNIXTIME(%i), spawn = '%s', gold = %i WHERE id = %i", listitem+1, iValidUntil, PI[playerid][p_novac], PI[playerid][p_pasos], sSpawn, PI[playerid][p_token], PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery);

    Log_Write(LOG_TOKEN, sLog);

    // Postavljanje pozicije
    PI[playerid][p_vip_level] = listitem+1;
    PI[playerid][p_vip_istice] = iValidUntil;
    PI[playerid][p_vip_refill] = 0;
    PI[playerid][p_vip_replenish] = 0;
    UpdatePlayerBubble(playerid);
    FLAGS_SetupVIPFlags(playerid);

    return callcmd::token(playerid, "");
}

Dialog:token_levelup(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        callcmd::token(playerid, "");
        return 1;
    }


    new sLog[64];

    if (listitem == 0)
    {
        // 1 x Level Up

        if (PI[playerid][p_token] < 100)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

        PI[playerid][p_token] -= 100;
        PI[playerid][p_nivo] += 1;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}100 tokena {FFFF00}za nagradu: {F7BBEE}1 x Level UP (nivo %i)", PI[playerid][p_nivo]);
        format(sLog, sizeof sLog, "%s | 1 x Level UP (100)", ime_obicno[playerid]);
    }

    else if (listitem == 1)
    {
        // 4 x Level Up
        
        if (PI[playerid][p_token] < 300)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

        PI[playerid][p_token] -= 300;
        PI[playerid][p_nivo] += 4;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}300 tokena {FFFF00}za nagradu: {F7BBEE}4 x Level UP (nivo %i)", PI[playerid][p_nivo]);
        format(sLog, sizeof sLog, "%s | 4 x Level UP (300)", ime_obicno[playerid]);
    }

    else if (listitem == 2)
    {
        // 7 x Level Up
        
        if (PI[playerid][p_token] < 500)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

        PI[playerid][p_token] -= 500;
        PI[playerid][p_nivo] += 7;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}7 x Level UP (nivo %i)", PI[playerid][p_nivo]);
        format(sLog, sizeof sLog, "%s | 7 x Level UP (500)", ime_obicno[playerid]);
    }

    else return callcmd::token(playerid, "");

    new sQuery[70];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %i, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_token], PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery);
    
    Log_Write(LOG_TOKEN, sLog);

    return 1;
}

Dialog:token_vehicles(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        callcmd::token(playerid, "");
        return 1;
    }


    new sLog[64];

    if (listitem == 0)
    {
        // Dodatni slot fixed by daddyDOT 23.5.2022

        if (PI[playerid][p_token] < 500)
        {
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");
        }

        if(PI[playerid][p_vozila_slotovi] >= 6)
        {
            return ErrorMsg(playerid, "Vec imas maksimalan broj slotova za vozila (6).");
        }

        PI[playerid][p_token] -= 500;
        PI[playerid][p_vozila_slotovi]++;

        SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Dodatni slot za vozilo");
        format(sLog, sizeof sLog, "%s | Slot za vozilo (500)", ime_obicno[playerid]);
    
        new query[56];
        format(query, sizeof query, "UPDATE igraci SET vozila_slotovi = %i WHERE id = %i", PI[playerid][p_vozila_slotovi], PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }

    else
    {
        new iTokenPrice = 0, iVehModel;

        if (listitem == 1)
        {
            // Bullet
            iTokenPrice = 800;
            iVehModel = 541;
        }

        else if (listitem == 2)
        {
            // Duneride
            iTokenPrice = 800;
            iVehModel = 573;
        }

        else if (listitem == 3)
        {
            // Sultan
            iTokenPrice = 1000;
            iVehModel = 560;
        }

        else if (listitem == 4)
        {
            // NRG-500
            iTokenPrice = 1000;
            iVehModel = 522;
        }

        else if (listitem == 5)
        {
            // Infernus
            iTokenPrice = 1200;
            iVehModel = 411;
        }

        else if (listitem == 6)
        {
            // FBI Rancher
            iTokenPrice = 1000;
            iVehModel = 490;
        }

        else if (listitem == 7)
        {
            // Bus
            iTokenPrice = 500;
            iVehModel = 431;
        }

        else if (listitem == 8)
        {
            // Boxville
            iTokenPrice = 500;
            iVehModel = 498;
        }

        else if (listitem == 9)
        {
            // Bandito
            iTokenPrice = 500;
            iVehModel = 568;
        }

        else if (listitem == 10)
        {
            // Kart
            iTokenPrice = 500;
            iVehModel = 571;
        }

        else if (listitem == 11)
        {
            // Monster
            iTokenPrice = 1000;
            iVehModel = 444;
        }

        else if (listitem == 12)
        {
            // Hotring Racer
            iTokenPrice = 1000;
            iVehModel = 494;
        }

        else if (listitem == 13)
        {
            // Bloodring Banger
            iTokenPrice = 700;
            iVehModel = 504;
        }

        else if (listitem == 14)
        {
            // Dumper
            iTokenPrice = 1500;
            iVehModel = 406;
        }

        else return callcmd::token(playerid, "");

            
        if (PI[playerid][p_token] < iTokenPrice)
            return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

        static ima = -1;

        for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) 
        {
            if (pVehicles[playerid][i] == 0) 
            {
                ima = i;
            }
        }

        if (ima == -1) //GetPVarInt(playerid, "pAutosalonSlot") == -1
            return ErrorMsg(playerid, "Nemas slobodne slotove za nova vozila.");

        if (IsVehicleMotorbike(iVehModel))
        {
            SetPVarInt(playerid, "pAutosalonCat", motor);
        }
        else
        {
            SetPVarInt(playerid, "pAutosalonCat", automobil);
        }

        mysql_tquery(SQL, "SELECT (t1.id + 1) as id FROM vozila t1 WHERE NOT EXISTS (SELECT t2.id FROM vozila t2 WHERE t2.id = t1.id + 1) LIMIT 1", "MySQL_VehicleRedeem", "iiii", playerid, iVehModel, cinc[playerid], ima);

        PI[playerid][p_token] -= iTokenPrice;

        SendClientMessageF(playerid, ZUTA, "* Zamenio si {F7BBEE}%i tokena {FFFF00}za nagradu: {F7BBEE}%s", iTokenPrice, inputtext);
        format(sLog, sizeof sLog, "%s | %s (%i)", ime_obicno[playerid], inputtext, iTokenPrice);

    }

    new sQuery[70];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %i, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_token], PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery);
    
    Log_Write(LOG_TOKEN, sLog);

    return 1;
}

Dialog:token_premium(playerid, response, listitem, const inputtext[])
{
    if (!response)
    {
        callcmd::token(playerid, "");
        return 1;
    }


    if (listitem == 0)
    {
        // DJ
        return InfoMsg(playerid, "Ova mogucnost je privremeno nedostupna. Kontaktiraj Head Admine.");
    }

    else if (listitem == 1)
    {
        // Spec nick
        return InfoMsg(playerid, "Ova mogucnost je privremeno nedostupna. Kontaktiraj Head Admine.");
    }

    else if (listitem == 2)
    {
        // Nick u boji
        return InfoMsg(playerid, "Ova mogucnost je privremeno nedostupna. Kontaktiraj Head Admine.");
    }

    else if (listitem == 3)
    {
        // Telefonski broj sa 3 cifre
        if (PI[playerid][p_token] < 300)
        {
            return ErrorMsg(playerid, "Nemas dovoljno tokena za ovu nagradu.");
        }

        if (!PlayerHasPhone(playerid))
        {
            return ErrorMsg(playerid, "Nemas mobilni telefon.");
        }

        SPD(playerid, "token_customPhone", DIALOG_STYLE_INPUT, "TOKEN", "{FFFFFF}Telefonski broj mora imati izmedju 3 i 6 cifara i ne smije pocinjati sa 0.\nUnesi zeljeni broj telefona (bez prefixa):", "Promijeni", "Odustani");
    }

    else if (listitem == 4)
    {
        // Posebne tablice na autu
        if (PI[playerid][p_token] < 300)
            return ErrorMsg(playerid, "Nemas dovoljno tokena za ovu nagradu.");

        new string[512];
        format(string, 30, "Slot\tVozilo\tModel\tTablice");

        new item = 0;
        for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
        {
        if (pVehicles[playerid][i] == 0) continue; // prazan slot

        new veh = pVehicles[playerid][i], color[7];
        if (GetPlayerVehicleID(playerid) == OwnedVehicle[veh][V_ID]) color = "FFFF00";
        else color = "FFFFFF";

        format(string, 512, "%s\n{%s}%d\t{%s}%s\t{%s}%s\t{%s}%s", string, color, i+1, color, propname(OwnedVehicle[veh][V_TYPE], PROPNAME_CAPITAL), color, imena_vozila[OwnedVehicle[veh][V_MODEL] - 400], color, OwnedVehicle[veh][V_PLATE]);

        vipVehDialog[playerid][item++] = i; // belezi se koji je slot
        }

        if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");

        SPD(playerid, "token_customPlate", DIALOG_STYLE_TABLIST_HEADERS, "TOKEN", string, "Odaberi", "Nazad");
    }

    else return callcmd::token(playerid, "");

    return 1;
}

Dialog:token_customPhone(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new number;
    if (sscanf(inputtext, "i", number))
        return DialogReopen(playerid);

    if (number < 100 || number > 999999)
        return DialogReopen(playerid);

    new sQuery[69];
    format(sQuery, sizeof sQuery, "SELECT id FROM igraci WHERE sim = '%s' AND sim_broj = %i", PI[playerid][p_sim], number);
    mysql_tquery(SQL, sQuery, "MySQL_CheckPhoneDuplicate", "iii", playerid, cinc[playerid], number);
    return 1;
}

Dialog:token_customPlate2(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new plate[33],
        slot = GetPVarInt(playerid, "numberPlate_SLOT"),
        id = pVehicles[playerid][slot];

    if (sscanf(inputtext, "s[33]", plate))
        return DialogReopen(playerid);

    if (strlen(inputtext) > 32)
        return DialogReopen(playerid);

    // Generisanje registarskog broja
    strmid(OwnedVehicle[id][V_PLATE], plate, 0, strlen(plate), 33);
    
    // Postavljanje tablice na auto
    SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
    
    // Baza update za vozilo
    mysql_format(SQL, mysql_upit, 128, "UPDATE vozila SET tablica = '%s' WHERE id = %d", OwnedVehicle[id][V_PLATE], id);
    mysql_tquery(SQL, mysql_upit);

    PI[playerid][p_token] -= 300;

    SendClientMessage(playerid, ZUTA, "* Zamenili ste {F7BBEE}300 tokena {FFFF00}za nagradu: {F7BBEE}tablica za vozilo po izboru.");

    new query[60];
    format(query, sizeof query, "UPDATE igraci SET gold = %i WHERE id = %i", PI[playerid][p_token], PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    new logStr[128];
    format(logStr, sizeof logStr, "%s | Tablica (20) | Vozilo %i | %s", ime_obicno[playerid], id, plate);
    Log_Write(LOG_TOKEN, logStr);

    return 1;
}

// Dialog:token_vehicles(playerid, response, listitem, const inputtext[])
// {
//     if (!response)
//     {
//         callcmd::token(playerid, "");
//         return 1;
//     }


//     new sLog[64];

//     if (listitem == 0)
//     {
//         // Dodatni slot

//         if (PI[playerid][p_token] < 500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Dodatni slot za vozilo");
//         format(sLog, sizeof sLog, "%s | Slot za vozilo (500)", ime_obicno[playerid]);
//     }

//     else if (listitem == 1)
//     {
//         // Bullet
        
//         if (PI[playerid][p_token] < 800)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 800;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}800 tokena {FFFF00}za nagradu: {F7BBEE}Bullet");
//         format(sLog, sizeof sLog, "%s | Bullet (800)", ime_obicno[playerid]);
//     }

//     else if (listitem == 2)
//     {
//         // Duneride
        
//         if (PI[playerid][p_token] < 800)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 800;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}800 tokena {FFFF00}za nagradu: {F7BBEE}Duneride");
//         format(sLog, sizeof sLog, "%s | Duneride (800)", ime_obicno[playerid]);
//     }

//     else if (listitem == 3)
//     {
//         // Sultan
        
//         if (PI[playerid][p_token] < 1000)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1000;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}Sultan");
//         format(sLog, sizeof sLog, "%s | Sultan (1000)", ime_obicno[playerid]);
//     }

//     else if (listitem == 4)
//     {
//         // NRG-500
        
//         if (PI[playerid][p_token] < 1000)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1000;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}NRG-500");
//         format(sLog, sizeof sLog, "%s | NRG-500 (1000)", ime_obicno[playerid]);
//     }

//     else if (listitem == 5)
//     {
//         // Infernus
        
//         if (PI[playerid][p_token] < 1200)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1200;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1200 tokena {FFFF00}za nagradu: {F7BBEE}Infernus");
//         format(sLog, sizeof sLog, "%s | Infernus (1200)", ime_obicno[playerid]);
//     }

//     else if (listitem == 6)
//     {
//         // FBI Rancher
        
//         if (PI[playerid][p_token] < 1000)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1000;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}FBI Rancher");
//         format(sLog, sizeof sLog, "%s | FBI Rancher (1000)", ime_obicno[playerid]);
//     }

//     else if (listitem == 7)
//     {
//         // Bus
        
//         if (PI[playerid][p_token] < 500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Bus");
//         format(sLog, sizeof sLog, "%s | Bus (500)", ime_obicno[playerid]);
//     }

//     else if (listitem == 8)
//     {
//         // Boxville
        
//         if (PI[playerid][p_token] < 500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Boxville");
//         format(sLog, sizeof sLog, "%s | Boxville (500)", ime_obicno[playerid]);
//     }

//     else if (listitem == 9)
//     {
//         // Bandito
        
//         if (PI[playerid][p_token] < 500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Bandito");
//         format(sLog, sizeof sLog, "%s | Bandito (500)", ime_obicno[playerid]);
//     }

//     else if (listitem == 10)
//     {
//         // Kart
        
//         if (PI[playerid][p_token] < 500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}500 tokena {FFFF00}za nagradu: {F7BBEE}Kart");
//         format(sLog, sizeof sLog, "%s | Kart (500)", ime_obicno[playerid]);
//     }

//     else if (listitem == 11)
//     {
//         // Monster
        
//         if (PI[playerid][p_token] < 1000)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1000;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}Monster");
//         format(sLog, sizeof sLog, "%s | Monster (1000)", ime_obicno[playerid]);
//     }

//     else if (listitem == 12)
//     {
//         // Hotring Racer
        
//         if (PI[playerid][p_token] < 1000)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1000;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1000 tokena {FFFF00}za nagradu: {F7BBEE}Hotring Racer");
//         format(sLog, sizeof sLog, "%s | Hotring Racer (1000)", ime_obicno[playerid]);
//     }

//     else if (listitem == 13)
//     {
//         // Bloodring Banger
        
//         if (PI[playerid][p_token] < 700)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 700;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}700 tokena {FFFF00}za nagradu: {F7BBEE}Bloodring Banger");
//         format(sLog, sizeof sLog, "%s | Bloodring Banger (700)", ime_obicno[playerid]);
//     }

//     else if (listitem == 14)
//     {
//         // Dumper
        
//         if (PI[playerid][p_token] < 1500)
//             return ErrorMsg(playerid, "Nemas dovoljno Tokena.");

//         PI[playerid][p_token] -= 1500;

//         SendClientMessage(playerid, ZUTA, "* Zamenio si {F7BBEE}1500 tokena {FFFF00}za nagradu: {F7BBEE}Dumper");
//         format(sLog, sizeof sLog, "%s | Dumper (1500)", ime_obicno[playerid]);
//     }

//     else return callcmd::token(playerid, "");

//     new sQuery[70];
//     format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %i, gold = %i WHERE id = %i", PI[playerid][p_nivo], PI[playerid][p_token], PI[playerid][p_id]);
//     mysql_tquery(SQL, sQuery);
    
//     Log_Write(LOG_TOKEN, sLog);

//     return 1;
// }

CMD:vipgoto(playerid, const params[]) 
{
    if (!IsVIP(playerid, 1))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (GetPVarInt(playerid, "vipGotoCooldown") > gettime())
        return ErrorMsg(playerid, "Vec ste se nedavno teleportovali do igraca. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "vipGotoCooldown")-gettime()));

    if (IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste na trci.");

    if (IsPlayerWorking(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok radite posao.");

    if (IsPlayerInDMArena(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u DM Areni.");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u waru.");

    if (PI[playerid][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zatvoreni.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste uhapseni/zavezani.");

    if (IsPlayerWanted(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu ukoliko imate trazeni nivo.");

    if (GetPVarInt(playerid, "pTookDamage")+10 > gettime())
        return ErrorMsg(playerid, "Nedavno ste upucani, morate sacekati 10 sekundi pre nego sto budete mogli da koristite ovu naredbu.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    if (IsACriminal(playerid))
    {
	    if (IsPlayerRobbingJewelry(playerid))
	        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok pljackate zlataru.");

	    if (IsTurfWarActiveForPlayer(playerid))
	        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda napada/brani teritoriju.");

	    if (IsBankRobberyInProgress() && GetFactionRobbingBank() == PI[playerid][p_org_id])
	    	return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda pljacka banku.");
	}
	else if (IsACop(playerid) && IsPlayerOnLawDuty(playerid))
	{
		if (IsBankRobberyInProgress())
			return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka banke.");

		if (GetFactionRobbingJeweley() != -1)
			return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka zlatare.");
	}

    new id;
    if (sscanf(params, "u", id))
        return Koristite(playerid, "idido [Ime ili ID igraca]");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (IsPlayerWorking(id))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok osoba radi posao.");

    if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, "Ne mozete se teleportovati do head admina.");

    new string[105];
    format(string, sizeof string, "{FFFFFF}Igrac sa VIP statusom {FFFF00}%s {FFFFFF}zeli da se teleportuje do Vas.", ime_rp[playerid]);
    SPD(id, "vip_goto", DIALOG_STYLE_MSGBOX, "Zahtev za teleport", string, "Prihvati", "Odbij");

    SetPVarInt(playerid, "vipGoto", id);
    SetPVarInt(id, "vipGotoRequested", playerid);
    return 1;
}

CMD:vipgethere(playerid, const params[]) 
{
    if (!IsVIP(playerid, 3))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (GetPVarInt(playerid, "vipGethereCooldown") > gettime())
        return ErrorMsg(playerid, "Vec ste nedavno teleportovali nekoga. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "vipGethereCooldown")-gettime()));

    if (IsPlayerInRace(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste na trci.");

    if (IsPlayerWorking(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok radite posao.");

    if (IsPlayerInWar(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste u waru.");

    if (PI[playerid][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste zatvoreni.");

    if (PI[playerid][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok ste uhapseni/zavezani.");

    if (IsPlayerWanted(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu ukoliko imate trazeni nivo.");

    if (GetPVarInt(playerid, "pTookDamage")+10 > gettime())
        return ErrorMsg(playerid, "Nedavno ste upucani, morate sacekati 10 sekundi pre nego sto budete mogli da koristite ovu naredbu.");

    if (IsACriminal(playerid))
    {
	    if (IsPlayerRobbingJewelry(playerid))
	        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok pljackate zlataru.");

	    if (IsTurfWarActiveForPlayer(playerid))
	        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda napada/brani teritoriju.");

	    if (IsBankRobberyInProgress() && GetFactionRobbingBank() == PI[playerid][p_org_id])
	    	return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok Vasa mafija/banda pljacka banku.");
	}
	else if (IsACop(playerid) && IsPlayerOnLawDuty(playerid))
	{
		if (IsBankRobberyInProgress())
			return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka banke.");

		if (GetFactionRobbingJeweley() != -1)
			return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer je u toku pljacka zlatare.");
	}

    new id;
    if (sscanf(params, "u", id))
        return Koristite(playerid, "idido [Ime ili ID igraca]");

    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (IsAdmin(id, 6) && !IsAdmin(playerid, 6))
        return ErrorMsg(playerid, "Ne mozete teleportovati head admina.");

    if (IsPlayerInRace(id))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu dok je igrac na trci.");

    if (IsPlayerWorking(id))
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok radi posao.");

    if (IsPlayerInWar(id))
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok je u waru.");

    if (PI[id][p_zatvoren] != 0)
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok je u zatvoru.");

    if (PI[id][p_zavezan] != 0)
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok je uhapsen/zavezan.");

    if (IsPlayerWanted(id))
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca jer ima wanted level.");

    if (GetPVarInt(id, "pTookDamage")+10 > gettime())
        return ErrorMsg(playerid, "Igrac je nedavno upucan, morate sacekati 10 sekundi pre nego sto budete mogli da ga teleportujete.");

    if (IsPlayerRobbingJewelry(id))
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok pljacka zlataru.");

    if (IsTurfWarActiveForPlayer(id))
        return ErrorMsg(playerid, "Ne mozete teleportovati igraca dok njegova mafija/banda napada/brani teritoriju.");

    new string[105];
    format(string, sizeof string, "{FFFFFF}Igrac sa VIP statusom {FFFF00}%s {FFFFFF}zeli da Vas teleportuje do sebe.", ime_rp[playerid]);
    SPD(id, "vip_gethere", DIALOG_STYLE_MSGBOX, "Zahtev za teleport", string, "Prihvati", "Odbij");

    SetPVarInt(playerid, "vipGethere", id);
    SetPVarInt(id, "vipGethereRequested", playerid);
    return 1;
}

CMD:viptransfer(playerid, const params[])
{
	if (!IsVIP(playerid, 4))
		return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

	new targetid, money;
	if (sscanf(params, "ui", targetid, money) || targetid == playerid)
		return Koristite(playerid, "viptransfer [Ime ili ID igraca] [Iznos]");

	if (!IsPlayerConnected(targetid) || !IsPlayerLoggedIn(targetid))
		return ErrorMsg(playerid, GRESKA_OFFLINE);

	if (money < 1 || money > 10000000)
		return ErrorMsg(playerid, "Iznos mora biti izmedju $1 i $10.000.000.");

	if (PI[playerid][p_banka] < money)
		return ErrorMsg(playerid, "Nemate dovoljno novca u banci.");

	PI[playerid][p_banka] -= money;
	PI[targetid][p_banka] += money;

	SendClientMessageF(targetid, ZELENA2, "(banka) {FFFFFF}Primili ste {00FF00}%s {FFFFFF}od {00FF00}%s.", formatMoneyString(money), ime_rp[playerid]);
	SendClientMessageF(playerid, ZELENA2, "(banka) %s {FFFFFF}je primio Vas transfer u iznosu od {00FF00}%s.", ime_rp[targetid], formatMoneyString(money));
	AdminMsg(ZUTA, "TRANSFER | %s[%d] » %s[%d] | %s", ime_rp[playerid], playerid, ime_rp[targetid], targetid, formatMoneyString(money));

	new sQuery[55];
	format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %i WHERE id = %i", PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery);
	format(sQuery, sizeof sQuery, "UPDATE igraci SET banka = %i WHERE id = %i", PI[targetid][p_banka], PI[targetid][p_id]);
	mysql_tquery(SQL, sQuery);

	new sLog[85];
	format(sLog, sizeof sLog, "(VIP) %s » %s | $%d", ime_obicno[playerid], ime_obicno[targetid], money);
	Log_Write(LOG_TRANSFERI, sLog);
	return 1;
}

CMD:viprefill(playerid, const params[])
{
    if (!IsVIP(playerid, 2)) 
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new cmdLimit = 100;
    if (IsVIP(playerid, 4)) cmdLimit = 100;
    else if (IsVIP(playerid, 3)) cmdLimit = 5;
    else if (IsVIP(playerid, 2)) cmdLimit = 2;

    if (PI[playerid][p_vip_replenish] >= cmdLimit)
        return ErrorMsg(playerid, "Prekoracili ste dnevni limit za koriscenje ove pogodnosti (%i/%i).", cmdLimit, cmdLimit);

    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Niste u vozilu.");

    new vehicleid = GetPlayerVehicleID(playerid);

    RefillVehicle(vehicleid);
    PI[playerid][p_vip_refill] ++;
    SendClientMessageF(playerid, SVETLOPLAVA, "* Vozilo je napunjeno gorivom. (%i/%i)", PI[playerid][p_vip_refill], cmdLimit);

    new query[52];
    format(query, sizeof query, "UPDATE igraci SET vip_refill = %i WHERE id = %i", PI[playerid][p_vip_refill], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    
    // Upisivanje u log
    format(string_128, sizeof string_128, "Komanda: /refill | %s", ime_obicno[playerid]);
    Log_Write(LOG_VIP, string_128);
    return 1;
}

CMD:vip(playerid, const params[])
{
	if (!IsVIP(playerid, 1) || (IsVIP(playerid, 1) && GetPVarInt(playerid, "vipOverride") == 1))
	{
		// Igrac nije VIP -> pokazi mu sta sve dobija
        DeletePVar(playerid, "vipOverride");
		SPD(playerid, "vip_packages", DIALOG_STYLE_LIST, "Izaberite paket", "Bronze\nSilver\nGold\nPlatinum", "Dalje", "Izadji");
	}
    else
    {
        new string[512];
        format(string, sizeof string, "Spisak VIP paketa\nVIP komande");

        if (IsVIP(playerid, 1))
            format(string, sizeof string, "%s\nVIP baza\nTeleport\nGoto\nPopravi vozilo", string);

        if (IsVIP(playerid, 2))
            format(string, sizeof string, "%s\nDopuni vozilo gorivom\nHP na 100%%, glad na 0%%\nUplati Lucky One\nBorilacke vestine", string);

        if (IsVIP(playerid, 3))
            format(string, sizeof string, "%s\nRespawn svog vozila\nGethere\nPrivatna poruka (PM)\nUkljuci/iskljuci PM", string);

        if (IsVIP(playerid, 4))
            format(string, sizeof string, "%s\nPM offline igracu\nPromeni skin\nPromeni spawn\nTeleport svog vozila\nTransfer", string);

        SPD(playerid, "vip", DIALOG_STYLE_LIST, "VIP opcije", string, "Izaberi", "Izadji");
    }
	return 1;
}

CMD:kod(playerid, const params[])
{
	new kod[19];
	if (sscanf(params, "s[19]", kod)) 
		return Koristite(playerid, "kod [Donatorski kod koji ste dobili od head admina]");
	
	// Slanje upita ka bazi
	mysql_escape_string(kod, kod);
	format(mysql_upit, sizeof mysql_upit, "SELECT gold, novac, nivo FROM kodovi WHERE kod = '%s'", kod);
	mysql_tquery(SQL, mysql_upit, "mysql_donator_kod", "isi", playerid, kod, cinc[playerid]);
	
	return 1;
}

CMD:vipfv(playerid, const params[])
{
    if (!IsVIP(playerid, 1))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (GetPVarInt(playerid, "pVIPFvCooldown") > gettime())
        return ErrorMsg(playerid, "Vec ste nedavno popravili vozilo. Pokusajte ponovo za %s.", konvertuj_vreme(GetPVarInt(playerid, "pVIPFvCooldown")-gettime()));

    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Niste u vozilu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
        return ErrorMsg(playerid, "Mozete popraviti samo vozilo kojim upravljate.");

    if (RecentPoliceInteraction(playerid))
        return ErrorMsg(playerid, "Ne mozete koristiti ovu naredbu jer ste nedavno imali kontakt sa policijom.");

    new vehicleid = GetPlayerVehicleID(playerid);
    RepairVehicle(vehicleid);
    SetVehicleHealth(vehicleid, 999.0);
    
    SendClientMessage(playerid, SVETLOPLAVA, "* Vozilo je popravljeno.");

    if (IsVIP(playerid, 4))
    {
        SetPVarInt(playerid, "pVIPFvCooldown", gettime()-1); // Neograniceno za VIP 4
    }
    else if (IsVIP(playerid, 3))
    {
        SetPVarInt(playerid, "pVIPFvCooldown", gettime()+60); // 1 minut za VIP 3
    }
    else if (IsVIP(playerid, 2))
    {
        SetPVarInt(playerid, "pVIPFvCooldown", gettime()+300); // 5 minuta za VIP 2
    }
    else if (IsVIP(playerid, 1))
    {
        SetPVarInt(playerid, "pVIPFvCooldown", gettime()+600); // 10 minuta za VIP 1
    }
    return 1;
}