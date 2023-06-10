/*
TODO:
Potrebno je ograditi war zonu (boundaries)
Informacije za sve igrace treba updateovati na kraju wara ili kada igrac izadje iz wara


War score:
---------------
Ubistvo protivnika +1
Smrt -1
Ubistvo lidera +2
Samoubistvo -3
Zadati dmg 1 hp = +0.01
Primljeni dmg 1 hp = -0.01

*/

#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
static
    // Podaci za pokretanje wara
    bool:war_aktivan = false, 
    bool:war_pripreme = false,
    bool:war_bets_allowed = false,
    war_review, 
    war_tim1, 
    war_tim2,
    war_ulog, 
    war_trajanje, 
    war_broj_ucesnika, 
    war_mapa, 
    war_preostalo,
    war_accept_time,
    
    // broj prijavljenih ucesnika za oba tima
    war_prijavljeno[3], 

    // Timska statistika
    war_skor[3], 
    war_ubistva[3], 
    war_smrti[3], 
    war_samoubistva[3], 

    // Individualna statistika
    bool:igrac_u_waru[MAX_PLAYERS char],    
    war_p_ubistva[MAX_PLAYERS], 
    war_p_smrti[MAX_PLAYERS], 
    war_p_samoubistva[MAX_PLAYERS], 
    Float:war_p_dmg_taken[MAX_PLAYERS], 
    Float:war_p_dmg_given[MAX_PLAYERS], 
    war_pauza_reload[MAX_PLAYERS],
    Float:war_p_score[MAX_PLAYERS], 
    

    // Za lakse kretanje kroz dialoge (reopen)
    war_mafia_gang_listitem[MAX_FACTIONS],
    war_return_listitem1[MAX_PLAYERS],      
    war_return_listitem2[MAX_PLAYERS], 
    war_inout_listitem[3][13],

    war_side_td_id[MAX_PLAYERS], // Odnosi se na textdrawove sa strane ekrana; upisuje ID td-a koji pripada igracu              
    
    // Parametri za okretanje kamere kad se gleda rezultat na kraju
    Float:war_kamera_ugao,
    
    // Iteratori
    Iterator:war_igraci<MAX_PLAYERS>, // svi igraci u waru
    Iterator:war_igraci_tim[3]<MAX_PLAYERS>, // svi igraci u jednom timu (index 0 se ne koristi)

    // TextDraws
    Text:tdWarRezultat[3], // upisuje se nakon kreiranja TD-ova, radi lakse promene skora timova; index 0 se ne koristi
    
    // Tajmeri
    tmrWarCam = 0, tmrWarTick = 0,

    // Kladjenje
    gWarBetTeam[MAX_PLAYERS],
    gWarBetStake[MAX_PLAYERS]
;




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new const war_mape[12][10] = {
    "Farma 1", "Farma 2", "Brod 1", "Brod 2", "Bull selo", 
    "Urban", "Skladiste", "Desert", "Fabrika", "Ruins", "Rampage", "Railroad"
};
/*
    dim 1 = broj mapa
    dim 2 = broj spawn pozicija po mapi
    dim 3 = broj koordinata (x, y, z, a)
    
    ako se dim 2 promeni, potrebno je promeniti je u war_spawn onaj random(12)
*/
new const Float:war_spawn_tim1[12][12][4] = {
    // ID 0
    {
        {-122.0406, -110.8095, 3.1172, 315.8515},   // Farma1 Tim 1 - Spawn 1
        {-131.5979, -109.9869, 3.1172, 86.5128},    // Farma1 Tim 1 - Spawn 2
        {-135.0741, -117.6536, 3.1172, 159.2067},   // Farma1 Tim 1 - Spawn 3
        {-123.6147, -119.9622, 3.1172, 259.7877},   // Farma1 Tim 1 - Spawn 4
        {-124.5750, -129.0227, 3.1172, 166.7268},   // Farma1 Tim 1 - Spawn 5
        {-137.7086, -127.6455, 3.1172, 83.3794},    // Farma1 Tim 1 - Spawn 6
        {-106.0126, -113.6321, 3.1172, 348.7519},   // Farma1 Tim 1 - Spawn 7
        {-75.5968, -118.2462, 3.1172, 260.0777},    // Farma1 Tim 1 - Spawn 8
        {-75.6963, -128.9496, 3.1172, 172.6568},    // Farma1 Tim 1 - Spawn 9
        {-104.4340, -123.1458, 3.1172, 77.0893},    // Farma1 Tim 1 - Spawn 10
        {-107.8134, -131.8252, 3.1172, 236.2641},   // Farma1 Tim 1 - Spawn 11
        {-83.4250, -135.7748, 3.1172, 259.4510}     // Farma1 Tim 1 - Spawn 12
    },
    
    // ID 1
    {
        {-1465.1959, -1453.7390, 101.7578, 52.1706},    // Farma2 Tim 1 - Spawn 1
        {-1453.7788, -1448.7202, 101.7578, 291.2228},   // Farma2 Tim 1 - Spawn 2
        {-1450.9510, -1459.5083, 101.7578, 194.0886},   // Farma2 Tim 1 - Spawn 3
        {-1462.5480, -1468.5563, 101.7578, 153.3548},   // Farma2 Tim 1 - Spawn 4
        {-1451.1769, -1470.2303, 101.7578, 272.7360},   // Farma2 Tim 1 - Spawn 5
        // ---- duplikati
        {-1465.1959, -1453.7390, 101.7578, 52.1706},    // Farma2 Tim 1 - Spawn 1
        {-1453.7788, -1448.7202, 101.7578, 291.2228},   // Farma2 Tim 1 - Spawn 2
        {-1450.9510, -1459.5083, 101.7578, 194.0886},   // Farma2 Tim 1 - Spawn 3
        {-1462.5480, -1468.5563, 101.7578, 153.3548},   // Farma2 Tim 1 - Spawn 4
        {-1451.1769, -1470.2303, 101.7578, 272.7360},   // Farma2 Tim 1 - Spawn 5
        {-1465.1959, -1453.7390, 101.7578, 52.1706},    // Farma2 Tim 1 - Spawn 1
        {-1453.7788, -1448.7202, 101.7578, 291.2228}    // Farma2 Tim 1 - Spawn 2
    },
    
    // ID 2
    {
        {-1249.4604, 491.0956, 16.5781, 78.5943},   // Brod 1 Tim 1 - Spawn 1
        {-1247.6334, 497.5902, 18.2344, 310.7531},  // Brod 1 Tim 1 - Spawn 2
        {-1253.0927, 506.3146, 18.2344, 24.3871},   // Brod 1 Tim 1 - Spawn 3
        {-1253.8907, 512.4352, 16.5781, 10.6003},   // Brod 1 Tim 1 - Spawn 4
        {-1248.3451, 510.3752, 16.5781, 245.6025},  // Brod 1 Tim 1 - Spawn 5
        {-1255.9048, 501.2853, 18.2344, 91.7544},   // Brod 1 Tim 1 - Spawn 6
        // ---- duplikati
        {-1249.4604, 491.0956, 16.5781, 78.5943},   // Brod 1 Tim 1 - Spawn 1
        {-1247.6334, 497.5902, 18.2344, 310.7531},  // Brod 1 Tim 1 - Spawn 2
        {-1253.0927, 506.3146, 18.2344, 24.3871},   // Brod 1 Tim 1 - Spawn 3
        {-1253.8907, 512.4352, 16.5781, 10.6003},   // Brod 1 Tim 1 - Spawn 4
        {-1248.3451, 510.3752, 16.5781, 245.6025},  // Brod 1 Tim 1 - Spawn 5
        {-1255.9048, 501.2853, 18.2344, 91.7544}    // Brod 1 Tim 1 - Spawn 6
    },
    
    // ID 3
    {
        {-1479.6310, 1489.6445, 8.2578, 279.6086},  // Brod 2 Tim 1 - Spawn 1
        {-1473.8142, 1495.7585, 8.2578, 230.6556},  // Brod 2 Tim 1 - Spawn 2
        {-1473.6333, 1484.2550, 8.2578, 179.6543},  // Brod 2 Tim 1 - Spawn 3
        {-1462.4288, 1480.2635, 8.2578, 271.4619},  // Brod 2 Tim 1 - Spawn 4
        {-1462.5088, 1497.7839, 8.2578, 0.1361},    // Brod 2 Tim 1 - Spawn 5
        // ---- duplikati
        {-1479.6310, 1489.6445, 8.2578, 279.6086},  // Brod 2 Tim 1 - Spawn 1
        {-1473.8142, 1495.7585, 8.2578, 230.6556},  // Brod 2 Tim 1 - Spawn 2
        {-1473.6333, 1484.2550, 8.2578, 179.6543},  // Brod 2 Tim 1 - Spawn 3
        {-1462.4288, 1480.2635, 8.2578, 271.4619},  // Brod 2 Tim 1 - Spawn 4
        {-1462.5088, 1497.7839, 8.2578, 0.1361},    // Brod 2 Tim 1 - Spawn 5
        {-1479.6310, 1489.6445, 8.2578, 279.6086},  // Brod 2 Tim 1 - Spawn 1
        {-1473.8142, 1495.7585, 8.2578, 230.6556}   // Brod 2 Tim 1 - Spawn 2
    },
    
    // ID 4
    {
        {-725.0926, 1430.0105, 18.4766, 355.5847},  // Bull selo Tim 1 - Spawn 1
        {-720.5718, 1439.2533, 18.4766, 355.5847},  // Bull selo Tim 1 - Spawn 2
        {-714.2961, 1449.3083, 18.4825, 313.5977},  // Bull selo Tim 1 - Spawn 3
        {-726.7614, 1458.7517, 18.3470, 43.8385},   // Bull selo Tim 1 - Spawn 4
        {-734.1126, 1448.1454, 17.3320, 149.1195},  // Bull selo Tim 1 - Spawn 5
        {-743.4327, 1449.5096, 16.5291, 84.8855},   // Bull selo Tim 1 - Spawn 6
        {-747.4013, 1441.5292, 16.1625, 160.3996},  // Bull selo Tim 1 - Spawn 7
        {-747.7115, 1433.2042, 16.0613, 189.8532},  // Bull selo Tim 1 - Spawn 8
        // ---- duplikati
        {-725.0926, 1430.0105, 18.4766, 355.5847},  // Bull selo Tim 1 - Spawn 1
        {-720.5718, 1439.2533, 18.4766, 355.5847},  // Bull selo Tim 1 - Spawn 2
        {-714.2961, 1449.3083, 18.4825, 313.5977},  // Bull selo Tim 1 - Spawn 3
        {-726.7614, 1458.7517, 18.3470, 43.8385}    // Bull selo Tim 1 - Spawn 4
    },
    
    // ID 5
    {
        {-2100.2681, -275.4084, 35.3203, 198.8251}, // Urban Tim 1 - Spawn 1
        {-2116.8984, -275.1729, 35.3203, 91.6641},  // Urban Tim 1 - Spawn 2
        {-2123.1079, -265.9467, 35.3203, 96.3642},  // Urban Tim 1 - Spawn 3
        {-2136.0432, -266.1573, 35.3203, 96.3642},  // Urban Tim 1 - Spawn 4
        {-2135.2561, -255.6641, 35.3203, 340.4297}, // Urban Tim 1 - Spawn 5
        {-2100.5254, -260.5247, 35.3203, 265.8557}, // Urban Tim 1 - Spawn 6
        // ---- duplikati
        {-2100.2681, -275.4084, 35.3203, 198.8251}, // Urban Tim 1 - Spawn 1
        {-2116.8984, -275.1729, 35.3203, 91.6641},  // Urban Tim 1 - Spawn 2
        {-2123.1079, -265.9467, 35.3203, 96.3642},  // Urban Tim 1 - Spawn 3
        {-2136.0432, -266.1573, 35.3203, 96.3642},  // Urban Tim 1 - Spawn 4
        {-2135.2561, -255.6641, 35.3203, 340.4297}, // Urban Tim 1 - Spawn 5
        {-2100.5254, -260.5247, 35.3203, 265.8557}  // Urban Tim 1 - Spawn 6
    },
    
    // ID 6
    {
        {1295.8276, 1070.7544, 10.7652, 339.5367},  // Skladiste Tim 1 - Spawn 1
        {1292.5142, 1079.9358, 10.6478, 9.3515},    // Skladiste Tim 1 - Spawn 2
        {1300.1415, 1068.9941, 10.8203, 216.7568},  // Skladiste Tim 1 - Spawn 3
        {1308.9679, 1072.0205, 10.8203, 292.2708},  // Skladiste Tim 1 - Spawn 4
        {1309.9948, 1084.0702, 10.8203, 350.5513},  // Skladiste Tim 1 - Spawn 5
        {1303.6091, 1093.1365, 10.8203, 35.5513},   // Skladiste Tim 1 - Spawn 6
        {1294.9352, 1103.0281, 10.7794, 30.3450},   // Skladiste Tim 1 - Spawn 7
        {1283.5444, 1121.7932, 10.5860, 19.6916},   // Skladiste Tim 1 - Spawn 8
        {1279.0889, 1127.7649, 10.5496, 2.4582},    // Skladiste Tim 1 - Spawn 9
        {1307.0874, 1124.8711, 10.8203, 319.5311},  // Skladiste Tim 1 - Spawn 10
        // ---- duplikati
        {1295.8276, 1070.7544, 10.7652, 339.5367},  // Skladiste Tim 1 - Spawn 1
        {1292.5142, 1079.9358, 10.6478, 9.3515}     // Skladiste Tim 1 - Spawn 2
    },
    
    // ID 7
    {
        {1122.1428, -289.7718, 73.9476, 71.7055},   // Desert Tim 1 - Spawn 1
        {1107.7786, -290.9770, 73.9922, 71.3922},   // Desert Tim 1 - Spawn 2
        {1098.3346, -273.8494, 74.6003, 341.3922},  // Desert Tim 1 - Spawn 3
        {1105.0089, -265.8004, 73.9672, 319.5312},  // Desert Tim 1 - Spawn 4
        {1116.9965, -265.0199, 73.0219, 319.5312},  // Desert Tim 1 - Spawn 5
        {1102.3574, -295.1319, 73.9922, 174.7932},  // Desert Tim 1 - Spawn 6
        {1109.7621, -306.0932, 73.9922, 257.2007},  // Desert Tim 1 - Spawn 7
        {1113.1553, -318.8434, 73.9922, 157.2464},  // Desert Tim 1 - Spawn 8
        {1112.9774, -327.0708, 73.9922, 157.2464},  // Desert Tim 1 - Spawn 9
        {1098.7699, -328.6316, 73.9922, 111.4993},  // Desert Tim 1 - Spawn 10
        // ---- duplikati
        {1122.1428, -289.7718, 73.9476, 71.7055},   // Desert Tim 1 - Spawn 1
        {1107.7786, -290.9770, 73.9922, 71.3922}    // Desert Tim 1 - Spawn 2
    },
    
    // ID 8
    {
        {2672.2483, 2688.1077, 10.8203, 149.7533},  // Tvornica Tim 1 - Spawn 1
        {2663.7886, 2687.1006, 10.8203, 84.2660},   // Tvornica Tim 1 - Spawn 2
        {2660.8696, 2695.0093, 10.8203, 0.6052},    // Tvornica Tim 1 - Spawn 3
        {2668.0508, 2706.9636, 10.8203, 7.8119},    // Tvornica Tim 1 - Spawn 4
        {2672.1648, 2722.3464, 10.8203, 7.8119},    // Tvornica Tim 1 - Spawn 5
        {2659.1311, 2720.6375, 10.8203, 97.7394},   // Tvornica Tim 1 - Spawn 6
        {2660.5605, 2703.9097, 10.8203, 182.0269},  // Tvornica Tim 1 - Spawn 7
        // ---- duplikati
        {2672.2483, 2688.1077, 10.8203, 149.7533},  // Tvornica Tim 1 - Spawn 1
        {2663.7886, 2687.1006, 10.8203, 84.2660},   // Tvornica Tim 1 - Spawn 2
        {2660.8696, 2695.0093, 10.8203, 0.6052},    // Tvornica Tim 1 - Spawn 3
        {2668.0508, 2706.9636, 10.8203, 7.8119},    // Tvornica Tim 1 - Spawn 4
        {2672.1648, 2722.3464, 10.8203, 7.8119}     // Tvornica Tim 1 - Spawn 5
    },
    
    // ID 9
    {
        {-1020.8187,-932.6609,129.2188,263.0075},   // Ruins Tim 1 - Spawn 1
        {-1013.8873,-952.1362,129.2188,201.521},    // Ruins Tim 1 - Spawn 2
        {-1012.3501,-988.7929,129.2188,178.6475},   // Ruins Tim 1 - Spawn 3
        {-1013.6534,-1043.9960,129.2188,178.6475},  // Ruins Tim 1 - Spawn 4
        {-1018.1602,-1053.5563,129.2188,150.4472},  // Ruins Tim 1 - Spawn 5
        {-1028.7279,-1036.7620,129.2188,2.2392},    // Ruins Tim 1 - Spawn 6
        {-1029.9628,-998.9217,129.2126,277.8792},   // Ruins Tim 1 - Spawn 7
        // ---- duplikati
        {-1020.8187,-932.6609,129.2188,263.0075},   // Ruins Tim 1 - Spawn 1
        {-1013.8873,-952.1362,129.2188,201.521},    // Ruins Tim 1 - Spawn 2
        {-1012.3501,-988.7929,129.2188,178.6475},   // Ruins Tim 1 - Spawn 3
        {-1013.6534,-1043.9960,129.2188,178.6475},  // Ruins Tim 1 - Spawn 4
        {-1018.1602,-1053.5563,129.2188,150.4472}   // Ruins Tim 1 - Spawn 5
    },

    // ID 10
    {
        {1163.4762,1347.9995,10.7915,88.6187},  // Rampage Tim 1 - Spawn 1
        {1163.2826,1352.6085,10.7915,87.9294},  // Rampage Tim 1 - Spawn 2
        {1162.6350,1359.2438,10.7915,92.0027},  // Rampage Tim 1 - Spawn 3
        {1168.2792,1349.2502,10.7915,93.4441},  // Rampage Tim 1 - Spawn 4
        {1167.7345,1354.6323,10.7915,92.0655},  // Rampage Tim 1 - Spawn 5
        {1166.8457,1360.3071,10.7915,123.3364}, // Rampage Tim 1 - Spawn 6
        {1173.4231,1348.7021,10.7915,90.4361},  // Rampage Tim 1 - Spawn 7
        {1173.3077,1354.6469,10.7915,98.5829},  // Rampage Tim 1 - Spawn 8
        {1173.3018,1359.9618,10.7915,107.544},  // Rampage Tim 1 - Spawn 9
        {1173.9225,1361.2233,10.7915,93.9919},  // Rampage Tim 1 - Spawn 10
        // ---- duplikati
        {1163.4762,1347.9995,10.7915,88.6187},  // Rampage Tim 1 - Spawn 1
        {1163.2826,1352.6085,10.7915,87.9294}  // Rampage Tim 1 - Spawn 2
    },

    // ID 11
    {
        // prvih 5 su razlicite, ostalo su duplikati
        {3848.6060,1290.6266,203.6406,181.2514}, // Railroad Tim 1
        {3866.4197,1282.5156,203.6327,181.2514}, // Railroad Tim 1
        {3879.3259,1291.4833,203.6327,182.1310}, // Railroad Tim 1
        {3891.5557,1290.8005,203.6406,179.6452}, // Railroad Tim 1
        {3906.5505,1281.5677,203.6327,184.0320}, // Railroad Tim 1
        {3848.6060,1290.6266,203.6406,181.2514}, // Railroad Tim 1
        {3866.4197,1282.5156,203.6327,181.2514}, // Railroad Tim 1
        {3879.3259,1291.4833,203.6327,182.1310}, // Railroad Tim 1
        {3891.5557,1290.8005,203.6406,179.6452}, // Railroad Tim 1
        {3906.5505,1281.5677,203.6327,184.0320}, // Railroad Tim 1
        {3891.5557,1290.8005,203.6406,179.6452}, // Railroad Tim 1
        {3906.5505,1281.5677,203.6327,184.0320} // Railroad Tim 1
    }
};

