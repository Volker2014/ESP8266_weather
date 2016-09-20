-- file : dht22.lua
local module = {}

local _datapin = nil

function module.read(format)
    local status, temp, humi, temp_dec, humi_dec = dht.read(_datapin)
    if status == dht.OK then
        temp = temp.."."..temp_dec
        humi = humi.."."..humi_dec
        return true, temp, humi, string.format(format, temp, humi)
    elseif status == dht.ERROR_CHECKSUM then
        return false, nil, nil, "DHT Checksum error"
    elseif status == dht.ERROR_TIMEOUT then
        return false, nil, nil, "DHT timed out"
    end
    return false, nil, nil, "unknown status: " .. status
end

function module.init(datapin)
    _datapin = datapin
end

return module
