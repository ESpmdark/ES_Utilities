local _, addon = ...
local EL = CreateFrame("Frame") -- EventListener
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
		extraactionbutton = false,
		lossofcontrol = false,
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

local isBagEventActive = false
local function sharedBagPrep()
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
		if isBagEventActive then
			isBagEventActive = false
			EL:UnregisterEvent("BAG_UPDATE_DELAYED")
		end
	else
		if not isBagEventActive then
			isBagEventActive = true
			EL:RegisterEvent("BAG_UPDATE_DELAYED")
		end
		iterateBags()
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
			sharedBagPrep()
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
			sharedBagPrep()
		end
		addon.toggleDrinkingMacro(enabled)
	elseif dbkey == "talkinghead" then
		addon.toggleTalkingHead(enabled)
	elseif dbkey == "extraactionbutton" then
		addon.toggleButtonArt(enabled)
	elseif dbkey == "lossofcontrol" then
		addon.toggleLossOfControl(enabled)
	end
end

local function InitializeAddon()
	local pFirst,_ = UnitName("player")
	addon.charName = pFirst .. '-' .. GetRealmName()
	ESUTIL_DB = ESUTIL_DB or defaultDB

	for k,v in pairs(defaultDB) do -- Handle new defaults for user
		if not (k == "chars") then -- Ignore this one
			if ESUTIL_DB[k] == nil then
				ESUTIL_DB[k] = v
			elseif type(v) == "table" then
				for k2,v2 in pairs(v) do
					if ESUTIL_DB[k][k2] == nil then
						ESUTIL_DB[k][k2] = v2
					end
				end
			end
		end
	end

	addon.setupConfig()
	for k,v in pairs(ESUTIL_DB.toggles) do
		addon.toggleSettings(k,v)
	end
end

EL:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		EL:UnregisterEvent("PLAYER_ENTERING_WORLD")
		InitializeAddon()
	elseif event == "BAG_UPDATE_DELAYED" then
		iterateBags()
		if ESUTIL_DB.toggles.drinkmacro then
			addon.updateDrinkMacro()
		end
		if ESUTIL_DB.toggles.weekly and not PlayerIsTimerunning() then
			addon.keyBagCheck()
		end
	end
end)
EL:RegisterEvent("PLAYER_ENTERING_WORLD")