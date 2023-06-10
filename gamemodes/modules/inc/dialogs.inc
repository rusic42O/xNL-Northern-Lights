// #define _dialogs_DEBUG

#define MAX_DIALOG_FUNCTION_SIZE	32
#define MAX_DIALOG_CAPTION_SIZE		64
#define MAX_DIALOG_INFO_SIZE        2048
#define MAX_DIALOG_BUTTON_SIZE		32
#define DIALOG_SECRET_CODE          801


stock SPD(playerid, const function[], style, const caption[], const info[], const button1[], const button2[])
{
    new caption_[MAX_DIALOG_CAPTION_SIZE];
    
    if (isnull(caption))
        strmid(caption_, "Dialog", 0, strlen("Dialog"), MAX_DIALOG_CAPTION_SIZE);
    else
        strmid(caption_, caption, 0, strlen(caption), MAX_DIALOG_CAPTION_SIZE);

    SetPVarInt(playerid, "_dialog_IsShown", 1);
    SetPVarInt(playerid, "_dialog_Style", style);
    SetPVarString(playerid, "_dialog_Function", function);
    SetPVarString(playerid, "_dialog_Caption", caption_);
    SetPVarString(playerid, "_dialog_Info", info);
    SetPVarString(playerid, "_dialog_Button1", button1);
    SetPVarString(playerid, "_dialog_Button2", button2);

    // Izbacivanje iz SelectTextDraw moda
    if (GetPVarInt(playerid, "owSelectTextDraw") == 1)
    {
        CancelSelectTextDraw(playerid);
        SetPVarInt(playerid, "owRestoreSelectTextDraw", 1);
    }

    // if (DebugDialogs())
    // {
    //     LogDialogShow(playerid, function);
    // }

    return ShowPlayerDialog(playerid, DIALOG_SECRET_CODE + playerid, style, caption_, info, button1, button2);
}

/**
 * Reshow the last dalog
 */
stock DialogReopen(playerid)
{
    new
        _function[MAX_DIALOG_FUNCTION_SIZE],
        _caption[MAX_DIALOG_CAPTION_SIZE],
        _info[MAX_DIALOG_INFO_SIZE],
        _button1[MAX_DIALOG_BUTTON_SIZE],
        _button2[MAX_DIALOG_BUTTON_SIZE],
        _style = GetPVarInt(playerid, "_dialog_Style");

    GetPVarString(playerid, "_dialog_Function", _function,  sizeof(_function));
    GetPVarString(playerid, "_dialog_Caption",  _caption,   sizeof(_caption));
    GetPVarString(playerid, "_dialog_Info",     _info,      sizeof(_info));
    GetPVarString(playerid, "_dialog_Button1",  _button1,   sizeof(_button1));
    GetPVarString(playerid, "_dialog_Button2",  _button2,   sizeof(_button2));

    SetPVarInt(playerid, "_dialog_IsShown", 1);
	return SPD(playerid, _function, _style, _caption, _info, _button1, _button2);
}

/**
 * Reshow the last dalog but with a different parameters
 */
stock dialog_reopen_ex(playerid, function[MAX_DIALOG_FUNCTION_SIZE] = '\0', style = -1, caption[MAX_DIALOG_CAPTION_SIZE] = '\0', info[MAX_DIALOG_INFO_SIZE] = '\0', button1[MAX_DIALOG_BUTTON_SIZE] = '\0', button2[MAX_DIALOG_BUTTON_SIZE] = '\0')
{
    if (function[0] != '\0') 
        SetPVarString(playerid, "_dialog_Function", function);
    
    if (style != -1) 
        SetPVarInt(playerid, "_dialog_Style", style);

    if (info[0] != '\0') 
        SetPVarString(playerid, "_dialog_Info", info);

    if (caption[0] != '\0')
       SetPVarString(playerid, "_dialog_Caption", caption);

    if (button1[0] != '\0')
        SetPVarString(playerid, "_dialog_Button1", button1);

    if (button2[0] != '\0')
        SetPVarString(playerid, "_dialog_Button2", button2);
    
    new
        _function[MAX_DIALOG_FUNCTION_SIZE],
        _caption[MAX_DIALOG_CAPTION_SIZE],
        _info[MAX_DIALOG_INFO_SIZE],
        _button1[MAX_DIALOG_BUTTON_SIZE],
        _button2[MAX_DIALOG_BUTTON_SIZE],
        _style = GetPVarInt(playerid, "_dialog_Style");

    GetPVarString(playerid, "_dialog_Function", _function, sizeof(_function));
    GetPVarString(playerid, "_dialog_Caption",  _function, sizeof(_caption));
    GetPVarString(playerid, "_dialog_Info",     _function, sizeof(_info));
    GetPVarString(playerid, "_dialog_Button1",  _function, sizeof(_button1));
    GetPVarString(playerid, "_dialog_Button2",  _function, sizeof(_button2));

    SetPVarInt(playerid, "_dialog_IsShown", 1);
    SPD(playerid, _function, _style, _caption, _info, _button1, _button2);
	return 1;
}

