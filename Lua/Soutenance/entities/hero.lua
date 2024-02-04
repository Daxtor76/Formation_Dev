require("utils");
local _Entity = require("entities/_entity");

local Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    local tmpHero = _Entity:New("Hero");
    print("Création d'une instance de "..tmpHero.name);
    setmetatable(tmpHero, {__index = Hero});

    tmpHero.posX = x;
    tmpHero.posY = y;
    tmpHero.width = 24;
    tmpHero.height = 24;
    tmpHero.pivotX = tmpHero.width*0.5;
    tmpHero.pivotY = tmpHero.height*0.5;

    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.anims = PopulateAnims();

    return tmpHero;
end

function Hero:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][math.floor((self.characterDirection)/2)%4]),
        self.posX, 
        self.posY, 
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function Hero:UpdateCharacterDirectionByMousePos()
    local angle = math.atan2(self.posY - GetMousePos()["y"], self.posX - GetMousePos()["x"]);
    self.characterDirection = math.floor(((math.deg(angle)+360)%360)/45) + 1;
end

function Hero:UpdateMovementDirectionByKeysPressed()
    if love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) and love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) then
        self.movementDirection = 2;
    elseif love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) and love.keyboard.isDown("d") then
        self.movementDirection = 4;
    elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
        self.movementDirection = 6;
    elseif love.keyboard.isDown("s") and love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) then
        self.movementDirection = 8;
    elseif love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) then
        self.movementDirection = 1;
    elseif love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) then
        self.movementDirection = 3;
    elseif love.keyboard.isDown("d") then
        self.movementDirection = 5;
    elseif love.keyboard.isDown("s") then
        self.movementDirection = 7;
    end
end

function PopulateAnims()
    local anims = {};
    local idleAnims = {};
    local runAnims = {};
    anims[0] = idleAnims;
    anims[1] = runAnims;

    local idleBottomAnim = Anim:New(24, 24, 0, 3, 5);
    local idleLeftAnim = Anim:New(24, 24, 4, 7, 5);
    local idleRightAnim = Anim:New(24, 24, 8, 11, 5);
    local idleTopAnim = Anim:New(24, 24, 12, 15, 5);
    local runBottomAnim = Anim:New(24, 24, 16, 21, 8);
    local runLeftAnim = Anim:New(24, 24, 22, 27, 8);
    local runRightAnim = Anim:New(24, 24, 28, 33, 8);
    local runTopAnim = Anim:New(24, 24, 34, 39, 8);
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