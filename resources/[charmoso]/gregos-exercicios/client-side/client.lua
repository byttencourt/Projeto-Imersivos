-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("gregos-exercicios",cRP)
vSERVER = Tunnel.getInterface("gregos-exercicios")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {}
local seconds = 0
local inAction = false
local hasProp = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(Config) do
				local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
				if distance <= 2 then
					timeDistance = 1
					if not inAction then
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   "..string.upper(v["nome"]))
					else
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   FINALIZAR")
					end

					if IsControlJustPressed(1,38) and seconds <= 0 then
						
						seconds = parseInt(v["duration"])
						if not inAction then
						inAction = true
						SetEntityCoords(ped,v["coords"][1],v["coords"][2],v["coords"][3])
						SetEntityHeading(ped,v["coords"][4])

							if v["animationName"] and v["event"] then
								TriggerEvent(v["event"],v["animationName"])
								hasProp = true
							else
								vSERVER.startAnim(v["animation"][1],v["animation"][2])
							end
							
							while inAction do
								if seconds == 0 then
									vSERVER.startExercice()
									inAction = false
									if hasProp then
										TriggerServerEvent("inventory:Cancel")
										vSERVER.stopExercice()
									else
									vSERVER.stopAnim()
									vSERVER.stopExercice()
									end
									
									break
								end
								Wait(1000)
							end
							
							
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
	
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if seconds > 0 then
			seconds = seconds - 1
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateAcademia(status)
	Config = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

