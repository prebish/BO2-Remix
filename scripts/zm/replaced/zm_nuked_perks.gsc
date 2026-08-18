#include maps\mp\zm_nuked_perks;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_game_module;

init_nuked_perks()
{
	level.perk_arrival_vehicle = getent("perk_arrival_vehicle", "targetname");
	level.perk_arrival_vehicle setmodel("tag_origin");

	level.grief_perk_arrival_vehicles = getentarray("grief_perk_arrival_vehicle", "targetname");
	level.grief_perk_arrival_vehicles_ind = 0;

	foreach (grief_perk_arrival_vehicle in level.grief_perk_arrival_vehicles)
	{
		grief_perk_arrival_vehicle setmodel("tag_origin");
	}

	flag_init("perk_vehicle_bringing_in_perk");
	structs = getstructarray("zm_perk_machine", "targetname");

	for (i = 0; i < structs.size; i++)
	{
		structs[i] structdelete();
	}

	level.nuked_perks = [];
	level.nuked_perks[0] = spawnstruct();
	level.nuked_perks[0].model = "zombie_vending_revive";
	level.nuked_perks[0].script_noteworthy = "specialty_quickrevive";
	level.nuked_perks[0].turn_on_notify = "revive_on";
	level.nuked_perks[1] = spawnstruct();
	level.nuked_perks[1].model = "zombie_vending_sleight";
	level.nuked_perks[1].script_noteworthy = "specialty_fastreload";
	level.nuked_perks[1].turn_on_notify = "sleight_on";
	level.nuked_perks[2] = spawnstruct();
	level.nuked_perks[2].model = "zombie_vending_doubletap2";
	level.nuked_perks[2].script_noteworthy = "specialty_rof";
	level.nuked_perks[2].turn_on_notify = "doubletap_on";
	level.nuked_perks[3] = spawnstruct();
	level.nuked_perks[3].model = "zombie_vending_jugg";
	level.nuked_perks[3].script_noteworthy = "specialty_armorvest";
	level.nuked_perks[3].turn_on_notify = "juggernog_on";
	// This value does not survive: _zm_perks::turn_packapunch_on overwrites the model of every
	// specialty_weapupgrade machine with level.machine_assets["packapunch"].off_model the moment it
	// starts, and swaps in the on model when it catches "Pack_A_Punch_on" - which turn_perks_on
	// fires about three seconds in, long before this machine is flown down. Kept at the off model
	// to match what the engine ends up with rather than to imply anything is chosen here.
	//
	// The empty spot the machine used to land on was not a model problem. See the
	// level.buildables_built["pap"] note in zm_nuked_reimagined::register_buildables.
	level.nuked_perks[4] = spawnstruct();
	level.nuked_perks[4].model = "p6_anim_zm_buildable_pap";
	level.nuked_perks[4].script_noteworthy = "specialty_weapupgrade";
	level.nuked_perks[4].turn_on_notify = "Pack_A_Punch_on";

	// PHD Flopper. Nuketown ships no machine for it, so this is the only place it is declared -
	// perk_changes enables the perk itself, and enable_divetonuke_perk_for_level is what hands
	// perk_machine_spawn_init the setup function that gives this machine its own keys instead of
	// the Speed Cola ones the switch falls back to.
	level.nuked_perks[5] = spawnstruct();
	level.nuked_perks[5].model = "p6_zm_al_vending_nuke_on";
	level.nuked_perks[5].script_noteworthy = "specialty_flakjacket";
	level.nuked_perks[5].turn_on_notify = "divetonuke_on";

	// Deadshot Daiquiri. Simpler than PHD above - perk_machine_spawn_init has a case for it, so it
	// needs no custom-perk hook, and perk_changes already enables it here for the perk bottle pool.
	level.nuked_perks[6] = spawnstruct();
	level.nuked_perks[6].model = "p6_zm_al_vending_ads_on";
	level.nuked_perks[6].script_noteworthy = "specialty_deadshot";
	level.nuked_perks[6].turn_on_notify = "deadshot_on";

	// Stamin-Up and Mule Kick, the two perks that used to be reachable here only through a bottle.
	// Both already had everything but the machine: perk_changes enables them, their models,
	// materials and fx are in zone_source/includes/zm_nuked.zone, and perk_machine_spawn_init has
	// cases that name and wire both.
	//
	// The machine struct is keyed on specialty_longersprint, not the specialty_movefaster that the
	// bottle pool uses - swap_marathon_perk renames the perk afterwards, but the spawn case matches
	// the original name.
	level.nuked_perks[7] = spawnstruct();
	level.nuked_perks[7].model = "zombie_vending_marathon";
	level.nuked_perks[7].script_noteworthy = "specialty_longersprint";
	level.nuked_perks[7].turn_on_notify = "marathon_on";

	level.nuked_perks[8] = spawnstruct();
	level.nuked_perks[8].model = "zombie_vending_three_gun";
	level.nuked_perks[8].script_noteworthy = "specialty_additionalprimaryweapon";
	level.nuked_perks[8].turn_on_notify = "additionalprimaryweapon_on";

	level.override_perk_targetname = "zm_perk_machine_override";
	random_perk_structs = [];
	perk_structs = getstructarray("zm_random_machine", "script_noteworthy");

	for (i = 0; i < perk_structs.size; i++)
	{
		random_perk_structs[i] = getstruct(perk_structs[i].target, "targetname");
		random_perk_structs[i].script_int = perk_structs[i].script_int;
	}

	level.random_perk_structs = array_randomize(random_perk_structs);

	// Driven off the list above rather than a fixed 5, so adding a perk needs no change here.
	// There are 10 candidate spots in the map, so there is room to keep going.
	for (i = 0; i < level.nuked_perks.size; i++)
	{
		level.random_perk_structs[i].targetname = "zm_perk_machine_override";
		level.random_perk_structs[i].model = level.nuked_perks[i].model;
		level.random_perk_structs[i].blocker_model = getent(level.random_perk_structs[i].target, "targetname");
		level.random_perk_structs[i].script_noteworthy = level.nuked_perks[i].script_noteworthy;
		level.random_perk_structs[i].turn_on_notify = level.nuked_perks[i].turn_on_notify;

		if (!isdefined(level.struct_class_names["targetname"]["zm_perk_machine_override"]))
		{
			level.struct_class_names["targetname"]["zm_perk_machine_override"] = [];
		}

		level.struct_class_names["targetname"]["zm_perk_machine_override"][level.struct_class_names["targetname"]["zm_perk_machine_override"].size] = level.random_perk_structs[i];
	}
}

