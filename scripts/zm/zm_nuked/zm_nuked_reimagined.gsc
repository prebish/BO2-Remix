#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_buildables;

main()
{
	replaceFunc(maps\mp\zombies\_zm_riotshield::doriotshielddeploy, scripts\zm\replaced\_zm_riotshield::doriotshielddeploy);
	replaceFunc(maps\mp\zombies\_zm_riotshield::trackriotshield, scripts\zm\replaced\_zm_riotshield::trackriotshield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::player_damage_shield, scripts\zm\replaced\_zm_weap_riotshield::player_damage_shield);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::riotshield_fling_zombie, scripts\zm\replaced\_zm_weap_riotshield::riotshield_fling_zombie);
	replaceFunc(maps\mp\zombies\_zm_weap_riotshield::riotshield_knockdown_zombie, scripts\zm\replaced\_zm_weap_riotshield::riotshield_knockdown_zombie);
	replaceFunc(maps\mp\zm_nuked::survival_init, scripts\zm\replaced\zm_nuked::survival_init);
	replaceFunc(maps\mp\zm_nuked::precache_team_characters, scripts\zm\replaced\zm_nuked::precache_team_characters);
	replaceFunc(maps\mp\zm_nuked::give_team_characters, scripts\zm\replaced\zm_nuked::give_team_characters);
	replaceFunc(maps\mp\zm_nuked::moon_rocket_follow_path, scripts\zm\replaced\zm_nuked::moon_rocket_follow_path);
	replaceFunc(maps\mp\zm_nuked::sndgameend, scripts\zm\replaced\zm_nuked::sndgameend);
	replaceFunc(maps\mp\zm_nuked_gamemodes::init, scripts\zm\replaced\zm_nuked_gamemodes::init);
	replaceFunc(maps\mp\zm_nuked_standard::main, scripts\zm\replaced\zm_nuked_standard::main);
	replaceFunc(maps\mp\zm_nuked_perks::init_nuked_perks, scripts\zm\replaced\zm_nuked_perks::init_nuked_perks);
	replaceFunc(maps\mp\zm_nuked_perks::perks_from_the_sky, scripts\zm\replaced\zm_nuked_perks::perks_from_the_sky);
	replaceFunc(maps\mp\zm_nuked_perks::bring_perk_landing_damage, scripts\zm\replaced\zm_nuked_perks::bring_perk_landing_damage);

	replaceFunc(maps\mp\zombies\_zm_buildables::sndbuildableusealias, ::snd_buildable_use_alias);
	replaceFunc(maps\mp\zombies\_zm_buildables::sndbuildablecompletealias, ::snd_buildable_complete_alias);

	// _zm_buildables::init calls this, and its client counterpart calls the .csc half at the
	// matching point in _zm.csc - both sit between the core registerclientfield calls, so the
	// "buildable" field gets registered in the same window on both sides.
	level.init_buildables = ::register_buildables;

	level._effect["dog_phase_trail"] = loadfx("maps/zombie/fx_zombie_tesla_bolt_secondary");
	level._effect["dog_phasing"] = loadfx("maps/zombie/fx_zmb_avog_phasing");

	maps\_explosive_dart::init();
}

init()
{
	level.mixed_rounds_enabled = 1;

	level.zombie_init_done = ::zombie_init_done;
	level.special_weapon_magicbox_check = ::nuked_special_weapon_magicbox_check;

	if (is_encounter())
	{
		maps\mp\zombies\_zm_ai_dogs::init();
		level thread encounter_zombie_eye_glow_change();
		level thread encounter_switch_announcer_to_richtofen();
	}

	level thread increase_dog_health();
}

zombie_init_done()
{
	self.meleedamage = 50;
	self.allowpain = 0;

	if (isDefined(self.script_parameters) && self.script_parameters == "crater")
	{
		self thread maps\mp\zm_nuked::zombie_crater_locomotion();
	}

	self setphysparams(15, 0, 48);
}

nuked_special_weapon_magicbox_check(weapon)
{
	return 1;
}

encounter_zombie_eye_glow_change()
{
	flag_wait("start_zombie_round_logic");

	level.zombie_spawners = getentarray("zombie_spawner_beyes", "script_noteworthy");

	if (isdefined(level._game_module_custom_spawn_init_func))
	{
		[[level._game_module_custom_spawn_init_func]]();
	}

	level setclientfield("zombie_eye_change", 1);
}

encounter_switch_announcer_to_richtofen()
{
	flag_wait("start_zombie_round_logic");

	sndswitchannouncervox("richtofen");
}

increase_dog_health()
{
	flag_wait("start_zombie_round_logic");

	level.dog_health = 1600;
}

// level.init_buildables, called from _zm_buildables::init. Registration only - the piece
// spawns have to exist first because generate_zombie_buildable_piece resolves them
// immediately, and add_zombie_buildable is what registers the clientfield.
register_buildables()
{
	add_buildable_piece_spawns();

	include_buildables();
	init_buildables();
}

