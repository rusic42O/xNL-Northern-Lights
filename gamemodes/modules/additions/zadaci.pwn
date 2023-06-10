#include <YSI_Coding\y_hooks>

#define MAX_TASKS 4

enum E_PLAYER_TASKS
{
	g_TaskName[20 + 1],
    g_TaskDesc[40 + 1],
    g_TaskPrize
}

new
    Iterator:PlayerFinishedTasks[MAX_PLAYERS]<MAX_TASKS>, // uzima sve IDeve zadataka koje je igrac uradio
    g_TaskCP[MAX_PLAYERS]
;

new TaskInfo[MAX_TASKS][E_PLAYER_TASKS] = {
    {"Izvadi pasos", "Idite u opstinu i izvadite pasos!", 100}, // id 0
    {"Polozi vozacki", "Uspjesno polozite za B kategoriju!", 200}, // id 1
    {"Zaposli se", "Pronadjite posao koji vam odgovara!", 250}, // id 2
    {"Rentaj vozilo", "Iznajmite neko od vozila iz rent firme!", 153} // bubam cijene, neće biti ovakve :P
};

hook OnPlayerConnect(playerid)
{
    g_TaskCP[playerid] = -1;
    return Y_HOOKS_CONTINUE_RETURN_1;
}

SetTasksVars(playerid, const tstr[])
{
    new
        t_Tasks[MAX_TASKS]
    ;

    sscanf(tstr, "p<|>dddd", t_Tasks[0], t_Tasks[1], t_Tasks[2], t_Tasks[3]);

    for(new i = 0; i < MAX_TASKS; i++)
    {
        if(t_Tasks[i] == 1) // provjerava ako je zavrsen i baca ga u iterator
            Iter_Add(PlayerFinishedTasks[playerid], i);
    }
}

hook OnPlayerDisconnect(playerid, reason)
{
    Iter_Clear(PlayerFinishedTasks[playerid]); // cisti iterator kad se disconnectuje
    
    return Y_HOOKS_CONTINUE_RETURN_1;
}

/*alias:tasks("zadaci")
CMD:tasks(const playerid)
{
    if(IsPlayerJailed(playerid) || IsPlayerInWar(playerid) || IsPlayerInRace(playerid) || IsPlayerInDMEvent(playerid))
        return 1;
    
    new
        str[20 + 8 + 1],
        strdialog[31 + 75 * MAX_TASKS]
    ;

    // Header za dijalog
    format(strdialog, sizeof strdialog, "Zadatak\tDeskripcija\tNagrada");

    // Listanje zadataka
    for(new i = 0; i < MAX_TASKS; i++)
    {
        if(Iter_Contains(PlayerFinishedTasks[playerid], i))
            format(str, sizeof str, "{03fc5a}%s", TaskInfo[i][g_TaskName]); // Igrac uradio taj zadatak (zelena boja)

        else
            format(str, sizeof str, "{ff293e}%s", TaskInfo[i][g_TaskName]); // Igrac nije uradio taj zadatak (crvena boja)

        format(strdialog, sizeof strdialog, "%s\n%s\t%s\t$%i", strdialog, str, TaskInfo[i][g_TaskDesc], TaskInfo[i][g_TaskPrize]);
    }

    SPD(playerid, "DialogueTasks", DIALOG_STYLE_TABLIST_HEADERS, "Northern Lights // Zadaci", strdialog, "Odaberi", "Otkazi");
    return 1;
}*/

Dialog:DialogueTasks(playerid, response, listitem, const inputtext[])
{
    if(!response)
        return 1;
    
    if(Iter_Contains(PlayerFinishedTasks[playerid], listitem))
        return ErrorMsg(playerid, "Vec ste uradili taj zadatak.");

    switch(listitem)
    {
        case 3:
        {
            g_TaskCP[playerid] = CreatePlayerCP(1242.5287,-1352.5763,13.2562, 5.0, -1, -1, playerid, 300.0);
            InfoMsg(playerid, "Idite do naznacenog mjesta i iznajmite vozilo.");
        }
    }
    return 1;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == g_TaskCP[playerid])
    {
        DestroyPlayerCP(g_TaskCP[playerid], playerid);
        DisablePlayerCheckpoint(playerid);
    }
    return Y_HOOKS_CONTINUE_RETURN_1;
}

stock HasPlayerFinishedTask(playerid, taskid)
{
    if(Iter_Contains(PlayerFinishedTasks[playerid], taskid))
        return 1;
    
    return 0;
}

stock PlayerFinishedTask(playerid, taskid)
{
    Iter_Add(PlayerFinishedTasks[playerid], taskid);
    CallLocalFunction("OnPlayerFinishTask", "ii", playerid, taskid);
}

forward OnPlayerFinishTask(playerid, taskid);
public OnPlayerFinishTask(playerid, taskid)
{
    static
        str[47+1]
    ;
    format(str, sizeof str, "~g~Uspjesno ~w~ste zavrsili zadatak~n~+~g~$%i", TaskInfo[taskid][g_TaskPrize]);
    GameTextForPlayer(playerid, str, 5000, 3);
    PlayerPlaySound(playerid, 183, 0.0, 0.0, 0.0);
    SetTimerEx("ResetSound", 9000, false, "i", playerid);
    SendClientMessageF(playerid, ZLATNA, "(zadaci) Uspjesno ste zavrsili zadatak '{FFFFFF}%s{FFFF80}' i zaradili {FFFFFF}$%i{FFFF80}.", TaskInfo[taskid][g_TaskName], TaskInfo[taskid][g_TaskPrize]);
    
    new
        tempvar[MAX_TASKS],
        infostr[23]
    ;

    for(new i = 0; i < MAX_TASKS; i++)
    {
        if(Iter_Contains(PlayerFinishedTasks[playerid], i))
            tempvar[i] = 1;
        
        else
            tempvar[i] = 0;
    }
    format(infostr, sizeof infostr, "%i|%i|%i|%i", tempvar[0], tempvar[1], tempvar[2], tempvar[3]);
    format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET Zadaci='%s' WHERE id=%d", infostr, PI[playerid][p_id]);
    mysql_tquery(SQL, mysql_upit);
    
    return true;
}

forward ResetSound(playerid);
public ResetSound(playerid)
{
    PlayerPlaySound(playerid, 0, 0.0, 0.0, 0.0);
    return 1;
}