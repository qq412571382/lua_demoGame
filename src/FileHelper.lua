local FileHelper = class("FileHelper")

_helperF = nil

function FileHelper:ctor()
	
end
function FileHelper:getGuanqiaInfo(number)
	
    --local data =  cc.HelperFunc:getFileData("/Users/jinwei/Documents/work_space/lua_demo/jsondata.json")--/Users/jinwei/Documents/work_space/lua_demo/
    local data = io.readfile("/Users/jinwei/Documents/work_space/lua_demo/json.json")
    local tb = json.decode(data)
    --dump(tb["guanqia"][number])
    return tb[number]
end
function FileHelper:getMapInfo()
	--local data = cc.HelperFunc:getFileData("jsondata.json")
	local data = io.readfile("/Users/jinwei/Documents/work_space/lua_demo/json.json")
	local tb = json.decode(data)
	return tb
end
function FileHelper:writeMapInfo(tab)
	local str = json.encode(tab)
	io.writefile("/Users/jinwei/Documents/work_space/lua_demo/json.json",str)
end
function FileHelper:getBagInfo()
	local data = io.readfile("/Users/jinwei/Documents/work_space/lua_demo/jsonbag.json")
	local tb = json.decode(data)
	return tb
end
function FileHelper:wirteBagInfo(tab)
	local str = json.encode(tab)
	io.writefile("/Users/jinwei/Documents/work_space/lua_demo/jsonbag.json",str)
end

if _helperF == nil then
	_helperF = FileHelper.new()
end

return _helperF