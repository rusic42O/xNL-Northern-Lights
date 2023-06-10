#include <YSI_Coding\y_hooks>

new gPlayerUsingLoopingAnim[MAX_PLAYERS char];

hook OnPlayerConnect(playerid)
{
    gPlayerUsingLoopingAnim{playerid} = 0;
    return true;
}

hook OnPlayerDeath(playerid, reason) 
{
    if(gPlayerUsingLoopingAnim{playerid})
    {
        gPlayerUsingLoopingAnim{playerid} = 0;
        TextDrawHideForPlayer(playerid,tdAnimHelp);
    }
    return 1;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsKeyJustDown(KEY_HANDBRAKE, newkeys, oldkeys) && gPlayerUsingLoopingAnim{playerid} != 0)
    {
        StopLoopingAnim(playerid);
        TextDrawHideForPlayer(playerid, tdAnimHelp);
    }
    return true;
}

stock PreloadAnimLib(playerid, const animlib[])
{
    ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
}

stock OnePlayAnim(playerid, const animlib[], const animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    // Koriscenje komandi za animacije nije moguce u sledecim uslovima:
    if (IsPlayerRobbingJewelry(playerid) || IsPlayerPlantingBomb(playerid)) return 1;

    if (gPlayerUsingLoopingAnim{playerid} == 1)
    {
        TextDrawHideForPlayer(playerid, tdAnimHelp);
    }
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
    return 1;
}

stock LoopingAnim(playerid, const animlib[], const animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    // Koriscenje komandi za animacije nije moguce u sledecim uslovima:
    if (IsPlayerRobbingJewelry(playerid) || IsPlayerPlantingBomb(playerid)) return 1;

    if (ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp))
    {
        if (gPlayerUsingLoopingAnim{playerid} == 1)
        {
            TextDrawHideForPlayer(playerid, tdAnimHelp);
        }
        gPlayerUsingLoopingAnim{playerid} = 1;
        TextDrawShowForPlayer(playerid, tdAnimHelp);
    }
    return 1;
}

stock StopLoopingAnim(playerid)
{
    gPlayerUsingLoopingAnim{playerid} = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}




// ========================================================================== //
//                          <section> MySQL </section>                        //
// ========================================================================== //





