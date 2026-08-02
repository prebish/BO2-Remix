# Building and Testing BO2-Reimagined

How to compile the mod and get it into the game.

---

## The whole thing, in one block

Close the game first, then paste this into PowerShell:

```powershell
# 1. build
cd C:\Users\Joel\Desktop\blops2\BO2-Reimagined
.\build.bat

# 2. install
$dest = "$env:LOCALAPPDATA\Plutonium\storage\t6\mods\zm_reimagined"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item 'C:\Users\Joel\Desktop\blops2\zm_reimagined\*' -Destination $dest -Force

# 3. check — this must print NOTHING
@('mod.ff','mod.iwd','mod.json','mod.all.sabs','mod.all.sabl','mod.english.sabs') |
  Where-Object { -not (Test-Path (Join-Path $dest $_)) }
```

If step 3 prints nothing, launch the game. Anything it prints is a **missing file** — see
[Something went wrong](#something-went-wrong).

Takes about 30 seconds.

---

## Step by step

### Step 1 — Close the game

The game holds `mod.ff` and `mod.iwd` open while running. Installing over a running game fails.

### Step 2 — Open PowerShell in the repo folder

```powershell
cd C:\Users\Joel\Desktop\blops2\BO2-Reimagined
```

**This matters.** `build.bat` figures out every path from the folder you run it in. Run it from
anywhere else and it breaks.

### Step 3 — Run the build

```powershell
.\build.bat
```

Watch for the last line:

- `Finished with 15 warnings, 0 errors` → **success.** 15 warnings is normal, ignore them.
- `Failed with ... 1 errors` → stopped. See [Something went wrong](#something-went-wrong).

### Step 4 — Install the mod

```powershell
$dest = "$env:LOCALAPPDATA\Plutonium\storage\t6\mods\zm_reimagined"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item 'C:\Users\Joel\Desktop\blops2\zm_reimagined\*' -Destination $dest -Force
```

> ### ⚠ The finished mod is NOT in the repo folder
>
> `build.bat` puts it **one level up, in a folder next to the repo**:
>
> ```
> C:\Users\Joel\Desktop\
> └── blops2\
>     ├── BO2-Reimagined\      <-- the repo. NOT here.
>     │   ├── build.bat
>     │   ├── scripts\
>     │   └── mod.ff, mod.all.sabs, ...   (leftovers - incomplete, ignore them)
>     │
>     └── zm_reimagined\       <-- HERE. all 6 files. copy from this one.
>         ├── mod.ff
>         ├── mod.iwd
>         ├── mod.json
>         ├── mod.all.sabs
>         ├── mod.all.sabl
>         └── mod.english.sabs
> ```
>
> `zm_reimagined` is a **sibling** of `BO2-Reimagined`, not inside it. If you're browsing the repo
> looking for it, you won't find it — go up one folder.
>
> The repo folder keeps some mod files after a build, but it's **missing `mod.iwd` and `mod.json`**
> (`build.bat` deletes the `.iwd` from there on its last line). Copy from the repo folder and you get
> a mod with **none of your script changes**, which still boots and looks fine. Easiest mistake to
> make.

### Step 5 — Check you got all 6 files

```powershell
@('mod.ff','mod.iwd','mod.json','mod.all.sabs','mod.all.sabl','mod.english.sabs') |
  Where-Object { -not (Test-Path (Join-Path $dest $_)) }
```

**Prints nothing = good.** Anything it prints is missing and the install is broken.

These are the 6 files that must be there:

| File | Size | What it holds |
|---|---|---|
| `mod.ff` | ~33 MB | images, materials, `.csc` scripts, text |
| `mod.iwd` | ~25 MB | **all your `.gsc` and Lua** |
| `mod.json` | tiny | mod name/version — Plutonium needs it to list the mod |
| `mod.all.sabs` | ~326 MB | sounds |
| `mod.all.sabl` | ~41 MB | sounds |
| `mod.english.sabs` | ~7 MB | sounds |

You may also see a `games_mp.log` in that folder. That's the game's own log file — normal, ignore it.
Don't count files by hand; use the check above, which looks for the 6 by name.

### Step 6 — Play

Plutonium launcher → **Black Ops II** → **Zombies** → pick the **Reimagined** mod → load your map.

---

## Fast rebuild — 2 seconds

If you **only** changed `.gsc` files or Lua in `ui/` / `ui_mp/`, skip `build.bat` entirely:

```powershell
cd C:\Users\Joel\Desktop\blops2\BO2-Reimagined
Compress-Archive -Force -Path attachmentunique,images,maps,scripts,ui,ui_mp,weapons -DestinationPath mod.iwd
Copy-Item mod.iwd "$env:LOCALAPPDATA\Plutonium\storage\t6\mods\zm_reimagined\" -Force
Remove-Item mod.iwd
```

2 seconds instead of 30. Use this while iterating on scripts.

### When do I need the full build instead?

| I changed... | Which build |
|---|---|
| `scripts/**/*.gsc` | **fast** |
| `ui/`, `ui_mp/` (`.lua`) | **fast** |
| `weapons/`, `attachmentunique/` | **fast** |
| `scripts/**/*.csc` | full ⚠ |
| `images/` (`.iwi`) | full |
| `materials/` | full |
| `sound/`, `soundbank/` | full |
| `english/localizedstrings/` | full |
| `zone_source/` | full |
| anything else | full |

> ⚠ **`.csc` files sit in `scripts/` right next to `.gsc` files but need a full build.** Same
> folder, totally different cost. Check the extension.

**Images are the one row with an exception.** Most of `images/` is listed in `zone_source/` and gets
baked into `mod.ff`, which is why the table says full. But an image that is **not** named in any
`.zone` file — a straight replacement of a stock game texture, like the HD crosshair's
`side_small.iwi` — only travels in `mod.iwd`, so the fast rebuild picks it up. If you are unsure,
`grep -r "yourimage" zone_source/` decides it: a hit means full build.

When in doubt, run the full build. It's only 30 seconds.

---

## Three rules

1. **Run `build.bat` from the repo folder.** It uses your current folder to find everything.
2. **Install from `blops2\zm_reimagined`, and check you have 6 files.** Never copy from the repo folder.
3. **Close the game before installing.**

---

## Something went wrong

### I can't find the `zm_reimagined` folder

It's **not inside the repo**. It's one level up, next to it:

```
C:\Users\Joel\Desktop\blops2\zm_reimagined
```

Open it directly:

```powershell
explorer C:\Users\Joel\Desktop\blops2\zm_reimagined
```

If that errors, the build didn't finish — re-run Step 3 and check for `0 errors`.

### The Step 5 check printed `mod.iwd` and `mod.json` as missing

You copied from the repo folder instead of `blops2\zm_reimagined`. Redo Step 4.

This is the most common mistake, and the symptom is confusing: the game still loads and looks
normal, but none of your script changes are there.

### `ERROR: Missing asset "<name>" of type "image"` (or `material`, `script`, `rawfile`)

You deleted an asset file but `zone_source/reimagined.zone` still lists it.

**Fix:** open `zone_source/reimagined.zone`, delete the line naming that asset, build again. The game
then falls back to its own stock version — usually exactly what you wanted.

### A sound doesn't play

The filename must match `soundbank/mod.all.aliases.csv` **exactly**. A replacement track named
`.snds.flac` when the CSV says `.snd.flac` will silently not load.

**Fix:** rename your file to match the CSV. Every sound in this repo uses `.snd.flac`.

**Check it worked:** `mod.all.sabs` should change size. If you swapped a 1.5 MB track for a 17.6 MB
one and the size didn't move, it didn't take.

### Build succeeded but the game looks unchanged

Two possibilities:

1. **You installed from the wrong folder** (see above) — check for 6 files.
2. **Leftover files from another mod pack are overriding yours.** Loose files in
   `%LOCALAPPDATA%\Plutonium\storage\t6\` beat anything in your mod. Check:
   ```powershell
   Get-ChildItem "$env:LOCALAPPDATA\Plutonium\storage\t6\images" -ErrorAction SilentlyContinue
   Get-ChildItem "$env:LOCALAPPDATA\Plutonium\storage\t6\scripts" -Recurse -ErrorAction SilentlyContinue
   ```
   Anything listed there is winning over your build.

### `'build.bat' is not recognized`

You're not in the repo folder. Run the `cd` from Step 2 first.

### Where are the 15 warnings?

Buried in thousands of lines of output. **`0 errors` is what matters — the build succeeded.**

All 15 say the same thing:

```
WARN: DEPRECATED: XModel <name> is version 1 that made use of bad GLTF bone rotations.
```

They're about custom models in `model_export/` that came from upstream. Harmless. **Ignore them.**

To see them anyway:

```powershell
.\build.bat 2>&1 | Tee-Object build.log
Select-String -Path build.log -Pattern '^WARN:|ERROR:|Finished with|Failed with'
```

Treat **15 as your baseline** — if that number changes, something you edited caused it.

### The build failed. Do I have to start over?

No. A failed build leaves all its intermediate work in `zone_source/`. Fix the problem and run
`.\build.bat` again — it picks up quickly.

### Starting completely clean

To rule out stale files:

```powershell
Remove-Item "$env:LOCALAPPDATA\Plutonium\storage\t6\mods\*" -Recurse -Force
```

Then do a **full** build and Step 4. (This deletes the sound banks too, so the fast rebuild alone
won't be enough.)

---

## Appendix — what's actually happening

Skip this unless something is behaving strangely.

### Two output files

Everything you edit ends up in one of two places:

- **`mod.iwd`** — a plain ZIP. Holds `.gsc`, Lua, and raw weapon files. Rebuilt in ~2 seconds.
- **`mod.ff`** — a compiled fastfile. Holds everything listed in `zone_source/reimagined.zone`:
  images, materials, `.csc` client scripts, text, string tables. Needs the linker.

The rule: **if `reimagined.zone` names it, it's in `mod.ff`. Otherwise it's in `mod.iwd`.**

Since `mod.iwd` is just a ZIP, you can read your script back out of the installed mod to prove a
change shipped:

```powershell
$dest = "$env:LOCALAPPDATA\Plutonium\storage\t6\mods\zm_reimagined"
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead("$dest\mod.iwd")
$e = $zip.Entries | Where-Object FullName -eq 'scripts/zm/_zm_reimagined.gsc'
$sr = New-Object System.IO.StreamReader($e.Open()); $sr.ReadToEnd() -split "`n" | Select-String 'buildables_available'
$sr.Close(); $zip.Dispose()
```

### What `build.bat` does

1. Runs `Linker.exe` 24 times. The first 23 build intermediate fastfiles into `zone_source/`; the
   24th (`mod`) combines them into the real `mod.ff`. It also generates the three sound banks from
   `soundbank/*.aliases.csv` plus `sound/`.
2. Zips `attachmentunique, images, maps, scripts, ui, ui_mp, weapons` into `mod.iwd`.
3. Deletes the intermediates.
4. Copies all six output files to `..\zm_reimagined`.
5. **Deletes `mod.iwd` from the repo folder** — which is why the repo folder looks incomplete
   afterwards, and why you must install from `..\zm_reimagined`.

It does **not** install the mod. That's Step 4, and it's on you.

### Setup this depends on

| Thing | Value |
|---|---|
| `OAT_BASE` | `C:\Program Files\OpenAssetTools` |
| `OAT_GAME` | `C:\Program Files (x86)\Steam\steamapps\common\Call of Duty Black Ops II` |
| `pwsh` | must be on `PATH` — `build.bat` uses it to make the ZIP |

Check it:

```powershell
Test-Path "$env:OAT_BASE\Linker.exe"               # True
Test-Path "$env:OAT_GAME\zone\all\zm_transit.ff"   # True
(Get-Command pwsh).Source                          # resolves
```

`OAT_GAME` must be a **stock, unmodified** BO2 install — the linker reads the original game files as
its source of base assets.

### Build outputs aren't committed

`.gitignore` excludes `*.iwd`, `*.sabs`, `*.sabl`, and `.ff` files at the repo root and under
`zone_source/`, so `git status` stays clean after a build.

The two `.ff` files in `zone/all/` are **tracked source inputs**, not build outputs. Don't delete
them.

A fresh clone can't produce a playable install without one full build — the sound banks are
generated, never committed.
