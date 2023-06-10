#include <YSI_Coding\y_hooks>

new
    g_BankRobber,
    g_BankCooldown,
    g_RobTimer,
    g_PinPlayer,
    g_PinCode,
    g_GateClose,
    g_RobCounter,
    g_ResetTimer,
    g_FinishCP,

    g_PinCP,
    PlayerText:TDPin[MAX_PLAYERS][5],
    PlayerText:TDCounter[MAX_PLAYERS][1],

    Float:RobbingPos[3] = {0.0, 0.0, 0.0}
;

const ROB_BOUNTY = 350000;

hook OnGameModeInit()
{
    g_BankCooldown = gettime();
    g_RobTimer = -1;
    g_RobCounter = 600;
    g_BankRobber = g_PinPlayer = INVALID_PLAYER_ID;

    g_PinCode = RandomEx(100, 999);
    g_PinCP = CreatePlayerCP(0.0, 0.0, 0.0, 3.0, -1, -1, -1, 30.0);

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
    for(new i = 0; i < 5; i++)
    {
        PlayerTextDrawDestroy(playerid, TDPin[playerid][i]);
        TDPin[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        if(i == 0)
        {
            PlayerTextDrawDestroy(playerid, TDCounter[playerid][i]);
            TDCounter[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == g_PinCP)
    {
        if(g_PinPlayer == INVALID_PLAYER_ID)
        {
            PinTDControl(playerid, true);
            SendClientMessage(playerid, SVETLOCRVENA, "(pin security) {FFFFFF}Unesi pin za pristup sefu (Otkazite akciju sa tipkom 'N')");
            SendClientMessage(playerid, SVETLOCRVENA, "(pin security) {FFFFFF}(( Upisite kod u chat ))");
        }
    }
    else if(checkpointid == g_FinishCP)
    {
        if(g_BankRobber == playerid)
        {
            StopBankRobberyProcess(true);
        }
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, oldkeys, newkeys)
{
    if(g_PinPlayer == playerid && newkeys & KEY_NO)
    {
        PinTDControl(playerid, false);
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerText(playerid, const text[])
{
    if(g_PinPlayer == playerid)
    {
        new
            pinvalue = strval(text),
            numb[11]
        ;

        if(pinvalue == g_PinCode)
        {
            format(numb, sizeof numb, "~g~~h~%s_%s_%s", text[0], text[1], text[3]);
            PlayerTextDrawSetString(playerid, TDPin[playerid][2], "~g~~h~|");
            PlayerTextDrawSetString(playerid, TDPin[playerid][3], numb);
            PlayerTextDrawSetString(playerid, TDPin[playerid][4], numb);

            PlayerTextDrawShow(playerid, TDPin[playerid][2]);
            PlayerTextDrawShow(playerid, TDPin[playerid][3]);
            PlayerTextDrawShow(playerid, TDPin[playerid][4]);

            SetTimerEx("OpenGate", 2000, false, "i", playerid);
        }

        return 0;
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

forward OpenGate(playerid);
public OpenGate(playerid)
{
    // MoveDynamicObject
    g_GateClose = SetTimer("CloseGate", 600000, false); // Za 10 min će se kapija zatvoriti ukoliko se rob ne započne
    SendClientMessage(playerid, SVETLOCRVENA, "(gate) {FFFFFF} Uspjesno si probio kapiju, zapocni pljacku!");

    return 1;
}

forward CloseGate();
public CloseGate()
{
    // move object
    return 1;
}

CMD:pljackaj(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 5.0, RobbingPos[0], RobbingPos[1], RobbingPos[2]) && IsACriminal(playerid))
    {
        if(g_BankCooldown > gettime())
            return ErrorMsg(playerid, "Cooldown za rob banke jos traje, /bankcd.");
        
        new
            gangcount,
            pdcount
        ;

        foreach(new i : Player)
        {
            if(GetPlayerFactionID(i) == GetPlayerFactionID(playerid) && IsPlayerInRangeOfPoint(playerid, 20.0, RobbingPos[0], RobbingPos[1], RobbingPos[2]))
            {
                gangcount++;
            }
            else if(IsACop(i) && !IsPlayerAFK(i))
            {
                pdcount++;
            }
        }

        if(!testingdaddy)
        {
            if(gangcount < 3)
                return ErrorMsg(playerid, "Potrebno je da sa sobom imate jos minimalno 3 clana organizacije u blizini vas.");

            if(pdcount < 3)
                return ErrorMsg(playerid, "Potrebno je minimalno tri online policajca kako biste zapoceli pljacku.");
        }

        // crime report;
        AddPlayerCrime(playerid, INVALID_PLAYER_ID, 6, "Pljacka banke", "Snimak sa nadzorne kamere");

        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Neidentifikovana kriminalna grupa je probila obezbjedjenje banke te zapocela pljacku!");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Specijalne jedinice izlaze na teren, a policija apeluje na gradjane da ne prilaze ovom dijelu grada!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        DepartmentMsg(DEPT_BOJA, "Centrala: {959BEA}Svim jedinicama: {FF6347}Pljacka banke u toku!");

        // postavljanje varijabli;
        g_BankRobber = playerid;
        g_PinPlayer = INVALID_PLAYER_ID;

        KillTimer(g_GateClose);
        DestroyDynamicCP(g_PinCP);

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 1, 0);

        g_RobTimer = SetTimerEx("RobInProcess", 1000, true, "i", playerid);

        // tdovi;
        TDCounter[playerid][0] = CreatePlayerTextDraw(playerid, 609.375000, 278.083404, "robbery_~n~~y~10:00");
        PlayerTextDrawLetterSize(playerid, TDCounter[playerid][0], 0.286874, 1.057500);
        PlayerTextDrawAlignment(playerid, TDCounter[playerid][0], 3);
        PlayerTextDrawColor(playerid, TDCounter[playerid][0], -1);
        PlayerTextDrawSetShadow(playerid, TDCounter[playerid][0], 0);
        PlayerTextDrawSetOutline(playerid, TDCounter[playerid][0], 1);
        PlayerTextDrawBackgroundColor(playerid, TDCounter[playerid][0], 255);
        PlayerTextDrawFont(playerid, TDCounter[playerid][0], 3);
        PlayerTextDrawSetProportional(playerid, TDCounter[playerid][0], 1);

        PlayerTextDrawShow(playerid, TDCounter[playerid][0]);
    }

    return 1;
}

/*stock GetTime(sec, const unit[])
{
    new
        scopy = sec,
        countminutes
    ;
    while(scopy >= 60)
    {
        scopy -= 60;
        countminutes++;
    }

    if(!strcmp(unit, "seconds"))
        return scopy;

    else if(!strcmp(unit, "minutes"))
        return countminutes;
}*/

forward RobInProcess(playerid);
public RobInProcess(playerid)
{
    g_RobCounter--;

    new
        fstr[16+7]
    ;

    format(fstr, sizeof fstr, "robbery:~n~~y~%s", konvertuj_vreme(g_RobCounter));
    PlayerTextDrawShow(playerid, TDCounter[playerid][0]);

    if(g_RobCounter == 0)
    {
        SendClientMessage(playerid, SVETLOCRVENA, "(robbery) {FFFFFF}Uspjesno ste opljackali banku, napustite prostoriju kroz ventilaciju.");
        KillTimer(g_RobTimer);

        g_ResetTimer = SetTimer("ResetBankRobbery", 600000*6, false);
        g_BankCooldown = gettime() + 600000*6;

        g_FinishCP = CreatePlayerCP(FACTIONS[GetPlayerFactionID(playerid)][f_x_ulaz], FACTIONS[GetPlayerFactionID(playerid)][f_y_ulaz], FACTIONS[GetPlayerFactionID(playerid)][f_z_ulaz], 4.0, -1, -1, playerid, 6000.0); // StopBankRobberyProcess
    }
    
    return 1;
}

CMD:bankcd(playerid)
{
    new
        string[40]
    ;

    format(string, sizeof string, "Banka cooldown: %s", (g_BankCooldown > 0) ? konvertuj_vreme(g_BankCooldown/1000) : "Dostupno za rob");
    SPD(playerid, "BCD", DIALOG_STYLE_MSGBOX, "Cooldown", string, "Ok", "");
    return 1;
}

forward ResetBankRobbery();
public ResetBankRobbery()
{
    g_RobTimer = -1;
    g_RobCounter = 600;
    g_BankRobber = g_PinPlayer = INVALID_PLAYER_ID;

    g_PinCode = RandomEx(100, 999);
    g_PinCP = CreatePlayerCP(0.0, 0.0, 0.0, 3.0, -1, -1, -1, 30.0);

    KillTimer(g_ResetTimer);
    // Move gate;
    return 1;
}

stock PinTDControl(playerid, bool:showpin)
{
    if(showpin)
    {
        TDPin[playerid][0] = CreatePlayerTextDraw(playerid, 256.875000, 136.916687, "");
        PlayerTextDrawTextSize(playerid, TDPin[playerid][0], 122.000000, 131.000000);
        PlayerTextDrawAlignment(playerid, TDPin[playerid][0], 1);
        PlayerTextDrawColor(playerid, TDPin[playerid][0], 153);
        PlayerTextDrawSetShadow(playerid, TDPin[playerid][0], 0);
        PlayerTextDrawFont(playerid, TDPin[playerid][0], 5);
        PlayerTextDrawSetProportional(playerid, TDPin[playerid][0], 0);
        PlayerTextDrawSetPreviewModel(playerid, TDPin[playerid][0], 2731);
        PlayerTextDrawBackgroundColor(playerid, TDPin[playerid][0], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, TDPin[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

        TDPin[playerid][1] = CreatePlayerTextDraw(playerid, 256.399932, 128.616455, "");
        PlayerTextDrawTextSize(playerid, TDPin[playerid][1], 122.000000, 131.000000);
        PlayerTextDrawAlignment(playerid, TDPin[playerid][1], 1);
        PlayerTextDrawColor(playerid, TDPin[playerid][1], 153);
        PlayerTextDrawSetShadow(playerid, TDPin[playerid][1], 0);
        PlayerTextDrawFont(playerid, TDPin[playerid][1], 5);
        PlayerTextDrawSetProportional(playerid, TDPin[playerid][1], 0);
        PlayerTextDrawSetPreviewModel(playerid, TDPin[playerid][1], 2731);
        PlayerTextDrawBackgroundColor(playerid, TDPin[playerid][1], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, TDPin[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

        TDPin[playerid][2] = CreatePlayerTextDraw(playerid, 303.625030, 160.866973, "|");
        PlayerTextDrawLetterSize(playerid, TDPin[playerid][2], 1.846250, 0.514999);
        PlayerTextDrawAlignment(playerid, TDPin[playerid][2], 1);
        PlayerTextDrawColor(playerid, TDPin[playerid][2], -1);
        PlayerTextDrawSetShadow(playerid, TDPin[playerid][2], 0);
        PlayerTextDrawBackgroundColor(playerid, TDPin[playerid][2], 255);
        PlayerTextDrawFont(playerid, TDPin[playerid][2], 1);
        PlayerTextDrawSetProportional(playerid, TDPin[playerid][2], 1);

        TDPin[playerid][3] = CreatePlayerTextDraw(playerid, 318.524871, 181.049911, "~w~0_0_0");
        PlayerTextDrawLetterSize(playerid, TDPin[playerid][3], 0.519374, 3.256665);
        PlayerTextDrawAlignment(playerid, TDPin[playerid][3], 2);
        PlayerTextDrawColor(playerid, TDPin[playerid][3], -1);
        PlayerTextDrawSetShadow(playerid, TDPin[playerid][3], 0);
        PlayerTextDrawBackgroundColor(playerid, TDPin[playerid][3], 255);
        PlayerTextDrawFont(playerid, TDPin[playerid][3], 2);
        PlayerTextDrawSetProportional(playerid, TDPin[playerid][3], 1);

        TDPin[playerid][4] = CreatePlayerTextDraw(playerid, 318.524871, 184.150100, "~w~0_0_0");
        PlayerTextDrawLetterSize(playerid, TDPin[playerid][4], 0.519374, 3.256665);
        PlayerTextDrawAlignment(playerid, TDPin[playerid][4], 2);
        PlayerTextDrawColor(playerid, TDPin[playerid][4], 34);
        PlayerTextDrawSetShadow(playerid, TDPin[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, TDPin[playerid][4], 255);
        PlayerTextDrawFont(playerid, TDPin[playerid][4], 2);
        PlayerTextDrawSetProportional(playerid, TDPin[playerid][4], 1);

        for(new i = 0; i < 5; i++)
            PlayerTextDrawShow(playerid, TDPin[playerid][i]);

        g_PinPlayer = playerid;
    }
    else
    {
        for(new i = 0; i < 5; i++)
        {
            PlayerTextDrawDestroy(playerid, TDPin[playerid][i]);
            TDPin[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }

        g_PinPlayer = INVALID_PLAYER_ID;
    }
    return 1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(playerid == g_BankRobber)
    {
        StopBankRobberyProcess(false, "Igrac koji je pljackao je napustio server");
    }

    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if(playerid == g_BankRobber)
    {
        StopBankRobberyProcess(false, "Igrac koji je pljackao je umro");
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

stock IsPlayerRobbingBank(playerid)
{
    if(g_BankRobber == playerid)
        return true;
    
    return false;
}

stock IsBankRobberyInProgress()
{
    if(g_BankRobber != INVALID_PLAYER_ID)
        return true;
    
    return false;
}

stock GetFactionRobbingBank()
{
    if(g_BankRobber != INVALID_PLAYER_ID)
        return GetPlayerFactionID(g_BankRobber);

    return -1;
}

stock StopBankRobberyProcess(bool:won = false, const occasions[] = "")
{
    static skill = 3;

    if(!won)
    {
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Policija naseg grada je uspjesno intervenirala i prekinula pljacku banke.");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Gradjanima je dozvoljeno kretanje u blizini banke ali apelujemo da budu na oprezu!");
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        // skill-up;
        foreach (new i : Player)
        {
            if (IsACop(i) && IsPlayerOnLawDuty(i))
            {
                PlayerUpdateCopSkill(i, skill, SKILL_BANKWIN, 1);
            }
        }

        FactionMsg(GetPlayerFactionID(g_BankRobber), "Pljacka banke je propala, razlog: %s", occasions);
    }
    else
    {
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");
        SendClientMessageFToAll(BELA, "Vesti | {FF6347}Neidentifikovana kriminalna grupa je uspjesno opljackala banku.");
        SendClientMessageFToAll(SVETLOCRVENA2, "    - Radi se o novcu cija kolicina iznosi oko $%i", ROB_BOUNTY);
        SendClientMessageFToAll(SVETLOCRVENA2, "______________________________________________________________________________________________________");

        // skill-up;
        foreach (new i : Player)
        {
            if (IsACriminal(i) && GetPlayerFactionID(i) == GetPlayerFactionID(g_BankRobber) && !IsPlayerAFK(i))
            {
                PlayerUpdateCriminalSkill(i, 2, SKILL_ROBBERY_BANK, 1);
            }
        }
    }

    FACTIONS[GetPlayerFactionID(g_BankRobber)][f_budzet] += ROB_BOUNTY;

    g_RobTimer = -1;
    g_RobCounter = 600;
    g_BankRobber = g_PinPlayer = INVALID_PLAYER_ID;

    if(IsValidDynamicCP(g_FinishCP))
        DestroyDynamicCP(g_FinishCP);

    return 1;
}
