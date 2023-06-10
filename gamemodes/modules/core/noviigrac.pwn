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
//                      <section> Callback-ovi </section>                     //
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

Dialog:noviigrac_zadatci(playerid, response, listitem, const inputtext[])
{
    
    new query[256];
    if(!response) return 1;

    if(listitem == 0) {
        if(PI[playerid][p_pasos_bonus] == 0) {
            if(PI[playerid][p_pasos] > 0 ){
                PlayerMoneyAdd(playerid, 5000);
                PI[playerid][p_pasos_bonus] = 1;

                format(query, sizeof(query), "UPDATE igraci SET p_pasos_bonus = '%d', novac = '%d' WHERE id = '%i'", PI[playerid][p_pasos_bonus], PI[playerid][p_novac], PI[playerid][p_id]);
                mysql_tquery(SQL, query);
            } else {
                ErrorMsg(playerid, "Nemate pasos!");
            }
        } else {
            ErrorMsg(playerid, "Vec ste ovo iskoristili!");
        }
    }
    else if(listitem == 1) {
        if(PI[playerid][p_vozacka_bonus] == 0) {
            if(PI[playerid][p_dozvola_voznja] > 0) {

                PlayerMoneyAdd(playerid, 5000);
                PI[playerid][p_vozacka_bonus] = 1;

                format(query, sizeof(query), "UPDATE igraci SET p_vozacka_bonus = '%d', novac = '%d' WHERE id = '%i'", PI[playerid][p_vozacka_bonus], PI[playerid][p_novac], PI[playerid][p_id]);
                mysql_tquery(SQL, query);

            } else {
                ErrorMsg(playerid, "Nemate vozacku dozvolu!");
            }
        } else {
            ErrorMsg(playerid, "Vec ste ovo iskoristili!");
        }
    }
    else if(listitem == 2) {
        if(PI[playerid][p_posao_bonus] == 0) {
            if(PI[playerid][p_posao_zarada] > 100) {

                PlayerMoneyAdd(playerid, 5000);
                PI[playerid][p_posao_bonus] = 1;

                format(query, sizeof(query), "UPDATE igraci SET p_posao_bonus = '%d', novac = '%d' WHERE id = '%i'", PI[playerid][p_posao_bonus], PI[playerid][p_novac], PI[playerid][p_id]);
                mysql_tquery(SQL, query);
            } else {
                ErrorMsg(playerid, "Nisi radio niti jedan posao!");
            }
        } else {
            ErrorMsg(playerid, "Vec ste ovo iskoristili!");
        }
    }
    else if(listitem == 3) {
        if(PI[playerid][p_nivo_bonus] == 0) {
            if(PI[playerid][p_nivo] >= 3) {

                PlayerMoneyAdd(playerid, 5000);
                PI[playerid][p_nivo_bonus] = 1;

                format(query, sizeof(query), "UPDATE igraci SET p_nivo_bonus = '%d', novac = '%d' WHERE id = '%i'", PI[playerid][p_nivo_bonus], PI[playerid][p_novac], PI[playerid][p_id]);
                mysql_tquery(SQL, query);

            } else {
                ErrorMsg(playerid, "Niste dosegli level 3!");
            }
        } else {
            ErrorMsg(playerid, "Vec ste ovo iskoristili!");
        }
    }
    else if(listitem == 4) {
        if(PI[playerid][p_org_bonus] == 0) {
            if(PI[playerid][p_org_id] > 0) {

                PlayerMoneyAdd(playerid, 5000);
                PI[playerid][p_org_bonus] = 1;

                format(query, sizeof(query), "UPDATE igraci SET p_org_bonus = '%d', novac = '%d' WHERE id = '%i'", PI[playerid][p_org_bonus], PI[playerid][p_novac], PI[playerid][p_id]);
                mysql_tquery(SQL, query);

            } else {
                ErrorMsg(playerid, "Niste u organizaciji!");
            }
        } else {
            ErrorMsg(playerid, "Vec ste ovo iskoristili!");
        }
    }
	return 1;
}


// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //

/*CMD:noviigrac(playerid, const params[])
{
    if(PI[playerid][p_nivo] < 5) return ErrorMsg(playerid, "Ovo mogu koristiti igraci ispod levela 4.");

    SPD(playerid, "noviigrac_zadatci", DIALOG_STYLE_LIST, "ZADATCI ZA NOVE IGRACE", "Napraviti pasos(5000$)\nIzraditi vozacku dozvolu(5000$)\nZaposliti se(5000$)\nPostignuti nivo 3(10000$)\nPridruziti se organizaciji(10000$)\n","Uredu", "Izadji");

    return 1;
}*/