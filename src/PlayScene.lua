PlayeScene = class("PlayeScene",function()
	return display.newScene("PlayeScene")
end )

require("BGLayer")
require("ItemBar")
require("ItemLayer")
require("UIDrag")
require("SelectScene")

FileHelper = require("FileHelper")

function PlayeScene:ctor(tab)
    _G.enemys = {}
    _G.heros = {}
    self.itemroot = nil
    self.itembar = nil
    self.itembag = nil
    self.equipbar =  nil
    self.guanqiaIdx = nil
    --
    self.guanqiaIdx = tab["state"]
    print("guanqiaIdx: "..self.guanqiaIdx)
    local layer= display.newNode()
    layer:addTo(self,0,111)
     -- 控制层
    local ctrllayer = require("CtrlLayer").new()
    self:addChild(ctrllayer)
    --背景层
    local bgLayer = BGLayer:createLayer(tab["bg"])
    layer:addChild(bgLayer,-1)

    layer:addChild(self:addHero(display.left+300,display.height/2))
    self:addEnemys(tab["enemyNum"], tab["enemyLvl"],layer)

    self:initScene()
end
function PlayeScene:onCleanup()
    _G.enemys = nil
    _G.heros = nil
    self.itemroot = nil
    self.itembar = nil
    self.itembag = nil
    self.equipbar = nil
    self:removeAllChildren()
    self:stopAllActions()
    print("playscene cleaup")
end
function PlayeScene:initScene()
    --初始化itembar
    self.itemroot = ItemBar.new()
    self.itemroot:initItemBar()
    self:addChild(self.itemroot)
   
   
    -- if #_G.heros >= 1 then
    --     _G.heros[1].paral = bgLayer.paralNode
    -- end
    self:schedule(function() self:update() end ,1/24)
    --UI
    self:initUI()
end
function PlayeScene:initUI()
    --暂停菜单
    local menuitemPause = cc.MenuItemFont:create("Pause")
    menuitemPause:setPosition(display.width,display.height)
    menuitemPause:registerScriptTapHandler(function ()
        if cc.Director:getInstance():isPaused() == false then 
            pauselayer = require("PauseLayer").new({
                btnGoOn = function()
                    display.resume()
                    pauselayer:removeFromParent()
                end
                })
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
function PlayeScene:addEnemys(num,lvl,layer)
    for i=1,num do
        local e = self:addEnemy(math.random(800,2500), display.height/2)
        layer:addChild(e)
        e.health = e.health*lvl
        e.Atk = e.Atk*lvl
        e.healthTop = e.health
    end
end
function PlayeScene:addEnemy(posx,posy)
    local role = require("Enemy").new()
    role:setPosition(posx,posy)
    --self:addChild(role)
    role.roleId = #_G.enemys + 1
   -- print(self.roleId)
    table.insert(_G.enemys,role)
   -- print(#_G.enemys)
   return _G.enemys[#_G.enemys]
end
function PlayeScene:addHero(posx,posy)
   
   
    local hero = require("Hero").new()
    hero:initHero()
    hero:setPosition(posx,posy)
    hero:setTag(333)

    --玩家状态UI
    local head = display.newSprite("playerwindow.png")
    head:scale(1.3)
    self:addChild(head)
    head:setAnchorPoint(cc.p(0,1))
    head:setPosition(display.left, display.height)

    hero.lvlLabel = display.newTTFLabel({text=""..hero.level,size=32})
    hero.lvlLabel:pos(head:getPositionX()+55, head:getPositionY()-55)
    self:addChild(hero.lvlLabel)

    hero.hpBar = self:addProgressBar("hppool.png", head:getPositionX()+head:getContentSize().width/2-30,head:getPositionY()-head:getContentSize().height*0.3)
    hero.mpBar = self:addProgressBar("manapool.png", head:getPositionX()+head:getContentSize().width/2-30,head:getPositionY()-head:getContentSize().height*0.8)
    hero.expBar = self:addProgressBar("hppool.png", head:getPositionX()+head:getContentSize().width/2-30,head:getPositionY()-head:getContentSize().height*1.2)
    hero.expBar:setPercentage(0)
    table.insert(_G.heros,hero)
    return hero
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
function PlayeScene:update()
    for i,v in ipairs(_G.enemys) do
        v:updateSelf()
    end
    for i,v in ipairs(_G.heros) do
        v:updateSelf()
    end
    if #_G.enemys == 0 then
        if cc.Director:getInstance():isPaused() == false then 
            local pauselayer = require("PauseLayer").new({
                btnGoOn = function()
                    print("game over")
                    display.resume()
                    local tab = FileHelper:getMapInfo()
                    tab[self.guanqiaIdx+1]["state"] = self.guanqiaIdx+1
                    FileHelper:writeMapInfo(tab)

                    display.replaceScene(require("SelectScene").new())
                end
                })
            self:addChild(pauselayer)
        end
    end
end
function PlayeScene:updateMapItem()
    if #_G.enemys < 1 then
        self:addEnemy(display.cx+300, display.height/5)
    end
end
return PlayeScene