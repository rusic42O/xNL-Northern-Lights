#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum E_ACCESSORIES_LIST
{
    ACCESSORIES_HATS,
    ACCESSORIES_GLASSES,
    ACCESSORIES_BANDANAS,
}

enum E_ACCESSORIES_PRICELIST
{
    ACCESSORY_OBJECT_ID,
    ACCESSORY_PRICE_CASH,
    ACCESSORY_PRICE_TOKENS,
}





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new ACCESSORIES_EditingModel[MAX_PLAYERS];
new AccessoryLists[E_ACCESSORIES_LIST] = {mS_INVALID_LISTID, ...};
new bool:pAccessoriesLoaded[MAX_PLAYERS char];

new AccessoriesPrices[][E_ACCESSORIES_PRICELIST] = 
{
    {18947, 3500, 0},
	{18969, 3500, 0},
	{18944, 3500, 0},
	{18945, 3500, 0},
	{18951, 3500, 0},
	{18962, 3500, 0},
	{19069, 3500, 0},
	{19096, 3500, 0},
	{19098, 3500, 0},
	{18968, 3500, 0},
	{19553, 3500, 0},
	{19067, 3500, 0},
	{18935, 3500, 0},
	{18934, 3500, 0},
	{19488, 3500, 0},
	{18967, 3500, 0},
	{18927, 3500, 0},
	{18932, 3500, 0},
	{18950, 3500, 0},
	{18928, 3500, 0},
	{18948, 3500, 0},
	{18946, 3500, 0},
	{18930, 3500, 0},
	{18931, 3500, 0},
	{18949, 3500, 0},
	{19521, 3500, 0},
	{19067, 3500, 0},
	{18639, 3500, 0},
	{19095, 3500, 0},
	{19097, 3500, 0},
	{18894, 3500, 0},
	{18899, 3500, 0},
	{18896, 3500, 0},
	{18897, 3500, 0},
	{18921, 3500, 0},
	{18939, 3500, 0},
	{18941, 3500, 0},
	{18940, 3500, 0},
	{18942, 3500, 0},
	{18943, 3500, 0},
	{18955, 3500, 0},
	{18956, 3500, 0},
	{18957, 3500, 0},
	{19137, 0, 4},
	{19068, 0, 4},
	{18933, 0, 4},
	{18929, 0, 4},
	{18926, 0, 4},
	{19528, 0, 4},
	{18973, 0, 4},
	{18972, 0, 4},
	{18970, 0, 4},
	{18971, 0, 4},
	{19352, 0, 4},
	{19068, 0, 4},
	{19487, 0, 4},
	{18893, 0, 4},
	{18895, 0, 4},
	{18901, 0, 4},
	{18924, 0, 4},
	{18929, 0, 4},
	{18958, 0, 4},
	{18959, 0, 4},
	{18961, 0, 4},

    // Glasses
    {19006, 2500, 0},
    {19007, 2500, 0},
    {19008, 2500, 0},
    {19009, 2500, 0},
    {19010, 2500, 0},
    {19011, 2500, 0},
    {19012, 2500, 0},
    {19013, 2500, 0},
    {19014, 2500, 0},
    {19015, 2500, 0},
    {19016, 2500, 0},
    {19017, 2500, 0},
    {19018, 2500, 0},
    {19019, 2500, 0},
    {19020, 2500, 0},
    {19021, 2500, 0},
    {19022, 2500, 0},
    {19023, 2500, 0},
    {19024, 2500, 0},
    {19025, 2500, 0},
    {19026, 2500, 0},
    {19027, 2500, 0},
    {19028, 2500, 0},
    {19029, 2500, 0},
    {19030, 2500, 0},
    {19031, 2500, 0},
    {19032, 2500, 0},
    {19033, 2500, 0},
    {19034, 2500, 0},
    {19035, 2500, 0},

    // Bandanas
    {18911, 3000, 0},
	{18912, 3000, 0},
	{18913, 3000, 0},
	{18914, 3000, 0},
	{18915, 3000, 0},
	{18916, 3000, 0},
	{18917, 3000, 0},
	{18918, 3000, 0},
	{18919, 3000, 0},
	{18920, 3000, 0}
};




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
	// Ucitavanje accessories-a
    AccessoryLists[ACCESSORIES_GLASSES] 	= LoadModelSelectionMenu("mSelection/accessories/glasses.list");
    AccessoryLists[ACCESSORIES_HATS]    	= LoadModelSelectionMenu("mSelection/accessories/hats.list");
    AccessoryLists[ACCESSORIES_BANDANAS]    = LoadModelSelectionMenu("mSelection/accessories/bandanas.list");
	return true;
}

