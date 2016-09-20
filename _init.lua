-- file : init.lua
tracememory = true

function requireFile(file)
    local heap = 0
    if tracememory then
        heap = node.heap()
    end
    result = require(file)
    if tracememory then
        print("require " .. file .. ", heap: " .. heap .. " - " .. node.heap())
    end
    return result
end

vdd33 = requireFile("vdd33")
vdd33.init()

config = requireFile("config")
time = requireFile("time")
wireless = requireFile("wireless")
app = requireFile("app")

app.init(config.INTERVAL, config.DATAPINS, config.WEBLOGSCRIPT, config.WETTERCOM, config.MQTT)
wireless.start(app.start, config.SSID, config.PWD)
config = nil
collectgarbage()

