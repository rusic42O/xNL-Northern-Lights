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





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
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
Dialog:setstats1(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (!IsAdmin(playerid, 5))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new id = GetPVarInt(playerid, "pSetStatsID");
    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    new string[240];
    SetPVarString(playerid, "pSetStatsField", inputtext);
    format(string, sizeof string, "{FFFFFF}Igrac: {FF0000}%s [%i]\n{FFFFFF}Polje: {FF0000}%s\n\n{FFFFFF}Upisite novu vrednost za ovo polje:", ime_rp[id], id, inputtext);

    if (!strcmp(inputtext, "org_kazna"))
    {
        format(string, sizeof string, "%s\n{FF6347}Unos mora biti u formatu: {FF0000}YYYY-MM-DD hh:mm:ss", string);
    }
    else if (!strcmp(inputtext, "provedeno_vreme"))
    {
        format(string, sizeof string, "%s\n{FF6347}Unos mora biti celobrojna vrednost. Npr {FF0000}40 {FF6347}sati", string);
    }

    SPD(playerid, "setstats2", DIALOG_STYLE_INPUT, ime_rp[id], string, "Promeni", "Nazad");
    return 1;
}

Dialog:setstats2(playerid, response, listitem, const inputtext[])
{
    if (!IsAdmin(playerid, 5))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    new id = GetPVarInt(playerid, "pSetStatsID");
    if (!IsPlayerConnected(id))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!response)
    {
        new params[5];
        format(params, sizeof params, "%i", id);
        DeletePVar(playerid, "pSetStatsID");
        DeletePVar(playerid, "pSetStatsField");
        return callcmd::setstats(playerid, params);
    }

    if (isnull(inputtext))
        return DialogReopen(playerid);

    new field[16],
        value = strval(inputtext),
        valueStr[24];
    GetPVarString(playerid, "pSetStatsField", field, sizeof field);

    if (!strcmp(field, "nivo"))
    {
        if (value < 1 || value > 255)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 1 i 255.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_nivo] = value;
            SetPlayerScore(id, PI[id][p_nivo]);
        }
    }
    else if (!strcmp(field, "org_id"))
    {
        if (value < -1 || value >= GetMaxFactions())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", GetMaxFactions());
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_org_id] = value;   
        }
    }
    else if (!strcmp(field, "org_vreme"))
    {
        if (value < 0 || value > 16777215)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 16777215.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_org_vreme] = value;   
        }
    }
    else if (!strcmp(field, "org_kazna"))
    {
        SendClientMessage(playerid, CRVENA, "Igrac se mora relogovati da bi ova izmena imala efekat!");
    }
    else if (!strcmp(field, "novac"))
    {
        if (value < -9999999 || value > 99999999)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -9999999 i 99999999.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_novac] = value;
            GivePlayerMoney(id, -GetPlayerMoney(id)+PI[id][p_novac]);
        }
    }
    else if (!strcmp(field, "banka"))
    {
        if (value < -9999999 || value > 99999999)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -9999999 i 99999999.");
            return DialogReopen(playerid);
        }
        else
        {
            BankMoneyAdd(id, value);
        }
    }
    else if (!strcmp(field, "gold"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_zlato] = value;
        }
    }
    else if (!strcmp(field, "iskustvo"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_iskustvo] = value;   
        }
    }
    else if (!strcmp(field, "payday"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_payday] = value;   
        }
    }
    else if (!strcmp(field, "kartica"))
    {
        format(PI[id][p_kartica], 17, "%s", inputtext);
    }
    else if (!strcmp(field, "kartica_pin"))
    {
        if (value < 0 || value > 16777215)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 16777215.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_kartica_pin] = value;   
        }
    }
    else if (!strcmp(field, "kredit_iznos"))
    {
        if (value < 0 || value > 16777215)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 16777215.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_kredit_iznos] = value;   
        }
    }
    else if (!strcmp(field, "kredit_otplata"))
    {
        if (value < 0 || value > 16777215)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 16777215.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_kredit_otplata] = value;   
        }
    }
    else if (!strcmp(field, "kredit_rata"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_kredit_rata] = value;   
        }
    }
    else if (!strcmp(field, "mobilni"))
    {
        format(PI[id][p_mobilni], 13, "%s", inputtext);
    }
    else if (!strcmp(field, "sim"))
    {
        format(PI[id][p_sim], 11, "%s", inputtext);
    }
    else if (!strcmp(field, "sim_broj"))
    {
        if (value < 0 || value > 16777215)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 16777215.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_sim_broj] = value;   
        }
    }
    else if (!strcmp(field, "sim_kredit"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_sim_kredit] = value;   
        }
    }
    else if (!strcmp(field, "pol"))
    {
        if (value != 0 && value != 1)
        {
            ErrorMsg(playerid, "Unesite vrednost 0 ili 1.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_pol] = value;   
        }
    }
    else if (!strcmp(field, "starost"))
    {
        if (value < 12 || value > 90)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 12 i 90.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_starost] = value;   
        }
    }
    else if (!strcmp(field, "drzava"))
    {
        format(PI[id][p_drzava], 11, "%s", inputtext);
    }
    else if (!strcmp(field, "glad"))
    {
        if (value < 0 || value > 100)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 100.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_glad] = value;   
        }
    }
    else if (!strcmp(field, "kaznjen_puta"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_kaznjen_puta] = value;   
        }
    }
    else if (!strcmp(field, "uhapsen_puta"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_uhapsen_puta] = value;   
        }
    }
    else if (!strcmp(field, "opomene"))
    {
        if (value < 0 || value > 5)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 5.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_opomene] = value;   
        }
    }
    else if (!strcmp(field, "kuca"))
    {
        if (value < -1 || value > RE_GetMaxID_House())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_House());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][kuca] = value;   
        }
    }
    else if (!strcmp(field, "stan"))
    {
        if (value < -1 || value > RE_GetMaxID_Apartment())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_Apartment());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][stan] = value;   
        }
    }
    else if (!strcmp(field, "firma"))
    {
        if (value < -1 || value > RE_GetMaxID_Business())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_Business());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][firma] = value;   
        }
    }
    else if (!strcmp(field, "garaza"))
    {
        if (value < -1 || value > RE_GetMaxID_Garage())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_Garage());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][garaza] = value;   
        }
    }
    else if (!strcmp(field, "vikendica"))
    {
        if (value < -1 || value > RE_GetMaxID_Cottage())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_Cottage());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][vikendica] = value;   
        }
    }
    else if (!strcmp(field, "hotel"))
    {
        if (value < -1 || value > RE_GetMaxID_Hotel())
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju -1 i %i.", RE_GetMaxID_Hotel());
            return DialogReopen(playerid);
        }
        else
        {
            pRealEstate[id][hotel] = value;   
        }
    }
    else if (!strcmp(field, "war_ubistva"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_war_ubistva] = value;   
        }
    }
    else if (!strcmp(field, "war_smrti"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_war_smrti] = value;   
        }
    }
    else if (!strcmp(field, "war_samoubistva"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_war_samoubistva] = value;   
        }
    }
    else if (!strcmp(field, "bombe"))
    {
        new m,s,v;
        if (sscanf(inputtext, "p<|>iii", m, s, v))
        {
            ErrorMsg(playerid, "Unos mora biti u formatu X|Y|Z (X, Y, Z su celi brojevi).");
            return DialogReopen(playerid);
        }
        PI[id][p_bomba][0] = m;
        PI[id][p_bomba][1] = s;
        PI[id][p_bomba][2] = v;
    }
    else if (!strcmp(field, "skill_criminal"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_skill_criminal] = value;   
        }
    }
    else if (!strcmp(field, "skill_cop"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_skill_cop] = value;   
        }
    }
    else if (!strcmp(field, "division_points"))
    {
        if (value < 0 || value > 65535)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 0 i 65535.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_division_points] = value;   
            PI[id][p_division_treshold_up] = floatround(value/100.0, floatround_ceil)*100;
            PI[id][p_division_treshold_dn] = PI[id][p_division_treshold_up] - GetDivisionDropTolerance();

            new sQuery1[110];
            mysql_format(SQL, sQuery1, sizeof sQuery1, "UPDATE igraci SET division_treshold_up = %i, division_treshold_dn = %i WHERE id = %d", PI[id][p_division_treshold_up], PI[id][p_division_treshold_dn], PI[id][p_id]);
            mysql_tquery(SQL, sQuery1);
        }
    }
    else if (!strcmp(field, "vozila_slotovi"))
    {
        if (value < 1 || value > 6)
        {
            ErrorMsg(playerid, "Unesite vrednost izmedju 1 i 6.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_vozila_slotovi] = value;   
        }
    }
    else if (!strcmp(field, "imanja_slotovi"))
    {
        if (value < 1 || value > 2)
        {
            // ErrorMsg(playerid, "Unesite vrednost izmedju 1 i 2.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_imanja_slotovi] = value;   
        }
    }
    else if (!strcmp(field, "boja_imena"))
    {
        if (isnull(inputtext) || strlen(inputtext) != 10)
            return DialogReopen(playerid);

        PI[id][p_boja_imena] = HexToInt(inputtext);
        SetPlayerColor(id, PI[id][p_boja_imena]);

    
    }
    else if (!strcmp(field, "provedeno_vreme"))
    {
        if (value < 0 || value > 9999999)
        {
            // ErrorMsg(playerid, "Unesite vrednost izmedju 1 i 2.");
            return DialogReopen(playerid);
        }
        else
        {
            PI[id][p_provedeno_vreme] = value;   
        }
    }

    if (IsNumeric(inputtext))
    {
    	format(valueStr, sizeof valueStr, "%i", value);
    }
    else
    {
    	format(valueStr, sizeof valueStr, "%s", inputtext);
    }

    SendClientMessageF(playerid, SVETLOPLAVA, "* Promenili ste %s vrednost polja %s: %s", ime_rp[id], field, valueStr);
    SendClientMessageF(id, SVETLOPLAVA, "* %s Vam je promenio vrednost polja %s: %s", ime_rp[playerid], field, valueStr);

    new sQuery[256];
    mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE igraci SET %s = '%s' WHERE id = %d", field, valueStr, PI[id][p_id]);
    mysql_tquery(SQL, sQuery);

    new sLog[128];
    format(sLog, sizeof sLog, "%s [%d] | %s: %s", ime_obicno[id], PI[id][p_id], field, valueStr);
    Log_Write(LOG_SETSTATS, sLog);

    DeletePVar(playerid, "pSetStatsID");
    DeletePVar(playerid, "pSetStatsField");
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:setstats(FLAG_ADMIN_5)
CMD:setstats(playerid, const params[])
{
    new targetid;
    if (sscanf(params, "u", targetid))
        return Koristite(playerid, "setstats [Ime ili ID igraca]");

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    new string[1024];
    SetPVarInt(playerid, "pSetStatsID", targetid);
    format(string, sizeof string, "Polje\tVrednost\nnivo\t%d\norg_id\t%d\norg_vreme\t%d\norg_kazna\t%d\nnovac\t%d\nbanka\t%d\ngold\t%d\niskustvo\t%d\npayday\t%d\nkartica\t%s\nkartica_pin\t%d\nkredit_iznos\t%d\nkredit_otplata\t%d\nkredit_rata\t%d\nmobilni\t%s\nsim\t%s\nsim_broj\t%d\nsim_kredit\t%d\npol\t%d\nstarost\t%d\ndrzava\t%s\nglad\t%d\nkaznjen_puta\t%d\nuhapsen_puta\t%d\nopomene\t%d\nkuca\t%d\nstan\t%d\nfirma\t%d\nhotel\t%d\ngaraza\t%d\nvikendica\t%d\nwar_ubistva\t%d\nwar_smrti\t%d\nwar_samoubistva\t%d\nbombe\t%d|%d|%d\nskill_criminal\t%d\nskill_cop\t%d\ndivision_points\nvozila_slotovi\t%i\nimanja_slotovi\t%i\nboja_imena\t%i\nprovedeno_vreme\t%.1f sati", PI[targetid][p_nivo], PI[targetid][p_org_id], PI[targetid][p_org_vreme], PI[targetid][p_org_kazna], PI[targetid][p_novac], PI[targetid][p_banka], PI[targetid][p_token], PI[targetid][p_iskustvo], PI[targetid][p_payday], PI[targetid][p_kartica], PI[targetid][p_kartica_pin], PI[targetid][p_kredit_iznos], PI[targetid][p_kredit_otplata], PI[targetid][p_kredit_rata], PI[targetid][p_mobilni], PI[targetid][p_sim], PI[targetid][p_sim_broj], PI[targetid][p_sim_kredit], PI[targetid][p_pol], PI[targetid][p_starost], PI[targetid][p_drzava], PI[targetid][p_glad], PI[targetid][p_kaznjen_puta], PI[targetid][p_uhapsen_puta], PI[targetid][p_opomene], pRealEstate[targetid][kuca], pRealEstate[targetid][stan], pRealEstate[targetid][firma], pRealEstate[targetid][hotel], pRealEstate[targetid][garaza], pRealEstate[targetid][vikendica], PI[targetid][p_war_ubistva], PI[targetid][p_war_smrti], PI[targetid][p_war_samoubistva], PI[targetid][p_bomba][0], PI[targetid][p_bomba][1], PI[targetid][p_bomba][2], PI[targetid][p_skill_criminal], PI[targetid][p_skill_cop], PI[targetid][p_division_points], PI[targetid][p_vozila_slotovi], PI[targetid][p_imanja_slotovi], PI[targetid][p_boja_imena], floatdiv(PI[targetid][p_provedeno_vreme], 3600.0));
    SPD(playerid, "setstats1", DIALOG_STYLE_TABLIST_HEADERS, ime_rp[targetid], string, "Dalje", "Izadji");
    return 1;
}