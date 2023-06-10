#include <YSI_Coding\y_va>

#define UpdatePVarInt(%0,%1,%2) SetPVarInt(%0, %1, (GetPVarInt(%0, %1) + (%2)))

stock SendClientMessageF(playerid, color, const fmat[], {Float, _}:...)
{
    new
        str[145];
    va_format(str, sizeof (str), fmat, va_start<3>);
    return SendClientMessage(playerid, color, str);
}

stock SendClientMessageFToAll(color, const fmat[], {Float, _}:...)
{
    new
        str[245];
    va_format(str, sizeof (str), fmat, va_start<2>);
    foreach (new i : Player)
    {
        if (IsPlayerLoggedIn(i))
        {
            SendClientMessage(i, color, str);
        }
    }
}

stock TDSetString(Text:text, const fmat[], {Float, _}:...)
{
    new
        str[1025];
    va_format(str, sizeof (str), fmat, va_start<2>);
    return TextDrawSetString(text, str);
}

stock PTDSetString(playerid, PlayerText:text, const fmat[], {Float, _}:...)
{
    new
        str[1025];
    va_format(str, sizeof (str), fmat, va_start<3>);
    return PlayerTextDrawSetString(playerid, text, str);
}

stock DebugMsg(playerid, const fmat[], {Float, _}:...)
{
    if (IsAdmin(playerid, 6))
    {
        new
            str[145];
        va_format(str, sizeof str, fmat, va_start<2>);
        format(str, sizeof str, "- DEBUG: {B4CDED}%s", str);
        SendClientMessage(playerid, CRVENA, str);
    }
    return 1;
}

stock InfoMsg(playerid, const fmat[], {Float, _}:...)
{
    new
        str[160];
    va_format(str, sizeof str, fmat, va_start<2>);
    format(str, sizeof str, "- NL: {B4CDED}%s", str);
    SendClientMessage(playerid, 0x0D1821FF, str);

    return 1;
}

stock IsVehicleFlipped(vehicleid) 
{
    new Float:Q[4], Float:VehSpd[4];
    GetVehicleVelocity(vehicleid,VehSpd[0],VehSpd[1],VehSpd[2]);
    VehSpd[3]=floatsqroot(VehSpd[0]*VehSpd[0]+VehSpd[1]*VehSpd[1]+VehSpd[2]*VehSpd[2]);
    GetVehicleRotationQuat(vehicleid,Q[0],Q[1],Q[2],Q[3]);
    new Float:sqw=Q[0]*Q[0];
    new Float:sqx=Q[1]*Q[1];
    new Float:sqy=Q[2]*Q[2];
    new Float:sqz=Q[3]*Q[3];
    new Float:bank=atan2(2*(Q[2]*Q[3]+Q[1]*Q[0]),-sqx-sqy+sqz+sqw);
    
    if(floatabs(bank)>160 && VehSpd[3]<0.01) return 1;
    return 0;
}

stock IsKeyJustDown(key, newkeys, oldkeys)
{
    if ((newkeys & key) && !(oldkeys & key)) return 1;
    return 0;
}

stock is_numeric(const string[]) 
{
    for__loop (new i = 0, j = strlen(string); i < j; i++) 
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

stock get_player_id(const ime[MAX_PLAYER_NAME], vrsta = obicno_ime) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "get_player_id");
    #endif

    switch (vrsta) 
    {
        case obicno_ime: 
        {
            foreach(new i : Player) 
            {
                if (!strcmp(ime_obicno[i], ime, false, strlen(ime))) 
                {
                    return i;
                }
            }
        }
        case rp_ime: 
        {
            foreach(new i : Player) 
            {
                if (!strcmp(ime_rp[i], ime, false, strlen(ime))) 
                {
                    return i;
                }
            }
        }
    }
    return INVALID_PLAYER_ID;
}

