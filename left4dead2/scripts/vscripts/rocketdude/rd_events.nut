//****************************************************************************************
//																						//
//										rd_events.nut									//
//																						//
//****************************************************************************************




function OnGameEvent_player_incapacitated(params){
	if(!lastChanceUsed){
		lastChanceSwitch(params)
	}
}




// When a survivor stands full hp in a mushroom trigger volume the function is unlocked
// again and the survivor gets hurt a touchtest should be done
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_hurt(params){
	if(GetPlayerFromUserID(params.userid).GetZombieType() == 9){
		foreach(trigger, datatable in medkit_data){
			DoEntFire("!self", "TouchTest", "", 0, trigger, trigger)
		}
	}
}




// Disable glows when survivors enter "last chance mode" but fail
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_mission_lost(params){
	disableInfectedGlows();
}




// Called when any player dies. Purpose mostly for bullet time, reviving survivors from being incap and "last chance"
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_player_death(params){
	
	local victim = null
	local attacker = null
	local victimClass = null
	
	if("userid" in params){
		victim = GetPlayerFromUserID(params["userid"])
	} else if("entityid" in params){
		victim = EntIndexToHScript(params["entityid"])
	}
	if("attacker" in params){
		attacker = GetPlayerFromUserID(params["attacker"])
	} else if("attackerentid" in params){
		attacker = EntIndexToHScript(params["attackerentid"])
	}
	
	if(!lastChanceUsed){
		lastChanceSwitch(params)	
	}
	
	if(victim.IsPlayer() && victim.GetZombieType() == 9){
		ClientPrint(null, 5, BLUE + victim.GetPlayerName() + WHITE + " did not finish this map. The map finished them.")
	}
	

	if(victim.GetClassname() != "infected"){
		if(victim.GetClassname() == "witch" || victim.GetZombieType() != 9){
			if(attacker != null && attacker.IsPlayer()){
				if(attacker.GetZombieType() == 9){
					if(attacker.IsIncapacitated()){
						if(!missionFailed){
							if(last_chance_active){
								stopLastChanceMode()
								attacker.ReviveFromIncap()
							}else{
								if(!allSurvivorsIncap()){
									attacker.ReviveFromIncap()
								}else{
									ClientPrint(null, 5, BLUE + "Time to say goodbye")
								}
							}
							EmitAmbientSoundOn("player/orch_hit_csharp_short", 1, 100, 100, attacker);	
						}
					}
				}
			}
		}
	}else{
		if(attacker != null && attacker.GetClassname() == "player" && attacker.GetZombieType() == 9){
			bulletTime()
		}
	}
}




// Set tank's health in relation to the current difficulty
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_tank_spawn(params){
	local tank = EntIndexToHScript(params.tankid)
	local health = 0;
	switch(Convars.GetStr("z_difficulty").tolower()){
		case "easy" :
			health = 7000; break;
		case "normal" :
			health = 14000; break;
		case "hard" :
			health = 28000; break;
		case "impossible" :
			health = 56000; break;
	}
	tank.SetMaxHealth(health);
	tank.SetHealth(health);
}




// Avoid multiple rocketlaunchers on the ground 
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_item_pickup(params){
	local player = GetPlayerFromUserID(params["userid"])
	local playerInv = {}
	if(player.GetZombieType() == 9){
		GetInvTable(player, playerInv)
		if("slot0" in playerInv){
			if(playerInv["slot0"].GetClassname() != "weapon_grenade_launcher"){
				playerInv["slot0"].Kill()
				player.GiveItem("weapon_grenade_launcher")
			}
		}
	}
}




function OnGameEvent_weapon_drop(params){
	if("propid" in params){
		local droppedItem = EntIndexToHScript(params.propid)
		if(droppedItem.GetClassname() == "weapon_grenade_launcher"){
			droppedItem.Kill()
		}
	}
}




// Like in Portal 1 we want to challange the player to do as less steps as possible or atleast to spend as less time on the 
// ground as possible. Event "player_footstep" is non-functional atm...Valve please fix
// ----------------------------------------------------------------------------------------------------------------------------

