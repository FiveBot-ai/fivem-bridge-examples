local CORE = 'my_core'

local ACCOUNTS = { cash = 'money', bank = 'bank', dirty = 'black_money' }

local function player(source)
  return exports[CORE]:GetPlayer(source)
end

local function plugIn()
  if GetResourceState('fivebot_bridge') ~= 'started' or GetResourceState(CORE) ~= 'started' then return end

  exports.fivebot_bridge:Provide('framework', {
    character = function(source)
      local p = player(source)
      if not p then return nil end
      return { name = p.firstName .. ' ' .. p.lastName, job = p.job.name, grade = p.job.gradeLabel }
    end,
    key = function(source)
      local p = player(source)
      return p and p.citizenId
    end,
    money = function(source)
      local p = player(source)
      if not p then return nil end
      return { cash = p.accounts.money or 0, bank = p.accounts.bank or 0, dirty = p.accounts.black_money or 0 }
    end,
    addMoney = function(source, account, amount)
      return exports[CORE]:AddMoney(source, ACCOUNTS[account], amount) == true
    end,
    removeMoney = function(source, account, amount)
      local p = player(source)
      if not p or (p.accounts[ACCOUNTS[account]] or 0) < amount then return false end
      return exports[CORE]:RemoveMoney(source, ACCOUNTS[account], amount) == true
    end,
    setJob = function(source, job, grade)
      return exports[CORE]:SetJob(source, job, grade) == true
    end,
  })
end

AddEventHandler('onResourceStart', function(resource)
  if resource == 'fivebot_bridge' or resource == CORE then plugIn() end
end)

plugIn()
