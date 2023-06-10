#include <YSI_Coding\y_hooks>

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((oldkeys & KEY_FIRE) && (newkeys & KEY_CROUCH))
    {
        new weaponID = GetPlayerWeapon(playerid);
        if(weaponID == 22 || weaponID == 24 || weaponID == 25 || weaponID == 27)
        {
            ApplyAnimationEx(playerid,"GYMNASIUM","gym_tread_falloff",1.0,0,0,0,0,0);
            GameTextForPlayer(playerid, "~r~C-Bug Zabranjen!", 3000, 3);
        }
    }
    return 1;
}