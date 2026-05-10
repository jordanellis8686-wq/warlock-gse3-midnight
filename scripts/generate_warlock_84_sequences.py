#!/usr/bin/env python3
"""
Warlock GSE3 Sequence Generator — Level 84-90 Compatible
Patch: Midnight 12.0.5 | Interface 120005 | GSE 3315
Uses CORRECT GSE3 CBOR format matching working Vengeance generator
"""

import base64
import os
import zlib
from datetime import datetime

try:
    import cbor2
except ImportError:
    print("ERROR: cbor2 module required. Install with: pip install cbor2")
    exit(1)

GSE_VERSION = 4000
LAST_UPDATED = int(datetime(2026, 5, 10, 0, 35).timestamp())
OMS = 150
AUTHOR = "Cascade-WoW"


def encode(name: bytes, seq: dict) -> str:
    """Encode GSE3 sequence in CBOR format with compression."""
    payload = cbor2.dumps([name, seq])
    comp = zlib.compressobj(level=9, wbits=15)
    encoded = comp.compress(payload) + comp.flush()
    return "!GSE3!" + base64.b64encode(encoded).decode("ascii")


def act(macro: str) -> dict:
    return {b"macro": macro.encode(), b"Type": b"Action", b"type": b"macro"}


def priority_loop(*actions: dict, repeat: int = 1) -> dict:
    """Create a priority loop block for GSE3 sequences."""
    block = {b"Type": b"Loop", b"StepFunction": b"Priority", b"Repeat": repeat}
    for index, action in enumerate(actions, 1):
        block[str(index).encode()] = action
    return block


def build(
    name, spec_id, actions, vars_dict, desc, help_text, talents="", oms=OMS
) -> dict:
    return {
        b"LastUpdated": LAST_UPDATED,
        b"WeakAuras": [],
        b"Versions": [{b"Actions": actions, b"InbuiltVariables": {}}],
        b"Variables": vars_dict,
        b"MetaData": {
            b"Author": AUTHOR.encode(),
            b"SpecID": spec_id,
            b"Name": name,
            b"Talents": talents.encode() if talents else [],
            b"Checksum": None,
            b"Dependencies": {b"Variables": [], b"Macros": [], b"Sequences": []},
            b"Default": 1,
            b"GSEVersion": GSE_VERSION,
            b"Description": desc.encode(),
            b"Help": help_text.encode(),
            b"EnforceCompatability": True,
            b"ManualIntervention": False,
            b"OMS": oms,
        },
    }


def warlock_variables() -> dict:
    return {
        b"KeyPress": {
            b"1": b"/startattack",
            b"2": b"/petattack",
            b"3": b"/cast [mod:alt,known:Spell Lock] Spell Lock",
            b"4": b"/cast [mod:ctrl,known:Mortal Coil] Mortal Coil",
            b"5": b"/cast [mod:shift,known:Unending Resolve] Unending Resolve",
        },
        b"KeyRelease": {
            b"1": b"/run if WA and WA.Signal then WA:Signal('WL_TICK') end",
        },
    }


# ── AFFLICTION SOUL HARVESTER ──


def aff_ssh_st_actions():
    return [
        priority_loop(
            act("/cast [known:Dark Harvest] Dark Harvest"),
            act("/cast [known:Summon Darkglare] Summon Darkglare"),
            act("/cast [known:Malevolence] Malevolence"),
            act("/cast [known:Haunt] Haunt"),
            act("/cast Unstable Affliction"),
            act("/cast Agony"),
            act("/cast Corruption"),
            act("/cast [known:Drain Soul] Drain Soul"),
            act("/cast Shadow Bolt"),
        ),
    ]


def aff_ssh_aoe_actions():
    return [
        priority_loop(
            act("/cast [known:Dark Harvest] Dark Harvest"),
            act("/cast [known:Summon Darkglare] Summon Darkglare"),
            act("/cast [known:Seed of Corruption] Seed of Corruption"),
            act("/cast Agony"),
            act("/cast Corruption"),
            act("/cast Unstable Affliction"),
            act("/cast [known:Drain Soul] Drain Soul"),
            act("/cast Shadow Bolt"),
        ),
    ]


