#include <YSI_Coding\y_hooks>
new PlayerText:rent_contract_PTD[MAX_PLAYERS][33];
static
	playerRentArrID[MAX_PLAYERS],
	playerRentVehID[MAX_PLAYERS],
	playerRentDate[MAX_PLAYERS],
	gRentSphere[6]
;
static
	bool:ShowedTextdraws[MAX_PLAYERS]
;
static
	IzabraoMinute[MAX_PLAYERS],
	PlayerText:ChooseVehTDs[MAX_PLAYERS][6],
	SmallCooldown[MAX_PLAYERS],
	RentedIn[MAX_PLAYERS],
	NaVozilu[MAX_PLAYERS]
;
enum E_PARKING_POSITIONS {
	Float:g_ParkingX,
	Float:g_ParkingY,
	Float:g_ParkingZ,
	Float:g_ParkingA
}
static CurrentRentVehModel[MAX_PLAYERS];

new
	RentedCarPos[][E_PARKING_POSITIONS] = {
	{1795.4114,-1745.6797,13.2740,89.0471 }, //0 spawn rent pozicije
	{1795.4114,-1751.7000,13.2739,88.9850 },
	{1795.4114,-1758.6377,13.2740,89.1847 },
	{1795.4114,-1765.5896,13.2746,89.3317 },
	{1801.6415,-1745.4335,13.2756,268.2151},
	{1801.6415,-1758.4880,13.2740,270.2968},
	{1801.6415,-1765.5868,13.2740,267.7817},//6
	{1444.7465,-1057.2987,23.5561,89.6331}, // banka rent
    {1444.6652,-1062.5770,23.5561,91.3543}, // banka rent
    {1444.6804,-1067.1842,23.5561,90.5401}, // banka rent
    {1444.8416,-1072.5504,23.5561,89.4527}, // banka rent
    {1444.6327,-1078.0923,23.5561,91.2080}, // banka rent
    {1444.6083,-1083.4301,23.5561,91.5572}, // banka rent
    {1451.1899,-1083.5139,23.5561,268.6993}, // banka rent
    {1451.1802,-1078.2792,23.5561,270.1043}, // banka rent
    {1450.9503,-1072.3810,23.5561,269.2453}, // banka rent
    {1451.2466,-1067.0077,23.5561,270.7311}, // banka rent
    {1451.0042,-1062.6041,23.5561,269.6749}, // banka rent
    {1451.7946,-1057.5175,23.5561,269.7958}, // banka rent
	{1959.2450,-1486.5006,13.2921,359.781}, // 19 SKATE PARK rent pozicije
	{1962.0325,-1486.5006,13.2924,359.256},
	{1964.9237,-1486.5006,13.2924,359.062},
	{1967.6682,-1486.5006,13.2927,0.06630},
	{1973.3795,-1474.0359,13.2925,89.1354},
	{1973.3694,-1477.7164,13.2921,89.0697},
	{1973.3960,-1482.5189,13.2918,89.4510},
	{1098.6698,-1760.8491,13.0779,89.9309}, // 26 auto skola rent pozicije
	{1078.7858,-1760.8292,13.1052,89.9567},
	{1062.6196,-1769.7524,13.0941,270.633},
	{1098.7621,-1769.7573,13.0744,90.0889},
	{1078.1049,-1775.6460,13.0714,89.3950},
	{1077.5092,-1766.7952,13.0915,270.077},
	{1098.3971,-1766.7649,13.0762,270.095},
	{1062.4521,-1760.8323,13.1311,269.228},
	{1062.5391,-1740.2828,13.1982,270.264},
	{1062.4354,-1746.0676,13.1845,269.616},
	{1454.9935,-1747.2642,13.5673,182.6647}, // 36 opstina
	{1455.5291,-1740.7289,13.3991,179.5467},
	{1460.0040,-1741.0037,13.3988,179.7392},
	{1464.3091,-1740.6671,13.3990,180.6686},
	{1468.6299,-1740.8661,13.3989,179.2047},
	{1473.0660,-1740.9196,13.3988,179.4230},
	{1477.3535,-1740.8586,13.3988,180.2985},
	{1481.8522,-1741.0298,13.3989,180.5762},
	{1486.2140,-1740.6687,13.3990,179.1109},
	{1490.7579,-1740.8599,13.3990,178.2023},
	{1494.8743,-1740.8441,13.3990,179.9247} //46
};

