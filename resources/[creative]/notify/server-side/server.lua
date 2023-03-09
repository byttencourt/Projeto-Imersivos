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
Tunnel.bindInterface("notify",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHORTCUTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.Shortcuts()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inventory = vRP.userInventory(user_id)
		if inventory[tostring("1")] == nil then
			slot1 = ""
		else
			slot1 = itemIndex(inventory[tostring("1")]["item"])
		end
		if inventory[tostring("2")] == nil then
			slot2 = ""
		else
			slot2 = itemIndex(inventory[tostring("2")]["item"])
		end
		if inventory[tostring("3")] == nil then
			slot3 = ""
		else
			slot3 = itemIndex(inventory[tostring("3")]["item"])
		end
		if inventory[tostring("4")] == nil then
			slot4 = ""
		else
			slot4 = itemIndex(inventory[tostring("4")]["item"])
		end
		if inventory[tostring("5")] == nil then
			slot5 = ""
		else
			slot5 = itemIndex(inventory[tostring("5")]["item"])
		end
		return {"CADULINDO",slot1,slot2,slot3,slot4,slot5}
	end
end
