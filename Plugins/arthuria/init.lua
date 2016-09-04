require("juxtappUtils")
require("chatCommands")
require("roomCommands")
require("events")
local json = require ("dkjson")

ZOMBIE_CONFIG = {
	version = "1",
	team = 3,
	respawnTime = 30, -- seconds
	maxCoinsDisplay = 29999,
	worldName = "Arthuria",
	waterLevel = 5,
	serverName = "HYPE >> Arthuria RPG [OPEN BETA]",
	serverInfo = [[
	]],
	serverPassword = "",
	maintenance = {
		serverName = "HYPE >> Arthuria RPG [CLOSED] [MAINTENANCE]",
		serverPassword = "asdf"
	},
	pvp = {
		x = 1293,
		y = 37,
		respawnX = 1260,
		respawnY = 34,
		health = 2.5,
		spawns = {
			{ x = 1298.5, y = 34 },
			{ x = 1294.5, y = 30 },
			{ x = 1288.5, y = 31 },
			{ x = 1280,   y = 35 }
		}
	},
	serverMaintenance = true,
	loaded = false,
	partyExpirationTime = 60, -- seconds
	partyMaxPlayers = 3,
	types = {
		BASIC_SKELETON = {
			name = "Skelie",
			type = "zombie",
			configName = "Entities/Actors/BasicSkeleton.cfg",
			level = 1,
			health = 246,
			exp = 8,
			coins = {min=4,max=16},
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				},
				{
					id = "skelie-skull",
					chances = 0.55
				}
			}
		},
		ADVANCED_SKELETON = {
			name = "Advanced Skelie",
			type = "zombie",
			configName = "Entities/Actors/BasicSkeleton.cfg",
			level = 5,
			health = 369,
			exp = 43,
			coins = {min=4,max=16},
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				},
				{
					id = "skelie-skull",
					chances = 0.45
				}
			}
		},
		BASIC_EARTH_SPIRIT = {
			name = "Earth Spirit",
			type = "zombie",
			configName = "Entities/Actors/BasicEarthSpirit.cfg",
			level = 10,
			health = 553,
			exp = 64,
			coins = {min=8,max=32},
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				}
			}
		},
		--[[
		ADVANCED_EARTH_SPIRIT = {
			name = "Big Earth Spirit",
			type = "zombie",
			configName = "Entities/Actors/BasicEarthSpirit.cfg",
			level = 6,
			health = 886,
			exp = 96,
			coins = {min=16,max=42},
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				}
			}
		},
		]]--
		BASIC_BISON = {
			name = "Moo",
			type = "zombie",
			configName = "Entities/Actors/BasicBison.cfg",
			level = 15,
			health = 830,
			exp = 105,
			coins = {min=28,max=48},
			drops = {
				{
					id = "small-potion",
					chances = 0.10
				},
				{
					id = "bison-meat",
					chances = 0.45
				}
			}
		},
		BASIC_ZOMBIE = {
			name = "Zombie",
			type = "zombie",
			configName = "Entities/Actors/BasicZombie.cfg",
			level = 20,
			health = 1724,
			exp = 416,
			coins = {min=56,max=96},
			drops = {
				{
					id = "small-potion",
					chances = 0.10
				},
				{
					id = "zombie-flesh",
					chances = 0.45
				}
			}
		},
		BASIC_FIRE_SPIRIT = {
			name = "Fire Spirit",
			type = "zombie",
			configName = "Entities/Actors/BasicFireSpirit.cfg",
			level = 40,
			health = 9929,
			exp = 1310,
			coins = {min=84,max=144},
			drops = {
				{
					id = "small-potion",
					cances = 0.10
				},
				{
					id = "fire-spirit-soul",
					chances = 0.45
				}
			}
		},
		BASIC_WRAITH = {
			name = "Wraith",
			type = "zombie",
			configName = "Entities/Actors/BasicWraith.cfg",
			level = 50,
			health = 6206,
			exp = 1,--936,
			coins = {min=4,max=16},
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				}
			}
		},
		BASIC_WATER_SPIRIT = {
			name = "Water Spirit",
			type = "zombie",
			configName = "Entities/Actors/BasicWaterSpirit.cfg",
			level = 60,
			health = 15886,
			exp = 1834
		},
		BASIC_ZOMBIE_KNIGHT = {
			name = "Zombie Knight",
			type = "zombie",
			configName = "Entities/Actors/BasicZombieKnight.cfg",
			level = 80,
			health = 40671,--*1.6
			exp = 3595,--*1.4
			coins = {min=84,max=144},
			drops = {
				{
					id = "small-potion",
					cances = 0.10
				}
			}
		},
		BASIC_SKULL = {
			name = "Skull",
			type = "zombie",
			configName = "Entities/Actors/BasicSkull.cfg",
			level = 90,
			health = 65073,
			exp = 5392,
			drops = {
				{
					id = "small-potion",
					chances = 0.05
				}
			},
			onDie = function(e, p)
				for i=-2,2 do
					SpawnEntity({ entity = { x = math.floor(e.blob:GetX() / 8) + i, y = math.floor(e.blob:GetY() / 8), type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_ARM, unique = true }, at = os.time()-1 })
				end
			end
		},
		-- exp = 14*x
		CHEST_1 = {
			name = "Chest",
			type = "genericitem",
			configName = "Entities/Items/BasicChest.cfg",
			time = 5*60,
			level = 1,
			health = 1,
			exp = {min=25,max=100},
			coins = {min=24,max=88},
			persistent = true
		},
		CHEST_BOSS_SKULL = {
			name = "Boss Chest",
			type = "genericitem",
			configName = "Entities/Items/BasicChest.cfg",
			unique = true,
			level = 1,
			health = 5000,
			exp = 0,
			coins = {min=104,max=288},
			persistent = true
		},
		BASIC_FAKE_CHEST = {
			name = "Chest",
			type = "genericitem",
			configName = "Entities/Items/BasicChest.cfg",
			unique = true, -- respawn depends on when the spawned mimic dies
			persistent = true,
			level = 1,
			health = 1,
			exp = 0,
			coins = 0,
			onHit = function(e, p, damage)
				SpawnEntity({ entity = {
					x = math.floor(e.blob:GetX() / 8),
					y = math.floor(e.blob:GetY() / 8),
					type = ZOMBIE_CONFIG.types.BASIC_MIMIC,
					unique = true,
					config = {
						parentPosition = { x = e.x, y = e.y }
					}
				}, at = os.time()-1 })
				e.despawn = true
				e.blob:Kill()
			end
		},
		BASIC_ZOMBIE_ARM = {
			name = "Arm",
			type = "zombie",
			configName = "Entities/Actors/BasicZombieArm.cfg",
			level = 1,
			health = 177,
			exp = 42
		},
		MINION_ZOMBIE_ARM = {
			name = "Arm",
			type = "zombie",
			configName = "Entities/Actors/BasicZombieArm.cfg",
			level = 1,
			health = 177,
			exp = 42,
			damage = 0
		},
		BASIC_ZOMBIE_CHICKEN = {
			name = "Chicken",
			type = "zombie",
			configName = "Entities/Actors/BasicZombieChicken.cfg",
			level = 1,
			health = 355,
			exp = 142
		},
		BOSS_SKULL = {
			name = "Skull",
			type = "zombie",
			configName = "Entities/Actors/BasicSkull.cfg",
			level = 1,
			health = 43545,
			exp = 3870,
			drops = {
				{
					id = "giant-skull",
					chances = 0.35
				}
			},
			healthVisible = true,
			sharedLoots = true,
			persistent = true,
			onHit = function(e, p, damage)
				if (math.random() > 0.6) then
					local minion = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_ARM
					if (e.currentHealth <= math.floor((e.health or e.type.health) / 3)) then
						minion = ZOMBIE_CONFIG.types.BASIC_SKELETON
					end
					SpawnEntity({ entity = { x = math.floor(e.blob:GetX() / 8), y = math.floor(e.blob:GetY() / 8), type = minion, unique = true }, at = os.time()-1 })
				end
			end,
			onDie = function(e, p)
				for i=-5,5 do
					SpawnEntity({ entity = { x = math.floor(e.blob:GetX() / 8) + i, y = math.floor(e.blob:GetY() / 8), type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_ARM, unique = true }, at = os.time()-1 })
				end
				SpawnEntity({ entity = { x = math.floor(e.blob:GetX() / 8), y = math.floor(e.blob:GetY() / 8), type = ZOMBIE_CONFIG.types.CHEST_BOSS_SKULL, unique = true }, at = os.time()+3 })
			end
		},
		BASIC_BANDIT = {
			name = "Bandit",
			type = "zombie",
			configName = "Entities/Actors/BasicBandit.cfg",
			level = 30,
			health = 3448,
			exp = 624,
			coins = {min=56,max=96}
		},
		EVENT_BANDIT = {
			name = "Bandit",
			type = "zombie",
			configName = "Entities/Actors/BasicBandit.cfg",
			level = 1,
			health = 178,
			exp = 24
		},
		BASIC_MIMIC = {
			name = "Mimic",
			type = "zombie",
			configName = "Entities/Actors/BasicHungryChest.cfg",
			level = 10,
			health = 2000,
			exp = 226,
			coins = {min=14,max=24},
			onDie = function(self, player)
				SpawnEntity({ entity = {
					x = math.floor(self.config.parentPosition.x / 8),
					y = math.floor(self.config.parentPosition.y / 8),
					type = ZOMBIE_CONFIG.types.BASIC_FAKE_CHEST,
				}, at = ZOMBIE_CONFIG.respawnTime })
			end
		},
		BASIC_CLOUD = {
			name = "Cloud",
			type = "zombie",
			configName = "Entities/Actors/BasicCloud.cfg",
			level = 1,
			health = 355,
			exp = 149,
			damage = 0.1
		},
		BASIC_UNDEAD = {
			name = "Undead",
			type = "zombie",
			configName = "Entities/Actors/BasicUndead.cfg",
			level = 1,
			health = 355,
			exp = 150
		},
		BEDROOM = {
			name = "Bedroom",
			type = "room",
			configName = "Entities/Rooms/RPG_Bedroom.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true
		},
		SHOP = {
			name = "Shop",
			type = "room",
			configName = "Entities/Rooms/RPG_Shop.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true
		},
		TUNNEL = {
			name = "Tunnel",
			type = "room",
			configName = "Entities/Rooms/RPG_Tunnel.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true,
			onAction = function(self, player, action)
				if (action == "fast_travel") then
					if (self.config.position) then
						player:ForcePosition(self.config.position.x * 8, self.config.position.y * 8)
					end
				end
			end
		},
		SIGN = {
			name = "Sign",
			type = "room",
			configName = "Entities/Rooms/RPG_Sign.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true
		},
		HEAD_SHOP_1 = {
			name = "Head Shop",
			type = "room",
			configName = "Entities/Rooms/RPG_HeadShop1.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true
		},
		ALTAR = {
			name = "Altar",
			type = "room",
			configName = "Entities/Rooms/RPG_Altar.cfg",
			level = 1,
			health = 1,
			exp = 0,
			persistent = true
		},
		STATIC_LANTERN = {
			name = "Lantern",
			type = "genericitem",
			configName = "Entities/Items/StaticLantern.cfg",
			level = 1,
			health = 1,
			exp = 0,
			invicible = true
		},
		LOOT_BAG = {
			name = "Loot Bag",
			type = "genericitem",
			configName = "Entities/Items/LootBag.cfg",
			level = 1,
			health = 1,
			invicible = true,
			unique = true
		}
	}
}
BIOMES = {
	{
		id = "start-zone",
		entities = {
			{
				x = 9,
				y = 37,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send([[
						|| WELCOME TO THE LAND OF ]] .. string.upper(ZOMBIE_CONFIG.worldName) .. [[ 
						|| Read the signs for more help
						|| You can also use the /help command
					]])
				end
			},
			{
				x = 29,
				y = 35,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("|| CHAPTER 1: STATS AND INVENTORY")
					player:Send("|| Do /s to show some stats like your level and your experience")
					player:Send("|| Do /i to open the inventory, you can also use an item by typing a part of its name")
					player:Send("|| NOTE: the name will be autocompleted, so if you type '/i sma' it will look for 'Small Potion'")
				end
			},
			{
				x = 39,
				y = 37,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("|| CHAPTER 2: FIGHTING AND LEVELING")
					player:Send("|| When you kill a monster, you gain experience and some coins")
					player:Send("|| Kill enough monsters and you will level up and become stronger")
					player:Send("|| Coins can be used to buy items at a shop")
				end
			},
			{
				x = 70,
				y = 34,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("|| CHAPTER 3: HEALING")
					player:Send("|| If you stand without moving for 10 seconds, you will slowly heal")
					player:Send("|| You can also use a potion if you have one (check your inventory with /i)")
					player:Send("|| NOTE: if you press F while sitting, it will quickly use a potion from your inventory")
				end
			},
			{
				x = 536,
				y = 70,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("Dungeon temporarily closed")
				end
			},
			{
				x = 782,
				y = 60,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("This area is closed for now =>")
				end
			},
			{
				x = 277.5,
				y = 32,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("|| TOWN: ATARIA")
					player:Send("|| Rooms: Bedroom, Shop")
				end
			},
			{
				x = 50,
				y = 39,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 98,
				y = 41,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 111,
				y = 41,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 100,
				y = 35,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 113,
				y = 35,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 104,
				y = 30,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 84,
				y = 22,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 142,
				y = 42,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 142,
				y = 31,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 144,
				y = 12,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 158,
				y = 22,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 157,
				y = 8,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 178,
				y = 19,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 185,
				y = 19,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 194,
				y = 31,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 204,
				y = 31,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 197,
				y = 40,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 236,
				y = 31,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 236,
				y = 38,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
		}
	},
	{
		id = "ghost-cave",
		entities = {
			{
				x = 174,
				y = 43,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 170,
				y = 57,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 161,
				y = 57,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 163,
				y = 53,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 127,
				y = 62,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 135,
				y = 62,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 99,
				y = 57,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 90,
				y = 64,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 100,
				y = 64,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 101,
				y = 71,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 90,
				y = 71,
				type = ZOMBIE_CONFIG.types.BASIC_SKELETON
			},
			{
				x = 59,
				y = 73,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 60,
				y = 66,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 18,
				y = 65,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 27,
				y = 65,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 25,
				y = 71,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 15,
				y = 71,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
		}
	},
	{
		id = "ataria",
		entities = {
			{
				x = 312,
				y = 29,
				type = ZOMBIE_CONFIG.types.HEAD_SHOP_1
			},
			{
				x = 293,
				y = 33,
				type = ZOMBIE_CONFIG.types.BEDROOM
			},
			{
				x = 314,
				y = 33,
				type = ZOMBIE_CONFIG.types.SHOP
			},
			{
				x = 348,
				y = 47.5,
				type = ZOMBIE_CONFIG.types.ALTAR,
				config = {
					requiredSkulls = 200,
					currentSkulls = 0,
				},
				onAction = function(self, player, action)
					if (action == "drop_skulls") then
						local item = GetItemByID("skelie-skull")
						local playerSkulls = InventoryCount(player, item)
						local skullsLeft = self.config.requiredSkulls - self.config.currentSkulls
						if (playerSkulls == 0) then
							player:Send("You do not have enough " .. item.name .. "! (" .. skullsLeft .. " left)")
						else
							local gift = math.max(0, math.min(skullsLeft, playerSkulls))
							if (gift > 0) then
								InventoryRemove(player, item, gift)
								GiveExperience(player, gift)
								self.config.currentSkulls = self.config.currentSkulls + gift
								local msg = "You have given " .. gift .. "x " .. item.name .. " to the altar."
								local needed = skullsLeft - gift
								if (needed > 0) then
									msg = msg .. " " .. needed .. " " .. (needed == 1 and "is" or "are") .. " still needed"
								end
								player:Send(msg)
								if (needed == 0) then
									KAG.SendMessage("== THE ALTAR NEAR 'ATARIA TOWN' IS READY TO BE ACTIVATED! ==")
								end
							end
						end
					elseif (action == "use_altar") then
						local item = GetItemByID("skelie-skull")
						local skullsLeft = self.config.requiredSkulls - self.config.currentSkulls
						if (skullsLeft > 0) then
							player:Send("The altar still needs at least " .. skullsLeft .. " " .. item.name)
						else
							KAG.SendMessage("== " .. string.upper(player:GetName()) .. " ACTIVATED THE ALTAR! ==")
							self.config.currentSkulls = 0
							SpawnEntity({ entity = { x = math.floor(self.blob:GetX() / 8), y = math.floor(self.blob:GetY() / 8), type = ZOMBIE_CONFIG.types.BOSS_SKULL, unique = true }, at = os.time()+3 })
						end
					end
				end
			},
			{
				x = 292,
				y = 24.5,
				type = ZOMBIE_CONFIG.types.TUNNEL,
				config = {
					position = {
						x = 1154,
						y = 57
					}
				}
			}
		}
	},
	{
		id = "dungeon-1",
		entities = {
			{
				x = 313,
				y = 71,
				type = ZOMBIE_CONFIG.types.ADVANCED_SKELETON
			},
			{
				x = 280,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 288,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 309,
				y = 58,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 291,
				y = 57,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 282,
				y = 56,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 271,
				y = 56,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 230,
				y = 59,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 233,
				y = 59,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 231,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
			},
			{
				x = 222,
				y = 63,
				type = ZOMBIE_CONFIG.types.CHEST_1
			},
		}
	},
	{
		id = "bison-forest",
		entities = {
			{
				x = 361,
				y = 33,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 378,
				y = 42,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 399,
				y = 38,
				type = ZOMBIE_CONFIG.types.CHEST_1
			},
			{
				x = 402,
				y = 47,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 420,
				y = 44,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 424.5,
				y = 6,
				type = ZOMBIE_CONFIG.types.CHEST_1
			},
			{
				x = 442,
				y = 23,
				type = ZOMBIE_CONFIG.types.BASIC_FAKE_CHEST
			},
			{
				x = 454,
				y = 45,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 482,
				y = 29,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 487,
				y = 19,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 505,
				y = 46,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
			{
				x = 530,
				y = 48,
				type = ZOMBIE_CONFIG.types.BASIC_BISON
			},
		}
	},
	{
		id = "dungeon-2",
		entities = {
			
		}
	},
	{
		id = "swamp",
		entities = {
			{
				x = 548,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 566,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 576,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 589,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 604,
				y = 73,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 631,
				y = 73,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 643,
				y = 72,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 655,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 672,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
			},
			{
				x = 722,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
			{
				x = 724,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
			{
				x = 726,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
			{
				x = 771,
				y = 64,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
			{
				x = 773,
				y = 63,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
			{
				x = 776,
				y = 62,
				type = ZOMBIE_CONFIG.types.BASIC_BANDIT
			},
		}
	},
	{ 
		id = "mountain-dungeon",
		entities = {
			{
				x = 866,
				y = 20,
				type = ZOMBIE_CONFIG.types.CHEST_1
			},
			{
				x = 861,
				y = 24,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 840,
				y = 23,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 838,
				y = 31,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 852,
				y = 37,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 855,
				y = 33,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 863,
				y = 33,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 865,
				y = 37,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			},
			{
				x = 859,
				y = 28,
				type = ZOMBIE_CONFIG.types.BASIC_WRAITH
			}
		}
	},
	{
		id = "volcano-dungeon",
		entities = {
			{
				x = 833,
				y = 58,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 822,
				y = 64,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 806,
				y = 65,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 789,
				y = 72,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 801,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 824,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 860,
				y = 74,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 862,
				y = 62,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 853,
				y = 61,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 893,
				y = 73,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 900,
				y = 72,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
			{
				x = 894,
				y = 54,
				type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
			},
		}
	},
	{
		id = "boat-left",
		entities = {
			{
				x = 959,
				y = 72.5,
				type = ZOMBIE_CONFIG.types.TUNNEL,
				config = {
					position = {
						x = 1112,
						y = 72
					}
				}
			}
		}
	},
	{
		id = "sea",
		entities = {
			{
				x = 1058.5,
				y = 62,
				type = ZOMBIE_CONFIG.types.CHEST_1
			}
		}
	},
	{
		id = "boat-right",
		entities = {
			{
				x = 1111.5,
				y = 72.5,
				type = ZOMBIE_CONFIG.types.TUNNEL,
				config = {
					position = {
						x = 960,
						y = 72
					}
				}
			}
		}
	},
	{
		id = "new-town",
		entities = {
			{
				x = 1208,
				y = 60.5,
				type = ZOMBIE_CONFIG.types.BEDROOM
			},
			{
				x = 1187,
				y = 62.5,
				type = ZOMBIE_CONFIG.types.SHOP
			},
			{
				x = 1202.5,
				y = 69.5,
				type = ZOMBIE_CONFIG.types.STATIC_LANTERN
			},
			{
				x = 1155,
				y = 56.5,
				type = ZOMBIE_CONFIG.types.TUNNEL,
				config = {
					position = {
						x = 292,
						y = 24
					}
				}
			}
		}
	},
	{
		id = "wasteland",
		entities = {
			
		}
	},
	{
		id = "pvp-arena",
		entities = {
			{
				x = 1260.5,
				y = 34,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					ShowPVPRanking(player)
				end
			},
			{
				x = 1325,
				y = 34,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					ShowPVPRanking(player)
				end
			}
		}
	},
	{
		id = "dojo",
		entities = {
			{
				x = 1401,
				y = 44,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					player:Send("|| DOJO HELP")
					player:Send("Fight strong monsters and survive as many rounds as possible")
				end
			},
			{
				x = 1406,
				y = 44,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					JoinDojo(player)
				end
			},
			{
				x = 1412,
				y = 44,
				type = ZOMBIE_CONFIG.types.SIGN,
				onAction = function(self, player, action)
					ShowDojoRanking(player)
				end
			}
		}
	}
}
DEFAULT_PLAYER_INFOS = {
	class = 1,
	head = 16,
	heads = json.encode({16}),
	coins = 5000,
	stone = 0,
	wood = 0,
	gold = 0,
	bombs = 0,
	arrows = 0,
	--max_health = 1.5,
	hammer = 1,
	level = 1,
	experience = 0,
	x = 0,
	y = 0,
	respawn_x = 1,
	respawn_y = 39,
	bank_wood = 0,
	bank_stone = 0,
	bank_gold = 0,
	max_wood = 20,
	max_stone = 20,
	max_gold = 20,
	up_wood = 0,
	up_stone = 0,
	up_gold = 0,
	up_health = 0,
	up_hammer = 0,
	item_mining_helmet = true,
	logs_materials = true,
	inventory = json.encode({{item = "small-potion", quantity = 50}})
}
UPGRADES = {
	{
		name = "Max Health",
		type = "health",
		label = "Increase maximum health",
		cost = {
			base = 100,
			scale = 4,
			diff = -9 -- first level will be equal to: (base-diff)
		}
	},
	{
		name = "Hammer",
		type = "hammer",
		label = "Upgrade to a better hammer to gather more resources",
		cost = {
			base = 100,
			scale = 4,
			diff = -9
		}
	},
	{
		name = "Stone Bag",
		type = "stone",
		label = "Increase the size of your stone bag",
		cost = {
			base = 100,
			scale = 3,
			diff = -9
		}
	},
	{
		name = "Wood Bag",
		type = "wood",
		label = "Increase the size of your wood bag",
		cost = {
			base = 100,
			scale = 3,
			diff = -9
		}
	},
	{
		name = "Gold Bag",
		type = "gold",
		label = "Increase the size of your gold bag",
		cost = {
			base = 100,
			scale = 3,
			diff = -9
		}
	}
}
ITEMS = {
	{
		id = "small-potion",
		name = "Small Potion",
		onUse = function(self, player)
			local currentHealth = player:GetHealth()
			local maxHealth = player:GetNumber("max_health")
			local healthDiff = maxHealth - currentHealth
			if (healthDiff > 0) then
				player:SetHealth(maxHealth)
				player:Send("Healed " .. math.round(healthDiff * 2, 1) .. " HP")
				return true
			else
				player:Send("Your health is full!")
			end
			return false
		end
	},
	{
		id = "skelie-skull",
		name = "Skelie Skull",
		crap = true,
		sellPrice = 2,
	},
	{
		id = "zombie-flesh",
		name = "Zombie Flesh",
		crap = true,
		sellPrice = 8,
	},
	{
		id = "giant-skull",
		name = "Giant Skull",
		crap = true,
		sellPrice = 500
	},
	{
		id = "bison-meat",
		name = "Bison Meat",
		crap = true,
		sellPrice = 8,
	},
	{
		id = "earth-spirit-soul",
		name = "Earth Spirit Soul",
		crap = true,
		sellPrice = 8
	},
	{
		id = "fire-spirit-soul",
		name = "Fire Spirit Soul",
		crap = true,
		sellPrice = 8
	}
}
HEADS = {
	{
		id = 16,
		name = "Normal Head",
		price = 0,
		bonus = {}
	},
	{
		id = 17,
		name = "Archer Hat",
		price = 5000,
		bonus = {
			acc = 2,
			def = 1,
			jab = -2
		}
	},
	{
		id = 18,
		name = "Bearded Face",
		price = 3500,
		bonus = {
			exp = 1,
			def = 1
		}
	},
	{
		id = 20,
		name = "Warrior Helmet",
		price = 5000,
		bonus = {
			def = 1,
			jab = 2
		}
	},
	{
		id = 21,
		name = "Knight Helmet",
		price = 7500,
		bonus = {
			def = 2,
			slash = 2,
			acc = -2
		}
	},
	{
		id = 22,
		name = "Cowboy Scarf",
		price = 3500,
		bonus = {
			acc = 1,
			jab = 1
		}
	},
	{
		id = 23,
		name = "Blindfolded",
		price = 5000,
		bonus = {
			slash = 2,
			acc = -2
		}
	},
	{
		id = 24,
		name = "Samurai Hat",
		price = 3500,
		bonus = {
			acc = 1,
			slash = 1
		}
	},
	{
		id = 25,
		name = "Pharaoh Hat",
		price = 5000,
		bonus = {
			coins = 2,
		}
	},
	{
		id = 26,
		name = "Scientist Head",
		price = 5000,
		bonus = {
			exp = 2,
			jab = -3,
			slash = -3
		}
	},
	{
		id = 27,
		name = "Gentleman Hat",
		price = 7500,
		bonus = {
			acc = 1,
			def = 1,
			jab = 1,
			slash = 1
		}
	},
	{
		id = 28,
		name = "Punk Head",
		price = 3500,
		bonus = {
			jab = 1,
			slash = 1,
			def = -1
		}
	},
	{
		id = 29,
		name = "Zombie Head",
		price = 7500,
		bonus = {
			jab = 2,
			slash = 2,
			health = -2
		}
	},
}
OPTIONS = {
	{
		name = "ShowDamage",
		desc = "Set to yes/no to show or hide the damage you do in the chat",
		type = "boolean",
		default = true
	},
	{
		name = "ShowExp",
		desc = "Set to yes/no to show or hide the experience you gain in the chat",
		type = "boolean",
		default = true
	}
}

ZOMBIE_TEAM_CHECK_QUEUE = {}
RESPAWN_QUEUE = {}
ENTITIES = {}
ENTITIES_MAPPING = {}
ZOMBIE_COMBAT = {}
PARTIES = {}
PARTY_INVITATIONS = {}
PVP_RANKING = {}
ENTITY_ID = 0
DOJO = {
	x = 1406,
	y = 44,
	rooms = {
		{
			name = "First room",
			position = {
				x = 1393,
				y = 24
			},
			width = 27,
			height = 10
		},
		{
			name = "Second room",
			position = {
				x = 1393,
				y = 46
			},
			width = 27,
			height = 10
		},
		{
			name = "Third room",
			position = {
				x = 1396,
				y = 13
			},
			width = 21,
			height = 10
		},
		{
			name = "Fourth room",
			position = {
				x = 1393,
				y = 57
			},
			width = 27,
			height = 10
		},
		{
			name = "Fifth room",
			position = {
				x = 1398,
				y = 2
			},
			width = 19,
			height = 10
		}
	},
	monsters = {
		{
			type = ZOMBIE_CONFIG.types.BASIC_SKELETON
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_EARTH_SPIRIT
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_ARM
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_CHICKEN
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_WATER_SPIRIT
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_BANDIT
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_FIRE_SPIRIT
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_ZOMBIE_KNIGHT
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_SKULL
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_MIMIC
		},
		--[[
		{
			type = ZOMBIE_CONFIG.types.BASIC_CLOUD
		},
		{
			type = ZOMBIE_CONFIG.types.BASIC_WRAITH
		},
		]]--
		{
			type = ZOMBIE_CONFIG.types.BASIC_UNDEAD
		}
	}
}

function LoadPlayer(player)
	if (not player) then return end
	if (not player:IsPlaying()) then return end
	if (player:IsBot()) then return end
	
	local playerData = {}
	local h = io.open("data/players/" .. player:GetName() .. ".db", "r")
	if h ~= nil then
		local data = h:read("*all")
		h:close()
		local obj, pos, err = json.decode(data, 1, nil)
		if (not err) then
			playerData = obj
		else
			print("LoadPlayer ERROR: " .. err)
		end
	end
	
	local pInfos = table.extend(table.clone(DEFAULT_PLAYER_INFOS), playerData)
	print(json.encode(pInfos, { indent = false }))
	SetPlayerInfos(player, pInfos)
end

function SetPlayerInfos(player, pInfos)
	player:SetNumber("editor_size", 1)
	player:SetNumber("editor_fill", -1)
	player:SetNumber("party_id", -1)
	
	if (pInfos["respawn_x"] == 0 or pInfos["respawn_y"] == 0) then
		pInfos["respawn_x"] = DEFAULT_PLAYER_INFOS.respawn_x
		pInfos["respawn_y"] = DEFAULT_PLAYER_INFOS.respawn_y
	end
	--player:SetNumber("max_health", pInfos["max_health"])
	player:SetClass(pInfos["class"])
	player:SetHead(pInfos["head"])
	player:SetBoolean("kill_on_respawn", true)
	player:SetNumber("respawn_x", pInfos["respawn_x"])
	player:SetNumber("respawn_y", pInfos["respawn_y"])
	player:SetNumber("stone", pInfos["stone"])
	player:SetNumber("wood", pInfos["wood"])
	player:SetNumber("gold", pInfos["gold"])
	player:SetNumber("bombs", pInfos["bombs"])
	player:SetNumber("arrows", pInfos["arrows"])
	player:SetNumber("coins", pInfos["coins"])
	player:SetNumber("level", pInfos["level"])
	player:SetNumber("experience", pInfos["experience"])
	player:SetNumber("hammer", pInfos["hammer"])
	player:SetNumber("class", pInfos["class"])
	player:SetNumber("head", pInfos["head"])
	player:SetNumber("bank_wood", pInfos["bank_wood"])
	player:SetNumber("bank_stone", pInfos["bank_stone"])
	player:SetNumber("bank_gold", pInfos["bank_gold"])
	player:SetNumber("max_wood", pInfos["max_wood"])
	player:SetNumber("max_stone", pInfos["max_stone"])
	player:SetNumber("max_gold", pInfos["max_gold"])
	player:SetNumber("up_wood", pInfos["up_wood"])
	player:SetNumber("up_stone", pInfos["up_stone"])
	player:SetNumber("up_gold", pInfos["up_gold"])
	player:SetNumber("up_health", pInfos["up_health"])
	player:SetNumber("up_hammer", pInfos["up_hammer"])
	player:SetBoolean("item_mining_helmet", pInfos["item_mining_helmet"])
	player:SetBoolean("logs_materials", pInfos["logs_materials"])
	player:SetString("inventory", pInfos["inventory"])
	player:SetString("heads", pInfos["heads"])
	
	local playerOptions = json.decode(pInfos["options"], 1, nil)
	if (not playerOptions) then playerOptions = {} end
	local optionsTable = {}
	for k,v in pairs(OPTIONS) do
		optionsTable[v.name] = v.value
	end
	playerOptions = table.extend(optionsTable, playerOptions)
	player:SetString("options", json.encode(playerOptions, { indent = false }))
end

function SavePlayer(player)
	if (not player) then return end
	if (not player:IsPlaying()) then return end
	if (player:IsBot()) then return end
	
	local playerData = {
		x = player:GetX(),
		y = player:GetY(),
		respawn_x = player:GetNumber("respawn_x"),
		respawn_y = player:GetNumber("respawn_y"),
		class = player:GetNumber("class"),
		head = player:GetNumber("head"),
		coins = player:GetNumber("coins"),
		stone = player:GetNumber("stone"),
		wood = player:GetNumber("wood"),
		gold = player:GetNumber("gold"),
		bombs = player:GetNumber("bombs"),
		arrows = player:GetNumber("arrows"),
		health = player:GetHealth(),
		--max_health = player:GetNumber("max_health"),
		level = player:GetNumber("level"),
		experience = player:GetNumber("experience"),
		hammer = player:GetNumber("hammer"),
		bank_wood = player:GetNumber("bank_wood"),
		bank_stone = player:GetNumber("bank_stone"),
		bank_gold = player:GetNumber("bank_gold"),
		max_wood = player:GetNumber("max_wood"),
		max_stone = player:GetNumber("max_stone"),
		max_gold = player:GetNumber("max_gold"),
		up_wood = player:GetNumber("up_wood"),
		up_stone = player:GetNumber("up_stone"),
		up_gold = player:GetNumber("up_gold"),
		up_health = player:GetNumber("up_health"),
		up_hammer = player:GetNumber("up_hammer"),
		item_mining_helmet = player:GetBoolean("item_mining_helmet"),
		logs_materials = player:GetBoolean("logs_materials"),
		inventory = player:GetString("inventory"),
		heads = player:GetString("heads"),
		options = player:GetString("options")
	}
	
	local h = io.open("data/players/" .. player:GetName() .. ".db", "w")
	if (h ~= nil) then
		local dumped = json.encode(playerData, { indent = false })
		if (not dumped) then
			print("SavePlayer ERROR: dumped is null")
		else
			h:write(dumped)
		end
		h:close()
	end
end

function HandlePlayer(player, ticks)
	if (player:GetBoolean("pvp") == true) then
		player:SetStone(0)
		player:SetWood(0)
		player:SetBombs(0)
		player:SetCoins(0)
	else
		player:SetStone(player:GetNumber("stone"))
		player:SetWood(player:GetNumber("wood"))
		player:SetBombs(player:GetNumber("bombs"))
		player:SetCoins(math.min(ZOMBIE_CONFIG.maxCoinsDisplay, player:GetNumber("coins")))
	end
	player:SetScore(math.floor(player:GetIdleTime()/30))
	
	local px = player:GetX()
	local py = player:GetY()
	
	if (not player:IsDead()) then
		-- Stalking
		local stalkingId = player:GetNumber("stalking")
		if (stalkingId > 0) then
			local p = KAG.GetPlayerByID(stalkingId)
			if (p and not p:IsDead()) then
				player:ForcePosition(p:GetX(), p:GetY())
			end
		end
		
		-- Heal every x seconds when idling
		local idleTime = player:GetIdleTime()
		local pvping = player:GetBoolean("pvp")
		if (not pvping and idleTime > 0 and idleTime % 300 == 0) then
			local newHealth = math.min(player:GetNumber("max_health"), player:GetHealth() + 0.5)
			player:SetHealth(newHealth)
		end
		
		-- Shortcuts
		if (player:IsKeyDown(Keys.DOWN) and player:WasKeyPressed(Keys.CHANGE)) then
			-- TODO: InventoryFindBySlot
			local item = GetItemByID("small-potion")
			if (InventoryCount(player, item) > 0) then
				InventoryUse(player, item)
			else
				player:Send("You're out of potions!")
			end
		end
		
		-- Pick-up
		--[[
		if (player:WasKeyPressed(Keys.USE)) then-- and player:HasFeature("view_rcon")) then
			local foundTarget = false
			for i=1,KAG.GetPlayersCount() do
				local p = KAG.GetPlayerByIndex(i)
				if (p:GetID() ~= player:GetID() and math.abs(p:GetX()-player:GetX()) < 12 and math.abs(p:GetY()-player:GetY()) < 12) then
					player:MountPlayer(p)
					foundTarget = true
					break
				end
			end
			if (not foundTarget) then
				for i=1,KAG.GetBlobsCount() do
					local b = KAG.GetBlobByIndex(i)
					if (math.abs(b:GetX()-player:GetX()) < 12 and math.abs(b:GetY()-player:GetY()) < 12) then
						player:MountBlob(b)
						foundTarget = true
						break
					end
				end
			end
		end
		]]--
		
		--[[
		if (ticks % 30 == 0) then
			local blob = player:GetBlob()
			if (blob) then
				if (blob:IsFacingLeft()) then
					player:Send("You're facing left!")
				else
					player:Send("You're facing right!")
				end
			end
		end
		]]--
		
		-- Lava
		if (ticks % 21 == 0) then
			local tile = KAG.GetTile(px, py)
			if (tile == 83) then
				player:Send("LAVA! HOT!")
				local hp = player:GetHealth() - 0.25
				player:SetHealth(hp)
				if (hp <= 0) then
					player:SetBoolean("kill_on_respawn", false)
					player:SetBoolean("exp_immunity", true)
					player:ForcePosition(0, (KAG.GetMapHeight()*8))
				end
			end
		end
	end
end

function OnUnload()
	-- Save players
	for i=1,KAG.GetPlayersCount() do
		SavePlayer(KAG.GetPlayerByIndex(i))
	end
	-- Save world
	SaveWorld()
	-- Remove all blobs
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		b:Kill()
	end
end

function OnInit()
	math.randomseed(os.time())
	
	KAG.SendRcon("/rcon /sv_name " .. (ZOMBIE_CONFIG.serverMaintenance and ZOMBIE_CONFIG.maintenance.serverName or ZOMBIE_CONFIG.serverName))
	KAG.SendRcon("/rcon /sv_info " .. ZOMBIE_CONFIG.serverInfo)
	KAG.SendRcon("/rcon /sv_password " .. (ZOMBIE_CONFIG.serverMaintenance and ZOMBIE_CONFIG.maintenance.serverPassword or ZOMBIE_CONFIG.serverPassword))
	
	KAG.CreateChatCommand("/i", cmd_Inventory)
	KAG.CreateChatCommand("/h", cmd_Heads)
	KAG.CreateChatCommand("/s", cmd_Stats)
	KAG.CreateChatCommand("/tp", cmd_Teleport)
	KAG.CreateChatCommand("/pos", cmd_Position)
	KAG.CreateChatCommand("/help", cmd_Help)
	--KAG.CreateChatCommand("/me", cmd_Me)
	KAG.CreateChatCommand("/admin", cmd_Admin)
	KAG.CreateChatCommand("/e", cmd_Editor)
	--KAG.CreateChatCommand("/clan", cmd_Clan)
	--KAG.CreateChatCommand("/stalk", cmd_Stalk)
	--KAG.CreateChatCommand("/unstalk", cmd_Unstalk)
	KAG.CreateChatCommand("/party", cmd_Party)
	KAG.CreateChatCommand("/p", cmd_PartyChat)
	KAG.CreateChatCommand("/guild", cmd_Guild)
	KAG.CreateChatCommand("/g", cmd_GuildChat)
	KAG.CreateChatCommand("/options", cmd_Options)
	
	KAG.CreateRoomCommand("heal", rm_Heal)
	KAG.CreateRoomCommand("set_spawn", rm_SetSpawn)
	KAG.CreateRoomCommand("check_shop", rm_CheckShop)
	KAG.CreateRoomCommand("sell_crap", rm_SellCrap)
	KAG.CreateRoomCommand("buy_smallpotion", rm_Buy_SmallPotion)
	KAG.CreateRoomCommand("buy_smallpotion_10", rm_Buy_SmallPotion_10)
	KAG.CreateRoomCommand("buy_smallpotion_50", rm_Buy_SmallPotion_50)
	KAG.CreateRoomCommand("buy_damagepotion", rm_Buy_DamagePotion)
	KAG.CreateRoomCommand("read_sign", rm_ReadSign)
	KAG.CreateRoomCommand("drop_skulls", rm_DropSkulls)
	KAG.CreateRoomCommand("use_altar", rm_UseAltar)
	KAG.CreateRoomCommand("check_tunnel", rm_CheckTunnel)
	KAG.CreateRoomCommand("fast_travel", rm_FastTravel)
	
	for i=1,33 do
		KAG.CreateRoomCommand("buy_head_" .. i, _G["rm_Buy_Head" .. i])
	end
	
	LoadPVPRanking()
	
	GenerateBiomes()
	
	KAG.SendMessage("Arthuria v" .. ZOMBIE_CONFIG.version .. " has been loaded!")
end

function LogMaterials(player, x, mat)
	if (not player:GetBoolean("logs_materials")) then return end
	--player:Send((x < 0 and "Lost" or "Gained") .. " " .. x .. " " .. mat)
end

function BankStore(player, mat)
	local current = player:GetNumber(mat) or 0
	local bank = player:GetNumber("bank_" .. mat) or 0
	local total = bank + current
	player:SetNumber("bank_" .. mat, total)
	GiveMaterial(player, -current, mat)
	player:Send("Stored " .. current .. " " .. mat .. " in bank (total: " .. total .. ")")
end

function BankWithdraw(player, mat)
	local current = player:GetNumber(mat) or 0
	local bank = player:GetNumber("bank_" .. mat) or 0
	local spaceLeftInBag = player:GetNumber("max_" .. mat) - current
	if (spaceLeftInBag <= 0) then
		player:Send("Your " .. mat .. " bag is full!")
		return
	end
	local withdraw = math.min(spaceLeftInBag, math.max(bank, bank - spaceLeftInBag))
	local newBank = bank - withdraw
	local newCurrent = current + withdraw
	player:SetNumber("bank_" .. mat, newBank)
	player:SetNumber(mat, newCurrent)
	player:Send("Withdrawn " .. withdraw .. " " .. mat .. " from bank (left: " .. newBank .. ")")
end

function GiveMaterial(player, x, mat)
	if (not player or not x or not mat) then return end
	local maxGain = player:GetNumber("max_" .. mat) - player:GetNumber(mat)
	local actualGain = math.min(maxGain, x)
	local val = math.clamp(player:GetNumber(mat) + actualGain, 0, player:GetNumber("max_" .. mat))
	player:SetNumber(mat, val)
	LogMaterials(player, actualGain, mat)
	return actualGain
end

function GiveWood(player, x)
	x = x or 0
	return GiveMaterial(player, x, "wood")
end

function GiveStone(player, x)
	x = x or 0
	return GiveMaterial(player, x, "stone")
end

function GiveGold(player, x)
	x = x or 0
	return GiveMaterial(player, x, "gold")
end

function GiveBombs(player, x)
	x = x or 0
	return GiveMaterial(player, x, "bombs")
end

function GiveArrows(player, x)
	x = x or 0
	return GiveMaterial(player, x, "arrows")
end

function UpgradePlayer(player, upgradeType)
	local upgrade = GetUpgradeByType(upgradeType)
	if (not upgrade) then return end
	local currentLevel = player:GetNumber("up_" .. upgrade.type)
	local newLevel = currentLevel + 1
	local bagCoins = player:GetNumber("coins")
	local bankCoins = player:GetNumber("bank_coins")
	local playerCoins = bagCoins + bankCoins
	local price = CalculateUpgradeCost(newLevel, upgrade.cost)
	if (playerCoins < price) then
		player:Send("You do not have enough money at the bank or inside your bag! (you have " .. playerCoins .. " coins, you need " .. price .. " coins)")
		return
	end
	local paidFromBank = math.min(price, bankCoins)
	local paidFromBag = math.min(price - paidFromBank, bagCoins)
	player:SetNumber("bank_coins", bankCoins - paidFromBank)
	player:SetNumber("coins", bagCoins - paidFromBag)
	player:SetNumber("up_" .. upgrade.type, newLevel)
	player:Send("Took " .. paidFromBank .. " coins at the bank" .. (paidFromBag > 0 and " and " .. paidFromBag .. " coins in your wallet" or ""))
	player:Send("Upgraded " .. upgrade.name .. " to level " .. newLevel .. "!")
	
	ApplyAllUpgrades(player)
end

function ApplyAllUpgrades(player)
	--[[
	for i=1,#UPGRADES do
		ApplyUpgrade(player, UPGRADES[i].type)
	end
	]]--
	
	-- Apply head bonus
	local baseAccuracy = 1
	local baseDefense = 1
	local baseJab = 1
	local baseSlash = 1
	local baseExperience = 1
	local baseCoins = 1
	local baseHealth = 0
	--[[
	for k,v in pairs(HEADS) do
		if (v.id == player:GetNumber("head")) then
			baseHealth = baseHealth + (v.bonus.health or 0)
			baseAccuracy = baseAccuracy + (v.bonus.acc or 0)
			baseDefense = baseDefense + (v.bonus.def or 0)
			baseJab = baseJab + (v.bonus.jab or 0)
			baseSlash = baseSlash + (v.bonus.slash or 0)
			baseExperience = baseExperience + (v.bonus.exp or 0)
			baseCoins = baseCoins + (v.bonus.coins or 0)
			break
		end
	end
	]]--
	player:SetNumber("base_health", baseHealth)
	player:SetNumber("base_accuracy", baseAccuracy)
	player:SetNumber("base_defense", baseDefense)
	player:SetNumber("base_jab", baseJab)
	player:SetNumber("base_slash", baseSlash)
	player:SetNumber("base_experience", baseExperience)
	player:SetNumber("base_coins", baseCoins)
	
	-- Update health
	player:SetNumber("max_health", 2 + math.floor(baseHealth + player:GetNumber("level") / 5) / 4)
	player:SetHealth(player:GetNumber("max_health"))
	
	-- Update clantag
	if (player:GetBoolean("pvp") == false) then
		local tag = "[" .. player:GetNumber("level") .. "]"
		local party = GetPartyByPlayer(player)
		if (party) then
			local leaderPlayer = KAG.GetPlayerByID(party.leader)
			if (leaderPlayer) then
				tag = tag .. " (P)"
			end
		end
		player:SetClantag(tag)
	end
end

function ApplyUpgrade(player, upgradeType)
	-- TODO: add base constants somewhere
	local base
	if (upgradeType == "wood" or upgradeType == "stone" or upgradeType == "gold") then
		base = 20
		player:SetNumber("max_" .. upgradeType, base + player:GetNumber("up_" .. upgradeType) * 10)
	elseif (upgradeType == "coins") then
		base = 2
		player:SetNumber("max_coins", (10 ^ (base + player:GetNumber("up_coins")) - 1))
	elseif (upgradeType == "health") then
		--base = 1.5
		--player:SetHealth(base + (player:GetNumber("up_health") / 4))
		player:SetHealth(player:GetNumber("max_health"))
	elseif (upgradeType == "hammer") then
		base = 1
		player:SetNumber("hammer", base + player:GetNumber("up_hammer"))
	end
end

function CalculatePlayerDamage(player, baseDamage)
	local level = player:GetNumber("level")
	if (level <= 0) then return 0 end
	local base = 50 -- TODO: put this somewhere else
	local baseAccuracy = player:GetNumber("base_accuracy")
	
	--[[
	local bonus = 0
	if (baseDamage == 1.0) then -- jab
		--KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " did a jab")
		bonus = math.random(math.min(-3, -3 * -baseAccuracy), 3) + (player:GetNumber("base_jab") * 11) 
	elseif (baseDamage == 1.25) then -- weak stomp (without shield)
		--KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " did a weak stomp")
		--bonus = math.random(math.min(-3, -3 * -baseAccuracy), 3)
		bonus = math.random(math.min(-3, -3 * -baseAccuracy), 3) + (player:GetNumber("base_jab") * 11) 
	elseif (baseDamage == 1.50) then -- slash
		--KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " did a slash")
		--bonus = 10 + math.random(math.min(-3, -3 * -baseAccuracy), 20) + (player:GetNumber("base_slash") * 11)
		bonus = math.random(math.min(-3, -3 * -baseAccuracy), 3) + (player:GetNumber("base_jab") * 11) * 1.5
	elseif (baseDamage == 1.75) then -- strong stomp
		--KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " did a strong stomp")
		bonus = 5 + math.random(math.min(-3, -3 * -baseAccuracy), 10)
	else
		KAG.SendMessage("(" .. os.time() .. ") " .. player:GetName() .. " did an unknown hit with " .. baseDamage .. " base damage")
	end
	]]--
	
	local bonus = math.random(math.min(-3, -3 * -baseAccuracy), 3) + (player:GetNumber("base_jab") * 11)
	local multiplier = 0.0
	if (baseDamage == 1.0) then -- jab
		multiplier = 1.0
	elseif (baseDamage == 1.25) then -- weak stomp (without shield)
		multiplier = 1.1
	elseif (baseDamage == 1.50) then -- slash
		multiplier = 1.5
	elseif (baseDamage == 1.75) then -- strong stomp
		multiplier = 1.25
	end
	local factor = 512 -- TODO: put this somewhere else
	local w = 22 * math.sqrt(level)
	local d = w * (10 / factor * level * math.sqrt(level)) + base
	local finalDamage = math.floor((d + bonus) * multiplier)
	return finalDamage
end

function CalculateExperience(player)
	--ROUNDUP(500000*((A2)/98)^2)
	return math.ceil(500000*(player:GetNumber("level")/98)^2)
	
	--[[
	local levels = 40
	local xp_for_first_level = 100
	local xp_for_last_level = 100000
	local B = math.log(xp_for_last_level / xp_for_first_level) / (levels - 1)
	local A = xp_for_first_level / (math.exp(B) - 1.0)
	local nextLevel = player:GetNumber("level") + 1
	local old_xp = math.floor(A * math.exp(B * (nextLevel - 1)))
	local new_xp = math.floor(A * math.exp(B * nextLevel))
	return new_xp - old_xp
	]]--
end

function GiveExperience(player, x)
	if (x == 0) then return end
	local currentExp = player:GetNumber("experience")
	local newExp = math.max(0, currentExp + x)
	local diffExp = newExp - currentExp
	player:SetNumber("experience", newExp)
	player:Send("You " .. (diffExp > 0 and "gained" or "lost") .. " " .. math.abs(diffExp) .. " exp!")
	if (newExp >= CalculateExperience(player)) then
		local newLevel = player:GetNumber("level") + 1
		player:SetNumber("level", newLevel)
		player:SetNumber("experience", 0)
		ApplyAllUpgrades(player)
		--PartyUpdate(playerParty)
		player:Send("LEVEL UP! You are now level " .. newLevel)
		KAG.SendMessageExcept(player, player:GetName() .. " leveled up!")
		SavePlayer(player)
	end
	player:SetGold(math.floor((player:GetNumber("experience") / CalculateExperience(player)) * 100))
end

function GiveCoins(player, x)
	if (x == 0) then return end
	local currentCoins = player:GetNumber("coins")
	local newCoins = math.max(0, currentCoins + x)
	local diffCoins = newCoins - currentCoins
	player:SetNumber("coins", newCoins)
	player:Send("You " .. (diffCoins > 0 and "gained" or "lost") .. " " .. diffCoins .. " coins! (total: " .. newCoins .. ")")
end

function GenerateBiomes()
	for i=1,#BIOMES do
		local biome = BIOMES[i]
		if (type(biome.entities) == "table") then
			for k,v in pairs(biome.entities) do
				SpawnEntity({ entity = v, at = os.time() })
			end
		end
	end
	KAG.SendRcon("waterLevel(" .. ZOMBIE_CONFIG.waterLevel .. ");")
end

function GetBiomeByID(id)
	for k,v in pairs(BIOMES) do
		if (BIOMES[i].id == id) then
			return BIOMES[i]
		end
	end
	return nil
end

function PlayersAround(x, y, r)
	local playersCount = KAG.GetPlayersCount()
	if (playersCount == 0) then return false end
	
	r = r or 800 -- pixels
	
	local xyLength = 0
	if (not _PLAYERS_POSITIONS) then
		_PLAYERS_POSITIONS = {}
		for i=1,playersCount do
			local p = KAG.GetPlayerByIndex(i)
			if (not p:IsDead()) then
				_PLAYERS_POSITIONS[xyLength+1] = {x = p:GetX(), y = p:GetY()}
				xyLength = xyLength + 1
			end
		end
	else
		xyLength = #_PLAYERS_POSITIONS
	end
	
	for i=1,xyLength do
		if (math.abs(x - _PLAYERS_POSITIONS[i].x) <= r and y <= _PLAYERS_POSITIONS[i].y + 140) then
			return true
		end
	end
	
	return false
end

function InventoryAdd(player, item, quantity)
	quantity = quantity or 1
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	local itemAdded = false
	for k,v in pairs(inv) do
		if (v.item == item.id) then
			v.quantity = v.quantity + quantity
			itemAdded = true
			break
		end
	end
	if (not itemAdded) then
		table.insert(inv, {item = item.id, quantity = quantity})
	end
	player:SetString("inventory", json.encode(inv, { indent = false }))
	player:Send("Received x" .. quantity .. " " .. item.name)
end

function InventorySet(player, item, quantity)
	quantity = quantity or 1
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	local quantityDiff = 0
	local itemFound = false
	for k,v in pairs(inv) do
		if (v.item == item.id) then
			itemFound = true
			if (quantity <= 0) then
				table.remove(inv, k, 1)
			else
				quantityDiff = quantity - v.quantity
				v.quantity = quantity
				break
			end
		end
	end
	if (not itemFound) then
		table.insert(inv, {item = item.id, quantity = quantity})
		quantityDiff = quantity
	end
	if (quantityDiff < 0) then
		player:Send("Lost x" .. quantityDiff .. " " .. item.name)
	elseif (quantityDiff > 0) then
		player:Send("Received x" .. quantityDiff .. " " .. item.name)
	end
	player:SetString("inventory", json.encode(inv, { indent = false }))
end

function InventoryRemove(player, item, quantity)
	quantity = quantity or 1
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	for k,v in pairs(inv) do
		if (v.item == item.id) then
			v.quantity = v.quantity - quantity
			if (v.quantity <= 0) then
				table.remove(inv, k, 1)
			end
			player:SetString("inventory", json.encode(inv, { indent = false }))
			player:Send("Lost x" .. quantity .. " " .. item.name .. (v.quantity > 0 and " (" .. v.quantity .. " left)" or ""))
			break
		end
	end
end

function InventoryCount(player, item)
	if (not item) then return end
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	for k,v in pairs(inv) do
		if (v.item == item.id) then
			return v.quantity
		end
	end
	return 0
end

function InventoryUse(player, item, quantity)
	quantity = quantity or 1
	if (not item) then return end
	if (player:GetBoolean("pvp") == true) then
		player:Send("You're not allowed to use items during PvP!")
		return
	end
	if (type(item.onUse) == "function") then
		if (item.onUse(item, player)) then
			InventoryRemove(player, item ,quantity)
		end
	end
end

function GetItemByID(itemId)
	for k,v in pairs(ITEMS) do
		if (v.id == itemId) then
			return v
		end
	end
	return nil
end

function GetHeadByID(headId)
	for k,v in pairs(HEADS) do
		if (v.id == headId) then
			return v
		end
	end
	return nil
end

function BuyHead(player, headId)
	local playerHeads = json.decode(player:GetString("heads"), 1, nil)
	if (type(playerHeads) ~= "table") then playerHeads = {} end
	local alreadyBought = false
	for k,v in pairs(playerHeads) do
		if (v == headId) then
			alreadyBought = true
			break
		end
	end
	if (alreadyBought) then
		player:Send("You have already bought this head, do /h " .. headId .. " to change your head!")
		return
	end
	
	local head = nil
	for k,v in pairs(HEADS) do
		if (v.id == headId) then
			head = v
			break
		end
	end
	if (not head) then
		player:Send("That head doesn't exist!")
		return
	end
	local currentCoins = player:GetNumber("coins")
	if (currentCoins < head.price) then
		player:Send("Not enough coins in your wallet!")
		return
	end
	
	-- Buy it
	for i=1,KAG.GetBlobsCount() do
		local b = KAG.GetBlobByIndex(i)
		if ((b:GetConfigFileName() == "Entities/Rooms/RPG_HeadShop1.cfg" or b:GetConfigFileName() == "Entities/Rooms/RPG_HeadShop2.cfg") and math.abs(b:GetX()-player:GetX()) <= 128 and math.abs(b:GetY()-player:GetY()) <= 64) then
			local e = ENTITIES[b:GetID()]
			if (e) then
				GiveCoins(player, -head.price)
				player:SetNumber("head", head.id)
				player:SetHead(head.id)
				table.insert(playerHeads, head.id)
				player:SetString("heads", json.encode(playerHeads, { indent = false }))
				player:Send("You now own this head! Do /h " .. head.id .. " to change your head!")
				player:SetNumber("temp_respawn_x", e.x)
				player:SetNumber("temp_respawn_y", e.y)
				
				player:SetBoolean("kill_on_respawn", false)
				player:SetBoolean("exp_immunity", true)
				player:ForcePosition(0, (KAG.GetMapHeight()*8))
			end
		end
	end
end

function SellCrap(player)
	local inv = json.decode(player:GetString("inventory"), 1, nil)
	if (type(inv) ~= "table") then inv = {} end
	local craps = {}
	for k,v in pairs(ITEMS) do
		if (v.crap) then
			table.insert(craps, v.id)
		end
	end
	for k,v in pairs(inv) do
		if (table.indexOf(craps, v.item) > -1) then
			local item = GetItemByID(v.item)
			if (item) then
				local totalPrice = v.quantity * (item.sellPrice or 0)
				InventoryRemove(player, item, v.quantity)
				GiveCoins(player, totalPrice)
			end
		end
	end
end

function PartyCreate(player)
	table.insert(PARTIES, {
		id = #PARTIES + 1,
		players = {player:GetID()},
		leader = player:GetID(),
		level = player:GetNumber("level")
	})
	player:Send("You have created a new party!")
	player:SetNumber("party_id", #PARTIES)
	ApplyAllUpgrades(player)
	return PARTIES[#PARTIES]
end

function PartyUpdate(party)
	local partyLevel = 0
	for k,v in pairs(party.players) do
		local p = KAG.GetPlayerByID(v)
		if (p) then
			local level = p:GetNumber("level")
			-- TODO: check for leeching conditions
			partyLevel = partyLevel + level
		else
			table.remove(party.players, k, 1)
		end
	end
	party.level = partyLevel
end

function PartyChangeLeader(party, newLeader)
	if (not newLeader) then
		for k,v in pairs(party.players) do
			local p = KAG.GetPlayerByID(v)
			if (p and p:GetID() ~= party.leader) then
				newLeader = p
				break
			end
		end
	end
	print("YOOOOOOOOOOOOOOOOOOOOOOOOOOOO 11111")
	if (not newLeader) then return end
	print("YOOOOOOOOOOOOOOOOOOOOOOOOOOOO 222222")
	party.leader = newLeader:GetID()
	for k,v in pairs(party.players) do
		local p = KAG.GetPlayerByID(v)
		if (p) then
			if (p:GetID() == newLeader:GetID()) then
				p:Send("You are now the leader of the party!")
			else
				p:Send(newLeader:GetName() .. " is now the new leader of the party!")
			end
			ApplyAllUpgrades(p)
		end
	end
end

function GetPartyByPlayer(player)
	if (type(player) == "number") then player = KAG.GetPlayerByID(player) end
	if (not player) then return nil end
	return PARTIES[player:GetNumber("party_id")]
end

function GetPlayerOption(player, optionName)
	if (not player or not optionName) then return nil end
	local playerOptions = json.decode(player:GetString("options"), 1, nil)
	if (type(playerOptions) ~= "table") then playerOptions = {} end
	optionName = string.lower(optionName)
	for k,v in pairs(playerOptions) do
		if (string.lower(k) == optionName) then
			for k2,v2 in pairs(OPTIONS) do
				if (v2.name == k) then
					return v2
				end
			end
			break
		end
	end
	return nil
end

function SetPlayerOption(player, optionName, optionValue)
	if (not player or not optionName or not optionValue) then return nil end
	local options = json.decode(player:GetString("options"), 1, nil)
	if (type(options) ~= "table") then options = {} end
	optionName = string.lower(optionName)
	for k,v in pairs(options) do
		if (string.lower(v.name) == optionName) then
			v.value = optionValue
			break
		end
	end
	player:SetString("options", json.encode(options, { indent = false }))
end

function SaveWorld()
	SavePVPRanking()
end

function LoadPVPRanking()
	local ranking = {}
	local h = io.open("data/pvp-ranking.db", "r")
	if h ~= nil then
		local data = h:read("*all")
		h:close()
		local obj, pos, err = json.decode(data, 1, nil)
		if (not err) then
			ranking = obj
		else
			print("LoadPVPRanking ERROR: " .. err)
		end
	end
	PVP_RANKING = table.clone(ranking) --TODO: do we really need to clone the table?
end

function UpdatePVPRanking(playerName, killUpdate, deathUpdate)
	if (not PVP_RANKING[playerName]) then PVP_RANKING[playerName] = {kills = 0, deaths = 0} end
	PVP_RANKING[playerName].kills = PVP_RANKING[playerName].kills + killUpdate
	PVP_RANKING[playerName].deaths = PVP_RANKING[playerName].deaths + deathUpdate
end

function SavePVPRanking()
	local h = io.open("data/pvp-ranking.db", "w")
	if (h ~= nil) then
		local dumped = json.encode(PVP_RANKING, { indent = false })
		if (not dumped) then
			print("SavePVPRanking ERROR: dumped is null")
		else
			h:write(dumped)
		end
		h:close()
	end
end

function ShowPVPRanking(player)
	player:Send("|| PVP ARENA RANKING")
	local suffix = ""
	local i = 1
	local pairsTable = {}
	for k,v in pairs(PVP_RANKING) do
		pairsTable[#pairsTable + 1] = {k = k, v = v}
	end
	table.sort(pairsTable, function(a, b) return a.v.kills - a.v.deaths > b.v.kills - b.v.deaths end)
	for k,v in pairs(pairsTable) do
		if (i == 1) then suffix = "st"
		elseif (i == 2) then suffix = "nd"
		elseif (i == 3) then suffix = "rd"
		else suffix = "th" end
		player:Send("|| " .. i .. suffix .. ": " .. v.k .. " (" .. (v.v.kills - v.v.deaths) .. " points)")
		i = i + 1
		if (i > 5) then break end
	end
end

function ShowDojoRanking(player)
	player:Send("|| DOJO RANKING")
end

function JoinDojo(player)
	for k,v in pairs(DOJO.rooms) do
		if (not v.player) then
			v.player = player:GetID()
			v.monster = nil
			v.monsterIndex = 0
			v.level = 0
			player:SetBoolean("dojoing", true)
			player:SetBoolean("kill_on_respawn", false)
			player:SetBoolean("exp_immunity", true)
			player:SetNumber("temp_respawn_x", DOJO.x)
			player:SetNumber("temp_respawn_y", DOJO.y)
			player:Send("Welcome to Dojo! You are in room \"" .. v.name .. "\"")
			player:ForcePosition((v.position.x + v.width / 2) * 8, (v.position.y + v.height / 2) * 8)
			return
		end
	end
end

function SpawnEntity(config)
	ENTITY_ID = ENTITY_ID + 1
	config._entityId = ENTITY_ID
	table.insert(RESPAWN_QUEUE, config)
	return config._entityId
end