public Float:GetDistanceBetweenPoints(Float:X, Float:Y, Float:Z, Float:PointX, Float:PointY, Float:PointZ) 
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "GetDistanceBetweenPoints");
    #endif

    return floatadd(floatadd(floatabs(floatsub(X, PointX)), floatabs(floatsub(Y, PointY))), floatabs(floatsub(Z, PointZ)));
}

stock checkcinc(playerid, ccinc) 
{
    if (cinc[playerid] == ccinc && IsPlayerConnected(playerid)) return true;
    else return false;
}

stock GetVehicleTopSpeed(modelid)
{
    if (400 <= modelid <= 611)
    {
        return floatround(brzina_vozila[modelid - 400] * 1.1, floatround_floor);
    }
    else
    {
        return 0;
    }
}

stock GetPlayerSpeed(playerid) 
{
    if (!IsPlayerInAnyVehicle(playerid)) return 0;
    
    new Float:ST[4];
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    ST[3] = floatmul(floatsqroot(floatadd(floatadd(floatpower(floatabs(ST[0]), 2.0), floatpower(floatabs(ST[1]), 2.0)), floatpower(floatabs(ST[2]), 2.0))), 195.12);
    return floatround(ST[3]);
}

stock GetVehicleGear(playerid, speed, topSpeed) 
{
    if (topSpeed == 0) return GEAR_UNKNOWN;

    new 
        gear,
        engine, lights, alarm, doors, bonnet, boot, objective,
        speedPercentage = (speed * 100) / topSpeed;
        
    GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);

    if (engine == 1) 
    {
        if (gPlayerReversing{playerid} == true) gear = GEAR_REVERSE;
        else
        {
            if (topSpeed < 200) 
            {
                if (speed == 0)                                         gear = GEAR_NEUTRAL;
                else if (speedPercentage > 0   && speedPercentage < 20) gear = 1;
                else if (speedPercentage >= 20 && speedPercentage < 40) gear = 2;
                else if (speedPercentage >= 40 && speedPercentage < 60) gear = 3;
                else if (speedPercentage >= 60 && speedPercentage < 85) gear = 4;
                else if (speedPercentage >= 85)                         gear = 5;
                else                                                    gear = GEAR_UNKNOWN;
            }
            else {
                if (speed == 0)                                         gear = GEAR_NEUTRAL;
                else if (speedPercentage > 0   && speedPercentage < 15) gear = 1;
                else if (speedPercentage >= 15 && speedPercentage < 30) gear = 2;
                else if (speedPercentage >= 30 && speedPercentage < 55) gear = 3;
                else if (speedPercentage >= 55 && speedPercentage < 75) gear = 4;
                else if (speedPercentage >= 75 && speedPercentage < 90) gear = 5;
                else if (speedPercentage >= 90)                         gear = 6;
                else                                                    gear = GEAR_UNKNOWN;
            }
        }
    }
    else gear = GEAR_PARKING;
    return gear;
}

stock HexToInt(const string[]) 
{
    if (string[0]==0) return 0;
    new 
    i, cur=1, res=0;
    for__loop (i=strlen(string);i>0;i--) {
        if (string[i-1]<58) 
            res=res+cur*(string[i-1]-48); 
        else 
            res=res+cur*(string[i-1]-65+10);

        cur=cur*16;
    }
    return res;
}

stock split(const strsrc[], strdest[][], delimiter, limit = -1) 
{
    new i, li;
    new aNum;
    new len;
    while__loop (i <= strlen(strsrc)) {
        if (strsrc[i] == delimiter || i == strlen(strsrc)) 
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
            if (aNum == limit) return 1;
        }
        i++;
    }
    return 1;
}

stock IsVehicleBicycle(m) {
    
    if (m == 481 || m == 509 || m == 510) return true;
    else return false;
}

stock IsVehicleAirplane(m) {
    if (m == 460 || m == 476 || m == 511 || m == 512 || m == 513 || m == 519 || m == 520 || m == 553 || m == 577 || m == 592 || m == 593) return true;
    else return false;
}

stock IsVehicleHelicopter(m) {
    if (m == 417 || m == 425 || m == 447 || m == 469 || m == 487 || m == 488 || m == 497 || m == 548 || m == 563) return true;
    else return false;
}

