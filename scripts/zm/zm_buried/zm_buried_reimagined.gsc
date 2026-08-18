#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

main()
{
	replaceFunc(character\c_transit_player_farmgirl::precache, character\c_highrise_player_farmgirl::precache);
	replaceFunc(character\c_transit_player_oldman::precache, character\c_highrise_player_oldman::precache);
	replaceFunc(character\c_transit_player_engineer::precache, character\c_highrise_player_engineer::precache);
	replaceFunc(character\c_transit_player_farmgirl::main, character\c_highrise_player_farmgirl::main);
	replaceFunc(character\c_transit_player_oldman::main, character\c_highrise_player_oldman::main);
	replaceFunc(character\c_transit_player_engineer::main, character\c_highrise_player_engineer::main);
	replaceFunc(maps\mp\zm_buried_sq::navcomputer_waitfor_navcard, scripts\zm\reimagined\_zm_sq::navcomputer_waitfor_navcard);
	replaceFunc(maps\mp\zm_buried::init_level_specific_wall_buy_fx, scripts\zm\replaced\zm_buried::init_level_specific_wall_buy_fx);
	replaceFunc(maps\mp\zm_buried::buried_zone_init, scripts\zm\replaced\zm_buried::buried_zone_init);
	replaceFunc(maps\mp\zm_buried::give_team_characters, scripts\zm\replaced\zm_buried::give_team_characters);
	replaceFunc(maps\mp\zm_buried_grief_street::precache, scripts\zm\replaced\zm_buried_grief_street::precache);
	replaceFunc(maps\mp\zm_buried_grief_street::main, scripts\zm\replaced\zm_buried_grief_street::main);
	replaceFunc(maps\mp\zm_buried_buildables::prepare_chalk_weapon_list, scripts\zm\replaced\zm_buried_buildables::prepare_chalk_weapon_list);
	replaceFunc(maps\mp\zm_buried_buildables::init_buildables, scripts\zm\replaced\zm_buried_buildables::init_buildables);
	replaceFunc(maps\mp\zm_buried_buildables::subwooferbuildable, scripts\zm\replaced\zm_buried_buildables::subwooferbuildable);
	replaceFunc(maps\mp\zm_buried_buildables::springpadbuildable, scripts\zm\replaced\zm_buried_buildables::springpadbuildable);
	replaceFunc(maps\mp\zm_buried_buildables::headchopperbuildable, scripts\zm\replaced\zm_buried_buildables::headchopperbuildable);
	replaceFunc(maps\mp\zm_buried_buildables::watch_cell_open_close, scripts\zm\replaced\zm_buried_buildables::watch_cell_open_close);
	replaceFunc(maps\mp\zm_buried_classic::insta_kill_player, scripts\zm\replaced\zm_buried_classic::insta_kill_player);
	replaceFunc(maps\mp\zm_buried_gamemodes::init, scripts\zm\replaced\zm_buried_gamemodes::init);
	replaceFunc(maps\mp\zm_buried_gamemodes::buildbuildable, scripts\zm\replaced\zm_buried_gamemodes::buildbuildable);
	replaceFunc(maps\mp\zm_buried_gamemodes::builddynamicwallbuy, scripts\zm\replaced\zm_buried_gamemodes::builddynamicwallbuy);
	replaceFunc(maps\mp\zm_buried_ffotd::main_end, scripts\zm\replaced\zm_buried_ffotd::main_end);
	replaceFunc(maps\mp\zm_buried_ffotd::jail_traversal_fix, scripts\zm\replaced\zm_buried_ffotd::jail_traversal_fix);
	replaceFunc(maps\mp\zm_buried_ffotd::time_bomb_takeaway, scripts\zm\replaced\zm_buried_ffotd::time_bomb_takeaway);
	replaceFunc(maps\mp\zm_buried_ffotd::spawned_life_triggers, scripts\zm\replaced\zm_buried_ffotd::spawned_life_triggers);
	replaceFunc(maps\mp\zm_buried_fountain::transport_player_to_start_zone, scripts\zm\replaced\zm_buried_fountain::transport_player_to_start_zone);
	replaceFunc(maps\mp\zm_buried_sq_bt::stage_vo_watch_gallows, scripts\zm\replaced\zm_buried_sq_bt::stage_vo_watch_gallows);
	replaceFunc(maps\mp\zm_buried_sq_bt::stage_vo_watch_guillotine, scripts\zm\replaced\zm_buried_sq_bt::stage_vo_watch_guillotine);
	replaceFunc(maps\mp\zm_buried_sq_tpo::promote_to_corpse_model, scripts\zm\replaced\zm_buried_sq_tpo::promote_to_corpse_model);
	replaceFunc(maps\mp\zm_buried_distance_tracking::escaped_zombies_cleanup_init, scripts\zm\replaced\zm_buried_distance_tracking::escaped_zombies_cleanup_init);
	replaceFunc(maps\mp\zm_buried_distance_tracking::delete_zombie_noone_looking, scripts\zm\replaced\zm_buried_distance_tracking::delete_zombie_noone_looking);
	replaceFunc(maps\mp\zombies\_zm_ai_ghost::prespawn, scripts\zm\replaced\_zm_ai_ghost::prespawn);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::start_jail_run, scripts\zm\replaced\_zm_ai_sloth::start_jail_run);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::start_jail_wait, scripts\zm\replaced\_zm_ai_sloth::start_jail_wait);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::update_jail_idle, scripts\zm\replaced\_zm_ai_sloth::update_jail_idle);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::update_jail_wait, scripts\zm\replaced\_zm_ai_sloth::update_jail_wait);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::update_eat, scripts\zm\replaced\_zm_ai_sloth::update_eat);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::sloth_check_ragdolls, scripts\zm\replaced\_zm_ai_sloth::sloth_check_ragdolls);
	replaceFunc(maps\mp\zombies\_zm_ai_sloth::sloth_ragdoll_zombie, scripts\zm\replaced\_zm_ai_sloth::sloth_ragdoll_zombie);
	replaceFunc(maps\mp\zombies\_zm_equip_subwoofer::hit_player, scripts\zm\replaced\_zm_equip_subwoofer::hit_player);
	replaceFunc(maps\mp\zombies\_zm_equip_subwoofer::startsubwooferdecay, scripts\zm\replaced\_zm_equip_subwoofer::startsubwooferdecay);
	replaceFunc(maps\mp\zombies\_zm_equip_subwoofer::subwoofer_network_choke, scripts\zm\replaced\_zm_equip_subwoofer::subwoofer_network_choke);
	replaceFunc(maps\mp\zombies\_zm_equip_springpad::springpadthink, scripts\zm\replaced\_zm_equip_springpad::springpadthink);
	replaceFunc(maps\mp\zombies\_zm_equip_headchopper::init_anim_slice_times, scripts\zm\replaced\_zm_equip_headchopper::init_anim_slice_times);
	replaceFunc(maps\mp\zombies\_zm_equip_headchopper::headchopperthink, scripts\zm\replaced\_zm_equip_headchopper::headchopperthink);
	replaceFunc(maps\mp\zombies\_zm_equip_headchopper::setupwatchers, scripts\zm\replaced\_zm_equip_headchopper::setupwatchers);
	replaceFunc(maps\mp\zombies\_zm_perk_vulture::_vulture_perk_think, scripts\zm\replaced\_zm_perk_vulture::_vulture_perk_think);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::slowgun_zombie_damage_response, scripts\zm\replaced\_zm_weap_slowgun::slowgun_zombie_damage_response);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::slowgun_fired, scripts\zm\replaced\_zm_weap_slowgun::slowgun_fired);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::zombie_paralyzed, scripts\zm\replaced\_zm_weap_slowgun::zombie_paralyzed);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::zombie_slow_for_time, scripts\zm\replaced\_zm_weap_slowgun::zombie_slow_for_time);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::slowgun_zombie_death_response, scripts\zm\replaced\_zm_weap_slowgun::slowgun_zombie_death_response);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::player_slow_for_time, scripts\zm\replaced\_zm_weap_slowgun::player_slow_for_time);
	replaceFunc(maps\mp\zombies\_zm_weap_slowgun::watch_reset_anim_rate, scripts\zm\replaced\_zm_weap_slowgun::watch_reset_anim_rate);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_deposit_unitrigger, scripts\zm\replaced\_zm_banking::bank_deposit_unitrigger);
	replaceFunc(maps\mp\zombies\_zm_banking::bank_withdraw_unitrigger, scripts\zm\replaced\_zm_banking::bank_withdraw_unitrigger);
}

