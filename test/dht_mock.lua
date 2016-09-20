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
    if pin ~= nil then
        return module.Status, module.Temp, module.Humi, module.TempDec, module.HumiDec
    end
    return 0
end

return module