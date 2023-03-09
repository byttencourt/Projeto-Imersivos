-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
arc = {}
Tunnel.bindInterface("arcade_restaurant",arc)
vSERVER = Tunnel.getInterface("arcade_restaurant")

Citizen.CreateThread(function()
	for k,v in pairs(config["restaurant"]) do
		exports["target"]:AddCircleZone("Restaurant:"..k,v["cds"],2.75,{
			name = "Restaurant:"..k,
			heading = 3374176
		},{
			shop = k,
			distance = 1.5,
			options = {
                {
                    event = "restaurant:register",
                    label = "Registrar fatura",
                    tunnel = "shop"
                },{
                    event = "restaurant:payment",
                    label = "Pagar fatura",
                    tunnel = "shop"
                }
            }
		})
	end
end)

RegisterNetEvent("restaurant:payment")
AddEventHandler("restaurant:payment",function(resName)
	TriggerServerEvent("restaurant:payment",resName)
end)

RegisterNetEvent("restaurant:register")
AddEventHandler("restaurant:register",function(resName)
	TriggerServerEvent("restaurant:register",resName)
end)

local locations = {
	--{ 113.33, -1040.51, 29.28, "BeanMachine", "Bean Machine" },
	--{ 792.57, -759.91, 26.76, "PizzaThis", "PizzaThis" },
	--{ -1256.92, -1474.1, 4.41, "BurgerShot", "Diners" },
	{ -579.83, -1070.7, 22.33, "Desserts", "UwU Café" },
	--{ 1952.23, 3843.35, 32.18, "Steinway", "Steinway" },
	--{ -612.21, -1609.37, 26.89, "Rogers", "Rogers" },
	--{ 373.63, -1269.21, 32.49, "BlazeIt", "BlazeIt!" },
	--{ 182.25, -1320.55, 29.32, "Penhores", "Loja de Penhores" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADHOVERFY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	local innerTable = {}

	for k,v in pairs(locations) do
		table.insert(innerTable,{ v[1],v[2],v[3],1,"E","Chamar atendente","Pressione para chamar" })
	end

	TriggerEvent("hoverfy:insertTable",innerTable)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)

	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)

			for k,v in pairs(locations) do
				local distance = #(coords - vector3(v[1],v[2],v[3]))
				if distance <= 2.5 then
					timeDistance = 1

					if IsControlJustPressed(1,38) then
						local disponivel = vSERVER.Disponivel(v[4])
						if not vSERVER.Cooldown() then
							if disponivel then
								TriggerEvent("Notify","verde","Chamado efetuado com sucesso.",5000,left)
							else
								TriggerEvent("Notify","vermelho","Estabelecimento fechado.",5000,left)
							end
						end
						vSERVER.Chamar(v[4],v[5])
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)