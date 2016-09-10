-- file : wettercom.lua
local module = {}

_httpPrefix = ""

function module.send(temp, humi)
    local httpCall =  _httpPrefix ..
        "&dtutc=" .. time.now() ..
        "&te=" .. temp ..
        "&hu=" .. humi;
    http.get(httpCall, nil, function(code, data)
            print("Wetter: "..code, data)
        end);
end

function module.send2(temp)
    local httpCall =  _httpPrefix ..
        "&dtutc=" .. time.now() ..
        "&teo=" .. temp;
    http.get(httpCall, nil, function(code, data)
            print("Wetter: "..code, data)
        end);
end

function module.start(apiAccess)
    _httpPrefix = apiAccess["host"] .. 
                    "?id="..  apiAccess["id"] ..
                    "&pwd=" .. apiAccess["pwd"] ..
                    "&sid=" .. apiAccess["sid"]      
end

return module