# ── AFFLICTION HELLCALLER ──


def aff_hcl_st_actions():
    return [
        priority_loop(
            act("/cast [known:Dark Harvest] Dark Harvest"),
            act("/cast [known:Summon Darkglare] Summon Darkglare"),
            act("/cast [known:Malevolence] Malevolence"),
            act("/cast [known:Haunt] Haunt"),
            act("/cast Unstable Affliction"),
            act("/cast Agony"),
            act("/cast Corruption"),
            act("/cast [known:Drain Soul] Drain Soul"),
            act("/cast Shadow Bolt"),
        ),
    ]


# ── DEMONOLOGY SOUL HARVESTER ──


def demo_ssh_st_actions():
    return [
        priority_loop(
            act("/cast [known:Summon Demonic Tyrant] Summon Demonic Tyrant"),
            act("/cast [known:Grimoire: Felguard] Grimoire: Felguard"),
            act("/cast [known:Summon Vilefiend] Summon Vilefiend"),
            act("/cast Call Dreadstalkers"),
            act("/cast Hand of Gul'dan"),
            act("/cast [known:Demonbolt] Demonbolt"),
            act("/cast Shadow Bolt"),
        ),
    ]


# ── DEMONOLOGY DIABOLIST ──


def demo_dia_aoe_actions():
    return [
        priority_loop(
            act("/cast [known:Summon Demonic Tyrant] Summon Demonic Tyrant"),
            act("/cast [known:Grimoire: Felguard] Grimoire: Felguard"),
            act("/cast [known:Pit Lord] Pit Lord"),
            act("/cast Call Dreadstalkers"),
            act("/cast Hand of Gul'dan"),
            act("/cast [known:Demonbolt] Demonbolt"),
            act("/cast Shadow Bolt"),
        ),
    ]


# ── DESTRUCTION HELLCALLER ──


def dst_hcl_st_actions():
    return [
        priority_loop(
            act("/cast [known:Summon Infernal] Summon Infernal"),
            act("/cast [known:Avatar of Destruction] Avatar of Destruction"),
            act("/cast [known:Soul Fire] Soul Fire"),
            act("/cast Chaos Bolt"),
            act("/cast Conflagrate"),
            act("/cast Immolate"),
            act("/cast Incinerate"),
        ),
    ]


# ── DESTRUCTION DIABOLIST ──


def dst_dia_clv_actions():
    return [
        priority_loop(
            act("/cast [known:Summon Infernal] Summon Infernal"),
            act("/cast [known:Havoc] Havoc"),
            act("/cast [known:Soul Fire] Soul Fire"),
            act("/cast Chaos Bolt"),
            act("/cast [known:Rain of Fire] Rain of Fire"),
            act("/cast Conflagrate"),
            act("/cast Immolate"),
            act("/cast Incinerate"),
        ),
    ]


SPEC_IDS = {
    "WL_AFF_SSH_ST": 265,
    "WL_AFF_SSH_AOE": 265,
    "WL_AFF_HCL_ST": 265,
    "WL_DEMO_SSH_ST": 266,
    "WL_DEMO_DIA_AOE": 266,
    "WL_DST_HCL_ST": 267,
    "WL_DST_DIA_CLV": 267,
}

