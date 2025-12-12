local _, addon = ...
local isInitiated,isEnabled
local GetNumLootItems = GetNumLootItems
local GetLootSlotInfo = GetLootSlotInfo
local LootSlot = LootSlot

local function simpleAutoLoot()
	local numItems = GetNumLootItems()
	if numItems > 0 then
		for slotIndex = 1, numItems do
			local locked, _ = select(6, GetLootSlotInfo(slotIndex));
			if not locked then
				LootSlot(slotIndex)
			end
		end
	end
	CloseLoot()
end

local function autoLootInit()
	local warn = false
	local detected = ""
	if C_AddOns.IsAddOnLoaded("Plumber") and PlumberDB["LootUI"] then
		detected = detected .. 'Plumber (Loot window)\n'
		warn = true
	end
	if C_AddOns.IsAddOnLoaded("Leatrix_Plus") and (LeaPlusDB["FasterLooting"] == "On") then
		detected = detected .. 'Leatrix Plus (Faster auto loot)\n'
		warn = true
	end
	if warn then
		StaticPopupDialogs["ESUTILITIES_LTPWARN"] = {
			text = 'The following addons have their loot\nsettings enabled in addition to |cff00ffffES_Utilities|r.\n\n|cffFFFF00'.. detected ..'|r\nIt is adviced to only have one addon at a time using their autoloot settings.|r',
			button1 = "Close",
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show("ESUTILITIES_LTPWARN")
	end
	isInitiated = true
end

local EL = CreateFrame("Frame")
EL:SetScript("OnEvent", function(self, event, ...)
	if event == "LOOT_OPENED" then
		if GetCVarBool("autoLootDefault") == IsModifiedClick("AUTOLOOTTOGGLE") then return end
		simpleAutoLoot()
	end
end)

addon.toggleAutoLoot = function(enable)
    if enable and not isEnabled then
		if not isInitiated then
			autoLootInit()
		end
		EL:RegisterEvent("LOOT_OPENED")
		isEnabled = true
	elseif not enable and isEnabled then
		EL:UnregisterEvent("LOOT_OPENED")
		isEnabled = false
	end
end