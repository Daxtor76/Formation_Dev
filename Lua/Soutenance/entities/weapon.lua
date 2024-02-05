require("utils");
local _Entity = require("entities/_entity");

local Weapon = {};
setmetatable(Weapon, {__index = _Entity});

function Weapon:New(x, y)
    local tmpWeapon = _Entity:New("Weapon");
    print("Création d'une instance de "..tmpWeapon.name);
    setmetatable(tmpWeapon, {__index = Weapon});

    tmpWeapon.posX = x;
    tmpWeapon.posY = y + 20;
    tmpWeapon.width = 50;
    tmpWeapon.height = 50;
    tmpWeapon.pivotX = tmpWeapon.width*0.5;
    tmpWeapon.pivotY = tmpWeapon.height*0.5;

    tmpWeapon.spritesheet = love.graphics.newImage("images/player/bow.png");
    tmpWeapon.anims = tmpWeapon:PopulateAnims();
    tmpWeapon.renderLayer = 0;

    return tmpWeapon;
end

function Weapon:Draw()
    local angle = math.atan2(GetMousePos().y - self.posY, GetMousePos().x - self.posX) - math.pi*0.5;
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.posX,
        self.posY,
        angle,
        self.scaleX,
        self.scaleY,
        self.pivotX,
        self.pivotY
    );
end

function Weapon:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 0, 1);
    anims[0][0] = idleAnim;

    return anims;
end

return Weapon;