local Racket = {};

local racket_mt = {__index = Racket};

function Racket.Create(posX, posY)

    print("Création d'une instance de Racket");

    local tmpRacket = {};
    tmpRacket.width = 80;
    tmpRacket.height = 20;
    tmpRacket.basePosX = posX - tmpRacket.width/2;
    tmpRacket.basePosY = posY - tmpRacket.height*3;
    tmpRacket.posX = posX - tmpRacket.width/2;
    tmpRacket.posY = posY - tmpRacket.height*3;
    tmpRacket.movementSpeed = 500;

    return setmetatable(tmpRacket, racket_mt);
end

function Racket:Reset()
    self.posX = self.basePosX;
    self.posY = self.basePosY;
end

function Racket:Move(direction, deltaTime)
    if direction == "left" then
        self.posX = self.posX - self.movementSpeed * deltaTime;
    elseif direction == "right" then
        self.posX = self.posX + self.movementSpeed * deltaTime;
    end
end

function Racket:CanMove(direction)
    if direction == "left" then
        return self.posX >= 0;
    elseif direction == "right" then
        return self.posX + self.width <= love.graphics.getWidth();
    end
    return false;
end

function Racket:ScreenPlacement()
    if self.posX + self.width/2 < love.graphics.getWidth()/3 then
        return 0;
    elseif self.posX + self.width/2 > (love.graphics.getWidth()/3)*2 then
        return 1;
    else
        return 2;
    end
end

return Racket;