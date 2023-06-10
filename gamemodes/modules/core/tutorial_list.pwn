#include <YSI_Coding\y_hooks>
static bool: AlreadyOnTutorial[MAX_PLAYERS];
static Float:lastPos[3][MAX_PLAYERS], lastVW[MAX_PLAYERS], lastInt[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
	AlreadyOnTutorial[playerid] = false;
	lastPos[0][playerid] =
	lastPos[1][playerid] =
	lastPos[2][playerid] = 0.0;
	lastInt[playerid] = 
	lastVW[playerid] = 0;
	return true;
}

CMD:tutorial(playerid, const arg[])
{
	SPD(playerid, "tutorial_lista", DIALOG_STYLE_LIST, "{0068B3}[NL] TUTORIJAL", "\
	{FFFFFF}- Glavne Lokacije\n\
	{FFFFFF}- Sistemi pljacke\n\
	{FFFFFF}- Izrada materijala", "Potvrdi", "Izadji");
	return true;
}
CMD:stoptutorial(playerid, arg[])
{
	if (!AlreadyOnTutorial[playerid]) return ErrorMsg(playerid, "Niste na tutorijalu!");
	TogglePlayerSpectating(playerid, false);
	SetPlayerCompensatedPos(playerid, lastPos[0][playerid], lastPos[1][playerid], lastPos[2][playerid]);
	SetPlayerVirtualWorld(playerid, lastVW[playerid]);
	SetPlayerInterior(playerid, lastInt[playerid]);
	SetCameraBehindPlayer(playerid);
	AlreadyOnTutorial[playerid] = false;
	lastPos[0][playerid] =
	lastPos[1][playerid] =
	lastPos[2][playerid] = 0.0;
	lastInt[playerid] = 
	lastVW[playerid] = 0;
	SendClientMessage(playerid, ZELENA2, "Vraceni ste na poziciju na kojoj ste bili pre pocetka tutorijala!");
	return true;
}
Dialog:tutorial_lista(playerid, response, listitem, const inputtext[]) {
	if (!response) return true;
	if (!AlreadyOnTutorial[playerid])
		StartPlayerTutorial(playerid, listitem);
	else ErrorMsg(playerid, "Vi vec gledate neki tutorijal, /stoptutorial.");
	return true;
}

StartPlayerTutorial(playerid, type) {
	AlreadyOnTutorial[playerid] = true;
	SendClientMessage(playerid, ZELENA2, "Zapoceli ste tutorijal!");
	SendClientMessage(playerid, NARANDZASTA, "/stoptutorial {FFFFFF}- Da prekinete tutorijal!");
	GetPlayerPos(playerid, lastPos[0][playerid], lastPos[1][playerid], lastPos[2][playerid]);
	lastInt[playerid] = GetPlayerInterior(playerid);
	lastVW[playerid] = GetPlayerVirtualWorld(playerid);
	SetPlayerVirtualWorld(playerid, playerid + 1000); //iz raznih razloga, nonrp gledanje igraca preko tutorijala, moguce bacanje vozila, nikako tutorijal raditi na vw 0.
	TogglePlayerSpectating(playerid, true);	
	switch (type) {
		case 0: {
			SetTimerEx("tut_lokacije", 2000, false, "ii", playerid, 0);
		}
		case 1: {
			SetTimerEx("tut_kradje", 2000, false, "ii", playerid, 0);
		}
		case 2: {
			SetTimerEx("tut_materijal", 2000, false, "ii", playerid, 0);
		}
	}
	return true;
}
forward tut_materijal(playerid, stage);
public tut_materijal(playerid, stage) {
	if (!IsPlayerConnected(playerid)) return false;	
	if (AlreadyOnTutorial[playerid]) {
		ClearChatForPlayer(playerid); //Ne potrebno je u svaki switch stavljati..
		switch (stage) {
			case 0: {
				SetPlayerCameraPos(playerid, 1039.8757, 2058.0388, 28.0623);
				SetPlayerCameraLookAt(playerid, 1040.2872, 2058.9495, 27.6423);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Prerada materijala ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Prikazana vam je zgrada u kojoj se preradjuje materijal");
				SendClientMessage(playerid, 0x33CCFFFF, "Ovde mozete izraditi bombu ili obraditi materijale");
				SendClientMessage(playerid, 0x33CCFFFF, "Obradjivanje materijala mozete napraviti oruzje i dilovati s njim");
				SetTimerEx("tut_materijal", 12000, false, "ii", playerid, 1);
			}
			case 1: {
				TogglePlayerSpectating(playerid, false);
				SetPlayerCompensatedPos(playerid, lastPos[0][playerid], lastPos[1][playerid], lastPos[2][playerid]);
				SetPlayerVirtualWorld(playerid, lastVW[playerid]);
				SetPlayerInterior(playerid, lastInt[playerid]);
				SetCameraBehindPlayer(playerid);
				AlreadyOnTutorial[playerid] = false;
				lastPos[0][playerid] =
				lastPos[1][playerid] =
				lastPos[2][playerid] = 0.0;
				lastInt[playerid] = 
				lastVW[playerid] = 0;
				SendClientMessage(playerid, ZELENA2, "Vraceni ste na poziciju na kojoj ste bili pre pocetka tutorijala!");
				SendClientMessage(playerid, ZELENA2, "Tutorijal je uspesno zavrsen!");
			}
		}
	}
	return true;
}

