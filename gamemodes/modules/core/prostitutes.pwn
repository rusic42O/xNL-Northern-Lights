#include <YSI_Coding\y_hooks>

#define MAX_PROSTITUTES (26)

enum E_PROSTITUTES
{
	PROSTITUTE_ID,
    PROSTITUTE_ACTOR_ID,
	PROSTITUTE_AREA_ID,
	PROSTITUTE_SKIN,
    PROSTITUTE_MONEY,
	Float:PROSTITUTE_POS[4],
    PROSTITUTE_NAME[25],
    PROSTITUTE_OWNER_ID,
    PROSTITUTE_OWNER_NAME[MAX_PLAYER_NAME],
    Text3D:PROSTITUTE_LABEL
}
new ProstituteInfo[MAX_PROSTITUTES][E_PROSTITUTES];

hook OnGameModeInit()
{
    mysql_tquery(SQL, "SELECT igraci.ime as vlasnik_ime, prostitutes.* FROM prostitutes LEFT JOIN igraci ON igraci.id = prostitutes.vlasnik", "MySQL_LoadProstitutes");
    return true;
}

hook OnPlayerEnterDynArea(playerid, STREAMER_TAG_AREA:areaid)
{
    for__loop (new i = 0; i < MAX_PROSTITUTES; i++) 
    {
        if (!IsValidProstitute(i)) continue;
		if (areaid == ProstituteInfo[i][PROSTITUTE_AREA_ID]) 
        {
			GameTextForPlayer(playerid, "~y~Prostitutka~n~~w~Koristite tipku ~y~~k~~CONVERSATION_NO~ ~w~da koristite njene usluge.", 3000, 3);
			break;
		}
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

/*hook OnPlayerPickUpDynPickup(playerid, pickupid) 
{
	for__loop (new i = 0; i < MAX_PROSTITUTES; i++) 
    {
        if (!IsValidProstitute(i)) continue;
		if (pickupid == ProstituteInfo[i][PROSTITUTE_AREA_ID]) 
        {
			GameTextForPlayer(playerid, "~y~Prostitutka~n~~w~Koristite tipku ~y~~k~~CONVERSATION_NO~ ~w~da koristite njene usluge.", 3000, 3);
			break;
		}
	}
	return 1;
}*/

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys == KEY_NO)
    {
    	for__loop (new i = 0; i < MAX_PROSTITUTES; i++) 
    	{
            if (!IsValidProstitute(i)) continue;

    		if (IsPlayerInRangeOfPoint(playerid, 2.0, ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2]))
    		{
    			SetPVarInt(playerid, "pBJActor", i);

                if (ProstituteInfo[i][PROSTITUTE_OWNER_ID] == 0)
                {
                    //Nema vlasnika, ponuditi kupovinu
                    SPD(playerid, "prostitute", DIALOG_STYLE_TABLIST, "Spisak usluga", "Recept za heroin\t$2.750\nRecept za MDMA\t$2.750\nLokacija paketa sa sastojcima\t$1.500\nLokacija za pakovanje droge\t$3.000\nProdavnica semena marihuane\t$5.000\nBribe Point (random)\t$3.000\nBlowjob\t$5.000\n---\nUzmi pod zastitu\t$100.000", "Izaberi", "Odustani");
                }
                else
                {
                    if (ProstituteInfo[i][PROSTITUTE_OWNER_ID] == PI[playerid][p_id] || PI[playerid][p_admin] > 5)
                    {
                        //Ovaj igrac je njen makro -> dati mu vise opcija
                        SPD(playerid, "prostitute_owner", DIALOG_STYLE_TABLIST, "Spisak usluga", "Recept za heroin\t$2.750\nRecept za MDMA\t$2.750\nLokacija paketa sa sastojcima\t$1.500\nLokacija za pakovanje droge\t$3.000\nProdavnica semena marihuane\t$5.000\nBribe Point (random)\t$3.000\nBlowjob\t$5.000\n---\nPokupi novac\nPromeni ime\nPrekini zastitu", "Izaberi", "Odustani");
                    }
                    else
                    {
                        //Igrac nije makro, ponuditi mu samo usluge
                        SPD(playerid, "prostitute", DIALOG_STYLE_TABLIST, "Spisak usluga", "Recept za heroin\t$2.750\nRecept za MDMA\t$2.750\nLokacija paketa sa sastojcima\t$1.500\nLokacija za pakovanje droge\t$3.000\nProdavnica semena marihuane\t$5.000\nBribe Point (random)\t$3.000\nBlowjob\t$5.000", "Izaberi", "Odustani");
                    }
                }

    			break;
    		}
    	}
    }
    return 1;
}

