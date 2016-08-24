-- file: rtctime_mock.lua
local module = {}

module.Time = 0

function module.epoch2cal(time)
	return {year = 1, mon = 2, day = 3, hour = 4, min = 5, sec = time}
end

function module.get()
	return module.Time
end

return module
