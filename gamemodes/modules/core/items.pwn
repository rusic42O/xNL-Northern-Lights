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
new tajmer:items_VehicleFixing[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    tajmer:items_VehicleFixing[playerid] = 0;
}

hook OnPlayerStateChange(playerid, newstate, oldstate)
{
    if (!BP_PlayerHasItem(playerid, ITEM_HELMET)) return 1;

    if (newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if (IsVehicleMotorbike(GetVehicleModel(GetPlayerVehicleID(playerid))))
        {
            switch(GetPlayerSkin(playerid))
            {
                #define SPAO{%0,%1,%2,%3,%4,%5} SetPlayerAttachedObject(playerid, SLOT_HELMET, 18645, 2, (%0), (%1), (%2), (%3), (%4), (%5));
                case 0, 65, 74, 149, 208, 273:  SPAO{0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000}
                case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: SPAO{0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000}
                case 7, 10: SPAO{0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 9: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 11..13: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
                case 15: SPAO{0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 17..21: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: SPAO{0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 40: SPAO{0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 50, 100..103, 148, 150..189, 222: SPAO{0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 51..54: SPAO{0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 59..62: SPAO{0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 77: SPAO{0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000}
                case 85, 88, 89: SPAO{0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 90..97: SPAO{0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 132: SPAO{0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 144..146: SPAO{0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 220: SPAO{0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 223, 246: SPAO{0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000}
                case 224..245: SPAO{0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 294: SPAO{0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000}
                case 295: SPAO{0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000}
                case 296..298: SPAO{0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
                case 299: SPAO{0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
            }
        }
    }
    else
    {
        RemovePlayerAttachedObject(playerid, SLOT_HELMET);
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward items_VehicleFixing(playerid, ccinc);
public items_VehicleFixing(playerid, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("items_VehicleFixing");
    }

    if (!checkcinc(playerid, ccinc) || !IsPlayerInAnyVehicle(playerid)) return 1;

    TogglePlayerControllable_H(playerid, true);
    SetVehicleHealth(GetPlayerVehicleID(playerid), 500.0);
    GameTextForPlayer(playerid, "~g~Popravka zavrseno~n~~w~Vozilo je popravljeno", 3500, 3);
    tajmer:items_VehicleFixing[playerid] = 0;
    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:ipod(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        switch (listitem)
        {
            case 0: PlayAudioStreamForPlayer(playerid, "http://balkan.dj.topstream.net:8070");
            case 1: PlayAudioStreamForPlayer(playerid, "http://naxi128.streaming.rs:9150");
            case 2: PlayAudioStreamForPlayer(playerid, "http://pink.exyuserver.com/listen.pls");
            case 3: PlayAudioStreamForPlayer(playerid, "http://stream.playradio.rs:8001/play.mp3");
            case 4: PlayAudioStreamForPlayer(playerid, "http://streaming.tdiradio.com/tdiradiobezreklama.mp3");

            case 5: PlayAudioStreamForPlayer(playerid, "http://176.9.30.66:80");
            case 6: PlayAudioStreamForPlayer(playerid, "http://136.243.21.140:9998");
            case 7: PlayAudioStreamForPlayer(playerid, "http://195.201.112.14:9010");
            case 8: PlayAudioStreamForPlayer(playerid, "http://sradio1.ipradio.rs:9000");
            case 9: PlayAudioStreamForPlayer(playerid, "http://streaming.hitfm.rs:8000");

        }
        // SetPVarInt(playerid, "pUsingIpod", 1);
        SendClientMessageF(playerid, BELA, "Izabrali ste radio stanicu {33AA33}%s. {FFFFFF}Za iskljucivanje koristite {33AA33}/ipod off.", inputtext);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:ipod("radio")
//alias:popravi("popravka");

CMD:ipod(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_IPODNANO) && !BP_PlayerHasItem(playerid, ITEM_IPODCLASSIC))
        return ErrorMsg(playerid, "Ne posedujete MP3 player (iPod), mozete ga kupiti u tech store-u.");

    if (!isnull(params) && !strcmp(params, "off", true))
    {
        StopAudioStreamForPlayer(playerid);
        SendClientMessage(playerid, BELA, "iPod je iskljucen.");
        return 1;
    }

    if (BP_PlayerHasItem(playerid, ITEM_IPODCLASSIC)) // Ima bolji iPod -> vise stanica
    {
        SPD(playerid, "ipod", DIALOG_STYLE_LIST, "IZABERITE STANICU", "Balkan DJ\nNaxi\nPink\nPlay\nTDI\nCool\nBanovina\nMix\nRadio S\nHit FM", "Play", "Izadji");
    }
    else if (BP_PlayerHasItem(playerid, ITEM_IPODNANO)) // Losiji iPod -> manje stanica
    {
        SPD(playerid, "ipod", DIALOG_STYLE_LIST, "IZABERITE STANICU", "Balkan DJ\nNaxi\nPink\nPlay\nTDI", "Play", "Izadji");
    }
    return 1;
}

CMD:popravi(playerid, const params[])
{
    if (!BP_PlayerHasItem(playerid, ITEM_ALAT))
        return ErrorMsg(playerid, "Ne posedujete alat za popravku vozila.");

    if (tajmer:items_VehicleFixing[playerid] != 0)
        return ErrorMsg(playerid, "Popravka vozila je vec u toku.");

    if (!IsPlayerInAnyVehicle(playerid))
        return ErrorMsg(playerid, "Ne nalazite se u vozilu.");

    new engine, lights, alarm, doors, bonnet, boot, objective,
        vehicleid = GetPlayerVehicleID(playerid),
        Float:health;

    if (IsVehicleBicycle(GetVehicleModel(vehicleid)))
        return ErrorMsg(playerid, "Ne mozete popraviti bicikl.");

    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (engine == 1)
        return ErrorMsg(playerid, "Motor vozila mora biti ugasen.");

    GetVehicleHealth(vehicleid, health);
    if (health > 500)
        return ErrorMsg(playerid, "Mozete popraviti vozilo samo ako ima manje od 500 hp.");

    BP_PlayerItemSub(playerid, ITEM_ALAT);
    TogglePlayerControllable_H(playerid, false);
    GameTextForPlayer(playerid, "~b~Popravka vozila je u toku~n~~w~molimo sacekajte...", 3500, 3);
    tajmer:items_VehicleFixing[playerid] = SetTimerEx("items_VehicleFixing", 5000, false, "ii", playerid, cinc[playerid]);
    return 1;
}