print("==============================")
print("test mqttclient")
print("------------------------------")

mqttclient = dofile("./mqttclient.lua")

gpio = dofile("test/gpio_mock.lua")
mqtt = dofile("test/mqtt_mock.lua")

mqttclient.start("host", 80, "", 1)
assert(not mqtt.CloseCall)
assert(mqtt.SubscribeCall)

mqttclient.publish("topic", "data", 0, 0)
assert(mqtt.PublishCall)

mqttclient.stop()
assert(mqtt.CloseCall)

mqttclient = nil
mqtt = nil
config = nil