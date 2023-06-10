#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MATS_PACKET_PRICE   1550 // Cena paketa neobradjenih materijala
#define MATS_PACKAGE_COUNT  500  // Koliko se materijala dobije kada se obradi paket



// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
static 
    DILER_brod_materijaliCP,
    DILER_brod_busilicaCP,
    DILER_fabrikaCP;




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnGameModeInit()
{
    DILER_brod_materijaliCP    = CreateDynamicCP(2838.0007, -2407.3162, 1.9699, 0.9, -1, -1, -1, 10.0); // Kupovina materijala
    DILER_brod_busilicaCP      = CreateDynamicCP(2837.7942, -2385.0515, 2.3328, 0.9, -1, -1, -1, 10.0); // Kupovina busilice
    DILER_fabrikaCP            = CreateDynamicCP(1064.3727, 2127.6003, 10.8203, 0.9, -1, -1, -1, 10.0); // Fabrika - izrada

    CreateDynamic3DTextLabel("Izrada bombe\n{FFFF00}Prerada materijala", NARANDZASTA, 1064.3727, 2127.6003, 10.8203,  20.0);


    // Pickup na mestu CP-a za materijale, jer CP propada dole u vodu
    CreateDynamic3DTextLabel("Kupovina materijala", NARANDZASTA, 2838.0007, -2407.3162, 1.9699,  20.0);


    CreateDynamicActor(179, -1316.7979,2509.5366,87.0420,0.0, 1, 100.0, 0, 0); // actor prodaja municije

    // Actori koji imitirjau igrace (stoje i pricaju)
    new actor;
    actor = CreateDynamicActor(179, -1311.4224, 2524.9846, 87.4917, 191.5266, 1, 100.0, 0, 0);
    ApplyDynamicActorAnimation(actor, "PED", "IDLE_CHAT", 4.0, 1, 0, 0, 1, 1);
    actor = CreateDynamicActor(179, -1319.5656, 2517.7366, 87.1620, 267.7065, 1, 100.0, 0, 0);
    ApplyDynamicActorAnimation(actor, "PED", "IDLE_CHAT", 4.0, 1, 0, 0, 1, 1);
    return true;
}

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == DILER_brod_materijaliCP)
    {
        if (IsNewPlayer(playerid))
        {
            ErrorMsg(playerid, "Novim igracima nije dozvoljena kupovina materijala. Morate imati najmanje 20 sati igre.");
            return ~1;
        }

        SPD(playerid, "DILER_buyMats", DIALOG_STYLE_MSGBOX, "Kupovina materijala", "{FFFFFF}Pakovanje materijala (0.5 kg) kosta {FF0000}$"#MATS_PACKET_PRICE, "Kupi", "Odustani");
        return ~1;
    }

    if (checkpointid == DILER_brod_busilicaCP)
    {
        if (PI[playerid][p_novac] < 20000)
        {
            ErrorMsg(playerid, "Nemate dovoljno novca.");
            return 1;
        }

        if (BP_PlayerItemGetCount(playerid, ITEM_DRILL))
            return ErrorMsg(playerid, "Mozete nositi samo jednu busilicu.");

        SPD(playerid, "DRILL_buy", DIALOG_STYLE_MSGBOX, "Crno trziste", "Da li zelite kupiti busilicu za $20000?", "Da", "Ne");
        return ~1;
    }

    // Prerada materijala/izrada bombe  
    else if (checkpointid == DILER_fabrikaCP)
    {
        SPD(playerid, "DILER_prerada", DIALOG_STYLE_LIST, "Fabrika oruzja", "Izrada bombe\nObrada materijala", "Dalje", "Izadji");
        return ~1;
    }
    return 1;
}