// Called from scripts\zm\replaced\zm_nuked_standard::main. Everything here needs the map
// entities to exist, so it runs later than register_buildables and touches no clientfields.
buildables_init()
{
	maps\mp\zombies\_zm_weap_riotshield::init();

	// The shield's own sounds are in Tranzit's sound bank, which Nuketown doesn't load, so they
	// play as silence here. Stand in with a blunt impact from the mod's own bank - it isn't the
	// real shield sound, but a shield with no audible feedback is worse.
	level.riotshield_impact_alias = "zmb_melee_hit_other";
	level.riotshield_destroy_alias = "zmb_melee_hit_other";
	level.riotshield_forcehit_alias = "zmb_melee_hit_other";

	spawn_buildable_bench();

	level thread maps\mp\zombies\_zm_buildables::think_buildables();
	level thread watch_players_for_piece_icon();
}

// Called from scripts\zm\replaced\zm_nuked_standard::main. The starting score is stamped onto
// the player at spawn out of their persistent stats, so a level variable set during map init
// gets overwritten - the points have to be handed out after the player is in the world.
starting_points_init(points)
{
	level.nuked_starting_points = points;

	players = get_players();

	foreach (player in players)
	{
		player thread give_starting_points();
	}

	for (;;)
	{
		level waittill("connected", player);
		player thread give_starting_points();
	}
}

give_starting_points()
{
	self endon("disconnect");

	self waittill("spawned_player");

	// Opening round only, once each. Anyone who bleeds out later, or drops into a game already
	// running, keeps the round-scaled points the stock code gives them instead.
	if (level.round_number > 1 || isDefined(self.nuked_starting_points_given))
	{
		return;
	}

	self.nuked_starting_points_given = 1;

	if (self.score < level.nuked_starting_points)
	{
		self maps\mp\zombies\_zm_score::add_to_player_score(level.nuked_starting_points - self.score);
	}
}

watch_players_for_piece_icon()
{
	players = get_players();

	foreach (player in players)
	{
		player thread piece_icon_watcher();
	}

	while (1)
	{
		level waittill("connected", player);

		player thread piece_icon_watcher();
	}
}

// Every buildable sound alias ships in the sound banks of the maps that have benches, so on
// Nuketown the stock names resolve to nothing and the whole bench is silent. These stand in
// with aliases from the mod's own bank, which is loaded on every map. Both are only swapped in
// from zm_nuked_reimagined::main, so the maps with the real audio keep it.
snd_buildable_use_alias(name)
{
	return "zmb_perks_packa_ticktock";
}

snd_buildable_complete_alias(name)
{
	return "zmb_perks_packa_ready";
}

// Stands in for the stock carried-part icon, which can't work on Nuketown - see the note in
// include_buildables. Polling the carried piece rather than hooking pickup/drop means build,
// swap, going down and bleeding out are all covered without a hook for each.
piece_icon_watcher()
{
	self endon("disconnect");

	self waittill("spawned_player");

	// Measured in from the bottom right so it holds its place beside the weapon readout at any
	// resolution, rather than drifting with the screen width the way a centred element does.
	// x walks it left of the ammo counter and y lines it up with the weapon name above it.
	hud_icon = newclienthudelem(self);
	hud_icon.horzalign = "right";
	hud_icon.vertalign = "bottom";
	hud_icon.alignx = "right";
	hud_icon.aligny = "bottom";
	hud_icon.x = -175;
	hud_icon.y = -45;
	hud_icon.foreground = 1;
	hud_icon.hidewheninmenu = 1;
	hud_icon.alpha = 0;

	shown = "";

	while (isDefined(self))
	{
		piece = self maps\mp\zombies\_zm_buildables::player_get_buildable_piece();

		carried = "";

		if (isDefined(piece) && isDefined(piece.hud_icon))
		{
			carried = piece.hud_icon;
		}

		if (carried != shown)
		{
			shown = carried;

			if (carried == "")
			{
				hud_icon.alpha = 0;
			}
			else
			{
				hud_icon setShader(carried, 32, 32);
				hud_icon.alpha = 1;
			}
		}

		wait 0.1;
	}
}

