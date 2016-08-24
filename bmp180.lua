-- file : bmp180.lua
local module = {}

oversampling = 1

function module.read()
    pressure = bmp085.pressure(oversampling)
    return string.format("%d.%02d", pressure / 100, pressure % 100)
end

function module.init(datapin, clockpin)
    bmp085.init(datapin, clockpin)
end

return module
