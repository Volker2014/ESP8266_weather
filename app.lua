-- file : app.lua
local module = {}  

oneSecond = 1000
timerInterval = 1*oneSecond
timerNo = 6
weblogscript = nil

function create()
    mqttclient = require("mqttclient")
    webserver = require("webserver")
    httprequest = require("httprequest")
    wettercom = require("wettercom")
    dht22 = require("dht22")
    bmp180 = require("bmp180")
end

function startLoop()
    tmr.stop(timerNo)
    print("Timer interval (ms): " .. timerInterval)
    tmr.alarm(timerNo, timerInterval, 1, module.send_data)
end

function setInterval(interval)
    if interval ~= nil then
        timerInterval = interval * oneSecond
        startLoop()
    end
end

function setMqtt(offOn)
    if offOn == "on" then
        mqttclient.start(config.MQTTHOST, config.PORT)
    elseif  offOn == "off" then
        mqttclient.stop()
    end
end

function setLogscript(script)
    if script ~= nil then
        weblogscript = script
    end
end

function sendConfig(config, conn)
    if config ~= nil then
    print(config)
        conn:send("Interval: "..(timerInterval/oneSecond)..", Mqtt connected: "..tostring(mqttclient.Connected)..", logscript:"..weblogscript)
    end
end

function publishMqtt()
    mqttclient.publish(config.ENDPOINT .. "id", config.ID)
    mqttclient.publish(config.ENDPOINT .. "temp", dht22.Temp)
    mqttclient.publish(config.ENDPOINT .. "humi", dht22.Humi)
end

function module.send_data()  
    dht22.read(config.GPIO)
    print("Date: "..time.now()..", Temp: " .. dht22.Temp .. ", Humi: " .. dht22.Humi)
    publishMqtt()
    wettercom.send(dht22.Temp, dht22.Humi)
    if weblogscript ~= nil then
        http.get("http://"..weblogscript.."?date="..time.now().."&temperature=".. dht22.Temp .. "&humidity=" .. dht22.Humi);
    end
end

function module.receiveRequest(conn, request)
    result = httprequest.parse(request)
    if result ~= nil then
        setInterval(result.uri.args["interval"])
        setMqtt(result.uri.args["mqtt"])
        setLogscript(result.uri.args["logscript"])
        ignoreSend = sendConfig(result.uri.args["config"], conn)
    end
    module.sendHtml(conn)
end

function module.sendHtml(conn)
    if (dht22.read(config.GPIO)) then
        conn:send("Date: "..time.now()..", Temperature: "..dht22.Temp..", Humidity: "..dht22.Humi)
    else
        conn:send("Error: "..dht22.Error)
    end
end

function module.start()
    create()
    timerInterval = config.INTERVAL * oneSecond
    weblogscript = config.WEBLOGSCRIPT;
    webserver.start(module.receiveRequest)
    wettercom.start(config.WETTERCOM)    
    startLoop()
end

return module  