perks_from_the_sky()
{
	level thread turn_perks_on();
	top_height = 8000;
	machines = [];
	machine_triggers = [];
	machines[0] = getent("vending_revive", "targetname");

	if (!isdefined(machines[0]))
	{
		return;
	}

	machine_triggers[0] = getent("vending_revive", "target");
	move_perk(machines[0], top_height, 5.0, 0.001);
	machine_triggers[0] trigger_off();
	machines[1] = getent("vending_doubletap", "targetname");
	machine_triggers[1] = getent("vending_doubletap", "target");
	move_perk(machines[1], top_height, 5.0, 0.001);
	machine_triggers[1] trigger_off();
	machines[2] = getent("vending_sleight", "targetname");
	machine_triggers[2] = getent("vending_sleight", "target");
	move_perk(machines[2], top_height, 5.0, 0.001);
	machine_triggers[2] trigger_off();
	machines[3] = getent("vending_jugg", "targetname");
	machine_triggers[3] = getent("vending_jugg", "target");
	move_perk(machines[3], top_height, 5.0, 0.001);
	machine_triggers[3] trigger_off();
	machine_triggers[4] = getent("specialty_weapupgrade", "script_noteworthy");
	machines[4] = getent(machine_triggers[4].target, "targetname");
	move_perk(machines[4], top_height, 5.0, 0.001);
	machine_triggers[4] trigger_off();

	// divetonuke_perk_machine_setup is what names the PHD machine, so it only exists once the perk
	// is enabled. Checked rather than assumed - a missing entry here would leave the arrays holding
	// an undefined machine for bring_random_perk to pick.
	//
	// Appended at machines.size rather than a fixed index, and this matters. Written as [5] and [6],
	// a missing PHD machine left index 5 empty while Deadshot still took 6, so the array had a hole
	// in it. bring_random_perk picks randomintrange(0, machines.size) and does not test what it
	// drew, so it could spend one of the seven deliveries on the hole - and every machine it never
	// drew stays parked at top_height with its trigger off, invisible and unusable for the whole
	// game. Pack-a-Punch is machines[4] and as likely to be the one stranded as any other.
	phd_machine = getent("vending_divetonuke", "targetname");

	if (isdefined(phd_machine))
	{
		index = machines.size;
		machines[index] = phd_machine;
		machine_triggers[index] = getent("vending_divetonuke", "target");
		move_perk(machines[index], top_height, 5.0, 0.001);
		machine_triggers[index] trigger_off();
	}

	// Deadshot names its machine and its trigger differently - vending_deadshot_model for the model,
	// vending_deadshot for what the trigger points at - so this pair does not read like the others.
	deadshot_machine = getent("vending_deadshot_model", "targetname");

	if (isdefined(deadshot_machine))
	{
		index = machines.size;
		machines[index] = deadshot_machine;
		machine_triggers[index] = getent("vending_deadshot", "target");
		move_perk(machines[index], top_height, 5.0, 0.001);
		machine_triggers[index] trigger_off();
	}

	// Stamin-Up and Mule Kick, named by perk_machine_spawn_init off the structs added in
	// init_nuked_perks. Guarded the same way as the two above, so a perk that fails to spawn a
	// machine costs nothing rather than stranding an undefined entry in the arrays.
	marathon_machine = getent("vending_marathon", "targetname");

	if (isdefined(marathon_machine))
	{
		index = machines.size;
		machines[index] = marathon_machine;
		machine_triggers[index] = getent("vending_marathon", "target");
		move_perk(machines[index], top_height, 5.0, 0.001);
		machine_triggers[index] trigger_off();
	}

	mulekick_machine = getent("vending_additionalprimaryweapon", "targetname");

	if (isdefined(mulekick_machine))
	{
		index = machines.size;
		machines[index] = mulekick_machine;
		machine_triggers[index] = getent("vending_additionalprimaryweapon", "target");
		move_perk(machines[index], top_height, 5.0, 0.001);
		machine_triggers[index] trigger_off();
	}

	flag_wait("initial_blackscreen_passed");

	if (is_encounter())
	{
		grief_bring_random_perks(machines, machine_triggers);
	}
	else
	{
		bring_random_perks(machines, machine_triggers);
	}
}