stock IsVehicleBoat(m) {
    if (m == 430 || m == 446 || m == 452 || m == 453 || m == 454 || m == 472 || m == 473 || m == 484 || m == 493 || m == 595) return true;
    else return false;
}

stock IsVehicleTruck(m) {
    if (m == 403 || m == 408 || m == 413 || m == 414 || m == 443 || m == 455 || m == 456 || m == 498 || m == 499 || m == 514 || m == 524 || m == 554 || m == 578 || m == 609) 
        return true;
    
    else 
        return false;
}

stock IsVehicleMotorbike(m) {
    if (m == 448 || m == 461 || m == 462 || m == 463 || m == 468 || m == 471 || m == 521 || m == 522 || m == 523 || m == 581 || m == 586) 
        return true;
    
    else 
        return false;
}

stock IsASportsCar(m) {
    if (m == 411 || m == 415 || m == 451 || m == 477 || m == 494 || m == 502 || m == 503 || m == 506 || m == 541)
        return true;
    else
        return false;
}

stock IsVehicleOccupied_OW(vehicleid) {
    new bool:occupied = false;
    foreach(new i : Player) {
        if (GetPlayerVehicleID(i) == vehicleid) {
            occupied = true;
            break;
        }
    }

    return occupied;
}

stock VehicleHasPassengers(vehicleid) {
    new bool:passengers = false;
    foreach(new i : Player) {
        if (GetPlayerVehicleID(i) == vehicleid && GetPlayerState(i) == PLAYER_STATE_PASSENGER) {
            passengers = true;
            break;
        }
    }

    return passengers;
}

stock GetPosBehindVehicle(vehicleid, &Float:x, &Float:y, &Float:z, Float:offset=0.5)
{
    new Float:vehicleSize[3], Float:vehiclePos[3];
    GetVehiclePos(vehicleid, vehiclePos[0], vehiclePos[1], vehiclePos[2]);
    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, vehicleSize[0], vehicleSize[1], vehicleSize[2]);
    GetXYBehindVehicle(vehicleid, vehiclePos[0], vehiclePos[1], (vehicleSize[1]/2)+offset);
    x = vehiclePos[0];
    y = vehiclePos[1];
    z = vehiclePos[2];
    return 1;
}

stock GetXYBehindVehicle(vehicleid, &Float:q, &Float:w, Float:distance)
{
    new Float:a;
    GetVehiclePos(vehicleid, q, w, a);
    GetVehicleZAngle(vehicleid, a);
    q += (distance * -floatsin(-a, degrees));
    w += (distance * -floatcos(-a, degrees));
}

stock GetVehicleModelName(modelid) 
{
    new modelName[18];
    if (modelid >= 400 && modelid <= 611) 
        format(modelName, sizeof modelName, "%s", imena_vozila[modelid - 400]);
    
    else
        modelName = "N/A";

    return modelName;
}

stock GetVehicleModelID(const modelName[]) 
{
    new modelid = -1;
    for__loop (new i; i < sizeof imena_vozila; i++) 
    {
        if (!strcmp(imena_vozila[i], modelName, true)) 
        {
            modelid = i+400;
            break;
        }
    }

    return modelid; // -1 = invalid
}

stock IsPlayerInArea(playerid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "IsPlayerInArea");
    #endif

    new Float:Poz[3];
    GetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
    if (Poz[0] > minx && Poz[0] < maxx && Poz[1] > miny && Poz[1] < maxy) return 1;
    return 0;
}

stock IsVehicleInRangeOfPoint(vehicleid, Float:radius, Float:x, Float:y, Float:z)
{
    #if defined DEBUG_FUNCTIONS
        Debug("function", "IsVehicleInRangeOfPoint");
    #endif

    new Float:poz[3];
    GetVehiclePos(vehicleid, poz[0], poz[1], poz[2]);
    if (GetDistanceBetweenPoints(poz[0], poz[1], poz[2], x, y, z) <= radius) return true;
    else return false;
}

