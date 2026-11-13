local INVENTORY = 'my_inventory'

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or GetResourceState(INVENTORY) ~= 'started' then return end
  local inventory = exports[INVENTORY]

  exports.fivebot_bridge:Provide('inventory', {
    items = function(source)
      local list = {}
      for _, item in pairs(inventory:GetItems(source) or {}) do
        list[#list + 1] = { name = item.name, count = item.amount }
      end
      return list
    end,
    label = function(item)
      return inventory:GetItemLabel(item) or item
    end,
    count = function(source, item)
      return inventory:GetItemCount(source, item) or 0
    end,
    fits = function(source, item, count)
      return inventory:CanCarry(source, item, count) == true
    end,
    add = function(source, item, count)
      return inventory:AddItem(source, item, count) == true
    end,
    remove = function(source, item, count)
      return inventory:RemoveItem(source, item, count) == true
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == INVENTORY then plugIn() end
end)

plugIn()
