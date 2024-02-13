local _Entity = require("entities/_Entity");

local Projectile = {};
setmetatable(Projectile, {__index = _Entity});

function Projectile:New(x, y, img)
    local tmpProjectile = _Entity:New("Arrow", "projectile");
    print("Création d'une instance de "..tmpProjectile.name);
    setmetatable(tmpProjectile, {__index = Projectile});

    -- Graph
    tmpProjectile.spritesheet = love.graphics.newImage(img);
    tmpProjectile.renderLayer = 0;

    -- Inner
    tmpProjectile.position = Vector.New(x, y);
    tmpProjectile.width = tmpProjectile.spritesheet:getWidth();
    tmpProjectile.height = tmpProjectile.spritesheet:getHeight();
    tmpProjectile.pivotX = tmpProjectile.width*0.5;
    tmpProjectile.pivotY = tmpProjectile.height*0.5;

    -- Graph
    tmpProjectile.rotation = math.atan2(GetMousePos().y - weapon.position.y + cameraOffset.y, GetMousePos().x - weapon.position.x + cameraOffset.x) - math.pi*0.5;
    tmpProjectile.direction = math.atan2(GetMousePos().y - weapon.position.y + cameraOffset.y, GetMousePos().x - weapon.position.x + cameraOffset.x);

    -- Behaviour
    tmpProjectile.speed = 800;
    tmpProjectile.collider = CollisionController.NewCollider(
        tmpProjectile.position.x + cameraOffset.x,
        tmpProjectile.position.y - tmpProjectile.height * 0.5 + cameraOffset.y,
        15,
        15,
        tmpProjectile,
        tmpProjectile.tag,
        Projectile.OnHit);

    table.insert(entities, tmpProjectile);

    return tmpProjectile;
end

Projectile.OnHit = function(collider, other)
    if other.parent.tag == "enemy" then
        if other.parent.canTakeDamages then
            collider.parent:ApplyDamages(collider.parent.damages, other.parent);
        end
        collider.enabled = false;
        collider.parent.enabled = false;
    elseif other.tag == "wall" then
        print("arrow destroyed")
        collider.enabled = false;
    end
end

function Projectile:Move(dt)
    local directionV = math.sin(self.direction);
    local directionH = math.cos(self.direction);

    local finalDirection = Vector.New(directionH, directionV);
    Vector.Normalize(finalDirection);
    self.position = self.position + dt * self.speed * finalDirection;
    self.collider.position = self.position;
end

function Projectile:Update(dt)
    self:Move(dt);
end

function Projectile:Draw()
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

return Projectile;