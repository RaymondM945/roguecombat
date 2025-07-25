local isFollowing = nil
local stopaddon = false

local MyCheckbox = CreateFrame("CheckButton", "MyCheckboxExample", UIParent, "UICheckButtonTemplate")
MyCheckbox:SetSize(30, 30)

-- Anchor to the top center of the screen
MyCheckbox:SetPoint("TOP", UIParent, "TOP", 0, -20) -- 20 pixels down from the top

MyCheckbox.text = MyCheckbox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
MyCheckbox.text:SetPoint("LEFT", MyCheckbox, "RIGHT", 5, 0)
MyCheckbox.text:SetText("stop addon")

MyCheckbox:SetChecked(stopaddon)

MyCheckbox:SetScript("OnClick", function(self)
	if self:GetChecked() then
		print("Checkbox is checked!")
		stopaddon = true
	else
		print("Checkbox is unchecked!")
		stopaddon = false
	end
end)

local box = CreateFrame("Frame", "CombatRogueCenterBox", UIParent)
box:SetSize(25, 25)
box:SetPoint("CENTER", UIParent, "CENTER")
box.texture = box:CreateTexture(nil, "BACKGROUND")
box.texture:SetAllPoints()
box.texture:SetColorTexture(0, 0, 0, 1)

box:SetScript("OnUpdate", function(self, elapsed)
	box.texture:SetColorTexture(0, 0, 0, 1)
	if IsInGroup() and not stopaddon then
		local targethealth = UnitHealth("party1target")
		local targetmaxHealth = UnitHealthMax("party1target")
		local hpPercent = (targethealth / targetmaxHealth) * 100
		if UnitAffectingCombat("party1") and hpPercent < 95 then
			box.texture:SetColorTexture(1, 1, 0, 1)
			local energy = UnitPower("player", 3)
			local comboPoints = GetComboPoints("player", "target")
			local sametarget = UnitIsUnit("target", "party1target")

			local SinisterStrike = GetSpellInfo(1752)
			local SSusable = IsUsableSpell(SinisterStrike)
			local Eviscerate = GetSpellInfo("Eviscerate")
			local isEviscerateUsable = IsUsableSpell(Eviscerate)
			local healthplayer = UnitHealth("player")
			local maxplayerHealth = UnitHealthMax("player")

			local hpPercentplayer = (healthplayer / maxplayerHealth) * 100

			local start, duration, enable = C_Container.GetContainerItemCooldown(0, 1)

			local canusePotion = start == 0 and duration == 0 and enable == 1

			if canusePotion and hpPercentplayer < 90 then
				box.texture:SetColorTexture(0.5, 0.5, 0.5, 1)
			elseif not sametarget then
				box.texture:SetColorTexture(0, 0, 1, 1)
			elseif not isFollowing then
				box.texture:SetColorTexture(1, 1, 1, 1)
			elseif not IsCurrentSpell("Attack") then
				box.texture:SetColorTexture(0, 1, 0, 1)
			elseif comboPoints >= 4 and isEviscerateUsable then
				box.texture:SetColorTexture(1, 0, 1, 1)
			elseif SSusable then
				box.texture:SetColorTexture(1, 0, 0, 1)
			end
		end
	end
end)

box:RegisterEvent("AUTOFOLLOW_BEGIN")
box:RegisterEvent("AUTOFOLLOW_END")

box:SetScript("OnEvent", function(self, event, ...)
	if event == "AUTOFOLLOW_BEGIN" then
		local name = ...
		isFollowing = name
		print("Now following: " .. (name or "unknown"))
	elseif event == "AUTOFOLLOW_END" then
		isFollowing = nil
		print("Stopped following")
	end
end)
