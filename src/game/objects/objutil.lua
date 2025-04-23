local GameObject = require "src.game.objects.GameObject"
local Bone = require "src.game.objects.Bone"
local Skull = require "src.game.objects.Skull"
local Chest = require "src.game.objects.Chest"
local Torch = require "src.game.objects.Torch"

local objutil = {}
function objutil.convertObjectData(objdata, tilesize)
    local obj = nil

    if objdata.name == "Bone" then
        obj = Bone("bone")
    elseif objdata.name == "Skull" then
        obj = Skull("skull")
    elseif objdata.name == "Chest" then
        obj = Chest("chest")
    elseif objdata.name == "Torch" then
        obj = Torch("torch")
    end

    if obj then
        obj:setCoords(objdata.x, objdata.y-tilesize, tilesize)
    end

    return obj
end

return objutil