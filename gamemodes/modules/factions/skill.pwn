#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define DIVISION_DROP_TOLERANCE 15




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new gPlayerDivision[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    return true;
}

hook OnPlayerConnect(playerid) 
{
    gPlayerDivision[playerid] = 0;
    return true;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
GetDivisionDropTolerance()
{
    return DIVISION_DROP_TOLERANCE;
}

nl_public PlayerUpdateCriminalSkill(playerid, incValue, E_SKILLS:skillType, helper)
{
    if (!IsPlayerLoggedIn(playerid) || (IsPlayerAFK(playerid) && helper == 1)) return 0;

    PI[playerid][p_division_points] += incValue;
    PI[playerid][p_skill_criminal] += incValue;
    UpdatePlayerDivision(playerid, PI[playerid][p_division_points]-incValue);

    // Prikazivanje informacionog TD-a
    //ptdSkill_Show(playerid, incValue, skillType);
    PlayerPlaySound(playerid, 1057, 0.0, 0.0, 0.0);

    new queryAdd[24];
    queryAdd[0] = EOS;
    switch (skillType)
    {
        case SKILL_ROBBERY_ATM:
        {
            PI[playerid][p_robbed_atms] ++;
            format(queryAdd, sizeof queryAdd, "robbed_atms = %i", PI[playerid][p_robbed_atms]);
        }

        case SKILL_ROBBERY_247:
        {
            PI[playerid][p_robbed_stores] ++;
            format(queryAdd, sizeof queryAdd, "robbed_stores = %i", PI[playerid][p_robbed_stores]);
        }

        case SKILL_ROBBERY_CAR:
        {
            PI[playerid][p_stolen_cars] ++;
            format(queryAdd, sizeof queryAdd, "stolen_cars = %i", PI[playerid][p_stolen_cars]);
        }
    }

    // Update podataka u bazi
    new query[116];
    format(query, sizeof query, "UPDATE igraci SET division_points = %i, skill_criminal = %i", PI[playerid][p_division_points], PI[playerid][p_skill_criminal]);
    if (!isnull(queryAdd))
    {
        format(query, sizeof query, "%s, %s", query, queryAdd);
    }
    format(query, sizeof query, "%s WHERE id = %i", query, PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    // Logovanje
    new logStr[75];
    format(logStr, sizeof logStr, "GANG | %s | %i | Tip: %i | Gang Skill: %i", ime_obicno[playerid], incValue, _:skillType, PI[playerid][p_skill_criminal]);
    Log_Write(LOG_SKILL, logStr);
    return 1;
}

nl_public PlayerUpdateCopSkill(playerid, incValue, E_SKILLS:skillType, helper)
{
    if (!IsPlayerLoggedIn(playerid) || IsPlayerAFK(playerid)) return 0;

    PI[playerid][p_division_points] += incValue;
    PI[playerid][p_skill_cop] += incValue;
    UpdatePlayerDivision(playerid, PI[playerid][p_division_points]-incValue);

    // Prikazivanje informacionog TD-a
    ptdSkill_Show(playerid, incValue, skillType);
    PlayerPlaySound(Race402_P1, 1057, 0.0, 0.0, 0.0);

    // Dodavanje stats-a
    if (skillType != SKILL_SILENT)
    {
        PI[playerid][p_arrested_criminals] ++;
    }

    // Update podataka u bazi
    new query[125];
    format(query, sizeof query, "UPDATE igraci SET division_points = %i, skill_cop = %i, arrested_criminals = %i WHERE id = %i", PI[playerid][p_division_points], PI[playerid][p_skill_cop], PI[playerid][p_arrested_criminals], PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    // Logovanje
    new logStr[75];
    format(logStr, sizeof logStr, "COP | %s | %i | Tip: %i | Cop Skill: %i", ime_obicno[playerid], incValue, _:skillType, PI[playerid][p_skill_cop]);
    Log_Write(LOG_SKILL, logStr);
    return 1;
}

stock UpdatePlayerDivision(playerid, oldValue)
{
    new newValue = PI[playerid][p_division_points];
    new bool:dbUpdate = false;

    // Ako padne u Iron diviziju -> brise mu se VIP i dobija cooldown 12 sati, pa tek onda moze da povrati VIP kad predje 1000 poena

    // Ako u okviru reload time-a (7 dana) od produzetka VIP-a ili prelaska u novu diviziju...
    // (u prevodu: narednih 7 dana nakon postizanja broja poena od 1500, 1600...2000, i slicno)
    // ... igrac padne za 15 poena u odnosu na prag (prag je tih 1500, 1600...2000 i slicno), VIP mu se skracuje za 12 sati.

    // Ako iz vise divizije padne na nizu (npr. Silver->Bronze) (tolerise se onih 15 poena, znaci ako sa 2000 padne na 1991 to je u redu, ostaje Silver i ne prelazi u Bronze) - onda mu se VIP skracuje za 12 sati + formalno pada u nizu diviziju, odnosno oduzima mu se VIP Silver i dobija VIP Bronze

    // Ako je igrac napustio organizaciju, momentalno gubi VIP status
    // Igrac dobija 3 dana kaznu/cooldown na VIP, dakle bez obzira koliko poena skupi, nece moci 3 dana da povrati VIP-a


    ///////////////////////////////////////////////////////////////////////////////

    new tresholdUp = PI[playerid][p_division_treshold_up],
        tresholdDn = PI[playerid][p_division_treshold_dn],
        reloadUp = PI[playerid][p_division_reload_up],
        reloadDn = PI[playerid][p_division_reload_dn];

    if (newValue > oldValue && newValue >= 1500)
    {
        // Skill je povecan i izvan Iron divizije

        if (floatround(oldValue/100.0, floatround_floor) < floatround(newValue/100.0, floatround_floor))
        {
            // Igrac je presao stotinu; npr. 1398 -> 1401, 2299 -> 2302, ...

            if (oldValue < tresholdUp && newValue >= tresholdUp)
            {
                // Regularan prelaz u vecu diviziju ILI produzenje trajanja za 3 dana
                // Npr. prvi put ulazi iz Iron u Bronze -> Skill mu je najmanje 1000
                // Postavlja se novi treshold za Up i novi reload za Up
                // TresholdUp se podize za 100; ako je bio 1000 -> 1100, 1100 -> 1200, ... 2200 -> 2300
                PI[playerid][p_division_treshold_dn] = PI[playerid][p_division_treshold_up] - DIVISION_DROP_TOLERANCE;
                PI[playerid][p_division_treshold_up] += 100;
                PI[playerid][p_division_reload_up] = gettime() + 3*86400;
                PI[playerid][p_division_reload_dn] = 0;

                // Produziti trajanje za 3 dana
                #define VIP_DAYS_EXTEND 3
                if (PI[playerid][p_division_expiry] < gettime())
                {
                    PI[playerid][p_division_expiry] = gettime() + VIP_DAYS_EXTEND*86400;
                }
                else
                {
                    PI[playerid][p_division_expiry] += VIP_DAYS_EXTEND*86400;
                }
                SetPlayerDivision(playerid, newValue);
                dbUpdate = true;
            }
            else
            {
                // Ako je treshold bio npr. 1600, igrac je sada presao 1500 ili 1400, ili neku drugu nizu stotinu.
                // Odobriti VIP produzenje samo ako je istekao reload za UP
                if (reloadUp < gettime())
                {
                    // Reload od 3 dana za upskill je prosao
                    if ((newValue % 100) == 0)
                    {
                        PI[playerid][p_division_treshold_up] = newValue + 100;
                    }
                    else
                    {
                        PI[playerid][p_division_treshold_up] = floatround(newValue/100.0, floatround_ceil)*100;
                    }

                    PI[playerid][p_division_reload_up] = gettime() + 3*86400;

                    // Produziti trajanje za 3 dana
                    #define VIP_DAYS_EXTEND 3
                    if (PI[playerid][p_division_expiry] < gettime())
                    {
                        PI[playerid][p_division_expiry] = gettime() + VIP_DAYS_EXTEND*86400;
                    }
                    else
                    {
                        PI[playerid][p_division_expiry] += VIP_DAYS_EXTEND*86400;
                    }
                    SetPlayerDivision(playerid, newValue);
                    dbUpdate = true;
                }
            }
        }
    }

    else if (newValue < oldValue && PI[playerid][p_division_expiry] >= gettime())
    {
        // Skill se smanjio  I  igrac je bio unutar neke vise divizije
        if (newValue < tresholdDn)
        {
            // Igrac je ispod tresholda (npr. ako je treshold bio 1400, sada ima <1385 ili ako je imao 1385, sada ima <1355,...)
            if (reloadDn < gettime())
            {
                // Igrac je izgubio previse poena, a nedavno mu *nije* skraceno trajanje VIP-a -> uciniti to
                PI[playerid][p_division_reload_dn] = gettime() + 86400; // narednih 24h ne moze dobiti skracenje
                PI[playerid][p_division_treshold_dn] -= DIVISION_DROP_TOLERANCE*2; // jos 30 poena tolerancije

                // Skratiti trajanje VIP za 12h
                PI[playerid][p_division_expiry] -= 43200; // 12h
                SetPlayerDivision(playerid, newValue);
                dbUpdate = true;
            }
        }
    }

    if (dbUpdate)
    {
        new query[195];
        format(query, sizeof query, "UPDATE igraci SET division_expiry = %i, division_treshold_up = %i, division_treshold_dn = %i, division_reload_up = %i, division_reload_dn = %i WHERE id = %i", PI[playerid][p_division_expiry], PI[playerid][p_division_treshold_up], PI[playerid][p_division_treshold_dn], PI[playerid][p_division_reload_up], PI[playerid][p_division_reload_dn], PI[playerid][p_id]);
        mysql_tquery(SQL, query);
    }
    return 1;
}

stock SetPlayerDivision(playerid, pts, bool:overrideMsg = false)
{
    new oldDivision = gPlayerDivision[playerid];
    if (PI[playerid][p_division_expiry] < gettime())
    {
        // Istekao mu VIP od divizije
        gPlayerDivision[playerid] = 0;
    }
    else
    {
        #define DIVISION_TRESHOLD_BRONZE    1500
        #define DIVISION_TRESHOLD_SILVER    3000
        #define DIVISION_TRESHOLD_GOLD      4500
        #define DIVISION_TRESHOLD_PLATINUM  6000

        if (pts >= DIVISION_TRESHOLD_PLATINUM)
        {
            gPlayerDivision[playerid] = 4;
        }
        else if (pts >= DIVISION_TRESHOLD_GOLD)
        {
            gPlayerDivision[playerid] = 3;
        }
        else if (pts >= DIVISION_TRESHOLD_SILVER)
        {
            gPlayerDivision[playerid] = 2;
        }
        else if (pts >= DIVISION_TRESHOLD_BRONZE)
        {
            gPlayerDivision[playerid] = 1;
        }
        else
        {
            gPlayerDivision[playerid] = 0;
        }
    }

    if (!overrideMsg)
    {
        if (gPlayerDivision[playerid] != oldDivision)
        {
            new oldStr[9], newStr[9];
            GetDivisionName(oldDivision, oldStr, sizeof oldStr);
            GetDivisionName(gPlayerDivision[playerid], newStr, sizeof newStr);

            // Poslati obavestenje o promeni
            SendClientMessageF(playerid, COLOR_SKILL,  "SKILL {FFFFFF}| Divizija je promenjena: {940025}%s - %s {FFFFFF}| Poeni: {940025}%i", oldStr, newStr, pts);
        }
        
        if (PI[playerid][p_division_expiry] > gettime())
        {
            new exp = PI[playerid][p_division_expiry] - gettime();
            new dy = floatround(exp/86400, floatround_floor);
            new hr = floatround((exp - dy*86400)/3600, floatround_floor);

            SendClientMessageF(playerid, COLOR_SKILL,  "SKILL {FFFFFF}| Trajanje VIP statusa: {940025}%i dana, %i sati", dy, hr);
        }
        else
        {
            SendClientMessage(playerid, COLOR_SKILL,  "SKILL {FFFFFF}| VIP status je prestao da vazi.");
        }
        
    }

    FLAGS_SetupVIPFlags(playerid);
    return 1;
}

GetPlayerDivision(playerid)
{
    return gPlayerDivision[playerid];
}

stock GetDivisionName(division, dest[], len)
{
    if (division == 1) format(dest, len, "Bronze");
    else if (division == 2) format(dest, len, "Silver");
    else if (division == 3) format(dest, len, "Gold");
    else if (division == 4) format(dest, len, "Platinum");
    else format(dest, len, "Iron");
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:skill(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0) // Skill - informacije
    {
        SPD(playerid, "skill_return", DIALOG_STYLE_MSGBOX, "Skill - opste informacije", "{FFFFFF}Uveli smo sistem individualnog napredovanja svakog igraca, kroz koji se ostvaruju razne pogodnosti u igri.\n\nNovac koji svakog sata dolazi u sef bande/mafije od zauzetih teritorija vise ne dolazi u sef, vec se automatski\nravnopravno raspodeljuje svim clanovima koji su online u tom trenutku (na osnovu njihovog skill-a).\nOsim toga, novac od pljacke zlatare/banke ne ide u sef, vec se ravnopravno raspodeljuje svim clanovima koji su\nbili prisutni u zlatari/banci za vreme pljacke.\n\nServer za svakog igraca belezi broj opljackanih bankomata i marketa, kao i broj ukradenih vozila, i taj stats se moze\nvideti preko komande /ucp. Slicno kao kod poslova, te brojke daju dodatne pogodnosti: sto vise opljackanih bankomata imate,\nto ce se vreme potrebno za pljacku smanjivati, a zarada od svakog bankomata ce biti veca. Isto vazi za pljacku marketa i kradju vozila.\n\n\
            {FF0000}RANKOVI\n{FFFFFF}Lider vise nema opciju dodeljivanja rankova svojim clanovima, vec svi krecu od ranka 1, a rank im se dodeljuje na osnovu skill-a.\nZa rank up potrebno je skupiti {FF9900}150 skill poena.\n\n\
            {FF0000}POLICIJA\n{FFFFFF}Policija dobija veca ovlascenja nego sto su ih imali do sada.\n\nPrvo, svi igraci koji imaju WL su policiji oznaceni crvenim markerom na mapi, i prate njihovu lokaciju u realnom vremenu.\nDozvoljeno im je da hapse {FF0000}bez upotrebe /me i /do komandi, {FFFFFF}samo trebaju naci nacin da zaustave kriminalca,\na onda je dovoljno da pridju i stave mu lisice, te da ga odvedu do stanice i stave u zatvor.\nPolicajac dobija novcanu nagradu u skladu sa wanted levelom igraca, a uhapseni igrac dobija novcanu i zatvorsku kaznu,\nopet u skladu sa svojim wanted levelom.", "Nazad", "");
    }

    else if (listitem == 1) // Skill - popis
    {
        if (IsACriminal(playerid))
        {
            SPD(playerid, "skill_return", DIALOG_STYLE_TABLIST, "Skill - popis", "Kradja vozila\t1 poen\n\
                Pljacka marketa\t1 poen\n\
                Pljacka bankomata\t1 poen\n\
                Pljacka zlatare (faza 1)\t3-5 poena\n\
                Pljacka zlatare (faza 2)\t2-5 poena\n\
                Pljacka banke (faza 1)\t3-7 poena\n\
                Pljacka banke (faza 2)\t2-5 poena\n\
                Odbrana teritorije\t2 poena\n\
                Zauzimanje teritorije\t2 poena\n\
                Dzeparenje\t1 poen\n\
                Dzeparenje (zrtva)\t-2 poena\n\
                Obijanje skladista (vagona)\t2 poena\n\
                Gubitak teritorije\t-2 poena\n\
                Napadac napusti teritoriju\t-3 poena\n\
                LTA\t-20 poena", "Nazad", "");
        }
        else if (IsACop(playerid))
        {
            SPD(playerid, "skill_return", DIALOG_STYLE_TABLIST, "Skill - popis", "Hapsenje\t1 poen / 5 WL\n\
                Hapsenje (pljacka zlatare)\t5 poena + 1poen/WL\n\
                Hapsenje (pljacka banke)\t6 poena + 1poen/WL\n\
                Ubistvo igraca sa WL\t1 poen / 10 WL\n\
                Dzeparenje\t-2 poena\n\
                LTA\t-20 poena", "Nazad", "");
        }
        else
        {
            DialogReopen(playerid);
            return ErrorMsg(playerid, "Samo pripadnici organizacija mogu videti popis skill poena.");
        }
    }

    else if (listitem == 2) // Divizije - informacije
    {
        SPD(playerid, "skill_return", DIALOG_STYLE_MSGBOX, "Divizije - opste informacije", "{FFFFFF}Moguce je dobiti {FCE6C4}VIP status {FFFFFF}na osnovu skill-a. Sto vise povecavate svoj skill, menjate svoju poziciju\nna lestvici i diviziju kojoj pripadate. Podela na divizije izgleda ovako:\n  Skill izmedju {FF9900}0-1499: {FF00FF}IRON\n  {FFFFFF}Skill izmedju {FF9900}1500-2999: {FF00CC}BRONZE\n  {FFFFFF}Skill izmedju {FF9900}3000-4499: {FF0099}SILVER\n  {FFFFFF}Skill izmedju {FF9900}4500-5999: {FF0066}GOLD\n  {FFFFFF}Skill {FF9900}6000 i vise: {FF0033}PLATINUM\n\n{FFFFFF}Shodno diviziji u kojoj se nalazite, imacete odgovarajuci VIP level. Ako ste u Bronze diviziji, imacete VIP Bronze, ako ste\nu Gold diviziji imacete VIP Gold, itd. Igraci u Iron diviziji nemaju pravo na VIP status.\n\nKada prvi put steknete pravo na VIP status (udjete u Bronze diviziju, odnosno sakupite Skill 1500), dobicete VIP status na 3 dana.\nKada sakupite jos 100 Skill poena (odnosno kada budete imali 1600, 1700, 1800, ...), VIP vam se produzava svaki put za po 3 dana. \nTo znaci da mozete konstantno imati VIP status ako ste aktivni, a mozete ga i izgubiti zbog neaktivnosti, pa ga dobiti ponovo kad se budete aktivirali.", "Nazad", "");
    }

    return 1;
}

Dialog:skill_return(playerid, response, listitem, const inputtext[])
{
    callcmd::skill(playerid, "");
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:skill(playerid, const params[])
{
    SPD(playerid, "skill", DIALOG_STYLE_LIST, "Skill - informacije", "Skill - opste informacije\nSkill - popis\nDivizije - opste informacije\n", "Odaberi", "Izadji");
    return 1;
}