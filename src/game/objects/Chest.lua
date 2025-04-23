local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local GameObject = require "src.game.objects.GameObject"

local spriteChest = love.graphics.newImage("graphics/objects/Chest.png")


local Chest = Class{__includes = GameObject}
function Chest:init(type) GameObject:init()
    self.name = "chest"
    self.type = type 
    self.sprite = spriteChest
    self.collectible = true

    self:setType(type)
end

function Chest:setType(type)
    if type == "chest" then
        self.type = "chest"
        self.sprite = spriteChest
    end
end

return Chest