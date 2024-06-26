local Ball = {};

local ball_mt = {__index = Ball};

function Ball.Create()

    print("Création d'une instance de Ball");

    local tmpBall = {};
    tmpBall.width = 20;
    tmpBall.height = 20;
    tmpBall.posX = love.graphics.getWidth()/2 - tmpBall.width/2;
    tmpBall.posY = love.graphics.getHeight()/2 - tmpBall.height/2;
    tmpBall.baseMovementSpeed = 250;
    tmpBall.baseAccel = 1.1;
    tmpBall.accelIncreasePerCollision = 0.1;
    tmpBall.movementSpeedX = tmpBall.baseMovementSpeed;
    tmpBall.movementSpeedY = tmpBall.baseMovementSpeed;
    tmpBall.accel = tmpBall.baseAccel;
    tmpBall.direction = love.math.random(0, 3);

    return setmetatable(tmpBall, ball_mt);
end

function Ball:ResetPos()
    self.posX = love.graphics.getWidth()/2 - self.width/2;
    self.posY = love.graphics.getHeight()/2 - self.height/2;
    self.direction = love.math.random(0, 3);
end

function Ball:Replace(newPosX, newPosY)
    self.posX = newPosX;
    self.posY = newPosY;
end

function Ball:ResetSpeed()
    self.movementSpeedX = self.baseMovementSpeed;
    self.movementSpeedY = self.baseMovementSpeed;
    self.accel = self.baseAccel;
end

function Ball:IncreaseAccel(amount)
    self.accel = self.accel + amount;
end

function Ball:IsCollidingWithRacket(racket)
    local racketRightFacePosX = racket.posX + racket.width;
    local racketLeftFacePosX = racket.posX;
    local racketDownFacePosY = racket.posY + racket.height;
    local racketUpperFacePosY = racket.posY;
    local ballDownFacePosY = self.posY + self.height;
    local ballUpperFacePosY = self.posY;
    local ballLeftFacePosX = self.posX;
    local ballRightFacePosX = self.posX + self.width;

    local leftBallSide = (ballLeftFacePosX < racketRightFacePosX and ballLeftFacePosX > racketLeftFacePosX) and (ballDownFacePosY > racketUpperFacePosY and ballUpperFacePosY < racketDownFacePosY);
    local rightBallSide = (ballRightFacePosX > racketLeftFacePosX and ballRightFacePosX < racketRightFacePosX) and (ballDownFacePosY > racketUpperFacePosY and ballUpperFacePosY < racketDownFacePosY);
    local downBallSide = (ballDownFacePosY > racketUpperFacePosY and ballDownFacePosY < racketDownFacePosY) and (ballRightFacePosX > racketLeftFacePosX and ballLeftFacePosX < racketRightFacePosX);
    local upperBallSide = (ballUpperFacePosY < racketDownFacePosY and ballUpperFacePosY > racketUpperFacePosY) and (ballRightFacePosX > racketLeftFacePosX and ballLeftFacePosX < racketRightFacePosX);

    if leftBallSide then
        return 1;
    elseif rightBallSide then
        return 3;
    elseif upperBallSide then
        return 2;
    elseif downBallSide then
        return 4;
    else
        return 0;
    end
end

function Ball:IsCollidingOnWalls()
    local ballDownFacePosY = self.posY + self.height;
    local ballUpperFacePosY = self.posY;
    local ballLeftFacePosX = self.posX;
    local ballRightFacePosX = self.posX + self.width;

    if ballLeftFacePosX < 0 then
        return 1;
    elseif ballUpperFacePosY < 0 then
        return 2;
    elseif ballRightFacePosX > love.graphics.getWidth() then
        return 3;
    elseif ballDownFacePosY > love.graphics.getHeight() then
        return 4;
    else
        return 0;
    end
end

function Ball:Move(accelFactor, deltaTime)
    if self.direction == 0 then
        -- haut gauche
        self.posX = self.posX - self.movementSpeedX * accelFactor * deltaTime;
        self.posY = self.posY - self.movementSpeedY * accelFactor * deltaTime;
    elseif self.direction == 1 then
        -- haut droite
        self.posX = self.posX + self.movementSpeedX * accelFactor * deltaTime;
        self.posY = self.posY - self.movementSpeedY * accelFactor * deltaTime;
    elseif self.direction == 2 then
        -- bas droite
        self.posX = self.posX + self.movementSpeedX * accelFactor * deltaTime;
        self.posY = self.posY + self.movementSpeedY * accelFactor * deltaTime;
    elseif self.direction == 3 then
        -- bas gauche
        self.posX = self.posX - self.movementSpeedX * accelFactor * deltaTime;
        self.posY = self.posY + self.movementSpeedY * accelFactor * deltaTime;
    end
end

return Ball;