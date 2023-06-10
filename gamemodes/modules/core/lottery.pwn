#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define LOTTERY_COLOR               (0xBA3268FF)
#define LOTTERY_LUCKYONE_STAKE      1000
// #define LOTTERY_LUCKYONE_FIXEDPRIZE 10000




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new 
    LOTTERY_pLuckyNumber[MAX_PLAYERS],
    bool:LOTTERY_reactionCheckAllowed[MAX_PLAYERS char], // da li ima pravo da ucestvuje na reaction check?
    //LOTTERY_reactionCheckStr[25],
    //LOTTERY_reactionCheckStart,
    LOTTERY_luckyOneNextDraw,
    LOTTERY_luckyOnePrize,
    bool:LOTTERY_reactionCheck;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    mysql_tquery(SQL, "SELECT value FROM server_info WHERE field = 'jackpot'", "MySQL_LoadJackpot");

    CreateDynamicActor(11, 1220.1567, -1425.9780, 13.6853, 0.0);
    CreateDynamic3DTextLabel("{FF0000}< LUCKY ONE >\n{FF9900}Koristite /luckyone za uplatu", BELA, 1220.1361, -1423.2625, 13.6835, 15.0);
    CreateDynamic3DTextLabel("{FFFF00}< WAR KLADIONICA >\n{FF9900}Koristite /bet za kladjenje", BELA, 1215.2556, -1423.5125, 13.6835, 15.0);


    LOTTERY_reactionCheck = false;

    SetTimer("LOTTERY_LuckyOne", 60*60*1000, true);
    SetTimer("LOTTERY_LuckyOneReminder", 45*60*1000, false);
    //SetTimer("LOTTERY_ReactionCheck", 60*60*700+random(300), true);

    LOTTERY_luckyOneNextDraw = gettime() + 3600;
    return true;
}
/*
hook OnPlayerText(playerid, text[])
{
    if (LOTTERY_reactionCheck)
    {
        if (!isnull(text) && !strcmp(LOTTERY_reactionCheckStr, text, false))
        {
            // Pogodio

            if (!LOTTERY_reactionCheckAllowed{playerid})
                return ErrorMsg(playerid, "Izgubili ste pravo da ucestvujete na lutriji jer ste minimizirali igru. Sledeci put igrajte posteno!");

            new string[110];
            format(string, sizeof string, "(lutrija) {FFFFFF}Najbrzu reakciju imao je {00FF00}%s {FFFFFF}(%.2f sec)", ime_rp[playerid], float(GetTickCount() - LOTTERY_reactionCheckStart)/1000.0);
            SendClientMessageFToAll(LOTTERY_COLOR, string);
            PlayerMoneyAdd(playerid, 1500);

            // Upisivanje u log
            new logstr[85];
            format(logstr, sizeof logstr, "ReactionCheck | %s | %s | $1.500", ime_obicno[playerid], LOTTERY_reactionCheckStr);
            Log_Write(LOG_LOTTERY, logstr);

            // Resetovanje
            LOTTERY_reactionCheck = false;
            LOTTERY_reactionCheckStr[0] = EOS;
        }
    } 
    return 0;
}*/

hook OnPlayerConnect(playerid)
{
    LOTTERY_pLuckyNumber[playerid] = 0;
    LOTTERY_reactionCheckAllowed{playerid} = true;
}

