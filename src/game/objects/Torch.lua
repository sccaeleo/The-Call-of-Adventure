local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local GameObject = require "src.game.objects.GameObject"

local spriteTorch = love.graphics.newImage("graphics/objects/Torch-Sheet.png")

local gridTorch = Anim8.newGrid(16,16,spriteTorch:getWidth(),spriteTorch:getHeight())
local animTorch = Anim8.newAnimation(gridTorch("1-3",1) ,0.1)

local Torch = Class{__includes = GameObject}
function Torch:init(type) GameObject:init()
    self.name = "torch"
    self.type = type 
    self.sprite = spriteTorch
    self.animation = animTorch:clone()

    self:setType(type)
end

function Torch:setType(type)
    if type == "torch" then
        self.type = "torch"
        self.sprite = spriteTorch
    end
end


return Torch