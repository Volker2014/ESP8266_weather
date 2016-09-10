-- file: sntp_mock.lua
local module = {}

module.Time = 0
module.CorrectUrl = true

function module.sync(url, successFunc, errorFunc)
	if module.CorrectUrl then
        rtctime.Time = module.Time
		successFunc(module.Time, 0, "server")
	else
		errorFunc("error")
	end
end

return module
