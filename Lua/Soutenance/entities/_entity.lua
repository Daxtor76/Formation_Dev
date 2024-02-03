require("utils");
local _Entity = {};
Anim = require("animation/anim");

function _Entity:New()
    print("Création d'une instance de Entity");
    local tmpEntity = {};
    setmetatable(tmpEntity, _Entity);

    tmpEntity.posX = 10;
    tmpEntity.posY = 10;
    tmpEntity.movementSpeedX = 20;
    tmpEntity.movementSpeedY = 20;
    tmpEntity.width = 0;
    tmpEntity.height = 0;
    tmpEntity.rotation = 0;
    tmpEntity.scaleX = 2;
    tmpEntity.scaleY = 2;
    tmpEntity.pivotX = 0;
    tmpEntity.pivotY = 0;

    tmpEntity.direction = 0;
    tmpEntity.speed = 200;

    tmpEntity.anims = nil;
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

function _Entity:GetCurrentQuadToDisplay()
    local animId = math.floor((self.direction)/(self.state+1));
    local sprite = self.anims[self.state][animId];
    return love.graphics.newQuad((sprite.width * sprite.from) + (sprite.width * self.frame), 0, sprite.width, sprite.height, self.spritesheet);
end

function _Entity:UpdateAnim(deltaTime)
    local animId = math.floor((self.direction)/(self.state+1));
    self.floatFrame = (self.floatFrame + self.anims[self.state][animId].speed * deltaTime)%(self.anims[self.state][animId].to - self.anims[self.state][animId].from + 1);
    self.frame = math.floor(self.floatFrame);
end

function _Entity:IsAnimOver(deltaTime)
    local animId = math.floor((self.direction)/(self.state+1));
    local animTimer = (self.floatFrame + self.anims[self.state][animId].speed * deltaTime)
    return math.ceil(animTimer) > (self.anims[self.state][animId].to - self.anims[self.state][animId].from + 1);
end

function _Entity:ChangeState(newState)
    if newState == "idle" or newState == 0 then
        self.state = 0;
    elseif newState == "run" or newState == 1 then
        self.state = 1;
    end
    --self.floatFrame = 0;
    --self.frame = 0;
    print("Entity goes in state "..self.state);
end

function _Entity:IsCollidingOnWalls()
    local downFacePosY = self.posY + self.height;
    local upperFacePosY = self.posY;
    local leftFacePosX = self.posX - self.width;
    local rightFacePosX = self.posX + self.width;

    if leftFacePosX < 0 then
        return 1;
    elseif upperFacePosY < 0 then
        return 2;
    elseif rightFacePosX > love.graphics.getWidth() then
        return 3;
    elseif downFacePosY > love.graphics.getHeight() then
        return 4;
    else
        return 0;
    end
end

function _Entity:Move(deltaTime)
    if self.direction == 1 then
        -- left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
    elseif self.direction == 2 then
        -- up left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 3 then
        -- up
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 4 then
        -- up right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 5 then
        -- right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
    elseif self.direction == 6 then
        -- down right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 7 then
        -- down
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 8 then
        -- down left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    end
end

return _Entity;