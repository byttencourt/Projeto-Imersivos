-----------------------------------------------------------------------------------------------------------------------------------------
-- Notify
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("truck_logistics:Notify")
AddEventHandler("truck_logistics:Notify", function(type,msg)
	-- You can change your notification here
	SendNUIMessage({ 
		notification = msg,
		notification_type = type,
	})
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- Draw Texts
-----------------------------------------------------------------------------------------------------------------------------------------

function DrawText3D2(x, y, z, text, scale)
	if text then
		local onScreen, _x, _y = World3dToScreen2d(x, y, z)
		local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
		SetTextScale(scale, scale) SetTextFont(4)
		SetTextProportional(1)
		SetTextEntry("STRING")
		SetTextCentre(true)
		SetTextColour(255, 255, 255, 215) AddTextComponentString(text)
		DrawText(_x, _y)
		local factor = (string.len(text)) / 700
		DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100)
	end
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------

--[[function spawnVehicle(name,x,y,z,h,vehbody,vehengine,vehtransmission,vehwheels,blip_sprite,blip_color,blip_name,properties)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		nveh = CreateVehicle(mhash,x,y,z+0.5,h,false,false)
		local netveh = VehToNet(nveh)

		Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
		Citizen.InvokeNative(0xAD738C3085FE7E11,nveh,true,true)
		SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
		SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
		SetModelAsNoLongerNeeded(mhash)
		SetVehicleDoorsLocked(nveh,1)
		SetVehicleDoorsLocked(NetToVeh(netveh),1)
		SetVehicleNumberPlateText(NetToVeh(netveh),Lang[Config.lang]['truck_plate'])

		if (vehwheels < 400) then
			local arr = {0,1,2,3,4,5,45,47}
			for k,v in pairs(arr) do
				SetVehicleTyreBurst(nveh,v,true,1000)
			end
		end

		SetVehicleFuelLevel(nveh,100.0)
		if properties then
			SetVehicleProperties(nveh, json.decode(properties))
		end
		SetVehicleEngineHealth(nveh,vehengine+0.0)
		SetVehicleBodyHealth(nveh,vehbody+0.0)
		DecorSetFloat(nveh, "_FUEL_LEVEL", GetVehicleFuelLevel(nveh))
	
		blip = AddBlipForEntity(nveh)
		SetBlipSprite(blip,blip_sprite)
		SetBlipColour(blip,blip_color)
		SetBlipAsShortRange(blip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blip_name)
		EndTextCommandSetBlipName(blip)
	end
	return nveh,blip
end]]

