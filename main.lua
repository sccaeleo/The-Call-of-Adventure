-- Authors: Victoria Shelton & Tim Hunt

local Globals = require "src.Globals"
local Push = require "libs.push"
local Player = require "src.game.Player"
local Camera = require "libs.sxcamera"
local HUD = require "src.game.HUD"
local Skeleton = require "src.game.enemy.Skeleton"
local Sounds = require "src.game.Sounds"

function love.load()
    love.window.setTitle("The Call of Adventure")
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})
    math.randomseed(os.time()) -- RNG setup for later
    titleFont = love.graphics.newFont("fonts/Kaph-Regular.ttf",26)
    Class = "Wizard"

    
    Sounds["music_dungeon_passive"]:play()
    skeleton = Skeleton(0,0, "Skeleton")
    player = Player(0,0, Class)
    hud = HUD(player,skeleton)

    camera = Camera(gameWidth/2,gameHeight/2,
        gameWidth,gameHeight)
    camera:setFollowStyle('TOPDOWN')

    stagemanager:setPlayer(player)
    stagemanager:setCamera(camera)
    --stagemanager:setStage(1)
    
    stagemanager:setStage(0)
    gameState = "title"

end

function love.resize(w,h)
    Push:resize(w,h) -- must called Push to maintain game resolution
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "F2" or key == "tab" then
        debugFlag = not debugFlag
    
    elseif gameState=="title" and key == "return" then
        gameState = "roam"
        stagemanager:setStage(0)

    elseif gameState == "complete" and key == "return" then
        gameState = "title"
    elseif gameState == "roam" and key == "i" then
        gameState = "battle"

    elseif gameState == "end" and key == "return" then
        gameState = "title"
        player:reset()
        stagemanager:setStage(0)
    
    

    else
        if gameState == "battle" then
            hud:keypressed(key)
        end
        player:keypressed(key)
    end
end

function love.update(dt)
    if gameState == "roam" then
        stagemanager:currentStage():update(dt)
        player:update(dt, stagemanager:currentStage())

        camera:update(dt)
        camera:follow(
            math.floor(player.x+48), math.floor(player.y))
    elseif  gameState == "battle" then
        hud:update(dt)
    end
end

function love.draw()
    Push:start()

    -- Title Screen
    if gameState == "title" then
        drawTitleState()
    -- When player is moving around in dungeon
    elseif gameState == "roam" then
        drawRoamState()
    
    -- When player battles
    elseif gameState == "battle" then
        player:setDirection("r")
        drawBattleState()

    -- When player dies/loses
    elseif gameState == "end" then
        skeleton.CurrentHp = skeleton.health
        player.CurrentHp = player.health
        drawEndState()

    -- When game is won
    elseif gameState == "complete" then
        skeleton.CurrentHp = skeleton.health
        player.CurrentHp = player.health
        drawStageCompleteState()

    -- Error
    else
        love.graphics.setColor(1,1,0)
        love.graphics.printf("Error", 0,20,gameWidth,"center")
    end

    Push:finish()
end

-- Title Screen
function drawTitleState()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    stagemanager:currentStage():draw()
    camera:detach()

    love.graphics.setColor(1,1,1)
    love.graphics.printf("The Call of Adventure", titleFont,0,80,gameWidth,"center")
    love.graphics.printf("Press enter to start!", 0,150,gameWidth,"center")
end

function drawRoamState()

    stagemanager:currentStage():drawBg()

    camera:attach()

    stagemanager:currentStage():draw()
    player:draw()
    
    camera:detach()
end

function drawBattleState()
    stagemanager:currentStage():drawBg()
    camera:attach()
    player:drawBattleState()
    skeleton:drawBattleState()
    camera:detach()
    hud:draw()
end

-- Game Over Screen
function drawEndState()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    stagemanager:currentStage():draw()
    camera:detach()

    love.graphics.setColor(1,0,0,1)
    love.graphics.printf("Game Over", titleFont,0,80,gameWidth,"center")
    love.graphics.printf("Press any key to restart", 0,150,gameWidth,"center")
end

function drawStageCompleteState()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    stagemanager:currentStage():draw()
    camera:detach()

    -- Set to green
    love.graphics.setColor(0,1,0)
    love.graphics.printf("You Win!", titleFont,0,80,gameWidth,"center")
    love.graphics.printf("Press any key to restart", 0,150,gameWidth,"center")

end