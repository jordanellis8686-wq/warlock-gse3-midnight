# Warlock - Midnight Research Split

**Patch**: 12.0.5 | **Workflow**: `../../shared/docs/CLASS_RESEARCH_REFRESH_WORKFLOW.md` | **Last Updated**: 2026-05-08

---

## Midnight Spellbook Changes

| Change | Detail |
|--------|--------|
| **Removed** | Phantom Singularity, Soul Rot |
| **Active (NOT removed — see QUIRK-031)** | Unstable Affliction — redesigned as primary burst layer; NOT removed in Midnight |
| **Added** | Diabolic Ritual, Wither (companion DoT alongside UA — talent-dependent) |
| **Changed** | Agony tick rate increased; Chaos Bolt generates Shards on crit; Demonbolt 40 Shards (was 60); Affliction May 5: UA +20%/SoC +10%/Corruption +20%/Agony +10% PvE; Destruction PvP +5% |

## PvE Priority

### Affliction
- Agony → Corruption → Unstable Affliction (primary burst layer) → Seed of Corruption AoE
- Wither: maintain alongside UA when Wither is talented (companion DoT — separate from UA)
- Malefic Rapture as Shard dump; Vile Taint on cooldown
- Diabolic Ritual: Ritual stack management — do NOT interrupt
- Soul Rot removed — old execute pattern changed; UA now fills the burst layer role
- Affliction UA +20%, Corruption +20%, Agony +10% May 5 — **Affliction is the strongest PvE spec in 12.0.5**

### Demonology
- Hand of Gul'dan (3 shards) → Demonic Calling proc → Dreadstalkers → Tyrant aligned
- Demonbolt cost 40 (was 60) — more frequent; spend before Wild Imps expire
- Diabolic Ritual: maintain ritual buff through Tyrant window
- Implosion on 4+ imps for AoE; Doom on boss target maintained
- Demonology recommended for leveling (safest/fastest)

### Destruction
- Chaos Bolt as primary spender; now generates Shards on crit — higher Shard income
- Immolate → Conflagrate (2 charges) → Chaos Bolt; Infernal on cooldown
- Channel Demonfire for AoE; Rain of Fire on 3+ targets
- Diabolic Ritual: Ritual proc aligns with Infernal window
- Destruction PvP +5% May 5

## PvP Priority

### Affliction
- Kill window: UA stack + Vile Taint + Malefic Rapture drain on CC'd healer or swap target
- Wither maintained on kill target; DoT blanket on team if possible
- Mortal Coil for CC + self-heal; Curse of Exhaustion slow; Howl of Terror fear
- Siphon Life for sustained self-healing under swap

### Demonology
- Hand of Gul'dan → Dreadstalkers → Felguard Axe Toss stun → burst inside stun
- Tyrant on swap target with full imp spawn; Demonbolt spam inside tyrant
- Portal kiting; Shadowfury stun for peel

### Destruction
- Chaos Bolt during CC; Destruction PvP +5% — improved Chaos Bolt burst potential
- Conflagrate slow; Shadowfury stun; Rain of Fire zone control
- Infernal at start of kill window for intimidation/interrupt potential

## Leveling Priority

**Demonology safest and fastest**: Felguard tanks, Soul Stone for safety net, Demonbolt spam.
**Affliction viable**: DoT-and-run; excellent for world content and rare farming.
**Destruction**: strong burst but mana-hungry; better at 70+.

## Talent-Driven Priority Shifts

| Hero Talent | Content | Priority Shift |
|-------------|---------|---------------|
| Hellcaller | Affliction all | Wither DoT management as 2nd maintained debuff alongside UA |
| Diabolist | Demonology/Destruction | Diabolic Ritual stacks prioritized; Ritual buff windows change CD alignment |
| Soul Harvester | Affliction alt | Cunning of the Deceiver passive; Shard recovery mechanics adjust drain usage |

## Confidence And Conflicts

- **Confidence**: HIGH — post QUIRK-031 fix; UA active status confirmed across UNIFIED_CLASS_INFO.md
- **Conflicts**: QUIRK-031 (resolved — UA was incorrectly listed as removed; now corrected)
- **Sources**: UNIFIED_CLASS_INFO.md, Warlock-research-index.md, QUIRKS_KNOWLEDGE_BASE.md QUIRK-031

---

# WARLOCK

## Affliction Warlock

### Hero Talents
- **Soul Harvester** - Recommended for most content, Dark Harvest focused
- **Hellcaller** - Alternative, superior AoE but worse single target

### Apex Talent
- **Shadow of Nathreza** - Enhances shadow spells

### Talent Import Strings

