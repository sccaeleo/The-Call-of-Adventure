local Class = require "libs.hump.class"

local Tile = Class{}
function Tile:init(id, quad)
    self.id = id -- tile id
    self.quad = quad -- our tile “image” is a quad
    self.rotation = 0 -- no rotation
    self.flipHor = 1 -- horizontal flip, 1 = no flip
    self.flipVer = 1 -- vertical flip, 1 = no flip
    self.solid = true
    self.hidden = false
end

return Tile