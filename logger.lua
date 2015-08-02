local Logger = {}

Logger.DEBUG = 4
Logger.INFO = 3
Logger.WARNING = 2
Logger.WARN = 2 --Couldn't decide on naming...
Logger.ERROR = 1

--0 = no messages, higher = more
Logger.level = 0

local ansiFormatting = true


local function aFormat(str, ...)
	--Formats str with ANSI escape sequences

	if not ansiFormatting or table.getn({...}) = 0 then return str end

	local formatting = ""
	for i,v in ipairs({...}) do
		formatting = formatting .. '[' .. v .. 'm'
	end
	return '\27' .. formatting .. str .. "\27[0m" --Reset to default
end


local function log(message, level)
	if level > Logger.level then return end
	
	local strErrLevel
	
	if level == 4 then strErrLevel = aFormat("DEBUG", 32)
	elseif level == 3 then strErrLevel = "INFO"
	elseif level == 2 then strErrLevel = aFormat("WARNING", 33)
	elseif level == 1 then strErrLevel = aFormat("ERROR", 31)
	else
		log("Invalid log level (" .. level .. ") of following message, setting to DEBUG level", Logger.WARNING)
		level = Logger.DEBUG
		strErrLevel = aFormat("DEBUG", 32)
	end
	
	local timeStamp = aFormat(os.date("%M:%S", os.time()), 2)
	
	--Get info about the caller
	t = debug.getinfo(2, "nSl")
	
	--TODO: add detection for non file sources and format the name better
	local fileName = aFormat(t.source, 1)
	
	local prefix = string.format("%s [%s]\t%s:%s", timeStamp, strErrLevel, fileName, aFormat(t.currentline, 1))
	
	--Only add the function name if it was called from inside a function
	if t.name then prefix = prefix .. " " .. aFormat(t.name .. "():", 2) end
	
	print(prefix .. " " .. message)
end


if love._os == "Windows" then
	ansiFormatting = false
	log("Windows detected, disabling ANSI formatting", Logger.INFO)
end

--Assign the function to the module name space
Logger.log = log

return Logger
