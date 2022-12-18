class DNFRandoDesktop extends UDukeDesktopWindow;

function CreateIconsForGameIconString( texture texIconGame, texture texIconGameGlow, texture texIconGameHL, texture texIconGameDown, optional bool bNoCreate )
{
	local float fLocX, fLocY;
	local float iconW, iconH;
	local int iArrayOffset;

	iconW = texIconGame.USize * (Root.WinWidth/1024);
	iconH = texIconGame.VSize * (Root.WinHeight/768);
	if ( !bNoCreate )
		iconDesktop[ICON_Game] = UDukeFakeIcon(CreateWindow( class'UDukeFakeIcon', fLocationX, fLocationY[ICON_Game], iconW, iconH*1.5, self));
	iconDesktop[ICON_Game].UpTexture   = texIconGame;
	iconDesktop[ICON_Game].DownTexture = texIconGameDown;
	iconDesktop[ICON_Game].OverTexture = texIconGameHL;
	iconDesktop[ICON_Game].GlowTexture = texIconGameGlow;
	iconDesktop[ICON_Game].bDesktopIcon = true;
	iconDesktop[ICON_Game].SetText("Game");
	iconDesktop[ICON_Game].TextY = texIconGame.VSize;
	iconDesktop[ICON_Game].Align = TA_Center;

	// Start to the right of the main icon, and tile across and down.
	fLocX = iconDesktop[ICON_Game].WinLeft + iconDesktop[ICON_Game].WinWidth + iIconOffsetX;
	fLocY = iconDesktop[ICON_Game].WinTop;

	// Setup buttons/icons.
	iArrayOffset = ICON_Game * SUB_ICON_MAX;
	CreateIconAndIncrementPosition(	arraySubIcons[iArrayOffset], fLocX, fLocY, eSUB_ICON_NewGame, regGame_NewGame, bNoCreate );
	arraySubIcons[iArrayOffset].classExplorer = class'DNFRNewGameWindow';
	iArrayOffset++;

	// SaveGame icon
	CreateIconAndIncrementPosition(	arraySubIcons[iArrayOffset], fLocX, fLocY, eSUB_ICON_SaveGame, regGame_SaveGame, bNoCreate );
	arraySubIcons[iArrayOffset].classExplorer = class'UDukeSaveGameWindow';
	iSaveGameIconIndex = iArrayOffset; // FairFriend: We store the index of the save game icon
	iArrayOffset++;
		
	// LoadGame icon
	CreateIconAndIncrementPosition(	arraySubIcons[iArrayOffset],fLocX, fLocY, eSUB_ICON_LoadGame, regGame_LoadGame, bNoCreate );
	arraySubIcons[iArrayOffset].classExplorer = class'UDukeLoadGameWindow';
	iArrayOffset++;
	
	// Profile icon
	CreateIconAndIncrementPosition(	arraySubIcons[iArrayOffset], fLocX, fLocY, eSUB_ICON_Profile,, bNoCreate);
	arraySubIcons[iArrayOffset].eWindowCommand = eWINDOW_COMMAND_Profile;
	iArrayOffset++;

	// QuitGame icon
	CreateIconAndIncrementPosition(	arraySubIcons[iArrayOffset], fLocX, fLocY, eSUB_ICON_QuitGame,, bNoCreate );
	arraySubIcons[iArrayOffset].eWindowCommand = eWINDOW_COMMAND_Quit;	
}
