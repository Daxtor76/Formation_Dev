local gameScene = SceneController.NewScene("Game");
    
gameScene.Load = function()
    local Hero = require("entities/Hero");
    local Bow = require("entities/Bow");
    local Cyclope = require("entities/Cyclope")
    local Sorceress = require("entities/Sorceress")
    
    --renderList = {};

    entities = {};
    --enemy = Cyclope:New(50, 50);
    --enemy2 = Sorceress:New(500, 500);
    --enemy3 = Sorceress:New(400, 500);
    --enemy4 = Sorceress:New(300, 500);
    --enemy5 = Sorceress:New(200, 500);

    bg = gameScene.GenerateBackground("images/background/Texture/TX Tileset Grass.png", 10, 10);

    levelBGWidth = #bg/10 * bg[1].img:getWidth();
    levelBGHeight = #bg/10 * bg[1].img:getHeight();

    cameraOffset = Vector.New(levelBGWidth * 0.5 - screenWidth * 0.5, levelBGHeight * 0.5 - screenHeight * 0.5);

    hero = Hero:New(GetScreenCenterPosition().x, GetScreenCenterPosition().y);
    weapon = Bow:New(hero.position.x, hero.position.y);
    
    scrollSpeed = 200;
    scrollDist = 150;

    screenBounds = {};
    screenBounds[0] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[1] = CollisionController.NewCollider(0, 0, screenWidth, 1, "", "wall");
    screenBounds[2] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");
    screenBounds[3] = CollisionController.NewCollider(0, 0, 1, screenHeight, "", "wall");
end

gameScene.Update = function(dt)
    -- Entities
    for key, value in pairs(entities) do
        value:Update(dt);
    end

    print(hero.position.x, hero.position.y)

    gameScene.MoveScreenBounds();
    CollisionController.CheckCollisions();
    gameScene.CleanLists();
end

gameScene.Draw = function()
    love.graphics.push()
    love.graphics.translate(-cameraOffset.x, -cameraOffset.y);
    -- BG
    gameScene.DrawBackground(bg);

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
gameScene.GenerateBackground = function(imgPath, gridWidth, gridHeight)
    local image = love.graphics.newImage(imgPath);
    local imageWidth = image:getWidth();
    local imageHeight = image:getHeight();
    local bg = {};
        for i = 0, gridWidth * imageWidth - 1, imageWidth do
            for y = 0, gridHeight * imageHeight - 1, imageHeight do
                local tile = gameScene.NewBGTile(image, Vector.New(i, y))
                table.insert(bg, tile);
                print(tile.position.x, tile.position.y)
            end
        end
    return bg;
end

gameScene.NewBGTile = function(img, pos)
    local tile = {};
    tile.img = img;
    tile.position = pos;
    tile.width = tile.img:getWidth();
    tile.height = tile.img:getHeight();
    tile.pivot = Vector.New(tile.width * 0.5, tile.height * 0.5);

    return tile;
end

gameScene.DrawBackground = function(levelBG)
    for key, value in pairs(levelBG) do
        love.graphics.draw(value.img, value.position.x, value.position.y, 0, 1, 1, value.pivot.x, value.pivot.y);
    end
end

return gameScene;