sequences = {
    "WL_AFF_SSH_ST": build(
        b"WL_AFF_SSH_ST",
        SPEC_IDS["WL_AFF_SSH_ST"],
        aff_ssh_st_actions(),
        warlock_variables(),
        "Affliction Soul Harvester ST. [known:] guards for L84-90",
        "Main ST: Dark Harvest > Darkglare > Haunt > UA > Agony > Corruption",
    ),
    "WL_AFF_SSH_AOE": build(
        b"WL_AFF_SSH_AOE",
        SPEC_IDS["WL_AFF_SSH_AOE"],
        aff_ssh_aoe_actions(),
        warlock_variables(),
        "Affliction Soul Harvester AOE. [known:] guards for L84-90",
        "AOE key. Seed of Corruption focus with Dark Harvest",
    ),
    "WL_AFF_HCL_ST": build(
        b"WL_AFF_HCL_ST",
        SPEC_IDS["WL_AFF_HCL_ST"],
        aff_hcl_st_actions(),
        warlock_variables(),
        "Affliction Hellcaller ST. [known:] guards for L84-90",
        "Main ST key. Malevolence + Darkglare burst windows",
    ),
    "WL_DEMO_SSH_ST": build(
        b"WL_DEMO_SSH_ST",
        SPEC_IDS["WL_DEMO_SSH_ST"],
        demo_ssh_st_actions(),
        warlock_variables(),
        "Demonology Soul Harvester ST. [known:] guards for L84-90",
        "Main ST key. Tyrant > Dreadstalkers > Hand > Demonbolt",
    ),
    "WL_DEMO_DIA_AOE": build(
        b"WL_DEMO_DIA_AOE",
        SPEC_IDS["WL_DEMO_DIA_AOE"],
        demo_dia_aoe_actions(),
        warlock_variables(),
        "Demonology Diabolist AOE. [known:] guards for L84-90",
        "AOE key. Pit Lord + Tyrant + demon swarms",
    ),
    "WL_DST_HCL_ST": build(
        b"WL_DST_HCL_ST",
        SPEC_IDS["WL_DST_HCL_ST"],
        dst_hcl_st_actions(),
        warlock_variables(),
        "Destruction Hellcaller ST. [known:] guards for L84-90",
        "Main ST key. Soul Fire > Chaos Bolt > Conflagrate > Immolate > Incinerate",
    ),
    "WL_DST_DIA_CLV": build(
        b"WL_DST_DIA_CLV",
        SPEC_IDS["WL_DST_DIA_CLV"],
        dst_dia_clv_actions(),
        warlock_variables(),
        "Destruction Diabolist Cleave. [known:] guards for L84-90",
        "Cleave key. Chaos Bolt > Havoc > Soul Fire > Shadowburn for 2-7 targets (no Rain of Fire)",
    ),
}

# Write output
base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
output_file = os.path.join(base_dir, "gse", "WARLOCK_84_90_Midnight.txt")

with open(output_file, "w") as f:
    f.write("# Warlock GSE3 Sequences — Level 84-90 Compatible\n")
    f.write(f"# Generated: {datetime.utcnow().isoformat()} UTC\n")
    f.write(f"# Patch: Midnight 12.0.5 | Interface 120005 | GSE {GSE_VERSION}\n")
    f.write(f"# OMS: {OMS}ms | Level: 84-90 compatible\n")
    f.write("# CORRECT GSE3 CBOR FORMAT — matching Vengeance generator\n\n")
    for name, seq in sequences.items():
        f.write(f"{name}\n")
        f.write(f"{encode(name.encode(), seq)}\n\n")

# Write loaded.lua
loaded_path = os.path.join(
    base_dir, "gse", "plugin", "GSE3-Warlock-Midnight", "loaded.lua"
)

lua = "local ModName, Sequences = ...\n"
lua += 'local GSE = rawget(_G, "GSE") or rawget(_G, "GSE3")\n'
lua += 'if GSE == nil then print("GSE3-Warlock-Midnight requires GSE.") return end\n\n'
lua += "-- Level 84-90 Compatible Warlock Sequences\n"
lua += "-- CORRECT GSE3 CBOR FORMAT — spells use [known:] guards\n\n"

for name, seq in sequences.items():
    lua += f'Sequences["{name}"] = [[{encode(name.encode(), seq)}]]\n'

lua += "\nGSE.RegisterAddon(\n"
lua += "  ModName,\n"
lua += '  C_AddOns.GetAddOnMetadata(ModName, "Version"),\n'
lua += "  GSE.GetSequenceNamesFromLibrary(Sequences),\n"
lua += "  Sequences\n"
lua += ")\n"

with open(loaded_path, "w") as f:
    f.write(lua)

print(f"Generated {len(sequences)} Warlock sequences (CORRECT CBOR FORMAT)")
print(f"Output: {output_file}")
print(f"Addon: {loaded_path}\n")
