local _Entity = require("entities/_Entity");
local CollisionController = require("collisions/CollisionController");
local Anim = require("animation/Anim");

local XP = {};
setmetatable(XP, {__index = _Entity});

function XP:New(x, y)
    local tmpXP = _Entity:New("XP", "");
    --print("Création d'une instance de "..tmpXP.name);
    setmetatable(tmpXP, {__index = XP});

    -- Inner
    tmpXP.position = Vector.New(x, y);
    tmpXP.size = Vector.New(32, 32);
    tmpXP.scale = Vector.New(1, 1);
    tmpXP.pivot = Vector.New(tmpXP.size.x * 0.5, tmpXP.size.y * 0.5);

    -- Behaviour
    tmpXP.collider = CollisionController.NewCollider(
        tmpXP.position - Vector.New(tmpXP.pivot.x * tmpXP.scale.x, tmpXP.pivot.y * tmpXP.scale.y),
        Vector.New(tmpXP.size.x * tmpXP.scale.x, tmpXP.size.y * tmpXP.scale.y),
        tmpXP,
        XP.OnHit
    );

    tmpXP.states["idle"] = 0;

    tmpXP.state = 0;
    tmpXP.range = 150;
    tmpXP.speed = 250;

    -- Graph
    tmpXP.spritesheet = love.graphics.newImage("images/collectibles/star_Spritesheet.png");
    tmpXP.anims = tmpXP:PopulateAnims();
    tmpXP.renderLayer = 0;

    table.insert(entities, tmpXP);

    return tmpXP;
end

function XP:Update(dt)
    local distanceToHero = self.position - hero.position;
    if distanceToHero:GetMagnitude() < self.range then 
        self:MoveToTarget(dt, hero.position);
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function XP:Draw()
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

    if debugMode then self:DrawRange() end
end

XP.OnHit = function(collider, other)
    if other.parent == hero then
        collider.enabled = false;
        collider.parent.enabled = false;
        other.parent:WinXP(1);
    end
end

function XP:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 12, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return XP;