// Nuketown ships no buildable entities at all, so the three things _zm_buildables expects to
// find in the map get spawned here: the table, the assembly model the parts get shown on, and
// the trigger it reads placement and naming off of.
spawn_buildable_bench()
{
	s_spot = getStruct("culdesac_chest", "script_noteworthy");

	// The chest struct sits some way off the floor, so trace down for the real ground height
	// rather than trusting its z.
	angles = s_spot.angles;

	// p6_zm_work_bench stands 44 tall, which reads as chest height next to the player, so sink
	// it into the floor to bring the worktop down. The assembly is offset from the bench
	// rather than the floor so it keeps sitting on the top when this is tuned.
	origin = ground_position(s_spot.origin) - (0, 0, 10);

	scripts\zm\locs\loc_common::barrier("p6_zm_work_bench", origin, angles, 1);

	// The bench's base is at its origin and t6_wpn_zmb_shield_world hangs 26 below its own,
	// so 70 up rests the assembly on the bench top.
	shield = spawn("script_model", origin + (0, 0, 70));
	shield.angles = angles + (0, 180, 0);
	shield setModel("t6_wpn_zmb_shield_world");
	shield.targetname = "buildable_riotshield";

	// Only read for its keys and then deleted - the trigger players use is the unitrigger box
	// that setup_unitrigger_buildable_internal builds out of script_length/width/height. That
	// box sits on this point and the stub sets require_look_at, so the player has to aim at it
	// to get the prompt. It has to stay at working height however far the bench itself is sunk,
	// which is why it is offset from the worktop and not from the bench's base: 44 up clears
	// the bench, and the 13 on top of that is where Transit puts the same trigger.
	trigger = spawn("script_origin", origin + (0, 0, 44 + 13));
	trigger.angles = angles;
	trigger.script_angles = angles;
	trigger.targetname = "riotshield_zm_buildable_trigger";
	trigger.target = "buildable_riotshield";
	trigger.zombie_weapon_upgrade = "riotshield_zm";

	// Transit's shield bench sets none of these and runs on the stock defaults, so use the same
	// numbers rather than hand-picked ones.
	trigger.script_length = 32;
	trigger.script_width = 100;
	trigger.script_height = 64;
}

// Drops a point onto the floor beneath it, so placements don't depend on hand-measured
// heights that are easy to get wrong by a few units.
ground_position(origin)
{
	return groundtrace(origin + (0, 0, 60), origin - (0, 0, 200), 0, undefined)["position"];
}

// generate_zombie_buildable_piece looks its spawn points up with
// getstructarray(buildable + "_" + model, "targetname"), so these have to exist before
// include_buildables runs. Each part picks one of its three spots per game.
add_buildable_piece_spawns()
{
	// The dolly's origin is at its base, the door's is at its centre 21 up, so they need
	// different lifts off the floor to sit on it rather than sink into it.
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (-1588, 545, -51), (0, 310, 0), 0);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (-870, 90, -59), (0, 20, 0), 0);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (1600, 940, -64), (0, 290, 0), 0);

	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (620, 300, -55), (0, 350, 0), 21);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (1380, 560, -62), (0, 195, 0), 21);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (-960, 570, -57), (0, 90, 0), 21);
}

add_buildable_piece_spawn(model, origin, angles, z_base)
{
	s_spawn = spawnStruct();
	s_spawn.targetname = "riotshield_zm_" + model;
	s_spawn.model = model;
	s_spawn.origin = ground_position(origin) + (0, 0, z_base);
	s_spawn.angles = angles;

	scripts\zm\replaced\utility::add_struct(s_spawn);
}

include_buildables()
{
	// No clientfield state on either piece on purpose. That value drives the stock carried-part
	// icon, which is looked up from a per-map table baked into the game's menu files - Nuketown
	// isn't in it, so the stock HUD draws an empty box. Leaving it undefined suppresses that,
	// and piece_icon_watcher draws the icon instead.
	riotshield_dolly = generate_zombie_buildable_piece("riotshield_zm", "t6_wpn_zmb_shield_dolly", 32, 64, 0, "zm_hud_icon_dolly", ::onpickup_common, ::ondrop_common, undefined, "TAG_RIOT_SHIELD_DOLLY");
	riotshield_door = generate_zombie_buildable_piece("riotshield_zm", "t6_wpn_zmb_shield_door", 48, 15, 25, "zm_hud_icon_cardoor", ::onpickup_common, ::ondrop_common, undefined, "TAG_RIOT_SHIELD_DOOR");

	riotshield = spawnStruct();
	riotshield.name = "riotshield_zm";
	riotshield add_buildable_piece(riotshield_dolly);
	riotshield add_buildable_piece(riotshield_door);
	riotshield.onbuyweapon = ::onbuyweapon_riotshield;
	riotshield.triggerthink = ::riotshieldbuildable;
	include_zombie_buildable(riotshield);
}

init_buildables()
{
	// Highest clientfield value used by a piece, not the number of pieces - it sizes the
	// clientfield, and the .csc half must say the same.
	level.buildable_piece_count = 3;

	add_zombie_buildable("riotshield_zm", &"ZOMBIE_BUILD_RIOT", &"ZOMBIE_BUILDING_RIOT", &"ZOMBIE_BOUGHT_RIOT");
}

riotshieldbuildable()
{
	buildable_trigger_think("riotshield_zm_buildable_trigger", "riotshield_zm", "riotshield_zm", &"ZOMBIE_GRAB_RIOTSHIELD", 1, 1);
}

onpickup_common(player)
{
	// The powerup grab sound, for the same reason the two alias functions above exist - there
	// is no buildable pickup sound in Nuketown's bank to play.
	player playSound("zmb_tombstone_grab");

	self.piece_owner = player;
}

ondrop_common(player)
{
	self.piece_owner = undefined;
}

onbuyweapon_riotshield(player)
{
	if (isDefined(player.player_shield_reset_health))
	{
		player [[player.player_shield_reset_health]]();
	}

	if (isDefined(player.player_shield_reset_location))
	{
		player [[player.player_shield_reset_location]]();
	}
}