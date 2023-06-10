alias:update("changelog")
CMD:update(playerid, const params[])
{
    SPD(playerid, "changelog", DIALOG_STYLE_LIST, "{FFFFFF}UPDATE v5.0 >> {0099FF}by z1ann", "{FFFFFF}[ > ] v5.0 {0099FF}(BugFix & Novosti)", "Ok", "");
    return 1;
}

Dialog:changelog(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new string[3600];
    format(string, sizeof string, "{0099FF}%s  -  Sta je novo?\n_____________________________________", inputtext);


    if (listitem == 0) // v5.0
    {
        // FIXES
        format(string, sizeof string, "%s\n\n{0099FF}NL v5.0 Update\n{FFFFFF}", string);
        format(string, sizeof string, "%s{0099FF}[1.] >> {FFFFFF}Osvjezen label na spawnu, osnovni prikaz informacija o serveru.\n", string);
        format(string, sizeof string, "%s{0099FF}[2.] >> {FFFFFF}Vrhovnoj komandi dodijeljene odredjene administratorske komande.\n", string);
        format(string, sizeof string, "%s{0099FF}[3.] >> {FFFFFF}Kretanje igraca prebaceno u 'CJ' stil.\n", string);
        format(string, sizeof string, "%s{0099FF}[4.] >> {FFFFFF}Osvjezenje dialoga i texta za bolji pregled i dizajn.\n", string);
        format(string, sizeof string, "%s{0099FF}[5.] >> {FFFFFF}Optimizovano cuvanje i ucitavanje podataka.\n", string);
        format(string, sizeof string, "%s{0099FF}[6.] >> {FFFFFF}Novi igraci od sada imaju 20 sati i level 2.\n", string);
        format(string, sizeof string, "%s{0099FF}[7.] >> {FFFFFF}Ubacena mapa organizacije 'La Cocaina'.\n", string);
        format(string, sizeof string, "%s{0099FF}[8.] >> {FFFFFF}Kreirana organizacija 'La Cocaina'.\n", string);
        format(string, sizeof string, "%s{0099FF}[9.] >> {FFFFFF}Enterijeri organizacija optimizovani za bolje ucitavanje.\n", string);
        format(string, sizeof string, "%s{0099FF}[10.] >> {FFFFFF}Nova mapa VLA baze.\n", string);
        format(string, sizeof string, "%s{0099FF}[11.] >> {FFFFFF}Izbacen posao 'Ribar'.\n", string);
        format(string, sizeof string, "%s{0099FF}[12.] >> {FFFFFF}Izbacen'Tube Race'.\n", string);
        format(string, sizeof string, "%s{0099FF}[13.] >> {FFFFFF}Nagrade promoterima povecane na '1000$'.\n", string);
        format(string, sizeof string, "%s{0099FF}[14.] >> {FFFFFF}Nova mapa DM arene.\n", string);
        format(string, sizeof string, "%s{0099FF}[15.] >> {FFFFFF}Popravljen bug prilikom pristupanja DM areni.\n", string);
        format(string, sizeof string, "%s{0099FF}[16.] >> {FFFFFF}Cijena pasosa smanjena na 10.000$.\n", string);

        format(string, sizeof string, "%s\n\n{0099FF}Credits: z1ann", string);
    }
    else return 1;

    new sTitle[32];
    format(sTitle, sizeof sTitle, "Changelog: %s", inputtext);
    SPD(playerid, "changelog_return", DIALOG_STYLE_MSGBOX, inputtext, string, "Ok", "");
    return 1;
}



Dialog:changelog_return(playerid, response, listitem, const inputtext[])
{
    return 1;//PC_EmulateCommand(playerid, "/update");
}

// CMD:update(playerid, const params[])
// {
	// #define LATEST_VERSION "v3.026"

	// if (strcmp(LATEST_VERSION, MOD_VERZIJA))
	// 	return ErrorMsg(playerid, "Skripter nije napisao nikakve detalje o trenutnoj verziji moda.");

	
    


    // IZDVOJENO
    // format(string, sizeof string, "%s\n\n{BA3268}LUCKY ONE\n{FFFFFF}", string);
    // format(string, sizeof string, "%s- Svoj broj je moguce uplatiti samo na odredjenom mestu (do sada je moglo globalno). Koristite /gps za lokaciju.\n{FFFFFF}", string);
    // format(string, sizeof string, "%s- Moguce je uplatiti samo 1 broj za jedno izvlacenje, a cena je $1.000, kao i do sada.\n{FFFFFF}", string);
    // format(string, sizeof string, "%s- Svaki put kada dobitnik ne bude izvucen, sav uplacen iznos se prenosi u naredno izvlacenje.\n{FFFFFF}", string);
    // format(string, sizeof string, "%s- Kada nakon nekoliko neuspelih izvlacenja bude izvucen pobednik, on odnosi celokupan Jackpot koji se sastoji od svih do tada uplacenih brojeva.\n{FFFFFF}", string);


    /*
    // IZDVOJENO
    format(string, sizeof string, "%s\n\n{FFFF00}PRODAJA DROGE\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Mafije i bande mogu prodati vece kolicine droge (preko 100g) na crno trziste i zaraditi novac.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Lokaciju za pocetak eventa mozete saznati od prostitutke - \"lokacija za pakovanje droge\".\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Event mozete pokrenuti samo izmedju 19h i 21h (u tom periodu ga morate i zavrsiti).\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Potrebno je da igrac spakuje minimum 100g heroina i mdme zajedno da bi tu drogu mogao prodati.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Kada je spakuje, dobice instrukcije gde treba da ode kako bi izvrsio prodaju.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Ukoliko igrac pogine tokom transporta, paket sa drogom ispada na zemlju i moze ga pokupiti bilo ko.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Ukoliko paket pokupi clan policije, on dobija CP unutar policijske stanice, gde treba da odnese paket.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Za uspesno donesen paket policija dobija novcanu nagradu u budzet organizacije.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- 100 grama droge placa se oko $800.000.\n{FFFFFF}", string);


    // IZDVOJENO
    format(string, sizeof string, "%s\n\n{33CCFF}MASINOVODJA\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Za posao je potreban nivo 7, plata je oko $10.000.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Posao se {FF0000}mora raditi u paru sa drugim igracem {FFFFFF}(vozac i kondukter).\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Vozac upravlja vozom, a kondukter silazi na svakoj stanici i skuplja kofere, te ih ubacuje u voz.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- Oba igraca moraju zavrsiti celu rutu da bi dobili platu.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- {FF0000}Postoji samo 1 voz, tako da posao u svakom trenutku moze raditi samo jedan par igraca.\n{FFFFFF}", string);
    format(string, sizeof string, "%s- {FF9900}U checkpointe morate uci sa {FF0000}malom brzinom!\n{FFFFFF}", string);
    */


    // IZDVOJENO 2
    // if (IsHelper(playerid, 1))
    // {
    //     format(string, sizeof string, "%s\n\n{33CCFF}HELPER / ADMIN\n{FFFFFF}", string);
    //     format(string, sizeof string, "%s- Helper 3 ima dozvolu za /spec\n{FFFFFF}", string);
    //     format(string, sizeof string, "%s- Komande /area i /utisaj prebacene na A4\n{FFFFFF}", string);
    //     format(string, sizeof string, "%s- Dodata komanda /kazni za A1\n{FFFFFF}", string);
    //     format(string, sizeof string, "%s- Dodata komanda /fine za A6\n{FFFFFF}", string);
    // }

	// #undef LATEST_VERSION

// 	return 1;
// }
