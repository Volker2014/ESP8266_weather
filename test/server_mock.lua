-- file : server.lua
local module = {}

module.CloseCall = false
module.SendCall = false
module.CallSendFunc = false

function module:listen(port, connFunc)
	connFunc(self)
end

function module:on(method, connFunc)
	if method == "receive" then
		if module.CallSendFunc then
			connFunc(self, "favicon.ico")
		else
			connFunc(self, "request")
		end
	elseif method == "sent" then
		connFunc(self)
	end
end

function module:send(request)
	module.SendCall = true
end

function module:close()
	module.CloseCall = true
end

return module
