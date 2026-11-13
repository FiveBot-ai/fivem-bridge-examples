local AMBULANCE = 'my_ambulance'

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or GetResourceState(AMBULANCE) ~= 'started' then return end

  exports.fivebot_bridge:Provide('medical', {
    revive = function(source)
      TriggerClientEvent(AMBULANCE .. ':revive', source)
    end,
    heal = function(source)
      TriggerClientEvent(AMBULANCE .. ':heal', source, 'full')
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == AMBULANCE then plugIn() end
end)

plugIn()
