local _Entity = require("entities/_Entity");

HeroCharge = {};
setmetatable(HeroCharge, {__index = _Entity});

function HeroCharge:New(x, y)
    local tmpHeroCharge = _Entity:New("HeroCharge", "");
    --print("Création d'une instance de "..tmpHeroCharge.name);
    setmetatable(tmpHeroCharge, {__index = HeroCharge});

    -- Inner
    tmpHeroCharge.position = Vector.New(x, y);
    tmpHeroCharge.width = 64;
    tmpHeroCharge.height = 64;
    tmpHeroCharge.scaleX = 1;
    tmpHeroCharge.scaleY = 1;
    tmpHeroCharge.pivotX = tmpHeroCharge.width*0.5;
    tmpHeroCharge.pivotY = tmpHeroCharge.height*0.5;

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
        hero.position.y + hero.height * 0.5, 
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function HeroCharge:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 10, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return HeroCharge;