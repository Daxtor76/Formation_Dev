local CollisionController = {};

function CollisionController:New()
    local collisionController = {};
    setmetatable(collisionController, {__index = CollisionController});

    collisionController.colliders = {};

    table.insert(controllers, collisionController);

    return collisionController;
end

function CollisionController:Update()
    for __, collider in ipairs(self.colliders) do
        for __, other in ipairs(self.colliders) do
            if collider ~= other then
                collider:CheckCollision(other);
            end
        end
    end
end

function CollisionController:DrawColliders()
    for __, collider in ipairs(self.colliders) do
        collider:Draw();
    end
end

return CollisionController;