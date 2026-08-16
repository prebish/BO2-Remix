#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;

main()
{
	replaceFunc(maps\mp\gametypes_zm\zgrief::onprecachegametype, scripts\zm\replaced\zgrief::onprecachegametype);
	replaceFunc(maps\mp\gametypes_zm\zgrief::postinit_func, scripts\zm\replaced\zgrief::postinit_func);
	replaceFunc(maps\mp\gametypes_zm\zgrief::zgrief_main, scripts\zm\replaced\zgrief::zgrief_main);
	replaceFunc(maps\mp\gametypes_zm\zgrief::game_mode_spawn_player_logic, scripts\zm\replaced\zgrief::game_mode_spawn_player_logic);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_bounce_override, scripts\zm\replaced\zgrief::meat_bounce_override);
	replaceFunc(maps\mp\gametypes_zm\zgrief::meat_stink, scripts\zm\replaced\zgrief::meat_stink);
	replaceFunc(maps\mp\gametypes_zm\zmeat::main, maps\mp\gametypes_zm\zgrief::main);
	replaceFunc(maps\mp\gametypes_zm\zmeat::create_item_meat_watcher, scripts\zm\replaced\zmeat::create_item_meat_watcher);
	replaceFunc(maps\mp\zombies\_zm_game_module_meat_utility::init_item_meat, scripts\zm\replaced\_zm_game_module_meat_utility::init_item_meat);

	if (getdvar("mapname") == "zm_nuked" || getdvar("mapname") == "zm_highrise" || getdvar("mapname") == "zm_tomb")
	{
		registerclientfield("toplayer", "meat_stink", 1, 1, "int");
	}

	registerclientfield("toplayer", "meat_glow", 1, 1, "int");

	if (getdvar("mapname") == "zm_prison" || getdvar("mapname") == "zm_tomb")
	{
		level._effect["butterflies"] = loadfx("maps/zombie_alcatraz/fx_alcatraz_skull_elec");
	}
	else
	{
		level._effect["butterflies"] = loadfx("maps/zombie/fx_zmb_impact_noharm");
	}

	level._effect["zombie_disappears"] = loadfx("maps/zombie/fx_zmb_returned_spawn_puff");
}

init()
{
	set_grief_vars();

	precacheStatusIcon(level.item_meat_status_icon_name);

	precacheString(&"hud_update_game_mode_name");
	precacheString(&"hud_update_scoring_team");
	precacheString(&"hud_update_player_count");
	precacheString(&"show_dead_spectate_hud");
	precacheString(&"hide_dead_spectate_hud");

	precacheshellshock("grief_stun_zm");

	enemy_powerup_hud();
	obj_waypoint();

	add_custom_limited_weapon_check(::is_weapon_available_in_grief_saved_weapons);

	level.dont_allow_meat_interaction = 1;
	level.can_revive_game_module = ::can_revive;
	level._powerup_grab_check = ::powerup_can_player_grab;
	level._zombiemode_powerup_grab = ::powerup_grab;

	level.custom_spectate_permissions = ::setspectatepermissions;

	level.is_respawn_gamemode_func = ::is_respawn_gamemode;
	level.round_start_wait_func = ::round_start_wait;
	level.increment_score_func = ::increment_score;
	level.grief_score_hud_set_player_count_func = ::grief_score_hud_set_player_count;
	level.show_grief_hud_msg_func = ::show_grief_hud_msg;
	level.store_player_damage_info_func = ::store_player_damage_info;

	level thread grief_gamemode_name_hud();
	level thread grief_intro_msg();
	level thread round_start_wait(5, true);
	level thread unlimited_zombies();
	level thread unlimited_powerups();
	level thread save_teams_on_intermission();

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		meat_init();
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		turned_init();
	}

	if (is_true(level.scr_zm_ui_gametype_pro))
	{
		level thread remove_held_melee_weapons();
	}
}

grief_gamemode_name_hud()
{
	flag_wait("hud_visible");

	level.game_mode_name_hud_value = &"";

	players = get_players();

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_game_mode_name", 1, level.game_mode_name_hud_value);
	}
}

grief_score_hud_set_player_count(team, count, team2, count2)
{
	if (!isdefined(level.game_mode_player_count_hud_value))
	{
		level.game_mode_player_count_hud_value = [];
		level.game_mode_player_count_hud_value["allies"] = -1;
		level.game_mode_player_count_hud_value["axis"] = -1;
	}

	if (!isdefined(team2))
	{
		if (level.game_mode_player_count_hud_value[team] == count)
		{
			return;
		}
	}
	else
	{
		if (level.game_mode_player_count_hud_value[team] == count && level.game_mode_player_count_hud_value[team2] == count2)
		{
			return;
		}
	}

	level.game_mode_player_count_hud_value[team] = count;

	if (isdefined(team2))
	{
		level.game_mode_player_count_hud_value[team2] = count2;
	}

	players = get_players("allies");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_player_count", 2, level.game_mode_player_count_hud_value["allies"], level.game_mode_player_count_hud_value["axis"]);
	}

	players = get_players("axis");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_player_count", 2, level.game_mode_player_count_hud_value["axis"], level.game_mode_player_count_hud_value["allies"]);
	}
}

grief_score_hud_set_scoring_team(team)
{
	if (!isdefined(level.game_mode_scoring_team_hud_value))
	{
		level.game_mode_scoring_team_hud_value = [];
		level.game_mode_scoring_team_hud_value["allies"] = -1;
		level.game_mode_scoring_team_hud_value["axis"] = -1;
	}

	value = [];
	value["allies"] = 0;
	value["axis"] = 0;

	if (team == "neutral")
	{
		value["allies"] = 0;
		value["axis"] = 0;
	}
	else if (team == "allies")
	{
		value["allies"] = 1;
		value["axis"] = 2;
	}
	else if (team == "axis")
	{
		value["allies"] = 2;
		value["axis"] = 1;
	}
	else if (team == "contested")
	{
		value["allies"] = 3;
		value["axis"] = 3;
	}
	else if (team == "none")
	{
		value["allies"] = 4;
		value["axis"] = 4;
	}

	if (level.game_mode_scoring_team_hud_value["allies"] == value["allies"] && level.game_mode_scoring_team_hud_value["axis"] == value["axis"])
	{
		return;
	}

	level.game_mode_scoring_team_hud_value["allies"] = value["allies"];
	level.game_mode_scoring_team_hud_value["axis"] = value["axis"];

	players = get_players("allies");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_scoring_team", 1, level.game_mode_scoring_team_hud_value["allies"]);
	}

	players = get_players("axis");

	foreach (player in players)
	{
		player luinotifyevent(&"hud_update_scoring_team", 1, level.game_mode_scoring_team_hud_value["axis"]);
	}
}

enemy_powerup_hud()
{
	registerclientfield("toplayer", "powerup_instant_kill_enemy", 1, 2, "int");
	registerclientfield("toplayer", "powerup_double_points_enemy", 1, 2, "int");

	powerup = level.zombie_powerups["insta_kill"];

	if (isdefined(powerup))
	{
		powerup.enemy_client_field_name = powerup.client_field_name + "_enemy";
	}

	powerup = level.zombie_powerups["double_points"];

	if (isdefined(powerup))
	{
		powerup.enemy_client_field_name = powerup.client_field_name + "_enemy";
	}
}

obj_waypoint()
{
	if (level.scr_zm_ui_gametype == "zmeat")
	{
		level.game_mode_obj_ind = 16;

		objective_state(level.game_mode_obj_ind, "active");
		objective_setgamemodeflags(level.game_mode_obj_ind, 0);
	}
}

