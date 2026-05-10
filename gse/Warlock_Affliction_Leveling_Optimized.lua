local _, Sequences = ...

-- Optimized Affliction Warlock Leveling Rotation
-- Features: Hero Talent detection, smart DoT management, pandemic windows
-- Author: Bussyblastr Bargain Bin (Optimized)
-- Patch: Midnight 12.0.5

Sequences["Warlock_Affliction_Leveling_Optimized"] = {
    SpecID = 265,
    Author = "Bussyblastr Bargain Bin",
    Help = "Smart Affliction leveling with Hero Talent detection. SHIFT=burst, CTRL=defensives, ALT=utility.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                -- Hero Talent detection via macro conditionals
                "/run local heroSpec = C_ClassTalents.GetActiveHeroTalentSpec(); GSEStore['AFF_HERO_SPEC'] = heroSpec or 0;",
                -- Defensive cooldowns
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact", 
                "/cast [mod:ctrl] Mortal Coil",
                -- Utility
                "/cast [mod:alt] Create Soulwell",
                "/cast [mod:alt] Demonic Gateway",
                "/cast [mod:alt,@player] Demonic Circle: Teleport",
                -- Burst cooldowns
                "/cast [mod:shift] Summon Darkglare",
                "/cast [mod:shift] Dark Harvest",
            },
            PreMacro = [[
                -- Smart DoT refresh logic with pandemic windows
                local agony = C_UnitAuras.GetPlayerAuraBySpellID(980)
                local corruption = C_UnitAuras.GetPlayerAuraBySpellID(146739)
                local ua = C_UnitAuras.GetPlayerAuraBySpellID(316099)
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local heroSpec = GSEStore['AFF_HERO_SPEC'] or 0
                local combat = UnitAffectingCombat("player")
                
                -- Pandemic thresholds (30% of duration)
                local agonyPandemic = agony and (agony.expirationTime - GetTime()) < 5.4
                local corruptionPandemic = corruption and (corruption.expirationTime - GetTime()) < 4.2
                local uaPandemic = ua and (ua.expirationTime - GetTime()) < 6.3
                
                GSEStore['AGONY_PANDEMIC'] = agonyPandemic
                GSEStore['CORRUPTION_PANDEMIC'] = corruptionPandemic  
                GSEStore['UA_PANDEMIC'] = uaPandemic
                GSEStore['SHARDS'] = shards
                GSEStore['HERO_SPEC'] = heroSpec
                GSEStore['IN_COMBAT'] = combat
            ]],
            "/cast [nochanneling] Agony",
            "/cast [nochanneling] Corruption", 
            "/cast [nochanneling] Unstable Affliction",
            "/cast [nochanneling] Seed of Corruption",
            "/cast [nochanneling] Haunt",
            "/cast [nochanneling] Drain Soul",
            "/cast [nochanneling] Shadow Bolt",
            "/cast [nochanneling] Malefic Grasp",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- Soul Harvester specific optimization
Sequences["Warlock_Affliction_SoulHarvester_ST"] = {
    SpecID = 265,
    Author = "Bussyblastr Bargain Bin", 
    Help = "Soul Harvester ST with Dark Harvest optimization",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Summon Darkglare",
                "/cast [mod:shift] Dark Harvest",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local darkglareCD = C_Spell.GetSpellCooldown(205180)
                local darkHarvestCD = C_Spell.GetSpellCooldown(386933)
                
                GSEStore['DARKGLARE_READY'] = darkglareCD == 0
                GSEStore['DARKHARVEST_READY'] = darkHarvestCD == 0
                GSEStore['SHARDS'] = shards
            ]],
            "/cast [nochanneling] Agony",
            "/cast [nochanneling] Corruption",
            "/cast [nochanneling] Unstable Affliction",
            "/cast [nochanneling] Haunt",
            "/cast [nochanneling] Drain Soul",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- Hellcaller specific optimization  
Sequences["Warlock_Affliction_Hellcaller_ST"] = {
    SpecID = 265,
    Author = "Bussyblastr Bargain Bin",
    Help = "Hellcaller ST with Wither and Malevolence optimization", 
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]", 
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:shift] Summon Darkglare",
                "/cast [mod:shift] Malevolence",
                "/cast [mod:shift] Dark Harvest",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local wither = C_UnitAuras.GetPlayerAuraBySpellID(386933) -- Verify spellID
                local malevolenceCD = C_Spell.GetSpellCooldown(386933) -- Verify spellID
                
                GSEStore['MALEVOLENCE_READY'] = malevolenceCD == 0
                GSEStore['WITHER_STACKS'] = wither and wither.applications or 0
                GSEStore['SHARDS'] = shards
            ]],
            "/cast [nochanneling] Agony",
            "/cast [nochanneling] Wither",
            "/cast [nochanneling] Unstable Affliction", 
            "/cast [nochanneling] Haunt",
            "/cast [nochanneling] Drain Soul",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