hook OnPlayerConnect(playerid)
{
	ACCESSORIES_EditingModel[playerid] = -1;
	pAccessoriesLoaded{playerid} = false;
}

hook OnPlayerSpawn(playerid)
{
	if (!pAccessoriesLoaded{playerid})
	{
		LoadPlayerAccessories(playerid);
	}
}

hook OnPlayerEditAttachedObj(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if (IsPlayerBuyingAccessories(playerid) || IsPlayerEditingAccessories(playerid))
    {
        if (!response)
        {
            // Igrac je odustao od promene pozicije. Ako kupuje, predmet, treba mu vratiti novac
            // ..izbrisati predmet iz tabele, vratiti novac u firmu

            if (IsPlayerBuyingAccessories(playerid))
            {
                new itemPriceCash = GetPVarInt(playerid, "pBuyingAccessories_PriceCash");
                new itemPriceTokens = GetPVarInt(playerid, "pBuyingAccessories_PriceTokens");
                
                if (itemPriceTokens > 0)
                {
                	PI[playerid][p_token] += itemPriceTokens;
                	re_firma_oduzmi_novac(firma_kupuje[playerid], 5000/2);
                
                	new sQuery[256];
                	format(sQuery, sizeof sQuery, "UPDATE igraci SET gold = %i WHERE id = %i", PI[playerid][p_token], PI[playerid][p_id]);
                	mysql_tquery(SQL, sQuery);
                }
                else
                {
                	PlayerMoneyAdd(playerid, itemPriceCash);
                	re_firma_oduzmi_novac(firma_kupuje[playerid], itemPriceCash/2);
                }

                new sQuery[60];
                format(sQuery, sizeof sQuery, "DELETE FROM accessories WHERE pid = %i AND model = %i", PI[playerid][p_id], modelid);
                mysql_tquery(SQL, sQuery);

                RemovePlayerAttachedObject(playerid, index);
                InfoMsg(playerid, "Odustali ste od kupovine ovog predmeta. Novac Vam je vracen.");
                // TODO: otvoriti mu selection menu

                new logStr[50];
		        format(logStr, sizeof logStr, "%s je odustao od kupovine %i", ime_obicno[playerid], modelid);
		        Log_Write(LOG_ACCESSORIES, logStr);
            }
        }
        else if (response)
        {
            new posStr[100];
            format(posStr, sizeof posStr, "%.5f|%.5f|%.5f|%.5f|%.5f|%.5f|%.5f|%.5f|%.5f", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

            new sQuery[185];
            format(sQuery, sizeof sQuery, "UPDATE accessories SET pos = '%s' WHERE pid = %i AND model = %i", posStr, PI[playerid][p_id], modelid);
            mysql_tquery(SQL, sQuery);

            // Gornji deo je zajednicki za kupovinu i izmenu vec postojecih predmeta
            // ovaj donji je dodatak za izmenu vec postojecih 
            if (IsPlayerEditingAccessories(playerid))
            {
                InfoMsg(playerid, "Pozicija ovog predmeta je izmenjena.");
                return callcmd::stvari(playerid, "");
            }
            return 1;
        }
    }
    return 1;
}

hook OnPlayerModelSelection(playerid, response, listid, modelid)
{
    if (DebugFunctions())
    {
        LogCallbackExec("accessories.pwn", "OnPlayerModelSelection");
    }

    if (IsPlayerBuyingAccessories(playerid))
    {
        new attachmentSlot = GetPlayerFreeAttachSlot(playerid);
        if (attachmentSlot == -1)
            return ErrorMsg(playerid, "Vec imate previse stvari na sebi. Morate skinuti nesto.");

        new itemPriceCash = 2500, itemPriceTokens = 0;
        for__loop (new i = 0; i < sizeof AccessoriesPrices; i++)
        {
            if (AccessoriesPrices[i][ACCESSORY_OBJECT_ID] == modelid)
            {
                itemPriceCash = AccessoriesPrices[i][ACCESSORY_PRICE_CASH];
                itemPriceTokens = AccessoriesPrices[i][ACCESSORY_PRICE_TOKENS];
                break;
            }
        }

        // Ako je unutar skripte definisana cena, gornji loop ce je pronaci.
        // Ako nije, izabrani objekat ce kostati $2500 / 0 tokena, podrazumevano.

        SetPVarInt(playerid, "pBuyingAccessories_PriceCash", itemPriceCash);
        SetPVarInt(playerid, "pBuyingAccessories_PriceTokens", itemPriceTokens);
        SetPVarInt(playerid, "pBuyingAccessories_Slot", attachmentSlot);
        SetPVarInt(playerid, "pBuyingAccessories_Model", modelid);

        new price[16];
        if (itemPriceTokens > 0)
        {
        	format(price, sizeof price, "%i tokena", itemPriceTokens);
        }
        else
        {
        	format(price, sizeof price, "%s", formatMoneyString(itemPriceCash));
        }
        new dStr[110];
        format(dStr, sizeof dStr, "{FFFFFF}Ovaj predmet kosta {FF9900}%s.\n{FFFFFF}Da li zelite da kupite ovaj predmet?", price);
        SPD(playerid, "accessoryBuy", DIALOG_STYLE_MSGBOX, "Kupovina", dStr, "Da", "Ne");

        // TODO:
        // Napraviti TD koji ce uvecati izabrani objekat i napisati njegovu cenu
        // Igracu dati opciju da kupi predmet, a zatim zapoceti editovanje objekta...
        // ... ili mu dati opciju da odustane. Ako odustane, vraca mu se selection menu
    }
    return 1;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock IsPlayerBuyingAccessories(playerid)
{
    new string[16];
    string[0] = EOS;
    GetPVarString(playerid, "pAccessoryIdent", string, sizeof string);

    if (isnull(string))
        return false;

    else return true;
}

stock IsPlayerEditingAccessories(playerid)
{
	if (ACCESSORIES_EditingModel[playerid] == -1)
	{
		return false;
	}
	else return true;
}

stock GetPlayerEditingModel(playerid)
{
	return ACCESSORIES_EditingModel[playerid];
}

stock SetPlayerEditingModel(playerid, modelid)
{
	ACCESSORIES_EditingModel[playerid] = modelid;
}

stock GetPlayerFreeAttachSlot(playerid)
{
    if (!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM1))
    {
        return SLOT_CUSTOM1;
    }
    else if (!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM2))
    {
        return SLOT_CUSTOM2;
    }
    else if (!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM3))
    {
        return SLOT_CUSTOM3;
    }
    else
    {
        return -1;
    }
}

