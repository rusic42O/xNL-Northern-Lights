#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define LOG_POGRESANXPASS           "logs/Pogresan HA password.txt"
#define LOG_MYSQLERROR              "logs/MySQL.txt"
#define LOG_CAPTCHAGRESKE           "logs/Captcha greske.txt"
#define LOG_NEUSPESNAPRIJAVA        "logs/Prijave (neuspesne).txt"
#define LOG_USPESNAPRIJAVA          "logs/Prijave (uspesno).txt"
#define LOG_REGISTRACIJA            "logs/Registracije.txt"
#define LOG_ADMINKOMANDE            "logs/Admin komande.txt"
#define LOG_DUZNOSTI                "logs/Duznosti.txt"
#define LOG_PORT                    "logs/Teleport.txt"
#define LOG_TRKE                    "logs/Trke.txt"
#define LOG_EVENTVOZILA             "logs/Event vozila.txt"
#define LOG_POSTAVLJANJE            "logs/Postavljanje.txt"
#define LOG_POZICIJE                "logs/Pozicije.txt"
#define LOG_STAFFPM                 "logs/Privatne poruke (staff).txt"
#define LOG_PLAYERPM                "logs/Privatne poruke (igraci).txt"
#define LOG_BAN                     "logs/Banovi.txt"
#define LOG_OPOMENE                 "logs/Opomene.txt"
#define LOG_KICK                    "logs/Kick.txt"
#define LOG_KAZNE                   "logs/Kazne.txt"
#define LOG_REPORT_POMOC            "logs/Prijave i pitanja.txt"
#define LOG_PLACANJA                "logs/Placanje.txt"
#define LOG_KODOVI                  "logs/Kodovi.txt"
#define LOG_REKLAME                 "logs/Reklame.txt"
#define LOG_STAFFOOC                "logs/Staff OOC.txt"
#define LOG_BOMBE                   "logs/Bombe.txt"
#define LOG_POGRESANODGOVOR         "logs/Pogresni odgovori.txt"
#define LOG_PROMENAVLASNISTVA       "logs/Promena vlasnistva.txt"
#define LOG_IMOVINA                 "logs/Prodaja i kupovina imovine.txt"
#define LOG_AIMOVINA                "logs/Uredjivanje imovine (A).txt"
#define LOG_KUTIJA                  "logs/Kutija.txt"
#define LOG_ORUZJE                  "logs/Davanje oruzja.txt"
#define LOG_BANKA                   "logs/Banka salter.txt"
#define LOG_TRANSFERI               "logs/Banka transferi.txt"
#define LOG_KREDITI                 "logs/Banka krediti.txt"
#define LOG_ATM                  	"logs/ATM.txt"
#define LOG_OGLASI                  "logs/Oglasi.txt"
#define LOG_SERVERPANEL             "logs/Server panel.txt"
#define LOG_DEBUG2                  "logs/Debug.txt"
#define LOG_PROIZVODIKUPOVINA       "logs/Kupovina proizvoda.txt"
#define LOG_OVERWATCH               "logs/Overwatch.txt"
#define LOG_RENOVAC            		"logs/Novac (nekretnine).txt"
#define LOG_UPRAVLJANJE_PRIJAVAMA	"logs/Upravljanje prijavama.txt"
#define LOG_STVARI					"logs/Stvari.txt"
#define LOG_FACTIONS_EDIT			"logs/Factions (izmene).txt"
#define LOG_FACTIONS_RANKS			"logs/Factions (rankovi).txt"
#define LOG_FACTIONS_MEMBERS		"logs/Factions (rankovi).txt"
#define LOG_FACTIONS_LOGIN			"logs/Factions (log in).txt"
#define LOG_FACTIONS_BUYSELLVEH     "logs/Factions (kupoprodaja vozila).txt"
#define LOG_FACTIONS_VEH_WEAPONS    "logs/Factions (vozila-oruzje).txt"
#define LOG_FACTIONS_SAFE           "logs/Factions (sef).txt"
#define LOG_PROMENA_PINA			"logs/Promena PIN-a.txt"
#define LOG_ZAMENA					"logs/Zamena imovina.txt"
#define LOG_SMS						"logs/SMS.txt"
#define LOG_PREPREKE				"logs/Prepreke i barikade.txt"
#define LOG_VEHICLES				"logs/Vozila (autosalon).txt"
#define LOG_VEHICLES_WEAPONS        "logs/Vozila (oruzje).txt"
#define LOG_CMD                     "logs/Komande.txt"
#define LOG_DIALOG                  "logs/Dialozi.txt"
#define LOG_FIRME                   "logs/Firme.txt"
#define LOG_TUNING                  "logs/Tuning.txt"
#define LOG_PROMOTER                "logs/Promoter.txt"
#define LOG_ROBBERY                 "logs/Robbery.txt"
#define LOG_GRANICA                 "logs/Granica.txt"
#define LOG_LOTTERY                 "logs/Lottery.txt"
#define LOG_PICKPOCKET              "logs/Pickpocket.txt"
#define LOG_NEXAC                   "logs/NexAC.txt"
#define LOG_HOUSES_WEAPONS          "logs/Kuce (oruzje).txt"
#define LOG_BACKPACK                "logs/Backpack.txt"
#define LOG_SETSTATS                "logs/SetStats.txt"
#define LOG_JOBSALARY               "logs/Poslovi.txt"
#define LOG_KAZNE_POLICE            "logs/Kazne (policija).txt"
#define LOG_SEIZE					"logs/Oduzimanje (policija).txt"
#define LOG_MEDSPACKAGE				"logs/Paketi medikamenata.txt"
#define LOG_TOKEN					"logs/Token.txt"
#define LOG_MAFIAGUNSHOP            "logs/Mafia Gunshop.txt"
#define LOG_ACCESSORIES				"logs/Accessories.txt"
#define LOG_PROSTITUTES             "logs/Prostitutes.txt"
#define LOG_DRUGSTRANSPORT          "logs/Drugs Transport.txt"
#define LOG_VIP          			"logs/VIP Komande.txt"
#define LOG_PAYDAY          		"logs/Payday.txt"
#define LOG_DULEBEAST          		"logs/DuLeBeast.txt"
#define LOG_DRUGSTRADE              "logs/Prodaja droge.txt"
#define LOG_REFERRAL                "logs/Referral.txt"
#define LOG_TURFS                   "logs/Turfs.txt"
#define LOG_SKILL                   "logs/Skill.txt"
#define LOG_ZABRANE                 "logs/Zabrane.txt"
#define LOG_CHAT                 	"logs/chat/Chat.txt"
#define LOG_CHAT_ADMIN              "logs/chat/Admin.txt"
#define LOG_CHAT_HELPER             "logs/chat/Helper.txt"
#define LOG_CHAT_HEAD              	"logs/chat/Head.txt"
#define LOG_CHAT_NEW				"logs/chat/New.txt"
#define LOG_ONPLAYERDEATH			"logs/OnPlayerDeath.txt"
#define LOG_PROMO_REWARDS			"logs/Promo nagrade.txt"
#define LOG_LECENJE					"logs/Lecenje.txt"
#define LOG_MONEYFLOW				"logs/Moneyflow.txt"
#define LOG_STATSRESTORE			"logs/Vracanje statsa.txt"
#define LOG_MARIJUANA				"logs/Marihuana.txt"
#define LOG_RE_STVARI				"logs/Nekretnine (stavi-uzmi).txt"
#define LOG_HAPPYJOB				"logs/Happyjob.txt"
#define LOG_LAND                    "logs/Imanja.txt"
#define LOG_LAND_DESTROYED          "logs/Imanja (propadanje).txt"
#define LOG_MARKETPLACE             "logs/Pijaca.txt"
#define LOG_ORGKAZNA                "logs/Org kazna.txt"
#define LOG_NAMECHANGE              "logs/Promena imena.txt"
#define LOG_DONATIONS               "logs/Donacije drzavi.txt"
#define LOG_VEHALARM                "logs/Vozila - alarmi.txt"
#define LOG_SPEEDCAMERAS            "logs/Radari.txt"
#define LOG_ZLATNICI                "logs/Zlatnici.txt"
#define LOG_MYSQLIMOVINA            "logs/MySQLImovinaVracanje.txt"


