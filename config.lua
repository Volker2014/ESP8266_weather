-- file : config.lua
local module = {}

module.SSID = "your SSID"
module.PWD = "your password"

module.HOST = "your mqtt server"  
module.PORT = 1883
module.ID = node.chipid()
module.INTERVAL = 900 -- seconds

module.ENDPOINT = "nodemcu/"

module.GPIO = 4 -- IO pin for DHT22

module.WETTERCOM = {}
module.WETTERCOM["id"] = "your id"
module.WETTERCOM["pwd"] = "your password"
module.WETTERCOM["sid"] = "API50"
module.WETTERCOM["host"] = "http://interface.wetterarchiv.de/weather/";

return module  
