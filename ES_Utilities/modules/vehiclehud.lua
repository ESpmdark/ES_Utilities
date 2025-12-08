local _, addon = ...
local isInitiated = false
local isEnabled = false
local editmode = false
local delay = 0
local isVisible
local main, loop --frames

local ref = {
	vehicle = { -- Priest MC and certain vehicles and questobjects
		[1] = 181,
		[2] = 182,
		[3] = 183,
		[4] = 184,
		[5] = 185,
		[6] = 186,
		[7] = 187,
		[8] = 188,
		[9] = 189,
		[10] = 190,
		[11] = 191,
		[12] = 192
	},
	possess = { -- might not be the right values, unverified
		[1] = 193,
		[2] = 194,
		[3] = 195,
		[4] = 196,
		[5] = 197,
		[6] = 198,
		[7] = 199,
		[8] = 200,
		[9] = 201,
		[10] = 202,
		[11] = 203,
		[12] = 204
	},
	override = { -- example: D.R.I.V.E in Undermine
		[1] = 205,
		[2] = 206,
		[3] = 207,
		[4] = 208,
		[5] = 209,
		[6] = 210,
		[7] = 211,
		[8] = 212,
		[9] = 213,
		[10] = 214,
		[11] = 215,
		[12] = 216
	},
}

local activeButtons = {}
local function fetchTooltip(idx)
	if not activeButtons[idx] then return end
	GameTooltip:SetAction(activeButtons[idx])
end

local function updateActions()
	if not ref[isVisible] then return end
	table.wipe(activeButtons)
	for i=1,12 do
		local action = GetActionTexture(ref[isVisible][i]) and ref[isVisible][i] or 0
        local icon = action and GetActionTexture(action)
        local id = icon and select(2, GetActionInfo(action))
        if id then
			activeButtons[i] = action
			local start, dur, _ = GetActionCooldown(action)
			local cCharge, mCharge = GetActionCharges(action)
			local cText = ((mCharge > 1) and cCharge) or ""
			local isUsable, _ = IsUsableAction(action)
			main[i]:Show()
			main[i].overlay:Hide()
			main[i].icon:SetDesaturated(false)
			main[i].charge:SetText(cText)
			if start and start > 0 then
				main[i].cd:SetCooldown(start, dur)
				if tostring(cText) or cText < 1 then
					main[i].overlay:Show()
					main[i].icon:SetDesaturated(true)
				end
			elseif not isUsable then
				main[i].overlay:Show()
				main[i].icon:SetDesaturated(true)
			end
			main[i].icon:SetTexture(icon)
		else
			main[i]:Hide()
		end
	end
end

local function updateDisplay(editmode)
	if not editmode then
		updateActions()
	end
	local padding = 4
	local count = 0
	local notPrevious
	for i=1,12 do
		if main[i]:IsVisible() then
			local extrapadding = notPrevious and 20 or 0
			padding = padding + extrapadding
			main[i]:SetPoint("LEFT", main, "LEFT", padding + (count * (ESUTIL_DB.vehiclehud.iconsize + 2)), 0)
			count = count + 1
			notPrevious = false
		else
			notPrevious = true
		end
	end
	if count > 0 then
		main:SetWidth(2 + padding  + (count * (ESUTIL_DB.vehiclehud.iconsize + 2)))
	end
end

local function updateShownState()
	if editmode then
		main:Show()
		ES_Utilities_VHedit:SetPoint("BOTTOM", main, "TOP", 0, 6)
		ES_Utilities_VHedit:Show()
		for i=1,12 do
			main[i].icon:SetTexture(618979)
			main[i]:Show()
		end
		updateDisplay(true)
		return
	end
	if HasOverrideActionBar() then
		isVisible = "override"
	elseif HasVehicleActionBar() then
		isVisible = "vehicle"
	elseif IsPossessBarVisible() then
		isVisible = "possess"
	elseif isVisible then
		isVisible = nil
	end	
	if isVisible then
		loop:Show()
		main:Show()
	else
		loop:Hide()
		main:Hide()
		for i=1,12 do
			main[i]:Hide()
		end
	end
end

local function setPointandSize()
	main:SetSize((8+(ESUTIL_DB.vehiclehud.iconsize+2)*12),ESUTIL_DB.vehiclehud.iconsize+8)
	main:SetScale(ESUTIL_DB.vehiclehud.scale)
	main:SetPoint("CENTER", UIParent, "CENTER", ESUTIL_DB.vehiclehud.xPos, ESUTIL_DB.vehiclehud.yPos)
	for i=1,12 do
		main[i]:SetSize(ESUTIL_DB.vehiclehud.iconsize,ESUTIL_DB.vehiclehud.iconsize)
	end
