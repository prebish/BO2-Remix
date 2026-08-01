#include maps\mp\zombies\_zm_banking;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

// Two things only: put the balance back on screen at the bank, and make the withdraw prompt state
// the right number. Everything else about the bank stays stock - the 250,000 cap, the withdraw fee,
// the 1000 point increments, the balance carrying between games and the teller.
//
// These two exist so the triggers are built pointing at the prompt functions below. The think
// functions are left as they are, so the amounts moved are still the stock ones.
bank_deposit_unitrigger()
{
	bank_unitrigger("bank_deposit", ::trigger_deposit_update_prompt, ::trigger_deposit_think, 5, 5, undefined, 5);
}

bank_withdraw_unitrigger()
{
	bank_unitrigger("bank_withdraw", ::trigger_withdraw_update_prompt, ::trigger_withdraw_think, 5, 5, undefined, 5);
}

trigger_deposit_update_prompt(player)
{
	self thread show_balance(player);

	if ((player.score <= 0) || (player.account_value >= level.bank_account_max))
	{
		self sethintstring("");
		return 0;
	}

	self sethintstring(&"ZOMBIE_BANK_DEPOSIT_PROMPT", level.bank_deposit_ddl_increment_amount);
	return 1;
}

// The stock version of this passes two values, an amount and the withdraw fee, into
// ZOMBIE_BANK_WITHDRAW_PROMPT. This mod's copy of that string only has one slot, which is what made
// the prompt read 10000 instead of 1000. One value in, one slot to fill.
trigger_withdraw_update_prompt(player)
{
	self thread show_balance(player);

	if (player.account_value <= 0)
	{
		self sethintstring("");
		return 0;
	}

	self sethintstring(&"ZOMBIE_BANK_WITHDRAW_PROMPT", level.bank_deposit_ddl_increment_amount);
	return 1;
}

// Balance readout, shown only while stood in the trigger. One element per player, kept on the
// trigger's stub so it can be torn down with the trigger.
show_balance(player)
{
	stub = self.stub;

	if (!isDefined(stub.bankbalancehud))
	{
		stub.bankbalancehud = [];
	}

	num = player getentitynumber();

	if (isDefined(stub.bankbalancehud[num]))
	{
		player notify("update_account_value");
		return;
	}

	hud = newclienthudelem(player);
	hud.alignx = "center";
	hud.aligny = "middle";
	hud.horzalign = "center";
	hud.vertalign = "bottom";
	hud.y = -100;
	hud.foreground = 1;
	hud.hidewheninmenu = 1;
	hud.font = "default";
	hud.fontscale = 1;
	hud.alpha = 1;
	hud.color = (1, 1, 1);
	hud.label = &"ZOMBIE_HUD_ACCOUNT_BALANCE";
	hud thread scripts\zm\_zm_reimagined::hide_on_scoreboard(player);
	stub.bankbalancehud[num] = hud;

	hud thread update_balance(player);

	while (isDefined(self))
	{
		if (!player isTouching(self) || !is_player_valid(player) || player isSprinting() || player isThrowingGrenade())
		{
			hud.alpha = 0;
			wait 0.05;
			continue;
		}

		if (!player.scoreboard_open)
		{
			hud.alpha = 1;
		}

		wait 0.05;
	}

	stub.bankbalancehud[num] destroy();
	stub.bankbalancehud[num] = undefined;
}

// account_value counts thousands, so it is scaled back up for display.
//
// Polled rather than waiting on an update_account_value notify. That notify came from the mod's own
// deposit and withdraw think functions, which are not restored here - the stock ones are still in
// use so the amounts stay vanilla - so nothing fires it after a transaction and the readout sat
// stale until you walked away and came back. The element only exists while a player is at the
// trigger, so polling it costs nothing meaningful.
update_balance(player)
{
	self endon("death");

	while (isDefined(player))
	{
		self setvalue(round_up_to_ten(int(player.account_value * level.bank_deposit_ddl_increment_amount)));

		wait 0.1;
	}
}