hook OnPlayerConnect(playerid) {

	NaVozilu[playerid] = 2;
	IzabraoMinute[playerid] = 0;
	SmallCooldown[playerid] = 0;
	RentedIn[playerid] = 0;
	playerRentArrID[playerid] = -1;
	playerRentVehID[playerid] = INVALID_VEHICLE_ID;
	ShowedTextdraws[playerid] = false;

	for(new i = 0; i < 6; i++)
		ChooseVehTDs[playerid][i] = INVALID_PLAYER_TEXT_DRAW;

	rent_contract_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 251.2499, 122.8517, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][0], 139.0000, 217.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][0], 0);

	rent_contract_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.7834, 146.4814, "CAR_RENTAL_AGREEMENT");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][1], 0.1408, 0.8688);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][1], 437918242);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][1], 1);

	rent_contract_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 320.5667, 139.9071, "]");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][2], 0.1229, 0.5681);
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][2], 0.0000, 7.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][2], 2);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][2], 437918463);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][2], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][2], 1);

	rent_contract_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 296.8168, 151.4557, "/");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][3], -0.2658, 0.6200);
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][3], 0.0000, 7.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][3], 2);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][3], 437918463);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][3], 0);

	rent_contract_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 298.4333, 156.1370, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][4], 57.0000, 0.3599);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][4], 255);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][4], 0);

	rent_contract_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 320.9000, 135.9589, "]");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][5], 0.7404, 3.2333);
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][5], 0.0000, 232.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][5], 2);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][5], 437918225);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][5], 0);

	rent_contract_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 300.8334, 147.7407, "");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][6], 43.0000, 56.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][6], -1);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][6], 5);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][6], 561);
	PlayerTextDrawSetPreviewRot(playerid, rent_contract_PTD[playerid][6], 0.0000, 0.0000, 90.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, rent_contract_PTD[playerid][6], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][6], 0x00000000);

	rent_contract_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 280.0002, 139.4443, "");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][7], 87.0000, 86.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][7], -239);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][7], 5);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][7], 561);
	PlayerTextDrawSetPreviewRot(playerid, rent_contract_PTD[playerid][7], 0.0000, 0.0000, 90.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, rent_contract_PTD[playerid][7], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][7], 0x00000000);

	rent_contract_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 362.3332, 198.0040, "Vrijeme_iznajmljivanja");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][8], 0.1274, 0.7133);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][8], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][8], 437918448);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][8], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][8], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][8], 1);

	rent_contract_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 362.1002, 204.6893, "100000000");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][9], 0.1274, 0.7133);
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][9], 50.0000, 50.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][9], 3);	
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][9], 437918361);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][9], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][9], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][9], 1);	
	
	rent_contract_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 368.8837, 194.8074, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][10], 0.4400, 121.9699);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][10], 437918463);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][10], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][10], 0);

	rent_contract_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 361.9499, 215.9050, "cijena_iznajmljivanja");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][11], 0.1274, 0.7133);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][11], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][11], 437918448);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][11], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][11], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][11], 1);

	rent_contract_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 362.1002, 222.5904, "Izaberite prvo vreme");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][12], 0.1274, 0.7133);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][12], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][12], 437918361);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][12], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][12], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][12], 1);

	rent_contract_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 362.6835, 259.4054, "d_o_d_a_t_n_e__i_n_f_o_r_m_a_c_i_j_e");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][13], 0.1241, 0.5629);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][13], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][13], 437918361);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][13], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][13], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][13], 1);

	rent_contract_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 361.4336, 273.9240, "U_slucaju_prekoracenja_dogovorenog_vremena~n~dobiti_cete_novcane_penale_stoga_Vas_molimo~n~da_pazljivo_ispunite_ovaj_formular!");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][14], 0.1204, 0.5785);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][14], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][14], 437918457);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][14], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][14], 0);

	rent_contract_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 361.4336, 294.6253, "U_slucaju_ostecenja_vozila_koje_pripada~n~firmi_ciji_formular_ispunite,_biti_cete_kaznjeni~n~novcanim_penalima!");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][15], 0.1204, 0.5785);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][15], 3);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][15], 437918457);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][15], 437918242);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][15], 0);

	rent_contract_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 366.6666, 202.2259, "-");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][16], 0.3658, 0.6303);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][16], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][16], 437918457);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][16], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][16], 0);
 
	rent_contract_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 366.6666, 220.7270, "-");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][17], 0.3658, 0.6303);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][17], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][17], 437918457);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][17], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][17], 0);

	rent_contract_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 374.7001, 255.7869, "!");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][18], 0.2500, 1.1385);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][18], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][18], 437918457);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][18], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][18], 0);

	rent_contract_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 367.2501, 182.5236, "?");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][19], 0.1820, 1.3822);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][19], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][19], 437918463);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][19], 437918361);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][19], 2);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][19], 0);

	rent_contract_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 322.0667, 235.9851, "~y~Prihvati");
	PlayerTextDrawLetterSize(playerid, rent_contract_PTD[playerid][20], 0.2737, 1.0400);
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][20], 40.0000, 40.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][20], 2);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][20], -1);
	PlayerTextDrawSetOutline(playerid, rent_contract_PTD[playerid][20], 1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][20], 437918310);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][20], 3);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][20], 0);
	PlayerTextDrawSetSelectable(playerid, rent_contract_PTD[playerid][20], true);

	rent_contract_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 256.2501, 173.6666, "");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][21], 43.0000, 56.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][21], -1);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][21], 5);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][21], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][21], 0);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][21], 561);
	PlayerTextDrawSetPreviewRot(playerid, rent_contract_PTD[playerid][21], 0.0000, 0.0000, 180.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, rent_contract_PTD[playerid][21], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][21], 0x00000000);

	rent_contract_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 259.5834, 209.3631, "");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][22], 37.0000, 48.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][22], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][22], -1);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][22], 5);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][22], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][22], 0);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][22], 561);
	PlayerTextDrawSetPreviewRot(playerid, rent_contract_PTD[playerid][22], -90.0000, 0.0000, 180.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, rent_contract_PTD[playerid][22], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][22], 0x00000000);

	rent_contract_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 257.1331, 128.4925, "vehicle:plateback3");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][23], 24.0000, 14.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][23], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][23], -1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][23], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][23], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][23], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][23], 0);

	rent_contract_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 251.0667, 121.6703, "LD_CHAT:dpad_lr");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][24], 88.0000, 219.7201);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][24], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][24], 33);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][24], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][24], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][24], 0);

	rent_contract_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 389.7333, 122.2332, "LD_CHAT:dpad_lr");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][25], -82.0000, 217.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][25], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][25], 33);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][25], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][25], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][25], 0);

	rent_contract_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 280.7500, 121.2962, "LD_OTB2:butnA");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][26], 77.0000, -6.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][26], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][26], -1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][26], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][26], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][26], 0);

	rent_contract_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 246.2499, 118.0222, "LD_OTB2:butnC");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][27], 148.0000, 356.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][27], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][27], 32);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][27], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][27], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][27], 0);

	rent_contract_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 246.2499, 118.0222, "LD_OTB2:butnC");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][28], 148.0000, 356.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][28], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][28], 32);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][28], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][28], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][28], 0);

	rent_contract_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 251.2500, 123.8888, "particle:particleskid");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][29], 139.0000, -3.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][29], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][29], -1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][29], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][29], 0);

	rent_contract_PTD[playerid][30] = CreatePlayerTextDraw(playerid, 251.1334, 342.1851, "particle:particleskid");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][30], 139.0000, -3.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][30], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][30], -1);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][30], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][30], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][30], 0);

	rent_contract_PTD[playerid][31] = CreatePlayerTextDraw(playerid, 359.0499, 117.1481, "vehicle:vehiclescratch64");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][31], 31.0000, 34.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][31], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][31], -176);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][31], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][31], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][31], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][31], 0);

	rent_contract_PTD[playerid][32] = CreatePlayerTextDraw(playerid, 285.4333, 118.6407, "vehicle:vehiclescratch64");
	PlayerTextDrawTextSize(playerid, rent_contract_PTD[playerid][32], -34.0000, 43.0000);
	PlayerTextDrawAlignment(playerid, rent_contract_PTD[playerid][32], 1);
	PlayerTextDrawColor(playerid, rent_contract_PTD[playerid][32], -176);
	PlayerTextDrawBackgroundColor(playerid, rent_contract_PTD[playerid][32], 255);
	PlayerTextDrawFont(playerid, rent_contract_PTD[playerid][32], 4);
	PlayerTextDrawSetProportional(playerid, rent_contract_PTD[playerid][32], 0);
	PlayerTextDrawSetShadow(playerid, rent_contract_PTD[playerid][32], 0);
	return true;
}
stock ChooseVeh(playerid, bool:showtds)
{
	if(showtds)
	{
		ChooseVehTDs[playerid][0] = CreatePlayerTextDraw(playerid, 261.666748, 153.444458, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][0], 112.000000, 123.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][0], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][0], 153);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][0], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][0], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][0], 0);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][0], 2730);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][0], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);

		ChooseVehTDs[playerid][1] = CreatePlayerTextDraw(playerid, 207.500061, 176.777832, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][1], 86.000000, 82.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][1], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][1], 153);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][1], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][1], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][1], 0);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][1], 2730);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][1], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][1], 0.000000, 0.000000, -40.000000, 1.000000);

		ChooseVehTDs[playerid][2] = CreatePlayerTextDraw(playerid, 341.583831, 176.777816, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][2], 86.000000, 82.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][2], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][2], 153);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][2], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][2], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][2], 0);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][2], 2730);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][2], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][2], 0.000000, 0.000000, 40.000000, 1.000000);

		ChooseVehTDs[playerid][3] = CreatePlayerTextDraw(playerid, 232.366683, 188.803756, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][3], 50.000000, 57.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][3], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][3], -1);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][3], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][3], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][3], 0);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][3], 401);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][3], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][3], 0.000000, 0.000000, -20.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, ChooseVehTDs[playerid][3], 1, 1);

		ChooseVehTDs[playerid][4] = CreatePlayerTextDraw(playerid, 274.449981, 167.025939, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][4], 85.000000, 96.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][4], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][4], -1);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][4], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][4], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][4], 0);
		PlayerTextDrawSetSelectable(playerid, ChooseVehTDs[playerid][4], false);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][4], 436);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][4], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][4], 0.000000, 0.000000, 0.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, ChooseVehTDs[playerid][4], 1, 1);

		ChooseVehTDs[playerid][5] = CreatePlayerTextDraw(playerid, 352.833435, 188.803802, "");
		PlayerTextDrawTextSize(playerid, ChooseVehTDs[playerid][5], 50.000000, 57.000000);
		PlayerTextDrawAlignment(playerid, ChooseVehTDs[playerid][5], 1);
		PlayerTextDrawColor(playerid, ChooseVehTDs[playerid][5], -1);
		PlayerTextDrawSetShadow(playerid, ChooseVehTDs[playerid][5], 0);
		PlayerTextDrawFont(playerid, ChooseVehTDs[playerid][5], 5);
		PlayerTextDrawSetProportional(playerid, ChooseVehTDs[playerid][5], 0);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][5], 533);
		PlayerTextDrawBackgroundColor(playerid, ChooseVehTDs[playerid][5], 0x00000000);
		PlayerTextDrawSetPreviewRot(playerid, ChooseVehTDs[playerid][5], 0.000000, 0.000000, 20.000000, 1.000000);
		PlayerTextDrawSetPreviewVehCol(playerid, ChooseVehTDs[playerid][5], 1, 1);

		for(new i = 0; i < 6; i++)
			PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][i]);
	}
	else
	{
		for(new i = 0; i < 6; i++)
		{
			PlayerTextDrawDestroy(playerid, ChooseVehTDs[playerid][i]);
			ChooseVehTDs[playerid][i] = INVALID_PLAYER_TEXT_DRAW;
		}
	}
	return 1;
}
enum E_RENT_VEH {
	r_vehid,
	r_price
};
static rentVehArray[][E_RENT_VEH] = {

	{400, 6},
	{401, 8},
	{436, 10},
	{533, 14},
	{579, 18}
};