function spawnVehicle(name,x,y,z,h,vehbody,vehengine,vehtransmission,vehwheels,blip_sprite,blip_color,blip_name,properties)
    if name then
        myVeh,netVeh,vehPlate = vGARAGES.createVehicletwo(name,x,y,z,h)
		blip = AddBlipForEntity(NetToVeh(netVeh))
		SetBlipSprite(blip,blip_sprite)
		SetBlipColour(blip,blip_color)
		SetBlipAsShortRange(blip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(blip_name)
		EndTextCommandSetBlipName(blip)
        return NetToVeh(netVeh),netVeh,vehPlate
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- showScaleform
-----------------------------------------------------------------------------------------------------------------------------------------

function showScaleform(title, desc, sec)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieFunctionParameterString(title)
		PushScaleformMovieFunctionParameterString(desc)
		PopScaleformMovieFunctionVoid()
		return scaleform
	end
	scaleform = Initialize("mp_big_message_freemode")
	while sec > 0 do
		sec = sec - 0.02
		Citizen.Wait(0)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addBlip
-----------------------------------------------------------------------------------------------------------------------------------------

-- function addBlip(x,y,z,idtype,idcolor,text,scale)
-- 	if idtype ~= 0 then
-- 		local blip = AddBlipForCoord(x,y,z)
-- 		SetBlipSprite(blip,idtype)
-- 		SetBlipAsShortRange(blip,true)
-- 		SetBlipColour(blip,idcolor)
-- 		SetBlipScale(blip,scale)

-- 		if text then
-- 			BeginTextCommandSetBlipName("STRING")
-- 			AddTextComponentString(text)
-- 			EndTextCommandSetBlipName(blip)
-- 		end
-- 		return blip
-- 	end
-- end

-- Citizen.CreateThread(function()
-- 	for k,v in pairs(Config.trucker_locations) do
-- 		local x,y,z = table.unpack(v.menu_location)
-- 		addBlip(x,y,z,v.blips.id,v.blips.color,v.blips.name,v.blips.scale)
-- 	end
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- vehicle Lock
-----------------------------------------------------------------------------------------------------------------------------------------


local anims = {}

function playAnim(upper, seq, looping)
	stopAnim(upper)

	local flags = 0
	if upper then flags = flags+48 end
	if looping then flags = flags+1 end

	Citizen.CreateThread(function()
	for k,v in pairs(seq) do
		local dict = v[1]
		local name = v[2]
		local loops = v[3] or 1

		for i=1,loops do
			local first = (k == 1 and i == 1)
			local last = (k == #seq and i == loops)

			-- request anim dict
			RequestAnimDict(dict)
			local i = 0
			while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
			Citizen.Wait(10)
			RequestAnimDict(dict)
			i = i+1
			end

			-- play anim
			if HasAnimDictLoaded(dict)then
			local inspeed = 8.0001
			local outspeed = -8.0001
			if not first then inspeed = 2.0001 end
			if not last then outspeed = 2.0001 end

			TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
			end

			Citizen.Wait(0)
			while GetEntityAnimCurrentTime(GetPlayerPed(-1),dict,name) <= 0.95 and IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
			Citizen.Wait(0)
			end
		end
	end
	end)
end
function stopAnim(upper)
	anims = {} -- stop all sequences
	if upper then
		ClearPedSecondaryTask(GetPlayerPed(-1))
	else
		ClearPedTasks(GetPlayerPed(-1))
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- Vehicle Tuning
-----------------------------------------------------------------------------------------------------------------------------------------
Trim = function(value)
	if not value then return nil end
	return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end
Round = function(value, numDecimalPlaces)
	if not numDecimalPlaces then return math.floor(value + 0.5) end
	local power = 10 ^ numDecimalPlaces
	return math.floor((value * power) + 0.5) / (power)
end

function GetPlate(vehicle)
	if vehicle == 0 then return end
	return Trim(GetVehicleNumberPlateText(vehicle))
end

function GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local extras = {}

		if GetIsVehiclePrimaryColourCustom(vehicle) then
			r, g, b = GetVehicleCustomPrimaryColour(vehicle)
			colorPrimary = { r, g, b }
		end

		if GetIsVehicleSecondaryColourCustom(vehicle) then
			r, g, b = GetVehicleCustomSecondaryColour(vehicle)
			colorSecondary = { r, g, b }
		end

		for extraId = 0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= -1 then
			modLivery = GetVehicleLivery(vehicle)
		else
			modLivery = GetVehicleMod(vehicle, 48)
		end

		return {
			model = GetEntityModel(vehicle),
			plate = GetPlate(vehicle),
			plateIndex = GetVehicleNumberPlateTextIndex(vehicle),
			bodyHealth = Round(GetVehicleBodyHealth(vehicle)),
			engineHealth = Round(GetVehicleEngineHealth(vehicle)),
			tankHealth = Round(GetVehiclePetrolTankHealth(vehicle)),
			fuelLevel = Round(GetVehicleFuelLevel(vehicle)),
			dirtLevel = Round(GetVehicleDirtLevel(vehicle)),
			color1 = colorPrimary,
			color2 = colorSecondary,
			pearlescentColor = pearlescentColor,
			interiorColor = GetVehicleInteriorColor(vehicle),
			dashboardColor = GetVehicleDashboardColour(vehicle),
			wheelColor = wheelColor,
			wheels = GetVehicleWheelType(vehicle),
			windowTint = GetVehicleWindowTint(vehicle),
			xenonColor = GetVehicleXenonLightsColour(vehicle),
			neonEnabled = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},
			neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras = extras,
			tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
			modSpoilers = GetVehicleMod(vehicle, 0),
			modFrontBumper = GetVehicleMod(vehicle, 1),
			modRearBumper = GetVehicleMod(vehicle, 2),
			modSideSkirt = GetVehicleMod(vehicle, 3),
			modExhaust = GetVehicleMod(vehicle, 4),
			modFrame = GetVehicleMod(vehicle, 5),
			modGrille = GetVehicleMod(vehicle, 6),
			modHood = GetVehicleMod(vehicle, 7),
			modFender = GetVehicleMod(vehicle, 8),
			modRightFender = GetVehicleMod(vehicle, 9),
			modRoof = GetVehicleMod(vehicle, 10),
			modEngine = GetVehicleMod(vehicle, 11),
			modBrakes = GetVehicleMod(vehicle, 12),
			modTransmission = GetVehicleMod(vehicle, 13),
			modHorns = GetVehicleMod(vehicle, 14),
			modSuspension = GetVehicleMod(vehicle, 15),
			modArmor = GetVehicleMod(vehicle, 16),
			modTurbo = IsToggleModOn(vehicle, 18),
			modSmokeEnabled = IsToggleModOn(vehicle, 20),
			modXenon = IsToggleModOn(vehicle, 22),
			modFrontWheels = GetVehicleMod(vehicle, 23),
			modBackWheels = GetVehicleMod(vehicle, 24),
			modCustomTiresF = GetVehicleModVariation(vehicle, 23),
			modCustomTiresR = GetVehicleModVariation(vehicle, 24),
			modPlateHolder = GetVehicleMod(vehicle, 25),
			modVanityPlate = GetVehicleMod(vehicle, 26),
			modTrimA = GetVehicleMod(vehicle, 27),
			modOrnaments = GetVehicleMod(vehicle, 28),
			modDashboard = GetVehicleMod(vehicle, 29),
			modDial = GetVehicleMod(vehicle, 30),
			modDoorSpeaker = GetVehicleMod(vehicle, 31),
			modSeats = GetVehicleMod(vehicle, 32),
			modSteeringWheel = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate = GetVehicleMod(vehicle, 35),
			modSpeakers = GetVehicleMod(vehicle, 36),
			modTrunk = GetVehicleMod(vehicle, 37),
			modHydrolic = GetVehicleMod(vehicle, 38),
			modEngineBlock = GetVehicleMod(vehicle, 39),
			modAirFilter = GetVehicleMod(vehicle, 40),
			modStruts = GetVehicleMod(vehicle, 41),
			modArchCover = GetVehicleMod(vehicle, 42),
			modAerials = GetVehicleMod(vehicle, 43),
			modTrimB = GetVehicleMod(vehicle, 44),
			modTank = GetVehicleMod(vehicle, 45),
			modWindows = GetVehicleMod(vehicle, 46),
			modLivery = modLivery,
		}
	else
		return
	end
end

function SetVehicleProperties(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)
		if props.plate then
			SetVehicleNumberPlateText(vehicle, props.plate)
		end
		if props.plateIndex then
			SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex)
		end
		if props.bodyHealth then
			SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
		end
		if props.engineHealth then
			SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
		end
		if props.fuelLevel then
			SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0)
		end
		if props.dirtLevel then
			SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
		end
		if props.color1 then
			if type(props.color1) == "number" then
				SetVehicleColours(vehicle, props.color1, colorSecondary)
			else
				SetVehicleCustomPrimaryColour(vehicle, props.color1[1], props.color1[2], props.color1[3])
			end
		end
		if props.color2 then
			if type(props.color2) == "number" then
				if (type(props.color1) == "number") then
					SetVehicleColours(vehicle, props.color1, props.color2)
				else
					SetVehicleColours(vehicle, colorPrimary, props.color2)
				end
			else
				SetVehicleCustomSecondaryColour(vehicle, props.color2[1], props.color2[2], props.color2[3])
			end
		end
		if props.pearlescentColor then
			SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor)
		end
		if props.interiorColor then
			SetVehicleInteriorColor(vehicle, props.interiorColor)
		end
		if props.dashboardColor then
			SetVehicleDashboardColour(vehicle, props.dashboardColor)
		end
		if props.wheelColor then
			SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor)
		end
		if props.wheels then
			SetVehicleWheelType(vehicle, props.wheels)
		end
		if props.windowTint then
			SetVehicleWindowTint(vehicle, props.windowTint)
		end
		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end
		if props.extras then
			for id, enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(id), 0)
				else
					SetVehicleExtra(vehicle, tonumber(id), 1)
				end
			end
		end
		if props.neonColor then
			SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
		end
		if props.modSmokeEnabled then
			ToggleVehicleMod(vehicle, 20, true)
		end
		if props.tyreSmokeColor then
			SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
		end
		if props.modSpoilers then
			SetVehicleMod(vehicle, 0, props.modSpoilers, false)
		end
		if props.modFrontBumper then
			SetVehicleMod(vehicle, 1, props.modFrontBumper, false)
		end
		if props.modRearBumper then
			SetVehicleMod(vehicle, 2, props.modRearBumper, false)
		end
		if props.modSideSkirt then
			SetVehicleMod(vehicle, 3, props.modSideSkirt, false)
		end
		if props.modExhaust then
			SetVehicleMod(vehicle, 4, props.modExhaust, false)
		end
		if props.modFrame then
			SetVehicleMod(vehicle, 5, props.modFrame, false)
		end
		if props.modGrille then
			SetVehicleMod(vehicle, 6, props.modGrille, false)
		end
		if props.modHood then
			SetVehicleMod(vehicle, 7, props.modHood, false)
		end
		if props.modFender then
			SetVehicleMod(vehicle, 8, props.modFender, false)
		end
		if props.modRightFender then
			SetVehicleMod(vehicle, 9, props.modRightFender, false)
		end
		if props.modRoof then
			SetVehicleMod(vehicle, 10, props.modRoof, false)
		end
		if props.modEngine then
			SetVehicleMod(vehicle, 11, props.modEngine, false)
		end
		if props.modBrakes then
			SetVehicleMod(vehicle, 12, props.modBrakes, false)
		end
		if props.modTransmission then
			SetVehicleMod(vehicle, 13, props.modTransmission, false)
		end
		if props.modHorns then
			SetVehicleMod(vehicle, 14, props.modHorns, false)
		end
		if props.modSuspension then
			SetVehicleMod(vehicle, 15, props.modSuspension, false)
		end
		if props.modArmor then
			SetVehicleMod(vehicle, 16, props.modArmor, false)
		end
		if props.modTurbo then
			ToggleVehicleMod(vehicle, 18, props.modTurbo)
		end
		if props.modXenon then
			ToggleVehicleMod(vehicle, 22, props.modXenon)
		end
		if props.xenonColor then
			SetVehicleXenonLightsColor(vehicle, props.xenonColor)
		end
		if props.modFrontWheels then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, false)
		end
		if props.modBackWheels then
			SetVehicleMod(vehicle, 24, props.modBackWheels, false)
		end
		if props.modCustomTiresF then
			SetVehicleMod(vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
		end
		if props.modCustomTiresR then
			SetVehicleMod(vehicle, 24, props.modBackWheels, props.modCustomTiresR)
		end
		if props.modPlateHolder then
			SetVehicleMod(vehicle, 25, props.modPlateHolder, false)
		end
		if props.modVanityPlate then
			SetVehicleMod(vehicle, 26, props.modVanityPlate, false)
		end
		if props.modTrimA then
			SetVehicleMod(vehicle, 27, props.modTrimA, false)
		end
		if props.modOrnaments then
			SetVehicleMod(vehicle, 28, props.modOrnaments, false)
		end
		if props.modDashboard then
			SetVehicleMod(vehicle, 29, props.modDashboard, false)
		end
		if props.modDial then
			SetVehicleMod(vehicle, 30, props.modDial, false)
		end
		if props.modDoorSpeaker then
			SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false)
		end
		if props.modSeats then
			SetVehicleMod(vehicle, 32, props.modSeats, false)
		end
		if props.modSteeringWheel then
			SetVehicleMod(vehicle, 33, props.modSteeringWheel, false)
		end
		if props.modShifterLeavers then
			SetVehicleMod(vehicle, 34, props.modShifterLeavers, false)
		end
		if props.modAPlate then
			SetVehicleMod(vehicle, 35, props.modAPlate, false)
		end
		if props.modSpeakers then
			SetVehicleMod(vehicle, 36, props.modSpeakers, false)
		end
		if props.modTrunk then
			SetVehicleMod(vehicle, 37, props.modTrunk, false)
		end
		if props.modHydrolic then
			SetVehicleMod(vehicle, 38, props.modHydrolic, false)
		end
		if props.modEngineBlock then
			SetVehicleMod(vehicle, 39, props.modEngineBlock, false)
		end
		if props.modAirFilter then
			SetVehicleMod(vehicle, 40, props.modAirFilter, false)
		end
		if props.modStruts then
			SetVehicleMod(vehicle, 41, props.modStruts, false)
		end
		if props.modArchCover then
			SetVehicleMod(vehicle, 42, props.modArchCover, false)
		end
		if props.modAerials then
			SetVehicleMod(vehicle, 43, props.modAerials, false)
		end
		if props.modTrimB then
			SetVehicleMod(vehicle, 44, props.modTrimB, false)
		end
		if props.modTank then
			SetVehicleMod(vehicle, 45, props.modTank, false)
		end
		if props.modWindows then
			SetVehicleMod(vehicle, 46, props.modWindows, false)
		end
		if props.modLivery then
			SetVehicleMod(vehicle, 48, props.modLivery, false)
			SetVehicleLivery(vehicle, props.modLivery)
		end
	end
end