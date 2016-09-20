-- file: wireless.lua
local module = {}

local startFunc = nil
local wait_timer = 1

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

function module.start(start_func, ssid, pwd)
    startFunc = start_func
    connect(ssid, pwd)
end

return module
