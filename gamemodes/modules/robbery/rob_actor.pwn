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





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //

hook OnPlayerRequestRobbery(playerid, actorid) {
	new exampleName[24];
	GetPlayerName(playerid, exampleName, 24);
    
    new string[40];
    format(string, sizeof(string), "%s roba actora %d", exampleName, actorid);
    SendClientMessage(playerid, -1, string);
	
	if(!strcmp(exampleName, "COP"))
	{
		SendClientMessage(playerid, -1, "COP no ROB.");
		return 0; // Must return 0 for the robbery to not commence.
	}
	return 1;
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
