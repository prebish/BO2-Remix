#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

init()
{
	precacheshader("specialty_doublepoints_zombies");
	precacheshader("specialty_instakill_zombies");
	precacheshader("specialty_firesale_zombies");
	precacheshader("zom_icon_bonfire");
	precacheshader("zom_icon_minigun");
	precacheshader("black");
	set_zombie_var("zombie_insta_kill", 0, undefined, undefined, 1);
	set_zombie_var("zombie_point_scalar", 1, undefined, undefined, 1);
	set_zombie_var("zombie_drop_item", 0);
	set_zombie_var("zombie_timer_offset", 350);
	set_zombie_var("zombie_timer_offset_interval", 30);
	set_zombie_var("zombie_powerup_fire_sale_on", 0);
	set_zombie_var("zombie_powerup_fire_sale_time", 30);
	set_zombie_var("zombie_powerup_bonfire_sale_on", 0);
	set_zombie_var("zombie_powerup_bonfire_sale_time", 30);
	set_zombie_var("zombie_powerup_insta_kill_on", 0, undefined, undefined, 1);
	set_zombie_var("zombie_powerup_insta_kill_time", 30, undefined, undefined, 1);
	set_zombie_var("zombie_powerup_point_doubler_on", 0, undefined, undefined, 1);
	set_zombie_var("zombie_powerup_point_doubler_time", 30, undefined, undefined, 1);
	set_zombie_var("zombie_powerup_drop_increment", 2000);
	set_zombie_var("zombie_powerup_drop_max_per_round", 4);
	onplayerconnect_callback(::init_player_zombie_vars);
	level._effect["powerup_on"] = loadfx("misc/fx_zombie_powerup_on");
	level._effect["powerup_off"] = loadfx("misc/fx_zombie_powerup_off");
	level._effect["powerup_grabbed"] = loadfx("misc/fx_zombie_powerup_grab");
	level._effect["powerup_grabbed_wave"] = loadfx("misc/fx_zombie_powerup_wave");

	if (isdefined(level.using_zombie_powerups) && level.using_zombie_powerups)
	{
		level._effect["powerup_on_red"] = loadfx("misc/fx_zombie_powerup_on_red");
		level._effect["powerup_grabbed_red"] = loadfx("misc/fx_zombie_powerup_red_grab");
		level._effect["powerup_grabbed_wave_red"] = loadfx("misc/fx_zombie_powerup_red_wave");
	}

	level._effect["powerup_on_solo"] = loadfx("misc/fx_zombie_powerup_solo_on");
	level._effect["powerup_grabbed_solo"] = loadfx("misc/fx_zombie_powerup_solo_grab");
	level._effect["powerup_grabbed_wave_solo"] = loadfx("misc/fx_zombie_powerup_solo_wave");
	level._effect["powerup_on_caution"] = loadfx("misc/fx_zombie_powerup_on_red");
	level._effect["powerup_grabbed_caution"] = loadfx("misc/fx_zombie_powerup_red_grab");
	level._effect["powerup_grabbed_wave_caution"] = loadfx("misc/fx_zombie_powerup_red_wave");
	init_powerups();

	// Stock hardwires the perk bottle to func_should_never_drop - it is registered only so a
	// leaper, ghost or denizen kill can spawn one directly. Survival and Classic get a real drop
	// check instead, paired with the include in _zm_reimagined::powerup_changes. A failed check
	// deals the next powerup in the shuffle, so this changes the mix and not how much drops.
	if (isDefined(level.zombie_powerups["free_perk"]) && (is_gametype_active("zstandard") || is_classic()))
	{
		level.zombie_powerups["free_perk"].func_should_drop_with_regular_powerups = ::func_should_drop_free_perk;

		if (is_classic())
		{
			level thread watch_for_free_perk_unlock();
		}
	}

	// Carpenter's stock check wants five stripped window barriers before it will drop, and
	// Nuketown has no windows at all - its only zbarriers are the mystery box lids - so that
	// check can never pass there. Swap in one that watches for a shield instead.
	if (getDvar("mapname") == "zm_nuked" && isDefined(level.zombie_powerups["carpenter"]))
	{
		level.zombie_powerups["carpenter"].func_should_drop_with_regular_powerups = ::func_should_drop_carpenter_nuked;
	}

	if (!level.enable_magic)
	{
		return;
	}

	thread watch_for_drop();

	// The fire sale rotation, one alias per track. Each name needs a matching row in
	// soundbank/mod.all.aliases.csv pointing at a FLAC in sound/mus/zombie/firesale - adding a
	// song is those two edits plus a name on this list.
	//
	// The FLAC has to be mono 48kHz 16-bit *and* encoded in 1024 sample blocks, which is not what
	// ffmpeg does by default - its 4608 sample blocks stream back as audible glitching. Encode
	// with -ac 1 -ar 48000 -sample_fmt s16 -c:a flac -frame_size 1024.
	//
	// FIRE SALE MUSIC on DEFAULT leaves the list unset, which is what pick_firesale_music reads as
	// "hand the track back to stock". Read here rather than per fire sale so the setting behaves
	// like the rest of the RULES tab and takes effect on the next game, not mid-match.
	if (scripts\zm\_zm_reimagined::mod_setting("zmr_firesale_music", 1))
	{
		level.firesale_music = array("mus_fire_sale_rich", "mus_fire_sale_hiphop", "mus_fire_sale_4_minutes", "mus_fire_sale_number_one");
	}

	thread setup_firesale_audio();
	thread setup_bonfiresale_audio();
	level.use_new_carpenter_func = ::start_carpenter_new;
	level.board_repair_distance_squared = 562500;
}

watch_for_drop()
{
	if (is_encounter())
	{
		return;
	}

	flag_wait("start_zombie_round_logic");
	flag_wait("begin_spawning");
	players = get_players();
	score_to_drop = players.size * level.zombie_vars["zombie_score_start_" + players.size + "p"] + level.zombie_vars["zombie_powerup_drop_increment"];

	while (true)
	{
		flag_wait("zombie_drop_powerups");
		players = get_players();
		curr_total_score = 0;

		for (i = 0; i < players.size; i++)
		{
			if (isdefined(players[i].score_total))
			{
				curr_total_score = curr_total_score + players[i].score_total;
			}
		}

		if (curr_total_score > score_to_drop)
		{
			level.zombie_vars["zombie_powerup_drop_increment"] = level.zombie_vars["zombie_powerup_drop_increment"] * 1.14;
			score_to_drop = curr_total_score + level.zombie_vars["zombie_powerup_drop_increment"];
			level.zombie_vars["zombie_drop_item"] = 1;
		}

		wait 0.5;
	}
}

