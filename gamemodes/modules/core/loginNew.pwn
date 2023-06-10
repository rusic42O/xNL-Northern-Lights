#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define LOGIN_FIND_ACC 		0
#define LOGIN_PW_CHECK 		1
#define LOGIN_BAN_CHECK 	2
#define LOGIN_STAFF_CHECK 	3
#define LOGIN_PIN_CHECK		4
#define LOGIN_LOAD_DATA 	5

#define THREAD_UCITAJ_P_CRASH		0
#define THREAD_UCITAJ_P_OPOMENE		1
#define THREAD_UCITAJ_P_DATUMAKT	2
#define THREAD_UCITAJ_P_BANSTATUS	3
#define THREAD_UCITAJ_P_ADMIN		4
#define THREAD_UCITAJ_P_HELPER		5

static bool:gPlayerLoggedIn[MAX_PLAYERS char];

new PlayerText:IDTD[MAX_PLAYERS][47]
;

enum
{
    PRIJAVA_NORMAL = 0,
    PRIJAVA_PRVIPUT,
    PRIJAVA_PINKOD,
};

stock ShowID(playerid, bool:showid)
{
    if(showid)
    {
        new
            name[56],
            level[27],
            bank[11],
            gold[8]
        ;

        format(name, sizeof name, "%s ( Los Santos )", ime_rp[playerid]);
        format(level, sizeof level, "Radni staz: %i god.", PI[playerid][p_nivo]);
        format(bank, sizeof bank, "$%08i", PI[playerid][p_banka]);
        format(gold, sizeof gold, "%05ig", PI[playerid][p_zlato]);

        IDTD[playerid][0] = CreatePlayerTextDraw(playerid, 249.583847, 176.896270, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][0], 40.000000, 40.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][0], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][0], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][0], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][0], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][0], 0);

        IDTD[playerid][1] = CreatePlayerTextDraw(playerid, 229.466430, 178.333267, "");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][1], 84.000000, 79.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][1], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][1], 21);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][1], 0);
        PlayerTextDrawFont(playerid, IDTD[playerid][1], 5);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][1], 0);
        PlayerTextDrawSetPreviewModel(playerid, IDTD[playerid][1], 25);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][1], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, IDTD[playerid][1], 0.000000, 0.000000, 0.000000, 0.850000);

        IDTD[playerid][2] = CreatePlayerTextDraw(playerid, 251.683303, 176.777770, "particle:lunar");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][2], 37.000000, 41.109901);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][2], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][2], 0x00000000);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][2], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][2], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][2], 4);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][2], 0x00000000);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][2], 0);

        IDTD[playerid][3] = CreatePlayerTextDraw(playerid, 246.749969, 175.688568, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][3], 5.000000, 91.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][3], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][3], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][3], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][3], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][3], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][3], 0);

        IDTD[playerid][4] = CreatePlayerTextDraw(playerid, 249.550247, 171.488372, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][4], 144.389602, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][4], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][4], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][4], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][4], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][4], 0);

        IDTD[playerid][5] = CreatePlayerTextDraw(playerid, 245.433227, 169.855468, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][5], 8.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][5], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][5], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][5], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][5], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][5], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][5], 0);

        IDTD[playerid][6] = CreatePlayerTextDraw(playerid, 245.433227, 261.422271, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][6], 8.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][6], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][6], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][6], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][6], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][6], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][6], 0);

        IDTD[playerid][7] = CreatePlayerTextDraw(playerid, 249.316925, 264.503173, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][7], 144.000000, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][7], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][7], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][7], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][7], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][7], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][7], 0);

        IDTD[playerid][8] = CreatePlayerTextDraw(playerid, 391.750061, 175.544067, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][8], 5.000000, 91.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][8], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][8], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][8], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][8], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][8], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][8], 0);

        IDTD[playerid][9] = CreatePlayerTextDraw(playerid, 390.250061, 261.303771, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][9], 8.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][9], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][9], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][9], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][9], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][9], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][9], 0);

        IDTD[playerid][10] = CreatePlayerTextDraw(playerid, 390.250061, 169.825973, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][10], 8.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][10], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][10], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][10], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][10], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][10], 0);

        IDTD[playerid][11] = CreatePlayerTextDraw(playerid, 251.216903, 216.717971, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][11], 144.000000, 48.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][11], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][11], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][11], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][11], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][11], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][11], 0);

        IDTD[playerid][12] = CreatePlayerTextDraw(playerid, 288.300354, 174.580871, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][12], 104.000000, 59.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][12], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][12], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][12], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][12], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][12], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][12], 0);

        IDTD[playerid][13] = CreatePlayerTextDraw(playerid, 245.416625, 176.777572, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][13], 90.000000, 90.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][13], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][13], -1);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][13], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][13], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][13], 4);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][13], 0x00000000);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][13], 0);

        IDTD[playerid][14] = CreatePlayerTextDraw(playerid, 246.633361, 244.821884, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][14], 151.000000, -28.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][14], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][14], 17);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][14], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][14], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][14], 4);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][14], 0x00000000);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][14], 0);

        IDTD[playerid][15] = CreatePlayerTextDraw(playerid, 248.316589, 197.536468, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][15], 151.000000, -28.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][15], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][15], -188);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][15], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][15], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][15], 4);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][15], 0x00000000);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][15], 0);

        IDTD[playerid][16] = CreatePlayerTextDraw(playerid, 303.333343, 190.259170, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][16], 82.000000, -0.389898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][16], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][16], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][16], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][16], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][16], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][16], 0);

        IDTD[playerid][17] = CreatePlayerTextDraw(playerid, 303.333343, 201.459869, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][17], 82.000000, -0.389898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][17], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][17], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][17], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][17], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][17], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][17], 0);

        IDTD[playerid][18] = CreatePlayerTextDraw(playerid, 382.516662, 183.796173, name);
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][18], 0.108300, 0.485100);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][18], 3);
        PlayerTextDrawColor(playerid, IDTD[playerid][18], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][18], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][18], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][18], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][18], 1);

        IDTD[playerid][19] = CreatePlayerTextDraw(playerid, 363.400054, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][19], 3.880000, 6.709898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][19], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][19], -43521);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][19], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][19], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][19], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][19], 0);

        IDTD[playerid][20] = CreatePlayerTextDraw(playerid, 361.216644, 192.607269, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][20], 3.000000, 7.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][20], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][20], -1523963137);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][20], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][20], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][20], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][20], 0);

        IDTD[playerid][21] = CreatePlayerTextDraw(playerid, 367.200256, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][21], 2.980000, 6.709898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][21], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][21], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][21], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][21], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][21], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][21], 0);

        IDTD[playerid][22] = CreatePlayerTextDraw(playerid, 371.000549, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][22], 1.019999, 6.709898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][22], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][22], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][22], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][22], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][22], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][22], 0);

        IDTD[playerid][23] = CreatePlayerTextDraw(playerid, 373.200653, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][23], 0.569998, 6.709898);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][23], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][23], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][23], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][23], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][23], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][23], 0);

        IDTD[playerid][24] = CreatePlayerTextDraw(playerid, 374.700744, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][24], 0.360000, 6.650000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][24], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][24], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][24], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][24], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][24], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][24], 0);

        IDTD[playerid][25] = CreatePlayerTextDraw(playerid, 376.000854, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][25], 0.360000, 6.650000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][25], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][25], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][25], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][25], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][25], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][25], 0);

        IDTD[playerid][26] = CreatePlayerTextDraw(playerid, 375.300750, 192.707260, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][26], 0.360000, 6.650000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][26], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][26], 16711935);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][26], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][26], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][26], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][26], 0);

        IDTD[playerid][27] = CreatePlayerTextDraw(playerid, 370.949951, 192.788772, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][27], 6.000000, 6.570000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][27], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][27], 17);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][27], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][27], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][27], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][27], 0);

        IDTD[playerid][28] = CreatePlayerTextDraw(playerid, 351.383453, 193.629562, "....");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][28], 0.095398, 0.412499);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][28], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][28], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][28], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][28], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][28], 1);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][28], 1);

        IDTD[playerid][29] = CreatePlayerTextDraw(playerid, 258.750061, 227.592559, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][29], 0.379999, 15.050000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][29], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][29], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][29], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][29], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][29], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][29], 0);

        IDTD[playerid][30] = CreatePlayerTextDraw(playerid, 258.750061, 227.592559, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][30], 105.000000, 0.409900);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][30], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][30], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][30], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][30], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][30], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][30], 0);

        IDTD[playerid][31] = CreatePlayerTextDraw(playerid, 361.233551, 227.988769, "$");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][31], 0.170398, 0.951798);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][31], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][31], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][31], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][31], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][31], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][31], 1);

        IDTD[playerid][32] = CreatePlayerTextDraw(playerid, 267.300140, 232.655471, bank);
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][32], 0.124099, 0.604399);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][32], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][32], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][32], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][32], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][32], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][32], 1);

        IDTD[playerid][33] = CreatePlayerTextDraw(playerid, 306.816833, 232.937072, "....");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][33], 0.102499, 0.381399);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][33], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][33], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][33], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][33], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][33], 1);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][33], 1);

        IDTD[playerid][34] = CreatePlayerTextDraw(playerid, 257.500061, 243.670364, "V");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][34], 0.101599, 0.428099);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][34], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][34], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][34], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][34], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][34], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][34], 1);

        IDTD[playerid][35] = CreatePlayerTextDraw(playerid, 257.900054, 247.970657, "V");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][35], 0.070000, 0.293300);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][35], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][35], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][35], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][35], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][35], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][35], 1);

        IDTD[playerid][36] = CreatePlayerTextDraw(playerid, 258.566650, 256.400238, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][36], 1.000000, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][36], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][36], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][36], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][36], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][36], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][36], 0);

        IDTD[playerid][37] = CreatePlayerTextDraw(playerid, 260.066741, 256.400238, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][37], 1.000000, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][37], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][37], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][37], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][37], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][37], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][37], 0);

        IDTD[playerid][38] = CreatePlayerTextDraw(playerid, 261.466857, 256.400238, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][38], 1.959900, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][38], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][38], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][38], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][38], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][38], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][38], 0);

        IDTD[playerid][39] = CreatePlayerTextDraw(playerid, 263.866943, 256.400238, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][39], 0.589999, 6.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][39], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][39], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][39], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][39], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][39], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][39], 0);

        IDTD[playerid][40] = CreatePlayerTextDraw(playerid, 268.383361, 257.488739, ".l../.l.../..l.ll");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][40], 0.081600, 0.479900);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][40], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][40], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][40], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][40], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][40], 1);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][40], 1);

        IDTD[playerid][41] = CreatePlayerTextDraw(playerid, 316.116851, 253.108047, "radno_iskustvo:_1god");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][41], 0.096198, 0.500698);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][41], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][41], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][41], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][41], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][41], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][41], 1);

        IDTD[playerid][42] = CreatePlayerTextDraw(playerid, 309.416656, 238.999969, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][42], -0.409900, 18.000000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][42], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][42], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][42], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][42], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][42], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][42], 0);

        IDTD[playerid][43] = CreatePlayerTextDraw(playerid, 316.116851, 242.907470, gold);
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][43], 0.096198, 0.500698);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][43], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][43], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][43], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][43], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][43], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][43], 1);

        IDTD[playerid][44] = CreatePlayerTextDraw(playerid, 307.516662, 244.388961, "-");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][44], 0.272399, 0.256998);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][44], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][44], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][44], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][44], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][44], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][44], 1);

        IDTD[playerid][45] = CreatePlayerTextDraw(playerid, 307.516662, 254.289520, "-");
        PlayerTextDrawLetterSize(playerid, IDTD[playerid][45], 0.272399, 0.256998);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][45], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][45], 153);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][45], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][45], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][45], 2);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][45], 1);

        IDTD[playerid][46] = CreatePlayerTextDraw(playerid, 257.966552, 262.814971, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, IDTD[playerid][46], 139.000000, 0.560000);
        PlayerTextDrawAlignment(playerid, IDTD[playerid][46], 1);
        PlayerTextDrawColor(playerid, IDTD[playerid][46], 34);
        PlayerTextDrawSetShadow(playerid, IDTD[playerid][46], 0);
        PlayerTextDrawBackgroundColor(playerid, IDTD[playerid][46], 255);
        PlayerTextDrawFont(playerid, IDTD[playerid][46], 4);
        PlayerTextDrawSetProportional(playerid, IDTD[playerid][46], 0);

        for(new i = 0; i < 47; i++)
        {
            PlayerTextDrawShow(playerid, IDTD[playerid][i]);
        }
    }
    else
    {
        for(new i = 0; i < 47; i++)
        {
            PlayerTextDrawDestroy(playerid, IDTD[playerid][i]);
            IDTD[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    //PlayAudioStreamForPlayer(playerid, "https://nlsamp.com/loginsong.mp3");
	gPlayerLoggedIn{playerid} = false;

	return 1;
}

hook OnPlayerSpawn(playerid) 
{
	if(!IsPlayerLoggedIn(playerid) && !IsPlayerRegistering(playerid))
    {
		return overwatch_poruka(playerid, "Server zahteva prijavu pre spawna!", true);
    }
	return 1;
}

hook OnPlayerRequestSpawn(playerid)
{
    if (!IsPlayerLoggedIn(playerid)) 
    {
		overwatch_poruka(playerid, "Server zahteva prijavu pre spawna!");
		return 0;
	}
	else 
    {
	    SpawnPlayer_H(playerid);
	}
	return 1;
}

forward LogPlayerIn(playerid, vrsta);
public LogPlayerIn(playerid, vrsta)
{
    if (DebugFunctions())
    {
        LogFunctionExec("LogPlayerIn");
    }

    TogglePlayerSpectating(playerid, false);    
    
    if (vrsta == PRIJAVA_PRVIPUT)
	{
	    gPlayerLoggedIn{playerid} = true;
	    
        Iter_Remove(iPlayersConnecting, playerid);
		//format(mysql_upit, sizeof mysql_upit, "SELECT id FROM igraci WHERE ime = '%s'", ime_obicno[playerid]);
		//mysql_tquery(SQL, mysql_upit, "mysql_id_igraca", "ii", playerid, cinc[playerid]);
	    // ostatak koda za registraciju. ukoliko bude bilo potrebno - dodati

        new email[MAX_EMAIL_LEN];
        GetPVarString(playerid, "pRegEmail", email, sizeof(email));

	    // Upisivanje u log
	    format(string_256, sizeof string_256, "Igrac: %s | Email: %s | IP: %s", ime_obicno[playerid], email, PI[playerid][p_ip]);
	    Log_Write(LOG_REGISTRACIJA, string_256);
 
        // Spawn na aerodromu
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), 1682.6960, -2334.6003, 13.5524, 0.0, 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating_H(playerid, false);
        CancelSelectTextDraw(playerid);
        // Vraca spawn na ono sto treba da bude (za ubuduce)
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);

        ClearChatForPlayer(playerid);
        SendClientMessage(playerid, 0x33CCFFFF, "Dobrodosli na nas server!");
		SendClientMessage(playerid, 0x33CCFFFF, "Nadamo se da cete uzivati na nasem serveru, ukoliko vam je potrebna pomoc koristite sljedece komande:");
		SendClientMessage(playerid, NARANDZASTA, "/askq {FFFFFF} - Kontakt staff team-a");
        SendClientMessage(playerid, NARANDZASTA, "/n {FFFFFF} - Chat sa staff team-om");
        SendClientMessage(playerid, NARANDZASTA, "/novi {FFFFFF} - Vi ste nov igrac, i mozete zatraziti hitnu pomoc ovom komandom.");
       	SendClientMessage(playerid, BELA, " ");
     	SendClientMessage(playerid, ZELENA2, "Posto ste vi nov igrac, savjetujemo vam da pogledate tutorijal servera, komandom /tutorial");
        SendClientMessage(playerid, ZELENA2, "Izgled vaseg User Interface-a mozete promijeniti komandom /td -> odabir td-ova.");
        StaffMsg(COLOR_HOT_PINK_11, "- Igrac "#HOT_PINK_8"%s[%i] "#HOT_PINK_11"se upravo registrovao. Pozelite mu dobrodoslicu!", ime_rp[playerid], playerid);
        
        //SpawnPlayer(playerid);
        return 1;
        //return SPD(playerid, "FirstTimeInfo", DIALOG_STYLE_MSGBOX, "Northern Lights // UI", "Kao igrac imate mogucnost izmijeniti svoj 'User Interface' u klasican ili moderan stil.\nDa to uradite koristite komandu /td i izaberite prvu opciju koja Vam se ponudi.\n\nDa li zelite da Vas odmah odvedemo na taj odabir?", "Zelim", "Ne zelim");
	}
    // provjeri ima li dozvolu na multiacc
  //  format(mysql_upit, sizeof mysql_upit, "SELECT id FROM igraci WHERE ime = '%s' && accepted_ma = 1", ime_obicno[playerid]);
	///mysql_tquery(SQL, mysql_upit, "mysql_ma_access", "i", playerid);
    // -||-
	// -------------------------- [ POCETAK PRIJAVE ] --------------------------
	gPlayerLoggedIn{playerid} = true; // ovo na pocetku
	new 
        pol_text[11],
        potrebno_iskustvo = GetNextLevelExp(PI[playerid][p_nivo]), 
        ime_izrezano[MAX_PLAYER_NAME];

    ime_izrezano = ime_obicno[playerid];
    for__loop (new i = 0; i < strlen(ime_obicno[playerid]); i++) 
    {
        if (ime_obicno[playerid][i] == '_') 
        {
            strdel(ime_izrezano, i, strlen(ime_izrezano));
            break;
        }
    }


	// PORUKE DOBRODOSLICE:
	if (PI[playerid][p_pol] == POL_ZENSKO) pol_text = "Dobrodosla";
	else pol_text = "Dobrodosao";
	// --- // 
	//SendClientMessageF(playerid, BELA,            "________________________________________________________________________________________");
	SendClientMessageF(playerid, 0x33CCFFFF,        "%s nazad %s, lepo te je opet videti na serveru.", pol_text, ime_izrezano);
	SendClientMessageF(playerid, 0x33CCFFFF,        "Ime: {FFFFFF}%s {33CCFF}| Nivo: {FFFFFF}%d {33CCFF}| Iskustvo: {FFFFFF}%d/%d", ime_rp[playerid], PI[playerid][p_nivo], PI[playerid][p_iskustvo], potrebno_iskustvo, formatMoneyString(PI[playerid][p_novac]), formatMoneyString(PI[playerid][p_banka]));
	SendClientMessageF(playerid, 0x33CCFFFF,        "Novac: {FFFFFF}%s {33CCFF}| Banka: {FFFFFF}%s", formatMoneyString(PI[playerid][p_novac]), formatMoneyString(PI[playerid][p_banka]));
    SendClientMessageF(playerid, 0x33CCFFFF,        "Vreme provedeno u igri: {FFFFFF}%dh {33CCFF}poslednja aktivnost: {FFFFFF}%s", PI[playerid][p_provedeno_vreme], PI[playerid][p_poslednja_aktivnost]);
	SendClientMessageF(playerid, 0x33CCFFFF,        "Forum: {FFFFFF}"#FORUM);
	SendClientMessageF(playerid, 0x33CCFFFF,        "Poslednji update: {FFFFFF}v5.0, {33CCFF}datuma: {FFFFFF}1.4.2023");
	SendClientMessageF(playerid, BELA,            "________________________________________________________________________________________");
    SendClientMessageF(playerid, ZELENA2,         "AKTIVNA IGRA | {FFFFFF}Nagradjujemo vasu aktivnost! Za vise informacija upisite {00FF00}/aktivnaigra.");
    //if(GetPVarInt(playerid, "KreditTake") > 0)
    //{
    //    SendClientMessage(playerid, 0x00FF00FF, "________________________________________________________________________________________");
    //    SendClientMessage(playerid, 0x00FF00FF, "(banka) {FFFFFF}Zbog dugova nismo u stanju odrzavati vase kredite, vrijednost podignutog novca je oduzeta s vaseg racuna!");
    //}
    //SendClientMessageF(playerid, LJUBICASTA,      "VRACAMO STATS | {FFFFFF}Za povratak stats-a sa drugih servera posjetite nas forum.");
    /*if (PI[playerid][p_nivo] < 4)
        */
    //SendClientMessageF(playerid, CRVENA,          "WINTER EDITION | {FFFFFF}Stavite novogodisnju kapu: {FF0000}/kapa   {FFFFFF}|    Ukljucite sneg: {FF0000}/sneg");

    // PORUKE OSTALIM ADMINIMA/HELPERIMA AKO JE IGRAC ADMIN/HELPER
    new joinStr[128], joinColor;
    /*if (PI[playerid][p_helper] > 0) 
    {
        format(joinStr, sizeof joinStr, "HELPER | %s[%i] je usao na server.", ime_rp[playerid], playerid);
        joinColor = ZELENOZUTA;
    }
    else if (PI[playerid][p_admin] > 0 && PI[playerid][p_admin] < 6) 
    {
        format(joinStr, sizeof joinStr, "GAME ADMIN | %s[%i] je usao na server.", ime_rp[playerid], playerid);
        joinColor = SVETLOPLAVA;
    }
    else if (PI[playerid][p_admin] >= 6)
    {
        new
            isowner = IsPlayerOwner(playerid)
        ;
        if(!isowner)
        {
            format(joinStr, sizeof joinStr, "HEAD ADMIN | %s[%i] je usao na server.", ime_rp[playerid], playerid);
            joinColor = ZUTA;
        }
        else
        {
            format(joinStr, sizeof joinStr, "OWNER | %s[%i] je usao na server.", ime_rp[playerid], playerid);
            joinColor = CRVENA;
        }
    }*/
    if( PI[playerid][p_helper] == 0 || PI[playerid][p_admin] == 0)
    {
        format(joinStr, sizeof joinStr, "Igrac %s[%i] je usao na server.", ime_rp[playerid], playerid);
        joinColor = GRAD2;
    }
    foreach (new i : Player)
    {
        if (IsHelper(i, 1) && IsChatEnabled(i, CHAT_CONNECTIONS))
        {
            SendClientMessage(i, joinColor, joinStr);
        }
    }

    // NEKRETNINE
    re_provera_vlasnistva(playerid);

    new upit_80[80];

    if(pRealEstate[playerid][kuca] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_kuce WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_kuca_return", "i", playerid);
    }

    if(pRealEstate[playerid][firma] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_firme WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_firma_return", "i", playerid);
    }

    if(pRealEstate[playerid][stan] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_stanovi WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_stan_return", "i", playerid);
    }

    if(pRealEstate[playerid][hotel] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_hoteli WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_hotel_return", "i", playerid);
    }

    if(pRealEstate[playerid][garaza] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_garaze WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_garaza_return", "i", playerid);
    }

    if(pRealEstate[playerid][vikendica] == -1) {
        format(upit_80, sizeof upit_80, "SELECT id FROM re_vikendice WHERE vlasnik = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, upit_80, "mysql_vikendica_return", "i", playerid);
    }


    // UCITAVANJE STVARI
    LoadPlayerBackpack(playerid);


    // PROVERA VIP STATUSA
    VIP_LoginCheck(playerid);


    // PROVERA SA-MP CLIENT VERZIJE
    new version[24];
    GetPlayerVersion(playerid, version, sizeof version);
    if (strcmp(version, "0.3.7-R4"))
    {
        SendClientMessageF(playerid, CRVENA, "OUT OF DATE | {FFFFFF}Primetili smo da koristis zastarelu verziju SA-MP Client-a: %s", version);
        SendClientMessage(playerid, BELA, "  * Molimo te da azuriras svoj SA-MP Client na najnoviju verziju {FF9900}0.3.7-R4. {FFFFFF}Uputstvo i link za preuzimanje mozes pronaci na forumu.");
    }

    // PROVERA IZNOSA NOVCA
    if (PI[playerid][p_novac] < -30000) 
    {
        overwatch_poruka(playerid, "Imate negativnu sumu novca u rukama!");
        SendClientMessage(playerid, ZUTA, "* Savetujemo Vam da ovo prijavite na forum kako bi Vas problem bio resen.");
            
        // Obavestenje adminima
        // AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[%d]: Negativan iznos u rukama || $%d", ime_rp[playerid], playerid, PI[playerid][p_novac]);

        // Upisivanje u log
        format(string_128, sizeof string_128, "NOVAC | %s | Negativan iznos (login, ruke) | $%d", ime_obicno[playerid], PI[playerid][p_novac]);
        Log_Write(LOG_OVERWATCH, string_128);
    }
    if (PI[playerid][p_banka] < 0) 
    {
        overwatch_poruka(playerid, "Imate negativnu sumu novca u banci!");
        SendClientMessage(playerid, ZUTA, "* Savetujemo Vam da ovo prijavite na forum kako bi Vas problem bio resen.");

        // Obavestenje adminima
        // AdminMsg(CRVENA, "OVERWATCH | {FFFFFF}%s[%d]: Negativan iznos u banci || $%d", ime_rp[playerid], playerid, PI[playerid][p_banka]);

        // Upisivanje u log
        format(string_128, sizeof string_128, "NOVAC | %s | Negativan iznos (login, banka) | $%d", ime_obicno[playerid], PI[playerid][p_banka]);
        Log_Write(LOG_OVERWATCH, string_128);
    }


    // POSTAVLJANJE NOVCA
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PI[playerid][p_novac]);


    // OSTALO
    f_prijavi_igraca(playerid); // factions.pwn
    re_proveri_hotel(playerid); // real_estate.pwn
    RE_CheckTenantStatus(playerid);
    CheckPassport_Login(playerid);
    StartAFKChecker(playerid);
    LoadPlayerAccessories(playerid); // accessories.pwn
    ResetAllChats(playerid); // chat.pwn
    EXPLOSIVE_TransferToBP(playerid); // explosive.pwn
    CheckForNewNotes(playerid); // notes.pwn
    CheckPromoRewards(playerid); // promoter.pwn
    RemoveVendingMachines(playerid);
    RunPunishmentChecker(playerid);
    WAR_LoadPlayerBets(playerid);

    // LOGOVANJE
    new sQuery[70];
    format(sQuery, sizeof sQuery, "INSERT INTO ip_logins (player, ip) VALUES (%i, '%s')", PI[playerid][p_id], PI[playerid][p_ip]);
    mysql_tquery(SQL, sQuery);
    format(mysql_upit, sizeof mysql_upit, "Igrac: %s | IP: %s", ime_obicno[playerid], PI[playerid][p_ip]);
    Log_Write(LOG_USPESNAPRIJAVA, mysql_upit);

    new sQuery2[64];
    format(sQuery2, sizeof sQuery2, "UPDATE players_online SET uniqid = %i WHERE playerid = %i", PI[playerid][p_id], playerid);
    mysql_tquery(SQL, sQuery2);

    // OVAJ DEO OBAVEZNO MORA BITI NA KRAJU
    SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);
        
    // Spawn igraca je pod mysql_crash()
    Iter_Remove(iPlayersConnecting, playerid);
    if (!IsPlayerJailed(playerid)) // Ako je igrac zatvoren onda ga spawna normalno; ako nije, onda mu menja poziciju u onu koja je bila pre crasha (ako je bilo crasha)
    {
        new sQuery3[68];
        format(sQuery3, sizeof sQuery3, "SELECT * FROM crash WHERE pid = %i AND istice > %i", PI[playerid][p_id], gettime());
        mysql_tquery(SQL, sQuery3, "mysql_crash", "ii", playerid, cinc[playerid]);
    }
    else TogglePlayerSpectating_H(playerid, false); // Spawna igraca i pod OnPlayerSpawn ga stavlja u zatvor

    SetCameraBehindPlayer(playerid);

    static strdate[12], d,m,y;
    getdate(y, m, d);
    format(strdate, sizeof strdate, "%02d/%02d/%d", d, m, y);
    if (!strcmp(strdate, MOD_UPDATE))
    {
        SendClientMessage(playerid, ZUTA, "UPDATE | {FFFFFF}Skripta je danas azurirana! Da vidite sta je novo upisite {FFFF00}/update  | {FF9900}NL:RPG "#MOD_VERZIJA"");
    }

    //ShowID(playerid, true);
    //SetTimerEx("IDCONTROL", 3000, false, "ii", playerid, 1);
    if(vrsta == PRIJAVA_PRVIPUT)
        SetTimerEx("ShowRegdialog", 5000, false, "i", playerid);
    
	return 1;
}

forward IDCONTROL(playerid, type);
public IDCONTROL(playerid, type)
{
    if(type == 1)
    {
        ShowID(playerid, true);
        SetTimerEx("IDCONTROL", 5000, false, "ii", playerid, 2);
    }
    else if(type == 2)
    {
        ShowID(playerid, false);
    }
    return 1;
}

forward IsPlayerLoggedIn(playerid);
public IsPlayerLoggedIn(playerid)
{
    if (0 <= playerid < MAX_PLAYERS && IsPlayerConnected(playerid))
	   return gPlayerLoggedIn{playerid};

    return false;
}

stock SetPlayerLoggedIn(playerid, bool:status = true) 
{
	gPlayerLoggedIn{playerid} = status;
}


forward mysql_kuca_return(playerid);
public mysql_kuca_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET kuca = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][kuca] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Kuca - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Kuca - Rows: %d", ime_obicno[playerid], PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    else if(rows > 1) 
    {
        pRealEstate[playerid][kuca] = -1;

        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja kuce na vas racun. Javite se na forum obavezno");

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Kuca - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
        pRealEstate[playerid][kuca] = -1;

     //   SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja kuce na vas racun. Javite se na forum obavezno");

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Kuca - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
}

forward mysql_ma_access(playerid);
public mysql_ma_access(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_ma_access");
    }

	cache_get_row_count(rows);
	if (!rows) return 1;
    SetPVarInt(playerid, "ma_access", 1);

	return 1;
}

