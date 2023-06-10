#include <YSI_Coding\y_hooks>

/*
- Na paydayu u ponoc proveriti SVA vozila za istek registracije, i azurirati im v_registrovan ako su istekle
- Obavestiti igraca da mu je registracija istekla/auto nije reg. kad sedne u njega
- Cuvanje healtha i goriva
*/



// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define V_FARBANJE			100 // cena farbanja
#define MAX_VOZILA_DB 		750 // max broj unosa u tabeli vozila
#define MAX_VOZILA_SLOTOVI 	6 // maximum broj slotova za vozila
#define AUTOPIJACA_MESTA	206
#define TABLICE_CENA		1000 // cena novih tablica za vozila koja nikad nisu bila registrovana
#define AUTOPIJACA_CENA		3000 // cena za ulazak na auto pijacu
#define AUTOPIJACA_FIRMA    22 // ID firme za auto pijacu

#define MAX_V_ITEMS			5 // ako se dodaje neki predmet, ovo treba povecati
#define V_ITEM_RADIO 		0
#define V_ITEM_GPS			1
#define V_ITEM_HEAL			2
#define V_ITEM_ALARM		3
#define V_ITEM_CRATE		4

#define REG_NE				0 // nikad nije bio registrovan
#define REG_DA				1 // registrovan je
#define REG_EXP				2 // registracija istekla

#define NEON_LIGHT_INVALID  (18001) // proizvoljan broj, bilo je bitno da je veci od 18000
#define NEON_LIGHT_RED      (18647)
#define NEON_LIGHT_BLUE     (18648)
#define NEON_LIGHT_GREEN    (18649)
#define NEON_LIGHT_YELLOW   (18650)
#define NEON_LIGHT_PINK     (18651)
#define NEON_LIGHT_WHITE    (18652)




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static gOwnedVehiclesList[MAX_PLAYERS][MAX_VOZILA_SLOTOVI];
static gSpecTuning[MAX_VOZILA_DB][27];

new
	vozila_uredjuje_item[MAX_PLAYERS], // dialog sa spiskom vozila: broj stavke koju je izabrao da uredjuje (listitem)
	vozila_uredjuje_slot[MAX_PLAYERS], // automobil koji je izabrao - na kom je slotu?
	auto_pijaca_kupuje[MAX_PLAYERS], // id vozila koje zeli da kupi na pijaci
	auto_pijaca_kupuje_cena[MAX_PLAYERS], // za koju cenu treba da kupi vozilo (verifikacija dok odgovori na dialog)
	auto_pijaca_kupuje_vlasnik[MAX_PLAYERS], // ko je vlasnik vozila koje igrac kupuje?
	bool:gCarMarket_Ticket[MAX_PLAYERS char],
	
	objCarMarketRampEntrance,      
	objCarMarketRampExit,
	bool:gCarMarket_EntranceRampInUse = false,
	bool:gCarMarket_ExitRampInUse = false,

	aveh[MAX_PLAYERS],

    oruzje_slot[MAX_PLAYERS], // Slot sa kog uzima/stavlja oruzje iz/u vozilo
	
	Text3D:v_prodaja_tekst[MAX_VOZILA_DB] = {Text3D:INVALID_3DTEXT_ID, Text3D:INVALID_3DTEXT_ID, ...},
	
	Iterator:iOwnedVehicles<MAX_VOZILA_DB>,
	Iterator:auto_pijaca<AUTOPIJACA_MESTA>
;

static Float:gCarMarket_Parcels[AUTOPIJACA_MESTA][4] = 
{
	{1650.2616, -1111.4387, 23.5869, 85.2056}, 
	{1650.2198, -1106.9738, 23.6314, 85.2049}, 
	{1650.2233, -1102.6438, 23.6154, 84.6477}, 
	{1650.2379, -1098.1685, 23.6099, 85.2071}, 
	{1650.1964, -1093.3706, 23.7157, 85.2069}, 
	{1650.4661, -1089.0692, 23.5281, 85.2059}, 
	{1650.1122, -1084.5497, 23.6058, 85.2070}, 
	{1649.9783, -1080.0530, 23.7221, 85.0609}, 
	{1630.0712, -1085.2469, 23.6312, 270.4999}, 
	{1630.1763, -1089.5249, 23.5715, 269.9510}, 
	{1630.1849, -1093.8967, 23.6061, 270.3721}, 
	{1630.0289, -1098.3457, 23.7116, 270.4402}, 
	{1630.1233, -1102.9244, 23.6075, 270.4999}, 
	{1629.5905, -1107.5710, 23.7443, 270.3951}, 
	{1616.7124, -1137.1514, 23.6119, 271.2916}, 
	{1616.4266, -1132.7351, 23.6113, 267.3183}, 
	{1616.7599, -1127.9557, 23.6116, 270.7864}, 
	{1617.0796, -1123.4282, 23.6118, 268.7831}, 
	{1617.8453, -1119.2977, 23.6110, 271.4116}, 
	{1620.2795, -1107.8258, 23.6114, 89.8268}, 
	{1620.4011, -1102.9470, 23.6115, 91.3936}, 
	{1619.8889, -1098.6565, 23.6113, 90.9705}, 
	{1619.6694, -1094.2155, 23.6153, 89.8415}, 
	{1620.5590, -1089.6981, 23.6111, 88.4086}, 
	{1620.4229, -1085.3010, 23.6116, 90.4143}, 
	{1593.5299, -1057.1304, 23.6117, 306.2165}, 
	{1590.3429, -1053.7649, 23.6111, 309.9333}, 
	{1587.2314, -1050.5031, 23.6115, 307.4005}, 
	{1584.7865, -1046.6406, 23.6121, 305.0063}, 
	{1577.2798, -1039.0632, 23.6118, 319.9096}, 
	{1574.0892, -1036.4421, 23.6132, 323.4737}, 
	{1570.7371, -1033.0983, 23.6164, 321.9045}, 
	{1564.0096, -1029.8940, 23.6151, 344.0382}, 
	{1559.6416, -1028.6506, 23.6112, 342.4812}, 
	{1555.7874, -1027.2715, 23.6117, 341.1150}, 
	{1551.4668, -1026.0477, 23.6116, 341.6811}, 
	{1546.7675, -1024.7998, 23.6116, 343.0102}, 
	{1542.9506, -1023.3036, 23.6111, 341.5749}, 
	{1558.7024, -1013.1671, 23.6112, 180.3813}, 
	{1563.0092, -1012.7914, 23.6116, 179.0775}, 
	{1567.2850, -1012.0812, 23.6173, 182.7385}, 
	{1572.1122, -1012.1268, 23.6110, 178.4624}, 
	{1576.6484, -1012.2177, 23.6115, 179.5152}, 
	{1581.7598, -1012.3909, 23.6113, 184.7326}, 
	{1586.0890, -1011.9827, 23.6114, 189.8637}, 
	{1590.2047, -1010.6924, 23.6117, 184.4012}, 
	{1594.8425, -1010.5307, 23.6109, 187.3640}, 
	{1599.6067, -1010.0270, 23.6112, 186.0161}, 
	{1604.5627, -1009.8218, 23.6114, 176.0972}, 
	{1609.1887, -1010.0581, 23.6111, 176.8389}, 
	{1612.9501, -1009.3815, 23.6114, 181.7948}, 
	{1617.8046, -1009.6567, 23.6051, 179.5188}, 
	{1623.6754, -1011.2606, 23.6039, 160.0785}, 
	{1627.9739, -1012.1487, 23.6034, 160.8288}, 
	{1631.9293, -1013.5544, 23.6039, 164.9372}, 
	{1635.7594, -1014.8575, 23.6033, 161.2278}, 
	{1640.5177, -1016.7668, 23.6040, 160.5111}, 
	{1644.8956, -1018.3088, 23.6033, 162.1662}, 
	{1627.1229, -1036.6573, 23.6036, 0.0481}, 
	{1631.5936, -1036.7274, 23.6039, 358.9277}, 
	{1636.5161, -1036.7075, 23.6044, 1.1198}, 
	{1640.7156, -1036.9624, 23.6042, 357.7119}, 
	{1645.2610, -1036.6995, 23.6037, 0.0872}, 
	{1649.6161, -1036.5382, 23.6039, 359.7976}, 
	{1653.7769, -1036.8535, 23.6037, 358.8484}, 
	{1658.5797, -1037.4850, 23.6038, 358.8587}, 
	{1658.8347, -1047.9871, 23.6034, 182.9199}, 
	{1654.6573, -1048.0219, 23.6041, 181.3884}, 
	{1650.1385, -1047.5802, 23.6041, 179.1427}, 
	{1645.3322, -1047.8943, 23.6039, 178.1748}, 
	{1641.1697, -1047.6489, 23.6039, 179.3687}, 
	{1636.6085, -1047.4445, 23.6036, 182.6502}, 
	{1631.4230, -1047.6633, 23.6028, 179.9772}, 
	{1627.1357, -1047.3870, 23.6036, 177.8611}, 
	{1659.1293, -1079.7799, 23.6077, 272.0227}, 
	{1658.8708, -1084.6218, 23.6118, 271.5049}, 
	{1659.0513, -1089.2656, 23.6113, 269.0147}, 
	{1659.2764, -1093.7028, 23.6114, 269.0664}, 
	{1659.6067, -1098.1152, 23.6118, 267.0625}, 
	{1659.5967, -1102.5409, 23.6119, 267.9526}, 
	{1659.3149, -1106.8336, 23.6115, 270.3850}, 
	{1659.7388, -1111.4294, 23.6103, 271.8528}, 
	{1674.5051, -1098.2615, 23.6114, 90.0584}, 
	{1674.9093, -1102.2144, 23.6119, 86.5313}, 
	{1675.3636, -1106.9685, 23.6111, 88.6214}, 
	{1674.9586, -1111.3831, 23.6116, 89.8734}, 
	{1674.7021, -1115.8080, 23.6115, 87.7062}, 
	{1674.9688, -1120.4303, 23.6117, 85.5377}, 
	{1675.0179, -1124.9250, 23.6112, 89.7466}, 
	{1675.1830, -1129.1449, 23.6115, 88.2458}, 
	{1666.4248, -1134.9258, 23.6482, 0.0537}, 
	{1661.6904, -1134.8120, 23.6253, 359.7622}, 
	{1657.5031, -1134.7419, 23.6111, 358.0611}, 
	{1652.6139, -1134.7625, 23.6119, 0.5017}, 
	{1648.4790, -1134.6865, 23.6113, 355.9955}, 
	{1651.9131, -1018.4251, 23.6034, 187.6933}, 
	{1656.2037, -1017.3529, 23.6035, 189.0435}, 
	{1660.6866, -1017.1564, 23.6039, 189.8953}, 
	{1665.2955, -1015.7896, 23.6040, 188.9851}, 
	{1679.3844, -1012.8262, 23.6030, 199.5395}, 
	{1683.3440, -1011.0316, 23.6057, 194.5230}, 
	{1687.3490, -1009.9171, 23.6111, 198.6696}, 
	{1691.4413, -1007.9330, 23.6110, 198.8230}, 
	{1696.2465, -1007.0864, 23.6114, 198.1698}, 
	{1703.2936, -1006.2165, 23.6119, 171.4440}, 
	{1708.1031, -1006.4966, 23.6175, 173.6892}, 
	{1712.5720, -1007.1378, 23.6198, 171.8054}, 
	{1716.7185, -1008.0523, 23.6188, 171.1919}, 
	{1721.5887, -1008.7995, 23.6176, 170.8443}, 
	{1725.9918, -1009.3189, 23.6290, 168.6414}, 
	{1730.9902, -1010.3499, 23.6442, 165.3478}, 
	{1735.0181, -1011.1288, 23.6578, 167.6182}, 
	{1739.6654, -1012.3569, 23.6665, 168.3084}, 
	{1744.0693, -1013.2872, 23.6668, 167.3798}, 
	{1748.2319, -1014.1313, 23.6663, 166.0285}, 
	{1752.5123, -1015.0244, 23.6656, 166.8325}, 
	{1757.0443, -1016.1260, 23.6656, 167.6981}, 
	{1761.4098, -1016.7417, 23.6656, 167.5658}, 
	{1767.4117, -1019.0847, 23.6659, 154.0568}, 
	{1771.1407, -1020.9092, 23.6657, 151.2040}, 
	{1775.0306, -1022.8593, 23.6659, 155.7990}, 
	{1779.4658, -1024.9655, 23.6664, 153.2282}, 
	{1782.7937, -1026.7240, 23.6668, 152.8420}, 
	{1793.6205, -1060.2400, 23.6714, 359.7952}, 
	{1788.9808, -1060.3063, 23.6659, 357.4070}, 
	{1784.4257, -1060.0413, 23.6657, 358.5881}, 
	{1780.0813, -1060.1056, 23.6659, 358.4028}, 
	{1775.2872, -1060.2749, 23.6655, 359.2778}, 
	{1770.9755, -1060.1110, 23.6656, 359.1809}, 
	{1766.5406, -1061.0323, 23.6656, 0.7294}, 
	{1762.1023, -1060.5155, 23.6660, 358.3337}, 
	{1761.3788, -1047.1619, 23.6654, 179.8849}, 
	{1757.4669, -1047.4884, 23.6657, 179.5809}, 
	{1752.9928, -1047.5851, 23.6656, 180.5973}, 
	{1748.4933, -1047.1938, 23.6657, 178.9919}, 
	{1744.2789, -1047.4286, 23.6662, 179.7569}, 
	{1743.5126, -1036.3711, 23.6671, 0.3554}, 
	{1748.6373, -1036.2507, 23.6659, 359.3062}, 
	{1752.4551, -1036.0192, 23.6660, 357.9121}, 
	{1761.7682, -1036.1667, 23.6660, 358.4494}, 
	{1680.5558, -1034.3348, 23.6099, 0.4741}, 
	{1685.0824, -1034.2645, 23.6117, 358.9988}, 
	{1689.9354, -1034.0459, 23.6112, 357.6035}, 
	{1694.0255, -1034.9945, 23.6118, 359.4362}, 
	{1698.1746, -1034.4297, 23.6115, 359.4700}, 
	{1703.0415, -1034.2035, 23.6120, 0.4388}, 
	{1707.8673, -1034.2594, 23.6168, 0.0539}, 
	{1712.3615, -1034.2042, 23.6192, 359.3457}, 
	{1707.8834, -1045.4165, 23.6109, 180.2933}, 
	{1703.4271, -1045.2979, 23.6110, 181.7457}, 
	{1698.5890, -1045.3750, 23.6111, 177.8452}, 
	{1694.4491, -1045.0857, 23.6116, 183.2831}, 
	{1689.9413, -1045.6086, 23.6115, 180.4733}, 
	{1685.5192, -1045.4816, 23.6131, 180.6973}, 
	{1681.0074, -1045.5370, 23.6079, 178.1481}, 
	{1691.5724, -1069.8652, 23.6116, 179.2735}, 
	{1696.3175, -1070.3574, 23.6110, 179.8124}, 
	{1700.2118, -1070.2904, 23.6114, 179.0828}, 
	{1704.9330, -1070.2368, 23.6113, 178.7530}, 
	{1709.2115, -1070.0283, 23.6114, 180.0387}, 
	{1714.0450, -1070.3607, 23.6117, 176.8083}, 
	{1718.1581, -1070.0114, 23.6118, 179.8541}, 
	{1722.6249, -1070.3279, 23.6263, 179.3178}, 
	{1722.6296, -1059.5038, 23.6277, 0.8231}, 
	{1718.5685, -1059.7144, 23.6159, 358.7811}, 
	{1713.9453, -1059.7019, 23.6116, 359.1612}, 
	{1709.3456, -1059.3224, 23.6109, 356.7006}, 
	{1704.5774, -1059.5328, 23.6113, 358.2530}, 
	{1700.1573, -1059.3986, 23.6111, 358.2918}, 
	{1695.9086, -1059.9260, 23.6175, 358.7359}, 
	{1691.0466, -1059.4587, 23.6194, 0.7476}, 
	{1687.8744, -1083.5441, 23.6118, 356.3423}, 
	{1692.7695, -1084.1279, 23.6111, 0.7499}, 
	{1696.8361, -1084.5186, 23.6113, 0.2929}, 
	{1701.0901, -1083.8993, 23.6118, 359.1858}, 
	{1705.6250, -1084.4241, 23.6112, 359.2484}, 
	{1726.7229, -1084.2491, 23.6317, 359.9770}, 
	{1731.0876, -1084.4221, 23.6498, 1.0541}, 
	{1735.1539, -1084.2006, 23.6646, 358.3723}, 
	{1739.6091, -1084.3306, 23.6658, 359.3499}, 
	{1744.4966, -1084.0282, 23.6667, 0.0694}, 
	{1749.0867, -1084.3553, 23.6658, 359.4717}, 
	{1753.7488, -1084.3927, 23.6656, 0.2365}, 
	{1757.5964, -1084.2836, 23.6661, 358.4247}, 
	{1761.8713, -1084.5120, 23.6662, 358.9601}, 
	{1766.6655, -1084.4979, 23.6656, 1.3406}, 
	{1771.4248, -1084.0858, 23.6662, 0.3848}, 
	{1776.0936, -1084.1068, 23.6668, 359.9068}, 
	{1780.6285, -1084.1450, 23.6660, 358.5173}, 
	{1785.2305, -1084.4452, 23.6736, 358.7221}, 
	{1789.6279, -1084.1160, 23.6736, 359.3931}, 
	{1793.6962, -1084.3822, 23.6741, 0.3181}, 
	{1798.5927, -1084.4412, 23.6657, 359.4047}, 
	{1803.1754, -1084.4324, 23.6658, 358.9460}, 
	{1580.8931, -1043.8513, 23.6062, 305.1881}, 
	{1757.5587, -1036.1627, 23.6536, 359.1094}, 
	{1762.2480, -1071.1405, 23.6656, 180.1185}, 
	{1766.8060, -1071.0178, 23.6663, 179.3708}, 
	{1771.1250, -1071.3672, 23.6662, 180.3407}, 
	{1775.7026, -1071.3037, 23.6656, 178.4432}, 
	{1779.6722, -1070.7954, 23.6664, 178.9294}, 
	{1784.6796, -1071.0603, 23.6663, 179.3281}, 
	{1789.2264, -1071.3103, 23.6658, 178.5732}, 
	{1792.8546, -1070.6536, 23.6658, 179.2751}, 
	{1674.4950, -1013.3273, 23.6082, 198.6777},  
	{1712.6575, -1045.0634, 23.6333, 180.7092}
};




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_VEHICLES
{
	bool:V_SPAWNED,
	V_ID, // id kreiranog vozila, return value od CreateVehicle()
	V_MODEL,
	V_OWNER_ID, // id igraca u bazi podataka
	V_OWNER_NAME[MAX_PLAYER_NAME], // ime igraca sa donjom crtom
	V_TYPE,
	Float:V_POS[4],
	V_COLOR_1,
	V_COLOR_2,
	V_PRICE,
	V_LOCKED,
	V_ENT, 
	V_VW, 
	V_PLATE[33], // Automobili, motori
	Float:V_FUEL, // Automobili, motori, brodovi, helikopteri
	Float:V_HEALTH, // Automobili, motori, brodovi, helikopteri
	V_DMG_STATUS_PANELS,
	V_DMG_STATUS_DOORS,
	V_DMG_STATUS_LIGHTS,
	V_DMG_STATUS_TIRES,
	V_SELLING_PRICE,
	Float:V_MILEAGE,
	V_CAR_MARKET, // belezi na kom je parking mestu na pijaci parkiran (nema u bazi)
	V_REG_EXPIRY[21], // datum isteka registracije
	V_REG_STATUS, // da li je auto registrovan? vrednosti su definisane sa REG_*
    V_COMPONENTS,
    V_NEON_LIGHT_OBJ[2], // ID-evi objekata neonki TODO: inicijalizovati na -1
    V_SECURITY,
    V_SPEC_TUNING,
    Float:V_SERVIS,
    Float:V_STEPENPOK
};
new OwnedVehicle[MAX_VOZILA_DB][E_VEHICLES]; // x5, po jednom za svaku vrstu vozila

enum E_VEH_COMPONENTS
{
	// v_vehid, // id vozila (u bazi podataka)
	V_COMPONENT_ID, // id komponente
	V_PART_ID, // ID dela (definisano sa PART_* unutar tuning.pwn)
};
new VehicleComponents[MAX_VOZILA_DB][12][E_VEH_COMPONENTS]; // 9 slotova za komponente + paintjob

