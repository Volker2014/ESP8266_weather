-- file : bmp180.lua
local module = {}

local _oversampling = 1

function module.read(format)
    local temp = bmp085.temperature()
    local pressure = bmp085.pressure(_oversampling)
    if pressure <= 0 then
        return false, nil, nil,"Bmp180 not available"
    end
    temp = string.format("%d.%01d", temp / 10, temp % 10)    
    pressure = string.format("%d.%02d", pressure / 100, pressure % 100)
    return true, temp, pressure, string.format(format, temp, pressure)
end

function module.init(datapin, clockpin)
    bmp085.init(datapin, clockpin)
end

return module
