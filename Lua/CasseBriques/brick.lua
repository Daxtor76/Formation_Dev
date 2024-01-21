local Brick = {};

local brick_mt = {__index = Brick};

function Brick.Create(width, height, margin)

    print("Création d'une instance de Brick");

    local tmpBrick = {};
    tmpBrick.width = width;
    tmpBrick.height = height;
    tmpBrick.margin = margin;
    tmpBrick.posX = 0;
    tmpBrick.posY = 0;
    tmpBrick.life = 1;

    return setmetatable(tmpBrick, brick_mt);
end

function Brick:TakeDamages(dmg)
    self.life = self.life - dmg;
end

return Brick;