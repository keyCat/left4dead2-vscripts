Msg("Initiating c6m2_survival Script\n");

DirectorOptions <-
{
	function AllowFallenSurvivorItem( classname )
	{
		if ( classname == "weapon_first_aid_kit" )
			return false;
		
		return true;
	}
}