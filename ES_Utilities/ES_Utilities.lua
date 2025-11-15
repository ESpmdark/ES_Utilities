local _, addon = ...
ES_Utilities = LibStub("AceAddon-3.0"):NewAddon("ES_Utilities", "AceEvent-3.0")
local ESU_Frame = CreateFrame("Frame","ESU_Frame_Timer", UIParent)
ESU_Frame:Hide()
local ESU_Timer = 0
local ESU_TimerP = 0
local ESU_TimerWA = 0
local pName
addon.font_LiberationSansRegular = "Interface\\Addons\\ES_Utilities\\fonts\\LiberationSans-Regular.TTF"

-- Add Vault-button to ESC menu
local function greatVault_Init()
	_G["GameMenuFrame"].Header.Text:SetText(" ") -- Button covers it partially
	local greatVault = CreateFrame("Frame", "ES_Utilities_GreatVault", _G["GameMenuFrame"])
	greatVault:SetFrameStrata("TOOLTIP")
	greatVault:SetSize(64,64)
	greatVault:SetPoint("TOP", 0, 24)
	greatVault.t = greatVault:CreateTexture(nil, "ARTWORK", nil, 1)
	greatVault.t:SetAtlas("greatVault-dis-start")
	greatVault.t:SetPoint("CENTER", 0, 0)
	greatVault.t:SetSize(80,80)
	greatVault.t2 = greatVault:CreateTexture(nil, "ARTWORK", nil, 2)
	greatVault.t2:SetAtlas("greatVault-frame-whole")
	greatVault.t2:SetPoint("CENTER", 0, 0)
	greatVault.t2:SetSize(80,80)
	greatVault.t2:Hide()
	greatVault:SetScript("OnMouseDown", function()
		if not WeeklyRewardsFrame:IsVisible() then
			HideUIPanel(GameMenuFrame)
			WeeklyRewardsFrame:Show()
		end
	end)
	greatVault:SetScript("OnEnter", function()
		greatVault.t2:Show()
	end)
	greatVault:SetScript("OnLeave", function()
		greatVault.t2:Hide()
	end)
end
--

-- Better Autoloot
local GetNumLootItems = GetNumLootItems
local GetLootSlotInfo = GetLootSlotInfo
local LootSlot = LootSlot
local function ES_Utilities_SimpleAutoLoot()
	local numItems = GetNumLootItems()
	if numItems > 0 then
		for slotIndex = 1, numItems do
			local locked, _ = select(6, GetLootSlotInfo(slotIndex));
			--if LootSlotHasItem(slotIndex) and not locked then
			if not locked then
				LootSlot(slotIndex)
			end
		end
	end
	CloseLoot()
end
--

