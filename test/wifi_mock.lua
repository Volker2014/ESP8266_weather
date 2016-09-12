-- file : wifi_mock.lua
local module = {}

module.STATION = 1

module.sta = module
module.ap = module

module.Mode = 0
module.ConfigCall = false
module.ConnectCall = false
module.Key = nil
module.Pwd = nil
module.Ip = nil

function module.getip()
	return module.Ip
end

function module.getap()
	return "ap"
end

function module.gethostname()
	return "host"
end

function module.config(key, pwd)
	module.Key = key
	module.Pwd = pwd	
end

function module.connect()
	module.ConnectCall = true
end

function module.getmode()
	return module.Mode
end

function module.setmode(mode)
	module.Mode = mode
end

function module.getmac()
	return "mac"
end

return module