local _, addon = ...

local rewardFrame = CreateFrame("Frame", nil, _G["GameMenuFrame"])
rewardFrame:SetFrameStrata("TOOLTIP")
rewardFrame:SetSize(10,10)
rewardFrame:SetPoint("TOPRIGHT", 10, -10)
local rewardFrametxt, getRenownQuests, rewardFrame_OnShow

local fID = {
	-- The War Within
	2590, -- Council of Dornogal
	2570, -- Hallowfall Arathi
	2594, -- The Assembly of the Deeps
	2600, -- The Severed Threads
	2605, -- The General
	2607, -- The Vizier
	2601, -- The Weaver
	2653, -- The Cartels of Undermine
	2677, -- Steamwheedle Cartel
	2671, -- Venture Company
	2669, -- Darkfuse Solutions
	2673, -- Bilgewater Cartel
	2675, -- Blackwater Cartel
	2689, -- Flame's Radiance
	2658, -- The K'aresh Trust
	
	-- Dragonflight
	2574, -- Dream Wardens
	2511, -- Iskaara Tuskarr
	2564, -- Loamm Niffen
	2503, -- Maruuk Centaur
	2507, -- Dragonscale Expedition
	2510, -- Valdrakken Accord
	
	-- Shadowlands
	2407, -- The Ascended
	2413, -- Court of Harvesters
	2410, -- The Undying Army
	2465, -- The Wild Hunt
	2432, -- Ve'nari
	2470, -- Death's Advance
	2472, -- The Archivists' Codex
	2478, -- The Enlightened
	
	-- Battle for Azeroth
	2164, -- Champions of Azeroth
	2163, -- Tortollan Seekers
	2391, -- Rustbolt Resistance
	2415, -- Rajani
	2417, -- Uldum Accord
	2159, -- 7th Legion
	2161, -- Order of Embers
	2160, -- Proudmoore Admiralty
	2162, -- Storm's Wake
	2400, -- Waveblade Ankoan
	2157, -- The Honorbound
	2156, -- Talanji's Expedition
	2158, -- Voldunai
	2103, -- Zandalari Empire
	2373, -- The Unshackled
	
	-- Legion
	1828, -- Highmountain Tribe
	1900, -- Court of Farondis
	1883, -- Dreamweavers
	1894, -- The Wardens
	1948, -- Valarjar
	1859, -- The Nightfallen
	2045, -- Armies of Legionfall
	2170, -- Argussian Reach
	2165 -- Army of the Light
}
local rQIDs = {
	[1] = {
		["name"] = "|cffff5d76Dornogal|r",
		["fid"] = 2590,
		["id"] = {
			[3] = {82342},
			[5] = {84404},
			[6] = {82333},
			[7] = {82346},
			[8] = {84403},
			[9] = {82344},
			[11] = {82349},
			[12] = {82348},
			[17] = {82356,85545},
			[18] = {85546},
			[19] = {82358},
			[20] = {82359},
			[22] = {82361},
			[24] = {82365},
			[25] = {82362}    
		}
	},
	[2] = {
		["name"] = "|cfffcba75Ringing Deeps|r",
		["fid"] = 2594,
		["id"] = {
			[6] = {82369},
			[7] = {82385},
			[8] = {82371},
			[9] = {82370},
			[10] = {82372},
			[11] = {82373},
			[12] = {82379},
			[13] = {82375},
			[14] = {82376},
			[15] = {82377},
			[16] = {82378},
			[17] = {83043},
			[18] = {85538},
			[20] = {82381},
			[21] = {82382},
			[22] = {85543,82383},
			[23] = {83046},
			[24] = {82384,85544},
			[25] = {84914}    
		}
	},
	[3] = {
		["name"] = "|cff9482c9Azj-Kahet|r",
		["fid"] = 2600,
		["id"] = {
			[3] = {82417},
			[6] = {82418},
			[8] = {85535},
			[9] = {82431},
			[10] = {82432},
			[12] = {82433},
			[13] = {82434},
			[14] = {85532,82435},
			[18] = {82440,85533},
			[21] = {82443},
			[22] = {85534,82444},
			[24] = {82446}    
		}
	},
	[4] = {
		["name"] = "|cfffff000Hallowfall|r",
		["fid"] = 2570,
		["id"] = {
			[4] = {82335},
			[6] = {82390},
			[7] = {84409},
			[8] = {82393},
			[9] = {82394},
			[12] = {82396},
			[13] = {84559},
			[14] = {82398},
			[16] = {82400,85536},
			[19] = {82403,85537},
			[22] = {82406},
			[23] = {83334},
			[24] = {82407}
		}
	},
	[5] = {
		["name"] = "|cffff7d0aFlame's Radiance|r",
		["fid"] = 2688,
		["id"] = {
			[2] = {89349},
			[3] = {89390},
			[4] = {89391,89398},
			[5] = {89392},
			[6] = {89393},
			[7] = {89394,89399},
			[8] = {89395},
			[9] = {89396},
			[10] = {89397,89400}
		}
	},
	[6] = {
		["name"] = "|cff98ff00Undermine|r",
		["fid"] = 2653,
		["id"] = {
			[3] = {85816},
			[4] = {85815},
			[6] = {85817},
			[8] = {85818},
			[9] = {85819,90557},
			[11] = {85820},
			[12] = {85821},
			[15] = {85823},
			[17] = {85824},
			[18] = {85825},
			[20] = {85827}
		}
	},
	[7] = {
		["name"] = "|cff69ccf0K'aresh|r",
		["fid"] = 2658,
		["id"] = {
			[5] = {90630,90631},
			[6] = {90632},
			[8] = {90633,90634},
			[9] = {90635},
			[12] = {90636,90637},
			[13] = {90638},
			[14] = {91143},
			[16] = {92330},
			[17] = {90665},
			[18] = {90666},
			[20] = {90667}
		}
	}
}

