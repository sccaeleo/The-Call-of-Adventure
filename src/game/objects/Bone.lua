local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local GameObject = require "src.game.objects.GameObject"

local spriteBone = love.graphics.newImage("graphics/objects/Bone.png")


local Bone = Class{__includes = GameObject}
function Bone:init(type) GameObject:init()
    self.name = "bone"
    self.type = type 
    self.sprite = spriteBone
    self.collectible = false
    self.enemy = false

    self:setType(type)
end

function Bone:setType(type)
    if type == "bone" then
        self.type = "bone"
        self.sprite = spriteBone
    end
end

return Bone