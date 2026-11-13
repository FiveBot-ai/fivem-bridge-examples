local SHOP = 'my_coinshop'
local CURRENCY = 'gold_coins'

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or GetResourceState(SHOP) ~= 'started' then return end
  local shop = exports[SHOP]

  exports.fivebot_bridge:Provide('currency', {
    get = function(source)
      return { [CURRENCY] = shop:GetCoins(source) or 0 }
    end,
    add = function(source, name, amount)
      return name == CURRENCY and shop:AddCoins(source, amount) == true
    end,
    remove = function(source, name, amount)
      if name ~= CURRENCY or (shop:GetCoins(source) or 0) < amount then return false end
      return shop:RemoveCoins(source, amount) == true
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == SHOP then plugIn() end
end)

plugIn()
