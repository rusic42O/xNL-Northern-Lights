#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //
new pAktivnaIgra_Pts[MAX_PLAYERS];




// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //
hook OnPlayerConnect(playerid)
{
    pAktivnaIgra_Pts[playerid] = 0;
}




// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //
stock AKTIGRA_Restore(playerid, timestamp, poeni)
{
    if ((gettime() - timestamp) < 600 && poeni > 0)
    {
        pAktivnaIgra_Pts[playerid] = poeni;
    }
}

stock AKTIGRA_PtsInc(playerid, pts = 1)
{
    pAktivnaIgra_Pts[playerid] += pts;
}

stock AKTIGRA_GetPts(playerid)
{
    return pAktivnaIgra_Pts[playerid];
}

forward AKTIGRA_Check(playerid);
public AKTIGRA_Check(playerid)
{
    if (DebugFunctions())
    {
        LogFunctionExec("AKTIGRA_Check");
    }

    switch (pAktivnaIgra_Pts[playerid])
    {
        case 3: // $5.000 + 1exp + 2 skill
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 3 poena aktivne igre, dobijate {FFFFFF}$5.000 + 1 exp + 2 skill poena.");

            PI[playerid][p_iskustvo]++;
            PlayerMoneyAdd(playerid, 5000);

            if (IsACriminal(playerid))
            {
                PlayerUpdateCriminalSkill(playerid, 2, SKILL_SILENT, 0);
            }
            else if (IsACop(playerid))
            {
                PlayerUpdateCopSkill(playerid, 2, SKILL_SILENT, 0);
            }

            new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
            if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
            {
                PI[playerid][p_nivo]++;
                SetPlayerScore(playerid, PI[playerid][p_nivo]);
                PI[playerid][p_iskustvo] = 0;
                SendClientMessageF(playerid, ZUTA, "** LEVEL UP | Sada ste nivo {FFFFFF}%d.", PI[playerid][p_nivo]);
            }
            new sQuery[90];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %d, iskustvo = %d, novac = %d WHERE id = %d", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_novac], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }

        case 4: // +$8000
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 4 poena aktivne igre, dobijate {FFFFFF}$8.000.");

            PlayerMoneyAdd(playerid, 8000);
        }

        case 5: // +2 respekta
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 5 poena aktivne igre, dobijate {FFFFFF}2 exp.");

            PI[playerid][p_iskustvo] += 2;

            new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
            if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
            {
                PI[playerid][p_nivo]++;
                SetPlayerScore(playerid, PI[playerid][p_nivo]);
                PI[playerid][p_iskustvo] -= nextLevelExp;
                SendClientMessageF(playerid, ZUTA, "** LEVEL UP | Sada ste nivo {FFFFFF}%d.", PI[playerid][p_nivo]);
            }
            new sQuery[67];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %d, iskustvo = %d WHERE id = %d", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }

        case 6: // $10000 + 2 zlatnika
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 6 poena aktivne igre, dobijate {FFFFFF}$10.000 + 1 zlatnik.");

            PlayerMoneyAdd(playerid, 10000);
            PI[playerid][p_zlato] += 1;

            new sQuery[71];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %d, zlato = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }

        case 7: // +3 respekta i 1 zlatnik
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 7 poena aktivne igre, dobijate {FFFFFF}3 exp + 1 zlatnik.");

            PI[playerid][p_iskustvo] += 3;
            PI[playerid][p_zlato] += 1;

            new nextLevelExp = GetNextLevelExp(PI[playerid][p_nivo]);
            if (PI[playerid][p_iskustvo] >= nextLevelExp) // Level up
            {
                PI[playerid][p_nivo]++;
                SetPlayerScore(playerid, PI[playerid][p_nivo]);
                PI[playerid][p_iskustvo] -= nextLevelExp;
                SendClientMessageF(playerid, ZUTA, "** LEVEL UP | Sada ste nivo {FFFFFF}%d.", PI[playerid][p_nivo]);
            }
            new sQuery[85];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET nivo = %d, iskustvo = %d, zlato = %d WHERE id = %d", PI[playerid][p_nivo], PI[playerid][p_iskustvo], PI[playerid][p_zlato], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }

        case 8: // 6 skill poena + glad na 0
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 8 poena aktivne igre, dobijate {FFFFFF}6 skill poena + glad na 0.");

            if (IsACriminal(playerid))
            {
                PlayerUpdateCriminalSkill(playerid, 6, SKILL_SILENT, 0);
            }
            else if (IsACop(playerid))
            {
                PlayerUpdateCopSkill(playerid, 6, SKILL_SILENT, 0);
            }

            PI[playerid][p_glad] = 0;
            PlayerHungerUpdate(playerid);
        }

        case 10: // $12000 + 5 zlatnika
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 10 poena aktivne igre, dobijate {FFFFFF}$12.000 + 5 zlatnika.");

            PlayerMoneyAdd(playerid, 12000);
            PI[playerid][p_zlato] += 1;

            new sQuery[71];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %d, zlato = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_zlato], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);
        }

        case 12: // $15000 + 2 tokena + 12 skill poena
        {
            SendClientMessage(playerid, PLAVAX, "(aktivna igra) {1275ED}Imate 12 poena aktivne igre, dobijate {FFFFFF}$15.000 + 2 tokena + 12 skill poena.");

            PlayerMoneyAdd(playerid, 15000);
            PI[playerid][p_token] += 2;

            if (IsACriminal(playerid))
            {
                PlayerUpdateCriminalSkill(playerid, 12, SKILL_SILENT, 0);
            }
            else if (IsACop(playerid))
            {
                PlayerUpdateCopSkill(playerid, 12, SKILL_SILENT, 0);
            }

            new sQuery[70];
            format(sQuery, sizeof sQuery, "UPDATE igraci SET novac = %d, gold = %d WHERE id = %d", PI[playerid][p_novac], PI[playerid][p_token], PI[playerid][p_id]);
            mysql_tquery(SQL, sQuery);

            // TODO: reset na 0
            pAktivnaIgra_Pts[playerid] = 0;
        }
    }

    if (pAktivnaIgra_Pts[playerid] > 12)
    {
        pAktivnaIgra_Pts[playerid] = 0;
    }
    return 1;
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
CMD:aktivnaigra(playerid, const params[])
{
    InfoMsg(playerid, "Trenutno imate %i poena aktivne igre.", pAktivnaIgra_Pts[playerid]);
    
    SPD(playerid, "no_return", DIALOG_STYLE_MSGBOX, "AKTIVNA IGRA", "{FFFFFF}- Aktivna igra je sistem koji nagradjuje vasu aktivnost na serveru.\n- Na svakom Payday-u dobijate po 1 poen aktivne igre, koje tako sakupljate sve dok ste online.\n- Kada napustite server i ponovo udjete, Vasi poeni se restartuju na 0 i pocinjete ispocetka.\n- Ako morate da se relogujete, poeni Vam se nece resetovati ako se na server vratite u roku od 5 minuta.\n\n{008080}3 POENA = {FFFFFF}$5.000 + 1 exp + 2 skill poena\n{008080}4 POENA = {FFFFFF}$8.000\n{008080}5 POENA = {FFFFFF}2 exp\n{008080}6 POENA = {FFFFFF}$10.000 + 1 zlatnik\n{008080}7 POENA = {FFFFFF}3 exp + 1 zlatnik\n{008080}8 POENA = {FFFFFF}6 skill poena + glad na 0\n{008080}10 POENA = {FFFFFF}$12.000 + 1 zlatnik\n{008080}12 POENA = {FFFFFF}$15.000 + 2 tokena + 12 skill poena\n\nTokene koje dobijate mozete zameniti za vredne nagrade - {008080}/token", "U redu", "");

    return 1;
}