hook OnGameModeInit() {

	gRentSphere[0] = CreateDynamicSphere(1785.4075, -1752.9414, 13.5482, 3.0, -1, -1, -1);
	gRentSphere[1] = CreateDynamicSphere(1220.0625,-1353.6696,13.2562, 3.0, -1, -1, -1);
	gRentSphere[2] = CreateDynamicSphere(1463.1378,-1051.2451,23.3968, 3.0, -1, -1, -1);
	gRentSphere[3] = CreateDynamicSphere(1957.6300,-1473.9803,13.5869, 3.0, -1, -1, -1);
	gRentSphere[4] = CreateDynamicSphere(1086.1724,-1747.4063,13.4227, 3.0, -1, -1, -1);
	gRentSphere[5] = CreateDynamicSphere(1454.9935,-1747.2642,13.5673, 3.0, -1, -1, -1);
	CreateDynamicPickup(19198, 1, 1463.1378,-1051.2451,24.3968, -1, -1, -1, 35.0);
	CreateDynamicPickup(19198, 1, 1785.4075,-1752.9414,13.5482, -1, -1, -1, 35.0);
	CreateDynamicPickup(19198, 1, 1957.6300,-1473.9803,13.5869, -1, -1, -1, 35.0);
	CreateDynamicPickup(19198, 1, 1086.1724,-1747.4063,13.4227, -1, -1, -1, 35.0);
	CreateDynamicPickup(19198, 1, 1454.9935,-1747.2642,13.5673, -1, -1, -1, 35.0);
	CreateDynamic3DTextLabel("[ RENT A CAR ]\n{FFFFFF}Iznajmite rent vozilo.", 0xDCE332AA, 1463.1378,-1051.2451,24.3968, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 35.0, -1,  0);
	CreateDynamic3DTextLabel("[ RENT A CAR ]\n{FFFFFF}Iznajmite rent vozilo.", 0xDCE332AA, 1785.4075,-1752.9414,13.5482, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 35.0, -1,  0);
	CreateDynamic3DTextLabel("[ RENT A CAR ]\n{FFFFFF}Iznajmite rent vozilo.", 0xDCE332AA, 1957.6300,-1473.9803,13.5869, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 35.0, -1,  0);
	CreateDynamic3DTextLabel("[ RENT A CAR ]\n{FFFFFF}Iznajmite rent vozilo.", 0xDCE332AA, 1086.1724,-1747.4063,13.4227, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 35.0, -1,  0);
	CreateDynamic3DTextLabel("[ RENT A CAR ]\n{FFFFFF}Iznajmite rent vozilo.", 0xDCE332AA, 1454.9935,-1747.2642,13.5673, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 35.0, -1,  0);
	return true;
}

