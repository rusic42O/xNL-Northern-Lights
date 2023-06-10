#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_IRC_ROOMS
{
	IRC_ROOM_NAME[32],
	IRC_ROOM_FLAGS,
	IRC_ROOM_PASSWORD[32],
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new IRCRoom[MAX_IRC_ROOMS][E_IRC_ROOMS],
	pIRC[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
	pIRC[playerid] = -1;
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
CMD:irc(playerid, const params[])
{
	new dStr[512];
	format(dStr, sizeof dStr, "Naziv\tPrisutni clanovi\tDozvola\tLozinka")
	for__loop (new i; i < MAX_IRC_ROOMS)
	{
		if (!isnull(IRCRoom[i][IRC_ROOM_NAME]))
		{
			new onlineCount = 0;
			foreach (new p : Player)
			{
				if (pIRC[p] == i) onlineCount++;
			}
			format(dStr, sizeof dStr, "%s\t%i\tNe\t%s", IRCRoom[i][IRC_ROOM_NAME], onlineCount, (isnull(IRCRoom[i][IRC_ROOM_PASSWORD])? ("Ne"):("Da")));
		}
	}

	SPD(playerid, "irc", DIALOG_STYLE_LIST, "IRC", dStr, "Odaberi", "Odustani");
	return 1;
}

Dialog:irc(playerid, response, listitem, const inputtext[])
{
	if (!response) return 1;

	
	return 1;
}