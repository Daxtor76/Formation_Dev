local gameScene = SceneController.NewScene("Game");
local CollisionController = require("controllers/gameControllers/CollisionController");
local WavesController = require("controllers/gameControllers/WavesController");
local ArenaController = require("controllers/gameControllers/ArenaController");

local Hero = require("entities/player/Hero");
local Bow = require("entities/player/Bow");

local arenaBounds = nil;
    
gameScene.Load = function()
    buttons = {};

    defeat = false;
    isPaused = false;
    gameTime = 0;
    enemiesKilled = 0;
    enemiesCount = 0;
    
    entities = {};
    controllers = {};

    arena = ArenaController:New("images/background/TX Tileset Grass.png", 5, 5);
    wavesController = WavesController:New();

    cameraOffset = Vector.New(arena.size.x * 0.5 - screenWidth * 0.5, arena.size.y * 0.5 - screenHeight * 0.5);
    shake = Vector.New(0, 0);

    hero = Hero:New(GetScreenCenterPosition().x, GetScreenCenterPosition().y);
    weapon = Bow:New(hero.position.x, hero.position.y);

    arenaBounds = {};
    arenaBounds[1] = CollisionController.NewCollider(Vector.New(0, 0), Vector.New(arena.size.x * arena.grid.x, 1), "wall");
    arenaBounds[2] = CollisionController.NewCollider(Vector.New(0, arena.size.y), Vector.New(arena.size.x * arena.grid.x, 1), "wall");
    arenaBounds[3] = CollisionController.NewCollider(Vector.New(0, 0), Vector.New(1, arena.size.y * arena.grid.y), "wall");
    arenaBounds[4] = CollisionController.NewCollider(Vector.New(arena.size.x, 0), Vector.New(1, arena.size.y * arena.grid.y), "wall");
end

gameScene.Update = function(dt)
    gameScene.CleanLists();
    if isPaused == false then
        -- Entities
        for __, value in ipairs(entities) do
            if value.active then
                value:Update(dt);
            end
        end
    
        if gameScene.CheckVictory() == false and gameScene.CheckDefeat() == false then
            wavesController:UpdateWave(dt);
            CollisionController.CheckCollisions();
            gameScene.UpdateGameTime(dt);
            gameScene.UpdateScreenShakeTimer(dt);
        elseif gameScene.CheckVictory() or gameScene.CheckDefeat() then
            SceneController.LoadSceneAdditive("GameOver");
            SceneController.SetCurrentScene("GameOver");
        end
    else
        if #buttons == 0 then
            for i = 1, 3 do
                local rand = love.math.random(1, #hero.upgrades);
                local upgrade = hero.upgrades[rand];
                buttons[i] = Button:New(screenWidth * 0.25 * i, screenHeight * 0.5, 110, 50, upgrade.label, upgrade.onSelect);
            end
        else
            gameScene.Checkbuttons();
        end
    end

    if love.keyboard.isDown(love.keyboard.getScancodeFromKey("space")) then
        debugMode = true;
    else
        debugMode = false;
    end
end

gameScene.Draw = function()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x + shake.x, -cameraOffset.y + shake.y);
    -- Draw in World position
    -- BG
    arena:DrawBackground();

    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 10 do
        for __, value in ipairs(entities) do
            if value.renderLayer == y then
                if value.active then
                    value:Draw();
                end
            end
        end
    end
    if debugMode then 
        CollisionController.DrawColliders(); 
        love.graphics.rectangle("fill", GetScreenCenterPosition().x, GetScreenCenterPosition().y, 5, 5);
        love.graphics.circle("line", hero.position.x, hero.position.y, hero.scrollDist);
        arena:DrawSpawnPoints();
    end
    love.graphics.pop();

    -- Draw in Screen position
    hero:DrawOnScreen();

    if isPaused then
        gameScene.Drawbuttons();
        ReplaceMouseCrosshair(true);
    else
        ReplaceMouseCrosshair(false, hero.crosshair);
    end
    love.graphics.print("Wave: "..WavesController.waveCounter, 0, 10);
    love.graphics.print("Enemies alive: "..enemiesCount, 0, 25);

    if debugMode then 
        love.graphics.print("XP: "..hero.xp, 0, 40);
    end
end

gameScene.Unload = function()
    buttons = nil;
    hero = nil;
    weapon = nil;
    arena = nil;
    cameraOffset = nil;
    arenaBounds = nil;
    enemiesCount = nil;
    wavesController = nil;

    for __, value in ipairs(entities) do
        if value.collider ~= nil then
            value.collider.enabled = false;
        end
        value.enabled = false;
    end
    gameScene.CleanLists();
    entities = nil;
end

gameScene.Checkbuttons = function()
    for __, value in ipairs(buttons) do
        if value:CheckHover() then
            if value:CheckClick() then
                value:applyButtonEffect();
            end
        end
    end
end

gameScene.Drawbuttons = function()
    for __, value in ipairs(buttons) do
        value:Draw();
    end
end

gameScene.UpdateScreenShakeTimer = function(dt)
    if screenShakeTimer > 0 then
        ScreenShake(3);
    end
    screenShakeTimer = Clamp(screenShakeTimer, 0, 100) - dt;
end

gameScene.UpdateGameTime = function(dt)
    gameTime = gameTime + dt;
end

gameScene.CheckVictory = function()
    return WavesController.isOver and enemiesCount == 0;
end

gameScene.CheckDefeat = function()
    return defeat;
end

gameScene.CleanLists = function()
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

return gameScene;