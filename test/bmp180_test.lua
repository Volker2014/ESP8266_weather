bmp180 = dofile("bmp180.lua")

bmp085 = dofile("test/bmp085_mock.lua")

bmp180.init(1, 2)
assert(bmp085.InitCall)

bmp085.Pressure = 101
assert(bmp180.read() == "1.01")

bmp180 = nil
bmp085 = nil
