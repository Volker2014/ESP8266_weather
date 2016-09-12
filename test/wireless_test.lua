print("==============================")
print("test wireless")
print("------------------------------")

wireless = dofile("./wireless.lua")
time = dofile("./time.lua")

sntp = dofile("test/sntp_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")
wifi = dofile("test/wifi_mock.lua")
tmr = dofile("test/tmr_mock.lua")

wireless.start(function()
		assert(false == true)
	end, "", "")

wifi.Ip = "ip"
wireless.start(function()
		assert(wifi.Mode == wifi.STATION)
		assert(wifi.Key == "key")
		assert(wifi.Pwd == "pwd")
		assert(wifi.ConnectCall)
		assert(tmr.StopCall)
	end, "key", "pwd")

wireless = nil
time = nil
sntp = nil
rtctime = nil
wifi = nil
tmr = nil
