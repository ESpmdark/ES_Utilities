local ESU_Frame = CreateFrame("Frame","ES_Utilities", UIParent)
local ESU_GUIDPlayers = {}
local ESU_GUIDPets = {}
local ESU_Timer = 0
local ESU_TimerP = 0

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

ESU_Frame:RegisterEvent("GROUP_FORMED")
ESU_Frame:RegisterEvent("GROUP_JOINED")
ESU_Frame:RegisterEvent("GROUP_LEFT")
ESU_Frame:RegisterEvent("PLAYER_ENTERING_WORLD")
ESU_Frame:RegisterEvent("RAID_ROSTER_UPDATE")
ESU_Frame:RegisterEvent("GROUP_ROSTER_UPDATE")
ESU_Frame:RegisterEvent("UNIT_PET")
local events = {
	["RAID_ROSTER_UPDATE"] = true,
	["GROUP_ROSTER_UPDATE"] = true,
	["PLAYER_ENTERING_WORLD"] = true,
	["GROUP_FORMED"] = true,
	["GROUP_JOINED"] = true,
	["GROUP_LEFT"] = true
}
local function ESU_Frame_eventHandler(self, event, owner, ...)
	if events[event] then
		PopulateGUID()
	elseif event == "UNIT_PET" then
		UpdatePet(owner)
	end
end
ESU_Frame:SetScript("OnEvent", ESU_Frame_eventHandler)

--## Create a throttled "every frame" event for weakaura triggers ##
local function ESU_Frame_UpdateLoop_Function(self,elapsed)
    ESU_Timer = ESU_Timer + elapsed
	if ESU_TimerP >= 20 then
		CheckPendingGUID()
	end
    if ESU_Timer >= 0.1 then
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