local _, addon = ...
ES_Utilities = LibStub("AceAddon-3.0"):NewAddon("ES_Utilities", "AceEvent-3.0")
addon.font_LiberationSansRegular = "Interface\\Addons\\ES_Utilities\\fonts\\LiberationSans-Regular.TTF"

local defaultDB = {
	toggles = {
		vault = false,
		rewards = false,
		renown = false,
		weekly = false,
		currency = false,
		autoloot = false,
		collected = false,
		drinkmacro = false,
		talkinghead = false,
		talkingheadsound = false,
		talkingheadwarmode = false,
	},
	last = {
		monthDay = 1,
		weekday = 1,
		month = 1,
		minute = 00,
		hour = 00,
		year = 1999,
	},
	reset = 999999,
	chars = {},
	drinkmacro = {
		name = "",
		defaults = "",
		arena = ""
	},
}
addon.CombatCheck = function()
	if UnitAffectingCombat("player") or InCombatLockdown() then return true end
	return false
end

addon.currentInventory = {}
addon.currentMacroItems = {defaults={},arena={}}
local itemsToCheck = {}
local NumBagSlots = C_Container.GetContainerNumSlots
local BagItemInfo = C_Container.GetContainerItemInfo

local function iterateBags()
	table.wipe(addon.currentInventory)
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = NumBagSlots(bag)
		for slot = 1, bSlots do
			local info = BagItemInfo(bag, slot)
			if info and itemsToCheck[info.itemID] then
				addon.currentInventory[info.itemID] = info.hyperlink
			end
		end
    end
end

function ES_Utilities:Handler1(event, ...)
	if event == "WEEKLY_REWARDS_UPDATE" then
		addon.VaultCheck()
	elseif event == "CHALLENGE_MODE_COMPLETED" then
		local valid, _ = IsInInstance()
		ESUTIL_DB["chars"][addon.charName]["pending"] = valid
	end
end

function ES_Utilities:Handler2(event, ...)
	iterateBags()
	if ESUTIL_DB.toggles.drinkmacro then
		addon.updateDrinkMacro()
	end
	if ESUTIL_DB.toggles.weekly then
		addon.keyBagCheck()
	end
end

function ES_Utilities:Handler3(event, msg, playername, ...)
    if not (addon.charName == playername) then return end
    addon.linkKey(event, msg)
end

function ES_Utilities:Handler4(event, ...)
	addon.updateCurrencies()
end

function ES_Utilities:Handler5(event, ...)
	if GetCVarBool("autoLootDefault") == IsModifiedClick("AUTOLOOTTOGGLE") then return end
	addon.SimpleAutoLoot()
end

function ES_Utilities:Handler6(event, name, ...)
	if name == "Blizzard_EncounterJournal" then
		addon.eventRegister(false,"ADDON_LOADED")
		addon.collected_EJHooks()
	end
end

local function extractNumbers(s)
	return s:gmatch("%d+")
end
local function parseMacroentries()
	table.wipe(addon.currentMacroItems.defaults)
	for line in extractNumbers(ESUTIL_DB.drinkmacro.defaults) do
		local id = tonumber(line)
		if id then
			itemsToCheck[id] = true
			addon.currentMacroItems.defaults[id] = true
		end
	end
	table.wipe(addon.currentMacroItems.arena)
	for line in extractNumbers(ESUTIL_DB.drinkmacro.arena) do
		local id = tonumber(line)
		if id then
			itemsToCheck[id] = true
			addon.currentMacroItems.arena[id] = true
		end
	end
end

local bagEventListen = false
local function sharedBagCheck()
	local show = false
	table.wipe(itemsToCheck)
	if ESUTIL_DB.toggles.weekly then
		show = true
		for k,v in pairs(addon.items.keyIds) do
			if v then
				itemsToCheck[k] = v
			end
		end
	end
	if ESUTIL_DB.toggles.drinkmacro then
		show = true
		for k,v in pairs(addon.items.magefood) do
			if v then
				itemsToCheck[k] = v
			end
		end
		parseMacroentries()
	end
	if not show then
		if bagEventListen then
			bagEventListen = false
			ES_Utilities:UnregisterEvent("BAG_UPDATE_DELAYED")
		end
	else
		if not bagEventListen then
			bagEventListen = true
			ES_Utilities:RegisterEvent("BAG_UPDATE_DELAYED", "Handler2")
		end
		iterateBags()
	end
end

addon.eventRegister = function(enable,event,handler)
	if enable then
		ES_Utilities:RegisterEvent(event, handler)
	else
		ES_Utilities:UnregisterEvent(event)
	end
end

addon.toggleSettings = function(dbkey, enabled)
	ESUTIL_DB.toggles[dbkey] = enabled
	if dbkey == "vault" then
		addon.toggleVaultButton(enabled)
	elseif dbkey == "rewards" then
		addon.toggleRewards(enabled)
	elseif dbkey == "weekly" then
		if enabled then
			sharedBagCheck()
		end
		addon.toggleVaultProgress(enabled)
	elseif dbkey == "currency" then
		addon.toggleCurrencies(enabled)
	elseif dbkey == "autoloot" then
		addon.toggleAutoLoot(enabled)
	elseif dbkey == "collected" then
		addon.toggleCollected(enabled)
	elseif dbkey == "drinkmacro" then
		if enabled then
			sharedBagCheck()
		end
		addon.toggleDrinkingMacro(enabled)
	elseif dbkey == "talkinghead" then
		addon.toggleTalkingHead(enabled)
	end
end

function ES_Utilities:OnInitialize()
	local pFirst,_ = UnitName("player")
	addon.charName = pFirst .. '-' .. GetRealmName()
	ESUTIL_DB = ESUTIL_DB or defaultDB
	addon.setupConfig()
	for k,v in pairs(ESUTIL_DB.toggles) do
		addon.toggleSettings(k,v)
	end
end