#include <YSI_Coding\y_hooks>

#define COLOR_PICK              (0xFFC2C2FF)
#define WEAPONDROP_MAX_PICKUPS  (60)
#define DROP_TYPE_WEAPON        (0)
#define DROP_TYPE_FIRSTAID      (1)

enum E_WEAPONDROP_INFO 
{
    WeaponDrop_PickupID,
    WeaponDrop_Type, 
    WeaponDrop_WeaponID, 
    WeaponDrop_Ammo,
    Text3D:WeaponDrop_LabelID,
    WeaponDrop_Timer,
}
new WeaponDropInfo[WEAPONDROP_MAX_PICKUPS][E_WEAPONDROP_INFO];

hook OnGameModeInit()
{
    for(new i = 0; i < WEAPONDROP_MAX_PICKUPS; i++) 
    {
        WeaponDropInfo[i][WeaponDrop_PickupID] = -1;
    }
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (GetPVarInt(playerid, "pKilledByAdmin") != 1 && !IsPlayerInWar(playerid) && !IsPlayerInDMArena(playerid))
    {
        DropPlayerWeapons(playerid);
    }
    return true;
}

hook OnPlayerPickUpDynPickup(playerid, pickupid) 
{
    for(new i = 0; i < WEAPONDROP_MAX_PICKUPS; i++) 
    {
        if(pickupid == WeaponDropInfo[i][WeaponDrop_PickupID] && WeaponDropInfo[i][WeaponDrop_PickupID] != -1 && GetPVarInt(playerid, "pIgnoreDeathFine") != 1)  
        {
            if(WeaponDropInfo[i][WeaponDrop_Type] == DROP_TYPE_FIRSTAID) 
            {
                SendClientMessage(playerid, COLOR_PICK, "Pokupili ste prvu pomoc. (+10hp)");
                new Float: HP;
                GetPlayerHealth(playerid, HP);
                if(HP < 90) SetPlayerHealth(playerid, HP+10);
                else SetPlayerHealth(playerid, 100);
            }
            else 
            {
                new gunname[32];
                GetWeaponName(WeaponDropInfo[i][WeaponDrop_WeaponID], gunname, sizeof(gunname));
                SendClientMessageF(playerid, COLOR_PICK, "Pokupili ste %s sa %d metaka.", gunname, WeaponDropInfo[i][WeaponDrop_Ammo]);
                GivePlayerWeapon(playerid, WeaponDropInfo[i][WeaponDrop_WeaponID], WeaponDropInfo[i][WeaponDrop_Ammo]);
            }

            KillTimer(WeaponDropInfo[i][WeaponDrop_Timer]);

            DestroyDynamicPickup(WeaponDropInfo[i][WeaponDrop_PickupID]);
            WeaponDropInfo[i][WeaponDrop_PickupID] = -1;

            DestroyDynamic3DTextLabel(WeaponDropInfo[i][WeaponDrop_LabelID]);
            WeaponDropInfo[i][WeaponDrop_LabelID] = Text3D:INVALID_3DTEXT_ID;

            WeaponDropInfo[i][WeaponDrop_Type] = 0;
            PlayerPlaySound(playerid, 1150, 0.0, 0.0, 10.0);    
        }   
    }
    return 1;
}   

