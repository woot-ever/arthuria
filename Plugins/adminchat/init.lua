require("stringutils") -- for string.split

local ADMIN_CHAT_FEATURE = "view_rcon" -- seclev feature required in order to be able to talk in the admin chat

function cmd_AdminChat(player, message)
	if (not player:HasFeature(ADMIN_CHAT_FEATURE)) then return end
	local args = string.split(message, " ")
	local msg = string.sub(message, string.len(args[1] .. " ")+1)
	for i=1,KAG.GetPlayersCount() do
		local p = KAG.GetPlayerByIndex(i)
		if (p:HasFeature(ADMIN_CHAT_FEATURE)) then
			p:SendMessage(">> [ADMINS] >> " .. player:GetName() .. " >> " ..  msg)
		end
	end
end

function OnInit()
	KAG.CreateChatCommand("/a", cmd_AdminChat)
end