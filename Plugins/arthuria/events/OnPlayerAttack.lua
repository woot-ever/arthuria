function OnPlayerAttack(player)
	-- PvP (experimental)
	--[[
	if (player and player:GetBoolean("pvp") == true) then
		local x = player:GetX()
		local y = player:GetY()
		local id = player:GetID()
		for i=1,KAG.GetPlayersCount() do
			local p = KAG.GetPlayerByIndex(i)
			if (p:GetID() ~= id and p:GetBoolean("pvp") == true and math.abs(p:GetX() - x) < 20 and math.abs(p:GetY() - y) < 20) then
				local shield = p:GetNumber("pvp_shield")
				if (p:IsShielding() and shield < 5) then
					shield = shield + 1
					p:SetNumber("pvp_shield", shield)
					if (shield >= 5) then
						p:Send("Your shield broke!")
					end
				else
					local hp = p:GetHealth() - 0.25
					p:SetHealth(hp)
					if (hp <= 0) then
						p:SetNumber("temp_respawn_x", ZOMBIE_CONFIG.pvp.respawnX)
						p:SetNumber("temp_respawn_y", ZOMBIE_CONFIG.pvp.respawnY)
						p:SetBoolean("kill_on_respawn", false)
						p:SetBoolean("exp_immunity", true)
						p:ForcePosition(0, (KAG.GetMapHeight()*8))
						p:Send("You died in the PvP arena !")
						UpdatePVPRanking(p:GetName(), 0, 1)
						
						player:Send("You've killed " .. p:GetName() .. " in the PvP arena !")
						player:SetHealth(ZOMBIE_CONFIG.pvp.health)
						player:SetNumber("pvp_shield", 0)
						UpdatePVPRanking(player:GetName(), 1, 0)
					end
				end
			end
		end
	end
	]]--
	
	return 1
end