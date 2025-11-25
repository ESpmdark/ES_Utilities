local _, addon = ...
local isInitiated = false
local isEnabled = false

local loopTimer = CreateFrame("Frame", nil, UIParent)
loopTimer:Hide()
local loopCount = 0

local displayFrame, txt, txt1, affix1, affix2, affix3, affix4, bTop, bBot, bLeft, bRight
local function createProgressDisplay()
	displayFrame = CreateFrame("Frame","ES_Utilities_Display", UIParent)
	txt = displayFrame:CreateTexture()
	txt:SetAllPoints()
	txt:SetColorTexture(0, 0, 0, 0.8)
	displayFrame:SetPoint("TOPLEFT", 1, -1)
	displayFrame:SetSize(600,200)
	displayFrame:SetFrameStrata("DIALOG")
	displayFrame:Hide()

	txt1 = displayFrame:CreateFontString(nil, "OVERLAY")
	txt1:SetPoint("TOPLEFT",6,-32)
	txt1:SetFont(addon.font_LiberationSansRegular, 14, "OUTLINE")
	txt1:SetText('')
	txt1:SetJustifyH("LEFT")

	affix1 = CreateFrame("Frame", nil, displayFrame)
	affix1:SetSize(24,24)
	affix1:SetPoint("TOPRIGHT", displayFrame, "TOP", -26, -6)
	affix1.t = affix1:CreateTexture()
	affix1.t:SetAllPoints()

	affix2 = CreateFrame("Frame", nil, displayFrame)
	affix2:SetSize(24,24)
	affix2:SetPoint("TOPRIGHT", displayFrame, "TOP", -1, -6)
	affix2.t = affix2:CreateTexture()
	affix2.t:SetAllPoints()

	affix3 = CreateFrame("Frame", nil, displayFrame)
	affix3:SetSize(24,24)
	affix3:SetPoint("TOPLEFT", displayFrame, "TOP", 1, -6)
	affix3.t = affix3:CreateTexture()
	affix3.t:SetAllPoints()

	affix4 = CreateFrame("Frame", nil, displayFrame)
	affix4:SetSize(24,24)
	affix4:SetPoint("TOPLEFT", displayFrame, "TOP", 26, -6)
	affix4.t = affix4:CreateTexture()
	affix4.t:SetAllPoints()

	bTop = displayFrame:CreateTexture()
	bTop:SetPoint("BOTTOMLEFT", displayFrame, "TOPLEFT", -1, -1)
	bTop:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", 1, 1)
	bTop:SetColorTexture(.2, .2, .2, 1)

	bBot = displayFrame:CreateTexture()
	bBot:SetPoint("BOTTOMLEFT", displayFrame, "BOTTOMLEFT", -1, -1)
	bBot:SetPoint("TOPRIGHT", displayFrame, "BOTTOMRIGHT", 1, 1)
	bBot:SetColorTexture(.2, .2, .2, 1)

	bLeft = displayFrame:CreateTexture()
	bLeft:SetPoint("BOTTOMLEFT", displayFrame, "BOTTOMLEFT", -1, -1)
	bLeft:SetPoint("TOPRIGHT", displayFrame, "TOPLEFT", 1, 1)
	bLeft:SetColorTexture(.2, .2, .2, 1)

	bRight = displayFrame:CreateTexture()
	bRight:SetPoint("BOTTOMLEFT", displayFrame, "BOTTOMRIGHT", -1, -1)
	bRight:SetPoint("TOPRIGHT", displayFrame, "TOPRIGHT", 1, 1)
	bRight:SetColorTexture(.2, .2, .2, 1)
end

addon.VaultCheck = function()
	if ESUTIL_DB.chars[addon.charName].curvault then return end
	local rt
	local vault = C_WeeklyRewards.GetActivities()
	local t = {}
	for _, slot in pairs(vault) do
		if slot.progress >= slot.threshold then
			if not t[slot.type] then
				t[slot.type] = 1
			else
				t[slot.type] = t[slot.type] + 1
			end
		end
	end
	local d = (t[1] and ("Dungeon("..t[1]..")  ") or "")
	local p = (t[6] and ("World("..t[6]..")  ") or "")
	local r = (t[3] and ("Raid("..t[3]..")") or "")
	if (d..p..r) ~= "" then rt = (d..p..r) end
	ESUTIL_DB.chars[addon.charName].nextvault = rt or false
end