stock GetAttachedItemIndex(playerid, modelid)
{
	if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM1))
	{
		if (pAttachedObjects[playerid][SLOT_CUSTOM1] == modelid)
		{
			return SLOT_CUSTOM1;
		}
	}

	if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM2))
	{
		if (pAttachedObjects[playerid][SLOT_CUSTOM2] == modelid)
		{
			return SLOT_CUSTOM2;
		}
	}

	if (IsPlayerAttachedObjectSlotUsed(playerid, SLOT_CUSTOM3))
	{
		if (pAttachedObjects[playerid][SLOT_CUSTOM3] == modelid)
		{
			return SLOT_CUSTOM3;
		}
	}

	return -1;
}

stock IsObjectAttachedToPlayer(playerid, modelid)
{
	if (GetAttachedItemIndex(playerid, modelid) == -1)
		return false;
	else return true;
}

stock ReopenAccessorySelection(playerid)
{
	new ident[16];
	GetPVarString(playerid, "pAccessoryIdent", ident, sizeof ident);
	ShowModelSelectionMenu(playerid, GetPVarInt(playerid, "pAccessoryListID"), ident);
}

stock LoadPlayerAccessories(playerid)
{
	new sQuery[90];
	format(sQuery, sizeof sQuery, "SELECT pos, bone, model FROM accessories WHERE pid = %i AND equipped = 'Yes' LIMIT 3", PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery, "MySQL_OnEquippedAcsLoaded", "ii", playerid, cinc[playerid]);
}





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_OnAccessoryPosLoad(playerid, ccinc, modelid, index);
public MySQL_OnAccessoryPosLoad(playerid, ccinc, modelid, index)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (rows != 1)
		return ErrorMsg(playerid, GRESKA_NEPOZNATO);

	new pos[100], bone;
	cache_get_value_name(0, "pos", pos, sizeof pos);
	cache_get_value_name_int(0, "bone", bone);

	new Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ;
	sscanf(pos, "p<|>fffffffff", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

	SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

	new sQuery[80];
	format(sQuery, sizeof sQuery, "UPDATE accessories SET equipped = 'Yes' WHERE pid = %i AND model = %i", PI[playerid][p_id], modelid);
	mysql_tquery(SQL, sQuery);

	InfoMsg(playerid, "Obukli ste ovaj predmet.");

	return 1;
}

