local Hero = class("Hero", function()
	return require("Role").new()
end)
EventManager = require("EventManager")
Hero.paral = nil
Hero.mpBar = nil
Hero.expBar = nil
Hero.lvlLabel = nil
Hero.mana = 100
Hero.expTop = 100
Hero.exp = 0
Hero.weapon = nil
Hero.clothes = nil
Hero.pants = nil

function Hero:ctor()
	GameData = GameState.load()
	self.level = GameData.level or 1
	self.exp = GameData.currentExp or 0
	self.expTop = self.level*100
	self.roleType = 1
	self.health = 100*self.level/2
	self.healthTop = self.health
	self.gethitNum = 0
	self.moveDirection = 1
	self.Atk = 50
	self:addStateMachine()
	--添加监听
	self:addEventListener()
	self:sendMsg("HERO_MSG",{["level"]=self.level})
end
function Hero:initHero()
	
end
function Hero:addEventListener()
	EventManager:addEventListener("ACTION",handler(self,self.getMsgFromeCtrl))
	EventManager:addEventListener("ENEMY_MSG",handler(self,self.getMSGFromEnemy))
end
function Hero:sendMsg(name,table)
	EventManager:pushEvent(name,table)
end
function Hero:getMsgFromeCtrl(event)
	--print("msg: " .. event.data["action"])
	if not event.data["action"] then
		print("action null")
		return
	elseif event.data["action"] == "YidongL" or 
		event.data["action"] == "YidongR" or 
		event.data["action"] == "YidongU" or 
		event.data["action"] == "YidongD" then

		self.moveStepX = event.data["moveStepX"] or 0
		self.moveStepY = event.data["moveStepY"] or 0
		self:heroDoEvent(event.data["action"])
	else
		self:heroDoEvent(event.data["action"])
	end
end
function Hero:getMSGFromEnemy(event)
	if event.data["damage"] then
		self.gethitNum = event.data["damage"]
		self:heroDoEvent("Githit")
	elseif event.data["enemy_dead"] == 1 then
		self:addExp(event.data["exp"])
	end
end
function Hero:addExp(exp)
	self.exp = self.exp+exp
	if self.exp >=self.expTop then
		self.exp = self.exp - self.expTop
		self.expTop = self.expTop*2
		self.level = self.level+1
		GameData.level = self.level
		--GameState.save(GameData)
		EventManager:dispatchEvent({name="HERO_MSG",data={["level"]=self.level}})
		print("Hero Level: " .. self.level)
	end
	GameData.currentExp = self.exp
	GameState.save(GameData)
end
function Hero:jump()
	local animate = cc.Animate:create(display.getAnimationCache("jump"))
	transition.execute(self, animate, {
		onComplete = function ()
			self:heroDoEvent("Kongxian")
		end
    })
	self:runAction(cc.JumpBy:create(0.7,cc.p(0,0),140,1))
	
end
function Hero:attack()

	local animate = cc.Animate:create(display.getAnimationCache("hit"))
	transition.execute(self, animate, {
		onComplete = function ()
			self:heroDoEvent("Kongxian")
		end
    })
end
function Hero:skill1()
	self:stopAllActions()
	
	local animate = cc.Animate:create(display.getAnimationCache("skill1"))
	transition.execute(self, animate, {
		onComplete = function ()
			self:heroDoEvent("Kongxian")
		end
    })
end
function Hero:skill2()

	local animate = cc.Animate:create(display.getAnimationCache("skill2"))
	local spawn = cc.Spawn:create(animate,
		cc.MoveBy:create(0.5,cc.p(150*self.moveDirection,0)))
	
	transition.execute(self, spawn, {
		onComplete = function ()
			self:heroDoEvent("Kongxian")
		end
    })
end
function Hero:skill3()
	local animate = cc.Animate:create(display.getAnimationCache("skill3"))
	transition.execute(self, animate, {
		onComplete = function ()
			self:heroDoEvent("Kongxian")
		end
    })
	local dis = 0
	if self:getPositionX() <= 350 then
		dis = self:getPositionX() - 10
	elseif self:getPositionX() <= 2100 then
		dis = 350
	else
		dis = 2450 - self:getPositionX() 
	end
	transition.execute(self,cc.MoveBy:create(0.25,cc.p(dis*self.moveDirection,0)))
end
function Hero:idle2()
	-- body
	self:stopAllActions()
	transition.playAnimationForever(self,display.getAnimationCache("idleR2"))
