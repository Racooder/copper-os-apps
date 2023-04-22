local LZW  = require('copper.compress.lzw')
local Tar  = require('copper.compress.tar')
local Util = require('copper.util')

local shell = _ENV.shell

local args  = { ... }

if not args[2] then
	error('Syntax: tar OUTFILE DIR')
end

local file = shell.resolve(args[1])
local dir = shell.resolve(args[2])

local filetype = 'tar'
if file:match('(.+)%.tar$') then
	filetype = 'tar'
elseif file:match('(.+)%.lzw$') then
	filetype = 'lzw'
end

if filetype == 'tar' then
	Tar.tar(file, dir)

elseif filetype == 'lzw' then
	local c = Tar.tar_string(dir)
	Util.writeFile(file, LZW.compress(c), 'wb')
end
