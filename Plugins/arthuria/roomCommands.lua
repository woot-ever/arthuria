function rm_Heal(player)
	local maxHealth = player:GetNumber("max_health")
	local diffHealth = maxHealth - player:GetHealth()
	if (diffHealth > 0) then
		player:SendMessage("Healed " .. (diffHealth * 2) .. " HP")
		player:SetHealth(player:GetNumber("max_health"))
	end
end

function rm_SetSpawn(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Bedroom.cfg" and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				player:SetNumber("respawn_x", e.x)
				player:SetNumber("respawn_y", e.y)
				player:SendMessage("New spawn point set! You will respawn here if you die or leave the server")
			end
		end
	end
end

function rm_CheckShop(player)
	
end

function rm_SellCrap(player)
	SellCrap(player)
end

function rm_Buy_SmallPotion(player)
	local unitPrice = 50
	local amount = 1
	local price = unitPrice * amount
	local currentCoins = player:GetNumber("coins")
	if (currentCoins < price) then
		player:SendMessage("Not enough coins in your wallet!")
		return
	end
	player:SetNumber("coins", math.max(0, currentCoins - price))
	player:SendMessage("Lost " .. price .. " coins")
	InventoryAdd(player, GetItemByID("small-potion"), amount)
end

function rm_Buy_SmallPotion_10(player)
	local unitPrice = 50
	local amount = 10
	local price = unitPrice * amount
	local currentCoins = player:GetNumber("coins")
	if (currentCoins < price) then
		player:SendMessage("Not enough coins in your wallet!")
		return
	end
	player:SetNumber("coins", math.max(0, currentCoins - price))
	player:SendMessage("Lost " .. price .. " coins")
	InventoryAdd(player, GetItemByID("small-potion"), amount)
end

function rm_Buy_SmallPotion_50(player)
	local unitPrice = 50
	local amount = 50
	local price = unitPrice * amount
	local currentCoins = player:GetNumber("coins")
	if (currentCoins < price) then
		player:SendMessage("Not enough coins in your wallet!")
		return
	end
	player:SetNumber("coins", math.max(0, currentCoins - price))
	player:SendMessage("Lost " .. price .. " coins")
	InventoryAdd(player, GetItemByID("small-potion"), amount)
end

function rm_Buy_DamagePotion(player)
	local price = 500
	local currentCoins = player:GetNumber("coins")
	if (currentCoins < price) then
		player:SendMessage("Not enough coins in your wallet!")
		return
	end
	player:SetNumber("coins", math.max(0, currentCoins - price))
	player:SendMessage("Lost " .. price .. " coins")
	InventoryAdd(player, GetItemByID("damage-potion"))
end

function rm_ReadSign(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Sign.cfg" and math.abs(b:GetX()-player:GetX()) <= 24 and math.abs(b:GetY()-player:GetY()) <= 24) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				if (type(e.onAction) == "function") then e.onAction(e, player, "read_sign") end
				if (type(e.type.onAction) == "function") then e.type.onAction(e, player, "read_sign") end
				break
			end
		end
	end
end

function rm_DropSkulls(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Altar.cfg" and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				if (type(e.onAction) == "function") then e.onAction(e, player, "drop_skulls") end
				if (type(e.type.onAction) == "function") then e.type.onAction(e, player, "drop_skulls") end
				break
			end
		end
	end
end

function rm_UseAltar(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Altar.cfg" and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				if (type(e.onAction) == "function") then e.onAction(e, player, "use_altar") end
				if (type(e.type.onAction) == "function") then e.type.onAction(e, player, "use_altar") end
				break
			end
		end
	end
end

function rm_CheckTunnel(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Tunnel.cfg" and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				if (type(e.onAction) == "function") then e.onAction(e, player, "check_tunnel") end
				if (type(e.type.onAction) == "function") then e.type.onAction(e, player, "check_tunnel") end
				break
			end
		end
	end
end

function rm_FastTravel(player)
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if (b:GetConfigFileName() == "Entities/Rooms/RPG_Tunnel.cfg" and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				if (type(e.onAction) == "function") then e.onAction(e, player, "fast_travel") end
				if (type(e.type.onAction) == "function") then e.type.onAction(e, player, "fast_travel") end
				break
			end
		end
	end
end

function rm_Buy_Head1(player)
	BuyHead(player, 16)
end
function rm_Buy_Head2(player)
	BuyHead(player, 17)
end
function rm_Buy_Head3(player)
	BuyHead(player, 18)
end
function rm_Buy_Head4(player)
	BuyHead(player, 19)
end
function rm_Buy_Head5(player)
	BuyHead(player, 20)
end
function rm_Buy_Head6(player)
	BuyHead(player, 21)
end
function rm_Buy_Head7(player)
	BuyHead(player, 22)
end
function rm_Buy_Head8(player)
	BuyHead(player, 23)
end
function rm_Buy_Head9(player)
	BuyHead(player, 24)
end
function rm_Buy_Head10(player)
	BuyHead(player, 25)
end
function rm_Buy_Head11(player)
	BuyHead(player, 26)
end
function rm_Buy_Head12(player)
	BuyHead(player, 27)
end
function rm_Buy_Head13(player)
	BuyHead(player, 28)
end
function rm_Buy_Head14(player)
	BuyHead(player, 29)
end
function rm_Buy_Head15(player)
	BuyHead(player, 30)
end
function rm_Buy_Head16(player)
	BuyHead(player, 31)
end
function rm_Buy_Head17(player)
	BuyHead(player, 32)
end
function rm_Buy_Head18(player)
	BuyHead(player, 33)
end
function rm_Buy_Head19(player)
	BuyHead(player, 34)
end
function rm_Buy_Head20(player)
	BuyHead(player, 35)
end
function rm_Buy_Head21(player)
	BuyHead(player, 36)
end
function rm_Buy_Head22(player)
	BuyHead(player, 37)
end
function rm_Buy_Head23(player)
	BuyHead(player, 38)
end
function rm_Buy_Head24(player)
	BuyHead(player, 39)
end
function rm_Buy_Head25(player)
	BuyHead(player, 40)
end
function rm_Buy_Head26(player)
	BuyHead(player, 41)
end
function rm_Buy_Head27(player)
	BuyHead(player, 42)
end
function rm_Buy_Head28(player)
	BuyHead(player, 43)
end
function rm_Buy_Head29(player)
	BuyHead(player, 0)
end
function rm_Buy_Head30(player)
	BuyHead(player, 1)
end
function rm_Buy_Head31(player)
	BuyHead(player, 2)
end
function rm_Buy_Head32(player)
	BuyHead(player, 3)
end
function rm_Buy_Head33(player)
	BuyHead(player, 4)
end