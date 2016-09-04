function OnPlayerInit(player)
	utils_OnPlayerInit(player)
	player:SetBoolean("kill_on_respawn", false)
	player:SetBoolean("exp_immunity", false)
	player:SetBoolean("pvp", false)
	player:SetNumber("pvp_shield", 0)
	player:SetBoolean("dojoing", false)
	player:SetNumber("temp_respawn_x", -1)
	player:SetNumber("temp_respawn_y", -1)
	player:SetNumber("temp_health", -1)
	if (player:IsPlaying()) then
		LoadPlayer(player)
		ApplyAllUpgrades(player)
	end
	player:SetNumber("stalking", 0)
	player:SetNumber("editor_block", -1)
	
	if (player:GetTeam() ~= 0 and player:GetBoolean("pvp") == false) then
		KAG.SendRcon("/swapid " .. player:GetID())
		return
	end
end
