-- file : mqttclient.lua
local module = {}

_host = ""
_port = 0

m = nil
connected = false
topic = ""

-- Sends my id to the broker for registration
local function register_myself()  
    topic = config.ENDPOINT .. config.ID .. "/#"
    m:subscribe(topic,0,function(conn)
        print("Successfully subscribed to data endpoint")
    end)
end

local function mqtt_start() 
    clientId = "ESP8266-" .. config.ID
    if connected then
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
            connected = true
            print("connected to mqtt broker as " .. clientId)
            register_myself()
        end,
        function(con, reason)
            print("connection to mqtt broker " .. _host .. " failed: " .. reason)
        end) 
end

function module.publish(topic, data)
    if connected then
        m:publish(topic, data, 0, 0)
    end
end

function module.start(host, port)
    _host = host
    _port = port
    mqtt_start()
end

function module.stop()
    if connected then
        m:unsubscribe(topic)
        m:close()
        m = nil
        connected = false
        print("Mqtt client stopped")
    end
end

return module
