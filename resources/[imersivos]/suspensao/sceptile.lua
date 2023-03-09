local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
cRP = {}
Tunnel.bindInterface("suspensao",cRP) 

RegisterNetEvent("callback")
AddEventHandler("callback",function(args)
    if args then 
       TriggerClientEvent("returncall",args)
    end
end)



RegisterCommand("susp", function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
       -- print(args[1])
    if vRP.userPremium(user_id) then
        TriggerClientEvent("returncall",source,tonumber(args[1]))
    else
        TriggerClientEvent("Notify",source,"vermelho","Não possui Premium.",3000)
    end
end)


RegisterServerEvent("trywheel") 
AddEventHandler("trywheel",function(nveh,arg)
    --print(arg)
	TriggerClientEvent("syncwheel",-1,nveh,arg)
end)

RegisterServerEvent("widthwheel") 
AddEventHandler("widthwheel",function(nveh,arg)
    --print(arg)
	TriggerClientEvent("wheelwidth",-1,nveh,arg)
end)

----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userPremium(user_id) then
            TriggerClientEvent("Notify",source,"verde","Acesso permitido.",3000)
            return true
        end
        TriggerClientEvent("Notify",source,"vermelho","Somente usuarios premium podem acessar essa função.",3000)
        return false
	end
end
