local Class = require "libs.hump.class"
local Tween = require "libs.tween"
local Stage = require "src.game.stages.Stage"

local StageManager = Class{}
function StageManager:init()
    self.createStage = {} -- stage creation function list
    self.index = 1 -- current stage index
    self.current = nil -- current instance of the stage
    self.player = nil -- reference to the player
    self.camera = nil -- reference to camera
end

function StageManager:currentStage()
    return self.current
end

function StageManager:setPlayer(player)
    self.player = player
end

function StageManager:setCamera(camera)
    self.camera = camera
end

function StageManager:nextStage()
    self:setStage(self.index+1)
end

function StageManager:prevStage()
    self:setStage(self.index-1)
end

function StageManager:setStage(index)
    if self:currentStage() then
        self:currentStage():stopMusic() -- stops music from previous stage
    end

    self.index = index
    self.current = self.createStage[self.index]() -- calls createS()
    -- self.current now has an instance of the stage

    self.player.x = self.current.initialPlayerX
    self.player.y = self.current.initialPlayerY
     
    self.camera:setBounds(0, 0, self:currentStage():getWidth(), self:currentStage():getHeight())
    self:currentStage():playMusic()
    return self:currentStage()
end

function StageManager:exitStage()
    -- setup animation/tweens for exiting stage
end


return StageManager