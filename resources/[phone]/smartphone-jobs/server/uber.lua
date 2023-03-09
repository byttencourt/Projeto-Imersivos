vRP.prepare('uber/create', [[CREATE TABLE IF NOT EXISTS smartphone_uber_trips(
  `id` VARCHAR(10) PRIMARY KEY,
  `user_id` INT,
  `driver_id` INT,
  `total` INT,
  `from` VARCHAR(255),
  `to` VARCHAR(255),
  `user_rate` TINYINT DEFAULT 0,
  `driver_rate` TINYINT DEFAULT 0,
  `created_at` INT,
  `finished_at` INT
)]])

vRP.prepare('uber/insert', [[INSERT INTO smartphone_uber_trips
  (`id`, `user_id`, `driver_id`, `total`, `from`, `to`, `created_at`, `finished_at`) VALUES 
  (@id, @user_id, @driver_id, @total, @from, @to, @created_at, UNIX_TIMESTAMP())
]])
vRP.prepare('uber/find_by_id', 'SELECT * FROM smartphone_uber_trips WHERE id=@id')
vRP.prepare('uber/set_rate', 'UPDATE smartphone_uber_trips SET user_rate=@user_rate,driver_rate=@driver_rate WHERE id=@id')
vRP.prepare('uber/get_user_rate', 'SELECT AVG(user_rate) as rate FROM smartphone_uber_trips WHERE user_id=@user_id AND user_rate > 0')
vRP.prepare('uber/get_driver_rate', 'SELECT AVG(driver_rate) as rate FROM smartphone_uber_trips WHERE driver_id=@user_id AND driver_rate > 0')
vRP.prepare('uber/get_trips', 'SELECT * FROM smartphone_uber_trips WHERE user_id=@user_id ORDER BY created_at DESC LIMIT 15')
vRP.prepare('uber/get_driver_trips', 'SELECT * FROM smartphone_uber_trips WHERE driver_id=@user_id ORDER BY created_at DESC LIMIT 15')

vRP.prepare('uber/get_trips_count', 'SELECT SUM(user_id=@user_id) AS passenger, SUM(driver_id=@user_id) AS driver FROM smartphone_uber_trips')

Citizen.CreateThread(function()
  vRP.execute('uber/create')
end)

local drivers = {}
local trips = {}
local chats = {}
local cfg = config.uber

function table.round(t)
  for k,v in pairs(t) do
    t[k] = toInt(v * 10) / 10
  end
  return t
end

local function toXYZ(o)
  if o.x then
    return table.round({ x = o.x, y = o.y, z = o.z })
  elseif o[1] then
    return table.round({ x = o[1], y = o[2], z = o[3] })
  end
  error('Nil was provided in toXYZ')
end

function isTripTaken(id)
  return trips[id] or #vRP.query('uber/find_by_id', { id=id }) > 0
end

local function getTrip(source)
  for id, trip in pairs(trips) do
    if trip.customer.source == source then
      trip.now = os.time()
      return trip
    end
  end
end

local function getRate(user_id, is_driver)
  local name = is_driver and 'uber/get_driver_rate' or 'uber/get_user_rate'
  return tonumber(vRP.query(name, { user_id = user_id })[1].rate)
end