new const Float:war_spawn_tim2[12][12][4] = {
    // ID 0
    {
        {-33.5363, 127.1149, 3.1172, 152.9400}, // Farma1 Tim 2 - Spawn 1
        {-13.0740, 113.6104, 3.1172, 240.6742}, // Farma1 Tim 2 - Spawn 2
        {-5.4594, 121.6966, 3.1172, 324.6483},  // Farma1 Tim 2 - Spawn 3
        {-29.4751, 135.7670, 3.1096, 60.2159},  // Farma1 Tim 2 - Spawn 4
        {-22.1101, 153.0709, 2.5224, 332.4817}, // Farma1 Tim 2 - Spawn 5
        {-0.2798, 143.2962, 2.5835, 242.9400},  // Farma1 Tim 2 - Spawn 6
        {-35.1466, 164.1599, 2.4692, 306.4514}, // Farma1 Tim 2 - Spawn 7
        {-64.7111, 177.8864, 2.6687, 68.3158},  // Farma1 Tim 2 - Spawn 8
        {-68.0758, 170.2834, 2.9244, 153.5432}, // Farma1 Tim 2 - Spawn 9
        {-40.2611, 155.4090, 2.8027, 242.2174}, // Farma1 Tim 2 - Spawn 10
        {-43.4381, 143.3551, 3.1172, 161.0633}, // Farma1 Tim 2 - Spawn 11
        {-70.2555, 157.6287, 3.1172, 61.1091}   // Farma1 Tim 2 - Spawn 12
    },
    
    // ID 1
    {
        {-1456.2748,-1595.2955,101.7578,108.2344}, // Farma2 Tim 2 - Spawn 1
        {-1455.7283,-1586.8392,101.7578,338.1999}, // Farma2 Tim 2 - Spawn 2
        {-1445.2836,-1587.0221,101.7578,264.8792}, // Farma2 Tim 2 - Spawn 3
        {-1439.2032,-1595.4650,101.7578,216.9388}, // Farma2 Tim 2 - Spawn 4
        {-1427.1168,-1587.0564,101.7578,307.4930},  // Farma2 Tim 2 - Spawn 5
        // ---- duplikati (zbog velicine array-a)
        {-1456.2748,-1595.2955,101.7578,108.2344}, // Farma2 Tim 2 - Spawn 1
        {-1455.7283,-1586.8392,101.7578,338.1999}, // Farma2 Tim 2 - Spawn 2
        {-1445.2836,-1587.0221,101.7578,264.8792}, // Farma2 Tim 2 - Spawn 3
        {-1439.2032,-1595.4650,101.7578,216.9388}, // Farma2 Tim 2 - Spawn 4
        {-1427.1168,-1587.0564,101.7578,307.4930},  // Farma2 Tim 2 - Spawn 5
        {-1439.2032,-1595.4650,101.7578,216.9388}, // Farma2 Tim 2 - Spawn 4
        {-1427.1168,-1587.0564,101.7578,307.4930}  // Farma2 Tim 2 - Spawn 5
    },
    
    // ID 2
    {
        {-1466.1844, 490.6882, 18.2344, 180.6694},  // Brod 1 Tim 2 - Spawn 1
        {-1466.4277, 511.8948, 18.2363, 0.9103},    // Brod 1 Tim 2 - Spawn 2
        {-1460.4227, 512.3464, 18.2363, 270.6694},  // Brod 1 Tim 2 - Spawn 3
        {-1460.6149, 501.7771, 18.2751, 178.2352},  // Brod 1 Tim 2 - Spawn 4
        {-1460.9563, 490.6753, 18.2344, 178.2352},  // Brod 1 Tim 2 - Spawn 5
        {-1460.5388, 487.1891, 16.5781, 190.6961},  // Brod 1 Tim 2 - Spawn 6
        // ---- duplikati
        {-1466.1844, 490.6882, 18.2344, 180.6694},  // Brod 1 Tim 2 - Spawn 1
        {-1466.4277, 511.8948, 18.2363, 0.9103},    // Brod 1 Tim 2 - Spawn 2
        {-1460.4227, 512.3464, 18.2363, 270.6694},  // Brod 1 Tim 2 - Spawn 3
        {-1460.6149, 501.7771, 18.2751, 178.2352},  // Brod 1 Tim 2 - Spawn 4
        {-1460.9563, 490.6753, 18.2344, 178.2352},  // Brod 1 Tim 2 - Spawn 5
        {-1460.5388, 487.1891, 16.5781, 190.6961}   // Brod 1 Tim 2 - Spawn 6
    },
    
    // ID 3
    {
        {-1363.0177, 1489.5016, 11.0391, 357.5569}, // Brod 2 Tim 2 - Spawn 1
        {-1365.5685, 1486.0464, 11.0391, 159.3110}, // Brod 2 Tim 2 - Spawn 2
        {-1366.1963, 1493.2991, 11.0391, 0.1362},   // Brod 2 Tim 2 - Spawn 3
        {-1371.0830, 1496.2096, 11.0391, 96.6437},  // Brod 2 Tim 2 - Spawn 4
        {-1371.4160, 1483.1453, 11.0391, 179.6778}, // Brod 2 Tim 2 - Spawn 5
        {-1376.8112, 1491.5394, 11.2031, 102.2837}, // Brod 2 Tim 2 - Spawn 6
        // ---- duplikati
        {-1363.0177, 1489.5016, 11.0391, 357.5569}, // Brod 2 Tim 2 - Spawn 1
        {-1365.5685, 1486.0464, 11.0391, 159.3110}, // Brod 2 Tim 2 - Spawn 2
        {-1366.1963, 1493.2991, 11.0391, 0.1362},   // Brod 2 Tim 2 - Spawn 3
        {-1371.0830, 1496.2096, 11.0391, 96.6437},  // Brod 2 Tim 2 - Spawn 4
        {-1371.4160, 1483.1453, 11.0391, 179.6778}, // Brod 2 Tim 2 - Spawn 5
        {-1376.8112, 1491.5394, 11.2031, 102.2837}  // Brod 2 Tim 2 - Spawn 6
    },
    
    // ID 4
    {
        {-824.6418, 1633.6637, 27.1172, 93.3689},   // Bull selo Tim 2 - Spawn 1
        {-836.1897, 1625.1027, 27.0607, 93.3689},   // Bull selo Tim 2 - Spawn 2
        {-826.1245, 1616.8228, 26.9609, 219.6435},  // Bull selo Tim 2 - Spawn 3
        {-809.0412, 1622.0024, 27.0231, 287.3241},  // Bull selo Tim 2 - Spawn 4
        {-798.7551, 1631.3950, 26.9534, 287.3241},  // Bull selo Tim 2 - Spawn 5
        {-795.4576, 1619.6836, 27.1172, 199.2766},  // Bull selo Tim 2 - Spawn 6
        {-785.2688, 1616.0450, 27.1172, 199.2766},  // Bull selo Tim 2 - Spawn 7
        // ---- duplikati
        {-824.6418, 1633.6637, 27.1172, 93.3689},   // Bull selo Tim 2 - Spawn 1
        {-836.1897, 1625.1027, 27.0607, 93.3689},   // Bull selo Tim 2 - Spawn 2
        {-826.1245, 1616.8228, 26.9609, 219.6435},  // Bull selo Tim 2 - Spawn 3
        {-809.0412, 1622.0024, 27.0231, 287.3241},  // Bull selo Tim 2 - Spawn 4
        {-798.7551, 1631.3950, 26.9534, 287.3241}   // Bull selo Tim 2 - Spawn 5
    },
    
    // ID 5
    {
        {-2099.5916, -84.9632, 35.3273, 335.9856},  // Urban Tim 2 - Spawn 1
        {-2101.7798, -93.8699, 35.3273, 181.8475},  // Urban Tim 2 - Spawn 2
        {-2108.8240, -85.1621, 35.3273, 63.4064},   // Urban Tim 2 - Spawn 3
        {-2111.8167, -94.7272, 35.3203, 153.4064},  // Urban Tim 2 - Spawn 4
        {-2135.4783, -90.0242, 35.3203, 88.7867},   // Urban Tim 2 - Spawn 5
        {-2140.8054, -98.4146, 35.3203, 88.7867},   // Urban Tim 2 - Spawn 6
        {-2147.6726, -107.9095, 35.3203, 178.7867}, // Urban Tim 2 - Spawn 7
        {-2154.3955, -100.5546, 35.3203, 88.7867},  // Urban Tim 2 - Spawn 8
        // ---- duplikati
        {-2099.5916, -84.9632, 35.3273, 335.9856},  // Urban Tim 2 - Spawn 1
        {-2101.7798, -93.8699, 35.3273, 181.8475},  // Urban Tim 2 - Spawn 2
        {-2108.8240, -85.1621, 35.3273, 63.4064},   // Urban Tim 2 - Spawn 3
        {-2111.8167, -94.7272, 35.3203, 153.4064}   // Urban Tim 2 - Spawn 4
    },
    
    // ID 6
    {
        {1494.2325, 915.8317, 10.9297, 99.2313},    // Skladiste Tim 2 - Spawn 1
        {1488.6959, 907.0805, 10.9297, 158.5244},   // Skladiste Tim 2 - Spawn 2
        {1479.2280, 909.3948, 10.8203, 112.7773},   // Skladiste Tim 2 - Spawn 3
        {1472.2366, 905.9558, 10.9297, 112.7773},   // Skladiste Tim 2 - Spawn 4
        {1477.3889, 914.2444, 10.8203, 332.7159},   // Skladiste Tim 2 - Spawn 5
        {1473.6028, 926.9271, 10.8203, 17.7159},    // Skladiste Tim 2 - Spawn 6
        {1467.7693, 934.6036, 10.8203, 62.7160},    // Skladiste Tim 2 - Spawn 7
        {1485.9788, 933.5637, 10.8203, 323.9425},   // Skladiste Tim 2 - Spawn 8
        {1490.9149, 940.3438, 10.8203, 323.9425},   // Skladiste Tim 2 - Spawn 9
        {1480.3347, 957.4600, 10.8203, 19.4030},    // Skladiste Tim 2 - Spawn 10
        // ----  duplikati
        {1494.2325, 915.8317, 10.9297, 99.2313},    // Skladiste Tim 2 - Spawn 1
        {1488.6959, 907.0805, 10.9297, 158.5244}    // Skladiste Tim 2 - Spawn 2
    },
    
    // ID 7
    {
        {968.9963, -398.9142, 66.3727, 180.7233},   // Desert Tim 2 - Spawn 1
        {983.9328, -397.0551, 68.0043, 267.8307},   // Desert Tim 2 - Spawn 2
        {992.9280, -403.7084, 67.3810, 267.8307},   // Desert Tim 2 - Spawn 3
        {993.6448, -391.2174, 69.9614, 8.7250},     // Desert Tim 2 - Spawn 4
        {981.0726, -390.5914, 68.8795, 98.7251},    // Desert Tim 2 - Spawn 5
        {981.0393, -380.3465, 69.5396, 8.7250},     // Desert Tim 2 - Spawn 6
        {999.2258, -366.5984, 72.4199, 317.3379},   // Desert Tim 2 - Spawn 7
        {1001.6298, -349.1739, 72.8602, 317.3379},  // Desert Tim 2 - Spawn 8
        {1004.9588, -329.2188, 73.5392, 317.3379},  // Desert Tim 2 - Spawn 9
        {997.0716, -317.3533, 71.8416, 47.3379},    // Desert Tim 2 - Spawn 10
        // ---- duplikati
        {968.9963, -398.9142, 66.3727, 180.7233},   // Desert Tim 2 - Spawn 1
        {983.9328, -397.0551, 68.0043, 267.8307}    // Desert Tim 2 - Spawn 2
    },
    
    // ID 8
    {
        {2509.3574, 2839.6155, 10.8203, 185.6679},  // Fabrika Tim 2 - Spawn 1
        {2515.5967, 2843.5376, 10.8203, 301.2889},  // Fabrika Tim 2 - Spawn 2
        {2526.3015, 2841.9453, 10.8203, 259.9286},  // Fabrika Tim 2 - Spawn 3
        {2527.9004, 2830.7371, 10.8203, 192.8746},  // Fabrika Tim 2 - Spawn 4
        {2512.7891, 2824.2605, 10.8203, 130.2073},  // Fabrika Tim 2 - Spawn 5
        {2516.2446, 2815.2021, 10.8203, 202.2747},  // Fabrika Tim 2 - Spawn 6
        {2529.4153, 2813.9397, 10.8203, 254.6018},  // Fabrika Tim 2 - Spawn 7
        {2536.1743, 2805.6716, 10.8203, 254.6018},  // Fabrika Tim 2 - Spawn 8
        // ---- duplikati   
        {2509.3574, 2839.6155, 10.8203, 185.6679},  // Fabrika Tim 2 - Spawn 1
        {2515.5967, 2843.5376, 10.8203, 301.2889},  // Fabrika Tim 2 - Spawn 2
        {2526.3015, 2841.9453, 10.8203, 259.9286},  // Fabrika Tim 2 - Spawn 3
        {2527.9004, 2830.7371, 10.8203, 192.8746}   // Fabrika Tim 2 - Spawn 4
    },
    
    // ID 9
    {
        {-1189.4712,-1047.2743,129.2188,184.6009},  // Ruins Tim 2 - Spawn 1
        {-1191.4048,-1007.0427,129.2188,6.3359},    // Ruins Tim 2 - Spawn 2
        {-1190.3623,-947.2451,129.2119,359.1292},   // Ruins Tim 2 - Spawn 3
        {-1181.6398,-935.2668,129.2188,349.1024},   // Ruins Tim 2 - Spawn 4
        {-1179.3088,-953.9180,129.2119,152.2547},   // Ruins Tim 2 - Spawn 5
        {-1172.6166,-1021.0139,129.2188,183.6608},  // Ruins Tim 2 - Spawn 6
        {-1173.7230,-1052.4855,129.2188,172.6941},  // Ruins Tim 2 - Spawn 7
        // ---- duplikati
        {-1189.4712,-1047.2743,129.2188,184.6009},  // Ruins Tim 2 - Spawn 1
        {-1191.4048,-1007.0427,129.2188,6.3359},    // Ruins Tim 2 - Spawn 2
        {-1190.3623,-947.2451,129.2119,359.1292},   // Ruins Tim 2 - Spawn 3
        {-1181.6398,-935.2668,129.2188,349.1024},   // Ruins Tim 2 - Spawn 4
        {-1179.3088,-953.9180,129.2119,152.2547}    // Ruins Tim 2 - Spawn 5
    },

    // ID 10
    {
        {1118.8593,1225.6051,10.8515,296.7134},  // Rampage Tim 2 - Spawn 1
        {1118.2802,1217.2589,10.8515,308.3069},  // Rampage Tim 2 - Spawn 2
        {1117.3898,1207.3763,10.8515,329.0497},  // Rampage Tim 2 - Spawn 3
        {1110.3070,1225.0594,10.8515,284.6187},  // Rampage Tim 2 - Spawn 4
        {1110.1525,1215.3840,10.8515,291.8255},  // Rampage Tim 2 - Spawn 5
        {1110.5750,1207.8860,10.8515,302.9803},  // Rampage Tim 2 - Spawn 6
        {1105.1971,1225.7769,10.8515,273.2762},  // Rampage Tim 2 - Spawn 7
        {1105.6190,1216.7936,10.8515,286.7496},  // Rampage Tim 2 - Spawn 8
        {1106.5729,1207.7322,10.8515,303.7952},  // Rampage Tim 2 - Spawn 9
        {1102.4047,1213.8831,10.8515,300.8499},  // Rampage Tim 2 - Spawn 10
        // ---- duplikati 
        {1118.8593,1225.6051,10.8515,296.7134},  // Rampage Tim 2 - Spawn 1
        {1118.2802,1217.2589,10.8515,308.3069}   // Rampage Tim 2 - Spawn 2
    },

    // ID 11
    {
        // prvih 5 su razlicite, ostalo su duplikati
        {3895.5144,1196.3871,203.6406,0.6699}, // Railroad Tim 2
        {3891.6086,1187.1132,203.6406,359.5001}, // Railroad Tim 2
        {3879.2925,1191.5795,203.6327,359.7925}, // Railroad Tim 2
        {3859.6624,1189.8705,203.6327,0.9623}, // Railroad Tim 2
        {3844.4973,1191.4510,203.6406,359.7924}, // Railroad Tim 2
        {3895.5144,1196.3871,203.6406,0.6699}, // Railroad Tim 2
        {3891.6086,1187.1132,203.6406,359.5001}, // Railroad Tim 2
        {3879.2925,1191.5795,203.6327,359.7925}, // Railroad Tim 2
        {3859.6624,1189.8705,203.6327,0.9623}, // Railroad Tim 2
        {3844.4973,1191.4510,203.6406,359.7924}, // Railroad Tim 2
        {3859.6624,1189.8705,203.6327,0.9623}, // Railroad Tim 2
        {3844.4973,1191.4510,203.6406,359.7924} // Railroad Tim 2
    }
};

