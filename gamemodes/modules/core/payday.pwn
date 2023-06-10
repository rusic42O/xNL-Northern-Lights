#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PAYDAY_MINS             (55) // Na koliko minuta igrac dobija platu




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_PAYDAY_DATA
{
    PAYDAY_SALARY,
    PAYDAY_SAVINGS,
    PAYDAY_JOB_INCOME,
    PAYDAY_EXP_ELECTRICITY,
    PAYDAY_EXP_WATER,
    PAYDAY_EXP_GARBAGE,
    PAYDAY_EXP_HOTEL,
    PAYDAY_EXP_RENT,
    PAYDAY_EXP_LOAN,
    PAYDAY_EXP_LUXURY,
    PAYDAY_EXP_BILLS_TOTAL,
    PAYDAY_EXP_TOTAL,
    PAYDAY_INCOME_TOTAL,
    PAYDAY_BANK_PREV,
    PAYDAY_KREDIT_IZNOS,
    PAYDAY_KREDIT_RATA,
    PAYDAY_KREDIT_OTPLATA,

    bool:PAYDAY_AVAILABLE,
    bool:PAYDAY_LEVELUP,
    bool:PAYDAY_DOUBLE_EXP,
    bool:PAYDAY_TRIPLE_EXP,
    bool:PAYDAY_LOAN_PAIDOFF,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new PaydayData[MAX_PLAYERS][E_PAYDAY_DATA];
new 
    paydayPlaytime[MAX_PLAYERS],
    payday_ETA_TS[MAX_PLAYERS],
    // payday_RestoreTime[MAX_PLAYERS],
    tajmer:payday[MAX_PLAYERS];





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid) 
{
    tajmer:payday[playerid] = paydayPlaytime[playerid] /*= payday_RestoreTime[playerid]*/ = 0;
    PaydayData[playerid][PAYDAY_AVAILABLE] = false;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    if (tajmer:payday[playerid] != 0)
    {
        KillTimer(tajmer:payday[playerid]);
        // PI[playerid][p_payday] += gettime() - paydayPlaytime[playerid];
        // ovo gore je premesteno u glavni fajl NLRPGv3.pwn pod OnPlayerDisconnect, prilikom cuvanja podataka
    }
    return true;
}

hook OnPlayerSpawn(playerid) 
{
    if (tajmer:payday[playerid] == 0)
    {
        if (PI[playerid][p_payday] < 0)
        {
            PI[playerid][p_payday] = 0;
        }
        else if (PI[playerid][p_payday] > PAYDAY_MINS*60)
        {
            PI[playerid][p_payday] = PAYDAY_MINS * 60;
        }

        payday_ETA_TS[playerid] = gettime() + (PAYDAY_MINS*60 - PI[playerid][p_payday]);
        tajmer:payday[playerid] = SetTimerEx("payday_Check", 60000, true, "ii", playerid, cinc[playerid]);
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward payday_Check(playerid, ccinc);
public payday_Check(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc) || !IsPlayerLoggedIn(playerid)) return 1;

    if (gettime() >= payday_ETA_TS[playerid])
    {
        // Vreme je da se primi plata
        payday(playerid);
    }
    return 1;
}

stock PAYDAY_GetTimeLeft(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("PAYDAY_GetTimeLeft");
    }

    new eta = payday_ETA_TS[playerid],
        time = PAYDAY_MINS*60 - (eta - gettime());
    
    if (time < 0 || time > 3600) time = PAYDAY_MINS*60;

    return time;
}

// stock PAYDAY_PlayerWentAFK(playerid)
// {
//     payday_RestoreTime[playerid] = payday_ETA_TS[playerid] - gettime();
//     payday_ETA_TS[playerid] += PAYDAY_MINS * 60;
// }

