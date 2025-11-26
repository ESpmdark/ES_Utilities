local _, addon = ...
local ba_Initiated = false
local ba_Enabled = false
local loc_Initiated = false
local loc_Enabled = false
local hasAddon = false
local EL = CreateFrame("Frame")
local border1,border2,border3

local function toggleBAart(enable)
    if enable then
        border1:SetAlpha(1)
        border2:SetAlpha(1)
	    ExtraActionButton1.style:SetAlpha(0)
	    ExtraActionButton1.style:Hide()
        ZoneAbilityFrame.Style:SetAlpha(0)
	    ZoneAbilityFrame.Style:Hide()
        if hasAddon then
            border3:SetAlpha(1)
        end
    else
        border1:SetAlpha(0)
        border2:SetAlpha(0)
	    ExtraActionButton1.style:SetAlpha(1)
	    ExtraActionButton1.style:Show()
        ZoneAbilityFrame.Style:SetAlpha(1)
	    ZoneAbilityFrame.Style:Show()
        if hasAddon then
            border3:SetAlpha(0)
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
	border3 = CreateFrame("Frame", nil, _G["ExtraQuestButton"])
	border3:SetFrameLevel(100)
	border3:SetPoint("CENTER",0,0)
	border3:SetSize(56,56)
	border3.t = border3:CreateTexture(nil, "ARTWORK")
	border3.t:SetAllPoints()
	border3.t:SetAtlas("loottoast-itemborder-artifact")
	border3.t:Show()
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

	border2 = CreateFrame("Frame", nil, ZoneAbilityFrame.SpellButtonContainer)
	border2:SetFrameLevel(100)
	border2:SetPoint("CENTER",0,0)
	border2:SetSize(56,56)
	border2.t = border2:CreateTexture(nil, "ARTWORK")
	border2.t:SetAllPoints()
	border2.t:SetAtlas("loottoast-itemborder-orange")
	border2.t:Show()

    if C_AddOns.IsAddOnLoaded("ExtraQuestButton") then
        skinExtraQuestButton()
    else
        EL:SetScript("OnEvent", function(self, event, name, ...)
	        if name == "ExtraQuestButton" then
        		EL:UnregisterEvent("ADDON_LOADED")
		        skinExtraQuestButton()
	        end
        end)
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
		if not ba_Initiated then
			buttonartInit()
		end
        toggleBAart(true)
		ba_Enabled = true
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