enum E_VEH_WEAPONS
{
	V_WEAPON_ID, // id oruzja
	V_AMMO, // kolicina municije
};
new VehicleWeapons[MAX_VOZILA_DB][13][E_VEH_WEAPONS]; // 13 = broj slotova za oruzje




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit() 
{
	for__loop (new i = 0; i < AUTOPIJACA_MESTA; i++)
		Iter_Add(auto_pijaca, i);
	
	for__loop (new i = 0; i < MAX_VOZILA_DB; i++)
    {
		OwnedVehicle[i][V_ID] = INVALID_VEHICLE_ID;

        for__loop (new j = 0; j < sizeof gSpecTuning[]; j++)
        {
            gSpecTuning[i][j] = INVALID_OBJECT_ID;
        }
    }
	
	mysql_pquery(SQL, "SELECT vozila.*, DATE_FORMAT(vozila.registracija, '%d/%m/%Y') as reg1, UNIX_TIMESTAMP(vozila.registracija) as reg2, UNIX_TIMESTAMP(igraci.poslednja_aktivnost) as last_act FROM vozila LEFT JOIN igraci ON igraci.id = vozila.vlasnik", "mysql_v_ucitaj");
	// ^reg 2 = timestamp isteka registracije

	Create3DTextLabel("{FFFF00}Auto pijaca\n{FFFFFF}Ulaz se naplacuje {FFFF00}$"#AUTOPIJACA_CENA"\n{FFFFFF}Pritisnite ~k~~PED_SPRINT~ za ulaz", BELA, 1641.9790,-1155.3376,24.0988, 15.0, 0);
 	Create3DTextLabel("{FFFF00}Auto pijaca\n{FFFFFF}Pritisnite ~k~~PED_SPRINT~ da izadjete", BELA, 1633.2030,-1142.8578,24.0788, 15.0, 0);

    objCarMarketRampEntrance = CreateDynamicObjectEx(968, 1646.056274, -1152.762329, 24.052207, 0.000000, -90.000000, 0.000000, 750.0, 750.0); 
    objCarMarketRampExit = CreateDynamicObjectEx(968, 1629.334838, -1152.631713, 23.992797, 0.000000, 90.00000, 0.000000, 750.0, 750.0); 

 	CreateDynamicPickup(19132, 1, 1641.9790,-1155.3376,24.0988); // Ulaz na autopijacu
	CreateDynamicPickup(19132, 1, 1633.2030,-1142.8578,24.0788); // Izlaz sa autopijace

    SetTimer("OwnedVehicle_IncreaseMileage", 2000, true); // Tajmer za povecanje kilometraze na vozilima
 	return 1;
}

hook OnPlayerConnect(playerid) 
{
	gCarMarket_Ticket{playerid} = false;
    aveh[playerid] = -1;
	
	return 1;
}

hook OnPlayerDisconnect(playerid, reason) 
{
	for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
	{
		if (pVehicles[playerid][i] == 0) continue; // prazan slot
		
		new 
			Float:hp, 
			veh = OwnedVehicle[pVehicles[playerid][i]][V_ID]
		;
		GetVehicleHealth(veh, hp);
		
		new sQuery[67];
		format(sQuery, sizeof sQuery, "UPDATE vozila SET gorivo = %.1f, health = %.1f WHERE id = %d", GetVehicleFuel(veh), (hp>999.0?999.0:hp), pVehicles[playerid][i]);
		mysql_tquery(SQL, sQuery);
	}
	
	return 1;
}

/*
  Poziva se kad igrac pokusa da udje u vozilo da bi se proverilo vlasnistvo i
  eventualno izbacio iz istog
*/
hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if (ispassenger) return 1; // nema veze ako je putnik
	
	foreach (new i : iOwnedVehicles) 
    {
		if (OwnedVehicle[i][V_ID] == vehicleid) 
        {
			if (OwnedVehicle[i][V_SELLING_PRICE] != 0) 
            {
				// Vozilo se prodaje na auto pijaci
				GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
				SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.5);
				
				if (OwnedVehicle[i][V_OWNER_ID] == PI[playerid][p_id])
					SendClientMessage(playerid, GRAD2, "* Ne mozete koristiti vozilo koje ste stavili na prodaju.");
				//else 
				//	SendClientMessageF(playerid, GRAD2, "* %s je zakljucan! Vlasnik: {FFFFFF}%s", propname(OwnedVehicle[i][V_TYPE], PROPNAME_CAPITAL), OwnedVehicle[i][V_OWNER_NAME]);
					
				return ~1;
			}
			
			if (IsAdmin(playerid, 3) && PI[playerid][p_id] != OwnedVehicle[i][V_OWNER_ID]) 
            {
				// Igrac je admin, i ovo nije njegovo vozilo -> dozvoli da udje i ispisi informacije
                aveh[playerid] = i;
                SendClientMessageF(playerid, CRVENA, "(%s) {FFFFFF}%s | Vlasnik: %s | ID baza: [%d] | ID server: [%d] | {FF9900}/aveh", 
                    propname(OwnedVehicle[i][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[i][V_MODEL] - 400], OwnedVehicle[i][V_OWNER_NAME], i, vehicleid);
				
				return ~1;
			}
			
			if (!IsAdmin(playerid, 3) && OwnedVehicle[i][V_LOCKED] == 1) 
            {
				// Igrac nije admin, a vozilo je zakljucano. Da li je ovaj igrac vlasnik tog vozila?
				if (OwnedVehicle[i][V_OWNER_ID] != PI[playerid][p_id]) 
				{
					GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
					SetPlayerCompensatedPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + 0.5);
					
					SendClientMessageF(playerid, GRAD2, "* %s je zakljucan! Vlasnik: {FFFFFF}%s", propname(OwnedVehicle[i][V_TYPE], PROPNAME_CAPITAL), OwnedVehicle[i][V_OWNER_NAME]);
					
					return ~1;
				}
				else
				{
					// Igrac ulazi u svoje vozilo
				}
			}
			
			break;
		}
	}
	
	return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) 
{
    if (oldstate == PLAYER_STATE_DRIVER && IsAdmin(playerid, 1))
    {
        aveh[playerid] = -1;
    }

    if (newstate == PLAYER_STATE_DRIVER)
    {
	    new vehicleid = GetPlayerVehicleID(playerid);
	    foreach (new i : iOwnedVehicles) 
	    {
			if (OwnedVehicle[i][V_ID] == vehicleid) 
	        {
	        	if (OwnedVehicle[i][V_OWNER_ID] == PI[playerid][p_id])
	        	{
	        		new Float:health;
	        		GetVehicleHealth(vehicleid, health);

	        		if (health == 250.1 && GetVehicleFuel(vehicleid) == 0.0)
	        		{
						// Proveriti da li je bio kraden i upozoriti ga da kupi/nadogradi alarm
						SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "{FFFFFF}[!!] Kradja", "{FF63CC}» UPOZORENJE «\n{FF0000}VOZILO JE KRADENO!\n\n{FFFFFF}Da biste izbegli neprijatnu situaciju da svoje vozilo zateknete osteceno i bez goriva,\npredlazemo da posetite Security Shop i kupite neki alarm za svoje vozilo.\n\nDovoljno jak alarm ce upozoriti policiju kada neko pokusa da ukrade Vase vozilo.\nAlarm takodje moze da utice na ishod same kradje, odnosno da potpuno onemoguci kradju.\n\n{FFFF00}Za vise informacija koristite {FF9900}/gps -- Security Shop.", "U redu", "");
	        		}
	        	}
	        	break;
	        }
	    }
	}

    return 1;
}

// rijesiti

cmd:resetservis(playerid, const params[])
{
    static
        id;

    if (!IsAdmin(playerid, 6))
        return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

    if (strfind(params, "") != -1) {
        Koristite(playerid, "/resetservis [svavozila (privatna) ili ID specificnog vozila");
    }
    else if (strfind(params, "svavozila") != -1) // resetuj servis svim privatnim vozilima
    {
        foreach (new v : iOwnedVehicles) 
        {
            OwnedVehicle[v][V_SERVIS] = 0.0;
            InfoMsg(playerid, "Resetirao si kilometrazu svim privatnim vozilima.");
            format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET servis = %.1f WHERE id = %d", OwnedVehicle[v][V_SERVIS], v);
            mysql_tquery(SQL, mysql_upit);
        }
    }
    else if (!sscanf(params, "u", id)) {
        OwnedVehicle[id][V_SERVIS] = 0.0;
        InfoMsg(playerid, "Resetirao si kilometrazu vozilu ID %i.", id);
        format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET servis = %.1f WHERE id = %d", OwnedVehicle[id][V_SERVIS], id);
        mysql_tquery(SQL, mysql_upit);
    }

    return 1;
}

hook OnPlayerExitVehicle(playerid, vehicleid) 
{
	// Da li je bio u ownership vozilu?
	foreach (new v : iOwnedVehicles) 
	{
		if (OwnedVehicle[v][V_ID] == vehicleid) 
		{
			//OwnedVehicle[v][V_MILEAGE] += kilometraza[playerid]/1000.0;

            //new Float:kmAfter;
            //kmAfter = kilometraza[playerid]/1000.0;
            //
            //if((OwnedVehicle[v][V_SERVIS] - kmAfter) < 0.0)
            //{
            //    OwnedVehicle[v][V_SERVIS] = 0.0;
            //    OwnedVehicle[v][V_STEPENPOK] += kilometraza[playerid]/1000.0;
            //    InfoMsg(playerid, "Vase vozilo je preslo 15.000 novih kilometara, potrebno je da odradite servis.");
            //    InfoMsg(playerid, "Ukoliko ne odradite servis na vrijeme, moze doci do kvara na vozilu.");
            //    printf("%f - %f - %f - %f", OwnedVehicle[v][V_SERVIS], OwnedVehicle[v][V_STEPENPOK], kilometraza[playerid], kilometraza[playerid]/1000.0);
            //}
            //else {
            //    OwnedVehicle[v][V_SERVIS] -= kilometraza[playerid]/1000.0;
            //    //printf("%f - %f - %f - %f", OwnedVehicle[v][V_SERVIS], OwnedVehicle[v][V_STEPENPOK], kilometraza[playerid], kilometraza[playerid]/1000.0);
            //}
			//kilometraza[playerid] = 0.0;
			
			GetVehicleDamageStatus(vehicleid, OwnedVehicle[v][V_DMG_STATUS_PANELS], OwnedVehicle[v][V_DMG_STATUS_DOORS], OwnedVehicle[v][V_DMG_STATUS_LIGHTS], OwnedVehicle[v][V_DMG_STATUS_TIRES]);
			GetVehicleHealth(vehicleid, OwnedVehicle[v][V_HEALTH]);
			OwnedVehicle[v][V_FUEL] = GetVehicleFuel(vehicleid);
			
			// Ako je vozilo previse zapaljeno, popravi ga malo da vise ne gori
			if (OwnedVehicle[v][V_HEALTH] < 250.0)
				OwnedVehicle[v][V_HEALTH] = 250.1;
			
			format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET health = %.1f, gorivo = %.1f, km = %.1f, dmg_status_panels = %d, dmg_status_doors = %d, dmg_status_lights = %d, dmg_status_tires = %d, servis = %.1f, stepen_pokvarenosti = %.1f WHERE id = %d", OwnedVehicle[v][V_HEALTH], OwnedVehicle[v][V_FUEL], OwnedVehicle[v][V_MILEAGE], OwnedVehicle[v][V_DMG_STATUS_PANELS], OwnedVehicle[v][V_DMG_STATUS_DOORS], OwnedVehicle[v][V_DMG_STATUS_LIGHTS], OwnedVehicle[v][V_DMG_STATUS_TIRES], OwnedVehicle[v][V_SERVIS], OwnedVehicle[v][V_STEPENPOK], v);
			mysql_tquery(SQL, mysql_upit);
			break;
		}
	}
    aveh[playerid] = -1;
	
	return 1;
}

hook OnVehicleSpawn(vehicleid) 
{
	// Da li je ownership vozilo?
	foreach (new v : iOwnedVehicles) 
    {
		if (OwnedVehicle[v][V_ID] == vehicleid) 
        {
			SetVehicleHealth(vehicleid, (OwnedVehicle[v][V_HEALTH]<250.0?250.1:OwnedVehicle[v][V_HEALTH]));
			UpdateVehicleDamageStatus(vehicleid, OwnedVehicle[v][V_DMG_STATUS_PANELS], OwnedVehicle[v][V_DMG_STATUS_DOORS], OwnedVehicle[v][V_DMG_STATUS_LIGHTS], OwnedVehicle[v][V_DMG_STATUS_TIRES]);

            // Stavlja mu spec tuning ako objekti nisu kreirani
            if (!IsValidDynamicObject(gSpecTuning[v][0]))
            {
                OwnedVehicle_SetSpecTuning(v);
            }

			if (OwnedVehicle[v][V_SELLING_PRICE] != 0)
			{
				// Prodaje se na pijaci
				SetVehicleVirtualWorld(vehicleid, 0);
	            LinkVehicleToInterior(vehicleid, 0);
			}
			else
			{
	            SetVehicleVirtualWorld(vehicleid, OwnedVehicle[v][V_VW]);
	            LinkVehicleToInterior(vehicleid, OwnedVehicle[v][V_ENT]);
	        }

            if (OwnedVehicle[v][V_COMPONENTS] != 0) 
            {
                for__loop (new i = 0; i < 12; i++) 
                {
                    if (VehicleComponents[v][i][V_PART_ID] == -1) continue;

                    // AddVehicleComponent(vehicleid, VehicleComponents[v][i][V_COMPONENT_ID]);

                    if (VehicleComponents[v][i][V_COMPONENT_ID] >= 0 && VehicleComponents[v][i][V_COMPONENT_ID] <= 2) // Paintjob
                    {
                        ChangeVehiclePaintjob(vehicleid, VehicleComponents[v][i][V_COMPONENT_ID]);
                    }
                    else if (VehicleComponents[v][i][V_COMPONENT_ID] > 18000)
                    {
                        Vehicle_SetNeonLights(v, true, VehicleComponents[v][i][V_COMPONENT_ID]);
                    }
                    else
                    {
                        AddVehicleComponent(vehicleid, VehicleComponents[v][i][V_COMPONENT_ID]);
                    }
                }
            }
            break;

			// SetVehicleHealth_H: ternary operator sluzi da spreci da se vozilo spawnuje zapaljeno
		}
	}
	return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_SPRINT && GetPlayerState(playerid) != PLAYER_STATE_DRIVER) || (newkeys & KEY_HANDBRAKE && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)) // Space
    {
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 1641.9790,-1155.3376,24.0988)) // Ulaz na autopijacu
        {
            if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            {
                ErrorMsg(playerid, "Samo vozila mogu koristiti ovaj ulaz. Ako ste bez vozila, zaobidjite rampu.");
                return ~1;
            }
            
            if (PI[playerid][p_novac] < AUTOPIJACA_CENA)
            {
                ErrorMsg(playerid, "Nemate dovoljno novca. Ulaz na autopijacu se naplacuje {FFFFFF}$"#AUTOPIJACA_CENA".");
                return ~1;
            }
            
            if (gCarMarket_EntranceRampInUse)
            {
                ErrorMsg(playerid, "Sacekajte da se rampa zatvori...");
                return ~1;
            }
            
            
            PlayerMoneySub(playerid, AUTOPIJACA_CENA);
            re_firma_dodaj_novac(re_globalid(firma, AUTOPIJACA_FIRMA), AUTOPIJACA_CENA);
            gCarMarket_Ticket{playerid} = true;
            SendClientMessage(playerid, SVETLOPLAVA, "* Kupili ste ulaznicu za auto pijacu. Zelimo Vam puno srece sa prodajom.");
            
            MoveDynamicObject(objCarMarketRampEntrance, 1646.056274, -1152.762329, 24.052207+0.005, 0.005, 0.0, 0.0, 0.0);
            gCarMarket_EntranceRampInUse = true;
            SetTimerEx("CarMarket_CloseRamp", 6000, false, "d", objCarMarketRampEntrance);
            return ~1;
        }
        
        if (IsPlayerInRangeOfPoint(playerid, 5.0, 1633.2030,-1142.8578,24.0788)) // Izlaz sa autopijace
        {
            if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
            {
                ErrorMsg(playerid, "Samo vozila mogu koristiti ovaj izlaz. Ako ste bez vozila, zaobidjite rampu.");
                return ~1;
            }
            
            if (gCarMarket_ExitRampInUse)
            {
                ErrorMsg(playerid, "Sacekajte da se rampa zatvori...");
                return ~1;
            }
            
            gCarMarket_Ticket{playerid} = false;
            
            MoveDynamicObject(objCarMarketRampExit, 1629.334838, -1152.631713, 23.992797+0.005, 0.005, 0.0, 0.0, 0.0);
            gCarMarket_ExitRampInUse = true;
            SetTimerEx("CarMarket_CloseRamp", 6000, false, "d", objCarMarketRampExit);
        
        
            return ~1;
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward v_resetuj_promenljive(id);
forward OwnedVehicle_LoadForPlayer(playerid);
forward OwnedVehicle_SellOffline(playerid);
forward v_proveri_registraciju(playerid);
forward CarMarket_CloseRamp(objectid);


OwnedVehicle_Reload(id)
{
	if (IsValidVehicle(OwnedVehicle[id][V_ID]))
	{
        OwnedVehicle_RemoveSpecTuning(id);

		DestroyVehicle(OwnedVehicle[id][V_ID]);
		OwnedVehicle[id][V_ID] = INVALID_VEHICLE_ID;

	}

	new sQuery[261];
	format(sQuery, sizeof sQuery, "SELECT vozila.*, DATE_FORMAT(vozila.registracija, '\%%d/\%%m/\%%Y') as reg1, UNIX_TIMESTAMP(vozila.registracija) as reg2, UNIX_TIMESTAMP(igraci.poslednja_aktivnost) as last_act FROM vozila LEFT JOIN igraci ON igraci.id = vozila.vlasnik WHERE vozila.id = %i", id);
	mysql_tquery(SQL, sQuery, "mysql_v_ucitaj");
}

OwnedVehiclesDialog_AddItem(playerid, index, vehicleid)
{
	gOwnedVehiclesList[playerid][index] = vehicleid;
}

OwnedVehiclesDialog_GetItem(playerid, index)
{
	return gOwnedVehiclesList[playerid][index];
}

OwnedVehicle_GetModel(id)
{
	return OwnedVehicle[id][V_MODEL];
}

OwnedVehicle_GetSecurity(id)
{
	return OwnedVehicle[id][V_SECURITY];
}

OwnedVehicle_IsSpecTuned(id)
{
    return OwnedVehicle[id][V_SPEC_TUNING];
}

nl_public OwnedVehicle_Create(id)
{
	if (OwnedVehicle[id][V_SPAWNED]) return 1;

	if (OwnedVehicle[id][V_SELLING_PRICE] != 0) 
    {
		// Vozilo je stavljeno na prodaju
		foreach (new j : auto_pijaca) 
        {
			OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], gCarMarket_Parcels[j][0], gCarMarket_Parcels[j][1], gCarMarket_Parcels[j][2], gCarMarket_Parcels[j][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
			SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], 0);
			LinkVehicleToInterior(OwnedVehicle[id][V_ID], 0);
			SetVehicleHealth(OwnedVehicle[id][V_ID], (OwnedVehicle[id][V_HEALTH]<250.0?250.1:OwnedVehicle[id][V_HEALTH]));
			// SetVehicleHealth_H: ternary operator sluzi da spreci da se vozilo spawnuje zapaljeno
			
			OwnedVehicle[id][V_CAR_MARKET] = j;
			
			new status[34], sLabel[256];
			if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) status = "{FF0000}nije registrovan";
			else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) status = "{FF9900}registracija istekla";
			else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
				format(status, sizeof(status), "registrovan do {00FF00}%s", OwnedVehicle[id][V_REG_EXPIRY]);
			
			format(sLabel, sizeof sLabel, "{FFFF00}%s na prodaju\n{FFFFFF}Cena: {FFFF00}%s\n{FFFFFF}Presao: {FFFF00}%.1f km\n{FFFFFF}Status: %s\n{FFFFFF}Alarm: {FFFF00}%i posto\n\n{FFFFFF}Da kupite ovaj %s upisite {FFFF00}/kupi %d", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(OwnedVehicle[id][V_SELLING_PRICE]), OwnedVehicle[id][V_MILEAGE], status, OwnedVehicle[id][V_SECURITY], propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), id);
			v_prodaja_tekst[id] = CreateDynamic3DTextLabel(sLabel, BELA, gCarMarket_Parcels[j][0], gCarMarket_Parcels[j][1], gCarMarket_Parcels[j][2]+1.5, 15.0, INVALID_PLAYER_ID, OwnedVehicle[id][V_ID]);
			
			Iter_Remove(auto_pijaca, j);
			break;
		}
	}
	else 
	{
		OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2]+0.3, OwnedVehicle[id][V_POS][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
		LinkVehicleToInterior(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_ENT]);
		SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_VW]);
		
		SetVehicleHealth(OwnedVehicle[id][V_ID], (OwnedVehicle[id][V_HEALTH]<250.0?250.1:OwnedVehicle[id][V_HEALTH]));
		UpdateVehicleDamageStatus(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES]);
	
		// SetVehicleHealth_H: ternary operator sluzi da spreci da se vozilo spawnuje zapaljeno
	}

	if (OwnedVehicle[id][V_TYPE] == automobil || OwnedVehicle[id][V_TYPE] == motor)
		SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
	
	OwnedVehicle[id][V_SPAWNED] = true;
	Iter_Add(iOwnedVehicles, id);
	
	SetVehicleFuel(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_FUEL]);
	if (OwnedVehicle[id][V_TYPE] == automobil)  SetVehicleTankVolume(OwnedVehicle[id][V_ID], 55.0);
	else if (OwnedVehicle[id][V_TYPE] == motor) SetVehicleTankVolume(OwnedVehicle[id][V_ID], 20.0);
	else SetVehicleTankVolume(OwnedVehicle[id][V_ID], 100.0);
	
	// Ucitavanje komponenti za ovo vozilo
	OwnedVehicle[id][V_COMPONENTS] = 0;
    new upit[72];
    format(upit, sizeof upit, "SELECT componentid, part FROM vozila_komponente WHERE v_id = %d", id);
    mysql_tquery(SQL, upit, "mysql_v_komponente", "i", id);

    // Ucitavanje oruzja za ovo vozilo
    OwnedVehicle_ResetWeapons(id);
    format(mysql_upit, 84, "SELECT slot, weapon, ammo FROM vozila_oruzje WHERE v_id = %d ORDER BY slot ASC", id);
    mysql_tquery(SQL, mysql_upit, "mysql_v_oruzje", "i", id);

    // Provera za spec tuning
    OwnedVehicle_SetSpecTuning(id);

    return 1;
}

stock OwnedVehicle_ResetWeapons(id) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_ResetWeapons");
    }

    for__loop (new i = 0; i < 13; i++) {
        VehicleWeapons[id][i][V_WEAPON_ID]  = -1;
        VehicleWeapons[id][i][V_AMMO]    = 0;
    }
    return 1;
}

stock OwnedVehicle_Buy(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_Buy");
    }

    mysql_tquery(SQL, "SELECT (t1.id + 1) as id FROM vozila t1 WHERE NOT EXISTS (SELECT t2.id FROM vozila t2 WHERE t2.id = t1.id + 1) LIMIT 1", "mysql_v_kupovina", "ii", playerid, cinc[playerid]);

    return 1;
}

