local function createBlip(x, y, z, name)
  local blip = AddBlipForCoord(x, y, z)
  SetBlipSprite(blip, 1)
  SetBlipColour(blip, 5)
  SetBlipRoute(blip, true)
  SetBlipScale(blip, 1.0)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(blip)
  return blip
end

local inDelivery

function eventHandlers.ifood_cancelled(id)
  inDelivery = nil
end

function Lua.ifood_finish()
  inDelivery = nil
  Lua.setState('ifood_order', nil)
end

function Lua.ifood_create(order)
  inDelivery = order
  Lua.setState('ifood_order', order)

  local cds = vector3(table.unpack(order.store.location))
  local blip = createBlip(cds.x, cds.y, cds.z, order.store.name)
  local step = 0

  while inDelivery do
    if step == 0 then
      DrawMarker(23, cds.x, cds.y, cds.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.1, 255, 0, 0, 120)
      if IsControlJustPressed(1, 38) then
        if #(GetEntityCoords(PlayerPedId()) - cds) <= 2 then
          vRP.playAnim(false, { "timetable@floyd@clean_kitchen@base", "base" }, false)
          FreezeEntityPosition(PlayerPedId(), true)
          Wait(3000)
          FreezeEntityPosition(PlayerPedId(), false)
          vRP.stopAnim()
          step = 1
          RemoveBlip(blip)
          cds = vector3(order.customer.x, order.customer.y, order.customer.z)
          blip = createBlip(cds.x, cds.y, cds.z, 'Destino')
          Net.ifood_pickup()
        end
      end
    end
    Wait(0)
  end

  RemoveBlip(blip)
end