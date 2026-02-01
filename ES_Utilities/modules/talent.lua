local _, addon = ...
local isInitiated,isEnabled
local EL = CreateFrame("Frame")

local pendingOnUpdate = CreateFrame("Frame", nil, UIParent)
pendingOnUpdate:Hide()

-- Localize functions
local SetSelection = C_Traits.SetSelection
local GetConfigInfo = C_Traits.GetConfigInfo
local GetTreeNodes = C_Traits.GetTreeNodes
local GetNodeInfo = C_Traits.GetNodeInfo
local GetConfigID = C_ClassTalents.GetActiveConfigID
local Purchase = C_Traits.PurchaseRank
local CanChangeTalents = C_ClassTalents.CanChangeTalents
local currSpec = C_SpecializationInfo.GetSpecialization
local setSpec = C_SpecializationInfo.SetSpecialization
-- Constants
local classFilename, classId = UnitClassBase("player")
local specCount = C_SpecializationInfo.GetNumSpecializationsForClassID(classId)
--

local function tblSortTal(a, b)
    if ( a.posY == b.posY ) then
		return a.posX < b.posX;
	else
		return a.posY < b.posY;
	end
end

local function updateSpecBorder()
	for i=1,4 do
		ES_Utilities_TalentMain["Spec" .. i].Ring:SetAtlas("talents-node-circle-gray")
	end
	ES_Utilities_TalentMain["Spec" .. currSpec()].Ring:SetAtlas("talents-node-circle-yellow")
end

function ES_Utilities_TalentActivateSpec(index)
	if currSpec() == index then
		PlaySound(110982, "Master", true)
		print('|cff00b4ffES_Utilities: |rSpecialization already active!')
	else
		local success = setSpec(index)
		if not success then
			print('|cff00b4ffES_Utilities: |r|cffff4141Could not activate specialization!')
		end
	end
end

local function ES_Utilities_TalentReadImport(importStream, treeID)
	local results = {};
	local treeNodes = GetTreeNodes(treeID);
	local success = true
	local msg1 = '|cff00b4ffES_Utilities: |r|cffff4141Import string is corrupt, node type mismatch at nodeID: |r\n'
	local text = ""
	local msg2 = '\n|cffff4141String possibly out of date.|r'
	for _, treeNodeID in ipairs(treeNodes) do
		local nodeSelectedValue = importStream:ExtractValue(1)
		local isNodeSelected =  nodeSelectedValue == 1;
		local isNodePurchased = false;
		local isPartiallyRanked = false;
		local partialRanksPurchased = false;
		local isChoiceNode = false;
		local choiceNodeSelection = 0;
		local result = {}
		if (isNodeSelected) then
			local nodePurchasedValue = importStream:ExtractValue(1);
			isNodePurchased = nodePurchasedValue == 1;
			if(isNodePurchased) then
				local isPartiallyRankedValue = importStream:ExtractValue(1);
				isPartiallyRanked = isPartiallyRankedValue == 1;
				if(isPartiallyRanked) then
					partialRanksPurchased = importStream:ExtractValue(ClassTalentImportExportMixin.bitWidthRanksPurchased);
				end
				local isChoiceNodeValue = importStream:ExtractValue(1);
				isChoiceNode = isChoiceNodeValue == 1;
				if(isChoiceNode) then
					choiceNodeSelection = importStream:ExtractValue(2);
				end
				choiceNodeSelection = choiceNodeSelection + 1
				local entryID
				local treeNode = GetNodeInfo(GetConfigID(), treeNodeID)
				local isChoice = (treeNode.type == Enum.TraitNodeType.Selection) or (treeNode.type == Enum.TraitNodeType.SubTreeSelection);
				if isChoice then
					if (isChoice ~= isChoiceNode) then
						success = false
						text = text .. treeNodeID .. " "
					elseif (isChoiceNode and choiceNodeSelection) then
						entryID = treeNode.entryIDs[choiceNodeSelection];
					end
				elseif treeNode.activeEntry then
					entryID = treeNode.activeEntry.entryID;
				end
				if not entryID then
					entryID = treeNode.entryIDs[1];
				end
				result = {
					e = entryID,
					r = isPartiallyRanked and partialRanksPurchased or treeNode.maxRanks,
					c = (isChoiceNode and 1) or false,
					n = treeNode.ID,
					posX = ((treeNode.type == Enum.TraitNodeType.SubTreeSelection) and 1) or treeNode.posX,
					posY = ((treeNode.type == Enum.TraitNodeType.SubTreeSelection) and 1) or treeNode.posY
				}
				tinsert(results, result)
			end
		end
	end
	if success then table.sort(results, tblSortTal) end
	return results, success, msg1 .. text .. msg2
