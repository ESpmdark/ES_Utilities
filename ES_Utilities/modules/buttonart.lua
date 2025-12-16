local _, addon = ...
local ba_Initiated,ba_Enabled,loc_Initiated,loc_Enabled,hasAddon,border1,border2

local function toggleLOCart(enable)
    local alpha,xPos,yPos = 1,256,58
    if enable then
        alpha,xPos,yPos = 0,140,80
    end
    LossOfControlFrame.RedLineTop:SetAlpha(alpha)
	LossOfControlFrame.RedLineBottom:SetAlpha(alpha)
	LossOfControlFrame.blackBg:SetSize(xPos,yPos)
	LossOfControlFrame.TimeLeft:SetAlpha(alpha)
end

local function skinExtraQuestButton()
    hasAddon = true
	border2 = _G["ExtraQuestButton"]:CreateTexture(nil, "ARTWORK", nil, 7)
	border2:SetAllPoints()
	border2:SetTexture("Interface\\AddOns\\ES_Utilities\\img\\border_ExtraQuestButton.tga")
	border2:Show()
end

local function generateZoneAbilityBorder(frame)
	if not frame then return end
	if not ba_Enabled then
		if frame.Custom then
			frame.Custom = nil
		end
		return
	end
	if frame.Custom then return	end
	frame.Custom = frame:CreateTexture(nil, "ARTWORK", nil, 7)
	frame.Custom:SetAllPoints()
	frame.Custom:SetTexture("Interface\\AddOns\\ES_Utilities\\img\\border_ZoneAbility.tga")
	frame.Custom:Show()
end

local function checkZoneAbilities()
	local children = {ZoneAbilityFrame.SpellButtonContainer:GetChildren()}
	if not children then return end
	for _,child in ipairs(children) do
		generateZoneAbilityBorder(child)
	end
	if ba_Enabled then
		ZoneAbilityFrame:SetWidth(#children * 52)
	end
end

local function toggleBAart(enable)
    if enable then
        border1:SetAlpha(1)
	    ExtraActionButton1.style:SetAlpha(0)
	    ExtraActionButton1.style:Hide()
        ZoneAbilityFrame.Style:SetAlpha(0)
	    ZoneAbilityFrame.Style:Hide()
        if hasAddon then
            border2:SetAlpha(1)
        end
		ExtraAbilityContainer.spacing = 10
		ExtraAbilityContainer.minimumWidth = 52
		ExtraActionBarFrame:SetWidth(52)
		checkZoneAbilities()
    else
        border1:SetAlpha(0)
	    ExtraActionButton1.style:SetAlpha(1)
	    ExtraActionButton1.style:Show()
        ZoneAbilityFrame.Style:SetAlpha(1)
	    ZoneAbilityFrame.Style:Show()
        if hasAddon then
            border2:SetAlpha(0)
        end
		ExtraAbilityContainer.spacing = -30
		ExtraAbilityContainer.minimumWidth = 250
		ExtraActionBarFrame:SetWidth(256)
		ZoneAbilityFrame:SetWidth(256)
    end
	if ExtraAbilityContainer:IsVisible() then
		ExtraAbilityContainer:UpdateLayoutIndicies()
		ExtraAbilityContainer:UpdateShownState()
	end
end

local function buttonartInit()
	border1 = ExtraActionButton1:CreateTexture(nil, "ARTWORK", nil, 7)
	border1:SetAllPoints()
	border1:SetTexture("Interface\\AddOns\\ES_Utilities\\img\\border_ExtraActionButton.tga")
	border1:Show()

	checkZoneAbilities()
	hooksecurefunc(ZoneAbilityFrame.SpellButtonContainer, "SetContents" , function()
		checkZoneAbilities()
	end)

    if C_AddOns.IsAddOnLoaded("ExtraQuestButton") then
        skinExtraQuestButton()
	end

    ba_Initiated = true
end

local function lossofcontrolInit()
    hooksecurefunc(LossOfControlFrame, "SetUpDisplay", function(...)
        if not loc_Enabled then return end
		LossOfControlFrame.AbilityName:SetPoint("CENTER", 0, 36)
		LossOfControlFrame.Icon:SetPoint("CENTER", 0, 0)
	end)
    loc_Initiated = true
end

addon.toggleButtonArt = function(enable)
    if enable and not ba_Enabled then
		ba_Enabled = true
		if not ba_Initiated then
			buttonartInit()
		end
        toggleBAart(true)
	elseif ba_Enabled then
		ba_Enabled = false
        toggleBAart(false)
	end
end

addon.toggleLossOfControl = function(enable)
    if enable and not loc_Enabled then
		if not loc_Initiated then
			lossofcontrolInit()
		end
		loc_Enabled = true
        toggleLOCart(true)
	elseif loc_Enabled then
		loc_Enabled = false
        toggleLOCart(false)
	end
end