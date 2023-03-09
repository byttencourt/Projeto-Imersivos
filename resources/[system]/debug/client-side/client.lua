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
Tunnel.bindInterface("debug",cRP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
local dickheaddebug = false

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

RegisterNetEvent("ToggleDebug")
AddEventHandler("ToggleDebug",function()
    dickheaddebug = not dickheaddebug
    if dickheaddebug then
        debugon()
    end
end)

function GetVehicle()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstVehicle()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 3.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped
            if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
                DrawText3D(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
            else
                DrawText3D(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
            end
        end
        success, ped = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return rped
end

function GetObject()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstObject()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if distance < 15.0 then
            distanceFrom = distance
            rped = ped

            if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
                DrawText3D(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
            else
                DrawText3D(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
            end
        end
        success, ped = FindNextObject(handle)
    until not success
    EndFindObject(handle)
    return rped
end

function getNPC()
    local playerped = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
        if canPedBeUsed(ped) and distance < 3.0 and (distanceFrom == nil or distance < distanceFrom) then
            distanceFrom = distance
            rped = ped

            if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
                DrawText3D(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
            else
                DrawText3D(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
            end
        end
        success, ped = FindNextPed(handle)
    until not success
    EndFindPed(handle)
    return rped
end

function canPedBeUsed(ped)
    if ped == nil then
        return false
    end
    if ped == GetPlayerPed(-1) then
        return false
    end
    if not DoesEntityExist(ped) then
        return false
    end
    return true
end

function debugon()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)

            if dickheaddebug then
                local pos = GetEntityCoords(GetPlayerPed(-1))
                local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
                local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
                local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
                local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 
                local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
                local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
                local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
                local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    
                local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
                local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
                currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

                DrawText2D(0.20,0.70,0.4,0.4,0.30, "~w~Heading: ~g~" .. GetEntityHeading(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.72,0.4,0.4,0.30, "~w~Coords: ~g~" .. pos,55,155,55,255)
                DrawText2D(0.20,0.74,0.4,0.4,0.30, "~w~Attached Ent: ~g~" .. GetEntityAttachedTo(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.76,0.4,0.4,0.30, "~w~Health: ~g~" .. GetEntityHealth(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.78,0.4,0.4,0.30, "~w~H a G: ~g~" .. GetEntityHeightAboveGround(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.80,0.4,0.4,0.30, "~w~Model: ~g~" .. GetEntityModel(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.82,0.4,0.4,0.30, "~w~Speed: ~g~" .. GetEntitySpeed(GetPlayerPed(-1)),55,155,55,255)
                DrawText2D(0.20,0.84,0.4,0.4,0.30, "~w~Frame Time: ~g~" .. GetFrameTime(),55,155,55,255)
                DrawText2D(0.20,0.86,0.4,0.4,0.30, "~w~Street: ~g~" .. currentStreetName,55,155,55,255)

                local nearped = getNPC()
                local veh = GetVehicle()
                local nearobj = GetObject()
            else
                Citizen.Wait(5000)
            end
        end
    end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DrawText2D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText2D(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.30,0.30)
    SetTextColour(r,g,b,a)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x-width/2,y-height/2+0.005)
end

function DrawText3D(x,y,z,text)
    local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

    if onScreen then
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringKeyboardDisplay(text)
        SetTextColour(255,255,255,150)
        SetTextScale(0.35,0.35)
        SetTextFont(4)
        SetTextCentre(1)
        EndTextCommandDisplayText(_x,_y)

        local width = string.len(text) / 160 * 0.45
        DrawRect(_x,_y + 0.0125,width,0.03,0,0,0,150)
    end
end