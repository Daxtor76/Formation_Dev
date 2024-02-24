local _Entity = require("entities/_Entity");
local Upgrade = require("upgrades/Upgrade");
local BloodFX = require("FXs/Blood");
local CollisionController = require("collisions/CollisionController");
local Anim = require("animation/Anim");

local Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    local tmpHero = _Entity:New("Hero", "player");
    --print("Création d'une instance de "..tmpHero.name);
    setmetatable(tmpHero, {__index = Hero});

    -- Inner
    tmpHero.position = Vector.New(x, y);
    tmpHero.size = Vector.New(24, 24);
    tmpHero.pivot = Vector.New(tmpHero.size.x * 0.5, tmpHero.size.y * 0.5);

    -- Behaviour
    tmpHero.collider = CollisionController.NewCollider(
        tmpHero.position - Vector.New(tmpHero.pivot.x * tmpHero.scale.x, tmpHero.pivot.y * tmpHero.scale.y),
        Vector.New(tmpHero.size.x * tmpHero.scale.x, tmpHero.size.y * tmpHero.scale.y),
        tmpHero
    );
    tmpHero.states["idle"] = 0;
    tmpHero.states["run"] = 1;
    tmpHero.states["hit"] = 2;
    tmpHero.states["recover"] = 3;
    tmpHero.states["die"] = 4;

    tmpHero.tornados = {};

    tmpHero.state = 0;
    tmpHero.speed = 150;
    
    tmpHero.scrollDist = 150;

    tmpHero.maxlife = 3;
    tmpHero.life = tmpHero.maxlife;

    tmpHero.recoverTimer = 0.5;
    tmpHero.currentRecoverTimer = tmpHero.recoverTimer;

    tmpHero.dyingSpeed = 2;
    tmpHero.currentDyingTimer = tmpHero.dyingSpeed;

    tmpHero.level = 1;
    tmpHero.xp = 0;

    tmpHero.xpThresholds = {};
    tmpHero.xpThresholds["1"] = 3;
    tmpHero.xpThresholds["2"] = 6;
    tmpHero.xpThresholds["3"] = 6;
    tmpHero.xpThresholds["4"] = 6;
    tmpHero.xpThresholds["5"] = 30;

    tmpHero.upgrades = {};
    tmpHero.upgrades[0] = Upgrade:New("Upgrade arrows", Upgrade.OnArrowUpgradeSelected);
    tmpHero.upgrades[1] = Upgrade:New("Shoot faster", Upgrade.OnFireRateUpgrade);
    tmpHero.upgrades[2] = Upgrade:New("1 more life", Upgrade.OnLifeUpgrade);
    tmpHero.upgrades[3] = Upgrade:New("1 more damage", Upgrade.OnDamageUpgrade);
    tmpHero.upgrades[4] = Upgrade:New("1 tornado", Upgrade.OnTornadoSelected);

    -- Graph
    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.crosshair = love.graphics.newImage("images/player/crosshair.png");
    tmpHero.anims = tmpHero:PopulateAnims();
    tmpHero.renderLayer = 8;

    tmpHero.bloodFX = BloodFX:New(tmpHero.position);

    table.insert(entities, tmpHero);

    return tmpHero;
end

function Hero:Update(dt)
    if self:IsAlive() then
        hero:UpdateCharacterDirectionByTarget(GetMousePos(), true);

        -- Hero Movement & Collision with camera bounds
        if love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s") then
            if self.state == 0 then
                self:ChangeState("run");
            elseif self.state == 1 then
                self:Move(dt);
            elseif self.state == 2 then
                self:Move(dt);
                self:ChangeState("recover");
            elseif self.state == 3 then
                self:Move(dt);
                self.canTakeDamages = self:CanTakeDamages(dt);
                if self.canTakeDamages then
                    self:ChangeState("idle");
                end
            end
        else
            if self.state == 1 then
                self:ChangeState("idle");
            elseif self.state == 2 then
                self:ChangeState("recover");
            elseif self.state == 3 then
                self.canTakeDamages = self:CanTakeDamages(dt);
                if self.canTakeDamages then
                    self:ChangeState("idle");
                end
            end
        end
    else
        weapon:DisableChargeFX();
        weapon:DisableChargeReadyFX();
        self:Die(dt);
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
end

function Hero:Draw()
    -- Life gauge
    if self.life > 0 then
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", self.position.x - 30, self.position.y + self.size.y, 60, 7);
        love.graphics.setColor(0, 255, 0, 1);
        love.graphics.rectangle("fill", self.position.x - 30, self.position.y + self.size.y, 60 * (self.life / self.maxlife), 7);
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
end

function Hero:DrawOnScreen()
    -- xp gauge
    if self.life > 0 then
        love.graphics.setColor(love.math.colorFromBytes(goldColor));
        love.graphics.rectangle("fill", 0, 0, screenWidth * (self.xp / self.xpThresholds[tostring(self.level)]), 7);
        love.graphics.setColor(255, 255, 255, 1);
    end
end

function Hero:LevelUp()
        self.xp = self.xp - self.xpThresholds[tostring(self.level)];
        self.level = self.level + 1;
        isPaused = true;
end

function Hero:CheckLevelUp()
    if self.xpThresholds[tostring(self.level + 1)] ~= nil then
        if self.xp >= self.xpThresholds[tostring(self.level)] then
            self:LevelUp();
        end
    end
end

