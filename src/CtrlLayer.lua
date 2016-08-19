CtrlLayer = class("CtrlLayer",function()
	return cc.Layer:create()
	-- body
end)
EventManager = require("EventManager")
local size = cc.Director:getInstance():getWinSize()
function CtrlLayer:ctor()
    self.btnS1 = nil
    self.btnS2 = nil
    self.btnS3 = nil
    self.labS1 = nil
    self.labS2 = nil
    self.labS3 = nil
    self:addCtrlBtn()
    self:addEventListener()
end

function CtrlLayer:sendMsgToListener(dispatcher_name,msg_table)
    EventManager:pushEvent(dispatcher_name, msg_table)
end
function CtrlLayer:addEventListener()
    EventManager:addEventListener("HERO_MSG",handler(self,self.getMsgForSkill))
end
function CtrlLayer:getMsgForSkill(event)
    if event.data["level"] then
        local level = event.data["level"]
        if level == 1 then
            self.btnS1:setButtonEnabled(false)
            self.btnS2:setButtonEnabled(false)
            self.btnS3:setButtonEnabled(false)
        elseif level == 2 then
            self.btnS1:setButtonEnabled(true)
            self.btnS2:setButtonEnabled(false)
            self.btnS3:setButtonEnabled(false)
        elseif level == 3 then
            self.btnS1:setButtonEnabled(true)
            self.btnS2:setButtonEnabled(true)
            self.btnS3:setButtonEnabled(false)
        else
            self.btnS1:setButtonEnabled(true)
            self.btnS2:setButtonEnabled(true)
            self.btnS3:setButtonEnabled(true)
        end
    end
end

function CtrlLayer:addCtrlBtn()
    --moveleft
    cc.ui.UIPushButton.new({normal = "btnLeftN.png",pressed="btnLeftP.png"})
        :pos(display.cx*0.15,display.cy/4)
        :scale(1.5)
        :onButtonPressed(function()
            self:sendMsgToListener("ACTION",{["action"]= "YidongL", ["moveStep"]= -6})
        end)
        :onButtonRelease(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Kongxian"})
        end)
        :addTo(self)
    --move right
    cc.ui.UIPushButton.new({normal = "btnRightN.png",pressed="btnRightP.png"})
        :pos(display.cx*0.45,display.cy/4)
        :scale(1.5)
        :onButtonPressed(function()
            self:sendMsgToListener("ACTION",{["action"]= "YidongR", ["moveStep"]= 6})
        end)
        :onButtonRelease(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Kongxian"})
        end)
        :addTo(self)
    --attack
    cc.ui.UIPushButton.new({normal = "hit.png",pressed="hit.png"})
        :pos(size.width*0.94,size.width - size.width*0.94)
        :scale(2)
        :onButtonClicked(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Gongji"})
        end)
        :addTo(self)
    --jump
    cc.ui.UIPushButton.new({normal = "jump.png",pressed="jump.png"})
        :pos(size.width*0.835,size.width - size.width*0.93)
        :onButtonClicked(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Tiaoyue"})
        end)
        :addTo(self)
    --skill button
    self.btnS1 = cc.ui.UIPushButton.new({normal = "skill1.png",pressed="skill1.png",disabled="locked.png"})
        :pos(size.width*0.88,size.width - size.width*0.87)
        :onButtonClicked(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Jineng1"})
        end)
        :addTo(self)  
    self.btnS2 = cc.ui.UIPushButton.new({normal = "skill2.png",pressed="skill2.png",disabled="locked.png"})
        :pos(size.width*0.955,size.width - size.width*0.84)
        :onButtonClicked(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Jineng2"})
        end)
        :addTo(self)
    self.btnS3 = cc.ui.UIPushButton.new({normal = "skill3.png",pressed="skill3.png",disabled="locked.png"})
        :pos(size.width*0.77,size.width - size.width*0.97)
        :onButtonClicked(function ()
            self:sendMsgToListener("ACTION",{["action"]= "Jineng3"})
        end)
        :addTo(self)
end

return CtrlLayer