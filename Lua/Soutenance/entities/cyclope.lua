local _Entity = require("entities/_Entity");

Cyclope = {};
setmetatable(Cyclope, {__index = _Entity});

function Cyclope:New(x, y)
    local tmpCyclope = _Entity:New("Cyclope");
    print("Création d'une instance de "..tmpCyclope.name);
    setmetatable(tmpCyclope, {__index = Cyclope});

    tmpCyclope.position = Vector.New(x, y);
    tmpCyclope.width = 24;
    tmpCyclope.height = 24;
    tmpCyclope.pivotX = tmpCyclope.width*0.5;
    tmpCyclope.pivotY = tmpCyclope.height*0.5;

    tmpCyclope.speed = 100;

    tmpCyclope.spritesheet = love.graphics.newImage("images/enemies/Cyclope/CyclopeSpritesheet.png");
    tmpCyclope.anims = tmpCyclope:PopulateAnims();
    tmpCyclope.renderLayer = 0;

    tmpCyclope.states = {};
    tmpCyclope.states["idle"] = 0;
    tmpCyclope.states["run"] = 1;

    table.insert(renderList, tmpCyclope);

    return tmpCyclope;
end

function Cyclope:Update(dt)

    -- Move
    self:Move(dt, hero);
    
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][math.floor((self.characterDirection)/2)%4], true);
end

function Cyclope:Draw()
    local angle = math.atan2(self.position.y - hero.position.y, self.position.x - hero.position.x) - math.pi*0.5;
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.position.x, 
        self.position.y, 
        angle, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function Cyclope:Move(dt, target)
    local direction = math.atan2(self.position.y - target.position.y, self.position.x - target.position.x);
    local directionV = math.sin(direction);
    local directionH = math.cos(direction);
    local finalDirection = Vector.New(-directionH, -directionV);
    
    Vector.Normalize(finalDirection);
    self.position = self.position + dt * self.speed * finalDirection;
end

function Cyclope:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleLeftAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    local idleTopAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    local idleRightAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    local idleBottomAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    return anims;
end

return Cyclope;