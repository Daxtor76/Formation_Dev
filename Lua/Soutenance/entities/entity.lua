require("utils");

local Entity = {};

function Entity:New()
    print("Création d'une instance de Entity");
    local tmpEntity = {};
    setmetatable(tmpEntity, Entity);

    tmpEntity.posX = 10;
    tmpEntity.posY = 10;
    tmpEntity.rotation = 0;

    return tmpEntity;
end

function Entity:Update()
    print(self.rotation);
end

function Entity:UpdatePos()
    self.posX = self.posX + 1;
    print(self.posX)
end

return Entity;