ShowPlayerRentContract(playerid, arrid) {

	new
		slotid
	;
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][6],  arrid);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][7],  arrid);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][21],  arrid);
	PlayerTextDrawSetPreviewModel(playerid, rent_contract_PTD[playerid][22],  arrid);
	for(new i = 0; i < 5; i++)
	{
		if(arrid == rentVehArray[i][r_vehid])
		{
			slotid = i;
			break;
		}
	}
	new string[32];
	format(string, sizeof(string), "%i min", IzabraoMinute[playerid]);
	PlayerTextDrawSetString(playerid, rent_contract_PTD[playerid][9], string);
	format(string, sizeof(string), "$%i (po minuti)", rentVehArray[slotid][r_price] * IzabraoMinute[playerid]);
	PlayerTextDrawSetString(playerid, rent_contract_PTD[playerid][12], string);
	for (new i = 0; i < 33; i++) {
		PlayerTextDrawShow(playerid,  rent_contract_PTD[playerid][i]);
	}
	InfoMsg(playerid, "Da prihvatite kliknite na 'Prihvati', a da odustanete 'ESC'.");
	playerRentArrID[playerid] = slotid;
	ShowedTextdraws[playerid] = true;
	SelectTextDraw(playerid, 0xFFFFFFFF);
	return true;
}

