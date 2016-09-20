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
local valid,temp,message = ds18b20.read("%s")
assert(valid == false)
assert(ow.Datapin == 4)
assert(ow.ResetSearchCall == 2)
assert(message == "no DS180B20 available")

ow.Addr = "12345678"
valid,temp,message = ds18b20.read("%s")
assert(valid == false)
assert(message == "wrong CRC 0 DS180B20 with addr 12345678")

ow.Crc = string.byte("8")
valid,temp,message = ds18b20.read("%s")
assert(valid == false)
assert(message == "unknown model of DS180B20 (49)")

ow.Addr = string.char(0x28) .. "2345678"
ow.ReadData = "123456789"
valid,temp,message = ds18b20.read("%s")
assert(valid == false)
assert(ow.ResetCall == 2)
assert(ow.SelectCall == 2)
assert(ow.WriteCall == 2)
assert(message == "wrong CRC 56 DS180B20 for data 49")

ow.ReadData = string.char(2)..string.char(1).."2345678"
valid,temp,message = ds18b20.read("%s")
assert(valid == true)
assert(temp == "16.12")
assert(message == "16.12")

ow.ReadData = string.char(193)..string.char(255).."2345678"
valid,temp,message = ds18b20.read("%s")
assert(valid == true)
assert(temp == "-3.93")
assert(message == "-3.93")

ow.Addr = string.char(0x10) .. "2345678"
ow.ReadData = string.char(1)..string.char(0).."2345678"
valid,temp,message = ds18b20.read("%s")
assert(valid)
assert(temp == "0.50")

ds18b20 = nil
ow = nil
tmr = nil
