#include <YSI_Coding\y_hooks>

enum E_ACCESSORIES
{
    ACS_OBJECT_ID,
    ACS_PRICE,
}

new pAccessories_objectID[MAX_PLAYERS];
new Accessories_Hats[][E_ACCESSORIES] = 
{
    {18926, 1000}, 
    {18927, 1000}, 
    {18928, 1000}, 
    {18929, 1000}, 
    {18930, 1000}, 
    {18931, 1000}, 
    {18932, 1000}, 
    {18933, 1000}, 
    {18934, 1000}, 
    {18636, 1000}, 
    {18894, 1000}, 
    {18899, 1000}, 
    {18903, 1000}, 
    {18929, 1000}, 
    {18933, 1000}, 
    {18934, 1000}, 
    {18944, 1000}, 
    {18945, 1000}, 
    {18947, 1000}, 
    {18951, 1000}, 
    {18957, 1000}, 
    {18962, 1000}, 
    {18968, 1000}, 
    {18969, 1000}, 
    {18976, 1000}, 
    {19068, 1000}, 
    {19069, 1000}, 
    {19096, 1000}, 
    {19098, 1000}, 
    {19106, 1000}, 
    {19113, 1000}, 
    {19137, 1000}, 
    {19163, 1000}, 
    {19521, 1000}, 
    {19528, 1000}
};

stock ptdAccessories_Create(playerid)
{
    PlayerTD[playerid][ptdAccessories][0] = CreatePlayerTextDraw(playerid, 239.099792, 343.896423, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][0], 0.000000, 6.966667);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][0], 395.099761, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][0], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][0], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][0], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][0], 170);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][0], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][0], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][0], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][0], 1);

    PlayerTD[playerid][ptdAccessories][1] = CreatePlayerTextDraw(playerid, 245.199890, 380.555633, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][1], 0.000000, 2.431681);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][1], 309.867187, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][1], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][1], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][1], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][1], 973082111);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][1], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][1], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][1], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][1], 1);

    PlayerTD[playerid][ptdAccessories][2] = CreatePlayerTextDraw(playerid, 277.535186, 382.870574, "KUPI");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][2], 0.374333, 1.926076);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][2], 20.000000, 61.200134);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][2], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][2], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][2], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][2], 1778388479);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][2], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdAccessories][2], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][2], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][2], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][2], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAccessories][2], true);

    PlayerTD[playerid][ptdAccessories][3] = CreatePlayerTextDraw(playerid, 322.204589, 380.555633, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][3], 0.000000, 2.431681);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][3], 386.871887, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][3], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][3], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][3], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][3], 973082111);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][3], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][3], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][3], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][3], 1);

    PlayerTD[playerid][ptdAccessories][4] = CreatePlayerTextDraw(playerid, 354.706573, 382.870574, "ODUSTANI");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][4], 0.289000, 1.918742);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][4], 20.000000, 61.050327);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][4], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][4], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][4], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][4], 1778388479);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][4], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdAccessories][4], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][4], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][4], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][4], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAccessories][4], true);

    PlayerTD[playerid][ptdAccessories][5] = CreatePlayerTextDraw(playerid, 258.533233, 350.688995, "box");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][5], 0.000000, 2.061008);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][5], 375.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][5], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][5], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][5], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][5], 221905151);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][5], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][5], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][5], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][5], 1);

    PlayerTD[playerid][ptdAccessories][6] = CreatePlayerTextDraw(playerid, 316.633331, 353.274322, "Cena: $---");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][6], 0.270666, 1.511493);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][6], 0.000000, 111.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][6], 2);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][6], -1);
    PlayerTextDrawUseBox(playerid, PlayerTD[playerid][ptdAccessories][6], 1);
    PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][ptdAccessories][6], 227016959);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][6], 0);
    PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdAccessories][6], 1);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][6], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][6], 2);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][6], 1);

    PlayerTD[playerid][ptdAccessories][7] = CreatePlayerTextDraw(playerid, 241.699935, 349.936828, "~<~");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][7], 0.563666, 2.176592);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][7], 260.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][7], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][7], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][7], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][7], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][7], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][7], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAccessories][7], true);

    PlayerTD[playerid][ptdAccessories][8] = CreatePlayerTextDraw(playerid, 378.899932, 349.936828, "~>~");
    PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdAccessories][8], 0.563666, 2.176592);
    PlayerTextDrawTextSize(playerid, PlayerTD[playerid][ptdAccessories][8], 394.000000, 20.000000);
    PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdAccessories][8], 1);
    PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdAccessories][8], -1);
    PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdAccessories][8], 0);
    PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdAccessories][8], 255);
    PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdAccessories][8], 1);
    PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdAccessories][8], 1);
    PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][ptdAccessories][8], true);
}

ptdAccessories_Destroy(playerid) 
{
    for (new i = 0; i < PTD_SIZE_ACCESSORIES; i++) 
    {
        PlayerTextDrawDestroy(playerid, PlayerTD[playerid][ptdAccessories][i]);
        PlayerTD[playerid][ptdAccessories][i] = PlayerText:INVALID_TEXT_DRAW;
    }

    DeletePVar(playerid, "pAccessoryShopping");
    DeletePVar(playerid, "pAccessoryShoppingPrice");
    return 1;
}

ptdAccessories_SetPrice(playerid, price) 
{
    new string[20];
    format(string, sizeof string, "Cena: %s", formatMoneyString(price));
    PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdAccessories][6], string);
    return 1;
}

