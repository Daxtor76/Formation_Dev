local gameScene = SceneController.NewScene("Game");
    
gameScene.Load = function()
    local Hero = require("entities/Hero");
    local Bow = require("entities/Bow");
    local WavesController = require("waves/WavesController");

    entities = {};

    bg = {};
    bg.grid = Vector.New(5, 5);
    bg.tiles = gameScene.GenerateBackground("images/background/Texture/TX Tileset Grass.png", bg.grid.x, bg.grid.y);
    bg.size = Vector.New(bg.grid.x * bg.tiles[1].img:getWidth(), bg.grid.y * bg.tiles[1].img:getHeight());
    bg.spawnPoints = gameScene.GenerateSpawnPoints(6);

    cameraOffset = Vector.New(bg.size.x * 0.5 - screenWidth * 0.5, bg.size.y * 0.5 - screenHeight * 0.5);

    hero = Hero:New(GetScreenCenterPosition().x, GetScreenCenterPosition().y);
    weapon = Bow:New(hero.position.x, hero.position.y);
    
    scrollSpeed = 200;
    scrollDist = 150;

    screenBounds = {};
    screenBounds[0] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[1] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[2] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");
    screenBounds[3] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");

    WavesController.Begin();
end

gameScene.Update = function(dt)
    -- Entities
    for key, value in pairs(entities) do
        value:Update(dt);
    end

    gameScene.MoveScreenBounds();
    CollisionController.CheckCollisions();
    gameScene.CleanLists();
end

gameScene.Draw = function()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y);
    -- BG
    gameScene.DrawBackground();

    -- Render entities layer by layer (0 = the deepest)
    for y = 0, 10 do
        for key, value in pairs(entities) do
            if value.renderLayer == y then
                value:Draw();
            end
        end
    end
    if debugMode then 
        CollisionController.DrawColliders(); 
        love.graphics.circle("line", GetScreenCenterPosition().x, GetScreenCenterPosition().y, scrollDist);
        gameScene.DrawSpawnPoints();
    end
    love.graphics.pop();

    -- Crosshair
    ReplaceMouseCrosshair(hero.crosshair);
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

gameScene.MoveScreenBounds = function()
    screenBounds[0].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
    screenBounds[1].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y + screenHeight * 0.5);
    screenBounds[2].Move(GetScreenCenterPosition().x - screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
    screenBounds[3].Move(GetScreenCenterPosition().x + screenWidth * 0.5, GetScreenCenterPosition().y - screenHeight * 0.5);
end

-- BG functions
gameScene.NewBGTile = function(img, pos)
    local tile = {};
    tile.img = img;
    tile.position = pos;
    tile.width = tile.img:getWidth();
    tile.height = tile.img:getHeight();

    return tile;
end

gameScene.GenerateBackground = function(imgPath, gridWidth, gridHeight)
    local image = love.graphics.newImage(imgPath);
    local imageWidth = image:getWidth();
    local imageHeight = image:getHeight();
    local bg = {};
        for i = 0, gridWidth * imageWidth - 1, imageWidth do
            for y = 0, gridHeight * imageHeight - 1, imageHeight do
                local tile = gameScene.NewBGTile(image, Vector.New(i, y))
                table.insert(bg, tile);
            end
        end
    return bg;
end

gameScene.DrawBackground = function()
    for key, value in pairs(bg.tiles) do
        love.graphics.draw(value.img, value.position.x, value.position.y, 0, 1, 1, 0, 0);
    end
end

-- SpawnPoints
gameScene.NewSpawnPoint = function(pos)
    local spawnPoint = {};
    spawnPoint.position = pos;
    spawnPoint.used = false;

    return spawnPoint;
end

gameScene.GenerateSpawnPoints = function(amountPerTile)
    local spawnPoints = {};

    for key, value in pairs(bg.tiles) do
        for i = 0, amountPerTile - 1 do
            local sp = gameScene.NewSpawnPoint(Vector.New(love.math.random(value.position.x, value.width), love.math.random(value.position.y, value.height)));
            table.insert(spawnPoints, sp);
        end
    end

    return spawnPoints;
end

gameScene.DrawSpawnPoints = function()
    for key, value in pairs(bg.spawnPoints) do
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", value.position.x, value.position.y, 5, 5);
        love.graphics.setColor(255, 255, 255, 1);
    end
end

return gameScene;