mqttclient = dofile("./mqttclient.lua")

mqtt = dofile("test/mqtt_mock.lua")
config = dofile("test/config_mock.lua")

mqttclient.start("host", 80)
assert(not mqtt.CloseCall)
assert(mqtt.SubscribeCall)

mqttclient.publish("topic", "data", 0, 0)
assert(mqtt.PublishCall)

mqttclient.stop()
assert(mqtt.CloseCall)

mqttclient = nil
mqtt = nil
config = nil