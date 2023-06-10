#include <YSI_Coding\y_hooks>

// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //


new serverEkonomijaNovac;


// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //





// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //

hook OnGameModeInit() 
{

	mysql_tquery(SQL, "SELECT field, value FROM server_info WHERE field = 'serverNovac'", "MySQL_LoadServerBanka");

	return 1;
}

forward MySQL_LoadServerBanka();
public MySQL_LoadServerBanka()
{
    cache_get_row_count(rows);

    new row = rows;
    while (row)
    {
        row --;

        new field[12], value[12];
        cache_get_value_name(row, "field", field, sizeof field);
        cache_get_value_name(row, "value", value, sizeof value);

        if (!strcmp(field, "serverNovac", true))
        {
            serverEkonomijaNovac = strval(value);
        }
    }
    return 1;
}

forward server_dodaj_novac(novac);
public server_dodaj_novac(novac)
{
    new nvc;

    nvc = serverEkonomijaNovac + novac;

    new query[256];
	format(query, sizeof query, "UPDATE server_info SET value = '%d' WHERE field = 'serverNovac'", nvc);
	mysql_tquery(SQL, query);

    return 1;
}

forward get_server_novac();
public get_server_novac()
{
    return serverEkonomijaNovac;
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





// ========================================================================== //
//                         <section> Komande </section>                       //
// ========================================================================== //
