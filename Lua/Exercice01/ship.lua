local Ship = {};

function Ship:New(posX, posY)

    print("Création d'une instance de Ship");

    local tmpShip = {};
    setmetatable(tmpShip, {__index = Ship});
    tmpShip.ship = love.graphics.newImage("Images/ship.png");
    tmpShip.engine = love.graphics.newImage("Images/engine.png");
    tmpShip.width = tmpShip.ship:getWidth();
    tmpShip.height = tmpShip.ship:getHeight();
    tmpShip.posX = posX - tmpShip.width/2;
    tmpShip.posY = posY - tmpShip.height/2;
    tmpShip.speed = love.math.random(75, 150);
    tmpShip.direction = love.math.random(0, 7);
    tmpShip.rotation = ConvertAngle((tmpShip.direction + 1) * 45);
    tmpShip.timer = love.math.random(4, 10);
    tmpShip.currentTimer = tmpShip.timer;
    return tmpShip;
end

function Ship:IsTimeToChangeDirection(deltaTime)
    self.currentTimer = self.currentTimer%self.timer - deltaTime;
    return self.currentTimer <= 0;
end

function Ship:IsCollidingOnWalls()
    local shipDownFacePosY = self.posY + self.height;
    local shipUpperFacePosY = self.posY;
    local shipLeftFacePosX = self.posX;
    local shipRightFacePosX = self.posX + self.width;

    if shipLeftFacePosX < 0 then
        return 1;
    elseif shipUpperFacePosY < 0 then
        return 2;
    elseif shipRightFacePosX > love.graphics.getWidth() then
        return 3;
    elseif shipDownFacePosY > love.graphics.getHeight() then
        return 4;
    else
        return 0;
    end
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

return Ship;