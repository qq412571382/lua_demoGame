local Hero = class("Hero", function()
	return require("Role").new()
end)
Hero.paral = nil


function Hero:ctor()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.move)) --cc.NODE_ENTER_FRAME_EVENT   for every frame
end

function Hero:jump()

	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("jump"))
	transition.execute(self,cc.JumpBy:create(0.7,cc.p(0,0),70,1),{
		onComplete = function ()
			-- body
			self:idle()
		end
		})
	transition.execute(self.paral,cc.JumpBy:create(0.7,cc.p(0,0),70,1))
end
function Hero:skill1()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("skill1"))
	transition.execute(self,cc.MoveBy:create(0.5,cc.p(50,0)),{
		onComplete = function ()
			-- body
			self:idle()
		end
		})
	-- body
end
function Hero:skill2()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("skill2"))
	transition.execute(self,cc.MoveBy:create(1,cc.p(200,0)),{
		onComplete = function ()
			-- body
			self:idle()
		end
		})
end
function Hero:skill3()
	self:stopAllActions()
	display.getAnimationCache("skill3"):setDelayPerUnit(0.05)
	transition.playAnimationOnce(self,display.getAnimationCache("skill3"))
	transition.execute(self,cc.MoveBy:create(0.25,cc.p(350,0)),{
		onComplete = function ()
			-- body
			self:idle()
		end
		})
end
function Hero:idle2()
	-- body
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("idleR2"))
end
function Hero:move()

	local heroPosXLast = self:getPositionX()
	local heroPosYLast = self:getPositionY()
	if self:getPositionX()+self.moveStep <= 10 or self:getPositionX()+self.moveStep >=890 then
		self:setPosition(self:getPositionX(),self:getPositionY())
	else
		self:setPosition(self:getPositionX()+self.moveStep,self:getPositionY())
	end
	local heroPosXNow = self:getPositionX()
	local heroPosYNow = self:getPositionY()

	local offsetX = heroPosXNow - heroPosXLast
	local offsetY = heroPosYNow - heroPosYLast
	if(self.paral:getPositionX()+offsetX <=0 or self.paral:getPositionX() + offsetX >=470) then
		self.paral:setPosition(self.paral:getPositionX(),self.paral:getPositionY())
	else
		self.paral:setPosition(self.paral:getPositionX()+offsetX,self.paral:getPositionY()+offsetY)
	end

	print("x:".. self.paral:getPositionX() .. " y:" .. self.paral:getPositionY())
end
function Hero:moveLeft()

	self:playAnimationForever(display.getAnimationCache("moveR"))
	self:scheduleUpdate()
end
function Hero:moveRight()

	transition.playAnimationForever(self,display.getAnimationCache("moveR"))
	self:scheduleUpdate()
end
return Hero