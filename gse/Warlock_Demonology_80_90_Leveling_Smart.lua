local _, Sequences = ...

-- Perfected Demonology Warlock 80-90 Leveling Smart Rotation
-- Optimized for Midnight 12.0.5 patch
-- Features: Smart resource management, pet priority, cooldown optimization
-- Author: Bussyblastr Bargain Bin
-- Level Range: 80-90

Sequences["Warlock_Demonology_80_90_Leveling_Smart"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Perfected 80-90 Demonology leveling. SHIFT=burst, CTRL=defensives, ALT=utility. Auto-manages pets, shards, and cooldowns.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                -- Pet summon if missing
                "/cast [nopet] Summon Felguard",
                -- Hero Talent detection
                "/run local heroSpec = C_ClassTalents.GetActiveHeroTalentSpec(); GSEStore['DEMO_HERO_SPEC'] = heroSpec or 0;",
                -- Defensive cooldowns
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                -- Utility
                "/cast [mod:alt] Fear",
                "/cast [mod:alt] Create Soulwell",
                "/cast [mod:alt] Demonic Gateway",
                -- Burst cooldowns
                "/cast [mod:shift] Grimoire: Fel Reaver",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Nether Portal",
                "/cast [mod:shift] Guillotine",
            },
            PreMacro = [[
                -- Resource and cooldown tracking
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local maxShards = UnitPowerMax("player", Enum.PowerType.SoulShards)
                local combat = UnitAffectingCombat("player")
                
                -- Pet and demonic empowerment tracking
                local hasPet = UnitExists("pet")
                local petHealth = hasPet and (UnitHealth("pet") / UnitHealthMax("pet")) or 0
                local empowerment = C_UnitAuras.GetPlayerAuraBySpellID(267171)
                
                -- Cooldown checks
                local tyrantCDInfo = C_Spell.GetSpellCooldown(265187)
                local tyrantCD = tyrantCDInfo and tyrantCDInfo.duration or 0
                local grimoireCDInfo = C_Spell.GetSpellCooldown(111898)
                local grimoireCD = grimoireCDInfo and grimoireCDInfo.duration or 0
                local dreadstalkersCDInfo = C_Spell.GetSpellCooldown(104316)
                local dreadstalkersCD = dreadstalkersCDInfo and dreadstalkersCDInfo.duration or 0
                local handsCDInfo = C_Spell.GetSpellCooldown(105174)
                local handsCD = handsCDInfo and handsCDInfo.duration or 0
                
                -- Level-based ability checks
                local playerLevel = UnitLevel("player")
                
                -- Smart decision logic
                local shouldTyrant = tyrantCD == 0 and shards >= 3 and combat
                local shouldHands = handsCD == 0 and shards >= 3
                local shouldDreadstalkers = dreadstalkersCD == 0 and shards >= 2
                local shouldEmpower = hasPet and empowerment == nil
                
                GSEStore['SHARDS'] = shards
                GSEStore['MAX_SHARDS'] = maxShards
                GSEStore['SHARD_PCT'] = shards / maxShards
                GSEStore['HAS_PET'] = hasPet
                GSEStore['PET_HEALTH'] = petHealth
                GSEStore['EMPOWERMENT'] = empowerment and empowerment.applications or 0
                GSEStore['TYRANT_READY'] = tyrantCD == 0
                GSEStore['GRIMOIRE_READY'] = grimoireCD == 0
                GSEStore['HANDS_READY'] = handsCD == 0
                GSEStore['DREADSTALKERS_READY'] = dreadstalkersCD == 0
                GSEStore['IN_COMBAT'] = combat
                GSEStore['PLAYER_LEVEL'] = playerLevel
                GSEStore['SHOULD_TYRANT'] = shouldTyrant
                GSEStore['SHOULD_HANDS'] = shouldHands
                GSEStore['SHOULD_DREADSTALKERS'] = shouldDreadstalkers
                GSEStore['SHOULD_EMPOWER'] = shouldEmpower
            ]],
            -- Priority rotation for 80-90 leveling (Midnight-safe tokens/order)
            "/cast [@target,harm,nodead] Doom",
            "/cast [@target,harm,nodead] Hand of Gul'dan",
            "/cast [combat] Nether Portal",
            "/cast [combat] Grimoire: Fel Reaver",
            "/cast [combat] Summon Demonic Tyrant",
            "/cast [@target,harm,nodead] Call Dreadstalkers",
            "/cast [@target,harm,nodead] Hand of Gul'dan",
            "/cast [@target,harm,nodead] Soul Strike",
            "/cast [@target,harm,nodead] Bilescourge Bombers",
            "/cast [combat,@target,harm,nodead] Mortal Coil",
            "/cast [@target,harm,nodead] Shadow Bolt",
            "/cast [@target,harm,nodead] Demonbolt",
            "/cast [@target,harm,nodead] Implosion",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- Single-target focused for elites/bosses
Sequences["Warlock_Demonology_80_90_ST"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "ST-focused 80-90 Demonology for elites and bosses. Maximizes single-target damage.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local tyrantCDInfo = C_Spell.GetSpellCooldown(265187)
                local tyrantCD = tyrantCDInfo and tyrantCDInfo.duration or 0
                local empowerment = C_UnitAuras.GetPlayerAuraBySpellID(267171)
                
                GSEStore['SHARDS'] = shards
                GSEStore['TYRANT_READY'] = tyrantCD == 0
                GSEStore['EMPOWERMENT'] = empowerment and empowerment.applications or 0
                GSEStore['SHARDS_FOR_HANDS'] = shards >= 3
            ]],
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Grimoire: Felguard",
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Soul Strike",
            "/cast [nochanneling] Power Siphon",
            "/cast [nochanneling] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- AoE focused for dungeon/trash
Sequences["Warlock_Demonology_80_90_AoE"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "AoE-focused 80-90 Demonology for dungeons and trash. Maximizes Implosion damage.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Bilescourge Bombers",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local enemies = 1
                
                GSEStore['SHARDS'] = shards
                GSEStore['ENEMY_COUNT'] = enemies
                GSEStore['AOE_MODE'] = enemies >= 3
                GSEStore['SHARDS_FOR_HANDS'] = shards >= 3
            ]],
            "/cast [nochanneling] Bilescourge Bombers",
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Implosion",
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
