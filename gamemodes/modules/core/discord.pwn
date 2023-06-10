#include <YSI_Coding\y_hooks>


// ========================================================================== //
//                       <section> Definicije </section>                      //
// ========================================================================== //
#define MAX_CHANNELS 4
#define MAX_DROLES 8	


// ========================================================================== //
//                       <section> Enumeratori </section>                     //
// ========================================================================== //

new discordRandom[MAX_PLAYERS];
new discordDisc[MAX_PLAYERS][5];
new discordName[MAX_PLAYERS][30];

enum channelNameID
{
	channelName[40],
	channelID[40]
};
new channels[MAX_CHANNELS][channelNameID] =
{
	{"obavestenja", 	"807380044342362174"},
	{"admin",           "807401759826771988"},
	{"overwatch_log",   "809970368646873141"},
	{"overwatch_bot",	"809970646871441413"}
};

enum roleNameID
{
	discRName[40],
	discRID[40]
};
new discRoles[MAX_DROLES][roleNameID] =
{
	{"helper", 		"807372523427594291"},
	{"admin", 		"807369198308687883"},
	{"head admin",  "807364486552879115"},
	{"lspd", 		"808255296014778408"},
	{"lcn", 		"808255696587456522"},
	{"gsf", 		"808255637154693130"},
	{"sb", 			"808255479838277632"},
	{"lider", 		"808258293394833429"}
};



// ========================================================================== //
//                      <section> Promenljive </section>                      //
// ========================================================================== //





// ========================================================================== //
//                       <section> Callback-ovi </section>                    //
// ========================================================================== //


// ========================================================================== //
//                        <section> Funkcije </section>                       //
// ========================================================================== //

forward sendDiSendClientMessageessage(const name[], const poruka[]);
public sendDiSendClientMessageessage(const name[], const poruka[])
{
	new DCC_Channel:channelId;
	for(new i = 0; i < MAX_CHANNELS; i++)
	{
	    if(!strcmp(name, channels[i][channelName]))
	    {
			channelId = DCC_FindChannelById(channels[i][channelID]);
			DCC_SendChannelMessage(channelId, poruka);
	    }
	}
	return 0;
}

forward setPlayerDiscRole(const id[], const role[]);
public setPlayerDiscRole(const id[], const role[])
{
	new DCC_User:userName, DCC_Role:roleID, DCC_Guild:guildID, DCC_Embed:embMsgDisc, DCC_Channel:infoChannel;
	new userID[21], roleName[30], userNameEmb[30], string[128], getUName[33], getUDisc[5];
	
	infoChannel = DCC_FindChannelById("809970646871441413");
	
	userName = DCC_FindUserById(id);
	guildID = DCC_FindGuildById("807293091232219157");
	DCC_GetUserId(userName, userID, sizeof(userID));
	
	for(new i = 0; i < MAX_DROLES; i++)
	{
	    if(!strcmp(role, discRoles[i][discRName]))
	    {
	        roleID = DCC_FindRoleById(discRoles[i][discRID]);
	        DCC_AddGuildMemberRole(guildID, userName, roleID);

			DCC_GetUserName(userName, getUName, 32);
			DCC_GetUserDiscriminator(userName, getUDisc, 5);
			format(string, sizeof(string), "Postavljam %s role - korisnik: %s#%s", discRoles[i][discRName], getUName, getUDisc);
			sendDiSendClientMessageessage("overwatch_log", string);

			format(roleName, sizeof(roleName), "%s", discRoles[i][discRName]);
			format(userNameEmb, sizeof(userNameEmb), "<@%s>", userID);
			
			embMsgDisc = DCC_CreateEmbed("ROLES");
			
			DCC_AddEmbedField(embMsgDisc, "AKCIJA", 	"ROLE SET", true);
			DCC_AddEmbedField(embMsgDisc, "ROLE", 		roleName, 	true);
			DCC_AddEmbedField(embMsgDisc, "KORISNIK",   userNameEmb,true);
			
			DCC_SendChannelEmbedMessage(infoChannel, embMsgDisc);
			
	        break;
	    }
	}
}

