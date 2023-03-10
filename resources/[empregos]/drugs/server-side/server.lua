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
Tunnel.bindInterface("drugs",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local userAmount = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemList = {
	{ item = "lean", priceMin = 75, priceMax = 100, randMin = 2, randMax = 5 },
	{ item = "ecstasy", priceMin = 75, priceMax = 100, randMin = 2, randMax = 5 },
	{ item = "cocaine", priceMin = 75, priceMax = 100, randMin = 2, randMax = 5 },
	{ item = "meth", priceMin = 75, priceMax = 100, randMin = 2, randMax = 5 },
	{ item = "joint", priceMin = 75, priceMax = 100, randMin = 2, randMax = 5 },
	{ item = "oxy", priceMin = 85, priceMax = 110, randMin = 1, randMax = 3 },
	{ item = "heroine", priceMin = 120, priceMax = 145, randMin = 1, randMax = 1 } 
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkAmount()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(itemList) do
			local randAmount = math.random(v["randMin"],v["randMax"])
			local randPrice = math.random(v["priceMin"],v["priceMax"])
			local consultItem = vRP.getInventoryItemAmount(user_id,v["item"])
			if consultItem[1] >= parseInt(randAmount) then
				userAmount[user_id] = { v["item"],randAmount,randPrice * randAmount }

				return true
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod(gridAmount)
	local source = source
	local user_id = vRP.getUserId(source)
	local policeResult = vRP.numPermission("Police")
	if user_id then
		if vRP.tryGetInventoryItem(user_id,userAmount[user_id][1],userAmount[user_id][2],true) then
			vRP.upgradeStress(user_id,3)
			TriggerClientEvent("player:applyGsr",source)
			if parseInt(#policeResult) <= 1 then
				vRP.generateItem(user_id,"dollarsz",userAmount[user_id][3] * 0.7,true)
			else	
				vRP.generateItem(user_id,"dollarsz",userAmount[user_id][3] * 1.2,true)
			end	
			if parseInt(gridAmount) >= 3 then
				local ped = GetPlayerPed(source)
				local coords = GetEntityCoords(ped)
				local policeResult = vRP.numPermission("Police")

				for k,v in pairs(policeResult) do
					async(function()
						vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Venda de Drogas", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Liga????o An??nima", time = "Recebido ??s "..os.date("%H:%M"), blipColor = 16 })
					end)
					--TriggerClientEvent("Notify",source,"amarelo","A Pol??cia foi Alertada.",15000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDisconnect",function(user_id)
	if userAmount[user_id] then
		userAmount[user_id] = nil
	end
end)