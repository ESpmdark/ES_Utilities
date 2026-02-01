ES_Utilities_TalentMainMixin = {}
function ES_Utilities_TalentMainMixin:OnLoad()
	self.AcceptButton:SetEnabled(false)
	self.Title:SetText(self.titleText)
	self.exclusive = true;
	self.AcceptButton:SetOnClickHandler(GenerateClosure(self.OnAccept, self));
	self.CancelButton:SetOnClickHandler(GenerateClosure(self.OnCancel, self));

	if self.NameControl then self.NameControl:GetEditBox():SetAutoFocus(false); end
	if self.ImportControl then self.ImportControl:GetEditBox():SetAutoFocus(false); end

end

function ES_Utilities_TalentMainMixin:OnHide()

end

function ES_Utilities_TalentMainMixin:OnCancel()
	if self:GetName() == "ES_Utilities_TalentImport" then
		self.CheckButton:SetChecked(false)
		self.CheckButton.Text:SetText("Save build directly from import string")
		self.NameControl:Hide()
		self.Title:SetText("Import talents from loadout")
		self.AcceptButton:SetText("Import")
	end
	self:Hide()
end

function ES_Utilities_TalentMainMixin:OnAccept()
	if self.AcceptButton:IsEnabled() then
		local success
		if self:GetName() == "ES_Utilities_TalentSave" then
			local loadoutName = self.NameControl:GetText();
			success = ES_Utilities_TalentSaveDialog(loadoutName)
		elseif self:GetName() == "ES_Utilities_TalentImport" then
			local importText = self.ImportControl:GetText();
			local loadoutName = self.NameControl:GetText();
			if self.CheckButton:GetChecked() then
				success = ES_Utilities_TalentSaveDialog(loadoutName, importText)
			else
				success = ES_Utilities_TalentImportBuild(importText)
			end
		end
		if success then
			if self:GetName() == "ES_Utilities_TalentImport" then
				self.CheckButton:SetChecked(false)
				self.CheckButton.Text:SetText("Save build directly from import string")
				self.NameControl:Hide()
				self.Title:SetText("Import talents from loadout")
				self.AcceptButton:SetText("Import")
			end
			self:Hide()
		end
	end
end

function ES_Utilities_TalentMainMixin:UpdateAcceptButtonEnabledState()
	local importTextFilled = self.ImportControl and self.ImportControl:HasText();
	local nameTextFilled = self.NameControl:HasText();
	local result = false
	if self:GetName() == "ES_Utilities_TalentSave"  then
		result = nameTextFilled
	elseif self:GetName() == "ES_Utilities_TalentImport" then
		if self.CheckButton:GetChecked() then
			result = (importTextFilled and nameTextFilled)
		else
			result = importTextFilled
		end
	end
	self.AcceptButton:SetEnabled(result);
end

function ES_Utilities_TalentMainMixin:OnTextChanged()
	self:UpdateAcceptButtonEnabledState();
end

ES_Utilities_TalentEditBoxMixin = {}

function ES_Utilities_TalentEditBoxMixin:OnLoad()
	local editBox = self:GetEditBox();
	editBox:SetScript("OnTextChanged", GenerateClosure(self.OnTextChanged, self));
	editBox:SetScript("OnEnterPressed", GenerateClosure(self.OnEnterPressed, self));
	editBox:SetScript("OnEscapePressed", GenerateClosure(self.OnEscapePressed, self));
	self.Label:SetText(self.labelText);
end

function ES_Utilities_TalentEditBoxMixin:OnShow()
	self:GetEditBox():SetText("");
end

function ES_Utilities_TalentEditBoxMixin:GetText()
	return self:GetEditBox():GetText();
end

function ES_Utilities_TalentEditBoxMixin:SetText(text)
	return self:GetEditBox():SetText(text);
end

function ES_Utilities_TalentEditBoxMixin:HasText()
	return UserEditBoxNonEmpty(self:GetEditBox());
end

function ES_Utilities_TalentEditBoxMixin:OnTextChanged()
	self:GetParent():OnTextChanged();
	InputScrollFrame_OnTextChanged(self.InputContainer.EditBox);
end

function ES_Utilities_TalentEditBoxMixin:GetEditBox()
	return self.InputContainer.EditBox;
end

function ES_Utilities_TalentEditBoxMixin:OnEnterPressed()

end

function ES_Utilities_TalentEditBoxMixin:OnEscapePressed()

end