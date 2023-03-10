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
Tunnel.bindInterface("tablet",cRP)
vCLIENT = Tunnel.getInterface("tablet")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local actived = {}
GlobalState["Cars"] = {}
GlobalState["Bikes"] = {}
GlobalState["Rental"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ASYNCFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local Cars = {}
	local Bikes = {}
	local Rental = {}
	local vehicles = vehicleGlobal()

	for k,v in pairs(vehicles) do
		if v[4] == "cars" then
			table.insert(Cars,{ k = k, name = v[1], price = v[3], chest = v[2], tax = parseInt(v[3] * 0.10) })
		elseif v[4] == "bikes" then
			table.insert(Bikes,{ k = k, name = v[1], price = v[3], chest = v[2], tax = parseInt(v[3] * 0.10) })
		elseif v[4] == "rental" then
			table.insert(Rental,{ k = k, name = v[1], price = v[5], chest = v[2], tax = parseInt(v[3] * 0.10) })
		end
	end

	GlobalState["Cars"] = Cars
	GlobalState["Bikes"] = Bikes
	GlobalState["Rental"] = Rental
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPOSSUIDOS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPossuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehList = {}
		local vehicles = vRP.query("vehicles/getVehicles",{ user_id = user_id })
		for k,v in pairs(vehicles) do
			local vehicleRental = 0
			local vehicleTax = "Atrasado"
			local vehPrices = vehiclePrice(v["vehicle"]) * 0.50

			if v["tax"] > os.time() then
				vehicleTax = minimalTimers(v["tax"] - os.time())
			end

			if vehicleType(v["vehicle"]) == "work" then
				vehPrices = vehiclePrice(v["vehicle"]) * 0.25
			end

			if v["rental"] > 0 then
				if v["rental"] <= os.time() then
					vehicleRental = "Vencido"
				else
					vehicleRental = minimalTimers(v["rental"] - os.time())
				end
			end

			table.insert(vehList,{ k = v["vehicle"], name = vehicleName(v["vehicle"]), plate = v["plate"], price = parseInt(vehPrices), chest = vehicleChest(v["vehicle"]), tax = vehicleTax, rental = vehicleRental })
		end

		return vehList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTAX
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestTax(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if vehicle[1] then
			if vehicle[1]["tax"] <= os.time() then
				local vehiclePrice = parseInt(vehiclePrice(vehName) * 0.05)

				if vRP.paymentFull(user_id,vehiclePrice) then
					vRP.execute("vehicles/updateVehiclesTax",{ user_id = user_id, vehicle = vehName })
					TriggerClientEvent("tablet:Update",source,"requestPossuidos")
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>D??lares</b> insuficientes.",5000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTTRANSF
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestTransf(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local myVehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
		if myVehicle[1] then
			if myVehicle[1]["rental"] >= 1 then
				TriggerClientEvent("Notify",source,"amarelo","Ve??culos alugados n??o podem ser transferidos.",5000)
				return
			end

			local passport = vKEYBOARD.keySingle(source,"Passaporte:")
            if not passport then
                return
            end

			local nuser_id = parseInt(passport[1])
			local identity = vRP.userIdentity(nuser_id)
			if identity then
				local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = parseInt(nuser_id), work = "false" })
				local amountVehs = identity["garage"]

				if vRP.userPremium(nuser_id) then
					amountVehs = amountVehs + 2
				end

				if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
					TriggerClientEvent("Notify",source,"amarelo","Atingiu o m??ximo de ve??culos.",5000)
					return
				end

				if vRP.request(source,"Transferir o ve??culo <b>"..vehicleName(vehName).."</b> para <b>"..identity["name"].." "..identity["name2"].."</b>?") then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = parseInt(nuser_id), vehicle = vehName })
					if vehicle[1] then
						TriggerClientEvent("Notify",source,"amarelo","<b>"..identity["name"].." "..identity["name2"].."</b> j?? possui este modelo de ve??culo.",5000)
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

						TriggerClientEvent("Notify",source,"verde","Transfer??ncia conclu??da.",5000)
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestRental(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehPrice = vehicleGems(vehName)
			if vRP.request(source,"Alugar o ve??culo <b>"..vehicleName(vehName).."</b> por <b>"..parseFormat(vehPrice).." gemas</b>?") then
				if vRP.paymentGems(user_id,vehPrice) then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
					if vehicle[1] then
						if vehicle[1]["rental"] <= os.time() then
							vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = user_id, vehicle = vehName })
							TriggerClientEvent("Notify",source,"verde","Aluguel do ve??culo <b>"..vehicleName(vehName).."</b> atualizado.",5000)
							TriggerEvent("discordLogs","buycar","**Passaporte:** "..user_id.."\n**Renovou ve??culo:** "..vehicleName(vehName).."\n**Valor:** "..parseFormat(vehPrice).." gemas\n**Hor??rio:** "..os.date("%H:%M:%S"),3092790)
						else
							vRP.execute("vehicles/rentalVehiclesDays",{ user_id = user_id, vehicle = vehName })
							TriggerClientEvent("Notify",source,"verde","Adicionado <b>30 Dias</b> de aluguel no ve??culo <b>"..vehicleName(vehName).."</b>.",5000)
							TriggerEvent("discordLogs","buycar","**Passaporte:** "..user_id.."\n**Adicionou 30 dias aluguel ao ve??culo:** "..vehicleName(vehName).."\n**Valor:** "..parseFormat(vehPrice).." gemas\n**Hor??rio:** "..os.date("%H:%M:%S"),3092790)

						end
					else
						vRP.execute("vehicles/rentalVehicles",{ user_id = user_id, vehicle = vehName, plate = vRP.generatePlate(), work = "false" })
						TriggerClientEvent("Notify",source,"verde","Aluguel do ve??culo <b>"..vehicleName(vehName).."</b> conclu??do.",5000)
						TriggerEvent("discordLogs","buycar","**Passaporte:** "..user_id.."\n**Alugou ve??culo:** "..vehicleName(vehName).."\n**Valor:** "..parseFormat(vehPrice).." gemas\n**Hor??rio:** "..os.date("%H:%M:%S"),3092790)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000)
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALMONEY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.rentalMoney(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehPrice = vehicleGems(vehName) * 2250
			if vRP.request(source,"Alugar o ve??culo <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrice).."</b> d??lares?") then
				if vRP.paymentFull(user_id,vehPrice) then
					local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
					if vehicle[1] then
						if vehicle[1]["rental"] <= os.time() then
							vRP.execute("vehicles/rentalVehiclesUpdate",{ user_id = user_id, vehicle = vehName })
							TriggerClientEvent("Notify",source,"verde","Aluguel do ve??culo <b>"..vehicleName(vehName).."</b> atualizado.",5000)
						else
							vRP.execute("vehicles/rentalVehiclesDays",{ user_id = user_id, vehicle = vehName })
							TriggerClientEvent("Notify",source,"verde","Adicionado <b>30 Dias</b> de aluguel no ve??culo <b>"..vehicleName(vehName).."</b>.",5000)
						end
					else
						vRP.execute("vehicles/rentalVehicles",{ user_id = user_id, vehicle = vehName, plate = vRP.generatePlate(), work = "false" })
						TriggerClientEvent("Notify",source,"verde","Aluguel do ve??culo <b>"..vehicleName(vehName).."</b> conclu??do.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>D??lares</b> insuficientes.",5000)
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestBuy(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return
			end

			local vehicle = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
			if vehicle[1] then
				TriggerClientEvent("Notify",source,"amarelo","J?? possui um <b>"..vehicleName(vehName).."</b>.",3000)
				actived[user_id] = nil
				return
			else
				if vehicleType(vehName) == "work" then
					if vRP.paymentFull(user_id,vehiclePrice(vehName)) then
						vRP.execute("vehicles/addVehicles",{ user_id = user_id, vehicle = vehName, plate = vRP.generatePlate(), work = "true" })
						TriggerEvent("discordLogs","buycar","**Passaporte:** "..user_id.."\n**Comprou:** "..vehicleName(vehName).."\n**Valor:** "..vehiclePrice(vehName).."\n**Hor??rio:** "..os.date("%H:%M:%S"),3092790)
						TriggerClientEvent("Notify",source,"verde","Compra conclu??da.",5000)
					else
						TriggerClientEvent("Notify",source,"vermelho","<b>D??lares</b> insuficientes.",5000)
					end
				else
					-- if vehicleType(vehName) == "bikes" then
					-- 	-- if not vRP.hasGroup(user_id,"TheLost") then
					-- 	-- 	TriggerClientEvent("Notify",source,"amarelo","Ve??culo vendido pelos membros dos <b>Motoqueiros</b>.",3000)
					-- 	-- 	actived[user_id] = nil
					-- 	-- 	return
					-- 	-- end
					-- end

					local vehPrice = vehiclePrice(vehName)
					if vRP.request(source,"Comprar <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrice).."</b> d??lares?") then
						local maxVehs = vRP.query("vehicles/countVehicles",{ user_id = user_id, work = "false" })
						local identity = vRP.userIdentity(user_id)
						local amountVehs = identity["garage"]

						if vRP.userPremium(user_id) then
							amountVehs = amountVehs + 2 
						end

						if parseInt(maxVehs[1]["qtd"]) >= parseInt(amountVehs) then
							TriggerClientEvent("Notify",source,"amarelo","Atingiu o m??ximo de ve??culos.",3000)
							actived[user_id] = nil
							return
						end

						if vRP.paymentFull(user_id,vehPrice) then
							vRP.execute("vehicles/addVehicles",{ user_id = user_id, vehicle = vehName, plate = vRP.generatePlate(), work = "false" })
							TriggerEvent("discordLogs","buycar","**Passaporte:** "..user_id.."\n**Comprou:** "..vehicleName(vehName).."\n**Valor:** "..parseFormat(vehPrice).." d??lares.\n**Hor??rio:** "..os.date("%H:%M:%S"),3092790)

							TriggerClientEvent("Notify",source,"verde","Compra conclu??da.",5000)
						else
							TriggerClientEvent("Notify",source,"vermelho","<b>D??lares</b> insuficientes.",5000)
						end
					end
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSELL
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestSell(vehName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if vRP.getFines(user_id) > 0 then
				TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
				actived[user_id] = nil
				return false
			end

			local vehType = vehicleType(vehName)
			if vehType == "work" then
				TriggerClientEvent("Notify",source,"amarelo","Ve??culos de servi??o n??o podem ser vendidos.",3000)
				actived[user_id] = nil
				return false
			end

			local vehPrices = vehiclePrice(vehName) * 0.5
			local sellText = "Vender o ve??culo <b>"..vehicleName(vehName).."</b> por <b>$"..parseFormat(vehPrices).."</b>?"

			if vehType == "rental" then
				sellText = "Remover o ve??culo de sua lista de possu??dos?"
			end

			if vRP.request(source,sellText) then
				local vehicles = vRP.query("vehicles/selectVehicles",{ user_id = user_id, vehicle = vehName })
				if vehicles[1] then
					vRP.remSrvdata("custom:"..user_id..":"..vehName)
					vRP.remSrvdata("vehChest:"..user_id..":"..vehName)
					vRP.remSrvdata("vehGloves:"..user_id..":"..vehName)
					vRP.execute("vehicles/removeVehicles",{ user_id = user_id, vehicle = vehName })
					TriggerClientEvent("tablet:Update",source,"requestPossuidos")

					if vehType ~= "rental" then
						vRP.addBank(user_id,vehPrices,"Private")
						TriggerClientEvent("itensNotify",source,{ "recebeu","dollars",parseFormat(vehPrices),"D??lares" })
					end
				end
			end

			actived[user_id] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
local plateVehs = {}
function cRP.startDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if actived[user_id] == nil then
			actived[user_id] = true

			if not exports["hud"]:Wanted(user_id) then
				if vRP.request(source,"Iniciar o teste por <b>$100</b> d??lares?") then
					if vRP.paymentFull(user_id,100) then
						plateVehs[user_id] = "PDMS"..(1000 + user_id)

						TriggerEvent("engine:tryFuel",plateVehs[user_id],100)
						TriggerClientEvent("update:Route",source,user_id)
						TriggerEvent("plateEveryone",plateVehs[user_id])
						SetPlayerRoutingBucket(source,user_id)
						actived[user_id] = nil

						return true,plateVehs[user_id]
					else
						TriggerClientEvent("Notify",source,"vermelho","<b>D??lares</b> insuficientes.",5000)
					end
				end
			end

			actived[user_id] = nil
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEDRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.removeDrive()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		TriggerEvent("plateReveryone",plateVehs[user_id])
		TriggerClientEvent("update:Route",source,0)
		SetPlayerRoutingBucket(source,0)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if actived[user_id] then
		actived[user_id] = nil
	end

	if plateVehs[user_id] then
		plateVehs[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkShares()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		if exports["hud"]:Repose(user_id) or exports["hud"]:Wanted(user_id,source) then
			return false
		end

		return true
	end
end