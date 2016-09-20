-- file : webserver.lua
local module = {}

module.server = nil

function module.start(sendFunc)
    server = net.createServer(net.TCP)
    server:listen(80,function(conn)
        conn:on("receive",function(client,request)
            if (string.find(request, "favicon.ico") == nil) then
                sendFunc(client, request)
            else
                conn:send("HTTP/1.1 200 OK")
            end
            client = nil
            request = nil
            collectgarbage()
        end)
        conn:on("sent",function(conn) 
            conn:close() 
            conn = nil
            collectgarbage()
        end)
    end)
end

return module
