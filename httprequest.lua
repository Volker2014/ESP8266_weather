-- file : httprequest.lua
-- httpserver-request
-- Part of nodemcu-httpserver, parses incoming client requests.
-- Author: Marcos Kirsch

local module = {}

local function parseBoundaryFormData(payload, boundary)
   local data = {}
   local dispoStart = payload:find("Content-Disposition", 1, true)
   local dispoEnd = payload:find("\r\n", dispoStart, true)
   local disposition = payload:sub(dispoStart, dispoEnd)
   _, _, disposition = disposition:find("Content%-Disposition: form%-data;(.+)")
   if disposition ~= nil then
       for k, v in disposition:gmatch('(%w+)="([%p%w]+)";*') do
           data[k] = v
       end
   end
   ---print("disposition: ["..disposition.."]")
   local contentStart = payload:find("\r\n\r\n", 1, true)
   local contentEnd = payload:find(boundary, contentStart, true)
   data["content"] = payload:sub(contentStart, contentEnd-3)
   --print("!",data.name,data.filename,data.content, "!")
   return data
end

local function getRequestData(payload, boundary)
   local requestData
   return function ()
      if requestData then
         return requestData
      else
         --print("boundary = ["..(boundary or "nil").."]")
         --print("payload = [" .. payload .. "]")
         --print("payloadlen = [" .. #payload .. "]")
         local mimeType = payload:match("Content%-Type: ([%w/-]+)")
         --print("mimeType = [" .. mimeType .. "]")
         if mimeType == "multipart/form-data" then
           requestData = payload:match("Content%-Type: multipart/form%-data; boundary=([%w/-]+)")
           --print("boundary: ["..requestData.."]")
         elseif boundary ~= nil then
            if payload:sub(3, #boundary+2) == boundary then
                requestData = parseBoundaryFormData(payload, boundary)
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

local function parseUri(request)
   local _, _, method, path, vars = request:find("([A-Z]+) (.+)?(.+) HTTP/[1-9]+.[0-9]+");
   if(method == nil)then
       _, _, method, path = request:find("([A-Z]+) (.+) HTTP/[1-9]+.[0-9]+");
   end
   local r = {}
   r.method = method
   r.file = path
   r.args = {}
   if vars ~= nil then
       for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
           r.args[k] = v
       end
   end
   return r
end

-- Parses the client's request. Returns a dictionary containing pretty much everything
-- the server needs to know about the uri.
function module.parse(request, boundary)
   --print("Request: \n", request)  
   local uri = parseUri(request)
   local getRequestData = getRequestData(request, boundary)
   return uri.method, uri, getRequestData
end

return module
