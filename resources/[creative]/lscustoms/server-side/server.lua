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
Tunnel.bindInterface("lscustoms",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	local mecResult = vRP.numPermission("Mechanic")
	local losResult = vRP.numPermission("LosSantos")
	if user_id then
		if vRP.getFines(user_id) > 0 then
			TriggerClientEvent("Notify",source,"amarelo","Multas pendentes encontradas.",3000)
			return false
		end

		if vRP.wantedReturn(user_id) then
			TriggerClientEvent("Notify",source,"amarelo","Você está procurado!",3000)
			return false
		end

		if parseInt(#mecResult) >= 1 then
			return false
		end

		if parseInt(#losResult) >= 1 then
			return false
		end
		
	end

	return true
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission2()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return vRP.hasPermission(user_id,"Mechanic") or vRP.hasPermission(user_id,"LosSantos")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:attemptPurchase")
AddEventHandler("lscustoms:attemptPurchase",function(type,mod)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id, "Mechanic") then
			if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod] * 0.9)) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
				else
					TriggerClientEvent("lscustoms:purchaseFailed",source)
				end
			else
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type]* 0.7)) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
				else
					TriggerClientEvent("lscustoms:purchaseFailed",source)
				end
			end
		else
			if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type][mod] * 1.2)) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
				else
					TriggerClientEvent("lscustoms:purchaseFailed",source)
				end
			else
				if vRP.paymentFull(user_id,parseInt(vehicleCustomisationPrices[type] * 1.2)) then
					TriggerClientEvent("lscustoms:purchaseSuccessful",source)
				else
					TriggerClientEvent("lscustoms:purchaseFailed",source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:updateVehicle")
AddEventHandler("lscustoms:updateVehicle",function(mods,vehPlate,vehName)
	local userPlate = vRP.userPlate(vehPlate)
	if userPlate then
		vRP.execute("entitydata/setData",{ dkey = "custom:"..userPlate["user_id"]..":"..vehName, value = json.encode(mods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local inVehicle = {}
RegisterServerEvent("lscustoms:inVehicle")
AddEventHandler("lscustoms:inVehicle",function(vehNet,vehPlate)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vehNet == nil then
			if inVehicle[user_id] then
				inVehicle[user_id] = nil
			end
		else
			inVehicle[user_id] = { vehNet,vehPlate }
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHEDIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("vehedit",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasGroup(user_id,"Admin") then
			TriggerClientEvent("lscustoms:openAdmin",source)
		end
	end
end)