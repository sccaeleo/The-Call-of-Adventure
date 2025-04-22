local Tileset = require "src.game.tiling.Tileset"

local imgTileset = love.graphics.newImage("graphics/tileset/Dungeon.png")

local DungeonTileset = Tileset(imgTileset, 16)
DungeonTileset:setNotSolid({18})

return DungeonTileset