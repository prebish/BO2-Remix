#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_alcatraz_utility;

main()
{
	replaceFunc(maps\mp\zm_alcatraz_craftables::init_craftables, scripts\zm\replaced\zm_alcatraz_craftables::init_craftables);
	replaceFunc(maps\mp\zm_alcatraz_craftables::include_craftables, scripts\zm\replaced\zm_alcatraz_craftables::include_craftables);
	replaceFunc(maps\mp\zm_alcatraz_gamemodes::init, scripts\zm\replaced\zm_alcatraz_gamemodes::init);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::zgrief_init, scripts\zm\replaced\zm_alcatraz_grief_cellblock::zgrief_init);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::give_team_characters, scripts\zm\replaced\zm_alcatraz_grief_cellblock::give_team_characters);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::main, scripts\zm\replaced\zm_alcatraz_grief_cellblock::main);
	replaceFunc(maps\mp\zm_alcatraz_grief_cellblock::magicbox_face_spawn, scripts\zm\replaced\zm_alcatraz_grief_cellblock::magicbox_face_spawn);
	replaceFunc(maps\mp\zm_alcatraz_utility::blundergat_upgrade_station, scripts\zm\replaced\zm_alcatraz_utility::blundergat_upgrade_station);
	replaceFunc(maps\mp\zm_alcatraz_utility::alcatraz_audio_get_mod_type_override, scripts\zm\replaced\zm_alcatraz_utility::alcatraz_audio_get_mod_type_override);
	replaceFunc(maps\mp\zm_alcatraz_utility::check_solo_status, scripts\zm\replaced\zm_alcatraz_utility::check_solo_status);
	replaceFunc(maps\mp\zm_alcatraz_utility::drop_all_barriers, scripts\zm\replaced\zm_alcatraz_utility::drop_all_barriers);
	replaceFunc(maps\mp\zm_alcatraz_sq::dryer_zombies_thread, scripts\zm\replaced\zm_alcatraz_sq::dryer_zombies_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::track_quest_status_thread, scripts\zm\replaced\zm_alcatraz_sq::track_quest_status_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::plane_boarding_thread, scripts\zm\replaced\zm_alcatraz_sq::plane_boarding_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::plane_flight_thread, scripts\zm\replaced\zm_alcatraz_sq::plane_flight_thread);
	replaceFunc(maps\mp\zm_alcatraz_sq::manage_electric_chairs, scripts\zm\replaced\zm_alcatraz_sq::manage_electric_chairs);
	replaceFunc(maps\mp\zm_alcatraz_traps::init_fan_trap_trigs, scripts\zm\replaced\zm_alcatraz_traps::init_fan_trap_trigs);
	replaceFunc(maps\mp\zm_alcatraz_traps::init_acid_trap_trigs, scripts\zm\replaced\zm_alcatraz_traps::init_acid_trap_trigs);
	replaceFunc(maps\mp\zm_alcatraz_traps::zombie_acid_damage, scripts\zm\replaced\zm_alcatraz_traps::zombie_acid_damage);
	replaceFunc(maps\mp\zm_alcatraz_traps::player_acid_damage, scripts\zm\replaced\zm_alcatraz_traps::player_acid_damage);
	replaceFunc(maps\mp\zm_alcatraz_traps::tower_trap_trigger_think, scripts\zm\replaced\zm_alcatraz_traps::tower_trap_trigger_think);
	replaceFunc(maps\mp\zm_alcatraz_travel::move_gondola, scripts\zm\replaced\zm_alcatraz_travel::move_gondola);
	replaceFunc(maps\mp\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager, scripts\zm\replaced\zm_alcatraz_weap_quest::grief_soul_catcher_state_manager);
	replaceFunc(maps\mp\zm_alcatraz_weap_quest::hellhole_projectile_watch, scripts\zm\replaced\zm_alcatraz_weap_quest::hellhole_projectile_watch);
	replaceFunc(maps\mp\zm_alcatraz_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_alcatraz_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zm_prison::working_zone_init, scripts\zm\replaced\zm_prison::working_zone_init);
	replaceFunc(maps\mp\zm_prison::custom_vending_precaching, scripts\zm\replaced\zm_prison::custom_vending_precaching);
	replaceFunc(maps\mp\zm_prison::delete_perk_machine_clip, scripts\zm\replaced\zm_prison::delete_perk_machine_clip);
	replaceFunc(maps\mp\zm_prison_spoon::init, scripts\zm\replaced\zm_prison_spoon::init);
	replaceFunc(maps\mp\zm_prison_spoon::give_player_spoon_upon_receipt, scripts\zm\replaced\zm_prison_spoon::give_player_spoon_upon_receipt);
	replaceFunc(maps\mp\zm_prison_spoon::dip_the_spoon, scripts\zm\replaced\zm_prison_spoon::dip_the_spoon);
	replaceFunc(maps\mp\zm_prison_spoon::extra_death_func_to_check_for_splat_death, scripts\zm\replaced\zm_prison_spoon::extra_death_func_to_check_for_splat_death);
	replaceFunc(maps\mp\zm_prison_sq_bg::give_sq_bg_reward, scripts\zm\replaced\zm_prison_sq_bg::give_sq_bg_reward);
	replaceFunc(maps\mp\zm_prison_sq_final::stage_one, scripts\zm\replaced\zm_prison_sq_final::stage_one);
	replaceFunc(maps\mp\zm_prison_sq_final::final_flight_trigger, scripts\zm\replaced\zm_prison_sq_final::final_flight_trigger);
	replaceFunc(maps\mp\zm_prison_sq_wth::sq_is_weapon_sniper, scripts\zm\replaced\zm_prison_sq_wth::sq_is_weapon_sniper);
	replaceFunc(maps\mp\zombies\_zm_afterlife::init_player, scripts\zm\replaced\_zm_afterlife::init_player);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_add, scripts\zm\replaced\_zm_afterlife::afterlife_add);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_laststand, scripts\zm\replaced\_zm_afterlife::afterlife_laststand);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_revive_trigger_think, scripts\zm\replaced\_zm_afterlife::afterlife_revive_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_revive_do_revive, scripts\zm\replaced\_zm_afterlife::afterlife_revive_do_revive);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_corpse_cleanup, scripts\zm\replaced\_zm_afterlife::afterlife_corpse_cleanup);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_player_damage_callback, scripts\zm\replaced\_zm_afterlife::afterlife_player_damage_callback);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_save_loadout, scripts\zm\replaced\_zm_afterlife::afterlife_save_loadout);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_give_loadout, scripts\zm\replaced\_zm_afterlife::afterlife_give_loadout);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_trigger_think, scripts\zm\replaced\_zm_afterlife::afterlife_trigger_think);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_can_revive, scripts\zm\replaced\_zm_afterlife::afterlife_can_revive);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_doors_open, scripts\zm\replaced\_zm_afterlife::afterlife_doors_open);
	replaceFunc(maps\mp\zombies\_zm_afterlife::afterlife_doors_close, scripts\zm\replaced\_zm_afterlife::afterlife_doors_close);

	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield_prison::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield_prison::trackriotshield, scripts\zm\replaced\_zm_riotshield_prison::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield_prison::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::riotshield_fling_zombie, scripts\zm\replaced\_zm_weap_riotshield_prison::riotshield_fling_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield_prison::riotshield_knockdown_zombie, scripts\zm\replaced\_zm_weap_riotshield_prison::riotshield_knockdown_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::init, scripts\zm\replaced\_zm_weap_blundersplat::init);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::wait_for_blundersplat_fired, scripts\zm\replaced\_zm_weap_blundersplat::wait_for_blundersplat_fired);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::wait_for_blundersplat_upgraded_fired, scripts\zm\replaced\_zm_weap_blundersplat::wait_for_blundersplat_upgraded_fired);
	replaceFunc(maps\mp\zombies\_zm_weap_blundersplat::_titus_target_animate_and_die, scripts\zm\replaced\_zm_weap_blundersplat::_titus_target_animate_and_die);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::calculate_tomahawk_damage, scripts\zm\replaced\_zm_weap_tomahawk::calculate_tomahawk_damage);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::get_grenade_charge_power, scripts\zm\replaced\_zm_weap_tomahawk::get_grenade_charge_power);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_attack_zombies, scripts\zm\replaced\_zm_weap_tomahawk::tomahawk_attack_zombies);
	replaceFunc(maps\mp\zombies\_zm_weap_tomahawk::tomahawk_return_player, scripts\zm\replaced\_zm_weap_tomahawk::tomahawk_return_player);

	if (!is_gametype_active("zclassic") && !is_gametype_active("zgrief"))
	{
		level.zombiemode_using_divetonuke_perk = 1;
		maps\mp\zombies\_zm_perk_divetonuke::enable_divetonuke_perk_for_level();

		level.zombiemode_using_additionalprimaryweapon_perk = 1;

		precacheModel("p6_zm_al_shock_box_on");
	}

	if (!is_gametype_active("zclassic"))
	{
		level.zombiemode_using_electric_cherry_perk = 1;
		maps\mp\zombies\_zm_perk_electric_cherry::enable_electric_cherry_perk_for_level();

		level thread turn_on_electric_cherry();
	}

	door_changes();
}

