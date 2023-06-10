#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define BROJ_BANKOMATA			34

#define ATM_PIN                 (1)
#define ATM_NISTA 				(2)
#define ATM_SALDO 				(3)
#define ATM_DEPOZIT 			(4)
#define ATM_PODIGNI 			(5)
#define ATM_KARTICA             (6)
#define ATM_TRANSFER            (7)





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_ATM_INFO
{
	Float:atmPos[3],
	atmPickup,
	atmRobberyCooldown,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new ATMInfo[BROJ_BANKOMATA][E_ATM_INFO] = 
{
	{{1701.58972168, -1907.92907715,	13.21273708}, 	-1, 0},
    {{1790.08850098, -1881.94299316,	13.21152306}, 	-1, 0},
    {{1144.17175293, -1840.15991211,	13.23255730}, 	-1, 0},
    {{360.60089111,	 -1802.92041016,	4.388810166}, 	-1, 0},
    {{996.83526611,	 -1820.26147461,	13.43389034}, 	-1, 0},
    {{1102.18041992, -1460.67675781,	15.43977451}, 	-1, 0},
    {{1416.06921387, -1658.46301270,	13.18977451}, 	-1, 0},
    {{411.88787842,	 -1504.86962891,	31.13644409}, 	-1, 0},
    {{826.10601807,	 -1385.39916992,	13.20907784}, 	-1, 0},
    {{1494.10913086, -1310.54187012,	13.56274033}, 	-1, 0},
    {{2235.52148438, -1666.83276367,	14.94258308}, 	-1, 0},
    {{1945.73950195, -2176.16503906,	13.19710827}, 	-1, 0},
    {{2714.10351562, -1880.09875488,	10.69758701}, 	-1, 0},
    {{2836.07324219, -1565.48876953,	10.73664951}, 	-1, 0},
    {{2668.67578125, -1095.91540527,	69.03177643}, 	-1, 0},
    {{1333.02514648, -1291.51000977,	13.18977451}, 	-1, 0},
    {{1936.59277344, 2155.99951172,		10.46321201}, 	-1, 0},
    {{-256.36203003, 2605.83935547,		62.50105286}, 	-1, 0},
    {{-1428.6342773, 2591.64501953,		55.47883606}, 	-1, 0},
    {{-2476.8417969, 2251.35766602,		4.62727451}, 	-1, 0},
    {{-1980.6123047, 131.93641663,		27.33039856}, 	-1, 0},
    {{-2420.1794434, 987.90417480,		44.93977356}, 	-1, 0},
    {{-1964.8881836, 1190.41088867,		45.08821106}, 	-1, 0},
    {{-81.44303894,	-1184.33154297,		1.39289951}, 	-1, 0},
    {{661.36816406,	-556.32757568,		15.97883701}, 	-1, 0},
    {{1495.600585,  -1022.164306,       23.454820}, 	-1, 0}, // Banka 1
    {{1428.500366,  -1022.164306,       23.454820}, 	-1, 0}, // Banka 2
    {{1832.404785, 	-1425.786621, 		13.216286}, 	-1, 0}, // tech store
    {{1647.351196, 	-1276.750000, 		14.398973}, 	-1, 0}, // spawn 
    {{1102.318725, 	-1688.109863, 		13.187642}, 	-1, 0}, // Auto skola
    {{1921.447753, 	-1765.868530, 		13.191584}, 	-1, 0}, // Benzinska Idlewood
    {{1207.302124,  -919.807312,        42.806499},     -1, 0}, // Burg
    {{1464.683715,  -1773.892700,       15.048965},     -1, 0}, // Opstina
    {{930.665588,   -1728.499145,       13.176138},     -1, 0} // Auto salon
};





// ========================================================================== //
//                      <section> Callback-ovi </section>                     //
// ========================================================================== //
hook OnGameModeInit() 
{
	for__loop (new i = 0; i < sizeof(ATMInfo); i++) 
		ATMInfo[i][atmPickup] = CreateDynamicPickup(19300, 2, ATMInfo[i][atmPos][0], ATMInfo[i][atmPos][1], ATMInfo[i][atmPos][2]);
	
	return 1;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid) 
{
	for__loop (new i = 0; i < sizeof(ATMInfo); i++) 
    {
		if (pickupid == ATMInfo[i][atmPickup]) 
        {
			GameTextForPlayer(playerid, "~n~~n~~n~~b~/bankomat", 2000, 3);
			break;
		}
	}
	return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if (GetPVarInt(playerid, "pATMStatus") >= 1)
    {
        new pressedNumber = -1;
        if (GetPVarInt(playerid, "pATMStatus") != ATM_NISTA)
        {
            if (clickedid >= tdATM[15] && clickedid <= tdATM[24])
            {
                pressedNumber = _:clickedid - _:tdATM[15]; // daje broj iz opsega 0-9
            }

            if (pressedNumber != -1)
            {
                // Igrac je pritisnuo neki broj, zabeleziti uneti pin

                if (GetPVarInt(playerid, "pATMInput") == 0)
                {
                    if (pressedNumber == 0)
                        return 1;

                    UpdatePVarInt(playerid, "pATMInput", pressedNumber);
                }
                else if (GetPVarInt(playerid, "pATMInput") > 0 && GetPVarInt(playerid, "pATMInput") <= 99999999)
                {
                    SetPVarInt(playerid, "pATMInput", GetPVarInt(playerid, "pATMInput")*10 + pressedNumber);
                }
            }
            if (clickedid == tdATM[30]) // Izbrisi
            {
                if (GetPVarInt(playerid, "pATMInput") > 0 && GetPVarInt(playerid, "pATMInput") <= 9)
                {
                    SetPVarInt(playerid, "pATMInput", 0);
                }
                else if (GetPVarInt(playerid, "pATMInput") > 9)
                {
                    SetPVarInt(playerid, "pATMInput", floatround(GetPVarInt(playerid, "pATMInput")/10, floatround_floor));
                }
            }
            else if (clickedid == tdATM[31]) // Odustani
            {
                ATM_PlayerCancel(playerid);
                return 1;
            }



            // Izmena broja u polju
            if (pressedNumber != -1 || clickedid == tdATM[30])
            {
                new numStr[15];
                if (GetPVarInt(playerid, "pATMInput") > 0)
                {
                    format(numStr, sizeof numStr, "%i", GetPVarInt(playerid, "pATMInput"));
                }
                else
                {
                    format(numStr, sizeof numStr, "_");
                }
                PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][3], numStr);
                PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][3]);
            }



            if (GetPVarInt(playerid, "pATMStatus") == ATM_PIN)
            {
                if (pressedNumber == -1)
                {
                    // Ekran za unosenje pin-a, ali igrac nije pritisnuo broj, vec neki drugi taster
                    if (clickedid == tdATM[29]) // Potvrdi
                    {
                        if (GetPVarInt(playerid, "pATMInput") < 1000 || GetPVarInt(playerid, "pATMInput") > 9999)
                        {
                            return ptdATM_ShowError(playerid, "PIN mora sadrzati 4 cifre.");
                        }

                        if (GetPVarInt(playerid, "pATMInput") != PI[playerid][p_kartica_pin])
                        {
                            return ptdATM_ShowError(playerid, "Uneli ste pogresan PIN.");
                        }
                        else
                        {

                            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][1], "<-- odaberite radnju -->");
                            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);

                            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][3], "_");
                            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][3]);

                            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][0]);

                            SetPVarInt(playerid, "pATMStatus", ATM_NISTA);
                            SetPVarInt(playerid, "pATMInput", 0);
                            return 1;
                        }
                    }
                }
            }

            else if (GetPVarInt(playerid, "pATMStatus") == ATM_PODIGNI)
            {
                if (clickedid == tdATM[29]) // Potvrdi
                {
                    if (GetPVarInt(playerid, "pATMInput") > 0)
                    {
                        if (GetPVarInt(playerid, "pATMInput") > 100000)
                        {
                            return ptdATM_ShowError(playerid, "Mozete podici najvise $100.000.");
                        }

                        if (PI[playerid][p_banka] < GetPVarInt(playerid, "pATMInput"))
                        {
                            return ptdATM_ShowError(playerid, "Nemate toliko novca na racunu.");
                        }

                        if ((PI[playerid][p_banka]+GetPVarInt(playerid, "pATMInput")) > 999999999)
                        {
                            return ptdATM_ShowError(playerid, "Mozete drzati najvise $999.999.999 u banci.");
                        }

                        PI[playerid][p_banka] -= GetPVarInt(playerid, "pATMInput");
                        PlayerMoneyAdd(playerid, GetPVarInt(playerid, "pATMInput"));

                        new query[60];
                        format(query, sizeof query, "UPDATE igraci SET banka = %i WHERE id = %i", PI[playerid][p_banka], PI[playerid][p_id]);
                        mysql_tquery(SQL, query);
                    }
                    else 
                    {
                        return ptdATM_ShowError(playerid, "Unesite iznos za podizanje.");
                    }
                }
            }

            else if (GetPVarInt(playerid, "pATMStatus") == ATM_DEPOZIT)
            {
                if (clickedid == tdATM[29]) // Potvrdi
                {
                    if (GetPVarInt(playerid, "pATMInput") > 0)
                    {
                        if (GetPVarInt(playerid, "pATMInput") > 100000)
                        {
                            return ptdATM_ShowError(playerid, "Mozete uplatiti najvise $100.000.");
                        }

                        if (PI[playerid][p_novac] < GetPVarInt(playerid, "pATMInput"))
                        {
                            return ptdATM_ShowError(playerid, "Nemate toliko novca kod sebe.");
                        }

                        if ((PI[playerid][p_novac]+GetPVarInt(playerid, "pATMInput")) > 99999999)
                        {
                            return ptdATM_ShowError(playerid, "Mozete nositi najvise $99.999.999 u rukama.");
                        }

                        PI[playerid][p_banka] += GetPVarInt(playerid, "pATMInput");
                        PlayerMoneySub(playerid, GetPVarInt(playerid, "pATMInput"));

                        new query[60];
                        format(query, sizeof query, "UPDATE igraci SET banka = %i WHERE id = %i", PI[playerid][p_banka], PI[playerid][p_id]);
                        mysql_tquery(SQL, query);
                    }
                    else 
                    {
                        return ptdATM_ShowError(playerid, "Unesite iznos za uplatu.");
                    }
                }
            }
        }


        if (clickedid == tdATM[32])
        {
            // [ PODIGNI ]
            SetPVarInt(playerid, "pATMStatus", ATM_PODIGNI);

            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][1], "Podizanje novca sa kartice");
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][2], "Upisite cifru koju zelite da podignete:");
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][2]);
        }
        else if (clickedid == tdATM[33])
        {
            // [ UPLATI ]
            SetPVarInt(playerid, "pATMStatus", ATM_DEPOZIT);

            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][1], "Uplata novca na racun");
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][2], "Upisite cifru koju zelite da uplatite:");
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][2]);
        }
        else if (clickedid == tdATM[34])
        {
            // [ TRANSFER ]
            SetPVarInt(playerid, "pATMStatus", ATM_TRANSFER);
        }
        else if (clickedid == tdATM[35])
        {
            // [ SALDO ]
            SetPVarInt(playerid, "pATMStatus", ATM_SALDO);
            ptdATM_DisplayBalance(playerid);
        }
        else if (clickedid == tdATM[36])
        {
            // [ KARTICA ]
            SetPVarInt(playerid, "pATMStatus", ATM_KARTICA);

            new str[100];
            format(str, sizeof str, "Tip kartice: %s~n~PIN kod: %d~n~~n~Mozete promeniti PIN.", PI[playerid][p_kartica], PI[playerid][p_kartica_pin]);
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][1], str);
            PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdATM][2], "Upisite novi PIN kod:");
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][1]);
            PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdATM][2]);
        }
        

        else if (clickedid == tdATM[25])
        {
            ATM_PlayerCancel(playerid);
        }
    }

    return 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward IsPlayerNearATM(playerid);
