local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
local vRP = Proxy.getInterface("vRP")
local xSound = exports.xsound

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)

RegisterCommand(cfg.dommandVehicle, function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.userPremium(user_id) then
			TriggerClientEvent("vrp_spotify:ShowNui",source)
		else
			TriggerClientEvent("Notify",source,"vermelho","Não possui Premium.",3000)
		end
	end
end)

function src.GetMusic()
	return cfg.zones
end

RegisterNetEvent("vrp_spotify:ChangeVolume")
AddEventHandler("vrp_spotify:ChangeVolume", function(vol, nome)
    local somafter = false
    local rangeafter = false
    for i = 1, #cfg.zones do
        local v = cfg.zones[i]
        if nome == v.name then
            local vadi = v.volume + vol
            if vadi <= 1.01 and vadi >= -0.001 then
				if vadi < 0.005 then
					vadi = 0.0
				end
                if v.popo then
                    v.range = (v.volume*cfg.distanceToVolume)
                else
					if vadi >= 0.05 then
						v.range = (vadi*v.range)/v.volume
					end
                end
                v.volume = vadi
                somafter = v.volume
                rangeafter = v.range
            end
        end
    end
    if somafter and rangeafter then
        TriggerClientEvent("vrp_spotify:ChangeVolume",-1,somafter,rangeafter, nome)
    end
end)

RegisterNetEvent("vrp_spotify:ChangeLoop")
AddEventHandler("vrp_spotify:ChangeLoop", function(nome,tip)
	local loopstate
	for i = 1, #cfg.zones do
		local v = cfg.zones[i]
		if nome == v.name then
			v.loop = tip
			loopstate = v.loop
		end
	end
	if loopstate ~= nil then
		TriggerClientEvent("vrp_spotify:ChangeLoop",-1,loopstate, nome)
	end
end)

RegisterNetEvent("vrp_spotify:ChangeState")
AddEventHandler("vrp_spotify:ChangeState", function(type, nome)
	for i = 1, #cfg.zones do
		local v = cfg.zones[i]
		if nome == v.name then
			v.isplaying = type
		end
	end
	TriggerClientEvent("vrp_spotify:ChangeState",-1,type, nome)
end)

RegisterNetEvent("vrp_spotify:ChangePosition")
AddEventHandler("vrp_spotify:ChangePosition", function(quanti, nome)
	for i = 1, #cfg.zones do
		local v = cfg.zones[i]
		if nome == v.name then
			v.deftime = v.deftime+quanti
			if v.deftime < 0 then
				v.deftime = 0
			end
		end
	end
	TriggerClientEvent("vrp_spotify:ChangePosition",-1,quanti, nome)
end)

RegisterNetEvent("vrp_spotify:ModifyURL")
AddEventHandler("vrp_spotify:ModifyURL", function(data)
	local _data = data
	local zena = false
	for i = 1, #cfg.zones do
		local v = cfg.zones[i]
		if _data.name == v.name then
			v.deflink = _data.link
			if _data.popo then
				v.popo = _data.popo
			end
			v.deftime = 0
			v.isplaying = true
			v.loop = _data.loop
			zena = v
		end
	end
	if zena then
		TriggerClientEvent("vrp_spotify:ModifyURL",-1,zena)
	end
end)

function countTime()
    SetTimeout(1000, countTime)
    for i = 1, #cfg.zones do
		local v = cfg.zones[i]
        if v.isplaying then
            v.deftime = v.deftime + 1
        end
    end
end

SetTimeout(1000, countTime)

RegisterNetEvent('vrp_spotify:AddVehicle')
AddEventHandler("vrp_spotify:AddVehicle", function(vehdata)
    local Data = {}
    Data.name = vehdata.plate
    Data.coords = vehdata.coords
    Data.range = vehdata.volume * cfg.distanceToVolume
    Data.volume = vehdata.volume
    Data.deflink = vehdata.link
    Data.isplaying = true
    Data.loop = vehdata.loop
    Data.deftime = 0
    Data.popo = vehdata.popo
    table.insert(cfg.zones, Data)
    TriggerClientEvent('vrp_spotify:AddVehicle', math.floor(-1), cfg.zones[#cfg.zones])
end)

RegisterNetEvent('vrp_spotify:GetDate')
AddEventHandler('vrp_spotify:GetDate', function()
    TriggerClientEvent('vrp_spotify:SendData', math.floor(-1), cfg.zones)
end)