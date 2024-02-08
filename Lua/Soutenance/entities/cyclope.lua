local _Entity = require("entities/_entity");

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

    tmpCyclope.speed = 150;

    tmpCyclope.spritesheet = love.graphics.newImage("images/enemies/Cyclope/CyclopeSpritesheet.png");
    tmpCyclope.anims = tmpCyclope:PopulateAnims();
    tmpCyclope.renderLayer = 1;

    tmpCyclope.states = {};
    tmpCyclope.states["idle"] = 0;
    tmpCyclope.states["run"] = 1;

    return tmpCyclope;
end

function Cyclope:Update(dt)
    -- Animations
    --self:UpdateAnim(dt, self.anims[self.state][math.floor((self.characterDirection)/2)%4], true);
end

function Cyclope:Draw()
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

function Cyclope:Move(dt)
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

function Cyclope:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleBottomAnim = Anim:New(self.width, self.height, 0, 3, 5, true);
    anims[0][0] = idleLeftAnim;
    anims[0][1] = idleTopAnim;
    anims[0][2] = idleRightAnim;
    anims[0][3] = idleBottomAnim;

    return anims;
end

return Cyclope;