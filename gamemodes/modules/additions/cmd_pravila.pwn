CMD:pravila(playerid, const params[])
{
    SPD(playerid, "pravila", DIALOG_STYLE_LIST, "{FFFF00}PRAVILA SERVERA", "(1) DeathMatch / RevengeKill\n(2) Pljacke i teritorije\n(3) Policija / hapsenja\n(4) Pravila za oglase\n(5) MetaGaming / PowerGaming (RPS)\n(6) Ostala pravila", "Izaberi", "Izadji");
    return 1;
}

Dialog:pravila(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0)
    {
        // DeathMatch / RevengeKill
        ShowRulesDialog_DM_RK(playerid, cinc[playerid]);
    }
    else if (listitem == 1)
    {
        // Pljacke i teritorije
        ShowRulesDialog_TURF_ROB(playerid, cinc[playerid]);
    }
    else if (listitem == 2)
    {
        // Pljacke i teritorije
        ShowRulesDialog_POLICE(playerid, cinc[playerid]);
    }
    else if (listitem == 3)
    {
        // Pravila za oglase
        ShowRulesDialog_ADS(playerid, cinc[playerid]);
    }
    else if (listitem == 4)
    {
        // MetaGaming / PowerGaming (RPS)
        ShowRulesDialog_MG_PG(playerid, cinc[playerid]);
    }
    else if (listitem == 5)
    {
        // Ostala pravila
        ShowRulesDialog_OTHER(playerid, cinc[playerid]);
    }
    return 1;
}

Dialog:pravila_1(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pravila(playerid, "");

    else
        return ShowRulesDialog_TURF_ROB(playerid, cinc[playerid]);
}

Dialog:pravila_2(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pravila(playerid, "");

    else
        return ShowRulesDialog_POLICE(playerid, cinc[playerid]);
}

Dialog:pravila_3(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pravila(playerid, "");

    else
        return ShowRulesDialog_ADS(playerid, cinc[playerid]);
}

Dialog:pravila_4(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pravila(playerid, "");

    else
        return ShowRulesDialog_MG_PG(playerid, cinc[playerid]);
}

Dialog:pravila_5(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return callcmd::pravila(playerid, "");

    else
        return ShowRulesDialog_OTHER(playerid, cinc[playerid]);
}

Dialog:pravila_6(playerid, response, listitem, const inputtext[])
{
    return callcmd::pravila(playerid, "");
}

forward ShowRulesDialog_DM_RK(playerid, ccinc);
public ShowRulesDialog_DM_RK(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_1", DIALOG_STYLE_MSGBOX, "{FFCC00}(1) DeathMatch / RevengeKill", "\
        {FF9900}DEATH MATCH (DM)\n\
        ------------\n\
        {FFFFFF}- DM je dozvoljen iskljucivo na teritorijama za clanove organizacija.\n\
        - Pucanje na PD/FBI bez RP razloga (ili iz cista mira) je zabranjeno.\n\
        - Pucanje na civile je zabranjeno.\n\
        - Pucanje na igrace koji rade posao je zabranjeno, bez obzira na njihovu pripadnost organizaciji/mafiji/bandi.\n\
        - Zabranjeno je raditi Spawn Kill - pucati na igraca odmah kada se spawna ili udje/izadje iz enterijera.\n\
        - Zabranjeno je ubijati druge igrace na imanjima\n\
        - Civilima sa manje od 20 sati igre je zabranjeno nosenje oruzja.\n\n\
        \
        {FF9900}DRIVE BY (DB)\n\
        ------------\n\
        {FFFFFF}- Zabranjeno je oboriti vozilom drugog igraca.\n\
        - Zabranjeno je ubiti igraca tako sto stanete vozilom preko njega.\n\
        - Zabranjeno je pucanje i ubijanje pesaka iz vozila.\n\
        - Policiji je dozvoljeno da pucaju iz vozila na drugo vozilo samo kada jure igraca sa Wanted Levelom.\n\
        - Mafijama i bandama je dozvoljeno pucanje iz vozila na policijsko vozilo, samo ako imaju WL i beze od policije.\n\n\
        \
        {FF9900}REVENGE KILL (RK)\n\
        ------------\n\
        {FFFFFF}- Revenge Kill je dozvoljeno raditi na aktivnim teritorijama (onima koje vasa mafija/banda napada/brani).\n\
        - Revenge Kill je zabranjeno raditi u svim ostalim situacijama, a posebno tokom pljacke banke/zlatare.", "Dalje -", "- Nazad");
    return 1;
}

