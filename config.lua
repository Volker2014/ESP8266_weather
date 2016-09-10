-- file : config.lua
local module = {}

module.SSID = "your SSID"
module.PWD = "your password"

module.WEBLOGSCRIPT = "your web log script" -- host/folder/file.php

module.MQTTHOST = "your mqtt server"  
module.PORT = 1883
module.ID = node.chipid()
module.INTERVAL = 900 -- seconds

module.ENDPOINT = "nodemcu/"

module.PINDHT22 = 4 -- IO pin for DHT22
module.PIND18B120 = 5 -- IO pin for D18B20
module.PINDATABMP180 = 7 -- IO pin for BMP180 data
module.PINCLOCKBMP180 = 6 -- IO pin for BMP180 clock

module.WETTERCOM = {}
module.WETTERCOM["id"] = "your id"
module.WETTERCOM["pwd"] = "your password"
module.WETTERCOM["sid"] = "API50"
module.WETTERCOM["host"] = "http://interface.wetterarchiv.de/weather/";

return module  
