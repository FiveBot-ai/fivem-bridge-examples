local MENU = 'my_adminmenu'

local function bridge()
  return GetResourceState('fivebot_bridge') == 'started'
end

AddEventHandler(MENU .. ':playerBanned', function(ban)
  if not bridge() then return end
  exports.fivebot_bridge:reportAction({
    kind = 'ban',
    id = ban.id,
    author = ban.adminSource or ban.adminName,
    target = ban.targetSource or { license = ban.license, discord = ban.discord },
    targetName = ban.targetName,
    reason = ban.reason,
    expiresAt = ban.expiresAt,
  })
end)

AddEventHandler(MENU .. ':playerWarned', function(warn)
  if not bridge() then return end
  exports.fivebot_bridge:reportAction({
    kind = 'warn',
    id = warn.id,
    author = warn.adminSource,
    target = warn.targetSource,
    reason = warn.reason,
  })
end)

AddEventHandler(MENU .. ':banLifted', function(ban)
  if not bridge() then return end
  exports.fivebot_bridge:reportAction({ kind = 'revoke', id = ban.id, author = ban.adminSource or ban.adminName })
end)

AddEventHandler(MENU .. ':itemGiven', function(adminSource, targetSource, item, amount)
  if not bridge() then return end
  exports.fivebot_bridge:logStaffActivity(adminSource, { action = 'item', what = item, amount = amount, target = targetSource })
end)

local function plugIn()
  if not bridge() or GetResourceState(MENU) ~= 'started' then return end

  exports.fivebot_bridge:Provide('moderation', {
    revoke = function(action)
      local ok, reason = exports[MENU]:Unban(action.id, action.note)
      if ok then return true end
      return false, reason or 'The ban was not found'
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == MENU then plugIn() end
end)

plugIn()