set_grief_vars()
{
	setDvar("ui_scorelimit", 1);
	setteamscore("axis", 0);
	setteamscore("allies", 0);

	level.highest_score = 0;
	setroundsplayed(level.highest_score);

	level.noroundnumber = 1;
	level.hide_revive_message = 1;
	level.custom_end_screen = ::custom_end_screen;
	level.game_module_onplayerconnect = ::grief_onplayerconnect;
	level.game_mode_custom_onplayerdisconnect = ::grief_onplayerdisconnect;
	level._game_module_player_damage_callback = ::game_module_player_damage_callback;

	if (level.scr_zm_ui_gametype == "zturned")
	{
		level._game_module_player_laststand_callback = undefined;
		level.onplayerspawned_restore_previous_weapons = undefined;
	}
	else
	{
		level._game_module_player_laststand_callback = ::grief_laststand_weapon_save;
		level.onplayerspawned_restore_previous_weapons = ::grief_laststand_weapons_return;
	}

	level.grief_score = [];
	level.grief_score["A"] = 0;
	level.grief_score["B"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_insta_kill_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_insta_kill_time"] = 15;
	level.zombie_vars["axis"]["zombie_powerup_point_doubler_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_point_doubler_time"] = 15;
	level.zombie_vars["axis"]["zombie_powerup_point_halfer_on"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_point_halfer_time"] = 15;
	level.zombie_vars["allies"]["zombie_powerup_point_halfer_on"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_point_halfer_time"] = 15;
	level.zombie_vars["axis"]["zombie_half_damage"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_half_damage_on"] = 0;
	level.zombie_vars["axis"]["zombie_powerup_half_damage_time"] = 15;
	level.zombie_vars["allies"]["zombie_half_damage"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_half_damage_on"] = 0;
	level.zombie_vars["allies"]["zombie_powerup_half_damage_time"] = 15;

	level.player_starting_points = 10000;

	level.zombie_move_speed = 100;
	level.zombie_vars["zombie_health_start"] = 2500;
	level.zombie_vars["zombie_health_increase"] = 0;
	level.zombie_vars["zombie_health_increase_multiplier"] = 0;
	level.zombie_vars["zombie_spawn_delay"] = 0.5;

	level.brutus_health = 20000;
	level.brutus_expl_dmg_req = 18000;
	level.mechz_health = 22500;

	if (level.item_meat_name == "item_head_zm")
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_head";
	}
	else
	{
		level.item_meat_status_icon_name = "menu_zm_weapons_item_meat";
	}

	if (is_respawn_gamemode())
	{
		setDvar("player_lastStandBleedoutTime", 10);
	}
}

grief_onplayerconnect()
{
	self thread on_player_spawned();
	self thread on_player_downed();
	self thread on_player_revived();
	self thread on_player_bled_out();
	self thread on_player_spectate();
	self thread on_player_zom_kill();

	self thread stun_fx();
	self thread headstomp_watcher();
	self thread decrease_weapon_ammo();
	self thread maps\mp\gametypes_zm\zmeat::create_item_meat_watcher();

	self.killsconfirmed = 0;
	self.killsdenied = 0;
	self.captures = 0;
	self.returns = 0;

	if (is_respawn_gamemode())
	{
		self._retain_perks = 1;
	}
}

grief_onplayerdisconnect(disconnecting_player)
{
	level endon("end_game");

	if (isDefined(disconnecting_player.stun_fx_ents))
	{
		array_thread(disconnecting_player.stun_fx_ents, ::self_delete);
	}

	if (!isDefined(disconnecting_player.team) || (disconnecting_player.team != "axis" && disconnecting_player.team != "allies"))
	{
		return;
	}

	if (!flag("initial_blackscreen_passed"))
	{
		return;
	}

	if (isDefined(level.gamemodulewinningteam))
	{
		return;
	}

	if (isDefined(level.update_stats_func))
	{
		[[level.update_stats_func]](disconnecting_player);
	}

	if (level.scr_zm_ui_gametype == "zgrief")
	{
		if (disconnecting_player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			increment_score(getOtherTeam(disconnecting_player.team));
		}
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		if (disconnecting_player.team != level.zombie_team)
		{
			amount = 0;

			if (!disconnecting_player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				amount = -1;
			}

			increment_score("allies", amount, 0, &"ZOMBIE_ZTURNED_SURVIVOR_DISAPPEARED");
		}
		else
		{
			increment_score("allies", 0, 0, &"ZOMBIE_ZTURNED_ZOMBIE_DISAPPEARED");
		}
	}

	player_count = get_players().size - 1;

	if (player_count == 1)
	{
		last_player = undefined;
		players = get_players();

		foreach (player in players)
		{
			if (player != disconnecting_player)
			{
				last_player = player;
				break;
			}
		}

		encounters_team = "A";

		if (last_player.team == "allies")
		{
			encounters_team = "B";
		}

		scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
	}

	team_player_count = get_players(disconnecting_player.team).size - 1;

	if (team_player_count == 0)
	{
		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (disconnecting_player.team == level.zombie_team)
			{
				level thread the_disease_powerup_drop(disconnecting_player.origin, 1);
			}
		}
		else
		{
			encounters_team = "A";

			if (getOtherTeam(disconnecting_player.team) == "allies")
			{
				encounters_team = "B";
			}

			scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
		}
	}

	if (level.scr_zm_ui_gametype == "zmeat")
	{
		if (isdefined(level.meat_player) && disconnecting_player == level.meat_player)
		{
			level thread scripts\zm\replaced\zgrief::meat_drop(disconnecting_player.origin, 1);
		}
	}

	if (level.teamcount > 1)
	{
		team_var = "team_" + disconnecting_player.team;

		setDvar(team_var, getDvar(team_var) + disconnecting_player getguid() + " ");
	}
}

on_player_spawned()
{
	level endon("end_game");
	self endon("disconnect");

	self.grief_initial_spawn = true;

	while (1)
	{
		self waittill("spawned_player");
		waittillframeend;

		if (self.sessionstate != "playing")
		{
			continue;
		}

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.team == level.zombie_team)
			{
				self turned_zombie_spawn();
				continue;
			}
		}

		self thread scripts\zm\replaced\_zm::player_spawn_protection();

		if (self.grief_initial_spawn)
		{
			self.grief_initial_spawn = false;

			if (is_respawn_gamemode() && flag("start_zombie_round_logic"))
			{
				self giveWeapon(self get_player_lethal_grenade());
				self setWeaponAmmoClip(self get_player_lethal_grenade(), 2);
			}
		}

		if (is_respawn_gamemode())
		{
			self thread player_spawn();
		}
	}
}

on_player_downed()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("entering_last_stand");

		self kill_feed();
		self kill_scoreboard();
		self player_downed_reward();

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.team == level.zombie_team)
			{
				self thread turned_zombie_spectate();
				continue;
			}

			if (self.team != level.zombie_team)
			{
				increment_score(self.team, -1, 0, &"ZOMBIE_ZTURNED_SURVIVOR_DOWN");
			}
		}

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			level thread update_players_on_downed_no_score(self);
		}

	}
}

on_player_revived()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("player_revived", reviver);

		if (isDefined(reviver) && reviver != self)
		{
			self revive_feed(reviver);

			if (level.scr_zm_ui_gametype == "zgrief")
			{
				level thread update_players_on_revived_no_score(self);
			}

			if (level.scr_zm_ui_gametype == "zturned")
			{
				if (self.team != level.zombie_team)
				{
					increment_score(self.team, 1, 0, &"ZOMBIE_ZTURNED_SURVIVOR_REVIVED");
				}
			}
		}
	}
}

on_player_bled_out()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("bled_out");
		waittillframeend;

		playersuicided = is_true(self.playersuicided);
		is_zombie = is_true(self.is_zombie);

		if (playersuicided)
		{
			wait_network_frame();
		}

		if (isDefined(level.zombie_last_stand_ammo_return))
		{
			self [[level.zombie_last_stand_ammo_return]](1);
		}

		if (!is_respawn_gamemode() || playersuicided)
		{
			if (!is_zombie)
			{
				self bleedout_feed();
			}
		}

		if (is_respawn_gamemode())
		{
			if (!playersuicided)
			{
				self maps\mp\zombies\_zm::spectator_respawn();
				waittillframeend; // wait for spawned_player
			}
		}

		if (level.scr_zm_ui_gametype == "zgrief")
		{
			increment_score(getOtherTeam(self.team), 1, 1, &"ZOMBIE_ZGRIEF_PLAYER_DEAD_NO_SCORE", &"ZOMBIE_ZGRIEF_ALLY_DEAD_NO_SCORE");
		}

		if (level.scr_zm_ui_gametype == "zturned")
		{
			if (self.team != level.zombie_team)
			{
				self thread turned_zombie_init();
			}
		}
	}
}

on_player_spectate()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("spawned_spectator");
		waittillframeend;

		if (is_respawn_gamemode())
		{
			self thread player_wait_and_respawn();
		}

		if (level.scr_zm_ui_gametype == "zturned")
		{
			self thread turned_zombie_wait_and_respawn();
		}
	}
}

on_player_zom_kill()
{
	level endon("end_game");
	self endon("disconnect");

	while (1)
	{
		self waittill("zom_kill", zombie);

	}
}

kill_feed()
{
	if (isDefined(self.last_damaged_by))
	{
		// show weapon icon for melee damage
		if (self.last_damaged_by.meansofdeath == "MOD_MELEE")
		{
			self.last_damaged_by.meansofdeath = "MOD_UNKNOWN";

			// show melee weapon icon on Ballistic Knife w/ Bowie melee or Ballistic Knife w/ Galvaknuckles melee
			if (issubstr(self.last_damaged_by.weapon, "knife_ballistic_bowie"))
			{
				self.last_damaged_by.weapon = "held_bowie_knife_zm";
			}
			else if (issubstr(self.last_damaged_by.weapon, "knife_ballistic_no_melee"))
			{
				self.last_damaged_by.weapon = "held_tazer_knuckles_zm";
			}
		}

		// show weapon icon for impact damage
		if (self.last_damaged_by.meansofdeath == "MOD_IMPACT")
		{
			self.last_damaged_by.meansofdeath = "MOD_UNKNOWN";
		}

		// weapon icon only defined on held melee weapon
		if (is_melee_weapon(self.last_damaged_by.weapon))
		{
			self.last_damaged_by.weapon = get_held_melee_weapon(self.last_damaged_by.weapon);
		}

		obituary(self, self.last_damaged_by.attacker, self.last_damaged_by.weapon, self.last_damaged_by.meansofdeath);
	}
	else if (isDefined(self.last_meated_by))
	{
		obituary(self, self.last_meated_by.attacker, level.item_meat_name, "MOD_UNKNOWN");
	}
	else if (isDefined(self.last_emped_by))
	{
		obituary(self, self.last_emped_by.attacker, "emp_grenade_zm", "MOD_UNKNOWN");
	}
	else
	{
		if (is_true(self.is_zombie))
		{
			obituary(self, self, "none", "MOD_SUICIDE");
		}
		else
		{
			obituary(self, self, "none", "MOD_CRUSH");
		}
	}
}

bleedout_feed()
{
	attacker = self;

	if (isdefined(self.bled_out_by_attacker))
	{
		attacker = self.bled_out_by_attacker;
		self.bled_out_by_attacker = undefined;
	}

	obituary(self, attacker, "none", "MOD_SUICIDE");
}

revive_feed(reviver)
{
	weapon = level.revive_tool;

	if (isdefined(self.revived_by_weapon))
	{
		weapon = self.revived_by_weapon;
		self.revived_by_weapon = undefined;
	}

	obituary(self, reviver, weapon, "MOD_UNKNOWN");
}

kill_scoreboard()
{
	damaged_by = undefined;

	if (isDefined(self.last_damaged_by))
	{
		damaged_by = self.last_damaged_by;
	}
	else if (isDefined(self.last_meated_by))
	{
		damaged_by = self.last_meated_by;
	}
	else if (isDefined(self.last_emped_by))
	{
		damaged_by = self.last_emped_by;
	}

	if (isDefined(damaged_by))
	{
		if (is_true(self.is_zombie) || is_true(damaged_by.attacker.is_zombie))
		{
			damaged_by.attacker.returns++;
		}
		else
		{
			damaged_by.attacker.killsconfirmed++;
		}
	}
}