forward ShowRulesDialog_TURF_ROB(playerid, ccinc);
public ShowRulesDialog_TURF_ROB(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_2", DIALOG_STYLE_MSGBOX, "{FFCC00}(2) Pljacke i teritorije", "\
        {FF9900}BANKA / ZLATARA: {FFA347}PLJACKA I SPRECAVANJE PLJACKE\n\
        ------------\n\
        {FFFFFF}- Za sprecavanje pljacke, potrebno je minimum 3 pripadnika PD/FBI. Niko ne sme sam pokusati da zaustavi pljacku.\n\
        - PD/FBI je u obavezi da pokusa da pregovara sa pljackasima pre otvaranja vatre.\n\
        -   Ukoliko pljackasi odbiju saradnju, dozvoljeno je otvoriti vatru i krenuti u napad.\n\
        -   Ukoliko pljackasi prvi otvore vatru, policija nije u obavezi da pregovara.\n\
        - PD/FBI se ne sme zaleteti i tazovati pljackasa dok njegovi saucesnici pucaju na njih.\n\
        -   Potrebno je najpre \"resiti\" sve njih, pa tek onda zaustaviti pljacku.\n\
        - Ukoliko jedna mafija/banda pljacka banku/zlataru, druge se smiju mijesati te pokusati ukrasti novac.\n\
        - Za pljacku je potrebno minimum 3 clana. \n\
        - Ukoliko clanovi PD/FBI primete da se pljackasi okupljaju i spremaju da zapocnu pljacku, {DB4D4D}zabranjeno {FFFFFF}je hapsiti dok pljacka ne pocne.\n\
        -   Eventualno mozete obavestiti kolege da se pripreme, ali nikako sprecavati pljacku pre nego sto ona pocne.\n\
        - Zabranjeno je raditi Team Kill (ubijanje svojih saigraca).\n\
        - Kada pljacka banke zapocne druge mafije/bande ne smiju ulaziti u interijer,ali nakon izlaska kroz kanalizacijske otvore mogu loviti pljackasa u pokusaju da mu preuzmu novac i odvedu u svoju bazu, cime bi oni dobili novac i pljacka bi zavrsila.\n\
        - U slucaju da PD ubije pljackasa i uzme torbu oni imaju zadatak tu torbu dostaviti u PD bazu, kako bi uspijesno odbranili banku. Mafije /bande  mogu takodjer oteti policiji novac!\n\
        - Na pljackama je dopusteno PD-u i mafijama/bandama da se sa helikopterom popnu na zgrade povise banke i koriste snajper.\n\
        - Dopusteno je samo mafiji/bandi koja pljacka da podigne svoje helikoptere,ostale orge ne smiju!\n\n\
        \
        {FF9900}PRAVILA NA TERITORIJAMA\n\
        ------------\n\
        {FFFFFF}- Podizanje saigraca pomocu repa helikoptera na nepristupacne zgrade i uzvisenja je zabranjeno.\n\
        -   Penjanje na objekte je dozvoljeno iskljucivo skakanjem.\n\
        - Zabranjeno je ulaziti u vodu i koristiti animacije.\n\
        - Zabranjeno je da PD/FBI ulaze na teritoriju koja se zauzima (vidi se prema blinkanju na mapi).\n\
        - Zabranjeno je raditi Team Kill (ubijanje svojih saigraca).\n\
        - Hapsenje na teritorijama je dozvoljeno ukoliko se one u tom trenutku ne zauzimaju.\n\
        - Na teritorijama je dozvoljen DM samo za clanove organizacija.\n\n\
        \
        {FF9900}PRAVILA ZA OTMICE\n\
        ------------\n\
        {FFFFFF}- Nije dozvoljeno traziti otkup preko {FF0000}$50.000 {FFFFFF}za otetog igraca.", "Dalje -", "- Nazad");
        
    return 1;
}

