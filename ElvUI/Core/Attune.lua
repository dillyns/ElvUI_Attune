local E, L, V, P, G = unpack(ElvUI);

Attune = {}

function Attune:AddAtuneIcon(button)
	if not button.attuneOrangeIcon then
		local attuneOrangeIcon = button:CreateTexture(nil, "OVERLAY")
		attuneOrangeIcon:SetTexture(E.Media.Textures.AttuneOrangeIcon)
		attuneOrangeIcon:SetTexCoord(0, 1, 0, 1)
		attuneOrangeIcon:SetInside()
		attuneOrangeIcon:Hide()
		button.attuneOrangeIcon = attuneOrangeIcon
	end

	if not button.attuneGreenIcon then
		local attuneGreenIcon = button:CreateTexture(nil, "OVERLAY")
		attuneGreenIcon:SetTexture(E.Media.Textures.AttuneGreenIcon)
		attuneGreenIcon:SetTexCoord(0, 1, 0, 1)
		attuneGreenIcon:SetInside()
		attuneGreenIcon:Hide()
		button.attuneGreenIcon = attuneGreenIcon
	end
end

function Attune:ToggleAttuneIcon(button, itemId)
	Attune:AddAtuneIcon(button)
	if CanAttuneItemHelper(itemId) > 0 and GetItemAttuneProgress(itemId) < 100  then
		button.attuneOrangeIcon:Show()
		button.attuneGreenIcon:Hide()
	elseif CanAttuneItemHelper(itemId) > 0 and GetItemAttuneProgress(itemId) >= 100 then
		button.attuneOrangeIcon:Hide()
		button.attuneGreenIcon:Show()
	else
		button.attuneOrangeIcon:Hide()
		button.attuneGreenIcon:Hide()
	end
end