-- file : config_mock.lua
local module = {}

-- needed for mqtt
module.ID = 1
module.ENDPOINT = ""

-- needed for app
module.INTERVAL = 1
module.WETTERCOM = {host="host", id="id", pwd="pwd", sid="sid"}

--needed for mqtt
module.MQTTHOST = "host"

return module