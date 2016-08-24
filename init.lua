-- file : init.lua
config = require("config")
time = require("time")
wireless = require("wireless")
app = require("app")  

wireless.start(app.start, config.SSID, config.PWD)
