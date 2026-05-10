-- Warlock WeakAuras Signals - Optimized for Midnight 12.0.5
-- Enhanced with precision resource management and tactical awareness
local addonName = ...

local frame = CreateFrame("Frame")

-- Affliction spells
local AGONY = "Agony"
local CORRUPTION = "Corruption"
local UNSTABLE_AFFLICTION = "Unstable Affliction"
local SEED_OF_CORRUPTION = "Seed of Corruption"
local VILE_TAINT = "Vile Taint"
local SOUL_ROTTEN = "Soul Rot"
local DARK_SOULEATER = "Dark Soul: Misery"
local SUMMON_DARKGLARE = "Summon Darkglare"

-- Demonology spells
local DEMONBOLT = "Demonbolt"
local SHADOW_BOLT = "Shadow Bolt"
local HAND_OF_GULDAN = "Hand of Gul'dan"
local CALL_DREADSTALKERS = "Call Dreadstalkers"
local IMPLOSION = "Implosion"
local POWER_SIPHON = "Power Siphon"
local GRIMOIRE_FELGUARD = "Grimoire: Felguard"
local SUMMON_DEMONIC_TYRANT = "Summon Demonic Tyrant"
local BILESCOURGE_BOMBERS = "Bilescourge Bombers"
local DOOM = "Doom"

-- Destruction spells
local IMMOLATE = "Immolate"
local INCINERATE = "Incinerate"
local CONFLAGRATE = "Conflagrate"
local CHAOS_BOLT = "Chaos Bolt"
local RAIN_OF_FIRE = "Rain of Fire"
local HAVOC = "Havoc"
local SUMMON_INFERNAL = "Summon Infernal"
local DARK_SOUL_INSTABILITY = "Dark Soul: Instability"

-- Shared spells
local UNENDING_RESOLVE = "Unending Resolve"
local DARK_PACT = "Dark Pact"
local MORTAL_COIL = "Mortal Coil"
local FEAR = "Fear"
local BANISH = "Banish"
local GATEWAY = "Demonic Gateway"
local HEALTHSTONE = "Healthstone"
local SOULSTONE = "Soulstone"

local function weakAurasReady()
  return WeakAuras and WeakAuras.ScanEvents
end

local function scan(eventName, active, value)
  if weakAurasReady() then
    WeakAuras.ScanEvents(eventName, active, value)
  end
end

local function pct(unit)
  local maxHealth = UnitHealthMax(unit)
  if not maxHealth or maxHealth <= 0 then
    return 100
  end
  return (UnitHealth(unit) / maxHealth) * 100
end

local function hostileTarget()
  return UnitExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("player", "target")
end

local function auraMissing(unit, auraName)
  if not hostileTarget() then
    return false
  end
  return AuraUtil.FindAuraByName(auraName, unit, "HARMFUL|PLAYER") == nil
end

local function auraRemaining(unit, auraName)
  if not hostileTarget() then
    return 0
  end
  local _, _, _, _, _, _, expirationTime = AuraUtil.FindAuraByName(auraName, unit, "HARMFUL|PLAYER")
  if expirationTime then
    return expirationTime - GetTime()
  end
  return 0
end

local function cooldownReady(spellId)
  local cdInfo = C_Spell.GetSpellCooldown(spellId)
  if not cdInfo or not cdInfo.startTime then return true end
  return cdInfo.startTime + cdInfo.duration <= GetTime()
end

local function getShardCount()
  return UnitPower("player", Enum.PowerType.SoulShards)
end

local function getManaPercent()
  local current = UnitPower("player", Enum.PowerType.Mana)
  local max = UnitPowerMax("player", Enum.PowerType.Mana)
  if max <= 0 then return 100 end
  return (current / max) * 100
end

local function getEnemyCount()
  local count = 0
  for i = 1, 40 do
    local unit = ("nameplate%d"):format(i)
    if UnitExists(unit) and UnitCanAttack("player", unit) and not UnitIsDeadOrGhost(unit) then
      local distance = UnitDistanceSquared("player", unit)
      if distance and distance <= 144 then -- 12 yard radius for Warlock AoE
        count = count + 1
      end
    end
  end
  return count
end

local function hasDarkSoul()
  return AuraUtil.FindAuraByName("Dark Soul", "player", "HELPFUL|PLAYER") ~= nil
end

local function getActiveDemons()
  local count = 0
  for i = 1, 40 do
    local unit = ("nameplate%d"):format(i)
    if UnitExists(unit) and UnitIsFriend("player", unit) then
      local _, _, _, _, _, _, _, _, _, _, spellId = AuraUtil.FindAuraByName("Demon", unit, "HELPFUL")
      if spellId then
        count = count + 1
      end
    end
  end
  return count
end

local function getSpecID()
  return GetSpecializationInfo(GetSpecialization())
end

