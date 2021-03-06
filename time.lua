-- file: time.lua
local module = {}

function module.now()
    local tm = rtctime.epoch2cal(rtctime.get())
    return string.format("%04d%02d%02d%02d%02d%02d", 
            tm["year"], tm["mon"], tm["day"], 
            tm["hour"], tm["min"], tm["sec"])
end

function module.sync()
    sntp.sync("pool.ntp.org",
        function(sec,usec,server)
            print("current date/time: " .. module.now())
        end,
        function(error)
            print('sntp sync failed: '.. error)
        end
    )
end

return module