#### Raid 25m - Soul Harvester Single Target
- **Source**: Icy Veins
- **ST Priority**: Spend shards aggressively to reduce Dark Harvest cooldown, maintain Cascading Calamity
- **Cleave Priority**: Seed of Destruction, Sow the Seeds, Patient Zero for multitarget
- **Key Mechanics**: Shard abundance reduces importance of Drain Soul sniping

#### Mythic+ - Soul Harvester AoE
- **Source**: Icy Veins
- **ST Priority**: Better damage at lower target count, multitarget scaling
- **Cleave Priority**: Seed of Destruction, Sow the Seeds, Patient Zero
- **Key Mechanics**: Spend shards fast for frequent Dark Harvest casts

#### Mythic+ - Hellcaller AoE
- **Source**: Icy Veins
- **ST Priority**: Superior AoE, worse single target
- **Cleave Priority**: Agony uptime on as many targets as possible
- **Key Mechanics**: Slower shard generation, Malefic Grasp can swap for Eye Contract (+2% AoE, -ST)

#### Delves - Soul Harvester
- **Source**: Icy Veins
- **ST Priority**: Better defensives, fluid gameplay, short burst loops
- **Cleave Priority**: Sataiel's Volition, Quietus, Wicked Reaping trigger off Haunt
- **Key Mechanics**: Defensive focus

---

## Demonology Warlock

### Hero Talents
- **Soul Harvester** - Recommended for single target
- **Diabolist** - Recommended for Mythic+ and multi-target raid

### Apex Talent
- **Dominion of Argus** - Spawns demons during windows

### Talent Import Strings

#### Raid 25m - Soul Harvester Single Target
```
CoQAAAAAAAAAAAAAAAAAAAAAAYmZmZGNbMMzMmlBAAAAAAYstMwAGwMsFyYzYM2mlZmZMDAYmZmZGgZGzMmZAAAGzMzYMDLDAD
```
- **Source**: Method.gg
- **ST Priority**: Generate and spend Demonic Cores to feed Soul Harvester talents (Wicked Reaping, Quietus)
- **Cleave Priority**: Can swap Gloomhound for Charhound, or swap both for Doom + Summon Doomguard
- **Key Mechanics**: Core-focused gameplay

#### Raid 25m - Diabolist Single Target
```
CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjxmZGzyAAAAAAAAGzYYBGYZ0CNsYMGbzyMmxMAgZmZmZmZAGzYmZDAAMmZGzYGWGGwA
```
- **Source**: Method.gg
- **ST Priority**: Diabolic Ritual management
- **Cleave Priority**: Chaos Bolt cycles through Diabolic Ritual
- **Key Mechanics**: Slower paced, prefers Crit and Mastery for heavy Chaos Bolts

#### Mythic+ - Soul Harvester AoE
```
CoQAAAAAAAAAAAAAAAAAAAAAAwMzMzoZjxmZGzyAAAAAAAM2WGYADYG2CZsYMGbzyMmxMAgZmZGzAMzMmxMzGAAYMzMmxgtZGgB
```
- **Source**: Method.gg
- **ST Priority**: Extremely strong stacked 5-target cleave profile
- **Cleave Priority**: Dreadlash, Implosion, Antoran Armaments, To Hell And Back, Doom, Summon Doomguard
- **Key Mechanics**: Scales well beyond 5 targets, strongest at 5 targets compared to most classes

#### Mythic+ - Diabolist AoE / Raid Cleave
```
CoQAAAAAAAAAAAAAAAAAAAAAAwMjZGNbmZ2mZGzyAAAAAAAAGzYYBGYb0CNsYMzYZ2mZmxMAwMjxMzMDwYGzYDAAMmZGzww2MGwA
```
- **Source**: Method.gg
- **ST Priority**: "Plays itself" - don't overcap cores or shards
- **Cleave Priority**: Keep Demonic Rituals rolling
- **Key Mechanics**: Bread and butter for M+ and multi-target raid encounters

#### Delves - Demonology
- **Source**: Icy Veins
- **ST Priority**: Soul Harvester offers better defensives
- **Cleave Priority**: Diabolist has stronger burst, can trivialize difficult situations
- **Key Mechanics**: Defensive vs burst trade-off

---

## Destruction Warlock

### Hero Talents
- **Hellcaller** - Recommended for most content
- **Diabolist** - Alternative

### Apex Talent
- **Raging Demonfire** - Enhances demonfire spells

### Talent Import Strings