powerup_drop(drop_point)
{
	if (level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"])
	{
		return;
	}

	if (!isdefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0)
	{
		return;
	}

	rand_drop = randomint(100);

	powerup_chance = 2;

	if (rand_drop >= powerup_chance)
	{
		if (!level.zombie_vars["zombie_drop_item"])
		{
			return;
		}

		debug = "score";
	}
	else
	{
		debug = "random";
	}

	playable_area = getentarray("player_volume", "script_noteworthy");
	level.powerup_drop_count++;
	powerup = maps\mp\zombies\_zm_net::network_safe_spawn("powerup", 1, "script_model", drop_point + vectorscale((0, 0, 1), 40.0));
	valid_drop = 0;

	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = 1;
		}
	}

	if (valid_drop && level.rare_powerups_active)
	{
		pos = (drop_point[0], drop_point[1], drop_point[2] + 42);

		if (check_for_rare_drop_override(pos))
		{
			level.zombie_vars["zombie_drop_item"] = 0;
			valid_drop = 0;
		}
	}

	if (!valid_drop)
	{
		level.powerup_drop_count--;
		powerup delete();
		return;
	}

	powerup powerup_setup();
	print_powerup_drop(powerup.powerup_name, debug);
	powerup thread powerup_timeout();
	powerup thread powerup_wobble();
	powerup thread powerup_grab();
	powerup thread powerup_move();
	powerup thread powerup_emp();
	level.zombie_vars["zombie_drop_item"] = 0;
	level notify("powerup_dropped", powerup);
}

powerup_timeout()
{
	if (isdefined(level._powerup_timeout_override) && !isdefined(self.powerup_team))
	{
		self thread [[level._powerup_timeout_override]]();
		return;
	}

	self endon("powerup_grabbed");
	self endon("death");
	self endon("powerup_reset");
	self show();
	wait_time = 15;

	if (isdefined(level._powerup_timeout_custom_time))
	{
		time = [[level._powerup_timeout_custom_time]](self);

		if (time == 0)
		{
			return;
		}

		wait_time = time;
	}

	wait(wait_time);

	for (i = 0; i < 60; i++)
	{
		if (i % 2)
		{
			self ghost();

			if (isdefined(self.worldgundw))
			{
				self.worldgundw ghost();
			}
		}
		else
		{
			self show();

			if (isdefined(self.worldgundw))
			{
				self.worldgundw show();
			}
		}

		if (i < 15)
		{
			wait 0.5;
			continue;
		}

		if (i < 35)
		{
			wait 0.25;
			continue;
		}

		wait 0.1;
	}

	self notify("powerup_timedout");
	self powerup_delete();
}

powerup_move()
{
	self endon("powerup_timedout");
	self endon("powerup_grabbed");

	while (true)
	{
		self waittill("move_powerup", moveto, distance);
		drag_vector = moveto - self.origin;
		range_squared = lengthsquared(drag_vector);

		if (range_squared > distance * distance)
		{
			drag_vector = vectornormalize(drag_vector);
			drag_vector = distance * drag_vector;
			moveto = self.origin + drag_vector;
		}

		self.origin = moveto;
	}
}

get_next_powerup()
{
	powerup = level.zombie_powerup_array[level.zombie_powerup_index];
	level.zombie_powerup_index++;

	if (level.zombie_powerup_index >= level.zombie_powerup_array.size)
	{
		level.zombie_powerup_index = 0;
		randomize_powerups();
		level thread play_fx_on_powerup_dropped();
	}

	return powerup;
}

play_fx_on_powerup_dropped()
{
	level waittill("powerup_dropped", powerup);

	if (powerup.solo)
	{
		playfx(level._effect["powerup_grabbed_solo"], powerup.origin);
		playfx(level._effect["powerup_grabbed_wave_solo"], powerup.origin);
	}
	else if (powerup.caution)
	{
		playfx(level._effect["powerup_grabbed_caution"], powerup.origin);
		playfx(level._effect["powerup_grabbed_wave_caution"], powerup.origin);
	}
	else
	{
		playfx(level._effect["powerup_grabbed"], powerup.origin);
		playfx(level._effect["powerup_grabbed_wave"], powerup.origin);
	}
}

