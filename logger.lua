local Logger = {}

Logger.DEBUG = 4
Logger.INFO = 3
Logger.WARNING = 2
Logger.WARN = 2 --Couldn't decide on naming...
Logger.ERROR = 1

--0 = no messages, higher = more
Logger.level = 0

local function log(message, level)
	if level > Logger.level then return end
	
	local strErrLevel
	
	if level == 4 then strErrLevel = "DEBUG"
	elseif level == 3 then strErrLevel = "INFO"
	elseif level == 2 then strErrLevel = "WARN"
	elseif level == 1 then strErrLevel = "ERROR"
	else
		Logger.log("Invalid log level (" .. level .. ") of following message, setting to DEBUG level", Logger.WARNING)
		level = Logger.DEBUG
		strErrLevel = "DEBUG"
	end
	
	local timeStamp = os.date("%M:%S", os.time())
	
	--Get info about the caller
	t = debug.getinfo(2, "nSl")
	
	--TODO: add detection for non file sources and format the name better
	local fileName = t.source
	
	local prefix = string.format("%s [%s]\t%s:%d", timeStamp, strErrLevel, fileName, t.currentline)
	
	--Only add the function name if it was called from inside a function
	if t.name then prefix = prefix .. " " .. t.name .. "():" end
	
	print(prefix .. " " .. message)
end

--Assign the function to the module name space
Logger.log = log

return Logger