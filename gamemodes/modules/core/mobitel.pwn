// TODO: srediti poziv za delivery, policiju i sl.

#include <YSI_Coding\y_hooks>

#define MOBILEPHO_SIZE 11
#define MOBILEMSG_SIZE 13
#define MOBILEBG_SIZE  19
#define MOBILEOUT_SIZE 25
#define MOBILEBUT_SIZE 33

new
    PlayerNumber[MAX_PLAYERS],
    PlayerOperator[MAX_PLAYERS][11],
    BeingCalled[MAX_PLAYERS],
    Dialing[MAX_PLAYERS],
    ResetPlayerCall[MAX_PLAYERS],
    TalkingWith[MAX_PLAYERS],
    PlayerPhone[MAX_PLAYERS][13],
    PlayerCredit[MAX_PLAYERS]
;

new
    bool:Talking[MAX_PLAYERS char],
    bool:InMobile[MAX_PLAYERS char],
    bool:AdNotif[MAX_PLAYERS char]
;

new
    PlayerText:MobileBG[MAX_PLAYERS][MOBILEBG_SIZE],
    PlayerText:MobileOUT[MAX_PLAYERS][MOBILEOUT_SIZE],
    PlayerText:MobileBUT[MAX_PLAYERS][MOBILEBUT_SIZE],
    PlayerText:MobileMSG[MAX_PLAYERS][MOBILEMSG_SIZE],
    PlayerText:MobilePHO[MAX_PLAYERS][MOBILEPHO_SIZE]
;

static
    bool:MobileShowedBG[MAX_PLAYERS char],
    bool:MobileShowedOUT[MAX_PLAYERS char],
    bool:MobileShowedBUT[MAX_PLAYERS char],
    bool:MobileShowedMSG[MAX_PLAYERS char],
    bool:MobileShowedPHO[MAX_PLAYERS char]
;

static
    PlayerMessage[MAX_PLAYERS][4][64],
    PlayerMessageNumber[MAX_PLAYERS][4][10],
    PlayerMessageLast[MAX_PLAYERS]
;

new
    AdInfo[63 + 1],
    AdFrom[12 + 1],
    bool:AdCooldown
;

