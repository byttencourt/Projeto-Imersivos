-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICELIST
-----------------------------------------------------------------------------------------------------------------------------------------
local serviceList = {
	{ 441.81,-982.05,30.83,274.97,"Lspd",18 },
	{ 1852.85,3687.79,34.07,0,"Sheriff-1",17 },
	{ -447.28,6013.01,32.41,0,"Sheriff-2",17 },
	{ 1840.20,2578.48,46.07,0,"Corrections",24 },
	{ 385.43,794.42,187.48,0,"Ranger",69 },
	{ 382.01,-1596.39,29.91,0,"State",11 },
	{ 1134.44,-1537.1,35.38,0,"Paramedic-1",6 },
	{ 1831.79,3672.95,34.27,0,"Paramedic-2",6 },
	{ -256.54,6331.26,32.42,320.32,"Paramedic-3",6 },
	{ 835.5,-829.71,26.34,229.61,"Mechanic",51 },
	{ -347.6,-133.34,39.01,70.8,"LosSantos",51 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTARGET
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for k,v in pairs(serviceList) do
		exports["target"]:AddCircleZone("service:"..v[5],vector3(v[1],v[2],v[3]),0.75,{
			name = "service:"..v[5],
			heading = v[4]
		},{
			shop = k,
			distance = 1.5,
			options = {
				{
					label = "Entrar em Serviço",
					event = "service:Toggle",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Toggle")
AddEventHandler("service:Toggle",function(Service)
	TriggerServerEvent("service:Toggle",serviceList[Service][5],serviceList[Service][6])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:LABEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Label")
AddEventHandler("service:Label",function(Service,Text)
	if Service == "Sheriff" then
		exports["target"]:LabelText("service:Sheriff-1",Text)
		exports["target"]:LabelText("service:Sheriff-2",Text)
	elseif Service == "Paramedic" then
		exports["target"]:LabelText("service:Paramedic-1",Text)
		exports["target"]:LabelText("service:Paramedic-2",Text)
		exports["target"]:LabelText("service:Paramedic-3",Text)
	else
		exports["target"]:LabelText("service:"..Service,Text)
	end
end)