// One call per machine, or whatever is left never comes down. bring_random_perk removes what it
// delivers - arrayremoveindex is an engine builtin that mutates in place - so nine calls deliver
// nine distinct machines and none is drawn twice.
//
// Every two rounds rather than every three. Nuketown carries nine of these now, four more than
// stock's five, and on the old spacing the last one landed at round 24-25. Pack-a-Punch is drawn
// from the same pool as the perks, so a one in nine chance of being last meant it could be most of
// a game away. Two round gaps put the whole set down by round 17, earlier than the seven machine
// schedule managed.
bring_random_perks(machines, machine_triggers)
{
	wait(randomintrange(10, 20));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(3, 4);
	wait(randomintrange(20, 45));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(5, 6);
	wait(randomintrange(20, 45));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(7, 8);
	wait(randomintrange(20, 45));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(9, 10);
	wait(randomintrange(20, 45));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(11, 12);
	wait(randomintrange(20, 45));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(13, 14);
	wait(randomintrange(30, 60));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(15, 16);
	wait(randomintrange(30, 60));
	bring_random_perk(machines, machine_triggers);

	wait_for_round_range(17, 18);
	wait(randomintrange(30, 60));
	bring_random_perk(machines, machine_triggers);
}

grief_bring_random_perks(machines, machine_triggers)
{
	level waittill("restart_round_start");

	// One call per machine, PHD Flopper included - Grief brings them all down at once, so a fixed
	// count would leave the sixth stranded in the sky.
	count = machines.size;

	for (i = 0; i < count; i++)
	{
		grief_bring_random_perk(machines, machine_triggers);
	}
}

grief_bring_random_perk(machines, machine_triggers)
{
	count = machines.size;

	if (count <= 0)
	{
		return;
	}

	index = randomintrange(0, count);
	level thread grief_bring_perk(machines[index], machine_triggers[index]);
	arrayremoveindex(machines, index);
	arrayremoveindex(machine_triggers, index);
}

