profi = dofile("test/ProFi.lua")
profi:start()


dofile("test/webserver_test.lua")
dofile("test/wireless_test.lua")
dofile("test/wettercom_test.lua")
dofile("test/mqttclient_test.lua")
dofile("test/app_test.lua")
dofile("test/httprequest_test.lua")
dofile("test/time_test.lua")
dofile("test/dht22_test.lua")
dofile("test/bmp180_test.lua")
dofile("test/ds18b20_test.lua")
dofile("test/lcdHD44780_test.lua")


profi:stop()
profi:checkMemory()
profi:writeReport("cov/profiling.txt")
