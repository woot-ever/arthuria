function OnPlayerRespawn(player)
	local pvp = player:GetBoolean("pvp")
	if ((player:GetTeam() ~= 0 and pvp == false) or (player:GetTeam() == 0 and pvp == true)) then
		KAG.SendRcon("/swapid " .. player:GetID())
		return
	end
	
	if (player:GetBoolean("kill_on_respawn") == true) then
		player:SetBoolean("kill_on_respawn", false)
		player:SetHead(player:GetNumber("head"))
		player:ForcePosition(0, (KAG.GetMapHeight()*8))
		player:SetBoolean("exp_immunity", true)
		return
	end
	player:SetClass(player:GetNumber("class"))
	ApplyAllUpgrades(player)
	player:SetGold(math.floor((player:GetNumber("experience") / CalculateExperience(player)) * 100))
	
	local tempX = player:GetNumber("temp_respawn_x")
	if (tempX ~= -1) then
		local tempY = player:GetNumber("temp_respawn_y")
		player:SetNumber("temp_respawn_x", -1)
		player:SetNumber("temp_respawn_y", -1)
		player:ForcePosition(tempX*8, tempY*8)
	else
		player:ForcePosition(player:GetNumber("respawn_x")*8, player:GetNumber("respawn_y")*8)
	end
	
	local tempHealth = player:GetNumber("temp_health")
	if (tempHealth ~= -1) then
		player:SetHealth(tempHealth)
		player:SetNumber("temp_health", -1)
	end
	
	if (pvp == true) then
		local spawn = ZOMBIE_CONFIG.pvp.spawns[math.random(#ZOMBIE_CONFIG.pvp.spawns)]
		player:ForcePosition(spawn.x * 8, spawn.y * 8)
		player:SetBoolean("kill_on_respawn", false)
		player:SetBoolean("exp_immunity", true)
		player:SetHealth(ZOMBIE_CONFIG.pvp.health)
	end
	
	player:SetBoolean("dojoing", false)
end
