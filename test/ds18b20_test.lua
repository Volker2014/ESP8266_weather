print("==============================")
print("test ds18b20")
print("------------------------------")

ds18b20 = dofile("./ds18b20.lua")

ow = dofile("test/ow_mock.lua")
tmr = dofile("test/tmr_mock.lua")

assert(ds18b20.read() == false)

pin = 4
ds18b20.init(pin)

ow.ResetSearchCall = 0
assert(ds18b20.read() == false)
assert(ow.Datapin == 4)
assert(ow.ResetSearchCall == 2)

ow.Addr = "12345678"
assert(ds18b20.read() == false)

ow.Crc = string.byte("8")
assert(ds18b20.read() == false)

ow.Addr = string.char(0x28) .. "2345678"
ow.ReadData = "123456789"
assert(ds18b20.read() == false)
assert(ow.ResetCall == 2)
assert(ow.SelectCall == 2)
assert(ow.WriteCall == 2)

ow.ReadData = string.char(2)..string.char(1).."2345678"
assert(ds18b20.read() == true)
assert(ds18b20.Temp == 16.125)

ow.ReadData = string.char(193)..string.char(255).."2345678"
assert(ds18b20.read() == true)
assert(ds18b20.Temp == -3.9375)

ds18b20 = nil
ow = nil
tmr = nil
