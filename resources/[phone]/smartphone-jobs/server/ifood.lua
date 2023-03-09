vRP.prepare('ifood/create', [[CREATE TABLE IF NOT EXISTS smartphone_ifood_orders(
  id VARCHAR(10) PRIMARY KEY,
  user_id INT,
  worker_id INT,
  store_id INT,
  total INT,
  fee INT,
  rate TINYINT DEFAULT 0,
  created_at INT
)]])

vRP.prepare('ifood/insert', [[INSERT INTO smartphone_ifood_orders
  (id, user_id, worker_id, store_id, total, fee, created_at)
  VALUES (@id, @user_id, @worker_id, @store_id, @total, @fee, UNIX_TIMESTAMP())
]])
vRP.prepare('ifood/search', 'SELECT * FROM smartphone_ifood_orders WHERE user_id=@user_id ORDER BY created_at DESC LIMIT 20')
vRP.prepare('ifood/find_by_id', 'SELECT * FROM smartphone_ifood_orders WHERE id = @id')
vRP.prepare('ifood/set_rate', 'UPDATE smartphone_ifood_orders SET rate=@rate WHERE id = @id')
vRP.prepare('ifood/get_stars', 'SELECT store_id, AVG(rate) AS stars FROM smartphone_ifood_orders WHERE rate > 0 GROUP BY store_id')

local orders = {}
local workers = {}

function cancelOrder(order, refund)
  orders[order.id] = nil
  if refund then
    vRP.addBank(order.customer.id, order.total,"Private")
    workers[order.worker] = nil
  else
    vRP.addBank(vRP.getUserId(order.worker), order.fee,"Private")
    workers[order.worker] = false
    pusher(order.worker, 'ifood_cancelled')
  end
  pusher(-1, 'ifood_delete_order', order.id, false)
end

function isOrderTaken(id)
  return orders[id] or #vRP.query('ifood/find_by_id', { id = id }) > 0
end

local function getOrder(source)
  for id, order in pairs(orders) do
    if order.customer.source == source then
      return order
    end
  end
end

expose('ifood_is_ordering', function(source)
  local order = getOrder(source)
  if order then
    return order.id
  end
end)

expose('ifood_find_order', function(source, id)
  local order = orders[id]
  assert(order, 'Pedido não encontrado')
  assert(order.customer.source == source, 'Este pedido não é seu')

  return order
end)

local stars = {}

CreateThread(function()
  vRP.execute('ifood/create')
  while true do
    for i, row in pairs(vRP.query('ifood/get_stars')) do
      stars[tostring(row.store_id)] = tonumber(row.stars)
    end
    Wait(60e3)
  end
end)

CreateThread(function()
  while true do
    for id, order in pairs(orders) do
      if order.worker then
        local customerPed = GetPlayerPed(order.customer.source)
        local workerPed = GetPlayerPed(order.worker)
        if not isPedAlive(customerPed) then
          cancelOrder(order)
          notify(order.worker, 'ifood', 'Cancelamos sua entrega', 'O consumidor sofreu um acidente. Você recebeu o valor integral')
        elseif not isPedAlive(workerPed) then
          cancelOrder(order, true)
          notify(order.customer.source, 'ifood', 'Seu pedido foi cancelado', 'Seu entregador sofreu um acidente. Você foi reembolsado')
        else
          local cds = GetEntityCoords(customerPed)
          if #(cds.xy - vec(order.customer.x, order.customer.y)) >= 30 then
            cancelOrder(order)
            notify(order.customer.source, 'ifood', 'Seu pedido foi cancelado', 'Você se afastou da área combinada')
            notify(order.worker, 'ifood', 'Cancelamos sua entrega', 'O consumidor se afastou da área combinada. Você recebeu o valor integral')
          end
        end
      end
    end
    Wait(5000)
  end
end)

expose('ifood_get_stars', function(source)
  return stars
end)

expose('ifood_get_star', function(source, storeId)
  return stars[storeId] or 0
end)

expose('ifood_get_orders', function(source)
  local user_id = vRP.getUserId(source)

  return vRP.query('ifood/search', { user_id = user_id })
end)

expose('ifood_set_rate', function(source, id, rate)
  local user_id = vRP.getUserId(source)
  assert(user_id, 'Você está bugado')
  
  local order = vRP.query('ifood/find_by_id', { id = id })[1]
  assert(order, 'Pedido não encontrado')
  assert(rate>=0 and rate <= 5, 'Avaliação inválida')

  vRP.execute('ifood/set_rate', { id = id, rate = rate })
end)

local function getPrice(store, distance)
  local pricePerKm = 0
  return toInt(store.fee + distance / 1000 * pricePerKm)
end

expose('ifood_calculate', function(source, storeId, distance)
  local store = assert(table.findBy(config.food.stores, 'id', storeId), 'Loja não encontrada')
  return getPrice(store, distance)
end)

expose('ifood_calculate_all', function(_, stores)
  return table.map(stores, function(data)
    local store = table.findBy(config.food.stores, 'id', data.id)
    return getPrice(store, data.distance)
  end)
end)

