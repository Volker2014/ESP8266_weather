print("==============================")
print("test dht22")
print("------------------------------")

dht22 = dofile("./dht22.lua")

dht = dofile("test/dht_mock.lua")

dht22.init(1)

dht.Status = dht.ERROR_TIMEOUT
assert(dht22.read() == false)
assert(dht22.Error ~= nil)
assert(dht22.message("%s,%s") == "DHT timed out")

dht.Status = dht.ERROR_CHECKSUM
assert(dht22.read() == false)
assert(dht22.Error ~= nil)
assert(dht22.message("%s,%s") == "DHT Checksum error")

dht.Status = dht.OK
dht.Temp = 20
dht.TempDec = 2
dht.Humi = 51
dht.HumiDec = 4

assert(dht22.read())
assert(dht22.Error == nil)
assert(dht22.Temp == "20.2")
assert(dht22.Humi == "51.4")
assert(dht22.message("%s,%s") == "20.2,51.4")

dht22 = nil
dht = nil
