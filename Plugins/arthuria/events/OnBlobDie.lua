function OnBlobDie(blob)
	if (not blob or blob:GetTeam() == 0) then return end
	local e = ENTITIES[blob:GetID()]
	if (ZOMBIE_COMBAT[blob:GetID()]) then
		-- Remove zombie combat for this blob
		if (e) then
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
			
			local totalExp = 0
			local _exp = e.exp or e.type.exp or nil
			if (type(_exp) == "table") then
				totalExp = math.random(_exp.min, _exp.max)
			elseif (type(_exp) == "number") then
				totalExp = _exp
			end
			
			local totalCoins = 0
			local _coins = e.coins or e.type.coins or nil
			if (type(_coins) == "table") then
				totalCoins = math.random(_coins.min, _coins.max)
			elseif (type(_coins) == "number") then
				totalCoins = _coins
			end
			
			for k,v in pairs(sortedActors) do
				local p = KAG.GetPlayerByID(v.p)
				if (p) then
					
					-------------
						if (totalExp > 0) then
							-- Party exp
							-- EXP received when in party = TotalEXP * (0.6 * damage dealt/monster's HP + 0.4 * lvl/party lvl) * Party Bonus
							local party = GetPartyByPlayer(p)
							local partyLevel = p:GetNumber("level")
							local partyBonus = 1.0
							if (party) then
								partyLevel = party.level
								if (#party.players > 1) then
									partyBonus = (((#party.players/20)*100)+100)/100
								end
							end
							
							local receivedExp = 0
							--[[
							if (party) then
								receivedExp = totalExp * (0.6 * v.d / (e.health or e.type.health)) + (0.4 * p:GetNumber("level") / partyLevel)
								totalExp = totalExp - receivedExp
								if (firstPlayer) then
									receivedExp = receivedExp + (0.6 * totalExp)
								end
								receivedExp = receivedExp * partyBonus
							
								local leechExp = (0.4 * totalExp) * partyBonus
								for k,v in pairs(party.players) do
									local pLeecher = KAG.GetPlayerByID(v)
									if (pLeecher) then
										if (v == p:GetID()) then
											GiveExperience(pLeecher, math.floor(receivedExp))
										else
											GiveExperience(pLeecher, math.floor(leechExp))
										end
									end
								end
							else
								receivedExp = math.floor((v.d / (e.health or e.type.health)) * totalExp)
								GiveExperience(p, receivedExp)
							end
							]]--
							receivedExp = math.floor((v.d / (e.health or e.type.health)) * totalExp)
							GiveExperience(p, receivedExp)
						end
					-------------
					
					-------------
						if (totalCoins > 0) then
							-- Party coins
							-- Coins received when in party = TotalCoins * (0.6 * damage dealt/monster's HP + 0.4 * lvl/party lvl) * Party Bonus
							local party = GetPartyByPlayer(p)
							local partyLevel = p:GetNumber("level")
							local partyBonus = 1.0
							if (party) then
								partyLevel = party.level
								if (#party.players > 1) then
									partyBonus = (((#party.players/20)*100)+100)/100
								end
							end
							
							local receivedCoins = 0
							--[[
							if (party) then
								receivedCoins = totalCoins * (0.6 * v.d / (e.health or e.type.health)) + (0.4 * p:GetNumber("level") / partyLevel)
								totalCoins = totalCoins - receivedCoins
								if (firstPlayer) then
									receivedCoins = receivedCoins + (0.6 * totalCoins)
								end
								receivedCoins = receivedCoins * partyBonus
							
								local leechExp = (0.4 * totalCoins) * partyBonus
								for k,v in pairs(party.players) do
									local pLeecher = KAG.GetPlayerByID(v)
									if (pLeecher) then
										if (v == p:GetID()) then
											GiveCoins(pLeecher, math.floor(receivedCoins))
										else
											GiveCoins(pLeecher, math.floor(leechExp))
										end
									end
								end
							else
								receivedCoins = math.floor((v.d / (e.health or e.type.health)) * totalCoins)
								GiveCoins(p, receivedCoins)
							end
							]]--
							receivedCoins = math.floor((v.d / (e.health or e.type.health)) * totalCoins)
							GiveCoins(p, receivedCoins)
						end
					-------------
					
					if (firstPlayer) then
						firstPlayer = false
					end
				end
			end
		end
		ZOMBIE_COMBAT[blob:GetID()] = nil
	end
	
	if (e) then
		--[[
		if (not e.despawn) then
			if (type(e.type.onDie) == "function") then e.type.onDie(e) end
			if (type(e.onDie) == "function") then e.onDie(e) end
		end
		]]--
		if (not (e.unique or e.type.unique)) then
			SpawnEntity({ entity = e, at = os.time() + (e._time or e.time or e.type.time or ZOMBIE_CONFIG.respawnTime) })
		end
		ENTITIES[blob:GetID()] = nil
		ENTITIES_MAPPING[e.entityId] = nil
	end
end
