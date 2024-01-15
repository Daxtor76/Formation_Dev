local Racket = {};

local racket_mt = {__index = Racket};

function Racket.Create()

    print("Création d'une instance de Racket");

    local tmpRacket = {};
    tmpRacket.nombre = 1;
    tmpRacket.width = 20;
    tmpRacket.height = 80;
    tmpRacket.posX = 10;
    tmpRacket.posY = 10;
    tmpRacket.movementSpeed = 4;

    return setmetatable(tmpRacket, racket_mt);
end

function Racket:Move(direction)
    if direction == "up" then
        self.posY = self.posY - self.movementSpeed;
    elseif direction == "down" then
        self.posY = self.posY + self.movementSpeed;
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