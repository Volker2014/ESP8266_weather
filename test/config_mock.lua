-- file : config_mock.lua
local module = {}

-- needed for mqtt
module.ID = 1
module.ENDPOINT = ""

-- needed for app
module.INTERVAL = 1
module.WETTERCOM = {host="host", id="id", pwd="pwd", sid="sid"}
module.PINDHT22 = 4 -- IO pin for DHT22
module.PIND18B120 = 5 -- IO pin for D18B20
module.PINDATABMP180 = 7 -- IO pin for BMP180 data
module.PINCLOCKBMP180 = 6 -- IO pin for BMP180 clock

--needed for mqtt
module.MQTTHOST = "host"

return module