init()
{
	precacheModel("collision_geo_32x32x128_standard");
	precacheModel("collision_player_sphere_32");

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::check_for_special_weapon_limit_exist;

	level.zombie_vars["below_world_check"] = -15000;

	maps\mp\zombies\_zm::spawn_life_brush((94, 6063, 240), 256, 256);

	alcatraz_add_player_dialogue("player", "perk", "specialty_flakjacket", "perk_generic", undefined, 100);
	alcatraz_add_player_dialogue("player", "perk", "specialty_additionalprimaryweapon", "perk_generic", undefined, 100);

	player_initial_spawn_override();
	player_respawn_override();
	spawn_kill_brushes();
	docks_gates_remain_open();

	level thread maps\mp\_sticky_grenade::init();

	level thread teleporters();
	level thread admin_powerhouse_puzzle_door_disconnect_paths_think();
	level thread grief_brutus_spawn_after_time();
}

door_changes()
{
	num = 0;
	targets = getentarray("cellblock_start_door", "targetname");
	zombie_doors = getentarray("zombie_door", "targetname");

	for (i = 0; i < zombie_doors.size; i++)
	{
		if (isdefined(zombie_doors[i].target) && zombie_doors[i].target == "cellblock_start_door")
		{
			zombie_doors[i].zombie_cost = 750;
			zombie_doors[i].target += num;
			targets[num].targetname += num;
			targets[num + 2].targetname += num;
			num++;
		}
	}
}

