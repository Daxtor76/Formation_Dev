local _Entity = require("entities/_Entity");
local CollisionController = require("controllers/CollisionController");
local Anim = require("constructors/Anim");

local LP = {};
setmetatable(LP, {__index = _Entity});

function LP:New(x, y)
    local tmpLP = _Entity:New("LP", "");
    --print("Création d'une instance de "..tmpLP.name);
    setmetatable(tmpLP, {__index = LP});

    -- Inner
    tmpLP.position = Vector.New(x, y);
    tmpLP.size = Vector.New(16, 16);
    tmpLP.pivot = Vector.New(tmpLP.size.x * 0.5, tmpLP.size.y * 0.5);

    -- Behaviour
    tmpLP.collider = CollisionController.NewCollider(
        tmpLP.position - Vector.New(tmpLP.pivot.x * tmpLP.scale.x, tmpLP.pivot.y * tmpLP.scale.y),
        Vector.New(tmpLP.size.x * tmpLP.scale.x, tmpLP.size.y * tmpLP.scale.y),
        tmpLP,
        LP.OnHit
    );

    tmpLP.states["idle"] = 0;

    tmpLP.state = 0;
    tmpLP.range = 150;
    tmpLP.speed = 250;

    -- Graph
    tmpLP.spritesheet = love.graphics.newImage("images/collectibles/lifePotion_Spritesheet.png");
    tmpLP.anims = tmpLP:PopulateAnims();
    tmpLP.renderLayer = 0;

    table.insert(entities, tmpLP);

    return tmpLP;
end

function LP:Update(dt)
    local distanceToHero = self.position - hero.position;
    if distanceToHero:GetMagnitude() < self.range then 
        self:MoveToTarget(dt, hero.position);
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function LP:Draw()
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

LP.OnHit = function(collider, other)
    if other.parent == hero then
        collider.enabled = false;
        collider.parent.enabled = false;
        other.parent:WinLife(2);
    end
end

function LP:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 7, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return LP;