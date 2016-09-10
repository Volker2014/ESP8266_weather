print("==============================")
print("test dht22")
print("------------------------------")

dht22 = dofile("./dht22.lua")

dht = dofile("test/dht_mock.lua")

dht22.init(1)

dht.Status = dht.ERROR_TIMEOUT
assert(dht22.read() == false)
assert(dht22.Error ~= nil)

dht.Status = dht.ERROR_CHECKSUM
assert(dht22.read() == false)
assert(dht22.Error ~= nil)

dht.Status = dht.OK
assert(dht22.read())
assert(dht22.Error == nil)
assert(dht22.Temp ~= 0)
assert(dht22.Humi ~= 0)

dht22 = nil
dht = nil
