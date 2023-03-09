-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("robberys",cRP)
vCLIENT = Tunnel.getInterface("robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYAVAILABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local robberyAvailable = {
	["departamentStore"] = os.time(),
	["ammunation"] = os.time(),
	["fleecas"] = os.time(),
	["barbershop"] = os.time(),
	["banks"] = os.time()
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
local robberys = {
	["1"] = {
		["coords"] = { 31.24,-1339.3,29.49 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["2"] = {
		["coords"] = { 2549.5,387.84,108.61 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["3"] = {
		["coords"] = { 1159.156,-314.055,69.21 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["4"] = {
		["coords"] = { -710.067,-904.091,19.22 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["5"] = {
		["coords"] = { -43.652,-1748.122,29.43 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["6"] = {
		["coords"] = { 381.02,332.55,103.56 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["7"] = {
		["coords"] = { -3249.75,1007.37,12.82 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["8"] = {
		["coords"] = { 1737.47,6419.5,35.03 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["9"] = {
		["coords"] = { 543.78,2662.57,42.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["10"] = {
		["coords"] = { 1961.7,3750.23,32.33 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["11"] = {
		["coords"] = { 2674.19,3289.24,55.23 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["12"] = {
		["coords"] = { 1708.095,4920.711,42.07 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["13"] = {
		["coords"] = { -1829.422,798.491,138.2 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["14"] = {
		["coords"] = { -2959.66,386.765,14.05 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["15"] = {
		["coords"] = { -3048.72,588.45,7.9 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["16"] = {
		["coords"] = { 1126.75,-979.760,45.42 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["17"] = {
		["coords"] = { 1169.631,2717.833,37.16 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["18"] = {
		["coords"] = { -1478.67,-375.675,39.17 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["19"] = {
		["coords"] = { -1221.126,-916.213,11.33 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["20"] = {
		["coords"] = { 170.99,6642.57,31.69 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["21"] = {
		["coords"] = { -168.42,6318.8,30.58 },
		["name"] = "Loja de Departamento",
		["type"] = "departamentStore",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card01",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 5,
		["payment"] = {
			{ "dollarsz",60000,70000 }
		}
	},
	["22"] = {
		["coords"] = { 1698.04,3757.44,34.69 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["23"] = {
		["coords"] = { 246.76,-51.37,69.94 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["24"] = {
		["coords"] = { 841.09,-1028.66,28.19 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["25"] = {
		["coords"] = { -326.0,6081.2,31.46 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["26"] = {
		["coords"] = { -660.987,-933.901,21.83 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["27"] = {
		["coords"] = { -659.09,-939.92,21.82 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["28"] = {
		["coords"] = { -1112.36,2697.14,18.55 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["29"] = {
		["coords"] = { 2564.81,299.04,108.73 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["30"] = {
		["coords"] = { -3166.93,1086.95,20.84 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["31"] = {
		["coords"] = { 18.82,-1108.21,29.79 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["32"] = {
		["coords"] = { 812.93,-2155.14,29.62 },
		["name"] = "Loja de Armas",
		["type"] = "ammunation",
		["distance"] = 10.0,
		["cooldown"] = 45,
		["item"] = "card02",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",30000,35000 }
		}
	},
	["33"] = {
		["coords"] = { -1210.409,-336.485,38.29 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 5,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["34"] = {
		["coords"] = { -353.519,-55.518,49.54 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["35"] = {
		["coords"] = { 311.525,-284.649,54.67 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["36"] = {
		["coords"] = { 147.210,-1046.292,29.87 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["37"] = {
		["coords"] = { -2956.449,482.090,16.2 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Sul",
		["timer"] = 420,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["38"] = {
		["coords"] = { 1175.66,2712.939,38.59 },
		["name"] = "Banco Fleeca",
		["type"] = "fleecas",
		["distance"] = 10.0,
		["cooldown"] = 180,
		["item"] = "card03",
		["locate"] = "Norte",
		["timer"] = 420,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",200,230 }
		}
	},
	["39"] = {
		["coords"] = { -808.36,-179.82,37.56 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["40"] = {
		["coords"] = { 136.42,-1709.94,29.28 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["41"] = {
		["coords"] = { -1284.5,-1118.04,6.99 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["42"] = {
		["coords"] = { 1933.34,3729.25,32.84 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["43"] = {
		["coords"] = { 1210.53,-473.12,66.2 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["44"] = {
		["coords"] = { -33.25,-150.52,57.07 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Sul",
		["timer"] = 300,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["45"] = {
		["coords"] = { -280.03,6228.82,31.69 },
		["name"] = "Barbearia",
		["type"] = "barbershop",
		["distance"] = 10.0,
		["cooldown"] = 60,
		["item"] = "card04",
		["locate"] = "Norte",
		["timer"] = 360,
		["cops"] = 3,
		["payment"] = {
			{ "dollarsz",7500,12000 }
		}
	},
	["46"] = {
		["coords"] = { -96.8,6459.86,31.63 },
		["name"] = "Saving Bank",
		["type"] = "banks",
		["distance"] = 10.0,
		["cooldown"] = 360,
		["item"] = "card05",
		["locate"] = "Norte",
		["timer"] = 900,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",175,225 }
		}
	},
	["47"] = {
		["coords"] = { 265.336,220.184,102.09 },
		["name"] = "Vinewood Vault",
		["type"] = "banks",
		["distance"] = 20.0,
		["cooldown"] = 360,
		["item"] = "card05",
		["locate"] = "Sul",
		["timer"] = 900,
		["cops"] = 7,
		["payment"] = {
			{ "goldbar",175,225 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robberys[robberyId] then
			local prev = robberys[robberyId]

			if os.time() >= robberyAvailable[prev["type"]] then
				local policeResult = vRP.numPermission("Police")
				if parseInt(#policeResult) >= parseInt(prev["cops"]) then
					local consultItem = vRP.getInventoryItemAmount(user_id,prev["item"])
					if consultItem[1] <= 0 then
						TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x "..itemName(prev["item"]).."</b>.",5000)
						return false
					end

					if vRP.checkBroken(consultItem[2]) then
						TriggerClientEvent("Notify",source,"vermelho","<b>"..itemName(prev["item"]).."</b> quebrado.",5000)
						return false
					end

					if vRP.tryGetInventoryItem(user_id,consultItem[2],1) then
						robberyAvailable[prev["type"]] = os.time() + (prev["cooldown"] * 60)
						TriggerClientEvent("player:applyGsr",source)

						for k,v in pairs(policeResult) do
							async(function()
								TriggerClientEvent("NotifyPush",v,{ code = 31, title = prev["name"], x = prev["coords"][1], y = prev["coords"][2], z = prev["coords"][3], time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
								vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
							end)
						end

						return true
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Policiais insuficientes.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentRobbery(robberyId)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,10)
		TriggerEvent("Wanted",source,user_id,900)

		local identity = vRP.userIdentity(user_id)
		for k,v in pairs(robberys[robberyId]["payment"]) do
			local value = math.random(v[2],v[3])
			vRP.generateItem(user_id,v[1],parseInt(value),true)

			if robberys[robberyId]["locate"] ~= identity["locate"] then
				vRP.generateItem(user_id,v[1],parseInt(value * 0.1),true)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnect",function(user_id,source)
	vCLIENT.inputRobberys(source,robberys)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:JEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
local jewelryShowcase = {}
local jewelryTimers = os.time()
local jewelryCooldowns = os.time()
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:INITJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("robberys:initJewelry")
AddEventHandler("robberys:initJewelry",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if os.time() >= jewelryCooldowns then
			local policeResult = vRP.numPermission("Police")
			if parseInt(#policeResult) >= 8 then
				local consultItem = vRP.getInventoryItemAmount(user_id,"pendrive")
				if consultItem[1] <= 0 then
					TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>1x Pendrive</b>.",5000)
					return false
				end

				if vRP.checkBroken(consultItem[2]) then
					TriggerClientEvent("Notify",source,"vermelho","<b>Pendrive</b> quebrado.",5000)
					return false
				end

				if vRP.tryGetInventoryItem(user_id,consultItem[2],1) then
					TriggerClientEvent("Notify",source,"verde","Sistema corrompido.",5000)
					jewelryCooldowns = os.time() + 7200
					jewelryTimers = os.time() + 600
					jewelryShowcase = {}

					for k,v in pairs(policeResult) do
						async(function()
							TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Joalheria", x = -633.07, y = -238.7, z = 38.06, time = "Recebido às "..os.date("%H:%M"), blipColor = 22 })
							vRPC.playSound(v,"Beep_Green","DLC_HEIST_HACKING_SNAKE_SOUNDS")
						end)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERYS:JEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("robberys:jewelry")
AddEventHandler("robberys:jewelry",function(entity)
	local source = source
	local showcase = entity[1]
	local user_id = vRP.getUserId(source)
	if user_id then
		if os.time() <= jewelryTimers then
			if jewelryShowcase[showcase] == nil then
				jewelryShowcase[showcase] = true
				TriggerClientEvent("vRP:Cancel",source,true)
				vRPC.playAnim(source,false,{"oddjobs@shop_robbery@rob_till","loop"},true)

				SetTimeout(20000,function()
					vRPC.stopAnim(source,false)
					vRP.upgradeStress(user_id,10)
					TriggerEvent("Wanted",source,user_id,60)
					TriggerClientEvent("vRP:Cancel",source,false)
					vRP.generateItem(user_id,"watch",math.random(20,30),true)
				end)
			else
				TriggerClientEvent("Notify",source,"azul","Vitrine vazia.",3000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Necessário corromper o sistema.",3000)
		end
	end
end)