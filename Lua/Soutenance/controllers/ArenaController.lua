local SpawnPoint = require("constructors/SpawnPoint");
local BGTile = require("constructors/BGTile");

local Arena = {};

function Arena:New(imgPath, gridWidth, gridHeight)
    local arena = {};
    setmetatable(arena, {__index = Arena});

    arena.grid = Vector.New(gridWidth, gridHeight);
    arena.tiles = Arena:GenerateTiles(imgPath, gridWidth, gridHeight);
    arena.size = Vector.New(gridWidth * arena.tiles[1].img:getWidth(), gridHeight * arena.tiles[1].img:getHeight());
    arena.spawnPoints = Arena:GenerateSpawnPoints(arena.tiles, 6);
    
    return arena;
end

function Arena:GenerateTiles(imgPath, gridWidth, gridHeight)
    local tiles = {};
    local image = love.graphics.newImage(imgPath);
    local imageWidth = image:getWidth();
    local imageHeight = image:getHeight();

    for i = 0, gridWidth * imageWidth - 1, imageWidth do
        for y = 0, gridHeight * imageHeight - 1, imageHeight do
            local tile = BGTile:New(image, Vector.New(i + imageWidth * 0.5, y + imageHeight * 0.5), Vector.New(imageWidth, imageHeight), Vector.New(imageWidth * 0.5, imageHeight * 0.5));
            table.insert(tiles, tile);
        end
    end
    
    return tiles;
end

function Arena:GenerateSpawnPoints(tiles, amountPerTile)
    local spawnPoints = {};

    for __, value in ipairs(tiles) do
        for i = 0, amountPerTile - 1 do
            local sp = SpawnPoint:New(Vector.New(value.position.x + love.math.random(-value.size.x * 0.5, value.size.x * 0.5), value.position.y + love.math.random(-value.size.y * 0.5, value.size.y * 0.5)));
            table.insert(spawnPoints, sp);
        end
    end

    return spawnPoints;
end

function Arena:DrawBackground()
    for __, value in ipairs(self.tiles) do
        love.graphics.draw(value.img, value.position.x, value.position.y, value.rotation, 1, 1, value.pivot.x, value.pivot.y);
    end
end

function Arena:DrawSpawnPoints()
    for __, value in ipairs(self.spawnPoints) do
        love.graphics.setColor(255, 0, 0, 1);
        love.graphics.rectangle("fill", value.position.x, value.position.y, 5, 5);
        love.graphics.setColor(255, 255, 255, 1);
    end
end

return Arena;