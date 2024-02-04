require("utils");
local _Entity = require("entities/_entity");

local Weapon = {};
setmetatable(Weapon, {__index = _Entity});

function Weapon:New(x, y)
    local tmpWeapon = _Entity:New("Weapon");
    print("Création d'une instance de "..tmpWeapon.name);
    setmetatable(tmpWeapon, {__index = Weapon});

    tmpWeapon.posX = x;
    tmpWeapon.posY = y;
    tmpWeapon.width = 24;
    tmpWeapon.height = 24;
    tmpWeapon.pivotX = tmpWeapon.width*0.5;
    tmpWeapon.pivotY = tmpWeapon.height*0.5;

    tmpWeapon.spritesheet = love.graphics.newImage("images/player/Bow.png");
    tmpWeapon.anims = PopulateAnims();

    return tmpWeapon;
end

function Weapon:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.posX,
        self.posY,
        self.rotation,
        self.scaleX,
        self.scaleY,
        self.pivotX,
        self.pivotY
    );
end

function PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(24, 24, 0, 0, 1);
    anims[0][0] = idleAnim;

    return anims;
end

return Weapon;