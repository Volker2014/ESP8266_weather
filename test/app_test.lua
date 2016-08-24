app = dofile("./app.lua")
time = dofile("./time.lua")

config = dofile("test/config_mock.lua")
tmr = dofile("test/tmr_mock.lua")
net = dofile("test/net_mock.lua")
dht = dofile("test/dht_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")
http = dofile("test/http_mock.lua")
mqtt = dofile("test/mqtt_mock.lua")

dht.Status = dht.OK

app.start()

assert(net.Server.SendCall)
assert(net.Server.CloseCall)
assert(http.GetCall)
assert(tmr.StopCall)

net.Server.SendCall = false
app.receiveRequest(net.Server, "GET /?interval=1 HTTP/1.0\r\n")
assert(net.Server.SendCall)

app.receiveRequest(net.Server, "GET /?mqtt=on HTTP/1.0\r\n")
assert(mqtt.SubscribeCall)

app.receiveRequest(net.Server, "GET /?mqtt=off HTTP/1.0\r\n")
assert(mqtt.CloseCall)

app = nil
time = nil
config = nil
tmr = nil
net = nil
dht = nil
rtctime = nil
http = nil
mqtt = nil