MobileBackground(playerid, bool:bgshow)
{
    if(bgshow)
    {
        MobileBG[playerid][0] = CreatePlayerTextDraw(playerid, 468.749877, 190.777786, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][0], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][0], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][0], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][0], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][0], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][0], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][0], 0);

        MobileBG[playerid][1] = CreatePlayerTextDraw(playerid, 464.583282, 196.481536, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][1], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][1], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][1], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][1], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][1], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][1], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][1], 0);

        MobileBG[playerid][2] = CreatePlayerTextDraw(playerid, 536.250000, 192.333389, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][2], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][2], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][2], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][2], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][2], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][2], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][2], 0);

        MobileBG[playerid][3] = CreatePlayerTextDraw(playerid, 539.783386, 196.763092, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][3], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][3], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][3], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][3], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][3], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][3], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][3], 0);

        MobileBG[playerid][4] = CreatePlayerTextDraw(playerid, 465.283416, 366.037078, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][4], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][4], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][4], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][4], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][4], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][4], 0);

        MobileBG[playerid][5] = CreatePlayerTextDraw(playerid, 467.566802, 371.859283, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][5], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][5], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][5], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][5], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][5], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][5], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][5], 0);

        MobileBG[playerid][6] = CreatePlayerTextDraw(playerid, 537.266784, 371.540771, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][6], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][6], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][6], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][6], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][6], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][6], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][6], 0);

        MobileBG[playerid][7] = CreatePlayerTextDraw(playerid, 541.200012, 365.873992, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][7], 23.000000, 27.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][7], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][7], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][7], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][7], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][7], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][7], 0);

        MobileBG[playerid][8] = CreatePlayerTextDraw(playerid, 468.283447, 208.244308, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][8], 91.000000, 176.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][8], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][8], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][8], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][8], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][8], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][8], 0);

        MobileBG[playerid][9] = CreatePlayerTextDraw(playerid, 480.783508, 196.162887, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][9], 69.000000, 21.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][9], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][9], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][9], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][9], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][9], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][9], 0);

        MobileBG[playerid][10] = CreatePlayerTextDraw(playerid, 479.866973, 374.214782, "ld_spac:white");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][10], 69.000000, 21.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][10], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][10], -2100762881);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][10], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][10], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][10], 0);

        MobileBG[playerid][11] = CreatePlayerTextDraw(playerid, 459.199859, 189.622268, "particle:shad_ped");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][11], 108.000000, 218.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][11], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][11], 50);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][11], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][11], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][11], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][11], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][11], 0);

        MobileBG[playerid][12] = CreatePlayerTextDraw(playerid, 459.199859, 189.622268, "particle:shad_ped");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][12], 108.000000, 218.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][12], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][12], 1097446165);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][12], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][12], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][12], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][12], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][12], 0);

        MobileBG[playerid][13] = CreatePlayerTextDraw(playerid, 444.533355, 235.725631, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][13], 140.000000, 191.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][13], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][13], 1097446178);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][13], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][13], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][13], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][13], 0);

        MobileBG[playerid][14] = CreatePlayerTextDraw(playerid, 473.733520, 287.103668, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][14], 80.000000, 108.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][14], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][14], -103);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][14], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][14], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][14], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][14], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][14], 0);

        MobileBG[playerid][15] = CreatePlayerTextDraw(playerid, 480.783355, 177.133255, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][15], 89.000000, 108.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][15], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][15], 1096533265);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][15], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][15], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][15], 4);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][15], 0);

        MobileBG[playerid][16] = CreatePlayerTextDraw(playerid, 496.516632, 206.596389, "particle:shad_ped");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][16], 55.000000, 67.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][16], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][16], 50);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][16], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][16], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][16], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][16], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][16], 0);

        MobileBG[playerid][17] = CreatePlayerTextDraw(playerid, 490.466644, 255.792633, "particle:shad_ped");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][17], 30.000000, 37.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][17], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][17], 37);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][17], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][17], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][17], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][17], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][17], 0);

        MobileBG[playerid][18] = CreatePlayerTextDraw(playerid, 470.733551, 289.922332, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, MobileBG[playerid][18], 84.000000, -93.000000);
        PlayerTextDrawAlignment(playerid, MobileBG[playerid][18], 1);
        PlayerTextDrawColor(playerid, MobileBG[playerid][18], -188);
        PlayerTextDrawSetShadow(playerid, MobileBG[playerid][18], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][18], 255);
        PlayerTextDrawFont(playerid, MobileBG[playerid][18], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBG[playerid][18], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBG[playerid][18], 0);

        MobileShowedBG{playerid} = true;

        for(new i = 0; i < MOBILEBG_SIZE; i++)
            PlayerTextDrawShow(playerid, MobileBG[playerid][i]);
    }
    else
    {
        MobileShowedBG{playerid} = false;

        for(new i = 0; i < MOBILEBG_SIZE; i++)
        {
            PlayerTextDrawHide(playerid, MobileBG[playerid][i]);
            PlayerTextDrawDestroy(playerid, MobileBG[playerid][i]);
            MobileBG[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

MobileOutline(playerid, bool:outlineshow)
{
    if(outlineshow)
    {
        MobileOUT[playerid][0] = CreatePlayerTextDraw(playerid, 466.982696, 194.825805, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][0], 15.000000, 17.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][0], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][0], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][0], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][0], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][0], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][0], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][0], 0);

        MobileOUT[playerid][1] = CreatePlayerTextDraw(playerid, 467.882812, 195.825897, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][1], 15.000000, 17.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][1], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][1], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][1], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][1], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][1], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][1], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][1], 0);

        MobileOUT[playerid][2] = CreatePlayerTextDraw(playerid, 481.116790, 195.107406, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][2], 68.000000, 3.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][2], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][2], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][2], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][2], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][2], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][2], 0);

        MobileOUT[playerid][3] = CreatePlayerTextDraw(playerid, 561.273437, 194.825805, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][3], -14.000000, 17.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][3], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][3], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][3], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][3], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][3], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][3], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][3], 0);

        MobileOUT[playerid][4] = CreatePlayerTextDraw(playerid, 560.373718, 195.925903, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][4], -14.000000, 17.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][4], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][4], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][4], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][4], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][4], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][4], 0);

        MobileOUT[playerid][5] = CreatePlayerTextDraw(playerid, 558.750122, 210.836898, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][5], 2.429999, 168.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][5], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][5], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][5], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][5], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][5], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][5], 0);

        MobileOUT[playerid][6] = CreatePlayerTextDraw(playerid, 467.117034, 210.836914, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][6], 2.419998, 168.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][6], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][6], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][6], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][6], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][6], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][6], 0);

        MobileOUT[playerid][7] = CreatePlayerTextDraw(playerid, 466.864654, 397.870727, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][7], 16.000000, -19.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][7], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][7], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][7], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][7], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][7], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][7], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][7], 0);

        MobileOUT[playerid][8] = CreatePlayerTextDraw(playerid, 467.664703, 396.770660, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][8], 16.000000, -19.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][8], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][8], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][8], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][8], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][8], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][8], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][8], 0);

        MobileOUT[playerid][9] = CreatePlayerTextDraw(playerid, 481.333435, 394.552124, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][9], 67.000000, 3.169997);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][9], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][9], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][9], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][9], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][9], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][9], 0);

        MobileOUT[playerid][10] = CreatePlayerTextDraw(playerid, 561.490173, 397.870758, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][10], -15.000000, -19.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][10], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][10], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][10], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][10], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][10], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][10], 0);

        MobileOUT[playerid][11] = CreatePlayerTextDraw(playerid, 560.265930, 396.489166, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][11], -13.000000, -19.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][11], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][11], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][11], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][11], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][11], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][11], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][11], 0);

        MobileOUT[playerid][12] = CreatePlayerTextDraw(playerid, 502.266784, 192.851730, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][12], -9.000000, 20.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][12], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][12], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][12], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][12], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][12], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][12], 19682);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][12], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][12], 90.000000, 0.000000, 0.000000, 1.000000);

        MobileOUT[playerid][13] = CreatePlayerTextDraw(playerid, 494.750030, 195.926040, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][13], 38.000000, 4.550012);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][13], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][13], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][13], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][13], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][13], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][13], 0);

        MobileOUT[playerid][14] = CreatePlayerTextDraw(playerid, 533.116699, 192.351699, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][14], -9.000000, 20.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][14], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][14], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][14], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][14], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][14], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][14], 19682);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][14], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][14], -90.000000, 0.000000, 180.000000, 1.000000);

        MobileOUT[playerid][15] = CreatePlayerTextDraw(playerid, 499.000091, 200.592727, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][15], 28.000000, 6.100001);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][15], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][15], 255);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][15], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][15], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][15], 4);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][15], 0);

        MobileOUT[playerid][16] = CreatePlayerTextDraw(playerid, 499.499969, 196.900054, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][16], -10.000000, 8.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][16], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][16], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][16], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][16], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][16], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][16], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][16], 0);

        MobileOUT[playerid][17] = CreatePlayerTextDraw(playerid, 527.918212, 196.140914, "hud:radardisc");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][17], 12.000000, 10.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][17], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][17], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][17], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][17], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][17], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][17], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][17], 0);

        MobileOUT[playerid][18] = CreatePlayerTextDraw(playerid, 507.966369, 183.466400, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][18], 19.000000, 26.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][18], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][18], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][18], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][18], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][18], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][18], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][18], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][18], 0.000000, -90.000000, 180.000000, 1.500000);

        MobileOUT[playerid][19] = CreatePlayerTextDraw(playerid, 503.166076, 183.466400, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][19], 19.000000, 26.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][19], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][19], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][19], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][19], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][19], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][19], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][19], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][19], 0.000000, -90.000000, 90.000000, 1.500000);

        MobileOUT[playerid][20] = CreatePlayerTextDraw(playerid, 494.865570, 183.466400, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][20], 19.000000, 26.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][20], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][20], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][20], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][20], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][20], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][20], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][20], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][20], 0.000000, -90.000000, 90.000000, 1.500000);

        MobileOUT[playerid][21] = CreatePlayerTextDraw(playerid, 468.182220, 172.185028, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][21], -2.000000, 94.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][21], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][21], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][21], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][21], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][21], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][21], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][21], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][21], 0.000000, -90.000000, 90.000000, 1.500000);

        MobileOUT[playerid][22] = CreatePlayerTextDraw(playerid, 468.348968, 209.894088, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][22], -2.000000, 68.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][22], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][22], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][22], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][22], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][22], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][22], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][22], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][22], 0.000000, -90.000000, 90.000000, 1.500000);

        MobileOUT[playerid][23] = CreatePlayerTextDraw(playerid, 468.348968, 225.995071, "");
        PlayerTextDrawTextSize(playerid, MobileOUT[playerid][23], -2.000000, 68.000000);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][23], 1);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][23], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][23], 0);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][23], 5);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][23], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileOUT[playerid][23], 2229);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][23], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileOUT[playerid][23], 0.000000, -90.000000, 90.000000, 1.500000);

        MobileOUT[playerid][24] = CreatePlayerTextDraw(playerid, 484.700042, 200.000000, "00:00");
        PlayerTextDrawLetterSize(playerid, MobileOUT[playerid][24], 0.089583, 0.500740);
        PlayerTextDrawAlignment(playerid, MobileOUT[playerid][24], 2);
        PlayerTextDrawColor(playerid, MobileOUT[playerid][24], -1);
        PlayerTextDrawSetShadow(playerid, MobileOUT[playerid][24], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileOUT[playerid][24], 255);
        PlayerTextDrawFont(playerid, MobileOUT[playerid][24], 2);
        PlayerTextDrawSetProportional(playerid, MobileOUT[playerid][24], 1);

        MobileShowedOUT{playerid} = true;

        for(new i = 0; i < MOBILEOUT_SIZE; i++)
            PlayerTextDrawShow(playerid, MobileOUT[playerid][i]);
    }
    else
    {
        MobileShowedOUT{playerid} = false;

        for(new i = 0; i < MOBILEOUT_SIZE; i++)
        {
            PlayerTextDrawHide(playerid, MobileOUT[playerid][i]);
            PlayerTextDrawDestroy(playerid, MobileOUT[playerid][i]);
            MobileOUT[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

MobileButtons(playerid, bool:buttonsshow)
{
    if(buttonsshow)
    {
        MobileBUT[playerid][0] = CreatePlayerTextDraw(playerid, 475.883270, 270.814544, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][0], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][0], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][0], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][0], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][0], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][0], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][0], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][0], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][1] = CreatePlayerTextDraw(playerid, 498.367218, 270.833038, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][1], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][1], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][1], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][1], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][1], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][1], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][1], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][1], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][2] = CreatePlayerTextDraw(playerid, 520.965881, 270.833038, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][2], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][2], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][2], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][2], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][2], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][2], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][2], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][3] = CreatePlayerTextDraw(playerid, 475.883270, 297.716186, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][3], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][3], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][3], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][3], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][3], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][3], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][3], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][3], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][3], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][4] = CreatePlayerTextDraw(playerid, 498.367218, 297.734680, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][4], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][4], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][4], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][4], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][4], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][4], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][4], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][4], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][5] = CreatePlayerTextDraw(playerid, 520.965881, 297.734680, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][5], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][5], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][5], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][5], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][5], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][5], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][5], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][5], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][5], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][6] = CreatePlayerTextDraw(playerid, 475.883270, 325.217864, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][6], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][6], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][6], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][6], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][6], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][6], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][6], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][6], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][6], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][7] = CreatePlayerTextDraw(playerid, 498.367218, 325.236358, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][7], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][7], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][7], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][7], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][7], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][7], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][7], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][7], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][7], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][8] = CreatePlayerTextDraw(playerid, 520.965881, 325.236358, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][8], 31.000000, 36.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][8], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][8], 153);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][8], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][8], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][8], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][8], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][8], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][8], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][9] = CreatePlayerTextDraw(playerid, 469.999023, 201.828948, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][9], 95.000000, 84.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][9], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][9], 68);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][9], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][9], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][9], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][9], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][9], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][9], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][10] = CreatePlayerTextDraw(playerid, 483.566680, 222.925888, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][10], 0.879999, 40.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][10], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][10], -103);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][10], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][10], 4);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][10], 0);

        MobileBUT[playerid][11] = CreatePlayerTextDraw(playerid, 495.133178, 363.062957, "LD_SPAC:white");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][11], 37.000000, 1.289999);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][11], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][11], -103);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][11], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][11], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][11], 4);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][11], 0);

        // oglasi
        MobileBUT[playerid][12] = CreatePlayerTextDraw(playerid, 495.933135, 229.488967, AdInfo);
        PlayerTextDrawLetterSize(playerid, MobileBUT[playerid][12], 0.078332, 0.521480);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][12], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][12], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][12], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][12], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][12], 2);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][12], 1);

        MobileBUT[playerid][13] = CreatePlayerTextDraw(playerid, 537.500610, 247.045516, AdFrom);
        PlayerTextDrawLetterSize(playerid, MobileBUT[playerid][13], 0.097499, 0.625185);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][13], 3);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][13], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][13], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][13], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][13], 2);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][13], 1);

        MobileBUT[playerid][14] = CreatePlayerTextDraw(playerid, 499.449768, 253.000045, "ld_chat:badchat");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][14], 7.000000, 8.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][14], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][14], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][14], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][14], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][14], 4);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][14], 0);
        PlayerTextDrawSetSelectable(playerid, MobileBUT[playerid][14], true);

        MobileBUT[playerid][15] = CreatePlayerTextDraw(playerid, 485.200164, 390.844329, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][15], 13.000000, -11.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][15], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][15], 85);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][15], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][15], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][15], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][15], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][15], 0);

        MobileBUT[playerid][16] = CreatePlayerTextDraw(playerid, 478.515747, 357.158538, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][16], 26.000000, 40.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][16], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][16], 119);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][16], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][16], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][16], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][16], 19807);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][16], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][16], 0.000000, 0.000000, 90.000000, 1.000000);

        // call
        MobileBUT[playerid][17] = CreatePlayerTextDraw(playerid, 479.615814, 358.658630, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][17], 24.000000, 37.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][17], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][17], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][17], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][17], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][17], 0);
        PlayerTextDrawSetSelectable(playerid, MobileBUT[playerid][17], true);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][17], 19807);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][17], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][17], 0.000000, 0.000000, 90.000000, 1.000000);

        MobileBUT[playerid][18] = CreatePlayerTextDraw(playerid, 507.701538, 390.844329, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][18], 13.000000, -11.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][18], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][18], 85);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][18], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][18], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][18], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][18], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][18], 0);

        MobileBUT[playerid][19] = CreatePlayerTextDraw(playerid, 497.798950, 369.802978, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][19], 32.000000, 18.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][19], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][19], 119);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][19], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][19], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][19], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][19], 2684);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][19], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][19], 0.000000, 0.000000, 0.000000, 1.000000);

        // message
        MobileBUT[playerid][20] = CreatePlayerTextDraw(playerid, 498.882385, 370.803039, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][20], 30.000000, 16.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][20], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][20], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][20], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][20], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][20], 0);
        PlayerTextDrawSetSelectable(playerid, MobileBUT[playerid][20], true);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][20], 2684);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][20], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][20], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileBUT[playerid][21] = CreatePlayerTextDraw(playerid, 530.597229, 390.844329, "particle:lamp_shad_64");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][21], 13.000000, -11.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][21], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][21], 85);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][21], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][21], 255);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][21], 4);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][21], 0x00000000);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][21], 0);

        MobileBUT[playerid][22] = CreatePlayerTextDraw(playerid, 519.081481, 368.002868, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][22], 33.850025, 27.409986);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][22], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][22], 119);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][22], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][22], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][22], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][22], 1216);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][22], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][22], -68.000000, 0.000000, 180.000000, 1.000000);

        // smsad
        MobileBUT[playerid][23] = CreatePlayerTextDraw(playerid, 520.081237, 368.902923, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][23], 32.000000, 25.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][23], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][23], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][23], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][23], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][23], 0);
        PlayerTextDrawSetSelectable(playerid, MobileBUT[playerid][23], true);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][23], 1216);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][23], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][23], -68.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][24] = CreatePlayerTextDraw(playerid, 478.614715, 276.288177, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][24], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][24], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][24], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][24], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][24], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][24], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][24], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][24], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][24], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][25] = CreatePlayerTextDraw(playerid, 501.264984, 276.806701, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][25], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][25], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][25], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][25], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][25], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][25], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][25], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][25], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][25], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][26] = CreatePlayerTextDraw(playerid, 524.181701, 276.806732, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][26], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][26], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][26], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][26], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][26], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][26], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][26], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][26], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][26], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][27] = CreatePlayerTextDraw(playerid, 478.764984, 303.651153, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][27], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][27], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][27], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][27], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][27], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][27], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][27], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][27], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][27], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][28] = CreatePlayerTextDraw(playerid, 501.181671, 303.651153, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][28], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][28], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][28], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][28], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][28], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][28], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][28], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][28], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][28], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][29] = CreatePlayerTextDraw(playerid, 524.231384, 303.651153, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][29], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][29], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][29], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][29], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][29], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][29], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][29], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][29], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][29], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][30] = CreatePlayerTextDraw(playerid, 478.814636, 331.232635, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][30], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][30], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][30], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][30], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][30], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][30], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][30], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][30], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][30], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileBUT[playerid][31] = CreatePlayerTextDraw(playerid, 501.331237, 331.232635, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][31], 25.000000, 23.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][31], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][31], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][31], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][31], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][31], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][31], 19804);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][31], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][31], 0.000000, 0.000000, 180.000000, 1.000000);

        // radio
        MobileBUT[playerid][32] = CreatePlayerTextDraw(playerid, 525.911682, 332.214202, "");
        PlayerTextDrawTextSize(playerid, MobileBUT[playerid][32], 21.000000, 22.000000);
        PlayerTextDrawAlignment(playerid, MobileBUT[playerid][32], 1);
        PlayerTextDrawColor(playerid, MobileBUT[playerid][32], -1);
        PlayerTextDrawSetShadow(playerid, MobileBUT[playerid][32], 0);
        PlayerTextDrawFont(playerid, MobileBUT[playerid][32], 5);
        PlayerTextDrawSetProportional(playerid, MobileBUT[playerid][32], 0);
        PlayerTextDrawSetSelectable(playerid, MobileBUT[playerid][32], true);
        PlayerTextDrawSetPreviewModel(playerid, MobileBUT[playerid][32], 19617);
        PlayerTextDrawBackgroundColor(playerid, MobileBUT[playerid][32], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileBUT[playerid][32], 0.000000, 0.000000, 180.000000, 1.000000);

        MobileShowedBUT{playerid} = true;

        for(new i = 0; i < MOBILEBUT_SIZE; i++)
            PlayerTextDrawShow(playerid, MobileBUT[playerid][i]);

        if(AdNotif{playerid})
        {
            PlayerTextDrawSetString(playerid, MobileBUT[playerid][14], "ld_chat:thumbup");
            PlayerTextDrawShow(playerid, MobileBUT[playerid][14]);
        }
    }
    else
    {
        MobileShowedBUT{playerid} = false;

        for(new i = 0; i < MOBILEBUT_SIZE; i++)
        {
            PlayerTextDrawHide(playerid, MobileBUT[playerid][i]);
            PlayerTextDrawDestroy(playerid, MobileBUT[playerid][i]);
            MobileBUT[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

MobileMessage(playerid, bool:messageshow)
{
    if(messageshow)
    {
        MobileMSG[playerid][0] = CreatePlayerTextDraw(playerid, 451.000000, 206.099517, "");
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][0], 126.000000, 58.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][0], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][0], 119);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][0], 0);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][0], 5);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][0], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileMSG[playerid][0], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][0], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileMSG[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileMSG[playerid][1] = CreatePlayerTextDraw(playerid, 451.000000, 248.814773, "");
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][1], 126.000000, 58.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][1], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][1], 119);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][1], 0);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][1], 5);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][1], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileMSG[playerid][1], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][1], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileMSG[playerid][1], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileMSG[playerid][2] = CreatePlayerTextDraw(playerid, 451.000061, 292.218200, "");
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][2], 126.000000, 58.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][2], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][2], 119);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][2], 0);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][2], 5);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][2], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileMSG[playerid][2], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][2], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileMSG[playerid][2], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileMSG[playerid][3] = CreatePlayerTextDraw(playerid, 451.000061, 335.036804, "");
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][3], 126.000000, 58.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][3], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][3], 119);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][3], 0);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][3], 5);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][3], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobileMSG[playerid][3], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][3], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobileMSG[playerid][3], 0.000000, 0.000000, 0.000000, 1.000000);

        MobileMSG[playerid][4] = CreatePlayerTextDraw(playerid, 484.166656, 226.377853, PlayerMessage[playerid][0]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][4], 0.089166, 0.557776);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][4], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][4], -1);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][4], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][4], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][4], 1);

        MobileMSG[playerid][5] = CreatePlayerTextDraw(playerid, 538.749816, 240.577880, PlayerMessageNumber[playerid][0]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][5], 0.109165, 0.614813);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][5], 3);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][5], -1378294017);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][5], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][5], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][5], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][5], 1);

        MobileMSG[playerid][6] = CreatePlayerTextDraw(playerid, 484.166656, 268.280395, PlayerMessage[playerid][1]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][6], 0.089166, 0.557776);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][6], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][6], -1);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][6], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][6], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][6], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][6], 1);

        MobileMSG[playerid][7] = CreatePlayerTextDraw(playerid, 538.749816, 282.480438, PlayerMessageNumber[playerid][1]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][7], 0.109165, 0.614813);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][7], 3);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][7], -1378294017);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][7], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][7], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][7], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][7], 1);

        MobileMSG[playerid][8] = CreatePlayerTextDraw(playerid, 484.166656, 311.383026, PlayerMessage[playerid][2]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][8], 0.089166, 0.557776);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][8], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][8], -1);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][8], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][8], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][8], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][8], 1);

        MobileMSG[playerid][9] = CreatePlayerTextDraw(playerid, 538.749816, 325.583068, PlayerMessageNumber[playerid][2]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][9], 0.109165, 0.614813);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][9], 3);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][9], -1378294017);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][9], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][9], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][9], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][9], 1);

        MobileMSG[playerid][10] = CreatePlayerTextDraw(playerid, 484.166656, 353.285583, PlayerMessage[playerid][3]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][10], 0.089166, 0.557776);
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][10], -157.000000, 0.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][10], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][10], -1);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][10], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][10], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][10], 1);

        MobileMSG[playerid][11] = CreatePlayerTextDraw(playerid, 538.749816, 367.485626, PlayerMessageNumber[playerid][3]);
        PlayerTextDrawLetterSize(playerid, MobileMSG[playerid][11], 0.109165, 0.614813);
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][11], -157.000000, 0.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][11], 3);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][11], -1378294017);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][11], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][11], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][11], 2);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][11], 1);

        MobileMSG[playerid][12] = CreatePlayerTextDraw(playerid, 546.250000, 216.703781, "ld_chat:badchat");
        PlayerTextDrawTextSize(playerid, MobileMSG[playerid][12], 6.000000, 7.000000);
        PlayerTextDrawAlignment(playerid, MobileMSG[playerid][12], 1);
        PlayerTextDrawColor(playerid, MobileMSG[playerid][12], -1);
        PlayerTextDrawSetShadow(playerid, MobileMSG[playerid][12], 0);
        PlayerTextDrawBackgroundColor(playerid, MobileMSG[playerid][12], 255);
        PlayerTextDrawFont(playerid, MobileMSG[playerid][12], 4);
        PlayerTextDrawSetProportional(playerid, MobileMSG[playerid][12], 0);

        MobileShowedMSG{playerid} = true;

        for(new i = 0; i < MOBILEMSG_SIZE-1; i++)
            PlayerTextDrawShow(playerid, MobileMSG[playerid][i]);
    }
    else
    {
        MobileShowedMSG{playerid} = false;

        for(new i = 0; i < MOBILEMSG_SIZE; i++)
        {
            PlayerTextDrawHide(playerid, MobileMSG[playerid][i]);
            PlayerTextDrawDestroy(playerid, MobileMSG[playerid][i]);
            MobileMSG[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

MobileCall(playerid, bool:callshow)
{
    if(callshow)
    {
        MobilePHO[playerid][0] = CreatePlayerTextDraw(playerid, 450.599975, 214.000000, "");
        PlayerTextDrawTextSize(playerid, MobilePHO[playerid][0], 127.000000, 165.000000);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][0], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][0], 119);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][0], 0);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][0], 5);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][0], 0);
        PlayerTextDrawSetPreviewModel(playerid, MobilePHO[playerid][0], 2730);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][0], 0x00000000);
        PlayerTextDrawSetPreviewRot(playerid, MobilePHO[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

        MobilePHO[playerid][1] = CreatePlayerTextDraw(playerid, 509.200256, 270.000000, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobilePHO[playerid][1], 10.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][1], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][1], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][1], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][1], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][1], 4);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][1], 0);

        MobilePHO[playerid][2] = CreatePlayerTextDraw(playerid, 507.200256, 257.000000, "(");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][2], 0.572915, 2.299999);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][2], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][2], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][2], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][2], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][2], 1);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][2], 1);

        MobilePHO[playerid][3] = CreatePlayerTextDraw(playerid, 507.200256, 257.000000, "(");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][3], 0.572915, 2.299999);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][3], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][3], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][3], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][3], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][3], 1);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][3], 1);

        MobilePHO[playerid][4] = CreatePlayerTextDraw(playerid, 507.200256, 257.000000, "(");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][4], 0.572915, 2.299999);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][4], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][4], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][4], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][4], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][4], 1);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][4], 1);

        MobilePHO[playerid][5] = CreatePlayerTextDraw(playerid, 509.200256, 258.599304, "ld_beat:chit");
        PlayerTextDrawTextSize(playerid, MobilePHO[playerid][5], 10.000000, 11.000000);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][5], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][5], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][5], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][5], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][5], 4);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][5], 0);

        MobilePHO[playerid][6] = CreatePlayerTextDraw(playerid, 509.500152, 263.399963, "(");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][6], 0.294999, 1.097036);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][6], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][6], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][6], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][6], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][6], 1);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][6], 1);

        MobilePHO[playerid][7] = CreatePlayerTextDraw(playerid, 509.500152, 263.399963, "(");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][7], 0.294999, 1.097036);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][7], 1);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][7], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][7], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][7], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][7], 1);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][7], 1);

        MobilePHO[playerid][8] = CreatePlayerTextDraw(playerid, 514.200195, 287.200012, "060-333-561");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][8], 0.097499, 0.687407);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][8], 2);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][8], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][8], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][8], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][8], 2);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][8], 1);

        MobilePHO[playerid][9] = CreatePlayerTextDraw(playerid, 514.200195, 305.601135, "Da_se_javis_pritisni_'Y'~n~Da_odbijes_pritisni_'N'");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][9], 0.086249, 0.619998);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][9], 2);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][9], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][9], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][9], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][9], 2);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][9], 1);

        MobilePHO[playerid][10] = CreatePlayerTextDraw(playerid, 514.200195, 324.202270, "...");
        PlayerTextDrawLetterSize(playerid, MobilePHO[playerid][10], 0.164582, 0.811851);
        PlayerTextDrawAlignment(playerid, MobilePHO[playerid][10], 2);
        PlayerTextDrawColor(playerid, MobilePHO[playerid][10], -1);
        PlayerTextDrawSetShadow(playerid, MobilePHO[playerid][10], 0);
        PlayerTextDrawBackgroundColor(playerid, MobilePHO[playerid][10], 255);
        PlayerTextDrawFont(playerid, MobilePHO[playerid][10], 2);
        PlayerTextDrawSetProportional(playerid, MobilePHO[playerid][10], 1);

        MobileShowedPHO{playerid} = true;

        for(new i = 0; i < MOBILEPHO_SIZE; i++)
            PlayerTextDrawShow(playerid, MobilePHO[playerid][i]);
    }
    else
    {
        MobileShowedPHO{playerid} = false;

        for(new i = 0; i < MOBILEPHO_SIZE; i++)
        {
            PlayerTextDrawHide(playerid, MobilePHO[playerid][i]);
            PlayerTextDrawDestroy(playerid, MobilePHO[playerid][i]);
            MobilePHO[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
        }
    }
    return 1;
}

