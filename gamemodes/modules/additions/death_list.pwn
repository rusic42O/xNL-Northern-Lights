#include <YSI_Coding\y_hooks>

static 
    deathCount = 0,
    killerList[140],
    victimList[140],
    gDeathList[MAX_PLAYERS char];

hook OnGameModeInit()
{
    deathCount = 0;
    killerList[0] = victimList[0] = EOS;
    return true;
}

hook OnPlayerConnect(playerid)
{
    gDeathList{playerid} = true;
    return true;
}

hook OnPlayerSpawn(playerid)
{
    if (gDeathList{playerid})
    {
        TextDrawShowForPlayer(playerid, tdDeathList[0]);
        TextDrawShowForPlayer(playerid, tdDeathList[1]);
        TextDrawShowForPlayer(playerid, tdDeathList[2]);
    }
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    if (playerid != INVALID_PLAYER_ID && killerid != INVALID_PLAYER_ID)
    {
        deathCount ++;

        if (deathCount <= 5)
        {
            // Formatiranje iksica
            new str[21];
            str[0] = EOS;
            for__loop (new i = 0; i < deathCount; i++)
            {
                format(str, sizeof str, "%sx~N~", str);
            }
            // Nakon 5 ubistava, vise se nece ni formatirati, vec ce ih uvek biti 5 (iksica)
            TextDrawSetString(tdDeathList[1], str);
        }
        if (deathCount > 5)
        {
            // Preko 5 smrti, brisemo prvo ime, pa tek onda dodajemo novo na kraj
            new delPos; 

            delPos = strfind(killerList, "~N~") + 3; // "+3" jer brise celo "~N~"
            strdel(killerList, 0, delPos);

            delPos = strfind(victimList, "~N~") + 3; // "+3" jer brise celo "~N~"
            strdel(victimList, 0, delPos);
        }
        
        format(killerList, sizeof killerList, "%s%s~N~", killerList, ime_obicno[killerid]);
        TextDrawSetString(tdDeathList[0], killerList);

        format(victimList, sizeof victimList, "%s%s~N~", victimList, ime_obicno[playerid]);
        TextDrawSetString(tdDeathList[2], victimList);
    }
    return true;
}

CMD:ubistva(playerid, const params[])
{
    if (!gDeathList{playerid})
    {
        SendClientMessage(playerid, SVETLOPLAVA, "* Ukljucili ste globalne poruke o ubistvima.");

        TextDrawShowForPlayer(playerid, tdDeathList[0]);
        TextDrawShowForPlayer(playerid, tdDeathList[1]);
        TextDrawShowForPlayer(playerid, tdDeathList[2]);
    }
    else
    {
        SendClientMessage(playerid, SVETLOPLAVA, "* Iskljucili ste globalne poruke o ubistvima.");
        
        TextDrawHideForPlayer(playerid, tdDeathList[0]);
        TextDrawHideForPlayer(playerid, tdDeathList[1]);
        TextDrawHideForPlayer(playerid, tdDeathList[2]);
    }

    gDeathList{playerid} = !gDeathList{playerid};
    return 1;
}