stock Vehicle_SetNeonLights(id, bool:enable = true, color = -1)
{
    if (DebugFunctions())
    {
        LogFunctionExec("Vehicle_SetNeonLights");
    }

    // id = id u bazi/enumu VEHICLES
    // color = -1 ---> odredi da li vozilo uopste ima neonke + pronadji boju

    new vehicleid = OwnedVehicle[id][V_ID];
    if (!VehicleSupportsNeonLights(GetVehicleModel(vehicleid))) return 1;

    new idx = GetVehicleModel(vehicleid) - 400;

    if(0 <= idx <= 211)
    {
        if (color != -1)
        {
            for__loop (new x = 0; x < 2; x++)
            {
                if (IsValidDynamicObject(OwnedVehicle[id][V_NEON_LIGHT_OBJ][x]))
                {
                    DestroyDynamicObject(OwnedVehicle[id][V_NEON_LIGHT_OBJ][x]);
                	OwnedVehicle[id][V_NEON_LIGHT_OBJ][x] = -1;
                }
            }

            if((NEON_LIGHT_RED <= color <= NEON_LIGHT_WHITE) && enable)
            {
                OwnedVehicle[id][V_NEON_LIGHT_OBJ][0] = CreateDynamicObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                OwnedVehicle[id][V_NEON_LIGHT_OBJ][1] = CreateDynamicObject(color, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);

                AttachDynamicObjectToVehicle(OwnedVehicle[id][V_NEON_LIGHT_OBJ][0], vehicleid, gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);
                AttachDynamicObjectToVehicle(OwnedVehicle[id][V_NEON_LIGHT_OBJ][1], vehicleid, -gTuningVehicleInfo[idx][t_neonOffset][POS_X], gTuningVehicleInfo[idx][t_neonOffset][POS_Y], gTuningVehicleInfo[idx][t_neonOffset][POS_Z], 0.0, 0.0, 0.0);
            }
        }
        return 1;
    }
    return 0;
}

stock OwnedVehicle_ChangeOwnerName(playerid, const newName[MAX_PLAYER_NAME])
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_ChangeOwnerName");
    }

    for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) {
        if (pVehicles[playerid][i] == 0) continue; // prazan slot
        
        new veh = pVehicles[playerid][i];
        strmid(OwnedVehicle[veh][V_OWNER_NAME], newName, 0, strlen(newName), MAX_PLAYER_NAME);
    }
    
}

public OwnedVehicle_LoadForPlayer(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_LoadForPlayer");
    }

    #if defined DEBUG_FUNCTIONS
        Debug("function", "OwnedVehicle_LoadForPlayer");
    #endif
        
	format(mysql_upit, sizeof mysql_upit, "SELECT id FROM vozila WHERE vlasnik = %d", PI[playerid][p_id]);
	mysql_pquery(SQL, mysql_upit, "mysql_v_ucitaj_za_igraca", "ii", playerid, cinc[playerid]);
	
	return 1;
}

public OwnedVehicle_SellOffline(playerid) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_SellOffline");
    }

        
	format(mysql_upit, sizeof mysql_upit, "SELECT * FROM vozila_offline_info WHERE pid = %d", PI[playerid][p_id]);
	mysql_pquery(SQL, mysql_upit, "mysql_v_offline_prodaja", "ii", playerid, cinc[playerid]);
}

public CarMarket_CloseRamp(objectid) 
{
	if (objectid == objCarMarketRampEntrance) 
    {
        MoveDynamicObject(objCarMarketRampEntrance, 1646.056274, -1152.762329, 24.052207-0.005, 0.005, 0.0, -90.0, 0.0);
		gCarMarket_EntranceRampInUse = false;
	}
	else if (objectid == objCarMarketRampExit) 
    {
        MoveDynamicObject(objCarMarketRampExit, 1629.334838, -1152.631713, 23.992797-0.005, 0.005, 0.0, 90.0, 0.0);
		gCarMarket_ExitRampInUse = false;
	}
	
	return 1;
}

forward OwnedVehicle_IncreaseMileage();
public OwnedVehicle_IncreaseMileage() 
{
    foreach (new i : Player) 
    {
        if (!IsPlayerInAnyVehicle(i)) continue;
        
        new 
            vehicleid = GetPlayerVehicleID(i),
            Float:veh_pos[3]
        ;
        if (!vehicleid || !IsValidVehicle(vehicleid) || IsVehicleBicycle(GetVehicleModel(vehicleid)) == 1) continue;
        
        GetVehiclePos(vehicleid, veh_pos[POS_X], veh_pos[POS_Y], veh_pos[POS_Z]);
        kilometraza[i] += GetDistanceBetweenPoints(veh_pos[POS_X], veh_pos[POS_Y], veh_pos[POS_Z], km_pos[i][POS_X], km_pos[i][POS_Y], km_pos[i][POS_Z]);
        GetVehiclePos(vehicleid, km_pos[i][POS_X], km_pos[i][POS_Y], km_pos[i][POS_Z]);

    }
    return 1;
}

OwnedVehicle_GetColor1(id)
{
	return OwnedVehicle[id][V_COLOR_1];
}

OwnedVehicle_GetColor2(id)
{
	return OwnedVehicle[id][V_COLOR_2];
}

OwnedVehicle_GetPrice(id)
{
	return OwnedVehicle[id][V_PRICE];
}

OwnedVehicle_GetRegStatus(id, dest[], len)
{
    if (DebugFunctions())
    {
        LogFunctionExec("OwnedVehicle_GetRegStatus");
    }

	if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) format(dest, len, "neregistrovan");
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) format(dest, len, "reg. istekla");
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
		format(dest, len, "%s", OwnedVehicle[id][V_PLATE]);
}

OwnedVehicle_IsRegistered(id)
{
	if (OwnedVehicle[id][V_REG_STATUS] == REG_DA)
	{
		return true;
	}
	else
	{
		return false;
	}
}

OwnedVehicle_RemoveSpecTuning(id)
{
    if (IsValidDynamicObject(gSpecTuning[id][0]))
    {
        for (new i = 0; i < 27; i++) //Nelson edit
        {
            if (IsValidDynamicObject(gSpecTuning[id][i]))
            {
                DestroyDynamicObject(gSpecTuning[id][i]);
                gSpecTuning[id][i] = INVALID_OBJECT_ID;
            }
        }
    }
}

OwnedVehicle_SetSpecTuning(id, bool:override = false)
{
    if (OwnedVehicle[id][V_SPEC_TUNING] != 1 && !override) return 1;

    new vehicleid = OwnedVehicle[id][V_ID];

    // SandKing
    if (OwnedVehicle[id][V_MODEL] == 495)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1189,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1059,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1059,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(1050,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(1079,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][10] = CreateDynamicObject(1247,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][11] = CreateDynamicObject(1247,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][12] = CreateDynamicObject(1111,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // gSpecTuning[id][13] = CreateDynamicObject(1006,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // gSpecTuning[id][14] = CreateDynamicObject(1006,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }

        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.000, 2.507, -0.314, 13.900, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.000, 2.711, -0.420, 0.000, 90.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, -2.421, -0.420, 0.000, 90.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, 0.890, 2.281, -0.390, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, 0.150, 0.380, -0.190, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, -0.150, 0.380, -0.190, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 0.000, -1.761, 0.960, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, -0.820, 2.389, 0.000, 90.000, 450.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 0.820, 2.389, 0.000, 90.000, -450.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, 0.000, -2.341, 0.160, 0.000, 0.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, -1.062, -0.719, 0.616, 20.100, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, 1.062, -0.719, 0.616, 20.100, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][12], vehicleid, 0.000, 2.620, -0.040, -15.000, 0.000, 0.000);
        // AttachDynamicObjectToVehicle(gSpecTuning[id][13], vehicleid, 0.840, 1.451, 0.350, 0.000, 3.899, 0.000);
        // AttachDynamicObjectToVehicle(gSpecTuning[id][14], vehicleid, -0.840, 1.451, 0.350, 0.000, -3.899, 0.000);
    }

    // NRG-500
    else if (OwnedVehicle[id][V_MODEL] == 522)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1247,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1247,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(18728,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(18749,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }

        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.191, 0.150, -0.074, 17.400, 0.999, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, -0.191, 0.150, -0.074, 17.400, -0.999, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, -0.940, -2.200, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, 0.469, 0.481, -1.080, 0.000, 0.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, -0.469, 0.481, -1.080, 0.000, 0.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 0.000, -0.863, 0.340, 427.400, 270.000, 359.899);
    }

    // Patriot
    else if (OwnedVehicle[id][V_MODEL] == 470)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(2985,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][10] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][11] = CreateDynamicObject(1060,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][12] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][13] = CreateDynamicObject(11727,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][13], 0, 1373, "traincross", "rednwhite", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][13], 1, 9514, "711_sfw", "beachwall_law", 0);
            gSpecTuning[id][14] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][15] = CreateDynamicObject(11727,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][15], 0, 1373, "traincross", "rednwhite", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][15], 1, 9514, "711_sfw", "beachwall_law", 0);
            gSpecTuning[id][16] = CreateDynamicObject(19883,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][16], 0, 18646, "matcolours", "grey-95-percent", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][16], 1, 18646, "matcolours", "grey-95-percent", 0);
            gSpecTuning[id][17] = CreateDynamicObject(19883,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][17], 0, 18646, "matcolours", "grey-95-percent", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][17], 1, 18646, "matcolours", "grey-95-percent", 0);
            gSpecTuning[id][18] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][18] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.000, -2.282, -0.030, 0.000, 0.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.000, -2.721, -0.260, 0.000, 90.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.470, 0.752, 0.355, 35.100, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, -0.470, 0.752, 0.355, 35.100, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, 0.470, 0.631, 0.527, 35.100, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, -0.470, 0.631, 0.527, 35.100, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, -0.470, -1.550, 1.009, -173.200, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, 0.470, -1.550, 1.009, -173.200, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 0.000, 2.411, 0.000, 0.000, 90.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, 0.900, 1.790, 0.410, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, -0.900, 1.790, 0.410, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, 0.000, -1.331, 1.030, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][12], vehicleid, -1.231, -0.260, -0.390, 0.000, -90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][13], vehicleid, 0.810, -2.489, 0.170, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][14], vehicleid, 1.231, -0.260, -0.390, 0.000, 90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][15], vehicleid, -0.810, -2.489, 0.170, 360.000, 180.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][16], vehicleid, -0.810, 2.111, 0.240, 270.000, 540.000, 180.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][17], vehicleid, 0.810, 2.111, 0.240, 270.000, -540.000, -180.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][18], vehicleid, 1.151, 0.900, 0.000, 0.000, 90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][19], vehicleid, -1.151, 0.900, 0.000, 0.000, -90.000, 0.000);
    }

    // Slamvan
    else if (OwnedVehicle[id][V_MODEL] == 535)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(18647,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(18647,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(19314,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(1115,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(19590,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(19590,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, -0.950, -1.471, 0.450, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.950, -1.471, 0.450, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, 0.340, 0.780, 90.000, 90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, -1.031, -1.630, -0.420, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, -1.101, 1.610, -0.380, 0.000, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 1.101, 1.610, -0.380, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 1.031, -1.610, -0.390, 0.000, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, 0.000, 2.511, -0.430, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 1.170, 0.940, 0.112, 0.000, 16.300, 180.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, -1.170, 0.940, 0.112, 0.000, -16.300, -180.000);
    }

    // Turismo
    else if (OwnedVehicle[id][V_MODEL] == 451)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1593,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(19846,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 1.090, -0.170, -0.550, 0.000, 90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, -1.090, -0.170, -0.550, 0.000, -90.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, 1.596, 0.040, -11.400, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, 0.000, -0.510, 0.510, 90.000, 90.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, -0.980, -1.701, -0.330, 180.000, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 0.980, -1.701, -0.330, 180.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 0.980, 1.311, -0.330, -180.000, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, -0.980, 1.301, -0.330, -180.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 0.000, -1.071, -0.390, 0.000, 90.000, 270.000);
    }

    // Cheetah
    else if (OwnedVehicle[id][V_MODEL] == 415)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1002,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(19917,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(19348,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][2], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][3] = CreateDynamicObject(19348,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][3], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][4] = CreateDynamicObject(19348,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][4], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][5] = CreateDynamicObject(19348,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][5], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][6] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(1111,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(1005,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][10] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][11] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][12] = CreateDynamicObject(18648,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][13] = CreateDynamicObject(1115,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // gSpecTuning[id][14] = CreateDynamicObject(1006,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.000, -2.509, 0.240, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.000, -1.641, -0.250, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.290, -2.138, -0.558, 23.700, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, -0.290, -2.138, -0.558, 23.700, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, 0.300, -1.605, 0.132, 80.200, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, -0.300, -1.605, 0.132, 80.200, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 0.370, -0.749, -0.470, 90.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, -0.370, -0.749, -0.470, 90.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 0.000, 2.616, -0.119, -9.900, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, 0.000, 1.391, 0.120, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, 0.641, 2.563, -0.218, 90.699, 2.299, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, -0.670, 2.569, -0.219, 103.399, -2.500, -3.799);
        AttachDynamicObjectToVehicle(gSpecTuning[id][12], vehicleid, 0.000, -2.149, -0.400, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][13], vehicleid, 0.000, 2.689, -0.105, -9.100, 180.000, 0.000);
        // AttachDynamicObjectToVehicle(gSpecTuning[id][14], vehicleid, 0.000, -0.130, 0.540, 0.000, 0.000, 0.000);

    }

    // Bullet
    else if (OwnedVehicle[id][V_MODEL] == 541)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][0], 0, 18996, "mattextures", "sampred", 0);
            gSpecTuning[id][1] = CreateDynamicObject(3003,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][2], 0, 18996, "mattextures", "sampred", 0);
            gSpecTuning[id][3] = CreateDynamicObject(3003,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(11740,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][4], 0, 19607, "enexmarkers", "enexmarker4-2", 0);
            gSpecTuning[id][5] = CreateDynamicObject(11740,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][5], 0, 19607, "enexmarkers", "enexmarker4-2", 0);
            gSpecTuning[id][6] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][6], 0, 18646, "matcolours", "grey-95-percent", 0);
            gSpecTuning[id][7] = CreateDynamicObject(19993,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][7], 0, 18646, "matcolours", "grey-95-percent", 0);
            gSpecTuning[id][8] = CreateDynamicObject(19574,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][8], 0, 18996, "mattextures", "sampred", 0);
            gSpecTuning[id][9] = CreateDynamicObject(19574,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][9], 0, 18996, "mattextures", "sampred", 0);
            gSpecTuning[id][10] = CreateDynamicObject(19141,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][10], 0, 10765, "airportgnd_sfse", "sf_pave2", 0);
            gSpecTuning[id][11] = CreateDynamicObject(19141,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][11], 0, 10765, "airportgnd_sfse", "sf_pave2", 0);
            gSpecTuning[id][12] = CreateDynamicObject(19574,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][12], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][13] = CreateDynamicObject(19574,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][13], 0, 10765, "airportgnd_sfse", "black64", 0);
            gSpecTuning[id][14] = CreateDynamicObject(1112,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            SetDynamicObjectMaterial(gSpecTuning[id][14], 0, 18996, "mattextures", "sampblack", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][14], 1, 18996, "mattextures", "sampblack", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][14], 2, 18996, "mattextures", "sampblack", 0);
            SetDynamicObjectMaterial(gSpecTuning[id][14], 3, 18996, "mattextures", "sampblack", 0);
            gSpecTuning[id][15] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][16] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][17] = CreateDynamicObject(18701,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][18] = CreateDynamicObject(18701,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][19] = CreateDynamicObject(18701,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][20] = CreateDynamicObject(18701,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][21] = CreateDynamicObject(1164,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][22] = CreateDynamicObject(1115,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][23] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][24] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][25] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][26] = CreateDynamicObject(1254,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }

        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, -0.880, 1.830, 0.150, 0.000, 90.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, -0.880, 1.831, 0.150, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.880, 1.830, 0.150, 0.000, -90.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, 0.880, 1.831, 0.150, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, -0.760, -2.121, 0.090, 0.000, 90.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 0.760, -2.121, 0.090, 0.000, -90.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, -0.770, -2.259, 0.100, 0.000, 90.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, 0.770, -2.259, 0.100, 0.000, -90.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, -0.700, 2.281, -0.200, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, 0.700, 2.281, -0.200, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, -0.723, 1.800, 0.140, 0.000, 0.000, 141.400);
        AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, 0.719, 1.785, 0.150, 0.000, 0.000, 79.300);
        AttachDynamicObjectToVehicle(gSpecTuning[id][12], vehicleid, 0.710, 1.851, 0.160, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][13], vehicleid, -0.720, 1.881, 0.160, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][14], vehicleid, 0.000, 1.304, 0.234, 0.500, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][15], vehicleid, 0.000, -0.603, 0.459, 110.599, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][16], vehicleid, 0.000, -0.902, 0.423, 108.799, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][17], vehicleid, -0.690, -0.569, -0.250, 0.000, 90.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][18], vehicleid, 0.690, -0.569, -0.250, 0.000, -90.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][19], vehicleid, -0.570, -0.569, -0.250, 0.000, 90.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][20], vehicleid, 0.570, -0.569, -0.250, 0.000, -90.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][21], vehicleid, 0.000, -2.080, 0.350, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][22], vehicleid, 0.000, 2.330, -0.540, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][23], vehicleid, 1.081, -1.521, -0.180, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][24], vehicleid, -1.081, -1.521, -0.180, 0.000, 0.000, -90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][25], vehicleid, -0.980, 1.521, -0.180, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][26], vehicleid, 0.980, 1.521, -0.180, 0.000, 0.000, -90.000);

    }

    // Infernus
    else if (OwnedVehicle[id][V_MODEL] == 411)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1146,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1146,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(18652,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1178,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1005,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1115,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(1111,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(18693,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(2232,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // gSpecTuning[id][10] = CreateDynamicObject(1006,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // SetDynamicObjectMaterial(gSpecTuning[id][10], 0, 19058, "xmasboxes", "wrappingpaper28", 0);
            // SetDynamicObjectMaterial(gSpecTuning[id][10], 1, 19058, "xmasboxes", "wrappingpaper28", 0);
            // gSpecTuning[id][11] = CreateDynamicObject(1006,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            // SetDynamicObjectMaterial(gSpecTuning[id][11], 0, 19058, "xmasboxes", "wrappingpaper28", 0);
            // SetDynamicObjectMaterial(gSpecTuning[id][11], 1, 19058, "xmasboxes", "wrappingpaper28", 0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.000, -2.411, 0.240, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.000, -2.321, 0.240, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, -2.339, 0.200, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, -0.940, -2.511, -0.280, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, 0.000, 0.030, 0.620, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 0.000, 2.792, -0.600, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 0.000, 2.890, -0.120, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, 0.320, -1.070, -0.450, 0.000, 90.000, 270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, -0.320, -1.070, -0.450, 0.000, -90.000, -270.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, 0.000, -1.080, 0.000, 270.000, 90.000, 720.000);
        // AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, 0.790, 1.581, 0.170, 0.000, 0.000, 0.000);
        // AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, -0.790, 1.581, 0.170, 0.000, 0.000, 0.000);
    }

    // Mesa
    else if (OwnedVehicle[id][V_MODEL] == 500)
    {
        if (!IsValidDynamicObject(gSpecTuning[id][0]))
        {
            gSpecTuning[id][0] = CreateDynamicObject(1145,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][1] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][2] = CreateDynamicObject(1116,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][3] = CreateDynamicObject(1098,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][4] = CreateDynamicObject(1012,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][5] = CreateDynamicObject(1059,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][6] = CreateDynamicObject(18651,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][7] = CreateDynamicObject(18651,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][8] = CreateDynamicObject(1550,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][9] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][10] = CreateDynamicObject(1550,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
            gSpecTuning[id][11] = CreateDynamicObject(1274,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
        }
        AttachDynamicObjectToVehicle(gSpecTuning[id][0], vehicleid, 0.000, 1.592, 0.189, -2.900, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][1], vehicleid, 0.000, 2.114, -0.500, 13.300, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][2], vehicleid, 0.000, 2.131, -0.350, 15.600, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][3], vehicleid, 0.280, -2.089, 0.050, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][4], vehicleid, 0.000, 0.930, 0.199, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][5], vehicleid, 0.030, 0.770, -0.020, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][6], vehicleid, 0.970, 0.130, -0.530, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][7], vehicleid, -0.970, 0.130, -0.530, 0.000, 0.000, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][8], vehicleid, 0.417, -1.079, 0.229, 0.000, 18.600, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][9], vehicleid, -0.879, 0.840, -0.310, 0.000, 0.000, 90.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][10], vehicleid, -0.066, -1.086, 0.231, 12.899, 29.600, 0.000);
        AttachDynamicObjectToVehicle(gSpecTuning[id][11], vehicleid, 0.879, 0.840, -0.310, 0.000, 0.000, -90.000);

    }

    else
    {
        return 0;
    }

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward mysql_v_ucitaj();
forward mysql_v_oruzje(id);
forward mysql_v_komponente(id);
forward mysql_v_kupovina(playerid, ccinc);
forward mysql_v_ucitaj_za_igraca(playerid, ccinc);
forward mysql_v_offline_prodaja(playerid, ccinc);
forward mysql_v_reg_datum(id, playerid, ccinc);