stock static IsAngleInRangeOfAngle(Float:a1, Float:a2, Float:range = 10.0)
{
    a1 -= a2;
    if((a1 < range) && (a1 > -range)) return true;
    return false;
}

stock IsPlayerFacingPoint(playerid, Float:x, Float:y, Float:range = 10.0)
{
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
 
    new Float:facing;
    GetPlayerFacingAngle(playerid, facing);
 
    new Float:angle;
 
    if(pos[1] > y) angle = (-acos((pos[0] - x) / floatsqroot((pos[0] - x)*(pos[0] - x) + (pos[1] - y)*(pos[1] - y))) - 90.0);
    else if(pos[1] < y && pos[0] < x) angle = (acos((pos[0] - x) / floatsqroot((pos[0] - x)*(pos[0] - x) + (pos[1] - y)*(pos[1] - y))) - 450.0);
    else if(pos[1] < y) angle = (acos((pos[0] - x) / floatsqroot((pos[0] - x)*(pos[0] - x) + (pos[1] - y)*(pos[1] - y))) - 90.0);
 
    return (IsAngleInRangeOfAngle(-angle, facing, range));
}

stock IsPlayerFacingPlayer(playerid, targetid, Float:range =  10.0)
{
        new Float:pos[3];
        GetPlayerPos(targetid, pos[0], pos[1], pos[2]);
 
        return IsPlayerFacingPoint(playerid, pos[0], pos[1], range);
}

stock IsPlayerNearPlayer(player1, player2, Float:range = 5.0) 
{
    new Float:pos[6];
    GetPlayerPos(player1, pos[0], pos[1], pos[2]);
    GetPlayerPos(player2, pos[3], pos[4], pos[5]);

    return GetDistanceBetweenPoints(pos[0], pos[1], pos[2], pos[3], pos[4], pos[5]) < range;
}

stock GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance) 
{
    x += (distance * floatsin(-angle, degrees));
    y += (distance * floatcos(-angle, degrees));
}

stock GetXYInFrontOfPlayer(playerid, &Float:destX, &Float:destY, Float:distance)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    if (IsPlayerInAnyVehicle(playerid))
    {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }
    else
    {
        GetPlayerFacingAngle(playerid, a);
    }

    GetXYInFrontOfPoint(destX, destY, a, distance);
}

stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius) 
{
    new Float:camera_x,Float:camera_y,Float:camera_z,Float:vector_x,Float:vector_y,Float:vector_z;
    GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
    GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

    new Float:vertical, Float:horizontal;

    switch (GetPlayerWeapon(playerid)) {
        case 34,35,36: {
            if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, vector_x, vector_y, vector_z) < radius) return true;
            return false;
        }
        case 30,31: { vertical = 4.0; horizontal = -1.6; }
        case 33: { vertical = 2.7; horizontal = -1.0; }
        default: { vertical = 6.0; horizontal = -2.2; }
    }

    new Float:angle = GetPointAngleToPoint(0, 0, floatsqroot(vector_x*vector_x+vector_y*vector_y), vector_z) - 270.0;
    new Float:resize_x, Float:resize_y, Float:resize_z = floatsin(angle+vertical, degrees);
    GetXYInFrontOfPoint(resize_x, resize_y, GetPointAngleToPoint(0, 0, vector_x, vector_y)+horizontal, floatcos(angle+vertical, degrees));

    if (DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, resize_x, resize_y, resize_z) < radius) return true;
    return false;
}

stock formatMoneyString(money) 
{
    new string[13];
    if (-1000 < money < 1000)
    {
        format(string, sizeof string, "$%i", money);
    }
    else 
    {
        valstr(string, money);

        for__loop (new i = strlen(string)-3; i >= 1; i -= 3) 
        {
            strins(string, ".", i);
        }
        strins(string, "$", 0);
    }
    return string;
}