init()
{
	precachemodel("collision_wall_128x128x10_standard");
	precachemodel("collision_wall_256x256x10_standard");

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::buried_special_weapon_magicbox_check;
	level.get_current_ghost_count_func = maps\mp\zombies\_zm_ai_ghost::get_current_ghost_count;

	maps\mp\zm_buried::buried_add_player_dialogue("player", "perk", "specialty_scavenger", "perk_tombstone", undefined, 100);

	player_initial_spawn_override();
	add_mansion_backyard_collision();
	move_divetonuke_collision();
	move_tombstone_collision();

	level thread enable_fountain_transport();
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;
	self.zombie_path_bad = 0;
	self thread maps\mp\zm_buried_distance_tracking::escaped_zombies_cleanup_init();
	self setphysparams(15, 0, 48);
}

buried_special_weapon_magicbox_check(weapon)
{
	if (weapon == "time_bomb_zm")
	{
		players = get_players();
		i = 0;

		while (i < players.size)
		{
			if (is_player_valid(players[i], undefined, 1) && players[i] is_player_tactical_grenade(weapon))
			{
				return 0;
			}

			i++;
		}
	}

	return 1;
}

player_initial_spawn_override()
{
	initial_spawns = getstructarray("initial_spawn", "script_noteworthy");

	if (level.scr_zm_map_start_location == "street")
	{
		// remove existing initial spawns
		level.struct_class_names["script_noteworthy"]["initial_spawn"] = [];

		// set new initial spawns to be same as respawns already on map
		ind = 0;
		respawn_points = maps\mp\gametypes_zm\_zm_gametype::get_player_spawns_for_gametype();

		for (i = 0; i < respawn_points.size; i++)
		{
			if (respawn_points[i].script_noteworthy == "zone_stables")
			{
				ind = i;
				break;
			}
		}

		respawn_array = getstructarray(respawn_points[ind].target, "targetname");

		foreach (respawn in respawn_array)
		{
			struct = spawnStruct();
			struct.origin = respawn.origin;
			struct.angles = respawn.angles;
			struct.radius = respawn.radius;
			struct.script_int = respawn.script_int;
			struct.script_noteworthy = "initial_spawn";
			struct.script_string = "zstandard_street zgrief_street";

			if (struct.origin == (-875.5, -33.85, 139.25))
			{
				struct.angles = (0, 10, 0);
			}
			else if (struct.origin == (-910.13, -90.16, 139.59))
			{
				struct.angles = (0, 20, 0);
			}
			else if (struct.origin == (-921.9, -134.67, 140.62))
			{
				struct.angles = (0, 30, 0);
			}
			else if (struct.origin == (-891.27, -209.95, 137.94))
			{
				struct.angles = (0, 55, 0);
				struct.script_int = 2;
			}
			else if (struct.origin == (-836.66, -257.92, 133.16))
			{
				struct.angles = (0, 65, 0);
			}
			else if (struct.origin == (-763, -259.07, 127.72))
			{
				struct.angles = (0, 90, 0);
			}
			else if (struct.origin == (-737.98, -212.92, 125.4))
			{
				struct.angles = (0, 85, 0);
			}
			else if (struct.origin == (-722.02, -151.75, 124.14))
			{
				struct.angles = (0, 80, 0);
				struct.script_int = 1;
			}

			size = level.struct_class_names["script_noteworthy"][struct.script_noteworthy].size;
			level.struct_class_names["script_noteworthy"][struct.script_noteworthy][size] = struct;
		}
	}
}