#### Raid 25m - Hellcaller Single Target
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLYmZxYsYGAAMzMmZmFLwAziRjZAMbxGDAAMGYsBAMzAzMmZAAAYmZmBAwMDD
```
- **Source**: Method.gg
- **ST Priority**: Best for pure ST and patchwerk encounters
- **Cleave Priority**: No Mayhem or Havoc access
- **Key Mechanics**: Pure single target focus

#### Raid 25m - Hellcaller Cleave
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLjZMLGz2iHYAAwMGzMziFYgZxoxMAmtYjBAAGDM2AAmZgZGzMAAAMzMzAAYmhB
```
- **Source**: Method.gg
- **ST Priority**: Sacrifice low-value talents for cleave
- **Cleave Priority**: Havoc or Mayhem (Havoc for general, Mayhem for sustained cleave like council)
- **Key Mechanics**: Havoc/Mayhem access for cleave

#### Mythic+ - Hellcaller
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMzDMzoZzM2mZGz2sZYmFzMLLjBAAzY2MzsYBGYWMaMDgZL2YAAgZGMDAAzMYMDmNAAAzMzMAAMDD
```
- **Source**: Method.gg
- **ST Priority**: Cataclysm for Wither maintenance in mass AoE
- **Cleave Priority**: Wither maintenance in AoE scenarios
- **Key Mechanics**: Easy Wither maintenance with Cataclysm

#### Raid 25m - Diabolist Single Target
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLYmZxYsYGAAMzMmZmFwYGDLkB2GWoxCDAAMGYsBgZGAzMmZAAAYmZmBAwMDD
```
- **Source**: Method.gg
- **ST Priority**: Competitive with Hellcaller ST, slower paced
- **Cleave Priority**: Diabolic Ritual management
- **Key Mechanics**: Prefers Crit and Mastery for heavy Chaos Bolts

