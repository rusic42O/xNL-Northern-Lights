// ============================================================
//              Attached Object Ex (AOX)
//                      by Corekt a.k.a. robotmonkey
//                              - 2014
//
//      ***IMPORTANT***
//      You must include this before any other
//      include that uses SetPlayerAttachedObject or
//      RemovePlayerAttachedObject
//
//      For updates please visit
//            http://forum.sa-mp.com/showthread.php?t=506429
//            https://pastebin.com/raw/WmfPGSCn
// ============================================================
 
#include <YSI_Coding\y_hooks>


// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_AOX_DATA
{
    eAO_modelid,
    eAO_bone,
    Float:eAO_fOffsetX,
    Float:eAO_fOffsetY,
    Float:eAO_fOffsetZ,
    Float:eAO_fRotX,
    Float:eAO_fRotY,
    Float:eAO_fRotZ,
    Float:eAO_fScaleX,
    Float:eAO_fScaleY,
    Float:eAO_fScaleZ,
    eAO_materialcolor1,
    eAO_materialcolor2,
    eAO_id,
    bool:eAO_tempRemoved,
    bool:eAO_isMoving
}





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static
    gPlayerAO[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][E_AOX_DATA],
    gIsPlayerWeaponZoomedIn[MAX_PLAYERS],
    gTimerWeaponZoom[MAX_PLAYERS],
    bool:gAOWeaponZoomEnabled[MAX_PLAYERS];





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    for__loop (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) 
    {
        RemovePlayerAttachedObject(playerid, i);
        gPlayerAO[playerid][i][eAO_modelid] = INVALID_OBJECT_ID;
        gPlayerAO[playerid][i][eAO_bone] = 0;
        gPlayerAO[playerid][i][eAO_fOffsetX] = 0;
        gPlayerAO[playerid][i][eAO_fOffsetY] = 0;
        gPlayerAO[playerid][i][eAO_fOffsetZ] = 0;
        gPlayerAO[playerid][i][eAO_fRotX] = 0;
        gPlayerAO[playerid][i][eAO_fRotY] = 0;
        gPlayerAO[playerid][i][eAO_fRotZ] = 0;
        gPlayerAO[playerid][i][eAO_fScaleX] = 0;
        gPlayerAO[playerid][i][eAO_fScaleY] = 0;
        gPlayerAO[playerid][i][eAO_fScaleZ] = 0;
        gPlayerAO[playerid][i][eAO_materialcolor1] = 0;
        gPlayerAO[playerid][i][eAO_materialcolor2] = 0;
        gPlayerAO[playerid][i][eAO_id] = 0;
        gPlayerAO[playerid][i][eAO_tempRemoved] = false;
    }
    gIsPlayerWeaponZoomedIn[playerid] = false;
    gAOWeaponZoomEnabled[playerid] = true;


    ToggleRemoveAOWeaponZoom(playerid, 1);
    return 1;
}
 
hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (gAOWeaponZoomEnabled[playerid]) 
    {
        if ((((newkeys & (KEY_HANDBRAKE)) == (KEY_HANDBRAKE)) && ((oldkeys & (KEY_HANDBRAKE)) != (KEY_HANDBRAKE))) && !IsPlayerInAnyVehicle(playerid)) 
        {
            if (GetPlayerWeapon(playerid) == WEAPON_SNIPER || GetPlayerWeapon(playerid) == WEAPON_ROCKETLAUNCHER || GetPlayerWeapon(playerid) == WEAPON_HEATSEEKER || GetPlayerWeapon(playerid) == WEAPON_CAMERA) 
            {
                if (!gIsPlayerWeaponZoomedIn[playerid]) 
                {
                    if (GetAttachedObjectCount(playerid) > 0) 
                    {
                        gIsPlayerWeaponZoomedIn[playerid] = true;
                        TempRemoveAttachedObjects(playerid);
                    }
                }
            }
        }
        else if ((((newkeys & (KEY_HANDBRAKE)) != (KEY_HANDBRAKE)) && ((oldkeys & (KEY_HANDBRAKE)) == (KEY_HANDBRAKE))) && gIsPlayerWeaponZoomedIn[playerid])
        {
            RestorePlayerAttachedObjects(playerid);
            gIsPlayerWeaponZoomedIn[playerid] = false;
        }
    }
    return 1;
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if (!(0 <= index <= 9)) return ~0;
    if (gPlayerAO[playerid][index][eAO_modelid] != modelid) return ~0;

    if (response)
    {
        gPlayerAO[playerid][index][eAO_modelid] = modelid;
        gPlayerAO[playerid][index][eAO_bone] = boneid;
        gPlayerAO[playerid][index][eAO_fOffsetX] = fOffsetX;
        gPlayerAO[playerid][index][eAO_fOffsetY] = fOffsetY;
        gPlayerAO[playerid][index][eAO_fOffsetZ] = fOffsetZ;
        gPlayerAO[playerid][index][eAO_fRotX] = fRotX;
        gPlayerAO[playerid][index][eAO_fRotY] = fRotY;
        gPlayerAO[playerid][index][eAO_fRotZ] = fRotZ;
        gPlayerAO[playerid][index][eAO_fScaleX] = fScaleX;
        gPlayerAO[playerid][index][eAO_fScaleY] = fScaleY;
        gPlayerAO[playerid][index][eAO_fScaleZ] = fScaleZ;
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock _AOX_SetPlayerAttachedObject(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
    if (index < 0 || index >= MAX_PLAYER_ATTACHED_OBJECTS) return 0; // prevent array index out of bounds exception
    
    new
        bool:replaceObj = false;
        
    if (IsPlayerAttachedObjectSlotUsed(playerid, index)) replaceObj = true;
    
    if (SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2) != 0) {
        if (!replaceObj && !gPlayerAO[playerid][index][eAO_tempRemoved]) gPlayerAO[playerid][index][eAO_id]++;
        gPlayerAO[playerid][index][eAO_modelid] = modelid;
        gPlayerAO[playerid][index][eAO_bone] = bone;
        gPlayerAO[playerid][index][eAO_fOffsetX] = fOffsetX;
        gPlayerAO[playerid][index][eAO_fOffsetY] = fOffsetY;
        gPlayerAO[playerid][index][eAO_fOffsetZ] = fOffsetZ;
        gPlayerAO[playerid][index][eAO_fRotX] = fRotX;
        gPlayerAO[playerid][index][eAO_fRotY] = fRotY;
        gPlayerAO[playerid][index][eAO_fRotZ] = fRotZ;
        gPlayerAO[playerid][index][eAO_fScaleX] = fScaleX;
        gPlayerAO[playerid][index][eAO_fScaleY] = fScaleY;
        gPlayerAO[playerid][index][eAO_fScaleZ] = fScaleZ;
        gPlayerAO[playerid][index][eAO_materialcolor1] = materialcolor1;
        gPlayerAO[playerid][index][eAO_materialcolor2] = materialcolor2;
        return 1;
    } 
    else 
    {
        return 0;
    }
}
#if defined _ALS_SetPlayerAttachedObject
    #undef SetPlayerAttachedObject
#else
    #define _ALS_SetPlayerAttachedObject
#endif
#define SetPlayerAttachedObject _AOX_SetPlayerAttachedObject


stock _AOX_RemovePlayerAttachedObject(playerid, index)
{
    if (index < 0 || index >= MAX_PLAYER_ATTACHED_OBJECTS) return 0; // prevent array index out of bounds exception

    if (!gPlayerAO[playerid][index][eAO_tempRemoved]) 
    {
        gPlayerAO[playerid][index][eAO_modelid] = INVALID_OBJECT_ID;
        gPlayerAO[playerid][index][eAO_bone] = 0;
        gPlayerAO[playerid][index][eAO_fOffsetX] = 0;
        gPlayerAO[playerid][index][eAO_fOffsetY] = 0;
        gPlayerAO[playerid][index][eAO_fOffsetZ] = 0;
        gPlayerAO[playerid][index][eAO_fRotX] = 0;
        gPlayerAO[playerid][index][eAO_fRotY] = 0;
        gPlayerAO[playerid][index][eAO_fRotZ] = 0;
        gPlayerAO[playerid][index][eAO_fScaleX] = 0;
        gPlayerAO[playerid][index][eAO_fScaleY] = 0;
        gPlayerAO[playerid][index][eAO_fScaleZ] = 0;
        gPlayerAO[playerid][index][eAO_materialcolor1] = 0;
        gPlayerAO[playerid][index][eAO_materialcolor2] = 0;
    }

    return RemovePlayerAttachedObject(playerid, index);
}
#if defined _ALS_RemovePlayerAttachedObject
    #undef RemovePlayerAttachedObject
#else
    #define _ALS_RemovePlayerAttachedObject
#endif
#define RemovePlayerAttachedObject _AOX_RemovePlayerAttachedObject
 
// ==========================================================
 
stock GetFreePlayerAttachedObjectSlot(playerid)
{
    for__loop (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) 
    {
        if (!IsPlayerAttachedObjectSlotUsed(playerid, i))
            return i;
    }
    return -1;
}
 
stock GetAttachedObjectCount(playerid)
{
    new count;
    for__loop (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) 
    {
        if (IsPlayerAttachedObjectSlotUsed(playerid, i))
            count++;
    }
    return count;
}
 
stock GetPlayerAttachedObjectID(playerid, index)
{
    if (!IsPlayerAttachedObjectSlotUsed(playerid, index) && !gPlayerAO[playerid][index][eAO_tempRemoved])
        return -1;
    return (gPlayerAO[playerid][index][eAO_tempBirth] != 0) ? gPlayerAO[playerid][index][eAO_id] : -1;
}