local function getPrice(from, to, distance)
  -- Tendo certeza que a distância enviada é no mínimo a distância em linha reta
  to = to or from
  local meters = math.max(distance, #(from - to))
  return toInt(cfg.pricing.base + cfg.pricing.per_km * (meters / 1e3))
end

local function getAvailable()
  return table.reduce(drivers, function(prev, v)
    return prev + (v == false and 1 or 0)
  end, 0)
end

local function getName(user_id)
  local identity = vRP.userIdentity(user_id) or {}
  return identity.name or '(Erro)'
end

local function getPhone(user_id)
  local identity = vRP.userIdentity(user_id) or {}
  return identity.phone
end

CreateThread(function()
  while true do
    for id, trip in pairs(trips) do
      if trip.driver and not trip.entered then
        local customerPed = GetPlayerPed(trip.customer.source)
        local driverPed = GetPlayerPed(trip.driver.source)
        if not isPedAlive(customerPed) then
          trip:cancel()
          notify(trip.driver.source, 'uber', 'Cancelamos sua corrida', 'Seu passageiro sofreu um acidente. Você recebeu o valor integral')
        elseif not isPedAlive(driverPed) then
          trip:cancel(true)
          notify(trip.customer.source, 'uber', 'Sua viagem foi cancelada', 'Seu motorista sofreu um acidente. Você foi reembolsado')
        else
          local cds = GetEntityCoords(customerPed)
          if #(cds.xy - vec(trip.from.x, trip.from.y)) >= 40 then
            trip:cancel()
            notify(trip.customer.source, 'uber', 'Seu viagem foi cancelada', 'Você se afastou da área combinada')
            notify(trip.driver.source, 'uber', 'Cancelamos sua corrida', 'O passageiro se afastou da área combinada. Você recebeu o valor integral')
          end
        end
      end
    end
    Wait(5000)
  end
end)

expose('uber_current_trip', getTrip)

expose('uber_chat', function(source)
  local trip = drivers[source] or getTrip(source)
  assert(trip, 'Você não está em uma viagem')

  return { trip = trip, source = source, messages = chats[trip.id] }
end)

expose('uber_send_message', function(source, content)
  local trip = drivers[source] or getTrip(source)
  assert(trip, 'Você não está em uma viagem')

  local chat = chats[trip.id]
  if #chat > 50 then
    table.remove(chat, 1)
  end

  local data = { content = content, from = source }
  table.insert(chat, data)
  for _, source in pairs({ trip.customer.source, trip.driver.source }) do
    pusher(source, 'uber_message', data)
  end
end)

expose('uber_calculate', function(source, distance)
  local origin = GetEntityCoords(GetPlayerPed(source))

  return {
    price = getPrice(origin, nil, distance),
    drivers = getAvailable(),
  }
end)

expose('uber_create_trip', function(source, pos, distance)
  local user_id = vRP.getUserId(source)
  local from = GetEntityCoords(GetPlayerPed(source))
  local to = vector3(table.unpack(pos))
  local price = getPrice(from, to, distance)
  -- Algumas pessoas possuem esse método retornando string
  local balance = toInt(vRP.getBankMoney(user_id))

  assert(getAvailable() > 0, 'Não há motoristas disponíveis')
  assert(drivers[source] == nil, 'Saia do expediente primeiro')
  assert(balance >= price, 'Saldo insuficiente')

  vRP.setBankMoney(user_id, balance - price)

  local trip = {
    id = generateId(isTripTaken),
    customer = {
      id = user_id,
      source = source,
      name = getName(user_id),
      phone = getPhone(user_id),
      rate = getRate(user_id),
      avatarURL = 'https://cdn.discordapp.com/attachments/976129252359557170/981746890364309514/user_square.png',
    },
    push = function(self, ...)
      pusher(self.customer.source, ...)
      pusher(self.driver.source, ...)
    end,
    cancel = function (self, refund)
      trips[self.id] = nil
      drivers[self.driver.source] = false
      self:push('uber_delete_trip', self.id, true)
      pusher(self.driver.source, 'uber_cancelled')
      if refund then
        vRP.addBank(self.customer.id, self.total,"Private")
      elseif self.driver then
        vRP.addBank(self.driver.id, self.total,"Private")
      end
    end,
    from = toXYZ(from),
    to = toXYZ(to),
    entered = false,
    total = price,
  }

  trips[trip.id] = trip
  chats[trip.id] = {}

  for source, working in pairs(drivers) do
    if working == false then
      pusher(source, 'uber_new_trip', trip)
      notify(source, 'uber', 'Uber', 'Uma nova corrida apareceu no seu radar.')
    end
  end

  CreateThread(function()
    local ms = 30000
    while trips[trip.id] and ms > 0 do
      Wait(100)

      if trip.driver then
        break
      end

      ms = ms - 100
    end

    pusher(-1, 'uber_delete_trip', trip.id, trip.driver ~= nil)
    if not trip.driver then
      trips[trip.id] = nil
      vRP.addBank(user_id, trip.total,"Private")
    end
  end)
end)

expose('uber_is_working', function(source)
  return drivers[source]
end)

expose('uber_start_working', function(source)
  assert(drivers[source] == nil, 'Você já está trabalhando')
  assert(getTrip(source) == nil, 'Espere seu uber ser cancelado primeiro')
  drivers[source] = false
end)

expose('uber_stop_working', function(source)
  assert(drivers[source] == false, 'Você está no meio de uma corrida')
  drivers[source] = nil
end)

expose('uber_get_pending_trips', function(source)
  return table.filter(trips, function(t)
    return t.driver == nil
  end)
end)

expose('uber_my_trips', function(source, asDriver)
  local user_id = assert(vRP.getUserId(source), 'Você está bugado')
  local query = asDriver and 'uber/get_driver_trips' or 'uber/get_trips'
  local rows = vRP.query(query, { user_id = user_id })

  for i, v in ipairs(rows) do
    v.from = json.decode(v.from)
    v.to = json.decode(v.to)
  end

  return rows
end)

expose('uber_set_rate', function(source, id, rate)
  local user_id = assert(vRP.getUserId(source), 'Você está bugado')
  assert(rate >= 1 and rate <= 5, 'A avaliação deve ser entre 1 e 5')
  local trip = assert(vRP.query('uber/find_by_id', { id = id })[1], 'Viagem não encontrada')
  if trip.user_id == user_id then
    trip.driver_rate = rate
  elseif trip.driver_id == user_id then
    trip.user_rate = rate
  else
    throw('Você não participou desta viagem')
  end
  vRP.execute('uber/set_rate', trip)
end)

expose('uber_profile', function(source, asDriver)
  local user_id = assert(vRP.getUserId(source), 'Você está bugado')
  local trips = vRP.query('uber/get_trips_count', { user_id = user_id })[1]

  return {
    trips_count = asDriver and (trips.driver or 0) or (trips.passenger or 0),
    rate = getRate(user_id, asDriver),
    avatarURL = 'https://cdn.discordapp.com/attachments/976129252359557170/981746890364309514/user_square.png'
  }
end)

expose('uber_accept_trip', function(source, id)
  local trip = assert(trips[id], 'Corrida não encontrada')
  assert(trip.driver == nil, 'Esta corrida foi atendida')
  assert(drivers[source] == false, 'Você já está em uma corrida')

  local vehicle = GetVehiclePedIsIn(GetPlayerPed(source))
  assert(vehicle ~= 0, 'Você precisa estar em um veículo')
  local plate = GetVehicleNumberPlateText(vehicle)

  local user_id = vRP.getUserId(source)

  trip.created_at = os.time()
  trip.driver = {
    id = user_id,
    source = source,
    plate = plate,
    name = getName(user_id),
    phone = getPhone(user_id),
    rate = getRate(user_id, true),
    avatarURL = 'https://cdn.discordapp.com/attachments/976129252359557170/981746890364309514/user_square.png',
  }
  drivers[source] = trip
  pusher(trip.customer.source, 'uber_accept_trip', trip.driver)
  notify(trip.customer.source, 'uber', 'Motorista encontrado', string.format(
    '%s (%s) está a caminho',
    trip.driver.name,
    trip.driver.plate
  ))

  CreateThread(function()
    while trips[trip.id] and not trip.entered do
      local cds = GetEntityCoords(GetPlayerPed(source))
      -- Atualiza o blip a cada 0.25 segundos
      emitNet('sj:blip', trip.customer.source, 'uber', cds.x, cds.y, cds.z)
      Wait(250)
    end
    -- Remove o blip ao motorista chegar no local
    emitNet('sj:rmblip', trip.customer.source, 'uber')
  end)
end)

expose('uber_customer_entered', function(source)
  local trip = assert(drivers[source], 'Você não está em uma viagem')
  trip.entered = true
  trip:push('uber_customer_entered')
end)

expose('uber_arrived', function(source)
  local trip = assert(drivers[source], 'Você não está em uma viagem')

  vRP.addBank(trip.driver.id, trip.total,"Private")
  notify(trip.customer.source, 'uber', 'Você chegou ao seu destino', 'Avalie o motorista através do aplicativo.')
  notify(trip.driver.source, 'uber', 'Corrida finalizada', 'Você recebeu R$'..trip.total)

  drivers[source] = false
  trips[trip.id] = nil
  vRP._execute('uber/insert', {
    id = trip.id,
    user_id = trip.customer.id,
    driver_id = trip.driver.id,
    total = trip.total,
    from = json.encode(trip.from),
    to = json.encode(trip.to),
    created_at = trip.created_at
  })

  trip:push('uber_delete_trip', trip.id, true)
end)

expose('uber_cancel', function(source)
  local trip = assert(getTrip(source), 'Você não está em uma viagem')
  assert(not trip.entered, 'Você não pode cancelar após entrar no veículo')
  
  trip:cancel(true)
  notify(trip.driver.source, 'uber', 'Corrida cancelada', 'O passageiro cancelou a viagem')
  notify(source, 'uber', 'Corrida cancelada', 'Você cancelou a viagem e o valor foi estornado para o seu cartão')
end)

AddEventHandler('playerDropped', function()
  local trip = drivers[source]

  if trip then
    vRP.addBank(trip.customer.id, trip.total,"Private")
    notify(trip.customer.source, 'uber', 'Corrida cancelada', 'Seu motorista sofreu um acidente.')
    notify(trip.customer.source, 'bank', 'Cartão de Débito', 'Seu pagamento para JST*Uber foi estornado')
    trips[trip.id] = nil
    pusher(trip.customer.source, 'uber_delete_trip', trip.id, true)
  else
    trip = getTrip(source)
    if trip then
      trips[trip.id] = nil
      if trip.driver then
        vRP.addBank(trip.driver.id, trip.total,"Private")
        notify(trip.driver.source, 'uber', 'Corrida cancelada', 'Você recebeu o valor integral.')
        drivers[trip.driver.source] = false
        pusher(trip.driver.source, 'uber_cancelled')
      end
    end
  end

  drivers[source] = nil
end)

AddEventHandler('smartphone:isReady', function()
  exports.smartphone:createApp(
    'uber', 
    'Uber', 
    'https://fivem.jesteriruka.dev/apps/uber.webp',
    'nui://smartphone-jobs/build/index.html#/uber'
  )
end)