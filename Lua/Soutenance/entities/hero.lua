require("utils");
local _Entity = require("entities/_entity");

local Hero = {};
setmetatable(Hero, {__index = _Entity});

function Hero:New(x, y)
    print("Création d'une instance de Hero");
    local tmpHero = _Entity:New();
    setmetatable(tmpHero, {__index = Hero});

    tmpHero.posX = x;
    tmpHero.posY = y;

    tmpHero.spritesheet = love.graphics.newImage("images/player/character.png");
    tmpHero.anims = PopulateAnims();

    return tmpHero;
end

function Hero:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(),
        self.posX, 
        self.posY, 
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        0, 
        0
    );
end

function PopulateAnims()
    local anims = {};
    local idleAnim = Anim:New(24, 30, 0, 2, 10);
    anims[0] = idleAnim;

    return anims;
end

function Hero:GetCurrentQuadToDisplay()
    local sprite = self.anims[self.state];
    return love.graphics.newQuad((sprite.width * sprite.from) + (sprite.width * self.frame), 0, sprite.width, sprite.height, self.spritesheet);
end

function Hero:UpdateAnim(deltaTime)
    self.floatFrame = (self.floatFrame + self.anims[self.state].speed * deltaTime)%(self.anims[self.state].to - self.anims[self.state].from + 1);
    self.frame = math.floor(self.floatFrame);
end

function Hero:IsAnimOver(deltaTime)
    local animTimer = (self.floatFrame + self.anims[self.state].speed * deltaTime)
    return math.ceil(animTimer) > (self.anims[self.state].to - self.anims[self.state].from + 1);
end

return Hero;