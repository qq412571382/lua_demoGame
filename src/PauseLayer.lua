PauseLayer = class("PauseLayer", function ()
	return display.newLayer()
end)

function PauseLayer:ctor()

	display.pause()

	local popwin = display.newSprite("pop_pause_window.png")
	:pos(display.cx, display.cy)
	:addTo(self)
	:scale(2)
	cc.ui.UIPushButton.new({normal="pop_pause_btnJixu.png",pressed="pop_pause_btnJixu.png"})
	:scale(2)
	:onButtonPressed(function ()
		-- body
		print("popwindow Jixu pressed")
			display.resume()
			self:removeFromParent()
	end)
	:addTo(self)
	:setPosition(popwin:getPositionX()-60,popwin:getPositionY()-55)
	cc.ui.UIPushButton.new({normal="pop_pause_btnTuichu.png",pressed="pop_pause_btnTuichu.png"})
	:scale(2)
	:onButtonPressed(function ()
		-- body
		print("popwindow Tuichu pressed")
	end)
	:addTo(self)
	:setPosition(popwin:getPositionX()+60,popwin:getPositionY()-55)
end


return PauseLayer