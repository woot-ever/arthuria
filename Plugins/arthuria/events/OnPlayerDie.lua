function OnPlayerDie(player, killer, reason)
	print("Death reason: " .. reason)
	
	-- Exp loss
	if (player:GetBoolean("exp_immunity") == false) then
		local currentExp = player:GetNumber("experience")
		local totalExp = CalculateExperience(player)
		local expLoss = math.floor((totalExp*5)/100)
		GiveExperience(player, -expLoss)
	else
		player:SetBoolean("exp_immunity", false)
	end
end
