local collisionController = {};
collisionController.colliders = {};

collisionController.CheckCollisions = function()
    for __, collider in ipairs(collisionController.colliders) do
        for __, other in ipairs(collisionController.colliders) do
            if collider ~= other then
                collider.CheckCollision(other);
            end
        end
    end
end

collisionController.DrawColliders = function()
    for __, collider in ipairs(collisionController.colliders) do
        collider.Draw();
    end
end

collisionController.NewCollider = function(position, size, parent, event)
    local tmpCollider = {};

    tmpCollider.position = position;
    tmpCollider.size = size;
    tmpCollider.parent = parent;
    tmpCollider.enabled = true;

    tmpCollider.callback = event;

    tmpCollider.CheckCollision = function(other)
        if tmpCollider.position.x < other.position.x + other.size.x and
        tmpCollider.position.x + tmpCollider.size.x > other.position.x and
        tmpCollider.position.y < other.position.y + other.size.y and
        tmpCollider.position.y + tmpCollider.size.y > other.position.y then
            if tmpCollider.callback ~= nil then 
                tmpCollider.callback(tmpCollider, other);
            end
        end
    end

    tmpCollider.Move = function(newPosX, newPosY)
        tmpCollider.position = Vector.New(newPosX, newPosY);
    end
    
    tmpCollider.Draw = function()
        love.graphics.setColor(0,1,0,1)
        love.graphics.rectangle("line", tmpCollider.position.x, tmpCollider.position.y, tmpCollider.size.x, tmpCollider.size.y)
        love.graphics.setColor(1,1,1,1)
    end

    table.insert(collisionController.colliders, tmpCollider);

    return tmpCollider;
end

return collisionController;