forward mysql_firma_return(playerid);
public mysql_firma_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET firma = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][firma] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Firma - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Firma - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    else if(rows > 1) 
    {
        pRealEstate[playerid][firma] = -1;

        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Firma - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
        pRealEstate[playerid][firma] = -1;

//        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Firma - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }

    return 1;
}

forward mysql_stan_return(playerid);
public mysql_stan_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET stan = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][stan] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Stan - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Stan - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    else if(rows > 1) 
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][stan] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Stan - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
     //   SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][stan] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Stan - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }

    return 1;
}

forward mysql_hotel_return(playerid);
public mysql_hotel_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET hotel = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][hotel] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Hotel - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Hotel - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    else if(rows > 1) 
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][hotel] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Hotel - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
     //   SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][hotel] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Hotel - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }

    
    return 1;
}
forward mysql_garaza_return(playerid);
public mysql_garaza_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET garaza = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][garaza] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Garaza - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Garaza - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    else if(rows > 1) 
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][garaza] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Garaza - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
     //   SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][garaza] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Garaza - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }

    return 1;
}

forward mysql_vikendica_return(playerid);
public mysql_vikendica_return(playerid)
{
    cache_get_row_count(rows);

    if(rows) 
    {
        new id, query[80];
        cache_get_value_index_int(0, 0, id);

        format(query, sizeof query, "UPDATE igraci SET vikendica = '%d' WHERE id = '%i'", id, PI[playerid][p_id]);
        mysql_tquery(SQL, query);

        pRealEstate[playerid][vikendica] = id;

        format(string_256, sizeof string_256, "[USPJESNO] Igrac: %s[%d] - Imovina: Vikendica - Rows: %d - ID: %d", ime_obicno[playerid],PI[playerid][p_id], rows, id);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    } 
    /*else if(rows == 0)
    {
        format(string_256, sizeof string_256, "[USPJESNO 0] Igrac: %s[%d] - Imovina: Vikendica - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }
    else if(rows > 1) 
    {
        SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][vikendica] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > 1] Igrac: %s[%d] - Imovina: Vikendica - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }*/
    else 
    {
      //  SendClientMessageF(playerid, SVETLOCRVENA, "Postoji problem kod postavljanja firme na vas racun. Javite se na forum obavezno");

        pRealEstate[playerid][vikendica] = -1;

        format(string_256, sizeof string_256, "[NEUSPJESNO > E] Igrac: %s[%d] - Imovina: Vikendica - Rows: %d", ime_obicno[playerid],PI[playerid][p_id], rows);
        Log_Write(LOG_MYSQLIMOVINA, string_256);
    }

    return 1;
}

// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_banIPCheck(playerid, nextStage);
public mysql_banIPCheck(playerid, nextStage)
{
    /*if (!checkcinc(playerid, ccinc)) {
        print("failed banIPCheck");
        return 1;
    }*/
    print("ban check");
    cache_get_row_count(rows);

    if (rows == 1) // Banovana IP adresa
    {
        new timestamp, ip[16];
        cache_get_value_index_int(0, 0, timestamp);
        GetPlayerIp(playerid, ip, sizeof ip);

        new timeLimit = timestamp + (7 * 24 * 60 * 60); // ip ban traje 7 dana
        if (gettime() < timeLimit)
        {
            SendClientMessageF(playerid, TAMNOCRVENA2, "Vasa IP adresa [%s] je banovana. Unban mozete zatraziti na forumu: {FFFFFF}"#FORUM, ip);
            Kick_Timer(playerid);
        }
    }
    else
    {
        // IP adresa nije banovana
        if (nextStage == 1) // Login
        {
            if (DebugFunctions())
            {
                LogFunctionExec("showLoginTDs");
            }
            SelectTextDraw(playerid, 0xFFFFFF88);
        }
        else if (nextStage == 2) // Registracija
        {        
            if (DebugFunctions())
            {
                LogFunctionExec("showRegisterTDs");
            }                   
        }
    }
    return 1;
}

forward mysql_banCheck(playerid, ccinc);
public mysql_banCheck(playerid, ccinc) 
{ 
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_banCheck");
    }

    if (!checkcinc(playerid, ccinc)) return 1;
    cache_get_row_count(rows);

    new 
        baninfo_admin[MAX_PLAYER_NAME], 
        baninfo_razlog[32], 
        baninfo_datum[22], 
        baninfo_istice[23],
        baninfo_istice_ts, 
        baninfo_offban, 
        baninfo_id,
        baninfo_playerid
    ;
    if (rows != 0) 
    {
        cache_get_value_index(0, 1, baninfo_admin);
        cache_get_value_index(0, 2, baninfo_razlog);
        cache_get_value_index(0, 3, baninfo_datum);
        cache_get_value_index(0, 5, baninfo_istice);
        cache_get_value_index_int(0, 4, baninfo_istice_ts);
        cache_get_value_index_int(0, 6, baninfo_offban);
        cache_get_value_index_int(0, 7, baninfo_id);
        cache_get_value_index_int(0, 8, baninfo_playerid);
    }
    
    // igrac je bio banovan ali vise nije --> izbrisati unos iz tabele
    if (rows != 0 && baninfo_istice_ts < gettime() && baninfo_istice_ts > 0) {
        format(mysql_upit, sizeof mysql_upit, "DELETE FROM banovi WHERE pid = '%d'", PI[playerid][p_id]);
        mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->
    }
    
    // igrac nije banovan --> ucitaj mu sve podatke
    if (rows == 0 || (baninfo_istice_ts < gettime() && baninfo_istice_ts > 0)) 
    {
        // fixed by daddyDOT 17.5.2022 (error: [ERROR] cache_get_value_name_int: value 'NULL' is not a number (C:\Users\korisnik\Documents\nl4.2\gamemodes\modules\core\loginNew.pwn:19753))
        new query[352];    
        format(query, sizeof query, "SELECT *, UNIX_TIMESTAMP(org_kazna) as org_kazna, DATE_FORMAT(poslednja_aktivnost, '\%%d \%%b \%%Y, \%%H:\%%i') as last_act, DATE_FORMAT(datum_registracije, '\%%d \%%b \%%Y, \%%H:\%%i') as reg_date, DATE_FORMAT(pasos, '\%%d/\%%m/\%%Y') as pasos1, UNIX_TIMESTAMP(pasos) as pasos_ts FROM igraci WHERE ime = '%s'", ime_obicno[playerid]);
        mysql_tquery(SQL, query, "mysql_login", "i", playerid);

        return 1;
    }
    
    // igrac je banovan
    ClearChatForPlayer(playerid);

    new string[650];
    format (string, sizeof string, "{FF0000}Vas nalog je iskljucen sa servera! (ban id: %d)\n\n{FFFFFF}Vase ime: {FF6347}%s [id: %d]\n{FFFFFF}Game Admin: {FF6347}%s\n{FFFFFF}Vreme iskljucenja: {FF6347}%s\n\n{FFFFFF}Razlog iskljucenja: {FF6347}%s\n", baninfo_id, ime_obicno[playerid], baninfo_playerid, baninfo_admin, baninfo_datum, baninfo_razlog);
    if (baninfo_istice_ts == 0)
        format(string, sizeof string, "%s{FFFFFF}Ban istice: {FF0000}nikada", string);
    else 
        format(string, sizeof string, "%s{FFFFFF}Ban istice: {FF6347}%s", string, baninfo_istice);
    format(string, sizeof string, "%s\n\n{A4CCF2}Ponovno ukljucenje naloga mozete zatraziti na forumu: {FF6347}"#FORUM, string);
    format(string, sizeof string, "%s\n{FFFFFF}Trenutno vreme: %s", string, trenutno_vreme());

    if (baninfo_offban == 1)
        format(string, sizeof string, "%s\n\n{FF0000}NAPOMENA: {FFFFFF}Vas nalog je iskljucen dok ste bili odsutni sa servera. (offban)", string);
    
    SPD(playerid, "login_ban", DIALOG_STYLE_MSGBOX, "{FF0000}Ban", string, "Kick", "");
    Kick_Timer(playerid);
    return 1;
}

forward mysql_login(playerid);
public mysql_login(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_login");
    }

	cache_get_row_count(rows);
	
	if(rows != 1) return Kick_Timer(playerid);
	new spawn[63], bombe[6], aktivnaigra[15], aktivnaigra_ts, aktivnaigra_poeni, sHexName[11], selectedtd, babobabo, Taskstr[128], dmarenastr[15];
	
    cache_get_value_name(0, "email",                        PI[playerid][p_email], MAX_EMAIL_LEN);
    cache_get_value_name(0, "kartica",                      PI[playerid][p_kartica], 17);
    cache_get_value_name(0, "drzava",                       PI[playerid][p_drzava], 11);
    cache_get_value_name(0, "naglasak",                     PI[playerid][p_naglasak], 13);
    cache_get_value_name(0, "mobilni",                      PI[playerid][p_mobilni], 13);
    cache_get_value_name(0, "sim",                          PI[playerid][p_sim], 11);
    cache_get_value_name(0, "reg_date",                     PI[playerid][p_datum_registracije], 22);
    cache_get_value_name(0, "last_act",                     PI[playerid][p_poslednja_aktivnost], 22);
    cache_get_value_name(0, "spawn",                        spawn);
    cache_get_value_name(0, "bombe",                        bombe);
    cache_get_value_name(0, "pasos1",                       PI[playerid][p_pasos], 11); // istek pasosa, dd/mm/yyyy
    cache_get_value_name(0, "aktivnaigra",                  aktivnaigra, 15);
    cache_get_value_name(0, "area_razlog",                  PI[playerid][p_area_razlog], 32);
    cache_get_value_name(0, "utisan_razlog",                PI[playerid][p_utisan_razlog], 32);
    cache_get_value_name(0, "referral",                     PI[playerid][p_referral], MAX_PLAYER_NAME);
    cache_get_value_name(0, "boja_imena",                   sHexName, sizeof sHexName);
	
    cache_get_value_name_int(0, "sim_broj",                 PI[playerid][p_sim_broj]);
    cache_get_value_name_int(0, "sim_kredit",               PI[playerid][p_sim_kredit]);

    cache_get_value_name_int(0, "nivo",                     PI[playerid][p_nivo]);
    cache_get_value_name_int(0, "iskustvo",                 PI[playerid][p_iskustvo]);
    cache_get_value_name_int(0, "payday",                   PI[playerid][p_payday]);
    cache_get_value_name_int(0, "novac",                    PI[playerid][p_novac]);
    cache_get_value_name_int(0, "banka",                    PI[playerid][p_banka]);
    cache_get_value_name_int(0, "gold",                     PI[playerid][p_token]);
    cache_get_value_name_int(0, "zlato",                    PI[playerid][p_zlato]);
    cache_get_value_name_int(0, "org_id",                   PI[playerid][p_org_id]);
    cache_get_value_name_int(0, "org_vreme",                PI[playerid][p_org_vreme]);
    cache_get_value_name_int(0, "org_kazna",                PI[playerid][p_org_kazna]);
    cache_get_value_name_int(0, "posao_zarada",             PI[playerid][p_posao_zarada]);
    cache_get_value_name_int(0, "posao_payday",             PI[playerid][p_posao_payday]);
    cache_get_value_name_int(0, "pol",                      PI[playerid][p_pol]);
    cache_get_value_name_int(0, "starost",                  PI[playerid][p_starost]);
    cache_get_value_name_int(0, "skin",                     PI[playerid][p_skin]);
    cache_get_value_name_int(0, "stil_borbe",               PI[playerid][p_stil_borbe]);
    cache_get_value_name_int(0, "stil_hodanja",             PI[playerid][p_stil_hodanja]);
    cache_get_value_name_int(0, "zatvoren",                 PI[playerid][p_zatvoren]);
    cache_get_value_name_int(0, "area",                     PI[playerid][p_area]);
    cache_get_value_name_int(0, "utisan",                   PI[playerid][p_utisan]);
    cache_get_value_name_int(0, "opomene",                  PI[playerid][p_opomene]);
    cache_get_value_name_int(0, "zavezan",                  PI[playerid][p_zavezan]);
    cache_get_value_name_int(0, "telefon",                  PI[playerid][p_telefon]);
    cache_get_value_name_int(0, "glad",                     PI[playerid][p_glad]);
    cache_get_value_name_int(0, "kaznjen_puta",             PI[playerid][p_kaznjen_puta]);
    cache_get_value_name_int(0, "uhapsen_puta",             PI[playerid][p_uhapsen_puta]);
    cache_get_value_name_int(0, "torba",                    PI[playerid][p_torba]);
    cache_get_value_name_int(0, "kaucija",                  PI[playerid][p_kaucija]);
    cache_get_value_name_int(0, "reload_market",            PI[playerid][p_reload_market]);
    cache_get_value_name_int(0, "reload_mehanicar",         PI[playerid][p_reload_mehanicar]);
    cache_get_value_name_int(0, "reload_bribe",             PI[playerid][p_reload_bribe]);
    cache_get_value_name_int(0, "reload_fv",                PI[playerid][p_reload_fv]);
    cache_get_value_name_int(0, "reload_namechange",        PI[playerid][p_reload_namechange]);
    cache_get_value_name_int(0, "dozvola_voznja",           PI[playerid][p_dozvola_voznja]);
    cache_get_value_name_int(0, "dozvola_letenje",          PI[playerid][p_dozvola_letenje]);
    cache_get_value_name_int(0, "dozvola_plovidba",         PI[playerid][p_dozvola_plovidba]);
    cache_get_value_name_int(0, "dozvola_oruzje",           PI[playerid][p_dozvola_oruzje]);
    cache_get_value_name_int(0, "kartica_pin",              PI[playerid][p_kartica_pin]);
    cache_get_value_name_int(0, "kredit_iznos",             PI[playerid][p_kredit_iznos]);
    cache_get_value_name_int(0, "kredit_otplata",           PI[playerid][p_kredit_otplata]);
    cache_get_value_name_int(0, "kredit_rata",              PI[playerid][p_kredit_rata]);
    cache_get_value_name_int(0, "offpm_vreme",              PI[playerid][p_offpm_vreme]);
    cache_get_value_name_int(0, "offpm_ugasen",             PI[playerid][p_offpm_ugasen]);
    cache_get_value_name_int(0, "provedeno_vreme",          PI[playerid][p_provedeno_vreme]);
    cache_get_value_name_int(0, "hotel_soba",               PI[playerid][p_hotel_soba]);
    cache_get_value_name_int(0, "hotel_cena",               PI[playerid][p_hotel_cena]);
    cache_get_value_name_int(0, "rent_kuca",                PI[playerid][p_rent_kuca]);
    cache_get_value_name_int(0, "rent_cena",                PI[playerid][p_rent_cena]);
    cache_get_value_name_int(0, "vozila_slotovi",           PI[playerid][p_vozila_slotovi]);
    cache_get_value_name_int(0, "imanja_slotovi",           PI[playerid][p_imanja_slotovi]);
    cache_get_value_name_int(0, "war_ubistva",              PI[playerid][p_war_ubistva]);
    cache_get_value_name_int(0, "war_smrti",                PI[playerid][p_war_smrti]);
    cache_get_value_name_int(0, "war_samoubistva",          PI[playerid][p_war_samoubistva]);
    cache_get_value_name_int(0, "eksploziv",                PI[playerid][p_eksploziv]);
    cache_get_value_name_int(0, "detonatori",               PI[playerid][p_detonatori]);
    cache_get_value_name_int(0, "wanted_level",             PI[playerid][p_wanted_level]);
    cache_get_value_name_int(0, "pasos_ts",                 PI[playerid][p_pasos_ts]);
    cache_get_value_name_int(0, "announcement",             PI[playerid][p_announcement]);
    cache_get_value_name_int(0, "paketici",                 PI[playerid][p_paketici]);
    cache_get_value_name_int(0, "treasure_hunt",            PI[playerid][p_treasure_hunt]);
    cache_get_value_name_int(0, "dj",                       PI[playerid][p_dj]);
    cache_get_value_name_int(0, "promo_hashtag",            PI[playerid][p_promo_hashtag]);
    cache_get_value_name_int(0, "reload_pay",               PI[playerid][p_reload_pay]);
    cache_get_value_name_int(0, "reload_vehicle_theft",     PI[playerid][p_reload_vehicle_theft]);
    cache_get_value_name_int(0, "cheater",                  PI[playerid][p_cheater]);
    cache_get_value_name_int(0, "tuning_pass",              PI[playerid][p_tuning_pass]);
    cache_get_value_name_int(0, "custom_flags",             PI[playerid][p_custom_flags]);
    cache_get_value_name_int(0, "donacije",                 PI[playerid][p_donacije]);
    cache_get_value_name_int(0, "vip_level",                PI[playerid][p_vip_level]);
    cache_get_value_name_int(0, "vip_istice",               PI[playerid][p_vip_istice]);
    cache_get_value_name_int(0, "vip_refill",               PI[playerid][p_vip_refill]);
    cache_get_value_name_int(0, "vip_replenish",            PI[playerid][p_vip_replenish]);
    cache_get_value_name_int(0, "skill_cop",                PI[playerid][p_skill_cop]);
    cache_get_value_name_int(0, "skill_criminal",           PI[playerid][p_skill_criminal]);
    cache_get_value_name_int(0, "division_points",          PI[playerid][p_division_points]);
    cache_get_value_name_int(0, "division_expiry",          PI[playerid][p_division_expiry]);
    cache_get_value_name_int(0, "division_treshold_up",     PI[playerid][p_division_treshold_up]);
    cache_get_value_name_int(0, "division_treshold_dn",     PI[playerid][p_division_treshold_dn]);
    cache_get_value_name_int(0, "division_reload_up",       PI[playerid][p_division_reload_up]);
    cache_get_value_name_int(0, "division_reload_dn",       PI[playerid][p_division_reload_dn]);
    cache_get_value_name_int(0, "robbed_atms",              PI[playerid][p_robbed_atms]);
    cache_get_value_name_int(0, "robbed_stores",            PI[playerid][p_robbed_stores]);
    cache_get_value_name_int(0, "stolen_cars",              PI[playerid][p_stolen_cars]);
    cache_get_value_name_int(0, "arrested_criminals",       PI[playerid][p_arrested_criminals]);
    cache_get_value_name_int(0, "atm_stolen_cash",          PI[playerid][p_atm_stolen_cash]);
    cache_get_value_name_int(0, "stores_stolen_cash",       PI[playerid][p_stores_stolen_cash]);
    cache_get_value_name_int(0, "zabrana_oruzje",           PI[playerid][p_zabrana_oruzje]);
    cache_get_value_name_int(0, "zabrana_lider",            PI[playerid][p_zabrana_lider]);
    cache_get_value_name_int(0, "zabrana_staff",            PI[playerid][p_zabrana_staff]);
    cache_get_value_name_int(0, "warn_dm",                  PI[playerid][p_warn_dm]);
    cache_get_value_name_int(0, "warn_turf_interrupt",      PI[playerid][p_warn_turf_interrupt]);
    cache_get_value_name_int(0, "warn_vip_abuse",           PI[playerid][p_warn_vip_abuse]);
    cache_get_value_name_int(0, "p_pasos_bonus",            PI[playerid][p_pasos_bonus]);
    cache_get_value_name_int(0, "p_vozacka_bonus",          PI[playerid][p_vozacka_bonus]);
    cache_get_value_name_int(0, "p_posao_bonus",            PI[playerid][p_posao_bonus]);
    cache_get_value_name_int(0, "p_nivo_bonus",             PI[playerid][p_nivo_bonus]);
    cache_get_value_name_int(0, "p_org_bonus",              PI[playerid][p_org_bonus]);

    cache_get_value_name_int(0, "kuca",                     pRealEstate[playerid][kuca]);
    cache_get_value_name_int(0, "stan",                     pRealEstate[playerid][stan]);
    cache_get_value_name_int(0, "firma", 			        pRealEstate[playerid][firma]);
    cache_get_value_name_int(0, "hotel", 			        pRealEstate[playerid][hotel]);
    cache_get_value_name_int(0, "garaza",                   pRealEstate[playerid][garaza]);
    cache_get_value_name_int(0, "vikendica",                pRealEstate[playerid][vikendica]);
	   
    cache_get_value_name_float(0, "war_dmg_taken",          PI[playerid][p_war_dmg_taken]);
    cache_get_value_name_float(0, "war_dmg_given",          PI[playerid][p_war_dmg_given]);

    cache_get_value_name(0, "p_discord_id",                 PI[playerid][p_discord_id], 21);

    cache_get_value_name_int(0, "p_rudnik_zlato",                PI[playerid][p_rudnik_zlato]);
    cache_get_value_name_int(0, "p_odradio_posao",                PI[playerid][p_odradio_posao]);

    cache_get_value_name_int(0, "tdselected",                selectedtd);
    cache_get_value_name_int(0, "babo",                      babobabo);
    cache_get_value_name(0, "Zadaci",                        Taskstr);
    cache_get_value_name(0, "dmstats",                       dmarenastr);

    SetMobileVar(playerid, PI[playerid][p_mobilni]);
    SetSimVar(playerid, PI[playerid][p_sim]);
    SetSimNumber(playerid, PI[playerid][p_sim_broj]);
    SetSimCredit(playerid, PI[playerid][p_sim_kredit]);

    SetTasksVars(playerid, Taskstr); 
    SetDMStats(playerid, dmarenastr);
    SetPlayerBabo(playerid, babobabo);
	sscanf(spawn, "p<|>ffffiiff", PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], PI[playerid][p_spawn_ent], PI[playerid][p_spawn_vw], PI[playerid][p_spawn_health], PI[playerid][p_spawn_armour]);
    sscanf(bombe, "p<|>iii", PI[playerid][p_bomba][BOMBA_S], PI[playerid][p_bomba][BOMBA_M], PI[playerid][p_bomba][BOMBA_L]);
    sscanf(aktivnaigra, "p<|>ii", aktivnaigra_ts, aktivnaigra_poeni);

    //if(PI[playerid][p_kredit_iznos] > 0)
    //{
    //    PI[playerid][p_banka] -= PI[playerid][p_kredit_iznos];
    //    SetPVarInt(playerid, "KreditTake", PI[playerid][p_kredit_iznos]);
    //    PI[playerid][p_kredit_iznos] =
    //    PI[playerid][p_kredit_otplata] =
    //    PI[playerid][p_kredit_rata] = 0;
    //    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET kredit_iznos = %d, kredit_otplata = %d, kredit_rata = %i, banka = %i WHERE id = %d", PI[playerid][p_kredit_iznos], PI[playerid][p_kredit_otplata], PI[playerid][p_kredit_rata], PI[playerid][p_banka], PI[playerid][p_id]);
    //    mysql_tquery(SQL, mysql_upit);
    //}

    PI[playerid][p_boja_imena] = HexToInt(sHexName);

    SetPlayerScore(playerid, PI[playerid][p_nivo]);
    SetPlayerFightingStyle(playerid, PI[playerid][p_stil_borbe]);
    SetPlayerWorldBounds(playerid, 6000, -6000, 6000, -6000);

    // Vracanje poena od aktivne igre
    AKTIGRA_Restore(playerid, aktivnaigra_ts, aktivnaigra_poeni);
	
    // Postavljanje levela (staff)
	PI[playerid][p_admin]      = GetPVarInt(playerid, "pLoginAdmin");
	PI[playerid][p_helper]     = GetPVarInt(playerid, "pLoginHelper");
    PI[playerid][p_promoter]   = GetPVarInt(playerid, "pLoginPromoter");

    // Postavljanje flagova
    FLAGS_SetupCustomFlags(playerid);
    FLAGS_SetupStaffFlags(playerid);
    FLAGS_SetupPromoterFlags(playerid);
    FLAGS_SetupVIPFlags(playerid);

    // Vreme na duznosti za juce
    if (IsHelper(playerid, 1))
    {
        new sQuery[110];
        format(sQuery, sizeof sQuery, "SELECT dutyTime FROM staff_activity WHERE DATE(date) = DATE_SUB(CURDATE(), INTERVAL 1 DAY) AND pid = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery, "MySQL_OnDutyTimeLoad", "ii", playerid, cinc[playerid]);
    }
	
	// Crimes ucitavanje
	LoadPlayerCrimes(playerid);
	
	// Ucitavanje vozila
	OwnedVehicle_LoadForPlayer(playerid);
	OwnedVehicle_SellOffline(playerid);

    // Ucitavanje imanja
    Land_LoadForPlayer(playerid);

    // Ucitavanje skillova za poslove
    loadJobSkills(playerid, cache_save());

    // Login
	LogPlayerIn(playerid, PRIJAVA_NORMAL);

    // Brisanje PVar-ova
    DeletePVar(playerid, "pLoginAdmin");
    DeletePVar(playerid, "pLoginHelper");
    DeletePVar(playerid, "pLoginPromoter");
    DeletePVar(playerid, "pLoginPin_Correct");
    //DeletePVar(playerid, "pLoginPass_Correct");
	return 1;
}

