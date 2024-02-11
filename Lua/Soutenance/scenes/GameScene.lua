local gameScene = SceneController.NewScene("Game");
    

gameScene.Load = function()
    local Hero = require("entities/Hero");
    local Weapon = require("entities/Weapon");
    local Cyclope = require("entities/Cyclope")
    
    renderList = {};

    hero = Hero:New(GetScreenCenterPosition().x, GetScreenCenterPosition().y);
    weapon = Weapon:New(hero.position.x, hero.position.y);
    enemies = {};
    enemies[0] = Cyclope:New(50, 50);
    
    scrollSpeed = 200;
    scrollDist = 150;

    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;
end

gameScene.Update = function(dt)
    hero:Update(dt);
    weapon:Update(dt);
    for key, value in pairs(enemies) do
        value:Update(dt);
    end
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

return gameScene;