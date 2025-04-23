local Class = require "libs.hump.class"
local imgParticle = love.graphics.newImage("graphics/particles/20.png")
local Explosion = Class{}

function Explosion:init()
    self.particleSystem = love.graphics.newParticleSystem(imgParticle,100) 
                                                      -- image, #particles
    self.particleSystem:setParticleLifetime(0.2, 1.0) -- 0.2 to 1.0 secs
    self.particleSystem:setEmissionRate(0) -- No continuous emission
    self.particleSystem:setSizes(0.1, 0) -- Start tiny, shrink to 0
    self.particleSystem:setSpeed(0, 20) -- Random speed range
    self.particleSystem:setLinearAcceleration(0, 0, 0, 0) -- No gravity
    self.particleSystem:setEmissionArea("uniform",20,20,0,true)
    self.particleSystem:setColors(1, 1, 1, 1, 0, 0, 0, 0) 
    -- White fading to transparent(r, g, b, a, r, g, b, a)    
end

function Explosion:setColor(r,g,b) -- sets the particle color
    self.particleSystem:setColors(r,g,b,1,r,g,b,0)
end

function Explosion:trigger(x,y)
    if x and y then -- if x & y not nil, set then now
        self.particleSystem:setPosition(x, y)
    end
    
    self.particleSystem:emit(30) -- Emit 30 particles
end

function Explosion:update(dt)
    self.particleSystem:update(dt)
end

function Explosion:draw(x,y)
    -- if x & y are nil, it will use the trigger x,y 
    love.graphics.draw(self.particleSystem, x, y)
end

function Explosion:isActive() 
    -- returns true if the particles are still running
    return self.particleSystem:getCount() > 0
end

-- Always remember to return the class at the end of the file
return Explosion 