-- Keystone Window
local ESUD_Frame, txt, txt1, affix1, affix2, affix3, affix4, bTop, bBot, bLeft, bRight
local function ESUD_Frame_Init()
	ESUD_Frame = CreateFrame("Frame","ES_Utilities_Display", UIParent)
	txt = ESUD_Frame:CreateTexture()
	txt:SetAllPoints()
	txt:SetColorTexture(0, 0, 0, 0.8)
	ESUD_Frame:SetPoint("TOPLEFT", 1, -1)
	ESUD_Frame:SetSize(600,200)
	ESUD_Frame:SetFrameStrata("DIALOG")
	ESUD_Frame:Hide()

	txt1 = ESUD_Frame:CreateFontString(nil, "OVERLAY")
	txt1:SetPoint("TOPLEFT",6,-32)
	txt1:SetFont(addon.font_LiberationSansRegular, 14, "OUTLINE")
	txt1:SetText('')
	txt1:SetJustifyH("LEFT")

	affix1 = CreateFrame("Frame", nil, ESUD_Frame)
	affix1:SetSize(24,24)
	affix1:SetPoint("TOPRIGHT", ESUD_Frame, "TOP", -26, -6)
	affix1.t = affix1:CreateTexture()
	affix1.t:SetAllPoints()

	affix2 = CreateFrame("Frame", nil, ESUD_Frame)
	affix2:SetSize(24,24)
	affix2:SetPoint("TOPRIGHT", ESUD_Frame, "TOP", -1, -6)
	affix2.t = affix2:CreateTexture()
	affix2.t:SetAllPoints()

	affix3 = CreateFrame("Frame", nil, ESUD_Frame)
	affix3:SetSize(24,24)
	affix3:SetPoint("TOPLEFT", ESUD_Frame, "TOP", 1, -6)
	affix3.t = affix3:CreateTexture()
	affix3.t:SetAllPoints()

	affix4 = CreateFrame("Frame", nil, ESUD_Frame)
	affix4:SetSize(24,24)
	affix4:SetPoint("TOPLEFT", ESUD_Frame, "TOP", 26, -6)
	affix4.t = affix4:CreateTexture()
	affix4.t:SetAllPoints()

	bTop = ESUD_Frame:CreateTexture()
	bTop:SetPoint("BOTTOMLEFT", ESUD_Frame, "TOPLEFT", -1, -1)
	bTop:SetPoint("TOPRIGHT", ESUD_Frame, "TOPRIGHT", 1, 1)
	bTop:SetColorTexture(.2, .2, .2, 1)

	bBot = ESUD_Frame:CreateTexture()
	bBot:SetPoint("BOTTOMLEFT", ESUD_Frame, "BOTTOMLEFT", -1, -1)
	bBot:SetPoint("TOPRIGHT", ESUD_Frame, "BOTTOMRIGHT", 1, 1)
	bBot:SetColorTexture(.2, .2, .2, 1)

	bLeft = ESUD_Frame:CreateTexture()
	bLeft:SetPoint("BOTTOMLEFT", ESUD_Frame, "BOTTOMLEFT", -1, -1)
	bLeft:SetPoint("TOPRIGHT", ESUD_Frame, "TOPLEFT", 1, 1)
	bLeft:SetColorTexture(.2, .2, .2, 1)

	bRight = ESUD_Frame:CreateTexture()
	bRight:SetPoint("BOTTOMLEFT", ESUD_Frame, "BOTTOMRIGHT", -1, -1)
	bRight:SetPoint("TOPRIGHT", ESUD_Frame, "TOPRIGHT", 1, 1)
	bRight:SetColorTexture(.2, .2, .2, 1)
end
--

local function ES_VaultCheck()
	if ESUTIL_DB["chars"][pName]["curvault"] then return end
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
	ESUTIL_DB["chars"][pName]["nextvault"] = rt or false
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
	if #runs > ESUTIL_DB["chars"][pName]["keynr"] then
		ESUTIL_DB["chars"][pName]["keynr"] = #runs
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
		if string ~= ESUTIL_DB["chars"][pName]["dung"] then
			ESUTIL_DB["chars"][pName]["dung"] = string
			PlaySound(23332, "Master", true)
			print('|cff6495edES_Utilities:|r' .. ' Updated top 8 M+ runs!')
		end
		ESUTIL_DB["chars"][pName]["pending"] = false
	end
end

local function ES_KeyFormat(isTimewalk, itemLink)
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
		if ESUTIL_DB["chars"][pName]["keylink"] then
			C_ChatInfo.SendChatMessage(ESUTIL_DB["chars"][pName]["keylink"], chan)
		else
			print('|cff6495edES_Utilities:|r This character has no keystone to link!')
		end
	else
		for charN,charX in pairs(ESUTIL_DB["chars"]) do
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
	local str = 'Type "!mykeys" in party or guild chat to report your current keys\n'
	local str2 = ""
	local str3 = ""
	for idx,charX in pairs(ESUTIL_DB["chars"]) do
		local left = ''
		local right = ''
		if idx == pName then
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
local function ES_CheckWeeklyReset()
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
	if not ESUTIL_DB["reset"] or not ESUTIL_DB["last"] then
		ESUTIL_DB["reset"] = sec
		ESUTIL_DB["last"] = currdate
		return
	end
	local adjusted = C_DateAndTime.AdjustTimeByDays(currdate, -6)
	local comparison = C_DateAndTime.CompareCalendarTime(ESUTIL_DB["last"], adjusted) or 2
	if ESUTIL_DB["reset"] < sec  or (comparison == 1 and ESUTIL_DB["reset"] > sec ) then
		local vaultcount = 0
		for _,charX in pairs(ESUTIL_DB["chars"]) do
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
	ESUTIL_DB["reset"] = sec
	ESUTIL_DB["last"] = currdate
end

