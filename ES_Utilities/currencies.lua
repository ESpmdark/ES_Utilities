local _, addon = ...

local currencies = {
	[1] = 3269, -- Catalyst
	[2] = 3008, -- Valor
	[3] = 3284, -- Weathered
	[4] = 3286, -- Carved
	[5] = 3288, -- Runed
	[6] = 3290 -- Gilded
}
local ESUC_Frame

local currencycounter = 0
local function createCurrencies(i)
	local f = CreateFrame("Frame", "curr"..i)
	f:SetSize(24,24)
	local extrapadding = 0
	if i ~= 1 then
		extrapadding = 7
	end
	f:SetPoint("TOPLEFT", ESUC_Frame, "TOPLEFT", 4, -1 * ((currencycounter * 28) + 4 + extrapadding))
	f:SetParent(ESUC_Frame)
	f.t = f:CreateTexture(nil, "ARTWORK")
	f.t:SetAllPoints()
	f.txt = f:CreateFontString(nil, "OVERLAY")
	f.txt:SetPoint("LEFT", f, "RIGHT", 2, 0)
	f.txt:SetFont("Interface\\Addons\\ES_Utilities\\LiberationSans-Regular.TTF", 16, "OUTLINE")
	
	local ID = currencies[i]
	local info = C_CurrencyInfo.GetCurrencyInfo(ID)
	local link = C_CurrencyInfo.GetCurrencyLink(ID)
	f.t:SetTexture(info.iconFileID)
	f:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetHyperlink(link)
	end)
	f:SetScript("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	
	currencycounter = currencycounter + 1
end

local qualColor = {
	[1] = '|cff34d9ff',
	[2] = '|cffffffff',
	[3] = '|cff1eff00',
	[4] = '|cff2a91f1',
	[5] = '|cffc356ff',
	[6] = '|cffff8000'
}

addon.updateCurrencies = function()
	local tbl = {}
	for i=1,6 do
        local curr = C_CurrencyInfo.GetCurrencyInfo(currencies[i])
		local earned = curr.totalEarned or 0
		if i == 1 then -- Catalyst
			tbl[i] = qualColor[i] .. curr.quantity .. '|r |cffbebebe(Catalyst)|r'
		elseif i == 2 then -- Valorstones
			tbl[i] = qualColor[i] .. curr.quantity .. '|r |cffbebebe(' .. (curr.maxQuantity - curr.quantity) .. ')|r'
		else -- Crests
			tbl[i] = qualColor[i] .. curr.quantity .. '|r '
			if curr.maxQuantity and curr.maxQuantity > 0 then
				tbl[i] = tbl[i] .. '|cffbebebe(' .. (curr.maxQuantity - earned) .. ')|r'
			end
		end
    end
	local reverseFrame = {
		["curr1"] = 1,
		["curr2"] = 2,
		["curr3"] = 3,
		["curr4"] = 4,
		["curr5"] = 5,
		["curr6"] = 6,
	}
	local f = _G["CharacterFrame"]
	local f2
	for i=1, select("#", f:GetChildren()) do
		local ChildFrame = select(i, f:GetChildren())
		local name = ChildFrame:GetName()
		if name == "ES_Utilities_Currencies" then
			f2 = ChildFrame
			break
		end
	end
	for i=1, select("#", f2:GetChildren()) do
		local ChildFrame = select(i, f2:GetChildren())
		local name = ChildFrame:GetName()
		if reverseFrame[name] then
			ChildFrame.txt:SetText(tbl[reverseFrame[name]])
		end
	end
end

addon.ESUC_Frame_Init = function()
	ESUC_Frame = CreateFrame("Frame", "ES_Utilities_Currencies", _G["CharacterFrame"])
	local txt = ESUC_Frame:CreateTexture(nil, "BACKGROUND")
	txt:SetAllPoints()
	txt:SetColorTexture(0, 0, 0, 0.8)
	ESUC_Frame:SetPoint("TOPRIGHT", 131, -22)
	ESUC_Frame:SetSize(130,180)
	ESUC_Frame:SetFrameStrata("BACKGROUND")
	ESUC_Frame:Show()
	
	local bTop = ESUC_Frame:CreateTexture(nil, "OVERLAY")
	bTop:SetPoint("BOTTOMLEFT", ESUC_Frame, "TOPLEFT", -1, -1)
	bTop:SetPoint("TOPRIGHT", ESUC_Frame, "TOPRIGHT", 1, 1)
	bTop:SetColorTexture(.2,.2,.2,.8)
	local bsep = ESUC_Frame:CreateTexture(nil, "OVERLAY")
	bsep:SetPoint("BOTTOMLEFT", ESUC_Frame, "TOPLEFT", -1, -32)
	bsep:SetPoint("TOPRIGHT", ESUC_Frame, "TOPRIGHT", 0, -34)
	bsep:SetColorTexture(.2,.2,.2,.8)
	local bBot = ESUC_Frame:CreateTexture(nil, "OVERLAY")
	bBot:SetPoint("BOTTOMLEFT", ESUC_Frame, "BOTTOMLEFT", -1, -1)
	bBot:SetPoint("TOPRIGHT", ESUC_Frame, "BOTTOMRIGHT", 1, 1)
	bBot:SetColorTexture(.2,.2,.2,.8)
	local bLeft = ESUC_Frame:CreateTexture(nil, "OVERLAY")
	bLeft:SetPoint("BOTTOMLEFT", ESUC_Frame, "BOTTOMLEFT", -1, -1)
	bLeft:SetPoint("TOPRIGHT", ESUC_Frame, "TOPLEFT", 1, 1)
	bLeft:SetColorTexture(.2,.2,.2,.8)
	local bRight = ESUC_Frame:CreateTexture(nil, "OVERLAY")
	bRight:SetPoint("BOTTOMLEFT", ESUC_Frame, "BOTTOMRIGHT", -1, -1)
	bRight:SetPoint("TOPRIGHT", ESUC_Frame, "TOPRIGHT", 1, 1)
	bRight:SetColorTexture(.2,.2,.2,.8)
	
	for i=1,6 do
		createCurrencies(i)
	end
	addon.updateCurrencies()
end





