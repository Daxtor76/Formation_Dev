local Racket = {};

local racket_mt = {__index = Racket};

function Racket.Create(posX, posY)

    print("Création d'une instance de Racket");

    local tmpRacket = {};
    tmpRacket.width = 80;
    tmpRacket.height = 20;
    tmpRacket.posX = posX;
    tmpRacket.posY = posY;
    tmpRacket.movementSpeed = 500;

    return setmetatable(tmpRacket, racket_mt);
end

function Racket:Reset(posX, posY)
    self.posX = posX;
    self.posY = posY;
    self.score = 0;
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

return Racket;