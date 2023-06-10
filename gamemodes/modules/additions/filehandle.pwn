#define ini_SetString(%0,%1,%2)\
        if(%2[0]) fwrite(%0, %1), fputchar(%0, '=', false) && fwrite(%0, %2) && fwrite(%0, "\r\n")

#define ini_SetInt(%0,%1,%2,%3)\
        format(%1, sizeof(%1), "%s=%d\r\n", %2, %3) && fwrite(%0, %1)

#define ini_SetFloat(%0,%1,%2,%3)\
        format(%1, sizeof(%1), "%s=%f\r\n", %2, %3) && fwrite(%0, %1)


stock ini_GetInt(const szParse[], const szValueName[], &iValue) {

    new
        iPos = strfind(szParse, "=", false);

    if(strcmp(szParse, szValueName, false, iPos) == 0) {
        iValue = strval(szParse[iPos + 1]);
        return 1;
    }
    return 0;
}

stock ini_GetValue(szParse[], const szValueName[], szDest[], iDestLen) { // brian!!1

    new
        iPos = strfind(szParse, "=", false),
        iLength = strlen(szParse);
        
    while__loop (iLength-- && szParse[iLength] <= ' ') {
        szParse[iLength] = 0;
    }

    if(strcmp(szParse, szValueName, false, iPos) == 0) {
        strmid(szDest, szParse, iPos + 1, iLength + 1, iDestLen);
        return 1;
    }
    return 0;
}