function OnPlayerBuild(player, x, y, block)
	local tile = KAG.GetTile(x, y)
	local ret = 0
	
	-- TODO: add coord to config
	if (x == 1274*8 and y == 36*8) then
		player:SetBoolean("pvp", true)
		KAG.SendRcon("/swapid " .. player:GetID())
		--[[
		player:ForcePosition(ZOMBIE_CONFIG.pvp.x * 8, ZOMBIE_CONFIG.pvp.y * 8)
		player:SetBoolean("kill_on_respawn", false)
		player:SetBoolean("exp_immunity", true)
		player:SetHealth(ZOMBIE_CONFIG.pvp.health)
		]]--
	elseif (x == 1311*8 and y == 36*8) then
		player:SetBoolean("pvp", true)
		KAG.SendRcon("/swapid " .. player:GetID())
		KAG.SendRcon("/swapid " .. player:GetID())
	elseif ((x == 1310*8 and y == 32*8) or (x == 1275*8 and y == 32*8)) then
		player:SetBoolean("pvp", false)
		player:ForcePosition(0, (KAG.GetMapHeight()*8))
		player:SetBoolean("kill_on_respawn", false)
		player:SetBoolean("exp_immunity", true)
	end
	
	return ret
end