powerup_grab(powerup_team)
{
	if (isdefined(self) && self.zombie_grabbable)
	{
		self thread powerup_zombie_grab(powerup_team);
		return;
	}

	self endon("powerup_timedout");
	self endon("powerup_grabbed");
	range_squared = 4096;

	while (isdefined(self))
	{
		players = get_array_of_closest(self.origin, get_players());

		for (i = 0; i < players.size; i++)
		{
			if ((self.powerup_name == "minigun" || self.powerup_name == "tesla" || self.powerup_name == "random_weapon" || self.powerup_name == "meat_stink") && players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				continue;
			}

			if (isdefined(self.can_pick_up_in_last_stand) && !self.can_pick_up_in_last_stand && players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			{
				continue;
			}

			if (players[i].sessionstate != "playing")
			{
				continue;
			}

			ignore_range = 0;

			if (isdefined(players[i].ignore_range_powerup) && players[i].ignore_range_powerup == self)
			{
				players[i].ignore_range_powerup = undefined;
				ignore_range = 1;
			}

			if (distancesquared(players[i] getCentroid(), self.origin) < range_squared || ignore_range)
			{
				if (isdefined(level._powerup_grab_check))
				{
					if (!self [[level._powerup_grab_check]](players[i]))
					{
						continue;
					}
				}

				self.power_up_grab_player = players[i];

				if (isdefined(level.zombie_powerup_grab_func))
				{
					level thread [[level.zombie_powerup_grab_func]]();
				}
				else
				{
					switch (self.powerup_name)
					{
						case "nuke":
							level thread nuke_powerup(self, players[i].team);
							players[i] thread powerup_vo("nuke");
							zombies = getaiarray(level.zombie_team);
							players[i].zombie_nuked = arraysort(zombies, self.origin);
							players[i] notify("nuke_triggered");
							break;

						case "full_ammo":
							level thread full_ammo_powerup(self, players[i]);
							players[i] thread powerup_vo("full_ammo");
							break;

						case "double_points":
							level thread double_points_powerup(self, players[i]);
							players[i] thread powerup_vo("double_points");
							break;

						case "insta_kill":
							level thread insta_kill_powerup(self, players[i]);
							players[i] thread powerup_vo("insta_kill");
							break;

						case "carpenter":
							if (is_classic())
							{
								players[i] thread maps\mp\zombies\_zm_pers_upgrades::persistent_carpenter_ability_check();
							}

							if (isdefined(level.use_new_carpenter_func))
							{
								level thread [[level.use_new_carpenter_func]](self.origin);
							}
							else
							{
								level thread start_carpenter(self.origin);
							}

							if (scripts\zm\_zm_reimagined::mod_setting("zmr_carpenter_shield", 1))
							{
								level thread carpenter_restore_shields(players[i]);
							}

							players[i] thread powerup_vo("carpenter");
							break;

						case "fire_sale":
							level thread start_fire_sale(self);
							players[i] thread powerup_vo("firesale");
							break;

						case "bonfire_sale":
							level thread start_bonfire_sale(self);
							players[i] thread powerup_vo("firesale");
							break;

						case "minigun":
							level thread minigun_weapon_powerup(players[i]);
							players[i] thread powerup_vo("minigun");
							break;

						case "free_perk":
							level thread free_perk_powerup(self);
							break;

						case "tesla":
							level thread tesla_weapon_powerup(players[i]);
							players[i] thread powerup_vo("tesla");
							break;

						case "random_weapon":
							if (!level random_weapon_powerup(self, players[i]))
							{
								continue;
							}

							break;

						case "bonus_points_player":
							level thread bonus_points_player_powerup(self, players[i]);
							players[i] thread powerup_vo("bonus_points_solo");
							break;

						case "bonus_points_team":
							level thread bonus_points_team_powerup(self);
							players[i] thread powerup_vo("bonus_points_team");
							break;

						case "teller_withdrawl":
							level thread teller_withdrawl(self, players[i]);
							break;

						default:
							if (isdefined(level._zombiemode_powerup_grab))
							{
								level thread [[level._zombiemode_powerup_grab]](self, players[i]);
							}

							break;
					}
				}

				maps\mp\_demo::bookmark("zm_player_powerup_grabbed", gettime(), players[i]);

				if (should_award_stat(self.powerup_name))
				{
					players[i] maps\mp\zombies\_zm_stats::increment_client_stat("drops");
					players[i] maps\mp\zombies\_zm_stats::increment_player_stat("drops");
					players[i] maps\mp\zombies\_zm_stats::increment_client_stat(self.powerup_name + "_pickedup");
					players[i] maps\mp\zombies\_zm_stats::increment_player_stat(self.powerup_name + "_pickedup");
				}

				if (self.solo)
				{
					playfx(level._effect["powerup_grabbed_solo"], self.origin);
					playfx(level._effect["powerup_grabbed_wave_solo"], self.origin);
				}
				else if (self.caution)
				{
					playfx(level._effect["powerup_grabbed_caution"], self.origin);
					playfx(level._effect["powerup_grabbed_wave_caution"], self.origin);
				}
				else
				{
					playfx(level._effect["powerup_grabbed"], self.origin);
					playfx(level._effect["powerup_grabbed_wave"], self.origin);
				}

				if (isdefined(self.stolen) && self.stolen)
				{
					level notify("monkey_see_monkey_dont_achieved");
				}

				if (isdefined(self.grabbed_level_notify))
				{
					level notify(self.grabbed_level_notify);
				}

				self.claimed = 1;
				wait 0.1;
				playsoundatposition("zmb_powerup_grabbed", self.origin);
				self stoploopsound();
				self hide();

				if (self.powerup_name != "fire_sale")
				{
					if (isdefined(self.power_up_grab_player))
					{
						if (isdefined(level.powerup_intro_vox))
						{
							level thread [[level.powerup_intro_vox]](self);
							return;
						}
						else if (isdefined(level.powerup_vo_available))
						{
							can_say_vo = [[level.powerup_vo_available]]();

							if (!can_say_vo)
							{
								self powerup_delete();
								self notify("powerup_grabbed");
								return;
							}
						}
					}
				}

				level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog(self.powerup_name, self.power_up_grab_player.pers["team"]);
				self powerup_delete();
				self notify("powerup_grabbed");
			}
		}

		wait 0.1;
	}
}

powerup_emp()
{
	self endon("powerup_timedout");
	self endon("powerup_grabbed");

	if (!should_watch_for_emp())
	{
		return;
	}

	if (self.caution || self.zombie_grabbable)
	{
		return;
	}

	while (true)
	{
		level waittill("emp_detonate", origin, radius);

		if (distancesquared(origin, self.origin) < radius * radius)
		{
			playfx(level._effect["powerup_off"], self.origin);
			self thread powerup_delete_delayed();
			self notify("powerup_timedout");
		}
	}
}

full_ammo_powerup(drop_item, player)
{
	clip_only = 0;

	if (is_encounter())
	{
		clip_only = 1;
		drop_item.hint = &"ZOMBIE_POWERUP_CLIP_AMMO";
	}

	players = get_players(player.team);

	if (isdefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}

	i = 0;

	while (i < players.size)
	{
		if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			i++;
			continue;
		}

		if (is_true(players[i].is_zombie))
		{
			i++;
			continue;
		}

		primary_weapons = players[i] getweaponslist(1);

		players[i] notify("zmb_max_ammo");
		players[i] notify("zmb_lost_knife");
		players[i] notify("zmb_disable_claymore_prompt");
		players[i] notify("zmb_disable_spikemore_prompt");

		x = 0;

		while (x < primary_weapons.size)
		{
			base_weapon = maps\mp\zombies\_zm_weapons::get_base_weapon_name(primary_weapons[x], 1);

			if (scripts\zm\_zm_reimagined::is_overheat_weapon(base_weapon))
			{
				players[i] setweaponoverheating(0, 0, primary_weapons[x]);
				x++;
				continue;
			}

			if (level.headshots_only && is_lethal_grenade(primary_weapons[x]))
			{
				x++;
				continue;
			}

			if (isdefined(level.zombie_include_equipment) && isdefined(level.zombie_include_equipment[primary_weapons[x]]))
			{
				x++;
				continue;
			}

			if (isdefined(level.zombie_weapons_no_max_ammo) && isdefined(level.zombie_weapons_no_max_ammo[primary_weapons[x]]))
			{
				x++;
				continue;
			}

			if (players[i] hasweapon(primary_weapons[x]))
			{
				if (clip_only)
				{
					if (weaponMaxAmmo(primary_weapons[x]) == 0)
					{
						x++;
						continue;
					}

					new_ammo = players[i] getWeaponAmmoStock(primary_weapons[x]) + weaponClipSize(primary_weapons[x]);

					if (weaponDualWieldWeaponName(primary_weapons[x]) != "none")
					{
						new_ammo += weaponClipSize(weaponDualWieldWeaponName(primary_weapons[x]));
					}

					if (new_ammo > weaponMaxAmmo(primary_weapons[x]))
					{
						new_ammo = weaponMaxAmmo(primary_weapons[x]);
					}

					players[i] setWeaponAmmoStock(primary_weapons[x], new_ammo);
				}
				else
				{
					players[i] givemaxammo(primary_weapons[x]);

					if (scripts\zm\_zm_reimagined::mod_setting("zmr_max_ammo_magazine", 1))
					{
						// givemaxammo only refills the reserve, so stock alone still leaves the player
						// needing a reload before any of it is usable. Fill the magazine as well.
						players[i] setweaponammoclip(primary_weapons[x], weaponClipSize(primary_weapons[x]));

						// Akimbo weapons carry the second magazine under their own weapon name, so the
						// off hand stays empty unless it is filled separately.
						dw_name = weaponDualWieldWeaponName(primary_weapons[x]);

						if (dw_name != "none")
						{
							players[i] setweaponammoclip(dw_name, weaponClipSize(dw_name));
						}
					}
				}
			}

			x++;
		}

		players[i] notify("weapon_ammo_change");

		i++;
	}

	level thread full_ammo_on_hud(drop_item, player.team);

	if (is_encounter())
	{
		level thread empty_clip_powerup(drop_item, player);
	}
}

