-- file : mqttclient.lua
local module = {}

module.Connected = false

_host = ""
_port = 0
_endpoint = nil
_id = nil

m = nil

topic = ""

-- Sends my id to the broker for registration
local function register_myself()  
    local topic = _endpoint .. _id .. "/#"
    m:subscribe(topic,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start() 
    local clientId = "ESP8266-" .. _id
    if module.Connected then
        module.stop()
    end
    m = mqtt.Client(clientId, 120)
    -- register message callback beforehand
    m:on("message", function(conn, topic, data) 
      if data ~= nil then
        print(topic .. ": " .. data)
        -- do something, we have received a message
      end
    end)
    -- Connect to broker
    m:connect(_host, _port, 0, 
        function(con) 
            module.Connected = true
            print("connected to mqtt broker as " .. clientId)
            register_myself()
        end,
        function(con, reason)
            print("connection to mqtt broker " .. _host .. " failed: " .. reason)
        end) 
end

function module.publish(topic, data)
    if module.Connected then
        m:publish(topic, data, 0, 0)
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
        m:unsubscribe(topic)
        m:close()
        m = nil
        module.Connected = false
        print("Mqtt client stopped")
    end
end

return module
