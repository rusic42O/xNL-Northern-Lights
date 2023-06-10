stock ptdBankMoney_Create(playerid)
{
	PlayerTD[playerid][ptdBankMoney] = CreatePlayerTextDraw(playerid, 498.901580, 99.749351, "$00000000");
	PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][ptdBankMoney], 0.552353, 2.174998);
	PlayerTextDrawAlignment(playerid, PlayerTD[playerid][ptdBankMoney], 1);
	PlayerTextDrawColor(playerid, PlayerTD[playerid][ptdBankMoney], 689920767);
	PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][ptdBankMoney], 0);
	PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][ptdBankMoney], 2);
	PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][ptdBankMoney], 255);
	PlayerTextDrawFont(playerid, PlayerTD[playerid][ptdBankMoney], 3);
	PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][ptdBankMoney], 1);
}

stock ptdBankMoney_Show(playerid)
{
	return PlayerTextDrawShow(playerid, PlayerTD[playerid][ptdBankMoney]);
}

stock ptdBankMoney_Hide(playerid)
{
	return PlayerTextDrawHide(playerid, PlayerTD[playerid][ptdBankMoney]);
}

stock ptdBankMoney_Set(playerid, amount)
{
	new str[10];
	format(str, sizeof str, "$%08d", amount);
	PlayerTextDrawSetString(playerid, PlayerTD[playerid][ptdBankMoney], str);
	ptdBankMoney_Show(playerid);
}

stock BankMoneyAdd(playerid, amount)
{
	PI[playerid][p_banka] += amount;
	ptdBankMoney_Set(playerid, PI[playerid][p_banka]);
}

stock BankMoneySub(playerid, amount)
{
	PI[playerid][p_banka] -= amount;
	ptdBankMoney_Set(playerid, PI[playerid][p_banka]);
}