stock HidePlayerDialogNew(playerid)
{
    SetPVarInt(playerid, "_dialog_IsShown", 0);

    if (GetPVarInt(playerid, "owRestoreSelectTextDraw") == 1)
    {
        SelectTextDraw(playerid, GetPVarInt(playerid, "owHoverColor"));
    }
    return ShowPlayerDialog(playerid, -1, DIALOG_STYLE_MSGBOX, "Close", "Close", "Close", "");
}

/**
 * dialog:login(playerid, response, listitem, const inputtext[])
 * Dialog callback
 */
#define dialog:%1(%2) \
	forward d_%1(%2); \
	public d_%1(%2)
#define Dialog:%1(%2) \
    forward d_%1(%2); \
    public d_%1(%2)
	
/**
 * dialog_respond:login(playerid, response, listitem, const inputtext[])
 * Calls a dialog response, doesn't show the dialog
 */
#define dialog_respond:%0(%1,%2,%3,%4) \
	d_%0(%1, %2, %3, %4)

/**
  * Checks if a player has a dialog shown on their screen
  */
#define IsDialogShownToPlayer(%0) \
    GetPVarInt(%0, "_dialog_IsShown")

stock GetLastDialogShownToPlayer(playerid) 
{
    new dialogName[MAX_DIALOG_FUNCTION_SIZE];
    GetPVarString(playerid, "_dialog_Function", dialogName, sizeof(dialogName));
    return dialogName;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (!IsDialogShownToPlayer(playerid)) return 1;
    SetPVarInt(playerid, "_dialog_IsShown", 0);

    if (dialogid != (DIALOG_SECRET_CODE+playerid))
    {
        return 1;
    }

    if (!isnull(inputtext))
    {
        for(new i = 0, j = strlen(inputtext); i < j; i++)
        {
            if(inputtext[i] == '%') inputtext[i] = '#';
        }
    }

    new dFunction[MAX_DIALOG_FUNCTION_SIZE];
    GetPVarString(playerid, "_dialog_Function", dFunction, sizeof(dFunction));

    new inputtextShortened[128];
    format(inputtextShortened, sizeof inputtextShortened, "%s", inputtext);

    // if (DebugDialogs())
    // {
    //     LogDialogResponse(playerid, dFunction, response, listitem, "d");
    // }

	#if defined _dialogs_DEBUG
        new 
            string[200],
            name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, MAX_PLAYER_NAME);

        format(string, sizeof(string), "OnDialogResponse(%d, %d, %d, %d, %s)", playerid, dialogid, response, listitem, inputtextShortened);
        print(string);

        format(string, sizeof(string), "-- %s | %s | input: %s", name, dFunction, inputtextShortened);
        Log_Write("Logovi/Dialozi.txt", string);
	#endif
	
	new sz[31];
	format(sz, sizeof sz, "d_%s", dFunction);

	#if defined _dialogs_DEBUG
	   printf("Player Function: %s - Will be called: %s", dFunction, sz);
	#endif

    if (GetPVarInt(playerid, "owRestoreSelectTextDraw") == 1)
    {
        SelectTextDraw(playerid, GetPVarInt(playerid, "owHoverColor"));
    }
	
	return CallLocalFunction(sz, "iiis", playerid, response, listitem, (inputtextShortened[0] == '\0') ? ("\1") : (inputtextShortened));
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse dialogs_OnDialogResponse
forward dialogs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
