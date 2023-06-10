/*CMD:pljacka(playerid, const params[]) 
{
    if (IsACop(playerid))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    
    if (IsPlayerInRangeOfPoint(playerid, 3.0, 891.6241,-1354.5830,5.3360))
    {
        return PC_EmulateCommand(playerid, "/pljackajzlataru");
    }
    else if (IsPlayerInRangeOfPoint(playerid, 3.0, 1470.8264,-978.0361,22.8931))
    {
        return PC_EmulateCommand(playerid, "/pljackajbanku");
    }
    else if (IsPlayerNearATM(playerid))
    {
        return PC_EmulateCommand(playerid, "/pljackajatm");
    }
    else
    {
        return ErrorMsg(playerid, "Na ovom mestu ne mozete nista da pljackate!");
    }
}

alias:cd("robinfo")
CMD:cd(playerid, const params[])
{
    new CD_Jewelry[22], CD_Bank[22];

    if (GetJewelryCooldownTimestamp() > gettime())
    {
        format(CD_Jewelry, sizeof CD_Jewelry, "{FF9900}%s", konvertuj_vreme(GetJewelryCooldownTimestamp() - gettime()));
    }
    else
    {
        if (GetFactionRobbingJeweley() != -1)
        {
            format(CD_Jewelry, sizeof CD_Jewelry, "{FFFF00}U toku");
        }
        else
        {
            format(CD_Jewelry, sizeof CD_Jewelry, "{00FF00}Spremno");
        }
    }
    
    if (GetBankCooldownTimestamp() > gettime())
    {
        format(CD_Bank, sizeof CD_Bank, "{FF9900}%s", konvertuj_vreme(GetBankCooldownTimestamp() - gettime()));
    }
    else
    {
        if (IsBankRobberyInProgress())
        {
            format(CD_Bank, sizeof CD_Bank, "{FFFF00}U toku");
        }
        else
        {
            format(CD_Bank, sizeof CD_Bank, "{00FF00}Spremno");
        }
    }

    new dStr[83];
    format(dStr, sizeof dStr, "{FFFFFF}Zlatara: %s\n{FFFFFF}Banka: %s", CD_Jewelry, CD_Bank);

    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "Cooldown", dStr, "U redu", "");
    return 1;
}*/