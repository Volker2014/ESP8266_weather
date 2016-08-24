-- file : dht22.lua
local module = {}

module.Temp = 0
module.Humi = 0
module.Error = nil

function module.read(pin)
    status, temp, humi, temp_dec, humi_dec = dht.read(pin)
    if status == dht.OK then
        module.Error = nil
        module.Temp = temp.."."..temp_dec
        module.Humi = humi.."."..humi_dec
        return true
    elseif status == dht.ERROR_CHECKSUM then
        module.Error = "DHT Checksum error."
        print( module.Error )
        return false
    elseif status == dht.ERROR_TIMEOUT then
        module.Error = "DHT timed out."
        print( module.Error )
        return false
    end
end

return module