full_ammo_on_hud(drop_item, player_team)
{
	self endon("disconnect");
	hudelem = maps\mp\gametypes_zm\_hud_util::createserverfontstring("objective", 2, player_team);
	hudelem maps\mp\gametypes_zm\_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - level.zombie_vars["zombie_timer_offset_interval"] * 2);
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;

	if (isdefined(drop_item))
	{
		hudelem.label = drop_item.hint;
	}

	hudelem thread full_ammo_move_hud(player_team);
}

full_ammo_move_hud(player_team)
{
	players = get_players(player_team);
	players[0] playsoundtoteam("zmb_full_ammo", player_team);
	wait 0.5;
	move_fade_time = 1.5;
	self fadeovertime(move_fade_time);
	self moveovertime(move_fade_time);
	self.y = 270;
	self.alpha = 0;
	wait(move_fade_time);
	self destroyelem();
}

empty_clip_powerup(drop_item, player)
{
	team = getOtherTeam(player.team);

	i = 0;
	players = get_players(team);

	while (i < players.size)
	{
		if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			i++;
			continue;
		}

		if (is_true(players[i].is_zombie))
		{
			i++;
			continue;
		}

		players[i] notify("zmb_empty_clip");

		primaries = players[i] getweaponslist();

		foreach (weapon in primaries)
		{
			base_weapon = maps\mp\zombies\_zm_weapons::get_base_weapon_name(weapon, 1);

			if (scripts\zm\_zm_reimagined::is_overheat_weapon(base_weapon))
			{
				players[i] setweaponoverheating(1, 100, weapon);
				continue;
			}

			if (!isweaponprimary(weapon))
			{
				continue;
			}

			dual_wield_weapon = weaponDualWieldWeaponName(weapon);
			alt_weapon = weaponAltWeaponName(weapon);

			players[i] setweaponammoclip(weapon, 0);

			if (dual_wield_weapon != "none")
			{
				players[i] setweaponammoclip(dual_wield_weapon, 0);
			}

			if (alt_weapon != "none")
			{
				players[i] setweaponammoclip(alt_weapon, 0);
			}
		}

		if (isDefined(players[i] get_player_lethal_grenade()))
		{
			players[i] setweaponammoclip(players[i] get_player_lethal_grenade(), 0);
		}

		if (isDefined(players[i] get_player_tactical_grenade()))
		{
			players[i] setweaponammoclip(players[i] get_player_tactical_grenade(), 0);
		}

		if (isDefined(players[i] get_player_placeable_mine()))
		{
			players[i] setweaponammoclip(players[i] get_player_placeable_mine(), 0);

			if (players[i] getcurrentweapon() == players[i] get_player_placeable_mine())
			{
				players[i] empty_clip_switch_to_primary_weapon();
			}
		}

		if (players[i] hasweapon("time_bomb_zm") && players[i] getweaponammoclip("time_bomb_zm") == 1)
		{
			players[i] empty_clip_swap_weapon_to_detonator();
		}

		i++;
	}

	level thread empty_clip_on_hud(drop_item, team);
}

