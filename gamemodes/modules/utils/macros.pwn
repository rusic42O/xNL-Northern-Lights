#define MOD_VERZIJA "v4.2"
#define MOD_UPDATE "22/05/2022"

/*#define while__loop(%1) while(%1)

#define for__loop(%1;%2;%3) for(%1;%2;%3)
*/

#define while__loop(%1) \
    PrintLoopBacktrace(); \
    while(%1)

#define for__loop(%1;%2;%3) \
    PrintLoopBacktrace(); \
    for(%1;%2;%3)


forward Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ);
forward Float:GetVehicleTankVolume(vehicleid);
forward Float:GetVehicleFuel(vehicleid);

#define MAX_NOVAC_IZMENA			5 // Broj izmena za varijablu novac pre nego sto izmene budu spremljene u bazu
#define MAX_FITEM_NAME				31 // Maksimalna duzina za naziv predmeta za "furniture.pwn" modul
#define FORUM                       "www.nlsamp.com"
#define TEAMSPEAK                   "ts.nlsamp.com"
#define MAX_PASSWORD_LEN            (25)
#define MAX_EMAIL_LEN               (41)
#define tajmer:                     TAJMER_
#define POS_X						0
#define POS_Y						1
#define POS_Z						2
#define POS_A						3
#define DEBUG_TIMERS
#define DEBUG_CMD
#define DEBUG_DIALOGS
#define VRSTA_LICNOVOZILO           0
#define VRSTA_LIDER                 1
#define PLACANJE_NOVAC              1
#define PLACANJE_GOLD               2
#define RE_MAX_SLOTS                3
#define kuca                		0
#define stan                		1
#define firma               		2
#define hotel               		3
#define garaza              		4
#define vikendica                   5
#define automobil                   6
#define motor                       7
#define bicikl                      8
#define brod                        9
#define helikopter                  10
#define VP_NISTA 					-1
#define VP_NE 						0
#define VP_DA 						1
#define SPAWN_X						1789.8363//1651.1167 1789.8363,-1746.1353,13.5469
#define SPAWN_Y						-1746.1353//-1246.5786
#define SPAWN_Z						13.5469//14.8125
#define SPAWN_A						-90.0
#define PROPNAME_UPPER              0 // Sva slova velika
#define PROPNAME_LOWER              1 // Sva slova mala
#define PROPNAME_CAPITAL       		2 // Prvo slovo veliko
#define PROPNAME_AKUZATIV           3 // Oblik u akuzativu, mala slova
#define PROPNAME_GENITIV            4 // Oblik u genitivu, mala slova
#define PROPNAME_TABLE              5 // Naziv MySQL tablice
#define MAPICON_JOB                 (99)
#define MAPICON_POLICE_SOS          (98)
#define MAPICON_TAXI                (97)
#define MAPICON_LOCATE              (96)
#define MAPICON_POLICE_GOLD         (95)
#define WALK_DEFAULT    			0
#define WALK_NORMAL     			1
#define WALK_PED        			2
#define WALK_GANGSTA    			3
#define WALK_GANGSTA2   			4
#define WALK_OLD        			5
#define WALK_FAT_OLD    			6
#define WALK_FAT        			7
#define WALK_LADY      				8
#define WALK_LADY2      			9
#define WALK_WHORE      			10
#define WALK_WHORE2     			11
#define WALK_DRUNK     				12
#define WALK_BLIND     				13
#define SLOT_BODY_WEAPON            0
#define SLOT_SANTAHAT               1
#define SLOT_BODY_ARMOR             2
#define SLOT_PHONE					4
#define SLOT_HELMET                 5
#define SLOT_CUSTOM1                6
#define SLOT_CUSTOM2                7
#define SLOT_CUSTOM3                8
#define SLOT_BACKPACK               9
#define SLOT_TASER                  9
#define SLOT_JOB                    9
#define IMOVINA_NEPOZNATO			0
#define IMOVINA_NEKRETNINA			1
#define IMOVINA_VOZILO				2
#define GEAR_REVERSE                (-1)
#define GEAR_NEUTRAL                (-2)
#define GEAR_UNKNOWN                (-3)
#define GEAR_PARKING                (-4)
#define TUBE        (0)
#define COVER       (1)
#define LIGHT       (2)
#define SUPPORT     (3)
#define TBR_RED     (0)
#define TBR_GREEN   (1)
#define TBR_BLUE    (2)
#define TBR_YELLOW  (3)
#define TBR_PURPLE  (4)
#define PRESSED(%0) 				(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define HOLDING(%0) 				((newkeys & (%0)) == (%0))
#if !defined strcpy
    #define strcpy(%0,%1) 				strcat((%0[0] = '\0', %0), %1) /* Format: strcpy(dest, src); */
#endif
#define CountDynamicActors(%0)      Streamer_CountItems(STREAMER_TYPE_ACTOR, %0)
#define HAPPY_HOURS_LEVEL_MAX       (5) // Maksimalni level na kome se *jos uvek* dobija duplo iskustvo
#define FlagCheck(%0,%1) (((%0) & (%1)) == (%1))

#define nl_public%0(%1) forward%0(%1); public%0(%1)

native WP_Hash(buffer[], len, const str[]);
DEFINE_HOOK_REPLACEMENT(Damage, Dmg);

nl_public PC_EmulateCommandEx(playerid, const cmd[], const params[]) // with params
{
    new cmdParams[48];
    format(cmdParams, sizeof cmdParams, "%s %s", cmd, params);
    return PC_EmulateCommand(playerid, cmdParams);
}