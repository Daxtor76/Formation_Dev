local gameScene = SceneController.NewScene("Game");

gameScene.Load = function()
    require("entities/_entity");
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
    -- TODO: clean and dispatch all this in scenes updates & draws

    -- Weapon Controls
    weapon:Replace(hero.position.x, hero.position.y);

    -- Hero Controls
    hero:UpdateCharacterDirectionByMousePos();
    
    -- Hero states machine
    if (love.keyboard.isDown(love.keyboard.getScancodeFromKey("a")) or 
        love.keyboard.isDown(love.keyboard.getScancodeFromKey("w")) or 
        love.keyboard.isDown("d") or 
        love.keyboard.isDown("s")) then 
        if hero.state ~= 1 then
            hero:ChangeState("run");
        end
    else
        if hero.state ~= 0 then
            hero:ChangeState("idle");
        end
    end

    -- Hero Movement & Collision with camera bounds
    if hero.state == 1 then
        hero:Move(dt);
        if GetDistance(hero.position.x, hero.position.y, screenWidth*0.5, screenHeight*0.5) > scrollDist then
            -- Move background so that the hero moves in the world
            bg.posX = bg.posX - scrollSpeed * dt * math.cos(math.atan2(hero.position.y - screenHeight*0.5, hero.position.x - screenWidth*0.5));
            bg.posY = bg.posY - scrollSpeed * dt * math.sin(math.atan2(hero.position.y - screenHeight*0.5, hero.position.x - screenWidth*0.5));
            
            -- Replace hero so that he cannot go outside of the camera bounds
            local newHeroPosX = screenWidth*0.5 + scrollDist * math.cos(math.atan2(hero.position.y - screenHeight*0.5, hero.position.x - screenWidth*0.5));
            local newHeroPosY = screenHeight*0.5 + scrollDist * math.sin(math.atan2(hero.position.y - screenHeight*0.5, hero.position.x - screenWidth*0.5));
            hero:Replace(newHeroPosX, newHeroPosY);
        end
    end

    -- Animations
    hero:UpdateAnim(dt, hero.anims[hero.state][math.floor((hero.characterDirection)/2)%4]);
    weapon:UpdateAnim(dt, weapon.anims[weapon.state][0]);
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