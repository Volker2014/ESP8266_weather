-- file : dht_mock.lua
local module = {}

module.OK = 1
module.ERROR_CHECKSUM = 2
module.ERROR_TIMEOUT = 3

module.Status = 0

function module.read(pin)
	return module.Status, math.random(-10, 40), math.random(0, 100), math.random(0, 9), math.random(0, 9)
end

return module