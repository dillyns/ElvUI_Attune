local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule("Bags")

Attune = {}


function Attune:AddAtuneIcon(slot)
	if not slot.attuneOrangeIcon then
		local attuneOrangeIcon = slot:CreateTexture(nil, "OVERLAY")
		attuneOrangeIcon:SetTexture(E.Media.Textures.AttuneOrangeIcon)
		attuneOrangeIcon:SetTexCoord(0, 1, 0, 1)
		attuneOrangeIcon:SetInside()
		attuneOrangeIcon:Hide()
		slot.attuneOrangeIcon = attuneOrangeIcon
	end

	if not slot.attuneGreenIcon then
		local attuneGreenIcon = slot:CreateTexture(nil, "OVERLAY")
		attuneGreenIcon:SetTexture(E.Media.Textures.AttuneGreenIcon)
		attuneGreenIcon:SetTexCoord(0, 1, 0, 1)
		attuneGreenIcon:SetInside()
		attuneGreenIcon:Hide()
		slot.attuneGreenIcon = attuneGreenIcon
	end
end

function Attune:ToggleAttuneIcon(slot, itemId)
	Attune:AddAtuneIcon(slot)
	if CanAttuneItemHelper(itemId) > 0 and GetItemAttuneProgress(itemId) < 100  then
		slot.attuneOrangeIcon:Show()
		slot.attuneGreenIcon:Hide()
	elseif CanAttuneItemHelper(itemId) > 0 and GetItemAttuneProgress(itemId) >= 100 then
		slot.attuneOrangeIcon:Hide()
		slot.attuneGreenIcon:Show()
	else
		slot.attuneOrangeIcon:Hide()
		slot.attuneGreenIcon:Hide()
	end
	Attune:UpdateItemLevelText(slot, itemId)
end

function Attune:UpdateItemLevelText(slot, itemId)
	if not slot.itemLevel then
		slot.itemLevel = slot:CreateFontString(nil, "OVERLAY")
		slot.itemLevel:Point("BOTTOMRIGHT", -1, 3)
		slot.itemLevel:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize, E.db.bags.itemLevelFontOutline)
	end
	slot.itemLevel:SetText("")

	if itemId and itemId ~= 0 then
		local _, _, itemRarity, iLvl, _, _, _, _, itemEquipLoc, _, _ = GetItemInfo(itemId)
		if iLvl and B.db.itemLevel and (itemEquipLoc ~= nil and itemEquipLoc ~= "" and itemEquipLoc ~= "INVTYPE_AMMO" and itemEquipLoc ~= "INVTYPE_BAG" and itemEquipLoc ~= "INVTYPE_QUIVER" and itemEquipLoc ~= "INVTYPE_TABARD") and (itemRarity and itemRarity > 1) and iLvl >= B.db.itemLevelThreshold then
			slot.itemLevel:SetText(iLvl)
			if B.db.itemLevelCustomColorEnable then
				slot.itemLevel:SetTextColor(B.db.itemLevelCustomColor.r, B.db.itemLevelCustomColor.g, B.db.itemLevelCustomColor.b)
			else
				slot.itemLevel:SetTextColor(GetItemQualityColor(itemRarity))
			end
		end
	end

end
