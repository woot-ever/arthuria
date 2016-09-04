local TILES_WHITELIST = {
	167,168,169,192, -- spikes
	128, -- doors
	176,184, -- bridges
	64, -- castle back
	48, -- stone block
	160, -- gold bullion
	144,145,165,166, -- ladders
	146,147,148,149, -- workshop tiles
	196, -- wooden block
	205, -- wooden back
	16, -- dirt block
	80, -- gold block
	96, -- stone block
	208, -- thick stone block
	106, -- bedrock block
	119, -- tree tile
	32, -- dirt back
	155 -- rubbles
}

function OnMapReceiveTile(player, x, y, tile)
	-- Teleport-to-mouse
	--player:SetPosition(x*8, y*8)
	--return 0
	local tileAt = KAG.GetTile(x*8, y*8)
	
	-- DEBUG: show tile id
	if (player:GetName() == "master4523") then
		player:SendMessage(x .. ":" .. y .. " = " .. tile)
	end
	
	-- Anti block hack
	if (tile ~= 0 and table.indexOf(TILES_WHITELIST, tile) == -1) then
		--player:SendMessage("This block has been disabled")
		--return 0
	end
	
	-- Disables spikes, rubbles and bedrock
	if (table.indexOf({--[[167,168,169,192,]]155,106}, tile) > -1) then
		player:SendMessage("This block has been disabled")
		return 0
	end
	
	--[[
	-- Do not build on the left side
	if (x < 32 and table.indexOf({144,145,165,166}, tile) == -1) then
		player:SendMessage("You cannot build on the left side of the map")
		return 0
	end
	]]--
	
	-- Tile filling (filter)
	local fillTile = player:GetNumber("editor_fill")
	if (fillTile > -1 and tile ~= 0) then
		print("tileAt="..tileAt)
		print("fillTile="..fillTile)
		if (tileAt ~= fillTile) then
			return 0
		end
	end
	
	-- Special blocks
	if (player:GetNumber("editor_block") > -1 and tile ~= 0) then
		KAG.SetTile(x*8, y*8, player:GetNumber("editor_block"))
		return 0
	end
	
	local editorSize = player:GetNumber("editor_size")
	if (editorSize > 1) then
		for ex=editorSize-1,0,-1 do
			for ey=editorSize-1,0,-1 do
				if (fillTile > -1) then
					if (KAG.GetTile((x+ex)*8, (y+ey)*8) == fillTile) then
						KAG.SetTile((x+ex)*8, (y+ey)*8, tile)
					end
				else
					KAG.SetTile((x+ex)*8, (y+ey)*8, tile)
				end
			end
		end
		return 0
	end
	return 1
end