function OnGameEvent_finale_vehicle_leaving(param){
	finalGroundTimeOutput()
}




function OnGameEvent_finale_win(param){
	finalGroundTimeOutput()
}




function finalGroundTimeOutput(){
	foreach(player,datatable in playerOnGroundData){
		if(player.IsValid()){
			if(!player.IsDead() && !player.IsDying() && !player.IsIncapacitated()){
				if(playerOnGroundData[player].finish == false){
					printFinalGroundTime(player)
					playerOnGroundData[player].finish = true;
				}
			}
		}
	}
}




local lastSaveRoomCheck = Time()
function survivorSaferoomCheck(){
	if( Time() > lastSaveRoomCheck + 0.03){
		lastSaveRoomCheck = Time()
		foreach(player, datatable in playerOnGroundData){
			if(playerOnGroundData[player].finish == false){
				if( ResponseCriteria.GetValue(player, "incheckpoint" ) == "1" ){
					printFinalGroundTime(player)
					playerOnGroundData[player].finish = true;
				}
			}
		}
	}
}




function printFinalGroundTime(player){
	local mapName = Director.GetMapName().tolower()
	if(!player.IsDead() && !player.IsDying() && !player.IsIncapacitated()){
		local sec = playerOnGroundData[player].seconds
		local fracs = playerOnGroundData[player].ticks.tofloat()
		if(fracs > 0){
			fracs = (fracs / 30)
		}
		local groundTime = sec + fracs
		local timeNeeded = limitDecimalPlaces( Time() - (playerOnGroundData[player].startTime).tofloat() )
		local midAirPercent = getMidAirPercentage(groundTime, timeNeeded)
		ClientPrint(null, 5, BLUE + player.GetPlayerName() + WHITE + " finished this map in " + BLUE + timeNeeded + WHITE + " seconds and spent " + BLUE + midAirPercent + WHITE + " % midair")
		
		local diff = GetSpeedrunStats(player, timeNeeded)

		// Speedrun tracker
		
		if( diff != null ){
			if( diff < 0){
				ClientPrint(null, 5, WHITE + "Thats a new personal record for " + mapName + GREEN + " ( "  + diff.tostring() + " seconds )")
				return;
			}else if(diff > 0){
				ClientPrint(null, 5, ORANGE + "( +" + ( diff.tostring()) + " seconds )" )
				return;
			}
		}else{
			ClientPrint(null, 5, WHITE + "Thats a new personal record for " + mapName )
		}
	}
}




function getMidAirPercentage(groundTime, timeNeeded){
	local airTime = timeNeeded - groundTime
	local airPercentage = (( airTime / timeNeeded ) * 100).tofloat()
	return limitDecimalPlaces(airPercentage)
}




function limitDecimalPlaces(var){
	return (var * 100).tointeger() / 100.0
}




// Check if the text from the file is a "number"
// ----------------------------------------------------------------------------------------------------------------------------

function isNumeric(value){
	local newValue;
	local dots = 0
	local numbers = ["0","1","2","3","4","5","6","7","8","9","."]
	for(local i=0; i < value.len(); i++){
		local checkChar = value.slice(i, i+1)
		if(checkChar == "."){
			dots++;
		}
		if(dots > 1){
			return false
		}
		if(numbers.find(checkChar) == null){
			return false;
		}
	}
	return true;
}




// Record output for the local player
// ----------------------------------------------------------------------------------------------------------------------------

function GetSpeedrunStats(player, newTime){
	
	// Restrict saving for the local player
	if(!(player == GetListenServerHost())){
		return null;
	}
	
	local mapName = Director.GetMapName().tolower()
	local filePath = "rocketdude/speedrun/"
	local fileName = mapName + ".txt"
	
	local savedTime = FileToString(filePath + fileName)
	
	// Save a file when there is none
	if(savedTime == null || savedTime.len() == 0 || !isNumeric(savedTime)){
		StringToFile(filePath + fileName, newTime.tostring() )
		return;
	}
	
	try{
		savedTime = savedTime.tofloat()
	}catch(exception){
		return;
	}
	
	return (newTime - savedTime)
}




__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