public mysql_v_ucitaj() 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_ucitaj");
    }

	cache_get_row_count(rows);
	
	new id, 
		activityLimit = gettime() - 86400*14,
		createdCount = 0;

	for__loop (new i = 0; i < rows; i++) 
    {
		new 
			spawn[41],
			reg3,
			last_act
		;
		
		cache_get_value_name_int(i, "id", 					id);
		cache_get_value_name_int(i, "vlasnik", 				OwnedVehicle[id][V_OWNER_ID]);
		cache_get_value_name_int(i, "vrsta", 				OwnedVehicle[id][V_TYPE]);
		cache_get_value_name_int(i, "model", 				OwnedVehicle[id][V_MODEL]);
		cache_get_value_name_int(i, "vw", 	 				OwnedVehicle[id][V_VW]);
		cache_get_value_name_int(i, "ent", 	 				OwnedVehicle[id][V_ENT]);
		cache_get_value_name_int(i, "boja1", 				OwnedVehicle[id][V_COLOR_1]);
		cache_get_value_name_int(i, "boja2", 				OwnedVehicle[id][V_COLOR_2]);
		cache_get_value_name_int(i, "cena", 				OwnedVehicle[id][V_PRICE]);
		cache_get_value_name_int(i, "zakljucan", 			OwnedVehicle[id][V_LOCKED]);
		cache_get_value_name_int(i, "prodaja_cena", 		OwnedVehicle[id][V_SELLING_PRICE]);
		cache_get_value_name_int(i, "dmg_status_panels", 	OwnedVehicle[id][V_DMG_STATUS_PANELS]);
		cache_get_value_name_int(i, "dmg_status_doors", 	OwnedVehicle[id][V_DMG_STATUS_DOORS]);
		cache_get_value_name_int(i, "dmg_status_lights", 	OwnedVehicle[id][V_DMG_STATUS_LIGHTS]);
		cache_get_value_name_int(i, "dmg_status_tires", 	OwnedVehicle[id][V_DMG_STATUS_TIRES]);
		cache_get_value_name_int(i, "security", 			OwnedVehicle[id][V_SECURITY]);
        cache_get_value_name_int(i, "spec_tuning",          OwnedVehicle[id][V_SPEC_TUNING]);
		cache_get_value_name_int(i, "reg2", 				reg3);
		cache_get_value_name_int(i, "last_act", 			last_act);
		
		cache_get_value_name_float(i, "km", 		OwnedVehicle[id][V_MILEAGE]);
		cache_get_value_name_float(i, "health", 	OwnedVehicle[id][V_HEALTH]);
		cache_get_value_name_float(i, "gorivo", 	OwnedVehicle[id][V_FUEL]);
	
		cache_get_value_name(i, "vlasnik_ime", 		OwnedVehicle[id][V_OWNER_NAME], MAX_PLAYER_NAME);
		cache_get_value_name(i, "tablica", 			OwnedVehicle[id][V_PLATE], 33);
		cache_get_value_name(i, "pozicija", 		spawn);
		cache_get_value_name(i, "reg1", 			OwnedVehicle[id][V_REG_EXPIRY], 21); // istek registracije, mm/dd/yyyy

        cache_get_value_name_float(i, "servis",       OwnedVehicle[id][V_SERVIS]);
        cache_get_value_name_float(i, "stepen_pokvarenosti", OwnedVehicle[id][V_STEPENPOK]);


		
		sscanf(spawn, "p<|>ffff", OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3]);
		
		if (reg3 > gettime()) 
			OwnedVehicle[id][V_REG_STATUS] = REG_DA;
		else
			OwnedVehicle[id][V_REG_STATUS] = REG_EXP;
		
		if (reg3 == 0) 
			OwnedVehicle[id][V_REG_STATUS] = REG_NE;
		
		OwnedVehicle_ResetWeapons(id);
		OwnedVehicle[id][V_COMPONENTS] = 0;
		OwnedVehicle[id][V_SPAWNED] = false;

		if (last_act > activityLimit)
		{
			createdCount++;
			OwnedVehicle_Create(id);
	    }
	}
	
	printf("[vehicles/ownership.pwn] Ucitano %d vozila, a kreirano je %d vozila.", rows, createdCount);
	
	LOADED[l_vehicles] = 1;
	
	return 1;
}

public mysql_v_oruzje(id) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_oruzje");
    }

    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new slot, i = 0; i < rows; i++) 
    {
        cache_get_value_index_int(i, 0, slot);
        cache_get_value_index_int(i, 1, VehicleWeapons[id][slot][V_WEAPON_ID]);
        cache_get_value_index_int(i, 2, VehicleWeapons[id][slot][V_AMMO]);
    }

    return 1;
}

public mysql_v_komponente(id) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_komponente");
    }

    // Resetovanje komponenti
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][0] = -1;
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][1] = -1;
    for__loop (new i = 0; i < 12; i++) 
        VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;


    cache_get_row_count(rows);
    if (!rows) return 1;

    for__loop (new i = 0; i < 12; i++) { // max. 10 komponenti moze jedno vozilo da ima + 1 paintjob + neonke = 12
        if (i >= rows) break; // Ne postoji toliko mnogo komponenti za ovo vozilo    

        cache_get_value_index_int(i, 0, VehicleComponents[id][i][V_COMPONENT_ID]);
        cache_get_value_index_int(i, 1, VehicleComponents[id][i][V_PART_ID]);


        if (VehicleComponents[id][i][V_COMPONENT_ID] >= 0 && VehicleComponents[id][i][V_COMPONENT_ID] <= 2) // Paintjob
        {
            ChangeVehiclePaintjob(OwnedVehicle[id][V_ID], VehicleComponents[id][i][V_COMPONENT_ID]);
        }
        else if (VehicleComponents[id][i][V_COMPONENT_ID] > 18000)
        {
            Vehicle_SetNeonLights(id, true, VehicleComponents[id][i][V_COMPONENT_ID]);
        }
        else 
        {
            AddVehicleComponent(OwnedVehicle[id][V_ID], VehicleComponents[id][i][V_COMPONENT_ID]);
        }


        OwnedVehicle[id][V_COMPONENTS] |= VehicleComponents[id][i][V_PART_ID];
    }
    return 1;
}

forward MySQL_GiftVehicle(playerid, model, ccinc);
public MySQL_GiftVehicle(playerid, model, ccinc)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MySQL_GiftVehicle");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    new id, rand, spawn[41];

    cache_get_row_count(rows);
    if (!rows) id = 1; // nema rezultata -> nema unosa u tabeli -> pocetni ID je 1
    else cache_get_value_index_int(0, 0, id); // prvi id koji nedostaje u tabeli

    // Promena pozicije ako je brod ili helikopter
    switch (GetPVarInt(playerid, "pAutosalonCat")) {
        case brod: {
            rand = random(sizeof(brodovi_pozicije));
            
            OwnedVehicle[id][V_POS][0] = brodovi_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = brodovi_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = brodovi_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = brodovi_pozicije[rand][POS_A];
        }
        case helikopter: {
            rand = random(sizeof(helikopteri_pozicije));
            
            OwnedVehicle[id][V_POS][0] = helikopteri_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = helikopteri_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = helikopteri_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = helikopteri_pozicije[rand][POS_A];
        }
        case motor, bicikl: {
            rand = random(sizeof(bike_pozicije));
            
            OwnedVehicle[id][V_POS][0] = bike_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = bike_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = bike_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = bike_pozicije[rand][POS_A];
        }
        default: {
            rand = random(sizeof(automobili_pozicije));
            
            OwnedVehicle[id][V_POS][0] = automobili_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = automobili_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = automobili_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = automobili_pozicije[rand][POS_A];
        }
    }

    // Inicijalizacija (varijable se postavljaju isto za sva vozila, posle se menjaju gde se razlikuju
    // Tamo gde nema, npr tablice na bicikli, to je nebitno, ostaje dakle postavljeno, ali se ne koristi dalje u skripti
    OwnedVehicle[id][V_TYPE]			= GetPVarInt(playerid, "pAutosalonCat"),
    OwnedVehicle[id][V_MODEL]           = model,
    OwnedVehicle[id][V_COLOR_1]         = 0,
    OwnedVehicle[id][V_COLOR_2]         = 0,
    OwnedVehicle[id][V_PRICE]           = 0,
    OwnedVehicle[id][V_VW]              = 0,
    OwnedVehicle[id][V_ENT]             = 0,
    OwnedVehicle[id][V_HEALTH]          = 999.0,
    OwnedVehicle[id][V_FUEL]         	= 20.0,
    OwnedVehicle[id][V_LOCKED]       	= 1,
    OwnedVehicle[id][V_OWNER_ID]        = PI[playerid][p_id];
    OwnedVehicle[id][V_SELLING_PRICE]   = 0;
    OwnedVehicle[id][V_SPAWNED]    		= true;
    OwnedVehicle[id][V_SECURITY]    	= 0;
    OwnedVehicle[id][V_SPEC_TUNING]     = 0;
	OwnedVehicle[id][V_MILEAGE] 		= 0.0;
    OwnedVehicle[id][V_SERVIS]          = 0.0;
    OwnedVehicle[id][V_STEPENPOK]       = 0.0;
    strmid(OwnedVehicle[id][V_PLATE], "N/A", 0, strlen("N/A"), 32);
    strmid(OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);

    // Resetovanje komponenti (bez ovoga tuning nece raditi!)
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][0] = -1;
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][1] = -1;
    for__loop (new i = 0; i < 12; i++) 
    {
        VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;
    }
    
    // Kreiranje vozila
    OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
    SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);


    // Resetovanje oruzja
    OwnedVehicle_ResetWeapons(id);
    
    format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f", OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3]);
    
    // Insertovanje vozila u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO vozila (id, vlasnik, vlasnik_ime, vrsta, model, pozicija, cena, gorivo, boja1, boja2, registracija) VALUES (%d, %d, '%s', %d, %d, '%s', %d, %.1f, %d, %d, FROM_UNIXTIME(0))", 
    id, OwnedVehicle[id][V_OWNER_ID], ime_obicno[playerid], OwnedVehicle[id][V_TYPE], OwnedVehicle[id][V_MODEL], spawn, OwnedVehicle[id][V_PRICE], OwnedVehicle[id][V_FUEL], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2]);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEINSERT);

    // Brisanje oruzja iz baze (za svaki slucaj)
    format(mysql_upit, 46, "DELETE FROM vozila_oruzje WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    // Brisanje komponenti iz baze (za svaki slucaj)
    format(mysql_upit, 50, "DELETE FROM vozila_komponente WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);
    
    // Upisivanje u igracev nalog
    pVehicles[playerid][GetPVarInt(playerid, "pAutosalonSlot")] = id;
    
    format(string_128, sizeof string_128, "%s - POKLON | Izvrsio: %s | Model: %s | Cena: $%d | ID: %d", propname(GetPVarInt(playerid, "pAutosalonCat"), PROPNAME_UPPER), ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_PRICE], id);
    Log_Write(LOG_VEHICLES, string_128);
    
    Iter_Add(iOwnedVehicles, id);
    return 1;
}

forward MySQL_VehicleRedeem(playerid, model, ccinc, varid);
public MySQL_VehicleRedeem(playerid, model, ccinc, varid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("MySQL_VehicleRedeem");
    }

    if (!checkcinc(playerid, ccinc)) return 1;

    new id, rand, spawn[41];

    cache_get_row_count(rows);
    if (!rows) id = 1; // nema rezultata -> nema unosa u tabeli -> pocetni ID je 1
    else cache_get_value_index_int(0, 0, id); // prvi id koji nedostaje u tabeli

    // Promena pozicije ako je brod ili helikopter
    switch (GetPVarInt(playerid, "pAutosalonCat")) 
    {
        case brod: {
            rand = random(sizeof(brodovi_pozicije));
            
            OwnedVehicle[id][V_POS][0] = brodovi_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = brodovi_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = brodovi_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = brodovi_pozicije[rand][POS_A];
        }
        case helikopter: 
        {
            rand = random(sizeof(helikopteri_pozicije));
            
            OwnedVehicle[id][V_POS][0] = helikopteri_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = helikopteri_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = helikopteri_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = helikopteri_pozicije[rand][POS_A];
        }
        case motor, bicikl: 
        {
            rand = random(sizeof(bike_pozicije));
            
            OwnedVehicle[id][V_POS][0] = bike_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = bike_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = bike_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = bike_pozicije[rand][POS_A];
        }
        default: 
        {
            rand = random(sizeof(automobili_pozicije));
            
            OwnedVehicle[id][V_POS][0] = automobili_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = automobili_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = automobili_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = automobili_pozicije[rand][POS_A];
        }
    }

    // Inicijalizacija (varijable se postavljaju isto za sva vozila, posle se menjaju gde se razlikuju
    // Tamo gde nema, npr tablice na bicikli, to je nebitno, ostaje dakle postavljeno, ali se ne koristi dalje u skripti
    OwnedVehicle[id][V_TYPE]            = GetPVarInt(playerid, "pAutosalonCat"),
    OwnedVehicle[id][V_MODEL]           = model,
    OwnedVehicle[id][V_COLOR_1]         = 0,
    OwnedVehicle[id][V_COLOR_2]         = 0,
    OwnedVehicle[id][V_PRICE]           = 0,
    OwnedVehicle[id][V_VW]              = 0,
    OwnedVehicle[id][V_ENT]             = 0,
    OwnedVehicle[id][V_HEALTH]          = 999.0,
    OwnedVehicle[id][V_FUEL]            = 20.0,
    OwnedVehicle[id][V_LOCKED]          = 1,
    OwnedVehicle[id][V_OWNER_ID]        = PI[playerid][p_id];
    OwnedVehicle[id][V_SELLING_PRICE]   = 0;
    OwnedVehicle[id][V_SPAWNED]         = true;
    OwnedVehicle[id][V_SECURITY]        = 0;
    OwnedVehicle[id][V_SPEC_TUNING]     = 0;
    OwnedVehicle[id][V_MILEAGE]         = 0.0;
    OwnedVehicle[id][V_SERVIS]          = 0.0;
    OwnedVehicle[id][V_STEPENPOK]       = 0.0;
    strmid(OwnedVehicle[id][V_PLATE], "N/A", 0, strlen("N/A"), 32);
    strmid(OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);

    // Resetovanje komponenti (bez ovoga tuning nece raditi!)
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][0] = -1;
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][1] = -1;
    for__loop (new i = 0; i < 12; i++) 
    {
        VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;
    }
    
    // Kreiranje vozila
    OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
    SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);


    // Resetovanje oruzja
    OwnedVehicle_ResetWeapons(id);
    
    format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f", OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3]);
    
    // Insertovanje vozila u bazu
    format(mysql_upit, sizeof mysql_upit, "INSERT INTO vozila (id, vlasnik, vlasnik_ime, vrsta, model, pozicija, cena, gorivo, boja1, boja2, registracija) VALUES (%d, %d, '%s', %d, %d, '%s', %d, %.1f, %d, %d, FROM_UNIXTIME(0))", 
    id, OwnedVehicle[id][V_OWNER_ID], ime_obicno[playerid], OwnedVehicle[id][V_TYPE], OwnedVehicle[id][V_MODEL], spawn, OwnedVehicle[id][V_PRICE], OwnedVehicle[id][V_FUEL], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2]);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEINSERT);

    // Brisanje oruzja iz baze (za svaki slucaj)
    format(mysql_upit, 46, "DELETE FROM vozila_oruzje WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    // Brisanje komponenti iz baze (za svaki slucaj)
    format(mysql_upit, 50, "DELETE FROM vozila_komponente WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);
    
    // Upisivanje u igracev nalog
    pVehicles[playerid][varid] = id; // fixed by daddyDOT 17.5.2022. (GetPVarInt(playerid, "pAutosalonSlot"))
    
    format(string_128, sizeof string_128, "%s - VIP TOKEN | Izvrsio: %s | Model: %s | Cena: $%d | ID: %d", propname(GetPVarInt(playerid, "pAutosalonCat"), PROPNAME_UPPER), ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_PRICE], id);
    Log_Write(LOG_VEHICLES, string_128);
    Log_Write(LOG_TOKEN, string_128);
    
    Iter_Add(iOwnedVehicles, id);
    return 1;
}

public mysql_v_kupovina(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_kupovina");
    }

	if (!checkcinc(playerid, ccinc)) return 1;
	
	new id;
	
	cache_get_row_count(rows);
	if (!rows) id = 1; // nema rezultata -> nema unosa u tabeli -> pocetni ID je 1
	else cache_get_value_index_int(0, 0, id); // prvi id koji nedostaje u tabeli
	
	new
        model = GetPVarInt(playerid, "pAutosalonModel"),
        color = GetPVarInt(playerid, "pAutosalonColor"),
        price = GetPVarInt(playerid, "pAutosalonPrice"),
        priceGold = 0,//GetVehicleGoldPrice(price, PI[playerid][p_nivo]),
		rand,
		spawn[41]
 	;

	if (PI[playerid][p_novac] < price)
    {
        katalog_Cancel(playerid);
        ErrorMsg(playerid, "Nemas dovoljno novca za ovo vozilo. (%s)", formatMoneyString(price));
        return 1;
    }

    if (PI[playerid][p_zlato] < priceGold)
    {
        katalog_Cancel(playerid);
        ErrorMsg(playerid, "Nemas dovoljno zlatnika za ovo vozilo. (%i)", priceGold);
        return 1;
    }


    if (AUTOSALON_CheckStock(model) <= 0 && !AUTOSALON_IsStockUnlimited())
    {
        katalog_Cancel(playerid);
		ErrorMsg(playerid, "Ovo vozilo je nazalost rasprodato. Moras sacekati da Head Admin dopuni salon vozilima.");
		return 1;
    }
    PlayerMoneySub(playerid, price);
    PI[playerid][p_zlato] -= priceGold;

	// Promena pozicije ako je brod ili helikopter
	switch (GetPVarInt(playerid, "pAutosalonCat")) 
	{
	    case brod: 
	    {
			rand = random(sizeof(brodovi_pozicije));
			
			OwnedVehicle[id][V_POS][0] = brodovi_pozicije[rand][POS_X];
			OwnedVehicle[id][V_POS][1] = brodovi_pozicije[rand][POS_Y];
			OwnedVehicle[id][V_POS][2] = brodovi_pozicije[rand][POS_Z];
			OwnedVehicle[id][V_POS][3] = brodovi_pozicije[rand][POS_A];
		}
	    case helikopter: 
	    {
			rand = random(sizeof(helikopteri_pozicije));
			
			OwnedVehicle[id][V_POS][0] = helikopteri_pozicije[rand][POS_X];
			OwnedVehicle[id][V_POS][1] = helikopteri_pozicije[rand][POS_Y];
			OwnedVehicle[id][V_POS][2] = helikopteri_pozicije[rand][POS_Z];
			OwnedVehicle[id][V_POS][3] = helikopteri_pozicije[rand][POS_A];
		}
        case motor, bicikl: 
        {
            rand = random(sizeof(bike_pozicije));
            
            OwnedVehicle[id][V_POS][0] = bike_pozicije[rand][POS_X];
            OwnedVehicle[id][V_POS][1] = bike_pozicije[rand][POS_Y];
            OwnedVehicle[id][V_POS][2] = bike_pozicije[rand][POS_Z];
            OwnedVehicle[id][V_POS][3] = bike_pozicije[rand][POS_A];
        }
		default: 
		{
			rand = random(sizeof(automobili_pozicije));
			
			OwnedVehicle[id][V_POS][0] = automobili_pozicije[rand][POS_X];
			OwnedVehicle[id][V_POS][1] = automobili_pozicije[rand][POS_Y];
			OwnedVehicle[id][V_POS][2] = automobili_pozicije[rand][POS_Z];
			OwnedVehicle[id][V_POS][3] = automobili_pozicije[rand][POS_A];
		}
	}

	// Inicijalizacija (varijable se postavljaju isto za sva vozila, posle se menjaju gde se razlikuju
	// Tamo gde nema, npr tablice na bicikli, to je nebitno, ostaje dakle postavljeno, ali se ne koristi dalje u skripti
	OwnedVehicle[id][V_TYPE]			= GetPVarInt(playerid, "pAutosalonCat"),
	OwnedVehicle[id][V_MODEL]        	= model,
	OwnedVehicle[id][V_COLOR_1]        	= color,
	OwnedVehicle[id][V_COLOR_2]        	= color,
	OwnedVehicle[id][V_PRICE]         	= price,
	OwnedVehicle[id][V_VW]      		= 0,
	OwnedVehicle[id][V_ENT]    			= 0,
	OwnedVehicle[id][V_HEALTH]       	= 999.0,
	OwnedVehicle[id][V_FUEL]       		= 55.0,
	OwnedVehicle[id][V_LOCKED]	 		= 1,
	OwnedVehicle[id][V_OWNER_ID] 		= PI[playerid][p_id];
	OwnedVehicle[id][V_SELLING_PRICE]   = 0;
	OwnedVehicle[id][V_SPAWNED]    		= true;
	OwnedVehicle[id][V_REG_STATUS]		= REG_NE;
	OwnedVehicle[id][V_SECURITY]		= 0;
    OwnedVehicle[id][V_SPEC_TUNING]     = 0;
	OwnedVehicle[id][V_MILEAGE] 		= 0.0;
    OwnedVehicle[id][V_SERVIS]          = 0.0;
    OwnedVehicle[id][V_STEPENPOK]       = 0.0;
	strmid(OwnedVehicle[id][V_PLATE], "N/A", 0, strlen("N/A"), 32);
	strmid(OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);

    // Resetovanje komponenti (bez ovoga tuning nece raditi!)
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][0] = -1;
    OwnedVehicle[id][V_NEON_LIGHT_OBJ][1] = -1;
    for__loop (new i = 0; i < 12; i++) 
    {
        VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;
    }
	
	// Kreiranje vozila
	OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
	SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);


	// Ciscenje chata za predstojecu poruku
	ClearChatForPlayer(playerid);

    // Resetovanje oruzja
    OwnedVehicle_ResetWeapons(id);
	
	format(string_256, sizeof string_256, "{FFFFFF}Uspesno ste kupili {FFFF00}%s.\n\n{FFFFFF}Model: {FFFF00}%s (%d)\n{FFFFFF}Cena vozila: {FFFF00}%i\n{FFFFFF}Tablice: {FFFF00}[neregistrovan]", propname(GetPVarInt(playerid, "pAutosalonCat"), PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_MODEL], formatMoneyString(OwnedVehicle[id][V_PRICE]));
	SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "{FFFF00}Kupovina vozila", string_256, "Zatvori", "");
	
	format(spawn, sizeof(spawn), "%.4f|%.4f|%.4f|%.4f", OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], OwnedVehicle[id][V_POS][3]);
	

	// Insertovanje vozila u bazu
    new sQuery[266];
	format(sQuery, sizeof sQuery, "INSERT INTO vozila (id, vlasnik, vlasnik_ime, vrsta, model, pozicija, cena, gorivo, boja1, boja2, registracija) VALUES (%d, %d, '%s', %d, %d, '%s', %d, %.1f, %d, %d, FROM_UNIXTIME(0))", 
	id, OwnedVehicle[id][V_OWNER_ID], ime_obicno[playerid], OwnedVehicle[id][V_TYPE], OwnedVehicle[id][V_MODEL], spawn, OwnedVehicle[id][V_PRICE], OwnedVehicle[id][V_FUEL], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2]);
	mysql_tquery(SQL, sQuery); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEINSERT);

    // Brisanje oruzja iz baze (za svaki slucaj)
    new sQuery_2[51];
    format(sQuery_2, sizeof sQuery, "DELETE FROM vozila_oruzje WHERE v_id = %d", id);
    mysql_tquery(SQL, sQuery_2); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);
    // Brisanje komponenti iz baze (za svaki slucaj)
    format(sQuery_2, sizeof sQuery, "DELETE FROM vozila_komponente WHERE v_id = %d", id);
    mysql_tquery(SQL, sQuery_2); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    // Cuvanje igracevog novca i zlatnika
    new sQuery_3[75];
    format(sQuery_3, sizeof sQuery_3, "UPDATE igraci SET novac = %i, zlato = %i WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
    mysql_tquery(SQL, sQuery_3);
	
	// Upisivanje u igracev nalog
	pVehicles[playerid][GetPVarInt(playerid, "pAutosalonSlot")] = id;
	
	format(string_128, sizeof string_128, "%s - KUPOVINA (salon) | Izvrsio: %s | Model: %s | Cena: $%d | ID: %d", propname(GetPVarInt(playerid, "pAutosalonCat"), PROPNAME_UPPER), ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_PRICE], id);
	Log_Write(LOG_VEHICLES, string_128);

    // Smanjivanje lagera
    if (!AUTOSALON_IsStockUnlimited())
    {
        AUTOSALON_ReduceStock(GetPVarInt(playerid, "pAutosalonCat"), model);
    }

	// Resetovanje
	SetCameraBehindPlayer(playerid);
	SetGPSLocation(playerid, OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2], "lokacija vozila");
	
	Iter_Add(iOwnedVehicles, id);

    // Sakrivanje svih TD-ova vezano za kupovinu vozila
    katalog_Cancel(playerid);
	return 1;
}

