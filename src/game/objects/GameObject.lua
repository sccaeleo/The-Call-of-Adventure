local Class = require "libs.hump.class"

local GameObject = Class{}
function GameObject:init()
    self.x = 0
    self.y = 0
    self.name = ""
    self.type = nil

    self.row = 0 -- grid coordinates
    self.col = 0 

    self.sprite = nil
    self.animation = nil
end

function GameObject:update(dt)
    self.animation:update(dt)
end

function GameObject:draw()
    self.animation:draw(self.sprite, self.x, self.y)
end

function GameObject:getDimensions()
    self.animation:getDimensions()
end

function GameObject:setCoords(x,y,tilesize)
    self.x = x
    self.y = y
    self.col = 1+math.floor((x+tilesize-1)/tilesize) 
    self.row = 1+math.floor((y+tilesize-1)/tilesize)
end

function GameObject:setType(type)
    -- Must be re-implemented in subclasses
end

function GameObject:setRandomType()
    -- Must be re-implemented in subclasses
end

return GameObject
