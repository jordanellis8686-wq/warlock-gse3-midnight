local _, Sequences = ...

Sequences["WL_Demo_Leveling_Adaptive"] = {
    SpecID = 266,
    Author = "Bussyblastr Bargain Bin",
    Help = "Demonology adaptive leveling sequence. SHIFT = burst tools, CTRL = defensives, ALT = utility.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/petattack [@target,harm,nodead]",
                "/cast [mod:ctrl,@player] Unending Resolve",
                "/cast [mod:ctrl,@player] Dark Pact",
                "/cast [mod:alt] Fear",
                "/cast [mod:alt,@player] Mortal Coil",
                "/cast [mod:shift] Grimoire: Felguard",
                "/cast [mod:shift] Summon Demonic Tyrant",
            },
            "/cast [nochanneling] Hand of Gul'dan",
            "/cast [nochanneling] Demonbolt",
            "/cast [nochanneling] Call Dreadstalkers",
            "/cast [nochanneling] Bilescourge Bombers",
            "/cast [nochanneling] Implosion",
            "/cast [nochanneling] Shadow Bolt",
            "/cast [nochanneling] Soul Strike",
            "/cast [nochanneling] Power Siphon",
            "/cast [nochanneling] Doom",
            "/cast [nochanneling] Corruption",
            KeyRelease = {
                "/startattack",
            },
        },
    },
}
