print("==============================")
print("test wettercom")
print("------------------------------")

wettercom = dofile("./wettercom.lua")
time = dofile("./time.lua")

http = dofile("test/http_mock.lua")
rtctime = dofile("test/rtctime_mock.lua")

wettercom.start({host="host", id="id", pwd="pwd", sid="sid"})

wettercom.send({te=1,hu=2,teo=3,tei=4,pr=5})
assert(http.Call == "host?id=id&pwd=pwd&sid=sid&dtutc=00010203040500&te=1&pr=5&teo=3&tei=4&hu=2")

wettercom = nil
time = nil
http = nil
rtctime = nil