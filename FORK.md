# Reimagined-Lite — fork changes

Fork of [BO2-Reimagined](https://github.com/Jbleezy/BO2-Reimagined) by Jbleezy. This file tracks
what **this fork** changes on top of that, and how far each change has actually been tested.
`README.md` describes only what this build does today; anything upstream did that this fork took
back out is catalogued here instead.

Forked at upstream commit `95729235`. First fork commit: `e4b42b92`, 2026-07-28.

## Test status key

| Mark | Meaning |
|---|---|
| ✅ | Played in game and confirmed working |
| ⚠️ | Played, works, but with a known rough edge |
| ❓ | Built clean, never seen in game |
| ❌ | Tested and known broken |

---

## The headline change

Upstream Reimagined **pre-built every buildable at match start**. `buildbuildables()` in
`_zm_reimagined.gsc` handed you the Zombie Shield, Turret, Electric Trap, Jet Gun, Sliquifier,
Trample Steam, Subwoofer and Head Chopper, and crafted the power switch, Pack-a-Punch, the Diner
hatch and the NAV table for you. Parts were never collected.

This fork deleted that whole system, so buildables are assembled from parts as in the base game.
It is the largest single difference between this fork and upstream.

## Upstream features removed

Everything here worked in Reimagined and does **not** work in this fork. Removed from `README.md`
so that document describes only current behaviour.

| Removed | Commits |
|---|---|
| Auto-building of all buildables, per the section above | `daf7c4ee`, `e4b42b92` |
| Auto-collecting of craftable parts on Mob of the Dead and Origins — the shield, Acid Gat Kit, Maxis Drone and gramophone parts were all handed to you at spawn. `buildcraftables` survived the buildables purge and was removed separately | working tree |
| Turbine specifically dropped from the auto-build list before the rest went | `e4b42b92` |
| Buildable system changes: purchase cost, automatic part pickup, build-at-any-table, HUD weapon name, custom build prompts and progress bar, held world model, movement and melee changes while carrying, destruction rules. Deleted `replaced/_zm_buildables.gsc` | `ae23bf7c`, `daf7c4ee` |
| Pooled buildable randomisation on Buried and Die Rise Sweatshop. Deleted `replaced/_zm_buildables_pooled.gsc` | `ae23bf7c`, working tree |
| Craftable system changes on Mob of the Dead and Origins. Deleted `replaced/_zm_craftables.gsc` | working tree |
| Craftable table overrides on Mob of the Dead and Origins. `updatecraftables()` and the map-local copies of `craftable_place_think`, `craftabletrigger_update_prompt` and `craftablestub_update_prompt` were deleted from `zm_tomb_reimagined.gsc` and `zm_prison_reimagined.gsc`, handing the crafting tables back to stock code. This also removed the points charge for taking a crafted item off the table, and the Maxis Drone's "already taken" and "cooling down" hint strings — the drone is still limited to one at a time by `tomb_custom_craftable_validation`, it just no longer says why | working tree |
| Zombie Shield repair at a crafting table. The helper went with `_zm_buildables`; the four call sites on Mob of the Dead and Origins were removed afterwards | `ae23bf7c`, working tree |
| Points cost to convert the Blundergat into the Acidgat on Mob of the Dead. The cost came from `get_equipment_cost()`, deleted with the buildables system, which left the conversion station comparing a player's score against an undefined value — the prompt read `[Cost: ]` and the station died the first time anyone used it. The conversion is now free, as in the base game | working tree |
| Decorative crate stacks at the Tranzit power switch and Pack-a-Punch buildable tables (`buildable_table_models`) | working tree |
| Jet Gun and Sliquifier buildable table model behaviour, and the Sliquifier's teddy bear box-availability indicator. These lived in the deleted `replaced/_zm_buildables.gsc`; the README bullets describing them have been removed | working tree |
| Banking changes: round interest, 100,000 cap, balance reset each game, teller disabled | `26ba1991` |
| Carpenter powerup removal — Carpenter drops again | `daf7c4ee` |
| Built-in perk shaders, including Quick Revive | `e4b42b92`, `97bb1382` |
| Dragon Pack-a-Punch camo. Reimagined replaced the stock upgraded-weapon camo with BO2 multiplayer's dragon camo (`d16c8a54`), and the README bullet describing it has been removed. The camo index is stock and always was — `get_pack_a_punch_weapon_options` picks 39, or 40 on Mob of the Dead and 45 on Origins, exactly as vanilla does — so the swap was made by redefining what index 39 *is*, in row 39 of `mp/weaponoptions_zm.csv`. That row is now back to stock's `mtl_weapon_camo_zombies,1,4`; the other seven camo rows were never changed. Mob of the Dead and Origins are unaffected, since they never used index 39. The last column is the 1-based index into each weapon's `camoMaterials` list, and six files in `camo/` had no group 4 — `acog`, `blundergat`, `metalstorm`, `mms`, `slipgun`, `titus6` — which is why dragon (group 12, missing only on `blundergat`) was the safer choice upstream. Rather than leave the ACOG attachment, Metal Storm, MMS, Sliquifier and Titus-6 upgrading with no camo, a group 4 was authored in all six by cloning the group that file already had — group 12, or group 9 for `blundergat`, which never had a dragon either — and substituting the zombies materials into it, so each keeps the base-material mapping and UV scale already tuned for that model. All 45 camo files now define group 4. Only `mtl_weapon_camo_zombies`, `_1` and `_3` exist, and `_3` is deliberately unused here: it resolves inside `common_mp` but not in the zombies steps, which load `camo_materials.ff` and not `common_mp.ff`, so an ACOG pulled in as an attachment dependency failed to link with *Missing asset "mc/mtl_weapon_camo_zombies_3"*. `camo_xpr50` still uses `_3` and is fine, because it only ever builds inside `common_mp` | working tree |
| Unlimited sprint for everyone. `set_perks()` handed every player `specialty_unlimitedsprint` on every spawn, so the sprint meter never mattered. It is now earned rather than free — see the Stamin-Up row in the additions table, which moves it onto that perk. `specialty_fastmantle` and `specialty_fastladderclimb` are untouched, as are the dive and sprint-recovery changes | working tree |
| Forced shotgun rank icon. `mp/rankicontable_zm.csv` pinned every rank row to `zombies_rank_5`, so the scoreboard and in-game rank icons always drew the shotgun. The file is deleted along with its `stringtable` line in `reimagined.zone`, and rank icons follow the player's real rank again. No art was involved — every icon named in that table is a stock asset | working tree |
| Disabled melee lunging. A single `aim_automelee_enabled 0` in `set_client_dvars`; auto-lunge is back on. The 16% melee range increase is a separate change (`player_meleeRange 64` in `set_dvars`) and stays | working tree |
| Low health regeneration delay cut from 5 seconds to 4. `level.longregentime` in `replaced/_zm_playerhealth::playerhealthregen` is back to stock's 5000. That value also feeds `redflashingoverlay`'s `stopflashingbadlytime`, so the red flashing overlay returns to stock timing with it. The other health changes in that function are unchanged — 2 second normal regen delay, the 50-health low threshold, the non-instant regen rate, and Quick Revive's cut to both delays (since raised to 33%, see the additions table) | working tree |
| Mystery Box special sound retargeting. Reimagined first moved the `mus_raygun_stinger` off the Ray Gun onto limited weapons (`3fbb214f`), then narrowed it to a hardcoded wonder weapon list (`d26b8014`). Both are undone — `weapon_give` plays the stinger on `ray_gun_zm` again, exactly as stock does, and the `is_magicbox_wonder_weapon` helper that backed the list is deleted with its last caller | working tree |
| Removed blur after drinking a perk. The three lines Reimagined stripped out of `give_perk` are back, so drinking blurs the screen for 0.1 s as in the base game | working tree |
| Speed Cola aiming twice as fast. `give_additional_perks` no longer grants `specialty_fastads` alongside `specialty_fastreload`; the faster weapon switch and grenade throw are untouched | working tree |
| Double Tap changes, both halves. `perk_weapRateEnhanced 0` is gone from `set_dvars`, so the perk fires two bullets per shot again, and the 1.5× bullet damage block for `specialty_rof` is deleted from `actor_damage_override`. The whole `### Double Tap` README section went with them, since those two bullets were all it contained | working tree |
| Stamin-Up cost increase. `level._custom_perks["specialty_movefaster"].cost` is back to stock's 2000 | working tree |
| Quick Revive not auto-powering in solo. Done surgically rather than by flipping `level.using_solo_revive`, which is the one line Reimagined used and which also controls the solo cost and the stock three-lives system — both of which this build keeps. `vending_trigger_think` now sets `start_on` for a one-player game directly, so the machine starts powered as in the base game while the perk stays at 1500 and self revives stay gated on holding a perk | working tree |
| Quick Revive's revive time reduction cut to 33.33%. `revivetime` is divided by 2 again, not 1.5, so the perk halves revive time as stock does | working tree |
| Speed Cola aiming twice as fast — **moved, not removed.** `specialty_fastads` now hangs off `specialty_deadshot` instead of `specialty_fastreload` in `give_additional_perks` | working tree |
| Mule Kick stowed weapons reloading over time. `additionalprimaryweapon_stowed_weapon_refill` and its `refill_after_time` helper are deleted along with the spawn thread — about 150 lines, the largest single removal in this batch | working tree |
| Vulture-Aid seeing players and zombies through walls, and its removal of perk, wallbuy and Mystery Box vision. Both lived in `replaced/_zm_perk_vulture.csc`, which replaced `vulture_vision_enable` to swap the stock wallbuy and perk-machine fx for a sonar attachment, and stubbed `vulture_vision_update_wallbuy_list` and `vulture_vision_mystery_box` out entirely. The whole file is deleted with its four `replaceFunc` lines, restoring both halves at once, and `give_vulture_perk`/`take_vulture_perk`/`vulture_perk_ir_think`/`vulture_perk_ir_is_valid` go with it on the server side. `_vulture_perk_think` is the only function kept, since the stink-while-moving change stays. **The three `cg_sonarAttachment*` dvars were deliberately left in place** — they read as Vulture-Aid support but only affect a client whose sonar attachment is on, which is now Turned zombies alone, and they are what lets those zombies see each other and stops distance fade | working tree |
| Powerup drop chance cut from 3% to 2%. `powerup_chance` is 3, which reproduces stock's `rand_drop > 2` exactly | working tree |
| **All Zombie Blood changes.** `replaced/_zm_powerup_zombie_blood.gsc` and `.csc` are deleted with their four `replaceFunc` lines in the Origins scripts. The Turned view model and orange eye fx it pulled in are stock assets Turned already loads, so no zone entries needed removing | working tree |
| B23R weapon cost cut from 1000 to 900, and the reduced Pack-a-Punch camo coverage on the upgraded model. The cost block is gone from `wallbuy_cost_changes` — the 870 MCS and Thompson blocks beside it stay — and `camo/camo_b23r.json` is deleted, so the linker falls back to the stock camo through the existing `camo,camo_b23r` line in `common_mp.zone`. Note the README bullet read "primary **camo**", not ammo; the B23R had no ammo change | working tree |
| Executioner gaining Fast Mag when upgraded. Its row in `zm/pap_attach.csv` goes from `dualclip` back to `none` | working tree |
| **All Five-seven Dual Wield changes.** `fivesevendw_zm` / `_upgraded` drop from 14 reserve clips to 13, and `fivesevenlh_zm` / `_upgraded` go back to 15 max and 15 start from the fork's 0 and 1. See the per-map caveat below | working tree |
| **All AN-94 changes.** The cost block leaves `wallbuy_cost_changes`, reserve clips go back to 10 unupgraded and 12 upgraded (300 and 600 rounds), and the upgraded name in `reimagined.str` returns to "Actuated Neutralizer 94000". Both maps that carry the gun, Buried and Die Rise, had identical stock values, so this one is exact | working tree |
| M8A1 recoil and ammo. `adsSpread` returns to 5, reserve clips to 6 unupgraded and 8 upgraded, and the upgraded magazine to 42. Stock is uniform across the four maps that carry it, so this is exact | working tree |
| MTAR recoil. `adsSpread` returns to 5 unupgraded and 2 upgraded. See the per-map caveat below for the view-kick fields, which are left alone | working tree |
| **All Weapon Locker changes.** `replaced/_zm_weapon_locker.gsc` is deleted with its six `replaceFunc` lines across Tranzit, Die Rise and Buried, taking the placed-weapon HUD and the clip top-up on store. `weapon_locker_give_ammo_after_rounds` and the `self.stored_weapon_data` reset go from `_zm_reimagined.gsc`, and `level.weapon_locker_online = 0` is dropped from `post_init` — that line, not the spawn reset, was what actually made the stored weapon reset each game, by forcing the locker off the online profile storage onto per-game entity storage. Die Rise keeps its moved locker location, which is a separate fork change | working tree |
| Barriers no longer rebuildable while sprinting or throwing a grenade. The replaced `player_fails_blocker_repair_trigger_preamble` was a byte-for-byte copy of stock apart from one `issprinting() \|\| isthrowinggrenade()` check, so the whole function and its `replaceFunc` were deleted rather than trimmed. `replaced/_zm_blockers.gsc` keeps its other four replacements | working tree |

| **Three competitive game modes: Race, Search & Rezurrect and Containment.** All three were Reimagined additions on top of the stock Encounter framework. Removed: their `maps/mp/gametypes_zm/*.gsc`/`.txt`, `clientscripts/mp/gametypes/*.csc` and `zm/gamesettings_*.cfg` files (12 in total, each `.gsc`/`.csc` a thin shim calling `zgrief::main`), their rows in `gametypestable.csv` and `_gametypes.txt`, their nine `rawfile`/`script` lines in `reimagined.zone`, ten localized string blocks, their entries in four LUI files, and every gametype branch in script — 22 sites in `zencounter_reimagined.gsc` plus a handful elsewhere. Containment's seven dedicated functions (~22 KB) and its whole HUD path went with it, along with Search & Rezurrect's four `update_players_on_*` helpers and `player_bled_out_reward`, which had no callers left. `zencounter_reimagined.gsc` shrank from 103 KB to 74 KB. See the Encounter note below | working tree |

### Encounter itself was deliberately kept

`is_encounter()` is **stock Treyarch code** in `maps/mp/zombies/_zm_utility.gsc`, returning true when
`ui_zm_gamemodegroup` is `zencounter`. In this mod that group covers Grief, Turned, Meat and the three
modes removed above — so Encounter is the shared competitive framework, not a mode. Deleting it would
have taken Grief and Turned, which are stock Black Ops 2 content, so the ~66 `is_encounter()` branches
across 28 scripts are untouched and the framework is intact.

One consequence worth recording: `replaced/_zm_game_module::wait_for_team_death_and_round_end` was
Search & Rezurrect's round logic behind an early `return` for every other mode. Its body is gone, but
the function and its `replaceFunc` are **kept, empty** — the registration is what stops stock's Grief
round-end logic from running, and the Encounter framework calls `game_won` itself.

**`game_won(winner)` in that same file must not be deleted.** It sat between the Search & Rezurrect
helpers and looks like part of them, but it is what ends *every* Encounter mode — `zencounter_reimagined`
calls it from four places when a team is wiped. It was cut with the SR block by mistake and restored;
the symptom was `Unresolved external: "game_won" with 1 parameters` on the first Grief game that
reached an end. Its neighbours `check_for_round_end` and `round_end` genuinely were SR-only and are
gone for good.

### Why two weapon reverts are approximate

Weapon files ship as loose files in `mod.iwd` — one `weapons/zm/<name>` per weapon, applied to every
map. Treyarch's stock values are **not** uniform across maps, so where they differ there is no single
value that restores stock everywhere. Both cases were resolved toward the majority:

- **Five-seven Dual Wield** reserve was 14 clips on Tranzit and 13 on the other six maps. It is now
  13, which is exact on six maps and one clip short of stock on Tranzit. That anomaly is also where
  the README's "225" baseline came from: stock Tranzit pairs 14 clips with a left-hand gun carrying
  225, where every other map gives it 15.
- **MTAR** view kick was the gentle set (`adsViewKickPitchMin` 5, `PitchMax` 52.5, `Yaw` ±45) on
  Tranzit, Die Rise, Nuketown and Die Rise, and a harsher set (15, 65, ±100) on Buried and Mob of the
  Dead. The fork unified everything to the gentle set. Those fields are **left as they are**: they
  came from commit `8ae21ccf`, which baked the `sv_patch_zm_weapons` and `sv_fix_zm_weapons` dvars
  into the weapon files, not from the "Decreased recoil" bullet. What that bullet actually described
  is `adsSpread`, which was zeroed on both the MTAR and the M8A1 and is what has been restored.
  Restoring the harsh kick would have made four maps worse than stock to make two match.

Note that the withdraw and teller **fees** are still waived — that lives in `_zm_reimagined.gsc`,
not the deleted banking script, so it survived the revert and is documented in `README.md`.

## Fork additions and tuning

| Change | Commits | Status |
|---|---|---|
| Fire Sale music rotation: a random track per Fire Sale drawn from the stock song, a hip hop remix, a 4 Minutes cut and a We Are Number One cut, never the same one twice running. Chosen once in `start_fire_sale` because stock threads the alias onto every `intercom` separately, so alias-level randomisation would have each speaker roll its own track. `setup_firesale_audio` is replaced as well as `play_firesale_audio` — replacing the latter alone does nothing, since its only caller is the stock copy of the former. Gated on `level.sndannouncerisrich`: the rotation is Richtofen's, so Samantha keeps the stock `mus_fire_sale` track for as long as she is announcing. That only bites on Nuketown, which opens on Samantha until round 20; every other map has Richtofen from round one | `ae23bf7c`, `daf7c4ee`, working tree | ✅ |
| **Deadshot Daiquiri aims twice as fast**, inheriting the `specialty_fastads` that used to come with Speed Cola | working tree | ✅ |
| **QBB LSW added to Nuketown**, alongside Mob of the Dead. Script only — the `level.script == "zm_prison"` test in the weapon include block now also accepts `zm_nuked`. No zone work was needed: every asset the gun depends on is map-independent, living in `common_mp.zone` (models and anims, under `t6_wpn_lmg_type95_*`), `code_post_gfx_mp.zone` (menu icon), the soundbank, and the loose `weapons/zm/qbb95_*` and `attachmentunique/zm/au_qbb95_*` files in `mod.iwd`. Mob of the Dead has no per-map entry for it either | working tree | ❓ |
| **Stamin-Up grants unlimited sprint.** The perk is `specialty_movefaster` in this build, not the base game's `specialty_longersprint`, so it had no effect on the sprint meter at all once the free unlimited sprint was removed. `give_additional_perks` now sets `specialty_unlimitedsprint` off `specialty_movefaster`, the same way that loop already derives Speed Cola's and Deadshot's extra perks. The unset branch is guarded on `is_zombie`, matching the `specialty_fasttoss` guard beside it, so a Turned zombie player keeps the unlimited sprint `_zm_turned` grants it | working tree | ✅ |
| Stamin-Up move speed cut from 10% to 2% (`perk_speedMultiplier` 1.1 → 1.02), now that the perk carries unlimited sprint instead | working tree | ✅ |
| Quick Revive's health regeneration delay reduction raised from 25% to 33% (`*= 0.75` → `*= 0.67` on both delays in `playerhealthregen`) | working tree | ✅ |
| Zombie Shield health 1500 → 2500 | `631df6ae` | ✅ |
| Legacy guns back in the Mystery Box alongside their replacements, under the `zmr_legacy_box_guns` setting. Started as Galil, RPD, FAL, Python and Barrett M82A1, with the wallbuy-only guns held back; MP5, AK74u, M14, M16A1 and M1911 were added later. The wallbuy five are the ones the mod had made unobtainable — their maps include them as `include_weapon(name, 0)`, and the mod swaps their wallbuys for INSAS, Vector, Saritch, SIG556 and Tac-45 — so returning them to the box is the only way back to them. Each gun reappears only on the maps that natively carry it, since `restore_legacy_box_weapons` guards on `isdefined(level.zombie_weapons[weapon])`; `README.md` has the per-map table | `132ae227`, working tree | ❓ |
| Max Ammo fills the magazine as well as the reserve, including akimbo off-hands. Grief and the encounter modes unchanged | `26ba1991` | ✅ |
| Carpenter restores a carried shield to full health, team-wide. Added to Nuketown, Mob of the Dead and Origins | `26ba1991`, `7ac44cb8` | ✅ |
| Free Perk powerup drops in Survival on all maps, half as often as other powerups | `26ba1991`, working tree | ✅ |
| Free Perk also drops in Classic, but held out of the rotation until a player holds 4 perks at once. Latches on once reached | working tree | ✅ |
| Perk bottles can give perks with no machine on the map (`give_random_perk` reads `level.free_perk_pool`) | `7ac44cb8` | ✅ |
| Bank balance shown at the deposit and withdraw triggers, and the withdraw prompt corrected to read 1000 | working tree | ✅ |
| Mod metadata renamed to Reimagined-Lite | `7de294c9` | ✅ |
| **RULES options tab** exposing eight fork settings: Starting Points, Free Perk Drop, Free Perk Rarity, Zombie Shield Health, Carpenter Repairs Shield, Max Ammo Fills Magazine, Legacy Box Guns, Fire Sale Music | working tree | ✅ |
| HD crosshair — a replacement `side_small.iwi` dropped into `images/`, which `build.bat` packs into `mod.iwd`. Overrides the stock crosshair while the mod is loaded, and reverts by deleting the one file | working tree | ✅ |
| HD font atlases — `gamefonts_pc_720` (2048x4096 A8), `devfonts` and `distfont`. Unlike the reticles these needed **both** halves: an `image,` line in `reimagined.zone` so `mod.ff` carries an asset entry that overrides the base game's, *and* the `.iwi` in `images/` for `mod.iwd` to stream the pixels from. A loose `.iwi` alone does nothing — the base asset wins and the menu keeps stock fonts. `mod.ff` barely grows because T6 images are streamed: the fastfile holds the header only. `devfonts` is a developer asset retail never draws | working tree | ✅ |
| HD texture set — 8 further reticles (`c4`, `flechette`, `hatchet`, `hud_flamethrower`, `knife_ballistic`, `m203`, `reticle_side_round01`, `tank`) and 15 equipment HUD icons (`grenadeicon_32`, `hud_claymore_32`, `hud_bounce_betty_32`, `hud_sticky_grenade_32` and the rest of the `hud_*_32` family). Same mechanism as the crosshair: loose `.iwi` in `images/`, no zone entry, no script reference. Several are MP-only icons that Zombies never draws — they cost disk in `mod.iwd` and nothing else | working tree | ✅ |

## Nuketown

| Change | Commits | Status |
|---|---|---|
| Richtofen takes over the announcer at round 20. Stock opens Nuketown on Samantha and only switches once the last moon transmission lands, which `wait_for_round_range(25)` puts at round 25. Added as its own thread in `zm_nuked_reimagined::init` rather than by replacing `zm_nuked::switch_announcer_to_richtofen`, since stock threads that from `zm_nuked::main` and there is no `replaceFunc` for it — an unregistered replacement is never reached. Stock's copy still runs at 25 and switches a second time, which is a no-op. The blue eye change moves to round 20 with it, via a `replaceFunc` on `zombie_eye_glow_change` rather than a parallel thread — that function clears `spawn_zombies` and kills every zombie to swap in the blue eyed spawner set, so a stock copy still waiting on the flag would repeat all of it at round 25 and wipe the round mid-fight. The moon transmission VO keeps stock timing | working tree | ✅ |
| Alternate Richtofen powerup callouts on Nuketown — Carpenter, Insta Kill, Double Points, Nuke, Max Ammo and Fire Sale. Swapped in alongside the round 20 announcer switch by re-calling `createvox` for those six dialog types, which only rewrites `game["zmbdialog"][type]` and so leaves every other announcer line on its stock alias. Deliberately not done at init: the prefix is `vox_zmba_sam` until round 20, so an early remap would mute Samantha's powerup callouts rather than change them. Registered as variant `_0` regardless of the source file numbering, since `get_number_variants` counts up from `_0` and stops at the first gap | working tree | ❓ |
| BO1 blood splatter dpad on Nuketown, replacing the green circle and its bar. `hud_dpad_blood` is a stock 256x128 material in `common_zm.ff`; the texture now used is the genuine BO1 splatter from mjmodz's Black Ops 1 HUD pack (`t5_hud_dpad_blood`) and matches those dimensions exactly, so only the image is overridden and no material is authored. `ammoareazombie.lua` picks it over the per-map `hud_zm_nuked_dpad` when the map is `zm_nuked`, widens the element to 2:1 so the splatter is not squashed into the 128 square dpad slot, and skips the bar entirely. Held in a local rather than `CoD.AmmoAreaZombie.DpadImage`, which is cached once per session and would otherwise carry the splatter onto the next map loaded without a restart. A first attempt instead repointed the `hud_zm_nuked_dpad` material at the image, which drew it squashed into the square slot as a stretched blob over the ammo area | working tree | ✅ |
| Genuine BO1 perk and powerup icons, Nuketown only. Art from mjmodz's [Black Ops 1 HUD for BO2](https://github.com/mjmodz/Black-Ops-1-HUD-for-BO2) v1.0.0, BO1 images by Kingslayer Kyle — pulled out of that release's `mod.ff` with Unlinker and kept under its own `uie_perk_*` / `uie_powerup_*` names with its own materials. Perk icon materials are global names with no per-map variant, so scoping is done in the LUI: a `nukedMaterialName` field read by `CoD.Perks.GetMaterial` and by `CoD.PowerUps.NukedMaterial`, which the three `CoD.PowerUps.Get*Material` functions share. Materials are registered on first use, not at file scope — they live in `mod.ff`, which loads after the LUI menu files, and registering early got "Could not load material" for every one while the icons silently stayed stock. The map is read through `UIExpression.DvarString(nil, "mapname")` at call time, not cached at file load, because LUI files are not guaranteed to load after the map is known. Covers all twelve perks and all six powerups | working tree | ❓ |
| **Replaced:** a hand-made `_bo1` icon set — 14 renamed images and 14 materials generated from an Unlinker dump of `specialty_juggernaut_zombies` — which had no art for Who's Who, Electric Cherry, Bonfire Sale or Minigun, so those four fell back to stock icons on Nuketown. The replacement art was kept under the pack's own names rather than renamed into the `_bo1` scheme because it is 128x128 with mipmaps where the retired set was 256x256 without, and reusing the old names would have meant transcoding the images and hand-authoring 18 materials to match | working tree | ✅ |
| Stamin-Up and Mule Kick machines added to the sky rotation, so both are reachable without a perk bottle. Everything but the machine was already in place — the perks are enabled in `perk_changes`, and the models, materials and fx were already listed in `zone_source/includes/zm_nuked.zone`, so this is script only. The Stamin-Up struct is keyed `specialty_longersprint` rather than the `specialty_movefaster` the bottle pool uses, because `swap_marathon_perk` renames the perk after `perk_machine_spawn_init` has matched on the original name. `bring_random_perks` gained two more delivery calls, at rounds 21-22 and 24-25 — one call per machine or the leftovers never leave the sky | working tree | ✅ |
| **Fixed:** perk machines could be stranded at `top_height` for a whole game, invisible and non-interactable. PHD and Deadshot were appended at hardcoded indices `[5]` and `[6]`, so a PHD machine that failed to resolve left a hole at 5 while Deadshot still took 6. `bring_random_perk` draws `randomintrange(0, machines.size)` without testing what it drew, so a draw could land on the hole and burn one of the scheduled deliveries, leaving a real machine in the sky. Pack-a-Punch is `machines[4]` and as likely to be the casualty as any perk. Both now append at `machines.size` | working tree | ❓ |
| Backyard Mystery Box location replaced with a buildable bench | `0185e4e9` | ✅ |
| Zombie Shield buildable, 2 parts spawning around the map | `0185e4e9`, `23f69405` | ✅ |
| Shield part HUD icon drawn from script, bottom right | `0185e4e9` | ✅ |
| Substitute sounds for part pickup, bench build loop and completion, because Nuketown's soundbank has none of the buildable or shield aliases | `23f69405` | ✅ |
| PHD Flopper machine added, dropped from the sky like the others | `7ac44cb8` | ✅ |
| Perk machines drop every 3 rounds instead of every 5; 7 machines, all down by round 19 | `7ac44cb8`, working tree | ✅ |
| Perk bottles can also give Stamin-Up and Mule Kick, neither of which has a machine. Deadshot now has one | `7ac44cb8`, working tree | ✅ |
| Carpenter drops only while a player carries a shield, since the map has no windows to board | `7ac44cb8` | ✅ |
| Deadshot Daiquiri machine added as a seventh sky drop, arriving rounds 18-19 | working tree | ✅ |

---

## Still to test

Everything marked ❓ or ⚠️ above. Three items remain:

1. **Grief, Meat and Turned still work** after the Race, Search & Rezurrect and Containment removal.
   All three share the Encounter framework the removed modes were built on, and the mode list, the
   gametype table and several script branches were rewritten around them. Check each appears in the
   lobby, starts, scores and ends correctly.
2. **QBB LSW on Nuketown** — it should appear in the Mystery Box with a world model, a view model and
   its own fire sound. If it draws as a missing model, the assets are not reaching the Nuketown
   fastfile and would need `weapon,qbb95_zm` adding to `zone_source/includes/zm_nuked.zone`; check
   Mob of the Dead too in that case, since neither map declares the weapon per-map today.
3. **Blundergat to Acidgat conversion on Mob of the Dead** — broken by a deleted cost function and
   fixed the same way the crafting tables were, but found by reading the diff rather than by
   playing, so it has never been seen working. The prompt should read cleanly with no cost, and the
   station should still work on a second use. This is the step immediately after crafting the Acid
   Gat Kit, which has been confirmed.

Confirmed: all three batches of upstream removals. The first — free unlimited sprint, the forced
shotgun rank icon, disabled melee lunging, the 4 second low health regen delay, and the barrier
rebuild restriction while sprinting or throwing. The second — the Ray Gun stinger back on the Ray
Gun, the perk drinking blur, Double Tap at stock, and Stamin-Up carrying unlimited sprint at 2000
points and 2% move speed. The third — Quick Revive auto-powering in solo at 1500 with its stock
half-length revive, the ADS speed moved from Speed Cola to Deadshot, Mule Kick no longer refilling
stowed weapons, Vulture-Aid back to stock vision both ways, the 3% powerup drop rate, and the full
Zombie Blood and Weapon Locker reverts. Turned still shows zombies to each other through walls,
confirming the `cg_sonarAttachment*` dvars were rightly kept when Vulture-Aid stopped needing them.
Also all eight RULES settings, and the full HD texture set — crosshair, reticles, equipment
icons and the font atlases, the last of these checked at the menu. The Free Perk gate in Classic, held back
until a player holds four perks at once. Perk bottles granting Stamin-Up and Mule Kick on Nuketown,
which were the two perks with no machine on the map. Crafting end to end on Mob of the Dead and
Origins, including taking the finished item off the table and using the gramophone — the failure
that prompted the craftables rewrite is gone.
Buildables on Buried and Die Rise after the pooling removal. Legacy guns in the Mystery Box. Max
Ammo filling the magazine. Carpenter repairing a carried shield. The Tranzit power switch and
Pack-a-Punch areas after the crate models were removed. Zombie Shield health, the Fire Sale track
and the perk shader removal. Nuketown end to end, including both new perk machines and a perk
bottle drop. The bank on Buried, and building the Turbine from parts there.

## Known issues

### Carpenter powerup on Nuketown

The pickup drew as an untextured black slab because Nuketown's fastfile has no copy of
`zombie_carpenter`. Fixed by adding the model to `zone_source/includes/zm_nuked.zone`, but not
re-tested since.

### Nuketown perk machines

One machine was seen landing invisible, and Juggernog could not be found in the same session. No
models fail to load and no script errors appear in the log, so the cause is unidentified. The
machine lowering code is stock and unmodified. Possibly explained by the drop schedule alone —
before the every-3-rounds change, the last machines did not arrive until round 21.

### Powerup HUD icons

Reported leftover or misdrawn Double Points and Insta-Kill icons on the HUD. Both materials are
present in `common_zm.ff`, which every Zombies map loads, so it is not a missing asset. Undiagnosed.

### Bank is unusable in Town Survival

Not pursued. The bank sits behind a vault door normally blown open with a grenade, which Survival
does not allow. Setting `OnTowBanVault` and `vault_opened` brings the zones online but leaves the
doors shut and solid, because whatever animates them does not run outside Classic. Deleting the door
models and the brushmodels they target does open the way — `town_bunker_door` ×2 and
`lab_secret_hatch` for the underground — but it was not confirmed whether the vault and lab zones
are properly populated in Survival, so it was dropped rather than half-done.

### README entries not individually verified

The per-buildable and per-map bullets in `README.md` — Jet Gun and Sliquifier table models, Maxis
Drone, Acidgat Kit, Buried's buildable table hint strings, Borough's church table — were left in
place. The per-map buildable and craftable scripts survived the deletions, so these plausibly still
work, but each was not checked against surviving code one by one.

### Starting points, formerly disabled code

`replaced/zm_nuked_standard.gsc` used to carry a commented-out call to `starting_points_init(5000)`,
a Nuketown-only prototype. That is now the Starting Points setting on the RULES tab, generalised to
every map and moved into `_zm_reimagined.gsc`; the Nuketown copy and the commented call are gone.

The one behavioural difference worth knowing: the setting is applied as "set the score to this
figure", not "add this much", so the 0 choice removes the stock starting points instead of doing
nothing. 500 deliberately means "leave it alone" rather than "force 500", because the stock starting
score is not always exactly 500 — persistent upgrades and some gametypes move it.

---

## Third-party art

* **Black Ops 1 HUD for BO2** — [mjmodz](https://github.com/mjmodz/Black-Ops-1-HUD-for-BO2), v1.0.0.
  BO1 images by Kingslayer Kyle. This fork uses the HUD art only: the twelve `uie_perk_*` and six
  `uie_powerup_*` icons, and `t5_hud_dpad_blood` standing in for the stock `hud_dpad_blood` image.
  All of it is scoped to Nuketown by the LUI. The pack's scoreboard, pause menu and options screens
  are deliberately not used, and neither is its `t5ammocounter.lua` — Nuketown's ammo counter keeps
  this fork's own layout and only borrows the splatter texture.

  The pack's readme asks that the author's signature be kept on the scoreboard and pause menu.
  Neither is used here, so nothing was stripped; this section is the credit instead.

## Things worth knowing when changing this fork

* **Nuketown carries almost none of the assets other maps have.** Adding anything to it — a powerup,
  a perk, a weapon, a buildable — usually means adding its models, materials, sounds and fx to
  `zone_source/includes/zm_nuked.zone` and loading the source map's fastfile in `build.bat`. The
  linker catches missing models and materials; it does **not** catch missing sound aliases, which
  play as silence, or a missing powerup pickup model, which draws as a black slab.
* **Custom sounds have to be encoded the way the engine expects, and nothing warns you when they
  are not.** Mono, 48kHz, 16-bit FLAC in 1024 sample blocks. ffmpeg defaults to 4608 sample blocks,
  which links, packs and plays — as audible glitching. Pass `-frame_size 1024`. The linker does not
  check this, and neither does anything else until you hear it.
* **Replacing a function only helps if something outside the stock script calls it.** A stock script
  calling its own function binds to the stock copy, so a replacement is dead code. The fire sale
  rotation needed `setup_firesale_audio` replaced as well, to get an unbroken chain of file-local
  calls from `init` down to `playloopsound`.
* **Fork settings live in three places at once.** A new option on the RULES tab needs a selector in
  `ui/t6/options.lua`, a default in `CoD.InitArchiveDvars` in `ui_mp/t6/main.lua`, and a label in
  `english/localizedstrings/reimagined.str`. Miss the label and the row renders blank rather than
  erroring. Defaults are also seeded server-side in `_zm_reimagined::init_dvars` so dedicated
  servers and players who never open the menu still get sane values, and every read goes through
  `mod_setting`, which falls back to a passed default rather than trusting init order — `getDvarInt`
  on an unset dvar returns 0, which is a meaningful value for several of these settings.
* **Gate behaviour, never registration.** A setting that skipped `include_powerup` or a
  `registerclientfield` call would desync host and client and drop joiners with
  `EXE_CLIENT_FIELD_MISMATCH`. The Free Perk toggle works by returning false from
  `func_should_drop_free_perk`, leaving the powerup registered exactly as before.
* **These settings are read wherever the game logic runs.** In co-op that is the host, so a client's
  RULES tab has no effect on the match. They are also read at map load, so changing one mid-game
  does nothing until the next one.
* **Perk and powerup enable flags must match between `.gsc` and `.csc`.** They gate
  `registerclientfield` calls on both sides, and a mismatch drops the client on connect with
  `EXE_CLIENT_FIELD_MISMATCH` rather than misbehaving visibly.
* **Files under `scripts/zm/replaced/` are copies of vanilla** with mod edits threaded through them.
  When stripping a feature, changes there deserve a second look — it is easy to delete a stock line
  along with the mod's. Files under `scripts/zm/<map>/` and `_zm_reimagined.gsc` are pure mod code.
* **Localized strings and the code that fills them are a pair.** `reimagined.str` overrides some
  stock strings with a different number of `&&` slots; removing the mod code that fed them leaves
  the stock caller passing the wrong number of values. That is what made the bank withdraw prompt
  read 10000.
* **Map files keep private copies of stock functions, and those outlive a deleted `replaced/` file.**
  `zm_tomb_reimagined.gsc` and `zm_prison_reimagined.gsc` each carried their own
  `craftable_place_think` and friends, re-pointed onto the tables at runtime by `updatecraftables()`.
  Deleting `replaced/_zm_craftables.gsc` and its `replaceFunc` lines looked complete — no dangling
  references, clean build, no script errors — but the tables were still running the map's copies,
  which called `get_equipment_cost()` for a purchase price. That function had been deleted commits
  earlier, so `stub.cost` was undefined and taking a crafted item off the table failed silently.
  When removing a system, grep the per-map `_reimagined.gsc` files for copies of its functions, not
  just for references to the deleted file.
* **Powerups use a shuffled bag, not weights.** Each type gets one slot per cycle, so adding one
  dilutes the rest. Per-powerup `func_should_drop_with_regular_powerups` checks are how rarity is
  controlled; a failed check deals the next powerup instead, so total drops are unaffected.