public mysql_v_ucitaj_za_igraca(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_ucitaj_za_igraca");
    }

	if (!checkcinc(playerid, ccinc)) return 1;
	
	cache_get_row_count(rows);
	if (rows == 0) return 1;
	
	if (rows > PI[playerid][p_vozila_slotovi]) 
	{
		SendClientMessage(playerid, TAMNOCRVENA2, "(greska) Sa Vasim nalogom je povezan veci broj vozila nego sto imate dozvoljenih slotova.");
		format(string_64, 64, "Pronadjeno je %d vozila, a ucitano je %d", rows, PI[playerid][p_vozila_slotovi]);
		SendClientMessage(playerid, TAMNOCRVENA2, string_64);
	} // ne treba return 1, ovo je samo upozorenje
	
	new exp = 0;
	for__loop (new i = 0; i < ((rows>PI[playerid][p_vozila_slotovi])?PI[playerid][p_vozila_slotovi]:rows); i++) 
	{
		cache_get_value_index_int(i, 0, pVehicles[playerid][i]);
		
		new id = pVehicles[playerid][i];
		OwnedVehicle_Create(id);
		
		if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) 
		{
			exp++;
			
			format(string_128, sizeof string_128, "Registracija je istekla za %s {880000}%s, {FF6347}registarskih oznaka {880000}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_PLATE]);
			SendClientMessage(playerid, SVETLOCRVENA, string_128);
		}
	}
	if (exp != 0)
		SendClientMessage(playerid, BELA, "* Registraciju mozete obnoviti u opstini.");
	
	return 1;
}

public mysql_v_offline_prodaja(playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_offline_prodaja");
    }

	if (!checkcinc(playerid, ccinc)) return 1;
	
	cache_get_row_count(rows);
	if (rows == 0) return 1;
	
	new
        pid,
		id,
		model,
		cena,
		vrsta
	;
	
	for__loop (new i = 0; i < rows; i++) 
	{
        cache_get_value_index_int(i, 0, pid); // id igraca
		cache_get_value_index_int(i, 1, id); // id vozila
		cache_get_value_index_int(i, 2, model);
		cache_get_value_index_int(i, 3, cena);
		cache_get_value_index_int(i, 4, vrsta);
		
		SendClientMessageF(playerid, SVETLOPLAVA, "* Vas %s %s [ID: %d] je prodat dok ste bili odsutni. Zaradili ste %s.", propname(vrsta, PROPNAME_LOWER), imena_vozila[model - 400], id, formatMoneyString(cena));
	}

    format(mysql_upit, sizeof mysql_upit, "DELETE FROM vozila_offline_info WHERE pid = %d", pid);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEOFFLINE);
	
	return 1;
}

public mysql_v_reg_datum(id, playerid, ccinc) 
{
    if (DebugFunctions())
    {
        LogFunctionExec("mysql_v_reg_datum");
    }

	cache_get_row_count(rows);
	if (!rows) return 1;

	cache_get_value_name(0, "reg", OwnedVehicle[id][V_REG_EXPIRY]);
	
	if (checkcinc(playerid, ccinc)) 
	{
		SendClientMessageF(playerid, BELA, "* Registracija vazi do {FFFF00}%s {FFFFFF}(narednih 30 dana).", OwnedVehicle[id][V_REG_EXPIRY]);
	}
	
	
	return 1;
}
forward GetVehFaulty(vehicleid);
public GetVehFaulty(vehicleid)
{
    if (vehicleid < 0 || vehicleid >= MAX_VEHICLES) return -1;

    if(OwnedVehicle[vehicleid][V_STEPENPOK] > 0.0) return 1;
    else return 0;
}



// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:aveh(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	if (listitem == 0) // Informacije
	{
		dialog_respond:v_general(playerid, 1, 0, "Informacije");
	}
	else if (listitem == 1) // Parkiraj
	{
		dialog_respond:v_general(playerid, 1, 2, "Parkiraj");
        //HidePlayerDialog(playerid);
	}
	else if (listitem == 2) // Teleport do sebe
	{
		dialog_respond:v_general(playerid, 1, 8, "Teleport do sebe");
        //HidePlayerDialog(playerid);
	}
	return 1;
}

Dialog:vozila(playerid, response, listitem, const inputtext[]) 
{
	if (!response) 
		return SPD(playerid, "imovina", DIALOG_STYLE_LIST, "{0068B3}UPRAVLJANJE IMOVINOM", "Vozila\nNekretnine", "Odaberi", "Izadji");
	
	new
		sTitle[36],
		slot = OwnedVehiclesDialog_GetItem(playerid, listitem),
		vehid = pVehicles[playerid][slot], // id u bazi, a ne id kreiranog vozila
		vrsta = OwnedVehicle[vehid][V_TYPE]
	;
	vozila_uredjuje_slot[playerid] = slot;
	vozila_uredjuje_item[playerid] = listitem;
	format(sTitle, sizeof(sTitle), "{FFFF00}Slot %d: %s", slot+1, imena_vozila[OwnedVehicle[vehid][V_MODEL] - 400]);
	
	format(string_256, sizeof string_256, "Informacije\nLociraj %s\nParkiraj %s\nProdaj %s\nPromeni boju\n%s %s\nOpcije vozila\nRespawnaj %s\nTeleport do sebe",
	propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER), ((OwnedVehicle[vehid][V_LOCKED]==1)?("Otkljucaj"):("Zakljucaj")), propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER));
	
	if (vrsta != bicikl) strins(string_256, "\nGepek", strlen(string_256));
	
    SetPVarInt(playerid, "pEditingVehType", vrsta);
    aveh[playerid] = -1;
	
	SPD(playerid, "v_general", DIALOG_STYLE_LIST, sTitle, string_256, "Odaberi", "Nazad");
	
	return 1;
}

Dialog:v_return(playerid, response, listitem, const inputtext[]) 
{
    if (aveh[playerid] !=-1)
        return 1; // ako je koristio /aveh, nece moci da ide nazad kroz dialoge, nego ce mu se zatvoriti

    
	return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
}

Dialog:v_general(playerid, response, listitem, const inputtext[]) 
{
	if (!response) 
		return dialog_respond:imovina(playerid, 1, 0, ""), DeletePVar(playerid, "pEditingVehType");
	
	new
		sTitle[36],
		Float:ostecenost, // ostecenost u procentima (900hp = 10% ostecenosti)
		slot = vozila_uredjuje_slot[playerid],
		id = ((aveh[playerid]==-1)? pVehicles[playerid][slot] : aveh[playerid]), // id u bazi, a ne id kreiranog vozila
		vrsta = OwnedVehicle[id][V_TYPE]
	;
	GetVehicleHealth(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_HEALTH]);
	ostecenost = (1 - OwnedVehicle[id][V_HEALTH]/1000.0) * 100,
	
	format(sTitle, sizeof sTitle, "{FFFF00}Slot %d: %s", slot+1, imena_vozila[OwnedVehicle[id][V_MODEL] - 400]);
	
	switch(listitem) 
    {
    	case 0: // Informacije
        {
    		switch(OwnedVehicle[id][V_TYPE]) 
    		{
    			case bicikl: 
    			{
    				new sDialog[160];
    				format(sDialog, sizeof sDialog, "{FFFF00}%s (ID: %d)\n\n{FFFFFF}Vrednost: {FFFF00}%s\n{FFFFFF}Vlasnik: {FFFF00}%s", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], id, formatMoneyString(OwnedVehicle[id][V_PRICE]), OwnedVehicle[id][V_OWNER_NAME]);

    				SPD(playerid, "v_return", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");
    			}
    			case brod, helikopter: 
                {
                	new sDialog[312];
    				format(sDialog, sizeof sDialog, "{FFFF00}%s (ID: %d)\n\n{FFFFFF}Vrednost: {FFFF00}%s\n{FFFFFF}Maksimalna brzina: {FFFF00}%d km/h\n{FFFFFF}Vlasnik: {FFFF00}%s\n{FFFFFF}Ostecenost: {FFFF00}%.1f%%\n{FFFFFF}Gorivo: {FFFF00}%.1f litara\n{FFFFFF}Alarm: {FFFF00}%i posto sigurnosti", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], id, formatMoneyString(OwnedVehicle[id][V_PRICE]), GetVehicleTopSpeed(OwnedVehicle[id][V_MODEL]), OwnedVehicle[id][V_OWNER_NAME], ostecenost, GetVehicleFuel(OwnedVehicle[id][V_ID]), OwnedVehicle[id][V_SECURITY]);

    				SPD(playerid, "v_return", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");
    			}
    			case automobil, motor: 
    			{
    				new sDialog[460],
    					szStatus[34]
                    ;
    				if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) szStatus = "{FF0000}nije registrovan";
    				else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) szStatus = "{FF9900}registracija istekla";
    				else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) format(szStatus, sizeof(szStatus), "registrovan do {00FF00}%s", OwnedVehicle[id][V_REG_EXPIRY]);
    					
    	
    				format(sDialog, sizeof sDialog, "{FFFF00}%s (ID: %d)\n\n{FFFFFF}Vrednost: {FFFF00}%s\n{FFFFFF}Maksimalna brzina: {FFFF00}%d km/h\n{FFFFFF}Vlasnik: {FFFF00}%s\n{FFFFFF}Status: %s\n{FFFFFF}Tablice: {FFFF00}%s\n{FFFFFF}Kilometraza: {FFFF00}%.1f km\n{FFFFFF}Ostecenost: {FFFF00}%.1f%%\n{FFFFFF}Gorivo: {FFFF00}%.1f litara\n{FFFFFF}Alarm: {FFFF00}%i posto sigurnosti\n{FFFFFF}Servis za: {FFFF00}%.1f", 
    				imena_vozila[OwnedVehicle[id][V_MODEL] - 400], id, formatMoneyString(OwnedVehicle[id][V_PRICE]), GetVehicleTopSpeed(OwnedVehicle[id][V_MODEL]), OwnedVehicle[id][V_OWNER_NAME], szStatus, OwnedVehicle[id][V_PLATE], OwnedVehicle[id][V_MILEAGE], ostecenost, GetVehicleFuel(OwnedVehicle[id][V_ID]), OwnedVehicle[id][V_SECURITY], OwnedVehicle[id][V_SERVIS]);

    				SPD(playerid, "v_return", DIALOG_STYLE_MSGBOX, sTitle, sDialog, "Nazad", "");
    			}
    		}
    	}
    	
    	case 1: // Lociraj
        {
    		new Float:poz[3], vw = GetVehicleVirtualWorld(OwnedVehicle[id][V_ID]);
    	    GetVehiclePos(OwnedVehicle[id][V_ID], poz[POS_X], poz[POS_Y], poz[POS_Z]);
    	    
    		if (vw > 0)
            {
                // Virtual je > 0, vozilo je verovatno parkirano u nekoj garazi
                if (re_odredivrstu(vw) == kuca) // za nekretnine: vw == gid
                {
                    SetGPSLocation(playerid, RealEstate[vw][RE_GARAZA][0], RealEstate[vw][RE_GARAZA][1], RealEstate[vw][RE_GARAZA][2], "lokacija vozila (kucna garaza)");
                }
                else if (re_odredivrstu(vw) == garaza)
                {
                    SetGPSLocation(playerid, RealEstate[vw][RE_ULAZ][0], RealEstate[vw][RE_ULAZ][1], RealEstate[vw][RE_ULAZ][2], "lokacija vozila (garaza)");
                }
            }
    		else SetGPSLocation(playerid, poz[POS_X], poz[POS_Y], poz[POS_Z], "lokacija vozila");
    	}
    	
    	case 2: // Parkiraj
        {
    		if (GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID]) 
    			return ErrorMsg(playerid, "Morate biti u svom vozilu da biste ga parkirali.");
    		
    	    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
    			return ErrorMsg(playerid, "Morate biti na mestu vozaca da biste parkirali ovo vozilo.");
    		
    	    if (IsPlayerInArea(playerid, 1524.091, -1373.938, 1801.698, -1144.969) == 1) 
    			return ErrorMsg(playerid, "Ne mozete parkirati vozilo blizu spawna.");
    		
    		if (IsPlayerInArea(playerid, 1530.92, -1100.53, 1820.35, -995.27) || IsPlayerInArea(playerid, 1591.7, -1143.8, 1684.72, -1090.67))
    			return ErrorMsg(playerid, "Da bi vozilo bilo parkirano na auto pijaci, prvo ga morate staviti na prodaju.");
    		
    		new
    			Float:poz[5],
    			ent,
    			vw
    		;
    	    GetVehiclePos(OwnedVehicle[id][V_ID], poz[0], poz[1], poz[2]);
    	    GetVehicleZAngle(OwnedVehicle[id][V_ID], poz[3]);
            GetVehicleHealth(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_HEALTH]);
            poz[2] += 0.5;
    	    poz[4] = GetVehicleFuel(OwnedVehicle[id][V_ID]);
    	    ent    = GetPlayerInterior(playerid);
    	    vw     = GetPlayerVirtualWorld(playerid);
    		
    		if (OwnedVehicle[id][V_HEALTH] < 300.0 && aveh[playerid] == -1)
    		{
    		    format(string_128, sizeof string_128, "Vas %s je previse ostecen! Da biste ga parkirali, najpre ga popravite.", propname(vrsta, PROPNAME_LOWER));
    			ErrorMsg(playerid, string_128);

    			return 1;
    		}
    		
    		new engine, lights, alarm, doors, bonnet, boot, objective;
    		GetVehicleParamsEx(OwnedVehicle[id][V_ID], engine, lights, alarm, doors, bonnet, boot, objective);
    		GetVehicleDamageStatus(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES]);
            Vehicle_SetNeonLights(id, false);
            OwnedVehicle_RemoveSpecTuning(id);
    	    DestroyVehicle(OwnedVehicle[id][V_ID]);
    	    OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], poz[0], poz[1], poz[2], poz[3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
    	    SetVehicleHealth(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_HEALTH]);
    	    SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], vw);
    		LinkVehicleToInterior(OwnedVehicle[id][V_ID], ent);
            // Vehicle_SetNeonLights(id, true, -1);
    	    SetVehicleFuel(OwnedVehicle[id][V_ID], poz[4]);
            OwnedVehicle[id][V_VW] = vw;
            OwnedVehicle[id][V_ENT] = ent;
    	    
    	    if (vrsta == automobil || vrsta == motor) 
            {
    			SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
    			SetVehicleToRespawn(OwnedVehicle[id][V_ID]);
    	    }
        	SetVehicleParamsEx(OwnedVehicle[id][V_ID], 1, lights, alarm, doors, bonnet, boot, objective);
    	    PutPlayerInVehicle(playerid, OwnedVehicle[id][V_ID], 0);
    		
    		// Update u bazi
    		new sQuery[259];
    		format(sQuery, sizeof sQuery, "UPDATE vozila SET pozicija = '%.4f|%.4f|%.4f|%.4f', ent = %d, vw = %d, health = %.1f, gorivo = %.1f, dmg_status_panels = %d, dmg_status_doors = %d, dmg_status_lights = %d, dmg_status_tires = %d WHERE id = %d", poz[0], poz[1], poz[2], poz[3], ent, vw, OwnedVehicle[id][V_HEALTH], GetVehicleFuel(OwnedVehicle[id][V_ID]), OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES], id);
    		mysql_tquery(SQL, sQuery);
    		
    	    SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Uspesno ste parkirali svoj %s.", propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER));
    	}
    	
    	case 3: // Prodaj
        {
            if (GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID]) 
                return ErrorMsg(playerid, "Morate biti u svom vozilu da biste ga prodali.");

    	    format(string_32, 32, "{FFFF00}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
            SPD(playerid, "v_prodaja", DIALOG_STYLE_LIST, string_32, "Stavi na prodaju\nProdaj auto-salonu\nProdaj igracu\nZameni sa igracem", "Dalje »", "« Nazad");
    	}
    	
    	case 4: // Promeni boju
        {    
    		return InfoMsg(playerid, "Nedostupno");
    	}
    	
    	case 5: // Otkljucaj/zakljucaj
        {
    		new Float:poz[3];
    	    GetVehiclePos(OwnedVehicle[id][V_ID], poz[0], poz[1], poz[2]);
    	    if (!IsPlayerInRangeOfPoint(playerid, 10.0, poz[0], poz[1], poz[2])) 
    			return ErrorMsg(playerid, "Morate biti blizu svog vozila.");

    	    if (OwnedVehicle[id][V_LOCKED] == 0) // Zakljucavanje
    	    {
    	        SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Vas %s je sada {FF0000}zakljucan.", propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER));
    	    }
    	    else // Otkljucavanje
    	    {
    	        SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Vas %s je sada {00FF00}otkljucan.", propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER));
    	    }
    	    OwnedVehicle[id][V_LOCKED] = (OwnedVehicle[id][V_LOCKED] == 0)? 1 : 0;

    	    format(string_64, 40, "** Beep-Beep (( %s ))", ime_rp[playerid]);
    	    RangeMsg(playerid, string_64, LJUBICASTA, 30.0);
    		
    		new sQuery[49];
    	    format(sQuery, sizeof sQuery, "UPDATE vozila SET zakljucan = %d WHERE id = %d", OwnedVehicle[id][V_LOCKED], id);
    	    mysql_tquery(SQL, sQuery);
    	}

        case 6: // Opcije vozila
        {
            return callcmd::vopcije(playerid, "");
        }

        case 7: // Respawnaj vozilo
        {
            if (!IsVIP(playerid, 3) && !IsAdmin(playerid, 6))
                return ErrorMsg(playerid, "Samo igraci sa VIP statusom mogu koristiti ovu opciju | koristite {FF0000}/vip");

            if (IsVehicleOccupied_OW(OwnedVehicle[id][V_ID]) && GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID])
                return ErrorMsg(playerid, "Ne mozete respawnati vozilo dok ga neko koristi.");

            SetVehicleToRespawn(OwnedVehicle[id][V_ID]);
            SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_VW]);
            LinkVehicleToInterior(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_ENT]);

            SendClientMessage(playerid, SVETLOPLAVA, "* Respawnali ste svoje vozilo.");
        }

        case 8: // Teleport do sebe
        {
        	if (aveh[playerid] != -1)
        	{
        		// Onemoguciti teleport vozila preko /aveh ako je vlasnik offline  + ako nije head admin
        		if (!IsAdmin(playerid, 6))
        		{
        			new vehOwner = INVALID_PLAYER_ID;
        			foreach(new i : Player) 
        			{
						if (PI[i][p_id] == OwnedVehicle[id][V_OWNER_ID]) 
						{
							vehOwner = i;
							break;
						}
					}

					if (!IsPlayerConnected(vehOwner))
						return ErrorMsg(playerid, "Ne mozete koristiti ovu opciju jer vlasnik vozila nije online.");

					if (!IsPlayerNearPlayer(playerid, vehOwner, 10.0))
						return ErrorMsg(playerid, "Potrebno je da vlasnik vozila stoji pored Vas.");
        		}
        	}
        	else
        	{
        		if (!IsVIP(playerid, 4) && !IsAdmin(playerid, 6))
                return ErrorMsg(playerid, "Samo igraci sa VIP statusom mogu koristiti ovu opciju | koristite {FF0000}/vip");

	            if (IsVehicleOccupied_OW(OwnedVehicle[id][V_ID]))
	                return ErrorMsg(playerid, "Ne mozete teleportovati vozilo dok ga neko koristi.");
        	}
            

            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], GetPlayerVirtualWorld(playerid));
            LinkVehicleToInterior(OwnedVehicle[id][V_ID], GetPlayerInterior(playerid));
            SetVehiclePos(OwnedVehicle[id][V_ID], x+3.0, y, z);

            InfoMsg(playerid, "Teleportovali ste svoje vozilo do sebe.");
        }
    	
    	case 9: // Gepek
        {
            format(string_32, 32, "{FFFF00}%s - GEPEK", propname(vrsta, PROPNAME_UPPER));
    		SPD(playerid, "v_gepek", DIALOG_STYLE_LIST, string_32, "Uzmi iz gepeka\nStavi u gepek", "Dalje »", "« Nazad");
    	}
	}
	
	return 1;
}

