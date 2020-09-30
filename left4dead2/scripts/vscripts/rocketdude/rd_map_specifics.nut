//****************************************************************************************
//																						//
//									rd_map_specifics.nut								//
//																						//
//****************************************************************************************




// Some maps require minor adjustments to improve gameplay. 
// ----------------------------------------------------------------------------------------------------------------------------

::mapSpecifics <- function(){
	local mapName = Director.GetMapName().tolower()
	switch(mapName){
		
		case "c1m1_hotel"		:	rd_specifics_c1m1();	break;
		case "c8m4_interior"	:	rd_specifics_c8m4();	break;
		case "c14m2_lighthouse"	:	rd_specifics_c14m2();	break;
		default					:							break;
	}
}




// Since we dont have any fall damage at all we should not stop players from just dropping down the hotel
// ----------------------------------------------------------------------------------------------------------------------------

::rd_specifics_c1m1 <- function(){
	local deathTriggers =
	[
		Vector(3200.000,5312.000,1648.000),
		Vector(2944.000,5888.000,1648.000),
		Vector(2936.000,6932.000,1648.000),
		Vector(1516.800,8000.000,1520.000),
		Vector(632.000,6944.000,1648.000),
		Vector(1600.000,4608.000,1648.000),
		Vector(0.000, 5632.000,1648.000)
	]
	foreach(triggerPos in deathTriggers){
		local ent = null;
		if(ent = Entities.FindByClassnameNearest( "trigger_hurt", triggerPos, 4 )){
			ent.Kill()
		}
	}
}




// Since players are not supposed to hang from any ledges we dont need a trigger which re-enables it
// ----------------------------------------------------------------------------------------------------------------------------

::rd_specifics_c14m2 <- function(){
	local trigger = null;
	if(trigger = Entities.FindByClassnameNearest( "trigger_multiple", Vector(-4352,3928,1096), 4 )){
		trigger.Kill()
	}
}

::c8m4FixReloaded <- false
::rd_specifics_c8m4 <-function(){
	if(!c8m4FixReloaded){
		EntFire( "worldspawn", "RunScriptFile", "c8m4_elevatorfix" )
	}
}