turn_on_electric_cherry()
{
	flag_wait("initial_blackscreen_passed");

	wait 1;

	level notify("electric_cherry_on");
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;
	self setphysparams(15, 0, 48);
}

check_for_special_weapon_limit_exist(weapon)
{
	if (weapon != "blundergat_zm" && weapon != "minigun_alcatraz_zm")
	{
		return 1;
	}

	players = get_players();
	count = 0;

	if (weapon == "blundergat_zm")
	{
		if (self maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("blundersplat_zm"))
		{
			return 0;
		}

		if (self afterlife_weapon_limit_check("blundergat_zm"))
		{
			return 0;
		}

		limit = level.limited_weapons["blundergat_zm"];
	}
	else
	{
		if (self afterlife_weapon_limit_check("minigun_alcatraz_zm"))
		{
			return 0;
		}

		limit = level.limited_weapons["minigun_alcatraz_zm"];
	}

	i = 0;

	while (i < players.size)
	{
		if (weapon == "blundergat_zm")
		{
			if (players[i] maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade("blundersplat_zm") || isDefined(players[i].is_pack_splatting) && players[i].is_pack_splatting)
			{
				count++;
				i++;
				continue;
			}
		}
		else
		{
			if (players[i] afterlife_weapon_limit_check(weapon))
			{
				count++;
			}
		}

		i++;
	}

	if (count >= limit)
	{
		return 0;
	}

	return 1;
}

