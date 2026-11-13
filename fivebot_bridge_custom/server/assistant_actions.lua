local GARAGE = 'my_garage'

AddEventHandler('myserver:givecar', function(data, done)
  if data.player == nil or data.player.source == nil then
    return done(false, 'They need to be online')
  end
  if GetResourceState(GARAGE) ~= 'started' then
    return done(false, GARAGE .. ' is not running')
  end
  local model = data.values.model
  local plate = exports[GARAGE]:GiveVehicle(data.player.source, model)
  if not plate then return done(false, 'Unknown model ' .. tostring(model)) end
  done(true, ('Gave %s, plate %s'):format(model, plate))
end)