forward MySQL_OnDutyTimeLoad(playerid, ccinc);
public MySQL_OnDutyTimeLoad(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    new dutyTime = 0;
    cache_get_row_count(rows);
    if (rows)
    {
        cache_get_value_index_int(0, 0, dutyTime);
    }

    new colorHex, colorRGB[7];
    if (IsAdmin(playerid, 1)) colorHex = PLAVA, colorRGB = "1275ED";
    else colorHex = ZELENOZUTA, colorRGB = "8EFF00";

    new hours = floatround(dutyTime/3600, floatround_floor),
        mins  = floatround((dutyTime - hours*3600)/60, floatround_floor);
    SendClientMessageF(playerid, colorHex, "DUTY TIME | {FFFFFF}Juce ste na duznosti proveli {%s}%i sati i %i minuta.", colorRGB, hours, mins);
    return 1;
}

// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:login_passNew(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;
    if (isnull(inputtext)) return DialogReopen(playerid);

    new pass[25];
    format(pass, sizeof pass, "%s", inputtext);

    for__loop (new i = 0; i < strlen(pass); i++) {
        if (pass[i] == '~')
            pass[i] = ' ';
    }

    // if (strlen(pass) > 25)
    //     pass[25] = EOS;

    SetPVarString(playerid, "pLoginPass", pass);

    /*if (strlen(pass) < 6) 
    {
        ErrorMsg(playerid, "Lozinka je suvise kratka (najmanje 6 znakova).");
        //ptdLogin_SetPass(playerid, false);
        return DialogReopen(playerid);
    }

    if (strlen(pass) > 24) 
    {
        ErrorMsg(playerid, "Lozinka je suvise dugacka (najvise 24 znaka).");
        //ptdLogin_SetPass(playerid, false);
        return DialogReopen(playerid);
    }*/

    new correctPass[MAX_PASSWORD_LEN];
    GetPVarString(playerid, "pLoginPass_Correct", correctPass, MAX_PASSWORD_LEN);
    if (!strcmp(pass, correctPass, false))
    {
        ////ptdLogin_SetPassNew(playerid, true);
        //
        ClearChatForPlayer(playerid);

        if ((GetPVarInt(playerid, "pLoginAdmin") > 0 || GetPVarInt(playerid, "pLoginHelper") > 0) && GetPVarInt(playerid, "pLoginPin") != 0) // Uneo pin
        {
            if (GetPVarInt(playerid, "pLoginPin") == GetPVarInt(playerid, "pLoginPin_Correct")) // Uneo je ispravan pin
            {
                CancelSelectTextDraw(playerid);

                // Prosao sve provere, uspesan login. Da li je acc banovan?
                static upit[330];
                format(upit, sizeof upit, "SELECT i.ime, b.admin, b.razlog, DATE_FORMAT(b.datum, '\%%d \%%b \%%Y, \%%H:\%%i') as datum, UNIX_TIMESTAMP(b.istice) as istice_ts, DATE_FORMAT(b.istice, '\%%d \%%b \%%Y, \%%H:\%%i') as istice, b.offban, b.id, i.id FROM banovi b INNER JOIN igraci i ON b.pid = i.id WHERE i.ime = '%s'", ime_obicno[playerid]);
                mysql_tquery(SQL, upit, "mysql_banCheck", "ii", playerid, cinc[playerid]);
                return ~1;
            }
        }
    }
    else 
    {
        SetPVarInt(playerid, "pLoginFailed", GetPVarInt(playerid, "pLoginFailed")+1);
        if (GetPVarInt(playerid, "pLoginFailed") < 3) 
        {
            format(string_64, 64, "Uneli ste pogresnu lozinku (%d/3)", GetPVarInt(playerid, "pLoginFailed"));
            ErrorMsg(playerid, string_64);
        }
        else 
        {
            return Kick_Timer(playerid), printf("%s : %d", __file, __line);
        }
        ////ptdLogin_SetPassNew(playerid, false);
    }
    return 1;
}

