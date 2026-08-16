#include maps\mp\zombies\_zm_perk_vulture;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\_visionset_mgr;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_ai_basic;

_vulture_perk_think()
{
	self endon("death");
	self endon("disconnect");
	self endon("vulture_perk_lost");

	prev_speed = 0;
	next_time = gettime();

	while (true)
	{
		b_player_in_zombie_stink = 0;
		speed = self scripts\zm\_zm_reimagined::get_player_speed();
		slowing_down = (speed - prev_speed) <= -10;
		prev_speed = speed;
		time = gettime();

		if (time < next_time)
		{
			wait 0.05;
			continue;
		}

		if (speed != 0 && !slowing_down)
		{
			wait 0.05;
			continue;
		}

		next_time = time + randomintrange(250, 500);

		if (!isdefined(level.perk_vulture.zombie_stink_array))
		{
			level.perk_vulture.zombie_stink_array = [];
		}

		if (level.perk_vulture.zombie_stink_array.size > 0)
		{
			a_close_points = arraysort(level.perk_vulture.zombie_stink_array, self.origin, 1, 300);

			if (a_close_points.size > 0)
			{
				b_player_in_zombie_stink = self _is_player_in_zombie_stink(a_close_points);
			}
		}

		self _handle_zombie_stink(b_player_in_zombie_stink);
		wait 0.05;
	}
}