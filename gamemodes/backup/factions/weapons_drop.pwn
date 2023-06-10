#include <YSI_Coding\y_hooks>

// TODO: Fali zapravo da se igracu doda oruzje (i ispise poruka sta je uzeo) + da svim igracima dodje obavestenje kad dodje novi drop + "Obijanje"
// TODO: Izbaciti igraca napolje ako se nalazi unutra u trenutku novog dropa
// TODO: Dodati tipku za prekidanje provale (opste)

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define WEAPONSDROP_BREAKIN_X (2259.8853)
#define WEAPONSDROP_BREAKIN_Y (-2248.5562)
#define WEAPONSDROP_BREAKIN_Z (13.5469)




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_WEAPONS_PACKAGES
{
    WEAPONS_PCK_PICKUPID,
    Float:WEAPONS_PCK_POS[3],
    bool:WEAPONS_PCK_COLLECTED,
    WEAPONS_PCK_WEAPON_ID,
    WEAPONS_PCK_WEAPON_COUNT,
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new bool:WeaponsDrop_PickedUp[MAX_PLAYERS char],
    bool:WeaponsDrop_Active,
    WeaponsDrop_BreakInPickup,
    WeaponsDrop_BreakInPlayerID,
    WeaponsDrop_GateObject;

new WEAPONS_PACKAGES[][E_WEAPONS_PACKAGES] = 
{
    {-1, {2231.4824, -2284.4404, 14.3751},    false, -1, 0},
    {-1, {2234.5098, -2287.4399, 14.3751},    false, -1, 0},
    {-1, {2246.4446, -2269.3848, 14.3751},    false, -1, 0},
    {-1, {2252.8342, -2262.9846, 14.3751},    false, -1, 0}
};

new WeaponsDrop_EligibleWeapons[] = {WEAPON_DEAGLE, WEAPON_AK47,    WEAPON_M4,  WEAPON_MP5, WEAPON_SHOTGUN};
new WeaponsDrop_WeaponsAmmo[]     = {50,            200,            200,        200,        30};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    new tmpobjid;
    tmpobjid = Map_AddObject(18762, 2260.267822, -2251.006103, 16.611841, 0.000000, 0.000000, 45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_carparkwall2", 0x00000000);
	tmpobjid = Map_AddObject(18762, 2260.267822, -2251.006103, 11.611825, 0.000000, 0.000000, 45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_carparkwall2", 0x00000000);
	tmpobjid = Map_AddObject(18762, 2267.956542, -2258.694824, 11.611825, 0.000000, 0.000000, 45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_carparkwall2", 0x00000000);
	tmpobjid = Map_AddObject(18762, 2267.956542, -2258.694824, 16.611808, 0.000000, 0.000000, 45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, "a51", "ws_carparkwall2", 0x00000000);
	tmpobjid = Map_AddObject(3117, 2250.557861, -2260.955078, 13.246022, 0.000000, 0.000000, -45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2567, "ab", "chipboard_256", 0x00000000);
	tmpobjid = Map_AddObject(3117, 2244.228271, -2267.284667, 13.246022, 0.000000, 0.000000, -45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2567, "ab", "chipboard_256", 0x00000000);
	tmpobjid = Map_AddObject(3117, 2236.533935, -2289.534179, 13.246022, 0.000000, 0.000000, -45.000000); 
	SetDynamicObjectMaterial(tmpobjid, 0, 2567, "ab", "chipboard_256", 0x00000000);
	tmpobjid = Map_AddObject(19911, 2227.682861, -2303.448730, 15.915509, 0.000000, 0.000000, 45.000000); 
	tmpobjid = Map_AddObject(19911, 2220.866210, -2296.632080, 15.915509, 0.000000, 0.000000, 45.000000); 
	tmpobjid = Map_AddObject(19911, 2214.051513, -2289.817382, 15.915509, 0.000000, 0.000000, 45.000000); 
	tmpobjid = Map_AddObject(19305, 2259.329101, -2249.028808, 14.000863, 0.000016, -0.000016, 134.800094); 
	tmpobjid = Map_AddObject(927, 2259.908935, -2249.459228, 14.332737, 0.000016, -0.000016, 135.100021); 
	tmpobjid = Map_AddObject(1299, 2255.074707, -2243.348632, 12.997143, 0.000000, 0.000000, -47.499992); 
    
    WeaponsDrop_Active = false;
    WeaponsDrop_BreakInPickup = -1;
    WeaponsDrop_BreakInPlayerID = INVALID_PLAYER_ID;
    WeaponsDrop_Init();

    WeaponsDrop_GateObject = CreateDynamicObjectEx(3037, 2264.252685, -2254.703369, 14.954821, 0.000000, 0.000000, 45.000000, 750.00, 750.00); 
    return true;
}

hook OnPlayerConnect(playerid)
{
    WeaponsDrop_PickedUp{playerid} = false;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid)
    {
        WeaponsDrop_BreakInPlayerID = INVALID_PLAYER_ID;
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid)
    {
        WeaponsDrop_BreakInPlayerID = INVALID_PLAYER_ID;
    }
}

hook OnPlayerSpawn(playerid)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid)
    {
        WeaponsDrop_BreakInPlayerID = INVALID_PLAYER_ID;
    }
}