// stock PAYDAY_PlayerCameBack(playerid)
// {
//     payday_ETA_TS[playerid] = gettime() + payday_RestoreTime[playerid];
// }
forward payday(playerid);
public payday(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("payday");
    }

    // tajmer:payday[playerid] = 0;
    PI[playerid][p_payday] = paydayPlaytime[playerid] = 0;
    AKTIGRA_PtsInc(playerid, 1);
    AKTIGRA_Check(playerid);


    new
        Float:interestRate = 0.001,
        Float:factorElectricity = 0.0,
        Float:factorWater = 0.0,
        Float:factorGarbage = 0.0; // smece

    GetVIPInterestRate(playerid, interestRate);


    PaydayData[playerid][PAYDAY_SALARY] = 
    PaydayData[playerid][PAYDAY_SAVINGS] = 
    PaydayData[playerid][PAYDAY_JOB_INCOME] = 
    PaydayData[playerid][PAYDAY_EXP_ELECTRICITY] = 
    PaydayData[playerid][PAYDAY_EXP_WATER] = 
    PaydayData[playerid][PAYDAY_EXP_GARBAGE] = 
    PaydayData[playerid][PAYDAY_EXP_HOTEL] = 
    PaydayData[playerid][PAYDAY_EXP_RENT] = 
    PaydayData[playerid][PAYDAY_EXP_LOAN] = 
    PaydayData[playerid][PAYDAY_EXP_LUXURY] = 
    PaydayData[playerid][PAYDAY_EXP_BILLS_TOTAL] = 
    PaydayData[playerid][PAYDAY_EXP_TOTAL] = 
    PaydayData[playerid][PAYDAY_INCOME_TOTAL] = 
    PaydayData[playerid][PAYDAY_KREDIT_IZNOS] = 
    PaydayData[playerid][PAYDAY_KREDIT_RATA] = 
    PaydayData[playerid][PAYDAY_KREDIT_OTPLATA] = 0;

    PaydayData[playerid][PAYDAY_BANK_PREV] = PI[playerid][p_banka];

    PaydayData[playerid][PAYDAY_LEVELUP] = 
    PaydayData[playerid][PAYDAY_DOUBLE_EXP] = 
    PaydayData[playerid][PAYDAY_TRIPLE_EXP] = 
    PaydayData[playerid][PAYDAY_LOAN_PAIDOFF] = false;

    // --------------- [ OBRACUN PRIHODA] ---------------

    // faktor_poeni = 1 + floatround(floatdiv((payday_bodovi  - payday_limit), 3600), floatround_floor);
    //     faktor_posao = 1 + floatround(floatdiv(fake_odradjeno, 900), floatround_floor);
    //     prihod_poeni = 15 + random(10) * faktor_poeni;
    //     prihod_posao = 40 + random(30) * faktor_posao;

    new Float:calc;

    if(PI[playerid][p_odradio_posao] > 4) calc = (PI[playerid][p_posao_payday] * 0.10) * (PI[playerid][p_odradio_posao] * 0.20);
    else calc = PI[playerid][p_posao_payday] * 0.10;

    PaydayData[playerid][PAYDAY_JOB_INCOME] = floatround(calc); // 10% zaradjenog novca na poslu izmedju 2 paydaya
    PaydayData[playerid][PAYDAY_SALARY] = 1000 + (PI[playerid][p_nivo] * 500);
    PaydayData[playerid][PAYDAY_SAVINGS] = floatround(PI[playerid][p_banka] * interestRate);

    if (PaydayData[playerid][PAYDAY_SAVINGS] < 0) PaydayData[playerid][PAYDAY_SAVINGS] = 0;
    if (PaydayData[playerid][PAYDAY_SAVINGS] > 50000) PaydayData[playerid][PAYDAY_SAVINGS] = 50000;

    PaydayData[playerid][PAYDAY_INCOME_TOTAL] = PaydayData[playerid][PAYDAY_JOB_INCOME] + PaydayData[playerid][PAYDAY_SALARY] + PaydayData[playerid][PAYDAY_SAVINGS];

    PI[playerid][p_odradio_posao] = 0;

    // --------------- [ OBRACUN RASHODA] ---------------

    if (pRealEstate[playerid][kuca] != -1) 
    {
        switch (RealEstate[re_globalid(kuca, pRealEstate[playerid][kuca])][RE_VRSTA])
        {
            case 1: // Prikolica
            {
                factorElectricity   += 4.0;
                factorGarbage       += 0.75;
                factorWater         += 2.0;
            }
            case 2: // Mala kuca
            {
                factorElectricity   += 7.00;
                factorGarbage       += 1.65;
                factorWater         += 3.75;
            }
            case 3: // Srednja kuca
            {
                factorElectricity   += 9.50;
                factorGarbage       += 2.0;
                factorWater         += 5.0;
            }
            case 4: // Velika kuca
            {
                factorElectricity   += 12.00;
                factorGarbage       += 2.20;
                factorWater         += 6.50;
            }
            case 5: // Vila
            {
                factorElectricity   += 15.0;
                factorGarbage       += 3.0;
                factorWater         += 8.0;
            }
        }
    }

    if (pRealEstate[playerid][stan] != -1) 
    {
        factorElectricity   += 2.00;
        factorGarbage       += 0.40;
        factorWater         += 1.00;
    }
    
    if (pRealEstate[playerid][garaza] != -1) 
    {
        factorElectricity   += 8.20;
        factorGarbage       += 2.20;
        factorWater         += 3.80;
    }
    
    if (pRealEstate[playerid][vikendica] != -1) 
    {
        factorElectricity   += 4.00;
        factorGarbage       += 8.20;
        factorWater         += 5.00;
    }
    
    if (pRealEstate[playerid][firma] != -1)
    {
        switch (RealEstate[re_globalid(firma, pRealEstate[playerid][firma])][RE_VRSTA])
        {
            case FIRMA_PRODAVNICA:      factorElectricity += 6.50;
            case FIRMA_ORUZARNICA:      factorElectricity += 12.75;
            case FIRMA_TECHNOLOGY:      factorElectricity += 20.00;
            case FIRMA_HARDWARE:        factorElectricity += 20.00;
            case FIRMA_RESTORAN:        factorElectricity += 2.25;
            case FIRMA_KAFIC:           factorElectricity += 2.00;
            case FIRMA_BAR:             factorElectricity += 1.50;
            case FIRMA_DISKOTEKA:       factorElectricity += 2.50;
            case FIRMA_BUTIK:           factorElectricity += 1.00;
            case FIRMA_SEXSHOP:         factorElectricity += 1.00;
            case FIRMA_BURGERSHOT:      factorElectricity += 4.75;
            case FIRMA_PIZZASTACK:      factorElectricity += 1.50;
            case FIRMA_CLUCKINBELL:     factorElectricity += 1.25;
            case FIRMA_RANDYSDONUTS:    factorElectricity += 1.00;
            case FIRMA_TERETANA:        factorElectricity += 3.50;
            case FIRMA_SECURITYSHOP:    factorElectricity += 20.75;
            case FIRMA_PIJACA:          factorElectricity += 1.80;
            case FIRMA_RENTACAR:        factorElectricity += 1.00;
            case FIRMA_KIOSK:           factorElectricity += 0.70;
            case FIRMA_BENZINSKA:       factorElectricity += 6.50;
            case FIRMA_POSAO:           factorElectricity += 10.00;
            case FIRMA_APOTEKA:         factorElectricity += 8.00;
            case FIRMA_MEHANICAR:       factorElectricity += 5.00;
            case FIRMA_TUNING:          factorElectricity += 30.00;
            case FIRMA_DRUGO:           factorElectricity += 7.0;
            case FIRMA_BOLNICA:         factorElectricity += 2.0;
            case FIRMA_ACCESSORY:       factorElectricity += 6.8;
            case FIRMA_RADIO:           factorElectricity += 15.0;
            default:                    factorElectricity += 3.00;
        }
        
        factorGarbage += 2;
        factorWater   += 4;
    }
    
    if (pRealEstate[playerid][hotel] != -1)
    {
        new broj_stanara = 0;
        for__loop (new i = 0; i < RealEstate[re_globalid(hotel, pRealEstate[playerid][hotel])][RE_SLOTOVI]; i++)
        {
            if (RE_HOTELS[pRealEstate[playerid][hotel]][i][rh_player_id] != INVALID_PLAYER_ID)
                broj_stanara ++;
        }
        
        factorElectricity   += 1.0 + 0.8*broj_stanara;
        factorGarbage       += 0.5 + 0.2*broj_stanara;
        factorWater         += 0.8 + 0.4*broj_stanara;
    }

    if (factorElectricity > 0 || factorGarbage > 0 || factorWater > 0) 
    {
        PaydayData[playerid][PAYDAY_EXP_ELECTRICITY] = floatround(factorElectricity * (100 + random(35)));
        PaydayData[playerid][PAYDAY_EXP_GARBAGE]     = floatround(factorGarbage * (70 + random(35)));
        PaydayData[playerid][PAYDAY_EXP_WATER]       = floatround(factorWater * (80 + random(35)));
    }

    if (PI[playerid][p_rent_kuca] > 0 && PI[playerid][p_rent_cena] > 0)
    {
        PaydayData[playerid][PAYDAY_EXP_RENT] = PI[playerid][p_rent_cena];
        RE_HouseAddMoney(re_globalid(kuca, PI[playerid][p_rent_kuca]), PaydayData[playerid][PAYDAY_EXP_RENT]);
    }

    // Porez na luksuz
    new vehTotalValue = 0;
    for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++)
    {
        if (pVehicles[playerid][i] > 0)
        {
            vehTotalValue += OwnedVehicle[pVehicles[playerid][i]][V_PRICE];
        }
    }
    if (vehTotalValue >= 750000)
    {
        // Oporezuju mu se vozila ako su vredna preko 750k
        
        if ((PI[playerid][p_banka] + PI[playerid][p_novac]) > 10000000 || vehTotalValue >= 8000000)
        {
            // Veci porez ako igrac ima preko 10 miliona *ILI* ako su mu vozila vredna preko 8000000
            PaydayData[playerid][PAYDAY_EXP_LUXURY] = floatround(vehTotalValue / 350.0, floatround_ceil);
        }
        else
        {
            PaydayData[playerid][PAYDAY_EXP_LUXURY] = floatround(vehTotalValue / 1000.0, floatround_ceil);
        }
    }


    PaydayData[playerid][PAYDAY_EXP_TOTAL] = PaydayData[playerid][PAYDAY_EXP_BILLS_TOTAL] = PaydayData[playerid][PAYDAY_EXP_ELECTRICITY] + PaydayData[playerid][PAYDAY_EXP_WATER] + PaydayData[playerid][PAYDAY_EXP_GARBAGE] + PaydayData[playerid][PAYDAY_EXP_RENT] + PaydayData[playerid][PAYDAY_EXP_LUXURY];
    
    // Rashodi za iznajmljivanje sobe TODO
    new hotelid = re_globalid(hotel, PI[playerid][p_hotel_soba]);
    if (PI[playerid][p_hotel_soba] != -1 && PI[playerid][p_hotel_cena] > 0 && RealEstate[hotelid][RE_CENA_SOBE] > 0 && RealEstate[hotelid][RE_CENA_SOBE] < 65535)
    {
        if ((PI[playerid][p_banka] + PaydayData[playerid][PAYDAY_INCOME_TOTAL] - PaydayData[playerid][PAYDAY_EXP_TOTAL]) >= RealEstate[hotelid][RE_CENA_SOBE])
        {
            // Ima dovoljno da plati sobu
            PaydayData[playerid][PAYDAY_EXP_HOTEL] = RealEstate[hotelid][RE_CENA_SOBE];
            PaydayData[playerid][PAYDAY_EXP_TOTAL] += PaydayData[playerid][PAYDAY_EXP_HOTEL];

            RealEstate[hotelid][RE_NOVAC] += RealEstate[hotelid][RE_CENA_SOBE];

            new query[256];
            format(query, sizeof query, "UPDATE re_hoteli SET novac = %i WHERE id = %i", RealEstate[hotelid][RE_NOVAC], PI[playerid][p_hotel_soba]);
            mysql_tquery(SQL, query);
        }
        else
        {
            // Nema da plati sobu -> izbaci ga
            PI[playerid][p_hotel_soba] = -1;
            PI[playerid][p_hotel_cena] = 0;
            
            // Slanje poruke igracu
            SendClientMessage(playerid, TAMNOCRVENA, "* Izbaceni ste iz hotela jer nemate novca da platite sobu.");
        
            // Promena spawna
            dialog_respond:spawn(playerid, 1, 0, "");

            format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET hotel_soba = -1, hotel_cena = 0 WHERE id = %d", PI[playerid][p_id]);
            mysql_tquery(SQL, mysql_upit);

            format(mysql_upit, sizeof mysql_upit, "DELETE FROM re_hoteli_stanari WHERE player_id = %d", PI[playerid][p_id]);
            mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_HOTEL_DELETE);
        }
    }
    

    // Rashodi za kredit
    if (strcmp(PI[playerid][p_kartica], "N/A") && PI[playerid][p_kredit_iznos] > 0 && PI[playerid][p_kredit_otplata] > 0)
    {
        if (PI[playerid][p_kredit_rata] < 0)
            PI[playerid][p_kredit_rata] = 1000; // za svaki slucaj, anti-abuse
                
            
        if ((PI[playerid][p_banka] - PaydayData[playerid][PAYDAY_EXP_BILLS_TOTAL] + PaydayData[playerid][PAYDAY_INCOME_TOTAL]) >= PI[playerid][p_kredit_rata]) // Ima dovoljno da plati ratu
        {
            if (PI[playerid][p_kredit_rata] < PI[playerid][p_kredit_otplata]) // Rata u je manja od iznosa koji treba da otplati
            {
                PaydayData[playerid][PAYDAY_EXP_LOAN] = PI[playerid][p_kredit_rata];
                PI[playerid][p_kredit_otplata] -= PI[playerid][p_kredit_rata];
            //    PlayerMoneySub_ex(playerid, PI[playerid][p_kredit_rata], true);               
            }
            else // Rata mu je veca nego sto mu je ostalo da otplati, igrac ce otplatiti kredit na ovom payday-u
            {
                PaydayData[playerid][PAYDAY_EXP_LOAN] = PI[playerid][p_kredit_otplata];
              //  PlayerMoneySub_ex(playerid, PI[playerid][p_kredit_rata], true);
                PI[playerid][p_kredit_iznos]    = 0;
                PI[playerid][p_kredit_otplata]  = 0;
                PI[playerid][p_kredit_rata]     = 0;

                PaydayData[playerid][PAYDAY_LOAN_PAIDOFF] = true;
            }
            
            PaydayData[playerid][PAYDAY_EXP_TOTAL] += PaydayData[playerid][PAYDAY_EXP_LOAN];
        }
        else
        {
            PaydayData[playerid][PAYDAY_EXP_LOAN] = 0;
        }

        PaydayData[playerid][PAYDAY_KREDIT_IZNOS]   = PI[playerid][p_kredit_iznos];
        PaydayData[playerid][PAYDAY_KREDIT_RATA]    = PI[playerid][p_kredit_rata];
        PaydayData[playerid][PAYDAY_KREDIT_OTPLATA] = PI[playerid][p_kredit_otplata];

        PlayerMoneySub_ex(playerid, PaydayData[playerid][PAYDAY_KREDIT_RATA], true);
    }


    // --------------------------------------------------
    // Level up / exp up
    new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
    PI[playerid][p_iskustvo] ++;

    // happy hours
    if (PI[playerid][p_nivo] <= HAPPY_HOURS_LEVEL_MAX || HappyHours() || IsVIP(playerid, 1))
    {
        PI[playerid][p_iskustvo] ++;
        PaydayData[playerid][PAYDAY_DOUBLE_EXP] = true;

        if (IsVIP(playerid, 3))
        {
            PI[playerid][p_iskustvo] ++;
            PaydayData[playerid][PAYDAY_TRIPLE_EXP] = true;
        }
    }

    if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
    {
        PI[playerid][p_nivo]++;
        SetPlayerScore(playerid, PI[playerid][p_nivo]);
        PaydayData[playerid][PAYDAY_LEVELUP] = true;
        PI[playerid][p_iskustvo] -= nextLevelExp;
    }

    
    // --------------------------------------------------

    if (PI[playerid][p_novac] < 0)
    {
        // Ne prima platu ako ima negativan iznos u rukama
        PaydayData[playerid][PAYDAY_SALARY] = 0;
        PaydayData[playerid][PAYDAY_SAVINGS] = 0;
        PaydayData[playerid][PAYDAY_JOB_INCOME] = 0;
        PaydayData[playerid][PAYDAY_INCOME_TOTAL] = 0;
    }

    BankMoneyAdd(playerid, PaydayData[playerid][PAYDAY_INCOME_TOTAL]-PaydayData[playerid][PAYDAY_EXP_TOTAL]);

    //if(PI[playerid][p_banka] < 1000000) { DodajNovacUBanku(300); PI[playerid][p_banka] -= 300;}
    //else if(PI[playerid][p_banka] > 1000000 && PI[playerid][p_banka] < 3000000) { DodajNovacUBanku(600); PI[playerid][p_banka] -= 600;}
    //else if(PI[playerid][p_banka] > 3000000 && PI[playerid][p_banka] < 6000000) { DodajNovacUBanku(1000); PI[playerid][p_banka] -= 1000;}
    //else { DodajNovacUBanku(1500); PI[playerid][p_banka] -= 1500;}

    PI[playerid][p_provedeno_vreme] ++;

    // Update podataka u bazi
    new sQuery[512];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %d, iskustvo = %d, posao_payday = 0, payday = 0, kredit_otplata = %d, kredit_iznos = %d, kredit_rata = %d, provedeno_vreme = %d WHERE id = %d", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_kredit_otplata], PI[playerid][p_kredit_iznos], PI[playerid][p_kredit_rata], PI[playerid][p_provedeno_vreme], PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery);


    PI[playerid][p_posao_payday] = 0;
    // tajmer:payday[playerid] = SetTimerEx("payday", PAYDAY_MINS*60*1000, false, "ii", playerid, cinc[playerid]);
    

    payday_ETA_TS[playerid] = gettime() + PAYDAY_MINS*60;

    PaydayData[playerid][PAYDAY_AVAILABLE] = true;

    SendClientMessageF(playerid, -1, "{FF8080}OBAVIJEST O RASHODIMA // {FFFFFF}Struja: {FF8080}%s  {FFFFFF}|  Voda: {FF8080}%s  {FFFFFF}|  Smece: {FF8080}%s", formatMoneyString(PaydayData[playerid][PAYDAY_EXP_ELECTRICITY]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_WATER]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_GARBAGE]));
    SendClientMessageF(playerid, -1, "{FFFFFF}Kirija: {FF8080}%s  {FFFFFF}|  Hotelska soba: {FF8080}%s", formatMoneyString(PaydayData[playerid][PAYDAY_EXP_RENT]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_HOTEL]));
    SendClientMessageF(playerid, -1, "{FFFFFF}Porez na luksuz: {FF8080}%s\n{FF8080}UKUPNO: %s", formatMoneyString(PaydayData[playerid][PAYDAY_EXP_LUXURY]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_BILLS_TOTAL]));
    
    if (PI[playerid][p_novac] < 0)
    {
        SendClientMessage(playerid, SVETLOCRVENA, "** Imas negativan iznos u rukama, pa je zarada 0 (ili negativna zbog racuna).");
    }

    // Logovanje zbog pracenja
    new sLog[128];
    format(sLog, sizeof sLog, "%s | Prihodi: %s | Rashodi: %s | Zarada: %s", ime_obicno[playerid], formatMoneyString(PaydayData[playerid][PAYDAY_INCOME_TOTAL]), 
        formatMoneyString(PaydayData[playerid][PAYDAY_EXP_TOTAL]), 
        formatMoneyString(PaydayData[playerid][PAYDAY_INCOME_TOTAL]-PaydayData[playerid][PAYDAY_EXP_TOTAL]));
    Log_Write(LOG_PAYDAY, sLog);
    return 1;
}