stock IsValidProstitute(id)
{
    if (ProstituteInfo[id][PROSTITUTE_ID] == -1) return false;

    return true;
}

stock FormatProstituteLabel(id, _label[], len)
{
    if (ProstituteInfo[id][PROSTITUTE_OWNER_ID] == 0)
    {
        format(_label, len, "Prostitutka #%i", ProstituteInfo[id][PROSTITUTE_ID]);
    }
    else
    {
        //Ima makroa
        format(_label, len, "%s (%i)\n{FFFFFF}Makro: {AF28A4}%s", ProstituteInfo[id][PROSTITUTE_NAME], ProstituteInfo[id][PROSTITUTE_ID], ProstituteInfo[id][PROSTITUTE_OWNER_NAME]);
    }
}

forward Blowjob(playerid, ccinc, actorid, stage);
public Blowjob(playerid, ccinc, actorid, stage)
{
    if (stage == 1)
    {
        ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_START_P", 4.1, 0,1,1,1,1,1);
        ApplyDynamicActorAnimation(actorid, "BLOWJOBZ", "BJ_STAND_START_W", 4.1, 0,1,1,1,1);

        stage = 2;
        SetTimerEx("Blowjob", 2000, false, "iiii", playerid, cinc[playerid], actorid, stage);
        return 1;
    }

    else if (stage == 2)
    {
        ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_LOOP_P", 4.1, 1,1,1,1,1,1);
        ApplyDynamicActorAnimation(actorid, "BLOWJOBZ", "BJ_STAND_LOOP_W", 4.1, 1,1,1,1,1);

        stage = 3;
        SetTimerEx("Blowjob", 8000, false, "iiii", playerid, cinc[playerid], actorid, stage);
        return 1;
    }

    else if (stage == 3)
    {
        ApplyAnimation(playerid, "BLOWJOBZ", "BJ_STAND_END_P", 4.1, 0,1,1,1,1,1);
        ApplyDynamicActorAnimation(actorid, "BLOWJOBZ", "BJ_STAND_END_W", 4.1, 0,1,1,1,1);

        stage = 4;
        SetTimerEx("Blowjob", 4500, false, "iiii", playerid, cinc[playerid], actorid, stage);
        return 1;
    }

    else if (stage == 4)
    {
        ClearAnimations(playerid);
        ClearDynamicActorAnimations(actorid);

        GameTextForPlayer(playerid, "~r~Health - ~g~dopunjen!", 5000, 3);
        SetPlayerHealth(playerid, 100.0);

        stage = 5;
        SetTimerEx("Blowjob", 1500, false, "iiii", playerid, cinc[playerid], actorid, stage);
        return 1;
    }

    else if (stage == 5)
    {
        new pr = GetPVarInt(playerid, "pBJActor");
        SetDynamicActorPos(actorid, ProstituteInfo[pr][PROSTITUTE_POS][0], ProstituteInfo[pr][PROSTITUTE_POS][1], ProstituteInfo[pr][PROSTITUTE_POS][2]);
        SetDynamicActorFacingAngle(actorid, ProstituteInfo[pr][PROSTITUTE_POS][3]);
    }
    return 1;
}

