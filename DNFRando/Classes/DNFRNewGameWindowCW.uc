class DNFRNewGameWindowCW extends UDukeNewGameWindowCW;

//==========================================================================================
//	SelectCurrentLocation
//==========================================================================================
function SelectCurrentLocation()
{
	if (CurLocation == -1)
		return;

	if (ScrollPos != 0)
		return;

	// Load the map if it's valid, and unlocked
	if ( Locations[CurLocation].MapIndex != -1 && MapList.Maps[Locations[CurLocation].MapIndex].Enabled )
	{
		LoadWaitTime = 0;
		UDukeNewGameWindow(ParentWindow.ParentWindow).bLocked = false;
		ParentWindow.ParentWindow.DelayedClose();
		AttentionWindow.DelayedClose();
		Root.Console.CloseUWindow();	
		GetPlayerOwner().ClientTravel( Locations[CurLocation].ComboBox.GetValue2() $ "?Mutator=DNFRando.DNFRMutator?noauto", TRAVEL_Absolute, false );
	}
}
