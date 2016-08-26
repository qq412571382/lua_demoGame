local Enemy = class("Enemy", function()
	return require("Role").new()
end)
EventManager = require("EventManager")
Enemy.searchDistence = 300
function Enemy:ctor()
	self.cd_time = 0
	self.hpBar = self:addHpBar()
	self.gethitNum = 0
	self:addStateMachine()
	self:addEventListener()
end
function Enemy:addEventListener()
	EventManager:addEventListener("HERO_MSG",handler(self, self.getMsgFromHero))
end
function Enemy:getMsgFromHero(event)
	if event.data["damage"] then
		self.gethitNum = event.data["damage"]
	end
end
function Enemy:getHit()
	self:stopAllActions()
	local animation = display.getAnimationCache("gethit")
	animation:setDelayPerUnit(0.3)

	self:costHp(self.gethitNum)

	if self.health > 0 then
		local animate = cc.Animate:create(animation)
		transition.execute(self, animate, {
			onComplete = function ()
				self:enemyDoEvent("Kongxian")
			end
		})
	end
	
end
function Enemy:costHp(damage)
	--战斗伤害文本
	local label = BloodText:createText(""..self.gethitNum)
  	if self:getScaleX() < 0 then
  		label:setScaleX(-1)
  	end
  	self:addChild(label)
  	--扣血
  	self.health = self.health-self.gethitNum

  	if self.health <= 0 then
  		--传消息给hero，敌人死亡
  		EventManager:pushEvent("ENEMY_MSG",
  			{["enemy_dead"]=1,["exp"]=60,["itemname"]="材料",["itemtype"]=999,
  			["posx"]=self:getPositionX(),["posy"]=self:getPositionY()-70})

  		--从场景移除自身
  		local delId = self.roleId
		
  		transition.execute(self, cc.Blink:create(1,4), {
			onComplete = function ()
				table.removebyvalue(_G.enemys, self)
				self:removeFromParent() 
			end
    	})
  	end
end
function Enemy:addStateMachine()
	self.fsm={}
	cc(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()
	self.fsm:setupState({
		initial = "idle",
		events = {
			{name="Gongji",from={"idle","moveL","moveR","moveU","moveD"},to="attack"},
			{name="Githit",from={"idle","moveL","moveR","attack","moveU","moveD","attacked"},to="attacked"},
			{name = "YidongL",from={"idle","moveR","moveU","moveD"},to="moveL"},
			{name = "YidongR",from={"idle","moveL","moveU","moveD"},to="moveR"},
			{name = "YidongU",from={"idle","moveL","moevD","moveR"},to="moveU"},
			{name = "YidongD",from={"idle","moveL","moveR","moveU"},to="moveD"},
			{name="Siwang",from={"idle","moveL","moveR","moveR","moveU","attack","attacked"},to="dead"},
			{name="Kongxian",from={"moveR","moveL","moveR","moveU","attack","attacked"},to="idle"}
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
			onentermoveL = function (event)
				self:moveLeft()
			end,
			onentermoveR = function (event)
				self:moveRight()
			end,
			onentermoveU = function (event)
				self:moveUp()
			end,
			onentermoveD = function (event)
				self:moveDown()
			end,
			onenterdead = function (event)
				self:dead()
			end
		}
	})
end
function Enemy:enemyDoEvent(event)
	if self.fsm:canDoEvent(event) then
		self.fsm:doEvent(event)
	end
end
function Enemy:enemyCanDoEvent(event)
	return self.fsm:canDoEvent(event)
end
function Enemy:enemyCanDoAction()
	local state = self.fsm:getState()

	if self.cd_time == 0 then
		if #_G.heros >=1 then
			self:enemyDoAction(cc.p(_G.heros[1]:getPositionX(),_G.heros[1]:getPositionY()))
		end
	else
		self.cd_time = self.cd_time -1
	end

	if state == "moveL" then
		self:setPositionX(self:getPositionX()-2)
	elseif state == "moveR" then
		self:setPositionX(self:getPositionX()+2)
	elseif state == "moveU" then
		if self:getPositionY() < 370 then
			self:setPositionY(self:getPositionY()+2)
		end
	elseif state == "moveD" then
		if self:getPositionY() > 150 then
			self:setPositionY(self:getPositionY()-2)
		end
	end
	if state == "attack" then
		if _G.heros[1] and cc.rectIntersectsRect(self:getBoundingBox(),_G.heros[1]:getBoundingBox()) 
			and self:getPositionY() <= _G.heros[1]:getPositionY()+5 
			and self:getPositionY() >= _G.heros[1]:getPositionY()-5  then
			
			EventManager:pushEvent("ENEMY_MSG",{["damage"]=self.Atk})
		end
	end
end
function Enemy:enemyDoAction(point)
	local distance = math.sqrt(math.pow(self:getPositionX()-point.x, 2)+
        math.pow(self:getPositionY()-point.y, 2))
	local state = self.fsm:getState()
	if distance <= 300 then
		if _G.heros[1]:getPositionX() > self:getPositionX() + 60 then
			self:enemyDoEvent("YidongR")
		elseif _G.heros[1]:getPositionX() < self:getPositionX() - 60 then
			self:enemyDoEvent("YidongL")
		elseif self:getPositionY() > _G.heros[1]:getPositionY()+5 then
			self:enemyDoEvent("YidongD")
		elseif self:getPositionY() < _G.heros[1]:getPositionY()-5 then
			self:enemyDoEvent("YidongU")
		else
			self:enemyDoEvent("Gongji")
			self.cd_time = 80
		end
	else
		local rand = math.random(1,16)
		if rand <=2 then
		 	self:enemyDoEvent("YidongR")
		 	self.cd_time = 10
		elseif rand <= 4 then
			self:enemyDoEvent("YidongL")
		 	self.cd_time = 10
		elseif rand <= 6 then
			self:enemyDoEvent("YidongU")
		 	self.cd_time = 10
		 elseif rand <= 8 then
			self:enemyDoEvent("YidongD")
		 	self.cd_time = 10
		else
			self:enemyDoEvent("Kongxian")
			self.cd_time = 20
		end
	end
end

function Enemy:updateSelf()
	self:updateBar()
	self:enemyCanDoAction()
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