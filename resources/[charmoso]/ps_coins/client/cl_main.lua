-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
psRP = {}
Tunnel.bindInterface("ps_coins",psRP)
vSERVER = Tunnel.getInterface("ps_coins")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive   = false
local painelactive = false
local onmenu       = false
local inTest       = false
local time         = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- ToggleActionMenu
-----------------------------------------------------------------------------------------------------------------------------------------
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)

		local myskins = vSERVER.SelectRewardsSkins()
		local myproducts = vSERVER.SelectRewardsProducts()
		local mycoins = vSERVER.GetCoins()

		SendNUIMessage({ 
			loadscript = true,
			settingsipimages = json.encode(config.ipimages),
			settingspercentage = json.encode(config.percentage),
			settingsbuycoins = json.encode(config.buycoins),
			boxes = json.encode(config.boxes),
			myskins = json.encode(myskins),
			myproducts = json.encode(myproducts),
			mycoins = mycoins
		})

		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ToggleActionMenu
-----------------------------------------------------------------------------------------------------------------------------------------
function TogglePainel()
	painelactive = not painelactive
	if painelactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)

		SendNUIMessage({ showpainel = true })

		local products = vSERVER.SelectRewardsProducts()

		SendNUIMessage({ 
			loadpainel = true,
			settingsipimages = json.encode(config.ipimages),
			settingspercentage = json.encode(config.percentage),
			settingsbuycoins = json.encode(config.buycoins),
			boxes = json.encode(config.boxes),
			products = json.encode(products)
		})
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidepainel = true })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ButtonClick
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "fechar" then
		ToggleActionMenu()
		onmenu = false
	elseif data == "fecharpainel" then
		TogglePainel()
		onmenu = false
    elseif data == "linksite" then
		vSERVER.openLink()
	end
    cb(true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ps_farm:close
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ps_farm:close")
AddEventHandler("ps_farm:close", function()
	ToggleActionMenu()
	onmenu = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SelectProducts
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("SelectProducts",function(data,cb)

	if data.index then
        local products = vSERVER.SelectProducts(data.index)

        if products ~= nil then
            SendNUIMessage({ loadproducts = true, products = json.encode(products) })

            SendNUIMessage({ showproducts = true })
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddProductUser
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("AddProductUser",function(data,cb)

	if data.id then
		local check = vSERVER.AddProductUser(data)
		if check then
            SendNUIMessage({ showproductwin = true, item = data })
			Wait(100)

			local myproducts = vSERVER.SelectRewardsProducts()
			local mycoins = vSERVER.GetCoins()

			SendNUIMessage({ 
				loadscript = true,
				myproducts = json.encode(myproducts),
				mycoins = mycoins
			})

            cb(true)
        else
            cb(false)
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- StartTestDrive
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("StartTestDrive",function(data,cb)
	if data.model then
		testDrivePS(data.model)
		cb(true)
	else
		cb(false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RedeemItem
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RedeemItem",function(data,cb)

	if data.item then
		local check = vSERVER.RedeemItem(data)
		if check then
			
			local myskins = vSERVER.SelectRewardsSkins()
			local myproducts = vSERVER.SelectRewardsProducts()
			local mycoins = vSERVER.GetCoins()

			SendNUIMessage({ 
				loadscript = true,
				myskins = json.encode(myskins),
				myproducts = json.encode(myproducts),
				mycoins = mycoins
			})

            cb(true)
        else
            cb(false)
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GiveBackItem
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GiveBackItem",function(data,cb)

	if data.item then
		local check = vSERVER.GiveBackItem(data)
		if check then
			
			local myproducts = vSERVER.SelectRewardsProducts()
			local mycoins = vSERVER.GetCoins()

			SendNUIMessage({ 
				loadscript = true,
				myproducts = json.encode(myproducts),
				mycoins = mycoins
			})

            cb(true)
        else
            cb(false)
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ApplySkin
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ApplySkin", function(data, cb)
    if data.image and data.weapon then
		local ped = PlayerPedId();
		local equipedhash = GetSelectedPedWeapon(ped)

		ToggleActionMenu()

		if equipedhash == nil then
			vSERVER.notify('vermelho','Você deve equipar a arma.', 5000)
		end

		if GetHashKey(data.weapon) == equipedhash then
			vSERVER.ChangeTexture(GetSelectedPedWeapon(ped),data.image)
		else
			vSERVER.notify('vermelho','Essa skin não serve para essa arma.', 5000)
		end
		cb(true)
	else
		cb(false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ApplySkin
-----------------------------------------------------------------------------------------------------------------------------------------
function psRP.ChangeTexture(hash,url,h,w)
    local txd = CreateRuntimeTxd('duiTxd')
    local duiObj = CreateDui(url, 512,512)
    _G.duiObj = duiObj
    local dui = GetDuiHandle(duiObj)
    local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
    AddReplaceTexture(Weapons[hash], Weapons[hash], 'duiTxd', 'duiTex')
	vSERVER.notify('verde','Skin aplicada com sucesso.', 5000)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- coins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("segredu", function()
    ToggleActionMenu()
    onmenu = true
end,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- coins
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("painelcoins", function()
	if vSERVER.checkPermission() then
		TogglePainel()
		onmenu = true
	end
end,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LoadPainel
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("LoadPainel",function(data,cb)
    cb({ 
		loadpainel = true,
		settingsipimages = json.encode(config.ipimages),
		settingspercentage = json.encode(config.percentage),
		boxes = json.encode(config.boxes)
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GetProductsPainel
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetProductsPainel",function(data,cb)
	local products = vSERVER.SelectAllProducts()
    cb(json.encode(products))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- AddProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('AddProductPainel', function(data, cb)
	local check = vSERVER.AddProductPainel(data)
    if check then
        cb(true)
    else
        cb(false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EditProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('EditProductPainel', function(data, cb)
	local check = vSERVER.EditProductPainel(data)
    if check then
        cb(true)
    else
        cb(false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DeleteProductPainel
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('DeleteProductPainel', function(data, cb)
	local check = vSERVER.DeleteProductPainel(data)
    if check then
        cb(true)
    else
        cb(false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Blips NUI
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000

		if inTest and time > 0 then
			local title = "Tempo de teste restante ~r~"..time.."~w~"
			drawTxt(title,4,0.5,0.92,0.35,255,255,255,180)
			time = time - 1

			if time <= 0 then
				inTest = false
			end
		end

		for k, v in pairs(config.blips) do
            local title = v.title
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true ) < 1.2 and not onmenu then
				drawTxt(title,4,0.5,0.92,0.35,255,255,255,180)
			end
			if distance <= 5 then
				DrawMarker(23, v.x, v.y, v.z-0.97,0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				idle = 5
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
						onmenu = true
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Time Online
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while config.onlinetime.active do
		local idle = config.onlinetime.time * 60000
		vSERVER.RewardCoins()
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Blips NUI
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 5

		if inTest and time > 0 then
			local title = "Tempo de teste restante ~r~"..time.."~w~"
			drawTxt(title,4,0.5,0.92,0.35,255,255,255,180)
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- loadModel
-----------------------------------------------------------------------------------------------------------------------------------------
function loadModel(model)
    local mhash = GetHashKey(model)
    local timeout = 5000
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        timeout = timeout - 1
        if timeout <= 0 then
            return false
        end
        Citizen.Wait(1)
    end
    return mhash
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- createVehicle
-----------------------------------------------------------------------------------------------------------------------------------------
function createVehicle(mhash, spawnCoords, plate)
    local vehicle = CreateVehicle(mhash, spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
    if plate then
        SetVehicleNumberPlateText(vehicle, plate)
    end
    if DoesEntityExist(vehicle) then
        local netveh = VehToNet(vehicle)
        NetworkRegisterEntityAsNetworked(vehicle)
        while not NetworkGetEntityIsNetworked(vehicle) do
            NetworkRegisterEntityAsNetworked(vehicle)
            Citizen.Wait(1)
        end
        if NetworkDoesNetworkIdExist(netveh) then
            SetEntitySomething(vehicle, true)
            if NetworkGetEntityIsNetworked(vehicle) then
                SetNetworkIdExistsOnAllMachines(netveh, true)
            end
        end
        SetVehicleIsStolen(vehicle, false)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetEntityInvincible(vehicle, false)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehRadioStation(vehicle, "OFF")
        SetModelAsNoLongerNeeded(mhash)
    end
    return vehicle
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- testDrivePS
-----------------------------------------------------------------------------------------------------------------------------------------
function testDrivePS(model)
    local mhash = loadModel(model)
	ToggleActionMenu()
    if mhash then
		local count = 0
        for k,v in ipairs(config.testdrive.places) do
        	local spawnCoords = v.coords
        	local closestVehicleOnSpot = GetClosestVehicle(spawnCoords.x,spawnCoords.y,spawnCoords.z,3.001,0,71)
            if DoesEntityExist(closestVehicleOnSpot) then
                count = count + 1
                if count >= #config.testdrive.places then
                    vSERVER.notify('vermelho','Todas as vagas estão ocupadas no momento.', 3000)
                    return
                end
            else
                Citizen.CreateThread(function()
					inTest = true
					DoScreenFadeOut(1000)
					Wait(1000)

					local myCoords = GetEntityCoords(PlayerPedId())
					SetEntityCoords(PlayerPedId(), spawnCoords)
					-- local plate = "55DTA141"

					local plate = "STREET"
					TriggerServerEvent("setPlateEveryone",plate)
					TriggerServerEvent("setPlatePlayers",plate,user_id)
					local veh = createVehicle(mhash,spawnCoords,plate)

					SetVehicleDirtLevel(veh,0.0)
					SetVehicleDoorsLocked(veh,4)
					SetVehicleDoorsLockedForAllPlayers(veh,4)
					SetVehRadioStation(veh,"OFF")
					SetVehicleNumberPlateText(veh,plate)
					SetEntityHeading(veh, v.h)
					SetPedIntoVehicle(PlayerPedId(), veh, -1)
					DoScreenFadeIn(1000)

					time = config.testdrive.time

					vSERVER.notify('amarelo', "Test Drive iniciado. Não saia do veículo e nem vá para muito longe do local.",3000)
					while inTest and IsPedInAnyVehicle(PlayerPedId(),false) and #(GetEntityCoords(PlayerPedId()) - spawnCoords) < config.testdrive.maxDistance and GetPedInVehicleSeat(veh,-1) == PlayerPedId() do
						Citizen.Wait(500)
					end

					if inTest then
						inTest = false
						time = 0
						vSERVER.notify('vermelho', "Test Drive cancelado.",3000)
						if #(GetEntityCoords(PlayerPedId()) - spawnCoords) >= config.testdrive.maxDistance then
							vSERVER.notify('vermelho', "Você se afastou muito do local do test.",3000)
						end
					else
						vSERVER.notify('amarelo', "Test Drive finalizado com sucesso.",3000)
					end

					DoScreenFadeOut(1000)
					Wait(1000)
					SetEntityAsNoLongerNeeded(veh)
					SetEntityAsMissionEntity(veh,true,true)
					DeleteVehicle(veh)
					SetEntityCoords(PlayerPedId(), myCoords)
					Wait(1000)
					DoScreenFadeIn(1000)
				end)
            	return
        	end
    	end 
    else
        vSERVER.notify('vermelho',"Veículo indisponível para test drive.",3000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- drawTxt
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end