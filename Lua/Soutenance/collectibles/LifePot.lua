local _Entity = require("entities/_Entity");

LP = {};
setmetatable(LP, {__index = _Entity});

function LP:New(x, y)
    local tmpLP = _Entity:New("LP", "");
    --print("Création d'une instance de "..tmpLP.name);
    setmetatable(tmpLP, {__index = LP});

    -- Inner
    tmpLP.position = Vector.New(x, y);
    tmpLP.width = 16;
    tmpLP.height = 16;
    tmpLP.scaleX = 2;
    tmpLP.scaleY = 2;
    tmpLP.pivotX = tmpLP.width*0.5;
    tmpLP.pivotY = tmpLP.height*0.5;

    -- Behaviour
    tmpLP.collider = CollisionController.NewCollider(
        tmpLP.position.x,
        tmpLP.position.y,
        tmpLP.width,
        tmpLP.height,
        tmpLP,
        LP.OnHit
    );

    tmpLP.states["idle"] = 0;

    tmpLP.state = 0;
    tmpLP.range = 150;
    tmpLP.speed = 170;

    -- Graph
    tmpLP.spritesheet = love.graphics.newImage("images/collectibles/lifePotion_Spritesheet.png");
    tmpLP.anims = tmpLP:PopulateAnims();
    tmpLP.renderLayer = 0;

    table.insert(entities, tmpLP);

    return tmpLP;
end

function LP:Update(dt)
    local distanceToHero = self.position - hero.position;
    if distanceToHero:GetMagnitude() < self.range then 
        self:MoveToTarget(dt, hero.position);
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function LP:Draw()
    love.graphics.draw(
        self.spritesheet,
        self:GetCurrentQuadToDisplay(self.anims[self.state][0]),
        self.position.x, 
        self.position.y, 
        self.rotation, 
        self.scaleX, 
        self.scaleY, 
        self.pivotX, 
        self.pivotY
    );

    if debugMode then self:DrawRange() end
end

LP.OnHit = function(collider, other)
    if other.parent == hero then
        collider.enabled = false;
        collider.parent.enabled = false;
        other.parent:WinLife(2);
    end
end

function LP:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 7, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return LP;