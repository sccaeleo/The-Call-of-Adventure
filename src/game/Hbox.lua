local Class = require "libs.hump.class"

local Hbox = Class{}
function Hbox:init(entity,ofX,ofY,width,height)
    self.entity = entity -- Player or Enemy (or anything with similar structure)
    self.offsetX = ofX -- offset on X based on the sprite
    self.offsetY = ofY -- offset on Y 
    self.width = width -- box width (end pos = x+offsetX+width)
    self.height = height -- box height
end

function Hbox:left()
    if self.entity.dir == "l" then --flip box 
        local animWidth, animHeight = self.entity:getDimensions()
        return self.entity.x+animWidth-self.offsetX-self.width
    else -- standard is right facing
        return self.entity.x+self.offsetX
    end
end

function Hbox:top()
    return self.entity.y+self.offsetY
end

function Hbox:right() 
    return self:left()+self.width
end

function Hbox:bottom()
    return self:top()+self.height
end

function Hbox:draw()
    if debugFlag then
        love.graphics.rectangle("line", self:left(), self:top(), self.width, self.height)
    end
end

function Hbox:collision(anotherHbox) --AABB collision between boxes
    --(obj1.x+obj1.width) >= obj2.x AND (obj2.x+obj2.width) >= obj1.x
    return self:right() >= anotherHbox:left() and anotherHbox:right() >= self:left()
    -- (obj1.y+obj1.height)>=obj2.y AND (obj2.y+obj2.height)>=obj1.y
    and self:bottom() >= anotherHbox:top() and anotherHbox:bottom() >= self:top()
end

return Hbox