hook OnPlayerPickUpDynPickup(playerid, pickupid)
{
    if (pickupid == WeaponsDrop_BreakInPickup && WeaponsDrop_BreakInPlayerID != playerid)
    {
        GameTextForPlayer(playerid, "~r~MESTO ZA OBIJANJE~n~~w~Koristite tipku ~y~~k~~CONVERSATION_NO~ ~w~da zapocenete provalu.", 5000, 3);
        return ~1;
    }

    for__loop (new i = 0; i < sizeof WEAPONS_PACKAGES; i++)
    {
        if (WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID] == pickupid)
        {
            // Igrac je stao na pickup za paket sastojaka

            if (WeaponsDrop_PickedUp{playerid})
                return ErrorMsg(playerid, "Vec ste pokupili paket sa oruzjem.");

            if (WEAPONS_PACKAGES[i][WEAPONS_PCK_COLLECTED])
                return ErrorMsg(playerid, "Na ovom mestu nema nikakve robe.");

            WEAPONS_PACKAGES[i][WEAPONS_PCK_COLLECTED] = true;
            DestroyDynamicPickup(WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID]);
            WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID] = -1;

            WeaponsDrop_PickedUp{playerid} = true;

            GivePlayerWeapon(playerid, WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_ID], WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_COUNT]);

            new weapon[22];
            GetWeaponName(WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_ID], weapon, sizeof weapon);
            SendClientMessageF(playerid, SVETLOPLAVA, "* Pokupili ste paket: {FFFFFF}%s sa %i metaka.", weapon, WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_COUNT]);
            return ~1;
        }
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys == KEY_NO)
    {
        if (IsPlayerInRangeOfPoint(playerid, 4.0, WEAPONSDROP_BREAKIN_X, WEAPONSDROP_BREAKIN_Y, WEAPONSDROP_BREAKIN_Z))
        {
            if (!BP_PlayerHasItem(playerid, ITEM_CROWBAR))
                return ErrorMsg(playerid, "Nemate pajser da biste zapoceli provalu.");

            if (!WeaponsDrop_Active)
                return ErrorMsg(playerid, "Jos uvek nije stigla nova isporuka oruzja.");

            if (WeaponsDrop_Active && IsPlayerConnected(WeaponsDrop_BreakInPlayerID))
                return ErrorMsg(playerid, "Provala u skladiste je vec u toku.");

            if (!IsACriminal(playerid))
                return ErrorMsg(playerid, "Samo pripadnici mafija i bandi mogu pljackati ovo skladiste.");


            WeaponsDrop_BreakInPlayerID = playerid;

            PlayerStartBurglary(playerid);
        }
    }
    return 1;
}

hook OnBurglarySuccess(playerid)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid && IsPlayerInRangeOfPoint(playerid, 4.0, WEAPONSDROP_BREAKIN_X, WEAPONSDROP_BREAKIN_Y, WEAPONSDROP_BREAKIN_Z))
    {
        MoveDynamicObject(WeaponsDrop_GateObject, 2264.252685, -2254.703369, 17.764825, 2.75);
        DestroyDynamicPickup(WeaponsDrop_BreakInPickup), WeaponsDrop_BreakInPickup = -1;

        // Skill UP za sve u okolini
        new fid = PI[playerid][p_org_id];
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid, x, y, z);
        foreach (new i : Player)
        {
            if (PI[i][p_org_id] == fid)
            {
                if (IsPlayerInRangeOfPoint(i, 20.0, x, y, z))
                {
                    PlayerUpdateCriminalSkill(i, 1, SKILL_WEAPONS_DROP, (i==playerid)? 0 : 1);
                }
            }
        }
    }
}