/*forward mysql_mobile(playerid);
public mysql_mobile(playerid)
{
    cache_get_row_count(rows);
	
	if(rows != 1) return Kick_Timer(playerid);

    cache_get_value_name_int(0, "sim_broj",                 PlayerNumber[playerid]);
    cache_get_value_name_int(0, "sim_kredit",               PlayerCredit[playerid]);
    cache_get_value_name(0, "mobilni",                      PlayerPhone[playerid], 13);
    cache_get_value_name(0, "sim",                          PlayerOperator[playerid], 11);
    return 1;
}*/

SetMobileVar(playerid, var[])
{
    if(!strcmp(var, "N/A", true))
        format(PlayerPhone[playerid], 13, "");
    else
        format(PlayerPhone[playerid], 13, "%s", var);
}

SetSimVar(playerid, var[])
{
    format(PlayerOperator[playerid], 11, "%s", var);
}

SetSimNumber(playerid, var)
{
    PlayerNumber[playerid] = var;
}

SetSimCredit(playerid, var)
{
    PlayerCredit[playerid] = var;
}

hook OnGameModeInit()
{
    AdCooldown = false;
    format(AdInfo, 51, "Trenutno nema oglasa~n~za prikazati!");
    format(AdFrom, 13, "-");

    //CreateDynamic3DTextLabel("/kupisim\n{FFFFFF}($250)", ZLATNA, 1726.7946, -1135.0697, 24.1268, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
    //CreateDynamic3DTextLabel("/kupimobilni\n{FFFFFF}($2000)", ZLATNA, 1724.2920, -1135.1124, 24.1268, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerConnect(playerid)
{
    BeingCalled[playerid] =
    Dialing[playerid] =
    TalkingWith[playerid] =
    ResetPlayerCall[playerid] = -1;

    PlayerCredit[playerid] =
    PlayerMessageLast[playerid] =
    PlayerNumber[playerid] = 0;

    format(PlayerOperator[playerid], 11, "");
    format(PlayerPhone[playerid], 13, "");

    Talking{playerid} =
    InMobile{playerid} =
    AdNotif{playerid} =
    MobileShowedBG{playerid} =
    MobileShowedOUT{playerid} =
    MobileShowedBUT{playerid} =
    MobileShowedMSG{playerid} =
    MobileShowedPHO{playerid} = false;

    for(new i = 0; i < 4; i++)
    {
        format(PlayerMessageNumber[playerid][i], 51, "-");
        format(PlayerMessage[playerid][i], 51, "-");
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason)
{
    if(TalkingWith[playerid] != -1)
    {
        new
            callerid = TalkingWith[playerid]
        ;
        Dialing[playerid] = BeingCalled[playerid] = -1;
        phone_call_msg(callerid, "Veza se prekinula, mobilni telefon sugovornika je prestao reagovati na konekciju.");

        // Sakrij mobitel pretplatniku
        MobileBackground(playerid, false);
        MobileOutline(playerid, false);
        MobileCall(playerid, false);

        // Sakrij mobitel pozivaocu
        MobileBackground(callerid, false);
        MobileOutline(callerid, false);
        MobileCall(callerid, false);

        Talking{playerid} = Talking{callerid} = false;
        TalkingWith[playerid] = TalkingWith[callerid] = -1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid)
{
    if(playertextid == MobileBUT[playerid][14])
    {
        if(!AdNotif{playerid})
        {
            AdNotif{playerid} = true;
            InfoMsg(playerid, "Ukljucili ste obavijesti za nove oglase.");
            PlayerTextDrawSetString(playerid, MobileBUT[playerid][14], "ld_chat:thumbup");
            PlayerTextDrawShow(playerid, MobileBUT[playerid][14]);
            return 1;
        }
        else
        {
            AdNotif{playerid} = false;
            InfoMsg(playerid, "Iskljucili ste obavijesti za nove oglase.");
            PlayerTextDrawSetString(playerid, MobileBUT[playerid][14], "ld_chat:badchat");
            PlayerTextDrawShow(playerid, MobileBUT[playerid][14]);
            return 1;
        }
    }
    else if(playertextid == MobileBUT[playerid][17]) // call
    {
        if (PI[playerid][p_utisan] > 0)
            return ErrorMsg(playerid, "Vasa SIM kartica je trenutno onemogucena, koristite /podrska da provjerite stanje.");
        
        SPD(playerid, "CallPlayer", DIALOG_STYLE_INPUT, "Biranje broja...", "Unesite broj kojeg zelite pozvati.\nBroj mora biti u sljedecem formatu: 060000000\nNaprimjer 061152541", "Pozovi", "Odustani");
    }
    else if(playertextid == MobileBUT[playerid][20]) // message
    {
        if (PI[playerid][p_utisan] > 0)
            return ErrorMsg(playerid, "Vasa SIM kartica je trenutno onemogucena, koristite /podrska da provjerite stanje.");
        
        SPD(playerid, "MessageOptions", DIALOG_STYLE_TABLIST_HEADERS, "Poruke...", "Opcija\tDodatno\nPosalji poruku\tPosalji poruku na validan broj / Kredit $3\nListaj poruke\tPrikazi cetiri zadnje poruke", "Odaberi", "Otkazi");
    }
    else if(playertextid == MobileBUT[playerid][23]) // ad(vertise)
    {
        if (PI[playerid][p_utisan] > 0)
            return ErrorMsg(playerid, "Vasa SIM kartica je trenutno onemogucena, koristite /podrska da provjerite stanje.");
        
        if (AdCooldown)
            return ErrorMsg(playerid, "Mora proci najmanje jedna minuta prije nego postavite novi oglas.");

        SPD(playerid, "PostAd", DIALOG_STYLE_INPUT, "Postavljanje oglasa...", "Unesite tekst oglasa kojeg zelite postaviti.\nOglas ne smije sadrzati nikakav uvrjedljiv ili NonRP sadrzaj!\nMaksimalno karaktera 60", "Posalji", "Otkazi");
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

GetPlayerCredit(playerid)
{
    return PlayerCredit[playerid];
}

AddPlayerCredit(playerid, cash)
{
    PlayerCredit[playerid] += cash;

    new query[57];
    format(query, sizeof query, "UPDATE igraci SET sim_kredit = %i WHERE id = %i", PlayerCredit[playerid], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
}

forward phone_animation(playerid, bool:status);
public phone_animation(playerid, bool:status) 
{
	if(status == false) 
    { //sakrij
 		if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);
     	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
	else if(status == true) 
    { //prikazi
 		if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_PHONE)) RemovePlayerAttachedObject(playerid, SLOT_PHONE);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
	    SetPlayerAttachedObject(playerid, SLOT_PHONE, 330, 6); // SLOT_PHONE = attachment slot, 330 = cellphone model, 6 = right hand
	}
	
	return 1;
}

forward phone_call_msg(playerid, const string[]);
public phone_call_msg(playerid, const string[]) 
{
	SendClientMessageF(playerid, ZUTA, "(poziv) {F1A3A4}%s", string);
	return 1;
}

PhoneCallActive(playerid)
{
    return Talking{playerid};
}

forward format_phone(playerid, string[]);
public format_phone(playerid, string[])
{
    new
        pozivni[4]
    ;
    if(isnull(PlayerPhone[playerid]) && isnull(PlayerOperator[playerid]))
        format(string, 8, "No");
    
    else
    {
        if(!strcmp(PlayerOperator[playerid], "BH Telecom"))
            format(pozivni, sizeof pozivni, "061");

        else if(!strcmp(PlayerOperator[playerid], "Telenor"))
            format(pozivni, sizeof pozivni, "069");

        else if(!strcmp(PlayerOperator[playerid], "m:tel"))
            format(pozivni, sizeof pozivni, "067");

        format(string, 13, "(%s) %i", pozivni, PlayerNumber[playerid]);
    }
    return 1;
}

stock PlayerHasPhone(playerid)
{
	if(isnull(PlayerPhone[playerid])) return 0;
	
	return 1;
}

stock PlayerHasSim(playerid) 
{
	if(isnull(PlayerOperator[playerid])) return 0;
	
	return 1;
}

Dialog:PostAd(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;

    if(isnull(inputtext) || strlen(inputtext) > 50)
        return ErrorMsg(playerid, "Nevazeci unos!");

    if (strfind(inputtext, "~", true) != -1) 
        return ErrorMsg(playerid, "Ne mozete koristiti znak \"~\" u oglasu!");
    
    new
        substring[2][25],
        FromNumb[13]
    ;

    AdminMsg(ZLATNA, "OGLAS | Igrac: %s (%i) / ,,%s''", ime_rp[playerid], playerid, inputtext);
    AdminMsg(ZLATNA, "Ukoliko oglas nije prikladan (vrijedjanje po bilo kojoj osnovi / NonRP) - /punishad (Ime_Prezime)");
    
    strmid(substring[0], inputtext, 0, 25, 25+1);
    strmid(substring[1], inputtext, 25, 50, 25+1);

    format(AdInfo, 25, "%s", substring[0]);

    if(!isnull(substring[1]))
        format(AdInfo, 64, "%s-~n~%s", AdInfo, substring[1]);
    
    format_phone(playerid, FromNumb);
    format(AdFrom, sizeof AdFrom, "%s", FromNumb);

    foreach(new i : Player)
    {
        if(MobileShowedBUT{i})
        {
            MobileButtons(playerid, false);
            MobileButtons(playerid, true);
        }
        if(AdNotif{i})
        {
            PlayerPlaySound(playerid, 6401 , 0.0, 0.0, 0.0);
        }
    }
    AdCooldown = true;
    SetTimer("ResetAdvertise", 60 * 1000, false);
    InfoMsg(playerid, "Uspjesno ste postavili oglas.");
    return 1;
}

Dialog:CallPlayer(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;
    
    new
        str[11]
    ;

    strmid(str, inputtext, 0, 11);
    callcmd::callplayer(playerid, str);
    return 1;
}

Dialog:MessageOptions(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;

    if(listitem == 0)
        SPD(playerid, "MessagePlayer", DIALOG_STYLE_INPUT, "Slanje poruke...", "Unesite broj i zeljenu poruku koju zelite poslati.\nPrimjer: 067215167 Koliko bi kostao taj Golf 2 kojeg vozite?\nPoruka ne smije sadrzati vise od 80 karaktera!", "Posalji", "Odustani");

    else
    {
        //CancelSelectTextDraw(playerid);
        MobileButtons(playerid, false);
        MobileMessage(playerid, true);
    }

    return 1;
}

Dialog:MessagePlayer(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;
    
    new
        str[101]
    ;

    strmid(str, inputtext, 0, 101);

    if(strlen(str) > 80)
        return ErrorMsg(playerid, "Poruka ne smije sadzati vise od 80 karaktera!");

    callcmd::sendmessage(playerid, str);
    return 1;
}

Dialog:SelectOperator(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;

    switch(listitem)
    {
        case 0: // BH Telecom
            format(PlayerOperator[playerid], 11, "BH Telecom");
        
        case 1: // Telenor
            format(PlayerOperator[playerid], 11, "Telenor");

        case 2: // m:tel
            format(PlayerOperator[playerid], 11, "m:tel");

        default: return ErrorMsg(playerid, "[mobitel.pwn] Pojavila se greska, prijavi skripteru!");
    }
    
    new
        pnumb = randomEx(100000, 999999),
        pozivni[4]
    ;

    PlayerNumber[playerid] = pnumb;

    if(!strcmp(PlayerOperator[playerid], "BH Telecom"))
        format(pozivni, sizeof pozivni, "061");
    
    else if(!strcmp(PlayerOperator[playerid], "Telenor"))
        format(pozivni, sizeof pozivni, "069");

    else if(!strcmp(PlayerOperator[playerid], "m:tel"))
        format(pozivni, sizeof pozivni, "067");
    
    PlayerMoneySub(playerid, 250);
    InfoMsg(playerid, "Uspjesno ste odabrali operatera i dobili SIM karticu: (%s) %i", pozivni, PlayerNumber[playerid]);

    new query[112];
    format(query, sizeof query, "UPDATE igraci SET sim = '%s', sim_broj = %d, sim_kredit = %d WHERE id = %d", PlayerOperator[playerid], PlayerNumber[playerid], 20, PI[playerid][p_id]);
    mysql_tquery(SQL, query);

    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_YES)
    {
        if(BeingCalled[playerid] != -1)
        {
            new
                callerid = BeingCalled[playerid]
            ;
            PlayerTextDrawColor(playerid, MobilePHO[playerid][8], 0x20e655FF);
            PlayerTextDrawColor(callerid, MobilePHO[playerid][8], 0x20e655FF);
            PlayerTextDrawShow(playerid, MobilePHO[playerid][8]);
            PlayerTextDrawShow(callerid, MobilePHO[playerid][8]);
            Talking{playerid} = Talking{callerid} = true;
            TalkingWith[playerid] = callerid;
            TalkingWith[callerid] = playerid;
            phone_call_msg(playerid, "Veza uspostavljena, koristite chat kako biste komunicirali.");
            phone_call_msg(callerid, "Veza uspostavljena, koristite chat kako biste komunicirali.");
            CancelSelectTextDraw(callerid);
            KillTimer(ResetPlayerCall[callerid]);
        }
        return 1;
    }
    else if(newkeys & KEY_NO)
    {
        if(BeingCalled[playerid] != -1)
        {
            new
                callerid = BeingCalled[playerid]
            ;
            Dialing[playerid] = BeingCalled[playerid] = BeingCalled[callerid] = -1;
            phone_call_msg(playerid, "Prekinuli ste poziv.");
            phone_call_msg(callerid, "Pretplatnik je prekinuo poziv.");

            // Sakrij mobitel pretplatniku
            MobileBackground(playerid, false);
            MobileOutline(playerid, false);
            MobileCall(playerid, false);

            // Sakrij mobitel pozivaocu
            MobileBackground(callerid, false);
            MobileOutline(callerid, false);
            MobileCall(callerid, false);

            InMobile{playerid} = InMobile{callerid} = false;

            Talking{playerid} = Talking{callerid} = false;
            TalkingWith[playerid] = TalkingWith[callerid] = -1;
            KillTimer(ResetPlayerCall[callerid]);
        }
        else if(Dialing[playerid] != -1)
        {
            new
                callerid = Dialing[playerid]
            ;
            Dialing[playerid] = BeingCalled[playerid] = BeingCalled[callerid] = -1;
            phone_call_msg(playerid, "Prekinuli ste poziv.");
            phone_call_msg(callerid, "Pozivaoc je prekinuo poziv.");

            // Sakrij mobitel pretplatniku
            MobileBackground(playerid, false);
            MobileOutline(playerid, false);
            MobileCall(playerid, false);

            // Sakrij mobitel pozivaocu
            MobileBackground(callerid, false);
            MobileOutline(callerid, false);
            MobileCall(callerid, false);

            Talking{playerid} = Talking{callerid} = false;
            TalkingWith[playerid] = TalkingWith[callerid] = -1;
            KillTimer(ResetPlayerCall[playerid]);
        }
        return 1;
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerText(playerid, text[])
{
    if(Talking{playerid} && TalkingWith[playerid] != -1)
    {
        format(string_128, sizeof string_128, "%s: {FFFFFF}%s", ime_rp[playerid], text);
		phone_call_msg(TalkingWith[playerid], string_128);
		
		format(string_128, sizeof string_128, "(mobilni) %s: %s", ime_rp[playerid], text);
		RangeMsg(playerid, string_128, BELA, 20.0);
        return 0;
    }
    return Y_HOOKS_CONTINUE_RETURN_0;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid)
{	
	if (clickedid == INVALID_TEXT_DRAW)
    {
		if (InMobile{playerid} && !Talking{playerid} && !MobileShowedMSG{playerid})
        {
            MobileBackground(playerid, false);
            MobileOutline(playerid, false);
            if(MobileShowedBUT{playerid})
                MobileButtons(playerid, false);
            if(MobileShowedPHO{playerid})
                MobileCall(playerid, false);
            CancelSelectTextDraw(playerid);
            InMobile{playerid} = false;
		}
        else if(!Talking{playerid} && MobileShowedMSG{playerid} && InMobile{playerid})
        {
            MobileMessage(playerid, false);
            MobileButtons(playerid, true);
            //SelectTextDraw(playerid, 0xFFFFFF99);
        }
	}
	return true;
}

forward ResetAdvertise();
public ResetAdvertise()
{
    AdCooldown = false;
    return 1;
}

forward ResetCall(playerid, callingid, pozivni[], callernumber);
public ResetCall(playerid, callingid, pozivni[], callernumber)
{
    BeingCalled[callingid] = Dialing[playerid] = -1;
    InMobile{playerid} = InMobile{callingid} = false;
    MobileBackground(playerid, false);
    MobileOutline(playerid, false);
    MobileCall(playerid, false);
    MobileBackground(callingid, false);
    MobileOutline(callingid, false);
    MobileCall(callingid, false);
    InfoMsg(playerid, "Niko se nije javio...");
    InfoMsg(callingid, "Propustili ste poziv od (%s) %i", pozivni, callernumber);
    return 1;
}

alias:mynumber("mojbroj", "broj")
CMD:mynumber(playerid, const params[])
{
    new
        checkid,
        pozivni[4]
    ;

    if(sscanf(params, "u", checkid))
    {
        if(PlayerNumber[playerid] < 100000)
            return ErrorMsg(playerid, "Nemate sim karticu.");

        if(!strcmp(PlayerOperator[playerid], "BH Telecom"))
            format(pozivni, sizeof pozivni, "061");

        else if(!strcmp(PlayerOperator[playerid], "Telenor"))
            format(pozivni, sizeof pozivni, "069");

        else if(!strcmp(PlayerOperator[playerid], "m:tel"))
            format(pozivni, sizeof pozivni, "067");

        SendClientMessageF(playerid, ZLATNA, "(operater) {FFFFFF}Broj Vase SIM kartice je: (%s) %i", pozivni, PlayerNumber[playerid]);
        SendClientMessageF(playerid, ZLATNA, "(operater) {FFFFFF}Da provjerite broj nekog drugog korisnika koristite /broj [Ime_Prezime]");
    }
    else
    {
        if(!IsPlayerConnected(checkid))
            return SendClientMessageF(playerid, ZLATNA, "(operater) {FFFFFF}Desial se greska u sistemu, provjerite unos!");
        
        if(PlayerNumber[checkid] < 100000)
            return ErrorMsg(playerid, "Taj korisnik nema sim karticu.");

        if(!strcmp(PlayerOperator[checkid], "BH Telecom"))
            format(pozivni, sizeof pozivni, "061");

        else if(!strcmp(PlayerOperator[checkid], "Telenor"))
            format(pozivni, sizeof pozivni, "069");

        else if(!strcmp(PlayerOperator[checkid], "m:tel"))
            format(pozivni, sizeof pozivni, "067");

        SendClientMessageF(playerid, ZLATNA, "(operater) {FFFFFF}Broj SIM kartice korisnika '%s' je: (%s) %i", ime_rp[checkid], pozivni, PlayerNumber[checkid]);
        SendClientMessageF(playerid, ZLATNA, "(operater) {FFFFFF}Da provjerite svoj broj koristite /mojbroj");
    }
    return 1;
}

CMD:teststring(playerid, params[])
{
    new
        str[60+1],
        strtest[60+1],
        strone[60+1],
        strtwo[60+1]
    ;

    sscanf(params, "s[60]", str);

    format(strtest, 60, "%s", str[25]);
    SendClientMessageF(playerid, -1, "strtest %s", strtest);
    strone[0] = EOS;
    for(new i = 0; i < strlen(str); i++)
    {
        if(strcmp(str[i], " ", true) && i >= 25)
            format(strone, sizeof strone, "%s%s", strone, str[i]);
        else
        {
            strmid(strtwo, str, i, strlen(str));
            format(strtwo, 61, "%s~n~%s", strone, strtwo);
            break;
        }
    }
    SendClientMessageF(playerid, -1, "strtwo | %s", strtwo);
    return 1;
}

CMD:punishad(playerid, params[])
{
    new
        punishedid,
        punishtype
    ;

    if(!sscanf(params, "ui", punishedid, punishtype))
    {
        if(punishtype == 1)
            PI[punishedid][p_utisan] += 60 * 60;
        else if(punishtype == 2)
            PI[punishedid][p_utisan] += 30 * 60;

        format(PI[punishedid][p_utisan_razlog], 32, "%s", "Los oglas");
        SetPlayerChatBubble(punishedid, "(( Ovaj igrac je UTISAN ))", 0xFF0000AA, 15.0, PI[punishedid][p_utisan]*1000);

        SendClientMessageF(punishedid, CRVENA, "MUTE | {FFFFFF}Kaznjeni ste od strane %s zbog loseg oglasa!", ime_rp[playerid]);
        SendClientMessageF(punishedid, CRVENA, "PODRSKA | {FFFFFF}Vasa SIM kartica je blokirana na narednih %imin zbog loseg oglasa!", konvertuj_vreme(PI[punishedid][p_utisan]));

        format(AdInfo, 51, "convicted");
        format(AdFrom, 13, "-");

        foreach(new i : Player)
        {
            if(MobileShowedBUT{i})
            {
                MobileButtons(i, false);
                MobileButtons(i, true);
            }
        }

        InfoMsg(playerid, "Uspjesno ste kaznili igraca %s zbog loseg oglasa.", ime_rp[punishedid]);
    }
    else
    {
        Koristite(playerid, "punishad (Ime_Prezime) (1 - uvrjedljiv sadrzaj / 2 - NonRP");
    }
    return 1;
}

CMD:podrska(playerid)
{
    new
        sMsg[50],
        pnumb[13]
    ;

    format_phone(playerid, pnumb);

    if (PI[playerid][p_utisan] > 0)
        format(sMsg, sizeof sMsg, "%s // Vasa SIM kartica je blokirana jos %s.", pnumb, konvertuj_vreme(PI[playerid][p_utisan], true));
    
    else
        format(sMsg, sizeof sMsg, "%s // Vasa SIM kartica je u funkcionalnom stanju.", pnumb);
    
    return 1;
}

alias:buymobilephone("kupimobitel", "buymobile", "kupimobilni")
CMD:buymobilephone(playerid)
{
    if(!isnull(PlayerPhone[playerid]))
        return ErrorMsg(playerid, "Vec posjedujete mobilni telefon.");

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1725.2416,-1136.1528,24.0985))
        return ErrorMsg(playerid, "Ne nalazite se u Samsung tech prodavnici.");

    format(PlayerPhone[playerid], 13, "Samsung"); 
    PlayerMoneySub(playerid, 2000);
    InfoMsg(playerid, "Uspjesno ste kupili mobilni telefon (%s).", PlayerPhone[playerid]);

    new query[112];
    format(query, sizeof query, "UPDATE igraci SET mobilni = '%s' WHERE id = %d", PlayerPhone[playerid], PI[playerid][p_id]);
    mysql_tquery(SQL, query);
    return 1;
}

alias:buysimcard("kupisim")
CMD:buysimcard(playerid)
{
    if(isnull(PlayerPhone[playerid]))
        return ErrorMsg(playerid, "Ne posjedujete mobilni telefon, kupite jedan u mobile shopu.");
    
    if(PlayerNumber[playerid] != 0)
        return ErrorMsg(playerid, "Vec posjedujete SIM karticu za telefon.");

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, 1726.7946, -1135.0697, 24.1268))
        return ErrorMsg(playerid, "Ne nalazite se kod labela za kupovinu kartice.");

    SPD(playerid, "SelectOperator", DIALOG_STYLE_TABLIST_HEADERS, "Odaberite operatera", "Operater\tPozivni broj\nBH Telecom\t061\nTelenor\t069\nm:tel\t067", "Odaberi", "Odustani");
    return 1;
}
alias:mobitel("mobilni")
CMD:mobitel(playerid)
{
    if(isnull(PlayerPhone[playerid]))
        return ErrorMsg(playerid, "Ne posjedujete mobilni telefon, kupite ga u Samsung tech prodavnici /gps.");

    if(MobileShowedMSG{playerid} && !InMobile{playerid})
    {
        MobileBackground(playerid, false);
        MobileOutline(playerid, false);
        MobileButtons(playerid, false);
        MobileMessage(playerid, false);
        CancelSelectTextDraw(playerid);

        return true;
    }

    if(!InMobile{playerid})
    {
        if(MobileShowedBG{playerid})
            MobileBackground(playerid, false);
        if(MobileShowedOUT{playerid})
            MobileOutline(playerid, false);
        if(MobileShowedBUT{playerid})
            MobileButtons(playerid, false);
        if(MobileShowedPHO{playerid})
            MobileButtons(playerid, false);
        
        MobileBackground(playerid, true);
        MobileOutline(playerid, true);
        MobileButtons(playerid, true);
        SelectTextDraw(playerid, 0xFFFFFF99);
        InMobile{playerid} = true;
    }
    else
    {
        MobileBackground(playerid, false);
        MobileOutline(playerid, false);
        if(MobileShowedBUT{playerid})
            MobileButtons(playerid, false);
        if(MobileShowedPHO{playerid})
            MobileButtons(playerid, false);
        CancelSelectTextDraw(playerid);
        InMobile{playerid} = false;
    }
    return 1;
}

alias:callplayer("call", "pozovi")
CMD:callplayer(playerid, params[])
{
    new
        broj,
        pozivni[11],
        parameternum[10],
        callingid = -1
    ;

    if(PlayerCredit[playerid] < 5)
        return ErrorMsg(playerid, "Nemas dovoljno kredita ($5), dokupi na trafici.");

    if(strlen(params) > 9)
        return ErrorMsg(playerid, "Nevazeci broj.");

    if(!sscanf(params, "s[12]", parameternum)) // primjer unosa: 061234567
    {
        if (!strcmp(parameternum, "069/666-999") || !strcmp(parameternum, "069666999"))
            return callcmd::weapondelivery1(playerid, "");

        if (!strcmp(params, "mehanicar", true) || !strcmp(params, "mehanicara", true))
        return callcmd::pozovimehanicara(playerid, "");

        if (!strcmp(params, "taxi", true) || !strcmp(params, "taksi", true))
            return callcmd::pozovitaxi(playerid, "");

        if(strlen(parameternum) < 9)
            return ErrorMsg(playerid, "Nevazeci broj");

        new tel[11], pozbr[4];
        format(tel, sizeof tel, "%s", parameternum);
        strdel(tel, 0, 3);
        format(pozbr, sizeof pozbr, "%s", parameternum);
        strdel(pozbr, 3, sizeof parameternum);
        broj = strval(tel);

        if(!strcmp(pozbr, "061"))
            format(pozivni, sizeof pozivni, "BH Telecom");
    
        else if(!strcmp(pozbr, "069"))
            format(pozivni, sizeof pozivni, "Telenor");

        else if(!strcmp(pozbr, "067"))
            format(pozivni, sizeof pozivni, "m:tel");
        
        else
            format(pozivni, sizeof pozivni, "N/A");

        if(!strcmp(pozivni, "N/A", true))
            return ErrorMsg(playerid, "Nepoznat pozivni broj.");

        if(broj == 0)
            return InfoMsg(playerid, "Nepoznat broj");
    }
    else
        return InfoMsg(playerid, "Nevazeci format, primjer vazeceg: 061671314");
    
    foreach(new i : Player)
    {
        if (!strcmp(PlayerOperator[i], pozivni, true) && PlayerNumber[i] == broj) 
        {
            callingid = i;
            break;
        }
    }

    if(callingid == -1)
        return ErrorMsg(playerid, "Neuspjesno ostvarivanje veze! Broj je pogresan ili je birani pretplatnik trenutno nedostupan.");
    
    if(callingid == playerid)
        return ErrorMsg(playerid, "Ne mozes nazvati sam sebe.");

    if(Talking{callingid} || Dialing[playerid] != -1)
        return ErrorMsg(playerid, "Birani broj je trenutno nedostupan, molimo pokusajte kasnije.");

    new
        callernumber[15]
    ;

    Dialing[playerid] = callingid;
    BeingCalled[callingid] = playerid;

    // Prikazi telefon igracu koji poziva
    if(!InMobile{playerid})
    {
        MobileBackground(playerid, true);
        MobileOutline(playerid, true);
        InMobile{playerid} = true;
    }
    MobileButtons(playerid, false);
    MobileCall(playerid, true);

    format(callernumber, sizeof callernumber, "%s-%i", pozivni, PlayerNumber[callingid]);
    PlayerTextDrawSetString(playerid, MobilePHO[playerid][8], callernumber);
    PlayerTextDrawSetString(playerid, MobilePHO[playerid][9], "Ukoliko zelis da prekines biranje~n~pritisni 'N'.~n~S vaseg kredita je skinuto\n$5");
    PlayerTextDrawShow(playerid, MobilePHO[playerid][8]);

    // Prikazi telefon igracu ciji se broj poziva
    if(!InMobile{callingid})
    {
        MobileBackground(callingid, true);
        MobileOutline(callingid, true);
        InMobile{callingid} = true;
    }
    else
    {
        if(MobileShowedMSG{callingid})
            MobileMessage(callingid, false);
        
        if(MobileShowedBUT{callingid})
        {
            MobileButtons(callingid, false);
            CancelSelectTextDraw(callingid);
        }
    }

    MobileCall(callingid, true);

    // Podesi call td-ove
    if(!strcmp(PlayerOperator[playerid], "BH Telecom"))
        format(pozivni, sizeof pozivni, "061");
    
    else if(!strcmp(PlayerOperator[playerid], "Telenor"))
        format(pozivni, sizeof pozivni, "069");

    else if(!strcmp(PlayerOperator[playerid], "m:tel"))
        format(pozivni, sizeof pozivni, "067");

    format(callernumber, sizeof callernumber, "%s-%i", pozivni, PlayerNumber[playerid]);
    PlayerTextDrawSetString(callingid, MobilePHO[callingid][8], callernumber);
    PlayerTextDrawShow(callingid, MobilePHO[callingid][8]);
    
    ResetPlayerCall[playerid] = SetTimerEx("ResetCall", 30000, false, "iis[4]i", playerid, callingid, pozivni, PlayerNumber[playerid]);

    return 1;
}

CMD:sendmessage(playerid, params[])
{
    new
        broj,
        pozivni[11],
        parameternum[10],
        message[50 + 1],
        callingid = -1
    ;

    if(PlayerCredit[playerid] < 3)
        return ErrorMsg(playerid, "Nemas dovoljno kredita ($3), dokupi na trafici.");

    if(!sscanf(params, "s[10]s[101]", parameternum, message)) // primjer unosa: 061234567
    {
        new tel[11], pozbr[4];
        format(tel, sizeof tel, "%s", parameternum);
        strdel(tel, 0, 3);
        format(pozbr, sizeof pozbr, "%s", parameternum);
        strdel(pozbr, 3, sizeof parameternum);
        broj = strval(tel);
        
        if(strlen(message) > 80)
        return ErrorMsg(playerid, "Poruka mora sadrzati manje od 80 karaktera!");

        if(!strcmp(pozbr, "061", true))
            format(pozivni, sizeof pozivni, "BH Telecom");
    
        else if(!strcmp(pozbr, "069", true))
            format(pozivni, sizeof pozivni, "Telenor");

        else if(!strcmp(pozbr, "067", true))
            format(pozivni, sizeof pozivni, "m:tel");
        
        else
            format(pozivni, sizeof pozivni, "N/A");

        if(!strcmp(pozivni, "N/A", true))
            return ErrorMsg(playerid, "Nepoznat pozivni broj.");

        if(broj == 0)
            return InfoMsg(playerid, "Nepoznat broj");
    }
    else
        return InfoMsg(playerid, "Nevazeci format, primjer vazeceg: 061671314");
    
    foreach(new i : Player)
    {
        if (!strcmp(PlayerOperator[i], pozivni, true) && PlayerNumber[i] == broj) 
        {
            callingid = i;
            break;
        }
    }

    if(callingid == -1)
        return ErrorMsg(playerid, "Neuspjesno slanje poruke! Broj je pogresan ili je birani pretplatnik trenutno nedostupan.");
    
    if(callingid == playerid)
        return ErrorMsg(playerid, "Ne mozes sam sebi poslati poruku.");

    if(Talking{callingid})
        return ErrorMsg(playerid, "Birani broj je trenutno nedostupan, molimo pokusajte kasnije.");

    new
        strparam[2][25]
    ;
    
    PlayerMessageLast[callingid] += 1;

    switch(PlayerMessageLast[callingid])
    {
        case 1: {}
        case 2:
        {
            PlayerMessageNumber[callingid][1] = PlayerMessageNumber[callingid][0];
            PlayerMessage[callingid][1] = PlayerMessage[callingid][0];
        }
        case 3:
        {
            PlayerMessageNumber[callingid][2] = PlayerMessageNumber[callingid][1];
            PlayerMessage[callingid][2] = PlayerMessage[callingid][1];
            
            PlayerMessageNumber[callingid][1] = PlayerMessageNumber[callingid][0];
            PlayerMessage[callingid][1] = PlayerMessage[callingid][0];
        }
        default:
        {
            PlayerMessageNumber[callingid][3] = PlayerMessageNumber[callingid][2];
            PlayerMessage[callingid][3] = PlayerMessage[callingid][2];

            PlayerMessageNumber[callingid][2] = PlayerMessageNumber[callingid][1];
            PlayerMessage[callingid][2] = PlayerMessage[callingid][1];
            
            PlayerMessageNumber[callingid][1] = PlayerMessageNumber[callingid][0];
            PlayerMessage[callingid][1] = PlayerMessage[callingid][0];
        }
    }

    strmid(strparam[0], message, 0, 25, 25+1);
    strmid(strparam[1], message, 25, 50, 25+1);
    
    format(PlayerMessage[callingid][0], 60, "%s", strparam[0]);

    if(!isnull(strparam[1]))
        format(PlayerMessage[callingid][0], 64, "%s-~n~%s", PlayerMessage[callingid][0], strparam[1]);

    // Prikazi telefon igracu ciji se broj poziva
    if(!InMobile{callingid})
    {
        MobileBackground(callingid, true);
        MobileOutline(callingid, true);
        InMobile{callingid} = true;
    }
    else
    {
        if(MobileShowedBUT{callingid})
        {
            MobileButtons(callingid, false);
            CancelSelectTextDraw(callingid);
        }
        if(MobileShowedMSG{callingid})
        {
            MobileMessage(callingid, false);
        }
    }

    if(MobileShowedBUT{callingid})
    {
        MobileButtons(callingid, false);
        CancelSelectTextDraw(callingid);
    }
    if(MobileShowedMSG{callingid})
    {
        MobileMessage(callingid, false);
    }

    // Podesi msg td-ove
    if(!strcmp(PlayerOperator[playerid], "BH Telecom"))
        format(pozivni, sizeof pozivni, "061");

    else if(!strcmp(PlayerOperator[playerid], "Telenor"))
        format(pozivni, sizeof pozivni, "069");

    else if(!strcmp(PlayerOperator[playerid], "m:tel"))
        format(pozivni, sizeof pozivni, "067");

    format(PlayerMessageNumber[callingid][0], 13, "(%s) %i", pozivni, PlayerNumber[playerid]);

    MobileMessage(callingid, true);

    InMobile{callingid} = false;

    PlayerTextDrawShow(callingid, MobileMSG[callingid][12]);

    // Dojavi igracu da je poruka uspjesno poslana
    InfoMsg(playerid, "Uspjesno si poslao poruku.");
    return 1;
}
