-- file : bmp085_mock.lua
local module = {}

module.InitCall = false
module.Pressure = 0
module.Temp = 0

function module.pressure(oversampling)
    return module.Pressure
end

function module.temperature()
    return module.Temp
end

function module.init(datapin, clockpin)
    module.InitCall = datapin ~= nil and clockpin ~= nil
end

return module
