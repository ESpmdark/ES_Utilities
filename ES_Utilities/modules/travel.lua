local _, addon = ...
local EL = CreateFrame("Frame")
local isInitiated,isEnabled,listGeneratedPersonal,listGeneratedGlobal
local inBags = {}

_G["BINDING_CATEGORY_ES Utilities"] = "ES_Utilities"
_G["BINDING_NAME_ES_UTILITIES_TRAVEL_TOGGLE"] = "Toggle travel frame"
local mainframe = CreateFrame("Frame","ES_Utilities_TravelMain", UIParent, "TooltipBorderedFrameTemplate")
mainframe:SetPoint("CENTER",UIParent,"CENTER",0,0)
mainframe:SetFrameStrata("DIALOG")
mainframe:Hide()
mainframe.dng = CreateFrame("Button", nil, mainframe, "SquareIconButtonTemplate")
mainframe.dng:SetSize(42,42)
mainframe.dng:SetPoint("CENTER",mainframe,"TOPRIGHT",-8,-8)
mainframe.dng:SetNormalAtlas("TaxiNode_Continent_Neutral")
mainframe.dng:SetHighlightAtlas("TaxiNode_Continent_Alliance")
mainframe.dng:SetPushedAtlas("TaxiNode_Continent_Alliance")

local dungeonframe = CreateFrame("Frame","ES_Utilities_TravelDungeon", UIParent, "TooltipBorderedFrameTemplate")
dungeonframe:SetPoint("CENTER",UIParent,"CENTER",0,0)
dungeonframe:SetFrameStrata("DIALOG")
dungeonframe:Hide()
dungeonframe.ret = CreateFrame("Button", nil, dungeonframe, "SquareIconButtonTemplate")
dungeonframe.ret:SetSize(42,42)
dungeonframe.ret:SetPoint("CENTER",dungeonframe,"TOPRIGHT",-8,-8)
dungeonframe.ret:SetNormalAtlas("poi-traveldirections-arrow2")
dungeonframe.ret:SetHighlightAtlas("poi-traveldirections-arrow")
dungeonframe.ret:SetPushedAtlas("poi-traveldirections-arrow2")

local width,height = 80, 80
local padding = 16

local function createNewButton(txt,left,type,right,icon,xPos,yPos,dungeon)
	local path = "Interface\\EncounterJournal\\UI-EncounterJournalTextures"
	local btn
	if dungeon then
		btn = CreateFrame("Button", nil, dungeonframe, "SecureActionButtonTemplate")
		btn:SetPoint("TOP", dungeonframe, "TOP", xPos, yPos)
	else
		btn = CreateFrame("Button", nil, mainframe, "SecureActionButtonTemplate")
		btn:SetPoint("TOP", mainframe, "TOP", xPos, yPos)
	end
    btn:SetSize(width, height)
	btn:RegisterForClicks("AnyUp", "AnyDown")
	btn.cd = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
	btn.cd:SetDrawEdge(false)
	btn.cd:SetDrawBling(false)
	btn.cd:SetAllPoints()
	local bg = btn:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
	bg:SetTexture(icon)
	local tf = CreateFrame("Frame", nil, btn)
	tf:SetAllPoints()
	tf:SetFrameStrata("TOOLTIP")
	local t = tf:CreateFontString(nil, "OVERLAY")
	t:SetPoint("TOP",0,0)
	t:SetFont("Fonts\\ARIALN.TTF", 18, "OUTLINE")
	t:SetText(txt)
    btn:SetNormalTexture(path)
    btn:GetNormalTexture():SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
    btn:SetHighlightTexture(path)
    btn:GetHighlightTexture():SetTexCoord(0.34570313, 0.68554688, 0.33300781, 0.42675781)
	if not right then
		btn:SetAttribute("type", type)
		btn:SetAttribute(type, left)
	else
		btn:SetAttribute("type1", type)
		btn:SetAttribute(type.."1", left)
		btn:SetAttribute("type2", type)
		btn:SetAttribute(type.."2", right)
	end
	btn:SetScript("PostClick", function()
       	mainframe:Hide()
       	dungeonframe:Hide()
	end)
	return btn