forward MySQL_LoadProstitutes();
public MySQL_LoadProstitutes()
{
    cache_get_row_count(rows);
    if (!rows) return 1;

    new max_i = 0;
    for__loop (new i = 0; i < rows; i++)
    {
        if (i >= MAX_PROSTITUTES)
        {
            printf("[prostitutes.pwn] FATAL ERROR: Dostignut je maksimalan broj prostitutki (MAX_PROSTITUTES)");
            break;
        }

        new pos[40];

        cache_get_value_name_int(i, "id", ProstituteInfo[i][PROSTITUTE_ID]);
        cache_get_value_name_int(i, "skin", ProstituteInfo[i][PROSTITUTE_SKIN]);
        cache_get_value_name_int(i, "vlasnik", ProstituteInfo[i][PROSTITUTE_OWNER_ID]);
        cache_get_value_name_int(i, "zarada", ProstituteInfo[i][PROSTITUTE_MONEY]);
        cache_get_value_name(i, "vlasnik_ime", ProstituteInfo[i][PROSTITUTE_OWNER_NAME], MAX_PLAYER_NAME);
        cache_get_value_name(i, "ime", ProstituteInfo[i][PROSTITUTE_NAME], 25);
        cache_get_value_name(i, "pozicija", pos, sizeof pos);

        sscanf(pos, "p<,>ffff", ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2], ProstituteInfo[i][PROSTITUTE_POS][3]);

        ProstituteInfo[i][PROSTITUTE_ACTOR_ID] = CreateDynamicActor(ProstituteInfo[i][PROSTITUTE_SKIN], ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2], ProstituteInfo[i][PROSTITUTE_POS][3], .worldid = 0);

        ApplyDynamicActorAnimation(ProstituteInfo[i][PROSTITUTE_ACTOR_ID], "GANGS","leanIDLE",4.0,0,1,1,1,0);

        SetDynamicActorPos(ProstituteInfo[i][PROSTITUTE_ACTOR_ID], ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2]);
        SetDynamicActorFacingAngle(ProstituteInfo[i][PROSTITUTE_ACTOR_ID], ProstituteInfo[i][PROSTITUTE_POS][3]);

        ProstituteInfo[i][PROSTITUTE_AREA_ID] = CreateDynamicSphere(ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2], 4.0); //CreateDynamicPickup(19300, 2, ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2]);

        CreateDynamicMapIcon(ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2], 12, BELA, 0, 0);

        new labelStr[120];
        FormatProstituteLabel(i, labelStr, sizeof labelStr);
        ProstituteInfo[i][PROSTITUTE_LABEL] = CreateDynamic3DTextLabel(labelStr, 0xAF28A4FF, ProstituteInfo[i][PROSTITUTE_POS][0], ProstituteInfo[i][PROSTITUTE_POS][1], ProstituteInfo[i][PROSTITUTE_POS][2]+1.0, 15.0);

        max_i = i;
    }

    //Sve one koje nisu kreirane posstavlja im id na -1
    for__loop (new i = MAX_PROSTITUTES-1; i > max_i; i--)
    {
        ProstituteInfo[i][PROSTITUTE_ID] = -1;
    }
    return 1;
}

