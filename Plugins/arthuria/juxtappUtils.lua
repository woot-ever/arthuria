local TILES_QUEUE = {}
local MAP_CHUNKS = {}

-- @ math.fib(num)
-- @ returns a fibonacci sequence number
function math.fib(n)
	return n<2 and n or math.fib(n-1)+math.fib(n-2)
end

-- @ math.round(num, decimals)
-- @ returns a rounded version of the number <num> with a given number of <decimals>
function math.round(num, idp)
	idp = idp or 2
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- @ math.bytestosize(bytes)
-- @ returns a human readable string of a given amount of <bytes>
function math.bytestosize(bytes)
	precision = 2
	kilobyte = 1024;
	megabyte = kilobyte * 1024;
	gigabyte = megabyte * 1024;
	terabyte = gigabyte * 1024;
	if((bytes >= 0) and (bytes < kilobyte)) then
		return bytes .. " Bytes";
	elseif((bytes >= kilobyte) and (bytes < megabyte)) then
		return math.round(bytes / kilobyte, precision) .. ' KB';
	elseif((bytes >= megabyte) and (bytes < gigabyte)) then
		return math.round(bytes / megabyte, precision) .. ' MB';
	elseif((bytes >= gigabyte) and (bytes < terabyte)) then
		return math.round(bytes / gigabyte, precision) .. ' GB';
	elseif(bytes >= terabyte) then
		return math.round(bytes / terabyte, precision) .. ' TB';
	else
		return bytes .. ' B';
	end
end

-- @ math.clamp(value, lower, upper)
-- @ returns a clamped version of the number <value> between <lower> and <upper> values
function math.clamp(v, l, u)
    if (l > u) then l, u = u, l end
    return math.max(l, math.min(u, v))
end

-- @ string.trim(str)
-- @ returns a trimmed string
function string.trim(s)
	local from = s:match"^%s*()"
	return from > #s and "" or s:match(".*%S", from)
end

-- @ table.shuffle(table)
-- @ returns a shuffled table
function table.shuffle(t)
	local rand = math.random
	assert(t, "table.shuffle() expected a table, got nil")
	local iterations = #t
	local j
	for i = iterations, 2, -1 do
		j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

-- @ table.indexOf(table, value)
-- @ returns the index of <value> inside <table> or -1 if the value was not found
function table.indexOf(t, o)
	if "table" == type( t ) then
		for i = 1, #t do
			if o == t[i] then
				return i
			end
		end
		return -1
	else
		error("table.indexOf expects table for first argument, " .. type(t) .. " given")
	end
end

-- @ table.clone(table, nometa)
-- @ clones a table and returns it
function table.clone(t, nometa)
	local u = {}
	if not nometa then
		setmetatable(u, getmetatable(t))
	end
	for i, v in pairs(t) do
		if type(v) == "table" then
			u[i] = table.clone(v)
		else
			u[i] = v
		end
	end
	return u
end

-- @ table.extend(destination, source)
-- @ extends a <destination> table based on the <source> table and returns it
function table.extend(destination, source)
	for k,v in pairs(source) do
		destination[k] = v
	end
	return destination
end

-- @ table.merge(t1, t2)
-- @ merges two tables into a new one
function table.merge(t1, t2)
	for k,v in ipairs(t2) do
		table.insert(t1, v)
	end
	return t1
end