end
function Hero:move()
	if self:getPositionX()+self.moveStepX <= 10 or self:getPositionX()+self.moveStepX >=2490 then
		self:setPosition(self:getPositionX(),self:getPositionY())
	elseif self:getPositionY() + self.moveStepY <=150 or self:getPositionY()+self.moveStepY >=370 then
		self:setPosition(self:getPositionX(),self:getPositionY())
	else
		self:setPosition(self:getPositionX()+self.moveStepX,self:getPositionY()+self.moveStepY)
	end
end
function Hero:getHit()
	self:stopAllActions()
	print("----hero gethit----")
	local animation = display.getAnimationCache("gethit")
	animation:setDelayPerUnit(0.3)

	self:costHp(self.gethitNum)

	if self.health >0 then
		local animate = cc.Animate:create(animation)
		transition.execute(self, animate, {
			onComplete = function ()
				self:heroDoEvent("Kongxian")
			end
		})
	end
end
function Hero:costHp(damage)
	--战斗伤害文本
	local label = BloodText:createText(""..self.gethitNum)
  	if self:getScaleX() < 0 then
  		label:setScaleX(-1)
  	end
  	self:addChild(label)
  	--扣血
  	self.health = self.health-self.gethitNum

  	if self.health <= 0 then

  		transition.execute(self, cc.Blink:create(1,4), {
			onComplete = function ()
				--游戏结束
				local pauselayer = require("PauseLayer").new({
                btnGoOn = function()
                    print("game over")
                    display.resume()
                    display.replaceScene(require("SelectScene").new())
                end
                })
            display.getRunningScene():addChild(pauselayer)
			end
    	})
  	end
end
function Hero:addStateMachine()
	self.fsm ={}
	cc(self.fsm):addComponent("components.behavior.StateMachine"):exportMethods()

	self.fsm:setupState({
		initial = "idle",
		events = {
			{name = "Gongji",from={"idle","moveL","moveR","moveU","moveD"},to="attack"},
			{name = "Jineng1",from={"idle","moveL","moveR","moveU","moveD"},to="skill1"},
			{name = "Jineng2",from={"idle","moveL","moveR","moveU","moveD"},to="skill2"},
			{name = "Jineng3",from={"idle","moveL","moveR","moveU","moveD"},to="skill3"},
			{name = "Kongxian",from={"attack","skill1","skill2","skill3",
			"attacked","jump","moveL","moveR","moveD","moveU"},to="idle"},
			{name = "Tiaoyue",from="idle",to="jump"},
			{name = "YidongL",from={"idle","moveR","moveU","moveD"},to="moveL"},
			{name = "YidongR",from={"idle","moveL","moveU","moveD"},to="moveR"},
			{name = "YidongU",from={"idle","moveL","moevD","moveR"},to="moveU"},
			{name = "YidongD",from={"idle","moveL","moveR","moveU"},to="moveD"},
			{name = "Githit",from={"idle","moveL","moveR","moveU","moveD","attack","attacked"},to="attacked"},
			{name = "Siwang",from={"idle","moveL","moveR","moveU","moveD","attack","attacked"},to="dead"}
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
			onentermoveU = function (event)
				self:moveUp()
			end,
			onentermoveD = function (event)
				self:moveDown()
			end,
			onenterattacked = function (event)
				self:getHit()
			end
		}
	})
end
function Hero:heroDoEvent(event)
	if self.fsm:canDoEvent(event) then
		self.fsm:doEvent(event)
	end
end
function Hero:updateFSM()
	local state = self.fsm:getState()
	if state == "moveL" or state == "moveR" or state == "moveU"or state == "moveD"  then
		self:move()
	elseif state=="attack" or state=="skill1" or state=="skill2" or state=="sill3" then
		for i,v in ipairs(_G.enemys) do
			if cc.rectIntersectsRect(self:getBoundingBox(),v:getBoundingBox()) 
			and v:getPositionY() <= self:getPositionY()+5 
			and v:getPositionY() >= self:getPositionY()-5  then
				self:sendMsg("HERO_MSG",{["damage"]=self.Atk})
				v:enemyDoEvent("Githit")
			end	
		end
	end
end
function Hero:updateSelf()
	self:updateFSM()
	self:updateBar()
end
function Hero:updateBar()
	-- body
	if self.hpBar then
		if self.health < 0 then
			self.health = 0
		end
		self.hpBar:setPercentage(self.health/self.healthTop*100)
	end
	if self.expBar then
		self.expBar:setPercentage(self.exp/self.expTop*100)
	end
	if self.lvlLabel then
		self.lvlLabel:setString(self.level.."")
	end
end

return Hero