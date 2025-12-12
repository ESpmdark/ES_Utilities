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
		-- These are verified:		
		"Looks like there's treasure nearby.",
		"Opportunity's knocking!",
		"I see some valuable resources in the area!",
		"There's a cache of resources nearby.",


		-- Have not seen these yet so keeping them in just incase:
		"Time to prove you're as hard-headed as the rams! Bust that cache open and claim the reward!", --Airdrop? Unverified, but likely is.
		"Nothing ventured, nothing gained! Fight back the shadows and claim what they've been hiding!", --Unused WQ-beginning?
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