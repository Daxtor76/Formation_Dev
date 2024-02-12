local _Entity = require("entities/_Entity");

Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    local tmpHero = _Entity:New("Hero", "player");
    print("Création d'une instance de "..tmpHero.name);
    setmetatable(tmpHero, {__index = Hero});

    -- Inner
    tmpHero.position = Vector.New(x, y);
    tmpHero.width = 24;
    tmpHero.height = 24;
    tmpHero.pivotX = tmpHero.width*0.5;
    tmpHero.pivotY = tmpHero.height*0.5;

    -- Behaviour
    tmpHero.collider = CollisionController.NewCollider(
        tmpHero.position.x - tmpHero.width * 0.5 + cameraOffset.x,
        tmpHero.position.y - tmpHero.height * 0.5 + cameraOffset.y,
        tmpHero.width,
        tmpHero.height * 1.5,
        tmpHero,
        tmpHero.tag);
    tmpHero.speed = 150;
    tmpHero.states["idle"] = 0;
    tmpHero.states["run"] = 1;
    tmpHero.states["hit"] = 2;
    tmpHero.states["recover"] = 3;
    tmpHero.states["die"] = 4;
    tmpHero.states["attack"] = 5;

    -- Graph
    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.crosshair = love.graphics.newImage("images/player/crosshair.png");
    tmpHero.anims = tmpHero:PopulateAnims();
    tmpHero.renderLayer = 1;

    table.insert(renderList, tmpHero);

    return tmpHero;
end

function Hero:Update(dt)
    hero:UpdateCharacterDirectionByTarget(GetMousePos(), true);
    -- Hero states machine & controls
    if (love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s")) then 
        if self.state ~= 1 then
            hero:ChangeState("run");
        end
    else
        if self.state ~= 0 then
            hero:ChangeState("idle");
        end
    end

    -- Hero Movement & Collision with camera bounds
    if self.state == 1 then
        self:Move(dt);
        if GetDistance(self.position, GetScreenCenterPosition()) > scrollDist then
            -- Move camera offset
            cameraOffset.x = cameraOffset.x + scrollSpeed * dt * math.cos(math.atan2(self.position.y - GetScreenCenterPosition().y, self.position.x - GetScreenCenterPosition().x));
            cameraOffset.y = cameraOffset.y + scrollSpeed * dt * math.sin(math.atan2(self.position.y - GetScreenCenterPosition().y, self.position.x - GetScreenCenterPosition().x));
            
            -- Replace hero so that he cannot go outside of the camera bounds
            local newPosX = GetScreenCenterPosition().x + scrollDist * math.cos(math.atan2(self.position.y - GetScreenCenterPosition().y, self.position.x - GetScreenCenterPosition().x));
            local newPosY = GetScreenCenterPosition().y + scrollDist * math.sin(math.atan2(self.position.y - GetScreenCenterPosition().y, self.position.x - GetScreenCenterPosition().x));
            hero:Replace(newPosX, newPosY);
        end
    end

    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
end

function Hero:Draw()
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
    local finalDirection = directionV + directionH;
    Vector.Normalize(finalDirection);
    self.position = self.position + dt * self.speed * finalDirection;
    self.collider.position.x = self.position.x - self.width * 0.5;
    self.collider.position.y = self.position.y - self.height * 0.5;
end

function Hero:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local runAnims = {};
    anims[0] = idleAnims;
    anims[1] = runAnims;

    local idleBottomAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    local idleLeftAnim = Anim:New(self.width, self.height, 4, 7, 5, true);
    local idleRightAnim = Anim:New(self.width, self.height, 8, 11, 5, true);
    local idleTopAnim = Anim:New(self.width, self.height, 12, 15, 5, true);
    local runBottomAnim = Anim:New(self.width, self.height, 16, 21, 8, true);
    local runLeftAnim = Anim:New(self.width, self.height, 22, 27, 8, true);
    local runRightAnim = Anim:New(self.width, self.height, 28, 33, 8, true);
    local runTopAnim = Anim:New(self.width, self.height, 34, 39, 8, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;
    anims[1][0] = runLeftAnim;
    anims[1][1] = runTopAnim;
    anims[1][2] = runRightAnim;
    anims[1][3] = runBottomAnim;

    return anims;
end

return Hero;