new const Float:war_kamere[12][3] = {
    {-59.9449,      22.0418,    3.1094}, // Farma 1
    {-1443.4912,    -1520.8220, 101.7578}, // Farma 2
    {-1348.6945,    495.9788,   18.2344}, // Brod 1
    {-1421.7767,    1491.3475,  7.1016}, // Brod 2
    {-818.9602,     1564.0802,  26.1588}, // Bull selo
    {-2130.1028,    -183.9911,  35.3203}, // Urban
    {1405.2976,     1067.5577,  10.8203}, // Skladiste
    {1052.4087,     -331.3469,  73.9922}, // Desert
    {2649.7356,     2737.8801,  19.3222}, // Fabrika
    {-1124.0986,    -1129.8904, 129.2259}, // Ruins
    {1136.5549,     1281.3639,  10.8203}, // Rampage
    {3880.9482,     1237.6016,  203.6327} // Railroad
};





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
    Iter_Init(war_igraci_tim);

    war_accept_time = 0;
    war_bets_allowed = false;
    return 1;
}

hook OnPlayerConnect(playerid) 
{
    igrac_u_waru{playerid} = false;
    war_pauza_reload[playerid] = 0;

    gWarBetTeam[playerid] = -1;
    gWarBetStake[playerid] = 0;
    return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
    /*
        TODO: 
        
        da li je u toku prijava igraca za war
        da li se igrac nalazi u war_inout_listitem
        --- ako da, postaviti taj listitem na -1
        
        Izbaciti igraca iz iteratora i poslati poruku o napustanju
    */
    
    if (!igrac_u_waru{playerid}) return 1;
    
    new tim = war_odredi_tim(playerid);
    if (tim == 0) return 1;
    
    RemovePlayerFromWar(playerid);
    
    new razlog[8];
    switch (reason) 
    {
        case 0: razlog = "crash";
        case 1: razlog = "izasao";
        case 2: 
        {
            if (kicked{playerid}) razlog = "izbacen";
            else razlog = "ban";
        }
        default: razlog = "???";
    }
    format(string_128, sizeof string_128, "%s (%s) je napustio server. (%s)", ime_rp[playerid], FACTIONS[PI[playerid][p_org_id]][f_tag], razlog);
    war_msg(0, string_128);
    
    igrac_u_waru{playerid} = false;
    
    return 1;
}


hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart) 
{
    if (!war_aktivan || !igrac_u_waru{playerid}) return 1;
    if (!IsPlayerConnected(issuerid)) return 1;
    if (!igrac_u_waru{issuerid}) return 1;

    war_p_dmg_taken[playerid] += amount;
    war_p_dmg_given[issuerid] += amount;

    PlayerWarScoreAdd(issuerid, amount * 0.01);
    PlayerWarScoreSub(playerid, amount * 0.01);
    
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) 
{
    if (war_aktivan && igrac_u_waru{playerid})
    {
        new
            player_tim = war_odredi_tim(playerid),
            player_rgb[7]
        ;

        // Odredjivanje spawn spawn pozicije nasem igracu
        if (player_tim == 1) 
        {
            new rand = random(12); // 12 je broj spawn pozicija za svaku mapu

            SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), war_spawn_tim1[war_mapa][rand][0], war_spawn_tim1[war_mapa][rand][1], war_spawn_tim1[war_mapa][rand][2], war_spawn_tim1[war_mapa][rand][3], 24, 100, 29, 1000, 31, 1000);
        }
        else if (player_tim == 2) 
        {
            new rand = random(12); // 12 je broj spawn pozicija za svaku mapu

            SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), war_spawn_tim2[war_mapa][rand][0], war_spawn_tim2[war_mapa][rand][1], war_spawn_tim2[war_mapa][rand][2], war_spawn_tim2[war_mapa][rand][3], 24, 100, 29, 1000, 31, 1000);
        }

        if (GetPVarInt(playerid, "pKilledByAdmin") != 1)
        {
            // Dodela poena, itd.
            if (IsPlayerConnected(killerid)) 
            {
                // Igrac je ubijen od strane drugog igraca
                
                if (!igrac_u_waru{killerid}) return 1;
                
                new
                    killer_tim = war_odredi_tim(killerid),
                    killer_rgb[7]
                ;
                
                
                war_p_ubistva[killerid] ++;
                war_p_smrti  [playerid] ++;

                GetFactionRGB(player_tim, player_rgb, sizeof player_rgb);
                GetFactionRGB(killer_tim, killer_rgb, sizeof killer_rgb);
            
                if (player_tim == killer_tim) 
                {
                    // friendly fire (smanji skor za 2)
                    war_skor[killer_tim] -= 2;
                
                    format(string_128, sizeof string_128, "{%s}%s {FFFFFF}je ubio svog saigraca. {%s}%s {FFFFFF}dobija -2 poena.", killer_rgb, ime_rp[killerid], killer_rgb, FACTIONS[PI[playerid][p_org_id]][f_tag]);
                    war_msg(0, string_128);

                    PlayerWarScoreSub(killerid, 2.0);
                    war_UpdateScoreTD(killer_tim);
                }
                else 
                {
                    // ubistvo protivnickog igraca (povecaj skor za 1)
                    war_skor[killer_tim] ++;
                    PlayerWarScoreAdd(killerid, 1.0);

                    // if (PI[playerid][p_org_rank] == RANK_LEADER) { // ubijeni igrac je lider
                    //     war_skor[killer_tim] ++; // dodatni bod za ubistvo lidera (ukupno 2)
                    //     format(string_128, sizeof string_128, "{%s}%s {FFFFFF}je ubio lidera protivnickog tima. {%s}%s {FFFFFF}dobija +2 poena.", killer_rgb, ime_rp[killerid], killer_rgb, FACTIONS[PI[killerid][p_org_id]][f_tag]);
                    //     PlayerWarScoreAdd(killerid, 1.0);
                    // }
                    // else {
                        // new oruzje[21];
                        // GetWeaponName(reason, oruzje, sizeof(oruzje));
                        // format(string_128, sizeof string_128, "{%s}%s {FFFFFF}je ubio protivnika {%s}%s {FFFFFF}(%s)", killer_rgb, ime_rp[killerid], player_rgb, ime_rp[playerid], oruzje);
                    // }

                    new oruzje[21];
                    GetWeaponName(reason, oruzje, sizeof(oruzje));
                    format(string_128, sizeof string_128, "{%s}%s {FFFFFF}je ubio protivnika {%s}%s {FFFFFF}(%s)", killer_rgb, ime_rp[killerid], player_rgb, ime_rp[playerid], oruzje);
                    war_msg(0, string_128);

                    war_UpdateScoreTD(killer_tim);
                }

                war_UpdateSideScoreTD(killerid);
            }
            else if (killerid == INVALID_PLAYER_ID || reason == 54) {
                // Samoubistvo
                war_p_samoubistva[playerid] ++;
                
                war_skor[player_tim] -= 3;
                
                format(string_128, sizeof string_128, "{%s}%s {FFFFFF}je izvrsio samoubistvo. {%s}%s {FFFFFF}dobija -3 poena.", player_rgb, ime_rp[playerid], player_rgb, FACTIONS[PI[playerid][p_org_id]][f_tag]);
                war_msg(0, string_128);

                PlayerWarScoreSub(playerid, 3);
                war_UpdateScoreTD(player_tim);
            }

            //foreach (new i : war_igraci) 
            //    SendDeathMessageToPlayer(i, killerid, playerid, reason);
        }
    }
    return 1;
}
/*
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (!igrac_u_waru{playerid} || war_review < gettime()) return 1;

    if (!(newkeys & KEY_SECONDARY_ATTACK) && oldkeys & KEY_SECONDARY_ATTACK) // Enter
        return RemovePlayerFromWar(playerid);
    
    return 1;
}*/

hook OnPlayerSpawn(playerid)
{
    if (IsPlayerInWar(playerid)) 
    {
        war_spawn(playerid, false);
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward war_msg(tim, const string[]);
forward war_odredi_tim(playerid);
forward war_spawn(playerid, bool:setPos);
forward war_start();
forward war_stop();
forward war_tick();
forward war_kamera();
forward war_UpdatePlayer(playerid);
forward war_ShowScoreboard();

public war_msg(tim, const string[]) 
{
    if (tim != 0 && tim != 1 && tim != 2) 
        return 1;

    new tekst[144];
    format(tekst, 144, "(war) {FFFFFF}%s", string);
    
    if (tim == 0) 
    {
        // Ako je tim == 0, poruku dobijaju oba tima
        foreach (new playerid : war_igraci) 
        {
            SendClientMessage(playerid, SVETLOLJUBICASTA, tekst);
        }
    }
    else if (tim == 1 || tim == 2) 
    {
        foreach (new playerid : war_igraci_tim[tim]) 
        {
            SendClientMessage(playerid, SVETLOLJUBICASTA, tekst);
        }
    }
    
    return 1;
}

public war_odredi_tim(playerid) 
{
    if (war_tim1 == PI[playerid][p_org_id])
        return 1;
    
    else if (war_tim2 == PI[playerid][p_org_id])
        return 2;
    
    else
        return 0;
}

public war_spawn(playerid, bool:setPos) 
{
    if (!IsPlayerConnected(playerid) || !igrac_u_waru{playerid} || !war_aktivan)
        return 1;
    
    TogglePlayerControllable_H(playerid, true);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 927); // 927 = W A R
    SetPlayerHealth(playerid, 99.0);
    SetCameraBehindPlayer(playerid);
    
    ShowMainGuiTD(playerid, false);//Hide

    if (setPos)
    {
        new tim = war_odredi_tim(playerid);
        if (tim == 1) 
        {
            new rand = random(12); // 12 je broj spawn pozicija za svaku mapu
            SetPlayerCompensatedPosEx(playerid, war_spawn_tim1[war_mapa][rand][0], war_spawn_tim1[war_mapa][rand][1], war_spawn_tim1[war_mapa][rand][2], war_spawn_tim1[war_mapa][rand][3]);
        }
        else if (tim == 2) 
        {
            new rand = random(12); // 12 je broj spawn pozicija za svaku mapu
            SetPlayerCompensatedPosEx(playerid, war_spawn_tim2[war_mapa][rand][0], war_spawn_tim2[war_mapa][rand][1], war_spawn_tim2[war_mapa][rand][2], war_spawn_tim2[war_mapa][rand][3]);
        }
        else return 1;

        GivePlayerWeapon(playerid, 24, 100);
        GivePlayerWeapon(playerid, 29, 1000);
        GivePlayerWeapon(playerid, 31, 1000);
    }
    return 1;
}

public war_tick() 
{
    TDSetString(tdWar[23], "%s", konvertuj_vreme(--war_preostalo));

    if (war_preostalo == 0) 
    {
        KillTimer(tmrWarTick);

        if (war_pripreme) 
        {
            war_start();
        }
        else 
        {
            // War je zavrsen, respawnuj igrace ali im oduzmi oruzje


            foreach (new playerid : war_igraci) 
            {
                war_spawn(playerid, true);
                ResetPlayerWeapons(playerid);
            }
            war_stop();

        }
    }
    return 1;
}

public war_start() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("war_start");
    }
 
    // Gametext x2
    format(string_64, 64, "~R~]War poceo]~N~~R~Vas tim protiv tima %s", FACTIONS[war_tim2][f_tag]);
    foreach(new playerid : war_igraci_tim[1]) 
    {
        GameTextForPlayer(playerid, string_64, 5000, 3);
    }
    format(string_64, 64, "~R~]War poceo]~N~~R~Vas tim protiv tima %s", FACTIONS[war_tim1][f_tag]);
    foreach(new playerid : war_igraci_tim[2]) 
    {
        GameTextForPlayer(playerid, string_64, 5000, 3);
    }
    
    KillTimer(tmrWarCam), tmrWarCam = 0;
    foreach(new playerid : war_igraci) 
    {
        war_spawn(playerid, true);
    }
    
    war_pripreme = false;
    war_preostalo = war_trajanje * 60;
    TDSetString(tdWar[23], "%d:00", war_trajanje); // Preostalo vreme za pripreme

    KillTimer(tmrWarTick);
    tmrWarTick = SetTimer("war_tick", 1000, true);
    SetTimer("war_stop_betting", 180000, false);
    
    return 1;
}

forward war_stop_betting();
public war_stop_betting()
{
    war_bets_allowed = false;
}

public war_stop() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("war_stop");
    }

    if (!war_aktivan) return 1;
    
    foreach (new playerid : war_igraci) 
    {
        TogglePlayerControllable_H(playerid, false);
        SetPlayerPos(playerid, war_kamere[war_mapa][POS_X], war_kamere[war_mapa][POS_Y], war_kamere[war_mapa][POS_Z]+50.0);
        ClearChatForPlayer(playerid);
    }
    
    war_kamera_ugao = 0.0;
    war_review = gettime()+10;
    tmrWarCam = SetTimer("war_kamera", 30, true);
    war_msg(0, "War je zavrsen. Automatski ce vas izbaciti iz wara za 10 sekundi."); //Za izlaz pritisnite taster ~k~~VEHICLE_ENTER_EXIT~ (F)
    war_ShowScoreboard();
    war_aktivan = false;
    return 1;
}

forward KickWar();
public KickWar()
{
    if(war_aktivan == true) return 1;

    foreach(new i : Player) {
        if(igrac_u_waru{i})
            RemovePlayerFromWar(i);
    }
    return 1;
}

public war_kamera() 
{
    if ((Iter_Count(war_igraci) == 0 && !war_pripreme) || (war_review < gettime() && !war_aktivan)) 
    {
        KillTimer(tmrWarCam), tmrWarCam = 0;
    }
    else
    {
        #define WAR_CAM_SPEED  0.5
        #define WAR_CAM_RADIUS 35.0

        if(war_kamera_ugao >= 360) war_kamera_ugao = 0;
        war_kamera_ugao += WAR_CAM_SPEED;

        new
            Float:nX = war_kamere[war_mapa][POS_X] + WAR_CAM_RADIUS * floatcos(war_kamera_ugao, degrees),
            Float:nY = war_kamere[war_mapa][POS_Y] + WAR_CAM_RADIUS * floatsin(war_kamera_ugao, degrees)
        ;

        foreach (new playerid : war_igraci) 
        {
            SetPlayerCameraPos(playerid, nX, nY, war_kamere[war_mapa][POS_Z]+50.0);
            SetPlayerCameraLookAt(playerid, war_kamere[war_mapa][POS_X], war_kamere[war_mapa][POS_Y], war_kamere[war_mapa][POS_Z]);
        }
    }
    SetTimer("KickWar", 10*1000, false);
    return 1;
}


/*
    ova funkcija se poziva kada neki igrac napusti war ili kada se war zavrsi
*/
public war_UpdatePlayer(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("war_UpdatePlayer");
    }

        
    if (!IsPlayerConnected(playerid)) return 1;
    
    PI[playerid][p_war_ubistva]     += war_p_ubistva    [playerid];
    PI[playerid][p_war_smrti]       += war_p_smrti      [playerid];
    PI[playerid][p_war_samoubistva] += war_p_samoubistva[playerid];
    PI[playerid][p_war_dmg_taken]   += war_p_dmg_taken  [playerid];
    PI[playerid][p_war_dmg_given]   += war_p_dmg_given  [playerid];
    
    war_p_ubistva[playerid] = war_p_smrti[playerid] = war_p_samoubistva[playerid] = 0;
    war_p_dmg_taken[playerid] = war_p_dmg_given[playerid] = war_p_score[playerid] = 0.0;
    
    format(mysql_upit, 200, "UPDATE igraci SET war_ubistva = %d, war_smrti = %d, war_samoubistva = %d, war_dmg_taken = %.2f, war_dmg_given = %.2f WHERE id = %d", PI[playerid][p_war_ubistva], PI[playerid][p_war_smrti], PI[playerid][p_war_samoubistva], PI[playerid][p_war_dmg_taken], PI[playerid][p_war_dmg_given], PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
    return 1;
}

