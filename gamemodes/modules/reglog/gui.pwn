new PlayerText:login_gui[MAX_PLAYERS][32];
new PlayerText:register_gui[MAX_PLAYERS][140];

#define TD_COLOR_VALID    (182223244)
#define TD_COLOR_INVALID  (-601351540)

CreateRegisterTD(playerid, bool:create) {

	if (create) {
		register_gui[playerid][0] = CreatePlayerTextDraw(playerid, 223.666702, 73.780250, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][0], 192.000000, 297.369384);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][0], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][0], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][0], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][0], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][0], 0);

		register_gui[playerid][1] = CreatePlayerTextDraw(playerid, 217.700027, 71.691368, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][1], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][1], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][1], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][1], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][1], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][1], 0);

		register_gui[playerid][2] = CreatePlayerTextDraw(playerid, 409.800170, 71.791366, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][2], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][2], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][2], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][2], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][2], 0);

		register_gui[playerid][3] = CreatePlayerTextDraw(playerid, 409.933685, 360.367309, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][3], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][3], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][3], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][3], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][3], 0);

		register_gui[playerid][4] = CreatePlayerTextDraw(playerid, 217.766845, 360.340576, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][4], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][4], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][4], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][4], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][4], 0);

		register_gui[playerid][5] = CreatePlayerTextDraw(playerid, 219.766708, 78.146705, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][5], 5.000000, 290.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][5], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][5], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][5], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][5], 0);

		register_gui[playerid][6] = CreatePlayerTextDraw(playerid, 410.900115, 77.002296, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][6], 8.799995, 290.959960);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][6], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][6], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][6], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][6], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][6], 0);

		register_gui[playerid][7] = CreatePlayerTextDraw(playerid, 219.866043, 214.821441, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][7], 112.000000, -141.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][7], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][7], -239);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][7], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][7], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][7], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][7], 1317);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][7], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][7], 0.000000, 90.000000, 90.000000, 0.000000);

		register_gui[playerid][8] = CreatePlayerTextDraw(playerid, 227.166702, 92.502510, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][8], 38.000000, 44.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][8], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][8], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][8], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][8], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][8], 0);

		register_gui[playerid][9] = CreatePlayerTextDraw(playerid, 230.666671, 94.817428, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][9], 32.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][9], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][9], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][9], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][9], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][9], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][9], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][9], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][9], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][9], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][10] = CreatePlayerTextDraw(playerid, 228.200057, 91.743324, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][10], 37.000000, 44.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][10], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][10], 219685170);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][10], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][10], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][10], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][10], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][10], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][10], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][10], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][11] = CreatePlayerTextDraw(playerid, 209.666641, 53.336017, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][11], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][11], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][11], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][11], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][11], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][11], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][11], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][11], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][11], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][11], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][12] = CreatePlayerTextDraw(playerid, 209.666641, 57.495391, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][12], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][12], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][12], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][12], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][12], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][12], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][12], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][12], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][12], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][12], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][13] = CreatePlayerTextDraw(playerid, 220.066696, 158.640304, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][13], 53.000000, -93.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][13], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][13], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][13], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][13], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][13], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][13], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][13], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][13], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][13], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][14] = CreatePlayerTextDraw(playerid, 220.366714, 153.092010, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][14], 50.000000, -84.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][14], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][14], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][14], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][14], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][14], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][14], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][14], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][14], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][14], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][15] = CreatePlayerTextDraw(playerid, 221.567367, 53.336017, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][15], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][15], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][15], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][15], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][15], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][15], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][15], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][15], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][15], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][15], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][16] = CreatePlayerTextDraw(playerid, 223.867507, 51.535907, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][16], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][16], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][16], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][16], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][16], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][16], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][16], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][16], 19177);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][16], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][16], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][17] = CreatePlayerTextDraw(playerid, 242.033309, 119.994956, "OGC");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][17], 0.104332, 0.446815);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][17], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][17], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][17], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][17], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][17], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][17], 1);

		register_gui[playerid][18] = CreatePlayerTextDraw(playerid, 274.400085, 165.699249, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][18], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][18], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][18], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][18], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][18], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][18], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][18], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][18], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][18], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][18], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][19] = CreatePlayerTextDraw(playerid, 274.700103, 166.099273, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][19], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][19], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][19], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][19], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][19], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][19], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][19], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][19], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][19], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][19], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][20] = CreatePlayerTextDraw(playerid, 276.900238, 165.699249, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][20], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][20], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][20], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][20], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][20], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][20], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][20], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][20], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][20], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][20], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][21] = CreatePlayerTextDraw(playerid, 278.300323, 166.099273, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][21], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][21], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][21], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][21], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][21], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][21], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][21], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][21], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][21], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][21], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][22] = CreatePlayerTextDraw(playerid, 282.066345, 123.143127, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][22], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][22], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][22], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][22], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][22], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][22], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][22], 0);

		register_gui[playerid][23] = CreatePlayerTextDraw(playerid, 288.499572, 122.854293, "Unesite_Vasu_lozinku:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][23], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][23], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][23], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][23], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][23], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][23], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][23], 1);

		register_gui[playerid][24] = CreatePlayerTextDraw(playerid, 348.166381, 109.580261, "I_N_S_E_R_T__P_A_S_S_W_O_R_D");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][24], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][24], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][24], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][24], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][24], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][24], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][24], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][24], true);

		register_gui[playerid][25] = CreatePlayerTextDraw(playerid, 297.532714, 104.017417, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][25], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][25], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][25], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][25], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][25], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][25], 0);

		register_gui[playerid][26] = CreatePlayerTextDraw(playerid, 350.035919, 123.018554, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][26], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][26], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][26], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][26], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][26], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][26], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][26], 0);

		register_gui[playerid][27] = CreatePlayerTextDraw(playerid, 399.466217, 117.906044, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][27], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][27], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][27], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][27], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][27], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][27], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][27], 1);

		register_gui[playerid][28] = CreatePlayerTextDraw(playerid, 400.866241, 114.598785, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][28], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][28], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][28], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][28], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][28], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][28], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][28], 1);

		register_gui[playerid][29] = CreatePlayerTextDraw(playerid, 348.866149, 98.865463, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][29], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][29], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][29], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][29], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][29], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][29], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][29], 1);

		register_gui[playerid][30] = CreatePlayerTextDraw(playerid, 339.466156, 118.046875, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][30], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][30], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][30], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][30], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][30], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][30], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][30], 1);

		register_gui[playerid][31] = CreatePlayerTextDraw(playerid, 402.766143, 110.265411, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][31], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][31], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][31], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][31], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][31], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][31], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][31], 1);

		register_gui[playerid][32] = CreatePlayerTextDraw(playerid, 275.066802, 204.266448, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][32], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][32], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][32], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][32], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][32], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][32], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][32], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][32], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][32], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][32], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][33] = CreatePlayerTextDraw(playerid, 275.366821, 204.666473, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][33], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][33], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][33], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][33], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][33], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][33], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][33], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][33], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][33], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][33], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][34] = CreatePlayerTextDraw(playerid, 277.566955, 204.266448, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][34], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][34], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][34], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][34], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][34], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][34], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][34], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][34], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][34], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][34], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][35] = CreatePlayerTextDraw(playerid, 278.967041, 204.666473, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][35], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][35], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][35], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][35], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][35], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][35], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][35], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][35], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][35], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][35], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][36] = CreatePlayerTextDraw(playerid, 282.733062, 161.710525, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][36], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][36], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][36], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][36], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][36], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][36], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][36], 0);

		register_gui[playerid][37] = CreatePlayerTextDraw(playerid, 289.166290, 161.421691, "Unesite_vas_email:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][37], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][37], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][37], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][37], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][37], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][37], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][37], 1);

		register_gui[playerid][38] = CreatePlayerTextDraw(playerid, 348.833099, 148.147521, "I_N_S_E_R_T__E_M_A_I_L");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][38], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][38], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][38], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][38], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][38], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][38], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][38], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][38], true);

		register_gui[playerid][39] = CreatePlayerTextDraw(playerid, 298.199432, 142.584655, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][39], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][39], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][39], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][39], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][39], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][39], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][39], 0);

		register_gui[playerid][40] = CreatePlayerTextDraw(playerid, 350.702636, 161.585952, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][40], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][40], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][40], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][40], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][40], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][40], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][40], 0);

		register_gui[playerid][41] = CreatePlayerTextDraw(playerid, 400.132934, 156.473358, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][41], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][41], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][41], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][41], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][41], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][41], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][41], 1);

		register_gui[playerid][42] = CreatePlayerTextDraw(playerid, 401.532958, 153.166076, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][42], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][42], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][42], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][42], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][42], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][42], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][42], 1);

		register_gui[playerid][43] = CreatePlayerTextDraw(playerid, 349.532867, 137.432723, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][43], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][43], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][43], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][43], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][43], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][43], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][43], 1);

		register_gui[playerid][44] = CreatePlayerTextDraw(playerid, 340.132873, 156.614181, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][44], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][44], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][44], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][44], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][44], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][44], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][44], 1);

		register_gui[playerid][45] = CreatePlayerTextDraw(playerid, 403.432861, 148.832672, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][45], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][45], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][45], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][45], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][45], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][45], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][45], 1);

		register_gui[playerid][46] = CreatePlayerTextDraw(playerid, 275.400146, 242.556838, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][46], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][46], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][46], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][46], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][46], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][46], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][46], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][46], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][46], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][46], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][47] = CreatePlayerTextDraw(playerid, 275.700164, 242.956863, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][47], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][47], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][47], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][47], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][47], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][47], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][47], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][47], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][47], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][47], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][48] = CreatePlayerTextDraw(playerid, 277.900299, 242.556838, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][48], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][48], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][48], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][48], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][48], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][48], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][48], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][48], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][48], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][48], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][49] = CreatePlayerTextDraw(playerid, 279.300384, 242.956863, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][49], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][49], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][49], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][49], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][49], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][49], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][49], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][49], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][49], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][49], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][50] = CreatePlayerTextDraw(playerid, 283.066406, 200.000915, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][50], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][50], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][50], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][50], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][50], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][50], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][50], 0);

		register_gui[playerid][51] = CreatePlayerTextDraw(playerid, 289.499633, 199.712081, "Unesite_vas_spol:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][51], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][51], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][51], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][51], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][51], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][51], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][51], 1);

		register_gui[playerid][52] = CreatePlayerTextDraw(playerid, 349.166442, 186.437911, "I_N_S_E_R_T__S_E_X");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][52], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][52], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][52], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][52], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][52], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][52], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][52], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][52], true);

		register_gui[playerid][53] = CreatePlayerTextDraw(playerid, 298.532775, 180.875045, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][53], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][53], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][53], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][53], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][53], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][53], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][53], 0);

		register_gui[playerid][54] = CreatePlayerTextDraw(playerid, 351.035980, 199.876342, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][54], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][54], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][54], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][54], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][54], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][54], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][54], 0);

		register_gui[playerid][55] = CreatePlayerTextDraw(playerid, 400.466278, 194.763748, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][55], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][55], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][55], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][55], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][55], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][55], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][55], 1);

		register_gui[playerid][56] = CreatePlayerTextDraw(playerid, 401.866302, 191.456466, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][56], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][56], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][56], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][56], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][56], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][56], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][56], 1);

		register_gui[playerid][57] = CreatePlayerTextDraw(playerid, 349.866210, 175.723114, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][57], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][57], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][57], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][57], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][57], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][57], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][57], 1);

		register_gui[playerid][58] = CreatePlayerTextDraw(playerid, 340.466217, 194.904571, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][58], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][58], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][58], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][58], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][58], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][58], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][58], 1);

		register_gui[playerid][59] = CreatePlayerTextDraw(playerid, 403.766204, 187.123062, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][59], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][59], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][59], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][59], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][59], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][59], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][59], 1);

		register_gui[playerid][60] = CreatePlayerTextDraw(playerid, 275.733581, 281.505126, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][60], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][60], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][60], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][60], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][60], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][60], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][60], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][60], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][60], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][60], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][61] = CreatePlayerTextDraw(playerid, 276.033599, 281.905151, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][61], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][61], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][61], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][61], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][61], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][61], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][61], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][61], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][61], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][61], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][62] = CreatePlayerTextDraw(playerid, 278.233734, 281.505126, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][62], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][62], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][62], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][62], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][62], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][62], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][62], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][62], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][62], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][62], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][63] = CreatePlayerTextDraw(playerid, 279.633819, 281.905151, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][63], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][63], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][63], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][63], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][63], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][63], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][63], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][63], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][63], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][63], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][64] = CreatePlayerTextDraw(playerid, 283.399841, 238.949142, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][64], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][64], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][64], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][64], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][64], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][64], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][64], 0);

		register_gui[playerid][65] = CreatePlayerTextDraw(playerid, 289.833068, 238.660308, "Unesite_vasu_drzavu:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][65], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][65], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][65], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][65], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][65], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][65], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][65], 1);

		register_gui[playerid][66] = CreatePlayerTextDraw(playerid, 349.499877, 225.386138, "I_N_S_E_R_T__C_O_U_N_T_R_Y");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][66], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][66], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][66], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][66], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][66], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][66], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][66], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][66], true);

		register_gui[playerid][67] = CreatePlayerTextDraw(playerid, 298.866210, 219.823272, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][67], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][67], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][67], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][67], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][67], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][67], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][67], 0);

		register_gui[playerid][68] = CreatePlayerTextDraw(playerid, 351.369415, 238.824569, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][68], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][68], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][68], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][68], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][68], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][68], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][68], 0);

		register_gui[playerid][69] = CreatePlayerTextDraw(playerid, 400.799713, 233.711975, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][69], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][69], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][69], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][69], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][69], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][69], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][69], 1);

		register_gui[playerid][70] = CreatePlayerTextDraw(playerid, 402.199737, 230.404693, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][70], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][70], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][70], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][70], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][70], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][70], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][70], 1);

		register_gui[playerid][71] = CreatePlayerTextDraw(playerid, 350.199645, 214.671340, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][71], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][71], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][71], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][71], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][71], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][71], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][71], 1);

		register_gui[playerid][72] = CreatePlayerTextDraw(playerid, 340.799652, 233.852798, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][72], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][72], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][72], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][72], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][72], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][72], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][72], 1);

		register_gui[playerid][73] = CreatePlayerTextDraw(playerid, 404.099639, 226.071289, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][73], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][73], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][73], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][73], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][73], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][73], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][73], 1);

		register_gui[playerid][74] = CreatePlayerTextDraw(playerid, 275.066894, 322.986663, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][74], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][74], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][74], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][74], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][74], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][74], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][74], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][74], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][74], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][74], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][75] = CreatePlayerTextDraw(playerid, 275.366912, 323.386688, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][75], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][75], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][75], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][75], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][75], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][75], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][75], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][75], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][75], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][75], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][76] = CreatePlayerTextDraw(playerid, 277.567047, 322.986663, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][76], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][76], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][76], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][76], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][76], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][76], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][76], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][76], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][76], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][76], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][77] = CreatePlayerTextDraw(playerid, 278.967132, 323.386688, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][77], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][77], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][77], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][77], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][77], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][77], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][77], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][77], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][77], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][77], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][78] = CreatePlayerTextDraw(playerid, 282.733154, 280.430725, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][78], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][78], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][78], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][78], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][78], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][78], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][78], 0);

		register_gui[playerid][79] = CreatePlayerTextDraw(playerid, 289.166381, 280.141876, "Unesite_vase_godine:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][79], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][79], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][79], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][79], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][79], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][79], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][79], 1);

		register_gui[playerid][80] = CreatePlayerTextDraw(playerid, 348.833190, 266.867736, "I_N_S_E_R_T__A_G_E");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][80], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][80], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][80], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][80], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][80], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][80], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][80], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][80], true);

		register_gui[playerid][81] = CreatePlayerTextDraw(playerid, 298.199523, 261.304779, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][81], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][81], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][81], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][81], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][81], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][81], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][81], 0);

		register_gui[playerid][82] = CreatePlayerTextDraw(playerid, 350.702728, 280.306152, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][82], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][82], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][82], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][82], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][82], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][82], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][82], 0);

		register_gui[playerid][83] = CreatePlayerTextDraw(playerid, 400.133026, 275.193572, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][83], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][83], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][83], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][83], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][83], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][83], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][83], 1);

		register_gui[playerid][84] = CreatePlayerTextDraw(playerid, 401.533050, 271.886260, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][84], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][84], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][84], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][84], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][84], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][84], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][84], 1);

		register_gui[playerid][85] = CreatePlayerTextDraw(playerid, 349.532958, 256.152862, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][85], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][85], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][85], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][85], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][85], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][85], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][85], 1);

		register_gui[playerid][86] = CreatePlayerTextDraw(playerid, 340.132965, 275.334381, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][86], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][86], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][86], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][86], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][86], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][86], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][86], 1);

		register_gui[playerid][87] = CreatePlayerTextDraw(playerid, 403.432952, 267.552856, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][87], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][87], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][87], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][87], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][87], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][87], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][87], 1);

		register_gui[playerid][88] = CreatePlayerTextDraw(playerid, 274.700408, 364.523895, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][88], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][88], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][88], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][88], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][88], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][88], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][88], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][88], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][88], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][88], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][89] = CreatePlayerTextDraw(playerid, 275.000427, 364.923919, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][89], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][89], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][89], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][89], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][89], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][89], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][89], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][89], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][89], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][89], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][90] = CreatePlayerTextDraw(playerid, 277.200561, 364.523895, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][90], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][90], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][90], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][90], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][90], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][90], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][90], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][90], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][90], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][90], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][91] = CreatePlayerTextDraw(playerid, 278.600646, 364.923919, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][91], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][91], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][91], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][91], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][91], -256);
		PlayerTextDrawFont(playerid, register_gui[playerid][91], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][91], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][91], 1318);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][91], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][91], 0.000000, 0.000000, 90.000000, 1.000000);

		register_gui[playerid][92] = CreatePlayerTextDraw(playerid, 282.366668, 321.967956, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][92], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][92], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][92], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][92], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][92], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][92], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][92], 0);

		register_gui[playerid][93] = CreatePlayerTextDraw(playerid, 288.799896, 321.679107, "Odaberite_tip_izgleda:");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][93], 0.081666, 0.496592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][93], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][93], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][93], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][93], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][93], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][93], 1);

		register_gui[playerid][94] = CreatePlayerTextDraw(playerid, 348.466705, 308.404968, "C_H_O_O_S_E__S_K_I_N");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][94], 0.119332, 0.608592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][94], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][94], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][94], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][94], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][94], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][94], 1);
		PlayerTextDrawSetSelectable(playerid, register_gui[playerid][94], true);

		register_gui[playerid][95] = CreatePlayerTextDraw(playerid, 297.833038, 302.842010, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][95], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][95], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][95], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][95], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][95], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][95], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][95], 0);

		register_gui[playerid][96] = CreatePlayerTextDraw(playerid, 350.336242, 321.843383, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][96], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][96], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][96], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][96], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][96], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][96], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][96], 0);

		register_gui[playerid][97] = CreatePlayerTextDraw(playerid, 399.766540, 316.730804, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][97], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][97], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][97], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][97], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][97], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][97], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][97], 1);

		register_gui[playerid][98] = CreatePlayerTextDraw(playerid, 401.166564, 313.423492, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][98], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][98], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][98], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][98], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][98], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][98], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][98], 1);

		register_gui[playerid][99] = CreatePlayerTextDraw(playerid, 349.166473, 297.690093, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][99], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][99], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][99], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][99], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][99], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][99], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][99], 1);

		register_gui[playerid][100] = CreatePlayerTextDraw(playerid, 339.766479, 316.871612, ".......");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][100], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][100], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][100], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][100], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][100], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][100], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][100], 1);

		register_gui[playerid][101] = CreatePlayerTextDraw(playerid, 403.066467, 309.090087, ".");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][101], 0.155999, 0.670814);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][101], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][101], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][101], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][101], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][101], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][101], 1);

		// OVI TDOVI TREBAJU DA SE POJAVLJUJU PRI ISPRAVNO UNESENOM POLJU
		register_gui[playerid][102] = CreatePlayerTextDraw(playerid, 398.500091, 98.333213, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][102], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][102], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][102], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][102], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][102], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][102], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][102], 0);

		register_gui[playerid][103] = CreatePlayerTextDraw(playerid, 404.500183, 103.381370, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][103], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][103], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][103], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][103], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][103], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][103], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][103], 1);

		register_gui[playerid][104] = CreatePlayerTextDraw(playerid, 406.500152, 107.744316, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][104], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][104], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][104], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][104], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][104], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][104], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][104], 1);

		//////
		register_gui[playerid][105] = CreatePlayerTextDraw(playerid, 398.500091, 137.236083, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][105], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][105], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][105], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][105], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][105], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][105], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][105], 0);

		register_gui[playerid][106] = CreatePlayerTextDraw(playerid, 404.500183, 142.284225, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][106], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][106], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][106], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][106], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][106], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][106], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][106], 1);

		register_gui[playerid][107] = CreatePlayerTextDraw(playerid, 406.500152, 146.647171, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][107], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][107], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][107], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][107], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][107], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][107], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][107], 1);

		//////
		register_gui[playerid][108] = CreatePlayerTextDraw(playerid, 398.500091, 174.538330, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][108], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][108], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][108], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][108], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][108], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][108], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][108], 0);

		register_gui[playerid][109] = CreatePlayerTextDraw(playerid, 404.500183, 179.586486, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][109], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][109], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][109], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][109], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][109], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][109], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][109], 1);

		register_gui[playerid][110] = CreatePlayerTextDraw(playerid, 406.500152, 183.949432, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][110], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][110], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][110], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][110], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][110], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][110], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][110], 1);

		//////
		register_gui[playerid][111] = CreatePlayerTextDraw(playerid, 398.500091, 213.440704, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][111], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][111], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][111], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][111], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][111], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][111], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][111], 0);

		register_gui[playerid][112] = CreatePlayerTextDraw(playerid, 404.500183, 218.488891, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][112], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][112], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][112], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][112], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][112], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][112], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][112], 1);

		register_gui[playerid][113] = CreatePlayerTextDraw(playerid, 406.500152, 222.851852, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][113], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][113], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][113], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][113], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][113], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][113], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][113], 1);

		//////
		register_gui[playerid][114] = CreatePlayerTextDraw(playerid, 398.500091, 254.843276, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][114], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][114], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][114], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][114], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][114], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][114], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][114], 0);

		register_gui[playerid][115] = CreatePlayerTextDraw(playerid, 404.500183, 259.891448, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][115], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][115], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][115], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][115], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][115], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][115], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][115], 1);

		register_gui[playerid][116] = CreatePlayerTextDraw(playerid, 406.500152, 264.254425, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][116], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][116], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][116], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][116], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][116], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][116], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][116], 1);

		//////
		register_gui[playerid][117] = CreatePlayerTextDraw(playerid, 398.532989, 295.257049, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][117], 11.000000, 12.350008);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][117], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][117], 871733759);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][117], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][117], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][117], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][117], 0);

		register_gui[playerid][118] = CreatePlayerTextDraw(playerid, 404.533020, 300.305206, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][118], -0.194333, 0.405333);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][118], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][118], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][118], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][118], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][118], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][118], 1);

		register_gui[playerid][119] = CreatePlayerTextDraw(playerid, 406.533020, 304.668182, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][119], -0.203000, -0.656592);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][119], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][119], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][119], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][119], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][119], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][119], 1);

		////// OVI TDOVI SU TU ZA STALNO
		register_gui[playerid][120] = CreatePlayerTextDraw(playerid, 243.000137, 149.585571, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][120], 8.000000, 5.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][120], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][120], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][120], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][120], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][120], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][120], 0);

		register_gui[playerid][121] = CreatePlayerTextDraw(playerid, 242.733322, 149.207977, "V");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][121], 0.312666, 0.484148);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][121], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][121], 255);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][121], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][121], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][121], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][121], 1);

		register_gui[playerid][122] = CreatePlayerTextDraw(playerid, 241.900054, 185.141326, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][122], 6.420009, 8.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][122], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][122], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][122], 0);
		PlayerTextDrawFont(playerid, register_gui[playerid][122], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][122], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][122], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][122], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][122], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][123] = CreatePlayerTextDraw(playerid, 244.733383, 192.063598, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][123], 0.849999, 4.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][123], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][123], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][123], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][123], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][123], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][123], 0);

		register_gui[playerid][124] = CreatePlayerTextDraw(playerid, 243.666687, 193.782012, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][124], 3.000000, 1.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][124], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][124], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][124], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][124], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][124], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][124], 0);

		register_gui[playerid][125] = CreatePlayerTextDraw(playerid, 245.200256, 185.041320, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][125], 6.420009, 8.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][125], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][125], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][125], 0);
		PlayerTextDrawFont(playerid, register_gui[playerid][125], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][125], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][125], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][125], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][125], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][126] = CreatePlayerTextDraw(playerid, 249.500122, 183.837631, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][126], 0.229999, 0.409481);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][126], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][126], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][126], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][126], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][126], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][126], 1);

		register_gui[playerid][127] = CreatePlayerTextDraw(playerid, 249.500122, 183.837631, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][127], 0.229999, 0.409481);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][127], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][127], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][127], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][127], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][127], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][127], 1);

		register_gui[playerid][128] = CreatePlayerTextDraw(playerid, 249.533370, 183.008056, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][128], 0.252333, 0.193778);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][128], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][128], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][128], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][128], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][128], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][128], 1);

		register_gui[playerid][129] = CreatePlayerTextDraw(playerid, 249.533370, 183.008056, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][129], 0.252333, 0.193778);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][129], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][129], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][129], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][129], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][129], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][129], 1);

		register_gui[playerid][130] = CreatePlayerTextDraw(playerid, 251.900009, 186.726608, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][130], 0.133333, -0.357925);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][130], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][130], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][130], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][130], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][130], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][130], 1);

		register_gui[playerid][131] = CreatePlayerTextDraw(playerid, 251.900009, 186.726608, "/");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][131], 0.133333, -0.357925);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][131], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][131], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][131], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][131], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][131], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][131], 1);

		register_gui[playerid][132] = CreatePlayerTextDraw(playerid, 243.333267, 222.548660, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][132], 9.000000, 11.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][132], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][132], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][132], 0);
		PlayerTextDrawFont(playerid, register_gui[playerid][132], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][132], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][132], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][132], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][132], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][133] = CreatePlayerTextDraw(playerid, 245.133270, 223.707763, ")l(");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][133], 0.157666, 0.890666);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][133], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][133], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][133], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][133], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][133], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][133], 1);

		register_gui[playerid][134] = CreatePlayerTextDraw(playerid, 242.900054, 262.982177, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][134], 11.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][134], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][134], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][134], 0);
		PlayerTextDrawFont(playerid, register_gui[playerid][134], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][134], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][134], 1316);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][134], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][134], 90.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][135] = CreatePlayerTextDraw(playerid, 245.600082, 267.674591, "18+");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][135], 0.098333, 0.430222);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][135], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][135], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][135], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][135], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][135], 1);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][135], 1);

		register_gui[playerid][136] = CreatePlayerTextDraw(playerid, 244.333343, 304.793365, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][136], 11.000000, 12.100002);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][136], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][136], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][136], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][136], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][136], 4);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][136], 0);

		register_gui[playerid][137] = CreatePlayerTextDraw(playerid, 245.866531, 306.167236, "");
		PlayerTextDrawTextSize(playerid, register_gui[playerid][137], 8.000000, 9.000000);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][137], 1);
		PlayerTextDrawColor(playerid, register_gui[playerid][137], 219685375);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][137], 0);
		PlayerTextDrawFont(playerid, register_gui[playerid][137], 5);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][137], 0);
		PlayerTextDrawSetPreviewModel(playerid, register_gui[playerid][137], 1275);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][137], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, register_gui[playerid][137], 0.000000, 0.000000, 0.000000, 1.000000);

		register_gui[playerid][138] = CreatePlayerTextDraw(playerid, 319.500000, 356.667358, "copyright_Northern_Lights_community_&_daddyDOT__//__2k21/22");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][138], 0.090666, 0.442666);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][138], 2);
		PlayerTextDrawColor(playerid, register_gui[playerid][138], -1061109505);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][138], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][138], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][138], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][138], 1);

		register_gui[playerid][139] = CreatePlayerTextDraw(playerid, 632.489501, 6.833309, "nl_v4.2_by_zile42o");
		PlayerTextDrawLetterSize(playerid, register_gui[playerid][139], 0.151683, 0.929166);
		PlayerTextDrawAlignment(playerid, register_gui[playerid][139], 3);
		PlayerTextDrawColor(playerid, register_gui[playerid][139], -1);
		PlayerTextDrawSetShadow(playerid, register_gui[playerid][139], 0);
		PlayerTextDrawBackgroundColor(playerid, register_gui[playerid][139], 255);
		PlayerTextDrawFont(playerid, register_gui[playerid][139], 2);
		PlayerTextDrawSetProportional(playerid, register_gui[playerid][139], 1);
	}
	else {
		for (new i; i < 140; i++) {
			PlayerTextDrawDestroy(playerid, register_gui[playerid][i]);
			register_gui[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}
	return true;
}


CreateLoginTD(playerid, bool:create) {

	if (create) {
		login_gui[playerid][0] = CreatePlayerTextDraw(playerid, 223.333374, 182.069366, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][0], 192.000000, 88.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][0], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][0], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][0], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][0], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][0], 0);

		login_gui[playerid][1] = CreatePlayerTextDraw(playerid, 217.366699, 179.780502, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][1], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][1], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][1], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][1], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][1], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][1], 0);

		login_gui[playerid][2] = CreatePlayerTextDraw(playerid, 409.466827, 179.780502, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][2], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][2], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][2], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][2], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][2], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][2], 0);

		login_gui[playerid][3] = CreatePlayerTextDraw(playerid, 409.600219, 259.139801, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][3], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][3], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][3], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][3], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][3], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][3], 0);

		login_gui[playerid][4] = CreatePlayerTextDraw(playerid, 217.433517, 259.139831, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][4], 12.000000, 13.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][4], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][4], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][4], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][4], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][4], 0);

		login_gui[playerid][5] = CreatePlayerTextDraw(playerid, 219.433380, 186.435836, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][5], 9.000000, 80.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][5], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][5], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][5], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][5], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][5], 0);

		login_gui[playerid][6] = CreatePlayerTextDraw(playerid, 410.566772, 185.291412, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][6], 9.000000, 80.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][6], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][6], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][6], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][6], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][6], 0);

		login_gui[playerid][7] = CreatePlayerTextDraw(playerid, 219.532714, 323.110076, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][7], 112.000000, -141.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][7], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][7], -239);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][7], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][7], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][7], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][7], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][7], 1317);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][7], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][7], 0.000000, 90.000000, 90.000000, 0.000000);

		login_gui[playerid][8] = CreatePlayerTextDraw(playerid, 226.833374, 200.791656, "ld_beat:chit");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][8], 38.000000, 44.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][8], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][8], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][8], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][8], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][8], 0);

		login_gui[playerid][9] = CreatePlayerTextDraw(playerid, 230.333343, 203.106582, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][9], 32.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][9], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][9], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][9], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][9], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][9], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][9], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][9], 1316);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][9], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][9], 90.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][10] = CreatePlayerTextDraw(playerid, 227.866729, 200.032470, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][10], 37.000000, 44.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][10], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][10], 219685170);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][10], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][10], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][10], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][10], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][10], 1316);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][10], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][10], 90.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][11] = CreatePlayerTextDraw(playerid, 209.333312, 161.625137, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][11], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][11], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][11], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][11], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][11], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][11], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][11], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][11], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][11], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][11], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][12] = CreatePlayerTextDraw(playerid, 209.333312, 165.784530, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][12], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][12], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][12], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][12], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][12], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][12], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][12], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][12], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][12], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][12], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][13] = CreatePlayerTextDraw(playerid, 219.733367, 266.928894, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][13], 53.000000, -93.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][13], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][13], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][13], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][13], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][13], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][13], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][13], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][13], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][13], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][14] = CreatePlayerTextDraw(playerid, 220.033386, 261.380584, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][14], 50.000000, -84.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][14], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][14], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][14], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][14], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][14], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][14], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][14], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][14], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][14], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][15] = CreatePlayerTextDraw(playerid, 221.234039, 161.625137, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][15], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][15], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][15], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][15], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][15], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][15], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][15], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][15], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][15], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][15], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][16] = CreatePlayerTextDraw(playerid, 223.534179, 159.825027, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][16], 62.000000, 120.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][16], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][16], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][16], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][16], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][16], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][16], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][16], 19177);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][16], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][16], 0.000000, 0.000000, 0.000000, 1.000000);

		login_gui[playerid][17] = CreatePlayerTextDraw(playerid, 241.699981, 228.284133, "OGC");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][17], 0.104333, 0.446815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][17], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][17], -1061109505);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][17], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][17], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][17], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][17], 1);

		login_gui[playerid][18] = CreatePlayerTextDraw(playerid, 274.066741, 273.987854, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][18], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][18], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][18], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][18], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][18], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][18], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][18], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][18], 1318);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][18], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][18], 0.000000, 0.000000, 90.000000, 1.000000);

		login_gui[playerid][19] = CreatePlayerTextDraw(playerid, 274.366760, 274.387878, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][19], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][19], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][19], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][19], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][19], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][19], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][19], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][19], 1318);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][19], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][19], 0.000000, 0.000000, 90.000000, 1.000000);

		login_gui[playerid][20] = CreatePlayerTextDraw(playerid, 276.566894, 273.987854, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][20], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][20], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][20], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][20], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][20], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][20], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][20], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][20], 1318);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][20], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][20], 0.000000, 0.000000, 90.000000, 1.000000);

		login_gui[playerid][21] = CreatePlayerTextDraw(playerid, 277.966979, 274.387878, "");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][21], 46.000000, -71.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][21], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][21], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][21], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][21], -256);
		PlayerTextDrawFont(playerid, login_gui[playerid][21], 5);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][21], 0);
		PlayerTextDrawSetPreviewModel(playerid, login_gui[playerid][21], 1318);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][21], 0xFFFFFF00);
		PlayerTextDrawSetPreviewRot(playerid, login_gui[playerid][21], 0.000000, 0.000000, 90.000000, 1.000000);

		login_gui[playerid][22] = CreatePlayerTextDraw(playerid, 281.733001, 231.432312, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][22], 35.000000, 38.000000);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][22], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][22], 219685375);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][22], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][22], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][22], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][22], 0);

		login_gui[playerid][23] = CreatePlayerTextDraw(playerid, 288.166229, 231.143478, "Unesite_Vasu_lozinku:");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][23], 0.081666, 0.496593);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][23], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][23], -1061109505);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][23], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][23], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][23], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][23], 1);

		login_gui[playerid][24] = CreatePlayerTextDraw(playerid, 347.833038, 217.869445, "I_N_S_E_R_T__P_A_S_S_W_O_R_D");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][24], 0.119333, 0.608593);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][24], 2);
		PlayerTextDrawColor(playerid, login_gui[playerid][24], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][24], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][24], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][24], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][24], 1);
		PlayerTextDrawSetSelectable(playerid, login_gui[playerid][24], true);

		login_gui[playerid][25] = CreatePlayerTextDraw(playerid, 297.199371, 212.306579, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][25], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][25], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][25], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][25], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][25], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][25], 0);

		login_gui[playerid][26] = CreatePlayerTextDraw(playerid, 349.702575, 231.307739, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, login_gui[playerid][26], 50.000000, -0.319999);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][26], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][26], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][26], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][26], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][26], 4);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][26], 0);

		login_gui[playerid][27] = CreatePlayerTextDraw(playerid, 399.132873, 226.195251, "/");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][27], 0.155999, 0.670815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][27], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][27], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][27], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][27], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][27], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][27], 1);

		login_gui[playerid][28] = CreatePlayerTextDraw(playerid, 400.532897, 222.887985, "/");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][28], 0.155999, 0.670815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][28], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][28], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][28], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][28], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][28], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][28], 1);

		login_gui[playerid][29] = CreatePlayerTextDraw(playerid, 348.532806, 207.154617, ".......");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][29], 0.155999, 0.670815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][29], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][29], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][29], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][29], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][29], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][29], 1);

		login_gui[playerid][30] = CreatePlayerTextDraw(playerid, 339.132812, 226.336074, ".......");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][30], 0.155999, 0.670815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][30], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][30], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][30], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][30], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][30], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][30], 1);

		login_gui[playerid][31] = CreatePlayerTextDraw(playerid, 402.432800, 218.554595, ".");
		PlayerTextDrawLetterSize(playerid, login_gui[playerid][31], 0.155999, 0.670815);
		PlayerTextDrawAlignment(playerid, login_gui[playerid][31], 1);
		PlayerTextDrawColor(playerid, login_gui[playerid][31], -1);
		PlayerTextDrawSetShadow(playerid, login_gui[playerid][31], 0);
		PlayerTextDrawBackgroundColor(playerid, login_gui[playerid][31], 255);
		PlayerTextDrawFont(playerid, login_gui[playerid][31], 2);
		PlayerTextDrawSetProportional(playerid, login_gui[playerid][31], 1);
	}
	else {
		for (new i; i < 32; i++) {
			PlayerTextDrawDestroy(playerid, login_gui[playerid][i]);
			login_gui[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}
	return true;
}
ShowLoginTD(playerid, bool:show) {

	if (show) {
		for (new i; i < 32; i++)
			PlayerTextDrawShow(playerid, login_gui[playerid][i]);
	}
	else {
		for (new i; i < 32; i++) {
			PlayerTextDrawHide(playerid, login_gui[playerid][i]);
			login_gui[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}
	return true;
}
ShowRegisterTD(playerid, bool:show) {

	if (show) {
		for (new i; i < 140; i++)
			PlayerTextDrawShow(playerid, register_gui[playerid][i]);
		for (new i = 102; i < 119; i++) 
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);	
	}
	else {
		for (new i; i < 140; i++) {
			PlayerTextDrawHide(playerid, register_gui[playerid][i]);
			register_gui[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}
	return true;
}
SetLoginPasswordTD(playerid, bool:ok) 
{
    PlayerTextDrawSetString(playerid, login_gui[playerid][24], "xxx");

    // Promena boje pozadine
    if (ok)
        PlayerTextDrawColor(playerid, login_gui[playerid][24], TD_COLOR_VALID);
    else
        PlayerTextDrawColor(playerid, login_gui[playerid][24], TD_COLOR_INVALID);

    PlayerTextDrawShow(playerid, login_gui[playerid][24]);
    return 1;
}