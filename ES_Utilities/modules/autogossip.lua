local _, addon = ...
local isEnabled

local skipEvents = {
	["QUEST_DETAIL"] = true,
	["GOSSIP_OPTIONS_REFRESHED"] = true,
	["GOSSIP_SHOW"] = true,
	["GOSSIP_CONFIRM"] = true,
}

local function activePopup()
	local anyVisible = false
	StaticPopup_ForEachShownDialog(function()
		anyVisible = true
	end)
	return anyVisible
end

local EL = CreateFrame("Frame")
EL:SetScript("OnEvent", function(self, event, ...)
	if activePopup() then return end
	local tbl = C_GossipInfo.GetOptions()
	local skip,quest
	for i=1,#tbl do
		if string.find(tbl[i].name, "Skip") then
			skip = tbl[i].gossipOptionID
		elseif bit.band(tbl[i].flags, 1) == 1 then
			quest = tbl[i].gossipOptionID
		end
	end
	if skip then
		C_GossipInfo.SelectOption(skip)
	elseif quest then
		C_GossipInfo.SelectOption(quest)
	end
end)

addon.toggleAutoGossip = function(enable)
    if enable and not isEnabled then
        for evt,_ in pairs(skipEvents) do
			EL:RegisterEvent(evt)
		end
		isEnabled = true
	elseif not enable and isEnabled then
        for evt,_ in pairs(skipEvents) do
			EL:UnregisterEvent(evt)
		end
		isEnabled = false
	end
end