end

local function ES_ToggleAnimation(arg)
	local f = _G["ES_Utilities_TalentLoadingFrame"]
	local an = _G["ES_Utilities_TalentLoadingAnim"]
	if arg == "show" then
		if not f:IsVisible() then
			f:Show()
			an.ag:Play()
		end
	elseif f:IsVisible() then
		an.ag:Stop()
		f:Hide()
	end
end

local pendingTalents = {}
local pendingIdx
local pendingCount = 1
local function preparePending(t, count, curr)
	pendingTalents[curr] = t
	if count == curr then
		ES_ToggleAnimation("show")
		pendingCount = 1
		pendingIdx = 1
		pendingOnUpdate:Show()
	end
end

local function verifyImportStream(importStream,direct)
	local headerValid, serializationVersion, specID, _ = ClassTalentImportExportMixin:ReadLoadoutHeader(importStream);
	local currentSerializationVersion = C_Traits.GetLoadoutSerializationVersion();

	if(not headerValid) then
		print('|cff00b4ffES_Utilities: |r|cffff4141Import failed!')
		print(LOADOUT_ERROR_BAD_STRING)
		PlaySound(29114, "Master", true)
		return false;
	end
	if(serializationVersion ~= currentSerializationVersion) then
		print('|cff00b4ffES_Utilities: |r|cffff4141Import failed!')
		print(LOADOUT_ERROR_SERIALIZATION_VERSION_MISMATCH)
		print("Import-version: " .. serializationVersion)
		print("Current version: " .. currentSerializationVersion)
		PlaySound(29114, "Master", true)
		return false;
	end
	if direct and specID then
		return specID
	else
		if(specID ~= PlayerUtil.GetCurrentSpecID()) then
			print('|cff00b4ffES_Utilities: |r|cffff4141Import failed!')
			print(LOADOUT_ERROR_WRONG_SPEC);
			PlaySound(29114, "Master", true)
			return false;
		end
	end
	return true
end

function ES_Utilities_TalentSaveDialog(name,import)
	local otherSpec = false
	local spec = PlayerUtil.GetCurrentSpecID()
	if import then
		local importStream = ExportUtil.MakeImportDataStream(import);
		local specID = verifyImportStream(importStream, true)
		if not specID then return false end
		if tonumber(specID) and not (specID == spec) then
			local _, specName, _, _, _, _, className = GetSpecializationInfoByID(specID)
			otherSpec = '|cff00b4ffES_Utilities: |rSaved "' .. name .. '" for a different specialization (' .. specName .. '-' .. className .. ').'
			spec = specID
		end
	end
	local success = false
	if ESUTIL_DB.talentbuilds[spec][name] then
		print('|cff00b4ffES_Utilities: |r|cffff4141Save failed. This spec already has a build with that name!')
		PlaySound(29114, "Master", true)
	else
		ESUTIL_DB.talentbuilds[spec][name] = import or C_Traits.GenerateImportString(GetConfigID())
		success = true
		if otherSpec then print(otherSpec) end
	end
	return success
end

