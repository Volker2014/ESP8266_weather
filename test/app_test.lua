print("==============================")
print("test app")
print("------------------------------")

tracememory = true

function requireFile(file)
    result = require(file)
    if tracememory then
        print("require " .. file .. ", heap: " .. node.heap())
    end
    return result
end

app = dofile("./app.lua")
time = dofile("./time.lua")
vdd33 = dofile("./vdd33.lua")

config = dofile("test/config_mock.lua")
adc = dofile("test/adc_mock.lua")
tmr = dofile("test/tmr_mock.lua")
net = dofile("test/net_mock.lua")
dht = dofile("test/dht_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")
http = dofile("test/http_mock.lua")
mqtt = dofile("test/mqtt_mock.lua")
ow = dofile("test/ow_mock.lua")
bmp085 = dofile("test/bmp085_mock.lua")
node = dofile("test/node_mock.lua")

dht.Status = dht.OK
dht.Temp = 20
dht.TempDec = 4
dht.Humi = 50
dht.humiDec = 2

interval = 1
wettercom = {host="host", id="id", pwd="pwd", sid="sid"}
script = "script"

app.init(interval, script, wettercom)
app.start(true, false)

assert(net.Server.SendCall)
assert(net.Server.CloseCall)
assert(http.GetCall)
assert(tmr.StopCall)

net.Server.SendCall = false
app.receiveRequest(net.Server, "GET /?node=0&interval=1 HTTP/1.0\r\n")
assert(net.Server.SendCall)

app.receiveRequest(net.Server, "GET /?node=0&mqtt=on HTTP/1.0\r\n")
assert(mqtt.SubscribeCall)

app.receiveRequest(net.Server, "GET /?node=0&mqtt=off HTTP/1.0\r\n")
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
node = nil
vdd33 = nil
adc = nil
