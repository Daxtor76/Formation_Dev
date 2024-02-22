local _Entity = require("entities/_Entity");

Blood = {};
setmetatable(Blood, {__index = _Entity});

function Blood:New(x, y)
    local tmpBlood = _Entity:New("Blood", "");
    --print("Création d'une instance de "..tmpBlood.name);
    setmetatable(tmpBlood, {__index = Blood});

    -- Inner
    tmpBlood.position = Vector.New(x, y);
    tmpBlood.width = 47;
    tmpBlood.height = 48;
    tmpBlood.scaleX = 1;
    tmpBlood.scaleY = 1;
    tmpBlood.pivotX = tmpBlood.width*0.5;
    tmpBlood.pivotY = 0;

    tmpBlood.states["idle"] = 0;

    tmpBlood.state = 0;

    -- Graph
    tmpBlood.spritesheet = love.graphics.newImage("images/blood_Spritesheet.png");
    tmpBlood.anims = tmpBlood:PopulateAnims();
    tmpBlood.renderLayer = 0;
    tmpBlood.active = false;

    table.insert(entities, tmpBlood);

    return tmpBlood;
end

function Blood:Update(dt)
    self:Replace(hero.position.x, hero.position.y);
    if GetMousePos().y + cameraOffset.y > hero.position.y then
        self:ChangeRenderLayer(10);
    else
        self:ChangeRenderLayer(8);
    end
end

function Blood:Draw()
    local delta = GetMousePos() - self.position + cameraOffset;
    local angle = delta:GetAngle() - math.pi*0.5;
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        hero.position.x, 
        hero.position.y, 
        angle, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );
end

function Blood:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 2, 1, true);
    anims[0][0] = idleAnim;

    return anims;
end

return Blood;