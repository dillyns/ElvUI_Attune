local E, L, V, P, G = unpack(ElvUI);
local B = E:GetModule("Bags")

local SynastriaCoreLib = LibStub('SynastriaCoreLib-1.0')

Attune = {}

function Attune:AddAtuneIcon(slot)
	if not slot.AttuneTextureBorder then
		local AttuneTextureBorder = slot:CreateTexture(nil, "ARTWORK")
		AttuneTextureBorder:SetTexture(E.Media.Textures.AttuneIconWhite)
		AttuneTextureBorder:SetVertexColor(0, 0, 0)
		AttuneTextureBorder:Hide()
		slot.AttuneTextureBorder = AttuneTextureBorder
	end

	if not slot.AttuneTexture then
		local AttuneTexture = slot:CreateTexture(nil, "OVERLAY")
		AttuneTexture:SetTexture(E.Media.Textures.AttuneIconWhite)
		AttuneTexture:Hide()
		slot.AttuneTexture = AttuneTexture
	end
end


function Attune:ToggleAttuneIcon(slot, itemIdOrLink, additionalXMargin)
	Attune:UpdateItemLevelText(slot, itemIdOrLink)
	Attune:AddAtuneIcon(slot)
	slot.AttuneTexture:Hide()
	slot.AttuneTextureBorder:Hide()
	if not SynastriaCoreLib.isLoaded() or not E.db.bags.attuneProgress or not itemIdOrLink then
		return
	end
	if SynastriaCoreLib.CheckItemValid(itemIdOrLink) == 0 then
		return
	end

	local xMargin = 2
	if additionalXMargin then xMargin = xMargin + additionalXMargin end
	local yMargin = 2
	local borderWidth = 1
	local maxHeight = slot:GetHeight() - (yMargin * 2 + borderWidth * 2)
	local minHeight = maxHeight * 0.2
	local width = 8 - borderWidth * 2

	slot.AttuneTextureBorder:SetPoint("BOTTOMLEFT", xMargin, yMargin)
	slot.AttuneTextureBorder:SetWidth(width + borderWidth * 2)
	slot.AttuneTexture:SetPoint("BOTTOMLEFT", xMargin + borderWidth, yMargin + borderWidth)
	slot.AttuneTexture:SetWidth(width)

	if SynastriaCoreLib.CheckItemValid(itemIdOrLink) == -2 then
		slot.AttuneTextureBorder:SetHeight(minHeight + borderWidth*2)
		slot.AttuneTexture:SetHeight(minHeight)
		slot.AttuneTexture:SetVertexColor(0.74, 0.02, 0.02)
		slot.AttuneTextureBorder:Show()
		slot.AttuneTexture:Show()
	elseif SynastriaCoreLib.CheckItemValid(itemIdOrLink) == 1 then
		local progress = SynastriaCoreLib.GetAttuneProgress(itemIdOrLink)
		if progress < 100 then
			local height = math.max(maxHeight * (progress/100), minHeight)
			slot.AttuneTextureBorder:SetHeight(height + borderWidth*2)
			slot.AttuneTexture:SetHeight(height)
			slot.AttuneTexture:SetVertexColor(0.96, 0.63, 0.02)
		else
			slot.AttuneTextureBorder:SetHeight(maxHeight + borderWidth*2)
			slot.AttuneTexture:SetHeight(maxHeight)
			if not E.db.bags.alternateProgressAttuneColor then
				slot.AttuneTexture:SetVertexColor(0, 0.64, 0.05)
			else
				slot.AttuneTexture:SetVertexColor(0.39, 0.56, 1)
			end
		end
		slot.AttuneTextureBorder:Show()
		slot.AttuneTexture:Show()
	end
end

function Attune:UpdateItemLevelText(slot, itemIdOrLink)
	if not slot.itemLevel then
		slot.itemLevel = slot:CreateFontString(nil, "OVERLAY")
		slot.itemLevel:Point("BOTTOMRIGHT", -1, 3)
		slot.itemLevel:FontTemplate(E.Libs.LSM:Fetch("font", E.db.bags.itemLevelFont), E.db.bags.itemLevelFontSize,
			E.db.bags.itemLevelFontOutline)
	end
	slot.itemLevel:SetText("")

	if itemIdOrLink then
		local _, _, itemRarity, iLvl, _, _, _, _, itemEquipLoc, _, _ = GetItemInfo(itemIdOrLink)
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