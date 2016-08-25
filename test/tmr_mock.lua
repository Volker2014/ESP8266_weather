-- file : tmr_mock.lua
local module = {}

module.StopCall = false

function module.stop(timer)
	module.StopCall = true
end

function module.alarm(timer, time, count, callback)
	callback()
end

function module.delay(time)
end

return module