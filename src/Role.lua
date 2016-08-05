local Role = class("Role", function() 
	return display.newSprite("idleR_1.png")
end)
Role.moveStep = 3
Role.lockedEnemy = nil
function Role:ctor()
	-- body 
	self:scale(1.8)
	self:idle()
	--self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.move)) --cc.NODE_ENTER_FRAME_EVENT   for every frame
	--self:scheduleUpdate()
end
function Role:attack()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("hit"))
	transition.execute(self,cc.MoveBy:create(0.7,cc.p(0,0)),{
		onComplete = function ()
			self:idle()
		end
		})
	-- body
end
function Role:dead()
	self:stopAllActions()
	transition.playAnimationOnce(self,display.getAnimationCache("dead"))
	-- body
end
function Role:idle()
	-- body
	self:stopAllActions()
	display.getAnimationCache("idleR"):setDelayPerUnit(0.3)
	transition.playAnimationForever(self,display.getAnimationCache("idleR"))
end


return Role
