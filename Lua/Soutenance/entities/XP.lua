local _Entity = require("entities/_Entity");

XP = {};
setmetatable(XP, {__index = _Entity});

function XP:New(x, y)
    local tmpXP = _Entity:New("XP", "", "");
    --print("Création d'une instance de "..tmpSorceress.name);
    setmetatable(tmpXP, {__index = XP});

    -- Inner
    tmpXP.position = Vector.New(x, y);
    tmpXP.width = 32;
    tmpXP.height = 32;
    tmpXP.scaleX = 1;
    tmpXP.scaleY = 1;
    tmpXP.pivotX = tmpXP.width*0.5;
    tmpXP.pivotY = tmpXP.height*0.5;

    -- Behaviour
    tmpXP.collider = CollisionController.NewCollider(
        tmpXP.position.x,
        tmpXP.position.y,
        tmpXP.width,
        tmpXP.height,
        tmpXP,
        tmpXP.tag,
        XP.OnHit
    );

    tmpXP.states["idle"] = 0;

    tmpXP.state = 0;
    tmpXP.range = 150;
    tmpXP.speed = 200;

    -- Graph
    tmpXP.spritesheet = love.graphics.newImage("images/collectibles/star_Spritesheet.png");
    tmpXP.anims = tmpXP:PopulateAnims();
    tmpXP.renderLayer = 0;

    table.insert(entities, tmpXP);

    return tmpXP;
end

function XP:Update(dt)
    local distanceToHero = self.position - hero.position;
    if distanceToHero:GetMagnitude() < self.range then 
        self:MoveToTarget(dt, hero.position);
    end
    -- Animations
    self:UpdateAnim(dt, self.anims[self.state][0]);
end

function XP:Draw()
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

    if debugMode then self:DrawRange() end
end

XP.OnHit = function(collider, other)
    if other.parent.tag == "player" then
        collider.enabled = false;
        collider.parent.enabled = false;
        other.parent:WinXP(1);
    end
end

function XP:PopulateAnims()
    local anims = {};
    local idleAnims = {};
    anims[0] = idleAnims;

    local idleAnim = Anim:New(self.width, self.height, 0, 12, 50/self.speed, true);
    anims[0][0] = idleAnim;

    return anims;
end

return XP;