local _Entity = {};
Anim = require("animation/anim");

function _Entity:New(name)
    local tmpEntity = {};
    setmetatable(tmpEntity, _Entity);

    tmpEntity.name = name;
    tmpEntity.rotation = 0;
    tmpEntity.scaleX = 2;
    tmpEntity.scaleY = 2;

    tmpEntity.movementDirection = 0;
    tmpEntity.characterDirection = 0;

    tmpEntity.state = 0;
    tmpEntity.frame = 0;
    tmpEntity.floatFrame = 0;

    return tmpEntity;
end

function _Entity:Load()
end

function _Entity:Update()
end

function _Entity:Draw()
end

function _Entity:GetCurrentQuadToDisplay(animation)
    return love.graphics.newQuad((animation.width * animation.from) + (animation.width * self.frame), 0, animation.width, animation.height, self.spritesheet);
end

-- TO DO : Améliorer cette function pour gérer les anims loop et non loop
function _Entity:UpdateAnim(deltaTime, animation)
    self.floatFrame = (self.floatFrame + animation.speed * deltaTime)%(animation.to - animation.from + 1);
    self.frame = math.floor(self.floatFrame);
end

function _Entity:IsAnimOver(deltaTime, animation)
    local animId = animation;
    local animTimer = (self.floatFrame + self.anims[self.state][animId].speed * deltaTime)
    return math.ceil(animTimer) > (self.anims[self.state][animId].to - self.anims[self.state][animId].from + 1);
end

function _Entity:ChangeRenderLayer(newLayer)
    self.renderLayer = newLayer;
end

function _Entity:ChangeState(newState)
    self.state = self.states[newState];
    print("Entity goes in state "..self.state);
end

function _Entity:IsCollidingOnWalls()
    local downFacePosY = self.posY + self.height;
    local upperFacePosY = self.posY;
    local leftFacePosX = self.posX - self.width;
    local rightFacePosX = self.posX + self.width;

    if leftFacePosX < 100 then
        return 1;
    elseif upperFacePosY < 100 then
        return 2;
    elseif rightFacePosX > love.graphics.getWidth() - 100 then
        return 3;
    elseif downFacePosY > love.graphics.getHeight() - 100 then
        return 4;
    else
        return 0;
    end
end

function _Entity:Replace(newPosX, newPosY)
    self.position.x = newPosX;
    self.position.y = newPosY;
end

function _Entity:Move(deltaTime)

    -- TO DO : Refaire avec des vecteurs
    -- Besoin de les coder => https://www.gamecodeur.fr/atelier-les-vecteurs/
    
    if self.movementDirection == 1 then
        -- left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
    elseif self.movementDirection == 2 then
        -- up left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.movementDirection == 3 then
        -- up
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.movementDirection == 4 then
        -- up right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.movementDirection == 5 then
        -- right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
    elseif self.movementDirection == 6 then
        -- down right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.movementDirection == 7 then
        -- down
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.movementDirection == 8 then
        -- down left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    end
end

return _Entity;