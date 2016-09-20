print("==============================")
print("test bmp180")
print("------------------------------")

bmp180 = dofile("./bmp180.lua")

bmp085 = dofile("test/bmp085_mock.lua")

bmp180.init(1, 2)
assert(bmp085.InitCall)

bmp085.Pressure = -1
local valid,temp,pressure,message = bmp180.read("%s,%s")
assert(valid == false)
assert(message == "Bmp180 not available")

bmp085.Pressure = 101
bmp085.Temp = 201
valid,temp,pressure,message = bmp180.read("%s,%s")
assert(valid)
assert(pressure == "1.01")
assert(temp == "20.1")
assert(message == "20.1,1.01")

bmp180 = nil
bmp085 = nil
