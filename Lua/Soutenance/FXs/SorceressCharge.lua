local _Entity = require("entities/_Entity");
local Anim = require("animation/Anim");

local SorceressCharge = {};
setmetatable(SorceressCharge, {__index = _Entity});

function SorceressCharge:New(x, y)
    local tmpSorceressCharge = _Entity:New("SorceressCharge", "");
    --print("Création d'une instance de "..tmpSorceressCharge.name);
    setmetatable(tmpSorceressCharge, {__index = SorceressCharge});

    -- Inner
    tmpSorceressCharge.position = Vector.New(x, y);
    tmpSorceressCharge.width = 64;
    tmpSorceressCharge.height = 42;
    tmpSorceressCharge.scaleX = 1;
    tmpSorceressCharge.scaleY = 1;
    tmpSorceressCharge.pivotX = tmpSorceressCharge.width*0.5;
    tmpSorceressCharge.pivotY = tmpSorceressCharge.height*0.5;

    tmpSorceressCharge.states["idle"] = 0;

    tmpSorceressCharge.state = 0;

    -- Graph
    tmpSorceressCharge.spritesheet = love.graphics.newImage("images/enemies/Sorceress/charge.png");
    tmpSorceressCharge.anims = tmpSorceressCharge:PopulateAnims();
    tmpSorceressCharge.renderLayer = 0;
    tmpSorceressCharge.active = false;

    table.insert(entities, tmpSorceressCharge);

    return tmpSorceressCharge;
end

function SorceressCharge:Update(dt)
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function SorceressCharge:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.position.x, 
        self.position.y + self.height * 0.5,
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function SorceressCharge:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 8, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return SorceressCharge;