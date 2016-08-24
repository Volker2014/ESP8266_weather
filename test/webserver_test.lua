webserver = dofile("./webserver.lua")

net = dofile("test/net_mock.lua")

webserver.start(function(client, request)
	assert(client ~= nil)
	assert(request ~= nil)
end)
assert(server.CloseCall)

net.Server.CallSendFunc = true
webserver.start(nil)
assert(net.Server.SendCall)

webserver = nil
net = nil