end

ES_Utilities_VehicleHUD_mixin = {}

function ES_Utilities_VehicleHUD_mixin:OnLoad()
    self.Header.Text:SetText("Edit Frame")
	self.Scale.Label:SetText("Scale")
	self.PositionText:SetText("Position:")
	self.IconSize.Label:SetText("Icon Size")
	self.xPos.Label:SetText("X:")
	self.yPos.Label:SetText("Y:")
	self:SetFrameStrata("MEDIUM")
end

function ES_Utilities_VehicleHUD_mixin:OnShow()
	self.Scale.EditBox:SetText(ESUTIL_DB.vehiclehud.scale)
	self.IconSize.EditBox:SetText(ESUTIL_DB.vehiclehud.iconsize)
	self.xPos.EditBox:SetText(ESUTIL_DB.vehiclehud.xPos)
	self.yPos.EditBox:SetText(ESUTIL_DB.vehiclehud.yPos)
end

function ES_Utilities_VehicleHUD_mixin:OnEnterPressed(field)
	self:ClearFocus()
	if not tonumber(self:GetText()) then
		self:SetText(ESUTIL_DB.vehiclehud[field])
		return
	end
	ESUTIL_DB.vehiclehud[field] = self:GetText()
	updateDisplay(true)
	setPointandSize()
end

function ES_Utilities_VehicleHUD_mixin:OnAccept()
	ESUTIL_DB.toggles.vehicleedit = false
	addon.toggleVehicleEdit(false)
	local panel = _G["ES_Utilities_ConfigScrollFrame"].ScrollChild
	for _,child in ipairs({ panel:GetChildren() }) do
		if child:GetName() == "vehicleedit" then
			child:SetChecked(false)
		end
	end
	self:Hide()
end

