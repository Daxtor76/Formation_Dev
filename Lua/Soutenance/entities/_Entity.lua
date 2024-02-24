local _Entity = {};

function _Entity:New(name, tag)
    local tmpEntity = {};
    setmetatable(tmpEntity, _Entity);

    -- Inner
    tmpEntity.name = name;
    tmpEntity.position = Vector.New(0, 0);
    tmpEntity.size = Vector.New(0, 0);
    tmpEntity.rotation = 0;
    tmpEntity.pivot = Vector.New(tmpEntity.size.x * 0.5, tmpEntity.size.y * 0.5);
    tmpEntity.scale = Vector.New(2, 2);
    tmpEntity.enabled = true;
    tmpEntity.tag = tag;
    tmpEntity.direction = nil;
    tmpEntity.angle = 0;

    -- Behaviour
    tmpEntity.collider = nil;

    tmpEntity.states = {};

    tmpEntity.state = 0;
    tmpEntity.range = 200;
    tmpEntity.speed = 0;

    tmpEntity.attackSpeed = 5;
    tmpEntity.currentAttackTimer = tmpEntity.attackSpeed;
    tmpEntity.canAttack = false;

    tmpEntity.chargeTimer = 0.4;
    tmpEntity.chargeCurrentTimer = tmpEntity.chargeTimer;
    tmpEntity.canShoot = false;

    tmpEntity.reloadSpeed = 1;
    tmpEntity.currentReloadTimer = tmpEntity.reloadSpeed;
    tmpEntity.canReload = false;

    tmpEntity.damages = 1;

    tmpEntity.maxlife = 2;
    tmpEntity.life = tmpEntity.maxlife;

    tmpEntity.recoverTimer = 5;
    tmpEntity.canTakeDamages = true;

    tmpEntity.dyingSpeed = 2;
    tmpEntity.currentDyingTimer = tmpEntity.dyingSpeed;

    tmpEntity.currentWaitTimer = 0;

    tmpEntity.xpDropped = 3;

    -- Graph
    tmpEntity.spritesheet = nil;
    tmpEntity.anims = nil;
    tmpEntity.renderLayer = 1;
    tmpEntity.characterDirection = 0;
    tmpEntity.frame = 0;
    tmpEntity.renderLayer = 0;
    tmpEntity.active = true;

    tmpEntity.bloodFX = nil;
    tmpEntity.chargeFX = nil;

    return tmpEntity;
end

function _Entity:Load()
end

function _Entity:Update()
end

function _Entity:Draw()
end

function _Entity:EnableBloodFX()
    self.bloodFX.active = true;
    self.bloodFX.position = self.position;
end

function _Entity:EnableChargeFX()
    self.chargeFX.active = true;
    self.chargeFX.position = self.position;
end

function _Entity:DisableChargeFX()
    self.chargeFX.active = false;
    self.chargeFX:ResetAnim(self.chargeFX.anims[self.chargeFX.state][0]);
end

function _Entity:DrawRange()
    love.graphics.setColor(255, 0, 0, 1);
    love.graphics.circle("line", self.position.x, self.position.y, self.range);
    love.graphics.setColor(255, 255, 255, 1);
end

function _Entity:Die(dt)
    self.collider.enabled = false;

    if self:CanDie(dt) then
        self.enabled = false;
    end
end

function _Entity:IsAlive()
    return self.life > 0;
end

function _Entity:WinLife(amount)
    self.life = Clamp((self.life + amount), 0, self.maxlife);
end

function _Entity:TakeDamages(damages)
    if self.canTakeDamages then
        self.life = self.life - damages;
    end

    if self.life <= 0 then
        self:ChangeState("die");
    else
        self:ChangeState("recover");
    end
end

function _Entity:ApplyDamages(damages, target)
    if target.canTakeDamages then
        target.life = target.life - damages;
    end

    if target.life <= 0 then
        target:ChangeState("die");
    else
        target:ChangeState("recover");
    end
end

function _Entity:CanTakeDamages(dt)
    self.currentRecoverTimer = self.currentRecoverTimer - dt;
    if self.currentRecoverTimer <= 0 then
        self.currentRecoverTimer = self.recoverTimer;
        return true;
    end
    return false;
end

function _Entity:CanAttack(dt)
    self.currentAttackTimer = self.currentAttackTimer - dt;
    if self.currentAttackTimer <= 0 then
        self.currentAttackTimer = self.attackSpeed;
        return true;
    end
    return false;
end

function _Entity:CanReload(dt)
    self.currentReloadTimer = self.currentReloadTimer - dt;
    if self.currentReloadTimer <= 0 then
        self.currentReloadTimer = self.reloadSpeed;
        return true;
    end
    return false;
end

function _Entity:CanDie(dt)
    self.currentDyingTimer = self.currentDyingTimer - dt;
    if self.currentDyingTimer <= 0 then
        self.currentDyingTimer = self.dyingTimer;
        return true;
    end
    return false;
end

function _Entity:IsWaiting(dt, duration)
    self.currentWaitTimer = self.currentWaitTimer + dt;
    if self.currentWaitTimer >= duration then
        self.currentWaitTimer = 0;
        return true;
    end
    return false;
end

function _Entity:GetCurrentQuadToDisplay(animation)
    return love.graphics.newQuad((animation.size.x * animation.frames.x) + (animation.size.x * self.frame), 0, animation.size.x, animation.size.y, self.spritesheet);
end

function _Entity:ResetAnim(animation)
    animation:ResetTimer();
    self.frame = 0;
end

function _Entity:UpdateAnim(deltaTime, animation)
    animation.currentTimer = animation.currentTimer - deltaTime;
    if animation.currentTimer <= 0 then
        if animation.loop then
            self.frame = (self.frame + 1)%animation.framesCount;
        else
            if self.frame < animation.framesCount - 1 then
                self.frame = self.frame + 1;
            else
                animation.isOver = true;
            end
        end
        animation.currentTimer = animation.duration / animation.framesCount;
    end
end

function _Entity:ChangeRenderLayer(newLayer)
    self.renderLayer = newLayer;
end

function _Entity:UpdateCharacterDirectionByTarget(targetPosition, useCameraOffset)
    local angle = 0;
    if targetPosition ~= nil then
        if useCameraOffset then
            local delta = targetPosition - self.position + cameraOffset;
            angle = delta:GetAngle() + math.pi * 1.25;
        else
            local delta = targetPosition - self.position;
            angle = delta:GetAngle() + math.pi * 1.25;
        end
    end
    self.characterDirection = math.floor(ConvertRadTo360Degrees(angle)/90);
end

function _Entity:ChangeState(newState)
    self.frame = 0;
    self.state = self.states[newState];
    --print("Entity goes in state "..self.state);
end

function _Entity:Move(dt)
    self.position = self.position + dt * self.speed * self.direction;
    self.collider.position = self.position - self.collider.size * 0.5;
end

function _Entity:MoveToTarget(dt, targetPosition)
    local delta = targetPosition - self.position;
    local angle = delta:GetAngle();
    self.direction = delta:Normalize();
    
    self.position = self.position + dt * self.speed * self.direction;
    self.collider.position = self.position - self.collider.size * 0.5;
end

function _Entity:MoveAroundTarget(dt, targetPosition, range)
    self.angle = (self.angle + dt * self.speed)%360;
    local direction = Vector.New(math.cos(math.rad(self.angle)), math.sin(math.rad(self.angle)));
    self.position = targetPosition + direction * range;
    self.collider.position = self.position - self.collider.size * 0.5;
end

function _Entity:Replace(newPos)
    self.position = newPos;
end

return _Entity;