expose('ifood_create_order', function(source, id, cart, distance)
  local store = table.findBy(config.food.stores, 'id', id)
  assert(store, 'Loja não encontrada')
  assert(getOrder(source)==nil, 'Você só pode fazer um pedido por vez')
  assert(workers[source]==nil, 'Você está trabalhando')

  local fee = getPrice(store, distance)
  local total = fee
  local items = {}
  for i, product in ipairs(cart) do
    local data = table.findBy(store.products, 'id', product.id)
    total = toInt(total + data.price * product.amount)
    for idname, amount in pairs(data.items) do
      items[idname] = (items[idname] or 0) + amount * product.amount
    end
  end

  local user_id = assert(vRP.getUserId(source), 'Você está bugado (sem id)')

  -- Algumas pessoas possuem esse método retornando string
  local bank = toInt(vRP.getBankMoney(user_id))
  assert(bank >= total, 'Saldo bancário insuficiente')
  vRP.setBankMoney(user_id, bank - total)

  local cds = GetEntityCoords(GetPlayerPed(source))

  local order = { 
    id = generateId(isOrderTaken),
    customer = {
      id = user_id,
      source = source,
      x = cds.x,
      y = cds.y,
      z = cds.z,
    },
    store_id = store.id,
    code = tostring(math.random(1000, 9999)),
    items = items,
    total = total,
    fee = fee,
  }
  orders[order.id] = order

  for source, o in pairs(workers) do
    if o == false then
      pusher(source, 'ifood_new_order', order)
      notify(source, 'ifood', 'iFood', 'Tem um cliente esperando por você! abra seu app e veja mais informações.')
    end
  end

  CreateThread(function()
    local ms = 30000
    while orders[order.id] and ms > 0 do
      Wait(100)

      if order.worker then
        break
      end

      ms = ms - 100
    end

    pusher(-1, 'ifood_delete_order', order.id, order.worker ~= nil)
    if not order.worker then
      orders[order.id] = nil
      vRP.addBank(user_id, order.total,"Private")
    end
  end)

  return order.id
end)

expose('ifood_accept_delivery', function(source, id)
  assert(workers[source] == false, 'Você não está disponível')

  local order = orders[id]
  assert(order.worker == nil, 'Este pedido já foi atendido por outro entregador')

  order.worker = source
  pusher(order.customer.source, 'ifood_order_accept')
  workers[source] = order
end)

expose('ifood_is_working', function(source)
  return workers[source]
end)

expose('ifood_worker_get_orders', function()
  local available = {}
  for id, order in pairs(orders) do
    if not order.worker then
      table.insert(available, order)
    end
  end

  return available
end)

expose('ifood_start_working', function(source)
  assert(getOrder(source) == nil, 'Você possui um pedido em andamento')
  workers[source] = false
end)

expose('ifood_stop_working', function(source)
  assert(workers[source] == false, 'Você possui uma entrega em andamento')
  workers[source] = nil
end)

expose('ifood_pickup', function(source)
  local order = workers[source]
  assert(order, 'Você não está em uma rota')

  order.pickup = true
  pusher(order.customer.source, 'ifood_pickup', true)
  notify(order.customer.source, 'ifood', 'Seu pedido está a caminho', 'O entregador está com seu pedido e chegará em um instante.')
  notify(source, 'ifood', 'Etapa concluída', 'Leve o pedido até o cliente.')

  CreateThread(function()
    while orders[order.id] do
      local cds = GetEntityCoords(GetPlayerPed(source))
      -- Atualiza o blip a cada 0.25 segundos
      emitNet('sj:blip', order.customer.source, 'ifood', cds.x, cds.y, cds.z)
      Wait(250)
    end
    -- Remove o blip no fim da corrida
    emitNet('sj:rmblip', order.customer.source, 'ifood')
  end)
end)

expose('ifood_finish_route', function(source, code)
  local user_id = vRP.getUserId(source)
  local order = workers[source]
  assert(order, 'Você não está entregando')
  assert(order.pickup, 'Você não buscou o pedido no estabelecimento')
  assert(order.code == code, 'Código inválido')
  assert(user_id, 'Você está bugado')

  local cds = GetEntityCoords(GetPlayerPed(source))
  local target = GetEntityCoords(GetPlayerPed(order.customer.source))
  assert(#(cds - target) <= 5, 'Chegue mais perto do cliente')

  for idname, amount in pairs(order.items) do
    vRP.generateItem(order.customer.id, idname, amount)
  end
  vRP.addBank(user_id, order.fee,"Private")
  emitNet('smartphone:pusher', source, 'BANK', {
    sender = 'iFood',
    value = order.fee,
  })
  workers[source] = false
  orders[order.id] = nil
  vRP.execute('ifood/insert', {
    id = order.id,
    user_id = order.customer.id,
    worker_id = user_id,
    store_id = order.store_id,
    total = order.total,
    fee = order.fee
  })
  pusher(order.customer.source, 'ifood_finished')
end)

AddEventHandler('playerDropped', function()
  local order = workers[source]
  if order then
    notify(order.customer.source, 'ifood', 'Pedido cancelado', 'Um cachorro mordeu a perna do seu entregador e portanto seu pedido foi cancelado, pedimos desculpa pelo transtorno.')
    emitNet('smartphone:pusher', order.customer.source, 'BANK_NOTIFY', { 
      title = 'Cartão de Débito',
      subtitle = 'Seu pagamento para JST*iFood foi estornado' 
    })
    cancelOrder(order, true)
  else
    local order = getOrder(source)
    if order then
      orders[order.id] = nil
      if order.worker then
        cancelOrder(order)
        notify(order.worker, 'ifood', 'Cancelamos sua entrega', 'O consumidor sofreu um acidente. Você recebeu o valor integral')
      else
        pusher(-1, 'ifood_delete_order', order.id, false)
      end
    end
  end
end)

AddEventHandler('smartphone:isReady', function()
  exports.smartphone:createApp(
    'ifood', 
    'iFood', 
    'https://fivem.jesteriruka.dev/apps/ifood.webp',
    'nui://smartphone-jobs/build/index.html#/ifood'
  )
end)