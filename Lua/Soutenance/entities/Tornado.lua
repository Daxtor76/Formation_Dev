local _Entity = require("entities/_Entity");

local Tornado = {};
setmetatable(Tornado, {__index = _Entity});

function Tornado:New(x, y, damages, initialAngle)
    local tmpTornado = _Entity:New("Tornado", "playerProjectile");
    --print("Création d'une instance de "..tmpTornado.name);
    setmetatable(tmpTornado, {__index = Tornado});

    -- Inner
    tmpTornado.position = Vector.New(x, y);
    tmpTornado.width = 32;
    tmpTornado.height = 30;
    tmpTornado.pivotX = tmpTornado.width * 0.5;
    tmpTornado.pivotY = tmpTornado.height * 0.5;
    tmpTornado.angle = initialAngle;

    -- Behaviour
    tmpTornado.range = 150;
    tmpTornado.speed = 100;
    tmpTornado.collider = CollisionController.NewCollider(
        tmpTornado.position.x,
        tmpTornado.position.y,
        tmpTornado.width * tmpTornado.scaleX,
        tmpTornado.height * tmpTornado.scaleY,
        tmpTornado,
        tmpTornado.OnHit
    );
    tmpTornado.damages = damages;

    -- Graph
    tmpTornado.spritesheet = love.graphics.newImage("images/upgrades/tornado_Spritesheet.png");
    tmpTornado.anims = tmpTornado:PopulateAnims();
    tmpTornado.renderLayer = 0;

    table.insert(entities, tmpTornado);

    return tmpTornado;
end

Tornado.OnHit = function(collider, other)
    if other.parent.tag == "enemy" then
        print("coucou")
        other.parent:ApplyDamages(collider.parent.damages, other.parent);
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
        self.scaleX,
        self.scaleY,
        self.pivotX,
        self.pivotY
    );
end

function Tornado:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 4, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return Tornado;