hook OnBurglaryFail(playerid)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid)
    {
        SetWeaponsDropInactive();
    }
    return 1;
}

hook OnBurglaryStop(playerid)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid)
    {
        SetWeaponsDropInactive();
    }
    return 1;
}



// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerRobbingWeaponsWH(playerid)
{
    if (WeaponsDrop_Active && WeaponsDrop_BreakInPlayerID == playerid && IsPlayerInRangeOfPoint(playerid, 10.0, WEAPONSDROP_BREAKIN_X, WEAPONSDROP_BREAKIN_Y, WEAPONSDROP_BREAKIN_Z))
    {
        // Malo veci range je stavljen.

        return 1;
    }
    return 0;
}
stock SetWeaponsDropInactive()
{
    WeaponsDrop_Active = false;
    WeaponsDrop_BreakInPlayerID = INVALID_PLAYER_ID;
}

stock WeaponsDrop_Init()
{
    new h, m, s, timerInterval;
    gettime(h, m, s);
    timerInterval = 3600 - h*60 - s;

    SetTimer("WeaponsDrop", (timerInterval - 200 + random(500)) * 1000, false);
}

forward WeaponsDrop();
public WeaponsDrop()
{
    if (DebugFunctions())
    {
        LogFunctionExec("WeaponsDrop");
    }

    WeaponsDrop_Active = true;

    foreach (new i : Player)
    {
        WeaponsDrop_PickedUp{i} = false;
    }


    for__loop (new i = 0; i < sizeof WEAPONS_PACKAGES; i++)
    {
        // Resetovanje


        new randomWeapon = random(sizeof WeaponsDrop_EligibleWeapons);
        WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_ID] = WeaponsDrop_EligibleWeapons[randomWeapon];
        WEAPONS_PACKAGES[i][WEAPONS_PCK_WEAPON_COUNT] = WeaponsDrop_WeaponsAmmo[randomWeapon];
        WEAPONS_PACKAGES[i][WEAPONS_PCK_COLLECTED] = false;


        if (IsValidDynamicPickup(WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID]))
        {
            DestroyDynamicPickup(WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID]);
            WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID] = -1;
        }
        WEAPONS_PACKAGES[i][WEAPONS_PCK_PICKUPID] = CreateDynamicPickup(2358, 1, WEAPONS_PACKAGES[i][WEAPONS_PCK_POS][POS_X], WEAPONS_PACKAGES[i][WEAPONS_PCK_POS][POS_Y], WEAPONS_PACKAGES[i][WEAPONS_PCK_POS][POS_Z], 0, 0);
    }

    // Postavljanje pickupa
    if (IsValidDynamicPickup(WeaponsDrop_BreakInPickup))
    {
        DestroyDynamicPickup(WeaponsDrop_BreakInPickup);
        WeaponsDrop_BreakInPickup = -1;
    }
    WeaponsDrop_BreakInPickup = CreateDynamicPickup(1239, 2, WEAPONSDROP_BREAKIN_X, WEAPONSDROP_BREAKIN_Y, WEAPONSDROP_BREAKIN_Z, 0, 0);

    // Zatvaranje kapije
    MoveDynamicObject(WeaponsDrop_GateObject, 2264.252685, -2254.703369, 14.954821, 2.75);

    // Obavestenje za sve igrace
    foreach (new i : Player)
    {
        if (IsPlayerLoggedIn(i))
            SendClientMessage(i, CRVENA, "[DOUSNIK] {FFFF80}Vagoni sa oruzjem su stigli u skladiste.");
            // SendClientMessage(i, ZLATNA, "*** Paketi sa oruzjem su isporuceni.");
    }

    // Tajmer za sledeci drop
    SetTimer("WeaponsDrop", (3600 - 200 + random(500))*1000, false);

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:wdrop(FLAG_ADMIN_6)
CMD:wdrop(playerid, const params[])
{
    return WeaponsDrop();
}