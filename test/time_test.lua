time = dofile("./time.lua")

sntp = dofile("test/sntp_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")

sntp.Time = 1

time.sync()
assert(time.now() == "000102030405"..string.format("%02d", rtctime.Time))

sntp = nil
rtctime = nil
