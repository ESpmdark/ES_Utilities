ES_Utilities = LibStub("AceAddon-3.0"):NewAddon("ES_Utilities", "AceEvent-3.0")
local ESU_Frame = CreateFrame("Frame","ESU_Frame_Timer", UIParent)
local ESU_GUIDPlayers = {}
local ESU_GUIDPets = {}
local ESU_Timer = 0
local ESU_TimerP = 0
ESUTIL_DB = {}

local covSpells = {
	-- Signature Abilities
	[324739] = 1,	-- Summon Steward
	[177278] = 1,	-- Phial of Serenity
	[300728] = 2,	-- Door of Shadows
	[310143] = 3,	-- Soulshape
	[324701] = 3,	-- Flicker
	[324631] = 4,	-- Fleshcraft
	
	-- Warrior
	[307865] = 1,
	[330334] = 2,
	[317488] = 2,
	[330325] = 2,
	[325886] = 3,
	[324143] = 4,
	
	-- Paladin
	[304971] = 1,
	[316958] = 2,
	[328282] = 3,
	[328620] = 3,
	[328622] = 3,
	[328281] = 3,
	[328204] = 4,
	
	-- Hunter
	[308491] = 1,
	[324149] = 2,
	[328231] = 3,
	[325028] = 4,
	
	-- Rogue
	[323547] = 1,
	[323654] = 2,
	[328305] = 3,
	[328547] = 4,
	
	-- Priest
	[325013] = 1,
	[323673] = 2,
	[327661] = 3,
	[324724] = 4,
	
	-- Death Knight
	[312202] = 1,
	[311648] = 2,
	[324128] = 3,
	[315443] = 4,
	
	-- Shaman
	[324519] = 1,
	[324386] = 1,
	[320674] = 2,
	[328923] = 3,
	[326059] = 4,
	
	-- Mage
	[307443] = 1,
	[314793] = 2,
	[314791] = 3,
	[324220] = 4,
	
	-- Warlock
	[312321] = 1,
	[321792] = 2,
	[325640] = 3,
	[325289] = 4,
	
	-- Monk
	[310454] = 1,
	[326860] = 2,
	[327104] = 3,
	[325216] = 4,
	
	-- Druid
	[338142] = 1,
	[326462] = 1,
	[326446] = 1,
	[338035] = 1,
	[338018] = 1,
	[338411] = 1,
	[326434] = 1,
	[323546] = 2,
	[323764] = 3,
	[325727] = 4,
	
	-- Demon Hunter
	[306830] = 1,
	[317009] = 2,
	[323639] = 3,
	[329554] = 4,
}

local function UpdatePet(owner)
	local unit
	if owner == "player" then
		unit = "pet"
	else
		if string.match(owner, "party") then
			unit = string.gsub(owner, "party", "partypet")
		else
			unit = string.gsub(owner, "raid", "raidpet")
		end
	end
	if UnitExists(unit) then
		ESU_GUIDPets[UnitGUID(unit)] = {
			["uid"] = unit,
			["role"] = "PET",
			["name"] = '|cffC69B6D'..GetUnitName(unit, false)..'|r'
		}
	else
		for k,v in pairs(ESU_GUIDPets) do
			if v.uid == unit then
				ESU_GUIDPets[k] = nil
				break
			end
		end
	end
end

local GUIDpending = {}
local function GUIDcheck(type, nUnit)
	if UnitExists(nUnit) then
		if type == "player" then
			local _, class, _, _, _, name = GetPlayerInfoByGUID(UnitGUID(nUnit))
			local _, _, _, hex = GetClassColor(class)
			if name and not (UnitGUID(nUnit) == UnitGUID("player")) then
				ESU_GUIDPlayers[UnitGUID(nUnit)] = {
					["uid"] = nUnit,
					["role"] = UnitGroupRolesAssigned(nUnit),
					["name"] = '|c'..hex..name..'|r'
				}
			else
				GUIDpending[nUnit] = "player"
			end
		else
			local petGuid = UnitGUID(nUnit)
			if petGuid then
				ESU_GUIDPets[petGuid] = {
					["uid"] = nUnit,
					["role"] = "PET",
					["name"] = '|cffC69B6D'..GetUnitName(nUnit, false)..'|r'
				}
			else
				GUIDpending[nUnit] = "pet"
			end
		end
	end
end

local function CheckPendingGUID()
	for unit,type in pairs(GUIDpending) do
		GUIDpending[unit] = nil
		GUIDcheck(type, unit)
	end
end

local function PopulateGUID()
	ESU_GUIDPlayers = nil
    ESU_GUIDPlayers = {}
	ESU_GUIDPets = nil
    ESU_GUIDPets = {}
	GUIDpending = nil
	GUIDpending = {}
    local count = 4
    local unit = "party"
	local _, playerclass, _, _, _, playername = GetPlayerInfoByGUID(UnitGUID("player"))
    local _, _, _, playerhex = GetClassColor(playerclass)
    ESU_GUIDPlayers[UnitGUID("player")] = {
		["uid"] = "player",
		["role"] = UnitGroupRolesAssigned("player"),
		["name"] = '|c'..playerhex..playername..'|r'
	}
    if UnitExists("pet") then
        ESU_GUIDPets[UnitGUID("pet")] = {
			["uid"] = "pet",
			["role"] = "PET",
			["name"] = '|cffC69B6D'..GetUnitName("pet", false)..'|r'
		}
	else
		for k,v in pairs(ESU_GUIDPets) do
			if v.uid == "pet" then
				ESU_GUIDPets[k] = nil
				break
			end
		end
    end
    if UnitExists("raid1") then
        unit = "raid" 
        count = 40
    end
    for i=1,count,1 do
		local nUnit = unit..tostring(i)
        GUIDcheck("player", nUnit)
    end
    unit = unit .. "pet"
    for i=1,count,1 do
		local nUnit = unit..tostring(i)
        GUIDcheck("pet", nUnit)
    end 