ptdAccessories_ExitShopping(playerid) 
{
    SetPlayerInterior(playerid, GetPVarInt(playerid, "pShoppingInt"));
    SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "pShoppingVW"));
    SetPlayerCompensatedPos(playerid, GetPVarFloat(playerid, "pShoppingX"), GetPVarFloat(playerid, "pShoppingY"), GetPVarFloat(playerid, "pShoppingZ"));
    SetCameraBehindPlayer(playerid);


    DeletePVar(playerid, "pAccessoryShopping");
    DeletePVar(playerid, "pAccessoryShoppingIndex");
    DeletePVar(playerid, "pShoppingInt");
    DeletePVar(playerid, "pShoppingVW");
    DeletePVar(playerid, "pShoppingX");
    DeletePVar(playerid, "pShoppingY");
    DeletePVar(playerid, "pShoppingZ");
    ptdAccessories_Destroy(playerid);
    CancelSelectTextDraw(playerid);
    return 1;
}

ptdAccessories_ShowObject(playerid, objectid)
{
    if (pAccessories_objectID[playerid] != -1)
    {
        DestroyDynamicObject(pAccessories_objectID[playerid]);
    }

    pAccessories_objectID[playerid] = CreateDynamicObject(objectid, 2195.980224, 969.239074, -30.226673, -0.000006, -0.000003, -117.399948, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid);
    Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
    return 1;
}



hook OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) 
{
    if (GetPVarInt(playerid, "pAccessoryShopping") <= 0) return 0;

    if (playertextid == PlayerTD[playerid][ptdAccessories][7]) // Levo
    {
        SetPVarInt(playerid, "pAccessoryShoppingIndex", GetPVarInt(playerid, "pAccessoryShoppingIndex") - 1);
        new
            index = GetPVarInt(playerid, "pAccessoryShoppingIndex"), 
            shoppingType[16], objectID, price;
        GetPVarString(playerid, "pShoppingType", shoppingType, sizeof shoppingType);

        if (!strcmp(shoppingType, "Kape", true))
        {
            objectID = Accessories_Hats[index][ACS_OBJECT_ID];
            price = Accessories_Hats[index][ACS_PRICE];
        }

        ptdAccessories_ShowObject(playerid, objectID);
        ptdAccessories_SetPrice(playerid, price);
        SetPVarInt(playerid, "pAccessoryShopping", objectID);

        if (index == 0) // Poslednji objekat, sakrij TD za desno
            PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAccessories][7]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAccessories][8]);

        return ~1;
    }

    if (playertextid == PlayerTD[playerid][ptdAccessories][8]) // Desno
    {
        SetPVarInt(playerid, "pAccessoryShoppingIndex", GetPVarInt(playerid, "pAccessoryShoppingIndex") + 1);
        new
            index = GetPVarInt(playerid, "pAccessoryShoppingIndex"), 
            lastIndex,
            shoppingType[16], objectID, price;
        GetPVarString(playerid, "pShoppingType", shoppingType, sizeof shoppingType);

        if (!strcmp(shoppingType, "Kape", true))
        {
            objectID = Accessories_Hats[index][ACS_OBJECT_ID];
            price = Accessories_Hats[index][ACS_PRICE];
            lastIndex = sizeof Accessories_Hats - 1;
        }

        ptdAccessories_ShowObject(playerid, objectID);
        ptdAccessories_SetPrice(playerid, price);
        SetPVarInt(playerid, "pAccessoryShopping", objectID);

        if (index == lastIndex) // Poslednji objekat, sakrij TD za desno
            PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdAccessories][8]);
        PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdAccessories][7]);

        return ~1;
    }

    // if (playertextid == PlayerTD[playerid][ptdButik][6]) // Kupi
    // {
    //     new
    //         skin  = pSkinIDs[playerid][GetPVarInt(playerid, "pAccessoryShoppingIndex")],
    //         price = pSkinPrices[playerid][GetPVarInt(playerid, "pAccessoryShoppingIndex")];

    //     if (PI[playerid][p_novac] < price) {
    //         ErrorMsg(playerid, "Nemate dovoljno novca. (%s)", formatMoneyString(price));
    //         return ~1;
    //     }

    //     PlayerMoneySub(playerid, price);
    //     re_firma_dodaj_novac(firma_kupuje[playerid], price/2);
    //     SetSpawnInfo(playerid, 0, skin, PI[playerid][p_spawn_x], PI[playerid][p_spawn_y], PI[playerid][p_spawn_z], PI[playerid][p_spawn_a], 0, 0, 0, 0, 0, 0);
    //     PI[playerid][p_skin] = skin;

    //     SendClientMessageF(playerid, SVETLOPLAVA, "Kupili ste novu odecu i platili %s.", formatMoneyString(price));
        
    //     format(mysql_upit, sizeof mysql_upit, "UPDATE igraci SET skin = %d WHERE id = %d", skin, PI[playerid][p_id]);
    //     mysql_tquery(SQL, mysql_upit);

    //     ptdButik_ExitShopping(playerid);
    //     SetPlayerSkin(playerid, skin); // mora ispod exit-a, jer se u njemu resetuje skin
    //     return ~1;
    // }

    if (playertextid == PlayerTD[playerid][ptdAccessories][4]) // Izadji
    {
        ptdAccessories_ExitShopping(playerid);
        return ~1;
    }

    return 0;
}