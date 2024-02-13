local _Entity = require("entities/_Entity");

local Projectile = {};
setmetatable(Projectile, {__index = _Entity});

function Projectile:New(x, y, img, rotation, direction, tag, target)
    local tmpProjectile = _Entity:New("Arrow", tag, target);
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
    tmpProjectile.rotation = rotation;
    tmpProjectile.direction = direction;

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
    if other.parent.tag == collider.parent.target then
        if other.parent.canTakeDamages then
            collider.parent:ApplyDamages(collider.parent.damages, other.parent);
        end
        collider.enabled = false;
        collider.parent.enabled = false;
    elseif other.tag == "wall" then
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

function Projectile:MoveToTarget(dt, targetPosition)
    local angle = math.atan2(targetPosition.y - self.position.y, targetPosition.x - self.position.x);
    local directionV = math.sin(angle);
    local directionH = math.cos(angle);
    local finalDirection = Vector.New(directionH, directionV);
    
    Vector.Normalize(finalDirection);
    
    self.position = self.position + dt * self.speed * finalDirection;
    self.collider.position.x = self.position.x - self.width * 0.5;
    self.collider.position.y = self.position.y - self.height * 0.5;
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