addon.rewardFrame_Init = function()
	rewardFrametxt = rewardFrame:CreateFontString(nil, "OVERLAY")
	rewardFrametxt:SetPoint("TOPLEFT",0,0)
	rewardFrametxt:SetFont(addon.font_LiberationSansRegular, 18, "OUTLINE")
	rewardFrametxt:SetWidth(500)
	rewardFrametxt:SetText('')
	rewardFrametxt:SetJustifyH("LEFT")

	getRenownQuests = function()
		local str = ""
		for i=1,7 do
			local tbl = C_MajorFactions.GetRenownLevels(rQIDs[i]["fid"])
			local level = 0
			for j=1,#tbl do
				if not tbl[j].locked then
					level = j
				else
					break
				end
			end
			local count = 0
			if level >= 1 then
				for k=1,level do
					local tmp = rQIDs[i]["id"][k]
					if tmp then
						for _,v in ipairs(tmp) do
							if not C_QuestLog.IsQuestFlaggedCompleted(v) then
								count = count + 1
							end
						end
					end
				end
			end
			if count >= 1 then
				str = str .. '\n' .. rQIDs[i]["name"] .. ': ' .. count
			end
		end
		if str ~= "" then
			str = "Renown rewards available:" .. str
		end
		return str
	end

	rewardFrame_OnShow = function()
		local rt = '|cff85ff00Available \nParagon Chest:|r\n\n'
		local show
		for i=1,#fID do
			local _, _, _, reward = C_Reputation.GetFactionParagonInfo(fID[i])
			if reward then
				if not show then show = true end
				local data = C_Reputation.GetFactionDataByID(fID[i])
				rt = rt .. (data and data.name or "nil") .. '\n'
			end
		end
		if show then
			rt = rt .. '\n\n' -- Make seperators for RenownQuests
		else
			rt = ""
		end
		rt = rt .. getRenownQuests()
		rewardFrametxt:SetText(rt)
	end
	rewardFrame:SetScript("OnShow", rewardFrame_OnShow)
end