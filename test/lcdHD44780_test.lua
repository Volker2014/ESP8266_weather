print("==============================")
print("test lcdHD44780")
print("------------------------------")

gpio = dofile("test/gpio_mock.lua")

lcdHD44780 = dofile("./lcdHD44780.lua")

bit = dofile("test/bit_mock.lua")
tmr = dofile("test/tmr_mock.lua")
dofile("test/table_ext.lua")

lcdHD44780.init({pinRS=1, pinEn=2, pinData={3,4,5,6}, maxLen=2})
assert(TableComp(gpio.modes, {{pin=1,mode=1},{pin=2,mode=1},{pin=3,mode=1},{pin=4,mode=1},{pin=5,mode=1},{pin=6,mode=1}}))
assert(TableComp(gpio.values, {{pin=1,level=false},{pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- cmd 3
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- cmd 3
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- cmd 3 
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- cmd 2
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- cmd 0
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=3,level=false},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=5,level=true},{pin=6,level=false}, -- 6
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- cmd 0
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=5,level=true},{pin=6,level=false},{pin=6,level=true}, -- C
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- cmd 2
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false},{pin=6,level=true}, -- 8
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- cmd 0
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                               {pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- 1
                               {pin=2,level=true},{pin=2,level=false}, -- enable
                              }))
lcdHD44780.values = {}
lcdHD44780.setText("A3z", lcdHD44780.AddrLine1)
assert(gpio.values, {{pin=1,level=false},{pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false},{pin=6,level=true}, -- cmd 8
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                     {pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- 0
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                     {pin=1,level=true},{pin=3,level=false},{pin=4,level=false},{pin=5,level=false},{pin=5,level=true},{pin=6,level=false}, -- chr 4
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                     {pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=5,level=false},{pin=6,level=false}, -- 1
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                     {pin=1,level=true},{pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- chr 3
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                     {pin=3,level=false},{pin=3,level=true},{pin=4,level=false},{pin=4,level=true},{pin=5,level=false},{pin=6,level=false}, -- 3
                     {pin=2,level=true},{pin=2,level=false}, -- enable
                    })