-----------------------------------------------------------------------------------------------------------------------------------------
-- TYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
local oldSpeed = 0
local Aiming = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- BIKESMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
local bikesModel = {
	[1131912276] = true,
	[448402357] = true,
	[-836512833] = true,
	[-186537451] = true,
	[1127861609] = true,
	[-1233807380] = true,
	[-400295096] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			timeDistance = 1

			DisableControlAction(0,345,true)

			if GetPedConfigFlag(ped,78,true) then
				if not Aiming then
					Aiming = GetFollowVehicleCamViewMode()
				end

				SetFollowVehicleCamViewMode(4)
			else
				if Aiming then
					SetFollowVehicleCamViewMode(Aiming)
					Aiming = false
				end
			end

			local vehicle = GetVehiclePedIsUsing(ped)
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				local speed = GetEntitySpeed(vehicle) * 3.6
				if speed ~= oldSpeed then
					if (oldSpeed - speed) >= 100 then
						TriggerServerEvent("upgradeStress",10)

						if GetVehicleClass(vehicle) ~= 8 then
							SetVehicleEngineOn(vehicle,false,true,true)

							local vehModel = GetEntityModel(vehicle)
							if bikesModel[vehModel] == nil then
								vehicleTyreBurst(vehicle)
							end
						end
					end

					oldSpeed = speed
				end
			end
		else
			if oldSpeed ~= 0 then
				oldSpeed = 0
			end

			if Aiming then
				Aiming = false
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDRIFT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			if GetPedInVehicleSeat(vehicle,-1) == ped then
				local vehClass = GetVehicleClass(vehicle)
				if (vehClass >= 0 and vehClass <= 7) or vehClass == 9 or vehClass == 18 then
					if IsControlPressed(1,21) then
						local speed = GetEntitySpeed(vehicle) * 3.6
						if speed <= 75.0 then
							SetVehicleReduceGrip(vehicle,true)

							if not GetDriftTyresEnabled(vehicle) then
								SetDriftTyresEnabled(vehicle,true)
								SetReduceDriftVehicleSuspension(vehicle,true)
							end
						end
					else
						SetVehicleReduceGrip(vehicle,false)

						if GetDriftTyresEnabled(vehicle) then
							SetDriftTyresEnabled(vehicle,false)
							SetReduceDriftVehicleSuspension(vehicle,false)
						end
					end
				end
			end
		end

		Citizen.Wait(100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYREBURST
-----------------------------------------------------------------------------------------------------------------------------------------
function vehicleTyreBurst(Vehicle)
	local Tyre = math.random(4)

	if Tyre == 1 then
		if GetTyreHealth(Vehicle,0) == 1000.0 then
			SetVehicleTyreBurst(Vehicle,0,true,1000.0)
		end
	elseif Tyre == 2 then
		if GetTyreHealth(Vehicle,1) == 1000.0 then
			SetVehicleTyreBurst(Vehicle,1,true,1000.0)
		end
	elseif Tyre == 3 then
		if GetTyreHealth(Vehicle,4) == 1000.0 then
			SetVehicleTyreBurst(Vehicle,4,true,1000.0)
		end
	elseif Tyre == 4 then
		if GetTyreHealth(Vehicle,5) == 1000.0 then
			SetVehicleTyreBurst(Vehicle,5,true,1000.0)
		end
	end

	if math.random(100) < 30 then
		Citizen.Wait(500)
		vehicleTyreBurst(Vehicle)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = {
	{ 214.53,-896.13,30.68,433,62,"Arena PVP",0.7 },
	{ -724.83,-1444.15,5.0,43,5,"Heliponto",0.7 },
	{ 1239.87,-3257.2,7.09,67,62,"Caminhoneiro",0.5 },
	{ 1151.5,-1529.12,35.18,61,1,"Hospital",0.6 },
	{ -247.42,6331.39,32.42,61,1,"Hospital",0.6 },
	{ -69.71,-1230.73,28.93,357,40,"Armazéns",0.6 },
	{ 55.43,-876.19,30.66,357,5,"Garagem",0.6 },
	{ 598.04,2741.27,42.07,357,65,"Garagem",0.6 },
	{ -136.36,6357.03,31.49,357,5,"Garagem",0.6 },
	{ 275.23,-345.54,45.17,357,65,"Garagem",0.6 },
	{ 596.40,90.65,93.12,357,65,"Garagem",0.6 },
	{ -340.76,265.97,85.67,357,65,"Garagem",0.6 },
	{ -2030.01,-465.97,11.60,357,65,"Garagem",0.6 },
	{ -1184.92,-1510.00,4.64,357,65,"Garagem",0.6 },
	{ 214.02,-808.44,31.01,357,65,"Garagem",0.6 },
	{ -348.88,-874.02,31.31,357,65,"Garagem",0.6 },
	{ 67.74,12.27,69.21,357,65,"Garagem",0.6 },
	{ 361.90,297.81,103.88,357,65,"Garagem",0.6 },
	{ 1035.89,-763.89,57.99,357,65,"Garagem",0.6 },
	{ -796.63,-2022.77,9.16,357,65,"Garagem",0.6 },
	{ 453.27,-1146.76,29.52,357,65,"Garagem",0.6 },
	{ 528.66,-146.3,58.38,357,65,"Garagem",0.6 },
	{ -1159.48,-739.32,19.89,357,65,"Garagem",0.6 },
	{ 101.22,-1073.68,29.38,357,65,"Garagem",0.6 },
	{ 1725.21,4711.77,42.11,357,65,"Garagem",0.6 },
	{ 1624.05,3566.14,35.15,357,5,"Garagem",0.6 },
	{ -73.35,-2004.6,18.27,357,65,"Garagem",0.6 }, 
	{ 1260.6,-3066.79,5.9,357,5,"Garagem",0.6 },
	{ 426.52,-980.82,30.7,60,18,"Departamento | Polícia",0.6 },
	{ 243.1,224.81,106.29,108,2,"Banco Central",0.5 },
	{ -815.12,-184.15,37.57,71,62,"Barbearia",0.5 },
	{ 138.13,-1706.46,29.3,71,62,"Barbearia",0.5 },
	{ -1280.92,-1117.07,7.0,71,62,"Barbearia",0.5 },
	{ 1930.54,3732.06,32.85,71,62,"Barbearia",0.5 },
	{ 1214.2,-473.18,66.21,71,62,"Barbearia",0.5 },
	{ -33.61,-154.52,57.08,71,62,"Barbearia",0.5 },
	{ -276.65,6226.76,31.7,71,62,"Barbearia",0.5 },
	{ -1117.26,-1438.74,5.11,366,62,"Loja de Roupas",0.5 },
	{ 75.35,-1392.92,29.38,366,62,"Loja de Roupas",0.5 },
	{ -710.15,-152.36,37.42,366,62,"Loja de Roupas",0.5 },
	{ -163.73,-303.62,39.74,366,62,"Loja de Roupas",0.5 },
	{ -822.38,-1073.52,11.33,366,62,"Loja de Roupas",0.5 },
	{ -1193.13,-767.93,17.32,366,62,"Loja de Roupas",0.5 },
	{ -1449.83,-237.01,49.82,366,62,"Loja de Roupas",0.5 },
	{ 4.83,6512.44,31.88,366,62,"Loja de Roupas",0.5 },
	{ 1693.95,4822.78,42.07,366,62,"Loja de Roupas",0.5 },
	{ 125.82,-223.82,54.56,366,62,"Loja de Roupas",0.5 },
	{ 614.2,2762.83,42.09,366,62,"Loja de Roupas",0.5 },
	{ 1196.72,2710.26,38.23,366,62,"Loja de Roupas",0.5 },
	{ -3170.53,1043.68,20.87,366,62,"Loja de Roupas",0.5 },
	{ -1101.42,2710.63,19.11,366,62,"Loja de Roupas",0.5 },
	{ 425.6,-806.25,29.5,366,62,"Loja de Roupas",0.5 },
	--{ 1945.39,3773.5,32.27,366,62,"Loja de Roupas",0.5 },
	{ -1082.22,-247.54,37.77,439,73,"Life Invader",0.6 },
	{ -1728.06,-1050.69,1.71,266,62,"Embarcações",0.5 },
	{ 1966.36,3975.86,31.51,266,62,"Embarcações",0.5 },
	{ -776.72,-1495.02,2.29,266,62,"Embarcações",0.5 },
	{ -893.97,5687.78,3.29,266,62,"Embarcações",0.5 },
	{ 4952.76,-5163.6,-0.3,266,62,"Embarcações",0.5 },
	{ 452.99,-607.74,28.59,513,62,"Motorista",0.5 },
	{ 356.42,274.61,103.14,67,62,"Transportador",0.5 },
	{ -840.21,5399.25,34.61,285,62,"Lenhador",0.5 },
	{ 132.6,-1305.06,29.2,93,62,"Vanilla Unicorn",0.5 },
	{ -565.14,271.56,83.02,93,62,"Tequi-La-La",0.5 },
	{ -172.21,6385.85,31.49,403,5,"Farmácia",0.7 },
	{ 1690.07,3581.68,35.62,403,5,"Farmácia",0.7 },
	{ 315.12,-1068.58,29.39,403,5,"Farmácia",0.7 },
	{ 114.45,-4.89,67.82,403,5,"Farmácia",0.7 },
	{ -490.82,-218.82,36.58,197,0,"Yoga",0.6 },
	{ 82.54,-1553.28,29.59,318,62,"Lixeiro",0.6 },
	{ 287.36,2843.6,44.7,318,62,"Lixeiro",0.6 },
	{ -413.97,6171.58,31.48,318,62,"Lixeiro",0.6 },
	{ -428.56,-1728.33,19.79,467,11,"Reciclagem",0.6 },
	{ 180.07,2793.29,45.65,467,11,"Reciclagem",0.6 },
	{ -195.42,6264.62,31.49,467,11,"Reciclagem",0.6 },
	{ -741.56,5594.94,41.66,36,62,"Teleférico",0.6 },
	{ 454.46,5571.95,781.19,36,62,"Teleférico",0.6 },
	{ -191.92,-1155.04,23.05,357,9,"Impound",0.6 },
	{ 1724.84,3715.31,34.22,357,9,"Impound",0.6 },
	{ -273.96,6121.63,31.41,357,9,"Impound",0.6 },
	{ 819.38,-809.02,26.18,402,9,"Bennys Motorworks",0.9 },
	{ -326.86,-137.55,39.01,402,9,"Los Santos Customs",0.9 },
	{ -620.61,-225.15,38.05,617,62,"Joalheria",0.6 },
	{ 1524.18,3783.93,34.49,628,62,"comprador Pescados",0.4 },
	{ 1792.83,4589.89,37.68,628,62,"Horti-Frutti Comprador",0.6 },
	{ -594.97,2090.46,131.56,617,62,"Minerador",0.6 },
	{ 1322.93,-1652.29,52.27,75,13,"Loja de Tatuagem",0.5 },
	{ -1154.42,-1425.9,4.95,75,13,"Loja de Tatuagem",0.5 },
	{ 322.84,180.16,103.58,75,13,"Loja de Tatuagem",0.5 },
	{ -3169.62,1075.8,20.83,75,13,"Loja de Tatuagem",0.5 },
	{ 1864.07,3747.9,33.03,75,13,"Loja de Tatuagem",0.5 },
	{ -293.57,6199.85,31.48,75,13,"Loja de Tatuagem",0.5 },
	{ 1520.21,3779.49,34.46,86,62,"The Boat House",0.4 },
	{ 405.92,6526.12,27.73,89,62,"Colheita",0.4 },
	{ 2301.09,5064.78,45.81,76,62,"Agricultor",0.4 },
	{ 2440.58,4736.35,34.29,77,62,"Retirar Leite",0.4 },
	{ -1178.2,-880.6,13.92,408,62,"BurgerShot",0.5 },
	{ 1584.93,6447.82,25.14,408,62,"Pop's Diner",0.5 },
	{ -580.93,-1074.92,22.33,408,62,"Dishes & Desserts",0.5 },
	{ 789.67,-758.2,26.72,408,62,"Pizza This",0.5 },
	{ -39.5,-1111.34,26.44,523,62,"Concessionária de Veículos",0.6 },
	-- { -61.41,58.48,72.02,523,62,"Concessionária de Luxo",0.6 },
	-- { 1224.6,2726.56,38.0,67,62,"Concessionária de Utilitários",0.6 },
	-- { 286.95,-1146.18,29.28,226,62,"Concessionária de Motocicletas",0.8 },
	{ -604.39,-933.23,23.86,184,62,"Weazel News",0.6 },
	{ 919.38,-182.83,74.02,198,62,"Taxista",0.5 },
	{ 1696.19,4785.25,42.02,198,62,"Taxista",0.5 },
	{ -680.9,5832.41,17.32,141,62,"Cabana do Caçador",0.7 },
	{ -772.69,312.77,85.7,475,31,"Hotel",0.5 },
	{ 1142.33,2663.9,38.16,475,31,"Hotel",0.5 },
	{ 562.36,2741.56,42.87,273,11,"Animal Park",0.5 },
	{ 1655.27,4874.31,42.04,374,11,"Imobiliária",0.5 },
	{ -308.09,-163.93,40.42,374,11,"Imobiliária",0.5 },
	{ 1185.21,-1461.05,34.88,436,1,"Bombeiros",0.5 },
	{ -535.04,-221.34,37.64,267,5,"Prefeitura",0.6 },
	{ -1913.48,-574.11,11.43,440,62,"Escritório",0.7 },
	{ -1745.44,-205.0,57.39,305,13,"Cemitério",0.7 },
	{ 918.69,50.33,80.9,680,28,"Cassino",0.7 },
	{ -714.55,-917.8,19.22,52,36,"Loja de Departamento",0.5 },
	{ -55.74,-1756.03,29.44,52,36,"Loja de Departamento",0.5 },
	{ 31.67,-1349.98,29.34,52,36,"Loja de Departamento",0.5 },
	{ 1155.77,-328.34,69.21,52,36,"Loja de Departamento",0.5 },
	{ 378.81,322.14,103.39,52,36,"Loja de Departamento",0.5 },
	{ 1141.98,-978.88,46.3,52,36,"Loja de Departamento",0.5 },
	{ -1223.62,-899.67,12.42,52,36,"Loja de Departamento",0.5 },
	{ -1495.42,-381.25,40.35,52,36,"Loja de Departamento",0.5 },
	{ -2974.32,392.95,15.04,52,36,"Loja de Departamento",0.5 },
	{ -3038.45,592.96,7.82,52,36,"Loja de Departamento",0.5 },
	{ -3239.67,1011.97,12.35,52,36,"Loja de Departamento",0.5 },
	{ 547.76,2674.09,42.19,52,36,"Loja de Departamento",0.5 },
	{ 1168.17,2702.51,38.18,52,36,"Loja de Departamento",0.5 },
	{ 2560.25,382.86,108.63,52,36,"Loja de Departamento",0.5 },
	{ 2680.17,3277.22,55.41,52,36,"Loja de Departamento",0.5 },
	{ 1963.05,3737.36,32.37,52,36,"Loja de Departamento",0.5 },
	{ 1700.38,4932.97,42.08,52,36,"Loja de Departamento",0.5 },
	{ 1733.3,6409.48,35.01,52,36,"Loja de Departamento",0.5 },
	{ 157.71,6640.84,31.59,52,36,"Loja de Departamento",0.5 }, 
	{ 817.5,-785.93,26.18,52,36,"Loja de Departamento",0.5 },
	{ 6.77,-1100.28,29.8,76,6,"Loja de Armas",0.4 },
	{ -661.14,-944.72,21.79,76,6,"Loja de Armas",0.4 },
	{ 815.47,-2147.44,29.43,76,6,"Loja de Armas",0.4 },
	{ 840.85,-1022.02,27.54,76,6,"Loja de Armas",0.4 },
	{ -1315.67,-392.9,36.59,76,6,"Loja de Armas",0.4 },
	{ 244.38,-43.17,69.9,76,6,"Loja de Armas",0.4 },
	{ 2566.73,303.76,108.61,76,6,"Loja de Armas",0.4 },
	{ -3162.59,1085.29,20.85,76,6,"Loja de Armas",0.4 },
	{ -1114.59,2688.71,18.61,76,6,"Loja de Armas",0.4 },
	{ 1701.42,3754.37,34.35,76,6,"Loja de Armas",0.4 },
	{ -322.51,6077.36,31.25,76,6,"Loja de Armas",0.4 },
	{ 48.26,-1747.0,29.31,78,11,"Mercado Central",0.5 },
	{ 2747.37,3465.68,55.7,78,11,"Mercado Central",0.5 },
	{ 1204.63,-3108.17,5.53,477,26,"Truck Logistics",0.6 }, 
	{ -1522.29,-411.42,35.59,459,2,"DigitalDen",0.5 },
	{ 265.05,-1262.65,29.3,361,41,"Posto de Gasolina",0.4 }, 
	{ 819.02,-1027.96,26.41,361,41,"Posto de Gasolina",0.4 },
	{ 1208.61,-1402.43,35.23,361,41,"Posto de Gasolina",0.4 },
	{ 1181.48,-330.26,69.32,361,41,"Posto de Gasolina",0.4 },
	{ 621.01,268.68,103.09,361,41,"Posto de Gasolina",0.4 },
	{ 2581.09,361.79,108.47,361,41,"Posto de Gasolina",0.4 },
	{ 175.08,-1562.12,29.27,361,41,"Posto de Gasolina",0.4 },
	{ -319.76,-1471.63,30.55,361,41,"Posto de Gasolina",0.4 },
	{ 49.42,2778.8,58.05,361,41,"Posto de Gasolina",0.4 },
	{ 264.09,2606.56,44.99,361,41,"Posto de Gasolina",0.4 },
	{ 1039.38,2671.28,39.56,361,41,"Posto de Gasolina",0.4 },
	{ 1207.4,2659.93,37.9,361,41,"Posto de Gasolina",0.4 },
	{ 2539.19,2594.47,37.95,361,41,"Posto de Gasolina",0.4 },
	{ 2679.95,3264.18,55.25,361,41,"Posto de Gasolina",0.4 },
	{ 2005.03,3774.43,32.41,361,41,"Posto de Gasolina",0.4 },
	{ 1687.07,4929.53,42.08,361,41,"Posto de Gasolina",0.4 },
	{ 1701.53,6415.99,32.77,361,41,"Posto de Gasolina",0.4 },
	{ 180.1,6602.88,31.87,361,41,"Posto de Gasolina",0.4 },
	{ -94.46,6419.59,31.48,361,41,"Posto de Gasolina",0.4 },
	{ -2555.17,2334.23,33.08,361,41,"Posto de Gasolina",0.4 },
	{ -1800.09,803.54,138.72,361,41,"Posto de Gasolina",0.4 },
	{ -1437.0,-276.8,46.21,361,41,"Posto de Gasolina",0.4 },
	{ -2096.3,-320.17,13.17,361,41,"Posto de Gasolina",0.4 },
	{ -724.56,-935.97,19.22,361,41,"Posto de Gasolina",0.4 },
	{ -525.26,-1211.19,18.19,361,41,"Posto de Gasolina",0.4 },
	{ -70.96,-1762.21,29.54,361,41,"Posto de Gasolina",0.4 },
	{ 1776.7,3330.56,41.32,361,41,"Posto de Gasolina",0.4 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for _,v in pairs(blips) do
		local blip = AddBlipForCoord(v[1],v[2],v[3])
		SetBlipSprite(blip,v[4])
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,v[5])
		SetBlipScale(blip,v[7])
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v[6])
		EndTextCommandSetBlipName(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local alphas = {
	
	{ -142.24,-1174.19,23.76,10,17,175 },
	{ 1724.84,3715.31,34.22,10,17,175 },
	{ -305.45,6117.62,31.49,10,17,175 },
	{ 156.44,-1065.79,30.04,10,66,175 },
	{ -1188.13,-1574.47,4.35,10,66,175 },
	{ -777.44,5593.64,33.63,10,66,175 },
	{ 523.65,-1828.87,28.46,10,66,175 },
	{ 102.74,-1959.16,20.79,10,66,175 },
	{ 337.63,-2036.08,21.37,10,66,175 },
	{ -161.39,-1628.59,33.63,10,66,175 },
	{ 236.22,-1702.66,29.23,10,66,175 },
	{ -23.28,-149.16,56.94,10,66,175 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADALPHA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for _,v in pairs(alphas) do
		local blip = AddBlipForRadius(v[1],v[2],v[3],v[4] + 0.0)
		SetBlipAlpha(blip,v [6])
		SetBlipColour(blip,v[5])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISPATCH
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for i = 1,25 do
		EnableDispatchService(i,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS fuck cops
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		InvalidateIdleCam()
		InvalidateVehicleIdleCam()

		SetCreateRandomCops(false)
		CancelCurrentPoliceReport()
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)

		SetVehicleModelIsSuppressed(GetHashKey("jet"),true)
		SetVehicleModelIsSuppressed(GetHashKey("besra"),true)
		SetVehicleModelIsSuppressed(GetHashKey("luxor"),true)
		SetVehicleModelIsSuppressed(GetHashKey("blimp"),true)
		SetVehicleModelIsSuppressed(GetHashKey("polmav"),true)
		SetVehicleModelIsSuppressed(GetHashKey("buzzard2"),true)
		SetVehicleModelIsSuppressed(GetHashKey("mammatus"),true)
		-- SetPedModelIsSuppressed(GetHashKey("s_m_y_prismuscl_01"),true)
		-- SetPedModelIsSuppressed(GetHashKey("u_m_y_prisoner_01"),true)
		-- SetPedModelIsSuppressed(GetHashKey("s_m_y_prisoner_01"),true)

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		SetWeaponDamageModifierThisFrame("WEAPON_BAT",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_HAMMER",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_WRENCH",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_UNARMED",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_HATCHET",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_CROWBAR",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_MACHETE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_POOLCUE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_KNUCKLE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_GOLFCLUB",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_BATTLEAXE",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_FLASHLIGHT",0.25)
		SetWeaponDamageModifierThisFrame("WEAPON_NIGHTSTICK",0.35)
		SetWeaponDamageModifierThisFrame("WEAPON_STONE_HATCHET",0.25)

		RemoveAllPickupsOfType("PICKUP_WEAPON_KNIFE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PISTOL")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MINISMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_MICROSMG")
		RemoveAllPickupsOfType("PICKUP_WEAPON_PUMPSHOTGUN")
		RemoveAllPickupsOfType("PICKUP_WEAPON_CARBINERIFLE")
		RemoveAllPickupsOfType("PICKUP_WEAPON_SAWNOFFSHOTGUN")

		DisablePlayerVehicleRewards(PlayerId())

		HideHudComponentThisFrame(1)
		HideHudComponentThisFrame(3)
		HideHudComponentThisFrame(4)
		HideHudComponentThisFrame(5)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(10)
		HideHudComponentThisFrame(11)
		HideHudComponentThisFrame(12)
		HideHudComponentThisFrame(13)
		HideHudComponentThisFrame(15)
		HideHudComponentThisFrame(17)
		HideHudComponentThisFrame(18)
		HideHudComponentThisFrame(21)
		HideHudComponentThisFrame(22)

		DisableControlAction(1,37,true)
		DisableControlAction(1,204,true)
		DisableControlAction(1,211,true)
		DisableControlAction(1,349,true)
		DisableControlAction(1,192,true)
		DisableControlAction(1,157,true)
		DisableControlAction(1,158,true)
		DisableControlAction(1,159,true)
		DisableControlAction(1,160,true)
		DisableControlAction(1,161,true)
		DisableControlAction(1,162,true)
		DisableControlAction(1,163,true)
		DisableControlAction(1,164,true)
		DisableControlAction(1,165,true)

		SetEveryoneIgnorePlayer(PlayerPedId(),true)
		SetPlayerCanBeHassledByGangs(PlayerPedId(),false)
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(),true)
		if LocalPlayer["state"]["Route"] > 0 then
			SetVehicleDensityMultiplierThisFrame(0.0)
			SetRandomVehicleDensityMultiplierThisFrame(0.0)
			SetParkedVehicleDensityMultiplierThisFrame(0.0)
			SetAmbientVehicleRangeMultiplierThisFrame(0.0)
			SetScenarioPedDensityMultiplierThisFrame(0.0,0.0)
			SetPedDensityMultiplierThisFrame(0.0)
		else
			SetVehicleDensityMultiplierThisFrame(0.5)
			SetRandomVehicleDensityMultiplierThisFrame(0.4)
			SetParkedVehicleDensityMultiplierThisFrame(0.4)
			SetAmbientVehicleRangeMultiplierThisFrame(0.5)
			SetScenarioPedDensityMultiplierThisFrame(0.3,0.4)
			SetPedDensityMultiplierThisFrame(0.4)
			SetGarbageTrucks(false)
			SetRandomBoats(false)
		end

		if IsPedArmed(PlayerPedId(),6) then
			DisableControlAction(1,140,true)
			DisableControlAction(1,141,true)
			DisableControlAction(1,142,true)
		end

		Citizen.Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
local ipList = {
	{
		props = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		coords = { -1150.70,-1520.70,10.60 }
	},{
		props = {
			"csr_beforeMission",
			"csr_inMission"
		},
		coords = { -47.10,-1115.30,26.50 }
	},{
		props = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		coords = { -802.30,175.00,72.80 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADIPLOADER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for _k,_v in pairs(ipList) do
		local interiorCoords = GetInteriorAtCoords(_v["coords"][1],_v["coords"][2],_v["coords"][3])
		LoadInterior(interiorCoords)

		if _v["props"] ~= nil then
			for k,v in pairs(_v["props"]) do
				EnableInteriorProp(interiorCoords,v)
				Citizen.Wait(1)
			end
		end

		RefreshInterior(interiorCoords)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local teleport = {
	{ -741.07,5593.13,41.66,446.19,5568.79,781.19 },
	{ 446.19,5568.79,781.19,-741.07,5593.13,41.66 },

	{ -740.78,5597.04,41.66,446.37,5575.02,781.19 },
	{ 446.37,5575.02,781.19,-740.78,5597.04,41.66 },
	{ -1898.46,-572.36,11.85,-1902.05,-572.42,19.09 },
	{ -1902.05,-572.42,19.09,-1898.46,-572.36,11.85 },
	{ -186.71,-1703.43,33.01,-197.56,-1699.85,33.48 },
	{ -197.56,-1699.85,33.48,-186.71,-1703.43,33.01 },

	{ 1089.67,206.05,-49.0,935.9,46.96,81.1 },
	{ 935.9,46.96,81.1,1089.67,206.05,-49.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local innerTable = {}

	for k,v in pairs(teleport) do
		table.insert(innerTable,{ v[1],v[2],v[3],1,"E","Porta de Acesso","Pressione para acessar" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			for _,v in pairs(teleport) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 1 then
					timeDistance = 1

					if IsControlJustPressed(1,38) then
						SetEntityCoords(ped,v[4],v[5],v[6],1,0,0,0)
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			local distance = #(coords - vector3(254.01,225.21,101.87))
			if distance <= 3.0 then
				timeDistance = 1

				if IsControlJustPressed(1,38) then
					local handle,object = FindFirstObject()
					local finished = false

					repeat
						local heading = GetEntityHeading(object)
						local coordsObj = GetEntityCoords(object)
						local distanceObjs = #(coordsObj - coords)

						if distanceObjs < 3.0 and GetEntityModel(object) == 961976194 then
							if heading > 150.0 then
								SetEntityHeading(object,0.0)
							else
								SetEntityHeading(object,160.0)
							end

							FreezeEntityPosition(object,true)
							finished = true
						end

						finished,object = FindNextObject(handle)
					until not finished

					EndFindObject(handle)
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	TriggerEvent("hoverfy:insertTable",{{ 254.01,225.21,101.87,1.5,"E","Porta do Cofre","Pressione para abrir/fechar" }})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUNNYHOP
-----------------------------------------------------------------------------------------------------------------------------------------
local bunnyHope = GetGameTimer()
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			if GetGameTimer() <= bunnyHope then
				timeDistance = 1
				DisableControlAction(1,22,true)
			else
				if IsPedJumping(ped) then
					bunnyHope = GetGameTimer() + 5000
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_max = 80.0
local fov_min = 10.0
local speed_ud = 3.0
local zoomspeed = 2.0
local vehCamera = false
local fov = (fov_max + fov_min) * 0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local waitPacket = 500
		local ped = PlayerPedId()
		if IsPedInAnyHeli(ped) then
			waitPacket = 4

			local veh = GetVehiclePedIsUsing(ped)
			SetVehicleRadioEnabled(veh,false)

			if IsControlJustPressed(1,51) then
				TriggerEvent("hud:Active",false)
				vehCamera = true
			end

			if IsControlJustPressed(1,154) then
				if GetPedInVehicleSeat(veh,1) == ped or GetPedInVehicleSeat(veh,2) == ped then
					TaskRappelFromHeli(ped,1)
				end
			end

			if vehCamera then
				SetTimecycleModifierStrength(0.3)
				SetTimecycleModifier("heliGunCam")

				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(1)
				end

				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
				AttachCamToEntity(cam,veh,0.0,0.0,-1.5,true)
				SetCamRot(cam,0.0,0.0,GetEntityHeading(veh))
				SetCamFov(cam,fov)
				RenderScriptCams(true,false,0,1,0)
				PushScaleformMovieFunction(scaleform,"SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(0)
				PopScaleformMovieFunctionVoid()

				while vehCamera do
					if IsControlJustPressed(1,51) then
						TriggerEvent("hud:Active",true)
						vehCamera = false
					end

					local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
					CheckInputRotation(cam,zoomvalue)
					HandleZoom(cam)
					HideHudAndRadarThisFrame()
					HideHudComponentThisFrame(19)
					PushScaleformMovieFunction(scaleform,"SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(veh).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam,2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)

					Citizen.Wait(1)
				end

				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5
				RenderScriptCams(false,false,0,1,0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam,false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end

		Citizen.Wait(waitPacket)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0,rotation.x + rightAxisY * -1.0 * (3.0) * (zoomvalue + 0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov - zoomspeed,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov + zoomspeed,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then
		fov = current_fov
	end

	SetCamFov(cam,current_fov + (fov - current_fov) * 0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVISIBLABLES
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer["state"]["Invisible"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHACKER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local ped = PlayerPedId()

			if not IsEntityVisible(ped) and not LocalPlayer["state"]["Invisible"] then
				TriggerServerEvent("admin:Hacker","está invisível")
			end

			if ForceSocialClubUpdate == nil then
				TriggerServerEvent("admin:Hacker","forçou a social club.")
			end

			if ShutdownAndLaunchSinglePlayerGame == nil then
				TriggerServerEvent("admin:Hacker","entrou no modo single player.")
			end

			if ActivateRockstarEditor == nil then
				TriggerServerEvent("admin:Hacker","ativou o rockstar editor.")
			end
		end

		Citizen.Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ILHA CAIO PERICO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
		SetRadarAsExteriorThisFrame()
		SetRadarAsInteriorThisFrame("h4_fake_islandx",vec(4700.0,-5145.0),0,0)
	end
end)