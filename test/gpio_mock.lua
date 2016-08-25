-- file : gpio_mock.lua
local module = {}

module.LOW = false
module.HIGH = true
module.OUTPUT = 1

module.values = {}
module.modes = {}

function module.write(pin, level)
    module.values[#module.values+1] = {["pin"] = pin, ["level"] = level}
end

function module.mode(pin, mode) 
    module.modes[#module.modes+1] = {["pin"] = pin, ["mode"] = mode}
end

return module
