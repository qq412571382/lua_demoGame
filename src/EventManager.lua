local EventManager = class("EventManager")

_eventM = nil

function EventManager:ctor()
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
end

function EventManager:pushEvent(event_name,msg)
	self:dispatchEvent({name = event_name,data = msg})
end

if _eventM == nil then
	_eventM = EventManager.new()
end

return _eventM