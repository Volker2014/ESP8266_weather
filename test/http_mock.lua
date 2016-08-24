-- file : http_mock.lua
local module = {}

module.GetCall = false

function module.get(call, headers, callBack)
    module.GetCall = true
    callBack("code", "data")
end

return module
