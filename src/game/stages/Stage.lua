local Class = require "libs.hump.class"
local Matrix = require "libs.matrix"
local objutil = require "src.game.objects.objutil"

local Stage = Class{}
function Stage:init(rows, cols, ts)
    self.tileset = ts -- tileset used in this map
    self.rowCount = rows
    self.colCount = cols

    self.initialPlayerY = 0
    self.initialPlayerX = 0

    self.music = nil -- this stage music
    self.mobs = {} -- mobs
    self.objects = {} -- game objects
    self.bgs = {} -- backgrounds
    self.map = Matrix:new(self.rowCount, self.colCount) -- map will be a matrix of tiles
end


function Stage:update(dt)
    for k=1, #self.objects do
        self.objects[k]:update(dt)
    end

    for k=#self.mobs, 1, -1 do 
        self.mobs[k]:update(dt, self)
        if self.mobs[k].died then
            table.remove(self.mobs, k)
        end
    end


end

function Stage:getWidth()
    return self.colCount * self:getTileSize()
end

function Stage:getHeight()
    return self.rowCount * self:getTileSize()
end

function Stage:getTileSize()
    return self.tileset.tileSize
end

function Stage:draw()
    for row = 1, self.rowCount do
        for col = 1, self.colCount do
            self:drawTile(row,col) 
        end -- end for col
    end -- end for row

    for k=1, #self.objects do
        self.objects[k]:draw()
    end

    for k=1, #self.mobs do 
        self.mobs[k]:draw()
    end
end

function Stage:drawTile(row,col)
    local curTile = self.map[row][col]
    if curTile then -- if not nil
        love.graphics.draw(self.tileset:getImage(), --img
            curTile.quad,  -- quad
            (col-1)*self:getTileSize(), -- x 
            (row-1)*self:getTileSize(),  -- y
            curTile.rotation, -- rotation (zero = no rotation)
            curTile.flipHor, --  no flip = 1, flipped = -1 
            curTile.flipVer)
    end
end

function Stage:addMob(aMob)
    table.insert(self.mobs, aMob)
end

function Stage:addBackground(background)
    table.insert(self.bgs, background)
end

function Stage:drawBg()
    for k=1, #self.bgs do
        self.bgs[k]:draw()
    end 
end

function Stage:readMapData(mapdata)
    local index = 1
    for row = 1, self.rowCount do
        for col = 1, self.colCount do
            if mapdata[index] == 0 then
                self.map[row][col] = nil
            else -- there is a tile
                self.map[row][col] = self.tileset:get(mapdata[index])
            end
            index = index +1
        end -- end for col
    end -- end for row
end

function Stage:toMapCoords(gameobject)
    local width, height = gameobject:getDimensions()
    local ts = self:getTileSize()

    local col1 = 1+math.floor( (gameobject.x+ts-1)/ts ) --left 
    local row1 = 1+math.floor( (gameobject.y+ts-1)/ts ) --top
    -- row1, col1 = top left corner
    local col2 = math.floor( (gameobject.x+width)/ts ) --right
    local row2 = math.floor( (gameobject.y+height)/ts )--bottom
    -- row2,col2 = bottom right corner
    
    return row1,col1,row2,col2
end

function Stage:rightCollision(entity, offset)
    local row1,col1,row2,col2 = self:toMapCoords(entity)
    if col2 < self.colCount then -- bellow the right corner of the stage
        for i = math.max(1, row1+offset), 
                math.min(row2-offset,self.rowCount) do
            if self.map[i][col2] ~= nil 
                    and self.map[i][col2].solid then
                return true
            end -- end if 
        end -- end for
    end -- end if    
    return false
end

function Stage:leftCollision(entity, offset)
    local row1,col1,row2,col2 = self:toMapCoords(entity)
    if col1 >= 1 then -- bellow the left corner of the stage
        for i = math.max(1, row1+offset), 
                math.min(row2-offset,self.rowCount) do
            if self.map[i][col1] ~= nil 
                    and self.map[i][col1].solid then
                return true
            end -- end if 
        end -- end for
    end -- end if    
    return false
end

function Stage:bottomCollision(entity, ofsRow, ofsCol)
    local row1,col1,row2,col2 = self:toMapCoords(entity)

    if row2+ofsRow < self.rowCount then -- not falling below screen
        for j = math.max(1, col1+ofsCol),
                math.min(col2-ofsCol, self.colCount) do
            if self.map[row2+ofsRow][j] ~= nil 
                    and self.map[row2+ofsRow][j].solid then
                return true
            end -- end if solid tile
        end -- end for j
    end -- end if row2 < rowCount
    return false
end

function Stage:readObjectsData(rawobjs)
    self.objects = {} 
    for k = 1, #rawobjs do
        local newobj = objutil.convertObjectData(
            rawobjs[k],self:getTileSize())
        if newobj then
            table.insert(self.objects, newobj)
        end
    end
end

function Stage:checkObjectsCollision(entity)
    local row1,col1,row2,col2 = self:toMapCoords(entity)
    for k = #self.objects, 1, -1 do
        if row1<= self.objects[k].row 
                and row2 >= self.objects[k].row
                and col1 <= self.objects[k].col 
                and col2 >= self.objects[k].col then
            
            local colidedObj = self.objects[k]
            table.remove(self.objects, k)
            return colidedObj
        end
    end
end

function Stage:checkMobsHboxCollision(anHbox, boxtype)
    if anHbox == nil then return nil end

    for k=1, #self.mobs do
        local mobHbox = self.mobs[k]:getHbox(boxtype)
        if mobHbox ~= nil and mobHbox:collision(anHbox) then
            return self.mobs[k]
        end -- end if
    end -- end for mobs

    return nil
end

function Stage:setMusic(music)
    self.music = music
end

function Stage:playMusic()
    if self.music then
        self.music:setLooping(true)
        self.music:play()
    end
end

function Stage:stopMusic()
    if self.music and self.music:isPlaying() then
        self.music:stop()
    end
end
    

return Stage
