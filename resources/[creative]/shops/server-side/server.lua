-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("shops",cRP)
vCLIENT = Tunnel.getInterface("shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	["weedShop"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["silk"] = 50,
			["weedseed"] = 5,
			["fertilizer"] = 5
		}
	}, 
	["cokeseedstore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["cokeseed"] = 5,
			["mushseed"] = 5,
			["sulfuric"] = 50
		}
	},
	["imoveisShop"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["contract1"] = 125000,
			["contract2"] = 300000,
			["contract3"] = 75000,
			["contract4"] = 175000,
			["contract5"] = 125000,
			["contract6"] = 250000,
			["contract7"] = 75000,
			["contract8"] = 250000,
			["contract9"] = 175000,
			["contract10"] = 100000
		}
	},
	["identityStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["identity"] = 5000
		}
	},
	["fidentityStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["fidentity"] = 10000
		}
	},
	["animalStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["rottweiler7"] = 5000,
			["husky7"] = 5000,
			["shepherd7"] = 5000,
			["retriever7"] = 5000,
			["poodle7"] = 5000,
			["pug7"] = 5000,
			["westy7"] = 5000,
			["cat7"] = 5000
		}
	},
	["departamentStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["sugar"] = 6,
			["cheese"] = 10,
			["postit"] = 20,
			["notepad"] = 10,
			["energetic"] = 15,
			["hamburger"] = 25,
			["emptybottle"] = 30,
			["cigarette"] = 10,
			["lighter"] = 175,
			["chocolate"] = 15,
			["sandwich"] = 15,
			["chandon"] = 15,
			["dewars"] = 15,
			["hennessy"] = 15,
			["absolut"] = 15,
			["tacos"] = 22,
			["cola"] = 15,
			["soda"] = 15,
			["coffee"] = 20,
			["bread"] = 5
		}
	},
	["desserts"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Desserts",
		["list"] = {
			["sugar"] = 3,
			["milkbottle"] = 20,
			["coffee2"] = 6,
			["wheat"] = 3,
			["fishfillet"] = 25,
			["chocolate"] = 7
		}
	},
	["fishdepartamentStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["bait"] = 4,
			["chocolate"] = 15,
			["fishingrod"] = 725
		}
	},
	["mercadoCentral"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["teddy"] = 75,
			["rose"] = 25,
			["rope"] = 875,
			["firecracker"] = 100,
			["radio"] = 975,
			["cellphone"] = 575,
			["tablet"] = 375,
			["binoculars"] = 275,
			["camera"] = 275,
			["vape"] = 4750,
			["scanner"] = 2750,
			["chair01"] = 750,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725
		}
	},
	["Clothes"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["teddy"] = 75,
			["WEAPON_BRICK"] = 25,
			["WEAPON_SHOES"] = 25,
			["WEAPON_SNOWBALL"] = 25,
			["rope"] = 875
		}
	},
	["mechanicTools"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["tyres"] = 350,
			["toolbox"] = 500,
			["WEAPON_CROWBAR"] = 725,
			["WEAPON_WRENCH"] = 725		
		}
	},
	["LesterTools"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["lockpick"] = 500,
			["lockpick2"] = 500,
			["credential"] = 400,
			["vest"] = 3000,
			["notebook"] = 4000,
			["coketable"] = 4750,
			["weedtable"] = 4750,
			["methtable"] = 4750,
			["nitro"] = 1000

		}
	},
	["mechanicBuy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Mechanic",
		["list"] = {
			["tyres"] = 75,
			["toolbox"] = 175,
			--["WEAPON_CROWBAR"] = 525,
			["WEAPON_WRENCH"] = 525
			--["lockpick"] = 125,
			--["lockpick2"] = 125,
			--["nitro"] = 500
			--["advtoolbox"] = 925
		}
	},
	["weaponsStore"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["pistolbody"] = 425,
			["smgbody"] = 525,
			["riflebody"] = 625
		}
	},
	["oxyStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["oxy"] = 35
		}
	},
	["pharmacyStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["gauze"] = 225,
			--["sinkalmy"] = 375,
			["analgesic"] = 125,
			--["ritmoneury"] = 475,
			["adrenaline"] = 975,
			["saline"] = 50
		}
	},
	["pharmacyParamedic"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedic",
		["list"] = {
			["badge04"] = 10,
			["syringe"] = 10,
			["gauze"] = 100,
			["medkit"] = 525,
			["sinkalmy"] = 225,
			["analgesic"] = 100,
			["ritmoneury"] = 400,
			["wheelchair"] = 500,
			["defibrillator"] = 300,
			["adrenaline"] = 800,
			["divingsuit"] = 800,
			["radio"] = 485,
			["medicbag"] = 425
		}
	},
	["ammunationStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			--["WEAPON_PISTOL_MK2"] = 7000,
			--["WEAPON_PISTOL_AMMO"] = 40,
			["GADGET_PARACHUTE"] = 475,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 725,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_KATANA"] = 975,
			["WEAPON_KARAMBIT"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_FLASHLIGHT"] = 675
		}
	},
	["premiumStore"] = {
		["mode"] = "Buy",
		["type"] = "Premium",
		["list"] = {
			["chip"] = 15,
			["camaro"] = 10,
			--["gemstone"] = 1,
			["premium"] = 40,
			["premium7"] = 10,
			["premiumplate"] = 12,
			["newgarage"] = 10,
			["newchars"] = 25,
			["namechange"] = 15,
			["newlocate"] = 15,
			["rottweiler"] = 15,
			["husky"] = 15,
			["shepherd"] = 15,
			["retriever"] = 15,
			["poodle"] = 15,
			["pug"] = 15,
			["westy"] = 15,
			["cat"] = 15
		}
	},
	["huntingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["meat"] = 20,
			["animalpelt"] = 25,
			--["tomato"] = 8,
			--["banana"] = 6,
			--["wheat"] = 3,
			--["passion"] = 6,
			--["grape"] = 6,
			--["tange"] = 6,
			--["orange"] = 6,
			--["apple"] = 6,
			--["strawberry"] = 6,
			--["coffee2"] = 6,
			["animalfat"] = 10,
			["leather"] = 25
		}
	},
	["hortiSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["wheat"] = 3,
			["coffee2"] = 6,
			["banana"] = 6,
			["orange"] = 6,
			["passion"] = 6,
			["strawberry"] = 6,
			["tange"] = 6,
			["apple"] = 6,
			["tomato"] = 6,
			["grape"] = 6
		}
	},
	["PizzaThis"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "PizzaThis",
		["list"] = {
			["wheat"] = 3,
			["mushroom"] = 10,
			["banana"] = 6,
			["orange"] = 6,
			["passion"] = 6,
			["strawberry"] = 6,
			["tange"] = 6,
			--["apple"] = 6,
			["tomato"] = 6,
			["grape"] = 6
		}
	},
	["fishingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["octopus"] = 20,
			["shrimp"] = 20,
			["carp"] = 18,
			["horsefish"] = 18,
			["tilapia"] = 20,
			["codfish"] = 22,
			["catfish"] = 22,
			["goldenfish"] = 24,
			["pirarucu"] = 24,
			["pacu"] = 24,
			["tambaqui"] = 24
		}
	},
	["huntingStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["switchblade"] = 525,
			["WEAPON_MUSKET"] = 3250,
		--	["WEAPON_SNIPERRIFLE"] = 7250,
			["WEAPON_MUSKET_AMMO"] = 7
		}
	},
	["recyclingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["key"] = 45,
			["bucket"] = 50,
			["notepad"] = 5,
			["plastic"] = 8,
			["glass"] = 8,
			["rubber"] = 8,
			["aluminum"] = 10,
			["techtrash"] = 10,
			["copper"] = 10,
			["radio"] = 485,
			["tablet"] = 150,
			["rope"] = 435,
			["cellphone"] = 285,
			["WEAPON_WRENCH"] = 285,
			["WEAPON_CROWBAR"] = 285,
			["notebook"] = 1000,
			["binoculars"] = 135,
			["emptybottle"] = 15,
			["switchblade"] = 215,
			["camera"] = 135,
			["vape"] = 2375,
			["rose"] = 15,
			["lighter"] = 75,
			["teddy"] = 35,
			["tyres"] = 50,
			["bait"] = 2,
			["firecracker"] = 50,
			["fishingrod"] = 365,
			["divingsuit"] = 485,
			["newspaper"] = 15,
			["silvercoin"] = 20,
			["goldcoin"] = 30
		}
	},
	["minerShop"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["emerald"] = 95,
			["diamond"] = 75,
			["ruby"] = 55,
			["sapphire"] = 50,
			["amethyst"] = 45,
			["amber"] = 40,
			["turquoise"] = 35
		}
	},
	["coffeeMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["coffee"] = 20
		}
	},
	["sodaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["donutMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["donut"] = 15,
			["chocolate"] = 15
		}
	},
	["burgerMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["hamburger"] = 25
		}
	},
	["hotdogMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["hotdog"] = 15
		}
	},
	["Chihuahua"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["hotdog"] = 15,
			["hamburger"] = 25,
			["coffee"] = 20,
			["cola"] = 15,
			["soda"] = 15
		}
	},
	["waterMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["water"] = 30
		}
	},
	["policeStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Police",
		["list"] = {
			["vest"] = 325,
			["gsrkit"] = 35,
			["gdtkit"] = 35,
			["barrier"] = 125,
			["handcuff"] = 425,
			["WEAPON_SMG"] = 3250,
			--["WEAPON_PUMPSHOTGUN"] = 4250,
			["WEAPON_CARBINERIFLE"] = 5250,
			["WEAPON_SMOKEGRENADE"] = 975,
			["WEAPON_CARBINERIFLE_MK2"] = 6250,
			["WEAPON_STUNGUN"] = 2250,
			["WEAPON_COMBATPISTOL"] = 3250,
			["WEAPON_REVOLVER"] = 4500,
			["WEAPON_HEAVYPISTOL"] = 3750,
			["WEAPON_NIGHTSTICK"] = 425,
			["WEAPON_PISTOL_AMMO"] = 8,
			["WEAPON_SMG_AMMO"] = 10,
			["WEAPON_RIFLE_AMMO"] = 12,
			["radio"] = 485,
			--["WEAPON_SHOTGUN_AMMO"] = 15,
			["badge07"] = 10
			--["badge02"] = 10,
			--["badge03"] = 10,
			--["badge05"] = 10,
			--["badge06"] = 10,
			--["badge07"] = 10,
			--["badge08"] = 10,
			--["badge09"] = 10,
			--["badge10"] = 10
		}
	},
	["ilegalHouse"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["keyboard"] = 75,
			["mouse"] = 75,
			["playstation"] = 78,
			["xbox"] = 80,
			["brick"] = 60,
			["dish"] = 75,
			["pan"] = 80,
			["fan"] = 75,
			["blender"] = 75,
			["switch"] = 60,
			["cup"] = 90,
			["lampshade"] = 80
		}
	},
	["ilegalCosmetics"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["silverring"] = 350,
			["goldring"] = 450,
			["watch"] = 350,
			["bracelet"] = 400,
			["dildo"] = 75,
			["spray01"] = 75,
			["spray02"] = 75,
			["spray03"] = 75,
			["spray04"] = 75,
			["sneakers"] = 80,
			["slipper"] = 70,
			["rimel"] = 75,
			["brush"] = 75,
			["soap"] = 70
		}
	},
	["ilegalToys"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["eraser"] = 70,
			["legos"] = 75,
			["ominitrix"] = 75,
			["dices"] = 70,
			["domino"] = 75,
			["floppy"] = 70,
			["horseshoe"] = 75,
			["deck"] = 70
		}
	},
	["ilegalCriminal"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["goldbar"] = 1000,
			["brokenpick"] = 40,
			["pliers"] = 40,
			["pager"] = 110,
			["card01"] = 275,
			["card02"] = 275,
			["card03"] = 300,
			["card04"] = 225,
			["card05"] = 315,
			["pendrive"] = 275
		}
	},
	["Vagosn"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		--["perm"] = "Vagos",
		["list"] = {
			["meth"] = 20
		}
	},
	["Ballasn"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["cocaine"] = 20
		}
	},
	["Familiesn"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["joint"] = 20
		}
	},
	["Triads"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Triads",
		["list"] = {
			["WEAPON_PISTOL_MK2"] = 5000,
			["WEAPON_SMG_MK2"] = 15000
		}
	},
	["TheLost"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "TheLost",
		["list"] = {
			["WEAPON_PISTOL_AMMO"] = 20,
			["WEAPON_SMG_AMMO"] = 20
		}
	},
	["mcFridge"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["dewars"] = 10,
			["chandon"] = 15,
			["hennessy"] = 13,
			["absolut"] = 11,
			["energetic"] = 15
			--["soda"] = 15,
			--["cola"] = 15,
			--["sandwich"] = 15,
			--["fries"] = 15,
			--["donut"] = 15
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- NAMES
-----------------------------------------------------------------------------------------------------------------------------------------
local nameMale = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio" }
local nameFemale = { "Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local userName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
local userLocate = { "Sul","Norte" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		if exports["hud"]:Wanted(user_id,source) then
			return false
		end

		if shops[shopType]["perm"] ~= nil then
			if not vRP.hasGroup(user_id,shops[shopType]["perm"]) then
				return false
			end
		end
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestShop(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local shopSlots = 20
		local inventoryShop = {}
		for k,v in pairs(shops[name]["list"]) do
			table.insert(inventoryShop,{ key = k, price = parseInt(v), name = itemName(k), index = itemIndex(k), peso = itemWeight(k), type = itemType(k), max = itemMaxAmount(k), desc = itemDescription(k) })
		end

		local inventoryUser = {}
		local inventory = vRP.userInventory(user_id)
		for k,v in pairs(inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["type"] = itemType(v["item"])
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			inventoryUser[k] = v
		end

		if parseInt(#inventoryShop) > 20 then
			shopSlots = parseInt(#inventoryShop)
		end

		return inventoryShop,inventoryUser,vRP.inventoryWeight(user_id),vRP.getWeight(user_id),shopSlots
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getShopType(name)
    return shops[name]["mode"]
end---------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionShops(shopType,shopItem,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shops[shopType] then
			if shopAmount == nil then shopAmount = 1 end
			if shopAmount <= 0 then shopAmount = 1 end

			local inventory = vRP.userInventory(user_id)
			if (inventory[tostring(slot)] and inventory[tostring(slot)]["item"] == shopItem) or inventory[tostring(slot)] == nil then
				if shops[shopType]["mode"] == "Buy" then
					if vRP.checkMaxItens(user_id,shopItem,shopAmount) then
						TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
						vCLIENT.updateShops(source,"requestShop")
						return
					end

					if (vRP.inventoryWeight(user_id) + (itemWeight(shopItem) * parseInt(shopAmount))) <= vRP.getWeight(user_id) then
						if shops[shopType]["type"] == "Cash" then
							if shops[shopType]["list"][shopItem] then
								if vRP.paymentFull(user_id,shops[shopType]["list"][shopItem] * shopAmount) then
									if shopItem == "identity" or string.sub(shopItem,1,5) == "badge" then
										vRP.generateItem(user_id,shopItem.."-"..user_id,parseInt(shopAmount),false,slot)
										TriggerEvent("discordLogs","Compra","Passaporte **"..user_id.."** Comprou "..parseInt(shopAmount).."x "..shopItem.." por "..shops[shopType]["list"][shopItem] * shopAmount.." dólares.",3092790)

									elseif shopItem == "fidentity" then
										local identity = vRP.userIdentity(user_id)
										if identity then
											if identity["sex"] == "M" then
												vRP.execute("fidentity/newIdentity",{ name = nameMale[math.random(#nameMale)], name2 = userName2[math.random(#userName2)], locate = userLocate[math.random(#userLocate)], blood = math.random(4) })
											else
												vRP.execute("fidentity/newIdentity",{ name = nameFemale[math.random(#nameFemale)], name2 = userName2[math.random(#userName2)], locate = userLocate[math.random(#userLocate)], blood = math.random(4) })
											end

											local identity = vRP.userIdentity(user_id)
											local consult = vRP.query("fidentity/lastIdentity")
											if consult[1] then
												vRP.generateItem(user_id,shopItem.."-"..consult[1]["id"],parseInt(shopAmount),false,slot)
												TriggerEvent("discordLogs","Compra","Passaporte **"..user_id.."** Comprou "..parseInt(shopAmount).."x "..shopItem.." por "..shops[shopType]["list"][shopItem] * shopAmount.." dólares.",3092790)

											end
										end
									else
										vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
										TriggerEvent("discordLogs","Compra","Passaporte **"..user_id.."** Comprou "..parseInt(shopAmount).."x "..shopItem.." por "..shops[shopType]["list"][shopItem] * shopAmount.." dólares.",3092790)

									end

									TriggerClientEvent("sounds:source",source,"cash",0.1)
								else
									TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
								end
							end
						elseif shops[shopType]["type"] == "Consume" then
							if vRP.tryGetInventoryItem(user_id,shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem] * shopAmount)) then
								vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
								TriggerEvent("discordLogs","Compra","Passaporte **"..user_id.."** Comprou "..parseInt(shopAmount).."x "..shopItem.." por "..shops[shopType]["list"][shopItem] * shopAmount.." dólares.",3092790)
								TriggerClientEvent("sounds:source",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(shops[shopType]["item"]).."</b> insuficiente.",5000)
							end
						elseif shops[shopType]["type"] == "Premium" then
							if vRP.paymentGems(user_id,shops[shopType]["list"][shopItem] * shopAmount) then
								TriggerClientEvent("sounds:source",source,"cash",0.1)
								vRP.generateItem(user_id,shopItem,parseInt(shopAmount),false,slot)
								TriggerClientEvent("Notify",source,"verde","Comprou <b>"..parseFormat(shopAmount).."x "..itemName(shopItem).."</b> por <b>"..parseFormat(shops[shopType]["list"][shopItem] * shopAmount).." Gemas</b>.",5000)
								TriggerEvent("discordLogs","Compra","Passaporte **"..user_id.."** Comprou "..parseFormat(shopAmount).."x "..itemName(shopItem).." por "..parseFormat(shops[shopType]["list"][shopItem] * shopAmount).." gemas.",3092790)
							else
								TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
							end
						end
					else
						TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					end
				elseif shops[shopType]["mode"] == "Sell" then
					local splitName = splitString(shopItem,"-")

					if shops[shopType]["list"][splitName[1]] then
						local itemPrice = shops[shopType]["list"][splitName[1]]

						if itemPrice > 0 then
							if vRP.checkBroken(shopItem) then
								if vRP.tryGetInventoryItem(user_id,shopItem,parseInt(shopAmount),true,slot) then
									vRP.generateItem(user_id,"dollars",parseInt(itemPrice * shopAmount * 0.4),false)
									TriggerClientEvent("sounds:source",source,"cash",0.1)
									TriggerEvent("discordLogs","Venda","Passaporte **"..user_id.."** Vendeu "..parseInt(shopAmount).."x "..shopItem.." por "..parseInt(itemPrice * shopAmount * 0.4).." dólares.",3092790)						
								end
							end
						end

						if shops[shopType]["type"] == "Cash" then
							if vRP.tryGetInventoryItem(user_id,shopItem,parseInt(shopAmount),true,slot) then
								if itemPrice > 0 then
									vRP.generateItem(user_id,"dollars",parseInt(itemPrice * shopAmount),false)
									TriggerClientEvent("sounds:source",source,"cash",0.1)
									TriggerEvent("discordLogs","Venda","Passaporte **"..user_id.."** Vendeu "..parseInt(shopAmount).."x "..shopItem.." por "..parseInt(itemPrice * shopAmount).." dólares.",3092790)
								end
							end
						elseif shops[shopType]["type"] == "Consume" then
							if vRP.tryGetInventoryItem(user_id,shopItem,parseInt(shopAmount),true,slot) then
								if itemPrice > 0 then
									vRP.generateItem(user_id,shops[shopType]["item"],parseInt(itemPrice * shopAmount),false)
									TriggerClientEvent("sounds:source",source,"cash",0.1)
									TriggerEvent("discordLogs","Venda","Passaporte **"..user_id.."** Vendeu "..parseInt(shopAmount).."x "..shopItem.." por "..parseInt(itemPrice * shopAmount).." dólares.",3092790)
								end
							end
						end
					end
				end
			end
		else
			print(shopType,shopItem,shopAmount,slot)
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:populateSlot")
AddEventHandler("shops:populateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
			vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:updateSlot")
AddEventHandler("shops:updateSlot",function(nameItem,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inventory = vRP.userInventory(user_id)
		if inventory[tostring(slot)] and inventory[tostring(target)] and inventory[tostring(slot)]["item"] == inventory[tostring(target)]["item"] then
			if vRP.tryGetInventoryItem(user_id,nameItem,amount,false,slot) then
				vRP.giveInventoryItem(user_id,nameItem,amount,false,target)
			end
		else
			vRP.swapSlot(user_id,slot,target)
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DIVINGSUIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:divingSuit")
AddEventHandler("shops:divingSuit",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.request(source,"Comprar <b>Roupa de Mergulho</b> por <b>$975</b>?") then
			if vRP.paymentFull(user_id,975) then
				vRP.generateItem(user_id,"divingsuit",1,true)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end)