require 'stringutils'

local JSON = require "JSON"
local tilesQueue = {}
local FAST = false

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

function PushTile(x, y, tile)
	table.insert(tilesQueue, { x = x, y = y, t = tile })
end

function cmd_SaveMap(player, message)
	if (not player:HasFeature("view_console")) then
		player:SendMessage("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (not args[2]) then
		player:SendMessage("Missing parameter: map name")
		return
	end
	local tile
	local w = KAG.GetMapWidth()
	local h = KAG.GetMapHeight()
	local start = os.clock()
	player:SendMessage("Saving map...");
	
	local data = {
		map = {
			width = KAG.GetMapWidth(),
			height = KAG.GetMapHeight()
		},
		tiles={},
		blobs={}
	}
	
	-- Save tiles
	for x=0,w do
		for y=0,h do
			tile = KAG.GetTile(x * 8, y * 8)
			if (tile ~= 0 and tile ~= -1) then
				table.insert(data.tiles, {x=x, y=y, t=tile})
			end
		end
	end
	
	-- Save blobs
	for i=1,KAG.GetBlobsCount() do
		local blob = KAG.GetBlobByIndex(i)
		table.insert(data.blobs, {id=blob:GetID(), factory=blob:GetFactoryName(), config=blob:GetConfigFileName(), type=blob:GetType(), team=blob:GetTeam(), x=blob:GetX(), y=blob:GetY()})
	end
	
	local file = io.open(args[2] .. ".kagx", "w")
	file:write(JSON:encode(data))--encode_pretty
	file:close()
	player:SendMessage("Map saved (took " .. (os.clock()-start) .. "s)")
end

function cmd_LoadMap(player, message)
	if (not player:HasFeature("view_console")) then
		player:SendMessage("You do not have access to that command!")
		return
	end
	local args = string.split(message, " ")
	if (not args[2]) then
		player:SendMessage("Missing parameter: map name")
		return
	end
	LoadMap(args[2], args[3] or false)
end

function LoadMap(mapName, params)
	mapName = mapName or "export"
	params = params or ""
	
	FAST = false
	if (params) then
		if (params == "-fast") then
			FAST = true
			for i=1,KAG.GetPlayersCount() do
				local p = KAG.GetPlayerByIndex(i)
				p:Kick()
			end
		end
	end
	
	local file = io.open(mapName .. ".kagx", "r")
	local data = JSON:decode(file:read("*all"))
	file:close()
	if (not FAST) then KAG.SendMessage("Loading map...") end
	
	local width = (data.map and data.map.width) and data.map.width or 0
	local height = (data.map and data.map.height) and data.map.height or 0
	if (not FAST) then KAG.SendMessage("width:height = " .. width .. ":" .. height) end
	if (data.tiles) then
		for k,v in pairs(data.tiles) do
			PushTile(v.x*8, v.y*8, v.t)
		end
	end
	if (data.blobs) then
		for k,v in pairs(data.blobs) do
			if (v.factory == "room") then
				KAG.SetTile(v.x, v.y, 64)
			end
			KAG.SpawnBlob(v.factory, v.config, v.x, v.y, v.team)
		end
	end
	
	if (not FAST) then KAG.SendMessage("Map loaded") end
end

function OnServerTick(ticks)
	if (#tilesQueue > 0) then
		for i=1,FAST and #tilesQueue or 500 do
			local tile = table.remove(tilesQueue, 1)
			if (tile == nil) then
				collectgarbage()
				break
			end
			KAG.SetTile(tile.x, tile.y, tile.t)
		end
		if (ticks % 30 == 0) then
			print("Tiles queue: " .. #tilesQueue)
		end
	end
end

function OnInit()
	KAG.CreateChatCommand("/savemap", cmd_SaveMap)
	KAG.CreateChatCommand("/loadmap", cmd_LoadMap)
end