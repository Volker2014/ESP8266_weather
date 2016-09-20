-- file : vdd33.lua
local module = {}

module.Vdd = ""
module.Error = nil

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
        module.Error = nil
        module.Vdd = string.format("%d.%d", vdd / _dividend, vdd % _dividend)
        return true, module.Vdd, string.format(format, module.Vdd)
    end
    module.Error = "adc not initialized for VDD33"
    module.Vdd = ""
    return false, nil, module.Error
end

return module

