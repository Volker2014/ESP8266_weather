-- file : bmp085_mock.lua
local module = {}

module.InitCall = false
module.Pressure = 0

function module.pressure(oversampling)
    return module.Pressure
end

function module.init(datapin, clockpin)
    module.InitCall = true
end

return module
