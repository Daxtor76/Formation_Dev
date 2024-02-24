local _Entity = require("entities/_Entity");
local CollisionController = require("collisions/CollisionController");
local Anim = require("animation/Anim");

local Projectile = {};
setmetatable(Projectile, {__index = _Entity});

function Projectile:NewArrow(x, y, damages, upgraded)
    local tmpProjectile = _Entity:New("Arrow", "playerProjectile");
    --print("Création d'une instance de "..tmpProjectile.name);
    setmetatable(tmpProjectile, {__index = Projectile});

    -- Graph
    tmpProjectile.spritesheet = love.graphics.newImage("images/projectiles/arrow.png");
    tmpProjectile.renderLayer = 0;

    -- Inner
    tmpProjectile.position = Vector.New(x, y);
    tmpProjectile.size = Vector.New(tmpProjectile.spritesheet:getWidth(), tmpProjectile.spritesheet:getHeight());
    tmpProjectile.pivot = Vector.New(tmpProjectile.size.x * 0.5, tmpProjectile.size.y * 0.5);

    local delta = GetMousePos() - tmpProjectile.position + cameraOffset;
    tmpProjectile.rotation = Vector.GetAngle(delta) - math.pi*0.5;
    tmpProjectile.direction = delta:Normalize();

    -- Behaviour
    tmpProjectile.speed = 800;
    tmpProjectile.collider = CollisionController.NewCollider(
        tmpProjectile.position - Vector.New(tmpProjectile.pivot.x * tmpProjectile.scale.x, tmpProjectile.pivot.y * tmpProjectile.scale.y),
        Vector.New(tmpProjectile.size.x, tmpProjectile.size.y),
        tmpProjectile,
        Projectile.OnHit
    );
    tmpProjectile.damages = damages;
    tmpProjectile.isUpgraded = upgraded;

    table.insert(entities, tmpProjectile);

    return tmpProjectile;
end

function Projectile:NewFireBall(x, y, damages, upgraded)
    local tmpProjectile = _Entity:New("Fireball", "enemyProjectile");
    --print("Création d'une instance de "..tmpProjectile.name);
    setmetatable(tmpProjectile, {__index = Projectile});

    -- Inner
    tmpProjectile.position = Vector.New(x, y);
    tmpProjectile.size = Vector.New(35, 17);
    tmpProjectile.pivot = Vector.New(tmpProjectile.size.x * 0.5, tmpProjectile.size.y * 0.5);

    local delta = hero.position - tmpProjectile.position;
    tmpProjectile.rotation = Vector.GetAngle(delta);
    tmpProjectile.direction = delta:Normalize();

    -- Behaviour
    tmpProjectile.speed = 400;
    tmpProjectile.collider = CollisionController.NewCollider(
        tmpProjectile.position - Vector.New(tmpProjectile.pivot.x * tmpProjectile.scale.x, tmpProjectile.pivot.y * tmpProjectile.scale.y),
        Vector.New(tmpProjectile.size.x * tmpProjectile.scale.x * 0.5, tmpProjectile.size.y * tmpProjectile.scale.y),
        tmpProjectile,
        Projectile.OnHit
    );
    tmpProjectile.damages = damages;
    tmpProjectile.isUpgraded = upgraded;

    -- Graph
    tmpProjectile.spritesheet = love.graphics.newImage("images/projectiles/fireball_Spritesheet.png");
    tmpProjectile.anims = tmpProjectile:PopulateAnims();
    tmpProjectile.renderLayer = 0;

    table.insert(entities, tmpProjectile);

    return tmpProjectile;
end

Projectile.OnHit = function(collider, other)
    -- If the projectile touches a wall
    if other.parent == "wall" then
        collider.enabled = false;
        collider.parent.enabled = false;
    end
    -- If the projectile touches something else
    if collider.parent.tag == "playerProjectile" then
        if other.parent.tag == "enemyProjectile" then
            collider.enabled = false;
            collider.parent.enabled = false;
        elseif other.parent.tag == "enemy" then
            other.parent:ApplyDamages(collider.parent.damages, other.parent);
            other.parent:EnableBloodFX();
            StartScreenShake(0.2);
            if collider.parent.isUpgraded == false then
                collider.enabled = false;
                collider.parent.enabled = false;
            end
        end
    elseif collider.parent.tag == "enemyProjectile" then
        if other.parent.tag == "playerProjectile" then
            collider.enabled = false;
            collider.parent.enabled = false;
        elseif other.parent.tag == "player" then
            collider.enabled = false;
            collider.parent.enabled = false;
            other.parent:ApplyDamages(collider.parent.damages, other.parent);
            other.parent:EnableBloodFX();
            StartScreenShake(0.2);
        end
    end
end

function Projectile:Update(dt)
    self:Move(dt);
    if self.name == "Fireball" then
        self:UpdateAnim(dt, self.anims[self.state][0]);
    end
end

function Projectile:Draw()
    if self.name == "Fireball" then
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
    else
        love.graphics.draw(
            self.spritesheet,
            self.position.x,
            self.position.y,
            self.rotation,
            self.scale.x,
            self.scale.y,
            self.pivot.x,
            self.pivot.y
        );
    end
end

function Projectile:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.size.x, self.size.y, 0, 4, 200/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return Projectile;