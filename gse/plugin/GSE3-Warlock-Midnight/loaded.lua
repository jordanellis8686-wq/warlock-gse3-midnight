local ModName, Sequences = ...
local GSE = rawget(_G, "GSE") or rawget(_G, "GSE3")
if GSE == nil then return end
if type(Sequences) ~= "table" then return end

local addonApi = rawget(_G, "C_AddOns")

local function addonVersion()
  if type(addonApi) == "table" and type(addonApi.GetAddOnMetadata) == "function" then
    local v = addonApi.GetAddOnMetadata(ModName, "Version")
    if type(v) == "string" and v ~= "" then return v end
  end
  return "1.0.5"
end

local function collectSequenceNames()
  local seqNames = {}
  for seqName, payload in pairs(Sequences) do
    if type(seqName) == "string" and seqName ~= "__manifest" then
      if type(payload) == "string" and payload:sub(1,6) == "!GSE3!" then
        table.insert(seqNames, seqName)
      end
    end
  end
  table.sort(seqNames)
  return seqNames
end

if type(GSE.RegisterAddon) ~= "function" then return end

local seqNames = collectSequenceNames()
if #seqNames == 0 then return end

GSE.RegisterAddon(
  ModName,
  addonVersion(),
  seqNames,
  Sequences
)