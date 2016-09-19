-- file : ds180b20.lua
local module = {}

module.Temp = 0
module.Error = nil

_datapin = nil
_searchCount = 100
_dividend = 10000

function getAddr()
    ow.setup(_datapin)
    ow.reset_search(_datapin)
    count = 0
    repeat
      count = count + 1
      addr = ow.search(_datapin)
      tmr.wdclr()
    until (addr ~= nil) or (count > _searchCount)
    ow.reset_search(_datapin)
    return addr
end

function module.read()
    module.Error = nil
    addr = getAddr()
    if addr == nil then
        module.Error = "no DS180B20 available"
        return false
    end
    crc = ow.crc8(addr:sub(1,7))
    if (crc ~= addr:byte(8)) then
        module.Error = "wrong CRC "..crc.." DS180B20 with addr "..addr
        return false
    end
    if addr:byte(1) == 0x10 then -- DS18S20, 1 fractional bit
        factor = 5000
    elseif addr:byte(1) == 0x28 then -- DS18B20, 4 fractional bits
        factor = 625
    else
        module.Error = "unknown model of DS180B20 ("..addr:byte(1)..")"
        return false
    end
      
    ow.reset(_datapin)
    ow.select(_datapin, addr)
    ow.write(_datapin, 0x44, 1)
    present = ow.reset(_datapin)
    ow.select(_datapin, addr)
    ow.write(_datapin,0xBE,1)
    data = nil
    data = string.char(ow.read(_datapin))
    for i = 1, 8 do
        data = data .. string.char(ow.read(_datapin))
    end
    crc = ow.crc8(data:sub(1,8))
    if (crc ~= data:byte(9)) then
        module.Error = "wrong CRC "..crc.." DS180B20 for data "..data:byte(1,9)
        return false
    end
    -- print(addr:byte(1,8))
    -- print(data:byte(1,9))
    temp = data:byte(1) + data:byte(2) * 256
    if (temp > 32767) then
        temp = temp - 65536
    end
    temp = temp * factor
    module.Temp = string.format("%d.%01d", temp / _dividend, (temp % _dividend)/100)    
    return true
end

function module.message(format)
    if module.Error ~= nil then
        return module.Error
    end
    return string.format(format, module.Temp) 
end

function module.init(datapin)
    _datapin = datapin
end

return module
