require("utils");
local Entity = require("entities/entity");

local Ship = {};
setmetatable(Ship, {__index = Entity});

function Ship:New()
    print("Création d'une instance de Ship");
    local tmpShip = Entity:New();
    setmetatable(tmpShip, {__index = Ship});

    tmpShip.rotation = 100;
    tmpShip.test = GetDistance(tmpShip, tmpShip);

    tmpShip:UpdatePos();

    return tmpShip;
end

function Ship:Update()
    print(self.rotation)
    self.posX = self.posX + 1;
    print("Ship is moving");
end

return Ship;