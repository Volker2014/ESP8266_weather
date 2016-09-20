-- file : wettercom.lua
local module = {}

local _httpPrefix = ""

function module.send(values)
    local httpCall =  _httpPrefix .. "&dtutc=" .. time.now()
    for key, value in pairs(values) do
        httpCall = httpCall .. "&" .. key .. "=" .. value
    end
    http.get(httpCall, nil, function(code, data)
            print("Wetter: "..code, data)
        end)
end

function module.start(apiAccess)
    _httpPrefix = apiAccess["host"] .. 
                    "?id="..  apiAccess["id"] ..
                    "&pwd=" .. apiAccess["pwd"] ..
                    "&sid=" .. apiAccess["sid"]      
end

return module
