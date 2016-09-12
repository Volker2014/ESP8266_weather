-- file : dht_mock.lua
local module = {}

module.OK = 1
module.ERROR_CHECKSUM = 2
module.ERROR_TIMEOUT = 3

module.Status = 0
module.Temp = 0
module.TempDec = 0
module.Humi = 0
module.HumiDec = 0

function module.read(pin)
	return module.Status, module.Temp, module.Humi, module.TempDec, module.HumiDec
end

return module