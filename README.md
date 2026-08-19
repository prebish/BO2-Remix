# Call of Duty: Black Ops 2 Zombies - Reimagined-Lite

A fork of **Reimagined**, the Black Ops 2 Zombies mod by Jbleezy.

> **The main difference: buildables are assembled from parts you find, as in the base game.**
> Reimagined handed you the Zombie Shield, Turret, Electric Trap, Jet Gun, Sliquifier, Trample
> Steam, Subwoofer and Head Chopper already built at the start of a match, and crafted the power
> switch, Pack-a-Punch, the Diner hatch and the NAV table for you. Parts were never collected. This
> fork removed that whole system, and it is the largest single difference between the two.
>
> The notes below describe **this fork's** behaviour: entries for features the fork removed have
> been taken out rather than left in place, so what is written here is what the mod currently does.

## Original mod created by: Jbleezy

[YouTube](https://youtube.com/ItsJbirdJustin)

[Twitch](https://twitch.tv/Jbleezy)

[Twitter](https://twitter.com/ItsJbleezy)

[Discord](https://dsc.gg/Jbleezy)

[Donate](https://ko-fi.com/Jbleezy)


## Credits

The mod itself is by **Jbleezy** (links above). The HUD and icon art below comes from third-party
packs, used with credit as their authors ask.

* **Black Ops 1 HUD for BO2** — [mjmodz](https://github.com/mjmodz/Black-Ops-1-HUD-for-BO2) v1.0.0,
  BO1 images by **Kingslayer Kyle**. Only the HUD art is used: the twelve perk icons, six powerup
  icons, and the blood splatter standing in for the stock dpad image. All of it is scoped to
  Nuketown. The pack's scoreboard, pause menu and options screens are deliberately not used — its
  readme asks that the author's signature be kept on those, and since none of them ship here,
  nothing was stripped and this credit stands in their place.
* **BO3 Perk Shaders Pack** — Shadows of Evil styled icons, scoped to Mob of the Dead. Perk shaders
  by **Gewehr**; Double Points, Insta Kill and Fire Sale shaders by **Larsendog**. Eleven perks and
  three powerups are used. The set has no Tombstone, Zombie Blood, Bonfire Sale or Death Machine
  icon, so those four keep their stock art on that map.

# Installing

A mod for [Plutonium](https://plutonium.pw) T6 (Black Ops II).

1. Put the mod folder inside `%LOCALAPPDATA%\Plutonium\storage\t6\mods\`, so you end up with a
   `mods\zm_zombiesplusplus\` folder containing `mod.ff`, `mod.iwd`, `mod.json` and the three `.sabs` /
   `.sabl` sound banks.
2. Launch Plutonium, start Black Ops II in Zombies, and choose **zm_zombiesplusplus** from the mods menu.

Settings live on tabs in the options menu — per-player display options under **HUD**, and
gameplay options under **[MOD RULES](#mod-rules)**. Mod Rules settings are read by the host, so in
co-op the host's choices apply to everyone, and they take effect on the next game rather than
immediately.

Four more decide how a match starts — see [Match](#match). Those sit on the lobby page as well as
on a **MATCH** tab that only appears in the pause menu.

Building the mod from this repository is a separate process — see [BUILDING.md](BUILDING.md).

# Change Notes

## Table of Contents
* [General](#general)
* [Settings](#settings)
	* [Match](#match)
	* [Mod Rules](#mod-rules)
* [HUD](#hud)
* [Players](#players)
* [Zombies](#zombies)
	* [Denizens](#denizens)
* [Weapons](#weapons)
	* [Legacy Weapons](#legacy-weapons)
	* [Pistols](#pistols)
		* [Executioner](#executioner)
		* [KAP-40](#kap-40)
		* [M1911](#m1911)
		* [Mauser C96](#mauser-c96)
		* [Remington New Model Army](#remington-new-model-army)
	* [Assault Rifles](#assault-rifles)
		* [FAL OSW](#fal-osw)
		* [M27](#m27)
		* [M8A1](#m8a1)
		* [MTAR](#mtar)
		* [SCAR-H](#scar-h)
		* [SMR](#smr)
		* [STG-44](#stg-44)
		* [SWAT-556](#swat-556)
		* [Type 25](#type-25)
	* [Submachine Guns](#submachine-guns)
		* [Chicom CQB](#chicom-cqb)
		* [M1927](#m1927)
		* [MP40](#mp40)
		* [MP7](#mp7)
		* [MSMC](#msmc)
		* [Peacekeeper](#peacekeeper)
		* [PDW-57](#pdw-57)
		* [Skorpion EVO](#skorpion-evo)
		* [Vector K10](#vector-k10)
	* [Light Machine Guns](#light-machine-guns)
		* [HAMR](#hamr)
		* [Mk 48](#mk-48)
		* [QBB LSW](#qbb-lsw)
	* [Sniper Rifles](#sniper-rifles)
		* [Ballista](#ballista)
		* [DSR 50](#dsr-50)
		* [XPR-50](#xpr-50)
	* [Shotguns](#shotguns)
		* [Remington 870 MCS](#remington-870-mcs)
		* [Launchers](#launchers)
		* [War Machine](#war-machine)
	* [Specials](#specials)
		* [Ballistic Knife](#ballistic-knife)
		* [Crossbow](#crossbow)
		* [Death Machine](#death-machine)
		* [Storm PSR](#storm-psr)
	* [Wonder Weapons](#wonder-weapons)
		* [Ray Gun](#ray-gun)
		* [Ray Gun Mark 2](#ray-gun-mark-2)
		* [Jet Gun](#jet-gun)
		* [Sliquifier](#sliquifier)
		* [Paralyzer](#paralyzer)
		* [Blundergat](#blundergat)
		* [Acidgat](#acidgat)
		* [Staffs](#staffs)
	* [Tactical Grenades](#tactical-grenades)
		* [Monkey Bomb](#monkey-bomb)
		* [EMP Grenade](#emp-grenade)
		* [Smoke Grenade](#smoke-grenade)
		* [Hell's Retriever](#hells-retriever)
		* [G-Strike Beacon](#g-strike-beacon)
	* [Equipment](#equipment)
		* [Combat Knife](#combat-knife)
		* [Bowie Knife](#bowie-knife)
		* [Silver Spoon](#silver-spoon)
		* [Golden Spork](#golden-spork)
		* [One Inch Punch](#one-inch-punch)
		* [Frag Grenade](#frag-grenade)
		* [Semtex](#semtex)
		* [Claymore](#claymore)
		* [Bouncing Betty](#bouncing-betty)
		* [Syrette](#syrette)
* [Wallbuys](#wallbuys)
* [Mystery Box](#mystery-box)
* [Perks](#perks)
	* [Perk buffs](#perk-buffs)
	* [Jugger-Nog](#jugger-nog)
	* [Quick Revive](#quick-revive)
	* [Speed Cola](#speed-cola)
	* [Stamin-Up](#stamin-up)
	* [PHD Flopper](#phd-flopper)
	* [Deadshot Daiquiri](#deadshot-daiquiri)
	* [Mule Kick](#mule-kick)
	* [Tombstone Soda](#tombstone-soda)
	* [Who's Who](#whos-who)
	* [Electric Cherry](#electric-cherry)
	* [Vulture-Aid](#vulture-aid)
* [Pack-a-Punch](#pack-a-punch)
* [Powerups](#powerups)
	* [Max Ammo](#max-ammo)
	* [Nuke](#nuke)
	* [Carpenter](#carpenter)
	* [Fire Sale](#fire-sale)
	* [Free Perk](#free-perk)
	* [Meat Stink](#meat-stink)
* [Persistent Upgrades](#persistent-upgrades)
* [Buildables](#buildables)
	* [Turbine](#turbine)
	* [Zombie Shield](#zombie-shield)
	* [Turret](#turret)
	* [Electric Trap](#electric-trap)
	* [Subsurface Resonator](#subsurface-resonator)
	* [Trample Steam](#trample-steam)
	* [Head Chopper](#head-chopper)
	* [Acidgat Kit](#acidgat-kit)
	* [Maxis Drone](#maxis-drone)
* [Bank](#bank)
* [NAV Table](#nav-table)
* [Maps](#maps)
	* [Nuketown](#nuketown)
	* [Tranzit](#tranzit)
		* [Bus Depot](#bus-depot)
		* [Diner](#diner)
		* [Farm](#farm)
		* [Power Station](#power-station)
		* [Town](#town)
	* [Die Rise](#die-rise)
		* [Shopping Mall](#shopping-mall)
		* [Dragon Rooftop](#dragon-rooftop)
	* [Buried](#buried)
	* [Mob of the Dead](#mob-of-the-dead)
		* [Cell Block](#cell-block)
	* [Origins](#origins)
		* [Church](#church)
* [Game Modes](#game-modes)
	* [Encounter](#encounter)
		* [Grief](#grief)
		* [Meat](#meat)
		* [Turned](#turned)

## General
* Every game mode is always offered when picking one, including in a solo party
* Map list only offers the start locations the selected game mode actually supports
* Removed round cap
* Removed 5 second wait before match start
* Added restart game button when in online solo game
* Tick rate is always 20
* Increased level of detail at longer distances
* Announcer audio always plays
* In-game menu no longer disabled instantly when the game ends
* Fixed various engine related leaks with entities

## Settings
* Added options to enable or disable new HUD elements
* Added option to enable or disable teammate head icons
* Added option to change action slot area
* Added option to enable or disable fog
* Added option to enable or disable depth of field
* Added option to enable or disable character dialog
* Added option to show your position and angles on the HUD, as a mapping aid

### Match

Four settings decide how a match starts. They sit on the lobby page itself rather than in the
options menu, below Change Map and Change Game Mode, so they can be seen and set on the way into
a match. Only the host sees them, and as with Mod Rules it is the host's choice that applies to
everyone.

The same four are repeated on a **MATCH** tab in the options menu, which appears only while a game
is running. The lobby is unreachable mid-match, so that tab is what shows you which settings the
current game actually started with. Changing one there takes effect on the next game, so the way
to use it is to set the value and restart the level.

| Setting | Options | Ships as | Vanilla |
| --- | --- | --- | --- |
| Start round | 1, 5, 10, 15, 20, 25 | 1 | — |
| Start points | 0, 500, 1000, 1500, 2000, 2500, 5000, 10000 | 500 | — |
| Perk purchase limit | 1, 4, 5, 6, Unlimited | 4 | 4 |
| Hit down | 2, 3, 5 | 3 | 2 |

* **Start points** sets your score to the chosen figure rather than adding to it, so `0` takes
  away the points you normally start with. `500` means "leave it alone" — the stock starting score
  is not always exactly 500, since persistent upgrades and some game modes move it.
* **Hit down** is how many zombie hits it takes to be downed without Jugger-Nog. Health is 50 per
  hit against a zombie's 60 damage, so `2` is stock's 100, `3` is 150 and `5` is 250. Jugger-Nog
  adds two more hits on top of whatever this is set to — 200, 250 and 350 respectively — so it is
  worth the same amount at every setting.
* **Perk purchase limit** caps how many perks you can *buy*. Perks given to you — powerup drops, dig
  rewards, perk bottles — ignore it, so you can end up holding more than the limit. `Unlimited` is
  the twelve perks in the game rather than a flag, so the cap can never be reached.

### Mod Rules
A second options tab holding the gameplay settings, separate from the HUD settings above. These are
read by the game rather than by each client, so in co-op the host's settings apply to everyone, and
they take effect on the next game rather than immediately. Fog at the top of the tab is the one
exception: it is a client setting that applies immediately, for the player who changed it only.

Two labels mark the choices worth knowing about. `VANILLA (…)` is the setting that matches stock
Black Ops 2, and `DEFAULT (…)` is the value the fork ships with. A choice never carries both — where
the two coincide it reads `VANILLA`, since that is the more useful fact when you are changing things.
Anything unlabelled is neither. Settings that stock has no equivalent for at all carry only
`DEFAULT`, since no choice there can be said to match vanilla.

| Setting | Options | Ships as | Vanilla |
| --- | --- | --- | --- |
| Perk drop rate | None, Rare, Normal, Extra, Crazy | Normal | None |
| Perk buffs | Vanilla, Enhanced | Enhanced | Vanilla |
| Zombie Shield health | Vanilla, Rebalanced | Rebalanced (250) | Vanilla (150 or 225 by map) |
| Carpenter behavior | Default, BO4 | BO4 | Default |
| Max Ammo behavior | Default, BO4 | BO4 | Default |
| Legacy box guns | Disabled, Enabled | Enabled | Disabled |
| Fog | Disabled, Enabled | Enabled | Enabled |
| Fire sale music | Default, Randomized | Randomized | Default |

Where the behaviour is not obvious from the name:

* **Perk drop rate** controls how often the perk bottle powerup appears. Every powerup gets one
  slot in the shuffle, so taking that slot every single time still caps the bottle at one drop in
  seven on Nuketown's pool. Rare and Normal are fractions of that slot; Extra and Crazy go past
  the cap by also claiming a share of slots that drew something else:

  | | Its own slot | Other slots | Roughly, of all drops |
  | --- | --- | --- | --- |
  | None | never | — | 0% |
  | Rare | a quarter | — | ~4% |
  | Normal | half | — | ~7% |
  | Extra | always | 20% | ~31% |
  | Crazy | always | 40% | ~49% |

  A bottle that fails its check is replaced by the next powerup rather than nothing dropping, so
  rarity changes the mix rather than how much drops.
* **Carpenter behavior** and **Max Ammo behavior** pick between what the powerup does in stock
  Black Ops 2 and its Black Ops 4 version — Carpenter repairing your Zombie Shield, and Max Ammo
  refilling the magazine in your weapon as well as your reserve. Both ship on `BO4`, so `DEFAULT`
  here means stock Black Ops 2 rather than the value the fork defaults to.
* **Perk buffs** switches the perks between the fork's enhanced versions and what they do in
  stock. See [Perk buffs](#perk-buffs) for exactly what changes.
* **Zombie Shield health** is a flat 250 on every map under Rebalanced. Vanilla is left alone rather than
  pinned to one figure, because stock varies by map — 225 on Tranzit, Die Rise and Buried, 150
  on Mob of the Dead and Origins — which is why that option carries no number.

  These are a tenth of the internal values (2500, 2250, 1500). The HUD shows the tenth so the
  shield number sits on the same scale as your health instead of dwarfing it; durability is
  unchanged.
* **Legacy box guns** returns the Black Ops 1 weapons to the Mystery Box — see
  [Legacy Weapons](#legacy-weapons).
* **Fire sale music** on Default plays the stock track, which the game picks based on whether
  Richtofen or Maxis is the announcer. Randomized draws a different track each Fire Sale.

## HUD
* Replaced the crosshair with a higher resolution version
* Enemy counter displayed on top left of screen
* Timer displayed on top right of screen
* Health bar displayed on bottom left of screen
* Zone name displayed on bottom left of screen
* Added custom ammo display on Tranzit, Nuketown, and Die Rise
* Character name displayed on all maps
* Character name fades out after 15 seconds on all maps
* Weapon name is capitalized on all maps
* Weapon name is the same text size on all maps
* Weapon name and ammo no longer fade out
* Grenade icons no longer fade based on how many the player currently has
* Ammo counter no longer shows while scoped on all maps
* Added round chalk images from Mob of the Dead to all maps
* Added proper game mode and map name to scoreboard
* Added icons on scoreboard when player is down, bled out, in Who's Who mode, in afterlife, or has the meat
* Changed player name color on scoreboard to match the player's color
* Moved voice chat icon on scoreboard to the end of the player name column
* Changed Classic faction color from blue to grey
* Changed CIA faction color from grey to blue
* Added teammate head icons
* Decreased waypoint size
* Increased waypoint offset from top and bottom of screen
* Added new revive waypoint icon
* All waypoint arrows move when offscreen
* All waypoints fade when targeted
* Revive waypoints move to center of screen for the player who is reviving
* Revive waypoints no longer show at incorrect position when they first appear
* Bleed out bar displayed when down
* Revive bar displayed for down player
* Changed revive bar color to blue
* Player is reviving you text gets removed instantly when player drops the revive
* Player needs to be revived text updates to new player instantly
* Changed need power hint string from "You must turn on the Power first!" to "Power must be turned on" on all maps
* Changed need local power hint string from "You'll need a source of power!" to "Power must be turned on" on all maps
* Increased number of times that the round number pulses between rounds from 2-7 to 10 (same as Black Ops 1)
* Fixed powerup move animation being incorrect
* Fixed low clip ammo pulse being out of sync after switching to another low ammo weapon
* Fixed scoreboard showing incorrect team on Survival after restart
* Removed NAV cards

## Players
* Increased health from 100 to 150 — configurable with **Hit down**, see [Match](#match)
* Self revives in solo are active whenever the player has at least 1 perk
* Upgraded starting weapon given as self revive weapon above all others except Ray Gun Mark 2
* Increased backwards move speed from 70% to 100%
* Increased strafing move speed from 80% to 100%
* Decreased sprint time needed to be able to dive from 0.25 seconds to 0.1 seconds
* Can move immediately after diving
* Can dive again immediately after diving
* Increased melee range by 16% (same as Black Ops 1)
* Disabled meleeing while doing falling hands anim
* Removed ammo counter while doing falling hands anim
* Can look up and down 90 degrees (normally 85 degrees)
* Changed low health threshold from 20% of player's max health to 50 health
* Decreased normal health regeneration delay from 2.4 seconds to 2 seconds
* Normal health regeneration rate is no longer instant
* Changed health regeneration rate to 100 health per second (normally fully restored health in 0.5 seconds)
* Fall damage no longer increases when max health is increased
* Fall damage no longer makes the player stop sprinting
* Added blood fx when taking damage and at low health
* Removed blur after taking damage
* Removed shellshock from explosive damage
* No longer killed when landing on top of another player
* Ignored by zombies for 1 second after being revived
* Disabled meleeing while reviving (except if player switches weapons)
* Pressing fire button while reviving no longer switches weapons
* Weapon is no longer switched after reviving if player switched weapons during revive
* No longer gain points back on self revives
* Respawn near a random player (normally respawn near the same player every time)
* No longer spawn in for a second when joining mid game
* Can activate triggers while switching weapons
* Can shoot while looking at other players
* Increased mantle speed
* Increased ladder climb speed
* Move direction on ladders no longer based on player view angles
* Disabled leaning
* Start with Semtex on maps that have Semtex
* Upgraded weapon camo is applied in last stand
* Dual wield last stand weapon is switched to when ammo is only in left clip
* Decreased friendly player overhead name fade out time from 1.5 seconds to 0.25 seconds
* Removed enemy player overhead name fade in time
* Fixed being able to open doors when player is not valid
* Fixed view model, player models, and zombie models flickering when there are many players and zombies nearby
* Fixed last stand vision being changed when another player downs
* Fixed revive hint string showing when another player drops the revive
* Fixed certain player anims
* Fixed being able to start reviving a player on the same frame that another player stopped reviving that player
* Fixed not being revived instantly by instant revive sources if another player was reviving
* Fixed randomization for teams on Survival

## Zombies
* Health capped at 100,000
* Decreased player damage from 60 to 50
* Changed height to 60 (normally either 48 or 72)
* Increased damage taken to make a crawler from 10% of current health to 25% of current health
* Amount of zombies scales linearly with the amount of players
* Zombies that bleed out and respawn no longer keep their previous health
* Zombies that are deleted due to being too far away always respawn
* Attracted towards points of interest immediately
* Removed walkers in high rounds
* Removed headless zombies
* Neck counts as headshot
* All body shot kills award 50 points
* Loud vocals only play for last zombie of the round
* 4 round and 5 round special rounds happen more equally
* Fixed not being able to drop powerups after doing certain traversals

### Denizens
* Decreased health from 200 to 150
* Decreased number of melees to kill from 5 to 3
* Decreased number of melees to kill with Bowie Knife from 3 to 2
* Decreased number of melees to kill with Galvaknuckles from 2 to 1
* No longer automatically run away when player is first attacked in solo
* Removed hint when player is first attacked in solo

## Weapons
* Switch to melee weapon by pressing the Melee Weapon button (same button as Time Bomb and Maxis Drone)
* Added alt weapon names on HUD
* Added camo to all attachments
* Added proper melee swing sound to all melee weapons
* Ammo gets added to the clip at the same time that it gets added in the reload anim on all weapons
* Removed aim spread on all weapons (except shotguns)
* Fixed world model position of certain melee weapons
* Fixed projectile angles of certain grenades and projectile weapons
* Fixed alt weapons being switched from when trading weapons
* Fixed burst fire weapons shooting when pressing aim button while fire button is already pressed
* Bullet weapons: can penetrate through any amount of entities (normally capped at 5, still decreases damage each time it penetrates)
* Projectile weapons: changed projectile weapon damage scalar to 50 multiplied by round number (normally random number between 0 and 100 multiplied by round number)
* Projectile weapons: capped projectile weapon damage scalar at 3000
* Grenades: improved projectile upward speed
* Grenades: can no longer be thrown faster than intended by throwing a grenade right after throwing one
* Grenades: changed damage scalar to 25 multiplied by round number (normally random number between 100 and 200 added by round number)
* Grenades: capped damage scalar at 1500
* Placeable mines: changed damage scalar to 150 multiplied by round number (normally random number between 100 and 200 multiplied by round number)
* Placeable mines: capped damage scalar at 9000
* Placeable mines: player hit audio no longer plays

### Legacy Weapons
Black Ops 2 replaced a number of Black Ops 1 weapons with its own equivalents, and the base game
dropped the originals from the Mystery Box. The **Legacy box guns** setting puts them back without
removing their replacements, so the box holds both. The setting can be turned off from the RULES
tab, and with it off every map keeps exactly its stock weapon list.

| Legacy weapon | Replaced in Black Ops 2 by | Returns on |
| --- | --- | --- |
| Galil | M27 | All maps |
| FAL | FAL OSW | All maps |
| M14 | Saritch | All maps |
| Barrett M82A1 | XPR-50 | All maps |
| M1911 | Not replaced — it is the starting pistol | Origins |
| MP5 | INSAS | All maps |
| AK74u | Vector | All maps |
| M16A1 | SIG556 | All maps |
| Olympia | Remington 870 MCS | All maps |
| Python | Executioner | All maps except Buried |
| RPD | Mk 48 | All maps except Buried |

Most of these only shipped on some maps. Where a gun was missing from a map entirely — the RPD and
Python on Mob of the Dead, the Barrett, MP5, M1911 and Olympia on Origins, the M16A1 on both — the
mod links the weapon in and registers it, so it now appears wherever the setting is on. The RPD and
Python are the two exceptions: Buried never carried either.

The MP5, AK74u, M16A1, M14 and Olympia were wallbuy-only weapons, and the mod swaps their
wallbuys for their replacements — returning them to the box is what makes them obtainable again at
all. The M16A1 upgrades to the M16A1 GL.

The M1911 is the exception. Every map that carries it already hands it to you as the starting
pistol, so the box only offers it on Origins, which starts on the Mauser C96 and never shipped an
M1911 at all.

### Pistols

#### Executioner

#### KAP-40
* Removed delay between last shot and reload

#### M1911
* Upgraded: decreased stock ammo from 50 to 48
* Upgraded: decreased last stand ammo from 2 clips to 1 clip

#### Mauser C96
* Upgraded: increased move speed while aiming from 100% to 110%
* Upgraded: decreased last stand ammo from 2 clips to 1 clip
* Upgraded: fixed not being able to melee while aiming
* Upgraded: added proper fire sound
* Upgraded: added empty fire sound

#### Remington New Model Army
* Upgraded: added proper fire sound

### Assault Rifles

#### FAL OSW

#### M27

#### M8A1
* Added on Buried

#### MTAR
* Upgraded: changed attachment from Reflex Sight to EOTech Sight

#### SCAR-H
* Upgraded: changed attachment from Reflex Sight to ACOG Sight

#### SMR
* Replaces M14
* Unupgraded: increased damage from 80 to 100
* Unupgraded: decreased clip ammo from 20 to 10
* Unupgraded: decreased stock ammo from 140 to 100
* Upgraded: increased damage from 120 to 160
* Upgraded: increased headshot multiplier from 4 to 4.5
* Upgraded: decreased clip ammo from 30 to 20
* Upgraded: decreased stock ammo from 420 to 200

#### STG-44
* Upgraded: decreased stock ammo from 330 to 300
* Upgraded: changed weapon name from "Spatz-447 +" to "Spatz-447"

#### SWAT-556
* Replaces M16A1

#### Type 25
* Added on Buried
* Decreased recoil

### Submachine Guns

#### Chicom CQB
* Added on Buried
* Unupgraded: decreased clip ammo from 40 to 36
* Unupgraded: increased stock ammo from 120 to 252
* Upgraded: increased clip ammo from 40 to 48
* Upgraded: increased stock ammo from 200 to 336
* Upgraded: changed attachment from None to Select Fire

#### M1927

#### MP40

#### MP7
* Added on Nuketown, Tranzit, Die Rise, and Buried

#### MSMC
* Replaces MP5

#### Peacekeeper
* Added on Nuketown, Mob of the Dead and Origins — the maps with no weapon locker

#### PDW-57
* Upgraded: changed weapon name from "57000" to "5700"

#### Skorpion EVO
* Upgraded: changed attachment from Reflex Sight to Fast Mag

#### Vector K10
* Replaces Ak74u

### Light Machine Guns

#### HAMR

#### Mk 48
* Also added on Buried

#### QBB LSW
* Added on Mob of the Dead and Nuketown

### Sniper Rifles

#### Ballista
* Replaces Olympia
* Unupgraded: increased damage from 150 to 250
* Unupgraded: decreased clip ammo from 8 to 6
* Unupgraded: decreased stock ammo from 64 to 60
* Upgraded: increased damage from 400 to 500
* Upgraded: decreased headshot multiplier from 10 to 8
* Upgraded: decreased stock ammo from 120 to 100
* Upgraded: increased amount of primary camo
* Upgraded: added proper fire sound

#### DSR 50
* Upgraded: fixed first raise anim

#### XPR-50

### Shotguns
* Increased penetration

#### Remington 870 MCS
* Changed weapon cost from 900 or 1500 to 1200 on all maps


### Launchers

#### War Machine
* Unupgraded: increased stock ammo from 18 to 24
* Unupgraded: grenades explode on impact

### Specials

#### Ballistic Knife
* Added model and anims from Black Ops 2 Multiplayer
* Added sounds to all maps
* Increased melee time from 0.5 seconds to 0.7 seconds
* Held with Galvaknuckles
* Projectiles are no longer destroyed when other players walk over them
* Projectiles are no longer destroyed when purchasing a melee wallbuy
* Projectiles get destroyed by lava
* Projectiles can be picked up while the weapon is not reloaded
* Projectiles can be picked up while the player is not on the ground
* Upgraded: increased melee damage with Galvaknuckles from 1500 to 2000

#### Crossbow
* Added on Origins

#### Death Machine
* No longer spins up by pressing aim button
* No longer spins up while not idle

#### Storm PSR
* Added on Tranzit
* Kills on any round fully charged
* Infinite penetration

### Wonder Weapons

#### Ray Gun
* Added model from Buried to all maps
* Added first raise and empty fire sounds from Mob of the Dead to all maps
* Decreased volume of empty fire sound
* Unupgraded: increased impact damage from 1000 to 1500 (same as max splash damage)
* Upgraded: increased impact damage from 1000 to 2000 (same as max splash damage)

#### Ray Gun Mark 2
* Added empty fire sound from Ray Gun
* Same probability to obtain as other weapons
* Can be obtained if player has Ray Gun
* Limited to 1 player on all maps
* Decreased last stand ammo from 3 clips to 1 clip
* Unupgraded: increased stock ammo from 162 to 168
* Upgraded: increased stock ammo from 201 to 210
* Upgraded: added secondary camo

#### Jet Gun
* Pulls in zombies from far away
* Kills all zombies that are close by immediately
* Kills zombies that are in the ground, traversing, or behind barriers
* Awards points for kills
* Cools down twice as fast
* Cools down while not holding weapon
* No longer spins up while not idle
* No longer kills while not firing
* No longer changes player vertical velocity while firing
* No longer automatically switched to weapon when picked up
* No longer disassembles when overheated
* Weapon is taken when overheated and continuing to fire for 1.5 seconds
* Weapon plays an alarm sound when overheated and continuing to fire
* Pulls in powerups more frequently
* Pulls in powerups twice as fast
* Added heat percentage on HUD
* Changed weapon name from "Thrustodyne Aeronautics Model 23" to "Jet Gun"
* Fixed spin dial, spin anim, and spin sounds being inaccurate
* Fixed HUD icon fading after firing

#### Sliquifier
* Added upgraded version
* Kills on any round (normally stops killing after round 100)
* Decreased stock ammo from 40 to 20
* Removed additional goo created by chain kills
* Continues to chain while not holding weapon
* Removed player damage
* Upgraded: increases slippery spot duration by 50%
* Upgraded: increases chain explosion radius by 50%

#### Paralyzer
* Kills on any round
* Decreased player fly duration
* Added heat percentage on HUD
* Fixed zombie spawn delay after zombie being killed

#### Blundergat
* Kills on any round in 1-2 shots
* Infinite penetration
* Increased pellet count from 7 to 8
* Increased pellet impact size
* Unupgraded: decreased stock ammo from 60 to 30
* Upgraded: decreased stock ammo from 120 to 60
* Upgraded: added camo

#### Acidgat
* Kills on any round in 1-2 bursts
* Increased player damage from 10 to 15
* Increased move speed while aiming from 100% to 200% (same as Blundergat)
* Decreased explosion radius by 50%
* Increased projectile count from 3 to 4
* Projectiles fire all at once
* Projectiles fire in a straight line
* Projectiles no longer seek toward zombies
* Added projectile indicator
* Removed projectile upward speed
* Deadshot Daiquiri improves accuracy
* Stuck zombie counts as a kill
* Unupgraded: decreased stock ammo from 30 bursts to 15 bursts
* Unupgraded: changed weapon name from "Acid Gat" to "Acidgat"
* Upgraded: increased clip ammo from 1 burst to 2 bursts
* Upgraded: decreased stock ammo from 50 bursts to 30 bursts
* Upgraded: increased max splash damage from 1000 to 2000
* Upgraded: increased min splash damage from 500 to 1000
* Upgraded: added camo
* Upgraded: added proper fire sound

#### Staffs
* Upgrade only requires collecting souls in The Crazy Place
* Can collect souls in The Crazy Place after upgrading to recharge (fills 5% of max ammo per soul)
* Can no longer collect souls in The Crazy Place from staff kills
* Picking up a staff in The Crazy Place while holding a staff places the other staff in The Crazy Place
* Insterting a staff in The Crazy Place requires player's current weapon to be the staff
* Fixed triggers for inserting and picking up staffs in The Crazy Place
* Fixed being able to carry multiple staffs by picking up a staff with staff revive weapon out
* Get full ammo when initially picked up after upgrading (normally missing one clip)
* Max ammo no longer fills clip ammo
* Upgraded: kill on any round
* Upgraded: no longer charges up while not idle
* Upgraded: fire button no longer has to be re-pressed to start charging if fire button was pressed before charging was ready
* Upgraded: weapon is switched when attempting to fire while having no ammo
* Upgraded: charged shots damage Panzersoldat
* Upgraded: decreased alt weapon fire time from 3 seconds to 0.5 seconds
* Upgraded: changed alt weapon fire type from full auto to single shot
* Upgraded: charge loop sound stops playing immediately after firing
* Upgraded: fixed charge sounds not playing after firing a charge level 1 shot
* Fire: projectiles fire all at once
* Fire: projectiles fire in a straight line
* Fire: decreased spread between projectiles by 50%
* Fire: awards points for damage
* Fire: decreased kill points from 60 to 50
* Fire upgraded: increased charge level 2 projectile count from 2 to 3
* Fire upgraded: increased charge level 3 lava duration from 5 seconds to 7.5 seconds
* Fire upgraded: decreased charge level 3 lava damage radius by 20% (same as charge level 2)
* Fire upgraded: plays smaller explosion fx at end of lava
* Fire upgraded: charged shots no longer deal additional damage to Panzersoldat
* Fire upgraded: fixed lava not being created if the player fired the charged shot on a wall or too close to themselves
* Ice upgraded: fixed melee sound
* Lightning upgraded: decreased clip ammo from 18 to 15
* Lightning upgraded: decreased stock ammo from 180 to 150
* Lightning upgraded: decreased kill points from 100 to 50
* Wind: awards points for damage
* Wind unupgraded: decreased stock ammo from 40 to 30
* Wind upgraded: whirlwind pulls in multiple zombies significantly faster
* Wind upgraded: whirlwind stops pulling in zombies when the whirlwind fx starts to end instead of when the whirlwind fx completely ends
* Wind upgraded: fixed whirlwind not being created and impact blast radius being incorrect if the player started reloading or throwing a grenade in between the time that the charged shot was fired and impacted a surface

### Tactical Grenades

#### Monkey Bomb
* Added model and HUD icon from Buried to all maps
* Zombies killed can drop powerups
* Fixed an issue where a Monkey Bomb wouldn't activate if the previously thrown Monkey Bomb hadn't activated yet

#### EMP Grenade
* Added bounce sounds and shellshock from Black Ops 2 Multiplayer
* No longer disables HUD
* Disables player's perks for 12 seconds
* Increased ammo from 2 to 3
* Increased throw time from 1 second to 1.35 seconds (same as Black Ops 2 Multiplayer)
* Decreased projectile speed by 30% (same as Black Ops 2 Multiplayer)
* Decreased zombie EMP radius by 17% (same as Black Ops 2 Multiplayer)
* Increased perk machine EMP radius by 22% (same as Black Ops 2 Multiplayer)
* Decreased perk machine EMP time from 90 seconds to 60 seconds
* Can be cancelled while holding
* Added fx to EMP'd players
* Can destroy deployed Zombie Shields
* EMP's all zombies instantly
* Increased min zombie EMP time from 0.1 seconds to 1 second
* Sprinting no longer wakes up EMP'd zombies
* Zombies that are in the ground can no longer get EMP'd
* Fixed throw anim
* Fixed an issue where zombies would sometimes not wake up from firing projectile weapons

#### Smoke Grenade
* Added on Mob of the Dead
* Kills on any round

#### Hell's Retriever
* No longer ricochets to other zombies when not charged
* Each charge exponentially increases total zombies attacked (3 -> 6 -> 10)
* Unupgraded: changed damage to 2000 (normally does 1000-2000 damage based on number of charges)
* Upgraded: kills on any round when not charged

#### G-Strike Beacon
* Kills on any round
* Increased ammo from 2 to 3
* No longer attracts after all missiles explode

### Equipment

#### Combat Knife
* Added model from Black Ops 2 Multiplayer

#### Bowie Knife
* Flipped HUD icon

#### Silver Spoon
* Decreased damage from 1100 to 1000

#### Golden Spork
* Decreased damage from 10000 to 5000

#### One Inch Punch
* Deals same damage at any range
* Decreased range by 4% (exactly 50% more range than normal melee)
* Unupgraded: increased damage from 2250 to 2500
* Upgraded: decreased damage from 11275 to 10000
* Upgraded: elemental punch changes based on which staff the player currently has
* Upgraded: uses melee lunge anim as normal melee anim
* Wind: knocks down zombies that are damaged
* Wind: no longer increases range
* Fixed occasionally not killing zombies that were in range
* Fixed players gaining damage score multiple times
* Fixed zombies not being flung when Insta Kill powerup is active
* Fixed an issue where a player's melee weapon wouldn't reset if the player bled out in the Giant Robots

#### Frag Grenade
* Replaces Semtex on Origins

#### Semtex
* Replaces Frag Grenade on Mob of the Dead

#### Claymore
* Added plant and alert sounds to all maps
* Can be repurchased
* Can be placed while in the air
* Increased explosion radius by 28% (same as Black Ops 2 Multiplayer)
* Increased max amount that can be placed from 12 to 20
* Added weapon name on HUD
* Removed initial weapon raise anim

#### Bouncing Betty
* Replaces Claymore on Origins

#### Syrette
* Added weapon name on HUD
* Fixed being able to see view model at end of anim

## Wallbuys
* Purchasing ammo refills clip ammo
* Increased trigger radius
* Decreased upgraded ammo cost from 4500 to 2500
* Ammo can be purchased if only alt weapon ammo has been used
* Purchasing no longer shows the weapon model at other wallbuys of the same weapon
* Melee weapons are given instantly when purchased
* Changed all hint strings from "to buy" to "for"
* Lethal grenade hint string no longer displays "ammo" after purchasing
* Increased brightness of wallbuy chalks
* Added melee wallbuy HUD icons to all maps

## Mystery Box
* Players only see weapons rising up that they can currently obtain
* Decreased weapon pick up time from 12 seconds to 9 seconds
* Moves to new location instantly
* Legacy box guns setting returns the Black Ops 1 era weapons to the box (see [Legacy Weapons](#legacy-weapons))
* Teddy bear shows at correct angles when it first appears
* No longer disappears then reappears at end of Fire Sale if Fire Sale started while Mystery Box was moving

## Perks
* Added high quality perk icons, used on every map except Nuketown and Mob of the Dead, which have their own sets (see [Credits](#credits))
* Removed the cap on how many perks a player can hold — perks given for free can take you past it. Buying is still capped, by the perk purchase limit, see [Match](#match)
* No longer deactivated if the perk machine is powered off
* Perk order on HUD is restored whenever perks are restored to the player
* Perk order on HUD is shown correctly when spectating
* Fixed perk machine bump sound continuously playing when player is down

### Perk buffs
The **Perk buffs** setting on the [Mod Rules](#mod-rules) tab switches these between the fork's enhanced
behaviour and stock. Everything else on the perks below — bug fixes, icons, machine placement,
Tombstone and Who's Who mechanics — is unaffected by the setting and always applies.

| Perk | Enhanced | Vanilla |
| --- | --- | --- |
| Speed Cola | Also switches weapons and throws grenades twice as fast | Faster reload only |
| Stamin-Up | Unlimited sprint, and 2% faster movement | Longer sprint, no speed bonus |
| Deadshot Daiquiri | Double headshot damage, double ADS speed, faster movement while aiming, quicker sprint recovery | Aim assist and reduced ADS spread only |
| Quick Revive | Health regeneration delay cut by a third | No effect on regeneration |

Stamin-Up is worth a note: the fork registers it as `specialty_movefaster` rather than stock's
`specialty_longersprint`, so on Vanilla the sprint extension is granted explicitly. Without that it
would end up weaker than stock rather than equal to it.

### Jugger-Nog
* Adds 100 maximum health, two hits' worth, on top of the [Hit down](#match) setting instead of
  setting it to a flat 160 — so the perk is worth the same two hits whatever the base is
* Upgraded keeps stock's 30-point lead over the base perk, so it adds 130
* Increases current health by 100 upon purchase (normally sets current health to max)

### Quick Revive
* Increased cost in solo from 500 to 1500
* Decreases health regeneration delay by 33%
* Changed hint string from "Revive" to "Quick Revive"

### Speed Cola
* Switch weapons twice as fast
* Throw grenades twice as fast

### Stamin-Up
* Unlimited sprint (normally only increases sprint duration)
* Move 2% faster

### PHD Flopper
* Added perk bottle model from Origins to all maps
* Deals same damage on all maps
* Damages all zombies at once on all maps
* Players no longer take damage from fire zombie death explosions
* Players no longer take 1 damage from falling when not diving
* Fixed player hit audio playing from explosive damage

### Deadshot Daiquiri
* Added perk bottle model from Origins to all maps
* Increases bullet headshot damage by 100%
* Aim twice as fast
* Move faster while aiming
* Decreases sprint recovery time
* Fixed not decreasing aim spread

### Mule Kick
* Added additional weapon indicator
* Additional weapon is given back when perk is reacquired
* Removed bottom part of perk machine model

### Tombstone Soda
* Added in solo and Encounter
* Powerup no longer removed when player is revived
* Powerup removed when player is down after being revived or respawning
* Unlimited time to pick up powerup
* Changed perk machine light fx from Speed Cola's fx to Quick Revive's fx
* Changed powerup fx color to blue
* Powerup gets destroyed by EMP Grenades
* Powerup can be pulled in by Jet Gun
* Restores all weapons properly
* Disabled suicide option when player is down
* Added powerup waypoint
* Flipped perk icon
* Changed hint string from "Tombstone" to "Tombstone Soda"

### Who's Who
* Keep weapons when entering Who's Who mode
* Keep any perks obtained in Who's Who mode when exiting Who's Who mode
* Self revives in solo always activate when downing during Who's Who mode
* Decreased Who's Who mode duration from 45 seconds to 30 seconds
* Ignored by zombies for 1 second after entering Who's Who mode
* Invulnerable for 2 seconds after entering and exiting Who's Who mode
* Controls are frozen for 0.5 seconds after entering and exiting Who's Who mode
* Clone spawns facing the same angles as the player down
* Player spawns facing towards the clone when entering Who's Who mode
* Purchasing Who's Who in Who's Who mode no longer destroys the clone
* Downing with Who's Who in Who's Who mode destroys the clone
* Added Who's Who mode duration bar on HUD
* Changed revive waypoint icon to Who's Who perk icon
* Revive waypoint shows offscreen
* Fixed an error that would crash the game when entering Who's Who mode

### Electric Cherry
* Stuns all zombies instantly
* Removed cooldown after being used multiple times in a row
* Last stand activation kills on any round
* Decreased radius of last stand activation by 48.8%
* No longer awards points when player is down
* Fixed last stand activation fx playing incorrectly

### Vulture-Aid
* Stink areas no longer activate while the player is moving

## Pack-a-Punch
* Attachments on weapons can no longer be changed
* Reticles on optical attachments are no longer random
* Decreased weapon pick up time from 15 seconds to 12 seconds
* Added sound when attempting to purchase without enough points
* Increased volume of sounds to be the same on all maps

## Powerups
* Increased time on the ground from 26.5 seconds to 30 seconds
* Grabbing time based powerups that are already active add to timer instead of resetting timer
* Fx plays when a powerup drops if it is the last powerup of a cycle

### Max Ammo
* Sets heat weapons to 0% heat
* Fills the magazine as well as the reserve ammo, so no reload is needed

### Nuke
* Kills all zombies instantly

### Carpenter
* Added on Nuketown, Mob of the Dead, and Origins
* Restores full health to a carried shield
* Nuketown has no windows to board, so it drops there only while a player is carrying a shield

### Fire Sale
* Added on Tranzit and Die Rise

### Free Perk
* Added as a random drop in Survival and Classic on all maps (normally only drops from leapers, ghosts, and denizens)
* In Classic, does not start dropping until a player has 4 perks at once
* Drops about half as often as the other powerups
* Can give perks that have no machine on the map, instead of only perks with a machine
* Nuketown: can also give Stamin-Up and Mule Kick

### Meat Stink
* Added pick up, throw, and land sounds to all maps
* Zombies are attracted towards player holding the meat
* 75% move speed while holding the meat
* Take 50 damage per second if stationary while holding the meat
* Decreased throw speed by 25%
* Player who threw the meat can meat themself
* Attracts zombies more consistently on ground
* Decreased attract radius on ground by 50%
* Decreased time on ground from 15 seconds to 10 seconds
* Decreased time on players from 30 seconds to 20 seconds
* Bounces off walls when thrown
* Added weapon name on HUD
* Added weapon glow fx
* Changed powerup fx color to blue
* Able to drop when players are down
* No longer able to drop when another meat powerup is already dropped
* Can be picked up while reviving
* Meleeing while the meat is moving no longer grabs the meat
* Gets destroyed when thrown on lava
* Removed unused pick up trigger that is visible when the meat is in the air
* Message shows when the meat is grabbed, thrown, and landed on a player
* Replaced with Head on Mob of the Dead and Origins locations

## Persistent Upgrades
* Removed

## Buildables

### Turbine
* Rotated held model 90 degrees

### Zombie Shield
* Added shield health bar on HUD
* Awards points for kills and damage
* Kills pay the base 50, the same as a body shot, rather than the 130 a melee kill normally
  earns — the shield kills far too easily for the melee rate to be right
* Zombies that are on fire no longer explode on death
* Can be destroyed by player damage when deployed
* Destroyed sound plays when player is holding
* Deployed damage sound plays on shield instead of player
* Switches back to correct weapon after deploying

### Turret
* No longer needs to be powered by a Turbine
* Gets destroyed after firing for 30 seconds
* Kills on any round in 1-4 shots (normally does 1200 damage max)
* Improved targeting
* No longer arcs downward
* No longer damages players
* Fixed an issue where the Turret would take damage from fire zombie death explosions
* Fixed an issue where the Turret sounds would continue playing after being picked up

### Electric Trap
* No longer needs to be powered by a Turbine
* Gets destroyed after being deployed for 30 seconds
* Kills on any round (normally stops killing after round 50)
* Kills zombies instantly
* Zombies that are on fire no longer explode on death
* No longer kills players without Jugger-Nog instantly
* Decreased player damage from 75 to 25
* Decreased player shellshock time from 2.5 seconds to 1.25 seconds
* Decreased startup time from 2 seconds to 0.5 seconds

### Subsurface Resonator
* No longer needs to be powered by a Turbine
* No longer gets destroyed from kills
* Gets destroyed after being deployed for 30 seconds
* Fires every 2 seconds (normally has a longer delay depending on the amount of kills from the previous fire)

### Trample Steam
* No longer gets destroyed from kills
* Gets destroyed after activating 15 times
* Does fast cooldown when player activates
* Fixed an issue where players were not flung correctly when activating the Trample Steam while in the air

### Head Chopper
* No longer gets destroyed from kills
* Gets destroyed after activating 10 times
* Does multiple swings when player activates
* Kills zombies when placed on a ceiling
* Increased damage trigger width by 100%
* No longer deals damage during retract anims
* Changed head chop player damage to 50 (normally instantly kills without Jugger-Nog or deals 15 damage with Jugger-Nog)
* Changed body chop player damage to 25 (normally deals 75 damage to torso or 37 damage to feet)
* Fixed an issue where each chop would only damage entities that were touching the damage trigger during the previous chop

### Acidgat Kit
* Player does knuckle crack anim during conversion
* Requires player's current weapon to be the Blundergat to convert
* Requires player to be looking at the buildable table to convert
* Changed craft hint string from "Blundergat Upgrade" to "Acidgat Kit"
* Changed pick up hint string from "take your converted weapon" to "take Acidgat"
* Fixed buildable table not showing locked hint string

### Maxis Drone
* Kills on any round in 1-4 shots (normally does 12000 damage max)
* Decreased active time from 90 seconds to 60 seconds
* Decreased cooldown time from 60 seconds to 30 seconds
* Added HUD message for how to activate
* Buildable table model sits on top of the stand
* Rotated buildable table model 90 degrees
* Can no longer switch weapons or sprint while deploying
* Switches back to correct weapon after deploying

## Bank
* No longer costs 100 points to withdraw
* No longer costs 100 points to trade points with the teller
* Account balance displayed while at the deposit or withdraw trigger

## Weapon Locker
The locker is shared by Tranzit, Die Rise and Buried, and the weapon you leave in it travels between
them, so it only accepts guns all three maps carry — otherwise the slot fills with something the
other maps refuse to hand back.

* Only stores weapons available on Tranzit, Die Rise and Buried
* Turned away: the Jet Gun, Sliquifier and Paralyzer, each of which exists on one map only, plus the
  LSAT, Metal Storm, Python, Remington New Model Army and RPD
* The Ray Gun and Ray Gun Mark 2 were already refused, as the base game bars limited weapons
* Stored weapons persist through profile storage, so the exact gun comes back between matches

## NAV Table
* Costs 100,000 points
* Ends the game

## Maps
* All locations can be played on all game modes
* All quests can be completed with any amount of players
* All quests give players all perks on completion
* All quests play a song on completion after ending the current round

### Nuketown
* Added PHD Flopper, Deadshot Daiquiri, Stamin-Up and Mule Kick machines, dropped from the sky like the others
* Machines arrive roughly every 2 rounds rather than every 5, so all 9 — the eight perk machines and Pack-a-Punch — have landed by round 19
* Replaced the Backyard Mystery Box location with a buildable bench
* Added Zombie Shield, built at the Backyard bench from 2 parts that spawn around the map
* Hellhounds spawn mid round starting at round 25 (4% chance to spawn)
* Initial perk is no longer always Quick Revive in solo
* Initial perk no longer always drops in the starting area in solo
* Initial perk drops at round 1 in coop
* Perks drop every 5 rounds
* Landing perks no longer deal damage to players
* Decreased brightness of CDC view model
* Increased intermission time from 7.5 seconds to 15 seconds
* Fixed Mystery Box floating in the sky at the start of the game
* Fixed an issue where invisible collision would appear in the starting area when zombies were spawning
* Encounter: all perks drop at the start of the game

### Tranzit
* Added AN-94 wallbuy at Town
* Added PDW-57 wallbuy at Bus Depot
* Added SVU-AS wallbuy at Cornfield
* Added PHD Flopper machine at Tunnel
* Added Deadshot Daiquiri machine at Cabin
* Added Mule Kick machine at Cornfield
* Added Who's Who machine at Power Station
* Added Mystery Box at Tunnel
* Added Mystery Box at Cornfield
* Any door that requires a Turbine to open is automatically open whenever the power is on
* Increased bus speed by 100%
* Added bus depart timer on HUD when player is on bus
* Added visor and hanging straps to the bus
* Players can sprint and go prone on the bus
* Powerups dropped within the bus are linked to the bus
* Bus wallbuy trigger functions the same as other wallbuy triggers
* Bus hatch starts off open but broken
* Zombie Shield and Jet Gun correctly kill zombies on the bus
* Lava in starting area activates after the power is on
* Lava destroys grenades instantly
* Lava damage no longer changes based on player's health
* Decreased light lava damage from 6 to 5
* Decreased fire zombie death explosion max damage from 30 to 15
* Player burning fx no longer shows to yourself
* Players can be revived in the fog easier
* Lamp post portals stay active until the lamp post is powered off
* Each lamp post portal teleports players to a set destination lamp post (randomizes each game)
* Decreased brightness at Power Station
* Changed spectator cycle color from grey to black
* Added missing fog fx to all game modes
* Added collision to area at Cornfield that was considered out of the map
* Added "Avenged Sevenfold - Carry On" song (activated by triggering the teddy bear at Farm last)
* Added "Skrillex - Try It Out" song (activated by triggering the teddy bear at Bus Depot last)
* Zombies killed by the bus no longer respawn
* Zombies no longer spawn in the Cornfield Building zone when players are in the Cornfield zone (and vice versa)
* Zombies spawn in the Outside Power Station zone when players are in the Fog After Power Station zone
* Zombies spawn in the Warehouse zone when players are in the Fog After Power Station zone
* Zombies spawn in the Warehouse zone when players are in the Outside Power Station zone before the door between the Power Station Control Room zone and the Warehouse zone is opened
* Fixed bus wheels moving around while the bus wasn't moving
* Fixed T.E.D.D. moving around while the bus was moving
* Fixed zombie riser spawn points that were too high above ground
* Fixed zombie pathing at Cornfield behind the pylon
* Fixed zombie pathing at Town in Bookstore
* Survival and Encounter: power doors are buyable doors
* Encounter: added Ballistic Knife, Ray Gun, and Ray Gun Mark 2 to the Mystery Box
* Quest: added "Benn - Just Like You" song
* Quest: increased pylon powerup drop rate from 4-12 minutes to 2-6 minutes
* Quest: fixed being able to complete both sides
* Quest (Maxis): Avogadro step only requires 1 Turbine under the pylon
* Quest (Maxis): Turbine can get destroyed by the EMP during the Avogadro step and it will still count as completed
* Quest (Maxis): lamp posts step requires all 8 lamp posts to get powered on by a Turbine
* Quest (Maxis): lamp posts step no longer requires all Turbines to be placed at the same time
* Quest (Maxis): fixed lamp post power on check being inaccurate
* Quest (Richtofen): lamp posts step requires all 8 lamp posts to get powered off by an EMP
* Quest (Richtofen): lamp posts step no longer requires all lamp posts to be powered off at the same time

#### Bus Depot
* Lava in starting area activates immediately
* Lava pit is accessible

#### Diner
* Wallbuys: SMR, MSMC, Remington 870 MCS, Galvaknuckles
* Perks: Jugger-Nog, Quick Revive, Speed Cola, Double Tap

#### Farm
* Zombies spawn in the Farm zone when players are in the Barn zone
* Replaced Galvaknuckles wallbuy with Claymore wallbuy (also added to Encounter)
* Encounter: removed collision in the Barn zone

#### Power Station
* Wallbuys: SMR, Ballista, MSMC, Vector K10, Remington 870 MCS, Bowie Knife
* Perks: Jugger-Nog, Quick Revive, Speed Cola, Double Tap, Tombstone Soda
* Pack-a-Punch

#### Town
* Moved Quick Revive to Stamin-Up's location on Town
* Moved Stamin-Up to its location on Tranzit
* Moved Tombstone Soda to the laundry room front door

### Die Rise
* Added Stamin-Up machine at Buddha Room area
* Added PHD Flopper machine at Escape Pod area
* Added Mystery Box at Sweatshop area
* Added Mystery Box at Buddha Room area
* Moved Mystery Box at Shopping Mall area from the Shopping Mall Level 1D zone to the Shopping Mall Level 1C zone
* Added one-way teleporter at Dragon Rooftop area
* Added one-way teleporter at Sweatshop area
* Removed key
* Elevators and escape pod can be called without key
* Added purchase cost to call elevators and escape pod
* Added elevator floors at the bottom of the Dragon Rooftop Level 1B zone
* Escape pod can be used with any amount of players
* Escape pod can be called up or down
* Moved weapon locker to the downstairs fridge
* Quick Revive elevator randomizes with Speed Cola and Who's Who elevators
* Pack-a-Punch can be used while elevator is moving
* Doors that open the same zone open together
* Players no longer fall off the map when using the slide
* Zombies killed by an elevator no longer respawn
* Zombies are no longer killed while spawning in a stationary elevator
* Zombies no longer spawn in the Dragon Rooftop area when players are in the Shopping Mall area
* Zombies no longer spawn in the area across from the debris in the Buddha Room area when the debris is uncleared
* Zombies no longer fall off the map when traversing down to the Shopping Mall Level 1A zone
* Leapers no longer fall off the map when traversing up to the Escape Pod Ground zone
* Fixed weapon model angle on upside down Mystery Box
* Fixed height of the elevators in the Dragon Rooftop Level 1B zone
* Fixed position of an elevator perk in the Sweatshop area and Dragon Rooftop area
* Fixed zombies going to specific locations when they can't find a path to any players
* Fixed zombies spawning in the elevator below the Shopping Mall Level 3B zone when in the Shopping Mall Level 3B zone
* Fixed Who's Who vision filter showing momentarily when the game ended
* Quest: added "Benn - High Risers" song
* Quest: elevator symbols and floor symbols require the player to be on the ground to activate
* Quest: elevator symbols can be activated without players on every symbol
* Quest: elevator symbols stay active after activating once
* Quest: floor symbols can be activated in any order
* Quest: Trample Steam step only requires one Trample Steam to be placed in the correct position
* Quest: tower legs can be punched in any order
* Quest (Maxis): no longer have to shoot the upgraded Ballistic Knife after collecting the corpses
* Quest (Maxis): ball no longer requires a Trample Steam on the other side
* Quest (Richtofen): decreased number of Sliquifier shots required for each ball from 20 to 10

#### Shopping Mall
* Wallbuys: SMR, Ballista, B23R, PDW-57, SVU-AS
* Perks: Jugger-Nog, Quick Revive, Speed Cola
* Buildables: Trample Steam

#### Dragon Rooftop
* Wallbuys: Ballista, MSMC, SWAT-556, Semtex, Claymore, Bowie Knife
* Perks: Jugger-Nog, Double Tap, Mule Kick
* Pack-a-Punch

### Buried
* Added Semtex wallbuy at Candy Store Upstairs
* Added PHD Flopper machine at Lower Processing
* Added Deadshot Daiquiri machine at Mansion Backyard
* Added Tombstone Soda machine at General Store
* Moved MSMC wallbuy to its location on Borough
* Moved buildable wallbuy in Courthouse to AN-94 wallbuy location on Borough
* Adjusted buildable wallbuy positions
* Added controller aim assist to ghosts
* Adjusted volume of zombie vocals
* Fountain portal automatically active
* Players no longer take fall damage after using the fountain teleporter
* Removed buildable table hint icons
* Added buildable table hint strings on buildable purchase
* Zombies spawn in the Toy Store Downstairs zone when players are in the Candy Store Downstairs zone (and vice versa)
* Fixed not switching back to weapon immediately after drawing wallbuy
* Quest (Maxis): no longer need to activate the lever in the Mansion before activating the bells
* Quest (Richtofen): can enter round infinity without having all players next to the Guillotine
### Mob of the Dead
* Perk and powerup icons use the Shadows of Evil style from Black Ops 3
* Added custom loading screen
* Replaced Remington 870 MCS wallbuy at Citadel with Semtex wallbuy
* Added PHD Flopper machine at Showers
* Added Mule Kick machine at China Alley
* Added one-way teleporter at Docks
* 1 afterlife max in solo
* Entering afterlife from a shock box no longer takes away afterlife
* Entering afterlife no longer takes an additional 2 seconds if the player had Electric Cherry
* Spawn facing towards the afterlife player model when entering afterlife
* Can no longer see other player's waypoints when in afterlife
* Afterlife player model has collision
* Moved afterlife icon to the left side of screen above health bar and zone name
* Afterlife icon fades when player has no afterlife lives
* Removed afterlife lives counter
* Key on HUD fades out
* Removed background color from plane parts on HUD
* Changed name of Zombie Shield recipe on HUD from "Shield" to "Zombie Shield"
* Changed background color of Zombie Shield parts on HUD from green to grey
* Changed background color of Acidgat Kit parts on HUD from blue to green
* Plane parts are shared in coop
* Plane parts must be all acquired to craft
* Plane no longer has to be refueled
* Plane reappears immediately after coming back from the Golden Gate Bridge
* Electric chairs appear immediately after crashing at the Golden Gate Bridge
* Zombies spawn sooner after crashing at the Golden Gate Bridge
* All barriers are initially built
* Decreased starting room doors cost from 1000 to 750
* Starting room doors no longer open together
* Brutus no longer spawns if no doors have been opened
* Activating the laundry machine always spawns zombies instead of Brutus
* Docks gate no longer closes when shock box is shocked in afterlife
* Decreased brightness of perk machines
* Improved perk machine flicker
* Added falling hands anim from Origins
* Added crafting sound and item pick up sound
* Changed afterlife doors need power hint string from "Door needs power" to "Power must be turned on"
* Changed Gondola need power hint string from "Gondola requires Power" to "Power must be turned on"
* Removed player spawn point in the Acid Trap
* Zombies spawn in the Docks Gates zone when players are in the Docks zone (and vice versa)
* Fixed afterlife icon showing when initially in afterlife at the start of the game
* Fixed initial weapon raise anim happening after exiting afterlife
* Fixed perk hint strings showing when in afterlife
* Fixed being able to hit a death barrier when jumping off the Docks Bridge zone
* Acid Trap: kills on any round (normally stops killing after round 158 on PC)
* Acid Trap: kills zombies instantly
* Acid Trap: decreased player damage from 75% of max health to 50% of max health
* Acid Trap: increased time between player damage from 1 second to 1.5 seconds
* Fan Trap: fixed rumble continuously playing after respawn if player bled out near the trap
* Tower Trap: kills on any round in 1 shot
* Tower Trap: fixed line of sight check
* Tower Trap (upgraded): kills on any round in 1-2 shots
* Tower Trap (upgraded): stays upgraded until the end of the round
* Tower Trap (upgraded): can be upgraded while the trap is not active
* Tower Trap (upgraded): upgrading no longer resets the duration of the trap
* Survival and Encounter: using the Mystery Box no longer spawns Brutus
* Encounter: Tower Trap targets and damages players
* Quest: added "Benn - Alcatraz" song
* Quest: Blundergat gets full ammo when picked up (normally missing one clip)
* Quest: number pad only needs each number to be shocked once to complete
* Quest: can enter the plane in afterlife with any amount of players
* Quest: can enter the plane in afterlife without Weasel
* Quest: if Weasel is the only player in the game, the cycle breaks immediately after being revived from the electric chairs
* Quest: if Weasel is not in the game, the cycle continues immediately after all players are revived from the electric chairs
* Quest: fixed revive triggers behaving incorrectly when reviving players from the electric chairs
* Quest: players no longer get moved to different positions after all players are revived from the electric chairs
* Quest: added player health regeneration during showdown
* Quest: showdown target waypoint shows immediately after all players are revived from the electric chairs
* Quest: showdown target waypoint shows offscreen

### Cell Block
* Zombies spawn in the Cell Block 3rd Floor zone
* Fixed players taking damage from the key spawn positions
* Fixed the electric fence in the Warden's Office making noise when bumping into it

### Origins
* Added Double Tap machine at Generator 6 Church
* Added PHD Flopper machine at The Crazy Place Fire Chamber
* Added Deadshot Daiquiri machine at Generator 2
* Added Electric Cherry machine at The Crazy Place Ice Chamber
* Door prices in solo cost the same as in coop
* Records automatically picked up
* Gramophone initially spawns at Excavation Site gramophone table
* Swapped spawn positions of certain staff parts to match the area where they are picked up at
* Musical parts on HUD change record color to show which table the gramophone is currently placed at
* Musical parts on HUD fade out
* Changed order of staff parts on HUD to match order of staff holders
* Staff parts on HUD correctly show that a player has a staff and a gem
* Staff parts on HUD no longer show that a player has a staff when it is crafted
* Changed order of Zombie Shield and Maxis Drone recipes on HUD
* Changed background color of Maxis Drone parts on HUD from green to orange
* Golden helmet shows at the same spot as golden shovel
* Moved challenge medals and tablet icon above health bar and zone name
* Added attachment name on HUD for upgraded attachment weapons
* Increased volume of crafting sound and item pick up sound
* Added player spawn points in The Crazy Place area
* Moved player spawn point in the Workshop area from the Workshop Upstairs zone to the Workshop Downstairs zone
* Moved player spawn point in the Generator 3 area to be closer to the area
* Zombies no longer spawn in the Generator 5 Tank Route 5 zone when players are in the No Man's Land Back Path 1 zone (and vice versa)
* Zombies no longer spawn in the Generator 6 After Tank Station 3 zone when players are in the No Man's Land Back Path 3 zone (and vice versa)
* Zombies no longer spawn in the Generator 6 After Tank Station 3 zone when players are in the Generator 6 After Tank Station 1 zone (and vice versa)
* Zombies spawn in the Generator 6 After Tank Station 3 zone when players are in the Generator 6 After Tank Station 2 zone (and vice versa)
* Zombies spawn in the Generator 6 Before Tank Station 3 zone when players are in the Generator 5 Tank Route 5 zone before the debris between the No Man's Land Back Path 2 zone and the Generator 6 Left Footstep zone is cleared
* Zombies spawn in the Generator 3 Above Bunker zone when players are in the Generator 3 Bunker 2 zone before any player has entered the Generator 3 Above Bunker zone
* Zombies spawn in the Generator 3 Above Bunker zone when players are in the Generator 4 Tank Route 6 zone before any player has entered the Generator 3 Above Bunker zone
* Fixed zombie eye fx not showing correctly when they first spawn in The Crazy Place area
* Fixed being able to hit a death barrier when jumping off the Generator 3 Above Bunker zone
* Fixed front part of tank model spawning in the Excavation Site Level 2 zone
* Generators: changed cost from 200-800 depending on how many players to 500
* Generators: increased capture reward points from 100 to 500
* Generators: capture reward points are only awarded to the activator
* Generators: changed capture time from 10-40 seconds depending on how many players to 20 seconds
* Generators: increased decay time from 20 seconds to 40 seconds
* Generators: always refund points if player was on the generator when captured
* Generators: can no longer start capturing if another generator is being captured by zombies
* Generators: no longer lose capture progress if any players are on the generator when zombies are capturing
* Generators: no longer gain capture progress if no players are on the generator when recapturing
* Generators: capture round zombies only drop Max Ammo if killed before taking first generator
* Generators: capture round zombie waypoint no longer shows offscreen
* Generators: added capture round zombie waypoint to all capture round zombies
* Generators: fixed capture round zombies not dropping Max Ammo when killed by a staff
* Generators: fixed an issue where recapture sound and fx would play twice
* Giant Robots: both feet always have an openable hatch
* Giant Robots: players bleed out instantly when stomped
* Giant Robots: zombie limit no longer decreased to 22 when 3 robots are active
* Tank: no longer kills players
* Tank: players can go prone on the tank
* Tank: powerups dropped within the tank are linked to the tank
* Tank: standing on the tread pushes the player forward instead of backward if the tank is moving
* Tank: changed cooldown to 30 seconds (normally 2-120 seconds depending on how long players were on the tank)
* Tank: no longer free to activate if called
* Tank: changed cooling down hint string from "Tank engine cooling down" to "The tank is cooling down"
* Teleporters: stay active after picking up gramophone
* Teleporters: placing gramophone activates The Crazy Place teleporters
* Teleporters: players face away from the teleporters when returning from The Crazy Place
* Teleporters: players can teleport while prone
* Mystery Box: added STG-44 Quickdraw Handle
* Mystery Box: removed B23R Extended Clip
* Mystery Box: Five-seven Dual Wield can no longer be obtained if player has Five-seven
* Mystery Box: Five-seven Dual Wield ammo can be purchased from Five-seven wallbuys
* Mystery Box: rotated weapon model angle 180 degrees
* Mystery Box: uses the same trade weapon hint string as other maps
* Der Wunderfizz: increased cost from 1500 to 2500
* Der Wunderfizz: all perks have an equal chance of being obtained
* Der Wunderfizz: available at all locations and costs 250 points when Fire Sale powerup is active
* Der Wunderfizz: decreased perk bottle pick up time from 10 seconds to 6 seconds
* Der Wunderfizz: players only see perk bottles cycling that they can currently obtain
* Der Wunderfizz: perk bottle shows at correct position when it first appears
* Der Wunderfizz: perk bottle is no longer at an angle when cycling
* Der Wunderfizz: perk bottle no longer moves behind the activation fx after cycling
* Der Wunderfizz: perk bottle no longer rotates after cycling
* Der Wunderfizz: teddy bear perk bottle rotates fast, then moves forward, then moves backward before moving to new location
* Der Wunderfizz: refunds points when teddy bear perk bottle is shown (normally refunds points when orb moves to new location)
* Der Wunderfizz: moves to new location instantly
* Der Wunderfizz: can no longer be activated while orb is moving down
* Der Wunderfizz: can be activated while the previous activator is drinking the perk
* Der Wunderfizz: obtaining the perk no longer takes an additional 0.5 seconds
* Der Wunderfizz: fixed top part of inactive machines not being open initially
* Der Wunderfizz: fixed sound and fx not playing if activated immediately after becoming activatable
* Rituals of the Ancients: spend points challenge reward changed from Double Tap perk to a random perk that the player does not have (perk does not change if reward is reopened)
* Rituals of the Ancients: fixed reward chests glowing initially
* Rituals of the Ancients: fixed not being able to pick up One Inch Punch from reward chests after disconnecting and reconnecting to a match
* Soul boxes: decreased number of souls to close from 30 to 20
* Dig spots: decreased number of digs to obtain golden shovel from 30 to 20
* Dig spots: changed number of digs to obtain golden helmet to 40 (normally 5% chance to obtain after obtaining golden shovel)
* Dig spots: dug up weapons get full ammo when picked up (normally missing one clip)
* Perk bottle dig spots: give random perk
* Perk bottle dig spots: all 4 spots are visible at the same time
* Perk bottle dig spots: fixed spots behaving incorrectly after disconnecting and reconnecting to a match
* Survival and Encounter: One Inch Punch buyable for 9000 points at Rituals of the Ancients reward chests
* Quest: added "Benn - The Divider" song
* Quest (ascend from darkness step): 3 robots are always active during this step
* Quest (ascend from darkness step): staffs can be placed at any staff holder
* Quest (ascend from darkness step): fixed an issue where staffs were able to be picked up at their build location when placed in the staff holders
* Quest (rain fire step): button no longer deactivates after activating
* Quest (unleash the horde step): decreased amount of Panzersoldats that spawn from 8 to 4
* Quest (unleash the horde step): Panzersoldat round and this step can no longer happen at the same time
* Quest (raise hell step): all staffs must be fully charged for souls to be collected
* Quest (raise hell step): zombies in The Crazy Place get knocked down during the screen flash after collecting all of the souls
* Quest (freedom step): teleport trigger can be triggered without looking at it
#### Church
* Wallbuys: B23R, STG-44, Remington 870 MCS, Frag Grenade
* Perks: Double Tap
* Der Wunderfizz
* One Inch Punch
## Game Modes

Picking a mode never hides the others, so the map list narrows to match instead. Meat runs wherever
Grief runs, since it shares Grief's map setup. Turned is only wired up on Buried Street.

| Mode | Start locations |
| --- | --- |
| Classic | Tranzit, Die Rise, Buried, Mob of the Dead, Origins |
| Survival | Nuketown, Bus Depot, Diner, Farm, Power Station, Town, Shopping Mall, Dragon Rooftop, Cell Block, Church |
| Grief | the Survival locations, plus Buried Street |
| Meat | the Survival locations, plus Buried Street |
| Turned | Buried Street |

Grief, Meat and Turned are built around two teams, so a solo party can start them but has no one to
play against.

### Encounter
* Group of competitive game modes
* Unlimited zombies
* 2500 health zombies
* 0.5 second zombie spawn rate
* Only sprinting zombies
* Crawlers bleed out if they have not dealt or taken damage within 30 seconds
* Boss zombies spawn every 4-6 minutes (on maps that have them)
* Unlimited powerups
* Unlimited barrier rebuild points
* Stunning enemy players with an unupgraded weapon decreases their move speed to 60%
* Stunning enemy players with an upgraded weapon or a melee weapon decreases their move speed to 40%
* Meleeing enemy players with an upgraded melee weapon pushes 33% more
* Meleeing enemy players that are in the air pushes 100% more
* Meleeing enemy players that are crouched pushes 33% less
* Meleeing enemy players that are prone pushes 66% less
* Meleeing enemy players that are reviving pushes 50% less
* Meleeing enemy players that are already stunned will still push them
* Ballistic knife projectile pushes enemy players
* Placeable mines are no longer triggered by enemy players
* Stun fx is linked to the player
* Stun fx shows in the correct position for explosive damage and projectile impact damage
* Stunning enemy players steals 100 points from them
* Downing enemy players awards 500 points
* Landing on top of an enemy player that is prone downs them
* Increased max radius for landing on top of an enemy player by 16.66%
* Decreased max height for landing on top of an enemy player by 50%
* Players start with 10000 points
* Decreased upgraded starting weapon, Ray Gun, and Ray Gun Mark 2 stock ammo by half
* Max Ammo: decreased amount of ammo given from max stock to one clip
* Max Ammo: unloads clip of all enemy players' weapons and takes away their grenades and placeable mines
* Double Points: decreased duration from 30 seconds to 15 seconds
* Double Points: enemy players gain half points
* Insta Kill: decreased duration from 30 seconds to 15 seconds
* Insta Kill: enemy players deal half damage
* Nuke: enemy players lose 400 points
* Nuke: deals 75 damage to all alive enemy players
* Nuke: bleeds out all down enemy players
* Added new CDC and CIA revive waypoint icons
* Added kill feed (includes downs, revives, and bleed outs)
* Added player kills on scoreboard (replaces headshots)
* All teammates have the same color on player overhead names
* All players have the same color on points and scoreboard
* Scoreboard always shows your team on top
* Spawn points are assigned to a team
* Added limited weapon check for saved weapons on bleed out
* Properly restores dual wield weapon left clip ammo, alt weapon ammo, and equipment on respawn
* Player offscreen waypoint arrow only shows for your team
* Can only spectate your team
* Added option to change teams in game
* Pro: no Mystery Box
* Pro: no Pack-a-Punch
* Pro: no Der Wunderfizz
* Pro: no held melee weapons

#### Grief
* Gain score by making enemy players bleed out
* Make 10 enemy players bleed out to win the game
* Players retain perks
* Players respawn after being down for 10 seconds

#### Meat
* Gain score by being the team holding the meat
* Gain 200 score to win the game
* Meat powerup always drops from the first zombie killed
* Player holding the meat gains 100 points when their team gains score
* Downing while holding the meat drops it as a powerup
* Throwing the meat on the ground drops it as a powerup
* Throwing the meat onto another player makes them grab the meat
* Decreased meat powerup time on the ground by half
* Team holding the meat shown on HUD
* Players retain perks
* Players respawn after being down for 10 seconds

#### Turned
* Survivors score starts at the amount of survivors
* Zombies score starts at the amount of survivors multiplied by 50
* Survivors score reduces when a survivor downs
* Zombies score reduces by 1 every second
* Reduce the enemy score to 0 to win the game
* All players start as survivors (except players that join mid game start as zombies)
* Disease powerup spawns near a random survivor after 10 seconds and chases the closest survivor to turn them into the initial zombie
* Survivors have an indicator when there are zombies nearby
* Survivors gain 10 points every second
* Survivors become zombies when they bleed out
* Zombies see survivors and other zombies through walls
* Zombies have the same health as AI zombies
* Zombies have the same melee damage as AI zombies
* Zombies have the same melee range as survivors
* Zombies move at 110% move speed (initial zombie moves at 120% move speed)
* Zombies can jump and go prone
* Zombies can open doors and activate traps
* Zombies can execute down survivors
* Zombies can't move while attacking, executing, or changing stances
* Zombies move at 50% fading move speed for 0.5 seconds after jumping
* Zombies can't damage the same survivor for 0.25 seconds after damaging them
* Zombies respawn near a random survivor
* Zombies respawn after spectating for 10 seconds