local function ES_TblSort(entry1, entry2)
    if ( entry1.level == entry2.level ) then
		return entry1.mapChallengeModeID < entry2.mapChallengeModeID;
	else
		return entry1.level > entry2.level;
	end
end

local function ES_MplusProg()
    local string = ""
    local nr = 1
	C_MythicPlus.RequestMapInfo()
    local runs = C_MythicPlus.GetRunHistory(false,true)
	if #runs > ESUTIL_DB.chars[addon.charName].keynr then
		ESUTIL_DB.chars[addon.charName].keynr = #runs
		if #runs > 0 then
			table.sort(runs, ES_TblSort)
			for _,run in pairs(runs) do
				if nr > 8 then break end
				if (nr == 1) or (nr == 4) or (nr == 8) then
					string = string .. '|cff64C864' .. tostring(run.level) .. '|r , '
				else
					string = string .. tostring(run.level) .. ' , '
				end        
				nr = nr + 1
			end
			if strsub(string, -2) == ", " then
				string = strsub(string, 1,(strlen(string)-2))
			end
		end
		if string ~= ESUTIL_DB.chars[addon.charName].dung then
			ESUTIL_DB.chars[addon.charName].dung = string
			PlaySound(23332, "Master", true)
			print('|cff6495edES_Utilities:|r' .. ' Updated top 8 M+ runs!')
		end
		ESUTIL_DB.chars[addon.charName].pending = false
	end
end



local function ES_KeyFormat()
	local rt
	local keylvl = C_MythicPlus.GetOwnedKeystoneLevel()
	if keylvl then
		local MapID = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
		local name1, _, _, _, _ = C_ChallengeMode.GetMapUIInfo(MapID)
		rt = '|cffa335ee[Keystone: ' .. name1 .. " (" .. keylvl .. ")]" .. '|r'
	end
    return rt or false
end

local function ES_LinkKey(personal, chan)
	if personal then
		if ESUTIL_DB.chars[addon.charName].keylink then
			C_ChatInfo.SendChatMessage(ESUTIL_DB.chars[addon.charName].keylink, chan)
		else
			print('|cff6495edES_Utilities:|r This character has no keystone to link!')
		end
	else
		for charN,charX in pairs(ESUTIL_DB.chars) do
			local msg = ""
			if charX.keylink then
				local cleanname, _ = strsplit("-",charN,2)
				msg = '('..cleanname..') '..charX.keylink
			end
			C_ChatInfo.SendChatMessage(msg, chan)
		end
	end
end

local function ES_Utilities_GetKeystoneData()
	local str = 'Type "!mykeys" in party or guild chat to report your current keys\n\n'
	local str2 = ""
	local str3 = ""
	for idx,charX in pairs(ESUTIL_DB.chars) do
		local left = ''
		local right = ''
		if idx == addon.charName then
			left = '|TInterface\\CovenantRenown\\CovenantRenownUI.PNG:12:14:0:0:1024:512:965:930:85:118:|t  '
		end
		local pending = ''
		if charX.pending then pending = '|TInterface\\Buttons\\UI-RefreshButton.PNG:12|t' end
		if charX.keylink then
			str = str .. left .. charX.name .. ' - ' .. charX.keystr .. ' ' .. charX.dung .. pending .. right .. '\n'
		end
		if charX.nextvault then
			if str3 == "" then
				str3 = '\n\n|TInterface\\RAIDFRAME\\ReadyCheck-Ready.PNG:12|tNext vault:\n'
			end
			str3 = str3 .. charX.name .. '|cffbfbfbf: ' .. charX.nextvault .. '|r\n'
		end
		if charX.curvault then
			str2 = str2 .. left .. charX.name .. right .. '\n'
		end
    end
	if str2 ~= "" then str2 = '\n\n|TInterface\\WorldMap\\TreasureChest_64.PNG:14|t Vault Rewards |TInterface\\WorldMap\\TreasureChest_64.PNG:14|t\n' .. str2 end
	return str .. str2 .. str3
end

