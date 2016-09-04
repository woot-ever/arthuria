local json = require ("dkjson")

function OnBlobHit(blob, attacker, damage)
	if (not blob or not attacker) then return damage end
	if (blob:GetType() == 17) then return 0 end -- 17 = room
	local player = attacker:GetPlayer()
	if (not player) then return 0 end
	local id = blob:GetID()
	if (not ZOMBIE_COMBAT[id]) then
		ZOMBIE_COMBAT[id] = {}
	end
	if (not ENTITIES[id]) then return 0 end
	local e = ENTITIES[id]
	if (e.invicible or e.type.invicible) then return 0 end
	
	-- Botting?
	local bottingCount = player:GetNumber("botting_count")
	local bottingX = player:GetNumber("botting_x")
	local px = math.floor(player:GetX())
	if (px == bottingX) then
		bottingCount = bottingCount + 1
	else
		bottingCount = 0
	end
	player:SetNumber("botting_count", bottingCount)
	player:SetNumber("botting_x", px)
	if (bottingCount > 100) then
		return 0
	end
	
	-- Calculate damage
	local actualDamage = 0
	local playerLevel = player:GetNumber("level")
	local monsterLevel = (e.level or e.type.level or 1)
	local calculatedDamage = CalculatePlayerDamage(player, damage)
	if (monsterLevel - playerLevel <= 6) then
		actualDamage = math.min(calculatedDamage, e.currentHealth)
	end
	
	-- Miss?
	if (actualDamage == 0) then
		player:Send("Missed <[" .. (e.level or e.type.level) .. "] " .. e.type.name .. ">, you're too weak!")
		return 0
	end
	table.insert(ZOMBIE_COMBAT[id], { p = player:GetID(), d = actualDamage})
	if (type(e.type.onHit) == "function") then e.type.onHit(e, player, actualDamage) end
	if (type(e.onHit) == "function") then e.onHit(e, player, actualDamage) end
	-- Reset zombie fake health to prevent him from dying because of a player hit
	-- Decrease real health
	e.currentHealth = e.currentHealth - actualDamage or 0
	local msg = "Hit <[" .. (e.level or e.type.level) .. "] " .. e.type.name .. "> for " .. calculatedDamage .. " damage!"
	if ((e.healthVisible or e.type.healthVisible) and e.currentHealth > 0) then
		msg = msg .. " (" .. e.currentHealth .. " left)"
	end
	player:Send(msg)
	if (e.currentHealth <= 0) then
		-- No more health, he sould die
		blob:SetHealth(0)
		
		if (not e.despawn) then
			if (type(e.type.onDie) == "function") then e.type.onDie(e, player) end
			if (type(e.onDie) == "function") then e.onDie(e, player) end
			
			local actions = ZOMBIE_COMBAT[blob:GetID()]
			local actors = {}
			local totalDamage = 0
			for k,v in pairs(actions) do
				actors[v.p] = (actors[v.p] or 0) + v.d
				totalDamage = totalDamage + v.d
			end
			local sortedActors = {}
			for k,v in pairs(actors) do
				sortedActors[#sortedActors+1] = { p = k, d = v }
			end
			table.sort(sortedActors, function(a, b) return a.d > b.d end)
			
			local firstPlayer = true
			
			for k,v in pairs(sortedActors) do
				local p = KAG.GetPlayerByID(v.p)
				if (p) then
					-- Drops
					if (firstPlayer or (e.sharedLoots or e.type.sharedLoots)) then
						firstPlayer = false
						
						local possibleDrops = table.merge((e.drops or {}), (e.type.drops or {}))
						print(json.encode(possibleDrops, { indent = false }))
						
						local drops = {}
						local dropsCount = 0
						for kDrops,vDrops in pairs(possibleDrops) do
							local rnd = math.random()
							print("rnd="..rnd..", vDrops.chances="..(vDrops.chances or 1))
							if (rnd <= (vDrops.chances or 1)) then
								print("add " .. vDrops.id .. " to drops")
								drops[dropsCount - 1] = { id = vDrops.id, q = vDrops.quantity or 1 }
								dropsCount = dropsCount + 1
							end
						end
						print("dropsCount="..dropsCount)
						if (dropsCount > 0) then
							if (e.sharedLoots or e.type.sharedLoots) then
								for kLoot,vLoot in pairs(drops) do
									InventoryAdd(p, GetItemByID(vLoot.id), vLoot.q)
								end
							end
							SpawnEntity({ entity = {
								x = math.floor(blob:GetX() / 8),
								y = math.floor(blob:GetY() / 8),
								type = ZOMBIE_CONFIG.types.LOOT_BAG,
								config = {
									owner = p:GetID(),
									loots = drops,
									time = os.time()
								}
							}, at = os.time()-1 })
						end
					end
				end
			end
		end
		return 1 -- enough damage to kill him
	end
	return 0.1 -- enough damage to stun him and drop some blood
end
