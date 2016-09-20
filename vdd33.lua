-- file : vdd33.lua
local module = {}

local _dividend = 1000

function module.init()
    if adc.force_init_mode(adc.INIT_VDD33) then
      node.restart()
      return -- don't bother continuing, the restart is scheduled
    end
end

function module.read(format)
    local vdd = adc.readvdd33()
    if vdd ~= 65535 then
        vdd = string.format("%d.%d", vdd / _dividend, vdd % _dividend)
        return true, vdd, string.format(format, vdd)
    end
    return false, nil, "adc not initialized for VDD33"
end

return module