forward removePlayerDiscRole(const id[], const role[]);
public removePlayerDiscRole(const id[], const role[])
{
	new DCC_User:userName, DCC_Role:roleID, DCC_Guild:guildID, DCC_Embed:embMsgDisc, DCC_Channel:infoChannel;
	new string[128], userID[21];
	new roleName[30], userNameEmb[30], getUName[33], getUDisc[5];

	userName = DCC_FindUserById(id);
	guildID = DCC_FindGuildById("809970646871441413");
	DCC_GetUserId(userName, userID, sizeof(userID));
	
	infoChannel = DCC_FindChannelById("807401759826771988");

	for(new i = 0; i < MAX_DROLES; i++)
	{
	    if(!strcmp(role, discRoles[i][discRName]))
	    {
	        roleID = DCC_FindRoleById(discRoles[i][discRID]);
	        
	        DCC_RemoveGuildMemberRole(guildID, userName, roleID);
	        
			DCC_GetUserName(userName, getUName, 32);
			DCC_GetUserDiscriminator(userName, getUDisc, 5);
			format(string, sizeof(string), "Skidam %s role - korisnik: %s#%s", discRoles[i][discRName], getUName, getUDisc);
			sendDiSendClientMessageessage("overwatch_log", string);
			
			format(roleName, sizeof(roleName), "%s", discRoles[i][discRName]);
			format(userNameEmb, sizeof(userName), "<@%s>", userID);

			embMsgDisc = DCC_CreateEmbed("ROLES");

			DCC_AddEmbedField(embMsgDisc, "AKCIJA", 	"ROLE REMOVE", true);
			DCC_AddEmbedField(embMsgDisc, "ROLE", 		roleName, 	true);
			DCC_AddEmbedField(embMsgDisc, "KORISNIK",  	userNameEmb,true);
			

			DCC_SendChannelEmbedMessage(infoChannel, embMsgDisc);
			
			break;
	    }
	    else return 0;
	}
	
	return 1;
}
forward discPosaljiKod(playerid);
public discPosaljiKod(playerid)
{
	new DCC_Channel:channelPrivate;
	new string[128];
	channelPrivate = DCC_GetCreatedPrivateChannel();

	format(string, sizeof(string), "Vas kod za potvrdu je: %d", discordRandom[playerid]);

    DCC_SendChannelMessage(channelPrivate, string);
    
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

CMD:discordpk(playerid, params[])
{
	new dID[5], uName[30];
	new DCC_User:findUserBN;

	if(strlen(PI[playerid][p_discord_id]) > 5) return ErrorMsg(playerid, "Vec imate povezan discord racun, kontaktirajte admina ukoliko vam treba novi link.");
	
	if(sscanf(params, "s[5]s[30]", dID, uName))
	{
		Koristite(playerid, "discordpk [VAS DISCORD ID] [VASE DISKORD IME]");
		InfoMsg(playerid, "Primjer: nickname#3463 -> nickname - vase ime | 3463 - vas ID");
		InfoMsg(playerid, "/discordpk 3463 nickname");
		InfoMsg(playerid, "[!!!]Svaki pokusaj prevare sistema rezultirat ce perma banom bez ikakve mogucnosti unbana.");
	}

	findUserBN = DCC_FindUserByName(uName, dID);

	new ranI;
	
	ranI = random(2000);

    discordRandom[playerid] = ranI;
    discordName[playerid] = uName;
    discordDisc[playerid] = dID;

	DCC_CreatePrivateChannel(findUserBN, "discPosaljiKod");
	
	return 1;
}

CMD:discordkod(playerid, params[])
{
	new unosID, query[80];

	if(strlen(PI[playerid][p_discord_id]) > 5) return ErrorMsg(playerid, "Vec imate povezan discord racun, kontaktirajte admina ukoliko vam treba novi link.");

	if(sscanf(params, "i", unosID))
	{
	    Koristite(playerid, "discordkod [KOD]");
		InfoMsg(playerid, "Unesite kod koji ste dobili putem discord poruke.");
	}
	else {
		if(unosID == discordRandom[playerid])
		{
		    new DCC_User:findIId, strId[21];

			InfoMsg(playerid, "Uspjesno ste povezali vas discord i samp racun.");

			findIId = DCC_FindUserByName(discordName[playerid], discordDisc[playerid]);
			DCC_GetUserId(findIId, strId, 21);

			PI[playerid][p_discord_id] = strId;

			format(query, sizeof query, "UPDATE igraci SET p_discord_id = %s WHERE id = %i", PI[playerid][p_discord_id], PI[playerid][p_id]);
			mysql_tquery(SQL, query);
		}
		else {
			ErrorMsg(playerid, "Kod nije tacan!");
		}
	}
	return 1;
}

CMD:checkid(playerid, params[])
{
	new string[128];
	format(string, sizeof(string), "ID: %s", PI[playerid][p_discord_id]);
	SendClientMessage(playerid, -1, string);
}