function ES_Utilities_TalentImportBuild(importText)
	local importStream = ExportUtil.MakeImportDataStream(importText);
	if not verifyImportStream(importStream) then return false end
	local info = GetConfigInfo(GetConfigID())
	local loadoutContent, success, errorMsg = ES_Utilities_TalentReadImport(importStream, info.treeIDs[1]);
	if success then
		C_Traits.ResetTree(GetConfigID(), info.treeIDs[1])
		table.wipe(pendingTalents)
		preparePending(loadoutContent, 1, 1)
	else
		print(errorMsg)
		PlaySound(29114, "Master", true)
	end
	return success
end

local function ES_Utilities_TalentBuilds_Delete(self)
	local spec = PlayerUtil.GetCurrentSpecID()
	local db = ESUTIL_DB.talentbuilds[spec]
	MenuUtil.CreateContextMenu(UIParent, function(self, rootDescription)
		rootDescription:CreateTitle('|cffFF2F31Click to delete:|r')
		for k,v in pairs(db) do
			rootDescription:CreateButton(k, function() ESUTIL_DB.talentbuilds[spec][k] = nil; end)
		end
	end)
end

function ES_Utilities_TalentBuilds_Load(self)
	self:SetupMenu(function(dropdown, rootDescription)
		local spec = PlayerUtil.GetCurrentSpecID()
		local db = ESUTIL_DB and ESUTIL_DB.talentbuilds[spec] or {}
		local title = true
		for k,v in pairs(db) do
			if title then
				rootDescription:CreateButton('|cffFF2F31Delete a build|r', function() CloseDropDownMenus(); ES_Utilities_TalentBuilds_Delete(); end)
				rootDescription:CreateTitle('|cff919191Click to apply:|r')
				title = false
			end
			rootDescription:CreateButton(k, function() CloseDropDownMenus(); ES_Utilities_TalentImportBuild(v); end)
		end
		if title then
			rootDescription:CreateTitle('|cff919191empty|r')
		end
	end)
end

local function ES_Utilities_TalentAvailablePoint()
	local str = ERR_TALENT_FAILED_UNSPENT_TALENT_POINTS
	local _, _, changeError = CanChangeTalents()
	return changeError and (changeError == str)
end

function ES_Utilities_TalentMain_OnShow(self)
	updateSpecBorder()
end

local function ES_Utilities_TalentPending(self,elapsed)
	if pendingIdx then
		local cID = GetConfigID()
		local v = pendingTalents[pendingIdx][pendingCount]
		if v and ES_Utilities_TalentAvailablePoint() then
			if v.c then
				SetSelection(cID, v.n, v.e)
			elseif v.r then
				for i=1,v.r do
					Purchase(cID, v.n)
				end
			end
			pendingCount = pendingCount + 1
		elseif pendingTalents[pendingIdx + 1] then
			pendingIdx = pendingIdx + 1
			pendingCount = 1
		else
			ES_ToggleAnimation("hide")
			pendingIdx = nil
			pendingOnUpdate:Hide()
		end
	end
end
pendingOnUpdate:SetScript("OnUpdate", ES_Utilities_TalentPending) -- Frame is hidden while not needed. Disabling the OnUpdate script

local function ES_Utilities_Talent_TerminateProcess()
	if pendingIdx then
		pendingOnUpdate:Hide()
		pendingIdx = nil
		table.wipe(pendingTalents)
		ES_ToggleAnimation("hide")
	end
end

