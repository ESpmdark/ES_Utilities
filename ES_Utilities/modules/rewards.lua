local _, addon = ...
local isInitiated,isEnabled

local rewardFrame = CreateFrame("Frame", nil, _G["GameMenuFrame"])
rewardFrame:SetFrameStrata("TOOLTIP")
rewardFrame:SetSize(10,10)
rewardFrame:SetPoint("TOPRIGHT", 10, -10)
local rewardFrametxt, getRenownQuests, rewardFrame_OnShow

local function rewardFrame_Init()
	rewardFrametxt = rewardFrame:CreateFontString(nil, "OVERLAY")
	rewardFrametxt:SetPoint("TOPLEFT",0,0)
	rewardFrametxt:SetFont(addon.font_LiberationSansRegular, 18, "OUTLINE")
	rewardFrametxt:SetWidth(500)
	rewardFrametxt:SetText('')
	rewardFrametxt:SetJustifyH("LEFT")

	getRenownQuests = function()
		local str = ""
		for name,info in pairs(addon.currentRenowns) do
			local tbl = C_MajorFactions.GetRenownLevels(info.fid)
			local level = 0
			for j=1,#tbl do
				if not tbl[j].locked then
					level = j
				else
					break
				end
			end
			local count = 0
			if level >= 1 then
				for k=1,level do
					local tmp = info.id[k]
					if tmp then
						for _,v in ipairs(tmp) do
							if not C_QuestLog.IsQuestFlaggedCompleted(v) then
								count = count + 1
							end
						end
					end
				end
			end
			if count >= 1 then
				str = str .. '\n' .. name .. ': ' .. count
			end
		end
		if str ~= "" then
			str = "- Renown rewards -" .. str
		end
		return str
	end

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
		if ESUTIL_DB.toggles.renown then
			rt = rt .. getRenownQuests()
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