Dialog:login_pass(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;
    if (isnull(inputtext)) return DialogReopen(playerid);

    new pass[25];
    format(pass, sizeof pass, "%s", inputtext);

    for__loop (new i = 0; i < strlen(pass); i++) {
        if (pass[i] == '~')
            pass[i] = ' ';
    }

    // if (strlen(pass) > 25)
    //     pass[25] = EOS;

    SetPVarString(playerid, "pLoginPass", pass);

    if (strlen(pass) < 6) 
    {
        ErrorMsg(playerid, "Lozinka je suvise kratka (najmanje 6 znakova).");
        //ptdLogin_SetPass(playerid, false);
        return DialogReopen(playerid);
    }

    if (strlen(pass) > 24) 
    {
        ErrorMsg(playerid, "Lozinka je suvise dugacka (najvise 24 znaka).");
        //ptdLogin_SetPass(playerid, false);
        return DialogReopen(playerid);
    }

    new correctPass[MAX_PASSWORD_LEN];
    GetPVarString(playerid, "pLoginPass_Correct", correctPass, MAX_PASSWORD_LEN);
    if (!strcmp(pass, correctPass, false))
    {
        //ptdLogin_SetPass(playerid, true);
    }
    else 
    {
        SetPVarInt(playerid, "pLoginFailed", GetPVarInt(playerid, "pLoginFailed")+1);
        if (GetPVarInt(playerid, "pLoginFailed") < 3) 
        {
            format(string_64, 64, "Uneli ste pogresnu lozinku (%d/3)", GetPVarInt(playerid, "pLoginFailed"));
            ErrorMsg(playerid, string_64);
        }
        else 
        {
            return Kick_Timer(playerid), printf("%s : %d", __file, __line);
        }
        //ptdLogin_SetPass(playerid, false);
    }
    return 1;
}