forward tut_kradje(playerid, stage);
public tut_kradje(playerid, stage) {
	if (!IsPlayerConnected(playerid)) return false;	
	if (AlreadyOnTutorial[playerid]) {
		ClearChatForPlayer(playerid); //Ne potrebno je u svaki switch stavljati..
		switch (stage) {

			case 0: {
				SetPlayerCameraPos(playerid, 1616.1497, -1247.4041, 30.2257);
				SetPlayerCameraLookAt(playerid, 1615.1464, -1247.4236, 30.0107);
				SendClientMessage(playerid, 0x33CCFFFF, "Uspesno ste pokrenuli tutorijal o 'Sistemima pljacki'");
				SendClientMessage(playerid, 0x33CCFFFF, "Trudicemo se da vam maksimalno objasnimo i predstavimo nase sistema pljacke ili ti roba");
				SetTimerEx("tut_kradje", 6000, false, "ii", playerid, 1); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 1: {
				SetPlayerCameraPos(playerid, -83.7157, -1187.8419, 3.3104);
				SetPlayerCameraLookAt(playerid, -83.1640, -1187.0095, 2.9104);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Pljacka Bankomata ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Kako bi ste opljackali bankomat, potrebno je da se nalazite blizu jednog, prikazan vam je trenutno jedan.");
				SendClientMessage(playerid, 0x33CCFFFF, "Komandom /pljackajatm, zapocinjete pljacku.");
				SendClientMessage(playerid, 0x33CCFFFF, "Morate posedovati oruzje kako bi ste pljackali.");				
				SendClientMessage(playerid, 0x33CCFFFF, "Ukoliko je bankomat vec opljackan moracete sacekati malo!");
				SendClientMessage(playerid, 0x33CCFFFF, "Morate biti u drustvu barem 1 pripadnika svoje mafije/bande da biste pokrenuli pljacku.");
				SendClientMessage(playerid, 0x33CCFFFF, "Brzina obijanja zavisi od vaseg skill-a.");
				SendClientMessage(playerid, 0x33CCFFFF, "Pljackanje traje 90 sekundi, odmah nakon otkucane komande dobijate wanted level.");
				SetTimerEx("tut_kradje", 16000, false, "ii", playerid, 2); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 2: {
				SetPlayerCameraPos(playerid, 1459.1064, -974.9569, 26.5580);
				SetPlayerCameraLookAt(playerid, 1459.2809, -973.9738, 26.4330);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Pljacka Banke ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Potrebno je 3 clana PD-a i 3 clana organizacije online na serveru za pokretanje pljacke.");
				SendClientMessage(playerid, 0x33CCFFFF, "Takodje je potrebno kupiti alatke, busilicu i dinamit na crnom trzistu!");
				SendClientMessage(playerid, 0x33CCFFFF, "Upucaj securitya u banci. Prodji do sefa i postavi busilicu tipkom N.");
				SendClientMessage(playerid, 0x33CCFFFF, "Sacekaj 10 min dok probijes vrata sefa. Kada probijes vrata sefa udji unutra i pokupi novac tipkom N.");
				SendClientMessage(playerid, 0x33CCFFFF, "Nakon toga postavi dinamit na kanalizacioni otvor te se udalji.");
				SendClientMessage(playerid, 0x33CCFFFF, "Nakon 10sec desiti ce se eksplozija i raznosi se saht.");
				SendClientMessage(playerid, 0x33CCFFFF, "Tada idete kroz kanalizaciju do markera gdje birate saht na koji izlazite (random pozicije)");
				SendClientMessage(playerid, 0x33CCFFFF, "Nakon izlaska imati cete marker na vratima svoje organizacije.");
				SendClientMessage(playerid, 0x33CCFFFF, "Potrebno je da dodjete do tamo i pljacka je uspjesna.");
				SendClientMessage(playerid, 0x33CCFFFF, "Novac od pljacke se automatski stavlja u sef organizacije.");
				SendClientMessage(playerid, 0x33CCFFFF, "Svi clanovi koji su blizu dostavljaca novca dobijaju skill up.");
				SendClientMessage(playerid, 0x33CCFFFF, "Ukoliko igrac koji nosi torbu s novcem umre ili napusti server, baciti ce na pod tu torbu koju moze pokupiti ili PD ili Mafija/Banda");
				SendClientMessage(playerid, 0x33CCFFFF, "Nakon sto pokupite dobijate marker koji oznacava vrata vase org");
				SendClientMessage(playerid, 0x33CCFFFF, "Tu morate odnijeti taj novac da, ako ste PD sprijecite, a ako ste mafija/banda da dovrsite pljacku.");
				SetTimerEx("tut_kradje", 26000, false, "ii", playerid, 3); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 3: {
				SetPlayerCameraPos(playerid, 1616.1497, -1247.4041, 30.2257);
				SetPlayerCameraLookAt(playerid, 1615.1464, -1247.4236, 30.0107);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Dzeparenje ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "(Za ovu vrstu pljacke nije postavljena kamera, jer je u pitanju kradja u blizini drugog igraca)");
				SendClientMessage(playerid, 0x33CCFFFF, "Komanda /ukradi, mozete pokusati odzepariti igraca");
				SendClientMessage(playerid, 0x33CCFFFF, "Za ovu vrstu pljacke potreban vam je level 3");
				SetTimerEx("tut_kradje", 10000, false, "ii", playerid, 4);
			}
			case 4: {
				SetPlayerCameraPos(playerid, 892.9424, -1352.3683, 6.0597);
				SetPlayerCameraLookAt(playerid, 893.4973, -1351.5378, 5.9347);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Pljacka Zlatare ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Potrebna vam je bomba za ovu vrstu pljacke");
				SendClientMessage(playerid, 0x33CCFFFF, "/pljackajzlataru - Komandom, pokrecete pljacku zlatare!");
				SetTimerEx("tut_kradje", 10000, false, "ii", playerid, 5);
			}
			case 5: {
				TogglePlayerSpectating(playerid, false);
				SetPlayerCompensatedPos(playerid, lastPos[0][playerid], lastPos[1][playerid], lastPos[2][playerid]);
				SetPlayerVirtualWorld(playerid, lastVW[playerid]);
				SetPlayerInterior(playerid, lastInt[playerid]);
				SetCameraBehindPlayer(playerid);
				AlreadyOnTutorial[playerid] = false;
				lastPos[0][playerid] =
				lastPos[1][playerid] =
				lastPos[2][playerid] = 0.0;
				lastInt[playerid] = 
				lastVW[playerid] = 0;
				SendClientMessage(playerid, ZELENA2, "Vraceni ste na poziciju na kojoj ste bili pre pocetka tutorijala!");
				SendClientMessage(playerid, ZELENA2, "Tutorijal je uspesno zavrsen!");
			}

		}
	}
	return true;
}
forward tut_lokacije(playerid, stage);
public tut_lokacije(playerid, stage) {
	if (!IsPlayerConnected(playerid)) return false;	
	if (AlreadyOnTutorial[playerid]) {
		ClearChatForPlayer(playerid); //Ne potrebno je u svaki switch stavljati..
		switch (stage) {

			case 0: {
				SetPlayerCameraPos(playerid, 1616.1497, -1247.4041, 30.2257);
				SetPlayerCameraLookAt(playerid, 1615.1464, -1247.4236, 30.0107);
				SendClientMessage(playerid, 0x33CCFFFF, "Uspesno ste pokrenuli tutorijal o 'Glavnim lokacijama'");
				SendClientMessage(playerid, 0x33CCFFFF, "Jako nam je bitno da budete upuceni o lokacijama na serveru");
				SendClientMessage(playerid, 0x33CCFFFF, "kako bi ste se lakse snalazili, za 5 sekundi, bice vam prikazane lokacije");
				SendClientMessage(playerid, 0x33CCFFFF, "koje su bitne za vas RolePlay, i igru. Tutorijal ce trajati 72 sekunde.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 1); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 1: {
				SetPlayerCameraPos(playerid, 1467.4946, -1047.5348, 33.1583);
				SetPlayerCameraLookAt(playerid, 1467.2435, -1046.5632, 33.0333);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Banka ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Banka je jedna od najposecenijih lokacija na nasem serveru.");
				SendClientMessage(playerid, 0x33CCFFFF, "Sama svrha banke je ocuvanje vaseg stecenog novca. ");
				SendClientMessage(playerid, 0x33CCFFFF, "Radno vreme banke je od 9:00 do 1:00.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 2); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 2: {
				SetPlayerCameraPos(playerid, 1518.6804, -1680.1045, 15.2234);
				SetPlayerCameraLookAt(playerid, 1519.6257, -1679.7642, 15.1984);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Policija ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Policija takodje spada u najposecenije lokacije servera.");
				SendClientMessage(playerid, 0x33CCFFFF, "U policiji mozete placati kazne, kaucije itd, ostale opcije mozete pronaci na salteru u istoj.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 3); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 3: {
				SetPlayerCameraPos(playerid, 1467.4946, -1047.5348, 33.1583);
				SetPlayerCameraLookAt(playerid, 1467.2435, -1046.5632, 33.0333);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Bolnica ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Kao i prethodne lokacije bolnica je na isti nacin bitna lokacija servera,");
				SendClientMessage(playerid, 0x33CCFFFF, "ovde cete se nalaziti nakon smrti i mozete se leciti na slateru u istoj.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 4); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 4: {
				SetPlayerCameraPos(playerid, 1225.4331, -940.6323, 51.4620);
				SetPlayerCameraLookAt(playerid, 1224.9547, -939.7484, 51.2870);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Burg ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Ovde se mozete nahraniti, druziti sa prijateljima i provoditi slobodno vreme,");
				SendClientMessage(playerid, 0x33CCFFFF, "burg takodje spada u bitne lokacije servera i samim tim glavnim mestom za obrok i pice.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 5); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 5: {
				SetPlayerCameraPos(playerid, 1346.5171, -1281.8186, 20.5661);
				SetPlayerCameraLookAt(playerid, 1347.5157, -1281.7026, 20.4461);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Gun Shop ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Nakon sto nabavite dozvolu za oruzje, mozete posetiti nas glavni Gun Shop na serveru.");
				SendClientMessage(playerid, 0x33CCFFFF, "Gun Shop ili ti Ammunation je mesto gde mozete legalno nabaviti oruzje i municiju.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 6); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 6: {
				SetPlayerCameraPos(playerid, 1854.0154, -1416.6356, 22.6295);
				SetPlayerCameraLookAt(playerid, 1853.0863, -1417.0181, 22.2648);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Tech store ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Tech store ili Electronic Shop mesto je gde mozete kupovati elektroniku.");
				SendClientMessage(playerid, 0x33CCFFFF, "Nalazi se pored samog skejt parka naseg servera.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 7); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 7: {
				SetPlayerCameraPos(playerid, 909.4853, -1726.4225, 21.6382);
				SetPlayerCameraLookAt(playerid, 910.4716, -1726.2319, 21.4485);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Auto salon ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Auto salon je mesto gde mozete kada navrsite dovoljan level, i skupite novac,");
				SendClientMessage(playerid, 0x33CCFFFF, "kupiti svoje privatno vozilo.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 8); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 8: {
				SetPlayerCameraPos(playerid, 900.6939, -1300.8862, 30.2730);
				SetPlayerCameraLookAt(playerid, 900.4948, -1301.8707, 29.9083);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Zlatara ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Zlatara je mesto gde mozete kupovati ili prodavati vase zlato.");
				SendClientMessage(playerid, 0x33CCFFFF, "Pripazite se zlatare su cesta meta mafijasa!");
				SendClientMessage(playerid, 0x33CCFFFF, "Radno vreme zlatare je od 8:00 - 2:00");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 9); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 9: {
				SetPlayerCameraPos(playerid, 1497.3340, -1722.4882, 22.6027);
				SetPlayerCameraLookAt(playerid, 1496.9014, -1723.3945, 22.5180);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Opstina ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Opstina je takodje jedna od najposecenijih lokacija, iz razloga");
				SendClientMessage(playerid, 0x33CCFFFF, "sto se u njoj vrsi na salteru davanje otkaza i ostale druge opcije");
				SendClientMessage(playerid, 0x33CCFFFF, "koje ona pruza.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 10); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 10: {
				SetPlayerCameraPos(playerid, 1079.3583, -1730.7286, 27.0945);
				SetPlayerCameraLookAt(playerid, 1079.4370, -1729.7280, 26.8697);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Auto Skola ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "U auto skoli, mozete uplatiti polaganje za vise kategorija, auto, motor, kamion i ostalo.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 11); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 11: {
				SetPlayerCameraPos(playerid, 1006.4469, -1303.9587, 35.1168);
				SetPlayerCameraLookAt(playerid, 1006.4962, -1304.9609, 34.5920);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Pijaca / Trznica ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Pijaca ili Trznica je mesto gde mozete trgovati vasim vockama koje posedujete.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 12); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 12: {
				SetPlayerCameraPos(playerid, 1824.3783, -1889.8193, 25.6456);
				SetPlayerCameraLookAt(playerid, 1823.5719, -1890.4172, 25.3908);
				SendClientMessage(playerid, NARANDZASTA, "- - - - - - - - - ( Autobuska i Zeleznicka stanica ) - - - - - - - - -");
				SendClientMessage(playerid, 0x33CCFFFF, "Ovde mozete iskoristiti drumski ili zeleznicki saobracaj kao prevoz na odredjene lokacije.");
				SetTimerEx("tut_lokacije", 6000, false, "ii", playerid, 13); //uvek slagati igraca zbog pinga i packetloss-a znaci uvek za sekundu vise od navedenog u tekstu
			}
			case 13: {
				TogglePlayerSpectating(playerid, false);
				SetPlayerCompensatedPos(playerid, lastPos[0][playerid], lastPos[1][playerid], lastPos[2][playerid]);
				SetPlayerVirtualWorld(playerid, lastVW[playerid]);
				SetPlayerInterior(playerid, lastInt[playerid]);
				SetCameraBehindPlayer(playerid);
				AlreadyOnTutorial[playerid] = false;
				lastPos[0][playerid] =
				lastPos[1][playerid] =
				lastPos[2][playerid] = 0.0;
				lastInt[playerid] = 
				lastVW[playerid] = 0;
				SendClientMessage(playerid, ZELENA2, "Vraceni ste na poziciju na kojoj ste bili pre pocetka tutorijala!");
				SendClientMessage(playerid, ZELENA2, "Tutorijal je uspesno zavrsen!");
			}
		}
	}
	return true;
}