local Stage = require "src.game.stages.Stage"
local Tileset = require "src.game.tiling.DungeonTileset"
local Background = require "src.game.tiling.Background"
--local Skeleton = require "src.game.enemy.Skeleton"
local Sounds = require "src.game.Sounds"

local function createS0()
    local stage = Stage(20,30,Tileset)
    local mapdata = require "src.game.maps.Map1"
    stage:readMapData(mapdata)

    local objdata = require "src.game.maps.Map1Obj"
    stage:readObjectsData(objdata)

    -- Background
    local bg1 = Background("graphics/tileset/Background.png")

    stage:addBackground(bg1)

    -- Initial Player Pos
    stage.initialPlayerX = 1*16
    stage.initialPlayerY = 13*16 

    -- Enemies
    --local mob1 = Skeleton()
    --mob1:setCoord(22*16, 12*16)
    --stage:addMob(mob1)


    -- music
    --stage:setMusic(Sounds["music_dungeon_passive"])

    return stage
end

return createS0