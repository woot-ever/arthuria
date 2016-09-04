function OnMapChange(mapName)
	if (mapName == "Maps/rpg_empty.png") then
		--Plugin.Call("maploader", "LoadMap", {"export", "-fast"})
		KAG.SendRcon("/rcon /sv_password " .. ZOMBIE_CONFIG.serverPassword)
		KAG.SendRcon("waterLevel(4);")
	end
end