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
new Text:tdColorscreen,
    tmdColorscreen,
    Iterator:iColorscreenPlayers<MAX_PLAYERS>;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    tdColorscreen = TextDrawCreate(1.0, 1.0, "_");
    TextDrawTextSize(tdColorscreen, 644.0, 32.0);
    TextDrawLetterSize(tdColorscreen, 0.0, 49.9);
    TextDrawUseBox(tdColorscreen, 1);
    TextDrawAlignment(tdColorscreen, 0);
    TextDrawBackgroundColor(tdColorscreen, 0x000000ff);
    TextDrawFont(tdColorscreen, 3);
    TextDrawColor(tdColorscreen, 0xffffffff);
    TextDrawSetOutline(tdColorscreen, 1);
    TextDrawSetProportional(tdColorscreen, 1);
    TextDrawSetShadow(tdColorscreen, 1);
    TextDrawBoxColor(tdColorscreen, 0xff000099);

    Iter_Clear(iColorscreenPlayers);
    tmdColorscreen = 0;
    return true;
}

hook OnPlayerDeath(playerid, killerid, reason)
{
    HideColorScreen(playerid);
}

hook OnPlayerDisconnect(playerid, reason)
{
    HideColorScreen(playerid);
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
forward ColorScreen();
public ColorScreen()
{
    if (Iter_Count(iColorscreenPlayers) == 0)
    {
        KillTimer(tmdColorscreen), tmdColorscreen = 0;
        return 1;
    }

    else
    {
        TextDrawBoxColor(tdColorscreen, randomColor());
        foreach(new u : iColorscreenPlayers)
        {
            ShowColorScreen(u);
        }
    }
    return 1;
}

stock randomColor()
{
    new
            result, color;
    result = randomEx(0, 5);
    switch(result)
    {
        case 0: color = 0xff000099;
        case 1: color = 0x0000ff66;
        case 2: color = 0xffff0066;
        case 3: color = 0xffffff66;
        case 4: color = 0x00ff0066;
        case 5: color = 0xff00ff66;
    }
    return color;
}

stock ShowColorScreen(playerid)
{
    TextDrawShowForPlayer(playerid, tdColorscreen);
    if (!Iter_Contains(iColorscreenPlayers, playerid))
    {
        Iter_Add(iColorscreenPlayers, playerid);
    }

    if (tmdColorscreen == 0)
    {
        tmdColorscreen = SetTimer("ColorScreen", 1000, true);
    }
}

stock HideColorScreen(playerid)
{
    TextDrawHideForPlayer(playerid, tdColorscreen);
    if (Iter_Contains(iColorscreenPlayers, playerid))
    {
        Iter_Remove(iColorscreenPlayers, playerid);
    }
}