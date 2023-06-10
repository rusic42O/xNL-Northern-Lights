#include <YSI_Coding\y_hooks>

new minsLeft, tajmer:autorestart, autorestart_cdown;

hook OnGameModeInit()
{
	SetTimer("AutoRestartChecker", 50*60*1000, true);
	return true;
}

forward AutoRestartChecker();
public AutoRestartChecker()
{
	new h, m, s;
	gettime(h, m, s);

	if ((h == 5 && m >= 30) || h == 6 && m < 25)
	{
		// Ima izmedju 5.30 i 6.25 ujutru, restartovati server ako je zakazano

        if (IsServerRestartScheduled())
        {
    		minsLeft = 4;
    		tajmer:autorestart = SetTimer("AutoRestartNotif", 60*1000, true);
        }
	}
	return 1;
}

forward AutoRestartNotif();
public AutoRestartNotif()
{
	minsLeft -= 1;

	new string[91];
	format(string, sizeof string, "OBAVESTENJE | {FFFFFF}Server ce automatski biti restartovan za {FF0000}%i {FFFFFF}minuta.", minsLeft);
	SendClientMessageToAll(CRVENA, string);

	if (minsLeft == 0)
	{
		KillTimer(tajmer:autorestart);
		RestartServer(10);
	}
	return 1;
}

forward AutoRestartCountdown();
public AutoRestartCountdown()
{
	autorestart_cdown -= 1;
	new str[22];
	format(str, sizeof str, "~r~RESTART ZA ~W~%i", autorestart_cdown);
	GameTextForAll(str, 1000, 3);

	if (autorestart_cdown <= 0)
	{
		KillTimer(tajmer:autorestart);
		SendRconCommand("gmx");	
	}
	return 1;
}

stock RestartServer(time)
{
   autorestart_cdown = time + 1;
   tajmer:autorestart = SetTimer("AutoRestartCountdown", 1000, true);
}