end

function ES_Utilities:Handler1(event, ...)
	PopulateGUID()
end

function ES_Utilities:Handler2(event, ...)
	UpdatePet(...)
end

local CLEU = CombatLogGetCurrentEventInfo
local UFN = UnitFullName
function ES_Utilities:Handler3(event, ...)
	local _, subevent, _, sourceGUID, _, _, _, _, _, _, _, spellId = CLEU()
	if subevent == "SPELL_CAST_SUCCESS" and C_PlayerInfo.GUIDIsPlayer(sourceGUID)then
		if covSpells[spellId] then
			local _, _, _, _, _, name, realm = GetPlayerInfoByGUID(sourceGUID)
			if (realm == "") or not realm then
				local _, playerRealm = UFN("player")
				realm = playerRealm
			end
			if not ESUTIL_DB["cov"][realm] then ESUTIL_DB["cov"][realm] = {} end
			if not ESUTIL_DB["cov"][realm][name] then --New entry
				ESUTIL_DB["cov"][realm][name] = covSpells[spellId]
				if IsGUIDInGroup(sourceGUID) then
					WeakAuras.ScanEvents("ESUTILITIES_WA_COVENANTUPDATE",true)
				end
			elseif not ESUTIL_DB["cov"][realm][name] == covSpells[spellId] then --Update entry
				ESUTIL_DB["cov"][realm][name] = covSpells[spellId]
				if IsGUIDInGroup(sourceGUID) then
					WeakAuras.ScanEvents("ESUTILITIES_WA_COVENANTUPDATE",true)
				end
			end
		end
	end
end

function ES_Utilities:OnInitialize()
	if not ESUTIL_DB["cov"] then ESUTIL_DB["cov"] = {} end
	ES_Utilities:RegisterEvent("RAID_ROSTER_UPDATE", "Handler1")
	ES_Utilities:RegisterEvent("GROUP_ROSTER_UPDATE", "Handler1")
	ES_Utilities:RegisterEvent("PLAYER_ENTERING_WORLD", "Handler1")
	ES_Utilities:RegisterEvent("GROUP_FORMED", "Handler1")
	ES_Utilities:RegisterEvent("GROUP_JOINED", "Handler1")
	ES_Utilities:RegisterEvent("GROUP_LEFT", "Handler1")
	ES_Utilities:RegisterEvent("UNIT_PET", "Handler2")
	ES_Utilities:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "Handler3")
end

--------------
-- Loop Timer:
--------------
local function ESU_Frame_UpdateLoop_Function(self,elapsed)
    ESU_Timer = ESU_Timer + elapsed
	if ESU_TimerP >= 20 then
		CheckPendingGUID()
		ESU_TimerP = 0
	end
    if ESU_Timer >= 0.1 then -- Throttled event for weakaura triggers. Dont have to use "every frame" check.
		ESU_TimerP = ESU_TimerP + 1
		WeakAuras.ScanEvents("ESUTILITIES_WA_EVENT",true)
        ESU_Timer = 0
    end
end
 
ESU_Frame:SetScript("OnUpdate", ESU_Frame_UpdateLoop_Function)

--------------------
-- Public functions:
--------------------
function ESUtil_GetUnit(GUID)
	if GUID == "PLAYERS" then
		local rt = {}
		for k,v in pairs(ESU_GUIDPlayers) do
			rt[k] = v
		end
		return rt
	elseif GUID == "PETS" then
		local rt = {}
		for k,v in pairs(ESU_GUIDPets) do
			rt[k] = v
		end
		return rt
	elseif ESU_GUIDPlayers[GUID] then
		return ESU_GUIDPlayers[GUID]
	elseif ESU_GUIDPets[GUID] then
		return ESU_GUIDPets[GUID]
	else
		return false
	end
end

function ESUtil_GetRole(role) -- TANK, HEALER, DAMAGER, NONE
	local rt = {}
	for k,v in pairs(ESU_GUIDPlayers) do
		if v.role == role then
			rt[v.uid] = true
		end
	end
	return rt
end

function ESUtil_GetCovenant(unit)
	local covRef = {
		[1] = "Kyrian",
		[2] = "Venthyr",
		[3] = "Night Fae",
		[4] = "Necrolord"
	}
	local name, realm = UnitFullName(unit)
	if (realm == "") or not realm then
		local _, playerRealm = UFN("player")
		realm = playerRealm
	end
	if ESUTIL_DB["cov"][realm] then
		local uCov = ESUTIL_DB["cov"][realm][name]
		if uCov and covRef[uCov] then
			return covRef[uCov]
		else
			return false
		end
	else
		return false
	end
end

