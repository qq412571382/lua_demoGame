CtrlLayer = class("CtrlLayer",function()
	return cc.Layer:create()
	-- body
end)
CtrlLayer.hero = nil

local size = cc.Director:getInstance():getWinSize()

    -- body
function CtrlLayer:addCtrlBtn()
    --moveleft
    cc.ui.UIPushButton.new({normal = "btnLeftN.png",pressed="btnLeftP.png"})
        :pos(display.cx*0.15,display.cy/4)
        :scale(1.5)
        :onButtonPressed(function()
            CtrlLayer.hero.moveStep = -3
            CtrlLayer.hero:moveLeft()
                print(_G.hero:getTag())
            for i,v in ipairs(_G.enemys) do
                print(v:getTag())
            end
        end)
        :onButtonRelease(function()
            CtrlLayer.hero:idle()
            CtrlLayer.hero:unscheduleUpdate()
        end)
        :addTo(self)
    --move right
    cc.ui.UIPushButton.new({normal = "btnRightN.png",pressed="btnRightP.png"})
        :pos(display.cx*0.45,display.cy/4)
        :scale(1.5)
        :onButtonPressed(function ()
            CtrlLayer.hero.moveStep = 3
            CtrlLayer.hero:moveRight()
        end)
        :onButtonRelease(function ()
            CtrlLayer.hero:idle()
            CtrlLayer.hero:unscheduleUpdate()
        end)
        :addTo(self)
    --attack
    cc.ui.UIPushButton.new({normal = "hit.png",pressed="hit.png"})
        :pos(size.width*0.94,size.width - size.width*0.94)
       -- :setAnchorPoint(cc.p(1,0))
        :scale(2)
        :onButtonClicked(function ()
           CtrlLayer.hero:attack()
        end)
        :addTo(self)
    --jump
    cc.ui.UIPushButton.new({normal = "jump.png",pressed="jump.png"})
        :pos(size.width*0.835,size.width - size.width*0.93)
        :onButtonClicked(function ()
            CtrlLayer.hero:jump()
        end)
        :addTo(self)
    --skill button
    cc.ui.UIPushButton.new({normal = "skill1.png",pressed="skill1.png"})
        :pos(size.width*0.88,size.width - size.width*0.87)
        :onButtonClicked(function ()
            CtrlLayer.hero:skill1()
        end)
        :addTo(self)
    cc.ui.UIPushButton.new({normal = "skill2.png",pressed="skill2.png"})
        :pos(size.width*0.955,size.width - size.width*0.84)
        :onButtonClicked(function ()
            CtrlLayer.hero:skill2()
        end)
        :addTo(self)
    cc.ui.UIPushButton.new({normal = "skill3.png",pressed="skill3.png"})
        :pos(size.width*0.77,size.width - size.width*0.97)
        :onButtonClicked(function ()
            CtrlLayer.hero:skill3()
        end)
        :addTo(self)
end

function CtrlLayer:initLayer(role)
    

    local menuitemPause = cc.MenuItemFont:create("Pause")
    menuitemPause:setPosition(size.width,size.height)
    menuitemPause:registerScriptTapHandler(function ()
        --display.pause()
        print("pause")
    end)
    local menu = cc.Menu:create(menuitemPause)
    menuitemPause:setAnchorPoint(cc.p(1,1))
    menu:setPosition(0,0)
    self:addChild(menu)
    
    self:addCtrlBtn()
    CtrlLayer.hero = role
end
function CtrlLayer:ctor()

	-- body
end


function CtrlLayer:createLayer(role)
	local layer = CtrlLayer.new()
	-- body
	layer:initLayer(role)
	return layer
end


return CtrlLayer