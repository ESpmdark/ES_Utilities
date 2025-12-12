local _, addon = ...
local isInitiated,isEnabled,greatVault

local function greatVault_Init()
	_G["GameMenuFrame"].Header.Text:SetText(" ") -- Button covers it partially
	greatVault = CreateFrame("Frame", "ES_Utilities_GreatVault", _G["GameMenuFrame"])
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
    isInitiated = true
    isEnabled = true
end

addon.toggleVaultButton = function(enable)
    if PlayerIsTimerunning() then return end
    if enable then
        if not isInitiated then
            if not C_AddOns.IsAddOnLoaded("Blizzard_WeeklyRewards") then
			    C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
		    end
		    local frame = "WeeklyRewardsFrame"
		    if not tContains(UISpecialFrames, frame) then
    			tinsert(UISpecialFrames, frame)
	    	end
    		greatVault_Init()
        elseif not isEnabled then
            greatVault:Show()
            _G["GameMenuFrame"].Header.Text:SetText(" ")
            isEnabled = true
        end
    elseif isEnabled then
        greatVault:Hide()
        _G["GameMenuFrame"].Header.Text:SetText(MAINMENU_BUTTON)
        isEnabled = false
	end
end