hook OnProgressFinish(playerid)
{
    if (IsPlayerInDynamicCP(playerid, DILER_fabrikaCP) || GetPVarInt(playerid, "pUsingMafiaGS"))
    {
        BP_PlayerItemSub(playerid, ITEM_RAW_MATS);
        BP_PlayerItemAdd(playerid, ITEM_MATERIALS, MATS_PACKAGE_COUNT);

        new sMsg[95];
        format(sMsg, sizeof sMsg, "Obrada materijala je zavrsena~N~Ranac: ~b~%.1f ~W~kg~N~~N~Komanda za izradu oruzja: ~R~/gun", BP_PlayerItemGetCount(playerid, ITEM_MATERIALS)/1000.0);
        ptdServerTips_ShowMsg(playerid, .title = "Materijali obradjeni", .msg = sMsg, .lines = 4, .durationMs = 15000);
        return ~1;
    }
    return 1;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) 
{
    if (GetPVarInt(playerid, "pMakeGun"))
    {
        DeletePVar(playerid, "pMakeGun");

        if (clickedid == tdMakeGun[10])
        {
            // Desert Eagle

            if (BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) < 1500)
            {
                ErrorMsg(playerid, "Nemate dovoljno materijala za ovo oruzje.");
            }
            else
            {
                GivePlayerWeapon(playerid, WEAPON_DEAGLE, 30);
                BP_PlayerItemSub(playerid, ITEM_MATERIALS, 1500);
            }
        }

        else if (clickedid == tdMakeGun[11])
        {
            // MP5

            if (BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) < 3000)
            {
                ErrorMsg(playerid, "Nemate dovoljno materijala za ovo oruzje.");
            }
            else
            {
                GivePlayerWeapon(playerid, WEAPON_MP5, 100);
                BP_PlayerItemSub(playerid, ITEM_MATERIALS, 3000);
            }
        }

        else if (clickedid == tdMakeGun[12])
        {
            // M4

            if (BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) < 4500)
            {
                ErrorMsg(playerid, "Nemate dovoljno materijala za ovo oruzje.");
            }
            else
            {
                GivePlayerWeapon(playerid, WEAPON_M4, 85);
                BP_PlayerItemSub(playerid, ITEM_MATERIALS, 4500);
            }
        }

        else if (clickedid == tdMakeGun[13])
        {
            // AK-47

            if (BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) < 4500)
            {
                ErrorMsg(playerid, "Nemate dovoljno materijala za ovo oruzje.");
            }
            else
            {
                GivePlayerWeapon(playerid, WEAPON_AK47, 85);
                BP_PlayerItemSub(playerid, ITEM_MATERIALS, 4500);
            }
        }

        CancelSelectTextDraw(playerid);
        for__loop (new i = 0; i < sizeof tdMakeGun; i++)
        {
            TextDrawHideForPlayer(playerid, tdMakeGun[i]);
        }
    }

    return 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //





// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:DILER_buyMats(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (PI[playerid][p_novac] < MATS_PACKET_PRICE)
    {
        ErrorMsg(playerid, "Nemate dovoljno novca.");
        return DialogReopen(playerid);
    }

    if (BP_PlayerItemGetCount(playerid, ITEM_RAW_MATS))
        return ErrorMsg(playerid, "Mozete nositi samo 1 paket neobradjenih materijala.");

    PlayerMoneySub(playerid, MATS_PACKET_PRICE);
    BP_PlayerItemAdd(playerid, ITEM_RAW_MATS, 1);
    InfoMsg(playerid, "Kupili ste paket materijala za %s.", formatMoneyString(MATS_PACKET_PRICE));
    SendClientMessage(playerid, BELA, "* Idite u {FF9933}fabriku oruzja {FFFFFF}i obradite materijale da biste mogli da pravite oruzje.");
    return 1;
}

Dialog:DRILL_buy(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    PlayerMoneySub(playerid, 20000);
    BP_PlayerItemAdd(playerid, ITEM_DRILL, 1);
    InfoMsg(playerid, "Kupili ste busilicu za %s.", formatMoneyString(20000));
    return 1;
}

Dialog:DILER_prerada(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    if (listitem == 0)
    {
        return callcmd::napravibombu(playerid, ""); // .\core\explosive.pwn
    }
    else if (listitem == 1) // Prerada materijala
    {
        if (!BP_PlayerItemGetCount(playerid, ITEM_RAW_MATS))
            return ErrorMsg(playerid, "Nemate neobradjene materijale u rancu. Kupite ih na crnom trzistu.");

        if ((BP_PlayerItemGetCount(playerid, ITEM_MATERIALS) + MATS_PACKAGE_COUNT) > BP_GetItemCountLimit(ITEM_MATERIALS))
            return ErrorMsg(playerid, "Imate previse obradjenih materijala u rancu. Potrosite neke pre nego sto obradite novi paket!");

        StartCenterProgress(playerid, "Obrada materijala...", 20*1000);
    }
    return 1;
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:gun(playerid, const params[])
{
    if (!BP_PlayerItemGetCount(playerid, ITEM_MATERIALS))
        return ErrorMsg(playerid, "Nemate materijale za oruzje.");

    for__loop (new i = 0; i < sizeof tdMakeGun; i++)
    {
        TextDrawShowForPlayer(playerid, tdMakeGun[i]);
    }

    SetPVarInt(playerid, "pMakeGun", 1);
    SelectTextDraw(playerid, 0xF2E4AEFF);
    return 1;
}