Dialog:login_pinNew(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

    new
        pin;

    if (sscanf(inputtext, "i", pin))
        return DialogReopen(playerid);

    SetPVarInt(playerid, "pLoginPin", pin);

    if (pin == GetPVarInt(playerid, "pLoginPin_Correct"))
    {
        //ptdLogin_SetPinNew(playerid, true);
        //
        static 
            pass[MAX_PASSWORD_LEN];

        ClearChatForPlayer(playerid);
        GetPVarString(playerid, "pLoginPass", pass, MAX_PASSWORD_LEN);
        if (strcmp(pass, "", false)) // Nije uneo lozinku
        {
            print("proslo pin");
            static correctPass[MAX_PASSWORD_LEN];
            GetPVarString(playerid, "pLoginPass_Correct", correctPass, MAX_PASSWORD_LEN);
            if (!strcmp(pass, correctPass, false)) // Uneo netacnu lozinku
            {
                CancelSelectTextDraw(playerid);

                // Prosao sve provere, uspesan login. Da li je acc banovan?
                static upit[330];
                format(upit, sizeof upit, "SELECT i.ime, b.admin, b.razlog, DATE_FORMAT(b.datum, '\%%d \%%b \%%Y, \%%H:\%%i') as datum, UNIX_TIMESTAMP(b.istice) as istice_ts, DATE_FORMAT(b.istice, '\%%d \%%b \%%Y, \%%H:\%%i') as istice, b.offban, b.id, i.id FROM banovi b INNER JOIN igraci i ON b.pid = i.id WHERE i.ime = '%s'", ime_obicno[playerid]);
                mysql_tquery(SQL, upit, "mysql_banCheck", "ii", playerid, cinc[playerid]);
                return ~1;
            }
        }
    }
    else 
    {
        SetPVarInt(playerid, "pPinFailed", GetPVarInt(playerid, "pPinFailed")+1);
        if (GetPVarInt(playerid, "pPinFailed") < 2) 
        {
            format(string_64, 64, "Uneli ste pogresan pin (%d/2)", GetPVarInt(playerid, "pPinFailed"));
            ErrorMsg(playerid, string_64);
        }
        else 
        {
            return Kick_Timer(playerid), printf("%s : %d", __file, __line);
        }
        //ptdLogin_SetPinNew(playerid, false);
    }
    return 1;
}

Dialog:login_pin(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

    new pin;
    if (sscanf(inputtext, "i", pin))
        return DialogReopen(playerid); 

    SetPVarInt(playerid, "pLoginPin", pin);

    if (pin == GetPVarInt(playerid, "pLoginPin_Correct"))
    {
        //ptdLogin_SetPin(playerid, true);
    }
    else 
    {
        SetPVarInt(playerid, "pPinFailed", GetPVarInt(playerid, "pPinFailed")+1);
        if (GetPVarInt(playerid, "pPinFailed") < 2) 
        {
            format(string_64, 64, "Uneli ste pogresan pin (%d/2)", GetPVarInt(playerid, "pPinFailed"));
            ErrorMsg(playerid, string_64);
        }
        else 
        {
            return Kick_Timer(playerid), printf("%s : %d", __file, __line);
        }
        //ptdLogin_SetPin(playerid, false);
    }
    return 1;
}

Dialog:login_ban(playerid, response, listitem, const inputtext[]) 
{
    return Kick(playerid);
}

cmd:idcard(playerid)
{
    ShowID(playerid, false);
    return 1;
}
