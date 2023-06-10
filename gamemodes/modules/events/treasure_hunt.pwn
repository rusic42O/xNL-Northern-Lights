#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static bool:gTreasureHunt;
static gHuntStage[MAX_PLAYERS char];
static gHuntPickup[5];
static gHuntCircle[5];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	gTreasureHunt=false;
	return true;
}
hook OnPlayerConnect(playerid)
{
	gHuntStage{playerid} = 0;
	return true;
}

hook OnPlayerEnterDynArea(playerid, areaid)
{
	if (gTreasureHunt && IsPlayerLoggedIn(playerid))
	{
		if (!PI[playerid][p_treasure_hunt] && areaid == gHuntCircle[gHuntStage{playerid}])
		{
			gHuntStage{playerid} ++;
			if (gHuntStage{playerid} == 5)
			{
				PlayerMoneyAdd(playerid, 100000);
				PI[playerid][p_treasure_hunt] = 1;

				new sQuery[80];
				format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %i, treasure_hunt = 1 WHERE id = %i", PI[playerid][p_novac], PI[playerid][p_id]);
				mysql_tquery(SQL, sQuery);

				new sMsg[92];
				format(sMsg, sizeof sMsg, "TREASURE HUNT | {FF9933}%s je stigao do kraja i osvojio $100.000!", ime_rp[playerid]);
				SendClientMessageToAll(NARANDZASTA, sMsg);

				foreach (new i : Player)
				{
					if (!PI[i][p_treasure_hunt])
					{
						SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | {FFFFFF}Koristite {FF9933}/th {FFFFFF}da biste dobili uputstva za potragu.");
					}
				}

				printf("[treasure hunt] %s je stigao do kraja.", ime_obicno[playerid]);
			}
			else
			{
				SendClientMessageF(playerid, 0x00CC00FF, "TREASURE HUNT | {FFFFFF}Checkpoint %i/5", gHuntStage{playerid});
				callcmd::th(playerid, "");
			}
		}
	}
	return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:thstart(FLAG_ADMIN_6)
flags:thstop(FLAG_ADMIN_6)
CMD:thstart(playerid, const params[])
{
	if (gTreasureHunt)
		return ErrorMsg(playerid, "Treasure Hunt je vec pokrenut.");

	gTreasureHunt = true;

	SendClientMessageToAll(NARANDZASTA, "TREASURE HUNT | {FF4500}Event je pokrenut! Koristite {FF9900}/th {FF4500}za uputstva.");
	SendClientMessageToAll(NARANDZASTA, "TREASURE HUNT | {FF4500}Svi igraci koji stignu do kraja potrage dobijaju {00CC00}$100.000 !");

	// gHuntPickup[0] = CreateDynamicPickup(1276, 1, 2704.6248,-2405.3835,13.1263, 0, 0);
	// gHuntPickup[1] = CreateDynamicPickup(1276, 1, 210.4413,-7.6768,1005.2109, 0, 0);
	// gHuntPickup[2] = CreateDynamicPickup(1276, 1, -1707.8488,11.9746,3.1796, 0, 0);
	// gHuntPickup[3] = CreateDynamicPickup(1276, 1, 2206.2661,1285.8824,10.4453, 0, 0);
	// gHuntPickup[4] = CreateDynamicPickup(1276, 1, 1443.7806,-810.3639,82.2625, 0, 0);
	// gHuntCircle[0] = CreateDynamicCircle(2704.6248,-2405.3835, 6.0, 0, 0, -1, 2);
	// gHuntCircle[1] = CreateDynamicCircle(210.4413,-7.6768, 6.0, 0, 0, -1, 2);
	// gHuntCircle[2] = CreateDynamicCircle(-1707.8488,11.9746, 6.0, 0, 0, -1, 2);
	// gHuntCircle[3] = CreateDynamicCircle(2206.2661,1285.8824, 6.0, 0, 0, -1, 2);
	// gHuntCircle[4] = CreateDynamicCircle(1443.7806,-810.3639, 6.0, 0, 0, -1, 2);

    ///////////////////////////////////////////

	// gHuntPickup[0] = CreateDynamicPickup(1276, 1, 1915.8771,-1426.1943,9.9843, 0, 0);
	// gHuntPickup[1] = CreateDynamicPickup(1276, 1, 1098.1116,1642.6327,11.6279, 0, 0);
	// gHuntPickup[2] = CreateDynamicPickup(1276, 1, 76.5924,1920.1754,17.2541, 0, 0);
	// gHuntPickup[3] = CreateDynamicPickup(1276, 1, -1951.9772,258.9750,41.0471, 0, 0);
	// gHuntPickup[4] = CreateDynamicPickup(1276, 1, 383.1626,-2028.8544,7.8359, 0, 0);

	// gHuntCircle[0] = CreateDynamicCircle(1915.8771,-1426.1943, 6.0, 0, 0, -1, 2);
	// gHuntCircle[1] = CreateDynamicCircle(1098.1116,1642.6327, 6.0, 0, 0, -1, 2);
	// gHuntCircle[2] = CreateDynamicCircle(76.5924,1920.1754, 6.0, 0, 0, -1, 2);
	// gHuntCircle[3] = CreateDynamicCircle(-1951.9772,258.9750, 6.0, 0, 0, -1, 2);
	// gHuntCircle[4] = CreateDynamicCircle(383.1626,-2028.8544, 6.0, 0, 0, -1, 2);

    ///////////////////////////////////////////

    // gHuntPickup[0] = CreateDynamicPickup(1276, 1, 834.4373,-2028.5151,12.9672, 0, 0);
    // gHuntPickup[1] = CreateDynamicPickup(1276, 1, -2239.8069,-2554.5281,31.9219, 0, 0);
    // gHuntPickup[2] = CreateDynamicPickup(1276, 1, -2081.2549,212.3480,35.3053, 0, 0);
    // gHuntPickup[3] = CreateDynamicPickup(1276, 1, 2323.6482,1283.1747,97.5987, 0, 0);
    // gHuntPickup[4] = CreateDynamicPickup(1276, 1, 1444.1179,-806.9337,82.6902, 0, 0);

    // gHuntCircle[0] = CreateDynamicCircle(834.4373,-2028.5151, 6.0, 0, 0, -1, 2);
    // gHuntCircle[1] = CreateDynamicCircle(-2234.9170,-1740.0985, 6.0, 0, 0, -1, 2);
    // gHuntCircle[2] = CreateDynamicCircle(-2081.2549,212.3480, 6.0, 0, 0, -1, 2);
    // gHuntCircle[3] = CreateDynamicCircle(2323.6482,1283.1747, 6.0, 0, 0, -1, 2);
    // gHuntCircle[4] = CreateDynamicCircle(1444.1179,-806.9337, 6.0, 0, 0, -1, 2);

    ///////////////////////////////////////////

    gHuntPickup[0] = CreateDynamicPickup(1276, 1, 2839.1047,-2390.9680,14.6081, 0, 0);
    gHuntPickup[1] = CreateDynamicPickup(1276, 1, -2664.2400,624.1995,14.4531, 0, 0);
    gHuntPickup[2] = CreateDynamicPickup(1276, 1, -2227.1938,2326.9739,7.5469, 0, 0);
    gHuntPickup[3] = CreateDynamicPickup(1276, 1, 2227.2837,2458.6628,-7.4531, 0, 0);
    gHuntPickup[4] = CreateDynamicPickup(1276, 1, 273.7247,-1181.7175,79.8719, 0, 0);

    gHuntCircle[0] = CreateDynamicCircle(2839.1047,-2390.9680, 6.0, 0, 0, -1, 2);
    gHuntCircle[1] = CreateDynamicCircle(-2664.2400,624.1995, 6.0, 0, 0, -1, 2);
    gHuntCircle[2] = CreateDynamicCircle(-2227.1938,2326.9739, 6.0, 0, 0, -1, 2);
    gHuntCircle[3] = CreateDynamicCircle(2227.2837,2458.6628, 6.0, 0, 0, -1, 2);
    gHuntCircle[4] = CreateDynamicCircle(273.7247,-1181.7175, 6.0, 0, 0, -1, 2);


	foreach (new i : Player)
	{
        PI[i][p_treasure_hunt] = 0;
		gHuntStage{i} = 0;
	}

    mysql_tquery(SQL, "UPDATE igraci SET treasure_hunt = 0");
	return 1;
}

CMD:thstop(playerid, const params[])
{
	if (!gTreasureHunt)
		return ErrorMsg(playerid, "Treasure Hunt nije pokrenut.");

	gTreasureHunt = false;
	SendClientMessageToAll(NARANDZASTA, "TREASURE HUNT | {FF4500}Event je zaustavljen.");

	for__loop (new i = 0; i < sizeof gHuntPickup; i++)
	{
		DestroyDynamicPickup(gHuntPickup[i]);
		gHuntPickup[i] = -1;

		DestroyDynamicArea(gHuntCircle[i]);
		gHuntCircle[i] = -1;
	}
	return 1;
}

CMD:th(playerid, const params[])
{
    if (!gTreasureHunt)
        return ErrorMsg(playerid, "Treasure Hunt nije aktiviran.");
    
	if (gHuntStage{playerid} == 0)
	{
		SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | Checkpoint: {FF9933}Brod na dokovima.");
	}
	else if (gHuntStage{playerid} == 1)
	{
		SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | Checkpoint: {FF9933}Bolnica u SF-u.");
	}
	else if (gHuntStage{playerid} == 2)
	{
		SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | Checkpoint: {FF9933}Heliodrom u Bayside Marine.");
	}
	else if (gHuntStage{playerid} == 3)
	{
		SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | Checkpoint: {FF9933}LVPD garaza.");
	}
	else if (gHuntStage{playerid} == 4)
	{
		SendClientMessage(playerid, NARANDZASTA, "TREASURE HUNT | Checkpoint: {FF9933}Richman 308.");
	}
	return 1;
}