function Hero:WinXP(amount)
    self.xp = self.xp + amount;
    self:CheckLevelUp();
end

function Hero:Die(dt)
    self.collider.enabled = false;
    weapon.enabled = false;

    self:DisableTornados();

    if self:CanDie(dt) then
        self.enabled = false;
        defeat = true;
    end
end

function Hero:DisableTornados()
    for key, value in pairs(self.tornados) do
        value.enabled = false;
        value.collider.enabled = false;
    end

    self.tornados = {};
end

function Hero:Move(dt)
    local directionV = Vector.New(0, 0);
    local directionH = Vector.New(0, 0);
    if love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) then
        directionV = Vector.New(0, -1);
    elseif love.keyboard.isDown("s") then
        directionV = Vector.New(0, 1);
    end

    if love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) then
        directionH = Vector.New(-1, 0);
    elseif love.keyboard.isDown("d") then
        directionH = Vector.New(1, 0);
    end
    self.direction = Vector.Normalize(directionV + directionH);
    self.position = Vector.New(
        Clamp(self.position.x, 0 + self.size.x, bg.size.x - self.size.x), 
        Clamp(self.position.y, 0 + self.size.y, bg.size.y - self.size.y)) + dt * self.direction * self.speed;
    self.collider.position = self.position - self.collider.size * 0.5;

    local delta = self.position - GetScreenCenterPosition();
    if delta:GetMagnitude() > self.scrollDist then 
        self:MoveCamera(dt, delta, self.scrollDist); 
    end
end

function Hero:MoveCamera(dt, cameraToHeroVec, radius)
    if CheckCameraCollision() == "none" then
        local cameraToHeroDirection = cameraToHeroVec:Normalize();
        local cameraToHeroLongueur = cameraToHeroVec:GetMagnitude();
        local distanceAParcourir = cameraToHeroLongueur - radius;

        cameraOffset = cameraOffset + cameraToHeroDirection * distanceAParcourir;
    end

    if CheckCameraCollision() == "left" then
        cameraOffset.x = 0;
    elseif CheckCameraCollision() == "right" then
        cameraOffset.x = bg.size.x - screenWidth;
    end

    if CheckCameraCollision() == "top" then
        cameraOffset.y = 0;
    elseif CheckCameraCollision() == "bottom" then
        cameraOffset.y = bg.size.y - screenHeight;
    end
end

function CheckCameraCollision()
    local leftPoint = GetScreenCenterPosition().x - screenWidth * 0.5;
    local rightPoint = GetScreenCenterPosition().x + screenWidth * 0.5;
    local topPoint = GetScreenCenterPosition().y - screenHeight * 0.5;
    local bottomPoint = GetScreenCenterPosition().y + screenHeight * 0.5;

    if leftPoint < 0 then
        return "left";
    elseif rightPoint > bg.size.x then
        return "right";
    end
    
    if topPoint < 0 then
        return "top";
    elseif bottomPoint > bg.size.y then
        return "bottom";
    end

    return "none";
end

function Hero:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local runAnims = {};
    local hitAnims = {};
    local recoverAnims = {};
    local dieAnims = {};
    anims[0] = idleAnims;
    anims[1] = runAnims;
    anims[2] = hitAnims;
    anims[3] = recoverAnims;
    anims[4] = dieAnims;

    local idleBottomAnim = Anim:New(self.size.x, self.size.y, 0, 3, 50/self.speed, true);
    local idleLeftAnim = Anim:New(self.size.x, self.size.y, 4, 7, 50/self.speed, true);
    local idleRightAnim = Anim:New(self.size.x, self.size.y, 8, 11, 50/self.speed, true);
    local idleTopAnim = Anim:New(self.size.x, self.size.y, 12, 15, 50/self.speed, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    local runBottomAnim = Anim:New(self.size.x, self.size.y, 16, 21, 50/self.speed, true);
    local runLeftAnim = Anim:New(self.size.x, self.size.y, 22, 27, 50/self.speed, true);
    local runRightAnim = Anim:New(self.size.x, self.size.y, 28, 33, 50/self.speed, true);
    local runTopAnim = Anim:New(self.size.x, self.size.y, 34, 39, 50/self.speed, true);
    anims[1][0] = runLeftAnim;
    anims[1][1] = runTopAnim;
    anims[1][2] = runRightAnim;
    anims[1][3] = runBottomAnim;
    anims[2][0] = runLeftAnim;
    anims[2][1] = runTopAnim;
    anims[2][2] = runRightAnim;
    anims[2][3] = runBottomAnim;
    anims[3][0] = idleLeftAnim;
    anims[3][1] = idleTopAnim;
    anims[3][2] = idleRightAnim;
    anims[3][3] = idleBottomAnim;

    local dieBottomAnim = Anim:New(self.size.x, self.size.y, 40, 42, self.dyingSpeed, false);
    local dieLeftAnim = Anim:New(self.size.x, self.size.y, 40, 42, self.dyingSpeed, false);
    local dieRightAnim = Anim:New(self.size.x, self.size.y, 40, 42, self.dyingSpeed, false);
    local dieTopAnim = Anim:New(self.size.x, self.size.y, 40, 42, self.dyingSpeed, false);
    anims[4][0] = dieLeftAnim;
    anims[4][1] = dieTopAnim;
    anims[4][2] = dieRightAnim;
    anims[4][3] = dieBottomAnim;

    return anims;
end

return Hero;