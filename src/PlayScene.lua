PlayeScene = class("PlayeScene",function()
	return display.newScene("PlayeScene")
end )

require("CtrlLayer")
require("BGLayer")
require("ItemBar")
require("ItemLayer")
require("UIDrag")
require("SelectScene")


local size = cc.Director:getInstance():getWinSize()

function PlayeScene:ctor()
    self.t_data = {}
    _G.enemys = {}
    self.itemroot = nil
    self.drag = nil
    self.itembar = nil
    self.itembag = nil
    self.equipbar=  nil
    --test
    self:addHero(size.width/4,size.height/5)

    self:addEnemy(display.cx+200, display.height/5)
    self:addEnemy(display.cx+100, display.height/5)
    
    self:initScene()
end
function PlayeScene:initScene()
    --初始化itembar
    self.itemroot = ItemBar.new()
    self.itemroot:initItemBar()
    self:addChild(self.itemroot)
    -- 控制层
    local ctrllayer = CtrlLayer:createLayer(hero)
    self:addChild(ctrllayer)
    --背景层
    local bgLayer = BGLayer:createLayer()
    self:addChild(bgLayer,-1)
    hero.paral = bgLayer.paralNode
    self:schedule(function() self.updateRole() end ,1/24)
    --UI
    self:initUI()

end
function PlayeScene:initUI()
    --暂停菜单
    local menuitemPause = cc.MenuItemFont:create("Pause")
    menuitemPause:setPosition(size.width,size.height)
    menuitemPause:registerScriptTapHandler(function ()
        if cc.Director:getInstance():isPaused() == false then 
            local pauselayer = require("PauseLayer").new()
            self:addChild(pauselayer)
        end
    end)
    local menu = cc.Menu:create(menuitemPause)
    menuitemPause:setAnchorPoint(cc.p(1,1))
    menu:setPosition(0,0)
    self:addChild(menu)
    --背包按钮
    cc.ui.UIPushButton.new({normal="bagicon.png",pressed="bagicon.png"})
    :onButtonClicked(function ()
        if self.itembag == nil then

           local node = self.itemroot:initItemBag()
            node:setVisible(true)
            self.itembag = node
        elseif self.itembag:isVisible() then
            self.itembag:setVisible(false)
        else
            self.itembag:setVisible(true)
        end
    end)
    --装备栏按钮
    :pos(display.width/2+138, display.bottom+38)
    :addTo(self)
    cc.ui.UIPushButton.new({normal="skillicon.png",pressed="skillicon.png"})
    :onButtonClicked(function ()
        if self.equipbar == nil then

            local node = self.itemroot:initEquipBar()
            node:setVisible(true)
            self.equipbar = node
        elseif self.equipbar:isVisible() then
            self.equipbar:setVisible(false)
        else
            self.equipbar:setVisible(true)
        end
    end)
    :pos(display.width/2+173, display.bottom+38)
    :addTo(self)

end
function PlayeScene:addEnemy(posx,posy)
    local role = require("Enemy").new()
    role:setPosition(posx,posy)
    self:addChild(role)
    role.roleId = #_G.enemys + 1
   -- print(self.roleId)
    table.insert(_G.enemys,role)
   -- print(#_G.enemys)
end
function PlayeScene:addHero(posx,posy)
    --玩家状态UI
    local head = display.newSprite("playerwindow.png")
    head:scale(1.3)
    self:addChild(head)
    head:setAnchorPoint(cc.p(0,1))
    head:setPosition(display.left, display.height)

    local hero = require("Hero").new()
    hero:setPosition(posx,posy)
    hero:setTag(333)
    self:addChild(hero)
    hero.hpBar = self:addProgressBar("hppool.png", head:getPositionX()+head:getContentSize().width/2-30,head:getPositionY()-head:getContentSize().height*0.3)
    hero.mpBar = self:addProgressBar("manapool.png", head:getPositionX()+head:getContentSize().width/2-30,head:getPositionY()-head:getContentSize().height*0.8)
    _G.hero = hero

end
function PlayeScene:updateRole()
    _G.hero:updateSelf()
    for i,v in ipairs(_G.enemys) do
        v:updateSelf()
    end
end
function PlayeScene:addProgressBar(img,posx,posy)
    -- body

    local bar = display.newProgressTimer(img,display.PROGRESS_TIMER_BAR)
    bar:pos(posx,posy)
    bar:setAnchorPoint(cc.p(0,1))
    bar:setBarChangeRate(cc.p(1,0))
    bar:setMidpoint(cc.p(0,0))
    bar:setPercentage(100)

    self:addChild(bar)
    return bar
end

return PlayeScene
