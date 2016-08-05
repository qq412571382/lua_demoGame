Controller = class("Controller",function ()
	-- body
	return cc.Node:create()
end)

class(classname, super)
Controller.hero = "sd"

function Controller:createController(role)
	-- body
	local ctrl = Controller.new()
	print(Controller.hero)
	return ctrl
end

return Controller