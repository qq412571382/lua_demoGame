BloodText = class("BloodText", function ()
	return display.newNode()
end)


function BloodText:createText(num)
	-- body
	local text = BloodText.new()
	text:init(num)
	text:startAnimation()
	return text
end
function BloodText:init(num)
	display.newTTFLabel({text=num ,font = "Arial",size = 40,align = cc.TEXT_ALIGNMENT_CENTER,color=cc.c3b(255, 0, 0)})
	:addTo(self)
end
function BloodText:startAnimation()
	-- body
	local sequence = cc.Sequence:create(cc.MoveBy:create(0.6,cc.p(0,70)),
		cc.CallFunc:create(function ()
			self:removeFromParent()
		end))
	self:runAction(sequence)
end