stock payday_GetETA_TS(playerid)
{
    return payday_ETA_TS[playerid];
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:payday(playerid, response, listitem, const inputtext[]) 
{
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:payday(playerid, const params[])
{
    if (!PaydayData[playerid][PAYDAY_AVAILABLE])

        return ErrorMsg(playerid, "Jos uvek niste primili platu otkad ste usli u igru.");

    new string[790];
    format(string, sizeof string, "{FF8282}Banka Los Santosa  |  Izvestaj");

    format(string, sizeof string, "%s\n\n\n{FF8080}RASHODI\n______________________\n{FFFFFF}Struja: {FF8080}%s  {FFFFFF}|  Voda: {FF8080}%s  {FFFFFF}|  Smece: {FF8080}%s\n{FFFFFF}Kirija: {FF8080}%s  {FFFFFF}|  Hotelska soba: {FF8080}%s\n{FFFFFF}Porez na luksuz: {FF8080}%s\n{FF8080}UKUPNO: %s", string, formatMoneyString(PaydayData[playerid][PAYDAY_EXP_ELECTRICITY]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_WATER]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_GARBAGE]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_RENT]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_HOTEL]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_LUXURY]), formatMoneyString(PaydayData[playerid][PAYDAY_EXP_BILLS_TOTAL]));


    if (PaydayData[playerid][PAYDAY_EXP_LOAN] != 0) 
    {
        format(string, sizeof string, "%s\n\n\n{8080FF}KREDIT\n______________________\n", string);

        if (PaydayData[playerid][PAYDAY_LOAN_PAIDOFF])
        {
            format(string, sizeof string, "%s{00FF00}Cestitamo, otplatili ste kredit!", string);
        }
        else
        {
            format(string, sizeof string, "%s{FFFFFF}Iznos kredita: {8080FF}%s  {FFFFFF}|  Iznos rate: {8080FF}%s\n{FFFFFF}Preostalo za otplatu: {8080FF}%s", string, formatMoneyString(PaydayData[playerid][PAYDAY_KREDIT_IZNOS]), formatMoneyString(PaydayData[playerid][PAYDAY_KREDIT_RATA]), formatMoneyString(PaydayData[playerid][PAYDAY_KREDIT_OTPLATA]));
        }

    }

    format(string, sizeof string, "%s\n\n\n{FFFFFF}______________________\nPrethodno stanja racuna: {FF8080}%s\n{FFFFFF}Novo stanje racuna: {80FF80}%s", string, formatMoneyString(PaydayData[playerid][PAYDAY_BANK_PREV]), formatMoneyString(PaydayData[playerid][PAYDAY_BANK_PREV] + PaydayData[playerid][PAYDAY_INCOME_TOTAL] - PaydayData[playerid][PAYDAY_EXP_TOTAL]));

    if (PaydayData[playerid][PAYDAY_LEVELUP]) // Level up
    {
        format(string, sizeof string, "%s\n\n\n{FFFF00}______________________\n ***  LEVEL UP  ***\nCestitamo, presli ste na sledeci nivo!\n{FFFFFF}Sada ste nivo {FFFF00}%d.", string, PI[playerid][p_nivo]);
    }
    else 
    {
        new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
        format(string, sizeof string, "%s\n{FFFFFF}Nivo: {33CCFF}%d  {FFFFFF}|  Iskustvo: {33CCFF}%d/%d", string, PI[playerid][p_nivo], PI[playerid][p_iskustvo], nextLevelExp);
    }
    // Happy hours
    if (PaydayData[playerid][PAYDAY_DOUBLE_EXP])
    {
        if (PaydayData[playerid][PAYDAY_TRIPLE_EXP])
        {
            format(string, sizeof string, "%s\n{33CCFF}** Dobili ste trostruke poene iskustva! (VIP)", string);
        }
        else
        {
            format(string, sizeof string, "%s\n{33CCFF}** Dobili ste duple poene iskustva! (%s)", string, (IsVIP(playerid, 1)? ("VIP") : ("happy hours")));
        }
    }

    SPD(playerid, "payday", DIALOG_STYLE_MSGBOX, "{FF8282}LS Banka", string, "{FFFFFF}U redu", "");
    return 1;
}