stock ClearDeathFeedForPlayer(playerid)
{
    for__loop (new j = 0; j < 6; j++)
    {
        SendDeathMessageToPlayer(playerid, 1001, 1001, 200);
    }
}

stock CountVehiclePassengers(vehicleid)
{
    new count = 0;
    foreach (new i : Player)
    {
        if (GetPlayerState(i) == PLAYER_STATE_PASSENGER && GetPlayerVehicleID(i) == vehicleid)
        {
            count++;
        }
    }
    return count;
}

// stock CountSetBits(n)
// {
//     new count = 0;
//     while__loop (n) 
//     { 
//         n &= (n - 1); 
//         count++; 
//     }
//     return count;
// }

#define RANDSTR_FLAG_UPPER (1)
#define RANDSTR_FLAG_LOWER (2)
#define RANDSTR_FLAG_DIGIT (4)
stock RandomString(strDest[], strLen = 10, flags = RANDSTR_FLAG_UPPER | RANDSTR_FLAG_LOWER | RANDSTR_FLAG_DIGIT)
{
    new randChar[3], index;

    strLen -= 1;
    while__loop (strLen--)
    {
        index = 0;
        if (flags & RANDSTR_FLAG_DIGIT)
            randChar[index++] = random(10) + '0';
        
        if (flags & RANDSTR_FLAG_UPPER)
            randChar[index++] = random(26) + 'A';
        
        if (flags & RANDSTR_FLAG_LOWER)
            randChar[index++] = random(26) + 'a';

        strDest[strLen] = randChar[random(index)];
    }
}

stock GetPosBehindPlayer(playerid, &Float:px, &Float:py, &Float:pz, Float:distance = 1.0)
{   
    new Float:pfa;
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerFacingAngle(playerid, pfa);
    px -= (distance * floatsin(-pfa, degrees));
    py -= (distance * floatcos(-pfa, degrees));
    return 1;
}

stock Float:GetDistanceBetweenPlayers(iPlayer1, iPlayer2, &Float: fDistance = Float: 0x7F800000, bool: bAllowNpc = false)
{
    static
        Float: fX, Float: fY, Float: fZ;

    if (! bAllowNpc && (IsPlayerNPC(iPlayer1) || IsPlayerNPC(iPlayer2))) // since this command is designed for players
        return fDistance;

    if(GetPlayerVirtualWorld(iPlayer1) == GetPlayerVirtualWorld(iPlayer2) && GetPlayerPos(iPlayer2, fX, fY, fZ))
        fDistance = GetPlayerDistanceFromPoint(iPlayer1, fX, fY, fZ);

    return fDistance;
}

stock GetWeaponIDFromName(const weaponName[])
{
    new const aWeaponNames[47][21] = 
    {
        "Unarmed", "Brass Knuckles", "Golf Club", "Nite Stick", "Knife", "Baseball Bat", "Shovel", "Pool Cue", "Katana", "Chainsaw", "Purple Dildo", "Small White Vibrator",
        "Large White Vibrator", "Silver Vibrator", "Flowers", "Cane", "Granade", "Tear Gas", "Molotov Cocktail", "N/A", "N/A", "N/A", "9mm", "Silenced 9mm", "Desert Eagle",
        "Shotgun", "Sawn-off Shotgun", "Combat Shotgun", "Micro SMG", "MP5", "AK-47", "M4", "Tec9", "Country Rifle", "Sniper Rifle", "Rocket Launcher", "HS Rocket Launcher",
        "Flamethrower", "Minigun", "Satchel Charge", "Detonator", "Spraycan", "Fire Extinguisher", "Camera", "Nightvision Goggles", "Thermal Goggles", "Parachute"
    };

    new weaponid = -1;
    for__loop (new i = 0; i < sizeof(aWeaponNames); i++)
    {
        if (!strcmp(aWeaponNames[i], weaponName, true))
        {
            weaponid = i;
            break;
        }
    }

    return weaponid;
}

