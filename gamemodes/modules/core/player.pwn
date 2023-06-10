#include <YSI_Coding\y_hooks>

enum E_PLAYER_INFO
{
    p_id,
    p_ip[16],
    p_email[MAX_EMAIL_LEN],
    p_nivo,
    p_admin,
    p_helper,
    p_promoter,
    p_org_id,
    p_org_rank, // Ne cuva se u bazi
    p_org_vreme,
    p_org_kazna,
    p_novac,
    p_banka,
    p_token,
    p_zlato,
    p_iskustvo,
    p_payday,
    p_posao_zarada,
    p_posao_payday,
    p_kartica[17],
    p_kartica_pin,
    p_kredit_iznos,
    p_kredit_otplata,
    p_kredit_rata,
    p_mobilni[13],
    p_sim[11],
    p_sim_broj, // 0 = nema broj/karticu
    p_sim_kredit,
    Float:p_spawn_x,
    Float:p_spawn_y,
    Float:p_spawn_z,
    Float:p_spawn_a,
    Float:p_spawn_health,
    Float:p_spawn_armour,
    p_spawn_ent,
    p_spawn_vw,
    p_pol,
    p_starost,
    p_drzava[11],
    p_stil_borbe,
    p_stil_hodanja,
    p_naglasak[13],
    p_skin,
    p_glad,
    p_telefon,
    p_torba,
    p_zavezan,
    p_zatvor,
    p_zatvoren,
    p_area,
    p_area_razlog[33],
    p_utisan,
    p_utisan_razlog[33],
    p_kaznjen_puta,
    p_uhapsen_puta,
    p_opomene,
    p_offpm_ugasen,
    p_offpm_vreme,
    p_dozvola_voznja,
    p_dozvola_oruzje,
    p_dozvola_letenje,
    p_dozvola_plovidba,
    p_reload_market,
    p_reload_mehanicar,
    p_reload_bribe,
    p_reload_fv,
    p_reload_namechange,
    p_vozila_slotovi,
    p_imanja_slotovi,
    p_nekretnine_slotovi[6], // 6 vrsta nekretnina (kuca, stan, firma, hotel, garaza, vikendica)
    p_datum_registracije[22],
    p_poslednja_aktivnost[22],
    p_provedeno_vreme,
    p_kaucija,
    p_hotel_soba,
    p_hotel_cena, // 0 = ne renta nigde
    p_rent_kuca, // 0 = ne renta nigde
    p_rent_cena, // 0 = ne renta nigde
    p_war_ubistva,
    p_war_smrti,
    p_war_samoubistva,
    Float:p_war_dmg_taken,
    Float:p_war_dmg_given,
    p_hud,
    p_eksploziv,
    p_detonatori,
    p_bomba[3],
    p_wanted_level,
    p_pasos[11],
    p_pasos_ts,
    p_announcement,
    p_paketici,
    p_treasure_hunt,
    p_dj,
    p_promo_hashtag,
    p_reload_pay,
    p_reload_vehicle_theft,
    p_cheater,
    p_tuning_pass,
    p_custom_flags,
    p_referral[MAX_PLAYER_NAME],
    p_boja_imena,
    p_donacije,
    p_vip_level,
    p_vip_istice,
    p_vip_refill,
    p_vip_replenish,
    p_skill_cop,
    p_skill_criminal,
    p_division_points,
    p_division_expiry,
    p_division_treshold_up,
    p_division_treshold_dn,
    p_division_reload_up,
    p_division_reload_dn,
    p_robbed_atms,
    p_robbed_stores,
    p_stolen_cars,
    p_arrested_criminals,
    p_atm_stolen_cash,
    p_stores_stolen_cash,
    p_zabrana_oruzje,
    p_zabrana_lider,
    p_zabrana_staff,
    p_warn_dm,
    p_warn_turf_interrupt,
    p_warn_vip_abuse,
    p_pasos_bonus,
    p_vozacka_bonus,
    p_posao_bonus,
    p_nivo_bonus,
    p_org_bonus,
    p_discord_id[21],
    p_rudnik_zlato,
    p_odradio_posao,
    bool:p_nosi_gajbicu,
    p_gajbica,
    p_apples,
    p_peaches,
    p_oranges
};

new PI[MAX_PLAYERS][E_PLAYER_INFO];
new pHudStatus[MAX_PLAYERS char];

