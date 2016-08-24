-- file: wireless.lua
local module = {}

startFunc = nil
ssidList = nil
wait_timer = 1

local function wifi_wait_ip()  
  if wifi.sta.getip() == nil then
    print("IP unavailable, Waiting...")
  else
    tmr.stop(wait_timer)
    time.sync()
    print("\n====================================")
    print("ESP8266 mode is: " .. wifi.getmode())
    print("MAC address is: " .. wifi.ap.getmac())
    print("IP is "..wifi.sta.getip())
    print("HOST is "..wifi.sta.gethostname())
    print("====================================")
    startFunc()
  end
end

local function connect(key, pwd)
    print("Connecting to " .. key .. " ...")
    tmr.stop(wait_timer)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(key, pwd)
    wifi.sta.connect()
    tmr.alarm(wait_timer, 2500, 1, wifi_wait_ip)
end

local function wifi_start(list_aps)
    if ssidList == nil then
        print("SSID list is empty")
    elseif list_aps then
        for key,value in pairs(list_aps) do
            if ssidList[key] then
                connect(key, ssidList[key])
            else
                print("Key " .. key .. " is not in SSID list")
            end
        end
    else
        print("Error getting AP list")
    end
end

function module.start(start_func, ssid_list)
    startFunc = start_func
    ssidList = ssid_list
    print("Configuring Wifi ...")
    wifi.sta.getap(wifi_start)
end

function module.start(start_func, ssid, pwd)
    startFunc = start_func
    connect(ssid, pwd)
end

return module
