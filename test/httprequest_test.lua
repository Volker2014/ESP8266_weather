print("==============================")
print("test httprequest")
print("------------------------------")

httprequest = dofile("./httprequest.lua")

assert(httprequest.parse("") == nil)
local method,uri,_ = httprequest.parse("GET /test?arg1=1&arg2=b HTTP/1.0\r\n")
assert(method == "GET")
assert(uri.file == "http/test")
assert(uri.args.arg1 == "1")
assert(uri.args.arg2 == "b")

httprequest = nil
