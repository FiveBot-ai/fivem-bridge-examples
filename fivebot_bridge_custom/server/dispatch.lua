local DISPATCH = 'my_dispatch'

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or GetResourceState(DISPATCH) ~= 'started' then return end

  exports.fivebot_bridge:Provide('dispatch', {
    alert = function(data)
      exports[DISPATCH]:CreateAlert({
        jobs = data.jobs,
        title = data.name,
        message = data.text,
        coords = data.coords,
        caller = data.source,
      })
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == DISPATCH then plugIn() end
end)

plugIn()
