new BrodObjekt[3],
	PolazisteObj[2],
	OdredisteObj[2],
	Part,
    KretanjeBroda;

#define Min(%0)             	((%0) * (1000*60))
#define KA_POLAZISTU 			1
#define KA_DOLAZISTU 			2


hook OnGameModeInit()
{
	SetTimer("InitShip", Min(1)+500, false);
	return Y_HOOKS_CONTINUE_RETURN_1;
}

forward InitShip();
public InitShip()
{
	//polaziste
 	BrodObjekt[0] = CreateDynamicObject(10794, 846.754455, -2342.751220, 3.016040, -0.000007, -0.000000, -89.999977, -1, -1, -1, 600.00, 600.00);
	BrodObjekt[1] = CreateDynamicObject(10795, 846.744506, -2341.249755, 13.429050, -0.000007, -0.000000, -89.999977, -1, -1, -1, 600.00, 600.00);
	BrodObjekt[2] = CreateDynamicObject(10793, 846.692626, -2268.384521, 31.878173, -0.000007, 0.000000, -89.999977, -1, -1, -1, 600.00, 600.00);
	//dolaziste
	//MoveDynamicObject(BrodObjekt[0], 874.255065, -2014.910278, 3.016040, 1.5);
	//MoveDynamicObject(BrodObjekt[1], 874.245117, -2013.408813, 13.429050, 1.5);
	//MoveDynamicObject(BrodObjekt[2], 874.193237, -1940.543579, 31.878173, 1.5);
	
	MoveDynamicObject(BrodObjekt[0], 874.255065, -2213.552734, 3.016039, 1.5);
	MoveDynamicObject(BrodObjekt[1], 874.245117, -2212.051269, 13.429050, 1.5);
	MoveDynamicObject(BrodObjekt[2], 874.193237, -2139.186035, 31.878173, 1.5);
	Part = 1;
	KretanjeBroda = KA_DOLAZISTU;
	return 1;
}

forward BrodPolaziste();
public BrodPolaziste()
{
    DestroyDynamicObject(OdredisteObj[0]);
	DestroyDynamicObject(OdredisteObj[1]);
	// Ka polazistu koordinate
	//MoveDynamicObject(BrodObjekt[0], 846.754455, -2342.751220, 3.016040, 1.5);
	//MoveDynamicObject(BrodObjekt[1], 846.744506, -2341.249755, 13.429050, 1.5);
	//MoveDynamicObject(BrodObjekt[2], 846.692626, -2268.384521, 31.878173, 1.5);
	MoveDynamicObject(BrodObjekt[0], 874.255065, -2213.552734, 3.016039, 1.5);
	MoveDynamicObject(BrodObjekt[1], 874.245117, -2212.051269, 13.429050, 1.5);
	MoveDynamicObject(BrodObjekt[2], 874.193237, -2139.186035, 31.878173, 1.5);
	Part = 1;
	KretanjeBroda = KA_POLAZISTU;
	/*foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 60.0, 817.683654, -2387.083740, 8.251288) || IsPlayerInRangeOfPoint(i, 60.0, 844.423278, -1999.452026, 11.733712))
			SendClientMessage(i, SVETLOCRVENA, "Brod Isplovljava iz Luke, ide ka obali.."); // Test Message
	}*/
    return 1;
}

/*forward BrodPolazisteMin();
public BrodPolazisteMin()
{
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, 817.683654, -2387.083740, 8.251288) || IsPlayerInRangeOfPoint(i, 30.0, 844.423278, -1999.452026, 11.733712))
			SendClientMessage(i, SVETLOCRVENA, "Brod uskoro isplovljava iz luke ka obali."); // Test Message
	}
    return 1;
}*/

