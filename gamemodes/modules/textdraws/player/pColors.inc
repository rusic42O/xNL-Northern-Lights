#include <YSI_Coding\y_hooks>
// Credits: Drebin
// http://forum.sa-mp.com/showthread.php?p=2518564


//Offsets used to calculate the spacing between each of the colors used in the dialog + offsets for cursor movements
#define OFFSET_COL_X        25.6 //The distance from "2" to "1" on the X axis. Y axis level doesn't change (they have an identical X axis value)
#define OFFSET_ROW_Y        24.0 //The distance from "3" to "1" on the Y axis. X axis level doesn't change (they have an identical Y axis value)
#define OFFSET_INDICATOR_X  25.6 //The X value the dialog cursor has to be moved on the X axis to get to the next color (Y value doesn't change when moving horizontally)
#define OFFSET_INDICATOR_Y  24.0 //The Y value the dialog cursor has to be moved on the Y axis to get to the next color (X value doesn't change when moving vertically)

new panelColorsHex[32][8]= 
{
    {0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF}, 
    {0xBDBEC6FF, 0x5E7072FF, 0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF}, 
    {0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF, 0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF}, 
    {0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF, 0x421F21FF, 0x5F272BFF}, 
    {0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF},
    {0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF}, 
    {0x989586FF, 0xADB0B0FF, 0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF}, 
    {0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF, 0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF}, 
    {0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF, 0x851F2EFF, 0x6F8297FF}, 
    {0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF},
    {0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF}, 
    {0x6D2837FF, 0xA7A28FFF, 0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF}, 
    {0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF, 0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF}, 
    {0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF, 0x7F6956FF, 0x8C929AFF}, 
    {0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF},
    {0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF},
    {0x177517FF, 0x210606FF, 0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF},
    {0x8A4DBDFF, 0x35963AFF, 0xB7B7B7FF, 0x464C8DFF, 0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF}, 
    {0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF, 0x1E1D13FF, 0x1E1306FF, 0x1F2518FF, 0x2C4531FF},
    {0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF, 0x992E1EFF, 0x2C1E08FF},
    {0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF},
    {0x481A0EFF, 0x7A7399FF, 0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF},
    {0x8D4C8DFF, 0x805B80FF, 0x7B3E7EFF, 0x3C1737FF, 0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF},
    {0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF, 0x163012FF, 0x16301BFF, 0x642B4FFF, 0x368452FF},
    {0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF, 0x2B3C99FF, 0x3A3A0BFF}, 
    {0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF},
    {0x2C5089FF, 0x15426CFF, 0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF}, 
    {0x8C573AFF, 0x52888EFF, 0x995C52FF, 0x99581EFF, 0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF},
    {0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF, 0x96821DFF, 0x197F19FF, 0x3B141FFF, 0x745217FF},
    {0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF, 0x8A653AFF, 0x732617FF}, 
    {0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF},
    {0x561A28FF, 0x4E0E27FF, 0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF}
};

