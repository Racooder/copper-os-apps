local JSON    = require('copper.json')
local TableDB = require('core.tableDB')
local Util    = require('copper.util')

local fs = _G.fs

local CORE_DIR = '/packages/core/etc/names'
local USER_DIR = '/usr/etc/names'

local nameDB = TableDB()

function nameDB:loadDirectory(directory)
	if fs.exists(directory) then
		local files = fs.list(directory)
		table.sort(files)

		for _,file in ipairs(files) do
			local mod = file:match('(%S+).json')
			if mod then
				local blocks = JSON.decodeFromFile(fs.combine(directory, file))

				if not blocks then
					error('Unable to read ' .. fs.combine(directory, file))
				end

				for strId, block in pairs(blocks) do
					strId = string.format('%s:%s', mod, strId)
					if type(block.name) == 'string' then
						self.data[strId .. ':0'] = block.name
					else
						for nid,name in pairs(block.name) do
							self.data[strId .. ':' .. (nid-1)] = name
						end
					end
				end

			elseif file:match('(%S+).db') then
				local names = Util.readTable(fs.combine(directory, file))
				if not names then
					error('Unable to read ' .. fs.combine(directory, file))
				end
				for key,name in pairs(names) do
					self.data[key] = name
				end
			end
		end
	end
end

function nameDB:load()
	self:loadDirectory(CORE_DIR)
	self:loadDirectory(USER_DIR)
end

function nameDB:getName(strId)
	return self.data[strId] or strId
end

nameDB:load()

return nameDB
