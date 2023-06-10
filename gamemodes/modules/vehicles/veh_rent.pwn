#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum e_vehRentInfo
{
    vehModel,
    vehBoja,
    vehCena,
    vehFirma,
    Float:vehPos[4],
    bool:VEH_RENT_TUNED,
}

enum e_playerRentInfo
{
    vehID,      // ID kreiranog vozila koje je iznajmljeno
    rentID,     // ID rent vozila (indeks iz promenljive rentVehicles)
    expTime,    // Dokle vazi iznajmljeno vozilo
}
new pRentInfo[MAX_PLAYERS][e_playerRentInfo];



// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //

// XYZA koordinate vozila
new rentVehicles[][e_vehRentInfo] = 
{
    // ----- [ Spawn Rent ] -----
    {410, 79, 60, 82,   {1795.4114,-1745.6797,13.2740,89.0471 }, false},
    {410, 79, 60, 82,   {1795.4114,-1751.7000,13.2739,88.9850 }, false},
    {410, 79, 60, 82,   {1795.4114,-1758.6377,13.2740,89.1847 }, false},
    {410, 79, 60, 82,   {1795.4114,-1765.5896,13.2746,89.3317 }, false},
    {410, 79, 60, 82,   {1801.6415,-1745.4335,13.2756,268.2151}, false},
    {410, 79, 60, 82,   {1801.6415,-1758.4880,13.2740,270.2968}, false},
    {410, 79, 60, 82,   {1801.6415,-1765.5868,13.2740,267.7817}, false},
    {410, 79, 60, 82,   {1801.5936,-1751.6818,13.2010,270.4702}, false},

    // ----- [ Old Spawn Rent ] -----
    {462, 79, 60, -1, {1600.3800, -1254.9500, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1253.2000, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1251.4500, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1249.7000, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1247.9500, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1246.2000, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1244.4500, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1242.7000, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1240.9500, 18.0, 90.0000}, false}, //Faggio
    {462, 79, 60, -1, {1600.3800, -1239.2000, 18.0, 90.0000}, false}, //Faggio
    {481, 79, 20, -1, {1593.7100, -1254.4000, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1252.6500, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1250.9000, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1249.1500, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1247.4000, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1245.6500, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1243.9000, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1242.1500, 18.0, 270.0000}, false}, //BMX
    {481, 79, 20, -1, {1593.7100, -1240.4000, 18.0, 270.0000}, false}, //BMX

    // ----- [ Tech Store Rent ] -----
    //{579, -1, 370, -1, {1831.8500, -1403.3000, 13.3111, 180.0000}, false}, //Huntley
    //{579, -1, 370, -1, {1828.3500, -1403.3000, 13.3111, 180.0000}, false}, //Huntley
    //{589, -1, 300, -1, {1824.8500, -1403.3000, 13.3111, 180.0000}, false}, //Club
    //{589, -1, 300, -1, {1821.3500, -1403.3000, 13.3111, 180.0000}, false}, //Club
    //{492, -1, 200, -1, {1817.8500, -1403.3000, 13.3111, 180.0000}, false}, //Greenwood
    //{492, -1, 200, -1, {1814.4500, -1403.3000, 13.3111, 180.0000}, false}, //Greenwood
    //{507, -1, 300, -1, {1824.8500, -1417.6700, 13.3286, 0.0000}, false}, //Elegant
    //{507, -1, 300, -1, {1821.3500, -1417.6700, 13.3286, 0.0000}, false}, //Elegant
    //{565, -1, 250, -1, {1817.8500, -1417.6700, 13.3198, 0.0000}, false}, //Flash
    //{565, -1, 250, -1, {1814.4500, -1417.6700, 13.3111, 0.000},  false}, //Flash

    /* ----- [ Opstina ] -----
    {477, -1, 500, 106, {1462.3937,-1744.0656,13.2608, 270.0}, false}, // ZR-350
    {477, -1, 500, 106, {1462.5752,-1747.2690,13.2608, 270.0}, false}, // ZR-350
    {533, -1, 350, 106, {1462.3396,-1750.5792,13.2608, 270.0}, false}, // Feltzer
    {533, -1, 350, 106, {1462.4028,-1753.7422,13.2609, 270.0}, false}, // Feltzer
    {545, -1, 400, 106, {1462.1201,-1756.8873,13.2608, 270.0}, false}, // Hustler
    {545, -1, 400, 106, {1462.2863,-1760.0334,13.2608, 270.0}, false}, // Hustler
    {560, -1, 400, 106, {1462.3885,-1763.4573,13.2608, 270.0}, false}, // Sultan
    {560, -1, 400, 106, {1493.0546,-1744.1443,13.2608, 90.0}, false}, // Sultan*/

    // ----- [ Aerodrom Spawn (desno) ] -----
    {410, 154, 90, 62, {1697.2864,-2311.7576,13.2839,180.1219}, false}, // Manana
    {410, 154, 90, 62, {1701.3110,-2311.7400,13.2827,179.9886}, false}, // Manana
    {410, 154, 90, 62, {1705.1871,-2311.7607,13.2827,180.1931}, false}, // Manana
    {410, 154, 90, 62, {1709.1190,-2311.7766,13.2845,180.1403}, false}, // Manana
    {410, 154, 90, 62, {1713.1498,-2311.7642,13.2831,179.7759}, false}, // Manana
    {410, 154, 90, 62, {1717.0834,-2311.7898,13.2747,180.3246}, false}, // Manana
    {410, 154, 90, 62, {1721.1125,-2311.7942,13.2652,179.9552}, false}, // Manana
    // Dodatno
    {410, 158, 90, 62, {1560.5012,-2312.2476,13.2004,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.6865,-2308.8577,13.1998,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.4038,-2315.4944,13.2029,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.5869,-2318.8047,13.2019,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.7986,-2322.1008,13.2056,90.0}, false}, // Manana 

        // ----- [ Aerodrom Spawn (levo) ] -----
    {410, 158, 90, 62, {1668.9707,-2311.7397,13.2841,180.0015}, false}, // Manana
    {410, 158, 90, 62, {1665.5946,-2311.7827,13.2844,179.4749}, false}, // Manana
    {410, 158, 90, 62, {1662.1211,-2311.7778,13.2843,179.9665}, false}, // Manana
    {410, 158, 90, 62, {1658.7299,-2311.7388,13.2842,179.9892}, false}, // Manana
    {410, 158, 90, 62, {1655.3738,-2311.7629,13.2845,179.7453}, false}, // Manana
    {410, 158, 90, 62, {1651.8408,-2311.7395,13.2818,180.9116}, false}, // Manana
    {410, 158, 90, 62, {1648.1547,-2311.7668,13.2693,180.0409}, false}, // Manana
    {410, 158, 90, 62, {1644.4039,-2311.7725,13.2543,180.6706}, false}, // Manana
    // Dodatno
    {410, 158, 90, 62, {1560.4950,-2325.3669,13.2006,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.4813,-2328.6531,13.2026,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.5619,-2331.8828,13.2036,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.5557,-2335.2527,13.2003,90.0}, false}, // Manana 
    {410, 158, 90, 62, {1560.3324,-2338.4556,13.1998,90.0}, false}, // Manana 

    // ----- [ Bolnica ] -----
    {462, -1, 90, 83, {1228.2219,-1362.0162,12.9833,88.8605}, false}, // Faggio
    {462, -1, 90, 83, {1227.8539,-1365.9656,12.9833,90.4169}, false}, // Faggio
    {462, -1, 90, 83, {1228.1025,-1370.0039,12.9833,90.2016}, false}, // Faggio
    {462, -1, 90, 83, {1228.0994,-1374.3763,12.9833,89.3192}, false}, // Faggio
    {462, -1, 90, 83, {1234.2606,-1374.4154,12.9833,270.337}, false}, // Faggio
    {462, -1, 90, 83, {1234.2021,-1369.9938,12.9833,269.532}, false}, // Faggio
    {462, -1, 90, 83, {1234.6172,-1365.8673,12.9833,270.095}, false}, // Faggio
    {462, -1, 90, 83, {1234.7826,-1361.9070,12.9833,269.327}, false}, // Faggio
    {462, -1, 90, 83, {1234.4866,-1345.3456,12.9833,270.739}, false}, // Faggio
    {462, -1, 90, 83, {1233.8760,-1340.9963,12.9833,269.306}, false}, // Faggio
    {462, -1, 90, 83, {1234.4628,-1336.9301,12.9833,270.253}, false}, // Faggio
    {462, -1, 90, 83, {1234.6896,-1332.6692,12.9833,269.973}, false}, // Faggio
    {410, -1, 90, 83, {1234.6989,-1314.9598,12.9833,269.508}, false}, // Manana
    {410, -1, 90, 83, {1234.3724,-1310.6743,12.9833,269.216}, false}, // Manana
    {410, -1, 90, 83, {1233.8981,-1306.5563,12.9833,270.623}, false}, // Manana
    {410, -1, 90, 83, {1234.4961,-1302.5864,12.9833,268.481}, false}, // Manana
    {410, -1, 90, 83, {1227.9519,-1302.6001,12.9833,89.8815}, false}, // Manana
    {410, -1, 90, 83, {1228.1993,-1306.6416,12.9833,90.1593}, false}, // Manana
    {410, -1, 90, 83, {1228.0701,-1310.6873,12.9833,89.2428}, false}, // Manana
    {410, -1, 90, 83, {1228.1484,-1315.1394,12.9833,88.4126}, false}, // Manana
    {410, -1, 90, 83, {1227.8606,-1332.6797,12.9833,89.0232}, false}, // Manana
    {410, -1, 90, 83, {1228.1466,-1336.8533,12.9833,88.7008}, false}, // Manana
    {410, -1, 90, 83, {1228.2000,-1340.9950,12.9833,91.2154}, false}, // Manana
    {410, -1, 90, 83, {1228.0751,-1345.3722,12.9833,89.1081}, false}, // Manana

    //{410, -1, 90, 162, {1226.8270,-1332.7983,12.9123,90.0}, false}, // r1
    //{410, -1, 90, 162, {1227.8198,-1336.9164,12.9101,90.0}, false}, // r2
    //{410, -1, 90, 162, {1227.9117,-1340.9581,12.9109,90.0}, false}, // r3
    //{410, -1, 90, 162, {1228.0269,-1345.3945,12.9090,90.0}, false}, // r4
    //{410, -1, 90, 162, {1227.4735,-1362.0819,12.9073,90.0}, false}, // r5
    //{410, -1, 90, 162, {1228.1689,-1314.9446,12.9120,90.0}, false}, // r6
    //{462, -1, 90, 162, {1234.7765,-1332.8030,12.9073,280.0}, false}, // r7
    //{462, -1, 90, 162, {1234.6743,-1336.8352,12.9123,280.0}, false}, // r8
    //{462, -1, 90, 162, {1234.2823,-1340.8948,12.9138,280.0}, false}, // r9
    //{462, -1, 90, 162, {1234.2180,-1345.2617,12.9092,280.0}, false}, // r10
    //{462, -1, 90, 162, {1234.1071,-1361.8508,12.9087,280.0}, false}, // r11
    //{462, -1, 90, 162, {1234.0032,-1315.0371,12.9090,280.0}, false}, // r12

    /*{411, -1, 1000, 162, {1285.7087,-1380.5001,13.2138,0.0}, false}, // Infernus
    {522, -1, 1000, 162, {1239.5551,-1382.8527,13.0544,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4596,-1381.4139,13.0551,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.5277,-1379.8701,13.0547,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.5046,-1378.3164,13.0576,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4987,-1376.8678,13.0552,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4185,-1375.2328,13.0581,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4585,-1373.3458,13.0569,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.5234,-1372.3392,13.0568,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.5608,-1370.7321,13.0572,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4069,-1369.3870,13.0567,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4495,-1367.8945,13.0577,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.4825,-1366.3884,13.0548,270.0}, false}, // NRG-500
    {522, -1, 1000, 162, {1239.5370,-1364.8408,13.0548,270.0}, false}, // NRG-500
    {560, -1, 1000, 162, {1296.1644,-1380.7100,13.1920,0.0}, false}, // Sultan
    {560, -1, 1000, 162, {1301.6366,-1380.7100,13.1920,0.0}, false}, // Sultan
    {560, -1, 1000, 162, {1307.0229,-1380.6550,13.1916,0.0}, false}, // Sultan
    {411, -1, 1000, 162, {1290.9480,-1380.4468,13.2138,0.0}, false}, // Infernus*/


    // -----[ Kod kradje vozila ] -----
    {410, -1, 90, -1, {219.3522,-170.7677,1.2316,90.0}, false}, // Manana
    {410, -1, 90, -1, {219.3299,-175.7467,1.1914,90.0}, false}, // Manana
    {410, -1, 90, -1, {199.9606,-155.2289,1.1889,180.0}, false}, // Manana
    {410, -1, 90, -1, {196.2131,-155.2962,1.1906,180.0}, false}, // Manana

    // -----[ Banka ] -----
    //{411, -1, 700, 84, {1468.4725,-1049.0771,23.5153,90.0}, false},  // Infernus
    //{541, -1, 600, 84, {1468.4429,-1057.6548,23.5391,90.0}, false}, // Bullet
    //{560, -1, 500, 84, {1436.2595,-1049.0576,23.5609,270.0}, false}, // Sultan
    //{451, -1, 500, 84, {1435.9807,-1057.8048,23.5608,270.0}, false}, // Turismo
    //{411, 79, 800, 84, {1468.5005,-1053.2609,23.5209,90.0}, true},  // Infernus
    //{541,  0, 700, 84, {1468.6113,-1062.3646,23.5209,90.0}, true}, // Bullet
    //{560, -1, 600, 84, {1436.0017,-1053.1948,23.5609,270.0}, true}, // Sultan
    //{451,  3, 600, 84, {1435.9576,-1062.2913,23.5608,270.0}, true}, // Turismo
    //{522, -1, 300, 84, {1464.9358,-1044.5695,23.4148,96.6908}, false}, // NRG-500
    //{522, -1, 300, 84, {1466.5809,-1045.7789,23.4142,104.7609}, false}, // NRG-500
    //{522, -1, 300, 84, {1440.1892,-1044.6715,23.4549,258.2430}, false}, // NRG-500
    //{522, -1, 300, 84, {1437.5182,-1045.7599,23.4559,237.1240}, false},  // NRG-500

    // -----[ Jefferson ] -----
    {533, -1, 350, 84, {1967.6660,-1486.8467,13.1703,0.0}, false}, // Feltzer
    {421, -1, 200, 84, {1964.8505,-1486.6039,13.1754,0.0}, false}, // Washington
    {419, -1, 280, 84, {1961.9836,-1486.7747,13.1764,0.0}, false}, // Esperanto
    {426, -1, 190, 84, {1959.1541,-1486.4594,13.1732,0.0}, false}, // Premier
    {461, -1, 130, 84, {1974.6133,-1478.9296,13.1868,90.0}, false}, // PCJ-600
    {461, -1, 150, 84, {1974.8822,-1481.0624,13.1860,90.0}, false}, // PCJ-600
    {461, -1, 150, 84, {1974.6062,-1483.1111,13.1843,90.0}, false}, // PCJ-600
    {581, -1, 120, 84, {1974.4772,-1485.2468,13.1825,90.0}, false}, // BF-400
    {581, -1, 120, 84, {1974.4735,-1487.5504,13.1869,90.0}, false}, // BF-400


    // -----[ Rudnik ] -----
    {410, -1, 130, -1, {635.5698,812.3039,-42.9796,77.8843}, false}, // Manana
    {410, -1, 130, -1, {634.7217,808.1844,-42.9755,76.5919}, false}, // Manana
    {410, -1, 130, -1, {621.6124,810.8977,-42.9777,255.3812}, false}, // Manana
    {410, -1, 130, -1, {622.6117,814.8372,-42.9778,257.1761}, false}, // Manana


    // -----[ Plantaza marihuane ] -----
    {410, -1, 130, -1, {562.2438,1082.9718,27.9904,195.5}, false}, // Manana
    {410, -1, 130, -1, {566.7651,1084.3336,27.9866,195.5}, false}, // Manana
    {410, -1, 130, -1, {571.9749,1085.5437,27.9847,195.5}, false}, // Manana
    {410, -1, 130, -1, {576.7992,1086.9170,27.9887,195.5}, false} // Manana
};



