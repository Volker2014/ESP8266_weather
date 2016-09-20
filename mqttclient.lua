-- file : mqttclient.lua
local module = {}

module.Connected = false

local _host = ""
local _port = 0
local _endpoint = nil
local _id = nil

local _m = nil

local _topic = ""

-- Sends my id to the broker for registration
local function register_myself()  
    local _topic = _endpoint .. _id .. "/#"
    _m:subscribe(_topic,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start() 
    local clientId = "ESP8266-" .. _id
    if module.Connected then
        module.stop()
    end
    _m = mqtt.Client(clientId, 120)
    -- register message callback beforehand
    _m:on("message", function(conn, _topic, data) 
      if data ~= nil then
        print(_topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    _m:connect(_host, _port, 0, 
        function(con) 
            module.Connected = true
            print("connected to mqtt broker as " .. clientId)
            register_myself()
        end,
        function(con, reason)
            print("connection to mqtt broker " .. _host .. " failed: " .. reason)
        end) 
end

function module.publish(_topic, data)
    if module.Connected then
        _m:publish(_topic, data, 0, 0)
    end
end

function module.start(host, port, endpoint, id)
    _host = host
    _port = port
    _endpoint = endpoint
    _id = id
    mqtt_start()
end

function module.stop()
    if module.Connected then
        _m:unsubscribe(_topic)
        _m:close()
        _m = nil
        module.Connected = false
        print("Mqtt client stopped")
    end
end

return module
