local _Entity = require("entities/_Entity");
local Projectile = require("entities/Projectile");
local HeroCharge = require("FXs/HeroCharge");

local Bow = {};
setmetatable(Bow, {__index = _Entity});

function Bow:New(x, y)
    local tmpWeapon = _Entity:New("Weapon", "player", "enemy");
    --print("Création d'une instance de "..tmpWeapon.name);
    setmetatable(tmpWeapon, {__index = Bow});

    -- Inner
    tmpWeapon.position = Vector.New(x, y);
    tmpWeapon.width = 48;
    tmpWeapon.height = 48;
    tmpWeapon.pivotX = tmpWeapon.width * 0.5;
    tmpWeapon.pivotY = tmpWeapon.height * 0.5;
    
    -- Behaviour
    tmpWeapon.states["idle"] = 0;
    tmpWeapon.states["charge"] = 1;
    tmpWeapon.states["shoot"] = 2;
    tmpWeapon.states["reload"] = 3;

    tmpWeapon.chargeTimer = 0.4;
    tmpWeapon.chargeCurrentTimer = tmpWeapon.chargeTimer;

    tmpWeapon.damages = 1;

    tmpWeapon.reloadSpeed = 0.5;
    tmpWeapon.currentReloadTimer = tmpWeapon.reloadSpeed;

    -- Graph
    tmpWeapon.spritesheet = love.graphics.newImage("images/player/bow.png");
    tmpWeapon.anims = tmpWeapon:PopulateAnims();
    tmpWeapon.renderLayer = 8;

    tmpWeapon.chargeFX = HeroCharge:New(hero.position.x, hero.position.y + hero.height * 0.5);

    table.insert(entities, tmpWeapon);

    return tmpWeapon;
end

function Bow:Update(dt)
    -- Weapon Controls
    weapon:Replace(hero.position.x, hero.position.y);

    if GetMousePos().y + cameraOffset.y > hero.position.y then
        self:ChangeRenderLayer(10);
    else
        self:ChangeRenderLayer(8);
    end

        -- Weapon states machine
    if love.mouse.isDown(1) then
        if self.state == 0 then
            self:ChangeState("charge");
        elseif self.state == 1 then
            self.canShoot = self:CanShoot(dt);
            self:EnableChargeFX(dt);
        elseif self.state == 3 then
            self.canReload = self:CanReload(dt);
            if self.canReload then
                self:ChangeState("idle");
            end
        end
    else
        if self.state == 1 and self.canShoot then
            self:ResetChargeTimer();
            Projectile:NewArrow(self.position.x, self.position.y, self.tag, self.target, self.damages);
            self:ChangeState("shoot");
            self:DisableChargeFX();
        elseif self.state == 1 and self.canShoot == false then
            self:ResetChargeTimer();
            self:ChangeState("idle");
            self:DisableChargeFX();
        elseif self.state == 2 then
            if self:IsWaiting(dt, 0.2) then
                self:ChangeState("reload");
            end
        elseif self.state == 3 then
            self.canReload = self:CanReload(dt);
            if self.canReload then
                self:ChangeState("idle");
            end
        end
    end 

    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function Bow:Draw()
    local delta = GetMousePos() - self.position + cameraOffset;
    local angle = delta:GetAngle() - math.pi*0.5;
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

function Bow:EnableChargeFX(dt)
    self.chargeFX.active = true;
    self.chargeFX:UpdateAnim(dt, self.chargeFX.anims[self.chargeFX.state][0]);
end

function Bow:DisableChargeFX()
    self.chargeFX.active = false;
    self.chargeFX:ResetAnim(self.chargeFX.anims[self.chargeFX.state][0]);
end

function Bow:CanShoot(dt)
    if self.chargeCurrentTimer > 0 then
        self.chargeCurrentTimer = self.chargeCurrentTimer - dt;
    end
    return self.chargeCurrentTimer <= 0;
end

function Bow:ResetChargeTimer()
    self.chargeCurrentTimer = self.chargeTimer;
end

function Bow:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local chargeAnims = {};
    local shootAnims = {};
    local reloadAnims = {};
    anims[0] = idleAnims;
    anims[1] = chargeAnims;
    anims[2] = shootAnims;
    anims[3] = reloadAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 0, 1, true);
    local chargeAnim = Anim:New(self.width, self.height, 1, 3, self.chargeTimer, false);
    local shootAnim = Anim:New(self.width, self.height, 4, 4, 2, false);
    local reloadAnim = Anim:New(self.width, self.height, 5, 5, self.reloadSpeed, false);
    anims[0][0] = idleAnim;
    anims[1][0] = chargeAnim;
    anims[2][0] = shootAnim;
    anims[3][0] = reloadAnim;

    return anims;
end

return Bow;