stock DropPlayerWeapons(playerid) 
{
    new Float: Pos[3], string[128], gunname[32], sweapon, sammo, idd = -1, result;
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

    if (IsACop(playerid) || IsPlayerInWar(playerid) || IsPlayerInDMEvent(playerid) || IsPlayerInHorrorEvent(playerid) || IsPlayerInLMSEvent(playerid)) return 1;

    // Oruzje
    for(new i = 0; i < 12; i++) 
    {
        GetPlayerWeaponData(playerid, i, sweapon, sammo); 
        if(sweapon != 0 && sweapon != WEAPON_MINIGUN) 
        {
            result++;
            idd = WEAPONDROP_GetEmptyID();
            if (idd == -1) return 1; // Nema slobodnih slotova
            WeaponDropInfo[idd][WeaponDrop_PickupID] = CreateDynamicPickup(GetWeaponObject(sweapon), 23, Pos[0]+result, Pos[1]+2, Pos[2], -1);
            WeaponDropInfo[idd][WeaponDrop_Type] =  DROP_TYPE_WEAPON;
            WeaponDropInfo[idd][WeaponDrop_WeaponID] = sweapon;
            WeaponDropInfo[idd][WeaponDrop_Ammo] = sammo;
            GetWeaponName(sweapon, gunname, sizeof(gunname));           
            format(string, sizeof(string), "{90F037}%s\n{FFFFFF}%d metaka", gunname, sammo);           
            WeaponDropInfo[idd][WeaponDrop_LabelID] = CreateDynamic3DTextLabel(string, 0xFFFFFFAA, Pos[0]+result, Pos[1]+2, Pos[2], 10.0, 0, 0);
            WeaponDropInfo[idd][WeaponDrop_Timer] = SetTimerEx("WEAPONDROP_DestroyPickup", 300*1000, false, "i", idd);
        }
    }
    ResetPlayerWeapons(playerid);
    return 1;
}

stock GetWeaponObject(weaponid) 
{
    if(weaponid == 1) return 331; 
    else if(weaponid == 2) return 332; 
    else if(weaponid == 3) return 333; 
    else if(weaponid == 5) return 334; 
    else if(weaponid == 6) return 335; 
    else if(weaponid == 7) return 336; 
    else if(weaponid == 10) return 321; 
    else if(weaponid == 11) return 322; 
    else if(weaponid == 12) return 323; 
    else if(weaponid == 13) return 324; 
    else if(weaponid == 14) return 325; 
    else if(weaponid == 15) return 326; 
    else if(weaponid == 23) return 347; 
    else if(weaponid == 24) return 348; 
    else if(weaponid == 25) return 349; 
    else if(weaponid == 26) return 350; 
    else if(weaponid == 27) return 351; 
    else if(weaponid == 28) return 352; 
    else if(weaponid == 29) return 353; 
    else if(weaponid == 30) return 355; 
    else if(weaponid == 31) return 356; 
    else if(weaponid == 32) return 372;
    else if(weaponid == 33) return 357; 
    else if(weaponid == 4) return 335; 
    else if(weaponid == 34) return 358; 
    else if(weaponid == 41) return 365; 
    else if(weaponid == 42) return 366; 
    else if(weaponid == 43) return 367; 
    return 0;
}

forward WEAPONDROP_DestroyPickup(id);
public WEAPONDROP_DestroyPickup(id)
{
    if(WeaponDropInfo[id][WeaponDrop_PickupID] != -1) 
    {
        DestroyDynamicPickup(WeaponDropInfo[id][WeaponDrop_PickupID]);
        WeaponDropInfo[id][WeaponDrop_PickupID] = -1;

        DestroyDynamic3DTextLabel(WeaponDropInfo[id][WeaponDrop_LabelID]);
        WeaponDropInfo[id][WeaponDrop_LabelID] = Text3D:INVALID_3DTEXT_ID;

        WeaponDropInfo[id][WeaponDrop_Type] = 0;
        WeaponDropInfo[id][WeaponDrop_Timer] = 0;
    }
    return 1;
}

stock WEAPONDROP_DestroyPickups() 
{
    for(new i = 0; i < WEAPONDROP_MAX_PICKUPS; i++) 
    {
        WEAPONDROP_DestroyPickup(i);
    }
    return 1;
}

stock WEAPONDROP_GetEmptyID() 
{
    for(new i = 0; i < WEAPONDROP_MAX_PICKUPS; i++) 
    {
        if(WeaponDropInfo[i][WeaponDrop_PickupID] == -1) return i;
    }
    return -1;
}