local lastbagcheck = 0
local function ES_Utilities_KeyUpdate()
	local keyIds = {
        [138019] = true, -- Legion
        [158923] = true, -- BfA
        [180653] = true, -- Shadowlands, Dragonflight and The War Within
		[187786] = true, -- Timewalking. Currently not tracking this
        [151086] = true, -- Tournament
    }
	local isTimewalk
    local rt
    for bag = 0, NUM_BAG_SLOTS do
        local bSlots = C_Container.GetContainerNumSlots(bag)
        if not bSlots then break end
        for slot = 1, bSlots do
			local item =  C_Container.GetContainerItemInfo(bag, slot)
            if item and keyIds[item.itemID] then
				if item.itemID == 187786 then
					isTimewalk = true
				end
				rt = item.hyperlink
            end
        end
    end
	if rt then
		ESUTIL_DB["chars"][pName]["keystr"] = ES_KeyFormat(isTimewalk, rt)
		ESUTIL_DB["chars"][pName]["keylink"] = rt
	end
end

function ES_Utilities:Handler1(event, ...)
	if event == "WEEKLY_REWARDS_UPDATE" then
		ES_VaultCheck()
	elseif event == "CHALLENGE_MODE_COMPLETED" then
		local valid, _ = IsInInstance()
		ESUTIL_DB["chars"][pName]["pending"] = valid
	end
end

function ES_Utilities:Handler2(event, ...)
	if (GetTime() - lastbagcheck) >= 3 then
		lastbagcheck = GetTime()
		if ESUTIL_DB["chars"][pName]["curvault"] then
			C_Timer.After(1, function()
				if not C_WeeklyRewards.HasAvailableRewards() and not C_WeeklyRewards.HasGeneratedRewards() then
					ESUTIL_DB["chars"][pName]["curvault"] = false
				end
				ES_Utilities_KeyUpdate()
			end)
		else
			ES_Utilities_KeyUpdate()
		end
	end
end

function ES_Utilities:Handler3(event, msg, playername, ...)
    if not (pName == playername) then return end
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

function ES_Utilities:Handler4(event, ...)
	addon.updateCurrencies()
end

function ES_Utilities:Handler5(event, ...)
	if GetCVarBool("autoLootDefault") == IsModifiedClick("AUTOLOOTTOGGLE") then return end
	ES_Utilities_SimpleAutoLoot()
end

local function ESCreateTooltip(tt,success)
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

local function ESU_CheckCharEntry()
	if PlayerIsTimerunning() then return end
	if not ESUTIL_DB["chars"][pName] then
		local cFname, _ = UnitClassBase("player")
		local hex = C_ClassColor.GetClassColor(cFname):GenerateHexColor()
		ESUTIL_DB["chars"][pName] = {
			name = '|c'..hex..pName..'|r',
			curvault = C_WeeklyRewards.HasAvailableRewards() or C_WeeklyRewards.HasGeneratedRewards(),
			dung = "",
			keylink = false,
			keystr = "",
			keynr = 0,
			pending = false
		}
	end
	ES_Utilities_KeyUpdate()
	ES_VaultCheck()
	if not ESUTIL_DB["chars"][pName]["keynr"] then
		ESUTIL_DB["chars"][pName]["keynr"] = 0
		ES_MplusProg()
	end
end

