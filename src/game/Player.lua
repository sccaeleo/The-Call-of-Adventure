local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Tween = require "libs.tween"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

-- Sprites
local WizardSprite = love.graphics.newImage("graphics/characters/wizard-Sheet.png")
local WizardGrid = Anim8.newGrid(32,32,WizardSprite:getWidth(),WizardSprite:getHeight())
local WizardAnim = Anim8.newAnimation(WizardGrid('1-4',1), 0.3)

local RangerSprite = love.graphics.newImage("graphics/characters/ranger-Sheet.png")
local RangerGrid = Anim8.newGrid(32,32,RangerSprite:getWidth(),RangerSprite:getHeight())
local RangerAnim = Anim8.newAnimation(RangerGrid('1-4',1), 0.3)

local PaladinSprite = love.graphics.newImage("graphics/characters/paladin-Sheet.png")
local PaladinGrid = Anim8.newGrid(32,32,PaladinSprite:getWidth(),PaladinSprite:getHeight())
local PaladinAnim = Anim8.newAnimation(PaladinGrid('1-4',1), 0.3)


local Player = Class{}

function Player:init(x, y, class)

    self.x = x
    self.y = y
    self.name = "char"
    self.class = class

    -- Player stats & inventory
    self.health = 100
    self.mana = 100
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

    elseif self.class == "Ranger" then
        self.animations["Ranger"] = RangerAnim
        self.sprites["Ranger"] = RangerSprite

    elseif self.class == "Paladin" then
        self.animations["Paladin"] = PaladinAnim
        self.sprites["Paladin"] = PaladinSprite

    end

    -- Hitbox for wall collisions
    self.hitbox = Hbox(self, 0, 0, 16, 16)
end

function Player:update(dt,stage)
    
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

function Player:keypressed(key)
    if key == "space" and self.state ~= "jump" then
        self.state = "jump"
        self.speedY = -64 -- jumping speed
        self.y = self.y -1
        self.animations["jump"]:gotoFrame(1)
        Sounds["jump"]:play()
    elseif key=="f" and self.state ~="jump" 
            and self.state~="attack1" and self.state~="attack2" then
        self.state = "attack1"
        self.animations["attack1"]:gotoFrame(1)
        Sounds["attack1"]:play()
    elseif key=="f" and self.state == "attack1" then
        self.state = "attack2"
        self.animations["attack2"]:gotoFrame(1)
        Sounds["attack2"]:play()
    end
end

function Player:keyreleased(key)
    
end

function Player:setCoords(x,y)
    self.x = x
    self.y = y
end

function Player:getDimensions()
    return self.animations[self.state]:getDimensions()
end

function Player:getHitbox()
    return self:getHbox("hit")
end

return Player