stock SetPlayerAttachedObjectScale(playerid, index, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if (!IsPlayerAttachedObjectSlotUsed(playerid, index))
        return 0;
        
    gPlayerAO[playerid][index][eAO_fScaleX] = fScaleX;
    gPlayerAO[playerid][index][eAO_fScaleY] = fScaleY;
    gPlayerAO[playerid][index][eAO_fScaleZ] = fScaleZ;
        
    SetPlayerAttachedObject(playerid, index,
        gPlayerAO[playerid][index][eAO_modelid], gPlayerAO[playerid][index][eAO_bone],
        gPlayerAO[playerid][index][eAO_fOffsetX], gPlayerAO[playerid][index][eAO_fOffsetY], gPlayerAO[playerid][index][eAO_fOffsetZ],
        gPlayerAO[playerid][index][eAO_fRotX], gPlayerAO[playerid][index][eAO_fRotY], gPlayerAO[playerid][index][eAO_fRotZ],
        gPlayerAO[playerid][index][eAO_fScaleX], gPlayerAO[playerid][index][eAO_fScaleY], gPlayerAO[playerid][index][eAO_fScaleZ],
        gPlayerAO[playerid][index][eAO_materialcolor1], gPlayerAO[playerid][index][eAO_materialcolor2]);
    return 1;
}

stock SetPlayerAttachedObjectColor(playerid, index, materialcolor1, materialcolor2)
{
    if (!IsPlayerAttachedObjectSlotUsed(playerid, index))
        return 0;
        
    gPlayerAO[playerid][index][eAO_materialcolor1] = materialcolor1;
    gPlayerAO[playerid][index][eAO_materialcolor2] = materialcolor2;
        
    SetPlayerAttachedObject(playerid, index,
        gPlayerAO[playerid][index][eAO_modelid], gPlayerAO[playerid][index][eAO_bone],
        gPlayerAO[playerid][index][eAO_fOffsetX], gPlayerAO[playerid][index][eAO_fOffsetY], gPlayerAO[playerid][index][eAO_fOffsetZ],
        gPlayerAO[playerid][index][eAO_fRotX], gPlayerAO[playerid][index][eAO_fRotY], gPlayerAO[playerid][index][eAO_fRotZ],
        gPlayerAO[playerid][index][eAO_fScaleX], gPlayerAO[playerid][index][eAO_fScaleY], gPlayerAO[playerid][index][eAO_fScaleZ],
        gPlayerAO[playerid][index][eAO_materialcolor1], gPlayerAO[playerid][index][eAO_materialcolor2]);
    return 1;
}

stock ToggleRemoveAOWeaponZoom(playerid, toggle)
{
    gAOWeaponZoomEnabled[playerid] = (toggle) ? true : false;
}

stock TempRemoveAttachedObjects(playerid)
{
    if (!gIsPlayerWeaponZoomedIn[playerid]) return 0;

    for__loop (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) 
    {
        if (!IsPlayerAttachedObjectSlotUsed(playerid, i)) continue;

        if (gAOWeaponZoomEnabled[playerid]) 
        {
            gPlayerAO[playerid][i][eAO_tempRemoved] = true;
            RemovePlayerAttachedObject(playerid, i);
        }
    }
    return 1;
}

stock RestorePlayerAttachedObjects(playerid)
{
    if (!gIsPlayerWeaponZoomedIn[playerid]) return 0;
    for__loop (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++) 
    {
        if ((gAOWeaponZoomEnabled[playerid]) && gPlayerAO[playerid][i][eAO_tempRemoved]) 
        {
            SetPlayerAttachedObject(playerid, i, gPlayerAO[playerid][i][eAO_modelid], gPlayerAO[playerid][i][eAO_bone],
                gPlayerAO[playerid][i][eAO_fOffsetX], gPlayerAO[playerid][i][eAO_fOffsetY], gPlayerAO[playerid][i][eAO_fOffsetZ],
                gPlayerAO[playerid][i][eAO_fRotX], gPlayerAO[playerid][i][eAO_fRotY], gPlayerAO[playerid][i][eAO_fRotZ],
                gPlayerAO[playerid][i][eAO_fScaleX], gPlayerAO[playerid][i][eAO_fScaleY], gPlayerAO[playerid][i][eAO_fScaleZ],
                gPlayerAO[playerid][i][eAO_materialcolor1], gPlayerAO[playerid][i][eAO_materialcolor2]);

            gPlayerAO[playerid][i][eAO_tempRemoved] = false;
        }
    }
    return 1;
}

forward _AOX_CheckWeaponZoom(playerid);
public _AOX_CheckWeaponZoom(playerid)
{
    if (!gIsPlayerWeaponZoomedIn[playerid]) return 0;
    new camMode = GetPlayerCameraMode(playerid);

    if (camMode != 7 && camMode != 8 && camMode != 16 && camMode != 46 && camMode != 51) 
    {
        RestorePlayerAttachedObjects(playerid);
        gIsPlayerWeaponZoomedIn[playerid] = false;
        KillTimer(gTimerWeaponZoom[playerid]);
    }
    return 1;
}