public IsPlayerNearATM(playerid)
{
	for__loop (new i = 0; i < sizeof(ATMInfo); i++) 
	{
		if (IsPlayerInRangeOfPoint(playerid, 3.0, ATMInfo[i][atmPos][0], ATMInfo[i][atmPos][1], ATMInfo[i][atmPos][2]))
		{
			// Vraca ID koji je za 1 veci od stvarnog, pa se na prijemu taj ID mora umanjiti za 1
			return i+1;
		}
	}
	return 0;
}

stock ATM_PlayerCancel(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("ATM_PlayerCancel");
    }

    if (GetPVarInt(playerid, "pATMStatus") > 0)
    {
        ptdATM_Destroy(playerid);
        for__loop (new i = 0; i < sizeof tdATM; i++) 
        {
            TextDrawHideForPlayer(playerid, tdATM[i]);
        }
        DeletePVar(playerid, "pATMStatus");
        CancelSelectTextDraw(playerid);

        ShowMainGuiTD(playerid, true);
    }
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
alias:bankomat("atm")

CMD:bankomat(playerid, const params[]) 
{
	if (!IsPlayerNearATM(playerid)) 
		return ErrorMsg(playerid, "Ne nalazite se blizu bankomata.");
    
    if(PI[playerid][p_wanted_level] > 0) return ErrorMsg(playerid, "Vi ste na listi trazenih, sve vase kartice su blokirane.");
	
	if (IsPlayerInAnyVehicle(playerid)) 
		return ErrorMsg(playerid, "Morate izaci iz vozila da biste mogli da koristite bankomat.");
	
	if (!strcmp(PI[playerid][p_kartica], "N/A")) 
		return ErrorMsg(playerid, "Nemate kreditnu karticu, izvadite je u banci.");

    if (GetPVarInt(playerid, "pUCP") != 0)
        return ErrorMsg(playerid, "Ne mozete koristiti bankomat dok je otvoren UCP.");
	
    ShowMainGuiTD(playerid, false);
    ptdATM_Create(playerid);
    for (new i = 0; i < sizeof(tdATM); i++)
    {
        TextDrawShowForPlayer(playerid, tdATM[i]);
    }

    SetPVarInt(playerid, "pATMInput", 0);
    SetPVarInt(playerid, "pATMStatus", ATM_PIN);
    SelectTextDraw(playerid, 0xFF0000FF);
    
    format(string_128, sizeof string_128, "** %s vadi svoju %s karticu i ubacuje je u bankomat.", ime_rp[playerid], PI[playerid][p_kartica]);
    RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
    ClearChatForPlayer(playerid);
    return 1;
}

CMD:atmloc(playerid, const params[])
{
    if (!IsACop(playerid))
    	return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new atm, str[15];
    if (sscanf(params, "i", atm))
    	return Koristite(playerid, "atmloc [ID bankomata]");

    if (atm < 1 || atm > sizeof(ATMInfo))
    	return ErrorMsg(playerid, "ID bankomata mora biti izmedju 1 i %i.", sizeof ATMInfo);

    format(str, sizeof str, "Bankomat #%02d", atm);
    atm--; // Uneta vrednost je za 1 veca od stvarnog ID-a bankomata, pa umanjujemo za 1.
    SetGPSLocation(playerid, ATMInfo[atm][atmPos][0], ATMInfo[atm][atmPos][1], ATMInfo[atm][atmPos][2], str);
    return 1;
}