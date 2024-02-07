local gameScene = SceneController.NewScene("Game");

gameScene.Load = function()
    local Hero = require("entities/hero");
    local Weapon = require("entities/weapon");
    
    hero = Hero:New(screenWidth*0.5, screenHeight*0.5);
    weapon = Weapon:New(hero.position.x, hero.position.y);
    
    scrollSpeed = 200;
    scrollDist = 150;
    
    renderList = {};
    renderList[0] = hero;
    renderList[1] = weapon;

    bg = {};
    bg.img = love.graphics.newImage("images/background/Texture/TX Tileset Grass.png");
    bg.posX = 0;
    bg.posY = 0;
end

gameScene.Update = function(dt)
    hero:Update(dt);
    weapon:Update(dt);
end

gameScene.Draw = function()
    -- BG
    love.graphics.draw(bg.img, bg.posX, bg.posY, 0, 10, 10);

    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 1 do
        for i=0, #renderList do
            if renderList[i].renderLayer == y then
                renderList[i]:Draw();
            end
        end
    end

    -- Crosshair
    ReplaceMouseCrosshair(hero.crosshair);
end

return gameScene;