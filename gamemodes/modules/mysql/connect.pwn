#include <YSI_Coding\y_hooks>

new MySQL:SQL;

new rows,
	MYSQL_DB_1[32];

hook OnGameModeInit() 
{
	SQL = mysql_connect_file();

	#warning Budi siguran da MYSQL_DB_1 sadrzi tacno ime databaze (potrebno za realestate / outdated) - daddyDOT
	format(MYSQL_DB_1, 32, "nl");

	mysql_log(ALL);
	new errs = mysql_errno(SQL);
	if (!errs) 
		print("MySQL is successfuly connected!");
	else 
	{
		print("Invalid MySQL connection!");
		print("The server will shutdown..");
		SendRconCommand("exit");
		return true;
	}
	return true;
}