local nextResetCheck
local lastResetCheck
local function checkWeeklyReset()
	local sec = C_DateAndTime.GetSecondsUntilWeeklyReset()
	--// Cant find an event that triggers on daily/weekly reset. Need this workaround to allow for the 4sec timer to check for us.
	-- Using this snippet to throttle the code so it doesnt check so frequently until the actualy reset is approaching.
	nextResetCheck = nextResetCheck or sec
	lastResetCheck = lastResetCheck or sec + 1
	if (nextResetCheck < sec) and (lastResetCheck > sec) then return end
	if sec >= 60 then
		nextResetCheck = math.floor(sec / 2)
	else
		nextResetCheck = sec
	end
	lastResetCheck = sec
	--//
	local currdate = C_DateAndTime.GetCurrentCalendarTime()
	local adjusted = C_DateAndTime.AdjustTimeByDays(currdate, -6)
	local comparison = C_DateAndTime.CompareCalendarTime(ESUTIL_DB.last, adjusted) or 2
	if ESUTIL_DB.reset < sec  or (comparison == 1 and ESUTIL_DB.reset > sec ) then
		local vaultcount = 0
		for _,charX in pairs(ESUTIL_DB.chars) do
			charX.keystr = nil
			charX.keynr = 0
			charX.pending = false
			charX.dung = ""
			charX.keylink = false
			if charX.nextvault then
				charX.curvault = true
				vaultcount = vaultcount + 1
				charX.nextvault = false
			end
		end
		if vaultcount > 0 then
			PlaySound(31578, "Master", true)
			print('|cff6495edES_Utilities:|r' .. ' Weekly reset has occurred!')
			print('|cff6495edES_Utilities:|r ' .. vaultcount ..' character' .. ((vaultcount > 1 and 's') or '') .. ' have rewards waiting.')
		end
	end
	ESUTIL_DB.reset = sec
	ESUTIL_DB.last = currdate
end

local lastbagcheck = 0
local function ES_Utilities_KeyUpdate()
	for itemID,show in pairs(addon.items.keyIds) do
		if show then
			local link = addon.currentInventory[itemID]
			if link then
				ESUTIL_DB.chars[addon.charName].keystr = ES_KeyFormat()
				ESUTIL_DB.chars[addon.charName].keylink = link
			end
		end
	end
end

addon.checkCharEntry = function()
	if PlayerIsTimerunning() then return end
	if not ESUTIL_DB.chars[addon.charName] then
		local cFname, _ = UnitClassBase("player")
		local hex = C_ClassColor.GetClassColor(cFname):GenerateHexColor()
		ESUTIL_DB.chars[addon.charName] = {
			name = '|c'..hex..addon.charName..'|r',
			curvault = C_WeeklyRewards.HasAvailableRewards() or C_WeeklyRewards.HasGeneratedRewards(),
			dung = "",
			keylink = false,
			keystr = "",
			keynr = 0,
			pending = false
		}
	end
	ES_Utilities_KeyUpdate()
	addon.VaultCheck()
	if not ESUTIL_DB.chars[addon.charName].keynr then
		ESUTIL_DB.chars[addon.charName].keynr = 0
		ES_MplusProg()
	end
end

local function updateAffixIcons(tt,success)
	if success then
		affix1.t:SetTexture(tt[1]["i"])
		affix1:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(tt[1]["t"], 1, 0.8, 0, 1, true)
		end)
		affix1:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		affix2.t:SetTexture(tt[2]["i"])
		affix2:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(tt[2]["t"], 1, 0.8, 0, 1, true)
		end)
		affix2:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		affix3.t:SetTexture(tt[3]["i"])
		affix3:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(tt[3]["t"], 1, 0.8, 0, 1, true)
		end)
		affix3:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
		affix4.t:SetTexture(tt[4]["i"])
		affix4:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText(tt[4]["t"], 1, 0.8, 0, 1, true)
		end)
		affix4:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	else
		affix2.t:SetTexture("Interface\\EncounterJournal\\UI-EJ-WarningTextIcon")
		affix2:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")
			GameTooltip:SetText('Could not retrieve affix data.\n\nTry reloading your interface.')
		end)
		affix2:SetScript("OnLeave", function(self)
			GameTooltip:Hide()
		end)
	end
end

