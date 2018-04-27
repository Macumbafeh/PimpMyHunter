-- Main Frame
local PMHFrame = CreateFrame("Frame", "PMHFrame", UIParent)
PMHFrame:SetPoint("CENTER")
PMHFrame:SetWidth(60)
PMHFrame:SetHeight(30)

-- Main Frame Background
local PMHFrameBackground = PMHFrame:CreateTexture(nil, "BACKGROUND")
PMHFrameBackground:SetAllPoints()
PMHFrameBackground:SetTexture(0, 0, 0, 0.5)
PMHFrameBackground:SetWidth(60)
PMHFrameBackground:SetHeight(30)

-- Main Frame Font
local PMHFrameFont = PMHFrame:CreateFontString("PMHFrameFont", "ARTWORK", "GameFontNormal")
PMHFrameFont:SetAllPoints()
PMHFrameFont:SetFont("Fonts\\FRIZQT__.TTF", 16)
PMHFrameFont:SetJustifyH("CENTER")
PMHFrameFont:SetText(UnitRangedDamage("player"))

-- Movable Main Frame
PMHFrame:SetMovable(true)
PMHFrame:EnableMouse(true)
PMHFrame:RegisterForDrag("LeftButton")
PMHFrame:SetScript("OnDragStart", function() PMHFrame:StartMoving() end)
PMHFrame:SetScript("OnDragStop", function() PMHFrame:StopMovingOrSizing() end)


-- OnEvent Script
local PreAuraTable = {}
local PostAuraTable = {}
local PostDurTable = {}
local PMHEventFrame = CreateFrame("Frame")
PMHEventFrame:RegisterEvent("UNIT_AURA")
PMHEventFrame:RegisterEvent("UNIT_RANGEDDAMAGE")
PMHEventFrame:RegisterEvent("PLAYER_LOGIN")
PMHEventFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		PMHFrameFont:SetText(UnitRangedDamage("player"))
		PMHEventFrame:UnregisterEvent("PLAYER_LOGIN")
		for i=1,40 do
			if select(1, UnitBuff("player", i)) ~= nil then
				local _, _, spellIcon = UnitBuff("player", i)
				PostAuraTable[i] = strsub(spellIcon, 17)
			else
				break
			end
		end
	end
	if event == "UNIT_RANGEDDAMAGE"	then
		PMHFrameFont:SetText(UnitRangedDamage("player"))
		PMHEventFrame:UnregisterEvent("UNIT_RANGEDDAMAGE")
	end
	if event == "UNIT_AURA" and arg1 == "player" then
		PreAuraTable = PostAuraTable
		PostAuraTable = {}
		for i=1,40 do
			if select(1, UnitBuff("player", i)) ~= nil then
				local _, _, spellIcon, _, _, spellDur = UnitBuff("player", i)
				PostAuraTable[i] = strsub(spellIcon, 17)
				if spellDur ~= nil then
					PostDurTable[i] = spellDur
				end
			else
				break
			end
		end
		if #PostAuraTable > #PreAuraTable then
			for j=1,#PostAuraTable do
				if PostAuraTable[j] ~= PreAuraTable[j] and tonumber(PMHFrameFont:GetText()) ~= UnitRangedDamage("player") then
					PMHFrameFont:SetText(UnitRangedDamage("player"))
					for i=1,10 do
						if _G["PMHFrameTexture"..i] == nil then
							_G["PMHFrameTexture"..i] = PMHFrame:CreateTexture(_G["PMHFrameTexture"..i])
							_G["PMHFrameTexture"..i]:SetTexture("Interface\\Icons\\"..PostAuraTable[j])
							_G["PMHFrameTexture"..i]:SetPoint("TOPLEFT", PMHFrame, 30+30*i, 0)
							_G["PMHFrameTexture"..i]:SetWidth(30)
							_G["PMHFrameTexture"..i]:SetHeight(30)
							_G["PMHFrameTexture"..i]:SetAlpha(0.9)
							_G["PMHFrameFont"..i] = PMHFrame:CreateFontString(_G["PMHFrameFont"..i], "ARTWORK", "GameFontNormal")
							_G["PMHFrameFont"..i]:SetPoint("CENTER", _G["PMHFrameTexture"..i], -1, -25)
							_G["PMHFrameFont"..i]:SetFont("Fonts\\FRIZQT__.TTF", 18)
							_G["PMHFrameFont"..i]:SetJustifyH("CENTER")
							_G["PMHFrameFont"..i]:SetTextColor(1, 0, 0)
							_G["PMHFrameFont"..i]:SetText("")
							_G["PMHFrameHiddenFont"..i] = CreateFrame("Button")
							_G["PMHFrameHiddenFont"..i]:SetText(PostDurTable[j])
							_G["PMHUpdateFrame"..i] = CreateFrame("Frame")
							_G["PMHUpdateFrame"..i]:SetScript("OnUpdate", function(self, elapsed)
								if (_G["PMHFrameHiddenFont"..i]:GetText() - elapsed) > 0 then
									_G["PMHFrameHiddenFont"..i]:SetText(_G["PMHFrameHiddenFont"..i]:GetText() - elapsed)
									_G["PMHFrameFont"..i]:SetText(floor(_G["PMHFrameHiddenFont"..i]:GetText()))
								else
									_G["PMHFrameFont"..i]:SetText("")
									_G["PMHFrameHiddenFont"..i]:SetText("")
									_G["PMHFrameTexture"..i]:SetTexture(x)
									_G["PMHFrameTexture"..i] = nil
									_G["PMHFrameFont"..i] = nil
									_G["PMHUpdateFrame"..i]:SetScript("OnUpdate", nil)
								end
							end)
							break
						end
					end
					break
				end
			end
		end
		PMHFrameFont:SetText(UnitRangedDamage("player"))
	end
end)