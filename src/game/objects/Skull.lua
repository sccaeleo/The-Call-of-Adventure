local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local GameObject = require "src.game.objects.GameObject"

local spriteSkull = love.graphics.newImage("graphics/objects/Skull.png")


local Skull = Class{__includes = GameObject}
function Skull:init(type) GameObject:init()
    self.name = "skull"
    self.type = type 
    self.sprite = spriteSkull
    self.collectible = false
    self.enemy = false

    self:setType(type)
end

function Skull:setType(type)
    if type == "skull" then
        self.type = "skull"
        self.sprite = spriteSkull
    end
end

return Skull