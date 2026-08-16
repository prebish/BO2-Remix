#include maps\mp\zombies\_zm_game_module;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio_announcer;
#include maps\mp\gametypes_zm\_zm_gametype;

// Search & Rezurrect was the only mode that used this. The replacement is kept, and kept empty,
// so stock's Grief round-end logic stays neutered - the Encounter framework in
// zencounter_reimagined decides when a team has lost and calls game_won itself.
wait_for_team_death_and_round_end()
{
}

game_won_freeze_controls_think()
{
	self endon("disconnect");

	// fixes player not switching to last stand weapon if game ended from their down
	while (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() && isdefined(self.laststandpistol) && self getcurrentweapon() != self.laststandpistol)
	{
		wait 0.05;
	}

	self freezecontrols(1);
}

zombie_goto_round(target_round)
{
	level endon("end_game");

	if (target_round < 1)
	{
		target_round = 1;
	}

	level.zombie_total = 0;
	zombies = get_round_enemy_array();

	for (i = 0; i < zombies.size; i++)
	{
		zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
	}

	game["axis_spawnpoints_randomized"] = undefined;
	game["allies_spawnpoints_randomized"] = undefined;
	set_game_var("switchedsides", !get_game_var("switchedsides"));

	waittillframeend; // wait for active perks to be stopped

	respawn_players();

	wait 0.05; // let all players fully respawn

	level thread player_respawn_award();

	if (isDefined(level.round_start_wait_func))
	{
		level thread [[level.round_start_wait_func]](5);
	}
}

respawn_players()
{
	players = get_players();

	foreach (player in players)
	{
		if (player maps\mp\zombies\_zm_laststand::player_is_in_laststand())
		{
			if (isdefined(player.revivetrigger))
			{
				player.revivetrigger delete();
			}

			player thread maps\mp\zombies\_zm_laststand::auto_revive(player);
		}

		player [[level.spawnplayer]]();
		player freeze_player_controls(1);
	}
}

player_respawn_award()
{
	maps\mp\zombies\_zm::award_grenades_for_survivors();
	players = get_players();

	foreach (player in players)
	{
		if (player.score < level.player_starting_points)
		{
			player maps\mp\zombies\_zm_score::add_to_player_score(level.player_starting_points - player.score);
		}

		if (isDefined(player get_player_placeable_mine()))
		{
			player giveweapon(player get_player_placeable_mine());
			player set_player_placeable_mine(player get_player_placeable_mine());
			player setactionslot(4, "weapon", player get_player_placeable_mine());
			player setweaponammoclip(player get_player_placeable_mine(), 2);
		}
	}
}