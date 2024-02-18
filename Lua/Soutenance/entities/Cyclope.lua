local _Entity = require("entities/_Entity");

Cyclope = {};
setmetatable(Cyclope, {__index = _Entity});

function Cyclope:New(x, y)
    local tmpCyclope = _Entity:New("Cyclope", "enemy", "player");
    --print("Création d'une instance de "..tmpCyclope.name);
    setmetatable(tmpCyclope, {__index = Cyclope});

    -- Inner
    tmpCyclope.position = Vector.New(x, y);
    tmpCyclope.width = 25;
    tmpCyclope.height = 26;
    tmpCyclope.pivotX = tmpCyclope.width * 0.5;
    tmpCyclope.pivotY = tmpCyclope.height * 0.5;

    -- Behaviour
    tmpCyclope.collider = CollisionController.NewCollider(
        tmpCyclope.position.x - tmpCyclope.width * 0.5 + cameraOffset.x,
        tmpCyclope.position.y - tmpCyclope.height * 0.5 + cameraOffset.y,
        tmpCyclope.width,
        tmpCyclope.height,
        tmpCyclope,
        tmpCyclope.tag);

    tmpCyclope.states["idle"] = 0;
    tmpCyclope.states["run"] = 1;
    tmpCyclope.states["hit"] = 2;
    tmpCyclope.states["recover"] = 3;
    tmpCyclope.states["die"] = 4;
    tmpCyclope.states["attack"] = 5;

    tmpCyclope.state = 1;
    tmpCyclope.range = 100;
    tmpCyclope.speed = 130;

    tmpCyclope.attackSpeed = 1.2;
    tmpCyclope.currentAttackTimer = tmpCyclope.attackSpeed;

    tmpCyclope.damages = 1;

    tmpCyclope.maxlife = 2;
    tmpCyclope.life = tmpCyclope.maxlife;

    tmpCyclope.recoverTimer = 0.5;
    tmpCyclope.currentRecoverTimer = tmpCyclope.recoverTimer;

    tmpCyclope.dyingSpeed = 1;
    tmpCyclope.currentDyingTimer = tmpCyclope.dyingSpeed;

    -- Graph
    tmpCyclope.spritesheet = love.graphics.newImage("images/enemies/Cyclope/cyclope_Spritesheet.png");
    tmpCyclope.anims = tmpCyclope:PopulateAnims();
    tmpCyclope.renderLayer = 0;

    table.insert(entities, tmpCyclope);

    return tmpCyclope;
end

function Cyclope:Update(dt)
    if hero:IsAlive() then
        -- Graph behaviour
        self:UpdateCharacterDirectionByTarget(hero.position, false);

        if self.position.y > hero.position.y then
            self:ChangeRenderLayer(2);
        else
            self:ChangeRenderLayer(0);
        end

        -- Behaviour
        if self.state == 1 then
            self:MoveToTarget(dt, hero.position);
            if GetDistance(self.position, hero.position) <= self.range then
                self:ChangeState("attack");
            end
        elseif self.state == 2 then
            self:ChangeState("recover");
        elseif self.state == 3 then
            self:MoveToTarget(dt, hero.position);

            self.canTakeDamages = self:CanTakeDamages(dt);
            if self.canTakeDamages then
                self:ChangeState("run");
            end
        elseif self.state == 4 then
            self.collider.enabled = false;

            if self:CanDie(dt) then
                self.enabled = false;
            end
        elseif self.state == 5 then
            if GetDistance(self.position, hero.position) <= self.range then
                self.canAttack = self:CanAttack(dt);
                if self.canAttack then
                    hero:ChangeState("hit");
                    self:ApplyDamages(self.damages, hero);
                end
            else
                self.currentAttackTimer = self.attackSpeed;
                self.anims[self.state][self.characterDirection]:ResetTimer();
                self:ChangeState("run");
            end
        end

        -- Animations
        self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
    end
end

function Cyclope:Draw()
    -- Life gauge
    if self.life > 0 then
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", self.position.x - self.width - 5, self.position.y + self.height, 60, 7);
        love.graphics.setColor(0, 255, 0, 1);
        love.graphics.rectangle("fill", self.position.x - self.width - 5, self.position.y + self.height, 60 * (self.life / self.maxlife), 7);
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

    if debugMode then self:DrawRange() end
end

function Cyclope:PopulateAnims()
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

    local runLeftAnim = Anim:New(self.width, self.height, 0, 5, 50/self.speed, true);
    local runTopAnim = Anim:New(self.width, self.height, 6, 11, 50/self.speed, true);
    local runRightAnim = Anim:New(self.width, self.height, 12, 17, 50/self.speed, true);
    local runBottomAnim = Anim:New(self.width, self.height, 18, 23, 50/self.speed, true);
    anims[0][0] = runLeftAnim;
    anims[0][1] = runTopAnim;
    anims[0][2] = runRightAnim;
    anims[0][3] = runBottomAnim;
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

    local dieLeftAnim = Anim:New(self.width, self.height, 24, 29, self.dyingSpeed, false);
    local dieTopAnim = Anim:New(self.width, self.height, 30, 35, self.dyingSpeed, false);
    local dieRightAnim = Anim:New(self.width, self.height, 36, 41, self.dyingSpeed, false);
    local dieBottomAnim = Anim:New(self.width, self.height, 42, 47, self.dyingSpeed, false);
    anims[4][0] = dieLeftAnim;
    anims[4][1] = dieTopAnim;
    anims[4][2] = dieRightAnim;
    anims[4][3] = dieBottomAnim;

    local attackLeftAnim = Anim:New(self.width, self.height, 48, 53, self.attackSpeed, true);
    local attackTopAnim = Anim:New(self.width, self.height, 54, 59, self.attackSpeed, true);
    local attackRightAnim = Anim:New(self.width, self.height, 60, 65, self.attackSpeed, true);
    local attackBottomAnim = Anim:New(self.width, self.height, 66, 71, self.attackSpeed, true);
    anims[5][0] = attackLeftAnim;
    anims[5][1] = attackTopAnim;
    anims[5][2] = attackRightAnim;
    anims[5][3] = attackBottomAnim;

    return anims;
end

return Cyclope;