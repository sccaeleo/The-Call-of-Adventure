local Class = require "libs.hump.class"
local Anim8 = require "libs.anim8"
local Tween = require "libs.tween"
local Hbox = require "src.game.Hbox"
local Sounds = require "src.game.Sounds"

-- Sprites
local Wizard = "graphics/characters/wizard-Sheet.png"
local Ranger = "graphics/characters/ranger-Sheet.png"
local Paladin = "graphics/characters/paladin-Sheet.png"


-- Animation
local animation = love.graphics.newImage(Wizard)



local Player = Class{}

function Player:init(x, y, class)
    self.x = x
    self.y = y
    self.name = "char"
    self.class = class
    self.hitbox = {}

    self.animations = {}
    self.sprites = {}
    self:createAnimations()

    if self.class == "Wizard" then
        self.sprite = self.animations["idle"]
        self.sprite:gotoFrame(1)
    end
    if self.class == "Ranger" then    
        self.sprite = self.animations["idle"]
        self.sprite:gotoFrame(1)
    end
    if self.class == "Paladin" then
        self.sprite = self.animations["idle"]
        self.sprite:gotoFrame(1)
    end
end

function Player:update()
    
end