#### Raid 25m - Diabolist Cleave
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMzMDNbMMzMzsMLDzMLGz2iHYAAwMGzMzCYMjhFyAbDL0YhBAAGDM2AwMDgZGzMAAAMzMzAAYmhB
```
- **Source**: Method.gg
- **ST Priority**: Niche uses for cleave with stacked burst AoE
- **Cleave Priority**: Cleave fights with stacked burst AoE
- **Key Mechanics**: Niche cleave scenarios

#### Mythic+ - Diabolist AoE
```
CsQAAAAAAAAAAAAAAAAAAAAAAwMegZGNbmx2MzY2mtxMzsYmZZZMAAYGjZmZBMmxwCZgthNmxCDAAMGMAAzMAjZMzsBAAYmZGAAMDD
```
- **Source**: Method.gg
- **ST Priority**: Diabolist Ritual AoE through Chaos Bolt cycling
- **Cleave Priority**: Chaos Bolt through Diabolic Ritual, minimal Rain of Fire talents
- **Key Mechanics**: Chaos Bolt primary AoE until very high target counts

---

## May 5 Class Tuning (Warlock)

### Affliction
- Unstable Affliction +20% (PvE)
- Seed of Corruption +10% (PvE)
- Corruption +20% (PvE) — does NOT affect Wither
- Agony +10% (PvE)

### Destruction (PvP)
- All damage +5% in PvP

---



## Hyper Nuance Update - Timings, Combo Chains, Fillers (May 2026)

Use these as execution invariants when converting research into GSE priorities.

### Affliction
- Timing Windows: DoT refresh in pandemic windows and shard economy are the two hard constraints; never enter burst with low shard bank.
- Optimal Combo Chain: DoT establish -> shard spend burst -> cooldown amp -> drain/execute sustain.
- Filler Logic: Drain/Shadow filler only when DoTs are stable and shard spenders are unavailable.
- ST/AoE Swap Rule: AoE: seed spread loops; ST: tight DoT + shard conversion.
- GSE Guardrail: Keep utility/CC/major defensives on modifier keys or separate binds; do not auto-fire them in the main body sequence.

### Demonology
- Timing Windows: Tyrant-style windows require pet setup first; pressing burst before setup is a hard desync loss.
- Optimal Combo Chain: Imp/demon setup -> major summon -> tyrant window -> core/shard spend stabilization.
- Filler Logic: Shadow Bolt/Demonbolt fillers to maintain core economy between summon checkpoints.
- ST/AoE Swap Rule: AoE packs: implosion cadence; ST: single-target summon optimization.
- GSE Guardrail: Keep utility/CC/major defensives on modifier keys or separate binds; do not auto-fire them in the main body sequence.

### Destruction
- Timing Windows: Havoc and infernal-style windows should start with shard preload; avoid entering with empty resources.
- Optimal Combo Chain: Cooldown open -> immolate/havoc prep -> chaos bolt burst chain -> rain/cleave conversion as needed.
- Filler Logic: Incinerate filler only when no spender or havoc interaction is available.
- ST/AoE Swap Rule: Cleave: havoc maintenance; ST: bolt-centric spend routing.
- GSE Guardrail: Keep utility/CC/major defensives on modifier keys or separate binds; do not auto-fire them in the main body sequence.


## Hyper Nuance Expansion - Micro Timings and Combo Ladders (May 2026)

Add this layer when refining priority loops into high-precision class packages.

### Affliction
- Opener Timing (Micro): 0-5s: DoT baseline; 5-12s: shard conversion burst.
- Combo Commit Rule: Commit dark harvest windows with full DoT spread and shard bank.
- Filler Cutoff Rule: If shards high and DoTs stable, spend before filler drains.
- Anti-Pattern to Avoid: Do not refresh DoTs too early outside pandemic thresholds.

### Demonology
- Opener Timing (Micro): 0-6s: pet setup; 6-12s: tyrant burst conversion.
- Combo Commit Rule: Commit tyrant only after demon setup threshold is met.
- Filler Cutoff Rule: If cores and shards both high, spender before extra builder casts.
- Anti-Pattern to Avoid: Do not cast tyrant with weak demon board.

### Destruction
- Opener Timing (Micro): 0-4s: immolate and shard prep; 4-10s: infernal/havoc spend chain.
- Combo Commit Rule: Commit infernal/havoc when shard bank supports bolt chain.
- Filler Cutoff Rule: If shards capped, chaos bolt/rain spend before incinerate filler.
- Anti-Pattern to Avoid: Do not waste havoc window on low-impact filler globals.



## PvP / RBG Nuance Layer - DR Sequencing, Swap-Kill Windows, Defensive Trade Trees (May 2026)

### Affliction (PvP)
- DR Map: Fear (Howl of Terror / Shadow Bolt proc) is fear DR. Shadowfury is stun (separate DR). Banish is a separate control (demon/elemental only, niche). Unstable Affliction silence on dispel is not a traditional CC.
- Swap-Kill Window: Dark Soul: Misery → Haunt → Malefic Rapture dump. All DoTs must be active before committing. Target must not actively be dispelling. Kill window ~12s; prioritize UA stacks for dispel punishment.
- Defensive Trade Tree: Unending Resolve (major CD — interrupt immunity + 40% DR, save for kill swaps) → Dark Pact (self-drain soul shard for large absorb shield) → Soulstone self-res as passive safety net.
- CC Priority: Shadowfury (AoE stun, instant) → Fear (separate DR — use on secondary targets to prevent peeling your team's kill window).
- PvP Anti-Pattern: Refreshing DoTs on kill target at 30% HP instead of letting them tick and spending casts on Malefic Rapture burst. Using Unending Resolve as a preemptive opener instead of saving for the kill swap.

### Demonology (PvP)
- DR Map: Shadowfury (stun). Fear (separate DR). Axe Toss (pet stun, same DR as Shadowfury if both used back-to-back — check per patch notes).
- Swap-Kill Window: Nether Portal + Summon Demonic Tyrant → Hand of Gul'dan chain. Imps and Dreadstalkers must be stacked before Tyrant. Tyrant window is ~15s; front-load all shard spending before Tyrant.
- Defensive Trade Tree: Unending Resolve → Dark Pact → Soulstone.
- CC Priority: Shadowfury instant AoE stun → Axe Toss (pet stun, check DR vs Shadowfury) → Fear (separate DR) for peel.
- PvP Anti-Pattern: Using Tyrant when kill target has active immunities. Running into melee range unnecessarily (Demonology is still primarily a caster; pet controls melee).

### Destruction (PvP)
- DR Map: Shadowfury (AoE stun, instant). Howl of Terror (AoE fear, separate DR). Banish (separate, limited use).
- Swap-Kill Window: Summon Infernal → Chaos Bolt chain within 6s. Infernal provides a stun on landing (1.5s) — chain Shadowfury after for second stun event on different DR. Chaos Bolt cast time requires target to be CC'd or interrupted to land safely.
- Defensive Trade Tree: Unending Resolve → Dark Pact (large absorb instant) → Burning Rush for mobility (costs HP — use carefully). Hold Unending Resolve specifically for kill swaps.
- CC Priority: Shadowfury (AoE stun instant, no cast time) → Howl of Terror (AoE fear, separate DR) — these chain for two CC events without casting Chaos Bolt into an active target.
- PvP Anti-Pattern: Casting Chaos Bolt into a Grounding Totem without checking. Using Shadowfury + Howl of Terror both before Chaos Bolt cast completes (wastes second CC as defensive cover if first CC is sufficient).
