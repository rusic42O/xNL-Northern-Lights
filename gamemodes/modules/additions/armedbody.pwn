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
new tajmer:ArmedBody[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    tajmer:ArmedBody[playerid] = SetTimerEx("ArmedBody", 1000, true, "ii", playerid, cinc[playerid]);
}

hook OnPlayerSpawn(playerid)
{
    DettachPlayerBodyArmor(playerid);
}

hook OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_ARMOR))
    {
        new Float:armor;
        GetPlayerArmour(playerid, armor);

        if (armor <= 0.0)
        {
            DettachPlayerBodyArmor(playerid);
        }
    }
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward ArmedBody(playerid, ccinc);
public ArmedBody(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
    {
        KillTimer(tajmer:ArmedBody[playerid]);
        return 1;
    }

    if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
        new weaponid, weaponammo, pArmedWeapon;
        pArmedWeapon = GetPlayerWeapon(playerid);
        GetPlayerWeaponData(playerid, 5, weaponid, weaponammo);

        if(weaponid && weaponammo > 0)
        {
            if(pArmedWeapon != weaponid)
            {
                if(!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_WEAPON))
                {
                    SetPlayerAttachedObject(playerid, SLOT_BODY_WEAPON, GetWeaponModel(weaponid), 1, 0.200000, -0.119999, -0.059999, 0.000000, 206.000000, 0.000000, 1.000000, 1.000000, 1.000000);
                }
            }
            else 
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_WEAPON))
                {
                    RemovePlayerAttachedObject(playerid, SLOT_BODY_WEAPON);
                }
            }
        }
        else if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_WEAPON))
        {
            RemovePlayerAttachedObject(playerid, SLOT_BODY_WEAPON);
        }
    }
    return 1;
}

stock AttachPlayerBodyArmor(playerid)
{
    // koristi se u overwatch -> OW_SetPlayerArmor

    if (!IsOnDuty(playerid))
    {
        // staff na duznosti nema ovaj objekat!

        if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_ARMOR))
        {
            RemovePlayerAttachedObject(playerid, SLOT_BODY_ARMOR);
        }
        
        SetPlayerAttachedObject(playerid, SLOT_BODY_ARMOR, 373, 1, 0.286006, -0.038657, -0.158132, 67.128456, 21.916156, 33.972290, 1.000000, 1.000000, 1.000000);
    }
}

stock DettachPlayerBodyArmor(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_BODY_ARMOR))
    {
        RemovePlayerAttachedObject(playerid, SLOT_BODY_ARMOR);
    }
}

stock GetWeaponModel(weaponid)
{
    switch(weaponid)
    {
        case 1:
            return 331;

        case 2..8:
            return weaponid+331;

        case 9:
            return 341;

        case 10..15:
            return weaponid+311;

        case 16..18:
            return weaponid+326;

        case 22..29:
            return weaponid+324;

        case 30,31:
            return weaponid+325;

        case 32:
            return 372;

        case 33..45:
            return weaponid+324;

        case 46:
            return 371;
    }
    return 0;
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