// ========================================================================== //
//                        <section> Dijalozi </section>                       //
// ========================================================================== //





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
CMD:animacije(playerid, const params[])
{
    SendClientMessage(playerid, ZUTA, "________________________________________________________________________________________________________________________");
    //SendClientMessage(playerid, ZUTA, "---------------------------------------------------------------");
    SendClientMessage(playerid, SVETLOPLAVA, "Animacije:");
    SendClientMessage(playerid, BELA, "/fall /fallback /injured /akick /spush /lowbodypush /handsup /bomb /drunk /getarrested /laugh /sup");
    SendClientMessage(playerid, BELA, "/basket /headbutt /medic /spray /robman /taichi /lookout /kiss /crossarms /lay /piss /lean");
    SendClientMessage(playerid, BELA, "/deal /crack /groundsit /dance /fucku /strip /hide /vomit /eat /chairsit /reload");
    SendClientMessage(playerid, BELA, "/koface /kostomach /rollfall /carjacked1 /carjacked2 /rcarjack1 /rcarjack2 /lcarjack1 /lcarjack2 /bat");
    SendClientMessage(playerid, BELA, "/lifejump /exhaust /leftslap /carlock /hoodfrisked /lightcig /tapcig /lay2 /chant finger");
    SendClientMessage(playerid, BELA, "/shouting /knife /cop /kneekick /airkick /gkick /gpunch /fstance /lowthrow /highthrow /aim");
    SendClientMessage(playerid, BELA, "/inbedleft /inbedright");
    SendClientMessage(playerid, ZUTA, "________________________________________________________________________________________________________________________");

    return true;
}
CMD:carjacked1(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","CAR_jackedLHS",4.0,0,1,1,1,0); return 1; }
CMD:carjacked2(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","CAR_jackedRHS",4.0,0,1,1,1,0); return 1; }
CMD:handsup(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 1, 1, 1, 0); return 1; }
CMD:drunk(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","WALK_DRUNK",4.1,1,1,1,1,1); return 1; }
CMD:bomb(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0); return 1; }
CMD:getarrested(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1); return 1; }
CMD:laugh(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0); return 1; }
CMD:lookout(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0); return 1; }
CMD:robman(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:crossarms(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1); return 1; }
CMD:lay(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:hide(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0); return 1; }
CMD:vomit(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0); return 1; }
CMD:eat(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0); return 1; }
CMD:wave(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:slapass(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0); return 1; }
CMD:deal(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0); return 1; }
CMD:crack(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:groundsit(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0); return 1; }
// CMD:chat(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","IDLE_CHAT",4.0,1,0,0,1,1); return 1; }
CMD:fucku(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","fucku",4.0,0,0,0,0,0); return 1; }
CMD:taichi(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0); return 1; }
CMD:chairsit(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","SEAT_down",4.1,0,1,1,1,0); return 1; }
CMD:fall(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0); return 1; }
CMD:fallback(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:kiss(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "KISSING", "Playa_Kiss_02", 3.0, 1, 1, 1, 1, 0); return 1; }
CMD:injured(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0); return 1; }
CMD:spush(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0); return 1; }
CMD:akick(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0); return 1; }
CMD:lowbodypush(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0); return 1; }
CMD:spray(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"SPRAYCAN","spraycan_full",4.0,0,0,0,0,0); return 1; }
CMD:headbutt(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0); return 1; }
CMD:medic(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"MEDIC","CPR",4.0,0,0,0,0,0); return 1; }
CMD:koface(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","KO_shot_face",4.0,0,1,1,1,0); return 1; }
CMD:kostomach(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","KO_shot_stom",4.0,0,1,1,1,0); return 1; }
CMD:lifejump(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","EV_dive",4.0,0,1,1,1,0); return 1; }
CMD:exhaust(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0); return 1; }
CMD:leftslap(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0); return 1; }
CMD:rollfall(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"PED","BIKE_fallR",4.0,0,1,1,1,0); return 1; }
CMD:carlock(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","CAR_pulloutL_LHS",4.0,0,0,0,0,0); return 1; }
CMD:rcarjack1(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","CAR_pulloutL_LHS",4.0,0,0,0,0,0); return 1; }
CMD:lcarjack1(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","CAR_pulloutL_RHS",4.0,0,0,0,0,0); return 1; }
CMD:rcarjack2(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","CAR_pullout_LHS",4.0,0,0,0,0,0); return 1; }
CMD:lcarjack2(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"PED","CAR_pullout_RHS",4.0,0,0,0,0,0); return 1; }
CMD:hoodfrisked(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"POLICE","crm_drgbst_01",4.0,0,1,1,1,0); return 1; }
CMD:lightcig(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"SMOKING","M_smk_in",3.0,0,0,0,0,0); return 1; }
CMD:tapcig(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"SMOKING","M_smk_tap",3.0,0,0,0,0,0); return 1; }
CMD:bat(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"BASEBALL","Bat_IDLE",4.0,1,1,1,1,0); return 1; }
// CMD:box(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0); return 1; }
CMD:lay2(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"SUNBATHE","Lay_Bac_in",3.0,0,1,1,1,0); return 1; }
CMD:chant(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0); return 1; }
CMD:finger(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"RIOT","RIOT_FUKU",2.0,0,0,0,0,0); return 1; }
CMD:shouting(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"RIOT","RIOT_shout",4.0,1,0,0,0,0); return 1; }
CMD:cop(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"SWORD","sword_block",50.0,0,1,1,1,1); return 1; }
CMD:elblow(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"FIGHT_D","FightD_3",4.0,0,1,1,0,0); return 1; }
CMD:kneekick(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"FIGHT_D","FightD_2",4.0,0,1,1,0,0); return 1; }
CMD:fstance(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"FIGHT_D","FightD_IDLE",4.0,1,1,1,1,0); return 1; }
CMD:gpunch(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"FIGHT_B","FightB_G",4.0,0,0,0,0,0); return 1; }
CMD:airkick(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"FIGHT_C","FightC_M",4.0,0,1,1,0,0); return 1; }
CMD:gkick(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"FIGHT_D","FightD_G",4.0,0,0,0,0,0); return 1; }
CMD:lowthrow(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"GRENADE","WEAPON_throwu",3.0,0,0,0,0,0); return 1; }
CMD:highthrow(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; OnePlayAnim(playerid,"GRENADE","WEAPON_throw",4.0,0,0,0,0,0); return 1; }
CMD:dealstance(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"DEALER","DEALER_IDLE",4.0,1,0,0,0,0); return 1; }
CMD:piss(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING); return 1; }
CMD:clear(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0); return 1; }
CMD:inbedright(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"INT_HOUSE","BED_Loop_R",4.0,1,0,0,0,0); return 1; }
CMD:inbedleft(playerid, const params[]) { if(IsPlayerInAnyVehicle(playerid)) return 1; LoopingAnim(playerid,"INT_HOUSE","BED_Loop_L",4.0,1,0,0,0,0); return 1; }
CMD:sup(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "sup [1-3]");
    switch(stil)
    {
        case 1: OnePlayAnim(playerid,"GANGS","hndshkba",4.0,0,0,0,0,0);
        case 2: OnePlayAnim(playerid,"GANGS","hndshkda",4.0,0,0,0,0,0);
        case 3: OnePlayAnim(playerid,"GANGS","hndshkfa_swt",4.0,0,0,0,0,0);
    }
    return 1;
}
CMD:rap(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "rap [1-4]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"RAPPING","RAP_A_Loop",4.0,1,0,0,0,0);
        case 2: LoopingAnim(playerid,"RAPPING","RAP_C_Loop",4.0,1,0,0,0,0);
        case 3: LoopingAnim(playerid,"GANGS","prtial_gngtlkD",4.0,1,0,0,0,0);
        case 4: LoopingAnim(playerid,"GANGS","prtial_gngtlkH",4.0,1,0,0,1,1);
    }
    return 1;
}
CMD:strip(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "strip [1-7]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1 );
        case 2: LoopingAnim(playerid,"STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1 );
        case 3: LoopingAnim(playerid,"STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1 );
        case 4: LoopingAnim(playerid,"STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1 );
        case 5: LoopingAnim(playerid,"STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1 );
        case 6: LoopingAnim(playerid,"STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1 );
        case 7: LoopingAnim(playerid,"STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1 );
        default: Koristite(playerid, "strip [1-7]");
    }
    return 1;
}
CMD:dance(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "dance [1-4]");
    switch(stil)
    {
        case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
        case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
        case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
        case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
        default: Koristite(playerid, "dance [1-4]");
    }
    return 1;
}
CMD:knife(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "knife [1-4]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"KNIFE","KILL_Knife_Ped_Damage",4.0,0,1,1,1,0);
        case 2: LoopingAnim(playerid,"KNIFE","KILL_Knife_Ped_Die",4.0,0,1,1,1,0);
        case 3: OnePlayAnim(playerid,"KNIFE","KILL_Knife_Player",4.0,0,0,0,0,0);
        case 4: LoopingAnim(playerid,"KNIFE","KILL_Partial",4.0,0,1,1,1,1);
        default: Koristite(playerid, "knife [1-4]");
    }
    return 1;
}
CMD:basket(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "basket [1-6]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"BSKTBALL","BBALL_idleloop",4.0,1,0,0,0,0);
        case 2: OnePlayAnim(playerid,"BSKTBALL","BBALL_Jump_Shot",4.0,0,0,0,0,0);
        case 3: OnePlayAnim(playerid,"BSKTBALL","BBALL_pickup",4.0,0,0,0,0,0);
        case 4: LoopingAnim(playerid,"BSKTBALL","BBALL_run",4.1,1,1,1,1,1);
        case 5: LoopingAnim(playerid,"BSKTBALL","BBALL_def_loop",4.0,1,0,0,0,0);
        case 6: LoopingAnim(playerid,"BSKTBALL","BBALL_Dnk",4.0,1,0,0,0,0);
        default: Koristite(playerid, "basket [1-6]");
    }
    return 1;
}

CMD:gwalk(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "gwalk [1-2]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1);
        case 2: LoopingAnim(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1);
        default: Koristite(playerid, "gwalk [1-2]");
    }
    return 1;
}
CMD:aim(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "aim [1-3]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"PED","gang_gunstand",4.0,1,1,1,1,1);
        case 2: LoopingAnim(playerid,"PED","Driveby_L",4.0,0,1,1,1,1);
        case 3: LoopingAnim(playerid,"PED","Driveby_R",4.0,0,1,1,1,1);
        default: Koristite(playerid, "aim [1-3]");
    }
    return 1;
}
CMD:lean(playerid, const params[])
{
    if(IsPlayerInAnyVehicle(playerid)) return 1;
    new stil;
    if(sscanf(params, "i", stil)) return Koristite(playerid, "lean [1-2]");
    switch(stil)
    {
        case 1: LoopingAnim(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0);
        case 2: LoopingAnim(playerid,"MISC","Plyrlean_loop",4.0,0,1,1,1,0);
        default: Koristite(playerid, "lean [1-2]");
    }
    return 1;
}