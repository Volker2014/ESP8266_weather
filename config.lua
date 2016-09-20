-- file : config.lua
local module = {}

module.SSID = "your SSID"
module.PWD = "your password"

module.WEBLOGSCRIPT = "your web log script" -- host/folder/file.php

module.MQTT = {}
module.MQTT["host"] = "your mqtt server"  
module.MQTT["port"] = 1883
module.MQTT["id"] = node.chipid()
module.MQTT["endpoint"] = "nodemcu/"

module.INTERVAL = 900 -- seconds

module.DATAPINS = {}
module.DATAPINS["DHT22"] = 6 -- IO pin for DHT22
module.DATAPINS["D18B120"] = 7 -- IO pin for D18B20
module.DATAPINS["DATABMP180"] = 5 -- IO pin for BMP180 data
module.DATAPINS["CLOCKBMP180"] = 4 -- IO pin for BMP180 clock

module.WETTERCOM = {}
module.WETTERCOM["id"] = "your id"
module.WETTERCOM["pwd"] = "your password"
module.WETTERCOM["sid"] = "API50"
module.WETTERCOM["host"] = "http://interface.wetterarchiv.de/weather/";

return module  