stock GetWeaponSlot_OW(weaponid) 
{
    switch (weaponid) 
    {
        case 0, 1:          return 0;
        case 2..9:          return 1;
        case 10..15:        return 10;
        case 16..18, 39:    return 8;
        case 22..24:        return 2;
        case 25..27:        return 3;
        case 28, 29, 32:    return 4;
        case 30, 31:        return 5;
        case 33, 34:        return 6;
        case 35..38:        return 7;
        case 40:            return 12;
        case 41..43:        return 9;
        case 44..46:        return 11;
        default:            return 0;
    }
    return 0;
}
#define GetSlotForWeapon GetWeaponSlot_OW 

stock randomEx(minnum = cellmin, maxnum = cellmax) 
{
    return random(maxnum - minnum + 1) + minnum;
}

stock GetTickDiff(newtick, oldtick)
{
    if (oldtick < 0 && newtick >= 0) 
    {
        return newtick - oldtick;
    } 
    else if (oldtick >= 0 && newtick < 0 || oldtick > newtick) 
    {
        return (cellmax - oldtick + 1) - (cellmin - newtick);
    }

    return newtick - oldtick;
}

stock SavePlayerWeaponDataAndPos(playerid)
{
    new oruzje[13], municija[13], oruzje_str[38], municija_str[80], pozicija_str[51],
        vw  = GetPlayerVirtualWorld(playerid),
        ent = GetPlayerInterior(playerid);

    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    GetPlayerFacingAngle(playerid, pozicija[playerid][3]);
    for__loop (new i = 0; i < 13; i++) 
    {
        GetPlayerWeaponData(playerid, i, oruzje[i], municija[i]);
    }

    format(pozicija_str, sizeof(pozicija_str), "%.2f|%.2f|%.2f|%.2f|%d|%d", pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], pozicija[playerid][3], vw, ent);
    format(oruzje_str, sizeof(oruzje_str), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d", oruzje[0], oruzje[1], oruzje[2], oruzje[3], oruzje[4], oruzje[5], oruzje[6], oruzje[7], oruzje[8], oruzje[9], oruzje[10], oruzje[11], oruzje[12]);
    format(municija_str, sizeof(municija_str), "%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d", municija[0], municija[1], municija[2], municija[3], municija[4], municija[5], municija[6], municija[7], municija[8], municija[9], municija[10], municija[11], municija[12]);

    SetPVarString(playerid, "pLastPos", pozicija_str);
    SetPVarString(playerid, "pWeaponData", oruzje_str);
    SetPVarString(playerid, "pAmmoData", municija_str);
    SetPVarInt(playerid, "pPDDuty", (IsPlayerOnLawDuty(playerid)? 1 : 0));
}

stock RestorePlayerWeaponDataAndPos(playerid)
{
    new oruzjeStr[38], municijaStr[80], pozicijaStr[51], pdDuty;
    pdDuty = GetPVarInt(playerid, "pPDDuty");
    GetPVarString(playerid, "pLastPos", pozicijaStr, sizeof pozicijaStr);
    GetPVarString(playerid, "pWeaponData", oruzjeStr, sizeof oruzjeStr);
    GetPVarString(playerid, "pAmmoData", municijaStr, sizeof municijaStr);
    DeletePVar(playerid, "pLastPos");
    DeletePVar(playerid, "pWeaponData");
    DeletePVar(playerid, "pAmmoData");
    DeletePVar(playerid, "pPDDuty");

    if (isnull(oruzjeStr) || isnull(municijaStr) || isnull(pozicijaStr)) return 1;

    new oruzje[13], municija[13], ent, vw;

    sscanf(pozicijaStr, "p<|>ffffii", pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2], pozicija[playerid][3], vw, ent);
    sscanf(oruzjeStr, "p<|>iiiiiiiiiiiii", oruzje[0], oruzje[1], oruzje[2], oruzje[3], oruzje[4], oruzje[5], oruzje[6], oruzje[7], oruzje[8], oruzje[9], oruzje[10], oruzje[11], oruzje[12]);
    sscanf(municijaStr, "p<|>iiiiiiiiiiiii", municija[0], municija[1], municija[2], municija[3], municija[4], municija[5], municija[6], municija[7], municija[8], municija[9], municija[10], municija[11], municija[12]);

    SetPlayerInterior(playerid, ent);
    SetPlayerVirtualWorld(playerid, vw);

    for__loop (new i = 0; i < 13; i++)
    {
        if (oruzje[i] > 0 && municija[i] > 0)
        {
            GivePlayerWeapon(playerid, oruzje[i], municija[i]);
        }
    }

    if (pdDuty == 1) ToggleLawDuty(playerid, true);

    pRestoreData{playerid} = false;
    return 1;
}

