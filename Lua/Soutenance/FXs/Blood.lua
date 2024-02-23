local _Entity = require("entities/_Entity");

local Blood = {};
setmetatable(Blood, {__index = _Entity});

function Blood:New(x, y)
    local tmpBlood = _Entity:New("Blood", "");
    --print("Création d'une instance de "..tmpBlood.name);
    setmetatable(tmpBlood, {__index = Blood});

    -- Inner
    tmpBlood.position = Vector.New(x, y);
    tmpBlood.width = 100;
    tmpBlood.height = 100;
    tmpBlood.scaleX = 1;
    tmpBlood.scaleY = 1;
    tmpBlood.pivotX = tmpBlood.width*0.5;
    tmpBlood.pivotY = 0;

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
        self.scaleX, 
        self.scaleY, 
        self.pivotX,
        self.pivotY
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

    local idleAnim = Anim:New(self.width, self.height, 0, 17, 0.2, false);
    anims[0][0] = idleAnim;

    return anims;
end

return Blood;