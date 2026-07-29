#include maps\mp\zm_nuked_standard;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\gametypes_zm\_zm_gametype;
#include maps\mp\zombies\_zm_game_module;
#include maps\mp\zombies\_zm_magicbox;



main()
{
	maps\mp\gametypes_zm\_zm_gametype::setup_standard_objects("nuked");
	maps\mp\zombies\_zm_game_module::set_current_game_module(level.game_module_standard_index);
	level.enemy_location_override_func = ::enemy_location_override;
	nuked_treasure_chest_init();
	scripts\zm\zm_nuked\zm_nuked_reimagined::buildables_init();
	// testing
level.zombie_vars["zombie_score_start_1p"] = 3000;
	flag_wait("initial_blackscreen_passed");
	flag_set("power_on");
}

// culdesac_chest is left out - that spot is the Zombie Shield bench now. Dropping it from
// level.chests is enough to retire it, since _zm_reimagined::hide_unused_chest_zbarriers
// hides the zbarrier of any treasure_chest_use struct that isn't in the list.
nuked_treasure_chest_init()
{
	level.chests = [];
	level.chests[level.chests.size] = getStruct("start_chest1", "script_noteworthy");
	level.chests[level.chests.size] = getStruct("start_chest2", "script_noteworthy");
	level.chests[level.chests.size] = getStruct("oh2_chest", "script_noteworthy");
	level.chests[level.chests.size] = getStruct("oh1_chest", "script_noteworthy");

	maps\mp\zombies\_zm_magicbox::treasure_chest_init("start_chest");
}