stock PlayerRestorePosition(playerid, bool:respawn = true)
{
    new pozicijaStr[51], vw, ent, Float:x, Float:y, Float:z, Float:a;
    GetPVarString(playerid, "pLastPos", pozicijaStr, sizeof pozicijaStr);
    sscanf(pozicijaStr, "p<|>ffffii", x, y, z, a, vw, ent);

    pRestoreData{playerid} = true;
    if (respawn)
    {
        // Igrac ce se raspawnati nakon pozivanja ove funkcije, pa mu se postavlja spawninfo
        SetSpawnInfo(playerid, 0, GetPlayerCorrectSkin(playerid), x, y, z, a, 0, 0, 0, 0, 0, 0);
    }
    else
    {
        SetPlayerCompensatedPos(playerid, x, y, z);
        RestorePlayerWeaponDataAndPos(playerid);
    }

    return 1;
}

SlapPlayer(playerid, Float:height = 7.0)
{
    // new Float:hp;
    // GetPlayerHealth(playerid, hp);
    GetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2]);
    SetPlayerPos(playerid, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + height);
    PlayerPlaySound(playerid, 1130, pozicija[playerid][0], pozicija[playerid][1], pozicija[playerid][2] + height);
    // SetPlayerHealth(playerid, hp-5.0);
}

IsPlayerNearVehicle(playerid, vehicleid, Float:range = 7.5)
{
    if (!IsPlayerConnected(playerid) || vehicleid == INVALID_VEHICLE_ID) return 0;

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);

    return (IsPlayerInRangeOfPoint(playerid, range, x, y, z) && GetPlayerVirtualWorld(playerid) == GetVehicleVirtualWorld(vehicleid));
}

stock RemoveVendingMachines(playerid)
{
    RemoveBuildingForPlayer(playerid, 1302, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1209, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 955, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 956, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1775, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1776, 0.0, 0.0, 0.0, 6000.0);
    RemoveBuildingForPlayer(playerid, 1977, 0.0, 0.0, 0.0, 6000.0);
    return 1;
}

/*stock QuickSort(array[], left, right)
{
    new
        tempLeft = left,
        tempRight = right,
        pivot = array[(left + right) / 2],
        tempVar
    ;
    while(tempLeft <= tempRight)
    {
        while(array[tempLeft] < pivot) tempLeft++;
        while(array[tempRight] > pivot) tempRight--;
        
        if(tempLeft <= tempRight)
        {
            tempVar = array[tempLeft], array[tempLeft] = array[tempRight], array[tempRight] = tempVar;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) QuickSort(array, left, tempRight);
    if(tempLeft < right) QuickSort(array, tempLeft, right);
}*/

stock QuickSort_Float(Float:array[], left, right)
{
    new
        tempLeft = left,
        tempRight = right,
        Float:pivot = array[(left + right) / 2],
        Float:tempVar
    ;
    while(tempLeft <= tempRight)
    {
        while(array[tempLeft] < pivot) tempLeft++;
        while(array[tempRight] > pivot) tempRight--;
        
        if(tempLeft <= tempRight)
        {
            tempVar = array[tempLeft], array[tempLeft] = array[tempRight], array[tempRight] = tempVar;
            tempLeft++, tempRight--;
        }
    }
    if(left < tempRight) QuickSort_Float(array, left, tempRight);
    if(tempLeft < right) QuickSort_Float(array, tempLeft, right);
}
