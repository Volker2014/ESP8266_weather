-- file : bit_mock.lua
local module = {}

function module.isset(value, bit)
    for i = 1,bit do
        value = math.floor(value / 2)
    end
    print(value, bit, math.mod(value, 2))
    return math.mod(value, 2) == 1
end

function module.arshift(value, count) 
    for i=1,count do
        value = math.floor(value / 2)
    end
    return value
end

return module
