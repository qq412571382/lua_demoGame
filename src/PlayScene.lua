PlayeScene = class("PlayeScene",function()
	return display.newScene("PlayeScene")
end )

require("CtrlLayer")
require("BGLayer")

local size = cc.Director:getInstance():getWinSize()
local function initScene()
	
	-- body
end
function PlayeScene:ctor()
    --test Hero
    local hero = require("Hero").new()
    hero:setPosition(size.width/4,size.height/2)
    hero:setTag(333)
    self:addChild(hero)
    _G.hero = hero
    local role1 = require("Enemy").new()
    role1:setPosition(size.width/5,size.height/5)
    self:addChild(role1)
    role1:setTag(111)
    local role2 = require("Enemy").new()
    role2:setPosition(size.width/2,size.height/5)
    self:addChild(role2)
    role2:setTag(222)
    _G.enemys = {}
    table.insert(_G.enemys, role2)
    table.insert(_G.enemys,role1)
    --control layer
    local ctrllayer = CtrlLayer:createLayer(hero)
    self:addChild(ctrllayer)
    --background layer
    local bgLayer = BGLayer:createLayer()
    self:addChild(bgLayer,-1)

    hero.paral = bgLayer.paralNode
  
end

return PlayeScene
