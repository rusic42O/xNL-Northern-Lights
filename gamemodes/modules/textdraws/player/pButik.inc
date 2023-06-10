#include <YSI_Coding\y_hooks>

new pSkinIDs[MAX_PLAYERS][10];
new pSkinPrices[MAX_PLAYERS][10];

ptdButik_Create(playerid) 
{
    PlayerTD[playerid][ptdButik][0] = CreatePlayerTextDraw(playerid, 115.333290, 259.273956, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][0], 0.000000, 10.380664);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][0], 244.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdButik][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdButik][0], 141);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][0], 1);

    PlayerTD[playerid][ptdButik][1] = CreatePlayerTextDraw(playerid, 210.666625, 269.681549, "LD_BEAT:RIGHT");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][1], 29.000000, 33.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][1], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][1], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][1], 4);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][1], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdButik][1], true);

    PlayerTD[playerid][ptdButik][2] = CreatePlayerTextDraw(playerid, 120.666595, 269.681549, "LD_BEAT:left");
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][2], 29.000000, 33.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][2], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][2], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][2], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][2], 4);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][2], 0);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdButik][2], true);

    PlayerTD[playerid][ptdButik][3] = CreatePlayerTextDraw(playerid, 180.266555, 267.407623, "_"); // ID skina
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][3], 0.565666, 3.479110);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][3], 0.000000, 347.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][3], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][3], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][3], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdButik][3], 2);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][3], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][3], 1);

    PlayerTD[playerid][ptdButik][4] = CreatePlayerTextDraw(playerid, 119.000000, 315.000000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][4], 0.000000, 3.700004);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][4], 176.666687, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][4], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][4], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdButik][4], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdButik][4], 10042623);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][4], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][4], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][4], 0);

    PlayerTD[playerid][ptdButik][5] = CreatePlayerTextDraw(playerid, 182.500000, 315.000000, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][5], 0.000000, 3.700004);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][5], 240.166687, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][5], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdButik][5], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdButik][5], -1390739201);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][5], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][5], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][5], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][5], 1);

    PlayerTD[playerid][ptdButik][6] = CreatePlayerTextDraw(playerid, 128.300003, 313.499603, "KUPI");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][6], 0.416333, 2.305185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][6], 171.000000, 50.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][6], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][6], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][6], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdButik][6], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][6], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][6], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][6], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdButik][6], true);

    PlayerTD[playerid][ptdButik][7] = CreatePlayerTextDraw(playerid, 183.000000, 320.000000, "IZADJI");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][7], 0.416333, 2.305185);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][7], 240.000000, 40.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][7], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][7], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdButik][7], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][7], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][7], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdButik][7], true);

    PlayerTD[playerid][ptdButik][8] = CreatePlayerTextDraw(playerid, 147.232864, 335.133270, "_"); // Cena
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdButik][8], 0.242666, 1.371851);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdButik][8], 0.000000, 156.566436);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdButik][8], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdButik][8], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdButik][8], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdButik][8], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdButik][8], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdButik][8], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdButik][8], 1);
    return 1;
}

ptdButik_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_BUTIK; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdButik][i]);
        PlayerTD[playerid][ptdButik][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    DeletePVar(playerid, "pSkinShopping");
    DeletePVar(playerid, "pSkinShoppingPrice");
    return 1;
}

ptdButik_Show(playerid) 
{
    for (new i = 0; i < PTD_SIZE_BUTIK; i++)
    {
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdButik][i]);
    }

    PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdButik][2]); // Sakrij strelicu nazad (levo)
    SelectTextDraw(playerid, 0xF2E4AEFF);
    return 1;
}

ptdButik_SetSkin(playerid, skin) 
{
    new skinStr[4];
    valstr(skinStr, skin);

    SetPlayerSkin(playerid, skin);
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdButik][3], skinStr);
    SetPVarInt(playerid, "pSkinShopping", skin);
    return 1;
}

ptdButik_SetPrice(playerid, price) 
{
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdButik][8], formatMoneyString(price));
    return 1;
}

hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (GetPVarInt(playerid, "pSkinShopping") <= 0) return 0;

    if (playertextid == PlayerTD[playerid][ptdButik][2]) // Levo
    {
        SetPVarInt(playerid, "pSkinShoppingIndex", GetPVarInt(playerid, "pSkinShoppingIndex") - 1);
        new
            index = GetPVarInt(playerid, "pSkinShoppingIndex"), 
            skin  = pSkinIDs[playerid][index],
            price = pSkinPrices[playerid][index];

        ptdButik_SetSkin(playerid, skin);
        ptdButik_SetPrice(playerid, price);

        if (index == 0) // Prvi skin, sakrij TD za levo
            PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdButik][2]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdButik][1]);

        return ~1;
    }

    if (playertextid == PlayerTD[playerid][ptdButik][1]) // Desno
    {
        SetPVarInt(playerid, "pSkinShoppingIndex", GetPVarInt(playerid, "pSkinShoppingIndex") + 1);
        new
            index = GetPVarInt(playerid, "pSkinShoppingIndex"), 
            skin  = pSkinIDs[playerid][index],
            price = pSkinPrices[playerid][index];

        ptdButik_SetSkin(playerid, skin);
        ptdButik_SetPrice(playerid, price);

        if (index == sizeof pSkinIDs[] - 1) // Poslednji skin, sakrij TD za desno
            PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdButik][1]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdButik][2]);

        return ~1;
    }

    if (playertextid == PlayerTD[playerid][ptdButik][6]) // Kupi
    {
        new
            skin  = pSkinIDs[playerid][GetPVarInt(playerid, "pSkinShoppingIndex")],
            price = pSkinPrices[playerid][GetPVarInt(playerid, "pSkinShoppingIndex")];

        if (PI[playerid][p_novac] < price) {
            ErrorMsg(playerid, "Nemate dovoljno novca. (%s)", formatMoneyString(price));
            return ~1;
        }

        PlayerMoneySub(playerid, price);
        re_firma_dodaj_novac(firma_kupuje[playerid], price/2);
        PI[playerid][p_skin] = skin;
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);

        SendClientMessageF(playerid, SVETLOPLAVA, "Kupili ste novu odecu i platili %s.", formatMoneyString(price));
        
        format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET skin = %d WHERE id = %d", skin, PI[playerid][p_id]);
        mysql_tquery(SQL, mysql_upit);

        ptdButik_ExitShopping(playerid);
        SetPlayerSkin(playerid, skin); // mora ispod exit-a, jer se u njemu resetuje skin
        return ~1;
    }

    if (playertextid == PlayerTD[playerid][ptdButik][7]) // Izadji
    {
        ptdButik_ExitShopping(playerid);
        return ~1;
    }

    return 0;
}

ptdButik_ExitShopping(playerid) 
{
    SetPlayerInterior(playerid, GetPVarInt(playerid, "pShoppingInt"));
    SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pShoppingVW"));
    SetPlayerCompensatedPos(playerid, GetPVarFloat(playerid, "pShoppingX"), GetPVarFloat(playerid, "pShoppingY"), GetPVarFloat(playerid, "pShoppingZ"));
    SetCameraBehindPlayer(playerid);
    SetPlayerSkin(playerid, GetPVarInt(playerid, "pOldSkin"));


    DeletePVar(playerid, "pOldSkin");
    DeletePVar(playerid, "pSkinShopping");
    DeletePVar(playerid, "pSkinShoppingIndex");
    DeletePVar(playerid, "pShoppingInt");
    DeletePVar(playerid, "pShoppingVW");
    DeletePVar(playerid, "pShoppingX");
    DeletePVar(playerid, "pShoppingY");
    DeletePVar(playerid, "pShoppingZ");
    ptdButik_Destroy(playerid);
    CancelSelectTextDraw(playerid);
    return 1;
}


ptdButik_Setup(playerid) 
{
    // Skinovi zavise od toga koji je enterijer butika u pitanju

    switch (GetPlayerInterior(playerid)) 
    {
        case 1: // Suburban
        {
            if (IsPlayerMale(playerid)) 
            { 
                pSkinIDs[playerid]      = {21, 22, 23, 67, 73, 100, 143, 179, 221, 222};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinIDs[playerid]      = {12, 39, 40, 56, 64, 77, 140, 152, 191, 198};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }

        case 3: // Prolaps
        {
            if (IsPlayerMale(playerid)) 
            {
                pSkinIDs[playerid]      = {18, 19, 25, 30, 34, 95, 142, 241, 242, 297};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinPrices[playerid]   = {91, 139, 151, 194, 219, 226, 231, 233, 246, 256};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }

        case 5: // Victim
        {
            if (IsPlayerMale(playerid)) 
            {
                pSkinIDs[playerid]      = {206, 229, 236, 247, 250, 258, 259, 290, 291, 292};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinIDs[playerid]      = {31, 53, 54, 88, 130, 131, 172, 224, 232, 238};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }

        case 14: // Didier
        {
            if (IsPlayerMale(playerid)) 
            {
                pSkinIDs[playerid]      = {45, 46, 47, 51, 59, 66, 84, 154, 184, 248};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinIDs[playerid]      = {89, 92, 190, 192, 193, 197, 200, 207, 225, 233};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }

        case 15: // Binco
        {
            if (IsPlayerMale(playerid)) 
            {
                pSkinIDs[playerid]      = {2, 7, 15, 20, 24, 26, 33, 35, 36, 43};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinIDs[playerid]      = {41, 63, 69, 76, 85, 90, 243, 251, 257, 263};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }

        case 18: // ZIP
        {
            if (IsPlayerMale(playerid)) 
            {
                pSkinIDs[playerid]      = {3, 185, 186, 189, 223, 228, 240, 295, 296, 299};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
            else 
            {
                pSkinIDs[playerid]      = {11, 12, 13, 211, 214, 215, 216, 219, 233, 263};
                pSkinPrices[playerid]   = {1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000};
            }
        }
    }
    
    SetPVarInt(playerid, "pSkinShoppingIndex", 0);
    SetPVarInt(playerid, "pOldSkin", GetPlayerSkin(playerid));
    ptdButik_SetSkin(playerid, pSkinIDs[playerid][0]);
    ptdButik_SetPrice(playerid, pSkinPrices[playerid][0]);
    return 1;
}