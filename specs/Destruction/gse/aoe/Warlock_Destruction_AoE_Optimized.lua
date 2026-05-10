local _, Sequences = ...

-- Optimized Destruction Warlock AoE Rotation
-- Features: Rain of Fire focus, multi-target Immolate, efficient shard usage
-- Author: Bussyblastr Bargain Bin (Optimized)
-- Patch: Midnight 12.0.5

Sequences["Warlock_Destruction_AoE_Optimized"] = {
    SpecID = 267,
    Author = "Bussyblastr Bargain Bin",
    Help = "Smart Destruction AoE with Rain of Fire priority. SHIFT=burst, CTRL=defensives, ALT=utility.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                -- Hero Talent detection
                "/run local heroSpec = C_ClassTalents.GetActiveHeroTalentSpec(); GSEStore['DEST_HERO_SPEC'] = heroSpec or 0;",
                -- Defensive cooldowns
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                -- Utility
                "/cast [mod:alt] Fear",
                "/cast [mod:alt] Create Soulwell",
                "/cast [mod:alt] Demonic Gateway",
                -- Burst cooldowns
                "/cast [mod:shift] Summon Infernal",
                "/cast [mod:shift] Cataclysm",
            },
            PreMacro = [[
                -- Resource and cooldown tracking
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                local maxShards = UnitPowerMax("player", Enum.PowerType.SoulShards)
                local playerLevel = UnitLevel("player")
                local heroSpec = GSEStore['DEST_HERO_SPEC'] or 0
                local combat = UnitAffectingCombat("player")
                
                -- Cooldown checks with proper nil handling
                local infernalCDInfo = C_Spell.GetSpellCooldown(116461)
                local infernalCD = infernalCDInfo and infernalCDInfo.startTime == 0
                local cataclysmCDInfo = C_Spell.GetSpellCooldown(152108)
                local cataclysmCD = cataclysmCDInfo and cataclysmCDInfo.startTime == 0
                
                -- Enemy count placeholder
                local enemies = 1 -- Placeholder for enemy count
                
                -- Backdraft stacks
                local backdraft = C_UnitAuras.GetPlayerAuraBySpellID(117828)
                
                GSEStore['SHARDS'] = shards
                GSEStore['MAX_SHARDS'] = maxShards
                GSEStore['SHARD_PCT'] = shards / maxShards
                GSEStore['PLAYER_LEVEL'] = playerLevel
                GSEStore['HERO_SPEC'] = heroSpec
                GSEStore['IN_COMBAT'] = combat
                GSEStore['INFERNAL_READY'] = infernalCD
                GSEStore['CATACLYSM_READY'] = cataclysmCD
                GSEStore['ENEMY_COUNT'] = enemies
                GSEStore['AOE_MODE'] = enemies >= 3
                GSEStore['BACKDRAFT_STACKS'] = backdraft and backdraft.applications or 0
                GSEStore['SHARDS_FOR_RAIN'] = shards >= 3
            ]],
            "/cast [nochanneling] [known:Soul Fire] Soul Fire",
            "/cast [nochanneling] Rain of Fire",
            "/cast [nochanneling] Chaos Bolt",
            "/cast [nochanneling] Conflagrate",
            "/cast [nochanneling] Immolate",
            "/cast [nochanneling] Incinerate",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
