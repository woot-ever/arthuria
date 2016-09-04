require("stringutils")
local json = require ("dkjson")

function cmd_Teleport(player, message)
	if (not player:HasFeature("teleport")) then
		player:Send("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (not args[2]) then return end
	local targets = {}
	local teleportToPosition = false
	if (string.lower(args[2]) == "@all") then
		if (not player:HasFeature("teleport_all")) then
			player:Send("You're not allowed to use @all for this command")
			return
		end
		for i=1,KAG.GetPlayersCount() do
			local p = KAG.GetPlayerByIndex(i)
			if (p:GetID() ~= player:GetID()) then
				table.insert(targets, p:GetID())
			end
		end
	elseif (string.lower(args[2]) == "@me") then
		table.insert(targets, player:GetID())
	elseif (string.find(args[2], ":")) then
		teleportToPosition = true
	else
		local ps = KAG.GetPlayersByPartialName(args[2])
		if (#ps == 0) then
			player:Send("Target not found")
			return
		else
			for i=1, #ps do
				if (not ps[i]:IsDead()) then
					table.insert(targets, ps[i]:GetID())
				end
			end
		end
	end
	if (teleportToPosition) then
		local pos = string.split(args[2], ":")
		player:ForcePosition(pos[1]*8, pos[2]*8)
		return
	end
	if (#targets == 0) then
		player:Send("No targets to teleport")
		return
	end
	-- Check for a second target
	local t2 = nil
	if (args[3]) then
		if (not player:HasFeature("teleport_target")) then
			player:Send("You're not allowed to teleport another target other than yourself")
			return
		end
		if (string.lower(args[3]) == "@me") then
			t2 = player
		elseif (string.lower(args[3]) == "@all") then
			player:Send("Invalid second target: @all")
		else
			if (string.find(args[3], ":")) then
				teleportToPosition = true
			else
				t2 = KAG.GetPlayerByPartialName(args[3])
			end
		end
		-- Check if second target exists
		if (not teleportToPosition and t2 == nil) then
			player:Send("Second target not found")
			return
		end
		-- Check if second target is alive
		if (not teleportToPosition and t2:IsDead()) then
			player:Send("Second target is dead")
			return
		end
	end
	for i=1, #targets do
		local target = KAG.GetPlayerByID(targets[i])
		if (target ~= nil) then
			if (teleportToPosition) then
				local pos = string.split(args[3], ":")
				target:ForcePosition(pos[1]*8, pos[2]*8)
			elseif (t2 ~= nil) then
				target:ForcePosition(t2:GetX(), t2:GetY())
			else
				-- No second target, teleport to the first target
				-- (it's actually an array of targets because of GetPlayersByPartialName, but we teleport to the first occurrence)
				player:ForcePosition(target:GetX(), target:GetY())
				break
			end
		end
	end
end

function cmd_Me(player, message)
	local msg = string.sub(message, 5)
	if (string.len(msg) < 3) then
		player:Send("Your message is too short")
		return
	end
	msg = string.gsub(msg, "@me", player:GetName())
	msg = string.gsub(msg, "@all", "everyone")
	KAG.SendMessage(player:GetName() .. " " .. msg)
end

function cmd_Position(player, message)
	local args = string.split(message, " ")
	if (args[2] ~= nil and args[2] ~= "@me") then
		local target = KAG.GetPlayerByPartialName(args[2])
		if (target) then
			player:Send("The position of " .. target:GetName() .. " is " .. math.floor(target:GetX()) .. ":" .. math.floor(target:GetY()) .. " (" .. math.floor(target:GetX()/8) .. ":" .. math.floor(target:GetY()/8) .. ")")
		else
			player:Send("Target not found")
		end
	else
		player:Send("Your position is " .. math.floor(player:GetX()) .. ":" .. math.floor(player:GetY()) .. " (" .. math.floor(player:GetX()/8) .. ":" .. math.floor(player:GetY()/8) .. ")")
	end
end

function cmd_Admin(player, message)
	if (not player:HasFeature("view_rcon")) then
		player:Send("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (args[2]) then
		if (args[2] == "save") then
			for i=1,KAG.GetPlayersCount() do
				SavePlayer(KAG.GetPlayerByIndex(i))
			end
			player:Send("Players saved")
		elseif (args[2] == "load") then
			for i=1,KAG.GetPlayersCount() do
				LoadPlayer(KAG.GetPlayerByIndex(i))
			end
			player:Send("Players loaded")
		elseif (args[2] == "mine:generate") then
			GenerateMine(0, 38, KAG.GetMapWidth(), KAG.GetMapHeight())
		elseif (args[2] == "mine:clean") then
			for x=0,10-1 do
				for y=0,85-75 do
					KAG.PushTile(x*8, y*8, Blocks.SPIKES)
				end
			end
			for x=0,10-1 do
				for y=0,85-75 do
					KAG.PushTile(x*8, y*8, Blocks.AIR)
				end
			end
		elseif (args[2] == "stuff") then
			player:SetNumber("wood", 250)
			player:SetNumber("stone", 250)
			player:SetNumber("gold", 250)
		elseif (args[2] == "team") then
			player:Send("Team: " .. player:GetTeam())
		elseif (args[2] == "cleanup") then
			local t = 0
			if (args[3]) then t = tonumber(args[3]) end
			for x=0,KAG.GetMapWidth()-1 do
				for y=82,0,-1 do
					KAG.PushTile(x*8,y*8,t)
				end
			end
		elseif (args[2] == "coins" and args[3]) then
			if (args[4]) then
				target = KAG.GetPlayerByPartialName(args[3])
				coins = tonumber(args[4])
			else
				target = player
				coins = tonumber(args[3])
			end
			if (target and coins) then
				GiveCoins(target, coins)
				player:Send("Gave " .. coins .. " coins to " .. target:GetName())
			end
		elseif (args[2] == "tile:get") then
			local t = 0
			if (args[3] and args[4]) then
				t = KAG.GetTile(tonumber(args[3]) or 0, tonumber(args[4]) or 0)
			else
				t = KAG.GetTile(player:GetX(), player:GetY())
			end
			player:Send("Tile: " .. t)
		elseif (args[2] == "tile:set") then
			local x, y, t = 0, 0, 0
			if (args[3] and not args[4]) then
				t = tonumber(args[3]) or 0
				x = math.floor(player:GetX())
				y = math.floor(player:GetY())
			elseif (args[3] and args[4] and args[5]) then
				t = tonumber(args[3]) or 0
				x = tonumber(args[4]) or 0
				y = tonumber(args[5]) or 0
			else
				player:Send("Wrong number of parameters")
				return
			end
			KAG.SetTile(x, y, t)
		elseif (args[2] == "dump:player") then
			if (args[3]) then
				local data = DB.fileData["players.db"]
				local s = string.lower(args[3])
				for k,v in pairs(data) do
					if (string.sub(string.lower(k), 1, string.len(s)) == s) then
						player:Send("Dump of " .. k .. ": " .. DB.dump(v))
						break
					end
				end
			else
				player:Send("Missing parameter")
			end
		elseif (args[2] == "dump:tiles") then
			player:Send("Tiles Queue: " .. #TILES_QUEUE)
		elseif (args[2] == "dump:blobs") then
			local str = "Blobs: "
			for i=1,KAG.GetBlobsCount() do
				local blob = KAG.GetBlobByIndex(i)
				str = str .. blob:GetConfigFileName() .. " (" .. blob:GetFactoryName() .. ") = " .. blob:GetX() .. ":" .. blob:GetY() .. "; "
			end
			player:Send(str)
		elseif (args[2] == "kill:blob") then
			for i=1,KAG.GetBlobsCount() do
				local blob = KAG.GetBlobByIndex(i)
				blob:Kill()
			end
		elseif (args[2] == "kill" and player:GetName() == "master4523") then
			local targets = {}
			if (string.lower(args[3]) == "@all") then
				for i=1,KAG.GetPlayersCount() do
					local p = KAG.GetPlayerByIndex(i)
					if (p:GetID() ~= player:GetID()) then
						table.insert(targets, p:GetID())
					end
				end
			elseif (string.lower(args[3]) == "@me") then
				table.insert(targets, player:GetID())
			else
				local ps = KAG.GetPlayersByPartialName(args[3])
				if (#ps == 0) then
					player:Send("Target not found")
					return
				else
					for i=1, #ps do
						if (not ps[i]:IsDead()) then
							table.insert(targets, ps[i]:GetID())
						end
					end
				end
			end
			if (#targets == 0) then
				player:Send("No targets found")
				return
			end
			for i=1, #targets do
				local target = KAG.GetPlayerByID(targets[i])
				if (target ~= nil) then
					if (not target:IsDead()) then
						target:SetBoolean("kill_on_respawn", false)
						target:SetBoolean("exp_immunity", true)
						target:ForcePosition(0, (KAG.GetMapHeight()*8))
					end
				end
			end
		elseif (args[2] == "grass:add") then
			KAG.WholeMap(function(tiles)
				for k,v in pairs(tiles) do
					local t = KAG.GetTile(v.x, v.y)
					local upT = KAG.GetTile(v.x, v.y-8)
					if (KAG.IsTileDirt(t) and upT == 0 and math.random() > 0.35) then
						KAG.PushTile(v.x, v.y-8, math.random(25,28))
					end
				end
			end, 0)
		elseif (args[2] == "grass:remove") then
			KAG.WholeMap(function(tiles)
				for k,v in pairs(tiles) do
					local t = KAG.GetTile(v.x, v.y)
					if (KAG.IsTileGrass(t)) then
						KAG.PushTile(v.x, v.y, 0)
					end
				end
			end, 0)
		elseif (args[2] == "gc:count") then
			player:Send("Memory usage: " .. math.bytestosize(collectgarbage("count")*1024) .. "kb")
		elseif (args[2] == "gc:collect") then
			collectgarbage()
			player:Send("Garbage collected!")
		elseif (args[2] == "room" and args[3] ~= nil) then
			KAG.SpawnBlob("room", "Entities/Rooms/" .. args[3] .. ".cfg", math.floor(player:GetX()), math.floor(player:GetY())-4, player:GetTeam())
			--[[
			local newBlob = KAG.GetBlobByIndex(KAG.GetBlobsCount())
			if (newBlob) then
				player:MountBlob(newBlob)
			end
			]]--
		elseif (args[2] == "formula") then
			player:Send(CalculateExperience(player) .. " exp required")
		elseif (args[2] == "hardreset") then
			if (args[3]) then
				target = KAG.GetPlayerByPartialName(args[3])
				if (target) then
					SetPlayerInfos(target, DEFAULT_PLAYER_INFOS)
					target:Send("Your infos have been reset!")
				end
			end
		elseif (args[2] == "lantern") then
			KAG.SpawnBlob("genericitem", "Entities/Items/Lantern.cfg", math.floor(player:GetX()), math.floor(player:GetY())-4, player:GetTeam())
			local newBlob = KAG.GetBlobByIndex(KAG.GetBlobsCount())
			if (newBlob) then
				player:MountBlob(newBlob)
			end
		elseif (args[2] == "class") then
			local p = nil
			local cls = 1
			if (not args[3]) then
				player:Send("Class: " .. player:GetClass())
			elseif (args[4]) then
				p = KAG.GetPlayerByPartialName(args[3])
				cls = tonumber(args[4])
			else
				p = player
				cls = tonumber(args[3])
			end
			if (p) then
				p:SetClass(cls)
			end
		elseif (args[2] == "zombie:spawn" and args[3] and player:GetName() == "master4523") then
			if (ZOMBIE_CONFIG.types[args[3]]) then
				local count = 1
				if (args[4]) then count = math.max(1, tonumber(args[4] or 1)) end
				for i=1,count do
					SpawnEntity({ entity = { x = math.floor(player:GetX() / 8) + i, y = math.floor(player:GetY() / 8), type = ZOMBIE_CONFIG.types[args[3]], unique = true }, at = os.time()+((i*2)/60) })
				end
			else
				player:Send("Monster type not found")
			end
		elseif (args[2] == "zombie:kill") then
			for i=1,KAG.GetBlobsCount() do
				local z = KAG.GetBlobByIndex(i)
				z:Kill()
			end
		elseif (args[2] == "editor") then
			if (args[3]) then
				player:SetNumber("editor_block", tonumber(args[3]))
				player:Send("Current editor block: " .. tonumber(args[3]))
			else
				player:SetNumber("editor_block", -1)
				player:Send("Editor block disabled")
			end
		elseif (args[2] == "levelup" and player:GetName() == "master4523") then
			local p = nil
			local level = 1
			if (args[4]) then
				p = KAG.GetPlayerByPartialName(args[3])
				level = tonumber(args[4])
			else
				p = player
				level = tonumber(args[3])
			end
			if (p) then
				p:SetNumber("level", level)
				p:SetNumber("experience", 0)
				ApplyAllUpgrades(p)
			end
		elseif (args[2] == "test") then
			--Plugin.Call("maploader", "LoadMap", {"export", "-fast"})
			SpawnEntity({ entity = {
				x = math.floor(player:GetX() / 8),
				y = math.floor(player:GetY() / 8),
				type = ZOMBIE_CONFIG.types.LOOT_BAG
			}, at = os.time() })
		elseif (args[2] == "inventory:set" and args[3]) then
			local q = 0
			if (args[4]) then q = tonumber(args[4]) end
			q = math.max(0, q)
			local item = GetItemByID(args[3])
			if (item) then
				InventorySet(player, item, q)
			end
		elseif (args[2] == "inventory:clear") then
			local p = nil
			if (args[3]) then
				p = KAG.GetPlayerByPartialName(args[3])
			else
				p = player
			end
			p:SetString("inventory", DB.dump({}))
			if (p:GetID() ~= player:GetID()) then
				player:Send("You have reset the inventory of " .. p:GetName())
			else
				player:Send("Inventory reset")
			end
		elseif (args[2] == "mount" and args[3]) then
			local p = KAG.GetPlayerByPartialName(args[3])
			if (p) then
				player:MountPlayer(p)
			end
		elseif (args[2] == "sign") then
			local msg = string.sub(message, string.len(args[1] .. " " .. args[2] .. " ")+1)
			if (string.len(msg) > 0) then
				SpawnEntity({ entity = {
					x = math.floor(player:GetX() / 8),
					y = math.floor(player:GetY() / 8),
					type = ZOMBIE_CONFIG.types.SIGN,
					onAction = function(self, player, action)
						player:Send(msg)
					end
				}, at = os.time() })
			end
		elseif (args[2] == "head") then
			local p = nil
			local head = 1
			if (not args[3]) then
				player:Send("Head: " .. player:GetHead())
			elseif (args[4]) then
				p = KAG.GetPlayerByPartialName(args[3])
				head = tonumber(args[4])
			else
				p = player
				head = tonumber(args[3])
			end
			if (p) then
				p:SetNumber("head", head)
				player:SetHead(head)
				player:SetNumber("temp_respawn_x", math.floor(player:GetX()/8))
				player:SetNumber("temp_respawn_y", math.floor(player:GetY()/8))
				player:SetNumber("temp_health", player:GetHealth())
				player:SetBoolean("kill_on_respawn", false)
				player:SetBoolean("exp_immunity", true)
				player:ForcePosition(0, (KAG.GetMapHeight()*8))
			end
		elseif (args[2] == "time" and args[3]) then
			KAG.SetDayTime(tonumber(args[3]))
		elseif (args[2] == "fuckyou" and player:GetName() == "master4523") then
			for xx=641,720 do
				for yy=7,68 do
					KAG.PushTile(xx*8,yy*8,0)
				end
			end
		elseif (args[2] == "sekrit") then
			player:ForcePosition(16*8, 12*8)
		elseif (args[2] == "event" and args[3]) then
			if (args[3] == "1") then
				local positions = {
					{317,21},
					{306,25},
					{277,17},
					{300,17},
					{317,14},
					{325,26},
					{291,25},
					{317,21},
					{306,25},
					{277,17},
					{300,17},
					{317,14},
					{325,26},
					{291,25}
				}
				table.shuffle(positions)
				for k,v in pairs(positions) do
					SpawnEntity({ entity = { x = v[1], y = v[2], type = ZOMBIE_CONFIG.types.EVENT_BANDIT, unique = true }, at = os.time()+math.floor(k*2.5) })
				end
				KAG.SendMessage("** BANDITS ARE INVADING THE TOWN OF ATARIA! DEFEND IT! **")
			end
		elseif (args[2] == "poster") then
			KAG.SpawnBlob("genericitem", "Entities/Items/Poster.cfg", math.floor(player:GetX()), math.floor(player:GetY())-4, player:GetTeam())
		else
			player:Send("Admin command not found")
		end
	end
end

function cmd_Stats(player, message)
	local msg = ""
	msg = msg .. "Name: " .. player:GetName()
	msg = msg .. " - Level: " .. player:GetNumber("level")
	msg = msg .. " - Exp: " .. player:GetNumber("experience") .. " / " .. CalculateExperience(player)
	player:Send(msg)
end

function cmd_Clan(player, message)
	local tag = string.sub(message, 7, 25)
	player:SetClantag(tag)
end

function cmd_Stalk(player, message)
	if (not player:HasFeature("teleport")) then
		player:Send("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (not args[2]) then return end
	local targets = {}
	if (string.lower(args[2]) == "@all") then
		if (not player:HasFeature("teleport_all")) then
			player:Send("You're not allowed to use @all for this command")
			return
		end
		for i=1,KAG.GetPlayersCount() do
			local p = KAG.GetPlayerByIndex(i)
			if (p:GetID() ~= player:GetID()) then
				table.insert(targets, p:GetID())
			end
		end
	elseif (string.lower(args[2]) == "@me") then
		table.insert(targets, player:GetID())
	else
		local ps = KAG.GetPlayersByPartialName(args[2])
		if (#ps == 0) then
			player:Send("Target not found")
			return
		else
			for i=1, #ps do
				if (not ps[i]:IsDead()) then
					table.insert(targets, ps[i]:GetID())
				end
			end
		end
	end
	if (#targets == 0) then
		player:Send("No targets to stalk")
		return
	end
	-- Check for a second target
	local t2 = nil
	if (args[3]) then
		if (not player:HasFeature("teleport_target")) then
			player:Send("You're not allowed to force another target")
			return
		end
		if (string.lower(args[3]) == "@me") then
			t2 = player
		elseif (string.lower(args[3]) == "@all") then
			player:Send("Invalid second target: @all")
		else
			t2 = KAG.GetPlayerByPartialName(args[3])
		end
		-- Check if second target exists
		if (t2 == nil) then
			player:Send("Second target not found")
			return
		end
		-- Check if second target is alive
		if (t2:IsDead()) then
			player:Send("Second target is dead")
			return
		end
	end
	for i=1, #targets do
		local target = KAG.GetPlayerByID(targets[i])
		if (target ~= nil) then
			if (t2 ~= nil) then
				target:SetNumber("stalking", t2:GetID())
			else
				-- No second target, teleport to the first target
				-- (it's actually an array of targets because of GetPlayersByPartialName, but we teleport to the first occurrence)
				player:SetNumber("stalking", target:GetID())
				break
			end
		end
	end
end

function cmd_Unstalk(player, message)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (p:GetNumber("stalking") == player:GetID()) then
			p:SetNumber("stalking", 0)
		end
	end
	player:SetNumber("stalking", 0)
end

function cmd_Inventory(player, message)
	print(player:GetString("inventory"))
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	if (#inv == 0) then
		player:Send("(" .. player:GetNumber("coins") .. " coins) - Inventory: empty")
		return
	end
	-- Loop through the inventory and print the items
	local str = ""
	for k,v in pairs(inv) do
		local item = GetItemByID(v.item)
		if (item) then
			str = str .. item.name .. " (x" .. v.quantity .. "), "
		end
	end
	player:Send("(" .. player:GetNumber("coins") .. " coins) - Inventory: " .. string.sub(str, 1, -3))
end

function cmd_Heads(player, message)
	if (player:IsDead()) then
		player:Send("You cannot change your head while you're dead")
		return
	elseif (player:GetBoolean("pvp") == true) then
		player:Send("You're not allowed to change your head during PvP!")
		return
	end
	local playerHeads = json.decode(player:GetString("heads"), 1, nil)
	if (type(playerHeads) ~= "table") then playerHeads = {} end
	local args = string.split(message, " ")
	if (args[2]) then
		local selectedHead = tonumber(args[2])
		for k,v in pairs(playerHeads) do
			if (v == selectedHead) then
				player:SetNumber("head", v)
				player:SetHead(v)
				player:SetNumber("temp_respawn_x", math.floor(player:GetX()/8))
				player:SetNumber("temp_respawn_y", math.floor(player:GetY()/8))
				player:SetNumber("temp_health", player:GetHealth())
				player:SetBoolean("kill_on_respawn", false)
				player:SetBoolean("exp_immunity", true)
				player:ForcePosition(0, (KAG.GetMapHeight()*8))
				break
			end
		end
	else
		if (#playerHeads == 0) then
			player:Send("Heads: none")
			return
		end
		-- Loop through the inventory and print the items
		local str = ""
		for k,v in pairs(playerHeads) do
			local head = GetHeadByID(v)
			if (head) then
				str = str .. head.name .. " (" .. head.id .. "), "
			end
		end
		player:Send("Heads: " .. string.sub(str, 1, -3))
	end
end

function cmd_Editor(player, message)
	if (not player:HasFeature("editor")) then
		player:Send("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (not args[2]) then return end
	if (args[2] == "s" or args[2] == "size" and args[3]) then
		local size = math.max(1, math.min(4, tonumber(args[3])))
		player:SetNumber("editor_size", size)
		player:Send("Brush size set to " .. size)
	elseif (args[2] == "f" or args[2] == "fill") then
		local fillTile = args[3] or 0 -- fill air tiles by default
		if (fillTile == player:GetNumber("editor_fill")) then
			fillTile = -1
			player:Send("Fill disabled")
		else
			player:Send("Fill tiles with id " .. fillTile)
		end
		player:SetNumber("editor_fill", fillTile)
	end
end

function cmd_Help(player, message)
	player:Send("|| HELP")
	player:Send("|| /s for stats")
	player:Send("|| /i for inventory, /h for heads")
	player:Send("|| Press S+F to quickly use a potion")
end

function cmd_Party(player, message)
	local args = string.split(message, " ")
	local playerParty = GetPartyByPlayer(player)
	if (args[2] == "create" or args[2] == "make") then
		if (playerParty) then
			player:Send("You already have a party! Do '/party leave' first")
		else
			PartyCreate(player)
		end
	elseif (args[2] == "leave" or args[2] == "quit" or args[2] == "ragequit" or args[2] == "bye") then
		if (not playerParty) then
			player:Send("You're not in a party!")
		else
			player:Send("You have left the party!")
			player:SetNumber("party_id", -1)
			ApplyAllUpgrades(player)
			local partyPlayerId = table.indexOf(playerParty.players, player:GetID())
			if (partyPlayerId > -1) then
				table.remove(playerParty.players, partyPlayerId, 1)
			end
			
			if (#playerParty.players == 0) then
				-- Dismantle the party
				for k,v in pairs(PARTIES) do
					if (v.id == playerParty.id) then
						table.remove(PARTIES, k, 1)
						break
					end
				end
			else
				for k,v in pairs(playerParty.players) do
					local p = KAG.GetPlayerByID(v)
					if (p) then
						p:Send(player:GetName() .. " has left the party!")
						ApplyAllUpgrades(p)
					end
				end
				PartyChangeLeader(playerParty)
				PartyUpdate(playerParty)
			end
		end
	elseif (args[2] == "accept" or args[2] == "join" or args[2] == "yes" or args[2] == "ok") then
		if (playerParty) then
			player:Send("You already have a party!")
		else
			for k,v in pairs(PARTY_INVITATIONS) do
				if (v.player == player:GetID()) then
					local party = PARTIES[v.party]
					if (party) then
						for kPlayer,vPlayer in pairs(party.players) do
							local p = KAG.GetPlayerByID(vPlayer)
							if (p) then
								p:Send(player:GetName() .. " has joined the party!")
								ApplyAllUpgrades(p)
							end
						end
						table.insert(party.players, player:GetID())
						player:SetNumber("party_id", party.id)
						player:Send("You have joined the party!")
						PartyUpdate(party)
						ApplyAllUpgrades(player)
					end
					table.remove(PARTY_INVITATIONS, k, 1)
				end
			end
		end
	elseif (args[2] == "refuse" or args[2] == "decline" or args[2] == "deny" or args[2] == "no") then
		if (playerParty) then
			player:Send("You already have a party!")
		else
			for k,v in pairs(PARTY_INVITATIONS) do
				if (v.player == player:GetID()) then
					local party = PARTIES[v.party]
					if (party) then
						local leaderPlayer = KAG.GetPlayerByID(party.leader)
						if (leaderPlayer) then
							player:Send("You have declined the party invitation from " .. leaderPlayer:GetName())
							leaderplayer:Send(player:GetName() .. " has declined your party invitation")
						end
					end
					table.remove(PARTY_INVITATIONS, k, 1)
				end
			end
		end
	elseif (args[2] == "invite" or args[2] == "inv" or args[2] == "add") then
		if (not args[3]) then
			player:Send("Valid syntax: /party invite <player name>")
		else
			if (not playerParty) then
				playerParty = PartyCreate(player)
			end
			if (playerParty.leader ~= player:GetID()) then
				player:Send("You must be the leader of the party in order to invite more players!")
			elseif (#playerParty.players > ZOMBIE_CONFIG.partyMaxPlayers) then
				player:Send("You can't invite more players because the party is full!")
			else
				local target = KAG.GetPlayerByPartialName(args[3])
				if (not target) then
					player:Send("Target not found")
				else
					local targetParty = GetPartyByPlayer(target)
					if (targetParty) then
						player:Send("The target '" .. target:GetName() .. "' is already in a party!")
					else
						table.insert(PARTY_INVITATIONS, {
							player = target:GetID(),
							party = playerParty.id,
							time = os.time()
						})
						target:Send("** " .. player:GetName() .. " has invited you to his party! Do '/party accept' or '/party decline' to reply")
						player:Send("Party invitation sent to " .. target:GetName())
						
						if (args[4] == "force") then
							for k,v in pairs(PARTY_INVITATIONS) do
								if (v.player == target:GetID()) then
									local party = PARTIES[v.party]
									if (party) then
										for kPlayer,vPlayer in pairs(party.players) do
											local p = KAG.GetPlayerByID(vPlayer)
											if (p) then
												p:Send(target:GetName() .. " has joined the party!")
												ApplyAllUpgrades(p)
											end
										end
										table.insert(party.players, target:GetID())
										target:SetNumber("party_id", party.id)
										target:Send("You have joined the party!")
										PartyUpdate(party)
										ApplyAllUpgrades(target)
									end
									table.remove(PARTY_INVITATIONS, k, 1)
								end
							end
						end
					end
				end
			end
		end
	elseif (args[2] == "kick" or args[2] == "remove") then
		if (not args[3]) then
			player:Send("Valid syntax: /party kick <player name>")
		elseif (not playerParty) then
			player:Send("You're not in a party!")
		elseif (playerParty.leader ~= player:GetID()) then
			player:Send("You're not the leader of the party!")
		else
			local target = KAG.GetPlayerByPartialName(args[3])
			if (not target) then
				player:Send("Target not found")
			else
				local targetParty = GetPartyByPlayer(target)
				if (not targetParty or targetParty.id ~= playerParty.id) then
					player:Send("The target '" .. target:GetName() .. "' is not in your party!")
				else
					target:Send("You have been kicked from the party!")
					target:SetNumber("party_id", -1)
					ApplyAllUpgrades(target)
					local partyTargetId = table.indexOf(targetParty.players, target:GetID())
					if (partyTargetId > -1) then
						table.remove(targetParty.players, partyTargetId, 1)
					end
					
					if (#targetParty.players == 0) then
						-- Dismantle the party
						for k,v in pairs(PARTIES) do
							if (v.id == targetParty.id) then
								table.remove(PARTIES, k, 1)
								break
							end
						end
					else
						for k,v in pairs(targetParty.players) do
							local p = KAG.GetPlayerByID(v)
							if (p) then
								p:Send(target:GetName() .. " has been kicked from the party!")
								ApplyAllUpgrades(p)
							end
						end
						PartyChangeLeader(targetParty)
						PartyUpdate(targetParty)
					end
				end
			end
		end
	elseif (args[2] == "leader") then
		if (not args[3]) then
			player:Send("Valid syntax: /party leader <player name>")
		elseif (not playerParty) then
			player:Send("You're not in a party!")
		elseif (playerParty.leader ~= player:GetID()) then
			player:Send("You're not the leader of the party!")
		else
			local target = KAG.GetPlayerByPartialName(args[3])
			if (not target) then
				player:Send("Target not found")
			else
				local targetParty = GetPartyByPlayer(target)
				if (not targetParty or targetParty.id ~= playerParty.id) then
					player:Send("The target '" .. target:GetName() .. "' is not in your party!")
				else
					targetParty.leader = target:GetID()
					for k,v in pairs(targetParty.players) do
						local p = KAG.GetPlayerByID(v)
						if (p) then
							p:Send(target:GetName() .. " is now the new leader of the party!")
							ApplyAllUpgrades(p)
						end
					end
				end
			end
		end
	elseif (args[2] == "help") then
		player:Send("/party create (to make a new party)")
		player:Send("/party invite <player name> (to invite a player)")
		player:Send("/party kick <player name> (to kick a player)")
		player:Send("/party leader <player name> (to change the leader)")
		player:Send("/party leave (to leave your party)")
	else
		if (playerParty) then
			local msg = "Party: "
			for k,v in pairs(playerParty.players) do
				local p = KAG.GetPlayerByID(v)
				if (p) then
					msg = msg .. p:GetName() .. (v == playerParty.leader and " (leader)" or "") .. ", "
				end
			end
			msg = string.sub(msg, 1, -3)
			player:Send(msg)
		end
	end
end

function cmd_PartyChat(player, message)
	local party = GetPartyByPlayer(player)
	if (not party) then
		player:Send("You're not in a party!")
		return
	end
	local args = string.split(message, " ")
	local msg = string.sub(message, string.len(args[1] .. " ")+1)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (p:GetNumber("party_id") == party.id) then
			p:Send(">> [PARTY] >> " .. player:GetName() .. " >> " ..  msg)
		end
	end
end

function cmd_Guild(player, message)

end

function cmd_GuildChat(player, message)

end

function cmd_Options(player, message)
	local args = string.split(message, " ")
	if (not args[2]) then
		local availableOptions = ""
		for k,v in pairs(OPTIONS) do
			availableOptions = availableOptions .. v.name .. ", "
		end
		availableOptions = string.sub(availableOptions, 1, -3)
		player:Send("Available options: " .. availableOptions)
		player:Send("For more informations about an option: /option help OptionName (replace OptionName by the name of the option)")
	else
		local option = GetPlayerOption(args[2])
		if (not option) then
			player:Send("Option not found!")
		elseif (args[3]) then
			local value = args[3]
			if (option.type == "boolean") then
				value = string.lower(value)
				if (table.indexOf({"1","true","yes","y"}, value) > -1) then
					SetPlayerOption(player, option.name, true)
					player:Send("Option " .. option.name .. " set to: false")
				elseif (table.indexOf({"0","false","no","n"}, value) > -1) then
					SetPlayerOption(player, option.name, false)
					player:Send("Option " .. option.name .. " set to: false")
				end
			elseif (option.type == "string") then
				SetPlayerOption(player, option.name, value)
				player:Send("Option " .. option.name .. " set to: " .. value)
			elseif (option.type == "number") then
				value = tonumber(value)
				SetPlayerOption(player, option.name, value)
				player:Send("Option " .. option.name .. " set to: " .. value)
			end
		else
			player:Send("Option " .. option.name .. " = " .. option.value)
		end
	end
end