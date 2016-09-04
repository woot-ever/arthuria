function OnPlayerChangeTeam(player, team, oldTeam)
	KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " switched from team " .. oldTeam .. " to team " .. team)
end