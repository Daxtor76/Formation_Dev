local Racket = {};

local racket_mt = {__index = Racket};

function Racket.Create()

    print("Création d'une instance de Racket");

    local tmpRacket = {};
    tmpRacket.nombre = 1;
    tmpRacket.posX = 10;
    tmpRacket.posY = 10;
    tmpRacket.width = 20;
    tmpRacket.height = 80;
    tmpRacket.movementSpeed = 2;

    return setmetatable(tmpRacket, racket_mt);
end

return Racket;