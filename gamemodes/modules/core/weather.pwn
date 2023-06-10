#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define VREMENSKA_INTERVAL (2700000) // Vreme se menja na svakih 45 minuta




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static bool:vremenskaPrognoza;
new tajmer:vremenska;





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    // vremenskaPrognoza = true;
    // weather_SetTimer(VREMENSKA_INTERVAL);

    new h,m,s;
    gettime(h,m,s);
    SetWorldTime_H(h);

    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward T_vremenskaPrognoza();

public T_vremenskaPrognoza() 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "T_vremenskaPrognoza");
    #endif
        
    new naziviVremena[10][10] =
    {
        "Suncano",
        "Kisovito",
        "Suncano",
        "Maglovito",
        "Suncano",
        "Vedro",
        "Vetrovito",
        "Suncano",
        "Oluja",
        "Suncano"
    };

    new x = random(sizeof(naziviVremena));
    format(string_128, 100, "Vesti | Dragi slusaoci, ocekivano vreme za narednih %d minuta je: {00D900}%s.", VREMENSKA_INTERVAL/(60*1000), naziviVremena[x]);
    foreach(new i : Player) 
    {
        if(IsPlayerInAnyVehicle(i)) 
        {
            SendClientMessage(i, 0x00D900C8, "Vesti | Sledi: Vremenska prognoza");
            SendClientMessage(i, BELA, string_128);
        }
    }
    if(!strcmp(naziviVremena[x], "Suncano")) SetWeather_H(0);
    else if(!strcmp(naziviVremena[x], "Kisovito")) SetWeather_H(8);
    else if(!strcmp(naziviVremena[x], "Oblacno")) SetWeather_H(33);
    else if(!strcmp(naziviVremena[x], "Maglovito")) SetWeather_H(9);
    else if(!strcmp(naziviVremena[x], "Vedro")) SetWeather_H(37);
    else if(!strcmp(naziviVremena[x], "Oluja")) 
    {
        new h;
        gettime(h);
        if(h >= 0 && h <= 7) SetWeather_H(8);
        else SetWeather_H(19);
    }
    return 1;
}

stock toggleWeather() 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "toggleWeather");
    #endif
        
    vremenskaPrognoza = !vremenskaPrognoza;
    return 1;
}

stock IsWeatherPredEnabled() 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "IsWeatherPredEnabled");
    #endif
        
    return vremenskaPrognoza? 1 : 0;
}

stock weather_SetTimer(interval = VREMENSKA_INTERVAL) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "weather_SetTimer");
    #endif
        
    tajmer:vremenska = SetTimer("T_vremenskaPrognoza", interval, true);
    return tajmer:vremenska;
}

stock weather_KillTimer() 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "weather_KillTimer");
    #endif
        
    KillTimer(tajmer:vremenska);
    tajmer:vremenska = 0;
    return 1;
}