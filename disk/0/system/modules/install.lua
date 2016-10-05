-- v0.1
local update = dofile('/modules/update.lua')
local json = dofile('/modules/json.lua')

local path = '/modules.json'

local module = {
	versions = nil,

	init = function(self, args)
		if #args == 0 then
			print('Usage: install <module name> [, ...]')
			return
		end

		-- get versions table from modules.json
		self.versions = self:getLocalVersions()

		-- add each module from args to table
		for key, val in ipairs(args) do
			self.versions[args[key]] = ""
		end

		-- save modules.json
		self:saveVersions()

		-- run update
		update()
	end,

	--- Writes the versions table to the modules.json file
	-- @param self
	saveVersions = function(self)
		-- make sure file exists
		if not fs.exists(path) then return end

		-- open file for reaching
		local file = fs.open(path, 'w')
		file.write(json:encode(self.versions))
		file.close()
	end,

	--- Retrieves module names and versions from storage
	-- @param self
	-- @returns 	Returns a table containing module names as table keys and 
	--				their version numbers as table values
	getLocalVersions = function(self)
		if not fs.exists(path) then
			return
		end

		-- open file
		local file = fs.open(path, 'r')

		-- read file contents
		-- decode JSON into table
		local data = json:decode(file:readAll())
		file:close()

		-- return table
		return data
	end,
}

return function(...)
	module:init(arg)
end