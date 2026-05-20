local _, addon = ...
local isInitiated,isEnabled,popup,pendingClose
local EL = CreateFrame("Frame")

local texture = {
	["Horde"] = "pvpqueue-chest-horde-collect",
	["Alliance"] = "pvpqueue-chest-alliance-collect",
	["Neutral"] = "mythicplus-chest-silver"
}

local airdrops = { -- Warmode Airdrops
	["Grand Marshal Tremblade"] = { -- Nazjatar (BfA)
		"Incoming supplies!"
	},
	["High Warlord Volrath"] = { -- Nazjatar (BfA)
		"Got some supplies for ya."
	},
	["Malicia"] = { -- Dragon Isles
		"Looks like you could all use some resources."
	},
	["Ruffious"] = { -- War Within
		"Looks like there's treasure nearby.",
		"Opportunity's knocking!",
		"I see some valuable resources in the area!",
		"There's a cache of resources nearby.",
	},
	["Vidious"] = { -- Midnight
		"You like goods don't you? Then find them.",
		"Keep an eye out for opportunities for loot when they arise, like now!",
	},
	["Ziadan"] = { -- Midnight
		"Take the early advantage and get your spoils.",
		"That looks like a treasure out in the distance. Don't miss this opportunity",
	},
}
local spectral = { -- Slayer's Rise, Spectral Battle Chest
	["Vidious"] = {
		"Standing around? And I thought the Alliance were fighters! Show me I was right.",
		"Huh what's happening? Something big it seems.",
	},
	["Ziadan"] = {
		"Has the Horde grown weak or do you no longer want treasure? Go find it.",
		"There are rumblings I can sense coming. Go explore Slayer's Rise and see what they are.",
	},
}

local function runAlert(msg,col)
	if pendingClose then
		print('|cffff00ffAdditional: |r'..msg) -- Just incase spectral and airdrop spawn during the same 5 seconds.
		return
	end
	local c = {
		[1] = {r=1,g=1,b=.4},
		[2] = {r=.8,g=.3,b=1}
	}
	pendingClose = true
	print('\n      '..msg..'\n\n')
	popup.text:SetTextColor(c[col].r,c[col].g,c[col].b,1)
	popup.text:SetText(msg)
	popup:Show()
	PlaySoundFile("Interface\\AddOns\\ES_Utilities\\Media\\airdrop.ogg", "Master")
	FlashClientIcon()
	C_Timer.After(5, function()
		popup:Hide()
		pendingClose = nil
	end)
end

EL:SetScript("OnEvent", function(self, event, text, name, ...)
	if not isEnabled or not ESUTIL_DB.toggles.talkingheadwarmode then return end
	if issecretvalue(text) or issecretvalue(name) then return end
	if not (text and name and tostring(text) and tostring(name)) then return end
	if airdrops[name] then
		for _,line in ipairs(airdrops[name]) do
			if string.find(text, line, 1, true) then
				runAlert('Incoming Airdrop!',1)
				return
			end
		end
	end
	if spectral[name] then
		for _,line in ipairs(spectral[name]) do
			if string.find(text, line, 1, true) then
				runAlert('FFA Battle Chest!',2)
				return
			end
		end
	end
end)

local function talkingHeadInit()
	local englishFaction = UnitFactionGroup("player")
	local chestAtlas = texture[englishFaction] or texture["Neutral"]
	local size = texture[englishFaction] and 140 or 80
	popup = CreateFrame("Frame", "ES_Utilities_Airdrop", UIParent, "TooltipBackdropTemplate")
	popup:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
	popup:SetSize(180,110)
	local icon = popup:CreateTexture(nil, "ARTWORK")
	icon:SetSize(size,size)
	icon:SetPoint("CENTER", popup, "TOP", 0, -40)
	icon:SetAtlas(chestAtlas)
	popup.text = popup:CreateFontString(nil, "OVERLAY")
	popup.text:SetPoint("BOTTOM", 0, 10)
	popup.text:SetFont("Fonts\\MORPHEUS.ttf", 20, "OUTLINE")
	popup.text:SetJustifyH("CENTER")
	popup:Hide()
	hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
		if not isEnabled then return end
		if ESUTIL_DB.toggles.talkingheadsound then
			if pendingClose then
				self:CloseImmediately()
			else
				self:Hide()
			end
		else
			self:CloseImmediately()
		end
	end)
	EL:RegisterEvent("CHAT_MSG_MONSTER_SAY")
end

addon.toggleTalkingHead = function(enable)
    if enable and not isInitiated then
		isInitiated = true
		talkingHeadInit()
	end
	isEnabled = enable
end