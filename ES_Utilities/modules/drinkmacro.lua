local _, addon = ...
local isInitiated,isEnabled
local EL = CreateFrame("Frame")

local function ESDM_ItemCheck(tbl)
	local rt = false
	for item,_ in pairs(tbl) do
		if addon.currentInventory[item] then
			rt = "/use item:" .. item
			break
		end
	end
	return rt
end

addon.updateDrinkMacro = function()
	if addon.CombatCheck() then return end
	local actualIndex = GetMacroIndexByName(ESUTIL_DB.drinkmacro.name)
	if actualIndex and actualIndex ~= 0 then
		local macro = "#showtooltip\n"
		local item = ""
		local mf = ESDM_ItemCheck(addon.items.magefood)
		if mf then
			item = mf
		else
			if C_PvP.IsArena() then
				local aw = ESDM_ItemCheck(addon.currentMacroItems.arena)
				if aw then
					item = aw
				end
			else
				local df = ESDM_ItemCheck(addon.currentMacroItems.defaults)
				if df then
					item = df
				end
			end
		end
		EditMacro(actualIndex, nil, nil, macro .. item)
	end
end

local function drinkMacroInit()
	if not C_AddOns.IsAddOnLoaded("Blizzard_MacroUI") then
		C_AddOns.LoadAddOn("Blizzard_MacroUI")
	end
	isInitiated = true
end

local function drinkMacroToggle(enable)
	if enable and not isEnabled then
		EL:RegisterEvent("PLAYER_REGEN_ENABLED")
		isEnabled = true
		addon.updateDrinkMacro()
	elseif isEnabled then
		EL:UnregisterEvent("PLAYER_REGEN_ENABLED")
		isEnabled = false
	end
end

addon.toggleDrinkingMacro = function(enable)
    if enable and not isInitiated then
		drinkMacroInit()
	end
	drinkMacroToggle(enable)
end

EL:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		addon.updateDrinkMacro()
	end
end)