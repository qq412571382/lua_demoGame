Bag = class("Bag", function ()
	return display.newLayer()
end)

function Bag:ctor()
	
	self:init()
end
function Bag:onCleanup()
	
end
function Bag:init()
	local bag = cc.uiloader:load("bag1.json")
    bag:addTo(self)
    bag:pos(display.cx,display.cy)
end
function Bag:onTouchBegan(point)
    print("bag began")
    return true
end
function Bag:onTouchMoved(point)
    print("bag moved")
end
function Bag:onTouchEnded(point)
    print("bag ended")
end




return Bag

