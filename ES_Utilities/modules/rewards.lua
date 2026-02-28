local _, addon = ...
local isInitiated,isEnabled

local rewardFrame = CreateFrame("Frame", nil, _G["GameMenuFrame"])
rewardFrame:SetFrameStrata("TOOLTIP")
rewardFrame:SetSize(10,10)
rewardFrame:SetPoint("TOPRIGHT", 10, -10)
local rewardFrametxt, rewardFrame_OnShow

local function rewardFrame_Init()
	rewardFrametxt = rewardFrame:CreateFontString(nil, "OVERLAY")
	rewardFrametxt:SetPoint("TOPLEFT",0,0)
	rewardFrametxt:SetFont(addon.font_LiberationSansRegular, 18, "OUTLINE")
	rewardFrametxt:SetWidth(500)
	rewardFrametxt:SetText('')
	rewardFrametxt:SetJustifyH("LEFT")
	rewardFrame_OnShow = function()
		if not isEnabled then return end
		local rt = '|cff85ff00Available \nParagon Chest:|r\n\n'
		local show
		for i=1,#addon.factionIDs do
			local _, _, _, reward = C_Reputation.GetFactionParagonInfo(addon.factionIDs[i])
			if reward then
				if not show then show = true end
				local data = C_Reputation.GetFactionDataByID(addon.factionIDs[i])
				rt = rt .. (data and data.name or addon.factionIDs[i]) .. '\n'
			end
		end
		if show then
			rt = rt .. '\n\n' -- Make seperators for RenownQuests
		else
			rt = ""
		end
		rewardFrametxt:SetText(rt)
	end
	rewardFrame:SetScript("OnShow", rewardFrame_OnShow)
end

addon.toggleRewards = function(enable)
	if PlayerIsTimerunning() then return end
	if enable then
    	if not isInitiated then
			rewardFrame_Init()
			isInitiated = true
			isEnabled = true
		elseif not isEnabled then
			isEnabled = true
		end
	elseif isEnabled then
		isEnabled = false
		rewardFrametxt:SetText("")
	end
end