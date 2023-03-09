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
Tunnel.bindInterface("garages",cRP)
vPLAYER = Tunnel.getInterface("player")
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
local vehSpawn = {}
local vehSignal = {}
local searchTimers = {}
GlobalState["vehPlates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.serverVehicle(model,x,y,z,heading,vehPlate,nitroFuel,vehDoors,vehBody)
	local spawnVehicle = 0
	local mHash = GetHashKey(model)
	local myVeh = CreateVehicle(mHash,x,y,z,heading,true,true)

	while not DoesEntityExist(myVeh) and spawnVehicle <= 1000 do
		spawnVehicle = spawnVehicle + 1
		Citizen.Wait(100)
	end

	if DoesEntityExist(myVeh) then
		if vehPlate ~= nil then
			SetVehicleNumberPlateText(myVeh,vehPlate)
		else
			vehPlate = vRP.generatePlate()
			SetVehicleNumberPlateText(myVeh,vehPlate)
		end

		SetVehicleBodyHealth(myVeh,vehBody + 0.0)

		if vehDoors then
			local vehDoors = json.decode(vehDoors)
			if vehDoors ~= nil then
				for k,v in pairs(vehDoors) do
					if v then
						SetVehicleDoorBroken(myVeh,parseInt(k),true)
					end
				end
			end
		end

		local netVeh = NetworkGetNetworkIdFromEntity(myVeh)

		if model ~= "wheelchair" then
			local idNetwork = NetworkGetEntityFromNetworkId(netVeh)
			SetVehicleDoorsLocked(idNetwork,2)

			local Nitro = GlobalState["Nitro"]
			Nitro[vehPlate] = nitroFuel or 0
			GlobalState["Nitro"] = Nitro
		end

		return true,netVeh,mHash,myVeh
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGELOCATES
-----------------------------------------------------------------------------------------------------------------------------------------
local garageLocates = {
	-- Garages
	["1"] = { name = "Garage", payment = false },
	["2"] = { name = "Garage", payment = true },
	["3"] = { name = "Garage", payment = false },
	["4"] = { name = "Garage", payment = true },
	["5"] = { name = "Garage", payment = true },
	["6"] = { name = "Garage", payment = true },
	["7"] = { name = "Garage", payment = true },
	["8"] = { name = "Garage", payment = true },
	["9"] = { name = "Garage", payment = true },
	["10"] = { name = "Garage", payment = true },
	["11"] = { name = "Garage", payment = true },
	["12"] = { name = "Garage", payment = true },
	["13"] = { name = "Garage", payment = true },
	["14"] = { name = "Garage", payment = true },
	["15"] = { name = "Garage", payment = true },
	["16"] = { name = "Garage", payment = true },
	["17"] = { name = "Garage", payment = true },
	["18"] = { name = "Garage", payment = true },
	["19"] = { name = "Garage", payment = true },
	["20"] = { name = "Garage", payment = true },
	["21"] = { name = "Garage", payment = true },
	["22"] = { name = "Garage", payment = true },
	["23"] = { name = "Garage", payment = false },
	["24"] = { name = "Garage", payment = true },
	["25"] = { name = "Garage", payment = true },
	["26"] = { name = "Garage", payment = false },

	-- Paramedic
	["41"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["42"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["43"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["44"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	["45"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["46"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },
	

	-- Police
	["61"] = { name = "Police", payment = false, perm = "Police" },
	["62"] = { name = "heliPolice", payment = false, perm = "Police" },

	["63"] = { name = "Police", payment = false, perm = "Police" },
	["64"] = { name = "heliPolice", payment = false, perm = "Police" },

	["65"] = { name = "Police", payment = false, perm = "Police" },
	["66"] = { name = "heliPolice", payment = false, perm = "Police" },

	["67"] = { name = "Police", payment = false, perm = "Police" },
	["68"] = { name = "busPolice", payment = false, perm = "Police" },

	["69"] = { name = "Police", payment = false, perm = "Police" },

	["70"] = { name = "Police", payment = false, perm = "Police" },
	["71"] = { name = "heliPolice", payment = false, perm = "Police" },
	["72"] = { name = "busPolice", payment = false, perm = "Police" },
	["73"] = { name = "Heli", payment = false, perm2 = true },
	["74"] = { name = "Heli", payment = false, perm2 = true },

	-- Bikes
	["100"] = { name = "Bikes", payment = false },
	["101"] = { name = "Bikes", payment = false },
	["102"] = { name = "Bikes", payment = false },
	["103"] = { name = "Bikes", payment = false },
	["104"] = { name = "Bikes", payment = false },
	["105"] = { name = "Bikes", payment = false },
	["106"] = { name = "Bikes", payment = false },
	["107"] = { name = "PizzaThis", payment = false },
	["108"] = { name = "BurgerShot", payment = false },
	["109"] = { name = "PopsDiner", payment = false },
	["110"] = { name = "Bikes", payment = false },
	["111"] = { name = "Bikes", payment = false },
	["112"] = { name = "Bikes", payment = false },
	["113"] = { name = "Bikes", payment = false },
	["114"] = { name = "Bikes", payment = false },
	["115"] = { name = "Bikes", payment = false },
	["116"] = { name = "Bikes", payment = false },
	["117"] = { name = "Bikes", payment = false },
	["118"] = { name = "Bikes", payment = false },
	["119"] = { name = "Bikes", payment = false },
	["120"] = { name = "Bikes", payment = false },

	-- Boats
	["121"] = { name = "Boats", payment = false },
	["122"] = { name = "Boats", payment = false },
	["123"] = { name = "Boats", payment = false },
	["124"] = { name = "Boats", payment = false },
	["125"] = { name = "Boats", payment = false },
	["126"] = { name = "Boats", payment = false },

	-- Works
	["140"] = { name = "Weazel", payment = true },
	["141"] = { name = "Lumberman", payment = false },
	["142"] = { name = "Driver", payment = false },
	["143"] = { name = "Garbageman", payment = false },
	["144"] = { name = "Transporter", payment = false },
	["145"] = { name = "Taxi", payment = false },
	["146"] = { name = "TowDriver", payment = false },
	["147"] = { name = "TowDriver", payment = false },
	["148"] = { name = "TowDriver", payment = false },
	["149"] = { name = "Garbageman", payment = false },
	["150"] = { name = "Garbageman", payment = false },
	["151"] = { name = "Taxi", payment = false },
	["152"] = { name = "TowDriver", payment = false },
	["153"] = { name = "Desserts", payment = false, perm = "Desserts" },
	["154"] = { name = "Vinhedo", payment = true, perm = "Vinhedo" },
	["155"] = { name = "Mechanic", payment = false, perm = "Mechanic" },
	["156"] = { name = "Hunter", payment = false },
	["157"] = { name = "Staff", payment = false, perm = "Admin" },
	["158"] = { name = "Trucker", payment = false },
	["159"] = { name = "TheLost", payment = false, perm = "TheLost" },
	["160"] = { name = "LosSantos", payment = false, perm = "LosSantos" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("signalRemove")
AddEventHandler("signalRemove",function(vehPlate)
	vehSignal[vehPlate] = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateReveryone")
AddEventHandler("plateReveryone",function(vehPlate)
	if GlobalState["vehPlates"][vehPlate] then
		local vehPlates = GlobalState["vehPlates"]
		vehPlates[vehPlate] = nil
		GlobalState["vehPlates"] = vehPlates
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateEveryone")
AddEventHandler("plateEveryone",function(vehPlate)
	local vehPlates = GlobalState["vehPlates"]
	vehPlates[vehPlate] = true
	GlobalState["vehPlates"] = vehPlates
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("platePlayers")
AddEventHandler("platePlayers",function(vehPlate,user_id)
	local userPlate = vRP.userPlate(vehPlate)
	if not userPlate then
		local vehPlates = GlobalState["vehPlates"]
		vehPlates[vehPlate] = user_id
		GlobalState["vehPlates"] = vehPlates
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEROBBERYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("plateRobberys")
AddEventHandler("plateRobberys",function(vehPlate,vehName)
	if vehPlate ~= nil and vehName ~= nil then
		local source = source
		local user_id = vRP.getUserId(source)
		if user_id then
			if GlobalState["vehPlates"][vehPlate] ~= user_id then
				local vehPlates = GlobalState["vehPlates"]
				vehPlates[vehPlate] = user_id
				GlobalState["vehPlates"] = vehPlates
			end

			vRP.generateItem(user_id,"vehkey-"..vehPlate,1,true,false)

			if math.random(100) >= 50 then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)

				local policeResult = vRP.numPermission("Police")
				for k,v in pairs(policeResult) do
					async(function()
						vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Roubo de Veículo", x = coords["x"], y = coords["y"], z = coords["z"], vehicle = vehicleName(vehName).." - "..vehPlate, time = "Recebido às "..os.date("%H:%M"), blipColor = 44 })
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local workGarages = {
	["Paramedic"] = {
		"lguard",
		--"blazer2",
		"ambulance",
		"ambulance2"
	},
	["heliParamedic"] = {
		"polmav"
	},
	["Police"] = {
		"r1250pol",
		"nc700pol",
		"polvic",
		"polchall",
		"polcorv",
		"poltang",
		"polchar",
		"policetpol",
		"sheriff2pol"
	},
	["heliPolice"] = {
		"maverick2"
	},
	["busPolice"] = {
		"pbus",
		"riot"
	},
	["Driver"] = {
		"bus"
	},
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["TowDriver"] = {
		"flatbed",
		"towtruck2"
	},
	["Garbageman"] = {
		"trash"
	},
	["Taxi"] = {
		"taxi"
	},
	["PopsDiner"] = {
		"bmx",
		"popsdiner"
	},
	["PizzaThis"] = {
		"bmx",
		"faggio",
		"pizzathis"
	},
	["Desserts"] = {
		"bmx",
		"uwu"
	},
	["BurgerShot"] = {
		"bmx",
		"faggio",
		"burgershot"
	},
	["Weazel"] = {
		"bmx",
		"weazel"
	},
	["Bikes"] = {
		"bmx",
		"cruiser",
		"fixter",
		"scorcher",
		"tribike",
		"tribike2",
		"tribike3"
	},
	["Deliver"] = {
		"bmx"
	},
	["Hunter"] = {
		"winky"
	},
	["Mechanic"] = {
		"cdaraptor",
		"scaniarepair"
	},
	["LosSantos"] = {
		"cdaraptor2",
		"scaniarepair2"
	},
	["Staff"] = {
		"aventador",
		"s1000rr",
		"camaro",
		"escalade2021",
		"audirs6",
		"rangerover",
		"mercedesg65"
	},
	["Trucker"] = {
		"hauler",
		"packer",
		"phantom"
	},
	["TheLost"] = {
		"ratbike"
	},
	["Heli"] = {
		"havok",
		"frogger",
		"volatus",
		"swift",
		"swift2",
		"supervolito"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Vehicles(Garage)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and not exports["hud"]:Wanted(user_id) then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"vermelho","Multas pendentes encontradas.",3000)
			return false
		end

		local garageName = garageLocates[Garage]["name"]
		if string.sub(garageName,0,5) == "Homes" then
			local consult = vRP.query("propertys/userPermissions",{ name = garageName, user_id = user_id })
			if consult[1] == nil then
				return false
			else
				local ownerConsult = vRP.query("propertys/userOwnermissions",{ name = garageName })
				if ownerConsult[1] then
					if ownerConsult[1]["tax"] <= os.time() then
						TriggerClientEvent("Notify",source,"amarelo","Taxa da propriedade atrasada.",10000)
						return false
					end
				end
			end
		end

		if garageLocates[Garage]["perm"] then
			if not vRP.hasGroup(user_id,garageLocates[Garage]["perm"]) then
				return false
			end
		end
		if garageLocates[Garage]["perm2"] then
			if not vRP.userPremium(user_id) then
				return false
			end
		end

		local Vehicle = {}
		if workGarages[garageName] then
			for k,v in pairs(workGarages[garageName]) do
				table.insert(Vehicle,{ ["model"] = v, ["name"] = vehicleName(v) })
			end
		else
			local vehicle = vRP.query("vehicles/getVehicles",{ user_id = user_id })
			for k,v in ipairs(vehicle) do
				if v["work"] == "false" then
					table.insert(Vehicle,{ ["model"] = vehicle[k]["vehicle"], ["name"] = vehicleName(vehicle[k]["vehicle"]) })
				end
			end
		end

		return Vehicle
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Impound()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myVehicle = {}
		local vehicle = vRP.query("vehicles/getVehicles",{ user_id = user_id })

		for k,v in ipairs(vehicle) do
			if v["arrest"] >= os.time() then
				table.insert(myVehicle,{ ["model"] = vehicle[k]["vehicle"], ["name"] = vehicleName(vehicle[k]["vehicle"]) })
			end
		end

		return myVehicle
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound",function(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehPrice = vehiclePrice(vehName)
		TriggerClientEvent("dynamic:closeSystem",source)

		if vRP.request(source,"A liberação do veículo tem o custo de <b>$"..parseFormat(vehPrice * 0.025).."</b> dólares, deseja prosseguir com a liberação do mesmo?","Sim","Não") then
			if vRP.paymentFull(user_id,vehPrice * 0.025) then
				vRP.execute("vehicles/paymentArrest",{ user_id = user_id, vehicle = vehName })
				TriggerClientEvent("Notify",source,"verde","Veículo liberado.",5000)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Spawn")
AddEventHandler("garages:Spawn",function(Table)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local splitName = splitString(Table,"-")
		local garageName = splitName[2]
		local vehName = splitName[1]

		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if vehicle[1] == nil then
			vRP.execute("vehicles/addVehicles",{ user_id = user_id, vehicle = vehName, plate = vRP.generatePlate(), work = "true" })
			TriggerClientEvent("Notify",source,"verde","Veículo adicionado em sua lista de veículos.",5000)
		else
			local vehPlates = GlobalState["vehPlates"]
			local vehPlate = vehicle[1]["plate"]

			if vehSpawn[vehPlate] then
				if vehSignal[vehPlate] == nil then
					if searchTimers[user_id] == nil then
						searchTimers[user_id] = os.time()
					end

					if os.time() >= parseInt(searchTimers[user_id]) then
						searchTimers[user_id] = os.time() + 60

						local vehNet = vehSpawn[vehPlate][3]
						local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
						if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 2 then
							vCLIENT.searchBlip(source,GetEntityCoords(idNetwork))
							TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>60 segundos</b>, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
						else
							if vehSpawn[vehPlate] then
								vehSpawn[vehPlate] = nil
							end

							if vehPlates[vehPlate] then
								vehPlates[vehPlate] = nil
								GlobalState["vehPlates"] = vehPlates
							end

							TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","Rastreador só pode ser ativado a cada <b>60 segundos</b>.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Rastreador está desativado.",5000)
				end
			else
				if vehicle[1]["tax"] <= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada, efetue o pagamento<br>através do sistema da concessionária.",5000)
				elseif vehicle[1]["arrest"] >= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Veículo apreendido, dirija-se até o <b>Impound</b> e efetue o pagamento da liberação do mesmo.",5000)
				else
					if vehicle[1]["rental"] ~= 0 then
						if vehicle[1]["rental"] <= os.time() then
							TriggerClientEvent("Notify",source,"amarelo","Validade do veículo expirou, efetue a renovação do mesmo.",5000)
							return
						end
					end

					local Coords = vCLIENT.spawnPosition(source,garageName)
					if Coords then
						local vehMods = nil
						local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName })
						if parseInt(#custom) > 0 then
							vehMods = custom[1]["dvalue"]
						end

						if garageLocates[garageName]["payment"] then
							if vRP.userPremium(user_id) then
								TriggerClientEvent("dynamic:closeSystem",source)
								local netExist,netVeh,mHash = cRP.serverVehicle(vehName,Coords[1],Coords[2],Coords[3],Coords[4],vehPlate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

								if netExist then
									vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["engine"],vehMods,vehicle[1]["windows"],vehicle[1]["tyres"])
									TriggerEvent("engine:tryFuel",vehPlate,vehicle[1]["fuel"])
									vehSpawn[vehPlate] = { user_id,vehName,netVeh }

									vehPlates[vehPlate] = user_id
									GlobalState["vehPlates"] = vehPlates
								end
							else
								local vehPrice = vehiclePrice(vehName)
								if vRP.request(source,"Retirar o veículo por <b>$"..parseFormat(vehPrice * 0.05).."</b> dólares?") then
									if vRP.getBank(user_id) >= parseInt(vehPrice * 0.05) then
										TriggerClientEvent("dynamic:closeSystem",source)
										local netExist,netVeh,mHash = cRP.serverVehicle(vehName,Coords[1],Coords[2],Coords[3],Coords[4],vehPlate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

										if netExist then
											vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["engine"],vehMods,vehicle[1]["windows"],vehicle[1]["tyres"])
											TriggerEvent("engine:tryFuel",vehPlate,vehicle[1]["fuel"])
											vehSpawn[vehPlate] = { user_id,vehName,netVeh }

											vehPlates[vehPlate] = user_id
											GlobalState["vehPlates"] = vehPlates
										end
									else
										TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
									end
								end
							end
						else
							TriggerClientEvent("dynamic:closeSystem",source)
							local netExist,netVeh,mHash = cRP.serverVehicle(vehName,Coords[1],Coords[2],Coords[3],Coords[4],vehPlate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])

							if netExist then
								vCLIENT.createVehicle(-1,mHash,netVeh,vehicle[1]["engine"],vehMods,vehicle[1]["windows"],vehicle[1]["tyres"])
								TriggerEvent("engine:tryFuel",vehPlate,vehicle[1]["fuel"])
								vehSpawn[vehPlate] = { user_id,vehName,netVeh }

								vehPlates[vehPlate] = user_id
								GlobalState["vehPlates"] = vehPlates
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATE VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.createVehicletwo(model,x,y,z,h)
    local user_id = vRP.getUserId(source)
    if user_id then
        if model then
            local vehPlate = "VEH"..math.random(10000,99999)
            local netExist,netVeh,mHash,myVeh = cRP.serverVehicle(model,x,y,z,h,vehPlate,0,nil,1000)
        
            if not netExist then
                return
            end

            vCLIENT.createVehicle(-1,mHash,netVeh,1000,nil,false,false)
            vehSpawn[vehPlate] = { user_id,vehName,netVeh }
            TriggerEvent("engine:tryFuel",vehPlate,100)

            local vehPlates = GlobalState["vehPlates"]
            vehPlates[vehPlate] = user_id
            GlobalState["vehPlates"] = vehPlates
			
            return myVeh,netVeh,vehPlate
        end
        return false
    end
end

function cRP.deleteVehicletwo(vehNet,vehPlate)
	if GlobalState["vehPlates"][vehPlate] then
		local vehPlates = GlobalState["vehPlates"]
		vehPlates[vehPlate] = nil
		GlobalState["vehPlates"] = vehPlates
	end

	if GlobalState["Nitro"][vehPlate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[vehPlate] = nil
		GlobalState["Nitro"] = Nitro
	end

	if vehSignal[vehPlate] then
		vehSignal[vehPlate] = nil
	end

	if vehSpawn[vehPlate] then
		vehSpawn[vehPlate] = nil
	end


	local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
	if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 2 then
		DeleteEntity(idNetwork)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") and (args[1]) then
			local ped = GetPlayerPed(source)
			local coords = GetEntityCoords(ped)
			local heading = GetEntityHeading(ped)
			local vehPlate = "VEH"..math.random(10000,99999)
			local netExist,netVeh,mHash,myVeh = cRP.serverVehicle(args[1],coords["x"],coords["y"],coords["z"],heading,vehPlate,2000,nil,1000)

			if not netExist then
				return
			end

			vCLIENT.createVehicle(-1,mHash,netVeh,1000,nil,false,false)
			vehSpawn[vehPlate] = { user_id,vehName,netVeh }
			TriggerEvent("engine:tryFuel",vehPlate,100)
			SetPedIntoVehicle(ped,myVeh,-1)

			local vehPlates = GlobalState["vehPlates"]
			vehPlates[vehPlate] = user_id
			GlobalState["vehPlates"] = vehPlates
			TriggerEvent("discordLogs","Car","**Passaporte:** "..user_id.."\n**Usou /car** \n**Spawnou:** "..args[1].." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local vehicle,vehNet,vehPlate,vehiclex = vRPC.vehList(source,10)
	if user_id then
		if vRP.hasGroup(user_id,"Moderator") then
			TriggerClientEvent("garages:Delete",source)
			TriggerEvent("discordLogs","Car","**Passaporte:** "..user_id.."\n**Usou /dv** em um "..vehiclex.." \n**placas:** "..vehPlate.." \n**Horário:** "..os.date("%H:%M:%S"),3092790)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:VEHICLEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("garages:vehicleKey")
AddEventHandler("garages:vehicleKey",function(entity)
	local source = source
	local vehPlate = entity[1]
	local user_id = vRP.getUserId(source)
	if user_id then
		if GlobalState["vehPlates"][vehPlate] == user_id then
			vRP.generateItem(user_id,"vehkey-"..vehPlate,1,true,false)
		end
	end
end)
RegisterNetEvent("garages:truckerKey")
AddEventHandler("garages:truckerKey",function(entity)
	local source = source
	local vehPlate = entity[1]
	local user_id = vRP.getUserId(source)
	if user_id then
		if GlobalState["vehPlates"][vehPlate] == user_id then
			vRP.generateItem(user_id,"vehkey-".."Trucker",1,true,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:lockVehicle")
AddEventHandler("garages:lockVehicle",function(vehNet,vehPlate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if GlobalState["vehPlates"][vehPlate] == user_id then
			TriggerEvent("garages:keyVehicle",source,vehNet)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEYVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:keyVehicle")
AddEventHandler("garages:keyVehicle",function(source,vehNet)
	local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
	local doorStatus = GetVehicleDoorLockStatus(idNetwork)

	if parseInt(doorStatus) <= 1 then
		TriggerClientEvent("Notify",source,"locked","Veículo trancado.",5000)
		TriggerClientEvent("sounds:source",source,"locked",0.4)
		SetVehicleDoorsLocked(idNetwork,2)
	else
		TriggerClientEvent("Notify",source,"unlocked","Veículo destrancado.",5000)
		TriggerClientEvent("sounds:source",source,"unlocked",0.4)
		SetVehicleDoorsLocked(idNetwork,1)
	end

	if not vRPC.inVehicle(source) then
		vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click"},false)
		Citizen.Wait(400)
		vRPC.stopAnim(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.tryDelete(vehNet,vehEngine,vehBody,vehFuel,vehDoors,vehWindows,vehTyres,vehPlate)
	if vehSpawn[vehPlate] then
		local user_id = vehSpawn[vehPlate][1]
		local vehName = vehSpawn[vehPlate][2]

		if parseInt(vehEngine) <= 100 then
			vehEngine = 100
		end

		if parseInt(vehBody) <= 100 then
			vehBody = 100
		end

		if parseInt(vehFuel) >= 100 then
			vehFuel = 100
		end

		if parseInt(vehFuel) <= 0 then
			vehFuel = 0
		end

		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if vehicle[1] ~= nil then
			vRP.execute("vehicles/updateVehicles",{ user_id = user_id, vehicle = vehName, nitro = GlobalState["Nitro"][vehPlate] or 0, engine = parseInt(vehEngine), body = parseInt(vehBody), fuel = parseInt(vehFuel), doors = json.encode(vehDoors), windows = json.encode(vehWindows), tyres = json.encode(vehTyres) })
		end
	end

	TriggerEvent("garages:deleteVehicle",vehNet,vehPlate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLEADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicleAdmin")
AddEventHandler("garages:deleteVehicleAdmin",function(entity)
	TriggerEvent("garages:deleteVehicle",entity[1],entity[2])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(vehNet,vehPlate)
	if GlobalState["vehPlates"][vehPlate] then
		local vehPlates = GlobalState["vehPlates"]
		vehPlates[vehPlate] = nil
		GlobalState["vehPlates"] = vehPlates
	end

	if GlobalState["Nitro"][vehPlate] then
		local Nitro = GlobalState["Nitro"]
		Nitro[vehPlate] = nil
		GlobalState["Nitro"] = Nitro
	end

	if vehSignal[vehPlate] then
		vehSignal[vehPlate] = nil
	end

	if vehSpawn[vehPlate] then
		vehSpawn[vehPlate] = nil
	end

	local idNetwork = NetworkGetEntityFromNetworkId(vehNet)
	if DoesEntityExist(idNetwork) and not IsPedAPlayer(idNetwork) and GetEntityType(idNetwork) == 2 then
		if GetVehicleNumberPlateText(idNetwork) == vehPlate then
			DeleteEntity(idNetwork)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UPDATEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:updateGarages")
AddEventHandler("garages:updateGarages",function(homeName,homeInfos)
	garageLocates[homeName] = { ["name"] = homeName, ["payment"] = false }

	-- CONFIG
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)
	configTable[homeName] = { ["name"] = homeName, ["payment"] = false }
	SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)

	-- LOCATES
	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)
	locatesTable[homeName] = homeInfos
	SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)

	TriggerClientEvent("garages:updateLocs",-1,homeName,homeInfos)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:REMOVEGARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:removeGarages")
AddEventHandler("garages:removeGarages",function(homeName)
	if garageLocates[homeName] then
		garageLocates[homeName] = nil

		local configFile = LoadResourceFile("logsystem","garageConfig.json")
		local configTable = json.decode(configFile)
		if configTable[homeName] then
			configTable[homeName] = nil
			SaveResourceFile("logsystem","garageConfig.json",json.encode(configTable),-1)
		end

		local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
		local locatesTable = json.decode(locatesFile)
		if locatesTable[homeName] then
			locatesTable[homeName] = nil
			SaveResourceFile("logsystem","garageLocates.json",json.encode(locatesTable),-1)
		end

		TriggerClientEvent("garages:updateRemove",-1,homeName)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Tax")
AddEventHandler("garages:Tax",function(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if vehicle[1] then
			if vehicle[1]["tax"] <= os.time() then
				local vehiclePrice = parseInt(vehiclePrice(vehName) * 0.05)

				if vRP.paymentFull(user_id,vehiclePrice) then
					vRP.execute("vehicles/updateVehiclesTax",{ user_id = user_id, vehicle = vehName })
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			else
				TriggerClientEvent("Notify",source,"azul",completeTimers(vehicle[1]["tax"] - os.time()),1000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Sell")
AddEventHandler("garages:Sell",function(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("dynamic:closeSystem",source)

		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return false
			end

			local vehType = vehicleType(vehName)
			if vehType == "work" then
				TriggerClientEvent("Notify",source,"amarelo","Veículos de serviço não podem ser vendidos.",3000)
				actived[user_id] = nil
				return false
			end

			local vehPrices = vehiclePrice(vehName) * 0.5
			local sellText = "Vender o veículo <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrices).."</b>?"

			if vehType == "rental" then
				sellText = "Remover o veículo de sua lista de possuídos?"
			end

			if vRP.request(source,sellText) then
				local vehicles = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
				if vehicles[1] then
					vRP.remSrvdata("custom:"..user_id..":"..vehName)
					vRP.remSrvdata("vehChest:"..user_id..":"..vehName)
					vRP.remSrvdata("vehGloves:"..user_id..":"..vehName)
					vRP.execute("vehicles/removeVehicles",{ user_id = user_id, vehicle = vehName })
					TriggerEvent("discordLogs","sellcar","**Passaporte:** "..user_id.."\n**Vendeu:** "..vehicleName(vehName).."\n**Horário:** "..os.date("%H:%M:%S"),3092790)


					if vehType ~= "rental" then
						vRP.addBank(user_id,vehPrices,"Private")
						TriggerClientEvent("itensNotify",source,{ "recebeu","dollars",parseFormat(vehPrices),"Dólares" })
					end
				end
			end

			actived[user_id] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Transfer")
AddEventHandler("garages:Transfer",function(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerClientEvent("dynamic:closeSystem",source)

		local myVehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if myVehicle[1] then
			if myVehicle[1]["rental"] >= 1 then
				TriggerClientEvent("Notify",source,"amarelo","Veículos alugados não podem ser transferidos.",5000)
				return
			end
			if myVehicle[1]["work"] == "true" then
				TriggerClientEvent("Notify",source,"amarelo","Veículos de trabalho não podem ser transferidos.",5000)
				return
			end
			local passport = vKEYBOARD.keySingle(source,"Passaporte:")
            if not passport then
                return
            end

			local nuser_id = parseInt(passport[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				if vRP.request(source,"Transferir o veículo <b>"..vehicleName(vehName).."</b> para <b>"..identity["name"].." "..identity["name2"].."</b>?") then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(nuser_id), vehicle = vehName })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"amarelo","<b>"..identity["name"].." "..identity["name2"].."</b> já possui este modelo de veículo.",5000)
					else
						vRP.execute("vehicles/moveVehicles",{ user_id = user_id, nuser_id = parseInt(nuser_id), vehicle = vehName })

						local custom = vRP.query("entitydata/getData",{ dkey = "custom:"..user_id..":"..vehName })
						if parseInt(#custom) > 0 then
							vRP.execute("entitydata/setData",{ dkey = "custom:"..nuser_id..":"..vehName, value = custom[1]["dvalue"] })
							vRP.execute("entitydata/removeData",{ dkey = "custom:"..user_id..":"..vehName })
						end

						local vehChest = vRP.getSrvdata("vehChest:"..user_id..":"..vehName)
						if vehChest ~= nil then
							vRP.setSrvdata("vehChest:"..nuser_id..":"..vehName,vehChest)
							vRP.remSrvdata("vehChest:"..user_id..":"..vehName)
						end

						local vehGloves = vRP.getSrvdata("vehGloves:"..user_id..":"..vehName)
						if vehGloves ~= nil then
							vRP.setSrvdata("vehGloves:"..nuser_id..":"..vehName,vehGloves)
							vRP.remSrvdata("vehGloves:"..user_id..":"..vehName)
						end

						TriggerClientEvent("Notify",source,"verde","Transferência concluída.",5000) 
						TriggerEvent("discordLogs","Transfer","**Passaporte:** "..user_id.."\n**Transferiu:** "..vehicleName(vehName).."\n**Para id:** "..nuser_id.."\n**Horário:** "..os.date("%H:%M:%S"),3092790)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local configFile = LoadResourceFile("logsystem","garageConfig.json")
	local configTable = json.decode(configFile)

	for k,v in pairs(configTable) do
		garageLocates[k] = v
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnect",function(user_id,source)
	local locatesFile = LoadResourceFile("logsystem","garageLocates.json")
	local locatesTable = json.decode(locatesFile)

	TriggerClientEvent("garages:allLocs",source,locatesTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if searchTimers[user_id] then
		searchTimers[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHSIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("vehSignal",function(vehPlate)
	return vehSignal[vehPlate]
end)