Dialog:prostitute(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

    new pr = GetPVarInt(playerid, "pBJActor");

	if (listitem == 0) // Recept za heroin
	{
		if (PI[playerid][p_novac] < 2750)
			return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

		PlayerMoneySub(playerid, 2750);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 2750;

		SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Recept za heroin", "{FFFFFF}Na ovom papiricu je zapisan recept za izradu {FF0000}1g heroina. {FFFFFF}Dobro ga zapamti!\n\n- Morfin {00FF00}30g\n{FFFFFF}- Acetanhidrid {00FF00}10g\n{FFFFFF}- Hloroform {00FF00}10g\n{FFFFFF}- Destilovana voda {00FF00}500ml\n{FFFFFF}- Alkohol {00FF00}100ml", "OK", "");
	}

	else if (listitem == 1) // Recept za MDMA
	{
		if (PI[playerid][p_novac] < 2750)
			return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

		PlayerMoneySub(playerid, 2750);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 2750;

		SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Recept za MDMA", "{FFFFFF}Na ovom papiricu je zapisan recept za izradu {FF0000}1g MDMA. {FFFFFF}Dobro ga zapamti!\n\n- Safrol {FFFF00}10g\n{FFFFFF}- Bromopropan {FFFF00}30g\n{FFFFFF}- Metilamin {FFFF00}20g\n{FFFFFF}- Destilovana voda {FFFF00}500ml", "OK", "");
	}

	else if (listitem == 2) // Lokacija paketa sa sastojcima
	{
		if (PI[playerid][p_novac] < 1500)
			return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

		PlayerMoneySub(playerid, 1500);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 1500;

		new Float:x, Float:y, Float:z;
		DRUGS_RandomDropLocation(x, y, z);
		SetGPSLocation(playerid, x, y, z, "lokacija paketa sa sastojcima");
	}

    else if (listitem == 3) // Pakovanje droge
    {
        if (PI[playerid][p_novac] < 3000)
            return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

        PlayerMoneySub(playerid, 3000);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 3000;

        SetGPSLocation(playerid, 891.7536,-27.6224,63.3120, "lokacija za pakovanje droge");
    }

    else if (listitem == 4) // Prodavnica semena marihuane
    {
        if (PI[playerid][p_novac] < 5000)
            return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

        PlayerMoneySub(playerid, 5000);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 5000;

        SetGPSLocation(playerid, 870.2025,-25.2336,63.9688, "prodavnica semena");
    }

    else if (listitem == 5) // Bribe Point
    {
        if (PI[playerid][p_novac] < 3000)
            return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");
        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);

        PlayerMoneySub(playerid, 3000);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 3000;

        new Float:x, Float:y, Float:z;
        GetRandomBribePoint(x, y, z);
        SetGPSLocation(playerid, x, y, z, "Bribe Point (random)");
    }

	else if (listitem == 6) // Blowjob
	{
		if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
			return ErrorMsg(playerid, "Morate biti van vozila i stajati pored prostitutke.");

		if (PI[playerid][p_novac] < 5000)
			return ErrorMsg(playerid, "Nemate dovoljno novca za ovu uslugu.");

        if(PI[playerid][p_provedeno_vreme] < 10) return ErrorMsg(playerid, "Nemate dovoljno sati da bi kupili ovo [%d/10]", PI[playerid][p_provedeno_vreme]/3600);
        
		PlayerMoneySub(playerid, 5000);
        ProstituteInfo[pr][PROSTITUTE_MONEY] += 5000;

		new actorid = ProstituteInfo[pr][PROSTITUTE_ACTOR_ID];

		//Okretanje prostitutke ka igracu
		new Float:Px, Float:Py, Float: Pa;
		new Float:x,Float:y,Float:z;
		GetPlayerPos(playerid, x, y, z);
		GetDynamicActorPos(actorid, Px, Py, Pa);
		Pa = floatabs(atan((y-Py)/(x-Px)));
		if (x <= Px && y >= Py) Pa = floatsub(180, Pa);
		else if (x < Px && y < Py) Pa = floatadd(Pa, 180);
		else if (x >= Px && y <= Py) Pa = floatsub(360.0, Pa);
		Pa = floatsub(Pa, 90.0);
		if (Pa >= 360.0) Pa = floatsub(Pa, 360.0);

		SetDynamicActorFacingAngle(actorid, Pa);

		new stage = 1;
		SetTimerEx("Blowjob", 1500, false, "iiii", playerid, cinc[playerid], actorid, stage);
	}

    else if (listitem == 7) // ---
    {
        DialogReopen(playerid);
    }

    else if (listitem == 8) // Uzmi pod zastitu
    {
        if (ProstituteInfo[pr][PROSTITUTE_OWNER_ID] != 0)
            return ErrorMsg(playerid, "Ova prostitutka vec ima svog makroa.");

        if (PI[playerid][p_novac] < 100000)
            return ErrorMsg(playerid, "Nemate dovoljno novca.");

        PlayerMoneySub(playerid, 100000);
        ProstituteInfo[pr][PROSTITUTE_OWNER_ID] = PI[playerid][p_id];
        ProstituteInfo[pr][PROSTITUTE_MONEY] = 0;
        format(ProstituteInfo[pr][PROSTITUTE_OWNER_NAME], MAX_PLAYER_NAME, "%s", ime_obicno[playerid]);

        new labelStr[120];
        FormatProstituteLabel(pr, labelStr, sizeof labelStr);
        UpdateDynamic3DTextLabelText(ProstituteInfo[pr][PROSTITUTE_LABEL], 0xAF28A4FF, labelStr);

        SendClientMessage(playerid, 0xAF28A4FF, "* Ova prostitutka je sada pod Vasom zastitom. Dobijacete sav novac koji ona zaradi.");

        //Update podataka u bazi
        new query[128];
        format(query, sizeof query, "UPDATE `prostitutes` SET `vlasnik` = %i, `vlasnik_ime` = '%s', `zarada` = 0 WHERE `id` = %i", PI[playerid][p_id], ProstituteInfo[pr][PROSTITUTE_OWNER_NAME], ProstituteInfo[pr][PROSTITUTE_ID]);
        mysql_tquery(SQL, query);

        //Upisivanje u log
        new logStr[53];
        format(logStr, sizeof logStr, "KUPOVINA | %s | ID: %i", ime_obicno[playerid], ProstituteInfo[pr][PROSTITUTE_ID]);
        Log_Write(LOG_PROSTITUTES, logStr);
    }

    if (listitem <= 6)
    {
        //Update para za koriscenje usluga ako prostitutka ima vlasnika
        if (ProstituteInfo[pr][PROSTITUTE_OWNER_ID] != 0)
        {
            new query[58];
            format(query, sizeof query, "UPDATE prostitutes SET zarada = %i WHERE id = %i", ProstituteInfo[pr][PROSTITUTE_MONEY], ProstituteInfo[pr][PROSTITUTE_ID]);
            mysql_tquery(SQL, query);
        }
        else
        {
            //Resetovanje para ako nema vlasnika
            ProstituteInfo[pr][PROSTITUTE_MONEY] = 0;
        }
    }
	return 1;
}