player_initial_spawn_override()
{
	initial_spawns = getstructarray("initial_spawn", "script_noteworthy");
	remove_initial_spawns = [];

	if (level.scr_zm_map_start_location == "cellblock")
	{
		foreach (initial_spawn in initial_spawns)
		{
			if (initial_spawn.origin == (704, 9672, 1470) || initial_spawn.origin == (1008, 9684, 1470))
			{
				remove_initial_spawns[remove_initial_spawns.size] = initial_spawn;
			}
			else if (initial_spawn.origin == (704, 9712, 1471) || initial_spawn.origin == (1008, 9720, 1470))
			{
				initial_spawn.origin += (0, -16, 0);
			}
			else if (initial_spawn.origin == (704, 9632, 1470) || initial_spawn.origin == (1008, 9640, 1470))
			{
				initial_spawn.origin += (0, 16, 0);
			}

			// prevents spawning up top in 3rd Floor zone due to not being enough height clearance
			initial_spawn.origin += (0, 0, -16);
		}
	}

	foreach (initial_spawn in remove_initial_spawns)
	{
		arrayremovevalue(initial_spawns, initial_spawn);
	}
}

player_respawn_override()
{
	respawn_points = getstructarray("player_respawn_point", "targetname");

	foreach (respawn_point in respawn_points)
	{
		if (respawn_point.script_noteworthy == "zone_cafeteria")
		{
			respawn_array = getstructarray(respawn_point.target, "targetname");
			remove_respawn_array = [];

			foreach (respawn in respawn_array)
			{
				if (respawn.origin == (2536, 9704, 1360))
				{
					// respawn is in acid trap
					remove_respawn_array[remove_respawn_array.size] = respawn;
				}
			}

			foreach (respawn in remove_respawn_array)
			{
				arrayremovevalue(respawn_array, respawn);
			}
		}
	}
}

spawn_kill_brushes()
{
	t_killbrush_1 = spawn("trigger_box", (1612, 9531, 1472), 0, 420, 160, 64);
	t_killbrush_1.script_noteworthy = "kill_brush";

	t_killbrush_2 = spawn("trigger_box", (1572, 9807, 1472), 0, 380, 160, 64);
	t_killbrush_2.script_noteworthy = "kill_brush";
}

docks_gates_remain_open()
{
	if (flag_exists("docks_gates_remain_open"))
	{
		flag_set("docks_gates_remain_open");
	}
}

teleporters()
{
	flag_wait("initial_blackscreen_passed");

	teleporters = [];

	teleporter = spawnstruct();
	teleporter.start_origin = (-253, 5660, -72);
	teleporter.end_origin = (-265, 5699, 17);
	teleporters[teleporters.size] = teleporter;

	foreach (teleporter in teleporters)
	{
		level thread teleporter_think(teleporter.start_origin, teleporter.end_origin);
	}
}

teleporter_think(teleporter_start_origin, teleporter_end_origin)
{
	trig = spawn("trigger_radius", teleporter_start_origin, 0, 8, 64);

	while (1)
	{
		trig waittill("trigger", player);

		height_diff = player.origin[2] - groundpos(player.origin)[2];

		playsoundatposition("evt_teleport_3d", player.origin);
		player setorigin(teleporter_end_origin + (0, 0, height_diff));
	}
}

admin_powerhouse_puzzle_door_disconnect_paths_think()
{
	admin_powerhouse_puzzle_door_clip = getent("admin_powerhouse_puzzle_door_clip", "targetname");

	barrier = spawn("script_model", admin_powerhouse_puzzle_door_clip.origin + anglestoright(admin_powerhouse_puzzle_door_clip.angles) * -3, 1);
	barrier.angles = admin_powerhouse_puzzle_door_clip.angles;
	barrier setmodel("collision_wall_64x64x10_standard");
	barrier disconnectpaths();

	while (isdefined(admin_powerhouse_puzzle_door_clip))
	{
		wait 0.05;
	}

	barrier connectpaths();
	barrier delete();
}

grief_brutus_spawn_after_time()
{
	if (!is_encounter())
	{
		return;
	}

	level endon("end_game");

	level waittill("restart_round_start");

	while (1)
	{
		time = randomIntRange(240, 360);

		wait time;


		while (level.brutus_count <= 0)
		{
			wait 1;
		}

		while (level.brutus_count > 0)
		{
			wait 1;
		}
	}
}