hook OnPlayerConnect(playerid)
{
    pHudStatus{playerid} = true;
    TDSelected{playerid} = false;

    return Y_HOOKS_CONTINUE_RETURN_1;
}
new const WebColorsRGBA[216] = {
		0x000000FF,0x000033FF,0x000066FF,0x000099FF,0x0000CCFF,0x0000FFFF,
		0x003300FF,0x003333FF,0x003366FF,0x003399FF,0x0033CCFF,0x0033FFFF,
		0x006600FF,0x006633FF,0x006666FF,0x006699FF,0x0066CCFF,0x0066FFFF,
		0x009900FF,0x009933FF,0x009966FF,0x009999FF,0x0099CCFF,0x0099FFFF,
		0x00CC00FF,0x00CC33FF,0x00CC66FF,0x00CC99FF,0x00CCCCFF,0x00CCFFFF,
		0x00FF00FF,0x00FF33FF,0x00FF66FF,0x00FF99FF,0x00FFCCFF,0x00FFFFFF,
		0x330000FF,0x330033FF,0x330066FF,0x330099FF,0x3300CCFF,0x3300FFFF,
		0x333300FF,0x333333FF,0x333366FF,0x333399FF,0x3333CCFF,0x3333FFFF,
		0x336600FF,0x336633FF,0x336666FF,0x336699FF,0x3366CCFF,0x3366FFFF,
		0x339900FF,0x339933FF,0x339966FF,0x339999FF,0x3399CCFF,0x3399FFFF,
		0x33CC00FF,0x33CC33FF,0x33CC66FF,0x33CC99FF,0x33CCCCFF,0x33CCFFFF,
		0x33FF00FF,0x33FF33FF,0x33FF66FF,0x33FF99FF,0x33FFCCFF,0x33FFFFFF,
		0x660000FF,0x660033FF,0x660066FF,0x660099FF,0x6600CCFF,0x6600FFFF,
		0x663300FF,0x663333FF,0x663366FF,0x663399FF,0x6633CCFF,0x6633FFFF,
		0x666600FF,0x666633FF,0x666666FF,0x666699FF,0x6666CCFF,0x6666FFFF,
		0x669900FF,0x669933FF,0x669966FF,0x669999FF,0x6699CCFF,0x6699FFFF,
		0x66CC00FF,0x66CC33FF,0x66CC66FF,0x66CC99FF,0x66CCCCFF,0x66CCFFFF,
		0x66FF00FF,0x66FF33FF,0x66FF66FF,0x66FF99FF,0x66FFCCFF,0x66FFFFFF,
		0x990000FF,0x990033FF,0x990066FF,0x990099FF,0x9900CCFF,0x9900FFFF,
		0x993300FF,0x993333FF,0x993366FF,0x993399FF,0x9933CCFF,0x9933FFFF,
		0x996600FF,0x996633FF,0x996666FF,0x996699FF,0x9966CCFF,0x9966FFFF,
		0x999900FF,0x999933FF,0x999966FF,0x999999FF,0x9999CCFF,0x9999FFFF,
		0x99CC00FF,0x99CC33FF,0x99CC66FF,0x99CC99FF,0x99CCCCFF,0x99CCFFFF,
		0x99FF00FF,0x99FF33FF,0x99FF66FF,0x99FF99FF,0x99FFCCFF,0x99FFFFFF,
		0xCC0000FF,0xCC0033FF,0xCC0066FF,0xCC0099FF,0xCC00CCFF,0xCC00FFFF,
		0xCC3300FF,0xCC3333FF,0xCC3366FF,0xCC3399FF,0xCC33CCFF,0xCC33FFFF,
		0xCC6600FF,0xCC6633FF,0xCC6666FF,0xCC6699FF,0xCC66CCFF,0xCC66FFFF,
		0xCC9900FF,0xCC9933FF,0xCC9966FF,0xCC9999FF,0xCC99CCFF,0xCC99FFFF,
		0xCCCC00FF,0xCCCC33FF,0xCCCC66FF,0xCCCC99FF,0xCCCCCCFF,0xCCCCFFFF,
		0xCCFF00FF,0xCCFF33FF,0xCCFF66FF,0xCCFF99FF,0xCCFFCCFF,0xCCFFFFFF,
		0xFF0000FF,0xFF0033FF,0xFF0066FF,0xFF0099FF,0xFF00CCFF,0xFF00FFFF,
		0xFF3300FF,0xFF3333FF,0xFF3366FF,0xFF3399FF,0xFF33CCFF,0xFF33FFFF,
		0xFF6600FF,0xFF6633FF,0xFF6666FF,0xFF6699FF,0xFF66CCFF,0xFF66FFFF,
		0xFF9900FF,0xFF9933FF,0xFF9966FF,0xFF9999FF,0xFF99CCFF,0xFF99FFFF,
		0xFFCC00FF,0xFFCC33FF,0xFFCC66FF,0xFFCC99FF,0xFFCCCCFF,0xFFCCFFFF,
		0xFFFF00FF,0xFFFF33FF,0xFFFF66FF,0xFFFF99FF,0xFFFFCCFF,0xFFFFFFFF
};


new webcolors[4096];
hook OnGameModeInit()
{
	for (new j = 0; j < 216; j++) format(webcolors, sizeof(webcolors), "%s{%06x}xxxx\n", webcolors, WebColorsRGBA[j] >>> 8);
	return true;
}

hook OnPlayerSpawn(playerid)
{
    SetPlayerColor(playerid, PI[playerid][p_boja_imena]);
    return Y_HOOKS_CONTINUE_RETURN_1;
}

Dialog:EditInfoBox(playerid, response, listitem, const inputtext[])
{
    if (!response)
        return 1;
    
    new
        header[11],
        info[40]
    ;

    sscanf(inputtext, "p<|>s[11]s[40]", header, info);

    UpdateAddon(header, info);
    return 1;
}

stock GetPlayerTextDrawState(playerid)
{
    if(pHudStatus{playerid})
        return 1;

    return 0;
}


CMD:td(playerid, const params[])
{
    SPD(playerid, "tdcontrol", DIALOG_STYLE_LIST, "TD Control", "Prikazi/Sakrij TD-ove\nPromeni Boju\nDefault", "Nastavi", "Otkazi");
    //SPD(playerid, "tdcontrol", DIALOG_STYLE_LIST, "TD Control", "Prikazi/Sakrij TD-ove", "Nastavi", "Otkazi");
    return 1;
}