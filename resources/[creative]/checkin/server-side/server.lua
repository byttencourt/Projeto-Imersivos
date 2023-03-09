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
Tunnel.bindInterface("checkin",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTCHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentCheckin()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getHealth(source) <= 101 then
			if vRP.paymentFull(user_id,1000) then
				vRP.upgradeHunger(user_id,20)
				vRP.upgradeThirst(user_id,20)
				vRP.upgradeStress(user_id,10)
				TriggerEvent("Repose",source,user_id,900)

				return true
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		else
			if vRP.request(source,"Prosseguir o tratamento por <b>$500</b> dólares?","Sim","Não") then
				if vRP.paymentFull(user_id,500) then
					vRP.upgradeHunger(user_id,20)
					vRP.upgradeThirst(user_id,20)
					vRP.upgradeStress(user_id,10)
					TriggerEvent("Repose",source,user_id,900)

					return true
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end

	return false
end

function cRP.paramedicCheckin()
local source = source
local user_id = vRP.getUserId(source)
local paramedicResult = vRP.numPermission("Paramedic")
	if parseInt(#paramedicResult) >= 1 then
		return false
	else
		TriggerEvent("discordLogs","Airport","**Passaporte:** "..parseFormat(user_id).."\nUsou comando /Paramédico\n**Horário:** "..os.date("%H:%M:%S"),3092790)
		return true
	end
end