-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")

------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("gregos-exercicios",cRP)
vCLIENT = Tunnel.getInterface("gregos-exercicios")


function cRP.startAnim(anim,b,prop)
	local source = source
	if source ~= nil then
		vRPC.playAnim(source,false,{anim,b},true)
		TriggerClientEvent("inventory:Buttons",source,true)
	end
end

function cRP.stopAnim()
	local source = source
	if source ~= nil then
		vRPC.stopAnim(source,false)
		TriggerClientEvent("inventory:Buttons",source,false)
	end
end

function cRP.startExercice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local amountWeight = 2
		local myWeight = vRP.getWeight(user_id)

		if parseInt(myWeight) < 45 then
			amountWeight = 2
		elseif parseInt(myWeight) >= 45 and parseInt(myWeight) <= 148 then
			amountWeight = 1
		elseif parseInt(myWeight) >= 150 then
			amountWeight = 0
		end

		vRP.setWeight(user_id,amountWeight)
		TriggerClientEvent("Notify",source,"verde","Você aumentou sua capacidade máxima de Carga",15000)
	end
end

function cRP.stopExercice()
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		TriggerClientEvent("Notify",source,"verde","Sessão de exercícios finalizada, inicie outra sessão caso queira mais mochila",15000)
		TriggerClientEvent("inventory:Buttons",source,false)
	end
end

