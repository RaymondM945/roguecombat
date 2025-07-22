local isFollowing = nil

local box = CreateFrame("Frame", "CombatRogueCenterBox", UIParent)
box:SetSize(25, 25)
box:SetPoint("CENTER", UIParent, "CENTER")
box.texture = box:CreateTexture(nil, "BACKGROUND")
box.texture:SetAllPoints()
box.texture:SetColorTexture(0, 0, 0, 1)

box:SetScript("OnUpdate", function(self, elapsed)
	box.texture:SetColorTexture(0, 0, 0, 1)
	if IsInGroup() then
		local targethealth = UnitHealth("target")
		local targetmaxHealth = UnitHealthMax("target")
		local hpPercent = (targethealth / targetmaxHealth) * 100
		local energy = UnitPower("player", 3)
		local comboPoints = GetComboPoints("player", "target")
		local sametarget = UnitIsUnit("target", "party1target")

		if UnitAffectingCombat("party1") and hpPercent < 90 then
			box.texture:SetColorTexture(1, 1, 0, 1)
			local SinisterStrike = GetSpellInfo(1752)
			local SSusable = IsUsableSpell(SinisterStrike)
			local Eviscerate = GetSpellInfo("Eviscerate")
			local isEviscerateUsable = IsUsableSpell(Eviscerate)

			if not sametarget then
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
