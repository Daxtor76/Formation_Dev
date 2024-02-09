local _Entity = require("entities/_Entity");

Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    local tmpHero = _Entity:New("Hero");
    print("Création d'une instance de "..tmpHero.name);
    setmetatable(tmpHero, {__index = Hero});

    tmpHero.position = Vector.New(x, y);
    tmpHero.width = 24;
    tmpHero.height = 24;
    tmpHero.pivotX = tmpHero.width*0.5;
    tmpHero.pivotY = tmpHero.height*0.5;

    tmpHero.speed = 150;

    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.crosshair = love.graphics.newImage("images/player/crosshair.png");
    tmpHero.anims = tmpHero:PopulateAnims();
    tmpHero.renderLayer = 1;

    tmpHero.states = {};
    tmpHero.states["idle"] = 0;
    tmpHero.states["run"] = 1;

    table.insert(renderList, tmpHero);

    return tmpHero;
end

function Hero:Update(dt)
    -- Hero Controls
    hero:UpdateCharacterDirectionByMousePos();
    
        -- Hero states machine
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
        if GetDistance(self.position.x, self.position.y, screenWidth*0.5, screenHeight*0.5) > scrollDist then
            -- Move background so that the hero moves in the world
            bg.posX = bg.posX - scrollSpeed * dt * math.cos(math.atan2(self.position.y - screenHeight*0.5, self.position.x - screenWidth*0.5));
            bg.posY = bg.posY - scrollSpeed * dt * math.sin(math.atan2(self.position.y - screenHeight*0.5, self.position.x - screenWidth*0.5));
            
            -- Replace hero so that he cannot go outside of the camera bounds
            local newPosX = screenWidth*0.5 + scrollDist * math.cos(math.atan2(self.position.y - screenHeight*0.5, self.position.x - screenWidth*0.5));
            local newPosY = screenHeight*0.5 + scrollDist * math.sin(math.atan2(self.position.y - screenHeight*0.5, self.position.x - screenWidth*0.5));
            hero:Replace(newPosX, newPosY);
        end
    end

    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][math.floor((self.characterDirection)/2)%4], true);
end

function Hero:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][math.floor((self.characterDirection)/2)%4]),
        self.position.x, 
        self.position.y, 
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function Hero:UpdateCharacterDirectionByMousePos()
    local angle = math.atan2(self.position.y - GetMousePos().y, self.position.x - GetMousePos().x);
    self.characterDirection = math.floor(((math.deg(angle)+360)%360)/45) + 1;
    
    if self.characterDirection >= 1 and self.characterDirection <= 4 then
        self:ChangeRenderLayer(1);
    else
        self:ChangeRenderLayer(0);
    end
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