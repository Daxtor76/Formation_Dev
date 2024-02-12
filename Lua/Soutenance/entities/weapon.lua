local _Entity = require("entities/_Entity");
local Projectile = require("entities/Projectile");

local Weapon = {};
setmetatable(Weapon, {__index = _Entity});

function Weapon:New(x, y)
    local tmpWeapon = _Entity:New("Weapon", "weapon");
    print("Création d'une instance de "..tmpWeapon.name);
    setmetatable(tmpWeapon, {__index = Weapon});

    -- Inner
    tmpWeapon.position = Vector.New(x, y);
    tmpWeapon.width = 48;
    tmpWeapon.height = 48;
    tmpWeapon.pivotX = tmpWeapon.width*0.5;
    tmpWeapon.pivotY = tmpWeapon.height*0.5;
    
    -- Behaviour
    tmpWeapon.states = {};
    tmpWeapon.states["idle"] = 0;
    tmpWeapon.states["charge"] = 1;
    tmpWeapon.states["reload"] = 2;
    tmpWeapon.states["shoot"] = 3;

    tmpWeapon.chargeTimer = 0.4;
    tmpWeapon.chargeCurrentTimer = tmpWeapon.chargeTimer;
    tmpWeapon.canShoot = false;

    -- Graph
    tmpWeapon.spritesheet = love.graphics.newImage("images/player/bow.png");
    tmpWeapon.anims = tmpWeapon:PopulateAnims();
    tmpWeapon.renderLayer = 0;

    table.insert(renderList, tmpWeapon);

    return tmpWeapon;
end

function Weapon:CanShootTimer(dt)
    if self.chargeCurrentTimer > 0 then
        self.chargeCurrentTimer = self.chargeCurrentTimer - dt;
    end
    return self.chargeCurrentTimer <= 0;
end

function Weapon:Update(dt)
    -- Weapon Controls
    weapon:Replace(hero.position.x, hero.position.y);

    if GetMousePos().y + cameraOffset.y > hero.position.y then
        self:ChangeRenderLayer(2);
    else
        self:ChangeRenderLayer(0);
    end

        -- Weapon states machine
    if love.mouse.isDown(1) then
        if self.state == 0 then
            self:ChangeState("charge");
        end
    else
        if self.state == 1 and self.canShoot then
            self.chargeCurrentTimer = self.chargeTimer;
            self:ChangeState("shoot");
        elseif self.state == 1 and self.canShoot == false then
            self.chargeCurrentTimer = self.chargeTimer;
            self:ChangeState("idle");
        end
    end 

    -- Weapon Charge & Shoot
    if self.state == 1 then
        self.canShoot = self:CanShootTimer(dt);
    elseif self.state == 2 then
        if self:IsAnimOver(dt, self.anims[self.state][0]) then
            self:ChangeState("idle");
        end
    elseif self.state == 3 then
        self.canShoot = false;
        self:ChangeState("reload");
        proj = Projectile:New(weapon.position.x, weapon.position.y, "images/player/arrow.png");
    end

    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function Weapon:Draw()
    local angle = math.atan2(GetMousePos().y - self.position.y + cameraOffset.y, GetMousePos().x - self.position.x + cameraOffset.x) - math.pi*0.5;
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        hero.position.x,
        hero.position.y,
        angle,
        self.scaleX,
        self.scaleY,
        self.pivotX,
        self.pivotY
    );
end

function Weapon:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local chargeAnims = {};
    local shootAnims = {};
    anims[0] = idleAnims;
    anims[1] = chargeAnims;
    anims[2] = shootAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 0, 1, true);
    local chargeAnim = Anim:New(self.width, self.height, 1, 3, self.attackSpeed, false);
    local shootAnims = Anim:New(self.width, self.height, 4, 5, self.attackSpeed, false);
    anims[0][0] = idleAnim;
    anims[1][0] = chargeAnim;
    anims[2][0] = shootAnims;

    return anims;
end

return Weapon;