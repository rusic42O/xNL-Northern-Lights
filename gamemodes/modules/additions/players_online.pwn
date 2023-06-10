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
new playersOnline;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	playersOnline = 0;
	mysql_tquery(SQL, "TRUNCATE players_online");
	return true;
}

hook OnPlayerConnect(playerid)
{
	PlayerCountInc(playerid);
	playersOnline_UpdateTD();
}

hook OnPlayerDisconnect(playerid, reason)
{
	PlayerCountDec(playerid);
	playersOnline_UpdateTD();
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock PlayerCountInc(playerid = INVALID_PLAYER_ID)
{
	if(IsPlayerNPC(playerid))
		return 1;
	
	playersOnline += 1;

	// Update podataka u bazi
	if (playerid != INVALID_PLAYER_ID)
	{
		new sQuery[92], playerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playerName, sizeof playerName);
		mysql_format(SQL, sQuery, sizeof sQuery, "INSERT INTO players_online (playerid, ime) VALUES (%i, '%s')", playerid, playerName);
		mysql_tquery(SQL, sQuery);
	}

	// Provera da li je oboren rekord
	if (playersOnline > GetServerPlayersRecord())
	{
		new sMsg[110];
		format(sMsg, sizeof sMsg, "{FFFF00}<>{FF9900}<>{FF0000}<>  {FFFFFF}NOVI REKORD SERVERA JE: {00FF00}[%i]  {FF0000}<>{FF9900}<>{FFFF00}<>", playersOnline);
		SendClientMessageToAll(BELA, sMsg);

		new sQuery[70];
		format(sQuery, sizeof sQuery, "UPDATE server_info SET value = '%i' WHERE field = 'players_record'", playersOnline);
		mysql_tquery(SQL, sQuery);

		printf("REKORD IGRACA OBOREN: [%i]", playersOnline);

		SetServerPlayersRecord(playersOnline);
	}
	return 1;
}
stock PlayerCountDec(playerid = INVALID_PLAYER_ID)
{
	playersOnline -= 1;
	
	// Update podataka u bazi
	if (playerid != INVALID_PLAYER_ID)
	{
		new sQuery[49], playerName[MAX_PLAYER_NAME];
		GetPlayerName(playerid, playerName, sizeof playerName);
		format(sQuery, sizeof sQuery, "DELETE FROM players_online WHERE playerid = %i", playerid);
		mysql_tquery(SQL, sQuery);
	}

	return 1;
}
stock playersOnline_UpdateTD()
{
    //new str[5];
    //format(str, sizeof str, "%i", playersOnline);
    //TextDrawSetString(tdPlayerCount[3], str);
	return true;
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
