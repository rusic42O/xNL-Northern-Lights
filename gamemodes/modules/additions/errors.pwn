#include <YSI_Coding\y_va>
// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define GRESKA_KICK 	    	"Automatski ste izbaceni sa servera."
#define GRESKA_NEPOZNATO 		"Dogodila se nepoznata greska, molimo pokusajte ponovo."
#define GRESKA_UTISAN 			"Utisani ste, ne mozete koristiti chat."
#define GRESKA_IMUNITET			"Ne mozete koristiti ovu naredbu na drugim adminima/helperima."
#define GRESKA_PREDALEKO 		"Nalazite se previse daleko."
#define GRESKA_REGISTRACIJA 	"Ne mozete koristiti ovu naredbu u toku registracije."
#define GRESKA_NEMADOZVOLU 		"Nemate dozvolu da koristite ovu naredbu."
#define GRESKA_OFFLINE 			"Igrac cije ste ime ili ID uneli trenutno nije na serveru."
#define GRESKA_MYSQL			"Dogodila se greska prilikom slanja upita ka bazi podataka."
#define GRESKA_AREA             "Ne mozete koristiti ovo dok ste u alcatrazu."
#define GRESKA_VIPADMIN         "Ne mozete koristiti ovu komandu na adminima/helperima."



// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum(<<= 1)
{
	// Error ako je utisan
    CHECK_MUTE = 1,

    // Error ako je target na visoj poziciji od player-a
    CHECK_IMMUNITY,

    // Error ako su player i target previse udaljeni
    CHECK_DISTANCE,

    // Error ako nema dozvolu
    CHECK_PERMISSION,

    // Error ako je target offline
    CHECK_TARGET_ONLINE,

    // Error ako player NIJE policajac
    CHECK_PLAYER_COP,

    // Error ako player NIJE kriminalac
    CHECK_PLAYER_CRIMINAL,

    // Error ako target JESTE policajac
    CHECK_TARGET_COP,

    // Error ako target JESTE kriminalac
    CHECK_TARGET_CRIMINAL,
}




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //





// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock ErrorMsg(playerid, const fmat[], {Float, _}:...)
{
    new
        str[145];
    va_format(str, sizeof str, fmat, va_start<2>);
    format(str, sizeof str, "- GRESKA: {ffffff}%s", str);
    SendClientMessage(playerid, ERROR, str);
    return 1;
}

// stock CheckCommonErrors(playerid, targetid, errors)
// {
// 	if (FlagCheck(errors, CHECK_TARGET_ONLINE))
// 	{
// 		if (!IsPlayerConnected(targetid))
// 		{
// 			ErrorMsg(playerid, GRESKA_OFFLINE);
// 			return 0;
// 		}
// 	}

// 	if (FlagCheck(errors, CHECK_MUTE))
// 	{
// 		if (PI[playerid][p_utisan] > 0)
// 		{
// 			ErrorMsg(playerid, GRESKA_UTISAN);
// 			return 0;
// 		}
// 	}

// 	if (FlagCheck(errors, CHECK_DISTANCE))
// 	{
// 		if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
// 		{
// 			ErrorMsg(playerid, "Niste dovoljno blizu tom igracu.");
// 			return 0;
// 		}
// 	}

// 	if (FlagCheck(errors, CHECK_PLAYER_COP))
// 	{
// 		if (!IsACop(playerid))
// 		{
// 			ErrorMsg(playerid, "Niste clan policije.");
// 			return 0;
// 		}
// 	}
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
