httprequest = dofile("./httprequest.lua")

assert(httprequest.parse("") == nil)
result = httprequest.parse("GET /test?arg1=1&arg2=b HTTP/1.0\r\n")
assert(result ~= nil)
assert(result.methodIsValid)
assert(result.method == "GET")
assert(result.uri.file == "http/test")
assert(result.uri.args.arg1 == "1")
assert(result.uri.args.arg2 == "b")

httprequest = nil
