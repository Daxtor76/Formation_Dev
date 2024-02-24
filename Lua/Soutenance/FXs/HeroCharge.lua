local _Entity = require("entities/_Entity");
local Anim = require("animation/Anim");

local HeroCharge = {};
setmetatable(HeroCharge, {__index = _Entity});

function HeroCharge:New(position)
    local tmpHeroCharge = _Entity:New("HeroCharge", "");
    --print("Création d'une instance de "..tmpHeroCharge.name);
    setmetatable(tmpHeroCharge, {__index = HeroCharge});

    -- Inner
    tmpHeroCharge.position = position;
    tmpHeroCharge.size = Vector.New(64, 64);
    tmpHeroCharge.scale = Vector.New(1, 1);
    tmpHeroCharge.pivot = Vector.New(tmpHeroCharge.size.x * 0.5, tmpHeroCharge.size.y * 0.5);

    tmpHeroCharge.states["idle"] = 0;

    tmpHeroCharge.state = 0;

    -- Graph
    tmpHeroCharge.spritesheet = love.graphics.newImage("images/player/charge.png");
    tmpHeroCharge.anims = tmpHeroCharge:PopulateAnims();
    tmpHeroCharge.renderLayer = 0;
    tmpHeroCharge.active = false;

    table.insert(entities, tmpHeroCharge);

    return tmpHeroCharge;
end

function HeroCharge:Update(dt)
end

function HeroCharge:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        hero.position.x, 
        hero.position.y + hero.size.y * 0.5, 
        self.rotation, 
        self.scale.x, 
        self.scale.x, 
        self.pivot.x, 
        self.pivot.y
    );
end

function HeroCharge:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 10, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return HeroCharge;