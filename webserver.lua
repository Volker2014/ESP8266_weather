-- file : webserver.lua
local module = {}

module.server = nil

function module.start(sendFunc)
    server = net.createServer(net.TCP)
    server:listen(80,function(conn)
        conn:on("receive",function(socket,request)
            socket:on("sent",function(sck) 
                sck:close() 
                collectgarbage()
            end)
            if node.heap() < 4096 then
                socket:send("low memory: " .. node.heap())
            elseif (string.find(request, "favicon.ico") == nil) then
                sendFunc(socket, request)
            else
                socket:send("HTTP/1.1 200 OK")
            end
            request = nil
        end)
    end)
end

return module
