require("BloodText")
local Role = class("Role", function() 
	return display.newSprite("idleR_1.png")
end)

EventManager = require("EventManager")
Role.moveStepX = 0
Role.moveStepY = 0
Role.lockedEnemy = nil
Role.movdDirection = 1  -- 1:right -1:left
Role.healthTop = 100
Role.health = 100
Role.animStartTime = 0
Role.animDuration = 0
Role.hpBar = nil
Role.roleType = 0
Role.roleId = 0
Role.Atk = 10
Role.Def = 0
Role.level = 1
function Role:ctor()
	-- body 
	self:scale(1.8)
	self:idle()
end
function Role:attack()
	self:stopAllActions()
	local animate = cc.Animate:create(display.getAnimationCache("hit"))
	transition.execute(self, animate, {
		onComplete = function ()
			self:enemyDoEvent("Kongxian")
		end
    })
end
function Role:dead()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("dead"))
end
function Role:idle()
		self:stopAllActions()
		display.getAnimationCache("idleR"):setDelayPerUnit(0.3)
		transition.playAnimationForever(self,display.getAnimationCache("idleR"))
end

function Role:moveLeft()
	self:stopAllActions()
	self:changeFaceDire(-1)
	self:playAnimationForever(display.getAnimationCache("moveR"))
end
function Role:moveRight()
	self:stopAllActions()
	self:changeFaceDire(1)
	self:playAnimationForever(display.getAnimationCache("moveR"))
end
function Role:moveDown()
	self:stopAllActions()
	transition.playAnimationForever(self,display.getAnimationCache("moveR"))
	--self:changeFaceDire(1)
end
function Role:moveUp()
	self:stopAllActions()
	transition.playAnimationForever(self,display.getAnimationCache("moveR"))
	--self:changeFaceDire(1)
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
return Role