grief_bring_perk(machine, trigger)
{
	if (is_true(level.scr_zm_ui_gametype_pro) && trigger.script_noteworthy == "specialty_weapupgrade")
	{
		return;
	}

	initial_perk = level.grief_perk_arrival_vehicles_ind == 0;
	perk_arrival_vehicle = level.grief_perk_arrival_vehicles[level.grief_perk_arrival_vehicles_ind];
	level.grief_perk_arrival_vehicles_ind++;

	if (initial_perk)
	{
		playsoundatposition("zmb_perks_incoming_quad_front", (0, 0, 0));
		playsoundatposition("zmb_perks_incoming_alarm", (-2198, 486, 327));
	}

	is_doubletap = 0;
	is_sleight = 0;
	is_revive = 0;
	is_jugger = 0;
	machine setclientfield("clientfield_perk_intro_fx", 1);
	machine.fx = spawn("script_model", machine.origin);
	machine.fx playloopsound("zmb_perks_incoming_loop", 6);
	machine.fx thread perk_incoming_sound();
	machine.fx.angles = machine.angles;
	machine.fx setmodel("tag_origin");
	machine.fx linkto(machine);
	machine linkto(perk_arrival_vehicle, "tag_origin", (0, 0, 0), (0, 0, 0));
	start_node = getvehiclenode("perk_arrival_path_" + machine.script_int, "targetname");

	perk_arrival_vehicle perk_follow_path(start_node);
	machine unlink();
	offset = (0, 0, 0);

	if (issubstr(machine.targetname, "doubletap"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 20);
		is_doubletap = 1;
	}
	else if (issubstr(machine.targetname, "sleight"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 5);
		is_sleight = 1;
	}
	else if (issubstr(machine.targetname, "revive"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 10);
		trigger.blocker_model hide();
		is_revive = 1;
	}
	else if (issubstr(machine.targetname, "jugger"))
	{
		forward_dir = anglestoforward(machine.original_angles + vectorscale((0, -1, 0), 90.0));
		offset = vectorscale(forward_dir * -1, 10);
		is_jugger = 1;
	}

	if (!is_revive)
	{
		trigger.blocker_model delete();
	}

	machine.original_pos = machine.original_pos + (offset[0], offset[1], 0);
	machine.origin = machine.original_pos;
	machine.angles = machine.original_angles;

	if (is_revive)
	{
		level.quick_revive_final_pos = machine.origin;
		level.quick_revive_final_angles = machine.angles;
	}

	machine.fx stoploopsound(0.5);
	machine setclientfield("clientfield_perk_intro_fx", 0);
	playsoundatposition("zmb_perks_incoming_land", machine.origin);
	trigger trigger_on();
	machine thread bring_perk_landing_damage();
	machine.fx unlink();
	machine.fx delete();
	machine notify(machine.turn_on_notify);
	level notify(machine.turn_on_notify);
	machine vibrate(vectorscale((0, -1, 0), 100.0), 0.3, 0.4, 3);
	machine playsound("zmb_perks_power_on");
	machine maps\mp\zombies\_zm_perks::perk_fx(undefined, 1);

	if (is_revive)
	{
		level.revive_machine_spawned = 1;
		machine thread maps\mp\zombies\_zm_perks::perk_fx("revive_light");
	}
	else if (is_jugger)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("jugger_light");
	}
	else if (is_doubletap)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("doubletap_light");
	}
	else if (is_sleight)
	{
		machine thread maps\mp\zombies\_zm_perks::perk_fx("sleight_light");
	}
}

bring_perk_landing_damage()
{
	// Stock threads this on the machine the moment it lands, in both the normal and grief paths,
	// which makes it the one reliable "this machine has arrived" hook. Nuketown has no power
	// switch, so the machines added to the drop rotation - Mule Kick, PHD, Deadshot - would
	// otherwise sit on their unlit model with their power-on callback never run.
	self thread scripts\zm\replaced\_zm_perks::nuked_perk_machine_power_on();

	player_prone_damage_radius = 300;
	zombie_damage_radius = 500;
	earthquake(0.7, 2.5, self.origin, 1000);
	exploder(500 + self.script_int);
	exploder(511);
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		if (is_true(players[i].is_zombie) && players[i].sessionstate == "playing")
		{
			if (distancesquared(players[i].origin, self.origin) <= zombie_damage_radius * zombie_damage_radius)
			{
				players[i] dodamage(players[i].health, players[i].origin);
			}
		}
		else
		{
			if (distancesquared(players[i].origin, self.origin) <= player_prone_damage_radius * player_prone_damage_radius)
			{
				players[i] setstance("prone");
				players[i] shellshock("default", 1.5);
			}
		}
	}

	zombies = getaiarray(level.zombie_team);

	for (i = 0; i < zombies.size; i++)
	{
		zombie = zombies[i];

		if (!isdefined(zombie) || !isalive(zombie))
		{
			continue;
		}

		if (distancesquared(zombie.origin, self.origin) > zombie_damage_radius * zombie_damage_radius)
		{
			continue;
		}

		zombie thread perk_machine_knockdown_zombie(self.origin);
	}
}