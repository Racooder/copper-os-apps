local class   = require('class')
local itemDB  = require('core.itemDB')
local Util    = require('util')

local device = _G.device

local Adapter = class()

function Adapter:init(args)
  if args.side then
    local inventory = device[args.side]
    if inventory then
      Util.merge(self, inventory)
    end
  end
end

function Adapter:listItems(throttle)
  local cache = { }
  throttle = throttle or Util.throttle()

  for k,v in pairs(self.list()) do
    if v.count > 0 then
      local key = table.concat({ v.name, v.damage, v.nbtHash }, ':')

      local entry = cache[key]
      if entry then
        entry.count = entry.count + v.count
      else
        cache[key] = itemDB:get(v, function() return self.getItemMeta(k) end)
      end
      throttle()
    end
  end

  -- TODO: cache number of slots, free slots, used slots
  -- useful for when inserting into chests
  -- ie. insert only if chest does not have item and has free slots

  self.cache = cache
end

return Adapter