local function update()
  local playerPct = pct("player")
  local targetPct = pct("target")
  local hostile = hostileTarget()
  local shards = getShardCount()
  local manaPct = getManaPercent()
  local enemyCount = getEnemyCount()
  local activeDemons = getActiveDemons()
  local specID = getSpecID()
  local hasDS = hasDarkSoul()

  -- Health thresholds
  scan("WARLOCK_RBG_PLAYER_HP_50", playerPct <= 50, playerPct)
  scan("WARLOCK_RBG_PLAYER_HP_30", playerPct <= 30, playerPct)
  scan("WARLOCK_RBG_PLAYER_HP_20", playerPct <= 20, playerPct)
  scan("WARLOCK_RBG_TARGET_EXECUTE", hostile and targetPct <= 20, targetPct)
  
  -- Resource management
  scan("WARLOCK_RBG_SOUL_SHARDS_FULL", shards >= 5, shards)
  scan("WARLOCK_RBG_SOUL_SHARDS_HIGH", shards >= 3, shards)
  scan("WARLOCK_RBG_SOUL_SHARDS_LOW", shards <= 1, shards)
  scan("WARLOCK_RBG_MANA_LOW", manaPct <= 30, manaPct)
  scan("WARLOCK_RBG_MANA_HIGH", manaPct >= 80, manaPct)
  
  -- Defensive cooldowns
  scan("WARLOCK_RBG_UNENDING_RESOLVE_READY", cooldownReady(104773), C_Spell.GetSpellCooldown(104773))
  scan("WARLOCK_RBG_DARK_PACT_READY", cooldownReady(108416), C_Spell.GetSpellCooldown(108416))
  scan("WARLOCK_RBG_MORTAL_COIL_READY", cooldownReady(6789), C_Spell.GetSpellCooldown(6789))
  scan("WARLOCK_RBG_FEAR_READY", cooldownReady(5782), C_Spell.GetSpellCooldown(5782))
  scan("WARLOCK_RBG_BANISH_READY", cooldownReady(710), C_Spell.GetSpellCooldown(710))
  
  -- Utility
  scan("WARLOCK_RBG_HEALTHSTONE_READY", GetItemCount(5512) > 0, GetItemCount(5512))
  scan("WARLOCK_RBG_SOULSTONE_READY", GetItemCount(40113) > 0, GetItemCount(40113))
  scan("WARLOCK_RBG_GATEWAY_READY", cooldownReady(111771), C_Spell.GetSpellCooldown(111771))
  
  -- Spec-specific tracking
  if specID == 265 then -- Affliction
    scan("WARLOCK_RBG_AGONY_TICKING", not auraMissing("target", AGONY), auraRemaining("target", AGONY))
    scan("WARLOCK_RBG_CORRUPTION_TICKING", not auraMissing("target", CORRUPTION), auraRemaining("target", CORRUPTION))
    scan("WARLOCK_RBG_UA_READY", cooldownReady(316099), C_Spell.GetSpellCooldown(316099))
    scan("WARLOCK_RBG_SEED_READY", cooldownReady(27243), C_Spell.GetSpellCooldown(27243))
    scan("WARLOCK_RBG_SOUL_ROT_READY", cooldownReady(386997), C_Spell.GetSpellCooldown(386997))
    scan("WARLOCK_RBG_DARK_SOUL_AFFLICTION_READY", cooldownReady(387170), C_Spell.GetSpellCooldown(387170))
    scan("WARLOCK_RBG_DARKGLARE_READY", cooldownReady(205180), C_Spell.GetSpellCooldown(205180))
    scan("WARLOCK_RBG_VILE_TAINT_READY", cooldownReady(386927), C_Spell.GetSpellCooldown(386927))
    
  elseif specID == 266 then -- Demonology
    scan("WARLOCK_RBG_DOOM_TICKING", not auraMissing("target", DOOM), auraRemaining("target", DOOM))
    scan("WARLOCK_RBG_DEMONBOLT_READY", cooldownReady(264178), C_Spell.GetSpellCooldown(264178))
    scan("WARLOCK_RBG_HAND_OF_GULDAN_READY", cooldownReady(105174), C_Spell.GetSpellCooldown(105174))
    scan("WARLOCK_RBG_CALL_DREADSTALKERS_READY", cooldownReady(264119), C_Spell.GetSpellCooldown(264119))
    scan("WARLOCK_RBG_IMPLOSION_READY", cooldownReady(196277), C_Spell.GetSpellCooldown(196277))
    scan("WARLOCK_RBG_POWER_SIPHON_READY", cooldownReady(264130), C_Spell.GetSpellCooldown(264130))
    scan("WARLOCK_RBG_FELGUARD_READY", cooldownReady(111898), C_Spell.GetSpellCooldown(111898))
    scan("WARLOCK_RBG_TYRANT_READY", cooldownReady(265187), C_Spell.GetSpellCooldown(265187))
    scan("WARLOCK_RBG_BILESCOURGE_READY", cooldownReady(267211), C_Spell.GetSpellCooldown(267211))
    scan("WARLOCK_RBG_DEMONS_ACTIVE", activeDemons >= 2, activeDemons)
    scan("WARLOCK_RBG_TYRANT_WINDOW", hasDS, 1)
    
  elseif specID == 267 then -- Destruction
    scan("WARLOCK_RBG_IMMOLATE_TICKING", not auraMissing("target", IMMOLATE), auraRemaining("target", IMMOLATE))
    scan("WARLOCK_RBG_CONFLAGRATE_CHARGES", GetSpellCharges(17962) or 0, GetSpellCharges(17962) or 0)
    scan("WARLOCK_RBG_CHAOS_BOLT_READY", cooldownReady(116858), GetSpellCharges(116858) or 0)
    scan("WARLOCK_RBG_RAIN_OF_FIRE_READY", cooldownReady(5740), C_Spell.GetSpellCooldown(5740))
    scan("WARLOCK_RBG_HAVOC_READY", cooldownReady(80240), C_Spell.GetSpellCooldown(80240))
    scan("WARLOCK_RBG_INFERNAL_READY", cooldownReady(1122), C_Spell.GetSpellCooldown(1122))
    scan("WARLOCK_RBG_DARK_SOUL_DESTRUCTION_READY", cooldownReady(387169), C_Spell.GetSpellCooldown(387169))
    scan("WARLOCK_RBG_BACKDRAFT_STACKS", select(4, AuraUtil.FindAuraByName("Backdraft", "player", "HELPFUL|PLAYER")) or 0, select(4, AuraUtil.FindAuraByName("Backdraft", "player", "HELPFUL|PLAYER")) or 0)
  end
  
  -- Tactical conditions
  scan("WARLOCK_RBG_AOE_SITUATION", enemyCount >= 3, enemyCount)
  scan("WARLOCK_RBG_SINGLE_TARGET", enemyCount == 1, enemyCount)
  scan("WARLOCK_RBG_BURST_READY", hasDS, 1)
  scan("WARLOCK_RBG_CONSERVE_MODE", manaPct < 40 and shards < 2, 1)
  scan("WARLOCK_RBG_BURST_MODE", manaPct > 70 and shards >= 3, 1)
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_HEALTH")
frame:RegisterEvent("UNIT_POWER_UPDATE")
frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