new panelColorsID[32][8] = //Vehicle color IDs shown in the dialog sorted by row and column
{
    {0,     1,      2,      3,      4,      5,      6,      7},
    {8,     9,      10,     11,     12,     13,     14,     15},
    {16,    17,     18,     19,     20,     21,     22,     23},
    {24,    25,     26,     27,     28,     29,     30,     31},
    {32,    33,     34,     35,     36,     37,     38,     39},
    {40,    41,     42,     43,     44,     45,     46,     47},
    {48,    49,     50,     51,     52,     53,     54,     55},
    {56,    57,     58,     59,     60,     61,     62,     63},   
    {64,    65,     66,     67,     68,     69,     70,     71},   
    {72,    73,     74,     75,     76,     77,     78,     79},   
    {80,    81,     82,     83,     84,     85,     76,     87},   
    {88,    89,     90,     91,     92,     93,     94,     95},   
    {96,    97,     98,     99,     100,    101,    102,    103},   
    {104,   105,    106,    107,    108,    109,    110,    111},   
    {112,   113,    114,    115,    116,    117,    118,    119},   
    {120,   121,    122,    123,    124,    125,    126,    127},
    {128,   129,    130,    131,    132,    133,    134,    135},
    {136,   137,    138,    139,    140,    141,    142,    143},
    {144,   145,    146,    147,    148,    149,    150,    151},
    {152,   153,    154,    155,    156,    157,    158,    159},
    {160,   161,    162,    163,    164,    165,    166,    167},
    {168,   169,    170,    171,    172,    173,    174,    175},
    {176,   177,    178,    179,    180,    181,    182,    183},
    {184,   185,    186,    187,    188,    189,    190,    191},   
    {192,   193,    194,    195,    196,    197,    198,    199},   
    {200,   201,    202,    203,    204,    205,    206,    207},   
    {208,   209,    210,    211,    212,    213,    214,    215},   
    {216,   217,    218,    219,    220,    221,    222,    223},   
    {224,   225,    226,    227,    228,    229,    230,    231},   
    {232,   233,    234,    235,    236,    237,    238,    239},   
    {240,   241,    242,    243,    244,    245,    246,    247},   
    {248,   249,    250,    251,    252,    253,    254,    255}      
};


// ptd_box[playerid] --> PlayerTD[playerid][ptdColors][0]
// ptd_indicator[playerid] --> PlayerTD[playerid][ptdColors][1]
// ptd_panel --> ptdColors_Panel
ptdColors_Create(playerid, page = 1) 
{
    PlayerTD[playerid][ptdColors][0] = CreatePlayerTextDraw(playerid, 117.0, 102.0, "_");
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][0], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][0], 0.5, 20.900007);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][0], 1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdColors][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdColors][0], 0x00000078);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][0], 2.0, 201.0);
    
    PlayerTD[playerid][ptdColors][1] = CreatePlayerTextDraw(playerid, 27.000000, 102.000000, "_");
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][1], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][1], 0.500000, 2.199999);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][1], 1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdColors][1], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdColors][1], 0xFFFFFFFF);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][1], 0.000000, 21.000000);

    PlayerTD[playerid][ptdColors][2] = CreatePlayerTextDraw(playerid, 170.666366, 297.022125, "Napred ~>~");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][2], 0.273666, 1.500444);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][2], 219.000000, 25.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdColors][2], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdColors][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdColors][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdColors][2], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][2], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdColors][2], true);

    PlayerTD[playerid][ptdColors][3] = CreatePlayerTextDraw(playerid, 15.000000, 297.022125, "~<~ Nazad");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][3], 0.273666, 1.500444);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][3], 65.000000, 25.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdColors][3], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdColors][3], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdColors][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdColors][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][3], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdColors][3], true);

    PlayerTD[playerid][ptdColors][4] = CreatePlayerTextDraw(playerid, 81.333351, 296.566589, " IZABERI");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][4], 0.321666, 1.633185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][4], 143.000000, 30.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdColors][4], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdColors][4], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdColors][4], 393549823);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdColors][4], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdColors][4], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdColors][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdColors][4], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][4], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdColors][4], true);

    PlayerTD[playerid][ptdColors][5] = CreatePlayerTextDraw(playerid, 214.499938, 91.603721, "X");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][5], 0.400000, 1.600000);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][5], 224.000000, 12.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdColors][5], -16776961);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdColors][5], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdColors][5], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdColors][5], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdColors][5], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][5], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdColors][5], true);

    ptdColors_CreatePanel(playerid, page);
    return 1;
}

