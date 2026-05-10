local _, Sequences = ...

-- Optimized Demonology Warlock Leveling Rotation  
-- Features: Hero Talent detection, smart demonic empowerment, pet management
-- Author: Bussyblastr Bargain Bin (Optimized)
-- Patch: Midnight 12.0.5

Sequences["Warlock_Demonology_Leveling_Optimized"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Smart Demonology leveling with Hero Talent detection. SHIFT=burst, CTRL=defensives, ALT=utility.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
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
                "/cast [mod:shift] Grimoire: Felguard",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Nether Portal", -- Soul Harvester
                "/cast [mod:shift] Guillotine", -- Diabolist
            },
            PreMacro = [[
                -- Resource and cooldown tracking
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local heroSpec = GSEStore['DEMO_HERO_SPEC'] or 0
                local combat = UnitAffectingCombat("player")
                
                -- Pet and demonic empowerment tracking
                local hasPet = UnitExists("pet")
                local empowerment = C_UnitAuras.GetPlayerAuraBySpellID(267171) -- Demonic Empowerment
                
                -- Cooldown checks with proper nil handling
                local tyrantCD = C_Spell.GetSpellCooldown(265187)
                local grimoireCD = C_Spell.GetSpellCooldown(111898)
                local handsCD = C_Spell.GetSpellCooldown(105174)
                
                GSEStore['SHARDS'] = shards
                GSEStore['HERO_SPEC'] = heroSpec
                GSEStore['HAS_PET'] = hasPet
                GSEStore['EMPOWERMENT'] = empowerment and empowerment.applications or 0
                GSEStore['TYRANT_READY'] = tyrantCD and tyrantCD.startTime == 0
                GSEStore['GRIMOIRE_READY'] = grimoireCD and grimoireCD.startTime == 0
                GSEStore['HANDS_READY'] = handsCD and handsCD.startTime == 0
                GSEStore['IN_COMBAT'] = combat
            ]],
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan", 
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Bilescourge Bombers",
            "/cast [nochanneling] Implosion",
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

-- Soul Harvester specific optimization
Sequences["Warlock_Demonology_SoulHarvester_ST"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Soul Harvester Demonology with Nether Portal optimization",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority", 
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Grimoire: Felguard",
                "/cast [mod:shift] Summon Demonic Tyrant", 
                "/cast [mod:shift] Nether Portal",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local portal = C_UnitAuras.GetPlayerAuraBySpellID(267218) -- Nether Portal
                
                GSEStore['SHARDS'] = shards
                GSEStore['PORTAL_ACTIVE'] = portal ~= nil
                GSEStore['SHARDS_FOR_HANDS'] = shards >= 3
            ]],
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Demonbolt", 
            "/cast [nochanneling] Bilescourge Bombers",
            "/cast [nochanneling] Implosion",
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

-- Diabolist specific optimization
Sequences["Warlock_Demonology_Diabolist_ST"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Diabolist Demonology with Guillotine optimization",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]", 
                "/petattack [@target,harm,nodead]",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Grimoire: Felguard",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Guillotine",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local guillotineCD = C_Spell.GetSpellCooldown(386932) -- Guillotine (Diabolist)
                
                GSEStore['SHARDS'] = shards
                GSEStore['GUILLOTINE_READY'] = guillotineCD and guillotineCD.startTime == 0
                GSEStore['SHARDS_FOR_HANDS'] = shards >= 3
            ]],
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Bilescourge Bombers", 
            "/cast [nochanneling] Implosion",
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

-- AoE optimized version
Sequences["Warlock_Demonology_AoE_Optimized"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin", 
    Help = "Demonology AoE with Implosion priority",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
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
            ]],
            "/cast [nochanneling] Bilescourge Bombers",
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Implosion",
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Soul Strike", 
            "/cast [nochanneling] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
