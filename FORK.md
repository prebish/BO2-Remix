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

Note that the withdraw and teller **fees** are still waived — that lives in `_zm_reimagined.gsc`,
not the deleted banking script, so it survived the revert and is documented in `README.md`.

## Fork additions and tuning

| Change | Commits | Status |
|---|---|---|
| New Fire Sale music track | `ae23bf7c`, `daf7c4ee` | ❓ |
| Zombie Shield health 1500 → 2500 | `631df6ae` | ❓ |
| Legacy guns back in the Mystery Box alongside their replacements: Galil, RPD, FAL, Python, Barrett M82A1. Wallbuy-only guns (MP5, AK74u, M14, M16A1, M1911) deliberately not added | `132ae227` | ❓ |
| Max Ammo fills the magazine as well as the reserve, including akimbo off-hands. Grief and the encounter modes unchanged | `26ba1991` | ❓ |
| Carpenter restores a carried shield to full health, team-wide. Added to Nuketown, Mob of the Dead and Origins | `26ba1991`, `7ac44cb8` | ⚠️ |
| Free Perk powerup drops in Survival on all maps, half as often as other powerups | `26ba1991`, working tree | ✅ |
| Free Perk also drops in Classic, but held out of the rotation until a player holds 4 perks at once. Latches on once reached | working tree | ❓ |
| Perk bottles can give perks with no machine on the map (`give_random_perk` reads `level.free_perk_pool`) | `7ac44cb8` | ⚠️ |
| Bank balance shown at the deposit and withdraw triggers, and the withdraw prompt corrected to read 1000 | working tree | ✅ |
| Mod metadata renamed to Reimagined-Lite | `7de294c9` | ✅ |

## Nuketown

| Change | Commits | Status |
|---|---|---|
| Backyard Mystery Box location replaced with a buildable bench | `0185e4e9` | ✅ |
| Zombie Shield buildable, 2 parts spawning around the map | `0185e4e9`, `23f69405` | ✅ |
| Shield part HUD icon drawn from script, bottom right | `0185e4e9` | ✅ |
| Substitute sounds for part pickup, bench build loop and completion, because Nuketown's soundbank has none of the buildable or shield aliases | `23f69405` | ✅ |
| PHD Flopper machine added, dropped from the sky like the others | `7ac44cb8` | ✅ |
| Perk machines drop every 3 rounds instead of every 5; 7 machines, all down by round 19 | `7ac44cb8`, working tree | ✅ |
| Perk bottles can also give Stamin-Up and Mule Kick, neither of which has a machine. Deadshot now has one | `7ac44cb8`, working tree | ⚠️ |
| Carpenter drops only while a player carries a shield, since the map has no windows to board | `7ac44cb8` | ✅ |
| Deadshot Daiquiri machine added as a seventh sky drop, arriving rounds 18-19 | working tree | ✅ |

---

## Still to test

Everything marked ❓ or ⚠️ above. In rough order of how likely it is to be wrong:

1. **Crafting on Mob of the Dead and Origins** — was tested and **broken**: parts could be collected
   but nothing could be built or placed. Fixed by deleting the leftover craftable table overrides
   (see the removed-features table). Needs a full retest: build the shield end to end, plus the Acid
   Gat Kit on Mob, and the Maxis Drone and gramophone on Origins. Taking a finished item off the
   table is the specific step that was failing, so watch that as much as the build itself.
2. **Blundergat to Acidgat conversion on Mob of the Dead** — broken by the same deleted cost
   function and fixed the same way, but found by reading the diff rather than by playing, so it has
   never been seen working. The prompt should read cleanly with no cost, and the station should
   still work on a second use.
3. **Free Perk in Classic, gated on 4 perks** — new and untested. Confirm no bottle appears before
   somebody holds four perks at once, and that they start appearing afterwards.
4. **Which perk a bottle actually grants** — a bottle was collected on Nuketown, but not which perk
   came out. Stamin-Up and Mule Kick are the two with no machine, and Mule Kick's third weapon slot
   is the most likely to misbehave.
5. **Buildables on Buried and Die Rise** — the pooled randomisation was removed, so the Subwoofer,
   Trample Steam and Head Chopper on Buried, and the Sweatshop table on Die Rise, now use fixed
   locations. Confirm each still builds and that no table is left empty.
6. **Legacy guns in the box** — quick to confirm, just needs box spins.
7. **Max Ammo filling the magazine** — including an akimbo weapon, which is the part with separate
   handling.
8. **Carpenter restoring a carried shield** — team-wide, on Nuketown, Mob of the Dead and Origins.
   Take shield damage first, then grab a Carpenter.
9. **Tranzit power switch and Pack-a-Punch areas** — the decorative crate stacks were removed with
   the buildables system. Purely a look check, but worth one glance for a floating or missing table.
10. **Zombie Shield 2500 health, Fire Sale track, perk shader removal** — cosmetic or incidental.

Confirmed so far: Nuketown end to end, including both new perk machines and a perk bottle drop; the
bank on Buried; building the Turbine from parts on Buried; and Origins no longer handing out
craftable parts at spawn.

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

### Disabled code

`replaced/zm_nuked_standard.gsc` has a commented-out call to `starting_points_init(5000)`, which set
Nuketown's starting points. Left in place deliberately, not active.

---

## Things worth knowing when changing this fork

* **Nuketown carries almost none of the assets other maps have.** Adding anything to it — a powerup,
  a perk, a weapon, a buildable — usually means adding its models, materials, sounds and fx to
  `zone_source/includes/zm_nuked.zone` and loading the source map's fastfile in `build.bat`. The
  linker catches missing models and materials; it does **not** catch missing sound aliases, which
  play as silence, or a missing powerup pickup model, which draws as a black slab.
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
