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
            print("left")
            CtrlLayer.hero.moveStep = -4
            if CtrlLayer.hero:heroCanDoEvent("YidongL") then
               CtrlLayer.hero:heroDoEvent("YidongL")
            end
        end)
        :onButtonRelease(function ()
            if CtrlLayer.hero:heroCanDoEvent("Kongxian") then
               CtrlLayer.hero:heroDoEvent("Kongxian")
            end
        end)
        :addTo(self)
    --move right
    cc.ui.UIPushButton.new({normal = "btnRightN.png",pressed="btnRightP.png"})
        :pos(display.cx*0.45,display.cy/4)
        :scale(1.5)
        :onButtonPressed(function ()
            print("right")
            CtrlLayer.hero.moveStep = 4
            if CtrlLayer.hero:heroCanDoEvent("YidongR") then
                CtrlLayer.hero:heroDoEvent("YidongR")
            end
        end)
        :onButtonRelease(function ()
            if CtrlLayer.hero:heroCanDoEvent("Kongxian") then
                CtrlLayer.hero:heroDoEvent("Kongxian")
            end
        end)
        :addTo(self)
    --attack
    cc.ui.UIPushButton.new({normal = "hit.png",pressed="hit.png"})
        :pos(size.width*0.94,size.width - size.width*0.94)
        :scale(2)
        :onButtonClicked(function ()
           if CtrlLayer.hero:heroCanDoEvent("Gongji") then
                CtrlLayer.hero:heroDoEvent("Gongji")
           end
        end)
        :addTo(self)
    --jump
    cc.ui.UIPushButton.new({normal = "jump.png",pressed="jump.png"})
        :pos(size.width*0.835,size.width - size.width*0.93)
        :onButtonClicked(function ()
            if CtrlLayer.hero:heroCanDoEvent("Tiaoyue") then
                CtrlLayer.hero:heroDoEvent("Tiaoyue")
            end
        end)
        :addTo(self)
    --skill button
    cc.ui.UIPushButton.new({normal = "skill1.png",pressed="skill1.png"})
        :pos(size.width*0.88,size.width - size.width*0.87)
        :onButtonClicked(function ()
             if CtrlLayer.hero:heroCanDoEvent("Jineng1") then
                CtrlLayer.hero:heroDoEvent("Jineng1")
            end
        end)
        :addTo(self)
    cc.ui.UIPushButton.new({normal = "skill2.png",pressed="skill2.png"})
        :pos(size.width*0.955,size.width - size.width*0.84)
        :onButtonClicked(function ()
            if CtrlLayer.hero:heroCanDoEvent("Jineng2") then
               CtrlLayer.hero:heroDoEvent("Jineng2")
            end
        end)
        :addTo(self)
    cc.ui.UIPushButton.new({normal = "skill3.png",pressed="skill3.png"})
        :pos(size.width*0.77,size.width - size.width*0.97)
        :onButtonClicked(function ()
            if CtrlLayer.hero:heroCanDoEvent("Jineng3") then
               CtrlLayer.hero:heroDoEvent("Jineng3")
            end
        end)
        :addTo(self)
end

function CtrlLayer:initLayer(role)
    

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