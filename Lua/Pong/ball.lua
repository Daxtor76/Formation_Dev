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

function Ball:IsCollidingWithRacket(racket)
    local rightRacketSide = self.posX <= racket.posX + racket.width and (self.posY + self.height >= racket.posY and self.posY <= racket.posY + racket.height);
    local leftRacketSide = self.posX + self.width >= racket.posX and (self.posY >= racket.posY and self.posY <= racket.posY + racket.height);

    if leftRacketSide then
        return true;
    end
    return false;
end

function Ball:IsCollidingVerticallyWithRacket(racket)
    local downRacketSide = self.posY <= racket.posY + racket.height and (self.posX + self.width >= racket.posX and self.posX <= racket.posX + racket.width);
    local upperRacketSide = self.posY + self.height >= racket.posY and (self.posX + self.width >= racket.posX and self.posX <= racket.posX + racket.width);
    return downRacketSide or upperRacketSide;
end

function Ball:IsCollidingVertically()
    return self.posY <= 0 or self.posY >= love.graphics.getHeight() - self.width;
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