hook OnPlayerPause(playerid)
{
    if (LOTTERY_reactionCheck)
    {
        LOTTERY_reactionCheckAllowed{playerid} = false;
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward MySQL_LoadJackpot();
public MySQL_LoadJackpot()
{
    cache_get_row_count(rows);
    if (rows != 1) 
        return printf("[lottery.pwn] Nije moguce ucitati jackpot.");

    new strLoad[9];
    cache_get_value_index(0, 0, strLoad, sizeof strLoad);
    LOTTERY_luckyOnePrize = strval(strLoad);

    if (LOTTERY_luckyOnePrize < 0) LOTTERY_luckyOnePrize = 0;
    if (LOTTERY_luckyOnePrize > 99999999) LOTTERY_luckyOnePrize = 0;
    return 1;
}

forward LOTTERY_LuckyOne();
public LOTTERY_LuckyOne()
{
    if (DebugFunctions())
    {
        LogFunctionExec("LOTTERY_LuckyOne");
    }

    new luckyNumber = 1 + random(50), winners = 0;

    // Brojanje dobitnika
    foreach (new i : Player)
    {
        if (LOTTERY_pLuckyNumber[i] == luckyNumber)
        {
            winners += 1;
        }
    }

    // Podela novca
    if (winners == 0)
    {
        foreach (new i : Player)
        {
            LOTTERY_pLuckyNumber[i] = 0;
        }
        SendClientMessageFToAll(LOTTERY_COLOR, "(lucky one) {FFFFFF}Izvucen je broj {BA3268}%i. {FFFFFF}Nazalost nemamo dobitnika, vise srece drugi put!", luckyNumber);
    }
    else
    {
        new 
            prize = floatround(LOTTERY_luckyOnePrize / winners), 
            logstr[120],
            winnerid = INVALID_PLAYER_ID;

        foreach (new i : Player)
        {
            if (LOTTERY_pLuckyNumber[i] == luckyNumber)
            {
                winnerid = i;
                PlayerMoneyAdd(i, prize);
                format(logstr, sizeof logstr, "LuckyOne | %s | %i | %s ($%d)", ime_obicno[i], luckyNumber, formatMoneyString(prize), prize);
                Log_Write(LOG_LOTTERY, logstr);
            }
            LOTTERY_pLuckyNumber[i] = 0;
        }

        if (winners > 1)
        {
            new str[145];
            format(str, sizeof str, "(lucky one) {FFFFFF}Izvucen je broj {BA3268}%i. {00FF00}%i dobitnika je podelilo %s.", luckyNumber, winners, formatMoneyString(LOTTERY_luckyOnePrize));
            SendClientMessageToAll(LOTTERY_COLOR, str);
        }
        else if (winners == 1)
        {
            new str[145];
            format(str, sizeof str, "(lucky one) {FFFFFF}Izvucen je broj {BA3268}%i. {FFFFFF}Jackpot (%s) je osvojio {BA3268}%s!", luckyNumber, formatMoneyString(LOTTERY_luckyOnePrize), ime_rp[winnerid]);
            SendClientMessageToAll(LOTTERY_COLOR, str);
        }

        LOTTERY_luckyOnePrize = 0;
        mysql_tquery(SQL, "UPDATE server_info SET value = '0' WHERE field = 'jackpot'");
    }

    SetTimer("LOTTERY_LuckyOneReminder", 45*60*1000, false);
    LOTTERY_luckyOneNextDraw = gettime() + 3600;
    return 1;
}

forward LOTTERY_LuckyOneReminder();
public LOTTERY_LuckyOneReminder()
{
    SendClientMessageToAll(LOTTERY_COLOR, "(lucky one) {FFFFFF}Naredno izvlacenje je za 15 minuta, ne zaboravite da uplatite svoj listic. {BA3268}(/luckyone)");
    
    new str[83];
    format(str, sizeof str, "(lucky one) {FFFFFF}Jackpot za naredno izvlacenje iznosi: {00FF00}%s", formatMoneyString(LOTTERY_luckyOnePrize));
    SendClientMessageToAll(LOTTERY_COLOR, str);
    return 1;
}

/*forward LOTTERY_ReactionCheck();
public LOTTERY_ReactionCheck()
{
    if (DebugFunctions())
    {
        LogFunctionExec("LOTTERY_ReactionCheck");
    }

    if (random(2))
    {
        // Matematika

        new 
            num[3], 
            variant = random(3), 
            correct = 987654, 
            string[145];

        for__loop (new i = 0; i < 3; i ++)
            num[i] = random(40);

        if (variant == 0)
        {
            // num[0] + num[1] * num[2]

            correct = num[0] + num[1] * num[2];
            format(string, sizeof string, "(lutrija) {FFFFFF}Budite prvi koji ce izracunati {BA3268}%i + %i * %i {FFFFFF}i osvojite $1.500!", num[0], num[1], num[2]);
        }
        else if (variant == 1)
        {
            // num[0] * num[1] + num[2]

            correct = num[0] * num[1] + num[2];
            format(string, sizeof string, "(lutrija) {FFFFFF}Budite prvi koji ce izracunati {BA3268}%i * %i + %i {FFFFFF}i osvojite $1.500!", num[0], num[1], num[2]);
        }
        else if (variant == 2)
        {
            // num[0] * num[1] - num[2]

            correct = num[0] * num[1] - num[2];
            format(string, sizeof string, "(lutrija) {FFFFFF}Budite prvi koji ce izracunati {BA3268}%i * %i - %i {FFFFFF}i osvojite $1.500!", num[0], num[1], num[2]);
        }
        SendClientMessageFToAll(LOTTERY_COLOR, string);

        format(LOTTERY_reactionCheckStr, sizeof LOTTERY_reactionCheckStr, "%i", correct);
    }
    else
    {
        // Prekucavanje stringa
        foreach (new i : Player)
        {
            LOTTERY_reactionCheckAllowed{i} = true;
        }

        LOTTERY_reactionCheckStr[0] = EOS;
        RandomString(LOTTERY_reactionCheckStr, sizeof (LOTTERY_reactionCheckStr), RANDSTR_FLAG_UPPER | RANDSTR_FLAG_LOWER | RANDSTR_FLAG_DIGIT);

        SendClientMessageFToAll(LOTTERY_COLOR, "(lutrija) {FFFFFF}Budite prvi koji ce ukucati {BA3268}%s {FFFFFF}i osvojite $1.500!", LOTTERY_reactionCheckStr);
    }

    LOTTERY_reactionCheck = true;
    LOTTERY_reactionCheckStart = GetTickCount();
    return 1;
}*/

LOTTERY_GetPrize()
{
    return LOTTERY_luckyOnePrize;
}

LOTTERY_SetPrize(set)
{
    LOTTERY_luckyOnePrize = set;
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
alias:luckyone("loto", "lotto", "lutrija")

CMD:luckyone(playerid, const params[])
{
    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1220.1361, -1423.2625, 13.6835) && !IsVIP(playerid, 2))
        return ErrorMsg(playerid, "Ne nalazite se na mestu za uplacivanje Lucky One listica. Koristite /gps.");

    new broj;
    if (sscanf(params, "i", broj))
        return Koristite(playerid, "luckyone [Vas broj (1-50)]");

    if (LOTTERY_pLuckyNumber[playerid] != 0)
        return InfoMsg(playerid, "Vec ste uplatili Lucky One. Naredno izvlacenje je za {FFFFFF}%s.", konvertuj_vreme(LOTTERY_luckyOneNextDraw - gettime()));

    if (broj < 1 || broj > 50)
        return ErrorMsg(playerid, "Broj mora biti izmedju 1 i 50");

    if (PI[playerid][p_novac] < LOTTERY_LUCKYONE_STAKE)
        return ErrorMsg(playerid, "Nemate dovoljno novca za listic (%s).", formatMoneyString(LOTTERY_LUCKYONE_STAKE));


    LOTTERY_pLuckyNumber[playerid] = broj;
    PlayerMoneySub(playerid, LOTTERY_LUCKYONE_STAKE);
    LOTTERY_luckyOnePrize += LOTTERY_LUCKYONE_STAKE;

    new query[256];
    format(query, sizeof query, "UPDATE server_info SET value = '%i' WHERE field = 'jackpot'", LOTTERY_luckyOnePrize);
    mysql_tquery(SQL, query);

    new string[145];
    format(string, sizeof string, "(lucky one) {FFFFFF}%s je uplatio listic. Jackpot sada iznosi: {00FF00}%s {FFFFFF}| izvlacenje za: %s", ime_rp[playerid], formatMoneyString(LOTTERY_luckyOnePrize), konvertuj_vreme(LOTTERY_luckyOneNextDraw - gettime()));
    SendClientMessageToAll(LOTTERY_COLOR, string);
    SendClientMessageF(playerid, LOTTERY_COLOR, "(lutrija) {FFFFFF}Izabrali ste broj {BA3268}%i. {FFFFFF}Srecno!", broj, konvertuj_vreme(LOTTERY_luckyOneNextDraw - gettime())); 

    return 1;
}

CMD:jackpot(playerid, const params[])
{
    return SendClientMessageF(playerid, LOTTERY_COLOR, "(lutrija) {FFFFFF}Jackpot: {00FF00}%s {FFFFFF}| Naredno izvlacenje za: %s", formatMoneyString(LOTTERY_luckyOnePrize), konvertuj_vreme(LOTTERY_luckyOneNextDraw - gettime())); 
}