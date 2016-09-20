-- file : adc_mock.lua
local module = {}

function module.force_init_mode(mode)
    return false
end

function module.readvdd33() 
    return 3000
end

return module
