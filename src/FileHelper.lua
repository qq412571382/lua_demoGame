local FileHelper = class("FileHelper")

_helperF = nil

function FileHelper:ctor()
	
end
function FileHelper:getGuanqiaInfo(number)
	
    local data =  cc.HelperFunc:getFileData("jsondata.json")--/Users/jinwei/Documents/work_space/lua_demo/
    local tb = json.decode(data)
    --dump(tb["guanqia"][number])
    return tb[number]
end
function FileHelper:getMapInfo()
	local data = cc.HelperFunc:getFileData("jsondata.json")
	local tb = json.decode(data)
	return tb
end
function FileHelper:writeMapInfo(tab)
	local str = json.encode(tab)
	io.writefile("jsondata.json",str)
end
if _helperF == nil then
	_helperF = FileHelper.new()
end

return _helperF