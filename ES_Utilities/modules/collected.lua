local _, addon = ...
local isInitiated = false
local isEnabled = false
local EL = CreateFrame("Frame")

-- Constants
local validsubclassID = {
	[2]= {[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true,[7]=true,[8]=true,[9]=true,[10]=true,[13]=true,[15]=true,[18]=true,[19]=true},
	[4] = {[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[6]=true}
}
local validOverrides = {["INVTYPE_BODY"]=true,["INVTYPE_HOLDABLE"]=true,["INVTYPE_TABARD"]=true}
--/

local ESCmixin = {}

local function createEJHooks()
	hooksecurefunc("EncounterJournal_LootUpdate", function()
		ESCmixin:UpdateEncounterJournal()
	end)
	local scroll = _G["EncounterJournalEncounterFrameInfo"].LootContainer.ScrollBar
	hooksecurefunc(scroll, "SetScrollPercentage", function()
		ESCmixin:UpdateEncounterJournal()
	end)
end

local function collectedInit()
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		ESCmixin:UpdateMerchant()
	end)

	if not C_AddOns.IsAddOnLoaded("Blizzard_EncounterJournal") then
		EL:RegisterEvent("ADDON_LOADED")
	else
		createEJHooks()
	end
end

function ESCmixin:UpdateEJButton(frame, itemID, link)
	local isCollected, limited, unknownSetVariant = self:IsItemCollected(itemID, link)
	if not frame.ES_CollectedTXT then
		self:CreateButton(frame)
	end	
	if isCollected then
		if isCollected == "hide" then
			frame.ES_CollectedTXT:SetText("")
		elseif unknownSetVariant then
			frame.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Pending", 20, 20)))
		elseif limited then
			frame.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("Soulbind-32x32", 20, 20)))
		else
			frame.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Ready", 20, 20)))
		end
	else
		frame.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Decline", 20, 20)))
	end
end

function ESCmixin:UpdateEncounterJournal(_, elapsed)
	local scrollBox = _G["EncounterJournalEncounterFrameInfo"].LootContainer.ScrollBox
	local lootItemFrames = scrollBox:GetFrames()
	for i = 1, #lootItemFrames do
		local frame = lootItemFrames[i]
		if isEnabled then
			local itemID = frame and frame.link and C_Item.GetItemIDForItemInfo(frame.link)
			if itemID then
				self:UpdateEJButton(frame, itemID, frame.link)
			end
		elseif frame.ES_CollectedTXT then
			frame.ES_CollectedTXT:SetText("")
		end
	end
end

function ESCmixin:CreateButton(parentFrame)
	parentFrame.ES_CollectedTXT = parentFrame:CreateFontString(nil, 'OVERLAY')
	parentFrame.ES_CollectedTXT:SetFont("Fonts\\ARIALN.TTF", 12)
	parentFrame.ES_CollectedTXT:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 0, 0)
end

function ESCmixin:UpdateMerchantBtn(i,padding)
    local itemButton = _G["MerchantItem" .. i .. "ItemButton"]
	if not itemButton then return end
	if not isEnabled then
		if itemButton.ES_CollectedTXT then
			itemButton.ES_CollectedTXT:SetText("")
		end
		return
	end
	local itemID = GetMerchantItemID(i+padding)
	local itemLink = GetMerchantItemLink(i+padding)
	local isCollected, limited, unknownSetVariant = self:IsItemCollected(itemID, itemLink)
	if not itemButton.ES_CollectedTXT then
		self:CreateButton(itemButton)
	end
	if isCollected then
		if isCollected == "hide" then
			itemButton.ES_CollectedTXT:SetText("")
		elseif unknownSetVariant then
			itemButton.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Pending", 20, 20)))
		elseif limited then
			itemButton.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("Soulbind-32x32", 20, 20)))
		else
			itemButton.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Ready", 20, 20)))
		end
	else
		itemButton.ES_CollectedTXT:SetText(tostring(CreateAtlasMarkup("UI-LFG-RoleIcon-Decline", 20, 20)))
	end
end

function ESCmixin:IsItemCollected(itemID, link)
    if not itemID then return false, false end
    local setID = C_Item.GetItemLearnTransmogSet(itemID)
    if setID then -- tmog set/ensemble/arsenal
        return self:GetSetCollection(setID)
    end
    if C_ToyBox.GetToyInfo(itemID) then -- toy
        return self:GetToyCollection(itemID)
    end
    local speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
    if speciesID then -- pet
        return self:GetPetCollection(speciesID)
    end
    local mountID = C_MountJournal.GetMountFromItem(itemID)
	if mountID then -- mount
		return self:GetMountCollection(mountID)
	end
	local equipLoc, _, classID, subclassID, _ = select(4, C_Item.GetItemInfoInstant(itemID))
	if validsubclassID[classID] and (validsubclassID[classID][subclassID] or (equipLoc and validOverrides[equipLoc])) then --single item
		if link then
			return self:GetAppearanceCollection(itemID,link)
		else
			return self:GetAppearanceCollection(itemID)
		end
	end
	if addon.illusions[itemID] then -- illusion
		return self:GetIllusionCollection(addon.illusions[itemID])
	end
	if addon.titles[itemID] then -- titles
	-- (if Blizzard continues to remove these items fron vendors if known, then we can perhaps skip title checks)
		return self:GetTitleCollection(addon.titles[itemID])
	end
	return "hide", false