function ES_Utilities_DelayedInit()
	if ESUTIL_DB["toggles"]["vault"] and not PlayerIsTimerunning() then
		if not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
			C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
		end
		local frame = "WeeklyRewardsFrame"
		if not tContains(UISpecialFrames, frame) then
			tinsert(UISpecialFrames, frame)
		end
		greatVault_Init()
	end

	if ESUTIL_DB["toggles"]["rewards"] and not PlayerIsTimerunning() then
		addon.rewardFrame_Init()
	end

	if ESUTIL_DB["toggles"]["currency"] and not PlayerIsTimerunning() then
		addon.ESUC_Frame_Init()
		ES_Utilities:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "Handler4")
	end

	if ESUTIL_DB["toggles"]["autoloot"] then
		ES_Utilities:RegisterEvent("LOOT_OPENED", "Handler5")

		--Check if you have plumber/leatrix, and their looting settings enabled
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
		--
	end

	if ESUTIL_DB["toggles"]["weekly"] then
		ES_Utilities:CreateKeysFrames()
		hooksecurefunc(_G["GameMenuFrame"], "Hide", function()
			ES_Utilities_ShowHide(false)
		end)
		hooksecurefunc(_G["GameMenuFrame"], "Show", function()
			ES_Utilities_ShowHide(true)
		end)
		if not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
			C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
		end
		--if not (UnitAffectingCombat("player") or InCombatLockdown()) then
			--ShowUIPanel(WeeklyRewardsFrame)
			--HideUIPanel(WeeklyRewardsFrame)
			-- Is this completely wasted crap that I added early on when I didnt understand how to ensure dataloading? Keeping it commented out for a while to see if it has any impact.
		--end

		ES_CheckWeeklyReset()
		local pFirst,pLast = UnitFullName("player")
		pName = pFirst .. '-' .. pLast
		if not ESUTIL_DB["chars"] then
			ESUTIL_DB["chars"] = {}
		end
		ESU_CheckCharEntry()
		if not PlayerIsTimerunning() then
			ES_Utilities:RegisterEvent("WEEKLY_REWARDS_UPDATE", "Handler1")
			ES_Utilities:RegisterEvent("CHALLENGE_MODE_COMPLETED", "Handler1")
			ES_Utilities:RegisterEvent("BAG_UPDATE", "Handler2")
		end
		ES_Utilities:RegisterEvent("CHAT_MSG_PARTY", "Handler3")
		ES_Utilities:RegisterEvent("CHAT_MSG_PARTY_LEADER", "Handler3")
		ES_Utilities:RegisterEvent("CHAT_MSG_GUILD", "Handler3")

		local afx = C_MythicPlus.GetCurrentAffixes()
		local lvl = {
			[1] = 4,
			[2] = 7,
			[3] = 10,
			[4] = 12
		}
		local afDt = {
			[1] = {["t"]="",["i"]=0},
			[2] = {["t"]="",["i"]=0},
			[3] = {["t"]="",["i"]=0},
			[4] = {["t"]="",["i"]=0}
		}
		if afx and (#afx >= 1) then
			for i=1,#afx do
				local name, description, icon = C_ChallengeMode.GetAffixInfo(afx[i].id)
				afDt[i]["t"] = '|cffffffff' .. name .. '|r |cff00bcff(+' .. lvl[i] .. ')|r\n\n' .. description
				afDt[i]["i"] = icon
			end
			ESCreateTooltip(afDt, true)
		else
			ESCreateTooltip(afDt, false)
		end
	end
	ESU_Frame:Show() -- Activate looptimer
end

function ES_Utilities:OnInitialize()
	ESUTIL_DB = ESUTIL_DB or {}
	if not ESUTIL_DB["toggles"] then
		ESUTIL_DB["toggles"] = {
			["vault"] = false,
			["rewards"] = false,
			["weekly"] = true,
			["currency"] = false,
			["autoloot"] = false
		}
	end	
	C_Timer.After(3, function()
		ES_Utilities_DelayedInit()
		ESU_Frame:Show() -- Activate looptimer
	end)
end

local function get_line_count(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then lines = lines + 1 end
    end

    return lines
end
local function ESUD_FrameShow(self)
	local txt = ES_Utilities_GetKeystoneData()
	local count = get_line_count(txt)
	txt1:SetText(txt)
	ESUD_Frame:SetHeight(31 + (14 * count))
	local widthBase = math.floor(txt1:GetWrappedWidth() + 12)
	local widthVar = math.floor(txt1:GetWrappedWidth() + 12)
	ESUD_Frame:SetWidth(((widthVar >= widthBase) and widthVar) or widthBase)
end


function ES_Utilities:CreateKeysFrames()
	ESUD_Frame_Init()
	ESUD_Frame:SetScript("OnShow", ESUD_FrameShow)
end
---------------
-- Loop Timers:
---------------
local function ESU_Frame_UpdateLoop_Function(self,elapsed)
    ESU_Timer = ESU_Timer + elapsed
	if ESUD_Frame and (ESU_TimerP >= 4) then -- 4 sec timer for pending MythicPlusProgression and weekly reset check
		ESU_TimerP = 0
		if ESUTIL_DB["chars"] and ESUTIL_DB["chars"][pName] and ESUTIL_DB["chars"][pName]["pending"] then
			ES_MplusProg()
			ES_Utilities_KeyUpdate()
		end
		ES_CheckWeeklyReset()
	end
	if ESU_TimerWA >= 2 then -- Throttled event (every 2 sec)
		ESU_TimerWA = 0
		WeakAuras.ScanEvents("ESUTILITIES_WA_EVENT2",true)
	end
    if ESU_Timer >= 0.2 then -- Throttled event for weakaura triggers. Dont have to use "every frame" check. 5 times per second.
        ESU_Timer = 0
		ESU_TimerP = ESU_TimerP + 0.2
		ESU_TimerWA = ESU_TimerWA + 0.2
		WeakAuras.ScanEvents("ESUTILITIES_WA_EVENT",true)
    end
end
ESU_Frame:SetScript("OnUpdate", ESU_Frame_UpdateLoop_Function)

--------------------
-- Public functions:
--------------------
function ES_Utilities_ShowHide(show)
	if show then
		ESUD_Frame:Show()
	else
		ESUD_Frame:Hide()
	end
end

------------------
-- Slash commands:
------------------
SLASH_ESUTILITIES1 = "/es_u";
SlashCmdList["ESUTILITIES"] = function(msg)
	if msg == "vault" then
		if ESUTIL_DB["toggles"]["vault"] then
			ESUTIL_DB["toggles"]["vault"] = false
			print('|cff00b4ffES_Utilities: |rDisabled GreatVaultbutton.')
		else
			ESUTIL_DB["toggles"]["vault"] = true
			print('|cff00b4ffES_Utilities: |rEnabled GreatVaultbutton.')
		end
		print('|cff00b4ffES_Utilities: |rChanges wont take effect until you reload your interface.')
	elseif msg == "rewards" then
		if ESUTIL_DB["toggles"]["rewards"] then
			ESUTIL_DB["toggles"]["rewards"] = false
			print('|cff00b4ffES_Utilities: |rDisabled reputation reward.')
		else
			ESUTIL_DB["toggles"]["rewards"] = true
			print('|cff00b4ffES_Utilities: |rEnabled reputation reward.')
		end
		print('|cff00b4ffES_Utilities: |rChanges wont take effect until you reload your interface.')
	elseif msg == "weekly" then
		if ESUTIL_DB["toggles"]["weekly"] then
			ESUTIL_DB["toggles"]["weekly"] = false
			print('|cff00b4ffES_Utilities: |rDisabled weekly reward tracking.')
		else
			ESUTIL_DB["toggles"]["weekly"] = true
			print('|cff00b4ffES_Utilities: |rEnabled weekly reward tracking.')
		end
		print('|cff00b4ffES_Utilities: |rChanges wont take effect until you reload your interface.')
	elseif msg == "currency" then
		if ESUTIL_DB["toggles"]["currency"] then
			ESUTIL_DB["toggles"]["currency"] = false
			print('|cff00b4ffES_Utilities: |rDisabled upgrade-currency.')
		else
			ESUTIL_DB["toggles"]["currency"] = true
			print('|cff00b4ffES_Utilities: |rEnabled upgrade-currency.')
		end
		print('|cff00b4ffES_Utilities: |rChanges wont take effect until you reload your interface.')
	elseif msg == "autoloot" then
		if ESUTIL_DB["toggles"]["autoloot"] then
			ESUTIL_DB["toggles"]["autoloot"] = false
			print('|cff00b4ffES_Utilities: |rDisabled fast autolooting.')
		else
			ESUTIL_DB["toggles"]["autoloot"] = true
			print('|cff00b4ffES_Utilities: |rEnabled fast autolooting.')
		end
		print('|cff00b4ffES_Utilities: |rChanges wont take effect until you reload your interface.')
	elseif msg == "reset" then
		table.wipe(ESUTIL_DB["chars"])
		ESU_CheckCharEntry()
		print('|cff00b4ffES_Utilities: |rCharacter list has been reset.')
	else
		print('|cff00b4ffES_Utilities: |rValid toggle-commands: \nNote: All options are disabled by default\n\n|cfffff400/es_u weekly |r(Weekly vault-reward tracking)\n|cfffff400/es_u reset |r(Reset character data)\n|cfffff400/es_u vault |r(Great vault button on ESC-menu)\n|cfffff400/es_u rewards |r(Renown and paragon reward notification on ESC-menu)\n|cfffff400/es_u currency |r(ItemUpgrade currency tracker on CharacterPanel)\n|cfffff400/es_u autoloot |r(Faster autoloot. Also tries to bypass Blizzards bug with autoloot!)')
	end
end
