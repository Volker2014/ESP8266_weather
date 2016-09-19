-- file : init.lua
if adc ~= nil then
    if adc.force_init_mode(adc.INIT_VDD33)
    then
      node.restart()
      return -- don't bother continuing, the restart is scheduled
    end
end

config = require("config")
time = require("time")
wireless = require("wireless")
app = require("app")  

app.init(config.INTERVAL, config.WEBLOGSCRIPT, config.WETTERCOM)
wireless.start(app.start, config.SSID, config.PWD)
