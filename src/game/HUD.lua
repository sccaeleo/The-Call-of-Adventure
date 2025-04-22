local Class = require "libs.hump.class"

-- Here we create a specific font in our HUD
local hudFont = love.graphics.newFont("fonts/Abaddon Bold.ttf",16)

local HUD = Class{}
function HUD:init(player, skeleton)
    self.player = player
    self.skeleton = skeleton
end

function HUD:update(dt)
end

function HUD:draw()
    --love.graphics.print( text, font, x, y,
    love.graphics.print("HP:"..self.player.CurrentHp.."/"..self.player.health,hudFont,math.floor(gameWidth/4 - 16),math.floor(gameHeight/2 + 32))
    love.graphics.print("MP:"..self.player.CurrentMp.."/"..self.player.mana,hudFont,math.floor(gameWidth/4 - 16),math.floor(gameHeight/2 + 48))
    love.graphics.print("Time:"..99,hudFont,1,1) 
    love.graphics.print("HP:"..self.skeleton.CurrentHp.."/"..self.skeleton.health,hudFont,math.floor(gameWidth - (gameWidth/4) - 16),math.floor(gameHeight/2 + 32))
    love.graphics.print("MP:"..self.skeleton.CurrentMp.."/"..self.skeleton.mana,hudFont,math.floor(gameWidth - (gameWidth/4) - 16,math.floor(gameHeight/2 + 48)))
    -- Time is usually Stage specific for Platformers
    --love.graphics.print("Score:"..self.player.score,hudFont,250,1)

end

return HUD