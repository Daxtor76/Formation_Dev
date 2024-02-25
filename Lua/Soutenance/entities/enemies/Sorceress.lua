local _Entity = require("entities/_Entity");
local Projectile = require("entities/projectiles/Projectile");
local SorceressChargeFX = require("entities/FXs/SorceressCharge");
local BloodFX = require("entities/FXs/Blood");
local XP = require("entities/collectibles/XP");
local LP = require("entities/collectibles/LifePot");
local Collider = require("constructors/Collider");
local Anim = require("constructors/Anim");

local Sorceress = {};
setmetatable(Sorceress, {__index = _Entity});

function Sorceress:New(x, y, speed, attackSpeed, damages, life)
    local tmpSorceress = _Entity:New("Sorceress", "enemy");
    --print("Création d'une instance de "..tmpSorceress.name);
    setmetatable(tmpSorceress, {__index = Sorceress});

    -- Inner
    tmpSorceress.position = Vector.New(x, y);
    tmpSorceress.size = Vector.New(48, 48);
    tmpSorceress.scale = Vector.New(1.5, 1.5);
    tmpSorceress.pivot = Vector.New(tmpSorceress.size.x * 0.5, tmpSorceress.size.y * 0.5);

    -- Behaviour
    tmpSorceress.collider = Collider:New(
        tmpSorceress.position - Vector.New(tmpSorceress.pivot.x * tmpSorceress.scale.x, tmpSorceress.pivot.y * tmpSorceress.scale.y),
        Vector.New(tmpSorceress.size.x * tmpSorceress.scale.x * 0.5, tmpSorceress.size.y * tmpSorceress.scale.y * 0.75),
        tmpSorceress
    );
    table.insert(collisionController.colliders, tmpSorceress.collider);

    tmpSorceress.states["idle"] = 0;
    tmpSorceress.states["run"] = 1;
    tmpSorceress.states["hit"] = 2;
    tmpSorceress.states["recover"] = 3;
    tmpSorceress.states["die"] = 4;
    tmpSorceress.states["attack"] = 5;

    tmpSorceress.state = 1;
    tmpSorceress.range = 350;
    tmpSorceress.speed = speed; --75

    tmpSorceress.attackSpeed = attackSpeed; --2.3
    tmpSorceress.isCasting = false;
    tmpSorceress.currentAttackTimer = tmpSorceress.attackSpeed;

    tmpSorceress.damages = damages; --2

    tmpSorceress.maxlife = life; --3
    tmpSorceress.life = tmpSorceress.maxlife;

    tmpSorceress.recoverTimer = 0.5;
    tmpSorceress.currentRecoverTimer = tmpSorceress.recoverTimer;

    tmpSorceress.dyingSpeed = 1;
    tmpSorceress.currentDyingTimer = tmpSorceress.dyingSpeed;

    -- Graph
    tmpSorceress.spritesheet = love.graphics.newImage("images/enemies/sorceress/sorceress_Spritesheet.png");
    tmpSorceress.anims = tmpSorceress:PopulateAnims();
    tmpSorceress.renderLayer = 6;

    tmpSorceress.chargeFX = SorceressChargeFX:New(tmpSorceress.position);
    tmpSorceress.bloodFX = BloodFX:New(tmpSorceress.position);

    table.insert(entities, tmpSorceress);

    return tmpSorceress;
end

function Sorceress:Update(dt)
    if hero:IsAlive() then
        -- Graph behaviour
        self:UpdateCharacterDirectionByTarget(hero.position, false);

        if self.position.y > hero.position.y then
            self:ChangeRenderLayer(9);
        else
            self:ChangeRenderLayer(6);
        end

        -- Behaviour
        if self.state == 1 then
            if GetDistance(self.position, hero.position) <= self.range then
                self:ChangeState("attack");
                self.isCasting = true;
            else
                self:MoveToTarget(dt, hero.position);
            end
        elseif self.state == 2 then
            self:ChangeState("recover");
        elseif self.state == 3 then
            --self:MoveToTarget(dt, hero.position);
            self.canTakeDamages = self:CanTakeDamages(dt);
            if self.canTakeDamages then
                if self.isCasting then
                    self:ChangeState("attack");
                else
                    self:ChangeState("run");
                end
            end
        elseif self.state == 4 then
            self:Die(dt);
            self:DisableChargeFX();
        elseif self.state == 5 then
            if self.isCasting then
                self:EnableChargeFX(self.position)
                self.canAttack = self:CanAttack(dt);
                if self.canAttack then
                    self:DisableChargeFX();
                    Projectile:NewFireBall(self.position.x, self.position.y, self.damages, false);
                    self.isCasting = false;
                end
            else
                self:DisableChargeFX();
                if GetDistance(self.position, hero.position) <= self.range then
                    self.isCasting = true;
                else
                    self.currentAttackTimer = self.attackSpeed;
                    self.anims[self.state][self.characterDirection]:ResetTimer();
                    self:ChangeState("run");
                end
            end
        end

        -- Animations
        self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
    end
