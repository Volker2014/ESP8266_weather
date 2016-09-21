-- file : app.lua
local module = {}  

local _oneSecond = 1000
local _timerInterval = 1*_oneSecond
local _timerNo = 6
local _weblogscript = nil
local _uploadBoundary = nil
local _wettercomData = nil
local _mqttData = nil
local _dataPins = nil

local _webserver = nil
local _httprequest = nil
local _dht22 = nil
local _bmp180 = nil
local _ds18b20 = nil
local _mqttclient = nil
local _wettercom = nil

local function startLoop()
    tmr.stop(_timerNo)
    --print("Timer interval (ms): " .. _timerInterval)
    tmr.alarm(_timerNo, _timerInterval, 1, module.send_data)
end

local function checkNode(nodeId)
    return nodeId == tostring(node.chipid())
end

local function setInterval(interval)
    if interval ~= nil then
        _timerInterval = interval * _oneSecond
        startLoop()
        return true
    end
    return false
end

local function setMqtt(offOn)
    if offOn == "on" then
        _mqttclient = require("mqttclient")
        _mqttclient.start(_mqttData["host"], _mqttData["port"], _mqttData["endpoint"], _mqttData["id"])
    elseif  offOn == "off" and _mqttclient ~= nil then
        _mqttclient.stop()
        _mqttclient = nil
        collectgarbage()
    end
end

local function setWettercom(offOn)
    if offOn == "on" then
        _wettercom = require("wettercom")
        _wettercom.start(_wettercomData)
        return true
    elseif  offOn == "off" and _wettercom ~= nil then
        _wettercom = nil
        collectgarbage()
        return true
    end
    return false
end

local function setLogscript(script)
    if script ~= nil then
        _weblogscript = script
        return true
    end
    return false
end

local function sendConfig(config, conn)
    if config then
        local message = "Interval: "..(_timerInterval/_oneSecond)
        if _mqttclient ~= nil then
            message = message .. ", Mqtt connected: " .. tostring(_mqttclient.Connected)
        else
            message = message .. ", Mqtt off"
        end
        if _wettercom ~= nil then
            message = message .. ", Wetter.com: on"
        else
            message = message .. ", Wetter.com: off"
        end
        message = message .. ", logscript: " .. _weblogscript
        conn:send(message)
        return true
    end
    return false
end

local function writeFile(data)
print(data.name,data.filename,data.content)
    if data.name ~= "upload" or 
       data.filename == nil or 
       data.content == nil then
        return
    end
    
    file.open(data.filename, "w+")
    file.write(data.content)
    file.close()
    node.restart()
end

function module.send_data()  
    local valid_dht22, dht22Temp, dht22Humi, dht22Message = _dht22.read("&temperature=%s&humidity=%s")
    local valid_ds18b20, ds18b20Temp, ds18b20Message = _ds18b20.read("&pooltemp=%s")
    local valid_bmp180, bmp180Temp, bmp180Pressure, bmp180Message = _bmp180.read("&boxtemp=%s&pressure=%s")
    local valid_Vdd33, vdd33Vdd, vdd33Message = vdd33.read("&vdd=%s")
    local message = ""
    local wetterValues = {}
    if valid_dht22 then
        message = message .. dht22Message
        wetterValues["te"] = dht22Temp
        wetterValues["hu"] = dht22Humi
    end
    if valid_ds18b20 then
        message = message .. ds18b20Message
        wetterValues["teo"] = ds18b20Temp
    end
    if valid_bmp180 then
        message = message .. bmp180Message
        wetterValues["tei"] = bmp180Temp
        wetterValues["pr"] = bmp180Pressure
    end
    if valid_Vdd33 then
        message = message .. vdd33Message
    end
    --print(tostring(_weblogscript) .. ", Date: " .. time.now() .. message)
    if message == "" then
        return
    end

    if _weblogscript ~= nil then
        http.get("http://".._weblogscript.."?date="..time.now() .. message);
    end

    if _wettercom ~= nil then
        _wettercom.send(wetterValues)
    end

    if _mqttclient ~= nil then
        _mqttclient.publish(_mqttData["endpoint"] .. "id", _mqttclient["id"])
        _mqttclient.publish(_mqttData["endpoint"] .. "temp", dht22Temp)
        _mqttclient.publish(_mqttData["endpoint"] .. "humi", dht22Humi)
        _mqttclient.publish(_mqttData["endpoint"] .. "pooltemp", ds18b20Temp)
        _mqttclient.publish(_mqttData["endpoint"] .. "boxtemp", bmp180Temp)
        _mqttclient.publish(_mqttData["endpoint"] .. "pressure", bmp180Pressure)
        _mqttclient.publish(_mqttData["endpoint"] .. "vdd", vdd33Vdd)
    end
end

function module.receiveRequest(conn, request)
    local method, uri, getRequestData = _httprequest.parse(request, _uploadBoundary)
    local ignoreSend = false
    if method ~= nil then
        if method == "GET" then
            if checkNode(uri.args["node"]) then
                ignoreSend = ignoreSend or setInterval(uri.args["interval"])
                ignoreSend = ignoreSend or setMqtt(uri.args["mqtt"])
                ignoreSend = ignoreSend or setWettercom(uri.args["wettercom"])
                ignoreSend = ignoreSend or setLogscript(uri.args["logscript"])
                ignoreSend = sendConfig(uri.args["config"] ~= nil or ignoreSend, conn)
            end
        elseif method == "POST" then
            if checkNode(uri.args["node"]) then
                _uploadBoundary = getRequestData()
            end
        elseif _uploadBoundary ~= nil then
            local data = getRequestData()
            writeFile(data)
            _uploadBoundary = nil
            collectgarbage()
        end
    end
    method = nil
    uri = nil
    getRequestData = nil
    collectgarbage()
    if not ignoreSend then
        module.sendHtml(conn)
    end
end

function module.sendHtml(conn)
    local valid_dht22, dht22Temp, dht22Hmui, dht22Message = _dht22.read("Temperature: %s, Humidity: %s")
    local valid_ds18b20, ds18b20Temp, ds18b20Message = _ds18b20.read("Pooltemp: %s")
    local valid_bmp180, bmp180Temp, bmp180Pressure, bmp180Message = _bmp180.read("BoxTemperature: %s, Pressure: %s")
    local valid_Vdd33, vdd33Vdd, vdd33Message = vdd33.read("Vdd: %s")
    local message = "Date: "..time.now()
    message = message .. ", " .. dht22Message
    message = message .. ", " .. ds18b20Message
    message = message .. ", " .. bmp180Message
    message = message .. ", " .. vdd33Message
    message = message .. ", Heap: " .. node.heap()
    conn:send(message)
    message = nil
    collectgarbage()
end

function module.start(wettercomOn, mqttOn)
    _webserver = requireFile("webserver")
    _httprequest = requireFile("httprequest")
    _dht22 = requireFile("dht22")
    _bmp180 = requireFile("bmp180")
    _ds18b20 = requireFile("ds18b20")

    if wettercomOn then
        setWettercom("on")
    end
    if mqttOn then
        setMqtt("on")
    end

    _webserver.start(module.receiveRequest)
    _dht22.init(_dataPins["DHT22"])  
    _ds18b20.init(_dataPins["D18B120"])
    _bmp180.init(_dataPins["DATABMP180"], _dataPins["CLOCKBMP180"])

    startLoop()
end

function module.init(interval, datapins, script, wettercomData, mqttData)
    _timerInterval = interval * _oneSecond
    setLogscript(script)
    _dataPins = datapins
    _wettercomData = wettercomData
    _mqttData = mqttData
end

return module  