local function get_line_count(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then lines = lines + 1 end
    end
    return lines
end

local function displayFrame_Show()
	local txt = ES_Utilities_GetKeystoneData()
	local count = get_line_count(txt)
	txt1:SetText(txt)
	displayFrame:SetHeight(31 + (14 * count))
	local widthBase = math.floor(txt1:GetWrappedWidth() + 12)
	local widthVar = math.floor(txt1:GetWrappedWidth() + 12)
	displayFrame:SetWidth(((widthVar >= widthBase) and widthVar) or widthBase)
end


addon.keyBagCheck = function()
    if (GetTime() - lastbagcheck) >= 3 then
		lastbagcheck = GetTime()
		if ESUTIL_DB.chars[addon.charName].curvault then
			C_Timer.After(1, function()
				if not C_WeeklyRewards.HasAvailableRewards() and not C_WeeklyRewards.HasGeneratedRewards() then
					ESUTIL_DB.chars[addon.charName].curvault = false
				end
				ES_Utilities_KeyUpdate()
			end)
		else
			ES_Utilities_KeyUpdate()
		end
	end
end

addon.linkKey = function(event, msg)
    if msg and string.lower(msg) == "!mykeys" then
        if (event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER") then
            ES_LinkKey(false,"PARTY")
        elseif (event == "CHAT_MSG_GUILD") then
            ES_LinkKey(false,"GUILD")
        end
	elseif msg and string.lower(msg) == "!mykey" then
        if (event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER") then
            ES_LinkKey(true,"PARTY")
        elseif (event == "CHAT_MSG_GUILD") then
            ES_LinkKey(true,"GUILD")
        end
    end
end

local function loopTimer_OnUpdate(self,elapsed)
    loopCount = loopCount + elapsed
	if loopCount >= 4 then -- 4 sec timer for pending MythicPlusProgression and weekly reset check
		loopCount = 0
		if ESUTIL_DB.chars[addon.charName] and ESUTIL_DB.chars[addon.charName].pending then
		    ES_MplusProg()
		    ES_Utilities_KeyUpdate()
	    end
	    checkWeeklyReset()
	end
end
loopTimer:SetScript("OnUpdate", loopTimer_OnUpdate)

local function toggleESUD(show)
	if not isEnabled then return end
    if show then
		displayFrame:Show()
	else
		displayFrame:Hide()
	end
end

local function showFrames()
	isEnabled = true
	loopTimer:Show()
end

local function hideFrames()
	isEnabled = false
	loopTimer:Hide()
end

local function vaultProgressInit()
	createProgressDisplay()
	displayFrame:SetScript("OnShow", displayFrame_Show)
    hooksecurefunc(_G["GameMenuFrame"], "Hide", function()
		toggleESUD(false)
	end)
	hooksecurefunc(_G["GameMenuFrame"], "Show", function()
		toggleESUD(true)
	end)
	if not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
		C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
	end
	--if not (UnitAffectingCombat("player") or InCombatLockdown()) then
		--ShowUIPanel(WeeklyRewardsFrame)
		--HideUIPanel(WeeklyRewardsFrame)
		-- Is this completely wasted crap that I added early on when I didnt understand how to ensure dataloading? Keeping it commented out for a while to see if it has any impact.
	--end
	checkWeeklyReset()
	addon.checkCharEntry()
	local afx = C_MythicPlus.GetCurrentAffixes()
	local lvl = {[1]=4,[2]=7,[3]=10,[4]=12}
	local afDt = {[1]={t="",i=0},[2]={t="",i=0},[3]={t="",i=0},[4]={t="",i=0}}
	if afx and (#afx >= 1) then
		for i=1,#afx do
			local name, description, icon = C_ChallengeMode.GetAffixInfo(afx[i].id)
			afDt[i].t = '|cffffffff' .. name .. '|r |cff00bcff(+' .. lvl[i] .. ')|r\n\n' .. description
			afDt[i].i = icon
		end
		updateAffixIcons(afDt, true)
	else
		updateAffixIcons(afDt, false)
	end
end

local function prepEvents(enabled)
	if not PlayerIsTimerunning() then
		addon.eventRegister(enabled,"WEEKLY_REWARDS_UPDATE", "Handler1")
		addon.eventRegister(enabled,"CHALLENGE_MODE_COMPLETED", "Handler1")
	end
	addon.eventRegister(enabled,"CHAT_MSG_PARTY", "Handler3")
	addon.eventRegister(enabled,"CHAT_MSG_PARTY_LEADER", "Handler3")
	addon.eventRegister(enabled,"CHAT_MSG_GUILD", "Handler3")
end

addon.toggleVaultProgress = function(enable)
    if enable then
		if not isInitiated then
			vaultProgressInit()
			isInitiated = true
			showFrames()
			prepEvents(true)
		elseif not isEnabled then
			showFrames()
			prepEvents(true)
		end
	elseif isEnabled then
		prepEvents(false)
		hideFrames()
	end
end