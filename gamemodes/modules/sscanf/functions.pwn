SSCANF:vehiclemodel(string[])
{
    if('0' <= string[0] <= '9')
    {
        new ret = strval(string);
        if (400 <= ret <= 611)
        {
            return ret;
        }
    }
    else for(new i; i < sizeof(imena_vozila); i++)
    {
        if(strfind(string, imena_vozila[i], true) != -1)
        {
            return i + 400;
        }
    }
    return -1;
}

SSCANF:ftag(string[])
{
    if(IsNumeric(string))
    {
        new ret = strval(string);
        if (0 <= ret < GetMaxFactions())
        {
            return ret;
        }
    }
    else for(new i = 0; i < GetMaxFactions(); i++)
    {
        new tag[10];
        GetFactionTag(i, tag, sizeof tag);
        if(strcmp(tag, "N/A") && !strcmp(tag, string, true))
        {
            return i;
        }
    }
    return -1;
}