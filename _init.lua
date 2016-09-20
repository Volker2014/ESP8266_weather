-- file : init.lua
tracememory = true

function requireFile(file)
    result = require(file)
    if tracememory then
        print("require " .. file .. ", heap: " .. node.heap())
    end
    return result
end

vdd33 = requireFile("vdd33")
vdd33.init()

config = requireFile("config")
time = requireFile("time")
wireless = requireFile("wireless")
app = requireFile("app")

app.init(config.INTERVAL, config.WEBLOGSCRIPT, config.WETTERCOM)
wireless.start(app.start, config.SSID, config.PWD)
