local MENU = 'my_adminmenu'

AddEventHandler('myserver:unban', function(data, done)
  if GetResourceState(MENU) ~= 'started' then
    return done(false, MENU .. ' is not running')
  end
  local license = data.player.identifiers.license
  if not license then
    return done(false, 'No license on this player')
  end
  local ok = exports[MENU]:UnbanByLicense(license, ('Ticket #%s, %s'):format(data.ticket.number, data.staff.name))
  done(ok == true, ok and 'Unbanned' or 'No active ban for this license')
end)

AddEventHandler('myserver:checkban', function(data, done)
  if GetResourceState(MENU) ~= 'started' then
    return done(false, MENU .. ' is not running')
  end
  local ban = exports[MENU]:GetBan(data.player.identifiers.license)
  if not ban then return done(true, 'No active ban') end
  done(true, ('Banned by %s: %s'):format(ban.adminName, ban.reason))
end)
