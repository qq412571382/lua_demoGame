ItemLayer = class("ItemLayer", function()

	return cc.Layer:create()

end)

function ItemLayer:ctor()
    self:setAnchorPoint(cc.p(0.5,0.5))
    --self:initItemBar()
    --self:initItemBag()
end
function ItemLayer:initItemBag()
    self.itemboxs = {}
    --添加背包背景
    local bagbg = display.newSprite("itembag.png")
    bagbg:setPosition(display.cx,display.cy)
    self:addChild(bagbg,-1)
    --添加触摸监听对象
    self.drag = UIDrag.new()
    self.drag:setTouchSwallowEnabled(false)
    self:addChild(self.drag)
    --添加item格子
    for i=1,5 do
        for j=1,6 do
            local box = self:createItemBox(i+(j-1)*5,
            cc.p(bagbg:getPositionX()+(i-4)*65+45,bagbg:getPositionY()+(j-4)*65-10))
            box:setTag(i+(j-1)*5)
            self:addChild(box,-3)
            self.drag:addDragItem(box)
            self.itemboxs[i+(j-1)*5] = box
        end
    end
    --self.drag:setContenSize(bagbg:getContentSize())
     --添加item
    local eq1=self:createItem("Knife")
    local eq2=self:createItem("Arm")
    --item放入item格子
    self.drag:find(self.itemboxs[1]):setDragObj(eq1)
    self.drag:find(self.itemboxs[2]):setDragObj(eq2)
end
function ItemLayer:createItemBox(text,point)
    local box = cc.LayerColor:create(cc.c4b(100,100,100,255),60,60)
    box:setPosition(point)
    local lab = display.newTTFLabel({text=text,color=cc.c3b(166, 166, 166),align=cc.ui.TEXT_ALIGN_CENTER,size=30})
    lab:setPosition(cc.p(box:getContentSize().width/2,box:getContentSize().height/2))
    box:addChild(lab)
    return box
end
function ItemLayer:createItem(text)
    local obj = cc.LayerColor:create(cc.c4b(55,55,55,255),60,60)
    --当作图片处理
    --obj:ignoreAnchorPointForPosition(false)
    local lab_o = display.newTTFLabel({text=text,color=cc.c3b(255,51,103),align=cc.ui.TEXT_ALIGN_CENTER,size=28})
    lab_o:setPosition(cc.p(obj:getContentSize().width/2,obj:getContentSize().height/2))
    obj:addChild(lab_o)
    return obj
end