-- file : http_mock.lua
local module = {}

module.Call = nil

function module.get(call, headers, callBack)
    module.Call = call
    if callBack ~= nil then
        callBack("code", "data")
    end
end

return module