new
	veh_rent[sizeof rentVehicles], // ID-evi svih rent vozila
	vr_iznajmljuje[sizeof rentVehicles], // ID igraca koji iznajmljuje vozilo (-1 default)
	bool:vr_ceka_rent[MAX_PLAYERS char], // true kada nema iznajmljeno vozilo, a usao je u vozilo koje se moze iznajmiti
	bool:vr_ceka_produzenje[MAX_PLAYERS char],
	bool:vr_usao_u_rent_vozilo[MAX_PLAYERS char],
	tmrVehRentExpiration[MAX_PLAYERS],
	tmrVehRentTakeAway[MAX_PLAYERS]
;


// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
	for (new i = 0; i < sizeof rentVehicles; i++) 
    {
        veh_rent[i] = CreateVehicle(rentVehicles[i][vehModel], rentVehicles[i][vehPos][POS_X], rentVehicles[i][vehPos][POS_Y], rentVehicles[i][vehPos][POS_Z], rentVehicles[i][vehPos][POS_A], rentVehicles[i][vehBoja], rentVehicles[i][vehBoja], 1000, false);

        CreateDynamic3DTextLabel("[ Rent-a-Car ]", 0x94B8B8AA, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, veh_rent[i]);
		
        
		vr_iznajmljuje[i] = -1; // Oznacava da ovo vozilo nije iznajmljeno

        if (rentVehicles[i][VEH_RENT_TUNED])
        {
            AddVehicleComponent(veh_rent[i], 1010); // Nitro
            AddVehicleComponent(veh_rent[i], 1073 + random(13)); // Random felne
            AddVehicleComponent(veh_rent[i], 1087); // Hidraulika
            
            new neonObjTemp;
            new idx = rentVehicles[i][vehModel] - 400;
            /*
            // Neonke
            
            new neonObjId = NEON_LIGHT_RED;
            

            if (rentVehicles[i][vehModel] == 411 && rentVehicles[i][vehFirma] == 84)
            {
                // Gumba_Saurus; infernus; rent kod banke
                neonObjId = NEON_LIGHT_RED;
            }

            else if (rentVehicles[i][vehModel] == 541 && rentVehicles[i][vehFirma] == 84)
            {
                // Gumba_Saurus; Bullet; rent kod banke
                neonObjId = NEON_LIGHT_YELLOW;
            }

            else if (rentVehicles[i][vehModel] == 451 && rentVehicles[i][vehFirma] == 84)
            {
                // Gumba_Saurus; Turismo; rent kod banke
                neonObjId = NEON_LIGHT_BLUE;
            }

            else if (rentVehicles[i][vehModel] == 560 && rentVehicles[i][vehFirma] == 84)
            {
                // Gumba_Saurus; Sultan; rent kod banke
                AddVehicleComponent(veh_rent[i], 1029);
                AddVehicleComponent(veh_rent[i], 1032);
                AddVehicleComponent(veh_rent[i], 1027);
                AddVehicleComponent(veh_rent[i], 1139);
                AddVehicleComponent(veh_rent[i], 1169);
                AddVehicleComponent(veh_rent[i], 1140);
                neonObjId = NEON_LIGHT_GREEN;
            }*/


            neonObjTemp = CreateDynamicObject(NEON_LIGHT_BLUE, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(neonObjTemp, veh_rent[i], gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);

            neonObjTemp = CreateDynamicObject(NEON_LIGHT_BLUE, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(neonObjTemp, veh_rent[i], -gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);
        }
	}
	
	return 1;
}

hook OnPlayerConnect(playerid) 
{
	pRentInfo[playerid][vehID] = INVALID_VEHICLE_ID;
	pRentInfo[playerid][rentID] = -1;
	pRentInfo[playerid][expTime] = 0;
	
	vr_ceka_rent{playerid} = vr_ceka_produzenje{playerid} = vr_usao_u_rent_vozilo{playerid} = false;
	
	tmrVehRentExpiration[playerid] = tmrVehRentTakeAway[playerid] = 0;
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
	if (pRentInfo[playerid][expTime] != 0 && pRentInfo[playerid][vehID] != INVALID_VEHICLE_ID && pRentInfo[playerid][rentID] != -1) 
    {
		// Odjavljuje vozilo
		vr_iznajmljuje[pRentInfo[playerid][rentID]] = -1;
		pRentInfo[playerid][vehID]    = INVALID_VEHICLE_ID;
		pRentInfo[playerid][rentID]   = -1;
		pRentInfo[playerid][expTime]  = 0;
		vr_ceka_rent{playerid} = false;
		vr_ceka_produzenje{playerid} = false;
		SetVehicleToRespawn(pRentInfo[playerid][vehID]);
	}
    KillTimer(tmrVehRentExpiration[playerid]);
    KillTimer(tmrVehRentTakeAway[playerid]);
	
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) 
{
	
	if (newstate != PLAYER_STATE_DRIVER || !IsPlayerInAnyVehicle(playerid)) return 1;
	new
		vehicleid = GetPlayerVehicleID(playerid)
	;
	
	for__loop (new i = 0; i < sizeof rentVehicles; i++) 
    {
		if (vehicleid == veh_rent[i]) 
        {
			// Igrac je usao u rent-a-car vozilo
			
			if (vr_iznajmljuje[i] != -1 && vr_iznajmljuje[i] != playerid) 
            {
				// Usao je u vozilo koje je neko drugi iznajmio
				
				isteraj(playerid);
				ErrorMsg(playerid, "Neko drugi je vec iznajmio ovo vozilo.");
			}
			else if (vr_iznajmljuje[i] == -1) 
            {
				// Vozilo dostupno za iznajmljivanje
				
				vr_usao_u_rent_vozilo{playerid} = true;
				TogglePlayerControllable_H(playerid, false);
				
				if (pRentInfo[playerid][expTime] == 0) 
                {
					// Igrac nema iznajmljeno vozilo
					
					vr_ceka_rent{playerid} = true;
					pRentInfo[playerid][vehID]  = vehicleid;
					pRentInfo[playerid][rentID] = i;
					
                    new 
                        string[300], str[21], model = rentVehicles[pRentInfo[playerid][rentID]][vehModel];
                    if (IsVehicleMotorbike(model))      str = "Seli ste na motor";
                    else if (IsVehicleBicycle(model))   str = "Seli ste na bicikl";
                    else                                str = "Usli ste u automobil";

                    format(string, sizeof string, "{FFFFFF}%s {0068B3}%s.\n\n{FFFFFF}Ovo vozilo je vlasnistvu rent-a-car firme i njegovo koriscenje se mora platiti.\nCena iznajmljivanja za 1 minut: {0068B3}$%d\n\n{FFFFFF}Upisite na koliko {0068B3}minuta {FFFFFF}zelite da iznajmite ovo vozilo (max. 45):", str, imena_vozila[rentVehicles[pRentInfo[playerid][rentID]][vehModel] - 400], rentVehicles[pRentInfo[playerid][rentID]][vehCena]);
                    SPD(playerid, "veh_rent", DIALOG_STYLE_INPUT, "Rent-a-car", string, "Iznajmi", "Odustani");
				}
                else
                    return ErrorMsg(playerid, "Vec ste iznajmili neko vozilo, morate ga odjaviti pre nego sto iznajmite novo (/odjavi).");
			}
			break;
		}
	}
	
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if (!IsPlayerInAnyVehicle(playerid)) return 1;
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	if (!vr_usao_u_rent_vozilo{playerid}) return 1;
	
	
	if (newkeys & KEY_SECONDARY_ATTACK) // F (zeli da izadje iz vozila)
	{
		new
			vehid = GetPlayerVehicleID(playerid)
		;
	
		for__loop (new i = 0; i < sizeof rentVehicles; i++) 
        {
			if (vehid == veh_rent[i]) 
            {
				// Igrac mora da bude u vozilu rent-a-car-a i mora da bude zamrznut + dodatna provera
				
				if (!zamrznut{playerid}) return 1;
				
				RemovePlayerFromVehicle(playerid);
				TogglePlayerControllable_H(playerid, true);
				vr_usao_u_rent_vozilo{playerid} = false;
				
				if (pRentInfo[playerid][expTime] == 0 && vr_ceka_rent{playerid}) 
                {
					vr_ceka_rent{playerid} = false;
					pRentInfo[playerid][vehID]  = INVALID_VEHICLE_ID;
					pRentInfo[playerid][rentID] = -1;
				}
				break;
			}
		}
	}
	return 1;
}

hook OnVehicleSpawn(vehicleid)
{
    for (new i = 0; i < sizeof rentVehicles; i++) 
    {
        if (vehicleid == veh_rent[i] && rentVehicles[i][VEH_RENT_TUNED])
        {
            AddVehicleComponent(veh_rent[i], 1010);
            AddVehicleComponent(veh_rent[i], 1073 + random(13));
            break;
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward VehRentExpiration(playerid);
public VehRentExpiration(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("VehRentExpiration");
    }

	if (pRentInfo[playerid][expTime] == 0 || pRentInfo[playerid][vehID] == INVALID_VEHICLE_ID || pRentInfo[playerid][rentID] == -1) 
    {
		// Nesto se dogodilo, ipak ne iznajmljuje vozilo
		tmrVehRentExpiration[playerid] = 0;
		return 1;
	}
	
    vr_ceka_produzenje{playerid} = true;
	SendClientMessageF(playerid, ZUTA, "(rent) Vase iznajmljeno vozilo {F5DEB3}%s {FFFF00}istice za 1 minut.", imena_vozila[rentVehicles[pRentInfo[playerid][rentID]][vehModel] - 400]); 
	SendClientMessageF(playerid, BELA, "   Ukoliko zelite da ga produzite, ponovo upisite {FFFF00}/iznajmi {FFFFFF}  | Cena: {FFFF00}$%d", rentVehicles[pRentInfo[playerid][rentID]][vehCena]);
	
	tmrVehRentExpiration[playerid] = 0;
	tmrVehRentTakeAway[playerid] = SetTimerEx("VehRentTakeAway", 60*1000, false, "i", playerid);
	
	return 1;
}

forward VehRentTakeAway(playerid);
public VehRentTakeAway(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("VehRentTakeAway");
    }

    tmrVehRentTakeAway[playerid] = 0;
	if (pRentInfo[playerid][expTime] == 0 || pRentInfo[playerid][vehID] == INVALID_VEHICLE_ID || pRentInfo[playerid][rentID] == -1) 
    {
		// Nesto se dogodilo, ipak ne iznajmljuje vozilo
		return 1;
	}	
	
	SetVehicleToRespawn(pRentInfo[playerid][vehID]);
    RefillVehicle(pRentInfo[playerid][vehID]);
    vr_iznajmljuje[pRentInfo[playerid][rentID]] = -1;
    pRentInfo[playerid][vehID]  = INVALID_VEHICLE_ID;
    pRentInfo[playerid][rentID] = -1;
    pRentInfo[playerid][expTime]   = 0;
    vr_ceka_rent{playerid} = false;
    vr_ceka_produzenje{playerid} = false;
    KillTimer(tmrVehRentExpiration[playerid]), tmrVehRentExpiration[playerid] = 0;
	
	// Poruka
	SendClientMessage(playerid, ZUTA, "(rent) Vase iznajmljeno vozilo je isteklo.");
	
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:veh_rent(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
    {
        new
            vehid = GetPlayerVehicleID(playerid)
        ;
    
        for__loop (new i = 0; i < sizeof rentVehicles; i++) 
        {
            if (vehid == veh_rent[i]) {
                // Igrac mora da bude u vozilu rent-a-car-a i mora da bude zamrznut + dodatna provera
                
                if (!zamrznut{playerid}) return 1;

                TogglePlayerControllable_H(playerid, true);
                RemovePlayerFromVehicle(playerid);
                vr_usao_u_rent_vozilo{playerid} = false;
                
                if (pRentInfo[playerid][expTime] == 0 && vr_ceka_rent{playerid}) 
                {
                    vr_ceka_rent{playerid} = false;
                    pRentInfo[playerid][vehID]  = INVALID_VEHICLE_ID;
                    pRentInfo[playerid][rentID] = -1;
                }
                break;
            }
        }
        return 1;
    }

    new rentDuration;
    if (sscanf(inputtext, "i", rentDuration))
        return DialogReopen(playerid);

    if (rentDuration < 1 || rentDuration > 45) 
    {
        ErrorMsg(playerid, "Unesite broj izmedju 1 i 45.");
        return DialogReopen(playerid);
    }

    return callcmd::iznajmi(playerid, inputtext);
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:odjavi("unrent")
alias:rlociraj("rloc")

CMD:iznajmi(playerid, const params[]) 
{

    new rentDuration;
    if (sscanf(params, "i", rentDuration))
        return Koristite(playerid, "iznajmi [Na koliko minuta zelite da iznajmite vozilo (max. 45)]");

    if (rentDuration < 1 || rentDuration > 45) 
        return ErrorMsg(playerid, "Unesite broj izmedju 1 i 45.");

    if (pRentInfo[playerid][rentID] == -1)
        return ErrorMsg(playerid, "Ne nalazitee se u rent-a-car vozilu.");

    if (PI[playerid][p_novac] < rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration)
        return ErrorMsg(playerid, "Nemate dovoljno novca da biste iznajmili ovo vozilo.");

	
	if (vr_ceka_produzenje{playerid}) { // Igrac moze da produzi rent
		new gid;
	
		pRentInfo[playerid][expTime] = gettime() + rentDuration*60;
		PlayerMoneySub(playerid, rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration);
        if(rentVehicles[pRentInfo[playerid][rentID]][vehFirma] != -1)
        {
            gid = re_globalid(firma, rentVehicles[pRentInfo[playerid][rentID]][vehFirma]);
		    re_firma_dodaj_novac(gid, rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration);  
        }
        
		// Postavlja tajmer na 3 minuta pred istek vozila
		KillTimer(tmrVehRentTakeAway[playerid]), tmrVehRentTakeAway[playerid] = 0;
        // Postavlja tajmer na 1 minut pred istek vozila, pod uslovom da je izabrao bar 3 minuta
        if (rentDuration >= 3)
            tmrVehRentExpiration[playerid] = SetTimerEx("VehRentExpiration", (rentDuration-1)*60*1000, false, "i", playerid);
        else 
            tmrVehRentTakeAway[playerid] = SetTimerEx("VehRentTakeAway", rentDuration*60*1000, false, "i", playerid);
		
		SendClientMessageF(playerid, ZUTA, "(rent) {FFFFFF}Produzili ste svoje vozilo za jos {FFFF00}%d minuta.", rentDuration);
        vr_ceka_produzenje{playerid} = false;
		
		return 1;
	}
	
	
	// Igrac mora da bude u vozilu rent-a-car-a i mora da bude zamrznut + dodatna provera
	if (!zamrznut{playerid}) return 1;
	
	if (pRentInfo[playerid][expTime] != 0 && !vr_ceka_produzenje{playerid})
		return ErrorMsg(playerid, "Vec ste iznajmili neko vozilo, morate ga odjaviti pre nego sto iznajmite novo (/odjavi).");
	
	if (!IsPlayerInAnyVehicle(playerid) || pRentInfo[playerid][vehID] == INVALID_VEHICLE_ID || pRentInfo[playerid][rentID] == -1)
		return ErrorMsg(playerid, "Ne nalazite se u rent-a-car vozilu.");
	
	if (!vr_ceka_rent{playerid} && !vr_ceka_produzenje{playerid})
		return ErrorMsg(playerid, "Ne nalazite se u rent-a-car vozilu.");
	
	if (vr_iznajmljuje[pRentInfo[playerid][rentID]] != -1)
		return ErrorMsg(playerid, "Neko drugi je vec iznajmio ovo vozilo.");
	
	new gid;
	
	// Glavna funkcija komande
	vr_ceka_rent{playerid} = false;
	vr_ceka_produzenje{playerid} = false;
	pRentInfo[playerid][expTime] = gettime() + rentDuration*60;
	PlayerMoneySub(playerid, rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration);

    if(rentVehicles[pRentInfo[playerid][rentID]][vehFirma] != -1)
    {
        gid = re_globalid(firma, rentVehicles[pRentInfo[playerid][rentID]][vehFirma]);
	    re_firma_dodaj_novac(gid, rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration);  
    }

	vr_iznajmljuje[pRentInfo[playerid][rentID]] = playerid;
	// Postavlja tajmer na 1 minut pred istek vozila, pod uslovom da je izabrao bar 3 minuta
    if (rentDuration >= 3)
        tmrVehRentExpiration[playerid] = SetTimerEx("VehRentExpiration", (rentDuration-1)*60*1000, false, "i", playerid);
    else 
        tmrVehRentTakeAway[playerid] = SetTimerEx("VehRentTakeAway", rentDuration*60*1000, false, "i", playerid);
	
	// Ispisivanje informacija
	GameTextForPlayer(playerid, "~g~Uspesno ste iznajmili ovo vozilo!", 3000, 5);
	SendClientMessageF(playerid, ZUTA, "(rent) {FFFFFF}Iznajmili ste vozilo: {FFFF00}%s {FFFFFF}po ceni od {FFFF00}$%d", imena_vozila[rentVehicles[pRentInfo[playerid][rentID]][vehModel] - 400], rentVehicles[pRentInfo[playerid][rentID]][vehCena]*rentDuration);
	SendClientMessage(playerid, BELA,  "   Da odjavite vozilo upisite {FFFF00}/odjavi. {FFFFFF}Da ga locirate upisite {FFFF00}/rlociraj.");
	SendClientMessageF(playerid, BELA, "   Mozete koristiti ovo vozilo narednih {FFFF00}%d minuta.", rentDuration);
	
	// Odmrzavanje igraca
	TogglePlayerControllable_H(playerid, true);

    // Paljenje vozila
    new engine, lights, alarm, doors, bonnet, boot, objective,
        vehicleid = GetPlayerVehicleID(playerid);
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    if (IsVehicleBicycle(GetVehicleModel(vehicleid)) == 1) return 1;
    if (engine == 0 || engine == -1)
    {
        if (GetVehicleFuel(vehicleid) <= 0.0) 
            return SendClientMessage(playerid, ZUTA, "Nemate goriva u vozilu, ne mozete upaliti motor!");

        SetVehicleParamsEx(vehicleid, 1, 1, alarm, doors, bonnet, boot, objective);
        format(string_128, sizeof string_128, "** %s pali motor na vozilu %s.", ime_rp[playerid], imena_vozila[GetVehicleModel(vehicleid) - 400]);
        RangeMsg(playerid, string_128, LJUBICASTA, 10.0);
	}
	return 1;
}

CMD:odjavi(playerid, const params[]) 
{
	if (pRentInfo[playerid][expTime] == 0 || pRentInfo[playerid][vehID] == INVALID_VEHICLE_ID || pRentInfo[playerid][rentID] == -1)
		return ErrorMsg(playerid, "Niste iznajmili nikakvo vozilo.");
	
	// Glavna funkcija komande
    SetVehicleToRespawn(pRentInfo[playerid][vehID]);
    RefillVehicle(pRentInfo[playerid][vehID]);
	vr_iznajmljuje[pRentInfo[playerid][rentID]] = -1;
	pRentInfo[playerid][vehID]  = INVALID_VEHICLE_ID;
	pRentInfo[playerid][rentID] = -1;
	pRentInfo[playerid][expTime] = 0;
	vr_ceka_rent{playerid} = false;
	vr_ceka_produzenje{playerid} = false;
	KillTimer(tmrVehRentExpiration[playerid]);
    KillTimer(tmrVehRentTakeAway[playerid]);
	
	// Poruka
	SendClientMessage(playerid, BELA, "Uspesno ste odjavili svoje vozilo.");
	
	return 1;
}

CMD:rlociraj(playerid, const params[]) 
{
	if (pRentInfo[playerid][expTime] == 0 || pRentInfo[playerid][vehID] == INVALID_VEHICLE_ID || pRentInfo[playerid][rentID] == -1)
		return ErrorMsg(playerid, "Niste iznajmili nikakvo vozilo.");
	
	new 
		vehid = pRentInfo[playerid][vehID],
		Float:pos[3]
	;
	
	// Glavna funkcija komande
	GetVehiclePos(vehid, pos[0], pos[1], pos[2]);
	SetGPSLocation(playerid, pos[0], pos[1], pos[2], "iznajmljeno vozilo");
	
	return 1;
}