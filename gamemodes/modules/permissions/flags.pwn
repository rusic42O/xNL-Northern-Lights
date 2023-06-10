#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define PlayerFlagSet(%0,%1) pFlags[%0] |= %1
#define PlayerFlagClear(%0,%1) pFlags[%0] &= ~%1
#define PlayerFlagGet(%0,%1) (((pFlags[%0]) & (%1)) == (%1))
#define PlayerFlagGetEx(%0,%1) (((%0) & (%1)) == (%1))
#define PlayerFlagToggle(%0,%1) pFlags[%0] ^= %1
#define PlayerFlagsClearAll(%0) pFlags[%0] = 0b00000000000000000000000000000000




// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //
enum (<<= 1)
{
    // Osnovni flagovi
    FLAG_PLAYER = 1,
    FLAG_HELPER_1,
    FLAG_HELPER_2,
    FLAG_HELPER_3,
    FLAG_HELPER_4,
    FLAG_ADMIN_1,
    FLAG_ADMIN_2,
    FLAG_ADMIN_3,
    FLAG_ADMIN_4,
    FLAG_ADMIN_5,
    FLAG_ADMIN_6,
    FLAG_VIP_1,
    FLAG_VIP_2,
    FLAG_VIP_3,
    FLAG_VIP_4,
    FLAG_PROMO_1,
    FLAG_PROMO_2,
    FLAG_PROMO_3,
    FLAG_FACTION_LEADER,

    // Custom flagovi / zaduzenja
    FLAG_DJ,
    FLAG_HELPER_VODJA,
    FLAG_ADMIN_VODJA,
    FLAG_PROMO_VODJA,
    FLAG_LEADER_VODJA,
    FLAG_SPEC_ADMIN, //24
    FLAG_RNL_LEADER, //25
    FLAG_RNL_MEMBER, //26
    FLAG_MAPER, // 27
    FLAG_YOUTUBER, // 28
}




// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pFlags[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
	PlayerFlagsClearAll(playerid);
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
nl_public FLAGS_SetupCustomFlags(playerid)
{
    pFlags[playerid] |= PI[playerid][p_custom_flags];
    return 1;
}

nl_public FLAGS_SetupVIPFlags(playerid)
{
	// Oduzimamo sve VIP flagove
    PlayerFlagClear(playerid, FLAG_VIP_4);
    PlayerFlagClear(playerid, FLAG_VIP_3);
    PlayerFlagClear(playerid, FLAG_VIP_2);
    PlayerFlagClear(playerid, FLAG_VIP_1);

    // Ako je igrac YOUTUBER, automatski dobija VIP 3
    if (PlayerFlagGet(playerid, FLAG_YOUTUBER))
        PI[playerid][p_vip_level] = 3;

    // Postavljamo VIP flagove
    if (IsVIP(playerid, 4))
        PlayerFlagSet(playerid, FLAG_VIP_4);

    if (IsVIP(playerid, 3))
        PlayerFlagSet(playerid, FLAG_VIP_3);

    if (IsVIP(playerid, 2))
        PlayerFlagSet(playerid, FLAG_VIP_2);

    if (IsVIP(playerid, 1))
        PlayerFlagSet(playerid, FLAG_VIP_1);

    return 1;
}

nl_public FLAGS_SetupPromoterFlags(playerid)
{
    // Oduzimamo sve Promo flagove
    PlayerFlagClear(playerid, FLAG_PROMO_3);
    PlayerFlagClear(playerid, FLAG_PROMO_2);
    PlayerFlagClear(playerid, FLAG_PROMO_1);

    // Postavljamo Promo flagove
    if (IsPromoter(playerid, 3))
        PlayerFlagSet(playerid, FLAG_PROMO_3);

    if (IsPromoter(playerid, 2))
        PlayerFlagSet(playerid, FLAG_PROMO_2);

    if (IsPromoter(playerid, 1))
        PlayerFlagSet(playerid, FLAG_PROMO_1);

    return 1;
}