forward MySQL_CheckAccessoryPossession(playerid, ccinc, modelid, slot, price, tokens);
public MySQL_CheckAccessoryPossession(playerid, ccinc, modelid, slot, price, tokens)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (rows > 0)
    {
        // TODO: Vratiti ga u selection menu
        return ErrorMsg(playerid, "Vec posedujete isti ovakav predmet.");
    }
    else
    {
    	if (tokens > 0 && PI[playerid][p_token] < tokens)
    		return ErrorMsg(playerid, "Nemate dovoljno tokena."); // TODO: vrati ga u sel. menu
    	else if (tokens > 0 && PI[playerid][p_token] >= tokens)
    	{
    		PI[playerid][p_token] -= tokens;

    		new sQuery[256];
    		format(sQuery, sizeof sQuery, "UPDATE igraci SET gold = %i WHERE id = %i", PI[playerid][p_token], PI[playerid][p_id]);
    		mysql_tquery(SQL, sQuery);

    		re_firma_dodaj_novac(firma_kupuje[playerid], 5000/2);
    	}

        if (tokens <= 0 && PI[playerid][p_novac] < price)
        {
            return ErrorMsg(playerid, "Nemate dovoljno novca."); // TODO: vrati u sel. menu
        }
        else if (tokens <= 0 && PI[playerid][p_novac] >= price)
        {
        	PlayerMoneySub(playerid, price);
        	re_firma_dodaj_novac(firma_kupuje[playerid], price/2);
        }


        SetPlayerAttachedObject(playerid, slot, modelid, 2);
        EditAttachedObject(playerid, slot);

        new sQuery[152], posStr[72], ident[16];
        GetPVarString(playerid, "pAccessoryIdent", ident, sizeof ident);
        format(posStr, sizeof posStr, "0.00000|0.00000|0.00000|0.00000|0.00000|0.00000|1.00000|1.00000|1.00000");
        format(sQuery, sizeof sQuery, "INSERT INTO accessories VALUES (%i, %i, '%s', %i, %i, '%s', 'Yes')", PI[playerid][p_id], modelid, ident, price, 2, posStr);
        mysql_tquery(SQL, sQuery);

        InfoMsg(playerid, "Kupili ste ovaj predmet za %s.", formatMoneyString(price));
        InfoMsg(playerid, "Podesite ga kako zelite da stoji i kliknite na \"Save\" ikonicu.");

        new logStr[50];
        format(logStr, sizeof logStr, "%s je kupio %s: %i (cena $%i)", ime_obicno[playerid], ident, modelid, price);
        Log_Write(LOG_ACCESSORIES, logStr);
    }
    return 1;
}

forward MySQL_OnPlayerAccessoriesLoad(playerid, ccinc);
public MySQL_OnPlayerAccessoriesLoad(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

	cache_get_row_count(rows);
	if (!rows)
	{
		return ErrorMsg(playerid, "Ne posedujete ni jedan odevni predmet. Idite u Accessory Shop da ih kupite.");
	}

	new string[1024];
	format(string, 22, "Model\tNaziv\tNa tebi");
	for__loop (new i = 0; i < rows; i++)
	{
		new model, naziv[16], equipped[4], bool:bEquipped = false;
		cache_get_value_name_int(i, "model", model);
		cache_get_value_name(i, "ident", naziv, sizeof naziv);
		cache_get_value_name(i, "equipped", equipped, sizeof equipped);

		if (!strcmp(equipped, "Yes", true)) bEquipped = true;
		format(string, sizeof string, "%s\n%i\t%s\t%s", string, model, naziv, (bEquipped? ("{00FF00}Da") : ("{FF0000}Ne")));
	}

	SPD(playerid, "accessories", DIALOG_STYLE_TABLIST_HEADERS, "Odevni predmeti", string, "Izmeni", "Izadji");
	return 1;
}

