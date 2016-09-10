-- file : app.lua
local module = {}  

oneSecond = 1000
timerInterval = 1*oneSecond
timerNo = 6
weblogscript = nil
uploadBoundary = nil
_wettercom = nil

function create()
    webserver = require("webserver")
    httprequest = require("httprequest")
    wettercom = require("wettercom")
    dht22 = require("dht22")
    bmp180 = require("bmp180")
    ds18b20 = require("ds18b20")
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
        mqttclient = require("mqttclient")
        mqttclient.start(config.MQTTHOST, config.PORT, config.ENDPOINT, config.ID)
    elseif  offOn == "off" and mqttclient ~= nil then
        mqttclient.stop()
        mqttclient = nil
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
    if mqttclient ~= nil then
        mqttclient.publish(config.ENDPOINT .. "id", config.ID)
        mqttclient.publish(config.ENDPOINT .. "temp", dht22.Temp)
        mqttclient.publish(config.ENDPOINT .. "humi", dht22.Humi)
        mqttclient.publish(config.ENDPOINT .. "pooltemp", ds18b20.Temp)
    end
end

function writeFile(data)
print(data.name,data.filename,data.content)
    if data.name ~= "upload" or 
       data.filename == nil or 
       data.content == nil then
        return
    end
    
    file.open(data.filename, "w+")
    file.write(data.content)
    file.close()
end

function module.send_data()  
    validDht22 = dht22.read()
    validDs18b20 = ds18b20.read()
    validBmp180 = bmp180.read()
    print("Date: " .. time.now() .. ", Temp: " .. dht22.Temp .. ", Humi: " .. dht22.Humi .. ", Pooltemp: " .. ds18b20.Temp..", Boxtemp: "..bmp180.Temp..", Pressure: "..bmp180.Pressure)
    publishMqtt()
    if validDht22 then
        wettercom.send(dht22.Temp, dht22.Humi)
    end
    if validDs18b20 then
        wettercom.send2(ds18b20.Temp)
    end
    if validBmp180 then
        wettercom.send3(bmp180.Temp, bmp180.Pressure)
    end
    if weblogscript ~= nil then
        http.get("http://"..weblogscript.."?date="..time.now().."&temperature=".. dht22.Temp .. "&humidity=" .. dht22.Humi .. "&pooltemp=" .. ds18b20.Temp .. "&boxtemp=" .. bmp180.Temp .. "&pressure=" .. bmp180.Pressure);
    end
end

function module.receiveRequest(conn, request)
    result = httprequest.parse(request, uploadBoundary)
    if result ~= nil then
        if result.method == "GET" then
            setInterval(result.uri.args["interval"])
            setMqtt(result.uri.args["mqtt"])
            setLogscript(result.uri.args["logscript"])
            ignoreSend = sendConfig(result.uri.args["config"], conn)
        elseif result.method == "POST" then
            data = result.getRequestData()
            uploadBoundary = data
        elseif uploadBoundary ~= nil then
            data = result.getRequestData()
            writeFile(data)
            uploadBoundary = nil
        end
    end
    module.sendHtml(conn)
end

function module.sendHtml(conn)
    if (dht22.read() or ds18b20.read()) then
        conn:send("Date: "..time.now()..", Temperature: "..dht22.Temp..", Humidity: "..dht22.Humi..",Pooltemp: "..ds18b20.Temp)
    else
        conn:send("Error: Dht22 - "..dht22.Error..", Ds18B20 - "..ds18b20.Error)
    end
end

function module.start()
    create()
    webserver.start(module.receiveRequest)
    wettercom.start(_wettercom)
    dht22.init(config.PINDHT22)  
    ds18b20.init(config.PIND18B120)
    bmp180.init(config.PINDATABMP180, config.PINCLOCKBMP180)
    startLoop()
end

function module.init(interval, script, wettercom)
    timerInterval = interval * oneSecond
    setLogscript(script)
    _wettercom = wettercom
end

return module  
