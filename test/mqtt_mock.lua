-- file : mqtt_mock.lua
local module = {}

module.SubscribeCall = false
module.UnsubscribeCall = false
module.PublishCall = false
module.CloseCall = false

function module.Client(id, timeout)
	return module
end

function module:on(method, clientFunc)
	if method == "message" then
		clientFunc(self, "topic", "data")
	end
end

function module:connect(host, port, secure, successFunc, errorFunc)
	if host ~= nil then
		successFunc(nil)
	else
		errorFunc(nil, "error")
	end
end

function module:subscribe(topic, qos, subscribeFunc)
	module.SubscribeCall = true
	subscribeFunc(self)
end

function module:unsubscribe(topic)
	module.UnsubscribeCall = true
end

function module:publish(topic, data, qos, retain)
	module.PublishCall = true
end

function module:close()
	module.CloseCall = true
end

return module
