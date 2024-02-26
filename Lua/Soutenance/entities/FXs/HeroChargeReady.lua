local _Entity = require("entities/_Entity");
local Anim = require("constructors/Anim");

local HeroChargeReady = {};
setmetatable(HeroChargeReady, {__index = _Entity});

function HeroChargeReady:New(position)
    local tmpHeroChargeReady = _Entity:New("HeroCharge", "");
    --print("Création d'une instance de "..tmpHeroChargeReady.name);
    setmetatable(tmpHeroChargeReady, {__index = HeroChargeReady});

    -- Inner
    tmpHeroChargeReady.position = position;
    tmpHeroChargeReady.size = Vector.New(47, 23);
    tmpHeroChargeReady.scale = Vector.New(1, 1);
    tmpHeroChargeReady.pivot = Vector.New(tmpHeroChargeReady.size.x * 0.5, tmpHeroChargeReady.size.y * 0.5);

    tmpHeroChargeReady.states["idle"] = 0;

    tmpHeroChargeReady.state = 0;

    -- Graph
    tmpHeroChargeReady.spritesheet = love.graphics.newImage("images/player/chargeReady.png");
    tmpHeroChargeReady.anims = tmpHeroChargeReady:PopulateAnims();
    tmpHeroChargeReady.renderLayer = 0;
    tmpHeroChargeReady.active = false;

    table.insert(entities, tmpHeroChargeReady);

    return tmpHeroChargeReady;
end

function HeroChargeReady:Update(dt)
    if isUpgrading == false then
        local delta = GetMousePos() - (hero.position - cameraOffset);
        local heroToMouseDirection = delta:Normalize();
        local distance = weapon.size.y - 10;

        self.position = hero.position + heroToMouseDirection * distance;
    end

    if GetMousePos().y + cameraOffset.y > hero.position.y then
        self:ChangeRenderLayer(10);
    else
        self:ChangeRenderLayer(8);
    end
end

function HeroChargeReady:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.position.x, 
        self.position.y, 
        self.rotation, 
        self.scale.x, 
        self.scale.y, 
        self.pivot.x, 
        self.pivot.y
    );
end

function HeroChargeReady:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 2, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return HeroChargeReady;