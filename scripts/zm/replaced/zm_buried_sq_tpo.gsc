#include maps\mp\zm_buried_sq_tpo;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_unitrigger;

promote_to_corpse_model(str_model)
{
	v_spawn_point = groundtrace(self.origin + vectorscale((0, 0, 1), 10.0), self.origin + vectorscale((0, 0, -1), 300.0), 0, undefined)["position"];
	self.corpse_model = spawn("script_model", v_spawn_point);
	self.corpse_model.angles = self.angles;
	self.corpse_model setmodel(str_model);
	self.corpse_model.targetname = "sq_tpo_corpse_model";
	self _pose_corpse();
	self.corpse_model.unitrigger = setup_unitrigger(&"ZM_BURIED_SQ_SCH", ::unitrigger_think);
}

unitrigger_think()
{
	self endon("kill_trigger");
	self thread unitrigger_killed();
	b_trigger_used = 0;

	while (!b_trigger_used)
	{
		self waittill("trigger", player);

		b_progress_bar_done = 0;
		n_frame_count = 0;

		while (player usebuttonpressed() && !b_progress_bar_done)
		{
			if (!isdefined(self.progress_bar))
			{
				self.progress_bar = player createprimaryprogressbar();
				self.progress_bar updatebar(0.01, 1 / 1.5);
				self.progress_bar_text = player createprimaryprogressbartext();
				self.progress_bar_text settext(&"ZM_BURIED_SQ_SEARCHING");
				self.progress_bar thread scripts\zm\_zm_reimagined::hide_on_scoreboard(player);
				self.progress_bar_text thread scripts\zm\_zm_reimagined::hide_on_scoreboard(player);
				self thread _kill_progress_bar();
			}

			n_progress_amount = n_frame_count / 30.0;
			n_frame_count++;

			if (n_progress_amount == 1)
			{
				b_progress_bar_done = 1;
			}

			wait 0.05;
		}

		self _delete_progress_bar();

		if (b_progress_bar_done)
		{
			b_trigger_used = 1;
		}
	}

	if (b_progress_bar_done)
	{
		self.stub.hint_string = "";
		self sethintstring(self.stub.hint_string);

		if (item_is_on_corpse())
		{
			iprintlnbold(&"ZM_BURIED_SQ_FND");
			player give_player_sq_tpo_switch();
		}
		else
		{
			iprintlnbold(&"ZM_BURIED_SQ_NFND");
		}

		self thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.stub);
	}
}
