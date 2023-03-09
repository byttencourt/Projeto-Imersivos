-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tablet")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADFOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERTABLET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:enterTablet")
AddEventHandler("tablet:enterTablet",function()
	local ped = PlayerPedId()
	if not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 and MumbleIsConnected() then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "openSystem" })
	end
	if not IsPedInAnyVehicle(ped) then
		vRP.removeObjects()
		vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("closeSystem",function()
	SetNuiFocus(false,false)
	vRP.removeObjects()
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = "closeSystem" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCARROS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestCarros",function(data,cb)
	cb({ result = GlobalState["Cars"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMotos",function(data,cb)
	cb({ result = GlobalState["Bikes"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTALUGUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestAluguel",function(data,cb)
	cb({ result = GlobalState["Rental"] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestPossuidos",function(data,cb)
	cb({ result = vSERVER.requestPossuidos() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBuy",function(data)
	if MumbleIsConnected() then
		vSERVER.requestBuy(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestRental",function(data)
	if MumbleIsConnected() then
		vSERVER.requestRental(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("rentalMoney",function(data)
	if MumbleIsConnected() then
		vSERVER.rentalMoney(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTax",function(data)
	if MumbleIsConnected() then
		vSERVER.requestTax(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTRANSF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestTransf",function(data)
	if MumbleIsConnected() then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "closeSystem" })
		vRP.removeObjects()

		vSERVER.requestTransf(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestSell",function(data)
	if MumbleIsConnected() then
		vSERVER.requestSell(data["name"])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLET:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("tablet:Update")
AddEventHandler("tablet:Update",function(action)
	SendNUIMessage({ action = action })
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVEABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local vehDrive = nil
local benDrive = false
local benCoords = { 0.0,0.0,0.0 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestDrive",function(data)
	local driveIn,vehPlate = vSERVER.startDrive()
	if driveIn then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "closeSystem" })

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		benCoords = { coords["x"],coords["y"],coords["z"] }

		TriggerEvent("races:insertList",true)
		LocalPlayer["state"]["Commands"] = true
		TriggerEvent("Notify","azul","Teste iniciado, para finalizar saia do veículo.",5000)

		Citizen.Wait(1000)

		vehCreate(data["name"],vehPlate)

		Citizen.Wait(1000)

		SetPedIntoVehicle(ped,vehDrive,-1)
		benDrive = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCREATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vehCreate(vehName,vehPlate)
	local mHash = GetHashKey(vehName)

	RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		Citizen.Wait(1)
	end

	if HasModelLoaded(mHash) then
		vehDrive = CreateVehicle(mHash,-16.24,-1095.71,26.96,158.75,false,false)

		SetEntityInvincible(vehDrive,true)
		SetVehicleNumberPlateText(vehDrive,vehPlate)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if benDrive then
			timeDistance = 1
			DisableControlAction(1,69,false)

			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) then
				Citizen.Wait(1000)

				benDrive = false
				vSERVER.removeDrive()
				TriggerEvent("races:insertList",false)
				LocalPlayer["state"]["Commands"] = false
				SetEntityCoords(ped,benCoords[1],benCoords[2],benCoords[3],1,0,0,0)
				DeleteEntity(vehDrive)
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local initVehicles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicles = {
	{
		["coords"] = vector3(-42.39,-1101.32,26.98),
		["heading"] = 19.85,
		["model"] = "350z",
		["color"] = 27,
		["distance"] = 50
	},{
		["coords"] = vector3(-54.61,-1096.86,26.98),
		["heading"] = 31.19,
		["model"] = "skyliner342",
		["color"] = 13,
		["distance"] = 50
	},{
		["coords"] = vector3(-47.57,-1092.05,26.98),
		["heading"] = 283.47,
		["model"] = "nissangtr50",
		["color"] = 1,
		["distance"] = 50
	},{
		["coords"] = vector3(-37.02,-1093.42,26.98),
		["heading"] = 206.93,
		["model"] = "jesko",
		["color"] = 14,
		["distance"] = 50
	},{
		["coords"] = vector3(-49.78,-1083.86,26.98),
		["heading"] = 65.2,
		["model"] = "bmwm1wb",
		["color"] = 112,
		["distance"] = 50
	},{
		["coords"] = vector3(1220.52,2732.96,37.29),
		["heading"] = 226.78,
		["model"] = "astonmartindbs",
		["color"] = 49,
		["distance"] = 30
	},{
		["coords"] = vector3(1225.09,2733.0,37.29),
		["heading"] = 226.78,
		["color"] = 1,
		["model"] = "panameramansory",
		["distance"] = 30
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(Vehicles) do
			local distance = #(coords - v["coords"])
			if distance <= v["distance"] then
				if initVehicles[k] == nil then
					local mHash = GetHashKey(v["model"])

					RequestModel(mHash)
					while not HasModelLoaded(mHash) do
						Citizen.Wait(1)
					end

					if HasModelLoaded(mHash) then
						initVehicles[k] = CreateVehicle(mHash,v["coords"],v["heading"],false,false)
						SetVehicleNumberPlateText(initVehicles[k],"PDMSPORT")
						FreezeEntityPosition(initVehicles[k],true)
						SetVehicleDoorsLocked(initVehicles[k],2)
						SetModelAsNoLongerNeeded(mHash)
						SetVehicleColours(initVehicles[k],v["color"],1)
					end
				end
			else
				if initVehicles[k] then
					if DoesEntityExist(initVehicles[k]) then
						DeleteEntity(initVehicles[k])
						initVehicles[k] = nil
					end
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTERTABLET
-----------------------------------------------------------------------------------------------------------------------------------------
function displaytablet(enable)
	local ped = PlayerPedId()
	if not LocalPlayer["state"]["Buttons"] and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and GetEntityHealth(ped) > 101 and MumbleIsConnected() then
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ action = "openSystem" })
	end
	if not IsPedInAnyVehicle(ped) then
		vRP.removeObjects()
		vRP.createObjects("amb@code_human_in_bus_passenger_idles@female@tablet@base","base","prop_cs_tablet",50,28422)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local locations = {
	{ -38.9,-1100.22,27.26 },
	{ -40.37,-1094.57,27.26 },
	{ -46.87,-1095.5,27.26 },
	{ -51.59,-1094.98,27.26 },
	{ -51.15,-1087.13,27.26 },
	{ 1230.03,2733.74,38.03 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local innerTable = {}
	for k,v in pairs(locations) do
		table.insert(innerTable,{ v[1],v[2],v[3],2.5,"E","Concessionária","Pressione para abrir" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(locations) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 3.5 then
					timeDistance = 1

					if IsControlJustPressed(1,38) and vSERVER.checkShares() then
						displaytablet(true)
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)