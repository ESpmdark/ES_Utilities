local _, addon = ...
local yPos = 0
local description = {
    [1] = {
        key = "vault",
        text = "Great Vault Button",
        tt = "Add a button to the ESC menu for easy access to your vault UI.",
    },
	[2] = {
        key = "weekly",
        text = "Vault Progress",
        tt = "Adds a Weakaura inspired tracker to your top left screen when ESC menu is open.\n\nWill track any progress across characters, aswell as display current keystones.",
    },
	[3] = {
        key = "rewards",
        text = "Paragon Rewards",
        tt = "Will display any available paragon chest on the right side of your ESC menu.",
        child = {
	        [1] = {
                key = "renown",
                text = "Include renown",
                tt = "Also show any unclaimed renown reward (Crests, Valorstone etc) the current character is eligble to pick up.",
            },
        },
    },
	[4] = {
        key = "currency",
        text = "Item upgrade currencies",
        tt = "Adds a tooltip to the right of your characterpanel, displaying current seasons curriencies used for upgrading items.",
    },
	[5] = {
        key = "autoloot",
        text = "Better autoloot",
        tt = "A faster and bugfree autoloot, that maintains default Blizzard lootframe.",
    },
	[6] = {
        key = "collected",
        text = "Collections",
        tt = "Adds a lightweight version of CanIMogIt for Merchants and the EncounterJournal.",
    },
	[7] = {
        key = "drinkmacro",
        text = "Drink Macro",
        tt = "Will automate a macro of your chosing to adapt to your situation and chose available consumables (including mage food).",
    },
	[8] = {
        key = "talkinghead",
        text = "Hide Talking Head",
        tt = "Hides the talking head frame.",
        child = {
	        [1] = {
                key = "talkingheadsound",
                text = "Keep sound",
                tt = "Keep the voiceline rolling even when hiding the frame.",
            },
	        [2] = {
                key = "talkingheadwarmode",
                text = "Whitelist airdrops",
                tt = "Will allow the frame to play if it is notifying an incoming warmode airdrop.",
            },
        },
    },
	[9] = {
        key = "extraactionbutton",
        text = "Button Art",
        tt = "Replace button art with a clean border for ExtraActionButton1 and ZoneAbility.",
    },
	[10] = {
        key = "lossofcontrol",
        text = "Simple LossOfControl",
        tt = "Clean up Blizzards Loss of Control frame.",
    },
}

local function createResetButton(parent)
    StaticPopupDialogs["ESUTILITIES_VPRESET"] = {
	    text = "This will reset all character data stored for your Vault Progress.\n\nAre you sure?",
	    button1 = ACCEPT,
	    button2 = CANCEL,
	    OnAccept = function()
            table.wipe(ESUTIL_DB.chars)
            addon.checkCharEntry()
     	end,
    	timeout = 0,
    	whileDead = true,
    	hideOnEscape = true,
    }
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetPoint("LEFT", parent.Text, "RIGHT", 10, 0)
    b:SetSize(42,24)
    b:SetText("Reset")
    b:SetScript("OnClick", function(self)
        StaticPopup_Show("ESUTILITIES_VPRESET")
    end)
end

local function createEditButton(parent)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetPoint("LEFT", parent.Text, "RIGHT", 10, 0)
    b:SetSize(38,24)
    b:SetText("Edit")
    b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText("Macro must already exist and have a unique name.\n\nThe lists only accept ItemID, and is read as one ItemID per line.", 1, 0.8, 0, 1, true)
    end)
    b:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
    end)
    b:SetScript("OnClick", function(self)
        ES_Utilities_Popup:Show()
    end)
end

local function createToggle(info,child)
    local panel = _G["ES_Utilities_ConfigScrollFrame"].ScrollChild
    local b = CreateFrame("CheckButton", info.key, panel, "UICheckButtonTemplate")
    b:SetSize(28,28)
    local xPos = child and 60 or 10
    b:SetPoint("TOPLEFT", panel, "TOPLEFT", xPos, yPos)
    b:SetChecked(ESUTIL_DB.toggles[info.key])
    b.Text:SetText(info.text)
    local fontPath, _, fontFlags = b.Text:GetFont()
    if not child then
        b.Text:SetFont(fontPath, 18, fontFlags)
    else
        b.Text:SetFont(fontPath, 14, fontFlags)
        b.Text:SetTextColor(1,1,1)
    end
    b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
			GameTooltip:SetText(info.tt, 1, 0.8, 0, 1, true)
    end)
    b:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
    end)
    b:SetScript("OnClick", function(self)
        addon.toggleSettings(info.key, self:GetChecked())
    end)
    yPos = yPos - 38
    if info.key == "drinkmacro" then
        createEditButton(b)
    elseif info.key == "weekly" then
        createResetButton(b)
    end
end

local function iterateToggles(info)
    createToggle(info)
    if not info.child then return end
    for _,v in ipairs(info.child) do
        yPos = yPos + 6
        createToggle(v, true)
    end
end

ESUtilitiesPopupMixin = {}

function ESUtilitiesPopupMixin:OnLoad()
    self.Header.Text:SetText("Drink Macro")
    self.MacroName.Label:SetText("Macro Name:")
    self.DefaultList.Label:SetText("Default Consumables")
    self.ArenaList.Label:SetText("Arena Water")
end

function ESUtilitiesPopupMixin:OnShow()
	self.MacroName.EditBox:SetText(ESUTIL_DB.drinkmacro.name)
	self.DefaultList.InputContainer.EditBox:SetText(ESUTIL_DB.drinkmacro.defaults)
	self.ArenaList.InputContainer.EditBox:SetText(ESUTIL_DB.drinkmacro.arena)
end

function ESUtilitiesPopupMixin:OnAccept()
    local nameT = self.MacroName.EditBox:GetText()
    local defaultsT = self.DefaultList.InputContainer.EditBox:GetText()
    local arenaT = self.ArenaList.InputContainer.EditBox:GetText()
    if nameT then
        ESUTIL_DB.drinkmacro.name = nameT
    end
    if defaultsT then
        ESUTIL_DB.drinkmacro.defaults = defaultsT
    end
    if arenaT then
        ESUTIL_DB.drinkmacro.arena = arenaT
    end
    if ESUTIL_DB.toggles.drinkmacro then
        addon.toggleSettings("drinkmacro", true)
        addon.updateDrinkMacro()
    end
	self:Hide()
end

addon.setupConfig = function()
    for i=1, #description do
        iterateToggles(description[i])
    end

    local panel = _G["ES_Utilities_ConfigScrollFrame"].ScrollChild
    panel:SetHeight(yPos * -1)

    local config = _G["ES_Utilities_Config"]
	local category, _ = Settings.RegisterCanvasLayoutCategory(config, "ES_Utilities");
	Settings.RegisterAddOnCategory(category);
end