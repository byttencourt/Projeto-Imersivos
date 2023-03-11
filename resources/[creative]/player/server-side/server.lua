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
Tunnel.bindInterface("player",cRP)
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Objects = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("me",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] then
		local message = string.sub(rawCommand:sub(4),1,100)

		local activePlayers = vRPC.activePlayers(source)
		for _,v in ipairs(activePlayers) do
			async(function()
				TriggerClientEvent("showme:pressMe",v,source,message,10)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("upgradeStress")
AddEventHandler("upgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("downgradeStress")
AddEventHandler("downgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.downgradeStress(user_id,number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:KICKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:kickSystem")
AddEventHandler("player:kickSystem",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasGroup(user_id,"Admin") then
			vRP.kick(user_id,message)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) > 101 then
			if args[2] == "friend" then
				local otherPlayer = vRPC.nearestPlayer(source)
				if otherPlayer then
					if vRP.getHealth(otherPlayer) > 101 and not vCLIENT.getHandcuff(otherPlayer) then
						local identity = vRP.userIdentity(user_id)
						if vRP.request(otherPlayer,"Pedido de <b>"..identity["name"].."</b> da animação <b>"..args[1].."</b>?") then
							TriggerClientEvent("emotes",otherPlayer,args[1])
							TriggerClientEvent("emotes",source,args[1])
						end
					end
				end
			else
				TriggerClientEvent("emotes",source,args[1])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and vRP.getHealth(source) > 101 then
			local otherPlayer = vRPC.nearestPlayer(source)
			if otherPlayer then
				if vRP.hasGroup(user_id,"Paramedic") then
					TriggerClientEvent("emotes",otherPlayer,args[1])
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:Doors")
AddEventHandler("player:Doors",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle,vehNet = vRPC.vehList(source,5)
		if vehicle then
			local activePlayers = vRPC.activePlayers(source)
			for _,v in ipairs(activePlayers) do
				async(function()
					TriggerClientEvent("player:syncDoors",v,vehNet,number)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.receiveSalary()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userPremium(user_id) then
			TriggerEvent("vRP:updateSalary",user_id,1500)
			TriggerClientEvent("Notify",source,"azul","Salário de Vip: <b>$1500</b> recebido.",5000)
		end
		if vRP.hasGroup(user_id,"Emergency") then
			TriggerEvent("vRP:updateSalary",user_id,2500)
			TriggerClientEvent("Notify",source,"azul","Salário de Funcionário Público: <b>$2.500</b> recebido.",5000)
		end
		if vRP.hasGroup(user_id,"Mechanic") then
			TriggerEvent("vRP:updateSalary",user_id,1250)
			TriggerClientEvent("Notify",source,"azul","Salário de Mecânico: <b>$1250</b> recebido.",5000)
		end
		if vRP.hasGroup(user_id,"LosSantos") then
			TriggerEvent("vRP:updateSalary",user_id,1250)
			TriggerClientEvent("Notify",source,"azul","Salário de Mecânico: <b>$1250</b> recebido.",5000)
		end
		if vRP.hasGroup(user_id,"Admin") then
			TriggerEvent("vRP:updateSalary",user_id,1000)
			TriggerClientEvent("Notify",source,"azul","Salário de Administrador: <b>$1000</b> recebido.",5000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("911",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and vRP.getHealth(source) > 101 then
			if vRP.hasGroup(user_id,"Police") then
				local department = "Police"
				if vRP.hasPermission(user_id,"State") then
					department = "STATE POLICE"
				elseif vRP.hasPermission(user_id,"Lspd") then
					department = "LSPD"
				elseif vRP.hasPermission(user_id,"Ranger") then
					department = "PARK RANGER"
				elseif vRP.hasPermission(user_id,"Corrections") then
					department = "CORRECTIONS"
				elseif vRP.hasPermission(user_id,"Sheriff") then
					department = "SHERIFF"
				end

				local identity = vRP.userIdentity(user_id)
				local policeResult = vRP.numPermission("Police")
				for k,v in pairs(policeResult) do
					async(function()
						TriggerClientEvent("chatME",v,"^2911^3"..department.."^9"..identity["name"].."^0"..rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 112
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("112",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and vRP.getHealth(source) > 101 then
			if vRP.hasGroup(user_id,"Paramedic") then
				local identity = vRP.userIdentity(user_id)
				local paramedicResult = vRP.numPermission("Paramedic")
				for k,v in pairs(paramedicResult) do
					async(function()
						TriggerClientEvent("chatME",v,"^4112^9"..identity["name"].." "..identity["name2"].."^0"..rawCommand:sub(4))
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.shotsFired()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		local policeResult = vRP.numPermission("Police")

		for k,v in pairs(policeResult) do
			async(function()
				vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
				TriggerClientEvent("NotifyPush",v,{ code = 10, title = "Confronto em andamento", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Disparos de arma de fogo", blipColor = 6 })
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CARRYPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
local playerCarry = {}
RegisterServerEvent("player:carryPlayer")
AddEventHandler("player:carryPlayer",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRPC.inVehicle(source) then
			if playerCarry[user_id] then
				TriggerClientEvent("player:playerCarry",playerCarry[user_id],source)
				TriggerClientEvent("player:Commands",playerCarry[user_id],false)
				playerCarry[user_id] = nil
			else
				local otherPlayer = vRPC.nearestPlayer(source)
				if otherPlayer then
					playerCarry[user_id] = otherPlayer

					TriggerClientEvent("player:playerCarry",playerCarry[user_id],source)
					TriggerClientEvent("player:Commands",playerCarry[user_id],true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if playerCarry[user_id] then
		TriggerClientEvent("player:Commands",playerCarry[user_id],false)
		playerCarry[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:WINSFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:winsFunctions")
AddEventHandler("player:winsFunctions",function(mode)
	local source = source
	local vehicle,vehNet = vRPC.vehSitting(source)
	if vehicle then
		local activePlayers = vRPC.activePlayers(source)
		for _,v in ipairs(activePlayers) do
			async(function()
				TriggerClientEvent("player:syncWins",v,vehNet,mode)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(mode)
	local source = source
	local distance = 1.1

	if mode == "rv" then
		distance = 10.0
	end

	local otherPlayer = vRPC.nearestPlayer(source,distance)
	if otherPlayer then
		local user_id = vRP.getUserId(source)
		local consultItem = vRP.getInventoryItemAmount(user_id,"rope")
		if vRP.hasGroup(user_id,"Emergency") or consultItem[1] >= 1 then
			local vehicle,vehNet = vRPC.vehList(source,5)
			if vehicle then
				local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
				local doorStatus = GetVehicleDoorLockStatus(idNetwork)
			
				if parseInt(doorStatus) <= 1 then
					if mode == "rv" then
						vCLIENT.removeVehicle(otherPlayer)
					elseif mode == "cv" then
						vCLIENT.putVehicle(otherPlayer,vehNet)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local preset = {
	["1"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 196, texture = 0 },
			["pants"] = { item = 133, texture = 1 },
			["vest"] = { item = 33, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 201, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 119, texture = 1 },
			["torso"] = { item = 333, texture = 4 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 36, texture = 4 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 145, texture = 0 },
			["pants"] = { item = 178, texture = 1 },
			["vest"] = { item = 28, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 171, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 163, texture = 0 },
			["torso"] = { item = 343, texture = 4 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 38, texture = 4 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 19, texture = 0 },
			["pants"] = { item = 133, texture = 1 },
			["vest"] = { item = 7, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 201, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 119, texture = 1 },
			["torso"] = { item = 333, texture = 4 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 36, texture = 4 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 19, texture = 0 },
			["pants"] = { item = 178, texture = 1 },
			["vest"] = { item = 7, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 171, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 170, texture = 0 },
			["torso"] = { item = 343, texture = 4 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 23, texture = 0 },
			["glass"] = { item = 38, texture = 4 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["3"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 0, texture = 0 },
			["pants"] = { item = 129, texture = 3 },
			["vest"] = { item = 28, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 117, texture = 0 },
			["torso"] = { item = 325, texture = 0 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 3, texture = 11 },
			["vest"] = { item = 24, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 38, texture = 0 },
			["torso"] = { item = 338, texture = 0 },
			["accessory"] = { item = 70, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["4"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 17, texture = 1 },
			["pants"] = { item = 113, texture = 1 },
			["vest"] = { item = 28, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 201, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 131, texture = 0 },
			["torso"] = { item = 313, texture = 21 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 17, texture = 1 },
			["pants"] = { item = 73, texture = 1 },
			["vest"] = { item = 24, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 50, texture = 0 },
			["tshirt"] = { item = 62, texture = 0 },
			["torso"] = { item = 315, texture = 21 },
			["accessory"] = { item = 70, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["5"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 195, texture = 0 },
			["pants"] = { item = 129, texture = 3 },
			["vest"] = { item = 32, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 156, texture = 0 },
			["torso"] = { item = 325, texture = 0 },
			["accessory"] = { item = 6, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 3, texture = 11 },
			["vest"] = { item = 27, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 173, texture = 0 },
			["torso"] = { item = 339, texture = 0 },
			["accessory"] = { item = 70, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 28, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["6"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 101, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 22, texture = 0 },
			["tshirt"] = { item = 203, texture = 0 },
			["torso"] = { item = 228, texture = 0 },
			["accessory"] = { item = 241, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 80, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 175, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 17, texture = 0 },
			["tshirt"] = { item = 228, texture = 0 },
			["torso"] = { item = 220, texture = 0 },
			["accessory"] = { item = 39, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 85, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["7"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 182, texture = 0 },
			["pants"] = { item = 182, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 59, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 116, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 362, texture = 1 },
			["accessory"] = { item = 241, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 90, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 131, texture = 0 },
			["pants"] = { item = 147, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 69, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 117, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 370, texture = 1 },
			["accessory"] = { item = 39, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 88, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["8"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 101, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 22, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 384, texture = 0 },
			["accessory"] = { item = 241, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 85, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 175, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 17, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 393, texture = 0 },
			["accessory"] = { item = 39, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 96, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["9"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 105, texture = 7 },
			["pants"] = { item = 167, texture = 23 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 16, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 363, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 88, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 54, texture = 7 },
			["pants"] = { item = 131, texture = 23 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 71, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 371, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 101, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["10"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 175, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 88, texture = 1 },
			["shoes"] = { item = 132, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 356, texture = 3 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 159, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 139, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 54, texture = 0 },
			["shoes"] = { item = 86, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 364, texture = 3 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 18, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["11"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 195, texture = 0 },
			["pants"] = { item = 129, texture = 3 },
			["vest"] = { item = 32, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 156, texture = 0 },
			["torso"] = { item = 322, texture = 0 },
			["accessory"] = { item = 6, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 3, texture = 11 },
			["vest"] = { item = 27, texture = 3 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 173, texture = 0 },
			["torso"] = { item = 338, texture = 0 },
			["accessory"] = { item = 70, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["12"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = 106, texture = 0 },
			["pants"] = { item = 129, texture = 2 },
			["vest"] = { item = 28, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 90, texture = 0 },
			["tshirt"] = { item = 128, texture = 0 },
			["torso"] = { item = 303, texture = 13 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 26, texture = 0 },
			["glass"] = { item = 5, texture = 1 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = 55, texture = 0 },
			["pants"] = { item = 3, texture = 12 },
			["vest"] = { item = 24, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 41, texture = 0 },
			["tshirt"] = { item = 38, texture = 0 },
			["torso"] = { item = 315, texture = 22 },
			["accessory"] = { item = 70, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 27, texture = 0 },
			["glass"] = { item = 11, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:presetFunctions")
AddEventHandler("player:presetFunctions",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Emergency") and not exports["hud"]:Repose(user_id) then
			local model = vRP.modelPlayer(source)

			if model == "mp_m_freemode_01" or "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,preset[number][model])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local otherPlayer = vRPC.nearestPlayer(source)
	if otherPlayer then
		TriggerClientEvent("player:checkTrunk",otherPlayer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	local source = source
	local otherPlayer = vRPC.nearestPlayer(source,1)
	if otherPlayer then
		TriggerClientEvent("player:checkTrash",otherPlayer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["homem"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 14, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 99, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	},
	["mulher"] = {
		["hat"] = { item = -1, texture = 0 },
		["pants"] = { item = 15, texture = 0 },
		["vest"] = { item = 0, texture = 0 },
		["backpack"] = { item = 0, texture = 0 },
		["bracelet"] = { item = -1, texture = 0 },
		["decals"] = { item = 0, texture = 0 },
		["mask"] = { item = 0, texture = 0 },
		["shoes"] = { item = 51, texture = 0 },
		["tshirt"] = { item = 15, texture = 0 },
		["torso"] = { item = 15, texture = 0 },
		["accessory"] = { item = 0, texture = 0 },
		["watch"] = { item = -1, texture = 0 },
		["arms"] = { item = 15, texture = 0 },
		["glass"] = { item = 0, texture = 0 },
		["ear"] = { item = -1, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:outfitFunctions")
AddEventHandler("player:outfitFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and not exports["hud"]:Repose(user_id) and not exports["hud"]:Wanted(user_id) then
		if mode == "aplicar" then
			local result = vRP.getSrvdata("saveClothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif mode == "preaplicar" then
			if vRP.userPremium(user_id) then
				local result = vRP.getSrvdata("premClothes:"..user_id)
				if result["pants"] ~= nil then
					TriggerClientEvent("updateRoupas",source,result)
					TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
				else
					TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
				end
			end
		elseif mode == "salvar" then
			local checkBackpack = vSKINSHOP.checkBackpack(source)
			if not checkBackpack then
				local custom = vSKINSHOP.getCustomization(source)
				if custom then
					vRP.setSrvdata("saveClothes:"..user_id,custom)
					TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Remova do corpo o acessório item.",5000)
			end
		elseif mode == "presalvar" then
			if vRP.userPremium(user_id) then
				local checkBackpack = vSKINSHOP.checkBackpack(source)
				if not checkBackpack then
					local custom = vSKINSHOP.getCustomization(source)
					if custom then
						vRP.setSrvdata("premClothes:"..user_id,custom)
						TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Remova do corpo o acessório item.",5000)
				end
			end
		elseif mode == "remover" then
			local model = vRP.modelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["mulher"])
			end
		else
			TriggerClientEvent("skinshop:set"..mode,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("contratar",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and parseInt(args[2]) > 0 then
			local Group = args[1]
			local nuser_id = parseInt(args[2])

			local identity = vRP.userIdentity(nuser_id)
			if identity then
				if vRP.hasPermission(user_id,"set"..Group) then
					vRP.cleanPermission(nuser_id)
					vRP.setPermission(nuser_id,Group)
					TriggerClientEvent("Notify",source,"verde","Passaporte <b>"..nuser_id.."</b> adicionado.",5000)
					TriggerEvent("discordLogs","group","**Passaporte:** "..user_id.."\n**Contratou o passaporte :** "..args[2].." no Grupo** "..args[1].."**\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("demitir",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] and parseInt(args[2]) > 0 then
			local Group = args[1]
			local nuser_id = parseInt(args[2])

			local identity = vRP.userIdentity(nuser_id)
			if identity then
				if vRP.hasPermission(user_id,"set"..Group) then
					vRP.cleanPermission(nuser_id)
					TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..nuser_id.."</b> removido.",5000)
					TriggerEvent("discordLogs","ungroup","**Passaporte:** "..user_id.."\n**Demitiu o passaporte :** "..args[2].." no Grupo** "..args[1].."**\n**Horário:** "..os.date("%H:%M:%S"),3092790)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEMITIDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("demitido",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and parseInt(args[1]) > 0 then
			local nuser_id = parseInt(args[1])

			local identity = vRP.userIdentity(nuser_id)
			if identity then
				vRP.cleanPermission(nuser_id)
				TriggerClientEvent("Notify",source,"amarelo","Passaporte <b>"..nuser_id.."</b>. Teve todas as permissões removidas.",5000)
				TriggerEvent("discordLogs","ungroup","**Passaporte:** "..user_id.."\n**Removeu as permissões do passaporte :** "..args[1].."**\nHorário:** "..os.date("%H:%M:%S"),3092790)	
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEATHLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:deathLogs")
AddEventHandler("player:deathLogs",function(nSource)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and source ~= nSource then
		local nuser_id = vRP.getUserId(nSource)
		if nuser_id then
			TriggerEvent("discordLogs","Deaths","**Quem Matou:** "..user_id.."\n**Quem Morreu:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLINKS
-----------------------------------------------------------------------------------------------------------------------------------------
local discordLinks = {
	["Disconnect"] = "",
	["Airport"] = "",
	["Deaths"] = "",
	["Police"] = "",
	["State"] = "",
	["Lspd"] = "",
	["Sheriff"] = "",
	["Ranger"] = "",
	["Corrections"] = "",
	["Paramedic"] = "",
	["Hackers"] = "",
	["Gemstones"] = "",
	["Badges"] = "",
	["Admin"] = "",
	["Drop"] = "",
	["Enviar"] = "",
	["Pegar"] = "",
	["Wall"] = "",
	["group"] = "",
	["ungroup"] = "",
	["Car"] = "",
	["Bloods"] = "",
	["Families"] = "",
	["Vagos"] = "",
	["Ballas"] = "",
	["Triads"] = "",
	["Vinhedo"] = "",
	["Aztecas"] = "",
	["TheLost"] = "",
	["Playboy"] = "",
	["EastSide"] = "",
	["LosSantos"] = "",
	["Mechanic"] = "",
	["Desserts"] = "",
	["Salieris"] = "",
	["Vanilla"] = "",
	["Staff"] = "",
	["Revistar"] = "",
	["Transfer"] = "",
	["sellcar"] = "",
	["buycar"] = "",
	["Compra"] = "",
	["Venda"] = "",
	["Craft"] = "",
	["Trunk"] = "",
	["Penitenciaria"] = ""


}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs",function(webhook,message,color)
	PerformHttpRequest(discordLinks[webhook],function(err,text,headers) end,"POST",json.encode({
		username = "Imersivos Roleplay",
		embeds = { { color = color, description = message } }
	}),{ ["Content-Type"] = "application/json" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIKESBACKPACK
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.bikesBackpack()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local amountWeight = 10
		local myWeight = vRP.getWeight(user_id)

		if parseInt(myWeight) < 45 then
			amountWeight = 15
		elseif parseInt(myWeight) >= 45 and parseInt(myWeight) <= 79 then
			amountWeight = 10
		elseif parseInt(myWeight) >= 80 and parseInt(myWeight) <= 95 then
			amountWeight = 5
		elseif parseInt(myWeight) >= 100 and parseInt(myWeight) <= 148 then
			amountWeight = 2
		elseif parseInt(myWeight) >= 150 then
			amountWeight = 1
		end

		vRP.setWeight(user_id,amountWeight)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:IDENTITYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:identityFunctions")
AddEventHandler("player:identityFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.userIdentity(user_id)
		if identity then
			local port = "Não"
			if identity["port"] >= 1 then
				port = "Sim"
			end

			local premium = "Não"
			local infoAccount = vRP.infoAccount(identity["steam"])
			if infoAccount and parseInt(os.time()) <= parseInt(infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
				premium = minimalTimers(86400 * infoAccount["predays"] - (os.time() - infoAccount["premium"]))
			end

			TriggerClientEvent("Notify",source,"default","<b>Passaporte:</b> "..parseFormat(user_id).."<br><b>Nome:</b> "..identity["name"].." "..identity["name2"].."<br><b>Gemas:</b> "..parseFormat(vRP.userGemstone1(user_id)).."<br><b>Maximo de Veículos:</b> "..identity["garage"].."<br><b>Porte de Armamento:</b> "..port.."<br><b>Premium:</b> "..premium,10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:IDENTITYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rg",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local nuser_id = parseInt(args[1])
	local playerBankMoney = vRP.getBank(nuser_id)
   	if nuser_id and vRP.hasPermission(user_id,"Admin") then
		local identity = vRP.userIdentity(nuser_id)
		if identity then
			local port = "Não"
			if identity["port"] >= 1 then
				port = "Sim"
			end

			local premium = "Não"
			local infoAccount = vRP.infoAccount(identity["steam"])
			if infoAccount and parseInt(os.time()) <= parseInt(infoAccount["premium"] + 24 * infoAccount["predays"] * 60 * 60) then
				premium = minimalTimers(86400 * infoAccount["predays"] - (os.time() - infoAccount["premium"]))
			end

			TriggerClientEvent("Notify",source,"default","<b>Passaporte:</b> "..parseFormat(nuser_id).."<br><b>Nome:</b> "..identity["name"].." "..identity["name2"].."<br><b>Gemas:</b> "..parseFormat(vRP.userGemstone1(nuser_id)).."<br><b>Conta Bancária:</b> "..playerBankMoney.."<br><b>Maximo de Veículos:</b> "..identity["garage"].."<br><b>Porte de Armamento:</b> "..port.."<br><b>Premium:</b> "..premium,10000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- sons
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("sons",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			vRPC.playSound(source,"Event_Start_Text","GTAO_FM_Events_Soundset")

		end
			
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("anuncio",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Admin") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>AVISO: </b>"..message[1]..".<br>Enviado por:<b> GOVERNADOR.</b>",60000)
		end
	end		
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cat",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Desserts") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>AVISO: </b>"..message[1]..".<br>Enviado por:<b> Cat-Café.</b>",30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("mec",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Mechanic") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>AVISO: </b>"..message[1]..".<br>Enviado por:<b> Benny`s Original Motorworks.</b>",30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lossantos",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"LosSantos") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>AVISO: </b>"..message[1]..".<br>Enviado por:<b> Los Santos Customs.</b>",30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lspd",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Lspd") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>LSPD Informa: </b>"..message[1]..".<br>Enviado por:<b> Los Santos Police Departament.</b>",30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pizza",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"PizzaThis") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>AVISO: </b>"..message[1]..".<br>Enviado por:<b> PizzaThis.</b>",30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("med",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"Paramedic") then
			local message = vKEYBOARD.keySingle(source,"Mensagem:")
			if not message then
				return
			end
			TriggerClientEvent("Notify",-1,"azul","<b>EMS Informa: </b>"..message[1]..".<br>Enviado por:<b> Emergency Medical Services.</b>",30000)
		end
	end
end)
