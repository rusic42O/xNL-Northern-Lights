new tajmer:HideSkillTextdraw[MAX_PLAYERS]; // inicijalizacija u factions.pwn

stock ptdSkill_Create(playerid)
{
    PlayerTD[playerid][ptdSkill][0] = CreatePlayerTextDraw(playerid, 266.666687, 356.340759, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSkill][0], 0.000000, 4.366666);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdSkill][0], 365.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSkill][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdSkill][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdSkill][0], 127);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSkill][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSkill][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSkill][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSkill][0], 1);

    PlayerTD[playerid][ptdSkill][1] = CreatePlayerTextDraw(playerid, 269.666625, 346.396453, "Skill");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSkill][1], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdSkill][1], 363.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSkill][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][1], -137807361);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSkill][1], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdSkill][1], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSkill][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSkill][1], 0);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSkill][1], 1);

    PlayerTD[playerid][ptdSkill][2] = CreatePlayerTextDraw(playerid, 349.966766, 346.619049, "_"); // Broj poena
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSkill][2], 0.348666, 1.720297);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSkill][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][2], 130628095);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSkill][2], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdSkill][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSkill][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSkill][2], 3);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSkill][2], 1);

    PlayerTD[playerid][ptdSkill][3] = CreatePlayerTextDraw(playerid, 333.800628, 366.718231, "_"); // Razlog
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdSkill][3], 0.231333, 1.093924);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdSkill][3], 0.000000, 59.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdSkill][3], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][3], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdSkill][3], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdSkill][3], -1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdSkill][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdSkill][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdSkill][3], 1);
}

stock ptdSkill_Show(playerid, incValue, E_SKILLS:skillType)
{
    if (skillType == SKILL_SILENT) return 1;

    new reason[32];
    switch (skillType)
    {
        case SKILL_ROBBERY_ATM:         format(reason, sizeof reason, "Pljacka~N~bankomata");
        case SKILL_ROBBERY_247:         format(reason, sizeof reason, "Pljacka~N~marketa");
        case SKILL_ROBBERY_CAR:         format(reason, sizeof reason, "Kradja~N~automobila");
        case SKILL_ROBBERY_BANK:        format(reason, sizeof reason, "Pljacka~N~banke");
        case SKILL_ROBBERY_JEWELRY:     format(reason, sizeof reason, "Pljacka~N~zlatare");
        case SKILL_TURF_DEFENSE:        format(reason, sizeof reason, "Odbrana~N~teritorije");
        case SKILL_TURF_TAKEOVER:       format(reason, sizeof reason, "Zauzimanje~N~teritorije");
        case SKILL_TURF_DEFENSE_FAIL:   format(reason, sizeof reason, "Neuspesna odbrana~n~teritorije");
        case SKILL_TURF_TAKEOVER_FAIL:  format(reason, sizeof reason, "Napustanje~n~teritorije");
        case SKILL_PICKPOCKET:          format(reason, sizeof reason, "Dzeparenje");
        case SKILL_WEAPONS_DROP:        format(reason, sizeof reason, "Obijanje~n~skladista");
        case SKILL_DELIVERY:            format(reason, sizeof reason, "Dostava~n~materijala");
        case SKILL_ARREST:              format(reason, sizeof reason, "Hapsenje");
        case SKILL_PZLATO:              format(reason, sizeof reason, "Prevoz zlata");
        case SKILL_LTA:                 format(reason, sizeof reason, "LTA - Logging~n~to avoid");
        case SKILL_WAR_WIN:             format(reason, sizeof reason, "WAR - Pobeda");
        case SKILL_WAR_LOSE:            format(reason, sizeof reason, "WAR - Poraz");
        case SKILL_BANKWIN:             format(reason, sizeof reason, "Uspjesno odbranjena banka");
        case SKILL_JEWWIN:              format(reason, sizeof reason, "Uspjesno odbranjena zlatara");
        
    }
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdSkill][3], reason);

    // Odredjivanje boje
    new valueStr[4];
    if (incValue >= 0)
    {
        format(valueStr, sizeof valueStr, "+%i", incValue);
        PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][2], 130628095);
    }
    else
    {
        format(valueStr, sizeof valueStr, "%i", incValue);
        PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdSkill][2], 4281026303);
    }
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdSkill][2], valueStr);

    // Prikazivanje osnove
    for (new i = 0; i < PTD_SIZE_SKILL; i++)
    {
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdSkill][i]);
    }

    // Sakrivamo sve ikonice
    for__loop (new i = 0; i < sizeof tdSkill; i++)
    {
        TextDrawHideForPlayer(playerid, tdSkill[E_SKILLS:i]);
    }

    // Prikazujemo odgovarajucu ikonicu
    TextDrawShowForPlayer(playerid, tdSkill[skillType]);
    if (skillType == E_SKILLS:SKILL_ARREST || skillType == E_SKILLS:SKILL_PZLATO) TextDrawShowForPlayer(playerid, tdSkill[E_SKILLS:SKILL_ARREST2]);
    else if (skillType == E_SKILLS:SKILL_ROBBERY_CAR)
    {
        new c1, c2;
        VehicleTheft_GetColors(playerid, c1, c2);
        TextDrawSetPreviewVehCol(tdSkill[SKILL_ROBBERY_CAR], c1, c2);
        TextDrawShowForPlayer(playerid, tdSkill[SKILL_ROBBERY_CAR]);
    }

    KillTimer(tajmer:HideSkillTextdraw[playerid]);
    tajmer:HideSkillTextdraw[playerid] = SetTimerEx("HideSkillTextdraw", 6000, false, "ii", playerid, cinc[playerid]);

    return 1;
}

forward HideSkillTextdraw(playerid, ccinc);
public HideSkillTextdraw(playerid, ccinc)
{
    if (checkcinc(playerid, ccinc))
    {
        // Sakrivamo osnovu
        for (new i = 0; i < PTD_SIZE_SKILL; i++)
        {
            PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdSkill][i]);
        }

        // Sakrivamo sve ikonice
        for__loop (new i = 0; i < sizeof tdSkill; i++)
        {
            TextDrawHideForPlayer(playerid, tdSkill[E_SKILLS:i]);
        }
    }

    KillTimer(tajmer:HideSkillTextdraw[playerid]), tajmer:HideSkillTextdraw[playerid] = 0;
    return 1;
}