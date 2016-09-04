function OnServerTick(ticks)
	utils_OnServerTick(ticks)
	
	for i=1,KAG.GetPlayersCount() do
		HandlePlayer(KAG.GetPlayerByIndex(i), ticks)
	end
	
	if (ticks % 900 == 0) then
		if (#ZOMBIE_TEAM_CHECK_QUEUE > 0) then
			for i=1,#ZOMBIE_TEAM_CHECK_QUEUE do
				local z = KAG.GetBlobByID(table.remove(ZOMBIE_TEAM_CHECK_QUEUE, 1))
				if (z and z:GetTeam() == 0) then
					z:Kill()
				end
			end
		end
	end
	if (ticks % 5 == 0) then
		-- Zombie respawn queue check
		for k,v in pairs(RESPAWN_QUEUE) do
			if (os.time() > v.at and ((v.entity.persistent or v.entity.type.persistent) or PlayersAround(v.entity.x * 8, v.entity.y * 8, 400))) then
				RESPAWN_QUEUE[k] = nil
				local e = v.entity
				if (not e.type) then
					print("Missing type for spawn " .. e.x .. ":" .. e.y)
				else
					KAG.SpawnBlob(e.type.type, e.type.configName, e.x * 8, (e.y * 8), e.team or e.type.team or ZOMBIE_CONFIG.team)
					local newBlob = KAG.GetBlobByIndex(KAG.GetBlobsCount())
					if (newBlob) then
						local health = e.health or e.type.health
						e.despawn = false
						e.config = table.merge(e.config or {}, e.type.config or {})
						e.blob = newBlob
						e.spawnTime = os.time()
						e._time = e.type.time or ZOMBIE_CONFIG.respawnTime
						e.currentHealth = e.health or e.type.health or 0
						e.coins = v.coins or e.type.coins or 0
						e.exp = v.exp or e.type.exp or 0
						--e.drops = v.drops or e.type.drops or {}
						e.id = newBlob:GetID()
						e.entityId = v._entityId
						newBlob:SetHealth(160) -- Give enough health so it can't die from a real hit
						ENTITIES[newBlob:GetID()] = e
						ENTITIES_MAPPING[e.entityId] = newBlob:GetID()
					end
				end
			end
		end
	end
	
	if (ticks % 150 == 0) then
		-- Despawn entities too far away from players
		for k,v in pairs(ENTITIES) do
			local b = KAG.GetBlobByID(k)
			if (b) then
				local bx, by = b:GetX(), b:GetY()
				if (not PlayersAround(bx, by, 800) and by > 0) then -- TODO: weird bug where zombies x:y are reported as 0:0 or 0:-8
					local e = ENTITIES[b:GetID()]
					if (e and not e.persistent and not e.type.persistent) then
						e.time = 2
						e.despawn = true
						b:Kill()
					end
				end
			end
		end
		
		-- Expire party invitations
		--[[
		for k,v in pairs(PARTY_INVITATIONS) do
			if (os.time() - v.time > ZOMBIE_CONFIG.partyExpirationTime) then
				table.remove(PARTY_INVITATIONS, k, 1)
			end
		end
		]]--
	end
	
	-- Auto save
	if (ticks % 9000 == 0) then -- 5 minutes
		for i=1,KAG.GetPlayersCount() do
			SavePlayer(KAG.GetPlayerByIndex(i), true)
		end
		SaveWorld()
		print("Progress saved!")
	end
	
	-- Dojo
	if (ticks % 150 == 0) then
		for k,v in pairs(DOJO.rooms) do
			if (v.player) then
				local p = KAG.GetPlayerByID(v.player)
				if (not p or p:GetBoolean("dojoing") == false) then
					-- Player is gone
					v.player = nil
					v.monster = nil
					v.monsterIndex = 0
					v.level = 0
					if (v.monster) then
						local e = ENTITIES_MAPPING[v.monster]
						if (e) then
							e.time = 2
							e.despawn = true
							local b = KAG.GetBlobByID(e.id)
							if (b) then b:Kill() end
						end
					end
				else
					local px, py = p:GetX(), p:GetY()
					if (px < v.position.x * 8 or px > (v.position.x + v.width) * 8 or py < v.position.y or py > (v.position.y + v.height) * 8) then
						-- Player is outside arena
						v.player = nil
						v.monster = nil
						v.monsterIndex = 0
						v.level = 0
						if (v.monster) then
							local e = ENTITIES_MAPPING[v.monster]
							if (e) then
								e.time = 2
								e.despawn = true
								local b = KAG.GetBlobByID(e.id)
								if (b) then b:Kill() end
							end
						end
					else
						local playerLevel = p:GetNumber("level")
						local shouldSpawn = false
						if (not v.level or v.level == 0) then
							-- Start
							v.level = 1
							v.monsterIndex = 1
							p:Send("First level!")
							shouldSpawn = true
						else
							if (v.monster) then
								local blobId = ENTITIES_MAPPING[v.monster]
								if (not blobId) then
									-- Monster killed
									local nextMonster = DOJO.monsters[v.monsterIndex + 1]
									if (not nextMonster) then
										-- End of dojo
										p:Send("Monster killed! YOU WON!")
										v.player = nil
										v.monster = nil
										v.level = 0
										p:ForcePosition(DOJO.x * 8, DOJO.y * 8)
									else
										v.level = v.level + 1
										v.monsterIndex = v.monsterIndex + 1
										p:Send("Monster killed! Next level: " .. v.level)
										shouldSpawn = true
									end
								end
							end
						end
						
						if (shouldSpawn) then
							local nextMonster = DOJO.monsters[v.monsterIndex]
							v.monster = SpawnEntity({ entity = {
								x = math.floor(v.position.x + v.width / 2),
								y = math.floor(v.position.y + v.height / 2),
								type = nextMonster.type,
								unique = true,
								persistent = true,
								level = 1,
								health = math.floor(v.level * ((playerLevel + 1) * 100) + (playerLevel + 1) * 10),
								drops = {},
								coins = 0,
								exp = (playerLevel * v.level) * 5,
								healthVisible = true,
								sharedLoots = true
							}, at = os.time()-1 })
						end
					end
				end
			end
		end
	end
	
	_PLAYERS_POSITIONS = nil
end