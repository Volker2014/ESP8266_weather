print("==============================")
print("test dht22")
print("------------------------------")

dht22 = dofile("./dht22.lua")

dht = dofile("test/dht_mock.lua")

dht22.init(1)

dht.Status = dht.ERROR_TIMEOUT
local valid,temp,humi,message = dht22.read("%s,%s")
assert(valid == false)
assert(message == "DHT timed out")

dht.Status = dht.ERROR_CHECKSUM
valid,temp,humi,message = dht22.read("%s,%s")
assert(valid == false)
assert(message == "DHT Checksum error")

dht.Status = dht.OK
dht.Temp = 20
dht.TempDec = 2
dht.Humi = 51
dht.HumiDec = 4

valid,temp,humi,message = dht22.read("%s,%s")
assert(valid)
assert(temp == "20.2")
assert(humi == "51.4")
assert(message == "20.2,51.4")

dht22 = nil
dht = nil
