Tunnel = module('lib/Tunnel')
Proxy = module('lib/Proxy')
vRP = Proxy.getInterface('vRP')
Net = Tunnel.getInterface('smartphone-plugins')
Lua = {}

function Lua.getPosition()
  return GetEntityCoords(PlayerPedId())
end

function Lua.distanceTo(x, y, z, px, py, pz)
  if not px then
    px,py,pz = table.unpack(Lua.getPosition())
  end
  LoadAllPathNodes(false)
  return CalculateTravelDistanceBetweenPoints(px, py, pz, x, y, z)
end

function Lua.distanceAll(locations)
  local o = {}

  LoadAllPathNodes(false)
  local px,py,pz = table.unpack(Lua.getPosition())
  for i, v in ipairs(locations) do
    o[i] = CalculateTravelDistanceBetweenPoints(px, py, pz, v.x or v[1], v.y or v[2], v.z or v[3])
  end
  
  return o
end

function Lua.getWaypoint()
  local blip = GetFirstBlipInfoId(8)
  if blip > 0 then
    return {table.unpack(GetBlipCoords(blip))}
  end
end

function Lua.getStreetName(x, y, z)
  local hash = GetStreetNameAtCoord(x, y, z or 64)
  return GetStreetNameFromHashKey(hash)
end

function Lua.callTo(phone)
  TriggerEvent('smartphone:pusher', 'CALL_TO', phone)
end

RegisterNUICallback('request', function(data, cb)
   local realm = _G[data[1]]
   local fname = data[2]
  print(reaml)
  print(fname)
   cb({ realm[fname](table.unpack(data, 3)) })
end)

-- PERSISTENCE

local state = {}

function Lua.setState(key, value)
  state[key] = value
end

function Lua.getState(key, value)
  return state[key]
end

-- POLLING

eventPoll = {}
eventRequest = false
eventTime = 180e3
eventHandlers = {}

RegisterNetEvent('smartphone-jobs:pusher', function(name, ...)
  table.insert(eventPoll, { name=name, args={...} })
  pcall(eventHandlers[name], ...)
end)

CreateThread(function()
  while true do
    while eventTime > 0 and #eventPoll == 0 do
      Wait(50)
      eventTime = eventTime - 50
    end
    pcall(eventRequest, eventPoll)
    eventPoll = {}
    eventTime = 180e3
  end
end)

RegisterNUICallback('polling', function(data, cb)
  eventRequest = cb
end)

local blips = {}

RegisterNetEvent('sj:blip', function(type, x, y, z)
  local isUber = type == 'uber'

  local blip = blips[type]
  if not blip then
    blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, isUber and 198 or 348)
    SetBlipColour(blip, 0)
    SetBlipRoute(blip, true)
    SetBlipScale(blip, 1.0)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(isUber and 'Motorista' or 'Entregador')
    EndTextCommandSetBlipName(blip)
    blips[type] = blip
  else
    SetBlipCoords(blip, x, y, z)
    SetBlipRoute(blip, true)
  end
end)  


RegisterNetEvent('sj:rmblip', function(type)
  if type and blips[type] then
    RemoveBlip(blips[type])
  end
end)  