local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule("Bags")

Attune = {}


function Attune:AddAtuneIcon(slot)
	if not slot.AttunableIcon then
		local AttunableIcon = slot:CreateTexture(nil, "OVERLAY")
		AttunableIcon:SetTexture(E.Media.Textures.AttunableIcon)
		AttunableIcon:SetTexCoord(0, 1, 0, 1)
		AttunableIcon:SetInside()
		AttunableIcon:Hide()
		slot.AttunableIcon = AttunableIcon
	end

	if not slot.AttunedIcon then
		local AttunedIcon = slot:CreateTexture(nil, "OVERLAY")
		AttunedIcon:SetTexture(E.Media.Textures.AttunedIcon)
		AttunedIcon:SetTexCoord(0, 1, 0, 1)
		AttunedIcon:SetInside()
		AttunedIcon:Hide()
		slot.AttunedIcon = AttunedIcon
	end
end

function Attune:ToggleAttuneIcon(slot, itemId)
	Attune:AddAtuneIcon(slot)

	local progress = GetItemAttuneProgress(itemId)
	local progressIndex = math.floor(progress / 2.5)

	slot.AttunableIcon:Hide()
	slot.AttunedIcon:Hide()

	if Attune:CheckItemValid(itemId) == -2 and itemId ~= 0 then
		slot.AttunableIcon:SetTexture(E.Media.Textures["AttunableIcon"])
		slot.AttunableIcon:Show()
	end

	if Attune:CheckItemValid(itemId) == 0 and itemId ~= 0 then
		slot.AttunableIcon:Hide()
	end

	if Attune:CheckItemValid(itemId) == 1 and itemId ~= 0 then
		if progress < 100 then
			slot.AttunableIcon:SetTexture(E.Media.Textures["AttunableIcon_" .. progressIndex])
			slot.AttunableIcon:Show()
		else
			slot.AttunableIcon:Hide()
			slot.AttunedIcon:Show()
		end
	end
	Attune:UpdateItemLevelText(slot, itemId)
end

function Attune:CheckItemValid(itemId)
	if type(itemId) ~= "number" then return 0 end
	return CanAttuneItemHelper(itemId)
end

function Attune:UpdateItemLevelText(slot, itemId)
	if not slot.itemLevel then
		slot.itemLevel = slot:CreateFontString(nil, "OVERLAY")
		slot.itemLevel:Point("BOTTOMRIGHT", -1, 3)
		slot.itemLevel:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize,
			E.db.bags.itemLevelFontOutline)
	end
	slot.itemLevel:SetText("")

	if itemId and itemId ~= 0 then
		local _, _, itemRarity, iLvl, _, _, _, _, itemEquipLoc, _, _ = GetItemInfo(itemId)
		if iLvl and B.db.itemLevel and (itemEquipLoc ~= nil and itemEquipLoc ~= "" and itemEquipLoc ~= "INVTYPE_AMMO" and itemEquipLoc ~= "INVTYPE_BAG" and itemEquipLoc ~= "INVTYPE_QUIVER" and itemEquipLoc ~= "INVTYPE_TABARD") and (itemRarity and itemRarity > 1) and iLvl >= B.db.itemLevelThreshold then
			slot.itemLevel:SetText(iLvl)
			if B.db.itemLevelCustomColorEnable then
				slot.itemLevel:SetTextColor(B.db.itemLevelCustomColor.r, B.db.itemLevelCustomColor.g, B.db.itemLevelCustomColor
					.b)
			else
				slot.itemLevel:SetTextColor(GetItemQualityColor(itemRarity))
			end
		end
	end
end