public war_ShowScoreboard() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("war_ShowScoreboard");
    }

        
    if (!war_aktivan) return 1;

    // Finalni skor oba tima
    TextDrawColor(tdWarResult[2], HexToInt(FACTIONS[war_tim1][f_hex]));
    TextDrawColor(tdWarResult[3], HexToInt(FACTIONS[war_tim2][f_hex]));
    TDSetString(tdWarResult[2], "%s   ~w~%d", FACTIONS[war_tim1][f_tag], war_skor[1]);
    TDSetString(tdWarResult[3], "%s   ~w~%d", FACTIONS[war_tim2][f_tag], war_skor[2]);


    // Spisak igraca oba tima i njihovi skorovi
    new 
        str[12],
        string_spisak[(MAX_PLAYER_NAME + 3)*10], // slova za igracevo ime + za "~n~"
        string_ubistva[(4+3)*10], // cetvorocifreni broj ubistava i 3 za ~n~
        string_smrti[(4+3)*10], // cetvorocifreni broj smrti i 3 za ~n~
        string_dmg[(5+3+3)*10]; // petocifreni broj za dmg, jos 3 za floating point i 3 za ~n~ (20321.22~n~)
    
    for__loop (new tim = 1; tim <= 2; tim++) 
    {
        str[0] = string_spisak[0] = string_ubistva[0] = string_smrti[0] = string_dmg[0] = EOS;
        foreach (new playerid : war_igraci_tim[tim]) 
        {
            if (!IsPlayerConnected(playerid)) continue;

            // Ime igraca
            format(string_32, 32, "%s~n~", ime_rp[playerid]);
            strins(string_spisak, string_32, strlen(string_spisak));

            // Broj ubistava
            format(str, sizeof(str), "%d~n~", war_p_ubistva[playerid]);
            strins(string_ubistva, str, strlen(string_ubistva));

            // Broj smrti
            format(str, sizeof(str), "%d~n~", (war_p_smrti[playerid] + war_p_samoubistva[playerid]));
            strins(string_smrti, str, strlen(string_smrti));

            // Damage given
            format(str, sizeof(str), "%.2f~n~", war_p_dmg_given[playerid]);
            strins(string_dmg, str, strlen(string_dmg));
        }
        // Brisanje ~n~ na kraju svakog stringa
        strdel(string_spisak, strlen(string_spisak)-3, strlen(string_spisak));
        strdel(string_ubistva, strlen(string_ubistva)-3, strlen(string_ubistva));
        strdel(string_smrti, strlen(string_smrti)-3, strlen(string_smrti));
        strdel(string_dmg, strlen(string_dmg)-3, strlen(string_dmg));

        // Setovanje u td; 4*(tim-1) sluzi kako bi ovo setovanje radilo za oba tima, namesta odgovarajuce indekse
        TextDrawSetString(tdWarResult[5 + 4*(tim-1)], string_spisak); // spisak igraca
        TextDrawSetString(tdWarResult[6 + 4*(tim-1)], string_ubistva); // broj ubistava svakog igraca
        TextDrawSetString(tdWarResult[7 + 4*(tim-1)], string_smrti); // broj smrti svakog igraca
        TextDrawSetString(tdWarResult[8 + 4*(tim-1)], string_dmg); // dmg given svakog igraca
    }


    // Racunamo najvise/najmanje ubistava, smrti, dmg taken i dmg given
    // Racunamo ukupan ucinak svakog igraca, i to po sledecoj formuli:
    // Ucinak = kills*1 + deaths*(-1) + suicide*(-3) + dmg_given*(0.01) + dmg_taken*(-0.01)
    new
        Float:ucinak[MAX_PLAYERS], 
        Float: MVP_ucinak = 0.0,    MVP,
        most_kills,                 least_kills,
        most_deaths,                least_deaths,
        most_dmg_taken,             least_dmg_taken,
        most_dmg_given,             least_dmg_given,

        max_kills = 0,              min_kills = 999999,
        max_deaths = 0,             min_deaths = 999999,
        Float:max_dmg_taken = 0.0,  Float:min_dmg_taken = 999999.0,
        Float:max_dmg_given = 0.0,  Float:min_dmg_given = 999999.0;

    if (Iter_Count(war_igraci) == 0) return 1;
    foreach (new playerid : war_igraci) 
    {
        if (!IsPlayerConnected(playerid) || PI[playerid][p_org_id] == -1) continue;

        // Najvise ubistava
        if (war_p_ubistva[playerid] >= max_kills) 
        {
            most_kills = playerid;
            max_kills  = war_p_ubistva[playerid];
        }

        // Najmanje ubistava
        if (war_p_ubistva[playerid] <= min_kills) 
        {
            least_kills = playerid;
            min_kills   = war_p_ubistva[playerid];
        }

        // Najvise smrti
        if (war_p_smrti[playerid] >= max_deaths) 
        {
            most_deaths = playerid;
            max_deaths  = war_p_smrti[playerid];
        }

        // Najmanje smrti
        if (war_p_smrti[playerid] <= min_deaths) 
        {
            least_deaths = playerid;
            min_deaths   = war_p_smrti[playerid];
        }

        // Najvise dmg naneto/given
        if (war_p_dmg_given[playerid] >= max_dmg_given) 
        {
            most_dmg_given = playerid;
            max_dmg_given  = war_p_dmg_given[playerid];
        }

        // Najmanje dmg naneto/given
        if (war_p_dmg_given[playerid] <= min_dmg_given) 
        {
            least_dmg_given = playerid;
            min_dmg_given   = war_p_dmg_given[playerid];
        }

        // Najvise dmg primljeno/taken
        if (war_p_dmg_taken[playerid] >= max_dmg_taken) 
        {
            most_dmg_taken = playerid;
            max_dmg_taken  = war_p_dmg_taken[playerid];
        }

        // Najmanje dmg primljeno/taken
        if (war_p_dmg_taken[playerid] <= min_dmg_taken) 
        {
            least_dmg_taken = playerid;
            min_dmg_taken   = war_p_dmg_taken[playerid];
        }


        // Racunamo ucinak/ukupan skor svakog igraca
       /* ucinak[playerid] =  war_p_ubistva[playerid] * 1.0         +
                            war_p_smrti[playerid] * (-1.0)        +
                            war_p_samoubistva[playerid] * (-3.0)  +
                            war_p_dmg_given[playerid] * (0.01)    +
                            war_p_dmg_taken[playerid] * (-0.01);*/

        // Trazimo MVP-a
        if (war_p_score[playerid] >= MVP_ucinak) 
        {
            MVP = playerid;
            MVP_ucinak = ucinak[playerid];
        }
    }
    TextDrawSetString(tdWarResult[15], ime_rp[most_kills]);
    TextDrawSetString(tdWarResult[16], ime_rp[least_kills]);
    TextDrawSetString(tdWarResult[17], ime_rp[most_deaths]);
    TextDrawSetString(tdWarResult[18], ime_rp[least_deaths]);
    TextDrawSetString(tdWarResult[20], ime_rp[most_dmg_given]);
    TextDrawSetString(tdWarResult[21], ime_rp[least_dmg_given]);
    TextDrawSetString(tdWarResult[22], ime_rp[most_dmg_taken]);
    TextDrawSetString(tdWarResult[23], ime_rp[least_dmg_taken]);
    TextDrawColor(tdWarResult[15], HexToInt(FACTIONS[PI[most_kills][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[16], HexToInt(FACTIONS[PI[least_kills][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[17], HexToInt(FACTIONS[PI[most_deaths][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[18], HexToInt(FACTIONS[PI[least_deaths][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[20], HexToInt(FACTIONS[PI[most_dmg_given][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[21], HexToInt(FACTIONS[PI[least_dmg_given][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[22], HexToInt(FACTIONS[PI[most_dmg_taken][p_org_id]][f_hex]));
    TextDrawColor(tdWarResult[23], HexToInt(FACTIONS[PI[least_dmg_taken][p_org_id]][f_hex]));
    TDSetString(tdWarResult[24], "MVP:   %s", ime_rp[MVP]);


    // Prikazivanje svih TD-ova
    new
        pobeda_td_id = (war_skor[1]==war_skor[2])?25:26,
        pobednik = ((war_skor[1]!=war_skor[2])? ((war_skor[1]>war_skor[2])? war_tim1 : war_tim2) : (-1)),
        gubitnik = ((pobednik==war_tim1)? war_tim2 : ((pobednik==war_tim2)? war_tim1 : (-1)))

    ;
    if (pobednik != -1) 
    {
        TextDrawColor(tdWarResult[26], HexToInt(FACTIONS[pobednik][f_hex]));
        TDSetString(tdWarResult[26], "%s pobeda", FACTIONS[pobednik][f_tag]);
    }

    foreach (new playerid : war_igraci) 
    {
        for__loop (new i = 0; i <= 24; i++) 
        {
            // Prikazujemo sve do MVP-a
            TextDrawShowForPlayer(playerid, tdWarResult[i]);
        }

        TextDrawShowForPlayer(playerid, tdWarResult[pobeda_td_id]);
    }

    // Dodavanje i oduzimanje para i skilla
    if (pobednik == -1) 
    {
        // Nereseno, vratiti novac, skill na status quo
        FactionMoneyAdd(war_tim1, war_ulog);
        FactionMoneyAdd(war_tim2, war_ulog);
    }
    else 
    {
        // Imamo pobednika i gubitnika
        FactionMoneyAdd(pobednik, war_ulog*2);

        foreach (new playerid : Player)
        {
            if (PI[playerid][p_org_id] == pobednik)
            {
                PlayerUpdateCriminalSkill(playerid, 3, SKILL_WAR_WIN, 0);
            }
            else if (PI[playerid][p_org_id] == gubitnik)
            {
                PlayerUpdateCriminalSkill(playerid, -3, SKILL_WAR_LOSE, 0);
            }
        }
    }

    war_processBets(pobednik);

    // Cuvanje statistike pobeda/poraza + string 
    new sWinningTeam[16];
    if (pobednik == -1 || gubitnik == -1)
    {
        // Nereseno
        FACTIONS[war_tim1][f_wars_draw] += 1;
        FACTIONS[war_tim2][f_wars_draw] += 1;
        format(sWinningTeam, sizeof sWinningTeam, "{FFFFFF}Nereseno");
    }
    else
    {
        FACTIONS[pobednik][f_wars_won]  += 1;
        FACTIONS[gubitnik][f_wars_lost] += 1;
        format(sWinningTeam, sizeof sWinningTeam, "{00FF00}%s", FACTIONS[pobednik][f_tag]);
    }

    // Ispisivanje info za sve clanove + adminima
    new string[85];
    format(string, sizeof string, "(war) {FFFFFF}WAR ZAVRSEN | %s - %s | Pobednik: %s", FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_tag], sWinningTeam);
    foreach(new i : Player) 
    {
        if (PI[i][p_org_id] == war_tim1 || PI[i][p_org_id] == war_tim2 || IsAdmin(i, 1))
            SendClientMessage(i, SVETLOLJUBICASTA, string);
    }

    new query[86];
    format(query, sizeof query, "UPDATE factions SET wars_won = %d, wars_lost = %d, wars_draw = %d WHERE id = %d", FACTIONS[war_tim1][f_wars_won], FACTIONS[war_tim1][f_wars_lost], FACTIONS[war_tim1][f_wars_draw], war_tim1);
    mysql_tquery(SQL, query);
    format(query, sizeof query, "UPDATE factions SET wars_won = %d, wars_lost = %d, wars_draw = %d WHERE id = %d", FACTIONS[war_tim2][f_wars_won], FACTIONS[war_tim2][f_wars_lost], FACTIONS[war_tim2][f_wars_draw], war_tim2);
    mysql_tquery(SQL, query);
    return 1;
}

forward war_processBets(winner_fid);
public war_processBets(winner_fid)
{
    mysql_tquery(SQL, "SELECT * FROM war_bets", "MySQL_ProcessBets", "i", winner_fid);
}

stock PlayerWarScoreAdd(playerid, Float:add) 
{
    war_p_score[playerid] += add;
    return 1;
}

stock PlayerWarScoreSub(playerid, Float:sub) 
{
    war_p_score[playerid] -= sub;
    return 1;
}

stock IsPlayerInWar(playerid) 
{
    return igrac_u_waru{playerid};
}

stock war_PodesiTimTD(tim) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("war_PodesiTimTD");
    }

        
    // Tim 1: tdWar[0] do tdWar[9]
    // Tim 2: tdWar[10] do tdWar[19]

    new
        tdPocetak = (tim==1)?0:10;

    // Sakriva sve TD-ove tima
    for__loop (new i = tdPocetak; i < tdPocetak+10; i++) {
        TextDrawHideForAll(tdWar[i]);
    }

    // Ide redom kroz iterator tima
    new 
        tdCounter = tdPocetak;
    foreach (new playerid : war_igraci_tim[tim]) {
        if (!IsPlayerConnected(playerid)) continue;

        TDSetString(tdWar[tdCounter++], "%s (%d)", ime_rp[playerid], war_p_ubistva[playerid]);
        war_side_td_id[playerid] = tdCounter-1;
    }

    for__loop (new i = tdPocetak; i < tdCounter; i++) {
        foreach(new playerid : war_igraci)
            TextDrawShowForPlayer(playerid, tdWar[i]);
    }

    return 1;
}

stock war_UpdateScoreTD(tim) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "war_UpdateScoreTD");
    #endif
    
    if (tim != 1 && tim != 2) return 0;

    new 
        fid = (tim==1)? war_tim1 : war_tim2;
    TDSetString(tdWarRezultat[tim], "%s: ~w~%d", FACTIONS[fid][f_tag], war_skor[tim]);
    return 1;
}

stock war_UpdateSideScoreTD(playerid) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "war_UpdateSideScoreTD");
    #endif
        
    TDSetString(tdWar[war_side_td_id[playerid]], "%s (%d)", ime_rp[playerid], floatround(war_p_score[playerid]));
    return 1;
}

stock RemovePlayerFromWar(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("RemovePlayerFromWar");
    }

        
    Iter_Remove(war_igraci, playerid);
    igrac_u_waru{playerid} = false;
        
    new
        tim = war_odredi_tim(playerid);
    if (tim != 1 && tim != 2) return 1;


    war_UpdatePlayer(playerid);
    Iter_Remove(war_igraci_tim[tim], playerid);
    
    // TextDraws
    war_PodesiTimTD(1), war_PodesiTimTD(2);

    // Spawna igraca na njegovom spawnu
    SpawnPlayer_H(playerid);

    if (IsPlayerConnected(playerid)) 
    {
        for (new i = 0; i < sizeof(tdWar); i++)
            TextDrawHideForPlayer(playerid, tdWar[i]);

        for (new i = 0; i < sizeof(tdWarResult); i++)
            TextDrawHideForPlayer(playerid, tdWarResult[i]);

        ClearDeathFeedForPlayer(playerid);
    }
    return 1;
}

stock IsWarActive() 
{
    return (war_aktivan)? 1 : 0;
}

stock IsTeamInWar(f_id) 
{
    if (IsWarActive() && (war_tim1 == f_id || war_tim2 == f_id)) return 1;
    return 0;
}

WAR_LoadPlayerBets(playerid)
{
    new sQuery[52];
    format(sQuery, sizeof sQuery, "SELECT fid, stake FROM war_bets WHERE pid = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery, "MySQL_LoadPlayerWarBets", "ii", playerid, cinc[playerid]);
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_WarTopPlayers(playerid, ccinc);
public MySQL_WarTopPlayers(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);
    if (!rows) return ErrorMsg(playerid, GRESKA_NEPOZNATO);

    new dStr[580];
    format(dStr, sizeof dStr, "Igrac\tUbistva\tSmrti\n%s\t%i\t%i\n-----", ime_obicno[playerid], PI[playerid][p_war_ubistva], PI[playerid][p_war_smrti]);
    for__loop (new i = 0; i < rows; i++)
    {
        new ime[MAX_PLAYER_NAME], ubistva, smrti;
        cache_get_value_index(i, 0, ime, sizeof ime);
        cache_get_value_index_int(i, 1, ubistva);
        cache_get_value_index_int(i, 2, smrti);

        format(dStr, sizeof dStr, "%s\n%s\t%i\t%i", dStr, ime, ubistva, smrti);
    }

    SPD(playerid, "war_stats_2", DIALOG_STYLE_TABLIST_HEADERS, "War statistike: top igraci", dStr, "<< Nazad", "Izadji");
    return 1;
}

forward MySQL_ProcessBets(winner_fid);
public MySQL_ProcessBets(winner_fid)
{
    cache_get_row_count(rows);

    if (rows)
    {
        new 
            stakeSum = 0,
            stakeSumWinners = 0
        ;

        for (new i = 0; i < rows; i++)
        {
            new stake, fid;
            cache_get_value_name_int(i, "fid", fid);
            cache_get_value_name_int(i, "stake", stake);

            printf("[MySQL_ProcessBets] [loop 1] [row %i] [fid: %i] [stake: %i]", i, fid, stake);

            stakeSum += stake;
            if (fid == winner_fid)
                stakeSumWinners += stake;
        }

        printf("[MySQL_ProcessBets] ------------------ [stakeSum: %i] [stakeSumWinners: %i]", stakeSum, stakeSumWinners);

        for (new i = 0; i < rows; i++)
        {
            new stake, fid, pid;
            cache_get_value_name_int(i, "pid", pid);
            cache_get_value_name_int(i, "fid", fid);
            cache_get_value_name_int(i, "stake", stake);

            printf("[MySQL_ProcessBets] [loop 2] [row %i] [pid: %i] [fid: %i] [stake: %i]", i, pid, fid, stake);

            if (fid == winner_fid)
            {
                // Igrac se kladio na pobednicki tim

                new playerWinnings = floatround(floatdiv(float(stakeSum), float(stakeSumWinners)) * stake); // Koliko para taj igrac osvaja

                printf("[MySQL_ProcessBets] [loop 2] Winner! %s", formatMoneyString(playerWinnings));
                
                // Upisuje se u bazu
                new sQuery[116];
                format(sQuery, sizeof sQuery, "INSERT INTO war_winnings VALUES (%i, %i) ON DUPLICATE KEY UPDATE amount = amount + %i", pid, playerWinnings, playerWinnings);
                mysql_tquery(SQL, sQuery);

                // Cmd da vide stanje na svom kladionicarskom racunu ;)
            }
        }


        // Loop kroz sve igrace, gde saljemo poruke online igracima koji su dobili na kladionici
        foreach (new i : Player)
        {
            if (gWarBetTeam[i] == winner_fid)
            {
                SendClientMessageF(i, SVETLOLJUBICASTA, "(war bet) {FFFFFF}Pogodio si pobednika u waru. Novac mozes podici u zgradi Lutrije.");
            }

            gWarBetTeam[i] = -1;
            gWarBetStake[i] = 0;
        }

        mysql_tquery(SQL, "TRUNCATE war_bets");
    }
    return 1;
}

forward MySQL_LoadPlayerWarBets(playerid, ccinc);
public MySQL_LoadPlayerWarBets(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc)) return 1;

    cache_get_row_count(rows);

    if (rows && war_aktivan)
    {
        new fid, stake;
        cache_get_value_name_int(0, "fid", fid);
        cache_get_value_name_int(0, "stake", stake);

        if (war_tim1 == fid || war_tim2 == fid)
        {
            gWarBetTeam[playerid] = fid;
            gWarBetStake[playerid] = stake;
        }
    }

    return 1;
}

forward MySQL_LoadWarWinnings(playerid, ccinc);
public MySQL_LoadWarWinnings(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);

    if (rows == 1)
    {
        new winnings;
        cache_get_value_index_int(0, 0, winnings);

        if (winnings < 1 || winnings > 999999999)
            return ErrorMsg(playerid, GRESKA_NEPOZNATO);

        PlayerMoneyAdd(playerid, winnings);
        SendClientMessageF(playerid, SVETLOLJUBICASTA, "(war bet) {FFFFFF}Uspesno si podigao {8080FF}%s {FFFFFF}koje si osvojio na War kladionici.", formatMoneyString(winnings));

        new sQuery[46];
        format(sQuery, sizeof sQuery, "DELETE FROM war_winnings WHERE pid = %i", PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery);
    }
    else return ErrorMsg(playerid, "Nemas dobitke na cekanju.");

    return 1;
}





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:war(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;
    
    if (!IsAdmin(playerid, 1))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);
    
    switch (listitem) 
    {
        case 0: // Pokreni war
        {
            if (war_aktivan) 
                return ErrorMsg(playerid, "War je vec aktiviran.");
            
            // #warning Vratiti cooldown na war
            if (war_review > gettime())
                return ErrorMsg(playerid, "Mora proci bar 5 minuta izmedju warova.");
            
            new item = 0;
            
            new sDialog[MAX_FACTIONS*44];
            sDialog[0] = EOS;
            for__loop (new i = 0; i < MAX_FACTIONS; i++) 
            {
                // if (FACTIONS[i][f_vrsta] != FACTION_MAFIA && FACTIONS[i][f_vrsta] != FACTION_GANG) continue; // samo mafije i bande!
                
                format(sDialog, sizeof sDialog, "%s\n%s (%s)", sDialog, FACTIONS[i][f_naziv], FACTIONS[i][f_tag]);
                war_mafia_gang_listitem[item++] = i;
            }
            
            SPD(playerid, "war_start_tim1", DIALOG_STYLE_LIST, "[war] Tim 1", sDialog, "Dalje >", "< Nazad");
        }
        
        case 1: // Zaustavi war
        {
            if (!war_aktivan)
                return ErrorMsg(playerid, "War nije aktiviran.");
            
            new sMsg[90];
            format(sMsg, sizeof sMsg, "{FF6347}- STAFF:{B4CDED} %s je prekinuo war izmedju %s i %s.", ime_rp[playerid], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_tag]);

            foreach(new i : Player) 
            {
                if (PI[i][p_admin] > 0 || igrac_u_waru{i}) 
                {
                    SendClientMessage(i, BELA, sMsg);
                    war_spawn(i, true);
                    ResetPlayerWeapons(i);
                }
            }
            
            KillTimer(tmrWarCam);
            KillTimer(tmrWarTick);
            war_stop();
        }
        
        case 2: // War informacije
        {
            if (!war_aktivan)
                return ErrorMsg(playerid, "War nije aktiviran.");

            new sDialog[140], rgb1[7], rgb2[7], ftag1[8], ftag2[8];
            GetFactionRGB(war_tim1, rgb1, sizeof rgb1);
            GetFactionRGB(war_tim2, rgb2, sizeof rgb2);
            GetFactionTag(war_tim1, ftag1, sizeof ftag1);
            GetFactionTag(war_tim2, ftag2, sizeof ftag2);
            format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {%s}%s {8080FF}(%i)\n{FFFFFF}Tim 2: {%s}%s {8080FF}(%i)\n{FFFFFF}Preostalo trajanje: {8080FF}%s", rgb1, ftag1, war_skor[1], rgb2, ftag2, war_skor[2], konvertuj_vreme(war_preostalo));

            SPD(playerid, "war_info", DIALOG_STYLE_MSGBOX, "War informacije", sDialog, "Nazad", "");
        }
        
        case 3: // Lider panel
        {
            if (!war_aktivan)
                return ErrorMsg(playerid, "War nije aktiviran.");

            if (PI[playerid][p_org_rank] != RANK_LEADER && PI[playerid][p_org_id] != war_tim1 && PI[playerid][p_org_id] != war_tim2)
                return ErrorMsg(playerid, "Niste lider ni jednog tima koji ucestvuju u waru.");

            SPD(playerid, "war_lider", DIALOG_STYLE_LIST, "War panel", "Pokreni war\nUbaci igraca\nIzbaci igraca\nPauza (60 sekundi)", "Dalje >", "Izadji");
        }
    }
    
    return 1;
}

Dialog:war_start_tim1(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
        return callcmd::war(playerid, "");
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");
    
    war_tim1 = war_mafia_gang_listitem[listitem];
    war_return_listitem1[playerid] = listitem; // koristi se kasnije zbog lakseg povratka na prethodni dialog
    
    new item = 0,
        sDialog[MAX_FACTIONS*42];
    
    sDialog[0] = EOS;
    for__loop (new i = 0; i < MAX_FACTIONS; i++) 
    {
        // if (FACTIONS[i][f_vrsta] != FACTION_MAFIA && FACTIONS[i][f_vrsta] != FACTION_GANG) continue; // samo mafije i bande!
        
        format(sDialog, sizeof sDialog, "%s\n%s (%s)", sDialog, FACTIONS[i][f_naziv], FACTIONS[i][f_tag]);
        war_mafia_gang_listitem[item++] = i;
    }
    
    SPD(playerid, "war_start_tim2", DIALOG_STYLE_LIST, "[war] Tim 2", sDialog, "Dalje >", "< Nazad");
    
    return 1;
}

Dialog:war_start_tim2(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
        return d_war(playerid, 1, 0, "");
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");
    
    war_tim2 = war_mafia_gang_listitem[listitem];
    war_return_listitem2[playerid] = listitem; // koristi se kasnije zbog lakseg povratka na prethodni dialog
    
    if (war_tim1 == war_tim2)
        return ErrorMsg(playerid, "Ne mozete izabrati istu mafiju/bandu dva puta.");
    
    new sDialog[212];
    format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {8080FF}%s (%s)\n{FFFFFF}Tim 2: {8080FF}%s (%s)\n\n{FFFFFF}Unesite iznos uloga - koliko novca ce obe strane uloziti:", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_naziv], FACTIONS[war_tim2][f_tag]);
    SPD(playerid, "war_start_ulog", DIALOG_STYLE_INPUT, "[war] Iznos uloga", sDialog, "Dalje >", "< Nazad");
    
    return 1;
}

Dialog:war_start_ulog(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
        return d_war_start_tim1(playerid, 1, war_return_listitem1[playerid], "");
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    new ulog;
    if (sscanf(inputtext, "i", ulog))
        return DialogReopen(playerid);
    
    if (ulog < 0 || ulog > 99999999)
        return DialogReopen(playerid);
    
    if (GetFactionMoney(war_tim1) < ulog) {
        ErrorMsg(playerid, "Tim 1 nema dovoljno novca u kasi.");
        return DialogReopen(playerid);
    }
    
    if (GetFactionMoney(war_tim2) < ulog) {
        ErrorMsg(playerid, "Tim 2 nema dovoljno novca u kasi.");
        return DialogReopen(playerid);
    }
    
    war_ulog = ulog;
    
    new sDialog[230];
    format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {8080FF}%s (%s)\n{FFFFFF}Tim 2: {8080FF}%s (%s)\n{FFFFFF}Ulog: {8080FF}%s\n\n{FFFFFF}Unesite trajanje wara u minutima (10-90 min):", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_naziv], FACTIONS[war_tim2][f_tag], formatMoneyString(war_ulog));
    SPD(playerid, "war_start_trajanje", DIALOG_STYLE_INPUT, "[war] Trajanje", sDialog, "Dalje >", "< Nazad");
    
    return 1;
}

Dialog:war_start_trajanje(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
        return d_war_start_tim2(playerid, 1, war_return_listitem2[playerid], "");
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    new trajanje;
    if (sscanf(inputtext, "i", trajanje))
        return DialogReopen(playerid);
    
    if (trajanje < 5 || trajanje > 90) {
        ErrorMsg(playerid, "War mora trajati izmedju 5 i 90 minuta.");
        return DialogReopen(playerid);
    }
    
    war_trajanje = trajanje;
    
    new sDialog[262];
    format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {8080FF}%s (%s)\n{FFFFFF}Tim 2: {8080FF}%s (%s)\n{FFFFFF}Ulog: {8080FF}%s\n{FFFFFF}Trajanje: {8080FF}%d min\n\n{FFFFFF}Unesite dozvoljeni broj ucesnika po timu:", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_naziv], FACTIONS[war_tim2][f_tag], formatMoneyString(war_ulog), war_trajanje);
    SPD(playerid, "war_start_broj_ucesnika", DIALOG_STYLE_INPUT, "[war] Broj ucesnika", sDialog, "Dalje >", "< Nazad");
    return 1;
}

Dialog:war_start_broj_ucesnika(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
    {
        new str[10];
        valstr(str, war_ulog);
        return d_war_start_ulog(playerid, 1, 0, str);
    }
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    new broj_ucesnika;
    if (sscanf(inputtext, "i", broj_ucesnika))
        return DialogReopen(playerid);
    
    if (broj_ucesnika < 3 || broj_ucesnika > 10) 
    {
        ErrorMsg(playerid, "Broj ucesnika mora biti izmedju 3 i 10.");
        return DialogReopen(playerid);
    }
    
    war_broj_ucesnika = broj_ucesnika;
    
    new sDialog[sizeof(war_mape) * 12];
    sDialog[0] = EOS;
    for__loop (new i = 0; i < sizeof(war_mape); i++) 
    {
        format(sDialog, sizeof sDialog, "%s\n%s", sDialog, war_mape[i]);
    }
    
    SPD(playerid, "war_start_mapa", DIALOG_STYLE_LIST, "[war] Mapa", sDialog, "Dalje >", "< Nazad");
    return 1;
}

Dialog:war_start_mapa(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
    {
        new str[4];
        valstr(str, war_trajanje);
        return d_war_start_trajanje(playerid, 1, 0, str);
    }
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");
    
    war_mapa = listitem;
    
    new sDialog[330];
    format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {8080FF}%s (%s)\n{FFFFFF}Tim 2: {8080FF}%s (%s)\n{FFFFFF}Ulog: {8080FF}%s\n{FFFFFF}Trajanje: {8080FF}%d min\n{FFFFFF}Broj ucesnika: {8080FF}%d\n{FFFFFF}Mapa: {8080FF}%s\n\n{FFFFFF}Da li zelite da pokrenete war?", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_naziv], FACTIONS[war_tim2][f_tag], formatMoneyString(war_ulog), war_trajanje, war_broj_ucesnika, war_mape[war_mapa]);
    SPD(playerid, "war_start_potvrda", DIALOG_STYLE_MSGBOX, "[war] Provera podataka", sDialog, "Pokreni", "Odustani");
    
    return 1;
}

Dialog:war_start_potvrda(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
    {
        if (IsLeader(playerid) && !IsAdmin(playerid, 1))
        {
            war_accept_time = 0;
            return FactionMsg(war_tim1, "Vas izazov za war je odbijen.");
        }
        else
        {
            return callcmd::war(playerid, "");
        }
    }
            
    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    if (IsLeader(playerid) && !IsAdmin(playerid, 1))
    {
        if (war_accept_time < gettime())
        {
            return ErrorMsg(playerid, "Isteklo je vreme za potvrdu. Potrebno je ponovo poslati izazov za war.");
        }
    }

    mysql_tquery(SQL, "TRUNCATE war_bets");
    
    war_aktivan = true;
    war_pripreme = true;
    war_bets_allowed = true;
    
    Iter_Clear(war_igraci);
    Iter_Clear(war_igraci_tim[1]);
    Iter_Clear(war_igraci_tim[2]);
    for__loop (new i = 1; i < 3; i++) 
    {
        war_prijavljeno[i] = war_skor[i] = war_ubistva[i] = war_smrti[i] = war_samoubistva[i] = 0;
    }
    war_preostalo = 90;
    KillTimer(tmrWarTick);
    tmrWarTick = SetTimer("war_tick", 1000, true);


    // --------------------------------------------
    // TextDraws
    new
        boja_int,
        boja_str[11]
    ;
    tdWarRezultat[1] = tdWar[21];
    tdWarRezultat[2] = tdWar[22];
    TextDrawColor(tdWarRezultat[1], HexToInt(FACTIONS[war_tim1][f_hex])); // Promena boje za skor prvog tima
    TextDrawColor(tdWarRezultat[2], HexToInt(FACTIONS[war_tim2][f_hex])); // Promena boje za skor drugog tima
    TDSetString(tdWarRezultat[1], "%s: ~w~0", FACTIONS[war_tim1][f_tag]); // Skor prvog tima
    TDSetString(tdWarRezultat[2], "%s: ~w~0", FACTIONS[war_tim2][f_tag]); // Skor drugog tima
    TextDrawSetString(tdWar[23], "01:30"); // Preostalo vreme za pripreme
    TDSetString(tdWar[24], war_mape[war_mapa]); // Naziv mape
    TDSetString(tdWar[25], "%d  vs  %d", war_broj_ucesnika, war_broj_ucesnika); // Broj ucesnika npr "5 vs 5"

    // Podesavanje boje za timove (20 TD-ova sa strane)
    format(boja_str, sizeof(boja_str), "0x%s64", FACTIONS[war_tim1][f_rgb]);
    boja_int = HexToInt(boja_str);
    for__loop (new i = 0; i <= 9; i++)
    {
        TextDrawBoxColor(tdWar[i], boja_int);
    }

    format(boja_str, sizeof(boja_str), "0x%s64", FACTIONS[war_tim2][f_rgb]);
    boja_int = HexToInt(boja_str);
    for__loop (new i = 10; i <= 19; i++)
    {
        TextDrawBoxColor(tdWar[i], boja_int);
    }
    // --------------------------------------------


    // Podesavanje kamere
    war_kamera_ugao = 0.0;
    tmrWarCam = SetTimer("war_kamera", 30, true);

    
    // Ispisivanje poruka svim igracima
    new string[144];
    format(string, sizeof string, "(war) {FFFFFF}%s | %s - %s | %d minuta | %d vs %d | Ulog: $%d", war_mape[war_mapa], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_tag], war_trajanje, war_broj_ucesnika, war_broj_ucesnika, war_ulog);

    foreach(new i : Player) 
    {
        // if (PI[i][p_org_id] == war_tim1 || PI[i][p_org_id] == war_tim2 || IsAdmin(i, 1))
        SendClientMessage(i, SVETLOLJUBICASTA, string);

        if (PI[i][p_org_rank] == RANK_LEADER)
            SendClientMessage(i, BELA, "* Vreme za pripremu je 90 sekundi. Koristite /war da sastavite svoj tim.");


        SendClientMessage(i, BELA, "** Za kladenje koristite komandu {8080FF}/bet.   {FFFFFF}Raspolozivo vreme: {8080FF}4 minuta.");

        gWarBetTeam[i] = -1;
        gWarBetStake[i] = 0;
    }

    // Oduzimanje novca od oba tima
    FactionMoneySub(war_tim1, war_ulog);
    FactionMoneySub(war_tim2, war_ulog);

    foreach (new i : Player)
    {
        igrac_u_waru{i} = false;
    }
    
    return 1;
}

Dialog:war_lider(playerid, response, listitem, const inputtext[]) 
{
    new 
        fid = PI[playerid][p_org_id], // faction id
        tim = war_odredi_tim(playerid),
        war_broj_igraca = 0
    ;
    
    if (!response) 
    {
        for__loop (new i = 0; i < 13; i++) 
        {
            war_inout_listitem[tim][i] = -1;
        }
    }
    
    switch (listitem) 
    {
        case 0: // Pokreni war
        {
            if (war_aktivan) 
                return ErrorMsg(playerid, "War je vec aktiviran.");
            
            if (war_review > gettime())
                return ErrorMsg(playerid, "Mora proci bar 5 minuta izmedju warova.");

            if (war_accept_time > gettime())
                return ErrorMsg(playerid, "Neko vec pokrece war, molimo sacekajte svoj red.");

            war_accept_time = gettime() + 60; // da neko drugi ne bi probao da pokrene war
            
            new item = 0;
            
            new sDialog[MAX_FACTIONS*44];
            sDialog[0] = EOS;
            for__loop (new i = 0; i < MAX_FACTIONS; i++) 
            {
                // if (FACTIONS[i][f_vrsta] != FACTION_MAFIA && FACTIONS[i][f_vrsta] != FACTION_GANG) continue; // samo mafije i bande!
                
                format(sDialog, sizeof sDialog, "%s\n%s (%s)", sDialog, FACTIONS[i][f_naziv], FACTIONS[i][f_tag]);
                war_mafia_gang_listitem[item++] = i;
            }
            
            SPD(playerid, "war_lider_start", DIALOG_STYLE_LIST, "[war] Protivnik", sDialog, "Dalje >", "< Nazad");
        }

        case 1: // Ubaci igraca
        {
            if (!war_aktivan) 
                return ErrorMsg(playerid, "War nije aktiviran.");
            
            if (tim == 0)
                return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");


            if (Iter_Count(war_igraci_tim[tim]) == war_broj_ucesnika) 
            {
                ErrorMsg(playerid, "Prijavili ste maksimalni broj igraca.");
                return DialogReopen(playerid);
            }
            
            new sDialog[27 * MAX_FACTIONS_MEMBERS];
            sDialog[0] = EOS;
            foreach(new i : Player) 
            {
                if (PI[i][p_org_id] == fid && !igrac_u_waru{i}) 
                {
                    war_inout_listitem[tim][war_broj_igraca++] = i;
                    format(sDialog, sizeof sDialog, "%s\n%s", sDialog, ime_rp[i]);
                }
            }
            if (war_broj_igraca == 0)
                return ErrorMsg(playerid, "Nema ni jednog igraca kojeg mozete ubaciti u war.");
            
            SPD(playerid, "war_lider_ubaci", DIALOG_STYLE_LIST, "[war] Ubacivanje igraca", sDialog, "Ubaci", "Nazad");
        }
        case 2: // Izbaci igraca
        {
            if (!war_aktivan) 
                return ErrorMsg(playerid, "War nije aktiviran.");
            
            if (tim == 0)
                return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");

            if (Iter_Count(war_igraci_tim[tim]) == 0) 
            {
                ErrorMsg(playerid, "Nema ni jednog igraca kojeg mozete izbaciti iz wara.");
                return DialogReopen(playerid);
            }
            
            new sDialog[27 * MAX_FACTIONS_MEMBERS];
            sDialog[0] = EOS;
            foreach(new i : Player) 
            {
                if (PI[i][p_org_id] == fid && igrac_u_waru{i})
                {
                    war_inout_listitem[tim][war_broj_igraca++] = i;
                    format(sDialog, sizeof sDialog, "%s\n%s", sDialog, ime_rp[i]);
                }
            }
            
            SPD(playerid, "war_lider_izbaci", DIALOG_STYLE_LIST, "[war] Izbacivanje igraca", sDialog, "Izbaci", "Nazad");
        }
        case 3: // Pauza
        {
            if (!war_aktivan) 
                return ErrorMsg(playerid, "War nije aktiviran.");
            
            if (tim == 0)
                return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");

            if (war_pauza_reload[playerid] > gettime())
                return ErrorMsg(playerid, "Mora proci 3 minuta od zavrsetka prethodne pauze.");

            InfoMsg(playerid, "Pauziranje trenutno nije dostupno."); // TODO
        }
    }

    return 1;
}

Dialog:war_lider_start(playerid, response, listitem, const inputtext[])
{
    if (!response) 
    {
        if (IsAdmin(playerid, 2))
          return callcmd::war(playerid, "");

        else return 1;
    }

    new fid = PI[playerid][p_org_id]; // faction id

    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    if (fid == war_mafia_gang_listitem[listitem])
    {
        DialogReopen(playerid);
        return ErrorMsg(playerid, "Pogresan izbor.");
    }

    new targetid[2];
    targetid[0] = GetPlayerIDFromName(F_LEADERS[war_mafia_gang_listitem[listitem]][0]);
    targetid[1] = GetPlayerIDFromName(F_LEADERS[war_mafia_gang_listitem[listitem]][1]);

    if (!IsPlayerConnected(targetid[0]) && !IsPlayerConnected(targetid[1]))
        return ErrorMsg(playerid, "Nema online lidera iz izabrane mafije/bande.");
    
    war_tim1 = fid;
    war_tim2 = war_mafia_gang_listitem[listitem];

    new sDialog[sizeof(war_mape) * 12];
    sDialog[0] = EOS;
    for__loop (new i = 0; i < sizeof(war_mape); i++) 
    {
        format(sDialog, sizeof sDialog, "%s\n%s", sDialog, war_mape[i]);
    }
    
    SPD(playerid, "war_lider_start_mapa", DIALOG_STYLE_LIST, "[war] Mapa", sDialog, "Dalje >", "< Nazad");

    return 1;
}

Dialog:war_lider_start_mapa(playerid, response, listitem, const inputtext[])
{
    if (!response) 
    {
        if (IsAdmin(playerid, 2))
          return callcmd::war(playerid, "");

        else return 1;
    }

    if (war_aktivan) 
        return ErrorMsg(playerid, "War je vec aktiviran.");

    war_broj_ucesnika = 10;
    war_trajanje = 10;
    war_mapa = listitem;
    war_ulog = 0;
    war_accept_time = gettime() + 45;
    
    new sDialog[330];
    format(sDialog, sizeof sDialog, "{FFFFFF}Tim 1: {8080FF}%s (%s)\n{FFFFFF}Tim 2: {8080FF}%s (%s)\n{FFFFFF}Ulog: {8080FF}%s\n{FFFFFF}Trajanje: {8080FF}%d min\n{FFFFFF}Broj ucesnika: {8080FF}%d\n{FFFFFF}Mapa: {8080FF}%s\n\n{FFFFFF}Da li zelite da pokrenete war?", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_naziv], FACTIONS[war_tim2][f_tag], formatMoneyString(war_ulog), war_trajanje, war_broj_ucesnika, war_mape[war_mapa]);
    SPD(playerid, "war_lider_start_potvrda", DIALOG_STYLE_MSGBOX, "[war] Provera podataka", sDialog, "Ponudi", "Odustani");

    return 1;
}

Dialog:war_lider_start_potvrda(playerid, response, listitem, const inputtext[])
{
    if (response)
    {
        // Salje ponudu nekome od 2 lidera
        new targetid[2], sDialog[330];
        targetid[0] = GetPlayerIDFromName(F_LEADERS[war_tim2][0]);
        targetid[1] = GetPlayerIDFromName(F_LEADERS[war_tim2][1]);

        format(sDialog, sizeof sDialog, "{FF9900}WAR IZAZOV!\n\n{FFFFFF}Protivnik: {8080FF}%s (%s)\n{FFFFFF}Trajanje: {8080FF}%d min\n{FFFFFF}Broj ucesnika: {8080FF}%d\n{FFFFFF}Mapa: {8080FF}%s\n\n{FFFFFF}Da li zelite da pokrenete war?", FACTIONS[war_tim1][f_naziv], FACTIONS[war_tim1][f_tag], war_trajanje, war_broj_ucesnika, war_mape[war_mapa]);

        if (IsPlayerConnected(targetid[0]) && !IsPlayerAFK(targetid[0]))
        {
            SPD(targetid[0], "war_start_potvrda", DIALOG_STYLE_MSGBOX, "War izazov", sDialog, "Prihvati", "Odbij");
        }
        else if (IsPlayerConnected(targetid[1]) && !IsPlayerAFK(targetid[1]))
        {
            SPD(targetid[1], "war_start_potvrda", DIALOG_STYLE_MSGBOX, "War izazov", sDialog, "Prihvati", "Odbij");
        }
        else ErrorMsg(playerid, "Lideri izabrane mafije/bande nisu online ili su AFK.");
    }
    else
    {
        if (IsAdmin(playerid, 2))
          return callcmd::war(playerid, "");

        else return 1;
    }
    return 1;
}

Dialog:war_lider_ubaci(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
    {
        if (IsAdmin(playerid, 2))
          return callcmd::war(playerid, "");

        else return 1;
    }
    
    new 
        fid = PI[playerid][p_org_id], // faction id
        pid, // id izabranog igraca iz dialoga
        tim = war_odredi_tim(playerid)
    ;
            
    if (!war_aktivan) 
        return ErrorMsg(playerid, "War nije aktiviran.");
    
    if (tim == 0)
        return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");
    
    pid = war_inout_listitem[tim][listitem];
    
    if (!IsPlayerConnected(pid)) 
    {
        ErrorMsg(playerid, "Izabrani igrac je napustio server.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (PI[pid][p_org_id] != PI[playerid][p_org_id]) 
    {
        ErrorMsg(playerid, "Izabrani igrac nije clan Vase mafije/bande.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (igrac_u_waru{pid}) 
    {
        ErrorMsg(playerid, "Izabrani igrac je vec ubacen u war.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (IsPlayerJailed(pid)) 
    {
        ErrorMsg(playerid, "Izabrani igrac je zatvoren i ne moze ucestvovati u waru.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (zamrznut{pid} || PI[playerid][p_zavezan] > 0) 
    {
        ErrorMsg(playerid, "Izabrani igrac je zamrznut ili zavezan i ne moze biti ubacen u war.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (Iter_Count(war_igraci_tim[tim]) == war_broj_ucesnika) 
    {
        ErrorMsg(playerid, "Prijavili ste maksimalni broj igraca.");
        return d_war_lider(playerid, 1, 0, "");
    }
    

    ResetPlayerWeapons(pid);
    SetPlayerArmour(pid, 0.0);

    igrac_u_waru{pid} = true;
    war_p_ubistva[pid] = war_p_smrti[pid] = war_p_samoubistva[pid] = 0;
    war_p_dmg_taken[pid] = war_p_dmg_given[pid] = war_p_score[pid] = 0.0;
    
    
    Iter_Add(war_igraci_tim[tim], pid);
    Iter_Add(war_igraci, pid);

    // TextDraws
    ShowMainGuiTD(playerid, false);//Hide
    war_PodesiTimTD(1), war_PodesiTimTD(2);
    for__loop (new i = 20; i <= 25; i++)
        TextDrawShowForPlayer(pid, tdWar[i]);

    // Podesavanje kamere
    if (war_pripreme) 
    {
        TogglePlayerControllable_H(pid, false);
        SetPlayerPos(pid, war_kamere[war_mapa][POS_X], war_kamere[war_mapa][POS_Y], war_kamere[war_mapa][POS_Z]+50.0);
    }
    else
    {
        war_spawn(pid, true);
    }
    
    format(string_128, sizeof string_128, "(war) {FFFFFF}%s je ubacio {8080FF}%s.", ime_rp[playerid], ime_rp[pid]);
    foreach (new i : Player) 
    {
        if (PI[i][p_org_id] == fid)
            SendClientMessage(i, SVETLOLJUBICASTA, string_128);

        // Postavljanje ovog markera
        if (IsPlayerInWar(i) && i != pid) 
        {
            // Postavljanje ovog markera drugim ucesnicima
            SetPlayerMarkerForPlayer(i, pid, HexToInt(FACTIONS[fid][f_hex]));

            // Postavljanje markera drugih ucesnika ovom igracu
            SetPlayerMarkerForPlayer(pid, i, HexToInt(FACTIONS[PI[i][p_org_id]][f_hex]));
        }
    }

    return d_war_lider(playerid, 1, 0, "");
}

Dialog:war_lider_izbaci(playerid, response, listitem, const inputtext[]) 
{
    if (!response) 
    {
        if (IsAdmin(playerid, 2))
          return callcmd::war(playerid, "");
        else return 1;
    }
    
    new 
        pid, // id izabranog igraca iz dialoga
        tim = war_odredi_tim(playerid)
    ;
            
    if (!war_aktivan) 
        return ErrorMsg(playerid, "War nije aktiviran.");
    
    if (tim == 0)
        return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");
    
    pid = war_inout_listitem[tim][listitem];
    
    if (!IsPlayerConnected(pid)) 
    {
        ErrorMsg(playerid, "Izabrani igrac je napustio server.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (PI[pid][p_org_id] != PI[playerid][p_org_id]) 
    {
        ErrorMsg(playerid, "Izabrani igrac nije clan Vase mafije/bande.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (!igrac_u_waru{pid}) 
    {
        ErrorMsg(playerid, "Izabrani igrac nije ubacen u war.");
        return d_war_lider(playerid, 1, 0, "");
    }
    
    if (Iter_Count(war_igraci_tim[tim]) == 0) 
    {
        ErrorMsg(playerid, "Nema ni jednog ucesnika iz Vaseg tima.");
        return d_war_lider(playerid, 1, 0, "");
    }

    RemovePlayerFromWar(pid);
    format(string_128, sizeof string_128, "(war) {FFFFFF}%s je izbacio {8080FF}%s.", ime_rp[playerid], ime_rp[pid]);
    war_msg(0, string_128);
    
    return d_war_lider(playerid, 1, 1, "");
}

Dialog:war_stats_1(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    mysql_tquery(SQL, "SELECT ime, war_ubistva, war_smrti FROM igraci ORDER BY war_ubistva DESC, war_smrti ASC LIMIT 0,15", "MySQL_WarTopPlayers", "ii", playerid, cinc[playerid]);
    return 1;
}

Dialog:war_stats_2(playerid, response, listitem, const inputtext[])
{
    if (response) return callcmd::warstats(playerid, "");
    return 1;
}

Dialog:war_info(playerid, response, listitem, const inputtext[]) 
{
    return callcmd::war(playerid, "");
}



// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:warscore(playerid, const params[])
{
    if (!war_aktivan)
        return ErrorMsg(playerid, "War nije aktiviran.");

    new tim = war_odredi_tim(playerid);
    if (tim == 0)
        return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");

    SendClientMessageF(playerid, SVETLOLJUBICASTA, "(war) {FFFFFF}Trenutni rezultat  >>  %s %i  -  %i %s", FACTIONS[war_tim1][f_tag], war_skor[1], war_skor[2], FACTIONS[war_tim2][f_tag]);
    return 1;
}

CMD:war(playerid, const params[])
{
    if (isnull(params))
    {
        if (IsAdmin(playerid, 3))
        {
            SPD(playerid, "war", DIALOG_STYLE_LIST, "War panel", "Pokreni war\nZaustavi war\nWar informacije\nLider opcije", "Dalje >", "Izadji");
        }
        
        else if (PI[playerid][p_org_rank] == RANK_LEADER) 
        {
            SPD(playerid, "war_lider", DIALOG_STYLE_LIST, "War panel", "Pokreni war\nUbaci igraca\nIzbaci igraca\nPauza (60 sekundi)", "Dalje >", "Izadji");
        }
    }
    else 
    {
        new cmdParams[145];
        format(cmdParams, sizeof cmdParams, "%s", params);
        callcmd::wa(playerid, cmdParams);
    }
    return 1;
}

CMD:wa(const playerid, params[145]) 
{
    if (PI[playerid][p_utisan] > 0) 
        return overwatch_poruka(playerid, GRESKA_UTISAN);
        
    if (gettime() < koristio_chat[playerid]) 
        return overwatch_poruka(playerid, "Chat mozete koristiti na svake 3 sekunde.");

    if (isnull(params))
        return Koristite(playerid, "wa(r) [Tekst]");

    if (!war_aktivan)
        return ErrorMsg(playerid, "War nije aktiviran.");

    if (!igrac_u_waru{playerid})
        return ErrorMsg(playerid, "Vi ne ucestvujete u waru.");

    new tim = war_odredi_tim(playerid);
    if (tim == 0)
        return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");
        
    koristio_chat[playerid] = gettime() + 3;

    zastiti_chat(playerid, params);
    
    new chat_string[145];
    format(chat_string, sizeof chat_string, "{%s}%s: {FFFFFF}%s", FACTIONS[PI[playerid][p_org_id]][f_rgb], ime_rp[playerid], params);
    war_msg(0, chat_string);
    return 1;
}

CMD:napustiwar(playerid, const params[]) 
{
    if (!war_aktivan && war_review < gettime()) 
        return ErrorMsg(playerid, "War nije aktiviran.");

    if (!igrac_u_waru{playerid})
        return ErrorMsg(playerid, "Vi ne ucestvujete u waru.");

    new tim = war_odredi_tim(playerid);
    
    if (tim == 0)
        return ErrorMsg(playerid, "Vas tim ne ucestvuje u waru.");


    RemovePlayerFromWar(playerid);
    format(string_128, sizeof string_128, "(war) {FFFFFF}%s je napustio war.", ime_rp[playerid]);
    war_msg(0, string_128);
    return 1;
}

CMD:warstats(playerid, const params[])
{
    new sDialog[38 + MAX_FACTIONS*47];
    format(sDialog, sizeof sDialog, "Organizacija\tPobede\tPorazi\tNereseno");
    for__loop (new i = 0; i < MAX_FACTIONS; i++)
    {
        if (FACTIONS[i][f_vrsta] == FACTION_MAFIA || FACTIONS[i][f_vrsta] == FACTION_GANG || FACTIONS[i][f_vrsta] == FACTION_RACERS)
        {
            format(sDialog, sizeof sDialog, "%s\n{%s}%s\t%i\t%i\t%i", sDialog, FACTIONS[i][f_rgb], FACTIONS[i][f_naziv], FACTIONS[i][f_wars_won], FACTIONS[i][f_wars_lost], FACTIONS[i][f_wars_draw]);
        }
    }

    SPD(playerid, "war_stats_1", DIALOG_STYLE_TABLIST_HEADERS, "War statistike: organizacije", sDialog, "Dalje >", "Izadji");
    return 1;
}

CMD:bet(playerid, const params[])
{
    if (!war_aktivan || war_tim1 == -1 || war_tim2 == -1)
        return ErrorMsg(playerid, "War nije aktiviran.");

    if (!IsPlayerInRangeOfPoint(playerid, 5.0, 1215.2556,-1423.5125,13.6835))
        return ErrorMsg(playerid, "Kladjenje je moguce samo u zgradi lutrije. Koristi /gps da vidis lokaciju.");

    new sTag[8], iStake;
    if (sscanf(params, "s[8] i", sTag, iStake))
    {
        new sMsg[36];
        format(sMsg, sizeof sMsg, "bet [%s/%s] [Ulog]", FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_tag]);
        return Koristite(playerid, sMsg);
    }

    if (!war_bets_allowed)
        return ErrorMsg(playerid, "Isteklo je vreme za postavljanje opklade.");

    if (gWarBetTeam[playerid] != -1 || gWarBetStake[playerid] > 0)
        return ErrorMsg(playerid, "Vec si postavio opkladu za ovaj war.");

    if (iStake < 10000 || iStake > 100000)
        return ErrorMsg(playerid, "Ulog mora biti izmedju $10.000 i $100.000.");

    if (PI[playerid][p_novac] < iStake)
        return ErrorMsg(playerid, "Nemas toliko novca kod sebe.");


    if (!strcmp(sTag, FACTIONS[war_tim1][f_tag], true))
    {
        gWarBetTeam[playerid] = war_tim1;
    }
    else if (!strcmp(sTag, FACTIONS[war_tim2][f_tag], true))
    {
        gWarBetTeam[playerid] = war_tim2;
    }
    else
    {
        return ErrorMsg(playerid, "Uneo si pogresan naziv tima. Odaberi %s ili %s.", FACTIONS[war_tim1][f_tag], FACTIONS[war_tim2][f_tag]);
    }

    gWarBetStake[playerid] = iStake;
    PlayerMoneySub(playerid, iStake);

    new SendClientMessaged[145];
    format(SendClientMessaged, sizeof SendClientMessaged, "(war bet) {FFFFFF}%s[%i] se kladio na {8080FF}%s  {FFFFFF}|  Ulog: {8080FF}%s  {FFFFFF}| /bet", ime_rp[playerid], playerid, FACTIONS[gWarBetTeam[playerid]], formatMoneyString(gWarBetStake[playerid]));
    SendClientMessageToAll(SVETLOLJUBICASTA, SendClientMessaged);

    new sQuery[256];
    format(sQuery, sizeof sQuery, "INSERT INTO war_bets VALUES (%i, %i, %i)", PI[playerid][p_id], gWarBetTeam[playerid], iStake);
    mysql_tquery(SQL, sQuery);

    return 1;
}

CMD:kladionica(playerid, const params[])
{
    // TODO: Provera lokacije
    new sQuery[52];
    format(sQuery, sizeof sQuery, "SELECT amount FROM war_winnings WHERE pid = %i", PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery, "MySQL_LoadWarWinnings", "ii", playerid, cinc[playerid]);
    return 1;
}