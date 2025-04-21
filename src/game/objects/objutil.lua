local GameObject = require "src.game.objects.GameObject"
--local Coin = require "src.game.objects.Coin"
--local Gem = require "src.game.objects.Gem"

local objutil = {}
function objutil.convertObjectData(objdata, tilesize)
    local obj = nil

    --if objdata.name == "Coin" then
    --    obj = Coin("gold")
    --elseif objdata.name == "Gem" then
    --    obj = Gem("blue")
    --end

    if obj then
        obj:setCoords(objdata.x, objdata.y-tilesize, tilesize)
    end

    return obj
end

return objutil