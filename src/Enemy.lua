local Enemy = class("Enemy", function()
	return require("Role").new()
end)

Enemy.searchDistence = 300
function Enemy:ctor()
	self.animStartTime = os.time()
	self.animDuration = 5
	self.hpBar = self:addHpBar()
	self:addStateMachine()
end

function Enemy:moveLeft()
	self:stopAllActions()
	self:changeFaceDire(-1)
	self:playAnimationForever(display.getAnimationCache("moveR"))
end
function Enemy:moveRight()
	self:stopAllActions()
	self:changeFaceDire(1)
	self:playAnimationForever(display.getAnimationCache("moveR"))
end
function Enemy:addStateMachine()
	self.fsm={}
	cc(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()
	self.fsm:setupState({
		initial = "idle",
		events = {
			{name="Gongji",from={"idle","moveL","moveR"},to="attack"},
			{name="Githit",from={"idle","moveL","moveR","attack"},to="attacked"},
			{name="YidongL",from={"idle","moveR"},to="moveL"},
			{name="YidongR",from={"idle","moveL"},to="moveR"},
			{name="Siwang",from={"idle","moveL","moveR","attack","attacked"},to="dead"},
			{name="Kongxian",from={"moveR","moveL","attack","attacked"},to="idle"}
		},
		callbacks={
			onenteridle = function (event)
				self:idle()
			end,
			onenterattack = function (event)
				self:attack()
			end,
			onenterattacked = function (event)
				self:getHit()
			end,
			onentermoveR = function (event)
				self:moveRight()
			end,
			onentermoveL = function (event)
				self:moveLeft()
			end,
			onenterdead = function (event)
				print("dead")
			end
		}
	})
end
function Enemy:enemyDoEvent(event)
	self.fsm:doEvent(event)
end
function Enemy:enemyCanDoEvent(event)
	return self.fsm:canDoEvent(event)
end
function Enemy:searchHero(hero)
	local state = self.fsm:getState()
	if state ~= "dead" and state ~= "attacked" then
		if math.abs(hero:getPositionX()-self:getPositionX()) <  Enemy.searchDistence then
			if hero:getPositionX() > self:getPositionX() + 40 then 
				if self:enemyCanDoEvent("YidongR") then
					self:enemyDoEvent("YidongR")
				end
			elseif hero:getPositionX() < self:getPositionX() - 40 then
				if self:enemyCanDoEvent("YidongL") then
					self:enemyDoEvent("YidongL")
				end
			else
				if self:enemyCanDoEvent("Gongji") then
					self:enemyDoEvent("Gongji")
				end
			end
		end
	end
end
function Enemy:enemyAI()
	for i,v in ipairs(_G.heros) do
		self:searchHero(v)
	end
	
end
function Enemy:updateSelf()
	self:enemyAI()
	self:updateFSM()
	self:updateBar()
end

function Enemy:updateFSM()
	local state = self.fsm:getState()
	if state == "moveR" then
		self:setPositionX(self:getPositionX() + 1)
	elseif state == "moveL" then
		self:setPositionX(self:getPositionX() - 1)
	end
	if state == "attack" then
		for i,v in ipairs(_G.heros) do
			if cc.rectIntersectsRect(self:getBoundingBox(),v:getBoundingBox()) then
				v:getHit(self.Atk)
			end
		end
		
	end
	if state~="idle" and not self:isBusy() and self:enemyCanDoEvent("Kongxian") then
		self:enemyDoEvent("Kongxian")
	end
end
function Enemy:updateBar()
	self.hpBar:setPercentage(self.health/self.healthTop*100)
	-- body
end
function Enemy:addHpBar()
	-- body
	print("int addbar")
    local bar = display.newProgressTimer("enemyhpbar.png",display.PROGRESS_TIMER_BAR)
    bar:pos(self:getPositionX(),self:getPositionY()+self:getContentSize().height+10) --head:getPositionX()+head:getContentSize().width+30,head:getPositionY()-head:getContentSize().height*0.3
    bar:setAnchorPoint(cc.p(0,1))
    bar:setBarChangeRate(cc.p(1,0))
    bar:setMidpoint(cc.p(0,0))
    bar:setPercentage(100)
    bar:setScaleX(0.5)
    self:addChild(bar)

    return bar
end

return Enemy