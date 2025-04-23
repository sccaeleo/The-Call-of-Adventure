local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local GameObject = require "src.game.objects.GameObject"

local spriteSkeleton = love.graphics.newImage("graphics/npc/Skeleton-Sheet.png")

local gridSkeleton = Anim8.newGrid(32,32,spriteSkeleton:getWidth(),spriteSkeleton:getHeight())
local animSkeleton = Anim8.newAnimation(gridSkeleton("1-2",1) ,0.1)

local Skeleton = Class{__includes = GameObject}
function Skeleton:init(type) GameObject:init()
    self.name = "skeleton"
    self.type = type
    self.sprite = spriteSkeleton
    self.animation = animSkeleton:clone()
    self.collectible = true
    self.enemy = true

    self:setType(type)
end

function Skeleton:setType(type)
    if type == "skeleton" then
        self.type = "skeleton"
        self.sprite = spriteSkeleton
    end
end


return Skeleton