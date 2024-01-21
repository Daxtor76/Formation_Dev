local Ball = {};

local ball_mt = {__index = Ball};

function Ball.Create(racket)

    print("Création d'une instance de Ball");

    local tmpBall = {};
    tmpBall.width = 20;
    tmpBall.height = 20;
    tmpBall.basePosX = racket.posX + racket.width/2 - tmpBall.width/2;
    tmpBall.basePosY = racket.posY - tmpBall.height;
    tmpBall.posX = racket.posX + racket.width/2 - tmpBall.width/2;
    tmpBall.posY = racket.posY - tmpBall.height;
    tmpBall.baseMovementSpeed = 250;
    tmpBall.baseAccel = 1;
    tmpBall.accelIncreasePerCollision = 0.1;
    tmpBall.movementSpeedX = tmpBall.baseMovementSpeed;
    tmpBall.movementSpeedY = tmpBall.baseMovementSpeed;
    tmpBall.accel = tmpBall.baseAccel;

    return setmetatable(tmpBall, ball_mt);
end

function Ball:ResetPos()
    self.posX = self.basePosX;
    self.posY = self.basePosY;
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

function Ball:GetRacketCollisionLocation(racket)
     -- Cette fonction doit me donner la position où la balle a tapé sur la raquette (0=gauche, 100=droite)
    return self.posX - racket.posX + self.width;
end

function Ball:FollowRacket(racket)
    self.posX = racket.posX + racket.width/2 - self.width/2
    self.posY = racket.posY - self.height;
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

    return downBallSide;
end

function Ball:IsCollidingWithBrick(brick)
    local brickRightFacePosX = brick.posX + brick.width;
    local brickLeftFacePosX = brick.posX;
    local brickDownFacePosY = brick.posY + brick.height;
    local brickUpperFacePosY = brick.posY;
    local ballDownFacePosY = self.posY + self.height;
    local ballUpperFacePosY = self.posY;
    local ballLeftFacePosX = self.posX;
    local ballRightFacePosX = self.posX + self.width;

    local leftBallSide = (ballLeftFacePosX < brickRightFacePosX and ballLeftFacePosX > brickLeftFacePosX) and (ballDownFacePosY > brickUpperFacePosY and ballUpperFacePosY < brickDownFacePosY);
    local rightBallSide = (ballRightFacePosX > brickLeftFacePosX and ballRightFacePosX < brickRightFacePosX) and (ballDownFacePosY > brickUpperFacePosY and ballUpperFacePosY < brickDownFacePosY);
    local downBallSide = (ballDownFacePosY > brickUpperFacePosY and ballDownFacePosY < brickDownFacePosY) and (ballRightFacePosX > brickLeftFacePosX and ballLeftFacePosX < brickRightFacePosX);
    local upperBallSide = (ballUpperFacePosY < brickDownFacePosY and ballUpperFacePosY > brickUpperFacePosY) and (ballRightFacePosX > brickLeftFacePosX and ballLeftFacePosX < brickRightFacePosX);

    if leftBallSide then
        return 1;
    elseif upperBallSide then
        return 2;
    elseif rightBallSide then
        return 3;
    elseif downBallSide then
        return 4;
    else
        return 0;
    end

    return leftBallSide or rightBallSide or downBallSide or upperBallSide;
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

function Ball:ApplyDirection(direction)
    if direction == 0 then
        -- haut gauche
        self.movementSpeedX = -self.movementSpeedX;
        self.movementSpeedY = -self.movementSpeedY;
    elseif direction == 1 then
        -- haut droite
        self.movementSpeedX = self.movementSpeedX;
        self.movementSpeedY = -self.movementSpeedY;
    end
end

function Ball:Move(accelFactor, deltaTime)
    self.posX = self.posX + self.movementSpeedX * accelFactor * deltaTime;
    self.posY = self.posY + self.movementSpeedY * accelFactor * deltaTime;
end

return Ball;