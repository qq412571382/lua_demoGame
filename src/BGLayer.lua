BGLayer = class("BGLayer", function ()
	return cc.Layer:create()
end)
--BGLayer.paralNode= nil
EventManager = require("EventManager")
function BGLayer:initLayer(bg)
	-- local bg1 = display.newSprite("bg_1.png")
 --    bg1:setAnchorPoint(cc.p(0,0))
 --    local bg2 = display.newSprite("bg_2.png")
 --    bg2:setAnchorPoint(cc.p(0,0))
 --    local bg3 = display.newSprite("bg_3.png")
 --    bg3:setAnchorPoint(cc.p(0,0))

 --    local parallax = cc.ParallaxNode:create()
 --    self:addChild(parallax)
 --    self.paralNode = parallax

 --    parallax:addChild(bg1, 3, cc.p(-3,-0.95),cc.p(0,0))
 --    parallax:addChild(bg2, 2, cc.p(-0.4,-0.15),cc.p(0,0))
 --    parallax:addChild(bg3, 1, cc.p(-0.1,-0.05),cc.p(0,70))

 --    local bg4 = display.newSprite("bg_front.png")
 --    self:add(bg4,2)
 --    bg4:setAnchorPoint(cc.p(0,0))
 --    bg4:setPosition(display.left,display.bottom)
    local background = display.newSprite(bg)
    background:setAnchorPoint(cc.p(0.5,0.5))
    background:addTo(self)
    background:pos(background:getContentSize().width/2,
        background:getContentSize().height/2)
    background:setTag(1)
    self:addEventListener()
end
function BGLayer:addEventListener()
    EventManager:addEventListener("ACTION", handler(self, self.moveMap))
end
function BGLayer:moveMap(event)
    if not event.data["action"] then
        print("action null")
        return
    elseif event.data["action"] == "YidongL" then
        self:schedule(function() self:update() end ,1/24)
    elseif event.data["action"] == "YidongR" then
        self:schedule(function() self:update() end ,1/24)
    else
        self:stopAllActions()
    end
end
function BGLayer:update()
   --print("update" .. step .. " tag: " .. self.getChildByTag(1):getTag())
   self:setViewpointCenter(cc.p(_G.heros[1]:getPositionX(),
    _G.heros[1]:getPositionY()))

end

function BGLayer:setViewpointCenter(pos)
    local winSize = cc.Director:getInstance():getWinSize()  
    local  _map = self:getChildByTag(1)
    --如果主角坐标小于屏幕的一半，则取屏幕中点坐标，否则取对象的坐标 
    local x = math.max(pos.x, winSize.width/2)
    local y = winSize.height/2 
    --local y = math.max(pos.y, winSize.height/2)
    x = math.min(x, (_map:getContentSize().width)-winSize.width/2)
    --y = math.min(y, (_map:getContentSize().height)-winSize.height/2)
    local actualPosition = cc.p(x,y)
    local centerOfView = cc.p(winSize.width/2, winSize.height/2)
    local viewPoint = cc.p(centerOfView.x-actualPosition.x,
        centerOfView.y-actualPosition.y)
    self:getParent():setPosition(viewPoint)
end
function BGLayer:createLayer(bg)
	-- body
	local layer = BGLayer.new()
	layer:initLayer(bg)

	return layer
end

return BGLayer