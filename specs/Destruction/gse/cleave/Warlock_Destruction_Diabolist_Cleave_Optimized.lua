local _, Sequences = ...

-- Optimized Destruction Warlock Cleave Rotation
-- Features: Havoc management, Rain of Fire optimization, multi-target priority
-- Author: Bussyblastr Bargain Bin (Optimized)
-- Patch: Midnight 12.0.5

Sequences["Warlock_Destruction_Diabolist_Cleave_Optimized"] = {
    SpecID = 267,
    Author = "Bussyblastr Bargain Bin",
    Help = "Smart Destruction cleave with Havoc management. SHIFT=burst, CTRL=defensives, ALT=utility.",
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
                "/cast [mod:shift] Havoc",
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
                local havocCDInfo = C_Spell.GetSpellCooldown(80240)
                local havocCD = havocCDInfo and havocCDInfo.startTime == 0
                
                -- Immolate tracking on primary target
                local immolate = C_UnitAuras.GetPlayerAuraBySpellID(157736)
                local immolatePandemic = immolate and (immolate.expirationTime - GetTime()) < 5.4
                
                -- Backdraft stacks
                local backdraft = C_UnitAuras.GetPlayerAuraBySpellID(117828)
                
                GSEStore['SHARDS'] = shards
                GSEStore['MAX_SHARDS'] = maxShards
                GSEStore['SHARD_PCT'] = shards / maxShards
                GSEStore['PLAYER_LEVEL'] = playerLevel
                GSEStore['HERO_SPEC'] = heroSpec
                GSEStore['IN_COMBAT'] = combat
                GSEStore['INFERNAL_READY'] = infernalCD
                GSEStore['HAVOC_READY'] = havocCD
                GSEStore['IMMOLATE_ACTIVE'] = immolate ~= nil
                GSEStore['IMMOLATE_REFRESH'] = immolatePandemic
                GSEStore['BACKDRAFT_STACKS'] = backdraft and backdraft.applications or 0
                GSEStore['SHARDS_FOR_CHAOS'] = shards >= 2
                GSEStore['SHARDS_FOR_RAIN'] = shards >= 3
            ]],
            "/cast [nochanneling] [known:Soul Fire] Soul Fire",
            "/cast [nochanneling] Chaos Bolt",
            "/cast [nochanneling] Rain of Fire",
            "/cast [nochanneling] Conflagrate",
            "/cast [nochanneling] Immolate",
            "/cast [nochanneling] Incinerate",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