end

local function generateButtons(tbl)
	local titleSize = 26
	local xPos = 0
	local yPos = (-1 * padding) - titleSize
	local mfMax = 0
	for i=1,3 do
		if #tbl[i] > 0 then
			if yPos ~= (-1 * padding) - titleSize then
				yPos = yPos - (padding*3)
			end
			local t = mainframe:CreateFontString(nil, "OVERLAY")
			t:SetPoint("BOTTOM", mainframe, "TOP", 0, yPos + 2)
			t:SetFont("Fonts\\MORPHEUS.TTF", titleSize, "")
			t:SetTextColor(1, 0.8, 0)
			t:SetText(addon.mainTitle[i])
			local mRw = math.ceil(#tbl[i]/6)
			local bTBL = {}
			local max = math.ceil(#tbl[i]/mRw)
			if max > mfMax then mfMax = max end
			local rCtn = 1
			local cCtn = 1
			for j=1,#tbl[i] do
				if cCtn > max then
					rCtn = rCtn + 1
					cCtn = 1
				end
				if not bTBL[rCtn] then bTBL[rCtn] = {} end
				bTBL[rCtn][cCtn] = tbl[i][j]
				cCtn = cCtn + 1
			end
			for y=1,#bTBL do
				xPos = ((padding + width) / 2) - ((#bTBL[y]/2) * (width + padding))
				for l=1,#bTBL[y] do
					local b = bTBL[y][l]
					if b then
						if b.id == 126892 then -- Zen Pilgrimage has a knownspell bug when using spellname. Need to use spellID to bypass this.
							b.left = b.id
						end
						local btn = createNewButton(b.name,b.left,b.type,b.right,b.icon,xPos,yPos)
						btn.type = b.type
						btn.id = b.id
						xPos = xPos + width + padding
					end
				end
				yPos = yPos - height - padding
			end
		end
	end
	mfMax = (mfMax == 0) and 0 or (mfMax >= 2) and mfMax or 2 -- Ensure the frame is wide enough to fit text if less than 2 wide
	mainframe:SetSize(((width+padding)*mfMax)+padding,yPos*-1)
	xPos = 0
	yPos = (-1 * padding) - titleSize
	mfMax = 0
	tbl = tbl[4]
	for i=#addon.dungeon,1,-1 do
		if #tbl[i] > 0 then
			if yPos ~= (-1 * padding) - titleSize then
				yPos = yPos - (padding*3)
			end
			local t = dungeonframe:CreateFontString(nil, "OVERLAY")
			t:SetPoint("BOTTOM", dungeonframe, "TOP", 0, yPos + 2)
			t:SetFont("Fonts\\MORPHEUS.TTF", titleSize, "")
			t:SetTextColor(1, 0.8, 0)
			t:SetText(addon.dungeonTitle[i])
			local bTBL = {}
			if #tbl[i] > mfMax then mfMax = #tbl[i] end
			local cCtn = 1
			for j=1,#tbl[i] do
				if not bTBL[1] then bTBL[1] = {} end
				bTBL[1][cCtn] = tbl[i][j]
				cCtn = cCtn + 1
			end
			for y=1,#bTBL do
				xPos = ((padding + width) / 2) - ((#bTBL[y]/2) * (width + padding))
				for l=1,#bTBL[y] do
					local b = bTBL[y][l]
					if b then
						local btn = createNewButton(b.name,b.left,b.type,b.right,b.icon,xPos,yPos,true)
						btn.type = b.type
						btn.id = b.id
						xPos = xPos + width + padding
					end
				end
				yPos = yPos - height - padding
			end
		end
	end
	mfMax = (mfMax == 0) and 0 or (mfMax >= 3) and mfMax or 3 -- Ensure the frame is wide enough to fit text if less than 3 wide
	if mfMax == 0 then -- If no dungeon ports are unlocked, give it a size of 1 button and create infotext
		mfMax = 1
		yPos = yPos - height - padding
		local tf = CreateFrame("Frame", nil, dungeonframe)
		tf:SetAllPoints()
		local t = tf:CreateFontString(nil, "OVERLAY")
		t:SetPoint("CENTER",0,0)
		t:SetFont("Fonts\\ARIALN.TTF", 18, "OUTLINE")
		t:SetText('No\ndungeon\nteleports\nunlocked')
	end
	dungeonframe:SetSize(((width+padding)*mfMax)+padding,yPos*-1)
end

local function toggleShow(arg,dungeon)
	if arg == "show" then
		if not (UnitAffectingCombat("player") or InCombatLockdown()) then
			if dungeon then
				mainframe:Hide()
				dungeonframe:Show()
			else
				dungeonframe:Hide()
				mainframe:Show()
			end
		end
	else
		dungeonframe:Hide()
		mainframe:Hide()
	end
end

mainframe.dng:SetScript("OnClick", function()
	toggleShow("show",true)
end)

dungeonframe.ret:SetScript("OnClick", function()
	toggleShow("show")
end)

local function updateCooldowns(frame)
	for _,f in ipairs({ frame:GetChildren() }) do
		if f.cd then
			f.cd:Clear()
			if f.type == "spell" and f.id then
				local cdLP = C_Spell.GetSpellCooldown(f.id)
				local start, dur = cdLP.startTime, cdLP.duration
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			elseif f.type == "item" then
				local start, dur, _ = C_Container.GetItemCooldown(f.id)
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			elseif f.type == "toy" then
				local start, dur, _ = C_Container.GetItemCooldown(f.id)
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			end
		end
	end
end

mainframe:SetScript("OnShow", function(self)
	updateCooldowns(self)
end)

dungeonframe:SetScript("OnShow", function(self)
	updateCooldowns(self)
end)

local GetItemInfoInstant = C_Item.GetItemInfoInstant

local function customOverride()
	if ESUTIL_DB.travel[addon.charName] then
		return ESUTIL_DB.travel[addon.charName]
	else
		return ESUTIL_DB.travel.global and ESUTIL_DB.travel.global or false
	end
end

local tblInit = {[1]={},[2]={},[3]={},[4]={}}

local function checkEntryGeneral()
    local custID = customOverride()
    local h = addon.general
    local count = 1
    if custID and PlayerHasToy(custID) then
        local icon, _ = select(5,GetItemInfoInstant(custID))
        tblInit[1][count] = {
			name = "Hearthstone",
			left = custID,
			right = false,
			type = "toy",
			id = custID,
			icon = icon
		}
        count = 2
    else
        custID = false
    end
	for i=#h,1,-1 do
		if h[i].type == "spell" and C_SpellBook.IsSpellKnown(h[i].id) then
			local spInfo = C_Spell.GetSpellInfo(h[i].id)
			local spNm, icon = spInfo.name, spInfo.iconID
			tblInit[1][count] = {
				name = h[i].name,
				left = spNm,
				right = false,
				type = "spell",
				id = h[i].id,
				icon = icon
			}
            count = count + 1
		elseif h[i].type == "toy" and PlayerHasToy(h[i].id) then
			local valid = true
			if h[i].quest then
				if not addon.checkQuest(h[i].id) then
					valid = false
				end
			end
			if valid then
                local icon, _ = select(5,GetItemInfoInstant(h[i].id))
				tblInit[1][count] = {
					name = h[i].name,
					left = h[i].id,
					right = false,
					type = "toy",
					id = h[i].id,
					icon = icon
				}
                count = count + 1
			end
		elseif not custID and h[i].id == 6948 and inBags[6948] then
			local icon, _ = select(5,GetItemInfoInstant(h[i].id))
			tblInit[1][count] = {
				name = h[i].short or h[i].name,
				left = h[i].name,
				right = false,
				type = "item",
				id = h[i].id,
				icon = icon
			}
            count = count + 1
		end
	end
end

local function loadEntries()
    checkEntryGeneral()
    if (select(3,UnitClass("player")) == 8) then
		local p = addon.ports
        local count = 1
		for i=#p,1,-1 do
			if p[i].tele and C_SpellBook.IsSpellKnown(p[i].tele) then
				local right
				if p[i].port and C_SpellBook.IsSpellKnown(p[i].port) then
					local spNm2 = C_Spell.GetSpellInfo(p[i].port).name
					right = spNm2
				end
				local spInfo = C_Spell.GetSpellInfo(p[i].tele)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit[3][count] = {
					name = p[i].name,
					left = spNm,
					right = right or false,
					type = "spell",
					id = p[i].id,
					icon = icon
				}
                count = count + 1
			end
		end
	end
	local d = addon.dungeon
	for i=#d,1,-1 do
		tblInit[4][i] = {}
        local count = 1
		for k,v in pairs(d[i]) do
			if C_SpellBook.IsSpellKnown(k) then
				local spInfo = C_Spell.GetSpellInfo(k)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit[4][i][count] = {
					name = v,
					left = spNm,
					right = false,
					type = "spell",
					id = k,
					icon = icon
				}
                count = count + 1
			end
		end
	end
    generateButtons(tblInit)
	wipe(tblInit)
    print('|cff00b4ffES_Utilities: |r|cff00ff00Travel data loaded|r')
end

local canUseToy = {}
local function loadEngineering()
	local w = addon.wormholes
	local count = 1
    for i=#w,1,-1 do
	    if w[i].item and canUseToy[w[i].id] then
			local icon, _ = select(5,GetItemInfoInstant(w[i].id))
			tblInit[2][count] = {
				name = w[i].name,
				left = w[i].item,
				right = false,
				type = "item",
				id = w[i].id,
				icon = icon
			}
			count = count + 1
   		elseif canUseToy[w[i].id] then
			local icon, _ = select(5,GetItemInfoInstant(w[i].id))
			tblInit[2][count] = {
				name = w[i].name,
				left = w[i].id,
				right = false,
				type = "toy",
				id = w[i].id,
				icon = icon
			}
			count = count + 1
   		end
    end
	loadEntries()
end

local loadedToys = 0
local pendingToys = {}
local function checkEngiToy(itemID)
	if pendingToys[itemID].item then
		canUseToy[itemID] = inBags[itemID] and true or false
	elseif PlayerHasToy(itemID) then
		canUseToy[itemID] = C_ToyBox.IsToyUsable(itemID)
	end
end

local function setframeScale(scale)
	local s = scale or ESUTIL_DB.travel.scale or 1
	mainframe:SetScale(s)
	dungeonframe:SetScale(s)
end

function ES_Utilities_Travel_Toggle()
	if not isInitiated then
		print('|cff00b4ffES_Utilities: |r|cffff0000Issue fetching data from API. Load pending!')
		return
	end
	if not isEnabled then
		print('|cff00b4ffES_Utilities: |rTravel module is not enabled.')
		return
	end
	if mainframe:IsVisible() then
		toggleShow("hide")
	elseif isEnabled then
		toggleShow("show")
	end
end

EL:SetScript("OnEvent", function(self, event, ...)
	if mainframe:IsVisible() or dungeonframe:IsVisible() then
		toggleShow("hide")
	end
end)

ESUtilitiesTravelEditmixin = {}

function ESUtilitiesTravelEditmixin:OnLoad()
    self.Header.Text:SetText("Travel Frame")
end

function ESUtilitiesTravelEditmixin:OnShow(frame,arg)
	if arg == "personal" then
		local val = ESUTIL_DB.travel[addon.charName] and addon.getToyName(ESUTIL_DB.travel[addon.charName]) or "Disabled"
		frame:SetDefaultText(val)
	elseif arg == "global" then
		local val = ESUTIL_DB.travel.global and addon.getToyName(ESUTIL_DB.travel.global) or "Disabled"
		frame:SetDefaultText(val)
	elseif arg == "scale" then
		frame:SetText(ESUTIL_DB.travel.scale)
	end
end

function ESUtilitiesTravelEditmixin:OnEnterPressed()
	self:ClearFocus()
	if tonumber(self:GetText()) then
		if tonumber(self:GetText()) >= 0 then
			return
		end
	end
	self:SetText(ESUTIL_DB.travel.scale or 1)
end

function ESUtilitiesTravelEditmixin:OnAccept()
	local scale = tonumber(self.Scale.EditBox:GetText()) or ESUTIL_DB.travel.scale or 1
	local personal = self.PersonalDropdown.Text:GetText()
	local global = self.GlobalDropdown.Text:GetText()

	if personal and personal ~= "Disabled" then
		ESUTIL_DB.travel[addon.charName] = addon.knownReversed[personal]
	else
		ESUTIL_DB.travel[addon.charName] = nil
	end
	if global and global ~= "Disabled" then
		ESUTIL_DB.travel.global = addon.knownReversed[global]
	else
		ESUTIL_DB.travel.global = nil
	end
	ESUTIL_DB.travel.scale = scale
	setframeScale(scale)
	print('|cff00b4ffES_Utilities: |rChanges to hearthstone selection will not be seen until you reload interface.')
	self:Hide()
end

function ES_Utilities_PersonalTravelDropdown_Load(self)
	if not isInitiated then return end
	if not listGeneratedPersonal then
		self:SetupMenu(function(dropdown, rootDescription)
			rootDescription:CreateButton("Disabled", function()
				CloseDropDownMenus();
				self:SetDefaultText("Disabled")
			end)
			for _,name in pairs(addon.knownToys) do
				rootDescription:CreateButton(name, function()
					CloseDropDownMenus();
					self:SetDefaultText(name)
				end)
			end
		end)
		listGeneratedPersonal = true
	end
end

function ES_Utilities_GlobalTravelDropdown_Load(self)
	if not isInitiated then return end
	if not listGeneratedGlobal then
		self:SetupMenu(function(dropdown, rootDescription)
			rootDescription:CreateButton("Disabled", function()
				CloseDropDownMenus();
				self:SetDefaultText("Disabled")
			end)
			for _,name in pairs(addon.knownToys) do
				rootDescription:CreateButton(name, function()
					CloseDropDownMenus();
					self:SetDefaultText(name)
				end)
			end
		end)
		listGeneratedGlobal = true
	end
end

local function initTravel()
	for bag = 0, NUM_BAG_SLOTS do
		local bSlots = C_Container.GetContainerNumSlots(bag)
		if not bSlots then break end
		for slot = 1, bSlots do
			local item =  C_Container.GetContainerItemInfo(bag, slot)
			if item and item.itemID then
				inBags[item.itemID] = true
			end
		end
	end
	local prof1, prof2, _ = GetProfessions()
	local isEngineer = (prof1 and select(7,GetProfessionInfo(prof1)) == 202) or (prof2 and select(7,GetProfessionInfo(prof2)) == 202) or false
	if isEngineer then
		local w = addon.wormholes
		for i=1,#w do
			pendingToys[w[i].id] = { item = w[i].item and true or false}
			local item = Item:CreateFromItemID(w[i].id)
			item:ContinueOnItemLoad(function()
				checkEngiToy(item:GetItemID())
				loadedToys = loadedToys + 1
				if loadedToys == #w then
					loadEngineering()
				end
			end)
		end
	else
		loadEntries()
	end
	setframeScale()
	addon.initToys() -- Generate the list of available toys for settings dropdown
	isInitiated = true
end

addon.toggleTravel = function(enable)
    if enable and not isEnabled then
		if not isInitiated then
			initTravel()
		end
		EL:RegisterEvent("PLAYER_REGEN_DISABLED")
		isEnabled = true
	elseif not enable and isEnabled then
		EL:UnregisterEvent("PLAYER_REGEN_DISABLED")
		isEnabled = false
	end
end