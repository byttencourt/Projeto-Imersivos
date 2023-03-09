-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("warehouse")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Warehouse = ""
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	["1"] = { -73.05,-1197.07,27.65,3.0 },
	["2"] = { -78.8,-1204.19,27.63,3.0 },
	["3"] = { -67.14,-1199.43,27.79,3.0 },
	["4"] = { -71.1,-1206.31,27.87,3.0 },
	["5"] = { -61.5,-1205.12,28.16,3.0 },
	["6"] = { -65.9,-1211.59,28.36,3.0 },
	["7"] = { -56.28,-1210.31,28.48,3.0 },
	["8"] = { -52.93,-1216.41,28.7,3.0 },
	["9"] = { -56.65,-1229.2,28.8,3.0 },
	["10"] = { -66.42,-1226.43,28.83,3.0 },
	["11"] = { -60.77,-1233.61,28.9,3.0 },
	["12"] = { -72.5,-1233.9,29.08,3.0 },
	["13"] = { -66.22,-1239.45,29.03,3.0 },
	["14"] = { -73.67,-1243.05,29.1,3.0 },
	["15"] = { -43.99,-1235.59,29.34,3.0 },
	["16"] = { -43.97,-1241.86,29.34,3.0 },
	["17"] = { -43.97,-1252.53,29.25,3.0 },
	["18"] = { -173.96,-1266.26,32.59,3.0 },
	["19"] = { -193.71,-1284.31,31.31,3.0 },
	["20"] = { -193.7,-1290.26,31.29,3.0 },
	["21"] = { -152.18,-1302.92,31.29,3.0 },
	["22"] = { 903.16,3586.15,33.43,3.0 },
	["23"] = { 914.68,3562.7,33.8,3.0 },
	["24"] = { 914.67,3567.38,33.78,3.0 },
	["25"] = { 433.69,3573.16,33.23,3.0 },
	["26"] = { 379.46,3583.39,33.3,3.0 },
	["27"] = { 186.06,2786.62,46.02,3.0 },
	["28"] = { 642.07,2791.8,41.97,3.0 },
	["29"] = { 619.1,2784.49,43.47,3.0 },
	["30"] = { 588.48,2782.29,43.47,3.0 },
	["31"] = { 583.27,2781.96,43.47,3.0 },
	["32"] = { 1695.71,6430.87,32.71,3.0 },
	["33"] = { 178.69,6392.1,32.37,3.0 },
	["34"] = { 175.19,6398.75,32.37,3.0 },
	["35"] = { 147.0,6366.74,31.53,3.0 },
	["36"] = { 108.89,6326.23,31.37,3.0 },
	["37"] = { 96.49,6329.04,31.37,3.0 },
	["38"] = { 93.55,6335.0,31.37,3.0 },
	["39"] = { -246.59,6068.58,32.33,3.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	SetNuiFocus(false,false)

	for k,v in pairs(List) do
		exports["target"]:AddCircleZone("Warehouse:"..k,vec3(v[1],v[2],v[3]),v[4],{
			name = "Warehouse:"..k,
			heading = 3374176,
			useZ = true
		},{
			shop = k,
			distance = 1.5,
			options = {
				{
					event = "warehouse:openSystem",
					label = "Abrir",
					tunnel = "shop"
				} --,{
				-- 	event = "warehouse:Upgrade",
				-- 	label = "Aumentar",
				-- 	tunnel = "shopserver"
				-- },{
				-- 	event = "warehouse:Password",
				-- 	label = "Trocar Senha",
				-- 	tunnel = "shopserver"
				-- }
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSE:OPENSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("warehouse:openSystem",function(Number)
	if LocalPlayer["state"]["Route"] < 900000 then
		if vSERVER.Warehouse(Number) then
			Warehouse = Number
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showMenu" })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSECLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invClose",function()
	SendNUIMessage({ action = "hideMenu" })
	SetNuiFocus(false,false)
	Warehouse = ""
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(data["item"],data["slot"],data["amount"],data["target"],Warehouse)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(data["item"],data["slot"],data["amount"],data["target"],Warehouse)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("updateWarehouse",function(data)
	vSERVER.updateWarehouse(data["slot"],data["target"],data["amount"],Warehouse)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTWAREHOUSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestWarehouse",function(data,cb)
	local myInventory,myWarehouse,invPeso,invMaxpeso,warehousePeso,warehouseMaxpeso = vSERVER.openWarehouse(Warehouse)
	if myInventory then
		cb({ myInventory = myInventory, myWarehouse = myWarehouse, invPeso = invPeso, invMaxpeso = invMaxpeso, warehousePeso = warehousePeso, warehouseMaxpeso = warehouseMaxpeso })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("warehouse:Update")
AddEventHandler("warehouse:Update",function(Action)
	SendNUIMessage({ action = Action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WAREHOUSE:WEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("warehouse:Weight")
AddEventHandler("warehouse:Weight",function(invPeso,invMaxpeso,warehousePeso,warehouseMaxpeso)
	SendNUIMessage({ action = "updateWeight", invPeso = invPeso, invMaxpeso = invMaxpeso, warehousePeso = warehousePeso, warehouseMaxpeso = warehouseMaxpeso })
end)