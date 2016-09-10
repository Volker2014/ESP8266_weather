-- file : ow_mock.lua
local module = {}

module.Datapin = nil
module.ResetSearchCall = 0
module.ResetCall = 0
module.SelectCall = 0
module.WriteCall = 0
module.Addr = nil
module.ReadData = nil
module.Crc = 0

function module.setup(datapin)
    module.Datapin = datapin
end

function module.reset_search(datapin)
    if module.Datapin == datapin then
        module.ResetSearchCall = module.ResetSearchCall + 1
    end
end

function module.search(datapin)
    if module.Datapin == datapin then
        return module.Addr
    end
    return nil
end

function module.crc8(buffer)
    return module.Crc
end

function module.reset(datapin)
    if module.Datapin == datapin then
        module.ResetCall = module.ResetCall + 1
    end
end

function module.select(datapin, addr)
    if module.Datapin == datapin and module.Addr == addr then
        module.SelectCall = module.SelectCall + 1
    end
end

function module.write(datapin, byte, power)
    if module.Datapin == datapin and power == 1 then
        if module.WriteCall == 0 and byte == 0x44 then
            module.WriteCall = 1
        elseif module.WriteCall == 1 and byte == 0xBE then
            module.WriteCall = 2
        end
    end
end

function module.read(datapin)
    if module.Datapin ~= datapin or module.ReadData == nil then
        return nil
    end
    byte = module.ReadData:byte(1)
    module.ReadData = module.ReadData:sub(2)
    return byte
end

return module