-- @ KAG.WholeMap(callback)
-- @ Splits the map into chunks and calls the <callback> function every X ticks (see OnServerTick)
function KAG.WholeMap(cb, chunkSize)
	chunkSize = chunkSize or 256
	local step = 0
	local tiles = {}
	local i = 1
	for x=0,KAG.GetMapWidth() do
		for y=0,KAG.GetMapHeight() do
			tiles[i] = {x=x*8, y=y*8}
			i = i + 1
			step = step + 1
			if (chunkSize > 0 and step > chunkSize) then
				table.insert(MAP_CHUNKS, {tiles=tiles, callback=cb})
				tiles = {}
				step = 0
			end
		end
	end
	if (chunkSize == 0) then
		-- Only 1 chunk
		table.insert(MAP_CHUNKS, {tiles=tiles, callback=cb})
	end
	print("Generated " .. #MAP_CHUNKS .. " chunks")
end

-- @ KAG.PushTile(x, y, tile)
-- @ adds a <tile> to the queue, at <x>:<y> position
function KAG.PushTile(x, y, tile)
	table.insert(TILES_QUEUE, { x = x, y = y, t = tile })
end

-- @ KAG.GetPlayerByPartialName(name)
-- @ returns the first player starting with a specific <name>
function KAG.GetPlayerByPartialName(s)
	if (string.len(s) == 0) then return nil end
	s = string.lower(s)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (string.sub(string.lower(p:GetName()), 1, string.len(s)) == s) then
			return p
		end
	end
	return nil
end

-- @ KAG.GetPlayersByPartialName(name)
-- @ returns a table of players starting with a specific <name>
function KAG.GetPlayersByPartialName(s)
	local r = {}
	if (string.len(s) == 0) then return r end
	s = string.lower(s)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (string.sub(string.lower(p:GetName()), 1, string.len(s)) == s) then
			table.insert(r, p)
		end
	end
	return r
end

-- @ KAG.GetPlayersByFeature(feature)
-- @ returns a table of players with a specific <feature>
function KAG.GetPlayersByFeature(s)
	local r = {}
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (p:HasFeature(s)) then
			table.insert(r, p)
		end
	end
	return r
end

-- @ KAG.IsTileDirt(tile)
-- @ returns true if the tile is dirt, or false if it's not
function KAG.IsTileDirt(t)
	return table.indexOf({16,29,30,31}, t) > -1
end

-- @ KAG.IsTileDirtBack(tile)
-- @ returns true if the tile is dirt backwall, or false if it's not
function KAG.IsTileDirtBack(t)
	return table.indexOf({32}, t) > -1
end

-- @ KAG.IsTileRock(tile)
-- @ returns true if the tile is rock, or false if it's not
function KAG.IsTileRock(t)
	return table.indexOf({96,100,101,102,103,104}, t) > -1
end

-- @ KAG.IsTileThickRock(tile)
-- @ returns true if the tile is rubbles, or false if it's not
function KAG.IsTileThickRock(t)
	return table.indexOf({208,214,215,216,217,218}, t) > -1
end

-- @ KAG.IsTileStone(tile)
-- @ returns true if the tile is stone block, or false if it's not
function KAG.IsTileStone(t)
	return table.indexOf({48,58,59,60,61,62,63}, t) > -1
end

-- @ KAG.IsTileStoneBack(tile)
-- @ returns true if the tile is stone backwall, or false if it's not
function KAG.IsTileStoneBack(t)
	return table.indexOf({64,76,76,77,78,79}, t) > -1
end

-- @ KAG.IsTileGold(tile)
-- @ returns true if the tile is gold nugget, or false if it's not
function KAG.IsTileGold(t)
	return table.indexOf({80,91,92,93,94}, t) > -1
end

-- @ KAG.IsTileGoldBullion(tile)
-- @ returns true if the tile is gold bullion, or false if it's not
function KAG.IsTileGoldBullion(t)
	return table.indexOf({160,161,162,163,164}, t) > -1
end

-- @ KAG.IsTileWood(tile)
-- @ returns true if the tile is wood block, or false if it's not
function KAG.IsTileWood(t)
	return table.indexOf({196,197,198,200,201,202,203,204}, t) > -1
end

-- @ KAG.IsTileWoodBack(tile)
-- @ returns true if the tile is wood backwall, or false if it's not
function KAG.IsTileWoodBack(t)
	return table.indexOf({205,207}, t) > -1
end

-- @ KAG.IsTileBack(tile)
-- @ returns true if the tile is backwall, or false if it's not
function KAG.IsTileBack(t)
	return KAG.IsTileWoodBack(t) or KAG.IsTileStoneBack(t) or KAG.IsTileDirtBack(t)
end

-- @ KAG.IsTileSpike(tile)
-- @ returns true if the tile is spike, or false if it's not
function KAG.IsTileSpike(t)
	return table.indexOf({167,168,169,170,171,172,192,195}, t) > -1
end

-- @ KAG.IsTileTree(tile)
-- @ returns true if the tile is tree, or false if it's not
function KAG.IsTileTree(t)
	return table.indexOf({119,120,121,122,123,124,125,126}, t) > -1
end

-- @ KAG.IsTileDoor(tile)
-- @ returns true if the tile is door, or false if it's not
function KAG.IsTileDoor(t)
	return KAG.IsTileBlueDoor(t) or KAG.IsTileRedDoor(t)
end

-- @ KAG.IsTileBlueDoor(tile)
-- @ returns true if the tile is blue door, or false if it's not
function KAG.IsTileBlueDoor(t)
	return table.indexOf({128,129,130,134,135,136,137,138}, t) > -1
end

-- @ KAG.IsTileRedDoor(tile)
-- @ returns true if the tile is red door, or false if it's not
function KAG.IsTileRedDoor(t)
	return table.indexOf({130,131,132,133,139,140,141,142,143}, t) > -1
end

-- @ KAG.IsTileBridge(tile)
-- @ returns true if the tile is bridge, or false if it's not
function KAG.IsTileBridge(t)
	return KAG.IsTileBlueBridge(t) or KAG.IsTileRedBridge(t) or table.indexOf({182,183,190,191},t) > -1
end

-- @ KAG.IsTileBlueBridge(tile)
-- @ returns true if the tile is blue bridge, or false if it's not
function KAG.IsTileBlueBridge(t)
	return table.indexOf({176,177,180,184,185,188,189}, t) > -1
end

-- @ KAG.IsTileRedBridge(tile)
-- @ returns true if the tile is red bridge, or false if it's not
function KAG.IsTileRedBridge(t)
	return table.indexOf({178,179,181,186,187}, t) > -1
end

-- @ KAG.IsTileWorkshop(tile)
-- @ returns true if the tile is a workshop piece, or false if it's not
function KAG.IsTileWorkshop(t)
	return table.indexOf({146,147,148,149}, t) > -1
end

-- @ KAG.IsTileGrass(tile)
-- @ returns true if the tile is grass, or false if it's not
function KAG.IsTileGrass(t)
	return table.indexOf({25,26,27,28}, t) > -1
end

-- @ KAG.IsTileLadder(tile)
-- @ returns true if the tile is ladder, or false if it's not
function KAG.IsTileLadder(t)
	return table.indexOf({5,144,145,165,166}, t) > -1
end

-- @ KAG.IsTileBedrock(tile)
-- @ returns true if the tile is bedrock, or false if it's not
function KAG.IsTileBedrock(t)
	return table.indexOf({106}, t) > -1
end

-- @ KAG.IsTileRubble(tile)
-- @ returns true if the tile is rubbles, or false if it's not
function KAG.IsTileRubble(t)
	return table.indexOf({155}, t) > -1
end

function KAG.SendMessageExcept(player, message)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (p:GetID() ~= player:GetID()) then
			p:Send(message)
		end
	end
end

-- @ Player.ForcePosition(x, y)
-- @ sets the <x>:<y> position of a player and makes sure that he was teleported on client side
function Player.ForcePosition(self, x, y)
	self:SetNumber("utils.fpx", x)
	self:SetNumber("utils.fpy", y)
	self:SetPosition(x, y)
end

-- @ Player.IsDead()
-- @ returns whether the player is dead or not, by checking his position and whether he is spectating or not
function Player.IsDead(self)
	return (self:IsSpectating() or (self:GetX() == 0 and self:GetY() == 0))
end

-- @ Player.IsSpectating()
-- @ returns whether the player is in the spectator team or not
function Player.IsSpectating(self)
	return self:GetTeam() == 200
end

function Player.Send(self, msg)
	if (type(msg) == "number") then msg = tostring(msg)
	elseif (type(msg) ~= "string") then return end
	for i in msg:gmatch("[^\r\n]+") do
		self:SendMessage(i:trim())
	end
end

function utils_OnPlayerInit(player)
	player:SetNumber("utils.fpx", -1)
	player:SetNumber("utils.fpy", -1)
end

function utils_OnServerTick(ticks)
	local p, fpx, fpy
	for i=1,KAG.GetPlayersCount() do
		p = KAG.GetPlayerByIndex(i)
		if (not p:IsDead()) then
			fpx = p:GetNumber("utils.fpx")
			fpy = p:GetNumber("utils.fpy")
			if (fpx ~= -1 or fpy ~= -1) then
				if (p:GetX() ~= fpx or p:GetY() ~= fpy) then
					p:SetPosition(fpx, fpy)
				else
					p:SetNumber("utils.fpx", -1)
					p:SetNumber("utils.fpy", -1)
				end
			end
		end
	end
	if (#TILES_QUEUE > 0) then
		for i=1,8 do
			local tile = table.remove(TILES_QUEUE, 1)
			if (tile == nil) then
				collectgarbage()
				break
			end
			KAG.SetTile(tile.x, tile.y, tile.t)
		end
		if (ticks % 30 == 0) then
			print("TILES_QUEUE: " .. #TILES_QUEUE)
		end
	end
	if (#MAP_CHUNKS > 0) then
		local chunkData = table.remove(MAP_CHUNKS)
		chunkData.callback(chunkData.tiles)
	end
end

-- Check if Juxta++ supports dynamic event hooking
-- If it doesn't then you'll have to add them manually
if (Juxta.GetVersion() >= 6) then
	Plugin.OnPlayerInit(utils_OnPlayerInit)
	Plugin.OnServerTick(utils_OnServerTick)
end