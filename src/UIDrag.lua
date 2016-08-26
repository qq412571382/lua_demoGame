
UIDragItem = class("UIDragItem")
function UIDragItem:ctor(box)
	-- body
	--拖拽物
	self.dragObj = nil
	--拖拽盒
	self.dragBox = box
	--拖拽物类别
	self._group = -1
end
function UIDragItem:setGroup(group)
	self._group = group
end
function UIDragItem:getGroup()
	return self._group
end
function UIDragItem:setDragObj(obj)
	if obj then
		self.dragObj = obj

		self.dragBox:getParent():addChild(self.dragObj)
		self.dragObj:setLocalZOrder(3)
		self.dragObj:setPosition(self.dragBox:getPosition())
	elseif self.dragObj  then
		self.dragObj:removeFromParent()
		self.dragObj = nil
	end
end















--负责接收，并判断监听
UIDrag = class("UIDrag", function()
	return display.newNode()
end)

function UIDrag:ctor()
	self._dragItems = {}
	self._currentDragItem = nil
	self._currentDragObj = nil

	self._isOnBean = false
	self._beanPoint = cc.p(0,0)
	--print("contentsize: " self:getContentSize().width.."-"..self:getContentSize().height)
	self:setTouchSwallowEnabled(false)
	self:setTouchEnabled(true)
	self:setContentSize(cc.size(display.width,display.height))
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event)
		if event.name == "began" then
			if self:onTouchBegan(cc.p(event.x,event.y)) then
				return true
			end
			return false
		elseif event.name == "moved" then
			self:onTouchMoved(cc.p(event.x,event.y))
		elseif event.name == "ended" then
			self:onTouchEnded(cc.p(event.x,event.y))
		end
	end)
end
function UIDrag:addDragItem(box)
	local item = UIDragItem.new(box)
	self._dragItems[#self._dragItems+1] = item

	print("dragitem lenght: "..#self._dragItems)
	return self._dragItems[#self._dragItems]
end
function UIDrag:find(box)
	for i = 1,#(self._dragItems) do
        if(self._dragItems[i].dragBox==box)then
            return self._dragItems[i]
        end
    end
    return nil
end
function UIDrag:onTouchBegan(point)
	for i = 1, #(self._dragItems) do
        repeat
            local item = self._dragItems[i]
            local box = item.dragBox
            if cc.rectContainsPoint(box:getBoundingBox(),point) and item.dragObj then
            	if box:getParent():isVisible() then
            		print("in ontouchbegan")
            		self._currentDragObj = item.dragObj
            		self._currentDragItem = item
            		return true
           	 	end
           	 	return false
            end
        until true
    end
    return false
end
function UIDrag:onTouchMoved(point)
	self._currentDragObj:setPosition(point.x-self._currentDragObj:getContentSize().width/2,
		point.y-self._currentDragObj:getContentSize().height/2)
end
function UIDrag:onTouchEnded(point)
	for i = 1, #(self._dragItems) do
        local item = self._dragItems[i]
        local box = item.dragBox

        if cc.rectContainsPoint(box:getBoundingBox(), point) then
        	--若格子被占用，交换位置
        	if item.dragObj then
 				--self._currentDragObj:setPosition(self._currentDragItem.dragBox:getPosition())
 				if item:getGroup() == self._currentDragItem:getGroup() then
	 				self._currentDragObj:retain()
	 				item.dragObj:retain()
	 				local obj_before = self._currentDragObj
	 				local obj_now = item.dragObj
	 				self._currentDragItem:setDragObj(nil)
	 				item:setDragObj(nil)
	 				self._currentDragItem:setDragObj(obj_now)
	 				item:setDragObj(obj_before)
	 			else
	 				self._currentDragObj:setPosition(self._currentDragItem.dragBox:getPosition())
	 			end
 				break
 			--若背包不可见，不操作
 			elseif box:getParent():isVisible() then
 				if item:getGroup() == self._currentDragObj:getTag() or 
 					item:getGroup() == 999 then

           			self._currentDragObj:retain()
 					local obj = self._currentDragObj
 					self._currentDragItem:setDragObj(nil)
 					item:setDragObj(obj)
 					break
 				else
 					self._currentDragObj:setPosition(self._currentDragItem.dragBox:getPosition())
 				end
 			end
 		--未拖入框中，不操作
        elseif i == #(self._dragItems) then
            self._currentDragObj:setPosition(self._currentDragItem.dragBox:getPosition())
        end
    end
end
