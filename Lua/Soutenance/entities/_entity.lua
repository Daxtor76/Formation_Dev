local _Entity = {};
Anim = require("animation/Anim");

function _Entity:New(name, tag, target)
    local tmpEntity = {};
    setmetatable(tmpEntity, _Entity);

    -- Inner
    tmpEntity.name = name;
    tmpEntity.position = Vector.New(x, y);
    tmpEntity.width = 25;
    tmpEntity.height = 26;
    tmpEntity.rotation = 0;
    tmpEntity.pivotX = tmpEntity.width*0.5;
    tmpEntity.pivotY = tmpEntity.height*0.5;
    tmpEntity.scaleX = 2;
    tmpEntity.scaleY = 2;
    tmpEntity.enabled = true;
    tmpEntity.tag = tag;
    tmpEntity.target = target;

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

    -- Graph
    tmpEntity.spritesheet = nil;
    tmpEntity.anims = nil;
    tmpEntity.renderLayer = 1;
    tmpEntity.characterDirection = 0;
    tmpEntity.frame = 0;
    tmpEntity.renderLayer = 0;

    return tmpEntity;
end

function _Entity:Load()
end

function _Entity:Update()
end

function _Entity:Draw()
end

function _Entity:DrawRange()
    love.graphics.setColor(255, 0, 0, 1);
    love.graphics.circle("line", self.position.x, self.position.y, self.range);
    love.graphics.setColor(255, 255, 255, 1);
end

function _Entity:IsAlive()
    return self.life > 0;
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
        target.life = target.life - 1;
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
    return love.graphics.newQuad((animation.width * animation.from) + (animation.width * self.frame), 0, animation.width, animation.height, self.spritesheet);
end

function _Entity:UpdateAnim(deltaTime, animation)
    animation.currentTimer = animation.currentTimer - deltaTime;
    if animation.currentTimer <= 0 then
        if animation.loop then
            self.frame = (self.frame + 1)%animation.framesCount;
        else
            if self.frame < animation.framesCount - 1 then
                self.frame = self.frame + 1;
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
            angle = math.atan2(targetPosition.y - self.position.y + cameraOffset.y, targetPosition.x - self.position.x + cameraOffset.x) + math.pi * 1.25;
        else
            angle = math.atan2(targetPosition.y - self.position.y, targetPosition.x - self.position.x) + math.pi * 1.25;
        end
    end
    self.characterDirection = math.floor(ConvertRadTo360Degrees(angle)/90);
end

function _Entity:ChangeState(newState)
    self.frame = 0;
    self.state = self.states[newState];
    print("Entity goes in state "..self.state);
end

function _Entity:IsCollidingOnWalls()
    local downFacePosY = self.posY + self.height;
    local upperFacePosY = self.posY;
    local leftFacePosX = self.posX - self.width;
    local rightFacePosX = self.posX + self.width;

    if leftFacePosX < 100 then
        return 1;
    elseif upperFacePosY < 100 then
        return 2;
    elseif rightFacePosX > love.graphics.getWidth() - 100 then
        return 3;
    elseif downFacePosY > love.graphics.getHeight() - 100 then
        return 4;
    else
        return 0;
    end
end

function _Entity:Replace(newPosX, newPosY)
    self.position = Vector.New(newPosX, newPosY);
end

return _Entity;