frame:SetScript("OnEvent", function(_, event, unit, ...)
  if event == "UNIT_HEALTH" and unit ~= "player" and unit ~= "target" then
    return
  end
  if event == "UNIT_POWER_UPDATE" and unit ~= "player" then
    return
  end
  if event == "COMBAT_LOG_EVENT_UNFILTERED" then
    local _, subEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId = CombatLogGetCurrentEventInfo()
    if subEvent == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
      -- Track ability usage for better resource prediction
      if spellId == 316099 then -- Unstable Affliction
        scan("WARLOCK_RBG_UA_USED", true, GetTime())
      elseif spellId == 265187 then -- Summon Demonic Tyrant
        scan("WARLOCK_RBG_TYRANT_USED", true, GetTime())
      elseif spellId == 116858 then -- Chaos Bolt
        scan("WARLOCK_RBG_CHAOS_BOLT_USED", true, GetTime())
      elseif spellId == 105174 then -- Hand of Gul'dan
        scan("WARLOCK_RBG_HAND_OF_GULDAN_USED", true, GetTime())
      end
    end
    return
  end
  if event == "UNIT_SPELLCAST_SUCCEEDED" and unit == "player" then
    local _, spellId = ...
    -- Track shard generation and spending
    if spellId == 686 then -- Shadow Bolt (Demonology)
      scan("WARLOCK_RBG_SHARD_GENERATED", true, 1)
    elseif spellId == 348 then -- Immolate (Destruction)
      scan("WARLOCK_RBG_SHARD_GENERATED", true, 1)
    elseif spellId == 980 then -- Agony (Affliction)
      scan("WARLOCK_RBG_SHARD_GENERATED", true, 1)
    end
  end
  update()
end)

SLASH_WARLOCKRBGWA1 = "/warlockrbgwa"
SlashCmdList.WARLOCKRBGWA = function()
  update()
  print(addonName .. ": Enhanced Warlock WeakAuras events fired.")
  print("Enemy Count: " .. getEnemyCount())
  print("Soul Shards: " .. getShardCount())
  print("Mana: " .. math.floor(getManaPercent()) .. "%")
  print("Health: " .. math.floor(pct("player")) .. "%")
  local specID = getSpecID()
  if specID == 265 then
    print("Spec: Affliction")
  elseif specID == 266 then
    print("Spec: Demonology - Active Demons: " .. getActiveDemons())
  elseif specID == 267 then
    print("Spec: Destruction")
  end
end