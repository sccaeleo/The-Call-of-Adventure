local Class = require "libs.hump.class"
local Tile = require "src.game.tiling.Tile"

local Tileset = Class{}
function Tileset:init(img, tilesize)
    self.tileImage = img -- tileset image
    self.tileSize = tilesize -- size of the tiles 
    
    -- the number of rows & cols this tileset has
    self.rowCount = self.tileImage:getHeight() / self.tileSize
    self.colCount = self.tileImage:getWidth() / self.tileSize
    
    self.tiles = {} -- store the tiles as a dictionary/table
    self:createTiles()
end

function Tileset:createTiles() -- converts img to dict of tiles
    local index = 1
    for row = 1, self.rowCount do
        for col = 1, self.colCount do
            self.tiles[index] = self:newTile(row,col,index)  
            index = index + 1 
        end -- end for col
    end -- end for row
end

function Tileset:newTile(row,col, index)
    local q = love.graphics.newQuad(
        (col-1)*self.tileSize, -- x
        (row-1)*self.tileSize, -- y
        self.tileSize,self.tileSize,self.tileImage)
        -- width, height, image/texture
    return Tile(index, q)
end

function Tileset:get(index)
    return self.tiles[index]
end

function Tileset:getImage()
    return self.tileImage
end

function Tileset:setNotSolid(tilelist) -- tilelist parameter is passed as {1,2,23,30,37}
    for i,tid in pairs(tilelist) do
        if self.tiles[tid] then -- if tile exists
            self.tiles[tid].solid = false -- not solid
        end
    end 
end

return Tileset