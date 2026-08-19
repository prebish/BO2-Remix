#include maps\mp\zombies\_zm_weapon_locker;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

// Stock only asks whether the weapon exists on the map you are standing in, which lets you store a
// gun on one locker map and then be unable to get it back on another. The locker is shared across
// Tranzit, Die Rise and Buried, and its whole point is carrying a weapon between them, so a gun that
// only some of them have is a dead end - the stored slot is occupied by something the retrieval
// check will refuse for the rest of the game.
//
// The extra test is level.locker_excluded_weapons, built in _zm_reimagined::post_init. Everything
// else here is stock and is left alone.
triggerweaponslockerisvalidweapon(weaponname)
{
	weaponname = get_base_weapon_name(weaponname, 1);

	if (!is_weapon_included(weaponname))
	{
		return false;
	}

	if (is_offhand_weapon(weaponname) || is_limited_weapon(weaponname))
	{
		return false;
	}

	if (isdefined(level.locker_excluded_weapons) && isinarray(level.locker_excluded_weapons, weaponname))
	{
		return false;
	}

	return true;
}
