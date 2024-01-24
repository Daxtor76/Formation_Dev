local Entity = {};

function Entity:New(posX, posY)

    print("Création d'une instance de Entity");

    local tmpEntity = {};
    setmetatable(tmpEntity, {__index = Entity});
    tmpEntity.posX = posX;
    tmpEntity.posY = posY;
    return tmpEntity;
end

function Entity:Update(dt)
    print ("entity s'update");
    print(self.posX);
end

return Entity;