Dialog:v_gepek(playerid, response, listitem, const inputtext[]) 
{
    if (!response)
        return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");

    new
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = OwnedVehicle[id][V_TYPE],
        sTitle[35],
        weapon[22],
        string[450],
        Float:pos[3];

    if (vrsta != automobil)
        return ErrorMsg(playerid, "Mozete pristupiti samo gepeku automobila, ne i drugih vozila.");

    GetPosBehindVehicle(OwnedVehicle[id][V_ID], pos[POS_X], pos[POS_Y], pos[POS_Z]);
    if (!IsPlayerInRangeOfPoint(playerid, 1.0, pos[POS_X], pos[POS_Y], pos[POS_Z])) {
        ErrorMsg(playerid, "Ne nalazite se blizu gepeka ovog vozila.");
        return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
    }
    
    oruzje_slot[playerid] = -1;
    switch (listitem) 
    {
        case 0: // Uzmi iz gepeka
        {
            if (IsPlayerOnLawDuty(playerid))
                return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete nista uzeti iz gepeka.");

            if (IsPlayerInDMEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista uzeti iz gepeka.");

            if (IsPlayerInHorrorEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista uzeti iz gepeka.");

            format(sTitle, sizeof(sTitle), "{FF9900}%s - UZMI IZ GEPEKA", propname(vrsta, PROPNAME_CAPITAL));
            format(string, 23, "Slot\tOruzje\tMunicija");

            for__loop (new i = 0; i < 13; i++) 
            {
                if (VehicleWeapons[id][i][V_WEAPON_ID] == -1 || VehicleWeapons[id][i][V_AMMO] <= 0) continue;

                GetWeaponName(VehicleWeapons[id][i][V_WEAPON_ID], weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, VehicleWeapons[id][i][V_AMMO]);
            }

            SPD(playerid, "v_gepek_uzmi", DIALOG_STYLE_TABLIST_HEADERS, sTitle, string, "Uzmi", "Nazad");
        }

        case 1: // Stavi u gepek
        {
            if (IsPlayerOnLawDuty(playerid))
                return ErrorMsg(playerid, "Vi ste na policijskoj duznosti i ne mozete nista ostaviti u gepek.");

            if (IsPlayerInDMEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u DM Event-u i ne mozete nista ostaviti u gepek.");

            if (IsPlayerInHorrorEvent(playerid))
                return ErrorMsg(playerid, "Trenutno ucestvujete u Horor Event-u i ne mozete nista ostaviti u gepek.");

            new
                weaponid,
                ammo;

            format(sTitle, sizeof(sTitle), "{FFFF00}%s - STAVI U GEPEK", propname(vrsta, PROPNAME_CAPITAL));
            format(string, 23, "Slot\tOruzje\tMunicija");
            for__loop (new i = 0; i < 13; i++) {
                weaponid    = GetPlayerWeaponInSlot(playerid, i);
                ammo        = GetPlayerAmmoInSlot(playerid, i);
                if (weaponid <= 0 || ammo <= 0) continue;

                GetWeaponName(weaponid, weapon, sizeof(weapon));
                format(string, sizeof(string), "%s\n%d\t%s\t%d", string, i, weapon, ammo);
            }

            SPD(playerid, "v_gepek_stavi", DIALOG_STYLE_TABLIST_HEADERS, sTitle, string, "Stavi", "Nazad");
        }
    }

    return 1;
}

Dialog:v_gepek_uzmi(playerid, response, listitem, const inputtext[]) {
    if (!response)
        return dialog_respond:v_general(playerid, 1, 6, "Gepek");

    new 
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = OwnedVehicle[id][V_TYPE],
        slot = strval(inputtext), // odnosi se na slot oruzja, a ne na slot gde se nalazi vozilo
        weaponid,
        ammo,
        weapon[22],
        sTitle[35];

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid = VehicleWeapons[id][slot][V_WEAPON_ID];
    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    ammo = VehicleWeapons[id][slot][V_AMMO];
    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    oruzje_slot[playerid] = slot;
    format(sTitle, sizeof(sTitle), "{FF9900}%s - UZMI IZ GEPEKA", propname(vrsta, PROPNAME_CAPITAL));
    format(string_256, 160, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da uzmete:", weapon, ammo);
    SPD(playerid, "v_gepek_uzmi_potvrda", DIALOG_STYLE_INPUT, sTitle, string_256, "Uzmi", "Nazad");

    return 1;
}

Dialog:v_gepek_uzmi_potvrda(playerid, response, listitem, const inputtext[]) {
    if (!response)
        return dialog_respond:v_gepek(playerid, 1, 0, "");

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
        return DialogReopen(playerid);
    }

    new
        slot    = oruzje_slot[playerid],
        id      = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta   = OwnedVehicle[id][V_TYPE],
        weaponid,
        weapon[22],
        ammo;

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid= VehicleWeapons[id][slot][V_WEAPON_ID];
    ammo    = VehicleWeapons[id][slot][V_AMMO];

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nema toliko municije za ovo oruzje u gepeku.");
        return DialogReopen(playerid);
    }

    if (GetPlayerWeaponInSlot(playerid, slot) != weaponid)
        GivePlayerWeapon(playerid, weaponid, 0);
    
    SetPlayerAmmo(playerid, weaponid, GetPlayerAmmoInSlot(playerid, slot)+input);
    VehicleWeapons[id][slot][V_AMMO] -= input;

    // Update podataka u bazi
    if (VehicleWeapons[id][slot][V_AMMO] <= 0) { 
        // Igrac je uzeo svu municiju, izbrisati oruzje iz gepeka
        VehicleWeapons[id][slot][V_WEAPON_ID] = -1;

        format(mysql_upit, 78, "DELETE FROM vozila_oruzje WHERE v_id = %d AND slot = %d AND weapon = %d", id, slot, weaponid);
        mysql_tquery(SQL, mysql_upit);
    }
    else {
        // Nije uzeo sve, samo uraditi update municije
        format(mysql_upit, 72, "UPDATE vozila_oruzje SET ammo = %d WHERE v_id = %d AND slot = %d", VehicleWeapons[id][slot][V_AMMO], id, slot);
        mysql_tquery(SQL, mysql_upit);
    }

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Uzeli ste {FFFF00}%s {FFFFFF}i {FFFF00}%d metaka {FFFFFF}iz gepeka.", propname(vrsta, PROPNAME_CAPITAL), weapon, input);
    SendClientMessageF(playerid, BELA, "* U gepeku je ostalo jos {FFFF00}%d metaka {FFFFFF}za ovo oruzje.", VehicleWeapons[id][slot][V_AMMO]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "UZIMANJE | %s | %s | Uzeo %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_VEHICLES_WEAPONS, string_128);

    return dialog_respond:v_gepek(playerid, 1, 0, "");
}

Dialog:v_gepek_stavi(playerid, response, listitem, const inputtext[]) {
    if (!response)
        return dialog_respond:v_general(playerid, 1, 6, "Gepek");

    new 
        id          = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta       = OwnedVehicle[id][V_TYPE],
        slot        = strval(inputtext), // odnosi se na slot oruzja, a ne na slot gde se nalazi vozilo
        weaponid    = GetPlayerWeaponInSlot(playerid, slot),
        ammo        = GetPlayerAmmoInSlot(playerid, slot),
        weapon[22],
        sTitle[35];

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznat slot)");

    if (weaponid == -1)
        return ErrorMsg(playerid, "Na izabranom slotu nema oruzja.");

    if (ammo <= 0)
        return ErrorMsg(playerid, "Oruzje na izabranom slotu je bez municije.");

    if (weaponid != WEAPON_DEAGLE && weaponid != WEAPON_MP5 && weaponid != WEAPON_M4 && weaponid != WEAPON_AK47 && weaponid != WEAPON_SNIPER)
    	return ErrorMsg(playerid, "Ne mozete ostaviti to oruzje u gepek.");

    GetWeaponName(weaponid, weapon, sizeof(weapon));
    oruzje_slot[playerid] = slot;
    format(sTitle, sizeof(sTitle), "{FF9900}%s - STAVI U GEPEK", propname(vrsta, PROPNAME_CAPITAL));
    format(string_256, 160, "{FFFFFF}Oruzje: {FF9900}%s\n{FFFFFF}Municija: {FF9900}%d\n\n{FFFFFF}Upisite kolicinu municije koju zelite da stavite:", weapon, ammo);
    SPD(playerid, "v_gepek_stavi_potvrda", DIALOG_STYLE_INPUT, sTitle, string_256, "Stavi", "Nazad");

    return 1;
}

Dialog:v_gepek_stavi_potvrda(playerid, response, listitem, const inputtext[]) {
    if (!response)
        return dialog_respond:v_gepek(playerid, 1, 1, "");

    new input;
    if (sscanf(inputtext, "i", input) || input < 1 || input > 1000) {
        ErrorMsg(playerid, "Unesite brojnu vrednost izmedju 1 i 1000.");
        return DialogReopen(playerid);
    }

    new
        slot    = oruzje_slot[playerid],
        id      = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta   = OwnedVehicle[id][V_TYPE],
        weaponid,
        weapon[22],
        ammo;

    if (slot < 0 || slot > 12)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (slot je izvan opsega)");

    weaponid= GetPlayerWeaponInSlot(playerid, slot);
    ammo    = GetPlayerAmmoInSlot(playerid, slot);

    if (weaponid <= 0 || weaponid > 46)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nepoznato oruzje)");

    if (ammo < 1 || ammo > 50000)
        return ErrorMsg(playerid, GRESKA_NEPOZNATO" (nevazeca kolicina municije)");

    if (input > ammo) {
        ErrorMsg(playerid, "Nemate toliko municije za ovo oruzje kod sebe.");
        return DialogReopen(playerid);
    }


    // Update podataka u bazi
    if (VehicleWeapons[id][slot][V_WEAPON_ID] == -1) 
    {
        // Ovaj slot nije bio zauzet u gepeku --> insert

        VehicleWeapons[id][slot][V_WEAPON_ID] = weaponid;
        VehicleWeapons[id][slot][V_AMMO]   = input;

        new sQuery[55];
        format(sQuery, sizeof sQuery, "INSERT INTO vozila_oruzje VALUES (%d, %d, %d, %d)", id, slot, weaponid, input);
        mysql_tquery(SQL, sQuery);
    }
    else 
    {
        // Slot je bio zauzet (istim ili drugim oruzjem)

        if ((VehicleWeapons[id][slot][V_AMMO] + input) > 1000)
        {
            ErrorMsg(playerid, "Mozete ubaciti najvise 1000 metaka u vozilo. Vec ih imate %d za ovaj slot.", VehicleWeapons[id][slot][V_AMMO]);
            return DialogReopen(playerid);
        }

        VehicleWeapons[id][slot][V_WEAPON_ID] = weaponid;
        VehicleWeapons[id][slot][V_AMMO]  += input;

        new sQuery[84];
        format(sQuery, sizeof sQuery, "UPDATE vozila_oruzje SET weapon = %d, ammo = %d WHERE v_id = %d AND slot = %d", weaponid, VehicleWeapons[id][slot][V_AMMO], id, slot);
        mysql_tquery(SQL, sQuery);
    }

    SetPlayerAmmo(playerid, weaponid, ammo-input);

    GetWeaponName(weaponid, weapon, sizeof(weapon));

    // Slanje poruka igracu
    SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Stavili ste {FFFF00}%s {FFFFFF}i {FFFF00}%d metaka {FFFFFF}u gepek.", propname(vrsta, PROPNAME_CAPITAL), weapon, input);
    SendClientMessageF(playerid, BELA, "* U gepeku sada imate {FFFF00}%d metaka {FFFFFF}za ovo oruzje.", VehicleWeapons[id][slot][V_AMMO]);

    // Upisivanje u log
    format(string_128, sizeof string_128, "STAVLJANJE | %s | %s | Stavio %d od %d metaka", ime_obicno[playerid], weapon, input, ammo);
    Log_Write(LOG_VEHICLES_WEAPONS, string_128);

    return dialog_respond:v_gepek(playerid, 1, 1, "");
}

Dialog:v_prodaja(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
	
	new
        slot = vozila_uredjuje_slot[playerid],
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = OwnedVehicle[id][V_TYPE]
	;
    
	switch (listitem) {
		case 0: // Stavi na prodaju
        {
	        format(string_32, 32, "{FFFF00}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
			
			format(string_256, sizeof string_256, "{FFFFFF}Vrsta vozila: {FFFF00}%s\n{FFFFFF}Model: {FFFF00}%s\n{FFFFFF}Vrednost: {FFFF00}%s\n \n{FFFFFF}Unesite cenu za koju zelite da prodate ovo vozilo:\n({FF0000}0{FFFF00} = ponistavanje prodaje)", propname(vrsta, PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(OwnedVehicle[id][V_PRICE]));
			SPD(playerid, "v_prodaja_autopijaca", DIALOG_STYLE_INPUT, string_32, string_256, "Postavi", "Nazad");
		}
		
		case 1: // Prodaj auto-salonu
        {
			// TODO: napraviti proveru za koordinate
			
	        format(string_32, 32, "{FFFF00}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
			format(string_256, 200, "{FFFFFF}Vrsta vozila: {FFFF00}%s\n{FFFFFF}Model: {FFFF00}%s\n{FFFFFF}Vrednost: {FFFF00}%s\n\nDa li zaista zelite da prodate ovo vozilo za {FFFF00}%s?", propname(vrsta, PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(OwnedVehicle[id][V_PRICE]), formatMoneyString((OwnedVehicle[id][V_PRICE]/3)*2));
			SPD(playerid, "v_prodaj_salonu", DIALOG_STYLE_MSGBOX, string_32, string_256, "Da", "Ne");
		}

        case 2: // Prodaj igracu
        {
            if (PI[playerid][p_nivo] < 10)
                return ErrorMsg(playerid, "Morate biti najmanje nivo 10 da biste mogli da prodajete imovinu drugim igracima.");
    
            if (OwnedVehicle[id][V_SELLING_PRICE] != 0)
                return ErrorMsg(playerid, "Najpre uklonite vozilo sa auto pijace.");
                
            format(string_32, 32, "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
            format(string_256, 200, "{FFFFFF}Vrsta vozila: {FFFF00}%s\n{FFFFFF}Model: {FFFF00}%s\n\n{FFFFFF}Upisite ime ili ID igraca kome zelite da prodate ovo vozilo:", propname(vrsta, PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400]);
            SPD(playerid, "v_prodaja_igracu_1", DIALOG_STYLE_INPUT, string_32, string_256, "Dalje »", "« Nazad");
        }
		
		case 3: // Zameni sa igracem	
        {
            if (PI[playerid][p_nivo] < 10)
                return ErrorMsg(playerid, "Morate biti najmanje nivo 10 da biste mogli da menjate imovinu sa drugim igracima.");
                
            if (exchange_active(playerid))
                return ErrorMsg(playerid, "Vec imate aktivnu zamenu sa nekim igracem.");

            exchange_reset(playerid);
            exchange_set_menja_id(playerid, id);
            exchange_set_menja_slot(playerid, slot);
                

            format(string_32, 32, "{0068B3}%s - ZAMENA [1/5]", propname(vrsta, PROPNAME_UPPER));
            SPD(playerid, "imovina_zamena_1", DIALOG_STYLE_INPUT, string_32, "{FFFFFF}Upisite ime ili ID igraca sa kojim zelite da zamenite imovinu:", "Dalje >", "< Nazad");
		}
	}
	
	return 1;
}

Dialog:v_prodaja_autopijaca(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
	
	new
		id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
		cena
	;
	
	if (sscanf(inputtext, "i", cena))
		return DialogReopen(playerid);
	
	if (cena < 0 || cena > 99999999)
		return DialogReopen(playerid);
	
	if (!IsPlayerInArea(playerid, 1530.92, -1100.53, 1820.35, -995.27) && !IsPlayerInArea(playerid, 1591.7, -1143.8, 1684.72, -1090.67)) // ako se nesto menja - promeniti i u komandi /kupi
		return ErrorMsg(playerid, "Niste na auto pijaci.");
	
	if (cena == 0) 
    {
		// Uklanja ga sa prodaje
		if (OwnedVehicle[id][V_SELLING_PRICE] == 0) 
        {
			ErrorMsg(playerid, "Vase vozilo nije na prodaju.");
			return DialogReopen(playerid);
		}
		
		OwnedVehicle[id][V_SELLING_PRICE] = 0;
		
        Vehicle_SetNeonLights(id, false);
        OwnedVehicle_RemoveSpecTuning(id);
		DestroyVehicle(OwnedVehicle[id][V_ID]);
		OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_POS][0], OwnedVehicle[id][V_POS][1], OwnedVehicle[id][V_POS][2]+0.3, OwnedVehicle[id][V_POS][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
        // Vehicle_SetNeonLights(id, true, -1);
		LinkVehicleToInterior(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_ENT]);
		SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_VW]);
		SetVehicleHealth(OwnedVehicle[id][V_ID], (OwnedVehicle[id][V_HEALTH]<250.0?250.1:OwnedVehicle[id][V_HEALTH]));
		UpdateVehicleDamageStatus(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES]);
		
		// SetVehicleHealth_H: ternary operator sluzi da spreci da se vozilo spawnuje zapaljeno
			
		SetVehicleFuel(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_FUEL]);
		if (OwnedVehicle[id][V_TYPE] == automobil)  SetVehicleTankVolume(OwnedVehicle[id][V_ID], 55.0);
		else if (OwnedVehicle[id][V_TYPE] == motor) SetVehicleTankVolume(OwnedVehicle[id][V_ID], 20.0);
		else SetVehicleTankVolume(OwnedVehicle[id][V_ID], 100.0);
		
		if (OwnedVehicle[id][V_TYPE] == automobil || OwnedVehicle[id][V_TYPE] == motor)
			SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
		
		SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Uklonili ste %s sa prodaje. Mozete ga naci na mestu gde je ranije bio parkiran.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER));
		
		DestroyDynamic3DTextLabel(v_prodaja_tekst[id]);
		v_prodaja_tekst[id] = Text3D:INVALID_3DTEXT_ID;
		
		Iter_Add(auto_pijaca, OwnedVehicle[id][V_CAR_MARKET]);
	}
	else 
	{
		// Postavlja na prodaju ili azurira cenu
		
		if (GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID] && OwnedVehicle[id][V_SELLING_PRICE] == 0)
			return ErrorMsg(playerid, "Ne nalazite se u svom vozilu."); // Mora da bude u svom vozilu ako ga tek stavlja na prodaju
	
		new status[34], sLabel[256];
		if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) status = "{FF0000}nije registrovan";
		else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) status = "{FF9900}registracija istekla";
		else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
			format(status, sizeof(status), "registrovan do {00FF00}%s", OwnedVehicle[id][V_REG_EXPIRY]);
		
		format(sLabel, sizeof sLabel, "{FFFF00}%s na prodaju\n{FFFFFF}Cena: {FFFF00}%s\n{FFFFFF}Presao: {FFFF00}%.1f km\n{FFFFFF}Status: %s\n{FFFFFF}Alarm: {FFFF00}%i posto\n\n{FFFFFF}Da kupite ovaj %s upisite {FFFF00}/kupi %d", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(cena), OwnedVehicle[id][V_MILEAGE], status, OwnedVehicle[id][V_SECURITY], propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), id);
		
		if (OwnedVehicle[id][V_SELLING_PRICE] != 0) 
		{
			// Azurira cenu, vec je stavljen na prodaju ranije ---> samo update label-a
			UpdateDynamic3DTextLabelText(v_prodaja_tekst[id], BELA, sLabel);
			
			SendClientMessageF(playerid, ZUTA, "(%s) Promenili ste cenu za svoj %s. Nova cena: {FFFF00}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(cena));
			SendClientMessage(playerid, BELA, "* Necete moci da koristite ovo vozilo dok stoji na auto pijaci.");
		}
		else 
        {
			// Tek postavlja na prodaju
		
			if (!gCarMarket_Ticket{playerid})
				return ErrorMsg(playerid, "Niste platili ulaz na auto pijacu.");
			
			foreach (new i : auto_pijaca) 
			{
                Vehicle_SetNeonLights(id, false);
                OwnedVehicle_RemoveSpecTuning(id);
				DestroyVehicle(OwnedVehicle[id][V_ID]);
				OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], gCarMarket_Parcels[i][0], gCarMarket_Parcels[i][1], gCarMarket_Parcels[i][2], gCarMarket_Parcels[i][3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);

                // Vehicle_SetNeonLights(id, true, -1);
		
				if (OwnedVehicle[id][V_TYPE] == automobil || OwnedVehicle[id][V_TYPE] == motor)
					SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
				
				OwnedVehicle[id][V_CAR_MARKET] = i;
				
				v_prodaja_tekst[id] = CreateDynamic3DTextLabel(sLabel, BELA, gCarMarket_Parcels[i][0], gCarMarket_Parcels[i][1], gCarMarket_Parcels[i][2]+1.5, 15.0, INVALID_PLAYER_ID, OwnedVehicle[id][V_ID]);
				
				Iter_Remove(auto_pijaca, i);
			
				SendClientMessageF(playerid, ZUTA, "(%s) Postavili ste svoj %s na prodaju po ceni od {FFFF00}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(cena));
				SendClientMessage(playerid, BELA, "* Necete moci da koristite ovo vozilo dok stoji na auto pijaci.");
				break;
			}
		}
		
		OwnedVehicle[id][V_SELLING_PRICE] = cena;
	}
		
	// Update unosa u bazi
    new sQuery[256];
	format(sQuery, sizeof sQuery, "UPDATE vozila SET prodaja_cena = %d WHERE id = %d", cena, id);
	mysql_pquery(SQL, sQuery);
	
	
	return 1;
}

