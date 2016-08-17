RoleFSM = class("RoleFSM", function()
	-- body
	return display.newNode()
end)

RoleFSM._currentRole
function RoleFSM:createFSM(role)
	-- body
	local fsm = RoleFSM.new()

	fsm:init(role)

	return fsm
end

function RoleFSM:init(role)
	self._currentRole = role
	self:schedule(function() self:switchState(self._currentRole.tostate) end ,1/24)
end
function RoleFSM:switchState(state)
	if state == 1 then
		self._currentRole:idle()
	elseif state == 2 then
		self._currentRole:moveLeft()
	elseif state == 3 then
		self._currentRole:moveRight()
	elseif state == 4 then
		self._currentRole:jump()
	elseif state == 5 then
		self._currentRole:skill1()
	elseif state == 6 then
		self._currentRole:skill2()
	elseif state == 7 then
		self._currentRole:skill3()
	elseif state == 8 then	
		self._currentRole:dead()
	elseif state == 9 then
		self._currentRole:attack()
	elseif state == 10 then
		self._currentRole:getHit()
	end

	print("fsm test")
end
return RoleFSM