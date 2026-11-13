local STORE = 'My Store'
local API = 'https://api.my-store.example/v1'
local API_KEY = GetConvar('my_store_api_key', '')

local function request(method, path, body)
  local pending = promise.new()
  PerformHttpRequest(API .. path, function(status, text)
    local ok, decoded = pcall(json.decode, text or '')
    pending:resolve({ status = status, body = ok and decoded or nil })
  end, method, body and json.encode(body) or '', {
    ['Authorization'] = 'Bearer ' .. API_KEY,
    ['Content-Type'] = 'application/json',
  })
  return Citizen.Await(pending)
end

local function toOrder(order)
  return {
    id = order.number,
    status = order.refunded and 'refunded' or (order.paid and 'paid' or 'pending'),
    delivery = order.delivered and 'delivered' or (order.queued and 'waiting' or 'failed'),
    amount = tostring(order.total),
    currency = order.currency,
    at = order.created_at,
    items = order.items,
    buyer = order.customer,
  }
end

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or API_KEY == '' then return end

  exports.fivebot_bridge:Provide('payments', {
    label = STORE,
    find = function(query)
      local response = request('POST', '/orders/search', {
        number = query.ref,
        license = query.identifiers.license,
        discord = query.identifiers.discord,
        steam = query.identifiers.steam,
        days = query.days,
      })
      if response.status ~= 200 or type(response.body) ~= 'table' then return {} end
      local orders = {}
      for _, order in ipairs(response.body.orders or {}) do
        orders[#orders + 1] = toOrder(order)
      end
      return orders
    end,
    redeliver = function(order)
      local response = request('POST', '/orders/' .. order.id .. '/redeliver', { note = order.note })
      if response.status == 200 then return true end
      return false, STORE .. ' answered HTTP ' .. tostring(response.status)
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' then plugIn() end
end)

plugIn()
