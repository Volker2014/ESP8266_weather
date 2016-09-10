-- file : bmp180.lua
local module = {}

module.Pressure = 0
module.Temp = 0

oversampling = 1

function module.read()
    local temp = bmp085.temperature()
    local pressure = bmp085.pressure(oversampling)
    module.Temp = string.format("%d.%01d", temp / 10, temp % 10)    
    module.Pressure = string.format("%d.%02d", pressure / 100, pressure % 100)
    return pressure > 0
end

function module.init(datapin, clockpin)
    bmp085.init(datapin, clockpin)
end

return module
