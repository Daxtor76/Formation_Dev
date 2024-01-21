local Brick = {};

local brick_mt = {__index = Brick};

function Brick.Create()

    print("Création d'une instance de Brick");

    local tmpBrick = {};
    tmpBrick.width = 40;
    tmpBrick.height = 20;
    tmpBrick.margin = 30;
    tmpBrick.posX = 0;
    tmpBrick.posY = 0;
    tmpBrick.line = 0;
    tmpBrick.column = 0;
    tmpBrick.life = 1;

    return setmetatable(tmpBrick, brick_mt);
end

function Brick:TakeDamages(dmg)
    self.life = self.life - dmg;
end

return Brick;