nl_public FLAGS_SetupStaffFlags(playerid)
{
	// Oduzimamo sve Admin flagove
	PlayerFlagClear(playerid, FLAG_ADMIN_6);
	PlayerFlagClear(playerid, FLAG_ADMIN_5);
	PlayerFlagClear(playerid, FLAG_ADMIN_4);
	PlayerFlagClear(playerid, FLAG_ADMIN_3);
	PlayerFlagClear(playerid, FLAG_ADMIN_2);
	PlayerFlagClear(playerid, FLAG_ADMIN_1);

	// Oduzimamo sve Helper flagove
	PlayerFlagClear(playerid, FLAG_HELPER_4);
	PlayerFlagClear(playerid, FLAG_HELPER_3);
	PlayerFlagClear(playerid, FLAG_HELPER_2);
	PlayerFlagClear(playerid, FLAG_HELPER_1);

	// Postavljamo Admin flagove
	if (IsAdmin(playerid, 6))
		PlayerFlagSet(playerid, FLAG_ADMIN_6);

	if (IsAdmin(playerid, 5))
		PlayerFlagSet(playerid, FLAG_ADMIN_5);

	if (IsAdmin(playerid, 4))
		PlayerFlagSet(playerid, FLAG_ADMIN_4);

	if (IsAdmin(playerid, 3))
		PlayerFlagSet(playerid, FLAG_ADMIN_3);

	if (IsAdmin(playerid, 2))
		PlayerFlagSet(playerid, FLAG_ADMIN_2);

	if (IsAdmin(playerid, 1))
		PlayerFlagSet(playerid, FLAG_ADMIN_1);

	// Postavljamo Helper flagove
	if (IsHelper(playerid, 4))
		PlayerFlagSet(playerid, FLAG_HELPER_4);

	if (IsHelper(playerid, 3))
		PlayerFlagSet(playerid, FLAG_HELPER_3);
 
	if (IsHelper(playerid, 2))
		PlayerFlagSet(playerid, FLAG_HELPER_2);

	if (IsHelper(playerid, 1))
		PlayerFlagSet(playerid, FLAG_HELPER_1);


    // Ako je igrac MAPER, automatski dobija H3
    if (PlayerFlagGet(playerid, FLAG_MAPER))
    {
        PlayerFlagSet(playerid, FLAG_HELPER_1);
        PlayerFlagSet(playerid, FLAG_HELPER_2);
        PlayerFlagSet(playerid, FLAG_HELPER_3);
    }

    return 1;
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //
forward MySQL_Zaduzenja(playerid, ccinc);
public MySQL_Zaduzenja(playerid, ccinc)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (!rows) 
        return ErrorMsg(playerid, "Nisu pronadjeni igraci sa posebnim zaduzenjima.");

    new string[1024];
    format(string, sizeof string, "Igrac\tZaduzenja");
    for__loop (new i = 0; i < rows; i++)
    {
        new ime[MAX_PLAYER_NAME], flags;
        cache_get_value_index(i, 0, ime, sizeof ime);
        cache_get_value_index_int(i, 1, flags);

        #define CheckFlag(%0) (((flags) & (%0)) == (%0))

        new sZaduzenja[128];
        sZaduzenja[0] = EOS;
        if (CheckFlag(FLAG_DJ))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | DJ", sZaduzenja);
        }
        if (CheckFlag(FLAG_HELPER_VODJA))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Helperi", sZaduzenja);
        }
        if (CheckFlag(FLAG_ADMIN_VODJA))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Admini", sZaduzenja);
        }
        if (CheckFlag(FLAG_PROMO_VODJA))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Promoteri", sZaduzenja);
        }
        if (CheckFlag(FLAG_LEADER_VODJA))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Lideri", sZaduzenja);
        }
        if (CheckFlag(FLAG_SPEC_ADMIN))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Spec Admin", sZaduzenja);
        }
        if (CheckFlag(FLAG_RNL_LEADER))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | RNL Leader", sZaduzenja);
        }
        if (CheckFlag(FLAG_RNL_MEMBER))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | RNL Novinar", sZaduzenja);
        }
        if (CheckFlag(FLAG_RNL_MEMBER))
        {
            format(sZaduzenja, sizeof sZaduzenja, "%s | Maper", sZaduzenja);
        }
        strdel(sZaduzenja, 0, 3);

        format(string, sizeof string, "%s\n%s\t%s", string, ime, sZaduzenja);
    }

    SPD(playerid, "zaduzenja", DIALOG_STYLE_TABLIST_HEADERS, "Igraci sa zaduzenjima", string, "Izmeni", "Izadji");
    return 1;
}