forward BrodDolaziste();
public BrodDolaziste()
{
	DestroyDynamicObject(PolazisteObj[0]);
	DestroyDynamicObject(PolazisteObj[1]);
	//Ka dolazistu koordinate
	MoveDynamicObject(BrodObjekt[0], 874.255065, -2213.552734, 3.016039, 1.5);
	MoveDynamicObject(BrodObjekt[1], 874.245117, -2212.051269, 13.429050, 1.5);
	MoveDynamicObject(BrodObjekt[2], 874.193237, -2139.186035, 31.878173, 1.5);
	//MoveDynamicObject(BrodObjekt[0], 874.255065, -2014.910278, 3.016040, 1.5);
	//MoveDynamicObject(BrodObjekt[1], 874.245117, -2013.408813, 13.429050, 1.5);
	//MoveDynamicObject(BrodObjekt[2], 874.193237, -1940.543579, 31.878173, 1.5);
	Part = 1;
	KretanjeBroda = KA_DOLAZISTU;
	/*foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, 817.683654, -2387.083740, 8.251288) || IsPlayerInRangeOfPoint(i, 30.0, 844.423278, -1999.452026, 11.733712))
			SendClientMessage(i, SVETLOCRVENA, "Brod Isplovljava iz Luke polazista, ide ka dolazistu.."); // Test Message
	}*/
    return 1;
}
/*
forward BrodDolazisteMin();
public BrodDolazisteMin()
{
	foreach(new i : Player)
	{
		if(IsPlayerInRangeOfPoint(i, 30.0, 817.683654, -2387.083740, 8.251288) || IsPlayerInRangeOfPoint(i, 30.0, 844.423278, -1999.452026, 11.733712))
			SendClientMessage(i, SVETLOCRVENA, "Brod uskoro isplovljava iz luke polazista."); // Test Message
	}
    return 1;
}
*/
hook OnDynamicObjectMoved(objectid)
{
    new fID = GetFactionIDbyName("West End Gang");

	if (objectid == BrodObjekt[0] && KretanjeBroda == KA_DOLAZISTU)
	{
		if(Part == 1)
		{
			MoveDynamicObject(BrodObjekt[0], 874.255065, -2014.910278, 3.016040, 1.5);
			MoveDynamicObject(BrodObjekt[1], 874.245117, -2013.408813, 13.429050, 1.5);
			MoveDynamicObject(BrodObjekt[2], 874.193237, -1940.543579, 31.878173, 1.5);
			Part = 2;
		}
		else if(Part == 2)
		{
			OdredisteObj[0] = CreateDynamicObject(18981, 844.423278, -1999.452026, 11.733712, 0.000000, 86.300003, 0.000000, -1, -1, -1, 600.00, 600.00); 
			SetDynamicObjectMaterial(OdredisteObj[0], 0, 16640, "a51", "sl_metalwalk", 0x00000000);
			OdredisteObj[1] = CreateDynamicObject(18981, 869.325927, -1999.452026, 11.883513, 0.000000, 92.900009, 0.000000, -1, -1, -1, 600.00, 600.00); 
			SetDynamicObjectMaterial(OdredisteObj[1], 0, 16640, "a51", "sl_metalwalk", 0x00000000);
			SetTimer("BrodPolaziste", Min(1)+500, false);
			//SetTimer("BrodPolazisteMin", 750, false);
			foreach(new i : Player)
			{
				if(fID == GetPlayerFactionID(i))
					SendClientMessage(i, SVETLOCRVENA, "Brod je upravo stigao na obalu. Bice na lokaciji 5 Minuta te nakon toga krece ka odredistu.");
			}
		}
        //SendClientMessageToAll(-1, "Brod je upravo stigao na dolaziste. Bice na lokaciji 5 Minuta nakon toga krece se ka Polazistu."); // Test Message
	}
    else if (objectid == BrodObjekt[0] && KretanjeBroda == KA_POLAZISTU)
	{
		if(Part == 1)
		{
			MoveDynamicObject(BrodObjekt[0], 846.754455, -2342.751220, 3.016040, 1.5);
			MoveDynamicObject(BrodObjekt[1], 846.744506, -2341.249755, 13.429050, 1.5);
			MoveDynamicObject(BrodObjekt[2], 846.692626, -2268.384521, 31.878173, 1.5);
			Part = 2;
		}
		else if(Part == 2)
		{
			PolazisteObj[0] = CreateDynamicObject(18981, 817.683654, -2387.083740, 8.251288, 0.000000, 70.000000, 0.000000, -1, -1, -1, 600.00, 600.00); 
			SetDynamicObjectMaterial(PolazisteObj[0], 0, 16640, "a51", "sl_metalwalk", 0x00000000);
			PolazisteObj[1] = CreateDynamicObject(18981, 841.426147, -2387.083740, 9.410073, 0.000000, 104.600013, 0.000000, -1, -1, -1, 600.00, 600.00); 
			SetDynamicObjectMaterial(PolazisteObj[1], 0, 16640, "a51", "sl_metalwalk", 0x00000000);

			SetTimer("BrodDolaziste", Min(1)+500, false);
			//SetTimer("BrodDolazisteMin", 750, false);
			foreach(new i : Player)
			{
				if(fID == GetPlayerFactionID(i))
					SendClientMessage(i, SVETLOCRVENA, "Brod je upravo stigao na odrediste. Bice na lokaciji 5 Minuta te nakon toga krece ka obali.");
			}
		}	
    }
	return Y_HOOKS_CONTINUE_RETURN_1;
}
