-- file : httprequest.lua
-- httpserver-request
-- Part of nodemcu-httpserver, parses incoming client requests.
-- Author: Marcos Kirsch

local module = {}

local function hex_to_char(x)
  return string.char(tonumber(x, 16))
end

local function uri_decode(input)
  return input:gsub("%+", " "):gsub("%%(%x%x)", hex_to_char)
end

local function parseArgs(args, pattern)
   local r = {}
   if args == nil or args == "" then return r end
   for arg in args:gmatch("([^&]+)") do
      local name, value = arg:match("(.*)=[\"]*(.*)[\"]*")
      if name ~= nil then 
        r[name] = uri_decode(value) 
        --print("Parsed: " .. name .. " => " .. value)
    end
   end
   return r
end

local function parseFormData(body)
    return parseArgs(body, "%s*&?([^=]+=[^&]+)")
end

local function parseBoundaryFormData(payload, content, boundary)
   local dispoStart = payload:find("Content-Disposition", 1, true)
   local dispoEnd = payload:find("\r\n", dispoStart, true)
   local disposition = payload:sub(dispoStart, dispoEnd)
   disposition = disposition:match("Content%-Disposition: form%-data;(.*)")
   ---print("disposition: ["..disposition.."]")
   local data = parseArgs(disposition, "([^=%s;]+=[^;]+)")
   local boundaryEnd = content:find(boundary, 1, true)
   data["content"] = content:sub(3, boundaryEnd-3)
   --print(data.name,data.filename,data.content)
   return data
end

local function getRequestData(payload, boundary)
   local requestData
   return function ()
      --print("Getting Request Data")
      if requestData then
         return requestData
      else
         --print("boundary = ["..(boundary or "nil").."]")
         --print("payload = [" .. payload .. "]")
         --print("payloadlen = [" .. #payload .. "]")
         local mimeType = payload:match("Content%-Type: ([%w/-]+)")
         local bodyStart = payload:find("\r\n\r\n", 1, true)
         local body = payload:sub(bodyStart, #payload)
         --print("mimeType = [" .. mimeType .. "]")
         --print("bodyStart = [" .. bodyStart .. "]")
         --print("body = [" .. body .. "]")
         if mimeType == "application/json" then
            --print("JSON: " .. body)
            requestData = cjson.decode(body)
         elseif mimeType == "application/x-www-form-urlencoded" then
            requestData = parseFormData(body)
         elseif mimeType == "multipart/form-data" then
           requestData = payload:match("Content%-Type: multipart/form%-data; boundary=([%w/-]+)")
           --print("boundary: ["..requestData.."]")
         elseif boundary ~= nil then
            if payload:sub(3, #boundary+2) == boundary then
                requestData = parseBoundaryFormData(payload, body, boundary)
            else
                requestData = {}
            end
         else
            requestData = {}
         end
         payload = nil
         collectgarbage()
         return requestData
      end
   end
end

local function parseUri(uri)
   local r = {}
   local filename
   local ext
   local fullExt = {}

   if uri == nil then return r end
   if uri == "/" then uri = "/index.html" end
   questionMarkPos, b, c, d, e, f = uri:find("?")
   if questionMarkPos == nil then
      r.file = uri:sub(1, questionMarkPos)
      r.args = {}
   else
      r.file = uri:sub(1, questionMarkPos - 1)
      r.args = parseArgs(uri:sub(questionMarkPos+1, #uri), "([^&]+)")
   end
   filename = r.file
   while filename:match("%.") do
      filename,ext = filename:match("(.+)%.(.+)")
      table.insert(fullExt,1,ext)
   end
   if #fullExt > 1 and fullExt[#fullExt] == 'gz' then
      r.ext = fullExt[#fullExt-1]
      r.isGzipped = true
   elseif #fullExt >= 1 then
      r.ext = fullExt[#fullExt]
   end
   r.isScript = r.ext == "lua" or r.ext == "lc"
   r.file = "http/" .. r.file:sub(2, -1)
   return r
end

-- Parses the client's request. Returns a dictionary containing pretty much everything
-- the server needs to know about the uri.
function module.parse(request, boundary)
   --print("Request: \n", request)  
   local e = request:find("\r\n", 1, true)
   if not e then return nil end
   local line = request:sub(1, e - 1)
   local r = {}
   _, i, r.method, r.request = line:find("^([A-Z]+) (.-) HTTP/[1-9]+.[0-9]+$")
   r.uri = parseUri(r.request)
   r.getRequestData = getRequestData(request, boundary)
   return r
end

return module
