/*
    Nakon preuzimanja skripte zapazio sam ovaj sistem u modu. Licno bi me bilo stid ubacivati fake igrace (botove)
    da bih na taj nacin nastojao "pogurati" svoj server naprijed. Dosta prije nego je Necro kupio zajednicu i ja (daddyDOT)
    postao skripter, jedan od admina je priznao da su ubacivali botove. Ono sto su postigli time jeste da su server oborili na 0 igraca.
    Necro i ostali clanovi trenutnog staff tima (29/04 -- ...) su odlucni u namjeri da se ovo ne koristi nikada u svrhe promoviranja servera
    već striktno testiranja kapaciteta masine koji se, barem se nadam, neće desiti a i ne bi trebao. Ja, daddyDOT, ovom porukom sastavljenom
    08/05/2021 godine garantujem da botovi na glavni server nikada neće ući. Brojku igraca postići ćemo svojim radom i trudom a ne laznim igracima!
*/

#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_FAKEPLAYER_INFO
{
    FP_IME[MAX_PLAYER_NAME],
    FP_NIVO,
    FP_EXP
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pFakePlayer[MAX_PLAYERS];
    // tajmer:FAKEPLAYERS_changePos[MAX_PLAYERS];

new FakePlayer[][E_FAKEPLAYER_INFO] =
{
	{"NONE", 0, 0}
};
// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    //SetTimer("FAKEPLAYERS_Payday", 60*60*1000, true);
    return true;
}

hook OnPlayerConnect(playerid)
{
	/*pFakePlayer[playerid] = -1;

	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof playerName);
	for__loop (new i = 0; i < sizeof FakePlayer; i++)
	{
		if (!strcmp(playerName, FakePlayer[i][FP_IME]))
		{
			pFakePlayer[playerid] = i;

            // Login
            new query[72];
            format(query, sizeof query, "SELECT nivo, iskustvo FROM fakeplayers WHERE ime = '%s'", playerName);
            mysql_tquery(SQL, query, "FAKEPLAYERS_Login", "ii", playerid, cinc[playerid]);
			break;
		}
	}*/
	return 1;
}

hook OnPlayerSpawn(playerid)
{
    if (IsFakePlayer(playerid))
    {
        SetPlayerVirtualWorld(playerid, playerid+100);
    }
}

// hook OnPlayerDisconnect(playerid, reason)
// {
//     if (IsFakePlayer(playerid))
//     {
//         KillTimer(tajmer:FAKEPLAYERS_payday[playerid]);
//     }
// }




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsFakePlayer(playerid)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS) return false;
     
	if (pFakePlayer[playerid] == -1)
        return false;

    else return true;
}

stock IsFakePlayerIP(const test_ip[])
{
    new ip[16];
    foreach (new i : Player)
    {
        if (IsFakePlayer(i))
        {
            GetPlayerIp(i, ip, sizeof ip);
            if (!strcmp(test_ip, ip))
            {
                return 1;
            }
        }
    }
    return 0;
}

stock GetFakePlayerID(playerid)
{
    return pFakePlayer[playerid];
}

forward FAKEPLAYERS_Payday();
public FAKEPLAYERS_Payday()
{
    foreach (new i : Player)
    {
        if (IsFakePlayer(i))
        {
            new fid = GetFakePlayerID(i);
            FakePlayer[fid][FP_EXP] += 1;

            new nexLevelExp = FakePlayer[fid][FP_NIVO] * 5 + 5;

            if (FakePlayer[fid][FP_EXP] >= nexLevelExp) // Level up
            {
                FakePlayer[fid][FP_NIVO]++;
                FakePlayer[fid][FP_EXP] = 0;
                SetPlayerScore(i, FakePlayer[fid][FP_NIVO]);

                PI[i][p_nivo] = FakePlayer[fid][FP_NIVO];
            }


            new query[100];
            format(query, sizeof query, "UPDATE fakeplayers SET nivo = %i, iskustvo = %i WHERE ime = '%s'", FakePlayer[fid][FP_NIVO], FakePlayer[fid][FP_EXP], FakePlayer[fid][FP_IME]);
            mysql_tquery(SQL, query);
        }
    }
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward FAKEPLAYERS_Pucina(playerid, cinca);
public FAKEPLAYERS_Pucina(playerid, cinca)
{
    print("successful");
    return 1;
}

forward FAKEPLAYERS_Login(playerid, ccinc);
public FAKEPLAYERS_Login(playerid, ccinc)
{
    cache_get_row_count(rows);
    if (rows && IsFakePlayer(playerid))
    {
        new fid = GetFakePlayerID(playerid);
        cache_get_value_name_int(0, "nivo", FakePlayer[fid][FP_NIVO]);
        cache_get_value_name_int(0, "iskustvo", FakePlayer[fid][FP_EXP]);
        SetPlayerScore(playerid, FakePlayer[fid][FP_NIVO]);

        PI[playerid][p_nivo] = FakePlayer[fid][FP_NIVO];

        GetPlayerName(playerid, ime_rp[playerid], MAX_PLAYER_NAME);
        for__loop (new i = 0; i < strlen(ime_rp[playerid]); i++) 
        {
            if (ime_rp[playerid][i] == '_') 
            {
                ime_rp[playerid][i] = ' ';
                break;
            }
        }
    }
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