player_spawn()
{
	if (self.score < 500)
	{
		self.score = 500;
	}

	if (flag("initial_blackscreen_passed"))
	{
		playfx(level._effect["zombie_disappears"], self.origin);
		playsoundatposition("evt_appear_3d", self.origin);
		earthquake(0.5, 0.75, self.origin, 100);
		playrumbleonposition("explosion_generic", self.origin);
	}
}

player_wait_and_respawn()
{
	level endon("end_game");
	self endon("disconnect");

	if (isdefined(self.player_wait_and_respawn))
	{
		return;
	}

	self.player_wait_and_respawn = 1;

	time = self.bleedout_time;

	if (!isdefined(time))
	{
		time = 0;
	}

	time += 1;

	self scripts\zm\_zm_reimagined::setlowermessage(&"GAME_RESPAWNING", time);

	self luinotifyevent(&"show_dead_spectate_hud");

	wait time;

	self scripts\zm\_zm_reimagined::clearlowermessage();

	self luinotifyevent(&"hide_dead_spectate_hud");

	self.sessionstate = "playing";

	self maps\mp\zombies\_zm::spectator_respawn();

	self.player_wait_and_respawn = undefined;
}

get_held_melee_weapon(melee_weapon)
{
	if (!issubstr(melee_weapon, "held_"))
	{
		melee_weapon = "held_" + melee_weapon;
	}

	return melee_weapon;
}

player_downed_reward()
{
	damaged_by = undefined;

	if (isDefined(self.last_damaged_by))
	{
		damaged_by = self.last_damaged_by;
	}
	else if (isDefined(self.last_meated_by))
	{
		damaged_by = self.last_meated_by;
	}
	else if (isDefined(self.last_emped_by))
	{
		damaged_by = self.last_emped_by;
	}

	if (isDefined(damaged_by) && is_player_valid(damaged_by.attacker))
	{
		if (is_true(self.is_zombie))
		{
			level maps\mp\zombies\_zm_spawner::zombie_death_points(self.origin, self.damagemod, self.damagelocation, damaged_by.attacker, self);
		}
		else
		{
			score = 500 * maps\mp\zombies\_zm_score::get_points_multiplier(damaged_by.attacker);
			damaged_by.attacker maps\mp\zombies\_zm_score::add_to_player_score(score);
		}
	}
}

stun_fx()
{
	self endon("disconnect");

	self scripts\zm\_zm_reimagined::waittill_next_snapshot(1);

	self.stun_fx_ents = [];
	self.stun_fx_ind = 0;

	for (i = 0; i < 3; i++)
	{
		self.stun_fx_ents[i] = spawn("script_model", self.origin);
		self.stun_fx_ents[i] setmodel("tag_origin");
		self.stun_fx_ents[i] linkto(self);
	}
}

headstomp_watcher()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	while (1)
	{
		if (!is_player_valid(self))
		{
			wait 0.05;
			continue;
		}

		players = get_players();

		foreach (player in players)
		{
			if (player != self && player.team != self.team && is_player_valid(player) && player getStance() == "prone" && player isOnGround() && self.origin[2] > player.origin[2])
			{
				if (distance2d(self.origin, player.origin) <= 21 && (self.origin[2] - player.origin[2]) <= 30)
				{
					player store_player_damage_info(self, "none", "MOD_FALLING");
					player dodamage(player.health, player.origin);
				}
			}
		}

		wait 0.05;
	}
}

decrease_weapon_ammo()
{
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

	decreased_ammo_weapons = array(level.zombie_weapons[level.start_weapon].upgrade_name, "ray_gun_zm", "ray_gun_upgraded_zm", "raygun_mark2_zm", "raygun_mark2_upgraded_zm");

	while (1)
	{
		self waittill("weapon_ammo_change");

		foreach (weapon in self getweaponslistprimaries())
		{
			if (!isinarray(decreased_ammo_weapons, weapon))
			{
				continue;
			}

			max_ammo = int(weaponmaxammo(weapon) / 2);

			ammo = self getweaponammostock(weapon);

			if (ammo > max_ammo)
			{
				self setweaponammostock(weapon, max_ammo);
			}
		}
	}
}

round_start_wait(time, initial)
{
	level endon("end_game");

	if (!isDefined(initial))
	{
		initial = false;
	}

	if (initial)
	{
		flag_clear("spawn_zombies");

		flag_wait("start_zombie_round_logic");

		players = get_players();

		foreach (player in players)
		{
			player.hostmigrationcontrolsfrozen = 1; // fixes players being able to move after initial_blackscreen_passed
		}

		level thread freeze_hotjoin_players();

		flag_wait("initial_blackscreen_passed");
	}
	else
	{
		players = get_players();

		foreach (player in players)
		{
			player setOrigin(groundpos_ignore_water_new(player.origin)); // players normally spawn slightly above the ground
			player setPlayerAngles(player.spectator_respawn.angles); // fixes angles if player was looking around while spawning in
		}
	}

	zombie_spawn_time = time + 10;

	level thread zombie_spawn_wait(zombie_spawn_time);

	text = &"MP_MATCH_STARTING_IN";
	text_param = undefined;

	countdown_hud = scripts\zm\_zm_reimagined::countdown_hud(text, text_param, time);

	wait time;

	countdown_hud scripts\zm\_zm_reimagined::countdown_hud_destroy();

	players = get_players();

	foreach (player in players)
	{
		if (initial)
		{
			player.hostmigrationcontrolsfrozen = 0;
		}

		player freezeControls(0);
		player disableInvulnerability();
	}

	level notify("restart_round_start");
}

freeze_hotjoin_players()
{
	level endon("restart_round_start");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			if (!is_true(player.hostmigrationcontrolsfrozen))
			{
				player.hostmigrationcontrolsfrozen = 1;

				player thread wait_and_freeze();
				player enableInvulnerability();
			}
		}

		wait 0.05;
	}
}

wait_and_freeze()
{
	self endon("disconnect");

	wait 0.05;

	self freezeControls(1);
}

zombie_spawn_wait(time)
{
	level endon("end_game");
	level endon("restart_round");

	flag_clear("spawn_zombies");

	wait time;

	flag_set("spawn_zombies");
}

get_number_of_valid_players_team(team, excluded_player)
{
	num_player_valid = 0;
	players = get_players(team);

	foreach (player in players)
	{
		if (isDefined(excluded_player) && player == excluded_player)
		{
			continue;
		}

		if (is_player_valid(player))
		{
			num_player_valid += 1;
		}
	}

	return num_player_valid;
}

update_players_on_downed_no_score(excluded_player)
{
	team = excluded_player.team;
	other_team = getOtherTeam(team);
	players = get_players(team);
	other_players = get_players(other_team);
	encounters_team = "A";
	other_encounters_team = "B";

	if (team == "allies")
	{
		encounters_team = "B";
		other_encounters_team = "A";
	}

	score = level.grief_score[encounters_team];
	other_score = level.grief_score[other_encounters_team];

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_BLED_OUT_NO_SCORE");
	}

	foreach (player in other_players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_BLED_OUT_NO_SCORE");
	}
}

update_players_on_revived_no_score(excluded_player)
{
	team = excluded_player.team;
	other_team = getOtherTeam(team);
	players = get_players(team);
	other_players = get_players(other_team);
	encounters_team = "A";
	other_encounters_team = "B";

	if (team == "allies")
	{
		encounters_team = "B";
		other_encounters_team = "A";
	}

	score = level.grief_score[encounters_team];
	other_score = level.grief_score[other_encounters_team];

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_ALLY_REVIVED_NO_SCORE");
	}

	foreach (player in other_players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_ZGRIEF_PLAYER_REVIVED_NO_SCORE");
	}
}

grief_intro_msg()
{
	level endon("end_game");

	flag_init("grief_intro_msg_complete");

	level waittill("restart_round_start");

	intro_str = istring(toupper("ZOMBIE_" + level.scr_zm_ui_gametype + "_INTRO"));

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(intro_str);
	}

	wait 5;

	to_win_str = &"ZOMBIE_GRIEF_SCORE_TO_WIN";

	if (level.scr_zm_ui_gametype == "zturned")
	{
		to_win_str = &"ZOMBIE_GRIEF_REDUCE_ENEMY_SCORE_TO_WIN";
	}

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(to_win_str, get_gamemode_winning_score());
	}

	wait 5;

	if (level.grief_score["A"] > level.grief_score["B"])
	{
		level.prev_leader = "A";
	}
	else if (level.grief_score["B"] > level.grief_score["A"])
	{
		level.prev_leader = "B";
	}

	flag_set("grief_intro_msg_complete");
}

