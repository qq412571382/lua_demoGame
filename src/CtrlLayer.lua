CtrlLayer = class("CtrlLayer",function()
	return cc.Layer:create()
	-- body
end)
local PI = 3.14159
EventManager = require("EventManager")
local size = cc.Director:getInstance():getWinSize()
function CtrlLayer:ctor()
    self.btnS1 = nil
    self.btnS2 = nil
    self.btnS3 = nil
    self.labS1 = nil
    self.labS2 = nil
    self.labS3 = nil
    self.stick = nil
    self.stickBg = nil
    self:addCtrlBtn()
    self:addEventListener()
    self:addJoystick()
    self:setNodeEventEnabled(true)
end

function CtrlLayer:onCleanup()
    self.btnS1 = nil
    self.btnS2 = nil
    self.btnS3 = nil
    self.labS1 = nil
    self.labS2 = nil
    self.labS3 = nil
    self.stick = nil
    self.stickBg = nil
    EventManager:removeAllEventListeners()
    print("CtrlLayer onExit")
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
            -- self.btnS1:setButtonEnabled(true)
            -- self.btnS2:setButtonEnabled(true)
            -- self.btnS3:setButtonEnabled(true)
        end
    end
end

function CtrlLayer:addCtrlBtn()
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

function CtrlLayer:addJoystick()
    self.stickBg = display.newSprite("joystickBg.png")
    self.stickBg:setAnchorPoint(cc.p(0.5,0.5))
    self.stickBg:scale(2.5)
    self.stickBg:pos(display.left+100, display.bottom+100)
    --self:addChild(stickBg, 1)
    self.stick = display.newSprite("joystick.png")
    self.stick:pos(display.left+100, display.bottom+100)
    self.stick:setAnchorPoint(cc.p(0.5,0.5))
    local node = display.newNode()
    --node:setPosition(0,0)
    node:addChild(self.stickBg)
    node:addChild(self.stick, 1)
    node:setContentSize(250,250)
    self:addChild(node)
    node:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
    node:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
        if event.name == "began" then
            print("began")
            if self:onStickTouchBegan(cc.p(event.x,event.y)) then
                return true
            end
        elseif event.name == "moved" then
            self:onStickTouchMoved(cc.p(event.x,event.y))
        elseif event.name == "ended" then
            self:onStickTouchEnded(cc.p(event.x,event.y))
        end
    end)
end
function CtrlLayer:onStickTouchBegan(point)
    local rad = self:stickGetRad(cc.p(display.left+100, display.bottom+100), point)
    if math.sqrt(math.pow(self.stickBg:getPositionX()-point.x, 2)+
        math.pow(self.stickBg:getPositionY()-point.y, 2))<=80
    then
        self.stick:pos(point.x, point.y)
    else
         local p = self:stickGetAnglePos(80,rad)
         self.stick:pos(self.stick:getPositionX()+p.x,self.stick:getPositionY()+p.y)
    end
    self:sendDirctionMsg(rad)
    return true
end
function CtrlLayer:onStickTouchMoved(point)
    local rad = self:stickGetRad(cc.p(display.left+100, display.bottom+100), point)
    --限制轨迹球移动范围
    if math.sqrt(math.pow(self.stickBg:getPositionX()-point.x, 2)+
        math.pow(self.stickBg:getPositionY()-point.y, 2))>80
    then
        local p = self:stickGetAnglePos(80,rad)
        self.stick:pos(self.stickBg:getPositionX()+p.x,self.stickBg:getPositionY()+p.y)
    else
        self.stick:pos(point.x, point.y)
    end
    self:sendDirctionMsg(rad)
end
function CtrlLayer:sendDirctionMsg(rad)
     --获取方向信息
    if rad >= -PI/4 and rad<PI/4 then
        self:sendMsgToListener("ACTION",{["action"]= "YidongR", ["moveStepX"]= 6})
    elseif rad >=PI/4 and rad <3*PI/4 then
       self:sendMsgToListener("ACTION",{["action"]= "YidongU", ["moveStepY"]= 3})
    elseif ((rad >= 3 * PI / 4 and rad<PI)or(rad>=-PI and rad<-3*PI/4)) then
        self:sendMsgToListener("ACTION",{["action"]= "YidongL", ["moveStepX"]= -6})
    elseif rad >= -3*PI/4 and rad < -PI/4 then
        self:sendMsgToListener("ACTION",{["action"]= "YidongD", ["moveStepY"]= -3})
    end
end
function CtrlLayer:onStickTouchEnded(point)
    self.stick:pos(self.stickBg:getPositionX(), self.stickBg:getPositionY())
    self:sendMsgToListener("ACTION",{["action"]= "Kongxian"})
    print("ended")
end
function CtrlLayer:stickGetRad(point1, point2)
    local rokerX = point1.x
    local rokerY = point1.y
    local touchX = point2.x
    local touchY = point2.y

    local x = touchX - rokerX
    local y = touchY - rokerY
    --local xie = sqrt(pow(x,2)+pow(y,2))
    local xie = math.sqrt(math.pow(x, 2)+math.pow(y, 2))
    local cogAngle = x / xie
    --local rad = acos(cogAngle)
    local rad = math.acos(cogAngle)
    if touchY<rokerY then
        rad = -rad
    end
    return rad
end
function CtrlLayer:stickGetAnglePos(banjin,rad)
    local x = banjin * math.cos(rad)
    local y = banjin * math.sin(rad)

    return cc.p(x,y)
end
return CtrlLayer