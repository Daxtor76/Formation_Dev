local _Entity = require("entities/_Entity");

local Projectile = {};
setmetatable(Projectile, {__index = _Entity});

function Projectile:NewArrow(x, y, tag, damages, upgraded)
    local tmpProjectile = _Entity:New("Arrow", tag);
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

function Projectile:NewFireBall(x, y, tag, damages, upgraded)
    local tmpProjectile = _Entity:New("Fireball", tag);
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
    -- if other.parent.tag ~= collider.parent.tag then
    --     if other.parent.name == "Arrow" or other.parent.name == "Fireball" then
    --         collider.enabled = false;
    --         collider.parent.enabled = false;
    --         other.enabled = false;
    --         other.parent.enabled = false;
    --     elseif other.parent.name == "Tornado" then
    --         collider.enabled = false;
    --         collider.parent.enabled = false;
    --     elseif other.parent.tag == collider.parent.target then
    --         if other.parent.canTakeDamages then
    --             collider.parent:ApplyDamages(collider.parent.damages, other.parent);
    --             StartScreenShake(0.2);
    --         end
    --         if collider.parent.isUpgraded == false then
    --             collider.enabled = false;
    --             collider.parent.enabled = false;
    --         end
    --     elseif other.tag == "wall" then
    --         collider.enabled = false;
    --         collider.parent.enabled = false;
    --     end
    -- end
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