local Entity = require("entity");
local Ship = {};
setmetatable(Ship, {__index = Entity});

function Ship:New(posX, posY)
    print("Création d'une instance de Ship");

    local tmpShip = Entity:New(posX, posY);
    setmetatable(tmpShip, {__index = Ship});

    tmpShip.isEngineOn = false;
    return tmpShip;
end

function Ship:Update()
    print ("ship s'update");
    self.posX = self.posX + 10;
    print(self.posX);
end

return Ship;