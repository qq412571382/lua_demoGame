local Hero = class("Hero", function()
	return require("Role").new()
end)
Hero.paral = nil
Hero.mpBar = nil
Hero.mana = 100
function Hero:ctor()
	--self:setScaleX(-1.8)
	self.health = 100
	self.moveDirection = 1
	self:addStateMachine()
end

function Hero:jump()
	self:stopAllActions()
	self.animStartTime = os.time()
	self.animDuration = display.getAnimationCache("skill2"):getDuration()
	transition.playAnimationOnce(self,display.getAnimationCache("jump"))
	self:runAction(cc.JumpBy:create(0.7,cc.p(0,0),140,1))
	if self.paral ~= nil then
		transition.execute(self.paral,cc.JumpBy:create(0.7,cc.p(0,0),70,1))
	end
end
function Hero:skill1()
	self:stopAllActions()
	self.animStartTime = os.time()
	self.animDuration = display.getAnimationCache("skill1"):getDuration()
	transition.playAnimationOnce(self,display.getAnimationCache("skill1"))
	transition.execute(self,cc.MoveBy:create(0.5,cc.p(50*self.moveDirection,0)))
end
function Hero:skill2()
	self:stopAllActions()
	self.animStartTime = os.time()
	self.animDuration = display.getAnimationCache("skill2"):getDuration()
	transition.playAnimationOnce(self,display.getAnimationCache("skill2"))
	transition.execute(self,cc.MoveBy:create(1,cc.p(200*self.moveDirection,0)))
end
function Hero:skill3()
	self:stopAllActions()
	self.animStartTime = os.time()
	self.animDuration = display.getAnimationCache("skill2"):getDuration()
	display.getAnimationCache("skill3"):setDelayPerUnit(0.05)
	transition.playAnimationOnce(self,display.getAnimationCache("skill3"))
	local dis = 0
	if self:getPositionX() <= 350 then
		dis = self:getPositionX() - 10
	elseif self:getPositionX() <= 580 then
		dis = 350
	else
		dis = 890 - self:getPositionX() 
	end
		transition.execute(self,cc.MoveBy:create(0.25,cc.p(dis*self.moveDirection,0)))
end
function Hero:idle2()
	-- body
	self:stopAllActions()
	transition.playAnimationForever(self,display.getAnimationCache("idleR2"))
end
function Hero:move()

	local heroPosXLast = self:getPositionX()
	local heroPosYLast = self:getPositionY()
	if self:getPositionX()+self.moveStep <= 10 or self:getPositionX()+self.moveStep >=890 then
		self:setPosition(self:getPositionX(),self:getPositionY())
	else
		self:setPosition(self:getPositionX()+self.moveStep,self:getPositionY())
	end
	if self.paral ~= nil then
		local heroPosXNow = self:getPositionX()
		local heroPosYNow = self:getPositionY()

		local offsetX = heroPosXNow - heroPosXLast
		local offsetY = heroPosYNow - heroPosYLast
		if(self.paral:getPositionX()+offsetX <=0 or self.paral:getPositionX() + offsetX >=470) then
			self.paral:setPosition(self.paral:getPositionX(),self.paral:getPositionY())
		else
			self.paral:setPosition(self.paral:getPositionX()+offsetX,self.paral:getPositionY()+offsetY)
		end
	end
	--print("x:".. self:getPositionX() .. " y:" .. self:getPositionY())
end
function Hero:moveLeft()

	self:playAnimationForever(display.getAnimationCache("moveR"))
	self:changeFaceDire(-1)
end
function Hero:moveRight()

	transition.playAnimationForever(self,display.getAnimationCache("moveR"))
	self:changeFaceDire(1)
end
function Hero:addStateMachine()
	self.fsm ={}
	cc(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()

	self.fsm:setupState({
		initial = "idle",
		events = {
			{name = "Gongji",from={"idle","moveL","moveR"},to="attack"},
			{name = "Jineng1",from={"idle","moveL","moveR"},to="skill1"},
			{name = "Jineng2",from={"idle","moveL","moveR"},to="skill2"},
			{name = "Jineng3",from={"idle","moveL","moveR"},to="skill3"},
			{name = "Kongxian",from={"attack","skill1","skill2","skill3",
			"getattack","jump","moveL","moveR"},to="idle"},
			{name = "Tiaoyue",from="idle",to="jump"},
			{name = "YidongL",from="idle",to="moveL"},
			{name = "YidongR",from="idle",to="moveR"},
			{name = "Githit",from={"idle","moveL","moveR"},to="attacked"},
			{name = "Siwang",from={"idle","moveL","moveR","attack","attacked"},to="dead"}
		},
		callbacks = {

			onenterattack = function (event)
				self:attack()
			end,
			onenterskill1 = function (event)
				self:skill1()
			end,
			onenterskill2 = function (event)
				self:skill2()
			end,
			onenterskill3 = function (event)
				self:skill3()
			end,
			onenteridle = function (event)
				self:idle()
			end,
			onenterjump = function (event)
				self:jump()
			end,
			onentermoveL = function (event)
				self:moveLeft()
			end,
			onentermoveR = function (event)
				self:moveRight()
			end,
			onenterattacked = function (event)
				self:getHit()
			end
		}
	})
end
function Hero:heroDoEvent(event)
	self.fsm:doEvent(event)

end
function Hero:heroCanDoEvent(event)
	return self.fsm:canDoEvent(event)
end
function Hero:updateFSM()
	local state = self.fsm:getState()
	if state ~= "idle" and not self:isBusy() and self:heroCanDoEvent("Kongxian") then
		if state ~= "moveL" and state ~= "moveR" then
			self:heroDoEvent("Kongxian")
		end
	end
	if state == "moveL" or state == "moveR" then
		self:move()
	end
end
function Hero:updateHit()
	local state = self.fsm:getState()
	if state=="attack" or state=="skill1" or state=="skill2" or state=="sill3" then
		for i,v in ipairs(_G.enemys) do
			if cc.rectIntersectsRect(_G.hero:getBoundingBox(),v:getBoundingBox()) then
				v:getHit()
			end
		end
	end
end
function Hero:updateSelf()
	self:updateHit()
	self:updateFSM()
	self:updateBar()
end
function Hero:updateBar()
	-- body
	if self.hpBar then
		if self.health < 0 then
			self.health = 0
		end
		self.hpBar:setPercentage(self.health)
	end
end

return Hero