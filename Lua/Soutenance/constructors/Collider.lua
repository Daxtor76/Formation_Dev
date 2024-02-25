local Collider = {};

function Collider:New(position, size, parent, event)
    local tmpCollider = {};
    setmetatable(tmpCollider, {__index = Collider});

    tmpCollider.position = position;
    tmpCollider.size = size;
    tmpCollider.parent = parent;
    tmpCollider.enabled = true;

    tmpCollider.callback = event;

    return tmpCollider;
end

function Collider:CheckCollision(other)
    if self.position.x < other.position.x + other.size.x and
    self.position.x + self.size.x > other.position.x and
    self.position.y < other.position.y + other.size.y and
    self.position.y + self.size.y > other.position.y then
        if self.callback ~= nil then 
            self:callback(other);
        end
    end
end

function Collider:Draw()
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle("line", self.position.x, self.position.y, self.size.x, self.size.y)
    love.graphics.setColor(1,1,1,1)
end

return Collider;