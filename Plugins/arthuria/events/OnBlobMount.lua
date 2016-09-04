function OnBlobMount(blob, player)
	if (not blob or not player) then return 1 end
	if (blob:GetConfigFileName() == "Entities/Items/LootBag.cfg") then
		local id = blob:GetID()
		if (ENTITIES[id]) then
			local e = ENTITIES[id]
			local ownerParty = GetPartyByPlayer(e.config.owner)
			local playerParty = GetPartyByPlayer(player)
			local sameParty = (ownerParty and playerParty and ownerParty.id == playerParty.id)
			if (e.config.owner == player:GetID() or sameParty or os.time() >= e.config.time + 60) then
				local loots = e.config.loots or {}
				for kLoot,vLoot in pairs(loots) do
					InventoryAdd(player, GetItemByID(vLoot.id), vLoot.q)
				end
				blob:Kill()
			else
				player:SendMessage("This loot bag doesn't belong to you! You can pick it up in " .. (e.config.time + 60 - os.time()) .. " seconds")
			end
		end
	end
	return 0
end
