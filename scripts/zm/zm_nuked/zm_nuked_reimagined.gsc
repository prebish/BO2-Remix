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
	replaceFunc(maps\mp\zm_nuked::zombie_eye_glow_change, ::zombie_eye_glow_change_early);
	replaceFunc(maps\mp\zm_nuked_gamemodes::init, scripts\zm\replaced\zm_nuked_gamemodes::init);
	replaceFunc(maps\mp\zm_nuked_standard::main, scripts\zm\replaced\zm_nuked_standard::main);
	replaceFunc(maps\mp\zm_nuked_perks::init_nuked_perks, scripts\zm\replaced\zm_nuked_perks::init_nuked_perks);
	replaceFunc(maps\mp\zm_nuked_perks::perks_from_the_sky, scripts\zm\replaced\zm_nuked_perks::perks_from_the_sky);
	replaceFunc(maps\mp\zm_nuked_perks::bring_perk_landing_damage, scripts\zm\replaced\zm_nuked_perks::bring_perk_landing_damage);

	replaceFunc(maps\mp\zombies\_zm_buildables::sndbuildableusealias, ::snd_buildable_use_alias);
	replaceFunc(maps\mp\zombies\_zm_buildables::sndbuildablecompletealias, ::snd_buildable_complete_alias);
	replaceFunc(maps\mp\zombies\_zm_buildables::player_build, ::nuked_player_build);

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
	else
	{
		level thread switch_announcer_to_richtofen_early();
	}

	level thread increase_dog_health();
}

// Nuketown opens on Samantha and stock only hands over to Richtofen once the last moon transmission
// has landed, which `wait_for_round_range(25)` puts at round 25 at the earliest. Bring the handover
// forward to round 20.
//
// Done as its own thread rather than by replacing zm_nuked::switch_announcer_to_richtofen, because
// stock threads that from zm_nuked::main and the fork does not replace main - an unregistered
// replacement is never reached. Stock's copy still runs and switches to Richtofen a second time
// when the transmission finishes, which is a no-op by then.
//
// The moon transmission VO still runs on stock's schedule. The blue eye change moves with the
// voice - see zombie_eye_glow_change_early.
switch_announcer_to_richtofen_early()
{
	level endon("end_game");

	while (level.round_number < 20)
	{
		wait 1;
	}

	sndswitchannouncervox("richtofen");
	use_nuked_powerup_vox();
}

// Blue eyes are Richtofen's tell, so they move with him to round 20. Stock hangs this off
// moon_transmission_over exactly like the announcer, which lands it at round 25 - leaving yellow
// eyed zombies under Richtofen's voice for five rounds.
//
// Replaced rather than threaded alongside stock's copy, because this clears spawn_zombies and kills
// every zombie on the map to swap in the blue eyed spawner set. A second copy still waiting on the
// flag would do all of that again at round 25 and wipe the round mid-fight.
zombie_eye_glow_change_early()
{
	level endon("end_game");

	while (level.round_number < 20)
	{
		wait 1;
	}

	flag_clear("spawn_zombies");
	maps\mp\zm_nuked::death_to_all_zombies();
	level.zombie_spawners = getentarray("zombie_spawner_beyes", "script_noteworthy");

	if (isdefined(level._game_module_custom_spawn_init_func))
	{
		[[level._game_module_custom_spawn_init_func]]();
	}

	flag_set("spawn_zombies");
	level setclientfield("zombie_eye_change", 1);
}