forward MySQL_OnEquippedAcsLoaded(playerid, ccinc);
public MySQL_OnEquippedAcsLoaded(playerid, ccinc)
{
	if (!checkcinc(playerid, ccinc))
		return 1;

    pAccessoriesLoaded{playerid} = true;

	cache_get_row_count(rows);
	if (!rows) return 1;

	for__loop (new i = 0; i < rows; i++)
	{
		new pos[100], bone, modelid;
		cache_get_value_name(i, "pos", pos, sizeof pos);
		cache_get_value_name_int(i, "bone", bone);
		cache_get_value_name_int(i, "model", modelid);

		new Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ;
		sscanf(pos, "p<|>fffffffff", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);

		new index = GetPlayerFreeAttachSlot(playerid);
		SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ);
	}
	return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:accessories(playerid, response, listitem, const inputtext[])
{
	if (!response) 
	{
		SetPlayerEditingModel(playerid, -1);
		return 1;
	}

	SetPlayerEditingModel(playerid, strval(inputtext));
	SPD(playerid, "accessoriesEdit", DIALOG_STYLE_LIST, "Izmena predmeta", "Izmeni naziv\nPromeni poziciju\nObuci/svuci\nBaci", "Dalje »", "« Nazad");
	return 1;
}

Dialog:accessoriesEdit(playerid, response, listitem, const inputtext[])
{
	if (!response)
		return callcmd::stvari(playerid, "");

	if (listitem == 0) // Izmeni naziv
	{
		SPD(playerid, "accessoriesEdit_Ident", DIALOG_STYLE_INPUT, "Izmeni naziv", "{FFFFFF}Unesi novi naziv za ovaj predmet:", "Promeni", "Nazad");
	}
	else if (listitem == 1) // Promeni poziciju
	{
		new modelid = GetPlayerEditingModel(playerid);

		if (IsObjectAttachedToPlayer(playerid, modelid))
		{
			new index = GetAttachedItemIndex(playerid, modelid);
			if (index == -1)
				return ErrorMsg(playerid, GRESKA_NEPOZNATO);

			EditAttachedObject(playerid, index);
		}
		else
		{
			return ErrorMsg(playerid, "Ovaj predmet mora biti na Vama da biste mu izmenili poziciju.");
		}	
	}
	else if (listitem == 2) // Obuci-svuci
	{
		new modelid = GetPlayerEditingModel(playerid);
		new slot = GetPlayerFreeAttachSlot(playerid);
		new equipCheck = GetAttachedItemIndex(playerid, modelid);

		if (slot == -1 && equipCheck == -1)
		{
			// Nema slobodnih slotova, a predmet nije obucen -> zeli da ga obuce
			return ErrorMsg(playerid, "Imate previse predmeta na sebi, morate neki skinuti.");
		}

		if (equipCheck != -1)
		{
			// Predmet je vec na igracu -> zeli da ga skine
			RemovePlayerAttachedObject(playerid, equipCheck);

			new sQuery[78];
			format(sQuery, sizeof sQuery, "UPDATE accessories SET equipped = 'No' WHERE pid = %i AND model = %i", PI[playerid][p_id], modelid);
			mysql_tquery(SQL, sQuery);

			InfoMsg(playerid, "Skinuli ste ovaj predmet.");
			return callcmd::stvari(playerid, "");
		}

		else if (equipCheck == -1)
		{
			// Predmet nije na igracu, zeli da ga stavi (provera za too much items vec postoji gore)
			// Query za nalazenje pozicija je neophodan.

			new sQuery[73];
			format(sQuery, sizeof sQuery, "SELECT bone, pos FROM accessories WHERE pid = %i AND model = %i", PI[playerid][p_id], modelid);
			mysql_tquery(SQL, sQuery, "MySQL_OnAccessoryPosLoad", "iiii", playerid, cinc[playerid], modelid, slot);
		}
	}
	else if (listitem == 3) // Baci
	{
		new modelid = GetPlayerEditingModel(playerid);
		new slot = GetAttachedItemIndex(playerid, modelid);
		if (slot != -1)
			RemovePlayerAttachedObject(playerid, slot);

		new sQuery[63];
		format(sQuery, sizeof sQuery, "DELETE FROM accessories WHERE pid = %i AND model = %i", PI[playerid][p_id], modelid);
		mysql_tquery(SQL, sQuery);	

		InfoMsg(playerid, "Bacili ste ovaj predmet.");
		return callcmd::stvari(playerid, "");
	}

	return 1;
}