#define LOG_DEBUG_DIALOG			"logs/debug/_Dialogs.txt"
#define LOG_DEBUG_FUNCTION          "logs/debug/_Functions.txt"
#define LOG_DEBUG_CALLBACK          "logs/debug/_Callbacks.txt"

#define LOG_AUTOPUNISHMENT          "logs/overwatch/Auto Punishment.txt"
#define LOG_OVERWATCH_CONTROL       "logs/overwatch/control.txt"
#define LOG_OVERWATCH_DETECTIONS    "logs/overwatch/detections.txt"




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
    print("Initializing logs..");
    new sLog[55];
	format(sLog, sizeof sLog, "\r\n\r\n- Novi log zapocet: %s\r\n", trenutno_vreme());
	Log_MarkStart(LOG_POGRESANXPASS,    		sLog);          
	Log_MarkStart(LOG_MYSQLERROR,       		sLog);
	Log_MarkStart(LOG_CAPTCHAGRESKE,    		sLog);
	Log_MarkStart(LOG_NEUSPESNAPRIJAVA, 		sLog);
	Log_MarkStart(LOG_USPESNAPRIJAVA,   		sLog);
	Log_MarkStart(LOG_REGISTRACIJA,     		sLog);
	Log_MarkStart(LOG_ADMINKOMANDE,     		sLog);
	Log_MarkStart(LOG_DUZNOSTI,         		sLog);
	Log_MarkStart(LOG_PORT, 					sLog);
	Log_MarkStart(LOG_TRKE, 					sLog);
	Log_MarkStart(LOG_EVENTVOZILA,  			sLog);
	Log_MarkStart(LOG_POSTAVLJANJE, 			sLog);
	Log_MarkStart(LOG_POZICIJE, 				sLog);
	Log_MarkStart(LOG_STAFFPM,  				sLog);
	Log_MarkStart(LOG_PLAYERPM, 				sLog);
	Log_MarkStart(LOG_BAN,      				sLog);
	Log_MarkStart(LOG_OPOMENE,  				sLog);
	Log_MarkStart(LOG_KICK,     				sLog);
	Log_MarkStart(LOG_KAZNE,    				sLog);
	Log_MarkStart(LOG_REPORT_POMOC, 			sLog);
	Log_MarkStart(LOG_PLACANJA, 				sLog);
	Log_MarkStart(LOG_KODOVI,   				sLog);
	Log_MarkStart(LOG_REKLAME,  				sLog);
	Log_MarkStart(LOG_STAFFOOC, 				sLog);
	Log_MarkStart(LOG_BOMBE,    				sLog);
	Log_MarkStart(LOG_POGRESANODGOVOR,   		sLog);
	Log_MarkStart(LOG_PROMENAVLASNISTVA, 		sLog);
	Log_MarkStart(LOG_IMOVINA,     			    sLog);
	Log_MarkStart(LOG_AIMOVINA,    			    sLog);
	Log_MarkStart(LOG_KUTIJA, 	 			    sLog);
	Log_MarkStart(LOG_ORUZJE, 	 			    sLog);
	Log_MarkStart(LOG_BANKA,  	 			    sLog);
	Log_MarkStart(LOG_TRANSFERI,   			    sLog);
	Log_MarkStart(LOG_KREDITI,     			    sLog);
    Log_MarkStart(LOG_ATM,                      sLog);
	Log_MarkStart(LOG_OGLASI,      			    sLog);
	Log_MarkStart(LOG_SERVERPANEL, 			    sLog);
	Log_MarkStart(LOG_DEBUG2,      			    sLog);
	Log_MarkStart(LOG_PROIZVODIKUPOVINA, 		sLog);
	Log_MarkStart(LOG_OVERWATCH, 				sLog);
	Log_MarkStart(LOG_RENOVAC,   				sLog);
	Log_MarkStart(LOG_UPRAVLJANJE_PRIJAVAMA, 	sLog);
	Log_MarkStart(LOG_STVARI, 				    sLog);
	Log_MarkStart(LOG_FACTIONS_EDIT, 			sLog);
	Log_MarkStart(LOG_FACTIONS_RANKS,	 		sLog);
	Log_MarkStart(LOG_FACTIONS_MEMBERS, 		sLog);
    Log_MarkStart(LOG_FACTIONS_LOGIN,           sLog);
    Log_MarkStart(LOG_FACTIONS_SAFE,            sLog);
    Log_MarkStart(LOG_ZAMENA,                   sLog);
    Log_MarkStart(LOG_SMS,                      sLog);
    Log_MarkStart(LOG_PREPREKE,                 sLog);
    Log_MarkStart(LOG_VEHICLES,                 sLog);
    Log_MarkStart(LOG_CMD,                      sLog);
    Log_MarkStart(LOG_DIALOG,                   sLog);
    Log_MarkStart(LOG_FIRME,                    sLog);
    Log_MarkStart(LOG_TUNING,                   sLog);
    Log_MarkStart(LOG_PROMOTER,                 sLog);
    Log_MarkStart(LOG_ROBBERY,                  sLog);
    Log_MarkStart(LOG_GRANICA,                  sLog);
    Log_MarkStart(LOG_LOTTERY,                  sLog);
    Log_MarkStart(LOG_PICKPOCKET,               sLog);
    Log_MarkStart(LOG_NEXAC,                    sLog);
    Log_MarkStart(LOG_HOUSES_WEAPONS,           sLog);
    Log_MarkStart(LOG_BACKPACK,                 sLog);
    Log_MarkStart(LOG_SETSTATS,                 sLog);
    Log_MarkStart(LOG_JOBSALARY,                sLog);
    Log_MarkStart(LOG_KAZNE_POLICE,             sLog);
    Log_MarkStart(LOG_SEIZE,           		    sLog);
    Log_MarkStart(LOG_MEDSPACKAGE,           	sLog);
    Log_MarkStart(LOG_TOKEN,           		    sLog);
    Log_MarkStart(LOG_MAFIAGUNSHOP,             sLog);
    Log_MarkStart(LOG_ACCESSORIES,          	sLog);
    Log_MarkStart(LOG_PROSTITUTES,              sLog);
    Log_MarkStart(LOG_DRUGSTRANSPORT,           sLog);
    Log_MarkStart(LOG_VIP,		                sLog);
    Log_MarkStart(LOG_PAYDAY,		            sLog);
    Log_MarkStart(LOG_DULEBEAST,		        sLog);
    Log_MarkStart(LOG_DRUGSTRADE,               sLog);
    Log_MarkStart(LOG_REFERRAL,                 sLog);
    Log_MarkStart(LOG_TURFS,                    sLog);
    Log_MarkStart(LOG_SKILL,                    sLog);
    Log_MarkStart(LOG_ZABRANE,                  sLog);
    Log_MarkStart(LOG_CHAT,                	    sLog);
    Log_MarkStart(LOG_CHAT_ADMIN,            	sLog);
    Log_MarkStart(LOG_CHAT_HELPER,              sLog);
    Log_MarkStart(LOG_CHAT_HEAD,            	sLog);
    Log_MarkStart(LOG_CHAT_NEW,                 sLog);
    Log_MarkStart(LOG_ONPLAYERDEATH,            sLog);
    Log_MarkStart(LOG_PROMO_REWARDS,            sLog);
    Log_MarkStart(LOG_LECENJE,          		sLog);
    Log_MarkStart(LOG_MONEYFLOW,          	    sLog);
    Log_MarkStart(LOG_STATSRESTORE,          	sLog);
    Log_MarkStart(LOG_MARIJUANA,                sLog);
    Log_MarkStart(LOG_RE_STVARI,                sLog);
    Log_MarkStart(LOG_HAPPYJOB,          		sLog);
    Log_MarkStart(LOG_LAND,                     sLog);
    Log_MarkStart(LOG_LAND_DESTROYED,           sLog);
    Log_MarkStart(LOG_MARKETPLACE,              sLog);
    Log_MarkStart(LOG_ORGKAZNA,                 sLog);
    Log_MarkStart(LOG_NAMECHANGE,               sLog);
    Log_MarkStart(LOG_DONATIONS,                sLog);
    Log_MarkStart(LOG_VEHALARM,                 sLog);
    Log_MarkStart(LOG_SPEEDCAMERAS,             sLog);

    Log_MarkStart(LOG_DEBUG_DIALOG,          	sLog);
    Log_MarkStart(LOG_DEBUG_FUNCTION,           sLog);
    Log_MarkStart(LOG_DEBUG_CALLBACK,           sLog);

    Log_MarkStart(LOG_AUTOPUNISHMENT,           sLog);
    Log_MarkStart(LOG_OVERWATCH_CONTROL,        sLog);
    Log_MarkStart(LOG_OVERWATCH_DETECTIONS,     sLog);
    print("Logs ready!");
	return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
