function OnPlayerChangeClass(player, class, oldClass)
	KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " switched from class " .. oldClass .. " to class " .. class)
end