Dialog:accessoriesEdit_Ident(playerid, response, listitem, const inputtext[])
{
	new respondStr[7];
	valstr(respondStr, GetPlayerEditingModel(playerid));

	if (!response)
		return dialog_respond:accessoriesEdit(playerid, 1, 0, respondStr);

	if (isnull(inputtext))
		return DialogReopen(playerid);

	if (strlen(inputtext) > 16)
	{
		ErrorMsg(playerid, "Naziv je predugacak (do 16 znakova).");
		return DialogReopen(playerid);
	}

	new modelid = GetPlayerEditingModel(playerid);

	new sQuery[90];
	mysql_format(SQL, sQuery, sizeof sQuery, "UPDATE accessories SET ident = '%s' WHERE pid = %i AND model = %i", inputtext, PI[playerid][p_id], modelid);
	mysql_tquery(SQL, sQuery);

	InfoMsg(playerid, "Izmenili ste naziv za predmet %i. Novi naziv: %s.", modelid, inputtext);

	callcmd::stvari(playerid, "");
	return 1;
}

Dialog:accessoryShop(playerid, response, listitem, const inputtext[])
{
    if (response)
   	{
        new shoppingType;
        if (listitem == 0) // Kape
        {
            shoppingType = _:ACCESSORIES_HATS;
            SetPVarString(playerid, "pAccessoryIdent", "Kapa");
        }
        else if (listitem == 1) // Bandane
        {
        	// return InfoMsg(playerid, "Trenutno mozete kupiti samo kape i naocare. Bandane stizu vrlo brzo!");

            shoppingType = _:ACCESSORIES_BANDANAS;
            SetPVarString(playerid, "pAccessoryIdent", "Bandana");
        }
        else if (listitem == 2) // Naocare
        {
            shoppingType = _:ACCESSORIES_GLASSES;
            SetPVarString(playerid, "pAccessoryIdent", "Naocare");
        }

        new listid = AccessoryLists[E_ACCESSORIES_LIST:shoppingType];
        SetPVarInt(playerid, "pAccessoryListID", listid); 
        ShowModelSelectionMenu(playerid, listid, inputtext);
    }
    else
    {
        DeletePVar(playerid, "pAccessoryIdent");
    }
    return 1;
}

Dialog:accessoryBuy(playerid, response, listitem, const inputtext[])
{
	if (!response)
	{
		// TODO: prikazi sel. menu
		return 1;
	}

    if (IsPlayerBuyingAccessories(playerid))
    {
        new slot  = GetPVarInt(playerid, "pBuyingAccessories_Slot");
        new modelid = GetPVarInt(playerid, "pBuyingAccessories_Model");
        new itemPriceCash = GetPVarInt(playerid, "pBuyingAccessories_PriceCash");
        new itemPriceTokens = GetPVarInt(playerid, "pBuyingAccessories_PriceTokens");
            
        if (itemPriceTokens > 0 && PI[playerid][p_token] < itemPriceTokens)
        {
        	// TODO: vratiti ga na selection menu
        	return ErrorMsg(playerid, "Nemate dovoljno tokena za ovaj predmet.");
        }
        
        else if (itemPriceTokens <= 0 && PI[playerid][p_novac] < itemPriceCash)
        {
            // TODO: vratiti ga na selection menu
            return ErrorMsg(playerid, "Nemate dovoljno novca.");
        }

        new sQuery[256];
        format(sQuery, sizeof sQuery, "SELECT pid FROM accessories WHERE model = %i AND pid = %i", modelid, PI[playerid][p_id]);
        mysql_tquery(SQL, sQuery, "MySQL_CheckAccessoryPossession", "iiiiii", playerid, cinc[playerid], modelid, slot, itemPriceCash, itemPriceTokens);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
alias:stvari("accessories", "accessory")

CMD:stvari(playerid, const params[])
{
	SetPlayerEditingModel(playerid, -1);

	new sQuery[45];
	format(sQuery, sizeof sQuery, "SELECT * FROM accessories WHERE pid = %i", PI[playerid][p_id]);
	mysql_tquery(SQL, sQuery, "MySQL_OnPlayerAccessoriesLoad", "ii", playerid, cinc[playerid]);
	return 1;
}