get_gamemode_winning_score()
{
	if (level.scr_zm_ui_gametype == "zgrief")
	{
		return 10;
	}
	else if (level.scr_zm_ui_gametype == "zmeat")
	{
		return 200;
	}
	else if (level.scr_zm_ui_gametype == "zturned")
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

is_respawn_gamemode()
{
	return is_encounter() && level.scr_zm_ui_gametype != "zturned";
}

show_grief_hud_msg(msg, msg_parm1, msg_parm2, offset, delay)
{
	level endon("end_game");
	level endon("restart_round");
	self endon("disconnect");

	while (isDefined(level.hostmigrationtimer))
	{
		wait 0.05;
	}

	if (isDefined(delay))
	{
		wait delay;
	}

	if (!isDefined(offset))
	{
		self notify("show_grief_hud_msg");
	}
	else
	{
		self notify("show_grief_hud_msg2");
	}

	zgrief_hudmsg = newclienthudelem(self);
	zgrief_hudmsg.alignx = "center";
	zgrief_hudmsg.aligny = "middle";
	zgrief_hudmsg.horzalign = "center";
	zgrief_hudmsg.vertalign = "middle";
	zgrief_hudmsg.sort = 1;
	zgrief_hudmsg.y -= 130;

	if (self issplitscreen())
	{
		zgrief_hudmsg.y += 70;
	}

	if (isDefined(offset))
	{
		zgrief_hudmsg.y += offset;
	}

	zgrief_hudmsg.foreground = 1;
	zgrief_hudmsg.fontscale = 5;
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.color = (1, 1, 1);
	zgrief_hudmsg.hidewheninmenu = 1;
	zgrief_hudmsg.font = "default";

	zgrief_hudmsg endon("death");

	zgrief_hudmsg thread show_grief_hud_msg_cleanup(self, offset);

	if (isDefined(msg_parm2))
	{
		zgrief_hudmsg settext(msg, msg_parm1, msg_parm2);
	}
	else if (isDefined(msg_parm1))
	{
		zgrief_hudmsg settext(msg, msg_parm1);
	}
	else
	{
		zgrief_hudmsg settext(msg);
	}

	zgrief_hudmsg changefontscaleovertime(0.25);
	zgrief_hudmsg fadeovertime(0.25);
	zgrief_hudmsg.alpha = 1;
	zgrief_hudmsg.fontscale = 2;

	wait 3.25;

	zgrief_hudmsg changefontscaleovertime(1);
	zgrief_hudmsg fadeovertime(1);
	zgrief_hudmsg.alpha = 0;
	zgrief_hudmsg.fontscale = 5;

	wait 1;

	if (isDefined(zgrief_hudmsg))
	{
		zgrief_hudmsg destroy();
	}
}

show_grief_hud_msg_cleanup(player, offset)
{
	self endon("death");

	self thread show_grief_hud_msg_cleanup_end_game();
	self thread show_grief_hud_msg_cleanup_restart_round();

	if (!isDefined(offset))
	{
		player waittill("show_grief_hud_msg");
	}
	else
	{
		player waittill("show_grief_hud_msg2");
	}

	if (isDefined(self))
	{
		self destroy();
	}
}

show_grief_hud_msg_cleanup_restart_round()
{
	self endon("death");

	level waittill("restart_round");

	if (isDefined(self))
	{
		self destroy();
	}
}

show_grief_hud_msg_cleanup_end_game()
{
	self endon("death");

	level waittill("end_game");

	if (isDefined(self))
	{
		self destroy();
	}
}

custom_end_screen()
{
	players = get_players();
	i = 0;

	while (i < players.size)
	{
		players[i].game_over_hud = newclienthudelem(players[i]);
		players[i].game_over_hud.alignx = "center";
		players[i].game_over_hud.aligny = "middle";
		players[i].game_over_hud.horzalign = "center";
		players[i].game_over_hud.vertalign = "middle";
		players[i].game_over_hud.y -= 130;
		players[i].game_over_hud.foreground = 1;
		players[i].game_over_hud.fontscale = 3;
		players[i].game_over_hud.alpha = 0;
		players[i].game_over_hud.color = (1, 1, 1);
		players[i].game_over_hud.hidewheninmenu = 1;
		players[i].game_over_hud settext(&"ZOMBIE_GAME_OVER");
		players[i].game_over_hud fadeovertime(1);
		players[i].game_over_hud.alpha = 1;

		if (players[i] issplitscreen())
		{
			players[i].game_over_hud.fontscale = 2;
			players[i].game_over_hud.y += 40;
		}

		players[i].survived_hud = newclienthudelem(players[i]);
		players[i].survived_hud.alignx = "center";
		players[i].survived_hud.aligny = "middle";
		players[i].survived_hud.horzalign = "center";
		players[i].survived_hud.vertalign = "middle";
		players[i].survived_hud.y -= 100;
		players[i].survived_hud.foreground = 1;
		players[i].survived_hud.fontscale = 2;
		players[i].survived_hud.alpha = 0;
		players[i].survived_hud.color = (1, 1, 1);
		players[i].survived_hud.hidewheninmenu = 1;

		if (players[i] issplitscreen())
		{
			players[i].survived_hud.fontscale = 1.5;
			players[i].survived_hud.y += 40;
		}

		winner_text = &"ZOMBIE_GRIEF_WIN";
		loser_text = &"ZOMBIE_GRIEF_LOSE";

		if (isDefined(level.host_ended_game) && level.host_ended_game)
		{
			players[i].survived_hud settext(&"MP_HOST_ENDED_GAME");
		}
		else
		{
			if (isDefined(level.gamemodulewinningteam) && players[i]._encounters_team == level.gamemodulewinningteam)
			{
				players[i].survived_hud settext(winner_text);
			}
			else
			{
				players[i].survived_hud settext(loser_text);
			}
		}

		players[i].survived_hud fadeovertime(1);
		players[i].survived_hud.alpha = 1;
		i++;
	}
}

game_module_player_damage_callback(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	if (isdefined(self.player_damage_callback_score_only))
	{
		self do_game_mode_stun_score_steal(eattacker);

		self store_player_damage_info(eattacker, sweapon, smeansofdeath);

		return;
	}

	if (issubstr(sweapon, "one_inch_punch") && idamage <= 5)
	{
		self.one_inch_punch_damage = 1;
		return;
	}

	self.last_damage_from_zombie_or_player = 0;

	if (isDefined(eattacker))
	{
		if (isplayer(eattacker) && eattacker == self)
		{
			return;
		}

		if (isDefined(eattacker.is_zombie) && eattacker.is_zombie || isplayer(eattacker))
		{
			self.last_damage_from_zombie_or_player = 1;
		}
	}

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return;
	}

	if (isplayer(eattacker) && isDefined(eattacker._encounters_team) && eattacker._encounters_team != self._encounters_team)
	{
		if (is_true(self.is_zombie) || is_true(eattacker.is_zombie))
		{
			return;
		}

		if (is_true(self.hasriotshield) && isDefined(vdir))
		{
			if (is_true(self.hasriotshieldequipped))
			{
				if (self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, 0.2) && isDefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
			else if (!isdefined(self.riotshieldentity))
			{
				if (!self maps\mp\zombies\_zm::player_shield_facing_attacker(vdir, -0.2) && isdefined(self.player_shield_apply_damage))
				{
					return;
				}
			}
		}

		is_melee = false;

		if (isDefined(eattacker) && isplayer(eattacker) && eattacker != self && eattacker.team != self.team && (smeansofdeath == "MOD_MELEE" || issubstr(sweapon, "knife_ballistic")))
		{
			is_melee = true;
			dir = vdir;
			amount = self get_player_push_amount(idamage);

			if (self isOnGround())
			{
				// don't move vertically if on ground
				dir = (dir[0], dir[1], 0);
			}

			dir = vectorNormalize(dir);
			self setVelocity(amount * dir);
		}

		sweapon = get_nonalternate_weapon(sweapon);

		if (!is_true(self._being_shellshocked) || is_melee)
		{
			self store_player_damage_info(eattacker, sweapon, smeansofdeath);
		}

		if (is_true(self._being_shellshocked))
		{
			return;
		}

		self do_game_mode_stun_score_steal(eattacker);

		if (isDefined(level._effect["butterflies"]))
		{
			self do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime);
		}

		self thread do_game_mode_shellshock(is_melee, is_weapon_upgraded(sweapon));
		self playsound("zmb_player_hit_ding");
	}
}

get_player_push_amount(idamage)
{
	amount = 0;

	if (self maps\mp\zombies\_zm_laststand::is_reviving_any())
	{
		if (idamage >= 500)
		{
			if (!self isOnGround())
			{
				amount = 185; // 64 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 297.5; // 32 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 215; // 21.33 units
			}
			else if (self getStance() == "prone")
			{
				amount = 132.5; // 10.66 units
			}
		}
		else
		{
			if (!self isOnGround())
			{
				amount = 142.5; // 48 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 235; // 24 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 172.5; // 16 units
			}
			else if (self getStance() == "prone")
			{
				amount = 112.5; // 8 units
			}
		}
	}
	else
	{
		if (idamage >= 500)
		{
			if (!self isOnGround())
			{
				amount = 350; // 128 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 540; // 64 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 377.5; // 42.66 units
			}
			else if (self getStance() == "prone")
			{
				amount = 215; // 21.33 units
			}
		}
		else
		{
			if (!self isOnGround())
			{
				amount = 265; // 96 air units
			}
			else if (self getStance() == "stand")
			{
				amount = 420; // 48 units
			}
			else if (self getStance() == "crouch")
			{
				amount = 297.5; // 32 units
			}
			else if (self getStance() == "prone")
			{
				amount = 172.5; // 16 units
			}
		}
	}

	return amount;
}

do_game_mode_stun_score_steal(eattacker)
{
	score = 100 * maps\mp\zombies\_zm_score::get_points_multiplier(eattacker);
	self stun_score_steal(eattacker, score);

	eattacker.killsdenied++;

}

do_game_mode_stun_fx(einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, psoffsettime)
{
	pos = vpoint;
	angle = vectortoangles(vpoint - self getcentroid());
	is_perk_damage = isdefined(sweapon) && issubstr(sweapon, "zombie_perk_bottle");

	if (smeansofdeath == "MOD_GRENADE_SPLASH" || smeansofdeath == "MOD_PROJECTILE_SPLASH" || is_perk_damage)
	{
		pos = self getcentroid() + vectornormalize((vpoint - self getcentroid()) * (1, 1, 0)) * 8;
	}

	angle = (0, angle[1], 0);

	stun_fx_ent = self.stun_fx_ents[self.stun_fx_ind];
	stun_fx_ent unlink();
	stun_fx_ent.origin = pos;
	stun_fx_ent.angles = angle;
	stun_fx_ent linkto(self);

	playfxontag(level._effect["butterflies"], stun_fx_ent, "tag_origin");

	self.stun_fx_ind = (self.stun_fx_ind + 1) % self.stun_fx_ents.size;
}

