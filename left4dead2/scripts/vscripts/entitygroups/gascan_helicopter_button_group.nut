//-------------------------------------------------------
// Autogenerated from 'gascan_helicopter_button.vmf'
//-------------------------------------------------------
GascanHelicopterButton <-
{
	//-------------------------------------------------------
	// Required Interface functions
	//-------------------------------------------------------
	function GetPrecacheList()
	{
		local precacheModels =
		[
			EntityGroup.SpawnTables.button_gascan_drop,
			EntityGroup.SpawnTables.unnamed,
		]
		return precacheModels
	}

	//-------------------------------------------------------
	function GetSpawnList()
	{
		local spawnEnts =
		[
			EntityGroup.SpawnTables.unnamed,
			EntityGroup.SpawnTables.radio_gascan_drop_sound_1,
			EntityGroup.SpawnTables.radio_gascan_drop_relay,
			EntityGroup.SpawnTables.usetarget_gascan_resupply,
			EntityGroup.SpawnTables.button_gascan_drop,
		]
		return spawnEnts
	}

	//-------------------------------------------------------
	function GetEntityGroup()
	{
		return EntityGroup
	}

	//-------------------------------------------------------
	// Table of entities that make up this group
	//-------------------------------------------------------
	EntityGroup =
	{
		SpawnTables =
		{
			button_gascan_drop = 
			{
				SpawnInfo =
				{
					classname = "prop_dynamic"
					angles = Vector( 0, 0, 0 )
					body = "0"
					disablereceiveshadows = "0"
					disableshadows = "0"
					disableX360 = "0"
					ExplodeDamage = "0"
					ExplodeRadius = "0"
					fademaxdist = "0"
					fademindist = "-1"
					fadescale = "1"
					glowbackfacemult = "1.0"
					glowcolor = "78 184 41"
					glowrange = "240"
					glowrangemin = "0"
					glowstate = "3"
					LagCompensate = "0"
					MaxAnimTime = "10"
					maxcpulevel = "0"
					maxgpulevel = "0"
					MinAnimTime = "5"
					mincpulevel = "0"
					mingpulevel = "0"
					model = "models/props_placeable/radio_box.mdl"
					PerformanceMode = "0"
					pressuredelay = "0"
					RandomAnimation = "0"
					renderamt = "255"
					rendercolor = "255 255 255"
					renderfx = "0"
					rendermode = "0"
					SetBodyGroup = "0"
					skin = "0"
					solid = "6"
					spawnflags = "0"
					targetname = "button_gascan_drop"
					updatechildren = "0"
					origin = Vector( 0, 0, 0 )
				}
			}
			usetarget_gascan_resupply = 
			{
				SpawnInfo =
				{
					classname = "point_script_use_target"
					model = "button_gascan_drop"
					origin = Vector( 0, 0, 0 )
					targetname = "usetarget_gascan_resupply"
					vscripts = "usetargets/gascan_drop_usetarget"
					connections =
					{
						OnUser1 =
						{
							cmd1 = "!selfRunScriptCodeSummonRandomGascanChopper()0-1"
							cmd2 = "radio_gascan_drop_relayTrigger0-1"
						}
					}
				}
			}
			radio_gascan_drop_relay = 
			{
				SpawnInfo =
				{
					classname = "logic_relay"
					spawnflags = "0"
					targetname = "radio_gascan_drop_relay"
					origin = Vector( 0, 0, 0 )
					connections =
					{
						OnTrigger =
						{
							cmd1 = "radio_gascan_drop_sound_1PlaySound3-1"
						}
					}
				}
			}
			radio_gascan_drop_sound_1 = 
			{
				SpawnInfo =
				{
					classname = "ambient_generic"
					health = "10"
					message = "npc.ChopperPilot_hospital_intro_heli_13"
					pitch = "100"
					pitchstart = "100"
					radius = "1250"
					spawnflags = "48"
					targetname = "radio_gascan_drop_sound_1"
					origin = Vector( 0, 0, 0 )
				}
			}
			unnamed = 
			{
				SpawnInfo =
				{
					classname = "prop_dynamic"
					angles = Vector( 0, 0, 0 )
					fademindist = "-1"
					fadescale = "1"
					glowbackfacemult = "1.0"
					glowcolor = "0 0 0"
					MaxAnimTime = "10"
					MinAnimTime = "5"
					model = "models/props_placeable/chopper_gas_trophy.mdl"
					renderamt = "255"
					rendercolor = "255 255 255"
					skin = "0"
					solid = "6"
					origin = Vector( 0, 0, 9 )
				}
			}
		} // SpawnTables
	} // EntityGroup
} // GascanHelicopterButton

RegisterEntityGroup( "GascanHelicopterButton", GascanHelicopterButton )
