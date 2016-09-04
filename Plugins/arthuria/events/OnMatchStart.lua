function OnMatchStart()
	if (ZOMBIE_CONFIG.loaded) then return end
	ZOMBIE_CONFIG.loaded = true
	KAG.SendRcon("/rcon /sv_password " .. (ZOMBIE_CONFIG.serverMaintenance and ZOMBIE_CONFIG.maintenance.serverPassword or ZOMBIE_CONFIG.serverPassword) or math.floor(math.random() * os.time()))
	KAG.ChangeMapPNG("rpg_empty")
end
