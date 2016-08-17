cc.FileUtils:getInstance():addSearchPath("src/")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end) 
function loadAnimation(fileplist,filename)
    -- body
    display.addSpriteFrames("res.plist", "res.png")

    local animations = {"moveR","hit","jump","skill1","dead","idleR","idleR2","skill2","skill3"}
    local animFrameNum = {6,8,10,8,10,4,8,16,10}
    for i =1, #animations do
        local frames = display.newFrames(animations[i].."_%d.png",1,animFrameNum[i])
        local animation = display.newAnimation(frames,0.1)

        display.setAnimationCache(animations[i],animation)
    end   
    local frames = display.newFrames("dead_%d.png", 1, 3)
    local animation = display.newAnimation(frames, 0.1)
    display.setAnimationCache("gethit", animation)
end

function MainScene:ctor()
	local  size = cc.Director:getInstance():getWinSize()
    
    loadAnimation("res.plist", "res.png")
    cc.ui.UILabel.new({
            UILabelType = 2, text = "Main Scene", size = 32})
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self)
    

    local menuitemHelp = cc.MenuItemFont:create("Help")
    menuitemHelp:setPosition(size.width*0.7,size.height/3)
    --self:addChild(menuitem)
    menuitemHelp:registerScriptTapHandler(function ()
        print("Tap Help")
    end)
     local menuitemStart = cc.MenuItemFont:create("Start")
    menuitemStart:setPosition(size.width*0.3,size.height/3)
    --self:addChild(menuitem)
    menuitemStart:registerScriptTapHandler(function ()
        --local scene = require("PlayScene").new()
        local scene = require("SelectScene").new()
        display.replaceScene(scene)
    end)
    local menu = cc.Menu:create(menuitemHelp,menuitemStart)
    menu:setPosition(0,0)
    self:addChild(menu)


end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
