BGLayer = class("BGLayer", function ()
	return cc.Layer:create()
end)
BGLayer.paralNode= nil
function BGLayer:initLayer()
	local bg1 = display.newSprite("bg_1.png")
    bg1:setAnchorPoint(cc.p(0,0))
    local bg2 = display.newSprite("bg_2.png")
    bg2:setAnchorPoint(cc.p(0,0))
    local bg3 = display.newSprite("bg_3.png")
    bg3:setAnchorPoint(cc.p(0,0))

    local parallax = cc.ParallaxNode:create()
    self:addChild(parallax)
    self.paralNode = parallax

    parallax:addChild(bg1, 3, cc.p(-3,-3),cc.p(0,0))
    parallax:addChild(bg2, 2, cc.p(-1,-1),cc.p(0,0))
    parallax:addChild(bg3, 1, cc.p(-0.5,-0.5),cc.p(0,70))

end

function BGLayer:createLayer()
	-- body
	local layer = BGLayer.new()
	layer:initLayer()

	return layer
end


return BGLayer