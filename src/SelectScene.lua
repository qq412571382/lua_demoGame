SelectScene = class("SelectScene", function ()
	return display.newScene("SeleceScene")
end)
FileHelper = require("FileHelper")
function SelectScene:ctor()
	
	self:initScene()
	self.selGuanqia = nil
	self.selGuanqiaIdx = nil
	self.canUnlock = nil
	dump(FileHelper:getMapInfo())
end

function SelectScene:initScene()
	self.layer = cc.LayerColor:create(cc.c4b(100,100,100,255),display.width,display.height)
	self.layer:setPosition(cc.p(0,0))--display.cx,display.cy
	self:addChild(self.layer)
	self:addPageView()

	local lab = display.newTTFLabel({text="选择关卡",color=cc.c3b(166, 166, 166),align=cc.ui.TEXT_ALIGN_CENTER,size=30})
    lab:setPosition(cc.p(display.cx,display.height-70))
    self:addChild(lab)
    self.lab2 = display.newTTFLabel({text="第1页",color=cc.c3b(166, 166, 166),align=cc.ui.TEXT_ALIGN_CENTER,size=30})
    self.lab2:setPosition(cc.p(display.cx,display.cy-50))
    self:addChild(self.lab2)
    local content = cc.LayerColor:create(cc.c4b(30,60,30,250))
	content:setContentSize(480,240)
	content:pos(display.left+60, display.bottom+10)
	self:addChild(content)

	local itemStart = cc.MenuItemFont:create("Start")
    itemStart:setPosition(display.width*0.8,display.height*0.3)
    itemStart:registerScriptTapHandler(function ()
        if self.selGuanqia then
        	if self.selGuanqia:getChildByTag(self.selGuanqiaIdx):getString() == "Locked" then
        		local act = cc.Sequence:create(cc.ScaleTo:create(0.1,1.4),cc.ScaleTo:create(0.1,1))
        		self.selGuanqia:getChildByTag(self.selGuanqiaIdx):runAction(act)
   			else
   				local tab = FileHelper:getGuanqiaInfo(self.selGuanqiaIdx)
   				--dump(tab)
            	local scene = require("PlayScene").new(tab)
            	display.replaceScene(scene)
        	end
        end
    end)
    local itemUnlock = cc.MenuItemFont:create("Unlock")
    itemUnlock:setPosition(display.width*0.7,display.height*0.3)
    itemUnlock:registerScriptTapHandler(function ()
    	local index = self.selGuanqiaIdx-1
    	if (self.selGuanqiaIdx == 1 or self.selGuanqiaIdx == self.canUnlock) and 
    		self.selGuanqia:getChildByTag(self.selGuanqiaIdx):getString()=="Locked" then
    		print("-----")
        	print(self.selGuanqia:getChildByTag(self.selGuanqiaIdx):setString(self.selGuanqiaIdx))
        	self.canUnlock = self.selGuanqiaIdx + 1

        	local tab = FileHelper:getMapInfo()
        	tab[self.selGuanqiaIdx]["state"]=self.selGuanqiaIdx
        	FileHelper:writeMapInfo(tab)
        elseif self.selGuanqia:getChildByTag(self.selGuanqiaIdx):getString() == "Locked" then
        	print("|||||")
        	local act = cc.Sequence:create(cc.ScaleTo:create(0.1,1.4),cc.ScaleTo:create(0.1,1))
        	self.selGuanqia:getChildByTag(self.selGuanqiaIdx):runAction(act)
        end
    end)
    local menu = cc.Menu:create(itemStart,itemUnlock)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu)
end
function SelectScene:addPageView()
	
	self.pv = cc.ui.UIPageView.new({
			viewRect = cc.rect(self.layer:getPositionX(),self.layer:getPositionY(),
				display.width,display.height),
			column = 4,row = 1,
			padding = {left = 60,right=60,top=1,bottom=300},
			columnSpace = 50,rowSpace = 50,bCirc = false})
		:onTouch(function (event)
			self.lab2:setString("第"..event.pageIdx.."页")
			if event.item then
				if self.selGuanqia then
					if event.item ~= self.selGuanqia then
						print("----")
						self.selGuanqia:scale(1)
						event.item:scale(1.2)
						self.selGuanqia = event.item
						self.selGuanqiaIdx = event.itemIdx
						--FileHelper:getGuanqiaInfo(self.selGuanqiaIdx)
					end
				else
					event.item:scale(1.2)
					self.selGuanqia = event.item
					self.selGuanqiaIdx = event.itemIdx
				end
			end
		end)
		:addTo(self)
	for i=1,12 do
		local item = self.pv:newItem()
		local content = cc.LayerColor:create(cc.c4b(30,60,30,250))
		content:setContentSize(160,240)
		content:setTouchEnabled(false)
		txt = FileHelper:getGuanqiaInfo(i)
		local lab = display.newTTFLabel({text=txt["state"],color=cc.c3b(166, 166, 166),align=cc.ui.TEXT_ALIGN_CENTER,size=30})
    	lab:setPosition(cc.p(content:getContentSize().width/2,content:getContentSize().height/2))
    	lab:setTag(i)
    	item:addChild(lab,1)
		item:addChild(content)
		self.pv:addItem(item)
	end
	self.pv:reload()

end
return SelectScene