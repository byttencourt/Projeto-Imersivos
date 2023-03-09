-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:BADGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("badge",function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		if vRP.hasGroup(user_id,"Police") and parseInt(args[1]) > 0 then
			local badge = parseInt(args[1])
			TriggerEvent("blipsystem:serviceExit",source)
			TriggerEvent("blipsystem:serviceEnter",source,"Lspd: "..badge.." - "..identity["name"].." "..identity["name2"],18)
			TriggerClientEvent("Notify",source,"verde","Badge: "..args[1].." definida com sucesso!",5000)
		else
			TriggerClientEvent("Notify",source,"vermelho","Sem permissão ou fora de Serviço!",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service,Color)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.userIdentity(user_id)
	if user_id then
		local splitName = splitString(Service,"-")
		local serviceName = splitName[1]

		if vRP.hasPermission(user_id,serviceName) then
			if serviceName == "Lspd" or serviceName == "Sheriff" or serviceName == "Corrections" or serviceName == "Ranger" or serviceName == "State" then
				vRP.removePermission(user_id,"Police")
				TriggerEvent("blipsystem:serviceExit",source)
				TriggerClientEvent("vRP:PoliceService",source,false)
			end

			if serviceName == "Paramedic" then
				vRP.removePermission(user_id,serviceName)
				--TriggerEvent("blipsystem:serviceExit",source)
				TriggerClientEvent("vRP:ParamedicService",source,false)
			end
			if serviceName == "Mechanic" then
				vRP.removePermission(user_id,serviceName)
				--TriggerEvent("blipsystem:serviceExit",source)
			end
			if serviceName == "LosSantos" then
				vRP.removePermission(user_id,serviceName)
				--TriggerEvent("blipsystem:serviceExit",source)
			end

			vRP.updatePermission(user_id,serviceName,"wait"..serviceName)
			TriggerClientEvent("Notify",source,"azul","Saiu de serviço.",5000)
			TriggerClientEvent("service:Label",source,serviceName,"Entrar em Serviço",5000)
		elseif vRP.hasPermission(user_id,"wait"..serviceName) then
			if serviceName == "Lspd" or serviceName == "Sheriff" or serviceName == "Corrections" or serviceName == "Ranger" or serviceName == "State" then
				vRP.insertPermission(source,user_id,"Police")
				TriggerClientEvent("vRP:PoliceService",source,true)
				TriggerEvent("blipsystem:serviceEnter",source,serviceName..": "..identity["name"].." "..identity["name2"],Color)
			end

			if serviceName == "Paramedic" then
				vRP.insertPermission(source,user_id,serviceName)
				TriggerClientEvent("vRP:ParamedicService",source,true)
				--TriggerEvent("blipsystem:serviceEnter",source,"Paramedico",Color)
			end
			if serviceName == "Mechanic" then
				vRP.insertPermission(source,user_id,serviceName)
			end
			if serviceName == "LosSantos" then
				vRP.insertPermission(source,user_id,serviceName)
			end

			vRP.updatePermission(user_id,"wait"..serviceName,serviceName)
			TriggerClientEvent("Notify",source,"azul","Entrou em serviço.",5000)
			TriggerClientEvent("service:Label",source,serviceName,"Sair de Serviço",5000)
		end
	end
end)