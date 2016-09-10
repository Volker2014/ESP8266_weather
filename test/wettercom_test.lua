print("==============================")
print("test wettercom")
print("------------------------------")

wettercom = dofile("./wettercom.lua")
time = dofile("./time.lua")

http = dofile("test/http_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")

wettercom.start({host="host", id="id", pwd="pwd", sid="sid"})

wettercom.send(20, 10)
assert(http.GetCall)

http.GetCall = false
wettercom.send2(20)
assert(http.GetCall)

http.GetCall = false
wettercom.send3(20, 1000)
assert(http.GetCall)

wettercom = nil
time = nil
http = nil
rtctime = nil