do_game_mode_shellshock(is_melee = 0, is_upgraded = 0)
{
	self notify("do_game_mode_shellshock");
	self endon("do_game_mode_shellshock");
	self endon("disconnect");

	name = "grief_stun_zm";

	if (is_upgraded || is_melee)
	{
		name = "grief_stab_zm";
	}

	self._being_shellshocked = 1;
	self shellshock(name, 0.75);

	wait 0.75;

	self._being_shellshocked = 0;
}

stun_score_steal(attacker, score)
{
	if (is_player_valid(attacker))
	{
		attacker maps\mp\zombies\_zm_score::add_to_player_score(score);
	}

	if (self.score < score)
	{
		self maps\mp\zombies\_zm_score::minus_to_player_score(self.score);
	}
	else
	{
		self maps\mp\zombies\_zm_score::minus_to_player_score(score);
	}
}

store_player_damage_info(attacker, weapon, meansofdeath)
{
	self.last_damaged_by = spawnStruct();
	self.last_damaged_by.attacker = attacker;
	self.last_damaged_by.weapon = weapon;
	self.last_damaged_by.meansofdeath = meansofdeath;

	self thread remove_player_damage_info_after_time();
	self thread remove_player_damage_info_on_attacker_disconnect();
}

remove_player_damage_info_after_time()
{
	self notify("remove_player_damage_info_after_time");
	self endon("remove_player_damage_info_after_time");
	self endon("remove_player_damage_info");
	self endon("disconnect");

	waittillframeend; // wait for damage

	if (is_true(self.is_zombie))
	{
		// remove at end of frame
	}
	else if (is_true(self.last_damaged_by.attacker.is_zombie))
	{
		health = self.health;

		while (self.health <= health && is_player_valid(self))
		{
			wait 0.05;
		}
	}
	else
	{
		health = self.health;
		time = getTime();
		max_time = 3000;

		while (((getTime() - time) < max_time || self.health < health) && is_player_valid(self))
		{
			wait 0.05;
		}
	}

	self.last_damaged_by = undefined;

	self notify("remove_player_damage_info");
}

remove_player_damage_info_on_attacker_disconnect()
{
	self notify("remove_player_damage_info_on_attacker_disconnect");
	self endon("remove_player_damage_info_on_attacker_disconnect");
	self endon("remove_player_damage_info");
	self endon("disconnect");

	self.last_damaged_by.attacker waittill("disconnect");

	self.last_damaged_by = undefined;

	self notify("remove_player_damage_info");
}

grief_laststand_weapon_save(einflictor, attacker, idamage, smeansofdeath, sweapon, vdir, shitloc, psoffsettime, deathanimduration)
{
	self.grief_savedweapon_weapons = self getweaponslistprimaries();
	self.grief_savedweapon_weaponsammo_clip = [];
	self.grief_savedweapon_weaponsammo_clip_dualwield = [];
	self.grief_savedweapon_weaponsammo_stock = [];
	self.grief_savedweapon_weaponsammo_clip_alt = [];
	self.grief_savedweapon_weaponsammo_stock_alt = [];
	self.grief_savedweapon_currentweapon = maps\mp\zombies\_zm_weapons::get_nonalternate_weapon(self getcurrentweapon()); // can't switch to alt weapon
	self.grief_savedweapon_melee = self get_player_melee_weapon();
	self.grief_savedweapon_grenades = self get_player_lethal_grenade();
	self.grief_savedweapon_tactical = self get_player_tactical_grenade();
	self.grief_savedweapon_mine = self get_player_placeable_mine();
	self.grief_savedweapon_equipment = self get_player_equipment();
	self.grief_hastimebomb = self hasweapon("time_bomb_zm") || self hasweapon("time_bomb_detonator_zm");
	self.grief_hasriotshield = undefined;
	self.grief_savedperks = [];

	for (i = 0; i < self.grief_savedweapon_weapons.size; i++)
	{
		self.grief_savedweapon_weaponsammo_clip[i] = self getweaponammoclip(self.grief_savedweapon_weapons[i]);
		self.grief_savedweapon_weaponsammo_clip_dualwield[i] = self getweaponammoclip(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]));
		self.grief_savedweapon_weaponsammo_stock[i] = self getweaponammostock(self.grief_savedweapon_weapons[i]);
		self.grief_savedweapon_weaponsammo_clip_alt[i] = self getweaponammoclip(weaponAltWeaponName(self.grief_savedweapon_weapons[i]));
		self.grief_savedweapon_weaponsammo_stock_alt[i] = self getweaponammostock(weaponAltWeaponName(self.grief_savedweapon_weapons[i]));

		if (isDefined(self.grief_savedweapon_weaponsammo_clip[i]))
		{
			clip_missing = weaponClipSize(self.grief_savedweapon_weapons[i]) - self.grief_savedweapon_weaponsammo_clip[i];

			if (clip_missing > self.grief_savedweapon_weaponsammo_stock[i])
			{
				clip_missing = self.grief_savedweapon_weaponsammo_stock[i];
			}

			self.grief_savedweapon_weaponsammo_clip[i] += clip_missing;
			self.grief_savedweapon_weaponsammo_stock[i] -= clip_missing;
		}

		if (isDefined(self.grief_savedweapon_weaponsammo_clip_dualwield[i]) && weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]) != "none")
		{
			clip_dualwield_missing = weaponClipSize(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i])) - self.grief_savedweapon_weaponsammo_clip_dualwield[i];

			if (clip_dualwield_missing > self.grief_savedweapon_weaponsammo_stock[i])
			{
				clip_dualwield_missing = self.grief_savedweapon_weaponsammo_stock[i];
			}

			self.grief_savedweapon_weaponsammo_clip_dualwield[i] += clip_dualwield_missing;
			self.grief_savedweapon_weaponsammo_stock[i] -= clip_dualwield_missing;
		}

		if (isDefined(self.grief_savedweapon_weaponsammo_clip_alt[i]) && weaponAltWeaponName(self.grief_savedweapon_weapons[i]) != "none")
		{
			clip_alt_missing = weaponClipSize(weaponAltWeaponName(self.grief_savedweapon_weapons[i])) - self.grief_savedweapon_weaponsammo_clip_alt[i];

			if (clip_alt_missing > self.grief_savedweapon_weaponsammo_stock_alt[i])
			{
				clip_alt_missing = self.grief_savedweapon_weaponsammo_stock_alt[i];
			}

			self.grief_savedweapon_weaponsammo_clip_alt[i] += clip_alt_missing;
			self.grief_savedweapon_weaponsammo_stock_alt[i] -= clip_alt_missing;
		}
	}

	if (isDefined(self.grief_savedweapon_grenades))
	{
		self.grief_savedweapon_grenades_clip = self getweaponammoclip(self.grief_savedweapon_grenades);
	}

	if (isDefined(self.grief_savedweapon_tactical))
	{
		self.grief_savedweapon_tactical_clip = self getweaponammoclip(self.grief_savedweapon_tactical);
	}

	if (isDefined(self.grief_savedweapon_mine))
	{
		self.grief_savedweapon_mine_clip = self getweaponammoclip(self.grief_savedweapon_mine);
	}

	if (is_true(self.grief_hastimebomb))
	{
		self.grief_savedweapon_timebomb_clip = 1;

		if (self hasweapon("time_bomb_detonator_zm"))
		{
			self.grief_savedweapon_timebomb_clip = 0;
		}
	}

	if (isDefined(self.hasriotshield) && self.hasriotshield)
	{
		self.grief_hasriotshield = 1;
	}

	if (isdefined(self.perks_active))
	{
		self.grief_savedperks = arraycombine(self.grief_savedperks, self.perks_active, 0, 0);
	}

	if (isdefined(self.perks_disabled))
	{
		self.grief_savedperks = arraycombine(self.grief_savedperks, self.perks_disabled, 0, 0);
	}
}

