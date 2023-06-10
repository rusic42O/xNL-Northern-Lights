#include <YSI_Coding\y_hooks>

#define WD_TIMER    (0) // tdMaterialsDelivery: timer
#define WD_COUNTER  (1) // tdMaterialsDelivery: counter

new
    Text:tdEventCountdown[10],
    Text:tdWar[26],
    Text:tdWarResult[28],
    Text:tdSpec[2],
    Text:tdFurnitureHint,
    Text:tdBarrierHint,
    Text:tdRacing[4],   
    Text:tdATM[38],
    Text:tdMaterialsDelivery[2],
    Text:tdBankRobTime,
    Text:tdJewelryRobTime,
    Text:tdJewelryRobCounter,   
    Text:tdAnimHelp,
    Text:tdDMFirstBlood,
    Text:tdDMDouble,
    Text:tdDMTriple,
    Text:tdDMQuad,
    Text:tdDMPenta,
    Text:tdDMEvent[6],
    Text:tdBurglaryTip,
    Text:tdLMSEvent,
    Text:tdDeathScreen[4],
    Text:tdDeathList[3],
    Text:tdSkill[E_SKILLS],
    Text:tdMakeGun[15],
    Text:tdFactionSafe[10]
;


hook OnGameModeInit() 
{
    // Globalni
    #include global\War.inc
    #include global\WarResult.inc
    #include global\Spec.inc
    #include global\FurnitureHint.inc
    #include global\BarrierHint.inc
    #include global\Racing.inc
    #include global\ATM.inc
    #include global\SideCounters.inc
    #include global\AnimHelp.inc
    #include global\BurglaryTip.inc
    #include global\DMEvent.inc
    #include global\EventCountdown.inc
    #include global\DeathScreen.inc
    #include global\DeathList.inc
    #include global\Skill.inc
    #include global\MakeGun.inc
    #include global\FactionSafe.inc
    return 1;
}

stock UpdateAddon(const header[], const info[])
{
    #pragma unused header
    #pragma unused info
  /*  TextDrawSetString(tdInfoBoxAddon[5], header);
    TextDrawSetString(tdInfoBoxAddon[6], info);
    TextDrawSetString(tdInfoBox[91], header);
    TextDrawSetString(tdInfoBox[92], info);

    foreach(new i : Player)
    {
        if(TDSelected{i})
        {
            TextDrawHideForPlayer(i, tdInfoBox[91]);
            TextDrawHideForPlayer(i, tdInfoBox[92]);
            TextDrawHideForPlayer(i, tdInfoBoxAddon[6]);
            TextDrawHideForPlayer(i, tdInfoBoxAddon[5]);
            TextDrawShowForPlayer(i, tdInfoBoxAddon[6]);
            TextDrawShowForPlayer(i, tdInfoBoxAddon[5]);
        }
        else if(!TDSelected{i})
        {
            TextDrawHideForPlayer(i, tdInfoBoxAddon[6]);
            TextDrawHideForPlayer(i, tdInfoBoxAddon[5]);
            TextDrawHideForPlayer(i, tdInfoBox[91]);
            TextDrawHideForPlayer(i, tdInfoBox[92]);
            TextDrawShowForPlayer(i, tdInfoBox[91]);
            TextDrawShowForPlayer(i, tdInfoBox[92]);
        }
    }*/
    return 1;
}

#define PTD_SIZE_SPEC           2
#define PTD_SIZE_JOBMETER       4
#define PTD_SIZE_HUDMODERN      21
#define PTD_SIZE_ATM            5
#define PTD_SIZE_REG            17
#define PTD_SIZE_LOGIN          8
#define PTD_SIZE_INTRO          7
#define PTD_SIZE_UCP            10
#define PTD_SIZE_UCPIKONE       8
#define PTD_SIZE_UCPIMOVINA     5
#define PTD_SIZE_UCPVOZILA      12
#define PTD_SIZE_KATALOG        18
#define PTD_SIZE_AUTOSALON      82
#define PTD_SIZE_COLORS         6
#define PTD_SIZE_BUTIK          9
#define PTD_SIZE_ACCESSORIES    9
#define PTD_SIZE_KEYPAD         16
#define PTD_SIZE_PADNUM         10
#define PTD_SIZE_JOBHELP        3
#define PTD_SIZE_MARKETROB      4
#define PTD_SIZE_BURGLARY       4
#define PTD_SIZE_HITPOINTS      2
#define PTD_SIZE_INFOBOX        3
#define PTD_SIZE_SKILL          4
#define PTD_SIZE_CENTERPROGRESS 4
#define PTD_SIZE_SERVER_TIPS    7
#define PTD_SIZE_FACTION_SAFE   7