Dialog:v_prodaj_salonu(playerid, response, listitem, const inputtext[]) 
{
	if (!response)
		return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
	
	new
		slot = vozila_uredjuje_slot[playerid],
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
		vrsta = GetPVarInt(playerid, "pEditingVehType")
	;
	
	if (id == 0 || (slot < 0 || slot >= PI[playerid][p_vozila_slotovi]))
		return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (01)");
	
	if (OwnedVehicle[id][V_SELLING_PRICE] != 0)
		return ErrorMsg(playerid, "Najpre uklonite vozilo sa auto pijace.");
	
	if (v_prodaja_tekst[id] != Text3D:INVALID_3DTEXT_ID)
	{
		DestroyDynamic3DTextLabel(v_prodaja_tekst[id]);
		v_prodaja_tekst[id] = Text3D:INVALID_3DTEXT_ID;
	}
	
	new cena = (OwnedVehicle[id][V_PRICE]/3)*2;
    Vehicle_SetNeonLights(id, false);
    OwnedVehicle_RemoveSpecTuning(id);
	DestroyVehicle(OwnedVehicle[id][V_ID]);
	OwnedVehicle[id][V_ID] = INVALID_VEHICLE_ID;
	pVehicles[playerid][slot] = 0;
	PlayerMoneyAdd(playerid, cena);
	format(string_64, 64, "~g~Prodaja vozila~n~~w~Prodali ste svoj %s za ~r~%s", propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena));
	GameTextForPlayer(playerid, string_64, 5000, 3);

	format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET novac = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_id]);
	mysql_pquery(SQL, mysql_upit);
	
	format(mysql_upit, 37, "DELETE FROM vozila WHERE id = %d", id);
	mysql_pquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    format(mysql_upit, 52, "DELETE FROM vozila_offline_info WHERE vid = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    // Brisanje oruzja iz baze
    format(mysql_upit, 46, "DELETE FROM vozila_oruzje WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

    // Brisanje komponenti iz baze
    format(mysql_upit, 50, "DELETE FROM vozila_komponente WHERE v_id = %d", id);
    mysql_tquery(SQL, mysql_upit); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEDELETE);

	format(string_128, sizeof string_128, "%s - PRODAJA (salon) | %s | Model: %s | Cena: $%d | ID: %d", propname(vrsta, PROPNAME_UPPER), ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_PRICE], id);
	Log_Write(LOG_IMOVINA, string_128);
	
	// Resetovanje (nekih) promenljivih
	OwnedVehicle[id][V_OWNER_ID] = -1;
	OwnedVehicle[id][V_SELLING_PRICE] = 0;

    // Resetovanje komponenti
    for__loop (new i = 0; i < 2; i++)
    {
        if (IsValidDynamicObject(OwnedVehicle[id][V_NEON_LIGHT_OBJ][i]))
        {
            DestroyDynamicObject(OwnedVehicle[id][V_NEON_LIGHT_OBJ][i]);
        	OwnedVehicle[id][V_NEON_LIGHT_OBJ][i] = -1;
        }
    }
    for__loop (new i = 0; i < 12; i++) 
        VehicleComponents[id][i][V_COMPONENT_ID] = VehicleComponents[id][i][V_PART_ID] = -1;

    // Resetovanje oruzja
    OwnedVehicle_ResetWeapons(id);
	
	return 1;
}

Dialog:v_autopijaca_potvrda(playerid, response, listitem, const inputtext[]) {
	if (!response) return 1;
	
	new 
		id = auto_pijaca_kupuje[playerid],
		prodavac = -1,
		Float:poz[3],
		slot = -1
	;
	
	if (id < 1 || id > MAX_VOZILA_DB)
		return ErrorMsg(playerid, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (02)");
	
	if (OwnedVehicle[id][V_ID] == INVALID_VEHICLE_ID)
		return ErrorMsg(playerid, "To vozilo ne postoji.");
	
	if (OwnedVehicle[id][V_SELLING_PRICE] == 0)
		return ErrorMsg(playerid, "To vozilo se ne prodaje ili ga je neko drugi vec kupio.");
	
	GetVehiclePos(OwnedVehicle[id][V_ID], poz[POS_X], poz[POS_Y], poz[POS_Z]);
	
	if (!IsPlayerInRangeOfPoint(playerid, 10.0, poz[POS_X], poz[POS_Y], poz[POS_Z]))
		return ErrorMsg(playerid, "Ne nalazite se blizu tog vozila.");
	
	if (OwnedVehicle[id][V_SELLING_PRICE] != auto_pijaca_kupuje_cena[playerid])
		return ErrorMsg(playerid, "Prodavac je u medjuvremenu promenio cenu vozila.");
	
	if (OwnedVehicle[id][V_OWNER_ID] != auto_pijaca_kupuje_vlasnik[playerid])
		return ErrorMsg(playerid, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (03)");
	
	if (PI[playerid][p_banka] < OwnedVehicle[id][V_SELLING_PRICE])
		return ErrorMsg(playerid, "Nemate dovoljno novca na svom bankovnom racunu.");
	
	// Trazimo prvi slobodan slot u koji ce se smestiti kupljeno vozilo
	for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) {
		if (pVehicles[playerid][i] == 0) {
			slot = i;
			break;
		}
	}
	if (slot == -1)
		return ErrorMsg(playerid, "Nemate slobodne slotove za nova vozila.");
	
	
	// Proveravamo da li je vlasnik auta trenutno na serveru
	foreach(new i : Player) 
	{
		if (PI[i][p_id] == OwnedVehicle[id][V_OWNER_ID]) 
		{
			prodavac = i;
			break;
		}
	}
	if (!IsPlayerConnected(prodavac)) 
	{
		// Vlasnik vozila nije prisutan
        new query1[70];
		format(query1, sizeof query1, "UPDATE igraci SET banka = banka + %d WHERE id = %d", OwnedVehicle[id][V_SELLING_PRICE], OwnedVehicle[id][V_OWNER_ID]);
		mysql_tquery(SQL, query1);
		
        new query2[128];
		format(query2, sizeof query2, "INSERT INTO vozila_offline_info VALUES (%d, %d, %d, %d, %d)", OwnedVehicle[id][V_OWNER_ID], id, OwnedVehicle[id][V_MODEL], OwnedVehicle[id][V_SELLING_PRICE], OwnedVehicle[id][V_TYPE]);
		mysql_tquery(SQL, query2); // uklonjen noreturn by daddyDOT ->, THREAD_VEHICLEOFFLINE);
	}
	else 
	{
		// Vlasnik vozila je prisutan na serveru
		BankMoneyAdd(prodavac, OwnedVehicle[id][V_SELLING_PRICE]);
		
		// Oslobodi mu slot za vozila
		for__loop (new i = 0; i < PI[prodavac][p_vozila_slotovi]; i++) 
		{
			if (pVehicles[prodavac][i] == id) 
				pVehicles[prodavac][i] = 0;
		}
		
        new query[60];
		format(query, sizeof query, "UPDATE igraci SET banka = %d WHERE id = %d", PI[prodavac][p_banka], PI[prodavac][p_id]);
		mysql_tquery(SQL, query);
			
		SendClientMessageF(prodavac, SVETLOPLAVA, "* Vas %s %s je uspesno prodat za {FFFFFF}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(OwnedVehicle[id][V_SELLING_PRICE]));
	}
	
	BankMoneySub(playerid, OwnedVehicle[id][V_SELLING_PRICE]);
	pVehicles[playerid][slot] = id;
	
	// Unistavanje 3D text-a
	DestroyDynamic3DTextLabel(v_prodaja_tekst[id]);
	v_prodaja_tekst[id] = Text3D:INVALID_3DTEXT_ID;
	
	
	// Azuriranje igracevih podataka
    new query[60];
	format(query, sizeof query, "UPDATE igraci SET banka = %d WHERE id = %d", PI[playerid][p_banka], PI[playerid][p_id]);
	mysql_tquery(SQL, query);
	
	// Azuriranje podataka o vozilu
	format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET vlasnik = %d, vlasnik_ime = '%s', prodaja_cena = 0 WHERE id = %d", PI[playerid][p_id], ime_obicno[playerid], id);
	mysql_tquery(SQL, mysql_upit);
	
	// Slanje poruke kupcu
	SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste kupili %s %s za {FFFFFF}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(OwnedVehicle[id][V_SELLING_PRICE]));
	SendClientMessage(playerid, BELA, "Koristite {FFFF00}/imovina -> vozila {FFFFFF}za upravljanje ovim vozilom.");
	SendClientMessage(playerid, SVETLOCRVENA, "U obavezi ste da u najkracem roku {FF0000}preparkirate {FF6347}svoje novo vozilo.");
	
	// Logovanje
	format(string_256, sizeof string_256, "%s - PRODAJA (autopijaca) | %s -> %s | Model: %s | Cena: $%d | ID: %d", propname(OwnedVehicle[id][V_TYPE], PROPNAME_UPPER), OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_SELLING_PRICE], id);
	Log_Write(LOG_IMOVINA, string_256);
	
	// Promena podataka vozila
	OwnedVehicle[id][V_OWNER_ID] = PI[playerid][p_id];
	OwnedVehicle[id][V_SELLING_PRICE] = 0;
	strmid(OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);
	SetVehicleToRespawn(OwnedVehicle[id][V_ID]);
	
	return 1;
}

Dialog:v_prodaja_igracu_1(playerid, response, listitem, const inputtext[]) // Prodaja igracu: ID
{
    if (!response)
        return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
    
    new
        slot = vozila_uredjuje_slot[playerid],
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = GetPVarInt(playerid, "pEditingVehType"),
        sTitle[32],
        targetid
    ;
    
    if (id == 0 || (slot < 0 || slot >= PI[playerid][p_vozila_slotovi]))
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (01)");

    if (sscanf(inputtext, "u", targetid))
        return DialogReopen(playerid);



    if (!IsPlayerConnected(targetid)) 
    {
        ErrorMsg(playerid, GRESKA_OFFLINE);
        return DialogReopen(playerid);
    }

    if (targetid == playerid)
        return DialogReopen(playerid);

    if (!IsPlayerNearPlayer(playerid, targetid, 5.0))
    {
        ErrorMsg(playerid, "Taj igrac se ne nalazi u Vasoj blizini.");
        return DialogReopen(playerid);
    }

    if (PI[targetid][p_nivo] < 3)
        return ErrorMsg(playerid, "Taj igrac mora biti barem nivo 3.");

    new minSec = 50 * 3600;
    if (PI[targetid][p_provedeno_vreme] < minSec)
        return ErrorMsg(playerid, "Taj igrac mora imati najmanje 50 sati igre. Trenutno ima %i sati igre.", floatround(PI[targetid][p_provedeno_vreme]/3600.0));


    // Trazenje slobodnog slota kod kupca
    new buyerSlot = -1;
    for__loop (new i = PI[targetid][p_vozila_slotovi]-1; i >= 0 ; i--) {
        if (pVehicles[targetid][i] == 0) 
            buyerSlot = i;
    }
    if (buyerSlot == -1)
        return ErrorMsg(playerid, "Taj igrac nema slobodan slot za novo vozilo.");

    // ---------- //

    SetPVarInt(playerid, "vehProdaja_BuyerID", targetid);

    format(sTitle, sizeof sTitle, "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
    SPD(playerid, "v_prodaja_igracu_2", DIALOG_STYLE_INPUT, sTitle, "{FFFFFF}Upisite iznos koji zelite da Vam ovaj igrac plati:", "Dalje »", "« Nazad");

    return 1;
}

Dialog:v_prodaja_igracu_2(playerid, response, listitem, const inputtext[]) // Prodaja igracu: cena
{
    if (!response)
        return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");
    
    new
        slot = vozila_uredjuje_slot[playerid],
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = GetPVarInt(playerid, "pEditingVehType"),
        sTitle[32],
        cena,
        targetid = GetPVarInt(playerid, "vehProdaja_BuyerID")
    ;
    
    if (id == 0 || (slot < 0 || slot >= PI[playerid][p_vozila_slotovi]))
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (01)");

    if (sscanf(inputtext, "i", cena) || cena < 1 || cena > 99999999)
        return DialogReopen(playerid);

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(targetid, playerid, 5.0))
        return ErrorMsg(playerid, "Ovaj igrac vise nije u Vasoj blizini.");

    SetPVarInt(playerid, "vehProdaja_Price", cena);

    format(sTitle, sizeof sTitle, "{0068B3}%s - PRODAJA", propname(vrsta, PROPNAME_UPPER));
    format(string_256, sizeof string_256, "{0068B3}Vozilo: {FFFFFF}%s\n{0068B3}Igrac: {FFFFFF}%s\n{0068B3}Cena: {FFFFFF}%s\n\nDa li zaista zelite da prodate svoje vozilo\novom igracu i za ovu cenu?", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], ime_rp[targetid], formatMoneyString(cena));

    SPD(playerid, "v_prodaja_igracu_3", DIALOG_STYLE_MSGBOX, sTitle, string_256, "Da", "Ne");
    return 1;
}

Dialog:v_prodaja_igracu_3(playerid, response, listitem, const inputtext[]) // Prodaja igracu: ponuda
{
    if (!response)
        return dialog_respond:vozila(playerid, 1, vozila_uredjuje_item[playerid], "");

    new
        slot = vozila_uredjuje_slot[playerid],
        id = pVehicles[playerid][vozila_uredjuje_slot[playerid]],
        vrsta = GetPVarInt(playerid, "pEditingVehType"),
        sTitle[40],
        cena = GetPVarInt(playerid, "vehProdaja_Price"),
        targetid = GetPVarInt(playerid, "vehProdaja_BuyerID")
    ;

    if (!IsPlayerConnected(targetid))
        return ErrorMsg(playerid, GRESKA_OFFLINE);

    if (!IsPlayerNearPlayer(targetid, playerid, 5.0))
        return ErrorMsg(playerid, "Ovaj igrac vise nije u Vasoj blizini.");


    SetPVarInt(targetid, "vehKupovina_SellerID", playerid);
    SetPVarInt(targetid, "vehKupovina_Price", cena);
    SetPVarInt(targetid, "vehKupovina_VehID", id);
    SetPVarInt(targetid, "vehKupovina_Model", OwnedVehicle[id][V_MODEL]);

    SetPVarInt(playerid, "vehProdaja_VehID", id);
    SetPVarInt(playerid, "vehProdaja_Slot", slot);

    format(sTitle, sizeof sTitle, "{0068B3}%s - KUPOPRODAJA", propname(vrsta, PROPNAME_UPPER));
    format(string_256, 200, "{FFFFFF}Igrac {0068B3}%s {FFFFFF}zeli da Vam proda %s: {0068B3}%s.\n\n{0068B3}Cena: {FFFFFF}%s", ime_rp[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena));

    SPD(targetid, "v_prodaja_igracu_4", DIALOG_STYLE_MSGBOX, sTitle, string_256, "Prihvati", "Odbaci");

    SendClientMessage(playerid, SVETLOPLAVA, "* Ponuda je poslata.");

    return 1;
}

Dialog:v_prodaja_igracu_4(playerid, response, listitem, const inputtext[]) // Prodaja igracu: dialog prihvati/odbij
{
    if (!response)
        return SendClientMessage(GetPVarInt(playerid, "vehKupovina_SellerID"), SVETLOCRVENA, "* Igrac je odbio kupovinu vozila.");

    new sellerid = GetPVarInt(playerid, "vehKupovina_SellerID"),
        price = GetPVarInt(playerid, "vehKupovina_Price"),
        id = GetPVarInt(playerid, "vehKupovina_VehID");

    if (!IsPlayerConnected(sellerid)) // Prodavac offline
        return SendClientMessage(playerid, SVETLOCRVENA, "* Igrac koji Vam je ponudio prodaju je napustio server.");

    // Provera da li se parametri poklapaju kod prodavca i kupca
    if (GetPVarInt(sellerid, "vehProdaja_Buyerid") != playerid)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (04)");

    if (GetPVarInt(sellerid, "vehProdaja_Price") != price)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (05)");

    if (GetPVarInt(sellerid, "vehProdaja_VehID") != id)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (06)");

    if (pVehicles[sellerid][GetPVarInt(sellerid, "vehProdaja_Slot")] != id)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (07)");

    if (OwnedVehicle[id][V_MODEL] != GetPVarInt(playerid, "vehKupovina_Model"))
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (08)");

    if (price < 1 || price > 99999999)
        return SendClientMessage(playerid, TAMNOCRVENA2, "[vehicles/ownership.pwn] "GRESKA_NEPOZNATO" (09)");

    if (PI[playerid][p_novac] < price)
        return ErrorMsg(playerid, "Nemate dovoljno novca.");

    // Provera slobodnih slotova
    new slot = -1;
    for__loop (new i = PI[playerid][p_vozila_slotovi]-1; i >= 0 ; i--) {
        if (pVehicles[playerid][i] == 0) 
            slot = i;
    }
    if (slot == -1)
        return ErrorMsg(playerid, "Nemate nijedan slobodan slot za novo vozilo.");

    PlayerMoneySub(playerid, price);
    PlayerMoneyAdd(sellerid, price);
    pVehicles[playerid][slot] = pVehicles[sellerid][GetPVarInt(sellerid, "vehProdaja_Slot")];
    pVehicles[sellerid][GetPVarInt(sellerid, "vehProdaja_Slot")] = 0;
    
    // Azuriranje podataka o vozilu
    format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET vlasnik = %d, vlasnik_ime = '%s' WHERE id = %d", PI[playerid][p_id], ime_obicno[playerid], id);
    mysql_tquery(SQL, mysql_upit);
    
    // Slanje poruka
    SendClientMessageF(sellerid, SVETLOPLAVA, "* Uspesno ste prodali %s %s za {FFFFFF}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(price));
    SendClientMessageF(playerid, SVETLOPLAVA, "* Uspesno ste kupili %s %s za {FFFFFF}%s.", propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(price));
    SendClientMessage(playerid, BELA, "Koristite {FFFF00}/imovina -> vozila {FFFFFF}za upravljanje ovim vozilom.");

    
    // Logovanje
    format(string_128, sizeof string_128, "%s - PRODAJA (igracu) | %s -> %s | Model: %s | Cena: $%d | ID: %d", propname(OwnedVehicle[id][V_TYPE], PROPNAME_UPPER), OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], imena_vozila[OwnedVehicle[id][V_MODEL] - 400], OwnedVehicle[id][V_SELLING_PRICE], id);
    Log_Write(LOG_IMOVINA, string_128);
    
    // Promena podataka vozila
    OwnedVehicle[id][V_OWNER_ID] = PI[playerid][p_id];
    strmid(OwnedVehicle[id][V_OWNER_NAME], ime_obicno[playerid], 0, strlen(ime_obicno[playerid]), MAX_PLAYER_NAME);

    return 1;
}

Dialog:buy_veh_alarm(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		new slot = OwnedVehiclesDialog_GetItem(playerid, listitem),
			id = pVehicles[playerid][slot],
			price = GetPVarInt(playerid, "pVehicleAlarmPrice"),
			security = GetPVarInt(playerid, "pVehicleAlarmSecurity"),
			gid = GetPVarInt(playerid, "pVehicleAlarmBizGID")
		;
		DeletePVar(playerid, "pVehicleAlarmSecurity");
		DeletePVar(playerid, "pVehicleAlarmPrice");
		DeletePVar(playerid, "pVehicleAlarmBizGID");

		if (OwnedVehicle[id][V_REG_STATUS] == REG_NE)
			return ErrorMsg(playerid, "Vozilo mora biti registrovano da biste mogli da ugradite alarm.");

		OwnedVehicle[id][V_SECURITY] = security;

		if (price > 0)
		{
			PlayerMoneySub(playerid, price);
			re_firma_dodaj_novac(gid, floatround(price/100.0)*8);
		}

		InfoMsg(playerid, "Alarm je ugradjen u vozilo: {FFFFFF}%s (ID: %i)", imena_vozila[OwnedVehicle[id][V_MODEL] - 400], id);

		new sQuery[50];
		format(sQuery, sizeof sQuery, "UPDATE vozila SET security = %i WHERE id = %i", OwnedVehicle[id][V_SECURITY], id);
		mysql_tquery(SQL, sQuery);

		new sLog[60];
		format(sLog, sizeof sLog, "%s | %i posto | Vozilo: %i", ime_obicno[playerid], OwnedVehicle[id][V_SECURITY], id);
		Log_Write(LOG_VEHALARM, sLog);
	}
	return 1;
}

