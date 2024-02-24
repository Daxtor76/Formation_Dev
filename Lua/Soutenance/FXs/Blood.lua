local _Entity = require("entities/_Entity");
local Anim = require("animation/Anim");

local Blood = {};
setmetatable(Blood, {__index = _Entity});

function Blood:New(position)
    local tmpBlood = _Entity:New("Blood", "");
    --print("Création d'une instance de "..tmpBlood.name);
    setmetatable(tmpBlood, {__index = Blood});

    -- Inner
    tmpBlood.position = position;
    tmpBlood.size = Vector.New(100, 100);
    tmpBlood.scale = Vector.New(1, 1);
    tmpBlood.pivot = Vector.New(tmpBlood.size.x * 0.5, tmpBlood.size.y * 0.5);

    tmpBlood.states["idle"] = 0;

    tmpBlood.state = 0;

    -- Graph
    tmpBlood.spritesheet = love.graphics.newImage("images/blood_Spritesheet.png");
    tmpBlood.anims = tmpBlood:PopulateAnims();
    tmpBlood.renderLayer = 10;
    tmpBlood.active = false;

    table.insert(entities, tmpBlood);

    return tmpBlood;
end

function Blood:Update(dt)
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
    if self.anims[self.state][0].isOver then
        self:DisableBloodFX();
    end
end

function Blood:Draw()
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

function Blood:DisableBloodFX()
    self.active = false;
    self.anims[self.state][0].isOver = false;
    self:ResetAnim(self.anims[self.state][0]);
end

function Blood:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 17, 0.2, false);
    anims[0][0] = idleAnim;

    return anims;
end

return Blood;