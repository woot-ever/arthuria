function OnPlayerLeave(player)
	SavePlayer(player)
	
	-- Reset resources to prevent drops
	player:SetStone(0)
	player:SetWood(0)
	player:SetGold(0)
	player:SetArrows(0)
	player:SetBombs(0)
	player:SetCoins(0)
	
	local party = GetPartyByPlayer(player)
	if (party) then
		local partyPlayerId = table.indexOf(party.players, player:GetID())
		if (partyPlayerId > -1) then
			table.remove(party.players, partyPlayerId, 1)
		end
		
		if (#party.players == 0) then
			-- Dismantle the party
			for k,v in pairs(PARTIES) do
				if (v.id == party.id) then
					table.remove(PARTIES, k, 1)
					break
				end
			end
		else
			for k,v in pairs(party.players) do
				local p = KAG.GetPlayerByID(v)
				if (p) then
					p:Send(player:GetName() .. " has left the party!")
					ApplyAllUpgrades(p)
				end
			end
			PartyChangeLeader(party)
		end
		PartyUpdate(party)
	end
end
