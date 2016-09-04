function OnBlobInit(blob)
	if (blob:GetConfigFileName() == "Entities/Items/Lantern.cfg") then return end
	table.insert(ZOMBIE_TEAM_CHECK_QUEUE, blob:GetID())
end