enum e_playerTextDraws
{
    PlayerText:ptdNovac,
    PlayerText:ptdSpec[PTD_SIZE_SPEC],
    PlayerText:ptdRacing,
    PlayerText:ptdJobmeter[PTD_SIZE_JOBMETER],
    PlayerText:ptdHudModern[PTD_SIZE_HUDMODERN],
    PlayerText:ptdHudModernTwo[7],
    PlayerText:ptdATM[PTD_SIZE_ATM],
    PlayerText:ptdReg[PTD_SIZE_REG],
    PlayerText:ptdLogin[PTD_SIZE_LOGIN],
    PlayerText:ptdIntro[PTD_SIZE_INTRO],
    PlayerText:ptdKatalog[PTD_SIZE_KATALOG],
    PlayerText:ptdAutosalon[PTD_SIZE_AUTOSALON],
    PlayerText:ptdColors[PTD_SIZE_COLORS],
    PlayerText:ptdGPS,
    PlayerText:ptdButik[PTD_SIZE_BUTIK],
    PlayerText:ptdAccessories[PTD_SIZE_ACCESSORIES],
    PlayerText:ptdKeypad[PTD_SIZE_KEYPAD],
    PlayerText:ptdPadNum[PTD_SIZE_PADNUM],
    PlayerText:ptdJobhelp[PTD_SIZE_JOBHELP],
    PlayerText:ptdMarketRob[PTD_SIZE_MARKETROB],
    PlayerText:ptdBurglary[PTD_SIZE_BURGLARY],
    PlayerText:ptdHitPoints[PTD_SIZE_HITPOINTS],
    PlayerText:ptdInfoBox[PTD_SIZE_INFOBOX],
    PlayerText:ptdInfoBoxTwo[PTD_SIZE_INFOBOX],
    PlayerText:ptdDMEvent,
    PlayerText:ptdSkill[PTD_SIZE_SKILL],
    PlayerText:ptdCenterProgress[PTD_SIZE_CENTERPROGRESS],    
    PlayerText:ptdServerTips[PTD_SIZE_SERVER_TIPS],
    PlayerText:ptdFactionSafe[PTD_SIZE_FACTION_SAFE],
    PlayerText:tdStaffDuty,
};
new PlayerTD[MAX_PLAYERS][e_playerTextDraws];

new PlayerText:ptdColors_Panel[MAX_PLAYERS][8][8];


#include player\pNovac.inc
#include player\pSpec.inc
#include player\pRacing.inc
#include player\pJobmeter.inc
#include player\pATM.inc
#include player\pKatalog.inc
#include player\pAutosalon.inc
#include player\pColors.inc
#include player\pButik.inc
#include player\pAccessories.inc
#include player\pKeypad.inc
#include player\pJobhelp.inc
#include player\pMarketRob.inc
#include player\pBurglary.inc
#include player\pHitPoints.inc
#include player\pDMEvent.inc
#include player\pSkill.inc
#include player\pCenterProgress.inc
#include player\pServerTips.inc
#include player\pFactionSafe.inc

#include <YSI_Coding\y_hooks>

hook OnPlayerConnect(playerid)
{
    for__loop (new i = 0; i < sizeof PlayerTD[]; i++) 
    {
        PlayerTD[playerid][e_playerTextDraws: i] = _:INVALID_TEXT_DRAW;
    }

    for__loop (new i = 0; i < 8; i++) 
    {
        for__loop (new j = 0; j < 8; j++)
            ptdColors_Panel[playerid][i][j] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}


forward ow_SelectTextDraw(playerid, hovercolor);
public ow_SelectTextDraw(playerid, hovercolor) 
{
    SetPVarInt(playerid, "owHoverColor", hovercolor);
    SetPVarInt(playerid, "owSelectTextDraw", 1);
    DeletePVar(playerid, "owRestoreSelectTextDraw");

    return SelectTextDraw(playerid, hovercolor);
}

forward ow_CancelSelectTextDraw(playerid);
public ow_CancelSelectTextDraw(playerid) 
{
    DeletePVar(playerid, "owHoverColor");
    DeletePVar(playerid, "owSelectTextDraw");
    DeletePVar(playerid, "owRestoreSelectTextDraw");

    return CancelSelectTextDraw(playerid);
}

// SelectTextDraw
#if defined _ALS_SelectTextDraw
    #undef SelectTextDraw
#else
    #define _ALS_SelectTextDraw
#endif
#define SelectTextDraw ow_SelectTextDraw

// CancelSelectTextDraw
#if defined _ALS_CancelSelectTextDraw
    #undef CancelSelectTextDraw
#else
    #define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw ow_CancelSelectTextDraw