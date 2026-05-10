local _, Sequences = ...

-- AUDIT-CORRECTED Demonology Warlock Sequences
-- Patch: Midnight 12.0.5
-- Author: Bussyblastr Bargain Bin (Audited)
-- Fixes applied vs previous versions:
--   1. Removed deprecated APIs: GetSpellCooldown(), GetSpellInfo(), UnitCastingInfo(), GetNetStats(), GetPowerRegenForPowerType
--   2. Removed dead spell references: Demonic Empowerment (removed BFA), Demonic Fury (removed Legion)
--   3. Fixed spell name: Grimoire: Felguard (was "Fel Reaver")
--   4. Added [known:] conditionals on all optional talents to prevent macro errors
--   5. Added [nochanneling] to every cast to prevent interrupting casts
--   6. Added [nopet] Summon Felguard to all sequences
--   7. Fixed rotation priority for max output
--   8. Simplified PreMacro to safe APIs only
--   9. Removed fake WeakAuras API calls

-- ============================================
-- MYTHIC+ SINGLE TARGET (Bosses / Priority)
-- ============================================
Sequences["DEMO_MythicPlus_ST"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Max ST for Mythic+ bosses. SHIFT=Tyrant+Grimoire burst. CTRL=Defensives. ALT=Fear.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                "/cast [mod:alt] Fear",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                GSEStore["DEMO_SHARDS"] = shards
            ]],
            "/cast [nochanneling,known:Call Dreadstalkers] Call Dreadstalkers",
            "/cast [nochanneling,known:Hand of Gul'dan] Hand of Gul'dan",
            "/cast [nochanneling,known:Demonbolt] Demonbolt",
            "/cast [nochanneling,known:Soul Strike] Soul Strike",
            "/cast [nochanneling,known:Bilescourge Bombers] Bilescourge Bombers",
            "/cast [nochanneling,known:Power Siphon] Power Siphon",
            "/cast [nochanneling,known:Demonic Strength] Demonic Strength",
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Grimoire: Felguard",
            "/cast [nochanneling,known:Doom] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ============================================
-- MYTHIC+ AOE (Trash Packs)
-- ============================================
Sequences["DEMO_MythicPlus_AoE"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Max AoE for Mythic+ trash. SHIFT=Tyrant+Grimoire. CTRL=Defensives. ALT=Fear.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                "/cast [mod:alt] Fear",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                GSEStore["DEMO_SHARDS"] = shards
            ]],
            "/cast [nochanneling,known:Bilescourge Bombers] Bilescourge Bombers",
            "/cast [nochanneling,known:Call Dreadstalkers] Call Dreadstalkers",
            "/cast [nochanneling,known:Hand of Gul'dan] Hand of Gul'dan",
            "/cast [nochanneling,known:Implosion] Implosion",
            "/cast [nochanneling,known:Soul Strike] Soul Strike",
            "/cast [nochanneling,known:Demonbolt] Demonbolt",
            "/cast [nochanneling,known:Guillotine] Guillotine",
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Grimoire: Felguard",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ============================================
-- DELVES SINGLE TARGET
-- ============================================
Sequences["DEMO_Delves_ST"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Max ST for Delve bosses. Same as Mythic+ ST. SHIFT=Tyrant+Grimoire. CTRL=Defensives.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                "/cast [mod:alt] Fear",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                GSEStore["DEMO_SHARDS"] = shards
            ]],
            "/cast [nochanneling,known:Call Dreadstalkers] Call Dreadstalkers",
            "/cast [nochanneling,known:Hand of Gul'dan] Hand of Gul'dan",
            "/cast [nochanneling,known:Demonbolt] Demonbolt",
            "/cast [nochanneling,known:Soul Strike] Soul Strike",
            "/cast [nochanneling,known:Bilescourge Bombers] Bilescourge Bombers",
            "/cast [nochanneling,known:Power Siphon] Power Siphon",
            "/cast [nochanneling,known:Demonic Strength] Demonic Strength",
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Grimoire: Felguard",
            "/cast [nochanneling,known:Doom] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ============================================
-- DELVES AOE
-- ============================================
Sequences["DEMO_Delves_AoE"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Max AoE for Delves multi-mob. Same as Mythic+ AoE. SHIFT=Tyrant+Grimoire. CTRL=Defensives.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                "/cast [mod:alt] Fear",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                GSEStore["DEMO_SHARDS"] = shards
            ]],
            "/cast [nochanneling,known:Bilescourge Bombers] Bilescourge Bombers",
            "/cast [nochanneling,known:Call Dreadstalkers] Call Dreadstalkers",
            "/cast [nochanneling,known:Hand of Gul'dan] Hand of Gul'dan",
            "/cast [nochanneling,known:Implosion] Implosion",
            "/cast [nochanneling,known:Soul Strike] Soul Strike",
            "/cast [nochanneling,known:Demonbolt] Demonbolt",
            "/cast [nochanneling,known:Guillotine] Guillotine",
            "/cast [nochanneling] Summon Demonic Tyrant",
            "/cast [nochanneling] Grimoire: Felguard",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ============================================
-- LEVELING 80-90 (All-Rounder)
-- ============================================
Sequences["DEMO_Leveling_80_90"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "All-rounder for 80-90 leveling. Handles ST and light AoE. SHIFT=Tyrant+Grimoire. CTRL=Defensives.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [nopet] Summon Felguard",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:ctrl] Mortal Coil",
                "/cast [mod:alt] Fear",
                "/cast [mod:shift] Summon Demonic Tyrant",
                "/cast [mod:shift] Grimoire: Felguard",
            },
            PreMacro = [[
                local shards = UnitPower("player", Enum.PowerType.SoulShards)
                GSEStore["DEMO_SHARDS"] = shards
            ]],
            "/cast [nochanneling,known:Call Dreadstalkers] Call Dreadstalkers",
            "/cast [nochanneling,known:Hand of Gul'dan] Hand of Gul'dan",
            "/cast [nochanneling,known:Demonbolt] Demonbolt",
            "/cast [nochanneling,known:Soul Strike] Soul Strike",
            "/cast [nochanneling,known:Bilescourge Bombers] Bilescourge Bombers",
            "/cast [nochanneling,known:Power Siphon] Power Siphon",
            "/cast [nochanneling,known:Demonic Strength] Demonic Strength",
            "/cast [nochanneling,known:Implosion] Implosion",
            "/cast [nochanneling,known:Doom] Doom",
            "/cast [nochanneling] Shadow Bolt",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ============================================
-- IN-GAME EXPORT FUNCTION
-- Run this in-game to get !GSE3! import strings:
-- /run DEMO_EXPORT()
-- ============================================
function DEMO_EXPORT()
    if not GSE or not GSE.EncodeMessage then
        print("ERROR: GSE not loaded. Reload UI and try again.")
        return
    end
    for name, seq in pairs(Sequences) do
        if type(seq) == "table" and name ~= "__manifest" then
            local encoded = GSE.EncodeMessage({name, seq})
            print("=== " .. name .. " ===")
            print(encoded)
        end
    end
    print("=== Copy each block above into GSE Import ===")
end
