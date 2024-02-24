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
    tmpProjectile.width = tmpProjectile.spritesheet:getWidth();
    tmpProjectile.height = tmpProjectile.spritesheet:getHeight();
    tmpProjectile.pivotX = tmpProjectile.width * 0.5;
    tmpProjectile.pivotY = tmpProjectile.height * 0.5;

    local delta = GetMousePos() - tmpProjectile.position + cameraOffset;
    tmpProjectile.rotation = Vector.GetAngle(delta) - math.pi*0.5;
    tmpProjectile.direction = delta:Normalize();

    -- Behaviour
    tmpProjectile.speed = 800;
    tmpProjectile.collider = CollisionController.NewCollider(
        tmpProjectile.position.x + cameraOffset.x,
        tmpProjectile.position.y - tmpProjectile.height * 0.5 + cameraOffset.y,
        15,
        15,
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
    tmpProjectile.width = 35;
    tmpProjectile.height = 17;
    tmpProjectile.pivotX = tmpProjectile.width * 0.5;
    tmpProjectile.pivotY = tmpProjectile.height * 0.5;

    local delta = hero.position - tmpProjectile.position;
    tmpProjectile.rotation = Vector.GetAngle(delta);
    tmpProjectile.direction = delta:Normalize();

    -- Behaviour
    tmpProjectile.speed = 400;
    tmpProjectile.collider = CollisionController.NewCollider(
        tmpProjectile.position.x,
        tmpProjectile.position.y,
        tmpProjectile.width,
        tmpProjectile.height,
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
            other.parent:EnableBloodFX(other.parent.position);
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
            other.parent:EnableBloodFX(other.parent.position);
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
            self.scaleX,
            self.scaleY,
            self.pivotX,
            self.pivotY
        );
    else
        love.graphics.draw(
            self.spritesheet,
            self.position.x,
            self.position.y,
            self.rotation,
            self.scaleX,
            self.scaleY,
            self.pivotX,
            self.pivotY
        );
    end
end

function Projectile:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 4, 200/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return Projectile;