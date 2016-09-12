-- file : node_mock.lua
local module = {}

module.ChipId = 0

function module.chipid()
	return module.ChipId
end

return module