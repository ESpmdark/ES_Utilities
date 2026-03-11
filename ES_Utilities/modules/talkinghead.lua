local _, addon = ...
local isInitiated,isEnabled

local whitelist = { -- Warmode Airdrops
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
	["Vidious"] ={ -- Midnight
		"You like goods don't you? Then find them.",
		"Keep an eye out for opportunities for loot when they arise, like now!",
	},
	["Ziadan"] ={ -- Midnight
		"Take the early advantage and get your spoils.",
		"That looks like a treasure out in the distance. Don't miss this opportunity",
	},
}
local function talkingHeadInit()
	hooksecurefunc(TalkingHeadFrame, "PlayCurrent", function(self)
		if not isEnabled then return end
		local _, _, _, _, _, _, name, text = C_TalkingHead.GetCurrentLineInfo();
		if not text then return end
		if ESUTIL_DB.toggles.talkingheadwarmode and whitelist[name] then
			for _,line in ipairs(whitelist[name]) do
				if string.match(text, line) then
					return
				end
			end
		end
		if ESUTIL_DB.toggles.talkingheadsound then
			self:Hide()
		else
			self:CloseImmediately()
		end
	end)
end

addon.toggleTalkingHead = function(enable)
    if enable and not isInitiated then
		isInitiated = true
		talkingHeadInit()
	end
	isEnabled = enable
end