forward ShowRulesDialog_POLICE(playerid, ccinc);
public ShowRulesDialog_POLICE(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_3", DIALOG_STYLE_MSGBOX, "{FFCC00}(3) Policija / hapsenja", "\
        {FF9900}PRAVILA ZA HAPSENJE IGRACA\n\
        ------------\n\
        {FFFFFF}- Za tokom hapsenja ili koje prethode hapsenju nije potrebno koristiti /me i /do komande (dozvoljeno je, ali nije obavezujuce).\n\
        - Za hapsenje je potrebno samo pronaci nacin da zaustavite kriminalca, a onda hapsenje odraditi na RP nacin, uz IC komunikaciju.\n\
        - Taz na gun je zabranjen (trcanje ka igracu koji vas puca, te sokiranje tazerom).\n\
        -   Trebalo bi \"prisunjati\" se igracu sa ledja, pa ga onda sokirati.\n\
        - Zabranjeno je cekati igrace ispred spawna/bolnice/zatvora i hapsiti/kontrolisati ih cim se spawnaju.", "Dalje -", "- Nazad");
    return 1;
}

forward ShowRulesDialog_ADS(playerid, ccinc);
public ShowRulesDialog_ADS(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_4", DIALOG_STYLE_MSGBOX, "{FFCC00}(4) Pravila za oglase", "\
        {FF9900}OGLASI\n\
        ------------\n\
        {FFFFFF}- Dozvoljeno je oglasavanje prodaje i kupovine pokretne i nepokretne imovine (odnosno vozila i nekretnina), kao i svih stvari koje se mogu nositi u rancu.\n\
        - Oglasi se mogu koristiti za promovisanje usluga (poslovi, prostitutke i slicno).\n\
        - Upotreba oglasa u bilo koje druge svrhe je kaznjiva.", "Dalje -", "- Nazad");
    return 1;
}

forward ShowRulesDialog_MG_PG(playerid, ccinc);
public ShowRulesDialog_MG_PG(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_5", DIALOG_STYLE_MSGBOX, "{FFCC00}(5) MetaGaming / PowerGaming (RPS)", "\
        {FF9900}META GAMING (MG)\n\
        ------------\n\
        {FFFFFF}- MetaGaming (MG) je obavezno postovati u sledecim situacijama:\n\
        ---  Kod pljacke banke / zlatare;\n\
        ---  Prilikom rutinske kontrole, hapsenja i bilo kakve interakcije sa policijom / osumnjicenim;\n\
        ---  Prilikom kidnapovanja (otmice).\n\n\
        \
        {FF9900}POWER GAMING (PG)\n\
        ------------\n\
        {FFFFFF}- Zabranjeno je stajati na vozilu u pokretu.\n\
        - Zabranjeno je pucati sa vozila u pokretu.\n\
        - Zabranjeno je skakati sa BMX-om (kaznjava se ako to radite dok vas juri policija).\n\
        - Zabranjen je {FF0000}svaki oblik {FFFFFF}PG-a tokom otmice / kidnapovanja.\n\
        - Zabranjeno je za policiju tokom pljacke trcati na robera dok vas pucaju sa svih strana.\n\
        - Zabranjeno je za policiju raditi taz na gun.\n\
        - U svim situacijama je dozvoljeno trcati iako ste upucani, nije obavezno RP-ati da ste ranjeni.", "Nazad", "");

    return 1;
}

forward ShowRulesDialog_OTHER(playerid, ccinc);
public ShowRulesDialog_OTHER(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    SPD(playerid, "pravila_6", DIALOG_STYLE_MSGBOX, "{FFCC00}(1)(6) Ostala pravila", "{FFFFFF}\
        - Zabranjeno je raditi Spawn Kill - pucati na igraca odmah kada se spawna ili udje/izadje iz enterijera.\n\
        - Zabranjeno je pucati u okolini bolnice i na plantazi za marihuanu.\n\
        - Zabranjeno je raditi LTA.\n\
        - Zabranjeno je koristiti animacije prilikom borbe za teritoriju.\n\n\
        - Zabranjeno je bilo kakvo vredjanje i provociranje, sa izuzetkom u IC chatu prilikom RP-anja.\n\
        - Komanda /askq sluzi da novi igraci traze pomoc od Helpera.\n\
        - Komanda /report sluzi da Adminima prijavite igrace koji krse pravila.\n\
        - Zabranjene je {FF0000}bilo kakva vrsta prevare {FFFFFF}koja ukljucuje imovinu i novac na serveru (IC/OOC).\n\
        - Ako se od njih zatrazi provjera duzni su dati adminu desk, ako odbiju ide kazna/jail!", "Dalje -", "- Nazad");
    return 1;
}