local function InitializeFrames()
	main = CreateFrame("Frame","ES_VehicleHUD", UIParent)
	main:Hide()

	loop = CreateFrame("Frame",nil, UIParent)
	loop:SetScript("OnUpdate", function(self,elapsed)
		if editmode then return end
		delay = delay + elapsed
		if delay >= 0.1 then
			delay = 0
			updateDisplay()
		end
	end)
	loop:Hide()

	main.background = main:CreateTexture(nil, "BACKGROUND")
	main.background:SetAllPoints()
	main.background:SetAtlas("Glues-AnnouncementPopup-Background")
	main.background:SetAlpha(0.8)

	main.nineslice_TL = main:CreateTexture(nil, "BORDER")
	main.nineslice_TL:SetPoint("TOPLEFT", -6, 6)
	main.nineslice_TL:SetAtlas("GenericMetal2-Nineslice-CornerTopLeft")
	main.nineslice_TL:SetSize(16,16)
	main.nineslice_TL:SetAlpha(0.5)

	main.nineslice_TR = main:CreateTexture(nil, "BORDER")
	main.nineslice_TR:SetPoint("TOPRIGHT", 6, 6)
	main.nineslice_TR:SetAtlas("GenericMetal2-Nineslice-CornerTopRight")
	main.nineslice_TR:SetSize(16,16)
	main.nineslice_TR:SetAlpha(0.5)

	main.nineslice_BL = main:CreateTexture(nil, "BORDER")
	main.nineslice_BL:SetPoint("BOTTOMLEFT", -6, -6)
	main.nineslice_BL:SetAtlas("GenericMetal2-Nineslice-CornerBottomLeft")
	main.nineslice_BL:SetSize(16,16)
	main.nineslice_BL:SetAlpha(0.5)

	main.nineslice_BR = main:CreateTexture(nil, "BORDER")
	main.nineslice_BR:SetPoint("BOTTOMRIGHT", 6, -6)
	main.nineslice_BR:SetAtlas("GenericMetal2-Nineslice-CornerBottomRight")
	main.nineslice_BR:SetSize(16,16)
	main.nineslice_BR:SetAlpha(0.5)

	main.nineslice_T = main:CreateTexture(nil, "BORDER")
	main.nineslice_T:SetPoint("TOPLEFT", 10, 6)
	main.nineslice_T:SetPoint("TOPRIGHT", -10, 6)
	main.nineslice_T:SetAtlas("_GenericMetal2-NineSlice-EdgeTop")
	main.nineslice_T:SetHeight(16)
	main.nineslice_T:SetAlpha(0.5)

	main.nineslice_B = main:CreateTexture(nil, "BORDER")
	main.nineslice_B:SetPoint("BOTTOMLEFT", 10, -6)
	main.nineslice_B:SetPoint("BOTTOMRIGHT", -10, -6)
	main.nineslice_B:SetAtlas("_GenericMetal2-NineSlice-EdgeBottom")
	main.nineslice_B:SetHeight(16)
	main.nineslice_B:SetAlpha(0.5)

	main.nineslice_L = main:CreateTexture(nil, "BORDER")
	main.nineslice_L:SetPoint("TOPLEFT", -6, -10)
	main.nineslice_L:SetPoint("BOTTOMLEFT", -6, 10)
	main.nineslice_L:SetAtlas("!GenericMetal2-NineSlice-EdgeLeft")
	main.nineslice_L:SetWidth(16)
	main.nineslice_L:SetAlpha(0.5)

	main.nineslice_R = main:CreateTexture(nil, "BORDER")
	main.nineslice_R:SetPoint("TOPRIGHT", 6,-10)
	main.nineslice_R:SetPoint("BOTTOMRIGHT", 6, 10)
	main.nineslice_R:SetAtlas("!GenericMetal2-NineSlice-EdgeRight")
	main.nineslice_R:SetWidth(16)
	main.nineslice_R:SetAlpha(0.5)

	for i=1,12 do
		main[i] = CreateFrame("Frame",nil,main)
		main[i]:SetSize(ESUTIL_DB.vehiclehud.iconsize,ESUTIL_DB.vehiclehud.iconsize)
		main[i]:Hide()
		local slotN = main[i]:CreateFontString(nil, "ARTWORK")
		slotN:SetFont("Fonts\\ARIALN.TTF", 20, "OUTLINE")
		slotN:SetPoint("TOPRIGHT", main[i], "TOPRIGHT", 0, -2)
		slotN:SetText(GetBindingKey("ACTIONBUTTON"..i))
		main[i].charge = main[i]:CreateFontString(nil, "ARTWORK")
		main[i].charge:SetFont("Fonts\\ARIALN.TTF", 24, "OUTLINE")
		main[i].charge:SetPoint("BOTTOMRIGHT", main[i], "BOTTOMRIGHT", 0, 1)
		main[i].charge:SetTextColor(0, 1, .5, 1)
		main[i].charge:SetText("")
		main[i].cd = CreateFrame("Cooldown", nil, main[i], "CooldownFrameTemplate")
		main[i].cd:SetDrawEdge(false)
		main[i].cd:SetDrawBling(false)
		main[i].cd:SetAllPoints()
		main[i].icon = main[i]:CreateTexture(nil, "BACKGROUND", nil, 1)
		main[i].icon:SetAllPoints()
		main[i].icon:SetTexture(136243)
		main[i].icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		main[i].overlay = main[i]:CreateTexture(nil, "BACKGROUND", nil, 2)
		main[i].overlay:SetAllPoints()
		main[i].overlay:SetColorTexture(.8, 0, 0, .5)
		main[i].overlay:Hide()
		local border = main[i]:CreateTexture(nil, "BACKGROUND", nil, 3)
		border:SetAllPoints()
		border:SetTexture("Interface\\AddOns\\ES_VehicleHUD\\border_VehicleButton.tga")
		border:Show()
		main[i]:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT")
				fetchTooltip(i)
				GameTooltip:Show()
		end)
		main[i]:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
		end)
		main[i]:EnableMouse(false)
		main[i]:EnableMouseMotion(true)
	end
	setPointandSize()
end

local eventList = {
	["UPDATE_VEHICLE_ACTIONBAR"] = true,
	["UPDATE_OVERRIDE_ACTIONBAR"] = true,
	["UPDATE_POSSESS_BAR"] = true,
}

local EL = CreateFrame("Frame")
EL:SetScript("OnEvent", function(self, event, ...)
	if eventList[event] then
		if HasVehicleActionBar() then
			isVisible = "vehicle"
		elseif HasOverrideActionBar() then
			isVisible = "override"
		elseif IsPossessBarVisible() then
			isVisible = "possess"
		else
			isVisible = nil
		end
		updateShownState()
	end
end)

addon.toggleVehicleHUD = function(enable)
    if enable and not isEnabled then
		if not isInitiated then
			isInitiated = true
			InitializeFrames()
		end
		for e,_ in pairs(eventList) do
			EL:RegisterEvent(e)
		end
		editmode = ESUTIL_DB.toggles.vehicleedit
		updateShownState()
		isEnabled = true
	elseif not enable and isEnabled then
		for e,_ in pairs(eventList) do
			EL:UnregisterEvent(e)
		end
		updateShownState()
		isEnabled = false
	end
end

addon.toggleVehicleEdit = function(enable)
    if not isEnabled then return end
	if enable and not editmode then
		editmode = true
		updateShownState()
	elseif not enable and editmode then
		editmode = false
		updateShownState()
	end
end