local Util = require('copper.util')

local shell = _ENV.shell

return {
	getWorkingDirectory = shell.dir,
	resolve = shell.resolve,
	resolveProgram = shell.resolveProgram,
	parse = Util.parse,
}
