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





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward PlayTutorial(playerid, ccinc, stage);
public PlayTutorial(playerid, ccinc, stage)
{
	if (!checkcinc(playerid, ccinc)) return 1;

	ClearChatForPlayer(playerid);
	if (stage == 1)
	{
		SetPlayerCameraPos(playerid, 1416.3256,-940.5312,109.1835);
		SetPlayerCameraLookAt(playerid, 1458.2017,-810.8207,80.7183);

		SendClientMessage(playerid, SVETLOPLAVA,  "Dobrodosao na Northern Lights RP!");
		SendClientMessage(playerid, BELA, 		"- Pre nego sto pocnes sa igrom, zelimo da ti predstavimo neke vaznije lokacije na serveru.");
		SendClientMessage(playerid, BELA, 		"- Sve lokacije koje ovde vidis, mozes ponovo pronaci preko komande {FFFF00}/gps.");

		stage = 2;
		SetTimerEx("PlayTutorial", 15000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 2)
	{
		SetPlayerCameraPos(playerid, 1455.4006,-1719.5956,49.2775);
		SetPlayerCameraLookAt(playerid, 1499.2323,-1757.6641,13.5483);

		SendClientMessage(playerid, 0x0068B3FF,   "OPSTINA I POSLOVI");
		SendClientMessage(playerid, BELA, 		"- Da bi se zaposlio, moras otici u opstinu i odabrati neki posao sa spiska.");
		SendClientMessage(playerid, BELA, 		"- Za pocetak ti predlazemo kosaca trave ili pizzaboy.");
		SendClientMessage(playerid, BELA, 		"- Svaki posao ima svoj {FF0000}skill {FFFFFF}- sto vise radis, veca ce biti i plata!");
		SendClientMessage(playerid, BELA, 		" ");
		SendClientMessage(playerid, BELA, 		"- U opstini takodje mozes izvaditi pasos ili registrovati svoje vozilo.");

		stage = 3;
		SetTimerEx("PlayTutorial", 27000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 3)
	{
		SetPlayerCameraPos(playerid, 1103.6431,-1713.9709,32.8630);
		SetPlayerCameraLookAt(playerid, 1080.9916,-1697.3716,13.5320);

		SendClientMessage(playerid, ZELENA,   	"AUTO SKOLA");
		SendClientMessage(playerid, BELA, 		"- Predlazemo ti da najpre polozis vozacki ispit kako ne bi imao problema sa policijom!");
		SendClientMessage(playerid, BELA, 		"- Polaganje je jednostavno i traje kratko!");

		stage = 4;
		SetTimerEx("PlayTutorial", 12000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 4)
	{
		SetPlayerCameraPos(playerid, 1437.8712,-1050.2128,46.7454);
		SetPlayerCameraLookAt(playerid, 1466.9877,-1017.1108,25.5759);

		SendClientMessage(playerid, SVETLOCRVENA, 	"BANKA");
		SendClientMessage(playerid, BELA, 		"- Da bi tvoj novac bio na sigurnom i da bi se zastitio od kradje, obavezno ga cuvaj u banci!");
		SendClientMessage(playerid, BELA, 		"- U banci mozes izvaditi platnu karticu na koju ces dobijati PayDay na svakih 55 minuta.");
		SendClientMessage(playerid, BELA, 		"- Takodje mozes podici i {00FF00}kredit {FFFFFF}tako da brze dodjes do zeljene kuce ili automobila.");
		SendClientMessage(playerid, BELA, 		" ");
		SendClientMessage(playerid, BELA, 		"- Radno vreme banke je od 9h do 24h, a kada banka ne radi, mozes koristiti {00FF00}bankomate.");

		stage = 5;
		SetTimerEx("PlayTutorial", 25000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 5)
	{
		SetPlayerCameraPos(playerid, 1069.4482,-1398.3854,48.1160);
		SetPlayerCameraLookAt(playerid, 1029.7325,-1438.0144,13.6790);

		SendClientMessage(playerid, CRVENA, 	"MAFIJE I BANDE  /  ILEGALNE ORGANIZACIJE");
		SendClientMessage(playerid, BELA, 		"- Clanstvo u mafiji ili bandi donosi ti brojne mogucnosti da dobro zaradis!");
		SendClientMessage(playerid, ZUTA, 		"- Mozes prevoziti materijale i municiju, zauzimati teritorije, pljackati bankomate, markete, zlataru.");
		SendClientMessage(playerid, NARANDZASTA, 		"- Postoji mogucnost kradje oruzja iz vagona ili sakupljanja sastojaka za izradu droge.");
		SendClientMessage(playerid, BELA, 		" ");
		SendClientMessage(playerid, BELA, 		"- Za ulazak u bilo koju mafiju ili bandu nema posebnih uslova, samo poznavanje RP pravila! Dovoljan ti je level 1.");

		stage = 6;
		SetTimerEx("PlayTutorial", 32000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 6)
	{
		SetPlayerCameraPos(playerid, 1897.2861,-1046.0894,41.3999);
		SetPlayerCameraLookAt(playerid, 1840.7155,-1049.6565,25.2086);

		SendClientMessage(playerid, NARANDZASTA, 	"KRAJ TUTORIJALA");
		SendClientMessage(playerid, BELA, 		"- Znamo da niko ne voli dugacke tutorijale, pa te necemo smarati da ih gledas.");
		SendClientMessage(playerid, BELA, 		"- Za sve sto te interesuje mozes se obratiti Helperima (/askq) ili posetiti nas forum:");
		SendClientMessage(playerid, SVETLOPLAVA, 		"   www.nlsamp.com");
		SendClientMessage(playerid, BELA, 		" ");
		SendClientMessage(playerid, BELA, 		"- Dok ne dostignes level 6, dobijaces dupli EXP!");
		SendClientMessage(playerid, BELA, 		"- Postuj RP pravila i zelimo ti dobru zabavu na nasem serveru!");

		stage = 7;
		SetTimerEx("PlayTutorial", 20000, false, "iii", playerid, cinc[playerid], stage);
	}

	else if (stage == 7)
	{
		// Spawn na aerodromu
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), 1682.6960, -2334.6003, 13.5524, 0.0, 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating_H(playerid, false);

        // Vraca spawn na ono sto treba da bude (za ubuduce)
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);

        ClearChatForPlayer(playerid);
		SendClientMessage(playerid, NARANDZASTA, "(pomoc) {FFFFFF}Ukoliko ti bude bila potrebna pomoc, upisi {FF9900}/novi {FFFFFF}i Helper ce doci do tebe.");
		SendClientMessage(playerid, BELA, "Da kontaktiras helpere koristi {FF9900}/askq    {FFFFFF}Za chat sa helperima koristi {FF0000}/n.");
		SendClientMessage(playerid, BELA, " ");
        // SendClientMessage(playerid, LJUBICASTA, "VRACAMO STATS | {FFFFFF}Za povratak stats-a sa drugih servera javite se head adminima (ingame) ili posetite nas forum.");
        // SendClientMessage(playerid, BELA, " ");
		SendClientMessage(playerid, NARANDZASTA, "(pomoc) {FFFFFF}Za pocetak, iznajmi neko vozilo i idi do opstine da bi uzeo {FFFF00}posao. {FFFFFF}Predlazemo: {00FF00}kosac trave ili pizzaboy.");
        // Slanje poruke staff-u
        StaffMsg(COLOR_HOT_PINK_11, "- Igrac "#HOT_PINK_8"%s[%i] "#HOT_PINK_11"se upravo registrovao. Pozelite mu dobrodoslicu!", ime_rp[playerid], playerid);
	}

	return 1;
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