end

function Sorceress:Draw()
    -- Life gauge
    if self.life > 0 then
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", self.position.x - 30, self.position.y + self.size.y + 17, 60, 7);
        love.graphics.setColor(0, 255, 0, 1);
        love.graphics.rectangle("fill", self.position.x - 30, self.position.y + self.size.y + 17, 60 * (self.life / self.maxlife), 7);
        love.graphics.setColor(255, 255, 255, 1);
    end

    -- Character
    if self.state == 3 then
        love.graphics.setColor(255, 0, 0, 1);
    end
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][self.characterDirection]),
        self.position.x, 
        self.position.y, 
        self.rotation, 
        self.scale.x, 
        self.scale.y, 
        self.pivot.x, 
        self.pivot.y
    );
    love.graphics.setColor(255, 255, 255, 1);

    if debugMode then self:DrawRange() end
end

function Sorceress:Die(dt)
    self.collider.enabled = false;

    if self:CanDie(dt) then
        self.enabled = false;
        enemiesCount = enemiesCount - 1;
        enemiesKilled = enemiesKilled + 1;

        local rand = love.math.random(0, 100);
        if rand < 10 then
            LP:New(self.position.x, self.position.y);
        end
        for i = 0, self.xpDropped - 1 do
            XP:New(self.position.x + love.math.random(-60, 60), self.position.y + love.math.random(-60, 60));
        end
    end
end

function Sorceress:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local runAnims = {};
    local hitAnims = {};
    local dieAnims = {};
    local attackAnims = {};
    local recoverAnims = {};
    anims[0] = idleAnims;
    anims[1] = runAnims;
    anims[2] = hitAnims;
    anims[3] = recoverAnims;
    anims[4] = dieAnims;
    anims[5] = attackAnims;

    local idleLeftAnim = Anim:New(self.size.x, self.size.y, 0, 5, 50/self.speed, true);
    local idleTopAnim = Anim:New(self.size.x, self.size.y, 6, 11, 50/self.speed, true);
    local idleRightAnim = Anim:New(self.size.x, self.size.y, 12, 17, 50/self.speed, true);
    local idleBottomAnim = Anim:New(self.size.x, self.size.y, 18, 23, 50/self.speed, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    local runLeftAnim = Anim:New(self.size.x, self.size.y, 24, 29, 50/self.speed, true);
    local runTopAnim = Anim:New(self.size.x, self.size.y, 30, 35, 50/self.speed, true);
    local runRightAnim = Anim:New(self.size.x, self.size.y, 36, 41, 50/self.speed, true);
    local runBottomAnim = Anim:New(self.size.x, self.size.y, 42, 47, 50/self.speed, true);
    anims[1][0] = runLeftAnim;
    anims[1][1] = runTopAnim;
    anims[1][2] = runRightAnim;
    anims[1][3] = runBottomAnim;
    anims[2][0] = runLeftAnim;
    anims[2][1] = runTopAnim;
    anims[2][2] = runRightAnim;
    anims[2][3] = runBottomAnim;
    anims[3][0] = runLeftAnim;
    anims[3][1] = runTopAnim;
    anims[3][2] = runRightAnim;
    anims[3][3] = runBottomAnim;

    local dieLeftAnim = Anim:New(self.size.x, self.size.y, 48, 55, self.dyingSpeed, false);
    local dieTopAnim = Anim:New(self.size.x, self.size.y, 56, 63, self.dyingSpeed, false);
    local dieRightAnim = Anim:New(self.size.x, self.size.y, 64, 71, self.dyingSpeed, false);
    local dieBottomAnim = Anim:New(self.size.x, self.size.y, 72, 79, self.dyingSpeed, false);
    anims[4][0] = dieLeftAnim;
    anims[4][1] = dieTopAnim;
    anims[4][2] = dieRightAnim;
    anims[4][3] = dieBottomAnim;

    local attackLeftAnim = Anim:New(self.size.x, self.size.y, 80, 83, self.attackSpeed, true);
    local attackTopAnim = Anim:New(self.size.x, self.size.y, 84, 87, self.attackSpeed, true);
    local attackRightAnim = Anim:New(self.size.x, self.size.y, 88, 91, self.attackSpeed, true);
    local attackBottomAnim = Anim:New(self.size.x, self.size.y, 92, 95, self.attackSpeed, true);
    anims[5][0] = attackLeftAnim;
    anims[5][1] = attackTopAnim;
    anims[5][2] = attackRightAnim;
    anims[5][3] = attackBottomAnim;

    return anims;
end

return Sorceress;