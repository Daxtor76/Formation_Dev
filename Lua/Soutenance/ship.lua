local Dino = {};

function Dino:New(posX, posY)

    print("Création d'une instance de Ship");

    local tmpDino = {};
    setmetatable(tmpDino, {__index = Dino});
    tmpDino.ship = love.graphics.newImage("Images/Dino_Spritesheet.png.png");
    tmpDino.width = tmpDino.ship:getWidth();
    tmpDino.height = tmpDino.ship:getHeight();
    tmpDino.posX = posX - tmpDino.width*0.5;
    tmpDino.posY = posY - tmpDino.height*0.5;
    tmpDino.pivotPosX = tmpDino.width*0.5;
    tmpDino.pivotPosY = tmpDino.height*0.5;
    tmpDino.speed = love.math.random(75, 150);
    tmpDino.direction = love.math.random(0, 7);
    tmpDino.rotation = ConvertAngle((tmpDino.direction + 1) * 45);
    tmpDino.timer = love.math.random(2, 10);
    tmpDino.currentTimer = tmpDino.timer;
    return tmpDino;
end

function Ship:IsTimeToChangeDirection(deltaTime)
    self.currentTimer = self.currentTimer%self.timer - deltaTime;
    return self.currentTimer <= 0;
end

function Ship:Move(deltaTime)
    if self.direction == 0 then
        -- gauche
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
    elseif self.direction == 1 then
        -- haut gauche
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 2 then
        -- haut
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 3 then
        -- haut droite
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight - self.speed * deltaTime;
    elseif self.direction == 4 then
        -- droite
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
    elseif self.direction == 5 then
        -- bas droite
        self.posX = self.posX%screenWidth + self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 6 then
        -- bas
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    elseif self.direction == 7 then
        -- bas gauche
        self.posX = self.posX%screenWidth - self.speed * deltaTime;
        self.posY = self.posY%screenHeight + self.speed * deltaTime;
    end
end

function ConvertAngle(angle)
    return math.rad(angle + 135);
end

return Dino;