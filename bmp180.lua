-- file : bmp180.lua
local module = {}

module.Pressure = 0
module.Temp = 0
module.Error = nil

oversampling = 1

function module.read()
    local temp = bmp085.temperature()
    local pressure = bmp085.pressure(oversampling)
    module.Temp = string.format("%d.%01d", temp / 10, temp % 10)    
    module.Pressure = string.format("%d.%02d", pressure / 100, pressure % 100)
    module.Error = nil
    if pressure <= 0 then
        module.Error = "Bmp180 not available"
    end
    return pressure > 0
end

function module.message(format)
    if module.Error ~= nil then
        return module.Error
    end
    return string.format(format, module.Temp, module.Pressure) 
end

function module.init(datapin, clockpin)
    bmp085.init(datapin, clockpin)
end

return module
