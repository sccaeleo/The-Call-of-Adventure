local Class = require "libs.hump.class"
local Tween = require "libs.tween"
local Explosion = require "src.game.Explosion"
local Sounds = require "src.game.Sounds"


-- Here we create a specific font in our HUD
local hudFont = love.graphics.newFont("fonts/Abaddon Bold.ttf",16)
local damageTextChar = ""
local damageTextEnemy = ""
local damageTextTimer = 0

-- Awful tween variables
local initialCharTextPos = {x = math.floor(gameWidth/4), y = math.floor(gameHeight/2 - 32)}
local initialEnemyTextPos = {x = math.floor(gameWidth -gameWidth/4), y = math.floor(gameHeight/2 - 32)}
local charTextPos = {x = math.floor(gameWidth/4), y = math.floor(gameHeight/2 - 32)}
local enemyTextPos = {x = math.floor(gameWidth -gameWidth/4), y = math.floor(gameHeight/2 - 32)}

local tweenCharTextPos = nil
local tweenEnemyTextPos = nil

local playerBlockDuration = 0
local exp = Explosion()
exp:init()
exp:setColor(255,0,0)
--sounds()

local HUD = Class{}
function HUD:init(player, skeleton)
    self.player = player
    self.skeleton = skeleton
end

function love.load()
    exp = Explosion()
    
end

function HUD:update(dt)
    math.randomseed(os.time())
    exp:update(dt)

    -- 
    if damageTextTimer > 0 then
        damageTextTimer = damageTextTimer - dt
        if tweenCharTextPos ~= nil then
            tweenCharTextPos:update(dt)
        end
        if tweenEnemyTextPos ~= nil then
            tweenEnemyTextPos:update(dt)
        end
    else
        damageTextChar = ""
        damageTextEnemy = ""
    end

    if self.player.CurrentHp <= 0 then
        gameState = "end"
    elseif self.skeleton.CurrentHp <= 0 then
        gameState = "roam"
    else
        
    end
    
    
end

function HUD:keypressed(key)
    if key == "a" then 
        charTextPos.y = initialCharTextPos.y
        enemyTextPos.y = initialEnemyTextPos.y
        if (math.random(1,20) + self.skeleton.attackBonus) >= self.player.armorClass then
            self.player.CurrentHp = self.player.CurrentHp - (math.random(1,self.skeleton.damageRoll) + self.skeleton.damageBonus)
            exp:trigger(math.floor(gameWidth/4),math.floor(gameHeight/2))
            damageTextChar = "Hit"
            Sounds["attack1"]:play()
            damageTextTimer = 1
        else
            damageTextChar = "Miss"
            Sounds["miss"]:play()
        end
        if (math.random(1,20) + self.player.attackBonus) >= self.skeleton.armorClass then
            self.skeleton.CurrentHp = self.skeleton.CurrentHp - (math.random(1,self.player.damageRoll) + self.player.damageBonus)
            exp:trigger(math.floor(gameWidth - gameWidth/4),math.floor(gameHeight/2))
            damageTextEnemy = "Hit"
            Sounds["attack1"]:play()
            damageTextTimer = 1
        else
            damageTextEnemy = "Miss"
            Sounds["miss"]:play()
        end
        if playerBlockDuration > 0 then
            playerBlockDuration = playerBlockDuration - 1
        end
    elseif key == "b" then
        playerBlockDuration = 3
        charTextPos.y = initialCharTextPos.y
        enemyTextPos.y = initialEnemyTextPos.y
        if (math.random(1,20) + self.skeleton.attackBonus) >= self.player.armorClass then
            self.player.CurrentHp = self.player.CurrentHp - math.floor((math.random(1,self.skeleton.damageRoll) + self.skeleton.damageBonus)/2)
            exp:trigger(math.floor(gameWidth/4),math.floor(gameHeight/2))
            damageTextChar = "Hit"
            Sounds["attack1"]:play()
            damageTextEnemy = "Block"
            damageTextTimer = 1
        else
            damageTextTimer = 1
            damageTextEnemy = "Block"
            damageTextChar = "Miss"
        end
    end
end

function HUD:draw()

    -- Draw Char and Enemy
    self.player.animations[self.player.class]:draw(self.player.sprites[self.player.class], math.floor(gameWidth/4), math.floor(gameHeight/2) )
    self.skeleton.animations[self.skeleton.class]:draw(self.skeleton.sprites[self.skeleton.class], math.floor(gameWidth - gameWidth/4), math.floor(gameHeight/2) )
    
    -- Display hit/miss
    if damageTextChar ~= "" then
        tweenCharTextPos = Tween.new(1,charTextPos,{y = initialCharTextPos.y - 10})
        tweenEnemyTextPos = Tween.new(1,enemyTextPos,{y = initialEnemyTextPos.y - 10})
        love.graphics.print(damageTextChar,hudFont,charTextPos.x,charTextPos.y)
        love.graphics.print(damageTextEnemy,hudFont,enemyTextPos.x,enemyTextPos.y)
        exp:draw(10,10)
    end

    -- Display Stats
    love.graphics.setColor(1,0,0)
    love.graphics.print("HP:"..self.player.CurrentHp.."/"..self.player.health,hudFont,math.floor(gameWidth/4 - 16),math.floor(gameHeight/2 + 32))
    love.graphics.setColor(0,1,1)
    love.graphics.print("MP:"..self.player.CurrentMp.."/"..self.player.mana,hudFont,math.floor(gameWidth/4 - 16),math.floor(gameHeight/2 + 48))
    --love.graphics.print("Time:"..99,hudFont,1,1)
    love.graphics.setColor(1,0,0)
    love.graphics.print("HP:"..self.skeleton.CurrentHp.."/"..self.skeleton.health,hudFont,math.floor(gameWidth - (gameWidth/4) - 16),math.floor(gameHeight/2 + 32))
    love.graphics.setColor(0,1,1)
    love.graphics.print("MP:"..self.skeleton.CurrentMp.."/"..self.skeleton.mana,hudFont,math.floor(gameWidth - (gameWidth/4) - 16),math.floor(gameHeight/2 +48))
    love.graphics.setColor(1,1,1)
    love.graphics.print("Press 'a' to attack",hudFont,math.floor(gameWidth/2 - 64),math.floor(gameHeight/2 + 80))
    love.graphics.print("Press 'b' to block",hudFont,math.floor(gameWidth/2 - 64),math.floor(gameHeight/2 + 96))
    
    -- Time is usually Stage specific for Platformers
    --love.graphics.print("Score:"..self.player.score,hudFont,250,1)

end

return HUD