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
Tunnel.bindInterface("luckywheel",cRP)
vSERVER = Tunnel.getInterface("luckywheel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Wheel = nil
local Vehicle = nil
local Casino = false
local Active = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCKYWHEEL:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:Active")
AddEventHandler("luckywheel:Active", function()
	if Casino then
		Active = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCASINO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			local distance = #(coords - vector3(1107.92,218.34,-49.44))
			if distance <= 25 then
				if not Casino then
					Casino = true

					local vehHash = GetHashKey("corvettec7")
					local luckyHash = GetHashKey("vw_prop_vw_luckywheel_02a")

					RequestModel(vehHash)
					while not HasModelLoaded(vehHash) do
						Citizen.Wait(10)
					end

					RequestModel(luckyHash)
					while not HasModelLoaded(luckyHash) do
						Citizen.Wait(10)
					end

					Wheel = CreateObject(luckyHash,1111.05,229.85,-50.39,false,false,false)
					SetEntityHeading(Wheel,0.0)
					SetModelAsNoLongerNeeded(luckyHash)

					Vehicle = CreateVehicle(vehHash,1100.04,219.87,-47.75,200.0,false,false)
					SetVehicleNumberPlateText(Vehicle,"imersivo")
					SetVehicleOnGroundProperly(Vehicle)
					FreezeEntityPosition(Vehicle,true)
					SetEntityInvincible(Vehicle,true)
					SetVehicleDoorsLocked(Vehicle,2)
					SetVehicleColours(Vehicle,29,1)
				end
			else
				if Casino then
					DeleteEntity(Vehicle)
					Vehicle = nil

					DeleteEntity(Wheel)
					Wheel = nil

					Casino = false
				end
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCKYWHEEL:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:Start")
AddEventHandler("luckywheel:Start",function(wheelResult)
	if wheelResult ~= nil then
		if Casino then
			if DoesEntityExist(Wheel) then
				SetEntityRotation(Wheel,0.0,0.0,0.0,1,true)
			end

			Citizen.CreateThread(function()
				local rollingRatio = 1
				local rollingSpeed = 1.0
				local rollingAngle = (wheelResult - 1) * 18
				local wheelAngles = rollingAngle + (360 * 8)
				local middleResult = (wheelAngles / 2)

				while rollingRatio > 0 do
					local xRot = GetEntityRotation(Wheel,1)
					if wheelAngles > middleResult then
						rollingRatio = rollingRatio + 1
					else
						rollingRatio = rollingRatio - 1

						if rollingRatio <= 0 then
							rollingRatio = 0

							if Active then
								TriggerServerEvent("luckywheel:Payment")
								Active = false
							end
						end
					end

					rollingSpeed = rollingRatio / 200
					local yRot = xRot["y"] - rollingSpeed
					wheelAngles = wheelAngles - rollingSpeed
					SetEntityRotation(Wheel,0.0,yRot,0.0,1,true)

					Citizen.Wait(0)
				end
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETROLL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("luckywheel:Target")
AddEventHandler("luckywheel:Target", function()
	if Casino then
		if vSERVER.checkRolling() then
			local ped = PlayerPedId()
			local aHash = "anim_casino_a@amb@casino@games@lucky7wheel@female"
			RequestAnimDict(aHash)
			while not HasAnimDictLoaded(aHash) do
				Citizen.Wait(1)
			end

			local inMoviment = true
			local movePosition = vector3(1110.1,229.06,-49.64)
			TaskGoStraightToCoord(ped,movePosition["x"],movePosition["y"],movePosition["z"],1.0,-1,0.0,0.0)

			while inMoviment do
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)

				if coords["x"] >= (movePosition["x"] - 0.01) and coords["x"] <= (movePosition["x"] + 0.01) and coords["y"] >= (movePosition["y"] - 0.01) and coords["y"] <= (movePosition["y"] + 0.01) then
					inMoviment = false
				end

				Citizen.Wait(0)
			end

			SetEntityHeading(ped,35.0)
			TriggerServerEvent("luckywheel:Starting")
			TaskPlayAnim(ped,aHash,"armraisedidle_to_spinningidle_high",8.0,-8.0,-1,0,0,false,false,false)

			Citizen.Wait(2000)

			ClearPedTasks(ped)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONRESOURCESTOP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStop",function(resource)
	if resource == GetCurrentResourceName() then
		DeleteEntity(Vehicle)
		DeleteEntity(Wheel)
	end
end)