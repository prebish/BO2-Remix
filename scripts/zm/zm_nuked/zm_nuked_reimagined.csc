#include clientscripts\mp\_utility;
#include clientscripts\mp\zombies\_zm_utility;

main()
{
	replaceFunc(clientscripts\mp\zm_nuked::main, scripts\zm\replaced\zm_nuked::main);

	// Client half of the Zombie Shield bench. _zm_buildables::init calls this from _zm.csc at
	// the point the server calls its half from _zm.gsc, which is what keeps the "buildable"
	// clientfield registration matched.
	level.init_buildables = ::register_buildables;

	clientscripts\_explosive_dart::main();
}

register_buildables()
{
	// Must match init_buildables in zm_nuked_reimagined.gsc or the clientfield sizes differ.
	level.buildable_piece_count = 3;

	clientscripts\mp\zombies\_zm_buildables::include_zombie_buildable("riotshield_zm");
	clientscripts\mp\zombies\_zm_buildables::add_zombie_buildable("riotshield_zm");

	level thread clientscripts\mp\zombies\_zm_buildables::set_clientfield_buildables_code_callbacks();
}