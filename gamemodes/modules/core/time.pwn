#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    SetTimer("podesi_sat", 5000, true);
}

// hook OnPlayerSpawn(playerid) 
// {
//     TextDrawShowForPlayer(playerid, tdSat);
// }




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward podesi_sat();

public podesi_sat() 
{
    new sat, minut, year, month, day, sMonth[4];
    gettime(sat, minut);
    getdate(year, month, day);

    if (minut == 0) SetWorldTime_H(sat);

    switch (month)
    {
        case 1: sMonth = "Jan";
        case 2: sMonth = "Feb";
        case 3: sMonth = "Mar";
        case 4: sMonth = "Apr";
        case 5: sMonth = "May";
        case 6: sMonth = "Jun";
        case 7: sMonth = "Jul";
        case 8: sMonth = "Aug";
        case 9: sMonth = "Sep";
        case 10: sMonth = "Oct";
        case 11: sMonth = "Nov";
        case 12: sMonth = "Dec";
    }

/*    format(sTime, sizeof sTime, "%02d:%02d", sat, minut);
    TextDrawSetString(tdInfoBox[47], sTime);
    TextDrawSetString(tdInfoBoxModern[15], sTime);
    format(sTime, sizeof sTime, "%02d %s %02d", day, sMonth, year);
    TextDrawSetString(tdInfoBox[48], sTime);
    TextDrawSetString(tdInfoBoxModern[16], sTime);*/


    // Duty Time cuvanje za staff na kraju dana
    if (sat == 23 && minut == 59)
    {
        StaffDutyEndDay();
    }
    return 1;
}

stock konvertuj_vreme(vreme, bool:konvertuj_sate = false) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "kovertuj_vreme");
    #endif

    new string[11];
    if (konvertuj_sate == false) // Ispisi sve u minutima i sekundama (npr 132:22)
    {
        new minuti, sekunde;
        minuti = floatround(vreme/60);
        sekunde = floatround(vreme - minuti*60);
        format(string, sizeof string, "%02d:%02d", minuti, sekunde);
    }
    else { // Ispisi vreme u satima, minutima i sekundama (npr 02:12:22)
        new sati, minuti, sekunde;
        minuti = floatround(vreme/60);
        sekunde = (vreme - minuti*60);
        sati = minuti/60;
        minuti -= sati*60;
        format(string, sizeof string, "%02d:%02d:%02d", sati, minuti, sekunde);
    }
    return string;
}

stock trenutno_vreme(bool:date = true) 
{
    new hour, minute, second, vreme[21];
    gettime(hour, minute, second);

    if (date)
    {
        new day, month, year;
        getdate(year, month, day);
        format(vreme, sizeof vreme, "%02d/%02d/%d, %02d:%02d:%02d", day, month, year, hour, minute, second);
    }
    else
    {
        format(vreme, sizeof vreme, "%02d:%02d:%02d", hour, minute, second);
    }
    return vreme;
}

GetRemainingTime(unixTimestamp, str[20])
{
    new remainingSeconds = unixTimestamp - gettime();
    GetReadableTime(remainingSeconds, str);
}

GetReadableTime(seconds, str[20])
{
    if (seconds < 3600)
    {
        // Ostalo manje od 1 sata
        new mins = floatround(seconds/60.0, floatround_round);
        format(str, sizeof str, "%i minuta", mins);
    }
    else if (seconds < 86400)
    {
        // Ostalo manje od 1 dan
        new hours = floatround(seconds/3600.0, floatround_floor);
        new mins = floatround((seconds - hours*3600)/60.0, floatround_round);
        format(str, sizeof str, "%i sati, %i minuta", hours, mins);
    }
    else
    {
        // Vise od 1 dan
        new days = floatround(seconds/86400.0, floatround_floor);
        new hours = floatround((seconds - days*86400)/3600.0, floatround_round);
        format(str, sizeof str, "%i dana, %i sati", days, hours);
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