end

function ESCmixin:UpdateMerchant()
	local count = GetMerchantNumItems()
	if count and (count >= 1) then
		local size = MERCHANT_ITEMS_PER_PAGE
		local padding = size * (MerchantFrame.page - 1)
		for i = 1, size do
			self:UpdateMerchantBtn(i,padding)
		end
	end
end

function ESCmixin:GetSetCollection(setID)
    local setInfo = C_TransmogSets.GetSetInfo(setID)
	local unknownSource = false
	local setItems = C_Transmog.GetAllSetAppearancesByID(setID) or {}
	for _, item in ipairs(setItems) do
		local info = C_TransmogCollection.GetSourceInfo(item.itemModifiedAppearanceID)
		if info and not info.isCollected then
			unknownSource = true
		end
	end
	local baseID = C_TransmogSets.GetBaseSetID(setID)
	local variantInfo = baseID and C_TransmogSets.GetVariantSets(baseID) or {}
	local baseSetInfo = baseID and C_TransmogSets.GetSetInfo(baseID) or {}
	local insertBaseSet = baseID and true or false
	for _, info in ipairs(variantInfo) do
        if info.setID == baseID then
            insertBaseSet = false;
            break
        end
    end
	if insertBaseSet then
		table.insert(variantInfo, baseSetInfo)
	end
	local unknownVariant = false
	local difficulties = {["Raid Finder"]=true,["Normal"]=true,["Heroic"]=true,["Mythic"]=true}
	for _, info in ipairs(variantInfo) do
		if difficulties[info.description] then
			local setAppearances = C_TransmogSets.GetSetPrimaryAppearances(info.setID)
			for _, v in ipairs(setAppearances) do
				if not v.collected then
					unknownVariant = true
					break
				end
			end
			if unknownVariant then break end
		end
	end
	return setInfo and setInfo.collected or (not unknownSource) or false, unknownSource, unknownVariant
end

function ESCmixin:GetAchievementStatus(achievementID)
	local completed, _ = select(4, GetAchievementInfo(achievementID))
	return completed
end

function ESCmixin:GetTitleCollection(titleID)
    return IsTitleKnown(titleID)
end

function ESCmixin:GetMountCollection(mountID)
	local mountInfo = { C_MountJournal.GetMountInfoByID(mountID) }
	if mountInfo then
		return mountInfo[11] and true or false
	end
    return false
end

function ESCmixin:GetPetCollection(speciesID)
    return C_PetJournal.GetNumCollectedInfo(speciesID) > 0
end

function ESCmixin:GetIllusionCollection(illusionID)
    local illusionInfo = C_TransmogCollection.GetIllusionInfo(illusionID)
    return illusionInfo and illusionInfo.isCollected and true or false
end

function ESCmixin:VerifyVariants(itemModifiedAppearanceID)
	local info = itemModifiedAppearanceID and C_TransmogCollection.GetAppearanceInfoBySource(itemModifiedAppearanceID)
	local ids = info and C_TransmogCollection.GetAllAppearanceSources(info.appearanceID) or {}
	for i = 1, #ids do
		if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(ids[i]) then
			return true
		end
	end
	return false
end

function ESCmixin:GetAppearanceCollection(itemID,link)
    local hasTransmog
	if link then
		local itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(link)
		if not itemModifiedAppearanceID then -- Catch for items that dont give valid info from link. Most likely those with shared appearance in all difficulties (EJ)
			itemAppearanceID, itemModifiedAppearanceID = C_TransmogCollection.GetItemInfo(itemID)
		end
		hasTransmog = itemModifiedAppearanceID and self:VerifyVariants(itemModifiedAppearanceID) or false
	elseif itemID then
		hasTransmog = C_TransmogCollection.PlayerHasTransmogByItemInfo(itemID)
	end
    return hasTransmog and true or false
end

function ESCmixin:GetToyCollection(itemID)
    local hasToy = PlayerHasToy(itemID)
    return hasToy and true or false
end

addon.toggleCollected = function(enable)
	if enable and not isInitiated then
		collectedInit()
	end
	isEnabled = enable
end

EL:SetScript("OnEvent", function(self, event, name, ...)
	if name == "Blizzard_EncounterJournal" then
		EL:UnregisterEvent("ADDON_LOADED")
		createEJHooks()
	end
end)