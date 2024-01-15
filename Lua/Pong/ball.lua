local Ball = {};

local ball_mt = {__index = Ball};

function Ball.Create()

    print("Création d'une instance de Ball");

    local tmpBall = {};
    tmpBall.width = 20;
    tmpBall.height = 20;
    tmpBall.posX = love.graphics.getWidth()/2 - tmpBall.width/2;
    tmpBall.posY = love.graphics.getHeight()/2 - tmpBall.height/2;
    tmpBall.movementSpeedX = 2;
    tmpBall.movementSpeedY = 2;
    tmpBall.direction = love.math.random(0, 3);

    return setmetatable(tmpBall, ball_mt);
end

function Ball:ResetPos()
    self.posX = love.graphics.getWidth()/2 - self.width/2;
    self.posY = love.graphics.getHeight()/2 - self.height/2;
    self.direction = love.math.random(0, 3);
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

    local leftBallSide = ballLeftFacePosX == racketRightFacePosX and (ballDownFacePosY >= racketUpperFacePosY and ballUpperFacePosY <= racketDownFacePosY);
    local rightBallSide = ballRightFacePosX == racketLeftFacePosX and (ballDownFacePosY >= racketUpperFacePosY and ballUpperFacePosY <= racketDownFacePosY);
    local downBallSide = ballDownFacePosY == racketUpperFacePosY and (ballRightFacePosX >= racketLeftFacePosX and ballLeftFacePosX <= racketRightFacePosX);
    local upperBallSide = ballUpperFacePosY == racketDownFacePosY and (ballRightFacePosX >= racketLeftFacePosX and ballLeftFacePosX <= racketRightFacePosX);

    if leftBallSide or rightBallSide then
        sounds.collide:play();
        return 0;
    elseif downBallSide or upperBallSide then
        sounds.collide:play();
        return 1;
    else
        return 2;
    end
end

function Ball:IsCollidingOnWalls()
    local ballDownFacePosY = self.posY + self.height;
    local ballUpperFacePosY = self.posY;
    local ballLeftFacePosX = self.posX;
    local ballRightFacePosX = self.posX + self.width;

    if ballUpperFacePosY <= 0 or ballDownFacePosY >= love.graphics.getHeight() then
        sounds.collide:play();
        return 1;
    elseif ballLeftFacePosX <= 0 then
        sounds.defeat:play();
        return 2;
    elseif ballRightFacePosX >= love.graphics.getWidth() then
        sounds.defeat:play();
        return 3;
    else
        return 0;
    end
end

function Ball:Move()
    if self.direction == 0 then
        -- haut gauche
        self.posX = self.posX - self.movementSpeedX;
        self.posY = self.posY - self.movementSpeedY;
    elseif self.direction == 1 then
        -- haut droite
        self.posX = self.posX + self.movementSpeedX;
        self.posY = self.posY - self.movementSpeedY;
    elseif self.direction == 2 then
        -- bas droite
        self.posX = self.posX + self.movementSpeedX;
        self.posY = self.posY + self.movementSpeedY;
    elseif self.direction == 3 then
        -- bas gauche
        self.posX = self.posX - self.movementSpeedX;
        self.posY = self.posY + self.movementSpeedY;
    end
end

return Ball;