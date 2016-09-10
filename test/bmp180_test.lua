print("==============================")
print("test bmp180")
print("------------------------------")

bmp180 = dofile("./bmp180.lua")

bmp085 = dofile("test/bmp085_mock.lua")

bmp180.init(1, 2)
assert(bmp085.InitCall)

bmp085.Pressure = -1
assert(bmp180.read() == false)

bmp085.Pressure = 101
bmp085.Temp = 201
assert(bmp180.read() == true)
assert(bmp180.Pressure == "1.01")
assert(bmp180.Temp == "20.1")

bmp180 = nil
bmp085 = nil
