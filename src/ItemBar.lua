ItemBar = class("ItemBar",function ()
	return cc.Layer:create()
end)

EventManager = require("EventManager")

function ItemBar:ctor()
	self:setAnchorPoint(cc.p(0.5,0.5))
	--self:initItemBar()
	--self:initItemBag()
	self.bag = nil
	self.bar = nil
    self.equip = nil
    self.items_in_map = {}
	self.drag = UIDrag.new()
	self.drag:setTouchSwallowEnabled(false)
	self:addChild(self.drag)
    self:setNodeEventEnabled(true)
    EventManager:addEventListener("ENEMY_MSG",handler(self,self.getMsgFromEnemy))

    self:schedule(function() self:update() end ,1/24)
end
function ItemBar:onCleanup()
    print("itembar oncleanup")
    self:writeItems2Fiel()

end
function ItemBar:getMsgFromEnemy(event)
    if event.data["enemy_dead"] then
        if event.data["itemname"] and event.data["itemtype"] then
            local i = self:createItem(event.data["itemname"])
            self.items_in_map[#self.items_in_map+1] = i
            i:pos(event.data["posx"], event.data["posy"])
            i:setTag(event.data["itemtype"])
            self:getParent():getChildByTag(111):addChild(i)
        end
    end
end
function ItemBar:getMsgFromHero(event)
    
end
function ItemBar:initItemBar()
	--添加item格子
	--local pos = self:getPosition()
    local box1 = self:createItemBox("1", cc.p(display.width/2-203,display.bottom+10))
    self:addChild(box1)
    local box2 = self:createItemBox("2", cc.p(display.width/2-138,display.bottom+10))
    self:addChild(box2)
    local box3 = self:createItemBox("3", cc.p(display.width/2-73,display.bottom+10))
    self:addChild(box3)
    local box4 = self:createItemBox("4", cc.p(display.width/2-8,display.bottom+10))
    self:addChild(box4)
    local box5 = self:createItemBox("5", cc.p(display.width/2+57,display.bottom+10))
    self:addChild(box5)
	--添加触摸监听对象
    -- self.drag = UIDrag.new()
    -- self.drag:setTouchSwallowEnabled(true)
    -- self:addChild(self.drag)
    self.drag:addDragItem(box1):setGroup(999)
    self.drag:addDragItem(box2):setGroup(999)
    self.drag:addDragItem(box3):setGroup(999)
    self.drag:addDragItem(box4):setGroup(999)
    self.drag:addDragItem(box5):setGroup(999)
    --添加item
    local eq1=self:createItem("裤子")
    eq1:setTag(3)
    local eq2=self:createItem("材料1")
    eq2:setTag(999)
    
    --item放入item格子
   -- self.drag:find(box1):setDragObj(eq1)
    --self.drag:find(box2):setDragObj(eq2)

    --添加itembar背景
    local bg = display.newSprite("itembar.png")
    :addTo(self)
    :pos(display.cx-5, box1:getPositionY()+30)
end
function ItemBar:initItemBag()
	self.itemboxs = {}
	--添加背包背景
    local node = cc.Node:create()
	local bagbg = display.newSprite("itembag.png")
	bagbg:setPosition(display.cx+250,display.cy+50)
	node:addChild(bagbg,-1)
	--添加触摸监听对象
	-- self.drag = UIDrag.new()
	-- self.drag:setTouchSwallowEnabled(false)
	-- self:addChild(self.drag)
	--添加item格子
	for i=1,6 do
		for j=1,5 do
			local box = self:createItemBox((i-1)*5+j,
			cc.p(bagbg:getPositionX()+(j-4)*65+45,bagbg:getPositionY()+(i-4)*65-10))
			node:addChild(box,1)
			self.drag:addDragItem(box):setGroup(999)
			self.itemboxs[(i-1)*5+j] = box
		end
	end
	--self.drag:setContenSize(bagbg:getContentSize())
	 --添加item
    local eq1=self:createItem("材料")
    eq1:setTag(999)
    local eq2=self:createItem("材料")
    eq2:setTag(999)

    --self.drag:find(self.itemboxs[1]):setDragObj(eq1)
   -- self.drag:find(self.itemboxs[2]):setDragObj(eq2)
    self:addChild(node)
    return node
end
function ItemBar:initEquipBar()

    local node = cc.Node:create()
    local bg = display.newSprite("equipwindow.png")
    bg:setPosition(display.cx-200,display.cy)
    node:addChild(bg,-1)
    local box1 = self:createItemBox("上装",
        cc.p(bg:getPositionX()+13,bg:getPositionY()+5))
    node:addChild(box1)
    local box2 = self:createItemBox("武器",
        cc.p(bg:getPositionX()-68,bg:getPositionY()-37))
    node:addChild(box2)
    local box3 = self:createItemBox("下装",
        cc.p(bg:getPositionX()+10,bg:getPositionY()-115))
    node:addChild(box3)

    self.drag:addDragItem(box1):setGroup(1)
    self.drag:addDragItem(box2):setGroup(2)
    self.drag:addDragItem(box3):setGroup(3)

    --test
    local eq1=self:createItem("衣服")
    eq1:setTag(1)
    local eq2=self:createItem("武器")
    eq2:setTag(2)
    --item放入item格子
    --self.drag:find(box1):setDragObj(eq1)
    --self.drag:find(box2):setDragObj(eq2)
    self:addChild(node)
    return node
end
function ItemBar:createItemBox(text,point)
    local box = cc.LayerColor:create(cc.c4b(100,100,100,255),60,60)
    box:setPosition(point)
    local lab = display.newTTFLabel({text=text,color=cc.c3b(166, 166, 166),align=cc.ui.TEXT_ALIGN_CENTER,size=30})
    lab:setPosition(cc.p(box:getContentSize().width/2,box:getContentSize().height/2))
    box:addChild(lab)
    return box
end
function ItemBar:createItem(text)
    local obj = cc.LayerColor:create(cc.c4b(55,55,55,255),60,60)
    --当作图片处理
    --obj:ignoreAnchorPointForPosition(false)
    local lab_o = display.newTTFLabel({text=text,color=cc.c3b(255,51,103),align=cc.ui.TEXT_ALIGN_CENTER,size=28})
    lab_o:setPosition(cc.p(obj:getContentSize().width/2,obj:getContentSize().height/2))
    obj:addChild(lab_o)
    return obj
end
function ItemBar:update()
    if self.items_in_map then
    for i=1,#self.items_in_map do
        local v = self.items_in_map[i]
        if cc.rectIntersectsRect(v:getBoundingBox(),
            _G.heros[1]:getBoundingBox()) then
            v:retain()
            v:removeFromParent()
            self:pickItem2Bag(v)
            table.removebyvalue(self.items_in_map,v)
            
        end
    end
    end
end
function ItemBar:initItems()
    local items = FileHelper:getBagInfo()
    for i,v in ipairs(items) do
        local item = nil
        if v["state"] ==1 then
            item = self:createItem("武器")
            item:setTag(1)
        elseif v["state"] == 2 then
            item = self:createItem("上装")
            item:setTag(2)
        elseif v["state"] == 3 then
            item = self:createItem("下装")
            item:setTag(3)
        elseif v["state"] == 999 then
            item = self:createItem("材料")
            item:setTag(999)
        end
        self.drag._dragItems[i]:setDragObj(item)
    end
end
function ItemBar:writeItems2Fiel()

    local tb = FileHelper:getBagInfo()

    for i,v in ipairs(self.drag._dragItems) do
        if v.dragObj then
            tb[i]["state"]=v.dragObj:getTag()
            print("items tag: "..v.dragObj:getTag())
            --FileHelper:wirteBagInfo(tb)
        end
    end
    FileHelper:wirteBagInfo(tb)
end
function ItemBar:pickItem2Bag(item)
    --寻找空闲格子
    for i = 1, #(self.drag._dragItems) do
        local di = self.drag._dragItems[i]
        if di.dragObj==nil and di:getGroup()==999 then
            --添加item到背包
            di:setDragObj(item)

            print("--add success--")
            break
        end
    end
end