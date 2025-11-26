local _, addon = ...
local ba_Initiated = false
local ba_Enabled = false
local loc_Initiated = false
local loc_Enabled = false
local hasAddon = false
local border1,border2

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
    else
        border1:SetAlpha(0)
	    ExtraActionButton1.style:SetAlpha(1)
	    ExtraActionButton1.style:Show()
        ZoneAbilityFrame.Style:SetAlpha(1)
	    ZoneAbilityFrame.Style:Show()
        if hasAddon then
            border2:SetAlpha(0)
        end
    end
end

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
	border2 = CreateFrame("Frame", nil, _G["ExtraQuestButton"])
	border2:SetFrameLevel(100)
	border2:SetPoint("CENTER",0,0)
	border2:SetSize(56,56)
	border2.t = border2:CreateTexture(nil, "ARTWORK")
	border2.t:SetAllPoints()
	border2.t:SetAtlas("loottoast-itemborder-artifact")
	border2.t:Show()
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
	frame.Custom:SetPoint("CENTER",0,0)
	frame.Custom:SetSize(56,56)
	frame.Custom:SetAtlas("loottoast-itemborder-orange")
	frame.Custom:Show()
end

local function checkZoneAbilities()
	local children = {ZoneAbilityFrame.SpellButtonContainer:GetChildren()}
	if not children then return end
	for _,child in ipairs(children) do
		generateZoneAbilityBorder(child)
	end
end

local function buttonartInit()
	border1 = CreateFrame("Frame", nil, ExtraActionButton1)
	border1:SetFrameLevel(100)
	border1:SetPoint("CENTER",0,0)
	border1:SetSize(56,56)
	border1.t = border1:CreateTexture(nil, "ARTWORK")
	border1.t:SetAllPoints()
	border1.t:SetAtlas("loottoast-itemborder-blue")
	border1.t:Show()

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
        toggleBAart(false)
		ba_Enabled = false
	end
end

addon.toggleLossOfControl = function(enable)
    if enable and not loc_Enabled then
		if not loc_Initiated then
			lossofcontrolInit()
		end
        toggleLOCart(true)
		loc_Enabled = true
	elseif loc_Enabled then
        toggleLOCart(false)
		loc_Enabled = false
	end
end