ptdColors_CreatePanel(playerid, page) 
{
    new rowOffset = (page-1)*8;
    for__loop (new row = 0; row < 8; row++) 
    {
        for__loop (new col = 0; col < 8; col++) 
        {
            ptdColors_Panel[playerid][row][col] = CreatePlayerTextDraw(playerid, 27.0 + (col * OFFSET_COL_X), 105.0 + (row * OFFSET_ROW_Y), "_");
            PlayerTextDrawAlignment(playerid, ptdColors_Panel[playerid][row][col], 2);
            PlayerTextDrawLetterSize(playerid, ptdColors_Panel[playerid][row][col], 0.5, 1.5);
            PlayerTextDrawSetProportional(playerid, ptdColors_Panel[playerid][row][col], 1);
            PlayerTextDrawUseBox(playerid, ptdColors_Panel[playerid][row][col], 1);
            PlayerTextDrawBoxColor(playerid, ptdColors_Panel[playerid][row][col], panelColorsHex[row+rowOffset][col]);
            PlayerTextDrawTextSize(playerid, ptdColors_Panel[playerid][row][col], 15.00, 15.0);
            PlayerTextDrawSetSelectable(playerid, ptdColors_Panel[playerid][row][col], true);
        }
    }

    SetPVarInt(playerid, "pColors_Page", page);
    return 1;
}

ptdColors_Destroy(playerid)
{
    for (new i = 0; i < PTD_SIZE_COLORS; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdColors][i]);
        PlayerTD[playerid][ptdColors][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    ptdColors_DestroyPanel(playerid);
    DeletePVar(playerid, "pColors_Page");
    DeletePVar(playerid, "pColors_SelectedColorID");
    DeletePVar(playerid, "pColors_SelectedColorHex");
    return 1;
}

ptdColors_DestroyPanel(playerid)
{
    for__loop (new i = 0; i < 8; i++) 
    {
        for__loop (new k = 0; k < 8; k++) 
        {
            PlayerTextDrawDestroy(playerid, ptdColors_Panel[playerid][i][k]);
            ptdColors_Panel[playerid][i][k] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    CancelSelectTextDraw(playerid);
    return 1;
}

ptdColors_Show(playerid) 
{
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][0]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][1]);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][5]);
    if (GetPVarInt(playerid, "pColors_Page") <= 1) // Prethodna strana; prikazi/sakrij
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdColors][3]);
    else
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][3]);

    if (GetPVarInt(playerid, "pColors_Page") < 4) // Sledeca strana; prikazi/sakrij
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][2]);
    else
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdColors][2]);

    for__loop (new i = 0; i < 8; i++) //Loop through every row
    {
        for__loop (new k = 0; k < 8; k++) //Loop through every column
            PlayerTextDrawShow(playerid, ptdColors_Panel[playerid][i][k]); //Show the textdraw
    }
    SelectTextDraw(playerid, 0xF2E4AEFF);
    return 1;
}

stock ptdColors_Hide(playerid) 
{
    for (new i = 0; i < PTD_SIZE_COLORS; i++)
        PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdColors][i]);

    for__loop (new i = 0; i < 8; i++) //Loop through every row
    {
        for__loop (new k = 0; k < 8; k++) //Loop through every column
            PlayerTextDrawHide(playerid, ptdColors_Panel[playerid][i][k]); //Hide the textdraw
    }
    CancelSelectTextDraw(playerid);
    return 1;
}

stock GetColorIDFromPosition(playerid, column, row) 
{
    new page = GetPVarInt(playerid, "pColors_Page");
    return panelColorsID[row + (page-1)*8][column];
}

stock GetColorHexFromPosition(playerid, column, row) 
{
    new page = GetPVarInt(playerid, "pColors_Page");
    return panelColorsHex[row + (page-1)*8][column];
}