grief_laststand_weapons_return()
{
	if (!isDefined(self.grief_savedweapon_weapons))
	{
		return 0;
	}

	if (is_true(self._retain_perks))
	{
		if (isDefined(self.grief_savedperks))
		{
			self.perks_active = [];

			foreach (perk in self.grief_savedperks)
			{
				self maps\mp\zombies\_zm_perks::give_perk(perk);
			}
		}
	}

	primary_weapons_given = 0;
	i = 0;

	while (i < self.grief_savedweapon_weapons.size)
	{
		if (primary_weapons_given >= get_player_weapon_limit(self))
		{
			break;
		}

		primary_weapons_given++;

		if (isDefined(self.stored_weapon_info) && isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]]) && isDefined(self.stored_weapon_info[self.grief_savedweapon_weapons[i]].used_amt))
		{
			used_amt = self.stored_weapon_info[self.grief_savedweapon_weapons[i]].used_amt;

			if (used_amt >= self.grief_savedweapon_weaponsammo_stock[i])
			{
				used_amt = used_amt - self.grief_savedweapon_weaponsammo_stock[i];
				self.grief_savedweapon_weaponsammo_stock[i] = 0;

				dual_wield_name = weapondualwieldweaponname(self.grief_savedweapon_weapons[i]);

				if ("none" != dual_wield_name)
				{
					if (used_amt >= self.grief_savedweapon_weaponsammo_clip_dualwield[i])
					{
						used_amt -= self.grief_savedweapon_weaponsammo_clip_dualwield[i];
						self.grief_savedweapon_weaponsammo_clip_dualwield[i] = 0;

						if (used_amt >= self.grief_savedweapon_weaponsammo_clip[i])
						{
							used_amt -= self.grief_savedweapon_weaponsammo_clip[i];
							self.grief_savedweapon_weaponsammo_clip[i] = 0;
						}
						else
						{
							self.grief_savedweapon_weaponsammo_clip[i] -= used_amt;
						}
					}
					else
					{
						self.grief_savedweapon_weaponsammo_clip_dualwield[i] -= used_amt;
					}
				}
				else
				{
					if (used_amt >= self.grief_savedweapon_weaponsammo_clip[i])
					{
						used_amt -= self.grief_savedweapon_weaponsammo_clip[i];
						self.grief_savedweapon_weaponsammo_clip[i] = 0;
					}
					else
					{
						self.grief_savedweapon_weaponsammo_clip[i] -= used_amt;
					}
				}
			}
			else
			{
				self.grief_savedweapon_weaponsammo_stock[i] -= used_amt;
			}
		}

		self giveweapon(self.grief_savedweapon_weapons[i], 0, self maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options(self.grief_savedweapon_weapons[i]));

		if (isdefined(self.grief_savedweapon_weaponsammo_clip[i]))
		{
			self setweaponammoclip(self.grief_savedweapon_weapons[i], self.grief_savedweapon_weaponsammo_clip[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_clip_dualwield[i]))
		{
			self setweaponammoclip(weaponDualWieldWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_clip_dualwield[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_stock[i]))
		{
			self setweaponammostock(self.grief_savedweapon_weapons[i], self.grief_savedweapon_weaponsammo_stock[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_clip_alt[i]))
		{
			self setweaponammoclip(weaponAltWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_clip_alt[i]);
		}

		if (isdefined(self.grief_savedweapon_weaponsammo_stock_alt[i]))
		{
			self setweaponammostock(weaponAltWeaponName(self.grief_savedweapon_weapons[i]), self.grief_savedweapon_weaponsammo_stock_alt[i]);
		}

		i++;
	}

	if (isDefined(self.grief_savedweapon_melee))
	{
		self giveweapon(self.grief_savedweapon_melee);
		self set_player_melee_weapon(self.grief_savedweapon_melee);
		self giveweapon("held_" + self.grief_savedweapon_melee);
		self setactionslot(2, "weapon", "held_" + self.grief_savedweapon_melee);
	}

	if (isDefined(self.grief_savedweapon_grenades))
	{
		self giveweapon(self.grief_savedweapon_grenades);
		self set_player_lethal_grenade(self.grief_savedweapon_grenades);

		if (isDefined(self.grief_savedweapon_grenades_clip))
		{
			if (is_respawn_gamemode())
			{
				self.grief_savedweapon_grenades_clip += 2;

				if (self.grief_savedweapon_grenades_clip > weaponClipSize(self.grief_savedweapon_grenades))
				{
					self.grief_savedweapon_grenades_clip = weaponClipSize(self.grief_savedweapon_grenades);
				}
			}

			self setweaponammoclip(self.grief_savedweapon_grenades, self.grief_savedweapon_grenades_clip);
		}
	}

	if (isDefined(self.grief_savedweapon_tactical))
	{
		self giveweapon(self.grief_savedweapon_tactical);
		self set_player_tactical_grenade(self.grief_savedweapon_tactical);

		if (isDefined(self.grief_savedweapon_tactical_clip))
		{
			self setweaponammoclip(self.grief_savedweapon_tactical, self.grief_savedweapon_tactical_clip);
		}
	}

	if (isDefined(self.grief_savedweapon_mine))
	{
		if (is_respawn_gamemode())
		{
			self.grief_savedweapon_mine_clip += 2;

			if (self.grief_savedweapon_mine_clip > weaponClipSize(self.grief_savedweapon_mine))
			{
				self.grief_savedweapon_mine_clip = weaponClipSize(self.grief_savedweapon_mine);
			}
		}

		self giveweapon(self.grief_savedweapon_mine);
		self set_player_placeable_mine(self.grief_savedweapon_mine);
		self setactionslot(4, "weapon", self.grief_savedweapon_mine);
		self setweaponammoclip(self.grief_savedweapon_mine, self.grief_savedweapon_mine_clip);
	}

	if (isDefined(self.current_equipment))
	{
		self maps\mp\zombies\_zm_equipment::equipment_take(self.current_equipment);
	}

	if (isDefined(self.grief_savedweapon_equipment))
	{
		self.do_not_display_equipment_pickup_hint = 1;
		self maps\mp\zombies\_zm_equipment::equipment_give(self.grief_savedweapon_equipment);
		self.do_not_display_equipment_pickup_hint = undefined;
	}

	if (is_true(self.grief_hastimebomb))
	{
		if (self.grief_savedweapon_timebomb_clip == 1)
		{
			self giveweapon("time_bomb_zm");
			self setactionslot(2, "weapon", "time_bomb_zm");
		}
		else
		{
			self giveweapon("time_bomb_detonator_zm");
			self setweaponammoclip("time_bomb_detonator_zm", 0);
			self setweaponammostock("time_bomb_detonator_zm", 0);
			self setactionslot(2, "weapon", "time_bomb_detonator_zm");
			self giveweapon("time_bomb_zm");
		}
	}

	if (isDefined(self.grief_hasriotshield) && self.grief_hasriotshield)
	{
		if (isDefined(self.player_shield_reset_health))
		{
			self [[self.player_shield_reset_health]]();
		}
	}

	self.grief_savedweapon_weapons = undefined;

	weapon = undefined;
	primaries = self getweaponslistprimaries();

	if (isDefined(self.pre_temp_weapon) && self hasWeapon(self.pre_temp_weapon))
	{
		weapon = self.pre_temp_weapon;

		if (!self.is_drinking)
		{
			self.pre_temp_weapon = undefined;
		}
	}
	else if (isDefined(self.grief_savedweapon_currentweapon) && self hasWeapon(self.grief_savedweapon_currentweapon))
	{
		weapon = self.grief_savedweapon_currentweapon;
		self.grief_savedweapon_currentweapon = undefined;
	}

	if (isDefined(weapon))
	{
		foreach (primary in primaries)
		{
			if (primary == weapon)
			{
				self switchtoweapon(primary);
				return 1;
			}
		}
	}

	if (primaries.size > 0)
	{
		self switchtoweapon(primaries[0]);
		return 1;
	}

	self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
	return 1;
}

red_flashing_overlay_loop()
{
	level endon("restart_round");
	self endon("disconnect");

	while (1)
	{
		self notify("hit_again");
		self player_flag_set("player_has_red_flashing_overlay");

		wait 1;
	}
}

unlimited_zombies()
{
	while (1)
	{
		level.zombie_total = 100;

		wait 1;
	}
}

unlimited_powerups()
{
	while (1)
	{
		level.powerup_drop_count = 0;

		wait 1;
	}
}

save_teams_on_intermission()
{
	if (!isDedicated())
	{
		return;
	}

	level waittill("intermission");

	axis_guids = "";
	allies_guids = "";

	players = array_randomize(get_players());
	i = 0;

	foreach (player in players)
	{
		if (i % 2 == 0)
		{
			axis_guids += player getguid() + " ";
		}
		else
		{
			allies_guids += player getguid() + " ";
		}

		i++;
	}

	setDvar("team_axis", axis_guids);
	setDvar("team_allies", allies_guids);
}

meat_init()
{
	level thread meat_think();
}

meat_think()
{
	level endon("end_game");

	flag_wait("initial_blackscreen_passed");

	grief_score_hud_set_scoring_team("none");

	level waittill("restart_round_start");

	wait 10;

	level thread meat_powerup_drop_think();
	level thread meat_powerup_timeout_think();

	prev_meat_player = undefined;
	held_time = undefined;
	obj_time = 1000;

	while (1)
	{
		if (isDefined(level.meat_player))
		{
			if (!isDefined(held_time))
			{
				held_time = getTime();
			}

			if (isDefined(prev_meat_player) && level.meat_player != prev_meat_player)
			{
				held_time = getTime();
			}

			prev_meat_player = level.meat_player;

			grief_score_hud_set_scoring_team(level.meat_player.team);

			objective_setgamemodeflags(level.meat_player.obj_ind, 3);
			objective_setgamemodeflags(level.game_mode_obj_ind, 0);

			if ((getTime() - held_time) >= obj_time)
			{
				held_time = getTime();

				score = 100 * maps\mp\zombies\_zm_score::get_points_multiplier(level.meat_player);
				level.meat_player maps\mp\zombies\_zm_score::add_to_player_score(score);

				level.meat_player.captures++;
				increment_score(level.meat_player.team);
			}
		}
		else
		{
			held_time = undefined;
			prev_meat_player = undefined;

			if (isDefined(level.item_meat))
			{
				grief_score_hud_set_scoring_team("neutral");

				objective_onentity(level.game_mode_obj_ind, level.item_meat);
				objective_setgamemodeflags(level.game_mode_obj_ind, 1);
			}
			else if (isDefined(level.meat_powerup))
			{
				grief_score_hud_set_scoring_team("neutral");

				objective_onentity(level.game_mode_obj_ind, level.meat_powerup);
				objective_setgamemodeflags(level.game_mode_obj_ind, 1);
			}
			else
			{
				grief_score_hud_set_scoring_team("none");

				objective_setgamemodeflags(level.game_mode_obj_ind, 0);
			}
		}

		wait 0.05;
		waittillframeend;
	}
}

meat_powerup_drop_think()
{
	level endon("end_game");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_KILL_ZOMBIE_TO_DROP_MEAT");
		}

		while (1)
		{
			level.zombie_powerup_ape = "meat_stink";
			level.zombie_vars["zombie_drop_item"] = 1;

			level waittill("powerup_dropped", powerup);

			if (powerup.powerup_name == "meat_stink")
			{
				level.meat_powerup = powerup;
				break;
			}
		}

		players = get_players();

		foreach (player in players)
		{
			player thread show_grief_hud_msg(&"ZOMBIE_MEAT_DROPPED");
		}

		level waittill("meat_inactive");
	}
}

meat_powerup_timeout_think()
{
	level endon("end_game");

	while (1)
	{
		level waittill("powerup_dropped", powerup);

		if (powerup.powerup_name != "meat_stink")
		{
			continue;
		}

		powerup thread meat_powerup_timeout();
		powerup thread meat_powerup_reset_on_timeout();
	}
}

