local Brick = {};

local brick_mt = {__index = Brick};

function Brick.Create(posX, posY)

    print("Création d'une instance de Brick");

    local tmpBrick = {};
    tmpBrick.width = 40;
    tmpBrick.height = 20;
    tmpBrick.margin = 10;
    tmpBrick.posX = posX;
    tmpBrick.posY = posY;

    return setmetatable(tmpBrick, brick_mt);
end

return Brick;