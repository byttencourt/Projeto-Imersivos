local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
MTserver = Tunnel.getInterface("suspensao")
vRP = Proxy.getInterface("vRP")
Tunnel.bindInterface("suspesao", Mts) 
Mts = {}

local NUi = false





Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

Citizen.CreateThread(function()
	while true do 
		local ped = GetPlayerPed(-1)
		local tcar = GetVehiclePedIsIn(ped)
		local letme = 2000
		if tcar > 0 then 
			letme = 1
			if IsControlJustPressed(0, 11) then
				if MTserver.checkPermission() then
					SetNuiFocus(true,true)
					SendNUIMessage({abrir = true})
				end
			end
		end
		Citizen.Wait(letme)
	end
end)


-- usar entre 0.49 e 0.99
RegisterCommand("largura",function(source,args)
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleWheelWidth(vehicle,tonumber(args[1]))
	end
end)
-- usar entre 0.29 e 0.89
RegisterCommand("tamanho",function(source,args)
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	if IsEntityAVehicle(vehicle) then
		SetVehicleWheelSize(vehicle,tonumber(args[1]))
	end
end)


RegisterNUICallback("Close",function()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ action = true })
end)


RegisterNUICallback("botaos",function(data)
	TriggerEvent("susp+1")
end)	

RegisterNUICallback("botaod",function(data)
	TriggerEvent("susp-1")
end)
RegisterNUICallback("botaosm",function(data)
	TriggerEvent("susps1")
end)
RegisterNUICallback("botaodm",function(data)
	TriggerEvent("suspd1")
end)
AddEventHandler("suspd1",function()
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	local lSusp = GetVehicleWheelWidth(vehicle)
	local result = lSusp - 0.01
	if IsEntityAVehicle(vehicle) then
		TriggerEvent("sounds:source","air",0.2)
		TriggerServerEvent("widthwheel",VehToNet(vehicle),result)
	end
end)
AddEventHandler("susps1",function()
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	local lSusp = GetVehicleWheelWidth(vehicle)
	local result = lSusp + 0.01
	if IsEntityAVehicle(vehicle) then
		TriggerEvent("sounds:source","air",0.2)
		TriggerServerEvent("widthwheel",VehToNet(vehicle),result)
	end
end)
AddEventHandler("susp+1",function()
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	local lSusp = GetVehicleSuspensionHeight(vehicle)
	local result = lSusp - 0.01
	if lSusp > -0.10 then
		if IsEntityAVehicle(vehicle) then
			TriggerEvent("sounds:source","air",0.2)
			TriggerServerEvent("trywheel",VehToNet(vehicle),result)
		end
	end
end)
AddEventHandler("susp-1",function()
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	local lSusp = GetVehicleSuspensionHeight(vehicle)
	local result = lSusp + 0.01
	if lSusp < 0.28 then 
		if IsEntityAVehicle(vehicle) then
			TriggerEvent("sounds:source","air",0.2)
			TriggerServerEvent("trywheel",VehToNet(vehicle),result)
		end
	end
end)



RegisterCommand("susp",function(source,args)
	local ped =  GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsIn(ped)
	if IsEntityAVehicle(vehicle) then
		TriggerEvent("sounds:source","air",0.2)
		TriggerServerEvent("trywheel",VehToNet(vehicle),args[1])
	end
end)



RegisterNetEvent("syncwheel")
AddEventHandler("syncwheel",function(index,arg)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then

			SetVehicleSuspensionHeight(v,tonumber(arg)+0.0)

			end
		end
	end
end)

RegisterNetEvent("wheelwidth")
AddEventHandler("wheelwidth",function(index,arg)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then

				SetVehicleWheelWidth(v,tonumber(arg)+0.0)

			end
		end
	end
end)





RegisterNetEvent("returncall")
AddEventHandler("returncall", function(e,source)
	local suspe =  e
	local player = GetPlayerPed(-1)
	local vcar = GetVehiclePedIsIn(player,false)
	SetVehicleSuspensionHeight(VehToNet(vcar),tonumber(suspe)+0.0)
end)






function debig(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