Log_MarkStart(const fajl[], const string[55]) 
{
	new File:file_handler = fopen(fajl, io_append);
    if (!file_handler) {
        printf("Log_MarkStart: Sranje sa fajlom: %s nema ga..", fajl);
    }
	fwrite(file_handler, string);
	fclose(file_handler);
    return true;
}

Log_Write(const fajl[], const log_str[]) 
{
    new string[384];
	format(string, sizeof string, "[%s] %s\r\n", trenutno_vreme(), log_str);
	new File:file_handler = fopen(fajl, io_append);
    if (!file_handler) {
        printf("Log_MarkStart: Sranje sa fajlom: %s nema ga..", fajl);
    }
	fwrite(file_handler, string);
	fclose(file_handler);

	return 1;
}

// upisi_log_ex(const table[], const string[], limit = 6) {
// 	// Upotreba: upisi_log_ex(LOG_BANOVI, "Ime_Prezime|Ime_Prezime|1440|Cheater")
// 	// U prevodu: Izvrsio: Ime_Prezime | Igrac: Ime_Prezime | Trajanje: 1440 minuta | Razlog: Cheater

// 	new
// 	    data[6][100]
// 	;

//  	split(string, data, '|');
// 	format(upit_512, 512, "INSERT INTO %s VALUES(NULL, NULL, ", table);

// 	for__loop (new i = 0; i < limit; i++)
// 	{
// 	    if (data[i][0] != '\0')
// 	    {
// 	        strins(data[i], "'", 0);
// 	        strins(data[i], "', ", strlen(data[i]));
// 	        strins(upit_512, data[i], strlen(upit_512));
// 	    }
// 	}

// 	strdel(upit_512, strlen(upit_512)-2, strlen(upit_512));
// 	strins(upit_512, ")", strlen(upit_512));

// 	return 1;
// }




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
