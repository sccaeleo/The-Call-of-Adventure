local Class = require "libs.hump.class"

local Background = Class{}
function Background:init(strImagePath)
    self.img = love.graphics.newImage(strImagePath) -- bg image

    self.x = 0 -- if we add paralax scrolling
    self.y = 0 -- if we add paralax scrolling

    self.scaleX = 1 -- scaling
    self.scaleY = 1
end

function Background:draw()
    love.graphics.draw(self.img,self.x,self.y,0,self.scaleX,self.scaleY)
end
    
return Background
