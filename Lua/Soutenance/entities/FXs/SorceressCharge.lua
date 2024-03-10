local _Entity = require("entities/_Entity");
local Anim = require("constructors/Anim");

local SorceressCharge = {};
setmetatable(SorceressCharge, {__index = _Entity});

function SorceressCharge:New(position)
    local tmpSorceressCharge = _Entity:New("SorceressCharge", "");
    --print("Création d'une instance de "..tmpSorceressCharge.name);
    setmetatable(tmpSorceressCharge, {__index = SorceressCharge});

    -- Inner
    tmpSorceressCharge.position = position;
    tmpSorceressCharge.size = Vector.New(64, 42);
    tmpSorceressCharge.scale = Vector.New(1, 1);
    tmpSorceressCharge.pivot = Vector.New(tmpSorceressCharge.size.x * 0.5, tmpSorceressCharge.size.y * 0.5);

    tmpSorceressCharge.states["idle"] = 0;

    tmpSorceressCharge.state = 0;

    -- Graph
    tmpSorceressCharge.spritesheet = love.graphics.newImage("images/enemies/sorceress/charge.png");
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
        self.position.y + self.size.y * 0.5,
        self.rotation, 
        self.scale.x, 
        self.scale.y, 
        self.pivot.x, 
        self.pivot.y
    );
end

function SorceressCharge:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 8, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return SorceressCharge;