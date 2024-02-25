local SpawnPoint = require("constructors/SpawnPoint");
local BGTile = require("constructors/BGTile");

local Arena = {};

function Arena:New(imgPath, gridWidth, gridHeight)
    local arena = Arena;

    arena.image = love.graphics.newImage(imgPath);
    arena.imageSize = Vector.New(arena.image:getWidth(), arena.image:getHeight());
    arena.grid = Vector.New(gridWidth, gridHeight);
    arena.tiles = arena:GenerateTiles();
    arena.size = Vector.New(arena.grid.x * arena.imageSize.x, arena.grid.y * arena.imageSize.y);
    arena.spawnPoints = arena:GenerateSpawnPoints(6);
    
    return arena;
end

function Arena:GenerateTiles()
    local tiles = {};

    for i = 0, self.grid.x * self.imageSize.x - 1, self.imageSize.x do
        for y = 0, self.grid.y * self.imageSize.y - 1, self.imageSize.y do
            local tile = BGTile:New(self.image, Vector.New(i + self.imageSize.x * 0.5, y + self.imageSize.y * 0.5), Vector.New(self.imageSize.x, self.imageSize.y), Vector.New(self.imageSize.x * 0.5, self.imageSize.y * 0.5));
            table.insert(tiles, tile);
        end
    end
    
    return tiles;
end

function Arena:GenerateSpawnPoints(amountPerTile)
    local spawnPoints = {};

    for __, value in ipairs(self.tiles) do
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