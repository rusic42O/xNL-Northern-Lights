new Float: AltChat_posY = 209.573348,
    Float: AltChat_YSpacing = 240.026733 - 229.573348;

ptdAltChat_Create(playerid) 
{
    for (new i = 0; i < MAX_LINES; i++)
    {
        AltChatTD_Player[i] = CreatePlayerTextDraw(playerid, 35.599971, AltChat_posY, " ");
        PlayerTextDrawLetterSize(playerid, AltChatTD_Player[i], 0.21, 0.9);
        PlayerTextDrawAlignment(playerid, AltChatTD_Player[i], 1);
        PlayerTextDrawColor(playerid, AltChatTD_Player[i], -1);
        PlayerTextDrawSetShadow(playerid, AltChatTD_Player[i], 0);
        PlayerTextDrawSetOutline(playerid, AltChatTD_Player[i], 1);
        PlayerTextDrawBackgroundColor(playerid, AltChatTD_Player[i], 255);
        PlayerTextDrawFont(playerid, AltChatTD_Player[i], 1);
        PlayerTextDrawSetProportional(playerid, AltChatTD_Player[i], 1);
        PlayerTextDrawSetShadow(playerid, AltChatTD_Player[i], 0);
        RemovePlayerAttachedObject(playerid, 6);
        strmid(AltChatTD_Text[playerid][i], " ", 0, 1);
        AltChat_posY += AltChat_YSpacing;

        PlayerTextDrawShow(playerid, AltChatTD_Player[i]);
    }

    return 1;
}
