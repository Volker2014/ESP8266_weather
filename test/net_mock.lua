-- file : net.lua
local module = {}

module.Server = nil

function module.createServer(tcp)
	if module.Server == nil then
		module.Server = dofile("test/server_mock.lua")
	end
	return module.Server

end

return module