meat_powerup_timeout()
{
	self notify("powerup_reset");

	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self show();

	wait 7.5;

	for (i = 0; i < 30; i++)
	{
		if (i % 2)
		{
			self ghost();
		}
		else
		{
			self show();
		}

		if (i < 8)
		{
			wait 0.5;
			continue;
		}

		if (i < 18)
		{
			wait 0.25;
			continue;
		}

		wait 0.1;
	}

	self notify("powerup_timedout");
	self maps\mp\zombies\_zm_powerups::powerup_delete();
}

meat_powerup_reset_on_timeout()
{
	self endon("powerup_grabbed");

	self waittill("powerup_timedout");

	if (is_true(self.claimed))
	{
		return;
	}

	level notify("meat_inactive");
}

turned_init()
{
	maps\mp\zombies\_zm_turned::init();

	level.decrement_score = 1;
	level.force_team_characters = 1;
	level.should_use_cia = 0;

	if (randomint(100) >= 50)
	{
		level.should_use_cia = 1;
	}

	maps\mp\zombies\_zm_powerups::include_zombie_powerup("the_disease");
	maps\mp\zombies\_zm_powerups::add_zombie_powerup("the_disease", "p6_zm_tm_blood_power_up", &"ZOMBIE_POWERUP_MAX_AMMO", ::func_should_never_drop, 0, 1, 0);

	level thread turned_think();
}

turned_think()
{
	level endon("end_game");

	flag_wait("initial_blackscreen_passed");

	level thread turned_zombie_move_speed_think();
	level thread turned_survivor_nearby_zombie_indicator_think();

	allies_players = get_players("allies");

	increment_score("allies", allies_players.size, 0);
	increment_score("axis", allies_players.size * 50, 0);

	level waittill("restart_round_start");

	level thread turned_decrease_zombie_score();

	wait 10;

	level thread the_disease_powerup_speed_think();

	zombie_players = get_players(level.zombie_team);

	if (zombie_players.size <= 0)
	{
		origin = the_disease_powerup_get_spawn_origin();

		level thread the_disease_powerup_drop(origin);
	}
	else
	{
		increment_score("allies", 0, 0, &"ZOMBIE_ZTURNED_SURVIVOR_TURNED");
	}
}

turned_zombie_move_speed_think()
{
	level endon("end_game");

	prev_fast_move_speed = 0;

	while (1)
	{
		zombie_players = get_players(level.zombie_team);
		fast_move_speed = zombie_players.size <= 1;

		if (fast_move_speed == prev_fast_move_speed)
		{
			wait 0.05;
			waittillframeend;
			continue;
		}

		if (fast_move_speed)
		{
			setDvar("player_zombieSpeedScale", 1.2);
			setDvar("player_zombieSprintSpeedScale", 1.2);
		}
		else
		{
			setDvar("player_zombieSpeedScale", 1.1);
			setDvar("player_zombieSprintSpeedScale", 1.1);
		}

		prev_fast_move_speed = fast_move_speed;

		wait 0.05;
		waittillframeend;
	}
}

turned_survivor_nearby_zombie_indicator_think()
{
	level endon("end_game");

	while (1)
	{
		players = get_players();
		valid_zombie_players = [];

		foreach (player in players)
		{
			if (player.team == level.zombie_team && player.sessionstate == "playing" && !player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				valid_zombie_players[valid_zombie_players.size] = player;
			}
		}

		foreach (player in players)
		{
			if (!isdefined(player.nearby_zombie_count))
			{
				player.nearby_zombie_count = 0;
			}

			nearby_zombie_count = 0;

			if (player.team != level.zombie_team && is_player_valid(player))
			{
				nearby_zombies = get_array_of_closest(player.origin, valid_zombie_players, undefined, undefined, 256);
				nearby_zombie_count = nearby_zombies.size;
			}

			if (player.nearby_zombie_count == nearby_zombie_count)
			{
				continue;
			}

			player.nearby_zombie_count = nearby_zombie_count;

			player luinotifyevent(&"objective_update_enemy_player_nearby", 1, nearby_zombie_count);
		}

		wait 0.05;
		waittillframeend;
		waittillframeend; // wait for zombie to change spawn points
	}
}

turned_decrease_zombie_score()
{
	level endon("end_game");

	while (1)
	{
		wait 1;
		waittillframeend;

		allies_players = get_players("allies");

		foreach (allies_player in allies_players)
		{
			if (is_player_valid(allies_player))
			{
				score = 10 * maps\mp\zombies\_zm_score::get_points_multiplier(allies_player);
				allies_player maps\mp\zombies\_zm_score::add_to_player_score(score);
			}
		}

		increment_score(level.zombie_team, -1, 0);
	}
}

the_disease_powerup(player)
{
	player notify("bled_out");
}

the_disease_powerup_speed_think()
{
	level endon("end_game");

	level.disease_powerup_speed = 10;

	while (level.disease_powerup_speed < 20)
	{
		wait 5;

		level.disease_powerup_speed++;
	}
}

the_disease_powerup_get_spawn_origin()
{
	allies_players = get_players("allies");
	allies_player = random(allies_players);
	allies_player turned_zombie_get_spawn_origin();
	origin = allies_player.turned_zombie_spawn_origin;

	allies_player.turned_zombie_spawn_origin = undefined;
	allies_player.turned_zombie_spawn_angles = undefined;

	return origin;
}

the_disease_powerup_drop(origin, drop_from_disconnecting_player = 0)
{
	if (drop_from_disconnecting_player)
	{
		waittillframeend; // wait for disconnecting player to disconnect
	}

	players = get_players();

	foreach (player in players)
	{
		player thread show_grief_hud_msg(&"ZOMBIE_RUN_AWAY_FROM_DISEASE_TO_SURVIVE");
	}

	level._powerup_timeout_override = ::the_disease_powerup_infinite_time;
	powerup = maps\mp\zombies\_zm_powerups::specific_powerup_drop("the_disease", origin);
	level._powerup_timeout_override = undefined;

	powerup thread the_disease_powerup_do_chase();
}

the_disease_powerup_do_chase()
{
	level endon("end_game");
	self endon("powerup_timedout");
	self endon("powerup_grabbed");

	while (1)
	{
		wait 0.05;

		allies_players = get_players("allies");
		allies_player = getclosest(self.origin, allies_players);

		if (!isdefined(allies_player))
		{
			continue;
		}

		allies_player_origin = allies_player.origin + (0, 0, 40);

		direction = vectornormalize(allies_player_origin - self.origin);

		self.origin += direction * level.disease_powerup_speed;
	}
}

the_disease_powerup_infinite_time()
{

}

turned_zombie_init()
{
	team = self.team;
	amount = 0;

	if (is_player_valid(self))
	{
		amount = -1;
	}

	if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && !is_true(self.playersuicided))
	{
		self notify("stop_revive_trigger");
		self.revivetrigger delete();

		self thread maps\mp\zombies\_zm_laststand::auto_revive(self);
	}

	self scripts\zm\_zm_reimagined::delete_placeable_mines();

	self notify("zmb_lost_knife");

	self notify("player_lost_time_bomb");

	self scripts\zm\_zm_reimagined::set_team(level.zombie_team);

	self maps\mp\zombies\_zm_turned::turn_to_zombie();

	level notify("attractor_positions_generated");

	increment_score(team, amount, 0, &"ZOMBIE_ZTURNED_SURVIVOR_TURNED");
}

turned_zombie_spawn()
{
	self maps\mp\zombies\_zm_turned::turn_to_zombie();

	if (!isdefined(self.turned_zombie_spawn_origin))
	{
		self turned_zombie_get_spawn_origin();

		increment_score("allies", 0, 0, &"ZOMBIE_ZTURNED_ZOMBIE_APPEARED");
	}

	self setorigin(self.turned_zombie_spawn_origin);
	self setplayerangles(self.turned_zombie_spawn_angles);

	self.turned_zombie_spawn_origin = undefined;
	self.turned_zombie_spawn_angles = undefined;

	playfx(level._effect["zombie_disappears"], self.origin);
	playsoundatposition("evt_appear_3d", self.origin);
	earthquake(0.5, 0.75, self.origin, 100);
	playrumbleonposition("explosion_generic", self.origin);
}

turned_zombie_spectate()
{
	self freezecontrols(1);
	self forcegrenadethrow();
	self disableweapons();
	self stopsounds();
	self ghost();

	playfx(level._effect["zombie_disappears"], self.origin);
	playsoundatposition("evt_disappear_3d", self.origin);
}

turned_zombie_wait_and_respawn()
{
	level endon("end_game");
	self endon("disconnect");

	if (isdefined(self.turned_zombie_wait_and_respawn))
	{
		return;
	}

	self.turned_zombie_wait_and_respawn = 1;

	time = 10;

	self scripts\zm\_zm_reimagined::setlowermessage(&"GAME_RESPAWNING", time);

	self luinotifyevent(&"show_dead_spectate_hud");

	wait time;

	flag_wait("spawn_zombies");

	self turned_zombie_get_spawn_origin();

	self scripts\zm\_zm_reimagined::clearlowermessage();

	self luinotifyevent(&"hide_dead_spectate_hud");

	self.sessionstate = "playing";

	self maps\mp\zombies\_zm::spectator_respawn();

	self.turned_zombie_wait_and_respawn = undefined;
}

turned_zombie_get_spawn_origin()
{
	valid_allies_players = [];
	allies_players = array_randomize(get_players("allies"));

	foreach (player in allies_players)
	{
		if (is_player_valid(player))
		{
			valid_allies_players[valid_allies_players.size] = player;
		}
	}

	if (!isdefined(self.turned_zombie_spawn_origin))
	{
		self turned_zombie_get_spawn_origin_from_nodes(valid_allies_players, 512, 1024, 256);
	}

	if (!isdefined(self.turned_zombie_spawn_origin))
	{
		self turned_zombie_get_spawn_origin_from_nodes(valid_allies_players, 256, 512, 256);
	}

	if (!isdefined(self.turned_zombie_spawn_origin))
	{
		self turned_zombie_get_spawn_origin_from_nodes(valid_allies_players, 0, 256, 256);
	}

	if (!isdefined(self.turned_zombie_spawn_origin))
	{
		player = random(valid_allies_players);

		self.turned_zombie_spawn_origin = player.origin;
		self.turned_zombie_spawn_angles = (0, player.angles[1], 0);
	}
}