hook OnPlayerUpdate(playerid)
{
	new
		Keys,
		ud,
		lr
	;

    GetPlayerKeys(playerid,Keys,ud,lr);
 
    if(lr == KEY_LEFT && ChooseVehTDs[playerid][0] != INVALID_PLAYER_TEXT_DRAW && SmallCooldown[playerid] <= gettime()) 
	{
		new
			currentmodelid = rentVehArray[NaVozilu[playerid]][r_vehid],
			slotid = NaVozilu[playerid]
		;

		/*for(new i = 0; i < 5; i++)
		{if(currentmodelid == rentVehArray[i][r_vehid])
			{
				slotid = i;
				break;
			}
		}*/

		if(currentmodelid == 579)
			return ErrorMsg(playerid, "Nema vise izbora ulijevo.");

		NaVozilu[playerid] += 1;

		playerRentArrID[playerid] = slotid+1;

		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][3],  rentVehArray[slotid][r_vehid]);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][4],  rentVehArray[slotid+1][r_vehid]); // glavni
		if(currentmodelid == 533)
			PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][5],  -1);
		else
			PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][5],  rentVehArray[slotid+2][r_vehid]);

		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][3]);
		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][4]);
		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][5]);

		SmallCooldown[playerid] = gettime()+1;
		CurrentRentVehModel[playerid] = rentVehArray[slotid+1][r_vehid];
		return 1;
	}
    else if(lr == KEY_RIGHT && ChooseVehTDs[playerid][0] != INVALID_PLAYER_TEXT_DRAW && SmallCooldown[playerid] <= gettime()) 
	{
		new
			currentmodelid = rentVehArray[NaVozilu[playerid]][r_vehid],
			slotid = NaVozilu[playerid]
		;

		/*for(new i = 0; i < 5; i++)
		{
			if(currentmodelid == rentVehArray[i][r_vehid])
			{
				slotid = i;
				break;
			}
		}*/
		
		if(currentmodelid == 400)
			return ErrorMsg(playerid, "Nema vise izbora udesno.");

		NaVozilu[playerid] -= 1;

		playerRentArrID[playerid] = slotid+1;

		if(currentmodelid == 401)
			PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][3], -1);
		else
			PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][3],  rentVehArray[slotid-2][r_vehid]);
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][4],  rentVehArray[slotid-1][r_vehid]); // glavni
		PlayerTextDrawSetPreviewModel(playerid, ChooseVehTDs[playerid][5],  rentVehArray[slotid][r_vehid]);

		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][3]);
		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][4]);
		PlayerTextDrawShow(playerid, ChooseVehTDs[playerid][5]);

		SmallCooldown[playerid] = gettime()+1;
		CurrentRentVehModel[playerid] =  rentVehArray[slotid-1][r_vehid];
		return 1;
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_SECONDARY_ATTACK)
	{
		if(ChooseVehTDs[playerid][4] != INVALID_PLAYER_TEXT_DRAW)
		{
			TogglePlayerControllable(playerid, true);
			ShowPlayerRentContract(playerid, CurrentRentVehModel[playerid]);
			ChooseVeh(playerid, false);
			ChooseVehTDs[playerid][4] = INVALID_PLAYER_TEXT_DRAW;
			return 1;
		}
	}
	return Y_HOOKS_CONTINUE_RETURN_1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
	if (playerRentVehID[playerid] != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(playerRentVehID[playerid]);
	}
	return true;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {

	if (playertextid == rent_contract_PTD[playerid][20]) {
		if (playerRentArrID[playerid] != -1) {
			
			new
				randline,
				foundposition
			;

			if(IsPlayerInDynamicArea(playerid, gRentSphere[0]))
			{
				randline = randomEx(0, 6);
				RentedIn[playerid] = 1;
			}
			else if(IsPlayerInDynamicArea(playerid, gRentSphere[1]) || IsPlayerInDynamicArea(playerid, gRentSphere[2]))
			{
				randline = randomEx(7, 17);
				RentedIn[playerid] = 2;
			}
			else if(IsPlayerInDynamicArea(playerid, gRentSphere[3]))
			{
				RentedIn[playerid] = 3;
				randline = randomEx(19, 24);
			}
			else if(IsPlayerInDynamicArea(playerid, gRentSphere[4]))
			{
				RentedIn[playerid] = 4;
				randline = randomEx(26, 34);
			}
			else if(IsPlayerInDynamicArea(playerid, gRentSphere[5]))
			{
				RentedIn[playerid] = 5;
				randline = randomEx(34, sizeof(RentedCarPos)-1);
			}
			else 
			{
				if (ShowedTextdraws[playerid] ) {
					CancelSelectTextDraw(playerid);
					for (new i = 0; i < 33; i++) {
						PlayerTextDrawHide(playerid,  rent_contract_PTD[playerid][i]);
					}
					ShowedTextdraws[playerid] = false;
				}
				ChooseVeh(playerid, false);
				return SendClientMessage(playerid, 0xD1D1D1FF, "Portir: {FFFFFF}Udaljili ste se od parking kucice, priblizite se ponovo i potpisite papire.");
			}
			while(foundposition != 0)
			{
				foreach(new i : Player)
				{
					foreach(new j : Vehicle)
					{
						if(IsPlayerInRangeOfPoint(i, 2.0, RentedCarPos[randline][g_ParkingX], RentedCarPos[randline][g_ParkingY], RentedCarPos[randline][g_ParkingZ]) && IsPlayerInAnyVehicle(playerid) || IsVehicleInRangeOfPoint(j, 2.0, RentedCarPos[randline][g_ParkingX], RentedCarPos[randline][g_ParkingY], RentedCarPos[randline][g_ParkingZ]))
						{
							if(IsPlayerInDynamicArea(playerid, gRentSphere[0])) //SPAWN
							{
								randline = randomEx(0, 6);	
							}
							else if(IsPlayerInDynamicArea(playerid, gRentSphere[1]) || IsPlayerInDynamicArea(playerid, gRentSphere[2])) //BOLNICA
							{
								randline = randomEx(7, 17);
							}
							else if(IsPlayerInDynamicArea(playerid, gRentSphere[3])) //SKATE PARK
							{
								randline = randomEx(19, 24);
							}
							else if(IsPlayerInDynamicArea(playerid, gRentSphere[4])) //AUTO SKOLA
							{
								randline = randomEx(26, 34);
							}
							else if(IsPlayerInDynamicArea(playerid, gRentSphere[5])) 
							{
								randline = randomEx(34, sizeof(RentedCarPos)-1);
							}
						}
						else
						{
							foundposition = 1;
							break;
						}
					}
				}
			}
			//GetPlayerPos(playerid, x, y, z);
			if (IzabraoMinute[playerid] < 2 || IzabraoMinute[playerid] > 60) return ErrorMsg(playerid, "Vreme iznajmljivanja ne moze biti manja od 2 minuta ili veca od 60 minuta!");
			if (PI[playerid][p_novac] < rentVehArray[playerRentArrID[playerid]][r_price] * IzabraoMinute[playerid]) return ErrorMsg(playerid, "Nemate dovoljno novca!");
			if (playerRentVehID[playerid] != INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Vec posedujete rentano vozilo vratite ga nazad /unrentvozilo");
			PlayerMoneySub(playerid, rentVehArray[playerRentArrID[playerid]][r_price] * IzabraoMinute[playerid] );
			playerRentVehID[playerid] = CreateVehicle(rentVehArray[playerRentArrID[playerid]][r_vehid], RentedCarPos[randline][g_ParkingX], RentedCarPos[randline][g_ParkingY], RentedCarPos[randline][g_ParkingZ], RentedCarPos[randline][g_ParkingA], 1, 1, 99999, false);
			//768
			InfoMsg(playerid, "Rentali ste vozilo, da ga vratite /unrentvozilo");
			InfoMsg(playerid, "Da ga vratite bez polaska nazad do firme /forceunrent (-$700)");
			InfoMsg(playerid, "Ukoliko ste izgubili rent vozilo koristite /locaterent");
			SetTimerEx("RentProvera", 60000, false, "i", playerid);
			playerRentDate[playerid] = gettime();
			PutPlayerInVehicle(playerid, playerRentVehID[playerid], 0);
			if (ShowedTextdraws[playerid] ) {
				CancelSelectTextDraw(playerid);
				for (new i = 0; i < 33; i++) {
					PlayerTextDrawHide(playerid,  rent_contract_PTD[playerid][i]);
				}
				ShowedTextdraws[playerid] = false;
			}
			ChooseVeh(playerid, false);

			// ima li task?
			if(!HasPlayerFinishedTask(playerid, 3))
				PlayerFinishedTask(playerid, 3);
		}
	}	
	return true;
}

Dialog:rentminutaza(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;
	if (isnull(inputtext)) return DialogReopen(playerid);
	if (strval(inputtext) > 60 || strval(inputtext) < 2) return DialogReopen(playerid);
	IzabraoMinute[playerid] = strval(inputtext);
	ChooseVeh(playerid, true);
	NaVozilu[playerid] = 2;
	InfoMsg(playerid, "Koristite strelice '<' i '>' da listate i stisnite 'ENTER' kada odaberete zeljeno vozilo.");
	TogglePlayerControllable(playerid, false);
	return true;
}

forward RentProvera(playerid);
public RentProvera(playerid) {
	if (playerRentVehID[playerid] != INVALID_VEHICLE_ID)
	{
		if (gettime() - playerRentDate[playerid] > IzabraoMinute[playerid]*60)
		{
			new
				modelid = GetVehicleModel(playerRentVehID[playerid]),
				amount,
				str[5]
			;
			
			switch(modelid)
			{
				case 400:
				{
					amount = 6;
					PlayerMoneySub(playerid, 12);
				} //, 6
				case 401:
				{
					amount = 8;
					PlayerMoneySub(playerid, 16);
				} //, 8
				case 436:
				{
					amount = 10;
					PlayerMoneySub(playerid, 20);
				} //, 10
				case 533:
				{
					amount = 14;
					PlayerMoneySub(playerid, 26);
				} //, 14
				case 579:
				{
					amount = 18;
					PlayerMoneySub(playerid, 36);
				} //, 18
				default: ErrorMsg(playerid, "[rent.pwn] Desila se neocekivana greska, prijavi skripteru!!");
			}
			//PlayerMoneySub(playerid, 15);
			SendClientMessageF(playerid, CRVENA, "Niste ispostovali ugovor o rentu, s racuna Vam je skinuto $%i. Da ga vratite koristite /unrentvozilo", amount*2);
			format(str, sizeof str, "-$%i", amount*2);
			GameTextForPlayer(playerid, str, 1500, 3);
		}
		SetTimerEx("RentProvera", 60000, false, "i", playerid);
		return true;
	}
	return true;
}

CMD:locaterent(playerid, const arg[])
{
	if (playerRentVehID[playerid] == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Vi nemate rentano vozilo");
	if (GetPlayerVehicleID(playerid) == playerRentVehID[playerid]) return ErrorMsg(playerid, "Vec ste u rentanom vozilu!");
	new
		Float:x,
		Float:y,
		Float:z
	;

	GetVehiclePos(playerRentVehID[playerid], x, y, z);

	SetGPSLocation(playerid, x, y, z, "Rent vozilo");
	return 1;
}

CMD:forceunrent(playerid, const arg[])
{
	if (playerRentVehID[playerid] == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Vi nemate rentano vozilo");
	new Float:health;
	GetVehicleHealth(playerRentVehID[playerid], health);
	if (health < 800) {
		InfoMsg(playerid, "Ostetili ste vozilo i novcano ste nadoknadili stetu od 500$");
		PlayerMoneySub(playerid, 500);
	}
	PlayerMoneySub(playerid, 700);
	DestroyVehicle(playerRentVehID[playerid]);
	RentedIn[playerid] = 0;
	playerRentArrID[playerid] = -1;
	playerRentVehID[playerid] = INVALID_VEHICLE_ID;
	IzabraoMinute[playerid] = -1;
	InfoMsg(playerid, "Unrentali ste vozilo a da ga niste vratili nazad u firmu, oduzeto vam je jos $700!");
	DisablePlayerCheckpoint(playerid);
	return 1;
}

CMD:unrentvozilo(playerid, const arg[]) {
	if (playerRentVehID[playerid] == INVALID_VEHICLE_ID) return ErrorMsg(playerid, "Vi nemate rentano vozilo");
	if (GetPlayerVehicleID(playerid) != playerRentVehID[playerid]) return ErrorMsg(playerid, "Niste u rentanom vozilu!");
	if(RentedIn[playerid] == 1)
		SetPlayerCheckpoint(playerid, 1785.4075, -1752.9414, 13.5482, 5.0);
	else if(RentedIn[playerid] == 2)
		SetPlayerCheckpoint(playerid, 1463.1378,-1051.2451,23.3968, 5.0);
	else if(RentedIn[playerid] == 3)
		SetPlayerCheckpoint(playerid, 1957.6300,-1473.9803,13.5869, 5.0);
	else if(RentedIn[playerid] == 4)
		SetPlayerCheckpoint(playerid, 1086.1724,-1747.4063,13.4227, 5.0);
	else if(RentedIn[playerid] == 5)
		SetPlayerCheckpoint(playerid, 1454.9935,-1747.2642,13.5673, 5.0);
	InfoMsg(playerid, "Check point vam je postavljen, vratite vozilo!");
	return true;
}

hook OnPlayerEnterCheckpoint(playerid) {
	if (IsPlayerInRangeOfPoint(playerid, 5.0, 1785.4075, -1752.9414, 13.5482) || IsPlayerInRangeOfPoint(playerid, 5.0, 1463.1378,-1051.2451,23.3968) || IsPlayerInRangeOfPoint(playerid, 5.0, 1957.6300,-1473.9803,13.5869) || IsPlayerInRangeOfPoint(playerid, 5.0, 1086.1724,-1747.4063,13.4227) || IsPlayerInRangeOfPoint(playerid, 5.0, 1454.9935,-1747.2642,13.5673)) {
		if (GetPlayerVehicleID(playerid) != playerRentVehID[playerid]) return ErrorMsg(playerid, "Niste u rentanom vozilu!");
		new Float:health;
		GetVehicleHealth(GetPlayerVehicleID(playerid), health);
		if (health < 800) {
			InfoMsg(playerid, "Ostetili ste vozilo i novcano ste nadoknadili stetu od 500$");
			PlayerMoneySub(playerid, 500);
		} 
		DestroyVehicle(GetPlayerVehicleID(playerid));
		RentedIn[playerid] = 0;
		playerRentArrID[playerid] = -1;
		playerRentVehID[playerid] = INVALID_VEHICLE_ID;
		IzabraoMinute[playerid] = -1;
		InfoMsg(playerid, "Unrentali ste vozilo!");
		DisablePlayerCheckpoint(playerid);
	}
	return true;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {
	
	if (clickedid == INVALID_TEXT_DRAW) {
		if (ShowedTextdraws[playerid] ) {
			CancelSelectTextDraw(playerid);
			for (new i = 0; i < 33; i++) {
				PlayerTextDrawHide(playerid,  rent_contract_PTD[playerid][i]);
			}
			ShowedTextdraws[playerid] = false;
		}
	}
	return true;
}

hook OnPlayerEnterDynArea(playerid, areaid) {

	if (areaid == gRentSphere[0] || areaid == gRentSphere[1] || areaid == gRentSphere[2] || areaid == gRentSphere[3] || areaid == gRentSphere[4] || areaid == gRentSphere[5]) {
		if (!ShowedTextdraws[playerid] && playerRentVehID[playerid] == INVALID_VEHICLE_ID && !IsPlayerInAnyVehicle(playerid))
			SPD(playerid, "rentminutaza", DIALOG_STYLE_INPUT, "{DCE332}Hertz Car Rental (min 2min - max 60min)", "Postovani, molimo Vas da upisete na koliko Vam je minuta potrebno iznajmljivanje vozila.", "Potvrdi", "Odustani");
	}
	return true;
}