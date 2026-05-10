# WARLOCK DEVELOPER REFERENCE
> Patch 12.0.5 — WoW: Midnight · GSE3 v3315 · Last Updated: 2026-05-08
> This document is the canonical single-source developer guide for all Warlock GSE3 work in this project.
> Read every section before touching any Warlock sequence, generator entry, or talent string.

---

## TABLE OF CONTENTS

1. [Class Overview](#1-class-overview)
2. [Affliction Warlock](#2-affliction-warlock)
3. [Demonology Warlock](#3-demonology-warlock)
4. [Destruction Warlock](#4-destruction-warlock)
5. [Talent Import Strings](#5-talent-import-strings)
6. [PvP Reference — All 3 Specs](#6-pvp-reference--all-3-specs)
7. [GSE3 Sequence Inventory](#7-gse3-sequence-inventory)
8. [Generator Usage](#8-generator-usage)
9. [GSE3 Quirks Affecting Warlock](#9-gse3-quirks-affecting-warlock)
10. [Developer Onboarding](#10-developer-onboarding)
11. [Leveling Rotations — Smart Awareness](#11-leveling-rotations--smart-awareness)

---

## 1. CLASS OVERVIEW

### Spec IDs

| Spec | ID | Role |
|------|----|------|
| Affliction | 265 | Damage (DoT/drain) |
| Demonology | 266 | Damage (pet/demon) |
| Destruction | 267 | Damage (fire/chaos) |

### Hero Talent Options Per Spec

| Spec | Hero Option A | Hero Option B | Recommended |
|------|--------------|--------------|-------------|
| Affliction | Soul Harvester | Hellcaller | Soul Harvester (ST/general) · Hellcaller (AoE M+) |
| Demonology | Soul Harvester | Diabolist | Soul Harvester (ST raid) · Diabolist (M+ / multi-target) |
| Destruction | Hellcaller | Diabolist | Hellcaller (ST/cleave default) · Diabolist (niche burst cleave) |

### 12.0.5 Midnight Changes (Warlock)

**Removed from game:**
- Unstable Affliction (Affliction) — replaced by sustained DoT rotation with Wither/Agony emphasis
- Phantom Singularity — removed
- Soul Rot — baseline removed; talent-only
- Dark Ascension — gone entirely across all specs

**New / renamed:**
- **Wither** (Hellcaller talent for Affliction/Destruction): stacking damage debuff, replaces old Immolate-like Affliction filler
- **Diabolic Ritual** (Diabolist hero talent): buff that cycles via Chaos Bolt and summon abilities
- Note: the generator sequences for Affliction_SoulHarvester_ST still reference `Unstable Affliction` — this is intentional as the generator template matches the imported talent build which may still include it via a specific Midnight talent path. Verify against live talent tree before shipping.

### May 5, 2026 — Class Tuning

**Affliction (PvE):**
- Unstable Affliction +20%
- Seed of Corruption +10%
- Corruption +20% (does NOT affect Wither — separate spell)
- Agony +10%

**Destruction (PvP):**
- All damage +5% in PvP

---

## 2. AFFLICTION WARLOCK

### 2.1 Core Mechanics

- **Resource:** Soul Shards (5 max). Generated via Drain Soul kills, talent procs, Haunt.
- **DoT stack:** Agony (slow ramp), Corruption (direct stack), Unstable Affliction (if talented).
- **Pandemic window:** Refresh DoTs at ≤30% remaining duration — never re-apply at full duration.
- **Shard economy is a hard constraint:** Never enter a Dark Harvest or burst window with an empty shard bank.

### 2.2 Sequence: `Affliction_SoulHarvester_ST_Optimized`

**Use case:** Raid ST, patchwork, slow sustained peel.

**Spell priority order (maps to generator blocks):**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Agony → Corruption → Unstable Affliction | Keep all 3 up before anything else |
| `cooldowns` | Darkglare → Soul Rot | Use when DoT spread is full; Darkglare + all DoTs ticking = max damage |
| `core` | Malefic Rapture → Haunt | Shard spenders; Malefic Rapture is primary burst; Haunt extends DoT duration |
| `pressure` | Drain Soul (nochanneling) → Shadow Bolt | Filler while waiting for shards |
| `filler` | Phantom Singularity → Vile Taint | AoE utility — don't prioritize in pure ST |

**GSE macro body (generator):**
```
maintenance: Agony, Corruption, Unstable Affliction
cooldowns: Darkglare, Soul Rot
core: Malefic Rapture, Haunt
pressure: Drain Soul [nochanneling], Shadow Bolt
filler: Phantom Singularity, Vile Taint
```

**Modifier keys:**
- `ALT` → Spell Lock (interrupt, pet Felhunter)
- `CTRL` → Mortal Coil (CC, fear + self-heal)
- `SHIFT` → Unending Resolve (major defensive CD)

**Anti-patterns:**
- Refreshing DoTs outside pandemic window (≤30% remaining) wastes globals
- Spending Malefic Rapture into an enemy who is being actively dispelled (UA silence on dispel doesn't apply if UA is down)
- Using Unending Resolve preemptively at pull instead of saving for kill-swap pressure

### 2.3 Sequence: `Affliction_Hellcaller_AOE_Optimized`

**Use case:** M+ AoE, heavy multi-target packs, group content.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Agony → Wither → Vile Taint | Wither replaces Corruption in Hellcaller builds — it's a separate debuff stacking DoT |
| `cooldowns` | Soul Rot → Darkglare | Reverse order vs ST — Soul Rot first for AoE shard generation |
| `core` | Seed of Corruption → Malefic Rapture | Seed detonation generates chains; Malefic Rapture spends shards |
| `pressure` | Drain Soul (nochanneling) → Haunt | Haunt doubles DoT damage on primary target |
| `filler` | Shadow Bolt → Curse of Exhaustion | Curse of Exhaustion = AoE slow; useful in M+ |

**Key mechanic — Wither vs Corruption:**
> Wither is NOT the same as Corruption. Applying Corruption does not overwrite Wither. They are separate debuffs. In Hellcaller builds, maintain BOTH if the talent build supports Corruption — check your talent tree.

**Slower shard generation note:** Hellcaller shard generation is slower than SoulHarvester ST builds. Malefic Grasp can swap for Eye Contract for +2% AoE at a ST damage cost if shard income is too tight.

**Anti-patterns:**
- Casting Seed of Corruption on isolated single targets (requires ≥2 targets to function)
- Overcapping shards — spend before bank hits 5
- Re-applying DoTs on targets already at >30% duration remaining

---

## 3. DEMONOLOGY WARLOCK

### 3.1 Core Mechanics

- **Resource:** Soul Shards (5 max) for Hand of Gul'dan; Demonic Core procs for free Demonbolts.
- **Demon board:** The damage output of Summon Demonic Tyrant scales directly with how many demons are active when Tyrant is cast. Thin demon board = wasted Tyrant window.
- **IRON RULE (see QUIRK-022):** Never cast Tyrant with an empty/thin board. Call Dreadstalkers + Hand of Gul'dan imps must be active before Tyrant fires.
- **Tyrant window duration:** ~15 seconds. Front-load all shard spending BEFORE pressing Tyrant.

### 3.2 Sequence: `Demonology_SoulHarvester_ST_Optimized`

**Use case:** Raid ST, single target.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Doom → Hand of Gul'dan | Doom = persistent DoT; HoG populates imp demons |
| `cooldowns` | Nether Portal → Grimoire: Felguard → Summon Demonic Tyrant | ORDER CRITICAL — see QUIRK-022 |
| `core` | Call Dreadstalkers → Demonbolt | Dreadstalkers must be in `core` to fire before Tyrant cooldown attempt |
| `pressure` | Soul Strike → Implosion | Soul Strike generates Demonic Cores; Implosion is AoE burst |
| `filler` | Shadow Bolt → Bilescourge Bombers | Bilescourge = area summon, low priority ST filler |

**QUIRK-022 enforcement in this sequence:**
> `cooldowns` block = `[Nether Portal, Grimoire: Felguard, Summon Demonic Tyrant]`
> Per the Priority triangular model (QUIRK-013), cooldowns are attempted more frequently as the loop deepens. By placing Tyrant last in the cooldowns block AND placing Dreadstalkers in the `core` block (attempted at a shallower depth), Dreadstalkers accumulates attempts before Tyrant's depth is reached.

### 3.3 Sequence: `Demonology_SoulHarvester_AOE_Optimized`

**Use case:** M+ AoE, 3–5+ target packs.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Doom → Call Dreadstalkers | Dreadstalkers moved to `maintenance` for AoE to ensure constant refresh |
| `cooldowns` | Nether Portal → Summon Demonic Tyrant → Grimoire: Felguard | Tyrant promoted vs Grimoire in AoE — faster board stacking |
| `core` | Hand of Gul'dan → Implosion | HoG spawns imps; Implosion then detonates them into the pack |
| `pressure` | Demonbolt → Bilescourge Bombers | Core spend + supplemental AoE |
| `filler` | Shadow Bolt → Soul Strike | ST fallback filler |

**Implosion timing note:**
> Implosion detonates all Wild Imps. Cast it when ≥3 imps are active on-target. Premature Implosion on 1 imp wastes the burst. In the AoE profile, Implosion is in `core` to maximize priority — but the spell won't fire if no imps are active, so it naturally self-gates.

### 3.4 Sequence: `Demonology_Diabolist_ST_Optimized`

**Use case:** Raid ST with Diabolist hero talents — slower paced, favors Crit + Mastery stat weights.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Doom → Hand of Gul'dan | Identical to SoulHarvester ST |
| `cooldowns` | Nether Portal → Grimoire: Felguard → Summon Demonic Tyrant | Same ordering for QUIRK-022 compliance |
| `core` | Call Dreadstalkers → Demonbolt | Dreadstalkers before Demonbolt always |
| `pressure` | Guillotine → Soul Strike | **Guillotine** replaces Implosion in Diabolist — different spell, different function |
| `filler` | Shadow Bolt → Bilescourge Bombers | Standard |

**Diabolic Ritual management:**
> Diabolist hero talent activates Diabolic Ritual buff through Chaos Bolt cycles and major demon summons. In Demo Diabolist, the ritual is triggered via Tyrant/Portal windows rather than Chaos Bolt. Prioritize normal Tyrant cycling — the ritual buff handles itself through the existing sequence.

**Stat priority (Diabolist):** Crit > Mastery > Haste > Versatility. More Crit = heavier Chaos Bolt / Demonbolt hits during Diabolic Ritual.

### 3.5 Sequence: `Demonology_Diabolist_AOE_Optimized`

**Use case:** Mythic+ / raid cleave with Diabolist — bread-and-butter M+ build, strong multi-target burst.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Doom → Call Dreadstalkers | Dreadstalkers in maintenance ensures constant board refresh |
| `cooldowns` | Nether Portal → Summon Demonic Tyrant → Grimoire: Felguard | AoE ordering — Tyrant before Grimoire |
| `core` | Hand of Gul'dan → Implosion | Same as SoulHarvester AOE |
| `pressure` | Demonbolt → Guillotine | **Guillotine** added vs SoulHarvester AOE |
| `filler` | Shadow Bolt → Bilescourge Bombers | Standard |

**"Plays itself" note:** This profile auto-manages Demonic Rituals if the player doesn't overcap cores or shards. Overcapping either wastes the proc economy that makes Diabolist M+ strong.

**QUIRK-023 note:** The talent string for this AOE profile was previously incorrect (pointed to Diabolist ST string). It is now corrected to the Mythic+/Cleave talent import. See §9 for full details.

---

## 4. DESTRUCTION WARLOCK

### 4.1 Core Mechanics

- **Resource:** Soul Shards (5 max). Generated by Immolate ticks, Conflagrate, Incinerate.
- **Havoc:** Copies your next single-target spell to also hit the Havoc target. Critical for cleave.
- **Chaos Bolt:** Heavy-hitting channeled spender. Cast time requires the target to be CC'd or briefly CCd to land safely in PvP.
- **Cooldown stacking:** Summon Infernal + Dark Soul: Instability together for maximum burst windows.
- **Immolate is mandatory:** Never cast Chaos Bolt without Immolate running on target. Immolate generates the shards that feed the Chaos Bolt chain.

### 4.2 Sequence: `Destruction_Hellcaller_ST_Optimized`

**Use case:** Pure ST / patchwork boss fights.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Immolate → Wither | Immolate = shard generation + DoT; Wither = Hellcaller stacking debuff |
| `cooldowns` | Summon Infernal → Dark Soul: Instability | Stacking cooldowns; use together for max burst |
| `core` | Chaos Bolt → Conflagrate | Chaos Bolt = primary spender; Conflagrate = instant builder |
| `pressure` | Incinerate → Shadowburn | Incinerate = filler builder; Shadowburn = execute range finisher |
| `filler` | Channel Demonfire (nochanneling) → Cataclysm | Channel Demonfire requires Immolate active; Cataclysm applies Immolate to all nearby targets |

**No Havoc / no Mayhem note:** This is a pure ST profile. Havoc and Mayhem are not present — they're sacrificed for focused ST output. For cleave, use the Diabolist Cleave profile.

**Anti-patterns:**
- Casting Chaos Bolt without Immolate active (no shard income, spell misses proc optimization)
- Letting shards cap at 5 (capped shards = lost Conflagrate/Incinerate procs)
- Casting Channel Demonfire while already channeling another spell (blocked by `nochanneling` guard — do not remove this)

### 4.3 Sequence: `Destruction_Diabolist_Cleave_Optimized`

**Use case:** Cleave fights, council encounters, Havoc cleave, M+ burst packs.

**Spell priority order:**

| Block | Spells | Notes |
|-------|--------|-------|
| `maintenance` | Immolate → Havoc | Havoc replaces Wither here — maintaining Havoc on secondary target is the cleave engine |
| `cooldowns` | Summon Infernal → Dimensional Rift | **Dimensional Rift** replaces Dark Soul: Instability — AoE burst window alternative |
| `core` | Chaos Bolt → Rain of Fire | Rain of Fire = AoE shard spender for packed packs |
| `pressure` | Conflagrate → Incinerate | Standard builders |
| `filler` | Shadowburn → Cataclysm (nochanneling) | Cataclysm applies Immolate to all nearby targets — good opener |

**Havoc timing:**
> The Havoc window is ~8s. Macro tries to maintain Havoc via `maintenance` block (highest priority). Within Havoc, Chaos Bolt is the premier spell to cast (copied to Havoc target for double hit). Cataclysm inside Havoc = double Immolate application on spread targets.

**Diabolic Ritual management (Destruction Diabolist):**
> For Destruction, Diabolic Ritual activates through Chaos Bolt cycling. The sequence auto-handles this — just don't interrupt the Chaos Bolt chain during the Infernal window.

---

## 5. TALENT IMPORT STRINGS

These are the **talent loadout** strings (what you paste into the WoW talent UI — NOT the GSE import string). Use these to load the correct talent build for each sequence profile.

### Affliction

| Profile | Talent Import String |
|---------|---------------------|
| SoulHarvester ST (Raid) | `CkQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjBzMmlBAAYmZxyMzsYGAYssNwAmgZYLww2AAAwMAAAmZGzYmZDDzMzMzMDmZmZAAzAD` |
| Hellcaller AOE (M+) | `CkQAy0jxIDofkwJmoH7WhvESoZmhZGNbmx2MzYWGAAwMzsMbzMzyYAgZZZZMMmFz0YmZYLzGDLDAAAGAAYmZmZmZYmtZGzgZmZGDzMzAAMgB` |

### Demonology

| Profile | Talent Import String |
|---------|---------------------|
| SoulHarvester ST (Raid) | `CoQAAAAAAAAAAAAAAAAAAAAAAYmZmZGNbMMzMmlBAAAAAAYstMwAGwMsFyYzYM2mlZmZMDAYmZmZGgZGzMmZAAAGzMzYMDLDAD` |
| SoulHarvester AOE (M+) | `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjxmZGzyAAAAAAAM2WGYADYG2CZsYMGbzyMmxMAgZmZGzAMzMmxMzGAAYMzMmxgtZGgB` |
| Diabolist ST (Raid) | `CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjxmZGzyAAAAAAAAGzYYBGYZ0CNsYMGbzyMmxMAgZmZmZmZAGzYmZDAAMmZGzYGWGGwA` |
| Diabolist AOE (M+) | `CoQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGzyAAAAAAAAGzYYBGYb0CNsYMzYZ2mZmxMAwMjxMzMDwYGzYDAAMmZGzww2MGwA` |

### Destruction

| Profile | Talent Import String |
|---------|---------------------|
| Hellcaller ST (Raid) | `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLYmZxYsYGAAMzMmZmFLwAziRjZAMbxGDAAMGYsBAMzAzMmZAAAYmZmBAwMDD` |
| Diabolist Cleave (Raid/M+) | `CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLYmZxYsYGAAMzMmZmFwYGDLkB2GWoxCDAAMGYsBgZGAzMmZAAAYmZmBAwMDD` |

> These strings are also stored in `TALENT_STRINGS` in `shared/docs/gen_all_class_optimized_gse.py` (lines 408–415) and are embedded into the generated GSE import at build time.

---

## 6. PvP REFERENCE — ALL 3 SPECS

### 6.1 Affliction (PvP / RBG / Blitz)

**DR Map:**
| CC Spell | DR Category |
|----------|------------|
| Fear (Howl of Terror / Shadow Bolt proc) | Fear DR (own pool) |
| Shadowfury | Stun DR |
| Banish | Separate (demon/elemental only, niche) |
| UA silence on dispel | Not a traditional CC — no DR category |

**Swap-Kill Window:**
1. Full DoT stack on target (Agony + Corruption + Unstable Affliction if available)
2. Haunt applied (extends and amplifies DoT damage)
3. Dark Soul: Misery (if available)
4. Malefic Rapture dump — spend all available shards
5. Kill window: ~12 seconds
6. Prioritize UA stacks for dispel punishment — player who dispels gets silenced

**Defensive Trade Tree (use in this order):**
1. Unending Resolve — interrupt immunity + 40% DR. SAVE for kill swaps; do not blow preemptively.
2. Dark Pact — drains soul shard for large absorb shield; instant.
3. Soulstone — passive self-res safety net; works even if dead.

**CC Priority:**
- Shadowfury (AoE stun, instant, no cast) → Fear on secondary targets (separate DR = doesn't break Shadowfury DR chain)

**PvP Anti-Patterns:**
- Refreshing DoTs on kill target at <30% HP instead of spending casts on Malefic Rapture burst
- Using Unending Resolve preemptively at pull rather than saving for kill pressure
- Applying Fear to the kill target during the Malefic Rapture dump window (breaks your own burst)

---

### 6.2 Demonology (PvP / RBG / Blitz)

**DR Map:**
| CC Spell | DR Category |
|----------|------------|
| Shadowfury | Stun DR |
| Axe Toss (pet stun, Felguard) | Stun DR — SAME DR as Shadowfury in Midnight 12.0.5 |
| Fear | Fear DR (separate) |

> **Axe Toss + Shadowfury DR interaction:** Both land in the same stun DR pool. Back-to-back = diminishing returns apply. Space them ~18s apart if you need two stun events.

**Swap-Kill Window:**
1. Nether Portal activated
2. Call Dreadstalkers + Hand of Gul'dan (build demon board — this is NON-NEGOTIABLE before Tyrant)
3. Summon Demonic Tyrant cast
4. Spend remaining shards in Tyrant window (~15 seconds)
5. Axe Toss / Shadowfury for stun chain during Tyrant window

**Defensive Trade Tree:**
1. Unending Resolve → Dark Pact → Soulstone (same tree as Affliction)

**CC Priority:**
- Shadowfury (AoE instant stun) → Axe Toss (pet stun, space from Shadowfury for DR) → Fear (separate DR, use as peel)

**PvP Anti-Patterns:**
- Using Tyrant when kill target has an active immunity (Ice Block, Divine Shield, etc.) — Tyrant window is wasted
- Running into melee range unnecessarily — Demonology is still a caster; let the pets do the melee work
- Casting Tyrant with empty demon board (this is QUIRK-022 in PvP context)

---

### 6.3 Destruction (PvP / RBG / Blitz)

**DR Map:**
| CC Spell | DR Category |
|----------|------------|
| Shadowfury | Stun DR |
| Howl of Terror | Fear DR (separate) |
| Banish | Separate (limited targets) |
| Summon Infernal landing stun (1.5s) | Stun DR |

> **Infernal landing + Shadowfury chain:** Infernal's 1.5s landing stun → wait for it to expire → Shadowfury for second stun on different DR batch. This gives two clean stun events before the first DR resolves.

**Swap-Kill Window:**
1. Summon Infernal (Infernal landing stun: 1.5s)
2. Chain Shadowfury after Infernal stun expires (separate stun event OR same stun DR — see above)
3. Chaos Bolt chain within Havoc window
4. Total window: ~6–10 seconds of secured cast time
5. Chaos Bolt requires cast time — target must be stunned, CC'd, or interrupted to land in competitive settings

**Defensive Trade Tree:**
1. Unending Resolve — HOLD for kill swaps specifically; interrupt immunity is critical when a healer targets you during Chaos Bolt cast
2. Dark Pact — large absorb shield, instant cast
3. Burning Rush — mobile speed boost (costs HP every tick; use only when being chased out of kill range)

**CC Priority:**
- Shadowfury (AoE stun, no cast) is the opener — instant, guarantees Chaos Bolt cast begins
- Howl of Terror (AoE fear, separate DR) used AFTER Shadowfury wears off to extend CC chain

**PvP Anti-Patterns:**
- Casting Chaos Bolt into a Grounding Totem without checking its presence first (Totem absorbs the spell — always verify with nameplate focus)
- Using both Shadowfury and Howl of Terror before a Chaos Bolt cast completes (wastes second CC as defensive cover — only use first CC, hold second as cover)
- Using Burning Rush as a defensive CD opener (costs too much HP; use Unending Resolve or Dark Pact first)

---

## 7. GSE3 SEQUENCE INVENTORY

All 11 active Warlock sequences (8 endgame + 3 leveling). Located in: `classes/Warlock/gse/Warlock-Optimized-Midnight-GSE3.txt`

| Sequence Name | Spec | Hero Talent | Use Case | Spec ID |
|--------------|------|-------------|----------|---------|
| `Warlock_Affliction_SoulHarvester_ST_Optimized` | Affliction | Soul Harvester | Raid ST / patchwork | 265 |
| `Warlock_Affliction_Hellcaller_AOE_Optimized` | Affliction | Hellcaller | M+ AoE / multi-target | 265 |
| `Warlock_Demonology_SoulHarvester_ST_Optimized` | Demonology | Soul Harvester | Raid ST | 266 |
| `Warlock_Demonology_SoulHarvester_AOE_Optimized` | Demonology | Soul Harvester | M+ AoE / stacked 5-target | 266 |
| `Warlock_Demonology_Diabolist_ST_Optimized` | Demonology | Diabolist | Raid ST (Crit/Mastery focus) | 266 |
| `Warlock_Demonology_Diabolist_AOE_Optimized` | Demonology | Diabolist | M+ / multi-target raid cleave | 266 |
| `Warlock_Destruction_Hellcaller_ST_Optimized` | Destruction | Hellcaller | Pure ST / no cleave | 267 |
| `Warlock_Destruction_Diabolist_Cleave_Optimized` | Destruction | Diabolist | Cleave / Havoc / council | 267 |

**Leveling sequences (smart awareness — `[known:]` guards on every action):**

| Sequence Name | Spec | Hero Talent | Use Case | Spec ID |
|--------------|------|-------------|----------|---------|
| `Warlock_Affliction_Leveling_Smart` | Affliction | None (any) | Questing + dungeons 1-80 | 265 |
| `Warlock_Demonology_Leveling_Smart` | Demonology | None (any) | Pet-leveling 1-80 | 266 |
| `Warlock_Destruction_Leveling_Smart` | Destruction | None (any) | Burst-leveling 1-80 | 267 |

### Modifier Key Assignment (All Warlock Sequences)

These are set in `DAMAGE_VARS["Warlock"]` in the generator:

| Key | Action | Notes |
|-----|--------|-------|
| `ALT` | Spell Lock (Felhunter interrupt) | Only works if Felhunter/Observer is active pet |
| `CTRL` | Mortal Coil | CC + 20% self-heal — use off-rotation |
| `SHIFT` | Unending Resolve | Major defensive CD — do NOT macro into rotation body |

> These are bound to KeyPress/KeyRelease events in GSE, not inside the main rotation loop. They fire when the modifier is held at the moment of button press.

### GSE3 Import Strings (what you paste into the GSE addon `/gsestudio import` box)

These are in `Warlock-Optimized-Midnight-GSE3.txt` and are the **encoded GSE3 package strings** (not talent strings). Rebuild with:
```
python shared/docs/gen_all_class_optimized_gse.py Warlock
```

---

## 8. GENERATOR USAGE

### File Location
```
shared/docs/gen_all_class_optimized_gse.py
```

### Run to Regenerate All 8 Warlock Sequences
```bash
python shared/docs/gen_all_class_optimized_gse.py Warlock
```
Output: `classes/Warlock/gse/Warlock-Optimized-Midnight-GSE3.txt`

### Run to Regenerate All Classes
```bash
python shared/docs/gen_all_class_optimized_gse.py
```

### Where Warlock Sequences Live in the Generator (line references)

| Section | Lines | Content |
|---------|-------|---------|
| `TALENT_STRINGS` dict | 408–415 | All 8 Warlock talent import strings |
| `SEQUENCES["Warlock"]` dict | ~927–980 | Spell lists per block per profile |
| `DAMAGE_VARS["Warlock"]` | ~300–320 | ALT/CTRL/SHIFT macro key bindings |

### How to Add a New Warlock Sequence

1. Add spell blocks entry to `SEQUENCES["Warlock"]` following the exact block format:
   ```python
   "Warlock_NewSpec_NewHero_Mode_Optimized": ("Warlock", SPEC_ID, "damage", "Hero Talent Name", {
       "maintenance": [...],
       "cooldowns": [...],
       "core": [...],
       "pressure": [...],
       "filler": [...],
   }),
   ```
2. Add the talent import string to `TALENT_STRINGS`:
   ```python
   "Warlock_NewSpec_NewHero_Mode_Optimized": "TALENT_STRING_HERE",
   ```
3. Run the generator and verify output.
4. Update `QUIRKS_KNOWLEDGE_BASE.md` and `RUNBOOK.md` if any new quirk was discovered.
5. Update this document's sequence inventory table (§7).

### How to Modify an Existing Sequence

1. Edit the spell blocks in `SEQUENCES["Warlock"]` — do NOT edit the `.txt` file directly; it is generated output.
2. If reordering blocks affects the Priority triangular sweep (QUIRK-013), document it.
3. Regenerate: `python shared/docs/gen_all_class_optimized_gse.py Warlock`
4. Verify the output in `Warlock-Optimized-Midnight-GSE3.txt`.
5. Document the change in `RUNBOOK.md`.

### Block Execution Model (Priority StepFunction)

The generator uses `StepFunction = "Priority"` for all Warlock sequences. Execution model:

```
Keypress 1  → attempts: maintenance[0]
Keypress 2  → attempts: maintenance[0], maintenance[1]
Keypress N  → attempts: maintenance[0..N-1]
On first successful cast → depth resets to 1
```

**Block order matters:** `maintenance` runs at the shallowest depth (attempted most). `filler` runs at the deepest depth (attempted least). Place your most critical spells in `maintenance` position 0.

---

## 9. GSE3 QUIRKS AFFECTING WARLOCK

These are documented in `shared/docs/QUIRKS_KNOWLEDGE_BASE.md`. Full entries are there; this section is the Warlock-specific extract.

---

### QUIRK-013 — Priority StepFunction Uses Triangular Depth Model

**Scope:** ALL sequences using StepFunction = "Priority" (all Warlock sequences)
**Status:** Active — permanent design constraint

**What most devs get wrong:**
> Priority does NOT evaluate all N actions per keypress and fire the first usable one.

**Actual behavior:**
> On keypress K, only the first K actions (across all blocks concatenated) are evaluated. The depth resets to 1 after any successful cast. Action 1 is attempted far more often than action 7.

**Warlock impact:**
- The most critical spell must be at position 1 of the first block.
- For Demo: `Doom` (maintenance[0]) is attempted most often — correct, it's the DoT baseline.
- For Affliction: `Agony` (maintenance[0]) is attempted most — correct.
- For Destruction: `Immolate` (maintenance[0]) — correct.
- Fillers in the last block will only fire after many keypresses without a successful cast earlier in the chain.

**Key design rule derived from this quirk (QUIRK-022):**
> Demo: put `Call Dreadstalkers` in the `core` block (not `pressure`), and put `Summon Demonic Tyrant` LAST in the `cooldowns` block. This ensures Dreadstalkers builds the demon board before Tyrant is deep enough to fire.

---

### QUIRK-014 — Banned Macro Conditionals (Silent No-Op)

**Scope:** ALL classes. Warlock-specific: Affliction and Destruction sequences previously affected.
**Status:** Fixed in all current Warlock sequences. Watch for regression.

**Banned conditionals — never use:**
```
[nodebuff:SpellName]
[nobuff:SpellName]
[buff:SpellName]
[debuff:SpellName]
[hp<X]
[health<X]
[mana<X]
```

**What happens if used:** WoW evaluates unknown conditionals as `false` → the cast silently never fires → the spell appears in the sequence but does nothing.

**What to use instead:**
```
[nochanneling:SpellName]  — only prevents cast while that specific spell is channeling
[@target,harm,nodead]     — standard valid targeting conditional
[combat]                  — only in combat
[mod:alt]  [mod:ctrl]  [mod:shift]  — modifier key gates
```

**Verification:** Run `full_audit.py` against all Warlock `.txt` files — must show ZERO `[BANNED]` entries.

---

### QUIRK-022 — Demonology Priority Ordering: Demon Board Before Tyrant

**Scope:** All Demonology sequences (all hero talents)
**Status:** Active — permanent design constraint

**The problem:**
> Summon Demonic Tyrant extends all active demon durations and grants Demonic Power. If Tyrant fires before Call Dreadstalkers and Hand of Gul'dan imps are active, the buff window is wasted on a thin demon roster.

**Root cause (historical):**
> Previous SoulHarvester ST sequence had Tyrant FIRST in cooldowns block and Dreadstalkers FOURTH in pressure block. The Priority triangular model (QUIRK-013) means cooldowns are attempted more frequently — Tyrant was firing before Dreadstalkers ever went out.

**Enforced rule (all Demo sequences):**
```
cooldowns block: [Nether Portal, Grimoire: Felguard, Summon Demonic Tyrant]
                                                              ↑ LAST
core block:      [Call Dreadstalkers, Demonbolt]
                  ↑ FIRST IN CORE
```

**Never:**
- Put Dreadstalkers in `pressure` or `filler`
- Put Tyrant first or second in `cooldowns`
- Place Dreadstalkers after Demonbolt in the same block

**Verification:**
```bash
python shared/docs/gen_all_class_optimized_gse.py Warlock
# Inspect output: Dreadstalkers must appear in core block for all SoulHarvester profiles
# Nether Portal must precede Summon Demonic Tyrant in cooldowns for all Demo profiles
```

---

### QUIRK-023 — Demonology Diabolist AOE Talent String Used Wrong Build

**Scope:** `TALENT_STRINGS["Warlock_Demonology_Diabolist_AOE_Optimized"]`
**Status:** Fixed (2026-05-08)

**What happened:**
> When Diabolist profiles were first added, both ST and AOE shared the same talent string — the Diabolist Raid ST string. Users who imported the AOE sequence got the wrong talent loadout (ST build, not the M+/AoE cleave build).

**Fix applied:**
```python
# BEFORE (wrong):
"Warlock_Demonology_Diabolist_AOE_Optimized": "<ST talent string>",

# AFTER (correct):
"Warlock_Demonology_Diabolist_AOE_Optimized": "CoQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGzyAAAAAAAAGzYYBGYb0CNsYMzYZ2mZmxMAwMjxMzMDwYGzYDAAMmZGzww2MGwA",
```

**Enforced rule:** ST and AOE Diabolist sequences must ALWAYS use separate, independently sourced talent strings. Do not copy one from the other.

**Verification:**
```bash
python shared/docs/gen_all_class_optimized_gse.py Warlock
grep "Demonology_Diabolist_AOE" classes/Warlock/gse/Warlock-Optimized-Midnight-GSE3.txt
# Should contain the AOE talent string on import, not the ST string
```

---

## 10. DEVELOPER ONBOARDING

### Who Is This For

Another developer picking up Warlock work in this project. This section tells you exactly where everything lives and what to do first.

### Folder Structure

```
WOW-MIDNIGHT-GSE-BUSSYBLASTR-BARGAIN-BIN/
└── classes/
    └── Warlock/
        ├── WARLOCK-DEVELOPER-REFERENCE.md   ← you are here
        ├── gse/
        │   └── Warlock-Optimized-Midnight-GSE3.txt  ← generated GSE import file (DO NOT EDIT)
        ├── research/
        │   ├── Warlock-from-combined-research.md    ← PRIMARY research source
        │   └── Warlock-research-index.md            ← index / changelog for research updates
        ├── scripts/
        │   └── (any Warlock-specific scripts)
        └── specs/
            └── (per-spec notes if added)

shared/
└── docs/
    ├── gen_all_class_optimized_gse.py       ← THE generator — primary source of truth for sequences
    ├── QUIRKS_KNOWLEDGE_BASE.md             ← every known quirk + fixes
    └── RUNBOOK.md                           ← build + audit + deploy workflow
```

### Where NOT to Edit

| File | Why Not |
|------|---------|
| `classes/Warlock/gse/Warlock-Optimized-Midnight-GSE3.txt` | Generated output — regenerated on every run; manual edits are overwritten |
| Bussyblastr/archive/ | Read-only historical reference; not current |

### First 10 Minutes Checklist (Before Any Work)

- [ ] Read `shared/docs/QUIRKS_KNOWLEDGE_BASE.md` — look for any Warlock entries
- [ ] Read `shared/docs/STRICT_RUNBOOK_DEVELOPMENT_RULES.md` — logic change enforcement rules
- [ ] Read `shared/docs/MIDNIGHT_AGENT_DOCS_GUIDE.md` — source map + safety rules
- [ ] Read `classes/Warlock/research/Warlock-from-combined-research.md` — full rotation research
- [ ] Read this document (done if you're here)

### Before Any Logic Change

1. Can you describe EXACTLY what spell fires when, and why, in the current sequence? If not, read §8 on the Priority model first.
2. Does your change require a new quirk entry? If the answer is "this didn't work as expected and I had to figure out why" — YES, write a QUIRK entry.
3. Did you update `RUNBOOK.md` with a changelog entry?
4. Did you regenerate the output file and verify it?

### Common Mistakes — Don't Repeat These

| Mistake | What Happened | Fix |
|---------|--------------|-----|
| Tyrant firing before demon board exists | Tyrant was first in cooldowns block; Demo board spells were in pressure block | QUIRK-022: Tyrant last in cooldowns; Dreadstalkers in core |
| Wrong talent string for Diabolist AOE | Both ST and AOE Diabolist shared the same ST talent string | QUIRK-023: each profile needs its own sourced talent string |
| Spell silently never firing | Used `[nodebuff:]` or `[hp<X]` conditional | QUIRK-014: use only valid WoW macro conditionals |
| "Wrong" spell firing at wrong time | Misunderstood Priority model as "first available wins" | QUIRK-013: it's a triangular sweep — most critical spell goes at position 1 |
| Editing the .txt file directly | It's generated output and gets overwritten | Always edit the generator; regenerate; check output |

### Spell Names to Watch

Some Midnight renames / removals affect Warlock specifically:

| Old/Expected Name | Midnight Reality | Notes |
|-------------------|-----------------|-------|
| Unstable Affliction | Still exists in 12.0.5 but scope-limited | Check talent tree for whether the build includes it |
| Phantom Singularity | Removed from Midnight | Do not add to any sequence |
| Soul Rot | Talent-only (not baseline) | Present in SoulHarvester builds, not universal |
| Dark Ascension | Removed from game | Never add to any sequence |

### Research Source Hierarchy (for updating rotation data)

1. Blizzard official patch notes
2. Method.gg (primary for Warlock — they source Warlock ST builds)
3. Icy Veins (cross-spec, M+ focus)
4. Maxroll.gg (M+ rotation priority)
5. Wowhead / Warcraft Logs
6. Reddit r/CompetitiveWoW (last resort, needs corroboration)

Minimum 10 independent sources before committing any rotation change. Single-source claims go in `Warlock-from-combined-research.md` notes only, not into GSE sequences.

### Changelog

| Date | Author | Change |
|------|--------|--------|
| 2026-05-08 | Agent | Initial creation — all 8 sequences documented |
| 2026-05-08 | Agent | Added QUIRK-022 (Demo demon board ordering) |
| 2026-05-08 | Agent | Added QUIRK-023 (Diabolist AOE talent string fix) |
| 2026-05-08 | Agent | Added 2 new Demo profiles (SoulHarvester AOE, Diabolist ST) |
| 2026-05-08 | Agent | Fixed Diabolist AOE profile (wrong talent string corrected) |
| 2026-05-08 | Agent | Added 3 leveling smart-awareness sequences (Affliction, Demonology, Destruction) |

---

## 11. LEVELING ROTATIONS — SMART AWARENESS

### What "Smart Awareness" Means

Each leveling sequence uses `[known:SpellName]` macro conditionals on every action. This is the standard WoW macro conditional that checks if the player currently has the spell in their spellbook (baseline or talented). If the spell is not yet learned, the action is silently skipped by GSE3 and the loop continues to the next available spell.

**Result:** A single sequence works at every level from 1 to 80. As the character levels up and learns new abilities, the sequence automatically begins using them — no manual updates required.

**Generator mechanism:** The `leveling_damage_actions()` function in `gen_all_class_optimized_gse.py` applies `with_known_guard()` to every macro before encoding. Endgame sequences use `damage_actions()` instead (no `[known:]` guards — all spells are assumed available).

**No talent strings** are assigned to leveling sequences. Talent trees are being earned during leveling so no single endgame talent import applies.

### 11.1 Affliction Leveling — `Warlock_Affliction_Leveling_Smart`

**Spec ID:** 265 | **Use Case:** Questing, dungeons, level 1–80 solo/group content

**Spell priority (fires in order; skips unknowns):**

| Block | Spells | Available From |
|-------|--------|---------------|
| `maintenance` | Corruption → Agony → Unstable Affliction | DoTs online ASAP |
| `cooldowns` | Darkglare → Soul Rot | Talent / high-level unlock |
| `core` | Malefic Rapture → Haunt | Mid-level Affliction toolkit |
| `pressure` | Drain Soul (nochanneling) → Drain Life | Drain Soul = filler + execute; Drain Life = self-sustain |
| `filler` | Shadow Bolt → Vile Taint | Shadow Bolt available from level 3 — always the baseline fallback |

**Leveling notes:**
- At very early levels, only Corruption and Shadow Bolt will fire; the rest auto-unlock as levels are gained.
- Drain Life provides passive self-sustain; it fires when nothing else in `pressure` block is available (e.g., before Drain Soul is learned).
- Darkglare and Soul Rot are talent-dependent — they fire only once acquired via the talent tree.

**GSE3 Import String:**
```
Warlock_Affliction_Leveling_Smart
!GSE3!rVVNb9tGEK3bU4H+gCan7aUtCpqOnRZtfSpDWhJjKjEk2RIQBMaYHIoLLXfZ3aVc+uQGyF/ouXA+bvl1RXpr0SElWVYgwQ3gE4mZ2ffefOzsi9FXQ9BCxZNTL00Fjy1X8jTCKQoux6f9HLR9cxiBscdFAhaT+/zf6pNwiDDxSg3msnOC2tAZ8/tV22tOm5dvg0FVYBApVUR9i0WrlI2nc6S50txWrR4WCHZr69VBDrFWox93YqJgzyZSnct9X2ldFvUJ5xcLeozWyUDnjlQJQvKcLf0NUWvGG1j6n+F9usDdXsH1xkpW6yEb1wa0zxZo4QrasTQWzgSyZeHWY68J3MD05qML9+2KpAD0ZCxAoxOr/Azsc3Ztua1SX68A9VUpWE/Za5yF4c6Eeyt8XRCY8pj1oLAlyV9bxw+CPq73HSilXY/buO4ssWC1Ixq4bKpHdHEGUjYXa72QZfBtuf20hiTiKX5AUgioUC+A64A7S/Pn1XnJIFHn7JESG2p8I+C23FZ3wQmnizMg+RuAl/4NuEehPCu5sCegeX0LzZ/h9e9V5xCrI43GvPZ2R/d3ZgQoMa/YM6kaoobG2xu5c1m5SvZhY5oFCsEiWqfew9GDGydiq8WGqVbagqCdxoX3/ei7G2dMxlO7bOKxRJlQW1kPjRJTfEzaeygQDF55u9EOLRlCshaIfG/0zRxodoE3o3S6aCEAC+9aXmkzpQ99VXCh7PZQDVuUTxwG97Y+D55Ajv/jrWgP6JJKS++Cn2E8MWX+dxTQ6MgEZczRvFoW/7LVrftjLsM+/lqSm0ztAFMohd163O4fzF+We1/8dRigiTVvVv4IuzyRfJxZtrvnPnB/YIrsOb/AhM3l3Vi0bCGPNfJc1kGt9pknK5c9TWmbcKo9cT1kbQ0JrWhGdVKldYMOimL0j08CzfYUBG9eP2ZUqWNkpq7yPnsk+MUF6MRhQ3WeUTsdRuXMFH3DuGInyKUhU0mqJg7zdJzRG1GrjDWkluZkTO4+z0sBtVi/tjosFkCc1Li8lHT15pzGZV40YDTo2Lx+O/gb/UkQDvMHvYiVlguKJrxO2BqwBFOUhk/Rpb0pS8qSdkDC/MAwjXm9DmYTwWIlrVZCUHKUApmV4bUYEO7gQKaKqH2VFzQhZw3B+94ML6yFTKnXFPvef9rtf/nHfw==
```

---

### 11.2 Demonology Leveling — `Warlock_Demonology_Leveling_Smart`

**Spec ID:** 266 | **Use Case:** Questing, dungeons, level 1–80 — pet-focused leveling

**Spell priority (fires in order; skips unknowns):**

| Block | Spells | Available From |
|-------|--------|---------------|
| `maintenance` | Doom → Hand of Gul'dan | Doom = persistent DoT; HoG = imp generator |
| `cooldowns` | Summon Demonic Tyrant → Grimoire: Felguard → Nether Portal | High-level summon CDs; skipped until learned |
| `core` | Call Dreadstalkers → Demonbolt | Primary Demo loop — demon spending |
| `pressure` | Soul Strike → Implosion | Soul Strike generates Demonic Cores; Implosion detonates imps |
| `filler` | Shadow Bolt → Bilescourge Bombers | Baseline filler until Demo toolkit fills in |

**Leveling notes:**
- At early levels, only Shadow Bolt fires (all other spells are talent/higher-level unlocks).
- Once Doom and Hand of Gul'dan unlock, the pet-based loop activates automatically.
- Summon Demonic Tyrant / Nether Portal will not fire until correctly talented at higher levels — the `[known:]` guard handles this.
- The pet (Imp/Felguard) acts as both damage dealer and tank for solo questing — do NOT dismiss it during leveling.

**GSE3 Import String:**
```
Warlock_Demonology_Leveling_Smart
!GSE3!tVVNb9tGEK3bW9Ef0OQ0PQVoFTl2mkN1Ck1aEmMpMSTFEhAYxogciQstd9ndpVz65AbIX+i5cJre+uuK9NaiQ0lWzEaCa6A9kZiZfe/N1+7r0VdDNFJHs7OAUq201NPirENzkkJNz/opGvfuqIPWvcxidBTfF38Vn4RDwpmXG7SX7RMyVmhlf7xqeZEr/968CwZFRkFH66zTd5Q1c7XwtI+N0Ea4otmjjNDt7Lw9TDEyevTNbsQU8Gqm9LlqBFqntacOzZRcLUGT1pSOCeNTKD0L8OaSK3D8v8T49BrLq2C1UcWgJ9DK5YMY1WbYfwRtYfj1zmk9rUjp5ylXGBZ1FhEMCoPK1SKdjtGdwkbvbbk2KgQtI1ItDDWgSXKao4nX6B+7tkB/dg39qAL9nFxCBo61cSjXqBXrFsC7D0OrwuyjlBAY7pNlkhlP2+Yefhx3W/GeVIeuLPxYS7dl8q7d/1ma31WHQ+cS+s6IGW0WcCPgbomFaSZ1uaKbcdfu/yuxBGN9DgdbK3sj4LbEwgrygZBkI50zJJ9Ox1tHY0PgFqbjUI1zId0JGoFjPvVzuP69ah9RcWzI2l+8vdH93SUTKUoLeKX0gnHB5+2P6iuhqY4buDXxjHhkO3z3eo/X61aeiJyRm490F5sGvhbS+3b09Y0zNhET5skkFmRO4aUiFfMNDj2yWs7pGWvvkSS0dOXtdXZ5RxjJOWTy/dGDFdByr7ejtLvkMECHvzW93CXaHPk6E1K7h0M9bHI+URjc2/k8eI4p/YuHpTVAScrxI+InFM1snv7RCXiYVEwqEmTffij+ZbNb9sdehn36Pmc3m1oBTTCXbudZq3+4eobuffH7UcDNNiIrWzuiroiVmCYO9vbrj+pPQLM9FRcUw0oefJAH1/JgIa8ObTK6AZ4q6vBiMhGR4Noz12O+TjEm8IDrpHNXD9oks9GfPgu0D+coxeKpBMsjFxHYssoNOJDi4qK8k2GozxNuZw24nInmbxgVcEJCWTblrGpWA89ECa9sqTIyOHE8J1N290WaSyxT80trDSKJzMmNS3PFy7jitHXwOgMQypExeeZ26Qf+U3x1gz/odSB3QnI047XD5gBimpCyYk516KLKOUuDIgY/sGAoRaFgOREQaeWMlpKT4xTYzDdHKQZlfXCoJpqpfZ1mPCHjBcH73hIvLIXMudcc+95/0e1/+dPf
```

---

### 11.3 Destruction Leveling — `Warlock_Destruction_Leveling_Smart`

**Spec ID:** 267 | **Use Case:** Questing, dungeons, level 1–80 — highest burst damage while leveling

**Spell priority (fires in order; skips unknowns):**

| Block | Spells | Available From |
|-------|--------|---------------|
| `maintenance` | Immolate | Available early — fire DoT to enable Conflagrate |
| `cooldowns` | Summon Infernal → Dark Soul: Instability | Major burst CDs; skipped until learned |
| `core` | Chaos Bolt → Conflagrate | Primary nuke; Conflagrate = shard generator + cleave |
| `pressure` | Incinerate → Shadowburn | Incinerate = shard builder; Shadowburn = execute |
| `filler` | Channel Demonfire (nochanneling) → Rain of Fire | AoE/nuke filler; Channel Demonfire skipped if channeling |

**Leveling notes:**
- Destruction is the simplest of the three — even at level 10 you have a complete working loop (Immolate → Conflagrate → Incinerate).
- Chaos Bolt requires Soul Shards. Shards are generated through Incinerate and Conflagrate — the sequence naturally builds them before spending.
- Summon Infernal and Dark Soul: Instability fire automatically once learned; no manual activation needed.
- Shadowburn is an execute on sub-20% HP targets — fires naturally when the target is low.

**GSE3 Import String:**
```
Warlock_Destruction_Leveling_Smart
!GSE3!tVVLb9tGEK57bX9Ak9OglwKFIsd2gqLqpbRoSYylxhAVS0BgGCNyKC603GX3IVc+uQHyF3ounOSYXxcktxYdPRxLgQS3QHoiMbPzfd+8dl8Mvu2jkToZn4dknfGJE1qdt2lCUqjReVygcW+O22jdszJFR+l98ff0i6hPOA68QXvVOiVjOcb+ft0M5tH25euwNy0pbGtdtmNHZcOruad1YoQ2wk0bXSoJ3c7Oq6MCE6MHB7sJU8DzsdIXqhYVhZZMVvnZoRmRq+RoiorSKWF6BjfeOUljwRk6/l9gvfnP5I/WyGPP+AoilZFRKCuJLobozuAT+xb2L29AD9dAQzRjiLWXNQawDodCspKP2Jvdny3BH9a01HPUFg61dJvre+u/K8cf13G1yiSOzNbGrRz4n1KLVCIUbVdw678rtXXcOMdUXwy9UZtxb/2fLbHupz1TiiSExDOYCUNMnSxsvKZb+7gec1fOP61RdlEo0Bk0ZmwbCVZPbME+idTQC+lO0QgcSrJ/Rh9/r1vHND0xZO3rYG9wf3dBQYqKKTxXek41Jwr2B9WltEKnNdw2uHFJUkKbL7PgYPBwJSJxRm4O6WjjUPJkChk8Gny/EmNzkTFPKXFK5gyeKVIplxq6ZLWc0BPW3iVJaOk62Gvv8tIyknPI5PuD75ZAi/3ejtLqkMMQHb5tBN7l2hzXdSmkdg/6ut/gfJIovLfzVfgLFvRvbupmDyUpx7dyPadkbH3xoR3yYKmUePLJvrqt/lWjM2uQvYpi+tWzm03NkDL00u08acZHy3v93tfvjpkwMaKcEQ6yjkiVGOUO9varD6uPQbO9EJeUwlIfrOiDG30w11eFFhldg0BNq/A0y0QiuPpMdgBNgylBAFwp7V01bJEsB3/VWaF9MEEp5o8PWO1NQmBnda7BoRSXl2jSCvT1Rc4NrQAXNNf8jZIpnJJQlk2eZY0rEJgk16oyk5kYzBxPyojdsSg8Pycstj6zViCRyJzcusIr3swlp61C0O6BUI6M8aXbpd/c4oGAeq/bBu8WVzrErajRg5QyUlZMqAodVJ6zNChSqIcWDBWzxVnMBCRaOaOl5OQ4BTZrK2ZiUFZ7RyrTTF3XRYk3j8L77gIvmgmZcLP57Pv60078zR//AA==
```

---

### 11.4 Leveling Sequence Inventory

| Sequence Name | Spec | Use Case | Spec ID | Has [known:] Guards |
|--------------|------|----------|---------|---------------------|
| `Warlock_Affliction_Leveling_Smart` | Affliction | Questing + dungeons 1-80 | 265 | ✓ Yes |
| `Warlock_Demonology_Leveling_Smart` | Demonology | Pet-leveling 1-80 | 266 | ✓ Yes |
| `Warlock_Destruction_Leveling_Smart` | Destruction | Burst-leveling 1-80 | 267 | ✓ Yes |

### 11.5 How `[known:]` Guards Work

Example — Affliction at level 3 (only Corruption known):
```
Keypress 1  → attempts: [known:Corruption,@target,harm,nodead] Corruption   → FIRES ✓
Keypress 2  → attempts: [known:Corruption,...] + [known:Agony,...] Agony     → Agony SKIPPED (unknown) ✓
Keypress 3  → attempts above + [known:Unstable Affliction,...] UA            → UA SKIPPED ✓
...
Eventually: [known:Shadow Bolt,...] Shadow Bolt                               → FIRES ✓ (baseline filler)
```

At level 40 when Agony is learned:
```
Keypress 1  → [known:Corruption,...] → FIRES ✓
Keypress 2  → [known:Corruption,...] + [known:Agony,...] → Agony now FIRES ✓
```

**Anti-patterns to avoid with leveling sequences:**
- Do NOT add hero talent spells (Soul Harvester, Hellcaller, Diabolist exclusives) to leveling sequences — hero talents unlock at max level only.
- Do NOT assign a talent import string to leveling sequences — leveling talent trees are fluid.
- Do NOT use the leveling sequences for max-level endgame content — use the spec-specific endgame sequences in §7 instead.

### 11.6 Regenerating Leveling Sequences

The same generator produces endgame and leveling sequences:
```bash
python shared/docs/gen_all_class_optimized_gse.py Warlock
```
Output: `classes/Warlock/gse/Warlock-Optimized-Midnight-GSE3.txt` (contains all 11 sequences: 8 endgame + 3 leveling)

If you add a new spell to a leveling profile:
1. Edit `PROFILES["Warlock"]["Affliction_Leveling_Smart"]` (or Demo/Destro) in `gen_all_class_optimized_gse.py`
2. Re-run the generator
3. Update the import string in this section (§11.x)
4. Update the Changelog below
