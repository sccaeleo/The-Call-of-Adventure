local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Tween = require "libs.tween"
local Hbox = require "src.game.Hbox"
--local Sounds = require "src.game.Sounds"

-- Sprites
local WizardSprite = love.graphics.newImage("graphics/characters/wizard-Sheet.png")
local WizardGrid = Anim8.newGrid(32,32,WizardSprite:getWidth(),WizardSprite:getHeight())
local WizardAnim = Anim8.newAnimation(WizardGrid('1-4',1), 0.05)

local RangerSprite = love.graphics.newImage("graphics/characters/ranger-Sheet.png")
local RangerGrid = Anim8.newGrid(32,32,RangerSprite:getWidth(),RangerSprite:getHeight())
local RangerAnim = Anim8.newAnimation(RangerGrid('1-4',1), 0.05)

local PaladinSprite = love.graphics.newImage("graphics/characters/paladin-Sheet.png")
local PaladinGrid = Anim8.newGrid(32,32,PaladinSprite:getWidth(),PaladinSprite:getHeight())
local PaladinAnim = Anim8.newAnimation(PaladinGrid('1-4',1), 0.05)


local Player = Class{}

function Player:init(x, y, class)

    self.x = x
    self.y = y
    self.name = "char"
    self.class = class
    self.dir = "r"
    self.speed = 96

    -- Player stats & inventory
    self.health = 100
    self.CurrentHp = 100
    self.armorClass = 10

    self.mana = 100
    self.CurrentMp = 100
    
    self.consumables = {}

    -- States = idle, walk, battle, attack, hurt
    self.state = "idle"

    -- Animations
    self.animations = {}
    self.sprites = {}

    -- Class animation handler 
    -- I didn't add that many flavors of animations because drawing sprite animations is incredibly time-consuming
    -- ...and I am bad at it
    if self.class == "Wizard" then
        self.animations["Wizard"] = WizardAnim
        self.sprites["Wizard"] = WizardSprite
        self.armorClass = 12
        self.attackBonus = 8
        self.damageBonus = 8
        self.damageRoll = 12

    elseif self.class == "Ranger" then
        self.animations["Ranger"] = RangerAnim
        self.sprites["Ranger"] = RangerSprite
        self.armorClass = 14
        self.attackBonus = 6
        self.damageBonus = 6
        self.damageRoll = 10

    elseif self.class == "Paladin" then
        self.animations["Paladin"] = PaladinAnim
        self.sprites["Paladin"] = PaladinSprite
        self.armorClass = 16
        self.attackBonus = 4
        self.damageBonus = 5
        self.damageRoll = 8

    end

    -- Hitbox for wall collisions
    self.hitbox = Hbox(self, 8, 8, 16, 16)
end

function Player:update(dt,stage)

    -- Player movement
    if love.keyboard.isDown("d","right") then
        self:setDirection("r")
        if not stage:rightCollision(self, 0) then
            self.x = self.x + self.speed*dt
        else 
            self.x = self.x - 2
        end
    elseif love.keyboard.isDown("a","left") then
        self:setDirection("l")
        if not stage:leftCollision(self,0) then
            self.x = self.x - self.speed*dt
        else 
            self.x = self.x + 2
        end
    elseif love.keyboard.isDown("s","down") then
        if not stage:bottomCollision(self,0) then
            self.y = self.y + self.speed*dt
        else 
            self.y = self.y - 2
        end
    elseif love.keyboard.isDown("w","up") then
        if not stage:topCollision(self,0) then
            self.y = self.y - self.speed*dt
        else 
            self.y = self.y + 2
        end
    end

    -- changing states logic
    if self.state == "idle" or self.state == "walk" then
        if love.keyboard.isDown("w","a","s","d","up","down","right","left") then
            self.state = "walk"

        else
            self.state = "idle"
        end
    end

    -- Collisions
    local obj = stage:checkObjectsCollision(self)
    if obj then
        -- Player colided with obj
        self:handleObjectCollision(obj)
    end

    if self.state == "walk" or self.state == "battle" then
        self.animations[self.class]:update(dt)
    else
        self.animations[self.class]:gotoFrame(1)
    end
    
end

function Player:handleObjectCollision(obj)

    -- Todo, adapt for opening chest if time allows
    --if obj.name == "coin" then
    --    self.coins = self.coins +1
    --    self.score = self.score +10
    --    Sounds["coin"]:play()
    --end
end

function Player:draw()
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

function Player:drawBattleState()
    self.state = "battle"
    self.animations[self.class]:draw(self.sprites[self.class], math.floor(gameWidth/4), math.floor(gameHeight/2) )

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

function Player:keypressed(key)
end

function Player:keyreleased(key)
    
end

function Player:setDirection(newdir)
    if self.dir ~= newdir then
        self.dir = newdir
        for states,anim in pairs(self.animations) do
            anim:flipH()
        end
    end
end

function Player:setCoords(x,y)
    self.x = x
    self.y = y
end

function Player:getDimensions()
    return self.animations[self.class]:getDimensions()
end
function Player:getHbox()
    return self.hitbox
end

function Player:getHitbox()
    return self:getHbox()
end

function Player:nextStage(stage)
    self.x = stage.initialPlayerX
    self.y = stage.initialPlayerY
end

function Player:reset()
    self.state = "idle"
    self:setDirection("r")
    self.hp = 100
    self.mana = 100
end

return Player