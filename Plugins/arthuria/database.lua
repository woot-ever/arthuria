local json = require ("dkjson")

local DB = {}
DB.fileData = {}
DB.file = 'data.db'

function DB.load(file)
	file = file or DB.file
	DB.file = file
	
	local h = io.open(file, "r")
	if h ~= nil then
		local data = h:read("*all")
		h:close()
		local obj, pos, err = json.decode(data, 1, nil)
		DB.fileData[file] = obj or {}
		return DB.fileData[file]
	else
		DB.fileData[file] = {}
		return nil
	end
end

function DB.data(file)
	file = file or DB.file
	if not DB.fileData[file] then
		return DB.load(file)
	else
		return DB.fileData[file]
	end
end

function DB.get(key, file)
	file = file or DB.file
	if not DB.fileData[file] then
		DB.load(file)
	end
	return DB.fileData[file][key]
end

function DB.set(key, value, file)
	file = file or DB.file
	
	if not DB.fileData[file] then
		DB.load(file)
	end
	
	DB.fileData[file][key] = value
end

function DB.save(data, file)
	file = file or DB.file
	if type(data) == 'string' then file = data end
	
	if type(data) == 'table' then
		DB.fileData[file] = data
	end
	
	local handle = io.open(file, "w")
	
	if (handle ~= nil) then
		local dumped = DB.dump(DB.fileData[file])
		if (not dumped) then
			print("DB.save ERROR: dumped is null")
		else
			handle:write(dumped)
		end
		handle:close()
		return true
	end
	
	return false
end

function DB.dump(o)
	return json.encode(o, { indent = false })
end

function __index(_, key)
	return DB.get(key)
end

function __newindex(_, key, value)
	return DB.set(key, value)
end

return DB;