Dialog:prostitute_owner(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;
    if (listitem <= 6) return dialog_respond:prostitute(playerid, response, listitem, inputtext);
    else
    {
        new pr = GetPVarInt(playerid, "pBJActor");

        if (ProstituteInfo[pr][PROSTITUTE_OWNER_ID] != PI[playerid][p_id])
            return ErrorMsg(playerid, "Ova prostitutka nije pod Vasom zastitom.");

        if (listitem == 8) // Pokupi novac
        {
            if (ProstituteInfo[pr][PROSTITUTE_MONEY] <= 0)
                return ErrorMsg(playerid, "Prostitutka nije uspela nista da zaradi od proslog puta!");

            new take = ProstituteInfo[pr][PROSTITUTE_MONEY];
            PlayerMoneyAdd(playerid, take);
            ProstituteInfo[pr][PROSTITUTE_MONEY] = 0;

            SendClientMessageF(playerid, LJUBICASTA, "* Preuzeli ste %s od prostitutke koju stitite.", formatMoneyString(take));

            //Update podataka u bazi
            new query[52];
            format(query, sizeof query, "UPDATE prostitutes SET zarada = 0 WHERE id = %i", ProstituteInfo[pr][PROSTITUTE_ID]);
            mysql_tquery(SQL, query);

            //Upisivanje u log
            new logStr[65];
            format(logStr, sizeof logStr, "ZARADA | %s | $%i | ID: %i", ime_obicno[playerid], take, ProstituteInfo[pr][PROSTITUTE_ID]);
            Log_Write(LOG_PROSTITUTES, logStr);
        }
        else if (listitem == 9) // Promeni ime
        {
            new dStr[112];
            format(dStr, sizeof dStr, "{FFFFFF}Trenutno ime: {AF28A4}%s\n\n{FFFFFF}Unesite novo ime ove prostitutke:", ProstituteInfo[pr][PROSTITUTE_NAME]);
            SPD(playerid, "prostitute_name", DIALOG_STYLE_INPUT, "Promena imena", dStr, "Promeni", "Odustani");
        }
        else if (listitem == 10) // Prekini zastitu
        {
            SPD(playerid, "prostitute_leave", DIALOG_STYLE_MSGBOX, "Prekini zastitu", "{FFFFFF}Prekidanjem zastite necete dobiti ulozeni novac natrag.", "Potvrdi", "Odustani");
        }
    }
    return 1;
}

Dialog:prostitute_name(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (isnull(inputtext))
        return DialogReopen(playerid);

    if (strlen(inputtext) > 25)
    {
        ErrorMsg(playerid, "Uneto ime je previse dugacko (do 25 slova).");
        return DialogReopen(playerid);
    }

    if (strlen(inputtext) < 3)
    {
        ErrorMsg(playerid, "Uneto ime je previse kratko (minimum 3 slova).");
        return DialogReopen(playerid);
    }

    new pr = GetPVarInt(playerid, "pBJActor");

    new query[128];
    format(ProstituteInfo[pr][PROSTITUTE_NAME], 25, "%s", inputtext);
    mysql_format(SQL, query, sizeof query, "UPDATE prostitutes SET ime = '%s' WHERE id = %i", ProstituteInfo[pr][PROSTITUTE_NAME], ProstituteInfo[pr][PROSTITUTE_ID]);
    mysql_tquery(SQL, query);

    new labelStr[120];
    FormatProstituteLabel(pr, labelStr, sizeof labelStr);
    UpdateDynamic3DTextLabelText(ProstituteInfo[pr][PROSTITUTE_LABEL], 0xAF28A4FF, labelStr);

    SendClientMessage(playerid, LJUBICASTA, "* Ime je uspesno promenjeno.");
    return 1;
}

Dialog:prostitute_leave(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new pr = GetPVarInt(playerid, "pBJActor");

    ProstituteInfo[pr][PROSTITUTE_MONEY] = 0;
    ProstituteInfo[pr][PROSTITUTE_OWNER_ID] = 0;
    format(ProstituteInfo[pr][PROSTITUTE_NAME], 25, "Prostitutka");
    format(ProstituteInfo[pr][PROSTITUTE_OWNER_NAME], MAX_PLAYER_NAME, "Niko");

    new labelStr[120];
    FormatProstituteLabel(pr, labelStr, sizeof labelStr);
    UpdateDynamic3DTextLabelText(ProstituteInfo[pr][PROSTITUTE_LABEL], 0xAF28A4FF, labelStr);

    new query[89];
    format(query, sizeof query, "UPDATE prostitutes SET vlasnik = 0, zarada = 0, ime = 'Prostitutka' WHERE id = %i", ProstituteInfo[pr][PROSTITUTE_ID]);
    mysql_tquery(SQL, query);

    return 1;
}