// Nuketown gets its own set of Richtofen powerup callouts. Every other map keeps the stock lines.
//
// createvox only rewrites game["zmbdialog"][type], which playleaderdialogonplayer glues onto
// game["zmbdialog"]["prefix"] - so remapping these six leaves every other announcer line pointing
// at its stock alias. Done here rather than at init because until round 20 the prefix is
// "vox_zmba_sam", and vox_zmba_sam_powerup_firesale_nuked does not exist: remapping early would
// mute Samantha's powerup callouts for the first nineteen rounds instead of changing them.
//
// The aliases are registered as variant 0 in mod.english.aliases.csv whatever the source file was
// numbered, because get_number_variants counts up from _0 and stops at the first gap - a lone _1
// would count as zero variants and play the unsuffixed alias, which does not exist.
use_nuked_powerup_vox()
{
	maps\mp\zombies\_zm_audio_announcer::createvox("carpenter", "powerup_carpenter_nuked");
	maps\mp\zombies\_zm_audio_announcer::createvox("insta_kill", "powerup_instakill_nuked");
	maps\mp\zombies\_zm_audio_announcer::createvox("double_points", "powerup_doublepoints_nuked");
	maps\mp\zombies\_zm_audio_announcer::createvox("nuke", "powerup_nuke_nuked");
	maps\mp\zombies\_zm_audio_announcer::createvox("full_ammo", "powerup_maxammo_nuked");
	maps\mp\zombies\_zm_audio_announcer::createvox("fire_sale", "powerup_firesale_nuked");
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

	// Nuketown's Pack-a-Punch is not buildable, but _zm_buildables::is_buildable does not check
	// that - for a trigger whose script_noteworthy is "specialty_weapupgrade" it returns true
	// whenever level.zombie_buildables exists at all, unless this flag says the machine is already
	// built. Stock Nuketown ships no buildables, so the array was undefined and the first line of
	// is_buildable bailed out; the shield above defines it, and that alone flips the answer.
	//
	// What that costs: vending_weapon_upgrade opens with `if (self is_buildable())`, which hides
	// the machine, turns its trigger off and then blocks on level waittill("pap_built"). Nothing
	// on this map ever sends that, so the machine flies in on the vehicle and lands with its model
	// still hidden and no hint string, use loop or enable_trigger ever reached - an empty,
	// unusable spot. zm_nuked_perks::bring_perk does call trigger_on when it lands, which is why
	// the trigger is technically on and still does nothing.
	//
	// Set here rather than in zm_nuked_standard::main so the ordering is not a guess:
	// _zm_buildables::init assigns level.buildables_built = [] and then calls this, and
	// _zm_perks::init runs after it, so this lands in the gap between the two. The fork already
	// does the same thing in zm_highrise_classic and the two zm_buried entry points, all for maps
	// where the machine is meant to start built.
	level.buildables_built["pap"] = 1;
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

// Nuketown ships no buildable audio of its own - it never had a bench - so the stock aliases
// resolve to nothing here and the whole thing is silent. The three sounds are carried in the fork's
// own bank under _nuked names.
//
// Named apart from the stock aliases on purpose. Defined under the stock names they would sit in
// mod.all, which every map loads, and Tranzit and Buried would end up playing the fork's copies
// instead of their own. All three replacements are registered only from zm_nuked_reimagined::main,
// so nothing outside Nuketown is touched.
snd_buildable_use_alias(name)
{
	return "zmb_buildable_loop_nuked";
}

snd_buildable_complete_alias(name)
{
	return "zmb_buildable_complete_nuked";
}

// Stock's copy, with one line changed: the piece-added sound is hardcoded as a playsound rather
// than routed through an alias function, so there is no smaller hook than replacing the whole
// thing. Everything else here is verbatim.
nuked_player_build(buildable, pieces)
{
	if (isdefined(pieces))
	{
		for (i = 0; i < pieces.size; i++)
		{
			buildable buildable_set_piece_built(pieces[i]);
			player_destroy_piece(pieces[i]);
		}
	}
	else
	{
		buildable buildable_set_piece_built(self player_get_buildable_piece(buildable.buildable_slot));
		player_destroy_piece(self player_get_buildable_piece(buildable.buildable_slot));
	}

	if (isdefined(buildable.stub.model))
	{
		for (i = 0; i < buildable.pieces.size; i++)
		{
			if (isdefined(buildable.pieces[i].part_name))
			{
				buildable.stub.model notsolid();

				if (!(isdefined(buildable.pieces[i].built) && buildable.pieces[i].built))
				{
					buildable.stub.model hidepart(buildable.pieces[i].part_name);
					continue;
				}

				buildable.stub.model show();
				buildable.stub.model showpart(buildable.pieces[i].part_name);
			}
		}
	}

	if (isplayer(self))
	{
		self track_buildable_pieces_built(buildable);
	}

	if (buildable buildable_all_built())
	{
		self player_finish_buildable(buildable);
		buildable.stub buildablestub_finish_build(self);

		if (isplayer(self))
		{
			self track_buildables_built(buildable);
		}

		if (isdefined(level.buildable_built_custom_func))
		{
			self thread [[level.buildable_built_custom_func]](buildable);
		}

		// Called directly rather than through sndbuildablecompletealias, which would rely on the
		// detour above resolving from inside this file.
		alias = snd_buildable_complete_alias(buildable.buildable_name);
		self playsound(alias);
	}
	else
	{
		// The one changed line - stock plays "zmb_buildable_piece_add" here.
		self playsound("zmb_buildable_piece_add_nuked");
		assert(isdefined(level.zombie_buildables[buildable.buildable_name].building), "Missing builing hint");

		if (isdefined(level.zombie_buildables[buildable.buildable_name].building))
		{
			return level.zombie_buildables[buildable.buildable_name].building;
		}
	}

	return "";
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
	// x walks it left of the ammo counter, y sets how far up from the bottom edge it sits.
	//
	// These two numbers are the knobs if it ever needs nudging: y is in the 480 unit virtual HUD
	// space, measured from the bottom, negative up and positive down. It started at -45, which
	// floated it well above the weapon readout.
	//
	// Positive now, so the icon hangs below where "bottom" lands. vertalign bottom anchors to the
	// safe area rather than the physical edge of the screen, which is why 0 still left a visible
	// gap underneath it.
	hud_icon = newclienthudelem(self);
	hud_icon.horzalign = "right";
	hud_icon.vertalign = "bottom";
	hud_icon.alignx = "right";
	hud_icon.aligny = "bottom";
	hud_icon.x = -175;
	hud_icon.y = 10;
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
	// it into the floor to bring the worktop down. This is the knob for bench height: raise it to
	// sink the bench further, lower it to lift the bench up.
	//
	// Everything else here is offset from origin rather than from the floor - the shield assembly
	// at +70 and the trigger at +57 - so they follow the worktop down and stay in place relative
	// to it whenever this is retuned. Started at 10, which sat noticeably high.
	sink = 16;
	origin = ground_position(s_spot.origin) - (0, 0, sink);

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
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (918, 674, -56), (0, 97, 0), 0);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (-870, 90, -59), (0, 20, 0), 0);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_dolly", (1600, 940, -64), (0, 290, 0), 0);

	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (620, 300, -55), (0, 350, 0), 21);
	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (-960, 570, -57), (0, 90, 0), 21);

	// Was (-670, 94, -48) at yaw 254, which faced the wrong way and sat too far forward. Yaw turned
	// 180 to 74, and the origin walked 24 units along the viewing angle it was judged from - a
	// player at (-661, 133, -52) looking down yaw -109, so forward is
	// (cos -109, sin -109) = (-0.326, -0.946) and 24 units of it is (-8, -23).
	add_buildable_piece_spawn("t6_wpn_zmb_shield_door", (-678, 71, -48), (0, 74, 0), 21);
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