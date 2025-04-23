local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Tween = require "libs.tween"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

-- Sprites
local SkeletonSprite = love.graphics.newImage("graphics/npc/Skeleton-Sheet.png")
local SkeletonGrid = Anim8.newGrid(32,32,SkeletonSprite:getWidth(),SkeletonSprite:getHeight())
local SkeletonAnim = Anim8.newAnimation(SkeletonGrid('1-2',1), 0.3)



local Skeleton = Class{}

function Skeleton:init(x, y, class)
    self.x = x
    self.y = y
    self.name = "char"
    self.class = class
    self.dir = "r"
    self.speed = 56

    -- Skeleton stats & inventory
    self.health = 50
    self.CurrentHp = 50
    self.armorClass = 10
    self.attackBonus = 3
    self.damageRoll = 4
    self.damageBonus = 2

    self.mana = 20
    self.CurrentMp = 20
    
    self.consumables = {}

    -- States = idle, walk, battle, attack, hurt
    self.state = "idle"

    -- Animations
    self.animations = {}
    self.sprites = {}

    -- Class animation handler 
    -- I didn't add that many flavors of animations because drawing sprite animations is incredibly time-consuming
    -- ...and I am bad at it
    if self.class == "Skeleton" then
        self.animations["Skeleton"] = SkeletonAnim
        self.sprites["Skeleton"] = SkeletonSprite
    end

    -- Hitbox for wall collisions
    self.hitbox = Hbox(self, 8, 8, 16, 16)
end

function Skeleton:update(dt,stage)
--[[
    -- Skellington movement
    if love.keyboard.isDown("d","right") then
        self:setDirection("r")
        if not stage:rightCollision(self, 1) then
            self.x = self.x + self.speed*dt
        end
    elseif love.keyboard.isDown("a","left") then
        self:setDirection("l")
        if not stage:leftCollision(self,1) then
            self.x = self.x - self.speed*dt
        end
    elseif love.keyboard.isDown("s","down") then
        if not stage:bottomCollision(self,1) then
            self.y = self.y + self.speed*dt
        end
    elseif love.keyboard.isDown("w","up") then
        if not stage:topCollision(self,1) then
            self.y = self.y - self.speed*dt
        end
    end
    

    -- changing states logic
    if self.state == "idle" or self.state == "walk" then
        if love.keyboard.isDown("w","a","s","d","up","down","right","left") then
            self.state = "walk"
        else
            self.state = "idle"
        end
    end ]]

    -- Collisions
    local obj = stage:checkObjectsCollision(self)
    if obj then
        -- Skelly colided with obj
        self:handleObjectCollision(obj)
    end
end

function Skeleton:handleObjectCollision(obj)

end

function Skeleton:draw()
    self.animations[self.class]:draw(self.sprites[self.class], math.floor(self.x), math.floor(self.y) )

    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",self.x,self.y,w,h) -- sprite

        if self:getHitbox() then
            love.graphics.setColor(1,0,0) -- red
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
    end
end

function Skeleton:drawBattleState()
    self.animations[self.class]:draw(self.sprites[self.class], math.floor(gameWidth - (gameWidth/4)), math.floor(gameHeight/2) )

    if debugFlag then
        local w,h = self:getDimensions()
        love.graphics.rectangle("line",gameWidth/4,gameHeight/2,w,h) -- sprite

        if self:getHitbox() then
            love.graphics.setColor(1,0,0) -- red
            self:getHitbox():draw()
        end
        love.graphics.setColor(1,1,1) 
    end
end

function Skeleton:keypressed(key)
end

function Skeleton:keyreleased(key)
    
end

function Skeleton:setDirection(newdir)
    if self.dir ~= newdir then
        self.dir = newdir
        for states,anim in pairs(self.animations) do
            anim:flipH()
        end
    end
end

function Skeleton:setCoords(x,y)
    self.x = x
    self.y = y
end

function Skeleton:getDimensions()
    return self.animations[self.class]:getDimensions()
end
function Skeleton:getHbox()
    return self.hitbox
end

function Skeleton:getHitbox()
    return self:getHbox()
end
--[[
function Skeleton:nextStage(stage)
    self.x = stage.initialSkellyX
    self.y = stage.initialSkellyY
end ]]

function Skeleton:reset()
    self.state = "idle"
    self:setDirection("l")
    self.hp = 100
    self.mana = 100
end

return Skeleton