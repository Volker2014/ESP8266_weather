-- file : ds180b20.lua
local module = {}

local _datapin = nil
local _searchCount = 100
local _dividend = 10000

local function getAddr()
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

function module.read(format)
    local addr = getAddr()
    if addr == nil then
        return false, nil, "no DS180B20 available"
    end
    local crc = ow.crc8(addr:sub(1,7))
    if (crc ~= addr:byte(8)) then
        return false, nil, "wrong CRC "..crc.." DS180B20 with addr "..addr
    end
    local factor = 0
    if addr:byte(1) == 0x10 then -- DS18S20, 1 fractional bit
        factor = 5000
    elseif addr:byte(1) == 0x28 then -- DS18B20, 4 fractional bits
        factor = 625
    else
        return false, nil, "unknown model of DS180B20 ("..addr:byte(1)..")"
    end
      
    ow.reset(_datapin)
    ow.select(_datapin, addr)
    ow.write(_datapin, 0x44, 1)
    local present = ow.reset(_datapin)
    ow.select(_datapin, addr)
    ow.write(_datapin,0xBE,1)
    local data = string.char(ow.read(_datapin))
    for i = 1, 8 do
        data = data .. string.char(ow.read(_datapin))
    end
    crc = ow.crc8(data:sub(1,8))
    if (crc ~= data:byte(9)) then
        return false, nil, "wrong CRC "..crc.." DS180B20 for data "..data:byte(1,9)
    end
    -- print(addr:byte(1,8))
    -- print(data:byte(1,9))
    local temp = data:byte(1) + data:byte(2) * 256
    if (temp > 32767) then
        temp = temp - 65536
    end
    temp = temp * factor
    temp = string.format("%d.%01d", temp / _dividend, (math.abs(temp) % _dividend) / 100)    
    return true, temp, string.format(format, temp)
end

function module.init(datapin)
    _datapin = datapin
end

return module