local function ES_Utilities_TalentInitFunc()
	local spcID = PlayerUtil.GetCurrentSpecID()
	if not ESUTIL_DB.talentbuilds[spcID] then ESUTIL_DB.talentbuilds[spcID] = {} end

	-- Create Animation Object
	local f = CreateFrame("Frame", "ES_Utilities_TalentLoadingFrame", ES_Utilities_TalentMain)
	f:SetSize(100,100)
	f:SetPoint("BOTTOM", ES_Utilities_TalentMain, "TOP", 0, 50)
	f.f = f:CreateFontString(nil, "OVERLAY")
	f.f:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
	f.f:SetPoint("CENTER")
	f.f:SetText("Applying talents")
	local af = CreateFrame("Frame", "ES_Utilities_TalentLoadingAnim", f)
	af:SetAllPoints()
	af.t = af:CreateTexture()
	af.t:SetAllPoints()
	af.t:SetAtlas("UF-Essence-SpinnerOut", true)
	af.ag = af:CreateAnimationGroup()
	af.ag:SetLooping("REPEAT")
	af.ag.spin = af.ag:CreateAnimation("Rotation")
	af.ag.spin:SetDegrees(-360)
	af.ag.spin:SetDuration(0.75)
	f:Hide()
	--//

	-- Populate specbutton data
	local rPerc, gPerc, bPerc, _ = GetClassColor(classFilename)	
	for i=1,4 do
		local button = "Spec" .. i
		if i <= specCount then
			local _, name, _, icon, _ = C_SpecializationInfo.GetSpecializationInfo(i, false)
			local roletexture = TextureUtil.GetSmallIconForRoleEnum(GetSpecializationRoleEnum(i, false, false))
			ES_Utilities_TalentMain[button].Icon:SetTexture(icon)
			ES_Utilities_TalentMain[button].Mask = ES_Utilities_TalentMain[button]:CreateMaskTexture()
			ES_Utilities_TalentMain[button].Mask:SetAllPoints(ES_Utilities_TalentMain[button].Icon)
			ES_Utilities_TalentMain[button].Mask:SetTexture("Interface/CHARACTERFRAME/TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			ES_Utilities_TalentMain[button].Icon:AddMaskTexture(ES_Utilities_TalentMain[button].Mask)
			ES_Utilities_TalentMain[button]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 0)
				GameTooltip:SetText(CreateAtlasMarkup(roletexture, 16, 16) .. name, rPerc, gPerc, bPerc)
				GameTooltip:Show()
			end)
			ES_Utilities_TalentMain[button]:SetScript("OnLeave", function(self)
				GameTooltip_Hide();
			end)
		else
			ES_Utilities_TalentMain[button]:Hide()
		end
	end
	updateSpecBorder()
	ES_Utilities_TalentMain.Spec1:SetPoint("RIGHT", ES_Utilities_TalentMain, "LEFT", -(specCount * 40) + 10,0)
	--//
	ES_Utilities_TalentMain:SetParent(PlayerSpellsFrame.TalentsFrame)
	ES_Utilities_TalentMain:SetPoint("BOTTOM", PlayerSpellsFrame.TalentsFrame, "BOTTOM", 0, 5)
	ES_Utilities_TalentMain:Show()

	-- Need to catch situation where user closes frame before the build is finished loading
	hooksecurefunc(_G["PlayerSpellsFrame"], "Hide", function()
		if isEnabled then
			ES_Utilities_Talent_TerminateProcess()
		end
	end)

	isInitiated = true
end

EL:SetScript("OnEvent", function(self, event, name, ...)
	if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" then
		if not isInitiated then return end
		local spcID = PlayerUtil.GetCurrentSpecID()
		if not ESUTIL_DB.talentbuilds[spcID] then ESUTIL_DB.talentbuilds[spcID] = {} end
		updateSpecBorder()
	elseif name and name == "Blizzard_PlayerSpells" then
		EL:UnregisterEvent("ADDON_LOADED")
		ES_Utilities_TalentInitFunc()
	end
end)

addon.toggleTalent = function(enable)
    if enable and not isEnabled then
		isEnabled = true
		EL:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
		if not isInitiated then
			if not C_AddOns.IsAddOnLoaded("Blizzard_PlayerSpells") then
				EL:RegisterEvent("ADDON_LOADED")
			else
				ES_Utilities_TalentInitFunc()
			end
		else
			ES_Utilities_TalentMain:Show()
		end
	elseif not enable and isEnabled then
		ES_Utilities_TalentMain:Hide()
		isEnabled = false
		EL:UnregisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
	end
end