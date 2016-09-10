-- file : http_mock.lua
local module = {}

module.GetCall = false

function module.get(call, headers, callBack)
    module.GetCall = true
    if callBack ~= nil then
        callBack("code", "data")
    end
end

return module
