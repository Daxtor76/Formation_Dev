local gameScene = SceneController.NewScene("Game");
    

gameScene.Load = function()
    local Hero = require("entities/hero");
    local Weapon = require("entities/weapon");
    --local Cyclope = require("entities/cyclope")
    
    renderList = {};

    hero = Hero:New(screenWidth*0.5, screenHeight*0.5);
    weapon = Weapon:New(hero.position.x, hero.position.y);
    enemies = {};
    
    scrollSpeed = 200;
    scrollDist = 150;

    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;

    for key, value in pairs(renderList) do
        print(key, value)
    end
end

gameScene.Update = function(dt)
    hero:Update(dt);
    weapon:Update(dt);
end

gameScene.Draw = function()
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