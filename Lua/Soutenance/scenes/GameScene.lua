local gameScene = SceneController.NewScene("Game");
    
gameScene.Load = function()
    local Hero = require("entities/Hero");
    local Weapon = require("entities/Weapon");
    local Cyclope = require("entities/Cyclope")
    
    renderList = {};

    hero = Hero:New(GetScreenCenterPosition().x, GetScreenCenterPosition().y);
    weapon = Weapon:New(hero.position.x, hero.position.y);

    entities = {};
    entities[1] = Cyclope:New(50, 50);
    --entities[2] = Cyclope:New(800, 50);
    --entities[3] = Cyclope:New(800, 800);
    --entities[4] = Cyclope:New(50, 800);
    
    scrollSpeed = 200;
    scrollDist = 150;

    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;

    screenBounds = {};
    screenBounds[0] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[1] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[2] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");
    screenBounds[3] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");
end

gameScene.Update = function(dt)
    hero:Update(dt);
    weapon:Update(dt);
    -- Entities
    for key, value in pairs(entities) do
        value:Update(dt);
    end

    for key, value in pairs(screenBounds) do
        value.Move()
    end
    gameScene.MoveScreenBounds();
    CollisionController.CheckCollisions();

    gameScene.CleanLists();
end

gameScene.Draw = function()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y);
    -- BG
    love.graphics.draw(bg.img, bg.posX, bg.posY, 0, 10, 10);

    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 10 do
        for key, value in pairs(renderList) do
            if value.renderLayer == y then
                value:Draw();
            end
        end
    end
    CollisionController.DrawColliders();
    --love.graphics.circle("line", GetScreenCenterPosition().x, GetScreenCenterPosition().y, scrollDist);
    love.graphics.pop();

    -- Crosshair
    ReplaceMouseCrosshair(hero.crosshair);
end

gameScene.KeyPressed = function(key)
    --print(key.." pressed")
end

gameScene.MouseButtonPressed = function(button)
    --print(button.." pressed")
end

gameScene.MouseButtonReleased = function(button)
    --print(button.." released")
end

gameScene.CleanLists = function()
    for i=#renderList, 1, -1 do
        if renderList[i].enabled == false then
            table.remove(renderList, i);
        end
    end
    for i=#CollisionController.colliders, 1, -1 do
        if CollisionController.colliders[i].enabled == false then
            table.remove(CollisionController.colliders, i);
        end
    end
    for i=#entities, 1, -1 do
        if entities[i].enabled == false then
            table.remove(entities, i);
        end
    end
end

gameScene.MoveScreenBounds = function()
    screenBounds[0].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
    screenBounds[1].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y + screenHeight * 0.5);
    screenBounds[2].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
    screenBounds[3].Move(GetScreenCenterPosition().x + screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
end

return gameScene;