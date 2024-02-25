local _Entity = require("entities/_Entity");
local CollisionController = require("controllers/gameControllers/CollisionController");
local Anim = require("constructors/Anim");

local Tornado = {};
setmetatable(Tornado, {__index = _Entity});

function Tornado:New(x, y, damages, initialAngle)
    local tmpTornado = _Entity:New("Tornado", "playerProjectile");
    --print("Création d'une instance de "..tmpTornado.name);
    setmetatable(tmpTornado, {__index = Tornado});

    -- Inner
    tmpTornado.position = Vector.New(x, y);
    tmpTornado.size = Vector.New(32, 30);
    tmpTornado.pivot = Vector.New(tmpTornado.size.x * 0.5, tmpTornado.size.y * 0.5);
    tmpTornado.angle = initialAngle;

    -- Behaviour
    tmpTornado.range = 150;
    tmpTornado.speed = 100;
    tmpTornado.collider = CollisionController.NewCollider(
        tmpTornado.position - Vector.New(tmpTornado.pivot.x * tmpTornado.scale.x, tmpTornado.pivot.y * tmpTornado.scale.y),
        Vector.New(tmpTornado.size.x * tmpTornado.scale.x, tmpTornado.size.y * tmpTornado.scale.y),
        tmpTornado,
        tmpTornado.OnHit
    );
    tmpTornado.damages = damages;

    -- Graph
    tmpTornado.spritesheet = love.graphics.newImage("images/projectiles/tornado_Spritesheet.png");
    tmpTornado.anims = tmpTornado:PopulateAnims();
    tmpTornado.renderLayer = 0;

    table.insert(entities, tmpTornado);

    return tmpTornado;
end

Tornado.OnHit = function(collider, other)
    if other.parent.tag == "enemy" then
        other.parent:ApplyDamages(collider.parent.damages, other.parent);
        other.parent:EnableBloodFX();
        StartScreenShake(0.2);
    end
end

function Tornado:Update(dt)
    self:MoveAroundTarget(dt, hero.position, self.range);
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function Tornado:Draw()
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

function Tornado:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 4, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return Tornado;