empty_clip_on_hud(drop_item, team)
{
	self endon("disconnect");
	hudelem = maps\mp\gametypes_zm\_hud_util::createserverfontstring("objective", 2, team);
	hudelem maps\mp\gametypes_zm\_hud_util::setpoint("TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.color = (0.21, 0, 0);
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	hudelem.label = &"ZOMBIE_POWERUP_CLIP_EMPTY";
	hudelem thread empty_clip_move_hud(team);
}

empty_clip_move_hud(team)
{
	wait 0.5;
	move_fade_time = 1.5;
	self fadeovertime(move_fade_time);
	self moveovertime(move_fade_time);
	self.y = 270;
	self.alpha = 0;
	wait move_fade_time;
	self destroy();
}

empty_clip_switch_to_primary_weapon()
{
	if (isdefined(self.last_held_primary_weapon) && self hasweapon(self.last_held_primary_weapon))
	{
		self switchtoweapon(self.last_held_primary_weapon);
	}
	else
	{
		primaryweapons = self getweaponslistprimaries();

		if (isdefined(primaryweapons) && primaryweapons.size > 0)
		{
			self switchtoweapon(primaryweapons[0]);
		}
		else
		{
			self maps\mp\zombies\_zm_weapons::give_fallback_weapon();
		}
	}
}

empty_clip_swap_weapon_to_detonator()
{
	switch_to_weapon = 0;

	if (self getcurrentweapon() == "time_bomb_zm")
	{
		switch_to_weapon = 1;
	}

	self takeweapon("time_bomb_zm");
	self giveweapon("time_bomb_detonator_zm");
	self setweaponammoclip("time_bomb_detonator_zm", 0);
	self setweaponammostock("time_bomb_detonator_zm", 0);
	self setactionslot(2, "weapon", "time_bomb_detonator_zm");

	if (switch_to_weapon)
	{
		self switchtoweapon("time_bomb_detonator_zm");
	}

	self giveweapon("time_bomb_zm");
}

nuke_powerup(drop_item, player_team)
{
	location = drop_item.origin;
	player = drop_item.power_up_grab_player;
	playfx(drop_item.fx, location);
	level thread maps\mp\zombies\_zm_powerups::nuke_flash(player_team);
	wait 0.5;
	zombies = getaispeciesarray(level.zombie_team, "all");
	zombies = arraysort(zombies, location);
	zombies_nuked = [];

	for (i = 0; i < zombies.size; i++)
	{
		if (isdefined(zombies[i].ignore_nuke) && zombies[i].ignore_nuke)
		{
			continue;
		}

		if (isdefined(zombies[i].marked_for_death) && zombies[i].marked_for_death)
		{
			continue;
		}

		if (isdefined(zombies[i].nuke_damage_func))
		{
			zombies[i] thread [[zombies[i].nuke_damage_func]]();
			continue;
		}

		if (is_magic_bullet_shield_enabled(zombies[i]))
		{
			continue;
		}

		zombies[i].marked_for_death = 1;
		zombies[i].nuked = 1;
		zombies_nuked[zombies_nuked.size] = zombies[i];
	}

	for (i = 0; i < zombies_nuked.size; i++)
	{
		if (!isdefined(zombies_nuked[i]))
		{
			continue;
		}

		if (is_magic_bullet_shield_enabled(zombies_nuked[i]))
		{
			continue;
		}

		if (i < 5 && !zombies_nuked[i].isdog)
		{
			zombies_nuked[i] thread maps\mp\animscripts\zm_death::flame_death_fx();
		}

		if (!zombies_nuked[i].isdog)
		{
			if (!(isdefined(zombies_nuked[i].no_gib) && zombies_nuked[i].no_gib))
			{
				zombies_nuked[i] maps\mp\zombies\_zm_spawner::zombie_head_gib();
			}

			zombies_nuked[i] playsound("evt_nuked");
		}

		zombies_nuked[i] dodamage(zombies_nuked[i].health + 666, zombies_nuked[i].origin);
	}

	players = get_players(player_team);

	for (i = 0; i < players.size; i++)
	{
		players[i] maps\mp\zombies\_zm_score::player_add_points("nuke_powerup", 400);
	}

	if (is_encounter())
	{
		players = get_players(getOtherTeam(player_team));

		for (i = 0; i < players.size; i++)
		{
			if (is_true(players[i].is_zombie))
			{
				if (players[i].sessionstate == "playing")
				{
					players[i] dodamage(players[i].health, players[i].origin);
				}
			}
			else
			{
				if (is_player_valid(players[i]))
				{
					score = 400 * maps\mp\zombies\_zm_score::get_points_multiplier(player);

					if (players[i].score < score)
					{
						players[i] maps\mp\zombies\_zm_score::minus_to_player_score(players[i].score);
					}
					else
					{
						players[i] maps\mp\zombies\_zm_score::minus_to_player_score(score);
					}

					radiusDamage(players[i].origin + (0, 0, 5), 10, 75, 75, undefined, "MOD_EXPLOSIVE");
				}
				else if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
				{
					players[i] thread scripts\zm\_zm_reimagined::player_suicide();
				}
			}
		}
	}
}

insta_kill_powerup(drop_item, player)
{
	if (isDefined(level.insta_kill_powerup_override))
	{
		level thread [[level.insta_kill_powerup_override]](drop_item, player);
		return;
	}

	if (is_classic())
	{
		player thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_insta_kill_upgrade_check();
	}

	team = player.team;

	time = 30;

	if (is_encounter())
	{
		time = 15;
		level thread half_damage_powerup(drop_item, player);
	}

	if (level.zombie_vars[team]["zombie_powerup_insta_kill_on"])
	{
		level.zombie_vars[team]["zombie_powerup_insta_kill_time"] += time;
		return;
	}

	temp_enta = spawn("script_origin", (0, 0, 0));
	temp_enta playloopsound("zmb_insta_kill_loop");

	level.zombie_vars[team]["zombie_half_damage"] = 0;
	level.zombie_vars[team]["zombie_insta_kill"] = !is_true(level.zombie_vars[team]["zombie_powerup_half_damage_on"]);

	level.zombie_vars[team]["zombie_powerup_insta_kill_on"] = 1;

	while (level.zombie_vars[team]["zombie_powerup_insta_kill_time"] >= 0)
	{
		wait 0.05;
		level.zombie_vars[team]["zombie_powerup_insta_kill_time"] -= 0.05;
	}

	level.zombie_vars[team]["zombie_half_damage"] = is_true(level.zombie_vars[team]["zombie_powerup_half_damage_on"]);
	level.zombie_vars[team]["zombie_insta_kill"] = 0;

	level.zombie_vars[team]["zombie_powerup_insta_kill_on"] = 0;
	level.zombie_vars[team]["zombie_powerup_insta_kill_time"] = time;

	get_players()[0] playsoundtoteam("zmb_insta_kill", team);
	temp_enta stoploopsound(2);
	temp_enta delete();

	players = get_players(team);
	i = 0;

	while (i < players.size)
	{
		if (isDefined(players[i]))
		{
			players[i] notify("insta_kill_over");
		}

		i++;
	}
}

half_damage_powerup(drop_item, player)
{
	team = getOtherTeam(player.team);

	time = 15;

	if (level.zombie_vars[team]["zombie_powerup_half_damage_on"])
	{
		level.zombie_vars[team]["zombie_powerup_half_damage_time"] += time;
		return;
	}

	level.zombie_vars[team]["zombie_insta_kill"] = 0;
	level.zombie_vars[team]["zombie_half_damage"] = !is_true(level.zombie_vars[team]["zombie_powerup_insta_kill_on"]);

	level.zombie_vars[team]["zombie_powerup_half_damage_on"] = 1;

	while (level.zombie_vars[team]["zombie_powerup_half_damage_time"] >= 0)
	{
		wait 0.05;
		level.zombie_vars[team]["zombie_powerup_half_damage_time"] -= 0.05;
	}

	level.zombie_vars[team]["zombie_insta_kill"] = is_true(level.zombie_vars[team]["zombie_powerup_insta_kill_on"]);
	level.zombie_vars[team]["zombie_half_damage"] = 0;

	level.zombie_vars[team]["zombie_powerup_half_damage_on"] = 0;
	level.zombie_vars[team]["zombie_powerup_half_damage_time"] = time;
}

double_points_powerup(drop_item, player)
{
	team = player.team;

	time = 30;

	if (is_encounter())
	{
		time = 15;
		level thread half_points_powerup(drop_item, player);
	}

	if (level.zombie_vars[team]["zombie_powerup_point_doubler_on"])
	{
		level.zombie_vars[team]["zombie_powerup_point_doubler_time"] += time;
		return;
	}

	if (is_true(level.pers_upgrade_double_points))
	{
		player thread maps\mp\zombies\_zm_pers_upgrades_functions::pers_upgrade_double_points_pickup_start();
	}

	if (isDefined(level.current_game_module) && level.current_game_module == 2)
	{
		if (isDefined(player._race_team))
		{
			if (player._race_team == 1)
			{
				level._race_team_double_points = 1;
			}
			else
			{
				level._race_team_double_points = 2;
			}
		}
	}

	players = get_players(team);

	for (i = 0; i < players.size; i++)
	{
		players[i] setclientfield("score_cf_double_points_active", 1);
	}

	temp_ent = spawn("script_origin", (0, 0, 0));
	temp_ent playloopsound("zmb_double_point_loop");

	level.zombie_vars[team]["zombie_point_scalar"] *= 2;
	level.zombie_vars[team]["zombie_powerup_point_doubler_on"] = 1;

	while (level.zombie_vars[team]["zombie_powerup_point_doubler_time"] >= 0)
	{
		wait 0.05;
		level.zombie_vars[team]["zombie_powerup_point_doubler_time"] -= 0.05;
	}

	level.zombie_vars[team]["zombie_point_scalar"] /= 2;
	level.zombie_vars[team]["zombie_powerup_point_doubler_on"] = 0;
	level.zombie_vars[team]["zombie_powerup_point_doubler_time"] = time;

	temp_ent stoploopsound(2);
	temp_ent delete();

	players = get_players(team);

	for (i = 0; i < players.size; i++)
	{
		players[i] playsound("zmb_points_loop_off");
		players[i] setclientfield("score_cf_double_points_active", 0);
	}

	level._race_team_double_points = undefined;
}

half_points_powerup(drop_item, player)
{
	team = getOtherTeam(player.team);

	time = 15;

	if (level.zombie_vars[team]["zombie_powerup_point_halfer_on"])
	{
		level.zombie_vars[team]["zombie_powerup_point_halfer_time"] += time;
		return;
	}

	level.zombie_vars[team]["zombie_point_scalar"] /= 2;
	level.zombie_vars[team]["zombie_powerup_point_halfer_on"] = 1;

	while (level.zombie_vars[team]["zombie_powerup_point_halfer_time"] >= 0)
	{
		wait 0.05;
		level.zombie_vars[team]["zombie_powerup_point_halfer_time"] -= 0.05;
	}

	level.zombie_vars[team]["zombie_point_scalar"] *= 2;
	level.zombie_vars[team]["zombie_powerup_point_halfer_on"] = 0;
	level.zombie_vars[team]["zombie_powerup_point_halfer_time"] = time;
}

// Carpenter boards the windows back up, so it repairs a carried shield too. Reaches the whole
// team the same way full_ammo_powerup does, rather than only the player who grabbed it.
carpenter_restore_shields(player)
{
	players = get_players(player.team);

	if (isdefined(level._get_game_module_players))
	{
		players = [[level._get_game_module_players]](player);
	}

	for (i = 0; i < players.size; i++)
	{
		if (players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			continue;
		}

		if (is_true(players[i].is_zombie))
		{
			continue;
		}

		// Both are undefined on a map with no shield. Going through the player's own reset
		// function rather than zeroing the counter here means Alcatraz and Origins get their own
		// shield handled without naming any of the three variants.
		if (!isDefined(level.riotshield_name) || !isDefined(players[i].player_shield_reset_health))
		{
			continue;
		}

		// Carrying it, not deployed - a shield placed on a wall is a separate entity with its own
		// health that this does not touch.
		if (!players[i] hasweapon(level.riotshield_name))
		{
			continue;
		}

		players[i] [[players[i].player_shield_reset_health]]();
	}
}

start_fire_sale(item)
{
	level thread maps\mp\zombies\_zm_audio_announcer::leaderdialog("fire_sale", getotherteam(item.power_up_grab_player.pers["team"]));

	if (level.zombie_vars["zombie_powerup_fire_sale_time"] > 0 && is_true(level.zombie_vars["zombie_powerup_fire_sale_on"]))
	{
		level.zombie_vars["zombie_powerup_fire_sale_time"] += 30;
		return;
	}

	level notify("powerup fire sale");
	level endon("powerup fire sale");

	// Pick the track before the flag below goes up: the intercom threads poll that flag and then
	// read the choice off level, so it has to be there by the time they wake. Grabbing a second
	// fire sale while one is running takes the early out above and leaves the song alone.
	level.firesale_music_playing = pick_firesale_music();

	level.zombie_vars["zombie_powerup_fire_sale_on"] = 1;
	level thread toggle_fire_sale_on();

	for (level.zombie_vars["zombie_powerup_fire_sale_time"] = 30; level.zombie_vars["zombie_powerup_fire_sale_time"] > 0; level.zombie_vars["zombie_powerup_fire_sale_time"] -= 0.05)
	{
		wait 0.05;
	}

	level.zombie_vars["zombie_powerup_fire_sale_on"] = 0;
	level notify("fire_sale_off");
}

// Byte for byte what stock does. It is here only so that the call to play_firesale_audio below
// binds to this script's copy: replacing play_firesale_audio on its own achieves nothing, because
// the only thing that calls it is stock's setup_firesale_audio, and a stock script calling its own
// function resolves to the stock one. Every link in the chain from init down to playloopsound has
// to live in this file or the rotation is unreachable.
setup_firesale_audio()
{
	wait 2;

	intercom = getentarray("intercom", "targetname");

	while (true)
	{
		while (level.zombie_vars["zombie_powerup_fire_sale_on"] == 0)
		{
			wait 0.2;
		}

		foreach (speaker in intercom)
		{
			speaker thread play_firesale_audio();
		}

		while (level.zombie_vars["zombie_powerup_fire_sale_on"] == 1)
		{
			wait 0.1;
		}

		level notify("firesale_over");
	}
}

// Stock ships this as a copy-paste of the function above - same flag, same intercoms, same track,
// so a fire sale starts the music on every speaker twice and a bonfire sale starts none. Kept as it
// is rather than fixed, since the pair of them is what the mix has always been balanced against.
setup_bonfiresale_audio()
{
	wait 2;

	intercom = getentarray("intercom", "targetname");

	while (true)
	{
		while (level.zombie_vars["zombie_powerup_fire_sale_on"] == 0)
		{
			wait 0.2;
		}

		foreach (speaker in intercom)
		{
			speaker thread play_bonfiresale_audio();
		}

		while (level.zombie_vars["zombie_powerup_fire_sale_on"] == 1)
		{
			wait 0.1;
		}

		level notify("firesale_over");
	}
}

// Draws the next fire sale track, with the one that just played held out of the draw. Straight
// random over three tracks repeats a third of the time, and a repeat back to back reads as the
// rotation being broken rather than as luck.
//
// An empty list is the DEFAULT setting: returning undefined leaves play_firesale_audio on the stock
// alias, so DEFAULT is stock behaviour exactly - announcer and all - rather than an imitation of it.
pick_firesale_music()
{
	if (!isDefined(level.firesale_music) || level.firesale_music.size == 0)
	{
		return undefined;
	}

	choices = [];

	foreach (track in level.firesale_music)
	{
		if (isDefined(level.firesale_music_playing) && track == level.firesale_music_playing)
		{
			continue;
		}

		choices[choices.size] = track;
	}

	// Only one track on the list, so it has to repeat.
	if (choices.size == 0)
	{
		return level.firesale_music[0];
	}

	return random(choices);
}

// Stock runs this on every intercom on the map and hardwires the alias, which is why the rotation
// cannot live in the sound aliases: several rows sharing one name would have each speaker roll its
// own track and play them over the top of each other. start_fire_sale draws once instead and every
// intercom reads that one choice.
play_firesale_audio()
{
	if (is_true(level.sndfiresalemusoff))
	{
		return;
	}

	if (isDefined(level.firesale_music_playing))
	{
		alias = level.firesale_music_playing;
	}
	else if (is_true(level.sndannouncerisrich))
	{
		// No draw to read, either because FIRE SALE MUSIC is on DEFAULT or because something
		// turned the fire sale on without going through start_fire_sale. Both stock alias names,
		// and mus_fire_sale_rich has to stay defined in mod.all.aliases.csv - dropping that row
		// once left every Richtofen game with a silent fire sale.
		alias = "mus_fire_sale_rich";
	}
	else
	{
		alias = "mus_fire_sale";
	}

	self playloopsound(alias);
	level waittill("firesale_over");
	self stoploopsound();
}

// Stock's copy of play_firesale_audio, threaded onto the same intercoms off the same flag by
// setup_bonfiresale_audio. Left in place so the sound stack is unchanged, but pointed at the same
// draw - if it kept the hardcoded alias it would start over the top of the chosen track.
play_bonfiresale_audio()
{
	self play_firesale_audio();
}

// Repairing a shield is the only thing Carpenter can do on a map with no windows, so hold it back
// until somebody is actually carrying one rather than letting it drop as a powerup that does
// nothing. A failed check deals the next powerup instead, so nothing is lost by waiting.
func_should_drop_carpenter_nuked()
{
	if (!isDefined(level.riotshield_name))
	{
		return false;
	}

	players = get_players();

	foreach (player in players)
	{
		if (player hasweapon(level.riotshield_name))
		{
			return true;
		}
	}

	return false;
}

// Every powerup gets one slot in the shuffle, so passing every time would make the perk bottle as
// common as Max Ammo. The rarity setting is that divisor: 2 leaves it half as common as any other
// single powerup, which on Nuketown's seven-powerup pool works out at roughly one bottle per
// fourteen drops, and 4 halves it again.
//
// A failed check deals the next powerup instead of dropping nothing, so turning this off changes
// the mix rather than the amount that drops.
func_should_drop_free_perk()
{
	if (!scripts\zm\_zm_reimagined::mod_setting("zmr_free_perk", 1))
	{
		return false;
	}

	if (is_classic() && !is_true(level.free_perk_unlocked))
	{
		return false;
	}

	rarity = scripts\zm\_zm_reimagined::mod_setting("zmr_free_perk_rarity", 2);

	// randomint(0) errors and randomint(1) would make it as common as everything else, so anything
	// under 2 is treated as the default rather than trusted.
	if (rarity < 2)
	{
		rarity = 2;
	}

	return randomint(rarity) == 0;
}

// Classic keeps the perk bottle out of the rotation until somebody is properly perked up. The test
// is four perks held at once, not four bought over the course of a game - perks_active has entries
// removed when a perk is lost, so a player who buys three, goes down and buys two more has never
// qualified. Once it has happened the bottle stays in the rotation for the rest of the match.
//
// Polled rather than hung off the perk_acquired notify so that players joining partway through, and
// perks gained any other way, are all covered without a hook for each.
watch_for_free_perk_unlock()
{
	while (!is_true(level.free_perk_unlocked))
	{
		players = get_players();

		foreach (player in players)
		{
			if (isDefined(player.perks_active) && player.perks_active.size >= 4)
			{
				level.free_perk_unlocked = 1;
				break;
			}
		}

		wait 1;
	}
}

func_should_drop_fire_sale()
{
	if (level.zombie_vars["zombie_powerup_fire_sale_on"] == 1)
	{
		return false;
	}

	if (isdefined(level.disable_firesale_drop) && level.disable_firesale_drop)
	{
		return false;
	}

	if (isdefined(level.random_perk_moves))
	{
		if (level.chest_moves < 1 && level.random_perk_moves < 1)
		{
			return false;
		}
	}
	else
	{
		if (level.chest_moves < 1)
		{
			return false;
		}
	}

	return true;
}

powerup_hud_monitor()
{
	flag_wait("start_zombie_round_logic");

	if (isdefined(level.current_game_module) && level.current_game_module == 2)
	{
		return;
	}

	flashing_timers = [];
	flashing_values = [];
	flashing_timer = 10;
	flashing_delta_time = 0;
	flashing_is_on = 0;
	flashing_value = 3;
	flashing_min_timer = 0.15;

	while (flashing_timer >= flashing_min_timer)
	{
		if (flashing_timer < 5)
		{
			flashing_delta_time = 0.1;
		}
		else
		{
			flashing_delta_time = 0.2;
		}

		if (flashing_is_on)
		{
			flashing_timer = flashing_timer - flashing_delta_time - 0.05;
			flashing_value = 2;
		}
		else
		{
			flashing_timer = flashing_timer - flashing_delta_time;
			flashing_value = 3;
		}

		flashing_timers[flashing_timers.size] = flashing_timer;
		flashing_values[flashing_values.size] = flashing_value;
		flashing_is_on = !flashing_is_on;
	}

	client_fields = [];
	powerup_keys = getarraykeys(level.zombie_powerups);

	for (powerup_key_index = 0; powerup_key_index < powerup_keys.size; powerup_key_index++)
	{
		if (isdefined(level.zombie_powerups[powerup_keys[powerup_key_index]].client_field_name))
		{
			powerup_name = powerup_keys[powerup_key_index];
			client_fields[powerup_name] = spawnstruct();
			client_fields[powerup_name].client_field_name = level.zombie_powerups[powerup_name].client_field_name;
			client_fields[powerup_name].enemy_client_field_name = level.zombie_powerups[powerup_name].enemy_client_field_name;
			client_fields[powerup_name].solo = level.zombie_powerups[powerup_name].solo;
			client_fields[powerup_name].time_name = level.zombie_powerups[powerup_name].time_name;
			client_fields[powerup_name].on_name = level.zombie_powerups[powerup_name].on_name;
		}
	}

	client_field_keys = getarraykeys(client_fields);

	while (true)
	{
		wait 0.05;
		waittillframeend;
		players = get_players();

		for (playerindex = 0; playerindex < players.size; playerindex++)
		{
			for (client_field_key_index = 0; client_field_key_index < client_field_keys.size; client_field_key_index++)
			{
				player = players[playerindex];

				if (isdefined(level.powerup_player_valid))
				{
					if (![[level.powerup_player_valid]](player))
					{
						continue;
					}
				}

				client_field_name = client_fields[client_field_keys[client_field_key_index]].client_field_name;
				time_name = client_fields[client_field_keys[client_field_key_index]].time_name;
				on_name = client_fields[client_field_keys[client_field_key_index]].on_name;
				powerup_timer = undefined;
				powerup_on = undefined;

				enemy_client_field_name = client_fields[client_field_keys[client_field_key_index]].enemy_client_field_name;
				enemy_powerup_timer = undefined;
				enemy_powerup_on = undefined;

				if (client_fields[client_field_keys[client_field_key_index]].solo)
				{
					if (isdefined(player._show_solo_hud) && player._show_solo_hud == 1)
					{
						powerup_timer = player.zombie_vars[time_name];
						powerup_on = player.zombie_vars[on_name];
					}
				}
				else if (isdefined(level.zombie_vars[player.team][time_name]))
				{
					powerup_timer = level.zombie_vars[player.team][time_name];
					powerup_on = level.zombie_vars[player.team][on_name];

					enemy_team = getotherteam(player.team);

					if (isdefined(level.zombie_vars[enemy_team][time_name]))
					{
						enemy_powerup_timer = level.zombie_vars[enemy_team][time_name];
						enemy_powerup_on = level.zombie_vars[enemy_team][on_name];
					}
				}
				else if (isdefined(level.zombie_vars[time_name]))
				{
					powerup_timer = level.zombie_vars[time_name];
					powerup_on = level.zombie_vars[on_name];
				}

				if (isdefined(powerup_timer) && isdefined(powerup_on))
				{
					player set_clientfield_powerups(client_field_name, powerup_timer, powerup_on, flashing_timers, flashing_values);

					if (isdefined(enemy_client_field_name) && isdefined(enemy_powerup_timer) && isdefined(enemy_powerup_on))
					{
						player set_clientfield_powerups(enemy_client_field_name, enemy_powerup_timer, enemy_powerup_on, flashing_timers, flashing_values);
					}

					continue;
				}

				player setclientfieldtoplayer(client_field_name, 0);
			}
		}
	}
}