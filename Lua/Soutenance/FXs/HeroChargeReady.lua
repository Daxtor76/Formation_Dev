local _Entity = require("entities/_Entity");

HeroChargeReady = {};
setmetatable(HeroChargeReady, {__index = _Entity});

function HeroChargeReady:New(x, y)
    local tmpHeroChargeReady = _Entity:New("HeroCharge", "");
    --print("Création d'une instance de "..tmpHeroChargeReady.name);
    setmetatable(tmpHeroChargeReady, {__index = HeroChargeReady});

    -- Inner
    tmpHeroChargeReady.position = Vector.New(x, y);
    tmpHeroChargeReady.width = 47;
    tmpHeroChargeReady.height = 48;
    tmpHeroChargeReady.scaleX = 1;
    tmpHeroChargeReady.scaleY = 1;
    tmpHeroChargeReady.pivotX = tmpHeroChargeReady.width*0.5;
    tmpHeroChargeReady.pivotY = 0;

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
    self:Replace(hero.position.x, hero.position.y);
    if GetMousePos().y + cameraOffset.y > hero.position.y then
        self:ChangeRenderLayer(10);
    else
        self:ChangeRenderLayer(8);
    end
end

function HeroChargeReady:Draw()
    local delta = GetMousePos() - self.position + cameraOffset;
    local angle = delta:GetAngle() - math.pi*0.5;
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        hero.position.x, 
        hero.position.y, 
        angle, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function HeroChargeReady:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 2, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return HeroChargeReady;