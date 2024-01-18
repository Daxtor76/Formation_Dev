local Racket = {};

local racket_mt = {__index = Racket};

function Racket.Create(posX, posY)

    print("Création d'une instance de Racket");

    local tmpRacket = {};
    tmpRacket.width = 10;
    tmpRacket.height = 80;
    tmpRacket.posX = posX;
    tmpRacket.posY = posY;
    tmpRacket.movementSpeed = 500;
    tmpRacket.score = 0;
    tmpRacket.isRed = false;

    return setmetatable(tmpRacket, racket_mt);
end

function Racket:Reset(posX, posY)
    self.posX = posX;
    self.posY = posY;
    self.score = 0;
end

function Racket:Move(direction, deltaTime)
    if direction == "up" then
        self.posY = self.posY - self.movementSpeed * deltaTime;
    elseif direction == "down" then
        self.posY = self.posY + self.movementSpeed * deltaTime;
    end
end

function Racket:CanMove(direction)
    if direction == "up" then
        if self.posY >= 0 then
            return true;
        end
        return false;
    elseif direction == "down" then
        if self.posY < love.graphics.getHeight() - self.height then
            return true;
        end
        return false;
    end
    return false;
end

return Racket;