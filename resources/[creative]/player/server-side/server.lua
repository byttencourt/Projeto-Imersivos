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
	["Disconnect"] = "https://discord.com/api/webhooks/973001212528033873/_9GuYTF_xlGZVLQogXTtxOkvX3_VFqYCs5u70x2902w4HRwynjhgq7AYwko7Ay1wx_Pn",
	["Airport"] = "https://discord.com/api/webhooks/980888422992474112/w7h0GbYIcX4plW2_V9IdO0K0LRZrCtj3k-kMaaZ6jTIhVuz5sJJpIdF355_yaYEXoRuq",
	["Deaths"] = "https://discord.com/api/webhooks/979543672590848010/Qumw-zn18PW8COVBo88l9zWOwpxRgo0-MfEkrwcKgRwFkWzS4f4ju9jA1Pq1WqdHBBBo",
	["Police"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["State"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["Lspd"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["Sheriff"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["Ranger"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["Corrections"] = "https://discord.com/api/webhooks/980888551770189914/i6cOMNDYw3iBgNQeqV6ehjKvNwp7QlINj2N-_Kf72oRBO_A8YRXXLfn47jBBl37eEV0W",
	["Paramedic"] = "https://discord.com/api/webhooks/980888685648175194/JzGdgVVUguYL1CZJ2vEfVGUnnmIY2HOTqzAPImvLR8sK7OkWOGAa8AhdslJohoszwcNZ",
	["Hackers"] = "https://discord.com/api/webhooks/973383236854087700/cRYHEO03-k1kVfzAOHIL4cBO8iokGUrcPn2eBX5CCNYKVwKs7A7VENN1XB2zpAnK-tW2",
	["Gemstones"] = "https://discord.com/api/webhooks/980888776593252362/1s0voN9XtMtetWC9z1_M1YYprjfmApJ0uuDRQa5EuDT3Dh9vxM0kvckMkUEosUgV2pY5",
	["Badges"] = "https://discord.com/api/webhooks/980888854976417873/ofpK3suMb8CLOHDk6jdJYmAVevEL6iWyTqmlKm8PlKc_Fwou2TalzP0VxRsA39lqpLNK",
	["Admin"] = "https://discord.com/api/webhooks/996586159197126726/eWMCjsQIjX6kVkslT4XJtRurgXSzQCueJJqGL4kEYOnDV8nOZcJo05g4tVRBFvpAxSmC",
	["Drop"] = "https://discord.com/api/webhooks/996619066032803950/RfxY9BOJHHQqnfaKs-Ysnxc2Cqe69Kg0ty2pgQCICXm9Ty-A9rBiAvioAt8HCetEl-2Z",
	["Enviar"] = "https://discord.com/api/webhooks/996621374686761010/hIHqZSmlHybepJq75Ijii-YEqSmAevRla0fN5WCdNkxr1o9Z0FJhmUctJsoB1T-SCRVW",
	["Pegar"] = "https://discord.com/api/webhooks/996621485277986937/cLq-vEEXWlYttcyZnCliUt0KiCs4q06jOwsUIRUBdsQ7WcXWlmkVFWzb7nn5QYS-ab2y",
	["Wall"] = "https://discord.com/api/webhooks/996640033895354388/HHTDBvFTAy4JAWQ7qSpFahpJRvW8IQCrFOie1nz80NMIDX5_WmFi4fsx0JFWt1rUbXqR",
	["group"] = "https://discord.com/api/webhooks/1000436188928282716/7aj3Q_10wgI2fNW5K4YG8hEjxMWTvcVdmWxjJppTxjiXFbLSwhHglt7MlXSmZ5X_t4qT",
	["ungroup"] = "https://discord.com/api/webhooks/1000436822905729126/3etVNRHMq8wEYCMWAXJG4Y8z1eVI_Z2DO89t9ZPt5LWGa9PO0S_Z6H1DSBwScSbyren_",
	["Car"] = "https://discord.com/api/webhooks/1000659505501188207/YVlTbWP_YDSRue97KlU34pAUPBI8siQmxiS4jwU7C_DmI2TWI33aYE6h2wEygLE2-ge5",
	["Bloods"] = "https://discord.com/api/webhooks/1002721284632883252/19Yu4JauevxXe6S4wcnMoFIhxsObpv_2aNGkD4-bdo4T7_VgNpv9Gt-E-kETocz0985B",
	["Families"] = "https://discord.com/api/webhooks/1007365625607368744/09mIUWi44LzR27LomYaqAxKci7I1m7nTrB5kweu1hwPHadOeo8m5sk5Ju2O6VDDMpONT",
	["Vagos"] = "https://discord.com/api/webhooks/1007365752413753394/iHRaeq3JoknH4tdIrWFXgmjB7Le32F9xZ2wDOcTMlLCzNijvW6ahXZvbBfqtSGbdmQnB",
	["Ballas"] = "https://discord.com/api/webhooks/1007365180847566908/3P5QkXokqHCLNTiLn2FNZgAeNGCMTjsS2qWX0CtRFVg1HJEr_ClgZRnarET-_yunzUaV",
	["Triads"] = "https://discord.com/api/webhooks/1002721897856901222/hBZYM1ap9W5i-mocrUQQj2XUE4gyCJXPvOYouZmtUPQWZPS_H96vVhHgGq5wUDUp8_21",
	["Vinhedo"] = "https://discord.com/api/webhooks/1023847689839976468/-Bx5UNgiergasNMfIln5TecSuDdRb0zSzcIdOoQHL96c9RWEqhXXedU2fzURwotNWDtD",
	["Aztecas"] = "https://discord.com/api/webhooks/1023848493573480489/C2YPHguSI5FAQD4PwuIbJMWZE--x-wAwUtVaZD9xErAQdhqlAFbvZqlkiR3-nQgwev9q",
	["TheLost"] = "https://discord.com/api/webhooks/1023848253462159430/kFHQ1Kp3W7_4M6z4DyGqBefpU18GRYvwJiuWwh3PChYC01T5fORWzrNKUGtN5rNjZIqV",
	["Playboy"] = "https://discord.com/api/webhooks/1002722015674896464/BINoi8h_8UG68S1eLs4_4O3x-zL8QGlGVlZ-LiJ063QXpyc53pxcmDkMIufpK9P8CvM-",
	["EastSide"] = "https://discord.com/api/webhooks/1002722177340158063/QZ9qK5_V_TVULfjPNuqdwMJuyLanqldkJCIpp4dKpqkjZ3YqEYliWYKzhc4DPgzeCNPg",
	["LosSantos"] = "https://discord.com/api/webhooks/1024194345043234858/GnNyvheD7W5c6WH2Um605ZvylZM8RusvvQhtOnxHUKneM2cs4myFn_KmzQAXftR8ac5b",
	["Mechanic"] = "https://discord.com/api/webhooks/1002722311432044645/oC64j261gsl7dzYsaXmHxA7S5mknvY32j0lhvfymlvOThkLLn_3vCizXpicWuetMelpA",
	["Desserts"] = "https://discord.com/api/webhooks/1002722517867307068/dEU239gqaeUvYBTktqkzOWTlMt2NTObq8r8RB6mF2TEUyilG0YLD0dwoFKqYpd8X2t4D",
	["Salieris"] = "https://discord.com/api/webhooks/1002724062818218014/Q6aBxuG83LauFFYEu8k2pEj8msv0Ck2QzkFMIsCGt2IoA58I5_yBABf2hKb1r_L3c8Qi",
	["Vanilla"] = "https://discord.com/api/webhooks/1023848778006007828/vx9KRwtwAsYLRhdKLEvV-KFfdn6OL8J4KZoiw4kWUwGS9YEU5UEsy-4Ihrdqx9cwDZQE",
	["Staff"] = "https://discord.com/api/webhooks/1003521353892241458/dBpY-s28szxrzFVU3I77_DqiaVvqp9orUY-V8dwpM8CTsw_YnfBQ51xcKjaoiwyM_AmB",
	["Revistar"] = "https://discord.com/api/webhooks/1005655021725167626/Q8WX35cqQT5uv_rc80T1P-qgPk0QxdrC9lSWyMEtCHR07USeRiE9xuIIcJvo0fHyvV6e",
	["Transfer"] = "https://discord.com/api/webhooks/991525339056578660/LsVVYAuawokRrDOsCHsBJ3my4eksbrZH6eAFqCueCCkLn8k-Vv6C3gmO_tSlPaWjmgRk",
	["sellcar"] = "https://discord.com/api/webhooks/991525469553963119/RRLSlt9cm3wsZbIZHVMMizg7ISgXW6tzRvM3nxGdwJqnBJvo5yPnHl7s1ClFlO0E4WzB",
	["buycar"] = "https://discord.com/api/webhooks/991525549707100250/Z7uYdxGBd2ccvguh3jO7vaAPWN_3Pe3QPfCpgIoNFVGld3qb5yPVUIbBYnUihCaLsxeS",
	["Compra"] = "https://discord.com/api/webhooks/979543084822052864/qGjZEn7AAr01xnzi8ncEI_1OVYXteTR6zwPY-oyxKJbgEbkJnu-qINYK4eKC04ocorNz",
	["Venda"] = "https://discord.com/api/webhooks/980889609078702110/-esNxejBaj7NznyWebwESWcvNaYUO-0z4nCJsJXgUCgIgYdsut1b2Xv7ieUBGrainwd8",
	["Craft"] = "https://discord.com/api/webhooks/1023849946115473450/B3b8eUhjogNXEd7S8yRe_JKTDi7FlD9Ewe-uqdjitfwVHMzy82RDKm2xDehC6lAGwd_d",
	["Trunk"] = "https://discord.com/api/webhooks/1023857684514095104/uTgF59cY-nbXRJqxum4bWNtHQqYqwUzv3oP1v6s2MoXxXzyTvWk_bVLhhgUWLuZrdosg",
	["Penitenciaria"] = "https://discord.com/api/webhooks/1023488055350403123/G5qfFlC5ZK88wqbV-FTvYi-nBIJSaTsEYBvqnDwMoqhlD19wzxkVUhcNj-tZ3UpQ0w1S"


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