turned_zombie_get_spawn_origin_from_nodes(valid_allies_players, min_radius, max_radius, max_height)
{
	spawn_origin = undefined;
	spawn_angles = undefined;

	foreach (player in valid_allies_players)
	{
		origin = groundpos_ignore_water_new(player.origin);
		nodes = array_randomize(getnodesinradius(origin, max_radius, min_radius, max_height, "pathnodes"));

		foreach (node in nodes)
		{
			if (isdefined(node.target))
			{
				continue;
			}

			is_node_valid = 1;

			if (is_node_valid)
			{
				is_node_valid = scripts\zm\replaced\_zm_utility::check_point_in_life_brush(node.origin) || (check_point_in_enabled_zone(node.origin, 1) && !scripts\zm\replaced\_zm_utility::check_point_in_kill_brush(node.origin));
			}

			if (is_node_valid)
			{
				is_node_valid = findpath(origin, node.origin) && findpath(node.origin, origin);
			}

			if (is_node_valid)
			{
				nearby_valid_allies_players = get_array_of_closest(node.origin, valid_allies_players, undefined, 1, min_radius);
				is_node_valid = nearby_valid_allies_players.size == 0;
			}

			if (is_node_valid)
			{
				if (isdefined(level._chugabud_reject_node_override_func))
				{
					reject_node = [[level._chugabud_reject_node_override_func]](origin, node);
					is_node_valid = !reject_node;
				}
			}

			if (is_node_valid)
			{
				spawn_origin = node.origin;

				look_at_origin = player.origin;
				linked_nodes = [];
				nearby_nodes = array_randomize(getnodesinradius(node.origin, 256, 0, max_height, "pathnodes"));

				foreach (nearby_node in nearby_nodes)
				{
					if (isdefined(nearby_node.target))
					{
						continue;
					}

					if (!nodesarelinked(node, nearby_node) && !nodesarelinked(nearby_node, node))
					{
						continue;
					}

					linked_nodes[linked_nodes.size] = nearby_node;
				}

				if (linked_nodes.size > 0)
				{
					closest_linked_node = getclosest(origin, linked_nodes);
					look_at_origin = closest_linked_node.origin;
				}

				spawn_angles = vectortoangles(look_at_origin - node.origin);
				spawn_angles = (0, spawn_angles[1], 0);

				break;
			}
		}

		if (isdefined(spawn_origin))
		{
			break;
		}
	}

	self.turned_zombie_spawn_origin = spawn_origin;
	self.turned_zombie_spawn_angles = spawn_angles;
}

can_revive(revivee)
{
	if (self hasweapon(get_gamemode_var("item_meat_name")))
	{
		return false;
	}

	return true;
}

powerup_can_player_grab(player)
{
	if (is_true(player.is_zombie))
	{
		return false;
	}

	if (self.powerup_name == "meat_stink")
	{
		if (player hasWeapon(get_gamemode_var("item_meat_name")) || is_true(player.dont_touch_the_meat))
		{
			return false;
		}
	}

	return true;
}

powerup_grab(powerup, player)
{
	switch (powerup.powerup_name)
	{
		case "meat_stink":
			level thread maps\mp\gametypes_zm\zgrief::meat_stink(player);
			break;

		case "the_disease":
			level thread the_disease_powerup(player);
			break;
	}
}

setspectatepermissions()
{
	self allowspectateteam("allies", 0);
	self allowspectateteam("axis", 0);
	self allowspectateteam("freelook", 0);
	self allowspectateteam("none", 0);
}

increment_score(team, amount = 1, show_lead_msg = true, score_msg, other_score_msg)
{
	level endon("end_game");

	other_team = getotherteam(team);
	players = get_players();
	team_players = get_players(team);
	other_team_players = get_players(other_team);
	encounters_team = "A";
	other_encounters_team = "B";

	if (team == "allies")
	{
		encounters_team = "B";
		other_encounters_team = "A";
	}

	level.grief_score[encounters_team] += amount;

	if (is_true(level.decrement_score))
	{
		if (level.grief_score[encounters_team] < get_gamemode_winning_score())
		{
			level.grief_score[encounters_team] = get_gamemode_winning_score();
		}

		setteamscore(team, level.grief_score[encounters_team]);

		if (team == "allies" && level.highest_score != level.grief_score[encounters_team])
		{
			level.highest_score = level.grief_score[encounters_team];

			if (level.highest_score > 255)
			{
				level.highest_score = 255;
			}

			setroundsplayed(level.highest_score);
		}

		if (level.grief_score[encounters_team] <= get_gamemode_winning_score())
		{
			scripts\zm\replaced\_zm_game_module::game_won(other_encounters_team);
		}
	}
	else
	{
		if (level.grief_score[encounters_team] > get_gamemode_winning_score())
		{
			level.grief_score[encounters_team] = get_gamemode_winning_score();
		}

		setteamscore(team, level.grief_score[encounters_team]);

		if ((level.highest_score < level.grief_score[encounters_team] && level.highest_score < 255) || level.highest_score == 0)
		{
			level.highest_score = level.grief_score[encounters_team];

			if (level.highest_score > 255)
			{
				level.highest_score = 255;
			}

			setroundsplayed(level.highest_score);
		}

		if (level.grief_score[encounters_team] >= get_gamemode_winning_score())
		{
			scripts\zm\replaced\_zm_game_module::game_won(encounters_team);
		}
	}

	if (!flag("grief_intro_msg_complete"))
	{
		return;
	}

	if (level.scr_zm_ui_gametype == "zgrief")
	{
		score = level.grief_score[encounters_team];
		other_score = level.grief_score[other_encounters_team];
		score_remaining = get_gamemode_winning_score() - score;

		if (isdefined(score_msg))
		{
			foreach (player in team_players)
			{
				player thread show_grief_hud_msg(score_msg);
			}
		}

		if (isdefined(other_score_msg))
		{
			foreach (player in other_team_players)
			{
				player thread show_grief_hud_msg(other_score_msg);
			}
		}

		if (level.grief_score[encounters_team] <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(level.grief_score[encounters_team] + "_player_down", team);
		}
		else if (score_remaining <= 3)
		{
			level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(score_remaining + "_player_left", team);
		}
	}

	if (level.scr_zm_ui_gametype == "zturned")
	{
		if (isdefined(score_msg))
		{
			level thread turned_score_msg(team, score_msg);
		}
	}

	if (show_lead_msg)
	{
		if (!isdefined(level.prev_leader) || (level.prev_leader != encounters_team && level.grief_score[encounters_team] > level.grief_score[level.prev_leader]))
		{
			level.prev_leader = encounters_team;

			delay = undefined;

			if (level.scr_zm_ui_gametype == "zgrief")
			{
				delay = 1;
			}

			foreach (player in team_players)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_GAIN_LEAD", undefined, undefined, 30, delay);
			}

			foreach (player in other_team_players)
			{
				player thread show_grief_hud_msg(&"ZOMBIE_GRIEF_LOSE_LEAD", undefined, undefined, 30, delay);
			}
		}
	}
}

turned_score_msg(team, score_msg)
{
	level endon("end_game");

	waittillframeend; // wait for player to change teams

	other_team = getotherteam(team);
	players = get_players();
	team_players = get_players(team);
	other_team_players = get_players(other_team);
	encounters_team = "A";

	if (team == "allies")
	{
		encounters_team = "B";
	}

	score = level.grief_score[encounters_team];
	other_score = other_team_players.size;

	foreach (player in team_players)
	{
		player thread show_grief_hud_msg(score_msg, score, other_score);
	}

	foreach (player in other_team_players)
	{
		player thread show_grief_hud_msg(score_msg, other_score, score);
	}

	if (score_msg == &"ZOMBIE_ZTURNED_SURVIVOR_DOWN" || score_msg == &"ZOMBIE_ZTURNED_SURVIVOR_REVIVED" || score_msg == &"ZOMBIE_ZTURNED_SURVIVOR_DISAPPEARED")
	{
		if (score == 1)
		{
			foreach (player in players)
			{
				if (player.team == team && is_player_valid(player))
				{
					player thread maps\mp\zombies\_zm_audio_announcer::leaderdialogonplayer("last_player");
				}
			}
		}

		level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(score + "_player_left", other_team);
	}
	else
	{
		level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(other_score + "_player_down", team);
	}
}

is_weapon_available_in_grief_saved_weapons(weapon, ignore_player)
{
	count = 0;
	upgradedweapon = weapon;

	if (isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
	{
		upgradedweapon = level.zombie_weapons[weapon].upgrade_name;
	}

	players = getplayers();

	if (isdefined(players))
	{
		for (player_index = 0; player_index < players.size; player_index++)
		{
			player = players[player_index];

			if (isdefined(ignore_player) && player == ignore_player)
			{
				continue;
			}

			if (isdefined(player.grief_savedweapon_weapons))
			{
				for (i = 0; i < player.grief_savedweapon_weapons.size; i++)
				{
					grief_weapon = player.grief_savedweapon_weapons[i];

					if (isdefined(grief_weapon) && (grief_weapon == weapon || grief_weapon == upgradedweapon))
					{
						count++;
					}
				}
			}
		}
	}

	return count;
}

remove_held_melee_weapons()
{
	level endon("intermission");

	while (1)
	{
		players = get_players();

		foreach (player in players)
		{
			melee_weapon = player get_player_melee_weapon();

			if (!isdefined(melee_weapon))
			{
				continue;
			}

			held_melee_weapon = "held_" + melee_weapon;

			if (player hasweapon(held_melee_weapon))
			{
				player takeweapon(held_melee_weapon);
			}
		}

		wait 0.05;
		waittillframeend;
	}
}