local _Entity = require("entities/_Entity");
local Projectile = require("entities/Projectile");

Sorceress = {};
setmetatable(Sorceress, {__index = _Entity});

function Sorceress:New(x, y)
    local tmpSorceress = _Entity:New("Cyclope", "enemy", "player");
    print("Création d'une instance de "..tmpSorceress.name);
    setmetatable(tmpSorceress, {__index = Sorceress});

    -- Inner
    tmpSorceress.position = Vector.New(x, y);
    tmpSorceress.width = 48;
    tmpSorceress.height = 48;
    tmpSorceress.scaleX = 1.5;
    tmpSorceress.scaleY = 1.5;
    tmpSorceress.pivotX = tmpSorceress.width*0.5;
    tmpSorceress.pivotY = tmpSorceress.height*0.5;

    -- Behaviour
    tmpSorceress.collider = CollisionController.NewCollider(
        tmpSorceress.position.x - tmpSorceress.width * 0.5 + cameraOffset.x,
        tmpSorceress.position.y - tmpSorceress.height * 0.5 + cameraOffset.y,
        tmpSorceress.width * 0.75,
        tmpSorceress.height,
        tmpSorceress,
        tmpSorceress.tag
    );

    tmpSorceress.states["idle"] = 0;
    tmpSorceress.states["run"] = 1;
    tmpSorceress.states["hit"] = 2;
    tmpSorceress.states["recover"] = 3;
    tmpSorceress.states["die"] = 4;
    tmpSorceress.states["attack"] = 5;

    tmpSorceress.state = 1;
    tmpSorceress.range = 350;
    tmpSorceress.speed = 75;

    tmpSorceress.attackSpeed = 2.3;
    tmpSorceress.isCasting = false;
    tmpSorceress.currentAttackTimer = tmpSorceress.attackSpeed;

    tmpSorceress.damages = 3;

    tmpSorceress.maxlife = 2;
    tmpSorceress.life = tmpSorceress.maxlife;

    tmpSorceress.recoverTimer = 0.5;
    tmpSorceress.currentRecoverTimer = tmpSorceress.recoverTimer;

    tmpSorceress.dyingSpeed = 1;
    tmpSorceress.currentDyingTimer = tmpSorceress.dyingSpeed;

    -- Graph
    tmpSorceress.spritesheet = love.graphics.newImage("images/enemies/Sorceress/sorceress_Spritesheet.png");
    tmpSorceress.anims = tmpSorceress:PopulateAnims();
    tmpSorceress.renderLayer = 0;

    table.insert(entities, tmpSorceress);

    return tmpSorceress;
end

function Sorceress:Update(dt)
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
                self.isCasting = true;
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
            if self.isCasting then
                self.canAttack = self:CanAttack(dt);
                if self.canAttack then
                    Projectile:NewFireBall(self.position.x, self.position.y, self.tag, self.target, self.damages);
                    self.isCasting = false;
                end
            else
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
        love.graphics.rectangle("fill", self.position.x - self.width * 0.7, self.position.y + self.height * 0.6, 60, 7);
        love.graphics.setColor(0, 255, 0, 1);
        love.graphics.rectangle("fill", self.position.x - self.width * 0.7, self.position.y + self.height * 0.6, 60 * (self.life / self.maxlife), 7);
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

    local idleLeftAnim = Anim:New(self.width, self.height, 0, 5, 50/self.speed, true);
    local idleTopAnim = Anim:New(self.width, self.height, 6, 11, 50/self.speed, true);
    local idleRightAnim = Anim:New(self.width, self.height, 12, 17, 50/self.speed, true);
    local idleBottomAnim = Anim:New(self.width, self.height, 18, 23, 50/self.speed, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    local runLeftAnim = Anim:New(self.width, self.height, 24, 29, 50/self.speed, true);
    local runTopAnim = Anim:New(self.width, self.height, 30, 35, 50/self.speed, true);
    local runRightAnim = Anim:New(self.width, self.height, 36, 41, 50/self.speed, true);
    local runBottomAnim = Anim:New(self.width, self.height, 42, 47, 50/self.speed, true);
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

    local dieLeftAnim = Anim:New(self.width, self.height, 48, 55, self.dyingSpeed, false);
    local dieTopAnim = Anim:New(self.width, self.height, 56, 63, self.dyingSpeed, false);
    local dieRightAnim = Anim:New(self.width, self.height, 64, 71, self.dyingSpeed, false);
    local dieBottomAnim = Anim:New(self.width, self.height, 72, 79, self.dyingSpeed, false);
    anims[4][0] = dieLeftAnim;
    anims[4][1] = dieTopAnim;
    anims[4][2] = dieRightAnim;
    anims[4][3] = dieBottomAnim;

    local attackLeftAnim = Anim:New(self.width, self.height, 80, 83, self.attackSpeed, true);
    local attackTopAnim = Anim:New(self.width, self.height, 84, 87, self.attackSpeed, true);
    local attackRightAnim = Anim:New(self.width, self.height, 88, 91, self.attackSpeed, true);
    local attackBottomAnim = Anim:New(self.width, self.height, 92, 95, self.attackSpeed, true);
    anims[5][0] = attackLeftAnim;
    anims[5][1] = attackTopAnim;
    anims[5][2] = attackRightAnim;
    anims[5][3] = attackBottomAnim;

    return anims;
end

return Sorceress;