Dialog:v_registracija(playerid, response, listitem, const inputtext[]) 
{
	if (!response) return 1;
	
	new
		string[700],
		sTitle[39],
		slot = OwnedVehiclesDialog_GetItem(playerid, listitem),
		id = pVehicles[playerid][slot], // id u bazi, a ne id kreiranog vozila
		vrsta = OwnedVehicle[id][V_TYPE],
		cena_reg = OwnedVehicle[id][V_PRICE] / 10,
		cena_ukupno
	;
	vozila_uredjuje_slot[playerid] = slot;
	
	format(sTitle, sizeof(sTitle), "{FFFF00}REGISTRACIJA (SLOT %d)", slot+1);
	
	if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) 
	{
		// Vozilo nikad nije bilo registrovano, mora da plati i tablice
		cena_ukupno = cena_reg + TABLICE_CENA;
		
		format(string, sizeof string, "{FFFFFF}Registracija vozila {FFFF00}%s\n\n{FFFFFF}Ovaj %s nikada pre nije bio registrovan, morate platiti i nove tablice.\nCena registracije: {FFFF00}%s\n{FFFFFF}Cena tablica: {FFFF00}%s\n{FFFFFF}Trajanje registracije: {FFFF00}30 dana\n\n{FFFFFF}Zelite li da registrujete ovaj %s za {FF0000}%s ?", 
		imena_vozila[OwnedVehicle[id][V_MODEL] - 400], propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena_reg), formatMoneyString(TABLICE_CENA), propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena_ukupno));
	}
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) 
	{
		// Registracija istekla
		cena_ukupno = cena_reg;
		
		format(string, sizeof string, "{FFFFFF}Registracija vozila {FFFF00}%s\n\n{FFFFFF}Cena registracije: {FFFF00}%s\n{FFFFFF}Cena tablica: {FFFF00}$--\n{FFFFFF}Trajanje registracije: {FFFF00}30 dana\n\n{FFFFFF}Zelite li da registrujete ovaj %s za {FF0000}%s ?", 
		imena_vozila[OwnedVehicle[id][V_MODEL] - 400], formatMoneyString(cena_reg), propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena_ukupno));
	}
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
	{
		// Vozilo registrovano, produzi registraciju
		cena_ukupno = cena_reg;
		
		format(string, sizeof string, "{FFFFFF}Registracija vozila {FFFF00}%s\n\n{FFFFFF}Ovaj %s je vec registrovan i ima vazece tablice.\nCena registracije: {FFFF00}%s\n{FFFFFF}Cena tablica: {FFFF00}$--\n{FFFFFF}Trajanje registracije: {FFFF00}30 dana\n\n{FFFFFF}Zelite li da produzite registraciju ovom %su za {FF0000}%s ?", 
		imena_vozila[OwnedVehicle[id][V_MODEL] - 400], propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena_reg), propname(vrsta, PROPNAME_LOWER), formatMoneyString(cena_ukupno));
	}
	else return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new vipPopust = 0;
	if (IsVIP(playerid, 4)) vipPopust = 100;
	else if (IsVIP(playerid, 3)) vipPopust = 70;
	else if (IsVIP(playerid, 2)) vipPopust = 40;
	else if (IsVIP(playerid, 1)) vipPopust = 20;

	if (vipPopust > 0)
	{
		cena_ukupno = floatround(cena_ukupno * (1 - vipPopust/100));
		format(string, sizeof string, "%s\n\n{00FF00}*** Zahvaljujuci VIP statusu, ostvarujete popust od {FFFF00}%i%%!\n{FFFFFF}Cena registracije sa popustom: %s", string, vipPopust, formatMoneyString(cena_ukupno));
	}
	SetPVarInt(playerid, "vRegCenaUkupno", cena_ukupno);
	
	SPD(playerid, "v_registracija_2", DIALOG_STYLE_MSGBOX, sTitle, string, "Da", "Ne");
	
	return 1;
}

Dialog:v_registracija_2(playerid, response, listitem, const inputtext[]) {
	if (!response) return 1;
	
	new
		slot = vozila_uredjuje_slot[playerid],
		id = pVehicles[playerid][slot], // id u bazi, a ne id kreiranog vozila
		vrsta = OwnedVehicle[id][V_TYPE],
		cena_ukupno = GetPVarInt(playerid, "vRegCenaUkupno")
	;
	
	if (PI[playerid][p_novac] < cena_ukupno)
		return ErrorMsg(playerid, "Nemate dovoljno novca za registraciju.");
	
	if (OwnedVehicle[id][V_OWNER_ID] != PI[playerid][p_id])
		return ErrorMsg(playerid, "Izabrano vozilo vise nije u Vasem vlasnistvu.");
	
	
	if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) 
	{
		// Vozilo nikad nije bilo registrovano, mora da plati i tablice
		
		// Generisanje registarskog broja
        new letters[3];
        RandomString(letters, sizeof letters, RANDSTR_FLAG_UPPER);
		format(string_32, 32, "LS %d-%s", 100+random(899), letters);
		strmid(OwnedVehicle[id][V_PLATE], string_32, 0, strlen(string_32), 33);
		
		// Postavljanje tablice na auto
		SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
		
		// Baza update
		format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET tablica = '%s', registracija = FROM_UNIXTIME(%d) WHERE id = %d", OwnedVehicle[id][V_PLATE], gettime()+2592000, id); // 2592000 = broj sekundi u 30 dana
		mysql_tquery(SQL, mysql_upit);
	}
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP || OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
	{
		// Registracija istekla ili produzava registraciju
		
		// Baza update
		format(mysql_upit, sizeof mysql_upit, "UPDATE vozila SET registracija = FROM_UNIXTIME(%d) WHERE id = %d", gettime()+2592000, id); // 2592000 = broj sekundi u 30 dana
		mysql_tquery(SQL, mysql_upit);
		
		// Selektovanje datuma
		format(mysql_upit, sizeof mysql_upit, "SELECT DATE_FORMAT(registracija, '\%%d \%%b') as reg FROM vozila WHERE id = %d", id);
		mysql_tquery(SQL, mysql_upit, "mysql_v_reg_datum", "iii", id, playerid, cinc[playerid]);
	}
	else return ErrorMsg(playerid, GRESKA_NEPOZNATO);
	
	PlayerMoneySub(playerid, cena_ukupno);
	OwnedVehicle[id][V_REG_STATUS] = REG_DA;
		
	// Poruke za igraca
	SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Registracija je uspesna. Vasa registarska oznaka je: {FFFF00}%s", propname(vrsta, PROPNAME_LOWER), OwnedVehicle[id][V_PLATE]);
	SendClientMessage(playerid, BELA, "* Registracija je vazeca narednih {FFFF00}30 dana.");
	
	return 1;
}

Dialog:vopcije(playerid, response, listitem, const inputtext[]) 
{
    if (!response) return 1;

    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Morate biti u vozilu da biste koristili ovu naredbu.");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
        return ErrorMsg(playerid, "Samo vozac moze da koristi ovu naredbu.");

    new v = GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, boot, objective);

    new sMsg[57];
    switch (listitem) 
    {
        case 0: 
        {
            if (engine == VP_DA) 
            {
                SetVehicleParamsEx(v, VP_NE, lights, alarm, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** %s gasi motor vozila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~r~Motor ugasen", 2500, 3);
            }
            else 
            {
                if (GetVehicleFuel(GetPlayerVehicleID(playerid)) <= 0.0) 
                    return SendClientMessage(playerid, SVETLOCRVENA, "Nemate goriva u vozilu, ne mozete upaliti motor.");

                new Float:HP;
                GetVehicleHealth(GetPlayerVehicleID(playerid), HP);
                if (HP < 280.0) 
                    return SendClientMessage(playerid, CRVENA, "* Vase vozilo je previse osteceno, ne mozete ga voziti!"),
                
                SendClientMessage(playerid, NARANDZASTA, "Kako biste popravili ostecenje, pozovite mehanicare komandom /pozovi.");
                SetVehicleParamsEx(v, VP_DA, lights, alarm, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** %s pali motor vozila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~g~Motor upaljen", 2500, 3);
            }
        }
        case 1: 
        {
            if (lights == VP_DA) 
            {
                SetVehicleParamsEx(v, engine, VP_NE, alarm, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** %s gasi svetla na vozilu.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~r~Svetla ugasena", 2500, 3);
            }
            else 
            {
                SetVehicleParamsEx(v, engine, VP_DA, alarm, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** %s pali svetla na vozilu.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~g~Svetla upaljena", 2500, 3);
            }
        }
        case 2: 
        {
            if (alarm == VP_DA) 
            {
                SetVehicleParamsEx(v, engine, lights, VP_NE, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** Beep Beep (( %s ))", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~r~Alarm iskljucen", 2500, 3);
            }
            else 
            {
                SetVehicleParamsEx(v, engine, lights, VP_DA, doors, bonnet, boot, objective);
                format(sMsg, sizeof sMsg, "** Beep Beep (( %s ))", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~g~Alarm ukljucen", 2500, 3);
            }
        }
        case 3: 
        {
            if (bonnet == VP_DA) 
            {
                SetVehicleParamsEx(v, engine, lights, alarm, doors, VP_NE, boot, objective);
                format(sMsg, sizeof sMsg, "** %s spusta haubu automobila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~r~Hauba spustena", 2500, 3);
            }
            else 
            {
                SetVehicleParamsEx(v, engine, lights, alarm, doors, VP_DA, boot, objective);
                format(sMsg, sizeof sMsg, "** %s podize haubu automobila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~g~Hauba podignuta", 2500, 3);
            }
        }
        case 4: 
        {
            if (boot == VP_DA) 
            {
                SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, VP_NE, objective);
                format(sMsg, sizeof sMsg, "** %s spusta gepek automobila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~r~Gepek spusten", 2500, 3);
            }
            else 
            {
                SetVehicleParamsEx(v, engine, lights, alarm, doors, bonnet, VP_DA, objective);
                format(sMsg, sizeof sMsg, "** %s podize gepek automobila.", ime_rp[playerid]);
                GameTextForPlayer(playerid, "~g~Gepek podignut", 2500, 3);
            }
        }
        default: return 1;
    }
    RangeMsg(playerid, sMsg, LJUBICASTA, 20.0);

    return 1;
}

Dialog:rtcmycar(playerid, response, listitem, const inputtext[])
{
	if (response)
	{
		new slot = OwnedVehiclesDialog_GetItem(playerid, listitem),
			id = pVehicles[playerid][slot]
		;

		if (PI[playerid][p_novac] < 30000)
			return ErrorMsg(playerid, "Nemate dovoljno novca.");

		PlayerMoneySub(playerid, 30000);

		SetVehiclePos(OwnedVehicle[id][V_ID], 1486.7990,-1760.2023,13.2522);
        SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_VW]);
        LinkVehicleToInterior(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_ENT]);

        SendClientMessage(playerid, BELA, "* Respawnali ste svoje vozilo po ceni od $30.000. Pronadjite ga ispred opstine.");
	}

	return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:vozila("vozilo", "motor", "v")

CMD:autopijaca(playerid, const params[]) 
{
	if (!IsPlayerInArea(playerid, 1530.92, -1100.53, 1820.35, -995.27) && !IsPlayerInArea(playerid, 1591.7, -1143.8, 1684.72, -1090.67)) // ako se nesto menja - promeniti i u komandi /kupi
		return ErrorMsg(playerid, "Niste na auto pijaci.");
	
	if (PI[playerid][p_nivo] < 3) 
		return ErrorMsg(playerid, "Morate biti barem nivo 3 da biste kupovali na auto pijaci.");
	
	new
		id,
		Float:vpos[3]
	;
	if (sscanf(params, "i", id))
		return Koristite(playerid, "kupi [ID vozila]");
	
	if (id < 1 || id >= MAX_VOZILA_DB)
		return ErrorMsg(playerid, "Uneli ste nepostojeci ID.");
	
	if (OwnedVehicle[id][V_ID] == INVALID_VEHICLE_ID)
		return ErrorMsg(playerid, "Vozilo sa unetim ID brojem ne postoji.");

	new Float:ppos[3];
	GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
	GetVehiclePos(OwnedVehicle[id][V_ID], vpos[0], vpos[1], vpos[2]);
	printf("id: %d, %.1f, %.1f, %.1f", OwnedVehicle[id][V_ID], vpos[0], vpos[1], vpos[2]);
	printf("udaljenost: %.3f", GetDistanceBetweenPoints(vpos[0], vpos[1], vpos[2], ppos[0], ppos[1], ppos[2]));

	 
	if (!IsPlayerInRangeOfPoint(playerid, 10.0, vpos[0], vpos[1], vpos[2]))
		return ErrorMsg(playerid, "Ne nalazite se blizu tog vozila.");
	
	if (OwnedVehicle[id][V_SELLING_PRICE] == 0)
		return ErrorMsg(playerid, "Vozilo koje pokusavate da kupite nije na prodaju.");
	
	if (PI[playerid][p_id] == OwnedVehicle[id][V_OWNER_ID])
		return ErrorMsg(playerid, "Ne mozete kupiti sopstveno vozilo.");
	
	
	
	auto_pijaca_kupuje[playerid] = id;
	auto_pijaca_kupuje_cena[playerid] = OwnedVehicle[id][V_SELLING_PRICE];
	auto_pijaca_kupuje_vlasnik[playerid] = OwnedVehicle[id][V_OWNER_ID];
	
	new status[34];
	if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) status = "{FF0000}nije registrovan";
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) status = "{FF9900}registracija istekla";
	else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) 
		format(status, sizeof(status), "registrovan do {00FF00}%s", OwnedVehicle[id][V_REG_EXPIRY]);
	
	format(string_256, sizeof string_256, "{FFFFFF}Izabrali ste %s {FFFF00}%s\n{FFFFFF}Status: %s\n{FFFFFF}Registarska oznaka: {FFFF00}%s\n{FFFFFF}Kilometraza: {FFFF00}%.1f km\n\n{FFFFFF}Da li zelite da kupite ovaj %s po ceni od {FF0000}%s ?", 
	propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], status, OwnedVehicle[id][V_PLATE], OwnedVehicle[id][V_MILEAGE], propname(OwnedVehicle[id][V_TYPE], PROPNAME_LOWER), formatMoneyString(OwnedVehicle[id][V_SELLING_PRICE]));
	SPD(playerid, "v_autopijaca_potvrda", DIALOG_STYLE_MSGBOX, "{FFFF00}AUTO PIJACA", string_256, "Kupi", "Odustani");
	
	return 1;
}

CMD:registracija(playerid, const params[]) 
{
	if (!IsPlayerInRangeOfPoint(playerid, 5.0, -2590.7322,2588.1689,-97.9156))
		return ErrorMsg(playerid, "Morate ici u opstinu da biste registrovali vozilo.");
	
	new sDialog[30 + MAX_VOZILA_SLOTOVI*59];
	format(sDialog, 30, "Vozilo\tModel\tStatus");
			
	new item = 0;
	for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
	{
		if (pVehicles[playerid][i] == 0) continue; // prazan slot
		
		new 
			id = pVehicles[playerid][i],
			status[29]
		;
		if (OwnedVehicle[id][V_TYPE] != automobil && OwnedVehicle[id][V_TYPE] != motor) continue; // reg. moze samo za auta i motore
		if (OwnedVehicle[id][V_REG_STATUS] == REG_NE) status = "{FF0000}Nije registrovan";
		else if (OwnedVehicle[id][V_REG_STATUS] == REG_DA) status = "{00FF00}Registrovan";
		else if (OwnedVehicle[id][V_REG_STATUS] == REG_EXP) status = "{FF9900}Registracija istekla";
		
		format(sDialog, sizeof sDialog, "%s\n%s\t%s\t%s", sDialog, propname(OwnedVehicle[id][V_TYPE], PROPNAME_CAPITAL), imena_vozila[OwnedVehicle[id][V_MODEL] - 400], status);

		OwnedVehiclesDialog_AddItem(playerid, item++, i);
	}
	
	if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");
	
	SPD(playerid, "v_registracija", DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}REGISTRACIJA VOZILA", sDialog, "Odaberi", "Nazad");
	
	return 1;
}


CMD:vopcije(playerid, const params[]) 
{
    if (!IsPlayerInAnyVehicle(playerid)) 
        return ErrorMsg(playerid, "Morate biti u vozilu!");

    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
        return ErrorMsg(playerid, "Samo vozac moze da koristi ovu komandu!");

    SPD(playerid, "vopcije", DIALOG_STYLE_LIST, "Upravljanje vozilom:", "Motor (upali/ugasi)\nSvetla (upali/ugasi)\nAlarm (upali/ugasi)\nHauba (podigni/spusti)\nGepek (podigni/spusti)", "Odaberi", "Izadji");
    return 1;
}

flags:aveh(FLAG_ADMIN_3)
CMD:aveh(playerid, const params[]) 
{
    if (sscanf(params, "i", aveh[playerid]))
    {
    	if (aveh[playerid] == -1)
    	{
    		// Uneta je komanda bez parametara + nije u ownership vozilu
    		return Koristite(playerid, "aveh [ID vozila]");
    	}
    }
    
    SPD(playerid, "aveh", DIALOG_STYLE_LIST, "Admin: izmena vozila", "Informacije\nParkiraj\nTeleport do sebe", "Odaberi", "Nazad");
    return 1;
}

CMD:rtcmycar(playerid, const params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 4.0, -2610.3477,2584.8767,-97.9256))
		return ErrorMsg(playerid, "Morate biti u opstini da biste koristili ovu komandu.");

	new sDialog[256];
    format(sDialog, 30, "Slot\tModel");
    
    new item = 0;
    for__loop (new i = 0; i < PI[playerid][p_vozila_slotovi]; i++) 
    {
        if (pVehicles[playerid][i] == 0) continue; // prazan slot
        
        new veh = pVehicles[playerid][i];
        format(sDialog, sizeof sDialog, "%s\n%d\t%s", sDialog, i+1, imena_vozila[OwnedVehicle_GetModel(veh) - 400]);

        OwnedVehiclesDialog_AddItem(playerid, item++, i);
    }

    if (item == 0) return ErrorMsg(playerid, "Ne posedujete ni jedno vozilo.");
    
    SPD(playerid, "rtcmycar", DIALOG_STYLE_TABLIST_HEADERS, "RESPAWN VOZILA", sDialog, "Respawn", "Odustani");

    return 1;
}

CMD:vozila(playerid, const params[]) 
    return dialog_respond:imovina(playerid, 1, 0, "Vozila");

/*CMD:kvparkiraj(playerid, const params[])
{
    if (GetPlayerVehicleID(playerid) != OwnedVehicle[id][V_ID]) 
    	return ErrorMsg(playerid, "Morate biti u svom vozilu da biste ga parkirali.");
    		
    if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
    	return ErrorMsg(playerid, "Morate biti na mestu vozaca da biste parkirali ovo vozilo.");

    if (IsPlayerInArea(playerid, 1524.091, -1373.938, 1801.698, -1144.969) == 1) 
    	return ErrorMsg(playerid, "Ne mozete parkirati vozilo blizu spawna.");

    if (IsPlayerInArea(playerid, 1530.92, -1100.53, 1820.35, -995.27) || IsPlayerInArea(playerid, 1591.7, -1143.8, 1684.72, -1090.67))
    	return ErrorMsg(playerid, "Da bi vozilo bilo parkirano na auto pijaci, prvo ga morate staviti na prodaju.");

    new
    	Float:poz[5],
    	ent,
    	vw
    ;
    GetVehiclePos(OwnedVehicle[id][V_ID], poz[0], poz[1], poz[2]);
    GetVehicleZAngle(OwnedVehicle[id][V_ID], poz[3]);
    GetVehicleHealth(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_HEALTH]);
    poz[2] += 0.5;
    poz[4] = GetVehicleFuel(OwnedVehicle[id][V_ID]);
    ent    = GetPlayerInterior(playerid);
    vw     = GetPlayerVirtualWorld(playerid);

    if (OwnedVehicle[id][V_HEALTH] < 300.0 && aveh[playerid] == -1)
    {
        format(string_128, sizeof string_128, "Vas %s je previse ostecen! Da biste ga parkirali, najpre ga popravite.", propname(vrsta, PROPNAME_LOWER));
    	ErrorMsg(playerid, string_128); 
    	return 1;
    }

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(OwnedVehicle[id][V_ID], engine, lights, alarm, doors, bonnet, boot, objective);
    GetVehicleDamageStatus(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES]);
    Vehicle_SetNeonLights(id, false);
    OwnedVehicle_RemoveSpecTuning(id);
    DestroyVehicle(OwnedVehicle[id][V_ID]);
    OwnedVehicle[id][V_ID] = CreateVehicle(OwnedVehicle[id][V_MODEL], poz[0], poz[1], poz[2], poz[3], OwnedVehicle[id][V_COLOR_1], OwnedVehicle[id][V_COLOR_2], 1000);
    SetVehicleHealth(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_HEALTH]);
    SetVehicleVirtualWorld(OwnedVehicle[id][V_ID], vw);
    LinkVehicleToInterior(OwnedVehicle[id][V_ID], ent);
    // Vehicle_SetNeonLights(id, true, -1);
    SetVehicleFuel(OwnedVehicle[id][V_ID], poz[4]);
    OwnedVehicle[id][V_VW] = vw;
    OwnedVehicle[id][V_ENT] = ent;

    if (vrsta == automobil || vrsta == motor) 
    {
    	SetVehicleNumberPlate(OwnedVehicle[id][V_ID], OwnedVehicle[id][V_PLATE]);
    	SetVehicleToRespawn(OwnedVehicle[id][V_ID]);
    }
    SetVehicleParamsEx(OwnedVehicle[id][V_ID], 1, lights, alarm, doors, bonnet, boot, objective);
    PutPlayerInVehicle(playerid, OwnedVehicle[id][V_ID], 0);

    // Update u bazi
    new sQuery[259];
    format(sQuery, sizeof sQuery, "UPDATE vozila SET pozicija = '%.4f|%.4f|%.4f|%.4f', ent = %d, vw = %d, health = %.1f, gorivo = %.1f, dmg_status_panels = %d, dmg_status_doors = %d, dmg_status_lights = %d, dmg_status_tires = %d WHERE id = %d", poz[0], poz[1], poz[2], poz[3], ent, vw, OwnedVehicle[id][V_HEALTH], GetVehicleFuel(OwnedVehicle[id][V_ID]), OwnedVehicle[id][V_DMG_STATUS_PANELS], OwnedVehicle[id][V_DMG_STATUS_DOORS], OwnedVehicle[id][V_DMG_STATUS_LIGHTS], OwnedVehicle[id][V_DMG_STATUS_TIRES], id);
    mysql_tquery(SQL, sQuery);

    SendClientMessageF(playerid, ZUTA, "(%s) {FFFFFF}Uspesno ste parkirali svoj %s.", propname(vrsta, PROPNAME_LOWER), propname(vrsta, PROPNAME_LOWER));
}*/

CMD:bi(playerid, const params[]) return InfoMsg(playerid, "Koristite: /imovina -> Vozila");
CMD:pl(playerid, const params[]) return InfoMsg(playerid, "Koristite: /imovina -> Vozila");
CMD:le(playerid, const params[]) return InfoMsg(playerid, "Koristite: /imovina -> Vozila");
