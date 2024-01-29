local Dino = {};
local AnimState = require("animState");

function Dino:New(posX, posY)

    print("Création d'une instance de Dino");

    local tmpDino = {};
    setmetatable(tmpDino, {__index = Dino});
    tmpDino.spritesheet = love.graphics.newImage("Images/Dino_Spritesheet.png");
    tmpDino.width = 25;
    tmpDino.height = 30;
    tmpDino.posX = posX;
    tmpDino.posY = posY;
    tmpDino.speed = love.math.random(75, 150);
    tmpDino.direction = 4;
    tmpDino.scaleX = 1;
    tmpDino.scaleY = 1;
    tmpDino.pivotX = tmpDino.width/2;
    tmpDino.pivotY = tmpDino.height/2;

    tmpDino.anims = PopulateAnims();
    tmpDino.state = 1;
    tmpDino.frame = 0;
    tmpDino.floatFrame = 0;

    tmpDino:ChangeState(tmpDino.state);
    tmpDino:ChangeDirection(tmpDino.direction);

    return tmpDino;
end

function PopulateAnims()
    local anims = {};
    local idleAnim = AnimState:New(24, 30, 0, 2, 4);
    local runAnim = AnimState:New(24, 30, 3, 9, 7);
    local hitAnim = AnimState:New(24, 30, 14, 16, 5);
    anims[0] = idleAnim;
    anims[1] = runAnim;
    anims[2] = hitAnim;

    return anims;
end

function Dino:GetCurrentQuadToDisplay()
    local sprite = self.anims[self.state];
    return love.graphics.newQuad((sprite.width * sprite.from) + (sprite.width * self.frame), 0, sprite.width, sprite.height, self.spritesheet);
end

function Dino:UpdateAnim(deltaTime)
    self.floatFrame = (self.floatFrame + self.anims[self.state].speed * deltaTime)%(self.anims[self.state].to - self.anims[self.state].from + 1);
    self.frame = math.floor(self.floatFrame);
end

function Dino:IsAnimOver(deltaTime)
    local animTimer = (self.floatFrame + self.anims[self.state].speed * deltaTime)
    if math.ceil(animTimer) > (self.anims[self.state].to - self.anims[self.state].from + 1) then
        return true;
    end
    return false;
end

function Dino:ChangeState(newState)
    if newState == "idle" or newState == 0 then
        self.state = 0;
    elseif newState == "run" or newState == 1 then
        self.state = 1;
    elseif newState == "hit" or newState == 2 then
        self.state = 2;
    end
    self.floatFrame = 0;
    self.frame = 0;
    print("Dino goes in state "..self.state);
end

function Dino:ChangeDirection(newDirection)
    self.direction = newDirection;
    if newDirection == 0 then
        self.scaleX = -1;
    elseif newDirection == 4 then
        self.scaleX = 1;
    end
end

function Dino:Replace(newPosX, newPosY)
    self.posX = newPosX;
    self.posY = newPosY;
end

function Dino:IsCollidingOnWalls()
    local downFacePosY = self.posY + self.height;
    local upperFacePosY = self.posY;
    local leftFacePosX = self.posX - self.width/2;
    local rightFacePosX = self.posX + self.width/2;

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

function Dino:Move(deltaTime)
    if self.direction == 0 then
        -- left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
    elseif self.direction == 1 then
        -- up left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 2 then
        -- up
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 3 then
        -- up right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 4 then
        -- right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
    elseif self.direction == 5 then
        -- down right
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 6 then
        -- down
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 7 then
        -- down left
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    end
end

return Dino;