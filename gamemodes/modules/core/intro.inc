/*-----------------------------------------------------------------------------------------------

	daddyDOT's roleplay gamemode:

		This script is made and maintaned using Southclaws' sampctl tool,
		which can be found here: https://github.com/Southclaws/sampctl

		The module 'intro' supports both languages (English/Bosnian): ✓

	Copyright 2021 github.com/daddyDOT & https://attox.net

		Permission to use the code contained in this (https://github.com/daddyDOT/attox-rpg)
		github repository is held by copyright holders
		as creators (Ahmed 'daddyDOT' Spahić) and financiers (attox.net).

-----------------------------------------------------------------------------------------------*/

// y_hooks;
#include <YSI_Coding\y_hooks>

// associated-includes;
//#include <inline_functions>

// object-vars;
new
    introobj[MAX_PLAYERS];

// functions;
stock SHOW_Intro(playerid)
{
    static
        query[240];


    introobj = CreateDynamicObject(19538, -2495.603759, 1661.696533, 0.794260, 165.499969, 106.999954, 10.700002, GetPlayerVirtualWorld(playerid), -1, -1, 300.00, 300.00); 
    SetDynamicObjectMaterial(introobj, 0, -1, "none", "none", 0x99000000);

    TogglePlayerSpectating_H(playerid, true);

    SetPlayerCameraPos(playerid, -2488.979736, 1711.347534, 16.300119);
    SetPlayerCameraLookAt(playerid, -2493.123046, 1708.950317, 17.744640, 2);

   
    // Da li je ovaj igrac registrovan + ?
    format(query, sizeof(query), "SELECT i.id, IFNULL(s.admin,0) as admin, IFNULL(s.helper,0) as helper, IFNULL(s.promoter,0) as promoter, IFNULL(s.pin,0) as pin, i.lozinka FROM staff s RIGHT OUTER JOIN igraci i ON s.pid = i.id WHERE i.ime = '%s'", ime_obicno[playerid]);
    mysql_tquery(SQL, query, "mysql_accountLookupNew", "ii", playerid);    
    return 1;
}