local _Entity = require("entities/_Entity");

Cyclope = {};
setmetatable(Cyclope, {__index = _Entity});

function Cyclope:New(x, y)
    local tmpCyclope = _Entity:New("Cyclope");
    print("Création d'une instance de "..tmpCyclope.name);
    setmetatable(tmpCyclope, {__index = Cyclope});

    -- Inner
    tmpCyclope.position = Vector.New(x, y);
    tmpCyclope.width = 25;
    tmpCyclope.height = 26;
    tmpCyclope.pivotX = tmpCyclope.width*0.5;
    tmpCyclope.pivotY = tmpCyclope.height*0.5;

    -- Behaviour
    tmpCyclope.speed = 100;
    tmpCyclope.state = 1;
    tmpCyclope.range = 100;

    tmpCyclope.states = {};
    tmpCyclope.states["idle"] = 0;
    tmpCyclope.states["run"] = 1;
    tmpCyclope.states["hit"] = 2;
    tmpCyclope.states["die"] = 3;
    tmpCyclope.states["attack"] = 4;

    -- Graph
    tmpCyclope.spritesheet = love.graphics.newImage("images/enemies/Cyclope/CyclopeSpritesheet.png");
    tmpCyclope.anims = tmpCyclope:PopulateAnims();
    tmpCyclope.renderLayer = 0;

    table.insert(renderList, tmpCyclope);

    return tmpCyclope;
end

function Cyclope:Update(dt)
    -- Behaviour
    self:UpdateCharacterDirectionByTarget(hero.position, false);
    if self.state == 1 then
        -- Move
        self:Move(dt, hero.position);
        if GetDistance(self.position, hero.position) <= self.range then
            self.state = 4;
        end
    elseif self.state == 4 then
        if GetDistance(self.position, hero.position) > self.range then
            self.state = 1;
        end
    end
    
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][self.characterDirection]);
end

function Cyclope:Draw()
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

    love.graphics.setColor(255, 0, 0, 1);
    love.graphics.circle("line", self.position.x, self.position.y, self.range);
    love.graphics.setColor(255, 255, 255, 1);
end

function Cyclope:Move(dt, targetPosition)
    local angle = math.atan2(targetPosition.y - self.position.y, targetPosition.x - self.position.x);
    local directionV = math.sin(angle);
    local directionH = math.cos(angle);
    local finalDirection = Vector.New(directionH, directionV);
    
    Vector.Normalize(finalDirection);
    
    self.position = self.position + dt * self.speed * finalDirection;
end

function Cyclope:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local runAnims = {};
    local hitAnims = {};
    local dieAnims = {};
    local attackAnims = {};
    anims[0] = idleAnims;
    anims[1] = runAnims;
    anims[2] = hitAnims;
    anims[3] = dieAnims;
    anims[4] = attackAnims;

    local runLeftAnim = Anim:New(self.width, self.height, 0, 5, 7, true);
    local runTopAnim = Anim:New(self.width, self.height, 6, 11, 7, true);
    local runRightAnim = Anim:New(self.width, self.height, 12, 17, 7, true);
    local runBottomAnim = Anim:New(self.width, self.height, 18, 23, 7, true);
    anims[0][0] = runLeftAnim;
    anims[0][1] = runTopAnim;
    anims[0][2] = runRightAnim;
    anims[0][3] = runBottomAnim;
    anims[1][0] = runLeftAnim;
    anims[1][1] = runTopAnim;
    anims[1][2] = runRightAnim;
    anims[1][3] = runBottomAnim;

    local dieLeftAnim = Anim:New(self.width, self.height, 24, 29, 7, false);
    local dieTopAnim = Anim:New(self.width, self.height, 30, 35, 7, false);
    local dieRightAnim = Anim:New(self.width, self.height, 36, 41, 7, false);
    local dieBottomAnim = Anim:New(self.width, self.height, 42, 47, 7, false);
    anims[3][0] = dieLeftAnim;
    anims[3][1] = dieTopAnim;
    anims[3][2] = dieRightAnim;
    anims[3][3] = dieBottomAnim;

    local attackLeftAnim = Anim:New(self.width, self.height, 48, 53, self.attackSpeed, true);
    local attackTopAnim = Anim:New(self.width, self.height, 54, 59, self.attackSpeed, true);
    local attackRightAnim = Anim:New(self.width, self.height, 60, 65, self.attackSpeed, true);
    local attackBottomAnim = Anim:New(self.width, self.height, 66, 71, self.attackSpeed, true);
    anims[4][0] = attackLeftAnim;
    anims[4][1] = attackTopAnim;
    anims[4][2] = attackRightAnim;
    anims[4][3] = attackBottomAnim;

    return anims;
end

return Cyclope;