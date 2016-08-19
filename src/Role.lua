require("BloodText")
local Role = class("Role", function() 
	return display.newSprite("idleR_1.png")
end)

EventManager = require("EventManager")
Role.moveStep = 3
Role.lockedEnemy = nil
Role.movdDirection = 1  -- 1:right -1:left
Role.healthTop = 100
Role.health = 100
Role.animStartTime = 0
Role.animDuration = 0
Role.hpBar = nil
Role.roleType = 0
Role.roleId = 0
Role.Atk = 5
Role.Def = 0
Role.level = 1
function Role:ctor()
	-- body 
	self:scale(1.8)
	self:idle()
end
function Role:attack()

	if self:isBusy() == false then
		self:stopAllActions()
		transition.playAnimationOnce(self,display.getAnimationCache("hit"))
		self.animStartTime = os.time()
		self.animDuration = display.getAnimationCache("hit"):getDuration()+0.1
	end
end
function Role:dead()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("dead"))
end
function Role:getHit(damage)
		
	if self:isBusy() == false then
		self:stopAllActions()
		transition.playAnimationOnce(self,display.getAnimationCache("gethit"))
		self.animStartTime = os.time()
		self.animDuration = display.getAnimationCache("gethit"):getDuration()
		self.health = self.health - damage
		
		local label = BloodText:createText(damage)
    	label:pos(self:getPosition())
    	display.getRunningScene():addChild(label)
		if self.health < 0 then
			if self.roleType == 0 then
				local delId = self.roleId
				table.remove(_G.enemys,self.roleId)
				self:removeFromParent()

				EventManager:dispatchEvent({name="OTHER",data={expadd=50}})

				for i,v in ipairs(_G.enemys) do
					if v.roleId > delId then
						v.roleId = v.roleId - 1
					end
				end
			end
		end
	end
end
function Role:idle()

		self:stopAllActions()
		display.getAnimationCache("idleR"):setDelayPerUnit(0.3)
		transition.playAnimationForever(self,display.getAnimationCache("idleR"))
end

function Role:changeFaceDire(direction)
	-- body
	self:setScaleX(direction)

	if direction == 1 then
		self.moveDirection = 1
	else
		self.moveDirection = -1
	end
	self:setScaleX(self.moveDirection*1.8)
end
function Role:isBusy()
	
	if os.time() - self.animStartTime >= self.animDuration then
		return false
	else
		return true
	end
end
return Role
