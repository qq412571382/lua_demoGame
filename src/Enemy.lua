local Enemy = class("Enemy", function()
	return require("Role").new()
end)

Enemy.searchDistence = 300
function Enemy:ctor()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.enemyAI)) --cc.NODE_ENTER_FRAME_EVENT   for every frame
	self:scheduleUpdate()
end

function Enemy:moveLeft()
	self:playAnimationForever(display.getAnimationCache("moveR"))
	self:setPositionX(self:getPositionX() + 2)
end
function Enemy:moveRight()
	
end


function Enemy:searchHero(hero)
	if math.abs(hero:getPositionX()-self:getPositionX()) <  Enemy.searchDistence then
		if hero:getPositionX() > self:getPositionX() + 30 then 

		end
	end
end
function Enemy:enemyAI()
	
	self:searchHero(_G.hero)
end


return Enemy