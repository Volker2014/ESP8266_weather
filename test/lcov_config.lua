local M = {}

--------------------------------------------------------------------
-- This allows you to run coverage over a subset of files.
-- This is an array of strings which are complete filenames.
-- Use the shortcut "exe" to specify the "--exe" filename.  If
-- the shortcut "exe" does not exist the "--exe" file is not
-- covered (i.e. only other files covered).
--------------------------------------------------------------------
M.fileFilter = { "app.lua", "dht22.lua", "bmp180.lua", "httprequest.lua", "mqttclient.lua", "time.lua", "webserver.lua", "wettercom.lua", "wireless.lua" }

--------------------------------------------------------------------
-- true indicates M.fileFilter contains FULL paths and that the filter process
-- should also use full paths.  This is useful if duplicate file names exist.
-- false (just file name) is the default.
--------------------------------------------------------------------
--M.filterFullPaths = true



--------------------------------------------------------------------
-- These are optional override to the existing command line options.
-- If they are commented out the command line options will be used.
--------------------------------------------------------------------
--M.bAppend   = false         -- "--append" option
--M.bCon      = false         -- "--con" option
--M.bDbg      = false         -- "--dbg" option
M.sDir      = "./cov"        -- "--dir" option
--M.bDoAll    = true         -- "--doall" option
M.bGen      = true         -- "--gen" option
M.bListDeps = true         -- "--listdeps" option

--------------------------------------------------------------------
-- These are optional values DO NOT override existing command line options.
--------------------------------------------------------------------
--M.tArgs   = {"-m", "../other.lua", "-t","../test.lua"} -- "--exe" args

M.sExe    = "test/run_tests.lua"            -- "--exe" path/filename

return M