enable_fountain_transport()
{
	if (!is_gametype_active("zclassic"))
	{
		return;
	}

	flag_wait("initial_blackscreen_passed");

	wait 1;

	level notify("courtyard_fountain_open");
}

add_mansion_backyard_collision()
{
	origin = (3432, 856, 58);
	angles = (0, 90, 0);

	collision = spawn("script_model", origin + anglesToUp(angles) * 128);
	collision.angles = angles;
	collision setmodel("collision_wall_256x256x10_standard");

	trigs = undefined;

	if (is_gametype_active("zclassic"))
	{
		trigs = getentarray("vending_deadshot", "target");
	}
	else if (level.scr_zm_map_start_location == "maze")
	{
		trigs = getentarray("vending_additionalprimaryweapon", "target");
	}

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (isdefined(trig.clip))
		{
			trig.clip delete();
		}
	}
}

move_divetonuke_collision()
{
	if (!is_gametype_active("zclassic"))
	{
		return;
	}

	trigs = getentarray("vending_divetonuke", "target");

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (isdefined(trig.clip))
		{
			trig.clip.origin += anglestoup(trig.clip.angles) * -128;
		}
	}
}

move_tombstone_collision()
{
	if (!is_gametype_active("zclassic"))
	{
		return;
	}

	trigs = getentarray("vending_tombstone", "target");

	if (!isdefined(trigs))
	{
		return;
	}

	foreach (trig in trigs)
	{
		if (isdefined(trig.clip))
		{
			trig.clip.origin += anglestoright(trig.clip.angles) * 8;
		}
	}
}

