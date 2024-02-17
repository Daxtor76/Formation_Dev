local _Entity = require("entities/_Entity");

Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    local tmpHero = _Entity:New("Hero", "player", "enemy");
    print("Création d'une instance de "..tmpHero.name);
    setmetatable(tmpHero, {__index = Hero});

    -- Inner
    tmpHero.position = Vector.New(x, y);
    tmpHero.width = 24;
    tmpHero.height = 24;
    tmpHero.pivotX = tmpHero.width * 0.5;
    tmpHero.pivotY = tmpHero.height * 0.5;

    -- Behaviour
    tmpHero.collider = CollisionController.NewCollider(
        tmpHero.position.x,
        tmpHero.position.y,
        tmpHero.width,
        tmpHero.height * 1.5,
        tmpHero,
        tmpHero.tag);
    tmpHero.states["idle"] = 0;
    tmpHero.states["run"] = 1;
    tmpHero.states["hit"] = 2;
    tmpHero.states["recover"] = 3;
    tmpHero.states["die"] = 4;

    tmpHero.state = 0;
    tmpHero.speed = 150;

    tmpHero.maxlife = 5;
    tmpHero.life = tmpHero.maxlife;

    tmpHero.recoverTimer = 0.5;
    tmpHero.currentRecoverTimer = tmpHero.recoverTimer;

    tmpHero.dyingSpeed = 2;
    tmpHero.currentDyingTimer = tmpHero.dyingSpeed;

    tmpHero.level = 1;

    -- Graph
    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.crosshair = love.graphics.newImage("images/player/crosshair.png");
    tmpHero.anims = tmpHero:PopulateAnims();
    tmpHero.renderLayer = 1;

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
                --self:MoveCamera(dt);
            elseif self.state == 2 then
                self:Move(dt);
                --self:MoveCamera(dt);
                self:ChangeState("recover");
            elseif self.state == 3 then
                self:Move(dt);
                --self:MoveCamera(dt);

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
        self.collider.enabled = false;
        weapon.enabled = false;

        if self:CanDie(dt) then
            self.enabled = false;
        end
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
end

function Hero:Draw()
    -- Life gauge
    if self.life > 0 then
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", self.position.x - self.width - 5, self.position.y + self.height + 10, 60, 7);
        love.graphics.setColor(0, 255, 0, 1);
        love.graphics.rectangle("fill", self.position.x - self.width - 5, self.position.y + self.height + 10, 60 * (self.life / self.maxlife), 7);
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
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
    love.graphics.setColor(255, 255, 255, 1);
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
    local finalDirection = Vector.Normalize(directionV + directionH);
    self.position = self.position + dt * finalDirection * self.speed;
    self.collider.position.x = self.position.x - self.width * 0.5;
    self.collider.position.y = self.position.y - self.height * 0.5;

-- TO DO : Bloquer hero aux bords du terrain
-- TO DO : Eviter le flicking

    local delta = self.position - GetScreenCenterPosition();
    if delta:GetMagnitude() > scrollDist then 
        --local angle = Vector.GetAngle(delta)
        --self:Replace(GetScreenCenterPosition().x + scrollDist * math.cos(angle), GetScreenCenterPosition().y + scrollDist * math.sin(angle));
        self:MoveCamera(dt, delta); 
    end
end

function Hero:MoveCamera(dt, delta)
    if CheckCameraCollision() == "none" then
        -- Move camera offset
        local direction = delta:Normalize();
        cameraOffset = cameraOffset + dt * direction * scrollSpeed;
    end

    if CheckCameraCollision() == "left" then
        cameraOffset.x = 0
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

    local idleBottomAnim = Anim:New(self.width, self.height, 0, 3, 50/self.speed, true);
    local idleLeftAnim = Anim:New(self.width, self.height, 4, 7, 50/self.speed, true);
    local idleRightAnim = Anim:New(self.width, self.height, 8, 11, 50/self.speed, true);
    local idleTopAnim = Anim:New(self.width, self.height, 12, 15, 50/self.speed, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    local runBottomAnim = Anim:New(self.width, self.height, 16, 21, 50/self.speed, true);
    local runLeftAnim = Anim:New(self.width, self.height, 22, 27, 50/self.speed, true);
    local runRightAnim = Anim:New(self.width, self.height, 28, 33, 50/self.speed, true);
    local runTopAnim = Anim:New(self.width, self.height, 34, 39, 50/self.speed, true);
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

    local dieBottomAnim = Anim:New(self.width, self.height, 40, 42, self.dyingSpeed, false);
    local dieLeftAnim = Anim:New(self.width, self.height, 40, 42, self.dyingSpeed, false);
    local dieRightAnim = Anim:New(self.width, self.height, 40, 42, self.dyingSpeed, false);
    local dieTopAnim = Anim:New(self.width, self.height, 40, 42, self.dyingSpeed, false);
    anims[4][0] = dieLeftAnim;
    anims[4][1] = dieTopAnim;
    anims[4][2] = dieRightAnim;
    anims[4][3] = dieBottomAnim;

    return anims;
end

return Hero;