stock SetPaintTDIndicatorPos(playerid, column, row) { //Set the exact position of the cursor

    PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdColors][1]);
    PlayerTD[playerid][ptdColors][1] = CreatePlayerTextDraw(playerid, 27.000000 + (column * OFFSET_INDICATOR_X), 102.000000 + (row * OFFSET_INDICATOR_Y), "_");
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdColors][1], 2);
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdColors][1], 0.500000, 2.199999);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdColors][1], 1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdColors][1], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdColors][1], 0xFFFFFFFF);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdColors][1], 0.000000, 21.000000);
    
    new rowOffset = (GetPVarInt(playerid, "pColors_Page")-1)*8;
    PlayerTextDrawDestroy(playerid, ptdColors_Panel[playerid][row][column]);
    ptdColors_Panel[playerid][row][column] = CreatePlayerTextDraw(playerid, 27.0 + (column * OFFSET_COL_X), 105.0 + (row * OFFSET_ROW_Y), "_");
    PlayerTextDrawAlignment(playerid, ptdColors_Panel[playerid][row][column], 2);
    PlayerTextDrawLetterSize(playerid, ptdColors_Panel[playerid][row][column], 0.5, 1.5);
    PlayerTextDrawSetProportional(playerid, ptdColors_Panel[playerid][row][column], 1);
    PlayerTextDrawUseBox(playerid, ptdColors_Panel[playerid][row][column], 1);
    PlayerTextDrawBoxColor(playerid, ptdColors_Panel[playerid][row][column], panelColorsHex[row + rowOffset][column]);
    PlayerTextDrawTextSize(playerid, ptdColors_Panel[playerid][row][column], 15.00, 15.0);
    PlayerTextDrawSetSelectable(playerid, ptdColors_Panel[playerid][row][column], true);
    
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][1]);
    PlayerTextDrawShow(playerid, ptdColors_Panel[playerid][row][column]);
    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (GetPVarInt(playerid, "pColors_Page") != 0) 
    {
        if (playertextid == PlayerTD[playerid][ptdColors][2]) // Sledeca strana
        {
            ptdColors_DestroyPanel(playerid);
            ptdColors_CreatePanel(playerid, GetPVarInt(playerid, "pColors_Page")+1);
            ptdColors_Show(playerid);
            return ~1;
        }

        if (playertextid == PlayerTD[playerid][ptdColors][3]) // Prethodna strana
        {
            ptdColors_DestroyPanel(playerid);
            ptdColors_CreatePanel(playerid, GetPVarInt(playerid, "pColors_Page")-1);
            ptdColors_Show(playerid);
            return ~1;
        }

        if (playertextid == PlayerTD[playerid][ptdColors][4]) // Izaberi/kupi
        {
            CallRemoteFunction("OnPlayerBuyColor", "iii", playerid, GetPVarInt(playerid, "pColors_SelectedColorHex"), GetPVarInt(playerid, "pColors_SelectedColorID")); 
            return ~1;
        }

        for__loop (new row = 0; row < 8; row++) 
        {
            for__loop (new col = 0; col < 8; col++) 
            {
                if (playertextid == ptdColors_Panel[playerid][row][col]) 
                {
                    SetPaintTDIndicatorPos(playerid, col, row);
                    CallRemoteFunction("OnPlayerSelectColor", "iii", playerid, GetColorHexFromPosition(playerid, col, row), GetColorIDFromPosition(playerid, col, row)); 
                    return ~1;
                }
            }
        }

        if (playertextid == PlayerTD[playerid][ptdColors][5]) // Izlaz
        {
            CallRemoteFunction("OnPlayerExitColorMenu", "i", playerid);
            return ~1;
        }
    }
    return 0;
}


forward OnPlayerSelectColor(playerid, hex, colorid); 
public OnPlayerSelectColor(playerid, hex, colorid) 
{    
    SetPVarInt(playerid, "pColors_SelectedColorID", colorid);
    SetPVarInt(playerid, "pColors_SelectedColorHex", hex);

    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdColors][4], hex);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdColors][4], true);
    PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdColors][4]);
    return 1;
}

forward OnPlayerBuyColor(playerid, hex, colorid);
public OnPlayerBuyColor(playerid, hex, colorid) 
{ 
    return 1;
}

forward OnPlayerExitColorMenu(playerid);
public OnPlayerExitColorMenu(playerid) 
{
    ptdColors_Destroy(playerid);
    ptdColors_Create(playerid);
    return 1;
}