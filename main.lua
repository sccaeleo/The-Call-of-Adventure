-- Authors: Victoria Shelton & Tim Hunt

local Globals = require "src.Globals"
local Push = require "libs.push"
local Sounds = require "src.game.Sounds"
local Player = require "src.game.Player"
local Camera = require "libs.sxcamera"
--local HUD = require "src.game.HUDimproved"

-- Sprites
local Wizard = "graphics/characters/wizard-Sheet.png"
local Ranger = "graphics/characters/ranger-Sheet.png"
local Paladin = "graphics/characters/paladin-Sheet.png"

function love.load()
    love.window.setTitle("The Call of Adventure")
    Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = false, resizable = true})
    math.randomseed(os.time()) -- RNG setup for later

    player = Player(0,0, Wizard)
    hud = HUD(player)

    camera = Camera(gameWidth/2,gameHeight/2,
        gameWidth,gameHeight)
    camera:setFollowStyle('TOPDOWN_TIGHT')

    stagemanager:setPlayer(player)
    stagemanager:setCamera(camera)
    --stagemanager:setStage(1)

    titleFont = love.graphics.newFont("fonts/Kaph-Regular.ttf",26)
    stagemanager:setStage(0)

end

function love.resize(w,h)
    Push:resize(w,h) -- must called Push to maintain game resolution
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "F2" or key == "tab" then
        debugFlag = not debugFlag
    end
end

function love.update(dt)
end

function love.draw()
    Push:start()

    Push:finish()
end

-- Title Screen
function drawTitle()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    stagemanager:currentStage():draw()
    camera:detach()

    love.graphics.setColor(0,1,0)
    love.graphics.printf("The Call of Adventure", titleFont,0,80,gameWidth,"center")
    love.graphics.printf("Press enter to start!", 0,150,gameWidth,"center")
end

-- Game Over Screen
function drawEnd()
    love.graphics.setColor(0.3,0.3,0.3)
    stagemanager:currentStage():drawBg()
    camera:attach()
    stagemanager:currentStage():draw()
    camera:detach()

    love.graphics.setColor(1,0,0,1)
    love.graphics.printf("Game Over", titleFont,0,80,gameWidth,"center")
    love.graphics.printf("Press any key to restart", 0,150,gameWidth,"center")
end