forward MySQL_ZaduzenjaPlayer(playerid, ccinc, playerOnline);
public MySQL_ZaduzenjaPlayer(playerid, ccinc, playerOnline)
{
    if (!checkcinc(playerid, ccinc))
        return 1;

    cache_get_row_count(rows);
    if (!rows) 
        return ErrorMsg(playerid, "Igrac nije pronadjen.");

    new flags, playerName[MAX_PLAYER_NAME], dbId;
    cache_get_value_index_int(0, 0, dbId);
    cache_get_value_index(0, 1, playerName, sizeof playerName);
    cache_get_value_index_int(0, 2, flags);

    if (!playerOnline)
    {
        SetPVarInt(playerid, "pSetFlags_ID", dbId);
        SetPVarInt(playerid, "pSetFlags_Cinc", -1); // oznacava da se izmenjuje offline igrac
        SetPVarInt(playerid, "pSetFlags_Flags", flags);
    }
    SetPVarString(playerid, "pSetFlags_Name", playerName);

    #define CheckFlag(%0) (((flags) & (%0)) == (%0))

    new sDialog[52*10]; // 10 je broj linija koje se pojavljuju
    format(sDialog, sizeof sDialog, "\
        {000000}%i\t{FFFFFF}DJ\t%s\n\
        {000000}%i\t{FFFFFF}Vodja helpera\t%s\n\
        {000000}%i\t{FFFFFF}Vodja admina\t%s\n\
        {000000}%i\t{FFFFFF}Vodja lidera\t%s\n\
        {000000}%i\t{FFFFFF}Vodja promotera\t%s\n\
        {000000}%i\t{FFFFFF}Spec Admin\t%s\n\
        {000000}%i\t{FFFFFF}RNL Leader\t%s\n\
        {000000}%i\t{FFFFFF}RNL Novinar\t%s\n\
        {000000}%i\t{FFFFFF}Maper\t%s\n\
        {000000}%i\t{FFFFFF}YouTuber\t%s",
        FLAG_DJ, (CheckFlag(FLAG_DJ)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_HELPER_VODJA, (CheckFlag(FLAG_HELPER_VODJA)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_ADMIN_VODJA, (CheckFlag(FLAG_ADMIN_VODJA)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_LEADER_VODJA, (CheckFlag(FLAG_LEADER_VODJA)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_PROMO_VODJA, (CheckFlag(FLAG_PROMO_VODJA)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_SPEC_ADMIN, (CheckFlag(FLAG_SPEC_ADMIN)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_RNL_LEADER, (CheckFlag(FLAG_RNL_LEADER)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_RNL_MEMBER, (CheckFlag(FLAG_RNL_MEMBER)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_MAPER, (CheckFlag(FLAG_MAPER)? ("{00FF00}DA") : ("{FF0000}NE")),
        FLAG_YOUTUBER, (CheckFlag(FLAG_YOUTUBER)? ("{00FF00}DA") : ("{FF0000}NE")));

    SPD(playerid, "flags_zaduzenja", DIALOG_STYLE_TABLIST, playerName, sDialog, "Daj/skini", "Odustani");
    return 1;
}




// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //
Dialog:zaduzenja(playerid, response, listitem, const inputtext[])
{
    if (!response) return 1;

    new SendClientMessaged[11 + MAX_PLAYER_NAME];
    format(SendClientMessaged, sizeof SendClientMessaged, "%s", inputtext);
    callcmd::zaduzenja(playerid, SendClientMessaged);
    return 1;
}

Dialog:flags_zaduzenja(playerid, response, listitem, const inputtext[])
{
    if (!response) 
    {
        DeletePVar(playerid, "pSetFlags_ID");
        DeletePVar(playerid, "pSetFlags_Cinc");
        return 1;
    }

    new 
        flag = strval(inputtext), 
        flagName[22],
        targetid = INVALID_PLAYER_ID,
        dbId = GetPVarInt(playerid, "pSetFlags_ID"),
        sPlayerName[MAX_PLAYER_NAME]
    ;

    GetPVarString(playerid, "pSetFlags_Name", sPlayerName, sizeof sPlayerName);

    foreach (new i : Player)
    {
        if (IsPlayerLoggedIn(i) && PI[i][p_id] == dbId && checkcinc(i, GetPVarInt(playerid, "pSetFlags_Cinc")))
        {
            targetid = i;
            break;
        }
    }

    if (flag == FLAG_DJ) flagName = "DJ";
    else if (flag == FLAG_HELPER_VODJA) flagName = "vodja helpera";
    else if (flag == FLAG_ADMIN_VODJA) flagName = "vodja admina";
    else if (flag == FLAG_LEADER_VODJA) flagName = "vodja lidera";
    else if (flag == FLAG_PROMO_VODJA) flagName = "vodja promotera";
    else if (flag == FLAG_SPEC_ADMIN) flagName = "spec admin";
    else if (flag == FLAG_RNL_LEADER) flagName = "RNL Leader";
    else if (flag == FLAG_RNL_MEMBER) flagName = "RNL Novinar";
    else if (flag == FLAG_MAPER) flagName = "Maper";
    else if (flag == FLAG_YOUTUBER) flagName = "YouTuber";
    else flagName = "Nepoznato";


    new flags;
    if (IsPlayerConnected(targetid))
    {
        PI[targetid][p_custom_flags] ^= flag;
        flags = PI[targetid][p_custom_flags];
        FLAGS_SetupCustomFlags(targetid);


        SendClientMessageF(playerid, SVETLOPLAVA, "* Igracu %s[%i] ste %s {33CCFF}zaduzenje: {FFFFFF}%s.", ime_rp[targetid], targetid, (PlayerFlagGetEx(PI[targetid][p_custom_flags], flag)? ("{00FF00}dodelili") : ("{FF0000}oduzeli")), flagName);
        SendClientMessageF(targetid, SVETLOPLAVA, "* Head Admin %s[%i] Vam je %s {33CCFF}zaduzenje: {FFFFFF}%s.", ime_rp[playerid], playerid, (PlayerFlagGetEx(PI[targetid][p_custom_flags], flag)? ("{00FF00}dodelio") : ("{FF0000}oduzeo")), flagName);
    }
    else
    {
        flags = GetPVarInt(playerid, "pSetFlags_Flags");
        flags ^= flag;

        SendClientMessageF(playerid, SVETLOPLAVA, "* Igracu %s ste %s {33CCFF}zaduzenje: {FFFFFF}%s.", sPlayerName, (PlayerFlagGetEx(flags, flag)? ("{00FF00}dodelili") : ("{FF0000}oduzeli")), flagName);
    }

    new sQuery[70];
    format(sQuery, sizeof sQuery, "UPDATE igraci SET custom_flags = %i WHERE id = %i", flags, dbId);
    mysql_tquery(SQL, sQuery);

    new cmdParams[11 + MAX_PLAYER_NAME];
    format(cmdParams, sizeof cmdParams, "%s", sPlayerName);
    return callcmd::zaduzenja(playerid, cmdParams);
}




// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
flags:zaduzenja(FLAG_ADMIN_6)
CMD:zaduzenja(playerid, const params[])
{
    if (isnull(params))
    {
        // Unesena je komanda bez parametara
        mysql_tquery(SQL, "SELECT ime, custom_flags FROM igraci WHERE custom_flags > 0", "MySQL_Zaduzenja", "ii", playerid, cinc[playerid]);
    }
    else
    {
        // Uneo je ID online igraca ili ime offline igraca

        if (!IsAdmin(playerid, 6))
            return ErrorMsg(playerid, GRESKA_NEMADOZVOLU);

        new id;
        sscanf(params, "u", id);

        if (IsPlayerConnected(id))
        {
            // Uneo je ime/id online igraca

            SetPVarInt(playerid, "pSetFlags_ID", PI[id][p_id]);
            SetPVarInt(playerid, "pSetFlags_Cinc", cinc[id]);

            new sQuery[58];
            format(sQuery, sizeof sQuery, "SELECT id, ime, custom_flags FROM igraci WHERE id = %i", PI[id][p_id]);
            mysql_tquery(SQL, sQuery, "MySQL_ZaduzenjaPlayer", "iii", playerid, cinc[playerid], 1);
        }
        else
        {
            // Uneo je ime offline igraca
            new sQuery[82];
            mysql_format(SQL, sQuery, sizeof sQuery, "SELECT id, ime, custom_flags FROM igraci WHERE ime = '%s'", params);
            mysql_tquery(SQL, sQuery, "MySQL_ZaduzenjaPlayer", "iii", playerid, cinc[playerid], 0);
        }
    }

    return 1;
}